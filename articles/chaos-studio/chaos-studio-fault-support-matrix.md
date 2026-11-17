---
title: Fault support matrix for Azure Chaos Studio
description: See which failures Azure Chaos Studio can inject for each Azure resource type, in which resource model, how each fault ends, and what each fault doesn't reproduce.
author: nikhilkaul-msft
ms.topic: reference
ms.date: 11/15/2026
ai-usage: ai-assisted
---

# Fault support matrix for Azure Chaos Studio

This article shows which failures Azure Chaos Studio can inject for each Azure resource type. For each fault, it shows the resource model that provides it, how the fault ends, and what the fault doesn't reproduce. Use it to answer three questions before you plan a resilience test:

- Can Chaos Studio inject this failure into this resource?
- What state is the resource in when the fault ends?
- How close is the fault to the real outage?

If a resource type or failure isn't in this article, Chaos Studio has no fault for it. The article says so where customers ask most often. See [Failures that Chaos Studio can't inject](#failures-that-chaos-studio-cant-inject).

This article is a summary. The catalogs are the source of truth for parameters, `actionId` values, and permissions:

- [Supported resources and Actions for Chaos Studio Workspaces](chaos-studio-workspaces-supported-resources.md)
- [Fault and action library for Experiments (classic)](chaos-studio-fault-library.md)

## How to read the matrix

Chaos Studio provides faults through three delivery paths. The paths have different support levels. A fault in one path doesn't establish that the fault is available in another path.

| Label | Delivery path | Support level |
|---|---|---|
| **Workspaces** | Actions in [Chaos Studio Workspaces](chaos-studio-workspaces-overview.md) Scenarios | Public preview. No service-level agreement. Not meant for production use. |
| **AKS extension** | Pod faults from the [Chaos Studio extension for AKS](chaos-studio-aks-extension-overview.md), run from a Workspace | Limited preview. Only for allow-listed subscriptions. |
| **Classic** | Faults in [Experiments (classic)](chaos-studio-chaos-experiments.md) | Generally available. Microsoft no longer adds features and considers only critical fixes. |
| **—** | No fault in this path | Not available. |

The **How it ends** column uses the Workspaces Action types:

| Type | What happens at the end |
|---|---|
| Discrete | Chaos Studio runs one operation and stops. It doesn't undo the operation. You own the recovery. |
| Continuous | Chaos Studio applies the effect for the duration, and then stops it. |
| Cancelable | Chaos Studio starts the effect and stops it when the duration ends or when you cancel the run. |

The column describes the Workspaces Action. For a fault that's also in Experiments (classic), or only there, check the [classic library](chaos-studio-fault-library.md) for how the classic fault ends.

> [!IMPORTANT]
> Some Discrete Actions change data or capacity and nothing restores it. Examples are **Flush database**, **Delete instances**, and a SQL failover with `ForceAllowDataLoss` set to `true`. Read the **How it ends** column before you choose a target.

## Find a fault by the failure you want to test

Start here if you know the outage you're worried about, but not the fault to use.

| Failure to test | Workspaces | Classic | What the fault does |
|---|---|---|---|
| Loss of an availability zone (compute) | Compute Zone Down and Zone Down templates. **Shutdown** with `Zones`. | Virtual Machine Scale Set Shutdown (2.0) | Shuts down virtual machines and scale set instances in the zone. |
| Loss of an availability zone (data tier) | Compute Zone Down variants with PostgreSQL, SQL Database, or SQL Managed Instance failover | — | Adds a database failover to the compute shutdown. |
| Loss of a region | **Offline region** (Azure Cosmos DB). **Planned failover** (Storage). **Failover** (SQL failover groups). | Cosmos DB Failover | Per-service only. There's no fault that takes down a region. |
| Loss of a VM or instance | **Shutdown**, **Restart**, **Hibernate**, **Delete instances** | VM Shutdown, Virtual Machine Scale Set Shutdown | Uses the Azure compute APIs. |
| Platform maintenance | VM Maintenance Reboot template (**Restart**, and then **Redeploy**) | VM Redeploy | Moves the VM to a different host. |
| CPU or memory exhaustion in a VM | **CPU pressure**, **Physical memory pressure** | CPU Pressure, Physical Memory Pressure, Virtual Memory Pressure, Stress-ng | Runs in the guest through the Chaos Studio agent. |
| Disk I/O pressure in a VM | — | DiskIO Pressure (Windows), Linux DiskIO Pressure | Agent-based. |
| Network latency, packet loss, or disconnect in a VM | — | Network Latency, Network Packet Loss, Network Disconnect, Network Isolation | Agent-based. |
| Network block between resources | **Apply NSG rule** | NSG Security Rule | Adds rules to a network security group (NSG). |
| DNS outage | DNS Outage template (NSG rule that denies outbound port 53) | NSG Security Rule. DNS Failure (agent, Windows). | See [DNS, Microsoft Entra ID, and Key Vault outages](#dns-microsoft-entra-id-and-key-vault-outages). |
| Microsoft Entra ID outage | Microsoft Entra ID Outage template (NSG rule) | NSG Security Rule | Blocks outbound traffic to Microsoft Entra ID service tags. |
| Key Vault unavailable | Key Vault Public Endpoint Outage template (NSG rule) | Key Vault: Deny Access | Workspaces blocks the network path. Classic changes the vault. |
| Certificate problems | — | Key Vault: Disable Certificate, Increment Certificate Version, Update Certificate Policy | Classic only. |
| Database failover or restart | **Failover** (MySQL, PostgreSQL, SQL). **Failover managed instance**. **Restart** (MySQL). | Cosmos DB Failover | Uses the failover operation of the database service. |
| Cache loss or cache node loss | **Reboot** (Azure Cache for Redis). **Flush database**, **Force unlink** (Azure Managed Redis). | Azure Cache for Redis (Reboot) | Flush database deletes the cached data. |
| Messaging unavailable | **Change queue state**, **Change topic state**, **Change subscription state**, **Change event hub state** | The same four faults | Disables entities in the namespace. |
| Backend of an API unavailable | **Update backend** (API Management). **Update load balancer admin state**. | — | Points a backend at an invalid URL, or marks backend addresses down. |
| App process crash | **Kill process**, **Restart** (App Service) | Stop App Service. Kill Process, Stop Service, Pause Process (agent). | See [App Service](#application-and-integration). |
| Pod failure or pod resource pressure in AKS | AKS extension: pod delete, pod CPU hog, pod memory hog | AKS Chaos Mesh Pod Chaos, Stress Chaos | In-cluster faults. |
| Pod network latency or loss in AKS | AKS extension: pod network latency, pod network loss | AKS Chaos Mesh Network Chaos, HTTP Chaos, DNS Chaos | In-cluster faults. |
| AKS node or zone loss | **Shutdown** on the node scale sets | Virtual Machine Scale Set Shutdown (2.0) | See [AKS resilience testing with Chaos Studio Workspaces](chaos-studio-aks-guidance.md). |
| Autoscale doesn't respond | — | Disable Autoscale | Classic only. |
| Clock skew | — | Time Change (agent, Windows). AKS Chaos Mesh Time Chaos. | Classic only. |
| Failure under load | **Start** and **Stop** (Azure Load Testing) | Start load test, Stop load test | Orchestration actions. They don't inject a failure. |
| A failure that isn't in the catalog | **Start runbook** (Azure Automation) | — | Runs your own runbook as a step. You write the fault and the recovery. |

## Matrix by resource type

### Compute

| Resource type | Fault | Workspaces | Classic | How it ends |
|---|---|---|---|---|
| `Microsoft.Compute/virtualMachines` | Shutdown | Yes | Yes | Cancelable |
| | Restart | Yes | — | Discrete |
| | Redeploy | Yes | Yes | Discrete |
| | Hibernate | Yes | — | Cancelable. Chaos Studio resumes the VM. |
| `Microsoft.Compute/virtualMachineScaleSets` | Shutdown, with an optional zone filter | Yes | Yes | Cancelable |
| | Delete instances | Yes | — | Discrete. The instances are deleted. |
| `Microsoft.ServiceFabric/managedClusters` | Availability zone down | Yes | — | Cancelable |
| `Microsoft.ClassicCompute/domainNames` | Cloud Service Shutdown | — | Yes | See the classic library |
| `Microsoft.Insights/autoscaleSettings` | Disable Autoscale | — | Yes | See the classic library |

### In-guest faults on virtual machines and scale sets

In-guest faults run through the Chaos Studio agent on `Microsoft.Compute/virtualMachines` and `Microsoft.Compute/virtualMachineScaleSets`.

| Fault | Workspaces | Classic | Operating systems |
|---|---|---|---|
| CPU pressure | Yes | Yes | Windows, Linux |
| Physical memory pressure | Yes | Yes | Windows, Linux |
| Virtual memory pressure | — | Yes | Windows |
| Disk I/O pressure | — | Yes | Windows, Linux |
| Arbitrary stress-ng stressor | — | Yes | Linux |
| Kill process | — | Yes | Windows, Linux |
| Stop service | — | Yes | Windows, Linux |
| Pause process | — | Yes | Windows |
| Network disconnect | — | Yes | Windows (TCP and UDP only), Linux (outbound only) |
| Network disconnect through the firewall | — | Yes | Windows |
| Network latency | — | Yes | Windows (TCP and UDP only), Linux (outbound only) |
| Network packet loss | — | Yes | Windows (TCP and UDP only), Linux (outbound only) |
| Network isolation | — | Yes | Windows, Linux (outbound only) |
| DNS failure | — | Yes | Windows |
| Time change | — | Yes | Windows |

Requirements differ by model:

- **Workspaces.** Chaos Studio installs the agent during the run and leaves it installed. The target needs a managed identity and public outbound connectivity to Chaos Studio. Virtual machines that are restricted to private networking aren't supported. VM sizes that use Arm-based processors aren't supported. For the validated Linux distributions, see [Agent-based Scenario requirements](chaos-studio-scenarios.md#agent-based-scenario-requirements).
- **Classic.** You install the agent. For the supported operating systems, see [Agent OS support for Experiments (classic)](chaos-agent-os-support.md).

### Azure Kubernetes Service

| Target | Fault | Workspaces | Classic | Notes |
|---|---|---|---|---|
| Node scale sets in the infrastructure resource group | Shutdown, with an optional zone filter | Yes | Yes | Doesn't apply to node pools that node autoprovisioning creates. |
| Pods | Pod delete | AKS extension | Chaos Mesh Pod Chaos | |
| Pods | Pod CPU hog, pod memory hog | AKS extension | Chaos Mesh Stress Chaos | |
| Pods | Pod network latency, pod network loss | AKS extension | Chaos Mesh Network Chaos | Extension: Linux amd64 nodes only. Not available when Deployment Safeguards enforces policies. |
| Pods | HTTP, DNS, I/O, kernel, and time faults | — | Chaos Mesh HTTP, DNS, IO, Kernel, and Time Chaos | |

The AKS extension doesn't support clusters that have only arm64 node pools, or Windows node pools. For the full requirements and known issues, see [Chaos Studio extension for AKS (preview) overview](chaos-studio-aks-extension-overview.md).

### Databases

| Resource type | Fault | Workspaces | Classic | How it ends |
|---|---|---|---|---|
| `Microsoft.DocumentDB/databaseAccounts` | Offline region | Yes | — | Cancelable |
| | Cosmos DB Failover | — | Yes | See the classic library |
| `Microsoft.DBforMySQL/flexibleServers` | Failover | Yes | — | Cancelable. `RestoreOnStop` tries to restore the original primary. |
| | Restart | Yes | — | Discrete |
| `Microsoft.DBforPostgreSQL/flexibleServers` | Failover, planned or forced | Yes | — | Cancelable. `RestoreOnStop` runs a planned restore. |
| `Microsoft.Sql/servers/databases` | Failover | Yes | — | Cancelable. `ForceAllowDataLoss` can lose data. |
| `Microsoft.Sql/servers/failoverGroups` | Failover | Yes | — | Cancelable. `ForceAllowDataLoss` can lose data. |
| `Microsoft.Sql/managedInstances` | Failover managed instance | Yes | — | Discrete |

### Caching

| Resource type | Fault | Workspaces | Classic | How it ends |
|---|---|---|---|---|
| `Microsoft.Cache/redis` | Reboot all nodes, the primary node, or the secondary node | Yes | Yes | Discrete |
| `Microsoft.Cache/redisEnterprise` | Flush database | Yes | — | Discrete. The data isn't restored. |
| | Force unlink from a geo-replication group | Yes | — | Discrete. The link isn't restored. |

### Messaging

| Resource type | Fault | Workspaces | Classic | How it ends |
|---|---|---|---|---|
| `Microsoft.ServiceBus/namespaces` | Change queue state | Yes | Yes | Cancelable |
| | Change topic state | Yes | Yes | Discrete. Add a later Action to set the state to `Active`. |
| | Change subscription state | Yes | Yes | Discrete. Add a later Action to set the state to `Active`. |
| `Microsoft.EventHub/namespaces` | Change event hub state | Yes | Yes | Cancelable |

### Networking

| Resource type | Fault | Workspaces | Classic | How it ends |
|---|---|---|---|---|
| `Microsoft.Network/networkSecurityGroups` | Apply NSG rule | Yes | Yes | Cancelable. Chaos Studio removes the rule. |
| `Microsoft.Network/loadBalancers` | Update load balancer admin state | Yes | — | Cancelable |

### Security

| Resource type | Fault | Workspaces | Classic | How it ends |
|---|---|---|---|---|
| `Microsoft.KeyVault/vaults` | Deny access | — | Yes | See the classic library |
| | Disable certificate, increment certificate version, update certificate policy | — | Yes | See the classic library |

In Workspaces, no Action targets a key vault. The Key Vault Public Endpoint Outage template targets an NSG.

### Storage

| Resource type | Fault | Workspaces | Classic | How it ends |
|---|---|---|---|---|
| `Microsoft.Storage/storageAccounts` | Planned failover | Yes | — | Discrete. Chaos Studio doesn't fail back. |

### Application and integration

| Resource type | Fault | Workspaces | Classic | How it ends |
|---|---|---|---|---|
| `Microsoft.Web/sites` | Restart | Yes | — | Discrete |
| | Kill process | Yes | — | Discrete |
| | Stop App Service | — | Yes | See the classic library |
| `Microsoft.ApiManagement/service` | Update backend | Yes | — | Cancelable |
| `Microsoft.LoadTestService/loadTests` | Start, Stop | Yes | Yes | Discrete |
| `Microsoft.Automation/automationAccounts` | Start runbook | Yes | — | Cancelable |

The Cache Stampede with Process Crash template, which uses **Kill process**, supports Windows App Service only.

## What the faults don't reproduce

A fault is a controlled approximation of an outage. It isn't the outage. The following limits matter when you decide what a test result proves.

### Zone down

- Compute Zone Down shuts down virtual machines and scale set instances in a zone. It doesn't affect other zonal resources unless the Scenario has an Action for them. Templates exist for PostgreSQL, SQL Database, SQL Managed Instance, and Azure Cache for Redis.
- The shutdown doesn't reproduce every effect of an availability zone outage. It removes compute capacity in the zone. It doesn't change the zone's network or the Azure services that run there.
- For AKS, the fault acts on node scale sets that AKS manages. AKS reconciliation and the cluster autoscaler can change capacity during the run.

### Region down

Chaos Studio has no fault that takes down a region. You can take one Azure Cosmos DB region offline, fail over a storage account, and fail over a SQL failover group. Each fault tests one service. To test a regional failover of a whole application, combine these Actions with your own traffic management steps.

### DNS, Microsoft Entra ID, and Key Vault outages

In Workspaces, these three templates use NSG rules. They block a network path. They don't change the service.

- A rule affects only traffic that passes through the NSGs that you select.
- The Key Vault template blocks the `AzureKeyVault` service tag. It doesn't affect Key Vault private endpoints or Azure Resource Manager operations on the vault.
- A block makes the dependency unreachable. It doesn't reproduce a dependency that's slow, that returns errors, or that returns wrong answers.

### Failovers

- A planned failover is more orderly than an unplanned failure. If your concern is an abrupt loss, use the forced option where the Action has one, and accept its risk.
- A forced SQL failover (`ForceAllowDataLoss`) can lose data. Don't use it on data that you can't lose.

### In-guest network faults (classic)

- The faults support IPv4 addresses only.
- Network disconnect affects only new connections. Existing connections stay open until the service or process restarts.
- On Linux, the faults affect outbound traffic only.

### AKS pod faults

- A pod fault isn't a zone outage. Kubernetes can replace a pod and the application can still lose requests or data.
- With the AKS extension, the run status can differ from the effect in the cluster. Confirm the effect with Kubernetes events and application metrics.

## Failures that Chaos Studio can't inject

The following list isn't complete. It names the gaps that matter most for common Azure architectures. If you need one of them, [open an issue](https://github.com/microsoft/chaos-studio/issues) so that other customers can find it and add to it.

- **Azure platform failures.** Chaos Studio acts on your resources through the same APIs that you can call. It can't fail the Azure control plane, a datacenter, or a service that Microsoft operates for all customers.
- **A whole zone or region.** See [Zone down](#zone-down) and [Region down](#region-down).
- **Degraded dependencies.** Except for the in-guest and in-cluster network faults, the faults make a resource unavailable. They don't make an Azure service slow, throttled, or partly wrong.
- **Resource types that aren't in the matrix.** If a resource type isn't in [Matrix by resource type](#matrix-by-resource-type), no fault targets it. You can often test the failure indirectly:
  - Block the network path to the resource with **Apply NSG rule**.
  - Run your own operation with **Start runbook**.
  - Fail the compute that calls the resource.
- **In-guest network and disk faults in Workspaces.** Use Experiments (classic).
- **Classic faults in Workspaces.** A Workspace rejects Actions that aren't in its catalog. Dynamic targeting and scheduled runs are also classic only. See [Choose between Chaos Studio Workspaces and Experiments (classic)](chaos-studio-workspaces-vs-experiments.md).

## Plan a test that the matrix supports

The matrix tells you what Chaos Studio can do. It doesn't tell you what your test proves. Before you run a fault:

1. **State the expected outcome.** For example: "When zone 1 loses its nodes, 99 percent of requests still succeed, and no acknowledged order is lost."
1. **Limit the blast radius.** Scope the Workspace to the resources that you approved. Use [resource filters](chaos-studio-workspaces-resource-targeting.md) and exclusions. Start in a preproduction environment.
1. **Know how the fault ends.** For a Discrete Action, write down who restores the resource and how.
1. **Set stop conditions.** Agree on the signals that end the test early, and who cancels the run.
1. **Measure the application, not the fault.** A completed Action shows that Chaos Studio ran the fault. It doesn't show that your application recovered. Use test traffic, application metrics, and data checks.
1. **Record inconclusive results as inconclusive.** If the fault didn't affect the resources that served your test traffic, the run isn't a pass.

## Check the current catalog

The matrix can lag behind the service. To get the current Workspaces Action catalog for your subscription, see [List Actions with the REST API](chaos-studio-workspaces-supported-resources.md#list-actions-with-the-rest-api). For regions, see [Regional availability by resource model](chaos-studio-region-availability.md).

[!INCLUDE [chaos-studio-feedback](includes/chaos-studio-feedback.md)]

## Related content

- [Scenarios and outage templates for Chaos Studio Workspaces](chaos-studio-scenarios.md)
- [Chaos Studio Workspaces limitations (preview)](chaos-studio-workspaces-limitations.md)
- [Limitations and known issues for Experiments (classic)](chaos-studio-limitations.md)
- [Chaos engineering and resilience in Azure](chaos-studio-chaos-engineering-overview.md)
