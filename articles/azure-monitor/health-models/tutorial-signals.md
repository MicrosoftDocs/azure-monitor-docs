---
title: Configure signals in an Azure Monitor health model (preview)
description: Learn how to configure Azure resource metric signals, Log Analytics workspace signals, and Azure Monitor workspace PromQL signals for entities in Azure Monitor health models.
ms.topic: tutorial
ms.date: 06/20/2026
ai-usage: ai-assisted
---

# Tutorial: Configure signals in an Azure Monitor health model (preview)

Signals determine the health state of each entity in your Azure Monitor health model. In this tutorial, you configure three signal types in the designer: Azure resource metric signals, Log Analytics workspace signals (logs), and Azure Monitor workspace signals (metrics).

In this tutorial, you learn how to:

> [!div class="checklist"]
> - Add and tune an Azure resource metric signal.
> - Add and tune a Log Analytics workspace signal based on a KQL query.
> - Add and tune an Azure Monitor workspace signal based on a PromQL query.
> - Reuse signal definitions across entities.

## Prerequisites

Before you start:

- Create a health model with at least one entity. For details, see [Create a new Azure Monitor health model](./create.md).
- Verify that your entity maps to a real data source such as an Azure resource, Log Analytics workspace telemetry, or Prometheus metrics in an Azure Monitor workspace.
- Ensure the health model identity has permissions to read the target telemetry. For details, see [Permissions required](./create.md#permissions-required).

## Understand signal options in the entity editor

1. Select **Designer** from your health model's menu in the Azure portal.
1. Select **Edit** on the entity you want to configure.
1. Select the **Signals** tab.

The **Signals** tab lets you add and tune signal assignments for the entity.

:::image type="content" source="media/signals/signals-empty.png" lightbox="media/signals/signals-empty.png" alt-text="Screenshot of the Signals tab for an entity in the health model designer.":::

When you add a signal assignment, you can choose one of these options:

- **Create new** to define a new signal.
- **Signal definitions** to reuse an existing signal definition.
- **Recommended** to add a suggested signal for supported Azure resources.
- **Import from alert rules** to create a signal from an existing Azure Monitor alert rule.

## Add an Azure resource metric signal

Use an Azure resource signal to evaluate platform metrics from the resource represented by the entity, such as CPU percentage, request count, or availability.

1. In the entity editor, under **Azure resource**, select **Add signal assignment** and then **Create new**.

1. Select a metric from the available list.

1. Configure threshold logic for **Degraded** and **Unhealthy**.

1. Optional: If available for the metric, apply suggested thresholds or enable dynamic thresholds.

   Dynamic thresholds adapt to historical behavior and seasonal patterns. During warm-up or sparse-data periods, health evaluation can temporarily rely on available in-place statistics until enough history is collected.

1. Select one of the following actions:

   - **Add to entity** to save this signal only on the current entity.
   - **Save as new signal definition** to create a reusable definition for other entities in the same health model.

1. Select **Save**.

:::image type="content" source="media/signals/azure-resource-signals.png" lightbox="media/signals/azure-resource-signals.png" alt-text="Screenshot of Azure resource signal settings in the entity editor.":::

> [!NOTE]
> For low-traffic resources, metric signals can temporarily show **Unknown** until sufficient data points are available.

## Add a Log Analytics workspace signal (KQL)

Use a Log Analytics workspace signal when health depends on log-based conditions, such as error rates, failed requests, or custom operational events.

1. In the entity editor, select **Add Log Analytics signals**.

1. Select **Log Analytics workspace**, choose the workspace resource, and select **Select resources**.

1. Set **Authentication setting** if needed, and then select **Add signal**.

1. Enter a display name.

1. Select **Edit query**, then write or select a KQL query that returns a single numeric value.

1. Configure **Degraded** and **Unhealthy** thresholds.

1. Select **Add to entity** or **Save as new signal definition**, and then select **Save**.

:::image type="content" source="media/signals/log-signals.png" lightbox="media/signals/log-signals.png" alt-text="Screenshot of Log Analytics workspace signal settings in the entity editor.":::

## Add an Azure Monitor workspace signal (PromQL)

Use an Azure Monitor workspace signal to evaluate Prometheus metrics by using PromQL, such as Kubernetes workload and infrastructure signals.

1. In the entity editor, select **Add Azure Monitor workspace signals**.
1. Select **Azure Monitor workspace**, choose the workspace resource, and select **Select resources**.
1. Set **Authentication setting** if needed, and then select **Add signal**.
1. Enter a display name and provide a PromQL query that returns a single numeric value.
1. Configure **Degraded** and **Unhealthy** thresholds for the expected operating range.
1. Select **Add to entity** or **Save as new signal definition**, and then select **Save**.

For detailed property guidance, see [Create and configure signals in Azure Monitor health models](./signals.md).

## Reuse signal definitions across entities

To apply an existing signal definition to another entity:

1. Open the target entity in **Designer** and go to **Signals**.
1. Select **Add signal assignment** and then **Signal definitions**.
1. Select a definition that isn't already assigned to the entity.
1. Select **Select**, and then select **Save**.

:::image type="content" source="media/signals/add-signal-definition.png" lightbox="media/signals/add-signal-definition.png" alt-text="Screenshot of selecting an existing signal definition while adding a signal assignment.":::

## Validate signal behavior

After you save your signals:

1. Select **Graph** and **Timeline** views to verify health transitions.
1. Confirm that entities shift between **Healthy**, **Degraded**, and **Unhealthy** as expected.
1. Refine thresholds if states are too sensitive or not sensitive enough.

## Next steps

After you configure signals, tune health propagation and alerting:

> [!div class="nextstepaction"]
> [Configure health rollup in an Azure Monitor health model](./rollup.md)
