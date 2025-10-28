---
title: Azure Service Health notifications overview
description: Service Health notifications allow you to view Service Health messages published by Microsoft Azure.
ms.topic: article
ms.date: 10/28/2025

---

# Service Health notifications

Azure Service Health notifications are system-generated alerts that inform you about Azure service issues or events affecting your resources. They're recorded as part of your subscription’s [Azure Activity Log](/azure/azure-monitor/platform/activity-log?tabs=log-analytics) (which logs many events in Azure), and then shown in the Azure portal under [Azure Service Health](service-health-portal-update.md). In other words, whenever Azure needs to communicate something about service health (for example, an outage, upcoming maintenance, or account-specific alert), it creates a Service Health event in your Activity Log. 

Depending on the notification’s type, it could be purely informational or indicate an issue that requires you to act. For more information, see [View Service Health notifications](service-notifications.md).

 :::image type="content"source="./media/service-health-notifications/service-health-notifications-main.png"alt-text="Screenshot of service health notification history pane." lightbox="./media/service-health-notifications/service-health-notifications-main.png":::


## How to access and use Service Health notifications
Once logged into Azure, you can access Service Health notifications in one of three ways:

- **Azure Portal – Service Health**: In the Azure portal, select Service Health to open a personalized dashboard showing any active notifications for your subscriptions. The notifications are organized into the categories corresponding to the types (Incidents, Maintenance, etc.), and there’s also a Health history section for past events. For example, active service outages are listed under Incidents, planned maintenance under Maintenance, and so on. From this interface, you can select a notification to read its details (impact, status updates, resolution, etc.). See [Azure Service Health Portal](service-health-portal-update.md).  

- **Azure Portal – Activity Log**: In the Azure portal, open the activity log to view notifications that contain more detailed information, but only under specific conditions. 
    - Service Health events appear in the Activity Log when they're subscription-scoped (for example, service issues, planned maintenance, health advisories).
    - Emerging Issues don't show up because they're global and not tied to a subscription.<br>
For more information, see [View and retrieve the activity log](/azure/azure-monitor/platform/activity-log?tabs=log-analytics#view-and-retrieve-the-activity-log). 

- **Alerts**: Within the Service Health portal pane, you can also set up Activity Log alerts to notify you (via email, SMS, etc.) when new Service Health events occur. For instance, you might create an alert to get an email whenever there’s a new Incident or a Security advisory. This way you don’t have to constantly check the portal; Azure proactively sends you a notification through your chosen channel. For more information on how to create alerts, see [Create Service Health Alerts](alerts-activity-log-service-notifications-portal.md).


- **Programmatic Access**: Because these are Activity Log events, you can retrieve them using Azure’s APIs or command-line tools. Azure also provides Resource Graph queries to list service health events across resources. This programmatic access is helpful for integration with external systems or dashboards.<br> 
For information about using Azure Resource Graph (ARG) queries to create reports on your Service health notifications, see [Resource graph sample queries](resource-graph-samples.md). This document provides guidance on how to utilize the available queries.


## Service Health notification types

To help you stay ahead of potential disruptions, Azure categorizes service health events into six types, each indicating a different type of situation. Some event types are *actionable* (meaning you need to do something) and others are purely *informational*.
 

Here’s a breakdown of each notification type, what it means, and how you can access and retain these updates.

- **Action required** – *Actionable*. Azure detected something unusual or important in your subscription that needs your attention or intervention. For example, Azure could detect something that needs your attention—like a configuration problem or an upcoming change that could affect your service. When that happens, Azure sends you a notification explaining what’s happening and provides clear steps you can take to fix it or how to reach support for help. The notifications are proactively issued to prevent or fix potential problems.<br> 
*The notifications often appear in the Service Health portal under Health Advisories.* 

- **Incident** - *Informational (urgent service issue)*. This type represents a service outage or degradation (an unplanned event) that is currently affecting one or more of your Azure resources. Essentially, an Incident notification means Azure is experiencing a problem (for example, a data center issue) that impacts you. The notification describes the issue and keeps you updated on its status. While labeled informational, Incidents are critical to know about; you usually don’t fix them, but you might activate your contingency plans.<br>
*You typically see them under the Service Issues pane for active outages.*

- **Maintenance** – *Informational (scheduled event)*. This type is for planned maintenance activities that might affect your resources. Azure uses these notifications to inform you of upcoming maintenance windows, such as infrastructure upgrades or patches that could cause a brief downtime or performance impact. The notification includes the schedule and scope of the maintenance so you can prepare.<br>
*Maintenance notifications appear in the Planned Maintenance pane in the portal.* 

- **Information** – *Informational (advisory)*. These notifications are health advisories or suggestions that don’t require action, but provide useful information to optimize or improve your use of Azure. For example, Azure might send an informational notice about best practices or a heads-up about a non-urgent issue. In general, an Information type notification highlights potential optimizations or minor issues that don't directly impact service availability.<br>
*These notifications also show in under Health Advisories pane.*

- **Security** – *Actionable or informational (security-related)*. Security notifications warn you of urgent security issues or advisories related to your Azure resources or Azure services. For instance, if there’s a security vulnerability affecting an Azure service you’re using, or a configuration that exposes a security risk, Azure issues a Security advisory. Some security notifications might require you to act (for example, apply a patch or update your settings) while others might just inform you of a potential threat or fix.<br>
*These notifications are found in Security advisories pane in the portal.*

- **Billing** – *Informational (account notices)*. These notifications provide information about billing or subscription changes. They might notify subscription owners/contributors about things like upcoming billing updates, credit expiration, or other billing-related issues. Billing notifications are purely informational. You don't fix anything in Azure—if there’s a billing issue, you’d contact support or check your billing settings.<br>
*These notifications are shown in the Billing updates pane*.

## Service Health notifications data properties

### Event type
Service Health event properties are metadata fields in Azure Service Health notifications that describe the nature, severity, and lifecycle of an event. 

Key properties include *properties.incidentTyp*e (for example, *ServiceIssue*, or *PlannedMaintenance*), status (*Active* or *Resolved*), and timestamps such as *properties.impactStartTime* and *properties.impactMitigationTime*. <br>For more information about the data properties, see [Activity log - Service Health](/azure/azure-monitor/platform/activity-log-schema#service-health-category).

Start by checking *properties.incidentType* to understand what kind of issue and detail is involved, then review *Level* for severity. For more information, see [Service Health event tags](service-health-event-tags.md).

Use the *status* and *timestamps* to gauge whether the event is ongoing or resolved, and refer to the *title* for a quick description. These properties help you filter, prioritize, and act on service health alerts effectively. For more information, see [Service Health event tags](service-health-event-tags.md). 

The following table lists and describes all the properties found in a Service health event in the Activity log.

Property name | Description
-------- | -----------
channels | One of the following values: **Admin** or **Operation**.
correlationId | Usually a GUID in the string format. Events that belong to the same action usually share the same correlationId.
eventDataId | The unique identifier of an event.
eventName | The title of an event.
level | The level of an event.
resourceProviderName | The name of the resource provider for the impacted resource.
resourceType| The type of resource of the impacted resource.
subStatus | Usually the HTTP status code of the corresponding REST call, but can also include other strings describing a substatus. For example:<br> OK (HTTP Status Code: 200)<br> Created (HTTP Status Code: 201)<br> Accepted (HTTP Status Code: 202)<br> No Content (HTTP Status Code: 204)<br> Bad Request (HTTP Status Code: 400),<br> Not Found (HTTP Status Code: 404),<br> Conflict (HTTP Status Code: 409),<br> Internal Server Error (HTTP Status Code: 500)<br> Service Unavailable (HTTP Status Code: 503)<br> Gateway Timeout (HTTP Status Code: 504).
eventTimestamp | Timestamp when the event was generated, and the Azure service processing the request corresponding to the event.
submissionTimestamp | Timestamp when the event became available for querying.
subscriptionId | The Azure subscription in which this event was logged.
status | String describing the status of the operation. Values are: **Active**, and **Resolved**.
operationName | The name of the operation.
category | This property is always **ServiceHealth**.
resourceId | The Resource ID of the impacted resource.
Properties.title | The localized title for this communication. English is the default.
Properties.communication | The localized details of the communication with HTML markup. English is the default.
Properties.incidentType | One of the following values: **ActionRequired**, **Informational**, **Incident**, **Maintenance**, or **Security**.
Properties.trackingId | The incident this event is associated with. Use this tracking ID to correlate the events related to an incident.
Properties.impactedServices | An escaped JSON blob that describes the services and regions impacted by the incident. The property includes a list of services, each of which has a **ServiceName**, and a list of impacted regions, each of which has a **RegionName**.
Properties.defaultLanguageTitle | The communication in English.
Properties.defaultLanguageContent | The communication in English as either HTML markup or plain text.
Properties.stage | The possible values for **Incident**, and **Security** are **Active,** <br>**Resolved**, or **RCA**.<br> For **ActionRequired** or **Informational** the only value is **Active.** <br>For **Maintenance** they are: **Active**, **Planned**, **InProgress**, **Canceled**, **Rescheduled**, **Resolved**, or **Complete**.
Properties.communicationId | The communication this event is associated with.


### Incident type

The `properties.incidentType` field in Azure Service Health identifies the category of a health event, such as *ActionRequired*, *Incident*, *Maintenance*, *Security*, or *Informational*. Each type signals a different scenario—for example, *Incident* means an unplanned outage or degradation, while *Maintenance* indicates scheduled work, and *ActionRequired* alerts you to changes needing your intervention.

You can use this property to filter and prioritize notifications in the Azure portal, Resource Graph queries, or alert rules. For instance, you might configure alerts only for Incident and Security types to focus on critical issues, or query Maintenance events to plan for downtime. This information helps automate monitoring and ensures timely responses to events that matter most.

Service Health event type (`properties.incidentType`)

**Health Advisory** (properties.incidentType == ActionRequired)
- Informational - Administrator action is required to prevent an impact to existing services.
    
**Planned Maintenance** (properties.incidentType == Maintenance)
- Warning - Emergency maintenance
- Informational - Standard planned maintenance

**Health Advisory** (properties.incidentType == Informational)
- Informational - An administrator might be required to prevent an impact to existing services.

**Health Advisory** (properties.incidentType == Retirement)
- Retirement - Retirement reminder notifications for scenarios where less than three months are left from final date of Retirement.

**Security Advisory** (properties.incidentType == Security)
- Warning - Security advisory that affects existing services and might require administrator action.
- Informational - Security advisory that affects existing services.

**Service Issues** (properties.incidentType == Incident)
- Error - Widespread issues accessing multiple services across multiple regions are impacting a broad set of customers.
- Warning - Issues accessing specific services and/or specific regions are impacting a subset of customers.
- Informational - Issues impacting management operations and/or latency, not impacting service availability.
<!--
**Billing** (properties.incidentType == Billing)
- Informational - Issues impacting billing updates.
- -->

>[!NOTE]
> Billing notifications aren't shown in the Activity log found in the Azure portal. You see them in Azure Service Health. 

 ## For more information

- [Service Health Frequently asked Questions](service-health-faq.yml)
- [View Service Health notifications from the portal](service-notifications.md)
- [View and access Security advisories](security-advisories-elevated-access.md)