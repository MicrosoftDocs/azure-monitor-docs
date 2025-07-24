---
ms.topic: include
ms.date: 05/08/2025
---


### Data collection volume and retention

| Pricing tier | Limit per day | Data retention | Comment |
|:-------------|:--------------|:---------------|:--------|
| [Pay-as-you-go](../cost-logs.md#pricing-model)<br>(introduced April 2018) | No limit | Up to 730 days interactive retention/<br> up to 12 years [data archive](../data-retention-configure.md) | Data retention beyond 31 days is available for extra charges. Learn more about [Azure Monitor pricing](https://azure.microsoft.com/pricing/details/monitor). |
| [Commitment tiers](../cost-logs.md#commitment-tiers)<br>(introduced November 2019) | No limit | Up to 730 days interactive retention/<br> up to 12 years [data archive](../data-retention-configure.md) | Data retention beyond 31 days is available for extra charges. Learn more about [Azure Monitor pricing](https://azure.microsoft.com/pricing/details/monitor). |
| [Legacy Per Node (OMS)](../cost-logs.md#per-node-pricing-tier)<br>(introduced April 2016) | No limit | 30 to 730 days | Data retention beyond 31 days is available for extra charges. Learn more about [Azure Monitor pricing](https://azure.microsoft.com/pricing/details/monitor). Only customers who meet one of the following conditions can access this pricing tier:</br>- subscriptions that contained a Log Analytics workspace or Application Insights resource before April 2, 2018</br>- subscriptions linked to an Enterprise Agreement that started before February 1, 2019 and is still active. |
| [Legacy Standalone tier](../cost-logs.md#standalone-pricing-tier)<br>(introduced April 2016) | No limit | 30 to 730 days | Data retention beyond 31 days is available for extra charges. Learn more about [Azure Monitor pricing](https://azure.microsoft.com/pricing/details/monitor). Only customers who meet one of the following conditions can access this pricing tier:</br>- subscriptions that contained a Log Analytics workspace or Application Insights resource before April 2, 2018</br>- subscriptions linked to an Enterprise Agreement that started before February 1, 2019 and is still active. |
| [Legacy Free tier](../cost-logs.md#free-trial-pricing-tier)<br>(introduced April 2016) | 500 MB | 7 days | When your workspace reaches the 500-MB-per-day limit, data ingestion stops and resumes at the start of the next day. A day is based on UTC. Data collected by Microsoft Defender for Cloud isn't included in this 500-MB-per-day limit and continues to be collected above this limit. Creating new workspaces in, or moving existing workspaces into, the legacy Free Trial pricing tier was only possible until July 1, 2022. |
| [Legacy Standard tier](../cost-logs.md#standard-and-premium-pricing-tiers) | No limit | 30 days | Retention can't be adjusted. This tier is unavailable to new workspaces since October 1, 2016. |
| [Legacy Premium tier](../cost-logs.md#standard-and-premium-pricing-tiers) | No limit | 365 days | Retention can't be adjusted. This tier is unavailable to new workspaces since October 1, 2016. |

### Number of workspaces per subscription

| Pricing tier | Workspace limit | Comments |
|:-------------|:----------------|:---------|
| Legacy Free tier | 10 | This limit can't be increased. Creating new workspaces in, or moving existing workspaces into, the legacy Free Trial pricing tier was only possible until July 1, 2022. |
| All other tiers | No limit | You're limited by the number of resources within a resource group and the number of resource groups per subscription. |

<a name="azure-portal"></a>

### Azure portal

| Category | Limit | Comments |
|:---------|:------|:---------|
| Maximum records returned by a log query | 500,000 | Reduce results by using query scope, time range, and filters in the query. |
| Maximum size of data returned | ~104 MB (~100 MiB)|The portal UI returns up to 64 MB of compressed data, which translates to up to 100 MB of raw data. |

### Data Collector API

| Category | Limit | Comments |
|:---------|:------|:---------|
| Maximum size for a single post | 30 MB | Split larger volumes into multiple posts. |
| Maximum size for field values | 32 KB | Fields longer than 32 KB are truncated. |

<a name="la-query-api"></a>

### Query API

| Category | Limit | Comments |
|:---------|:------|:---------|
| Maximum records returned in a single query | 500,000 | |
| Maximum size of data returned | ~104 MB (~100 MiB)|The API returns up to 64 MB of compressed data, which translates to up to 100 MB of raw data. |
| Maximum query running time | 10 minutes | See [Timeouts](../api/timeouts.md) for details.|
| Maximum request rate | 200 requests per 30 seconds per Microsoft Entra user or client IP address | See [Log queries and language](../../fundamentals/service-limits.md#log-queries-and-language).|

### Azure Monitor Logs connector

| Category | Limit | Comments |
|:---------|:------|:---------|
| Maximum size of data | ~16.7 MB (~16 MiB) | The connector infrastructure dictates that limit is set lower than query API limit. |
| Maximum number of records | 500,000 |  |
| Maximum connector timeout | 110 second |  |
| Maximum query timeout | 100 second |  |
| Charts |  | The Logs page and the connector use different charting libraries for visualization. Some functionality isn't currently available in the connector. |

### Summary rules

| Category | Limit |
|:---------|:------|
| Maximum number of active rules in a workspace | 30 |
| Maximum number of results per bin | 500,000 |
| Maximum results set volume | 100 MB |
| Query time-out for bin processing | 10 minutes |

### General workspace limits

| Category | Limit | Comments |
|:---------|:------|:---------|
| Maximum columns in a table | 500 | **AzureDiagnostics** - columns above the limit are added to dynamic 'AdditionalFields' column<br>**Custom log created by Data collector API** - columns above the limit are added to dynamic 'AdditionalFields' column<br>**Custom log** - contact support to increase limit |
| Maximum number of custom log tables | 500 | Contact support to increase limit |
| Maximum characters for column name | 45 | |

<b id="data-ingestion-volume-rate">Data ingestion volume rate</b>

Azure Monitor is a high-scale data service that serves thousands of customers sending Terabytes of data each daily and at a growing pace. A soft volume rate limit intends to isolate Azure Monitor customers from sudden ingestion spikes in a multitenancy environment. The default ingestion volume rate threshold in workspaces is 500 MB (compressed), which is translated to approximately 6 GB/min uncompressed.

The volume rate limit applies to data ingested from [workspace-based Application Insights](../../app/create-workspace-resource.md), Azure resources via [Diagnostic settings](../../essentials/diagnostic-settings.md), and [Data Collector API](../../logs/data-collector-api.md). When the volume rate limit is reached, a retry mechanism attempts to ingest the data four times in a period of 12 hours and drop it if operation fails. The limit doesn't apply to data ingested from [agents](../../agents/agents-overview.md), or via [Data Collection Rule (DCR)](../../essentials/data-collection-rule-overview.md).

When volume rate is higher than 80% of the threshold in your workspace, an event is sent to the `Operation` table in your workspace every 6 hours while the threshold exceeds. When the ingested volume rate is higher than the threshold, some data is dropped, an event is sent to the `Operation` table in your workspace every 6 hours while the threshold exceeds. 

If your ingestion volume rate exceeds this threshold or you're planning to increase ingestion past that threshold, **contact support to request increasing the rate limit in your workspace**.

**Best practice** - Create an alert rule to get notified when nearing or reaching ingestion rate limits. See [Monitor health of Log Analytics workspace in Azure Monitor](../monitor-workspace.md).

>[!NOTE]
>Depending on how long you've been using Log Analytics, you might have access to legacy pricing tiers. Learn more about [Log Analytics legacy pricing tiers](../cost-logs.md#legacy-pricing-tiers).
