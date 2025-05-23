---
title: Example log table queries for AACAudit
description:  Example queries for AACAudit log table
ms.topic: generated-reference
ms.service: azure-monitor
ms.author: edbaynash
author: EdB-MSFT
ms.date: 04/14/2025

# This file is automatically generated. Changes will be overwritten. Do not change this file directly. 

---

# Queries for the AACAudit table

For information on using these queries in the Azure portal, see [Log Analytics tutorial](/azure/azure-monitor/logs/log-analytics-tutorial). For the REST API, see [Query](/rest/api/loganalytics/query).


### Most recent delete key-value operations  


List the most recent deleting key-value operations in App Config data plane.  

```query
// This query helps retrieve the most recent 10 audit logs for deleting key-value operations in App Configuration data plane.
AACAudit
| where EventCategory == "ApplicationManagement" and OperationName == "delete-keyvalue"
| where TimeGenerated > ago(1h)
| sort by TimeGenerated desc
| limit 10

```



### Most recent client error  


Lists the most recent failures because of client error.  

```query
// This query helps list the most recent 10 audit logs for failures because of client error. 
AACAudit
| where ResultType == "ClientError" and TimeGenerated > ago(1h)
| sort by TimeGenerated desc
| limit 10

```

