---
title: Azure Monitor Logs reference - AMSKeyDeliveryRequests
description: Reference for AMSKeyDeliveryRequests table in Azure Monitor Logs.
ms.topic: reference
ms.service: azure-monitor
ms.subservice: logs
ms.author: orens
author: osalzberg
ms.date: 09/16/2024
---

# AMSKeyDeliveryRequests

Key delivery requests logs from Azure Media Services. This table captures details for every HTTP request for key or license acquisition sent to Azure Media Services. It can be used to monitor encrypted content playback, and to diagnose issues with DRM license acquisition or Clear Key acquisition.


## Table attributes

|Attribute|Value|
|---|---|
|**Resource types**|microsoft.media/mediaservices|
|**Categories**|Audit, Azure Resources|
|**Solutions**| LogManagement|
|**Basic log**|Yes|
|**Ingestion-time transformation**|No|
|**Sample Queries**|[Yes](/azure/azure-monitor/reference/queries/amskeydeliveryrequests)|



## Columns
  
[!INCLUDE [amskeydeliveryrequests](~/reusable-content/ce-skilling/azure/includes/azure-monitor/reference/tables/amskeydeliveryrequests-include.md)]
