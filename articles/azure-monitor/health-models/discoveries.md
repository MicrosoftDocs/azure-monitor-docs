---
title: Discover entities for Azure Monitor health models (preview)
description: Learn discovery concepts and configuration for Azure Monitor health models, including discovery kinds, recommended configuration, and parent entity assignment.
ms.topic: how-to
author: bwren
ms.author: bwren
ms.date: 05/14/2026
ai-usage: ai-assisted
---

# Discover entities for Azure Monitor health models (preview)
Discovery automatically adds entities to an [Azure Monitor health model](./overview.md) based on a rule. This article explains each discovery kind, how discovery recommendations work, and how to assign a parent entity for discovered entities.

## Discovery concepts
A discovery rule defines how entities are found and added to your model. Discovery helps you bootstrap large or dynamic topologies without manually adding every entity.

:::image type="content" source="media/discoveries/discovery-kinds.png" lightbox="media/discoveries/discovery-kinds.png" alt-text="Screenshot of the Discovery view with the Create menu showing Application Insights topology, Resource graph query, and Service group discovery kinds.":::

Each discovery rule includes these core settings:

| Setting | Description |
|:---|:---|
| Display name | Friendly name for the discovery rule. |
| Authentication setting | Identity used by discovery to enumerate resources. |
| Parent entity | Entity that discovered entities are attached to in the health model graph. |
| Discover relationships | When enabled, discovery attempts to create relationships between discovered entities when supported. |
| Add recommended signals | When enabled, discovery adds recommended signals to supported discovered entities. |
| Results preview | Preview list of resources discovery can currently find with the configured scope and conditions. |

## Discovery kinds
Use the discovery kind that matches your workload and source of truth.

| Discovery kind | Description | Best for |
|:---|:---|:---|
| Application Insights topology | Discovers entities from Application Insights topology and dependency information. | Application-centric workloads where components and dependencies are tracked in Application Insights. |
| Resource graph query | Discovers Azure resources that match Azure Resource Graph conditions. | Scope-based discovery by resource type, resource group, subscription, location, tags, and other properties. |
| Service group | Discovers entities from members of a service group scope. | Service group-based workload organization. |

## Recommended signals and alerts
When you enable **Add recommended signals**, discovery adds supported recommended signals to discovered entities.

Discovery does not automatically create alert configurations. After discovery adds entities and signals, configure alert behavior in the health model by following [Configure alerts in health models](./alerts.md).

## Specify a parent entity for discovered entities
Each discovery rule supports a **Parent entity** setting.

- If you select a parent entity, all discovered entities are attached under that parent.
- If you don't select a parent entity, a new parent entity is created for the discovery rule.

Choose a stable parent that represents the boundary of the discovery scope, such as a workload, environment, or resource group entity.

## Create and run a discovery rule
1. Open the health model, and then select **Discovery**.
1. Select **Create**, and then choose a discovery kind.
1. Enter a display name.
1. Select the authentication setting to use for discovery.
1. Optionally select a parent entity.
1. Configure kind-specific scope or conditions.
1. Set **Discover relationships** and **Add recommended signals** based on your needs.
1. Review **Results preview**, and then select **Create**.

:::image type="content" source="media/discoveries/create-resource-graph-discovery.png" lightbox="media/discoveries/create-resource-graph-discovery.png" alt-text="Screenshot of creating a Resource graph query discovery rule with authentication setting, parent entity selection, conditions, and options for discovering relationships and adding recommended signals.":::

## Verify discovered entities
After you create a rule, review discovered entities in the graph and entity views.

:::image type="content" source="media/discoveries/discovered-entities-graph.png" lightbox="media/discoveries/discovered-entities-graph.png" alt-text="Screenshot of health model graph showing entities discovered and added under a parent entity.":::

Use the discovered graph to validate that:

- Entities were added under the expected parent.
- Relationships match your intended topology.
- Recommended signals were assigned where supported.

## Next steps
- [Configure a health model using the designer](./designer.md)
- [Signals in Azure Monitor health models](./signals.md)
- [Configure alerts in health models](./alerts.md)
- [Analyze health state of the health model and its entities](./analyze-health.md)
