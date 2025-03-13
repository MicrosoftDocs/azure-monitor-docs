---
title: Best practices for monitoring at-scale with Azure Monitor
description: Learn about solutions and recommendations for using Azure Monitor to monitor your environment at-scale.
ms.topic: conceptual
ms.date: 10/30/2024

# customer-intent: As an Azure Monitor customer, I want to learn about best practices for using Azure Monitor to monitor my at-scale.
---

# Best practices for monitoring at-scale with Azure Monitor

Azure Monitor is a comprehensive monitoring solution for collecting, analyzing, and responding to monitoring data from your cloud and on-premises environments.

In large and complex implementations, you need a way to manage your environment at-scale, without having to apply the same configurations, behaviors, or changes to each resource. Using at-scale solutions, you can apply settings to resources as they're created, and you can make changes that are automatically applied to all relevant resources.


## Use Azure Policies to implement at-scale solutions

Azure Policy is the most commonly used solution for implementing monitoring at-scale. 
Azure Policy is a service in Azure that you use to create, assign, and manage policies. These policies enforce different rules and effects over your resources, so those resources stay compliant with your corporate standards and service level agreements. Azure Policy can be used to enforce policies that apply to all resources in your subscription, or to a subset of resources.

For more information, see [Azure Policy](/azure/governance/policy/overview).

## At-scale solutions

The following table describes the solutions you can use to implement monitoring at scale for various scenarios. 


|At-scale solution|Resources   |
|---------|---------|
|Use Log Analytics workspace architecture  |[Design a Log Analytics workspace architecture](logs/workspace-design.md) |
|Configure diagnostic settings to collect data |[Create diagnostic settings at-scale using Azure Policies and Initiatives](essentials/diagnostic-settings-policy.md)|
|Configure agents to collect data |[Best practices for data collection rule creation and management in Azure Monitor](essentials/data-collection-rule-best-practices.md) |
|Configure alerts and action groups  | - You can use [Azure policies](/azure/governance/policy/overview) to easily implement [alerting at-scale](alerts/alerts-overview.md#alerting-at-scale). You can see how this is implemented with [Azure Monitor baseline alerts](https://aka.ms/amba).<br> - For Virtual machines, you can use Log Analytics to set up 1 alert for each metric. This would cause each metric to be configured with an alert, and when the VM starts sending data to Log Analytics, the metric is already configured for that alert.|
|Configure virtual machines as they're added     |Use [Azure policies](/azure/governance/policy/overview) to:<br> - [Install an Azure Monitor Agent](agents/azure-monitor-agent-manage.md)<br> - [Create a DCR](essentials/data-collection-rule-create-edit.md) to collect performance data</br> - [Add associations to the DCR](essentials/data-collection-rule-view.md).|
|Configure Kubernetes clusters as they're added     | Use [Azure policies](/azure/governance/policy/overview) to:</br> - [Install an Azure Monitor Agent](agents/azure-monitor-agent-manage.md)</br> - [Create a DCR](essentials/data-collection-rule-create-edit.md) to collect performance data.</br> - [Add associations to the DCR](essentials/data-collection-rule-view.md).|


## Related content
- [Getting started with Azure Monitor](getting-started.md)
- [Data collection in Azure Monitor](essentials/data-collection.md)