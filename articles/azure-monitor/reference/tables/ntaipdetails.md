---
title: Azure Monitor Logs reference - NTAIpDetails
description: Reference for NTAIpDetails table in Azure Monitor Logs.
ms.topic: reference
ms.service: azure-monitor
ms.subservice: logs
ms.author: orens
author: osalzberg
ms.date: 09/16/2024
---

# NTAIpDetails

Traffic Analytics provides WHOIS data and geographic location for all public IPs in the customer's environment. For Malicious IP, it provides DNS domain, threat type and thread descriptions as identified by Microsoft security intelligence solutions. IP Details are published to your Log Analytics Workspace so you can create custom queries and put alerts on them. You can also access pre-populated queries from the traffic analytics dashboard.


## Table attributes

|Attribute|Value|
|---|---|
|**Resource types**|-|
|**Categories**|Network|
|**Solutions**| LogManagement|
|**Basic log**|No|
|**Ingestion-time transformation**|Yes|
|**Sample Queries**|-|



## Columns
  
[!INCLUDE [ntaipdetails](~/reusable-content/ce-skilling/azure/includes/azure-monitor/reference/tables/ntaipdetails-include.md)]
