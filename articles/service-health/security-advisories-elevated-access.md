---
title: Security advisories overview
description: This article describes the Security advisories pane and that users are required to obtain elevated access roles in order to view Security advisory details.
ms.topic: article
ms.date: 12/15/2025
---


# Security advisories

The Security advisories pane in Azure Service Health is a specialized dashboard designed to notify you about urgent security-related events that might affect your subscriptions.


:::image type="content"source="./media/security-advisories/security-advisories-main.PNG"alt-text="Screenshot of Service Health Security advisories pane."Lightbox="./media/security-advisories/security-advisories-main.PNG":::

The Security advisories pane is used to communicate critical security events such as:
- Platform vulnerabilities
- Security incidents
- Privacy breaches

These advisories are distinct from general health or service issues, because they often involve sensitive information and require elevated access roles to view all the details.

:::image type="content"source="./media/impacted-resource-sec/security-advisories-tab.PNG" alt-text="Screenshot of Service Health Security advisories summary tab."Lightbox="./media/impacted-resource-sec/security-advisories-tab.PNG":::

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
>For more information about Sercurity advisories using ARG queries, see [Azure Resource Graph sample queries for Service health](/azure/service-health/resource-graph-samples?branch=main&tabs=azure-cli#all-active-service-issue-events). This resource provides guidance on how to utilize the available queries.

## Who can view Security advisories?

Because the information in this tab is sensitive, specific Role-Based Access Control (RBAC) permissions are required to view security-impacted resources and sensitive details in the Azure portal or through APIs.

- Users must have appropriate **Role-Based Access Control (RBAC)** permissions at the subscription or tenant level.
- The **Summary** and **Issue Updates** tabs require an elevated role for sensitive security events, but for **Impacted Resources** you need Elevated access to view sensitive security communication.

- Users with only reader access can't view sensitive details unless they're assigned the appropriate elevated permissions.

For details about role requirements for accessing these resources, see [Viewing impacted resource and sensitive details from Azure security incidents](impacted-resources-security.md).

Users who have [roles with tenant admin access](admin-access-reference.md) can also access tenant-level security advisory details on the **Summary** and **Issue Updates** tabs.
<!--
### Configure a Tenant and Subscription to view Security advisories

1.  **Access the Azure portal**: Log into the Azure portal and navigate to the **Subscriptions** section.
1.  **Select the Subscription**: Choose the subscription that you want to manage for Security advisory access.
1.  **Navigate to Access Control (IAM)**: Select **Access control (IAM)** to manage user roles.
1.  **Add the role assignment**: Select **Add role assignment** to assign the necessary roles. <br>Users must have elevated roles such as *Owner* or *Contributor* to view sensitive information in Security advisories. Only users with elevated roles can access sensitive information on the Summary, Issue updates, and Impacted resources tabs.
1.  **Verify the user roles**: Ensure that the user you're assigning has the appropriate Role-Based Access Control (RBAC) permissions. <br>Users with only reader access can't view sensitive details unless they're assigned the appropriate elevated permissions.
1.  **Update the email addresses**: To ensure that security notifications are received, verify that the email address associated with the user in Azure Active Directory is current. 
    1.  Navigate to Azure Active Directory 
    1.  Select **Users**
    1.  Check the user’s profile for the correct email address 
Make sure that the Subscription Administrator and Tenant Global Admin roles have the right contact information to receive notifications for security issues impacting at the subscription and tenant levels.

For more information about assigning roles in Azure, see [Assign Azure roles using the Azure portal](/azure/role-based-access-control/role-assignments-portal).-->


### Access Service advisories through API endpoint

To access Security advisories through APIs, you must update your code to use the new **ARM endpoint (/fetchEventDetails)** to receive sensitive Security advisories notification details. Users with the specified roles can view sensitive event details for a specific event with the new endpoint.

The existing endpoint **(/events)** which returns all Service Health event types impacting a subscription or tenant, doesn't return sensitive security notification details.

For more information, see [Event- fetch Details by Tenant ID and Tracking ID](/rest/api/resourcehealth/event/fetch-details-by-tenant-id-and-tracking-id).

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
