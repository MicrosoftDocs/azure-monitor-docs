---
title: Azure Service Health notifications data overview
description: An overview of Service Health notifications data properties
ms.topic: concept-article
ms.date: 02/23/2026

---

# Service Health notifications data properties


Azure Service Health notifications include different data properties depending on the **event type** (such as Service Issue, Planned Maintenance, Security Advisory, or Health Advisory) and its **incident type** (the specific scenario within that event). There are two ways to check the metadata of Service Health:
- The Activity Log
- Azure Resource Graph

Understanding the difference matters because each type carries its own purpose, required level of attention, and unique metadata that helps you interpret what’s happening to your resources. 

Event types describe the broad category of the issue Azure is reporting. Incident types add the specific context such as whether it’s a platform‑initiated outage, a scheduled maintenance update, or an advisory that might require action. 

When you know what each type of notification means, it becomes easier to decide what needs immediate action. It also helps you set up the right alerts and create dashboards or workflows that show the true effect on your environment. 

In other words, the event type tells you *why* Azure is contacting you. The incident details tell you *what to do next* to help you stay informed, maintain continuity, and act quickly and confidently when your services are affected.



## ServiceHealthResources table in Azure Resource Graph
Service Health **event** properties are metadata fields in Azure Service Health notifications that describe the nature, severity, and lifecycle of an event. 
For information about event tags, see [Service Health event tags](service-health-event-tags.md) to see how they're used in Service Health.

Key properties include
- **Type of Incident** from `properties.EventType` (for example, *ServiceIssue*, or *PlannedMaintenance*) 
- **properties.Status** as (*Active* or *Resolved*)
- **Timestamps** such as *properties.impactStartTime* and *properties.impactMitigationTime*

Start by checking *properties.incidentType* to understand what kind of issue and detail is involved, then review *Level* for severity. 

To learn how to use Resource Graph queries, see [Resource Graph overview](azure-resource-graph-overview.md).

## Azure Activity logs

<!--
Use the *status* and *timestamps* to gauge whether the event is ongoing or resolved, and refer to the *title* for a quick description. These properties help you filter, prioritize, and act on service health alerts effectively. 

For more information how long service health notifications are available, see [Service Health data transition](service-health-notification-transitions.md). 
-->
The following table lists and describes some representative properties found in a Service health event in the Activity log.

Key properties include
- **Type of Incident** from `properties.incidentType` (for example, *Incident*, or *Maintenance*) 
- **Status** as (*Active* or *Resolved*)
- **Timestamps** such as *properties.impactStartTime* and *properties.impactMitigationTime*

Start by checking **properties.incidentType** to understand what kind of issue and detail is involved, then check the *level* for the severity.
To learn how to use Azure Activity logs, see [Azure Activity log event schema](azure/azure-monitor/platform/activity-log-schema#service-health-category).

| Property name                     | Description                                                            |
| --------------------------------- | ---------------------------------------------------------------------- |
| correlationId                     | Usually a GUID in the string format. Events that belong to the same action usually share the same correlationId.|
| eventDataId                       | The unique identifier of an event.                                     |
| eventName                         | The title of the event.                                                |
| level                             | The level of the event.                                                |
| eventTimestamp                    | Timestamp when the event was generated, and the Azure service processing the request corresponding to the event. |
| submissionTimestamp               | Timestamp when the event became available for querying.                |
| subscriptionId                    | The Azure subscription in which this event was logged.                 |
| status                            | String describing the status of the operation. Values are: **Active**, and **Resolved**. |
| operationName                     | The name of the operation.                                             |
| category                          | This property is always **ServiceHealth**.                             |
| resourceId                        | The Resource ID of the impacted resource.                              |
| Properties.title                  | The localized title for this communication. English is the default.    |
| Properties.communication          | The localized details of the communication with HTML markup. English is the default. |
| Properties.incidentType           | One of the following values: **ActionRequired**, **Informational**, **Incident**, **Maintenance**, or **Security**. |
| Properties.trackingId             | The incident this event is associated with. Use this tracking ID to correlate the events related to an incident. |
| Properties.impactedServices       | An escaped JSON blob that describes the services and regions impacted by the incident. The property includes a list of services, each of which has a **ServiceName**, and a list of impacted regions, each of which has a **RegionName**. |
| Properties.defaultLanguageTitle   | The communication in English.                                          |
| Properties.defaultLanguageContent | The communication in English as either HTML markup or plain text.      |
| Properties.stage                  | The possible values for **Incident**, and **Security** are **Active,** <br>**Resolved**, or **RCA**.<br> For **ActionRequired** or **Informational** the only value is **Active.** <br>For **Maintenance** they are: **Active**, **Planned**, **InProgress**, **Canceled**, **Rescheduled**, **Resolved**, or **Complete**. |
| Properties.communicationId        | The communication this event is associated with.                       |

<!--
## Incident type

In Service Health, the **properties.incidentType** field tells you what kind of health event Azure is reporting. It categorizes the notification so you can immediately understand what type of situation you're looking at and how to respond. This field appears on every Service Health event and is one of the primary ways to filter, sort, and prioritize notifications.


The `properties.incidentType` field in Azure Service Health identifies the category of a health event, such as: 
- *ActionRequired* 
- *Incident* 
- *Maintenance* 
- *Security*
- *Informational*

Each type signals a different scenario, for example, *Incident* means an unplanned outage or degradation, while *Maintenance* indicates scheduled work, and *ActionRequired* alerts you to changes needing your intervention.

You can use this property to filter and prioritize notifications in the Azure portal, Resource Graph queries, or alert rules. For instance, you might configure alerts only for Incident and Security types to focus on critical issues, or query Maintenance events to plan for downtime. This information helps automate monitoring and ensures timely responses to events that matter most.

To see how the incident type fields are displayed in service health notifications, see [Service Health data transition](service-health-notification-transitions.md).
<!--
Service Health event type (`properties.incidentType`)

**Service Issues** (properties.incidentType == Incident)
- Error - Widespread issues accessing multiple services across multiple regions are impacting a broad set of customers.
- Warning - Issues accessing specific services and/or specific regions are impacting a subset of customers.
- Informational - Issues impacting management operations and/or latency, not impacting service availability.
  
**Planned Maintenance** (properties.incidentType == Maintenance)
- Warning - Emergency maintenance
- Informational - Standard planned maintenance

**Health Advisory** (properties.incidentType == Informational)
- Informational - Advisories or permanent changes with advanced notice. Action could be recommended to minimize and future impact, if any.
- Warning - Permanent changes that are approaching quickly with the potential for impact. Prompt action might be required.

**Security Advisory** (properties.incidentType == Security)
- Warning - Security advisory that affects existing services and might require administrator action.
- Informational - Security advisory that affects existing services.
-->

>[!NOTE]
> Billing notifications aren't shown in the Activity log located in the Azure portal. You only see them in Azure Service Health.

 ## For more information

- [Service Health Frequently asked Questions](service-health-faq.yml)
- [View Service Health notifications from the portal](service-notifications.md)
- [View and access Security advisories](security-advisories-elevated-access.md)
- [Service Health event tags](service-health-event-tags.md)
- [Service Health data transitions](service-health-notification-transitions.md)
- [Activity log - Service Health](/azure/azure-monitor/platform/activity-log-schema#service-health-category).
