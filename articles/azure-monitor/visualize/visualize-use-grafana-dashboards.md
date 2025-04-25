---
title: Use Grafana dashboards
description: Summary goes here.
ms.topic: conceptual
ms.date: 04/25/2025
---

# Use Grafana with Azure Monitor Dashboards

Summary goes here.

## Prerequisites

-   Running Azure resources that have created data over at least a 15-minute period.
-   Assigned *Monitoring Data Reader* for access to Azure Managed Prometheus (Azure Monitor Workspace).

For more information about RBAC and assigning roles, see [Azure RBAC]().

## Use dashboard templates

The following steps are for using Grafana dashboards that are already available in the Azure portal.

1.  Navigate to **Azure Monitor** in the Azure portal.
1.  Select **Dashboards with Grafana (Preview)**.
1.  Browse the list of available dashboards.
1.  Select a dashboard for example .
1.  Choose a *subscription* and *resource group* where the target resource exists. The dashboard loads based on the dashboard your chose and the selected resources.

## Use dashboards with Azure Kubernetes Service (AKS)

> [!Note]
> The Kubernetes cluster must be onboarded to Azure Managed Prometheus.

1.  Navigate to the AKS cluster you want to work with in the Azure portal.
1.  Select **Dashboards with Grafana (Preview)**.
1.  Select the Kubernetes cluster you want to work with.
1.  Select a dashboard using *Azure Monitor Workspace* as the data source.
1.  To apply filters, select the **Workspace**, **Cluster**, and any additional, needed filters. The dashboard visuals update to reflect selections.

## Use Save as to customize a dashboard

## Create a new Grafana dashboard

1.  Select *\*New Dashboard\** from within the Grafana interface.
1.  Add panels using built-in or code-based query editors.
1.  Choose a supported data source (*Azure Monitor* or *Prometheus*).
1.  Save the dashboard to a *subscription*, *resource group*, and *region*.

## Edit a dashboard

Note

Editing tools and behavior follow standard Grafana open-source controls.

1.  Open an editable dashboard (created or imported).
1.  Select **Edit** to modify panels, queries, and visualizations.

## Import Grafana dashboards using JSON

The following instructions assume that you signed in to your Grafana account in one browser window or tab and, in another window or tab, you signed in to your Azure account, are in the Azure Monitor area of the Azure portal, and selected **Dashboards with Grafana (Preview)**.

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

SEE VIDEO FROM LAST WEEK FOR THESE EDITS.

## Generate and share links to dashboards

SEE VIDEO FROM LAST WEEK FOR THESE EDITS.