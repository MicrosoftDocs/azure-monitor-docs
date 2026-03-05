---
title: Quick Fix remediation for Advisor recommendations
description: Perform bulk remediation using Quick Fix in Advisor
ms.topic: how-to
ms.date: 12/02/2024
---

# Quick Fix remediation for Advisor

The **Quick Fix** feature provides a faster and easier way to remediate a recommendation on multiple resources. The **Quick Fix** feature allows you to used bulk remediations for resources. The **Quick Fix** feature helps you to quickly optimize and scale your subscription with remediation for your resources.

> [!NOTE]
> The **Quick Fix** feature is only available for specific recommendations using the Azure portal.

## Steps to use Quick Fix

1.  On the list of recommendations, select a recommendation with the **Quick Fix** label.

    :::image alt-text="Screenshot showing a list of recommendations with Quick Fix labels in Advisor." lightbox="./media/advisor-all-recommendations-label-quick-fix.png" source="./media/advisor-all-recommendations-label-quick-fix-preview.png" type="content":::

    > [!NOTE]
    > Prices in the image are only for example purposes.

1.  On the Recommendation details page, review the list of resources associated with the recommendation. Select all of the resources you want to remediate.

    :::image alt-text="Screenshot showing the Impacted resources window with list items and the highlighted Quick Fix button." lightbox="./media/quick-fix-2.png" source="./media/quick-fix-2.png" type="content":::

    > [!NOTE]
    > Prices in the image are only for example purposes.

1.  After you select one or more resources, select the **Quick Fix** button to bulk remediate.

    > [!NOTE]
    > If a listed resource is blocked or you are unable to select it, your appropriate permission level is too low to modify it.

    > [!NOTE]
    > If other implications exist beyond the benefits shown in Advisor, the experience informs and helps you make remediation decisions.

1.  After the remediation completes, a notification is sent to you. If a resource is in one of the following states, an error is shown:

    * Resource isn't remediated.
    * Resource is in the selected mode in the resource list view.

## Related articles

For more information about Azure Advisor, see the following articles.

*   [Introduction to Azure Advisor](./advisor-overview.md)

*   [Azure Advisor portal basics](./advisor-get-started.md)

*   [Use Advisor score](./azure-advisor-score.md)

*   [Azure Advisor REST API](/rest/api/advisor)

For more information about specific Advisor recommendations, see the following articles.

*   [Reliability recommendations](./advisor-reference-reliability-recommendations.md)

*   [Reduce service costs by using Azure Advisor](./advisor-reference-cost-recommendations.md)

*   [Performance recommendations](./advisor-reference-performance-recommendations.md)

*   [Review security recommendations](/azure/defender-for-cloud/review-security-recommendations "Review security recommendations | Defender for Cloud | Microsoft Learn")

*   [Operational excellence recommendations](./advisor-reference-operational-excellence-recommendations.md)
