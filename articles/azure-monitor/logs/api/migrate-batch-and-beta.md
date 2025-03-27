---
title: Migrate from using batch and beta queries to the standard Log Analytics query API 
description: Migrate from using batch and beta queries to the standard query API.
ms.date: 02/26/2025
author: guywi-ms
ms.author: guywild
ms.reviewer: ron.frenkel
ms.topic: article
---

# Migrate from using batch and beta queries to the standard Log Analytics query API

Azure Monitor Logs is deprecating the batch query and beta query APIs. Support for these APIs is available according to the following timelines:

| Deprecated API | Identifier | Support cutoff date |
|---|---|
| beta | `https://api.loganalytics.io/beta/` | March 31, 2026 |
| batch | `https://api.loganalytics.azure.com/v1/$batch` | March 31, 2028 |

This article explains how to use the [standard Log Analytics query API](overview.md) for existing queries that currently use the batch query and beta query APIs.

## Migrate batch queries to single queries

- To migrate [batch API calls](batch-queries.md), split every query that you send as part of the `requests` array in the body of the message and use the [standard request format](request-format.md).
- If you use Azure Monitor SDKs or packages to initiate batch queries, split batched queries to run as separate queries using the corresponding method:
  - .NET: [Azure Monitor Query client library for .NET](/dotnet/api/overview/azure/monitor.query-readme)
  - Java: [Azure Monitor Query client library for Java](/java/api/overview/azure/monitor-query-readme)
  - JavaScript: [Azure Monitor Query client library for JavaScript](/javascript/api/overview/azure/monitor-query-readme)
  - Python: [Azure Monitor Query client library for Python](/python/api/overview/azure/monitor-query-readme)

Make sure to adjust and handle the response using [the standard response format](response-format.md).

## Migrate beta queries to standard queries

To migrate queries that use the Beta API - for example, `https://api.loganalytics.io/beta/workspaces/{workspaceId}/query` - use the [standard request format](request-format.md) instead.
