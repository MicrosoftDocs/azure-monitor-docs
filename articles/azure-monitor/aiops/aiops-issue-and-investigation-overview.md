---
title: Azure Monitor issue and investigation (preview)
description: This article explains what Azure Monitor issue and investigation is and how it's used to triage and mitigate problems with an Azure resource.
ms.topic: how-to
ms.servce: azure-monitor
ms.reviewer: enauerman
ms.date: 09/02/2025
ms.custom: references_regions
---

# Azure Monitor issues and investigations (preview)

Azure Monitor issues and investigations (preview) are AIOps capabilities that automate the troubleshooting processes for [Azure monitor alerts](/azure/azure-monitor/alerts/alerts-overview). The [Observability Agent](observability-agent-overview.md) is the AI-powered system that investigates issues and produces findings to help resolve problems with Azure resources.

This article explains how Azure Monitor issues and investigations (preview) are used to triage and mitigate problems with an Azure resource.

## What is an issue?

An issue is a holistic view of service-related problems providing a structured framework for managing incidents. It uses AI for automated analysis and diagnostic processes to deliver high-quality insights using all observability-related data for fast and accurate troubleshooting service health degradations.

An issue presents an overview, the investigation, details about the alerts, and the resources involved.

You can set the severity, status, and impact time of an issue.

:::image type="content" source="media/issue-frame.png" alt-text="Screenshot of issue." lightbox="media/issue-frame.png":::

## What is an investigation?

An investigation is an analysis performed by [Observability Agent](observability-agent-overview.md) that produces findings within the context of an issue. Observability Agent uses AI-based, iterative triage and diagnostic processes to minimize manual effort and enable faster and more accurate troubleshooting.

Only the latest investigation is displayed. Users can edit the scope and impact time and trigger Observability Agent to run a new investigation. Observability Agent scans up to two hours of telemetry from the issue impact time.

### Findings

Findings identify anomalous behavior that could explain a problem with a service resource. They summarize the analysis of multiple anomalies (for example, "VM performance is low due to possible memory leak") based on relevant signals (metrics, logs, etc.) and might suggest further investigation steps and potential mitigations.

A finding contains a summary that can include:

- **What happened?** A description of the finding with the resources included in the investigation.
- **A possible explanation.** A description of what might be causing problems for the specific finding and related supporting data.
- **Next steps.** Suggestions for continuing the investigation or mitigating the problems.
- **Supporting data.** Supporting data is the information that justifies the finding, such as anomalies, diagnostics insights, health data, resource changes, related resources, and related alerts.

> [!NOTE]
> Up to five findings are displayed and all other anomalies are grouped into **Additional data**.

## Supporting data types for findings

### Metric anomaly explanations

In addition to detecting anomalies, explanations are created based the metric dimensions, for example, the specific region or error code of the anomaly.

:::image type="content" source="media/metric-anomalies.png" alt-text="Screenshot of metric anomalies." lightbox="media/metric-anomalies.png":::

### Application logs Analysis

Observability Agent scans the application logs for anomalies. The top three failure events (for dependencies, requests and exceptions) are analyzed. For each event:

- **Explanation**: An explanation of what happened is generated for the failure.
- **Transaction Examples**: A list of examples of transactions in which the specific failure event exists. Selecting the example displays the end-to-end transaction in Application Insights.
- **Exceptions**: If there are specific exception problem identifiers (IDs) that correlate with the failure, they are displayed with the count of appearance in the logs. The problem IDs are explained in natural language and an example is provided.
- **Transaction Pattern**: If there's a specific transaction pattern the failure, it's displayed. This information can help explain the issue and show the root cause. If there are multiple transaction patterns, no pattern is displayed.
- **Trace Message Patterns**: If there are specific trace message patterns that correlate with the failure, they are displayed with the count of appearance in the logs. The patterns are explained in natural language and an example is provided.

:::image type="content" source="media/application-anomalies.png" alt-text="Screenshot of application anomalies." lightbox="media/application-anomalies.png":::

### Diagnostic insights

Provides actionable solutions and diagnostics based on abnormal telemetry from Azure support best practices, enhancing issue resolution efficiency.

:::image type="content" source="media/diagnostics-and-troubleshooting.png" alt-text="Screenshot of diagnostics and troubleshooting." lightbox="media/diagnostics-and-troubleshooting.png":::

### Related Alerts

Contains data from related, high-severity alerts on the issue scoped resource that occurred in the last 15 minutes. Those alerts are synced back to the issue and appear in the Alerts tab.

:::image type="content" source="media/related-alerts.png" alt-text="Screenshot of related alerts." lightbox="media/related-alerts.png":::

### Resource Health

Provides events data from [Azure Resource Health](/azure/service-health/resource-health-overview) about resource health degradation in the investigated period.

## Capabilities

### Configurable scope

Observability Agent makes suggestions for which resources to analyze based on the scope of the investigation. The default scope includes all metrics of the resource. You can change the scope to include up to five resources. See Scope the investigation in [Use issue and investigation](aiops-issue-and-investigation-how-to.md).

### Smart scoping

Observability Agent also offers smart scoping for Application Insight resources. In this case, possible suspected resources are automatically identified by looking at the dependencies and the infrastructure where the service is running then includes them in the analysis. This process happens during the investigation and the results are synced to the issue.

:::image type="content" source="media/smart-scoping.png" alt-text="Screenshot of smart scoping." lightbox="media/smart-scoping.png":::

## Issue and investigation initial workflow example

1. An alert email from Azure Monitor is received.
1. A select on the investigate button in the email creates an issue and starts Observability Agent investigation. The issue page on the Azure portal opens in your browser.
1. On the Issue page, you're presented with:
    1. The issue overview where the findings produced by Observability Agent are presented with summarized supporting data.
    1. Each finding contains the Observability Agent analysis summary, suggested actions to take and the supporting data used for the analysis.
1.  Every finding produced by Observability Agent presents more details on the potential cause and present next steps to choose from.

## Regions

These regions are the supported Azure regions for issues and investigation services:

| **Public preview region availability** |
|----------------------------------------|
| australiacentral                       |
| australiaeast                          |
| australisoutheast                      |
| brazilsouth                            |
| canadacentral                          |
| canadaeast                             |
| centralindia                           |
| centralus                              |
| chilecentral                           |
| eastasia                               |
| eastus                                 |
| eastus2                                |
| eastus2euap                            |
| francecentral                          |
| germanywestcentral                     |
| indonesiacentral                       |
| israelcentral                          |
| italynorth                             |
| japaneast                              |
| japanwest                              |
| koreacentral                           |
| koreasouth                             |
| malaysiawest                           |
| mexicocentral                          |
| newzealandnorth                        |
| northcentralus                         |
| northeurope                            |
| northwayeast                           |
| polandcentral                          |
| southafricanorth                       |
| southcentralus                         |
| southindia                             |
| southeastasia                          |
| spaincentral                           |
| swedencentral                          |
| swedensouth                            |
| switzerland north                      |
| uaenorth                               |        
| uksouth                                |
| ukwest                                 |
| westcentralus                          |
| westeurope                             |
| westus                                 |
| westus2                                |
| westus3                                | 

## Next steps

- [Azure Monitor Observability Agent overview](observability-agent-overview.md)
- [Use Azure Monitor issues and investigations](aiops-issue-and-investigation-how-to.md)
- [Azure Monitor issues and investigations (preview) responsible use](observability-agent-responsible-use.md)
- [Azure Monitor issues and investigations (preview) troubleshooting](observability-agent-troubleshooting.md)
