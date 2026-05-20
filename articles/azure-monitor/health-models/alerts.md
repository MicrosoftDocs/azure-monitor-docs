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
[Alerts in Azure Monitor health models](./overview.md#alerting) fire when the health state of an entity changes. Action groups associated with an alert rule trigger automated responses that can proactively notify you when critical issues occur in the work load represented by the health model. This article explains alert concepts and how to configure alerts in the designer.

## Configure alerts in the designer
To configure alerts for an entity:

1. Open the [Designer](./designer.md) for the health model.
1. Select an entity and choose **Edit**.
1. On the **Alerts** tab, enable **Degraded**, **Unhealthy**, or both. The alert fires when the entity enters the corresponding health state based on its signals and child dependencies.
1. Set the alert **Severity** and provide an optional description.
1. Optionally select up to five [action groups](../alerts/action-groups.md) depending on your notification requirements.
1. Save the entity and then select **Save changes** in the designer.

:::image type="content" source="media/designer/entity-editor-alerts.png" lightbox="media/designer/entity-editor-alerts.png" alt-text="Screenshot of alert configuration in the entity editor.":::

## Migrate from resource-specific alert rules
Any resource-specific alert rules configured on an Azure resource will continue to operate when that resource is added to a health model, even if health model alerts are enabled. This could result in duplicate alerts for the same underlying issue. 

There are multiple strategies that you may employ to migrate from resource-specific alert rules to health model alerts:

- Add the Azure resource to a health model and enable signals but not alerts. When a resource-specific alert fires, use the health model signals to analyze the health state of the entity and validate that the health model is correctly reflecting the issue. Once you have confidence in the health model configuration, enable alerts in the health model and disable the resource-specific alert rules.
- Generate both alerts until you can validate that the health model alerts are firing as expected, and then disable the resource-specific alert rules to avoid duplicates.
- Import alerts from resource-specific alert rules to the health model using the **Import from alert rule** option when adding signals in the designer. This creates signals based on the alert rule criteria and alert rules based on the alert rule configuration. You can then disable the original resource-specific alert rules to avoid duplicates.



## Next steps
- [Understand health model concepts](./concepts.md)
- [Configure signals in health models](./signals.md)
- [Analyze health state of the health model and its entities](./analyze-health.md)
