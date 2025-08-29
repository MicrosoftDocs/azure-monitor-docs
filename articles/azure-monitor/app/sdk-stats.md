---
title: SDK Stats workbooks for Azure Monitor Application Insights (Preview)
description: Use SDK Stats workbooks to visualize telemetry export success, dropped counts, retry counts, and drop reasons produced by the Azure Monitor Software Development Kits (SDKs) and agents.
ms.topic: how-to
ms.date: 08/29/2025
---

# SDK Stats workbooks for Application Insights (Preview)

Use SDK Stats [workbooks](../visualize/workbooks-overview.md) to monitor how [Application Insights](app-insights-overview.md) SDKs and agents export telemetry to the Breeze ingestion endpoint. These workbooks visualize internal custom metrics that the SDKs publish.

> [!NOTE]
> SDK Stats workbooks add new visualizations. They don't replace existing Application Insights workbooks.

## Prerequisites

> [!div class="checklist"]
> - An [instrumented](opentelemetry-enable.md) Node.js or Python application.
> - An environment variable set to [opt-in](#enable-and-configure-sdk-stats).

## SDK stats overview

SDK stats are per-process counters that the Application Insights SDKs and agents emit as **custom metrics**. These metrics summarize how many telemetry items the exporter sends successfully, how many items the exporter drops, and how many items the exporter schedules for retry.

The SDK publishes three metrics:

- `preview.item.success.count`
- `preview.item.dropped.count`
- `preview.item.retry.count`

SDK stats appear as **custom metrics** that you can use in Workbooks, query in [Log Analytics](../logs/log-analytics-overview.md) through the `customMetrics` table, and plot in [Metrics explorer](../metrics/metrics-explorer.md).

**Dimensions**

These metrics include dimensions in `customDimensions` and standard Application Insights dimensions for slicing:

| Dimension key                          | Description                                                                                                                                                                                                                  |
| -------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `telemetry_type`                       | Telemetry type associated with the count. Values align with Application Insights tables such as `REQUEST`, `DEPENDENCY`, `EXCEPTION`, `TRACE`, `CUSTOM_EVENT`, and `AVAILABILITY`.                                           |
| `drop.code`, `drop.reason`             | Code and short reason for dropped items. The code is either an HTTP status from Breeze or a client code such as `CLIENT_EXCEPTION`.                                                                                          |
| `retry.code`, `retry.reason`           | Code and short reason for scheduled retries. The code is either an HTTP status from Breeze or a client code such as `CLIENT_TIMEOUT`.                                                                                        |
| `telemetry_success`                    | For `REQUEST` and `DEPENDENCY`, the telemetry item's `success` value at export time (`true` or `false`).                                                                                                                     |
| `language`, `version`                  | SDK or agent language and version.                                                                                                                                                                                           |
| `compute.type`                         | Compute environment such as `aks`, `appsvc`, `functions`, `springcloud`, `vm`, or `unknown`. <!-- TODO: Confirm the serialized key name in payloads is `computeType` while the logical dimension name is `compute.type`. --> |
| `sdkVersion`                           | SDK version string also available in tags.                                                                                                                                                                                   |
| `cloud_RoleName`, `cloud_RoleInstance` | Resource dimensions you can use to slice by service and instance.                                                                                                                                                            |

Each metric row represents an **aggregated count** for the export interval.

## Open the SDK Stats workbook

Open your Application Insights resource, then open **Workbooks** and select **SDK Stats (Preview)**. The experience uses a **single workbook** with a simplified set of visuals.

### Filters

Use the filters at the top of the workbook to scope the view:

- **Time Range**: Filter by the time window and bin size.
- **SDK Version**: Filter by the `sdkVersion` field.
- **Telemetry Type**: Filter by the `telemetry_type` dimension.
- **Drop Reason**: Filter by the `drop.reason` dimension.
- **Drop Code**: Filter by the `drop.code` dimension.

### Workbook visuals

The workbook focuses on a concise set of charts that keep outcomes in context:

- **Export outcomes over time**. Plots counts of `success`, `retry`, and `dropped` together.
- **Failure ratio**. Shows `dropped / success` on the selected time grain.
- **Time-bucket drilldown**. Selecting a bucket opens a breakdown view with top drop reasons and codes for that period. <!-- TODO: Confirm the exact drilldown fields and titles used in the template. -->

## Enable and configure SDK stats

Current coverage requires **opt-in** and is limited to the following SDKs:

> [!div class="checklist"]
> - **Node.js**
> - **Python**

Enable by setting the environment variable `APPLICATIONINSIGHTS_SDKSTATS_ENABLED_PREVIEW=true` in the application process environment.

**Export interval**

- The default export interval is **15 minutes**.
- Configure a different interval in seconds with `APPLICATIONINSIGHTS_SDKSTATS_EXPORT_INTERVAL`.

You don't need to deploy any workbook resources. The SDK Stats template appears in the **Workbooks** gallery under your Application Insights resource.

## Use SDK stats outside Workbooks

You can use these metrics across Azure Monitor tools and external systems.

### Metrics explorer

Chart these custom metrics in Metrics explorer.

1. Open your Application Insights resource.
2. Open **Metrics**.
3. Select the **Custom metrics** namespace.
4. Select `preview.item.success.count`, `preview.item.dropped.count`, or `preview.item.retry.count`.
5. Split by `cloud_RoleName`, `cloud_RoleInstance`, `telemetry_type`, or `sdkVersion` as needed.

<!-- TODO: Confirm the exact metrics namespace label in Metrics explorer. -->

### Power BI

Use the **Azure Monitor Logs** connector to bring these metrics into Power BI.

```kusto
// Failure and retry ratios by hour
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
| order by timestamp asc
```

```kusto
// Dropped items by reason
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

Create log alerts that monitor ratios or specific codes.

```kusto
// Failure ratio over 5 minutes
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

```kusto
// Over-quota daily cap (HTTP 402) in the last 10 minutes
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
> Pair the 402 alert with [daily cap](opentelemetry-sampling.md#set-a-daily-cap) guidance so responders can adjust the cap or reduce ingestion.

## Troubleshooting

### Diagnose drops and retries

- **Daily cap or over quota**: Look for spikes where `drop.code == "402"`. Adjust the [daily cap](opentelemetry-sampling.md#set-a-daily-cap) or reduce ingestion.
- **Throttling from Breeze**: Look for rises in `drop.code == "429"` and high retry counts. Reduce batch rates and respect `Retry-After` headers.
- **Local buffer pressure**: Look for `CLIENT_PERSISTENCE_CAPACITY` drops or high retry with stable success. Right-size buffers and validate disk and quotas.
- **Invalid telemetry**: Look for `400` drops and `InvalidTelemetry` reasons. Validate payload size and schema.

### Drop reasons and Breeze response codes

The exporter sets `drop.reason` and `drop.code` for dropped items and `retry.reason` and `retry.code` for scheduled retries. The following values describe common cases.

#### Client-side drop codes

| drop.code                     | Description                                                                      |
| ----------------------------- | -------------------------------------------------------------------------------- |
| `CLIENT_EXCEPTION`            | Items dropped due to exceptions or when Breeze doesn't return a response.        |
| `CLIENT_READONLY`             | Items dropped because the file system is read-only.                              |
| `CLIENT_PERSISTENCE_CAPACITY` | Items dropped because disk persistence capacity is exceeded.                     |
| `CLIENT_STORAGE_DISABLED`     | Items that would be retried but local storage is disabled.                       |
| `*NON_RETRYABLE_STATUS_CODE`  | Items dropped when Breeze returns a nonretryable status such as `401` or `403`.  |

**drop.reason** complements `drop.code` with low-cardinality categories such as **Timeout exception**, **Network exception**, **Storage exception**, and **Client exception**. <!-- TODO: Replace with the final canonical list and casing from the spec. -->

#### Client-side retry codes

| retry.code               | Description                                                                                                                    |
| ------------------------ | ------------------------------------------------------------------------------------------------------------------------------ |
| `CLIENT_EXCEPTION`       | Items scheduled for retry due to runtime exceptions such as network or Domain Name System (DNS) failures (excluding timeouts). |
| `CLIENT_TIMEOUT`         | Items scheduled for retry because a timeout occurred.                                                                          |
| `*RETRYABLE_STATUS_CODE` | Items scheduled for retry because Breeze returned a retryable HTTP status code.                                                |

**retry.reason** uses the same categorization approach as **drop.reason**.

#### Breeze HTTP responses

| HTTP status from Breeze                 | Typical reason                                                                                     | SDK action                                                                                                                                                     |
| --------------------------------------- | -------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `200 OK`                                | All items accepted.                                                                                | Count items as success.                                                                                                                                        |
| `206 Partial Content`                   | Some items accepted, some rejected.                                                                | Count accepted items as success and rejected items as dropped.                                                                                                 |
| `307` or `308 Redirect`                 | Redirect to a stamp-specific endpoint.                                                             | Follow redirects (up to 10). Update the ingestion endpoint. Drop if redirects continue beyond the limit.                                                       |
| `400 Bad Request`                       | Invalid telemetry or unsupported schema; also used in some Microsoft Entra misconfiguration cases. | Drop invalid items. <!-- TODO: Confirm guidance for Azure AD misrouting that returns 400 but would succeed on the correct API. -->                             |
| `401 Unauthorized`                      | Authentication error or Microsoft Entra token lacks required permissions.                          | Retry with backoff.                                                                                                                                            |
| `402 Payment Required`                  | Daily quota exceeded.                                                                              | Drop new items until the cap window resets. No `Retry-After` is present. <!-- TODO: Confirm guidance for previously persisted items during the cap window. --> |
| `403 Forbidden`                         | Misconfigured permissions or endpoint/resource mapping.                                            | Retry with backoff after configuration is corrected.                                                                                                           |
| `404 Stamp-specific endpoint required`  | Connection string points to a different region than the resource.                                  | Drop and update the connection string.                                                                                                                         |
| `405 Method Not Allowed`                | HTTP method isn't allowed.                                                                         | Persist and retry later.                                                                                                                                       |
| `408 Request Timeout`                   | Network timeout.                                                                                   | Retry with exponential backoff.                                                                                                                                |
| `413 Payload Too Large`                 | Batch size too large.                                                                              | Split the batch, persist if supported, and retry.                                                                                                              |
| `429 Too Many Requests`                 | Throttling with `Retry-After`.                                                                     | Persist and retry after the indicated interval.                                                                                                                |
| `439 Daily Quota Exceeded (deprecated)` | Legacy form of over-quota.                                                                         | Drop the items.                                                                                                                                                |
| `5xx Server Error`                      | Transient service issue.                                                                           | Persist and retry with exponential backoff.                                                                                                                    |
| Other                                   | Not recognized.                                                                                    | Drop the items.                                                                                                                                                |

Items scheduled for retry aren't counted as dropped unless the exporter abandons them or the retry buffer overflows. Retry counts never decrement; retries represent attempts, not final state.

### How the counters are collected

- The SDK increments counters as it evaluates and exports telemetry, then sends the counters as `customMetrics` records on an interval.
- The exporter records `preview.item.success.count` for items Breeze accepts, `preview.item.dropped.count` for dropped items, and `preview.item.retry.count` for scheduled retries.
- Retried items that later succeed count toward success when the exporter sends them.

### How SDK stats relate to logs

- Stats aggregate over export intervals while log tables store individual items. Counts across different time grains can differ.
- Stats reflect items after the SDK applies sampling and processors.
- Breeze can accept part of a batch and reject the rest, which records success and drop counts for the same interval.
- Retried items can send later than the event time.
- Over quota (`402`) drops mean the application telemetry doesn't appear in logs during the cap window.

### Cost and data volume

SDK stats send aggregated `customMetrics` records. The workload publishes counters instead of every telemetry item, so the data volume stays low relative to application telemetry. The records bill as standard Application Insights data ingestion for `customMetrics`.

**Planning formula**

```
Estimated records per hour per instance ≈
  (#metrics emitted per interval)
  × (3600 / interval_seconds)
  × (distinct dimension combinations you use)
```

The default interval is **15 minutes** (`interval_seconds = 900`). Configure a different interval with `APPLICATIONINSIGHTS_SDKSTATS_EXPORT_INTERVAL`.

### Kusto Query Language (KQL) samples

**Export outcomes vs. time**

```kusto
let g = 15m; // align with export interval for clearer charts
customMetrics
| where name in ("preview.item.success.count", "preview.item.dropped.count", "preview.item.retry.count")
| summarize 
    success = sumif(todouble(value), name == "preview.item.success.count"),
    dropped = sumif(todouble(value), name == "preview.item.dropped.count"),
    retry   = sumif(todouble(value), name == "preview.item.retry.count")
    by bin(timestamp, g)
```

**Ratios over time**

```kusto
let g = 15m;
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
