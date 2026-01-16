---
title: Security advisories overview
description: This article describes the Security advisories pane and that users are required to obtain elevated access roles in order to view Security advisory details.
ms.topic: article
ms.date: 01/16/2026
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
>For more information about Security advisories using ARG queries, see [Azure Resource Graph sample queries for Service health](/azure/service-health/resource-graph-samples?branch=main&tabs=azure-cli#all-active-service-health-events). This resource provides guidance on how to utilize the available queries.

## Who can view Security advisories?

Access to Security Advisories depends on what information is included in the advisory and the assigned Role‑Based Access Control (RBAC) permissions.

Security Advisory data falls into two categories: non‑sensitive fields and sensitive fields. Access is enforced consistently across tabs and scopes.

### Non‑sensitive (informational) fields

**What's included**
- Advisory title and description
- High‑level issue summary
- General guidance that is publicly available
- Status updates that don’t expose customer‑specific security posture

**Who can access**
- Users with standard Azure Service Health RBAC permissions.
- Users with the **Reader** or **Monitoring Reader** roles.

**Where are they accessible**
- Summary tab
- Issue Updates tab
- Subscription-level view

These fields are available for Informational Security Advisories and for the non‑sensitive portions of advisories that contain sensitive data.



### Sensitive fields

Security Advisories are classified as sensitive when they include information that could:
- Reveal customer security posture
- Enable targeted exploitation
- Disclose mitigation, remediation, or recovery status
- Identify impacted resources or configurations

**Sensitive fields include** 
- Impacted resources
- Resource-level or configuration-specific details
- Tenant-level exposure information
- Mitigation or remediation progress tied to customer assets

**Access to sensitive fields**

To view sensitive Security Advisory fields, users must have:
- **Owner** or **Contributor** role
- A custom role that includes the required Security Advisory permissions

Users assigned only **Reader** or **Monitoring Reader** roles:
- Can't view sensitive fields
- See an access-required message in place of any restricted data 

### Access fields by type and scope

**Summary and Issue Updates tabs**
- **Non-sensitive** fields are accessible with Standard Service Health RBAC permissions.
- **Sensitive** fields require elevated permissions

**Tenant-level access**
- Users assigned **Tenant Administrator** roles can view tenant‑level sensitive Security Advisory details in the Summary and Issue Updates tabs when advisories contain sensitive information.

**Impacted Resources tab**
- Always treated as sensitive
- Requires elevated permissions for all advisories regardless of classification
- Enforced at **Resource**, **Subscription**, and **Tenant Scope**


|Field Type                  |Examples                                    |Required Roles                    |
|----------------------------|--------------------------------------------|----------------------------------|
|Non-sensitive               |Summary text, general guidance              |Reader, Monitoring Reader         |
|Sensitive                   |Impacted resources, configs                 |Owner, Contributor, or custom role|
|Impacted Resources          |Resource‑level details                      |Elevated roles only               |
|Tenant‑level sensitive data |Tenant exposure views                       |Tenant administrator roles        |

 
**More information**
For more information about role requirements to view impacted resources and sensitive details, see [Viewing impacted resource and sensitive details from Azure security incidents](impacted-resources-security.md).

For guidance on configuring subscription‑ or tenant‑level access to Security Advisories, see [Configure subscriptions for Security Advisories](security-advisories-add-subscription.md).



## More information

* Read [Keep informed about Azure security events](stay-informed-security.md)
* Read [Resource impact from Azure security incidents](impacted-resources-security.md)
* Read [Resource Health frequently asked questions](resource-health-faq.yml)
* Read [Service Health frequently asked questions](service-health-faq.yml)
