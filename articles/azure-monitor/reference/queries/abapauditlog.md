---
title: Example log table queries for ABAPAuditLog
description:  Example queries for ABAPAuditLog log table
ms.topic: reference
ms.service: azure-monitor
ms.author: edbaynash
author: EdB-MSFT
ms.date: 11/04/2024

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 

---

# Queries for the ABAPAuditLog table

For information on using these queries in the Azure portal, see [Log Analytics tutorial](/azure/azure-monitor/logs/log-analytics-tutorial). For the REST API, see [Query](/rest/api/loganalytics/query).


### ABAP audit log multiple IP logons  


Display multiple users login from the same ip.  

```query
let perIPLimit = 1;
SAPAuditLog
| where MessageId == 'AUM'
| extend DetailsBy = pack("User", User, "Email", Email, "SystemId", SystemId, "ClientId", ClientId)
| summarize LoginbyIPAttempts = count(), Details = make_set(DetailsBy), StartTime = min(TimeGenerated), EndTime = max(TimeGenerated)
    by TerminalIpV6
| where LoginbyIPAttempts > perIPLimit
| mv-expand Details
| evaluate bag_unpack(Details, "Details_")
```



### ABAP audit log file downloads  


Display file downloads activities.  

```query
let TableAccessTcodes= dynamic(["SE16", "SE16N", "SE11", "SE16H", "SM30", "SE12", "SM31", "SE16H", "SE14", "SE54","SE17", "SE16T", "DB01", "DB02"]);
// get data read actions
ABAPAuditLog
    | where MessageID == "AU3"
    | where TransactionCode in (TableAccessTcodes) or Variable1 in (TableAccessTcodes)
    | summarize by TimeAccessed= bin(TimeGenerated, 1h), SystemId, ClientId, User, AbapProgramName
```

