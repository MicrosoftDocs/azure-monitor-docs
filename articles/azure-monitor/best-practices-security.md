---
title: Security in Azure Monitor
description: Guidelines for configuring Azure Monitor to optimize security.
ms.topic: conceptual
author: bwren
ms.author: bwren
ms.date: 03/12/2024
ms.reviewer: bwren
---

# Security guidelines for Azure Monitor

This article provides [Security](/azure/architecture/framework/security/) guidelines for Azure Monitor as part of the [Azure Well-Architected Framework](/azure/architecture/framework/). 

Azure Monitor security guidelines are: 

- Consistent with the the [Microsoft cloud security benchmark (MCSB)](/security/benchmark/azure/overview), which prescribes best practices to help improve the security of workloads, data, and services on Azure and your multi-cloud environment. 
- Based on the [five pillars of the Azure Well-Architected Framework](/azure/architecture/framework/), which are designed to help you build secure, high-performing, resilient, and efficient applications.
- Designed to help you understand the security features of Azure Monitor and how to configure them to optimize security for various aspects of monitoring.

## Log collection and storage

[!INCLUDE [waf-logs-reliability](includes/waf-logs-security.md)]

## Alerts

[!INCLUDE [waf-containers-reliability](includes/waf-alerts-security.md)]

## Virtual machine monitoring

[!INCLUDE [waf-vm-reliability](includes/waf-vm-security.md)]

## Container monitoring

[!INCLUDE [waf-containers-reliability](includes/waf-containers-security.md)]

## Next step

- [Get best practices for a complete deployment of Azure Monitor](best-practices.md).

