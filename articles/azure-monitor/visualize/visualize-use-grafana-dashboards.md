---
title: Use Azure Monitor Dashboards with Grafana
description: This article explains how to use Azure Monitor dashboards with Grafana.
ms.topic: how-to
ms.reviewer: kayodeprinceMS
ms.date: 11/03/2025
---

# Use Azure Monitor dashboards with Grafana

This article explains how to use Azure Monitor dashboards with Grafana.

## Supported data sources

Dashboards with Grafana supports the following data sources:

- Azure Monitor - Metrics, Logs, Traces
- Azure Data Explorer
- Azure Monitor managed service for Prometheus
- Azure Resource Graph

 
## Prerequisites

- Running Azure resources that have created data over at least a 15-minute period.
- Assigned *Monitoring Reader* for access to Azure Managed Prometheus (Azure Monitor Workspace).

For more information about RBAC and assigning roles, see [Azure RBAC](/azure/role-based-access-control/).

## Use dashboard templates

Azure managed template dashboards are pre-provisioned and automatically updated dashboards for frequently used Azure resources and Azure Kubernetes Services. They help you get started quickly. The following steps are for using these Grafana dashboards that are already available in the Azure portal. Azure managed templates are identified with a tag.

:::image type="content" source="./media/visualizations-grafana/azure-managed-templates.png" alt-text="Screenshot of Azure managed template listing the gallery.":::

1.  Navigate to **Azure Monitor** in the Azure portal.
1.  Select **Dashboards with Grafana**.
1.  Browse the list of available dashboards in the Azure Monitor or Azure Managed Prometheus listings.
1.  Select a dashboard, for example **Azure | Insights | Storage Accounts** or **Azure | Insights | Key Vaults**. 
1.  Choose a *subscription* and *resource group* where the target resource exists. The dashboard loads based on the dashboard you chose and the selected resources.

Other Azure resources with built-in dashboard templates include the following. Access  from the Monitoring > Dashboards with Grafana menu item for the following resources:

- Azure Kubernetes
- AKS Automatic
- AKS Arc
- App Insights
- SQL DB
- Azure Container Apps
- Azure Monitor Workspace

## Create a new Grafana dashboard
 
1. Select **New** > **New Dashboard** from within the Grafana interface.
2. Select **Add visualization**.
3. Choose a supported data source (*Azure Monitor*, *Azure Data Explorer* or *Prometheus*) for the first panel.
6. Add panels using built-in or code-based query editors.

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

The following instructions assume you signed in to your Azure account, are in the Azure Monitor area of the Azure portal, and selected **Dashboards with Grafana**.

Using the Grafana website window or tab, navigate to the dashboard you want to import.

1.  Download the JSON file for the dashboard.
1.  Using the Azure portal window or tab, on the Dashboards with Grafana screen, select **New** \> **Import**.
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

## Use Explore to copy and edit a query and graph

You can copy and edit a query and graph without breaking or changing the original query with the Explore feature.

1. Select the resource you want to monitor, for example an AKS cluster.
1. Select *Dashboards with Grafana*. A list of available dashboards appears.
1.	Select a dashboard, for example the *Kubernetes | Compute Resources | Cluster dashboard*.
1.	Select the **vertical ellipsis** in one of the graphs in the dashboard, then select **Explore**. The Explore screen appears. A copy of query of the graph is copied (populated) to the new screen for you to work with.
1. You can now edit the copied query without breaking or changing the original query.

## Save the new graph to a dashboard
When you are happy with the results of the changes you made to the copied query and the graph, you can save it to a dashboard. 

1. Select **Add to dashboard**. The Add Panel to Dashboard screen appears.
1. From the **Subscription dropdown list**, select the subscription you want to work with.
1. From the **Resource groups dropdown list**, select the resource group you want to work with. A list of dashboard for that resource group appears.
1. Select the dashboard from the list. The dashboard screen appears with the new query and graph added to it. Alternatively, you can create a new dashboard by selecting **New dashboard**.

## Use explore from the dashboard gallery

1.	From the resource page in the Azure portal, select **Dashboards with Grafana**. The explore screen appears without data. 
1.	Select **Select a resource** and then select a resource from the list of resources in the subscription you are currently working with.
1.	Select the **metric**, **aggregation**, **time grain**, **dimensions**, etc for the query and graph.
1.	When you are happy with the query and the graph, select **Add to dashboard** to save it to a dashboard or create a new dashboard by selecting **New dashboard**.

For more information about Grafana Explore, see the [Grafana documentation](https://grafana.com/docs/grafana/latest/explore/).

## Share links to dashboards

Dashboards that you import or create require RBAC access configuration to share them with specific people or groups.

1. Open the dashboard.
1. Select **Share**. The Share Dashboard pane opens. Copy the link to the dashboard to your clipboard.
1. Review sharing options:
    - **People with this link can edit** - Enabling this option creates a link that opens the dashboard in the standard view and provides the ability to edit for users with the required dashboard write permissions. Disabling this option creates a link that opens the dashboard in a view-only mode for all users.
    - **Lock time range** - If the dashboard is using a relative time range e.g. *now-30m to now*, enabling this option converts the time range in the link to an absolute time range. This enables link recipients to view the same absolute time range as used when shared.
    - **Keep variables** - If the dashboard includes variables, enabling this option retains the current values of the variables and includes them in the generated link.
1. Select **Manage sharing options** to use the RBAC workflow for granting *view* or *edit* access to users or groups. The **Reader** role is required for viewing the dashboard. **Contributor** is required to edit the dashboard. The link recipient will also need access to any data source used in the content of this Grafana dashboard. **Monitoring Reader** role is required for Azure Monitor data and **Monitoring Data Reader** is required for Prometheus data.
> [!NOTE]
> 'Microsoft.Dashboard/dashboard/read' and 'Microsoft.Dashboard/dashboard/write' can also be used to assign permissions with more fine-grained control.
1.	Copy the link to the dashboard to your clipboard.
1. Paste the link into your preferred communication method to share it.

## Tag a dashboard

Azure Monitor dashboards with Grafana tags are managed using Azure tags. Open-source Grafana dashboard tags remain in the dashboard JSON during import and export but are not used for populating Azure tags.

To add Dashboard tags to a saved dashboard, add or update the Azure tag with the key GrafanaDashboardTags with your tag names using commas to separate entries.

:::image type="content" source="./media/visualizations-grafana/dashboards-with-grafana-edit-tags.png" alt-text="Screenshot of tagging interface.":::

Dashboards created or saved from the context of an Azure Kubernetes Service cluster automatically have the Azure tag *GrafanaDashboardResourceType: microsoft.ContainerService/managedClusters* added.  

You can also add this tag *GrafanaDashboardResourceType: microsoft.ContainerService/managedClusters* to a saved dashboard to be able to access and view the dashboard in the context of AKS clusters.

## Export JSON

You can export a dashboard as JSON.

1. In the dashboard screen, select **Export** then **JSON**.
1. Save the file.

## Export a dashboard ARM template

You can export a dashboard as an ARM template that contains the JSON for the dashboard.

1. In the dashboard screen, select **Export** then **Export as ARM template**.
1. Select **Download** and save the file.

## Related content

- [Azure Monitor Grafana overview](visualize-grafana-overview.md)
- [Use Dashboards with Grafana with Azure Data Explorer](visualize-use-grafana-dashboards-azure-data-explorer.md)
- [Use Dashboards with Grafana with Azure Kubernetes Service](visualize-use-grafana-dashboards-azure-kubernetes-service.md)
- [Use Managed Grafana](visualize-use-managed-grafana-how-to.md)
