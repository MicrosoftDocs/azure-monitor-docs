---
title: Azure Monitor Logs reference - AACHttpRequest
description: Reference for AACHttpRequest table in Azure Monitor Logs.
ms.topic: reference
ms.service: azure-monitor
ms.subservice: logs
ms.author: orens
author: osalzberg
ms.date: 09/16/2024
---

# AACHttpRequest

Incoming requests to Azure App Configuration. The records in this table are aggregated. The 'HitCount' field describes the number of requests that each record accounts for.


## Table attributes

|Attribute|Value|
|---|---|
|**Resource types**|microsoft.appconfiguration/configurationstores|
|**Categories**|Azure Resources|
|**Solutions**| LogManagement|
|**Basic log**|No|
|**Ingestion-time transformation**|Yes|
|**Sample Queries**|[Yes](/azure/azure-monitor/reference/queries/aachttprequest)|



## Columns
  
[!INCLUDE [aachttprequest](~/reusable-content/ce-skilling/azure/includes/azure-monitor/reference/tables/aachttprequest-include.md)]
