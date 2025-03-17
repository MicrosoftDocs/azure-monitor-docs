---
author: bwren
ms.author: bwren
ms.service: azure-monitor
ms.topic: include
ms.date: 11/28/2023
---

[Action groups](../articles/azure-monitor/alerts/action-groups.md) define a set of actions to take when an alert is fired such as sending an email or an SMS message.

To configure actions, select the **Actions** tab.

:::image type="content" source="media/azure-monitor-tutorial-action-group/actions.png" lightbox="./media/azure-monitor-tutorial-action-group/actions.png" alt-text="Screenshot that shows the Actions tab highlighted.":::

Click **Select action groups** to add one to the alert rule.

:::image type="content" source="media/azure-monitor-tutorial-action-group/select-action-groups.png" lightbox="./media/azure-monitor-tutorial-action-group/select-action-groups.png" alt-text="Screenshot that shows the Select action groups button.":::


If you don't already have an action group in your subscription to select, then click **Create action group** to create a new one.

:::image type="content" source="media/azure-monitor-tutorial-action-group/create-action-group.png" lightbox="./media/azure-monitor-tutorial-action-group/create-action-group.png" alt-text="Create action group":::

Select a **Subscription** and **Resource group** for the action group and give it an **Action group name** that will appear in the portal and a **Display name** that will appear in email and SMS notifications.

:::image type="content" source="media/azure-monitor-tutorial-action-group/action-group-basics.png" lightbox="./media/azure-monitor-tutorial-action-group/action-group-basics.png" alt-text="Action group basics":::

Select the **Notifications** tab and add one or more methods to notify appropriate people when the alert is fired.

:::image type="content" source="media/azure-monitor-tutorial-action-group/action-group-notifications.png" lightbox="./media/azure-monitor-tutorial-action-group/action-group-notifications.png" alt-text="Action group notifications":::
