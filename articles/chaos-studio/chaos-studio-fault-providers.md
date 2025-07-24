---
title: Supported resource types and role assignments for Chaos Studio
description: Understand the list of supported resource types and which role assignment is needed to enable an experiment to run a fault against that resource type.
services: chaos-studio
author: prasha-microsoft
ms.topic: article
ms.date: 10/14/2024
ms.reviewer: prashabora
---

# Supported resource types and role assignments for Chaos Studio

The following table lists the supported resource types for faults, the target types, and suggested roles to use when you give an experiment permission to a resource of that type.

More information about role assignments can be found on the [Azure built-in roles page](/azure/role-based-access-control/built-in-roles).

| Resource type                                                    | Target name/type                          | Suggested role assignment                   |
|-------------------------------------------------------------------|--------------------------------------------|----------------------------------------------|
| Microsoft.Cache/Redis (service-direct)                           | Microsoft-AzureCacheForRedis              | [Redis Cache Contributor](/azure/role-based-access-control/built-in-roles#redis-cache-contributor)                     |
| Microsoft.ClassicCompute/domainNames (service-direct)            | Microsoft-DomainNames                     | [Classic Virtual Machine Contributor](/azure/role-based-access-control/built-in-roles#classic-virtual-machine-contributor)       |
| Microsoft.Compute/virtualMachines (agent-based)                  | Microsoft-Agent                           | [Reader](/azure/role-based-access-control/built-in-roles#reader)                                      |
| Microsoft.Compute/virtualMachineScaleSets (agent-based)          | Microsoft-Agent                           | [Reader](/azure/role-based-access-control/built-in-roles#reader)                                      |
| Microsoft.Compute/virtualMachines (service-direct)               | Microsoft-VirtualMachine                  | [Virtual Machine Contributor](/azure/role-based-access-control/built-in-roles#virtual-machine-contributor)                 |
| Microsoft.Compute/virtualMachineScaleSets (service-direct)       | Microsoft-VirtualMachineScaleSet          | [Virtual Machine Contributor](/azure/role-based-access-control/built-in-roles#virtual-machine-contributor)                 |
| Microsoft.ContainerService/managedClusters (service-direct)      | Microsoft-AzureKubernetesServiceChaosMesh (recommended)| [Azure Kubernetes Service RBAC Admin Role](/azure/role-based-access-control/built-in-roles#azure-kubernetes-service-rbac-admin-role) and [Azure Kubernetes Service Cluster User Role](/azure/role-based-access-control/built-in-roles#azure-kubernetes-service-cluster-user-role) |
| Microsoft.ContainerService/managedClusters (service-direct)      | Microsoft-AzureKubernetesServiceChaosMesh (fault version 2.1 with Kubernetes local accounts only)| [Azure Kubernetes Service Cluster Admin Role](/azure/role-based-access-control/built-in-roles#azure-kubernetes-service-cluster-admin-role) |
| Microsoft.DocumentDb/databaseAccounts (Cosmos DB, service-direct) | Microsoft-Cosmos DB                        | [Cosmos DB Operator](/azure/role-based-access-control/built-in-roles#cosmos-db-operator)                          |
| Microsoft.Insights/autoscalesettings (service-direct)            | Microsoft-AutoScaleSettings               | [Web Plan Contributor](/azure/role-based-access-control/built-in-roles#web-plan-contributor)                        |
| Microsoft.KeyVault/vaults (service-direct)                       | Microsoft-KeyVault                        | [Azure Key Vault Contributor](/azure/role-based-access-control/built-in-roles#key-vault-contributor)                       |
| Microsoft.Network/networkSecurityGroups (service-direct)         | Microsoft-NetworkSecurityGroup            | [Network Contributor](/azure/role-based-access-control/built-in-roles#network-contributor)                         |
| Microsoft.Web/sites (service-direct)                             | Microsoft-AppService                      | [Website Contributor](/azure/role-based-access-control/built-in-roles#website-contributor)                         |
| Microsoft.ServiceBus/namespaces (service-direct)                 | Microsoft-ServiceBus                      | [Azure Service Bus Data Owner](/azure/role-based-access-control/built-in-roles#azure-service-bus-data-owner)                         |
| Microsoft.EventHub/namespaces (service-direct)                   | Microsoft-EventHub                        | [Azure Event Hubs Data Owner](/azure/role-based-access-control/built-in-roles#azure-event-hubs-data-owner)                         |
| Microsoft.LoadTestService/loadtests (service-direct)             | Microsoft-AzureLoadTest                   | [Load Test Contributor](/azure/role-based-access-control/built-in-roles#load-test-contributor)                         |

## Custom role operations

If you prefer not to use the listed built-in roles, you can create custom roles and assign the exact operations needed for each fault. There are two ways to do this. 

While creating an experiment within the Azure portal, you can select **"Use a new custom role"** within the **"Experiment permissions"** section of the **Permissions** tab to allow Chaos Studio to deploy a custom role with the necessary operations.

Alternatively, if you aren't using the Azure portal or you prefer to manage operations individually, you can find the operations needed for each fault and manually assign them to a custom role. To see what roles are needed for a Chaos Studio fault, run the following Azure CLI REST command:

```azurecli-interactive
az rest --method get --uri https://management.azure.com/subscriptions/$SUBSCRIPTION_ID/providers/Microsoft.Chaos/locations/eastus/targetTypes/$TARGET_TYPE/capabilityTypes/$CAPABILITY_NAME?api-version=2024-01-01
```

As an example, see `properties.azureRbacActions` and `properties.azureRbacDataActions` for the Cosmos DB Failover fault.
```json
> az rest --method get --url "https://management.azure.com/subscriptions/$SUBSCRIPTION_ID/providers/Microsoft.Chaos/locations/eastus/targetTypes/Microsoft-CosmosDB/capabilityTypes/Failover-1.0?api-version=2024-01-01"
{
  "id": "/subscriptions/$SUBSCRIPTION_ID/providers/Microsoft.Chaos/locations/eastus/targetTypes/CosmosDB/capabilityTypes/Failover-1.0",
  "location": "eastus",
  "name": "Failover-1.0",
  "properties": {
    "azureRbacActions": [
      "Microsoft.DocumentDB/databaseAccounts/read",
      "Microsoft.DocumentDB/databaseAccounts/failoverPriorityChange/action"
    ],
    "azureRbacDataActions": null,
    "description": "",
    "displayName": "",
    "kind": "Fault",
    "parametersSchema": "https://schema-tc.eastus.chaos-prod.azure.com/targetTypes/Microsoft-CosmosDB/capabilityTypes/Failover-1.0/parametersSchema.json",
    "publisher": "Microsoft",
    "runtimeProperties": {
      "kind": "Continuous"
    },
    "targetType": "CosmosDB",
    "urn": "urn:csci:microsoft:cosmosDB:failover/1.0"
  },
  "systemData": {
    "createdAt": "2024-10-10T17:28:41.7377834+00:00",
    "createdByType": "Application",
    "lastModifiedAt": "2024-10-10T17:28:41.7377834+00:00"
  },
  "type": "Microsoft.Chaos/locations/targetTypes/capabilityTypes"
}
```
