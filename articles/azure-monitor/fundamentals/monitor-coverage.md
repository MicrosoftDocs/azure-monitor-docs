---
title: Create data collection rules (DCRs) in Azure Monitor
description: Details on creating data collection rules (DCRs) in Azure Monitor.
ms.topic: how-to
ms.date: 11/19/2024
ms.reviewer: nikeist
ms.custom: references_regions
---

# Monitoring coverage in Azure Monitor

Monitoring Coverage provides a centralized experience to view and enable recommended monitoring settings for common Azure resource types. This feature uses [Azure Advisor](/azure/advisor/advisor-overview) recommendations to help identify gaps in your monitoring posture and quickly enable data collection and alerting at scale with minimal configuration. You can also explore a detailed view of individual resources, see which recommendations apply to each, and review what monitoring settings are currently enabled.


## Key capabilities
- Get an overview of monitoring coverage across common Azure resource types.
- Identify and apply Azure Advisor recommendations at scale to improve your monitoring posture.
- Enable recommended monitoring settings for multiple resources from a single, centralized location.
- View detailed information for each resource, including current monitoring configuration and applicable recommendations.

## How to access
Open the **Monitor** menu in the Azure portal and select **Monitoring Coverage (preview)** in the **Settings** section. Filter the page using standard Azure filters such as Subscriptions, Resource groups, Tags, Locations, and Resource types to scope the view to the resources you want to manage.

## Supported resource types
The preview release of monitoring coverage supports Virtual Machines (VMs) and Azure Kubernetes Service (AKS). Additional resource types will be supported in future updates.

## Overview page
The Overview tab summarizes monitoring coverage across your selected resources. It helps you identify coverage gaps and provides quick actions to enable recommendations. The view distinguishes between:

- Basic monitoring: Standard monitoring that’s enabled by default when the resource is created.
- Enhanced monitoring: Recommended monitoring settings from Microsoft that provide additional observability and can improve your overall monitoring posture. Enabling enhanced monitoring may incur additional costs.

:::image type="content" source="./media/monitor-coverage/overview.png" lightbox="./media/monitor-coverage/overview.png" alt-text="Screenshot of Monitoring coverage overview page.":::

Monitoring Details page
The **Monitoring Details** page provides a more granular view of the monitoring recommendations. View resources as a list or group them by recommendation. If a resource has multiple recommendations, it may appear under multiple recommendation groupings. You can enable individual settings directly from this page if you prefer to configure monitoring for a specific resource instead of enabling at scale.


 The **Monitoring coverage** column provides a summary of enabled recommendations or existing data collection rules.
- 


## Enablement page
The **Enablement** page lists all resources that are included in the operation and allows you to apply the recommended monitoring settings. 

Remove specific resources from the list if you don't want them configured. Select **View details and configure** to open configuration options specific to the resource type, such as choosing a Log Analytics workspace.

:::image type="content" source="./media/monitor-coverage/enablement.png" lightbox="./media/monitor-coverage/enablement.png" alt-text="Screenshot of Monitoring coverage enablement page.":::

After configuring settings, select **Review + Enable** to summarize the changes that will be applied. Once you select **Enable**, it may take 30–60 minutes for monitoring data to start appearing in the selected destination.

> [!NOTE]
> The preview version supports enabling monitoring for up to 100 resources at a time and requires an existing Log Analytics Workspace.




## Next steps

* [Read about the detailed structure of a data collection rule](data-collection-rule-structure.md)
* [Get details on transformations in a data collection rule](data-collection-transformations.md)
