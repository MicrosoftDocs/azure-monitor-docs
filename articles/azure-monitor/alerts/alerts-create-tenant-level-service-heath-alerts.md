---
title: Create Tenant Level Service Health Alerts (preview)
description: This article shows you how to create tenant level service health alerts in the Azure portal and provides some troubleshooting guidance.
ms.topic: how-to
ms.date: 08/05/2025
ms.reviewer: harelbr
---

# Create tenant level service health alerts (preview)

This article shows you how to create tenant level service health alerts in the Azure portal and provides some troubleshooting guidance.

## Use the Azure portal

1. In the Azure portal, navigate to **Monitor** \> **Service Health**.
1. Select **Create service health alert**. A context pane opens.
1. Under **Scope**, select the **Scope level** as Directory. The current directory is displayed.

    :::image type="content" source="media/shared/tenant-level-service-health-alert-rules-1.png" alt-text="Screenshot of tenant level alert interface in the azure portal screenshot 1":::

1. Under the **Condition** section, select the services, regions, and event types you’re interested in monitoring.
1. Under the **Details** section, name the alert rule and select where to save it.

## Use the alert rule creation wizard

1. In the Azure portal, navigate to **Monitor** \> **Alerts**.
1. Select **Create** \> **Alert rule**. The alert rule creation wizard opens.

    :::image type="content" source="media/shared/tenant-level-service-health-alert-create-rule-1.png" alt-text="Screenshot of tenant level alert interface in the azure portal screenshot 2":::

1. In the **Scope** tab, select the **Scope level** as Directory. The current directory is displayed.
1. In the **Condition** section, select the services, regions, and event types you’re interested in monitoring.

    :::image type="content" source="media/shared/tenant-level-service-health-alert-create-rule.png" alt-text="Screenshot of tenant level alert interface in the azure portal screenshot 3":::

1. Continue creating the alert rule.

## Troubleshoot

### **No permissions to create the tenant-level SH alert rule**

To create an alert rule that monitors tenant-level Service Health events, the user must have Read access to tenant data. Such access can be granted when the user is associated with a Microsoft Entra role, as indicated here: [Roles with tenant admin access - Azure Service Health \| Microsoft Learn](/azure/service-health/admin-access-reference)

When attempting to create a tenant-level SH alert rule without the required permissions, the user gets an unauthorized error message:

```
❗ Create alert rule  
Failed to create alert rule. Error: StatusCode=Forbidden, ReasonPhrase=Forbidden, responseContent={"error":{"code":"AuthorizationFailed","message":"The client '00000000-0000-0000-000000000000' with object id '00000000-0000-0000-000000000000' does not have authorization to perform action 'Microsoft.ResourceHealth/events/read' over scope '/providers/Microsoft.ResourceHealth' or the scope is invalid. If access was recently granted, please refresh your credentials."}} Activity ID: 00000000-0000-0000-000000000000.
```

**Recommendation**

Make sure the user attempting to create the alert rule has tenant admin access. If the user lacks the necessary permissions, they'll receive a 'No access' result and should consult their subscription owner for the being granted access.

### **Fired tenant-level SH alerts aren’t shown in the alerts list**

With this release, alerts fired on tenant-level SH events aren't shown in the alerts list.

Any actions associated with the alert rule (for example, email, webhook) contain a link to view the tenant-level event in the Azure Service Health portal page when a tenant-level SH alert fires.

In the following example, the alert email contains a link to view the event in the Service Health page, unlike other alert emails that contain a link to view the alert details.

**Recommendation**

Users should open the Service Health page in the portal to view tenant-level events.

### **A tenant-level SH alert rule didn’t fire on subscription-level events**

Tenant-level Service Health events only cover tenant related issues. That means users shouldn’t expect to get both a tenant-level and subscription-level SH alerts for the same problem.

**Recommendation**

Create separate alert rules with different scopes:

-   A Service Health alert rule scoped to the tenant
-   A Service Health alert rule scoped to the subscription. A separate alert rule is required for each subscription that customer would like to monitor.
