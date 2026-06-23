---
title: Custom instructions for the Azure Copilot Observability Agent (preview)
description: Learn how to write custom instructions that guide autonomous alert correlation and issue creation in the Azure Copilot Observability Agent.
ms.topic: concept-article
ms.collection: ce-skilling-ai-copilot
ms.reviewer: efratbp
ms.date: 06/15/2026
ai-usage: ai-assisted
# Customer intent: As an Azure Monitor user responsible for an on-call rotation or AIOps strategy, I want practical example instructions so that I can shape how the Observability Agent correlates alerts and creates issues, and apply the right instruction for my situation.
---

# Custom instructions for the Azure Copilot Observability Agent (preview)

Custom instructions let you shape how the Azure Copilot Observability Agent correlates alerts and creates Azure Monitor issues during autonomous operations. Write them in plain language, and the agent applies them alongside the topology it discovers automatically.

This article provides example instructions that shape correlation and issue-creation behavior, and describes when to use each one. For information about custom instructions and where they fit in autonomous operations, see [Autonomous operations in the Azure Copilot Observability Agent](observability-agent-autonomous-operations.md).

> [!IMPORTANT]
> Autonomous operations in the Azure Copilot Observability Agent, including custom instructions, are currently in PREVIEW. See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability.

## How the agent applies custom instructions

Custom instructions affect how the agent correlates alerts and creates Azure Monitor issues during autonomous operations. They don't change how the agent runs deep investigations on the issues it creates. The agent applies them alongside the topology it discovers from the monitored Application Insights resource. Instructions refine that reasoning; they don't grant permissions, bypass Azure role-based access control (Azure RBAC), or let the agent change resources in your environment.

Write instructions as plain natural-language text. You can include several instructions in the custom instructions field on the Observability Agent resource. Write each one as its own short, clear sentence. The field doesn't support Markdown or file uploads yet.

You enter custom instructions on the **Operations** tab when you [create the resource in the Azure portal](observability-agent-resource-create-portal.md#configure-agent-operations-operations-tab), or by setting the `instructions` property in an [ARM or Bicep template](observability-agent-resource-create-template.md).

## Write effective instructions

Custom instructions work best when each one is a clear directive about the behavior you want, scoped to the alerts or resources it applies to. Keep these guidelines in mind:

- **Lead with the behavior.** Start with what you want the agent to do, for example, *correlate*, *don't correlate*, or *create an issue*.
- **Name what the rule applies to.** Reference the specific alert rules, resources, or severities the instruction targets so the agent applies it precisely.
- **Keep each instruction focused.** Prefer several short, specific instructions over one long paragraph that mixes unrelated intents.
- **Edit as you go.** Instructions are reversible. Adjust or remove them as your priorities change. Changes take effect for future correlations only.

### Reference your services and alert attributes

When an instruction names a service, use its **cloud role name** (the name that appears in Application Map) or any **dimension** that appears on your alert rules.

You can also reference the standard alert attributes that the agent reads from each alert, including:

- Severity
- Alert rule name
- Monitor service
- Signal type
- Description
- Target resource, resource type, and resource group

## What not to include

Don't include secrets, credentials, access tokens, connection strings, personal data, customer data, or temporary incident notes in custom instructions. The Observability Agent resource stores custom instructions as configuration, and anyone with permission to read or manage the resource can read them.

Use instructions for stable operational guidance, such as critical workloads, alert-handling rules, and correlation boundaries.

## Examples that shape how alerts are correlated

Use these instructions to adjust how the agent groups related alerts into a single issue.

### Keep distinct systems apart

Use this instruction when two systems share infrastructure or fire alerts at similar times but should never land in the same issue.

*Don't correlate billing-service alerts with clinical-service alerts. These systems are operationally distinct.*

### Keep environments separate

Use this instruction when resource groups or a naming convention separate your environments but the environments share alert rules and require separate investigation.

*Don't correlate alerts in the `prod-rg` resource group with alerts in the `staging-rg`, `test-rg`, or `dev-rg` resource groups.*

### Enforce a time window on correlation

Use this instruction when the agent should group alerts only when they fire close together in time.

*Only correlate alerts that fire within five minutes of each other.*

### Adjust the grouping signal

Use this instruction to nudge how the agent decides that alerts belong together.

*Correlate alerts that share the same target resource group.*

### Combine directives for related microservices

Combine several directives in a single set of instructions to express a richer correlation and issue-creation policy for several related microservices.

*Correlate alerts for the `checkout-api` and `payment-worker` cloud roles when they fire within five minutes of each other. Don't correlate them with alerts from the `search-service` role. Always create an issue for severity 1 or severity 2 alerts on `payment-worker`.*

## Examples that shape when an issue is created

The agent creates an issue in one of two ways: by correlating a group of related alerts, or by promoting a single prominent alert into its own issue. Use these instructions to tell the agent which individual alerts should always become their own issue.

### Always create an issue for a specific alert

Not every incident announces itself with a chorus of alerts. Use this instruction when one specific high-impact alert should always become its own well-explained issue, even if nothing else is firing.

*Always create an issue for `fintrack-servicebus-active-messages-backlog`.*

### Always create an issue for business-critical workloads

Use this instruction when a workload is important enough that any alert affecting it should always become an issue.

*The checkout and payment paths carry revenue traffic. Always create an issue for alerts that affect these paths.*

### Create an issue based on severity

Use this instruction when severity is your signal for "this always deserves its own issue."

*Always create an issue for every severity 2 alert.*

## Examples that shape the issue title

Use these instructions when you want every agent-created issue title to carry a consistent owner tag or review marker.

### Add an owner tag to every issue title

Use this instruction when you want every issue title to identify the team that owns it.

*End every issue title with ` — owner: SRE-team`.*

### Add a review marker to every issue title

Use this instruction when you want a visible marker on every issue title to flag it for triage or review.

*Include the marker `[OPS-REVIEW]` in every issue title.*

> [!NOTE]
> The agent always generates the issue background from the alerts and telemetry it analyzed. You can't set the issue background or the issue severity through custom instructions.

## Limits and governance

| Item | Detail |
|---|---|
| Length limit | Each Observability Agent resource accepts up to **8,192 characters** of custom instructions. |
| Storage | The Observability Agent resource stores instructions as one of its properties. Any edit updates the resource, and you can query it like any other Azure resource, for example, through Azure Resource Graph. |
| Edit permission | Editing custom instructions requires **Monitoring Contributor** on the target resource group, the same permission you need to create or update the Observability Agent resource itself. |
| Permission boundary | Custom instructions don't grant new permissions, bypass Azure RBAC, or expand the Observability Agent resource scope. |
| Action boundary | Custom instructions don't let the agent restart resources, change configuration, or remediate issues automatically. The agent creates issues and investigations for your team to review. |
| Applicability | Custom instructions apply to future autonomous correlations. They don't rewrite existing issues or previous investigation results. |

For the access-control model and data-handling specifics, see [Data, privacy, and governance FAQ for Azure Copilot Observability Agent](observability-agent-governance-faq.md) and [Transparency FAQ for Azure Copilot Observability Agent](observability-agent-transparency.md).

## Related content

- [Autonomous operations in the Azure Copilot Observability Agent](observability-agent-autonomous-operations.md)
- [Azure Copilot Observability Agent resource](observability-agent-resource.md)
- [Create an Azure Copilot Observability Agent resource in the Azure portal](observability-agent-resource-create-portal.md)
- [Create Observability Agents by using templates](observability-agent-resource-create-template.md)
- [Data, privacy, and governance FAQ for Azure Copilot Observability Agent](observability-agent-governance-faq.md)
