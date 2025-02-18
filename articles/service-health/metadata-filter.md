---
title: Use Event Level to prioritize notifications/communications
description: Information on how use the metadata to filter event notifications 
ms.topic: overview
ms.date: 02/14/2025
---
# Service Health Event Level filter notifications

## Overview
To assist users in prioritizing Service Health event communications, we are introducing a new field called "Event Level," which indicates the significance of each communication. This enhancement allows users to rapidly evaluate the importance of each alert. With this feature, clients can filter, and sort events based on this metadata, enabling them to prioritize their actions more effectively.

## Who can see the Metadata fields
Anyone who has access to the subscription can view and filter by Event Level.

## Event Level Alert definitions
### Event Level for Service Issues

|title|Definition|
|-----|-----|
|**Informational**|No current service availability impact, but possible future issues in a specific region.|
|**Warning**|Potential service issues in a region that could impact availability or performance if high availability or disaster recovery is not used, or the issue persists.|
|**Critical**|Immediate attention recommended. Widespread issues affecting multiple regions or services, risking failure of high availability or disaster recovery measures.|

>[!Tip] 
>You can filter by Metadata to see specific types using the 'Event Level' field.

>[!NOTE] 
>This is only available for Service Issues at this time. 

:::[new metada filter option](articles/service-health/media/metada-screen.png#lightbox):::