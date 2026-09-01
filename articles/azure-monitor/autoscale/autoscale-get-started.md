---
title: Get started with autoscale in Azure
description: Learn how to configure Azure Monitor autoscale for an App Service plan by using metric rules and schedules.
#customer intent: As an Azure administrator, I want to configure autoscale for an App Service plan so that it adjusts capacity based on demand.
ms.topic: get-started
ms.date: 08/19/2026
ms.reviewer: ancav
ai-usage: ai-assisted
---
# Get started with autoscale in Azure

Autoscale automatically scales your applications or resources based on demand. Use autoscale to provision enough resources to support the demand on your application without overprovisioning and incurring unnecessary costs.

This article describes how to configure autoscale settings in the Azure portal. The walkthrough uses an App Service plan, but Azure Monitor autoscale supports many resource types. For more information, see [autoscale supported resources](./autoscale-overview.md#supported-services-for-autoscale).

In this walkthrough, you discover resources that support autoscale, create metric-based scale-out and scale-in rules, add scheduled scale conditions, and review the run history and JSON configuration.

> [!VIDEO https://learn-video.azurefd.net/vod/player?id=125ecef8-c287-4a81-9001-69c01558398c]

## Prerequisites

- An Azure account with an active subscription. [Create an account for free](https://azure.microsoft.com/free/).
- An App Service plan on the Standard tier or higher.
- At least one app in the App Service plan.
- The **Owner** or **Contributor** role, or a custom role with `Microsoft.Insights/autoscaleSettings/*` permissions, on the App Service plan.

Azure Monitor autoscale applies its metric and schedule rules to the entire App Service plan, so scaling affects every app in the plan.

> [!NOTE]
> [App Service automatic scaling](/azure/app-service/manage-automatic-scaling) is a separate option that scales individual apps based on HTTP traffic without metric rules or schedules.

## Discover the autoscale settings in your subscription

To discover the resources available for autoscale, follow these steps.

1. Open the [Azure portal](https://portal.azure.com).

1. Search for and select **Monitor**.

1. Under **Settings**, select **Autoscale** to view the resources that support autoscale and their current status.

1. Use the filters to select a subscription, resource group, resource type, or resource.

   :::image type="content" source="./media/autoscale-get-started/view-resources.png" lightbox="./media/autoscale-get-started/view-resources.png" alt-text="A screenshot showing resources that can use autoscale and their statuses.":::

   The page shows the instance count and the autoscale status for each resource. Autoscale statuses are:
   - **Not configured**: Autoscale isn't set up yet for this resource.
   - **Enabled**: Autoscale is enabled for this resource.
   - **Disabled**: Autoscale is disabled for this resource.

    For an App Service plan, you can also open the plan and, under **Settings**, select **Scale out (App Service plan)**.

     :::image type="content" source="./media/autoscale-get-started/scaling-page.png" lightbox="./media/autoscale-get-started/scaling-page.png" alt-text="Screenshot of an App Service plan with Scale out selected under Settings.":::

## Create your first autoscale setting  

Follow the steps in this section to create your first autoscale setting.

1. Open the **Autoscale** pane in Azure Monitor and select the App Service plan that you want to scale.
1. The current instance count is 1. Select **Custom autoscale**.

1. Review the generated **Autoscale setting name** and **Resource group**. Change them if needed.

    :::image type="content" source="./media/autoscale-get-started/custom-scale.png" lightbox="./media/autoscale-get-started/custom-scale.png" alt-text="Screenshot of Custom autoscale selected for an App Service plan.":::

1. Select **Scale based on a metric**.
1. Select **Add a rule** to open the **Scale rule** pane.

1. The new rule defaults to increasing the instance count by one when the App Service plan's **CPU Percentage** metric is greater than 70 percent over 10 minutes.

    Keep the default values and select **Add**.

1. You've created your first scale-out rule. Best practice is to have at least one scale-in rule. To add another rule, select **Add a rule**.

1. Set **Operator** to *Less than*.
1. Set **Metric threshold to trigger scale action** to *20*.
1. Set **Operation** to *Decrease count by*.

    :::image type="content" source="./media/autoscale-get-started/scale-rule.png" lightbox="./media/autoscale-get-started/scale-rule.png" alt-text="Screenshot of an App Service scale-in rule with a 20-percent CPU threshold.":::

1. Select **Add**.

   You have configured a scale setting that scales out and scales in based on CPU usage, but you're still limited to a maximum of one instance. Change the instance limits to allow for more instances.

1. Under **Instance limits**, set **Maximum** to *3*.

    :::image type="content" source="./media/autoscale-get-started/instance-limits.png" lightbox="./media/autoscale-get-started/instance-limits.png" alt-text="Screenshot of App Service scale-out and scale-in rules with instance limits from one to three.":::

1. Select **Save**.

You created an autoscale setting that scales the App Service plan based on CPU usage. When CPU usage is greater than 70 percent, autoscale adds an instance, up to a maximum of three. When CPU usage is below 20 percent, autoscale removes an instance, down to a minimum of one. The default instance count is one.

## Add scheduled scale conditions

The default scale condition defines the scale rules that are active when no other scale condition is in effect. Add scale conditions that are active on a given date and time, or that recur on a weekly basis.

### Scale based on a repeating schedule

Set your resource to scale to a single instance on a Sunday.

1. Select **Add a scale condition**.

1. Select **Scale to a specific instance count**. You can also scale based on metrics and thresholds that are specific to this scale condition.
1. Enter *1* in the **Instance count** field.
1. Select **Repeat specific days**.
1. Select **Sunday**.
1. Set the **Start time** and **End time** for when the scale condition should be applied. Outside of this time range, the default scale condition applies.

    :::image type="content" source="./media/autoscale-get-started/repeating-schedule.png" lightbox="./media/autoscale-get-started/repeating-schedule.png" alt-text="Screenshot of an App Service plan scale condition that repeats on Sunday.":::

1. Select **Save**.

You defined a scale condition that reduces the App Service plan to one instance every Sunday during the specified time range.

### Scale differently on specific dates

Set autoscale to scale differently for specific dates, when you expect an unusual level of demand for the service.

1. Select **Add a scale condition**.

1. Select **Scale based on a metric**.
1. Select **Add a rule** to define your scale-out and scale-in rules. Set the rules to be the same as the default condition.
1. Set the **Maximum** instance limit to *10*.
1. Set the **Default** instance limit to *3*.
1. Select **Specify start/end dates**.
1. Enter the **Start date** and **End date** for when the scale condition should be applied.

    :::image type="content" source="./media/autoscale-get-started/specific-date-schedule.png" lightbox="./media/autoscale-get-started/specific-date-schedule.png" alt-text="Screenshot of an App Service plan metric condition with specific start and end dates.":::

1. Select **Save**.

You defined a scale condition for a specific date range. When CPU usage is greater than 70 percent, autoscale adds an instance, up to a maximum of 10. When CPU usage is below 20 percent, autoscale removes an instance, down to a minimum of one. When this scale condition becomes active, its default instance count is three.

## Additional settings

Use the autoscale setting tabs and resource-specific options to review activity, edit JSON, configure notifications, and access advanced scaling features.

### View the history of your resource's scale events

Whenever your resource has any scaling event, the activity log records it. You can view the history of the scale events in the **Run history** tab.

:::image type="content" source="./media/autoscale-get-started/run-history.png" lightbox="./media/autoscale-get-started/run-history.png" alt-text="Screenshot of the observed App Service plan instance count on the Run history tab.":::

### View the scale settings for your resource

Autoscale is an Azure Resource Manager resource. Like other resources, you can view the resource definition in JSON format. To view the autoscale settings in JSON, select the **JSON** tab.

:::image type="content" source="./media/autoscale-get-started/autoscale-setting-json-tab.png" lightbox="./media/autoscale-get-started/autoscale-setting-json-tab.png" alt-text="Screenshot of an App Service plan autoscale rule on the JSON tab.":::

Make changes directly in JSON if necessary. These changes take effect after you save them.

### Predictive autoscale for Virtual Machine Scale Sets

Predictive autoscale uses machine learning to help manage and scale Azure Virtual Machine Scale Sets with cyclical workload patterns. It forecasts the overall CPU load to your Virtual Machine Scale Set, based on your historical CPU usage patterns. It predicts the overall CPU load by observing and learning from historical usage. This process ensures that scale-out occurs in time to meet the demand. For more information, see [Use predictive autoscale to scale out before load demands](autoscale-predictive.md).


### Scale-in policy for Virtual Machine Scale Sets

When scaling a Virtual Machine Scale Set, the scale-in policy determines which virtual machines are selected for removal when a scale-in event occurs. Set the scale-in policy to **Default**, **NewestVM**, or **OldestVM**. For more information, see [Use custom scale-in policies with Azure Virtual Machine Scale Sets](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-scale-in-policy?WT.mc_id=Portal-Microsoft_Azure_Monitoring).

:::image type="content" source="./media/autoscale-get-started/scale-in-policy.png" lightbox="./media/autoscale-get-started/scale-in-policy.png" alt-text="A screenshot showing the scale-in policy setting.":::


### Notify

Configure notifications to send when a scale event occurs. Send notifications to an email address or to a webhook. For more information, see [autoscale notifications](autoscale-webhook-email.md).


### Cool-down period effects

Autoscale evaluates the cool-down period configured on each candidate rule. After a scale operation, a rule isn't eligible to initiate another scale action until its own cool-down period has elapsed. Another rule with a shorter cool-down period can become eligible sooner. The cool-down period allows the metrics to stabilize and avoids scaling more than once for the same condition. The default cool-down period is five minutes. For more information, see [how autoscale evaluates cooldown](autoscale-understanding-settings.md#how-does-autoscale-evaluate-cooldown).

### Flapping

Flapping refers to a loop condition that causes a series of opposing scale events. Flapping happens when one scale event triggers an opposite scale event. For example, scaling in reduces the number of instances causing the CPU to rise in the remaining instances. This condition triggers a scale-out event, which causes CPU usage to drop, repeating the process. For more information, see [Flapping in autoscale](autoscale-flapping.md) and [Troubleshoot autoscale](autoscale-troubleshoot.md).

### Clean up autoscale settings

To stop autoscale on a resource, open the **Autoscale** pane for the resource, select **Manual scale**, set the instance count, and select **Save**. Manual scale removes the autoscale rules and returns the resource to a fixed instance count.

## Move autoscale to a different region

This section describes how to move Azure autoscale to another region under the same subscription and resource group. Use the REST API to move autoscale settings.

### Prerequisites

- Ensure that the subscription and resource group are available and the details in both the source and destination regions are identical.
- Ensure that Azure autoscale is available in the [Azure region you want to move to](https://azure.microsoft.com/global-infrastructure/services/?products=monitor&regions=all).

### Move

Use [REST API](/rest/api/monitor/autoscalesettings/createorupdate) to create an autoscale setting in the new environment. The autoscale setting created in the destination region is a copy of the autoscale setting in the source region.

You can't move [diagnostic settings](../platform/diagnostic-settings.md) that you created in association with the autoscale setting in the source region. You need to re-create diagnostic settings in the destination region after you create the autoscale settings.

### Learn more about moving resources across Azure regions

To learn more about moving resources between regions and disaster recovery in Azure, see [Move resources to a new resource group or subscription](/azure/azure-resource-manager/management/move-resource-group-and-subscription).

## Related content

- [Create an activity log alert to monitor all autoscale engine operations on your subscription](https://github.com/Azure/azure-quickstart-templates/tree/master/demos/monitor-autoscale-alert)
- [Create an activity log alert to monitor all failed autoscale scale-in/scale-out operations on your subscription](https://github.com/Azure/azure-quickstart-templates/tree/master/demos/monitor-autoscale-failed-alert)
- [Use autoscale actions to send email and webhook alert notifications in Azure Monitor](autoscale-webhook-email.md)
