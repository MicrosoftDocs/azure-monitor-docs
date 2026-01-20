---
title: Health models in Azure Monitor (preview)
description: Overview of health models in Azure Monitor that allow you to track the health of your Azure resources and workloads.
ms.topic: overview
author: bwren
ms.author: bwren
ms.date: 06/27/2025
---

# Health models in Azure Monitor (preview)

Azure Monitor health models allow you to define and track the health of the Azure resources in your [service groups](/azure/governance/service-groups/overview) and the resources they depend on. Health models augment raw monitoring signals collected by Azure Monitor with critical business context, setting a baseline against which the workload is monitored. 

Azure health models allow you to:

- Track the health of your Azure workloads based on the health of its individual components.
- Alert on the health of your service group or any of its components based on multiple signals.
- Add business context to the monitoring data collected by Azure Monitor.

:::image type="content" source="media/overview/sample-health-model.png" lightbox="media/overview/sample-health-model.png" alt-text="Screenshot of an example health model." :::


## Track health
Each resource included in your health model has a set of signals that together determine the overall health rating for that resource. Signals can be based on metrics or log queries, and you can define your own signals or use a set of recommended signals for common Azure resources. The health of each resource rolls up to any resources that depend on it, giving you an overall health rating for the entire workload.

Track the health of your workload using multiple views. The Graph view shown above gives you a graphical representation of the current health of the workload, while the Timeline view provides its health over time. Drill in on any entity in the model for a detailed view of its health state and the signals that contribute to it.

:::image type="content" source="media/overview/sample-graph-view.png" lightbox="media/overview/sample-graph-view.png" alt-text="Screenshot of health details of an entity in a sample health model." :::

## Configure a model
Health models are based on [Azure service groups](/azure/governance/service-groups/overview), which allow you to group Azure resources that work together in a common workload or application. You specify a service group when you create a health model, and the health model is automatically populated with the resources in that service group. If any resources are added or removed from the service group, then the health model is automatically updated to reflect those changes. You use a graphical tool to arrange the resources in your health model and to configure their health signals. 

:::image type="content" source="media/overview/design-view.png" lightbox="media/overview/design-view.png" alt-text="Screenshot of configuring details of an entity in the designer for a sample health model." :::


## Alerting
Health models allow you to create alerts based on health as opposed to individual signals. Alert on individual unhealthy resources in the model or only on the aggregate of multiple resources that affect the health of the workload. This results in fewer alerts that are focused on business impact as opposed to technical details and leverages the same action groups as other Azure Monitor alerts.

:::image type="content" source="media/overview/sample-alert-rule.png" lightbox="media/overview/sample-alert-rule.png" alt-text="Screenshot of configuring details of an alert rule for a sample health model." :::


## Next steps

- [Create a new health model](./create.md).
- [Understand the concepts of health models](./concepts.md).
