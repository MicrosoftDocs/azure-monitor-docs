---
title: Azure Monitor Logs reference - SynapseDXSucceededIngestion
description: Reference for SynapseDXSucceededIngestion table in Azure Monitor Logs.
ms.topic: reference
ms.service: azure-monitor
ms.subservice: logs
ms.author: orens
author: osalzberg
ms.date: 09/16/2024
---

# SynapseDXSucceededIngestion

Succeeded ingestion operations logs provide information about successfully completed ingest operations. Logs include data source details that together with `Failed ingestion operations` logs can be used for tracking the process of ingestion of each data source. Ingestion logs are supported for queued ingestion to the ingestion endpoint using SDKs, data connections, and connectors


## Table attributes

|Attribute|Value|
|---|---|
|**Resource types**|microsoft.synapse/workspaces|
|**Categories**|Azure Resources|
|**Solutions**| LogManagement|
|**Basic log**|No|
|**Ingestion-time transformation**|Yes|
|**Sample Queries**|-|



## Columns
  
[!INCLUDE [synapsedxsucceededingestion](~/reusable-content/ce-skilling/azure/includes/azure-monitor/reference/tables/synapsedxsucceededingestion-include.md)]
