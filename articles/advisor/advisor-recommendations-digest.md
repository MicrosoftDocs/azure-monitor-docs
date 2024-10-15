---
title: Recommendation digest for Azure Advisor
description: Get periodic summary for your active recommendations
ms.topic: article
ms.date: 10/14/2024

---

# Recommendation digest for Azure Advisor

Learn how to create a recommendation digest for your Advisor recommendations.

## Configure periodic summary for recommendations

A recommendation digest provides an easy and proactive way to configure and schedule notifications that summarize a list of your active recommendations across multiple categories. Use one or more action groups to choose your desired channel for notifications like email, sms, or others.

## Configure your recommendation digest

The recommendation digest creation experience helps you configure the summary. To configure your recommendation digest, complete the following parameters.

| Parameter | Detail |
|:--- |:--- |
| Frequency | Frequency for the summary notification is weekly, bi-weekly, or monthly. |
| Recommendation Category | The recommendation categories include cost, high availability, performance, operational excellence, and security. |
| Language | Language for the digest. |
| Action Groups | Select either an existing action group or create a new action group. To learn more about action groups, see [Action groups](../azure-monitor/alerts/action-groups.md "Action groups \| Azure Monitor \| Microsoft Learn"). |
| Recommendation digest name | Use a user-friendly string to better track and monitor the digests. |

## Create a recommendation digest in Advisor

To create a recommendation digest, complete the following actions.

1.  On **Advisor** | **Overview**, on the menu for Advisor, select **Monitoring** > **Recommendation digests**.

    :::image alt-text="Screenshot of entry-point of a recommendation digest." lightbox="./media/advisor-overview-highlight-recommendation-digest.png" source="./media/advisor-overview-highlight-recommendation-digest-preview.png" type="content":::

1.  Select **New recommendation digest**.

    :::image alt-text="Screenshot of New recommendation digest." lightbox="./media/advisor-recommendation-digest-highlight-new-recommendation-digest.png" source="./media/advisor-recommendation-digest-highlight-new-recommendation-digest-preview.png" type="content":::

1.  On **Add an Advisor recommendation digest** > **Scope**, in the drop-down menu next to **Subscription**, select the subscription of your digest.

    :::image alt-text="Screenshot of Scope input on Add an Advisor recommendation digest." lightbox="./media/add-an-advisor-recommendation-digest-highlight-scope.png" source="./media/add-an-advisor-recommendation-digest-highlight-scope-preview.png" type="content":::

1.  On **Add an Advisor recommendation digest** > **Condition**, complete the following actions.

    1.  In the drop-down menu next to **Frequency**, select how often you receive the notification for your digest.

    1.  In the drop-down menu next to **Recommendation Category**, select the category of your digest.

    1.  In the drop-down menu next to **Language**, select the language of your digest.

    :::image alt-text="Screenshot of Condition inputs on Add an Advisor recommendation digest." lightbox="./media/add-an-advisor-recommendation-digest-highlight-condition.png" source="./media/add-an-advisor-recommendation-digest-highlight-condition-preview.png" type="content":::

1.  On **Add an Advisor recommendation digest** >  **Action Groups**, select an existing **Action Group Name** or create a new action group for your digest. To learn more, see [Action groups](../azure-monitor/alerts/action-groups.md "Action groups | Azure Monitor | Microsoft Learn").

    :::image alt-text="Screenshot of Action Groups inputs on Add an Advisor recommendation digest." lightbox="./media/add-an-advisor-recommendation-digest-highlight-action-groups.png" source="./media/add-an-advisor-recommendation-digest-highlight-action-groups-preview.png" type="content":::

1.  On **Add an Advisor recommendation digest** > **Digest Details**, complete the following actions.

    1.  In the text box next to **Recommendation digest name**, enter the name of your digest.

    1.  Next to **Enable recommendation digest**, toggle the switch to activate your digest.

    :::image alt-text="Screenshot of Digest Details inputs on Add an Advisor recommendation digest." lightbox="./media/add-an-advisor-recommendation-digest-highlight-digest-details.png" source="./media/add-an-advisor-recommendation-digest-highlight-digest-details-preview.png" type="content":::

1.  Select **Create recommendation digest**.

## Related articles

For more information about Advisor recommendations, see the following articles.

*   [Introduction to Azure Advisor](./advisor-overview.md "Introduction to Azure Advisor | Azure Advisor | Microsoft Learn")

*   [Azure Advisor portal basics](./advisor-get-started.md "Azure Advisor portal basics | Azure Advisor | Microsoft Learn")

*   [Azure Advisor REST API](/rest/api/advisor "Azure Advisor REST API | Microsoft Learn")
