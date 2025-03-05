---
title: Operational excellence in Azure Monitor
description: Recommendations for configuring Azure Monitor for operational excellence.
ms.topic: conceptual
ms.date: 03/12/2024
ms.reviewer: bwren
---

# Operational excellence best practices in Azure Monitor

Operational excellence refers to operations processes required keep a service running reliably in production. Use the following information to minimize the operational requirements for monitoring of your virtual machines.

This article describes [Operational excellence](/azure/architecture/framework/security/) for Azure Monitor as part of the [Azure Well-Architected Framework](/azure/architecture/framework/). The Azure Well-Architected Framework is a set of guiding tenets that can be used to improve the quality of a workload. The framework consists of five pillars of architectural excellence:

- Reliability
- Security
- Cost Optimization
- Operational Excellence
- Performance Efficiency

## Azure Monitor Logs

[!INCLUDE [waf-logs-reliability](includes/waf-logs-operation.md)]

## Alerts

[!INCLUDE [waf-containers-reliability](includes/waf-alerts-operation.md)]

## Virtual machines

[!INCLUDE [waf-vm-reliability](includes/waf-vm-operation.md)]

## Containers

[!INCLUDE [waf-containers-reliability](includes/waf-containers-operation.md)]

## Next step

- [Get best practices for a complete deployment of Azure Monitor](best-practices.md).

