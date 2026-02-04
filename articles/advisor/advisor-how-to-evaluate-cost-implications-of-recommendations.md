---
title: Evaluate cost implications of recommendations
description: Evaluate cost implications of recommendations
ms.topic: how-to
ms.date: 10/20/2025

---

# Evaluate cost implications of recommendations

> [!NOTE]
> This feature is currently in preview. Features in preview are subject to change and may not be available in all regions. Microsoft makes no warranties, express or implied, with respect to the information provided.

## Overview

Advisor offers targeted recommendations designed to help optimize your workloads. However, determining the recommendations to implement can be challenging; particularly when the potential financial impact isn't immediately apparent. Uncertainty regarding potential cost increases can cause hesitation or result in missed opportunities to optimize workloads.

Understanding how suggested changes affect spending enables teams to prioritize actions, manage budgets efficiently, and plan for future growth with greater confidence.

Azure Advisor now provides qualitative cost indicators accompanied by clear descriptions of the factors that influence costs. The qualitative cost indicators are `High`, `Medium`, or `Low`. For selected recommendations, the cost implication label and description clarify how a proposed change has a significant, moderate, or minimal impact on spending. 

> [!NOTE]
> During the preview phase, only a subset of recommendations include cost implication labels and descriptions. This coverage may expand in future updates.

## What is included in the preview

### Qualitative cost indicators

Each supported recommendation includes a cost implication label and a description of factors that affects your costs. Factors that affect costs include changes in resource configuration, infrastructure requirements, or data transfer patterns. The estimates are qualitative; the actual cost increase varies based on your Microsoft agreement, subscription type, and usage patterns.

| Cost implication | Estimated cost increase | Detail |
|:--- |:--- |:--- |
| High | More than 100% | Significant cost increase expected. |
| Medium | 30% - 100% | Moderate cost increase expected. |
| Low | Up to 30% | Minimal cost impact is expected. |
| No cost impact | 0% | No change to current costs. |

In certain scenarios, the cost impact of a recommendation significantly varies due to factors such as SKU availability within a region, capacity constraints, and desired resiliency level. In these cases, the cost implication label may be presented as a range (for example, `Medium–High`) that indicates the actual cost impact is based on multiple variables specific to your environment.

### Metadata API

Cost implication data is available using metadata API and Azure Resource Graph, enabling integration with custom tools.

### Download as CSV

The downloadable CSV report now includes cost implication info along with descriptions of factors making it easier to analyze and share recommendations offline.

## How to use

1.  In the Azure portal, navigate to [Advisor](https://portal.azure.com/#view/Microsoft_Azure_Expert).

1.  In the left navigation menu, under **Recommendations**, select **Reliability**.

1.  Select the **Automated** tab.

1.  Next to each recommendation, look for the **Cost Implication** label.

1.  To view a detailed description of the expected cost impact, select a recommendation.

1.  Look for the **What factors can contribute to this cost**.

1.  Use the enhanced **Download as CSV** report for sharing or analyzing recommendations offline.

:::image alt-text="Screenshot of recommendation list in Azure Advisor." lightbox="./media/advisor-list.png" source="./media/advisor-list-preview.png" type="content":::

:::image alt-text="Screenshot of the Resiliency recommendation in Azure Advisor." lightbox="./media/advisor-resiliency-use-zone-supported.png" source="./media/advisor-resiliency-use-zone-supported-preview.png" type="content":::

### Limitations

*   Cost implications are defined at the recommendation level, not for individual resources.

*   Only selected recommendations include cost implication data during preview.

### Share feedback

The Advisor team welcomes your feedback for improving this feature. Use the Feedback button in the Azure portal for sharing your thoughts.

## Related articles

For more information about Azure Advisor, see the following articles.

*   [Recommendation Metadata API](/rest/api/advisor/recommendation-metadata "Recommendation Metadata | Resource Manager | Azure Advisor REST API | Microsoft Learn")
