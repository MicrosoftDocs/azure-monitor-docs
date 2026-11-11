---
title: Supported resources and Actions for Chaos Studio Workspaces
description: Find the Azure resource types that Chaos Studio Workspaces supports, the Actions for each type, and the Scenario templates that use each Action.
author: nikhilkaul-msft
ms.topic: reference
ms.date: 10/24/2026
ai-usage: ai-assisted
---

# Supported resources and Actions for Chaos Studio Workspaces

This article lists the Azure resource types that [Chaos Studio Workspaces](chaos-studio-workspaces-overview.md) can target. For each resource type, it shows the Actions you can run and the Scenario templates that use them. Use it to check which faults are available for your resources before you build a [custom Scenario](chaos-studio-scenarios.md#create-a-custom-scenario). For example, to test a Service Bus outage, find `Microsoft.ServiceBus/namespaces`, pick an Action, and copy its `actionId`.

[!INCLUDE [chaos-studio-workspaces-preview](includes/chaos-studio-workspaces-preview.md)]

## Find Actions for a resource type

Find your resource type in the following table. The **Scenario templates** column lists the [supported Scenario templates](chaos-studio-scenarios.md#supported-scenario-templates) that use an Action on that resource type. You can use every Action in a custom Scenario.

| Resource type | Actions | Scenario templates |
|---|---|---|
| `Microsoft.ApiManagement/service` | [Update backend](#application-and-integration) | None |
| `Microsoft.Automation/automationAccounts` | [Start runbook](#application-and-integration) | Zone Down (optional runbooks) |
| `Microsoft.Automation/automationAccounts/runbooks` | [Start runbook](#application-and-integration) | None |
| `Microsoft.Cache/redis` | [Reboot](#caching) | Zone Down |
| `Microsoft.Cache/redisEnterprise` | [Flush database](#caching), [Force unlink](#caching) | Cache Stampede, Cache Stampede with Process Crash |
| `Microsoft.Compute/virtualMachines` | [CPU pressure](#compute), [Hibernate](#compute), [Physical memory pressure](#compute), [Redeploy](#compute), [Restart](#compute), [Shutdown](#compute) | Compute Zone Down and its database variants, Zone Down, VM Hibernate, VM Maintenance Reboot, CPU Pressure, Physical Memory Pressure |
| `Microsoft.Compute/virtualMachineScaleSets` | [CPU pressure](#compute), [Delete instances](#compute), [Physical memory pressure](#compute), [Shutdown](#compute), [VMSS shutdown](#compute) | Compute Zone Down and its database variants, Zone Down, CPU Pressure, Physical Memory Pressure |
| `Microsoft.DBforMySQL/flexibleServers` | [Failover](#databases), [Restart](#databases) | DB Failover Under Load, DB Restart Under Load, Cache Stampede, Cache Stampede with Process Crash |
| `Microsoft.DBforPostgreSQL/flexibleServers` | [Failover](#databases) | Compute Zone Down + PostgreSQL Failover |
| `Microsoft.DocumentDb/databaseAccounts` | [Offline region](#databases) | None |
| `Microsoft.EventHub/namespaces` | [Change event hub state](#messaging) | Event-Driven Messaging Disruption, Dependency Blackout |
| `Microsoft.LoadTestService/loadTests` | [Start](#application-and-integration), [Stop](#application-and-integration) | DB Failover Under Load, DB Restart Under Load |
| `Microsoft.Network/loadBalancers` | [Update load balancer admin state](#networking) | None |
| `Microsoft.Network/networkSecurityGroups` | [Apply NSG rule](#networking) | DNS Outage, Microsoft Entra ID Outage, Key Vault Public Endpoint Outage, Dependency Blackout |
| `Microsoft.ServiceBus/namespaces` | [Change queue state](#messaging), [Change subscription state](#messaging), [Change topic state](#messaging) | Event-Driven Messaging Disruption, Dependency Blackout |
| `Microsoft.ServiceFabric/managedClusters` | [Availability zone down](#compute) | None |
| `Microsoft.Sql/managedInstances` | [Failover managed instance](#databases) | Compute Zone Down + SQL Managed Instance Failover |
| `Microsoft.Sql/servers/databases` | [Failover](#databases) | Compute Zone Down + SQL DB Failover |
| `Microsoft.Sql/servers/failoverGroups` | [Failover](#databases) | None |
| `Microsoft.Storage/storageAccounts` | [Planned failover](#storage) | None |
| `Microsoft.Web/sites` | [Kill process](#application-and-integration), [Restart](#application-and-integration) | Cache Stampede, Cache Stampede with Process Crash |

Faults inside an Azure Kubernetes Service (AKS) cluster, such as pod delete and network latency, aren't in this catalog. They run through the [Chaos Studio extension for AKS](chaos-studio-aks-extension-overview.md). To shut down AKS nodes, use the scale set Actions. For more information, see [AKS resilience testing with Chaos Studio Workspaces](chaos-studio-aks-guidance.md).

## Use an Action in a custom Scenario

1. Find the Action in the [Action reference](#action-reference). Copy its `actionId`.
1. Add the Action to a Scenario in the Scenario designer, or in a `Microsoft.Chaos/workspaces/scenarios` resource. For the resource structure and a Bicep example, see [Create a custom Scenario](chaos-studio-scenarios.md#create-a-custom-scenario).
1. Set the parameters that the Action requires. Set a `duration` for Continuous and Cancelable Actions.
1. Give the Workspace identity the recommended role, or a custom role with the same permissions. For more information, see [Permissions and identity in Chaos Studio Workspaces](chaos-studio-workspace-permissions.md#role-assignments-the-workspace-identity-needs) and [Create least-privilege roles](chaos-studio-workspaces-least-privilege-roles.md).

The Workspace runs each Action against the discovered resources of its target type in the Workspace scope. To limit the resources, use [resource filters](chaos-studio-workspaces-resource-targeting.md) or resource exclusions.

### Action types

Each Action has one of three types. The type controls how the Action uses `duration` and what happens when the Action ends.

| Type | Behavior |
|---|---|
| Discrete | Runs one operation, such as a restart or a failover, and then completes. It doesn't undo the operation. |
| Continuous | Applies an effect for the Action's `duration`, and then stops it. |
| Cancelable | Starts an effect and stops it when the `duration` ends or when you cancel the run. Some Actions have a parameter, such as `RestoreOnStop`, that controls what happens at stop. |

## Action reference

The tables in this section come from the Workspaces Action catalog. Each `actionId` has the form `<action name>/<major>.<minor>`. Parameters marked *required* must have a value. Other parameters are optional.

### Application and integration

| Action | `actionId` | Target resource types | Type | Parameters | Recommended role |
|---|---|---|---|---|---|
| Update backend | `microsoft-apimanagement-updatebackend/1.0` | `Microsoft.ApiManagement/service` | Cancelable | `BackendId`: name of the backend entity in the API Management service. `Url`: the invalid URL to set on the backend to simulate a failure. | API Management Service Contributor |
| Start runbook | `microsoft-automation-startrunbook/1.0` | `Microsoft.Automation/automationAccounts`, `Microsoft.Automation/automationAccounts/runbooks` | Cancelable | `RunbookName`: name of the runbook to run. Required when the target is an Automation account. `RunbookParameters`: runbook parameters as a serialized JSON dictionary. | Automation Operator |
| Start (load test) | `microsoft-azureloadtest-start/1.0` | `Microsoft.LoadTestService/loadTests` | Discrete | `TestId`: the load test to start. | Load Test Contributor |
| Stop (load test) | `microsoft-azureloadtest-stop/1.0` | `Microsoft.LoadTestService/loadTests` | Discrete | `TestId`: the load test to stop. | Load Test Contributor |
| Kill process | `microsoft-appservice-killprocess/1.0` | `Microsoft.Web/sites` | Discrete | `ProcessName`: process to kill. Leave it empty to kill the main worker process. `InstanceIds`: instances to target. `Zones`: availability zones to target, such as `["1"]`. | Website Contributor |
| Restart (App Service) | `microsoft-appservice-restart/1.0` | `Microsoft.Web/sites` | Discrete | `SoftRestart`: `true` applies configuration settings and restarts only if necessary. The default, `false`, always restarts the app. | Website Contributor |

### Caching

| Action | `actionId` | Target resource types | Type | Parameters | Recommended role |
|---|---|---|---|---|---|
| Reboot | `microsoft-azureclusteredcacheforredis-reboot/1.0` | `Microsoft.Cache/redis` | Discrete | `RebootType` (required): `AllNodes`, `PrimaryNode`, or `SecondaryNode`. `ShardId`: shard to reboot, for clustered caches only. | Redis Cache Contributor |
| Flush database | `microsoft-managedredis-flushdatabase/1.0` | `Microsoft.Cache/redisEnterprise` | Discrete | `DatabaseName`: database in the cluster to flush. | Azure Managed Redis Contributor |
| Force unlink | `microsoft-managedredis-forceunlink/1.0` | `Microsoft.Cache/redisEnterprise` | Discrete | `DatabaseName`: database in the cluster to unlink. `LinkedDatabaseResourceIds`: resource IDs of the linked databases to remove from the geo-replication group. | Azure Managed Redis Contributor |

The Reboot Action works on clustered and non-clustered Azure Cache for Redis instances. For a non-clustered cache, such as a Basic or Standard cache, don't set `ShardId`.

### Compute

| Action | `actionId` | Target resource types | Type | Parameters | Recommended role |
|---|---|---|---|---|---|
| CPU pressure | `microsoft-compute-cpupressure/1.0` | `Microsoft.Compute/virtualMachines`, `Microsoft.Compute/virtualMachineScaleSets` | Continuous | `PressureLevel`: CPU pressure, 1–100 percent. | Virtual Machine Contributor |
| Physical memory pressure | `microsoft-compute-physicalmemorypressure/1.0` | `Microsoft.Compute/virtualMachines`, `Microsoft.Compute/virtualMachineScaleSets` | Continuous | `PressureLevel`: memory pressure, 1–99 percent. | Virtual Machine Contributor |
| Shutdown | `microsoft-compute-shutdown/1.0` | `Microsoft.Compute/virtualMachines`, `Microsoft.Compute/virtualMachineScaleSets` | Cancelable | `GracefulShutdown`: `true` shuts down gracefully. `Zones`: availability zones to shut down. Applies to scale sets only. | Virtual Machine Contributor |
| VMSS shutdown | `microsoft-virtualmachinescaleset-shutdown/1.0` | `Microsoft.Compute/virtualMachineScaleSets` | Cancelable | `GracefulShutdown`: `true` shuts down gracefully. `Zones`: availability zones to shut down. | Virtual Machine Contributor |
| Delete instances | `microsoft-compute-deleteinstances/1.0` | `Microsoft.Compute/virtualMachineScaleSets` | Discrete | `Percentage`: percentage of scale set instances to delete, 1–100. The service selects instances at random. | Virtual Machine Contributor |
| Hibernate | `microsoft-compute-hibernate/1.0` | `Microsoft.Compute/virtualMachines` | Cancelable | None | Virtual Machine Contributor |
| Redeploy | `microsoft-compute-redeploy/1.0` | `Microsoft.Compute/virtualMachines` | Discrete | None | Virtual Machine Contributor |
| Restart (VM) | `microsoft-compute-restart/1.0` | `Microsoft.Compute/virtualMachines` | Discrete | None | Virtual Machine Contributor |
| Availability zone down | `microsoft-servicefabricmanagedcluster-azdown/1.0` | `Microsoft.ServiceFabric/managedClusters` | Cancelable | `Nodetype`: node type to apply the fault to. `Zone`: the zone to bring down. You can bring down one zone at a time. | Service Fabric Managed Cluster Contributor |

CPU pressure and physical memory pressure are agent-based Actions. For the operating system and VM requirements, see [Agent-based Scenario requirements](chaos-studio-scenarios.md#agent-based-scenario-requirements).

### Databases

| Action | `actionId` | Target resource types | Type | Parameters | Recommended role |
|---|---|---|---|---|---|
| Offline region | `microsoft-documentdb-offlineregion/1.0` | `Microsoft.DocumentDb/databaseAccounts` | Cancelable | `RegionName` (required): display name of the region to take offline, such as `East US`. | Cosmos DB Operator |
| Failover (MySQL) | `microsoft-mysql-failover/1.0` | `Microsoft.DBforMySQL/flexibleServers` | Cancelable | `RestoreOnStop` (required): `true` tries to restore the original primary when the Action stops. | Contributor |
| Restart (MySQL) | `microsoft-mysql-restart/1.0` | `Microsoft.DBforMySQL/flexibleServers` | Discrete | None | Contributor |
| Failover (PostgreSQL) | `microsoft-azurepostgresql-failover/1.0` | `Microsoft.DBforPostgreSQL/flexibleServers` | Cancelable | `FailoverMode` (required): `PlannedFailover` or `ForcedFailover`. `RestoreOnStop`: `true` runs a planned restore to the original primary when the Action stops. `SkipIneligibleServers`: `true` skips read replicas and servers without high availability. | Contributor |
| Failover (SQL) | `microsoft-sql-failover/1.0` | `Microsoft.Sql/servers/databases`, `Microsoft.Sql/servers/failoverGroups` | Cancelable | `ForceAllowDataLoss`: `true` uses a forced failover, which can lose data. The default, `false`, uses a planned failover. | SQL DB Contributor |
| Failover managed instance | `microsoft-sql-failovermanagedinstance/1.0` | `Microsoft.Sql/managedInstances` | Discrete | `ReplicaType`: `Primary` (default) or `ReadableSecondary`. | SQL Managed Instance Contributor |

### Messaging

| Action | `actionId` | Target resource types | Type | Parameters | Recommended role |
|---|---|---|---|---|---|
| Change event hub state | `microsoft-eventhub-changeeventhubstate/1.0` | `Microsoft.EventHub/namespaces` | Cancelable | `desiredState` (required): `Active`, `Disabled`, or `SendDisabled`. `eventhubs`: event hubs to change. | Azure Event Hubs Data Owner |
| Change queue state | `microsoft-servicebus-changequeuestate/1.0` | `Microsoft.ServiceBus/namespaces` | Cancelable | `desiredState` (required): `Active`, `Disabled`, `SendDisabled`, or `ReceiveDisabled`. `queues`: queues to change. | Azure Service Bus Data Owner |
| Change subscription state | `microsoft-servicebus-changesubscriptionstate/1.0` | `Microsoft.ServiceBus/namespaces` | Discrete | `topic` (required): topic name. `subscriptions` (required): subscription names. `desiredState` (required): `Active` or `Disabled`. | Azure Service Bus Data Owner |
| Change topic state | `microsoft-servicebus-changetopicstate/1.0` | `Microsoft.ServiceBus/namespaces` | Discrete | `topics` (required): topic names. `desiredState` (required): `Active` or `Disabled`. | Azure Service Bus Data Owner |

Change subscription state and Change topic state are Discrete. They don't restore the original state. To restore it, add a later Action that sets `desiredState` to `Active`.

### Networking

| Action | `actionId` | Target resource types | Type | Parameters | Recommended role |
|---|---|---|---|---|---|
| Apply NSG rule | `microsoft-networksecuritygroupv2-applynsgrule/2.0` | `Microsoft.Network/networkSecurityGroups` | Cancelable | `Rules`: the NSG rules to apply. Each rule sets `Access` (`Allow` or `Deny`), `Direction` (`Inbound` or `Outbound`), `Protocol`, and address and port ranges. | Network Contributor |
| Update load balancer admin state | `microsoft-network-updateloadbalanceradminstate/1.0` | `Microsoft.Network/loadBalancers` | Cancelable | `AdminState`: `Down`, `Up`, or `None`. `BackendPoolName`: the backend pool. `BackendAddressNames`: addresses in the pool to change. | Network Contributor |

### Storage

| Action | `actionId` | Target resource types | Type | Parameters | Recommended role |
|---|---|---|---|---|---|
| Planned failover | `microsoft-storageaccount-plannedfailover/1.0` | `Microsoft.Storage/storageAccounts` | Discrete | None | Storage Account Contributor |

## List Actions with the REST API

The Action catalog is also available through Azure Resource Manager. Use it to get the full parameter schema and the exact permissions that each Action needs.

1. Run the following command. Replace `<subscription-id>` with your subscription ID. The example uses the West Central US region.

    ```azurecli
    az rest --method get \
      --url "https://management.azure.com/subscriptions/<subscription-id>/providers/Microsoft.Chaos/locations/westcentralus/actions?api-version=2026-08-01-preview" \
      --query "value[].{name:name, type:properties.actionType, targets:properties.supportedTargetTypes[].targetType}"
    ```

1. Check the result. Each entry shows the Action name, its type, and its target resource types:

    ```json
    {
      "name": "microsoft-documentdb-offlineregion",
      "targets": [
        "Microsoft.DocumentDb/databaseAccounts"
      ],
      "type": "Cancelable"
    }
    ```

Each Action also returns `parametersSchema`, `supportedTargetTypes[].requiredPermissions`, and `recommendedRoles`. The `recommendedRoles` property holds built-in role definition IDs. To build a least-privilege role from `requiredPermissions`, see [Create least-privilege roles](chaos-studio-workspaces-least-privilege-roles.md).

[!INCLUDE [chaos-studio-feedback](includes/chaos-studio-feedback.md)]

## Next steps

- [Scenarios and outage templates for Chaos Studio Workspaces](chaos-studio-scenarios.md)
- [Permissions and identity in Chaos Studio Workspaces](chaos-studio-workspace-permissions.md)
- [Manage Workspaces and Scenarios with the Azure CLI](chaos-studio-manage-cli.md)
