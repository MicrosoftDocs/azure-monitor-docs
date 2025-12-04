---
title: Filter container log collection with ConfigMap
description: Options for filtering Container insights data that you don't require.
ms.topic: how-to
ms.date: 09/22/2025
ms.reviewer: aul
---

# Filter and customize data collection for Kubernetes clusters
The data that Azure Monitor initially collects from your Kubernetes clusters depends on the options you chose when you [enabled collection of logs and metrics](./kubernetes-monitoring-enable.md). After this initial onboarding, you can further customize the data collection either to add data that you require to properly monitor your Kubernetes environment, or to filter out data that you don't need to reduce your monitoring costs. You can further optimize costs with advanced filtering and sending different types of data to different storage. 
 
This article describes the different types of customization you can perform for data collection from your Kubernetes clusters and the methods required to implement each. Links are provided to detailed instructions for each method.


## Configuration methods
When you enable monitoring for a Kubernetes cluster in Azure Monitor, the [Azure Monitor agent (AMA)](../agents/azure-monitor-agent-overview.md) is installed in the cluster. This agent is responsible for collecting logs and metrics from the cluster and sending them to Azure Monitor. 

There are two methods to define the configuration the agent will use to collect data. Each method controls different aspects of data collection, so you need to use both methods together to achieve your requirements. For some configuration options, you can choose either method. While both logs and metrics use the same configuration options, configuration for each data is done separately.


| Method | Description |
|:---|:---|
| ConfigMap | [ConfigMaps](https://kubernetes.io/docs/concepts/configuration/configmap/) in Kubernetes store configuration data for applications running in the cluster. Multiple ConfigMaps are provided by Microsoft for both logs and metrics that are read by the Azure Monitor to modify different aspects of data collected by the agent from the cluster. Modify these ConfigMaps and apply them to your cluster to customize data collection for each data type. |
| Data Collection Rule (DCR) | [Data collection rules (DCRs)](../data-collection/data-collection-rule-overview.md) in Azure Monitor define what data is collected from a monitored resource and where that data is sent. Separate DCRs are automatically created for logs and metrics when you enable monitoring for your Kubernetes cluster. You can also share a single DCR across multiple clusters to centralize configuration and simplify management. Some settings in the DCR are read by the agent to determine the data it collects by the cluster. Other settings are used by Azure Monitor to determine how to process that data after it's sent from the cluster. This includes [transformations](../data-collection/data-collection-rule-transformations.md), which provide advanced filtering and manipulation of data before it's ingested into the Log Analytics workspace.|

:::image type="content" source="./media/kubernetes-data-collection-configure/data-configuration-options.png" lightbox="./media/kubernetes-data-collection-configure/data-configuration-options.png" alt-text="{alt-text}":::

## Comparison
The follow table provides a comparison of the two configuration methods.

| | ConfigMap | Data Collection Rule (DCR) |
|:---|:---|:---|
| Logs | - Enable/disable container logs separately<br>- Namespace filtering for container logs<br>- Annotation filtering<br>- Collect environment variables | - Enable/disable all container logs<br>- Namespace filtering for other logs<br>- Specify collected tables<br>- Log Analytics workspace(s)<br>- Custom filtering with transformations |
| Metrics | - Enable/disable targets<br>- Enable/disable specific metrics<br>- Annotation-based scraping  | - Azure Monitor workspace(s) |
| Deployment | - Apply ConfigMap to each cluster.<br>- Requires redeployment for changes. | - Configure single DCR for multiple clusters<br>- Modify DCR with no restart required |

## Common settings
Some settings can be configured with both ConfigMap and DCR, but there are important differences as described in the following table.

| Setting | Recommendation |
|:---|:---|
| Container logs | For container logs to be collected, they must be enabled in both ConfigMap and DCR (ContainerLogV2 stream). ConfigMap allows you to separately enable stdout and stderr logs. If you disable either of the logs in ConfigMap, they won't be collected. |
| Namespace filtering | Namespace filtering is configured in both the ConfigMap and DCR but for different logs. Namespace filtering in ConfigMap only applies to container logs and can be configured separately for stdout and stderr logs. Namespace filtering in the DCR applies to all other logs. To fully exclude a namespace from log collection, you must exclude it in both places. |


## ConfigMap configuration
Separate ConfigMaps are provided for logs and metrics that you can modify to customize data collection from your Kubernetes clusters. Both logs and metrics have a default configuration applied when you [enable monitoring for your cluster](./kubernetes-monitoring-enable.md#enable-prometheus-metrics-and-container-logging). 

### Logs
The ConfigMap used for log collection is [container-azm-ms-agentconfig.yaml](https://aka.ms/container-azm-ms-agentconfig). See [Filter container log collection with ConfigMap](./container-insights-data-collection-configmap.md) for a description of each of the available settings and how to modify and apply this ConfigMap to your cluster. The [ConfigMap settings](./container-insights-data-collection-configmap.md#configmap-settings) section provides the default values for each setting that are used before a ConfigMap is applied.

### Metrics
See [Default Prometheus metrics configuration in Azure Monitor](./prometheus-metrics-scrape-default.md) for the metrics that are collected by default from your cluster. The ConfigMap used to modify this configuration is [ama-metrics-settings-configmap](https://aka.ms/azureprometheus-addon-settings-configmap). See [Customize collection of Prometheus metrics from your Kubernetes cluster using ConfigMap](./prometheus-metrics-scrape-configuration.md) for a description of each of the available settings and how to modify and apply this ConfigMap to your cluster. Other ConfigMaps are available to create custom scrape jobs. See [Create custom Prometheus scrape job from your Kubernetes cluster using ConfigMap](./prometheus-metrics-scrape-configmap.md) for details on how to use these ConfigMaps.



## DCR configuration
When you enable log collection for your cluster, a DCR is automatically created that includes the settings that you specified in the onboarding process. See [Enable Prometheus metrics and container logging](./kubernetes-monitoring-enable.md#enable-prometheus-metrics-and-container-logging) for specifying these settings using different onboarding methods. You can use the same methods to modify these settings after onboarding. For example, select a different **Logs preset** in the Azure portal to change the streams collected. Or run a CLI command to select a different Log Analytics workspace. 

Alternatively, you can modify the DCR directly to change these settings. See [Create data collection rules (DCRs) in Azure Monitor](../data-collection/data-collection-rule-create-edit.md) for guidance different methods to edit an existing DCR.

### 

### Advanced filtering

> [!TIP]
> You should use other filtering methods described in this article before using transformations. Transformations should be used as a last resort when other methods can't achieve your filtering requirements. They are more complex to implement and increase network usage since data is sent from the cluster before it's filtered.


Advanced data transformations that can perform the following:
- Filtering rows based on specific criteria
- Drop or rename columns
- Mask sensitive fields
- Add calculated fields


Why Use It:
•	Apply governance and filtering across multiple clusters without touching cluster config.
•	Enrich or sanitize data before ingestion for compliance and cost optimization.



## DCRs created

The resources that are created when you enable monitoring Prometheus metrics and container logging for your Kubernetes clusters in the Azure monitor are described in the following tables. 

**Log collection**

| Resource Name | Resource Type | Resource Group | Region/Location | Description |
|:---|:---|:---|:---|:---|
| `MSCI-<aksclusterregion>-<clustername>` | [Data Collection Rule](../data-collection/data-collection-rule-overview.md) | Same as cluster | Same as Log Analytics workspace | Associated with the AKS cluster resource, defines configuration of logs collection by the Azure Monitor agent. **This is the DCR to add the transformation.** |

**Managed Prometheus**

| Resource Name | Resource Type | Resource Group | Region/Location | Description |
|:---|:---|:---|:---|:---|
| `MSPROM-<aksclusterregion>-<clustername>` | [Data Collection Rule](../data-collection/data-collection-rule-overview.md) | Same as cluster | Same as Azure Monitor workspace | Associated with the AKS cluster resource, defines configuration of prometheus metrics collection by metrics addon. |
| `MSPROM-<aksclusterregion>-<clustername>` | [Data Collection endpoint](../data-collection/data-collection-endpoint-overview.md) | Same as cluster | Same as Azure Monitor workspace | Used by the DCR for ingesting Prometheus metrics from the metrics addon. |
    
When you create a new Azure Monitor workspace, the following additional resources are created.

| Resource Name | Resource Type | Resource Group | Region/Location | Description |
|:---|:---|:---|:---|:---|
| `<azuremonitor-workspace-name>` | [Data Collection Rule](../data-collection/data-collection-rule-overview.md) | MA_\<azuremonitor-workspace-name>_\<azuremonitor-workspace-region>_managed | Same as Azure Monitor Workspace | DCR to be used if you use Remote Write from a Prometheus server. |
| `<azuremonitor-workspace-name>` | [Data Collection endpoint](../data-collection/data-collection-endpoint-overview.md) | MA_\<azuremonitor-workspace-name>_\<azuremonitor-workspace-region>_managed | Same as Azure Monitor Workspace | DCE to be used if you use Remote Write from a Prometheus server. |





## Next steps

- See [Data transformations in Container insights](./container-insights-transformations.md) to add transformations to the DCR that will further filter data based on detailed criteria.







| Stage | Method | Streams |
|:---|:---|:---|
| Creation | UI (Logs and Events)) |  "Microsoft-ContainerLog", ContainerLogV2", "Microsoft-KubeEvents","Microsoft-KubePodInventory" |
| Creation 


Time stamp to clearly specify UTC/TZ and in 24hr format at (https://learn.microsoft.com/en-us/azure/azure-monitor/metrics/metrics-store-custom-rest-api?tabs=rest#timestamp)

-NameSpace and Name cannot contain spaces at (https://learn.microsoft.com/en-us/azure/azure-monitor/metrics/metrics-store-custom-rest-api?tabs=rest#namespace & https://learn.microsoft.com/en-us/azure/azure-monitor/metrics/metrics-store-custom-rest-api?tabs=rest#name)

-Sample JSON to show 24HR UTC and compliant namespace and name (they have spaces in them https://learn.microsoft.com/en-us/azure/azure-monitor/metrics/metrics-store-custom-rest-api?tabs=rest#sample-custom-metric-publication)




## Configuration options
The following tables describe the different configuration and filtering options available for logs and metrics collected from your Kubernetes clusters, along with the method required to implement each option.

### Logs

| Data | Description | Method |
|:---|:---|:---|
| Collected tables | There are multiple types of logs that Azure Monitor can collect from the cluster listed in [Stream values](./containers/kubernetes-monitoring-enable.md?tabs=cli#stream-values). Modify the tables collected using the Azure portal as described at [Configuration options](./containers/kubernetes-monitoring-enable.md?tabs=portal#configuration-options) or by manually modifying the DCR. | [DCR](./kubernetes-monitoring-enable.md#enable-prometheus-metrics-and-container-logging) |
| Container logs | Container logs are stdout/stderr logs that are sent to ContainerLogsV2 in the Log Analytics workspace. You can enable or disable collection of these logs using either the ConfigMap or the DCR. With ConfigMap, you can control stdout and stderr separately, while the DCR can only enable or disable collection of both together. | [ConfigMap](./container-insights-data-collection-configmap.md#filter-container-logs)<br>[DCR](./kubernetes-monitoring-enable.md#enable-prometheus-metrics-and-container-logging) |
| Namespaces | Filter logs for namespaces that you don't need to monitor. You may also want to enable platform logs which are disabled by default in order to support specific troubleshooting scenarios. Namespace filtering for container logs is done in ConfigMap. Namespace filtering for other logs is done with the DCR. | [ConfigMap](./container-insights-data-collection-configmap.md#filter-container-logs)<br>[DCR](./kubernetes-monitoring-enable.md#enable-prometheus-metrics-and-container-logging) |
| Annotation filtering | Exclude log collection for certain pods and containers by annotating the pod. | [ConfigMap](./container-insights-data-collection-configmap.md#filter-environment-variables) |
| Environment variables | Enable collection of environment variables across all pods and nodes.  | [ConfigMap](./container-insights-data-collection-configmap.md#filter-environment-variables) |
| Metadata enrichment | Extends the container log schema with additional Kubernetes metadata. | [ConfigMap](./container-insights-logs-schema.md#kubernetes-metadata-and-logs-filtering) |
| Transformations | Use [data transformations](./container-insights-transformations.md) in the DCR as a last resort for filtering data that you can't filter using other methods. While a powerful feature, transformations are more complex to implement. They also filter data after it's sent from the cluster, increasing your network usage. | [DCR](./container-insights-transformations.md) |

### Metrics

| Data | Description | Method |
|:---|:---|:---|
| Default targets | Either disable targets that are collected by default or enable additional targets.  | [ConfigMap](./prometheus-metrics-scrape-configuration.md#enable-and-disable-default-targets) |
| Default metrics | Customize the specific metrics collected from default targets.  | [ConfigMap](./prometheus-metrics-scrape-configuration.md#customize-metrics-collected-by-default-targets) |
| 
