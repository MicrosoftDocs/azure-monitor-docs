---
title: Azure Monitor Logs reference - ArcK8sAudit
description: Reference for ArcK8sAudit table in Azure Monitor Logs.
ms.topic: reference
ms.service: azure-monitor
ms.subservice: logs
ms.author: orens
author: osalzberg
ms.date: 09/16/2024
---

# ArcK8sAudit

Contains all Kubernetes API Server audit logs including events with the get and list verbs. These events are useful for monitoring all of the interactions with the Kubernetes API. To limit the scope to modifying operations see the ArcK8sAuditAdmin table. Requires Diagnostic Settings to use the Resource Specific destination table.


## Table attributes

|Attribute|Value|
|---|---|
|**Resource types**|microsoft.kubernetes/connectedclusters|
|**Categories**|Audit, Azure Resources, Containers|
|**Solutions**| LogManagement|
|**Basic log**|Yes|
|**Ingestion-time transformation**|No|
|**Sample Queries**|-|



## Columns
  
[!INCLUDE [arck8saudit](~/reusable-content/ce-skilling/azure/includes/azure-monitor/reference/tables/arck8saudit-include.md)]
