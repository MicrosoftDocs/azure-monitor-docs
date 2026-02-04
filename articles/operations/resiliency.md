---
title: Resiliency in Operations center (preview)
description: Describes the Resiliency menu in Operations center, which provides an aggregated view of resiliency across computers, containers, data, storage, and networking resources.
ms.topic: concept-article
ms.date: 11/14/2025
---


# Resiliency in Operations center (preview)

[!INCLUDE [Preview-register](./includes/preview-register.md)]

The **Resiliency** menu in [Operations center](./overview.md) provides an aggregated view of resiliency across virtual machines, containers, data, storage, and networking resources. It helps you with the following tasks::

- Assign zonal resiliency goals for critical applications.
- View summaries of zonal resiliency configuration across your resource and application estate.
- Receive recommendations to improve your resiliency posture and align with Azure best practices to minimize downtime and risk.


The Resiliency menu uses the following Azure services:
- [Resiliency](/azure/resiliency/resiliency-overview)
- [Azure Advisor](/azure/advisor/advisor-overview)

## Menu items
The Resiliency menu includes the following menu items:

| Menu | Description |
|:---|:---|
| Resiliency | Summary of resiliency recommendations. See [Resiliency overview](#resiliency-overview) for details. |
| Resource resiliency | Aggregated view of the resiliency status of your resources across virtual machines, containers, data, storage, and networking. Identify resources may be at risk and take proactive measures to enhance their resiliency. |
| Service group resiliency | Listing of all service groups in your subscriptions identifying the resiliency status of the resources in each group. Assign resiliency goals to each  |
| Backup + recovery | Use [Resiliency in Azure](/azure/resiliency/resiliency-overview) to manage your protection estate across solutions and environments. The tabs across the top of this view correspond to menu items in the **Resiliency** menu. |
| Recommendations | Azure Advisor recommendations related to resiliency. See [Azure Advisor portal basics](/azure/advisor/advisor-get-started) for details. |

## Resiliency overview
The **Resiliency** overview page provides a summary of your zone resiliency posture and associated recommendations. It includes a single-pane snapshot of the resiliency status for your resources and service groups, summarizing key information from other pages in the Resiliency menu. 

Modify the scope of tiles by selecting any of the filters at the top of the page. Drill down on any of the tiles to open other pages in the Resiliency menu for more details.

:::image type="content" source="./media/resiliency/resiliency-menu.png" lightbox="./media/resiliency/resiliency-menu.png" alt-text="Screenshot of Resiliency menu in the Azure portal":::


The Resiliency overview page includes the following sections. 

| Section | Description |
|:---|:---|
| Top actions | Combination of recommended actions based on Azure Advisor recommendations and suggested actions from the [Resiliency agent](/azure/copilot/resiliency-agent). Click on any of these actions to open the relevant page in the Resiliency menu or to open the Resiliency agent for guided assistance. |
| Resource resiliency | Count of resources that have been configured with a zone resiliency solution and those for which the zone resiliency wasn't detected. |
| Service group resiliency | Count of service groups with different resiliency statuses for their contained resources. |
| Optimization recommendations | Displays the top Advisor recommendations for resiliency. See [Azure Advisor portal basics](/azure/advisor/advisor-get-started) for details. |

## Next steps
- Learn more about [operations center](./overview.md)