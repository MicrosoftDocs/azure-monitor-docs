---
title: Example log table queries for ProjectActivity
description:  Example queries for ProjectActivity log table
ms.topic: reference
ms.service: azure-monitor
ms.author: edbaynash
author: EdB-MSFT
ms.date: 11/20/2024

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 

---

# Queries for the ProjectActivity table

For information on using these queries in the Azure portal, see [Log Analytics tutorial](/azure/azure-monitor/logs/log-analytics-tutorial). For the REST API, see [Query](/rest/api/loganalytics/query).


### MS Project events filtered by organization ID  


Display events from more than one day ago, filtered by organization ID and summarized by user ID and result status.  

```query
ProjectActivity
| where OrganizationId != "22223333-cccc-4444-dddd-5555eeee6666"
| summarize count() by UserId, ResultStatus

```

