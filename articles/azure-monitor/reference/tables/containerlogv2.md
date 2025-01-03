---
title: Azure Monitor Logs reference - ContainerLogV2
description: Reference for ContainerLogV2 table in Azure Monitor Logs.
ms.topic: reference
ms.service: azure-monitor
ms.subservice: logs
ms.author: orens
author: osalzberg
ms.date: 09/16/2024
---

# ContainerLogV2

Kubernetes Container logs in V2 schema. This is the successor of ContainerLog. This has a friendlier schema, specifically for Kubernetes orchestrated containers in pods. With this feature enabled, previously split container logs are stitched together and sent as single entries to the ContainerLogV2 table. The schema now supports container log lines of up to to 64 KB. The schema also supports .NET and Go stack traces, which appear as single entries.


## Table attributes

|Attribute|Value|
|---|---|
|**Resource types**|microsoft.containerservice/managedclusters,<br>microsoft.kubernetes/connectedclusters,<br>microsoft.hybridcontainerservice/provisionedclusters|
|**Categories**|Containers|
|**Solutions**| AzureResources, ContainerInsights|
|**Basic log**|Yes|
|**Ingestion-time transformation**|Yes|
|**Sample Queries**|[Yes](/azure/azure-monitor/reference/queries/containerlogv2)|



## Columns
  
[!INCLUDE [containerlogv2](~/reusable-content/ce-skilling/azure/includes/azure-monitor/reference/tables/containerlogv2-include.md)]
