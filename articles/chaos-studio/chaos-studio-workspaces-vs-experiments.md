---
title: Compare workspaces and experiments in Azure Chaos Studio
description: Understand the differences between Chaos Studio workspaces and the classic experiment model, the main advantages of workspaces, and when to choose each model.
author: nikhilkaul-msft
ms.topic: concept-article
ms.date: 07/17/2026
ai-usage: ai-assisted
---

# Compare workspaces and experiments in Azure Chaos Studio

Azure Chaos Studio offers two models for running resilience tests: [workspaces](chaos-studio-workspaces-overview.md), which run scenarios against automatically discovered resources, and the classic model, which runs [experiments](chaos-studio-chaos-experiments.md) against targets you enable individually. This article compares the two models, explains the main advantages of workspaces, and helps you decide which model fits your situation. The classic experiment model is generally available; workspaces are in public preview.

[!INCLUDE [chaos-studio-workspaces-preview](includes/chaos-studio-workspaces-preview.md)]

## How the two models differ

Both models inject real faults against your Azure resources, but they differ in how you get from "I want to test this failure" to a running test.

| Aspect | Workspaces (preview) | Experiments (classic) |
|---|---|---|
| Onboarding | Set a scope (subscription, resource group, or service group). The workspace discovers supported resources automatically. | Enable a target and capabilities on each resource before it can be used in an experiment. |
| Test definition | Start from a scenario template that already composes the right actions and sequencing for an outage pattern, or customize one in the scenario designer. | Assemble faults, steps, and branches manually, and select target resources for each fault. |
| Finding what to test | The scenario library shows which scenarios apply to the resources discovered in your scope. | You choose faults from the fault library and check resource requirements yourself. |
| Identity and permissions | One managed identity per workspace, with roles assigned once and shared by all scenarios. Chaos Studio can assign the required roles automatically. | Each experiment has its own managed identity and role assignments. |
| Permission validation | The workspace validates the permissions required for a run before it starts. | Missing permissions typically surface as failures at run time. |
| Regions | A workspace is a logical resource that can act on resources in any Azure region, in any of the [supported workspace regions](chaos-studio-region-availability.md#regional-availability-of-chaos-studio-workspaces). | Experiments deploy to [specific regions](chaos-studio-region-availability.md), and targets must be in a resource-targeting region. |
| Reporting | Each run produces a downloadable [scenario report](chaos-studio-scenario-reports.md) with run details, an action summary, a timeline, and an execution flow diagram. | Experiment history shows execution details and error information per run. |
| Fault coverage | A curated set of [scenario templates](chaos-studio-scenarios.md) plus custom scenarios authored in the designer or as `Microsoft.Chaos/workspaces/scenarios` resources. | The full [fault library](chaos-studio-fault-library.md), including agent-based faults, AKS Chaos Mesh faults, and dynamic targeting. |

## Main advantages of workspaces

**Faster onboarding.** A workspace removes the largest source of setup friction in the classic model: per-resource target and capability enablement. You set a scope once, and discovery finds the supported resources in it. If you add or remove resources later, the workspace picks up the changes automatically.

**Built-in recommendations.** The scenario library is populated from the resources discovered in your scope, so you start from outage patterns that actually apply to your environment instead of assembling faults and hoping the composition is realistic. Real incidents rarely affect one resource at a time; scenarios such as Compute Zone Down compose the simultaneous disruptions for you.

**Use any region.** Workspaces are logical resources: the workspace region doesn't need to match your target resources, and one workspace can act on resources in any Azure region. In the classic model, targets and capabilities must be co-located with your resources, and experiments can only be created in certain regions.

**Simpler, safer permissions.** The workspace's managed identity is a single blast-radius control shared by every scenario, with a two-layer authorization model: the person triggering the run needs permission on the workspace, and the workspace identity needs roles on the target resources. Chaos Studio can assign the required roles automatically during setup. In the classic model, you manage an identity and role assignments per experiment.

**Validation before disruption.** A workspace validates that the identity has the permissions a run requires before the run starts, so permission gaps surface up front instead of as failed actions mid-test.

**Evidence you can hand to auditors.** Every run generates a structured scenario report - run details, per-action statuses and durations, resources affected, timeline, and execution flow - that you can download and use for compliance reviews, post-incident retrospectives, or resilience maturity assessments.

**Better performance.** The workspaces platform reduces the latency between starting a run and the faults taking effect compared to the classic experiment infrastructure, so runs start faster and results are easier to correlate with your monitoring.

## When to choose workspaces

Choose workspaces when:

- You're new to Chaos Studio and want the fastest path from nothing to a meaningful resilience test.
- The outage pattern you need is covered by the [scenario catalog](chaos-studio-scenarios.md) (zone failures, DNS and identity outages, database failovers, cache stampedes, messaging disruption) or is close enough to customize in the designer.
- You need to test resources across multiple regions or subscriptions from one place.
- You need structured, shareable evidence of testing for compliance or operational-resilience frameworks.
- Multiple teams or applications need separate testing boundaries. You can create a workspace per application, environment, team, or compliance boundary.

## When to choose the classic model

Choose experiments when:

- You need a fault that the scenario catalog doesn't yet cover, such as specific agent-based faults or [AKS Chaos Mesh faults](chaos-studio-tutorial-aks-portal.md) for in-cluster fault injection.
- You rely on classic-only capabilities such as [dynamic targeting](chaos-studio-tutorial-dynamic-target-portal.md) or [scheduled experiment runs](tutorial-schedule.md).
- You require a generally available service. Workspaces are in public preview and aren't recommended for production workloads yet.

## Using both models together

Workspaces and experiments are separate models, and they coexist. Existing experiments continue to work exactly as before, with their own identities and permissions. Adopting workspaces doesn't affect them. A practical approach is to use workspaces for the common outage patterns the scenario catalog covers, and keep experiments for custom fault compositions the catalog doesn't cover yet.

## Next steps

- [What are workspaces in Azure Chaos Studio?](chaos-studio-workspaces-overview.md)
- [Quickstart: Create a workspace and run your first scenario](quickstart-create-workspace.md)
- [Scenarios in Azure Chaos Studio](chaos-studio-scenarios.md)
