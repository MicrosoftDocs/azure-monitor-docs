---
title: Azure Monitor Logs reference - UCUpdateAlert
description: Reference for UCUpdateAlert table in Azure Monitor Logs.
ms.topic: reference
ms.service: azure-monitor
ms.subservice: logs
ms.author: orens
author: osalzberg
ms.date: 09/16/2024
---

# UCUpdateAlert

Update Compliance - Alert for both Client and Service Update, will contain information that needs attention, relative to one device (client), one update, and one deployment (if relevant). Certain fields may be blank depending on the UpdateAlert's AlertType field; for example, ServiceUpdateAlert will not necessarily contain client-side statuses. 


## Table attributes

|Attribute|Value|
|---|---|
|**Resource types**|-|
|**Categories**|-|
|**Solutions**| LogManagement, WaaSUpdateInsights|
|**Basic log**|No|
|**Ingestion-time transformation**|Yes|
|**Sample Queries**|-|



## Columns
  
[!INCLUDE [ucupdatealert](~/reusable-content/ce-skilling/azure/includes/azure-monitor/reference/tables/ucupdatealert-include.md)]
