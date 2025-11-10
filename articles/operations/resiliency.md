---
title: Resiliency in Operations center (preview)
description: Describes the Resiliency pillar in Operations center, which provides an aggregated view of resiliency across computers, containers, data, storage, and networking resources.
ms.topic: conceptual
ms.date: 09/24/2025
---


# Resiliency in Operations center (preview)

[!INCLUDE [Preview-register](./includes/preview-register.md)]

The **Resiliency** pillar in [Operations center](./overview.md) provides an aggregated view of resiliency across computers, containers, data, storage, and networking resources. It helps you with the following tasks::

- Assign zonal resiliency goals for critical applications.
- View summaries of zonal resiliency configuration across your resource and application estate.
- Receive recommendations to improve your resiliency posture and align with Azure best practices to minimize downtime and risk.


The Resiliency pillar uses the following Azure services:
- [Azure Business Continuity Center](/azure/business-continuity-center/business-continuity-center-overview)
- [Azure Advisor](/azure/advisor/advisor-overview)

## Menu items

:::image type="content" source="./media/resiliency/resiliency-pillar.png" lightbox="./media/resiliency/resiliency-pillar.png" alt-text="Screenshot of Resiliency menu in the Azure portal":::

| Menu | Description |
|:---|:---|
| Resiliency | Overview of XXX recommendations. See [Resiliency overview](#resiliency-overview) for details. |
| Resource resiliency | Listing of all resources in your subscriptions identifying which are configured for resiliency. |
| Service group resiliency | Listing of all service groups in your subscriptions identifying which are configured for resiliency. |
| Backup + recovery | Use [Azure Business Continuity Center](/azure/business-continuity-center/business-continuity-center-overview) to manage your protection estate across solutions and environments. The tabs across the top of this view correspond to menu items in the **Business Continuity Center** menu. |
| Recommendations | Azure Advisor recommendations related to resiliency. |

## Resiliency overview
The Resiliency overview page provides a single-pane snapshot of the resiliency status for your resources and service groups, summarizing key information from other pages in the Resiliency pillar. The **Top actions** section provides recommendations for actions to take to optimize your resources. Modify the scope of tiles by selecting any of the filters at the top of the page.

Drill down on any of the tiles to open other pages in the Resiliency pillar for more details.

:::image type="content" source="./media/resiliency/resiliency-pillar.png" lightbox="./media/resiliency/resiliency-pillar.png" alt-text="Screenshot of Resiliency menu in the Azure portal":::


The Resiliency overview page includes the following sections. 

| Section | Description |
|:---|:---|
| Top actions | Surfaces the most impactful and actionable recommendations to maximize cost and carbon savings. This is a unified and prioritized list across Cost recommendations and Cost alerts so you can immediately identify where to focus your attention. Some of these actions may open the [Resiliency agent](#resiliency-agent) which allows you to interact with Azure Copilot to act on the recommendation. |
| Cost and carbon emissions summary | Summarizes the data from the previous month and forecasts the next month for all selected subscriptions and the top contributing subscriptions. Drill into any of these views to open other pages in the Optimization pillar for additional details. |
| Optimization recommendations | Displays the top Advisor recommendations for resiliency.  |



## Resource resiliency

The **Resource resiliency** page provides an aggregated view of the resiliency status of your resources across computers, containers, data, storage, and networking. It helps you identify resources that may be at risk and take proactive measures to enhance their resiliency.