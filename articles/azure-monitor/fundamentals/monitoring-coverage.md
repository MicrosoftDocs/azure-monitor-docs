---
title: Monitoring coverage in Azure Monitor (preview)
description: Details on the monitoring coverage feature in Azure Monitor, which allows you to identify gaps in your monitoring posture and quickly enable data collection, alerting, and data flow validation at scale.
ms.topic: concept-article
ms.date: 05/29/2026
ai-usage: ai-assisted
---

# Monitoring coverage in Azure Monitor (preview)

Monitoring coverage provides a centralized experience to view, validate, and enable recommended monitoring settings for common Azure resource types. The feature uses [Azure Advisor](/azure/advisor/advisor-overview) recommendations to help identify gaps in your observability posture and quickly enable data collection, recommended alert rules, and data flow validation at scale with minimal configuration.

Capabilities provided by the monitoring coverage feature include:

- Get an overview of monitoring coverage and data flow status across common Azure resource types.
- Identify and apply Azure Advisor observability recommendations at scale, including VM insights, container monitoring, and recommended alert rules for virtual machines and Azure Kubernetes Service.
- Enable recommended monitoring settings for multiple resources from a single, centralized location.
- View detailed information for each resource, including current monitoring configuration, applicable recommendations, data collection rules, data sources, destinations, and Azure Monitor Agent version.
- Run validation checks to detect resource, agent, data collection rule association, network, and data flow issues that can affect monitoring data before they cause data loss.

## Supported resource types

The preview release of monitoring coverage supports Virtual Machines (VMs) and Azure Kubernetes Service (AKS). The experience can also surface supported Kubernetes - Azure Arc recommendations when those resources are included in the selected scope.

## How to access

Open the **Monitor** menu in the Azure portal and select **Monitoring Coverage (preview)** in the **Settings** section. Use the filters at the top of the page to scope the view by subscription, resource type, resource group, location, or other available criteria.

## Overview page

The **Overview** tab summarizes monitoring coverage and data flow status across your selected resources. It helps you identify coverage gaps, find resources whose monitoring data might need attention, and apply recommended monitoring and alerting at scale.

The **Summary** section includes two high-level cards:

| Card | What it shows | How to use it |
|---|---|---|
| **Monitoring Coverage** | Counts for resources with **Enhanced (Recommended)**, **Partial**, and **Basic (Default)** monitoring coverage. | Select **See details** to review the affected resources on the **Monitoring Details** tab. |
| **Data flow status** | Counts for resources that need attention based on validation checks for connectivity, agent configuration, and data routing. | Select **See details** to find resources whose monitoring data flow might be affected. |

The monitoring coverage visualizations distinguish between:

- **Basic monitoring.** Standard monitoring that's enabled by default when the resource is created.
- **Partial monitoring.** Some recommended monitoring is enabled, but one or more recommended configurations are missing.
- **Enhanced monitoring.** Recommended monitoring settings from Microsoft are enabled. These settings provide additional observability and can improve your overall observability posture. Enabling enhanced monitoring might incur additional costs.

The **Monitoring recommendations** table lists observability recommendations that can be applied from monitoring coverage. Recommendations can include enabling Insights and Alerts for common Azure resources. Select **Apply** next to a recommendation to open the enablement page with the relevant resources preselected.

:::image type="content" source="./media/monitoring-coverage/overview.png" lightbox="./media/monitoring-coverage/overview.png" alt-text="Screenshot of Monitoring coverage Overview tab with coverage summary, recommendations, and data flow status.":::

## Enable recommended monitoring at scale

When you select **Apply** for a recommendation, monitoring coverage opens an enablement page for the selected recommendation. The enablement page lists resources included in the operation, lets you configure settings for the recommendation, and provides a **Review + Enable** step before changes are applied.

Currently, only the first 100 resources are included in an enablement operation. Use the filtering options on the **Overview** page to ensure the intended resources are selected.

### Enable VM monitoring for virtual machines

Select **Apply** next to **Enable VM Insights for virtual machines** to configure VM insights for multiple virtual machines. Enabling the recommendation creates or selects data collection rules, associates the selected resources, and deploys the Azure Monitor Agent. Data might take up to 30 minutes to begin flowing, and storage costs might apply depending on data volume.

The **Configure monitoring** step includes:

1. **Select resources.** Review the virtual machines included in the operation and clear any resources that shouldn't be configured.
1. **Review VM Insights recommended settings.** Confirm the recommended Azure Monitor workspace, Log Analytics workspace, and data collection rules that are used for OpenTelemetry metrics and log-based data collection.
1. **Customize monitoring settings, if needed.** Select **Customize monitoring settings** to change the workspace, create a new workspace or DCR, or enable and disable the available collection options.
1. **Review + Enable.** Confirm the selected resources and settings, then select **Enable**.

The recommended VM insights settings can include preview OpenTelemetry metrics sent to an Azure Monitor workspace and classic log-based metrics sent to a Log Analytics workspace. The OpenTelemetry metrics configuration collects performance counters such as filesystem usage, disk usage, disk operation time, disk operations, memory usage, network I/O, CPU time, network dropped, network errors, and system uptime.

:::image type="content" source="./media/monitoring-coverage/enablement.png" lightbox="./media/monitoring-coverage/enablement.png" alt-text="Screenshot of Configure monitoring for VM Insights with selected resources and recommended settings.":::

<!-- TODO: Add screenshot - Customize VM Insights settings for OpenTelemetry metrics, log-based metrics, workspaces, and DCRs. -->

<!-- TODO: Add screenshot - Review and enable VM Insights settings before applying changes. -->

### Enable recommended alert rules

Monitoring coverage can also recommend alert rules for resources that are missing recommended alert coverage. Select **Apply** next to **Enable VM Recommended Alerts** or **Enable AKS Recommended Alerts** to configure recommended alert rules from a centralized flow. Alert coverage might vary by resource based on available telemetry, and creating alert rules might incur costs.

For virtual machines, the **Enable VM Recommended Alerts** page creates alert rules for supported signals and notifies you when potential issues are detected. Some VMs might already have alerts configured. New rules don't duplicate existing alerts.

For VM recommended alerts, choose one of the following scopes:

| Scope | Behavior | When to use it |
|---|---|---|
| **Entire subscription(s)** | Applies recommended alerts to all current and future VMs in the selected subscriptions. One alert rule per subscription is created. This option requires a user-assigned managed identity and the **Monitoring Contributor** role. | Use for broad coverage across a subscription and to include future VMs automatically. |
| **Selected resources** | Applies recommended alerts only to selected VMs. One alert rule per VM is created. | Use for granular control when you want to enable alerts for a specific set of resources. |

When subscription scope is selected, you can skip host metric alert rules and create guest OS alert rules only for VMs that have Azure Monitor Agent with OpenTelemetry metrics collection enabled. This helps avoid duplicate alerting on VMs covered by guest OS alerts but leaves VMs without OpenTelemetry metrics uncovered.

The recommended VM alert settings include host metric alert rules, a VM availability alert rule, and preview guest OS alert rules collected through OpenTelemetry when supported telemetry is available. Select **Edit** in the **Alerts** section to select alert rules, adjust thresholds, and configure notification options such as email, Azure Resource Manager role notifications, Azure mobile app notifications, or an existing action group.

The **Review + Enable** tab summarizes the selected scope, selected resources, alert rules, and notification settings. After the alerts are created, you can customize them from the **Alerts** page.

<!-- TODO: Add screenshot - Configure VM recommended alerts with subscription-level scope selected. -->

<!-- TODO: Add screenshot - Configure VM recommended alerts for selected resources. -->

<!-- TODO: Add screenshot - Customize recommended alert rules, thresholds, and notification options. -->

<!-- TODO: Add screenshot - Review and enable VM recommended alerts. -->

### Enable AKS recommended alerts

When AKS resources have alert coverage gaps, the **Overview** tab can show an **Enable AKS Recommended Alerts** recommendation. Select **Apply** to configure recommended alert rules for the affected Kubernetes services. The enablement flow follows the same pattern as other monitoring coverage recommendations: select the affected scope or resources, review the recommended alert settings, customize the settings when available, and then use **Review + Enable** to create the alert rules.

Available AKS alert rules depend on supported signals and telemetry for the selected clusters. After alert rules are created, manage and customize them from the **Alerts** page.

### Data flow status on the Overview page

The **Data flow status** section validates whether monitoring data can reach its configured destination. Validation checks help identify issues in resource configuration, agent state, data collection rule associations, network connectivity, and data flows before they cause monitoring data loss.

The section includes:

- **Data flow status across resources**, which shows how many resources need attention, passed initial checks, or aren't configured for validation.
- **Top resources that need attention**, which lists the resources with detected issues so you can open the resource-specific details directly.

## Monitoring Details page

The **Monitoring Details** tab provides a resource-centric view of monitoring coverage and data flow status. Use this page to find individual resources that need recommended monitoring, have partial coverage, or have data flow validation issues.

The list can be filtered or grouped by available resource properties. Key columns include **Monitoring coverage** and **Data flow status**. Select a value in either column to open the **Monitoring details** pane for the resource.

| Column | Description |
|---|---|
| **Monitoring coverage** | Shows whether the resource has **Basic**, **Partial**, or **Enhanced** monitoring. Select the value to view which recommended monitoring configurations are enabled, missing, or associated with the resource. |
| **Data flow status** | Shows the most recent validation status for monitoring data flow, such as **Needs attention** or **Passed initial checks**. Select the value to view validation results and recommended actions. |
| **Resource Type**, **Subscription**, **Resource Group**, **Location** | Provides context for filtering, grouping, and triaging resources at scale. |

:::image type="content" source="./media/monitoring-coverage/details.png" lightbox="./media/monitoring-coverage/details.png" alt-text="Screenshot of Monitoring Details tab with resource-level monitoring coverage and data flow status.":::

### Monitoring coverage details for a resource

The **Monitoring coverage details** tab summarizes monitoring for the selected resource. The **Overview** section shows the current monitoring coverage, data flow status, and last updated time. The **Configuration summary** shows the number of data collection rules, data sources, destinations, and the installed agent and version.

The **Configuration details** section shows the monitoring configurations applied to the resource, including data collection configurations such as:

- VM insights status and an action to enable VM insights when it isn't configured.
- Recommended alert rules, including enabled rules and notification configuration, with an action to manage alert rules.
- Data collection rules associated with the resource, including data sources and destinations, with an action to associate the resource to additional DCRs.

<!-- TODO: Add screenshot - Resource monitoring coverage details with configuration summary, VM insights, recommended alerts, and DCRs. -->

### Data flow status for a resource

The **Data flow status** tab shows validation results for the selected resource. Validation checks evaluate a set of configurations that commonly cause data flow issues. Rerun validation checks after applying any fix to confirm progress.

The default view shows issues that need attention at the top and then lists all validation checks. For each issue, the page provides a recommended action, such as installing the agent or opening the resource for remediation.

Validation checks are grouped by areas such as:

- Resource
- Data collection rule associations
- Network
- Data flows

Fix detected issues in numerical order, then select **Run validation checks** to update the status. Use the **List** and **Diagram** views to switch between validation result layouts.

> [!NOTE]
> Passing all current validations doesn't necessarily mean there's nothing wrong with the data flow's end-to-end configuration. Additional validations are added in the future.

<!-- TODO: Add screenshot - Resource data flow status with validation checks, recommended action, and last checked time. -->

## Important notes

- Monitoring coverage is in preview. Feature availability, supported recommendations, and enablement flows can change before general availability.
- Enablement operations include up to 100 resources at a time.
- Enhanced monitoring, data collection, workspace ingestion, and alert rules might incur additional costs.
- Some enablement actions require sufficient permissions on the selected subscription or resources. Subscription-level VM alerting requires a user-assigned managed identity and the **Monitoring Contributor** role.
- Data flow status reflects the latest validation check. Rerun validation checks after making changes to verify that issues are resolved.
