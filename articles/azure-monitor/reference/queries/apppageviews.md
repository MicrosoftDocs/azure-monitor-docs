---
title: Example log table queries for AppPageViews
description:  Example queries for AppPageViews log table
ms.topic: generated-reference
ms.service: azure-monitor
ms.author: edbaynash
author: EdB-MSFT
ms.date: 04/14/2025

# This file is automatically generated. Changes will be overwritten. Do not change this file directly. 

---

# Queries for the AppPageViews table

For information on using these queries in the Azure portal, see [Log Analytics tutorial](/azure/azure-monitor/logs/log-analytics-tutorial). For the REST API, see [Query](/rest/api/loganalytics/query).


### Page views trend  


Chart the page views count, during the last day.  

```query
// To create an alert for this query, click '+ New alert rule'
AppPageViews
| where ClientType == 'Browser'
| summarize count_sum = sum(ItemCount) by bin(TimeGenerated,30m), _ResourceId
| render timechart
```



### Slowest pages  


What are the 3 slowest pages, and how slow are they?  

```query
AppPageViews
| where notempty(DurationMs) and ClientType == 'Browser'
| extend total_duration=DurationMs*ItemCount
| summarize avg_duration=(sum(total_duration)/sum(ItemCount)) by OperationName
| top 3 by avg_duration desc
```

