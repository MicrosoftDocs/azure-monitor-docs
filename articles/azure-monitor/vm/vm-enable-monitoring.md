---
title: Enable VM Insights
description: Describes different methods for enabling VM Insights on virtual machines and virtual machine scale sets.
ms.topic: how-to
ms.reviewer: xpathak
ms.date: 02/17/2026
ms.custom: references_regions

---

# Enable VM monitoring

This article provides details on enabling monitoring for a virtual machine in Azure Monitor using different methods.

> [!NOTE]
> To quickly enable monitoring for a single virtual machine using the Azure portal, see [Tutorial: Enable enhanced monitoring for an Azure virtual machine](./tutorial-vm-enable-monitoring.md).


## Prerequisites

- [Azure Monitor workspace](../logs/quick-create-workspace.md) if you enable OpenTelemetry metrics (preview). 
- [Log Analytics workspace](../logs/quick-create-workspace.md) if you enable log-based metrics. 
- Permissions to create a data collection rule (DCR) and associate it with the Azure Monitor agent. See [Data Collection Rule permissions](../essentials/data-collection-rule-create-edit.md#permissions).
- See [Azure Monitor agent supported operating systems and environments](../agents/azure-monitor-agent-supported-operating-systems.md) to verify that your operating system is supported by Azure Monitor agent. 
- See [Manage the Azure Monitor agent](../agents/azure-monitor-agent-manage.md#prerequisites) for prerequisites related to Azure Monitor agent.
- See [Azure Monitor agent network configuration](../agents/azure-monitor-agent-network-configuration.md) for network requirements for the Azure Monitor agent.

## Enable at scale
There are three fundamental steps to enable monitoring of virtual machines in Azure Monitor:

1. Install the [Azure Monitor agent](../agents/azure-monitor-agent-overview.md) on each virtual machine.
1. Create [data collection rule (DCR)](../data-collection/data-collection-rule-overview.md).
1. Create an [association](../data-collection/data-collection-rule-associations.md) between the DCR with the agent on each virtual machine.


## Deploy agents
The [Azure Monitor agent](../agents/azure-monitor-agent-overview.md) is responsible for collecting data from the guest operating system and delivering it to Azure Monitor. There are multiple methods to install the agent on your machines as described in [Installation options](../agents/azure-monitor-agent-manage.md#installation-options).

## Create data collection rules (DCRs)

- Need a DCR in each region

| Experience | Description |
|:---|:---|
| Otel metrics (preview) | This enables the OTel metrics experience for the VM in the Azure portal. It requires the `Microsoft-OtelPerfMetrics` stream. The default DCR that's created when you enable enhanced monitoring in the Azure portal includes a predefined set of metrics that are collected. You can modify this list by modifying the DCR.<br><br>When you enable enhanced monitoring in the Azure portal, a DCR named `MSVMOtel-<region>-<machine-name>` is created. |
| Logs-based metrics (classic) | This enables the classic logs-based experience for the VM in the Azure portal. It also identifies the VM as monitored and includes its metrics in the multi-VM view. It requires the `Microsoft-InsightsMetrics` data source. This collects a predefined set of metrics that can't be modified. Retrieve a DCR that you can use at [VM insights data collection rule templates](https://github.com/Azure/AzureMonitorForVMs-ArmTemplates/releases/download/vmi_ama_ga/DeployDcr.zip).<br><br>When you enable enhanced monitoring in the Azure portal, a DCR named `MSVMI-<region>-<WorkspaceName>` is created. | |
| Logs and additional metrics | Create additional DCRs to collect logs from your clients and also to collect additional metrics. |


> [!NOTE]
> If you're only using log-based metrics, you can also download and install the [VM insights data collection rule templates](https://github.com/Azure/AzureMonitorForVMs-ArmTemplates/releases/download/vmi_ama_ga/DeployDcr.zip). The following table describes the templates available. See [Deploy templates](#deploy-arm-templates) if you aren't familiar with methods to deploy ARM templates.
>
>   | Folder  | Description |
>   |:---|:---|
>   | DeployDcr\\<br>PerfOnlyDcr | Enable only Performance experience of VM Insights. |
>   | DeployDcr\\<br>PerfAndMapDcr | Enable both Performance and Map experience of VM Insights. This feature has been deprecated. See [VM Insights Map and Dependency Agent retirement guidance](./vminsights-maps-retirement.md). |



<details>
<summary>OTel metrics</summary>

```json
{
    "properties": {
        "dataSources": {
            "performanceCountersOTel": [
                {
                    "streams": [
                        "Microsoft-OtelPerfMetrics"
                    ],
                    "samplingFrequencyInSeconds": 60,
                    "counterSpecifiers": [
                        "system.filesystem.usage",
                        "system.disk.io",
                        "system.disk.operation_time",
                        "system.disk.operations",
                        "system.memory.usage",
                        "system.network.io",
                        "system.cpu.time",
                        "system.uptime",
                        "system.network.dropped",
                        "system.network.errors"
                    ],
                    "name": "OtelDataSource"
                }
            ]
        },
        "destinations": {
            "monitoringAccounts": [
                {
                    "accountResourceId": "/subscriptions/my-subscription/resourcegroups/my-resource-group/providers/microsoft.monitor/accounts/my-workspace",
                    "name": "MonitoringAccountDestination"
                }
            ]
        },
        "dataFlows": [
            {
                "streams": [
                    "Microsoft-OtelPerfMetrics"
                ],
                "destinations": [
                    "MonitoringAccountDestination"
                ]
            }
        ]
    }
}
```

</details>


<details>
<summary>VM insights</summary>

```json
{
    "properties": {
        "mode": "Incremental",
        "template": {
            "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
            "contentVersion": "1.0.0.0",
            "parameters": {},
            "variables": {},
            "resources": [
                {
                    "type": "Microsoft.Insights/dataCollectionRules",
                    "apiVersion": "2021-04-01",
                    "name": "[concat('MSVMI-', 'Perf-',parameters('userGivenDcrName'))]",
                    "location": "[parameters('WorkspaceLocation')]",
                    "properties": {
                        "description": "Data collection rule for VM Insights.",
                        "dataSources": {
                            "performanceCounters": [
                                {
                                    "name": "VMInsightsPerfCounters",
                                    "streams": [
                                        "Microsoft-InsightsMetrics"
                                    ],
                                    "scheduledTransferPeriod": "PT1M",
                                    "samplingFrequencyInSeconds": 60,
                                    "counterSpecifiers": [
                                        "\\VmInsights\\DetailedMetrics"
                                    ]
                                }
                            ]
                        },
                        "destinations": {
                            "logAnalytics": [
                                {
                                    "workspaceResourceId": "[parameters('WorkspaceResourceId')]",
                                    "name": "VMInsightsPerf-Logs-Dest"
                                }
                            ]
                        },
                        "dataFlows": [
                            {
                                "streams": [
                                    "Microsoft-InsightsMetrics"
                                ],
                                "destinations": [
                                    "VMInsightsPerf-Logs-Dest"
                                ]
                            }
                        ]
                    }
                }
            ]
        }
    }
}
```

</details>



  
## Associate DCR with agents
The final step in enabling VM insights is to associate the DCR with the Azure Monitor agent. Use the template below which comes from [Manage data collection rule associations in Azure Monitor](../essentials/data-collection-rule-associations.md#create-new-association). To enable on multiple machines, you need to create an association using this template for each one. See [Deploy templates](#deploy-arm-templates) if you aren't familiar with methods to deploy ARM templates.


### Enable VM insights for multiple VMs using PowerShell script

This section describes how to enable [VM insights](./vminsights-overview.md) using a PowerShell script that can enable multiple VMs. This process uses a script that installs VM extensions for Azure Monitoring agent (AMA) and, if necessary, the Dependency Agent to enable VM Insights. 

Before you use this script, you must create a VM insights DCR using the details above in [VM insights DCR](#vm-insights-dcr).

## PowerShell script
A PowerShell script is available to enable VM insights for multiple virtual machines or virtual machine scale sets. This script only enables log-based metrics. If you want to enable OpenTelemetry-based metrics, you can use the Azure portal or ARM template methods described above.

Use the PowerShell script [Install-VMInsights.ps1](https://www.powershellgallery.com/packages/Install-VMInsights) to enable VM insights for multiple VMs or virtual machine scale sets. This script iterates through the machines according to the parameters that you specify. The script can be used to enable VM insights for the following. Each of these parameters accepts wildcards.

- Every virtual machine and virtual machine scale set in your subscription.
- The scoped resource groups specified by `-ResourceGroup`.
- A VM or virtual machine scale set specified by `-Name`.

Verify that you're using Az PowerShell module version 1.0.0 or later with `Enable-AzureRM` compatibility aliases enabled. Run `Get-Module -ListAvailable Az` to find the version. To upgrade, see [Install Azure PowerShell module](/powershell/azure/install-azure-powershell). If you're running PowerShell locally, run `Connect-AzAccount` to create a connection with Azure.

For a list of the script's argument details and example usage, run `Get-Help`.

```powershell
Get-Help Install-VMInsights.ps1 -Detailed
```

When you enable VM insights using Azure Monitor Agent, the script associates a Data Collection Rule (DCR) and a User Assigned Managed Identity (UAMI) to the VM/Virtual Machine Scale Set. The UAMI settings are passed to the Azure Monitor Agent extension.   

```powershell
Install-VMInsights.ps1 -SubscriptionId <SubscriptionId> `
[-ResourceGroup <ResourceGroup>] `
[-ProcessAndDependencies ] `
[-Name <VM or Virtual Machine Scale Set name>] `
-DcrResourceId <DataCollectionRuleResourceId> `
-UserAssignedManagedIdentityName <UserAssignedIdentityName> `
-UserAssignedManagedIdentityResourceGroup <UserAssignedIdentityResourceGroup> 

```

Required Arguments:   
+  `-SubscriptionId <String>`  Azure subscription ID.  
+  `-DcrResourceId <String> `  Data Collection Rule (DCR) Azure resource ID identifier. You can specify DCRs from different subscriptions to the VMs or virtual machine scale sets being enabled with Vm-Insights.
+  `-UserAssignedManagedIdentityResourceGroup <String> `  Name of User Assigned Managed Identity (UAMI) resource group.   
+  `-UserAssignedManagedIdentityName <String> `  Name of User Assigned Managed Identity (UAMI).  


Optional Arguments:   
+ `-ProcessAndDependencies` Set this flag to onboard the Dependency Agent with Azure Monitoring Agent (AMA) settings.  If not specified, only the Azure Monitoring Agent (AMA)  is onboarded.  
+ `-Name <String>` Name of the VM or Virtual Machine Scale Set to be onboarded. If not specified, all VMs and Virtual Machine Scale Set in the subscription or resource group are onboarded. Use wildcards to specify multiple VMs or Virtual Machine Scale Sets.
+ `-ResourceGroup <String>` Name of the resource group containing the VM or Virtual Machine Scale Set to be onboarded. If not specified, all VMs and Virtual Machine Scale Set in the subscription are onboarded. Use wildcards to specify multiple resource groups.
+ `-PolicyAssignmentName <String>` Only include VMs associated with this policy.   When the PolicyAssignmentName parameter is specified, the VMs part of the parameter SubscriptionId are considered. 
+ `-TriggerVmssManualVMUpdate [<SwitchParameter>]` Trigger the update of VM instances in a scale set whose upgrade policy is set to Manual. 
+ `-WhatIf [<SwitchParameter>]` Get info about expected effect of the commands in the script.         
+ `-Confirm [<SwitchParameter>]` Confirm each action in the script. 
+ `-Approve [<SwitchParameter>]` Provide the approval for the installation to start with no confirmation prompt for the listed VM's/Virtual Machine Scale Sets. 
 
The script supports wildcards for `-Name` and `-ResourceGroup`. For example, `-Name vm*` enables VM insights for all VMs and Virtual Machine Scale Sets that start with "vm". For more information, see [Wildcards in Windows PowerShell](/powershell/module/microsoft.powershell.core/about/about_wildcards). 

Example:

```powershell
Install-VMInsights.ps1 -SubscriptionId 12345678-abcd-abcd-1234-12345678 `
-ResourceGroup rg-AMAPowershell  `
-ProcessAndDependencies  `
-Name vmAMAPowershellWindows `
-DcrResourceId /subscriptions/12345678-abcd-abcd-1234-12345678/resourceGroups/rg-AMAPowershell/providers/Microsoft.Insights/dataCollectionRules/MSVMI-ama-vmi-default-dcr `
-UserAssignedManagedIdentityName miamatest1  `
-UserAssignedManagedIdentityResourceGroup amapowershell
```

Check your machines in Azure portal to see if the extensions are installed or use the following command:

```powershell
az vm extension list --resource-group <resource group> --vm-name <VM name>  -o table 
```

---

## Enable network isolation

There are two methods for network isolation that VM insights supports as described in the following table.

| Method | Description |
|:---|:---|
| Private link | See [Enable network isolation for Azure Monitor Agent by using Private Link](../agents/azure-monitor-agent-private-link.md). |
| Network security perimeter | See [Configure Azure Monitor with Network Security Perimeter](../fundamentals/network-security-perimeter.md). |


## Next steps

To learn how to use the Performance monitoring feature, see [View VM Insights Performance](../vm/vminsights-performance.md). To view discovered application dependencies, see [View VM Insights Map](../vm/vminsights-maps.md).
