---
title: Azure Monitor Logs reference - AZKVAuditLogs
description: Reference for AZKVAuditLogs table in Azure Monitor Logs.
ms.topic: reference
ms.service: azure-monitor
ms.subservice: logs
ms.author: orens
author: osalzberg
ms.date: 09/16/2024
---

# AZKVAuditLogs

Audit logs can be used to monitor how and when your key vaults are accessed, and by whom. Customers will be able to log all authentication api requests. Operations on the key vault itself, including creation, deletion, setting key vault access policies, and updating key vault attributes such as tags.Operation on keys and secrets in keyvault including creating, deleting, signing.


## Table attributes

|Attribute|Value|
|---|---|
|**Resource types**|microsoft.keyvault/vaults|
|**Categories**|Azure Resources, Audit|
|**Solutions**| LogManagement|
|**Basic log**|Yes|
|**Ingestion-time transformation**|No|
|**Sample Queries**|[Yes](/azure/azure-monitor/reference/queries/azkvauditlogs)|



## Columns
  
[!INCLUDE [azkvauditlogs](~/reusable-content/ce-skilling/azure/includes/azure-monitor/reference/tables/azkvauditlogs-include.md)]
