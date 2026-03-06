---
title: Copy an Azure Monitor dashboard to Azure Managed Grafana
description: Learn how to copy a saved dashboard from Azure Monitor dashboards with Grafana to an existing or new Azure Managed Grafana instance.
ms.topic: how-to
ms.reviewer: kayodeprinceMS
ms.date: 03/04/2026
ai-usage: ai-assisted
---

# Copy an Azure Monitor dashboard to Azure Managed Grafana

In this article, you learn how to copy a saved Azure Monitor dashboard with Grafana to either a new or existing Azure Managed Grafana workspace. By following this copy process, your dashboard panels, queries, and layout are preserved, so you can move to Azure Managed Grafana without recreating them.

Migrate your dashboards to Azure Managed Grafana when you need capabilities that Azure Monitor dashboards with Grafana doesn't support, such as alerts, scheduled reports, external data sources, or private networking. For a full list, see [Limitations](visualize-grafana-overview.md#limitations).

> [!NOTE]
> This guide applies to user-saved dashboards. Azure-managed template dashboards can't be copied directly. To copy a template dashboard:  
> 1. Save it so it becomes a user-saved dashboard.
> 1. Copy the saved version. 
> 
> For more information, see [Save a copy of a dashboard](visualize-use-grafana-dashboards.md#save-a-copy-of-a-dashboard).

## Prerequisites

- Review [known limitations](#known-behaviors-and-limitations) before starting.
- A user-saved dashboard in Azure Monitor dashboards with Grafana.
- The **Grafana Editor** or **Grafana Admin** role on the target Azure Managed Grafana instance. For more information, see [Azure RBAC](/azure/role-based-access-control/overview).

## Copy to an existing Azure Managed Grafana instance

1. Open a user-saved dashboard in **Dashboards with Grafana**.
1. Select **Copy to Managed Grafana** in the toolbar. A side pane opens.

    :::image type="content" source="./media/visualizations-grafana/copy-to-managed-grafana-side-pane.png" alt-text="Screenshot of the Copy to Managed Grafana side pane.":::

1. In the side pane, select an existing Azure Managed Grafana workspace from the **Azure Managed Grafana** dropdown list. The current user must have the **Grafana Editor** or **Grafana Admin** role on the selected instance.
1. Select **Copy**.
1. The deployment starts. Track progress in the Azure portal **Notifications**.
1. When the deployment is complete, select the link in the notification to open the copied dashboard in the Grafana instance.

## Copy to a new Azure Managed Grafana instance

1. Open a user-saved dashboard in **Dashboards with Grafana**.
1. Select **Copy to Managed Grafana** in the toolbar. A side pane opens.
1. In the side pane, select **Create new** to open the creation pane.

    :::image type="content" source="./media/visualizations-grafana/copy-to-managed-grafana-create-new-workspace.png" alt-text="Screenshot of the Create new Azure Managed Grafana workspace pane.":::

1. Configure the required details for the new Azure Managed Grafana workspace:
    - **Workspace name** - Enter a name for the new workspace.
    - **Region** - Select the Azure region for the workspace.
1. Select **Create**. The creation pane closes and the new workspace name is populated in the **Azure Managed Grafana** field on the side pane.

    > [!NOTE]
    > Selecting **Create** in the creation pane saves the configuration but doesn't provision the new Azure Managed Grafana workspace yet. Provisioning begins when you select **Copy** in the next step.

1. Select **Copy** on the side pane. The deployment starts. Two deployment tasks appear in the Azure portal **Notifications**:
    - **Azure Managed Grafana workspace provisioning** - Includes a link to the new Azure Managed Grafana resource after completion.
    - **Dashboard copy** - Includes a direct link to the copied Grafana dashboard after completion.

1. When both deployments are complete, select the dashboard link in the notification to open the copied dashboard in the new Grafana instance.

## Known behaviors and limitations

Review the following known behaviors and limitations before you copy a dashboard to Azure Managed Grafana.

### Azure managed template dashboards can't be copied directly

The **Copy to Managed Grafana** button isn't available on Azure managed template dashboards because they're provisioned static content and not ARM resources. Save the dashboard first to create a user-saved copy, and then copy that version. For more information, see [Save a copy of a dashboard](visualize-use-grafana-dashboards.md#save-a-copy-of-a-dashboard).

### Data sources aren't migrated

The copy process doesn't create, configure, or map data sources in the destination instance. Only the Azure Monitor data source works out of the box. Other data sources, such as Azure Data Explorer or Azure Monitor managed service for Prometheus, must be manually configured in the target Azure Managed Grafana instance after the copy.

> [!TIP]
> Azure Monitor dashboards with Grafana uses the current user's identity to authenticate to data sources. When configuring data sources in the destination instance, consider selecting **Current User** as the authentication method so the dashboard behaves the same way as the original.

### Destination folder can't be selected

The copied dashboard is placed in the root folder of the Grafana instance. If a dashboard with the same identity already exists in a different folder, the copy is placed in that folder instead.

### Existing dashboards might be overwritten

> [!CAUTION]
> If the target instance already contains a dashboard with the same identity, the copy operation overwrites it without prompting for confirmation. Verify that no dashboard you want to keep uses the same identity before you start the copy.

## Next steps

- [Use Azure Managed Grafana](visualize-use-managed-grafana-how-to.md)
- [How to manage data sources in Azure Managed Grafana](/azure/managed-grafana/how-to-data-source-plugins-managed-identity)
