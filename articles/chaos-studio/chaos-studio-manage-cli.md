---
title: Manage Chaos Studio Workspaces and Scenarios with the Azure CLI
description: Install the Azure CLI extension for Azure Chaos Studio, bootstrap a Workspace, and configure, validate, and run a Scenario from the command line.
author: nikhilkaul-msft
ms.topic: how-to
ms.date: 07/02/2026
ms.custom: devx-track-azurecli
ms.devlang: azurecli
ai-usage: ai-assisted
---

# Manage Chaos Studio Workspaces and Scenarios with the Azure CLI

The Azure CLI extension for Azure Chaos Studio (`az chaos`) helps you create a workspace, discover the resources in scope, and configure, validate, and run scenarios without leaving the command line. This article walks through the full workflow, from installing the extension to running your first scenario and cleaning up.

The `az chaos` extension targets Chaos Studio Workspaces. To script classic chaos experiments instead, see [Create a chaos experiment that uses an agent-based fault with the Azure CLI](chaos-studio-tutorial-agent-based-cli.md).

## Prerequisites

- An Azure subscription. [!INCLUDE [quickstarts-free-trial-note](~/reusable-content/ce-skilling/azure/includes/quickstarts-free-trial-note.md)]
- The Azure CLI. To install or upgrade it, see [How to install the Azure CLI](/cli/azure/install-azure-cli). You can also run these commands in [Azure Cloud Shell](https://shell.azure.com).
- At least one deployed Azure resource that supports Chaos Studio Actions, such as a virtual machine, Azure Virtual Machine Scale Set, Azure SQL database, or PostgreSQL flexible server. For the full list, see [Supported resource types](chaos-studio-fault-providers.md).
- The **Microsoft.Chaos** resource provider registered in your subscription. To register it, run `az provider register --namespace Microsoft.Chaos`.
- Permission to create resources and role assignments in the target scope. The bootstrap step grants the Workspace identity the **Reader** role on the scope, and permission fixing assigns the roles each scenario needs. You need the **Owner** or **User Access Administrator** role, or an equivalent custom role, to assign roles. If you want to manage role assignments yourself, use the `--skip-permissions` option.

## Install the extension

Install the extension from the public Azure CLI extension index:

```azurecli
az extension add --name chaos
```

If you already have the extension, update it to the latest version:

```azurecli
az extension update --name chaos
```

Sign in and select the subscription you want to work in:

```azurecli
az login
az account set --subscription "<subscription-name-or-id>"
```

## Bootstrap a workspace with one command

The `az chaos setup` command creates a ready-to-use environment in a single step. It:

1. Creates the resource group if it doesn't already exist.
1. Creates a workspace with a managed identity.
1. Grants that identity the **Reader** role on each scope you specify.
1. Discovers the supported resources in scope and evaluates which scenarios apply.
1. Prints the recommended scenarios and the commands to run next.

Run `setup`, replacing the placeholders with your values:

```azurecli
az chaos setup \
  --name <workspace-name> \
  --resource-group <resource-group> \
  --location <region> \
  --scopes "/subscriptions/<subscription-id>/resourceGroups/<target-resource-group>"
```

Keep the following points in mind:

- Use `--scopes` to declare which resources Chaos Studio can target. Pass one or more resource IDs, separated by spaces. A scope can be a subscription (`/subscriptions/<subscription-id>`), a resource group, or a service group. To copy a resource group's ID, run `az group show --name <resource-group> --query id --output tsv`.
- You only need to provide `--location` when the resource group doesn't already exist. When the group exists, `setup` reuses its location.
- Use `--user-assigned <identity-resource-id>` to assign your own managed identity instead of a system-assigned one.
- Use `--skip-permissions` to skip the Reader grant when you manage role assignments yourself.

When `setup` finishes, it lists the scenarios recommended for the resources it found, ranked by how well they apply.

## Review discovered resources and recommended scenarios

The workspace discovered the following resources in scope:

```azurecli
az chaos discovered-resource list \
  --workspace-name <workspace-name> \
  --resource-group <resource-group> \
  --output table
```

The workspace recommends the following scenarios for those resources:

```azurecli
az chaos scenario list \
  --workspace-name <workspace-name> \
  --resource-group <resource-group> \
  --output table
```

If a list looks stale, trigger a new discovery and evaluation:

```azurecli
az chaos workspace refresh-recommendation \
  --name <workspace-name> \
  --resource-group <resource-group>
```

## Configure a scenario

A scenario configuration defines the parameters and resource filters for a run. Create one from a recommended scenario:

```azurecli
az chaos scenario config create \
  --workspace-name <workspace-name> \
  --resource-group <resource-group> \
  --scenario-name <scenario-name> \
  --name <config-name> \
  --parameters "[{key:duration,value:PT10M}]" \
  --filters "{locations:[<region>],zones:[1]}"
```

Keep the following points in mind:

- `--scenario-name` is the name of a scenario from `az chaos scenario list`, such as `ComputeZoneDown-1.1`.
- `--parameters` takes a list of key/value objects. Use it to set values a scenario supports, such as the run `duration` in ISO 8601 format, where `PT10M` is 10 minutes. You can also pass a file with `--parameters @parameters.json`.
- `--filters` narrows the targeted resources by `locations`, `zones`, or `physical-zones`. The `zones` and `physical-zones` keys are mutually exclusive.

## Validate and fix permissions

Validate the configuration before you run it. Validation checks that the Workspace identity has the roles needed to run the Scenario against the targeted resources:

```azurecli
az chaos scenario config validate \
  --workspace-name <workspace-name> \
  --resource-group <resource-group> \
  --scenario-name <scenario-name> \
  --name <config-name>
```

If validation reports missing permissions, assign the required roles automatically:

```azurecli
az chaos scenario config fix-permissions \
  --workspace-name <workspace-name> \
  --resource-group <resource-group> \
  --scenario-name <scenario-name> \
  --name <config-name>
```

To preview the role assignments without making them, add `--what-if`.

Re-run `validate` until it passes. Azure role assignments can take a few minutes to propagate, so validation might still report that permissions require attention for a short time after you fix them.

## Run the scenario

Start a run from the configuration. By default, `run start` performs a pre-flight validation and then executes:

```azurecli
az chaos scenario run start \
  --workspace-name <workspace-name> \
  --resource-group <resource-group> \
  --scenario-name <scenario-name> \
  --config-name <config-name>
```

The command returns a run ID. Check the run's status:

```azurecli
az chaos scenario run show \
  --workspace-name <workspace-name> \
  --resource-group <resource-group> \
  --scenario-name <scenario-name> \
  --run-id <run-id> \
  --output table
```

To stop a run before it finishes:

```azurecli
az chaos scenario run cancel \
  --workspace-name <workspace-name> \
  --resource-group <resource-group> \
  --scenario-name <scenario-name> \
  --run-id <run-id>
```

After a run completes, review its Scenario report to see which Actions ran and how your resources responded. See [Scenario reports in Azure Chaos Studio](chaos-studio-scenario-reports.md).

## Run the steps individually (optional)

The `az chaos setup` command wraps the granular commands behind one workflow verb. To control each step yourself, run them directly:

```azurecli
az chaos workspace create \
  --name <workspace-name> \
  --resource-group <resource-group> \
  --location <region> \
  --scopes "/subscriptions/<subscription-id>/resourceGroups/<target-resource-group>" \
  --system-assigned ""

az chaos workspace refresh-recommendation \
  --name <workspace-name> \
  --resource-group <resource-group>
```

Grant the Workspace identity the roles it needs by using `az role assignment create`, or let `az chaos scenario config fix-permissions` handle it per configuration.

## Clean up resources

When you're done, delete the resources you created to avoid ongoing charges:

```azurecli
az group delete --name <resource-group> --yes --no-wait
```

If you scoped the Workspace to resources outside the deleted resource group, remove any role assignments granted to the Workspace identity.

[!INCLUDE [chaos-studio-feedback](includes/chaos-studio-feedback.md)]

## Related content

- [What are Workspaces?](chaos-studio-workspaces-overview.md)
- [Scenarios in Azure Chaos Studio](chaos-studio-scenarios.md)
- [Scenario reports in Azure Chaos Studio](chaos-studio-scenario-reports.md)
- [Quickstart: Create a Workspace and run your first Scenario](quickstart-create-workspace.md)
