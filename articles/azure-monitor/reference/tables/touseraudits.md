---
title: Azure Monitor Logs reference - TOUserAudits
description: Reference for TOUserAudits table in Azure Monitor Logs.
ms.topic: reference
ms.service: azure-monitor
ms.subservice: logs
ms.author: orens
author: osalzberg
ms.date: 01/27/2025
---

# TOUserAudits

Contains all Toolchain orchestrator API Server audit logs including the events generated as a result of interactions with any external system or toolchain. These events are useful for monitoring all the interactions with the Toolchain orchestrator API server and between Toolchain orchestrator and external orchestrated targets, e.g. Kubernetes. Requires Diagnostic Settings to use the Resource Specific destination table.


## Table attributes

|Attribute|Value|
|---|---|
|**Resource types**|microsoft.toolchainorchestrator/diagnostics|
|**Categories**|Audit, Azure Resources|
|**Solutions**| LogManagement|
|**Basic log**|No|
|**Ingestion-time transformation**|No|
|**Sample Queries**|[Yes](/azure/azure-monitor/reference/queries/touseraudits)|



## Columns
  
[!INCLUDE [touseraudits](~/reusable-content/ce-skilling/azure/includes/azure-monitor/reference/tables/touseraudits-include.md)]
