---
title: Azure Copilot observability agent (preview)
description: This article explains what Azure Copilot observability agent is and how it investigates issues within Azure Monitor to provide automated troubleshooting insights.
ms.topic: how-to
ms.service: azure-monitor
ms.reviewer: yalavi
ms.date: 10/28/2025
ms.custom: references_regions
---

# Azure Copilot observability agent (preview)

Azure Copilot observability agent is an AI-powered system that automatically investigates issues within Azure Monitor. When problems occur with your applications and Azure resources, the observability agent analyzes telemetry data, identifies anomalies, and produces findings to help you understand and resolve issues faster.

## What does the observability agent do?

When an issue is created (typically from an alert or invoked during troubleshooting in Azure Copilot), the observability agent investigates it by:

- **Analyzes telemetry data** from the affected resources and related systems
- **Detects anomalies** in metrics, logs, and other observability signals
- **Correlates data** across multiple data sources to understand the scope of problems
- **Generates findings** with explanations of what happened and potential next steps
- **Persists results** in the issue for review and action

## Investigation capabilities overview

The investigation provides comprehensive analysis capabilities including:

- **Metric anomaly analysis** - Examines metric data to identify unusual patterns with explanations
- **Application log analysis** - Scans logs to identify top failure events with detailed breakdowns
- **Diagnostic insights** - Provides actionable solutions based on Azure support best practices  
- **Smart scoping** - Automatically expands investigation scope by identifying related resources

For detailed information about each capability and the supporting data types they produce, see [Supporting data types for findings](aiops-issue-and-investigation-overview.md#supporting-data-types-for-findings).

## How it works with issues

The observability agent operates within the context of Azure Monitor issues:

- **Issue creation** - When you create an issue, it triggers the observability agent
- **Investigation execution** - The agent analyzes telemetry from the issue impact time (see [technical details](aiops-issue-and-investigation-overview.md#what-is-an-investigation) for scope and timing)
- **Finding generation** - Results are organized into findings that explain what happened, possible causes, and next steps
- **Supporting data correlation** - Supporting data is attached to each finding for validation and deeper analysis

## Integration with Azure Monitor workflow

The observability agent is seamlessly integrated into the standard Azure Monitor troubleshooting workflow:

- **Alert-driven** - Accessible from alert email notifications via the "Investigate" button
- **Portal integration** - Available from the Azure portal alerts interface
- **Copilot integration** - Can be invoked during troubleshooting workflows in Azure Copilot
- **Collaboration ready** - Results are persisted in issues for team collaboration and tracking
- **Actionable guidance** - Findings include specific next steps for problem resolution

For a complete workflow example, see [Issue and investigation initial workflow](aiops-issue-and-investigation-overview.md#issue-and-investigation-initial-workflow-example).

## Technical requirements

- Subscription must be associated with an Azure Monitor Workspace (AMW)
- Appropriate permissions (Contributor, Monitoring Contributor, or Issue Contributor role on the AMW)
- Supported in specific Azure regions (see [complete regional availability list](aiops-issue-and-investigation-overview.md#regions))

## Related content

- [Azure Monitor issues and investigations overview](aiops-issue-and-investigation-overview.md) - Detailed technical documentation
- [Use Azure Monitor issues and investigations](aiops-issue-and-investigation-how-to.md) - Step-by-step usage guide
- [Best practices for Azure Monitor investigations](observability-agent-best-practices.md) - Optimization guidance
