---
title: Azure Monitor issues (preview)
description: Learn how Azure Monitor issues provide persistent context for troubleshooting investigations and help you analyze and retain troubleshooting data.
ms.topic: concept
ms.service: azure-monitor
ms.reviewer: enauerman
ms.date: 02/12/2026
ms.custom: references_regions
---

# Azure Monitor issues (preview)

Azure Monitor issue is an AIOps capability that helps you analyze and troubleshoot problems detected by Azure Monitor alerts. This article describes the capabilities available in issues, and how you use them to analyze and retain troubleshooting data.

The [observability agent](observability-agent-overview.md) provides two main concepts for analyzing and retaining troubleshooting data: **investigations** and **issues**.

## What is an issue?

An issue provides a persistent context for investigation results and related troubleshooting data. Use issues to retain investigation results, supporting data, and collaborate with your team over time.

Issues provide persistence and context for troubleshooting efforts. When you save an investigation to an issue, you can:

- Track problems over time
- Review investigation results and supporting data
- Collaborate with team members
- Set severity, status, and impact time

## How issues work

The following workflow shows how issues integrate with investigations:

1. An alert triggers in Azure Monitor. You can access the alert from an alert notification (such as email) or from the Azure portal.
1. You select **Investigate** to open a chat-based troubleshooting session with the observability agent.
1. You invoke investigation capabilities within the conversation to analyze the detected problem.
1. The observability agent analyzes telemetry data and produces analysis based on available signals.
1. After the investigation is complete, you can optionally create an issue by selecting **Create Issue**.

**When you create an issue**, you save and retain the investigation in the context of the issue. The investigation results and supporting data persist for future reference.

**When you don't create an issue**, the system temporarily makes the investigation available for up to 48 hours. After that, results are automatically deleted.

## Investigation results

When an investigation completes, it produces results that include:

- **Analysis summary** - Detailed analysis, including summaries, suggested actions, and supporting evidence.
- **Supporting data** - Evidence such as metric anomalies, application logs, diagnostics insights, and related alerts.
- **Context** - Related alerts and affected resources.

For information about the observability agent and investigation capabilities, see [Azure Copilot observability agent](observability-agent-overview.md).

## Supporting data types

### Metric anomaly explanations

In addition to detecting anomalies, explanations are created based on the metric dimensions, for example, the specific region or error code of the anomaly.

### Application log analysis

The observability agent scans the application logs for anomalies. The top three failure events (for dependencies, requests, and exceptions) are analyzed. For each event:

- **Explanation** - An explanation of what happened is generated for the failure.
- **Transaction examples** - A list of examples of transactions in which the specific failure event exists. Selecting the example displays the end-to-end transaction in Application Insights.
- **Exceptions** - If there are specific exception problem identifiers (IDs) that correlate with the failure, they're displayed with the count of appearance in the logs. The problem IDs are explained in natural language and an example is provided.
- **Transaction pattern** - If there's a specific transaction pattern for the failure, it's displayed. This information can help explain the issue and show the root cause. If there are multiple transaction patterns, no pattern is displayed.
- **Trace message patterns** - If there are specific trace message patterns that correlate with the failure, they're displayed with the count of appearance in the logs. The patterns are explained in natural language and an example is provided.

### Diagnostic insights

Provides actionable solutions and diagnostics based on abnormal telemetry from Azure support best practices, enhancing issue resolution efficiency.

### Related alerts

Contains data from related, high-severity alerts on the issue scoped resource that occurred in the last 15 minutes. Those alerts are synced back to the issue and appear in the Alerts tab.

### Resource Health

Provides events data from [Azure Resource Health](/azure/service-health/resource-health-overview) about resource health degradation in the investigated period.

## Capabilities

### Configurable scope

The observability agent makes suggestions for which resources to analyze based on the scope of the investigation. The default scope includes all metrics of the resource. You can change the scope to include up to five resources. See Scope the investigation in [Use issue and investigation](aiops-issue-and-investigation-how-to.md).

### Smart scoping

The observability agent also offers smart scoping for Application Insight resources. In this case, possible suspected resources are automatically identified by looking at the dependencies and the infrastructure where the service is running, then includes them in the analysis. This process happens during the investigation and the results are synced to the issue.

## Regions

These regions are the supported Azure regions for issues and investigation services:

| **Public preview region availability** |
|----------------------------------------|
| australiacentral                       |
| australiaeast                          |
| australiasoutheast                     |
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
| norwayeast                             |
| polandcentral                          |
| southafricanorth                       |
| southcentralus                         |
| southindia                             |
| southeastasia                          |
| spaincentral                           |
| swedencentral                          |
| swedensouth                            |
| switzerlandnorth                       |
| uaenorth                               |
| uksouth                                |
| ukwest                                 |
| westcentralus                          |
| westeurope                             |
| westus                                 |
| westus2                                |
| westus3                                |

## Related content

- [Azure Copilot observability agent](observability-agent-overview.md)
- [Use Azure Monitor issues and investigations](aiops-issue-and-investigation-how-to.md)
- [Azure Copilot observability agent responsible use](observability-agent-responsible-use.md)
- [Azure Copilot observability agent troubleshooting](observability-agent-troubleshooting.md)
