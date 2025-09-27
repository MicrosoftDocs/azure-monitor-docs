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

This article describes how to manage access to data in a Azure Monitor workspace.

## Overview

The factors that define the data you can access are described in the following table. Each factor is further described in the sections that follow.

| Factor                                                 | Description                                                                                                                                              |
|:-------------------------------------------------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------|
| [Query scope](#query-scope)                            | Method used to query the Prometheus HTTP APIs that Azure exposes for all Azure Monitor Workspace metrics. Defines the scope of the data available and the access control mode that's applied.                                 |
| [Access control mode](#access-control-mode)            | Setting on the workspace that defines whether permissions are applied at the workspace or resource level.                                                |
| [Azure role-based access control (RBAC)](#azure-rbac)  | Permissions applied to individuals or groups of users for the workspace or resource sending data to the workspace. Defines what data you have access to. |

## Query Scope

The *Query Scope* refers to how you access a Azure Monitor workspace and defines the data you can access.

There are two Query Scopes:

* **Workspace-scope**: You can view all metrics in the workspace for which you have permission. These queries are scoped to all data in the workspace you have access to. When you select an **Azure Monitor Workspace** Scope on any **Azure Monitor** dashboard in the Azure portal, that is the workspace scope.

* **Resource-scope**: When you access the metrics for a particular resource, resource group, or subscription, such as when you select **Metrics** from a resource menu in the Azure portal, Azure RBAC is used so you can view metrics for only resources that you have access to. Depending on the Access Mode the workspace(s) hosting your resource metrics is configured to, you may need direct access to the workspace(s) in addition to resources queried.

Metrics are only available in resource-scope queries if they're associated with the relevant resource. To check this association, run a query and verify that the Microsoft.resourceid dimension is populated.

There are known limitations with the following resources:

* **Computers outside of Azure**: Resource-scoped queries are only supported with [Azure Arc for servers](/azure/azure-arc/servers/).
* **Application Insights**: Supported for resource-scoped queries only when using [OpenTelemetry metrics](../app/opentelemetry-configuration.md) that have an associated DCR that handles the stamping of required Microsoft.* dimensions.

### Comparing query scopes

The following table summarizes the scenarios and personas using each query scope:

| Issue | Workspace-scope | Resource-scope |
|:------|:------------------|:-----------------|
| Who is each model intended for? | Central administration.<br>Administrators who need to configure data collection and users who need access to a wide variety of resources. Also currently required for users who need to access metrics for resources outside of Azure, such as those sent via remote-write without Azure Arc enabled on hosting machines. | Application teams.<br>Administrators of Azure resources being monitored. Allows them to focus on their resource without filtering. |
| What does a user require to view metrics? | Permissions to the workspace.<br>See "Workspace permissions" in [Manage access using workspace permissions](#azure-rbac). | Read access to the resource.<br>See "Resource permissions" in [Manage access using Azure permissions](#azure-rbac). Permissions can be inherited from the resource group or subscription or directly assigned to the resource. Permission to the metrics for the resource will be automatically assigned. The user doesn't require access to the workspace. |
| What is the scope of permissions? | Workspace.<br>Users with access to the workspace can query all metrics in the workspace. | Azure resource.<br>Users can query metrics for specific resources, resource groups, or subscriptions they have access to in any workspace, but they can't query metrics for other resources. |
| How can a user access metrics? | On the **Azure Monitor** menu, select **Metrics**.<br><br>Select **Metrics** from **Azure Monitor workspaces**.<br><br>From Azure Monitor when the Azure Monitor workspace is selected for resource type. | Select **Metrics** on the menu for the Azure resource. Users will have access to data for that resource.<br><br>Select **Metrics** on the **Azure Monitor** menu. Users will have access to data for all resources they have access to.|

## Access control mode

The *access control mode* is a setting on each workspace that defines how permissions are determined for the workspace.

* **Require workspace permissions**. This control mode does NOT allow granular resource-level Azure RBAC. To access the workspace, the user must be [granted permissions to the workspace](#azure-rbac).

    When a user scopes their query to a [workspace](#query-scope), workspace permissions apply. When a user scopes their query to a [resource](#query-scope), both workspace permissions AND resource permissions are verified.

    This setting is the default for all workspaces created before October 2025.

* **Use resource or workspace permissions**. This control mode allows granular Azure RBAC. Users can be granted access to only data associated with resources they can view by assigning Azure `read` permission.

    When a user scopes their query to a [workspace](#query-scope), workspace permissions apply. When a user scopes their query to a [resource](#query-scope), only resource permissions are verified, and workspace permissions are ignored.

    This setting is the default for all workspaces created after October 2025.

    > [!NOTE]
    > If a user has only resource permissions to the workspace, they can only access the workspace by using resource-scoped queries assuming the workspace access mode is set to **Use resource or workspace permissions**. The [permissions](#azure-rbac) section goes into detail on the specific Azure RBAC permissions required for different scenarios.

### Configure access control mode for a workspace

# [Azure portal](#tab/portal)

View the current workspace access control mode on the **Overview** page for the workspace in the **Azure Monitor workspace** menu.

Change this setting on the **Properties** page of the workspace. If you don't have permissions to configure the workspace, changing the setting is disabled.

# [PowerShell](#tab/powershell)

Use the following command to view the access control mode for all workspaces in the subscription:

```powershell
Get-AzResource -ResourceType Microsoft.monitor/accounts -ExpandProperties | foreach {$_.Name + ": " + $_.Properties.features.enableAccessUsingResourcePermissions}
```

The output should resemble the following:

```
DefaultWorkspace38917: True
DefaultWorkspace21532: False
```

A value of `False` means the workspace is configured with *workspace-context* access mode. A value of `True` means the workspace is configured with *resource-context* access mode.

> [!NOTE]
> If a workspace is returned without a Boolean value and is blank, this result also matches the results of a `False` value.

Use the following script to set the access control mode for a specific workspace to *resource-context* access mode:

```powershell
$WSName = "my-workspace"
$Workspace = Get-AzResource -Name $WSName -ExpandProperties
if ($Workspace.Properties.features.enableAccessUsingResourcePermissions -eq $null)
    { $Workspace.Properties.features | Add-Member enableAccessUsingResourcePermissions $true -Force }
else
    { $Workspace.Properties.features.enableAccessUsingResourcePermissions = $true }
Set-AzResource -Properties $Workspace.Properties -Force
```

Use the following script to set the access control mode for all workspaces in the subscription to *resource-context* access mode:

```powershell
Get-AzResource -ResourceType Microsoft.monitor/accounts -ExpandProperties | foreach {
if ($_.Properties.features.enableAccessUsingResourcePermissions -eq $null)
    { $_.Properties.features | Add-Member enableAccessUsingResourcePermissions $true -Force }
else
    { $_.Properties.features.enableAccessUsingResourcePermissions = $true }
Set-AzResource -Properties $_.Properties -Force
}
```

# [Resource Manager](#tab/arm)

To configure the access mode in an Azure Resource Manager template, set the **enableAccessUsingResourcePermissions** feature flag on the workspace to one of the following values:

* **false**: Set the workspace to *workspace-context* permissions. This setting is the default if the flag isn't set.
* **true**: Set the workspace to *resource-context* permissions.

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

People assigned the Monitoring Contributor role can view all monitoring data in a subscription. They can also create or modify monitoring settings, but they can't modify any other resources.

This role is a superset of the Monitoring Reader role. It's appropriate for members of an organization's monitoring team or managed service providers who, in addition to the permissions mentioned earlier, need to:

* Read all monitoring data granted by the Monitoring Reader role.
* View monitoring dashboards in the portal and create their own private monitoring dashboards.
* Create and edit diagnostic settings for a resource.
* Set alert rule activity and settings using Azure alerts.

The Monitoring Contributor role includes the following Azure actions:

[Learn more](/azure/azure-monitor/roles-permissions-security)

> [!div class="mx-tableFixed"]
> | Actions | Description |
> | --- | --- |
> | */read | Read control plane information for all Azure resources. |
> | [Microsoft.AlertsManagement](../permissions/monitor.md#microsoftalertsmanagement)/alerts/* |  |
> | [Microsoft.AlertsManagement](../permissions/monitor.md#microsoftalertsmanagement)/alertsSummary/* |  |
> | [Microsoft.AlertsManagement](../permissions/monitor.md#microsoftalertsmanagement)/issues/* |  |
> | [Microsoft.Insights](../permissions/monitor.md#microsoftinsights)/actiongroups/* |  |
> | [Microsoft.Insights](../permissions/monitor.md#microsoftinsights)/activityLogAlerts/* |  |
> | [Microsoft.Insights](../permissions/monitor.md#microsoftinsights)/AlertRules/* | Create and manage a classic metric alert |
> | [Microsoft.Insights](../permissions/monitor.md#microsoftinsights)/components/* | Create and manage Insights components |
> | [Microsoft.Insights](../permissions/monitor.md#microsoftinsights)/createNotifications/* |  |
> | [Microsoft.Insights](../permissions/monitor.md#microsoftinsights)/dataCollectionEndpoints/* |  |
> | [Microsoft.Insights](../permissions/monitor.md#microsoftinsights)/dataCollectionRules/* |  |
> | [Microsoft.Insights](../permissions/monitor.md#microsoftinsights)/dataCollectionRuleAssociations/* |  |
> | [Microsoft.Insights](../permissions/monitor.md#microsoftinsights)/DiagnosticSettings/* | Creates, updates, or reads the diagnostic setting for Analysis Server |
> | [Microsoft.Insights](../permissions/monitor.md#microsoftinsights)/eventtypes/* | List Activity Log events (management events) in a subscription. This permission is applicable to both programmatic and portal access to the Activity Log. |
> | [Microsoft.Insights](../permissions/monitor.md#microsoftinsights)/LogDefinitions/* | This permission is necessary for users who need access to Activity Logs via the portal. List log categories in Activity Log. |
> | [Microsoft.Insights](../permissions/monitor.md#microsoftinsights)/metricalerts/* |  |
> | [Microsoft.Insights](../permissions/monitor.md#microsoftinsights)/MetricDefinitions/* | Read metric definitions (list of available metric types for a resource). |
> | [Microsoft.Insights](../permissions/monitor.md#microsoftinsights)/Metrics/* | Read metrics for a resource. |
> | [Microsoft.Insights](../permissions/monitor.md#microsoftinsights)/notificationStatus/* |  |
> | [Microsoft.Insights](../permissions/monitor.md#microsoftinsights)/Register/Action | Register the Microsoft Insights provider |
> | [Microsoft.Insights](../permissions/monitor.md#microsoftinsights)/scheduledqueryrules/* |  |
> | [Microsoft.Insights](../permissions/monitor.md#microsoftinsights)/webtests/* | Create and manage Insights web tests |
> | [Microsoft.Insights](../permissions/monitor.md#microsoftinsights)/workbooks/* |  |
> | [Microsoft.Insights](../permissions/monitor.md#microsoftinsights)/workbooktemplates/* |  |
> | [Microsoft.Insights](../permissions/monitor.md#microsoftinsights)/privateLinkScopes/* |  |
> | [Microsoft.Insights](../permissions/monitor.md#microsoftinsights)/privateLinkScopeOperationStatuses/* |  |
> | [Microsoft.Monitor](../permissions/monitor.md#microsoftmonitor)/accounts/* |  |
> | [Microsoft.OperationalInsights](../permissions/monitor.md#microsoftoperationalinsights)/workspaces/write | Creates a new workspace or links to an existing workspace by providing the customer id from the existing workspace. |
> | [Microsoft.OperationalInsights](../permissions/monitor.md#microsoftoperationalinsights)/workspaces/intelligencepacks/* | Read/write/delete log analytics solution packs. |
> | [Microsoft.OperationalInsights](../permissions/monitor.md#microsoftoperationalinsights)/workspaces/savedSearches/* | Read/write/delete log analytics saved searches. |
> | [Microsoft.OperationalInsights](../permissions/monitor.md#microsoftoperationalinsights)/workspaces/search/action | Executes a search query |
> | [Microsoft.OperationalInsights](../permissions/monitor.md#microsoftoperationalinsights)/workspaces/sharedKeys/action | Retrieves the shared keys for the workspace. These keys are used to connect Microsoft Operational Insights agents to the workspace. |
> | [Microsoft.OperationalInsights](../permissions/monitor.md#microsoftoperationalinsights)/workspaces/sharedKeys/read | Retrieves the shared keys for the workspace. These keys are used to connect Microsoft Operational Insights agents to the workspace. |
> | [Microsoft.OperationalInsights](../permissions/monitor.md#microsoftoperationalinsights)/workspaces/storageinsightconfigs/* | Read/write/delete log analytics storage insight configurations. |
> | [Microsoft.OperationalInsights](../permissions/monitor.md#microsoftoperationalinsights)/locations/workspaces/failover/action | Initiates workspace failover to replication location. |
> | [Microsoft.OperationalInsights](../permissions/monitor.md#microsoftoperationalinsights)/workspaces/failback/action | Initiates workspace failback. |
> | [Microsoft.Support](../permissions/general.md#microsoftsupport)/* | Create and update a support ticket |
> | [Microsoft.AlertsManagement](../permissions/monitor.md#microsoftalertsmanagement)/smartDetectorAlertRules/* |  |
> | [Microsoft.AlertsManagement](../permissions/monitor.md#microsoftalertsmanagement)/actionRules/* |  |
> | [Microsoft.AlertsManagement](../permissions/monitor.md#microsoftalertsmanagement)/smartGroups/* |  |
> | [Microsoft.AlertsManagement](../permissions/monitor.md#microsoftalertsmanagement)/migrateFromSmartDetection/* |  |
> | [Microsoft.AlertsManagement](../permissions/monitor.md#microsoftalertsmanagement)/investigations/* |  |
> | [Microsoft.AlertsManagement](../permissions/monitor.md#microsoftalertsmanagement)/prometheusRuleGroups/* |  |
> | [Microsoft.Monitor](../permissions/monitor.md#microsoftmonitor)/investigations/* |  |
> | **NotActions** |  |
> | *none* |  |
> | **DataActions** |  |
> | *none* |  |
> | **NotDataActions** |  |
> | *none* |  |

### Resource permissions

To scope queries to a [resource](#query-scope), you need these permissions on the resource:

| Permission                                                                                         | Description                                                                         |
|----------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------|
| `Microsoft.Insights/metrics/*/read`                                                                   | Ability to view all metrics data for the resource                                       |

The `/read` permission is usually granted from a role that includes _\*/read or_ _\*_ permissions, such as the built-in [Reader](/azure/role-based-access-control/built-in-roles#reader) and [Contributor](/azure/role-based-access-control/built-in-roles#contributor) roles. Custom roles that include specific actions or dedicated built-in roles might not include this permission.

## Next steps

* See [Log Analytics agent overview](../agents/log-analytics-agent.md) to gather data from computers in your datacenter or other cloud environment.
* See [Collect data about Azure virtual machines](../vm/monitor-virtual-machine.md) to configure data collection from Azure VMs.
