---
title: Azure Monitor Logs reference - AZFWNatRule
description: Reference for AZFWNatRule table in Azure Monitor Logs.
ms.topic: reference
ms.service: azure-monitor
ms.subservice: logs
ms.author: orens
author: osalzberg
ms.date: 09/16/2024
---

# AZFWNatRule

Contains all DNAT (Destination Network Address Translation) events log data. Each match between data plane and DNAT rule creates a log entry with the data plane packet and the matched rule's attributes.

Azure Firewall logs DNAT rule matches in the AZFWNatRule table. Only traffic that successfully matches a DNAT rule is logged. If a connection does not match any DNAT rule, it will not be recorded in the AZFWNatRule table.


## Table attributes

|Attribute|Value|
|---|---|
|**Resource types**|microsoft.network/azurefirewalls|
|**Categories**|Security|
|**Solutions**| LogManagement|
|**Basic log**|No|
|**Ingestion-time transformation**|No|
|**Sample Queries**|[Yes](/azure/azure-monitor/reference/queries/azfwnatrule)|



## Columns
  
[!INCLUDE [azfwnatrule](~/reusable-content/ce-skilling/azure/includes/azure-monitor/reference/tables/azfwnatrule-include.md)]
