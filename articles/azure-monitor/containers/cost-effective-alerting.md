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

This article describes multiple strategies for alerting on AKS workloads with tables configured for Basic logs. These recommendations help you balance cost and performance while still meeting your operational needs and service-level objectives (SLOs). 


> [!TIP]
> Use the guidance at [Select a table plan based on data usage in a Log Analytics workspace](../logs/logs-table-plans.md) to set the table plan for `ContainerLogsV2` to Basic.

## Managed Prometheus alerts

Whenever possible, you should prioritize alerting on metrics rather than logs, as this is typically more scalable and cost-efficient, especially in large AKS environments. Metrics are compact, purpose-built for fast evaluation, and incur lower ingestion, storage, and query costs compared to logs.

Azure Managed Prometheus enables near real-time metric ingestion and alerting without the overhead of managing your own Prometheus infrastructure. It integrates directly with your AKS clusters and supports Kubernetes-native metrics scraping using Prometheus format. Alert rules can be visualized and analyzed in [Azure Managed Grafana](/azure/managed-grafana/overview) or integrated into Azure Monitor for alert routing.

Get started by enabling a set of [recommended alert rules](./kubernetes-metric-alerts.md#enable-recommended-alert-rules) and [create your own custom alert rules](../alerts/prometheus-alerts.md).



### Examples

- You want to be alerted when the number of failed login attempts in your application exceeds a threshold within a 5-minute window. This condition can't be detected with a metric, so you would need to use a [log query alert rule]() to identify failed login attempts and emit a custom metric.
- You're running containerized workloads on AKS. While they have CPU metrics available in Azure Monitor, they also collect detailed logs from the container runtime that include CPU usage per process. They want to alert when any container exceeds 90% CPU usage.


## Simple log search alert rules (preview)

[Simple log search alerts](../alerts/alerts-types.md#simple-log-search-alerts) in Azure Monitor are designed to provide a simpler and faster alternative to traditional log search alerts, and they're supported on Basic Logs tables. Unlike log search alerts that aggregate rows over a defined period, simple log alerts evaluate each row individually and allow a single-condition log search. They're also ideal for scenarios such as watching for a specific error event or status change.

:::image type="content" source="media/cost-effective-alerts/simple-log-alert-rule.png" lightbox="media/cost-effective-alerts/simple-log-alert-rule.png" alt-text="Diagram that shows a simple alert." border="false":::

You have a cloud-based application and want to ensure that any critical error, such as a failed deployment or a service outage, is detected immediately so the engineering team can respond quickly. One of the services occasionally transitions into a *Degraded* or *Unavailable* state due to upstream dependency issues. You want to be notified immediately when this happens to reduce downtime and improve incident response.

## Create Summary rules (Preview)
[Summary rules](../logs/summary-rules.md) are scheduled queries that run at defined intervals to perform aggregations or transformations and store the results in a custom Analytics-tier tables. This allows you to ingest your container logs into a Basic Logs table and then perform advanced analysis and alerting on an aggregated version of the data. 

:::image type="content" source="media/cost-effective-alerts/summary-rule.png" lightbox="media/cost-effective-alerts/summary-rule.png" alt-text="Diagram that shows alerting from an analytics table created by a summary rule." border="false":::

Consider a scenario where you want to monitor error rates in your container logs. Using the guidance at [Create or update a summary rule](../logs/summary-rules.md#create-or-update-a-summary-rule), create a summary rule with the following definition to count the number of error-level logs and stores the result in an Analytics-tier table.

    ```json
    {
      "properties": {
          "ruleType": "User",
          "description": "Summarize container logs",
          "ruleDefinition": {
              "query": "ContainerLogv2 | where LogLevel == \"Error\" | summarize ErrorCount = count() by bin TimeGenerated, 15m), ContainerID",
              "binSize": 30,
              "destinationTable": "ContainerLogV2Summary_CL"
          }
      }
    }
    ```

> [!TIP]
> To reduce scan costs, use a query that returns multiple aggregations and dimensions that can be used by multiple alert rules. 

Once the summary rule is created, you can create log query alerts with a 1h window on the new Analytics-tier table to notify when error counts exceed defined thresholds. With the configurations in this example, each alert evaluation will include two summaries and the alert itself will have a 1 hour latency. You can alter bin size of the summary rule and the window size of the alert rule based on your requirements.


## Create transformation to send critical logs to Analytics tier
Summary rules may not be responsive enough if you need near-real time alerting on container logs. In operationally sensitive scenarios where near real-time log alerting is required, use a [transformation](../data-collection/data-collection-transformations-create.md) to route high-value logs to an Analytics Logs table while sending other logs to a Basic Logs table.

:::image type="content" source="media/cost-effective-alerts/transformation.png" lightbox="media/cost-effective-alerts/transformation.png" alt-text="Diagram that shows a transformation that sends some data to analytics table and other data to basic logs." border="false":::