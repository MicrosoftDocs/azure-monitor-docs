---
title: Azure Monitor health model concepts
description: Description of the core concepts required for building and using health models in Azure Monitor.
ms.topic: concept-article
author: bwren
ms.author: bwren
ms.date: 05/15/2026
ai-usage: ai-assisted
---

# Azure Monitor health model concepts (preview)
This article describes the concepts that you must understand to create and use [Azure Monitor health models](./overview.md). This includes the components that make up a model, how those components are related, and how the health of each component is determined. See [Using the Designer in Azure Monitor](./designer.md) for details on creating and configuring these components.


## Entities
Entities are the building blocks of an [Azure Monitor health model](./overview.md). They represent the different components of your workload and any supporting business processes. You can add entities manually, or you can use discovery to add them automatically based on supported discovery methods. 

There are three distinct types of entities as described in the following sections.

:::image type="content" source="media/concepts/entities.png" lightbox="media/concepts/entities.png" alt-text="Screenshot showing entity types.":::

### Root entity
All health models have a single entity called the *root entity* that represents the model itself. While not required, all other entities in the health model typically connect to the root either directly or through other relationships. The root entity can't be deleted.

The primary use of the root entity is to represent the overall health of the workload or application represented by the health model. You can track health of the application over time and create alerts based on the health of the root entity either in addition or instead of the individual entities in the model.


### Azure resource entity
An *Azure resource entity* represents an Azure resource from the current subscription or from another subscription that you can access. You can either add the resource or configure discovery to add matching resources automatically. 

The health model includes a representation of the Azure resource and not the resource itself. A resource can be represented in multiple health models, and each can define different monitoring requirements and business logic. If the resource is represented by multiple entities in different models, then the signals for each entity are evaluated separately, and each has its own independent health state.

The signals applied to each Azure resource entity are evaluated from the metrics or logs that are associated with the resource. The collection of this data is defined for the resource itself and not in the health model. The health model instead focuses on how to interpret that data in the context of the role of the resource in the workload.

### Generic entity
A *generic entity* represents some part of the application or workload that isn't an Azure resource. It may represent some manual process in the workflow, or you may use it to represent some aggregation of other entities such as a region or a business unit. A generic entity can have its own signals, although it may just have a health state determined by the health of its child entities. You create most generic entities manually, although a generic entity may also be automatically created to support health rollup for entities that are automatically added through discovery.


## Relationship
A relationship represents the dependency of one entity on another, or it may represent the aggregation of multiple entities into a single entity. An entity can have multiple child entities and multiple parent entities. The primary function of relationships is to support health propagation as described in [Health states](#health-states).

In most health models, all entities will connect directly or indirectly to the root entity. This allows you to roll up the health of all entities in the model to the root entity. This is useful for tracking the overall health of your workload and for alerting on the health of the entire workload.


## Signals
The [health state](#health-states) of an entity in an Azure Monitor health model is determined by one or more *signals*. A signal is a value from a metric or query that's periodically compared to threshold values for each health state. One or more signals determine the health state of an entity.

Azure Monitor health models support the following discovery types.

| Discovery type | High-level description |
|:---|:---|
| Application Insights topology | Discovers application components and their dependencies from Application Insights topology to quickly map your workload relationships. |
| Resource graph query | Discovers Azure resources that match a Resource Graph query so you can onboard resources at scale with query-based selection. |
| Service group | Discovers entities from a service group definition to align model entities with your service structure and ownership boundaries. |

For detailed discovery configuration and behavior, see [Discoveries in Azure Monitor health models](./discoveries.md).

For signal types, signal definitions, thresholds, and configuration details, see [Signals in Azure Monitor health models](./signals.md). 

## Health states
The *health state* of an entity represents its ability to perform its required tasks. It may be fully functional and performing within an expected range, or it may have limited functionality or degraded performance, or it may not be functional at all. Health state is determined by the [signals](#signals) that are associated with an entity, and it may be affected by the health states of any child entities. You can view the most current health state of your workflow and its components in addition to tracking the health of the model over time.

Azure Monitor health models use the health states in the following table to represent the health of each entity in the model. There's no objective definition of the thresholds that determine each of these health states, but you'll specify each according to the requirements of your particular workload and business. 

| Icon | State | Description |
|:---|:---|:---|
| :::image type="content" source="media/concepts/healthy.png" alt-text="Healthy icon." border="false"::: | Healthy | The entity is working as expected. |
| :::image type="content" source="media/concepts/degraded.png" alt-text="Degraded icon." border="false"::: | Degraded | The entity is working but with diminished functionality or performance.<br>Does not count as downtime for [health objective](#health-objective). |
| :::image type="content" source="media/concepts/unhealthy.png" alt-text="Unhealthy icon." border="false"::: | Unhealthy | The entity is not working or is working with unacceptable performance.<br>Counts as downtime for [health objective](#health-objective). |
| :::image type="content" source="media/concepts/unknown.png" alt-text="Unknown icon." border="false"::: | Unknown | The health state of the entity can't be determined due to insufficient data or a lack of signals. |

The following example illustrates an Azure resource entity with multiple metric signals. Each has a defined range for degraded and unhealthy states. When the value of each signal is outside of the degraded threshold, the health state of the entity is healthy to match all of its signals. When the value of a signal is within the degraded or unhealthy threshold, then that signal is set to the corresponding health state, and the entity is set to the **worst state** of all its signals. 

In the following example, the entity is set to a degraded state since one of its signals is in a degraded state and the other two are healthy. If any of the signals were unhealthy, then the entity would be set to an unhealthy state.

:::image type="content" source="media/concepts/health-signals.png" lightbox="media/concepts/health-signals.png" alt-text="Screenshot of an example entity showing the health state from different signals." border="false":::

### Health propagation

In addition to its own signals, the health state of an entity is affected by its child entities. This typically represents the dependency of one entity in your health model on another entity. While the signal for the parent may be healthy, you can assume that it isn't fully operational since another entity that it depends on isn't working properly.

You may also use health rollup to consolidate the health of multiple entities. For example, you may want to track the health of a particular component of your application, or the resources in a particular region or business unit. In this case, you can add a [generic entity](#generic-entity) to your model that rolls up the health of the child entities you want to aggregate.

The following example illustrates health propagation in a sample health model. Signals are shown for an event hub entity and a generic entity representing an application component that processes incoming messages. Even though the signal for the message processor is healthy, its entity health state is unhealthy due to the unhealthy state of the event hub that it depends on. This unhealthy state is propagated to the root entity because it's the worst state of the entities connected to the root.

:::image type="content" source="media/concepts/health-signals-rollup.png" lightbox="media/concepts/health-signals-rollup.png" alt-text="Screenshot of an example entity showing the health state from a child entity." border="false":::

### Impact
The *impact* setting of an entity determines how its health state is propagated to its parent(s). The following table describes the different impact settings. Select the setting for each entity in the [entity editor](#entities).

| Option | Description |
|:-------|:------------|
| Standard | Propagates the entity state up to the parent. This is the default setting and the most common. |
| Limited  | Doesn't propagate a degraded state and propagates an unhealthy state as degraded. The parent will never receive an unhealthy state from this entity. For example, you may have an application that depends on a cache. If the cache is unhealthy, then the application will keep performing but with degraded performance. |
| Suppressed | Doesn't propagate any health state. Even if the entity is degraded or unhealthy, the parent will appear as healthy. For example, your application may have a backup operation represented by an entity in the health model. Even though the backup operation is unhealthy, the application continues operating normally. |

The following sample shows the effect of each impact setting. Each of the child entities is in an unhealthy state, but the parent health states are different based on the impact setting of each child.

:::image type="content" source="media/concepts/health-impact.png" lightbox="media/concepts/health-impact.png" alt-text="Screenshot of an example health model showing different impact settings." border="false":::

### Dependencies
The *dependencies* setting of an entity determines how its health state is propagated from its child(ren). The following table describes the different dependency settings. Select the setting for each entity in the [entity editor](#entities).

| Option | Description |
|:-------|:------------|
| Worst of | Propagates the worst health state among all dependencies. This is the default setting and the most common. |
| Minimum health  | Entity becomes degraded or unhealthy when the number of healthy children entities falls to or below a specific threshold. Specify a separate threshold for each health state. The threshold can either be an absolute value or a percentage. |
| Maximum not healthy | Entity becomes degraded or unhealthy when the number of non-healthy children entities reaches or exceeds a specific threshold. Specify a separate threshold for each health state. The threshold can either be an absolute value or a percentage. |

### Health objective
The health objective for an entity is the target percentage of time this entity should be healthy. This allows you to track the achievement of your availability goals over time. Health objective is an optional value. Instead of setting one for each entity in the health model, you may choose to only set a health objective for the root entity which represents a health objective for the entire workload. Select the setting for each entity in the [entity editor](#entities).

Following is a history from [Entity details](./analyze-health.md#entity-details) for a sample entity showing health objective reporting.

:::image type="content" source="media/concepts/health-objective.png" lightbox="media/concepts/health-objective.png" alt-text="Screenshot of an example health objective reporting.":::



## Alerts
Alerts notify you when the health state of an entity changes.

For alert strategy and configuration details, see [Alerts in Azure Monitor health models](./alerts.md).



## Next steps
- [Create a new health model](./create.md).
- [Configure a health model using the designer](./designer.md).
- [Configure signals in health models](./signals.md).
- [Configure alerts in health models](./alerts.md).