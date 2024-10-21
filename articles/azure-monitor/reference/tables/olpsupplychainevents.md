---
title: Azure Monitor Logs reference - OLPSupplyChainEvents
description: Reference for OLPSupplyChainEvents table in Azure Monitor Logs.
ms.topic: reference
ms.service: azure-monitor
ms.subservice: logs
ms.author: orens
author: osalzberg
ms.date: 09/16/2024
---

# OLPSupplyChainEvents

The events table captures every event that was dispatched from the Open Logistics Platform workspace. Events can be a result of a data plane API call (e.g. Shipment Created, Item Deleted, Notification sent, etc.) or a long running job operation completion (e.g. Data ingestion results in NewDataAvailable event).


## Table attributes

|Attribute|Value|
|---|---|
|**Resource types**|microsoft.openlogisticsplatform/workspaces|
|**Categories**|Azure Resources|
|**Solutions**| LogManagement|
|**Basic log**|No|
|**Ingestion-time transformation**|No|
|**Sample Queries**|-|



## Columns
  
[!INCLUDE [olpsupplychainevents](~/reusable-content/ce-skilling/azure/includes/azure-monitor/reference/tables/olpsupplychainevents-include.md)]
