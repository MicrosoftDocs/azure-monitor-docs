---
title: Discover entities for Azure Monitor health models (preview)
description: Learn discovery concepts and configuration for Azure Monitor health models, including discovery kinds, recommended configuration, and parent entity assignment.
ms.topic: how-to
author: bwren
ms.author: bwren
ms.date: 05/18/2026
ai-usage: ai-assisted
---

# Discover entities for Azure Monitor health models (preview)
Discoveries automatically add Azure resource entities to your [Azure Monitor health model](./overview.md). They allow you to quickly create a new model without manually adding each resource and to keep your models up to date as your environment grows. This article explains each discovery kind, how discovery recommendations work, and how to assign a parent entity for discovered entities.

## Discovery kinds
There are three kinds of discoveries shown in the following table. You can use any combination of discoveries in a single health model depending on your requirements.

| Discovery kind | Description | Best for |
|:---|:---|:---|
| Application Insights topology | Discovers entities from Application Insights topology and dependency information. | Application-centric workloads where components and dependencies are tracked in Application Insights. |
| Resource graph query | Discovers Azure resources that match an Azure Resource Graph query. | Scope-based discovery by resource type, resource group, subscription, location, tags, and other properties. |
| Service group | Discovers entities from members of a service group scope. | Service group-based workload organization. |

## Discovery frequency
All discoveries run every 5 minutes. This value can't be modified.

## Discovery concepts
A discovery rule defines how entities are found and added to your model.

:::image type="content" source="media/discoveries/discovery-kinds.png" lightbox="media/discoveries/discovery-kinds.png" alt-text="Screenshot of the Discovery view with the Create menu showing Application Insights topology, Resource graph query, and Service group discovery kinds.":::

Each discovery rule includes these core settings:

| Setting | Description |
|:---|:---|
| Display name | Friendly name for the discovery rule. |
| Authentication setting | Identity used by discovery to enumerate resources. |
| Resource access authentication setting | Identity used to access source resources for discovery methods that require direct resource reads, such as Application Insights topology. |
| Parent entity | Any entities added by the discovery are attached as children of this entity. If you don't select a parent entity, a new generic entity is created for the discovery rule. |
| Discover relationships | When enabled, discovery attempts to create relationships between discovered entities when supported. |
| Add recommended signals | When enable, the [recommended signals]() for that resource type are added to any discovered entities. This allows you to have basic monitoring automatically started for any discovered entities. |
| Results preview | Preview list of resources discovery can currently find with the configured scope and conditions. |



### Application Insights topology settings
When you create an **Application Insights topology** discovery rule, configure:

- **Source: Application Insights** - Select the Application Insights resource that discovery reads topology from.
- **Authentication setting** - Select the identity used to enumerate and run discovery.
- **Resource access authentication setting** - Select the identity used to read source resource details required by topology discovery.
- **Parent entity** - Optionally select a parent. If not selected, a parent entity is created for the rule.
- **Discover relationships** and **Add recommended signals** - Enable these options to populate topology edges and baseline signals.

:::image type="content" source="media/discoveries/create-app-insights-discovery.png" lightbox="media/discoveries/create-app-insights-discovery.png" alt-text="Screenshot of creating an Application Insights topology discovery rule with source selection, authentication settings, parent entity selection, and configuration options.":::

### Resource graph query settings
When you create a **Resource graph query** discovery rule, configure:

- **Scope** - Select the subscription or subscriptions to evaluate in the query.
- **Query** - Enter an Azure Resource Graph query that returns the resources you want to discover.
- **Authentication setting** - Select the identity used to run the query and enumerate matching resources.
- **Parent entity** - Optionally select a parent. If not selected, a parent entity is created for the rule.
- **Discover relationships** and **Add recommended signals** - Enable these options to add supported relationships and baseline signals for matched resources.

Use **Results preview** to validate that the query returns the intended resources before you create the rule.

### Service group settings
When you create a **Service group** discovery rule, configure:

- **Source: Service group** - Select the service group that provides the discovery scope.
- **Authentication setting** - Select the identity used to enumerate service group members.
- **Parent entity** - Optionally select a parent. If not selected, a parent entity is created for the rule.
- **Discover relationships** and **Add recommended signals** - Enable these options to add relationships and supported baseline signals for discovered members.

If you start from a service group experience, you can create a health model from the service group monitoring page and then configure discovery in the model.

:::image type="content" source="media/create/create-from-service-group.png" lightbox="media/create/create-from-service-group.png" alt-text="Screenshot of the service group monitoring page with a link to create a health model for the service group.":::

## Multiple discoveries
A single health model can use multiple discoveries, including multiple rules of the same type. For example, you might use multiple Resource graph query discoveries to find resources by tag values and attach them to different parent entities. If the same resource is discovered by more than one rule, each rule creates a separate entity in the model that represent the same resource.


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


## Next steps
- [Configure a health model using the designer](./designer.md)
- [Signals in Azure Monitor health models](./signals.md)
- [Configure alerts in health models](./alerts.md)
- [Analyze health state of the health model and its entities](./analyze-health.md)
