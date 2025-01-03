---
title: Azure Monitor Logs reference - DnsAuditEvents
description: Reference for DnsAuditEvents table in Azure Monitor Logs.
ms.topic: reference
ms.service: azure-monitor
ms.subservice: logs
ms.author: orens
author: osalzberg
ms.date: 09/24/2024
---

# DnsAuditEvents

DNS server audit events enable change tracking on the DNS server. An audit event is logged each time server, zone, or resource record settings are changed. This includes operational events such as zone transfers, and DNSSEC zone signing and unsigning.  This table captures audit events that are not from dynamic updates.


## Table attributes

|Attribute|Value|
|---|---|
|**Resource types**|microsoft.securityinsights/securityinsights|
|**Categories**|Security|
|**Solutions**| SecurityInsights|
|**Basic log**|No|
|**Ingestion-time transformation**|No|
|**Sample Queries**|-|



## Columns
  
[!INCLUDE [dnsauditevents](~/reusable-content/ce-skilling/azure/includes/azure-monitor/reference/tables/dnsauditevents-include.md)]
