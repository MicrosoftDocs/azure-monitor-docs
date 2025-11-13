---
title: How to create Resource Health alerts in Service Health
description: Create alerts in Azure Service Health to notify you when your Azure resources become unavailable.
ms.topic: conceptual
ms.date: 11/13/2025 

---

# Create Resource Health alerts 

A Resource Health alert is a proactive notification that tells you when the health status of an individual Azure resource changes. 

Unlike Service Health alerts that cover platform-wide issues, Resource Health alerts are resource-specific and can detect problems even if there’s no broader Azure outage. 

Resource Health alerts notify you when your Azure resources experience a change in health status, such as becoming unavailable or degraded. These alerts help you stay informed and respond quickly to service issues affecting your workloads.

You can create Resource Health alerts to get the following information:
- **Immediate Action**: To respond to outages before they impact customers. 
- **Compliance**: So you can track SLA violations and recovery times. 
- **Operational Insight**: To understand whether issues are platform or initiated by users. 
- **Automation**: To trigger workflows via Action Groups (for example, auto-scale, failover). 

This article shows you how to create and configure Azure Resource Health alerts from the Service Health portal.


## Create a Resource Health alert rule

1. In the Service Health portal, select **Resource Health**.


:::image type="content" source="./media/alerts-activity-log-service-notifications/resource-health-select.png" alt-text="Screenshot of Service Health option." lightbox="./media/alerts-activity-log-service-notifications/resource-health-select.png":::

    
2. Select **Add resource health alert** to open the **Create an alert rule** window.
   
:::image type="content" source="./media/resource-health/resource-health-create.PNG" alt-text="Screenshot of Resource Health create option." lightbox="./media/resource-health/resource-health-create.PNG":::


To set up your alert, use the six tabs in this window: **Scope**, **Condition**, **Actions**, **Details**, **Tags**, and **Review + create**.
<!--For more information about creating alerts, see [Configure alert rule conditions](/azure/azure-monitor/alerts/alerts-create-activity-log-alert-rule?tabs=activity-log#configure-alert-rule-conditions).-->


>[!TIP]
>- Select the *Next: ...* button at the bottom of each tab, or select the name at the top of the wizard to open the next tab.
>- All fields with an asterisk * next to the name are required fields.


## Scope

Scope defines which resources your alert monitors. In this tab, you select the subscription, resource group, or individual resources that matter most to your business. This information is needed because Resource health alerts only trigger for the resources you include in the scope. 

By choosing the right scope, you ensure alerts are relevant and actionable, helping you respond quickly to issues that could have an impact on your critical workloads without unnecessary noise.

:::image type="content" source="./media/resource-health/resource-health-create-scope.PNG" alt-text="Screenshot of Resource Health scope tab." lightbox="./media/resource-health/resource-health-create-scope.PNG":::

On this panel you can select any or all of the following from the drop-down menus: 
- Subscription
- Resource Group 
- Resource type 
- Resource

You can also select either or both boxes to include all future resource groups and future resources.


## Condition

Use this tab to choose what you need to trigger your alert. You can set it to watch for changes in resource health status (like Unavailable or Degraded), event status (Active or Resolved), or even specific reason types (platform vs. user actions). 

Pick the conditions that matter most so you only get alerts when action is needed.

:::image type="content" source="./media/resource-health/resource-health-create-condition.PNG" alt-text="Screenshot of Resource Health condition tab." lightbox="./media/resource-health/resource-health-create-condition.PNG"::: 

The **Signal name** field is automatically populated and shows the type of event that triggers your alert. For Resource Health alerts, it's usually *Resource Health*. It tells Azure what signal to monitor so your alert fires when the resource’s health status changes.
This tab is where you select from the health-related conditions you want for alerts such as:

- **Event status**: is it active or resolved or ongoing?
- **Resource status**: how is the resource now?
- **Previous vs current status**: you can create an alert based on the status transition – is it in progress or being resolved?
- **The reason type**: is the event platform or user initiated?

To set up your alert for the following information, select from each of the following drop-down menu options.

### Event status
- Active – The health event is ongoing.
- Resolved – The event ended.
- In Progress – Azure is working on mitigation. 

>[!Tip] 
> -Use **Active** to get notified immediately when an issue starts.<br>
> -Use **Resolved** for post-incident reviews

### Current resource status
You can select **All** or:<br>
- Available - Healthy
- Degraded - Performance issues
- Unavailable- Down

### Previous resource status
You can select **All** or:<br>
- Available- Healthy
- Degraded- Performance issues
- Unavailable - Down
- Unknown - health information is missing

>[!NOTE]>
> You can set alerts based on status transitions for example:<br> `Previous` = Unavailable and `Current` = Available.<br> This would show the resource is recovered and it's helpful for tracking recovery or SLA compliance.

### Reason type
- Platform Initiated – Azure maintenance or incident.
- User Initiated – Manual stop/deallocate. (*This setting helps distinguish between Azure issues and user actions*.)
- Unknown

## Actions
On this tab, you decide how you're notified. Action Groups let you send alerts by email, SMS, push notifications, or even trigger automation through webhooks, Logic Apps, or Functions.<br> Use multiple channels to make sure all the right people respond quickly.

:::image type="content" source="./media/resource-health/resource-health-create-actions.PNG" alt-text="Screenshot of Resource Health actions tab." lightbox="./media/resource-health/resource-health-create-actions.PNG":::


Based on your subscription, there's  a list of all available action groups you can choose. Select up to 5 and then select **Select**. Each action group contains actions that are defined for that group as in emails or roles

>[!TIP] **Select Create action groups** to create your own action groups.
For more information about Action groups, see [Action Groups](/azure/azure-monitor/alerts/action-groups?WT.mc_id=Portal-Microsoft_Azure_Monitoring).


## Details
The Details tab is where you name and describe your alert. This information is needed so you can easily identify the alert later and understand its purpose immediately. A clear name and description help you manage multiple alerts, avoid confusion, and ensure the right alert is triggered for the right scenario.  

:::image type="content" source="./media/resource-health/resource-health-create-details.PNG" alt-text="Screenshot of Resource Health Details tab." lightbox="./media/resource-health/resource-health-create-details.PNG"::: 

On this tab you can give your alert a clear name and description so it’s easy to recognize later. Use names that explain the purpose, like *Critical VM Health Alert.*<br> Choose how to set up your details with the following fields. 

**Project details**
- Resource group
- Region

**Alert rule details**
- Alert rule name
- Alert rule description

**Advanced options**<br>
*Select this tool to add your own custom properties to the alert rule.*

## Tags
Tags help you organize and filter your alerts easily. 

For example, adding tags like *Environment: Production* or *Team: Operations* make it simple to find and manage alerts later, especially when you have many rules.
:::image type="content" source="./media/resource-health/resource-health-create-tags.PNG" alt-text="Screenshot of Resource Health Tags tab." lightbox="./media/resource-health/resource-health-create-tags.PNG"::: 

Select from the **Name** drop-down menu and then choose the value from the **Value** drop-down.

For more information about using tags, see [Use tags to organize your resources](/azure/azure-resource-manager/management/tag-resources?wt.mc_id=azuremachinelearning_inproduct_portal_utilities-tags-tab).

## Review + Create
This is your final check before activating the alert. 

Review all the settings from **Scope**, **Condition**, **Actions**, and **Details** to make sure they’re correct. 
:::image type="content" source="./media/resource-health/resource-health-create-rule.PNG" alt-text="Screenshot of Resource Health Review tab." lightbox="./media/resource-health/resource-health-create-rule.PNG":::

When everything looks good, select **Create** to start monitoring your resources.


## For more information

Learn more about Resource Health:

* [Azure Resource Health overview](Resource-health-overview.md)
* [Resource types and health checks available through Azure Resource Health](resource-health-checks-resource-types.md)

Create Service Health Alerts:

* [Configure Alerts for Service Health](./alerts-activity-log-service-notifications-portal.md) 
* [Azure Activity Log event schema](../azure-monitor/essentials/activity-log-schema.md)
* [Understand structure and syntax of ARM templates](/azure/azure-resource-manager/templates/syntax#template-format)
