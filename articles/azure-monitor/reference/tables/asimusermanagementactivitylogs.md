---
title: Azure Monitor Logs reference - ASimUserManagementActivityLogs
description: Reference for ASimUserManagementActivityLogs table in Azure Monitor Logs.
ms.topic: reference
ms.service: azure-monitor
ms.subservice: logs
ms.author: orens
author: osalzberg
ms.date: 09/24/2024
---

# ASimUserManagementActivityLogs

The ASim User Management schema represents user management activities, such as creating a user or a group, changing user attribute, or adding a user to a group. Such events are reported, for example, by operating systems, directory services, identity management systems, and any other system reporting on its local user management activity.


## Table attributes

|Attribute|Value|
|---|---|
|**Resource types**|microsoft.securityinsights/asimtables|
|**Categories**|Security|
|**Solutions**| SecurityInsights|
|**Basic log**|No|
|**Ingestion-time transformation**|Yes|
|**Sample Queries**|-|



## Columns
  
[!INCLUDE [asimusermanagementactivitylogs](~/reusable-content/ce-skilling/azure/includes/azure-monitor/reference/tables/asimusermanagementactivitylogs-include.md)]
