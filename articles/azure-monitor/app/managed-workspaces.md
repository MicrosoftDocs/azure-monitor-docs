---
title: Application Insights managed workspaces
description: This article explains automatically created managed workspaces
ms.topic: how-to
ms.date: 03/18/2025
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
- Tags cannot be added to a managed workspace.
- Deletion of the connected Application Insights resource is required to remove managed workspaces. To keep the Application Insights resource, connect it to a different workspace and then delete the managed workspaces.

## Identify managed workspaces

Managed workspaces created by Application Insights follow specific naming conventions.

**managed workspace groups**
- **Name**: `ai_<APPINSIGHTS RESOURCE NAME>_<APPINSIGHTS RESOURCE ID>_managed`
- **Managed by**: The associated Application Insights resource

**Managed Log Analytics workspaces**
- **Name**: `managed-<APPINSIGHTS RESOURCE NAME>-ws`

You can identify the managing resource by checking the **Managed By** property in the Azure portal.

## Removing managed workspaces

Removing a managed workspace requires that it is not longer connected to any other resources or resource groups.  If you want to delete a manage workspace, you must do the following:
1. **Remove the connected workspace-based Application Insights resource**: This can be done by connecting the Application Insights resource to a different Log Analytics workspace or deleting the Application Insights resource.
1. **Delete the resource group**

Once both actions are completed, the managed workspace can be deleted.

## Automatically migrated classic resources

Beginning in April 2025, classic Application Insights resources are automatically migrated to workspace-based resources. As part of the migration:

- The classic Application Insights resource is converted to a workspace-based resource.
- A managed Log Analytics workspace is created and linked to the migrated resource.
- The workspace is placed in a new resource group. This new group doesn't inherit access permissions from the Application Insights resource group. However, users with appropriate permissions can still query telemetry data through the Application Insights resource, due to resource-centric access control.

> [!IMPORTANT]  
> Each migrated classic resource receives its own managed workspace and resource group.  Due to an Azure limit on the number of resource groups allowed in a subscription, the auto-migration process may cause your subscription to reach or come close to that limit and prevent additional resource groups from being created. To prevent this scenario, [migrate your classic resources manually](/previous-versions/azure/azure-monitor/app/convert-classic-resource).

### Limitations of automatic migration

> [!WARNING]
> Classic Application Insights resources that aren't migrated by April 24, 2025, will be disabled, and can't ingest new data. To reenable a resource, convert it to a workspace-based Application Insights resource.

Some classic Application Insights resources can't be migrated until you take other actions. Examples scenarios that will affect your ability to migrate include but are not limited to:

- Using Unicode or non-UTF-8 characters in the Application Insights resource name or resource group name.
- Restricting Log Analytics workspace creation in the subscription.
- Enforcing policies that prevent new resource creation in the subscription.
- If your subscription has a high number of resource groups and/or classic Application Insights resources, there might not be enough remaining resource group quota to fully migrate your subscription. Azure subscriptions are [limited to 980 total resource groups](/azure/azure-resource-manager/management/azure-subscription-service-limits#azure-subscription-limits). 

To prevent service interruptions, resolve these issues and [manually migrate classic Application Insights resources](/previous-versions/azure/azure-monitor/app/convert-classic-resource).

## Next steps

- To review frequently asked questions (FAQ), see [Managed workspaces FAQ](application-insights-faq.yml#managed-workspaces)
- [Migrate to workspace-based Application Insights resources](/previous-versions/azure/azure-monitor/app/convert-classic-resource)
- [Create and configure Application Insights resources](./create-workspace-resource.md)
- [Manage connection strings in Application Insights](./connection-strings.md)
- [Understand data collection basics](./opentelemetry-overview.md)
- [Explore the Application Insights overview](./app-insights-overview.md)

