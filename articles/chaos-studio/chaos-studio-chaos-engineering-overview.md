---
title: Chaos engineering and resilience
description: Understand the concepts of chaos engineering and fault injection that underpin Azure Chaos Studio.
services: chaos-studio
author: prasha-microsoft
ms.topic: concept-article
ms.date: 06/10/2026
ms.reviewer: prashabora
ai-usage: ai-assisted
---

# Chaos engineering and resilience

Chaos engineering is the practice of injecting controlled failures into a system to validate that it handles disruptions gracefully. Fault injection — introducing errors like network latency, resource unavailability, or sudden load — is the mechanism that makes this possible.

Azure Chaos Studio applies these principles as a managed service. You can run preconfigured [Scenarios](chaos-studio-scenarios.md) through a [Workspace](chaos-studio-workspaces-overview.md), or build custom [experiments](chaos-studio-chaos-experiments.md) with fine-grained control over faults, targets, and sequencing.

## Why resilience testing matters

Distributed cloud applications depend on infrastructure, services, and networks that can fail independently. A disruption in one component — a database failover, a DNS outage, an availability zone going offline — can cascade into a system-wide incident if the application wasn't designed to tolerate it.

Resilience is a property of the whole system, not individual components. The only way to know whether your application survives a specific failure pattern is to test it under that condition. Chaos engineering provides a structured way to do this in preproduction and production environments.

## How Chaos Studio applies chaos engineering

Chaos Studio injects faults against Azure resources in a controlled, time-bounded manner. An experiment defines which faults to run, against which resources, in what order. Faults can run in parallel or sequentially. Many continuous faults are time-bounded and remove their temporary changes when the experiment ends — for example, removing NSG rules or restarting stopped resources. Verify the cleanup behavior for each fault you use by checking the [Fault and action library](chaos-studio-fault-library.md).

For a deeper look at experiment structure, see [Chaos experiments in Azure Chaos Studio](chaos-studio-chaos-experiments.md). For the list of available faults, see the [Fault and action library](chaos-studio-fault-library.md).

## Next steps

- [What is Azure Chaos Studio?](chaos-studio-overview.md)
- [Create a Workspace and run your first Scenario](quickstart-create-workspace.md)
- [Faults and actions in Azure Chaos Studio](chaos-studio-faults-actions.md)
