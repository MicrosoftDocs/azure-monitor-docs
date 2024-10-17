---
title: Supported resource types and role assignments for Chaos Studio
description: Understand the list of supported resource types and which role assignment is needed to enable an experiment to run a fault against that resource type.
services: chaos-studio
author: prasha-microsoft
ms.topic: article
ms.date: 10/14/2024
ms.author: abbyweisberg
ms.reviewer: prashabora
ms.service: azure-chaos-studio
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
| Microsoft.ContainerService/managedClusters (service-direct)      | Microsoft-AzureKubernetesServiceChaosMesh | [Azure Kubernetes Service Cluster Admin Role](/azure/role-based-access-control/built-in-roles#azure-kubernetes-service-cluster-admin-role) |
| Microsoft.DocumentDb/databaseAccounts (Cosmos DB, service-direct) | Microsoft-Cosmos DB                        | [Cosmos DB Operator](/azure/role-based-access-control/built-in-roles#cosmos-db-operator)                          |
| Microsoft.Insights/autoscalesettings (service-direct)            | Microsoft-AutoScaleSettings               | [Web Plan Contributor](/azure/role-based-access-control/built-in-roles#web-plan-contributor)                        |
| Microsoft.KeyVault/vaults (service-direct)                       | Microsoft-KeyVault                        | [Azure Key Vault Contributor](/azure/role-based-access-control/built-in-roles#key-vault-contributor)                       |
| Microsoft.Network/networkSecurityGroups (service-direct)         | Microsoft-NetworkSecurityGroup            | [Network Contributor](/azure/role-based-access-control/built-in-roles#network-contributor)                         |
| Microsoft.Web/sites (service-direct)                             | Microsoft-AppService                      | [Website Contributor](/azure/role-based-access-control/built-in-roles#website-contributor)                         |
| Microsoft.ServiceBus/namespaces (service-direct)                 | Microsoft-ServiceBus                      | [Azure Service Bus Data Owner](/azure/role-based-access-control/built-in-roles#azure-service-bus-data-owner)                         |
| Microsoft.EventHub/namespaces (service-direct)                   | Microsoft-EventHub                        | [Azure Event Hubs Data Owner](/azure/role-based-access-control/built-in-roles#azure-event-hubs-data-owner)                         |
| Microsoft.LoadTestService/loadtests (service-direct)             | Microsoft-AzureLoadTest                   | [Load Test Contributor](/azure/role-based-access-control/built-in-roles#load-test-contributor)                         |
