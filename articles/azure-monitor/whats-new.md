---
title: "What's new in Azure Monitor documentation"
description: "What's new in Azure Monitor documentation"
author: EdB-MSFT
ms.topic: conceptual
ms.date: 09/06/2024
ms.author: edbaynash
---

# What's new in Azure Monitor documentation

This article lists significant changes to Azure Monitor documentation.

> [!TIP]
> Get notified when this page is updated by copying and pasting the following URL into your feed reader:
>
> :::image type="content" source="./media//whats-new/rss.png" alt-text="An rss icon.":::  https://aka.ms/azmon/rss

## [2024](#tab/2024)

## October 2024

|Subservice | Article | Description |
|---|---|---|
|Alerts|[Troubleshoot log search alerts in Azure Monitor](alerts/alerts-troubleshoot-log.md)|Added a workaround for when time filtering doesn't work correctly for log search alert rules that  use Azure Data Explorer (ADX) or Azure Resource Graph (ARG) queries.|
|Application-Insights|[OpenTelemetry help, support, and feedback](app/opentelemetry-faq.md)|OpenTelemetry help, support, and feedback options are now available in one place.|
|Application-Insights|[Enable application monitoring in Azure App Service for .NET, Node.js, Python, and Java applications](app/azure-web-apps-java.md)|App Service automatic instrumentation information for all languages is now available in one place.|
|Change-Analysis|[Migrate to the Change Analysis API powered by Azure Resource Graph](change/change-analysis-migration.md)|Change Analysis (classic) migration and retirement announcement.|
|Essentials|[Structure of a data collection rule in Azure Monitor](essentials/data-collection-rule-structure.md)|Updated DCR JSON structure|
|General|[Best practices for monitoring at-scale with Azure Monitor](monitor-at-scale.md)|We've published a new article describing our at-scale monitoring solutions.|
|General|[Migrate to the Change Analysis API powered by Azure Resource Graph](change/change-analysis-migration.md)|Change Analysis (classic) migration and retirement announcement.|
|Logs|[Set up a table with the Auxiliary plan in your Log Analytics workspace (Preview)](logs/create-custom-table-auxiliary.md)|Added support for the Auxiliary table plan in West EU and West US 2 regions.|
|Logs|[Structure of transformation in Azure Monitor](essentials/data-collection-transformations-structure.md)|Added `parse` operator limitations and information about ingestion latency introduced by transformations.|
|Logs|[Enhance resilience by replicating your Log Analytics workspace across regions (Preview)](logs/workspace-replication.md)|Added information about how Azure Monitor protects in-transit data during a regional when you enable workspace replication.|
|Logs|[Functions in Azure Monitor log queries](logs/functions.md)|Added ARM template example of how to create a function in Azure Monitor Logs. |
|Optimization-Insights|[Code Optimizations extensions for Visual Studio and Visual Studio Code (preview)](insights/code-optimizations-extensions.md)|Public preview announcement of the Visual Studio and Visual Studio Code extensions for Code Optimizations|
|Optimization-Insights|[Code Optimizations extensions for Visual Studio (preview)](insights/code-optimizations-vs-extension.md)|Instructions for using the Code Optimizations extension for Visual Studio|
|Optimization-Insights|[Code Optimizations extensions for Visual Studio Code (preview)](insights/code-optimizations-vscode-extension.md)|Instructions for using the Code Optimizations extension for Visual Studio Code|
|Profiler|[Enable Profiler for ASP.NET Core web apps hosted in Linux](profiler/profiler-aspnetcore-linux.md)|Update "Profiler" name to variations of ".NET Profiler" to differentiate from the Java Profiler. |
|Profiler|[Enable the .NET Profiler for Azure Functions apps](profiler/profiler-azure-functions.md)|Update "Profiler" name to variations of ".NET Profiler" to differentiate from the Java Profiler. |
|Profiler|[Configure BYOS for Application Insights Profiler for .NET and Snapshot Debugger](profiler/profiler-bring-your-own-storage.md)|Update "Profiler" name to variations of ".NET Profiler" to differentiate from the Java Profiler. |
|Profiler|[Enable the .NET Profiler for Azure Cloud Services](profiler/profiler-cloudservice.md)|Update "Profiler" name to variations of ".NET Profiler" to differentiate from the Java Profiler. |
|Profiler|[Enable the .NET Profiler on Azure containers](profiler/profiler-containers.md)|Update "Profiler" name to variations of ".NET Profiler" to differentiate from the Java Profiler. |
|Profiler|[View Application Insights Profiler for .NET data](profiler/profiler-data.md)|Update "Profiler" name to variations of ".NET Profiler" to differentiate from the Java Profiler. |
|Profiler|[Profile production applications in Azure with Application Insights Profiler for .NET](profiler/profiler-overview.md)|Update "Profiler" name to variations of ".NET Profiler" to differentiate from the Java Profiler. |
|Profiler|[Enable the .NET Profiler for Azure Service Fabric applications](profiler/profiler-servicefabric.md)|Update "Profiler" name to variations of ".NET Profiler" to differentiate from the Java Profiler. |
|Profiler|[Configure Application Insights Profiler for .NET](profiler/profiler-settings.md)|Update "Profiler" name to variations of ".NET Profiler" to differentiate from the Java Profiler. |
|Profiler|[Write code to track requests with Application Insights Profiler for .NET](profiler/profiler-trackrequests.md)|Update "Profiler" name to variations of ".NET Profiler" to differentiate from the Java Profiler. |
|Profiler|[Troubleshoot Application Insights Profiler for .NET](profiler/profiler-troubleshooting.md)|Update "Profiler" name to variations of ".NET Profiler" to differentiate from the Java Profiler. |
|Profiler|[Enable the .NET Profiler for web apps on an Azure virtual machine](profiler/profiler-vm.md)|Update "Profiler" name to variations of ".NET Profiler" to differentiate from the Java Profiler. |
|Profiler|[Enable the .NET Profiler for Azure App Service apps](profiler/profiler.md)|Update "Profiler" name to variations of ".NET Profiler" to differentiate from the Java Profiler. |
|Profiler|[Troubleshoot Code Optimizations](insights/code-optimizations-troubleshoot.md)|Updates to the Code Optimizations documentation for GA.|
|Profiler|[Monitor and analyze runtime behavior with Code Optimizations](insights/code-optimizations.md)|Updates to the Code Optimizations documentation for GA.|
|Profiler|[Set up Code Optimizations](insights/set-up-code-optimizations.md)|Updates to the Code Optimizations documentation for GA.|
|Profiler|[View Code Optimizations results](insights/view-code-optimizations.md)|Updates to the Code Optimizations documentation for GA.|
|Profiler|[Profile production applications in Azure with Application Insights Profiler for .NET](profiler/profiler-overview.md)|Updates to the Code Optimizations documentation for GA.|
|Profiler|[Configure Application Insights Profiler for .NET](profiler/profiler-settings.md)|Updates to the Code Optimizations documentation for GA.|
|Virtual-Machines|[Dependency Agent](vm/vminsights-dependency-agent-maintenance.md)|Added considerations section.|
|Virtual-Machines|[Enable VM Insights overview](vm/vminsights-enable-overview.md)|Added supported operating systems and VM insights DCR sections.|
|Virtual-Machines|[Enable VM insights using the Azure portal](vm/vminsights-enable-portal.md)|General cleanup.|
|Virtual-Machines|[Enable VM insights using ARM templates](vm/vminsights-enable-resource-manager.md)|Added details on VM insights DCR and associations.|
|Virtual-Machines|[Migrate to Azure Monitor Agent from Log Analytics agent in VM Insights](vm/vminsights-migrate-agent.md)|New article.|
|Visualizations|[Stat visualizations](visualize/workbooks-stat-visualizations.md)|Azure Workbooks now support Stat visualizations to help you create dashboards that give you instant alerts when a service is healthy or unhealthy, or when important metrics drop below a certain level.|
|Visualizations|[Azure Workbooks dashboard preview](visualize/workbooks-dashboard-preview.md)|Azure workbooks now support a limited dashboard preview for Dashboard style workbooks. This feature is in continued development.|
|Visualizations|[Enable Change Analysis (classic)](change/change-analysis-enable.md)|Update Change Analysis to "Change Analysis (classic)" ahead of retirement in favor of the Change Analysis API for Azure Resource Graph |
|Visualizations|[Tutorial: Track a web app outage using Change Analysis (classic)](change/change-analysis-track-outages.md)|Update Change Analysis to "Change Analysis (classic)" ahead of retirement in favor of the Change Analysis API for Azure Resource Graph |
|Visualizations|[Troubleshoot Change Analysis (classic)](change/change-analysis-troubleshoot.md)|Update Change Analysis to "Change Analysis (classic)" ahead of retirement in favor of the Change Analysis API for Azure Resource Graph |
|Visualizations|[View and use Change Analysis (classic)](change/change-analysis-visualizations.md)|Update Change Analysis to "Change Analysis (classic)" ahead of retirement in favor of the Change Analysis API for Azure Resource Graph |
|Visualizations|[Use Change Analysis (classic)](change/change-analysis.md)|Update Change Analysis to "Change Analysis (classic)" ahead of retirement in favor of the Change Analysis API for Azure Resource Graph |
|Visualizations|[Azure Monitor data platform](data-platform.md)|Update Change Analysis to "Change Analysis (classic)" ahead of retirement in favor of the Change Analysis API for Azure Resource Graph |
|Visualizations|[Azure Monitor overview](overview.md)|Update Change Analysis to "Change Analysis (classic)" ahead of retirement in favor of the Change Analysis API for Azure Resource Graph |
|Visualizations|[Azure Workbooks data sources](visualize/workbooks-data-sources.md)|Update Change Analysis to "Change Analysis (classic)" ahead of retirement in favor of the Change Analysis API for Azure Resource Graph |

## September 2024

|Subservice | Article | Description |
|---|---|---|
|Agents|[Azure Diagnostics extension overview](/azure/azure-monitor/agents/diagnostics-extension-overview)|Announced that Azure Diagnostics extension will be deprecated on March 31, 2026.|
|Agents|[Azure Monitor Agent supported operating systems and environments](/azure/azure-monitor/agents/azure-monitor-agent-supported-operating-systems)|Added Azure Monitor Agent support for Amazon Linux 2023.|
|Alerts|[Create a new alert rule using the CLI, PowerShell, or an ARM template](/azure/azure-monitor/alerts/alerts-create-rule-cli-powershell-arm)|Added prerequisites for all alert rule types stating that in order to create alert rules that use action groups, you must have a role with permissions for those action groups.|
|Application-Insights|[Configure Azure Monitor OpenTelemetry](/azure/azure-monitor/app/opentelemetry-configuration?tabs=aspnetcore)|We recommend the [Azure Monitor OpenTelemetry Exporter](https://www.nuget.org/packages/Azure.Monitor.OpenTelemetry.Exporter) for classic ASP.NET apps (console, worker service, WinForms, etc.), which doesn't include live metrics.|
|Application-Insights|[Live metrics: Monitor and diagnose with 1-second latency](/azure/azure-monitor/app/live-stream?tabs=otel)|We revamped this article for simplicity and linked out to Microsoft Entra documentation for more information on how to secure potentially sensitive information entered into custom filters.|
|Application-Insights|[Migrate from .NET Application Insights SDKs to Azure Monitor OpenTelemetry](/azure/azure-monitor/app/opentelemetry-dotnet-migrate?tabs=aspnetcore)|We recommend the [Azure Monitor OpenTelemetry Exporter](https://www.nuget.org/packages/Azure.Monitor.OpenTelemetry.Exporter) for classic ASP.NET apps (console, worker service, WinForms, etc.), which doesn't include live metrics.|
|Application-Insights|[Statsbeat in Application Insights](/azure/azure-monitor/app/statsbeat?tabs=dotnet)|We revamped Statsbeat documentation to include OpenTelemetry scenarios.|
|Essentials|[Create and edit data collection rules (DCRs) and associations in Azure Monitor](/azure/azure-monitor/essentials/data-collection-rule-create-edit?tabs=portal)|Added DCRs for metrics|
|Essentials|[Data plane metrics batch API query versus metrics export](/azure/azure-monitor/essentials/data-plane-versus-metrics-export)|New article: Comparison of metrics retrieval methods|
|Essentials|[Metrics export through data collection rules (Preview)](/azure/azure-monitor/essentials/data-collection-metrics?tabs=log-analytics-workspaces)|New feature - DCRs for Metrics|
|General|[Operational excellence best practices in Azure Monitor](/azure/azure-monitor/best-practices-operation)|New best practice articles|
|General|[Performance efficiency in Azure Monitor](/azure/azure-monitor/best-practices-performance)|New best practice articles|
|General|[Reliability best practices in Azure Monitor](/azure/azure-monitor/best-practices-reliability)|New best practice articles|
|General|[Security best practices in Azure Monitor](/azure/azure-monitor/best-practices-security)|New best practice articles|

## August 2024

|Subservice | Article | Description |
|---|---|---|
|Agents|[MMA/OMS Discovery and Removal Utility](agents/azure-monitor-agent-mma-removal-tool.md)|New Removal Tool|
|Application-Insights|[Migrate to workspace-based Application Insights resources](/previous-versions/azure/azure-monitor/app/convert-classic-resource)|We've updated the table that converts values used in Classic AI resources to Workspace-based resources.|
|Application-Insights|[Application Insights for ASP.NET Core applications](app/asp-net-core.md)|The option to disable telemetry correlation has been documented for ASP.NET Core.|
|Application-Insights|[Configure Application Insights for your ASP.NET website](app/asp-net.md)|The option to disable telemetry correlation has been documented for ASP.NET.|
|Application-Insights|[Configuration options: Azure Monitor Application Insights for Java](app/java-standalone-config.md)|The option to disable telemetry correlation has been documented for Java.|
|Application-Insights|[Monitor your Node.js services and apps with Application Insights](app/nodejs.md)|The option to disable telemetry correlation has been documented for Node.js.|
|Application-Insights|[What is autoinstrumentation for Azure Monitor Application Insights?](app/codeless-overview.md)|Further "autoinstrumentation" explanation has been added, alongside an example, to better convey the meaning of this term.|
|Application-Insights|[Microsoft Entra authentication for Application Insights](app/azure-ad-authentication.md)|Options to enable Microsoft Entra authentication for .NET and Node.js autoinstrumentation are documented.|
|Application-Insights|[Application Insights availability tests](app/availability.md)|We clarified information about using an "availability test string identifier", which previously caused some confusion when referred to as a "GUID".|
|Containers|[Optimize monitoring costs for Container insights](containers/container-insights-cost.md)|Rewritten to consolidate cost saving options and analysis.|
|Containers|[Configure log collection in Container insights](containers/container-insights-data-collection-configure.md)|New article to consolidate all guidance for container location.|
|Containers|[Filter log collection in Container insights](containers/container-insights-data-collection-filter.md)|New article to describe all options to filter container logs.|
|Containers|[Container insights log schema](containers/container-insights-logs-schema.md)|Rewritten to focus on definition and configuration of log schema, including metadata option.|
|Containers|[Access Syslog data in Container Insights](containers/container-insights-syslog.md)|Removed duplicate information on configuration.|
|Containers|[Data transformations in Container insights](containers/container-insights-transformations.md)|Added details to filtering example and added a new example to send data to multiple tables.|
|Containers|[Enable private link for Kubernetes monitoring in Azure Monitor](containers/container-insights-private-link.md)|New article to consolidate private link guidance for Container insights.|
|Containers|[High scale logs collection in Container Insights (Preview)](containers/container-insights-high-scale.md)|New feature.|
|Containers|[Monitor your Kubernetes cluster performance with Container insights](containers/container-insights-analyze.md)|Added explanation of "Other processes" column.|
|Essentials |[Manage data collection rules (DCRs) and associations in Azure Monitor](essentials/data-collection-rule-view.md)|Added guidance for new UI feature to manage DCR associations.|
|Essentials|[Use Azure Policy to install and manage the Azure Monitor agent](agents/azure-monitor-agent-policy.md)|Added information on new UI feature to create associations.|
|Essentials|[Create and edit data collection rules (DCRs) and associations in Azure Monitor](essentials/data-collection-rule-create-edit.md)|Removed duplicate information.|
|Essentials|[Data collection rules (DCRs) in Azure Monitor](essentials/data-collection-rule-overview.md)|Added diagram.|
|Essentials|[Monitor and troubleshoot DCR data collection in Azure Monitor](essentials/data-collection-monitor.md)|Corrected an error in KQL using InputStreamId.|
|General|[Analyze and visualize monitoring data](best-practices-analysis.md)|We've updated our visualization recommendations to better guide customers when to use Azure Managed Grafana and when to use Azure Workbooks.|
|Logs|[Best practices for Azure Monitor Logs](best-practices-logs.md)|Updated overview of features that enhance resilience of your Log Analytics workspace, including a new video. |
|Logs|[Set up a table with the Auxiliary plan in your Log Analytics workspace (Preview)](logs/create-custom-table-auxiliary.md)|New article that explains how to set up a table with the Auxiliary plan. |
|Logs|[Azure Monitor Logs overview](logs/data-platform-logs.md)|Updated Azure Monitor Logs overview provides a high-level overview of data collection, management, retrieval, and consumption for a range of use cases.|
|Logs|[Run search jobs in Azure Monitor](logs/search-jobs.md)|New video that explains how to use search jobs in Azure Monitor Logs.|
|Logs|[Aggregate data in a Log Analytics workspace by using summary rules (Preview)](logs/summary-rules.md)|New video that explains how to use summary rules to optimize data in your Log Analytics workspace.|

## July 2024

|Subservice | Article | Description |
|---|---|---|
|Agents|[Collect firewall logs with Azure Monitor Agent (Preview)](agents/data-sources-firewall-logs.md)|New article that explains how to collect Windows Firewall logs with Azure Monitor Agent.|
|Agents|[AMA agent data field differences from MMA](agents/azure-monitor-agent-data-field-differences.md)|New article that describes differences between the data collected by Log Analytics agent and Azure Monitor Agent. This information is important when you migrate from the legacy agent to Azure Monitor Agent, especially for migrating queries.|
|Agents|[Collect data with Azure Monitor Agent](agents/azure-monitor-agent-data-collection.md)|Rewritten to describe basic process for all data sources.|
|Agents|[Install and manage Azure Monitor Agent](agents/azure-monitor-agent-manage.md)|Rewritten to simplify agent onboarding guidance.|
|Agents|[Azure Monitor Agent overview](agents/azure-monitor-agent-overview.md)|Rewritten to better describe core concepts including DCR associations.|
|Agents|[Use Azure Policy to install and manage the Azure Monitor agent](agents/azure-monitor-agent-policy.md)|New article to break Azure Policy guidance out from onboarding guidance.|
|Agents|[Azure Monitor agent requirements](agents/azure-monitor-agent-requirements.md)|New article to break agent requirements out from onboarding guidance.|
|Agents|[Azure Monitor Agent supported operating systems](agents/azure-monitor-agent-supported-operating-systems.md)|New article to break supported OS out from onboarding guidance.|
|Agents|[Collect Windows events from virtual machines with Azure Monitor Agent](agents/data-collection-windows-events.md)|Rewritten for consistency with other data collection articles.|
|Agents|[Collect Syslog events with Azure Monitor Agent](agents/data-collection-syslog.md)|Rewritten for consistency with other data collection articles.|
|Agents|[Collect IIS logs with Azure Monitor Agent](agents/data-collection-iis.md)|Rewritten for consistency with other data collection articles.|
|Agents|[Collect performance counters with Azure Monitor Agent](agents/data-collection-performance.md)|Rewritten for consistency with other data collection articles.|
|Agents|[Collect logs from a text file with Azure Monitor Agent](agents/data-collection-log-text.md)|Rewritten for consistency with other data collection articles and to better describe configuration options.|
|Agents|[Collect logs from a JSON file with Azure Monitor Agent](agents/data-collection-log-json.md)|Rewritten for consistency with other data collection articles and to better describe configuration options.|
|Agents|[Collect SNMP trap data with Azure Monitor Agent](agents/data-collection-snmp-data.md)|Rewritten to better describe fundamental strategy.|
|Agents|[Create and edit data collection rules (DCRs) in Azure Monitor](essentials/data-collection-rule-create-edit.md)|Rewritten for consistency with rewritten agent DCR articles.|
|Application-Insights|[Migrate from .NET Application Insights SDKs to Azure Monitor OpenTelemetry](app/opentelemetry-dotnet-migrate.md)|Migrate .NET applications from the SDK Classic API to OpenTelemetry using our new step-by-step guide.|
|Application-Insights|[Configure Azure Monitor OpenTelemetry](app/opentelemetry-configuration.md)|The .NET example under Set the Cloud Role Name and the Cloud Role Instance now shows how to configure all signals.|
|Application-Insights|[Configure Azure Monitor OpenTelemetry](app/opentelemetry-configuration.md)|Node.js guidance is available for using each of the credential classes.|
|Application-Insights|[Monitor Azure Functions with Azure Monitor Application Insights](app/monitor-functions.md)|New configuration guidance added for Functions both on and off a consumption plan.|
|Application-Insights|[Configure Azure Monitor OpenTelemetry](app/opentelemetry-configuration.md)|Updated instructions and code sample for using Microsoft Entra with Python.|
|Containers|[Monitor Kubernetes clusters using Azure services and cloud native tools](containers/monitor-kubernetes.md)|Updated for Prometheus experience for Container insights.|
|Essentials|[Azure monitoring REST API walkthrough](essentials/rest-api-walkthrough.md)|Get an API token  using Python, JavaScript C# and Azure CLI.|
|Essentials|[Best practices for scaling Azure Monitor Workspaces with Azure Monitor managed service for Prometheus](essentials/azure-monitor-workspace-scaling-best-practice.md)|New article: Best practices for Azure Monitor workspaces with  Azure Managed Prometheus|
|Logs|[Log Analytics workspace overview](logs/log-analytics-workspace-overview.md)|Public preview of the Auxiliary table plan - a new low-cost plan for verbose logs used in compliance and security scenarios. We've also upgraded the Basic table plan to include 30 days of interactive retention and full KQL on a single table.|
|Logs|[Enhance data and service resilience in Azure Monitor Logs with availability zones](logs/availability-zones.md)|Added availability zone support in Spain Central.|
|Operations-Manager-Managed-Instance|[Monitor Azure and Off-Azure Virtual machines with Azure Monitor SCOM Managed Instance extensions](scom-manage-instance/monitor-arc-enabled-vm-with-scom-managed-instance.md)|Added new monitor doc|
|Operations-Manager-Managed-Instance|[Monitor Off-Azure Virtual machines with Azure Monitor SCOM Managed Instance](scom-manage-instance/monitor-off-azure-vm-with-scom-managed-instance.md)|added new docs|
|Optimization-Insights|[Monitor and analyze runtime behavior with Code Optimizations (Preview)](insights/code-optimizations.md)|Clarify expected CPU/memory overhead when using Profiler/Code Optimizations|
|Profiler|[View Application Insights Profiler data](profiler/profiler-data.md)|Clarify expected CPU/memory overhead when using Profiler|
|Profiler|[Profile production applications in Azure with Application Insights Profiler](profiler/profiler-overview.md)|Clarify expected CPU/memory overhead when using Profiler|
|Profiler|[Configure Application Insights Profiler](profiler/profiler-settings.md)|Clarify expected CPU/memory overhead when using Profiler|
|Profiler|[Troubleshoot Application Insights Profiler](profiler/profiler-troubleshooting.md)|Clarify expected CPU/memory overhead when using Profiler|
|Profiler|[Enable Profiler for Azure App Service apps](profiler/profiler.md)|Clarify expected CPU/memory overhead when using Profiler|
|Snapshot-Debugger|[ Troubleshoot problems enabling Application Insights Snapshot Debugger or viewing snapshots](snapshot-debugger/snapshot-debugger-troubleshoot.md)|Clarify expected CPU/memory overhead when using Snapshot Debugger|
|Snapshot-Debugger|[Debug exceptions in .NET applications using Snapshot Debugger](snapshot-debugger/snapshot-debugger.md)|Clarify expected CPU/memory overhead when using Snapshot Debugger|

## June 2024

|Subservice | Article | Description |
|---|---|---|
|Agents|[Azure Monitor Agent Migration Helper workbook](agents/azure-monitor-agent-migration-helper-workbook.md)|Guidance for using the AMA migration workbook.|
|Agents|[Migrate to Azure Monitor Agent from Log Analytics agent](agents/azure-monitor-agent-migration.md)|Refreshed guidance for migrating to Azure Monitor Agent.|
|Alerts|[Action groups](alerts/action-groups.md)|Added list of supported roles to which action groups can send emails.|
|Alerts|[Action groups](alerts/action-groups.md)|Updated PowerShell script for action groups using secure webhook.|
|Alerts|[Create or edit a log search alert rule](alerts/alerts-create-log-alert-rule.md)|Added limitation of log search alert rules to indicate that log search alert rules don't support linked storage.|
|Alerts|[Common alert schema](alerts/alerts-common-schema.md)|A link to Azure Monitor Investigator was added to the alerts common schema.|
|App|[Live metrics: Monitor and diagnose with 1-second latency](app/live-stream.md)|Update Distro Feature Matrix|
|Application-Insights|[Migrate to workspace-based Application Insights resources](/previous-versions/azure/azure-monitor/app/convert-classic-resource)|Migration guidance for Classic to Workspace-based resources has been updated. Classic Application Insights resources are fully retired and Continuous Export is disabled.|
|Application-Insights|[OpenTelemetry on Azure](app/opentelemetry.md)|Our OpenTelemetry on Azure offerings are fully documented here, as well as a link to our OpenTelemetry roadmap.|
|Application-Insights|[Application Insights availability tests](app/availability-overview.md)|Availability Test TLS support is now fully documented.|
|Application-Insights|[Enable Azure Monitor OpenTelemetry for .NET, Node.js, Python, and Java applications](app/opentelemetry-enable.md)|A tab for Azure Monitor Application Insights OpenTelemetry support of Java Native images is available.|
|Application-Insights|[Live metrics: Monitor and diagnose with 1-second latency](app/live-stream.md)|We've updated our Live Metrics documentation so that it links out to both OpenTelemetry and the Classic API code.|
|Application-Insights|[Configuration options: Azure Monitor Application Insights for Java](app/java-standalone-config.md)|For Java OpenTelemetry, we've documented how to locally disable ingestion sampling. (preview feature)|
|Containers|[Enable private link with Container insights](containers/container-insights-private-link.md)|Added guidance for CLI.|
|Containers|[Customize scraping of Prometheus metrics in Azure Monitor managed service for Prometheus](containers/prometheus-metrics-scrape-configuration.md)|Updated and refreshed|
|Containers|[Use Prometheus exporters for common workloads with Azure Managed Prometheus](containers/prometheus-exporters.md)|New article listing supported exporters.|
|Essentials|[Send Prometheus metrics from virtual machines, scale sets, or Kubernetes clusters to an Azure Monitor workspace](essentials/prometheus-remote-write-virtual-machines.md)|Configure remote write for self-managed Prometheus on a Kubernetes cluster|
|General|[Create a metric alert with dynamic thresholds](alerts/alerts-dynamic-thresholds.md)|Added possible values for alert User Response field.|
|Logs|[Tutorial: Send data to Azure Monitor using Logs ingestion API (Resource Manager templates)](logs/tutorial-logs-ingestion-api.md)|Updated to use DCR endpoint instead of DCE.|
|Logs|[Create and manage a dedicated cluster in Azure Monitor Logs](logs/logs-dedicated-clusters.md)|Added new process for configuring dedicated clusters in Azure portal.|
|Logs|[Set a table's log data plan to Basic or Analytics](logs/logs-table-plans.md)|The Basic Logs table plan now includes 30 days of interactive retention.|
|Logs|[Aggregate data in a Log Analytics workspace by using summary rules (Preview)](logs/summary-rules.md)|Summary rules final 2|
|Visualizations|[Link actions](visualize/workbooks-link-actions.md)|Added clarification that the user must have permissions to all resources referenced in a workbook as well as to the workbook itself.<p>Updated process and screenshots for custom views in workbook link actions.|

## May 2024

|Subservice | Article | Description |
|---|---|---|
|Agents|[Migrate to Azure Monitor Agent from Log Analytics agent](agents/azure-monitor-agent-migration.md)|Updated support policy for the legacy Log Analytics agent, which will be retired on August 31, 2024.|
|Alerts|[Create a metric alert with dynamic thresholds](alerts/alerts-dynamic-thresholds.md)|Clarify look-back period|
|Alerts|[Action groups](alerts/action-groups.md)|Updated the description of action groups to clarify that you can use automatic workflows for any scenario, not only to let users know that alert has been raised.|
|Alerts|[Supported resources for Azure Monitor metric alerts](alerts/alerts-metric-near-real-time.md)|Removed references to the deprecated Microsoft.Web/containerApps namespace, and replaced with Microsoft.app/containerApps namespace.|
|Alerts|[Action groups](alerts/action-groups.md)|Updated action group ARM role group notification functionality.|
|Alerts|[Create or edit a log search alert rule](alerts/alerts-create-log-alert-rule.md)|Updated article to indicate that log search alert rule queries support 'ago()' with timespan literals only.|
|Application-Insights|[Configure Azure Monitor OpenTelemetry](app/opentelemetry-configuration.md)|The OpenTelemetry live metrics feature preview is available for .NET Core, Node.js, and Python.|
|Application-Insights|[Testing behind a firewall](app/availability-private-test.md)|New guidance is available for availability testing behind firewalls.|
|Application-Insights|[Application Insights availability tests](app/availability-overview.md)|We added clarification on both running availability tests on an intranet server and the user agent string used for availability tests.|
|Application-Insights|[Application map: Triage distributed applications](app/app-map.md)|This article has been refreshed with all new screenshots.|
|Application-Insights|[Downtime, SLA, and outages workbook](app/sla-report.md)|This article has been refreshed with all new screenshots.|
|Application-Insights|[Application Insights API for custom events and metrics](app/api-custom-events-metrics.md)|Clarification added for Java and JavaScript automatic flushing behavior and configuration.|
|Containers|[Switch to using managed Prometheus visualizations for Container Insights (preview)](containers/container-insights-experience-v2.md)|V2 docs updates|
|Essentials|[Built-in policies for Azure Monitor](essentials/diagnostics-settings-policies-deployifnotexists.md)|New built-in policies for "allLogs" category |
|Logs|[Define Azure Monitor Agent network settings](agents/azure-monitor-agent-data-collection-endpoint.md)|When you create a data collection rule, Azure Monitor now automatically creates a data collection endpoint and associates it to the data collection rule.|
|Logs|[Azure Monitor customer-managed key](logs/customer-managed-keys.md)|Azure Monitor Logs now supports running search jobs in Log Analytics workspaces with customer managed keys.|
|Logs|[Enhance resilience by replicating your Log Analytics workspace across regions (Preview)](logs/workspace-replication.md)|You can now replicate your Log Analytics workspace across regions and switch over to the replicated workspace if there's a regional failure.|
|Logs|[Analyze data using Log Analytics Simple mode (Preview)](logs/log-analytics-simple-mode.md)|Simple mode provides the most commonly used Azure Monitor Logs functionality in an intuitive, spreadsheet-like experience. Just point and click to filter, sort, and aggregate data to get to the insights you need 80% of the time.|
|Profiler|[Troubleshoot Application Insights Profiler](profiler/profiler-troubleshooting.md)|Update Troubleshooting guide with instructions for stopping unused slots.|
|Profiler|[Troubleshoot Application Insights Profiler](profiler/profiler-troubleshooting.md)|Update Troubleshooting guide with prerequisite for latest ASP.NET Core runtime and explanation for limit on active profiling sessions.|

## April 2024

|Subservice | Article | Description |
|---|---|---|
|Alerts|[Understand the automatic migration process for your classic alert rules](alerts/alerts-automatic-migration.md)|Azure Monitor classic alerts are officially retired, replaced by the newer alerts experience.|
|Alerts|[Troubleshooting problems in Azure Monitor alerts](alerts/alerts-troubleshoot.md)|Update alerts-troubleshoot.md|
|Alerts|[Tutorial: Create a log search alert for an Azure resource](alerts/tutorial-log-alert.md)|Added note to indicate that  The combined size of all data in the log alert rule properties can't exceed 64 KB. This can be caused by too many dimensions, the query being too large, too many action groups, or a long description. Remember to optimize these areas when creating log search alert rules.|
|Application-Insights|[Migrate to workspace-based Application Insights resources](/previous-versions/azure/azure-monitor/app/convert-classic-resource)|Continuous Export within Classic Application Insights will be shut down on May 15, 2024. After this date, your Continuous Export configurations will no longer be available.|
|Application-Insights|[Migrate from the Node.js Application Insights SDK 2.X to Azure Monitor OpenTelemetry](app/opentelemetry-nodejs-migrate.md)|Node.js OpenTelemetry migration guidance is available, providing a choice of either clean installing our Distro (recommended) or upgrading to Node.js SDK 3.X as an interim solution.|
|Application-Insights|[Application monitoring for Azure App Service and Python (Preview)](app/azure-web-apps-python.md)|Codeless OpenTelemetry automatic instrumentation for Python is available in preview.|
|Application-Insights|[Configuration options: Azure Monitor Application Insights for Java](app/java-standalone-config.md)|Java Custom Instrumentation (preview) is available. Starting from version 3.3.1, you can capture spans for a method in your application.|
|Application-Insights|[Sampling in Application Insights](app/sampling-classic-api.md)|Conflicting`ExcludedTypes` and `IncludedTypes` guidance has been added.|
|Change-Analysis|[Enable Change Analysis](change/change-analysis-enable.md)|Add note to AzMon Change Analysis documentation to point users to the new ARG Change Analysis public preview, which will replace AzMon Change Analysis in GA.|
|Change-Analysis|[Tutorial: Track a web app outage using Change Analysis](change/change-analysis-track-outages.md)|Add note to AzMon Change Analysis documentation to point users to the new ARG Change Analysis public preview, which will replace AzMon Change Analysis in GA.|
|Change-Analysis|[Troubleshoot Azure Monitor's Change Analysis](change/change-analysis-troubleshoot.md)|Add note to AzMon Change Analysis documentation to point users to the new ARG Change Analysis public preview, which will replace AzMon Change Analysis in GA.|
|Change-Analysis|[Use Change Analysis in Azure Monitor](change/change-analysis.md)|Add note to AzMon Change Analysis documentation to point users to the new ARG Change Analysis public preview, which will replace AzMon Change Analysis in GA.|
|Containers|[Data transformations in Container insights](containers/container-insights-transformations.md)|Fixed syntax errors in transformation examples.|
|Containers|[Recommended alert rules for Kubernetes clusters](containers/kubernetes-metric-alerts.md)|Updated to include new portal experience for enabling Prometheus alerts.|
|Containers|[Customize scraping of Prometheus metrics in Azure Monitor managed service for Prometheus](containers/prometheus-metrics-scrape-configuration.md)|Updated basic authentication|
|Containers|[Argo CD](containers/prometheus-argo-cd-integration.md)|Argo CD  Prometheus integration|
|Containers|[Elasticsearch](containers/prometheus-elasticsearch-integration.md)|Elastic search Prometheus integration|
|Containers|[Apache Kafka](containers/prometheus-kafka-integration.md)|Kafka Prometheus integration|
|Essentials|[Data collection rules in Azure Monitor](essentials/data-collection-rule-overview.md)|Rewritten for consistency with new Azure Monitor pipeline content.|
|Essentials|[Configuration of Azure Monitor edge pipeline](essentials/edge-pipeline-configure.md)|New article for edge pipeline.|
|Essentials|[Overview of Azure Monitor pipeline](essentials/pipeline-overview.md)|New article to introduce Azure Monitor pipeline, which includes edge pipeline and cloud pipeline.|
|Essentials|[Azure Monitor metrics explorer with PromQL (Preview)](essentials/metrics-explorer.md)|New metrics explorer with PromQL support for Azure Monitor workspaces.|
|Essentials|[Send Prometheus metrics from Virtual Machines to an Azure Monitor workspace](essentials/prometheus-remote-write-virtual-machines.md)|How to send prometheus metrics from a Virtual machine or Virtual Machine Scale Set.|
|General|[Azure Monitor data sources and data collection methods](data-sources.md)|We've edited the article describing the Azure Monitor data sources  to be more consistent with the overall Azure Monitor story.|
|General|[Azure Monitor cost and usage](cost-usage.md)|Updated information about costs associated with Azure Migrate.|
|General|[Azure Monitor monitoring data reference](monitor-azure-monitor-reference.md)|Updated to list the latest metrics, log categories, and Log Analytics tables related to monitoring Azure Monitor.|
|General|[Monitor Azure Monitor](monitor-azure-monitor.md)|How to monitor Azure Monitor article updated to list all the ways you can monitor parts of Azure Monitor. |
|Logs|[Azure Monitor customer-managed key](logs/customer-managed-keys.md)|Updated the management API versions used for managing customer managed keys and dedicated clusters.|

## March 2024

|Subservice | Article | Description |
|---|---|---|
|Alerts|[Improve the reliability of your application by using Azure Advisor](../../articles/advisor/advisor-high-availability-recommendations.md)|We’ve updated the alerts troubleshooting articles to remove out of date content and include common support issues.|
|Application-Insights|[Enable Azure Monitor OpenTelemetry for .NET, Node.js, Python, and Java applications](app/opentelemetry-enable.md)|OpenTelemetry sample applications are now provided in a centralized location.|
|Application-Insights|[Migrate to workspace-based Application Insights resources](/previous-versions/azure/azure-monitor/app/convert-classic-resource)|Classic Application Insights resources have been retired. For more information, see this article for migration information and frequently asked questions.|
|Application-Insights|[Sampling overrides - Azure Monitor Application Insights for Java](app/java-standalone-sampling-overrides.md)|The sampling overrides feature has reached general availability (GA), starting from 3.5.0.|
|Containers|[Configure data collection and cost optimization in Container insights using data collection rule](containers/container-insights-data-collection-dcr.md)|Updated to include new Logs and Events cost preset.|
|Containers|[Enable private link with Container insights](containers/container-insights-private-link.md)|Updated with ARM templates.|
|Essentials|[Data collection rules in Azure Monitor](essentials/data-collection-rule-overview.md)|Rewritten to consolidate previous data collection article.|
|Essentials|[Workspace transformation data collection rule (DCR) in Azure Monitor](essentials/data-collection-transformations-workspace.md)|Content moved to a new article dedicated to workspace transformation DCR.|
|Essentials|[Data collection transformations in Azure Monitor](essentials/data-collection-transformations.md)|Rewritten to remove redundancy and make the article more consistent with related articles.|
|Essentials|[Create and edit data collection rules (DCRs) in Azure Monitor](essentials/data-collection-rule-create-edit.md)|Updated API version in REST API calls.|
|Essentials|[Tutorial: Edit a data collection rule (DCR)](essentials/data-collection-rule-edit.md)|Updated API version in REST API calls.|
|Essentials|[Monitor and troubleshoot DCR data collection in Azure Monitor](essentials/data-collection-monitor.md)|New article documenting new DCR monitoring feature.|
|Logs|[Monitor Log Analytics workspace health](logs/log-analytics-workspace-health.md)|Added new metrics for monitoring data export from a Log Analytics workspace.|
|Logs|[Set a table's log data plan to Basic or Analytics](logs/logs-table-plans.md)|Azure Databricks logs tables now support the basic logs data plan.|

## February 2024

|Subservice | Article | Description |
|---|---|---|
|Agents|[Manage Azure Monitor Agent](agents/azure-monitor-agent-manage.md)|Added Azure Monitor Agent disk space requirements.|
|Alerts|[Monitor the health of log search alert rules](alerts/log-alert-rule-health.md)|Added documentation for new feature - resource health for log search alert rules.|
|Application-Insights|[Failures and Performance views](app/failures-and-performance-views.md)|A new article was added with current information on both the Performance and Failures views.|
|Application-Insights|[Release and work item insights](app/release-and-work-item-insights.md)|We've modified our Annotations script to support unicode characters.|
|Application-Insights|[Migrate to workspace-based Application Insights resources](/previous-versions/azure/azure-monitor/app/convert-classic-resource)|The FAQ section was updated with information on what happens if you choose not to manually migrate and similar question/answer pairs related to Classic App Insights resource retirement.|
|Containers|[Transition from the Container Monitoring Solution to using Container Insights](containers/container-insights-transition-solution.md)|Changed date for Container Monitoring Solution retirement.|
|Essentials|[Create alert rules for Azure resources](alerts/alert-options.md)|New article summarizing alert options including Azure Monitor Baseline Alerts (AMBA).|
|Essentials|[Structure of transformation in Azure Monitor](essentials/data-collection-transformations-structure.md)|Added |
|General|[Sources of monitoring data for Azure Monitor and their data collection methods](data-sources.md)|Rewritten to simplify list of Azure Monitor data sources.|
|Logs|[Logs Ingestion API in Azure Monitor](logs/logs-ingestion-api-overview.md)|Add new tables that now support ingestion time transformations.|
|Logs|[Plan alerts and automated actions](alerts/alerts-plan.md)|The Getting Started section was edited to make the documentation cleaner and more efficient.|
|Logs|[Enhance data and service resilience in Azure Monitor Logs with availability zones](logs/availability-zones.md)|Updated the list of supported regions for Availability Zones.|
|Logs|[Set a table's log data plan to Basic or Analytics](logs/logs-table-plans.md)|Bare Metal Machines and Microsoft Graph tables now support Basic logs.|
|Virtual-Machines|[Monitor virtual machines with Azure Monitor](vm/monitor-virtual-machine.md)|Added information on using Performance Diagnostics to troubleshoot performance issues on Windows or Linux virtual machines.|

## January 2024

|Subservice | Article | Description |
|---|---|---|
|Agents|[MMA Discovery and Removal Utility](agents/azure-monitor-agent-mma-removal-tool.md)|Added a PowerShell script that discovers and removes the Log Analytics agent from machines as part of the migration to Azure Monitor Agent.|
|Agents|[Send data to Event Hubs and Storage (Preview)](agents/azure-monitor-agent-send-data-to-event-hubs-and-storage.md)|Update azure-monitor-agent-send-data-to-event-hubs-and-storage.md|
|Alerts|[Resource Manager template samples for metric alert rules in Azure Monitor](alerts/resource-manager-alerts-metric.md)|We added a clarification about the parameters used when creating metric alert rules programatically.|
|Alerts|[Manage your alert instances](alerts/alerts-manage-alert-instances.md)|We've added documentation about the new alerts timeline view.|
|Alerts|[Create or edit a log search alert rule](alerts/alerts-create-log-alert-rule.md)|Added limitations to log search alert queries.|
|Alerts|[Create or edit a log search alert rule](alerts/alerts-create-log-alert-rule.md)|We've added samples of log search alert rule queries that use Azure Data Explorer and Azure Resource Graph.|
|Application-Insights|[Data Collection Basics of Azure Monitor Application Insights](app/opentelemetry-overview.md)|We've provided information on how to get a list of Application Insights SDK versions and their names.|
|Application-Insights|[Application Insights logging with .NET](app/ilogger.md)|We've clarified steps to view ILogger telemetry.|
|Application-Insights|[Migrate to workspace-based Application Insights resources](/previous-versions/azure/azure-monitor/app/convert-classic-resource)|The script to discover classic resources has been updated.|
|Application-Insights|[Migrate to workspace-based Application Insights resources](/previous-versions/azure/azure-monitor/app/convert-classic-resource)|Extra details are now available on migrating from Continuous Export to Diagnostic Settings.|
|Application-Insights|[Telemetry processors (preview) - Azure Monitor Application Insights for Java](app/java-standalone-telemetry-processors.md)|Sample metrics filters have been added.|
|Application-Insights|[Log-based and preaggregated metrics in Application Insights](app/pre-aggregated-metrics-log-metrics.md)|We've clarified how custom metrics work.|
|Containers|[Default Prometheus metrics configuration in Azure Monitor](containers/prometheus-metrics-scrape-default.md)|Added default targets for Control Plane to minimal ingestion profile|
|Containers|[Azure Monitor features for Kubernetes monitoring](containers/container-insights-overview.md)|Rewritten to focus on role of log collection and added agent details.|
|Containers|[Configure data collection in Container insights using ConfigMap](containers/container-insights-data-collection-configmap.md)|New article to consolidate ConfigMap configuration of all cluster configurations.|
|Containers|[Configure data collection in Container insights using data collection rule](containers/container-insights-data-collection-dcr.md)|New article to consolidate DCR configuration of all cluster configurations.|
|Containers|[Container insights log schema](containers/container-insights-logs-schema.md)|Combine Prometheus and Container insights|
|Containers|[Enable monitoring for Kubernetes clusters](containers/container-insights-enable-aks.md)|New article to consolidate onboarding process for all container configurations and for both Prometheus and Container insights.|
|Containers|[Customize scraping of Prometheus metrics in Azure Monitor managed service for Prometheus](containers/prometheus-metrics-scrape-configuration.md)|[Azure Monitor Managed Prometheus] Docs for pod annotation scraping through configmap|
|Essentials|[Custom metrics in Azure Monitor (preview)](essentials/metrics-custom-overview.md)|Article refreshed an updated|
|General|[Disable monitoring of your Kubernetes cluster](containers/kubernetes-monitoring-disable.md)|New article to consolidate process for all container configurations and for both Prometheus and Container insights.|
|Logs|[Best practices for Azure Monitor Logs](best-practices-logs.md)|Dedicated clusters are now available in all commitment tiers, with a minimum daily ingestion of 100 GB.|
|Logs|[Enhance data and service resilience in Azure Monitor Logs with availability zones](logs/availability-zones.md)|Availability zones are now supported in the Israel Central, Poland Central, and Italy North regions.|
|Virtual-Machines|[Dependency Agent](vm/vminsights-dependency-agent-maintenance.md)|VM Insights Dependency Agent now supports RHEL 8.6 Linux.|
|Visualizations|[Composite bar renderer](visualize/workbooks-composite-bar.md)|We've edited the Workbooks content to make some features and functionality easier to find based on customer feedback. We've also removed legacy content.|

## [2023](#tab/2023)

## December 2023

|Subservice | Article | Description |
|---|---|---|
Alerts|[Noncommon alert schema definitions](alerts/alerts-non-common-schema-definitions.md)|Added recommendation for using the common schema|
Alerts|[Create a metric alert in Azure Monitor Logs](alerts/alerts-metric-logs.md)|Add recommendations for alerting at scale|
Alerts|[Create or edit an activity log, service health, or resource health alert rule](alerts/alerts-create-activity-log-alert-rule.md)|Restructured articles about creating new alert rules for better clarity. There are now separate articles dedicated to each alert rule type, and dedicated articles for specific alert rule configurations.|
Alerts|[Create or edit a metric alert rule](alerts/alerts-create-new-alert-rule.md)|Added limitations for use of custom properties in alert rules. Added list of query plugins not supported by log alert rule queries.|
Application-Insights|[Add, modify, and filter OpenTelemetry](app/opentelemetry-add-modify.md)|Custom events code samples and instructions have been added to .NET Core / .NET tabs.|
Application-Insights|[Migrate availability tests](app/availability-test-migration.md)|We've clarified the URL ping tests retirement statement. Migrate your URL ping tests as soon as possible using the PowerShell scripts provided in this article.|
Application-Insights|[Enable Azure Monitor Application Insights Real User Monitoring](app/javascript-sdk.md)|More guidance has been added on when to use the npm package.|
Application-Insights|[Migrate to workspace-based Application Insights resources](/previous-versions/azure/azure-monitor/app/convert-classic-resource)|We confirmed that migrating from classic to workspace-based resources doesn't introduce application downtime or restarts, and it doesn't change your existing instrumentation key or connection string.|
Logs|[Correlate data in Azure Data Explorer and Azure Resource Graph with data in a Log Analytics workspace](logs/azure-monitor-data-explorer-proxy.md)|Explained how to query Azure Data Explorer external tables using the `adx("")` expression. |
Logs|[Logs Ingestion API in Azure Monitor](logs/logs-ingestion-api-overview.md)|Updated Log Ingestion API version.|
Profiler|[Profile production applications in Azure with Application Insights Profiler](profiler/profiler-overview.md)|Add support for Java profiler and link to docs from .NET profiler overview.|
Virtual-Machines|[Enable VM insights by using PowerShell](vm/vminsights-enable-powershell.md)|Enable VM insights with Azure monitor agent by using PowerShell|

## November 2023

|Subservice | Article | Description |
|---|---|---|
Agents|[Migrate to Azure Monitor Agent from Log Analytics agent](agents/azure-monitor-agent-migration.md)|Container Insights is now generally available with Azure Monitor Agent.|
Agents|[Azure Monitor Agent overview](agents/agents-overview.md)|Azure Monitor Agent now supports AlmaLinux 9, Oracle Linux 9, and Rocky Linux 9.|
Alerts|[Create or edit an alert rule](alerts/alerts-create-new-alert-rule.md)|Added limitations of stateful log alerts.|
Alerts|[Troubleshoot Azure Monitor metric alerts](alerts/alerts-troubleshoot-metric.md)|Documented network error that can occur if you create a metric alert rule that uses a large number of dimensions, creating a payload that is too large for the network. We also documented possible workarounds for this issue.|
Alerts|[Create a metric alert with dynamic thresholds](alerts/alerts-dynamic-thresholds.md)|We restructured the section on Azure Monitor alerts, so that the content is more easily findable and usable.|
Alerts|[Create or edit an alert rule](alerts/alerts-create-new-alert-rule.md)|Corrected information about dimensions. Dimensions are retrieved from the last 24 hours, not 48 hours.|
Alerts|[Connect Azure to ITSM tools by using IT Service Management](alerts/itsmc-definition.md)|Added documentation to note that as of October 2023, we don't support the using ITSM actions to send alerts and events to ServiceNow in the Azure portal.|
Alerts|[Create or edit an alert rule](alerts/alerts-create-new-alert-rule.md)|When you create a log alert rule, if you're querying an ADX or ARG cluster, the data sources accessed by the query, must have the Reader role.|
Application-Insights|[Application Insights overview](app/app-insights-overview.md)|OpenTelemetry for .NET Core reached general availability and is now fully supported.|
Application-Insights|[Enable Azure Monitor OpenTelemetry for .NET, Node.js, Python and Java applications](app/opentelemetry-enable.md)|Our OpenTelemetry FAQ section has been updated to reflect the general availability status of OpenTelemetry for .NET Core.|
Application-Insights|[Monitor your Node.js services and apps with Application Insights](app/nodejs.md)|A dedicated troubleshooting article is now available to assist with issues related to monitoring Node.js apps.|
Application-Insights|[Application Insights availability tests](app/availability-overview.md)|We enabled TLS 1.3 in Availability Tests and updated our troubleshooting information.|
Containers|[Data transformations in Container insights](containers/container-insights-transformations.md)|New article describes how to transform data using a DCR transformation in Container insights|
Containers|[Enable Container insights](containers/container-insights-onboard.md)|New article: Enable private link with Container insights|
Essentials|[Azure Monitor managed service for Prometheus rule groups](essentials/prometheus-rule-groups.md)|Create or edit Prometheus rule group in the Azure portal (preview)|
Logs|[Detect and mitigate potential issues using AIOps and machine learning in Azure Monitor](logs/aiops-machine-learning.md)|Microsoft Copilot in Azure now helps you write KQL queries to analyze data and troubleshoot issues based on prompts, such as "Are there any errors in container logs?". |
Logs|[Best practices for Azure Monitor Logs](./best-practices-logs.md)|More guidance on Azure Monitor Logs features that provide enhanced resilience.|
Logs|[Data retention and archive in Azure Monitor Logs](logs/data-retention-configure.md)|Azure Monitor Logs extended archiving of data to up to 12 years.|
Logs|[Set a table's log data plan to Basic or Analytics](logs/logs-table-plans.md)|Added Basic logs support for Network managers tables.|
Virtual-Machines|[Enable VM insights in the Azure portal](vm/vminsights-enable-portal.md)|Azure portal no longer supports enabling VM insights using Log Analytics agent.|
Virtual-Machines|[Azure Monitor SCOM Managed Instance](vm/scom-managed-instance-overview.md)|Azure Monitor SCOM Managed Instance is now generally available.|
Visualizations|[Azure Workbooks](visualize/workbooks-overview.md)|We clarified that when you're viewing Azure workbooks, you can see all of the workbooks that are in your current view. In order to see all of your existing workbooks of any kind, you must Browse across galleries. |

## October 2023

|Subservice | Article | Description |
|---|---|---|
General|[Best practices for monitoring Kubernetes with Azure Monitor](best-practices-containers.md)|New article.|
General|[Estimate Azure Monitor costs](cost-estimate.md)|New article describing use of Azure Monitor pricing calculator.|
General|[Azure Monitor billing meter names](cost-meters.md)|Billing meters moved into dedicated reference article.|
General|[Azure Monitor cost and usage](cost-usage.md)|Rewritten.|
Agents|[Collect logs from a text or JSON file with Azure Monitor Agent](agents/data-collection-text-log.md)|Added the ability to collect logs from a JSON file with Azure Monitor Agent.|
Alerts|[Create or edit an alert rule](alerts/alerts-create-new-alert-rule.md)|Custom properties for Azure Monitor alerts are now located in the Details tab when creating or editing  an alert rule. |
Alerts|[Create or edit an alert rule](alerts/alerts-create-new-alert-rule.md)|Added note clarifying the limitations of setting the frequency of alert rules to one minute. |
Application-Insights|[IP addresses used by Azure Monitor](app/ip-addresses.md)|A logic model diagram is available to assist with troubleshooting scenarios.|
Application-Insights|[Application Insights Overview dashboard](app/overview-dashboard.md)|All of the Application Insights experiences are now defined in a manner that mirrors the Azure portal experience. We've included a logic model diagram to visually convey how Application Insights works at a high level.|
Application-Insights|[Enable Azure Monitor OpenTelemetry for .NET, Node.js, Python, and Java applications](app/opentelemetry-enable.md)|Our OpenTelemetry Distro released for .NET, Java, Python, and Node.js. This is a replacement for classic Application Insights SDKs.|
Essentials|[Collect IIS logs with Azure Monitor Agent](agents/data-collection-iis.md)|Added guidance on setting up data collection endpoints based on deployment.|
Logs|[Restore logs in Azure Monitor](logs/restore.md)|Updated information about the cost of restoring logs. |
Logs|[Log Analytics workspace data export in Azure Monitor](logs/logs-data-export.md)|Billing for Data Export was enabled in early October 2023.|
Logs|[Analyze usage in a Log Analytics workspace](logs/analyze-usage.md)|Added support for querying data volume from events directly, and by computer.|

## September 2023

|Subservice | Article | Description |
|---|---|---|
Agents|[Define Azure Monitor Agent network settings](agents/azure-monitor-agent-data-collection-endpoint.md)|Added an example of Azure Monitor Agent deployment with an Azure Resource Manager policy template.|
Agents|[Migrate to Azure Monitor Agent from Log Analytics agent](agents/azure-monitor-agent-migration.md)|VM Insights with Azure Monitor Agent is now generally available.|
Alerts|[Manage your alert instances](alerts/alerts-manage-alert-instances.md)|Updated  documentation to clarify that  Azure Monitor alerts are stored for 30 days and are deleted after the 30-day retention period. For stateful alerts, while the alert itself is deleted after 30 days, and isn't viewable on the alerts page, the alert condition is stored until the alert is resolved, to prevent firing another alert, and so that notifications can be sent when the alert is resolved.|
Alerts|[Troubleshooting problems in Azure Monitor alerts](alerts/alerts-troubleshoot.md)|Added a new article describing the process for migrating from the alertsSummary API, which is being deprecated in September 2026. You can use Azure Resource Graph's functionality to get the same information returned by the alertsSummary API.|
Alerts|[Troubleshoot log alerts in Azure Monitor](alerts/alerts-troubleshoot-log.md)|Added clarification about the limitations of the override time query setting when creating a new alert rule. The alert time range is limited to a maximum of two days, no matter what override time is set in the query.|
Application-Insights|[Migrate availability tests](app/availability-test-migration.md)|Updated PowerShell script for quick migration of URL Ping Tests to Standard Tests.|
Application-Insights|[Application Insights overview](app/app-insights-overview.md)|We've updated the Supported Languages section to provide more information about the OpenTelemetry Distro.|
Application-Insights|[Migrating from OpenCensus Python SDK and Azure Monitor OpenCensus exporter for Python to Azure Monitor OpenTelemetry Python Distro](app/opentelemetry-python-opencensus-migrate.md)|Follow this guide to migrate Python apps from OpenCensus solutions to the OpenTelemetry Distro.|
Application-Insights|[Enable Azure Monitor OpenTelemetry for .NET, Node.js, Python and Java applications](app/opentelemetry-enable.md)|The OpenTelemetry Distro is fully released and generally available for Node.js, Python, and Java. An OpenTelemetry Exporter is also released and generally available for .NET and .NET Core.|
Application-Insights|[What is autoinstrumentation for Azure Monitor Application Insights?](app/codeless-overview.md)|Automatic instrumentation, which enables Application Insights without code changes, is now released and generally available for App Service on Linux - Publish as Docker.|
Containers|[Migrate from ContainerLog to ContainerLogV2](containers/container-insights-v2-migration.md)|New article.|
Containers|[Configure remote write for Azure managed service for Prometheus using Azure Active Directory workload identity (preview)](containers/prometheus-remote-write-azure-workload-identity.md)|New article Configure remote write for Azure Monitor managed service …|
Essentials|[Migrate from diagnostic settings storage retention to Azure Storage lifecycle management](essentials/migrate-to-azure-storage-lifecycle-policy.md)|Added CLI and template tabs showing storage lifecycle setting.|
General|[Plan your alerts and automated actions](alerts/alerts-plan.md)|Add alerts best practices article|
General|[Azure Monitor cost and usage](cost-usage.md)|Updated information about the Cost Analysis usage report which contains both the cost for your usage, and the number of units of usage. You can use this export to see the amount of benefit you're receiving from various offers such as the [Defender for Servers data allowance](logs/cost-logs.md#workspaces-with-microsoft-defender-for-cloud) and the [Microsoft Sentinel benefit for Microsoft 365 E5, A5, F5, and G5 customers](https://azure.microsoft.com/offers/sentinel-microsoft-365-offer/). |
Logs|[Send log data to Azure Monitor by using the HTTP Data Collector API (deprecated)](logs/data-collector-api.md)|Added deprecation notice.|
Logs|[Azure Monitor Logs overview](logs/data-platform-logs.md)|Added code samples for the Azure Monitor Ingestion client module for Go.|
Logs|[Set a table's log data plan to Basic or Analytics](logs/logs-table-plans.mdVirtual Network Manager,  Dev Center, and Communication Services tables that now support Basic logs.|

## August 2023

|Subservice| Article | Description |
|---|---|---|
General|[Azure Monitor cost and usage](cost-usage.md)|Added section detailing billing meter names.|
Application-Insights|[Add, modify, and filter OpenTelemetry](app/opentelemetry-add-modify.md)|A caution has been added about using community libraries with additional information on how to request we include them in our distro.|
Application-Insights|[Add, modify, and filter OpenTelemetry](app/opentelemetry-add-modify.md)|Support and feedback options are now available across all of our OpenTelemetry pages.|
Application-Insights|[How many Application Insights resources should I deploy?](app/create-workspace-resource.md#how-many-application-insights-resources-should-i-deploy)|We added an important warning about additional network costs when monitoring across regions.|
Application-Insights|[Use Search in Application Insights](app/transaction-search-and-diagnostics.md?tabs=transaction-search)|We clarified that URL query strings aren't logged by Azure Functions and that URL query strings won't show up in searches.|
Application-Insights|[Migrating from OpenCensus Python SDK and Azure Monitor OpenCensus exporter for Python to Azure Monitor OpenTelemetry Python Distro](app/opentelemetry-python-opencensus-migrate.md)|Migrate from OpenCensus to OpenTelemetry with this step-by-step guidance.|
Application-Insights|[Application Insights overview](app/app-insights-overview.md)|We've added an illustration to convey how Azure Monitor Application Insights works at a high level.|
Containers|[Troubleshoot collection of Prometheus metrics in Azure Monitor](containers/prometheus-metrics-troubleshoot.md)|Added the *Troubleshoot using PowerShell script* section.|
Containers|[Monitor Kubernetes clusters using Azure services and cloud native tools](containers/monitor-kubernetes.md)|Updated previous scenario for hybrid Kubernetes clusters and managed Prometheus.|
Containers|[Monitor Azure Kubernetes Service (AKS)](/azure/aks/monitor-aks)|New article providing simplified introduction to monitoring AKS cluster.|
Containers|[Container insights overview](containers/container-insights-overview.md)|Rewritten for to include new features and managed services.|
Essentials|[Send Prometheus metrics to Log Analytics workspace with Container insights](containers/container-insights-prometheus-logs.md)|Updated to simplify article to only legacy method of sending Prometheus metrics to Log Analytics workspace.|
Essentials|[Collect Prometheus metrics from an AKS cluster](containers/kubernetes-monitoring-enable.md#enable-prometheus-and-grafana)|Updated to include additional onboarding methods.|
Essentials|[Azure Monitor managed service for Prometheus rule groups](essentials/prometheus-rule-groups.md)|Expanded "Limiting rules to a specific cluster"|
Logs|[Enable cost optimization settings](containers/container-insights-cost-config.md)|Updated for portal updates and additional details on workspace tables.|
Logs|[Enable the ContainerLogV2 schema](containers/container-insights-logs-schema.md)|Updated configuration section.|
Logs|[Manage access to Log Analytics workspaces](logs/manage-access.md)|Simplified flow for setting table-level access.|
Logs|[Query data in Azure Data Explorer and Azure Resource Graph from Azure Monitor](logs/azure-monitor-data-explorer-proxy.md)|Azure Monitor now lets you query data in Azure Resource Graph from your Log Analytics workspace. |

## July 2023

|Subservice| Article | Description |
|---|---|---|
Agents|[Azure Monitor Agent Health (Preview)](agents/azure-monitor-agent-health.md)|Introduced a new Azure Monitor Agent Health workbook, which monitors the health of agents deployed across your organization. |
Alerts|[Manage your alert instances](alerts/alerts-manage-alert-instances.md)|View alerts as a timeline (preview)|
Alerts|[Upgrade to the Scheduled Query Rules API from the legacy Log Analytics alerts API](alerts/alerts-log-api-switch.md)|Changes to the log alert rule creation experience|
Application-Insights|[Migrate to workspace-based Application Insights resources](/previous-versions/azure/azure-monitor/app/convert-classic-resource)|We now support migrating classic components to workspace-based components via PowerShell cmdlet. |
Application-Insights|[EventCounters introduction](app/eventcounters.md)|Code samples have been provided for the latest .NET versions.|
Application-Insights|[Enable a framework extension for Application Insights JavaScript SDK](app/javascript-framework-extensions.md)|We've added a section for the React Native Manual Device Plugin, and clarified exception tracking and device info collection.|
Application-Insights|[Migrate availability tests](app/availability-test-migration.md)|Migrate your classic URL ping tests to the new standard availability tests using this prescriptive guidance.|
Application-Insights|[Enable a framework extension for Application Insights JavaScript SDK](app/javascript-framework-extensions.md)|The  'What does the plug-in enable?' and 'Add configuration' sections have been rewritten to align across all of our JavaScript documentation.|
Application-Insights|[Microsoft Azure Monitor Application Insights JavaScript SDK configuration](app/javascript-sdk-configuration.md)|The  'What does the plug-in enable?' and 'Add configuration' sections have been rewritten to align across all of our JavaScript documentation.|
Application-Insights|[Enable Azure Monitor OpenTelemetry for .NET, Node.js, Python and Java applications](app/opentelemetry-enable.md)|Clarification of the term "Distro" has been provided.|
Application-Insights|[Data Collection Basics of Azure Monitor Application Insights](app/opentelemetry-overview.md)|We've added a new article to clarify both manual and automatic instrumentation options to enable Application Insights.|
Application-Insights|[Enable a framework extension for Application Insights JavaScript SDK](app/javascript-framework-extensions.md)|The "Explore your data" section has been improved.|
Application-Insights|[Sampling overrides (preview) - Azure Monitor Application Insights for Java](app/java-standalone-sampling-overrides.md)|We've documented steps for troubleshooting sampling.|
Logs|[Set a table's log data plan to Basic or Analytics](logs/logs-table-plans.md)|Additional Azure tables now support low-cost basic logs, including tables for the Bare Metal Machines, Managed Lustre, Nexus Clusters, and Nexus Storage Appliances services. |
Logs|[Query Basic Logs in Azure Monitor](logs/basic-logs-query.md)|Basic log queries are now billable.|
Logs|[Restore logs in Azure Monitor](logs/restore.md)|Restored logs are now billable.|
Logs|[Run search jobs in Azure Monitor](logs/search-jobs.md)|Search jobs are now billable.|
Logs|[Tutorial: Ingest events from Azure Event Hubs into Azure Monitor Logs (Preview)](logs/ingest-logs-event-hub.md)|New article that explains how to ingest data directly from Azure Event Hubs, Azure's big data streaming platform, into Azure Monitor Logs.|
Optimization-Insights|[Monitor and analyze runtime behavior with Code Optimizations (Preview)](insights/code-optimizations.md)|PM added a demo video for Code Optimizations|
Virtual-Machines|[Migrate from deprecated VM insights policies](vm/vminsights-migrate-deprecated-policies.md)|We're deprecating the VM insights DCR deployment policies and replacing them with new policies because of a race condition issue. This article explains how to migrate from deprecated VM insights policies to their replacement policies.|

## June 2023

|Subservice| Article | Description |
|---|---|---|
General|[What's new in Azure Monitor documentation](whats-new.md)| Subscribe to "What's New" using the new RSS link|
Application-Insights|[Filter and preprocess telemetry in the Application Insights SDK](app/api-filtering-sampling.md)|An Azure Monitor Telemetry Data Types Reference has been added for quick reference.|
Application-Insights|[Add and modify OpenTelemetry](app/opentelemetry-add-modify.md)|We've simplified the OpenTelemetry onboarding process by moving instructions to add and modify telemetry in this new document.|
Application-Insights|[Application Map: Triage distributed applications](app/app-map.md)|Application Map Intelligent View has reached general availability. Enjoy this powerful tool that harnesses machine learning to aid in service health investigations.|
Application-Insights|[Usage analysis with Application Insights](app/usage.md)|Code samples have been updated for the latest versions of .NET.|
Application-Insights|[Enable a framework extension for Application Insights JavaScript SDK](app/javascript-framework-extensions.md)|All JavaScript SDK documentation has been updated and simplified, including documentation for feature and framework extensions.|
Autoscale|[Use autoscale actions to send email and webhook alert notifications in Azure Monitor](autoscale/autoscale-webhook-email.md)|Article updated and refreshed|
Containers|[Query logs from Container insights](containers/container-insights-log-query.md#container-logs)|New section: Container logs, with sample queries|
Containers|[Authentication for Container Insights](containers/container-insights-authentication.md)|New article: Configure agent authentication for the Container Insights agent|
Essentials|[Azure monitoring REST API walkthrough](essentials/rest-api-walkthrough.md)|Added multi resource request examples|
Essentials|[Azure Monitor managed service for Prometheus rule groups](essentials/prometheus-rule-groups.md)| Added CLI & PowerShell reference and examples|
Logs|[Set up resources required to send data to Azure Monitor Logs using the Logs Ingestion API](logs/set-up-logs-ingestion-api-prerequisites.md)|New article. Run a PowerShell script to set up resources required to send data to Azure Monitor using the Logs Ingestion API.|
Logs|[Migrate from the HTTP Data Collector API to the Log Ingestion API to send data to Azure Monitor Logs](logs/custom-logs-migrate.md)|Updated guidance for migrating from the legacy Azure Monitor Data Collector API to the Log Ingestion API.|
Logs|[Detect and mitigate potential issues using AIOps and machine learning in Azure Monitor](logs/aiops-machine-learning.md)|New article. Lists Azure Monitor AIOps features and explains how to implement a machine learning pipeline on data in Azure Monitor Logs.|
Logs|[Tutorial: Analyze data in Azure Monitor Logs using a notebook](logs/notebooks-azure-monitor-logs.md)|New tutorial. Explains how to integrate a notebook with a Log Analytics workspace to create a machine learning pipeline or perform advanced analysis on data in Azure Monitor Logs. |
Virtual-Machines|[Tutorial: Create availability alert rule for multiple Azure virtual machines (preview)](vm/tutorial-monitor-vm-alert-availability.md)|New article with consolidated list of best practices for monitoring VMs organized by WAF pillar.|

## May 2023

|Subservice| Article | Description |
|---|---|---|
Agents|[Azure Monitor Agent overview](agents/agents-overview.md)|MMA AMA migration update|
Agents|[Azure Monitor Agent overview](agents/agents-overview.md)|Azure Monitoring Agent for Linux now officially supports various hardening standards for Linux operating systems and distros.|
Agents|[Migrate from MMA custom text log to AMA DCR based custom text logs](agents/azure-monitor-agent-custom-text-log-migration.md)|New article that explains how to migrate from the HTTP Data Collector API to the Log Ingestion API.|
Agents|[Azure Monitor Agent overview](agents/agents-overview.md)|Azure Monitor Agent now supports Azure Stack HCI. |
Alerts|[Create a new alert rule](alerts/alerts-create-new-alert-rule.md)|Log alert rules support using managed identities to send the log query.|
Alerts|[Monitor Azure AD B2C with Azure Monitor](/azure/active-directory-b2c/azure-monitor)|Articles on action groups have been updated.|
Alerts|[Create a new alert rule](alerts/alerts-create-new-alert-rule.md)|Alert rules that use action groups support custom properties to add custom information to the alert notification payload.|
Application-Insights|[Feature extensions for the Application Insights JavaScript SDK (Click Analytics)](app/javascript-feature-extensions.md)|Most of our JavaScript SDK documentation has been updated and overhauled.|
Application-Insights|[Analyze product usage with HEART](app/usage.md#heart---five-dimensions-of-customer-experience)|Updated and overhauled HEART framework documentation.|
Application-Insights|[Dependency tracking in Application Insights](app/asp-net-dependencies.md)|All new documentation supports the Azure Monitor OpenTelemetry Distro public preview release announced on May 10, 2023. [Public Preview: Azure Monitor OpenTelemetry Distro for ASP.NET Core, JavaScript (Node.js), Python](https://azure.microsoft.com/updates/public-preview-azure-monitor-opentelemetry-distro-for-aspnet-core-javascript-nodejs-python)|
Application-Insights|[Application Monitoring for Azure App Service and Java](app/azure-web-apps-java.md)|Added CATALINA_OPTS for Tomcat.|
Essentials|[Configure remote write for Azure Monitor managed service for Prometheus using Microsoft Azure Active Directory pod identity (preview)](essentials/prometheus-remote-write-azure-ad-pod-identity.md)|New article: Configure remote write for Azure Monitor managed service for Prometheus using Microsoft Azure Active Directory pod identity|
Essentials|[Use private endpoints for Managed Prometheus and Azure Monitor workspace](essentials/azure-monitor-workspace-private-endpoint.md)|New article: Use private endpoints for Managed Prometheus and Azure Monitor workspace|
Essentials|[Private Link for data ingestion for Managed Prometheus and Azure Monitor workspace](essentials/private-link-data-ingestion.md)|New article: Private Link for data ingestion for Managed Prometheus and Azure Monitor workspace|
Essentials|[Collect Prometheus metrics from an Arc-enabled Kubernetes cluster (preview)](essentials/prometheus-metrics-from-arc-enabled-cluster.md)|New article: Collect Prometheus metrics from an Arc-enabled Kubernetes cluster (preview)|
Essentials|[How to migrate from the metrics API to the getBatch API](essentials/migrate-to-batch-api.md)|Migrate from the metrics API to the getBatch API|
Essentials|[Azure Active Directory authorization proxy](essentials/prometheus-authorization-proxy.md)|Microsoft Azure Active Directory (Azure AD) auth proxy|
Essentials|[Integrate KEDA with your Azure Kubernetes Service cluster](essentials/integrate-keda.md)|New Article: Integrate KEDA with AKS and Prometheus|
Essentials|[General Availability: Azure Monitor managed service for Prometheus](https://techcommunity.microsoft.com/t5/azure-observability-blog/general-availability-azure-monitor-managed-service-for/ba-p/3817973)|General Availability: Azure Monitor managed service for Prometheus |
Insights|[Monitor and analyze runtime behavior with Code Optimizations (Preview)](insights/code-optimizations.md)|New doc for public preview release of Code Optimizations feature.|
Logs|[Set a table's log data plan to Basic or Analytics](logs/logs-table-plans.md)|Added Azure Active Directory, Communication Services, Container Apps Environments, and Data Manager for Energy to the list of tables that support Basic logs.|
Logs|[Export data from a Log Analytics workspace to a storage account by using Logic Apps](logs/logs-export-logic-app.md)|Added an Azure Resource Manager template for exporting data from a Log Analytics workspace to a storage account by using Logic Apps.|
Logs|[Set daily cap on Log Analytics workspace](logs/daily-cap.md)|Starting September 18, 2023, the Log Analytics Daily Cap will no longer exclude a set of data types from the daily cap, and all billable data types will be capped if the daily cap is met.|

## April 2023

|Subservice| Article | Description |
|---|---|---|
Agents|[Azure Monitor Agent Performance Benchmark](agents/azure-monitor-agent-performance.md)|Added performance benchmark data for the scenario of using Azure Monitor Agent to forward data to a gateway.|
Agents|[Troubleshoot issues with the Log Analytics agent for Windows](agents/agent-windows-troubleshoot.md)|Log Analytics will no longer accept connections from MMA versions that use old root CAs (MMA versions prior to the Winter 2020 release for Log Analytics agent, and prior to Microsoft System Center Operations Manager 2019 UR3 for Operations Manager). |
Agents|[Azure Monitor Agent overview](agents/agents-overview.md)|Log Analytics agent supports Windows Server 2022. |
Alerts|[Common alert schema](alerts/alerts-common-schema.md)|Updated alert payload common schema to include custom properties.|
Alerts|[Create and manage action groups in the Azure portal](alerts/action-groups.md)|Clarified use of basic auth in webhook.|
Application-Insights|[Application Insights logging with .NET](app/ilogger.md)|We've made it easier to understand where to find iLogger telemetry.|
Application-Insights|[Set up Azure Monitor for your Python application](/previous-versions/azure/azure-monitor/app/opencensus-python)|Updated telemetry type mappings code sample.|
Application-Insights|[Feature extensions for the Application Insights JavaScript SDK (Click Analytics)](app/javascript-feature-extensions.md)|Code samples updated to use connection strings.|
Application-Insights|[Connection strings](app/connection-strings.md)|Code samples updated for .NET 6/7.|
Application-Insights|[Live Metrics: Monitor and diagnose with 1-second latency](app/live-stream.md)|Code samples updated for .NET 6/7.|
Application-Insights|[Geolocation and IP address handling](app/ip-collection.md)|The PowerShell 'Update-AzApplicationInsights' code sample to disable IP masking has been updated.|
Application-Insights|[Application Insights for Worker Service applications (non-HTTP applications)](app/worker-service.md)|The .NET Core app scenario chart has been updated.|
Application-Insights|[Azure AD authentication for Application Insights](app/azure-ad-authentication.md)|Linked information on how to query Application Insights using Azure AD Authentication.|
Application-Insights|[Enable Azure Monitor OpenTelemetry for .NET, Node.js, Python and Java applications](app/opentelemetry-enable.md)|Java guidance and code samples have been updated.|
Autoscale|[Configure autoscale with PowerShell](autoscale/autoscale-using-powershell.md)|New Article:  Configure autoscale using PowerShell|
Autoscale|[Get started with autoscale in Azure](autoscale/autoscale-get-started.md)|Refreshed article|
Containers|[Monitor an Azure Kubernetes Service cluster using Container insights in Azure Monitor](/training/modules/aks-monitor/)|New Learn module: Monitor an Azure Kubernetes Service cluster using Container insights in Azure Monitor.|
Containers|[Manage the Container insights agent](containers/container-insights-manage-agent.md)|Semantic version update of container insights agent version|
Essentials|[Azure Monitor Metrics overview](essentials/data-platform-metrics.md)|New Batch Metrics API that allows multiple resource requests and reducing throttling found in the non-batch version. |
General|[Cost optimization in Azure Monitor](best-practices-cost.md)|Rewritten to match organization of Well Architected Framework service guides|
General|[Best practices for Azure Monitor Logs](best-practices-logs.md)|New article with consolidated list of best practices for Logs organized by WAF pillar.|
General|[Migrate from Operations Manager to Azure Monitor](azure-monitor-operations-manager.md)|Migrate from Operations Manager to Azure Monitor|
Logs|[Application Insights API Access with Microsoft Azure Active Directory (Azure AD) Authentication](app/app-insights-azure-ad-api.md)|New article that explains how to authenticate and access the Azure Monitor Application Insights APIs using Azure AD.|
Logs|[Tutorial: Replace custom fields in Log Analytics workspace with KQL-based custom columns](logs/custom-fields-migrate.md)|Guidance for migrate legacy custom fields to KQL-based custom columns using transformations.|
Logs|[Monitor Log Analytics workspace health](logs/log-analytics-workspace-health.md)|View Log Analytics workspace health metrics, including query success metrics, directly from the Log Analytics workspace screen in the Azure portal.|
Logs|[Set a table's log data plan to Basic or Analytics](logs/logs-table-plans.md)|Dedicated SQL Pool tables and Kubernetes services tables now support Basic logs.|
Logs|[Set daily cap on Log Analytics workspace](logs/daily-cap.md)|Updated daily cap functionality for workspace-based Application Insights.|
Profiler|[View Application Insights Profiler data](profiler/profiler-data.md)|Clarified this section based on user feedback.|
Snapshot-Debugger|[Debug snapshots on exceptions in .NET apps](snapshot-debugger/snapshot-collector-release-notes.md)|Removed "how to view" sections and move into its own doc.|
Snapshot-Debugger|[Enable Snapshot Debugger for .NET apps in Azure App Service](snapshot-debugger/snapshot-debugger-app-service.md)|Updated link for release notes to the "Release notes" section in the Snapshot Debugger overview.|
Snapshot-Debugger|[View Application Insights Snapshot Debugger data](snapshot-debugger/snapshot-debugger-data.md)|Created this new doc for viewing snapshots from content taken from the overview.|
Snapshot-Debugger|[Enable Snapshot Debugger for .NET and .NET Core apps in Azure Functions](snapshot-debugger/snapshot-debugger-function-app.md)|Updated link for release notes to the "Release notes" section in the Snapshot Debugger overview.|
Snapshot-Debugger|[Troubleshoot problems enabling Application Insights Snapshot Debugger or viewing snapshots](snapshot-debugger/snapshot-debugger-troubleshoot.md)|Updated link for release notes to the "Release notes" section in the Snapshot Debugger overview.|
Snapshot-Debugger|[Enable Snapshot Debugger for .NET apps in Azure Service Fabric, Cloud Service, and Virtual Machines](snapshot-debugger/snapshot-debugger-vm.md)|Updated link for release notes to the "Release notes" section in the Snapshot Debugger overview.|
Snapshot-Debugger|[Debug snapshots on exceptions in .NET apps](snapshot-debugger/snapshot-debugger.md)|Moved the release notes to the end of the Snapshot Debugger overview doc to improve page metrics.|
Snapshot-Debugger|[What's new in Azure Monitor documentation](whats-new.md)|Updated link for release notes to the "Release notes" section in the Snapshot Debugger overview.|
Snapshot-Debugger|[Debug snapshots on exceptions in .NET apps](snapshot-debugger/snapshot-debugger.md)|Updated .NET availability for Snapshot Debugger to avoid ".NET Core" and "LTS" language.|
Snapshot-Debugger|[Debug snapshots on exceptions in .NET apps](snapshot-debugger/snapshot-debugger.md)|Added release notes for the 1.4.4 point release addressing user-reported bugs.|

## March 2023  
  
|Subservice| Article | Description |
|---|---|---|
Alerts|[Manage your alert rules](alerts/alerts-manage-alert-rules.md)|Updated article to reflect that the user can duplicate an existing alert rule.|
Alerts|[Quickstart: Deploy an Azure Kubernetes Service (AKS) cluster by using the Azure portal](/azure/aks/learn/quick-kubernetes-deploy-portal)|You can enable recommended alert rules when you create an AKS cluster in the Azure portal. |
Alerts|[Monitor Log Analytics workspace health](logs/log-analytics-workspace-health.md)|If you have a Log Analytics workspace without any configured alert rules, you can enable recommended alert rules from the **Alerts** page of a Log Analytics workspace.|
Alerts|[Connect Azure to ITSM tools by using IT Service Management](alerts/itsmc-definition.md)|Updated the workflow for creating ServiceNow ITSM tickets from an Azure Monitor alert. The article now specifies separate workflows for ITSM actions, incidents, and events.|
Alerts|[Manage your alert rules](alerts/alerts-manage-alert-rules.md)|Recommended alert rules are now enabled for all customers and are no longer in public preview.|
Alerts|[Create a new alert rule](alerts/alerts-create-new-alert-rule.md)|Updated to reflect the updated **Create new alert rule** UI. The alert rule creation wizard clearly indicates the most commonly used resources and signals for their alerts to help users more easily create alert rules.|
Alerts|[Understanding Azure Active Directory Application Proxy Complex application scenario (preview)](/azure/active-directory/app-proxy/application-proxy-configure-complex-application)| Updated the documentation for the common schema used in the alerts payload to contain the detailed information about the fields in the payload of each alert type.  |
Alerts|[Supported resources for metric alerts in Azure Monitor](alerts/alerts-metric-near-real-time.md)|Updated list of metrics supported by metric alert rules.|
Alerts|[Create and manage action groups in the Azure portal](alerts/action-groups.md)|Updated the documentation explaining the retry logic used in action groups that use webhooks.|
Alerts|[Create and manage action groups in the Azure portal](alerts/action-groups.md)|Added list of countries/regions supported by voice notifications.|
Alerts|[Connect ServiceNow to Azure Monitor](alerts/itsmc-secure-webhook-connections-servicenow.md)|Added Tokyo to list of supported ServiceNow webhook integrations.|
Application-Insights|[Application Insights SDK support guidance](app/sdk-support-guidance.md)|Release notes are now available for each SDK.|
Application-Insights|[What is distributed tracing and telemetry correlation?](app/distributed-trace-data.md)|Merged our documents related to distributed tracing and telemetry correlation.|
Application-Insights|[Application Insights availability tests](app/availability-overview.md)|Separated and called out the two Classic Tests, which are older versions of availability tests.|
Application-Insights|[Microsoft Azure Monitor Application Insights JavaScript SDK configuration](app/javascript-sdk-configuration.md)|JavaScript SDK configuration now includes npm setup, cookie configuration and management, source map un-minify support, and tree shaking optimized code.|
Application-Insights|[Microsoft Azure Monitor Application Insights JavaScript SDK](app/javascript-sdk.md)|Our introductory article to the JavaScript SDK now provides only the fast and easy code-snippet method of getting started.|
Application-Insights|[Geolocation and IP address handling](app/ip-collection.md)|Updated code samples for .NET 6/7.|
Application-Insights|[Application Insights logging with .NET](app/ilogger.md)|Updated code samples for .NET 6/7.|
Application-Insights|[Azure Monitor overview](overview.md)|Updated Azure Monitor overview graphics along with related content.|
Containers|[Metric alert rules in Container insights (preview)](containers/container-insights-metric-alerts.md)|Updated to indicate deprecation of metric alerts.|
Containers|[Azure Monitor Container insights for Azure Arc-enabled Kubernetes clusters](containers/container-insights-enable-arc-enabled-clusters.md)|Added option for Azure Monitor Private Link Scope (AMPLS) + Proxy.|
Essentials|[Collect Prometheus metrics from an AKS cluster (preview)](containers/kubernetes-monitoring-enable.md#enable-prometheus-and-grafana)|Enabled Windows metric collection metrics add-on.|
Essentials|[Query Prometheus metrics by using the API and PromQL](essentials/prometheus-api-promql.md)|New article: Query Azure Monitor workspaces by using REST and PromQL.|
Essentials|[Configure remote write for Azure Monitor managed service for Prometheus by using Azure Active Directory authentication (preview)](essentials/prometheus-remote-write-active-directory.md)|Added Prometheus remote write Active Directory relabel.|
Essentials|[Built-in policies for Azure Monitor](essentials/diagnostics-settings-policies-deployifnotexists.md)|Added new built-in policies to create diagnostic settings in Azure Monitor with deploy-if-not-exists defaults.|
Logs|[Logs Ingestion API in Azure Monitor](logs/logs-ingestion-api-overview.md)|Updated to include client libraries.|
Logs|[Tutorial: Send data to Azure Monitor by using the Logs Ingestion API (Azure Resource Manager templates)](logs/tutorial-logs-ingestion-api.md)|Rewritten to be more consistent with related tutorial.|
Logs|[Sample code to send data to Azure Monitor by using the Logs Ingestion API](logs/tutorial-logs-ingestion-code.md)|New article: Sample code to send data by using the Logs Ingestion API, including new client ingestion libraries for Python, .NET, Java, and JavaScript.|
Logs|[Tutorial: Send data to Azure Monitor Logs with the Logs Ingestion API (Azure portal)](logs/tutorial-logs-ingestion-portal.md)|Rewritten to be more consistent with related tutorial.|
Snapshot-Debugger|[Enable Profiler for ASP.NET Core web applications hosted in Linux on Azure App Service](profiler/profiler-aspnetcore-linux.md)|Updated code snippets from .NET 5 to .NET 6.|
Snapshot-Debugger|[Enable Snapshot Debugger for .NET apps in Azure Service Fabric, Azure Cloud Services, and Azure Virtual Machines](snapshot-debugger/snapshot-debugger-vm.md)|Updated code snippets from .NET 5 to .NET 6.|

## February 2023

|Subservice| Article | Description |
|---|---|---|
Agents|[Azure Monitor Agent extension versions](agents/azure-monitor-agent-extension-versions.md)|Added release notes for the Azure Monitor Agent Linux 1.25 release.|
Agents|[Migrate to Azure Monitor Agent from the Log Analytics agent](agents/azure-monitor-agent-migration.md)|Updated guidance for migrating from Log Analytics agent to Azure Monitor Agent.|
Alerts|[Manage your alert rules](alerts/alerts-manage-alert-rules.md)|Included limitation and workaround for resource health alerts. If you apply a target resource type scope filter to the **Alerts rules** page, the alerts rules list doesn’t include resource health alert rules.|
Alerts|[Customize alert notifications by using Azure Logic Apps](alerts/alerts-logic-apps.md)|Added instructions for other customizations that you can include when you use Logic Apps to create alert notifications. You can extract information about the affected resource from the resource's tags. Then you can include the resource tags in the alert payload and use the information in your logical expressions that are used for creating the notifications.|
Alerts|[Create and manage action groups in the Azure portal](alerts/action-groups-create-resource-manager-template.md)|Combined two articles about creating action groups into one article.|
Alerts|[Create and manage action groups in the Azure portal](alerts/action-groups.md)|Clarified that you can't pass security certificates in a webhook action in action groups.|
Alerts|[Create a new alert rule](alerts/alerts-create-new-alert-rule.md)|Added information about adding custom properties to the alert payload when you use action groups.|
Alerts|[Manage your alert instances](alerts/alerts-manage-alert-instances.md)|Removed option for managing alert instances by using the Azure CLI.|
Application-Insights|[Migrate to workspace-based Application Insights resources](/previous-versions/azure/azure-monitor/app/convert-classic-resource)|Added the continuous export deprecation notice to this article for more visibility. We recommend migrating to workspace-based Application Insights resources as soon as possible to take advantage of new features.|
Application-Insights|[Application Insights API for custom events and metrics](app/api-custom-events-metrics.md)|Consolidated client-side JavaScript SDK extensions into two new articles called *Framework extensions* and *Feature extensions*. We've also created new standalone *Upgrade* and *Troubleshooting* articles.|
Application-Insights|[Monitor Azure Functions with Azure Monitor Application Insights](app/monitor-functions.md)|Overhauled the documentation on Azure Functions integration with Application Insights.|
Application-Insights|[Enable Azure Monitor OpenTelemetry for .NET, Node.js, Python, and Java applications](app/opentelemetry-enable.md)|Updated Java OpenTelemetry examples.|
Application-Insights|[Application monitoring for Azure App Service and Java](app/azure-web-apps-java.md)|Updated and separated out the instructions to manually deploy the latest Application Insights Java version.|
Containers|[Enable Container insights for Azure Kubernetes Service (AKS) clusters](containers/container-insights-enable-aks.md)|Added a section for enabling a private link without managed identity authentication.|
Containers|[Syslog collection with Container insights (preview)](containers/container-insights-syslog.md)|Added use of Azure Resource Manager templates for enabling Syslog collection.|
Containers|[Enable cost-optimization settings (preview)](containers/container-insights-cost-config.md)|New article: Enable cost-optimization settings.|
Essentials|[Data collection transformations in Azure Monitor](essentials/data-collection-transformations.md)|Added section and sample for using transformations to send to multiple destinations.|
Essentials|[Custom metrics in Azure Monitor (preview)](essentials/metrics-custom-overview.md)|Added reference to the limit of 64 KB on the combined length of all custom metrics names.|
Essentials|[Azure monitoring REST API walkthrough](essentials/rest-api-walkthrough.md)|Refreshed REST API walkthrough.|
Essentials|[Collect Prometheus metrics from AKS cluster (preview)](containers/kubernetes-monitoring-enable.md#enable-prometheus-and-grafana)|Added enabling Prometheus metric collection by using Azure Policy and Bicep.|
Essentials|[Send Prometheus metrics to multiple Azure Monitor workspaces (preview)](essentials/prometheus-metrics-multiple-workspaces.md)|Updated sending metrics to multiple Azure Monitor workspaces.|
General|[Analyze and visualize data](best-practices-analysis.md)|Revised the article about analyzing and visualizing monitoring data to provide a comparison of the different visualization tools and guide customers on when to choose each tool for their implementation. |
Logs|[Tutorial: Send data to Azure Monitor Logs by using the REST API (Resource Manager templates)](logs/tutorial-logs-ingestion-api.md)|Made minor fixes and updated sample data.|
Logs|[Analyze usage in a Log Analytics workspace](logs/analyze-usage.md)|Added query for data that has the IsBillable indicator set incorrectly, which could result in incorrect billing.|
Logs|[Add or delete tables and columns in Azure Monitor Logs](logs/create-custom-table.md)|Added custom column naming limitations.|
Logs|[Enhance data and service resilience in Azure Monitor Logs with availability zones](logs/availability-zones.md)|Clarified availability zone support for data resilience and service resilience and added new supported regions.|
Logs|[Monitor Log Analytics workspace health](logs/log-analytics-workspace-health.md)|New article: Explains how to monitor the service and resource health of a Log Analytics workspace.|
Logs|[Feature extensions for Application Insights JavaScript SDK (Click Analytics)](app/javascript-click-analytics-plugin.md)|You can now launch Power BI and create a dataset and report connected to a Log Analytics query with one click.|
Logs|[Set a table's log data plan to Basic or Analytics](logs/logs-table-plans.md)|Added new tables to the list of tables that support Basic Logs.|
Logs|[Manage tables in a Log Analytics workspace]()|Refreshed all Log Analytics workspace images with the new TOC on the left.|
Security-Fundamentals|[Monitoring Azure App Service](/azure/app-service/monitor-app-service)|Revised the Azure Monitor overview to improve usability. The article is cleaned up, streamlined, and better reflects the product architecture and the customer experience. |
Snapshot-Debugger|[host.json reference for Azure Functions 2.x and later](/azure/azure-functions/functions-host-json)|Removing the TSG from the Azure Monitor TOC and adding to the support TOC.|
Snapshot-Debugger|[Configure Bring Your Own Storage (BYOS) for Application Insights Profiler and Snapshot Debugger](profiler/profiler-bring-your-own-storage.md)|Removing the TSG from the Azure Monitor TOC and adding to the support TOC.|
Snapshot-Debugger|[Release notes for Microsoft.ApplicationInsights.SnapshotCollector](https://github.com/microsoft/ApplicationInsights-SnapshotCollector/blob/main/CHANGELOG.md)|Removing the TSG from the Azure Monitor TOC and adding to the support TOC.|
Snapshot-Debugger|[Enable Snapshot Debugger for .NET apps in Azure App Service](snapshot-debugger/snapshot-debugger-app-service.md)|Removing the TSG from the Azure Monitor TOC and adding to the support TOC.|
Snapshot-Debugger|[Enable Snapshot Debugger for .NET and .NET Core apps in Azure Functions](snapshot-debugger/snapshot-debugger-function-app.md)|Removing the TSG from the Azure Monitor TOC and adding to the support TOC.|
Snapshot-Debugger|[Troubleshoot problems enabling Application Insights Snapshot Debugger or viewing snapshots](/troubleshoot/azure/azure-monitor/app-insights/snapshot-debugger-troubleshoot)|Removing the TSG from the Azure Monitor TOC and adding to the support TOC.|
Snapshot-Debugger|[Enable Snapshot Debugger for .NET apps in Azure Service Fabric, Azure Cloud Services, and Virtual Machines](snapshot-debugger/snapshot-debugger-vm.md)|Removing the TSG from the Azure Monitor TOC and adding to the support TOC.|
Snapshot-Debugger|[Debug snapshots on exceptions in .NET apps](snapshot-debugger/snapshot-debugger.md)|Removing the TSG from the Azure Monitor TOC and adding to the support TOC.|
Virtual-Machines|[Monitor virtual machines with Azure Monitor: Analyze monitoring data](vm/monitor-virtual-machine-analyze.md)|New article.|
Visualizations|[Use JSONPath to transform JSON data in workbooks](visualize/workbooks-jsonpath.md)|Added information about using JSONPath to convert data types in Azure Workbooks.|
Containers|[Configure Container insights cost-optimization data collection rules](containers/container-insights-cost-config.md)|New article: Preview of cost-optimization settings.|

## January 2023

|Subservice| Article | Description |
|---|---|---|
Agents|[Tutorial: Transform text logs during ingestion in Azure Monitor Logs](agents/azure-monitor-agent-transformation.md)|New tutorial: How to write a KQL query that transforms text log data and add the transformation to a data collection rule.|
Agents|[Azure Monitor Agent overview](agents/agents-overview.md)|SQL Best Practices Assessment now available with Azure Monitor Agent.|
Alerts|[Create a new alert rule](alerts/alerts-create-new-alert-rule.md)|Streamlined alerts documentation added the common schema definition to the common schema article, and moved sample Resource Manager templates for alerts to the "Samples" section.|
Alerts|[Non-common alert schema definitions for Test Action Group (preview)](alerts/alerts-non-common-schema-definitions.md)|Added a sample payload for the Actual Cost and Forecasted Budget schemas.|
Application-Insights|[Live Metrics: Monitor and diagnose with 1-second latency](app/live-stream.md)|Updated Live Metrics "Troubleshooting" section.|
Application-Insights|[Application Insights for Azure Virtual Machines and Azure Virtual Machine Scale Sets](app/azure-vm-vmss-apps.md)|Easily monitor your IIS-hosted .NET Framework and .NET Core applications running on Azure Virtual Machines and Azure Virtual Machine Scale Sets by using a new App Insights extension.|
Application-Insights|[Sampling in Application Insights](app/sampling.md)|Added embedded links to assist with looking up type definitions (dependency, event, exception, PageView, request, and trace).|
Application-Insights|[Configuration options: Azure Monitor Application Insights for Java](app/java-standalone-config.md)|Instructions are now available on how to set the HTTP proxy by using an environment variable, which overrides the JSON configuration. We've also provided a sample to configure connection string at runtime.|
Application-Insights|[Application Insights for Java 2.x](/previous-versions/azure/azure-monitor/app/deprecated-java-2x)|The Java 2.x retirement notice is available at [https://azure.microsoft.com/updates/application-insights-java-2x-retirement](https://azure.microsoft.com/updates/application-insights-java-2x-retirement).|
Autoscale|[Diagnostic settings in autoscale](autoscale/autoscale-diagnostics.md)|Updated and expanded content.|
Autoscale|[Overview of common autoscale patterns](autoscale/autoscale-common-scale-patterns.md)|Clarification of weekend profiles.|
Autoscale|[Autoscale with multiple profiles](autoscale/autoscale-multiprofile.md)|Added clarifications for profile end times.|
Change-Analysis|[Scenarios for using Change Analysis in Azure Monitor](change/change-analysis-custom-filters.md)|Merged two low-engagement docs into Visualizations article and removed from TOC.|
Change-Analysis|[Scenarios for using Change Analysis in Azure Monitor](change/change-analysis-query.md)|Merged two low-engagement docs into Visualizations article and removed from TOC.|
Change-Analysis|[Scenarios for using Change Analysis in Azure Monitor](change/change-analysis-visualizations.md)|Merged two low-engagement docs into Visualizations article and removed from TOC.|
Change-Analysis|[Track a web app outage by using Change Analysis](change/tutorial-outages.md)|Added new section on virtual network changes to the tutorial.|
Containers|[Azure Monitor container insights for Azure Kubernetes Service hybrid clusters (preview)](containers/kubernetes-monitoring-enable.md?tabs=cli)|New article.|
Containers|[Syslog collection with Container insights (preview)](containers/container-insights-syslog.md)|New article.|
Essentials|[Query Prometheus metrics by using Azure Workbooks (preview)](essentials/prometheus-workbooks.md)|New article.|
Essentials|[Azure Workbooks data sources](visualize/workbooks-data-sources.md)|Added section for Prometheus metrics.|
Essentials|[Query Prometheus metrics by using Azure Workbooks (preview)](essentials/prometheus-workbooks.md)|New article.|
Essentials|[Azure Monitor workspace (preview)](essentials/azure-monitor-workspace-overview.md)|Updated design considerations.|
Essentials|[Supported metrics with Azure Monitor](essentials/metrics-supported.md)|Updated and refreshed the list of supported metrics.|
Essentials|[Supported categories for Azure Monitor resource logs](essentials/resource-logs-categories.md)|Updated and refreshed the list of supported logs.|
General|[Multicloud monitoring with Azure Monitor](best-practices-multicloud.md)|New article.|
Logs|[Set daily cap on Log Analytics workspace](logs/daily-cap.md)|Clarified special case for daily cap logic.|
Logs|[Send custom metrics for an Azure resource to the Azure Monitor metric store by using a REST API](essentials/metrics-store-custom-rest-api.md)|Updated and refreshed how to send custom metrics.|
Logs|[Migrate from Splunk to Azure Monitor Logs](logs/migrate-splunk-to-azure-monitor-logs.md)|New article: Explains how to migrate your Splunk Observability deployment to Azure Monitor Logs for logging and log data analysis.|
Logs|[Manage access to Log Analytics workspaces](logs/manage-access.md)|Added permissions required to run a search job and restore archived data.|
Logs|[Set a table's log data plan to Basic or Analytics](logs/logs-table-plans.md)|Added information about how to modify a table schema by using the API.|
Snapshot-Debugger|[Enable Snapshot Debugger for .NET apps in Azure App Service](snapshot-debugger/snapshot-debugger-app-service.md)|Per customer feedback, added new note that Consumption plan isn't supported.|
Virtual-Machines|[Collect IIS logs with Azure Monitor Agent](agents/data-collection-iis.md)|Added sample log queries.|
Virtual-Machines|[Collect text logs with Azure Monitor Agent](agents/data-collection-text-log.md)|Added sample log queries.|
Virtual-Machines|[Monitor virtual machines with Azure Monitor: Deploy agent](vm/monitor-virtual-machine-agent.md)|Rewritten for Azure Monitor Agent.|
Virtual-Machines|[Monitor virtual machines with Azure Monitor: Alerts](vm/monitor-virtual-machine-alerts.md)|Rewritten for Azure Monitor Agent.|
Virtual-Machines|[Monitor virtual machines with Azure Monitor: Analyze monitoring data](vm/monitor-virtual-machine-analyze.md)|Rewritten for Azure Monitor Agent.|
Virtual-Machines|[Monitor virtual machines with Azure Monitor: Collect data](vm/monitor-virtual-machine-data-collection.md)|Rewritten for Azure Monitor Agent.|
Virtual-Machines|[Monitor virtual machines with Azure Monitor: Migrate management pack logic](vm/monitor-virtual-machine-management-packs.md)|Rewritten for Azure Monitor Agent.|
Virtual-Machines|[Monitor virtual machines with Azure Monitor](vm/monitor-virtual-machine.md)|Rewritten for Azure Monitor Agent.|
Virtual-Machines|[Monitor Azure virtual machines](/azure/virtual-machines/monitor-vm)|VM scenario updates for Azure Monitor Agent.|

## [2022](#tab/2022)

## December 2022

|Subservice| Article | Description |
|---|---|---|
General|[Azure Monitor for existing Operations Manager customers](azure-monitor-operations-manager.md)|Updated for Azure Monitor Agent and System Center Operations Manager managed instance.|
Application-Insights|[Create an Application Insights resource](/previous-versions/azure/azure-monitor/app/create-new-resource)|Classic Application Insights resources are deprecated. Support ends on February 29, 2024. Migrate to workspace-based resources to take advantage of new capabilities.|
Application-Insights|[Enable Azure Monitor OpenTelemetry for .NET, Node.js, and Python applications (preview)](app/opentelemetry-enable.md)|Updated Node.js sample code for JavaScript and TypeScript.|
Application-Insights|[System performance counters in Application Insights](app/performance-counters.md)|Updated code samples for .NET 6/7.|
Application-Insights|[Sampling in Application Insights](app/sampling.md)|Updated code samples for .NET 6/7.|
Application-Insights|[Availability alerts](app/availability-alerts.md)|Rewritten with new guidance and screenshots.|
Change-Analysis|[Tutorial: Track a web app outage by using Change Analysis](change/tutorial-outages.md)|Changed tutorial content to reflect changes to repo and removed and replaced sections.|
Containers|[Configure Azure CNI networking in Azure Kubernetes Service](/azure/aks/configure-azure-cni)|Added steps to enable IP subnet usage.|
Containers|[Reports in Container insights](containers/container-insights-reports.md)|Updated to reflect the steps to enable IP subnet usage.|
Essentials|[Best practices for data collection rule creation and management in Azure Monitor](essentials/data-collection-rule-best-practices.md)|New article.|
Essentials|[Configure self-managed Grafana to use Azure Monitor managed service for Prometheus (preview) with Azure Active Directory](essentials/prometheus-self-managed-grafana-azure-active-directory.md)|New article: Configured self-managed Grafana to use Azure Monitor managed service for Prometheus (preview) with Azure Active Directory.|
Logs|[Azure Monitor SCOM Managed Instance (preview)](vm/scom-managed-instance-overview.md)|New article.|
Logs|[Set a table's log data plan to Basic or Analytics](logs/logs-table-plans.md)|Updated the list of tables that support Basic Logs.|
Virtual-Machines|[Tutorial: Create availability alert rule for Azure virtual machine (preview)](vm/tutorial-monitor-vm-alert-availability.md)|New article.|
Virtual-Machines|[Tutorial: Enable recommended alert rules for Azure virtual machine](vm/tutorial-monitor-vm-alert-recommended.md)|New article.|
Virtual-Machines|[Tutorial: Enable monitoring with VM insights for Azure virtual machine](vm/tutorial-monitor-vm-enable-insights.md)|New article.|
Virtual-Machines|[Monitor Azure virtual machines](/azure/virtual-machines/monitor-vm)|Updated for Azure Monitor Agent and availability metric.|
Virtual-Machines|[Enable VM insights by using Azure Policy](vm/vminsights-enable-policy.md)|Updated flow for enabling VM insights with Azure Monitor Agent by using Azure Policy.|
Visualizations|[Creating an Azure Workbook](visualize/workbooks-create-workbook.md)|Added tutorial on resource-centric log queries in workbooks.|

## November 2022

|Subservice| Article | Description |
|---|---|---|
General|[Cost optimization and Azure Monitor](best-practices-cost.md)|Rewritten to align with Azure Well-Architected Framework. Moved detailed content to other articles and linked from here.|
Agents|[Collect SNMP trap data with Azure Monitor Agent](agents/data-collection-snmp-data.md)|New tutorial: Explains how to collect Simple Network Management Protocol (SNMP) traps by using Azure Monitor Agent.|
Alerts|[Create a new alert rule](alerts/alerts-create-new-alert-rule.md)|Resource Health alerts and Service Health alerts are created by using the same simplified workflow as all other alert types.|
Alerts|[Manage your alert rules](alerts/alerts-manage-alert-rules.md)|Recommended alert rules are enabled for Azure Kubernetes Service and Log Analytics workspace resources in addition to VMs.|
Application-insights|[Sampling in Application Insights](app/sampling.md)|ASP.NET Core applications can be configured in code or through the `appsettings.json` file. Removed conflicting information.|
Application-insights|[How many Application Insights resources should I deploy?](app/create-workspace-resource.md#how-many-application-insights-resources-should-i-deploy)|Added clarification on setting iKey dynamically in code.|
Application-insights|[Application Map: Triage distributed applications](app/app-map.md)|Documented App Map Filters, an exciting new feature.|
Application-insights|[Enable Application Insights for ASP.NET Core applications](/previous-versions/azure/azure-monitor/app/tutorial-asp-net-core)|The Azure Café sample app is now hosted and linked on Git.|
Application-insights|[What is autoinstrumentation for Azure Monitor Application Insights?](app/codeless-overview.md)|Updated the autoinstrumentation supported languages chart.|
Application-insights|[Application monitoring for Azure App Service and ASP.NET](app/azure-web-apps-net.md)|Corrected links to check versions.|
Application-insights|[Sampling overrides (preview) - Azure Monitor Application Insights for Java](app/java-standalone-sampling-overrides.md)|Updated OpenTelemetry Span information for Java.|
Autoscale|[Understand autoscale settings](autoscale/autoscale-understanding-settings.md)|Refreshed and updated.|
Autoscale|[Overview of common autoscale patterns](autoscale/autoscale-common-scale-patterns.md)|Refreshed and updated.|
Essentials|[Azure Monitor managed service for Prometheus (preview)](essentials/prometheus-metrics-scrape-default.md)|Restructured Prometheus content.|
Essentials|[Configure remote write for Azure Monitor managed service for Prometheus by using Azure Active Directory authentication (preview)](essentials/prometheus-remote-write.md)|New article.|
Essentials|[Azure Monitor workspace (preview)](essentials/azure-monitor-workspace-overview.md)|Added Bicep example.|
Essentials|[Migrate from diagnostic settings storage retention to Azure Storage lifecycle management](essentials/migrate-to-azure-storage-lifecycle-policy.md)|Added deprecation note.|
Essentials|[Diagnostic settings in Azure Monitor](essentials/diagnostic-settings.md)|All destination endpoints support TLS 1.2.|
Logs|[Cost optimization and Azure Monitor](best-practices-cost.md)|Added cost information and removed preview label.|
Logs|[Diagnostic settings in Azure Monitor](essentials/diagnostic-settings.md)|Added section on controlling costs with transformations.|
Logs|[Analyze usage in a Log Analytics workspace](logs/analyze-usage.md)|Added Kusto Query Language query that retrieves data volumes for charged data types.|
Logs|[Access the Azure Monitor Log Analytics API](logs/api/timeouts.md)|Refreshed and updated.|
Logs|[Collect text logs with the Log Analytics agent in Azure Monitor](agents/data-sources-custom-logs.md)|Added new table management section with new articles on table configuration options, schema management, and custom table creation.|
Logs|[Azure Monitor Metrics overview](essentials/data-platform-metrics.md)| Added a new Azure SDK client library for Go.|
Logs|[Azure Monitor Log Analytics API overview](logs/api/overview.md)| Added a new Azure SDK client library for Go.|
Logs|[Azure Monitor Logs overview](logs/data-platform-logs.md)| Added a new Azure SDK client library for Go.|
Logs|[Log queries in Azure Monitor](logs/log-query-overview.md)| Added a new Azure SDK client library for Go.|
Logs|[Set a table's log data plan to Basic or Analytics](logs/logs-table-plans.md)|Added new tables to the list of tables that support the Basic Log data plan.|
Visualizations|[Monitor your Azure services in Grafana](visualize/grafana-plugin.md)|The Grafana integration is generally available and is no longer in preview.|
Visualizations|[Get started with Azure Workbooks](visualize/workbooks-getting-started.md)|Added instructions for how to share workbooks.|

## October 2022

|Subservice| Article | Description |
|---|---|---|
|General|Table of contents|Updated the Azure Monitor table of contents (TOC). The new TOC structure better reflects the customer experience and makes it easier for users to navigate and discover our content.|
Alerts|[Connect Azure to ITSM tools by using IT Service Management](./alerts/itsmc-definition.md)|Deprecating support for sending ITSM actions and events to ServiceNow. Instead, use ITSM actions in action groups based on Azure alerts to create work items in your ITSM tool.|
Alerts|[Create a new alert rule](./alerts/alerts-create-new-alert-rule.md)|New PowerShell commands to create and manage log alerts.|
Alerts|[Types of Azure Monitor alerts](alerts/alerts-types.md)|Updated to include Prometheus alerts.|
Alerts|[Customize alert notifications by using Logic Apps](./alerts/alerts-logic-apps.md)|New article: Use alerts to send emails or Teams posts by using Logic Apps.|
Application-insights|[Sampling in Application Insights](./app/sampling.md)|Prioritized the "When to use sampling" and "How sampling works" sections as prerequisite information for the article.|
Application-insights|[What is autoinstrumentation for Azure Monitor Application Insights?](./app/codeless-overview.md)|Overhauled the autoinstrumentation overview with links and footnotes.|
Application-insights|[Enable Azure Monitor OpenTelemetry for .NET, Node.js, and Python applications (preview)](./app/opentelemetry-enable.md)|Open Telemetry Metrics are now available for .NET, Node.js and Python applications.|
Application-insights|[Find and diagnose performance issues with Application Insights](./app/tutorial-performance.md)|Replaced the URL Ping (Classic) Test with Standard Test step-by-step instructions.|
Application-insights|[Application Insights API for custom events and metrics](./app/api-custom-events-metrics.md)|Added flushing information to the FAQ.|
Application-insights|[Azure AD authentication for Application Insights](./app/azure-ad-authentication.md)|Updated the `TelemetryConfiguration` code sample by using .NET.|
Application-insights|[Using Azure Monitor Application Insights with Spring Boot](./app/java-spring-boot.md)|Updated the Spring Boot information to 3.4.2.|
Application-insights|[Configuration options: Azure Monitor Application Insights for Java](./app/java-standalone-config.md)|Added new features on Capture Log4j Markers and Logback Markers as custom properties on the corresponding trace (log message) telemetry.|
Application-insights|[Create custom KPI dashboards by using Application Insights](./app/overview-dashboard.md#create-custom-kpi-dashboards-using-application-insights)|Refreshed with new screenshots and instructions.|
Application-insights|[Share Azure dashboards by using Azure role-based access control](/azure/azure-portal/azure-portal-dashboard-share-access)|Refreshed with new screenshots and instructions.|
Application-insights|[Application monitoring for Azure App Service and ASP.NET](./app/azure-web-apps-net.md)|Added important notes about System.IO.FileNotFoundException after an 2.8.44 autoinstrumentation upgrade.|
Application-insights|[Geolocation and IP address handling](./app/ip-collection.md)| Updated geolocation lookup information.|
Containers|[Metric alert rules in Container insights (preview)](./containers/container-insights-metric-alerts.md)|Updated to include Container insights metric alerts.|
Containers|[Custom metrics collected by Container insights](/previous-versions/azure/azure-monitor/containers/container-insights-custom-metrics)|New article.|
Containers|[Overview of Container insights in Azure Monitor](containers/container-insights-overview.md)|Rewritten to simplify onboarding options.|
Containers|[Enable Container insights for Azure Kubernetes Service cluster](containers/container-insights-enable-aks.md?tabs=azure-cli)|Updated to combine new and existing clusters.|
Containers Prometheus|[Query logs from Container insights](containers/container-insights-log-query.md)|Updated to include log queries for Prometheus data.|
Containers Prometheus|[Collect Prometheus metrics with Container insights](containers/container-insights-prometheus.md?tabs=cluster-wide)|Updated to include Azure Monitor managed service for Prometheus.|
Essentials Prometheus|[Metrics in Azure Monitor](essentials/data-platform-metrics.md)|Updated to include Azure Monitor managed service for Prometheus.|
Essentials Prometheus|<ul> <li> [Azure Monitor workspace overview (preview)](essentials/azure-monitor-workspace-overview.md?tabs=azure-portal) </li><li> [Overview of Azure Monitor managed service for Prometheus (preview)](essentials/prometheus-metrics-overview.md) </li><li>[Rule groups in Azure Monitor managed service for Prometheus (preview)](essentials/prometheus-rule-groups.md)</li><li>[Remote-write in Azure Monitor managed service for Prometheus (preview)](essentials/prometheus-remote-write-managed-identity.md) </li><li>[Use Azure Monitor managed service for Prometheus (preview) as data source for Grafana](essentials/prometheus-grafana.md)</li><li>[Troubleshoot collection of Prometheus metrics in Azure Monitor (preview)](essentials/prometheus-metrics-troubleshoot.md)</li><li>[Default Prometheus metrics configuration in Azure Monitor (preview)](essentials/prometheus-metrics-scrape-default.md)</li><li>[Scrape Prometheus metrics at scale in Azure Monitor (preview)](essentials/prometheus-metrics-scrape-scale.md)</li><li>[Customize scraping of Prometheus metrics in Azure Monitor (preview)](essentials/prometheus-metrics-scrape-configuration.md)</li><li>[Create, validate, and troubleshoot custom configuration file for Prometheus metrics in Azure Monitor (preview)](essentials/prometheus-metrics-scrape-validate.md)</li><li>[Minimal Prometheus ingestion profile in Azure Monitor (preview)](essentials/prometheus-metrics-scrape-configuration-minimal.md)</li><li>[Collect Prometheus metrics from AKS cluster (preview)](containers/kubernetes-monitoring-enable.md#enable-prometheus-and-grafana)</li><li>[Send Prometheus metrics to multiple Azure Monitor workspaces (preview)](essentials/prometheus-metrics-multiple-workspaces.md) </li></ul> |New articles: Public preview of Azure Monitor managed service for Prometheus.|
Essentials Prometheus|[Azure Monitor managed service for Prometheus remote write - managed identity (preview)](./essentials/prometheus-remote-write-managed-identity.md)|Added information that verifies Prometheus remote write is working correctly.|
Essentials|[Azure resource logs](./essentials/resource-logs.md)|Clarified which blob's logs are written to, and when.|
Essentials|[Resource Manager template samples for Azure Monitor](resource-manager-samples.md?tabs=portal)|Added template deployment methods.|
Essentials|[Azure Monitor service limits](service-limits.md)|Added Azure Monitor managed service for Prometheus.|
Logs|[Manage access to Log Analytics workspaces](./logs/manage-access.md)|Table-level role-based access control lets you give specific users or groups read access to particular tables.|
Logs|[Configure Basic Logs in Azure Monitor](./logs/logs-table-plans.md)|Added information on general availability of the Basic Logs data plan, retention and archiving, search job, and the table management user experience in the Azure portal.|
Logs|[Guided project - Analyze logs in Azure Monitor with KQL - Training](/training/modules/analyze-logs-with-kql/)|New Learn module: Learn to write KQL queries to retrieve and transform log data to answer common business and operational questions.|
Logs|[Detect and analyze anomalies with KQL in Azure Monitor](logs/kql-machine-learning-azure-monitor.md)|New tutorial: Walkthrough of how to use KQL for time-series analysis and anomaly detection in Azure Monitor Log Analytics. |
Virtual-machines|[Enable VM insights for a hybrid virtual machine](./vm/vminsights-enable-hybrid.md)|Updated versions of standalone installers.|
Visualizations|[Retrieve legacy Application Insights workbooks](./visualize/workbooks-retrieve-legacy-workbooks.md)|New article: Access legacy workbooks in the Azure portal.|
Visualizations|[Azure Workbooks](./visualize/workbooks-overview.md)|New video to see how you can use Azure Workbooks to get insights and visualize your data. |

## September 2022

### Agents

| Article | Description |
|---|---|
|[Azure Monitor Agent overview](./agents/agents-overview.md)|Added Azure Monitor Agent support for Arm64-based virtual machines for a number of distributions. <br><br>Azure Monitor Agent and legacy agents don't support machines and appliances that run heavily customized or stripped-down versions of operating system distributions. <br><br>Azure Monitor Agent versions 1.15.2 and higher now support Syslog RFC formats, including Cisco Meraki, Cisco ASA, Cisco FTD, Sophos XG, Juniper Networks, Corelight Zeek, CipherTrust, NXLog, McAfee, and Common Event Format (CEF).|

### Alerts

| Article | Description |
|---|---|
|[Convert ITSM actions that send events to ServiceNow to Secure Webhook actions](./alerts/itsm-convert-servicenow-to-webhook.md)|As of September 2022, we're starting the three-year process of deprecating support of using ITSM actions to send events to ServiceNow. Learn how to convert ITSM actions that send events to ServiceNow to Secure Webhook actions.|
|[Create a new alert rule](./alerts/alerts-create-new-alert-rule.md)|Added description of all available monitoring services to **Create a new alert rule** and **Alert processing rules** pages. <br><br>Added support for regional processing for metric alert rules that monitor a custom metric with the scope defined as one of the supported regions. <br><br> Clarified that selecting the **Automatically resolve alerts** setting makes log alerts stateful.|
|[Types of Azure Monitor alerts](alerts/alerts-types.md)|Azure Database for PostgreSQL - Flexible Servers is supported for monitoring multiple resources.|
|[Upgrade legacy rules management to the current Scheduled Query Rules API from legacy Log Analytics Alert API](./alerts/alerts-log-api-switch.md)|The process of moving legacy log alert rules management from the legacy API to the current API is now supported by the government cloud.|

### Application Insights

| Article | Description |
|---|---|
|[Azure Monitor OpenTelemetry-based autoinstrumentation for Java applications](./app/opentelemetry-enable.md?tabs=java)|Added new OpenTelemetry `@WithSpan` annotation guidance.|
|[Capture Application Insights custom metrics with .NET and .NET Core](/previous-versions/azure/azure-monitor/app/tutorial-asp-net-custom-metrics)|Updated tutorial steps and images.|
|[Configuration options: Azure Monitor Application Insights for Java](./app/opentelemetry-enable.md)|Updated connection string guidance.|
|[Enable Application Insights for ASP.NET Core applications](/previous-versions/azure/azure-monitor/app/tutorial-asp-net-core)|Updated tutorial steps and images.|
|[Enable Azure Monitor OpenTelemetry Exporter for .NET, Node.js, and Python applications (preview)](./app/opentelemetry-enable.md)|Fixed the product feedback link at the bottom of each document.|
|[Filter and preprocess telemetry in the Application Insights SDK](./app/api-filtering-sampling.md)|Added sample initializer to control which client IP gets used as part of geo-location mapping.|
|[Java Profiler for Azure Monitor Application Insights](./app/java-standalone-profiler.md)|Announced the new Java Profiler at Ignite. Read all about it.|
|[Release notes for Azure Web App extension for Application Insights](./app/web-app-extension-release-notes.md)|Added release notes for 2.8.44 and 2.8.43.|
|[Resource Manager template samples for creating Application Insights resources](./app/create-workspace-resource.md)|Fixed inaccurate tagging of workspace-based resources as still in preview.|
|[Unified cross-component transaction diagnostics](./app/transaction-search-and-diagnostics.md?tabs=transaction-diagnostics)|Added a FAQ section to help troubleshoot Azure portal errors like "error retrieving data."|
|[Upgrading from Application Insights Java 2.x SDK](./app/java-standalone-upgrade-from-2x.md)|Added more upgrade guidance. Java 2.x is deprecated.|
|[Using Azure Monitor Application Insights with Spring Boot](./app/java-spring-boot.md)|Updated configuration options.|

### Autoscale

| Article | Description |
|---|---|
|[Autoscale with multiple profiles](./autoscale/autoscale-multiprofile.md)|New article: Using multiple profiles in autoscale with CLI PowerShell and templates.|
|[Flapping in autoscale](./autoscale/autoscale-flapping.md)|New article: Flapping in autoscale.|
|[Understand autoscale settings](./autoscale/autoscale-understanding-settings.md)|Clarified how often autoscale runs.|

### Change Analysis

| Article | Description |
|---|---|
|[Troubleshoot Azure Monitor's Change Analysis](./change/change-analysis-troubleshoot.md)|Added section about partial data and how to mitigate to the troubleshooting guide.|

### Essentials

| Article | Description |
|---|---|
|[Structure of transformation in Azure Monitor (preview)](./essentials/data-collection-transformations-structure.md)|Added information about new KQL functions that are supported.|

### Virtual machines

| Article | Description |
|---|---|
|[Migrate from Service Map to Azure Monitor VM insights](./vm/vminsights-migrate-from-service-map.md)|Added a new article with guidance for migrating from the Service Map solution to Azure Monitor VM insights.|

### Network Insights

| Article | Description |
|---|---|
|[Network Insights](/azure/network-watcher/network-insights-overview)| Onboarded the new topology experience to Network Insights in Azure Monitor.|

### Visualizations

| Article | Description |
|---|---|
|[Access deprecated troubleshooting guides in Azure Workbooks](./visualize/workbooks-access-troubleshooting-guide.md)|New article: Access deprecated troubleshooting guides in Azure Workbooks.|

## August 2022

### Agents

| Article | Description |
|---|---|
|[Log Analytics agent overview](agents/log-analytics-agent.md)|Restructured the "Agents" section and rewrote the *Agents overview* article to reflect that Azure Monitor Agent is the primary agent for collecting monitoring data.|
|[Dependency analysis in Azure Migrate Discovery and assessment - Azure Migrate](/azure/migrate/concepts-dependency-visualization)|Revamped the guidance for migrating from the Log Analytics agent to Azure Monitor Agent.|

### Alerts

| Article | Description |
|:---|:---|
|[Create Azure Monitor alert rules](alerts/alerts-create-new-alert-rule.md)|Added support for data processing in a specified region, for action groups, and for metric alert rules that monitor a custom metric.|

### Application Insights

| Article | Description |
|---|---|
|[Application Insights Overview dashboard](app/overview-dashboard.md)|Added important information clarifying that moving or renaming resources breaks dashboards, with more instructions on how to resolve this scenario.|
|[Application Insights override default SDK endpoints](/previous-versions/azure/azure-monitor/app/create-new-resource#override-default-endpoints)|Clarified that endpoint modification isn't recommended and to use connection strings instead.|
|[Continuous export of telemetry from Application Insights](/previous-versions/azure/azure-monitor/app/export-telemetry)|Added important information about avoiding duplicates when you save diagnostic logs in a Log Analytics workspace.|
|[Dependency tracking in Application Insights with OpenCensus Python](/previous-versions/azure/azure-monitor/app/opencensus-python-dependency)|Updated Django sample application and documentation in the Azure Monitor OpenCensus Python samples repository.|
|[Incoming request tracking in Application Insights with OpenCensus Python](/previous-versions/azure/azure-monitor/app/opencensus-python-request)|Updated Django sample application and documentation in the Azure Monitor OpenCensus Python samples repository.|
|[Monitor Python applications with Azure Monitor](/previous-versions/azure/azure-monitor/app/opencensus-python)|Updated Django sample application and documentation in the Azure Monitor OpenCensus Python samples repository.|
|[Configuration options: Azure Monitor Application Insights for Java](app/java-standalone-config.md)|Updated connection string overrides example.|
|[Application Insights SDK for ASP.NET Core applications](/previous-versions/azure/azure-monitor/app/tutorial-asp-net-core)|Added a new tutorial with step-by-step instructions on how to use the Application Insights SDK with .NET Core applications.|
|[Application Insights SDK support guidance](app/sdk-support-guidance.md)|Updated and clarified the SDK support guidance.|
|[Application Insights: Dependency autocollection](app/asp-net-dependencies.md#dependency-autocollection)|Updated the latest currently supported node.js modules.|
|[Application Insights custom metrics with .NET and .NET Core](/previous-versions/azure/azure-monitor/app/tutorial-asp-net-custom-metrics)|Added a new tutorial with step-by-step instructions on how to enable custom metrics with .NET applications.|
|[Migrate an Application Insights classic resource to a workspace-based resource](/previous-versions/azure/azure-monitor/app/convert-classic-resource)|Added a comprehensive FAQ section to assist with migration to workspace-based resources.|
|[Configuration options: Azure Monitor Application Insights for Java](app/java-standalone-config.md)| Updated this article for 3.4.0-BETA.|

### Autoscale

| Article | Description |
|---|---|
|[Autoscale in Microsoft Azure](autoscale/autoscale-overview.md)|Updated conceptual diagrams.|
|[Use predictive autoscale to scale out before load demands in Virtual Machine Scale Sets (preview)](autoscale/autoscale-predictive.md)|Predictive autoscale (preview) is now available in all regions.|

### Change Analysis

| Article | Description |
|---|---|
|[Enable Change Analysis](change/change-analysis-enable.md)| Added a note for slot-level enablement.|
|[Tutorial: Track a web app outage by using Change Analysis](change/tutorial-outages.md)| Added setup steps to the tutorial.|
|[Use Change Analysis in Azure Monitor to find web-app issues](change/change-analysis.md)|Updated limitations.|
|[Observability data in Azure Monitor](observability-data.md)| Added a "Changes" section.|

### Containers

| Article | Description |
|---|---|
|[Monitor a deployed Azure Kubernetes Service cluster](containers/container-insights-enable-existing-clusters.md)|Added section on using a private link with Container insights.|

### Essentials

| Article | Description |
|---|---|
|[Azure activity log](essentials/activity-log.md)|Added instructions for how to stop collecting activity logs by using the legacy collection method.|
|[Azure activity log insights](essentials/activity-log-insights.md)|Created a separate activity log insights article in the "Insights" section.|

### Logs

| Article | Description |
|---|---|
|[Configure data retention and archive in Azure Monitor Logs (preview)](logs/data-retention-configure.md)|Clarified how data retention and archiving work in Azure Monitor Logs to address repeated customer inquiries.|

## July 2022

### General

| Article | Description |
|:---|:---|
|[Sources of data in Azure Monitor](data-sources.md)|Updated with Azure Monitor Agent and the Logs Ingestion API.|

### Agents

| Article | Description |
|:---|:---|
|[Azure Monitor Agent overview](agents/agents-overview.md)| Restructured the "Agents" section. A single Azure Monitor Agent is replacing all of Azure Monitor's legacy monitoring agents.
|[Enable network isolation for Azure Monitor Agent](agents/azure-monitor-agent-data-collection-endpoint.md)|Rewritten to better describe configuration of network isolation.

### Alerts

| Article | Description |
|:---|:---|
|[Azure Monitor alerts overview](alerts/alerts-overview.md)|Updated the logic for the time to resolve behavior in stateful log alerts.

### Application Insights

| Article | Description |
|:---|:---|
|[Azure Monitor Application Insights Java](app/opentelemetry-enable.md?tabs=java)|Updated the Supported Custom Telemetry table in OpenTelemetry-based autoinstrumentation for Java applications.
|[Application Insights API for custom events and metrics](app/api-custom-events-metrics.md)|Added clarification that valueCount and itemCount have a minimum value of 1.
|[Telemetry sampling in Application Insights](app/sampling.md)|Updated sampling documentation to warn of the potential impact on alerting accuracy.
|[Azure Monitor Application Insights Java (redirect to OpenTelemetry)](app/java-in-process-agent-redirect.md)|Java autoinstrumentation now redirects to OpenTelemetry documentation.
|[Application Insights for ASP.NET Core applications](app/asp-net-core.md)|Updated .NET Core FAQ.
|[Create a new Azure Monitor Application Insights workspace-based resource](app/create-workspace-resource.md)|Linked to Microsoft Insights components for more information on properties.
|[Application Insights SDK support guidance](app/sdk-support-guidance.md)|Updated and clarified SDK support guidance.
|[Azure Monitor Application Insights Java](app/opentelemetry-enable.md?tabs=java)|Updated example code.
|[IP addresses used by Azure Monitor](app/ip-addresses.md)|Updated the IP/FQDN table.
|[Continuous export of telemetry from Application Insights](/previous-versions/azure/azure-monitor/app/export-telemetry)|Updated and clarified the continuous export notice.
|[Set up availability alerts with Application Insights](app/availability-alerts.md)|Added "Custom Alert Rule" and "Alert Frequency" sections.

### Autoscale

| Article | Description |
|:---|:---|
| [Set up autoscale for a web app with a custom metric](autoscale/autoscale-custom-metric.md) |Rewritten to improve clarity.|
[Overview of autoscale in Azure](autoscale/autoscale-overview.md)|Rewritten to improve clarity.|

### Containers

| Article | Description |
|:---|:---|
|[Overview of Container insights](containers/container-insights-overview.md)|Added information about deprecation of Docker support.|
|[Enable Container insights](containers/container-insights-onboard.md)|Updated all Container insights content for new support of managed identity authentication by using Azure Monitor Agent.|

### Essentials

| Article | Description |
|:---|:---|
|[Tutorial: Editing data collection rules](essentials/data-collection-rule-edit.md)|New article.|
|[Data collection rules in Azure Monitor](essentials/data-collection-rule-overview.md)|Rewritten to improve clarity.|
|[Data collection transformations](essentials/data-collection-transformations.md)|Rewritten to improve clarity.|
|[Data collection in Azure Monitor](essentials/data-collection.md)|New article.|
|[Migrate from diagnostic settings storage retention to Azure Storage lifecycle policy](essentials/migrate-to-azure-storage-lifecycle-policy.md)|New article.|

### Logs

| Article | Description |
|:---|:---|
|[Logs Ingestion API in Azure Monitor (preview)](logs/logs-ingestion-api-overview.md)|Custom logs API renamed to Logs Ingestion API.
|[Tutorial: Send data to Azure Monitor Logs by using the REST API (Resource Manager templates)](logs/tutorial-logs-ingestion-api.md)|Custom logs API renamed to Logs Ingestion API.
|[Tutorial: Send data to Azure Monitor Logs by using the REST API (Azure portal)](logs/tutorial-logs-ingestion-portal.md)|Custom logs API renamed to Logs Ingestion API.

### Virtual machines

| Article | Description |
|:---|:---|
|[What is VM insights?](vm/vminsights-overview.md)|Updated all VM insights content for new support of Azure Monitor Agent.

## June 2022

### General

| Article | Description |
|:---|:---|
| [Tutorial: Editing data collection rules](essentials/data-collection-rule-edit.md) | New article.|

### Application Insights

| Article | Description |
|:---|:---|
| [Application Insights logging with .NET](app/ilogger.md) | Added connection string sample code.|
| [Application Insights SDK support guidance](app/sdk-support-guidance.md) | Updated SDK supportability guidance. |
| [Azure AD authentication for Application Insights](app/azure-ad-authentication.md) | Azure AD authenticated telemetry ingestion reached general availability.|
| [Application Insights for JavaScript web apps](app/javascript.md) | Our Java on-premises page is retired and redirected to [Azure Monitor OpenTelemetry-based autoinstrumentation for Java applications](app/opentelemetry-enable.md?tabs=java).|
| [Application Insights Telemetry Data Model: Telemetry context](app/data-model-complete.md#context) | Clarified that Anonymous User ID is simply User.Id for easy selection in IntelliSense.|
| [Continuous export of telemetry from Application Insights](/previous-versions/azure/azure-monitor/app/export-telemetry) | On February 29, 2024, continuous export will be deprecated as part of the classic Application Insights deprecation.|
| [Dependency tracking in Application Insights](app/asp-net-dependencies.md) | Updated the Azure Event Hubs Client SDK and Azure Service Bus Client SDK information.|
| [Monitor Azure App Service performance and .NET Core](app/azure-web-apps-net-core.md) | Updated Linux troubleshooting guidance. |
| [Performance counters in Application Insights](app/performance-counters.md) | Added a prerequisite section to ensure performance counter data is accessible.|

### Agents

| Article | Description |
|:---|:---|
| [Collect text and IIS logs with Azure Monitor Agent (preview)](agents/data-collection-text-log.md) | Added "Troubleshooting" section.|
| [Tools for migrating to Azure Monitor Agent from legacy agents](agents/azure-monitor-agent-migration-tools.md) | New article: Explains how to install and use tools for migrating from legacy agents to the new Azure Monitor Agent.|

### Visualizations
Azure Monitor Workbooks documentation previously resided on an external GitHub repository. We've migrated all Azure Workbooks content to the same repo as all other Azure Monitor content.

## May 2022

### General

| Article | Description |
|:---|:---|
| [Azure Monitor cost and usage](cost-usage.md) | Added standard web tests to table.<br>Added explanation of billable GB calculation. |
| [Azure Monitor overview](overview.md) | Updated overview diagram. |

### Agents

| Article | Description |
|:---|:---|
| [Azure Monitor Agent extension versions](agents/azure-monitor-agent-extension-versions.md) | Updated to latest extension version. |
| [Azure Monitor Agent overview](agents/azure-monitor-agent-overview.md) | Added supported resource types. |
| [Collect text and IIS logs with Azure Monitor Agent (preview)](agents/data-collection-text-log.md) | Corrected an error in data collection rule. |
| [Overview of the Azure monitoring agents](agents/agents-overview.md) | Added new OS supported for agent. |
| [Resource Manager template samples for agents](agents/resource-manager-agent.md) | Added Bicep examples. |
| [Rsyslog data not uploaded due to Full Disk space issue on Azure Monitor Agent Linux Agent](agents/azure-monitor-agent-troubleshoot-linux-vm-rsyslog.md) | New article. |
| [Troubleshoot the Azure Monitor Agent on Linux virtual machines and scale sets](agents/azure-monitor-agent-troubleshoot-linux-vm.md) | New article. |
| [Troubleshoot the Azure Monitor Agent on Windows Arc-enabled server](agents/azure-monitor-agent-troubleshoot-windows-arc.md) | New article. |
| [Troubleshoot the Azure Monitor Agent on Windows virtual machines and scale sets](agents/azure-monitor-agent-troubleshoot-windows-vm.md) | New article. |

### Alerts

| Article | Description |
|:---|:---|
| [Configure Azure to connect ITSM tools by using Secure Webhook](alerts/itsm-connector-secure-webhook-connections-azure-configuration.md) | Added the workflow for ITSM management and removed all references to System Center Service Manager. |
| [Overview of Azure Monitor Alerts](alerts/alerts-overview.md) | Complete rewrite. |
| [Resource Manager template samples for log search alerts](alerts/resource-manager-alerts-log.md) | Added Bicep samples for alerting to the Resource Manager template samples articles. |
| [Supported resources for metric alerts in Azure Monitor](alerts/alerts-metric-near-real-time.md) | Added a newly supported resource type. |

### Application Insights

| Article | Description |
|:---|:---|
| [Application Map in Application Insights](app/app-map.md) | Application Maps Intelligent View feature. |
| [Application Insights for ASP.NET Core applications](app/asp-net-core.md) | The `telemetry.Flush()` guidance is now available. |
| [Diagnose with Live Metrics Stream](app/live-stream.md) | Updated information on using unsecure control channel. |
| [Migrate an Azure Monitor Application Insights classic resource to a workspace-based resource](/previous-versions/azure/azure-monitor/app/convert-classic-resource) | Schema change documentation is now available. |
| [Profile production apps in Azure with Application Insights Profiler](profiler/profiler-overview.md) | Profiler documentation now has a new home in the TOC. |

All references to unsupported versions of .NET and .NET CORE are scrubbed from Application Insights product documentation. See [.NET and .NET Core Support Policy](https://dotnet.microsoft.com/platform/support/policy/dotnet-core).

### Change Analysis

| Article | Description |
|:---|:---|
| [Navigate to a change by using custom filters in Change Analysis](change/change-analysis-custom-filters.md) | New article. |
| [Pin and share a Change Analysis query to the Azure dashboard](change/change-analysis-query.md) | New article. |
| [Use Change Analysis in Azure Monitor to find web app issues](change/change-analysis.md) | Added details for enabling web app in-guest changes. |

### Containers

| Article | Description |
|:---|:---|
| [Configure ContainerLogv2 schema (preview) for Container insights](containers/container-insights-logs-schema.md) | New article: Describes new schema for container logs. |
| [Enable Container insights](containers/container-insights-onboard.md) | Rewritten to improve clarity. |
| [Resource Manager template samples for Container insights](/azure/azure-monitor/containers/kubernetes-monitoring-enable?tabs=arm#enable-container-insights) | Added Bicep examples. |

### Insights

| Article | Description |
|:---|:---|
| [Troubleshoot SQL Insights (preview)](/azure/azure-sql/database/sql-insights-troubleshoot) | Added known issue for OS computer name. |

### Logs

| Article | Description |
|:---|:---|
| [Azure Monitor customer-managed key](logs/customer-managed-keys.md) | Updated limitations and constraint. |
| [Design a Log Analytics workspace architecture](logs/workspace-design.md) | Rewritten to better describe decision criteria and include Microsoft Sentinel considerations. |
| [Manage access to Log Analytics workspaces](logs/manage-access.md) | Consolidated and rewrote all content on configuring workspace access. |
| [Restore logs in Azure Monitor (preview)](logs/restore.md) | Documented new Log Analytics table management configuration UI, which lets you configure a table's log plan and archive and retention policies. |

### Virtual machines

| Article | Description |
|:---|:---|
| [Migrate from VM insights guest health (preview) to Azure Monitor log alerts](vm/vminsights-health-migrate.md) | New article: Describes process to replace VM guest health with alert rules. |
| [VM insights guest health (preview)](vm/vminsights-health-overview.md) | Added deprecation statement. |

---
