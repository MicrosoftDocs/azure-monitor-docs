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

There are two methods to define the configuration the agent will use to collect data. Each method controls different aspects of data collection, so you need to use both methods together to achieve your requirements. While both logs and metrics use the same configuration options, configuration for each data type is done separately.

| Method | Description |
|:---|:---|
| ConfigMap | [ConfigMaps](https://kubernetes.io/docs/concepts/configuration/configmap/) in Kubernetes store configuration data for applications running in the cluster. Multiple ConfigMaps are provided by Microsoft for both logs and metrics that are read by the Azure Monitor agent to modify different aspects of data collected by the agent from the cluster. Modify these ConfigMaps and apply them to your cluster to customize data collection for each data type. |
| Data Collection Rule (DCR) | [Data collection rules (DCRs)](../data-collection/data-collection-rule-overview.md) in Azure Monitor define what data is collected from a monitored resource and where that data is sent. Separate DCRs are automatically created for logs and metrics when you enable monitoring for your Kubernetes cluster. Some settings in the DCR are read by the agent to determine the data it collects by the cluster. Other settings are used by Azure Monitor to determine how to process that data after it's sent from the cluster. This includes [transformations](../data-collection/data-collection-rule-transformations.md), which provide advanced filtering and manipulation of data before it's ingested into the Log Analytics workspace. |

The following image illustrates how each of the configuration methods is used in the collection of data from your Kubernetes clusters. There is only one DCR used for logs collection. It's shown twice in the image to illustrate that some information in the DCR is used by the agent at the cluster level, while other information in the DCR is used by Azure Monitor after that data is delivered.

:::image type="content" source="./media/kubernetes-data-collection-configure.md/data-configuration-options.png" lightbox="./media/kubernetes-data-collection-configure.md/data-configuration-options.png" alt-text="{alt-text}":::

The following table provides a comparison of the two configuration methods. Most settings are only available in one of the methods, so you don't have the option to choose which method to use. There are some [common settings](#common-settings) that can be configured with either method, but there are important differences in how they work. In those cases, you can select the method that best meets your requirements.

| | ConfigMap | Data Collection Rule (DCR) |
|:---|:---|:---|
| Logs | - Enable/disable container logs separately<br>- Namespace filtering for container logs<br>- Annotation filtering<br>- Collect environment variables | - Enable/disable all container logs<br>- Namespace filtering for other logs<br>- Specify collected tables<br>- Log Analytics workspace(s)<br>- Custom filtering with transformations |
| Metrics | - Enable/disable targets<br>- Enable/disable specific metrics<br>- Annotation-based scraping  | - Azure Monitor workspace(s) |
| Deployment | - Apply ConfigMap to each cluster.<br>- Requires redeployment for changes. | - Configure single DCR for multiple clusters<br>- Modify DCR with no restart required |


## Common settings
Some settings can be configured with both ConfigMap and DCR, but there are important differences as described in the following table.

| Setting | Recommendation |
|:---|:---|
| Container logs | Container logs are stdout/stderr logs from the cluster. For container logs to be collected, they must be enabled in both ConfigMap and DCR (ContainerLogV2 stream). ConfigMap allows you to separately enable stdout and stderr logs. If you disable either of the logs in ConfigMap, they won't be collected. |
| Namespace filtering | Namespace filtering is configured in both the ConfigMap and DCR but for different logs. Namespace filtering in ConfigMap only applies to container logs and can be configured separately for stdout and stderr logs. Namespace filtering in the DCR applies to all other logs. To fully exclude a namespace from log collection, you must exclude it in both places. |


## ConfigMap configuration
Separate ConfigMaps are provided for logs and metrics as described below. Both logs and metrics have a default configuration applied when you [enable monitoring for your cluster](./kubernetes-monitoring-enable.md#enable-prometheus-metrics-and-container-logging). Use these ConfigMaps to modify the default configuration to meet your requirements.

| Data | Description |
|:---|:---|
| Logs | The ConfigMap used for log collection is [container-azm-ms-agentconfig.yaml](https://aka.ms/container-azm-ms-agentconfig). See [Filter container log collection with ConfigMap](./container-insights-data-collection-configmap.md) for a description of each of the available settings and how to modify and apply this ConfigMap to your cluster. The [ConfigMap settings](./container-insights-data-collection-configmap.md#configmap-settings) section in that article provides the default values for each setting that are used before a ConfigMap is applied. |
| Metrics | See [Default Prometheus metrics configuration in Azure Monitor](./prometheus-metrics-scrape-default.md) for the metrics that are collected by default from your cluster. The ConfigMap used to modify this configuration is [ama-metrics-settings-configmap](https://aka.ms/azureprometheus-addon-settings-configmap). See [Customize collection of Prometheus metrics from your Kubernetes cluster using ConfigMap](./prometheus-metrics-scrape-configuration.md) for a description of each of the available settings and how to modify and apply this ConfigMap to your cluster. Other ConfigMaps are available to create custom scrape jobs. See [Create custom Prometheus scrape job from your Kubernetes cluster using ConfigMap](./prometheus-metrics-scrape-configmap.md) for details on how to use these ConfigMaps. |



## DCR configuration
When you enable log collection for your cluster, separate DCRs are automatically created for logs and metrics that include the settings that you specified in the [onboarding process](./kubernetes-monitoring-enable.md#enable-prometheus-metrics-and-container-logging). See [DCRs and related resources](#dcrs-and-related-resources) below for details of the DCRs and related objects that are created during onboarding.


| Data | Description |
|:---|:---|
| Metrics | The DCR for metrics is called `MSProm-<region>-<cluster name>`. It includes the Azure Monitor workspace but is used minimally to define details for the metrics collected. Use `ConfigMap` instead to configure these details. The primary scenario for modifying the DCR is to send metrics to multiple Azure Monitor workspaces as described in [Send Prometheus metrics to multiple Azure Monitor workspaces](./prometheus-metrics-multiple-workspaces.md). |
| Logs | The DCR for logs is called `MSCI-<region>-<cluster name>`. It includes the Log Analytics workspace and other configuration that's specified in the onboarding process, such as streams of data collected and namespace filtering. You can use the same methods to modify these settings after onboarding. For example, select a different **Logs preset** in the Azure portal to change the streams collected, or run a CLI command with a new log configuration file to add namespace filtering. In these cases, you don't need to work interactively with the DCR. Alternatively, you can [modify the DCR directly](../data-collection/data-collection-rule-create-edit.md) to change these settings. You can also directly modify the DCR to achieve the advanced scenarios described below. |


## Advanced filtering

[Transformations](../data-collection/data-collection-transformations.md) in DCRs allow you to apply a KQL query to filter and manipulate data sent to Azure Monitor before it's ingested into the Log Analytics workspace. This allows you to enrich or sanitize data before ingestion for compliance and cost optimization. Examples include filtering rows and columns of incoming data, masking sensitive fields, and creating new calculated fields. See [Advanced filtering and transformations for Kubernetes logs in Azure Monitor](./container-insights-transformations.md) for details on how to implement transformations for logs collected from your Kubernetes clusters.

> [!NOTE]
> Transformations only apply to data sent to a Log Analytics workspace, so they can't be used to filter metrics data which is sent to an Azure Monitor workspace.


## Send to multiple workspaces and tables
The DCR specifies the workspace and table where data is sent. A DCR for Kubernetes can only specify a single Log Analytics workspace for log data and a single Azure Monitor workspace for metrics data. You can create to create additional DCRs and associate them with your cluster though. For example, you may have different teams responsible for different applications running in the same cluster, and each team requires their own set of data. See [Send Prometheus metrics to multiple Azure Monitor workspaces](./prometheus-metrics-multiple-workspaces.md) for a detailed example that uses both the ConfigMap and DCR.

Log Analytics workspaces have different data tiers that provide different capabilities and costs. You can reduce your monitoring costs by sending certain data to tables configured for lower-cost. Rather than configuring an entire table for another tier, for example configuring ContainerLogV2 for [basic logs](../logs/manage-logs-tables.md#table-type-and-schema), you can use transformations in the DCR to select data to send to different tables configured for different tiers. See [Send data to different tables](./control-plane-transformations.md#send-data-to-different-tables) for a detailed example.

## Share a DCR with multiple clusters
If you have multiple clusters that use the same configuration, they can share a single DCR. This strategy reduces management overhead and ensures consistency across your clusters, especially when implementing complex configurations such as using transformations for advanced filtering. A single cluster can also be associated with multiple DCRs, each defining different data to collect.

To use a common DCR for multiple clusters, remove the association from each cluster's current DCR and create a new association to the shared DCR. Once the cluster is associated with the common DCR, you can remove the old DCR. See [Manage data collection rule associations in Azure Monitor](../data-collection/data-collection-rule-associations.md) for different methods to manage DCR associations. 


## DCRs and related resources

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




