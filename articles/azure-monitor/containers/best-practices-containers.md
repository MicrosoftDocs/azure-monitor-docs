---
title: Best practices for monitoring Kubernetes with Azure Monitor
description: Explore Azure Monitor best practices for Kubernetes clusters, including AKS and Azure Arc. Get guidance on reliability, security, cost, and performance.
ms.topic: best-practice
ms.date: 03/29/2023
ms.reviewer: bwren
ai-usage: ai-assisted

#customer intent: As a Kubernetes administrator, I want to understand best practices for monitoring my clusters with Azure Monitor so that I can ensure reliability, security, cost efficiency, and performance.

---

# Best practices for monitoring Kubernetes with Azure Monitor

Azure Monitor provides a [set of services](kubernetes-monitoring-overview.md) for monitoring the health and performance of your [Azure Kubernetes Service (AKS)](/azure/aks/intro-kubernetes) and [Azure Arc-enabled Kubernetes](/azure/azure-arc/kubernetes/overview) clusters. Without proper configuration, your monitoring setup might miss critical issues or collect unnecessary data, leading to gaps in visibility or increased costs.

This article provides best practices based on the five pillars of architecture excellence in the [Azure Well-Architected Framework](/azure/architecture/framework/) to help you configure reliable, secure, and cost-effective monitoring for your Kubernetes clusters.

## Reliability best practices for Kubernetes monitoring

Ensure the reliability of your Azure Kubernetes Service (AKS) and Azure Arc-enabled Kubernetes cluster monitoring by enabling Prometheus metrics, Container insights, control plane diagnostic settings, and alert rules. These recommendations help you detect and respond to failures in your cluster and its monitoring components.

[!INCLUDE [waf-containers-reliability](includes/waf-containers-reliability.md)]

## Security best practices for Kubernetes monitoring

Azure Monitor supports least privilege access and defense-in-depth for Kubernetes clusters. These security recommendations cover managed identity authentication, private link connectivity, network observability, and Log Analytics workspace security.

[!INCLUDE [waf-containers-security](includes/waf-containers-security.md)]

## Cost optimization for Kubernetes monitoring

Reduce your Azure Monitor costs for Kubernetes monitoring by optimizing data collection, configuring appropriate pricing tiers, and eliminating redundant metric collection. See [Azure Monitor cost and usage](../fundamentals/cost-usage.md) to learn how Azure Monitor charges and how to view your monthly bill.

> [!NOTE]
> See [Optimize costs in Azure Monitor](../fundamentals/best-practices-cost.md) for cost optimization recommendations across all features of Azure Monitor.

[!INCLUDE [waf-containers-cost](includes/waf-containers-cost.md)]

## Operational excellence for Kubernetes monitoring

Streamline the operational management of your Kubernetes cluster monitoring with Azure Monitor. These recommendations cover monitoring guidance for all Kubernetes layers, Azure Arc integration for hybrid clusters, managed cloud-native tools, and automated policy-based data collection.

[!INCLUDE [waf-containers-operation](includes/waf-containers-operation.md)]

## Performance efficiency for Kubernetes monitoring

Track Kubernetes cluster performance with Azure Monitor by enabling Prometheus metrics collection, Container insights, and performance alert rules. These recommendations help you identify performance bottlenecks and scale your clusters efficiently.

[!INCLUDE [waf-containers-performance](includes/waf-containers-performance.md)]

## Related content

- [Enable monitoring for Kubernetes clusters](kubernetes-monitoring-enable.md)
- [Getting started with Azure Monitor](../fundamentals/getting-started.md)
