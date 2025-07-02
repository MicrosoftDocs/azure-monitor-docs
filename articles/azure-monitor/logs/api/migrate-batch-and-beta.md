---
title: Migrate from using batch and beta queries to the standard Log Analytics query API 
description: Migrate from the batch operation and beta version of the Log Analytics and Application Insights APIs
ms.date: 06/25/2025
ms.reviewer: ron.frenkel
ms.topic: upgrade-and-migration-article
---

# Migrate from Logs Query API batch operation and beta version

The Azure Monitor Logs Query API is deprecating the `batch` query operation and the `beta` API version. Support for these features is available according to the following timelines:

| Support cutoff date | Deprecation | Migration steps |
|---|---|---|
| March 31, 2026 | Logs Query API `beta` version | [Change `beta` path to `v1`](#change-beta-path-to-v1) |
| March 31, 2028 | Logs Query API `batch` operation | [Split batch queries into single queries](#split-batch-queries-to-single-queries) |

### Change `beta` path to `v1`

To migrate from the `beta` version of the Logs Query API, change the path in your API calls from `beta` to `v1`.

| Operation group reference | URI examples |
|---|---|
| [Log Analytics](/rest/api/loganalytics/operation-groups?view=rest-loganalytics-2022-10-27-preview)<br>`query`<br>`metadata` |  `https://api.loganalytics.azure.com/beta/`<br>`https://api.loganalytics.io/beta/` |
| Log Analytics via ARM<a id="note1"><sup>1</sup></a><br>`query`<br>`metadata` | `https://management.azure.com/.../api/query?api-version=2017-01-01-preview`<br>`https://management.azure.com/.../api/metadata?api-version=2017-01-01-preview` |
| [Application Insights](/rest/api/application-insights/operation-groups?view=rest-application-insights-v1)<br>`query`<br>`metadata`<br>`metrics`<br>`events` | `https://api.applicationinsights.azure.com/beta/`<br>`https://api.applicationinsights.io/beta/` |

<a href="#note1"><sup>1</sup></a>*Log Analytics queries via ARM should migrate to the Logs Query API `v1` version.*

For more information, see the Logs Query API [request format](request-format.md#public-api-format).

### Split batch queries to single queries

To migrate [batch API calls](batch-queries.md), split every query that you previously sent as part of the `requests` array in the body of the message and use the `query` section in the [standard request format](request-format.md) instead.

If you use an Azure SDK client library to initiate batch queries, split batched queries to run as separate queries using the corresponding methods.

| Ecosystem  | Package                                                                                                |
|------------|--------------------------------------------------------------------------------------------------------|
| .NET       | [Azure.Monitor.Query](/dotnet/api/overview/azure/monitor.query-readme)                                 |
| Go         | [azlogs](https://pkg.go.dev/github.com/Azure/azure-sdk-for-go/sdk/monitor/query/azlogs#section-readme) |
| Java       | [azure-monitor-query](/java/api/overview/azure/monitor-query-readme)                                   |
| JavaScript | [@azure/monitor-query](/javascript/api/overview/azure/monitor-query-readme)                            |
| Python     | [azure-monitor-query](/python/api/overview/azure/monitor-query-readme)                                 |

Make sure to adjust and handle the response using Logs Query API [response format](response-format.md).
