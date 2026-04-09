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

In the Azure portal, open your Azure Monitor pipeline resource and select **Monitoring**. The following metrics are available:

| Metric name | Display name | Description | Dimensions |
|:---|:---|:---|:---|
| `process_cpu_utilization` | CPU utilization (preview) | The percentage of CPU utilized by the pipeline group process, normalized across all cores. | Instance ID |
| `process_memory_usage` | Memory used (preview) | Total physical memory (resident set size) used by the pipeline group process. | Instance ID |
| `process_uptime` | Process uptime (preview) | Uptime of the pipeline group process since last start. | Instance ID |
| `exporter_sent_log_records` | Logs exported (preview) | Number of log records successfully sent by the exporter to the destination. | Instance ID, Pipeline name, Component name |

### View metrics through Prometheus scraping

You can also scrape pipeline metrics using Prometheus. For more information, see [Collect Prometheus metrics from an Arc-enabled Kubernetes cluster](/azure/azure-monitor/containers/kubernetes-monitoring-enable#enable-prometheus-and-grafana).

### View logs in the Azure portal

Create a [diagnostic setting in Azure Monitor](../platform/diagnostic-settings.md) to collect resource logs for the pipeline. After you configure diagnostic settings, you can view logs for your Azure Monitor pipeline instance in the `AzureMonitorPipelineLogErrors` table in your Log Analytics workspace.

### Collect logs from cluster pods

To investigate issues not visible in the Azure portal, collect logs directly from pipeline pods on your Kubernetes cluster.

**Retrieve pod logs:**
```bash
kubectl logs <pod-name> -n <namespace>
```

**Retrieve logs from a previous pod instance** (if the pod crashed and restarted):
```bash
kubectl logs <pod-name> -n <namespace> --previous
```

**Stream logs in real time:**
```bash
kubectl logs <pod-name> -n <namespace> -f
```

**Retrieve logs from all pipeline pods:**
```bash
kubectl logs -n mon -l app.kubernetes.io/name=collector -f
```

These logs often contain detailed error messages and stack traces that can help identify the root cause of deployment, configuration, data collection, or connectivity issues.

## Common issues

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

2. Test connectivity from a client pod:
   ```bash
   kubectl run -it --image=mcr.microsoft.com/alpine:latest --restart=Never -- nc -zv <pipeline-ip> 514
   ```

3. Verify the gateway configuration. See [Configure a Kubernetes gateway for Azure Monitor pipeline](./pipeline-kubernetes-gateway.md).

4. Check firewall and network security group rules to ensure required ports are open:
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

### Performance and resource issues

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
