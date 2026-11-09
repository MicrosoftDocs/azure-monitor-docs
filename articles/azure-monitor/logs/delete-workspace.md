---
title: Delete and Recover a Log Analytics Workspace
description: Learn how to delete your Log Analytics workspace if you created one in a personal subscription or restructure your workspace model.
ms.topic: how-to
ms.custom: cbo-v1.5, code-validator-v1.4
ms.reviewer: yossi-y
ms.date: 10/28/2026
ai-usage: ai-assisted
---

# Delete and recover a Log Analytics workspace

This article explains the concept of Azure Log Analytics workspace soft-delete and how to recover a deleted workspace in a soft-delete state. It also explains how to delete a workspace permanently instead of deleting it into a soft-delete state.

## Choose the right action

Use soft delete by default so that you can recover the workspace if needed. Use the following table to choose an action.

| Action | When to use it | Can it be reversed? | Recovery window | When the workspace name becomes reusable |
|:-------|:---------------|:--------------------|:----------------|:----------------------------------------|
| [Soft delete](#delete-a-workspace-into-a-soft-delete-state) | Remove a workspace while keeping the option to recover it. | Yes, recover the workspace during the soft-delete period. | 14 days after deletion. | After the 14-day period, unless you recover the workspace. Permanent deletion releases the name sooner. |
| [Recover](#recover-a-workspace-in-a-soft-delete-state) | Restore a workspace that's in a soft-delete state. | You can delete the recovered workspace again. | Recovery must occur within the original 14-day soft-delete period. | The name remains assigned to the recovered workspace. |
| [Permanently delete](#delete-a-workspace-permanently) | Reuse the name immediately when permanent loss of the workspace and its data is acceptable. | No. | None. | After permanent deletion, without waiting for the soft-delete period to end. |

## Permissions required

* To delete a Log Analytics workspace into a soft-delete state or permanently, you need `Microsoft.OperationalInsights/workspaces/delete` permissions on the workspace, either assigned directly or inherited from its resource group or subscription. The [Log Analytics Contributor built-in role](./manage-access.md#log-analytics-contributor) provides this permission.
* To recover a Log Analytics workspace in a soft-delete state, you need `Microsoft.OperationalInsights/workspaces/write` permissions assigned at the containing resource group or subscription scope. The [Log Analytics Contributor built-in role](./manage-access.md#log-analytics-contributor) provides this permission.

Before deletion, ensure that the person who will recover the workspace has the required access at the resource group or subscription scope. A role assignment on the workspace alone doesn't provide recovery access after deletion removes the workspace resource.

## Considerations when you delete a workspace

Soft delete gives you 14 days to recover a workspace, whether deletion is accidental or intentional. For the deletion lifecycle and data cleanup timing, see [Recover a workspace in a soft-delete state](#recover-a-workspace-in-a-soft-delete-state).

> [!NOTE]
> A replicated workspace can't be deleted. To properly delete a workspace, first disable replication. For more information, see [Disable workspace replication](workspace-replication.md#disable-workspace-replication).

> [!WARNING]
> [Permanent deletion](#delete-a-workspace-permanently) bypasses the recovery window. You can't recover the workspace or its data, and the workspace won't appear in the recycle bin.

Users with access to other workspaces retain access to Log Analytics through those workspaces.

Be careful when you delete a workspace because there might be important data and configuration that might negatively affect your service operation. Review what agents, solutions, and other Azure services store their data in Log Analytics, such as:

* Management solutions.
* Azure Automation.
* Agents running on Windows and Linux virtual machines.
* Agents running on Windows and Linux computers in your environment.
* System Center Operations Manager.

## Delete a workspace into a soft-delete state

The workspace delete operation removes the workspace Azure Resource Manager resource. Its configuration and data are kept for 14 days, although it looks as if the workspace is deleted. Any agents and System Center Operations Manager management groups configured to report to the workspace remain in an orphaned state during the soft-delete period. You can [recover the deleted workspace](#recover-a-workspace-in-a-soft-delete-state) during this period, but recovery doesn't restore every connected resource.

### Recovery behavior

The following table summarizes what happens when you recover a soft-deleted workspace.

| Recovery behavior | Resources or data |
|:------------------|:------------------|
| Recovered automatically | Workspace configuration and retained data, including data associated with solutions.<br><br>Connections to agents and System Center Operations Manager management groups. |
| Must be reconfigured | Installed solutions: deletion permanently removes them, so reinstall the solutions and their schemas.<br><br>Linked services, such as the link to an Azure Automation account: deletion permanently removes the links, so reconfigure the linked services. |

Some data might remain unavailable for queries until you reinstall the associated solutions and add their schemas.

# [Portal](#tab/portal)

1. Sign in to the [Azure portal](https://portal.azure.com).
1. In the Azure portal, select **All services**. In the list of resources, enter **Log Analytics**. As you begin typing, the list filters based on your input. Select **Log Analytics workspaces**.
1. In the list of Log Analytics workspaces, select a workspace. Select **Delete**.
1. A confirmation page appears that shows the data ingestion to the workspace over the past week.
1. Enter the name of the workspace to confirm and then select **Delete**.

    :::image type="content" source="media/delete-workspace/workspace-delete.png" alt-text="Screenshot that shows confirming the deletion of a workspace." lightbox="media/delete-workspace/workspace-delete.png":::

# [Azure CLI](#tab/cli)

The following Azure CLI example uses the [`az monitor log-analytics workspace delete`](/cli/azure/monitor/log-analytics/workspace#az-monitor-log-analytics-workspace-delete) command. It deletes a workspace and moves it to a soft-delete state.

```bash
# Set variables
resourceGroupName="<ResourceGroupName>"
workspaceName="<WorkspaceName>"

# Delete the workspace (soft-delete)
az monitor log-analytics workspace delete \
  --resource-group "$resourceGroupName" \
  --workspace-name "$workspaceName"
```

[!INCLUDE [Azure CLI default endpoint](../includes/cli-default-endpoint.md)]

# [Azure PowerShell](#tab/powershell)

The following Azure PowerShell example uses the [`Remove-AzOperationalInsightsWorkspace`](/powershell/module/az.operationalinsights/remove-azoperationalinsightsworkspace) cmdlet. It deletes a workspace and moves it to a soft-delete state.

```powershell
# Set variables
$resourceGroupName = "<ResourceGroupName>"
$workspaceName = "<WorkspaceName>"

# Define parameters for Remove-AzOperationalInsightsWorkspace
$removeAzOperationalInsightsWorkspaceParams = @{
    ResourceGroupName = $resourceGroupName
    Name              = $workspaceName
}

# Delete the workspace (soft-delete)
Remove-AzOperationalInsightsWorkspace @removeAzOperationalInsightsWorkspaceParams
```

[!INCLUDE [Azure PowerShell default endpoint](../includes/powershell-default-endpoint.md)]

# [REST](#tab/rest)

The following REST example uses the [`Workspaces - Delete`](../fundamentals/azure-monitor-rest-api-index.md#op-logs-workspaces) REST API operation. It deletes a workspace and moves it to a soft-delete state.

```REST
DELETE https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}?api-version={apiVersion}
Authorization: Bearer {accessToken}
```

---

<!--
| Variable | Example value | Purpose |
|----------|---------------|---------|
| subscriptionId | \<SubscriptionId\> | User input |
| resourceGroupName | \<ResourceGroupName\> | User input |
| workspaceName | \<WorkspaceName\> | User input |
| apiVersion | 2025-07-01 | [Reference](../fundamentals/azure-monitor-rest-api-index.md) |
-->

**Expected result:** The workspace appears in the Azure portal's recycle bin, and its name remains reserved during the 14-day recovery window.

## Recover a workspace in a soft-delete state

When you delete a Log Analytics workspace, it follows this timeline:

1. **At deletion:** The workspace becomes inaccessible. Azure reserves its name, so you can't use it to create another workspace. Workspace-scoped role assignments no longer provide access.
1. **During the next 14 days:** You can recover the workspace, its retained data, and its connections to agents. Some resources require reconfiguration, as described in the [recovery behavior table](#recovery-behavior).
1. **After the 14-day recovery window:** The workspace and its data can't be recovered. Azure releases the workspace name for reuse.
1. **Subsequent cleanup:** Azure initiates cleanup of dedicated resources. Data in shared clusters expires under its existing retention policy.

Recover the workspace during the soft-delete period, including its data, configuration, and connected agents. Recovery re-creates the Log Analytics workspace with the details of the deleted workspace, including:

* Subscription ID
* Resource group name
* Workspace name
* Region

> [!IMPORTANT]
> If your workspace was deleted as part of a resource group delete operation, you must first re-create the resource group.

Recovery restores the workspace and its retained data, but solutions and linked services require reconfiguration. See [Recovery behavior](#recovery-behavior) for details.

# [Portal](#tab/portal)

1. Sign in to the [Azure portal](https://portal.azure.com).

1. In the Azure portal, select **All services**. In the list of resources, enter **Log Analytics**. As you begin typing, the list filters based on your input. Select **Log Analytics workspaces**. You see the list of workspaces you have in the selected scope.

1. Select **Open recycle bin** on the top left menu to open a page with workspaces in a soft-delete state that can be recovered.

    <!-- convertborder later -->
    :::image type="content" source="media/delete-workspace/recover-menu.png" lightbox="media/delete-workspace/recover-menu.png" alt-text="Screenshot that shows the Log Analytics workspaces screen and Open recycle bin on the menu bar." border="false":::

1. Select the workspace. Then select **Recover** to recover the workspace.

    <!-- convertborder later -->
    :::image type="content" source="media/delete-workspace/recover-workspace.png" lightbox="media/delete-workspace/recover-workspace.png" alt-text="Screenshot that shows the Recycle bin with a workspace and the Recover button." border="false":::

# [Azure CLI](#tab/cli)

The following Azure CLI example uses the [`az monitor log-analytics workspace recover`](/cli/azure/monitor/log-analytics/workspace#az-monitor-log-analytics-workspace-recover) command. It recovers a workspace from a soft-delete state.

```bash
# Set variables
resourceGroupName="<ResourceGroupName>"
workspaceName="<WorkspaceName>"

# Recover the workspace from soft-delete
az monitor log-analytics workspace recover \
  --resource-group "$resourceGroupName" \
  --workspace-name "$workspaceName"
```

# [Azure PowerShell](#tab/powershell)

The following Azure PowerShell example uses the [`Restore-AzOperationalInsightsWorkspace`](/powershell/module/az.operationalinsights/restore-azoperationalinsightsworkspace) cmdlet. It recovers a workspace from a soft-delete state.

```powershell
# Set variables
$resourceGroupName = "<ResourceGroupName>"
$workspaceName = "<WorkspaceName>"
$azureRegion = "<AzureRegion>"

# Define parameters for Restore-AzOperationalInsightsWorkspace
$restoreAzOperationalInsightsWorkspaceParams = @{
    ResourceGroupName = $resourceGroupName
    Name              = $workspaceName
    Location          = $azureRegion
}

# Recover the workspace from soft-delete
Restore-AzOperationalInsightsWorkspace @restoreAzOperationalInsightsWorkspaceParams
```

# [REST](#tab/rest)

The following REST example uses the [`Workspaces - Create Or Update`](../fundamentals/azure-monitor-rest-api-index.md#op-logs-workspaces) REST API operation. It recovers a workspace from a soft-delete state by re-creating it with the same name, resource group, and location.

```REST
PUT https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}?api-version={apiVersion}
Authorization: Bearer {accessToken}
Content-Type: application/json

{
  "location": "<AzureRegion>"
}
```

---

<!--
| Variable | Example value | Purpose |
|----------|---------------|---------|
| subscriptionId | \<SubscriptionId\> | User input |
| resourceGroupName | \<ResourceGroupName\> | User input |
| workspaceName | \<WorkspaceName\> | User input |
| azureRegion | \<AzureRegion\> | User input |
| apiVersion | 2025-07-01 | [Reference](../fundamentals/azure-monitor-rest-api-index.md) |
-->

**Expected result:** The workspace returns to the list of Log Analytics workspaces, with its retained data and agent connections restored. Reinstall solutions and reconfigure linked services as described in [Recovery behavior](#recovery-behavior).

## Delete a workspace permanently

Use soft delete by default. Permanently delete a workspace only when immediate name reuse is required and permanent loss of the workspace and its data is acceptable. Permanent deletion releases the workspace name for reuse without waiting for the 14-day soft-delete period to end.

> [!WARNING]
> Permanent deletion can't be reversed. You can't recover the workspace or its data, and the workspace won't appear in the recycle bin.

If the workspace is in a soft-delete state, [recover the workspace](#recover-a-workspace-in-a-soft-delete-state) before you permanently delete it.

# [Portal](#tab/portal)

To permanently delete a workspace by using the Azure portal:

1. Sign in to the [Azure portal](https://portal.azure.com).
1. In the Azure portal, select **All services**. In the list of resources, enter **Log Analytics**. As you begin typing, the list filters based on your input. Select **Log Analytics workspaces**.
1. In the list of Log Analytics workspaces, select a workspace. Select **Delete**.
1. A confirmation page appears that shows the data ingestion to the workspace over the past week.
1. Select the **Delete the workspace permanently** checkbox.
1. Enter the name of the workspace to confirm and then select **Delete**.

    :::image type="content" source="media/delete-workspace/workspace-delete.png" alt-text="Screenshot that shows confirming the deletion of a workspace." lightbox="media/delete-workspace/workspace-delete.png":::

# [Azure CLI](#tab/cli)

The following Azure CLI example uses the [`az monitor log-analytics workspace delete`](/cli/azure/monitor/log-analytics/workspace#az-monitor-log-analytics-workspace-delete) command. The `--force` parameter permanently deletes the workspace.

```bash
# Set variables
resourceGroupName="<ResourceGroupName>"
workspaceName="<WorkspaceName>"

# Permanently delete the Log Analytics workspace
az monitor log-analytics workspace delete \
  --resource-group "$resourceGroupName" \
  --workspace-name "$workspaceName" \
  --force
```

# [Azure PowerShell](#tab/powershell)

The following Azure PowerShell example uses the [`Remove-AzOperationalInsightsWorkspace`](/powershell/module/az.operationalinsights/remove-azoperationalinsightsworkspace) cmdlet. The `-ForceDelete` parameter permanently deletes the workspace and requires Az.OperationalInsights 2.3.0 or later.

```powershell
# Set variables
$resourceGroupName = "<ResourceGroupName>"
$workspaceName = "<WorkspaceName>"

# Define parameters for Remove-AzOperationalInsightsWorkspace
$removeAzOperationalInsightsWorkspaceParams = @{
    ResourceGroupName = $resourceGroupName
    Name              = $workspaceName
    ForceDelete       = $true
}

# Permanently delete the Log Analytics workspace
Remove-AzOperationalInsightsWorkspace @removeAzOperationalInsightsWorkspaceParams
```

# [REST](#tab/rest)

The following REST example uses the [`Workspaces - Delete`](../fundamentals/azure-monitor-rest-api-index.md#op-logs-workspaces) REST API operation. The `force=true` query parameter permanently deletes the workspace.

```REST
DELETE https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}?api-version={apiVersion}&force=true
Authorization: Bearer {accessToken}
```

---

<!--
| Variable | Example value | Purpose |
|----------|---------------|---------|
| subscriptionId | \<SubscriptionId\> | User input |
| resourceGroupName | \<ResourceGroupName\> | User input |
| workspaceName | \<WorkspaceName\> | User input |
| apiVersion | 2025-07-01 | [Reference](../fundamentals/azure-monitor-rest-api-index.md) |
-->

**Expected result:** The workspace doesn't appear in the recycle bin and can't be recovered. Its name is available for reuse.

## Troubleshooting

Use the following section to troubleshoot issues with deleting or recovering a Log Analytics workspace.

### I'm not sure if the workspace I deleted can be recovered

To check whether you can recover a deleted workspace, in the Azure portal, select [Open recycle bin](?tabs=portal#recover-a-workspace-in-a-soft-delete-state) on the **Log Analytics workspaces** page to see a list of soft-deleted workspaces for each subscription. The list doesn't include permanently deleted workspaces.

### Resolve the "This workspace name is already in use" or "conflict" error message

If you receive one of these error messages when you create a workspace, it could be because:

* The workspace name isn't available because it's being used by someone in your organization or another customer.

* The workspace was deleted in the last 14 days and its name was kept reserved for the soft-delete period. To resolve, follow these steps:

    1. [Recover](#recover-a-workspace-in-a-soft-delete-state) your workspace in a soft-delete state, which allows you to delete it permanently.
    1. [Permanently delete](#delete-a-workspace-permanently) the workspace you recovered. When you delete a workspace permanently, its name is no longer reserved.
    1. [Create a new workspace](./quick-create-workspace.md) by using the same workspace name.

### I'm receiving 204 response code with "Resource not found" when deleting a workspace

If you get a 204 response code with "Resource not found" when you delete a workspace, consecutive retry operations might have occurred. The 204 code is an empty response, which usually means that the resource doesn't exist, so the delete finished without doing anything.

### I'm receiving error code 404 when attempting to recover my workspace

If you deleted your resource group and it included your workspace, view the deleted workspace on the [Open recycle bin](?tabs=portal#recover-a-workspace-in-a-soft-delete-state) page in the Azure portal. In this state, recovery operations fail with a 404 HTTP status code because the resource group doesn't exist. [Re-create your resource group](/azure/azure-resource-manager/management/manage-resource-groups-portal) and try the recovery again.

## Related content

If you need to create a new Log Analytics workspace, see [Create a Log Analytics workspace](./quick-create-workspace.md).
