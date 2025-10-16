---
title: Agentic Experience in Azure Operations Center (preview)
description: Provides an overview of the agentic experience in Azure Operations Center, highlighting AI-driven guidance and automation features to enhance operational workflows.
ms.topic: conceptual
ms.date: 09/24/2025
---


# Agentic Experience in Azure Operations Center (preview)

Ops360 introduces an agentic experience, leveraging AI-driven guidance and automation to enhance operational workflows. This experience provides interactive, context-aware assistance that helps users troubleshoot, automate, and optimize operations.

## Key Capabilities
- Guided troubleshooting with step-by-step recommendations
- Automated remediation for common issues
- Contextual insights based on telemetry and logs
- Integration with Azure Copilot and other AI services

## Benefits
- Reduces mean time to resolution (MTTR)
- Empowers users with actionable insights
- Improves operational efficiency

## Cost

- Needed for Ignite?

## Associated content

- [Azure Monitor issues and investigations (preview)](/azure/azure-monitor/aiops/aiops-issue-and-investigation-overview)
- [Use Azure Monitor issues and investigations (preview)](/azure/azure-monitor/aiops/aiops-issue-and-investigation-how-to)

## Prerequisites
- Associate an Azure Monitor workspace with subscription.

## Scenarios

### Investigations

- **Scenario 1**: A user encounters a performance degradation in their application. The agentic experience provides step-by-step guidance to identify the root cause and suggests automated remediation actions.
  - Create an investigation from an alert. Same as [Ways to start an investigation on an alert](/azure/azure-monitor/aiops/aiops-issue-and-investigation-how-to#ways-to-start-an-investigation-on-an-alert).
  - Invoke Copilot to explore options and assist with mitigation.
    - Opens Copilot in a side pane.
    - Examples for messaging with Copilot.

- **Scenario 2**: Administrator is getting reports of a problem but can't identify the source. They start an investigation with Copilot.
  - Copilot creates the investigation.
  - Invoke Copilot to explore options and assist with mitigation.
  - Same path as scenario 1.

- **Scenario 3**: User troubleshooting an issue, needs to open ticket with Microsoft. Copilot helps gather information and open ticket.
  - Invoke Copilot to explore options and assist with mitigation.
  - Copilot gathers information from investigation, telemetry, logs, etc.
  - Copilot opens ticket with Microsoft.

### Optimization

- **Scenario 1:** Potential actions to reduce cost.
- **Scenario 2:** Explanations of how recommendations were created to ensure understanding of impact of acting on them.
- **Scenario 3:** Recommendations that are immediately actionable and validated against quota and capacity constraints to prevent implementation failures.
- **Scenario 4:** Additional options if the top recommendations don’t work. 
- **Scenario 5:** Understand both the performance improvement and cost impact of making the change upsizing Virtual Machines.

