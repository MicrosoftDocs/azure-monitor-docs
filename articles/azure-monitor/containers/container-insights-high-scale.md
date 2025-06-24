---
title: High scale logs collection in Container Insights (Preview) 
description: Enable high scale logs collection in Container Insights (Preview).
ms.topic: article
ms.date: 08/06/2024
---

# High scale logs collection in Container Insights (Preview)

High scale mode is a feature in Container Insights that enables you to collect container console (stdout & stderr) logs with high throughput from your Azure Kubernetes Service (AKS) cluster nodes. This feature enables you to collect up to 50,000 logs/sec per node.

> [!NOTE]
> This feature is currently in public preview. For additional information, read the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms).

## Overview

When high scale mode is enabled, Container Insights performs multiple configuration changes resulting in a higher overall throughput. This includes using an upgraded agent and Azure Monitor data pipeline with scale improvements. These changes are all made in the background by Azure Monitor and don't require input or configuration after the feature is enabled.

High scale mode impacts only the data collection layer. The rest of the Container Insights experience remains the same, with logs being ingested into same `ContainerLogV2` table. Existing queries and alerts continue to work since the same data is being collected.

To achieve the maximum supported logs throughput, you should use high-end VM SKUs with 16 CPU cores or more for your AKS cluster nodes. Using low end VM SKUs impacts your logs throughput.

## Does my cluster qualify?

High scale logs collection is suited for environments sending more than 2,000 logs/sec (or 2 MB/sec) per node in their Kubernetes clusters and has been designed and tested for sending up to 50,000 logs/sec per node. Use the following [log queries](../logs/log-query-overview.md) to determine whether your cluster is suitable for high scale logs collection.

**Logs per second and per node**

```kusto
ContainerLogV2 
| where _ResourceId =~ "<cluster-resource-id>" 
| summarize count() by bin(TimeGenerated, 1s), Computer 
| render timechart 
```

**Log size (in MB) per second per node**

```kusto
 ContainerLogV2 
| where _ResourceId =~ "<cluster-resource-id>"
| summarize BillableDataMB = sum(_BilledSize)/1024/1024 by bin(TimeGenerated, 1s), Computer 
| render timechart 
```

## Prerequisites 

* Azure CLI version 2.63.0 or higher.
* AKS-preview CLI extension version must be 7.0.0b4 or higher if an aks-preview CLI extension is installed.
* Cluster schema must be [configured for ContainerLogV2](container-insights-logs-schema.md#enable-the-containerlogv2-schema).
* If the default resource limits (CPU and memory) on ama-logs daemon set container doesn't meet your log scale requirements, contact the Microsoft support channel to increase the resource limits of your ama-logs container.

## Network firewall requirements

In addition to the [network firewall requirements](kubernetes-monitoring-firewall.md) for monitoring a Kubernetes cluster, additional configurations in the following table are needed for enabling high scale mode depending on your cloud. 

| Cloud                                      | Endpoint                                                                      | Port |
|:-------------------------------------------|:------------------------------------------------------------------------------|:-----|
| Azure Public Cloud                         | `<dce-name>-<suffix>.<cluster-region-name>-<suffix>.ingest.monitor.azure.com` | 443  |
| Microsoft Azure operated by 21Vianet cloud | `<dce-name>-<suffix>.<cluster-region-name>-<suffix>.ingest.monitor.azure.cn`  | 443  |
| Azure Government cloud                     | `<dce-name>-<suffix>.<cluster-region-name>-<suffix>.ingest.monitor.azure.us`  | 443  |

The endpoint is the **Logs Ingestion** endpoint from the data collection endpoint (DCE) for the data collection rule (DCR) used by the cluster. This DCE is created when you enable high scale mode for the cluster and starts with the prefix `MSCI-ingest`.

:::image type="content" source="media/container-insights-high-scale/logs-ingestion-endpoint.png" lightbox="media/container-insights-high-scale/logs-ingestion-endpoint.png" alt-text="Screenshot of logs ingestion endpoint for DCE.":::

## Limitations 

The following scenarios aren't supported during the preview release. These will be addressed when the feature becomes generally available.

* AKS Clusters with Arm64 nodes
* Azure Arc-enabled Kubernetes
* HTTP proxy with trusted certificate
* Onboarding through Azure portal, Azure Policy, Terraform and Bicep 
* Configuring through **Monitor Settings** in the AKS Insights portal experience
* Automatic migration from existing Container Insights

## Enable high scale logs collection

Follow the two steps in the following sections to enable high scale mode for your cluster.

> [!NOTE]
> High log scale mode requires a [data collection endpoint (DCE)](../data-collection/data-collection-endpoint-overview.md) for ingestion. An ingestion DCE is created with the prefix `MSCI-ingest` for each cluster when you onboard them. If Azure Monitor private link scope is configured, then there will also be configuration DCE created with the prefix `MSCI-config`. 

### Update configmap

The first step is to update configmap for the cluster to instruct the Container Insights ama-logs deamonset pods to run in high scale mode. 

1. Follow the guidance in [Configure and deploy ConfigMap](container-insights-data-collection-configmap.md#configure-and-deploy-configmap) to download and update ConfigMap for the cluster. 

1. Enable high scale mode with the following setting under `agent-settings`.

    ```yml
    [agent_settings.high_log_scale] 
      enabled = true 
    ```

1. Enable collection of internal metrics to populate the QoS Grafana dashboard described below with the following setting under `agent-settings`.

    ```yaml
    [agent_settings.fbit_config]
      enable_internal_metrics = "true"
    ```

1. Apply the ConfigMap to the cluster with the following commands. 

    ```bash
    kubectl config set-context <cluster-name>
    kubectl apply -f <configmap_yaml_file.yaml>
    ```

After applying this configmap, `ama-logs-*` pods will get restarted automatically and configure the ama-logs daemonset pods to run in high scale mode. 

### Enable high scale mode for Monitoring add-on

Enable the Monitoring Add-on with high scale mode using the following Azure CLI commands to enable high scale logs mode for the Monitoring add-on depending on your AKS configuration.

> [!NOTE]
> Instead of CLI, you can use an ARM template to enable high scale mode for the Monitoring add-on. See [Enable Container Insights](kubernetes-monitoring-enable.md?tabs=arm#enable-container-insights) for guidance on enabling Container Insights using an ARM template. To enable high scale mode, use `Microsoft-ContainerLogV2-HighScale` instead of `Microsoft-ContainerLogV2` in the `streams` parameter as described in [Configure DCR with ARM templates](container-insights-data-collection-configure.md?tabs=arm#configure-dcr-with-arm-templates).

**Existing AKS cluster**

```azurecli
az aks enable-addons -a monitoring -g <resource-group-name> -n <cluster-name> --enable-high-log-scale-mode
```

**Existing AKS Private cluster**

```azurecli
az aks enable-addons -a monitoring -g <resource-group-name> -n <cluster-name> --enable-high-scale-mode --ampls-resource-id /subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/microsoft.insights/privatelinkscopes/<resourceName> 
```

**New AKS cluster**

```azurecli
az aks create -g <cluster-name> -n <cluster-name> enable-addons -a monitoring --enable-high-log-scale-mode
```

**New AKS Private cluster**

See [Create a private Azure Kubernetes Service (AKS) cluster](/azure/aks/private-clusters?tabs=azure-portal) for details on creating an AKS Private cluster. Use the additional parameters `--enable-high-scale-mode` and `--ampls-resource-id` to configure high log scale mode with Azure Monitor Private Link Scope Resource ID. 

## Migration

If Container Insights is already enabled for your cluster, then you need to disable it and then re-enable it with high scale mode.

* Since high scale mode uses a different data pipeline, you must ensure that pipeline endpoints aren't blocked by a firewall or other network connections.
* High scale mode requires a data collection endpoint (DCE) for ingestion in addition to the standard DCR for data collection. If you've created any DCRs that use `Microsoft.ContainerLogV2`, you must replace this with `Microsoft.ContainerLogV2-HighScale` or data will be duplicated. You should also create a DCE for ingestion and link it to the DCR if the DCR isn't already using one. Refer to Container Insights onboarding through Azure Resource Manager for reference for the dependencies. 

## Monitor QoS metrics with Prometheus and Grafana 

When the volume of logs generated is substantial, it can lead to throttling and log loss. See the *[Configure throttling for Container Insights](https://learn.microsoft.com/azure/azure-monitor/containers/container-insights-throttling)* article for guidance on configuring throttling parameters and monitoring for log loss. 

## Next steps

* Share any feedback or issues with High Scale mode at [https://aka.ms/cihsfeedback](https://aka.ms/cihsfeedback).
