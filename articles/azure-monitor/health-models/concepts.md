---
title: Azure Monitor health model concepts
description: Description of the core concepts required for building and using health models in Azure Monitor.
ms.topic: conceptual
author: bwren
ms.author: bwren
ms.date: 05/22/2025
---

# Azure Monitor health model concepts (preview)
This article describes the concepts that you must understand to create and use [Azure health models](./overview.md). This includes the components that make up a model, how those components are related, and how the health of each component is determined. See [Using the Designer in Azure Monitor](./designer.md) for details on creating and configuring these components.


## Entities
Entities are the building blocks of an [Azure Monitor health model](./overview.md). They represent the different components of your workload and any supporting business processes. Entities in your health model are discovered from the service group the model is linked to.  This article describes the different types of entities, how they relate to each other, and how to configure them in different views.

There are two distinct types of entities as described in the following sections.

:::image type="content" source="media/concepts/entities.png" lightbox="media/concepts/entities.png" alt-text="Screenshot showing entity types.":::

### Root entity
All health models have a single entity called the *root entity* that represents the model itself. All other entities in the health model will connect to the root. The root entity can't be deleted.

The primary use of the root entity is to represent the overall health of the workload or application that the service group supporting the health model represents. You can track health of the application over time and create alerts based on the health of the root entity either in addition or instead of the individual entities in the model. 


### Azure resource entity
An *Azure resource entity* represents an Azure resource from the current subscription or a subscription that you can access. Entities may also reside in another subscription if they're in a shared service group that you have access to.

To add an Azure resource entity to your health model you need to first add it as a member to your service group. The health model will then discover the resource and automatically add an Azure resource entity to the model to represent this new service group member. This discovery is automatically run every 5 minutes.

The health model includes a representation of the Azure resource and not the resource itself. A resource can be represented by in multiple health models, and each can define different monitoring requirements and business logic. If the resource is represented by multiple entities in different models, then the signals for each entity are evaluated separately, and each has its own independent health state.

The signals applied to each Azure resource entity are evaluated from the metrics or logs that are associated with the resource. The collection of this data is defined for the resource itself and not in the health model. The health model instead focuses how to interpret that data in the context of the role of the resource in the workload. 

### Health component
A *health component* represent a unique application component that isn't represented in the service group. It can have its own signals, although it may just have a health state determined by the health of its propagation paths. Unlike the Azure resource entities which are automatically discovered from the service group, you manually add health components to the model.

## Propagation paths
A propagation path represents the propagation of [health](#health-states) from one entity to another. When the health model is created, a path is automatically created from each Azure resource entity in the service group to the root entity. You can create additional propagation paths between entities in the health model to define propagation of the health throughout the model. 

## Signals
The [health state](#health-states) of an entity in an Azure Monitor health model is determined by one or more *signals*. A signal is a value from a metric or a log query result that is periodically compared to threshold values associated with each health state for that entity.

Each signal type uses a different type of data source that you must configure for each entity. The following table describes the different types of signals that can be used in a health model and their data sources. 

| Signal type | Data source |
|:---|:---|
| Azure resource | Sample the value of a [platform metric](../essentials/data-platform-metrics.md) from a particular resource and compare against a numeric threshold. |
| Log Analytics workspace | Run a [log query](../logs/queries.md) against a Log Analytics workspace and evaluate the results. |
| Azure Monitor workspace | Runs a [PromQL query](../metrics/metrics-explorer.md) to analyze Prometheus and evaluate the results. |

The health model doesn't collect data that signals use but instead relies on data that's already being collected for the Azure resources reference in the model. You must configure this data collection using other features of Azure Monitor. Since [platform metrics](../platform/tutorial-metrics.md) are automatically collected for all resources, data for Azure resource signals will always be available. See [Sources of monitoring data for Azure Monitor](../data-sources.md) for information on enabling data collection to support Log Analytics workspace and Azure Monitor workspace signals.

## Health states
The *health state* of an entity represents its ability to perform its required tasks. It may be fully functional and performing within an expected range, or it may have limited functionality or degraded performance, or it may not be functional at all. This article describes how health states are determined and how they roll up to parent entities in the health model. 

The health state of an entity is determined by the [signals](#signals) that are associated with it, and it may be affected by the health states of any entities with propagation paths to it. You can view the most current health state of your workflow and its components in addition to tracking the health of the model over time.

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

In addition to its own signals, the health state of any entity in the model, including the root entity, is affected by any entities with a propagation path to it. The following example shows multiple entities in different health states propagating health the same root entity. The health of the root is set to an unhealthy state since this is the worst state of all its children.

You may also use health rollup to consolidate the health of multiple entities. For example, you may want to track the health of a particular component of your application, or the resources in a particular region or business unit. In this case, you can add a [health component](#health-component) to your model that rolls up the health of the child entities you want to aggregate.

The following example illustrates health propagation in a sample health model. The signals are shown for the event hub and storage account entities. Even though the signals for the event hub are healthy, its health state is unhealthy due to the unhealthy state of the storage account that it depends on. This unhealthy state is propagated to the root entity since its the worst state of the entities connected to the root.

:::image type="content" source="media/concepts/health-signals-rollup.png" lightbox="media/concepts/health-signals-rollup.png" alt-text="Screenshot of an example entity showing the health state from a child entity." border="false":::

### Impact
The *impact* of an entity determines how its health state is propagated to its parent. The following table describes the different impact settings. Select the setting for each entity in the [entity editor](#entities).

| Option | Description |
|:-------|:------------|
| Standard | Propagates the entity state up to the parent. This is the default setting and the most common. |
| Limited  | Doesn't propagate a degraded state and propagates an unhealthy state as degraded. The parent will never receive an unhealthy state from this entity. For example, you may have an application that depends on a cache. If the cache is unhealthy, then the application will keep performing but with degraded performance. |
| Suppressed | Doesn't propagate any health state. Even if the entity is degraded or unhealthy, the parent will appear as healthy. For example, your application may have a backup operation represented by an entity in the health model. Even though the backup operation is unhealthy, the application continues operating normally. |

The following sample shows the effect of each impact setting. Each of the child entities is in an unhealthy state, but the parent health states are difference based on the impact setting of each child. 

:::image type="content" source="media/concepts/health-impact.png" lightbox="media/concepts/health-impact.png" alt-text="Screenshot of an example health model showing different impact settings." border="false":::

### Health objective
The health objective for an entity is the target percentage of time this entity should be healthy. This allows you to track the achievement of your availability goals over time. Health objective is an optional value. Instead of setting one for each entity in the health model, you may choose to only set a health objective for the root entity which represents a health objective for the entire workload. Select the setting for each entity in the [entity editor](#entities).

Following is a history from [Entity details](./analyze-health.md#entity-details) for a sample entity showing health objective reporting.

:::image type="content" source="media/concepts/health-objective.png" lightbox="media/concepts/health-objective.png" alt-text="Screenshot of an example health objective reporting.":::



## Alerts
Alerts in [Azure Monitor health models](./overview.md) allow you to be proactively notified when the health state of an entity changes. These alerts integrate with [Azure Monitor alerts](../alerts/alerts-overview.md) and can use the same [action groups](../alerts/action-groups.md) to notify your team or take corrective action.

Alerting in health models is distinctly different than other alerting in Azure Monitor which typically alerts on each signal associated with a resource without any context of that resource's role in the application or workload. Health models allow you to create alerts that are more meaningful to your business and reduce the overall number of alerts generated for the same number of issues.

:::image type="content" source="media/concepts/alert.png" lightbox="media/concepts/alert.png" alt-text="Diagram of alert created from health state." border="false":::

The following table summarizes the differences between alert rules for Azure resources and alert rules for entities in a health model.

| Azure resource alert rules | Health entity alert rules |
|:---|:---|
| Based on a single metric value or log query from a single resource. | Based on the health state of an entity which is determined from multiple signals and/or from multiple child entities. Can also alert from the root entity based on the health of its children entities. |
| Potential multiple alerts from the same resource if multiple rules fire simultaneously. | Only one alert from an entity even if multiple signals are unhealthy. |
| Always same alert criteria and severity for a particular resource. | Different alert criteria and severity for entities in different models representing the same resource. |

You may have alert rules already defined for the Azure resources represented by your entities in the health model. These alert rules will continue to generate alerts so you may want to disable them if you create an alert rule for the health state of an entity.

Alert rules in health models also provide an opportunity to alert a different audience at the root entity level. In the following example, alert rules that send an email to the operations team are created for the Azure resource entities since this is the team that will diagnose the problem and take corrective action. An alert rule on the root entity is created to send an email to the executive team for awareness of the application being unavailable.

Alert rules in health models also provide an opportunity to create different alerts for different audiences. In the following example, alert rules that send an email to the operations team are created for the Azure resource entities since this is the team that will diagnose the problem and take corrective action. Alert rules that send an email to the business team are created for the health component since this is the team that will communicate the problem to the customers and make decisions about the business impact. Finally, an alert rule on the root entity is created to send an email to the executive team for awareness of the application being unavailable.

:::image type="content" source="media/concepts/alert-strategy.png" lightbox="media/concepts/alert-strategy.png" alt-text="Diagram of a health model with alert rules at different levels." border="false":::



## Next steps
- [Create a new health model](./create.md).
- [Configure a health model using the designer](./designer.md).