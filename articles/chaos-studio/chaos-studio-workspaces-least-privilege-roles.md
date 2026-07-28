---
title: Use least-privilege custom roles with Chaos Studio Workspaces
description: Discover the exact RBAC actions and target resources a Scenario needs, then create least-privilege custom roles for the Workspace managed identity instead of using fixResourcePermissions.
author: nikhilkaul-msft
ms.service: azure-chaos-studio
ms.author: nikhilkaul
ms.topic: how-to
ms.date: 07/28/2026
ai-usage: ai-assisted
---

# Use least-privilege custom roles with Chaos Studio Workspaces

A Chaos Studio Workspace runs Scenarios by using its [managed identity](chaos-studio-workspace-permissions.md), which must hold the RBAC roles required to act on each target resource. The `fixResourcePermissions` operation can assign those roles for you automatically, but it grants **Azure built-in roles** (for example, Virtual Machine Contributor or Network Contributor). Built-in roles include more permissions than a Scenario actually uses, so they don't satisfy a strict least-privilege policy.

This article is for customers who opt out of `fixResourcePermissions` and instead create their own **custom roles** that contain only the exact actions a Scenario needs. It shows you how to:

> [!div class="checklist"]
> * Discover the exact RBAC actions a Scenario configuration requires.
> * Identify the specific resources the managed identity needs a role on.
> * Build a least-privilege custom role and assign it to the Workspace managed identity.

[!INCLUDE [chaos-studio-workspaces-preview](includes/chaos-studio-workspaces-preview.md)]

## Why use custom roles instead of fixResourcePermissions

| Approach | What it does | Trade-off |
|---|---|---|
| `fixResourcePermissions` | Automatically assigns the recommended **built-in** roles to the managed identity on each target resource. | Fast and hands-off, but built-in roles grant broader permissions than the Scenario uses. |
| **Custom roles** (this article) | You author a role that contains only the exact `Actions` (and `DataActions`) the Scenario requires, then assign it on each target resource. | Full least-privilege control; requires a few extra steps and maintenance when Scenarios change. |

The key insight is that validation already tells you the exact permissions and resources involved. You use that output to build a minimal role instead of accepting the built-in role.

## Step 1: Discover the exact permissions and resources needed

[Validation](chaos-studio-scenarios.md) resolves your Scenario configuration against the resources currently in the Workspace scope and checks whether the managed identity can perform every required action on each target. When permissions are missing, validation reports precisely which actions are missing and on which resource.

1. Create a Scenario configuration for the Scenario you intend to run.

1. Start a validation:

   ```azurecli
   az rest --method post \
     --url "https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Chaos/workspaces/{workspace}/scenarios/{scenario}/configurations/{configuration}/validate?api-version=2026-05-01-preview"
   ```

   The call returns `202 Accepted`.

1. Poll the latest validation result until it reaches a terminal state:

   ```azurecli
   az rest --method get \
     --url "https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Chaos/workspaces/{workspace}/scenarios/{scenario}/configurations/{configuration}/validations/latest?api-version=2026-05-01-preview"
   ```

1. When the managed identity is missing permissions, `status` is `RequiresAttention` and the `validationErrors.permission` array lists one entry per affected resource:

   ```json
   {
     "properties": {
       "status": "RequiresAttention",
       "validationErrors": {
         "permission": [
           {
             "resourceId": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Network/networkSecurityGroups/nsg1",
             "requiredPermissions": [
               "Microsoft.Network/networkSecurityGroups/read",
               "Microsoft.Network/networkSecurityGroups/write",
               "Microsoft.Network/networkSecurityGroups/securityRules/read",
               "Microsoft.Network/networkSecurityGroups/securityRules/write",
               "Microsoft.Network/networkSecurityGroups/securityRules/delete"
             ],
             "missingPermissions": [
               "Microsoft.Network/networkSecurityGroups/securityRules/write",
               "Microsoft.Network/networkSecurityGroups/securityRules/delete"
             ],
             "recommendedRoles": [
               "Network Contributor"
             ]
           }
         ]
       }
     }
   }
   ```

Each permission error gives you everything you need:

| Field | Meaning | How you use it |
|---|---|---|
| `resourceId` | The specific target resource the identity must act on. | This is the **scope** for the role assignment in Step 3. |
| `requiredPermissions` | The full set of RBAC actions the Scenario needs on that resource. | These become the `Actions` in your custom role in Step 2. |
| `missingPermissions` | The subset of `requiredPermissions` the identity currently lacks. | Use it to confirm what's still missing after you assign the role. |
| `recommendedRoles` | The built-in role(s) `fixResourcePermissions` would assign. | Reference only — for least privilege, build from `requiredPermissions` instead. |

> [!TIP]
> Validation resolves against the resources actually in scope, so `requiredPermissions` reflects the real actions for your configuration and filters. If a Scenario needs data-plane access, those actions also appear here and belong in `DataActions` (Step 2).

## Step 2: Create a least-privilege custom role

Collect the `requiredPermissions` from every permission error and place them in the `Actions` list of a custom role definition. Set `AssignableScopes` to the subscriptions or resource groups that contain your target resources.

1. Create a role definition file, `chaos-least-privilege-role.json`. Copy the actions verbatim from `requiredPermissions`:

   ```json
   {
     "Name": "Chaos Scenario - DNS Outage (least privilege)",
     "Description": "Only the actions required to run the DNS Outage Scenario against target NSGs.",
     "Actions": [
       "Microsoft.Network/networkSecurityGroups/read",
       "Microsoft.Network/networkSecurityGroups/write",
       "Microsoft.Network/networkSecurityGroups/securityRules/read",
       "Microsoft.Network/networkSecurityGroups/securityRules/write",
       "Microsoft.Network/networkSecurityGroups/securityRules/delete"
     ],
     "DataActions": [],
     "NotActions": [],
     "NotDataActions": [],
     "AssignableScopes": [
       "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg"
     ]
   }
   ```

1. Create the role:

   ```azurecli
   az role definition create --role-definition chaos-least-privilege-role.json
   ```

> [!NOTE]
> Different Scenarios (and different target resource types within one Scenario) require different actions. Create one role per Scenario, or combine the required actions from all the Scenarios a Workspace runs into a single role. Always source the actions from validation output rather than guessing.

## Step 3: Assign the custom role to the Workspace managed identity

Assign the custom role to the Workspace's managed identity, scoped to each `resourceId` from the validation output.

1. Get the managed identity's principal (object) ID. For a system-assigned identity:

   ```azurecli
   az resource show \
     --ids "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Chaos/workspaces/{workspace}" \
     --query "identity.principalId" -o tsv
   ```

   For a user-assigned identity, get the `principalId` of that managed identity resource instead.

1. Assign the role on each `resourceId` reported by validation:

   ```azurecli
   az role assignment create \
     --assignee-object-id <managedIdentityPrincipalId> \
     --assignee-principal-type ServicePrincipal \
     --role "Chaos Scenario - DNS Outage (least privilege)" \
     --scope "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Network/networkSecurityGroups/nsg1"
   ```

   Repeat for every distinct `resourceId` in the permission errors. If you prefer fewer assignments, assign the role once at a common parent scope (such as the resource group) that contains all the target resources — but keep the scope as narrow as your policy allows.

## Step 4: Re-validate before you run

Run validation again and confirm the managed identity now has sufficient access:

```azurecli
az rest --method post \
  --url "https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Chaos/workspaces/{workspace}/scenarios/{scenario}/configurations/{configuration}/validate?api-version=2026-05-01-preview"
```

Poll `validations/latest` until `status` is `Succeeded` (or `Accepted` with only non-blocking warnings) and `validationErrors.permission` is empty. Only then [execute](chaos-studio-scenarios.md) the Scenario.

## Keep custom roles in sync

Re-run validation and update your custom role whenever you:

* Change the Scenario or its configuration (parameters, filters, or exclusions).
* Add resources to the Workspace scope that the Scenario will target.
* Adopt a new or updated Scenario template, which may add required actions.

If a run fails with a permissions error, start again at [Step 1](#step-1-discover-the-exact-permissions-and-resources-needed) to capture any newly required actions.

## Next steps

- [Permissions and identity in Chaos Studio Workspaces](chaos-studio-workspace-permissions.md)
- [Troubleshoot Workspaces and Scenarios in Azure Chaos Studio](troubleshoot-workspaces-scenarios.md)
- [Chaos Studio Workspaces overview](chaos-studio-workspaces-overview.md)
