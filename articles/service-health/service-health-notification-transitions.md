---
title: Azure service health notification data transitions
description: Service health notification data moving from active to resolved explained.
ms.topic: article
ms.date: 10/24/2025

---

# Service Health notifications - data transitions

Service Health notifications in Azure transition from any **Active** pane to the **History** pane when the status of the event changes from Active to Resolved. 

This move ensures that only ongoing issues remain visible in the Active view, while completed events are archived for reference.

In this article, you learn about the lifecycle of Service Health notifications, including the reasons for transitions between pans, ways to view past records, and how long they're retained.

## How notifications move from active to history

Each communication category panel - Incidents, Planned maintenance, Health advisories, Security advisories, and Billing updates - uses distinct logic to determine event transitions. This logic determines when an event moves from its category tab to the Health history panel as defined in this table.

|Event  |Severity levels |Event tags |When Event is moved to Health history panel  | Event details moved from Health history panel, but available through REST API | Event details archived and inaccessible through REST API|
|---------|---------|---------|---------|
|**Service Issues**       | **Error** - Widespread issues accessing multiple services across multiple regions are impacting a broad set of customers.<br>**Warning** - Issues accessing specific services and/or specific regions are impacting a subset of customers.<br>**Informational** - Issues impacting management operations and/or latency, not impacting service availability.      | Action Recommended<br>- Final PIR<br>- Preliminary PIR<br>False Positive   | 90 days as long as it's active or updated | When resolved| One year from most recent published date   |
|**Planned maintenance**   | **Warning** - Emergency Maintenance <br> **Informational** - Standard Planned Maintenance | N/A         | Schedule's EndDate passed<br> Or 50 days from Schedule's StartDate        |90 days from most recent published date   |One year from most recent published date    |
|**Security**              |**Warning** - Security advisory that affects existing services and might require administrator action<br>**Informational** - Security advisory that affects existing services |Action Recommended<br>- Final Post Incident Review (PIR)<br>- Preliminary PIR<br>False Positive         |         | 90 days from most recent published date  | One year from most recent  published date   |
|**Health advisories**     |**Warning** - Retirement reminder notifications for scenarios where less than 3 months are left from final date of Retirement<br> -**Information** - An administrator might be required to prevent an effect to existing services. | Retirement         |         | 90 days from most recent published date  | One year from most recent  published date   |
|**Billing**              |**Informational** - Issues impacting billing updates   | N/A        |         | 90 days from most recent published date  | One year from most recent  published date   |

For more information, see [Service Health notifications](service-health-notifications-properties.md).