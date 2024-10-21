---
title: Azure Monitor Logs reference - OLPSupplyChainEntityOperations
description: Reference for OLPSupplyChainEntityOperations table in Azure Monitor Logs.
ms.topic: reference
ms.service: azure-monitor
ms.subservice: logs
ms.author: orens
author: osalzberg
ms.date: 09/16/2024
---

# OLPSupplyChainEntityOperations

The OLPSupplyChainEntityOperations table captures every data plane operation performed on a supplychain entity in the workspace. Data Plane requests are operations executed to create, update, delete or retrieve supplychain entities such as Warehouse, Item, DeliveryNode, Shipment etc. within a workspace.


## Table attributes

|Attribute|Value|
|---|---|
|**Resource types**|microsoft.openlogisticsplatform/workspaces|
|**Categories**|Azure Resources|
|**Solutions**| LogManagement|
|**Basic log**|No|
|**Ingestion-time transformation**|No|
|**Sample Queries**|[Yes](/azure/azure-monitor/reference/queries/olpsupplychainentityoperations)|



## Columns
  
[!INCLUDE [olpsupplychainentityoperations](~/reusable-content/ce-skilling/azure/includes/azure-monitor/reference/tables/olpsupplychainentityoperations-include.md)]
