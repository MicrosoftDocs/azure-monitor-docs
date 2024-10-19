---
title: Example log table queries for ADTEventRoutesOperation
description:  Example queries for ADTEventRoutesOperation log table
ms.topic: reference
ms.service: azure-monitor
ms.author: edbaynash
author: EdB-MSFT
ms.date: 09/16/2024

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 

---

# Queries for the ADTEventRoutesOperation table

For information on using these queries in the Azure portal, see [Log Analytics tutorial](/azure/azure-monitor/logs/log-analytics-tutorial). For the REST API, see [Query](/rest/api/loganalytics/query).


### EventRoutes API Usage  


Count of EventRoute APIs by type (read, write and delete).  

```query
ADTEventRoutesOperation
| summarize count() by OperationName
| render piechart
```

