---
title: SDK Stats workbooks for Azure Monitor Application Insights (Preview)
description: Use SDK Stats workbooks to visualize telemetry export success, dropped counts, retry counts, and drop reasons produced by the Azure Monitor Software Development Kits (SDKs) and agents.
ms.service: azure-monitor
ms.subservice: application-insights
ms.topic: conceptual
ms.date: 08/28/2025
---

# SDK Stats workbooks for Application Insights (Preview)

Use SDK Stats workbooks to monitor how Application Insights SDKs and agents export telemetry to the Breeze ingestion endpoint. These workbooks visualize internal custom metrics that the SDKs publish.

> [!NOTE]
> SDK Stats workbooks add new visualizations. They don't replace existing Application Insights workbooks.

## What SDK stats are

SDK stats are per-process counters that the Application Insights SDKs and agents emit as **custom metrics**. These metrics summarize how many telemetry items the exporter sends successfully, how many items the exporter drops, and how many items the exporter schedules for retry.

These workbooks visualize three metrics:

- `preview.item.success.count`
- `preview.item.dropped.count`
- `preview.item.retry.count`

SDK stats appear as **custom metrics** that you can use in Workbooks, query in Log Analytics through the `customMetrics` table, and plot in Metrics explorer.

<!-- TODO: Confirm that all supported SDKs map these names exactly. Keep the names present until engineering provides final casing and prefixes. -->

**Dimensions**

The metrics include useful dimensions in `customDimensions` and standard Application Insights dimensions for slicing:

| Dimension key                          | Description                                                                                                                                                                                                  |
| -------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `telemetry_type`                       | The telemetry type associated with the count. Examples include `REQUEST`, `DEPENDENCY`, `EXCEPTION`, `TRACE`, and `EVENT`. <!-- TODO: Confirm the complete set of values the SDK emits. -->                  |
| `drop.reason`                          | A categorical reason for a dropped item. Examples include client-side conditions and Breeze responses.                                                                                                       |
| `drop.code`                            | A code that further qualifies `drop.reason`. For Breeze responses, this value is the HTTP status code. For client-side reasons, it's an internal code. <!-- TODO: Provide the full list of codes per SDK. --> |
| `telemetry_success`                    | For request and dependency telemetry, the value of the item’s `success` field at the time of export. Values are the strings `true` or `false`.                                                               |
| `sdkVersion`                           | The SDK version that emitted the metric.                                                                                                                                                                     |
| `cloud_RoleName`, `cloud_RoleInstance` | Standard resource dimensions you can use to slice by service and instance.                                                                                                                                   |

The value for each metric row is an **aggregated count** for the time grain the SDK uses when it publishes counters.

## Open the SDK Stats dashboards

Open your Application Insights resource, then open **Workbooks** and select **SDK Stats Dashboards (Preview)**.

### Filters

Use the filters at the top of the workbook to scope the views:

- **Time Range**. Set the time window and the bin size.
- **SDK Version**. Filter by the `sdkVersion` field.
- **Telemetry Type**. Filter by the `telemetry_type` dimension.
- **Drop Reason**. Filter by the `drop.reason` dimension.
- **Drop Code**. Filter by the `drop.code` dimension.

### Success dashboard

Use this dashboard to track exporter outcomes over time.

- **Telemetry export success, retry, and failure timechart**. Plots the `preview.item.success.count`, `preview.item.retry.count`, and `preview.item.dropped.count` series together to keep context.
- **Failure ratio**. Computes `dropped / success` on the selected time grain to baseline expected exporter behavior.
- **Retry to eventual success ratio**. Computes `success / retry` for the window to distinguish transient issues from permanent errors.

Selecting a time bucket opens a details section that lists the top drop reasons for that bucket.

### Dropped dashboard

Use this dashboard to understand why items were dropped.

- **Drop reasons over time**. Plots `drop.reason` categories on a timechart to show spikes.
- **Drop reasons summary table**. Lists the total dropped count per reason and code in the selected time range.
- **Drop reasons distribution**. Shows the relative distribution across reasons with a pie chart.
- **Reason and code drill-down**. Use the breakdown of `drop.reason × drop.code` to map drops to HTTP status and client-side conditions.

Use the **Telemetry Type**, **Drop Reason**, **Drop Code**, and **SDK Version** filters to focus on a specific issue such as throttling or bad requests.

### Instance dashboard

Use this dashboard to locate where drops occur.

- **By cloud role and instance**. Breaks down dropped, retried, and successful counts by `cloud_RoleName` and `cloud_RoleInstance`.
- **By SDK version**. Surfaces counts by `sdkVersion` to identify regressions after upgrades.

> <!-- TODO: If a dedicated "Instance" workbook isn't provided, confirm whether these visuals live inside the Success or Dropped workbook as grids. -->

## Enable SDK stats

Support depends on the SDK or agent and version. The feature is enabled by default for supported SDKs.

- **.NET SDK**. Enabled by default. Use a configuration setting or environment variable to disable when required for troubleshooting or compliance. <!-- TODO: Add the exact switch name and supported versions for Classic vs. Distro. -->
- **Java SDK**. Enabled by default. Provide a configuration property to disable. <!-- TODO: Add the exact property name and supported versions. -->
- **Node.js or Browser JavaScript SDK**. Enabled by default. Provide a configuration flag to disable. <!-- TODO: Add the exact flag and supported versions. -->
- **Python SDK**. Enabled by default in the Azure Monitor OpenTelemetry packages. Provide a configuration flag to disable. <!-- TODO: Add the exact flag and supported versions. -->
- **Azure Monitor OpenTelemetry exporter and Distro**. The exporter and Distro emit these metrics when supported by the language. <!-- TODO: List minimum versions once PMs provide them. -->
- **Application Insights Agents**. Status Monitor V2 and the Java In-Process Agents inherit exporter logic and emit SDK stats when enabled. <!-- TODO: Add agent versions after confirmation. -->

You don't need to deploy any workbook resources. The SDK Stats templates appear in the **Workbooks** gallery under your Application Insights resource.

## How collection works

The SDK increments counters as it evaluates and exports telemetry. The SDK sends the counters on a regular interval as `customMetrics` records. Each record aggregates counts for the interval and includes the dimensions listed earlier.

Flow:

1. The application creates telemetry and the SDK applies sampling and processors.
2. The exporter sends a batch of telemetry to Breeze.
3. The exporter records `preview.item.success.count` for items Breeze accepts.
4. The exporter records `preview.item.dropped.count` for items the exporter drops, including `drop.reason` and `drop.code`.
5. When Breeze returns a transient error, the exporter schedules items for retry and increments `preview.item.retry.count`. If a later attempt succeeds, those items contribute to the success counters at send time.
6. The SDK publishes the aggregated counters as `customMetrics` at fixed intervals.

<!-- TODO: Document the default publish interval and whether the interval differs per SDK. -->

## Drop reasons and Breeze response codes

The exporter sets `drop.reason` and `drop.code` when it drops telemetry. The following cases describe common behavior. The exact values and actions can vary by SDK. Retry rules follow a consistent goal: retry on transient errors and drop on permanent errors.

### Client-side reasons

| drop.reason                            | drop.code     | What it means                                                   | Exporter action                                                      |
| -------------------------------------- | ------------- | --------------------------------------------------------------- | -------------------------------------------------------------------- |
| `QueueFull`                            | Internal code | The in-memory queue or local storage is full.                   | Drop the overflow items.                                             |
| `LocalStorageFailure`                  | Internal code | The exporter can't write to offline storage.                    | Drop the affected items.                                             |
| `InvalidTelemetry` or `SerializeError` | Internal code | The item is invalid after serialization or size checks.         | Drop the invalid item.                                               |
| `ThrottledBySdk` or `Backoff`          | Internal code | The SDK self-throttled based on backoff rules or `Retry-After`. | Keep the item in the retry buffer when configured. Drop on overflow. |
| `Filtering` or `Sampling`              | Internal code | A telemetry processor or sampling filter removed the item.      | Drop the filtered item.                                              |

<!-- TODO: Replace placeholder names with the exact enum values per SDK once the spec is finalized. -->

### Breeze HTTP responses

When Breeze returns an HTTP response, the exporter interprets the code as follows.

| HTTP status from Breeze               | Typical reason                                       | Exporter action                                                                                                   |
| ------------------------------------- | ---------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- |
| `200 OK`                              | All items accepted.                                  | Count all items as success.                                                                                       |
| `206 Partial Content`                 | Some items accepted and some rejected in the batch.  | Count accepted items as success and rejected items as dropped.                                                    |
| `400 Bad Request`                     | Invalid payload or unsupported schema.               | Drop the items.                                                                                                   |
| `401 Unauthorized` or `403 Forbidden` | Invalid or missing credentials or connection string. | Drop the items until configuration is fixed.                                                                      |
| `402 Payment Required`                | Daily cap or quota exceeded.                         | Drop the items until the cap window resets. Don't retry during the window.                                        |
| `408 Request Timeout`                 | Network timeout.                                     | Retry with exponential backoff.                                                                                   |
| `413 Payload Too Large`               | Batch size too large.                                | Drop the batch or split on next attempt depending on SDK behavior. <!-- TODO: Confirm exact behavior per SDK. --> |
| `429 Too Many Requests`               | Breeze throttling.                                   | Respect `Retry-After` and retry with backoff.                                                                     |
| `5xx Server Error`                    | Transient service issue.                             | Retry with exponential backoff.                                                                                   |

Items scheduled for retry aren't counted as dropped unless the exporter abandons them or the retry buffer overflows.

<!-- TODO: Confirm whether each SDK records a drop only after retry exhaustion and whether a later success increments success without decrementing retry. -->

## Use SDK stats outside Workbooks

You can use these metrics across Azure Monitor tools and external systems.

### Metrics explorer

You can chart SDK stats in Metrics explorer because they're custom metrics on the Application Insights resource.

1. Open your Application Insights resource.
2. Open **Metrics**.
3. Select the **Custom metrics** namespace.
4. Select a metric such as `preview.item.success.count`, `preview.item.dropped.count`, or `preview.item.retry.count`.
5. Add a filter or split by `cloud_RoleName`, `cloud_RoleInstance`, `telemetry_type`, or `sdkVersion` as needed.

<!-- TODO: Confirm the exact metrics namespace label that contains these metrics in Metrics explorer. -->

### Power BI

Use the **Azure Monitor Logs** connector to bring these metrics into Power BI.

1. Open Power BI Desktop and select **Get data**.
2. Select **Azure** then **Azure Monitor Logs**.
3. Provide the subscription, resource group, and select your Application Insights resource.
4. Paste a Kusto Query Language (KQL) query. Power BI supports parameters for time range by using `ago()` or `now()` in the query.

**Sample query: failure ratio by hour**

```kusto
let window = 14d;
let g = 1h;
customMetrics
| where timestamp >= ago(window)
| where name in ("preview.item.success.count", "preview.item.dropped.count", "preview.item.retry.count")
| summarize 
    success = sumif(todouble(value), name == "preview.item.success.count"),
    dropped = sumif(todouble(value), name == "preview.item.dropped.count"),
    retry   = sumif(todouble(value), name == "preview.item.retry.count")
    by bin(timestamp, g)
| extend failure_ratio = dropped / iff(success == 0.0, 1.0, success)
| extend retry_to_success_ratio = iff(retry == 0.0, 1.0, success / retry)
| project timestamp, success, retry, dropped, failure_ratio, retry_to_success_ratio
| order by timestamp asc
```

**Sample query: dropped items by reason**

```kusto
let window = 14d;
let g = 1h;
customMetrics
| where timestamp >= ago(window)
| where name == "preview.item.dropped.count"
| extend drop_reason = tostring(customDimensions["drop.reason"])
| summarize dropped = sum(todouble(value)) by bin(timestamp, g), drop_reason
| order by timestamp asc
```

### Alerts

Create a log alert that monitors the failure ratio or specific drop codes.

**Alert query: failure ratio over 5 minutes**

```kusto
let window = 5m;
customMetrics
| where timestamp >= ago(window)
| where name in ("preview.item.success.count", "preview.item.dropped.count")
| summarize 
    success = sumif(todouble(value), name == "preview.item.success.count"),
    dropped = sumif(todouble(value), name == "preview.item.dropped.count")
| extend failure_ratio = dropped / iff(success == 0.0, 1.0, success)
| project failure_ratio
```

Set the condition to **Greater than** and the threshold you consider unhealthy, such as `0.05` for five percent.

**Alert query: over-quota daily cap (HTTP 402) in the last 10 minutes**

```kusto
let window = 10m;
customMetrics
| where timestamp >= ago(window)
| where name == "preview.item.dropped.count"
| extend drop_code = tostring(customDimensions["drop.code"])
| summarize dropped_402 = sum(todouble(value)) by drop_code
| where drop_code == "402" and dropped_402 > 0
| project dropped_402
```

> [!TIP]
> To reduce ingestion, pair the 402 alert with guidance on daily cap configuration and options. <!-- TODO: Insert link to the official daily cap article once confirmed. -->

## How SDK stats relate to logs

Don't expect these counters to equal item counts in tables such as `requests` or `dependencies`. Differences occur for several reasons:

- **Aggregation timing**. Stats aggregate over intervals and batches. Logs store individual items, so counts across different time grains can drift.
- **Sampling and processors**. Stats count items after the SDK applies sampling and any processors that drop or modify telemetry. Logs reflect what Breeze accepted.
- **Partial successes**. Breeze can accept part of a batch and reject the rest. The exporter records accepted items as success and rejected items as dropped in the same interval.
- **Local buffering**. When the exporter retries, it can send buffered items later. The time that stats assign to drop, retried, or successful counts doesn't always match the event time of the original telemetry.
- **Over quota or daily cap**. When the resource exceeds its daily cap, Breeze returns an error and the exporter records drops. The corresponding application telemetry doesn't appear in logs during the cap window.
- **Scope**. Stats cover exporter behavior. Logs cover end-to-end telemetry, including fields that don't affect exporter success.

## Troubleshoot missing data with SDK Stats

Use SDK Stats to triage common missing-data scenarios.

- **Daily cap or over quota**. Look for spikes where `drop.code == "402"`. Adjust the daily cap or reduce ingestion. <!-- TODO: Link to daily cap doc. -->
- **Throttling from Breeze**. Look for rises in `drop.code == "429"` and high retry counts. Reduce batch rates and respect `Retry-After` headers.
- **Local buffer pressure**. Look for `QueueFull` drops or high retry with stable success. Right-size buffers and validate disk access and quotas.
- **Invalid telemetry**. Look for `InvalidTelemetry` or `SerializeError` drops. Validate payload size and schema.

## Cost and data volume

SDK stats send aggregated `customMetrics` records. The workload publishes counters instead of every telemetry item, so the data volume stays low relative to application telemetry. The records bill as standard Application Insights data ingestion for `customMetrics`, and they follow your retention settings. The exporter sends the counters on the existing ingestion channel, so no extra endpoint or service is required.

**Planning formula**

Use this estimate while selecting intervals and slicing:

```
Estimated records per hour per instance ≈
  (#metrics emitted per interval)
  × (3600 / interval_seconds)
  × (distinct dimension combinations you use)
```

For example, if success, dropped, and retry publish once per minute, and you segment by five telemetry types and several drop reasons, the total often stays under a few hundred `customMetrics` rows per hour per instance. Validate with your real cardinality.

<!-- TODO: Replace the example with data once engineering tells us the default intervals and typical dimension sets. -->

## KQL reference used by the workbooks

Use these examples to recreate or extend the workbook charts.

**Telemetry export success vs. retry vs. failure**

```kusto
let g = 1h; // bind to the workbook time grain parameter
customMetrics
| where name in ("preview.item.success.count", "preview.item.dropped.count", "preview.item.retry.count")
| summarize 
    success = sumif(todouble(value), name == "preview.item.success.count"),
    dropped = sumif(todouble(value), name == "preview.item.dropped.count"),
    retry   = sumif(todouble(value), name == "preview.item.retry.count")
    by bin(timestamp, g)
```

**Failure and retry ratios over time**

```kusto
let g = 1h;
customMetrics
| where name in ("preview.item.dropped.count", "preview.item.success.count", "preview.item.retry.count")
| summarize 
    success = sumif(todouble(value), name == "preview.item.success.count"),
    dropped = sumif(todouble(value), name == "preview.item.dropped.count"),
    retry   = sumif(todouble(value), name == "preview.item.retry.count")
    by bin(timestamp, g)
| extend failure_ratio = dropped / iff(success == 0.0, 1.0, success)
| extend retry_to_success_ratio = iff(retry == 0.0, 1.0, success / retry)
| project timestamp, failure_ratio, retry_to_success_ratio
```

**Drop reasons summary with code**

```kusto
customMetrics
| where name == "preview.item.dropped.count"
| extend drop_reason = tostring(customDimensions["drop.reason"]),
        drop_code   = tostring(customDimensions["drop.code"])
| summarize total_dropped = sum(todouble(value)) by drop_reason, drop_code
| order by total_dropped desc
```

**Drop reasons for a selected time bucket**

```kusto
let g = 1h;
let bucket = datetime(2025-01-01T00:00:00Z); // replace with the selected bucket
customMetrics
| where name == "preview.item.dropped.count"
| where bin(timestamp, g) == bucket
| extend drop_reason = tostring(customDimensions["drop.reason"])
| summarize total_dropped = sum(todouble(value)) by drop_reason
| order by total_dropped desc
```

<!-- TODO: Align the bin size with the workbook's time grain parameter and template logic. -->

## Next steps

- Use the filters in the SDK Stats workbooks to focus on a service, an instance, or a specific SDK version.
- Pin the charts to dashboards and share them with your team.
- Track deployment changes along with failure and retry ratios to spot regressions.

<!-- Follow-ups for PM and engineering sign-off: exact metric names and intervals per language, disable switches per SDK and agent, authoritative `drop.reason` values and 413 behavior, minimum versions for Distro and exporters, agent coverage and versions. -->
