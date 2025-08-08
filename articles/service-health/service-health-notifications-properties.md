---
title: Azure service health notifications
description: Service health notifications allow you to view service health messages published by Microsoft Azure.
ms.topic: article
ms.date: 08/08/2025

---

# Service health notifications

Service health notifications created through Azure, contain information about the resources under your subscription. These notifications are a subclass of activity log events, and can also be found in the activity log. Service health notifications can be informational or actionable, depending on the class.

There are various classes of service health notifications:  

- **Action required:** Azure might notice something unusual happens on your account, and work with you to remedy the issue. Azure sends you a notification, either detailing the actions you need to take or how to contact Azure engineering or support.  
- **Incident:** An event that impacts service is currently affecting one or more of the resources in your subscription.  
- **Maintenance:** A planned maintenance activity that might affect one or more of the resources under your subscription.  
- **Information:** Potential optimizations that might help improve your resource use. 
- **Security:** Urgent security-related information regarding your solutions that run on Azure.
- **Billing:** Information about billing updates for users with subscription owner/contributor roles.

Each communication category panel - Incidents, Planned Maintenance, Health Advisories, Security Advisories, and Billing - uses distinct logic to determine event transitions. This logic determines when an event moves from its category tab to the Health History panel as defined in the following table.


|**Event**  |**Severity levels** |**Event tags** |**When Event is moved to Health History panel**  | **Event details moved from Health History panel, but available through REST API** | **Event details archived and inaccessible through REST API**|
|---------|---------|---------|---------|
|**Service Issues** | **Error** - Widespread issues accessing multiple services across multiple regions are impacting a broad set of customers.<br>**Warning** - Issues accessing specific services and/or specific regions are impacting a subset of customers.<br>**Informational** - Issues impacting management operations and/or latency, not impacting service availability.      | Action Recommended<br>Final PIR<br>Preliminary PIR<br>False Positive   |  Three days       | 90 days from most recent published date| One year from most recent  published date   |
|**Planned Maintenance**   | **Warning** - Emergency Maintenance <br> **Informational** - Standard Planned Maintenance | N/A         | Schedule's EndDate passed<br> Or 50 days from Schedule's StartDate        |90 days from most recent published date   |One year from most recent  published date    |
|**Security**     |**Warning** - Security advisory that affects existing services and might require administrator action<br>**Informational** - Security advisory that affects existing services |Action Recommended<br>Final PIR<br>Preliminary PIR<br>False Positive         |         | 90 days from most recent published date  | One year from most recent  published date   |
|**Health Advisories**<br>-Action Required<br>- Informational<br>- Product Retirement notifications |**Warning** - Retirement reminder notifications for scenarios where less than 3 months are left from final date of Retirement<br> -**Informational** - Administrator might be required to prevent impact to existing services. | Retirement         |         | 90 days from most recent published date  | One year from most recent  published date   |
|**Billing**     |**Informational** - Issues impacting billing updates   | N/A        |         | 90 days from most recent published date  | One year from most recent  published date   |



For more information about using Azure Resource Graph (ARG) queries, see [Resource graph sample queries](resource-graph-samples.md). This resource provides guidance on how to utilize the available queries.




Each service health notification includes details on the scope and impact to your resources. Details include:

Property name | Description
-------- | -----------
channels | One of the following values: **Admin** or **Operation**.
correlationId | Usually a GUID in the string format. Events that belong to the same action usually share the same correlationId.
eventDataId | The unique identifier of an event.
eventName | The title of an event.
level | The level of an event
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
Properties.stage | The possible values for **Incident**, and **Security** are **Active,** **Resolved, or **RCA**. For **ActionRequired** or **Informational** the only value is **Active.** For **Maintenance** they are: **Active**, **Planned**, **InProgress**, **Canceled**, **Rescheduled**, **Resolved**, or **Complete**.
Properties.communicationId | The communication this event is associated with.

### Details on service health level information

Service Health event type (properties.incidentType)

**Health Advisory** (properties.incidentType == ActionRequired)
- Informational - Administrator action is required to prevent impact to existing services.
    
**Planned Maintenance** (properties.incidentType == Maintenance)
- Warning - Emergency maintenance
- Informational - Standard planned maintenance

**Health Advisory** (properties.incidentType == Informational)
- Informational - Administrator might be required to prevent impact to existing services.

**Health Advisory** (properties.incidentType == Retirement)
- Retirement - Retirement reminder notifications for scenarios where less than three months are left from final date of Retirement.

**Security Advisory** (properties.incidentType == Security)
- Warning - Security advisory that affects existing services and might require administrator action.
- Informational - Security advisory that affects existing services.

**Service Issues** (properties.incidentType == Incident)
- Error - Widespread issues accessing multiple services across multiple regions are impacting a broad set of customers.
- Warning - Issues accessing specific services and/or specific regions are impacting a subset of customers.
- Informational - Issues impacting management operations and/or latency, not impacting service availability.

**Billing** (properties.incidentType == Billing)
- Informational - Issues impacting billing updates. 