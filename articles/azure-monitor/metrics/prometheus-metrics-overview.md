---
title: Overview of Azure Monitor with Prometheus
description: Get an overview of Azure Monitor with Prometheus, which provides Prometheus-compatible interfaces called Azure Monitor workspaces for storing and retrieving metric data.
ms.topic: concept-article
ms.date: 10/06/2024
---

# Azure Monitor and Prometheus

Prometheus is a popular open-source monitoring and alerting solution that's widely used in the cloud-native ecosystem. Organizations use Prometheus to monitor and alert on the performance of infrastructure and workloads. It's often used in Kubernetes environments.

You can use Prometheus as an Azure-managed service or as a self-managed service to collect metrics. Prometheus metrics can be collected from your Azure Kubernetes Service (AKS) clusters, Azure Arc-enabled Kubernetes clusters, virtual machines, and virtual machine scale sets.

Prometheus metrics are stored in an Azure Monitor workspace. You can analyze and visualize the data in a workspace by using [metrics explorer with Prometheus Query Language (PromQL)](metrics-explorer.md) and [Azure Managed Grafana](/azure/managed-grafana/overview).

> [!IMPORTANT]
> The use of Azure Monitor to manage and host Prometheus is intended for storing information about the service health of customer machines and applications. It's not intended for storing any personal data. We strongly recommend that you don't send any sensitive information (for example, usernames and credit card numbers) into Azure Monitor-hosted Prometheus fields like metric names, label names, or label values.

## Azure Monitor managed service for Prometheus

Azure Monitor managed service for Prometheus is a component of [Azure Monitor Metrics](data-platform-metrics.md) that provides a fully managed and scalable environment for running Prometheus. It simplifies the deployment, management, and scaling of Prometheus in AKS and Azure Arc-enabled Kubernetes, so you can focus on monitoring your applications and infrastructure.

As a fully managed service, Azure Monitor managed service for Prometheus automatically deploys Prometheus in AKS or Azure Arc-enabled Kubernetes. The service provides high availability, service-level agreement (SLA) guarantees, and automatic software updates. It provides a highly scalable metrics store that retains data for up to 18 months.

Azure Monitor managed service for Prometheus provides preconfigured alerts, rules, and dashboards. With recommended dashboards from the Prometheus community and native Grafana integration, you can achieve comprehensive monitoring immediately. Azure Monitor managed service for Prometheus integrates with Azure Managed Grafana, and it also works with self-managed Grafana.

Pricing is based on ingestion and query with no additional storage cost. For more information, see the **Metrics** tab in [Azure Monitor pricing](https://azure.microsoft.com/pricing/details/monitor/).

> [!NOTE]
> Azure Managed Prometheus supports Horizontal Pod Autoscaling for replicaset pods in AKS Kubernetes clusters. See [Autoscaling](../containers/prometheus-metrics-scrape-autoscaling.md) to learn more.

### Enable Azure Monitor managed service for Prometheus

Azure Monitor managed service for Prometheus collects data from AKS and Azure Arc-enabled Kubernetes.

To enable Azure Monitor managed service for Prometheus, you must create an [Azure Monitor workspace](azure-monitor-workspace-overview.md) to store the metrics. You can then onboard services that collect Prometheus metrics:

* To collect Prometheus metrics from your Kubernetes cluster, see [Enable Prometheus and Grafana](../containers/kubernetes-monitoring-enable.md#enable-prometheus-and-grafana).
* To configure remote write to collect data from a self-managed Prometheus server, see [Send Prometheus metrics from virtual machines, scale sets, or Kubernetes clusters to an Azure Monitor workspace](prometheus-remote-write-virtual-machines.md).

To enable managed Prometheus for Microsoft Azure air-gapped clouds, contact support.

## Azure-hosted self-managed Prometheus

In addition to managed service for Prometheus, you can install and manage your own Prometheus instance and use remote write to store metrics in an Azure Monitor workspace.

By using remote write, you can collect data from self-managed Prometheus servers running in the following environments:

* Azure virtual machines
* Azure virtual machine scale sets
* Azure Arc-enabled servers
* Self-manged Azure-hosted or Azure Arc-enabled Kubernetes clusters

### Self-managed Kubernetes services

Send metrics from self-managed Prometheus on Kubernetes clusters. For more information on remote write to Azure Monitor workspaces for Kubernetes services, see the following articles:

* [Send Prometheus data to Azure Monitor by using managed identity authentication](../containers/prometheus-remote-write-managed-identity.md)
* [Send Prometheus data to Azure Monitor by using Microsoft Entra authentication](../containers/prometheus-remote-write-active-directory.md)
* [Send Prometheus data to Azure Monitor by using Microsoft Entra pod-managed identity (preview) authentication](../containers/prometheus-remote-write-azure-ad-pod-identity.md)
* [Send Prometheus data to Azure Monitor by using Microsoft Entra Workload ID authentication](../containers/prometheus-remote-write-azure-workload-identity.md)

### Virtual machines and virtual machine scale sets

Send data from self-managed Prometheus on virtual machines and virtual machine scale sets. The virtual machines can be in an Azure-managed environment or on-premises. For more information, see [Send Prometheus metrics from virtual machines, scale sets, or Kubernetes clusters to an Azure Monitor workspace](prometheus-remote-write-virtual-machines.md).

## Data storage

Prometheus metrics are stored in an Azure Monitor workspace. The data is stored in a time-series database that can be queried via PromQL. You can store data from several Prometheus data sources in a single Azure Monitor workspace. For more information, see [Azure Monitor workspace architecture](azure-monitor-workspace-overview.md?#azure-monitor-workspace-architecture).

Azure Monitor workspaces retain data for 18 months.

## Querying and analyzing Prometheus metrics

Prometheus data is retrieved via PromQL. You can write your own queries, use queries from the open-source community, and use Grafana dashboards that include PromQL queries. For more information, see the [Querying Prometheus](https://prometheus.io/docs/prometheus/latest/querying/basics/) on the Prometheus website.

The following Azure services support querying Prometheus metrics from an Azure Monitor workspace:

* [Azure Monitor metrics explorer with PromQL](metrics-explorer.md)
* [Azure Monitor workbooks](../visualize/workbooks-overview.md)
* [Azure Managed Grafana](/azure/managed-grafana/overview)
* [Prometheus query APIs](prometheus-api-promql.md)

### Azure Monitor metrics explorer with PromQL

Use metrics explorer with PromQL (preview) to analyze and visualize platform and Prometheus metrics. Metrics explorer with PromQL is available from the **Metrics** pane in the Azure Monitor workspace where your Prometheus metrics are stored. For more information, see [Azure Monitor metrics explorer with PromQL](metrics-explorer.md).

:::image type="content" source="./media/prometheus-metrics-overview/metrics-explorer.png" alt-text="Screenshot of a PromQL query in Azure Monitor metrics explorer." lightbox="./media/prometheus-metrics-overview/metrics-explorer.png":::

### Azure workbooks

Create charts and dashboards powered by Azure Monitor managed service for Prometheus by using Azure workbooks and PromQL queries. For more information, see [Query Prometheus metrics using Azure workbooks](prometheus-workbooks.md).

### Grafana integration

Visualize Prometheus metrics by using [Azure Managed Grafana](/azure/managed-grafana/overview). Connect your Azure Monitor workspace to a Grafana workspace so that you can use it as a data source in a Grafana dashboard. You then have access to multiple prebuilt dashboards that use Prometheus metrics. You also have the ability to create any number of custom dashboards. For more information, see [Link a Grafana workspace](azure-monitor-workspace-manage.md#link-a-grafana-workspace).

### Prometheus query API

Use PromQL via the REST API to query Prometheus metrics stored in an Azure Monitor workspace. For more information, see [Query Prometheus metrics using the API and PromQL](prometheus-api-promql.md).

## Rules and alerts

Prometheus supports recording rules and alert rules by using PromQL queries. Azure Monitor managed service for Prometheus automatically deploys rules and alerts. Metrics that recording rules record are stored in the Azure Monitor workspace. Dashboards or other rules can then query the metrics.

You can create and manage alert rules and recording rules by using [Azure Monitor managed service for Prometheus rule groups](prometheus-rule-groups.md). For your AKS cluster, a set of [predefined Prometheus alert rules](../containers/container-insights-metric-alerts.md) and [recording rules](../containers/prometheus-metrics-scrape-default.md#recording-rules) helps you get started quickly.

Alerts that alert rules fire can trigger actions or notifications, as defined in the [action groups](../alerts/action-groups.md) configured for the alert rule. You can also view fired and resolved Prometheus alerts in the Azure portal, along with other alert types.

## Service limits and quotas

Azure Monitor managed service for Prometheus has default limits and quotas for ingestion. When you reach the ingestion limits, throttling can occur. You can request an increase in these limits. For more information, see [Azure Monitor service limits](../fundamentals/service-limits.md#prometheus-metrics).

To monitor and alert on your ingestion metrics, see [Monitor Azure Monitor workspace metrics ingestion](azure-monitor-workspace-monitor-ingest-limits.md).

## Limitations

The following limitations apply to Azure Monitor managed service for Prometheus:

* The minimum frequency for scraping and storing metrics is 1 second.
* During node updates, you might experience gaps that last 1 to 2 minutes in some metric collections from the cluster-level collector. This gap is due to a regular action from Azure Kubernetes Service to update the nodes in your cluster. This behavior doesn't affect recommended alert rules.
* Managed Prometheus for Windows nodes isn't automatically enabled. To enable monitoring for Windows nodes and pods in your clusters, see [Enable Windows metrics collection (preview)](../containers/kubernetes-monitoring-enable.md#enable-windows-metrics-collection-preview).

[!INCLUDE [case sensitivity](includes/prometheus-case-sensitivity.md)]

[!INCLUDE [duplicate timeseries](includes/prometheus-duplicate-timeseries.md)]

## Metric names, label names & label values

| Property | Limit |
|:---|:---|
| Label name length | Less than or equal to 511 characters. When this limit is exceeded for any time-series in a job, the entire scrape job fails, and metrics get dropped from that job before ingestion. You can see up=0 for that job and also target Ux shows the reason for up=0. |
| Label value length | Less than or equal to 1023 characters. When this limit is exceeded for any time-series in a job, the entire scrape fails, and metrics get dropped from that job before ingestion. You can see up=0 for that job and also target Ux shows the reason for up=0. |
| Number of labels per time series | Less than or equal to 63. When this limit is exceeded for any time-series in a job, the entire scrape job fails, and metrics get dropped from that job before ingestion. You can see up=0 for that job and also target Ux shows the reason for up=0. |
| Metric name length | Less than or equal to 511 characters. When this limit is exceeded for any time-series in a job, only that particular series get dropped. MetricextensionConsoleDebugLog has traces for the dropped metric. |
| Label names with different casing | Two labels within the same metric sample, with different casing is treated as having duplicate labels and are dropped when ingested. For example, the time series `my_metric{ExampleLabel="label_value_0", examplelabel="label_value_1}` is dropped due to duplicate labels since `ExampleLabel` and `examplelabel` are seen as the same label name. |

## Prometheus references

Following are links to Prometheus documentation:

* [Querying Prometheus](https://aka.ms/azureprometheus-promio-promql)
* [Grafana support for Prometheus](https://aka.ms/azureprometheus-promio-grafana)
* [Defining recording rules](https://aka.ms/azureprometheus-promio-recrules)
* [Alerting rules](https://aka.ms/azureprometheus-promio-alertrules)
* [Writing exporters](https://aka.ms/azureprometheus-promio-exporters)

## Related content

* [Enable monitoring for Kubernetes clusters](../containers/kubernetes-monitoring-enable.md)
* [Send Prometheus metrics from virtual machines, scale sets, or Kubernetes clusters to an Azure Monitor workspace](prometheus-remote-write-virtual-machines.md)
* [Enable Windows metrics collection (preview)](../containers/kubernetes-monitoring-enable.md#enable-windows-metrics-collection-preview)
* [Configure Azure Monitor managed service for Prometheus rule groups](prometheus-rule-groups.md)
* [Customize scraping of Prometheus metrics in Azure Monitor managed service for Prometheus](../containers/prometheus-metrics-scrape-configuration.md)
* [Troubleshoot collection of Prometheus metrics in Azure Monitor](../containers/prometheus-metrics-troubleshoot.md)
