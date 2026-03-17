---
# Required metadata
# For more information, see https://learn.microsoft.com/en-us/help/platform/learn-editor-add-metadata
# For valid values of ms.service, ms.prod, and ms.topic, see https://learn.microsoft.com/en-us/help/platform/metadata-taxonomies

title: Azure Advisor recommendation state management
description: This article describes azure advisor recommendation state management and provides you with methods for use.
author:      zucatihal # GitHub alias
ms.author:   v-zucatihal # Microsoft alias
ms.service: azure-advisor
ms.topic: how-to
ms.date:     03/17/2026
ms.reviewer: tiffanywang, adaga
---

# Azure Advisor recommendation state management


Lorem Ipsum Article Description. 

## Heading 2

Lorem Ipsum Heading 2 Content

## Heading 2 Procedure Title

Heading 2 Procedure Intro Sentence

1. Sign in to the [**Azure portal**](https://portal.azure.com).

1. Search for and select [**Advisor**](https://aka.ms/azureadvisordashboard) from any page.\
The Advisor **Overview** page opens.

1. Export cost recommendations by navigating to the **Cost** tab on the left navigation menu and choosing **Download as CSV**.

1. Use the cost savings amount for each recommendation to calculate aggregated potential yearly savings.

    [![Screenshot of the Azure Advisor cost recommendations page that shows download option.](./media/advisor-how-to-calculate-total-cost-savings.png)](./media/advisor-how-to-calculate-total-cost-savings.png#lightbox)

> [!NOTE]
> Different types of cost savings recommendations are generated using overlapping datasets (for example, VM rightsizing/shutdown, VM reservations and savings plan recommendations all consider on-demand VM usage). As a result, resource changes (e.g., VM shutdowns) or reservation/savings plan purchases will impact on-demand usage, and the resulting recommendations and associated savings forecast. 

