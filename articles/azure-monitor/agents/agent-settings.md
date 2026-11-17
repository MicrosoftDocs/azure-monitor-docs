---
title: Azure Monitor Agent Configuration
description: Learn how to change Azure Monitor Agent configuration settings, including proxy, performance, and logging options on Azure VMs and Arc-enabled servers.
ms.topic: install-set-up-deploy
ms.date: 11/16/2026
ms.custom: devx-track-azurepowershell, devx-track-azurecli
ms.reviewer: shseth, nmangum
ai-usage: ai-assisted

---

# Configure agents with Azure Monitor Agent settings

This article describes how to configure the [Azure Monitor Agent](azure-monitor-agent-overview.md) on Azure Virtual Machines (VMs), Virtual Machine Scale Sets, and Azure Arc-enabled servers. Many applications and services log telemetry by using the Azure Monitor Agent. You can configure Azure Monitor Agents by using the central control plane and creating the Agent Settings Data Collection Rule (DCR).

## Prerequisites

Prerequisites are listed in [Collect data from virtual machine client with Azure Monitor](../vm/data-collection.md#prerequisites).

## Considerations

When you work with the Agent Settings DCR:

* Currently, an Azure Resource Manager template is the only way to create Agent Settings.
* Agent Settings is a standalone DCR with no other collection sources.
* The most recent Agent Settings DCR applied to the VM overrides all other Agent Settings DCRs.

### Supported parameters

The Agent Settings DCR supports the following parameters:

These settings configure the Azure Monitor Agent and are organized by telemetry type. In the DCR JSON, add each setting to either the `properties.agentSettings.logs` or `properties.agentSettings.metrics` collection, as indicated in the following table.

| Telemetry type | Agent Settings collection | Setting name | Supported values and validation | Description |
|:---|:---|:---|:---|:---|
| General | `logs` | `MaxDiskQuotaInMB` | Integer from 4,000 through 1,000,000. Default is 10,000 MB on Windows and 10,240 MB on Linux. | Sets the local log-cache quota on Windows and Linux. The cache grows if cloud connectivity is lost, and the agent sends data after connectivity is restored. The agent loses data that exceeds the cache limit. On Linux, the effective log-buffer quota uses a percentage of the configured value, as described in `DiskQuotaUsageInPercent`. |
| Logs | `logs` | `UseTimeReceivedForForwardedEvents` | `0` or `1`. `0` uses `TimeGenerated`; `1` uses `TimeReceived`. | Windows only. Controls the timestamp behavior for Microsoft Sentinel Windows Event Forwarding (WEF) data. |
| General | `logs` | `Tags` | Any non-empty string. The service doesn't validate the format or delimiter. | Controls agent behavior through recognized feature flags. This setting isn't a general-purpose tagging mechanism. |
| General | `logs` | `DiskQuotaUsageInPercent` | Integer from 50 through 100. | Linux only. Percentage of `MaxDiskQuotaInMB` used for the log-buffer quota. Specify both settings in the same Agent Settings DCR. If this setting is omitted, the agent uses a percentage based on the configured quota size. |
| Logs and traces | `logs` | `OtlpGrpcLogsTracesPort` | Integer TCP port from 1,024 through 65,535. Must be unique across all OTLP port settings in the DCR. | Overrides the OTLP gRPC listener port for logs and traces. |
| Logs and traces | `logs` | `OtlpHttpProtobufLogsTracesPort` | Integer TCP port from 1,024 through 65,535. Must be unique across all OTLP port settings in the DCR. | Overrides the OTLP HTTP/Protobuf listener port for logs and traces. |
| Metrics | `metrics` | `OtlpGrpcMetricsPort` | Integer TCP port from 1,024 through 65,535. Must be unique across all OTLP port settings in the DCR. | Overrides the OTLP gRPC listener port for metrics. |
| Metrics | `metrics` | `OtlpHttpProtobufMetricsPort` | Integer TCP port from 1,024 through 65,535. Must be unique across all OTLP port settings in the DCR. | Overrides the OTLP HTTP/Protobuf listener port for metrics. |

> [!NOTE]
> OTLP port settings require DCR API version `2025-05-11` or later. OTLP metrics port settings require Azure Monitor Agent version 1.45 or later on both Windows and Linux.

To use the OTLP metrics listeners, also associate a DCR that enables the corresponding metrics collection. An Agent Settings DCR alone doesn't enable metrics collection. Explicit environment-variable or command-line settings for metrics ports take precedence over DCR settings.

### Create an Agent Settings DCR

#### [Azure portal](#tab/azure-portal)

Currently not supported.

#### [Azure PowerShell](#tab/azure-powershell)

Currently not supported.

#### [Azure CLI](#tab/azure-cli)

Currently not supported.

#### [Resource Manager template](#tab/azure-resource-manager)

1. Prepare the environment by installing the Azure Monitor Agent on your VM.

1. Create the Agent Settings DCR.

The following example shows settings in both the `logs` and `metrics` categories, including overrides for the OTLP logs, traces, and metrics listener ports. Include only settings that apply to your operating system and collection scenario.

**Step 1** - Use the search bar to find the **Deploy a custom template** option.

:::image type="content" source="./media/agent-settings/azure-monitor-agent-deploy-template-portal.png" Lightbox="./media/agent-settings/azure-monitor-agent-deploy-template-portal.png" alt-text="Screenshot that shows the custom template in the search bar in the Azure portal.":::
 
**Step 2** – Select **Build your own template in the editor**.

:::image type="content" source="./media/agent-settings/azure-monitor-agent-data-collection-rule-edit-template-portal.png" lightbox="./media/agent-settings/azure-monitor-agent-data-collection-rule-edit-template-portal.png" alt-text="Screenshot that shows how to open the template editor in the Azure portal.":::
 
 **Step 3** – Delete the existing JSON in the template editor and copy the JSON code into the editor. Make sure you modify the parameters in the JSON in the editor to meet your needs.

:::image type="content" source="./media/agent-settings/azure-monitor-agent-data-collection-rule-paste-template-portal.png" lightbox="./media/agent-settings/azure-monitor-agent-data-collection-rule-paste-template-portal.png" alt-text="Screenshot that shows how to open the custom template editor in the Azure portal.":::

Here's example JSON code to create the Agent Settings DCR:

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "region": {
            "defaultValue": "eastus",
            "type": "string"
        },
        "dcrName": {
            "defaultValue": "myDcrName",
            "type": "string"
        },
        "maxDiskQuota": {
            "defaultValue": "5000",
            "type": "string"
        },
        "useTimeReceivedForForwardedEvents": {
            "defaultValue": "0",
            "type": "string"
        },
        "diskQuotaUsageInPercent": {
            "defaultValue": "80",
            "type": "string"
        },
        "otlpGrpcLogsTracesPort": {
            "defaultValue": "14319",
            "type": "string"
        },
        "otlpHttpProtobufLogsTracesPort": {
            "defaultValue": "14320",
            "type": "string"
        },
        "otlpGrpcMetricsPort": {
            "defaultValue": "15317",
            "type": "string"
        },
        "otlpHttpProtobufMetricsPort": {
            "defaultValue": "15318",
            "type": "string"
        }
    },
    "resources": [

        {
            "type": "Microsoft.Insights/dataCollectionRules",
            "kind": "AgentSettings",
            "location": "[parameters('region')]",
            "name": "[parameters('dcrName')]",
            "apiVersion": "2025-05-11",
            "properties": {
                "description": "Simple agent settings",
                "agentSettings": {
                    "logs": [
                        {
                            "name": "MaxDiskQuotaInMB",
                            "value": "[parameters('maxDiskQuota')]"
                        },
                        {
                            "name": "UseTimeReceivedForForwardedEvents",
                            "value": "[parameters('useTimeReceivedForForwardedEvents')]"
                        },
                        {
                            "name": "DiskQuotaUsageInPercent",
                            "value": "[parameters('diskQuotaUsageInPercent')]"
                        },
                        {
                            "name": "OtlpGrpcLogsTracesPort",
                            "value": "[parameters('otlpGrpcLogsTracesPort')]"
                        },
                        {
                            "name": "OtlpHttpProtobufLogsTracesPort",
                            "value": "[parameters('otlpHttpProtobufLogsTracesPort')]"
                        }
                    ],
                    "metrics": [
                        {
                            "name": "OtlpGrpcMetricsPort",
                            "value": "[parameters('otlpGrpcMetricsPort')]"
                        },
                        {
                            "name": "OtlpHttpProtobufMetricsPort",
                            "value": "[parameters('otlpHttpProtobufMetricsPort')]"
                        }
                    ]
                }
            }
        }
    ]
}
```

Validate and deploy the template. Make sure that you don't get any errors.

**Step 4** - Associate the DCR with a virtual machine go to the **Deploy a custom template in the editor** option again. Delete the existing JSON in the template editor and copy the JSON code into the editor. To meet your VM name and DCR resource, make sure you modify the items in the parameters section. You can copy the resource ID by going to the DCR and selecting the JSON View in the upper right corner. Use the **Copy to clipboard** option and then paste it into the template. For the `vmName`, use the string name of the VM.

:::image type="content" source="./media/agent-settings/azure-monitor-agent-data-collection-rule-resource-portal.png" lightbox="./media/agent-settings/azure-monitor-agent-data-collection-rule-resource-portal.png" alt-text="Screenshot that shows how to copy the DCR resource ID from the DCR json in the Azure portal.":::

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "vmName": {
      "type": "string",
      "defaultValue":"WindowsM1",
      "metadata": {
        "description": "The name of the virtual machine."
      }
    },
    "dataCollectionResourceId": {
      "type": "string",
      "defaultValue": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/ContosoAdmin/providers/Microsoft.Insights/dataCollectionRules/myDcrName",
      "metadata": {
        "description": "The resource ID of the data collection rule."
      }
    }
  },
  "resources": [
    {
      "type": "Microsoft.Insights/dataCollectionRuleAssociations",
      "apiVersion": "2021-09-01-preview",
      "scope": "[format('Microsoft.Compute/virtualMachines/{0}', parameters('vmName'))]",
      "name": "agentSettings",
      "properties": {
        "description": "Association of data collection rule. Deleting this association will break the data collection for this virtual machine.",
        "dataCollectionRuleId": "[parameters('dataCollectionResourceId')]"
      }
    }
  ]
}
```

Validate and deploy the template. Make sure you don't get any errors.

**Step 5** – Allow AMA to refresh its configuration. OTLP metrics port changes apply automatically and don't require a full AMA restart.

---

## Related content

[Create a data collection rule](../vm/data-collection.md) to collect data from the agent and send it to Azure Monitor.
