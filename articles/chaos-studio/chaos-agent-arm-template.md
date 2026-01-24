---
title: Resource Manager template samples for agents in Chaos Studio
description: Sample Azure Resource Manager templates to deploy and configure virtual machine agents in Chaos Studio.
services: chaos-studio
author: nikhilkaul-msft
ms.topic: sample
ms.date: 03/03/2025
ms.author: nikhilkaul
ms.reviewer: nikhilkaul
---

# Resource Manager template samples for agents in Chaos Studio

This article includes a sample [Azure Resource Manager template](/azure/azure-resource-manager/templates/syntax) to deploy and configure the [Chaos Agent](./chaos-agent-overview.md) on Azure virtual machine scale sets using a user-assigned managed identity. The sample deploys the Chaos Agent extension with all capabilities enabled on a VM scale set.

## Chaos Agent

The sample in this section installs the Chaos Agent on a virtual machine scale set with all capabilities turned on. The Chaos Agent extension is deployed via an ARM template and leverages a user-assigned managed identity for authentication.

### Prerequisites

To use the template below, you'll need:
- To [create a user-assigned managed identity](/azure/active-directory/managed-identities-azure-resources/how-manage-user-assigned-managed-identities) and assign it to your virtual machine scale set.
- To have an existing virtual machine scale set in your target region.
- To ensure that the target scale set is configured to use user-assigned managed identities for authenticating with Chaos Studio.

### Permissions required

| Built-in Role | Scope(s) | Reason |
|:---|:---|:---|
| [Virtual Machine Reader](/azure/role-based-access-control/built-in-roles#virtual-machine-reader) | Virtual machine scale sets | To deploy the Chaos Agent extension and configure scale set settings |
| Any role that includes the action *Microsoft.Resources/deployments/* | Subscription, resource group, or specific resource scope | To deploy ARM templates |

### Azure Virtual Machine Scale Set

The following sample installs the Chaos Agent on an Azure virtual machine scale set. The template deploys the Chaos target, configures the scale set with user-assigned identities, installs the Chaos Agent extension, and then enables all available Chaos agent capabilities.

#### Template file

# [JSON](#tab/json)

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "resources": [
        {
            "type": "Microsoft.Chaos/targets",
            "apiVersion": "2024-01-01",
            "name": "Microsoft-Agent",
            "location": "<location>",
            "properties": {
                "identities": [
                    {
                        "type": "AzureManagedIdentity",
                        "clientId": "<managed-identity-client-id>",
                        "tenantId": "<tenant-id>"
                    }
                ]
            },
            "scope": "microsoft.compute/virtualmachinescalesets/<vmss-name>"
        },
        {
            "type": "microsoft.compute/virtualmachinescalesets",
            "apiVersion": "2021-07-01",
            "name": "<vmss-name>",
            "location": "<location>",
            "identity": {
                "userAssignedIdentities": {
                    "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.ManagedIdentity/userAssignedIdentities/<userAssignedIdentity1>": {
                        "principalId": "<principal-id-1>",
                        "clientId": "<client-id-1>"
                    },
                    "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.ManagedIdentity/userAssignedIdentities/<userAssignedIdentity2>": {}
                },
                "type": "UserAssigned"
            }
        },
        {
            "type": "microsoft.compute/virtualmachinescalesets/extensions",
            "apiVersion": "2021-07-01",
            "name": "<vmss-name>/ChaosAgent",
            "location": "<location>",
            "dependsOn": [
                "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Compute/virtualMachineScaleSets/<vmss-name>",
                "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Compute/virtualMachineScaleSets/<vmss-name>/providers/Microsoft.Chaos/targets/Microsoft-Agent"
            ],
            "properties": {
                "publisher": "Microsoft.Azure.Chaos",
                "type": "ChaosLinuxAgent",
                "autoUpgradeMinorVersion": true,
                "enableAutomaticUpgrade": false,
                "typeHandlerVersion": "1.0",
                "settings": {
                    "profile": "[reference('/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Compute/virtualMachineScaleSets/<vmss-name>/providers/Microsoft.Chaos/targets/Microsoft-Agent').agentProfileId]",
                    "auth.msi.clientid": "<managed-identity-client-id>",
                    "appinsightskey": ""
                }
            }
        },
        {
            "type": "Microsoft.Chaos/targets/capabilities",
            "apiVersion": "2024-01-01",
            "name": "Microsoft-Agent/StressNg-1.0",
            "location": "<location>",
            "dependsOn": [
                "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Compute/virtualMachineScaleSets/<vmss-name>/providers/Microsoft.Chaos/targets/Microsoft-Agent"
            ],
            "properties": {},
            "scope": "microsoft.compute/virtualmachinescalesets/<vmss-name>"
        },
        {
            "type": "Microsoft.Chaos/targets/capabilities",
            "apiVersion": "2024-01-01",
            "name": "Microsoft-Agent/CPUPressure-1.0",
            "location": "<location>",
            "dependsOn": [
                "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Compute/virtualMachineScaleSets/<vmss-name>/providers/Microsoft.Chaos/targets/Microsoft-Agent"
            ],
            "properties": {},
            "scope": "microsoft.compute/virtualmachinescalesets/<vmss-name>"
        },
        {
            "type": "Microsoft.Chaos/targets/capabilities",
            "apiVersion": "2024-01-01",
            "name": "Microsoft-Agent/LinuxDiskIOPressure-1.1",
            "location": "<location>",
            "dependsOn": [
                "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Compute/virtualMachineScaleSets/<vmss-name>/providers/Microsoft.Chaos/targets/Microsoft-Agent"
            ],
            "properties": {},
            "scope": "microsoft.compute/virtualmachinescalesets/<vmss-name>"
        },
        {
            "type": "Microsoft.Chaos/targets/capabilities",
            "apiVersion": "2024-01-01",
            "name": "Microsoft-Agent/DiskIOPressure-1.1",
            "location": "<location>",
            "dependsOn": [
                "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Compute/virtualMachineScaleSets/<vmss-name>/providers/Microsoft.Chaos/targets/Microsoft-Agent"
            ],
            "properties": {},
            "scope": "microsoft.compute/virtualmachinescalesets/<vmss-name>"
        },
        {
            "type": "Microsoft.Chaos/targets/capabilities",
            "apiVersion": "2024-01-01",
            "name": "Microsoft-Agent/DnsFailure-1.0",
            "location": "<location>",
            "dependsOn": [
                "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Compute/virtualMachineScaleSets/<vmss-name>/providers/Microsoft.Chaos/targets/Microsoft-Agent"
            ],
            "properties": {},
            "scope": "microsoft.compute/virtualmachinescalesets/<vmss-name>"
        },
        {
            "type": "Microsoft.Chaos/targets/capabilities",
            "apiVersion": "2024-01-01",
            "name": "Microsoft-Agent/KillProcess-1.0",
            "location": "<location>",
            "dependsOn": [
                "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Compute/virtualMachineScaleSets/<vmss-name>/providers/Microsoft.Chaos/targets/Microsoft-Agent"
            ],
            "properties": {},
            "scope": "microsoft.compute/virtualmachinescalesets/<vmss-name>"
        },
        {
            "type": "Microsoft.Chaos/targets/capabilities",
            "apiVersion": "2024-01-01",
            "name": "Microsoft-Agent/NetworkDisconnect-1.1",
            "location": "<location>",
            "dependsOn": [
                "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Compute/virtualMachineScaleSets/<vmss-name>/providers/Microsoft.Chaos/targets/Microsoft-Agent"
            ],
            "properties": {},
            "scope": "microsoft.compute/virtualmachinescalesets/<vmss-name>"
        },
        {
            "type": "Microsoft.Chaos/targets/capabilities",
            "apiVersion": "2024-01-01",
            "name": "Microsoft-Agent/NetworkDisconnectViaFirewall-1.0",
            "location": "<location>",
            "dependsOn": [
                "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Compute/virtualMachineScaleSets/<vmss-name>/providers/Microsoft.Chaos/targets/Microsoft-Agent"
            ],
            "properties": {},
            "scope": "microsoft.compute/virtualmachinescalesets/<vmss-name>"
        },
        {
            "type": "Microsoft.Chaos/targets/capabilities",
            "apiVersion": "2024-01-01",
            "name": "Microsoft-Agent/NetworkIsolation-1.0",
            "location": "<location>",
            "dependsOn": [
                "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Compute/virtualMachineScaleSets/<vmss-name>/providers/Microsoft.Chaos/targets/Microsoft-Agent"
            ],
            "properties": {},
            "scope": "microsoft.compute/virtualmachinescalesets/<vmss-name>"
        },
        {
            "type": "Microsoft.Chaos/targets/capabilities",
            "apiVersion": "2024-01-01",
            "name": "Microsoft-Agent/NetworkLatency-1.1",
            "location": "<location>",
            "dependsOn": [
                "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Compute/virtualMachineScaleSets/<vmss-name>/providers/Microsoft.Chaos/targets/Microsoft-Agent"
            ],
            "properties": {},
            "scope": "microsoft.compute/virtualmachinescalesets/<vmss-name>"
        },
        {
            "type": "Microsoft.Chaos/targets/capabilities",
            "apiVersion": "2024-01-01",
            "name": "Microsoft-Agent/NetworkPacketLoss-1.0",
            "location": "<location>",
            "dependsOn": [
                "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Compute/virtualMachineScaleSets/<vmss-name>/providers/Microsoft.Chaos/targets/Microsoft-Agent"
            ],
            "properties": {},
            "scope": "microsoft.compute/virtualmachinescalesets/<vmss-name>"
        },
        {
            "type": "Microsoft.Chaos/targets/capabilities",
            "apiVersion": "2024-01-01",
            "name": "Microsoft-Agent/PauseProcess-1.0",
            "location": "<location>",
            "dependsOn": [
                "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Compute/virtualMachineScaleSets/<vmss-name>/providers/Microsoft.Chaos/targets/Microsoft-Agent"
            ],
            "properties": {},
            "scope": "microsoft.compute/virtualmachinescalesets/<vmss-name>"
        },
        {
            "type": "Microsoft.Chaos/targets/capabilities",
            "apiVersion": "2024-01-01",
            "name": "Microsoft-Agent/PhysicalMemoryPressure-1.0",
            "location": "<location>",
            "dependsOn": [
                "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Compute/virtualMachineScaleSets/<vmss-name>/providers/Microsoft.Chaos/targets/Microsoft-Agent"
            ],
            "properties": {},
            "scope": "microsoft.compute/virtualmachinescalesets/<vmss-name>"
        },
        {
            "type": "Microsoft.Chaos/targets/capabilities",
            "apiVersion": "2024-01-01",
            "name": "Microsoft-Agent/StopService-1.0",
            "location": "<location>",
            "dependsOn": [
                "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Compute/virtualMachineScaleSets/<vmss-name>/providers/Microsoft.Chaos/targets/Microsoft-Agent"
            ],
            "properties": {},
            "scope": "microsoft.compute/virtualmachinescalesets/<vmss-name>"
        },
        {
            "type": "Microsoft.Chaos/targets/capabilities",
            "apiVersion": "2024-01-01",
            "name": "Microsoft-Agent/TimeChange-1.0",
            "location": "<location>",
            "dependsOn": [
                "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Compute/virtualMachineScaleSets/<vmss-name>/providers/Microsoft.Chaos/targets/Microsoft-Agent"
            ],
            "properties": {},
            "scope": "microsoft.compute/virtualmachinescalesets/<vmss-name>"
        },
        {
            "type": "Microsoft.Chaos/targets/capabilities",
            "apiVersion": "2024-01-01",
            "name": "Microsoft-Agent/VirtualMemoryPressure-1.0",
            "location": "<location>",
            "dependsOn": [
                "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Compute/virtualMachineScaleSets/<vmss-name>/providers/Microsoft.Chaos/targets/Microsoft-Agent"
            ],
            "properties": {},
            "scope": "microsoft.compute/virtualmachinescalesets/<vmss-name>"
        }
    ]
}
```
