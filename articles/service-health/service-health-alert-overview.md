---
title: Service Health Alerts overview
description: Service health alerts notify of the health of your Azure services or regions.
ms.topic: concept-article
ms.date: 02/19/2026
---

# Service Health alerts 

The Health Alerts panel in Azure Service Health lets you view and manage alerts about service issues, planned maintenance, health advisories and security advisories. These alerts notify you about events that could affect your resources.

It shows only the alerts that you create based on the criteria you configured (subscription, services, regions, event types). 
Health alerts are tied to your alert rules, not to all events occurring in Azure.


For information on how to create Service Health alerts, refer to [How to create Service health alerts](alerts-activity-log-service-notifications-portal.md).

## Service Health alert notifications

You’re notified when Azure sends relevant Service Health notifications to your subscription or tenant directory. 
The alerts must be configured using the Service Health interface, including selecting subscriptions, services, and regions.


## Get started with Health alerts

:::image type="content" source="./media/alert-overview/health-alerts-main.PNG" alt-text="Screenshot of Health alerts main panel." lightbox="./media/alert-overview/health-alerts-main.PNG":::
When you open the health alerts panel, it displays a list of all the alerts you created for:
- Service issues
- Planned maintenance
- Health advisories
- Security advisories


#### Filtering and sorting
At the top of each tab, there's a command bar with several options of how to view the information displayed.

:::image type="content" source="./media/alert-overview/health-alerts-filter.PNG" alt-text="Screenshot of Health alerts filter options." lightbox="./media/alert-overview/health-alerts-filter.PNG":::
- Create a new alert
- Select the columns you want to see on this page
- Refresh the screen
- Export to a CSV file
- Open a query to start Azure Graph Explorer and run a query

You can also:
- Tag by subscription or status
- Add a filter
- Group by subscription or status

## View the alert details

Select the name of the alert to open a new panel that displays the details of the alert and all information that is collected.

:::image type="content" source="./media/alert-overview/health-alerts-overview.PNG" alt-text="Screenshot of Health alerts overview panel." lightbox="./media/alert-overview/health-alerts-overview.PNG":::

The **Overview** panel displays the basic information in the alert that you set up when you created the Health alert.

There's an option on this panel to show information about the JSON View.
    
**JSON View** opens the raw JSON payload of the Service Health alert. This JSON is the same structure used by:
- Resource ID, subscription, region
- Health status and status change timestamps
- Reason codes / cause category
- Platform‑initiated vs. user‑initiated actions
- Correlated event IDs
- Metadata used by automation tools (for example, Action Groups, Logic Apps, Functions)
- Full activityLog.properties as not all fields are shown in the UI
<!--
 :::image type="content" source="./media/alert-overview/health-alerts-json.PNG" alt-text="Screenshot of Health alerts JSON panel." lightbox="./media/alert-overview/health-alerts-json.PNG":::
-->
#### Activity log
Select **Activity log** to open the panel showing information from the Activity log located in Azure Monitor. 
>[!NOTE]
> This panel isn't exclusive to Service Health alerts. It's part of the general Activity Log alert experience that includes both Resource Health and Service Health alerts.
<!--
:::image type="content" source="./media/alert-overview/health-alerts-activity-log.PNG" alt-text="Screenshot of Activity log panel." lightbox="./media/alert-overview/health-alerts-activity-log.PNG":::
-->
For more information on the Activity log, read [Azure Monitor data sources and data collection](/azure/azure-monitor/fundamentals/data-sources).

#### Access control (IAM)
Select **Access Control *Identity and Access Management* (IAM)** to open the panel showing what access you have, and also where you can assign role access. For more information, see [Check access for a user](/azure/role-based-access-control/check-access?tabs=default).
<!-- 
:::image type="content" source="./media/alert-overview/health-alerts-assignments.PNG" alt-text="Screenshot of Health alerts Access panel." lightbox="./media/alert-overview/health-alerts-assignments.PNG":::
-->
#### Tags
Select **Tags** to open the panel with an option to select tags by **Name** and **Value**. 
<!--
:::image type="content" source="./media/alert-overview/health-alerts-tags.PNG" alt-text="Screenshot of Tags panel." lightbox="./media/alert-overview/health-alerts-tags.PNG":::
-->
For more information, see [Use tags to organize your resources](/azure/azure-resource-manager/management/tag-resources).

#### Diagnose and solve problems
Select **Diagnose and solve problems** to open the panel showing what options for diagnosing what the issue is on this alert.
 <!--
:::image type="content" source="./media/alert-overview/health-alerts-diagnose.PNG" alt-text="Screenshot of Diagnose and solve problems panel." lightbox="./media/alert-overview/health-alerts-diagnose.PNG":::
-->
#### History
Select **History** to open the panel showing any available history for this issue. You can filter by a time range if you need it.
 <!--
 
:::image type="content" source="./media/alert-overview/health-alerts-history.png" alt-text="Screenshot of the History panel." lightbox="./media/alert-overview/health-alerts-history.png":::
-->
#### Resource visualizer
Select **Resource visualizer** to open the panel to see the position of the resource in the hierarchy (subscription > resource group > resource). This view helps you understand relationships or dependencies when you're troubleshooting a Service Health or Resource Health alert.

#### Automation
For more information about the options on this panel, see [Create an automation task](/azure/logic-apps/create-automation-tasks-azure-resources#create-an-automation-task).

## For more information

* [Service Health Frequently asked questions](service-health-faq.yml)
* [Configure Alerts for Service Health](./alerts-activity-log-service-notifications-portal.md) 
* [Azure Activity Log event schema](../azure-monitor/essentials/activity-log-schema.md)
* [Configure Resource Health alerts](./resource-health-alert-arm-template-guide.md)
