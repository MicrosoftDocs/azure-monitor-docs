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



## Discovery kinds
There are three kinds of discoveries shown in the following table. You can use any combination of discoveries, including multiple discoveries of the same type, in a single health model depending on your requirements.

| Discovery kind | Description | Best for |
|:---|:---|:---|
| Application Insights topology | Discovers entities from Application Insights topology and dependency information. | Application-centric workloads where components and dependencies are tracked in Application Insights. |
| Resource graph query | Discovers Azure resources that match an Azure Resource Graph query. | Scope-based discovery by resource type, resource group, subscription, location, tags, and other properties. |
| Service group | Discovers entities from members of a service group scope. | Service group-based workload organization. |

## Discovery frequency
All discoveries run every 5 minutes. This value can't be modified.

## Discovery settings
A discovery rule defines how entities are found and added to your model. Each discovery rule includes these core settings:

| Setting | Description |
|:---|:---|
| Display name | Friendly name for the discovery rule. |
| Authentication setting | Identity used by discovery to enumerate resources. |
| Resource access authentication setting | Identity used to access source resources for discovery methods that require direct resource reads, such as Application Insights topology. |
| Parent entity | Any entities added by the discovery are attached as children of this entity. If you don't select a parent entity, a new generic entity is created for the discovery rule. |
| Discover relationships | When enabled, discovery attempts to create relationships between discovered entities when supported. |
| Add recommended signals | When enable, the [recommended signals](./signals.md#recommended-signals) for that resource type are added to any discovered entities. This allows you to have basic monitoring automatically started for any discovered entities. |




### Application Insights topology settings
When you create an **Application Insights topology**, you select an Application Insights resource in your subscription or a subscription you have access to. No other configuration is required other than the common settings. The components in the Application Insights topology are discovered as entities in the health model with relationships based on the dependencies in the topology.


### Resource graph query settings
When you create a **Resource graph query** discovery rule, you create a [KQL query](/azure/governance/resource-graph/samples/starter) that retrieves the resources you want. You can select between *Simple view* which prompts you for each property value and *Query view* which allows you work with the full query text.

Select **Refresh preview** to see the results of your query and verify that it returns the expected resources before you create the discovery rule.

:::image type="content" source="media/discoveries/create-resource-graph-discovery.png" lightbox="media/discoveries/create-resource-graph-discovery.png" alt-text="Screenshot of a resource group discovery rule.":::

### Service group settings
When you create a **Service group** discovery rule, you select a service group in your tenant. This will create a Resource graph query that retrieves the members of the service group as entities in the health model. You can simply accept this query or modify it as you would a Resource graph query discovery.

Select **Refresh preview** to see the results of your query and verify that it returns the expected resources before you create the discovery rule.

:::image type="content" source="media/discoveries/create-service-group-discovery.png" lightbox="media/discoveries/create-service-group-discovery.png" alt-text="Screenshot of a service group discovery rule.":::

## Multiple discoveries
A single health model can use multiple discoveries, including multiple rules of the same type. For example, you might use multiple Resource graph query discoveries to find resources by tag values and attach them to different parent entities. If the same resource is discovered by more than one rule, each rule creates a separate entity in the model that represent the same resource.



## Next steps
- [Configure a health model using the designer](./designer.md)
- [Signals in Azure Monitor health models](./signals.md)
- [Configure alerts in health models](./alerts.md)
- [Analyze health state of the health model and its entities](./analyze-health.md)
