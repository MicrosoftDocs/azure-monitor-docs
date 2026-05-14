---
title: Migrate from Logs Query API Batch and Beta to Latest Version
description: Migrate from the batch operation and beta version of the Azure Monitor Logs query API to the v1 endpoint with single queries.
ms.date: 05/13/2026
ms.reviewer: ron.frenkel
ms.topic: upgrade-and-migration-article
ai-usage: ai-assisted

#customer intent: As a developer using the Azure Monitor Logs query API, I want to migrate from the deprecated batch operation and beta version so that my queries continue to work after the deprecation dates.

---

# Migrate from Logs Query API batch operation and beta version

The Azure Monitor Logs Query API is deprecating the `batch` query operation and the `beta` API version. Support for these features is available according to the following timelines:

| Support cutoff date | Deprecation | Migration steps |
|---|---|---|
| March 31, 2026 | Logs query API `beta` version | [Change `beta` path to `v1`](#change-beta-path-to-v1) |
| March 31, 2028 | Logs query API `batch` operation | [Split batch queries into single queries](#split-batch-queries-into-single-queries) |

## Change `beta` path to `v1`

To migrate from the `beta` version of the Logs query API, change the path in your API calls from `beta` to `v1`.

| Operation group reference | URI examples |
|---------------------------|--------------|
| [Log Analytics](../../fundamentals/azure-monitor-rest-api-index.md#logs-query)<br>`query`<br>`metadata` | `https://api.loganalytics.azure.com/beta/`<br>`https://api.loganalytics.io/beta/` |
| Log Analytics via ARM<a id="note1"></a><sup>1</sup><br>`query`<br>`metadata` | `https://management.azure.com/.../api/query?api-version=2017-01-01-preview`<br>`https://management.azure.com/.../api/metadata?api-version=2017-01-01-preview` |
| [Application Insights](../../fundamentals/azure-monitor-rest-api-index.md#application-insights-apis)<br>`query`<br>`metadata`<br>`metrics`<br>`events` | `https://api.applicationinsights.azure.com/beta/`<br>`https://api.applicationinsights.io/beta/` |

<a href="#note1"><sup>1</sup></a>Log Analytics queries via ARM should migrate to the Logs Query API `v1` [request format](request-format.md#public-query-endpoint-format).

## Split batch queries into single queries

To migrate [batch API calls](batch-queries.md), split every query that you previously sent as part of the `requests` array in the body of the message and use the `query` section in the [request format](request-format.md#post-request-format) instead.

If you use an Azure SDK client library to initiate batch queries, split batched queries to run as separate queries by using the corresponding methods.

| Ecosystem  | Package                                                                                                |
|------------|--------------------------------------------------------------------------------------------------------|
| .NET       | [Azure.Monitor.Query](/dotnet/api/overview/azure/monitor.query-readme)                                 |
| Go         | [azlogs](https://pkg.go.dev/github.com/Azure/azure-sdk-for-go/sdk/monitor/query/azlogs#section-readme) |
| Java       | [azure-monitor-query](/java/api/overview/azure/monitor-query-readme)                                   |
| JavaScript | [@azure/monitor-query](/javascript/api/overview/azure/monitor-query-readme)                            |
| Python     | [azure-monitor-query](/python/api/overview/azure/monitor-query-readme)                                 |

Adjust your response handling by using the Logs query API [response format](response-format.md).

## Related content

- [Logs query API request format](request-format.md)
- [Logs query API response format](response-format.md)
- [Azure Monitor REST API reference](../../fundamentals/azure-monitor-rest-api-index.md)
