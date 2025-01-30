---
title: Azure Monitor Logs reference - TOUserDiagnostics
description: Reference for TOUserDiagnostics table in Azure Monitor Logs.
ms.topic: reference
ms.service: azure-monitor
ms.subservice: logs
ms.author: orens
author: osalzberg
ms.date: 01/27/2025
---

# TOUserDiagnostics

Contains all Toolchain orchestrator API Server user diagnostics logs. These events are useful for diagnose failed requests on Toolchain orchestrator. Requires Diagnostic Settings to use the Resource Specific destination table.


## Table attributes

|Attribute|Value|
|---|---|
|**Resource types**|microsoft.toolchainorchestrator/diagnostics|
|**Categories**|Azure Resources|
|**Solutions**| LogManagement|
|**Basic log**|No|
|**Ingestion-time transformation**|No|
|**Sample Queries**|[Yes](/azure/azure-monitor/reference/queries/touserdiagnostics)|



## Columns
  
[!INCLUDE [touserdiagnostics](~/reusable-content/ce-skilling/azure/includes/azure-monitor/reference/tables/touserdiagnostics-include.md)]
