---
title: Azure Monitor data platform
description: Overview of the Azure Monitor data platform and collection of observability data.
ms.topic: concept-article
ms.date: 08/07/2026
ms.reviewer:
ai-usage: ai-assisted
---

# Azure Monitor data platform

Distributed applications span cloud and on-premises services across many layers and components. Observability depends on collecting operational data from every layer, then analyzing and consolidating it into views that serve each stakeholder in your organization.

[Azure Monitor](overview.md) collects and aggregates data from various sources into a common data platform for analysis, visualization, and alerting. It provides a consistent experience across data from multiple sources and gives you deep insights into all your monitored resources, including data from other services that store their data in Azure Monitor.

:::image type="content" source="media/overview/overview-simple-20230707-opt.svg" alt-text="Diagram that shows an overview of Azure Monitor with data sources on the left sending data to a central data platform and features of Azure Monitor on the right that use the collected data." border="false" lightbox="media/overview/overview-blowout-20230707-opt.svg":::

## Observability data in Azure Monitor

Metrics, logs, and distributed traces are commonly referred to as the three pillars of observability. A monitoring tool must collect and analyze these three different kinds of data to provide sufficient observability of a monitored system. Observability can be achieved by correlating data from multiple pillars and aggregating data across the entire set of resources being monitored. Because Azure Monitor stores data from multiple sources together, the data can be correlated and analyzed by using a common set of tools. It also correlates data across multiple Azure subscriptions and tenants, in addition to hosting data for other services.

Azure resources generate a significant amount of monitoring data. Azure Monitor consolidates this data along with monitoring data from other sources into either a Metrics or Logs platform. Each platform is optimized for particular monitoring scenarios, and each supports different features in Azure Monitor. Features such as data analysis, visualization, and alerting require an understanding of these differences to implement your scenario in the most efficient and cost-effective manner. Insights in Azure Monitor such as [Application Insights](../app/app-insights-overview.md) or [Container Insights](../containers/kubernetes-monitoring-overview.md) provide analysis tools that focus on a particular monitoring scenario without requiring you to understand the differences between the two types of data.

The following table compares metrics and logs at a glance:

| Aspect | Metrics | Logs |
| --- | --- | --- |
| What it is | Numerical values sampled at regular intervals that describe an aspect of a system at a point in time. | Timestamped records of events that contain structured or free-form text. |
| Storage | Time-series database optimized for time-stamped data. | Log Analytics workspace built on Azure Data Explorer. |
| Best for | Alerting and fast detection of performance issues. | Root-cause analysis and deep, contextual queries. |
| Query experience | Metrics Explorer and metric alerts. | Kusto Query Language (KQL) in Log Analytics. |

### Metrics in Azure Monitor

[Metrics](../metrics/data-platform-metrics.md) are numerical values that describe some aspect of a system at a particular point in time. Azure Monitor collects metrics at regular intervals and identifies them with a timestamp, a name, a value, and one or more defining labels. It aggregates metrics by using various algorithms, compares them to other metrics, and analyzes them for trends over time.

Azure Monitor stores metrics in a time-series database that's optimized for analyzing time-stamped data. Time-stamping makes metrics well suited for alerting and fast detection of problems. Metrics tell you how your system is performing but typically must be combined with logs to identify the root cause of problems.

Azure Monitor Metrics includes two types: native metrics and Prometheus metrics. For a comparison of the two and their sources of data, see [Metrics in Azure Monitor](../metrics/data-platform-metrics.md).

### Logs in Azure Monitor

[Logs](../logs/data-platform-logs.md) are events that occurred within the system. They can contain different kinds of data and might be structured or freeform text with a timestamp. They might be created sporadically as events in the environment generate log entries. A system under heavy load typically generates more log volume.

Logs in Azure Monitor are stored in a Log Analytics workspace that's based on [Azure Data Explorer](/azure/data-explorer/), which provides a powerful analysis engine and [rich query language](/azure/kusto/query/). Logs typically provide enough information to provide complete context of the issue being identified and are valuable for identifying the root cause of issues.

> [!NOTE]
> It's important to distinguish between Azure Monitor Logs and sources of log data in Azure. For example, subscription-level events in Azure are written to an [Activity log](data-sources.md), available from the Azure Monitor menu. Most resources write operational information to a [resource log](data-sources.md) for forwarding to different locations.
>
>Azure Monitor Logs is a log data platform that collects Activity logs and resource logs along with other monitoring data to provide deep analysis across your entire set of resources.

Work with [log queries](../logs/log-query-overview.md) interactively by using [Log Analytics](../logs/log-query-overview.md) in the Azure portal. Add the results to an [Azure dashboard](../app/overview-dashboard.md#create-custom-kpi-dashboards-using-application-insights) for visualization in combination with other data. Create [log search alerts](../alerts/alerts-create-log-alert-rule.md) that trigger an alert based on the results of a scheduled query.

### Distributed traces

Traces are series of related events that follow a user request through a distributed system. They can be used to determine the behavior of application code and the performance of different transactions. While logs are often created by individual components of a distributed system, a trace measures the operation and performance of your application across the entire set of components.

You enable distributed tracing in Azure Monitor by using [Application Insights](../app/app-insights-overview.md). Application Insights stores trace data with other application log data it collects. This storage makes trace data available to the same analysis tools as other log data, including log queries, dashboards, and alerts.

### Changes tracked with Azure Resource Graph

Changes are a series of events that occur in your Azure application, from the infrastructure layer through application deployment. Change Analysis tracks these events at the subscription level and builds on [Azure Resource Graph](/azure/governance/resource-graph/overview) to provide detailed insights into resource changes.

Change Analysis now runs on Azure Resource Graph, which provides an onboarding-free experience across all subscriptions and resources. You no longer need to register the `Microsoft.ChangeAnalysis` resource provider. Resource Graph uses Change Actor functionality to identify when a resource is created, updated, or deleted through the Azure Resource Manager control plane.

Change Analysis provides data for management and troubleshooting scenarios that help you understand what changes might have caused an issue:

* Troubleshoot an application from the Diagnose and solve problems experience in the Azure portal.
* Query change history tenant-wide with the `Microsoft.ResourceGraph/resources` API.
* [View resource changes in the Azure portal](/azure/governance/resource-graph/changes/view-resource-changes).

For more information, see [Analyze changes to your Azure resources with Change Analysis](/azure/governance/resource-graph/changes/resource-graph-changes).

## Collect monitoring data

Different [sources of data for Azure Monitor](data-sources.md) write to either a Log Analytics workspace (Logs) or the Azure Monitor metrics database (Metrics) or both. Some sources write directly to these data stores, while others might write to another location such as Azure storage and require some configuration to populate logs or metrics.

For a listing of different data sources that populate each type, see [Metrics in Azure Monitor](../metrics/data-platform-metrics.md) and [Logs in Azure Monitor](../logs/data-platform-logs.md).

## Stream data to external systems

In addition to using the tools in Azure to analyze monitoring data, you might have a requirement to forward it to an external tool like a security information and event management product. This forwarding is typically done directly from monitored resources through [Azure Event Hubs](/azure/event-hubs/).

Some sources send data directly to an event hub. For others, use another process, such as a logic app, to retrieve the required data. For more information, see [Stream Azure monitoring data to an event hub for consumption by an external tool](../platform/stream-monitoring-data-event-hubs.md).

## Next steps

* [Metrics in Azure Monitor](../metrics/data-platform-metrics.md)
* [Logs in Azure Monitor](../logs/data-platform-logs.md)
* [Monitoring data available](data-sources.md) for different resources in Azure
