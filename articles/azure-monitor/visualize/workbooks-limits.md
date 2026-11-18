---
title: Azure Workbooks limits | Microsoft docs
description: Learn about the limits of each type of workbook data sources and visualizations.
ms.topic: limits-and-quotas
ms.date: 04/02/2026
ms.reviewer: gardnerjr
---

# Workbook limits

Azure Workbooks limits the size of saved workbooks and the results returned or displayed by data sources, visualizations, and parameters. This article describes these limits.

## Saved size limit

The maximum size of a saved Azure Workbook is approximately 2 MB. This limit includes the workbook content, such as embedded JSON data, query text, and Markdown text, along with metadata such as the workbook name, resource group, and other properties. If the total size exceeds this limit, the workbook fails to save with an HTTP 413 "Payload Too Large" error.

To keep large workbooks manageable, split them into smaller workbooks that you can load and manage independently. You can also use the workbook group items **From a template** option to load content from other workbooks without storing that content in the parent workbook. For more information, see [Splitting a large template](./workbooks-create-workbook.md#splitting-a-large-template-into-many-templates).

## Workbooks result limits

Data source, visualization, and parameter limits have some points in common:

- In general, Azure Workbooks limits the results of queries to no more than 10,000 results. Any results after that point are truncated.
- Each data source might have its own specific limits based on the limits of the service it queries.
- Those limits might be on the numbers of resources, regions, results returned, and time ranges. Consult the documentation for each service to find those limits.

## Data source limits

This table lists the limits of specific data sources.

| Data source | Limits |
|---------|---------|
| Log-based queries | Log Analytics [has limits](../service-limits.md#log-queries-and-language) for the number of resources, workspaces, and regions involved in queries. |
| Metrics | Metrics grids are limited to querying 200 resources at a time. |
| Azure Resource Graph | Resource Graph limits queries to 1,000 subscriptions at a time. |

## Visualization limits

This table lists the limits of specific data visualizations.

| Visualization | Limits |
|---------|---------|
| Grid | By default, grids display only the first 250 rows of data. Change this setting in the query component's advanced settings to display up to 10,000 rows. The grid ignores any further items and shows a warning.<br>The checkbox for toggling the selection of all items is available only when the grid displays 150 rows of data or fewer.|
| Charts | Charts are limited to 100 series.<br>Charts are limited to 10,000 data points. |
| Tiles | Tiles are limited to displaying 100 tiles. The visualization ignores any further items and shows a warning. |
| Maps | Maps are limited to displaying 100 points. The visualization ignores any further items and shows a warning. |
| Text | Text visualization displays only the first cell of data returned by a query. The visualization ignores any other data. |

## Parameter limits

This table lists the limits of specific data parameters.

|Parameter | Limits |
|---------|---------|
| Drop down | Drop-down-based parameters are limited to 1,000 items. The parameter ignores any items returned by a query after that limit.<br>When based on a query, the parameter uses only the first four columns of data produced by the query. The parameter ignores any other columns. |
| Multi-value | Multi-value parameters are limited to 100 items. The parameter ignores any items returned by a query after that limit.<br>When based on a query, the parameter uses only the first column of data produced by the query. The parameter ignores any other columns. |
| Options group | Options group parameters are limited to 1,000 items. The parameter ignores any items returned by a query after that limit. <br>When based on a query, the parameter uses only the first column of data produced by the query. The parameter ignores any other columns. |
| Text | Text parameters that retrieve their value based on a query display only the first cell returned by the query (row 1, column 1). The parameter ignores any other data. |
