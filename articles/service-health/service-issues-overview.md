---
title: Service Issues notifications
description: This article describes how to view and use the Service Issues pane
ms.topic: overview
ms.date: 9/26/2025

---

# Service issues

The Service issues pane in Azure Service Health offers a detailed, and real-time view of active Azure service problems. It highlights issues that could be affecting your resources.

You can see which resources are impacted and review key details such as severity, status, scope, and timestamps. The information on this pane helps you stay informed and able to take action quickly if needed. This article provides a detailed explanation of the purpose of this panel and the information it provides.

On the main panel you can sort the displayed list of Planned maintenance events by Scope, Subscription, Region, Service, Event levels and Event tags. 

And you can create a service health alert. See [Create Service Health alerts in the Azure portal](alerts-activity-log-service-notifications-portal.md).


## Get started with Service issues

:::image type="content" source="./media/service-issue-overview/service-issues-main-tab.png" alt-text="Screenshot that shows the main panel with Service issues." Lightbox="./media/service-issue-overview/service-issues-main-tab.PNG":::

The Service issues pane provides you with the help to track incidents, understand which of your services are affected, and follow recommended steps to reduce downtime or disruption.<br>
For each Service issue listed on this panel, the information includes: 

- Issue name
- Event Level
- Tracking ID
- Services
- Regions
- Start time
- Last updated 
- Event tags

Select the Issue name **link** to open the tabs and see more detailed information about the issue.
>[!Note]
>Service issue events are displayed in the panel for 3 days if they are still active or have been updated during that time. After that they are moved to the health history panel where they are displayed for 90 days. 
>
>
>For more information about Service issue events using ARG queries, see [Resource graph sample queries](resource-graph-samples.md). This resource provides guidance on how to utilize the available queries.

### Command bar
At the top of each tab, there's a command bar with several options of how to view the information displayed.

:::image type="content" source="./media/service-issue-overview/service-issues-tool-bar.png" alt-text="Screenshot that shows options." Lightbox="./media/service-issue-overview/service-issues-tool-bar.PNG":::

- **Download as a PDF**: Select to download and open a PDF with the information about this event.
- **Request post incident review**: Select to start the creation of a Post Incident Review (PIR).
- **Track issue on mobile**: Select to open and point your mobile phone camera at the QR code.
- **Create a support request**: See [How to create an Azure support request](/azure/azure-portal/supportability/how-to-create-azure-support-request).
- **Create a service health alert**: See [Create Service Health alerts in the Azure portal](alerts-activity-log-service-notifications-portal.md). 


## Summary tab

The Summary tab shows detailed information about the Service issue.

:::image type="content" source="./media/service-issue-overview/service-issues-summary.png" alt-text="Screenshot that shows the summary tab." Lightbox="./media/service-issue-overview/service-issues-summary.PNG":::

The information on this tab includes the following data:

|Field  |Description  |
|---------|---------|
|Title    | A summary of the issue |
|Tracking ID |A unique identifier for the incident |
|Status   |Whether the issue is Active, Resolved, or Scheduled. Select the **See details** link to open the Impacted Services tab for more detailed information. |
|Start/End Time |When the issue began and when it was resolved (if applicable) |
|Impacted Services |Azure services affected by the issue|
|Impacted Regions |Geographic regions where the issue is occurring |
|Impacted Subscriptions    |Your subscriptions that are affected|
|Impacted Resources| The resources affected by this service issue. Select the **View details** link to open the Impacted Resources tab for more detailed information. |
|Event level   | Severity of the issue (for example, Informational, Warning, Critical)|
|Event tags    | Definition of the nature and status of the event|
|Last update    | Timestamp of the most recent update from Azure Service Health. Select the **See all updates** link to open the Issue Updates tab for more detailed information.|



## Impacted Services tab

:::image type="content" source="./media/service-issue-overview/service-issues-impacted-services.png" alt-text="Screenshot that shows the Issues Impacted tab." Lightbox="./media/service-issue-overview/service-issues-impacted-services.PNG":::

This tab displays all the impacted services that are affected:
- Region 
- Status 
- Last update time 
- The storage that is affected

## Issue Updates tab

:::image type="content" source="./media/service-issue-overview/service-issues-issue-updates.png" alt-text="Screenshot that shows the Issue Updates tab." Lightbox="./media/service-issue-overview/service-issues-issue-updates.PNG":::

This tab provides a timeline of updates from Azure Service Health, including: 
- The Root Cause Analyses (RCAs) and mitigation steps. 
- Each message update is listed with the time of creation.

## Impacted Resources tab

:::image type="content" source="./media/service-issue-overview/service-issues-impacted-resources.png" alt-text="Screenshot that shows the Impacted Resources tab." Lightbox="./media/service-issue-overview/service-issues-impacted-resources.PNG":::
This tab shows a list of your specific resources that are or might be affected, which includes:
- Resource Name (linked to Resource Health)
- Health Status (Available, Degraded, Unavailable, Unknown)
- Impact Type (Confirmed or Potential)
- Resource Type, Group, Location, and Subscription details
- Resource Group
- Location
- Subscription ID
- Subscription Name

For more information about Impacted resources, see [Impacted Resources from Outages](./impacted-resources-outage.md).


### Next steps:

- [Service Health Frequently asked questions](service-health-faq.yml)
- [Service Health Portal](service-health-portal-update.md)
- [How to create Service Health alerts](alerts-activity-log-service-notifications-portal.md)
