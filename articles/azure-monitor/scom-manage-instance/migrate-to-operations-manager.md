---
title: Migrate from Azure Monitor SCOM Managed Instance to System Center Operations Manager
description: This article explains how to migrate from Azure Monitor SCOM Managed Instance to System Center Operations Manager.
ms.topic: conceptual
author: jyothisuri
ms.author: jsuri
ms.date: 09/30/2025
ms.service: azure-monitor
ms.subservice: operations-manager-managed-instance
---

# Migrate from Azure Monitor SCOM Managed Instance to System Center Operations Manager

This article explains how to migrate from Azure Monitor SCOM Managed Instance to System Center Operations Manager.

## Limitations

On-premises System Center Operations Manager requires ongoing maintenance such as patching, upgrades, backups, and capacity planning.

## Migrate to System Center Operations Manager (on-premises)

Migration to System Center Operations Manager is ideal for organizations with:

- Complex monitoring needs
- Regulatory or data residency requirements
- Legacy workloads not suited for cloud migration

To migrate to System Center Operations Manager, follow these steps:

1. **Assess current SCOM Managed Instance environment**

   Manually determine an inventory of all management packs, monitored agents, customizations, and integrations. Use PowerShell scripts or the System Center Operations Manager console to export configurations. You can export the management packs into a list using the guide [here](/system-center/scom/manage-mp-import-remove-delete?view=sc-om-2025&preserve-view=true).

2. **Prepare infrastructure for On-premises deployment**

   Based on your requirements and current SCOM Managed Instance infrastructure, plan your System Center Operations Manager on-premises deployment using the guidance [here](/system-center/scom/manage-mp-import-remove-delete?view=sc-om-2025&preserve-view=true).

3. **Install System Center Operations Manager components**

   Deploy management servers, SQL Server databases, web console, and reporting services. Follow this guidance on installation [here](/system-center/scom/deploy-overview?view=sc-om-2025&preserve-view=true).

4. **Import or Re-author management packs**

   Import existing management packs or re-author them if compatibility issues arise. Ensure to test management packs in a staging environment before deploying them in a production environment. Follow this guidance on [how to import management packs](/system-center/scom/manage-mp-import-remove-delete?view=sc-om-2025&preserve-view=true).

5. **Reconfigure agents**

   Point the existing SCOM Managed Instance agents to the System Center Operations Manager on-premises management servers. This may involve redeployment or updating agent settings via PowerShell. Follow this guidance on [how to upgrade agents in a parallel deployment](/system-center/scom/deploy-upgrade-agents-parallel?view=sc-om-2025&preserve-view=true).

6. **Re-establish integrations**

   Reconnect integrations such as ticketing systems, dashboards, and automation workflows. Validate connectivity and data flow. Follow this guidance on [Monitoring scenarios](/system-center/scom/manage-monitoring-scenarios?view=sc-om-2025&preserve-view=true).

7. **Test and validate setup**

   Perform end-to-end testing of alerts, dashboards, and reports. Confirm that monitoring logic behaves as expected. Include application owners and IT stakeholders in validation. Use synthetic transactions where applicable.

8. **Decommission SCOM Managed Instance**

   Once the on-premises setup is stable, delete SCOM Managed Instance resources to avoid unnecessary costs. Deleting a SCOM Managed Instance is nothing but deleting the Azure resource groups where the SCOM Managed Instance resources are deployed. For any issues, see [frequently asked questions](/azure/azure-monitor/scom-manage-instance/scom-managed-instance-faq#what-is-the-procedure-to-delete-an-instance-).
