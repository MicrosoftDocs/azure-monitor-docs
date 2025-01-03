---
title: Azure Monitor Logs reference - UpdateSummary
description: Reference for UpdateSummary table in Azure Monitor Logs.
ms.topic: reference
ms.service: azure-monitor
ms.subservice: logs
ms.author: orens
author: osalzberg
ms.date: 09/16/2024
---

# UpdateSummary

Summary for each update schedule run. Includes information such as how many updates were not installed.


## Table attributes

|Attribute|Value|
|---|---|
|**Resource types**|microsoft.compute/virtualmachines,<br>microsoft.conenctedvmwarevsphere/virtualmachines,<br>microsoft.azurestackhci/virtualmachines,<br>microsoft.scvmm/virtualmachines,<br>microsoft.compute/virtualmachinescalesets,<br>microsoft.automation/automationaccounts|
|**Categories**|Virtual Machines|
|**Solutions**| Security, SecurityCenter, SecurityCenterFree, Updates|
|**Basic log**|No|
|**Ingestion-time transformation**|Yes|
|**Sample Queries**|[Yes](/azure/azure-monitor/reference/queries/updatesummary)|



## Columns
  
[!INCLUDE [updatesummary](~/reusable-content/ce-skilling/azure/includes/azure-monitor/reference/tables/updatesummary-include.md)]
