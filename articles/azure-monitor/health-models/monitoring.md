---
title: Monitoring a health model in Azure Monitor (preview)
description: Learn how to monitor an Azure Monitor health model by using model-level Metrics and Alerts in the Azure portal.
ms.topic: how-to
author: bwren
ms.author: bwren
ms.date: 06/26/2026
ai-usage: ai-assisted
---

# Monitoring a health model in Azure Monitor (preview)

After you create and configure a health model, you can monitor the health model resource itself in the Azure portal. This monitoring is separate from entity-level monitoring inside the model.

Use the following options:

- **Metrics** to track model-level telemetry, such as how many entities and relationships are in the model, or discovery execution performance.
- **Alerts** to create alert rules on health model platform metrics and events.

## View health model metrics

Use model-level metrics to monitor model growth, discovery activity, and platform behavior.

1. Open your health model resource in the Azure portal.

1. Under **Monitoring**, select **Metrics**.

1. In **Metric namespace**, select **Health model standard metrics**.

1. Select a metric and aggregation to visualize a trend over time.

Common metrics include:

- **Number of entities in health model** to track model size.
- **Number of relationships in health model** to track topology complexity.
- **Discovery rule execution duration** to track discovery performance.
- **Discovery rule entities discovered count** to track discovery results.

:::image type="content" source="media/monitoring/health-model-metrics.png" lightbox="media/monitoring/health-model-metrics.png" alt-text="Screenshot of the Metrics page for a health model in Azure portal, showing Health model standard metrics including number of entities, number of relationships, and discovery rule execution duration.":::

## Create alerts for the health model resource

Model-level alerts are alert rules on the health model resource itself. They're not the same as alerts configured inside the health model for monitored entities. For details on entity-level alerts, see [Enable alerts in Azure Monitor health models](./alerts.md).

Use model-level alerts for scenarios such as:

- Notifying when discovery behavior changes unexpectedly.
- Notifying when discovery events indicate model updates, such as newly discovered entities.
- Notifying when model-level metric values cross expected thresholds.

To create a model-level alert:

1. Open your health model resource in the Azure portal.

1. Under **Monitoring**, select **Alerts**.

1. Select **Create** and then **Alert rule**.

1. Select a model-level signal, configure condition logic, and set thresholds.

1. Configure an action group and alert details, and then create the rule.

## Next steps

- [Enable alerts in Azure Monitor health models](./alerts.md)
- [Analyze health state of Azure Monitor health models](./analyze-health.md)
- [Create discoveries in Azure Monitor health models](./discoveries.md)
