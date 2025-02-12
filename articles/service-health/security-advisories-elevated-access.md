---
title: Elevated access for viewing Security Advisories
description: This article details a change that requires users to obtain elevated access roles in order to view Security Advisory details
ms.topic: conceptual
ms.date: 2/11/2025
---

# Elevated access for viewing Security Advisories


This article details how users are required to obtain elevated access roles in order to view Security Advisory details on Azure Service Health.

## What are Security Advisories?

Azure customers use [Service Health](service-health-overview.md) to stay informed about security events that are impacting their critical and noncritical business applications. Security event notifications are displayed on Azure Service Health within the Security Advisories blade. Important security advisory details are displayed in four tabs: Summary, Impacted Services, Issue Updates, and Impacted Resources.


:::image type="content" source="./media/impacted-resource-sec/security-advisories-tab.PNG" alt-text="Screenshot of Service Health Security Advisories Blade.":::

## Who can view Security Advisories?

- Security Advisories are displayed to users at the subscription or tenant level. 
- Users with tenant roles [listed here](admin-access-reference.md) can also access tenant level security advisory details on the **Summary** and **Issue Updates** tabs.
- Only users with elevated access roles can access the information on the summary and issue update tabs.
  For more information on subscription and tenant roles, see [Resource impact from Azure security incidents](impacted-resources-security.md).


## What are Impacted Resources within Security Advisories?

Since details displayed in this tab are sensitive, role based access (RBAC) is required for customers viewing security impacted resources via UI or API. [Review this article](impacted-resources-security.md) for more information on the current RBAC requirements for accessing security impacted resources.


## Accessing Security Advisories

Accessing Security Advisories requires elevated access across the Summary, Impacted Services, Issue Updates, and Impacted Resources tabs. Users who have subscription reader access, or tenant roles at tenant scope can't view security advisory details until they get the required roles.

### 1. On the Service Health portal
A banner is displayed to users<!-- until April 2024--> on the Summary and Issue Updates tabs prompting customers to get the right roles to view these tabs in future. 


## What changed in Security Advisories?

Accessing Security Advisories now requires elevated access across the **Summary**, **Impacted Resources**, and **Issue Updates** tabs. Users who have subscription reader access, or tenant roles at tenant scope, aren't able anymore to view security advisory details until they get the required roles.

### 1. On the Service Health portal

Only users with elevated access roles can access the information on the **Summary**, **Impacted Resources**, and **Issue Updates** tab.

### 2. Service Health API Changes

Events API users need to update their code to use the new **ARM endpoint (/fetchEventDetails)** to receive Security Advisories notification details. If users have the above-mentioned roles, they can view event details for a specific event with the new endpoint. The existing endpoint **(/events)** that returns all Service Health event types impacting a subscription or tenant, don't return sensitive security notification details. <!--This update will be made to API version 2023-10-01-preview and future versions.-->

The <!--new and existing--> endpoints listed here <!--will--> return the security notification details for a specific event.

#### New API Endpoint Details

- To access the new endpoint, users need to be authorized with the above-mentioned roles. 
- This endpoint returns the event object with all available properties for a specific event. 

<!--- Available since API version 2022-10-01-->


**Example**

```HTTP
https://management.azure.com/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/providers/microsoft.ResourceHealth/events/{trackingId}/fetchEventDetails?api-version=2023-10-01-preview 
```
Operation: POST

#### Impacted Resources for Security Advisories

- Customers authorized with the above-mentioned roles can use the following endpoints to access the list of resources impacted by a Security Incident
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


<!--With API version 2023-10-01-preview (and future API versions),--> The existing Events API endpoint which returns the list of events (including security events with event Type: “Security”) will be restricted to pass only nonsensitive properties listed below for security events. 

```HTTP
https://management.azure.com/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/providers/microsoft.ResourceHealth/events?api-version=2023-10-01-preview&$filter= "eventType eq SecurityAdvisory"
```
Operation: GET

The following values in the events object response are populated for security Advisories events using this endpoint:

* ID
* name
* type
* nextLink
* properties

Only the following are populated in the properties object:

* eventType
* eventSource
* status
* title
* platformInitiated
* level
* eventLevel
* isHIR
* priority
* subscriptionId
* lastUpdateTime
* impact

The impactedService property is populated for the impact object, but only the following properties in the impactedServiceRegion object in the impact object are populated:

* impactedService
* impactedSubscriptions
* impactedTenants
* impactedRegion
* status

## Next steps

* [Keep informed about Azure security events](stay-informed-security.md)
* [Resource impact from Azure security incidents](impacted-resources-security.md)
* [Frequently asked questions about Azure Resource Health](resource-health-faq.yml)
