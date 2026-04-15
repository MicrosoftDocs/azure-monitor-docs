---
title: Troubleshoot Azure Monitor pipeline
description: Guidance for troubleshooting issues with Azure Monitor pipeline deployment, configuration, data collection, and connectivity.
ms.topic: troubleshooting-general
ms.date: 03/20/2026
ms.custom: references_regions, devx-track-azurecli, doc-kit-assisted
---

# Troubleshoot Azure Monitor pipeline

This article provides guidance for common issues encountered when deploying and using Azure Monitor pipeline.

## Monitor pipeline health and performance

Track the health and performance of your pipeline deployment using Azure Monitor metrics and logs.

### View metrics in the Azure portal

In the Azure portal, open your Azure Monitor pipeline resource and select **Monitoring** and then **Metrics**. The following metrics are available:

| Component | Metric name | Display name | Description | Dimensions |
|:---|:---|:---|:---|:---|
| Engine | `process_cpu_utilization` | CPU utilization (preview) | The percentage of CPU utilized by the pipeline group process, normalized across all cores. | Instance ID |
| Engine | `process_memory_usage` | Memory used (preview) | Total physical memory (resident set size) used by the pipeline group process. | Instance ID |
| Pipeline | `process_uptime` | Process uptime (preview) | Uptime of the pipeline group process since last start. | Instance ID |
| Exporter | `exporter_sent_log_records` | Logs exported (preview) | Number of log records successfully sent by the exporter to the destination. | Instance ID, Pipeline name, Component name |
| Exporter | `exporter_send_failed_log_records` | Failed log exports (preview) | Number of log records that the exporter couldn't deliver after exhausting its own retries, if any. The same logs might be counted more than once if an upstream retry or buffering mechanism resubmits them. A nonzero value indicates export issues but not necessarily data loss because the pipeline might still retry successfully. | Instance ID, Pipeline name, Component name |

### Collect and view logs

Create a [diagnostic setting in Azure Monitor](../platform/diagnostic-settings.md) to collect resource logs for the pipeline. If you select Log Analytics workspace as a destination, you can view logs for your Azure Monitor pipeline instance in the `AzureMonitorPipelineLogErrors` table in your Log Analytics workspace.

### Collect logs from cluster pods

To investigate issues not visible in the Azure portal, collect logs directly from pipeline pods on your Kubernetes cluster.

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

If data isn't appearing in your Log Analytics workspace from Azure Monitor pipeline, the issue might be at any stage in the collection process. An Azure Monitor pipeline group follows an OpenTelemetry Collector pattern:

```
Receiver → Processor → Exporter → Data Collection Endpoint → Data Collection Rule → Log Analytics Workspace
```

Work through the following checks in order to locate the source of the issue.

### Verify pipeline group provisioning status

Before anything else, confirm the resource deployed successfully.

```bash
az resource show \
  --ids "/subscriptions/{sub}/resourceGroups/{rg}/providers/Microsoft.Monitor/pipelineGroups/{name}" \
  --query "properties.provisioningState"
```

- If not `Succeeded`, check the deployment error details in the Activity Log.
- Confirm `extendedLocation.type` is `"CustomLocation"` and the custom location resource ID is valid and points to an Arc-enabled Kubernetes cluster.

### Validate exporter to Log Analytics configuration

This is the **most common area for mistakes**. The exporter must specify three things correctly:

| Field | What to check |
|---|---|
| `dataCollectionEndpointUrl` | Must be a valid DCE URL (e.g., `https://logs-ingestion-xxxx.eastus-1.ingest.monitor.azure.com`). Confirm the DCE exists and is in the same region. |
| `dataCollectionRule` | Must be the immutable ID of the DCR (e.g., `dcr-6ed97ddc...`), **not** the resource ID. Confirm the DCR exists and hasn't been deleted. |
| `stream` | Must match a stream declared in the DCR (e.g., `Custom-MyTableRawData` or `Microsoft-Syslog`). A mismatch means data is silently dropped. |

**Common mistake:** Using the DCR resource name instead of its immutable ID.

### Example: Correct Exporter Configuration

```json
{
  "name": "myExporter",
  "type": "AzureMonitorWorkspaceLogs",
  "azureMonitorWorkspaceLogs": {
    "api": {
      "dataCollectionEndpointUrl": "https://logs-ingestion-eb0s.eastus-1.ingest.monitor.azure.com",
      "dataCollectionRule": "dcr-6ed97ddc4a3f45b991ad89ea6930a949",
      "stream": "Custom-MyTableRawData",
      "schema": {
        "recordMap": [
          { "from": "body", "to": "Body" },
          { "from": "severity_text", "to": "SeverityText" },
          { "from": "time_unix_nano", "to": "TimeGenerated" }
        ]
      }
    }
  }
}
```

### Check the record map schema mapping

The `recordMap` in the exporter's `api.schema` must:

- **Include a mapping to `TimeGenerated`** — Log Analytics rejects records without this column.
  Example: `{ "from": "time_unix_nano", "to": "TimeGenerated" }`
- **Map `from` fields correctly** — Valid sources include `body`, `severity_text`, `time_unix_nano`, and `attributes.{fieldName}`.
  - Multi-level dot notation like `attributes.foo.bar` is **not supported**. Use bracket notation: `attributes['foo.bar']`.
- **Map `to` fields that exist in the destination table** — Column names must match the DCR/table schema.

### Validate the Custom Table Schema

```kql
// Check if the custom table exists and has expected columns
CustomTable_CL
| getschema
```

### Verify the pipeline wiring in the service section

In the `service.pipelines` array, confirm:

- **Every receiver, processor, and exporter referenced in the pipeline actually exists** in the top-level arrays. A typo in a name (e.g., `"otlp1"` vs `"OTLP1"`) causes `MissingReceiverReference` / `MissingExporterReference` errors.
- **No duplicate references** within a single pipeline (e.g., listing the same receiver twice).
- **All defined components are referenced** in at least one pipeline — orphaned receivers/exporters are rejected.
- **Pipeline type matches the data** — Use `"Logs"` for log data flowing to Log Analytics.

### Example: Correct Pipeline Wiring

```json
{
  "service": {
    "pipelines": [
      {
        "name": "MyPipeline1",
        "type": "Logs",
        "receivers": ["otlp1", "MySyslog1"],
        "processors": ["batchproc1"],
        "exporters": ["myExporter"]
      }
    ]
  }
}
```

### Check receiver endpoints and network connectivity

- **Endpoint format**: Must be `host:port` (e.g., `0.0.0.0:514`). IPv6 uses `[::]:port`.
- **No port conflicts**: Two receivers cannot bind the same port. Check for `ReceiverPortConflict` errors.
- **Firewall or NSG rules**: Ensure the source (application, syslog forwarder, OTLP client) can reach the receiver endpoint on the Arc-connected Kubernetes cluster.
- **For Syslog receivers**: Verify `transportProtocol` is `"tcp"` or `"udp"` (not `"http"`), and `allowedFormats` includes the format your source sends (e.g., `syslogRfc5424`, `cefRfc3164`).

### Supported Receiver Types

| Type | Protocol | Example Endpoint |
|---|---|---|
| OTLP | gRPC | `0.0.0.0:4317` |
| Syslog | TCP or UDP | `0.0.0.0:514` |
| UDP | UDP | `0.0.0.0:5557` |

### Test Connectivity from Source

```bash
# For TCP syslog
nc -zv <pipeline-endpoint-ip> 514

# For OTLP gRPC
grpcurl -plaintext <pipeline-endpoint-ip>:4317 list
```

### Validate the data collection rule and endpoint

Even if the pipeline is configured correctly, the DCR/DCE layer can block ingestion:

- **DCR stream name must match** the exporter's `stream` value exactly.
- **DCR must be associated** with the correct Log Analytics workspace.
- **DCE must be accessible** from the Kubernetes cluster — check firewall/private endpoint configuration.
- **For private link setups**: Confirm the DCE is added to the Azure Monitor Private Link Scope (AMPLS) and DNS resolves correctly.

### Check DCR Ingestion Health

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

#### Check Current Ingestion Volume

```kql
Usage
| where TimeGenerated > ago(1d)
| summarize TotalGB = sum(Quantity) / 1000 by DataType
| order by TotalGB desc
```

### Validate transform statements

If your pipeline uses a `TransformLanguage` processor:

- The KQL transform statement must be syntactically valid.
- When targeting **standard tables** (e.g., `Syslog`, `CommonSecurityLog`), the transform must preserve all required columns — particularly `TimeGenerated`.
- Invalid transforms produce `InvalidTransformStatement` or `InvalidTransformStatementForStreamSchema` errors.

### Check persistence configuration

If the exporter has `persistence` or `cache` configured:

- A `persistentVolumeName` **must** be specified in `service.persistence`. Without it, you'll get `PersistenceRequiredForExporterPersistence`.
- The `retentionPeriod` must not exceed 2,880 minutes (2 days).
- Verify the Kubernetes PersistentVolume exists and is bound.

### Check TLS configuration

If receivers reference a `tlsConfiguration`:

- The certificate and private key must be valid and accessible.
- Private keys must be stored in a **Kubernetes Secret** (not a ConfigMap).
- Expired or mismatched certificates will prevent data sources from connecting.

### Inspect Arc extension health

The pipeline group runs as an Arc extension on Kubernetes. Verify the extension status and the health of the pods on the cluster:

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
- Buffering enabled with high retention settings
- Transformations taking too long
- Cluster resource constraints

**Resolution**:
1. Check cluster resource utilization:
   ```bash
   kubectl top pods -n mon
   ```

2. Review pipeline transformation complexity. Simplify KQL transformations if possible. See [Pipeline transformations](./pipeline-transformations.md).

3. Monitor network latency between cluster and Azure Monitor.

4. Review buffering configuration and adjust retention settings as needed.

</details>

### Connectivity and reliability issues

<details>
<summary><b>Buffered data not being backfilled after connectivity is restored</b></summary>

**Symptoms**: Data is buffered during outages but not sent to Azure Monitor after reconnection.

**Causes**:
- Persistent storage configuration issues
- Buffer corruption
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
- Memory leaks or resource exhaustion
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
