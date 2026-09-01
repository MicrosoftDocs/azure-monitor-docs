---
title: Chaos engineering and resilience
description: Understand the concepts of chaos engineering and fault injection that underpin Azure Chaos Studio.
services: chaos-studio
author: prasha-microsoft
ms.topic: concept-article
ms.date: 08/31/2026
ms.reviewer: prashabora
ai-usage: ai-assisted
---

# Chaos engineering and resilience

Chaos engineering is the practice of injecting controlled failures into a system to validate that it handles disruptions gracefully. Fault injection is the mechanism that makes this possible. It introduces errors like network latency, resource unavailability, or sudden load.

Azure Chaos Studio applies these principles as a managed service. [Chaos Studio Workspaces](chaos-studio-workspaces-overview.md) is the current resource model. A Workspace discovers your resources and recommends [Scenarios](chaos-studio-scenarios.md) that simulate relevant outage patterns. [Experiments (classic)](chaos-studio-chaos-experiments.md) is the legacy model for custom fault compositions that use targets and capabilities. To choose a model, see [Choose between Chaos Studio Workspaces and Experiments (classic)](chaos-studio-workspaces-vs-experiments.md).

## Why resilience testing matters

Distributed cloud applications depend on infrastructure, services, and networks that can fail independently. A disruption in one component can cascade into a system-wide incident if the application wasn't designed to tolerate it. Examples include a database failover, a DNS outage, or an availability zone going offline.

Resilience is a property of the whole system, not individual components. The only way to know whether your application survives a specific failure pattern is to test it under that condition. Chaos engineering provides a structured way to do this in preproduction and production environments.

## How Chaos Studio applies chaos engineering

Chaos Studio injects faults against Azure resources in a controlled, time-bounded manner. In Chaos Studio Workspaces, a Scenario defines the Actions, affected resource types, and sequence for an outage pattern. In Experiments (classic), an experiment defines which faults run against which targets and whether they run in parallel or sequentially.

Many continuous faults are time-bounded and remove their temporary changes when the experiment ends. For example, a fault removes the network security group rules it added or restarts the resources it stopped. For Experiments (classic), verify cleanup behavior in the [fault and action library](chaos-studio-fault-library.md).

## Next steps

- [What is Azure Chaos Studio?](chaos-studio-overview.md)
- [Chaos Studio Workspaces overview](chaos-studio-workspaces-overview.md)
- [Choose between Chaos Studio Workspaces and Experiments (classic)](chaos-studio-workspaces-vs-experiments.md)
- [Create a Workspace and run your first Scenario](quickstart-create-workspace.md)
- [Understand Experiments (classic)](chaos-studio-chaos-experiments.md)
