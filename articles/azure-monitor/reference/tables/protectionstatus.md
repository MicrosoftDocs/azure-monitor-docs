---
title: Azure Monitor Logs reference - ProtectionStatus
description: Reference for ProtectionStatus table in Azure Monitor Logs.
ms.topic: reference
ms.service: azure-monitor
ms.subservice: logs
ms.author: orens
author: osalzberg
ms.date: 09/16/2024
---

# ProtectionStatus

Antimalware installation info and security health status of the machine:


## Table attributes

|Attribute|Value|
|---|---|
|**Resource types**|microsoft.compute/virtualmachines,<br>microsoft.conenctedvmwarevsphere/virtualmachines,<br>microsoft.azurestackhci/virtualmachines,<br>microsoft.scvmm/virtualmachines,<br>microsoft.compute/virtualmachinescalesets|
|**Categories**|Security|
|**Solutions**| AntiMalware, Security, SecurityCenter, SecurityCenterFree|
|**Basic log**|No|
|**Ingestion-time transformation**|Yes|
|**Sample Queries**|[Yes](/azure/azure-monitor/reference/queries/protectionstatus)|



## Columns
  
[!INCLUDE [protectionstatus](~/reusable-content/ce-skilling/azure/includes/azure-monitor/reference/tables/protectionstatus-include.md)]
