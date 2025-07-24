---
title: Create availability alert rule for multiple Azure virtual machines (preview)
description: Create a single alert rule in Azure Monitor to proactively notify you if any virtual machine in a subscription or resource group is unavailable.
ms.topic: tutorial
ms.custom: subject-monitoring
ms.date: 03/04/2025
ms.reviewer: Xema Pathak
---

# Tutorial: Create availability alert rule for multiple Azure virtual machines

One of the most common monitoring requirements for a virtual machine is to create an alert if it stops running. The best method is to create a metric alert rule in Azure Monitor using the [VM Availability Metric](/azure/virtual-machines/monitor-vm-reference#vm-availability-metric-preview) which is currently in public preview.

You can create an availability alert rule for a single virtual machine (VM) using the VM Availability Metric with [recommended alerts](tutorial-monitor-vm-alert-recommended.md). This tutorial shows how to create a single rule that applies to all virtual machines in a subscription or resource group in a particular region.

> [!TIP]
> While this article uses the metric value *VM Availability Metric,* you can use the same process to alert on any metric value. 

In this article, you learn how to:

> [!div class="checklist"]
> * View the VM availability metric in metrics explorer.
> * Create an alert rule targeting a subscription or resources group.
> * Create an action group to be proactively notified when an alert is created.

## Prerequisites

To complete the steps in this article, you need at least one Azure virtual machine to monitor.

## View VM availability metric in metrics explorer

There are multiple methods to create an alert rule in Azure Monitor. In this tutorial, we create it from [metrics explorer](../essentials/metrics-getting-started.md), which prefills required values such as the scope and metric we want to monitor. You just need to provide the detailed logic for the alert rule.

1. Select **Metrics** from the **Monitor** menu in the Azure portal.

1. In **Select a scope**, select either a subscription or a resource group with VMs to monitor.

1. Under **Refine scope**, for **Resource type**, select *Virtual machines*, and select the **Location** with VMs to monitor.

1. Click **Apply** to set the scope for metrics explorer.

    :::image type="content" source="media/tutorial-monitor-vm/metric-explorer-scope.png" alt-text="Screenshot of metrics explorer scope selection." lightbox="media/tutorial-monitor-vm/metric-explorer-scope.png":::

1. Select *VM Availability metric (preview)* for **Metric**. The value is displayed  for each VM in the selected scope.

    :::image type="content" source="media/tutorial-monitor-vm/vm-availability-metric-explorer.png" alt-text="Screenshot of VM Availability metric in metrics explorer." lightbox="media/tutorial-monitor-vm/vm-availability-metric-explorer.png":::

1. Click **New Alert Rule** to create an alert rule and open its configuration.

1. Set the following values for the **Alert logic**. This specifies that the alert fires whenever the average value of the availability metric falls below 1, which indicates that one of the VMs in the selected scope isn't running.

    | Setting          | Value     |
    |:-----------------|:----------|
    | Threshold        | Static    |
    | Aggregation Type | Average   |
    | Operator         | Less than |
    | Unit             | Count     |
    | Threshold value  | 1         |

1. Set the following values for **When to evaluate**. This specifies that the rule runs every minute, using the collected values from the previous minute.

    | Setting         | Value    |
    |:----------------|:---------|
    | Check every     | 1 minute |
    | Loopback period | 1 minute |


    :::image type="content" source="media/tutorial-monitor-vm/vm-availability-metric-alert-logic.png" alt-text="Screenshot of alert rule details for VM Availability metric." lightbox="media/tutorial-monitor-vm/vm-availability-metric-alert-logic.png":::

## Configure action group

The **Actions** page allows you to add one or more [action groups](../alerts/action-groups.md) to the alert rule. Action groups define a set of actions to take when an alert is fired such as sending an email or an SMS message.

1. Select **Use action groups** to add an existing group to the alert or create a new one.

    :::image type="content" source="media/tutorial-monitor-vm/action-group-select.png" alt-text="Screenshot of option to use action groups." lightbox="media/tutorial-monitor-vm/action-group-select.png":::

1. Select **Create action group** to create a new one.

    :::image type="content" source="media/tutorial-monitor-vm/action-group-create.png" alt-text="Screenshot of option to create new action group." lightbox="media/tutorial-monitor-vm/action-group-create.png":::

1. Select a **Subscription** and **Resource group** for the action group and give it an **Action group name** that appears in the portal and a **Display name** that appears in email and SMS notifications.

    :::image type="content" source="media/tutorial-monitor-vm/action-group-basics.png" lightbox="./media/tutorial-monitor-vm/action-group-basics.png" alt-text="Screenshot of action group basics.":::

1. Select **Notifications** and add one or more methods to notify appropriate people when the alert is fired.

    :::image type="content" source="media/tutorial-monitor-vm/action-group-notifications.png" lightbox="./media/tutorial-monitor-vm/action-group-notifications.png" alt-text="Screenshot showing action group notifications.":::

## Configure details

1. Configure different settings for the alert rule on the **Details** page.

    | Setting                | Description                                                                                                                                             |
    |:-----------------------|:--------------------------------------------------------------------------------------------------------------------------------------------------------|
    | Subscription           | Subscription where the alert rule is stored.                                                                                                            |
    | Resource group         | Resource group where the alert rule is stored. This doesn't need to be in the same resource group as the resource that you're monitoring.               |
    | Severity               | The severity allows you to group alerts with a similar relative importance. A severity of **Error** is appropriate for an unresponsive virtual machine. |
    | Alert rule name        | Name of the alert that shows when it fires.                                                                                                             |
    | Alert rule description | Optional description of the alert rule.                                                                                                                 |
    
    :::image type="content" source="media/tutorial-monitor-vm/alert-rule-details.png" lightbox="media/tutorial-monitor-vm/alert-rule-details.png" alt-text="Screenshot showing alert rule details.":::

1. Click **Review + create** to create the alert rule.

## View the alert

To test the alert rule, stop one or more virtual machines in the scope you specified. If you configured a notification in your action group, then you should receive that notification within a few seconds. You also see an alert for each VM on the **Alerts** page.

:::image type="content" source="media/tutorial-monitor-vm/vm-availability-metric-alert.png" lightbox="media/tutorial-monitor-vm/alerts-summary.png" alt-text="Screenshot showing alerts summary":::

## Next steps

Now that you have an alert in place when the VM goes down, enable VM insights to install the Azure Monitor agent which collects additional data from the client and provides additional analysis tools.

> [!div class="nextstepaction"]
> [Collect guest logs and metrics from Azure virtual machine](tutorial-monitor-vm-guest.md)
