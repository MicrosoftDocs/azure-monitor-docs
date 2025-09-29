---
title: Overview of Azure Monitor with Prometheus
description: Get an overview of Azure Monitor with Prometheus, which provides Prometheus-compatible interfaces called Azure Monitor workspaces for storing and retrieving metric data.
ms.topic: concept-article
ms.date: 09/06/2025
---

# Azure Monitor and Prometheus

[Prometheus](http://prometheus.io) is a popular open-source monitoring and alerting solution that's widely used in the cloud-native ecosystem. Azure Monitor provides a fully managed service for Prometheus that enables you to collect, store, and analyze Prometheus metrics without maintaining your own Prometheus server. You can leverage this managed service to collect Prometheus metrics from your Kubernetes clusters and virtual machines, or you can integrate with it from your self-managed Prometheus servers.


## Azure Monitor managed service for Prometheus

Azure Monitor managed service for Prometheus provides a fully managed and scalable environment for running Prometheus. It simplifies the deployment, management, and scaling of Prometheus in AKS and Azure Arc-enabled Kubernetes so you can focus on monitoring your applications and infrastructure. As a fully managed service, it provides high availability, service-level agreement (SLA) guarantees, automatic software updates, and a highly scalable metrics store that retains data for up to 18 months.

Azure Monitor managed service for Prometheus provides preconfigured alerts, rules, and dashboards. It fully supports [Prometheus Query Language (PromQL)](https://prometheus.io/docs/prometheus/latest/querying/basics/) and provides [tools in the Azure portal](metrics-explorer.md) for interactively querying and visualizing Prometheus metrics. With recommended dashboards from the Prometheus community and native Grafana integration, you can achieve comprehensive monitoring immediately. It integrates with [Azure Managed Grafana](/azure/managed-grafana/overview), provides a seamless data source for [Azure Monitor dashboards with Grafana (preview)](../visualize/visualize-grafana-overview.md), and can also provide data for your existing self-managed Grafana environment.

:::image type="content" source="media/prometheus-metrics-overview/overview.png" alt-text="Diagram showing overview of Managed Prometheus and Azure Monitor tools that use it." lightbox="media/prometheus-metrics-overview/overview.png"  border="false":::



## Benefits of Azure Monitor managed service for Prometheus

Key benefits of Azure Monitor managed service for Prometheus include:

- Fully managed service hosted in Azure:
  - Automatic upgrades and scaling.
  - Data retention for 18 months with no cost for storage.
  - [Simple pricing based on ingestion and query](https://azure.microsoft.com/pricing/details/monitor/).
- Monitoring and observability:
  - [End-to-end, at-scale monitoring](../containers/kubernetes-monitoring-overview.md).
  - Out-of-the-box dashboards, alerts, and scrape configurations.
  - Native integration with key Azure Kubernetes Service (AKS) components, including [Customer Control Plane](/azure/azure-resource-manager/management/control-plane-and-data-plane) and [Advanced Container Networking Services](/azure/aks/advanced-container-networking-services-overview).
  - [Compliance with Azure Trust Center](azure-monitor-workspace-overview.md#data-considerations).
- Native integration with other Azure services including [Azure Managed Grafana](/azure/managed-grafana/overview) or [Azure Monitor dashboards with Grafana](../visualize/visualize-use-grafana-dashboards.md).

## Pricing
There's no direct cost to Azure Monitor managed service for Prometheus or creating an Azure Monitor workspace. Pricing is based on ingestion and query of collected data. See the **Metrics** tab in [Azure Monitor pricing](https://azure.microsoft.com/pricing/details/monitor/) for details.

## Data collection
Azure Monitor managed service for Prometheus currently collects data directly from AKS and Azure Arc-enabled Kubernetes. Azure Monitor provides an [onboarding process](../containers/kubernetes-monitoring-overview.md) that installs the [Azure Monitor agent](../agents/azure-monitor-agent-overview.md) in your cluster and creates a [data collection rule (DCR)](../data-collection/data-collection-rule-overview.md) that defines the data collection process and directs the data to the appropriate workspace. You can use the Azure portal, CLI, PowerShell, and ARM/Bicep templates to easily enable and configure monitoring or work directly with ConfigMap and the DCR for more advanced scenarios.

See [Enable monitoring for Kubernetes clusters](../containers/kubernetes-monitoring-enable.md) for details on enabling Managed Prometheus on your cluster. To enable managed Prometheus for Microsoft Azure air-gapped clouds, contact support.

## Data storage
The only requirement to enable Azure Monitor managed service for Prometheus is to create an [Azure Monitor workspace](./prometheus-metrics-overview.md) which provides the storage for Prometheus metrics. Add Azure Monitor workspaces to separate data for different regions, environments, or teams. Onboarding for monitoring resources such as Azure Kubernetes Service (AKS) clusters guide you through the process of creating a new Azure Monitor workspace or connecting to an existing one. Data is stored for 18 months at no additional cost.

## Integrate with self-managed Prometheus
Azure Monitor managed service for Prometheus is intended to be a replacement for self managed Prometheus so you don't need to manage a Prometheus server in your Kubernetes clusters. There may be scenarios though where you want to continue to use self-managed Prometheus in your Kubernetes clusters while also sending data to Managed Prometheus for long term data retention and to create a centralized view across your clusters. This may be a temporary solution while you migrate to Managed Prometheus or a long term solution if you have specific requirements to maintain your existing environment.

[Remote_write](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#remote_write) is a feature in Prometheus that allows you to send metrics from a local Prometheus instance to remote storage or to another Prometheus instance. Use this feature to send metrics from self-managed Prometheus running in your Kubernetes cluster or virtual machines to an Azure Monitor workspace used by Managed Prometheus. 

The following diagram illustrates this strategy. A [data collection rule (DCR)](../data-collection/data-collection-rule-overview.md) in Azure Monitor provides an endpoint for the self-managed Prometheus to send metrics to and defines the Azure Monitor workspace where the data will be sent.

:::image type="content" source="media/prometheus-remote-write/overview.png" alt-text="Diagram showing use of remote-write to send metrics from local Prometheus to Managed Prometheus." lightbox="media/prometheus-remote-write/overview.png"  border="false":::

See [Connect self-managed Prometheus to Azure Monitor managed service for Prometheus](prometheus-remote-write.md) to configure remote write to collect data from a self-managed Prometheus server.


## Querying and analyzing Prometheus metrics
Azure Monitor provides multiple tools for querying and analyzing Prometheus metrics stored in an Azure Monitor workspace. You can write your own queries using [PromQL](https://prometheus.io/docs/prometheus/latest/querying/basics/), use queries from the open-source community, and use and create Grafana dashboards. The following table describes the tools available for querying and analyzing Prometheus metrics stored in an Azure Monitor workspace.

| Tool | Description |
|:---|:---|
| Container insights | Container insights provides a variety of interactive views to analyze Prometheus metrics for your Kubernetes cluster. View high level metrics for your cluster or drill down to analyze detail metrics for the components of your cluster including nodes, controllers, and containers. See [Analyze Kubernetes cluster data with Container insights](../containers/container-insights-analyze.md). |
| Azure Monitor metrics explorer with PromQL | Use metrics explorer with PromQL (preview) to analyze and visualize platform and Prometheus metrics in the Azure portal. See [Azure Monitor metrics explorer with PromQL](./metrics-explorer.md). |
| Azure Monitor workbooks | Create charts and dashboards powered by Azure Monitor managed service for Prometheus by using Azure workbooks and PromQL queries. See [Query Prometheus metrics using Azure workbooks](prometheus-workbooks.md). |
| Grafana | Visualize Prometheus metrics using [Grafana dashboards](https://grafana.com/) are a common solution to visualize Prometheus data, and a variety of community dashboards are available. [Azure Monitor dashboards with Grafana (preview)](../visualize/visualize-grafana-overview.md) provides a built-in experience at no cost. Use [Azure Managed Grafana](/azure/managed-grafana/overview) for dashboards combining different data sources. See [Visualize with Grafana](../visualize/visualize-grafana-overview.md). |
| Prometheus query API | Use PromQL with the REST API to query Prometheus metrics stored in an Azure Monitor workspace. For more information, see [Query Prometheus metrics using the API and PromQL](./prometheus-api-promql.md). |

## Rules and alerts

[Recording rules](https://prometheus.io/docs/prometheus/latest/configuration/recording_rules/) in Prometheus allow you to precompute values stored in the time series, while [alert rules](https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/) provide proactive notification of predefined conditions in your collected metrics. Azure Monitor managed service for Prometheus automatically deploys a predefined set of recording rules, and Container insights allows you to easily enable a set of common alert rules for Kubernetes clusters. 

Recording and alert rules are stored in the Azure Monitor workspace, and you can easily manage existing rules and manually create custom rules using a variety of methods such as the Azure portal, CLI, Bicep, and ARM. See [Azure Monitor managed service for Prometheus rule groups](./prometheus-rule-groups.md) for details.


## Related content

* [Enable monitoring for Kubernetes clusters](../containers/kubernetes-monitoring-enable.md)
* [Send Prometheus metrics from virtual machines, scale sets, or Kubernetes clusters to an Azure Monitor workspace](prometheus-remote-write-virtual-machines.md)
* [Enable Windows metrics collection (preview)](../containers/enable-windows-metrics.md)
* [Configure Azure Monitor managed service for Prometheus rule groups](prometheus-rule-groups.md)
* [Customize scraping of Prometheus metrics in Azure Monitor managed service for Prometheus](../containers/prometheus-metrics-scrape-configuration.md)
* [Troubleshoot collection of Prometheus metrics in Azure Monitor](../containers/prometheus-metrics-troubleshoot.md)
