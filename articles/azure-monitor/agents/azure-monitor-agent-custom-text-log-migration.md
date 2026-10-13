---
title: Migrate from Log Analytics Agent Custom Log Table to Azure Monitor Agent DCR-Based Custom Log Table
description: Learn the steps to migrate from Log Analytics agent custom log table to Azure Monitor Agent DCR-based custom log table.
ms.topic: upgrade-and-migration-article
ms.reviewer: shseth, nmangum
ms.date: 04/07/2026
ms.custom: ai-assisted, cbo-v1.6
ai-usage: ai-assisted
---

# Migrate from Log Analytics agent custom log table to Azure Monitor Agent DCR-based custom log table

This article explains how to migrate a custom text log table from the legacy Log Analytics agent (MMA) so you can use it as the destination for custom text logs that Azure Monitor Agent (AMA) collects through a data collection rule (DCR).

## Background

You must configure Log Analytics agent custom text logs to support new DCR features that let AMA write to the table. Consider the following points:

* The table is reconfigured to enable all features for DCR-based custom logs.
* AMA can write data to any column in the table.
* Log Analytics agent custom text logs can no longer write to that table.

To keep writing your custom data from both the Log Analytics agent and AMA, each agent needs its own custom log table. Your data queries in Log Analytics must join the two tables until the migration is complete, at which point you can remove the join.

## Migration

You should follow the steps only if the following criteria are met:

* You created the original table using the Custom Log Wizard.
* You want to preserve the existing data in the table.
* You don't need Log Analytics agents to send data to the existing table.
* You want to exclusively write new data by using a [DCR for AMA custom text logs](../vm/data-collection-log-text.md) and possibly configure an [ingestion time transformation](../vm/data-collection-log-text.md).

## Prerequisites

For Azure CLI or Azure PowerShell, select the subscription that contains your Log Analytics workspace before you run the migration command.

## Procedure

1. Configure your data collection rule (DCR) by following the instructions in [collect text logs with AMA](../vm/data-collection-log-text.md).

1. To enable ingestion from a DCR and manage your table in the Azure portal, issue the following API call against your existing custom log table. This call only changes the table the first time you run it. Running it again has no effect. Migration is one-way, so you can't migrate the table back to the Log Analytics agent.

    # [Azure CLI](#tab/cli)

    The following Azure CLI example uses the [`az monitor log-analytics workspace table migrate`](/cli/azure/monitor/log-analytics/workspace/table#az-monitor-log-analytics-workspace-table-migrate) command.

    ```bash
    # Set variables
    resourceGroupName="<ResourceGroupName>"
    workspaceName="<WorkspaceName>"
    tableName="<TableName>_CL"

    # Migrate the custom log table
    az monitor log-analytics workspace table migrate --resource-group "$resourceGroupName" \
      --workspace-name "$workspaceName" \
      --table-name "$tableName"
    ```

    [!INCLUDE [Azure CLI default endpoint](../includes/cli-default-endpoint.md)]

    # [Azure PowerShell](#tab/powershell)

    The following Azure PowerShell example uses the [`Invoke-AzOperationalInsightsMigrateTable`](/powershell/module/az.operationalinsights/invoke-azoperationalinsightsmigratetable) cmdlet.

    ```powershell
    # Set variables
    $resourceGroupName = "<ResourceGroupName>"
    $workspaceName = "<WorkspaceName>"
    $tableName = "<TableName>_CL"

    # Define parameters for Invoke-AzOperationalInsightsMigrateTable
    $invokeAzOperationalInsightsMigrateTableParams = @{
        ResourceGroupName = $resourceGroupName
        WorkspaceName     = $workspaceName
        TableName         = $tableName
    }

    # Migrate the custom log table
    Invoke-AzOperationalInsightsMigrateTable @invokeAzOperationalInsightsMigrateTableParams
    ```

    [!INCLUDE [Azure PowerShell default endpoint](../includes/powershell-default-endpoint.md)]

    # [REST](#tab/rest)

    The following REST example uses the [`Tables - Migrate`](../fundamentals/azure-monitor-rest-api-index.md#op-logs-tables) REST API operation.

    ```REST
    POST https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/tables/{tableName}_CL/migrate?api-version={apiVersion}
    Authorization: Bearer {accessToken}
    Content-Type: application/json
    ```

    ---

1. Discontinue the Log Analytics agent custom text logs collection and start using AMA custom text logs.

## Next steps

* [Walk through a tutorial sending custom logs using the Azure portal.](../vm/data-collection-log-text.md)
* [Create an ingestion time transform for your custom text data](../vm/data-collection-log-text.md)
