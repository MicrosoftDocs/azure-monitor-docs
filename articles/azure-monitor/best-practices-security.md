---
title: Security in Azure Monitor
description: Recommendations for configuring Azure Monitor to optimize security.
ms.topic: conceptual
author: bwren
ms.author: bwren
ms.date: 03/12/2024
ms.reviewer: bwren
---

# Security best practices in Azure Monitor

Security is one of the most important aspects of any architecture. Azure Monitor provides features to employ both the principle of least privilege and defense-in-depth. Use the following information to monitor the security of your virtual machines.

This article describes [Security](/azure/architecture/framework/security/) for Azure Monitor as part of the [Azure Well-Architected Framework](/azure/architecture/framework/). The Azure Well-Architected Framework is a set of guiding tenets that can be used to improve the quality of a workload. The framework consists of five pillars of architectural excellence:

- Reliability
- Security
- Cost Optimization
- Operational Excellence
- Performance Efficiency

## Azure Monitor Logs

[!INCLUDE [waf-logs-reliability](includes/waf-logs-security.md)]

## Alerts

[!INCLUDE [waf-containers-reliability](includes/waf-alerts-security.md)]

## Virtual machines

[!INCLUDE [waf-vm-reliability](includes/waf-vm-security.md)]

## Containers

[!INCLUDE [waf-containers-reliability](includes/waf-containers-security.md)]

## Next step

- [Get best practices for a complete deployment of Azure Monitor](best-practices.md).

