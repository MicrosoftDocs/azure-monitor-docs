---
title: Use Azure Monitor Dashboards with Grafana
description: This article explains how to use Azure Monitor dashboards with Grafana. It covers creating, editing, importing, and sharing dashboards for monitoring data.
ms.topic: how-to
ms.reviewer: kayodeprinceMS
ms.date: 08/22/2025
---

# Use Azure Monitor dashboards with Grafana (preview)

> [!IMPORTANT]
> See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability.

This article explains how to use Azure Monitor dashboards with Grafana. It covers creating, editing, importing, and sharing dashboards for monitoring data.

## Prerequisites

- Running Azure resources that have created data over at least a 15-minute period.
- Assigned *Monitoring Reader* for access to Azure Managed Prometheus (Azure Monitor Workspace).

For more information about RBAC and assigning roles, see [Azure RBAC](/azure/role-based-access-control/).

## Use dashboard templates

Azure managed template dashboards are pre-provisioned and automatically updated dashboards for frequently used Azure resources and Azure Kubernetes Services. They help you get started quickly. The following steps are for using these Grafana dashboards that are already available in the Azure portal. Azure managed templates are identified with a tag.

:::image type="content" source="media/visualizations-grafana/azure-managed-templates.png" alt-text="Screenshot of Azure managed template listing the gallery.":::

1.  Navigate to **Azure Monitor** in the Azure portal.
1.  Select **Dashboards with Grafana (Preview)**.
1.  Browse the list of available dashboards in the Azure Monitor or Azure Managed Prometheus listings.
1.  Select a dashboard, for example **Azure | Insights | Storage Accounts** or **Azure | Insights | Key Vaults**. 
1.  Choose a *subscription* and *resource group* where the target resource exists. The dashboard loads based on the dashboard you chose and the selected resources.

## Create a new Grafana dashboard
 
1. Select **New Dashboard** from within the Grafana interface.
1. Create the dashboard by specifying a **subscription**, **resource group**, and **region**.
1. Add a visualization.
1. Choose a supported data source (*Azure Monitor* or *Prometheus*) for the first panel.
1. Add panels using built-in or code-based query editors.

## Save a copy of a dashboard

You can choose **Save As** to save the dashboard to your subscription and make edits without affecting the original dashboard.

1. Open the dashboard.
1. Choose **Save As**.
1. Enter a title in the **Title** field.
1. Choose the subscription for the dashboard from the **Subscription** dropdown list.
1. Choose the resource group from the **Resource Group** dropdown list.
1. Choose the location (region) from the **Location** dropdown list.
1. Select **Save**.
1. Select **Yes** to open the dashboard copy and begin editing.

## Edit a dashboard

> [!NOTE]
> Editing tools and behavior follow standard Grafana open-source controls.

1.  Open an editable dashboard (created or imported).
1.  Select **Edit** to modify panels, queries, and visualizations.

For more details on editing a Grafana dashboard, see the [Grafana documentation](https://grafana.com/docs/grafana/latest/dashboards/build-dashboards/).

## Import Grafana dashboards using JSON

The following instructions assume you signed in to your Azure account, are in the Azure Monitor area of the Azure portal, and selected **Dashboards with Grafana (preview)**.

Using the Grafana website window or tab, navigate to the dashboard you want to import.

1.  Download the JSON file for the dashboard.
1.  Using the Azure portal window or tab, on the Dashboards with Grafana (Preview) screen, select **New** \> **Import**.
1.  Select the JSON file.
1.  Select **Load**.
1.  Enter a name for the dashboard.
1.  Select the **subscription**, **resource group**, and **region**.

## Import from Grafana public gallery

1.  Visit the [Grafana dashboard gallery](https://grafana.com/grafana/dashboards/).
1.  Locate a dashboard using a *JSON file* or *Dashboard ID*.
1.  On the Azure Monitor page in the Azure portal, open **Import** in Azure Monitor dashboards.
1.  Enter the *Dashboard ID* or upload the corresponding *JSON* *file*.
1.  Follow the import steps listed above.

> [!NOTE]
> Only Azure Monitor and Prometheus dashboards using supported data sources can be imported.

## Share links to dashboards

Dashboards that you import or create require RBAC access configuration to share them with specific people or groups.

1. Open the dashboard.
1. Select **Share**. The Share Dashboard pane opens. Copy the link to the dashboard to your clipboard.
1. Select **Manage sharing options** to use the RBAC workflow for granting *view* or *edit* access to users or groups. The **Reader** role is required for viewing the dashboard. **Contributor** is required to edit the dashboard.
1. Paste the link into your preferred communication method to share it with the intended people or groups.

## Use dashboards with Azure Kubernetes Service (AKS)

The Kubernetes cluster must be onboarded to Azure Managed Prometheus.

### Prometheus prerequisites

To query Prometheus metrics from an Azure Monitor workspace with Azure Monitor dashboards with Grafana, you need to do the following: 

1. [Create an Azure Monitor workspace](/azure/azure-monitor/metrics/azure-monitor-workspace-overview). 
1. Ensure that the Azure Monitor workspace is collecting Prometheus metrics from an AKS cluster.
1. Enable Managed Prometheus on an existing AKS cluster (Prometheus only): 
    1. Navigate to your cluster in the Azure portal. 
    1. In the service menu, under Monitoring, select **Insights** > **Monitor Settings**. 
    1. Select the **Enable Prometheus metrics** checkbox only. *You do not need to enable Azure Managed Grafana.*
    1. Select **Advanced settings** if you want to select alternate workspaces or create new ones. 
    1. Select **Configure**. 

> [!NOTE] 
> Azure Managed Grafana is not required to view Prometheus in Azure Monitor dashboards with Grafana. See a comparison of the solutions [here](visualize-grafana-overview.md#solution-comparison). 

### Role assignment
The user must be assigned role that can perform the microsoft.monitor/accounts/read operation on the Azure Monitor workspace.

### Select a dashboard

1. Navigate to the AKS cluster you want to work with in the Azure portal.
1. Select **Dashboards with Grafana (preview)**.
1. Select a dashboard. The dashboard is populated with the Data source and the cluster.

The relevant filters for Data Source and Cluster are pre-populated based on your AKS Cluster. Apply additional filters as needed. The dashboard visuals update to reflect selections.

## Tag a dashboard

Azure Monitor dashboards with Grafana tags are managed using Azure tags. Open-source Grafana dashboard tags remain in the dashboard JSON during import and export but are not used for populating Azure tags.

To add Dashboard tags to a saved dashboard, add or update the Azure tag with the key GrafanaDashboardTags with your tag names using commas to separate entries.

:::image type="content" source="media/visualizations-grafana/dashboards-with-grafana-edit-tags.png" alt-text="Screenshot of tagging interface.":::

Dashboards created or saved from the context of an Azure Kubernetes Service cluster automatically have the Azure tag *GrafanaDashboardResourceType: microsoft.ContainerService/managedClusters* added.  

You can also add this tag *GrafanaDashboardResourceType: microsoft.ContainerService/managedClusters* to a saved dashboard to be able to access and view the dashboard in the context of AKS clusters.

## Related content

- [Azure Monitor Grafana overview](visualize-grafana-overview.md)
- [Use Manged Grafana](visualize-use-managed-grafana-how-to.md)
