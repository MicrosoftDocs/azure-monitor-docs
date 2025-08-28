---
title: Application Insights managed workspaces
description: This article explains automatically created managed workspaces
ms.topic: how-to
ms.date: 08/28/2025
ms.reviewer: cogoodson
---

# Managed workspaces in Application Insights

[Azure Monitor](../fundamentals/overview.md) [Application Insights](./app-insights-overview.md) requires a connection to a [Log Analytics](../logs/log-analytics-overview.md) workspace to store and analyze telemetry data. To simplify deployment, Application Insights automatically creates a managed workspace when you don't specify one during resource creation.

## What is a managed workspace?

A managed workspace is a Log Analytics workspace that Application Insights creates and manages on your behalf. This workspace is used exclusively by the Application Insights resource that created it.

If you create an Application Insights resource without specifying a Log Analytics workspace, Azure automatically creates a managed workspace. If you attempt to create a classic Application Insights resource, Azure instead creates a workspace-based version that uses a managed workspace.

## What happens during managed workspace creation?

When Azure creates a managed workspace during Application Insights deployment, the following actions occur:

- It creates the Application Insights resource in the specified subscription and resource group.
- It creates a Log Analytics workspace and links it to the Application Insights resource.
- It creates a new resource group and places the managed workspace in that group.

## Limitations

Managed workspaces have the following limitations:

- Support only the Application Insights resource that created them. A managed workspace can't be used for diagnostic settings, custom logs, or another Application Insights instance.
- Changes to workspace settings, such as quotas, are allowed, but the workspace can't be repurposed for other uses.
- Tags can't be added to a managed workspace.
- Removal follows one of two paths:
  - Delete the Application Insights resource. Azure deletes the managed resource group and the managed workspace automatically.
  - Keep the Application Insights resource by connecting it to a different Log Analytics workspace, then delete the managed resource group that contains the managed workspace.

## Identify managed workspaces

Managed workspaces created by Application Insights follow specific naming conventions.

**Managed workspace groups**
- **Name**: `ai_<APPINSIGHTS RESOURCE NAME>_<APPINSIGHTS RESOURCE ID>_managed`
- **Managed by**: The associated Application Insights resource

**Managed Log Analytics workspaces**
- **Name**: `managed-<APPINSIGHTS RESOURCE NAME>-ws`

You can identify the managing resource by checking the **Managed By** property in the Azure portal.

## Remove managed workspaces

Remove a managed workspace only after it isn't connected to an Application Insights resource. Use one of the following options.

### Option 1: Delete the Application Insights resource

Delete the Application Insights resource that owns the managed workspace. Azure deletes the managed resource group and the workspace automatically.

### Option 2: Keep the Application Insights resource

1. **Reconnect the Application Insights resource to a different Log Analytics workspace.**
1. **Delete the managed resource group** that contains the managed workspace.

> [!NOTE]
> The managed workspace shows **Deny assignments** in the Azure portal. These deny assignments don't prevent deletion of the resource group that contains the managed workspace. Resource group deletion completes and removes the workspace.

## Automatically migrated classic resources

Beginning in April 2025, classic Application Insights resources are automatically migrated to workspace-based resources. As part of the migration:

- The classic Application Insights resource is converted to a workspace-based resource.
- A managed Log Analytics workspace is created and linked to the migrated resource.
- The workspace is placed in a new resource group. The new group doesn't inherit access permissions from the Application Insights resource group. However, users with appropriate permissions can still query telemetry data through the Application Insights resource, due to resource-centric access control.

> [!IMPORTANT]  
> Each migrated classic Application Insights resource gets its own managed workspace and resource group. Azure sets a limit on the number of resource groups allowed in a subscription. Automatic migration can use up this limit and block the creation of new resource groups. To avoid hitting this limit, manually migrate your classic Application Insights resources by following the steps at [Convert classic Application Insights resources](/previous-versions/azure/azure-monitor/app/convert-classic-resource).

### Limitations of automatic migration

> [!WARNING]
> * Microsoft completed attempts to automatically migrate classic Application Insights resources to workspace-based resources. Remaining classic resources must be manually migrated.
> * Classic Application Insights resources that aren't migrated by July 31, 2025, are disabled, and can't ingest new data. To reenable a resource, convert it to a workspace-based Application Insights resource.

Some classic Application Insights resources can't be migrated until you take extra steps. Migration is blocked in the following scenarios:

- Using Unicode or non-UTF-8 characters in the resource name or resource group name.
- Blocking Log Analytics workspace creation in the subscription.
- Enforcing policies that prevent new resource creation in the subscription.
- Approaching the resource group limit in the subscription. Each migrated resource gets its own workspace and resource group. If your subscription already has many resource groups or classic Application Insights resources, you could run out of remaining quota. Azure subscriptions support up to 980 total resource groups.

To complete the migration, update your subscription or resource configuration to remove the blockers mentioned earlier.

To prevent service interruptions, resolve these issues and [manually migrate classic Application Insights resources](/previous-versions/azure/azure-monitor/app/convert-classic-resource).

## AMPLS considerations

If your Application Insights resource uses Azure Monitor Private Link Scope (AMPLS), review this guidance to avoid data access issues after migration to Log Analytics workspaces.

### What changes during migration

Classic Application Insights resources support Public Network Access (PNA) settings for both ingestion and query. Some AMPLS users disable public query to limit telemetry access to private networks.

During migration, the process copies the PNA settings from the classic resource to the new Log Analytics workspace. In the interest of security, it doesn't add the workspace to AMPLS. This design gives the resource owner full control over private network access.

If public query access is disabled and the workspace isn't associated with AMPLS, telemetry queries from a private network fail after migration. To restore access, either add the workspace to AMPLS or enable public query access.

Telemetry ingestion continues regardless of PNA settings or AMPLS scope. The ingestion path from the Application Insights endpoint to the Log Analytics workspace uses Microsoft's Azure backbone network. Migration doesn't interrupt data collection.

### Common configurations

#### Before migration (working state)

- Application Insights is part of AMPLS.
- PNA (Query): disabled
- PNA (Ingestion): disabled
- Queries and ingestion work from the private network.

#### After migration (problem state)

- The Log Analytics workspace keeps the same PNA settings.
- The workspace isn't associated with AMPLS.
- Queries from the private network fail. The workspace blocks access because it doesn't trust the network.

#### After manual update (working state)

- The workspace is added to AMPLS.
- Private query access is restored.
- Queries and ingestion work from the private network.

### Required actions

If you're using AMPLS, take the following steps:

- **Add the Log Analytics workspace to your AMPLS** to maintain private query access.
- **Alternatively, enable PNA for queries** if private access isn't required.
- **Validate telemetry query access** from your virtual network after migration.

### How to add a workspace to AMPLS

1. Navigate to your Azure Monitor Private Link Scope.
2. Select your AMPLS resource.
3. Open **Resource associations**.
4. Select **Add**.
5. Choose the Log Analytics workspace created during migration.
6. Save the configuration.

> [!TIP]
> To identify the new workspace, open your Application Insights resource in the Azure portal and review the value under **Workspace**.

## Migration blocked due to policy restrictions

Some Application Insights resources can't be migrated automatically due to Azure policy restrictions in the subscription. These restrictions prevent the migration process from creating the necessary Log Analytics workspace or resource group.

Common policy restrictions include:

- Requiring specific naming conventions
- Enforcing required tags on resources or resource groups
- Restricting allowed regions for resource deployment
- Blocking the creation of new resource groups

These policies are defined and enforced at the management group, subscription, or resource group level. The migration process respects these policies and doesn't override them. If a policy blocks migration, the process stops and doesn't attempt migration again for that resource.

### What to expect

- Microsoft doesn't retry automatic migration for resources blocked by policy.
- Microsoft continues telemetry ingestion into classic resources until July 31, 2025.
- Microsoft keeps existing data available for query after ingestion stops but doesn't collect new telemetry.

### Required actions

To complete the migration:

- [**Manually migrate each Application Insights resource**](/previous-versions/azure/azure-monitor/app/convert-classic-resource) that wasn't migrated automatically.
- **Use a Log Analytics workspace that complies with your organization's policy requirements**, including resource group, tags, location, and naming standards.

If you need help with updating Azure policies, contact your organization's policy administrator.

## Next steps

- Review common questions in the [Managed workspaces FAQ](application-insights-faq.yml#managed-workspaces).
- [Migrate classic resources to workspace-based Application Insights](/previous-versions/azure/azure-monitor/app/convert-classic-resource).
- [Create and configure Application Insights resources](./create-workspace-resource.md).
- [Manage connection strings in Application Insights](./connection-strings.md).
- [Learn how data collection works](./opentelemetry-overview.md).
- [Read the Application Insights overview](./app-insights-overview.md).
