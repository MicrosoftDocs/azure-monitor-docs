---
title: Planned maintenance overview
description: Overview of the features and information found on the Planned maintenance pane. 
ms.topic: concept-article

ms.date: 03/26/2026
---

# Planned maintenance

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


For more information about Planned maintenance events using ARG queries, see:
- [Resource graph sample queries](resource-graph-health-samples.md) 
- [Service Health graph sample queries](resource-graph-samples.md)
- [Impacted resources graph sample queries](resource-graph-impacted-samples.md)<br>
These resources provide guidance on how to utilize the available queries.

### Filtering and sorting

At the top of each tab, there's a command bar with several options of how to view the information displayed.

 - **Download as a PDF**: Select to download and open a PDF with the information about this event.
- **Track issue on mobile**: Select to open and point your mobile phone camera at the QR code.
- **Create a support request**: See [How to create an Azure support request](/azure/azure-portal/supportability/how-to-create-azure-support-request).
- **Create a service health alert**: See [Create Service Health alerts in the Azure portal](alerts-activity-log-service-notifications-portal.md). 


 :::image type="content" source="./media/planned-maintenance/planned-maintenance-tools.PNG" alt-text="Screenshot of tools on each tab." lightbox="media/planned-maintenance/planned-maintenance-tools.png":::

### Summary tab

:::image type="content" source="./media/planned-maintenance/planned-maintenance-summary.PNG" alt-text="Screenshot of Summary tab." lightbox="media/planned-maintenance/planned-maintenance-summary.png":::

When you open the Planned maintenance event, it opens the Summary tab, which shows you a list of information about this event, which includes:

| Field                  | Description                                                                    |
| ---------------------- | ------------------------------------------------------------------------------ |
| Tracking ID            | The tracking ID of the event.                                                  |
| Shareable link         | Copy this link to share the information.                                       |
| Impacted services      | A list of any services impacted by this event.                                 |
| Impacted regions       | A list of all the regions impacted by this event and shown on the calendar.    |
| Impacted subscriptions | A list of any subscriptions impacted by this event.                            |
| Status                 | The current status of this event.                                              |
| Health event type      | The type of health event (Planned maintence/Security advisory).                |
| Event tags             | The information that explains or names the nature and status of this event.    |
| Start time             | The time the event started. <br> *All times displayed are in UTC*.             |
| End time               | The time the event ended. <br> *All times displayed are in UTC*.               |
| Last update            | The most current notification information about this event.                    |



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

The Impacted Resources tab displays information about any of your resources that are affected. 

  - **Resource Name** - The name of the impacted resource.
  - **Resource Type** - Type of Azure service, such as Virtual Machine or App Service.
  - **Resource Group** - The resource group containing the impacted resource.
  - **Regions** - The Azure region where the resource is located.
  - **Subscription ID** - The subscription that owns the resource.
  - **Action** - A link to apply the update during a self-service window (for reboot-required updates).

For more information about impacted resources, see [Impacted Resources from Planned maintenance events](impacted-resources-planned-maintenance.md).


### Planned maintenance FAQ


The Planned Maintenance pane in Azure Service Health is a dedicated section within the Azure portal that provides visibility into upcoming maintenance activities that could affect your Azure resources. Here's how it happens and what best practices you should consider:

1. What are the types of maintenance windows?
    - **Self-Service Maintenance window**: You can manually initiate updates within approximately 35 days.
    - **Scheduled Maintenance window**: If you don't initiate updates, Azure Service Health automatically applies them.
    - **Zero-Downtime Maintenance**: Azure limits disruption by using live migration and cold starts.<br>
  
1. How can I prepare for maintenance?
    - Monitor the Planned Maintenance pane regularly.
    - Use the Resources tab to identify the affected services.<br>
    
1. What metadata is available for maintenance events?<br>
  These key fields help you assess the scope, timing, and severity of the events.
    - impactType
    - impactMitigationTime
    - eventSource
    - trackingId
    - status
    
1. Can I automate maintenance tracking?<br>
  Yes, you can use:
    - [Azure Policy](service-health-alert-deploy-policy.md) to deploy Service health alerts across all subscriptions.
    - Azure Resource Graph (ARG): use the queries to filter and analyze maintenance events.
    
1. How long is the maintenance history available?
   - Active view: up to 90 days
   - Health history: 90 days from most recent published date

#### Summary 


**Service health dashboard experience for Planned maintenance**

We want to provide clarity on what customers can expect from the **Service Health (SH) dashboard** during planned maintenance events, and why functionality may vary across different events.

**Service health dashboard capabilities**<br>
Service Health is designed to be the **authoritative place** for customers to understand maintenance events, assess impact, and be redirected to take action where applicable. For some planned maintenance events, customers will see the **full Service Health experience**, which includes:
  - **Dynamic impacted resources on page refresh**<br>
    A live, automatically updated list of impacted resources as maintenance progresses and completes on each page refresh.
  - **Live status updates**<br>
    The resource status reflects the current maintenance phase without requiring a manual page refresh.
  - **A link to self-serve Customer actionability (where supported)**<br>
    The ability to redirect customers from Service Health to the right location in Azure Portal to take proactive actions on individual resources directly.
    
Together, these features represent the **full functionality** of the Service health dashboard for planned maintenance.

**Limited functionality for some maintenance events**<br>
For other planned maintenance events, you might see a limited Service Health experience. In these cases:
  - Impacted resources could be shown as a **static list or may be unavailable**, based on the information provided to Service Health for that event.
  - Resource status **may not update dynamically** as the maintenance progresses or completes.
  - Resource-level customer action links might **not be supported**.<br>
  In these scenarios, Service health continues to provide **maintenance visibility and notifications**, but without the full set of dynamic and actionable capabilities described above.

**What we mean by full functionality**

From our perspective, full Service Health functionality for planned maintenance includes:
- Automatically identified and continuously updated impacted resources.
- Live status tracking throughout the maintenance lifecycle.
- Resource‑level customer actionability links available for redirection where supported.
- Consistent behavior across the Service Health portal, APIs, and integrations.

If one or more of these elements aren't available, the experience is considered **limited**, even though Service Health remains available and operational.


**Service health commitment**<br>
Service Health continues to meet its **availability** and **notification commitments** for all planned maintenance events. 

Feature-level capabilities can vary by event and delivery mechanism such as the Azure portal interface (Portal UI) or programmatic access (API). We're actively working toward delivering a **consistent and fully functional Service Health experience** across all services over time.




For more information on event retention, see [Service Health notification transitions](service-health-notification-transitions.md).


## Next steps

- Read [How to report an impact (Preview)](report-issue.md)
- Read [Impacted resources from Azure Retirements](impacted-resources-retirements.md)
- Read [Service Health Frequently asked questions](service-health-faq.yml)
- Read [Resource impact from Azure outages](impacted-resources-outage.md)
- Read [How to create Service Health alerts](alerts-activity-log-service-notifications-portal.md)
- Read [Resource Health Frequently asked questions](resource-health-faq.yml)
