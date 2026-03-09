---
title: Enable VM monitoring at scale
description: Learn how to enable monitoring for virtual machines and virtual machine scale sets at scale using Azure CLI, PowerShell, ARM templates, Bicep, and Azure Policy.
ms.topic: how-to
ms.reviewer: xpathak
ms.date: 03/08/2026
ms.custom: references_regions, devx-track-azurecli, devx-track-azurepowershell, devx-track-arm-template, devx-track-bicep
zone_pivot_groups: azure-monitor-vm-deployment

---

# Enable VM monitoring at scale

This article describes how to enable monitoring for Azure virtual machines and virtual machine scale sets at scale using infrastructure as code (IaC) tools and automation methods. These methods allow you to consistently deploy monitoring across your VM fleet and integrate monitoring configuration into your DevOps pipelines.

Select your preferred deployment method at the top of this article to see relevant commands and examples.

> [!NOTE]
> To quickly enable monitoring for a single virtual machine using the Azure portal, see [Tutorial: Enable enhanced monitoring for an Azure virtual machine](./tutorial-vm-enable-monitoring.md).

## Overview

Enabling VM monitoring at scale involves three fundamental steps that can be automated using various tools:

1. **Install the Azure Monitor agent** on each virtual machine
2. **Create data collection rules (DCRs)** that specify what data to collect and where to send it  
3. **Associate DCRs with VMs** to activate data collection

This article covers the following methods for automating these steps:

- **Azure CLI** - Scriptable command-line interface
- **Azure PowerShell** - PowerShell-based automation
- **ARM templates** - JSON-based infrastructure as code
- **Bicep** - Azure-native domain-specific language
- **Azure Policy** - Governance-based automated compliance

Each method can enable both OpenTelemetry-based metrics (preview) and logs-based metrics (classic). You can also create additional DCRs to collect events, logs, and custom performance counters beyond the default metrics.


## Prerequisites

- **Azure Monitor workspace** if you enable OpenTelemetry metrics (preview). See [Create an Azure Monitor workspace](../metrics/azure-monitor-workspace-manage.md#create-an-azure-monitor-workspace).
- **Log Analytics workspace** if you enable logs-based metrics or collect logs. See [Create a Log Analytics workspace](../logs/quick-create-workspace.md).
- **Permissions** to create data collection rules (DCRs) and associate them with VMs. See [Data collection rule permissions](../data-collection/data-collection-rule-create-edit.md#permissions).
- **Supported operating system** on your VMs. See [Azure Monitor agent supported operating systems](../agents/azure-monitor-agent-supported-operating-systems.md).
- **Network connectivity** from VMs to Azure Monitor. See [Azure Monitor agent network configuration](../agents/azure-monitor-agent-network-configuration.md).
- **Azure CLI** (version 2.15.0 or later) if using CLI methods. Run `az --version` to check your version.
- **Azure PowerShell** (Az module 5.4.0 or later) if using PowerShell methods. Run `Get-Module -ListAvailable Az` to check your version.

## Understanding data collection rules

Data collection rules (DCRs) define what data to collect from the Azure Monitor agent and where to send it. You can create different types of DCRs depending on what you want to monitor:

| DCR Type | Purpose | Stream | Destination |
|:---|:---|:---|:---|
| **OpenTelemetry metrics** | Collects system-level performance counters using OpenTelemetry standards | `Microsoft-OtelPerfMetrics` | Azure Monitor workspace |
| **VM insights (logs-based)** | Collects predefined performance counters for the classic VM insights experience | `Microsoft-InsightsMetrics` | Log Analytics workspace |
| **Windows events** | Collects Windows event logs | `Microsoft-Event` | Log Analytics workspace |
| **Syslog** | Collects Linux system logs | `Microsoft-Syslog` | Log Analytics workspace |
| **Performance counters** | Collects custom Windows or Linux performance counters | `Microsoft-Perf` | Log Analytics workspace |
| **IIS logs** | Collects Internet Information Services web server logs | `Microsoft-W3CIISLog` | Log Analytics workspace |
| **Text/JSON logs** | Collects custom application logs from text or JSON files | Custom streams | Log Analytics workspace |

### Sharing DCRs across VMs

A key advantage of DCRs is that a single DCR can be associated with multiple VMs. This provides several benefits:

- **Consistency**: All VMs collect the same data using identical configuration
- **Simplified management**: Update one DCR to change monitoring for all associated VMs
- **Cost efficiency**: Each DCR incurs a small management overhead; sharing reduces total cost
- **Regional consideration**: DCRs must be in the same region as their destination workspace

**Best practices for DCR sharing:**

1. **Create regional DCRs**: Deploy one DCR per region per monitoring configuration to match workspace regions
2. **Group by monitoring needs**: VMs with identical monitoring requirements should share a DCR
3. **Naming convention**: Use descriptive names like `dcr-otel-westus2-production` or `dcr-vminsights-eastus-dev`
4. **Separate concerns**: Use different DCRs for different data types (one for metrics, one for logs, one for custom performance counters)

**Example architecture:**
```
Production VMs in West US 2  →  dcr-otel-westus2-prod      →  amw-production-westus2
                              →  dcr-logs-westus2-prod     →  law-production-westus2
Development VMs in West US 2 →  dcr-otel-westus2-dev       →  amw-development-westus2
                              →  dcr-logs-westus2-dev      →  law-development-westus2
```

## Step 1: Install Azure Monitor agent

The first step is to install the Azure Monitor agent extension on your virtual machines.

::: zone pivot="azure-cli"

Install the Azure Monitor agent extension on a VM:

```azurecli-interactive
# For Linux VM
az vm extension set \
  --name AzureMonitorLinuxAgent \
  --publisher Microsoft.Azure.Monitor \
  --vm-name <vm-name> \
  --resource-group <resource-group>

# For Windows VM
az vm extension set \
  --name AzureMonitorWindowsAgent \
  --publisher Microsoft.Azure.Monitor \
  --vm-name <vm-name> \
  --resource-group <resource-group>

# For Linux VMSS
az vmss extension set \
  --name AzureMonitorLinuxAgent \
  --publisher Microsoft.Azure.Monitor \
  --vmss-name <vmss-name> \
  --resource-group <resource-group>

# For Windows VMSS
az vmss extension set \
  --name AzureMonitorWindowsAgent \
  --publisher Microsoft.Azure.Monitor \
  --vmss-name <vmss-name> \
  --resource-group <resource-group>
```

::: zone-end

::: zone pivot="azure-powershell"

Install the Azure Monitor agent using PowerShell:

```powershell
# For Windows VM
Set-AzVMExtension `
  -Name AzureMonitorWindowsAgent `
  -ExtensionType AzureMonitorWindowsAgent `
  -Publisher Microsoft.Azure.Monitor `
  -ResourceGroupName <resource-group> `
  -VMName <vm-name> `
  -Location <location> `
  -TypeHandlerVersion 1.0

# For Linux VM
Set-AzVMExtension `
  -Name AzureMonitorLinuxAgent `
  -ExtensionType AzureMonitorLinuxAgent `
  -Publisher Microsoft.Azure.Monitor `
  -ResourceGroupName <resource-group> `
  -VMName <vm-name> `
  -Location <location> `
  -TypeHandlerVersion 1.0

# For VMSS (Windows)
Add-AzVmssExtension `
  -VirtualMachineScaleSet (Get-AzVmss -ResourceGroupName <resource-group> -VMScaleSetName <vmss-name>) `
  -Name AzureMonitorWindowsAgent `
  -Publisher Microsoft.Azure.Monitor `
  -Type AzureMonitorWindowsAgent `
  -TypeHandlerVersion 1.0
```

::: zone-end

::: zone pivot="azure-resource-manager"

Add the agent extension to your ARM template:

```json
{
  "type": "Microsoft.Compute/virtualMachines/extensions",
  "apiVersion": "2023-03-01",
  "name": "[concat(parameters('vmName'), '/AzureMonitorWindowsAgent')]",
  "location": "[parameters('location')]",
  "properties": {
    "publisher": "Microsoft.Azure.Monitor",
    "type": "AzureMonitorWindowsAgent",
    "typeHandlerVersion": "1.0",
    "autoUpgradeMinorVersion": true
  }
}
```

For Linux, change the type to `AzureMonitorLinuxAgent` and the name accordingly.

::: zone-end

::: zone pivot="bicep"

Add the agent extension to your Bicep template:

```bicep
resource amaExtension 'Microsoft.Compute/virtualMachines/extensions@2023-03-01' = {
  name: '${vmName}/AzureMonitorWindowsAgent'
  location: location
  properties: {
    publisher: 'Microsoft.Azure.Monitor'
    type: 'AzureMonitorWindowsAgent'
    typeHandlerVersion: '1.0'
    autoUpgradeMinorVersion: true
  }
}
```

For Linux, change the type to `AzureMonitorLinuxAgent` in both the name and properties.

::: zone-end

::: zone pivot="azure-policy"

Azure Policy automatically installs the Azure Monitor agent when you assign a VM insights policy initiative. Skip to [Enable monitoring using Azure Policy](#enable-monitoring-using-azure-policy) to configure policy-based deployment.

::: zone-end

## Step 2: Create data collection rules

Create DCRs to specify what data to collect. You can create different DCRs for different monitoring scenarios.

### OpenTelemetry metrics (preview)

::: zone pivot="azure-cli"

Create a DCR JSON file (`dcr-otel.json`):

```json
{
  "location": "westus2",
  "properties": {
    "dataSources": {
      "performanceCountersOTel": [
        {
          "streams": ["Microsoft-OtelPerfMetrics"],
          "samplingFrequencyInSeconds": 60,
          "counterSpecifiers": [
            "system.cpu.time",
            "system.cpu.utilization",
            "system.memory.usage",
            "system.memory.utilization",
            "system.disk.io",
            "system.disk.operations",
            "system.network.io",
            "system.filesystem.usage"
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
        "streams": ["Microsoft-OtelPerfMetrics"],
        "destinations": ["MonitoringAccount"]
      }
    ]
  }
}
```

Deploy the DCR:

```azurecli-interactive
az monitor data-collection rule create \
  --name "dcr-otel-westus2" \
  --resource-group <resource-group> \
  --location westus2 \
  --rule-file dcr-otel.json
```

::: zone-end

::: zone pivot="azure-powershell"

Create a DCR using PowerShell:

```powershell
$dcrProperties = @{
    location = "westus2"
    properties = @{
        dataSources = @{
            performanceCountersOTel = @(
                @{
                    streams = @("Microsoft-OtelPerfMetrics")
                    samplingFrequencyInSeconds = 60
                    counterSpecifiers = @(
                        "system.cpu.time",
                        "system.cpu.utilization",
                        "system.memory.usage",
                        "system.disk.io",
                        "system.network.io",
                        "system.filesystem.usage"
                    )
                    name = "OtelPerfCounters"
                }
            )
        }
        destinations = @{
            monitoringAccounts = @(
                @{
                    accountResourceId = "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Monitor/accounts/<workspace-name>"
                    name = "MonitoringAccount"
                }
            )
        }
        dataFlows = @(
            @{
                streams = @("Microsoft-OtelPerfMetrics")
                destinations = @("MonitoringAccount")
            }
        )
    }
}

New-AzDataCollectionRule `
  -Name "dcr-otel-westus2" `
  -ResourceGroupName <resource-group> `
  -JsonString ($dcrProperties | ConvertTo-Json -Depth 10)
```

::: zone-end

::: zone pivot="azure-resource-manager"

Add the DCR resource to your ARM template:

```json
{
  "type": "Microsoft.Insights/dataCollectionRules",
  "apiVersion": "2022-06-01",
  "name": "dcr-otel-westus2",
  "location": "westus2",
  "properties": {
    "dataSources": {
      "performanceCountersOTel": [
        {
          "streams": ["Microsoft-OtelPerfMetrics"],
          "samplingFrequencyInSeconds": 60,
          "counterSpecifiers": [
            "system.cpu.time",
            "system.cpu.utilization",
            "system.memory.usage",
            "system.disk.io",
            "system.network.io",
            "system.filesystem.usage"
          ],
          "name": "OtelPerfCounters"
        }
      ]
    },
    "destinations": {
      "monitoringAccounts": [
        {
          "accountResourceId": "[parameters('monitoringAccountId')]",
          "name": "MonitoringAccount"
        }
      ]
    },
    "dataFlows": [
      {
        "streams": ["Microsoft-OtelPerfMetrics"],
        "destinations": ["MonitoringAccount"]
      }
    ]
  }
}
```

::: zone-end

::: zone pivot="bicep"

Add the DCR resource to your Bicep template:

```bicep
resource dcr 'Microsoft.Insights/dataCollectionRules@2022-06-01' = {
  name: 'dcr-otel-westus2'
  location: 'westus2'
  properties: {
    dataSources: {
      performanceCountersOTel: [
        {
          streams: ['Microsoft-OtelPerfMetrics']
          samplingFrequencyInSeconds: 60
          counterSpecifiers: [
            'system.cpu.time'
            'system.cpu.utilization'
            'system.memory.usage'
            'system.disk.io'
            'system.network.io'
            'system.filesystem.usage'
          ]
          name: 'OtelPerfCounters'
        }
      ]
    }
    destinations: {
      monitoringAccounts: [
        {
          accountResourceId: monitoringAccountId
          name: 'MonitoringAccount'
        }
      ]
    }
    dataFlows: [
      {
        streams: ['Microsoft-OtelPerfMetrics']
        destinations: ['MonitoringAccount']
      }
    ]
  }
}
```

::: zone-end

::: zone pivot="azure-policy"

Azure Policy automatically creates DCRs when you configure the policy initiative. Skip to [Enable monitoring using Azure Policy](#enable-monitoring-using-azure-policy).

::: zone-end

### VM insights (logs-based metrics)

::: zone pivot="azure-cli"

Create a DCR JSON file (`dcr-vminsights.json`):

```json
{
  "location": "westus2",
  "properties": {
    "dataSources": {
      "performanceCounters": [
        {
          "name": "VMInsightsPerfCounters",
          "streams": ["Microsoft-InsightsMetrics"],
          "samplingFrequencyInSeconds": 60,
          "counterSpecifiers": ["\\VmInsights\\DetailedMetrics"]
        }
      ]
    },
    "destinations": {
      "logAnalytics": [
        {
          "workspaceResourceId": "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.OperationalInsights/workspaces/<workspace-name>",
          "name": "VMInsightsDestination"
        }
      ]
    },
    "dataFlows": [
      {
        "streams": ["Microsoft-InsightsMetrics"],
        "destinations": ["VMInsightsDestination"]
      }
    ]
  }
}
```

Deploy the DCR:

```azurecli-interactive
az monitor data-collection rule create \
  --name "dcr-vminsights-westus2" \
  --resource-group <resource-group> \
  --location westus2 \
  --rule-file dcr-vminsights.json
```

::: zone-end

::: zone pivot="azure-powershell"

Create a DCR using PowerShell:

```powershell
$dcrProperties = @{
    location = "westus2"
    properties = @{
        dataSources = @{
            performanceCounters = @(
                @{
                    name = "VMInsightsPerfCounters"
                    streams = @("Microsoft-InsightsMetrics")
                    samplingFrequencyInSeconds = 60
                    counterSpecifiers = @("\\VmInsights\\DetailedMetrics")
                }
            )
        }
        destinations = @{
            logAnalytics = @(
                @{
                    workspaceResourceId = "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.OperationalInsights/workspaces/<workspace-name>"
                    name = "VMInsightsDestination"
                }
            )
        }
        dataFlows = @(
            @{
                streams = @("Microsoft-InsightsMetrics")
                destinations = @("VMInsightsDestination")
            }
        )
    }
}

New-AzDataCollectionRule `
  -Name "dcr-vminsights-westus2" `
  -ResourceGroupName <resource-group> `
  -JsonString ($dcrProperties | ConvertTo-Json -Depth 10)
```

::: zone-end

::: zone pivot="azure-resource-manager"

Add the DCR resource to your ARM template:

```json
{
  "type": "Microsoft.Insights/dataCollectionRules",
  "apiVersion": "2022-06-01",
  "name": "dcr-vminsights-westus2",
  "location": "westus2",
  "properties": {
    "dataSources": {
      "performanceCounters": [
        {
          "name": "VMInsightsPerfCounters",
          "streams": ["Microsoft-InsightsMetrics"],
          "samplingFrequencyInSeconds": 60,
          "counterSpecifiers": ["\\VmInsights\\DetailedMetrics"]
        }
      ]
    },
    "destinations": {
      "logAnalytics": [
        {
          "workspaceResourceId": "[parameters('workspaceResourceId')]",
          "name": "VMInsightsDestination"
        }
      ]
    },
    "dataFlows": [
      {
        "streams": ["Microsoft-InsightsMetrics"],
        "destinations": ["VMInsightsDestination"]
      }
    ]
  }
}
```

::: zone-end

::: zone pivot="bicep"

Add the DCR resource to your Bicep template:

```bicep
resource dcr 'Microsoft.Insights/dataCollectionRules@2022-06-01' = {
  name: 'dcr-vminsights-westus2'
  location: 'westus2'
  properties: {
    dataSources: {
      performanceCounters: [
        {
          name: 'VMInsightsPerfCounters'
          streams: ['Microsoft-InsightsMetrics']
          samplingFrequencyInSeconds: 60
          counterSpecifiers: ['\\VmInsights\\DetailedMetrics']
        }
      ]
    }
    destinations: {
      logAnalytics: [
        {
          workspaceResourceId: workspaceResourceId
          name: 'VMInsightsDestination'
        }
      ]
    }
    dataFlows: [
      {
        streams: ['Microsoft-InsightsMetrics']
        destinations: ['VMInsightsDestination']
      }
    ]
  }
}
```

::: zone-end

### Additional data collection

You can create additional DCRs to collect Windows events, Syslog, or custom performance counters. See [Data collection rule structure](../data-collection/data-collection-rule-structure.md) for complete syntax reference.

**Windows events example** (critical and error events from System and Application logs):

```json
"dataSources": {
  "windowsEventLogs": [
    {
      "name": "WindowsEvents",
      "streams": ["Microsoft-Event"],
      "xPathQueries": [
        "System!*[System[(Level=1 or Level=2 or Level=3)]]",
        "Application!*[System[(Level=1 or Level=2 or Level=3)]]"
      ]
    }
  ]
}
```

**Syslog example** (auth, cron, daemon logs at error level and above):

```json
"dataSources": {
  "syslog": [
    {
      "name": "SyslogEvents",
      "streams": ["Microsoft-Syslog"],
      "facilityNames": ["auth", "authpriv", "cron", "daemon", "kern"],
      "logLevels": ["Alert", "Critical", "Emergency", "Error"]
    }
  ]
}
```

## Step 3: Associate DCRs with VMs

The final step is to create associations between your DCRs and your VMs to activate data collection.

::: zone pivot="azure-cli"

Associate a DCR with a VM:

```azurecli-interactive
# Get DCR resource ID
DCR_ID=$(az monitor data-collection rule show \
  --name "dcr-otel-westus2" \
  --resource-group <resource-group> \
  --query id -o tsv)

# Create association
az monitor data-collection rule association create \
  --name "dcr-association" \
  --rule-id $DCR_ID \
  --resource /subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Compute/virtualMachines/<vm-name>
```

::: zone-end

::: zone pivot="azure-powershell"

Create an association between a DCR and a VM:

```powershell
# Get DCR resource ID
$dcrId = (Get-AzDataCollectionRule `
  -ResourceGroupName <dcr-resource-group> `
  -Name "dcr-otel-westus2").Id

# Create association
New-AzDataCollectionRuleAssociation `
  -AssociationName "dcr-association" `
  -ResourceUri "/subscriptions/<subscription-id>/resourceGroups/<vm-resource-group>/providers/Microsoft.Compute/virtualMachines/<vm-name>" `
  -DataCollectionRuleId $dcrId
```

::: zone-end

::: zone pivot="azure-resource-manager"

Add the association resource to your ARM template:

```json
{
  "type": "Microsoft.Insights/dataCollectionRuleAssociations",
  "apiVersion": "2022-06-01",
  "scope": "[format('Microsoft.Compute/virtualMachines/{0}', parameters('vmName'))]",
  "name": "dcr-association",
  "dependsOn": [
    "[resourceId('Microsoft.Insights/dataCollectionRules', variables('dcrName'))]",
    "[resourceId('Microsoft.Compute/virtualMachines/extensions', parameters('vmName'), 'AzureMonitorWindowsAgent')]"
  ],
  "properties": {
    "dataCollectionRuleId": "[resourceId('Microsoft.Insights/dataCollectionRules', variables('dcrName'))]"
  }
}
```

::: zone-end

::: zone pivot="bicep"

Add the association resource to your Bicep template:

```bicep
resource dcrAssociation 'Microsoft.Insights/dataCollectionRuleAssociations@2022-06-01' = {
  scope: resourceId('Microsoft.Compute/virtualMachines', vmName)
  name: 'dcr-association'
  properties: {
    dataCollectionRuleId: dcr.id
  }
  dependsOn: [
    amaExtension
  ]
}
```

::: zone-end

::: zone pivot="azure-policy"

Azure Policy automatically creates associations when remediating policy assignments. Skip to [Enable monitoring using Azure Policy](#enable-monitoring-using-azure-policy).

::: zone-end

## Complete deployment examples

The following examples show complete automation scripts that perform all three steps for multiple VMs.

### Bulk deployment script

::: zone pivot="azure-cli"

Shell script to enable monitoring for all VMs in a resource group:

```bash
#!/bin/bash

# Configuration
RESOURCE_GROUP="<vm-resource-group>"
DCR_RESOURCE_GROUP="<dcr-resource-group>"
DCR_NAME="dcr-otel-westus2"
LOCATION="westus2"

# Get DCR resource ID
DCR_ID=$(az monitor data-collection rule show \
  --name "$DCR_NAME" \
  --resource-group "$DCR_RESOURCE_GROUP" \
  --query id -o tsv)

# Get list of VMs
VM_LIST=$(az vm list \
  --resource-group "$RESOURCE_GROUP" \
  --query "[].{name:name, id:id, os:storageProfile.osDisk.osType}" -o json)

# Process each VM
echo "$VM_LIST" | jq -c '.[]' | while read vm; do
  VM_NAME=$(echo $vm | jq -r '.name')
  VM_ID=$(echo $vm | jq -r '.id')
  OS_TYPE=$(echo $vm | jq -r '.os')
  
  echo "Processing VM: $VM_NAME (OS: $OS_TYPE)"
  
  # Determine agent name based on OS
  if [ "$OS_TYPE" == "Windows" ]; then
    AGENT_NAME="AzureMonitorWindowsAgent"
  else
    AGENT_NAME="AzureMonitorLinuxAgent"
  fi
  
  # Install Azure Monitor agent
  az vm extension set \
    --ids "$VM_ID" \
    --name "$AGENT_NAME" \
    --publisher Microsoft.Azure.Monitor \
    --no-wait
  
  # Associate DCR (after agent installation completes)
  az monitor data-collection rule association create \
    --name "dcr-assoc-$VM_NAME" \
    --rule-id "$DCR_ID" \
    --resource "$VM_ID" \
    --no-wait
done

echo "Deployment initiated for all VMs in resource group $RESOURCE_GROUP"
```

::: zone-end

::: zone pivot="azure-powershell"

PowerShell script to enable monitoring for all VMs in a resource group:

```powershell
# Configuration
$resourceGroup = "<vm-resource-group>"
$dcrResourceGroup = "<dcr-resource-group>"
$dcrName = "dcr-otel-westus2"
$location = "westus2"

# Get DCR ID
$dcrId = (Get-AzDataCollectionRule `
  -ResourceGroupName $dcrResourceGroup `
  -Name $dcrName).Id

Write-Host "Using DCR: $dcrId"

# Get all VMs in resource group
$vms = Get-AzVM -ResourceGroupName $resourceGroup

Write-Host "Found $($vms.Count) VMs to process"

foreach ($vm in $vms) {
    Write-Host "`nProcessing VM: $($vm.Name)"
    
    # Determine OS type and agent name
    if ($vm.StorageProfile.OsDisk.OsType -eq "Windows") {
        $agentName = "AzureMonitorWindowsAgent"
        $extensionType = "AzureMonitorWindowsAgent"
    } else {
        $agentName = "AzureMonitorLinuxAgent"
        $extensionType = "AzureMonitorLinuxAgent"
    }
    
    # Install Azure Monitor agent
    try {
        Write-Host "  Installing $agentName..."
        Set-AzVMExtension `
          -Name $agentName `
          -ExtensionType $extensionType `
          -Publisher "Microsoft.Azure.Monitor" `
          -ResourceGroupName $resourceGroup `
          -VMName $vm.Name `
          -Location $location `
          -TypeHandlerVersion 1.0 `
          -ErrorAction Stop | Out-Null
        
        Write-Host "  Agent installed successfully"
    } catch {
        Write-Warning "  Failed to install agent: $_"
        continue
    }
    
    # Create DCR association
    try {
        Write-Host "  Creating DCR association..."
        New-AzDataCollectionRuleAssociation `
          -AssociationName "dcr-assoc-$($vm.Name)" `
          -ResourceUri $vm.Id `
          -DataCollectionRuleId $dcrId `
          -ErrorAction Stop | Out-Null
        
        Write-Host "  DCR associated successfully"
    } catch {
        Write-Warning "  Failed to associate DCR: $_"
    }
}

Write-Host "`nCompleted processing $($vms.Count) VMs"
```

::: zone-end

::: zone pivot="azure-resource-manager"

Complete ARM template deploying a VM with monitoring:

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "vmName": {
      "type": "string",
      "metadata": {
        "description": "Name of the virtual machine"
      }
    },
    "location": {
      "type": "string",
      "defaultValue": "[resourceGroup().location]"
    },
    "workspaceResourceId": {
      "type": "string",
      "metadata": {
        "description": "Resource ID of the Log Analytics workspace"
      }
    }
  },
  "variables": {
    "dcrName": "[concat('dcr-vminsights-', parameters('location'))]"
  },
  "resources": [
    {
      "type": "Microsoft.Insights/dataCollectionRules",
      "apiVersion": "2022-06-01",
      "name": "[variables('dcrName')]",
      "location": "[parameters('location')]",
      "properties": {
        "dataSources": {
          "performanceCounters": [
            {
              "name": "VMInsightsPerfCounters",
              "streams": ["Microsoft-InsightsMetrics"],
              "samplingFrequencyInSeconds": 60,
              "counterSpecifiers": ["\\VmInsights\\DetailedMetrics"]
            }
          ]
        },
        "destinations": {
          "logAnalytics": [
            {
              "workspaceResourceId": "[parameters('workspaceResourceId')]",
              "name": "VMInsightsDestination"
            }
          ]
        },
        "dataFlows": [
          {
            "streams": ["Microsoft-InsightsMetrics"],
            "destinations": ["VMInsightsDestination"]
          }
        ]
      }
    },
    {
      "type": "Microsoft.Compute/virtualMachines/extensions",
      "apiVersion": "2023-03-01",
      "name": "[concat(parameters('vmName'), '/AzureMonitorWindowsAgent')]",
      "location": "[parameters('location')]",
      "dependsOn": [
        "[resourceId('Microsoft.Insights/dataCollectionRules', variables('dcrName'))]"
      ],
      "properties": {
        "publisher": "Microsoft.Azure.Monitor",
        "type": "AzureMonitorWindowsAgent",
        "typeHandlerVersion": "1.0",
        "autoUpgradeMinorVersion": true
      }
    },
    {
      "type": "Microsoft.Insights/dataCollectionRuleAssociations",
      "apiVersion": "2022-06-01",
      "scope": "[format('Microsoft.Compute/virtualMachines/{0}', parameters('vmName'))]",
      "name": "dcr-association",
      "dependsOn": [
        "[resourceId('Microsoft.Insights/dataCollectionRules', variables('dcrName'))]",
        "[resourceId('Microsoft.Compute/virtualMachines/extensions', parameters('vmName'), 'AzureMonitorWindowsAgent')]"
      ],
      "properties": {
        "dataCollectionRuleId": "[resourceId('Microsoft.Insights/dataCollectionRules', variables('dcrName'))]"
      }
    }
  ],
  "outputs": {
    "dcrResourceId": {
      "type": "string",
      "value": "[resourceId('Microsoft.Insights/dataCollectionRules', variables('dcrName'))]"
    }
  }
}
```

Deploy the template:

```azurecli-interactive
az deployment group create \
  --resource-group <resource-group> \
  --template-file vm-monitoring.json \
  --parameters vmName=<vm-name> \
               workspaceResourceId=<workspace-resource-id>
```

::: zone-end

::: zone pivot="bicep"

Complete Bicep template deploying a VM with comprehensive monitoring:

```bicep
@description('Name of the virtual machine')
param vmName string

@description('Location for all resources')
param location string = resourceGroup().location

@description('Resource ID of the Log Analytics workspace')
param workspaceResourceId string

@description('OS type of the VM')
@allowed([
  'Windows'
  'Linux'
])
param osType string = 'Windows'

var dcrMetricsName = 'dcr-vminsights-${location}'
var dcrLogsName = 'dcr-logs-${location}'
var agentType = osType == 'Windows' ? 'AzureMonitorWindowsAgent' : 'AzureMonitorLinuxAgent'

// DCR for VM Insights metrics
resource dcrMetrics 'Microsoft.Insights/dataCollectionRules@2022-06-01' = {
  name: dcrMetricsName
  location: location
  properties: {
    dataSources: {
      performanceCounters: [
        {
          name: 'VMInsightsPerfCounters'
          streams: ['Microsoft-InsightsMetrics']
          samplingFrequencyInSeconds: 60
          counterSpecifiers: ['\\VmInsights\\DetailedMetrics']
        }
      ]
    }
    destinations: {
      logAnalytics: [
        {
          workspaceResourceId: workspaceResourceId
          name: 'LAWorkspace'
        }
      ]
    }
    dataFlows: [
      {
        streams: ['Microsoft-InsightsMetrics']
        destinations: ['LAWorkspace']
      }
    ]
  }
}

// DCR for event logs
resource dcrLogs 'Microsoft.Insights/dataCollectionRules@2022-06-01' = {
  name: dcrLogsName
  location: location
  properties: {
    dataSources: osType == 'Windows' ? {
      windowsEventLogs: [
        {
          name: 'WindowsEvents'
          streams: ['Microsoft-Event']
          xPathQueries: [
            'System!*[System[(Level=1 or Level=2 or Level=3)]]'
            'Application!*[System[(Level=1 or Level=2 or Level=3)]]'
          ]
        }
      ]
    } : {
      syslog: [
        {
          name: 'SyslogEvents'
          streams: ['Microsoft-Syslog']
          facilityNames: ['auth', 'authpriv', 'cron', 'daemon', 'kern', 'syslog']
          logLevels: ['Alert', 'Critical', 'Emergency', 'Error', 'Warning']
        }
      ]
    }
    destinations: {
      logAnalytics: [
        {
          workspaceResourceId: workspaceResourceId
          name: 'LAWorkspace'
        }
      ]
    }
    dataFlows: [
      {
        streams: osType == 'Windows' ? ['Microsoft-Event'] : ['Microsoft-Syslog']
        destinations: ['LAWorkspace']
      }
    ]
  }
}

// Azure Monitor agent
resource amaExtension 'Microsoft.Compute/virtualMachines/extensions@2023-03-01' = {
  name: '${vmName}/${agentType}'
  location: location
  properties: {
    publisher: 'Microsoft.Azure.Monitor'
    type: agentType
    typeHandlerVersion: '1.0'
    autoUpgradeMinorVersion: true
  }
  dependsOn: [
    dcrMetrics
    dcrLogs
  ]
}

// Associate metrics DCR
resource dcrMetricsAssociation 'Microsoft.Insights/dataCollectionRuleAssociations@2022-06-01' = {
  scope: resourceId('Microsoft.Compute/virtualMachines', vmName)
  name: 'dcr-metrics-association'
  properties: {
    dataCollectionRuleId: dcrMetrics.id
  }
  dependsOn: [
    amaExtension
  ]
}

// Associate logs DCR
resource dcrLogsAssociation 'Microsoft.Insights/dataCollectionRuleAssociations@2022-06-01' = {
  scope: resourceId('Microsoft.Compute/virtualMachines', vmName)
  name: 'dcr-logs-association'
  properties: {
    dataCollectionRuleId: dcrLogs.id
  }
  dependsOn: [
    amaExtension
  ]
}

output dcrMetricsId string = dcrMetrics.id
output dcrLogsId string = dcrLogs.id
```

Deploy the template:

```azurecli-interactive
az deployment group create \
  --resource-group <resource-group> \
  --template-file vm-monitoring.bicep \
  --parameters vmName=<vm-name> \
               workspaceResourceId=<workspace-resource-id> \
               osType=Windows
```

::: zone-end

::: zone pivot="azure-policy"

Azure Policy-based deployment doesn't require custom scripts. All three steps (agent installation, DCR creation, and association) are handled automatically through policy initiatives and remediation tasks. See [Enable monitoring using Azure Policy](#enable-monitoring-using-azure-policy) for details.

::: zone-end

### Using the Install-VMInsights.ps1 script

::: zone pivot="azure-powershell"

For VM insights specifically, Microsoft provides a PowerShell Gallery script that automates all three steps. This script supports logs-based metrics only.

```powershell
# Install the script from PowerShell Gallery
Install-Script -Name Install-VMInsights

# Enable VM insights for specific VMs
Install-VMInsights.ps1 `
  -SubscriptionId <subscription-id> `
  -ResourceGroup <resource-group> `
  -Name <vm-name> `
  -DcrResourceId <dcr-resource-id> `
  -UserAssignedManagedIdentityName <identity-name> `
  -UserAssignedManagedIdentityResourceGroup <identity-resource-group>

# Enable for all VMs in a subscription
Install-VMInsights.ps1 `
  -SubscriptionId <subscription-id> `
  -DcrResourceId <dcr-resource-id> `
  -UserAssignedManagedIdentityName <identity-name> `
  -UserAssignedManagedIdentityResourceGroup <identity-resource-group> `
  -Approve

# Enable with wildcard matching
Install-VMInsights.ps1 `
  -SubscriptionId <subscription-id> `
  -ResourceGroup "rg-production-*" `
  -Name "vm-web-*" `
  -DcrResourceId <dcr-resource-id> `
  -UserAssignedManagedIdentityName <identity-name> `
  -UserAssignedManagedIdentityResourceGroup <identity-resource-group>
```

::: zone-end

::: zone pivot="azure-cli,azure-resource-manager,bicep,azure-policy"

This script is only available for PowerShell-based deployments.

::: zone-end

## Enable monitoring using Azure Policy

Azure Policy allows you to enforce consistent monitoring across all VMs in a scope (management group, subscription, or resource group) by automatically deploying agents and associating DCRs to new and existing resources.

### Azure Policy initiatives

VM insights policy initiatives are predefined sets of policies that install the Azure Monitor agent and configure data collection. The following initiatives are available:

- **Enable Azure Monitor for VMs with Azure Monitoring Agent (AMA)** - For Azure virtual machines
- **Enable Azure Monitor for VMSS with Azure Monitoring Agent (AMA)** - For virtual machine scale sets
- **Enable Azure Monitor for Hybrid VMs with AMA** - For Arc-enabled servers

> [!IMPORTANT]
> The Dependency Agent and the Map experience in VM Insights will be retired on 30 June 2028. See the [retirement guidance](https://aka.ms/DependencyAgentRetirement) for more details. Set the **Enable Processes and Dependencies** parameter to false when assigning policy initiatives.

### Assign a policy initiative

Before you begin, ensure you have a DCR created for the monitoring configuration you want to apply. You'll need the DCR resource ID when assigning the policy.

To assign a VM insights policy initiative:

1. In the Azure portal, navigate to **Policy** > **Assignments** > **Assign initiative**.

2. Configure the **Basics** tab:
   - **Scope**: Select the management group, subscription, or resource group where the initiative will apply.
   - **Exclusions**: (Optional) Exclude specific resources from the initiative.
   - **Initiative definition**: Select one of the [VM insights initiatives](#azure-policy-initiatives).
   - **Assignment name**: Provide a descriptive name for the assignment.
   - **Policy enforcement**: Specify whether to enforce the policies or only evaluate compliance.

3. Configure the **Parameters** tab:
   - **Enable Processes and Dependencies**: Set to false (the Map feature is being retired).
   - **Bring Your Own User-Assigned Managed Identity**: 
     - When enabled, specify an existing managed identity for the agent to use.
     - When disabled, a managed identity is automatically created per region.
   - **User-Assigned Managed Identity settings**: If bringing your own identity, provide:
     - **Restrict Bring Your Own User-Assigned Identity to Subscription**: Enable if the identity is in the same subscription as the VMs.
     - **User-Assigned Managed Identity Resource ID**: Full resource ID (if not restricted to subscription).
     - **User-Assigned Managed Identity Name**: Identity name (if restricted to subscription).
     - **User-Assigned Managed Identity Resource Group**: Identity resource group (if restricted to subscription).
   - **VMI Data Collection Rule Resource Id**: Enter the resource ID of your DCR.
   - **Effect for all constituent policies**: Set to `DeployIfNotExists` to enable policy enforcement.
   - **Scope Policy to supported Operating Systems**: Enable to apply only to VMs with supported OS.

4. Configure the **Managed identity** tab:
   - Specify the managed identity that the policy engine will use to deploy resources. This is different from the agent's managed identity.

5. Review and create the assignment.

### Monitor policy compliance

After assigning an initiative, monitor compliance:

1. Navigate to **Monitor** > **Insights** > **Virtual machines** > **Overview** > **Other onboarding options**.

2. Under **Enable using policy**, select **Enable** to view the **Azure Monitor for VMs Policy Coverage** page.

   This page shows:
   - **Total VMs**: Number of VMs in the scope
   - **Assignment Coverage**: Percentage of VMs covered by the initiative
   - **Compliant VMs**: Number of VMs with agents installed and DCRs associated
   - **Compliance State**: Overall compliance status

3. Select the ellipsis (**...**) > **View Compliance** to see detailed compliance information.

4. Select an assignment to view the **Initiative compliance** page, which lists each policy definition and its compliance state.

Policy definitions are considered noncompliant if:
- Azure Monitor Agent isn't deployed on a VM
- VM operating system isn't supported or recognized
- DCR isn't associated with the VM

### Create a remediation task

For existing VMs that were present before the policy assignment, create remediation tasks to bring them into compliance:

1. On the **Initiative compliance** page, select a noncompliant policy definition.

2. Select **Create Remediation Task**.

3. Review **Remediation settings**:
   - **Scope**: Verify the scope for remediation (defaults to policy assignment scope)
   - **Policy definition**: The individual policy being remediated
   - **Resources to remediate**: Optional filters to target specific resources

4. Select **Remediate** to create the task.

5. Track remediation progress on the **Policy** > **Remediation** > **Remediation tasks** tab.

> [!NOTE]
> Remediation tasks must be created separately for each policy definition in the initiative. You cannot create a single remediation task for the entire initiative.

### Policy best practices for scale

When using Azure Policy for at-scale VM monitoring:

- **Use management groups**: Assign policies at the management group level for organization-wide enforcement
- **Share DCRs**: Reference the same DCR across multiple policy assignments for consistency
- **Plan for regional DCRs**: Create region-specific DCRs if your VMs span multiple regions (DCRs must be in the same region as the destination workspace)
- **Leverage exclusions**: Use exclusions for special-purpose VMs that require custom monitoring configurations
- **Monitor remediation**: Check remediation task status regularly to ensure compliance
- **Use resource selectors**: Target specific VM types or resource groups within a broader scope

Example policy assignment scenario for a multi-region deployment:

1. Create DCRs in each region (East US, West Europe) with the same configuration
2. Assign the VM insights initiative at the management group level
3. Use resource selectors to target VMs in each region with the appropriate regional DCR
4. Create remediation tasks after assignment to enable existing VMs
5. Monitor compliance and investigate non-compliant resources

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
