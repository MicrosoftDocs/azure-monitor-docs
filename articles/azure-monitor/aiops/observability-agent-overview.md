---
title: Azure Copilot observability agent (preview)
description: Learn how Azure Copilot observability agent provides AI-powered, chat-first troubleshooting for Azure Monitor alerts and resources.
ms.topic: concept
ms.service: azure-monitor
ms.reviewer: yalavi
ms.date: 02/12/2026
ms.custom: references_regions
---

# Azure Copilot observability agent (preview)

Azure Copilot observability agent is an AI-powered system that helps you troubleshoot problems detected by Azure Monitor. When issues occur with your applications and Azure resources, the observability agent analyzes telemetry data, identifies anomalies, and produces insights. These insights help you understand and resolve problems faster.

The observability agent provides a chat-first troubleshooting experience, so you can explore problems, ask questions, and run structured analysis as part of your natural workflow.

## What does the observability agent do?

When you initiate troubleshooting (typically from an alert or during a session in Azure Copilot), the observability agent:

- Analyzes telemetry data from the affected resources and related systems
- Detects anomalies in metrics, logs, and other observability signals
- Correlates data across multiple data sources to understand the scope of the problem
- Generates analysis with explanations of what happened and recommended next steps

As part of the troubleshooting experience, the observability agent can run an investigation to perform structured analysis of your telemetry data.

## Investigation capabilities

During an investigation, the agent applies a set of analysis capabilities to help identify issues:

- **Metric anomaly analysis** - Examines metric data to identify unusual patterns and provides explanations.
- **Application log analysis** - Scans logs to identify top failure events with detailed breakdowns.
- **Diagnostic insights** - Provides actionable recommendations based on Azure support best practices.
- **Smart scoping** - Automatically expands the investigation scope by identifying related resources.

## Investigation results

Investigation results describe anomalous behavior identified during the investigation. Results include summaries of what happened, possible explanations, and suggested next steps.

Investigation results are available for a limited period of time (up to 48 hours) unless you save them to an issue. Each investigation result includes:

- **Analysis summary** - A summary of identified problems with explanations 
- **Supporting data** - Evidence such as metric anomalies, logs, diagnostics insights, and related alerts that justify the analysis

## Retaining investigation results with issues

After an investigation completes, you can choose whether to persist its results by creating an issue:

- **When you create an issue**, you save the investigation results and supporting data in a persistent context. You can track the problem, review results over time, and collaborate with your team.
- **When you don't create an issue**, the investigation remains available as a standalone investigation for up to 48 hours. After that period, the results are automatically deleted.

For more information about Azure Monitor issues and capabilities, see [Azure Monitor issues](aiops-issue-and-investigation-overview.md).

## Integration with Azure Monitor workflows

The observability agent is integrated into standard Azure Monitor troubleshooting workflows, allowing you to investigate problems directly from familiar entry points:

- **Alert-driven access (portal and notifications)** - The observability agent can be launched from Azure Monitor alerts, either from alert notifications (for example, email) or from the alert details page in the Azure portal, using the **Investigate** button.
- **Azure Copilot integration** - Can be invoked during troubleshooting workflows in Azure Copilot.

## Data privacy

The observability agent processes conversation data and investigation context to provide troubleshooting insights. Consider the following:

- Customer Managed Keys (CMK) aren't supported for observability agent conversation data at this time. The data is encrypted by using Microsoft-managed encryption keys. Support for other encryption options, including CMK, might be considered in the future.
- For operational, quality, and future product improvement purposes, Microsoft might retain investigation data internally for up to 30 days after an investigation is completed.

## Requirements

- Subscription must be associated with an Azure Monitor Workspace (AMW) if you want to save investigations to issues.
- Have appropriate permissions on the AMW, such as Contributor, Monitoring Contributor, or Issue Contributor role.
- If you run investigations without creating an issue, you don't need an Azure Monitor Workspace.

## Supported regions

The observability agent is supported in selected Azure regions. For details, see [Regions](aiops-issue-and-investigation-overview.md#regions).

## Related content

- [Azure Monitor issues](aiops-issue-and-investigation-overview.md)
- [Use Azure Monitor issues and investigations](aiops-issue-and-investigation-how-to.md)
- [Best practices for Azure Monitor investigations](observability-agent-best-practices.md)
