---
title: Azure Monitor Logs reference - UpdateRunProgress
description: Reference for UpdateRunProgress table in Azure Monitor Logs.
ms.topic: reference
ms.service: azure-monitor
ms.subservice: logs
ms.author: orens
author: osalzberg
ms.date: 09/16/2024
---

# UpdateRunProgress

Breaks down each run of your update schedule by the patches available at the time with details on the installation status of each patch.


## Table attributes

|Attribute|Value|
|---|---|
|**Resource types**|microsoft.compute/virtualmachines,<br>microsoft.conenctedvmwarevsphere/virtualmachines,<br>microsoft.azurestackhci/virtualmachines,<br>microsoft.scvmm/virtualmachines,<br>microsoft.compute/virtualmachinescalesets,<br>microsoft.automation/automationaccounts|
|**Categories**|IT & Management Tools|
|**Solutions**| Updates|
|**Basic log**|No|
|**Ingestion-time transformation**|Yes|
|**Sample Queries**|[Yes](/azure/azure-monitor/reference/queries/updaterunprogress)|



## Columns
  
[!INCLUDE [updaterunprogress](~/reusable-content/ce-skilling/azure/includes/azure-monitor/reference/tables/updaterunprogress-include.md)]
