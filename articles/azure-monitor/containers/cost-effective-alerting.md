---
title: Cost effective alerting strategies for AKS clusters in Azure Monitor 
description: Describes different strategies for cost effective alerting from AKS clusters in Azure Monitor.
ms.topic: conceptual
ms.date: 05/12/2025
ms.reviewer: vdiec
---

# Cost effective alerting strategies for AKS

Alerting is a critical part of monitoring workloads on Azure Kubernetes Service (AKS). Advanced alerting requires [Analytics-tier logs](../logs/data-platform-logs.md#table-plans) in your Log Analytics workspace, but this can be cost-prohibitive for high-volume environments or certain types of logs such as audit logs. 

You can significantly reduce your data ingestion costs by converting tables such as [ContainerLogsV2](../logs/data-platform-logs.md#table-plans) to [Basic logs](../logs/data-platform-logs.md#table-plans). Azure Monitor provides options for event-driven and summary-based alerting on Basic Logs tables, giving you more control over costs without sacrificing visibility into the health and behavior of your AKS workloads.

This article describes multiple strategies for alerting on AKS workloads with tables supporting container logs configured as Basic. These recommendations help you balance cost and performance while still meeting your operational needs and service-level objectives (SLOs). 


> [!TIP]
> Use the guidance at [Select a table plan based on data usage in a Log Analytics workspace](../logs/logs-table-plans.md) to set the plan for any tables to Basic.

## Managed Prometheus alerts

Whenever possible, you should prioritize alerting on metrics rather than logs, as this is typically more scalable and cost-efficient, especially in large AKS environments. Metrics are compact, purpose-built for fast evaluation, and incur lower ingestion, storage, and query costs compared to logs.

[Azure Managed Prometheus](./prometheus-metrics-scrape-default.md) enables near real-time metric ingestion and alerting without the overhead of managing your own Prometheus infrastructure. It integrates directly with your AKS clusters and supports Kubernetes-native metrics scraping using Prometheus format. Alert rules can be visualized and analyzed in [Azure Managed Grafana](/azure/managed-grafana/overview) or integrated into Azure Monitor for alert routing.

Start by enabling [recommended alert rules](./kubernetes-metric-alerts.md#enable-recommended-alert-rules). This includes platform metric alerts such as firing when CPU of a node exceeds a threshold. You can also enable different levels of Prometheus alerts for a variety of scenarios. In addition to the built-in alert rules, [create your own custom alert rules](../alerts/prometheus-alerts.md) using Prometheus metrics.


## Simple log search alert rules (preview)

[Simple log search alerts](../alerts/alerts-types.md#simple-log-search-alerts) in Azure Monitor are designed to provide a simpler and faster alternative to traditional log search alerts, and they're supported on Basic Logs tables. Unlike log search alerts that aggregate rows over a defined period, simple log alerts evaluate each row individually and allow a single-condition log search. They're ideal for scenarios such as watching for a specific error event or status change. 

:::image type="content" source="media/cost-effective-alerts/simple-log-alert-rule.png" lightbox="media/cost-effective-alerts/simple-log-alert-rule.png" alt-text="Diagram that shows a simple alert." border="false":::

For example, you may set a rule to fire on every occurrence of a specific error message from a cloud-based  application have a cloud-based application, or you may choose to fire on any message with an error level severity. 

In addition to firing on every occurrence of a message, you can also set a threshold for the number of occurrences within a specified time window. For example, you may have a message indicating a failed login and want to be alerted when the number of failed login attempts in their application in a minute exceeds a threshold. Once identified, you can use a log query on the table itself to identify the failed login attempts

## Create Summary rules
[Summary rules](../logs/summary-rules.md) are scheduled queries that run at defined intervals to perform aggregations or transformations and store the results in a custom Analytics-tier tables. This allows you to ingest your container logs into a Basic Logs table and then perform advanced analysis and alerting on an aggregated version of the data. 

:::image type="content" source="media/cost-effective-alerts/summary-rule.png" lightbox="media/cost-effective-alerts/summary-rule.png" alt-text="Diagram that shows alerting from an analytics table created by a summary rule." border="false":::

Consider a scenario where you want to monitor error rates in your container logs. Using the guidance at [Create or update a summary rule](../logs/summary-rules.md#create-or-update-a-summary-rule), create a summary rule with a query such as the following, which counts the number of error-level logs for each container.

```kusto
ContainerLogv2
| where LogLevel == "Error" 
| summarize ErrorCount = count() by ContainerID
```

> [!TIP]
> To reduce scan costs, use a query that returns multiple aggregations and dimensions that can be used by multiple alert rules. 

Create log query alerts with a window greater than the bin size on the new Analytics-tier table to notify when error counts exceed defined thresholds. For example, if the bin size is 30min, you might create an alert rule with a 1hr window so that each alert evaluation will include two summaries.


## Create transformation to send critical logs to Analytics tier
Summary rules may not be responsive enough if you need near-real time alerting on container logs. In operationally sensitive scenarios where near real-time log alerting is required, use a [transformation](../data-collection/data-collection-transformations-create.md) to route high-value logs (such as error and critical events) to an Analytics Logs table while sending other logs to a Basic Logs table. 

Configuration for this transformation is provided in [Data transformations in Container insights](./container-insights-transformations.md#send-data-to-different-tables).

:::image type="content" source="media/cost-effective-alerts/transformation.png" lightbox="media/cost-effective-alerts/transformation.png" alt-text="Diagram that shows a transformation that sends some data to analytics table and other data to basic logs." border="false":::

Using this strategy, you can perform advanced alerting on the Analytics Logs table while keeping the Basic Logs table for cost-effective storage and analysis of less critical logs.


## Next steps

- [Learn more about Basic logs](../logs/data-platform-logs.md#table-plans)
- [Learn more about alerts in Azure Monitor](../alerts/alerts-overview.md)