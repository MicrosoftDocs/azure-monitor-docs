---
title: Recommendation digest for Azure Advisor
description: Get periodic summary for your active recommendations
ms.topic: article
ms.date: 03/18/2025

---

# Recommendation digest

Learn how to create a recommendation digest for your Advisor recommendations.

## Configure your recommendation digest

A recommendation digest provides an easy and proactive way to configure notifications that summarize a list of your active recommendations across multiple categories. Use one or more action groups to choose your desired channel for notifications like email, SMS, or others. To configure your recommendation digest, complete the following parameters.

| Parameter | Detail |
|:--- |:--- |
| Frequency | Frequency for the summary notification is weekly, bi-weekly, or monthly. |
| Recommendation Category | The recommendation categories include cost, operational excellence, performance, reliability, and security. |
| Language | Language for the digest. |
| Action Groups | Select either an existing action group or create a new action group. <br /> To learn more about action groups, see [Action groups](/azure/azure-monitor/alerts/action-groups "Action groups \| Azure Monitor \| Microsoft Learn"). |
| Recommendation digest name | Use a user-friendly string to manage the digest. |

## Create a recommendation digest

To create a recommendation digest, complete the following actions.

1.  In **Advisor**, select **Monitoring** > **Recommendation digests**.

1.  On **Advisor** | **Recommendation digests**, select **Create recommendation digest**.

    :::image alt-text="Screenshot of New recommendation digest." lightbox="./media/advisor-recommendation-digest-highlight-new-recommendation-digest.png" source="./media/advisor-recommendation-digest-highlight-new-recommendation-digest-preview.png" type="content":::

1.  On **Add an Advisor recommendation digest** > **Scope**, in the drop-down menu next to **Subscription**, select the subscription for your digest.

    :::image alt-text="Screenshot of Scope input on Add an Advisor recommendation digest." lightbox="./media/add-an-advisor-recommendation-digest-highlight-scope.png" source="./media/add-an-advisor-recommendation-digest-highlight-scope-preview.png" type="content":::

1.  On **Add an Advisor recommendation digest** > **Condition**.

    1.  In the drop-down menu next to **Frequency**, select how often you receive the notification for your digest.

    1.  In the drop-down menu next to **Recommendation Category**, select the category of your digest.

    1.  In the drop-down menu next to **Language**, select the language of your digest.

    :::image alt-text="Screenshot of Condition inputs on Add an Advisor recommendation digest." lightbox="./media/add-an-advisor-recommendation-digest-highlight-condition.png" source="./media/add-an-advisor-recommendation-digest-highlight-condition-preview.png" type="content":::

1.  On **Add an Advisor recommendation digest** > **Action Groups**, select an existing **Action Group Name** or create a new action group for your digest.

    To learn more about action groups, see [Action groups](/azure/azure-monitor/alerts/action-groups "Action groups | Azure Monitor | Microsoft Learn").

    :::image alt-text="Screenshot of Action Groups inputs on Add an Advisor recommendation digest." lightbox="./media/add-an-advisor-recommendation-digest-highlight-action-groups.png" source="./media/add-an-advisor-recommendation-digest-highlight-action-groups-preview.png" type="content":::

1.  On **Add an Advisor recommendation digest** > **Digest Details**.

    1.  In the text box next to **Recommendation digest name**, enter the name of your digest.

    1.  Next to **Enable recommendation digest**, toggle the switch to enable your digest.

    :::image alt-text="Screenshot of Digest Details inputs on Add an Advisor recommendation digest." lightbox="./media/add-an-advisor-recommendation-digest-highlight-digest-details.png" source="./media/add-an-advisor-recommendation-digest-highlight-digest-details-preview.png" type="content":::

1.  Select **Create recommendation digest**.

## Manage digest

Your organization configures the recommendation digests. You must have access to the digest action group to modify the properties. The Subscription administrator manages your access.

To manage a digest after you create it, complete the actions in the following sections.

### Update digest

To edit your digest, complete the following actions.

1.  On **Advisor** | **Recommendation digests**, in the column under the **Digest name** heading, select the text.

1.  On **Edit Advisor recommendation digest** > **Condition**.

    *   In the drop-down menu next to **Frequency**, select how often you receive the notification for your digest.

    *   In the drop-down menu next to **Recommendation Category**, select the category of your digest.

    *   In the drop-down menu next to **Language**, select the language of your digest.

1.  On **Edit Advisor recommendation digest** > **Action Groups**.

    1.  Remove an existing **Action Group Name**.
  
    1.  Select an existing **Action Group Name** or create a new action group for your digest.

        To learn more, see [Action groups](/azure/azure-monitor/alerts/action-groups "Action groups | Azure Monitor | Microsoft Learn").

1.  On **Edit Advisor recommendation digest** > **Digest Details**, next to **Enable recommendation digest**, toggle the switch.

    *   Toggle the switch to set your digest to `Enable` or `Disable`.

1.  On **Edit Advisor recommendation digest**, select **Save Changes**.

### Set digest to Enable or Disable

To set your digest to `Enable` or `Disable`, complete the following actions.

1.  On **Advisor** | **Recommendation digests**.

    1.  Select the checkbox next to name of the digest.

    1.  Change the activation state of the digest.

        *   To set a digest to `Disable`, select **Disable**.

        *   To set a digest to `Enable`, select **Enable**.

            A digest set to `Enable` restarts notification using email.

### Delete digest

After you delete a digest, restoration isn't an option and you must recreate the digest.

> [!IMPORTANT]
> Unlike `Disable` that is reversible; `Delete` is permanent.

To delete your digest, complete the following actions.

1.  On **Advisor** | **Recommendation digests**

    1.  Next to the name of the digest, select the checkbox.

    1.  Select **Delete**.

1.  Confirm deletion when prompted.

### Unsubscribe from digest

To unsubscribe from a digest using the action group, complete the following actions.

1.  In **Monitor**, select **Alerts**.

1.  On **Monitor** | **Alerts**, select **Action groups**.

1. On **Alert rules**.

    1.  In the **Search** textbox, enter the name of the action group.

        1.  To locate the value of the Action group name, complete the following actions.

            1.  On **Advisor** | **Recommendation digests**, in the column under the **Digest name** heading, select the text.

            1.  On **Edit Advisor recommendation digest** > **Action Groups**, under the **ACTION GROUP NAME** heading, copy the value. 

    1.  In the column under the **Name** heading, select the text.

1.  On **Alert rules** > the name of alert rule, select **Edit**.

1.  On edit the alert rule > **Actions**, in the column under the **Action group name** heading, select the text.

1.  On edit the action group > **Notifications**.
   
    1.  In drop-down menu under the **Notification type** heading, select the notification type.

    1.  Select **Save changes**.

## Related articles

For more information about Advisor recommendations, see the following articles.

*   [Introduction to Azure Advisor](./advisor-overview.md "Introduction to Azure Advisor | Azure Advisor | Microsoft Learn")

*   [Azure Advisor portal basics](./advisor-get-started.md "Azure Advisor portal basics | Azure Advisor | Microsoft Learn")

*   [Azure Advisor REST API](/rest/api/advisor "Azure Advisor REST API | Microsoft Learn")

For more information about action groups, see the following article.

*   [Action groups](/azure/azure-monitor/alerts/action-groups "Action groups | Azure Monitor | Microsoft Learn")
