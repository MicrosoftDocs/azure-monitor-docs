---
title: Azure Monitor Logs reference - IoTHubDistributedTracing
description: Reference for IoTHubDistributedTracing table in Azure Monitor Logs.
ms.topic: reference
ms.service: azure-monitor
ms.subservice: logs
ms.author: orens
author: osalzberg
ms.date: 09/16/2024
---

# IoTHubDistributedTracing

The distributed tracing category tracks the trace-id and span-id for messages that carry the trace context header. To fully enable these logs, client-side code must be updated by following https://aka.ms/iottracing


## Table attributes

|Attribute|Value|
|---|---|
|**Resource types**|microsoft.devices/iothubs|
|**Categories**|Azure Resources|
|**Solutions**| LogManagement|
|**Basic log**|No|
|**Ingestion-time transformation**|No|
|**Sample Queries**|-|



## Columns
  
[!INCLUDE [iothubdistributedtracing](~/reusable-content/ce-skilling/azure/includes/azure-monitor/reference/tables/iothubdistributedtracing-include.md)]
