---
title: Azure Monitor Logs reference - ABAPAuditLog
description: Reference for ABAPAuditLog table in Azure Monitor Logs.
ms.topic: reference
ms.service: azure-monitor
ms.subservice: logs
ms.author: orens
author: osalzberg
ms.date: 11/04/2024
---

# ABAPAuditLog

SAP security audit log is used to keep records of important user transactions and system events within an SAP system. This table stores information such as who accessed the system, which transactions were executed, and when. It provides a useful tool for monitoring activity and detecting potential security breaches.


## Table attributes

|Attribute|Value|
|---|---|
|**Resource types**|-|
|**Categories**|Security|
|**Solutions**| SecurityInsights|
|**Basic log**|No|
|**Ingestion-time transformation**|No|
|**Sample Queries**|[Yes](/azure/azure-monitor/reference/queries/abapauditlog)|



## Columns
  
[!INCLUDE [abapauditlog](~/reusable-content/ce-skilling/azure/includes/azure-monitor/reference/tables/abapauditlog-include.md)]
