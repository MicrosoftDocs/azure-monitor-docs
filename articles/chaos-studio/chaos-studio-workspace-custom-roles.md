---
title: Create least-privilege custom roles for Chaos Studio Workspaces
description: Learn how to grant a Workspace managed identity only the exact RBAC actions a Scenario needs by building custom Azure roles instead of assigning built-in roles.
author: nikhilkaul-msft
ms.topic: how-to
ms.date: 07/29/2026
ai-usage: ai-assisted
---

# Create least-privilege custom roles for Chaos Studio Workspaces

Chaos Studio can assign the recommended Azure **built-in** roles to your Workspace managed identity for you. This is convenient, but a built-in role usually grants more actions than a single Scenario actually uses. If your organization enforces least privilege, you can instead author a **custom Azure role** that contains only the exact role-based access control (RBAC) actions a Scenario needs, and assign it to the Workspace managed identity on only the resources that require it.

This article shows you how to:

> [!div class="checklist"]
> * Discover the exact permissions (RBAC actions) a Scenario needs.
> * Discover which resources the Workspace managed identity needs those permissions on.
> * Build a custom role from that permission set and assign it at the right scope.

[!INCLUDE [chaos-studio-workspaces-preview](includes/chaos-studio-workspaces-preview.md)]

## Prerequisites

- A [Chaos Studio Workspace](chaos-studio-workspaces-overview.md) with a managed identity and at least one Scenario configuration.
- Permission to create custom roles and assign roles on the target resources (**Owner** or **User Access Administrator** on those resources).
- Read access for the Workspace managed identity on the scope you want Chaos Studio to discover, so that resource discovery can resolve your targets. See [Make sure resource discovery has completed](#make-sure-resource-discovery-has-completed) in Step 1.
- The [Azure CLI](/cli/azure/install-azure-cli) installed, or access to Azure Cloud Shell.

## Why custom roles instead of automatic assignment

When Chaos Studio assigns permissions automatically, it inspects a Scenario configuration and assigns the **recommended built-in roles** to the Workspace managed identity. For information about how identity, scope, and role assignments work, see [Permissions and identity in Chaos Studio Workspaces](chaos-studio-workspace-permissions.md).

Automatic assignment is convenient, but built-in roles are broad. To grant only the precise actions a Scenario requires, build a custom role scoped to those exact actions. Chaos Studio already computes the required actions and the exact target resources during validation, so you copy them straight into a custom role definition.

## Step 1: Discover the exact permissions and resources needed

Validation resolves your Scenario against the discovered resources, then checks whether the managed identity has the required RBAC permissions on each resolved target. When permissions are missing, validation reports exactly what is missing, what is required, and on which resource.

Throughout this article, replace the placeholders (`{subscriptionId}`, `{rg}`, `{ws}`, `{scenario}`, `{name}`) with your own values.

### Make sure resource discovery has completed

Before validation can report permission errors, Chaos Studio must **discover** the resources in the Workspace scope. Discovery runs as the Workspace managed identity, so that identity needs **read access** on the scope first. If it doesn't, discovery fails and validation reports a discovery error (for example, `ResourceDiscoveryNotReadyError` or `ResourceDiscoveryPermissionError`) instead of the permission errors you're looking for.

Grant the managed identity read access on the scope you want discovered. The built-in **Reader** role is the simplest option; to stay strictly least-privilege, you can instead use a custom role that contains only the `*/read` actions for the resource types in scope.

```azurecli-interactive
az role assignment create \
  --assignee-object-id <managed-identity-principalId> \
  --assignee-principal-type ServicePrincipal \
  --role "Reader" \
  --scope "/subscriptions/{subscriptionId}/resourceGroups/{rg}"
```

(Step 3 shows how to get the managed identity's `principalId`.)

Then trigger discovery and wait for it to finish. This is a long-running operation that returns `202 Accepted`:

```azurecli-interactive
az rest --method post \
  --url "https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{rg}/providers/Microsoft.Chaos/workspaces/{ws}/refreshRecommendations?api-version=2026-05-01-preview"
```

Poll the singleton `evaluations/latest` resource until `status` is `Succeeded`:

```azurecli-interactive
az rest --method get \
  --url "https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{rg}/providers/Microsoft.Chaos/workspaces/{ws}/evaluations/latest?api-version=2026-05-01-preview" \
  --query "properties.status" -o tsv
```

You can review what was found in the `discoveredResources` collection on the Workspace. Once discovery succeeds, continue to validation below.

### Run validation

Trigger validation on the Scenario configuration. This is a long-running operation that returns `202 Accepted`:

```azurecli-interactive
az rest --method post \
  --url "https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{rg}/providers/Microsoft.Chaos/workspaces/{ws}/scenarios/{scenario}/configurations/{name}/validate?api-version=2026-05-01-preview"
```

### Poll for the result

Poll the singleton `validations/latest` resource until `status` reaches a terminal state:

```azurecli-interactive
az rest --method get \
  --url "https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{rg}/providers/Microsoft.Chaos/workspaces/{ws}/scenarios/{scenario}/configurations/{name}/validations/latest?api-version=2026-05-01-preview"
```

When the managed identity is missing permissions, `status` is `RequiresAttention` and the `validationErrors` property contains a `permission` array.

### Read the permission errors

The following example is a `RequiresAttention` response with two permission errors&mdash;one for a virtual machine and one for a network security group:

```json
{
  "name": "latest",
  "type": "Microsoft.Chaos/workspaces/scenarios/configurations/validations",
  "properties": {
    "status": "RequiresAttention",
    "validationErrors": {
      "permission": [
        {
          "resourceId": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/contoso-prod/providers/Microsoft.Compute/virtualMachines/contoso-vm-01",
          "requiredPermissions": [
            "Microsoft.Compute/virtualMachines/powerOff/action",
            "Microsoft.Compute/virtualMachines/start/action"
          ],
          "missingPermissions": [
            "Microsoft.Compute/virtualMachines/powerOff/action",
            "Microsoft.Compute/virtualMachines/start/action"
          ],
          "recommendedRoles": [
            "9980e02c-c2be-4d73-94e8-173b1dc7cf3c"
          ]
        },
        {
          "resourceId": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/contoso-prod/providers/Microsoft.Network/networkSecurityGroups/contoso-nsg-01",
          "requiredPermissions": [
            "Microsoft.Network/networkSecurityGroups/read",
            "Microsoft.Network/networkSecurityGroups/write"
          ],
          "missingPermissions": [
            "Microsoft.Network/networkSecurityGroups/write"
          ],
          "recommendedRoles": [
            "4d97b98b-1d4f-4787-a291-c67834d212e7"
          ]
        }
      ]
    }
  }
}
```

Each object in the `permission` array tells you everything you need:

| Field | What it tells you | How to use it |
| --- | --- | --- |
| `resourceId` | The target resource the managed identity needs access to | The **scope** to assign your custom role on (Step 3) |
| `requiredPermissions` | The **full** set of RBAC actions required for that resource | Copy these verbatim into your custom role's `Actions` (Step 2) |
| `missingPermissions` | The actions the managed identity is currently missing | The subset still to be granted&mdash;useful for diagnosing partial coverage |
| `recommendedRoles` | The built-in role(s) automatic assignment would use | Cross-reference only&mdash;build your custom role from `requiredPermissions` instead |

> [!TIP]
> Build your custom role from `requiredPermissions` (the complete required set), not `missingPermissions`. `missingPermissions` reflects only what is currently absent for this identity, so it changes as you grant roles. `requiredPermissions` is the stable, complete list for that resource.

## Step 2: Build a custom role definition

Collect the `requiredPermissions` across all `permission` entries and put them into a custom role's `Actions` array. Scope the role's `AssignableScopes` to the subscription or resource groups that contain the target resources.

Create a role definition JSON file named *chaos-vm-nsg-role.json*:

```json
{
  "Name": "Chaos Studio - Contoso VM and NSG scenario (least privilege)",
  "Description": "Only the RBAC actions required by the Contoso zone-down Scenario configuration.",
  "Actions": [
    "Microsoft.Compute/virtualMachines/powerOff/action",
    "Microsoft.Compute/virtualMachines/start/action",
    "Microsoft.Network/networkSecurityGroups/read",
    "Microsoft.Network/networkSecurityGroups/write"
  ],
  "DataActions": [],
  "NotActions": [],
  "NotDataActions": [],
  "AssignableScopes": [
    "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/contoso-prod"
  ]
}
```

Then create the role:

```azurecli-interactive
az role definition create --role-definition chaos-vm-nsg-role.json
```

> [!IMPORTANT]
> Copy the actions verbatim from `requiredPermissions`. If a Scenario needs **data-plane** actions, they appear in `requiredPermissions` as data actions (for example, `Microsoft.KeyVault/vaults/secrets/...`). Place those in the role's `DataActions` array rather than `Actions`. When in doubt, cross-check against the built-in role(s) listed in `recommendedRoles`.

## Step 3: Assign the custom role to the Workspace managed identity

The Workspace managed identity is the system-assigned or user-assigned identity attached to your Workspace. Chaos Studio uses it to inject faults, so the role must be assigned to its principal. For background, see [Permissions and identity in Chaos Studio Workspaces](chaos-studio-workspace-permissions.md).

### Get the managed identity principal ID

For a **system-assigned** identity:

```azurecli-interactive
az rest --method get \
  --url "https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{rg}/providers/Microsoft.Chaos/workspaces/{ws}?api-version=2026-05-01-preview" \
  --query "identity.principalId" -o tsv
```

For a **user-assigned** identity, use the `principalId` of that managed identity resource instead.

### Assign the role on each target resource

Assign your custom role to the managed identity on each `resourceId` returned in the validation permission errors:

```azurecli-interactive
az role assignment create \
  --assignee-object-id <managed-identity-principalId> \
  --assignee-principal-type ServicePrincipal \
  --role "Chaos Studio - Contoso VM and NSG scenario (least privilege)" \
  --scope "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/contoso-prod/providers/Microsoft.Compute/virtualMachines/contoso-vm-01"
```

Repeat for the network security group `resourceId`, and for any other distinct `resourceId` in the permission errors.

> [!TIP]
> Each distinct `resourceId` in the permission errors needs coverage. To avoid one assignment per resource, you can assign the custom role once at a common parent scope (for example, the resource group `/subscriptions/.../resourceGroups/contoso-prod`) that contains all the targets, as long as that scope is listed in the role's `AssignableScopes`. Choose the narrowest parent scope that still covers every target to stay least-privilege.

## Step 4: Re-validate

After the role assignments propagate (RBAC changes can take a few minutes), re-run validation and confirm the permission errors are gone:

```azurecli-interactive
az rest --method post \
  --url "https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{rg}/providers/Microsoft.Chaos/workspaces/{ws}/scenarios/{scenario}/configurations/{name}/validate?api-version=2026-05-01-preview"
```

Poll `validations/latest` again. The configuration is ready to run once `status` is `Succeeded` (or `Accepted` for non-blocking warnings) and `validationErrors` is `null` (or no longer contains a `permission` array).

## Keep permissions in sync

Re-run Step 1 whenever:

- You change the Scenario, its configuration, filters, or exclusions. The resolved resource set&mdash;and therefore the required scopes&mdash;can change.
- Your Workspace discovers new resources that fall in scope.
- A Scenario update adds new Action permissions. New Actions can introduce more `requiredPermissions` that your custom role doesn't yet grant.

The `recommendedRoles` field always shows the built-in role equivalent for reference, so you can compare your custom role against what automatic assignment would have granted.

## Related content

- [Permissions and identity in Chaos Studio Workspaces](chaos-studio-workspace-permissions.md)
- [Troubleshoot Workspaces and Scenarios](troubleshoot-workspaces-scenarios.md)
- [What are Chaos Studio Workspaces?](chaos-studio-workspaces-overview.md)
- [Quickstart: Create a Workspace and run a Scenario](quickstart-create-workspace.md)
