---
title: Configure health rollup in an Azure Monitor health model (preview)
description: Learn how to configure aggregation rules and impact settings to control how health states roll up from child entities to parent entities in Azure Monitor health models.
ms.topic: tutorial
author: bwren
ms.author: bwren
ms.date: 06/16/2026
ai-usage: ai-assisted
---

# Tutorial: Configure health rollup in an Azure Monitor health model (preview)

Health models help you represent how the health of dependent entities contributes to overall workload health. In this tutorial, you configure dependencies and impact settings to control how health states roll up from child entities to parent entities.

In this tutorial, you learn how to:

> [!div class="checklist"]
> - Configure percentage-based and count-based dependency rules for parent entities.
> - Configure suppressed and limited impact behavior for child entities.
> - Validate rollup behavior in graph view.

## Prerequisites

To complete this configuration, you need an Azure Monitor health model that contains entities with child dependencies. Those child entities should already have signals that determine their own health states. If you don't have a model yet, see [Create a new Azure Monitor health model](./create.md).

## Determine a health baseline for your workload

Before you configure aggregation logic, decide what healthy means for your workload. For example, determine how many failed nodes, regions, or services your system can tolerate before the parent entity should become degraded or unhealthy. These decisions help you choose the right aggregation type and threshold values for your model.

## Configure dependencies settings for rollup

Dependencies settings define how a parent entity evaluates the health of its child entities. They let you choose how child health states are combined and what threshold must be reached before the parent becomes healthy, degraded, or unhealthy. For background information, see [Dependencies (parent)](./concepts.md#dependencies-parent).

### Configure percentage-based dependency

A cluster of virtual machines can keep running normally as long as most nodes stay healthy. In this scenario, you can configure the parent entity so it becomes unhealthy only when more than 60% of its child nodes are unhealthy.

1. Select **Designer** from your health model's menu in the Azure portal.

1. Select **Edit** on the parent entity you want to configure.

1. Select the **Signals** tab and then **Configuration**. The **Dependencies** configuration pane opens.

1. Select **Minimum healthy** as the **Aggregation type**, set the **Unhealthy threshold** to **60**, and select **Percentage** as the **Data unit**.

   > [!NOTE]
   > The **Ignore unknown** checkbox is selected by default. This setting excludes any children with unknown health states from the threshold calculation.

1. Select **Save**.

   :::image type="content" source="media/rollup/percentage-aggregation-config.png" lightbox="media/rollup/percentage-aggregation-config.png" alt-text="Screenshot of the Dependencies configuration pane with Minimum healthy aggregation type, Percentage data unit, and an unhealthy threshold of 60.":::

1. Select **Graph** from the menu and review the health model. With a percentage-based rule, the parent entity changes health when the proportion of child entities that aren't healthy reaches the threshold you configured.

   :::image type="content" source="media/rollup/percentage-aggregation-graph.png" lightbox="media/rollup/percentage-aggregation-graph.png" alt-text="Screenshot of the graph view showing a parent entity marked as unhealthy because more than 60% of its child VM entities are unhealthy.":::

### Configure count-based dependency

An application with built-in reliability and tolerances across regions might stay healthy if at least two regions continue serving traffic. In this scenario, you can configure the parent entity to become unhealthy only when three or more child regions are unhealthy.

1. Select **Designer** from your health model's menu in the Azure portal.

1. Select **Edit** on the parent entity you want to configure.

1. Select the **Signals** tab and then **Configuration**. The **Dependencies** configuration pane opens.

1. Select **Maximum not healthy** as the **Aggregation type**, set the **Unhealthy threshold** to **3**, and select **Absolute** as the **Data unit**.

1. Select **Save**.

   :::image type="content" source="media/rollup/count-aggregation-config.png" lightbox="media/rollup/count-aggregation-config.png" alt-text="Screenshot of the Dependencies configuration pane with Maximum not healthy aggregation type, Absolute data unit, and an unhealthy threshold of 3.":::

1. Select **Graph** from the menu and examine your health model. When the number of unhealthy child entities reaches or exceeds the threshold, the parent entity becomes unhealthy and rolls that health state up to the overall health of the workload.

   :::image type="content" source="media/rollup/count-aggregation-graph.png" lightbox="media/rollup/count-aggregation-graph.png" alt-text="Screenshot of the graph view showing a parent entity marked as unhealthy because three or more child region entities are unhealthy.":::

## Configure impact settings

Dependencies settings determine how child health states are combined. Impact settings complement this process by controlling how strongly an individual entity affects its parent when its health changes.

Use impact settings when a child entity shouldn't influence its parent in the same way as other dependencies. For example, you can suppress an entity so its degraded or unhealthy state doesn't affect the parent, or limit it so the propagated health state is less severe. For background on how impact settings work, see [Impact (child)](./concepts.md#impact-child) in Azure Monitor health model concepts.

### Configure suppressed impact

Use **Suppressed** impact when a dependency is optional and its health shouldn't affect the overall workload health. For example, a newsletter sign-up component might become degraded or unhealthy without affecting the core user journey of the application. In this scenario, suppress the entity so its health state doesn't contribute to the parent entity's health rollup. Similarly, a reporting server that provides background analytics but isn't required to serve user requests could be configured as **Suppressed** so the workload remains healthy when that component fails.

1. Select **Designer** from your health model's menu in the Azure portal.

1. Select **Edit** on the entity you want to configure.

1. In the entity editor, find the **Impact** setting, select **Suppressed**, and then select **Save**.

   :::image type="content" source="media/rollup/impact-suppressed-config.png" lightbox="media/rollup/impact-suppressed-config.png" alt-text="Screenshot of the entity editor with the Suppressed impact setting selected.":::

1. Select **Graph** from the menu and examine your health model. When the entity becomes degraded or unhealthy, its health state doesn't affect the parent entity or roll up to the overall health of the workload.

   :::image type="content" source="media/rollup/impact-suppressed-graph.png" lightbox="media/rollup/impact-suppressed-graph.png" alt-text="Screenshot of the graph view showing the Newsletter sign-up entity as unhealthy while the parent entity remains healthy.":::

### Configure limited impact

Use **Limited** impact when a dependency is important but the workload can continue operating without it at a reduced level of service. For example, an application might use a cache to improve performance, but if the cache becomes unhealthy, requests can fall back to the database. In this scenario, configure the cache entity as **Limited** so the application becomes degraded instead of unhealthy when the cache fails.

1. Select **Designer** from your health model's menu in the Azure portal.

1. Select **Edit** on the entity you want to configure.

1. Select **Limited** and then select **Save**.

   :::image type="content" source="media/rollup/impact-limited-config.png" lightbox="media/rollup/impact-limited-config.png" alt-text="Screenshot of the entity editor with the Limited impact setting selected.":::

1. Select **Graph** from the menu and review the health model. With **Limited** impact, the parent treats a degraded child as healthy and an unhealthy child as degraded. This reduction lowers the severity that rolls up to the overall health of the workload.

   :::image type="content" source="media/rollup/impact-limited-graph.png" lightbox="media/rollup/impact-limited-graph.png" alt-text="Screenshot of the graph view showing the cache entity as unhealthy and the parent entity as degraded due to Limited impact.":::

## Next steps

Now that you configured health rollup behavior, learn how to set and tune signals that drive health state changes.

> [!div class="nextstepaction"]
> [Configure signals in health models](./signals.md)
