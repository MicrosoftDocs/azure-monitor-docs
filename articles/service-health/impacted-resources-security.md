---
title: Impacted resources from Azure security incidents
description: This article details where to find information from Azure Service Health about how Azure security incidents impact your resources.
ms.topic: concept-article
ms.date: 12/11/2025
---

# Impacted resources from Azure security incidents

To support of the experience of viewing impacted resources, Service Health contains a feature that:

- Displays resources impacted by a security incident.
- Enables Role-Based Access Control (RBAC) for viewing security incident impacted resource information.

This article explains what and where you can view information about your impacted resources.

>[!Note]
>This feature will be rolled out in phases. The rollout will gradually expand to 100 percent of subscription and tenant customers.

## Role Based Access (RBAC) For Sensitive Security incident resource impact and sensitive details

[Azure role-based access control (Azure RBAC)](/azure/role-based-access-control/overview) helps you manage who has access to Azure resources, what they can do with those resources, and what areas they have access to.<br> 
Given the sensitive nature of security incidents, role-based access is used to limit the audience of their impacted resource information. <!--
Along with resource information, Service Health provides the information shown here to users whose resources are impacted from a security incident: -->

Users with the authorized roles shown here can view security impacted resource information and sensitive details such as description, summary, and updates:

**Subscription level**
- Service Health Security reader
- Subscription Owner
- Subscription Admin
- Custom Roles with
  <br>Microsoft.ResourceHealth/events/fetchEventDetails/action <br>Microsoft.ResourceHealth/events/listSecurityAdvisoryImpactedResources/action <br>Microsoft.ResourceHealth/events/action permissions

**Tenant level**
- Security Admin
- Global Admin/Tenant Admin
- Custom Roles with <br>Microsoft.ResourceHealth/events/fetchEventDetails/action <br>Microsoft.ResourceHealth/events/listSecurityAdvisoryImpactedResources/action <br>Microsoft.ResourceHealth/events/action permissions

**Contributor level**
- Custom Roles with
  <br>Microsoft.ResourceHealth/events/fetchEventDetails/action <br>Microsoft.ResourceHealth/events/listSecurityAdvisoryImpactedResources/action <br>Microsoft.ResourceHealth/events/action permissions
- Built-in Roles see [Azure Built-in roles](/azure/role-based-access-control/built-in-roles/privileged#contributor).




## Viewing Impacted Resources for Security Incidents on the Service Health Portal

In the Azure portal, the **Impacted Resources** tab under **Service Health** > **Security Advisories** displays resources impacted from a security incident. Along with resource information, Service Health provides the information shown here to users whose resources are impacted from a security incident:

|Column  |Description |
|---------|---------|
|**Subscription ID**|Unique ID for the subscription that contains the impacted resource|
|**Subscription Name**|Name for the subscription that contains the impacted resource|
|**Tenant Name**|Name for the tenant that contains the impacted resource|
|**Tenant ID**|Unique ID for the tenant that contains the impacted resource|

The following examples show a security incident with impacted resources from the subscription and tenant scope.

**Subscription**

:::image type="content" source="./media/impacted-resource-sec/impact-security.PNG" alt-text="Screenshot of information about impacted resources from subscription scope in Azure Service Health."Lightbox="./media/impacted-resource-sec/impact-security.PNG":::

**Tenant**

:::image type="content" source="./media/impacted-resource-sec/security-tenant.PNG" alt-text="Screenshot of information about impacted resources from tenant scope in Azure Service Health."Lightbox="./media/impacted-resource-sec/security-tenant.PNG":::


## Accessing Impacted Resources programmatically via an API

You can retrieve information about impacted resources for security incidents using the Events API program. Authorized users with the specified roles can access the list of resources impacted by a security incident using the endpoints provided here. For details on how to access this data, see the [API documentation](/rest/api/resourcehealth/2022-10-01/security-advisory-impacted-resources).

**Subscription**

```HTTP
https://management.azure.com/subscriptions/<Subscription ID>/providers/microsoft.resourcehealth/events/<Tracking ID>/listSecurityAdvisoryImpactedResources?api-version=2025-05-01
```

**Tenant**

```HTTP
https://management.azure.com/providers/microsoft.resourcehealth/events/("Tracking ID")/listSecurityAdvisoryImpactedResources?api-version=2025-05-01
```

## Next steps
- [Introduction to the Azure Service Health dashboard](service-health-overview.md)
- [Introduction to Azure Resource Health](resource-health-overview.md)
- [Azure Resource Health frequently asked questions](resource-health-faq.yml)
