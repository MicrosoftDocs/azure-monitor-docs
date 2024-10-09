---
title: Azure Monitor Logs reference - AgriFoodJobProcessedLogs
description: Reference for AgriFoodJobProcessedLogs table in Azure Monitor Logs.
ms.topic: reference
ms.service: azure-monitor
ms.subservice: logs
ms.author: orens
author: osalzberg
ms.date: 09/16/2024
---

# AgriFoodJobProcessedLogs

Logs indicating success or failure of job runs for farmOperationDataIngestionJob, farmOperationPeriodicJob, farmOperationEventHandlingJob,satelliteDataIngestionJob, weatherDataIngestionJob etc. These logs also contain reasons for failure of these jobs if any.


## Table attributes

|Attribute|Value|
|---|---|
|**Resource types**|microsoft.agfoodplatform/farmbeats|
|**Categories**|Azure Resources|
|**Solutions**| LogManagement|
|**Basic log**|No|
|**Ingestion-time transformation**|No|
|**Sample Queries**|[Yes](/azure/azure-monitor/reference/queries/agrifoodjobprocessedlogs)|



## Columns
  
[!INCLUDE [agrifoodjobprocessedlogs](~/reusable-content/ce-skilling/azure/includes/azure-monitor/reference/tables/agrifoodjobprocessedlogs-include.md)]
