---
title: Migrate from using batch and beta queries to the standard Log Analytics query API 
description: Migrate from using batch and beta queries to the standard query API.
ms.date: 06/25/2025
ms.reviewer: ron.frenkel
ms.topic: upgrade-and-migration-article
---

# Migrate from the batch operation and beta version of the Log Analytics and Application Insights APIs

Azure Monitor Logs is deprecating the batch query operation and beta API version. Support for these APIs is available according to the following timelines:

| Deprecated APIs | Affected Endpoint | Support cutoff date | Migration steps |
|---|---|---|---|
| Log Analytics *beta* versions of the following operations:</br>`query`</br>`metadata`| `api.loganalytics.azure.com/beta/`</br>`api.loganalytics.io/beta/` | March 31, 2026 | Change path to *v1*</br>See examples of the [format](request-format.md#public-api-format) in the [Azure REST API reference](/rest/api/loganalytics/operation-groups?view=rest-loganalytics-2022-10-27-preview) or [Azure OpenAPI specification](https://github.com/Azure/azure-rest-api-specs/blob/main/specification/operationalinsights/data-plane/Microsoft.OperationalInsights/stable/v1/OperationalInsights.json)  |
| Application Insights *beta* versions of the following operations:</br>`query`</br>`metadata`</br>`events`</br>`metrics` | `https://api.applicationinsights.azure.com/beta/`</br>`https://api.applicationinsights.io/beta/` | March 31, 2026 | Change path to *v1*</br>See examples of the format in the [Azure REST API reference](/rest/api/application-insights/operation-groups?view=rest-application-insights-v1) or [Azure OpenAI specification] (https://github.com/Azure/azure-rest-api-specs/blob/main/specification/applicationinsights/data-plane/Microsoft.Insights/preview/v1/AppInsights.json) |
| Log Analytics via ARM *beta* versions of the following operations:</br>`query`</br>`metadata` | `management.azure.com/.../api/query?api-version=2017-01-01-preview`</br>`management.azure.com/.../api/metadata?api-version=2017-01-01-preview` | March 31, 2026 | Switch to the Log Analytics API and use the *v1* path |
| `batch` operation via Log Analytics API or Azure client SDKs | `api.loganalytics.azure.com/v1/$batch`</br>`api.loganalytics.io/v1/$batch` | March 31, 2028 | [Split batch queries into single queries](#split-batch-queries-to-single-queries) |


## Split batch queries to single queries

To migrate [batch API calls](batch-queries.md), split every query that you previously sent as part of the `requests` array in the body of the message and use the `query` section in the [standard request format](request-format.md) instead.

If you use an Azure SDK client library to initiate batch queries, split batched queries to run as separate queries using the corresponding methods.

| Ecosystem  | Package                                                                                                |
|------------|--------------------------------------------------------------------------------------------------------|
| .NET       | [Azure.Monitor.Query](/dotnet/api/overview/azure/monitor.query-readme)                                 |
| Go         | [azlogs](https://pkg.go.dev/github.com/Azure/azure-sdk-for-go/sdk/monitor/query/azlogs#section-readme) |
| Java       | [azure-monitor-query](/java/api/overview/azure/monitor-query-readme)                                   |
| JavaScript | [@azure/monitor-query](/javascript/api/overview/azure/monitor-query-readme)                            |
| Python     | [azure-monitor-query](/python/api/overview/azure/monitor-query-readme)                                 |

Make sure to adjust and handle the response using [the standard response format](response-format.md).
