---
title: Advisor MCP Tools
description: Use Advisor MCP Tools in Azure MCP server
ms.topic: concept-article
ms.date: 30/05/2026
---

# Advisor MCP tools

Azure Advisor MCP (Model Context Protocol) tools give AI agents structured access to Azure Advisor recommendations. You can use these tools inside any MCP-compatible AI client, such as Visual Studio Code with GitHub Copilot, to query Advisor recommendations for your subscriptions and apply best-practice rules directly to your ARM templates and Terraform configurations.

>[!NOTE]
>Bicep is currently not supported and would be available in future release.

## Prerequisites

Before you use the Advisor MCP tools, make sure you have the following:

- An MCP-compatible AI client such as [Visual Studio Code](https://code.visualstudio.com/) with [GitHub Copilot](https://code.visualstudio.com/docs/copilot/setup).
- The Azure MCP server configured in your client. For setup instructions, see [Get started with the Azure MCP server](https://learn.microsoft.com/azure/developer/azure-mcp-server/get-started/tools/visual-studio-code).
- Appropriate Azure RBAC permissions to read Advisor recommendations in your target subscription.

## Available tools

The Advisor MCP tools provide two commands under the `azmcp advisor recommendation` namespace:

| Command | Description |
|---|---|
| `azmcp advisor recommendation list` | List Azure Advisor recommendations for a subscription |
| `azmcp advisor recommendation apply` | Apply Azure Advisor best-practice recommendations to your ARM templates and Terraform configurations |

## List Advisor recommendations

The `list` command queries Azure Advisor recommendations across your subscription. It returns recommendation details including the affected resource, the recommendation text, and the recommendation category.

### Parameters

| Parameter | Required | Description |
|---|---|---|
| `--subscription` | Yes | The Azure subscription ID or name to query recommendations for |
| `--resource-group` | No | Filter recommendations to a specific resource group |

### Example prompts

Use these prompts in your MCP-compatible AI client to list recommendations:

- "List all Advisor recommendations in my subscription"
- "Show me Advisor recommendations for the resource group `myapp-rg`"
- "What Azure Advisor recommendations exist for subscription `contoso-prod`?"
- "List Cost recommendations in my subscription"

### Response format

The command returns a list of recommendations, where each recommendation includes:

- **resourceId** - The Azure resource ID of the affected resource
- **recommendationText** - A description of the recommendation
- **category** - The Advisor category (for example, `HighAvailability`, `Security`, `Performance`, `Cost`, `OperationalExcellence`)

## Apply Advisor recommendations to IaC files

The `apply` tool helps analyze your [infrastructure-as-code (IaC)](https://learn.microsoft.com/devops/deliver/what-is-infrastructure-as-code) files against Azure Advisor best practices for a given Azure resource type. The tool returns a set of **_Advisor Rules_** which can be used by an AI agent to identify configurations that doesn't follow Advisor recommendations. The AI agent then proposes or applies fixes directly to your ARM templates or Terraform configurations.

The tool supports the resource types listed in [Supported resource types](#supported-resource-types). Your AI client automatically determines the relevant resource type from your prompt and IaC context.

### Parameters

_No parameters are required for this tool. The context is inferred directly from the IaaC file._

### Example prompts

Use these prompts in your MCP-compatible AI client:

- "Apply Advisor recommendations to my ARM template for virtual machines"
- "Check my Terraform configuration for storage account best practices using Advisor"
- "What Advisor recommendations can be applied to my AKS cluster template?"
- "Apply Advisor recommendations to all IaC files in my workspace"

## Supported resource types

The `apply` tool supports recommendations for the following Azure services. 

### Microsoft Entra ID

| Azure service | Recommendations |
|---|---|
| Microsoft Entra Domain Services | Upgrade TLS to 1.2, use Enterprise SKU for replica sets |

### API Management

| Azure service | Recommendations |
|---|---|
| Azure API Management | Enable multi-region deployment, migrate from stv1 to stv2 platform, upgrade TLS to 1.2 |

### AI services

| Azure service | Recommendations |
|---|---|
| Azure AI services | Migrate from Azure AI Health Insights (retiring), migrate from LUIS to Conversational Language Understanding, migrate from QnA Maker to Azure AI Language |

### Compute

| Azure service | Recommendations |
|---|---|
| Azure Virtual Machines | Use capacity reservations for critical VMs, migrate from A-series/B-series to D-series or better, migrate from retiring VM series (F, Fs, Fsv2, Lsv2, G, GS, Av2, B), migrate from NCv3-series to newer NC-series |
| Azure Virtual Machine Scale Sets | Disable strict zone balance for flexibility, enable automatic instance repairs |

### Containers

| Azure service | Recommendations |
|---|---|
| Azure Container Registry | Use Premium tier for production registries |
| Azure Kubernetes Service (AKS) | Migrate in-tree disk drivers to CSI drivers |

### Databases

| Azure service | Recommendations |
|---|---|
| Azure Database for PostgreSQL - Flexible Server | Enable custom maintenance schedule |
| Azure Cosmos DB | Enforce TLS 1.2 |
| Azure SQL Managed Instance | Migrate SCOM Managed Instance monitoring to supported alternatives |

### Key Vault

| Azure service | Recommendations |
|---|---|
| Azure Key Vault | Enable soft-delete for vault recovery |

### Kubernetes (hybrid)

| Azure service | Recommendations |
|---|---|
| Azure Arc-enabled Kubernetes | Migrate to AKS on Azure Local |
| Kubernetes configuration extensions | Migrate Arc App Service extension to Container Apps |

### Networking

| Azure service | Recommendations |
|---|---|
| Application Gateway WAF policies | Upgrade to the latest DRS rule set version |
| Azure ExpressRoute Direct | Enable Admin State for ExpressRoute Direct links |
| Azure Front Door WAF policies | Upgrade to the latest DRS rule set version |

### Storage

| Azure service | Recommendations |
|---|---|
| Azure NetApp Files | Configure snapshot policy, migrate to Standard network features |
| Azure Storage accounts | Upgrade TLS to 1.2 |

### Web

| Azure service | Recommendations |
|---|---|
| Azure App Service plans | Use Standard or Premium tier, configure at least two instances |
| Azure Static Web Apps | Migrate from Dedicated pricing plan to Standard |

## Example workflows

The following examples show how to use the Advisor MCP tools to improve your Azure infrastructure.

### Review existing Advisor recommendations

Ask your AI agent to list Advisor recommendations for your subscription to understand the current state of your Azure resources:

```text
List all Advisor recommendations for my subscription "contoso-prod"
```

The agent returns a list of recommendations, including the affected resources and their categories. You can use this information to prioritize which resources need attention.

### Apply Advisor best practices to IaC files

Ask the agent to review and fix your IaC files based on Advisor best practices:

```text
Apply Advisor recommendations to my ARM template for virtual machines in main.json
```

The agent analyzes your IaC file, identifies configurations that don't align with Advisor best practices, and proposes or applies the recommended changes. Review the changes before deploying the updated templates.

### Supported IaC formats

The apply tool works with the following IaC formats:

- **ARM templates**
- **Terraform** (using the `azurerm` provider)
>[!NOTE]
>Bicep is currently not supported and would be available in future release.
