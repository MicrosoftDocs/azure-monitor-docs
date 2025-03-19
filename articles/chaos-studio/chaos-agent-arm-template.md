---
title: Resource Manager template samples for agents in Chaos Studio
description: Sample Azure Resource Manager templates to deploy and configure virtual machine agents in Chaos Studio.
ms.topic: sample
ms.custom: devx-track-arm-template
ms.date: 11/14/2024
ms.reviewer: jeffwo
---

# Resource Manager template samples for agents in Chaos Studio

This article includes a sample [Azure Resource Manager template](/azure/azure-resource-manager/templates/syntax) to deploy and configure the [Chaos Agent](./chaos-agent-overview.md) on Azure virtual machine scale sets using a user-assigned managed identity. The sample deploys the Chaos Agent extension with all capabilities enabled on a VM scale set.

[!INCLUDE [chaos-studio-samples](../../../includes/chaos-studio-resource-manager-samples.md)]

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
| [Virtual Machine Contributor](/azure/role-based-access-control/built-in-roles#virtual-machine-contributor) | Virtual machine scale sets | To deploy the Chaos Agent extension and configure scale set settings |
| Any role that includes the action *Microsoft.Resources/deployments/* | Subscription, resource group, or specific resource scope | To deploy ARM templates |

### Azure Virtual Machine Scale Set

The following sample installs the Chaos Agent on an Azure virtual machine scale set. The template deploys the Chaos target, configures the scale set with user-assigned identities, installs the Chaos Agent extension, and then enables all available Chaos capabilities.

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
            "location": "eastus2",
            "properties": {
                "identities": [
                    {
                        "type": "AzureManagedIdentity",
                        "clientId": "47c4b0b3-35ee-49ce-9e85-e52fc889cec2",
                        "tenantId": "72f988bf-86f1-41af-91ab-2d7cd011db47"
                    }
                ]
            },
            "scope": "microsoft.compute/virtualmachinescalesets/adi-vmss"
        },
        {
            "type": "microsoft.compute/virtualmachinescalesets",
            "apiVersion": "2021-07-01",
            "name": "adi-vmss",
            "location": "eastus2",
            "identity": {
                "userAssignedIdentities": {
                    "/subscriptions/fb74b135-894b-4c1d-9b2e-8a3c231abc14/resourceGroups/AzSecPackAutoConfigRG/providers/Microsoft.ManagedIdentity/userAssignedIdentities/AzSecPackAutoConfigUA-eastus2": {
                        "principalId": "695c83e6-7716-433c-8dc3-7710acb317f4",
                        "clientId": "a5123606-81d6-4dff-8c8b-b70fd7c42d23"
                    },
                    "/subscriptions/20637940-1bd7-4e44-babd-d4a4c98d09de/resourceGroups/jduan-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/agent-msi": {}
                },
                "type": "UserAssigned"
            }
        },
        {
            "type": "microsoft.compute/virtualmachinescalesets/extensions",
            "apiVersion": "2021-07-01",
            "name": "adi-vmss/ChaosAgent",
            "location": "eastus2",
            "dependsOn": [
                "/subscriptions/fb74b135-894b-4c1d-9b2e-8a3c231abc14/resourceGroups/rg-adi/providers/Microsoft.Compute/virtualMachineScaleSets/adi-vmss",
                "/subscriptions/fb74b135-894b-4c1d-9b2e-8a3c231abc14/resourceGroups/rg-adi/providers/Microsoft.Compute/virtualMachineScaleSets/adi-vmss/providers/Microsoft.Chaos/targets/Microsoft-Agent"
            ],
            "properties": {
                "publisher": "Microsoft.Azure.Chaos",
                "type": "ChaosLinuxAgent",
                "autoUpgradeMinorVersion": true,
                "enableAutomaticUpgrade": false,
                "typeHandlerVersion": "1.0",
                "settings": {
                    "profile": "[reference('/subscriptions/fb74b135-894b-4c1d-9b2e-8a3c231abc14/resourceGroups/rg-adi/providers/Microsoft.Compute/virtualMachineScaleSets/adi-vmss/providers/Microsoft.Chaos/targets/Microsoft-Agent').agentProfileId]",
                    "auth.msi.clientid": "47c4b0b3-35ee-49ce-9e85-e52fc889cec2",
                    "appinsightskey": ""
                }
            }
        },
        {
            "type": "Microsoft.Chaos/targets/capabilities",
            "apiVersion": "2024-01-01",
            "name": "Microsoft-Agent/StressNg-1.0",
            "location": "eastus2",
            "dependsOn": [
                "/subscriptions/fb74b135-894b-4c1d-9b2e-8a3c231abc14/resourceGroups/rg-adi/providers/Microsoft.Compute/virtualMachineScaleSets/adi-vmss/providers/Microsoft.Chaos/targets/Microsoft-Agent"
            ],
            "properties": {},
            "scope": "microsoft.compute/virtualmachinescalesets/adi-vmss"
        },
        {
            "type": "Microsoft.Chaos/targets/capabilities",
            "apiVersion": "2024-01-01",
            "name": "Microsoft-Agent/CPUPressure-1.0",
            "location": "eastus2",
            "dependsOn": [
                "/subscriptions/fb74b135-894b-4c1d-9b2e-8a3c231abc14/resourceGroups/rg-adi/providers/Microsoft.Compute/virtualMachineScaleSets/adi-vmss/providers/Microsoft.Chaos/targets/Microsoft-Agent"
            ],
            "properties": {},
            "scope": "microsoft.compute/virtualmachinescalesets/adi-vmss"
        },
        {
            "type": "Microsoft.Chaos/targets/capabilities",
            "apiVersion": "2024-01-01",
            "name": "Microsoft-Agent/LinuxDiskIOPressure-1.1",
            "location": "eastus2",
            "dependsOn": [
                "/subscriptions/fb74b135-894b-4c1d-9b2e-8a3c231abc14/resourceGroups/rg-adi/providers/Microsoft.Compute/virtualMachineScaleSets/adi-vmss/providers/Microsoft.Chaos/targets/Microsoft-Agent"
            ],
            "properties": {},
            "scope": "microsoft.compute/virtualmachinescalesets/adi-vmss"
        },
        {
            "type": "Microsoft.Chaos/targets/capabilities",
            "apiVersion": "2024-01-01",
            "name": "Microsoft-Agent/DiskIOPressure-1.1",
            "location": "eastus2",
            "dependsOn": [
                "/subscriptions/fb74b135-894b-4c1d-9b2e-8a3c231abc14/resourceGroups/rg-adi/providers/Microsoft.Compute/virtualMachineScaleSets/adi-vmss/providers/Microsoft.Chaos/targets/Microsoft-Agent"
            ],
            "properties": {},
            "scope": "microsoft.compute/virtualmachinescalesets/adi-vmss"
        },
        {
            "type": "Microsoft.Chaos/targets/capabilities",
            "apiVersion": "2024-01-01",
            "name": "Microsoft-Agent/DnsFailure-1.0",
            "location": "eastus2",
            "dependsOn": [
                "/subscriptions/fb74b135-894b-4c1d-9b2e-8a3c231abc14/resourceGroups/rg-adi/providers/Microsoft.Compute/virtualMachineScaleSets/adi-vmss/providers/Microsoft.Chaos/targets/Microsoft-Agent"
            ],
            "properties": {},
            "scope": "microsoft.compute/virtualmachinescalesets/adi-vmss"
        },
        {
            "type": "Microsoft.Chaos/targets/capabilities",
            "apiVersion": "2024-01-01",
            "name": "Microsoft-Agent/KillProcess-1.0",
            "location": "eastus2",
            "dependsOn": [
                "/subscriptions/fb74b135-894b-4c1d-9b2e-8a3c231abc14/resourceGroups/rg-adi/providers/Microsoft.Compute/virtualMachineScaleSets/adi-vmss/providers/Microsoft.Chaos/targets/Microsoft-Agent"
            ],
            "properties": {},
            "scope": "microsoft.compute/virtualmachinescalesets/adi-vmss"
        },
        {
            "type": "Microsoft.Chaos/targets/capabilities",
            "apiVersion": "2024-01-01",
            "name": "Microsoft-Agent/NetworkDisconnect-1.1",
            "location": "eastus2",
            "dependsOn": [
                "/subscriptions/fb74b135-894b-4c1d-9b2e-8a3c231abc14/resourceGroups/rg-adi/providers/Microsoft.Compute/virtualMachineScaleSets/adi-vmss/providers/Microsoft.Chaos/targets/Microsoft-Agent"
            ],
            "properties": {},
            "scope": "microsoft.compute/virtualmachinescalesets/adi-vmss"
        },
        {
            "type": "Microsoft.Chaos/targets/capabilities",
            "apiVersion": "2024-01-01",
            "name": "Microsoft-Agent/NetworkDisconnectViaFirewall-1.0",
            "location": "eastus2",
            "dependsOn": [
                "/subscriptions/fb74b135-894b-4c1d-9b2e-8a3c231abc14/resourceGroups/rg-adi/providers/Microsoft.Compute/virtualMachineScaleSets/adi-vmss/providers/Microsoft.Chaos/targets/Microsoft-Agent"
            ],
            "properties": {},
            "scope": "microsoft.compute/virtualmachinescalesets/adi-vmss"
        },
        {
            "type": "Microsoft.Chaos/targets/capabilities",
            "apiVersion": "2024-01-01",
            "name": "Microsoft-Agent/NetworkIsolation-1.0",
            "location": "eastus2",
            "dependsOn": [
                "/subscriptions/fb74b135-894b-4c1d-9b2e-8a3c231abc14/resourceGroups/rg-adi/providers/Microsoft.Compute/virtualMachineScaleSets/adi-vmss/providers/Microsoft.Chaos/targets/Microsoft-Agent"
            ],
            "properties": {},
            "scope": "microsoft.compute/virtualmachinescalesets/adi-vmss"
        },
        {
            "type": "Microsoft.Chaos/targets/capabilities",
            "apiVersion": "2024-01-01",
            "name": "Microsoft-Agent/NetworkLatency-1.1",
            "location": "eastus2",
            "dependsOn": [
                "/subscriptions/fb74b135-894b-4c1d-9b2e-8a3c231abc14/resourceGroups/rg-adi/providers/Microsoft.Compute/virtualMachineScaleSets/adi-vmss/providers/Microsoft.Chaos/targets/Microsoft-Agent"
            ],
            "properties": {},
            "scope": "microsoft.compute/virtualmachinescalesets/adi-vmss"
        },
        {
            "type": "Microsoft.Chaos/targets/capabilities",
            "apiVersion": "2024-01-01",
            "name": "Microsoft-Agent/NetworkPacketLoss-1.0",
            "location": "eastus2",
            "dependsOn": [
                "/subscriptions/fb74b135-894b-4c1d-9b2e-8a3c231abc14/resourceGroups/rg-adi/providers/Microsoft.Compute/virtualMachineScaleSets/adi-vmss/providers/Microsoft.Chaos/targets/Microsoft-Agent"
            ],
            "properties": {},
            "scope": "microsoft.compute/virtualmachinescalesets/adi-vmss"
        },
        {
            "type": "Microsoft.Chaos/targets/capabilities",
            "apiVersion": "2024-01-01",
            "name": "Microsoft-Agent/PauseProcess-1.0",
            "location": "eastus2",
            "dependsOn": [
                "/subscriptions/fb74b135-894b-4c1d-9b2e-8a3c231abc14/resourceGroups/rg-adi/providers/Microsoft.Compute/virtualMachineScaleSets/adi-vmss/providers/Microsoft.Chaos/targets/Microsoft-Agent"
            ],
            "properties": {},
            "scope": "microsoft.compute/virtualmachinescalesets/adi-vmss"
        },
        {
            "type": "Microsoft.Chaos/targets/capabilities",
            "apiVersion": "2024-01-01",
            "name": "Microsoft-Agent/PhysicalMemoryPressure-1.0",
            "location": "eastus2",
            "dependsOn": [
                "/subscriptions/fb74b135-894b-4c1d-9b2e-8a3c231abc14/resourceGroups/rg-adi/providers/Microsoft.Compute/virtualMachineScaleSets/adi-vmss/providers/Microsoft.Chaos/targets/Microsoft-Agent"
            ],
            "properties": {},
            "scope": "microsoft.compute/virtualmachinescalesets/adi-vmss"
        },
        {
            "type": "Microsoft.Chaos/targets/capabilities",
            "apiVersion": "2024-01-01",
            "name": "Microsoft-Agent/StopService-1.0",
            "location": "eastus2",
            "dependsOn": [
                "/subscriptions/fb74b135-894b-4c1d-9b2e-8a3c231abc14/resourceGroups/rg-adi/providers/Microsoft.Compute/virtualMachineScaleSets/adi-vmss/providers/Microsoft.Chaos/targets/Microsoft-Agent"
            ],
            "properties": {},
            "scope": "microsoft.compute/virtualmachinescalesets/adi-vmss"
        },
        {
            "type": "Microsoft.Chaos/targets/capabilities",
            "apiVersion": "2024-01-01",
            "name": "Microsoft-Agent/TimeChange-1.0",
            "location": "eastus2",
            "dependsOn": [
                "/subscriptions/fb74b135-894b-4c1d-9b2e-8a3c231abc14/resourceGroups/rg-adi/providers/Microsoft.Compute/virtualMachineScaleSets/adi-vmss/providers/Microsoft.Chaos/targets/Microsoft-Agent"
            ],
            "properties": {},
            "scope": "microsoft.compute/virtualmachinescalesets/adi-vmss"
        },
        {
            "type": "Microsoft.Chaos/targets/capabilities",
            "apiVersion": "2024-01-01",
            "name": "Microsoft-Agent/VirtualMemoryPressure-1.0",
            "location": "eastus2",
            "dependsOn": [
                "/subscriptions/fb74b135-894b-4c1d-9b2e-8a3c231abc14/resourceGroups/rg-adi/providers/Microsoft.Compute/virtualMachineScaleSets/adi-vmss/providers/Microsoft.Chaos/targets/Microsoft-Agent"
            ],
            "properties": {},
            "scope": "microsoft.compute/virtualmachinescalesets/adi-vmss"
        }
    ]
}
