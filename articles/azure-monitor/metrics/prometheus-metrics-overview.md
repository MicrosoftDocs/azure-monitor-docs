---
title: Overview of Azure Monitor with Prometheus
description: Get an overview of Azure Monitor with Prometheus, which provides Prometheus-compatible interfaces called Azure Monitor workspaces for storing and retrieving metric data.
ms.topic: concept-article
ms.date: 10/06/2024
---

# Azure Monitor and Prometheus

[Prometheus](http://promehteus.io) is a popular open-source monitoring and alerting solution that's widely used in the cloud-native ecosystem. Azure Monitor provides a fully managed service for Prometheus that enables you to collect, store, and analyze Prometheus metrics without maintaining your own Prometheus server. You can leverage this managed service to collect Prometheus metrics from your Kubernetes clusters and virtual machines, or you can integrate with it from your self-managed Prometheus servers.


## Azure Monitor managed service for Prometheus

Azure Monitor managed service for Prometheus provides a fully managed and scalable environment for running Prometheus. It simplifies the deployment, management, and scaling of Prometheus in AKS and Azure Arc-enabled Kubernetes so you can focus on monitoring your applications and infrastructure. As a fully managed service, it provides high availability, service-level agreement (SLA) guarantees, automatic software updates, and a highly scalable metrics store that retains data for up to 18 months.

Azure Monitor managed service for Prometheus provides preconfigured alerts, rules, and dashboards. It fully supports [Prometheus Query Language (PromQL)]([metrics-explorer.md](https://prometheus.io/docs/prometheus/latest/querying/basics/)) and provides [tools in the Azure portal](metrics-explorer.md) for interactively querying and visualizing Prometheus metrics. With recommended dashboards from the Prometheus community and native Grafana integration, you can achieve comprehensive monitoring immediately. It integrates with [Azure Managed Grafana](/azure/managed-grafana/overview), provides a seamless data source for [Azure Monitor dashboards with Grafana (preview)](../visualize/visualize-grafana-overview.md), and can also provide data for your existing self-managed Grafana environment.

:::image type="content" source="media/prometheus-metrics-overview/overview.png" alt-text="Diagram showing overview of Managed Prometheus and Azure Monitor tools that use it." lightbox="media/prometheus-metrics-overview/overview.png"  border="false":::

The only requirement to enable Azure Monitor managed service for Prometheus is to create an [Azure Monitor workspace](./prometheus-metrics-overview.md) which provides the storage for Prometheus metrics. Add Azure Monitor workspaces to separate data for different regions, environments, or teams. Onboarding for monitoring resources such as Azure Kubernetes Service (AKS) clusters guide you through the process of creating a new Azure Monitor workspace or connecting to an existing one.

## Pricing
There's no direct cost to Azure Monitor managed service for Prometheus or creating an Azure Monitor workspace. Pricing is based on ingestion and query of collected data. See the **Metrics** tab in [Azure Monitor pricing](https://azure.microsoft.com/pricing/details/monitor/) for details.

## Data collection
Azure Monitor managed service for Prometheus currently collects data directly from AKS and Azure Arc-enabled Kubernetes. [Container insights](../containers/kubernetes-monitoring-overview.md) provides an onboarding process that installs the [Azure Monitor agent](../agents/azure-monitor-agent-overview.md) in your cluster and creates a [data collection rule (DCR)](../data-collection/data-collection-rule-overview.md) that defines the data collection process and directs the data to the appropriate workspace. You can use the Azure portal to easily enable and configure monitoring or work directly with the DCR for more advanced scenarios.

See [Enable monitoring for Kubernetes clusters](../containers/kubernetes-monitoring-enable.md) to use Container insights to configure Managed Prometheus on your cluster. To enable managed Prometheus for Microsoft Azure air-gapped clouds, contact support.

## Integrate with self-managed Prometheus
Azure Monitor managed service for Prometheus is intended to be a replacement for self managed Prometheus so you don't need to manage a Prometheus server in your Kubernetes clusters. There may be scenarios though where you want to continue to use self-managed Prometheus in your Kubernetes clusters while also sending data to Managed Prometheus for long term data retention and to create a centralized view across your clusters. This may be a temporary solution while you migrate to Managed Prometheus or a long term solution if you have specific requirements to maintain self-managed Prometheus.

[Remote_write](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#remote_write) is a feature in Prometheus that allows you to send metrics from a local Prometheus instance to remote storage or to another Prometheus instance. Use this feature to send metrics from self-managed Prometheus running in your Kubernetes cluster or virtual machines to an Azure Monitor workspace used by Managed Prometheus. 

The following diagram illustrates this strategy. A [data collection rule (DCR)](../data-collection/data-collection-rule-overview.md) in Azure Monitor provides an endpoint for the self-managed Prometheus to send metrics to and defines the Azure Monitor workspace where the data will be sent.

:::image type="content" source="media/prometheus-remote-write-configure/overview.png" alt-text="Diagram showing use of remote-write to send metrics from local Prometheus to Managed Prometheus." lightbox="media/prometheus-remote-write-configure/overview.png"  border="false":::

See [Connect self-managed Prometheus to Azure Monitor managed service for Prometheus](prometheus-remote-write.md) to configure remote write to collect data from a self-managed Prometheus server.


## Querying and analyzing Prometheus metrics
Azure Monitor provides multiple tools for querying and analyzing Prometheus metrics stored in an Azure Monitor workspace. You can write your own queries using [PromQL](https://prometheus.io/docs/prometheus/latest/querying/basics/), use queries from the open-source community, and use and create Grafana dashboards. The following table describes the tools available for querying and analyzing Prometheus metrics stored in an Azure Monitor workspace.

| Tool | Description |
|:---|:---|
| Container insights | Container insights provides a variety of interactive views to analyze Prometheus metrics for your Kubernetes cluster. View high level metrics for your cluster or drill down to analyze detail metrics for the components of your cluster including nodes, controllers, and containers. See [Analyze Kubernetes cluster data with Container insights](../containers/container-insights-analyze.md). |
| Azure Monitor metrics explorer with PromQL | Use metrics explorer with PromQL (preview) to analyze and visualize platform and Prometheus metrics in the Azure portal. See [Azure Monitor metrics explorer with PromQL](metrics-explorer.md). |
| Azure Monitor workbooks | Create charts and dashboards powered by Azure Monitor managed service for Prometheus by using Azure workbooks and PromQL queries. See [Query Prometheus metrics using Azure workbooks](prometheus-workbooks.md). |
| Grafana | Visualize Prometheus metrics using [Grafana dashboards](https://grafana.com/) are a common solution to visualize Prometheus data, and a variety of community dashboards are available. [Azure Monitor dashboards with Grafana (preview)](../visualize/visualize-grafana-overview.md) provides a built-in experience at no cost. Use [Azure Managed Grafana](/azure/managed-grafana/overview) for dashboards combining different data sources. See [Visualize with Grafana](../visualize/visualize-grafana-overview.md). |
| Prometheus query API | Use PromQL with the REST API to query Prometheus metrics stored in an Azure Monitor workspace. For more information, see [Query Prometheus metrics using the API and PromQL](./prometheus-api-promql.mdprometheus-api-promql.md). |

## Rules and alerts

Prometheus supports recording rules and alert rules using PromQL queries. 

Azure Monitor managed service for Prometheus automatically deploys rules and alerts. Metrics that recording rules record are stored in the Azure Monitor workspace. Dashboards or other rules can then query the metrics.

Azure Monitor alerts proactively notify you of situations in your environment requiring attention. Managed Prometheus integrates [Prometheus alerts](https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/) with other alerts created by Azure Monitor. Container insights allows you to quickly enable a common set of Prometheus alerts for your Kubernetes cluster. See [](). 

You can create and manage alert rules and recording rules by using [Azure Monitor managed service for Prometheus rule groups](prometheus-rule-groups.md). For your AKS cluster, a set of [predefined Prometheus alert rules](../containers/container-insights-metric-alerts.md) and [recording rules](../containers/prometheus-metrics-scrape-default.md#recording-rules) helps you get started quickly.

Alerts that alert rules fire can trigger actions or notifications, as defined in the [action groups](../alerts/action-groups.md) configured for the alert rule. You can also view fired and resolved Prometheus alerts in the Azure portal, along with other alert types.

## Service limits and quotas

Azure Monitor managed service for Prometheus has default limits and quotas for ingestion. When you reach the ingestion limits, throttling can occur. You can request an increase in these limits. For more information, see [Azure Monitor service limits](../fundamentals/service-limits.md#prometheus-metrics).

To monitor and alert on your ingestion metrics, see [Monitor Azure Monitor workspace metrics ingestion](azure-monitor-workspace-monitor-ingest-limits.md).


[!INCLUDE [case sensitivity](includes/prometheus-case-sensitivity.md)]

[!INCLUDE [duplicate timeseries](includes/prometheus-duplicate-timeseries.md)]

## Metric names, label names & label values

Metrics scraping currently has the limitations in the following table:

| Property | Limit |
|:---|:---|
| Label name length | Less than or equal to 511 characters. When this limit is exceeded for any time-series in a job, the entire scrape job fails, and metrics get dropped from that job before ingestion. You can see up=0 for that job and also target Ux shows the reason for up=0. |
| Label value length | Less than or equal to 1023 characters. When this limit is exceeded for any time-series in a job, the entire scrape fails, and metrics get dropped from that job before ingestion. You can see up=0 for that job and also target Ux shows the reason for up=0. |
| Number of labels per time series | Less than or equal to 63. When this limit is exceeded for any time-series in a job, the entire scrape job fails, and metrics get dropped from that job before ingestion. You can see up=0 for that job and also target Ux shows the reason for up=0. |
| Metric name length | Less than or equal to 511 characters. When this limit is exceeded for any time-series in a job, only that particular series get dropped. MetricextensionConsoleDebugLog has traces for the dropped metric. |
| Label names with different casing | Two labels within the same metric sample, with different casing is treated as having duplicate labels and are dropped when ingested. For example, the time series `my_metric{ExampleLabel="label_value_0", examplelabel="label_value_1}` is dropped due to duplicate labels since `ExampleLabel` and `examplelabel` are seen as the same label name. |



## Related content

* [Enable monitoring for Kubernetes clusters](../containers/kubernetes-monitoring-enable.md)
* [Send Prometheus metrics from virtual machines, scale sets, or Kubernetes clusters to an Azure Monitor workspace](prometheus-remote-write-virtual-machines.md)
* [Enable Windows metrics collection (preview)](../containers/enable-windows-metrics.md)
* [Configure Azure Monitor managed service for Prometheus rule groups](prometheus-rule-groups.md)
* [Customize scraping of Prometheus metrics in Azure Monitor managed service for Prometheus](../containers/prometheus-metrics-scrape-configuration.md)
* [Troubleshoot collection of Prometheus metrics in Azure Monitor](../containers/prometheus-metrics-troubleshoot.md)


> [!IMPORTANT]
> The use of Azure Monitor to manage and host Prometheus is intended for storing information about the service health of customer machines and applications. It's not intended for storing any personal data. We strongly recommend that you don't send any sensitive information (for example, usernames and credit card numbers) into Azure Monitor-hosted Prometheus fields like metric names, label names, or label values.


> [!NOTE]
> Azure Managed Prometheus supports Horizontal Pod Autoscaling for replicaset pods in AKS Kubernetes clusters. See [Autoscaling](../containers/prometheus-metrics-scrape-autoscaling.md) to learn more.