---
title: Choose between Chaos Studio Workspaces and Experiments (classic)
description: Compare Chaos Studio Workspaces and Experiments (classic), choose the resource model that fits your resilience test, and evaluate an adoption path.
author: nikhilkaul-msft
ms.topic: concept-article
ms.date: 08/31/2026
ai-usage: ai-assisted
---

# Choose between Chaos Studio Workspaces and Experiments (classic)

Azure Chaos Studio offers two resource models for resilience testing. [Chaos Studio Workspaces](chaos-studio-workspaces-overview.md) is the current model. It discovers resources within a scope and runs Scenarios against them. [Experiments (classic)](chaos-studio-chaos-experiments.md) is the legacy model. It runs experiments against targets that you enable individually. Use this comparison to choose a model for each resilience test and to evaluate where Workspaces fit your existing testing strategy. The Experiments (classic) model is generally available, and Chaos Studio Workspaces is in public preview.

[!INCLUDE [chaos-studio-workspaces-preview](includes/chaos-studio-workspaces-preview.md)]

## How the two models differ

Both models inject real faults against your Azure resources, but they differ in how you get from "I want to test this failure" to a running test.

| Aspect | Chaos Studio Workspaces (preview) | Experiments (classic) |
|---|---|---|
| Servicing state | Active development. New Chaos Studio features ship in the Workspaces model. | Legacy model. There's no further feature development, and only critical fixes, such as security updates, are considered for backport. |
| Onboarding | Set a scope (subscription, resource group, or service group). The Workspace discovers supported resources automatically. | Enable a target and capabilities on each resource before it can be used in an experiment. |
| Test definition | Start from a Scenario template that already composes the Actions and sequencing for an outage pattern, or customize one in the Scenario designer. | Assemble faults, steps, and branches manually, and select target resources for each fault. |
| Finding what to test | The Scenario library shows which Scenarios apply to the resources discovered in your scope. | Choose faults from the [fault library for Experiments (classic)](chaos-studio-fault-library.md) and check resource requirements. |
| Identity and permissions | Configure managed identity at the Workspace level: system-assigned, user-assigned, or both, with role assignments shared by its Scenarios. The portal offers to fix missing role assignments. | Use a managed identity and role assignments for each experiment. |
| Permission validation | The Workspace validates the permissions required for a run before it starts. | Missing permissions typically surface as failures at run time. |
| Regions | A Workspace is a logical resource that can act on resources in any Azure region from any of the [supported Workspace regions](chaos-studio-region-availability.md#regional-availability-of-chaos-studio-workspaces). | Experiments deploy to [specific regions](chaos-studio-region-availability.md#regional-availability-of-experiments-classic), and targets must be in a resource-targeting region. |
| Reporting | Each run produces a downloadable [Scenario report](chaos-studio-scenario-reports.md) with run details, an Action summary, a timeline, and an execution flow diagram. | Experiment history shows execution details and error information per run. |
| Supported tests | Use the curated [Scenario catalog](chaos-studio-scenarios.md) or customize a Scenario in the designer or as a `Microsoft.Chaos/workspaces/scenarios` resource. | Use the classic fault catalog, including agent-based faults, AKS Chaos Mesh faults, and dynamic targeting. |

## Main advantages of Chaos Studio Workspaces

**Faster onboarding.** A Workspace removes the largest source of setup friction in Experiments (classic): per-resource target and capability enablement. You set a scope once, and discovery finds the supported resources in it. If you add or remove resources later, the Workspace picks up the changes automatically.

**Built-in recommendations.** The Scenario library is populated from the resources discovered in your scope, so you start from outage patterns that apply to your environment instead of assembling faults manually. Scenarios such as Compute Zone Down compose related disruptions for you.

**Use any region.** Workspaces are logical resources: the Workspace region doesn't need to match your target resources, and one Workspace can act on resources in any Azure region. In Experiments (classic), targets and capabilities must be co-located with your resources, and experiments can only be created in certain regions.

**Simpler, safer permissions.** The Workspace's managed identity is a single blast-radius control shared by every Scenario, with a two-layer authorization model: the person triggering the run needs permission on the Workspace, and the Workspace identity needs roles on the target resources. When validation finds missing permissions, the portal offers to fix the role assignments for you. In Experiments (classic), you manage an identity and role assignments for each experiment.

**Validation before disruption.** A Workspace validates that the identity has the permissions a run requires before the run starts, so permission gaps surface before Actions run.

**Evidence you can share.** Every run generates a structured Scenario report with run details, Action statuses and durations, affected resources, a timeline, and an execution flow. You can download the report for compliance reviews, post-incident retrospectives, or resilience maturity assessments.

## When to choose Chaos Studio Workspaces

Choose Workspaces when:

- You're new to Chaos Studio and want the fastest path from nothing to a meaningful resilience test.
- The outage pattern you need is covered by the [Scenario catalog](chaos-studio-scenarios.md) or is close enough to customize in the designer.
- You need to test resources across multiple regions or subscriptions from one place.
- You need structured, shareable evidence of testing for compliance or operational-resilience frameworks.
- Multiple teams or applications need separate testing boundaries. You can create a Workspace for each application, environment, team, or compliance boundary.

## When to choose Experiments (classic)

Choose Experiments (classic) when:

- You need a fault that the scenario catalog doesn't yet cover, such as specific agent-based faults or [AKS Chaos Mesh faults](chaos-studio-tutorial-aks-portal.md) for in-cluster fault injection.
- You rely on classic-only capabilities such as [dynamic targeting](chaos-studio-tutorial-dynamic-target-portal.md) or [scheduled experiment runs](tutorial-schedule.md).
- You require a generally available resource model. Chaos Studio Workspaces is in public preview and isn't recommended for production workloads.

If you choose Experiments (classic), keep its servicing state in mind: it's a legacy model with no further feature development, and only critical fixes, such as security updates, are considered for backport.

## Evaluate a move from Experiments (classic)

Treat adoption as a model-selection decision for each resilience test. Don't assume that a Scenario and an existing experiment have equivalent coverage.

1. Check the [Scenario catalog](chaos-studio-scenarios.md) for the outage pattern and resources you need to test.
1. Review [Workspaces limitations](chaos-studio-workspaces-limitations.md) for any required fault or capability that isn't available.
1. Review the [Workspaces permission model](chaos-studio-workspace-permissions.md) and the roles required by the Scenario.
1. Use the [Workspaces quickstart](quickstart-create-workspace.md) to validate the selected Scenario and its report in a safe environment.
1. Choose Experiments (classic) for a testing requirement that depends on a classic-only fault or capability.

This decision path evaluates model fit. It doesn't define a resource-conversion procedure.

## Use both models

Your model choice can differ by resilience test. Use Chaos Studio Workspaces where the Scenario catalog covers the outage pattern, and use Experiments (classic) where you need a classic-only fault composition or capability.

## Next steps

- [Chaos Studio Workspaces overview](chaos-studio-workspaces-overview.md).
- [Create a Workspace and run your first Scenario](quickstart-create-workspace.md).
- [Configure permissions and identity for Chaos Studio Workspaces](chaos-studio-workspace-permissions.md).
- [Review the Scenarios available in Chaos Studio Workspaces](chaos-studio-scenarios.md).
- [Understand Experiments (classic)](chaos-studio-chaos-experiments.md).
