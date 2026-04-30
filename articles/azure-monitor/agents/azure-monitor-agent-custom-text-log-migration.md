---
title: Migrate from Log Analytics Agent Custom Text Table to Azure Monitor Agent DCR-Based Custom Text Table
description: Learn the steps to migrate from Log Analytics agent custom text table to Azure Monitor Agent DCR-based custom text table.
ms.topic: upgrade-and-migration-article
ms.date: 04/07/2026
ms.custom: ai-assisted
---

# Migrate from Log Analytics agent custom text table to Azure Monitor Agent DCR-based custom text table

This article describes how to migrate a [custom text logs table from the legacy Log Analytics agent](data-sources-custom-logs.md) (also known as Microsoft Monitoring Agent or MMA) so it can be used as the destination for a new [Azure Monitor Agent (AMA) custom text logs](data-collection-log-text.md) data collection rule (DCR).

## Background

You must configure Log Analytics agent custom text logs to support new DCR features that allow AMA to write to it. Take the following actions:

- Your table is reconfigured to enable all DCR-based custom logs features.
- Your AMA can write data to any column in the table.
- Your Log Analytics agent custom text logs will lose the ability to write to the custom log.

To continue writing your custom data from both the Log Analytics agent and AMA, each agent must have its own custom table. Your data queries in Log Analytics that process your data must join the two tables until the migration is complete, at which point you can remove the join.

## Migration

You should follow the steps only if the following criteria are met:

- You created the original table using the Custom Log Wizard.
- You're going to preserve the existing data in the table.
- You don't need Log Analytics agents to send data to the existing table.
- You're going to exclusively write new data using an [AMA custom text logs DCR](data-collection-log-text.md) and possibly configure an [ingestion time transformation](azure-monitor-agent-transformation.md).

## Procedure

1. Configure your data collection rule (DCR) following the instructions in [collect text logs with AMA](data-collection-log-text.md).

1. Issue the following API call against your existing custom logs table to enable ingestion from a DCR and manage your table in the Azure portal. This call is idempotent and future calls have no effect. Migration is one-way, you can't migrate the table back to Log Analytics agent.

    # [REST](#tab/rest)

    ```REST
    POST https://management.azure.com/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/tables/{tableName}/migrate?api-version={apiVersion}
    Authorization: Bearer {token}
    Content-Type: application/json
    ```

    # [Azure CLI](#tab/cli)

    The following Azure CLI example uses the [az monitor log-analytics workspace table](/cli/azure/monitor/log-analytics/workspace/table) command group.

    ```azurecli
    subscriptionId="aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e"
    resourceGroupName="myResourceGroup"
    workspaceName="myWorkspace"
    tableName="myTable"

    az account set --subscription "$subscriptionId"

    az monitor log-analytics workspace table migrate \
      --resource-group "$resourceGroupName" \
      --workspace-name "$workspaceName" \
      --table-name "$tableName"
    ```

    [!INCLUDE [Azure CLI default endpoint](../includes/cli-default-endpoint.md)]

    # [PowerShell](#tab/powershell)

    The following PowerShell example uses the [Invoke-AzOperationalInsightsMigrateTable](/powershell/module/az.operationalinsights/invoke-azoperationalinsightsmigratetable) cmdlet.

    ```azurepowershell
    $subscriptionId = "aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e"
    $resourceGroupName = "myResourceGroup"
    $workspaceName = "myWorkspace"
    $tableName = "myTable"
    
    Set-AzContext -Subscription $subscriptionId
    
    $migrateTableParams = @{
        ResourceGroupName = $resourceGroupName
        WorkspaceName     = $workspaceName
        TableName         = $tableName
    }
    
    Invoke-AzOperationalInsightsMigrateTable @migrateTableParams
    ```

    [!INCLUDE [Azure PowerShell default endpoint](../includes/powershell-default-endpoint.md)]

    ---

    | Variable | Example value | Purpose |
    |----------|---------------|---------|
    | host | *management.azure.com* | Implicit ARM endpoint |
    | subscriptionId | aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e | User input |
    | resourceGroupName | myResourceGroup | User input |
    | workspaceName | myWorkspace | User input |
    | tableName | myTable | User input |
    | apiVersion | 2025-07-01 | [Reference](../fundamentals/azure-monitor-rest-api-index.md) |

1. Discontinue Log Analytics agent custom text logs collection and start using the AMA custom text logs.

## Next steps

- [Walk through a tutorial sending custom logs using the Azure portal.](data-collection-log-text.md)
- [Create an ingestion time transform for your custom text data](azure-monitor-agent-transformation.md)
