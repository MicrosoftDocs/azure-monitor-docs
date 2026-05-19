---
title: Alerts in Azure Monitor health models (preview)
description: Learn alert concepts and configuration for Azure Monitor health models, including alert strategy, severity, and action groups.
ms.topic: how-to
author: bwren
ms.author: bwren
ms.date: 05/18/2026
ai-usage: ai-assisted
---

# Alerts in Azure Monitor health models (preview)
Alerts in [Azure Monitor health models](./overview.md) fire when the health state of an entity changes. [Action groups](../alerts/action-groups.md) associated with an alert rule trigger automated responses that can proactively notify you when critical issues ocur in the work load represented by the health model. This article explains alert concepts and how to configure alerts in the designer.

## Alert concepts
Alerts can be configured independently on any entity in the health model. They can be fired when the entity enters a degraded or an unhealthy state. The only configuration required is the severity and description of the alert.

An alert is fired only when the entity changes state. Even though multiple signals may be degraded or unhealthy, only a single alert is fired. The alert is automatically resolved when the entity returns to a healthy state.

Health model alerts integrate with [Azure Monitor alerts](../alerts/alerts-overview.md) and can use the same [action groups](../alerts/action-groups.md) for notifications and automation.

Health model alerts differ from resource-level alerts because they evaluate entity health states that can include multiple signals and dependency rollup.

:::image type="content" source="media/concepts/alert.png" lightbox="media/concepts/alert.png" alt-text="Diagram of alert created from health state." border="false":::

The following table summarizes key differences.

| Azure resource alert rules | Health entity alert rules |
|:---|:---|
| Based on a single metric value or log query from a single resource. | Based on entity health state, which can include multiple signals and child-entity rollup. |
| Can trigger multiple alerts from one resource when multiple rules fire. | Triggers one alert per entity for the configured health state transition. |
| Usually uses identical criteria and severity for one resource type. | Supports different criteria and severity by entity role in each model. |

## Build an alert strategy
You can define alert rules at different levels in the same model for different audiences.

For example, create alerts on Azure resource entities for engineering teams, alerts on generic entities for business or operations teams, and a root alert for executive awareness.

:::image type="content" source="media/concepts/alert-strategy.png" lightbox="media/concepts/alert-strategy.png" alt-text="Diagram of a health model with alert rules at different levels." border="false":::

If you already have resource-level alert rules, those rules continue to fire. Review and disable redundant rules when health model alerts provide better workload context.

## Configure alerts in the designer
To configure alerts for an entity:

1. Open the [Designer](./designer.md) for the health model.
1. Select an entity and choose **Edit**.
1. On the **Alerts** tab, enable **Degraded**, **Unhealthy**, or both.
1. Set the alert **Severity**.
1. Optionally select up to five action groups.
1. Save the entity and then select **Save changes** in the designer.

:::image type="content" source="media/designer/entity-editor-alerts.png" lightbox="media/designer/entity-editor-alerts.png" alt-text="Screenshot of alert configuration in the entity editor.":::

### Alert behavior
When an enabled health state transition occurs, the alert fires for that entity and configured state.

Only one alert is created for the entity even when multiple underlying signals contribute to that state.

## Next steps
- [Understand health model concepts](./concepts.md)
- [Configure signals in health models](./signals.md)
- [Analyze health state of the health model and its entities](./analyze-health.md)
