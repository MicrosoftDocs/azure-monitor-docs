---
title: Autonomous operations - Azure Copilot Observability Agent (preview)
description: Learn how autonomous operations in the Azure Copilot Observability Agent correlate alerts and create Azure Monitor issues, while humans keep control of decisions.
ms.topic: concept-article
ms.service: azure-monitor
ms.collection: ce-skilling-ai-copilot
ms.reviewer: efratbp
ms.date: 06/10/2026
ms.custom: references_regions
ai-usage: ai-assisted
# Customer intent: As an Azure Monitor user responsible for an on-call rotation or AIOps strategy, I want to understand what the Observability Agent does autonomously, what's still user-initiated, and where humans stay in control, so I can decide whether to turn on autonomous correlation and issue creation and so my team knows what to expect when an autonomously created issue arrives.
---

# Autonomous operations in the Azure Copilot Observability Agent (preview)

Autonomous operations let the Azure Copilot Observability Agent do continuous preparation work in the background. The agent correlates related alerts, creates Azure Monitor issues, runs deep investigations on those issues, and assembles context, so your on-call team starts each incident with a short list of explained issues instead of a flood of raw alerts. The agent itself is otherwise an on-demand assistant that you point at a problem. Autonomous operations extend it with always-on triage through a controlled-autonomy model. Humans still make every decision that changes your environment.

This article helps you decide whether to turn on autonomous correlation and issue creation for your environment. It explains how the agent reasons over your alerts, what you can teach it with custom instructions, and what to expect when an autonomously created issue lands in your queue.

For a focused explanation of what context is session-scoped versus durable, see [Operational context and memory in Azure Copilot Observability Agent](observability-agent-context-memory.md).

> [!IMPORTANT]
> Autonomous operations in the Azure Copilot Observability Agent are currently in public preview. See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability.

## When to use autonomous operations versus on-demand workflows

Use **autonomous operations** when you want continuous, in-the-background reduction of alert noise into a small set of meaningful issues, and automatic deep investigations on those issues.

Use **on-demand chat or deep investigations** when you're actively exploring a specific problem. For on-demand workflows, see [Chat with your observability data](observability-agent-chat.md) and [Deep investigations in the Azure Copilot Observability Agent](observability-agent-deep-investigations.md).

For the billing implications of continuous, background work, see [Billing and cost management for Observability Agent in Azure Monitor](observability-agent-billing.md).

## What the agent runs autonomously

In public preview, the Observability Agent runs the following work autonomously across its in-scope environment:

- **Alert correlation into issues.** The agent continuously analyzes alerts as they fire, groups related alerts into a single Azure Monitor issue that represents what's actually happening, and attaches a natural-language explanation of *why* those alerts belong together.
- **Issues from individual prominent alerts.** Beyond correlated alert groups, the agent can also create an issue from a single high-impact alert when you tell it to. You drive this with custom instructions, for example, *"Always create an issue for `fintrack-servicebus-active-messages-backlog`"* or *"Investigate all severity 2 alerts."*
- **Deep investigation on agent-created issues.** A deep investigation is triggered automatically on issues the agent creates. To opt out for a resource, clear the **Investigation** checkbox on the **Operations** tab when you [create or edit the Observability Agent resource](observability-agent-resource-create-portal.md#configure-agent-operations-operations-tab). Automatic deep investigation is a billable feature as of July 1, 2026. For details, see [Billing implications for autonomous operations](#billing-implications-for-autonomous-operations).

The result is fewer, higher-signal items in your queue instead of a wall of separate alerts. Each one is a coherent incident story, whether it came from many correlated alerts or a single prominent one.

Two consistent markers identify an agent-created issue: the issue title is prefixed with `[<AppName>]`, and the **Background** section opens with `Observability Agent created this issue for <AppName> because`. Everything else in the title and background is generated from the alerts and telemetry the agent analyzed, so the wording varies by issue. In the issues list view, only the title is visible, so the `[<AppName>]` prefix is the distinguishing signal there. No separate column, badge, or filter exists for agent-created issues today.

## How autonomous correlation reasons over alerts

Autonomous correlation runs in the background, analyzing alerts as they fire and reasoning about how they relate. The reasoning combines:

- **Automatically discovered application and dependency topology.** When you point the agent to an Application Insights resource, it maps services, dependencies, and how they relate. The same topology that powers the agent's investigations also powers correlation.
- **Your own natural-language custom instructions.** See [Custom instructions: teach the agent how your system works](#custom-instructions-teach-the-agent-how-your-system-works).

## Custom instructions: teach the agent how your system works

Custom instructions are an optional input to autonomous correlation. Use them to add context that telemetry doesn't carry, that the agent can't infer from topology, or to specify the correlation and issue-creation patterns you want.

**What instructions are best for.** Use custom instructions to tell the agent:

- Which dependencies are upstream versus downstream.
- Business priorities, such as which workloads carry revenue or regulated traffic.

**Example.** If billing-service alerts and clinical-service alerts shouldn't be correlated because the systems are operationally distinct, tell the agent that. The agent applies that separation to future correlations.

**How instructions are applied.** The agent combines your instructions with discovered application and dependency topology at correlation time. See [How autonomous correlation reasons over alerts](#how-autonomous-correlation-reasons-over-alerts).

**Length limit.** Custom instructions are limited to 8,192 characters per Observability Agent resource.

For detailed examples, limits, and governance information, see [Custom instructions for the Azure Copilot Observability Agent](observability-agent-custom-instructions.md).

## How autonomous operations attach to your environment

Autonomous operations run against an **Observability Agent resource**, the Azure resource (`Microsoft.Monitor/observabilityAgents`) that you assign autonomous operations to. The resource carries a dedicated agent identity that you use to scope, govern, and assign autonomous operations. The resource uses a managed identity, either system-assigned or user-assigned. You choose one.

This article doesn't cover provisioning. To create an Observability Agent resource, see [Create an Azure Copilot Observability Agent resource in the Azure portal](observability-agent-resource-create-portal.md). For region availability, scope, and the identity model, see [Observability Agent resource](observability-agent-resource.md). For the access-control model, see [Data, privacy, and governance FAQ for Azure Copilot Observability Agent](observability-agent-governance-faq.md).

## Enable autonomous operations

You enable autonomous correlation and issue creation from the Observability Agent resource in the Azure portal. They run against the resource's configured target.

For the provisioning steps that come before enabling, see [Create an Azure Copilot Observability Agent resource in the Azure portal](observability-agent-resource-create-portal.md).

## What your team experiences differently

Autonomous operations change the day-to-day workflow of your on-call team:

- **Fewer items to triage.** Your team works through issues, not raw alerts, with clear "why these belong together" summaries.
- **Faster orientation.** The first few minutes of an incident go to acting, not to assembling what happened.
- **Better prioritization.** Some alerts might not seem urgent on their own, but when the Observability Agent correlates them with related signals, the combined issue can reflect higher overall severity. This helps your team focus first on incidents whose full impact is visible only when alerts are considered together.
- **Durable team expertise.** Custom instructions turn team expertise into a durable, evolving asset that the agent applies autonomously and consistently to every alert. New on-call members inherit that context automatically.

## How autonomous operations connect to deep investigations

When you turn on autonomous operations, deep investigation runs automatically on the issues the agent creates. The trigger covers both correlated issues and single-alert promotions. To opt out for a resource, clear the **Investigation** checkbox on the resource's **Operations** tab. For the full procedure, see [Configure Observability Agent operations (Operations tab)](observability-agent-resource-create-portal.md#configure-agent-operations-operations-tab).

The investigation starts from the full context, instead of from a single alert and a single resource: every related alert, every impacted resource, and every piece of reasoning the agent already produced. That approach gives you deeper investigations, sharper root-cause hypotheses, and recommendations that account for the full scope of impact from the first step.

:::image type="content" source="media/observability-agent-autonomous-operations/autonomously-run-issue-investigation.png" alt-text="Screenshot of autonomously created issue with investigation report and recommendations." lightbox="media/observability-agent-autonomous-operations/autonomously-run-issue-investigation.png":::

For more information about what a deep investigation does and what its report contains, see [Deep investigations in the Azure Copilot Observability Agent](observability-agent-deep-investigations.md).

## Controlled autonomy: where humans stay in control

Autonomous operations use autonomy for triage and investigation, while keeping humans in control of decisions, mitigations, and any change to your environment:

- **No automatic mitigations.** The agent doesn't make changes to your environment.
- **Issues, not actions.** Autonomous correlation produces issues. Humans review, dismiss, escalate, or hand them off to another team.
- **Reviewable reasoning.** Each autonomously created issue includes a natural-language explanation and the underlying alerts, so it's auditable.
- **Reversible.** You can edit or remove custom instructions at any time.

## Billing implications for autonomous operations

Automatic deep investigation on agent-created issues is a billable feature as of **July 1, 2026**. To opt out for a resource, clear the **Investigation** checkbox on the resource's **Operations** tab. For the full procedure, see [Configure Observability Agent operations (Operations tab)](observability-agent-resource-create-portal.md#configure-agent-operations-operations-tab).

For the full Observability Agent billing model and Azure Agent Credit (AAC) details, see [Billing and cost management for Observability Agent in Azure Monitor](observability-agent-billing.md).

## Data handling, privacy, and responsible use

Custom instructions are configuration data, stored as a property of the Observability Agent resource.

Autonomously created issues are part of the Azure Monitor workspace that hosts them and follow its shared context and Azure role-based access control (Azure RBAC) model.

For data retention, privacy, model handling, and governance controls, see [Data, privacy, and governance FAQ for Azure Copilot Observability Agent](observability-agent-governance-faq.md). For transparency and reliability expectations, see [Transparency FAQ for Azure Copilot Observability Agent](observability-agent-transparency.md).

## Preview limitations

The following limitations apply to autonomous operations during public preview:

- **In-scope capabilities.** Public preview covers alert correlation with automatic issue creation, single-alert promotion to issues, and automatic deep investigation on agent-created issues (opt-out). Other autonomous behaviors are on the roadmap.
- **Scope target.** The Azure portal scopes autonomous operations to a single Application Insights resource per Observability Agent resource. The API allows up to 10 Application Insights resources.
- **Provisioning surfaces.** In public preview, you can provision an Observability Agent resource through the Azure portal or Azure Resource Manager (ARM) and Bicep templates. Azure CLI and Terraform aren't supported.
- **Subscription cap.** You can have up to **5** Observability Agent resources per subscription during preview. This limit is fixed.
- **Region availability.** Autonomous operations are available in the following regions in public preview. For the agent-wide region list, see the **Regions** section in [Azure Copilot Observability Agent](observability-agent-overview.md#regions).

  :::row:::
     :::column:::
        - Australia East
        - Canada Central
        - Central US
     :::column-end:::
     :::column:::
        - East Asia
        - East US
        - South Central US
     :::column-end:::
     :::column:::
        - UK South
        - West Central US
        - West Europe
     :::column-end:::
  :::row-end:::

## Related content

- [Operational context and memory in Azure Copilot Observability Agent](observability-agent-context-memory.md)
- [Issues in Azure Monitor](issues-overview.md)
- [Deep investigations in the Azure Copilot Observability Agent](observability-agent-deep-investigations.md)
- [Azure Copilot Observability Agent](observability-agent-overview.md)
