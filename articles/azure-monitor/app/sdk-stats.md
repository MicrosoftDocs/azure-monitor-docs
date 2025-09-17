---
title: SDK stats for Azure Monitor Application Insights (Preview)
description: Use SDK stats to visualize telemetry export success, dropped counts, retry counts, and drop reasons produced by the Azure Monitor Software Development Kits (SDKs) and agents.
ms.topic: how-to
ms.date: 09/05/2025
---

# SDK stats for Application Insights (Preview)

[Application Insights](app-insights-overview.md) offers SDK stats [custom metrics](metrics-overview.md) that help you monitor and troubleshoot missing or unexpected telemetry behaviors. When telemetry doesn't reach the [ingestion endpoint](app-insights-overview.md#logic-model), SDK stats help you identify what happened and what to do next.

These custom metrics include counts for item success, drops, and retries. They also include **drop codes** and **retry codes** that explain the cause and guide next steps.

Visualization is provided in the [SDK stats workbook](#open-the-sdk-stats-workbook).

> [!IMPORTANT]
> The preview features are provided without a service-level agreement and aren't recommended for production workloads. 
> For more information, see [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).

## Prerequisites

> [!div class="checklist"]
> - An application [instrumented](opentelemetry-enable.md) with one of the following:
>   - Python OpenTelemetry Distro 1.8.0+ and azure-monitor-opentelemetry-exporter 1.0.0b42+
>   - Node.js OpenTelemetry Distro 1.13.0+
>   - Node.js Application Insights Classic API SDK 3.10.0+
> - An environment variable set to [opt in](#enable-and-configure-sdk-stats).

## SDK stats overview

SDK stats are per-process counters that the Application Insights SDKs and agents emit as **custom metrics**. These metrics summarize how many telemetry items the exporter sends successfully, how many items the exporter drops, and how many items the exporter schedules for retry.

The SDK publishes three metrics:

- `preview.item.success.count`
- `preview.item.dropped.count`
- `preview.item.retry.count`

> [!NOTE]
> Retry counts represent attempts and never decrement. A later success for the same items is reflected only in the success series.

**Dimensions**

These metrics include dimensions in `customDimensions` and standard Application Insights dimensions for slicing:

| Dimension key                          | Description                                                                                                                                                                        |
| -------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `telemetry_type`                       | Telemetry type associated with the count. Values align with Application Insights tables such as `REQUEST`, `DEPENDENCY`, `EXCEPTION`, `TRACE`, `CUSTOM_EVENT`, and `AVAILABILITY`. |
| `drop.code`, `drop.reason`             | Code and short reason for dropped items. The code is either an HTTP status from the ingestion endpoint or a client code such as `CLIENT_EXCEPTION`.                                |
| `retry.code`, `retry.reason`           | Code and short reason for scheduled retries. The code is either an HTTP status from the ingestion endpoint or a client code such as `CLIENT_TIMEOUT`.                              |
| `telemetry_success`                    | For `REQUEST` and `DEPENDENCY`, the telemetry item's `success` value at export time (`true` or `false`).                                                                           |
| `language`, `version`                  | SDK or agent language and version.                                                                                                                                                 |
| `compute.type`                         | Compute environment such as `aks`, `appsvc`, `functions`, `springcloud`, `vm`, or `unknown`.                                                                                       |
| `sdkVersion`                           | SDK version string also available in tags.                                                                                                                                         |
| `cloud_RoleName`, `cloud_RoleInstance` | Resource dimensions you can use to slice by service and instance.                                                                                                                  |

Each metric row represents an **aggregated count** for the export interval. Total **attempted** in a time slice equals `success + dropped` for that slice.

## Enable and configure SDK stats

Current coverage requires **opt in** and is limited to the following SDKs:

> [!div class="checklist"]
> - **Node.js**
> - **Python**

Enable by setting the environment variable `APPLICATIONINSIGHTS_SDKSTATS_ENABLED_PREVIEW=true` in the application process environment and restarting the application.

**Export interval**

- The default export interval is **15 minutes**.
- Configure a different interval in seconds with `APPLICATIONINSIGHTS_SDKSTATS_EXPORT_INTERVAL`.
- The minimum interval is one second.

You don't need to deploy any workbook resources. The SDK stats template appears in the **Workbooks** gallery under your Application Insights resource. The workbook shows **No data** until the SDK emits these custom metrics.

## Open the SDK stats workbook

Open your Application Insights resource, then open **Workbooks** and select **SDK stats (Preview)**. The experience uses a **single workbook** with a simplified set of visuals.

:::image type="content" source="media/sdk-stats/sdk-stats-workbook.png" alt-text="A screenshot of the SDK stats default workbook." lightbox="media/sdk-stats/sdk-stats-workbook.png":::

### Filters

Use the filters at the top of the workbook to scope the view:

- **Time Range**: Filter by the time window and bin size.
- **SDK Version**: Filter by the `sdkVersion` field.
- **Telemetry Type**: Filter by the `telemetry_type` dimension.
- **Drop Reason** and **Drop Code**: Filter by `drop.reason` and `drop.code`.

### Workbook visuals

The workbook focuses on a concise set of charts that keep outcomes in context:

- **Drop rate**. Shows `dropped / (dropped + success)` on the selected time grain.
- **Request and dependency analysis over time**. Splits request and dependency telemetry by the item’s `success` value at the application, then shows **Sent** versus **Dropped** in separate bar charts:
  - **Successful and sent vs. dropped**. Compares items that the application recorded as successful and that the exporter **sent** to Application Insights with items in the same category that the exporter **dropped**.
  - **Failed and sent vs. dropped**. Compares items that the application recorded as failed and that the exporter **sent** with items in the same category that the exporter **dropped**. Spikes in **Failed, Dropped** often indicate transient service issues, throttling, or configuration problems.
  - Use **Drop Reason**, **Drop Code**, and **SDK Version** filters to isolate causes. For example, if **Failed, Dropped** rises, check for `429` throttling or `401` and `403` authentication problems.
- **Time bucket drilldown**. Selecting a bucket opens a breakdown view with the top drop reasons and codes for that period.
- **Export outcomes over time**. Plots counts of `success`, `retry`, and `dropped` together.

## Troubleshooting unexpected telemetry behaviors

Use the codes to determine what happened and what to do next. [Workbook](#open-the-sdk-stats-workbook) callouts indicate where to look first.

### Diagnose drop codes

The exporter sets `drop.code` for items it couldn't deliver. Use the following guidance.

> [!NOTE]
> When the ingestion endpoint accepts some items and rejects others, you could see `206 Partial Content`. Accepted items contribute to `success`. Rejected items contribute to `dropped` with an accompanying drop code.

#### Client drop codes

| drop.code                     | What it means in practice                                                                      | What you should do next                                                                                                                                                                   |
| ----------------------------- | ---------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `CLIENT_EXCEPTION`            | Items were dropped because the exporter hit an exception or received no response.              | Check app and exporter logs. Verify Domain Name System (DNS), Transport Layer Security (TLS), proxy, firewall, and outbound internet rules. Validate endpoint reachability from the host. |
| `CLIENT_READONLY`             | Local persistence couldn't write because the file system is read only.                         | Point persistence to a writable path. Fix container or virtual machine (VM) permissions. Consider disabling disk persistence if not allowed in the environment.                           |
| `CLIENT_PERSISTENCE_CAPACITY` | Local persistence was full and new items couldn't be buffered.                                 | Increase disk quota or storage size. Reduce batch size or ingestion rate. Consider [sampling](opentelemetry-sampling.md).                                                                 |
| `CLIENT_STORAGE_DISABLED`     | Local persistence is disabled. Items that needed buffering couldn't be saved and were dropped. | Enable local storage or scale out to reduce pressure.                                                                                                                                     |
| `*NON_RETRYABLE_STATUS_CODE`  | The ingestion endpoint returned a nonretryable status such as `400`, `401`, `403`, or `404`.   | Use the HTTP code tables to correct configuration, credentials, or telemetry schema, then redeploy.                                                                                       |

#### Ingestion endpoint HTTP status codes

| HTTP status                               | Typical reason                                                                                               | What you should do next                                                                                                       |
| ----------------------------------------- | ------------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------- |
| `200 OK`                                  | All items accepted.                                                                                          | No action needed.                                                                                                             |
| `206 Partial Content`                     | Some items accepted and others rejected.                                                                     | Inspect exporter logs for per-item errors. Validate schema and sizes. Reduce batch size if payloads are near size limits.     |
| `307` or `308 Redirect`                   | Redirect to a stamp specific endpoint.                                                                       | Allow redirects in your environment. Update the connection string to the correct region if redirects are persistent.          |
| `400 Bad Request`                         | Invalid telemetry or unsupported schema. In some cases, Microsoft Entra misconfiguration can surface as 400. | Validate payload sizes and schema. Fix connection string or token audience if misrouted.                                      |
| `401 Unauthorized`                        | Authentication failed or token lacks required permissions.                                                   | Fix connection string or credentials. Ensure the identity has correct roles and token scope for Application Insights.         |
| `402 Payment Required`                    | Daily cap exceeded.                                                                                          | Adjust the [daily cap](opentelemetry-sampling.md#set-a-daily-cap), reduce ingestion, or increase sampling. Wait for reset.    |
| `403 Forbidden`                           | Permission or mapping is incorrect.                                                                          | Correct role assignments or endpoint mapping. Confirm resource and connection string belong to the same environment.          |
| `404 Not Found`                           | Connection string points to the wrong region or resource.                                                    | Update the connection string to the correct resource and region.                                                              |
| `405 Method Not Allowed`                  | The request method isn't permitted.                                                                          | Upgrade the SDK and confirm only supported methods are used.                                                                  |
| `408 Request Timeout`                     | Network timeout.                                                                                             | Check network latency and firewall rules. Increase client timeout if appropriate.                                             |
| `413 Payload Too Large`                   | Batch payload exceeded size limits.                                                                          | Lower the max batch size. Consider sending more frequent, smaller batches.                                                    |
| `429 Too Many Requests`                   | Throttling with `Retry-After`.                                                                               | Reduce send rate. Respect `Retry-After`. Increase sampling or scale out.                                                      |
| `439 Daily Quota Exceeded` *(deprecated)* | Legacy quota signal.                                                                                         | Same as 402. Prefer to monitor 402 going forward.                                                                             |
| `5xx Server Error`                        | Transient service issue.                                                                                     | Expect recovery. If it persists beyond a few minutes, check Azure status and open a support case with timestamps and regions. |
| Other                                     | Not recognized.                                                                                              | Capture correlation identifiers (IDs) from logs and open a support case.                                                      |

### Diagnose retry codes

The exporter sets `retry.code` for items it schedules to send later. Retries indicate a delivery attempt that didn't succeed yet, not a final drop.

| retry.code               | What it means in practice                                                                  | What you should do next                                                                                      |
| ------------------------ | ------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------ |
| `CLIENT_EXCEPTION`       | A runtime exception such as network failure prevented delivery.                            | Check DNS, proxies, TLS, and firewall. Review exporter logs for exception details.                           |
| `CLIENT_TIMEOUT`         | The exporter timed out waiting for a response.                                             | Increase timeout if appropriate. Investigate network latency and server responsiveness.                      |
| `*RETRYABLE_STATUS_CODE` | The ingestion endpoint returned a retryable HTTP status (for example `408`, `429`, `5xx`). | Expect eventual recovery. Reduce send rate or sampling when throttled. Watch for `Retry-After` and honor it. |

#### How to interpret retries

The `preview.item.retry.count` counter increases whenever the exporter schedules telemetry to be sent again. It reflects **attempts**, not final outcomes. The counter never decreases. Use it together with the **success** and **dropped** series to understand delivery health.

##### Interpret trends

- A rising retry line by itself doesn't mean data loss. Items can later be sent successfully.
- Compare retries with **success**. If success recovers after a spike in retries, the issue was likely transient.
- Compare retries with **dropped**. If retries rise while dropped stays near zero, the exporter is buffering and recovering.
- Persistent high retries with flat or falling success signals a blocking issue. See [**If success does not recover**](#if-success-doesnt-recover).

##### Investigate by code

Split the retry metric by `retry.code` to identify why attempts are being retried.

| `retry.code`       | What it usually means                             | What to check or do next                                                                 |
| ------------------ | ------------------------------------------------- | ---------------------------------------------------------------------------------------- |
| `CLIENT_TIMEOUT`   | The exporter timed out waiting for a response.    | Increase client timeout if appropriate. Check latency, proxies, and firewall rules.      |
| `CLIENT_EXCEPTION` | Network or runtime error prevented delivery.      | Review exporter logs. Verify DNS, TLS, proxy, and outbound network configuration.        |
| `408`              | Request timed out at the ingestion endpoint.      | Investigate network path and latency. Consider smaller batches or higher send frequency. |
| `429`              | Throttled by ingestion, often with `Retry-After`. | Reduce send rate or increase sampling. Honor `Retry-After` before retrying.              |
| `5xx`              | Transient service issue at ingestion.             | Expect recovery. Continue to retry with backoff. Check Azure status if it persists.      |

##### If success doesn't recover

If retries continue to climb and **success** doesn't recover, pivot to **drop codes** to find the blocker. Start with configuration and quota issues such as `402` (daily cap), `401` or `403` (authentication or permission), and client storage problems like `CLIENT_PERSISTENCE_CAPACITY`, `CLIENT_READONLY`, or `CLIENT_STORAGE_DISABLED`. Fix the underlying cause, then confirm that **dropped** returns to zero and **success** rises on the next intervals.

## Cost and data volume

SDK stats send aggregated `customMetrics` records. The workload publishes counters instead of every telemetry item, so the data volume stays low relative to application telemetry. The records bill as standard Application Insights data ingestion for `customMetrics`, and they follow your retention settings. The exporter sends the counters on the existing ingestion channel.

**Planning formula**

```
Estimated records per hour per instance ≈
  (#metrics emitted per interval)
  × (3600 / interval_seconds)
  × (distinct dimension combinations you use)
```

The default interval is **15 minutes** (`interval_seconds = 900`). Configure a different interval with `APPLICATIONINSIGHTS_SDKSTATS_EXPORT_INTERVAL`.

## Use SDK stats in Azure Monitor outside of the default workbook

You can use SDK stats custom metrics with other Azure Monitor features.

- [Azure Data Explorer](/azure/data-explorer/data-explorer-overview)
- [Log Analytics](../logs/log-analytics-overview.md) through the `customMetrics` table
- [Alerts](../alerts/alerts-overview.md)
- [Power BI](/power-bi/fundamentals/power-bi-overview)
- [Metrics explorer](../metrics/analyze-metrics.md)

### Azure Data Explorer

The following are [Kusto Query Language (KQL)](/kusto/query/) reference samples.

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

**Rates over time**

```kusto
let g = 15m;
customMetrics
| where name in ("preview.item.dropped.count", "preview.item.success.count", "preview.item.retry.count")
| summarize 
    success = sumif(todouble(value), name == "preview.item.success.count"),
    dropped = sumif(todouble(value), name == "preview.item.dropped.count"),
    retry   = sumif(todouble(value), name == "preview.item.retry.count")
    by bin(timestamp, g)
| extend drop_rate = dropped / iff((success + dropped) == 0.0, 1.0, (success + dropped))
| extend retry_to_attempt_ratio = retry / iff((success + dropped) == 0.0, 1.0, (success + dropped))
| project timestamp, drop_rate, retry_to_attempt_ratio
```

**Request and dependency analysis over time (replicates the stacked bars)**

```kusto
let g = 15m;
// Successful request or dependency telemetry: sent vs dropped
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

// Failed request or dependency telemetry: sent vs dropped
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

### Alerts

Create log alerts that monitor ratios or specific codes.

```kusto
// Drop rate over 5 minutes
let window = 5m;
customMetrics
| where timestamp >= ago(window)
| where name in ("preview.item.success.count", "preview.item.dropped.count")
| summarize 
    success = sumif(todouble(value), name == "preview.item.success.count"),
    dropped = sumif(todouble(value), name == "preview.item.dropped.count")
| extend drop_rate = dropped / iff((success + dropped) == 0.0, 1.0, (success + dropped))
| project drop_rate
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

### Power BI

Use the **Azure Monitor Logs** connector to bring these metrics into [Power BI](/power-bi/fundamentals/power-bi-overview).

```kusto
// Drop and retry ratios by hour
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
| extend drop_rate = dropped / iff((success + dropped) == 0.0, 1.0, (success + dropped))
| extend retry_to_attempt_ratio = retry / iff((success + dropped) == 0.0, 1.0, (success + dropped))
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

### Metrics explorer

Chart these SDK stats in **Metrics**.

1. Open your Application Insights resource.
2. Open **Metrics**.
3. For **Metric Namespace**, select **Log-based metrics**.
4. For **Metric**, choose one of:
   - `preview.item.success.count`
   - `preview.item.dropped.count`
   - `preview.item.retry.count`
5. (Optional) Set **Aggregation** to **Sum** for time‑grain totals.
6. Use **Split by** to investigate. Common splits:
   - **drop.reason**, **drop.code**  
   - **telemetry_type**, **sdkVersion**  
   - **cloud_RoleName**, **cloud_RoleInstance**

## How do SDK stats counts differ from logs?

Don't expect these counters to equal item counts in tables such as `requests` or `dependencies`. Differences occur for several reasons:

- **Aggregation timing**. Stats aggregate over intervals and batches. Logs store individual items, so counts across different time grains can drift.
- **Sampling and processors**. Stats count items after the SDK applies sampling and any processors that drop or modify telemetry. Logs reflect what the ingestion endpoint accepted.
- **Partial successes**. The ingestion endpoint can accept part of a batch and reject the rest. The exporter records accepted items as success and rejected items as dropped in the same interval.
- **Local buffering**. When the exporter retries, it can send buffered items later. The time that stats assign dropped, retried, or successful counts doesn't always match the event time of the original telemetry.
- **Over quota or daily cap**. When the resource exceeds its daily cap, the ingestion endpoint returns an error and the exporter records drops. The corresponding application telemetry doesn't appear in logs during the cap window.
- **Scope**. Stats cover exporter behavior. Logs cover end to end telemetry, including fields that don't affect exporter success.