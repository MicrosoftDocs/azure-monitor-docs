---
title: Filter resources for Chaos Studio Workspace Scenarios
description: Use include and exclude criteria to control which discovered resources participate in an Azure Chaos Studio Workspace Scenario.
author: nikhilkaul-msft
ms.topic: how-to
ms.date: 10/05/2026
ms.custom: devx-track-azurecli
ms.devlang: azurecli
ai-usage: ai-assisted
---

# Filter resources for Chaos Studio Workspace Scenarios

Resource targeting controls which discovered Azure resources an Azure Chaos Studio Workspace Scenario can affect. It filters resources that the Workspace discovers and the Scenario supports.

Use resource targeting to keep production resources out of a fault, test only resources marked for testing, or limit the affected resources to one availability zone.

For example, include resources tagged `chaos-ready=true` and exclude resources tagged `environment=production`. A resource with both tags is excluded.

This article shows you how to create that policy and validate the selected resources before you run the Scenario.

[!INCLUDE [chaos-studio-workspaces-preview](includes/chaos-studio-workspaces-preview.md)]

## Prerequisites

- An Azure subscription. [!INCLUDE [quickstarts-free-trial-note](~/reusable-content/ce-skilling/azure/includes/quickstarts-free-trial-note.md)]
- A [Chaos Studio Workspace](quickstart-create-workspace.md) that discovers supported resources.
- A Scenario and Scenario configuration in the Workspace.
- The Azure CLI. To install or upgrade it, see [How to install the Azure CLI](/cli/azure/install-azure-cli). You can also run the commands in [Azure Cloud Shell](https://shell.azure.com).
- Permission to update and validate the Scenario configuration.

Resource targeting is available in the `2026-08-01-preview` REST API for Chaos Studio Workspaces. In this API version, `resourceTargeting` replaces the earlier `filters` and `exclusions` properties. Don't combine the old and new properties in one configuration. The examples in this article use `az rest` to call the new API.

Sign in and select the subscription that contains the Workspace:

```azurecli
az login
az account set --subscription "<subscription-name-or-id>"
```

## Create a resource-targeting policy

The following policy includes resources tagged `chaos-ready=true` and excludes resources tagged `environment=production`. A resource that has both tags is excluded because exclusion takes precedence.

Create a file named `scenario-configuration.json`:

```json
{
  "properties": {
    "scenarioId": "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Chaos/workspaces/<workspace-name>/scenarios/<scenario-name>",
    "parameters": [
      {
        "key": "duration",
        "value": "PT10M"
      }
    ],
    "resourceTargeting": {
      "include": {
        "tags": [
          {
            "key": "chaos-ready",
            "value": "true"
          }
        ]
      },
      "exclude": {
        "tags": [
          {
            "key": "environment",
            "value": "production"
          }
        ]
      }
    }
  }
}
```

> [!IMPORTANT]
> A `PUT` request creates the Scenario configuration if it doesn't exist. If the configuration already exists, the request modifies it by replacing the existing property values with the values you provide. The `resourceTargeting` criteria in the request replace the previously saved criteria; they aren't added to them. Preserve the configuration's `scenarioId` and include any existing `parameters` that the Scenario still requires.

Set variables for the Scenario configuration:

```azurecli
SUBSCRIPTION_ID="<subscription-id>"
RESOURCE_GROUP="<resource-group>"
WORKSPACE_NAME="<workspace-name>"
SCENARIO_NAME="<scenario-name>"
CONFIGURATION_NAME="<configuration-name>"

CONFIGURATION_URL="https://management.azure.com/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.Chaos/workspaces/$WORKSPACE_NAME/scenarios/$SCENARIO_NAME/configurations/$CONFIGURATION_NAME"
```

Create or update the configuration:

```azurecli
az rest \
  --method put \
  --url "$CONFIGURATION_URL?api-version=2026-08-01-preview" \
  --body @scenario-configuration.json
```

### Review the saved policy

Retrieve the scenario configuration to confirm the saved `resourceTargeting` policy:

```azurecli
az rest \
  --method get \
  --url "$CONFIGURATION_URL?api-version=2026-08-01-preview" \
  --query properties.resourceTargeting
```

### Migrate an earlier targeting policy

Migration from `filters` and `exclusions` is manual. When you send a `PUT` request by using the `2026-08-01-preview` API, `resourceTargeting` replaces the earlier targeting properties. The service doesn't copy their values into the new policy for you.

| Earlier property | `resourceTargeting` equivalent |
|---|---|
| `filters.locations`, `filters.zones`, `filters.physicalZones` | `include.locations`, `include.zones`, `include.physicalZones` |
| `exclusions.resources`, `exclusions.tags`, `exclusions.types` | `exclude.resources`, `exclude.tags`, `exclude.types` |

Before you update the configuration, record its existing `filters` and `exclusions` values. Map those values to `resourceTargeting`, and send a `PUT` request that includes the mapped policy, the existing `scenarioId`, and any existing `parameters` that the Scenario still requires. If you omit a mapped criterion, its earlier value isn't retained. The `2026-08-01-preview` request model removes `filters` and `exclusions`, so don't include those properties in the request.

After migration, use `az rest` with the `2026-08-01-preview` API to manage the configuration. The current `az chaos scenario config create` and `az chaos scenario config update` commands use the earlier API model and don't support `resourceTargeting`.

## Validate the selected resources

### Run validation

1. Start validation:

   ```azurecli
   az rest \
     --method post \
     --url "$CONFIGURATION_URL/validate?api-version=2026-08-01-preview" \
     --debug 2>validation-debug.log
   ```

1. Find and copy the `Location` URL from the response headers. The response might also provide a `Retry-After` interval. The `--debug` output records these headers because `az rest` doesn't print them by default:

   ```azurecli
   grep -Ei "location|retry-after" validation-debug.log
   ```

1. Set the URL as a variable:

   ```azurecli
   VALIDATION_URL="<location-url>"
   ```

1. Get the validation status:

   ```azurecli
   az rest --method get --url "$VALIDATION_URL"
   ```

Validation is a long-running operation. Repeat the GET request after the `Retry-After` interval, if the response provides one. Stop polling when `properties.status` is `Succeeded`, `RequiresAttention`, or `NoResolvedResources`.

### Check the result

The completed validation result separates the discovered resources into:

- `resources`: Resources that passed resource targeting and will be affected by the run.
- `excludedResources`: Scenario-compatible resources that the policy removed from the run.

The following abbreviated result confirms that `vm-chaos` is selected and `vm-production` is excluded:

```json
{
  "properties": {
    "status": "Succeeded",
    "resources": [
      {
        "id": "/subscriptions/<subscription-id>/resourceGroups/<target-resource-group>/providers/Microsoft.Compute/virtualMachines/vm-chaos"
      }
    ],
    "excludedResources": [
      {
        "id": "/subscriptions/<subscription-id>/resourceGroups/<target-resource-group>/providers/Microsoft.Compute/virtualMachines/vm-production"
      }
    ]
  }
}
```

Review both lists before you fix permissions or execute the Scenario. Validation can also return permission errors, resource-state errors, or a `NoResolvedResources` status when no resources remain after targeting.

> [!IMPORTANT]
> Validation creates the execution plan used by the next Scenario run. If your resource inventory or targeting policy changes, validate the configuration again before you run it.

## How resource targeting works

A Workspace first discovers resources in its configured [scope](chaos-studio-workspaces-overview.md#scope-types). A Scenario then identifies the resource types that its Actions support. Resource targeting further narrows the selected resources for a specific Scenario configuration.

Chaos Studio applies resource targeting in this order:

1. Chaos Studio starts with resources that the Workspace discovered and the Scenario supports.
1. Chaos Studio selects resources that match `include`. If you omit `include`, it keeps all resources from the first step.
1. Chaos Studio removes resources that match any value in any `exclude` criterion.

If a resource matches both `include` and `exclude`, Chaos Studio excludes it.

A criterion is a filter category, such as `tags` or `locations`. Within an `include` criterion, a resource needs to match only one listed value. Across `include` criteria, a resource must match every criterion that has values.

For example, suppose `include` lists two tag pairs and two locations. A resource must match at least one listed tag pair and one listed location.

An omitted, `null`, or empty array doesn't filter resources. If you omit `resourceTargeting`, all discovered resources that apply to the Scenario can participate.

## Supported criteria

You can use the same criteria under `include` and `exclude`.

| Criterion | Description | Requirements |
|---|---|---|
| `locations` | Azure location names, such as `eastus`, `westeurope`, or `global`. | Use normalized location names, such as `eastus`, instead of display names, such as `East US`. Matching is case-insensitive. |
| `zones` | Logical availability zone identifiers, such as `1`, `2`, `3`, or `zone-redundant`. | Set `locations` in the same `include` or `exclude` object. Don't use `zones` and `physicalZones` together in that object. |
| `physicalZones` | Physical datacenter zone identifiers in the format `{region}-az{N}`, such as `westus2-az1`. | Don't use `physicalZones` and `zones` together in the same `include` or `exclude` object. Chaos Studio resolves physical zones to the corresponding logical zone for each subscription at run time. |
| `types` | Azure resource types, such as `Microsoft.Compute/virtualMachines`. | Matching is case-insensitive. Use a trailing wildcard to match a provider namespace, such as `Microsoft.Compute/*`. |
| `tags` | Azure resource tag key-value pairs. | Matching is case-insensitive and literal. |
| `resources` | Fully qualified Azure resource IDs. | Matching is case-insensitive. |

Tag criteria follow these rules:

- A resource matches the criterion if it has any listed key-value pair.
- The value `*` matches only a tag whose value is literally `*`; it isn't a wildcard.

## More targeting examples

For each example:

1. Replace only `properties.resourceTargeting` in `scenario-configuration.json` with the example object.
1. Keep the existing `scenarioId` and any `parameters` that the Scenario still requires.
1. Rerun the create-or-update command.
1. Validate the selected resources again before you run the Scenario.

### Match either of two tags

Use multiple tag pairs when either tag should qualify a resource. This example includes resources with `chaos-ready=true` or `team=platform`, and excludes any with `environment=production`.

```json
{
  "include": {
    "tags": [
      {
        "key": "chaos-ready",
        "value": "true"
      },
      {
        "key": "team",
        "value": "platform"
      }
    ]
  },
  "exclude": {
    "tags": [
      {
        "key": "environment",
        "value": "production"
      }
    ]
  }
}
```

### Use physical availability zones

To target a physical datacenter zone consistently across subscriptions, use `physicalZones` instead of `zones`:

```json
{
  "include": {
    "physicalZones": [
      "westus2-az1"
    ],
    "types": [
      "Microsoft.Compute/virtualMachines",
      "Microsoft.Compute/virtualMachineScaleSets"
    ]
  }
}
```

At execution time, Chaos Studio resolves each physical zone to the logical zone that represents the same datacenter in each subscription. Don't specify `zones` and `physicalZones` together under the same `include` or `exclude` object.

### Exclude resource types

Resource type matching supports a trailing wildcard. This example excludes all resources from the `Microsoft.Network` provider namespace:

```json
{
  "exclude": {
    "types": [
      "Microsoft.Network/*"
    ]
  }
}
```

Resource targeting doesn't expand the Workspace scope or add unsupported resources to a Scenario. A matching resource must already be discovered by the Workspace and supported by the Scenario.

[!INCLUDE [chaos-studio-feedback](includes/chaos-studio-feedback.md)]

## Next steps

- [Manage Workspaces and Scenarios with the Azure CLI](chaos-studio-manage-cli.md)
- [Configure permissions and identity for Chaos Studio Workspaces](chaos-studio-workspace-permissions.md)
- [Create least-privilege roles for Chaos Studio Workspaces](chaos-studio-workspaces-least-privilege-roles.md)
- [Review the Scenarios available in Chaos Studio Workspaces](chaos-studio-scenarios.md)
