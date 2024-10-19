---
title: Example log table queries for AZMSHybridConnectionsEvents
description:  Example queries for AZMSHybridConnectionsEvents log table
ms.topic: reference
ms.service: azure-monitor
ms.author: edbaynash
author: EdB-MSFT
ms.date: 09/16/2024

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 

---

# Queries for the AZMSHybridConnectionsEvents table

For information on using these queries in the Azure portal, see [Log Analytics tutorial](/azure/azure-monitor/logs/log-analytics-tutorial). For the REST API, see [Query](/rest/api/loganalytics/query).


### Publish HTTP send data for hybrid connection  


Publish details for send events on a hybrid connection.  

```query
//Endpoint needs to be replaced with client specific endpoint.
AZMSHybridConnectionsEvents
| extend NamespaceName = tostring(split(_ResourceId, "/")[8])
| where OperationName == "Microsoft.Relay/HybridConnections/SenderSentHttpRequest"
| where Endpoint contains "shamavijay-relay-hybconn"
| project NamespaceName, TaskName, Message, OperationName
| summarize by NamespaceName, TaskName
```

