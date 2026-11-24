---
title: Configure persistent storage for Azure Monitor pipeline
description: Configure persistent buffering for Syslog, CEF, and OpenTelemetry data in Azure Monitor pipeline.
ai-usage: ai-assisted
ms.topic: how-to
ms.date: 11/23/2026
---

# Configure persistent storage for Azure Monitor pipeline

Persistent storage buffers telemetry locally after the pipeline receives it. If the connection to Azure Monitor is interrupted or a collector restarts, the pipeline reads buffered records from durable storage and resumes delivery.

For DCR-based deployments on Arc-enabled Kubernetes, configure both the extension's volume selection and the buffering limits on each data source that needs persistence. Selecting a volume alone doesn't enable buffering.

This article applies to Syslog, CEF, and OpenTelemetry (OTel) logs, metrics, and traces. For Linux VM and Arc-enabled Linux server deployments, see [Configure persistent storage on a VM](./pipeline-configure-vm.md#configure-persistent-storage-optional). For an existing PipelineGroup deployment, use the [legacy storage guidance](./pipeline-configure-legacy.md#legacy-cli-enable-persistent-storage).

## Prerequisites

Prepare an existing, available **ReadWriteMany** filesystem PersistentVolume (PV) with durable storage accessible from every eligible collector node. Size it for all replicas, data source buffers, and filesystem overhead.

A node-local `hostPath` isn't suitable for collectors on different hosts. Supply the **PV name**, not a persistent volume claim (PVC) name, StorageClass, Azure disk resource ID, or file-share URL.

The pipeline controller creates its own PVC, copies the PV's StorageClass, and binds the claim to the selected PV. Don't pre-create a competing claim. The deployment doesn't create the backing storage or Kubernetes PV.

## Select the persistent volume

Merge the following entry into the extension's `properties.configurationSettings` map. Preserve other required extension settings:

```json
{
  "controllerManager.manager.env.pipelinePersistentVolume": "<existing-read-write-many-pv-name>"
}
```

Keep PV selection out of the settings DCR and dataflow DCR. To configure replicas and node constraints, see [Pod placement](./pipeline-pod-placement.md#configure-collector-placement).

## Configure buffer limits

Add `persistence` directly to each data source object that needs durable buffering:

```json
{
  "persistence": {
    "maxStorageUsageMb": 1024,
    "retentionPeriodMin": 1440
  }
}
```

Don't nest this object under `configuration` in the Azure Resource Manager request. The example caps that data source's buffer at 1,024 MB with 1,440-minute retention. The size limit doesn't provision storage. The buffer drops the oldest records when it reaches the size limit or retention period.

### Minimum buffer size

Each durable buffer requires at least 192 MiB (201.33 MB) for every CPU core available to the collector. Set the data source's `maxStorageUsageMb` to at least:

`202 MB × CPU cores available to the collector`

This calculation rounds up the per-core minimum and is simple to apply. For four available cores, set at least 808 MB per buffer. The exact minimum rounded up to a whole megabyte is 806 MB.

If the pipeline uses `all_cores`, size each buffer for the largest core count that the pipeline can use on any eligible node. The limit applies separately to every data source buffer; it isn't the PVC size. Size the PVC for all buffers, replicas, and filesystem overhead.

> [!IMPORTANT]
> If `maxStorageUsageMb` is lower than the minimum for the active core count, the pipeline fails to start. It doesn't reduce the number of cores to fit the configured buffer.

### Syslog and CEF

Add the property to each applicable `properties.dataSources.syslog[]` object. Retain its name, mode, streams, formats, transformation, and endpoint routing.

### OpenTelemetry logs, metrics, and traces

Add the same property to each applicable OTel data source object:

- `properties.dataSources.otelLogs[]`
- `properties.dataSources.otelMetrics[]`
- `properties.dataSources.otelTraces[]`

For example, the following OTel logs source enables a 1,024-MB buffer with 24-hour retention:

```json
{
  "name": "otelLogs",
  "mode": "pipeline",
  "streams": [
    "Microsoft-OTel-Logs"
  ],
  "endpointRouting": [
    "otlp-grpc"
  ],
  "persistence": {
    "maxStorageUsageMb": 1024,
    "retentionPeriodMin": 1440
  }
}
```

Configure persistence separately for every OTel source that needs buffering. Limits apply to each source buffer, not to the total persistent volume.

## Deploy and verify

Deploy the updated extension settings and dataflow DCR. Then:

1. Verify that the controller-created PVC is `Bound` to the selected PV:

   ```bash
   kubectl get pvc --namespace <extension-namespace> --selector app.kubernetes.io/instance=<extension-name> -o wide
   kubectl get pv <existing-read-write-many-pv-name> -o yaml
   ```

1. Read the dataflow DCR by using API version `2025-05-11`. Confirm that the applicable `syslog`, `otelLogs`, `otelMetrics`, or `otelTraces` data source retains the requested `persistence` limits.
1. Inspect the generated collector configuration for a durable buffer and its mount at `/var/azmonpipeline/durable_buffer`.
1. Check collector logs for storage and export errors.
1. Send test telemetry, interrupt destination connectivity, restore connectivity, and verify that buffered records are delivered.

Persistence starts after the pipeline receives a record. It can't recover packets or requests lost before the collector accepts them. A bound claim and successful ingestion don't prove recovery after a restart or connectivity interruption, so test recovery before relying on it.

Don't assume that the claim survives DCR removal or extension deletion. Drain buffered data before teardown, and use a PV reclaim policy of `Retain` when backing data must survive claim deletion.
