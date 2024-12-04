---
title: Azure Monitor Logs cost calculations and options
description: Cost details for data stored in a Log Analytics workspace in Azure Monitor, including commitment tiers and data size calculation.
ms.topic: conceptual
ms.reviewer: Dale.Koetke
ms.date: 01/25/2024
ms.reviwer: dalek git
---

# Azure Monitor Logs cost calculations and options

The most significant charges for most Azure Monitor implementations are typically ingestion and retention of data in your Log Analytics workspaces. Several features in Azure Monitor don't have a direct cost but add to the workspace data that's collected. This article describes how data charges are calculated for your Log Analytics workspaces and the various configuration options that affect your costs.

[!INCLUDE [azure-monitor-cost-optimization](../../../includes/azure-monitor-cost-optimization.md)]


## Pricing model

The default pricing for Log Analytics is a pay-as-you-go model that's based on ingested data volume and data retention. Each Log Analytics workspace is charged as a separate service and contributes to the bill for your Azure subscription. [Pricing for Azure Monitor Logs](https://azure.microsoft.com/pricing/details/monitor/) is set regionally. The amount of data ingestion can be considerable, depending on:

- The set of management solutions enabled and their configuration.
- The number and type of monitored resources.
- The types of data collected from each monitored resource.

A list of Azure Monitor billing meter names is available [here](../cost-meters.md). 

## Data size calculation

Azure Monitor Logs bills for the amount of data you send to a Log Analytics workspace in GB (10^9 bytes). 

Azure Monitor Logs calculates the billed size of a single record based on:

- A string representation of the column entries that Azure Monitor Logs needs to add in the Log Analytics workspace for that record. 

>[!NOTE]
>The billable data volume calculation is generally substantially smaller than the size of the entire incoming JSON-packaged event. On average, across all event types, the billed size is around 25 percent less than the incoming data size. It can be up to 50 percent for small events. The percentage includes the effect of the standard columns excluded from billing. It's essential to understand this calculation of billed data size when you estimate costs and compare other pricing models.

- The billable size includes data both data is collected from the data source or added during the ingestion process. For example, this calculation includes any custom columns added by the [logs ingestion API](logs-ingestion-api-overview.md), [transformations](../essentials/data-collection-transformations.md), and [custom fields](custom-fields.md). If you send columns entries that don't match the destination table schema, Azure Monitor Logs bills you for those column entries, even though the destination table can't store the data. Make sure your data collection rules match the destination table schema to avoid being charged for data that your destination table can't store. 

### Excluded columns

The following [standard columns](log-standard-columns.md) are common to all tables and are excluded in the calculation of the record size. All other columns stored in Log Analytics are included in the calculation of the record size. The standard columns are:

- `_ResourceId`
- `_SubscriptionId`
- `_ItemId`
- `_IsBillable`
- `_BilledSize`
- `Type`

### Excluded tables

Some tables are free from data ingestion charges altogether, including, for example, [AzureActivity](/azure/azure-monitor/reference/tables/azureactivity), [Heartbeat](/azure/azure-monitor/reference/tables/heartbeat), [Usage](/azure/azure-monitor/reference/tables/usage), and [Operation](/azure/azure-monitor/reference/tables/operation). This information is always indicated by the [_IsBillable](log-standard-columns.md#_isbillable) column, which shows whether a record was excluded from billing for data ingestion and retention.

### Charges for other solutions and services

Some solutions have more specific policies about free data ingestion. For example, [Azure Migrate](https://azure.microsoft.com/pricing/details/azure-migrate/) makes dependency visualization data free for the first 180 days of a Server Assessment. Services such as [Microsoft Defender for Cloud](https://azure.microsoft.com/pricing/details/azure-defender/), [Microsoft Sentinel](https://azure.microsoft.com/pricing/details/azure-sentinel/), and [configuration management](https://azure.microsoft.com/pricing/details/automation/) have their own pricing models.

See the documentation for different services and solutions for any unique billing calculations.

## Commitment tiers

In addition to the pay-as-you-go model, Log Analytics has *commitment tiers*, which can save you as much as 30 percent compared to the pay-as-you-go price. With commitment tier pricing, you can commit to buy data ingestion for a workspace, starting at 100 GB per day, at a lower price than pay-as-you-go pricing. Any usage above the commitment level (overage) is billed at that same price per GB as provided by the current commitment tier. (Overage is billed using the same commitment tier billing meter. For example if a workspace is in the 200 GB/day commitment tier and ingests 300 GB in a day, that usage is billed as 1.5 units of the 200 GB/day commitment tier.) The commitment tiers have a 31-day commitment period from the time a commitment tier is selected or changed.

- During the commitment period, you can change to a higher commitment tier, which restarts the 31-day commitment period. You can't move back to pay-as-you-go or to a lower commitment tier until after you finish the commitment period.
- At the end of the commitment period, the workspace retains the selected commitment tier, and the workspace can be moved to pay-as-you-go or to a lower commitment tier at any time.
- If a workspace is inadvertently moved into a commitment tier, contact Microsoft Support to reset the commitment period so you can move back to the pay-as-you-go pricing tier.

Billing for the commitment tiers is done per workspace on a daily basis. If the workspace is part of a [dedicated cluster](#dedicated-clusters), the billing is done for the cluster. See the following "Dedicated clusters" section. For a list of the commitment tiers and their prices, see [Azure Monitor pricing](https://azure.microsoft.com/pricing/details/monitor/).

Azure Commitment Discounts, such as discounts received from [Microsoft Enterprise Agreements](https://www.microsoft.com/licensing/licensing-programs/enterprise), are applied to Azure Monitor Logs commitment-tier pricing just as they're to pay-as-you-go pricing. Discounts are applied whether the usage is being billed per workspace or per dedicated cluster.

> [!TIP]
> The **Usage and estimated costs** menu item for each Log Analytics workspace shows an estimate of what your data ingestion charges would be at each commitment level to help you choose the optimal commitment tier for your data ingestion patterns. Review this information periodically to determine if you can reduce your charges by moving to another tier. For information on this view, see [Usage and estimated costs](../cost-usage.md#usage-and-estimated-costs). To review your actual charges, use [Azure Cost Management = Billing](../cost-usage.md#azure-cost-management--billing).

## Dedicated clusters

An [Azure Monitor Logs dedicated cluster](logs-dedicated-clusters.md) is a collection of workspaces in a single managed Azure Data Explorer cluster. Dedicated clusters support advanced features, such as [customer-managed keys](customer-managed-keys.md), and use the same commitment-tier pricing model as workspaces, although they must have a commitment level of at least 100 GB per day. Any usage above the commitment level (overage) is billed at that same price per GB as provided by the current commitment tier. There's no pay-as-you-go option for clusters.

The cluster commitment tier has a 31-day commitment period after the commitment level is increased. During the commitment period, the commitment tier level can't be reduced, but it can be increased at any time. When workspaces are associated to a cluster, the data ingestion billing for those workspaces is done at the cluster level by using the configured commitment tier level.

There are two modes of billing for a cluster that you specify when you create the cluster:

- **Cluster (default)**: Billing for ingested data is done at the cluster level. The ingested data quantities from each workspace associated to a cluster are aggregated to calculate the daily bill for the cluster. Per-node allocations from [Microsoft Defender for Cloud](/azure/security-center/) are applied at the workspace level prior to this aggregation of data across all workspaces in the cluster.

- **Workspaces**: Commitment tier costs for your cluster are attributed proportionately to the workspaces in the cluster, by each workspace's data ingestion volume (after accounting for per-node allocations from [Microsoft Defender for Cloud](/azure/security-center/) for each workspace).<br><br>If the total data volume ingested into a cluster for a day is less than the commitment tier, each workspace is billed for its ingested data at the effective per-GB commitment tier rate by billing them a fraction of the commitment tier. The unused part of the commitment tier is then billed to the cluster resource.<br><br>If the total data volume ingested into a cluster for a day is more than the commitment tier, each workspace is billed for a fraction of the commitment tier, based on its fraction of the ingested data that day and each workspace for a fraction of the ingested data above the commitment tier. If the total data volume ingested into a workspace for a day is above the commitment tier, nothing is billed to the cluster resource.

Examples of how cluster billing works in each of these modes can be found [here](/azure/sentinel/enroll-simplified-pricing-tier?tabs=microsoft-sentinel#dedicated-cluster-billing-examples). 

Data retention is billed for each workspace, the same as for workspaces not joined to a cluster. 

Cluster billing starts when the cluster is created, regardless of whether workspaces are associated with the cluster.

When you link workspaces to a cluster, the pricing tier is changed to cluster, and ingestion is billed based on the cluster's commitment tier. Workspaces associated to a cluster no longer have their own pricing tier. Workspaces can be unlinked from a cluster at any time, and the pricing tier can be changed to per GB.

If your linked workspace is using the legacy Per Node pricing tier, it's billed based on data ingested against the cluster's commitment tier, and no longer Per Node. Per-node data allocations from Microsoft Defender for Cloud will continue to be applied.

If a cluster is deleted, billing for the cluster stops even if the cluster is within its 31-day commitment period. 

For more information on how to create a dedicated cluster and specify its billing type, see [Create a dedicated cluster](logs-dedicated-clusters.md#create-a-dedicated-cluster).

## Basic and Auxiliary table plans

You can configure certain tables in a Log Analytics workspace to use [Basic and Auxiliary table plans](logs-table-plans.md). Data in these tables has a significantly reduced ingestion charge. There's a charge to query data in these tables.

The charge for querying data in Basic and Auxiliary tables is based on the GB of data scanned in performing the search.

For more information about the Basic and Auxiliary table plans, see [Azure Monitor Logs overview: Table plans](data-platform-logs.md#table-plans).

## Log data retention

In addition to data ingestion, there's a charge for the retention of data in each Log Analytics workspace. You can set the retention period for the entire workspace or for each table. After this period, the data is either removed or kept in long-term retention. During the long-term retention period, you pay a reduced retention charge, and there's a charge to retrieve the data using a [search job](search-jobs.md). Use long-term retention to reduce your costs for data that you must store for compliance or occasional investigation.

[Deleting a custom table](create-custom-table.md#delete-a-table) doesn't remove data associated with that table, so interactive and long-term retention charges continue to apply. 

For more information on data retention, including how to configure these settings and access data in long-term retention, see [Manage data retention in a Log Analytics workspace](data-retention-configure.md).

>[!NOTE]
>Deleting data from your Log Analytics workspace using the Log Analytics Purge feature doesn't affect your retention costs. To lower retention costs, decrease the retention period for the workspace or for specific tables. 

## Search jobs

Retrieve data from long-term retention by running [search jobs](search-jobs.md). Search jobs are asynchronous queries that fetch records into a new search table within your workspace for further analytics. Search jobs are billed by the number of GB of data scanned on each day that's accessed to perform the search.

## Log data restore

When you need to intensively queried large volumes of data, or data in long-term retention with the full analytic query capabilities, the [data restore](restore.md) feature is a powerful tool. The restore operation makes a specific time range of data in a table available in the hot cache for high-performance queries. You can later dismiss the data when you're finished. Log data restore is billed by the amount of data restored, and by the time the restore is kept active. The minimal values billed for any data restore are 2 TB and 12 hours. Data restored of more than 2 TB and/or more than 12 hours in duration is billed on a pro-rated basis.

## Log data export

[Data export](logs-data-export.md) in a Log Analytics workspace lets you continuously export data per selected tables in your workspace to an Azure Storage account or Azure Event Hubs as it arrives to an Azure Monitor pipeline. Charges for the use of data export are based on the amount of data exported. The size of data exported is the number of bytes in the exported JSON-formatted data.

## Application Insights billing

Because [workspace-based Application Insights resources](../app/create-workspace-resource.md) store their data in a Log Analytics workspace, the billing for data ingestion and retention is done by the workspace where the Application Insights data is located. For this reason, you can use all options of the Log Analytics pricing model, including [commitment tiers](#commitment-tiers), along with pay-as-you-go.

> [!TIP]
> Looking to adjust retention settings on your Application Insights tables? The table names have changed for workspace based components, see [Application Insights Table Structure](/azure/azure-monitor/app/convert-classic-resource#table-structure)

Data ingestion and data retention for a [classic Application Insights resource](/previous-versions/azure/azure-monitor/app/create-new-resource) follow the same pay-as-you-go pricing as workspace-based resources, but they can't use commitment tiers.

Telemetry from ping tests and multi-step tests is charged the same as data usage for other telemetry from your app. Use of web tests and enabling alerting on custom metric dimensions is still reported through Application Insights. There's no data volume charge for using [Live Metrics Stream](../app/live-stream.md).

For more information about legacy tiers that are available to early adopters of Application Insights, see [Application Insights legacy enterprise (per node) pricing tier](/previous-versions/azure/azure-monitor/app/legacy-pricing).

## Workspaces with Microsoft Sentinel

When Microsoft Sentinel is enabled in a Log Analytics workspace, all data collected in that workspace is subject to Microsoft Sentinel charges along with Log Analytics charges. For this reason, you'll often separate your security and operational data in different workspaces so that you don't incur [Microsoft Sentinel charges](/azure/sentinel/billing) for operational data.

In some scenarios, combining this data can result in cost savings. Typically, this situation occurs when you aren't collecting enough security and operational data for each to reach a commitment tier on their own, but the combined data is enough to reach a commitment tier. For more information, see:

- [Design a Log Analytics workspace architecture](workspace-design.md)
- [Sample Log Analytics workspace designs for Microsoft Sentinel](/azure/sentinel/sample-workspace-designs)

## Workspaces with Microsoft Defender for Cloud

[Microsoft Defender for Servers (part of Defender for Cloud)](/azure/security-center/) [bills by the number of monitored services](https://azure.microsoft.com/pricing/details/defender-for-cloud/). It provides 500 MB per server per day of data allocation that's applied to the following subset of [security data types](/azure/azure-monitor/reference/tables/tables-category#security):

- [SecurityAlert](/azure/azure-monitor/reference/tables/securityalert)
- [SecurityBaseline](/azure/azure-monitor/reference/tables/securitybaseline)
- [SecurityBaselineSummary](/azure/azure-monitor/reference/tables/securitybaselinesummary)
- [SecurityDetection](/azure/azure-monitor/reference/tables/securitydetection)
- [SecurityEvent](/azure/azure-monitor/reference/tables/securityevent)
- [WindowsFirewall](/azure/azure-monitor/reference/tables/windowsfirewall)
- [SysmonEvent](/azure/azure-monitor/reference/tables/sysmonevent)
- [ProtectionStatus](/azure/azure-monitor/reference/tables/protectionstatus)
- [Update](/azure/azure-monitor/reference/tables/update) and [UpdateSummary](/azure/azure-monitor/reference/tables/updatesummary) when the Update Management solution isn't running in the workspace or solution targeting is enabled.
- [MDCFileIntegrityMonitoringEvents](/azure/azure-monitor/reference/tables/mdcfileintegritymonitoringevents)

If the workspace is in the legacy Per Node pricing tier, the Defender for Cloud and Log Analytics allocations are combined and applied jointly to all billable ingested data. If the workspace has Microsoft Sentinel enabled on it, if Sentinel is using a classic pricing tier, the Defender data allocation applies only for the Log Analytics data ingestion billing, but not the classic Sentinel billing. If Sentinel is using a [simplified pricing tier](/azure/sentinel/enroll-simplified-pricing-tier), the Defender data allocation applies to the unified Sentinel billing. To learn more on how Microsoft Sentinel customers can benefit, see the [Microsoft Sentinel Pricing page](https://azure.microsoft.com/pricing/details/microsoft-sentinel/).

The count of monitored servers is calculated on an hourly granularity. The daily data allocation contributions from each monitored server are aggregated at the workspace level. If the workspace is in the legacy Per Node pricing tier, the Microsoft Defender for Cloud and Log Analytics allocations are combined and applied jointly to all billable ingested data.  

## Legacy pricing tiers

Subscriptions that contained a Log Analytics workspace or Application Insights resource on April 2, 2018, or are linked to an Enterprise Agreement that started before February 1, 2019, and is still active, will continue to have access to use the following legacy pricing tiers:

- Standalone (Per GB)
- Per Node (Operations Management Suite [OMS]) 

Access to the legacy Free Trial pricing tier was limited on July 1, 2022. Pricing information for the Standalone and Per Node pricing tiers is available [here](https://aka.ms/OMSpricing). 

A list of Azure Monitor billing meter names, including these legacy tiers, is available [here](../cost-meters.md). 

> [!IMPORTANT] 
> The legacy pricing tiers do not support access to some of the newest features in Log Analytics such as ingesting data to tables with the cost-effective Basic and Auxiliary table plans. 

### Free Trial pricing tier

Workspaces in the Free Trial pricing tier have daily data ingestion limited to 500 MB (except for security data types collected by [Microsoft Defender for Cloud](/azure/security-center/)). Data retention is limited to seven days. The Free Trial pricing tier is intended only for evaluation purposes, not production workloads. No SLA is provided for the Free Trial tier.

> [!NOTE]
> Creating new workspaces in, or moving existing workspaces into, the legacy Free Trial pricing tier was possible only until July 1, 2022.

### Standalone pricing tier

Usage on the Standalone pricing tier is billed by the ingested data volume. It's reported in the **Log Analytics** service and the meter is named "Data Analyzed." Workspaces in the Standalone pricing tier have user-configurable retention from 30 to 730 days. Workspaces in the Standalone pricing tier don't support the use of [Basic and Auxiliary table plans](logs-table-plans.md).

### Per Node pricing tier

The Per Node pricing tier charges per monitored VM (node) on an hour granularity. For each monitored node, the workspace is allocated 500 MB of data per day that's not billed. This allocation is calculated with hourly granularity and is aggregated at the workspace level each day. Data ingested above the aggregate daily data allocation is billed per GB as data overage. The Per Node pricing tier is a legacy tier, which is only available to existing Subscriptions fulfilling the requirement for [legacy pricing tiers](#legacy-pricing-tiers). 

On your bill, the service is **Insight and Analytics** for Log Analytics usage if the workspace is in the Per Node pricing tier. Workspaces in the Per Node pricing tier have user-configurable retention from 30 to 730 days. Workspaces in the Per Node pricing tier don't support the use of [Basic and Auxiliary table plans](logs-table-plans.md). Usage is reported on three meters:

- **Node**: The usage for the number of monitored nodes (VMs) in units of node months.
- **Data Overage per Node**: The number of GB of data ingested in excess of the aggregated data allocation.
- **Data Included per Node**: The amount of ingested data that was covered by the aggregated data allocation. This meter is also used when the workspace is in all pricing tiers to show the amount of data covered by Microsoft Defender for Cloud.

> [!TIP]
> If your workspace has access to the **Per Node** pricing tier but you're wondering whether it would cost less in a pay-as-you-go tier, [use the following query](#evaluate-the-legacy-per-node-pricing-tier) for a recommendation.

### Standard and Premium pricing tiers

Workspaces can't be created in or moved to the **Standard** or **Premium** pricing tiers since October 1, 2016. Workspaces already in these pricing tiers can continue to use them, but if a workspace is moved out of these tiers, it can't be moved back. The Standard and Premium pricing tiers have fixed data retention of 30 days and 365 days, respectively. Workspaces in these pricing tiers don't support the use of [Basic and Auxiliary table plans](logs-table-plans.md) and long-term data retention. Data ingestion meters on your Azure bill for these legacy tiers are called "Data Analyzed."

### Microsoft Defender for Cloud with legacy pricing tiers

The following considerations pertain to legacy Log Analytics tiers and how usage is billed for [Microsoft Defender for Cloud](/azure/security-center/):

- If the workspace is in the legacy Standard or Premium tier, Microsoft Defender for Cloud is billed only for Log Analytics data ingestion, not per node.
- If the workspace is in the legacy Per Node tier, Microsoft Defender for Cloud is billed using the current [Microsoft Defender for Cloud node-based pricing model](https://azure.microsoft.com/pricing/details/security-center/).
- In other pricing tiers (including commitment tiers), if Microsoft Defender for Cloud was enabled before June 19, 2017, Microsoft Defender for Cloud is billed only for Log Analytics data ingestion. Otherwise, Microsoft Defender for Cloud is billed using the current Microsoft Defender for Cloud node-based pricing model.

More information on pricing tier limitations is available at [Azure subscription and service limits, quotas, and constraints](../service-limits.md#log-analytics-workspaces).

None of the legacy pricing tiers have regional-based pricing.

> [!NOTE]
> To use the entitlements that come from purchasing OMS E1 Suite, OMS E2 Suite, or OMS Add-On for System Center, choose the Log Analytics Per Node pricing tier.

## Evaluate the legacy Per Node pricing tier

It's often difficult to determine whether workspaces with access to the legacy Per Node pricing tier are better off in that tier or in a current pay-as-you-go or commitment tier. You need to understand the trade-off between the fixed cost per monitored node in the Per Node pricing tier and its included data allocation of 500 MB per node per day and the cost of paying for ingested data in the pay-as-you-go (per GB) tier.

Use the following query to make a recommendation for the optimal pricing tier based on a workspace's usage patterns. This query looks at the monitored nodes and data ingested into a workspace in the last seven days. For each day, it evaluates which pricing tier would have been optimal. To use the query, you must specify:

- Whether the workspace is using Microsoft Defender for Cloud by setting `workspaceHasSecurityCenter` to `true` or `false`.
- Update the prices if you have specific discounts.
- Specify the number of days to look back and analyze by setting `daysToEvaluate`. This option is useful if the query is taking too long trying to look at seven days of data.

```kusto
// Set these parameters before running query
// For pay-as-you-go (per-GB) and commitment tier pricing details, see https://azure.microsoft.com/pricing/details/monitor/.
// You can see your per-node costs in your Azure usage and charge data. For more information, see https://learn.microsoft.com/azure/cost-management-billing/understand/download-azure-daily-usage.  
let workspaceHasSecurityCenter = true;
let daysToEvaluate = 7;
let PerNodePrice = 15.; // Monthly price per monitored node
let PerNodeOveragePrice = 2.30; // Price per GB for data overage in the Per Node pricing tier
let PerGBPrice = 2.30; // Enter the pay-as-you-go price for your workspace's region (from https://azure.microsoft.com/pricing/details/monitor/)
let CommitmentTier100Price = 196.; // Enter your price for the 100 GB/day commitment tier
let CommitmentTier200Price = 368.; // Enter your price for the 200 GB/day commitment tier
let CommitmentTier300Price = 540.; // Enter your price for the 300 GB/day commitment tier
let CommitmentTier400Price = 704.; // Enter your price for the 400 GB/day commitment tier
let CommitmentTier500Price = 865.; // Enter your price for the 500 GB/day commitment tier
let CommitmentTier1000Price = 1700.; // Enter your price for the 1000 GB/day commitment tier
let CommitmentTier2000Price = 3320.; // Enter your price for the 2000 GB/day commitment tier
let CommitmentTier5000Price = 8050.; // Enter your price for the 5000 GB/day commitment tier
// ---------------------------------------
let SecurityDataTypes=dynamic(["SecurityAlert", "SecurityBaseline", "SecurityBaselineSummary", "SecurityDetection", "SecurityEvent", "WindowsFirewall", "MaliciousIPCommunication", "LinuxAuditLog", "SysmonEvent", "ProtectionStatus", "WindowsEvent", "Update", "UpdateSummary"]);
let StartDate = startofday(datetime_add("Day",-1*daysToEvaluate,now()));
let EndDate = startofday(now());
union * 
| where TimeGenerated >= StartDate and TimeGenerated < EndDate
| extend computerName = tolower(tostring(split(Computer, '.')[0]))
| where computerName != ""
| summarize nodesPerHour = dcount(computerName) by bin(TimeGenerated, 1h)  
| summarize nodesPerDay = sum(nodesPerHour)/24.  by day=bin(TimeGenerated, 1d)  
| join kind=leftouter (
    Heartbeat 
    | where TimeGenerated >= StartDate and TimeGenerated < EndDate
    | where Computer != ""
    | summarize ASCnodesPerHour = dcount(Computer) by bin(TimeGenerated, 1h) 
    | extend ASCnodesPerHour = iff(workspaceHasSecurityCenter, ASCnodesPerHour, 0)
    | summarize ASCnodesPerDay = sum(ASCnodesPerHour)/24.  by day=bin(TimeGenerated, 1d)   
) on day
| join (
    Usage 
    | where TimeGenerated >= StartDate and TimeGenerated < EndDate
    | where IsBillable == true
    | extend NonSecurityData = iff(DataType !in (SecurityDataTypes), Quantity, 0.)
    | extend SecurityData = iff(DataType in (SecurityDataTypes), Quantity, 0.)
    | summarize DataGB=sum(Quantity)/1000., NonSecurityDataGB=sum(NonSecurityData)/1000., SecurityDataGB=sum(SecurityData)/1000. by day=bin(StartTime, 1d)  
) on day
| extend AvgGbPerNode =  NonSecurityDataGB / nodesPerDay
| extend OverageGB = iff(workspaceHasSecurityCenter, 
             max_of(DataGB - 0.5*nodesPerDay - 0.5*ASCnodesPerDay, 0.), 
             max_of(DataGB - 0.5*nodesPerDay, 0.))
| extend PerNodeDailyCost = nodesPerDay * PerNodePrice / 31. + OverageGB * PerNodeOveragePrice
| extend billableGB = iff(workspaceHasSecurityCenter,
             (NonSecurityDataGB + max_of(SecurityDataGB - 0.5*ASCnodesPerDay, 0.)), DataGB )
| extend PerGBDailyCost = billableGB * PerGBPrice
| extend CommitmentTier100DailyCost = CommitmentTier100Price + max_of(billableGB - 100, 0.)* CommitmentTier100Price/100.
| extend CommitmentTier200DailyCost = CommitmentTier200Price + max_of(billableGB - 200, 0.)* CommitmentTier200Price/200.
| extend CommitmentTier300DailyCost = CommitmentTier300Price + max_of(billableGB - 300, 0.)* CommitmentTier300Price/300.
| extend CommitmentTier400DailyCost = CommitmentTier400Price + max_of(billableGB - 400, 0.)* CommitmentTier400Price/400.
| extend CommitmentTier500DailyCost = CommitmentTier500Price + max_of(billableGB - 500, 0.)* CommitmentTier500Price/500.
| extend CommitmentTier1000DailyCost = CommitmentTier1000Price + max_of(billableGB - 1000, 0.)* CommitmentTier1000Price/1000.
| extend CommitmentTier2000DailyCost = CommitmentTier2000Price + max_of(billableGB - 2000, 0.)* CommitmentTier2000Price/2000.
| extend CommitmentTier5000DailyCost = CommitmentTier5000Price + max_of(billableGB - 5000, 0.)* CommitmentTier5000Price/5000.
| extend MinCost = min_of(
    PerNodeDailyCost,PerGBDailyCost,CommitmentTier100DailyCost,CommitmentTier200DailyCost,
    CommitmentTier300DailyCost, CommitmentTier400DailyCost, CommitmentTier500DailyCost, CommitmentTier1000DailyCost, CommitmentTier2000DailyCost, CommitmentTier5000DailyCost)
| extend Recommendation = case(
    MinCost == PerNodeDailyCost, "Per node tier",
    MinCost == PerGBDailyCost, "Pay-as-you-go tier",
    MinCost == CommitmentTier100DailyCost, "Commitment tier (100 GB/day)",
    MinCost == CommitmentTier200DailyCost, "Commitment tier (200 GB/day)",
    MinCost == CommitmentTier300DailyCost, "Commitment tier (300 GB/day)",
    MinCost == CommitmentTier400DailyCost, "Commitment tier (400 GB/day)",
    MinCost == CommitmentTier500DailyCost, "Commitment tier (500 GB/day)",
    MinCost == CommitmentTier1000DailyCost, "Commitment tier (1000 GB/day)",
    MinCost == CommitmentTier2000DailyCost, "Commitment tier (2000 GB/day)",
    MinCost == CommitmentTier5000DailyCost, "Commitment tier (5000 GB/day)",
    "Error"
)
| project day, nodesPerDay, ASCnodesPerDay, NonSecurityDataGB, SecurityDataGB, OverageGB, AvgGbPerNode, PerGBDailyCost, PerNodeDailyCost, 
    CommitmentTier100DailyCost, CommitmentTier200DailyCost, CommitmentTier300DailyCost, CommitmentTier400DailyCost, CommitmentTier500DailyCost, CommitmentTier1000DailyCost, CommitmentTier2000DailyCost, CommitmentTier5000DailyCost, Recommendation 
| sort by day asc
//| project day, Recommendation // Comment this line to see details
| sort by day asc
```

This query isn't an exact replication of how usage is calculated, but it provides pricing tier recommendations in most cases.

> [!NOTE]
> To use the entitlements that come from purchasing OMS E1 Suite, OMS E2 Suite, or OMS Add-On for System Center, choose the Log Analytics Per Node pricing tier.

## Next steps

- See [Azure Monitor cost and usage](../cost-usage.md) for a description of the different types of Azure Monitor charges and how to analyze them on your Azure bill.
- See [Analyze usage in Log Analytics workspace](analyze-usage.md) for details on analyzing the data in your workspace to determine the source of any higher-than-expected usage and opportunities to reduce your amount of data collected.
- See [Set daily cap on Log Analytics workspace](daily-cap.md) to control your costs by configuring a maximum volume that might be ingested in a workspace each day.
- See [Azure Monitor best practices - Cost management](../best-practices-cost.md) for best practices on configuring and managing Azure Monitor to minimize your charges.

