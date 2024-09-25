---
title: Azure Monitor Logs reference - ASimRegistryEventLogs
description: Reference for ASimRegistryEventLogs table in Azure Monitor Logs.
ms.topic: reference
ms.service: azure-monitor
ms.subservice: logs
ms.author: orens
author: osalzberg
ms.date: 09/24/2024
---

# ASimRegistryEventLogs

The ASim Registry Event schema represents Windows activity of creating, modifying, or deleting Windows Registry entities. Registry events are specific to Windows systems, but are reported by different systems that monitor Windows, such as EDR (End Point Detection and Response) systems, Sysmon, or Windows itself.


## Table attributes

|Attribute|Value|
|---|---|
|**Resource types**|microsoft.securityinsights/asimtables|
|**Categories**|Security|
|**Solutions**| SecurityInsights|
|**Basic log**|No|
|**Ingestion-time transformation**|Yes|
|**Sample Queries**|-|



## Columns
  
[!INCLUDE [asimregistryeventlogs](~/reusable-content/ce-skilling/azure/includes/azure-monitor/reference/tables/asimregistryeventlogs-include.md)]
