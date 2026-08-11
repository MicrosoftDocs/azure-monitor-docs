---
title: Reliability in Azure Monitor
description: Recommendations for configuring Azure Monitor to optimize reliability.
ms.topic: best-practice
ms.date: 05/21/2025
ms.reviewer:
ai-usage: ai-assisted
---

# Reliability best practices in Azure Monitor

In the cloud, failures happen. Instead of trying to prevent failures altogether, minimize the effects of a single failing component. This article describes reliability recommendations for Azure Monitor Logs, alerts, virtual machines, and containers to keep monitoring and telemetry available when parts of a workload fail.

These recommendations apply the [Reliability pillar](/azure/well-architected/reliability/) of the [Azure Well-Architected Framework](/azure/well-architected/).

## Azure Monitor Logs

[!INCLUDE [waf-logs-reliability](../logs/includes/waf-logs-reliability.md)]

## Alerts

[!INCLUDE [waf-alerts-reliability](../alerts/includes/waf-alerts-reliability.md)]

## Virtual machines

Apply these recommendations to keep monitoring of your virtual machines and their client workloads available when a component fails.

[!INCLUDE [waf-vm-reliability](../vm/includes/waf-vm-reliability.md)]

## Containers

Apply these recommendations to keep monitoring of your container workloads available when a component fails.

[!INCLUDE [waf-containers-reliability](../containers/includes/waf-containers-reliability.md)]

## Next step

* Learn more in the [Azure Monitor overview](overview.md).
