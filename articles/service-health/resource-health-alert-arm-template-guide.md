---
title: How to create Resource Health alerts in Service Health
description: Create alerts in Azure Service Healthvto notify you when your Azure resources become unavailable.
ms.topic: conceptual
ms.date: 11/05/2025 

---

# Create and configure Resource Health alerts 

This article shows you how to create and configure Azure Resource Health alerts using the Azure Service Health portal.

Resource Health alerts notify you when your Azure resources experience a change in health status, such as becoming unavailable or degraded. These alerts help you stay informed and respond quickly to service issues affecting your workloads.


## Create a Resource Health alert rule in the Service Health portal

1. In the Azure [portal](https://portal.azure.com/), select **Service Health**.

:::image type="content" source="./media/resource-health-alert-monitor-guide/service-health-selection-1.png" alt-text="Screenshot of Resource Health option." lightbox="./media/resource-health-alert-monitor-guide/service-health-selection-1.PNG":::


2. Select **Resource Health**.

:::image type="content" source="./media/alerts-activity-log-service-notifications/resource-health-select.png" alt-text="Screenshot of Service Health option." lightbox="./media/alerts-activity-log-service-notifications/resource-health-select.png":::

    
3. Select **Add resource health alert**.
   
:::image type="content" source="./media/resource-health/resource-health-create.PNG" alt-text="Screenshot of Resource Health create option." lightbox="./media/resource-health/resource-health-create.PNG":::

The **Create an alert rule** wizard opens the **Condition** tab, with the **Scope** tab already populated. 

:::image type="content" source="./media/resource-health/resource-health-create-scope.PNG" alt-text="Screenshot of Resource Health scope tab." lightbox="./media/resource-health/resource-health-create-scope.PNG":::

4. Follow the steps to create Resource Health alerts, starting from the **Condition** tab, in the [Alert rule wizard](../azure-monitor/alerts/alerts-create-activity-log-alert-rule.md).

:::image type="content" source="./media/resource-health/resource-health-create-condition.PNG" alt-text="Screenshot of Resource Health condition tab." lightbox="./media/resource-health/resource-health-create-condition.PNG":::

## For more information

Learn more about Resource Health:

* [Azure Resource Health overview](Resource-health-overview.md)
* [Resource types and health checks available through Azure Resource Health](resource-health-checks-resource-types.md)

Create Service Health Alerts:

* [Configure Alerts for Service Health](./alerts-activity-log-service-notifications-portal.md) 
* [Azure Activity Log event schema](../azure-monitor/essentials/activity-log-schema.md)
* [Understand structure and syntax of ARM templates](/azure/azure-resource-manager/templates/syntax#template-format)
