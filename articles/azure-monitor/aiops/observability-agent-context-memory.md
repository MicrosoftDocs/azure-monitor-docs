---
title: Operational context and memory in Azure Copilot Observability Agent (preview)
description: Learn how Azure Copilot Observability Agent builds, stores, and reuses operational context across chat, deep investigations, issues, and Observability Agent resources.
ms.topic: concept-article
ms.service: azure-monitor
ms.collection: ce-skilling-ai-copilot
ms.date: 06/15/2026
ai-usage: ai-assisted
# Customer intent: As an Azure Monitor user, I want to understand what context the Observability Agent keeps, what expires, what persists, and how to configure resource-level context, so my team can get more consistent incident analysis across rotations.
---

# Operational context and memory in Azure Copilot Observability Agent (preview)

The Azure Copilot Observability Agent uses context from your telemetry, alerts, topology, and configuration to explain incidents and suggest next steps. Some context is short-lived and conversation-scoped, while other context is durable and tied to Azure Monitor issues or an Observability Agent resource. This article describes where that context is stored and how it is reused across workflows.


## Context layers

The Observability Agent works with three practical context layers:

- **Session context (short-lived).** Chat and investigation follow-up context in the current conversation.
- **Issue context (durable incident record).** Findings and investigation outputs saved to an Azure Monitor issue.
- **Resource context (durable operational memory).** Scope, identity, and custom instructions stored on an Observability Agent resource.

These layers work together. You can start with short-lived exploration, promote useful findings into issues, and apply durable resource-level instructions so autonomous correlation reflects your environment conventions.

## What persists and where

| Context type | Where it lives | Lifetime | Who governs access |
|---|---|---|---|
| Chat and follow-up context | Active Observability Agent session | Up to 24 hours | Azure Copilot access plus user Azure RBAC for in-scope data |
| Deep-investigation output that you save | Azure Monitor issue | Until issue lifecycle actions change or close it | Azure Monitor workspace Azure RBAC |
| Custom instructions | Observability Agent resource  | Durable until edited or deleted | Resource-group Azure RBAC (for example, Monitoring Contributor) |
| Autonomous scope | Child resources under the Observability Agent resource | Durable until changed | Resource-group Azure RBAC |

For the 24-hour session limit, see [Current limitations](observability-agent-overview.md#current-limitations).

## Session context

During a single conversation session, the Observability Agent retains context about the specific signals you're investigating, any patterns you've discussed, and your follow-up questions. This session context is temporary and cleared when you end the chat or investigation session.

When you invoke the Observability Agent for the first time for chat or investigation, the agent learns about your application's topology, baseline patterns, dependencies, and typical behavior directly from your telemetry. This initial learning happens automatically as part of your first session context. If you later create an Observability Agent resource, the agent will perform this learning again and retain it durably as resource context for future autonomous operations.

## How the agent builds context

During analysis, the Observability Agent combines:

- Telemetry and alert context from in-scope resources.
- Application and dependency topology from scoped Application Insights resources.
- Existing issue content when you continue work on an issue.
- Optional custom instructions that encode service boundaries, priorities, and local operating rules.

This model helps the agent move from signal interpretation toward incident explanation while keeping decisions and mitigations with humans.

## Why resource-level memory matters for operations

Without an Observability Agent resource, context is mostly session-scoped. With a resource, your team can define durable instructions once and reuse them across autonomous runs.

This improves consistency for:

- **On-call handoffs.** New responders inherit the same service boundaries and escalation assumptions.
- **Noise reduction.** Correlation decisions can align to your topology and business-critical paths.
- **Governance.** Context configuration is auditable as Azure resource state.

To understand the resource model, see [Azure Copilot Observability Agent resource](observability-agent-resource.md).

## Design guidance for teams

Use these patterns to keep context useful and maintainable:

- Keep custom instructions specific and operational. Prefer concrete rules over broad goals.
- Store durable team knowledge in resource-level instructions, not only in one-off chat prompts.
- Use Azure Monitor issues as the persistent record for incident findings and cross-shift collaboration.
- Review and refine instructions as your service topology or ownership model changes.

For operational examples, see [Autonomous operations in the Azure Copilot Observability Agent](observability-agent-autonomous-operations.md).

## Governance and privacy boundaries

Resource-level context is configuration data on an Azure resource and follows Azure governance controls. Issue content follows Azure Monitor workspace access controls. Session context remains scoped to the active experience and doesn't become durable operational configuration unless you store it in issues or resource settings.

For detailed governance and privacy guidance, see [Data, privacy, and governance FAQ for Azure Copilot Observability Agent](observability-agent-governance-faq.md).

## Related content

- [Azure Copilot Observability Agent](observability-agent-overview.md)
- [Autonomous operations in the Azure Copilot Observability Agent](observability-agent-autonomous-operations.md)
- [Azure Copilot Observability Agent resource](observability-agent-resource.md)
- [Azure Monitor issues overview](issues-overview.md)
