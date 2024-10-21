---
title: Azure Monitor Logs reference - ConfigurationData
description: Reference for ConfigurationData table in Azure Monitor Logs.
ms.topic: reference
ms.service: azure-monitor
ms.subservice: logs
ms.author: orens
author: osalzberg
ms.date: 09/16/2024
---

# ConfigurationData

View the last reported state for in-guest configuration data such as Files Software Registry Keys Windows Services and Linux Daemons


## Table attributes

|Attribute|Value|
|---|---|
|**Resource types**|microsoft.compute/virtualmachines,<br>microsoft.conenctedvmwarevsphere/virtualmachines,<br>microsoft.azurestackhci/virtualmachines,<br>microsoft.scvmm/virtualmachines,<br>microsoft.compute/virtualmachinescalesets|
|**Categories**|IT & Management Tools|
|**Solutions**| ChangeTracking|
|**Basic log**|No|
|**Ingestion-time transformation**|Yes|
|**Sample Queries**|[Yes](/azure/azure-monitor/reference/queries/configurationdata)|



## Columns
  
[!INCLUDE [configurationdata](~/reusable-content/ce-skilling/azure/includes/azure-monitor/reference/tables/configurationdata-include.md)]
