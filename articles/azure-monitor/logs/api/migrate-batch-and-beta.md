---
title: Migrate from using batch and beta queries to the standard Log Analytics query API 
description: Migrate from using batch and beta queries to the standard query API.
ms.date: 06/25/2025
ms.reviewer: ron.frenkel
ms.topic: upgrade-and-migration-article
---

# Migrate from using batch and beta queries to the standard Log Analytics query API

Azure Monitor Logs is deprecating the batch query and beta query APIs. Support for these APIs is available according to the following timelines:

| Deprecated API | Identifier | Support cutoff date | Migration action required |
|---|---|---|---|
| beta</br>Log Analytics | `https://api.loganalytics.azure.com/beta/`</br>`https://api.loganalytics.io/beta/` | March 31, 2026 | 
| beta</br>Application Insights | `https://api.applicationinsights.azure.com/beta/`</br>`https://api.applicationinsights.io/beta/` | March 31, 2026 |
| beta</br>Log Analytics via ARM | `https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/api/query?api-version=2017-01-01-preview`</br>`https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/api/metadata?api-version=2017-01-01-preview` | March 31, 2026 |
| batch | `https://api.loganalytics.azure.com/v1/$batch`</br>`https://api.loganalytics.io/v1/$batch` | March 31, 2028 |

This article explains how to use the [standard Log Analytics query API](overview.md) for existing queries that currently use the batch query and beta query APIs.

## Migrate batch queries to single queries

To migrate [batch API calls](batch-queries.md), split every query that you previously sent as part of the `requests` array in the body of the message and use the `query` section in the [standard request format](request-format.md) instead.

If you use an Azure SDK client library listed below to initiate batch queries, split batched queries to run as separate queries using the corresponding method.

| Ecosystem  | Package                                                                                                |
|------------|--------------------------------------------------------------------------------------------------------|
| .NET       | [Azure.Monitor.Query](/dotnet/api/overview/azure/monitor.query-readme)                                 |
| Go         | [azlogs](https://pkg.go.dev/github.com/Azure/azure-sdk-for-go/sdk/monitor/query/azlogs#section-readme) |
| Java       | [azure-monitor-query](/java/api/overview/azure/monitor-query-readme)                                   |
| JavaScript | [@azure/monitor-query](/javascript/api/overview/azure/monitor-query-readme)                            |
| Python     | [azure-monitor-query](/python/api/overview/azure/monitor-query-readme)                                 |

Make sure to adjust and handle the response using [the standard response format](response-format.md).

## Migrate beta queries to standard queries

To migrate queries that use the `beta` API version - for example, `https://api.loganalytics.io/beta/workspaces/{workspaceId}/query` - use the [standard request format](request-format.md) instead.
