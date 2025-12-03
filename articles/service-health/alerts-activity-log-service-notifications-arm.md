---
title: Receive Service health alerts on Azure service notifications using Resource Manager template
description: Get notified via SMS, email, or webhook when Azure service occurs using a Resource Manager template.
ms.date: 05/27/2025
ms.topic: quickstart
ms.custom: subject-armqs, mode-arm, devx-track-arm-template
---

# Quickstart: Create Service health alerts on service notifications using an ARM template

This guide walks you through how to set up service health alerts for service health notifications by using an Azure Resource Manager (ARM) template.

[!INCLUDE [About Azure Resource Manager](~/reusable-content/ce-skilling/azure/includes/resource-manager-quickstart-introduction.md)]

## Overview

Service health notifications are stored in the [Azure activity log](../azure-monitor/essentials/platform-logs-overview.md). Given the possibly large volume of information stored in the activity log, there's a separate user interface to make it easier to view and set up alerts on service health notifications.

You can receive an alert when Azure sends service health notifications to your Azure subscription. You can configure the alert based on:

- The class of service health notification (Service issues, Planned maintenance, Health advisories).
- The subscription affected.
- The services affected.
- The regions affected.

> [!NOTE]
> Service health notifications don't send alerts regarding resource health events.

You also can configure who the alert should be sent to:

- Select an existing action group.
- Create a new action group that can be used for future alerts.

To learn more about action groups, see [Create and manage action groups](../azure-monitor/alerts/action-groups.md).

### Prerequisites

- If you don't have an Azure subscription, create a [free account](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn) before you begin.
- To run the commands from your local computer, install Azure CLI or the Azure PowerShell modules. For more information, see [Install the Azure CLI](/cli/azure/install-azure-cli) and [Install Azure PowerShell](/powershell/azure/install-azure-powershell).

**1. Review the template**

The following template creates an action group with an email target and enables all service health notifications for the target subscription. 
<br> Save this template as *CreateServiceHealthAlert.json*.

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "actionGroups_name": {
      "type": "string",
      "defaultValue": "SubHealth"
    },
    "activityLogAlerts_name": {
      "type": "string",
      "defaultValue": "ServiceHealthActivityLogAlert"
    },
    "emailAddress": {
      "type": "string"
    }
  },
  "variables": {
    "alertScope": "[format('/subscriptions/{0}', subscription().subscriptionId)]"
  },
  "resources": [
    {
      "type": "microsoft.insights/actionGroups",
      "apiVersion": "2019-06-01",
      "name": "[parameters('actionGroups_name')]",
      "location": "Global",
      "properties": {
        "groupShortName": "[parameters('actionGroups_name')]",
        "enabled": true,
        "emailReceivers": [
          {
            "name": "[parameters('actionGroups_name')]",
            "emailAddress": "[parameters('emailAddress')]"
          }
        ],
        "smsReceivers": [],
        "webhookReceivers": []
      }
    },
    {
      "type": "microsoft.insights/activityLogAlerts",
      "apiVersion": "2017-04-01",
      "name": "[parameters('activityLogAlerts_name')]",
      "location": "Global",
      "properties": {
        "scopes": [
          "[variables('alertScope')]"
        ],
        "condition": {
          "allOf": [
            {
              "field": "category",
              "equals": "ServiceHealth"
            },
            {
              "field": "properties.incidentType",
              "equals": "Incident"
            }
          ]
        },
        "actions": {
          "actionGroups": [
            {
              "actionGroupId": "[resourceId('microsoft.insights/actionGroups', parameters('actionGroups_name'))]",
              "webhookProperties": {}
            }
          ]
        },
        "enabled": true
      },
      "dependsOn": [
        "[resourceId('microsoft.insights/actionGroups', parameters('actionGroups_name'))]"
      ]
    }
  ]
}
```

The template defines two resources:

- [Microsoft.Insights/actionGroups](/azure/templates/microsoft.insights/actiongroups)
- [Microsoft.Insights/activityLogAlerts](/azure/templates/microsoft.insights/activityLogAlerts)

**2. Deploy the template**

Deploy the template using any standard method for [deploying an ARM template](/azure/azure-resource-manager/templates/deploy-portal). You can use the following examples for using CLI and PowerShell. 

Replace the sample values for **Resource Group** and **emailAddress** with the appropriate values for your environment.

# [CLI](#tab/CLI)

```azurecli
az login
az deployment group create --name CreateServiceHealthAlert --resource-group my-resource-group --template-file CreateServiceHealthAlert.json --parameters emailAddress='user@contoso.com'
```

# [PowerShell](#tab/PowerShell)

```powershell
Connect-AzAccount
Select-AzSubscription -SubscriptionName my-subscription
New-AzResourceGroupDeployment -Name CreateServiceHealthAlert -ResourceGroupName my-resource-group -TemplateFile CreateServiceHealthAlert.json -emailAddress user@contoso.com
```

---

**3. Validate the deployment**

Verify that the workspace is created using one of the following commands. Replace the sample values for **Resource Group** with the values you used.

# [CLI](#tab/CLI)

```azurecli
az monitor activity-log alert show --resource-group my-resource-group --name ServiceHealthActivityLogAlert
```

# [PowerShell](#tab/PowerShell)

```powershell
Get-AzActivityLogAlert -ResourceGroupName my-resource-group -Name ServiceHealthActivityLogAlert
```

---

**4. Clean up resources**

If you plan to continue working with subsequent quickstarts and tutorials, you might want to leave these resources in place. 

You can delete the resource group when it's no longer needed, which deletes the alert rule and the related resources. To delete the resource group by using Azure CLI or Azure PowerShell commands shown here.

# [CLI](#tab/CLI)

```azurecli
az group delete --name my-resource-group
```

# [PowerShell](#tab/PowerShell)

```powershell
Remove-AzResourceGroup -Name my-resource-group
```

---

## Next steps

- Learn about [best practices for setting up Azure Service Health alerts](https://learn-video.azurefd.net/vod/player?id=771688cf-0348-44c4-ba48-f36bcd0aba3f).
- Learn how to [setup mobile push notifications for Azure Service Health](https://learn-video.azurefd.net/vod/player?id=4a3171ca-2104-4447-8f4b-c4d27f6dfe96).
- Learn how to [configure webhook notifications for existing problem management systems](service-health-alert-webhook-guide.md).
- Learn about [service health notifications](service-notifications.md).
- Learn about [notification rate limiting](../azure-monitor/alerts/alerts-rate-limiting.md).
- Review the [Service health alert webhook schema](../azure-monitor/alerts/activity-log-alerts-webhook.md).
- Get an [overview of Service health alerts](../azure-monitor/alerts/alerts-overview.md), and learn how to receive alerts.
- Learn more about [action groups](../azure-monitor/alerts/action-groups.md).
