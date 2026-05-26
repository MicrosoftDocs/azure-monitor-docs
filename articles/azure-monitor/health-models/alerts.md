---
title: Alerts in Azure Monitor health models (preview)
description: Learn alert concepts and configuration for Azure Monitor health models, including alert strategy, severity, and action groups.
ms.topic: how-to
author: bwren
ms.author: bwren
ms.date: 05/25/2026
ai-usage: ai-assisted
---

# Enable alerts in Azure Monitor health models (preview)
[Alerts in Azure Monitor health models](./overview.md#alerting) fire when the health state of an entity changes. Action groups associated with an alert rule trigger automated responses that can proactively notify you when critical issues occur in the work load represented by the health model. This article explains how to configure alerts in the designer.

Unlike resource-specific alert rules in Azure Monitor, health model alerts are configured for an entity instead of individual signals. The signals determine the health state of the entity, and the alert fires when that state changes. 

## Enable alerts for an entity

Configure alerts for an entity on the **Alerts** tab in the entity editor. You can enable **Degraded**, **Unhealthy**, or both. The alert fires when the entity enters the corresponding health state based on its signals and child dependencies. The only properties you need to specify are the alert **Severity** and an optional description.

Add up to five [action groups](../alerts/action-groups.md) for each entity to define the automated responses that will be triggered when the alert fires.

:::image type="content" source="media/alerts/entity-editor-alerts.png" lightbox="media/alerts/entity-editor-alerts.png" alt-text="Screenshot of alert configuration in the entity editor.":::

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
