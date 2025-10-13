---
title: Evaluate cost implications of recommendations
description: Evaluate cost implications of recommendations
ms.topic: how-to
ms.date: 10/13/2025

---

# Evaluate cost implications of recommendations

> [!NOTE]
> This feature is currently in preview. Features in preview are subject to change and may not be available in all regions. Microsoft makes no warranties, express or implied, with respect to the information provided.

## Overview

Making well-informed decisions about cloud resources relies heavily on understanding the financial impact of recommended changes. Uncertainty regarding potential cost increases can cause hesitation or result in missed opportunities to optimize workloads. Having clear visibility into how recommendations may affect spending empowers teams to prioritize actions, manage budgets effectively, and confidently plan for future growth.

The new preview feature in Azure Advisor helps address this need by providing qualitative cost indicators - High, Medium, or Low - along with clear descriptions of the factors that influence costs. For selected recommendations, these cost implication labels and explanations clarify whether a proposed change is likely to have a high, medium, or low impact on spending. This enhancement reduces uncertainty, enabling teams to make more informed decisions and better balance reliability, performance, and cost.

> [!NOTE]
> During the preview phase, only a subset of recommendation types will include cost implication labels and descriptions. This coverage may expand in future updates.

## What's included in the preview

### Qualitative cost indicators

Each supported recommendation includes a Cost Implication label and a description of factors that may affect your costs. The estimates are qualitative, and actual cost increase may vary based on your Microsoft agreement, subscription type, and usage patterns.

| Label | Estimated cost increase | Detail |
|:--- |:--- |:--- |
| High | More than 100% | Significant cost increase expected. |
| Medium | 30% - 100% | Moderate cost increase expected. |
| Low | Up to 30% | Minimal cost impact is expected. |
| No cost impact | 0% | No change to current costs. |

Factors that may affect costs include changes in resource configuration, infrastructure requirements, or data transfer patterns. In certain scenarios, the cost impact of a recommendation varies significantly due to factors such as SKU availability within a region, capacity constraints, and desired resiliency level. In these cases, the cost implication label may be presented as a range (for example, Medium–High), indicating that the actual cost impact depends on multiple variables specific to your environment.

### Metadata API

Cost implication data is available via metadata API and Azure Resource Graph, enabling integration with custom tools.

### Download as CSV

The downloadable CSV export now includes:

*   Cost implication labels

*   Descriptions of expected changes

This makes it easier to analyze and share recommendations offline.

## How to use

1.  Navigate to Advisor in the Azure portal.

1.  Select Reliability under Recommendations in the left navigation menu.

1.  Select the Automated tab.

1.  Look for the **Cost Implication** label next to each recommendation.

1.  Select a recommendation to view a detailed description of the expected cost impact.

1.  Look for the **Description of factors that might impact your costs**.

1.  Use the enhanced **Download as CSV report** to share or analyze recommendations offline.

:::image alt-text="Screenshot of recommendation list in Azure Advisor." lightbox="./media/advisor-list.png" source="./media/advisor-list-preview.png" type="content":::

:::image alt-text="Screenshot of the Resiliency recommendation in Azure Advisor." lightbox="./media/advisor-resiliency-use-zone-supported.png" source="./media/advisor-resiliency-use-zone-supported-preview.png" type="content":::

### Limitations

*   Cost implications are defined at the recommendation type level, not for individual resources.

*   Only selected recommendations include cost implication data during preview.

### Share feedback

We welcome your feedback to improve this feature. Use the Feedback button in the Azure portal to share your thoughts.

## Related articles

For more information about Azure Advisor, see the following articles.

*   [Introduction to Azure Advisor](./advisor-overview.md "Introduction to Azure Advisor | Azure Advisor | Microsoft Learn")

*   [Azure Advisor portal basics](./advisor-get-started.md "Azure Advisor portal basics | Azure Advisor | Microsoft Learn")

*   [Use Advisor score](./azure-advisor-score.md "Use Advisor score | Azure Advisor | Microsoft Learn")

*   [Service Retirement workbook](./advisor-workbook-service-retirement.md "Service Retirement workbook | Azure Advisor | Microsoft Learn")

For more information about specific Advisor recommendations, see the following articles.

*   [Reliability recommendations](./advisor-reference-reliability-recommendations.md "Reliability recommendations | Azure Advisor | Microsoft Learn")

*   [Cost recommendations](./advisor-reference-cost-recommendations.md "Cost recommendations | Azure Advisor | Microsoft Learn")

*   [Performance recommendations](./advisor-reference-performance-recommendations.md "Performance recommendations | Azure Advisor | Microsoft Learn")

*   [Review security recommendations](/azure/defender-for-cloud/review-security-recommendations "Review security recommendations | Defender for Cloud | Microsoft Learn")

*   [Operational excellence recommendations](./advisor-reference-operational-excellence-recommendations.md "Operational excellence recommendations | Azure Advisor | Microsoft Learn")
