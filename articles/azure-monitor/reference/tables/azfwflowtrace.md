---
title: Azure Monitor Logs reference - AZFWFlowTrace
description: Reference for AZFWFlowTrace table in Azure Monitor Logs.
ms.topic: reference
ms.service: azure-monitor
ms.subservice: logs
ms.author: orens
author: osalzberg
ms.date: 09/16/2024
---

# AZFWFlowTrace

Flow logs across Azure Firewall instances. Log contains flow information, flags and the time period when the flows were recorded. Please follow the documentation to enable flow trace logging and details on how it is recorded.


## Table attributes

|Attribute|Value|
|---|---|
|**Resource types**|microsoft.network/azurefirewalls|
|**Categories**|Azure Resources|
|**Solutions**| LogManagement|
|**Basic log**|Yes|
|**Ingestion-time transformation**|No|
|**Sample Queries**|[Yes](/azure/azure-monitor/reference/queries/azfwflowtrace)|



## Columns
  
[!INCLUDE [azfwflowtrace](~/reusable-content/ce-skilling/azure/includes/azure-monitor/reference/tables/azfwflowtrace-include.md)]
