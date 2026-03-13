---
title: Enable VM monitoring in Azure Monitor
description: Learn how to enable monitoring for virtual machines and virtual machine scale sets at scale using Azure CLI, PowerShell, ARM templates, and Bicep.
ms.topic: how-to
ms.reviewer: xpathak
ms.date: 03/08/2026
ms.custom: references_regions, devx-track-azurecli, devx-track-azurepowershell, devx-track-arm-template, devx-track-bicep

---

# Enable VM monitoring in Azure Monitor

This article describes how to enable monitoring for virtual machines, virtual machine scale sets, and Arc-enabled servers at scale using command line tools that allow you to use infrastructure as code (IaC) tools and automation methods. These methods allow you to consistently deploy monitoring across your VM fleet and integrate monitoring configuration into your DevOps pipelines.

> [!NOTE]
> To enable monitoring for a single virtual machine using the Azure portal, see [Tutorial: Enable enhanced monitoring for an Azure virtual machine](./tutorial-vm-enable-monitoring.md). To enable monitoring for a virtual machine scale set using the Azure portal, see [Tutorial: Enable monitoring for an Azure virtual machine scale set](./tutorial-scale-set-enable-monitoring.md).

## Supported machines

- Azure virtual machines
- Azure Virtual Machine Scale Sets
- Arc-enabled servers

For a list of supported operating systems, see [Azure Monitor agent supported operating systems](../agents/azure-monitor-agent-supported-operating-systems.md).


## Prerequisites

- **Azure Monitor workspace** if you enable OpenTelemetry metrics (preview). See [Create an Azure Monitor workspace](../metrics/azure-monitor-workspace-manage.md#create-an-azure-monitor-workspace).
- **Log Analytics workspace** if you enable logs-based metrics or collect logs. See [Create a Log Analytics workspace](../logs/quick-create-workspace.md).
- **Permissions** to create data collection rules (DCRs) and associate them with VMs. See [Data collection rule permissions](../data-collection/data-collection-rule-create-edit.md#permissions).
- **Azure Connected Machine agent** if you're monitoring virtual machines hosted outside of Azure. You must first install the Connected Machine agent on your so that the machine can be managed through Azure Arc-enabled servers before you can install the Azure Monitor agent and enable monitoring. See [Connect a machine to Arc-enabled servers](/azure/azure-arc/servers/quick-enable-hybrid-vm).


## Overview

Enabling data collection from a VM by Azure Monitor involves three steps that can each be completed using different methods. When you enable enhanced monitoring or create a DCR in the Azure portal, each of these steps is completed for you automatically. When enabling at scale, you can automate each step using methods described in this article.

| Step | Description |
|:---|:---|
| [Install the Azure Monitor agent](#install-azure-monitor-agent) | The agent needs to be installed on each virtual machine to be monitored. This only needs to be completed once since the agent can use any number of DCRs that each collect different data. |
| [Create data collection rules (DCRs)](#create-data-collection-rules) | Each DCR specifies data to collect and where to send it. You can create your own DCRs or use existing ones depending on your requirements. You need to understand the different types of DCRs and their purposes to determine which ones to use. |
| [Associate DCRs with VMs](#associate-dcrs-with-vms) | When you create an association between a VM and a DCR, the agent downloads that DCR and begins data collection. Create associations with multiple DCRs for the agent collect different types of data. Remove associations to stop data collection. |



> [!NOTE]
> To enable monitoring at scale using Azure Policy, see [Enable VM insights using Azure Policy](vminsights-enable-policy.md).


## Install Azure Monitor agent

The first step is to install the Azure Monitor agent extension on your virtual machines and Arc-enabled servers. 

## [Azure CLI](#tab/cli)

**Azure virtual machine**

```azurecli-interactive
#  Linux
az vm extension set \
  --name AzureMonitorLinuxAgent \
  --publisher Microsoft.Azure.Monitor \
  --vm-name <vm-name> \
  --resource-group <resource-group>

# Windows
az vm extension set \
  --name AzureMonitorWindowsAgent \
  --publisher Microsoft.Azure.Monitor \
  --vm-name <vm-name> \
  --resource-group <resource-group>
```

**Arc-enabled server**

```azurecli-interactive
# Windows
az connectedmachine extension create \
  --name AzureMonitorWindowsAgent \
  --publisher Microsoft.Azure.Monitor \
  --type AzureMonitorWindowsAgent \
  --machine-name <arc-server-name> \
  --resource-group <resource-group> \
  --location <location>

# Linux
az connectedmachine extension create \
  --name AzureMonitorLinuxAgent \
  --publisher Microsoft.Azure.Monitor \
  --type AzureMonitorLinuxAgent \
  --machine-name <arc-server-name> \
  --resource-group <resource-group> \
  --location <location>
```


**Virtual machine scale set**

```azurecli-interactive
# Windows
az vmss extension set \
  --name AzureMonitorWindowsAgent \
  --publisher Microsoft.Azure.Monitor \
  --vmss-name <vmss-name> \
  --resource-group <resource-group>

# Linux
az vmss extension set \
  --name AzureMonitorLinuxAgent \
  --publisher Microsoft.Azure.Monitor \
  --vmss-name <vmss-name> \
  --resource-group <resource-group>
```


## [PowerShell](#tab/powershell)


**Virtual machine**

```powershell-interactive
# Windows
Set-AzVMExtension `
  -Name AzureMonitorWindowsAgent `
  -ExtensionType AzureMonitorWindowsAgent `
  -Publisher Microsoft.Azure.Monitor `
  -ResourceGroupName <resource-group> `
  -VMName <vm-name> `
  -Location <location> `
  -TypeHandlerVersion 1.0

# Linux
Set-AzVMExtension `
  -Name AzureMonitorLinuxAgent `
  -ExtensionType AzureMonitorLinuxAgent `
  -Publisher Microsoft.Azure.Monitor `
  -ResourceGroupName <resource-group> `
  -VMName <vm-name> `
  -Location <location> `
  -TypeHandlerVersion 1.0
```

**Arc-enabled server**

```powershell-interactive
# Windows
New-AzConnectedMachineExtension `
  -Name AzureMonitorWindowsAgent `
  -ExtensionType AzureMonitorWindowsAgent `
  -Publisher Microsoft.Azure.Monitor `
  -ResourceGroupName <resource-group> `
  -MachineName <arc-server-name> `
  -Location <location> `
  -TypeHandlerVersion 1.0

# Linux
New-AzConnectedMachineExtension `
  -Name AzureMonitorLinuxAgent `
  -ExtensionType AzureMonitorLinuxAgent `
  -Publisher Microsoft.Azure.Monitor `
  -ResourceGroupName <resource-group> `
  -MachineName <arc-server-name> `
  -Location <location> `
  -TypeHandlerVersion 1.0
```
**Virtual machine scale set**

```powershell-interactive
# Windows
Add-AzVmssExtension `
  -VirtualMachineScaleSet (Get-AzVmss -ResourceGroupName <resource-group> -VMScaleSetName <vmss-name>) `
  -Name AzureMonitorWindowsAgent `
  -Publisher Microsoft.Azure.Monitor `
  -Type AzureMonitorWindowsAgent `
  -TypeHandlerVersion 1.0

# Linux
Add-AzVmssExtension `
  -VirtualMachineScaleSet (Get-AzVmss -ResourceGroupName <resource-group> -VMScaleSetName <vmss-name>) `
  -Name AzureMonitorWindowsAgent `
  -Publisher Microsoft.Azure.Monitor `
  -Type AzureMonitorWindowsAgent `
  -TypeHandlerVersion 1.0

```


---


## Create data collection rules

Data collection rules (DCRs) define what data to collect from the Azure Monitor agent and where to send it. You can create different types of DCRs depending on what you want to monitor. Some DCRs will enable features in the Azure portal such as the enhanced monitoring experience for VMs, while others will collect specific types of logs or metrics that you can use for analysis or alerting.

DCRs are structured in JSON. When you create DCRs using the Azure portal, you don't require any knowledge of the DCR structure. You may need to understand the DCR structure though to create DCRs from scratch or to add advanced functionality to existing DCRs such as adding a transformation.

The following table describes the most common DCR types used for VM monitoring. For an complete list of DCR types and their structures, see [Data collection rule structure](../data-collection/data-collection-rule-structure.md).

| DCR Type | Description |
|:---|:---|
| **OpenTelemetry metrics** | Collects system-level performance counters using OpenTelemetry standards. Enables the metrics-based experience for VM monitoring in the Azure portal. |
| **VM insights** | Collects predefined performance counters in a Log Analytics workspace. Enables the classic logs-based experience in the Azure portal. |
| **Logs** | Collect different types of logs from the VM including Windows Events and Syslog. These DCCRs don't enable any additional experiences in Azure Monitor, but they can be analyzed with Log Analytics and used for alerting. See [Collect data from virtual machine client with Azure Monitor](./data-collection.md) for a description of the different data sources available. |
| Performance data | Collect performance data in addition to the data collected when enhanced monitoring is enabled. This may be OpenTelemetry metrics sent to an Azure Monitor workspace or performance counters sent to a Log Analytics workspace. |

Start by defining the DCR in JSON format. 

<details>
<summary>OpenTelemetry metrics</summary>

```json
{
  "properties": {
    "dataSources": {
      "performanceCountersOTel": [
        {
          "streams": "Microsoft-OtelPerfMetrics",
          "samplingFrequencyInSeconds": 60,
          "counterSpecifiers": [
              "system.filesystem.usage",
              "system.disk.io",
              "system.disk.operation_time",
              "system.disk.operations",
              "system.memory.usage",
              "system.network.io",
              "system.cpu.time",
              "system.network.dropped",
              "system.network.errors",
              "system.uptime"
          ],
          "name": "OtelPerfCounters"
        }
      ]
    },
    "destinations": {
      "monitoringAccounts": [
        {
          "accountResourceId": "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Monitor/accounts/<workspace-name>",
          "name": "MonitoringAccount"
        }
      ]
    },
    "dataFlows": [
      {
        "streams": "Microsoft-OtelPerfMetrics",
        "destinations": "MonitoringAccount"
      }
    ]
  }
}
```

</details>

<details>
<summary>VM insights</summary>

``` json
{
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
                    "workspaceResourceId": "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.OperationalInsights/workspaces/<workspace-name>",
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
```

</details>

## [CLI](#tab/cli)


```azurecli-interactive
az monitor data-collection rule create \
  --name <dcr-name> \
  --resource-group <resource-group> \
  --location <location> \
  --rule-file <path-to-json-file>
```



## [PowerShell](#tab/powershell)

```powershell-interactive
New-AzDataCollectionRule `
  -Name <dcr-name> `
  -ResourceGroupName <resource-group> `
  -Location <location>
  -RuleFile <path-to-json-file>
```
---


## Associate DCRs with VMs

The final step is to create associations between your DCRs and your VMs to activate data collection.

## [Azure CLI](#tab/cli)

### Azure VM

```azurecli
az monitor data-collection rule association create \
  --name "dcr-association" \
  --rule-id /subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Compute/virtualMachines/<vm-name>
  --resource /subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Compute/virtualMachines/<vm-name>
```

### Azure VM scale set

```azurecli
az monitor data-collection rule association create \
  --name "dcr-association" \
  --rule-id /subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Compute/virtualMachines/<vm-name>
  --resource /subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Compute/virtualMachines/<vm-name>
```

### Arc-enabled server

```azurecli
az monitor data-collection rule association create \
  --name "dcr-association" \
  --rule-id $DCR_ID \
  --resource /subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.HybridCompute/machines/<arc-server-name>
```

## [PowerShell](#tab/powershell)

### Azure VM

```powershell
New-AzDataCollectionRuleAssociation `
  -AssociationName "dcr-association" `
  -ResourceUri "/subscriptions/<subscription-id>/resourceGroups/<vm-resource-group>/providers/Microsoft.Compute/virtualMachines/<vm-name>" `
  -DataCollectionRuleId "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/microsoft.insights/datacollectionrules/<dcr-name>"
```

### Azure VM scale set

```powershell
New-AzDataCollectionRuleAssociation `
  -AssociationName "dcr-association" `
  -ResourceUri "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Compute/virtualMachineScaleSets/<vmss-name>" `
  -DataCollectionRuleId "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/microsoft.insights/datacollectionrules/<dcr-name>"
```

### Arc-enabled server

```powershell
New-AzDataCollectionRuleAssociation `
  -AssociationName "dcr-association" `
  -ResourceUri "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.HybridCompute/machines/<vm-name>" `
  -DataCollectionRuleId "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/microsoft.insights/datacollectionrules/<dcr-name>"
```

---


## Enable network isolation

There are two methods for network isolation that VM insights supports as described in the following table.

| Method | Description |
|:---|:---|
| Private link | See [Enable network isolation for Azure Monitor Agent by using Private Link](../fundamentals/private-link-vm-kubernetes.md). |
| Network security perimeter | See [Configure Azure Monitor with Network Security Perimeter](../fundamentals/network-security-perimeter.md). |


## Next steps

Now that you've enabled VM monitoring at scale, learn how to:

- [View VM insights Performance](vminsights-performance.md) to identify performance bottlenecks and overall utilization across your VMs
- [View VM insights Map](vminsights-maps.md) to visualize dependencies between VMs and applications
- [Create alert rules](monitor-virtual-machine-alerts.md) to proactively notify you of issues with your VMs
- [Customize data collection rules](../data-collection/data-collection-rule-create-edit.md) to add custom performance counters, additional Windows events, or Syslog facilities
- [Troubleshoot VM insights](vminsights-troubleshoot.md) if you encounter issues with agent deployment or data collection
