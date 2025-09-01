---
title: SDK stats for Azure Monitor Application Insights (Preview)
description: Use SDK stats to visualize telemetry export success, dropped counts, retry counts, and drop reasons produced by the Azure Monitor Software Development Kits (SDKs) and agents.
ms.topic: how-to
ms.date: 09/05/2025
---

# SDK stats for Application Insights (Preview)

SDK stats provide health metrics for [Application Insights](app-insights-overview.md) SDKs and agents about telemetry sent to the [ingestion endpoint](app-insights-overview.md#logic-model).

SDK stats appear as **custom metrics** you can use to:

> [!div class="checklist"]
> - Visualize in [Workbooks](../visualize/workbooks-overview.md)
> - Query in [Log Analytics](../logs/log-analytics-overview.md) through the `customMetrics` table
> - Plot in [Metrics explorer](../metrics/metrics-explorer.md)
> - Trigger [alerts](../alerts/alerts-overview.md)
> - Chart in [Power BI](/power-bi/fundamentals/power-bi-overview)

The metrics include counts for item success, drops, and retries. They also include drop reasons and retry reasons. Use these metrics to monitor delivery and troubleshoot missing or unexpected telemetry.

> [!IMPORTANT]
> The preview features are provided without a service-level agreement, and aren't recommended for production workloads. 
> For more information, see [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).

## Prerequisites

> [!div class="checklist"]
> - An [instrumented](opentelemetry-enable.md) Node.js or Python application.
> - An environment variable set to [opt in](#enable-and-configure-sdk-stats).

## SDK stats overview

SDK stats are per-process counters that the Application Insights SDKs and agents emit as **custom metrics**. These metrics summarize how many telemetry items the exporter sends successfully, how many items the exporter drops, and how many items the exporter schedules for retry.

The SDK publishes three metrics:

- `preview.item.success.count`
- `preview.item.dropped.count`
- `preview.item.retry.count`

**Dimensions**

These metrics include dimensions in `customDimensions` and standard Application Insights dimensions for slicing:

| Dimension key                          | Description                                                                                                                                                                                                                  |
| -------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `telemetry_type`                       | Telemetry type associated with the count. Values align with Application Insights tables such as `REQUEST`, `DEPENDENCY`, `EXCEPTION`, `TRACE`, `CUSTOM_EVENT`, and `AVAILABILITY`.                                           |
| `drop.code`, `drop.reason`             | Code and short reason for dropped items. The code is either an HTTP status from the ingestion endpoint or a client code such as `CLIENT_EXCEPTION`.                                                                          |
| `retry.code`, `retry.reason`           | Code and short reason for scheduled retries. The code is either an HTTP status from the ingestion endpoint or a client code such as `CLIENT_TIMEOUT`.                                                                        |
| `telemetry_success`                    | For `REQUEST` and `DEPENDENCY`, the telemetry item's `success` value at export time (`true` or `false`).                                                                                                                     |
| `language`, `version`                  | SDK or agent language and version.                                                                                                                                                                                           |
| `compute.type`                         | Compute environment such as `aks`, `appsvc`, `functions`, `springcloud`, `vm`, or `unknown`. <!-- TODO: Confirm the serialized key name in payloads is `computeType` while the logical dimension name is `compute.type`. --> |
| `sdkVersion`                           | SDK version string also available in tags.                                                                                                                                                                                   |
| `cloud_RoleName`, `cloud_RoleInstance` | Resource dimensions you can use to slice by service and instance.                                                                                                                                                            |

Each metric row represents an **aggregated count** for the export interval.

## Enable and configure SDK stats

Current coverage requires **opt in** and is limited to the following SDKs:

> [!div class="checklist"]
> - **Node.js**
> - **Python**

Enable by setting the environment variable `APPLICATIONINSIGHTS_SDKSTATS_ENABLED_PREVIEW=true` in the application process environment and restarting the application.

**Export interval**

- The default export interval is **15 minutes**.
- Configure a different interval in seconds with `APPLICATIONINSIGHTS_SDKSTATS_EXPORT_INTERVAL`.

You don't need to deploy any workbook resources. The SDK stats template appears in the **Workbooks** gallery under your Application Insights resource.

## Open the SDK stats workbook

Open your Application Insights resource, then open **Workbooks** and select **SDK stats (Preview)**. The experience uses a **single workbook** with a simplified set of visuals.

### Filters

Use the filters at the top of the workbook to scope the view:

- **Time Range**: Filter by the time window and bin size.
- **SDK Version**: Filter by the `sdkVersion` field.
- **Telemetry Type**: Filter by the `telemetry_type` dimension.
- **Drop Reason**: Filter by the `drop.reason` dimension.
- **Drop Code**: Filter by the `drop.code` dimension.

### Workbook visuals

The workbook focuses on a concise set of charts that keep outcomes in context:

- **Failure ratio**. Shows `dropped / success` on the selected time grain.
- **Request and dependency analysis over time**. Splits request and dependency telemetry by the item’s `success` value, then shows **Sent** versus **Dropped** in separate bar charts:
  - **Successful telemetry over time**. Compares items that the application recorded as successful and that the exporter **sent** to Application Insights with items in the same category that the exporter **dropped**. Use this view to confirm steady delivery of successful operations.
  - **Failed telemetry over time**. Compares items that the application recorded as failed and that the exporter **sent** with items in the same category that the exporter **dropped**. Spikes in **Failed – Dropped** often indicate transient service issues, throttling, or configuration problems.
  - Use **Drop Reason**, **Drop Code**, and **SDK Version** filters to isolate causes. For example, if **Failed – Dropped** rises, check for `429` throttling or `401/403` authentication problems.
- **Time-bucket drilldown**. Selecting a bucket opens a breakdown view with top drop reasons and codes for that period. <!-- TODO: Confirm the exact drilldown fields and titles used in the template. -->
- **Export outcomes over time**. Plots counts of `success`, `retry`, and `dropped` together.

## Cost and data volume

SDK stats send aggregated `customMetrics` records. The workload publishes counters instead of every telemetry item, so the data volume stays low relative to application telemetry. The records bill as standard Application Insights data ingestion for `customMetrics`, and they follow your retention settings. The exporter sends the counters on the existing ingestion channel.

**Planning formula**

```
Estimated records per hour per instance ≈
  (#metrics emitted per interval)
  × (3600 / interval_seconds)
  × (distinct dimension combinations you use)
```

Default interval is **15 minutes** (`interval_seconds = 900`). Configure a different interval with `APPLICATIONINSIGHTS_SDKSTATS_EXPORT_INTERVAL`.

## Troubleshooting

Use this section to **leverage insights from the workbook** to diagnose unexpected telemetry behaviors.

### Diagnose drops and retries

- **Daily cap or over quota**: Look for spikes where `drop.code == "402"`. Adjust the [daily cap](opentelemetry-sampling.md#set-a-daily-cap) or reduce ingestion.
- **Throttling from the ingestion endpoint**: Look for rises in `drop.code == "429"` and high retry counts. Reduce batch rates and respect `Retry-After` headers.
- **Local buffer pressure**: Look for `CLIENT_PERSISTENCE_CAPACITY` drops or high retry with stable success. Right-size buffers and validate disk and quotas.
- **Invalid telemetry**: Look for `400` drops and `InvalidTelemetry` reasons. Validate payload size and schema.

### Interpret the retry metric

Use the retry series to spot transient delivery issues and decide what to check next.

- **What it is**. `preview.item.retry.count` records attempts that the exporter schedules for retry. Retries represent attempts, not final state, and never decrement.
- **Does a rising line mean data loss**. No. A rising retry count by itself doesn't mean loss. Items count as success when the exporter sends them later. Use the dropped series to determine loss.
- **How to investigate**. Split by `retry.code` and review common codes:
  - `408`, `5xx`: network or service issues that usually recover. Expect success to catch up with low drops.
  - `429`: throttling. Expect retries until the `Retry-After` window ends. Consider reducing batch rates.
  - `401`, `403`: authentication or permission errors. Fix credentials or roles.
- **What to do next**. If retries keep rising and success doesn't recover, check **Dropped by reason and code**. Look for `402` (quota), `401/403` (auth), or client exceptions such as storage issues.

### Drop reasons and ingestion endpoint response codes

The exporter sets `drop.reason` and `drop.code` for dropped items and `retry.reason` and `retry.code` for scheduled retries. The following values describe common cases.

#### Client-side drop codes

| drop.code                     | Description                                                                                     |
| ----------------------------- | ----------------------------------------------------------------------------------------------- |
| `CLIENT_EXCEPTION`            | Items dropped due to exceptions or when the ingestion endpoint doesn't return a response.       |
| `CLIENT_READONLY`             | Items dropped because the file system is read-only.                                             |
| `CLIENT_PERSISTENCE_CAPACITY` | Items dropped because disk persistence capacity is exceeded.                                    |
| `CLIENT_STORAGE_DISABLED`     | Items that would be retried but local storage is disabled.                                      |
| `*NON_RETRYABLE_STATUS_CODE`  | Items dropped when the ingestion endpoint returns a nonretryable status such as `401` or `403`. |

**drop.reason** complements `drop.code` with low-cardinality categories such as **Timeout exception**, **Network exception**, **Storage exception**, and **Client exception**. <!-- TODO: Replace with the final canonical list and casing from the spec. -->

#### Client-side retry codes

| retry.code               | Description                                                                                                                   |
| ------------------------ | ----------------------------------------------------------------------------------------------------------------------------- |
| `CLIENT_EXCEPTION`       | Items scheduled for retry due to runtime exceptions such as network or Domain Name System (DNS) failures, excluding timeouts. |
| `CLIENT_TIMEOUT`         | Items scheduled for retry because a timeout occurred.                                                                         |
| `*RETRYABLE_STATUS_CODE` | Items scheduled for retry because the ingestion endpoint returned a retryable HTTP status code.                               |

**retry.reason** uses the same categorization approach as **drop.reason**.

#### Ingestion endpoint HTTP responses

| HTTP status from the ingestion endpoint | Typical reason                                                                                     | SDK action                                                                                                                                                     |
| --------------------------------------- | -------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `200 OK`                                | All items accepted.                                                                                | Count items as success.                                                                                                                                        |
| `206 Partial Content`                   | Some items accepted, some rejected.                                                                | Count accepted items as success and rejected items as dropped.                                                                                                 |
| `307` or `308 Redirect`                 | Redirect to a stamp-specific endpoint.                                                             | Follow redirects, up to 10. Update the ingestion endpoint. Drop if redirects continue beyond the limit.                                                        |
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

## Kusto Query Language (KQL) reference samples

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

**Request and dependency analysis over time (replicate the stacked bars)**

```kusto
let g = 15m;
// Successful request/dependency telemetry: sent vs dropped
let sent_success = (requests
| where success == true
| summarize c = count() by bin(timestamp, g)
| union (dependencies | where success == true | summarize c = count() by bin(timestamp, g))
| summarize sent = sum(c) by timestamp);
let dropped_success = (customMetrics
| where name == "preview.item.dropped.count"
| extend telemetry_type = tostring(customDimensions["telemetry_type"]),
        telemetry_success = tostring(customDimensions["telemetry_success"])
| where telemetry_type in ("REQUEST","DEPENDENCY") and telemetry_success == "true"
| summarize dropped = sum(todouble(value)) by bin(timestamp, g));
sent_success
| join kind=fullouter dropped_success on timestamp
| project timestamp, ["Successful - Sent"] = todouble(sent), ["Successful - Dropped"] = todouble(dropped)
| order by timestamp asc;

// Failed request/dependency telemetry: sent vs dropped
let sent_failed = (requests
| where success == false
| summarize c = count() by bin(timestamp, g)
| union (dependencies | where success == false | summarize c = count() by bin(timestamp, g))
| summarize sent = sum(c) by timestamp);
let dropped_failed = (customMetrics
| where name == "preview.item.dropped.count"
| extend telemetry_type = tostring(customDimensions["telemetry_type"]),
        telemetry_success = tostring(customDimensions["telemetry_success"])
| where telemetry_type in ("REQUEST","DEPENDENCY") and telemetry_success == "false"
| summarize dropped = sum(todouble(value)) by bin(timestamp, g));
sent_failed
| join kind=fullouter dropped_failed on timestamp
| project timestamp, ["Failed - Sent"] = todouble(sent), ["Failed - Dropped"] = todouble(dropped)
| order by timestamp asc
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

## Frequently asked questions

<details>
<summary><b>How are counters collected?</b></summary>

The SDK updates counters as it evaluates and exports telemetry. It sends the counters at a regular interval as `customMetrics` records. Each record aggregates counts for the interval and includes the dimensions described earlier.

1. The application creates telemetry. The SDK applies sampling and processors.
2. The exporter sends a batch of telemetry to the ingestion endpoint.
3. The exporter increments `preview.item.success.count` for items the ingestion endpoint accepts.
4. The exporter increments `preview.item.dropped.count` for items it drops and sets `drop.reason` and `drop.code`.
5. If the ingestion endpoint returns a transient error, the exporter schedules items for retry and increments `preview.item.retry.count`. Retried items that later succeed count as success when the exporter sends them.
6. At each interval, the SDK publishes the aggregated counters to the `customMetrics` table.

> **Note**  
> Retry counts represent attempts and never decrement.
</details>

<br>

<details>
<summary><b>How can I use SDK stats with alerts?</b></summary>

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

</details>

<br>

<details>
<summary><b>How can I use SDK stats with PowerBI?</b></summary>

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

</details>

<br>

<details>
<summary><b>How can I use SDK stats in Metrics Explorer?</b></summary>

Chart these custom metrics in Metrics explorer.

1. Open your Application Insights resource.
2. Open **Metrics**.
3. Select the **Custom metrics** namespace.
4. Select `preview.item.success.count`, `preview.item.dropped.count`, or `preview.item.retry.count`.
5. Split by `cloud_RoleName`, `cloud_RoleInstance`, `telemetry_type`, or `sdkVersion` as needed.

<!-- TODO: Confirm the exact metrics namespace label in Metrics explorer. -->

</details>

<br>

<details>
<summary><b>How do SDK stats counts differ from logs?</b></summary>

Don't expect these counters to equal item counts in tables such as `requests` or `dependencies`. Differences occur for several reasons:

- **Aggregation timing**. Stats aggregate over intervals and batches. Logs store individual items, so counts across different time grains can drift.
- **Sampling and processors**. Stats count items after the SDK applies sampling and any processors that drop or modify telemetry. Logs reflect what the ingestion endpoint accepted.
- **Partial successes**. The ingestion endpoint can accept part of a batch and reject the rest. The exporter records accepted items as success and rejected items as dropped in the same interval.
- **Local buffering**. When the exporter retries, it can send buffered items later. The time that stats assign dropped, retried, or successful counts don't always match the event time of the original telemetry.
- **Over quota or daily cap**. When the resource exceeds its daily cap, the ingestion endpoint returns an error and the exporter records drops. The corresponding application telemetry doesn't appear in logs during the cap window.
- **Scope**. Stats cover exporter behavior. Logs cover end-to-end telemetry, including fields that don't affect exporter success.

</details>
