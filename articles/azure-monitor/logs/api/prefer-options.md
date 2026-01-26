---
title: Prefer options
description: The API supports setting some request options using the Prefer header. This section describes how to set each preference and their values.
ms.date: 08/12/2024
ms.topic: how-to
---
# Logs query API `Prefer` options

The Logs query API supports setting some request and response options using the `Prefer` header. This section describes how to set each preference and their values.

## `Prefer:include-render` - visualization information

In the query language, you can specify different render options. By default, the API doesn't return information about the type of visualization. To include a specific visualization, include this header:

```
    Prefer: include-render=true
```

The header includes a `render` property in the response that specifies the type of visualization selected by the query and any properties for that visualization.

For example, the following request specifies a visualization of a bar chart with title "24H Perf events":

```
    POST https://api.loganalytics.azure.com/v1/workspaces/{workspace-id}/query
    Authorization: Bearer <access token>
    Prefer: include-render=true
    Content-Type: application/json
    
    {
        "query": "Perf | summarize count() by bin(TimeGenerated, 4h) | render barchart title='24H Perf events'",
        "timespan": "P1D"
    }
```

The response contains a `render` property, which describes the metadata for the selected visualization.

```
    HTTP/1.1 200 OK
    Content-Type: application/json; charset=utf-8
    
    {
        "tables": [ ...query results... ],
        "render": {
            "visualization": "barchart",
            "title": "24H Perf events",
            "accumulate": false,
            "isQuerySorted": false,
            "kind": "default",
            "annotation": "",
            "by": null
        }
    }
```

## `Prefer:include-statistics` - Query statistics

To get information about query statistics, include this header:

```
    Prefer: include-statistics=true
```

The header includes a `statistics` property in the response that describes various performance statistics such as query execution time and resource usage.

## `Prefer:wait` - Query timeout

The default query timeout is 3 minutes (180 seconds). To adjust the query timeout, set the `wait` header request value in seconds.

```
    Prefer: wait=300
```

For more information, see [Logs query API server timeouts](timeouts.md). 

## `Prefer:include-dataSources` - Query data sources

To get information about the query data sources like regions, workspaces, clusters, and tables, include this header:

```
    Prefer: include-dataSources=true
```

## `Prefer:include-permissions` - List permissions

To query logs for Azure resources, users must have appropriate permissions to access both the resource and the Log Analytics workspace containing the logs. If a user lacks the necessary permissions, different error responses might be returned depending on the specific permission that's missing. A good permissions troubleshooting step is to include the following header in the request:

```
    Prefer: include-permissions=true
```

For more information, see [Logs query API resource query access troubleshooting](azure-resource-queries.md#partial-access).
