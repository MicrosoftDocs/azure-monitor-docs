---
title: Billing and cost management for Observability Agent in Azure Monitor
description: Learn how the Azure Monitor Observability Agent is billed, what's billable, when charges begin, and how to manage costs in Microsoft Cost Management.
ms.topic: concept-article
ms.service: azure-monitor
ms.date: 05/12/2026
---

# Billing and cost management for Observability Agent in Azure Monitor

The Observability Agent in Azure Monitor uses generative AI to investigate, diagnose, and explain issues across your monitored resources. Because the agent calls large language models (LLMs), usage incurs costs. This article explains how the Observability Agent is billed, what is billable today, and how to control spend in Azure Cost Management.

> [!IMPORTANT]
> Billing for the Observability Agent starts on **July 1, 2026**.

## How the Observability Agent is billed

The Observability Agent uses a **consumption-based** pricing model. You pay only for the AI work the agent performs. Agent consumption is measured in **Azure Agent Credit (AAC)**. AAC pricing is uniform across models, so you don't need to track per-model rates. AAC list prices are available on the [Azure Monitor pricing page](https://azure.microsoft.com/pricing/details/monitor/). Charges are scoped to the **Azure subscription** of the monitored resource.

Simple questions, such as "what was the maximum latency in this app yesterday?", typically use few tokens. A deep investigation though will consume many more tokens, and therefore incur higher cost.

> [!NOTE]
> Deep investigation operations include multiple agent and tool calls. A single deep investigation operation is capped at 300 AACs.


## Related content

- [Observability Agent in Azure Monitor overview](../aiops/observability-agent-overview.md)
- [Azure Monitor pricing](https://azure.microsoft.com/pricing/details/monitor/)

