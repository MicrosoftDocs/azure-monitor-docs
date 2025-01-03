---
title: Azure Monitor Logs reference - AZFWFatFlow
description: Reference for AZFWFatFlow table in Azure Monitor Logs.
ms.topic: reference
ms.service: azure-monitor
ms.subservice: logs
ms.author: orens
author: osalzberg
ms.date: 09/16/2024
---

# AZFWFatFlow

This query returns the top flows across Azure Firewall instances. Log contains flow information, date transmission rate (in Megabits per second units) and the time period when the flows were recorded. Please follow the documentation to enable Top flow logging and details on how it is recorded.


## Table attributes

|Attribute|Value|
|---|---|
|**Resource types**|microsoft.network/azurefirewalls|
|**Categories**|Security|
|**Solutions**| LogManagement|
|**Basic log**|No|
|**Ingestion-time transformation**|No|
|**Sample Queries**|[Yes](/azure/azure-monitor/reference/queries/azfwfatflow)|



## Columns
  
[!INCLUDE [azfwfatflow](~/reusable-content/ce-skilling/azure/includes/azure-monitor/reference/tables/azfwfatflow-include.md)]
