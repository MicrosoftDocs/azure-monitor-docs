---
title: Move a Log Analytics Workspace in Azure Monitor
description: Learn how to move your Log Analytics workspace to another subscription or resource group.
ms.topic: how-to
ms.reviewer: yossiy
ms.date: 07/25/2026
ms.custom: devx-track-azurepowershell, cbo-v1.6
ai-usage: ai-assisted

---

# Move a Log Analytics workspace to a different subscription or resource group

This article explains how to move a Log Analytics workspace to another resource group or subscription in the same region. Moving a Log Analytics workspace in the same region does not affect your log data or data retention settings.

To move a workspace to a *different* region instead, see [Relocate a Log Analytics workspace to another region](/azure/azure-resource-manager/management/relocation/relocation-log-analytics). A cross-region move requires creating a new workspace because workspace data doesn't move across regions. To move to a region that supports availability zones, see [Migrate Log Analytics to availability zone support](/azure/reliability/migrate-monitor-log-analytics).

> [!TIP] 
> To learn more about how to move Azure resources through the Azure portal, PowerShell, the Azure CLI, or the REST API, see [Move resources to a new resource group or subscription](/azure/azure-resource-manager/management/move-resource-group-and-subscription).

## Prerequisites

* The subscription or resource group where you want to move your Log Analytics workspace must be located in the same region as the Log Analytics workspace you're moving.

* No services can remain linked to the workspace when you move it. Before the move, delete solutions that rely on linked services, including an Azure Automation account. Remove these solutions before you can unlink your Automation account. Data collection for the solutions stops and their tables are removed from the UI, but data remains in the workspace for the retention period defined for the table. When you add solutions back after the move, ingestion is restored and tables become visible with data. Linked services include:

  * Update management
  * Change tracking
  * Start/Stop VMs during off-hours
  * Microsoft Defender for Cloud

* Connected [Log Analytics agents](../agents/log-analytics-agent.md) and [Azure Monitor Agent](../agents/azure-monitor-agent-overview.md) remain connected to the workspace after the move with no interruption to ingestion.

* You should re-create alerts after the move, since permissions for alerts are based on workspace resource ID, which changes with the move. You can export alerts created after June 1, 2019, or in workspaces that were [upgraded from the legacy Log Analytics Alert API to the scheduledQueryRules API](../alerts/alerts-log-api-switch.md) in templates and deploy them after the move. You can [check if the scheduledQueryRules API is used for alerts in your workspace](../alerts/alerts-log-api-switch.md#check-switching-status-of-workspace). Alternatively, you can configure alerts manually in the target workspace.

* Update resource paths after a workspace move for Azure or external resources that point to the workspace, such as [Azure Monitor alert rules](../alerts/alerts-resource-move.md), third-party applications, and custom scripts.

## Permissions required

| Action | Permissions required |
|--------|----------------------|
| Verify the Microsoft Entra tenant. | `Microsoft.AzureActiveDirectory/b2cDirectories/read` permissions, as provided by the [Log Analytics Reader built-in role](./manage-access.md#log-analytics-reader), for example. |
| Delete a solution. | `Microsoft.OperationsManagement/solutions/delete` permissions on the solution, as provided by the [Log Analytics Contributor built-in role](./manage-access.md#log-analytics-contributor), for example. |
| Remove alert rules for the Start/Stop VMs solution. | `microsoft.insights/scheduledqueryrules/delete` permissions, as provided by the [Monitoring Contributor built-in role](/azure/role-based-access-control/built-in-roles#monitoring-contributor), for example. |
| Unlink the Automation account | `Microsoft.OperationalInsights/workspaces/linkedServices/delete` permissions on the linked Log Analytics workspace, as provided by the [Log Analytics Contributor built-in role](./manage-access.md#log-analytics-contributor), for example. |
| Move a Log Analytics workspace. | `Microsoft.OperationalInsights/workspaces/delete` and `Microsoft.OperationalInsights/workspaces/write` permissions on the Log Analytics workspace, as provided by the [Log Analytics Contributor built-in role](./manage-access.md#log-analytics-contributor), for example. |

## Considerations 

* It can take Azure Resource Manager a few hours to complete. Solutions might be unresponsive during the operation.
* Your log data and data retention settings remain unaffected.
* Managed solutions that are installed in the workspace move as well.
* Managed solutions are workspace objects and can't be moved independently.
* Azure regenerates workspace keys (both primary and secondary) with a workspace move operation. If you keep a copy of your workspace keys in Azure Key Vault, update them with the new keys generated after the workspace is moved.

>[!IMPORTANT]
> **Microsoft Sentinel customers**
>
> When you move a Log Analytics workspace that has Microsoft Sentinel deployed, the following resources are impacted but recoverable:
>
> * **Microsoft Sentinel**: The workspace is offboarded from Microsoft Sentinel immediately. To restore Sentinel, [re-onboard the workspace to Microsoft Sentinel](/azure/sentinel/quickstart-onboard) within 90 days to preserve your existing Microsoft Sentinel data.
> * **SIEM in Microsoft Defender**: SIEM workspaces in Microsoft Defender are disconnected immediately. [Reconnect Microsoft Sentinel to the Microsoft Defender portal](/unified-secops/microsoft-sentinel-onboard) after the move.
>
> If you already moved the workspace and rules aren't firing, disable all active rules under **Analytics** and reenable them after five minutes.

## Verify the Microsoft Entra tenant
The workspace source and destination subscriptions must exist within the same Microsoft tenant. Use Azure PowerShell to verify that both subscriptions have the same Entra tenant ID.

# [Portal](#tab/portal)

[Find your Microsoft Entra tenant](/azure/azure-portal/get-subscription-tenant-id#find-your-azure-ad-tenant) for the source and destination subscriptions.

# [Azure CLI](#tab/cli)

The following Azure CLI example uses the [`az account show`](/cli/azure/account#az-account-show) command.

> [!NOTE]
> The two tenant IDs must match.

```bash
# Set variables
sourceSubscriptionId="<SourceSubscriptionId>"
targetSubscriptionId="<TargetSubscriptionId>"

# Retrieve each subscription's tenant ID
az account show --subscription "$sourceSubscriptionId" --query tenantId --output tsv
az account show --subscription "$targetSubscriptionId" --query tenantId --output tsv
```

[!INCLUDE [Azure CLI default endpoint](../includes/cli-default-endpoint.md)]

# [Azure PowerShell](#tab/powershell)

The following Azure PowerShell example uses the [`Get-AzSubscription`](/powershell/module/az.accounts/get-azsubscription) cmdlet.

> [!NOTE]
> The two tenant IDs must match.

```powershell
# Set variables
$sourceSubscriptionId = "<SourceSubscriptionId>"
$targetSubscriptionId = "<TargetSubscriptionId>"

# Retrieve each subscription's tenant ID
(Get-AzSubscription -SubscriptionId $sourceSubscriptionId).TenantId
(Get-AzSubscription -SubscriptionId $targetSubscriptionId).TenantId
```

[!INCLUDE [Azure PowerShell default endpoint](../includes/powershell-default-endpoint.md)]

# [REST](#tab/rest)

The following REST example uses the [`Subscriptions - Get`](../fundamentals/azure-monitor-rest-api-index.md#op-monitor-subscriptions) REST API operation.

> [!NOTE]
> Run the request for each subscription and compare its `tenantId` value.

```REST
GET https://management.azure.com/subscriptions/{subscriptionId}?api-version={apiVersion}
Authorization: Bearer {accessToken}
```

---

## Delete solutions

# [Portal](#tab/portal)

1. Open the menu for the resource group where any solutions are installed.
1. Select the solutions to remove.
1. Select **Delete Resources** and then confirm the resources to be removed by selecting **Delete**.
    <!-- convertborder later -->
    :::image type="content" source="media/move-workspace/delete-solutions.png" lightbox="media/move-workspace/delete-solutions.png" alt-text="Screenshot that shows deleting solutions." border="false":::

# [Azure CLI](#tab/cli)

The following Azure CLI example uses the [`az resource delete`](/cli/azure/resource#az-resource-delete) command.

> [!NOTE]
> Run it for each solution you want to remove.

```bash
# Set variables
resourceGroupName="<ResourceGroupName>"
solutionName="<SolutionName>"

# Delete the solution
az resource delete \
  --name "$solutionName" \
  --resource-type Microsoft.OperationsManagement/solutions \
  --resource-group "$resourceGroupName"
```

[!INCLUDE [Azure CLI default endpoint](../includes/cli-default-endpoint.md)]

# [Azure PowerShell](#tab/powershell)

The following Azure PowerShell example uses the [`Remove-AzResource`](/powershell/module/az.resources/remove-azresource) cmdlet.

> [!NOTE]
> Include only the solutions you want to remove.

```powershell
# Set variables
$resourceGroupName = "<ResourceGroupName>"
$workspaceName = "<WorkspaceName>"
$solutionNames = @(
  "ChangeTracking($workspaceName)"
  "Updates($workspaceName)"
  "Start-Stop-VM($workspaceName)"
)

# Delete the selected solutions
foreach ($solutionName in $solutionNames) {
  $removeAzResourceParams = @{
    ResourceType      = "Microsoft.OperationsManagement/solutions"
    ResourceName      = $solutionName
    ResourceGroupName = $resourceGroupName
  }
  Remove-AzResource @removeAzResourceParams
}
```

[!INCLUDE [Azure PowerShell default endpoint](../includes/powershell-default-endpoint.md)]

# [REST](#tab/rest)

The following REST example uses the [`Resources - Delete`](../fundamentals/azure-monitor-rest-api-index.md#op-monitor-resource-moves) REST API operation.

```REST
DELETE https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}?api-version={apiVersion}
Authorization: Bearer {accessToken}
```

---

### Remove alert rules for the Start/Stop VMs solution

To remove the **Start/Stop VMs** solution, you also need to remove the alert rules created by the solution.

# [Portal](#tab/portal)

1. Open the **Monitor** menu and then select **Alerts**.
1. Select **Manage alert rules**.
1. Select the following three alert rules, and then select **Delete**:

    * AutoStop_VM_Child
    * ScheduledStartStop_Parent
    * SequencedStartStop_Parent
      <!-- convertborder later -->
      :::image type="content" source="media/move-workspace/delete-rules.png" lightbox="media/move-workspace/delete-rules.png" alt-text="Screenshot that shows deleting rules." border="false":::

# [Azure CLI](#tab/cli)

The following Azure CLI example uses the [`az monitor scheduled-query delete`](/cli/azure/monitor/scheduled-query#az-monitor-scheduled-query-delete) command.

> [!NOTE]
> The example deletes these alert rules:
>
> * AutoStop_VM_Child
> * ScheduledStartStop_Parent
> * SequencedStartStop_Parent

```bash
# Set variables
resourceGroupName="<ResourceGroupName>"
ruleNames=(AutoStop_VM_Child ScheduledStartStop_Parent SequencedStartStop_Parent)

# Delete the alert rules
for ruleName in "${ruleNames[@]}"; do
  az monitor scheduled-query delete \
    --name "$ruleName" \
    --resource-group "$resourceGroupName"
done
```

[!INCLUDE [Azure CLI default endpoint](../includes/cli-default-endpoint.md)]

# [Azure PowerShell](#tab/powershell)

The following Azure PowerShell example uses the [`Remove-AzScheduledQueryRule`](/powershell/module/az.monitor/remove-azscheduledqueryrule) cmdlet.

> [!NOTE]
> The example deletes these alert rules:
>
> * AutoStop_VM_Child
> * ScheduledStartStop_Parent
> * SequencedStartStop_Parent

```powershell
# Set variables
$resourceGroupName = "<ResourceGroupName>"
$ruleNames = @(
  "AutoStop_VM_Child"
  "ScheduledStartStop_Parent"
  "SequencedStartStop_Parent"
)

# Delete the alert rules
foreach ($ruleName in $ruleNames) {
  $removeAzScheduledQueryRuleParams = @{
    Name              = $ruleName
    ResourceGroupName = $resourceGroupName
  }
  Remove-AzScheduledQueryRule @removeAzScheduledQueryRuleParams
}
```

[!INCLUDE [Azure PowerShell default endpoint](../includes/powershell-default-endpoint.md)]

# [REST](#tab/rest)

The following REST example uses the [`Scheduled Query Rules - Delete`](../fundamentals/azure-monitor-rest-api-index.md#op-monitor-scheduled-query-rules-2021-08-01) REST API operation.

> [!NOTE]
> Run it for each of these alert rules:
>
> * AutoStop_VM_Child
> * ScheduledStartStop_Parent
> * SequencedStartStop_Parent

```REST
DELETE https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/scheduledQueryRules/{ruleName}?api-version={apiVersion}
Authorization: Bearer {accessToken}
```

---

## Unlink the Automation account

# [Portal](#tab/portal-2)

See [Delete a standalone Automation account linked to workspace](/azure/automation/delete-account#delete-a-standalone-automation-account-linked-to-workspace).

# [REST](#tab/rest-2)

The following REST example uses the [`Linked Services - Delete`](../fundamentals/azure-monitor-rest-api-index.md#op-logs-linked-services) REST API operation.

```REST
DELETE https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/linkedServices/{linkedServiceName}?api-version={apiVersion}
Authorization: Bearer {accessToken}
```

---

## Move your workspace

For a move between resource groups in the same subscription, use that subscription as the destination too. Include any related resources that must move with the workspace.

# [Portal](#tab/portal)

1. Open the **Log Analytics workspaces** menu and then select your workspace.
1. On the **Overview** page, select **change** next to either **Resource group** or **Subscription name**.
1. A new page opens with a list of resources related to the workspace. Select the resources to move to the same destination subscription and resource group as the workspace.
1. Select a destination **Subscription** and **Resource group**. If you're moving the workspace to another resource group in the same subscription, you won't see the **Subscription** option.
1. Select **OK** to move the workspace and selected resources.

    :::image type="content" source="media/move-workspace/portal.png" lightbox="media/move-workspace/portal.png" alt-text="Screenshot that shows the Overview pane in the Log Analytics workspace with options to change the resource group and subscription name.":::

# [Azure CLI](#tab/cli)

The following Azure CLI example uses the [`az resource move`](/cli/azure/resource#az-resource-move) command.

```bash
# Set variables
sourceResourceGroupName="<SourceResourceGroupName>"
workspaceName="<WorkspaceName>"
targetSubscriptionId="<TargetSubscriptionId>"
targetResourceGroupName="<TargetResourceGroupName>"

# Get the subscription ID from the current Azure CLI context
sourceSubscriptionId=$(az account show --query id --output tsv)

# Build workspace resource ID
workspacePath="/subscriptions/$sourceSubscriptionId"
workspacePath+="/resourceGroups/$sourceResourceGroupName"
workspaceProvider="Microsoft.OperationalInsights/workspaces/$workspaceName"
workspaceResourceId="$workspacePath/providers/$workspaceProvider"

# Move the workspace
az resource move \
  --destination-group "$targetResourceGroupName" \
  --destination-subscription-id "$targetSubscriptionId" \
  --ids "$workspaceResourceId"
```

[!INCLUDE [Azure CLI default endpoint](../includes/cli-default-endpoint.md)]

# [Azure PowerShell](#tab/powershell)

The following Azure PowerShell example uses the [`Move-AzResource`](/powershell/module/az.resources/move-azresource) cmdlet.

```powershell
# Set variables
$sourceResourceGroupName = "<SourceResourceGroupName>"
$workspaceName = "<WorkspaceName>"
$targetSubscriptionId = "<TargetSubscriptionId>"
$targetResourceGroupName = "<TargetResourceGroupName>"

# Get the subscription ID from the current Azure PowerShell context
$sourceSubscriptionId = (Get-AzContext).Subscription.Id

# Build workspace resource ID
$workspacePath = "/subscriptions/$sourceSubscriptionId" +
  "/resourceGroups/$sourceResourceGroupName"
$workspaceProvider = "Microsoft.OperationalInsights/workspaces/$workspaceName"
$workspaceResourceId = "$workspacePath/providers/$workspaceProvider"

# Define parameters for Move-AzResource
$moveAzResourceParams = @{
  ResourceId                   = @($workspaceResourceId)
  DestinationSubscriptionId    = $targetSubscriptionId
  DestinationResourceGroupName = $targetResourceGroupName
}

# Move the workspace
Move-AzResource @moveAzResourceParams
```

[!INCLUDE [Azure PowerShell default endpoint](../includes/powershell-default-endpoint.md)]

# [REST](#tab/rest)

The following REST example uses the [`Resources - Move Resources`](../fundamentals/azure-monitor-rest-api-index.md#op-monitor-resource-moves) REST API operation.

```REST
POST https://management.azure.com/subscriptions/{sourceSubscriptionId}/resourceGroups/{sourceResourceGroupName}/moveResources?api-version={apiVersion}
Authorization: Bearer {accessToken}
Content-Type: application/json

{
  "resources": [
    "/subscriptions/<SourceSubscriptionId>/resourceGroups/<SourceResourceGroupName>/providers/Microsoft.OperationalInsights/workspaces/<WorkspaceName>"
  ],
  "targetResourceGroup": "/subscriptions/<TargetSubscriptionId>/resourceGroups/<TargetResourceGroupName>"
}
```

---

> [!IMPORTANT]
> After the move operation, removed solutions and the Automation account link should be reconfigured to bring the workspace back to its previous state.

## Related content

* [Move operation support for resources](/azure/azure-resource-manager/management/move-support-resources) lists which resources support the move operation.
* [Relocate a Log Analytics workspace to another region](/azure/azure-resource-manager/management/relocation/relocation-log-analytics) covers cross-region moves, where data doesn't move automatically.
