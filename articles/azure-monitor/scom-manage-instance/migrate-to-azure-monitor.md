---
title: Migrate from Azure Monitor SCOM Managed Instance to Azure Monitor Data Collection Rules
description: This article explains how to migrate from Azure Monitor SCOM Managed Instance to Azure Monitor Data Collection Rules.
ms.topic: conceptual
author: jyothisuri
ms.author: jsuri
ms.date: 09/03/2025
ms.service: azure-monitor
ms.subservice: operations-manager-managed-instance
---

# Migrate from Azure Monitor SCOM Managed Instance to Azure Monitor Data Collection Rules

Organizations embracing cloud-native architectures, leveraging Azure for infrastructure, or seeking to consolidate monitoring into a single pane of glass can benefit from Azure Monitor and its Data collection rules driven data collection.

This article explains how to migrate from Azure Monitor SCOM Managed Instance to Azure Monitor Data Collection Rules.

## Data Collection Rules (DCRs)

[Data Collection Rules](/azure/azure-monitor/data-collection/data-collection-rule-overview) are at the heart of Azure Monitor's modern data ingestion framework. DCRs define what telemetry to collect from which resources, how to transform or filter it, and where it must be sent (For example, Log Analytics workspace, storage, and event hubs).

## Limitations

- The potential need to re-author complex management pack logic as custom queries and DCRs.
- Retraining staff to be more familiar with Azure Monitor terminology and Azure models as compared to on-premises models.
- Review the cost implications of moving away from System Center Operations Manager on-premises licensing to Pay-As-You-Go Azure and Azure Monitor pricing.

## Best practices for a smooth migration

- **Plan thoroughly**: Start with a comprehensive inventory and gap analysis of your SCOM Manage Instance environment versus the target platform (o\On-premises or Data collection rule based).
- **Pilot first**: Conduct a pilot migration for a subset of resources to validate your migration approach and identify issues ahead of full-scale rollout.
- **Leverage Microsoft resources**: Microsoft provides migration guides, reference architectures, and support channels to assist with your transition.
- **Plan for training**: Ensure your IT team is equipped with skills for managing the chosen platform, especially if moving to Data collection rules and Azure Monitor.

## Migrate to Azure Monitor DCRs

To migrate to Azure Monitor DCRs, follow these steps:

1. **Assess Current Monitoring Requirements**
   
   Manually determine an inventory of all management packs, monitored agents, customizations, and integrations. Use PowerShell scripts or the System Center Operations Manager console to export configurations. You can export the Management packs into a list using the guide [here](/system-center/scom/manage-mp-import-remove-delete?view=sc-om-2025&preserve-view=true).

2. **Map to Azure Monitor Equivalents**

   Match SCOM Managed Instance features to Azure Monitor components such as metrics, logs, alerts, workbooks. Some System Center Operations Manager features may not have direct equivalents; plan for workarounds or enhancements. Follow the guidance on [how to determine equivalent capabilities](/azure/azure-monitor/fundamentals/overview).

3. **Author Data Collection Rules (DCRs)**

   Map management packs to DCRs. 

4. **Deploy Azure Monitor Agent (AMA)**

   Install AMA on target resources such as Virtual machines and servers. Configure it to use the DCRs created. Follow the guidance on [how to deploy Azure Monitor agent](/azure/azure-monitor/agents/azure-monitor-agent-overview).

5. **Migrate Alerts**

   Recreate SCOM Managed Instance alerts using Azure Monitor's alerting framework (metric alerts, log query alerts). Follow the guidance on how to [Migrate alerts](/azure/azure-monitor/fundamentals/data-platform).

6. **Build Dashboards and Results**

   Use Azure Workbooks to visualize health, performance, and alerting. Replicate System Center Operations Manager dashboards where possible. Follow the guidance on [how to visualize data](/azure/azure-monitor/visualize/best-practices-visualize).

7. **Reconnect Integrations**

   Map the alert rules in System Center Operations Manager on-premises to Azure Monitor alert rules, along with all ITSM and other integrations. Follow the guidance on [how to Map the alert rules](/azure/azure-monitor/alerts/alerts-common-schema).

8. **Decommission SCOM MI**

   Once the on-premises setup is stable, delete SCOM Managed Instance resources to avoid unnecessary costs. Deleting a SCOM Managed Instance is a matter of deleting the Azure resource groups where the SCOM Managed Instance resources are deployed. For any issues, see [frequently asked questions](/azure/azure-monitor/scom-manage-instance/scom-managed-instance-faq#what-is-the-procedure-to-delete-an-instance-).

