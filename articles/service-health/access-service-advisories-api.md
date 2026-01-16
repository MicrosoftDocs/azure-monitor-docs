---
title: How to access Security advisories through API endpoint
description: This article describes how to access Security advisories using API endpoint.
ms.topic: quickstart
ms.date: 01/16/2026
---

# How to access Service advisories through API endpoint

Accessing data through an API endpoint lets you retrieve Security Advisory information programmatically instead of relying only on the Azure portal. 

Knowing this tool is useful if you want to automate monitoring, integrate advisory data into existing tools, or build custom workflows while still respecting role‑based access and security requirements. This article provides details and steps to guide you on the process.

To access Security advisories through APIs, you must update your code to use the new **ARM endpoint (/fetchEventDetails)** to receive sensitive Security advisories notification details. Users with the specified roles can view sensitive event details for a specific event with the new endpoint.

The existing endpoint **(/events)** which returns all Service Health event types impacting a subscription or tenant, doesn't return sensitive security notification details.

For more information, see [Event- fetch Details by Tenant ID and Tracking ID](/rest/api/resourcehealth/event/fetch-details-by-tenant-id-and-tracking-id).
For information about Security advisories, refer to [Security advisories overview](security-advisories-elevated-access.md).

The endpoints listed here return the security notification details for a specific event.

## New API endpoint details

Users need to be authorized with the roles defined here to access the new endpoint.
This endpoint returns the event object with all available properties for a specific event.

<!--- Available since API version 2022-10-01-->


**Example**

```HTTP
https://management.azure.com/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/providers/microsoft.ResourceHealth/events/{trackingId}/fetchEventDetails?api-version=2023-10-01-preview 
```
Operation: POST

#### Impacted resources for Security advisories

Customers authorized with the authorized roles, can use the following endpoints to access the list of resources impacted by a Security Incident.
<!--- Available since API version 2022-05-01-->

 
**Subscription**

```HTTP
https://management.azure.com/subscriptions/bbbb1b1b-cc2c-dd3d-ee4e-ffffff5f5f5f/providers/microsoft.resourcehealth/events/{trackingId}/listSecurityAdvisoryImpactedResources?api-version=2025-05-01 
```
Operation: POST

For more information, see [Security Advisories Impacted Resources](/rest/api/resourcehealth/security-advisory-impacted-resources/list-by-subscription-id-and-event-id).

**Tenant**

```HTTP
https://management.azure.com/providers/microsoft.resourcehealth/events/{trackingId}/listSecurityAdvisoryImpactedResources?api-version=2025-05-01
```
Operation: POST

For more information, see [Security Advisories Impacted Resources](/rest/api/resourcehealth/security-advisory-impacted-resources/list-by-subscription-id-and-event-id).

#### Existing events API endpoint

**Security advisories Subscription List Events** 

The current Events API, which lists all events, including sensitive security ones, stops including certain sensitive details for security-related events (events marked as `eventType`: `Security` and `isEventSensitive` = true).
<!--With API version 2023-10-01-preview (and future API versions), The existing Events API endpoint which returns the list of events (including sensitive security events with property 'eventType' : `Security` and property 'isEventSensitive' = true) will be restricted to not pass sensitive properties listed below for security events.-->

```HTTP
https://management.azure.com/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/providers/microsoft.ResourceHealth/events?api-version=2023-10-01-preview&$filter= "eventType eq SecurityAdvisory"
```
Operation: GET

The following properties in the events object response aren't populated for sensitive Security Advisories events using this endpoint:

* Summary
* Description
* Updates


## More information

* Read [Keep informed about Azure security events](stay-informed-security.md)
* Read [Resource impact from Azure security incidents](impacted-resources-security.md)
* Read [Resource Health frequently asked questions](resource-health-faq.yml)
* Read [Service Health frequently asked questions](service-health-faq.yml)
