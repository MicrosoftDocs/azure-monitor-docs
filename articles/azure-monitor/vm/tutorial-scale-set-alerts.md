---
title: Enable recommended alerts for an Azure virtual machine scale set
description: Enable recommended alerts in Azure Monitor to get notified about issues with an Azure virtual machine scale set.
ms.topic: tutorial
ms.custom: subject-monitoring
ms.date: 03/16/2026
ms.reviewer: Xema Pathak
---

# Tutorial: Enable recommended alerts for an Azure virtual machine scale set
Once you have enabled monitoring for a virtual machine scale set, you should enable alerts to get notified when the scale set or its instances experience issues or performance degradation. Azure Monitor provides a set of recommended alert rules based on common performance scenarios that you can quickly enable for your virtual machine scale sets.

In this tutorial, you learn how to:

> [!div class="checklist"]
> * Enable recommended alert rules for a virtual machine scale set.
> * Configure alert thresholds and severity levels.
> * Set up email notifications using action groups.
> * View and manage created alert rules.

## Prerequisites
To complete this tutorial, you need:

- An Azure virtual machine scale set with monitoring enabled. If you haven't enabled monitoring yet, see [Enable monitoring for an Azure virtual machine scale set](tutorial-scale-set-enable-monitoring.md).
- Permission to create alert rules and action groups for the virtual machine scale set.

## Enable recommended alert rules

From the menu for the virtual machine scale set in the Azure portal, select the **Monitoring** tab. In the **Alerts** section, select **Enable** next to **Enable recommended alert rules**.

:::image type="content" source="media/tutorial-scale-set-alerts/enable-recommended-alerts.png" alt-text="Screenshot of option to enable recommended alerts for a virtual machine scale set." lightbox="media/tutorial-scale-set-alerts/enable-recommended-alerts.png":::

A list of recommended alert rules is displayed. You can select which rules to create. You can also change the recommended threshold. Ensure that **Email** is enabled and provide an email address to be notified when any of the alerts fire. An [action group](../alerts/action-groups.md) will be created with this address. If you already have an action group that you want to use, you can specify it instead.

:::image type="content" source="media/tutorial-scale-set-alerts/set-up-recommended-alerts.png" alt-text="Screenshot of recommended alert rule configuration." lightbox="media/tutorial-scale-set-alerts/set-up-recommended-alerts.png":::

## Configure alert severity

Expand each of the alert rules to see its details. By default, the severity for each is **Informational**. You might want to change to another severity such as **Error** or **Warning** depending on how critical each condition is for your environment.

:::image type="content" source="media/tutorial-scale-set-alerts/configure-alert-severity.png" alt-text="Screenshot of recommended alert rule severity configuration." lightbox="media/tutorial-scale-set-alerts/configure-alert-severity.png":::

Select **Save** to create the alert rules.

## View created alert rules

When the alert rule creation is complete, you'll see the alerts screen for the virtual machine scale set.

:::image type="content" source="media/tutorial-scale-set-alerts/recommended-alerts-complete.png" alt-text="Screenshot of alert screen for a virtual machine scale set." lightbox="media/tutorial-scale-set-alerts/recommended-alerts-complete.png":::

Click **Alert rules** to view the rules you just created. You can click on any of the rules to view their details and to modify their threshold if you want.

:::image type="content" source="media/tutorial-scale-set-alerts/recommended-alerts-rules.png" alt-text="Screenshot of list of created alert rules." lightbox="media/tutorial-scale-set-alerts/recommended-alerts-rules.png":::

## Next steps
Now that you have enabled alerts for your virtual machine scale set, you can collect additional log data such as Windows event log or Syslog to further enhance your monitoring capabilities.

> [!div class="nextstepaction"]
> [Collect data from virtual machine client with Azure Monitor](data-collection.md)
