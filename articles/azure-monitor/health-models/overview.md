---
title: Health models in Azure Monitor (preview)
description: Overview of health models in Azure Monitor that allow you to track the health of your Azure resources and workloads.
ms.topic: overview
author: bwren
ms.author: bwren
ms.date: 05/13/2026
ai-usage: ai-assisted
---

# Health models in Azure Monitor (preview)

Azure Monitor health models allow you to define and track the health of entities in your workload and the resources they depend on. Health models augment raw monitoring signals collected by Azure Monitor with business context, so you can monitor the health of a workload rather than isolated resources.

Health models introduce state-based monitoring to Azure Monitor. This adds a business context to your monitoring data by assigning a health state to each managed entity and combining multiple entities to represent an application or workload. 

State-based monitoring provides the following benefits over exclusively alert-based monitoring:

- Identify the current health of each entity in the health model based on multiple signals.
- Reduce alert noise by correlating multiple signals into a single health state.
- Define relationships between workload components to identify health dependencies and track overall workload health.
- Create generic entities to aggregate the health of related entities in the health model.

:::image type="content" source="media/overview/sample-health-model.png" lightbox="media/overview/sample-health-model.png" alt-text="Screenshot of an example health model." :::


## Track health
Entities in the health model represent Azure resources, and each has a set of signals that together determine its overall health state. Signals can be based on metrics or log queries, and you can define your own signals or use a set of recommended signals for common Azure resources. The health of each entity rolls up to any entities that depend on it, giving you an overall health state for the entire workload.

Track the health of your workload using multiple views. The Graph view shown above gives you a graphical representation of the current health of the workload, while the Timeline view provides its health over time. Drill in on any entity in the model for a detailed view of its health state and the signals that contribute to it.

:::image type="content" source="media/overview/sample-graph-view.png" lightbox="media/overview/sample-graph-view.png" alt-text="Screenshot of health details of an entity in a sample health model." :::

## Leverage existing investments
Health models leverage your existing investments in Azure Monitor by working with the same data that you're already collecting for your Azure resources. This includes platform metrics and resource logs, Prometheus metrics from your Kubernetes clusters, logs and metrics from your virtual machines, and application data collected from Azure Monitor. Alerts created from health models are integrated into your existing Azure Monitor alerting experience and use the same action groups for notifications and automation.


## Configure a model
Azure Monitor health models provide a graphical designer to arrange entities, define dependencies, add signals, and tune health rollup behavior. Manually add Azure resources to the model or create discoveries to automatically populate the model based on an Azure Resource Graph query, an Application Insights resource, or a service group.

:::image type="content" source="media/overview/design-view.png" lightbox="media/overview/design-view.png" alt-text="Screenshot of configuring details of an entity in the designer for a sample health model." :::


## Alerting
Health models allow you to create alerts based on health state instead of individual signals. Alert on unhealthy entities or on aggregate health that represents business impact across multiple dependencies. This approach reduces alert noise, focuses investigations on workload impact, and uses the same action groups as other Azure Monitor alerts.

:::image type="content" source="media/overview/sample-alert-rule.png" lightbox="media/overview/sample-alert-rule.png" alt-text="Screenshot of configuring details of an alert rule for a sample health model." :::

## Next steps

- [Create a new health model](./create.md).
- [Understand the concepts of health models](./concepts.md).
