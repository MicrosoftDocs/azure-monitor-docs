---
title: Azure Copilot observability agent (preview)
description: This article explains what Azure Copilot observability agent is and how it investigates issues within Azure Monitor to provide automated troubleshooting insights.
ms.topic: concept-article
ms.service: azure-monitor
ms.collection: ce-skilling-ai-copilot
ms.reviewer: yalavi, ronitauber
ms.date: 02/24/2026
ms.custom: references_regions
# Customer intent: As an Azure Monitor user, I want to understand what the Azure Copilot observability agent is, how it works, and how to use it for troubleshooting issues detected by Azure Monitor alerts.
---

# Azure Copilot observability agent (preview)

The Azure Copilot observability agent is an AI-powered system designed to help you find the root cause of issues in complex, full-stack applications.

By analyzing telemetry across metrics, logs, and related Azure resources, the agent helps you understand what changed, where the problem originated, and how different components are connected across your environment.

The observability agent provides a chat-first investigation experience, designed to support troubleshooting workflows while focusing on structured, data-driven investigations.

## What the observability agent does

When you initiate an investigation (for example, from an alert), the observability agent analyzes the problem by:

- Analyzing telemetry data from the affected resources and related systems
- Detecting anomalies in metrics, logs, and other observability signals
- Correlating data across multiple data sources to understand the scope of the problem
- Generating analysis with explanations of what happened and recommended next steps

The agent surfaces its reasoning throughout the investigation, explaining how signals are correlated and why specific insights are generated, so you can follow and understand the investigation logic.

## Run an investigation with the observability agent


As part of the troubleshooting experience, the observability agent can run an investigation to help identify potential root causes and contributing factors.

The agent performs deep analysis and applies relevant analysis paths based on the signals it identifies, allowing the investigation to adapt to the specific characteristics of the issue.

Depending on the scenario, the agent may analyze and correlate signals from multiple sources, including logs and tracing data, metrics, alerts and alert context, resource health signals, and signals related to recent releases or system changes, when available.

By correlating these signals, the agent generates analysis that explains what happened, highlights abnormal behavior, and surfaces relevant insights. Investigations are interactive and conversational.

You can ask follow-up questions, refine the scope, or create additional investigations to explore different aspects or hypotheses related to the same problem.

:::image type="content" source="media/observability-agent-overview/investigation-start.png" alt-text="Screenshot of Azure portal displaying API-RequestFailures investigation with latency metrics and request code breakdown." lightbox="media/observability-agent-overview/investigation-start.png":::

## Investigation results

Investigation results describe anomalous behavior identified during the investigation that could explain a problem with a resource.

You can view investigation results for up to 48 hours unless you save them as part of an issue.

The results include:

- What happened – A summary of the observed behavior and affected resources.
- Next steps – Suggested actions for further investigation or mitigation.
- Supporting data – Evidence such as metric anomalies, logs, diagnostics insights, resource changes, and related alerts.

:::image type="content" source="media/observability-agent-overview/investigation-results.png" alt-text="Screenshot of Azure Monitor investigation results with summary, supporting data, and Create Issue option visible." lightbox="media/observability-agent-overview/investigation-results.png":::

Investigation results are available temporarily. To persist investigation results, create an Azure Monitor issue.

## Saving investigation results in an issue

When you create an Azure Monitor issue, the full investigation context is preserved, not just the final results.

This includes:

- Investigation results and supporting data
- The interactive conversation with the agent
- The reasoning and explanations presented to the user during the investigation

By saving an issue, you can return to the investigation at any time, resume the conversation, ask additional questions, and continue exploring the problem with full visibility into previous findings and reasoning.

:::image type="content" source="media/observability-agent-overview/create-issue.png" alt-text="Screenshot of Azure Monitor investigation workflow, highlighting the Create Issue form with input fields and a Create Issue option." lightbox="media/observability-agent-overview/create-issue.png":::

For more information about Azure Monitor issues and capabilities, see [Azure Monitor issues](aiops-issue-and-investigation-how-to.md).

## Integration with Azure Monitor workflows

The observability agent integrates into standard Azure Monitor troubleshooting workflows, so you can investigate problems directly from familiar entry points.

Alert‑driven access (portal and notifications) – You can launch the observability agent from Azure Monitor alerts. Use the **Investigate** action in alert notifications, such as email, or from the alert details page in the Azure portal.

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

The observability agent is currently available in the following Azure regions. Some parts of the processing are geographically-based rather than regional.

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

- [Azure Monitor issues and investigations overview](aiops-issue-and-investigation-overview.md) - Detailed technical documentation.
- [Use Azure Monitor issues and investigations](aiops-issue-and-investigation-how-to.md) - Step-by-step usage guide.
- [Best practices for Azure Monitor investigations](observability-agent-best-practices.md) - Optimization guidance.