---
title: Reliability in Azure Monitor
description: Recommendations for configuring Azure Monitor to optimize reliability.
ms.topic: best-practice
ms.date: 05/21/2025
ms.reviewer: bwren
---

# Reliability best practices in Azure Monitor

In the cloud, we acknowledge that failures happen. Instead of trying to prevent failures altogether, the goal is to minimize the effects of a single failing component. Use the following information to monitor your virtual machines and their client workloads for failure.

This article describes [Reliability](/azure/architecture/framework/reliability/) for Azure Monitor as part of the [Azure Well-Architected Framework](/azure/architecture/framework/). The Azure Well-Architected Framework is a set of guiding tenets that can be used to improve the quality of a workload. The framework consists of five pillars of architectural excellence:

* Reliability
* Security
* Cost Optimization
* Operational Excellence
* Performance Efficiency

## Azure Monitor Logs

[!INCLUDE [waf-logs-reliability](../logs/includes/waf-logs-reliability.md)]

## Alerts

[!INCLUDE [waf-containers-reliability](../alerts/includes/waf-alerts-reliability.md)]

## Virtual machines

[!INCLUDE [waf-vm-reliability](../vm/includes/waf-vm-reliability.md)]

## Containers

[!INCLUDE [waf-containers-reliability](../containers/includes/waf-containers-reliability.md)]

## Next step

* Learn more about [getting started with Azure Monitor](getting-started.md).
