---
title: Filter container log collection with ConfigMap
description: Options for filtering Container insights data that you don't require.
ms.topic: how-to
ms.date: 09/22/2025
ms.reviewer: aul
---

# Customize log and metric collection for Kubernetes clusters
The data that Azure Monitor initially collects from your Kubernetes clusters depends on the options you chose when you [enabled collection of logs and metrics](./kubernetes-monitoring-enable.md). After this initial onboarding, you can further customize the data collection either to add data that you require to properly monitor your Kubernetes environment, or to filter out data that you don't need to reduce your monitoring costs. You can further optimize costs by sending different types of data to different storage . 
 
This article describes the different types of customization you can perform for data collection from your Kubernetes clusters and the methods required to implement each. Links are provided to detailed instructions for each method.

## Types of data
There are two fundamental types of data that Azure Monitor collects from your Kubernetes clusters: logs and metrics. The configuration methods to customize each are similar but have some differences as described in the sections below.

| Data | Description | Destination |
|:---|:---|:---|
| Logs | Logs collected for a Kubernetes cluster typically include container logs from pods (stdout/stderr) and system logs from nodes and control plane components, providing visibility into application behavior and cluster health for troubleshooting and monitoring. In addition to filtering for logs that you don't require and adding logs that aren't collected by default, you may want to send different logs to different storage tiers to optimize your costs.  | Log Analytics workspace |
| Metrics | Numerical values that represent the state and performance of various components in your Kubernetes cluster. You may want to filter metrics that you don't require or add metrics that aren't collected by default. | Azure Monitor workspace |

## Configuration methods
When you enable monitoring for a Kubernetes cluster in Azure Monitor, the [Azure Monitor agent (AMA)](../agents/azure-monitor-agent-overview.md) is installed in the cluster. This agent is responsible for collecting logs and metrics from the cluster and sending them to Azure Monitor. There are two methods to define the configuration the agent will use to collect data. Each method controls different aspects of data collection, so you need to use both methods together to achieve your requirements. For some configuration options, you can choose either method.


| Method | Description |
|:---|:---|
| ConfigMap | [ConfigMaps](https://kubernetes.io/docs/concepts/configuration/configmap/) in Kubernetes store configuration data for applications running in the cluster. Multiple ConfigMaps are provided by Microsoft that are read by the Azure Monitor to modify different aspects of data collection. Modify these ConfigMaps to customize data collection for these data types. |
| Data Collection Rule (DCR) | [Data collection rules (DCRs)](../data-collection/data-collection-rule-overview.md) in Azure Monitor define what data is collected from a monitored resource and where it's sent and also allow you to perform advanced configurations using [transformations](../data-collection/data-collection-rule-transformations.md) which filter and transform data before it's ingested into the Log Analytics workspace. DCRs are automatically created  |



:::image type="content" source="./media/kubernetes-data-collection-configure/custom-data-collection.png" lightbox="./media/kubernetes-data-collection-configure/custom-data-collection.png" alt-text="{alt-text}":::

:::image type="content" source="./media/kubernetes-data-collection-configure/data-configuration-options.png" lightbox="./media/kubernetes-data-collection-configure/data-configuration-options.png" alt-text="{alt-text}":::

### Logs

| Data | Method |
|:---|:---|
| Collected tables | There are multiple types of logs that Azure Monitor can collect listed in [Stream values](./containers/kubernetes-monitoring-enable.md?tabs=cli#stream-values). These are defined exclusively in the DCR. Modify the tables collected using the Azure portal as described at [Configuration options](./containers/kubernetes-monitoring-enable.md?tabs=portal#configuration-options) or by manually modifying the DCR. |
| Container logs | Container logs are stdout/stderr logs that are sent to ContainerLogsV2 in the Log Analytics workspace. You can enable or disable collection of these logs using either the ConfigMap or the DCR. With ConfigMap, you can control stdout and stderr separately, while the DCR can only enable or disable collection of both together. |
| Namespaces | Filter logs for namespaces that you don't need to monitor. You may also want to enable platform logs which are disabled by default in order to support specific troubleshooting scenarios. Namespace filtering for container logs is done in ConfigMap. Filtering for other logs is done with the DCR. |
| Annotation filtering | Exclude log collection for certain pods and containers by annotating the pod. This is done with ConfigMap.  |
| Environment variables | ConfigMap |
| Metadata enrichment | ConfigMap |
| Transformations | Use [data transformations](./container-insights-transformations.md) in the DCR as a last resort for filtering data that you can't filter using other methods. While a powerful feature, transformations are more complex to implement. They also filter data after it's sent from the cluster, increasing your network usage. 

### Metrics

| Data | Method |
|:---|:---|
|  | |



## Comparison

| | ConfigMap | Data Collection Rule (DCR) |
|:---|:---|:---|
| Log filters | - Enable/disable container logs separately<br>- Namespace filtering for container logs<br>- Annotation filtering<br>- Environment variables | - Collected tables<br>- Enable/disable container logs<br>- Namespace filtering<br>- Custom filtering |
| Metrics filters | - Enable/disable targets<br>- Enable/disable specific metrics<br>- Annotation-based scraping  |
| Deployment | - Each cluster requires own ConfigMap.<br>- Requires redeployment for changes. | - Configure single DCR for multiple clusters<br>- Modify DCR with no restart required |


## ConfigMap configuration

Default configuration
- Logs
  - Depends on onboarding options chosen. See [Enable Prometheus metrics and container logging](./kubernetes-monitoring-enable.md#enable-prometheus-metrics-and-container-logging) for details.
- Metrics
  - [Default Prometheus metrics configuration in Azure Monitor](./prometheus-metrics-scrape-default.md)

- Metrics
  - [Default Prometheus metrics configuration in Azure Monitor](./prometheus-metrics-scrape-default.md)
  - [Customize collection of Prometheus metrics from your Kubernetes cluster using ConfigMap](./prometheus-metrics-scrape-configuration.md)
  - [Create custom Prometheus scrape job from your Kubernetes cluster using ConfigMap](./prometheus-metrics-scrape-configmap.md)
- Logs
  - [Filter container log collection with ConfigMap](./container-insights-data-collection-filter.md)



## DCR configuration
When you enable log collection for your cluster, a DCR is automatically created that includes the following settings that you specified in the onboarding process. See [Enable Prometheus metrics and container logging](./kubernetes-monitoring-enable.md#enable-prometheus-metrics-and-container-logging) for specifying these methods using different onboarding options.

You can use the same methods to modify these settings after onboarding. For example, select a different **Logs preset** in the Azure portal to change the streams collected. Or run a CLI command to select a different Log Analytics workspace. 

- Log Analytics workspace
- Streams to collect

Alternatively, you can modify the DCR directly to change these settings. See [Create data collection rules (DCRs) in Azure Monitor](../data-collection/data-collection-rule-create-edit.md) for methods to edit an existing DCR.

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
