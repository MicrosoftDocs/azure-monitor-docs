---
title: Use Grafana dashboards
description: This article provides guidance on using Grafana dashboards with Azure Monitor. It covers prerequisites, such as having Azure resources and appropriate RBAC roles, and explains how to use pre-existing dashboard templates, create new dashboards, and customize or edit dashboards. It also details importing dashboards from JSON files or the Grafana public gallery, saving copies of dashboards, and sharing them with others using RBAC configurations.
ms.topic: conceptual
ms.date: 04/25/2025
---

# Use Grafana with Azure Monitor Dashboards

This article provides guidance on using Grafana dashboards with Azure Monitor. It covers prerequisites, such as having Azure resources and appropriate RBAC roles, and explains how to use pre-existing dashboard templates, create new dashboards, and customize or edit dashboards. It also details importing dashboards from JSON files or the Grafana public gallery, saving copies of dashboards, and sharing them with others using RBAC configurations.

## Prerequisites

- Running Azure resources that have created data over at least a 15-minute period.
- Assigned *Monitoring Data Reader* for access to Azure Managed Prometheus (Azure Monitor Workspace).

For more information about RBAC and assigning roles, see [Azure RBAC]().

## Use dashboard templates

The following steps are for using Grafana dashboards that are already available in the Azure portal.

1.  Navigate to **Azure Monitor** in the Azure portal.
1.  Select **Dashboards with Grafana (Preview)**.
1.  Browse the list of available dashboards.
1.  Select a dashboard for example .
1.  Choose a *subscription* and *resource group* where the target resource exists. The dashboard loads based on the dashboard your chose and the selected resources.

## Create a new Grafana dashboard

1.  Select **New Dashboard** from within the Grafana interface.
1.  Add panels using built-in or code-based query editors.
1.  Choose a supported data source (*Azure Monitor* or *Prometheus*).
1.  Save the dashboard to a *subscription*, *resource group*, and *region*.

## Tag a dashboard

Azure Monitor dashboards with Grafana tags are managed using Azure tags. Open-source Grafana dashboard tags remain in the dashboard JSON during import and export but are not used for populating Azure tags.

**THIS NEEDS TO BE DONE IN STEPS LIKE THE REST OF THE DOC.**
To add Dashboard tags to a saved dashboard, add or update the Azure tag with the key GrafanaDashboardTags with your tag names using commas to separate entries.

Dashboards created or saved from the context of an Azure Kubernetes Service cluster automatically have the Azure tag GrafanaDashboardResourceType: microsoft.ContainerService/managedClusters added.  

You can also add this tag GrafanaDashboardResourceType: microsoft.ContainerService/managedClusters to a saved dashboard to be able to access and view the dashboard in the context of AKS clusters.

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

## Import Grafana dashboards using JSON

The following instructions assume that you signed in to your Grafana account in one browser window or tab and, in another window or tab, you signed in to your Azure account, are in the Azure Monitor area of the Azure portal, and selected **Dashboards with Grafana (preview)**.

Using the Grafana website window or tab, navigate to the dashboard you want to import.

1.  Download the JSON file for the dashboard.
1.  Using the Azure portal window or tab, on the Dashboards with Grafana (Preview) screen, select **New** \> **Import**.
1.  Select the JSON file.
1.  Select **Load**.
1.  Enter a name for the dashboard.
1.  Select the **subscription**, **resource group**, and **region**.

## Import Grafana dashboard to Prometheus

Follow the above steps then:

1.  For Prometheus dashboards, select the *Prometheus data source*.
1.  Select **Import** to complete the process.

## Import from Grafana public gallery

1.  Visit the [Grafana dashboard gallery](https://grafana.com/grafana/dashboards/).
1.  Locate a dashboard using a *JSON file* or *Dashboard ID*.
1.  On the Azure Monitor page in the Azure portal, open **Import** in Azure Monitor dashboards.
1.  Enter the *Dashboard ID* or upload the corresponding *JSON* *file*.
1.  Follow the import steps listed above.

> [!NOTE]
> Only dashboards using supported data sources can be imported.

## Share links to dashboards

Dashboards that you import or create require RBAC access configuration to share them with specific people or groups.

1. Open the dashboard.
1. Select **Share**. The Sare Dashboard pane opens. Copy the link to the dashboard to your clipboard.
1. Select **Manage sharing options** to use the RBAC workflow for sharing.
1. Paste the link into your preferred communication method to share it with the intended people or groups.

## Use dashboards with Azure Kubernetes Service (AKS)

> [!Note]
> The Kubernetes cluster must be onboarded to Azure Managed Prometheus.

1.  Navigate to the AKS cluster you want to work with in the Azure portal.
1.  Select **Dashboards with Grafana (Preview)**.
1.  Select the Kubernetes cluster you want to work with.
1.  Select a dashboard using *Azure Monitor Workspace* as the data source.
1.  To apply filters, select the **Workspace**, **Cluster**, and any additional, needed filters. The dashboard visuals update to reflect selections.

## Related content

- [Azure Monitor Grafana overview](visualize-grafana-overview.md)
- [Use Manged Grafana](visualize-use-managed-grafana-how-to.md)
