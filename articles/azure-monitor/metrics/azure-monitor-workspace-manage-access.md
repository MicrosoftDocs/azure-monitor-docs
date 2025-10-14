---
title: Manage access to Azure Monitor workspaces
description: This article explains how you can manage access to data stored in an Azure Monitor workspace by using resource or workspace permissions.
ms.topic: how-to
ms.reviewer: TylerKight
ms.date: 09/24/2025

---

# Manage access to Azure Monitor workspaces

The factors that determine which data you can access in an Azure Monitor workspace are:

* The settings on the workspace itself.
* Your access permissions to resources that send data to the workspace.
* The method used to access the workspace.

This article describes how to manage access to data in an Azure Monitor workspace.

## Overview

The factors that define the data you can access are described in the following table. Each factor is further described in the sections that follow.

| Factor | Description |
|:---|:---|
| [Query scope](#query-scope) | Method used to query the Prometheus HTTP APIs that Azure exposes for all Azure Monitor Workspace metrics. Defines the scope of the data available and the access control mode that's applied. |
| [Access control mode](#access-control-mode)  | Setting on the workspace that defines whether permissions are applied at the workspace or resource level.|
| [Azure role-based access control (RBAC)](#azure-rbac)  | Permissions applied to individuals or groups of users for the workspace or resource sending data to the workspace. Defines what data you have access to. |

## Query scope

The *query scope* refers to how you access an Azure Monitor workspace and defines the data you can access.

There are two query scopes:

* **Workspace-scope**: You can view all metrics in the workspace for which you have permission. These queries are scoped to all data in the workspace you have access to. When you select an **Azure Monitor Workspace** scope on any **Azure Monitor** dashboard in the Azure portal, the workspace scope is used.

* **Resource-scope**: When you access the metrics for a particular resource, resource group, or subscription, such as when you select **Metrics** from a resource menu in the Azure portal, Azure RBAC is used so you can view metrics for only resources that you have access to. Depending on the access control mode configured for the workspaces hosting your resource metrics, you may need direct access to the workspaces in addition to resources queried.

Metrics are only available in resource-scope queries if they're associated with the relevant resource. To check this association, run a query and verify that the `Microsoft.resourceid` dimension is populated.

There are limitations with the following resources:

* **Computers outside of Azure**: Resource-scoped queries are only supported for external machines configured with [Azure Arc for servers](/azure/azure-arc/servers/).
* **Application Insights**: Supported for resource-scoped queries only when using [OpenTelemetry metrics](../app/opentelemetry-configuration.md) that have an associated [data collection rule DCR](../data-collection/data-collection-rule-overview.md) that handles the stamping of required `Microsoft.*` dimensions.

### Comparing query scopes

The following table summarizes the scenarios and personas using each query scope:

| Issue | Workspace-scope | Resource-scope |
|:------|:------------------|:-----------------|
| Who is each model intended for? | Central administration.<br>Administrators who need to configure data collection and users who need access to a wide variety of resources. Currently required for users who need to access metrics for resources outside of Azure, such as those sent from remote-write without Azure Arc enabled on hosting machines. | Application teams.<br>Administrators of Azure resources being monitored. Allows them to focus on their resource without filtering. |
| What does a user require to view metrics? | Permissions to the workspace.<br>See "Workspace permissions" in [Manage access using workspace permissions](#azure-rbac). | Read access to the resource.<br>See "Resource permissions" in [Manage access using Azure permissions](#azure-rbac). Permissions can be inherited from the resource group or subscription or directly assigned to the resource. Permission to the metrics for the resource will be automatically assigned. The user doesn't require access to the workspace. |
| What is the scope of permissions? | Workspace.<br>Users with access to the workspace can query all metrics in the workspace. | Azure resource.<br>Users can query metrics for specific resources, resource groups, or subscriptions they have access to in any workspace, but they can't query metrics for other resources. |
| How can a user access metrics? | On the **Azure Monitor** menu, select **Metrics**.<br><br>Select **Metrics** from **Azure Monitor workspaces**.<br><br>From Azure Monitor when the Azure Monitor workspace is selected for resource type. | Select **Metrics** on the menu for the Azure resource. Users will have access to data for that resource.<br><br>Select **Metrics** on the **Azure Monitor** menu. Users will have access to data for all resources they have access to.|

## Access control mode

The *access control mode* is a setting on each workspace that defines how permissions are determined for the workspace.

* **Require workspace permissions**. This control mode doesn't allow granular resource-level Azure RBAC. To access the workspace, the user must be [granted permissions to the workspace](#azure-rbac).

    When a user scopes their query to a [workspace](#query-scope), workspace permissions apply. When a user scopes their query to a [resource](#query-scope), both workspace permissions AND resource permissions are verified.

    This setting is the default for all workspaces created before October 2025.

* **Use resource or workspace permissions**. This control mode allows granular Azure RBAC. Users can be granted access to only data associated with resources they can view by assigning Azure `read` permission.

    When a user scopes their query to a [workspace](#query-scope), workspace permissions apply. When a user scopes their query to a [resource](#query-scope), only resource permissions are verified, and workspace permissions are ignored.

    This setting is the default for all workspaces created after October 2025.

    > [!NOTE]
    > If a user has only resource permissions to the workspace, they can only access the workspace by using resource-scoped queries assuming the workspace access mode is set to **Use resource or workspace permissions**. The [permissions](#azure-rbac) section goes into detail on the specific Azure RBAC permissions required for different scenarios.

### Configure access control mode for a workspace

## Resource Manager

To configure the access mode in an Azure Resource Manager template, set the **enableAccessUsingResourcePermissions** feature flag on the workspace to one of the following values:

* **false**: Set the workspace to *workspace-context* permissions. This setting is the default if the flag isn't set.
* **true**: Set the workspace to *resource-context* permissions.

    > [!NOTE]
    > An ARM template is the only method currently supported to configure access control for an Azure Monitor workspace.

---

## Azure RBAC

Access to a workspace is managed by using [Azure RBAC](/azure/role-based-access-control/role-assignments-portal). To grant access to the Azure Monitor workspace by using Azure permissions, follow the steps in [Assign Azure roles to manage access to your Azure subscription resources](/azure/role-based-access-control/role-assignments-portal).

### Built-in roles

Assign users to these roles to give them access at different scopes:

* **Subscription**: Access to all workspaces in the subscription
* **Resource group**: Access to all workspaces in the resource group
* **Resource**: Access to only the specified workspace

Create assignments at the resource level (workspace) to assure accurate access control. Use [custom roles](/azure/role-based-access-control/custom-roles) to create roles with the specific permissions needed.

> [!NOTE]
> To add and remove users to a user role, you must have `Microsoft.Authorization/*/Delete` and `Microsoft.Authorization/*/Write` permission.

#### Monitoring Reader

Members of the Monitoring Reader role can view all monitoring data and monitoring settings, including the configuration of Azure diagnostics on all Azure resources. Allows members to view all data about resources within the assigned scope, including:

* View and query all monitoring data (e.g. metrics)
* View monitoring settings, including viewing the configuration of Azure diagnostics on all Azure resources, or the access control mode set.

The Monitoring Reader role includes the following Azure actions:

| Type | Permission | Description |
|------|------------|-------------|
| Action | `*/read` | Ability to view all Azure resources, resource configuration, and metrics about that resource with Microsoft.resourceid labeling.<br>For workspaces, allows full unrestricted permissions to read the workspace settings and query data. |
| Action | `Microsoft.Support/*` | Ability to open support cases. |

#### Monitoring Contributor

Members of the Monitoring Contributor role can view all monitoring data in a subscription. They can also create or modify monitoring settings, but they can't modify any other resources.

This role is a superset of the Monitoring Reader role. It's appropriate for members of an organization's monitoring team or managed service providers who, in addition to the permissions mentioned earlier, need to:

* Read all monitoring data granted by the Monitoring Reader role.
* View monitoring dashboards in the portal and create their own private monitoring dashboards.
* Create and edit diagnostic settings for a resource.
* Set alert rule activity and settings using Azure alerts.

See [Monitoring Contributor](/azure/role-based-access-control/built-in-roles/monitor#monitoring-contributor) for a detailed list of the Azure actions included in the role.


### Resource permissions

To scope queries to a [resource](#query-scope), you need the following permissions on the resource:

| Permission | Description |
|:---|:---|
| `Microsoft.Insights/metrics/*/read` | Ability to view all metrics data for the resource |

The `/read` permission is usually granted from a role that includes _\*/read or_ _\*_ permissions, such as the built-in [Reader](/azure/role-based-access-control/built-in-roles#reader) and [Contributor](/azure/role-based-access-control/built-in-roles#contributor) roles. Custom roles that include specific actions or dedicated built-in roles might not include this permission.

## Next steps

- Learn more about [Azure Monitor workspaces](./azure-monitor-workspace-overview.md).
