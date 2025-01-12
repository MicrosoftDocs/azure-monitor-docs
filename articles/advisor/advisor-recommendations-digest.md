---
title: Recommendation digest for Azure Advisor
description: Get periodic summary for your active recommendations
ms.topic: article
ms.date: 11/01/2024

---

# Recommendation digests

Learn how to create a recommendation digest for your Advisor recommendations.

## Configure your recommendation digest

Recomendation digests provide an easy and proactive way to configure notifications that summarize a list of your active recommendations across multiple categories. Use one or more action groups to choose your desired channel for notifications like email, SMS, or others. To configure your recommendation digest, complete the following parameters.

| Parameter | Detail |
|:--- |:--- |
| Frequency | Frequency for the summary notification is weekly, bi-weekly, or monthly. |
| Recommendation Category | The recommendation categories include cost, operational excellence, performance, reliability, and security. |
| Language | Language for the digest. |
| Action Groups | Select either an existing action group or create a new action group. To learn more about action groups, see [Action groups](/azure/azure-monitor/alerts/action-groups "Action groups | Azure Monitor |  Microsoft Learn"). |
| Recommendation digest name | Use a user-friendly string to manage the digest. |

## Create a recommendation digest in Advisor

To create a recommendation digest, complete the following actions.

1.  On **Advisor** | **Overview**, on the menu for Advisor, select **Monitoring** > **Recommendation digests**.

    :::image alt-text="Screenshot of entry-point of a recommendation digest." lightbox="./media/advisor-overview-highlight-recommendation-digest.png" source="./media/advisor-overview-highlight-recommendation-digest-preview.png" type="content":::

1.  Select **Create recommendation digest**.

    :::image alt-text="Screenshot of New recommendation digest." lightbox="./media/advisor-recommendation-digest-highlight-new-recommendation-digest.png" source="./media/advisor-recommendation-digest-highlight-new-recommendation-digest-preview.png" type="content":::

1.  On **Add an Advisor recommendation digest** > **Scope**, in the drop-down menu next to **Subscription**, select the subscription for your digest.

    :::image alt-text="Screenshot of Scope input on Add an Advisor recommendation digest." lightbox="./media/add-an-advisor-recommendation-digest-highlight-scope.png" source="./media/add-an-advisor-recommendation-digest-highlight-scope-preview.png" type="content":::

1.  On **Add an Advisor recommendation digest** > **Condition**, complete the following actions.

    1.  In the drop-down menu next to **Frequency**, select how often you receive the notification for your digest.

    1.  In the drop-down menu next to **Recommendation Category**, select the category of your digest.

    1.  In the drop-down menu next to **Language**, select the language of your digest.

    :::image alt-text="Screenshot of Condition inputs on Add an Advisor recommendation digest." lightbox="./media/add-an-advisor-recommendation-digest-highlight-condition.png" source="./media/add-an-advisor-recommendation-digest-highlight-condition-preview.png" type="content":::

1.  On **Add an Advisor recommendation digest** >  **Action Groups**, select an existing **Action Group Name** or create a new action group for your digest. To learn more, see [Action groups](/azure/azure-monitor/alerts/action-groups "Action groups | Azure Monitor |  Microsoft Learn").

    :::image alt-text="Screenshot of Action Groups inputs on Add an Advisor recommendation digest." lightbox="./media/add-an-advisor-recommendation-digest-highlight-action-groups.png" source="./media/add-an-advisor-recommendation-digest-highlight-action-groups-preview.png" type="content":::

1.  On **Add an Advisor recommendation digest** > **Digest Details**, complete the following actions.

    1.  In the text box next to **Recommendation digest name**, enter the name of your digest.

    1.  Next to **Enable recommendation digest**, toggle the switch to activate your digest.

    :::image alt-text="Screenshot of Digest Details inputs on Add an Advisor recommendation digest." lightbox="./media/add-an-advisor-recommendation-digest-highlight-digest-details.png" source="./media/add-an-advisor-recommendation-digest-highlight-digest-details-preview.png" type="content":::

1.  Select **Create recommendation digest**.

## Manage digest

Your organization configures the recommendation digests. You must have access to the digest action group to modify the properties. The Subscription administrator manages your access.

To manage a digest after you create it, complete the actions in the following sections.

### Update digest

To edit your digest, complete the following actions.

On **Advisor** | **Recommendation digests**.

1.  Select the text in the column under the **Digest name** heading.

On **Edit Advisor recommendation digest** > **Condition**, update the following drop-down menus.

*   In the drop-down menu next to **Frequency**, select how often you receive the notification for your digest.

*   In the drop-down menu next to **Recommendation Category**, select the category of your digest.

*   In the drop-down menu next to **Language**, select the language of your digest.

On **Edit Advisor recommendation digest** >  **Action Groups**, update the following table.

*   Remove an existing **Action Group Name** and either select an existing **Action Group Name** or create a new action group for your digest. To learn more, see [Action groups](/azure/azure-monitor/alerts/action-groups "Action groups | Azure Monitor |  Microsoft Learn").

On **Edit Advisor recommendation digest** > **Digest Details**, update the following toggle switch.

*   Next to **Enable recommendation digest**, toggle the switch to activate or deactivate your digest.

On **Edit Advisor recommendation digest**

1.  Select **Save Changes**.

### Activate and deactivate digest

To deactivate or activate your digest, complete the following actions.

On **Advisor** | **Recommendation digests**.

1.  Select the checkbox next to name of the digest.

1.  To deactivate an active digest, select **Disable**.

    *   To activate an inactive digest, select **Enable**.

### Delete digest

After you delete a digest, restoration isn't an option and you must recreate the digest.

> [!NOTE]
> Unlike deactivation that is reversible; deletion is permanent.
>
> To reactivate an inactive digest, select **Enable**. A digest set to `Enable` restarts notification using email.

To delete your digest, complete the following actions.

On **Advisor** | **Recommendation digests**.

1.  Select the checkbox next to name of the digest.

1.  Select **Delete**.

On **Delete**.

1.  Select **Yes**.

## Related articles

For more information about Advisor recommendations, see the following articles.

*   [Introduction to Azure Advisor](./advisor-overview.md)

*   [Azure Advisor portal basics](./advisor-get-started.md)

*   [Azure Advisor REST API](/rest/api/advisor "Azure Advisor REST API | Microsoft Learn")
