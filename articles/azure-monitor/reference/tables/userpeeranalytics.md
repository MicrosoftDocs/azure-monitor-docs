---
title: Azure Monitor Logs reference - UserPeerAnalytics
description: Reference for UserPeerAnalytics table in Azure Monitor Logs.
ms.topic: reference
ms.service: azure-monitor
ms.subservice: logs
ms.author: orens
author: osalzberg
ms.date: 09/16/2024
---

# UserPeerAnalytics

This analytics table, for a given user, provides a ranked list of peers. For example, if the user is Jane Smith, Peer Analytics calculates all of Jane's peers based on her mailing list, security groups, etc and provides the top 20 of her peers.


## Table attributes

|Attribute|Value|
|---|---|
|**Resource types**|-|
|**Categories**|Security|
|**Solutions**| BehaviorAnalyticsInsights|
|**Basic log**|No|
|**Ingestion-time transformation**|No|
|**Sample Queries**|-|



## Columns
  
[!INCLUDE [userpeeranalytics](~/reusable-content/ce-skilling/azure/includes/azure-monitor/reference/tables/userpeeranalytics-include.md)]
