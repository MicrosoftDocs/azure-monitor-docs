---
title: Service Health Planned maintenance
description: Overview of the features and information found on the pane. 
ms.topic: reference
ms.date: 11/12/2025

---

# Planned maintenance overview

The Planned Maintenance pane in Azure Service Health is a dedicated section in the Azure portal that keeps you informed about upcoming maintenance activities. It highlights events that can affect your Azure resources, helping you prepare in advance.<br> Here's a breakdown of its purpose and the information it provides:


This pane is designed to provide you with advance notice of scheduled maintenance events that can affect your services. 
The information enables you to:

- Prepare for possible service disruptions
- Coordinate internal change management processes
- Use self-service update windows when available

Unlike unplanned outages, planned maintenance is scheduled and communicated ahead of time to help minimize the effect.


## Get started with Planned maintenance

When you open the Planned maintenance pane, you see a list of maintenance events relevant to your subscriptions.

On the main panel you can sort the displayed list of Planned maintenance events by **Scope**, **Subscription**, **Region**, **Service**, and **Event tags**.

There are options to: 
- Create a service health alert
- Download the events as a CSV file

:::image type="content" source="./media/planned-maintenance/planned-maintenance-main.png" alt-text="Screenshot of current planned maintenance events." lightbox="./media/planned-maintenance/planned-maintenance-main.png":::

Each event includes the following information:
- Issue Name
- Tracking ID
- Services
- Regions
- Start time
- End time
- Last updated
- Event tags


Select the **Issue name** link to open the tabs with the information you need.

>[!Note]
>Planned maintenance events are displayed in the panel for 90 days if they are still active and if the `impactMitigationTime/endtime` is set in the future. After that they are moved to the health history panel where they are displayed for 90 days. 
>
>For more information about Planned maintenance events using ARG queries, refer to:
>- [Resource graph sample queries](resource-graph-health-samples.md) 
>- [Service Health graph sample queries](resource-graph-samples.md)
>- [Impacted resources graph sample queries](resource-graph-impacted-samples.md)<br>
>These resources provide guidance on how to utilize the available queries.

### Command bar

At the top of each tab, there's a command bar with several options of how to view the information displayed.

 - **Download as a PDF**: Select to download and open a PDF with the information about this event.
- **Track issue on mobile**: Select to open and point your mobile phone camera at the QR code.
- **Create a support request**: See [How to create an Azure support request](/azure/azure-portal/supportability/how-to-create-azure-support-request).
- **Create a service health alert**: See [Create Service Health alerts in the Azure portal](alerts-activity-log-service-notifications-portal.md). 


 :::image type="content" source="./media/planned-maintenance/planned-maintenance-tools.PNG" alt-text="Screenshot of tools on each tab." lightbox="media/planned-maintenance/planned-maintenance-tools.png":::

### Summary tab

:::image type="content" source="./media/planned-maintenance/planned-maintenance-summary.PNG" alt-text="Screenshot of Summary tab." lightbox="media/planned-maintenance/planned-maintenance-summary.png":::

When you open the Planned maintenance event, it opens the Summary tab, which shows you a list of information about this event. 
Each event includes:

|Field                  |Description  |
|-----------------------|-------------|
|Tracking ID            | The tracking ID of the event.                                               |
|Shareable link         | Copy this link to share the information.                                    |
|Impacted services      | A list of any services impacted by this event.                              |
|Impacted regions       | A list of all the regions impacted by this event and shown on the calendar. |
|Impacted subscriptions | A list of any subscriptions impacted by this event.                         |
|Status                 | The current status of this event.                                           |
|Health event type      | The type of health event (Planned maintence/Security advisory)                       |
|Event tags             | The information that explains or names the nature and status of this event. |
|Start time             | The time the event started.                                                 |
|End time               | The time the event ended.                                                   |
|Last update            | The most current notification information about this event.                 |



### Impacted Services tab

:::image type="content" source="./media/planned-maintenance/planned-maintenance-impacted-services.PNG" alt-text="Screenshot of Impacted Services tab." lightbox="media/planned-maintenance/planned-maintenance-impacted-services.png":::

The Impacted Services tab displays information about any of your services that are affected.
- Region
- Status
- Last update time

### Issue Updates tab

:::image type="content" source="./media/planned-maintenance/planned-maintenance-issue-updates.PNG" alt-text="Screenshot of Issue Updates tab." lightbox="media/planned-maintenance/planned-maintenance-issue-updates.png":::

The Issues Updates tab displays all information notifications by the date they were entered.
>[!TIP]
>Duplicate communications on this tab are removed if they're entered into the tab a short time apart.

### Impacted Resources tab


:::image type="content" source="./media/planned-maintenance/planned-maintenance-impacted-resources.PNG" alt-text="Screenshot of Impacted Resources tab." lightbox="media/planned-maintenance/planned-maintenance-impacted-resources.png":::

The tab for Impacted Resources displays the following information about any of your resources that are affected. 

- **Resource Name** - The name of the impacted resource.
- **Resource Type** - Type of Azure service (for example, Virtual Machine, App Service).
- **Resource Group** - The resource group containing the impacted resource.
- **Regions** - The Azure region where the resource is located.
- **Subscription ID** - The subscription that owns the resource.
- **Action** - A link to apply the update during a self-service window (for reboot-required updates).

For more information about Impacted resources, see [Impacted Resources from Planned maintenance events](impacted-resources-planned-maintenance.md).


### Planned Maintenance FAQ

The Planned Maintenance pane in Azure Service Health is a dedicated section within the Azure portal that provides visibility into upcoming maintenance activities that could affect your Azure resources. Here's how it happens and what best practices you should consider:

1. What are the types of maintenance windows?
- **Self-Service Maintenance window**: Updates can be manually initiated within approximately 35 days.
- **Scheduled Maintenance window**: If not initiated, Azure Service Health automatically applies updates.
- **Zero-Downtime Maintenance**: Azure limits disruption with live migration and cold starts.
2. How can I prepare for maintenance?
- Monitor the Planned Maintenance pane regularly.
- Use the Resources tab to identify the affected services.
3. What metadata is available for maintenance events?<br>
  These key fields help you assess the scope, timing, and severity of the events.
    - impactType
    - impactMitigationTime
    - eventSource
    - trackingId
    - status
4. Can I automate maintenance tracking?<br>
  Yes, you can use:
    - [Azure Policy](service-health-alert-deploy-policy.md) to deploy Service health alerts across all subscriptions.
    - Azure Resource Graph (ARG): use the queries to filter and analyze maintenance events.
5. How long is the maintenance history available?
- Active view: up to 90 days
- Health history: 90 days from most recent published date

For more information on event retention, see [Service Health notification transitions](service-health-notification-transitions.md).


## Next steps

- Read [Impacted resources from Azure Retirements](impacted-resources-retirements.md)
- Read [Service Health Frequently asked questions](service-health-faq.yml)
- Read [Resource impact from Azure outages](impacted-resources-outage.md)
- Read [How to create Service Health alerts](alerts-activity-log-service-notifications-portal.md)
- Read [Resource Health Frequently asked questions](resource-health-faq.yml)
