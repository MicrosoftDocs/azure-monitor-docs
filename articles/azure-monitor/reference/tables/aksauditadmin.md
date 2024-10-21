---
title: Azure Monitor Logs reference - AKSAuditAdmin
description: Reference for AKSAuditAdmin table in Azure Monitor Logs.
ms.topic: reference
ms.service: azure-monitor
ms.subservice: logs
ms.author: orens
author: osalzberg
ms.date: 09/16/2024
---

# AKSAuditAdmin

Contains Kubernetes API Server audit logs excluding events with the get and list verbs. These events are useful for monitoring resource modification requests made to the Kubernetes API. To see all modifying and non-modifying operations see the AKSAudit table.


## Table attributes

|Attribute|Value|
|---|---|
|**Resource types**|microsoft.containerservice/managedclusters|
|**Categories**|Audit, Azure Resources, Containers|
|**Solutions**| LogManagement|
|**Basic log**|Yes|
|**Ingestion-time transformation**|No|
|**Sample Queries**|[Yes](/azure/azure-monitor/reference/queries/aksauditadmin)|



## Columns
  
[!INCLUDE [aksauditadmin](~/reusable-content/ce-skilling/azure/includes/azure-monitor/reference/tables/aksauditadmin-include.md)]
