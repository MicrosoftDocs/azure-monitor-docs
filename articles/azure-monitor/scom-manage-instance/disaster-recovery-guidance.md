---
ms.assetid: 
title: Disaster Recovery guidance – Azure Monitor SCOM Managed Instance
description: This article provides information to review in advance of application deployment.
author: jyothisuri
ms.author: jsuri
ms.date: 09/08/2025
ms.update-cycle: 1825-days
ms.custom: references_regions, engagement-fy24
ms.service: azure-monitor
ms.subservice: operations-manager-managed-instance
ms.topic: how-to
---

# Disaster Recovery guidance – Azure Monitor SCOM Managed Instance

[!INCLUDE [retirement-banner.md](includes/retirement-banner.md)]

Azure Monitor SCOM Managed Instance provides an industry leading high availability monitoring service. It also provides business continuity capabilities that you can perform for quick disaster recovery in the event of a regional outage. This article provides information to review in advance of application deployment.

Though we continuously strive to provide high availability, there are times when the Azure Monitor SCOM Managed Instance service incurs outages that cause the unavailability of your monitored data and thus impacts your observability service. When our service monitoring detects issues that cause widespread connectivity errors, failures, or performance issues, the service declares an outage to keep you informed.

## Service outage

In the event of an Azure Monitor SCOM Managed Instance service outage, you can find additional details related to the outage in the following places: 

- **Azure portal banner**

     If your subscription is identified as impacted, there's an outage alert of a Service Issue in your Azure portal Notifications:

     :::image type="notifications" source="media/disaster-recovery-guidance/notifications.png" alt-text="Screenshot that shows notifications screen.":::

- **Help + support or Support + troubleshooting**

     When you create a support ticket from [Help + support](https://ms.portal.azure.com/#view/Microsoft_Azure_Support/HelpAndSupportBlade/~/overview) or Support + troubleshooting, there's information about any issues impacting your resources. Select **View outage details** for more information and a summary of impact. There's also an alert in the New support request page. 

     :::image type="support" source="media/disaster-recovery-guidance/support.png" alt-text="Screenshot that shows support screen.":::

- **Service health**

     The Service Health page in the Azure portal contains information about Azure data center status globally. Search for **Service health** in the search bar in the Azure portal, then view Service issues in the Active events category. You can also view the health of individual resources in the Resource health page of any resource under the Help menu. The following is sample screenshot of the Service Health page, with information about an active service issue in Southeast Asia: 
     
     :::image type="service health" source="media/disaster-recovery-guidance/service-health.png" alt-text="Screenshot that shows service health.":::

## Scope of regional redundancy 

Below are the crucial artifacts of SCOM Managed Instance that needs to be configured and acted upon during regional outage: 
- Monitoring Agents (VM Extensions) 
- Management Packs 
- Instance configuration details like Log Analytics integration, Instance Version, Alert Actions, Workbooks, etc. 
- Historical Monitored Data (Azure SQL Database) 

## When to initiate disaster recovery during an outage

In the event of a service outage impacting application resources, consider the following courses of action: 
- The Azure teams work diligently to restore service availability as quickly as possible but depending on the root cause it can sometimes take hours. If your application can tolerate significant downtime, you can just wait for recovery to complete. In this case, no action on your part is required. View the health of individual resources in the Resource health page of any resource under the Help menu. Refer to the Resource health page for updates and the latest information regarding an outage. After the recovery of the region, your application's availability is restored. 
- Recovery to another Azure region can require changing Monitoring Agent connection to secondary SCOM Managed Instance, restoring SQL Database and redirecting users to alternate dashboards and workbooks. Therefore, disaster recovery should be performed only when the outage duration approaches your application's recovery time objective (RTO). Depending on your application tolerance to downtime and possible business liability, you can decide if you want to wait for service to recover or initiate disaster recovery yourself. 

## Set up Geo redundancy

During region outage (disaster), you are expected to switch over to an alternate Azure Monitor SCOM Managed Instance for business continuity.

:::image type="Geo redundancy before disaster" source="media/disaster-recovery-guidance/before-disaster.png" alt-text="Screenshot that shows Geo redundancy before disaster.":::

:::image type="Geo redundancy after disaster" source="media/disaster-recovery-guidance/after-disaster.png" alt-text="Screenshot that shows Geo redundancy after disaster.":::

Follow these steps to set up the alternate Azure Monitor SCOM Managed Instance in a region of your choice.  

1. Set up a SCOM Managed Instance in an alternate region by following [Tutorial - Create an instance of Azure Monitor SCOM Managed Instance](/azure/azure-monitor/scom-manage-instance/tutorial-create-scom-managed-instance). 
2. **Data Replication**: Set up SQL MI failover group to ensure business continuity and disaster recovery for Operations database (DB) and Data Warehouse (DW) used by SCOM Managed Instance. This ensures continuous replication of these resources to an alternate region. Follow the detailed instructions in [Configure a failover group for SQL Managed Instance](/azure/azure-sql/managed-instance/failover-group-configure-sql-mi?view=azuresql&source=recommendations&tabs=azure-portal%2Cazure-portal-modify%2Cazure-powershell-manage).  
3. **Configuration replication**: Replicate monitoring configurations such as Management packs, Log Analytics Integrations, Grafana dashboards, Workbooks to create a replica of primary SCOM Managed Instance. 
4. **Continuous replication**: Ensure the changes done to primary Azure Monitor SCOM Managed Instance are replicated/synced to secondary Azure Monitor SCOM Managed Instance frequently. Changes include (but not limited to) Management Pack overrides, instance patch updates. 

## Outage recovery guidance 

If the Azure Monitor SCOM Managed Instance outage in a region hasn't been mitigated for an extended period of time and is affecting your application's service-level agreement (SLA), consider the following steps: 

### Forced Failover (data loss) to geo-replicated secondary instance 

To initiate a forced failover, use Azure portal and PowerShell and follow these steps:

1. Deboard agents from SCOM Managed Instance one through Azure portal at scale. 
     1. On Azure portal, navigate to primary Azure Monitor SCOM Managed Instance > **Monitored resources**, select all the VMs, and then select **Remove**.
     2. Alternatively, monitored resources can also be exported and deboarded from SCOM Managed Instance using Cloud Shell automation scripts. 
         1. Use the [Export-SCOMMIMonitoredResources.ps1](https://go.microsoft.com/fwlink/?linkid=2300749) script to export the list of monitored VMs to a CSV file. 
         2. Run the [Deboard-SCOMMIMonitoredResources.ps1](https://go.microsoft.com/fwlink/?linkid=2300551) script to deboard the monitored VMs from SCOM Managed Instance. This script utilizes the CSV file generated by export script.  
2. Onboard agent to SCOM Managed Instance two through Azure portal at scale. 
     1. On Azure portal, navigate to secondary Azure Monitor SCOM Managed Instance > **Monitored resources**, select **New Monitored resource**. Select all the relevant VMs and add. 
     2. Alternatively, monitored resources can also be onboarded to SCOM Managed Instance using Cloud Shell automation scripts. 
         1. Run the [Onboard-SCOMMIMonitoredResources.ps1](https://go.microsoft.com/fwlink/?linkid=2300638) script to onboard the monitored VMs to SCOM Managed Instance. This script utilizes the CSV file generated by export script. 
3. The secondary Azure Monitor SCOM Managed Instance starts monitoring freshly. 

[Optional] To retrieve historical monitored data, restore databases (Operations and Data Warehouse) by following [Outage Recovery guidance](/azure/azure-sql/managed-instance/disaster-recovery-guidance?view=azuresql#outage-recovery-guidance). The restored SQL databases can be used only for investigation (query) purposes only. 

## Considerations

Before you configure the Geo redundancy of Azure Monitor SCOM Managed Instance, ensure that you are aware of the following considerations: 

- Historical monitored data is accessible only through dashboarding tools (such as Grafana and Power BI) and SQL management studio. Operations console and Azure portal can't access the data from restored SQL databases.
- **Cost for dual set up**: As you are setting up secondary Azure Monitor SCOM Managed Instance with its own SQL managed instance and replicating monitoring configurations such as Log Analytics integration, workbooks, dashboards and Management Packs, you incur compute cost for this replication.
- To optimize costs for ensuring business continuity and disaster recovery with SQL MI, the [Backup and Restore](/azure/azure-sql/managed-instance/automated-backups-change-settings?view=azuresql&tabs=azure-portal) approach can be considered as an alternative to failover groups. This method involves continuously backing up SQL MI data to a storage account and restoring the database to a new SQL MI server from the backup in the event of a disaster. However, this approach results in a higher Recovery Time Objective (RTO), as restoring a database from a backup typically takes longer compared to using failover groups.
