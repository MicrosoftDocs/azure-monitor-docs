---
title: View and access Security advisories
description: This article describes the Security advisories pane and that users are required to obtain elevated access roles in order to view Security advisory details.

ms.topic: conceptual
ms.date: 8/08/2025
---


# View and access Security advisories

The Security advisories pane in Azure Service Health is a specialized dashboard designed to notify Azure customers about urgent security-related events that might affect their subscriptions. 


:::image type="content"source="./media/security-advisories/security-advisories-main.PNG"alt-text="Screenshot of Service Health Security Advisories pane."Lightbox="./media/security-advisories/security-advisories-main.PNG":::

The Security Advisories pane is used to communicate critical security events such as:
- Platform vulnerabilities
- Security incidents
- Privacy breaches

These advisories are distinct from general health or service issues, because they often involve sensitive information and require elevated access roles to view the full details. 

:::image type="content"source="./media/impacted-resource-sec/security-advisories-tab.PNG" alt-text="Screenshot of Service Health Security Advisories summary tab."Lightbox="./media/impacted-resource-sec/security-advisories-tab.PNG":::

Each advisory typically includes four key sections:

- **Summary** – An overview of the security event, including its nature and severity.
- **Impacted Services** – Lists of the Azure services affected by the incident.
- **Issue Updates** – A timeline of ongoing updates and the remediation steps.
- **Impacted Resources** – Specific resources in your environment that are affected.

Select the **Advisory name** link to open the tabs with the information you need.

>[!Note]
>Security advisories are displayed in the pane for up to 28 days if they are still active and if the impact time is in the future. After that they are moved to the health history panel where they are displayed for 90 days. 
>
>
>For more information about Sercurity advisories using ARG queries, see [Resource graph sample queries](resource-graph-samples.md). This resource provides guidance on how to utilize the available queries.

## Who can view Security advisories? 

Because the information in this tab is sensitive, specific Role-Based Access Control (RBAC) permissions are required to view security-impacted resources and sensitive details in the Azure portal or through APIs.

- Users must have appropriate **Role-Based Access Control (RBAC)** permissions at the subscription or tenant level.
- Only users with elevated roles can access sensitive information on the **Summary**, **Issue Updates**, and **Impacted Resources** tabs.
- Users with only reader access can't view sensitive details unless they're assigned the appropriate elevated permissions.

For details about role requirements for accessing these resources, see [Viewing impacted resource and sensitive details from Azure security incidents](impacted-resources-security.md).

Users who have [roles with tenant admin access](admin-access-reference.md) can also access tenant-level security advisory details on the **Summary** and **Issue Updates** tabs.




## Service Health API endpoint

To access Security Advisories through APIs, you must update your code to use the new **ARM endpoint (/fetchEventDetails)** to receive sensitive Security Advisories notification details. Users with the specified roles can view sensitive event details for a specific event with the new endpoint.

The existing endpoint **(/events)** which returns all Service Health event types impacting a subscription or tenant, doesn't return sensitive security notification details.

For more information, see [Event- fetch Details by Tenant ID and Tracking ID](/rest/api/resourcehealth/event/fetch-details-by-tenant-id-and-tracking-id)

The endpoints listed here return the security notification details for a specific event.

### New API endpoint details

Users need to be authorized with the roles defined here to access the new endpoint.
This endpoint returns the event object with all available properties for a specific event. 

<!--- Available since API version 2022-10-01-->


**Example**

```HTTP
https://management.azure.com/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/providers/microsoft.ResourceHealth/events/{trackingId}/fetchEventDetails?api-version=2023-10-01-preview 
```
Operation: POST

#### Impacted Resources for Security advisories

Customers authorized with the authorized roles, can use the following endpoints to access the list of resources impacted by a Security Incident.
<!--- Available since API version 2022-05-01-->

 
**Subscription**

```HTTP
https://management.azure.com/subscriptions/bbbb1b1b-cc2c-dd3d-ee4e-ffffff5f5f5f/providers/microsoft.resourcehealth/events/{trackingId}/listSecurityAdvisoryImpactedResources?api-version=2025-05-01 
```
Operation: POST
For more information see [Security Advisories Impacted Resources](https://learn.microsoft.com/rest/api/resourcehealth/security-advisory-impacted-resources/list-by-subscription-id-and-event-id?view=rest-resourcehealth-2025-05-01&tabs=HTTP)

**Tenant**

```HTTP
https://management.azure.com/providers/microsoft.resourcehealth/events/{trackingId}/listSecurityAdvisoryImpactedResources?api-version=2025-05-01
```
Operation: POST
For more information see [Security Advisories Impacted Resources](https://learn.microsoft.com/rest/api/resourcehealth/security-advisory-impacted-resources/list-by-subscription-id-and-event-id?view=rest-resourcehealth-2025-05-01&tabs=HTTP)

#### Existing Events API Endpoint

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


## Next steps

* [Keep informed about Azure security events](stay-informed-security.md)
* [Resource impact from Azure security incidents](impacted-resources-security.md)
* [Resource Health frequently asked questions](resource-health-faq.yml)
* [Service Health frequently asked questions](service-health-faq.yml)
