---
title: Log Analytics Agent Migration
description: Learn how to migrate from the Log Analytics agent (MMA/OMS) to Azure Monitor Agent (AMA), including prerequisites, migration tools, and validation steps.
ms.topic: upgrade-and-migration-article
ms.date: 05/08/2026
ai-usage: ai-assisted

# Customer intent: As an Azure administrator, I want to migrate from the Log Analytics agent to Azure Monitor Agent so that I can continue collecting monitoring data using a supported agent.

---

# Migrate from Log Analytics agent to Azure Monitor Agent

[Azure Monitor Agent (AMA)](./agents-overview.md) replaces the Log Analytics agent, also known as Microsoft Monitoring Agent (MMA) and Operations Management Suite (OMS), for Windows and Linux machines in Azure, non-Azure, on-premises, and other cloud environments. Azure Monitor Agent uses [data collection rules (DCRs)](../essentials/data-collection-rule-overview.md) to configure data collection, which is simpler and more flexible than the workspace-based configuration the Log Analytics agent uses.

This article walks you through the end-to-end migration process from the Log Analytics agent to Azure Monitor Agent:

1. Assess your current environment (agents, workspaces, and dependent services).
1. Configure and deploy Azure Monitor Agent with data collection rules.
1. Validate that data collection works correctly.
1. Remove the Log Analytics agent from your machines.

> [!IMPORTANT]
> The Log Analytics agent was [retired on **August 31, 2024**](https://azure.microsoft.com/updates/were-retiring-the-log-analytics-agent-in-azure-monitor-on-31-august-2024/). If you didn't migrate yet, be aware of the following impacts:
>
> - **Data upload:** Cloud ingestion services for the Log Analytics agent are being shut down. After March 2, 2026, data upload from the Log Analytics agent can stop at any time without further notice.
> - **Installation:** You can't install the Log Analytics agent from the Azure portal. Offline installation and extension-based installation still work.
> - **Support:** Microsoft doesn't support the Log Analytics agent.
> - **OS support:** The Log Analytics agent no longer receives new distributions or service packs.
>
> This retirement doesn't apply to the Log Analytics agent connected exclusively to an on-premises System Center Operations Manager (SCOM) installation.

## Prerequisites

- Review the [prerequisites for installing Azure Monitor Agent](./azure-monitor-agent-manage.md#prerequisites).
- For non-Azure and on-premises servers, [install the Azure Arc Connected Machine agent](/azure/azure-arc/servers/agent-overview). The Azure Arc agent makes your on-premises servers visible to Azure as targetable resources at no extra cost.
- Verify that you have the [required permissions to install Azure Monitor Agent](./azure-monitor-agent-requirements.md#permissions) on the target machines.
- Confirm that Azure Monitor Agent supports your data collection requirements. Azure Monitor Agent is generally available (GA) for data collection, and various Azure Monitor features and Azure services use it.

## Migration tools

Two tools help you throughout the migration process:

| Tool | Purpose |
|---|---|
| [Azure Monitor Agent Migration Helper workbook](./azure-monitor-agent-migration-helper-workbook.md) | A workbook-based Azure Monitor solution that helps you inventory agents, audit workspaces, identify dependent services, and track migration progress. |
| [DCR Config Generator](./azure-monitor-agent-migration-data-collection-rule-generator.md) | Converts your existing Log Analytics agent workspace configuration into data collection rules automatically. |

## Assess your current agent deployment

Before you start migrating, inventory your current Log Analytics agent deployment. The [Azure Monitor Agent Migration Helper workbook](./azure-monitor-agent-migration-helper-workbook.md#using-the-ama-workbook) helps you answer these questions:

| Question | Action |
|---|---|
| How many agents do you need to migrate? | Use the Migration Helper workbook to count Log Analytics agents across your environment. |
| Are any agents deployed outside of Azure? | For servers outside Azure (on-premises or other clouds), deploy the [Azure Arc Connected Machine agent](/azure/azure-arc/servers/agent-overview) before installing Azure Monitor Agent. |
| Are you using System Center Operations Manager (SCOM)? | If you plan to continue using SCOM, evaluate [SCOM Managed Instance](/system-center/scom/operations-manager-managed-instance-overview). You can keep the Log Analytics agent on machines that SCOM manages. |
| How are agents deployed today? | If you use automated deployment for the Log Analytics agent, stop deploying it to new servers. This step prevents your migration backlog from growing. |

## Audit workspaces and solutions

Review your Log Analytics workspaces to understand which ones actively receive data and which solutions you configured. Migration is a good opportunity to consolidate unused workspaces.

The [Migration Helper workbook](./azure-monitor-agent-migration-helper-workbook.md#workspaces) shows which workspaces you have, which solutions you implemented, and when you last used each solution. Each solution includes a migration recommendation.

You can also use the [Azure Monitor Workspace Auditing workbook](./azure-monitor-agent-migration-helper-workbook.md#workspace-auditing-workbook) for detailed workspace analysis. To set up this workbook, copy it from the [GitHub repository](https://github.com/microsoft/AzureMonitorCommunity/blob/master/Azure%20Services/Log%20Analytics%20workspaces/Workbooks/Workspace%20Audit.json) and import it into your Log Analytics workspace. This workbook shows:

- All data sources sending data to the workspace.
- Agents sending heartbeats to the workspace.
- Resources sending data to the workspace.
- Application Insights resources sending data to the workspace.

## Identify dependent services

Before migrating, determine which services depend on the Log Analytics agent and plan their migration path.

| Service | Migration action |
|---|---|
| **Azure Automation Update Management** | Migrate to [Azure Update Manager](/azure/update-manager/guidance-migration-automation-update-management-azure-update-manager). Azure Update Manager has its own agent, independent of Azure Monitor Agent. Microsoft deprecated Update Management in August 2024. The [Migration Helper workbook](./azure-monitor-agent-migration-helper-workbook.md#automation-update-management) shows which machines use Update Management. |
| **Change Tracking and Inventory** | Create a data collection rule for the Azure Monitor Agent change tracking solution. For more information, see [Manage change tracking and inventory using Azure Monitor Agent](/azure/automation/change-tracking/manage-change-tracking-monitoring-agent). |
| **Microsoft Defender for Cloud** | If you use Defender for Servers Plan 2, change your agent deployment in Defender for Cloud from the Log Analytics agent to agentless scanning. If you use Defender for Cloud to collect security events, create a custom data collection rule to collect those events. |
| **Microsoft Sentinel** | Solutions that previously used the Log Analytics agent now support Azure Monitor Agent. Update these solutions to use the latest versions. |

## Configure data collection rules and deploy Azure Monitor Agent

Follow these steps to set up Azure Monitor Agent with data collection rules:

1. **Identify a pilot group.** Select a small group of servers to validate data collection before deploying at scale.

1. **Generate data collection rules.** Use the [DCR Config Generator](./azure-monitor-agent-migration-data-collection-rule-generator.md) to convert your existing workspace-based data collection configuration into data collection rules. Deploy the generated rules to your pilot group.

1. **Migrate VM insights.** If you use VM insights (Azure Monitor for Virtual Machines), [migrate VM insights to Azure Monitor Agent](../vm/vminsights-migrate-agent.md) for the pilot group.

1. **Disable Log Analytics agent data collection during testing.** To avoid double ingestion, remove the workspace configurations for the Log Analytics agent on pilot servers without uninstalling the Log Analytics agent. For more information, see [Configure data sources for the Log Analytics agent](/azure/azure-monitor/agents/agent-data-sources#configure-data-sources).

1. **Deploy at scale by using Azure Policy.** Use built-in policies to deploy Azure Monitor Agent extensions and data collection rule associations at scale. Azure Policy also automatically deploys to new machines. For more information, see [Use Azure Policy to install and manage the Azure Monitor Agent](./azure-monitor-agent-policy.md).

## Validate Azure Monitor Agent data collection

After deploying Azure Monitor Agent to your pilot group, verify that data collection works correctly before expanding the deployment:

1. **Compare ingested data.** Run KQL queries against your Log Analytics workspace to compare the data ingested by the Log Analytics agent with data ingested by Azure Monitor Agent. For example, query the `Heartbeat` table and filter by `Category` to confirm Azure Monitor Agent heartbeats are arriving.

1. **Check for data gaps.** Verify that Azure Monitor Agent collects all expected data types (performance counters, Windows events, Syslog, custom logs). Compare record counts and data types between the two agents over the same time period.

1. **Validate dependent services.** Confirm that services like Microsoft Defender for Cloud, Microsoft Sentinel, and Change Tracking continue to function correctly with Azure Monitor Agent.

After validation succeeds, expand the Azure Monitor Agent deployment to the rest of your environment.

## Remove the Log Analytics agent

After you validate that Azure Monitor Agent is collecting data correctly across your environment, remove the Log Analytics agent to avoid duplicate data collection.

- **At scale:** Use the [MMA Discovery and Removal tool](./azure-monitor-agent-mma-removal-tool.md?tabs=single-tenant%2Cdiscovery) to remove the Log Analytics agent from machines across your environment.
- **SCOM exception:** If you use System Center Operations Manager, keep the Log Analytics agent on machines managed by SCOM. The [Operations Manager Admin Management Pack](https://github.com/thekevinholman/SCOM.Management) helps you remove workspace configurations at scale while keeping the SCOM Management Group configuration intact.

## Known migration issues

- **IIS logs:** When you enable IIS log collection, Azure Monitor Agent might not populate the `sSiteName` column of the `W3CIISLog` table. The Log Analytics agent collects this field by default. To collect `sSiteName` with Azure Monitor Agent, enable the **Service Name (s-sitename)** field in W3C logging for IIS. For steps, see [Select W3C fields to log](/iis/manage/provisioning-and-managing-iis/configure-logging-in-iis#select-w3c-fields-to-log).
- **SQL Assessment Solution:** This solution is part of SQL best practice assessment. The deployment policies require one Log Analytics workspace per subscription, which differs from the recommended Azure Monitor Agent deployment approach.

## Related content

- [Azure Monitor Agent migration helper workbook](./azure-monitor-agent-migration-helper-workbook.md)
- [DCR Config Generator](./azure-monitor-agent-migration-data-collection-rule-generator.md)
- [MMA Discovery and Removal tool](./azure-monitor-agent-mma-removal-tool.md?tabs=single-tenant%2Cdiscovery)
