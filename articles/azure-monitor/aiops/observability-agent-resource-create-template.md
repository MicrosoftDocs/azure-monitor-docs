---
title: Create Observability Agents by using templates in Azure Monitor (preview)
description: Sample Azure Resource Manager templates and Bicep files to deploy Azure Monitor Observability Agents and the resources they monitor.
ms.topic: sample
ms.reviewer: efratbp
ms.date: 06/11/2026
ms.custom: references_regions, devx-track-arm-template
---

# Create an Azure Copilot Observability Agent resource using templates (preview)

An [Observability Agent resource](./observability-agent-resource.md) enables the Azure Copilot Observability Agent to perform [autonomous tasks](./observability-agent-autonomous-operations.md). This article shows you how to create a new resource by using Resource Manager and Bicep templates. For portal-based setup, see [Create an Observability Agent resource in Azure Monitor](observability-agent-resource-create-portal.md).

An Observability Agent (`Microsoft.Monitor/observabilityAgents`) is scoped to an Azure Monitor workspace and defines which AI-driven operations, such as issue creation and investigation, run on the alerts and signals in that workspace. Each agent has one or more child monitored resources (`Microsoft.Monitor/observabilityAgents/monitoredResources`) that tell the agent which Azure resources to observe.

## Prerequisites 
- A target [Azure Monitor workspace](../metrics/azure-monitor-workspace-overview.md) in the same region as the Observability Agent resource.
- *Monitoring Contributor* role on the resource group where you create the Observability Agent resource.
- If you use a user-assigned managed identity, create the identity and grant the required roles before you create the Observability Agent resource. If you use a system-assigned managed identity, the identity is created for you.

> [!NOTE]
> Each subscription is limited to five Observability Agents by default.

## Identity requirements
Use a managed identity to read fired alerts and alert context, analyze application telemetry to build system knowledge, and create or update issues in the Azure Monitor workspace. It requires the following roles:

- *Issue Contributor* on the Azure Monitor workspace where you create issues.
- *Monitoring Reader* on every subscription that contains alert rules and application resources that the agent needs to read, including underlying infrastructure resources such as App Service, Function App, SQL, Storage, AKS, and virtual machines.

The simplest strategy is to assign **Monitoring Contributor** on the subscription scope for each subscription containing your alert rules and application resources. This single role grants required permissions needed for alerts context, telemetry analysis and knowledge building, as well as permissions to create issues in the Azure Monitor workspace. 

> [!NOTE]
> Observability Agents are a preview feature. The API version used in these samples is `2026-05-01-preview`.


## Create an agent with a system-assigned identity
The following sample creates an Observability Agent with the following details:

- Enables autonomous issue creation and investigation operations.
- System-assigned managed identity.

### Template file

# [Bicep](#tab/bicep)

```bicep
@description('Name of the Observability Agent.')
@minLength(1)
param agentName string

@description('Location of the Observability Agent. Must match the location of the parent Azure Monitor workspace.')
@minLength(1)
param location string

@description('ARM resource ID of the Azure Monitor workspace (Microsoft.Monitor/accounts) that hosts this agent.')
@minLength(1)
param monitoringAccountId string

@description('Specifies whether the agent is enabled.')
param isEnabled bool = true

@description('Operation-level instructions provided to the issue creation operation.')
param issueCreationInstructions string = 'Always create an issue for \'storeapp-checkout-failures\''

resource observabilityAgent 'Microsoft.Monitor/observabilityAgents@2026-05-01-preview' = {
  name: agentName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  tags: {
    env: 'production'
  }
  properties: {
    monitoringAccountId: monitoringAccountId
    enabled: isEnabled
    operations: [
      {
        type: 'IssueCreation'
        mode: 'Auto'
        instructions: issueCreationInstructions
      }
      {
        type: 'Investigation'
        mode: 'Auto'
      }
    ]
  }
}
```

# [JSON](#tab/json)

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "agentName": {
      "type": "string",
      "minLength": 1,
      "metadata": {
        "description": "Name of the Observability Agent."
      }
    },
    "location": {
      "type": "string",
      "minLength": 1,
      "metadata": {
        "description": "Location of the Observability Agent. Must match the location of the parent Azure Monitor workspace."
      }
    },
    "monitoringAccountId": {
      "type": "string",
      "minLength": 1,
      "metadata": {
        "description": "ARM resource ID of the Azure Monitor workspace (Microsoft.Monitor/accounts) that hosts this agent."
      }
    },
    "isEnabled": {
      "type": "bool",
      "defaultValue": true,
      "metadata": {
        "description": "Specifies whether the agent is enabled."
      }
    },
    "issueCreationInstructions": {
      "type": "string",
      "defaultValue": "Always create an issue for 'storeapp-checkout-failures'",
      "metadata": {
        "description": "Operation-level instructions provided to the issue creation operation."
      }
    }
  },
  "resources": [
    {
      "type": "Microsoft.Monitor/observabilityAgents",
      "apiVersion": "2026-05-01-preview",
      "name": "[parameters('agentName')]",
      "location": "[parameters('location')]",
      "identity": {
        "type": "SystemAssigned"
      },
      "tags": {
        "env": "production"
      },
      "properties": {
        "monitoringAccountId": "[parameters('monitoringAccountId')]",
        "enabled": "[parameters('isEnabled')]",
        "operations": [
          {
            "type": "IssueCreation",
            "mode": "Auto",
            "instructions": "[parameters('issueCreationInstructions')]"
          },
          {
            "type": "Investigation",
            "mode": "Auto"
          }
        ]
      }
    }
  ]
}
```

---

### Parameter file

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "agentName": {
      "value": "contoso-observability-agent"
    },
    "location": {
      "value": "eastus"
    },
    "monitoringAccountId": {
      "value": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/contoso-rg/providers/Microsoft.Monitor/accounts/contoso-workspace"
    },
    "isEnabled": {
      "value": true
    },
    "issueCreationInstructions": {
      "value": "Always create an issue for 'storeapp-checkout-failures'"
    }
  }
}
```

## Create an agent with a user-assigned identity
The following sample creates an Observability Agent with the following details:

- Sets the investigation operation to `Manual` mode, which opts the agent out of running investigations automatically.
- User-assigned managed identity.


### Template file

# [Bicep](#tab/bicep)

```bicep
@description('Name of the Observability Agent.')
@minLength(1)
param agentName string

@description('Location of the Observability Agent. Must match the Azure Monitor workspace location.')
@minLength(1)
param location string

@description('Name of the existing Azure Monitor workspace (Microsoft.Monitor/accounts) in this resource group.')
@minLength(1)
param monitoringAccountName string

@description('ARM resource ID of the existing user-assigned managed identity to attach to the agent.')
@minLength(1)
param userAssignedIdentityId string

@description('Object ID (principalId) of the user-assigned managed identity. Used for the role assignment in this template.')
@minLength(36)
param userAssignedIdentityPrincipalId string

@description('Name of the monitored resource entry under the agent.')
@minLength(1)
param monitoredResourceName string

@description('ARM resource ID of the target Azure resource that the agent observes.')
@minLength(1)
param targetResourceId string

@description('Operation-level instructions for the issue creation operation.')
param issueCreationInstructions string = 'group related alerts into a single issue'

// Built-in role definition ID for Monitoring Contributor.
var monitoringContributorRoleId = '749f88d5-cbae-40b8-bcfc-e573ddc772fa'

// Reference the existing Azure Monitor workspace so the role assignment can be scoped to it.
resource monitoringAccount 'Microsoft.Monitor/accounts@2023-04-03' existing = {
  name: monitoringAccountName
}

// Grant the agent's user-assigned identity Monitoring Contributor on the Azure Monitor workspace.
resource amwRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: monitoringAccount
  name: guid(monitoringAccount.id, userAssignedIdentityPrincipalId, monitoringContributorRoleId)
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', monitoringContributorRoleId)
    principalId: userAssignedIdentityPrincipalId
    principalType: 'ServicePrincipal'
  }
}

// Create the Observability Agent with the user-assigned managed identity attached.
resource observabilityAgent 'Microsoft.Monitor/observabilityAgents@2026-05-01-preview' = {
  name: agentName
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${userAssignedIdentityId}': {}
    }
  }
  properties: {
    monitoringAccountId: monitoringAccount.id
    enabled: true
    operations: [
      {
        type: 'IssueCreation'
        mode: 'Auto'
        instructions: issueCreationInstructions
      }
      {
        type: 'Investigation'
        mode: 'Auto'
      }
    ]
  }
}

// Add the monitored resource as a child of the agent.
resource monitoredResource 'Microsoft.Monitor/observabilityAgents/monitoredResources@2026-05-01-preview' = {
  parent: observabilityAgent
  name: monitoredResourceName
  properties: {
    resourceId: targetResourceId
    enabled: true
    isAutonomous: true
  }
}
```

# [JSON](#tab/json)

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "agentName": {
      "type": "string",
      "minLength": 1,
      "metadata": {
        "description": "Name of the Observability Agent."
      }
    },
    "location": {
      "type": "string",
      "minLength": 1,
      "metadata": {
        "description": "Location of the Observability Agent. Must match the Azure Monitor workspace location."
      }
    },
    "monitoringAccountName": {
      "type": "string",
      "minLength": 1,
      "metadata": {
        "description": "Name of the existing Azure Monitor workspace (Microsoft.Monitor/accounts) in this resource group."
      }
    },
    "userAssignedIdentityId": {
      "type": "string",
      "minLength": 1,
      "metadata": {
        "description": "ARM resource ID of the existing user-assigned managed identity to attach to the agent."
      }
    },
    "userAssignedIdentityPrincipalId": {
      "type": "string",
      "minLength": 36,
      "metadata": {
        "description": "Object ID (principalId) of the user-assigned managed identity."
      }
    },
    "monitoredResourceName": {
      "type": "string",
      "minLength": 1,
      "metadata": {
        "description": "Name of the monitored resource entry under the agent."
      }
    },
    "targetResourceId": {
      "type": "string",
      "minLength": 1,
      "metadata": {
        "description": "ARM resource ID of the target Azure resource that the agent observes."
      }
    },
    "issueCreationInstructions": {
      "type": "string",
      "defaultValue": "group related alerts into a single issue",
      "metadata": {
        "description": "Operation-level instructions for the issue creation operation."
      }
    }
  },
  "variables": {
    "monitoringContributorRoleId": "749f88d5-cbae-40b8-bcfc-e573ddc772fa",
    "monitoringAccountId": "[resourceId('Microsoft.Monitor/accounts', parameters('monitoringAccountName'))]"
  },
  "resources": [
    {
      "type": "Microsoft.Authorization/roleAssignments",
      "apiVersion": "2022-04-01",
      "scope": "[format('Microsoft.Monitor/accounts/{0}', parameters('monitoringAccountName'))]",
      "name": "[guid(variables('monitoringAccountId'), parameters('userAssignedIdentityPrincipalId'), variables('monitoringContributorRoleId'))]",
      "properties": {
        "roleDefinitionId": "[subscriptionResourceId('Microsoft.Authorization/roleDefinitions', variables('monitoringContributorRoleId'))]",
        "principalId": "[parameters('userAssignedIdentityPrincipalId')]",
        "principalType": "ServicePrincipal"
      }
    },
    {
      "type": "Microsoft.Monitor/observabilityAgents",
      "apiVersion": "2026-05-01-preview",
      "name": "[parameters('agentName')]",
      "location": "[parameters('location')]",
      "identity": {
        "type": "UserAssigned",
        "userAssignedIdentities": {
          "[parameters('userAssignedIdentityId')]": {}
        }
      },
      "properties": {
        "monitoringAccountId": "[variables('monitoringAccountId')]",
        "enabled": true,
        "operations": [
          {
            "type": "IssueCreation",
            "mode": "Auto",
            "instructions": "[parameters('issueCreationInstructions')]"
          },
          {
            "type": "Investigation",
            "mode": "Auto"
          }
        ]
      }
    },
    {
      "type": "Microsoft.Monitor/observabilityAgents/monitoredResources",
      "apiVersion": "2026-05-01-preview",
      "name": "[format('{0}/{1}', parameters('agentName'), parameters('monitoredResourceName'))]",
      "dependsOn": [
        "[resourceId('Microsoft.Monitor/observabilityAgents', parameters('agentName'))]"
      ],
      "properties": {
        "resourceId": "[parameters('targetResourceId')]",
        "enabled": true,
        "isAutonomous": true
      }
    }
  ]
}
```

---

### Parameter file

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "agentName": {
      "value": "contoso-observability-agent"
    },
    "location": {
      "value": "eastus"
    },
    "monitoringAccountName": {
      "value": "contoso-workspace"
    },
    "userAssignedIdentityId": {
      "value": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/contoso-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/contoso-agent-identity"
    },
    "userAssignedIdentityPrincipalId": {
      "value": "00000000-0000-0000-0000-000000000000"
    },
    "monitoredResourceName": {
      "value": "storeappai"
    },
    "targetResourceId": {
      "value": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/contoso-rg/providers/Microsoft.Insights/components/StoreAppAI"
    },
    "issueCreationInstructions": {
      "value": "group related alerts into a single issue"
    }
  }
}
```

## Add a monitored resource

The following sample creates a single `monitoredResources` child resource under an existing Observability Agent. The monitored resource points to an Application Insights component that the agent observes.

> [!NOTE]
> You must create a monitored resource under an existing parent agent in the same resource group. If you omit `location` in the request, the monitored resource inherits the location of its parent agent.

### Template file

# [Bicep](#tab/bicep)

```bicep
@description('Name of the parent Observability Agent.')
@minLength(1)
param agentName string

@description('Name of the monitored resource entry under the agent.')
@minLength(1)
param monitoredResourceName string

@description('ARM resource ID of the target Azure resource that the agent will observe.')
@minLength(1)
param targetResourceId string

@description('Specifies whether monitoring of the target resource is enabled.')
param isEnabled bool = true

@description('When true, the agent observes the target resource autonomously without requiring manual triggering for every signal.')
param isAutonomous bool = true

resource monitoredResource 'Microsoft.Monitor/observabilityAgents/monitoredResources@2026-05-01-preview' = {
  name: '${agentName}/${monitoredResourceName}'
  properties: {
    resourceId: targetResourceId
    enabled: isEnabled
    isAutonomous: isAutonomous
  }
}
```

# [JSON](#tab/json)

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "agentName": {
      "type": "string",
      "minLength": 1,
      "metadata": {
        "description": "Name of the parent Observability Agent."
      }
    },
    "monitoredResourceName": {
      "type": "string",
      "minLength": 1,
      "metadata": {
        "description": "Name of the monitored resource entry under the agent."
      }
    },
    "targetResourceId": {
      "type": "string",
      "minLength": 1,
      "metadata": {
        "description": "ARM resource ID of the target Azure resource that the agent will observe."
      }
    },
    "isEnabled": {
      "type": "bool",
      "defaultValue": true,
      "metadata": {
        "description": "Specifies whether monitoring of the target resource is enabled."
      }
    },
    "isAutonomous": {
      "type": "bool",
      "defaultValue": true,
      "metadata": {
        "description": "When true, the agent observes the target resource autonomously without requiring manual triggering for every signal."
      }
    }
  },
  "resources": [
    {
      "type": "Microsoft.Monitor/observabilityAgents/monitoredResources",
      "apiVersion": "2026-05-01-preview",
      "name": "[format('{0}/{1}', parameters('agentName'), parameters('monitoredResourceName'))]",
      "properties": {
        "resourceId": "[parameters('targetResourceId')]",
        "enabled": "[parameters('isEnabled')]",
        "isAutonomous": "[parameters('isAutonomous')]"
      }
    }
  ]
}
```

---

### Parameter file

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "agentName": {
      "value": "contoso-observability-agent"
    },
    "monitoredResourceName": {
      "value": "storeappai"
    },
    "targetResourceId": {
      "value": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/contoso-rg/providers/Microsoft.Insights/components/StoreAppAI"
    },
    "isEnabled": {
      "value": true
    },
    "isAutonomous": {
      "value": true
    }
  }
}
```

## Create an agent with multiple monitored resources

The following sample creates an Observability Agent and a set of monitored resources in a single deployment. The child monitored resources declare an explicit `dependsOn` reference to the parent agent.

### Template file

# [Bicep](#tab/bicep)

```bicep
@description('Name of the Observability Agent.')
@minLength(1)
param agentName string

@description('Location of the Observability Agent. Monitored resources inherit this location.')
@minLength(1)
param location string

@description('ARM resource ID of the Azure Monitor workspace (Microsoft.Monitor/accounts) that hosts this agent.')
@minLength(1)
param monitoringAccountId string

@description('Array of target resources to monitor. Each entry must have a unique name and a valid ARM resourceId.')
param monitoredResources array = [
  {
    name: 'storeappai'
    resourceId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/contoso-rg/providers/Microsoft.Insights/components/StoreAppAI'
    enabled: true
    isAutonomous: true
  }
  {
    name: 'checkoutapi'
    resourceId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/contoso-rg/providers/Microsoft.Web/sites/checkout-api'
    enabled: true
    isAutonomous: true
  }
]

resource observabilityAgent 'Microsoft.Monitor/observabilityAgents@2026-05-01-preview' = {
  name: agentName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    monitoringAccountId: monitoringAccountId
    enabled: true
    operations: [
      {
        type: 'IssueCreation'
        mode: 'Auto'
        instructions: 'group related alerts into a single issue'
      }
      {
        type: 'Investigation'
        mode: 'Auto'
      }
    ]
  }
}

resource monitoredResource 'Microsoft.Monitor/observabilityAgents/monitoredResources@2026-05-01-preview' = [for entry in monitoredResources: {
  parent: observabilityAgent
  name: entry.name
  properties: {
    resourceId: entry.resourceId
    enabled: entry.enabled
    isAutonomous: entry.isAutonomous
  }
}]
```

# [JSON](#tab/json)

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "agentName": {
      "type": "string",
      "minLength": 1,
      "metadata": {
        "description": "Name of the Observability Agent."
      }
    },
    "location": {
      "type": "string",
      "minLength": 1,
      "metadata": {
        "description": "Location of the Observability Agent. Monitored resources inherit this location."
      }
    },
    "monitoringAccountId": {
      "type": "string",
      "minLength": 1,
      "metadata": {
        "description": "ARM resource ID of the Azure Monitor workspace (Microsoft.Monitor/accounts) that hosts this agent."
      }
    },
    "monitoredResources": {
      "type": "array",
      "defaultValue": [
        {
          "name": "storeappai",
          "resourceId": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/contoso-rg/providers/Microsoft.Insights/components/StoreAppAI",
          "enabled": true,
          "isAutonomous": true
        },
        {
          "name": "checkoutapi",
          "resourceId": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/contoso-rg/providers/Microsoft.Web/sites/checkout-api",
          "enabled": true,
          "isAutonomous": true
        }
      ],
      "metadata": {
        "description": "Array of target resources to monitor. Each entry must have a unique name and a valid ARM resourceId."
      }
    }
  },
  "resources": [
    {
      "type": "Microsoft.Monitor/observabilityAgents",
      "apiVersion": "2026-05-01-preview",
      "name": "[parameters('agentName')]",
      "location": "[parameters('location')]",
      "identity": {
        "type": "SystemAssigned"
      },
      "properties": {
        "monitoringAccountId": "[parameters('monitoringAccountId')]",
        "enabled": true,
        "operations": [
          {
            "type": "IssueCreation",
            "mode": "Auto",
            "instructions": "group related alerts into a single issue"
          },
          {
            "type": "Investigation",
            "mode": "Auto"
          }
        ]
      }
    },
    {
      "type": "Microsoft.Monitor/observabilityAgents/monitoredResources",
      "apiVersion": "2026-05-01-preview",
      "name": "[format('{0}/{1}', parameters('agentName'), parameters('monitoredResources')[copyIndex()].name)]",
      "copy": {
        "name": "monitoredResourcesCopy",
        "count": "[length(parameters('monitoredResources'))]"
      },
      "dependsOn": [
        "[resourceId('Microsoft.Monitor/observabilityAgents', parameters('agentName'))]"
      ],
      "properties": {
        "resourceId": "[parameters('monitoredResources')[copyIndex()].resourceId]",
        "enabled": "[parameters('monitoredResources')[copyIndex()].enabled]",
        "isAutonomous": "[parameters('monitoredResources')[copyIndex()].isAutonomous]"
      }
    }
  ]
}
```

---

### Parameter file

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "agentName": {
      "value": "contoso-observability-agent"
    },
    "location": {
      "value": "eastus"
    },
    "monitoringAccountId": {
      "value": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/contoso-rg/providers/Microsoft.Monitor/accounts/contoso-workspace"
    },
    "monitoredResources": {
      "value": [
        {
          "name": "storeappai",
          "resourceId": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/contoso-rg/providers/Microsoft.Insights/components/StoreAppAI",
          "enabled": true,
          "isAutonomous": true
        },
        {
          "name": "checkoutapi",
          "resourceId": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/contoso-rg/providers/Microsoft.Web/sites/checkout-api",
          "enabled": true,
          "isAutonomous": true
        }
      ]
    }
  }
}
```

## Property reference

The following tables summarize the properties that the samples in this article use.

### `Microsoft.Monitor/observabilityAgents` properties

| Property | Type | Required | Description |
|---|---|---|---|
| `monitoringAccountId` | string | Yes | ARM resource ID of the Azure Monitor workspace (`Microsoft.Monitor/accounts`) that hosts this agent. Must be in the same location as the agent. |
| `enabled` | bool | No | Indicates whether the agent is enabled. Defaults to `true` when not specified. |
| `operations` | array | No | List of operations that the agent runs. Each entry has a `type`, `mode`, and optional `instructions`. |
| `operations[].type` | string | Yes (per entry) | Operation type. Allowed values: `IssueCreation`, `Investigation`. |
| `operations[].mode` | string | No | Execution mode for the operation. Allowed values: `Auto`, `Manual`. |
| `operations[].instructions` | string | No | Free-form, operation-scoped instructions. Maximum length is 8,192 characters. |
| `identity` | object | Yes | Managed identity definition for the agent. The `type` must be either `SystemAssigned` or `UserAssigned`. |

### `Microsoft.Monitor/observabilityAgents/monitoredResources` properties

| Property | Type | Required | Description |
|---|---|---|---|
| `resourceId` | string | Yes | ARM resource ID of the target Azure resource that the parent agent observes. |
| `enabled` | bool | No | Specifies whether monitoring of this target resource is enabled. |
| `isAutonomous` | bool | No | When `true`, the agent observes the target resource autonomously. |

## Next steps

* [Get other sample templates for Azure Monitor](../resource-manager-samples.md).
* [Learn more about Azure Monitor workspaces](../essentials/azure-monitor-workspace-overview.md).
