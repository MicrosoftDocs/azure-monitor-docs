---
title: Application Insights managed workspaces
description: This article explains automatically created managed workspaces
ms.topic: conceptual
ms.date: 03/17/2025
ms.reviewer: cogoodson
---
# Managed workspaces in Application Insights

[Azure Monitor](../fundamentals/overview.md) [Application Insights](./app-insights-overview.md) requires a connection to a [Log Analytics](../logs/log-analytics-overview.md) workspace to store and analyze telemetry data. To simplify deployment, Application Insights automatically creates a managed workspace when you don't specify one during resource creation.

## What is a managed workspace?

A managed workspace is a Log Analytics workspace that Application Insights creates and manages on your behalf. This workspace is used exclusively by the Application Insights resource that created it.

If you create an Application Insights resource without specifying a Log Analytics workspace, Azure automatically creates a managed workspace. If you attempt to create a classic Application Insights resource, Azure instead creates a workspace-based version that uses a managed workspace.



## What happens during managed resource creation?

When Azure creates a managed workspace during Application Insights deployment, the following actions occur:

- It creates the Application Insights resource in the specified subscription and resource group.
- It creates a Log Analytics workspace and links it to the Application Insights resource.
- It creates a new resource group and places the managed workspace in that group.

## Limitations

Managed resources have the following limitations:

- Managed resources support only the Application Insights resource that created them. For example, a managed workspace can't be used for diagnostic settings, custom logs, or another Application Insights instance.
- You can modify workspace settings, such as quotas, but you can't repurpose the workspace for other use cases.
- Managed resources can ony be deleted by deleting the connected Application Insights resource or by connecting the Application Insights resource to a different workspace and then deleting it. 

## Identify managed resources

Managed resources created by Application Insights follow specific naming conventions.

**Managed resource groups**
- **Name**: `ai_<APPINSIGHTS RESOURCE NAME>_<APPINSIGHTS RESOURCE ID>_managed`  
- **Managed by**: The associated Application Insights resource

**Managed Log Analytics workspaces**  
- **Name**: `managed-<APPINSIGHTS RESOURCE NAME>-ws`

You can identify the managing resource by checking the **Managed By** property in the Azure portal.

## Automatically migrated classic resources

Beginning on April 2025, classic Application Insights resources are automatically migrated to workspace-based resources. As part of the migration:

- The classic Application Insights resource is converted to a workspace-based resource.
- A managed Log Analytics workspace is created and linked to the migrated resource.
- The workspace is placed in a new resource group with the same access permissions as the Application Insights resource.

> [!IMPORTANT]  
> Each migrated classic resource receives its own managed workspace. To prevent this scenario, [migrate your classic resources manually](/previous-versions/azure/azure-monitor/app/convert-classic-resource).

### Limitations of automatic migration

 [!WARNING]
> Classic Application Insights resources which are not migrated by April 24, 2025, will be disabled and unable to ingest new data. These resources can be reenabled by converting them to workspace-based Application Insights.

In some cases, a classic Application Insights resource cannot be migrated before other actions are taken. These scenarios include:

- Having unicode/non-UTF-8 characters in the resource name.
- Having a classic Application Insights resource in a subscription that does not allow Log Analytics workspace creation.
- Policies that prevent the creation of new resources in the subscription.

It is important that you address these issues and migrate your classic Application Insights resources manually to prevent service interruptions.


## Frequently asked questions

### Do I need to update scripts or automation that reference classic resources?

No. Existing ARM templates and API calls continue to work. When you attempt to create a classic resource, a workspace-based resource with a managed workspace is created instead.

### Am I notified before my resource is migrated?

No. Notification for individual resource migrations isn't available. To control when and how your resources are migrated, use [manual migration](/previous-versions/azure/azure-monitor/app/convert-classic-resource).

### How long does the migration process take?

Individual migrations usually complete in less than two minutes. The full rollout takes place over several weeks across all regions.

### How can I tell if a resource is migrated?

After migration, the resource links to a Log Analytics workspace on the Overview page. The classic retirement notice is removed, and the retirements workbook no longer lists the resource.

### Will my billing change after migration?

Costs typically remain similar. Workspace-based Application Insights enables cost-saving features and we recommend reviewing [pricing plans](./create-workspace-resource.md#set-the-pricing-plan).

If you're on a legacy billing model, review the [pricing documentation](https://azure.microsoft.com/pricing/details/monitor/) for details.

### Do I lose alerts or availability tests during migration?

No. All alerts, dashboards, and availability tests remain intact and continue to function after migration.

## Next steps

- [Create and configure Application Insights resources](./create-workspace-resource.md)
- [Manage connection strings in Application Insights](./connection-strings.md)
- [Understand data collection basics](./opentelemetry-overview.md)
- [Explore the Application Insights overview](./app-insights-overview.md)

