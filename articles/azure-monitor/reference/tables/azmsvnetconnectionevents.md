---
title: Azure Monitor Logs reference - AZMSVnetConnectionEvents
description: Reference for AZMSVnetConnectionEvents table in Azure Monitor Logs.
ms.topic: reference
ms.service: azure-monitor
ms.subservice: logs
ms.author: orens
author: osalzberg
ms.date: 09/16/2024
---

# AZMSVnetConnectionEvents

Captures all virtual network and IP filtering logs for Azure Event Hubs and Azure Service Bus. These would only be emitted if namespace allows access from selected networks or from specific IP address (IP Filter rules).


## Table attributes

|Attribute|Value|
|---|---|
|**Resource types**|microsoft.eventhub/namespaces,<br>microsoft.servicebus/namespaces,<br>microsoft.relay/namespaces|
|**Categories**|Azure Resources, Audit|
|**Solutions**| LogManagement|
|**Basic log**|Yes|
|**Ingestion-time transformation**|No|
|**Sample Queries**|[Yes](/azure/azure-monitor/reference/queries/azmsvnetconnectionevents)|



## Columns
  
[!INCLUDE [azmsvnetconnectionevents](~/reusable-content/ce-skilling/azure/includes/azure-monitor/reference/tables/azmsvnetconnectionevents-include.md)]
