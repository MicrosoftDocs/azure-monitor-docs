---
title: Cost effective alerting strategies for AKS clusters in Azure Monitor 
description: Describes different strategies for cost effective alerting from AKS clusters in Azure Monitor.
ms.topic: conceptual
ms.date: 05/12/2025
ms.reviewer: vdiec
---

# Cost effective alerting strategies for AKS

Alerting is a critical part of monitoring workloads on Azure Kubernetes Service (AKS), but it can quickly become expensive if not configured carefully. This article outlines best practices to help you build cost-effective alerting pipelines in AKS, using Azure Monitor and Azure Managed Prometheus. These recommendations help you balance cost and performance while still meeting your operational needs and service-level objectives (SLOs). 

Advanced alerting on [Analytics-tier logs](../logs/data-platform-logs.md#table-plans) can be cost-prohibitive for high-volume environments or certain type of logs such as audit logs. To bridge this gap, Azure Monitor provides options for event-driven and summary-based alerting on [Basic Logs](../logs/data-platform-logs.md#table-plans), giving you more control over costs without sacrificing visibility into the health and behavior of your AKS workloads.

This article outlines various strategies that can be used to carry out cost-effective alerting in an AKS environment. 

## Managed Prometheus

Whenever possible, you should prioritize alerting on metrics rather than logs, as this is typically more scalable and cost-efficient, especially in large AKS environments. Metrics are compact, purpose-built for fast evaluation, and incur lower storage and query costs compared to logs.

Azure Managed Prometheus enables near real-time metric ingestion and alerting without the overhead of managing your own Prometheus infrastructure. It integrates directly with your AKS clusters and supports Kubernetes-native metrics scraping using Prometheus format.

Alert rules can be visualized and analyzed in Azure Managed Grafana or integrated into Azure Monitor for alert routing.

## Simple log search alert rules (preview)

[Simple log search alerts](../alerts/alerts-types.md#simpl-log-search-alerts) in Azure Monitor are designed to provide a simpler and faster alternative to traditional log search alerts. Unlike log search alerts that aggregate rows over a defined period, simple log alerts evaluate each row individually. This feature is also useful for customers using basic logs that would like to create alerts, as it offers a "simple mode" defined on a single row in a specific log analytics table.

Simple Log Alerts support single-condition log search over Basic Logs, which makes them more cost-effective than traditional log alerts on Analytics tier. They're also ideal for scenarios such as watching for a specific error event or status change.

### Examples

- As a Product Manager overseeing a cloud-based application, you want to ensure that any critical error, such as a failed deployment or a service outage, is detected immediately so the engineering team can respond quickly.
- Your team manages an application. One of the services occasionally transitions into a *Degraded* or *Unavailable* state due to upstream dependency issues. You want to be notified immediately when this happens to reduce downtime and improve incident response.

# Create Summary rules (Preview) 
Another cost-effective strategy is to ingest all or most of container log data into the Basic tier to reduce ingestion costs and then use [Summary rules](../logs/summary-rules.md) to aggregate and ingest essential summarized data into the Analytics tier, enabling advanced analysis and alerting. Summary rules are scheduled queries that run at defined intervals to perform aggregations or transformations and store the results in a custom Analytics-tier tables.

## Example

Consider a scenario where you want to monitor error rates in your container logs.

1.	Ingest all container logs into Basic Logs, which ensures comprehensive data collection at a lower cost. Container logs are stored in [ContainerLogsV2](), so set the plan for this table to Basic as described in 

2.	Define a Summary Rule: Create a rule that runs every 30 minutes to count the number of error-level logs and stores the result in an Analytics-tier table.

    ```kusto    
    ContainerLogv2
    | where LogLevel == "Error"
    | summarize ErrorCount = count() by bin(TimeGenerated, 15m), ContainerID
    ```


