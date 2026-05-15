---
title: Azure Service Health Notification Data Transitions
description: This article explains how Azure Service Health notification data moves from an Active status to a Resolved status.
ms.topic: concept-article

ms.date: 04/30/2026

---

# Service Health notifications: Data transitions

Azure Service Health notifications in Azure transition from any **Active** pane to the **History** pane when the status of the event changes from **Active** to **Resolved**.

This move ensures that only ongoing issues remain visible in the **Active** view. Completed events are archived for reference.

In this article, you learn about the lifecycle of Service Health notifications, including the reasons for transitions between the panes, ways to view past records, and how long they're retained.

>[!TIP]
>The field `impactMitigationTime` is the API field name, and `End time` is the name on the user interface.

## How notifications move from Active to History status

Each communication category pane (**Incidents**, **Planned maintenance**, **Health advisories**, **Security advisories**, and **Billing updates**) uses distinct logic to determine event transitions. This logic determines when an event moves from its category tab to the **Health history** pane as defined in this table.

|Event type  |Severity levels |Event tags |When event moves to Health history pane  | Event details moved from Health history pane, but available through REST API | Event details archived and inaccessible through REST API|
|---------|---------|---------|---------|
|**Service issues**       | Error: Widespread issues accessing multiple services across multiple regions are affecting a broad set of customers.<br>Warning: Issues accessing specific services or specific regions are affecting a subset of customers.<br>Informational: Issues affecting management operations or latency, but not affecting service availability.      | Action recommended<br>- Final post-incident review (PIR)<br>- Preliminary PIR<br>False positive   | 90 days, as long as it's active or updated. |90 days from most recent published date| One year from most recent published date   |
|**Planned maintenance**   | Warning: Emergency maintenance. <br> Informational: Standard planned maintenance. | N/A         | Schedule's end date is passed,<br> or 50 days from the schedule's start date.        |90 days from most recent published date   |One year from most recent published date    |
|**Security advisories**              |Warning: Security advisory that affects existing services and might require administrator action.<br>Informational: Security advisory that affects existing services. |Action recommended<br>- Final PIR<br>- Preliminary PIR<br>False positive         | 90 days, as long as it's active or updated.        | 90 days from most recent published date  | One year from most recent published date   |
|**Health advisories**     |Warning: Permanent changes that are approaching quickly with the potential for impact. Prompt action might be required.<br> Informational: Advisories or permanent changes with advanced notice. Action might be recommended to minimize any future impact (if any). | Retirement         | 90 days, as long as it's active or updated.  | 90 days from most recent published date  | One year from most recent published date   |
|**Billing updates**              |Informational: Issues affecting billing updates.   | N/A        | 60 days after the event is created, and then it moves to Health history.        | 90 days from most recent published date  | One year from most recent published date   |

For more information, see [Service Health notifications](service-health-notifications-properties.md).