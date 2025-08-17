---
title: Azure Monitor billing meter names
description: Reference of Azure Monitor billing meter names.
ms.topic: reference
ms.reviewer: Dale.Koetke
ms.date: 05/21/2025
---

# Azure Monitor billing meter names

This article contains a reference of the billing meter names used by Azure Monitor in [Azure Cost Management + Billing](cost-usage.md#microsoft-cost-management--billing). Use this information to interpret your monthly charges for Azure Monitor.

## Log data ingestion

The following table lists the meters used to bill for data ingestion in your Log Analytics workspaces, and whether the meter is regional. There's a different billing meter, `MeterId` in the export usage report for each region. Auxiliary Logs and Basic Logs table plans can be used when the workspace's pricing tier is Pay-as-you-go or any commitment tier, not any of the legacy pricing tiers. 

| Analytics Logs<br>Pricing tier | ServiceName           | MeterName                                            | Regional Meter? |
|--------------------------------|-----------------------|------------------------------------------------------|-----------------|
| (any)                          | Azure Monitor         | [Auxiliary Logs Data Ingestion](../logs/cost-logs.md#basic-and-auxiliary-table-plans)                        | yes             |
| (any)                          | Azure Monitor         | [Basic Logs Data Ingestion](../logs/cost-logs.md#basic-and-auxiliary-table-plans)                      | yes             |
| Pay-as-you-go                  | Log Analytics         | Pay-as-you-go Data Ingestion or <br/> Analytics Logs Pay-as-you-go Data Ingestion (*new name*)                        | yes             |
| 100 GB/day [Commitment Tier](../logs/cost-logs.md#commitment-tiers)     | Azure Monitor         | 100 GB Commitment Tier Capacity Reservation          | yes             |
| 200 GB/day Commitment Tier     | Azure Monitor         | 200 GB Commitment Tier Capacity Reservation          | yes             |
| 300 GB/day Commitment Tier     | Azure Monitor         | 300 GB Commitment Tier Capacity Reservation          | yes             |
| 400 GB/day Commitment Tier     | Azure Monitor         | 400 GB Commitment Tier Capacity Reservation          | yes             |
| 500 GB/day Commitment Tier     | Azure Monitor         | 500 GB Commitment Tier Capacity Reservation          | yes             |
| 1000 GB/day Commitment Tier    | Azure Monitor         | 1,000 GB Commitment Tier Capacity Reservation         | yes             |
| 2000 GB/day Commitment Tier    | Azure Monitor         | 2,000 GB Commitment Tier Capacity Reservation         | yes             |
| 5000 GB/day Commitment Ties    | Azure Monitor         | 5,000 GB Commitment Tier Capacity Reservation         | yes             |
| 10000 GB/day Commitment Tier   | Azure Monitor         | 10,000 GB Commitment Tier Capacity Reservation        | yes             |
| 25000 GB/day Commitment Tier   | Azure Monitor         | 25,000 GB Commitment Tier Capacity Reservation        | yes             |
| 50000 GB/day Commitment Tier   | Azure Monitor         | 50,000 GB Commitment Tier Capacity Reservation        | yes             |
| [Per Node](../logs/cost-logs.md#per-node-pricing-tier) (legacy tier)         | Insight and Analytics | Standard Node                                        | no              |
| Per Node (legacy tier)         | Insight and Analytics | Standard Data Overage per Node                       | no              |
| Per Node (legacy tier)         | Insight and Analytics | Standard Data Included per Node                      | no              |
| [Standalone](../logs/cost-logs.md#standalone-pricing-tier) (legacy tier)       | Log Analytics         | Pay-as-you-go Data Analyzed                          | no              |
| [Standard](../logs/cost-logs.md#standard-and-premium-pricing-tiers) (legacy tier)         | Log Analytics         | Standard Data Analyzed                               | no              |
| [Premium](../logs/cost-logs.md#standard-and-premium-pricing-tiers) (legacy tier)          | Log Analytics         | Premium Data Analyzed                                | no              |
| (any)                          | Azure Monitor         | Free Benefit - Microsoft 365 Defender Data Ingestion | yes             |
| (any)                          | Azure Monitor         | Free Benefit - Az Sentinel Trial Data Ingestion      | yes             |


The **Standard Data Included per Node** meter is used both, for the Log Analytics [Per Node tier](../logs/cost-logs.md#per-node-pricing-tier) data allowance, and also for the [Defender for Servers data allowance](../logs/cost-logs.md#workspaces-with-microsoft-defender-for-cloud), for workspaces in any pricing tier.

The **Free Benefit - M365 Defender Data Ingestion** meter is used to record the benefit from the [Microsoft Sentinel benefit for Microsoft 365 E5, A5, F5, and G5 customers](https://azure.microsoft.com/offers/sentinel-microsoft-365-offer/).

## Log data retention

[Data retention](../logs/data-retention-configure.md) can be configured at the workspace and table level. The following meters are used to charge for extended data retention. 

| ServiceName           | MeterName                                | Regional Meter? |
|-----------------------|------------------------------------------|-----------------|
| Log Analytics         | Pay-as-you-go Data Retention or <br/> Analytics Logs Retention (*new name*)            | yes             |
| Azure Monitor         | Data Archive or <br/> Long-term Retention (*new name*)                            | yes             |
| Insight and Analytics | Standard Data Retention | no              |

**Pay-as-you-go Data Retention** (now **Analytics Logs Retention**) is interactive retention for workspaces in all modern pricing tiers (Pay-as-you-go and Commitment Tiers).  **Data Archive** (now **Long-term Retention**) is the meter for long-term data retention. **Standard Data Retention** is interactive retention for workspaces in the legacy Per Node and Standalone pricing tiers.  

## Other Azure Monitor logs meters

| ServiceName           | MeterName                                | Regional Meter? |
|-----------------------|------------------------------------------|-----------------|
| Azure Monitor         | [Search Queries Scanned](../logs/basic-logs-query.md)                   | yes             |
| Azure Monitor         | [Search Jobs Scanned](../logs/search-jobs.md) | yes             |
| Azure Monitor         | [Data Restore](../logs/restore.md)                             | yes             |
| Azure Monitor         | [Log Analytics data export Data Exported](../logs/logs-data-export.md)  | yes             |
| Azure Monitor         | Data Replication Data Replicated         | yes             |
| Azure Monitor         | Log data ingestion and transformation GB  <br/> Logs Processed GB (*new name*) | yes             |
| Azure Monitor         | Platform Logs Data Processed            | yes             |



## Azure Monitor metrics meters:

| ServiceName   | MeterName                                 | Regional Meter? |
|---------------|-------------------------------------------|-----------------|
| Azure Monitor | Metrics ingestion Metric samples          | yes             |
| Azure Monitor | Prometheus Metrics Queries Metric samples | yes             |
| Azure Monitor | Native Metric Queries API Calls           | yes             |
| Azure Monitor | Metrics Export Metric Samples Exported    | yes             |

## Azure Monitor alerts meters

| ServiceName   | MeterName                                          | Regional Meter? |
|---------------|----------------------------------------------------|-----------------|
| Azure Monitor | Alerts Metric Monitored                            | no              |
| Azure Monitor | Alerts Dynamic Threshold                           | no              |
| Azure Monitor | Alerts System Log Monitored at 1 Minute Frequency  | no              |
| Azure Monitor | Alerts System Log Monitored at 10 Minute Frequency | no              |
| Azure Monitor | Alerts System Log Monitored at 15 Minute Frequency | no              |
| Azure Monitor | Alerts System Log Monitored at 5 Minute Frequency  | no              |
| Azure Monitor | Alerts Resource Monitored at 1 Minute Frequency    | no              |
| Azure Monitor | Alerts Resource Monitored at 10 Minute Frequency   | no              |
| Azure Monitor | Alerts Resource Monitored at 15 Minute Frequency   | no              |
| Azure Monitor | Alerts Resource Monitored at 5 Minute Frequency    | no              |

## Azure Monitor web test meters

| ServiceName          | MeterName                   | Regional Meter? |
|----------------------|-----------------------------|-----------------|
| Azure Monitor        | Standard Web Test Execution | yes             |
| Application Insights | Multi-step Web Test         | no              |

## Legacy classic Application Insights meters

| ServiceName          | MeterName               | Regional Meter? |
|----------------------|-------------------------|-----------------|
| Application Insights | Enterprise Node         | no              |
| Application Insights | Enterprise Overage Data | no              |


### Legacy Application Insights meters

Most Application Insights usage for both classic and workspace-based resources is reported on meters with **Log Analytics** for **Meter Category** because there's a single log back-end for all Azure Monitor components. Only Application Insights resources on legacy pricing tiers and multiple-step web tests are reported with **Application Insights** for **Meter Category**. The usage is shown in the **Consumed Quantity** column. The unit for each entry is shown in the **Unit of Measure** column. For more information, see [Understand your Microsoft Azure bill](/azure/cost-management-billing/understand/review-individual-bill).

To separate costs from your Log Analytics and classic Application Insights usage, [create a filter](/azure/cost-management-billing/costs/group-filter) on **Resource type**. To see all Application Insights costs, filter **Resource type** to **microsoft.insights/components**. For Log Analytics costs, filter **Resource type** to **microsoft.operationalinsights/workspaces**. (Workspace-based Application Insights is all billed to the Log Analytics workspace resourced.)
