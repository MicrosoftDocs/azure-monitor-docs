---
title: Azure Monitor cost and usage
description: Overview of how Azure Monitor is billed and how to analyze billable usage.
services: azure-monitor
ms.topic: conceptual
ms.reviewer: Dale.Koetke
ms.date: 01/24/2024
---

# Azure Monitor cost and usage
This article describes the different ways that Azure Monitor charges for usage and how to evaluate charges on your Azure bill.

[!INCLUDE [azure-monitor-cost-optimization](../../includes/azure-monitor-cost-optimization.md)]

## Pricing model

Azure Monitor uses a consumption-based pricing (pay-as-you-go) billing model where you only pay for what you use. Features of Azure Monitor that are enabled by default don't incur any charge. This includes collection and alerting on the [Activity log](essentials/activity-log.md) and collection and analysis of [platform metrics](essentials/metrics-supported.md). 

Several other features don't have a direct cost, but you instead pay for the ingestion and retention of data that they collect. The following table describes the different types of usage that are charged in Azure Monitor. Detailed current pricing for each is provided in [Azure Monitor pricing](https://azure.microsoft.com/pricing/details/monitor/).


| Type | Description |
|:---|:---|
| Logs |Ingestion, retention, and export of data in [Log Analytics workspaces](logs/log-analytics-workspace-overview.md) and [legacy Application insights resources](/previous-versions/azure/azure-monitor/app/convert-classic-resource). Log data ingestion is the largest component of Azure Monitor charges for most customers. There's no charge for querying this data except in the case of [Basic and Auxiliary logs](../azure-monitor/logs/data-platform-logs.md#table-plans) or [data in long-term retention](logs/data-retention-configure.md).<br><br>Charges for Logs can vary significantly on the configuration that you choose. See [Azure Monitor Logs pricing details](logs/cost-logs.md) for details on how charges for Logs data are calculated and the different pricing tiers available. |
| Platform Logs | Processing of [diagnostic and auditing information](essentials/resource-logs.md) is charged for [certain services](essentials/resource-logs-categories.md#costs) when sent to destinations other than a Log Analytics workspace. There's no direct charge when this data is sent to a Log Analytics workspace, but there's a charge for the workspace data ingestion and collection. |
| Metrics | There's no charge for [standard metrics](essentials/metrics-supported.md) collected from Azure resources. There's a cost for collecting [custom metrics](essentials/metrics-custom-overview.md) and for retrieving metrics from the [REST API](essentials/rest-api-walkthrough.md#retrieve-metric-values). |
| Prometheus Metrics | Pricing for [Azure Monitor managed service for Prometheus](essentials/prometheus-metrics-overview.md) is based on [data samples ingested](containers/kubernetes-monitoring-enable.md#enable-prometheus-and-grafana)  and [query samples processed](essentials/azure-monitor-workspace-manage.md#link-a-grafana-workspace). Data is retained for 18 months at no extra charge. |
| Alerts | Alerts are charged based on the type and number of [signals](alerts/alerts-overview.md) used by the alert rule, its frequency, and the type of [notification](alerts/action-groups.md) used in response. For [log search alerts](alerts/alerts-types.md#log-alerts) configured for [at scale monitoring](alerts/alerts-types.md#monitor-the-same-condition-on-multiple-resources-using-splitting-by-dimensions-1), the cost also depends on the number of time series created by the dimensions resulting from your query. |
| Web tests | There's a cost for [standard web tests](app/availability-standard-tests.md) and [multi-step web tests](app/availability-multistep.md) in Application Insights. Multi-step web tests are deprecated.|

A list of Azure Monitor billing meter names is available [here](cost-meters.md). 

### Data transfer charges 
Sending data to Azure Monitor can incur data bandwidth charges. As described in the [Azure Bandwidth pricing page](https://azure.microsoft.com/pricing/details/bandwidth/), data transfer between Azure services located in two regions charged as outbound data transfer at the normal rate. Inbound data transfer is free. Data transfer charges for Azure Monitor though are typically very small compared to the costs for data ingestion and retention. You should focus more on your ingested data volume to control your costs.

> [!NOTE]
> Data sent to a different region using [Diagnostic Settings](essentials/diagnostic-settings.md) does not incur data transfer charges

## View Azure Monitor usage and charges
There are two primary tools to view, analyze, and optimize your Azure Monitor costs. Each is described in detail in the following sections.

| Tool | Description |
|:---|:---|
| [Azure Cost Management + Billing](#azure-cost-management--billing) | Gives you powerful capabilities use to understand your billed costs. There are multiple options to analyze your charges for different Azure Monitor features and their projected cost over time. |
| [Usage and Estimated Costs](#usage-and-estimated-costs) | Provides estimates of log data ingestion costs based on your daily usage patterns to help you optimize to use the most cost-effective logs pricing tier. |


## Azure Cost Management + Billing
To get started analyzing your Azure Monitor charges, open [Cost Management + Billing](/azure/cost-management-billing/costs/quick-acm-cost-analysis?toc=/azure/billing/TOC.json) in the Azure portal. This tool includes several built-in dashboards for deep cost analysis like cost by resource and invoice details. Access policies are described [here](/azure/cost-management-billing/manage/manage-billing-access#give-others-access-to-view-billing-information). Select **Cost Management** and then **Cost analysis**. Select your subscription or another [scope](/azure/cost-management-billing/costs/understand-work-scopes).

Next, create a **Daily Costs** view, and change the **Group by** to show costs by **Meter** so that you can see each the costs from each feature. The meter names for each Azure Monitor feature are listed [here](cost-meters.md).

>[!NOTE]
>You might need additional access to use Cost Management data. See [Assign access to Cost Management data](/azure/cost-management-billing/costs/assign-access-acm-data).


:::image type="content" source="media/usage-estimated-costs/010.png" lightbox="media/usage-estimated-costs/010.png" alt-text="Screenshot that shows Azure Cost Management with cost information.":::

To limit the view to Azure Monitor charges, [create a filter](/azure/cost-management-billing/costs/group-filter) for the following **Service names**. 
- Azure Monitor
- Log Analytics
- Insight and Analytics
- Application Insights

See [Azure Monitor billing meter names](cost-meters.md) for a list of all Azure Monitor billing meters that are included in each of these services.

Other services such as Microsoft Defender for Cloud and Microsoft Sentinel also bill their usage against Log Analytics workspace resources. See [Common cost analysis uses](/azure/cost-management-billing/costs/cost-analysis-common-uses) for details on using this view.


> [!NOTE]
> Alternatively, you can go to the **Overview** page of a Log Analytics workspace or Application Insights resource and click **View Cost** in the upper right corner of the **Essentials** section. This will launch the **Cost Analysis** from Azure Cost Management + Billing already scoped to the workspace or application. (You might need to use the [preview version](https://preview.portal.azure.com/) of the Azure portal to see this option.) 
> :::image type="content" source="logs/media/view-bill/view-cost-option.png" lightbox="logs/media/view-bill/view-cost-option.png" alt-text="Screenshot of option to view cost for Log Analytics workspace.":::
### Automated mails and alerts
Rather than manually analyzing your costs in the Azure portal, you can automate delivery of information using the following methods.

- **Daily cost analysis emails.** After you configure your Cost Analysis view, select **Subscribe** at the top of the screen to receive regular email updates from Cost Analysis.
- **Budget alerts.** To be notified if there are significant increases in your spending, create a [budget alerts](/azure/cost-management-billing/costs/cost-mgt-alerts-monitor-usage-spending) for a single workspace or group of workspaces. 

### Export usage details

To gain deeper understanding of your usage and costs, create exports using **Cost Analysis**. See [Tutorial: Create and manage exported data](/azure/cost-management-billing/costs/tutorial-export-acm-data) to learn how to automatically create a daily export you can use for regular analysis.

These exports are in CSV format and contain a list of daily usage (billed quantity and cost) by resource, [billing meter](cost-meters.md), and several other fields such as [AdditionalInfo](/azure/cost-management-billing/automate/understand-usage-details-fields#list-of-fields-and-descriptions). You can use Microsoft Excel to do rich analyses of your usage not possible in the **Cost Analytics** experiences in the portal.

For example, usage from Log Analytics can be found by first filtering on the **Meter Category** column to show: 

1. **Log Analytics** (for Pay-as-you-go data ingestion and interactive Data Retention), 
2. **Insight and Analytics** (used by some of the legacy pricing tiers), and 
3. **Azure Monitor** (used by most other Log Analytics features such as Commitment Tiers, Basic Logs ingesting, Long-Term Retention, Search Queries, Search Jobs, and so on) 

Add a filter on the **Instance ID** column for **contains workspace** or **contains cluster**. The usage is shown in the **Consumed Quantity** column. The unit for each entry is shown in the **Unit of Measure** column.

> [!NOTE]
> See [Azure Monitor billing meter names](cost-meters.md) for a reference of the billing meter names used by Azure Monitor in Azure Cost Management + Billing. 

## View data allocation benefits

There are several approaches to view the benefits a workspace receives from offers that are part of other products. These offers are:

1. [Defender for Servers data allowance](logs/cost-logs.md#workspaces-with-microsoft-defender-for-cloud) and 

1. [Microsoft Sentinel benefit for Microsoft 365 E5, A5, F5, and G5 customers](https://azure.microsoft.com/offers/sentinel-microsoft-365-offer/).

> [!NOTE]
> To receive the Defender for Servers data allowance on your Log Analytics workspace, the **Security** solution must have been [created on the workspace](/cli/azure/monitor/log-analytics/solution).

### View benefits in a usage export

Since a usage export has both the number of units of usage and their cost, you can use this export to see the benefits you're receiving. In the usage export, to see the benefits, filter the *Instance ID* column to your workspace. (To select all of your workspaces in the spreadsheet, filter the *Instance ID* column to "contains /workspaces/".) Then filter on the Meter to either of the following 2 meters:

- **Standard Data Included per Node**: this meter is under the service "Insight and Analytics" and tracks the benefits received when a workspace in either in Log Analytics [Per Node tier](logs/cost-logs.md#per-node-pricing-tier) data allowance and/or has [Defender for Servers](logs/cost-logs.md#workspaces-with-microsoft-defender-for-cloud) enabled. Each of these allowances provides a 500 MB/server/day data allowance. 

- **Free Benefit - M365 Defender Data Ingestion**: this meter, under the service "Azure Monitor", tracks the benefit from the [Microsoft Sentinel benefit for Microsoft 365 E5, A5, F5, and G5 customers](https://azure.microsoft.com/offers/sentinel-microsoft-365-offer/).

### View benefits in Usage and estimated costs

You can also see these data benefits in the Log Analytics Usage and estimated costs page. If the workspace is receiving these benefits, there's a sentence below the cost estimate table that gives the data volume of the benefits used over the last 31 days. 

:::image type="content" source="media/cost-usage/log-analytics-workspace-benefit.png" lightbox="media/cost-usage/log-analytics-workspace-benefit.png" alt-text="Screenshot of monthly usage with benefits from Defender and Sentinel offers.":::


### Query benefits from the Operation table

The [Operation](/azure/azure-monitor/reference/tables/operation) table contains daily events which given the amount of benefit used from the [Defender for Servers data allowance](logs/cost-logs.md#workspaces-with-microsoft-defender-for-cloud) and the [Microsoft Sentinel benefit for Microsoft 365 E5, A5, F5, and G5 customers](https://azure.microsoft.com/offers/sentinel-microsoft-365-offer/). The `Detail` column for these events is in the format `Benefit amount used 1.234 GB`, and the type of benefit is in the `OperationKey` column. Here's a query that charts the benefits used in the last 31-days:

```kusto
Operation
| where TimeGenerated >= ago(31d)
| where Detail startswith "Benefit amount used"
| parse Detail with "Benefit amount used: " BenefitUsedGB " GB"
| extend BenefitUsedGB = toreal(BenefitUsedGB)
| parse OperationKey with "Benefit type used: " BenefitType 
| project BillingDay=TimeGenerated, BenefitType, BenefitUsedGB
| sort by BillingDay asc, BenefitType asc
| render columnchart 
```

(This functionality of reporting the benefits used in the `Operation` table started January 27, 2024.) 

> [!TIP]
> If you [increase the data retention](logs/data-retention-configure.md) of the [Operation](/azure/azure-monitor/reference/tables/operation) table, you will be able to view these benefit trends over longer periods.  
>

## Usage and estimated costs
You can get more usage details about Log Analytics workspaces and Application Insights resources from the **Usage and Estimated Costs** option for each.

### Log Analytics workspace
To learn about your usage trends and optimize your costs using the most cost-effective [commitment tier](logs/cost-logs.md#commitment-tiers) for your Log Analytics workspace, select **Usage and Estimated Costs** from the **Log Analytics workspace** menu in the Azure portal. 

:::image type="content" source="media/cost-usage/usage-estimated-cost-dashboard-01.png" lightbox="media/cost-usage/usage-estimated-cost-dashboard-01.png" alt-text="Screenshot of usage and estimated costs screen in Azure portal.":::

This view includes the following sections:

A. Estimated monthly charges based on usage from the past 31 days using the current pricing tier.<br>
B. Estimated monthly charges using different commitment tiers.<br>
C. Billable data ingestion by solution from the past 31 days.

To explore the data in more detail, select the icon in the upper-right corner of either chart to work with the query in Log Analytics.  

:::image type="content" source="logs/media/manage-cost-storage/logs.png" lightbox="logs/media/manage-cost-storage/logs.png" alt-text="Screenshot of log query with Usage table in Log Analytics.":::

### Application insights

#### Workspace-based resources

To learn about usage on your workspace-based resources, see [Data volume trends for workspace-based resources](logs/analyze-usage.md#data-volume-trends-for-workspace-based-resources).

#### Classic resources

To learn about usage on retired classic Application Insights resources, select **Usage and Estimated Costs** from the **Applications** menu in the Azure portal. 

:::image type="content" source="media/usage-estimated-costs/app-insights-usage.png" lightbox="media/usage-estimated-costs/app-insights-usage.png" alt-text="Screenshot of usage and estimated costs for Application Insights in Azure portal.":::

This view includes the following:

A. Estimated monthly charges based on usage from the past month.<br>
B. Billable data ingestion by table from the past month.

To investigate your Application Insights usage more deeply, open the **Metrics** page, add the metric named *Data point volume*, and then select the *Apply splitting* option to split the data by "Telemetry item type".

## Operations Management Suite subscription entitlements

Customers who purchased Microsoft Operations Management Suite E1 and E2 are eligible for per-node data ingestion entitlements for Log Analytics and Application Insights. Each Application Insights node includes up to 200 MB of data ingested per day (separate from Log Analytics data ingestion), with 90-day data retention at no extra cost.

To receive these entitlements for Log Analytics workspaces or Application Insights resources in a subscription, they must use the Per-Node (OMS) pricing tier. This entitlement isn't visible in the estimated costs shown in the Usage and estimated cost pane. 

Depending on the number of nodes of the suite that your organization purchased, moving some subscriptions into a Per GB (pay-as-you-go) pricing tier might be advantageous, but this change in pricing tier requires careful consideration.

> [!TIP]
> If your organization has Microsoft Operations Management Suite E1 or E2, it's usually best to keep your Log Analytics workspaces in the Per-Node (OMS) pricing tier and your Application Insights resources in the Enterprise pricing tier. 
>

## Azure Migrate data benefits

Workspaces linked to [classic Azure Migrate](/azure/migrate/migrate-services-overview#azure-migrate-versions) receive free data benefits for the data tables related to Azure Migrate (`ServiceMapProcess_CL`, `ServiceMapComputer_CL`, `VMBoundPort`, `VMConnection`, `VMComputer`, `VMProcess`, `InsightsMetrics`). This version of Azure Migrate was retired in February 2024. 

Starting from 1 July 2024, the data benefit for Azure Migrate in Log Analytics will no longer be available. We suggest moving to the [Azure Migrate agentless dependency analysis](/azure/migrate/how-to-create-group-machine-dependencies-agentless). If you continue with agent-based dependency analysis, standard [Azure Monitor charges](https://azure.microsoft.com/pricing/details/monitor/) apply for the data ingestion that enables dependency visualization. 

## Next steps

- See [Azure Monitor Logs pricing details](logs/cost-logs.md) for details on how charges are calculated for data in a Log Analytics workspace and different configuration options to reduce your charges.
- See [Analyze usage in Log Analytics workspace](logs/analyze-usage.md) for details on analyzing the data in your workspace to determine to source of any higher than expected usage and opportunities to reduce your amount of data collected.
- See [Set daily cap on Log Analytics workspace](logs/daily-cap.md) to control your costs by setting a daily limit on the amount of data that might be ingested in a workspace.
- See [Azure Monitor best practices - Cost management](best-practices-cost.md) for best practices on configuring and managing Azure Monitor to minimize your charges.
