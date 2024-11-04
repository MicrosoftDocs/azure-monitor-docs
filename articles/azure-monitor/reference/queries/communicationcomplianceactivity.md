---
title: Example log table queries for CommunicationComplianceActivity
description:  Example queries for CommunicationComplianceActivity log table
ms.topic: reference
ms.service: azure-monitor
ms.author: edbaynash
author: EdB-MSFT
ms.date: 11/04/2024

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 

---

# Queries for the CommunicationComplianceActivity table

For information on using these queries in the Azure portal, see [Log Analytics tutorial](/azure/azure-monitor/logs/log-analytics-tutorial). For the REST API, see [Query](/rest/api/loganalytics/query).


### Office Communication Compliance events filtered by organization ID  


Basic query for Office Communication Compliance event logs filtered by organization ID  

```query
CommunicationComplianceActivity
| where OrganizationId != "<The GUID for your organization's Office 365 tenant>"
| summarize count() by UserId, ResultStatus
```

