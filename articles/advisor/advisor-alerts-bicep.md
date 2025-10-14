---
title: Create Advisor alerts for new recommendations by using Bicep
description: Learn how to set up an alert for new recommendations from Azure Advisor by using Bicep.
ms.topic: quickstart
ms.custom: subject-armqs, mode-arm, devx-track-bicep
ms.date: 04/26/2022
---

# Quickstart: Create Advisor alerts on new recommendations by using Bicep

This article shows you how to set up an alert for new recommendations from Azure Advisor by using Bicep.

[!INCLUDE [About Bicep](~/reusable-content/ce-skilling/azure/includes/resource-manager-quickstart-bicep-introduction.md)]

Whenever Advisor detects a new recommendation for one of your resources, an event is stored in an [Azure activity log](../azure-monitor/essentials/platform-logs-overview.md). You can set up alerts for these events from Advisor by using a recommendation-specific alerts creation experience. You can select a subscription and optionally select a resource group to specify the resources that you want to receive alerts on.

You can also determine the types of recommendations by using these properties:

- Category
- Impact level
- Recommendation type

You can also configure the action that takes place when an alert is triggered by:

- Selecting an existing action group.
- Creating a new action group.

To learn more about action groups, see [Create and manage action groups](../azure-monitor/alerts/action-groups.md).

> [!NOTE]
> Advisor alerts are currently only available for High Availability, Performance, and Cost recommendations. Security recommendations aren't supported.

## Prerequisites

- If you don't have an Azure subscription, create a [free account](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn) before you begin.
- To run the commands from your local computer, install the Azure CLI or the Azure PowerShell modules. For more information, see [Install the Azure CLI](/cli/azure/install-azure-cli) and [Install Azure PowerShell](/powershell/azure/install-azure-powershell).

## Review the Bicep file

The Bicep file used in this quickstart is from [Azure Quickstart Templates](https://azure.microsoft.com/resources/templates/insights-alertrules-servicehealth/).

:::code language="bicep" source="~/quickstart-templates/quickstarts/microsoft.insights/insights-alertrules-servicehealth/main.bicep":::

The Bicep file defines two resources:

- [Microsoft.Insights/actionGroups](/azure/templates/microsoft.insights/actiongroups)
- [Microsoft.Insights/activityLogAlerts](/azure/templates/microsoft.insights/activityLogAlerts)

## Deploy the Bicep file

1. Save the Bicep file as `main.bicep` to your local computer.
1. Deploy the Bicep file by using either the Azure CLI or Azure PowerShell.

    # [CLI](#tab/CLI)

    ```azurecli
    az group create --name exampleRG --location eastus
    az deployment group create --resource-group exampleRG --template-file main.bicep --parameters alertName=<alert-name>
    ```

    # [PowerShell](#tab/PowerShell)

    ```azurepowershell
    New-AzResourceGroup -Name exampleRG -Location eastus
    New-AzResourceGroupDeployment -ResourceGroupName exampleRG -TemplateFile ./main.bicep -alertName "<alert-name>"
    ```

    ---

    > [!NOTE]
    > Replace \<alert-name\> with the name of the alert.

    When the deployment finishes, you should see a message that indicates the deployment succeeded.

## Validate the deployment

Use the Azure portal, the Azure CLI, or Azure PowerShell to list the deployed resources in the resource group.

# [CLI](#tab/CLI)

```azurecli-interactive
az resource list --resource-group exampleRG
```

# [PowerShell](#tab/PowerShell)

```azurepowershell-interactive
Get-AzResource -ResourceGroupName exampleRG
```

---

## Clean up resources

When you no longer need the resources, use the Azure portal, the Azure CLI, or Azure PowerShell to delete the resource group.

# [CLI](#tab/CLI)

```azurecli-interactive
az group delete --name exampleRG
```

# [PowerShell](#tab/PowerShell)

```azurepowershell-interactive
Remove-AzResourceGroup -Name exampleRG
```

---

## Related content

- Get an [overview of activity log alerts](../azure-monitor/alerts/alerts-overview.md) and learn how to receive alerts.
- Learn more about [action groups](../azure-monitor/alerts/action-groups.md).
