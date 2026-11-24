---
title: Troubleshoot Azure Monitor pipeline
description: Guidance for troubleshooting issues with Azure Monitor pipeline deployment, configuration, data collection, and connectivity.
ai-usage: ai-assisted
ms.topic: troubleshooting-general
ms.date: 11/23/2026
ms.custom: references_regions, devx-track-azurecli, doc-kit-assisted
---

# Troubleshoot Azure Monitor pipeline

This article provides guidance for common issues encountered when deploying and using Azure Monitor pipeline.

## Monitor pipeline health and performance

Track the health and performance of your pipeline deployment using Azure Monitor metrics and logs.

### View metrics in the Azure portal

In the Azure portal, open your Azure Monitor pipeline resource and select **Monitoring** and then **Metrics**. The following metrics are available:

> [!IMPORTANT]
> Starting with pipeline version 1.6.1, use `exported_log_records` instead of `exporter_sent_log_records` and `log_records_failed_to_export` instead of `exporter_send_failed_log_records`. Update any queries, alerts, dashboards, or workbooks that use the previous metric names.

| Area | Metric name | Function | Description | Dimensions |
|:---|:---|:---|:---|:---|
| Pipeline process | `process_cpu_utilization` | CPU utilization | The percentage of CPU utilized by the pipeline process, normalized across all cores. | Instance ID |
| Pipeline process | `process_memory_usage` | Memory used | Total physical memory (resident set size) used by the pipeline process. | Instance ID |
| Pipeline process | `process_uptime` | Process uptime | Uptime of the pipeline process since last start. | Instance ID |
| Log ingestion | `accepted_log_records` | Logs accepted (preview) | Number of log records accepted into the pipeline. | Instance ID, Component name |
| Log ingestion | `rejected_log_records` | Logs rejected (preview) | Number of log records rejected by validation while entering the pipeline. | Instance ID, Component name |
| Data processing | `processor_input_log_records` | Processing input (preview) | Number of log records entering a configured processing step. | Instance ID, Pipeline name, Component name |
| Data processing | `processor_output_log_records` | Processing output (preview) | Number of log records leaving a configured processing step. | Instance ID, Pipeline name, Component name |
| Data processing | `processing_duration` | Processing duration (preview) | Time spent processing log records in a configured step. | Instance ID, Pipeline name, Component name |
| Data delivery | `exported_log_records` | Logs exported (preview) | Number of log records successfully sent to the destination. | Instance ID, Pipeline name, Component name |
| Data delivery | `log_records_failed_to_export` | Logs failed to export (preview) | Number of log records the pipeline couldn't deliver after exhausting its own retries, if any. The same logs might be counted more than once if an upstream retry or buffering mechanism resubmits them. A nonzero value indicates export issues but not necessarily data loss because the pipeline might still retry successfully. | Instance ID, Pipeline name, Component name |
| Data delivery | `log_records_pending_export` | Logs currently pending export (preview) | Current number of log records queued or in flight for delivery. | Instance ID, Pipeline name, Component name |
| Persistent storage | `persistent_storage_utilization` | Persistent storage utilization (preview) | Percentage of configured persistent storage currently in use. | Instance ID, Pipeline name, Component name |
| Persistent storage | `log_records_dropped_from_storage` | Logs dropped from persistent storage (preview) | Number of log records dropped from persistent storage. | Loss reason, Instance ID, Pipeline name, Component name |

### Collect and view logs
Create a [diagnostic setting in Azure Monitor](diagnostic-settings.md) to collect resource logs for the pipeline. You can send these logs to a Log Analytics workspace, a storage account, an event hub, or a partner solution. If you send logs to a Log Analytics workspace, you can query them in the `AzureMonitorPipelineLogErrors` table.


### Collect logs from cluster pods

To investigate issues not visible in the Azure portal, collect logs directly from pipeline pods on your Kubernetes cluster.

Starting with pipeline version 1.7.0, the extension includes a diagnostic collection script in the `azure-monitor-pipeline-forensics` ConfigMap. The script requires `kubectl` and `zip`. Run the following commands from a machine that has access to the cluster:

```bash
kubectl get configmap azure-monitor-pipeline-forensics \
  --namespace <namespace> \
  --output go-template='{{ index .data "azure-monitor-pipeline-forensics.sh" }}' \
  > azure-monitor-pipeline-forensics.sh

chmod +x azure-monitor-pipeline-forensics.sh
./azure-monitor-pipeline-forensics.sh -n <namespace> -p <pipeline-name>
```

The script creates `azure-monitor-pipeline-forensics.zip` in the current directory. It collects logs and diagnostic information only for the specified pipeline instance.

You can also collect individual pod logs manually.

**Retrieve pod logs:**
```bash
kubectl logs <pod-name> -n <namespace>

#Example:
kubectl logs my-pipeline -n my-ns
```

**Retrieve logs from a previous pod instance** (useful if determining why a pod crashed):
```bash
kubectl logs <pod-name> -n <namespace> --previous

# Example:
kubectl logs my-pipeline -n my-ns --previous
```

**Stream logs in real time:**
```bash
kubectl logs <pod-name> -n <namespace> -f

# Example:
kubectl logs my-pipeline -n my-ns -f
```

**Retrieve logs from all pipeline pods:**
```bash
kubectl logs -n mon -l app.kubernetes.io/name=collector -f

# Example:
kubectl logs -n mon -l app.kubernetes.io/name=collector -fs
```

These logs often contain detailed error messages that can help identify the root cause of deployment, configuration, data collection, or connectivity issues.

## No data arriving in Azure Monitor

Check the destination that corresponds to the signal:

- Send Syslog and OpenTelemetry (OTel) logs to a Log Analytics workspace. OTel logs can use the `OTelLogs` table or a custom table.
- Send OTel metrics to an Azure Monitor workspace.
- Send OTel traces to the `OTelEvents`, `OTelSpans`, and `OTelResources` tables in a Log Analytics workspace.

Work through the following checks in order to locate the source of the issue.

### Verify extension provisioning status

Confirm that the pipeline extension deployed successfully:

```bash
az k8s-extension show --name <extension-name> \
  --cluster-name <cluster-name> \
  --resource-group <resource-group> \
  --cluster-type connectedClusters \
  --query "{provisioningState:provisioningState,principalId:identity.principalId}"
```

- If the provisioning state isn't `Succeeded`, check the deployment error details in the Activity Log.
- Confirm that the extension's managed identity is available.

### Verify DCR associations

Associate both the settings DCR and dataflow DCR with the same pipeline extension.

- Create each association under the Arc connected cluster with Monitor API version `2025-05-11`.
- Set `properties.dataCollectionRuleId` to the full Azure Resource Manager resource ID of the corresponding DCR.
- Set `properties.scopeToResourceId` to the full Azure Resource Manager resource ID of the pipeline extension.
- Confirm that both associations retain the same extension scope after an update.

For commands to inspect both associations, see [Check the extension and associations](./pipeline-configure-cli.md#check-the-extension-and-associations).

### Verify ingestion permissions

The deployment automatically assigns **Monitoring Metrics Publisher** to the extension's managed identity on the dataflow DCR. The provided ARM template includes this role assignment; it isn't a separate manual setup step.

An association delivers configuration; it doesn't grant permission to send telemetry. If exports return `403`, verify that the deployment-created role assignment targets the extension's identity, not the cluster identity. Check for a failed role-assignment deployment and allow time for permission changes to propagate before retrying.

### Validate dataflow routing

Confirm that:

- The endpoint name in `dataSources.syslog[].endpointRouting` matches a reference in `references.pipelineSettingsEndpointRouting`.
- The reference's `pipelineSettingsResourceId` identifies the settings DCR.
- The named endpoint exists in `properties.pipelineSettings.endpoints`.
- The data source streams are connected to the intended destinations through `dataFlows`.
- The workspace resource ID and region are correct.
- Microsoft Sentinel is enabled if you send CEF data to `CommonSecurityLog`.

### Validate the custom table schema

```kql
// Check if the custom table exists and has expected columns
CustomTable_CL
| getschema
```

### Check receiver endpoints and network connectivity

- **Endpoint format**: Must be `host:port` (e.g., `0.0.0.0:514`). IPv6 uses `[::]:port`.
- **No port conflicts**: Two receivers cannot bind the same port. Check for `ReceiverPortConflict` errors.
- **Firewall or NSG rules**: Ensure the source (application, syslog forwarder, OTLP client) can reach the receiver endpoint on the Arc-connected Kubernetes cluster.
- **For Syslog receivers**: Verify `transportProtocol` is `"tcp"` or `"udp"` (not `"http"`), and `allowedFormats` includes the format your source sends (e.g., `syslogRfc5424`, `cefRfc3164`).

### Supported receiver types

| Type | Protocol | Example Endpoint |
|---|---|---|
| OTLP (Preview) | gRPC | `0.0.0.0:4317` |
| Syslog | TCP or UDP | `0.0.0.0:514` |

### Test connectivity from source

```bash
# For TCP syslog
nc -zv <pipeline-endpoint-ip> 514

# For OTLP gRPC
grpcurl -plaintext <pipeline-endpoint-ip>:4317 list
```

### Validate the data collection rule and endpoint

Check workspace routing and network access:

- **DCR stream name must match**: The data source's `streams` values must match the corresponding `dataFlows[].streams` values exactly.
- **DCR workspace must be correct**: Confirm that each data flow references the intended destination and that its workspace resource ID is correct.
- **DCE must be accessible**: If the deployment uses a data collection endpoint, check firewall and private endpoint configuration from the Kubernetes cluster. Also verify access to the Azure Monitor ingestion endpoints.
- **For private link setups**: Confirm the DCE is added to the Azure Monitor Private Link Scope (AMPLS) and DNS resolves correctly.

### Check DCR ingestion health

```kql
_LogOperation
| where Category == "Ingestion"
| where TimeGenerated > ago(1h)
| where Detail has "error" or Level == "Warning"
```

### Check for ingestion limits with the daily cap

Log Analytics enforces a daily ingestion cap. Once hit, **all data collection stops** for the rest of the 24-hour window.

1. Go to your Log Analytics workspace → **Usage and Estimated Costs** → **Daily Cap**.
2. Check if the cap was reached. If so, increase it or reduce ingestion volume.

#### Check current ingestion volume

```kql
Usage
| where TimeGenerated > ago(1d)
| summarize TotalGB = sum(Quantity) / 1000 by DataType
| order by TotalGB desc
```

### Validate transform statements

If your dataflow includes a transformation:

- The KQL transform statement must be syntactically valid.
- When targeting **standard tables** (e.g., `Syslog`, `CommonSecurityLog`), the transform must preserve all required columns — particularly `TimeGenerated`.
- Invalid transforms produce `InvalidTransformStatement` or `InvalidTransformStatementForStreamSchema` errors.

### Resource attributes are missing from OTel logs or spans

For native OTLP collection, the Azure Monitor pipeline copies resource attributes onto log and span records only when the corresponding data source sets `enrichWithResourceAttributes` to an array of attribute names.

- Set the property on each applicable `properties.dataSources.otelLogs[]` and `properties.dataSources.otelTraces[]` object. For example, use `["service.name", "service.version"]` to select specific attributes or `["*"]` to select all resource attributes. A Boolean value isn't valid.
- For multi-workspace log fan-out, set it on the `otelLogs` source in every dataflow DCR.
- Read the DCR back by using API version `2025-05-11` and confirm that the property is retained.
- Confirm that the OTel client emits resource attributes, and then send new telemetry. The setting doesn't update records that were already ingested.

`ServiceName` can be populated even when `OTelLogs.ResourceAttributes` is null. For traces, resource attributes can also appear in `OTelResources`; correlate `OTelSpans.ResourceAttributesId` with `OTelResources.Id`.

### Check persistent storage configuration

If the pipeline uses persistent storage:

- Set `controllerManager.manager.env.pipelinePersistentVolume` in the extension's `properties.configurationSettings` to the name of an existing, available **ReadWriteMany PersistentVolume**. Don't supply a PVC or StorageClass name; the controller creates and binds its own PVC.
- Set `persistence.maxStorageUsageMb` and `retentionPeriodMin` on each applicable `syslog`, `otelLogs`, `otelMetrics`, or `otelTraces` data source in the dataflow DCR. See [Configure persistent storage](./pipeline-persistent-storage.md).
- Size each buffer for 202 MB per CPU core available to the collector. If the pipeline uses `all_cores`, use the largest core count available on any eligible node. A smaller cap prevents the pipeline from starting.
- Verify that persistent volume claims are bound.
- Confirm that the pipeline can mount and write to the volume.
- Check available storage and look for write or backfill errors in pod logs.

### Check TLS configuration

If the pipeline's listening endpoints use TLS:

- The certificate and private key must be valid and accessible.
- Private keys must be stored in a **Kubernetes Secret** (not a ConfigMap).
- Expired or mismatched certificates will prevent data sources from connecting.

### Inspect Arc extension health

The pipeline runs as an Arc extension on Kubernetes. Verify the extension status and the health of the pods on the cluster:

```bash
# Check extension status
az k8s-extension show --name <extension-name> \
  --cluster-name <cluster-name> \
  --resource-group <rg> \
  --cluster-type connectedClusters \
  --query "provisioningState"

# Check pod health on the cluster
kubectl get pods -n <pipeline-namespace>
kubectl logs <pipeline-pod> -n <pipeline-namespace>
```

## Common issues and resolutions

### Deployment and configuration issues

<details>
<summary><b>Pipeline pods are in CrashLoopBackOff status</b></summary>

**Symptoms**: Pipeline operator or collector pods continuously restart with `CrashLoopBackOff` status.

**Causes**: 
- Missing certificate manager extension
- Insufficient cluster resources
- Missing or invalid configuration

**Resolution**:
1. Verify that the Azure Arc Certificate Manager extension is installed on your cluster:
   ```azurecli
   az k8s-extension list --cluster-name <cluster-name> --resource-group <resource-group> --cluster-type connectedClusters --query "[?extensionType=='microsoft.certmanagement'].{Name:name, State:provisioningState}" -o table
   ```

2. Check pod logs for detailed error messages:
   ```bash
   kubectl logs <pod-name> -n mon --previous
   ```

3. Verify cluster resource availability:
   ```bash
   kubectl top nodes
   kubectl describe node <node-name>
   ```

4. Review the pipeline configuration for missing required fields. See [Configure Azure Monitor pipeline](./pipeline-configure.md) for valid configuration.

</details>

<details>
<summary><b>Heartbeat records not appearing in Log Analytics workspace</b></summary>

**Symptoms**: No heartbeat records in the `Heartbeat` table even after several minutes.

**Causes**:
- Pipeline not sending data to Azure Monitor
- Network connectivity issues
- Incorrect Log Analytics workspace configuration

**Resolution**:
1. Verify the pipeline is running:
   ```bash
   kubectl get pods -n mon
   ```

2. Check network connectivity from the cluster to Azure:
   ```bash
   kubectl run -it --image=mcr.microsoft.com/azure-cli:latest --restart=Never -- az monitor diagnostic-settings list --resource /subscriptions/<subscription-id>
   ```

3. Verify the Log Analytics workspace is configured correctly in the pipeline instance.

4. Check pipeline logs for connection errors:
   ```bash
   kubectl logs -n mon -l app.kubernetes.io/name=collector -f
   ```

</details>

### Data collection issues

<details>
<summary><b>Pipeline not receiving telemetry data from clients</b></summary>

**Symptoms**: No data arriving at the pipeline despite clients attempting to send data.

**Causes**:
- Clients can't reach the pipeline endpoint
- Gateway not properly configured or exposed
- Port access restrictions

**Resolution**:
1. Verify the pipeline service endpoint is accessible:
   ```bash
   kubectl get svc -n mon
   ```

2. Test connectivity from a client pod (assuming port 514):
   ```bash
   kubectl run -it --image=mcr.microsoft.com/alpine:latest --restart=Never -- nc -zv <pipeline-ip> 514
   ```

3. Verify the gateway configuration. See [Configure a Kubernetes gateway for Azure Monitor pipeline](./pipeline-kubernetes-gateway.md).

4. Check firewall and network security group rules to ensure required ports are open (assuming default ports)):
   - Syslog/CEF: TCP port 514 (default)
   - OTLP: TCP port 4317 (default, Preview)

</details>

<details>
<summary><b>Data arriving late or inconsistently</b></summary>

**Symptoms**: Telemetry is received but with delays or gaps.

**Causes**:
- Cluster resource constraints (CPU or memory pressure)
- Transformations taking too long
- Network latency between the cluster and Azure Monitor

**Resolution**:
1. Check cluster resource utilization:
   ```bash
   kubectl top pods -n mon
   ```

2. Review pipeline transformation complexity. Simplify KQL transformations if possible. See [Pipeline transformations](./pipeline-transformations.md).

3. Monitor network latency between cluster and Azure Monitor.

</details>

### Connectivity and reliability issues

<details>
<summary><b>Data in persistent storage not being backfilled after connectivity is restored</b></summary>

**Symptoms**: Data written to persistent storage isn't sent to Azure Monitor after reconnection.

**Causes**:
- Persistent storage configuration issues
- Connectivity still not fully restored

**Resolution**:
1. Verify persistent storage is correctly configured and accessible:
   ```bash
   kubectl get pvc -n mon
   kubectl describe pvc <pvc-name> -n mon
   ```

2. Check persistent volume status:
   ```bash
   kubectl get pv
   ```

3. Verify network connectivity is fully restored:
   ```bash
   kubectl run -it --image=mcr.microsoft.com/azure-cli:latest --restart=Never -- az monitor account list
   ```

4. Check pipeline logs for backfill errors:
   ```bash
   kubectl logs -n mon -l app.kubernetes.io/name=collector -f | grep -i buffer
   ```

</details>

<details>
<summary><b>TLS/mTLS certificate issues</b></summary>

**Symptoms**: Connection errors mentioning certificates or TLS handshake failures.

**Causes**:
- Expired certificates
- Invalid certificate configuration
- Certificate not trusted by clients

**Resolution**:
1. Verify certificate status:
   ```bash
   kubectl get cert -n mon
   kubectl describe cert <cert-name> -n mon
   ```

2. Check certificate expiration dates:
   ```bash
   kubectl get secret -n mon -o json | jq '.items[] | select(.type=="kubernetes.io/tls") | {name: .metadata.name, expiration: .data."tls.crt" | @base64d | openssl x509 -noout -enddate}'
   ```

3. For automated certificate management, verify the certificate manager extension is working properly. See [Configure TLS](./pipeline-tls.md).

4. For customer-managed certificates, ensure certificates are properly imported and configured. See [Customer-managed certificates (BYOC)](./pipeline-tls-custom.md).

</details>

## Performance and resource issues

<details>
<summary><b>High memory or CPU usage on pipeline pods</b></summary>

**Symptoms**: Pipeline pods consuming high memory or CPU resources, affecting cluster performance.

**Causes**:
- High data throughput exceeding current sizing
- Resource limits set too low for current workload
- Inefficient transformations

**Resolution**:
1. Review cluster sizing against actual throughput. See [Best practices for sizing Azure Monitor pipeline](./pipeline-sizing.md).

2. Monitor metrics over time:
   ```bash
   kubectl top pod -n mon --containers
   ```

3. Simplify or optimize data transformations if applicable.

4. Increase cluster resources or add additional pipeline replicas:
   - Scale vertically: Use larger node sizes
   - Scale horizontally: Add more pipeline replicas

</details>

## Still need help?

If you're unable to resolve the issue using this guidance:

1. Collect diagnostic logs from the cluster and pipeline pods
2. Review pipeline extension versions for compatibility. See [Extension versions](./pipeline-extension-versions.md)
3. Check [Supported configurations](./pipeline-overview.md#supported-configurations) to ensure your deployment is supported
4. Contact Azure support with collected logs and deployment details
