---
title: Example log table queries for EGNSuccessfulMqttConnections
description:  Example queries for EGNSuccessfulMqttConnections log table
ms.topic: reference
ms.service: azure-monitor
ms.author: edbaynash
author: EdB-MSFT
ms.date: 09/16/2024

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 

---

# Queries for the EGNSuccessfulMqttConnections table

For information on using these queries in the Azure portal, see [Log Analytics tutorial](/azure/azure-monitor/logs/log-analytics-tutorial). For the REST API, see [Query](/rest/api/loganalytics/query).


### Session connections query  


Connections report by session names.  

```query
EGNSuccessfulMqttConnections
| summarize count() by SessionName
```

