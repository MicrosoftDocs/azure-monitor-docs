---
title: Azure Monitor Agent Network Configuration
description: Learn how to define network settings and enable network isolation for the Azure Monitor Agent.
ms.topic: how-to
ms.date: 11/14/2024
ms.custom: references_regions
ms.reviewer: shseth

---
# Azure Monitor Agent network configuration

The Azure Monitor Agent supports connections by using direct proxies, a Log Analytics gateway, and private links. This article describes how to define network settings and enable network isolation for the Azure Monitor Agent.

## Virtual network service tags

[Azure Virtual Network service tags](/azure/virtual-network/service-tags-overview) must be enabled on the virtual network for the virtual machine (VM). Both `AzureMonitor` and `AzureResourceManager` tags are required. See the `AzureMonitor` entry in [Available service tags](/azure/virtual-network/service-tags-overview#available-service-tags) for any other requirements.

You can use Azure Virtual Network service tags to define network access controls on [network security groups](/azure/virtual-network/network-security-groups-overview#security-rules), [Azure Firewall](/azure/firewall/service-tags), and user-defined routes. Use service tags in place of specific IP addresses when you create security rules and routes. For scenarios where Azure Virtual Network service tags can't be used, the firewall requirements are described later in this article.

> [!NOTE]
> Data collection endpoint (DCE) public IP addresses aren't included in the network service tags you can use to define network access controls for Azure Monitor. If you have custom logs or Internet Information Services (IIS) log data collection rules (DCRs), consider allowing the DCE's public IP addresses. Doing so ensures the scenarios work until these scenarios are supported via network service tags.

## Firewall endpoints

The following table provides the endpoints that firewalls must provide access to for different clouds. Each endpoint is an outbound connection to port 443.

> [!IMPORTANT]
> For all endpoints, HTTPS inspection must be disabled.

| Endpoint | Purpose | Example |
|:---------|:--------|:--------|
| `global.handler.control.monitor.azure.com` | Access the control service | Not applicable |
| `global.prod.microsoftmetrics.com` | Access the metrics service | Not applicable |
| `<virtual-machine-region-name>.handler.control.monitor.azure.com` | Fetch DCRs for a specific machine | `westus2.handler.control.monitor.azure.com` |
|`<log-analytics-workspace-id>.ods.opinsights.azure.com` | Ingest log data | `1234a123-aa1a-123a-aaa1-a1a345aa6789.ods.opinsights.azure.com` |
| `management.azure.com` | Needed only if you send time series data (metrics) to an Azure Monitor [custom metrics](../metrics/metrics-custom-overview.md) database | Not applicable |
| `<virtual-machine-region-name>.monitoring.azure.com` | Needed only if you send time series data (metrics) to an Azure Monitor [custom metrics](../metrics/metrics-custom-overview.md) database | `westus2.monitoring.azure.com` |
| `<data-collection-endpoint>.<virtual-machine-region-name>.ingest.monitor.azure.com` |Ingest log data | `275test-01li.eastus2euap-1.canary.ingest.monitor.azure.com` |



Replace the suffix in the endpoints with the suffix in the following table for respective clouds:

| Cloud                                | Suffix |
|:-------------------------------------|:-------|
| Azure Commercial                     | `.com` |
| Azure Government                     | `.us`  |
| Microsoft Azure operated by 21Vianet | `.cn`  |

> [!NOTE]
>
> * If you use private links on the agent, you must add *only* [private DCEs](../data-collection/data-collection-endpoint-overview.md#components-of-a-dce). The agent doesn't use the nonprivate endpoints listed in the preceding table when you use private links or private DCEs.
>
> * The Azure Monitor metrics (custom metrics) preview isn't available in Azure Government and Azure operated by 21Vianet clouds.
>
> * When you use the Azure Monitor Agent with Azure Monitor Private Link Scope, all your DCRs must use DCEs. The DCEs must be added to the Azure Monitor Private Link Scope configuration via a [private link](../fundamentals/private-link-configure.md#connect-resources-to-the-ampls).

## Proxy configuration

The Azure Monitor Agent extensions for Windows and Linux can communicate either through a proxy server or through a [Log Analytics gateway](gateway.md) to Azure Monitor by using the HTTPS protocol. Use it for Azure VMs, scale sets, and Azure Arc for servers. Use the extensions settings for configuration as described in the following steps. Both anonymous authentication and basic authentication by using a username and password are supported.

> [!IMPORTANT]
> OMS Gateway isn't supported with Azure Arc-enabled servers for proxy connectivity, private link connectivity, and public endpoint connectivity options.

> [!IMPORTANT]
> Proxy configuration isn't supported for [Azure Monitor Metrics (preview)](../metrics/metrics-custom-overview.md) as a destination. If you send metrics to this destination, it uses the public internet without any proxy.

> [!NOTE]
> Setting Linux system proxy via environment variables like `http_proxy` and `https_proxy` is supported only when you use the Azure Monitor Agent for Linux version 1.24.2 or later. For the Azure Resource Manager template (ARM template), if you configure a proxy, use the ARM template shown here as an example of how to declare the proxy settings inside the ARM template. Also, a user can set global environment variables that get picked up by all systemd services [via the DefaultEnvironment variable in /etc/systemd/system.conf](https://www.man7.org/linux/man-pages/man5/systemd-system.conf.5.html).

Use Azure PowerShell commands in the following examples based on your environment and configuration.

# [Windows VM](#tab/PowerShellWindows)

**No proxy**

```azurepowershell
$settingsString = '{"proxy":{"mode":"none"}}';
Set-AzVMExtension -ExtensionName AzureMonitorWindowsAgent -ExtensionType AzureMonitorWindowsAgent -Publisher Microsoft.Azure.Monitor -ResourceGroupName <resource-group-name> -VMName <virtual-machine-name> -Location <location> -SettingString $settingsString
```

**Proxy with no authentication**

```azurepowershell
$settingsString = '{"proxy":{"mode":"application","address":"http://[address]:[port]","auth": "false"}}';
Set-AzVMExtension -ExtensionName AzureMonitorWindowsAgent -ExtensionType AzureMonitorWindowsAgent -Publisher Microsoft.Azure.Monitor -ResourceGroupName <resource-group-name> -VMName <virtual-machine-name> -Location <location> -SettingString $settingsString
```

**Proxy with authentication**

```azurepowershell
$settingsString = '{"proxy":{"mode":"application","address":"http://[address]:[port]","auth": "true"}}';
$protectedSettingsString = '{"proxy":{"username":"[username]","password": "[password]"}}';
Set-AzVMExtension -ExtensionName AzureMonitorWindowsAgent -ExtensionType AzureMonitorWindowsAgent -Publisher Microsoft.Azure.Monitor -ResourceGroupName <resource-group-name> -VMName <virtual-machine-name> -Location <location> -SettingString $settingsString -ProtectedSettingString $protectedSettingsString
```

**Revert Proxy configuration to defaults**

To restore proxy configuration to defaults, you could define $settingsString = '{}'; as in the following example:
```azurepowershell
$settingsString = '{}';
Set-AzVMExtension -ExtensionName AzureMonitorWindowsAgent -ExtensionType AzureMonitorWindowsAgent -Publisher Microsoft.Azure.Monitor -ResourceGroupName RESOURCE GROUP HERE -VMName VM NAME HERE -Location westeurope -> > SettingString $settingsString
```

# [Linux VM](#tab/PowerShellLinux)

**No proxy**

```azurepowershell
$settingsString = '{"proxy":{"mode":"none"}}';
Set-AzVMExtension -ExtensionName AzureMonitorLinuxAgent -ExtensionType AzureMonitorLinuxAgent -Publisher Microsoft.Azure.Monitor -ResourceGroupName <resource-group-name> -VMName <virtual-machine-name> -Location <location> -SettingString $settingsString
```

**Proxy with no authentication**

```azurepowershell
$settingsString = '{"proxy":{"mode":"application","address":"http://[address]:[port]","auth": "false"}}';
Set-AzVMExtension -ExtensionName AzureMonitorLinuxAgent -ExtensionType AzureMonitorLinuxAgent -Publisher Microsoft.Azure.Monitor -ResourceGroupName <resource-group-name> -VMName <virtual-machine-name> -Location <location> -SettingString $settingsString
```

**Proxy with authentication**

```azurepowershell
$settingsString = '{"proxy":{"mode":"application","address":"http://[address]:[port]","auth": "true"}}';
$protectedSettingsString = '{"proxy":{"username":"[username]","password": "[password]"}}';
Set-AzVMExtension -ExtensionName AzureMonitorLinuxAgent -ExtensionType AzureMonitorLinuxAgent -Publisher Microsoft.Azure.Monitor -ResourceGroupName <resource-group-name> -VMName <virtual-machine-name> -Location <location> -SettingString $settingsString -ProtectedSettingString $protectedSettingsString
```

# [Windows Arc-enabled server](#tab/PowerShellWindowsArc)

**No proxy**

```azurepowershell
$settings = @{"proxy" = @{mode = "none"}}
New-AzConnectedMachineExtension -Name AzureMonitorWindowsAgent -ExtensionType AzureMonitorWindowsAgent -Publisher Microsoft.Azure.Monitor -ResourceGroupName <resource-group-name> -MachineName <arc-server-name> -Location <arc-server-location> -Setting $settings
```

**Proxy with no authentication**

```azurepowershell
$settings = @{"proxy" = @{mode = "application"; address = "http://[address]:[port]"; auth = "false"}}
New-AzConnectedMachineExtension -Name AzureMonitorWindowsAgent -ExtensionType AzureMonitorWindowsAgent -Publisher Microsoft.Azure.Monitor -ResourceGroupName <resource-group-name> -MachineName <arc-server-name> -Location <arc-server-location> -Setting $settings 
```

**Proxy with authentication**

```azurepowershell
$settings = @{"proxy" = @{mode = "application"; address = "http://[address]:[port]"; auth = "true"}}
$protectedSettings = @{"proxy" = @{username = "[username]"; password = "[password]"}}
New-AzConnectedMachineExtension -Name AzureMonitorWindowsAgent -ExtensionType AzureMonitorWindowsAgent -Publisher Microsoft.Azure.Monitor -ResourceGroupName <resource-group-name> -MachineName <arc-server-name> -Location <arc-server-location> -Setting $settings -ProtectedSetting $protectedSettings
```

**Revert Proxy configuration to defaults**

To restore proxy configuration to defaults, you could define $settingsString = '{}'; as in the following example:
```azurepowershell
$settings = '{}';
New-AzConnectedMachineExtension -Name AzureMonitorWindowsAgent -ExtensionType AzureMonitorWindowsAgent -Publisher Microsoft.Azure.Monitor -ResourceGroupName <resource-group-name> -MachineName <arc-server-name> -Location <arc-server-location> -Setting $settings
```

# [Linux Arc-enabled server](#tab/PowerShellLinuxArc)

**No proxy**

```azurepowershell
$settings = @{"proxy" = @{mode = "none"}}
New-AzConnectedMachineExtension -Name AzureMonitorLinuxAgent -ExtensionType AzureMonitorLinuxAgent -Publisher Microsoft.Azure.Monitor -ResourceGroupName <resource-group-name> -MachineName <arc-server-name> -Location <arc-server-location> -Setting $settings
```

**Proxy with no authentication**

```azurepowershell
$settings = @{"proxy" = @{mode = "application"; address = "http://[address]:[port]"; auth = "false"}}
New-AzConnectedMachineExtension -Name AzureMonitorLinuxAgent -ExtensionType AzureMonitorLinuxAgent -Publisher Microsoft.Azure.Monitor -ResourceGroupName <resource-group-name> -MachineName <arc-server-name> -Location <arc-server-location> -Setting $settings 
```

**Proxy with authentication**

```azurepowershell
$settings = @{"proxy" = @{mode = "application"; address = "http://[address]:[port]"; auth = "true"}}
$protectedSettings = @{"proxy" = @{username = "[username]"; password = "[password]"}}
New-AzConnectedMachineExtension -Name AzureMonitorLinuxAgent -ExtensionType AzureMonitorLinuxAgent -Publisher Microsoft.Azure.Monitor -ResourceGroupName <resource-group-name> -MachineName <arc-server-name> -Location <arc-server-location> -Setting $settings -ProtectedSetting $protectedSettings
```

# [Azure Resource Manager policy template example](#tab/ArmPolicy)

```json
{
  "properties": {
    "displayName": "Configure Windows Arc-enabled machines to run the Azure Monitor Agent",
    "policyType": "BuiltIn",
    "mode": "Indexed",
    "description": "Automate the deployment of the Azure Monitor Agent extension on your Windows Arc-enabled machines for collecting telemetry data from the guest OS. This policy installs the extension if the OS and region are supported and system-assigned managed identity is enabled, and skips install otherwise. Learn more at https://aka.ms/AMAOverview.",
    "metadata": {
      "version": "2.3.0",
      "category": "Monitoring"
    },
    "parameters": {
      "effect": {
        "type": "String",
        "metadata": {
          "displayName": "Effect",
          "description": "Enable or disable the execution of the policy."
        },
        "allowedValues": [
          "DeployIfNotExists",
          "Disabled"
        ],
        "defaultValue": "DeployIfNotExists"
      }
    },
    "policyRule": {
      "if": {
        "allOf": [
          {
            "field": "type",
            "equals": "Microsoft.HybridCompute/machines"
          },
          {
            "field": "Microsoft.HybridCompute/machines/osName",
            "equals": "Windows"
          },
          {
            "field": "location",
            "in": [
              "australiacentral",
              "australiaeast",
              "australiasoutheast",
              "brazilsouth",
              "canadacentral",
              "canadaeast",
              "centralindia",
              "centralus",
              "eastasia",
              "eastus",
              "eastus2",
              "eastus2euap",
              "francecentral",
              "germanywestcentral",
              "japaneast",
              "japanwest",
              "jioindiawest",
              "koreacentral",
              "koreasouth",
              "northcentralus",
              "northeurope",
              "norwayeast",
              "southafricanorth",
              "southcentralus",
              "southeastasia",
              "southindia",
              "swedencentral",
              "switzerlandnorth",
              "uaenorth",
              "uksouth",
              "ukwest",
              "westcentralus",
              "westeurope",
              "westindia",
              "westus",
              "westus2",
              "westus3"
            ]
          }
        ]
      },
      "then": {
        "effect": "[parameters('effect')]",
        "details": {
          "type": "Microsoft.HybridCompute/machines/extensions",
          "roleDefinitionIds": [
            "/providers/Microsoft.Authorization/roleDefinitions/cd570a14-e51a-42ad-bac8-bafd67325302"
          ],
          "existenceCondition": {
            "allOf": [
              {
                "field": "Microsoft.HybridCompute/machines/extensions/type",
                "equals": "AzureMonitorWindowsAgent"
              },
              {
                "field": "Microsoft.HybridCompute/machines/extensions/publisher",
                "equals": "Microsoft.Azure.Monitor"
              },
              {
                "field": "Microsoft.HybridCompute/machines/extensions/provisioningState",
                "equals": "Succeeded"
              }
            ]
          },
          "deployment": {
            "properties": {
              "mode": "incremental",
              "template": {
                "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                "contentVersion": "1.0.0.0",
                "parameters": {
                  "vmName": {
                    "type": "string"
                  },
                  "location": {
                    "type": "string"
                  }
                },
                "variables": {
                  "extensionName": "AzureMonitorWindowsAgent",
                  "extensionPublisher": "Microsoft.Azure.Monitor",
                  "extensionType": "AzureMonitorWindowsAgent"
                },
                "resources": [
                  {
                    "name": "[concat(parameters('vmName'), '/', variables('extensionName'))]",
                    "type": "Microsoft.HybridCompute/machines/extensions",
                    "location": "[parameters('location')]",
                    "apiVersion": "2021-05-20",
                    "properties": {
                      "publisher": "[variables('extensionPublisher')]",
                      "type": "[variables('extensionType')]",
                      "autoUpgradeMinorVersion": true,
                      "enableAutomaticUpgrade": true,
                      "settings": {
                      "proxy": {
                        "auth": "false",
                        "mode": "application",
                        "address": "http://XXX.XXX.XXX.XXX"
                        }
                      },
                 "protectedsettings": { }
                    }
                  }
                ]
              },
              "parameters": {
                "vmName": {
                  "value": "[field('name')]"
                },
                "location": {
                  "value": "[field('location')]"
                }
              }
            }
          }
        }
      }
    }
  },
  "id": "/providers/Microsoft.Authorization/policyDefinitions/94f686d6-9a24-4e19-91f1-de937dc171a4",
  "type": "Microsoft.Authorization/policyDefinitions",
  "name": "94f686d6-9a24-4e19-91f1-de937dc171a4"
}
```

---

## Log Analytics gateway configuration

1. Follow the preceding guidance to configure proxy settings on the agent and provide the IP address and port number that correspond to the gateway server. If you deployed multiple gateway servers behind a load balancer, for the agent proxy configuration, instead use the virtual IP address of the load balancer.

1. Add the configuration endpoint URL to fetch DCRs to the allow list for the gateway:

    1. Run `Add-OMSGatewayAllowedHost -Host global.handler.control.monitor.azure.com`.
    1. Run `Add-OMSGatewayAllowedHost -Host <gateway-server-region-name>.handler.control.monitor.azure.com`.

    (If you use private links on the agent, you must also add the [DCEs](../data-collection/data-collection-endpoint-overview.md#components-of-a-dce).)

1. Add the data ingestion endpoint URL to the allow list for the gateway:

    * Run `Add-OMSGatewayAllowedHost -Host <log-analytics-workspace-id>.ods.opinsights.azure.com`.

1. To apply the changes, restart the Log Analytics gateway (*OMS Gateway*) service:

    1. Run `Stop-Service -Name <gateway-name>`.
    1. Run `Start-Service -Name <gateway-name>`.

## Related content

* Learn how to [add an endpoint to an Azure Monitor Private Link Scope resource](../fundamentals/private-link-configure.md#connect-ampls-to-a-private-endpoint).
