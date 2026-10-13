---
title: Chaos engineering and resilience in Azure
description: Learn how chaos engineering in Azure tests resilience through controlled failures, and use Chaos Studio Workspaces to run Scenarios and review results.
services: chaos-studio
author: prasha-microsoft
ms.topic: concept-article
ms.date: 09/05/2026
ms.reviewer: prashabora
ai-usage: ai-assisted
---

# Chaos engineering and resilience in Azure

Chaos engineering in Azure tests how your applications handle controlled failures before an outage exposes a resilience gap. Azure Chaos Studio applies fault injection to simulate disruptions such as resource unavailability or sudden load. Start with [Chaos Studio Workspaces](chaos-studio-workspaces-overview.md) to discover resources and run Scenarios in a preproduction environment.

Azure Chaos Studio applies these principles as a managed service. [Chaos Studio Workspaces](chaos-studio-workspaces-overview.md) is the current resource model. A Workspace discovers your resources and recommends [Scenarios](chaos-studio-scenarios.md) that simulate relevant outage patterns. [Experiments (classic)](chaos-studio-chaos-experiments.md) is the legacy model for custom fault compositions that use targets and capabilities. To choose a model, see [Choose between Chaos Studio Workspaces and Experiments (classic)](chaos-studio-workspaces-vs-experiments.md).

## Why resilience testing matters

Distributed cloud applications depend on infrastructure, services, and networks that can fail independently. A disruption in one component can cascade into a system-wide incident if the application wasn't designed to tolerate it. Examples include a database failover, a DNS outage, or an availability zone going offline.

Resilience is a property of the whole system, not individual components. The only way to know whether your application survives a specific failure pattern is to test it under that condition. Chaos engineering provides a structured way to do this in preproduction and production environments.

## How Chaos Studio applies chaos engineering

Chaos Studio injects faults against Azure resources in a controlled, time-bounded manner. In Chaos Studio Workspaces, a Scenario defines the Actions, affected resource types, and sequence for an outage pattern. In Experiments (classic), an experiment defines which faults run against which targets and whether they run in parallel or sequentially.

Many continuous faults are time-bounded and remove their temporary changes when the experiment ends. For example, a fault removes the network security group rules it added or restarts the resources it stopped. For Experiments (classic), verify cleanup behavior in the [fault and action library](chaos-studio-fault-library.md).

## Next steps

- [Azure Chaos Studio Workspaces overview](chaos-studio-workspaces-overview.md).
- [Azure Chaos Studio Workspaces quickstart](quickstart-create-workspace.md).
- [Azure Chaos Studio Scenarios and outage templates](chaos-studio-scenarios.md).
- [Workspaces permissions and identity](chaos-studio-workspace-permissions.md).
- [Azure Chaos Studio Scenario reports](chaos-studio-scenario-reports.md).
- [Compare Workspaces and Experiments (classic)](chaos-studio-workspaces-vs-experiments.md).
- [Azure Chaos Studio product overview](chaos-studio-overview.md).
