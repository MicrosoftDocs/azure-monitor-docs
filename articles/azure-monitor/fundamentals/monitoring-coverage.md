---
title: Monitoring coverage in Azure Monitor
description: Use monitoring coverage in Azure Monitor to identify monitoring gaps, enable infrastructure monitoring and platform telemetry collection, configure alerts, and validate data flow at scale.
ms.topic: concept-article
ms.date: 10/27/2026
ms.author: shseth
ai-usage: ai-assisted
---

# Monitoring coverage in Azure Monitor

Monitoring coverage provides a centralized experience to view, validate, and enable recommended monitoring settings for common Azure resource types. The feature uses [Azure Advisor](/azure/advisor/advisor-overview) recommendations to help identify gaps in your observability posture and quickly enable data collection, recommended alert rules, and data flow validation at scale with minimal configuration. Review infrastructure monitoring and platform telemetry together, then configure the capabilities your resources need.

Capabilities provided by the monitoring coverage feature include:

- Get an overview of infrastructure coverage, platform telemetry collection, and data flow status across common Azure resource types.
- Identify and apply Azure Advisor observability recommendations at scale, including VM insights, container monitoring, and recommended alert rules for virtual machines and Azure Kubernetes Service.
- Enable recommended monitoring settings for multiple resources from a single, centralized location.
- Configure export of supported platform metrics and collection of resource logs through data collection rules (DCRs), diagnostic settings, or both.
- View detailed information for each resource, including current monitoring configuration, applicable recommendations, data collection rules, data sources, destinations, and Azure Monitor Agent version.
- Run validation checks to detect resource, agent, data collection rule association, network, and data flow issues that can affect monitoring data before they cause data loss.

## Supported resource types

Available recommendations and configuration options depend on resource type, existing monitoring, and the selected scope.

| Resource category | Capabilities in monitoring coverage |
|---|---|
| Virtual machines and virtual machine scale sets | Infrastructure coverage and resource-level details. VM insights and recommended VM alerts are available for supported resources and signals. |
| Azure Kubernetes Service (AKS) clusters | Infrastructure coverage, collection of supported container logs and Prometheus metrics, and recommended AKS alerts. |
| Supported Azure Arc-enabled Kubernetes clusters | Infrastructure coverage and supported Kubernetes - Azure Arc recommendations. Collection options depend on the cluster and supported capabilities. |
| Supported platform telemetry resources | Collection coverage and at-scale configuration for platform metrics and resource logs. Examples include storage accounts, key vaults, and supported application and networking resources. Available signals and routes vary by type and region. |

Not every resource supports every workflow. Use the **Resource types** filter and the enablement page to inspect the supported choices for your scope. A resource can appear in both infrastructure and platform summaries, so their counts aren't necessarily additive.

## Prerequisites

To review coverage, you need access to the Azure portal and read access to the subscriptions and resources in scope. To change monitoring, you also need permissions for the selected workflow:

- For infrastructure collection, ensure you can configure the selected resources, agent or monitoring extensions, workspaces, DCRs, and associations required by the plan.
- For alerting, ensure you can create the selected alert rules and configure the required action groups and identity. Subscription-level VM alerts require a user-assigned managed identity and the **Monitoring Contributor** role.
- For platform telemetry, review the [platform telemetry prerequisites](#platform-telemetry-prerequisites). These requirements don't apply merely to viewing monitoring coverage.

Data collection and destination services can incur charges. Review [Azure Monitor pricing](https://azure.microsoft.com/pricing/details/monitor/) and the pricing for your selected destination before you enable collection.

## How to access

Open the **Monitor** menu in the [Azure portal](https://portal.azure.com/) and select **Monitoring Coverage** in the **Settings** section. Use the filters at the top of the page to scope the view by subscription, resource type, resource group, location, or tags.

## Overview page

The **Overview** tab summarizes monitoring coverage and data flow status across your selected resources. It helps you identify coverage gaps, find resources whose monitoring data might need attention, and apply recommended monitoring and alerting at scale.

The **Summary** section includes three high-level cards:

| Card | What it shows | How to use it |
|---|---|---|
| **Infrastructure coverage** | Counts for infrastructure resources with **Enhanced (Recommended)**, **Partial**, and **Basic (Default)** monitoring coverage. | Select **See details** to review the affected resources on the **Monitoring Details** tab. |
| **Platform telemetry coverage** | Counts of supported resources with **Collected** or **Not collected** platform telemetry. | Review coverage by resource type and select **See details** to inspect collection settings. |
| **Data flow status** | Counts for resources that need attention based on validation checks for connectivity, agent configuration, and data routing. | Select **See details** to find resources whose monitoring data flow might be affected. |

The infrastructure coverage visualizations distinguish between:

- **Basic monitoring.** Standard monitoring that's enabled by default when the resource is created.
- **Partial monitoring.** Some recommended monitoring is enabled, but one or more recommended configurations are missing.
- **Enhanced monitoring.** Recommended monitoring settings from Microsoft are enabled. These settings provide additional observability and can improve your overall observability posture. Enabling enhanced monitoring might incur additional costs.

Infrastructure coverage measures whether the recommended configuration is present, not whether a resource is healthy. Enhanced coverage doesn't guarantee successful ingestion or the absence of operational issues.

The **Monitoring recommendations** table lists observability recommendations that can be applied from monitoring coverage. Recommendations can include enabling Insights and Alerts for common Azure resources. Select **Apply** next to a recommendation to open the enablement page with the relevant resources preselected.

:::image type="content" source="./media/monitoring-coverage/overview.png" lightbox="./media/monitoring-coverage/overview.png" alt-text="Screenshot of the Overview tab with infrastructure coverage, platform telemetry coverage, data flow status, and recommendations.":::

### Platform telemetry coverage (preview)

Platform telemetry functionality in monitoring coverage is in preview and is provided under the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).

Platform telemetry includes:

- **Platform metrics**, which Azure collects automatically for supported resources. You can view these metrics in metrics explorer without configuring export. This workflow configures export to additional destinations.
- **Platform logs**, also called resource logs, which provide insight into operations performed within an Azure resource. Collection requires a configured route.

Depending on the resource type and signal, monitoring coverage can use a platform telemetry DCR, a diagnostic setting, or both for different signals. The workflow shows the planned mechanism before it makes changes.

A resource is shown as **Collected** when it has an applicable platform telemetry DCR association with a matching signal stream, or a diagnostic setting with at least one enabled metric or log category. Collected means that at least one supported signal has configured collection, not that every available metric and log is collected. Open the resource details to inspect the mechanisms and destinations.

Coverage represents configuration state. It doesn't guarantee that data has arrived at the destination. **Not collected** means no export configuration was detected; it doesn't mean that Azure's default platform metrics are unavailable.

Coverage initially reflects DCR configuration and is refined while diagnostic settings are checked. Wait for **Checking diagnostic settings** to finish before interpreting the totals. Select **See all** to inspect additional resource types, or **See details** to open **Monitoring Details**.

Monitoring coverage evaluates up to 5,000 resources for platform telemetry coverage. If the selected scope is truncated, narrow the scope filters before treating the result as a complete inventory. Supported resource types, signals, and collection routes can vary by region; the experience resolves the available choices when you open it.

## Enable recommended monitoring at scale

When you select **Apply** for a recommendation, monitoring coverage opens an enablement page for the selected recommendation. The enablement page lists resources included in the operation, lets you configure settings for the recommendation, and provides a **Review + Enable** step before changes are applied.

Resource-selection enablement operations include only the first 100 resolved resources. Use the filtering options on the **Overview** page to target the intended batch, and repeat for additional batches. This limit doesn't mean that subscription-level VM alert rules cover only the displayed VMs: that alerting mode can include eligible current and future VMs in the selected subscriptions.

### Enable VM monitoring for virtual machines

Select **Apply** next to **Enable VM Insights for virtual machines** to configure VM insights for multiple virtual machines. Enabling the recommendation creates or selects data collection rules, associates the selected resources, and deploys the Azure Monitor Agent. Data might take up to 30 minutes to begin flowing, and storage costs might apply depending on data volume.

The **Configure monitoring** step includes:

1. **Select resources.** Review the virtual machines included in the operation and clear any resources that shouldn't be configured.
1. **Review VM Insights recommended settings.** Confirm the recommended Azure Monitor workspace, Log Analytics workspace, and data collection rules that are used for OpenTelemetry metrics and log-based data collection.
1. **Customize monitoring settings, if needed.** Select **Customize monitoring settings** to change the workspace, create a new workspace or DCR, or enable and disable the available collection options.
1. **Review + Enable.** Confirm the selected resources and settings, then select **Enable**.

The recommended VM insights settings can include OpenTelemetry metrics sent to an Azure Monitor workspace and classic log-based metrics sent to a Log Analytics workspace. The OpenTelemetry metrics configuration collects performance counters such as filesystem usage, disk usage, disk operation time, disk operations, memory usage, network I/O, CPU time, network dropped, network errors, and system uptime.

:::image type="content" source="./media/monitoring-coverage/vm-insights-configure.png" lightbox="./media/monitoring-coverage/vm-insights-configure.png" alt-text="Screenshot of Configure monitoring for VM Insights with selected resources and recommended settings." border="true":::

:::image type="content" source="./media/monitoring-coverage/vm-insights-customize.png" lightbox="./media/monitoring-coverage/vm-insights-customize.png" alt-text="Screenshot of customize VM Insights settings for OpenTelemetry metrics, log-based metrics, workspaces, and DCRs." border="true":::

:::image type="content" source="./media/monitoring-coverage/vm-insights-review.png" lightbox="./media/monitoring-coverage/vm-insights-review.png" alt-text="Screenshot of review and enable VM Insights settings before applying changes." border="true":::

### Enable data collection for AKS clusters

Use the container-monitoring recommendation to configure supported collection capabilities for AKS clusters. Supported Arc-enabled Kubernetes clusters can have a corresponding recommendation with different available options.

1. Select **Apply** beside the applicable container-monitoring recommendation.
1. Review the selected clusters and their recommended settings.
1. Inspect the available **Prometheus metrics** and **Container logs** settings, including the Azure Monitor workspace, Log Analytics workspace, and DCRs. Customize the available options as needed.
1. Use **Review + Enable** to confirm the plan, then select **Enable**. Review deployment results for any clusters that couldn't be configured.

Collection and alerting are separate workflows. To configure notifications for AKS clusters, use [Enable AKS recommended alerts](#enable-aks-recommended-alerts).

### Enable recommended alert rules

Monitoring coverage can also recommend alert rules for resources that are missing recommended alert coverage. Select **Apply** next to **Enable VM Recommended Alerts** or **Enable AKS Recommended Alerts** to configure recommended alert rules from a centralized flow. Alert coverage might vary by resource based on available telemetry, and creating alert rules might incur costs.

For virtual machines, the **Enable VM Recommended Alerts** page creates alert rules for supported signals and notifies you when potential issues are detected. Review existing alerting and any exclusions shown by the workflow before enabling new rules.

For VM recommended alerts, choose one of the following scopes:

| Scope | Behavior | When to use it |
|---|---|---|
| **Entire subscription(s)** | Uses subscription-scoped rules to cover eligible current and future VMs in the selected subscriptions. Requires a user-assigned managed identity and the **Monitoring Contributor** role. Review signal-specific eligibility and exclusions. | Use for broad coverage across a subscription and to include future VMs automatically. |
| **Selected resources** | Applies recommended alerts only to selected VMs. Doesn't automatically include future VMs. | Use for granular control when you want to enable alerts for a specific set of resources. |

When subscription scope is selected, you can skip host metric alert rules and create guest OS alert rules only for VMs that have Azure Monitor Agent with OpenTelemetry metrics collection enabled. This helps avoid duplicate alerting on VMs covered by guest OS alerts but leaves VMs without OpenTelemetry metrics uncovered.

The recommended VM alert settings include host metric alert rules, a VM availability alert rule, and preview guest OS alert rules collected through OpenTelemetry when supported telemetry is available. Select **Edit** in the **Alerts** section to select alert rules, adjust thresholds, and configure notification options such as email, Azure Resource Manager role notifications, Azure mobile app notifications, or an existing action group.

The **Review + Enable** tab summarizes the selected scope, selected resources, alert rules, and notification settings. After the alerts are created, you can customize them from the **Alerts** page.

:::image type="content" source="./media/monitoring-coverage/vm-alerts-subscription.png" lightbox="./media/monitoring-coverage/vm-alerts-subscription.png" alt-text="Screenshot of Configure VM recommended alerts with subscription-level scope selected.":::

:::image type="content" source="./media/monitoring-coverage/vm-alerts-selected-resources.png" lightbox="./media/monitoring-coverage/vm-alerts-selected-resources.png" alt-text="Screenshot of Configure VM recommended alerts for selected resources.":::

:::image type="content" source="./media/monitoring-coverage/vm-alerts-customize.png" lightbox="./media/monitoring-coverage/vm-alerts-customize.png" alt-text="Screenshot of customize recommended alert rules, thresholds, and notification options.":::

:::image type="content" source="./media/monitoring-coverage/vm-alerts-review.png" lightbox="./media/monitoring-coverage/vm-alerts-review.png" alt-text="Screenshot of review and enable VM recommended alerts.":::

### Enable AKS recommended alerts

When AKS resources have alert coverage gaps, the **Overview** tab can show an **Enable AKS Recommended Alerts** recommendation. Select **Apply** to configure recommended alert rules for the affected Kubernetes services. The enablement flow follows the same pattern as other monitoring coverage recommendations: select the affected scope or resources, review the recommended alert settings, customize the settings when available, and then use **Review + Enable** to create the alert rules.

Available AKS alert rules depend on supported signals and telemetry for the selected clusters. After alert rules are created, manage and customize them from the **Alerts** page.

### Enable platform telemetry (preview)

Use this workflow to configure collection for selected existing resources. It doesn't create a policy that automatically onboards future resources.

#### Platform telemetry prerequisites

Before opening this workflow, confirm the collection permissions and at least one compatible existing destination:

- Permission to create the collection resources used by your plan: deployments and DCRs in the destination resource group, DCR associations on monitored resources, and diagnostic settings on resources that use that mechanism.
- For DCR delivery to Storage or Event Hubs, an existing user-assigned managed identity and permission to assign it to the DCR.
- At least one existing Log Analytics workspace, Storage account, or Event Hubs namespace and event hub. Diagnostic-settings delivery to Event Hubs also requires a namespace shared access policy (authorization rule).
- Resources and destinations in supported Azure regions. See [platform logs supported resource types and regions](../data-collection/platform-logs-reference.md) and [metrics export using DCRs](../data-collection/metrics-export-create.md).

For DCR delivery to Storage or Event Hubs, the workflow attempts to grant the selected identity's destination role if it's missing. You need role-assignment write permission at the destination, for example **Owner** or **User Access Administrator** in addition to collection-configuration permissions. **Contributor** alone can't create that role assignment. An administrator can preassign the required destination role.

#### Select resources, signals, and destinations

1. On **Overview**, find **Enable Platform Telemetry for supported resources** under **Monitoring recommendations**, and then select **Apply**.
1. On **Configure monitoring**, under **Step 1: Select resources**, review the preselected resources and clear any resource you don't want to change. The wizard's subscription, resource-type, and location filters further narrow the operation to selected resources that match those filters.
1. Under **Step 2: Select telemetry to collect**, select a **Configuration method**:
   - **Quick setup (recommended)** keeps available platform metrics selected and selects logs for a focus area. **Default** includes matching security, audit, and health log categories; it isn't a metrics-only preset. Other focus areas are **Security**, **Reliability**, **Performance / Latency**, **Cost Optimization**, and **Test / Dev**. Test / Dev selects every available log category. If a focus area has no matching categories, the workflow tries Default matches, then leaves logs unselected if none match.
   - **Choose settings manually** lets you expand each resource type and select metrics and log categories. For a newly configured type, metrics are selected by default and logs are opt-in. Where available, **Select metrics** lets you choose individual metrics for DCR collection. Diagnostic-settings collection uses **AllMetrics**.
1. Review the selected metrics and logs for every resource type, especially after changing configuration methods. Check warnings about unavailable regional metrics or unresolved streams: affected signals or resources can be omitted while compatible work continues. If nothing remains to enable, change the selection before continuing.
1. Under **Step 3: Choose destinations**, select and fully configure at least one destination as described in [Choose destinations](#choose-destinations).
1. Select **Review + Enable**.
1. Verify the resource counts, **Metrics**, **Logs**, **Logs table** where applicable, and **Collected via** columns. Collected via can show **Data collection rule**, **Diagnostic setting**, or **DCR + diagnostic setting**. Confirm the destination, identity, warnings, and names of the DCRs and diagnostic settings to be created.
1. Select **Enable** to apply the plan.

:::image type="content" source="./media/monitoring-coverage/platform-telemetry-quick-setup.png" lightbox="./media/monitoring-coverage/platform-telemetry-quick-setup.png" alt-text="Screenshot of platform telemetry quick setup with resource selection, focus areas, and destination choices.":::

:::image type="content" source="./media/monitoring-coverage/platform-telemetry-manual.png" lightbox="./media/monitoring-coverage/platform-telemetry-manual.png" alt-text="Screenshot of manual platform telemetry configuration with metrics and log categories for each resource type.":::

#### Choose destinations

Available destinations depend on the selected resources, signals, collection mechanism, and regions.

| Destination | Requirements and behavior |
|---|---|
| Log Analytics workspace | For DCR collection, the DCR and workspace must be in the same region; supported monitored resources can be in other regions. This route doesn't require a managed identity. Diagnostic settings can also send to an accessible workspace. Data ingestion and retention charges can apply. |
| Storage account | For DCR collection, the monitored resources, DCR, and Storage account must be in the same region. Select a user-assigned managed identity with **Storage Blob Data Contributor** and provide an existing or new blob container name; a missing container is created during ingestion. For diagnostic settings, a regional source and Storage destination must be in the same region. No managed identity or container name is selected in this workflow; diagnostic settings manage their own per-category containers. Allow trusted Microsoft services through the destination firewall when required. |
| Event Hubs | For DCR collection, the monitored resources, DCR, and Event Hubs namespace must be in the same region. Select a user-assigned managed identity with **Azure Event Hubs Data Sender**. For diagnostic settings, use a same-region destination for a regional source and a namespace shared access policy with **Manage**, **Send**, and **Listen** permissions. The configuring user also needs **ListKey** permission on that rule. Allow trusted Microsoft services through the destination firewall when required. |

Storage and Event Hubs aren't available for an incompatible multi-region resource selection. Narrow the resource filter to one compatible region or choose Log Analytics when supported. Don't select a Storage account or Event Hubs namespace as both a monitored source and its own destination.

The workflow creates a separate DCR for each selected destination type that uses DCR collection, in that destination's resource group and region. One DCR can serve multiple selected resources and resource types. Signals that require diagnostic settings use a per-resource setting named `platform-telemetry`.

Enabling platform telemetry doesn't migrate or remove other collection routes. A diagnostic setting already named `platform-telemetry` is updated by this workflow. Existing DCR names are avoided by generating a new name. Inspect existing collection before enabling or rerunning the wizard to avoid overwriting that setting or sending duplicate data.

#### Review and apply the plan

The **Review + Enable** page shows the signals, collection mechanisms, planned DCRs or diagnostic settings, and destinations. Confirm the plan before enabling collection.

:::image type="content" source="./media/monitoring-coverage/platform-telemetry-review.png" lightbox="./media/monitoring-coverage/platform-telemetry-review.png" alt-text="Screenshot of Review + Enable with platform signals, collection mechanisms, planned DCRs and diagnostic settings, and destinations.":::

#### Review results and retry failed configuration

Review the completion message and the **Data collection rule deployments**, **Created**, and **Resources that couldn't be enabled** sections, when shown. An operation can succeed, partially succeed, or fail. A partial result doesn't automatically undo successful configuration.

Before retrying:

1. Record the failed resource names, collection routes, deployment results, and error details.
1. Correct the permission, region, destination, metadata, deployment, DCR-association, or diagnostic-setting issue.
1. Select only the failed resources.
1. Inspect any collection that already succeeded on those resources, then review the new plan to avoid duplicate collection.
1. Retry only the missing configuration. If you use the wizard again, verify every planned write before selecting **Enable**.

If a DCR was created but its resource associations failed, associate the affected resources with that existing DCR rather than recreating it. A new wizard run can create another DCR; don't delete a successful DCR only because an association failed.

### Data flow status on the Overview page

The **Data flow status** section validates whether monitoring data can reach its configured destination. Validation checks help identify issues in resource configuration, agent state, data collection rule associations, network connectivity, and data flows before they cause monitoring data loss.

The section includes:

- **Data flow status across resources**, which shows how many resources need attention, passed initial checks, or aren't configured for validation.
- **Top resources that need attention**, which lists the resources with detected issues so you can open the resource-specific details directly.

Platform telemetry collection isn't validated by these agent-based checks. Resources assessed only for platform telemetry show **Not assessed** data-flow status. Neither an initial pass nor a configured collection route proves that data has arrived at its destination.

## Monitoring Details page

The **Monitoring Details** tab combines infrastructure and platform resources in a resource-centric view of coverage and data flow status. Use this page to find individual resources that need recommended monitoring, have partial coverage, or have data flow validation issues.

The list can be filtered or grouped by available resource properties. Key columns include **Coverage** and **Data flow status**. Select a value in either column to inspect the resource.

| Column | Description |
|---|---|
| **Coverage** | Shows whether the resource has **Basic**, **Partial**, or **Enhanced** monitoring. Select the value to inspect the resource's monitoring configuration. |
| **Data flow status** | Shows the most recent validation status for monitoring data flow, such as **Needs attention** or **Passed initial checks**. Select the value to view validation results and recommended actions. |
| **Resource Type**, **Subscription**, **Resource Group**, **Location** | Provides context for filtering, grouping, and triaging resources at scale. |

:::image type="content" source="./media/monitoring-coverage/details.png" lightbox="./media/monitoring-coverage/details.png" alt-text="Screenshot of Monitoring Details tab with resource-level monitoring coverage and data flow status.":::

### Filter and group resources

Use **Subscriptions** to select scope, then **Add filter** to narrow the list.

| Filter | Options and behavior |
|---|---|
| **Resource groups**, **Resource types**, **Locations**, **Tags** | Limit the resource scope. Resource types includes supported infrastructure and platform telemetry types. |
| **Coverage** | Select one or more of **Enhanced**, **Partial**, and **Basic**. |
| **Data flow status** | Select one or more of **Needs attention**, **Passed initial checks**, **No data collection configured**, and **Not assessed**. |
| **Filter resources...** | Search by resource name, resource type, resource group, subscription, or location. |

Coverage, Data flow status, and text search filter the loaded Monitoring Details list. They don't change the Overview summary cards or expand a truncated resource inventory. Use the scope filters to narrow large inventories. Sorting and grouping can help organize the remaining resources.

For resources assessed only for platform telemetry, **Coverage** shows **Enhanced** when platform collection is configured and **Basic** when it isn't; there's no Partial platform tier. VM, VM scale set, AKS, and Arc-enabled Kubernetes coverage instead follows the infrastructure monitoring configuration, so enabling platform telemetry alone doesn't raise their infrastructure coverage tier.

### Monitoring coverage details for a resource

For an infrastructure resource, the **Monitoring coverage details** tab summarizes its monitoring. The **Overview** section shows the current monitoring coverage, data flow status, and last updated time. The **Configuration summary** shows the number of data collection rules, data sources, destinations, and the installed agent and version when applicable.

The **Configuration details** section shows the monitoring configurations applied to the resource, including data collection configurations such as:

- VM insights status and an action to enable VM insights when it isn't configured.
- Recommended alert rules, including enabled rules and notification configuration, with an action to manage alert rules.
- Data collection rules associated with the resource, including data sources and destinations, with an action to associate the resource to additional DCRs.

:::image type="content" source="./media/monitoring-coverage/resource-monitoring-details.png" lightbox="./media/monitoring-coverage/resource-monitoring-details.png" alt-text="Screenshot of resource monitoring coverage details with configuration summary, VM insights, recommended alerts, and DCRs.":::

### Inspect platform telemetry collection

For a resource assessed only for platform telemetry, such as a storage account or key vault, select **Coverage** to open the **Platform telemetry** pane. It can show:

- DCRs associated with the resource and the supported signals they collect.
- Diagnostic settings with enabled metric or log categories.
- The destination for each collection route.
- The collection scope for supported child resources, such as Storage subservices.

If the summary and the resource's Azure configuration disagree, refresh monitoring coverage and inspect the DCR association or diagnostic setting directly before changing the configuration.

### Data flow status for a resource

For supported infrastructure resources, the **Data flow status** tab shows validation results. Validation checks evaluate a set of configurations that commonly cause data flow issues. Rerun validation checks after applying any fix to confirm progress.

The default view shows issues that need attention at the top and then lists all validation checks. For each issue, the page provides a recommended action, such as installing the agent or opening the resource for remediation.

Validation checks are grouped by areas such as:

- Resource
- Data collection rule associations
- Network
- Data flows

Fix detected issues in numerical order, then select **Run validation checks** to update the status. Use the **List** and **Diagram** views to switch between validation result layouts.

> [!NOTE]
> Passing all current validations doesn't necessarily mean there's nothing wrong with the data flow's end-to-end configuration. **No data collection configured** and **Not assessed** are different states: the latter is used for resources whose platform telemetry data flow isn't validated here.

:::image type="content" source="./media/monitoring-coverage/resource-data-flow.png" lightbox="./media/monitoring-coverage/resource-data-flow.png" alt-text="Screenshot of resource data flow status with validation checks, recommended action, and last checked time.":::

## Verify platform telemetry ingestion

Configuration success and destination data arrival are separate checks:

1. Refresh monitoring coverage after Azure Resource Manager propagation.
1. Open an affected resource and verify the expected DCR association or diagnostic setting.
1. Confirm that the intended stream or category and destination are present.
1. Generate or wait for an expected metric or resource-log event.
1. Check the destination for the correct UTC time range.

For platform telemetry DCRs, allow up to 30 minutes for initial log data to appear. For diagnostic settings, current guidance says data should start flowing within 90 minutes. The exact latency depends on the source and destination.

If configuration is correct but data doesn't appear after the applicable window, see [Troubleshooting for platform log collection with DCRs](../data-collection/platform-logs-collect.md#troubleshoot) or [Troubleshooting for diagnostic settings](../data-collection/diagnostic-settings.md#troubleshooting).

## Limitations and considerations

- Resource-selection enablement operations include up to 100 resources at a time. Subscription-level VM alerting has broader scope, including eligible current and future VMs.
- Platform telemetry coverage evaluates up to 5,000 resources. Narrow the scope if results are truncated.
- Availability varies by Azure cloud, region, resource type, and signal.
- Storage and Event Hubs require region-compatible selections.
- Diagnostic-settings metric configuration uses **AllMetrics**; most resource types don't support individual metric categories on that route.
- Configuration coverage doesn't guarantee data arrival. Data flow status reflects the latest validation check; rerun checks after making changes.
- A transient permissions, throttling, or service error while reading diagnostic settings can temporarily make configured collection appear absent. Refresh and verify the resource directly before recreating configuration.
- Disabling or losing access to monitoring coverage doesn't remove DCRs, DCR associations, diagnostic settings, role assignments, or destinations created earlier.
- Enhanced monitoring, ingestion, retention, destination services, and alert rules can incur charges.

## Troubleshoot common issues

For infrastructure data-flow issues, open the resource's validation results, follow the recommended actions, and rerun checks. For missing recommendations, confirm the scope, resource type, permissions, and existing configuration. Use the following guidance for platform telemetry:

| Symptom | What to check |
|---|---|
| Platform telemetry coverage isn't visible | Confirm feature availability for the tenant, cloud, region, and portal environment. Confirm that the user can access monitoring coverage. |
| Expected resources are missing | Check the selected filters, read permissions, supported resource types and regions, and the 5,000-resource coverage limit. |
| Coverage says collection is absent, but configuration exists | Refresh, then inspect DCR associations and diagnostic settings directly. Don't recreate valid configuration solely to change the status. |
| Metrics or log categories are unavailable | Confirm that the resource type and region support the signal. Continue only with signals displayed on **Review + Enable**. |
| Storage or Event Hubs isn't available | Use resources and a destination in one compatible region. Confirm the required identity, role, container, event hub, and authorization rule. |
| Enablement partially succeeds | Keep successful configuration and correct each failed route. Reuse a successfully created DCR when only associations failed. Review existing collection before retrying to avoid duplicate delivery. |
| Configuration succeeds, but no data appears | Verify the exact stream or category and destination, allow the applicable propagation window, and check the underlying DCR or diagnostic-settings troubleshooting article. |

## Related content

- [Enable VM monitoring](../vm/vm-enable-monitoring.md).
- [Enable monitoring for Kubernetes clusters](../containers/kubernetes-monitoring-enable.md).
- [Platform log collection with DCRs](../data-collection/platform-logs-collect.md).
- [Platform logs supported resource types and regions](../data-collection/platform-logs-reference.md).
- [Metrics export using DCRs](../data-collection/metrics-export-create.md).
- [Diagnostic settings in Azure Monitor](../data-collection/diagnostic-settings.md).
- [Data collection rules in Azure Monitor](../data-collection/data-collection-rule-overview.md).
