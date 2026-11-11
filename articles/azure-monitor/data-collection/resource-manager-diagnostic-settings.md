---
title: Resource Manager Template Samples for Diagnostic Settings
description: Sample Azure Resource Manager templates to apply Azure Monitor diagnostic settings to an Azure resource.
ms.topic: sample
ms.custom: devx-track-arm-template, cbo-v1.6
ms.date: 08/07/2026
ms.reviewer: lualderm
ai-usage: ai-assisted
---

# Resource Manager template samples for diagnostic settings in Azure Monitor

This article includes sample [Azure Resource Manager templates](/azure/azure-resource-manager/templates/syntax) to create diagnostic settings for an Azure resource. Each sample includes a template file and a parameters file with sample values to provide to the template.

> [!NOTE]
> Before you deploy a sample:
>
> * Ensure that the monitored resource and each selected destination already exist. The Bicep `existing` declarations reference monitored resources; they don't create or update them.
> * Provide the destination subscription, resource group, and resource names used to compose the resource IDs. The resource-group templates target a monitored resource in the deployment resource group unless their scope says otherwise.
> * Check the resource's supported log and metric categories and the [destination requirements](diagnostic-settings.md#destinations).
> * Use a new diagnostic-setting name to add a setting. Reusing an existing name updates that setting, so preserve its required destinations, logs, metrics, retention configuration, and other settings.
>
> Each named API-version placeholder corresponds to its resource declaration. Use the resource type's [template reference](/azure/templates/) to resolve that version. The Storage sample also uses a separately named API version for its endpoint lookup and its nested deployment.

To create a diagnostic setting for an Azure resource, add a resource of type `<resource namespace>/providers/diagnosticSettings` to the template. This article provides examples for some resource types, but the same pattern can be applied to other resource types. The collection of allowed logs and metrics varies for each resource type.

> [!IMPORTANT]
> Template deployments create or update the named diagnostic setting; they aren't partial PATCH operations. When updating a setting, preserve its required destinations and complete log and metric collections.

The following table lists the resource types with samples in this article.

| Resource type | Diagnostic settings resource |
| --- | --- |
| Activity log | `Microsoft.Insights/diagnosticSettings` |
| Azure Data Explorer | `Microsoft.Kusto/clusters/providers/diagnosticSettings` |
| Azure Key Vault | `Microsoft.KeyVault/vaults/providers/diagnosticSettings` |
| Azure SQL Database | `microsoft.sql/servers/databases/providers/diagnosticSettings` |
| Azure SQL Managed Instance | `microsoft.sql/managedInstances/providers/diagnosticSettings` |
| Managed instance of Azure SQL Database | `microsoft.sql/managedInstances/databases/providers/diagnosticSettings` |
| Recovery Services vault | `microsoft.recoveryservices/vaults/providers/diagnosticSettings` |
| Log Analytics workspace | `Microsoft.OperationalInsights/workspaces/providers/diagnosticSettings` |
| Azure Storage | `Microsoft.Storage/storageAccounts/providers/diagnosticSettings` |

[!INCLUDE [azure-monitor-samples](../fundamentals/includes/azure-monitor-resource-manager-samples.md)]

## Diagnostic setting for an activity log

> [!IMPORTANT]
> Diagnostic settings for activity logs are created for a subscription, not for a resource group like settings for Azure resources. To deploy the Resource Manager template, use `New-AzSubscriptionDeployment` for PowerShell or `az deployment sub create` for the Azure CLI.

### Activity log

The following sample creates a diagnostic setting for an activity log by adding a resource of type `Microsoft.Insights/diagnosticSettings` to the template.

# [Bicep](#tab/bicep)

The following Bicep example uses the [`Microsoft.Insights/diagnosticSettings`](/azure/templates/microsoft.insights/diagnosticsettings?pivots=deployment-language-bicep) resource type.

<br>
<details>
<summary>Configure diagnostic destinations for the activity log</summary>

```bicep
targetScope = 'subscription'

param settingName string = '<SettingName>'

param destinationWorkspaceSubscriptionId string = '<DestinationWorkspaceSubscriptionId>'
param destinationWorkspaceResourceGroupName string = '<DestinationWorkspaceResourceGroupName>'
param destinationWorkspaceName string = '<DestinationWorkspaceName>'

param destinationStorageSubscriptionId string = '<DestinationStorageSubscriptionId>'
param destinationStorageResourceGroupName string = '<DestinationStorageResourceGroupName>'
param destinationStorageAccountName string = '<DestinationStorageAccountName>'

param eventHubSubscriptionId string = '<EventHubSubscriptionId>'
param eventHubResourceGroupName string = '<EventHubResourceGroupName>'
param eventHubNamespaceName string = '<EventHubNamespaceName>'
param eventHubAuthorizationRuleName string = '<EventHubAuthorizationRuleName>'

param eventHubName string = '<EventHubName>'

var workspaceId = resourceId(
  destinationWorkspaceSubscriptionId,
  destinationWorkspaceResourceGroupName,
  'Microsoft.OperationalInsights/workspaces',
  destinationWorkspaceName
)

var storageAccountId = resourceId(
  destinationStorageSubscriptionId,
  destinationStorageResourceGroupName,
  'Microsoft.Storage/storageAccounts',
  destinationStorageAccountName
)

var eventHubAuthorizationRuleId = resourceId(
  eventHubSubscriptionId,
  eventHubResourceGroupName,
  'Microsoft.EventHub/namespaces/authorizationRules',
  eventHubNamespaceName,
  eventHubAuthorizationRuleName
)

resource diagnosticSetting 'Microsoft.Insights/diagnosticSettings@<DiagnosticSettingsApiVersion>' = {
  name: settingName
  properties: {
    workspaceId: workspaceId
    storageAccountId: storageAccountId
    eventHubAuthorizationRuleId: eventHubAuthorizationRuleId
    eventHubName: eventHubName
    logs: [
      {
        category: 'Administrative'
        enabled: true
      }
      {
        category: 'Security'
        enabled: true
      }
      {
        category: 'ServiceHealth'
        enabled: true
      }
      {
        category: 'Alert'
        enabled: true
      }
      {
        category: 'Recommendation'
        enabled: true
      }
      {
        category: 'Policy'
        enabled: true
      }
      {
        category: 'Autoscale'
        enabled: true
      }
      {
        category: 'ResourceHealth'
        enabled: true
      }
    ]
  }
}
```

</details>

# [ARM template](#tab/arm)

The following ARM template example uses the [`Microsoft.Insights/diagnosticSettings`](/azure/templates/microsoft.insights/diagnosticsettings?pivots=deployment-language-arm-template) resource type.

<br>
<details>
<summary>Configure diagnostic destinations for the activity log</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2018-05-01/subscriptionDeploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "settingName": {
      "type": "string",
      "defaultValue": "<SettingName>"
    },
    "destinationWorkspaceSubscriptionId": {
      "type": "string",
      "defaultValue": "<DestinationWorkspaceSubscriptionId>"
    },
    "destinationWorkspaceResourceGroupName": {
      "type": "string",
      "defaultValue": "<DestinationWorkspaceResourceGroupName>"
    },
    "destinationWorkspaceName": {
      "type": "string",
      "defaultValue": "<DestinationWorkspaceName>"
    },
    "destinationStorageSubscriptionId": {
      "type": "string",
      "defaultValue": "<DestinationStorageSubscriptionId>"
    },
    "destinationStorageResourceGroupName": {
      "type": "string",
      "defaultValue": "<DestinationStorageResourceGroupName>"
    },
    "destinationStorageAccountName": {
      "type": "string",
      "defaultValue": "<DestinationStorageAccountName>"
    },
    "eventHubSubscriptionId": {
      "type": "string",
      "defaultValue": "<EventHubSubscriptionId>"
    },
    "eventHubResourceGroupName": {
      "type": "string",
      "defaultValue": "<EventHubResourceGroupName>"
    },
    "eventHubNamespaceName": {
      "type": "string",
      "defaultValue": "<EventHubNamespaceName>"
    },
    "eventHubAuthorizationRuleName": {
      "type": "string",
      "defaultValue": "<EventHubAuthorizationRuleName>"
    },
    "eventHubName": {
      "type": "string",
      "defaultValue": "<EventHubName>"
    }
  },
  "resources": [
    {
      "type": "Microsoft.Insights/diagnosticSettings",
      "apiVersion": "<DiagnosticSettingsApiVersion>",
      "name": "[parameters('settingName')]",
      "properties": {
        "workspaceId": "[variables('workspaceId')]",
        "storageAccountId": "[variables('storageAccountId')]",
        "eventHubAuthorizationRuleId": "[variables('eventHubAuthorizationRuleId')]",
        "eventHubName": "[parameters('eventHubName')]",
        "logs": [
          {
            "category": "Administrative",
            "enabled": true
          },
          {
            "category": "Security",
            "enabled": true
          },
          {
            "category": "ServiceHealth",
            "enabled": true
          },
          {
            "category": "Alert",
            "enabled": true
          },
          {
            "category": "Recommendation",
            "enabled": true
          },
          {
            "category": "Policy",
            "enabled": true
          },
          {
            "category": "Autoscale",
            "enabled": true
          },
          {
            "category": "ResourceHealth",
            "enabled": true
          }
        ]
      }
    }
  ],
  "variables": {
    "workspaceId": "[resourceId(parameters('destinationWorkspaceSubscriptionId'), parameters('destinationWorkspaceResourceGroupName'), 'Microsoft.OperationalInsights/workspaces', parameters('destinationWorkspaceName'))]",
    "storageAccountId": "[resourceId(parameters('destinationStorageSubscriptionId'), parameters('destinationStorageResourceGroupName'), 'Microsoft.Storage/storageAccounts', parameters('destinationStorageAccountName'))]",
    "eventHubAuthorizationRuleId": "[resourceId(parameters('eventHubSubscriptionId'), parameters('eventHubResourceGroupName'), 'Microsoft.EventHub/namespaces/authorizationRules', parameters('eventHubNamespaceName'), parameters('eventHubAuthorizationRuleName'))]"
  }
}
```

</details>

---

<br>
<details>
<summary><strong>Activity log parameter file</strong></summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "settingName": {
      "value": "<SettingName>"
    },
    "destinationWorkspaceSubscriptionId": {
      "value": "<DestinationWorkspaceSubscriptionId>"
    },
    "destinationWorkspaceResourceGroupName": {
      "value": "<DestinationWorkspaceResourceGroupName>"
    },
    "destinationWorkspaceName": {
      "value": "<DestinationWorkspaceName>"
    },
    "destinationStorageSubscriptionId": {
      "value": "<DestinationStorageSubscriptionId>"
    },
    "destinationStorageResourceGroupName": {
      "value": "<DestinationStorageResourceGroupName>"
    },
    "destinationStorageAccountName": {
      "value": "<DestinationStorageAccountName>"
    },
    "eventHubSubscriptionId": {
      "value": "<EventHubSubscriptionId>"
    },
    "eventHubResourceGroupName": {
      "value": "<EventHubResourceGroupName>"
    },
    "eventHubNamespaceName": {
      "value": "<EventHubNamespaceName>"
    },
    "eventHubAuthorizationRuleName": {
      "value": "<EventHubAuthorizationRuleName>"
    },
    "eventHubName": {
      "value": "<EventHubName>"
    }
  }
}
```

</details>

## Diagnostic setting for Azure Data Explorer

The following sample creates a diagnostic setting for an Azure Data Explorer cluster by adding a resource of type `Microsoft.Kusto/clusters/providers/diagnosticSettings` to the template.

### Azure Data Explorer

# [Bicep](#tab/bicep)

The following Bicep example uses the [`Microsoft.Insights/diagnosticSettings`](/azure/templates/microsoft.insights/diagnosticsettings?pivots=deployment-language-bicep) resource type.

<br>
<details>
<summary>Configure diagnostic categories for Azure Data Explorer</summary>

```bicep
param clusterName string = '<ClusterName>'
param settingName string = '<SettingName>'
param destinationWorkspaceSubscriptionId string = '<DestinationWorkspaceSubscriptionId>'
param destinationWorkspaceResourceGroupName string = '<DestinationWorkspaceResourceGroupName>'
param destinationWorkspaceName string = '<DestinationWorkspaceName>'
param destinationStorageSubscriptionId string = '<DestinationStorageSubscriptionId>'
param destinationStorageResourceGroupName string = '<DestinationStorageResourceGroupName>'
param destinationStorageAccountName string = '<DestinationStorageAccountName>'
param eventHubSubscriptionId string = '<EventHubSubscriptionId>'
param eventHubResourceGroupName string = '<EventHubResourceGroupName>'
param eventHubNamespaceName string = '<EventHubNamespaceName>'
param eventHubAuthorizationRuleName string = '<EventHubAuthorizationRuleName>'
param eventHubName string = '<EventHubName>'

var workspaceId = resourceId(
  destinationWorkspaceSubscriptionId,
  destinationWorkspaceResourceGroupName,
  'Microsoft.OperationalInsights/workspaces',
  destinationWorkspaceName
)

var storageAccountId = resourceId(
  destinationStorageSubscriptionId,
  destinationStorageResourceGroupName,
  'Microsoft.Storage/storageAccounts',
  destinationStorageAccountName
)

var eventHubAuthorizationRuleId = resourceId(
  eventHubSubscriptionId,
  eventHubResourceGroupName,
  'Microsoft.EventHub/namespaces/authorizationRules',
  eventHubNamespaceName,
  eventHubAuthorizationRuleName
)

resource dataExplorerCluster 'Microsoft.Kusto/clusters@<DataExplorerClusterApiVersion>' existing = {
  name: clusterName
}

resource diagnosticSetting 'Microsoft.Insights/diagnosticSettings@<DiagnosticSettingsApiVersion>' = {
  name: settingName
  scope: dataExplorerCluster
  properties: {
    workspaceId: workspaceId
    storageAccountId: storageAccountId
    eventHubAuthorizationRuleId: eventHubAuthorizationRuleId
    eventHubName: eventHubName
    metrics: []
    logs: [
      {
        category: 'Command'
        categoryGroup: null
        enabled: true
        retentionPolicy: {
          enabled: false
          days: 0
        }
      }
      {
        category: 'Query'
        categoryGroup: null
        enabled: true
        retentionPolicy: {
          enabled: false
          days: 0
        }
      }
      {
        category: 'Journal'
        categoryGroup: null
        enabled: true
        retentionPolicy: {
          enabled: false
          days: 0
        }
      }
      {
        category: 'SucceededIngestion'
        categoryGroup: null
        enabled: false
        retentionPolicy: {
          enabled: false
          days: 0
        }
      }
      {
        category: 'FailedIngestion'
        categoryGroup: null
        enabled: false
        retentionPolicy: {
          enabled: false
          days: 0
        }
      }
      {
        category: 'IngestionBatching'
        categoryGroup: null
        enabled: false
        retentionPolicy: {
          enabled: false
          days: 0
        }
      }
      {
        category: 'TableUsageStatistics'
        categoryGroup: null
        enabled: false
        retentionPolicy: {
          enabled: false
          days: 0
        }
      }
      {
        category: 'TableDetails'
        categoryGroup: null
        enabled: false
        retentionPolicy: {
          enabled: false
          days: 0
        }
      }
    ]
  }
}
```

</details>

# [ARM template](#tab/arm)

The following ARM template example uses the [`Microsoft.Insights/diagnosticSettings`](/azure/templates/microsoft.insights/diagnosticsettings?pivots=deployment-language-arm-template) resource type.

<br>
<details>
<summary>Configure diagnostic categories for Azure Data Explorer</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "clusterName": {
      "type": "string",
      "defaultValue": "<ClusterName>"
    },
    "settingName": {
      "type": "string",
      "defaultValue": "<SettingName>"
    },
    "destinationWorkspaceSubscriptionId": {
      "type": "string",
      "defaultValue": "<DestinationWorkspaceSubscriptionId>"
    },
    "destinationWorkspaceResourceGroupName": {
      "type": "string",
      "defaultValue": "<DestinationWorkspaceResourceGroupName>"
    },
    "destinationWorkspaceName": {
      "type": "string",
      "defaultValue": "<DestinationWorkspaceName>"
    },
    "destinationStorageSubscriptionId": {
      "type": "string",
      "defaultValue": "<DestinationStorageSubscriptionId>"
    },
    "destinationStorageResourceGroupName": {
      "type": "string",
      "defaultValue": "<DestinationStorageResourceGroupName>"
    },
    "destinationStorageAccountName": {
      "type": "string",
      "defaultValue": "<DestinationStorageAccountName>"
    },
    "eventHubSubscriptionId": {
      "type": "string",
      "defaultValue": "<EventHubSubscriptionId>"
    },
    "eventHubResourceGroupName": {
      "type": "string",
      "defaultValue": "<EventHubResourceGroupName>"
    },
    "eventHubNamespaceName": {
      "type": "string",
      "defaultValue": "<EventHubNamespaceName>"
    },
    "eventHubAuthorizationRuleName": {
      "type": "string",
      "defaultValue": "<EventHubAuthorizationRuleName>"
    },
    "eventHubName": {
      "type": "string",
      "defaultValue": "<EventHubName>"
    }
  },
  "resources": [
    {
      "type": "Microsoft.Insights/diagnosticSettings",
      "apiVersion": "<DiagnosticSettingsApiVersion>",
      "scope": "[format('Microsoft.Kusto/clusters/{0}', parameters('clusterName'))]",
      "name": "[parameters('settingName')]",
      "properties": {
        "workspaceId": "[variables('workspaceId')]",
        "storageAccountId": "[variables('storageAccountId')]",
        "eventHubAuthorizationRuleId": "[variables('eventHubAuthorizationRuleId')]",
        "eventHubName": "[parameters('eventHubName')]",
        "metrics": [],
        "logs": [
          {
            "category": "Command",
            "categoryGroup": null,
            "enabled": true,
            "retentionPolicy": {
              "enabled": false,
              "days": 0
            }
          },
          {
            "category": "Query",
            "categoryGroup": null,
            "enabled": true,
            "retentionPolicy": {
              "enabled": false,
              "days": 0
            }
          },
          {
            "category": "Journal",
            "categoryGroup": null,
            "enabled": true,
            "retentionPolicy": {
              "enabled": false,
              "days": 0
            }
          },
          {
            "category": "SucceededIngestion",
            "categoryGroup": null,
            "enabled": false,
            "retentionPolicy": {
              "enabled": false,
              "days": 0
            }
          },
          {
            "category": "FailedIngestion",
            "categoryGroup": null,
            "enabled": false,
            "retentionPolicy": {
              "enabled": false,
              "days": 0
            }
          },
          {
            "category": "IngestionBatching",
            "categoryGroup": null,
            "enabled": false,
            "retentionPolicy": {
              "enabled": false,
              "days": 0
            }
          },
          {
            "category": "TableUsageStatistics",
            "categoryGroup": null,
            "enabled": false,
            "retentionPolicy": {
              "enabled": false,
              "days": 0
            }
          },
          {
            "category": "TableDetails",
            "categoryGroup": null,
            "enabled": false,
            "retentionPolicy": {
              "enabled": false,
              "days": 0
            }
          }
        ]
      }
    }
  ],
  "variables": {
    "workspaceId": "[resourceId(parameters('destinationWorkspaceSubscriptionId'), parameters('destinationWorkspaceResourceGroupName'), 'Microsoft.OperationalInsights/workspaces', parameters('destinationWorkspaceName'))]",
    "storageAccountId": "[resourceId(parameters('destinationStorageSubscriptionId'), parameters('destinationStorageResourceGroupName'), 'Microsoft.Storage/storageAccounts', parameters('destinationStorageAccountName'))]",
    "eventHubAuthorizationRuleId": "[resourceId(parameters('eventHubSubscriptionId'), parameters('eventHubResourceGroupName'), 'Microsoft.EventHub/namespaces/authorizationRules', parameters('eventHubNamespaceName'), parameters('eventHubAuthorizationRuleName'))]"
  }
}
```

</details>

---

<br>
<details>
<summary><strong>Azure Data Explorer parameter file</strong></summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "clusterName": {
      "value": "<ClusterName>"
    },
    "settingName": {
      "value": "<SettingName>"
    },
    "destinationWorkspaceSubscriptionId": {
      "value": "<DestinationWorkspaceSubscriptionId>"
    },
    "destinationWorkspaceResourceGroupName": {
      "value": "<DestinationWorkspaceResourceGroupName>"
    },
    "destinationWorkspaceName": {
      "value": "<DestinationWorkspaceName>"
    },
    "destinationStorageSubscriptionId": {
      "value": "<DestinationStorageSubscriptionId>"
    },
    "destinationStorageResourceGroupName": {
      "value": "<DestinationStorageResourceGroupName>"
    },
    "destinationStorageAccountName": {
      "value": "<DestinationStorageAccountName>"
    },
    "eventHubSubscriptionId": {
      "value": "<EventHubSubscriptionId>"
    },
    "eventHubResourceGroupName": {
      "value": "<EventHubResourceGroupName>"
    },
    "eventHubNamespaceName": {
      "value": "<EventHubNamespaceName>"
    },
    "eventHubAuthorizationRuleName": {
      "value": "<EventHubAuthorizationRuleName>"
    },
    "eventHubName": {
      "value": "<EventHubName>"
    }
  }
}
```

</details>

### Azure Data Explorer: enabling the 'audit' category group

> [!NOTE]
> Use this variant instead of the individual-category example when you want the `audit` category group. Both variants use the Azure Data Explorer parameter file.

# [Bicep](#tab/bicep)

The following Bicep example uses the [`Microsoft.Insights/diagnosticSettings`](/azure/templates/microsoft.insights/diagnosticsettings?pivots=deployment-language-bicep) resource type.

<br>
<details>
<summary>Enable the Azure Data Explorer audit category group</summary>

```bicep
param clusterName string = '<ClusterName>'
param settingName string = '<SettingName>'
param destinationWorkspaceSubscriptionId string = '<DestinationWorkspaceSubscriptionId>'
param destinationWorkspaceResourceGroupName string = '<DestinationWorkspaceResourceGroupName>'
param destinationWorkspaceName string = '<DestinationWorkspaceName>'
param destinationStorageSubscriptionId string = '<DestinationStorageSubscriptionId>'
param destinationStorageResourceGroupName string = '<DestinationStorageResourceGroupName>'
param destinationStorageAccountName string = '<DestinationStorageAccountName>'
param eventHubSubscriptionId string = '<EventHubSubscriptionId>'
param eventHubResourceGroupName string = '<EventHubResourceGroupName>'
param eventHubNamespaceName string = '<EventHubNamespaceName>'
param eventHubAuthorizationRuleName string = '<EventHubAuthorizationRuleName>'
param eventHubName string = '<EventHubName>'

var workspaceId = resourceId(
  destinationWorkspaceSubscriptionId,
  destinationWorkspaceResourceGroupName,
  'Microsoft.OperationalInsights/workspaces',
  destinationWorkspaceName
)

var storageAccountId = resourceId(
  destinationStorageSubscriptionId,
  destinationStorageResourceGroupName,
  'Microsoft.Storage/storageAccounts',
  destinationStorageAccountName
)

var eventHubAuthorizationRuleId = resourceId(
  eventHubSubscriptionId,
  eventHubResourceGroupName,
  'Microsoft.EventHub/namespaces/authorizationRules',
  eventHubNamespaceName,
  eventHubAuthorizationRuleName
)

resource dataExplorerCluster 'Microsoft.Kusto/clusters@<DataExplorerClusterApiVersion>' existing = {
  name: clusterName
}

resource diagnosticSetting 'Microsoft.Insights/diagnosticSettings@<DiagnosticSettingsApiVersion>' = {
  name: settingName
  scope: dataExplorerCluster
  properties: {
    workspaceId: workspaceId
    storageAccountId: storageAccountId
    eventHubAuthorizationRuleId: eventHubAuthorizationRuleId
    eventHubName: eventHubName
    logs: [
      {
        category: null
        categoryGroup: 'audit'
        enabled: true
        retentionPolicy: {
          enabled: false
          days: 0
        }
      }
    ]
  }
}
```

</details>

# [ARM template](#tab/arm)

The following ARM template example uses the [`Microsoft.Insights/diagnosticSettings`](/azure/templates/microsoft.insights/diagnosticsettings?pivots=deployment-language-arm-template) resource type.

<br>
<details>
<summary>Enable the Azure Data Explorer audit category group</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "clusterName": {
      "type": "string",
      "defaultValue": "<ClusterName>"
    },
    "settingName": {
      "type": "string",
      "defaultValue": "<SettingName>"
    },
    "destinationWorkspaceSubscriptionId": {
      "type": "string",
      "defaultValue": "<DestinationWorkspaceSubscriptionId>"
    },
    "destinationWorkspaceResourceGroupName": {
      "type": "string",
      "defaultValue": "<DestinationWorkspaceResourceGroupName>"
    },
    "destinationWorkspaceName": {
      "type": "string",
      "defaultValue": "<DestinationWorkspaceName>"
    },
    "destinationStorageSubscriptionId": {
      "type": "string",
      "defaultValue": "<DestinationStorageSubscriptionId>"
    },
    "destinationStorageResourceGroupName": {
      "type": "string",
      "defaultValue": "<DestinationStorageResourceGroupName>"
    },
    "destinationStorageAccountName": {
      "type": "string",
      "defaultValue": "<DestinationStorageAccountName>"
    },
    "eventHubSubscriptionId": {
      "type": "string",
      "defaultValue": "<EventHubSubscriptionId>"
    },
    "eventHubResourceGroupName": {
      "type": "string",
      "defaultValue": "<EventHubResourceGroupName>"
    },
    "eventHubNamespaceName": {
      "type": "string",
      "defaultValue": "<EventHubNamespaceName>"
    },
    "eventHubAuthorizationRuleName": {
      "type": "string",
      "defaultValue": "<EventHubAuthorizationRuleName>"
    },
    "eventHubName": {
      "type": "string",
      "defaultValue": "<EventHubName>"
    }
  },
  "resources": [
    {
      "type": "Microsoft.Insights/diagnosticSettings",
      "apiVersion": "<DiagnosticSettingsApiVersion>",
      "scope": "[format('Microsoft.Kusto/clusters/{0}', parameters('clusterName'))]",
      "name": "[parameters('settingName')]",
      "properties": {
        "workspaceId": "[variables('workspaceId')]",
        "storageAccountId": "[variables('storageAccountId')]",
        "eventHubAuthorizationRuleId": "[variables('eventHubAuthorizationRuleId')]",
        "eventHubName": "[parameters('eventHubName')]",
        "logs": [
          {
            "category": null,
            "categoryGroup": "audit",
            "enabled": true,
            "retentionPolicy": {
              "enabled": false,
              "days": 0
            }
          }
        ]
      }
    }
  ],
  "variables": {
    "workspaceId": "[resourceId(parameters('destinationWorkspaceSubscriptionId'), parameters('destinationWorkspaceResourceGroupName'), 'Microsoft.OperationalInsights/workspaces', parameters('destinationWorkspaceName'))]",
    "storageAccountId": "[resourceId(parameters('destinationStorageSubscriptionId'), parameters('destinationStorageResourceGroupName'), 'Microsoft.Storage/storageAccounts', parameters('destinationStorageAccountName'))]",
    "eventHubAuthorizationRuleId": "[resourceId(parameters('eventHubSubscriptionId'), parameters('eventHubResourceGroupName'), 'Microsoft.EventHub/namespaces/authorizationRules', parameters('eventHubNamespaceName'), parameters('eventHubAuthorizationRuleName'))]"
  }
}
```

</details>

---

## Diagnostic setting for Azure Key Vault

> [!IMPORTANT]
> For Azure Key Vault, the event hub must be in the same region as the key vault.

### Azure Key Vault

The following sample creates a diagnostic setting for an instance of Azure Key Vault by adding a resource of type `Microsoft.KeyVault/vaults/providers/diagnosticSettings` to the template.

# [Bicep](#tab/bicep)

The following Bicep example uses the [`Microsoft.Insights/diagnosticSettings`](/azure/templates/microsoft.insights/diagnosticsettings?pivots=deployment-language-bicep) resource type.

<br>
<details>
<summary>Configure diagnostic destinations for Azure Key Vault</summary>

```bicep
param settingName string = '<SettingName>'

param vaultName string = '<VaultName>'

param destinationWorkspaceSubscriptionId string = '<DestinationWorkspaceSubscriptionId>'
param destinationWorkspaceResourceGroupName string = '<DestinationWorkspaceResourceGroupName>'
param destinationWorkspaceName string = '<DestinationWorkspaceName>'

param destinationStorageSubscriptionId string = '<DestinationStorageSubscriptionId>'
param destinationStorageResourceGroupName string = '<DestinationStorageResourceGroupName>'
param destinationStorageAccountName string = '<DestinationStorageAccountName>'

param eventHubSubscriptionId string = '<EventHubSubscriptionId>'
param eventHubResourceGroupName string = '<EventHubResourceGroupName>'
param eventHubNamespaceName string = '<EventHubNamespaceName>'
param eventHubAuthorizationRuleName string = '<EventHubAuthorizationRuleName>'

param eventHubName string = '<EventHubName>'

var workspaceId = resourceId(
  destinationWorkspaceSubscriptionId,
  destinationWorkspaceResourceGroupName,
  'Microsoft.OperationalInsights/workspaces',
  destinationWorkspaceName
)

var storageAccountId = resourceId(
  destinationStorageSubscriptionId,
  destinationStorageResourceGroupName,
  'Microsoft.Storage/storageAccounts',
  destinationStorageAccountName
)

var eventHubAuthorizationRuleId = resourceId(
  eventHubSubscriptionId,
  eventHubResourceGroupName,
  'Microsoft.EventHub/namespaces/authorizationRules',
  eventHubNamespaceName,
  eventHubAuthorizationRuleName
)

resource keyVault 'Microsoft.KeyVault/vaults@<KeyVaultApiVersion>' existing = {
  name: vaultName
}

resource diagnosticSetting 'Microsoft.Insights/diagnosticSettings@<DiagnosticSettingsApiVersion>' = {
  name: settingName
  scope: keyVault
  properties: {
    workspaceId: workspaceId
    storageAccountId: storageAccountId
    eventHubAuthorizationRuleId: eventHubAuthorizationRuleId
    eventHubName: eventHubName
    logs: [
      {
        category: 'AuditEvent'
        enabled: true
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
  }
}
```

</details>

# [ARM template](#tab/arm)

The following ARM template example uses the [`Microsoft.Insights/diagnosticSettings`](/azure/templates/microsoft.insights/diagnosticsettings?pivots=deployment-language-arm-template) resource type.

<br>
<details>
<summary>Configure diagnostic destinations for Azure Key Vault</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "settingName": {
      "type": "string",
      "defaultValue": "<SettingName>"
    },
    "vaultName": {
      "type": "string",
      "defaultValue": "<VaultName>"
    },
    "destinationWorkspaceSubscriptionId": {
      "type": "string",
      "defaultValue": "<DestinationWorkspaceSubscriptionId>"
    },
    "destinationWorkspaceResourceGroupName": {
      "type": "string",
      "defaultValue": "<DestinationWorkspaceResourceGroupName>"
    },
    "destinationWorkspaceName": {
      "type": "string",
      "defaultValue": "<DestinationWorkspaceName>"
    },
    "destinationStorageSubscriptionId": {
      "type": "string",
      "defaultValue": "<DestinationStorageSubscriptionId>"
    },
    "destinationStorageResourceGroupName": {
      "type": "string",
      "defaultValue": "<DestinationStorageResourceGroupName>"
    },
    "destinationStorageAccountName": {
      "type": "string",
      "defaultValue": "<DestinationStorageAccountName>"
    },
    "eventHubSubscriptionId": {
      "type": "string",
      "defaultValue": "<EventHubSubscriptionId>"
    },
    "eventHubResourceGroupName": {
      "type": "string",
      "defaultValue": "<EventHubResourceGroupName>"
    },
    "eventHubNamespaceName": {
      "type": "string",
      "defaultValue": "<EventHubNamespaceName>"
    },
    "eventHubAuthorizationRuleName": {
      "type": "string",
      "defaultValue": "<EventHubAuthorizationRuleName>"
    },
    "eventHubName": {
      "type": "string",
      "defaultValue": "<EventHubName>"
    }
  },
  "resources": [
    {
      "type": "Microsoft.Insights/diagnosticSettings",
      "apiVersion": "<DiagnosticSettingsApiVersion>",
      "scope": "[format('Microsoft.KeyVault/vaults/{0}', parameters('vaultName'))]",
      "name": "[parameters('settingName')]",
      "properties": {
        "workspaceId": "[variables('workspaceId')]",
        "storageAccountId": "[variables('storageAccountId')]",
        "eventHubAuthorizationRuleId": "[variables('eventHubAuthorizationRuleId')]",
        "eventHubName": "[parameters('eventHubName')]",
        "logs": [
          {
            "category": "AuditEvent",
            "enabled": true
          }
        ],
        "metrics": [
          {
            "category": "AllMetrics",
            "enabled": true
          }
        ]
      }
    }
  ],
  "variables": {
    "workspaceId": "[resourceId(parameters('destinationWorkspaceSubscriptionId'), parameters('destinationWorkspaceResourceGroupName'), 'Microsoft.OperationalInsights/workspaces', parameters('destinationWorkspaceName'))]",
    "storageAccountId": "[resourceId(parameters('destinationStorageSubscriptionId'), parameters('destinationStorageResourceGroupName'), 'Microsoft.Storage/storageAccounts', parameters('destinationStorageAccountName'))]",
    "eventHubAuthorizationRuleId": "[resourceId(parameters('eventHubSubscriptionId'), parameters('eventHubResourceGroupName'), 'Microsoft.EventHub/namespaces/authorizationRules', parameters('eventHubNamespaceName'), parameters('eventHubAuthorizationRuleName'))]"
  }
}
```

</details>

---

<br>
<details>
<summary><strong>Azure Key Vault parameter file</strong></summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "settingName": {
      "value": "<SettingName>"
    },
    "vaultName": {
      "value": "<VaultName>"
    },
    "destinationWorkspaceSubscriptionId": {
      "value": "<DestinationWorkspaceSubscriptionId>"
    },
    "destinationWorkspaceResourceGroupName": {
      "value": "<DestinationWorkspaceResourceGroupName>"
    },
    "destinationWorkspaceName": {
      "value": "<DestinationWorkspaceName>"
    },
    "destinationStorageSubscriptionId": {
      "value": "<DestinationStorageSubscriptionId>"
    },
    "destinationStorageResourceGroupName": {
      "value": "<DestinationStorageResourceGroupName>"
    },
    "destinationStorageAccountName": {
      "value": "<DestinationStorageAccountName>"
    },
    "eventHubSubscriptionId": {
      "value": "<EventHubSubscriptionId>"
    },
    "eventHubResourceGroupName": {
      "value": "<EventHubResourceGroupName>"
    },
    "eventHubNamespaceName": {
      "value": "<EventHubNamespaceName>"
    },
    "eventHubAuthorizationRuleName": {
      "value": "<EventHubAuthorizationRuleName>"
    },
    "eventHubName": {
      "value": "<EventHubName>"
    }
  }
}
```

</details>

## Diagnostic setting for Azure SQL Database

The following sample creates a diagnostic setting for an instance of Azure SQL Database by adding a resource of type `microsoft.sql/servers/databases/providers/diagnosticSettings` to the template.

### Azure SQL Database

# [Bicep](#tab/bicep)

The following Bicep example uses the [`Microsoft.Insights/diagnosticSettings`](/azure/templates/microsoft.insights/diagnosticsettings?pivots=deployment-language-bicep) resource type.

<br>
<details>
<summary>Configure diagnostic destinations for Azure SQL Database</summary>

```bicep
param settingName string = '<SettingName>'

param serverName string = '<ServerName>'

param dbName string = '<DbName>'

param destinationWorkspaceSubscriptionId string = '<DestinationWorkspaceSubscriptionId>'
param destinationWorkspaceResourceGroupName string = '<DestinationWorkspaceResourceGroupName>'
param destinationWorkspaceName string = '<DestinationWorkspaceName>'

param destinationStorageSubscriptionId string = '<DestinationStorageSubscriptionId>'
param destinationStorageResourceGroupName string = '<DestinationStorageResourceGroupName>'
param destinationStorageAccountName string = '<DestinationStorageAccountName>'

param eventHubSubscriptionId string = '<EventHubSubscriptionId>'
param eventHubResourceGroupName string = '<EventHubResourceGroupName>'
param eventHubNamespaceName string = '<EventHubNamespaceName>'
param eventHubAuthorizationRuleName string = '<EventHubAuthorizationRuleName>'

param eventHubName string = '<EventHubName>'

var workspaceId = resourceId(
  destinationWorkspaceSubscriptionId,
  destinationWorkspaceResourceGroupName,
  'Microsoft.OperationalInsights/workspaces',
  destinationWorkspaceName
)

var storageAccountId = resourceId(
  destinationStorageSubscriptionId,
  destinationStorageResourceGroupName,
  'Microsoft.Storage/storageAccounts',
  destinationStorageAccountName
)

var eventHubAuthorizationRuleId = resourceId(
  eventHubSubscriptionId,
  eventHubResourceGroupName,
  'Microsoft.EventHub/namespaces/authorizationRules',
  eventHubNamespaceName,
  eventHubAuthorizationRuleName
)

resource sqlServer 'Microsoft.Sql/servers@<SqlServerApiVersion>' existing = {
  name: serverName
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@<SqlDatabaseApiVersion>' existing = {
  parent: sqlServer
  name: dbName
}

resource diagnosticSetting 'Microsoft.Insights/diagnosticSettings@<DiagnosticSettingsApiVersion>' = {
  name: settingName
  scope: sqlDatabase
  properties: {
    workspaceId: workspaceId
    storageAccountId: storageAccountId
    eventHubAuthorizationRuleId: eventHubAuthorizationRuleId
    eventHubName: eventHubName
    logs: [
      {
        category: 'SQLInsights'
        enabled: true
      }
      {
        category: 'AutomaticTuning'
        enabled: true
      }
      {
        category: 'QueryStoreRuntimeStatistics'
        enabled: true
      }
      {
        category: 'QueryStoreWaitStatistics'
        enabled: true
      }
      {
        category: 'Errors'
        enabled: true
      }
      {
        category: 'DatabaseWaitStatistics'
        enabled: true
      }
      {
        category: 'Timeouts'
        enabled: true
      }
      {
        category: 'Blocks'
        enabled: true
      }
      {
        category: 'Deadlocks'
        enabled: true
      }
    ]
    metrics: [
      {
        category: 'Basic'
        enabled: true
      }
      {
        category: 'InstanceAndAppAdvanced'
        enabled: true
      }
      {
        category: 'WorkloadManagement'
        enabled: true
      }
    ]
  }
}
```

</details>

# [ARM template](#tab/arm)

The following ARM template example uses the [`Microsoft.Insights/diagnosticSettings`](/azure/templates/microsoft.insights/diagnosticsettings?pivots=deployment-language-arm-template) resource type.

<br>
<details>
<summary>Configure diagnostic destinations for Azure SQL Database</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "settingName": {
      "type": "string",
      "defaultValue": "<SettingName>"
    },
    "serverName": {
      "type": "string",
      "defaultValue": "<ServerName>"
    },
    "dbName": {
      "type": "string",
      "defaultValue": "<DbName>"
    },
    "destinationWorkspaceSubscriptionId": {
      "type": "string",
      "defaultValue": "<DestinationWorkspaceSubscriptionId>"
    },
    "destinationWorkspaceResourceGroupName": {
      "type": "string",
      "defaultValue": "<DestinationWorkspaceResourceGroupName>"
    },
    "destinationWorkspaceName": {
      "type": "string",
      "defaultValue": "<DestinationWorkspaceName>"
    },
    "destinationStorageSubscriptionId": {
      "type": "string",
      "defaultValue": "<DestinationStorageSubscriptionId>"
    },
    "destinationStorageResourceGroupName": {
      "type": "string",
      "defaultValue": "<DestinationStorageResourceGroupName>"
    },
    "destinationStorageAccountName": {
      "type": "string",
      "defaultValue": "<DestinationStorageAccountName>"
    },
    "eventHubSubscriptionId": {
      "type": "string",
      "defaultValue": "<EventHubSubscriptionId>"
    },
    "eventHubResourceGroupName": {
      "type": "string",
      "defaultValue": "<EventHubResourceGroupName>"
    },
    "eventHubNamespaceName": {
      "type": "string",
      "defaultValue": "<EventHubNamespaceName>"
    },
    "eventHubAuthorizationRuleName": {
      "type": "string",
      "defaultValue": "<EventHubAuthorizationRuleName>"
    },
    "eventHubName": {
      "type": "string",
      "defaultValue": "<EventHubName>"
    }
  },
  "resources": [
    {
      "type": "Microsoft.Insights/diagnosticSettings",
      "apiVersion": "<DiagnosticSettingsApiVersion>",
      "scope": "[format('Microsoft.Sql/servers/{0}/databases/{1}', parameters('serverName'), parameters('dbName'))]",
      "name": "[parameters('settingName')]",
      "properties": {
        "workspaceId": "[variables('workspaceId')]",
        "storageAccountId": "[variables('storageAccountId')]",
        "eventHubAuthorizationRuleId": "[variables('eventHubAuthorizationRuleId')]",
        "eventHubName": "[parameters('eventHubName')]",
        "logs": [
          {
            "category": "SQLInsights",
            "enabled": true
          },
          {
            "category": "AutomaticTuning",
            "enabled": true
          },
          {
            "category": "QueryStoreRuntimeStatistics",
            "enabled": true
          },
          {
            "category": "QueryStoreWaitStatistics",
            "enabled": true
          },
          {
            "category": "Errors",
            "enabled": true
          },
          {
            "category": "DatabaseWaitStatistics",
            "enabled": true
          },
          {
            "category": "Timeouts",
            "enabled": true
          },
          {
            "category": "Blocks",
            "enabled": true
          },
          {
            "category": "Deadlocks",
            "enabled": true
          }
        ],
        "metrics": [
          {
            "category": "Basic",
            "enabled": true
          },
          {
            "category": "InstanceAndAppAdvanced",
            "enabled": true
          },
          {
            "category": "WorkloadManagement",
            "enabled": true
          }
        ]
      }
    }
  ],
  "variables": {
    "workspaceId": "[resourceId(parameters('destinationWorkspaceSubscriptionId'), parameters('destinationWorkspaceResourceGroupName'), 'Microsoft.OperationalInsights/workspaces', parameters('destinationWorkspaceName'))]",
    "storageAccountId": "[resourceId(parameters('destinationStorageSubscriptionId'), parameters('destinationStorageResourceGroupName'), 'Microsoft.Storage/storageAccounts', parameters('destinationStorageAccountName'))]",
    "eventHubAuthorizationRuleId": "[resourceId(parameters('eventHubSubscriptionId'), parameters('eventHubResourceGroupName'), 'Microsoft.EventHub/namespaces/authorizationRules', parameters('eventHubNamespaceName'), parameters('eventHubAuthorizationRuleName'))]"
  }
}
```

</details>

---

<br>
<details>
<summary><strong>Azure SQL Database parameter file</strong></summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "settingName": {
      "value": "<SettingName>"
    },
    "serverName": {
      "value": "<ServerName>"
    },
    "dbName": {
      "value": "<DbName>"
    },
    "destinationWorkspaceSubscriptionId": {
      "value": "<DestinationWorkspaceSubscriptionId>"
    },
    "destinationWorkspaceResourceGroupName": {
      "value": "<DestinationWorkspaceResourceGroupName>"
    },
    "destinationWorkspaceName": {
      "value": "<DestinationWorkspaceName>"
    },
    "destinationStorageSubscriptionId": {
      "value": "<DestinationStorageSubscriptionId>"
    },
    "destinationStorageResourceGroupName": {
      "value": "<DestinationStorageResourceGroupName>"
    },
    "destinationStorageAccountName": {
      "value": "<DestinationStorageAccountName>"
    },
    "eventHubSubscriptionId": {
      "value": "<EventHubSubscriptionId>"
    },
    "eventHubResourceGroupName": {
      "value": "<EventHubResourceGroupName>"
    },
    "eventHubNamespaceName": {
      "value": "<EventHubNamespaceName>"
    },
    "eventHubAuthorizationRuleName": {
      "value": "<EventHubAuthorizationRuleName>"
    },
    "eventHubName": {
      "value": "<EventHubName>"
    }
  }
}
```

</details>

## Diagnostic setting for Azure SQL Managed Instance

The following sample creates a diagnostic setting for an instance of Azure SQL Managed Instance by adding a resource of type `microsoft.sql/managedInstances/providers/diagnosticSettings` to the template.

### Azure SQL Managed Instance

# [Bicep](#tab/bicep)

The following Bicep example uses the [`Microsoft.Insights/diagnosticSettings`](/azure/templates/microsoft.insights/diagnosticsettings?pivots=deployment-language-bicep) resource type.

<br>
<details>
<summary>Configure diagnostics for Azure SQL Managed Instance</summary>

```bicep
param sqlManagedInstanceName string = '<SqlManagedInstanceName>'
param diagnosticSettingName string = '<DiagnosticSettingName>'
param destinationWorkspaceSubscriptionId string = '<DestinationWorkspaceSubscriptionId>'
param destinationWorkspaceResourceGroupName string = '<DestinationWorkspaceResourceGroupName>'
param destinationWorkspaceName string = '<DestinationWorkspaceName>'
param destinationStorageSubscriptionId string = '<DestinationStorageSubscriptionId>'
param destinationStorageResourceGroupName string = '<DestinationStorageResourceGroupName>'
param destinationStorageAccountName string = '<DestinationStorageAccountName>'
param eventHubSubscriptionId string = '<EventHubSubscriptionId>'
param eventHubResourceGroupName string = '<EventHubResourceGroupName>'
param eventHubNamespaceName string = '<EventHubNamespaceName>'
param eventHubAuthorizationRuleName string = '<EventHubAuthorizationRuleName>'
param eventHubName string = '<EventHubName>'

var diagnosticWorkspaceId = resourceId(
  destinationWorkspaceSubscriptionId,
  destinationWorkspaceResourceGroupName,
  'Microsoft.OperationalInsights/workspaces',
  destinationWorkspaceName
)

var storageAccountId = resourceId(
  destinationStorageSubscriptionId,
  destinationStorageResourceGroupName,
  'Microsoft.Storage/storageAccounts',
  destinationStorageAccountName
)

var eventHubAuthorizationRuleId = resourceId(
  eventHubSubscriptionId,
  eventHubResourceGroupName,
  'Microsoft.EventHub/namespaces/authorizationRules',
  eventHubNamespaceName,
  eventHubAuthorizationRuleName
)

resource sqlManagedInstance 'Microsoft.Sql/managedInstances@<SqlManagedInstanceApiVersion>' existing = {
  name: sqlManagedInstanceName
}

resource diagnosticSetting 'Microsoft.Insights/diagnosticSettings@<DiagnosticSettingsApiVersion>' = {
  name: diagnosticSettingName
  scope: sqlManagedInstance
  properties: {
    workspaceId: diagnosticWorkspaceId
    storageAccountId: storageAccountId
    eventHubAuthorizationRuleId: eventHubAuthorizationRuleId
    eventHubName: eventHubName
    logs: [
      {
        category: 'ResourceUsageStats'
        enabled: true
      }
      {
        category: 'DevOpsOperationsAudit'
        enabled: true
      }
      {
        category: 'SQLSecurityAuditEvents'
        enabled: true
      }
    ]
  }
}
```

</details>

# [ARM template](#tab/arm)

The following ARM template example uses the [`Microsoft.Insights/diagnosticSettings`](/azure/templates/microsoft.insights/diagnosticsettings?pivots=deployment-language-arm-template) resource type.

<br>
<details>
<summary>Configure diagnostics for Azure SQL Managed Instance</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "sqlManagedInstanceName": {
      "type": "string",
      "defaultValue": "<SqlManagedInstanceName>"
    },
    "diagnosticSettingName": {
      "type": "string",
      "defaultValue": "<DiagnosticSettingName>"
    },
    "destinationWorkspaceSubscriptionId": {
      "type": "string",
      "defaultValue": "<DestinationWorkspaceSubscriptionId>"
    },
    "destinationWorkspaceResourceGroupName": {
      "type": "string",
      "defaultValue": "<DestinationWorkspaceResourceGroupName>"
    },
    "destinationWorkspaceName": {
      "type": "string",
      "defaultValue": "<DestinationWorkspaceName>"
    },
    "destinationStorageSubscriptionId": {
      "type": "string",
      "defaultValue": "<DestinationStorageSubscriptionId>"
    },
    "destinationStorageResourceGroupName": {
      "type": "string",
      "defaultValue": "<DestinationStorageResourceGroupName>"
    },
    "destinationStorageAccountName": {
      "type": "string",
      "defaultValue": "<DestinationStorageAccountName>"
    },
    "eventHubSubscriptionId": {
      "type": "string",
      "defaultValue": "<EventHubSubscriptionId>"
    },
    "eventHubResourceGroupName": {
      "type": "string",
      "defaultValue": "<EventHubResourceGroupName>"
    },
    "eventHubNamespaceName": {
      "type": "string",
      "defaultValue": "<EventHubNamespaceName>"
    },
    "eventHubAuthorizationRuleName": {
      "type": "string",
      "defaultValue": "<EventHubAuthorizationRuleName>"
    },
    "eventHubName": {
      "type": "string",
      "defaultValue": "<EventHubName>"
    }
  },
  "resources": [
    {
      "type": "Microsoft.Insights/diagnosticSettings",
      "apiVersion": "<DiagnosticSettingsApiVersion>",
      "scope": "[format('Microsoft.Sql/managedInstances/{0}', parameters('sqlManagedInstanceName'))]",
      "name": "[parameters('diagnosticSettingName')]",
      "properties": {
        "workspaceId": "[variables('diagnosticWorkspaceId')]",
        "storageAccountId": "[variables('storageAccountId')]",
        "eventHubAuthorizationRuleId": "[variables('eventHubAuthorizationRuleId')]",
        "eventHubName": "[parameters('eventHubName')]",
        "logs": [
          {
            "category": "ResourceUsageStats",
            "enabled": true
          },
          {
            "category": "DevOpsOperationsAudit",
            "enabled": true
          },
          {
            "category": "SQLSecurityAuditEvents",
            "enabled": true
          }
        ]
      }
    }
  ],
  "variables": {
    "diagnosticWorkspaceId": "[resourceId(parameters('destinationWorkspaceSubscriptionId'), parameters('destinationWorkspaceResourceGroupName'), 'Microsoft.OperationalInsights/workspaces', parameters('destinationWorkspaceName'))]",
    "storageAccountId": "[resourceId(parameters('destinationStorageSubscriptionId'), parameters('destinationStorageResourceGroupName'), 'Microsoft.Storage/storageAccounts', parameters('destinationStorageAccountName'))]",
    "eventHubAuthorizationRuleId": "[resourceId(parameters('eventHubSubscriptionId'), parameters('eventHubResourceGroupName'), 'Microsoft.EventHub/namespaces/authorizationRules', parameters('eventHubNamespaceName'), parameters('eventHubAuthorizationRuleName'))]"
  }
}
```

</details>

---

<br>
<details>
<summary><strong>Azure SQL Managed Instance parameter file</strong></summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "sqlManagedInstanceName": {
      "value": "<SqlManagedInstanceName>"
    },
    "diagnosticSettingName": {
      "value": "<DiagnosticSettingName>"
    },
    "destinationWorkspaceSubscriptionId": {
      "value": "<DestinationWorkspaceSubscriptionId>"
    },
    "destinationWorkspaceResourceGroupName": {
      "value": "<DestinationWorkspaceResourceGroupName>"
    },
    "destinationWorkspaceName": {
      "value": "<DestinationWorkspaceName>"
    },
    "destinationStorageSubscriptionId": {
      "value": "<DestinationStorageSubscriptionId>"
    },
    "destinationStorageResourceGroupName": {
      "value": "<DestinationStorageResourceGroupName>"
    },
    "destinationStorageAccountName": {
      "value": "<DestinationStorageAccountName>"
    },
    "eventHubSubscriptionId": {
      "value": "<EventHubSubscriptionId>"
    },
    "eventHubResourceGroupName": {
      "value": "<EventHubResourceGroupName>"
    },
    "eventHubNamespaceName": {
      "value": "<EventHubNamespaceName>"
    },
    "eventHubAuthorizationRuleName": {
      "value": "<EventHubAuthorizationRuleName>"
    },
    "eventHubName": {
      "value": "<EventHubName>"
    }
  }
}
```

</details>

## Diagnostic setting for a managed instance of Azure SQL Database

The following sample creates a diagnostic setting for a managed instance of Azure SQL Database by adding a resource of type `microsoft.sql/managedInstances/databases/providers/diagnosticSettings` to the template.

### Managed instance of Azure SQL Database

# [Bicep](#tab/bicep)

The following Bicep example uses the [`Microsoft.Insights/diagnosticSettings`](/azure/templates/microsoft.insights/diagnosticsettings?pivots=deployment-language-bicep) resource type.

<br>
<details>
<summary>Configure diagnostics for a managed SQL database</summary>

```bicep
param sqlManagedInstanceName string = '<SqlManagedInstanceName>'
param sqlManagedDatabaseName string = '<SqlManagedDatabaseName>'
param diagnosticSettingName string = '<DiagnosticSettingName>'
param destinationWorkspaceSubscriptionId string = '<DestinationWorkspaceSubscriptionId>'
param destinationWorkspaceResourceGroupName string = '<DestinationWorkspaceResourceGroupName>'
param destinationWorkspaceName string = '<DestinationWorkspaceName>'
param destinationStorageSubscriptionId string = '<DestinationStorageSubscriptionId>'
param destinationStorageResourceGroupName string = '<DestinationStorageResourceGroupName>'
param destinationStorageAccountName string = '<DestinationStorageAccountName>'
param eventHubSubscriptionId string = '<EventHubSubscriptionId>'
param eventHubResourceGroupName string = '<EventHubResourceGroupName>'
param eventHubNamespaceName string = '<EventHubNamespaceName>'
param eventHubAuthorizationRuleName string = '<EventHubAuthorizationRuleName>'
param eventHubName string = '<EventHubName>'

var diagnosticWorkspaceId = resourceId(
  destinationWorkspaceSubscriptionId,
  destinationWorkspaceResourceGroupName,
  'Microsoft.OperationalInsights/workspaces',
  destinationWorkspaceName
)

var storageAccountId = resourceId(
  destinationStorageSubscriptionId,
  destinationStorageResourceGroupName,
  'Microsoft.Storage/storageAccounts',
  destinationStorageAccountName
)

var eventHubAuthorizationRuleId = resourceId(
  eventHubSubscriptionId,
  eventHubResourceGroupName,
  'Microsoft.EventHub/namespaces/authorizationRules',
  eventHubNamespaceName,
  eventHubAuthorizationRuleName
)

resource sqlManagedInstance 'Microsoft.Sql/managedInstances@<SqlManagedInstanceApiVersion>' existing = {
  name:sqlManagedInstanceName
}

resource sqlManagedDatabase 'Microsoft.Sql/managedInstances/databases@<SqlManagedDatabaseApiVersion>' existing = {
  name: sqlManagedDatabaseName
  parent: sqlManagedInstance
}

resource diagnosticSetting 'Microsoft.Insights/diagnosticSettings@<DiagnosticSettingsApiVersion>' = {
  name: diagnosticSettingName
  scope: sqlManagedDatabase
  properties: {
    workspaceId: diagnosticWorkspaceId
    storageAccountId: storageAccountId
    eventHubAuthorizationRuleId: eventHubAuthorizationRuleId
    eventHubName: eventHubName
    logs: [
      {
        category: 'SQLInsights'
        enabled: true
      }
      {
        category: 'QueryStoreRuntimeStatistics'
        enabled: true
      }
      {
        category: 'QueryStoreWaitStatistics'
        enabled: true
      }
      {
        category: 'Errors'
        enabled: true
      }
    ]
  }
}
```

</details>

# [ARM template](#tab/arm)

The following ARM template example uses the [`Microsoft.Insights/diagnosticSettings`](/azure/templates/microsoft.insights/diagnosticsettings?pivots=deployment-language-arm-template) resource type.

<br>
<details>
<summary>Configure diagnostics for a managed SQL database</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "sqlManagedInstanceName": {
      "type": "string",
      "defaultValue": "<SqlManagedInstanceName>"
    },
    "sqlManagedDatabaseName": {
      "type": "string",
      "defaultValue": "<SqlManagedDatabaseName>"
    },
    "diagnosticSettingName": {
      "type": "string",
      "defaultValue": "<DiagnosticSettingName>"
    },
    "destinationWorkspaceSubscriptionId": {
      "type": "string",
      "defaultValue": "<DestinationWorkspaceSubscriptionId>"
    },
    "destinationWorkspaceResourceGroupName": {
      "type": "string",
      "defaultValue": "<DestinationWorkspaceResourceGroupName>"
    },
    "destinationWorkspaceName": {
      "type": "string",
      "defaultValue": "<DestinationWorkspaceName>"
    },
    "destinationStorageSubscriptionId": {
      "type": "string",
      "defaultValue": "<DestinationStorageSubscriptionId>"
    },
    "destinationStorageResourceGroupName": {
      "type": "string",
      "defaultValue": "<DestinationStorageResourceGroupName>"
    },
    "destinationStorageAccountName": {
      "type": "string",
      "defaultValue": "<DestinationStorageAccountName>"
    },
    "eventHubSubscriptionId": {
      "type": "string",
      "defaultValue": "<EventHubSubscriptionId>"
    },
    "eventHubResourceGroupName": {
      "type": "string",
      "defaultValue": "<EventHubResourceGroupName>"
    },
    "eventHubNamespaceName": {
      "type": "string",
      "defaultValue": "<EventHubNamespaceName>"
    },
    "eventHubAuthorizationRuleName": {
      "type": "string",
      "defaultValue": "<EventHubAuthorizationRuleName>"
    },
    "eventHubName": {
      "type": "string",
      "defaultValue": "<EventHubName>"
    }
  },
  "resources": [
    {
      "type": "Microsoft.Insights/diagnosticSettings",
      "apiVersion": "<DiagnosticSettingsApiVersion>",
      "scope": "[format('Microsoft.Sql/managedInstances/{0}/databases/{1}', parameters('sqlManagedInstanceName'), parameters('sqlManagedDatabaseName'))]",
      "name": "[parameters('diagnosticSettingName')]",
      "properties": {
        "workspaceId": "[variables('diagnosticWorkspaceId')]",
        "storageAccountId": "[variables('storageAccountId')]",
        "eventHubAuthorizationRuleId": "[variables('eventHubAuthorizationRuleId')]",
        "eventHubName": "[parameters('eventHubName')]",
        "logs": [
          {
            "category": "SQLInsights",
            "enabled": true
          },
          {
            "category": "QueryStoreRuntimeStatistics",
            "enabled": true
          },
          {
            "category": "QueryStoreWaitStatistics",
            "enabled": true
          },
          {
            "category": "Errors",
            "enabled": true
          }
        ]
      }
    }
  ],
  "variables": {
    "diagnosticWorkspaceId": "[resourceId(parameters('destinationWorkspaceSubscriptionId'), parameters('destinationWorkspaceResourceGroupName'), 'Microsoft.OperationalInsights/workspaces', parameters('destinationWorkspaceName'))]",
    "storageAccountId": "[resourceId(parameters('destinationStorageSubscriptionId'), parameters('destinationStorageResourceGroupName'), 'Microsoft.Storage/storageAccounts', parameters('destinationStorageAccountName'))]",
    "eventHubAuthorizationRuleId": "[resourceId(parameters('eventHubSubscriptionId'), parameters('eventHubResourceGroupName'), 'Microsoft.EventHub/namespaces/authorizationRules', parameters('eventHubNamespaceName'), parameters('eventHubAuthorizationRuleName'))]"
  }
}
```

</details>

---

<br>
<details>
<summary><strong>Managed instance of Azure SQL Database parameter file</strong></summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "sqlManagedInstanceName": {
      "value": "<SqlManagedInstanceName>"
    },
    "sqlManagedDatabaseName": {
      "value": "<SqlManagedDatabaseName>"
    },
    "diagnosticSettingName": {
      "value": "<DiagnosticSettingName>"
    },
    "destinationWorkspaceSubscriptionId": {
      "value": "<DestinationWorkspaceSubscriptionId>"
    },
    "destinationWorkspaceResourceGroupName": {
      "value": "<DestinationWorkspaceResourceGroupName>"
    },
    "destinationWorkspaceName": {
      "value": "<DestinationWorkspaceName>"
    },
    "destinationStorageSubscriptionId": {
      "value": "<DestinationStorageSubscriptionId>"
    },
    "destinationStorageResourceGroupName": {
      "value": "<DestinationStorageResourceGroupName>"
    },
    "destinationStorageAccountName": {
      "value": "<DestinationStorageAccountName>"
    },
    "eventHubSubscriptionId": {
      "value": "<EventHubSubscriptionId>"
    },
    "eventHubResourceGroupName": {
      "value": "<EventHubResourceGroupName>"
    },
    "eventHubNamespaceName": {
      "value": "<EventHubNamespaceName>"
    },
    "eventHubAuthorizationRuleName": {
      "value": "<EventHubAuthorizationRuleName>"
    },
    "eventHubName": {
      "value": "<EventHubName>"
    }
  }
}
```

</details>

## Diagnostic setting for Recovery Services vault

The following sample creates a diagnostic setting for an Azure Recovery Services vault by adding a resource of type `microsoft.recoveryservices/vaults/providers/diagnosticSettings` to the template. This example specifies the collection mode as described in [Azure resource logs](../logs/resource-logs.md#destinations). Specify `Dedicated` or `AzureDiagnostics` for the `logAnalyticsDestinationType` property.

### Recovery Services vault

# [Bicep](#tab/bicep)

The following Bicep example uses the [`Microsoft.Insights/diagnosticSettings`](/azure/templates/microsoft.insights/diagnosticsettings?pivots=deployment-language-bicep) resource type.

<br>
<details>
<summary>Configure diagnostic destinations for a Recovery Services vault</summary>

```bicep
param recoveryServicesName string = '<RecoveryServicesName>'
param settingName string = '<SettingName>'
param destinationWorkspaceSubscriptionId string = '<DestinationWorkspaceSubscriptionId>'
param destinationWorkspaceResourceGroupName string = '<DestinationWorkspaceResourceGroupName>'
param destinationWorkspaceName string = '<DestinationWorkspaceName>'
param destinationStorageSubscriptionId string = '<DestinationStorageSubscriptionId>'
param destinationStorageResourceGroupName string = '<DestinationStorageResourceGroupName>'
param destinationStorageAccountName string = '<DestinationStorageAccountName>'
param eventHubSubscriptionId string = '<EventHubSubscriptionId>'
param eventHubResourceGroupName string = '<EventHubResourceGroupName>'
param eventHubNamespaceName string = '<EventHubNamespaceName>'
param eventHubAuthorizationRuleName string = '<EventHubAuthorizationRuleName>'
param eventHubName string = '<EventHubName>'

var workspaceId = resourceId(
  destinationWorkspaceSubscriptionId,
  destinationWorkspaceResourceGroupName,
  'Microsoft.OperationalInsights/workspaces',
  destinationWorkspaceName
)

var storageAccountId = resourceId(
  destinationStorageSubscriptionId,
  destinationStorageResourceGroupName,
  'Microsoft.Storage/storageAccounts',
  destinationStorageAccountName
)

var eventHubAuthorizationRuleId = resourceId(
  eventHubSubscriptionId,
  eventHubResourceGroupName,
  'Microsoft.EventHub/namespaces/authorizationRules',
  eventHubNamespaceName,
  eventHubAuthorizationRuleName
)

resource recoveryServicesVault 'Microsoft.RecoveryServices/vaults@<RecoveryServicesVaultApiVersion>' existing = {
  name: recoveryServicesName
}

resource diagnosticSetting 'Microsoft.Insights/diagnosticSettings@<DiagnosticSettingsApiVersion>' = {
  name: settingName
  scope: recoveryServicesVault
  properties: {
    workspaceId: workspaceId
    storageAccountId: storageAccountId
    eventHubAuthorizationRuleId: eventHubAuthorizationRuleId
    eventHubName: eventHubName
    logs: [
      {
        category: 'AzureBackupReport'
        enabled: false
      }
      {
        category: 'CoreAzureBackup'
        enabled: true
      }
      {
        category: 'AddonAzureBackupJobs'
        enabled: true
      }
      {
        category: 'AddonAzureBackupAlerts'
        enabled: true
      }
      {
        category: 'AddonAzureBackupPolicy'
        enabled: true
      }
      {
        category: 'AddonAzureBackupStorage'
        enabled: true
      }
      {
        category: 'AddonAzureBackupProtectedInstance'
        enabled: true
      }
      {
        category: 'AzureSiteRecoveryJobs'
        enabled: false
      }
      {
        category: 'AzureSiteRecoveryEvents'
        enabled: false
      }
      {
        category: 'AzureSiteRecoveryReplicatedItems'
        enabled: false
      }
      {
        category: 'AzureSiteRecoveryReplicationStats'
        enabled: false
      }
      {
        category: 'AzureSiteRecoveryRecoveryPoints'
        enabled: false
      }
      {
        category: 'AzureSiteRecoveryReplicationDataUploadRate'
        enabled: false
      }
      {
        category: 'AzureSiteRecoveryProtectedDiskDataChurn'
        enabled: false
      }
    ]
    logAnalyticsDestinationType: 'Dedicated'
  }
}
```

</details>

# [ARM template](#tab/arm)

The following ARM template example uses the [`Microsoft.Insights/diagnosticSettings`](/azure/templates/microsoft.insights/diagnosticsettings?pivots=deployment-language-arm-template) resource type.

<br>
<details>
<summary>Configure diagnostic destinations for a Recovery Services vault</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "recoveryServicesName": {
      "type": "string",
      "defaultValue": "<RecoveryServicesName>"
    },
    "settingName": {
      "type": "string",
      "defaultValue": "<SettingName>"
    },
    "destinationWorkspaceSubscriptionId": {
      "type": "string",
      "defaultValue": "<DestinationWorkspaceSubscriptionId>"
    },
    "destinationWorkspaceResourceGroupName": {
      "type": "string",
      "defaultValue": "<DestinationWorkspaceResourceGroupName>"
    },
    "destinationWorkspaceName": {
      "type": "string",
      "defaultValue": "<DestinationWorkspaceName>"
    },
    "destinationStorageSubscriptionId": {
      "type": "string",
      "defaultValue": "<DestinationStorageSubscriptionId>"
    },
    "destinationStorageResourceGroupName": {
      "type": "string",
      "defaultValue": "<DestinationStorageResourceGroupName>"
    },
    "destinationStorageAccountName": {
      "type": "string",
      "defaultValue": "<DestinationStorageAccountName>"
    },
    "eventHubSubscriptionId": {
      "type": "string",
      "defaultValue": "<EventHubSubscriptionId>"
    },
    "eventHubResourceGroupName": {
      "type": "string",
      "defaultValue": "<EventHubResourceGroupName>"
    },
    "eventHubNamespaceName": {
      "type": "string",
      "defaultValue": "<EventHubNamespaceName>"
    },
    "eventHubAuthorizationRuleName": {
      "type": "string",
      "defaultValue": "<EventHubAuthorizationRuleName>"
    },
    "eventHubName": {
      "type": "string",
      "defaultValue": "<EventHubName>"
    }
  },
  "resources": [
    {
      "type": "Microsoft.Insights/diagnosticSettings",
      "apiVersion": "<DiagnosticSettingsApiVersion>",
      "scope": "[format('Microsoft.RecoveryServices/vaults/{0}', parameters('recoveryServicesName'))]",
      "name": "[parameters('settingName')]",
      "properties": {
        "workspaceId": "[variables('workspaceId')]",
        "storageAccountId": "[variables('storageAccountId')]",
        "eventHubAuthorizationRuleId": "[variables('eventHubAuthorizationRuleId')]",
        "eventHubName": "[parameters('eventHubName')]",
        "logs": [
          {
            "category": "AzureBackupReport",
            "enabled": false
          },
          {
            "category": "CoreAzureBackup",
            "enabled": true
          },
          {
            "category": "AddonAzureBackupJobs",
            "enabled": true
          },
          {
            "category": "AddonAzureBackupAlerts",
            "enabled": true
          },
          {
            "category": "AddonAzureBackupPolicy",
            "enabled": true
          },
          {
            "category": "AddonAzureBackupStorage",
            "enabled": true
          },
          {
            "category": "AddonAzureBackupProtectedInstance",
            "enabled": true
          },
          {
            "category": "AzureSiteRecoveryJobs",
            "enabled": false
          },
          {
            "category": "AzureSiteRecoveryEvents",
            "enabled": false
          },
          {
            "category": "AzureSiteRecoveryReplicatedItems",
            "enabled": false
          },
          {
            "category": "AzureSiteRecoveryReplicationStats",
            "enabled": false
          },
          {
            "category": "AzureSiteRecoveryRecoveryPoints",
            "enabled": false
          },
          {
            "category": "AzureSiteRecoveryReplicationDataUploadRate",
            "enabled": false
          },
          {
            "category": "AzureSiteRecoveryProtectedDiskDataChurn",
            "enabled": false
          }
        ],
        "logAnalyticsDestinationType": "Dedicated"
      }
    }
  ],
  "variables": {
    "workspaceId": "[resourceId(parameters('destinationWorkspaceSubscriptionId'), parameters('destinationWorkspaceResourceGroupName'), 'Microsoft.OperationalInsights/workspaces', parameters('destinationWorkspaceName'))]",
    "storageAccountId": "[resourceId(parameters('destinationStorageSubscriptionId'), parameters('destinationStorageResourceGroupName'), 'Microsoft.Storage/storageAccounts', parameters('destinationStorageAccountName'))]",
    "eventHubAuthorizationRuleId": "[resourceId(parameters('eventHubSubscriptionId'), parameters('eventHubResourceGroupName'), 'Microsoft.EventHub/namespaces/authorizationRules', parameters('eventHubNamespaceName'), parameters('eventHubAuthorizationRuleName'))]"
  }
}
```

</details>

---

<br>
<details>
<summary><strong>Recovery Services vault parameter file</strong></summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "settingName": {
      "value": "<SettingName>"
    },
    "recoveryServicesName": {
      "value": "<RecoveryServicesName>"
    },
    "destinationWorkspaceSubscriptionId": {
      "value": "<DestinationWorkspaceSubscriptionId>"
    },
    "destinationWorkspaceResourceGroupName": {
      "value": "<DestinationWorkspaceResourceGroupName>"
    },
    "destinationWorkspaceName": {
      "value": "<DestinationWorkspaceName>"
    },
    "destinationStorageSubscriptionId": {
      "value": "<DestinationStorageSubscriptionId>"
    },
    "destinationStorageResourceGroupName": {
      "value": "<DestinationStorageResourceGroupName>"
    },
    "destinationStorageAccountName": {
      "value": "<DestinationStorageAccountName>"
    },
    "eventHubSubscriptionId": {
      "value": "<EventHubSubscriptionId>"
    },
    "eventHubResourceGroupName": {
      "value": "<EventHubResourceGroupName>"
    },
    "eventHubNamespaceName": {
      "value": "<EventHubNamespaceName>"
    },
    "eventHubAuthorizationRuleName": {
      "value": "<EventHubAuthorizationRuleName>"
    },
    "eventHubName": {
      "value": "<EventHubName>"
    }
  }
}
```

</details>

## Diagnostic setting for a Log Analytics workspace

The following sample creates a diagnostic setting for a Log Analytics workspace by adding a resource of type `Microsoft.OperationalInsights/workspaces/providers/diagnosticSettings` to the template. This example sends audit data about queries executed in the workspace to the same workspace.

### Log Analytics workspace

# [Bicep](#tab/bicep)

The following Bicep example uses the [`Microsoft.Insights/diagnosticSettings`](/azure/templates/microsoft.insights/diagnosticsettings?pivots=deployment-language-bicep) resource type.

<br>
<details>
<summary>Configure query auditing for a Log Analytics workspace</summary>

```bicep
param workspaceName string = '<WorkspaceName>'
param settingName string = '<SettingName>'
param destinationWorkspaceSubscriptionId string = '<DestinationWorkspaceSubscriptionId>'
param destinationWorkspaceResourceGroupName string = '<DestinationWorkspaceResourceGroupName>'
param destinationWorkspaceName string = '<DestinationWorkspaceName>'
param destinationStorageSubscriptionId string = '<DestinationStorageSubscriptionId>'
param destinationStorageResourceGroupName string = '<DestinationStorageResourceGroupName>'
param destinationStorageAccountName string = '<DestinationStorageAccountName>'
param eventHubSubscriptionId string = '<EventHubSubscriptionId>'
param eventHubResourceGroupName string = '<EventHubResourceGroupName>'
param eventHubNamespaceName string = '<EventHubNamespaceName>'
param eventHubAuthorizationRuleName string = '<EventHubAuthorizationRuleName>'
param eventHubName string = '<EventHubName>'

var workspaceId = resourceId(
  destinationWorkspaceSubscriptionId,
  destinationWorkspaceResourceGroupName,
  'Microsoft.OperationalInsights/workspaces',
  destinationWorkspaceName
)

var storageAccountId = resourceId(
  destinationStorageSubscriptionId,
  destinationStorageResourceGroupName,
  'Microsoft.Storage/storageAccounts',
  destinationStorageAccountName
)

var eventHubAuthorizationRuleId = resourceId(
  eventHubSubscriptionId,
  eventHubResourceGroupName,
  'Microsoft.EventHub/namespaces/authorizationRules',
  eventHubNamespaceName,
  eventHubAuthorizationRuleName
)

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@<WorkspaceApiVersion>' existing = {
  name: workspaceName
}
resource diagnosticSetting 'Microsoft.Insights/diagnosticSettings@<DiagnosticSettingsApiVersion>' = {
  name: settingName
  scope: logAnalyticsWorkspace
  properties: {
    workspaceId: workspaceId
    storageAccountId: storageAccountId
    eventHubAuthorizationRuleId: eventHubAuthorizationRuleId
    eventHubName: eventHubName
    logs: [
      {
        category: 'Audit'
        enabled: true
      }
    ]
  }
}
```

</details>

# [ARM template](#tab/arm)

The following ARM template example uses the [`Microsoft.Insights/diagnosticSettings`](/azure/templates/microsoft.insights/diagnosticsettings?pivots=deployment-language-arm-template) resource type.

<br>
<details>
<summary>Configure query auditing for a Log Analytics workspace</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "workspaceName": {
      "type": "string",
      "defaultValue": "<WorkspaceName>"
    },
    "settingName": {
      "type": "string",
      "defaultValue": "<SettingName>"
    },
    "destinationWorkspaceSubscriptionId": {
      "type": "string",
      "defaultValue": "<DestinationWorkspaceSubscriptionId>"
    },
    "destinationWorkspaceResourceGroupName": {
      "type": "string",
      "defaultValue": "<DestinationWorkspaceResourceGroupName>"
    },
    "destinationWorkspaceName": {
      "type": "string",
      "defaultValue": "<DestinationWorkspaceName>"
    },
    "destinationStorageSubscriptionId": {
      "type": "string",
      "defaultValue": "<DestinationStorageSubscriptionId>"
    },
    "destinationStorageResourceGroupName": {
      "type": "string",
      "defaultValue": "<DestinationStorageResourceGroupName>"
    },
    "destinationStorageAccountName": {
      "type": "string",
      "defaultValue": "<DestinationStorageAccountName>"
    },
    "eventHubSubscriptionId": {
      "type": "string",
      "defaultValue": "<EventHubSubscriptionId>"
    },
    "eventHubResourceGroupName": {
      "type": "string",
      "defaultValue": "<EventHubResourceGroupName>"
    },
    "eventHubNamespaceName": {
      "type": "string",
      "defaultValue": "<EventHubNamespaceName>"
    },
    "eventHubAuthorizationRuleName": {
      "type": "string",
      "defaultValue": "<EventHubAuthorizationRuleName>"
    },
    "eventHubName": {
      "type": "string",
      "defaultValue": "<EventHubName>"
    }
  },
  "resources": [
    {
      "type": "Microsoft.Insights/diagnosticSettings",
      "apiVersion": "<DiagnosticSettingsApiVersion>",
      "scope": "[format('Microsoft.OperationalInsights/workspaces/{0}', parameters('workspaceName'))]",
      "name": "[parameters('settingName')]",
      "properties": {
        "workspaceId": "[variables('workspaceId')]",
        "storageAccountId": "[variables('storageAccountId')]",
        "eventHubAuthorizationRuleId": "[variables('eventHubAuthorizationRuleId')]",
        "eventHubName": "[parameters('eventHubName')]",
        "logs": [
          {
            "category": "Audit",
            "enabled": true
          }
        ]
      }
    }
  ],
  "variables": {
    "workspaceId": "[resourceId(parameters('destinationWorkspaceSubscriptionId'), parameters('destinationWorkspaceResourceGroupName'), 'Microsoft.OperationalInsights/workspaces', parameters('destinationWorkspaceName'))]",
    "storageAccountId": "[resourceId(parameters('destinationStorageSubscriptionId'), parameters('destinationStorageResourceGroupName'), 'Microsoft.Storage/storageAccounts', parameters('destinationStorageAccountName'))]",
    "eventHubAuthorizationRuleId": "[resourceId(parameters('eventHubSubscriptionId'), parameters('eventHubResourceGroupName'), 'Microsoft.EventHub/namespaces/authorizationRules', parameters('eventHubNamespaceName'), parameters('eventHubAuthorizationRuleName'))]"
  }
}
```

</details>

---

<br>
<details>
<summary><strong>Log Analytics workspace parameter file</strong></summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "settingName": {
      "value": "<SettingName>"
    },
    "workspaceName": {
      "value": "<WorkspaceName>"
    },
    "destinationWorkspaceSubscriptionId": {
      "value": "<DestinationWorkspaceSubscriptionId>"
    },
    "destinationWorkspaceResourceGroupName": {
      "value": "<DestinationWorkspaceResourceGroupName>"
    },
    "destinationWorkspaceName": {
      "value": "<DestinationWorkspaceName>"
    },
    "destinationStorageSubscriptionId": {
      "value": "<DestinationStorageSubscriptionId>"
    },
    "destinationStorageResourceGroupName": {
      "value": "<DestinationStorageResourceGroupName>"
    },
    "destinationStorageAccountName": {
      "value": "<DestinationStorageAccountName>"
    },
    "eventHubSubscriptionId": {
      "value": "<EventHubSubscriptionId>"
    },
    "eventHubResourceGroupName": {
      "value": "<EventHubResourceGroupName>"
    },
    "eventHubNamespaceName": {
      "value": "<EventHubNamespaceName>"
    },
    "eventHubAuthorizationRuleName": {
      "value": "<EventHubAuthorizationRuleName>"
    },
    "eventHubName": {
      "value": "<EventHubName>"
    }
  }
}
```

</details>

## Diagnostic setting for Azure Storage

The following sample creates a diagnostic setting for each storage service endpoint that's available in the Azure Storage account. A setting is applied to each individual storage service that's available on the account. The storage services that are available depend on the type of storage account.

This template creates a diagnostic setting for a storage service in the account only if it exists for the account. For each available service, the diagnostic setting enables transaction metrics, and the collection of resource logs for read, write, and delete operations.

### Azure Storage

# [Bicep](#tab/bicep)

The following Bicep example uses the [`Microsoft.Insights/diagnosticSettings`](/azure/templates/microsoft.insights/diagnosticsettings?pivots=deployment-language-bicep) resource type.

**main.bicep**

> [!NOTE]
> Keep `main.bicep` and `module.bicep` in the same directory. The main file retrieves the existing account's service endpoints and passes them, along with the destination parameters, to the module.

```bicep
param storageAccountName string = '<StorageAccountName>'
param settingName string = '<SettingName>'
param storageSyncName string = '<StorageSyncName>'
param destinationWorkspaceSubscriptionId string = '<DestinationWorkspaceSubscriptionId>'
param destinationWorkspaceResourceGroupName string = '<DestinationWorkspaceResourceGroupName>'
param destinationWorkspaceName string = '<DestinationWorkspaceName>'

module nested './module.bicep' = {
  name: 'nested'
  params: {
    endpoints: reference(resourceId('Microsoft.Storage/storageAccounts', storageAccountName), '<StorageEndpointReadApiVersion>', 'Full').properties.primaryEndpoints
    settingName: settingName
    storageAccountName: storageAccountName
    storageSyncName: storageSyncName
    destinationWorkspaceSubscriptionId: destinationWorkspaceSubscriptionId
    destinationWorkspaceResourceGroupName: destinationWorkspaceResourceGroupName
    destinationWorkspaceName: destinationWorkspaceName
  }
}
```

**module.bicep**

> [!NOTE]
> This module is invoked by `main.bicep`; it isn't a separate deployment entry point. Its `endpoints` object comes from the existing storage account. `storageSyncName` identifies a separate destination storage account in the same deployment resource group.

<br>
<details>
<summary>Configure diagnostics for available storage services</summary>

```bicep
param endpoints object
param settingName string = '<SettingName>'
param storageAccountName string = '<StorageAccountName>'
param storageSyncName string = '<StorageSyncName>'
param destinationWorkspaceSubscriptionId string = '<DestinationWorkspaceSubscriptionId>'
param destinationWorkspaceResourceGroupName string = '<DestinationWorkspaceResourceGroupName>'
param destinationWorkspaceName string = '<DestinationWorkspaceName>'

var workspaceId = resourceId(
  destinationWorkspaceSubscriptionId,
  destinationWorkspaceResourceGroupName,
  'Microsoft.OperationalInsights/workspaces',
  destinationWorkspaceName
)

var hasBlob = contains(endpoints, 'blob')
var hasTable = contains(endpoints, 'table')
var hasFile = contains(endpoints, 'file')
var hasQueue = contains(endpoints, 'queue')

resource storageAccount 'Microsoft.Storage/storageAccounts@<StorageAccountApiVersion>' existing = {
  name: storageAccountName
}

resource diagnosticSetting 'Microsoft.Insights/diagnosticSettings@<DiagnosticSettingsApiVersion>' = {
  name: settingName
  scope: storageAccount
  properties: {
    workspaceId: workspaceId
    storageAccountId: resourceId('Microsoft.Storage/storageAccounts', storageSyncName)
    metrics: [
      {
        category: 'Transaction'
        enabled: true
      }
    ]
  }
}

resource blob 'Microsoft.Storage/storageAccounts/blobServices@<StorageBlobServiceApiVersion>' existing = {
  name:'default'
  parent:storageAccount
}

resource blobSetting 'Microsoft.Insights/diagnosticSettings@<DiagnosticSettingsApiVersion>' = if (hasBlob) {
  name: settingName
  scope: blob
  properties: {
    workspaceId: workspaceId
    storageAccountId: resourceId('Microsoft.Storage/storageAccounts', storageSyncName)
    logs: [
      {
        category: 'StorageRead'
        enabled: true
      }
      {
        category: 'StorageWrite'
        enabled: true
      }
      {
        category: 'StorageDelete'
        enabled: true
      }
    ]
    metrics: [
      {
        category: 'Transaction'
        enabled: true
      }
    ]
  }
}

resource table 'Microsoft.Storage/storageAccounts/tableServices@<StorageTableServiceApiVersion>' existing = {
  name:'default'
  parent:storageAccount
}

resource tableSetting 'Microsoft.Insights/diagnosticSettings@<DiagnosticSettingsApiVersion>' = if (hasTable) {
  name: settingName
  scope: table
  properties: {
    workspaceId: workspaceId
    storageAccountId: resourceId('Microsoft.Storage/storageAccounts', storageSyncName)
    logs: [
      {
        category: 'StorageRead'
        enabled: true
      }
      {
        category: 'StorageWrite'
        enabled: true
      }
      {
        category: 'StorageDelete'
        enabled: true
      }
    ]
    metrics: [
      {
        category: 'Transaction'
        enabled: true
      }
    ]
  }
}

resource file 'Microsoft.Storage/storageAccounts/fileServices@<StorageFileServiceApiVersion>' existing = {
  name:'default'
  parent:storageAccount
}

resource fileSetting 'Microsoft.Insights/diagnosticSettings@<DiagnosticSettingsApiVersion>' = if (hasFile) {
  name: settingName
  scope: file
  properties: {
    workspaceId: workspaceId
    storageAccountId: resourceId('Microsoft.Storage/storageAccounts', storageSyncName)
    logs: [
      {
        category: 'StorageRead'
        enabled: true
      }
      {
        category: 'StorageWrite'
        enabled: true
      }
      {
        category: 'StorageDelete'
        enabled: true
      }
    ]
    metrics: [
      {
        category: 'Transaction'
        enabled: true
      }
    ]
  }
}

resource queue 'Microsoft.Storage/storageAccounts/queueServices@<StorageQueueServiceApiVersion>' existing = {
  name:'default'
  parent:storageAccount
}

resource queueSetting 'Microsoft.Insights/diagnosticSettings@<DiagnosticSettingsApiVersion>' = if (hasQueue) {
  name: settingName
  scope: queue
  properties: {
    workspaceId: workspaceId
    storageAccountId: resourceId('Microsoft.Storage/storageAccounts', storageSyncName)
    logs: [
      {
        category: 'StorageRead'
        enabled: true
      }
      {
        category: 'StorageWrite'
        enabled: true
      }
      {
        category: 'StorageDelete'
        enabled: true
      }
    ]
    metrics: [
      {
        category: 'Transaction'
        enabled: true
      }
    ]
  }
}
```

</details>

# [ARM template](#tab/arm)

The following ARM template example uses the [`Microsoft.Insights/diagnosticSettings`](/azure/templates/microsoft.insights/diagnosticsettings?pivots=deployment-language-arm-template) resource type.

<br>
<details>
<summary>Configure diagnostics for available storage services</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "storageAccountName": {
      "type": "string",
      "defaultValue": "<StorageAccountName>"
    },
    "settingName": {
      "type": "string",
      "defaultValue": "<SettingName>"
    },
    "storageSyncName": {
      "type": "string",
      "defaultValue": "<StorageSyncName>"
    },
    "destinationWorkspaceSubscriptionId": {
      "type": "string",
      "defaultValue": "<DestinationWorkspaceSubscriptionId>"
    },
    "destinationWorkspaceResourceGroupName": {
      "type": "string",
      "defaultValue": "<DestinationWorkspaceResourceGroupName>"
    },
    "destinationWorkspaceName": {
      "type": "string",
      "defaultValue": "<DestinationWorkspaceName>"
    }
  },
  "resources": [
    {
      "type": "Microsoft.Resources/deployments",
      "apiVersion": "<DeploymentApiVersion>",
      "name": "nested",
      "properties": {
        "expressionEvaluationOptions": {
          "scope": "inner"
        },
        "mode": "Incremental",
        "parameters": {
          "endpoints": {
            "value": "[reference(resourceId('Microsoft.Storage/storageAccounts', parameters('storageAccountName')), '<StorageEndpointReadApiVersion>', 'Full').properties.primaryEndpoints]"
          },
          "settingName": {
            "value": "[parameters('settingName')]"
          },
          "storageAccountName": {
            "value": "[parameters('storageAccountName')]"
          },
          "storageSyncName": {
            "value": "[parameters('storageSyncName')]"
          },
          "destinationWorkspaceSubscriptionId": {
            "value": "[parameters('destinationWorkspaceSubscriptionId')]"
          },
          "destinationWorkspaceResourceGroupName": {
            "value": "[parameters('destinationWorkspaceResourceGroupName')]"
          },
          "destinationWorkspaceName": {
            "value": "[parameters('destinationWorkspaceName')]"
          }
        },
        "template": {
          "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
          "contentVersion": "1.0.0.0",
          "parameters": {
            "endpoints": {
              "type": "object"
            },
            "settingName": {
              "type": "string",
              "defaultValue": "<SettingName>"
            },
            "storageAccountName": {
              "type": "string",
              "defaultValue": "<StorageAccountName>"
            },
            "storageSyncName": {
              "type": "string",
              "defaultValue": "<StorageSyncName>"
            },
            "destinationWorkspaceSubscriptionId": {
              "type": "string",
              "defaultValue": "<DestinationWorkspaceSubscriptionId>"
            },
            "destinationWorkspaceResourceGroupName": {
              "type": "string",
              "defaultValue": "<DestinationWorkspaceResourceGroupName>"
            },
            "destinationWorkspaceName": {
              "type": "string",
              "defaultValue": "<DestinationWorkspaceName>"
            }
          },
          "variables": {
            "hasBlob": "[contains(parameters('endpoints'), 'blob')]",
            "hasTable": "[contains(parameters('endpoints'), 'table')]",
            "hasFile": "[contains(parameters('endpoints'), 'file')]",
            "hasQueue": "[contains(parameters('endpoints'), 'queue')]",
            "workspaceId": "[resourceId(parameters('destinationWorkspaceSubscriptionId'), parameters('destinationWorkspaceResourceGroupName'), 'Microsoft.OperationalInsights/workspaces', parameters('destinationWorkspaceName'))]"
          },
          "resources": [
            {
              "type": "Microsoft.Insights/diagnosticSettings",
              "apiVersion": "<DiagnosticSettingsApiVersion>",
              "scope": "[format('Microsoft.Storage/storageAccounts/{0}', parameters('storageAccountName'))]",
              "name": "[parameters('settingName')]",
              "properties": {
                "workspaceId": "[variables('workspaceId')]",
                "storageAccountId": "[resourceId('Microsoft.Storage/storageAccounts', parameters('storageSyncName'))]",
                "metrics": [
                  {
                    "category": "Transaction",
                    "enabled": true
                  }
                ]
              }
            },
            {
              "condition": "[variables('hasBlob')]",
              "type": "Microsoft.Insights/diagnosticSettings",
              "apiVersion": "<DiagnosticSettingsApiVersion>",
              "scope": "[format('Microsoft.Storage/storageAccounts/{0}/blobServices/{1}', parameters('storageAccountName'), 'default')]",
              "name": "[parameters('settingName')]",
              "properties": {
                "workspaceId": "[variables('workspaceId')]",
                "storageAccountId": "[resourceId('Microsoft.Storage/storageAccounts', parameters('storageSyncName'))]",
                "logs": [
                  {
                    "category": "StorageRead",
                    "enabled": true
                  },
                  {
                    "category": "StorageWrite",
                    "enabled": true
                  },
                  {
                    "category": "StorageDelete",
                    "enabled": true
                  }
                ],
                "metrics": [
                  {
                    "category": "Transaction",
                    "enabled": true
                  }
                ]
              }
            },
            {
              "condition": "[variables('hasTable')]",
              "type": "Microsoft.Insights/diagnosticSettings",
              "apiVersion": "<DiagnosticSettingsApiVersion>",
              "scope": "[format('Microsoft.Storage/storageAccounts/{0}/tableServices/{1}', parameters('storageAccountName'), 'default')]",
              "name": "[parameters('settingName')]",
              "properties": {
                "workspaceId": "[variables('workspaceId')]",
                "storageAccountId": "[resourceId('Microsoft.Storage/storageAccounts', parameters('storageSyncName'))]",
                "logs": [
                  {
                    "category": "StorageRead",
                    "enabled": true
                  },
                  {
                    "category": "StorageWrite",
                    "enabled": true
                  },
                  {
                    "category": "StorageDelete",
                    "enabled": true
                  }
                ],
                "metrics": [
                  {
                    "category": "Transaction",
                    "enabled": true
                  }
                ]
              }
            },
            {
              "condition": "[variables('hasFile')]",
              "type": "Microsoft.Insights/diagnosticSettings",
              "apiVersion": "<DiagnosticSettingsApiVersion>",
              "scope": "[format('Microsoft.Storage/storageAccounts/{0}/fileServices/{1}', parameters('storageAccountName'), 'default')]",
              "name": "[parameters('settingName')]",
              "properties": {
                "workspaceId": "[variables('workspaceId')]",
                "storageAccountId": "[resourceId('Microsoft.Storage/storageAccounts', parameters('storageSyncName'))]",
                "logs": [
                  {
                    "category": "StorageRead",
                    "enabled": true
                  },
                  {
                    "category": "StorageWrite",
                    "enabled": true
                  },
                  {
                    "category": "StorageDelete",
                    "enabled": true
                  }
                ],
                "metrics": [
                  {
                    "category": "Transaction",
                    "enabled": true
                  }
                ]
              }
            },
            {
              "condition": "[variables('hasQueue')]",
              "type": "Microsoft.Insights/diagnosticSettings",
              "apiVersion": "<DiagnosticSettingsApiVersion>",
              "scope": "[format('Microsoft.Storage/storageAccounts/{0}/queueServices/{1}', parameters('storageAccountName'), 'default')]",
              "name": "[parameters('settingName')]",
              "properties": {
                "workspaceId": "[variables('workspaceId')]",
                "storageAccountId": "[resourceId('Microsoft.Storage/storageAccounts', parameters('storageSyncName'))]",
                "logs": [
                  {
                    "category": "StorageRead",
                    "enabled": true
                  },
                  {
                    "category": "StorageWrite",
                    "enabled": true
                  },
                  {
                    "category": "StorageDelete",
                    "enabled": true
                  }
                ],
                "metrics": [
                  {
                    "category": "Transaction",
                    "enabled": true
                  }
                ]
              }
            }
          ]
        }
      }
    }
  ]
}
```

</details>

---

<br>
<details>
<summary><strong>Azure Storage parameter file</strong></summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "storageAccountName": {
      "value": "<StorageAccountName>"
    },
    "settingName": {
      "value": "<SettingName>"
    },
    "storageSyncName": {
      "value": "<StorageSyncName>"
    },
    "destinationWorkspaceSubscriptionId": {
      "value": "<DestinationWorkspaceSubscriptionId>"
    },
    "destinationWorkspaceResourceGroupName": {
      "value": "<DestinationWorkspaceResourceGroupName>"
    },
    "destinationWorkspaceName": {
      "value": "<DestinationWorkspaceName>"
    }
  }
}
```


</details>

## Next steps

* [Get other sample templates for Azure Monitor](../fundamentals/resource-manager-samples.md)
* [Learn more about diagnostic settings](diagnostic-settings.md)
