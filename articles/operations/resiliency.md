---
title: Resiliency in Azure Operations Center (preview)
description: Describes the Resiliency pillar in Azure Operations Center, which provides an aggregated view of resiliency across computers, containers, data, storage, and networking resources.
ms.topic: conceptual
ms.date: 09/24/2025
---


# Resiliency in Azure Operations Center (preview)

The **Resiliency** pillar in [Azure operations center](./overview.md) provides an aggregated view of resiliency across computers, containers, data, storage, and networking resources. It helps you with the following tasks::

- Understand zonal availability to keep workloads online during failures.
- Validate recovery readiness through checks that predict failover success.
- Align with Azure resiliency best practices to minimize downtime and risk.

The Resiliency pillar uses the following Azure services:
- [Azure Business Continuity Center](/azure/business-continuity-center/business-continuity-center-overview)
- [Azure Advisor](/azure/advisor/advisor-overview)

## Menu items

:::image type="content" source="./media/resiliency/resiliency-pillar.png" lightbox="./media/resiliency/resiliency-pillar.png" alt-text="Screenshot of Resiliency menu in the Azure portal":::

| Menu | Description |
|:---|:---|
| Resiliency |  |
| Resource resiliency | Listing of all resources in your subscriptions identifying which are configured for resiliency. |
| Service group resiliency | Listing of all service groups in your subscriptions identifying which are configured for resiliency. |
| Backup + recovery | Use [Azure Business Continuity Center](/azure/business-continuity-center/business-continuity-center-overview) to manage your protection estate across solutions and environments. The tabs across the top of this view correspond to menu items in the **Business Continuity Center** menu. |
| Recommendations | Azure Advisor recommendations related to resiliency. |

## Resiliency overview
The resiliency overview page provides a single-pane snapshot of the resiliency status for your resources and service groups, summarizing key information from other pages in the Resiliency pillar. The **Top actions** section provides recommendations for actions to take to optimize your resources. Some of these actions may open the [Optimize agent](#optimize-agent) for guided assistance.

Drill down on any of the tiles to open other pages in the Optimization pillar for more details.

:::image type="content" source="./media/resiliency/resiliency-pillar.png" lightbox="./media/resiliency/resiliency-pillar.png" alt-text="Screenshot of Resiliency menu in the Azure portal":::

## Resource resiliency

The **Resource resiliency** page provides an aggregated view of the resiliency status of your resources across computers, containers, data, storage, and networking. It helps you identify resources that may be at risk and take proactive measures to enhance their resiliency.