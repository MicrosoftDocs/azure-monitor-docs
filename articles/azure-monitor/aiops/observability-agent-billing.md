---
title: Billing and cost management for Azure Copilot Observability Agent
description: Learn how the Azure Monitor Observability Agent is billed, what's billable, when charges begin, and how to manage costs in Microsoft Cost Management.
ms.topic: concept-article
ms.service: azure-monitor
ms.date: 05/12/2026
ai-usage: ai-assisted
---

# Billing and cost management for Azure Copilot Observability Agent

The Observability Agent in Azure Monitor uses generative AI to investigate, diagnose, and explain issues across your monitored resources. Because the agent calls large language models (LLMs), usage incurs costs. This article explains how the Observability Agent is billed, what is billable today, and how to control spend in Azure Cost Management.

## How the Observability Agent is billed

Billing for the Observability Agent has been in effect since July 1, 2026.

The Observability Agent uses a **consumption-based** pricing model. You pay only for the AI work the agent performs. Agent consumption is measured in **Azure Agent Credit (AAC)**. AAC pricing is uniform across models, so you don't need to track per-model rates. AAC list prices are available on the [Azure Monitor pricing page](https://azure.microsoft.com/pricing/details/monitor/). Charges are scoped to the **Azure subscription** of the monitored resource.

Simple questions, such as "what was the maximum latency in this app yesterday?", typically use fewer tokens. A deep investigation consumes more agent and tool work, and therefore typically incurs higher cost.

## What is billable

The current Observability Agent experience has three main billing patterns:

- **Chat with your data.** Natural-language exploration of logs, metrics, and related telemetry consumes AAC based on the amount of agent and model work required to answer the question.
- **Deep investigations.** A deep investigation consumes AAC for the multi-step analysis that gathers signals, correlates findings, and produces a report.
- **Autonomous operations.** If autonomous correlation is configured to automatically trigger a deep investigation, the investigation itself is billed. Alert correlation is currently in public preview and isn't billed at this time.

These patterns share the same AAC unit, but they create different cost profiles depending on how often you use them and how much work the agent performs.

## On-demand chat and deep investigations

Chat and deep investigations are **on-demand** workflows. They consume AAC when a user actively asks the agent to do work.

- **Chat** is usually the lowest-cost pattern because it often answers a focused question or performs a smaller amount of analysis.
- **Deep investigation** usually costs more than chat because it orchestrates multiple agent and tool calls across application, infrastructure, and Azure platform signals.

> [!NOTE]
> Deep investigation operations include multiple agent and tool calls. A single deep investigation operation is capped at 500 AACs. For more information about what a deep investigation does, see [Deep investigations in the Azure Copilot Observability Agent](observability-agent-deep-investigations.md).

## Autonomous operations

Autonomous correlation is currently in public preview and isn't billed at this time. When billing for correlation begins, it will follow the same AAC unit as on-demand chat and deep investigations.

If you enable automatic deep investigation on agent-created issues, the investigation itself is billed:

- **Continuous correlation.** Alert correlation runs in the background and creates issues without a person opening chat. Correlation isn't billed during public preview.
- **Automatic deep investigations.** If the investigation operation is enabled, an autonomously created issue triggers an automatic deep investigation, which is billed. Each deep investigation operation is capped at 500 AAC, the same cap that applies to user-initiated deep investigations. You can turn off the automatic deep-investigation behavior so a person decides whether to run one.

For what runs autonomously, how to opt in, and how to manage the automatic deep-investigation behavior, see [Autonomous operations in the Azure Copilot Observability Agent](observability-agent-autonomous-operations.md).

## Manage and forecast costs

To manage Observability Agent costs:

- Use chat for targeted exploration before starting a deep investigation.
- Run deep investigations when you need cross-signal analysis and a structured report.
- Review the scope of autonomous operations carefully, because background correlation can consume AAC whenever new alerts arrive.
- Turn off automatic deep investigation for agent-created issues if you want a person to decide when that additional billable work runs.
- Use Microsoft Cost Management and the Azure Monitor pricing page to monitor and forecast spending.

## Related content

- [Observability Agent in Azure Monitor overview](../aiops/observability-agent-overview.md)
- [Autonomous operations in the Azure Copilot Observability Agent](observability-agent-autonomous-operations.md)
- [Deep investigations in the Azure Copilot Observability Agent](observability-agent-deep-investigations.md)
- [Azure Monitor pricing](https://azure.microsoft.com/pricing/details/monitor/)

