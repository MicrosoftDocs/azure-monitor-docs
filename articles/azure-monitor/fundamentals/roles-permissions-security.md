---
title: Roles, permissions, and security in Azure Monitor
description: Learn how to use roles and permissions in Azure Monitor to restrict access to monitoring resources.
ms.topic: how-to
ms.custom: devx-track-azurepowershell
ms.date: 08/07/2026
ms.reviewer: dalek
ai-usage: ai-assisted
---

# Roles, permissions, and security in Azure Monitor

This article shows how to apply [role-based access control (RBAC)](/azure/role-based-access-control/overview) monitoring roles to grant or limit access, and discusses security considerations for your Azure Monitor-related resources.

## Built-in monitoring roles

[Azure role-based access control (Azure RBAC)](/azure/role-based-access-control/overview) provides built-in roles for monitoring to assign to users, groups, service principals, and managed identities. The most common roles are [Monitoring Reader](#monitoring-reader) and [Monitoring Contributor](#monitoring-contributor) for read and write permissions, respectively. When you assign a role, specify the scope of the role assignment. Roles can be assigned at the subscription, resource group, or resource level. The wider the scope, the more resources the role assignment applies to. Assign the role at the appropriate scope to limit access to only the resources that the user needs.

For more detailed information on the monitoring roles, see [RBAC Monitoring Roles](/azure/role-based-access-control/built-in-roles#monitor).

### Monitoring Reader vs Monitoring Contributor

Monitoring Contributor is a superset of Monitoring Reader. The following table compares the two roles at a glance. For the full list of capabilities, see the sections that follow.

| Capability | Monitoring Reader | Monitoring Contributor |
| --- | --- | --- |
| View monitoring data, dashboards, metrics, and alerts | Yes | Yes |
| Query the Activity log and Log Analytics workspace data | Yes | Yes |
| View diagnostic settings, autoscale settings, and Application Insights data | Yes | Yes |
| Create private monitoring dashboards | No | Yes |
| Create and edit diagnostic settings | No | Yes <sup>1</sup> |
| Set alert rules and alert settings | No | Yes |
| List shared keys for a Log Analytics workspace | No | Yes |
| Create, delete, and run saved searches | No | Yes |
| Create web tests and components for Application Insights | No | Yes |

<sup>1</sup> **ListKeys prerequisite:** Creating or editing a diagnostic setting that sends data to a storage account or streams to an event hub requires the **ListKeys** permission on the target resource (storage account or Event Hubs namespace), in addition to the Monitoring Contributor role. Grant ListKeys at resource or resource group scope, never at subscription scope for users who need only monitoring access. For details, see [Security considerations for monitoring data](#security-considerations-for-monitoring-data).

Neither role grants read access to log data streamed to an event hub or stored in a storage account. To configure access to that data, see [Security considerations for monitoring data](#security-considerations-for-monitoring-data).

### Monitoring Reader

People assigned the Monitoring Reader role can view all monitoring data in a subscription but can't modify any resource or edit any settings related to monitoring resources. This role is appropriate for users in an organization, such as support or operations engineers, who need to:

* View monitoring dashboards in the Azure portal.
* View alert rules defined in [Azure alerts](../alerts/alerts-overview.md).
* Query Azure Monitor Metrics by using the [Azure Monitor REST API](/rest/api/monitor/metrics), [PowerShell cmdlets](/powershell/module/az.monitor), or [Azure CLI](/cli/azure/service-page/monitor).
* Query the Activity log by using the portal, Azure Monitor REST API, PowerShell cmdlets, or Azure CLI.
* View the [diagnostic settings](../platform/diagnostic-settings.md) for a resource.
* View the [log profile](/previous-versions/azure/azure-monitor/essentials/legacy-collection-methods) for a subscription. Log profiles are a legacy feature for routing the Activity log. Don't build new dependencies on them.
* View autoscale settings.
* View alert activity and settings.
* Search Log Analytics workspace data, including usage data for the workspace.
* Retrieve the table schemas in a Log Analytics workspace.
* Retrieve and execute log queries in a Log Analytics workspace.
* Access Application Insights data.

### Monitoring Contributor

People assigned the Monitoring Contributor role can view all monitoring data in a subscription. They can also create or modify monitoring settings, but they can't modify any other resources.

This role is a superset of the Monitoring Reader role. It's appropriate for members of an organization's monitoring team or managed service providers who, in addition to the permissions mentioned earlier, need to:

* View monitoring dashboards in the portal and create their own private monitoring dashboards.
* Create and edit [diagnostic settings](../platform/diagnostic-settings.md) for a resource. Creating or editing a diagnostic setting also requires the [ListKeys prerequisite](#monitoring-reader-vs-monitoring-contributor).
* Set alert rule activity and settings using [Azure alerts](../alerts/alerts-overview.md).
* List shared keys for a Log Analytics workspace.
* Create, delete, and execute saved searches in a Log Analytics workspace.
* Create and delete the workspace storage configuration for Log Analytics.
* Create web tests and components for Application Insights.

## Monitor permissions and Azure custom roles

If the built-in roles don't meet the needs of your team, [create an Azure custom role](/azure/role-based-access-control/custom-roles) with [granular permissions](/azure/role-based-access-control/permissions/monitor).

For example, use granular permissions to create an Azure custom role for an Activity Log Reader with the following PowerShell script.

```powershell
$role = Get-AzRoleDefinition "Reader"
$role.Id = $null
$role.Name = "Activity Log Reader"
$role.Description = "Can view activity logs."
$role.Actions.Clear()
$role.Actions.Add("Microsoft.Insights/eventtypes/*")
$role.AssignableScopes.Clear()
$role.AssignableScopes.Add("/subscriptions/<SubscriptionId>")
New-AzRoleDefinition -Role $role 
```

Access to alerts, diagnostic settings, and metrics for a resource requires read access to the resource type and scope of that resource. Creating a diagnostic setting that sends data to a storage account or streams to an event hub also requires the [ListKeys prerequisite](#monitoring-reader-vs-monitoring-contributor).

## Assign a role

To assign a role, see [Assign Azure roles using Azure PowerShell](/azure/role-based-access-control/role-assignments-powershell).

For example, the following PowerShell script assigns a role to a specified user.

Replace `<RoleId>` with the [RBAC Monitoring Role](/azure/role-based-access-control/built-in-roles#monitor) ID you want to assign.

Replace `<SubscriptionID>`, `<ResourceGroupName>`, and `<UserPrincipalName>` with the appropriate values for your environment.

```powershell
# Define variables
$SubscriptionId = "<SubscriptionID>"
$ResourceGroupName = "<ResourceGroupName>"
$UserPrincipalName = "<UserPrincipalName>"  # The UPN of the user to whom you want to assign the role
$RoleId = "<RoleId>"  # The ID of the role

# Get the user object
$User = Get-AzADUser -UserPrincipalName $UserPrincipalName

# Define the scope (e.g., subscription or resource group level)
$Scope = "/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName"

# Assign the role
New-AzRoleAssignment -ObjectId $User.Id -RoleDefinitionId $RoleId -Scope $Scope
```

To use the portal instead, see [Assign Azure roles by using the Azure portal](/azure/role-based-access-control/role-assignments-portal).

> [!IMPORTANT]
> * To assign roles, you need the **Owner**, **Role Based Access Control Administrator**, or **User Access Administrator** role, or a custom role with the `Microsoft.Authorization/roleAssignments/write` permission at the target scope.
> * Assign access at subscription, resource group, or resource scope. Use the narrowest scope that meets your requirements.

## PowerShell query to determine role membership

It can be helpful to generate lists of users who belong to a given role. To help with generating these types of lists, the following sample queries can be adjusted to fit your specific needs.

### Query entire subscription for Admin roles + Contributor roles

The `-IncludeClassicAdministrators` parameter and the classic `ServiceAdministrator` and `CoAdministrator` roles are legacy. Azure retired classic administrator roles in August 2024, so this query often returns no classic administrator entries. It remains here only for environments that still reference these roles.

```powershell
(Get-AzRoleAssignment -IncludeClassicAdministrators | Where-Object {$_.RoleDefinitionName -in @('ServiceAdministrator', 'CoAdministrator', 'Owner', 'Contributor') } | Select -ExpandProperty SignInName | Sort-Object -Unique) -Join ", "
```

### Query within the context of a specific Application Insights resource for owners and contributors

```powershell
$resourceGroup = "ResourceGroupName"
$resourceName = "AppInsightsName"
$resourceType = "microsoft.insights/components"
(Get-AzRoleAssignment -ResourceGroup $resourceGroup -ResourceType $resourceType -ResourceName $resourceName | Where-Object {$_.RoleDefinitionName -in @('Owner', 'Contributor') } | Select -ExpandProperty SignInName | Sort-Object -Unique) -Join ", "
```

### Query within the context of a specific resource group for owners and contributors

```powershell
$resourceGroup = "ResourceGroupName"
(Get-AzRoleAssignment -ResourceGroup $resourceGroup | Where-Object {$_.RoleDefinitionName -in @('Owner', 'Contributor') } | Select -ExpandProperty SignInName | Sort-Object -Unique) -Join ", "
```

## Security considerations for monitoring data

[Data in Azure Monitor](data-platform.md) can be sent in a storage account or streamed to an event hub, both of which are general-purpose Azure resources. Being general-purpose resources, creating, deleting, and accessing them is a privileged operation reserved for an administrator. Since this data can contain sensitive information such as IP addresses or user names, use the following practices for monitoring-related resources to prevent misuse:

* Use a single, dedicated storage account for monitoring data. If you need to separate monitoring data into multiple storage accounts, the storage accounts should be used only for monitoring data. If you share storage accounts for monitoring and other types of data, you might inadvertently grant access to other data to organizations that should only access monitoring data. For example, a non-Microsoft organization for security information and event management should need only access to monitoring data.
* Use a single, dedicated service bus or event hub namespace across all diagnostic settings for the same reason described in the previous point.
* Limit access to monitoring-related storage accounts or event hubs by keeping them in a separate resource group. [Use scope](/azure/role-based-access-control/overview#scope) on your monitoring roles to limit access to only that resource group.
* You should never grant the ListKeys permission for either storage accounts or event hubs at subscription scope when a user only needs access to monitoring data. Instead, give these permissions to the user at a resource or resource group scope (if you have a dedicated monitoring resource group).

### Limit access to monitoring-related storage accounts

When a user or application needs access to monitoring data in a storage account, [generate a shared access signature (SAS)](/rest/api/storageservices/create-account-sas) on the storage account that contains monitoring data with service-level read-only access to blob storage. In PowerShell, the account SAS might look like the following code:

```powershell
$context = New-AzStorageContext -ConnectionString "[connection string for your monitoring Storage Account]"
$token = New-AzStorageAccountSASToken -ResourceType Service -Service Blob -Permission "rl" -Context $context
```

Give the token to the entity that needs to read from that storage account. The entity can list and read from all blobs in that storage account.

Alternatively, to control this permission with Azure RBAC, grant that entity the `Microsoft.Storage/storageAccounts/listkeys/action` permission on that particular storage account. This permission is necessary for users who need to set a diagnostic setting to send data to a storage account. For example, create the following Azure custom role for a user or application that needs to read from only one storage account:

```powershell
$role = Get-AzRoleDefinition "Reader"
$role.Id = $null
$role.Name = "Monitoring Storage Account Reader"
$role.Description = "Can get the storage account keys for a monitoring storage account."
$role.Actions.Clear()
$role.Actions.Add("Microsoft.Storage/storageAccounts/listkeys/action")
$role.Actions.Add("Microsoft.Storage/storageAccounts/Read")
$role.AssignableScopes.Clear()
$role.AssignableScopes.Add("/subscriptions/<SubscriptionId>/resourceGroups/myResourceGroup/providers/Microsoft.Storage/storageAccounts/myMonitoringStorageAccount")
New-AzRoleDefinition -Role $role 
```

> [!WARNING]
> The ListKeys permission enables the user to list the primary and secondary storage account keys. These keys grant the user all signed permissions (such as read, write, create blobs, and delete blobs) across all signed services (blob, queue, table, file) in that storage account. We recommend using an account SAS when possible.

### Limit access to monitoring-related event hubs

Follow a similar pattern with event hubs, but first create a dedicated authorization rule for listening. To grant access to an application that only needs to listen to monitoring-related event hubs, follow these steps:

1. In the portal, create a shared access policy on the event hubs that were created for streaming monitoring data with only listening claims. For example, you might call it "monitoringReadOnly." If possible, give that key directly to the consumer and skip the next step.
1. If the consumer needs to get the key on demand, grant the user the `ListKeys` action for that event hub. This step is also necessary for users who need to set a diagnostic setting to stream to an event hub. For example, you might create an Azure RBAC rule:
   
    ```powershell
    $role = Get-AzRoleDefinition "Reader"
    $role.Id = $null
    $role.Name = "Monitoring Event Hub Listener"
    $role.Description = "Can get the key to listen to an event hub streaming monitoring data."
    $role.Actions.Clear()
    $role.Actions.Add("Microsoft.EventHub/namespaces/authorizationrules/listkeys/action")
    $role.Actions.Add("Microsoft.EventHub/namespaces/Read")
    $role.AssignableScopes.Clear()
    $role.AssignableScopes.Add("/subscriptions/<SubscriptionId>/resourceGroups/myResourceGroup/providers/Microsoft.EventHub/namespaces/myEventHubNamespace")
    New-AzRoleDefinition -Role $role 
    ```

## Next steps

* [Read about Azure RBAC and permissions in Azure Resource Manager](/azure/role-based-access-control/overview)
* [Read the overview of monitoring in Azure](overview.md)
