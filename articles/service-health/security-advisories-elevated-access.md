---
title: Elevated access for viewing Security Advisories
description: This article details a change that requires users to obtain elevated access roles in order to view Security Advisory details
ms.topic: article
ms.date: 5/22/2025
---

# Elevated access for viewing Security Advisories


This article explains how to access and interpret Security Advisories in Azure Service Health, which notify users about security events that might impact their Azure resources.

## What are Security Advisories?

Security Advisories are notifications about security events affecting Azure services. They're displayed in the Azure Service Health portal under the "Security advisories" blade.

Azure [Service Health](service-health-overview.md) helps customers stay informed about security events that could affect both critical and non-critical business applications. These notifications appear in the Security Advisories section of the portal.

Each advisory includes four key tabs: **Summary**, **Impacted Services**, **Issue Updates**, and **Impacted Resources**, providing a comprehensive view of the event.


:::image type="content" source="./media/impacted-resource-sec/security-advisories-tab.PNG" alt-text="Screenshot of Service Health Security Advisories Blade."Lightbox="./media/impacted-resource-sec/security-advisories-tab.PNG":::

## Who can view Security Advisories?

- Security Advisories are displayed to users at the subscription or tenant level.
- Only users with elevated access roles can access the information on the summary and issue update tabs for sensitive security events. For more information on elevated access subscription and tenant roles, see [Resource impact from Azure security incidents](impacted-resources-security.md).
- Users with tenant roles [listed here](admin-access-reference.md) can also access tenant level security advisory details on the **Summary** and **Issue Updates** tabs.



## What are Impacted Resources within Security Advisories?

Since details displayed in this tab are sensitive, Role-Based Access Control (RBAC) is required for customers viewing security impacted resources via UI or API. For more information, read [this article](impacted-resources-security.md) for more information on the current RBAC requirements for accessing security impacted resources.


## Accessing Security Advisories

Accessing sensitive data for Security Advisories requires elevated access across the Summary, Impacted Services, Issue Updates, and Impacted Resources tabs. Users who have subscription reader access, or tenant roles at tenant scope can't view sensitive security advisory details until they get the required roles.

### On the Service Health portal

Only users with elevated access roles can access sensitive information on the **Summary**, **Impacted Resources**, and **Issue Updates** tab.

### Service Health API Changes

API users need to update their code to use the new **ARM endpoint (/fetchEventDetails)** to receive sensitive Security Advisories notification details. Users with the specified roles can view sensitive event details for a specific event with the new endpoint. The existing endpoint **(/events)** which returns all Service Health event types impacting a subscription or tenant, doesn't return sensitive security notification details. <!--This update will be made to API version 2023-10-01-preview and future versions.-->

The <!--new and existing--> endpoints listed here <!--will--> return the security notification details for a specific event.

#### New API Endpoint Details

- Users need to be authorized with the above-mentioned roles to access the new endpoint.
- This endpoint returns the event object with all available properties for a specific event. 

<!--- Available since API version 2022-10-01-->


**Example**

```HTTP
https://management.azure.com/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/providers/microsoft.ResourceHealth/events/{trackingId}/fetchEventDetails?api-version=2023-10-01-preview 
```
Operation: POST

#### Impacted Resources for Security Advisories

Customers authorized with the above-mentioned roles can use the following endpoints to access the list of resources impacted by a Security Incident.
<!--- Available since API version 2022-05-01-->

 
**Subscription**

```HTTP
https://management.azure.com/subscriptions/bbbb1b1b-cc2c-dd3d-ee4e-ffffff5f5f5f/providers/microsoft.resourcehealth/events/{trackingId}/listSecurityAdvisoryImpactedResources?api-version=2023-10-01-preview 
```
Operation: POST

**Tenant**

```HTTP
https://management.azure.com/providers/microsoft.resourcehealth/events/{trackingId}/listSecurityAdvisoryImpactedResources?api-version=2023-10-01-preview
```
Operation: POST

#### Existing Events API Endpoint

**Security Advisories Subscription List Events** 

The current Events API, which lists all events, including sensitive security ones, will stop including certain sensitive details for security-related events:<br> (Events marked as 'eventType': 'Security' and 'isEventSensitive'= true).
<!--With API version 2023-10-01-preview (and future API versions), The existing Events API endpoint which returns the list of events (including sensitive security events with property 'eventType' : `Security` and property 'isEventSensitive' = true) will be restricted to not pass sensitive properties listed below for security events.-->

```HTTP
https://management.azure.com/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/providers/microsoft.ResourceHealth/events?api-version=2023-10-01-preview&$filter= "eventType eq SecurityAdvisory"
```
Operation: GET

The following properties in the events object response aren't populated for sensitive Security Advisories events using this endpoint:

* Summary
* Description
* Updates


## Next steps

* [Keep informed about Azure security events](stay-informed-security.md)
* [Resource impact from Azure security incidents](impacted-resources-security.md)
* [Azure Resource Health frequently asked questions](resource-health-faq.yml)
