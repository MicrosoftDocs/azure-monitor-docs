---
author: AbbyMSFT
ms.author: abbyweisberg
ms.service: azure-monitor
ms.topic: include
ms.date: 03/07/2025
---

### Design checklist

> [!div class="checklist"]
> * Use dynamic thresholds in metric alert rules where appropriate.
> * Whenever possible, use one alert rule to monitor multiple resources.
> * To control behavior at scale, use alert processing rules.
> * Leverage custom properties to enhance diagnostics
> * Leverage Logic Apps to customize, enrich, and integrate with a variety of systems

### Configuration recommendations

| Recommendation | Benefit |
|:---------------|:--------|
| Use [dynamic thresholds](../alerts/alerts-dynamic-thresholds.md) in metric alert rules where appropriate. | You may be unsure of the correct numbers to use as the thresholds for your alert rules. Dynamic thresholds use machine learning and a set of algorithms and methods to determine the correct thresholds based on trends. This means you don't need to know the correct predefined threshold in advance. Dynamic thresholds are also useful for rules that monitor multiple resources, and a single threshold can't be configured for all of the resources. For more information, see [Dynamic thresholds in metric alerts](../alerts/alerts-dynamic-thresholds.md). |
| Whenever possible, use one alert rule to monitor multiple resources. | Using alert rules that monitor multiple resources reduces management overhead by allowing you to manage one rule to monitor a large number of resources. |
| To control behavior at scale, use [alert processing rules](../alerts/alerts-processing-rules.md). | Alert processing rules can be used to reduce the number of alert rules you need to create and manage. |
| Use custom properties for [metric alert rules](../alerts/alerts-create-metric-alert-rule.md#configure-the-alert-rule-details) and [log search alert rules](../alerts/alerts-create-log-alert-rule.md#configure-alert-rule-details) to enhance diagnostics. | If the alert rule uses action groups, you can add your own properties to include in the alert notification payload. You can use these properties in the actions called by the action group, such as webhook, Azure function, or logic app actions. |
| Use [Logic Apps](../alerts/alerts-logic-apps.md) to customize the notification workflow and integrate with various systems. | You can use Azure Logic Apps to build and customize workflows for integration. Use Logic Apps to customize your alert notifications.<br><br>You can:<br>• Customize the alerts email by using your own email subject and body format.<br>• Customize the alert metadata by looking up tags for affected resources or fetching a log query search result.<br>• Integrate with external services by using existing connectors like Outlook, Microsoft Teams, Slack, and PagerDuty. You can also configure the logic app for your own services. |
