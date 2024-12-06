---
title: Quick Fix remediation for Advisor recommendations
description: Perform bulk remediation using Quick Fix in Advisor
ms.topic: article
ms.date: 09/26/2024
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

## Next steps

For more information about Azure Advisor, go to:

* [Introduction to Azure Advisor](./advisor-overview.md)
* [Azure Advisor portal basics](./advisor-get-started.md)
* [Azure Advisor REST API](/rest/api/advisor)

To learn more about specific Advisor recommendations, see:

* [Reliability](advisor-reference-reliability-recommendations.md)
* [Security](advisor-security-recommendations.md)
* [Performance](advisor-reference-performance-recommendations.md)
* [Cost](advisor-reference-cost-recommendations.md)
* [Operational excellence](advisor-reference-operational-excellence-recommendations.md)
