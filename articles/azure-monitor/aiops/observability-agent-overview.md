---
title: Azure Copilot observability agent (preview)
description: This article explains what Azure Copilot observability agent is and how it investigates issues within Azure Monitor to provide automated troubleshooting insights.
ms.topic: concept-article
ms.service: azure-monitor
ms.collection: ce-skilling-ai-copilot
ms.reviewer: yalavi
ms.date: 02/12/2026
ms.custom: references_regions
# Customer intent: As an Azure Monitor user, I want to understand what the Azure Copilot observability agent is, how it works, and how to use it for troubleshooting issues detected by Azure Monitor alerts.
---

# Azure Copilot observability agent (preview)

The Azure Copilot observability agent is an AI-powered system that helps you troubleshoot problems detected by Azure Monitor. When issues occur with your applications and Azure resources, the observability agent analyzes telemetry data, identifies anomalies, and produces insights. These insights help you understand and resolve problems more efficiently.

The observability agent provides a chat-first troubleshooting experience, so you can explore problems, ask questions, and run structured analysis as part of your investigation workflow.

## What the observability agent does

When you initiate troubleshooting (typically from an alert or during a session in Azure Copilot), the observability agent analyzes the problem by:

- Analyzing telemetry data from the affected resources and related systems
- Detecting anomalies in metrics, logs, and other observability signals
- Correlating data across multiple data sources to understand the scope of the problem
- Generating analysis with explanations of what happened and recommended next steps

## Run an investigation with the observability agent

As part of the troubleshooting experience, the observability agent can run an investigation.

During an investigation, the agent applies a set of analysis capabilities to help surface potential causes and insights, including:

- **Metric anomaly analysis** - Examines metric data to identify unusual patterns and provides explanations
- **Application log analysis** - Scans logs to identify top failure events with detailed breakdowns
- **Diagnostic insights** - Provides actionable recommendations based on Azure support best practices
- **Smart scoping** - Automatically expands the investigation scope by identifying related resources

:::image type="content" source="media/observability-agent-overview/investigation-start.png" alt-text="Screenshot of Azure portal displaying API-RequestFailures investigation with latency metrics and request code breakdown." lightbox="media/observability-agent-overview/investigation-start.png":::

## Investigation results

Investigation results describe anomalous behavior identified during the investigation that could explain a problem with a resource.

You can view investigation results for up to 48 hours unless you save them as part of an issue.

The results include:

- What happened – A summary of the observed behavior and affected resources.
- Next steps – Suggested actions for further investigation or mitigation.
- Supporting data – Evidence such as metric anomalies, logs, diagnostics insights, resource changes, and related alerts.

:::image type="content" source="media/observability-agent-overview/investigation-results.png" alt-text="Screenshot of Azure Monitor investigation results with summary, supporting data, and Create Issue option visible." lightbox="media/observability-agent-overview/investigation-results.png":::

## Saving investigation results in an issue

After an investigation completes, choose whether to persist its results by creating an Azure Monitor issue.

- When you create an issue, you save the investigation results and supporting data in a persistent context. You can track the problem, review results over time, and take further action.
- When you don't create an issue, the investigation remains available as a standalone (issue-less) investigation for up to 48 hours. After that period, the results are automatically deleted.

:::image type="content" source="media/observability-agent-overview/create-issue.png" alt-text="Screenshot of Azure Monitor investigation workflow, highlighting the Create Issue form with input fields and a Create Issue option." lightbox="media/observability-agent-overview/create-issue.png":::
For more information about Azure Monitor issues and capabilities, see [Azure Monitor issues](aiops-issue-and-investigation-how-to.md).

## Integration with Azure Monitor workflows

The observability agent integrates into standard Azure Monitor troubleshooting workflows, so you can investigate problems directly from familiar entry points.

Alert‑driven access (portal and notifications) – You can launch the observability agent from Azure Monitor alerts. Use the Investigate action in alert notifications, such as email, or from the alert details page in the Azure portal.

Azure Copilot integration – You can invoke the agent during troubleshooting workflows in Azure Copilot.

:::image type="content" source="media/observability-agent-overview/issue-integration-investigate-option.png" alt-text="Screenshot of Azure Monitor alert summary with failed requests graph and option to start an Investigate action." lightbox="media/observability-agent-overview/issue-integration-investigate-option.png":::

## Data security and encryption

The observability agent processes conversation data and investigation context to provide troubleshooting insights.

Customer Managed Keys (CMK) aren't supported for observability agent conversation data at this time. The data is encrypted by using Microsoft-managed encryption keys in accordance with Azure data protection standards.

Support for other encryption options, including CMK, might be considered in the future.

### Investigation data retention

For operational, quality, and future product improvement purposes, you might retain investigation data internally for up to 30 days after an investigation is completed.

## Technical requirements

- Azure Monitor supports the observability agent in selected Azure regions. See the following section for details.
- To create and manage Azure Monitor issues:
    - Associate the subscription with an Azure Monitor Workspace (AMW).
    - Have appropriate permissions on the AMW, such as *Contributor*, *Monitoring Contributor*, or *Issue Contributor*.

If you run investigations without creating an issue, you don't need an Azure Monitor Workspace or issue-specific permissions.

## Regions

The observability agent is currently available in the following Azure regions:

:::row:::
    :::column:::
        - australiacentral
        - australiaeast
        - australiasoutheast
        - brazilsouth
        - canadacentral
        - canadaeast
        - centralindia
        - centralus
        - chilecentral
        - eastasia
        - eastus
        - eastus2
    :::column-end:::
    :::column:::
        - eastus2euap
        - francecentral
        - germanywestcentral
        - indonesiacentral
        - israelcentral
        - italynorth
        - japaneast
        - japanwest
        - koreacentral
        - koreasouth
        - malaysiawest
    :::column-end:::
    :::column:::
        - mexicocentral
        - newzealandnorth
        - northcentralus
        - northeurope
        - northwayeast
        - polandcentral
        - southafricanorth
        - southcentralus
        - southindia
        - southeastasia
        - spaincentral
    :::column-end:::
    :::column:::
        - swedencentral
        - swedensouth
        - switzerlandnorth
        - uaenorth
        - uksouth
        - ukwest
        - westcentralus
        - westeurope
        - westus
        - westus2
        - westus3
    :::column-end:::
:::row-end:::

## Related content

- [Azure Monitor issues and investigations overview](aiops-issue-and-investigation-overview.md) - Detailed technical documentation
- [Use Azure Monitor issues and investigations](aiops-issue-and-investigation-how-to.md) - Step-by-step usage guide
- [Best practices for Azure Monitor investigations](observability-agent-best-practices.md) - Optimization guidance