---
title: Azure Chaos Studio fault and action library
description: Understand the available actions you can use with Azure Chaos Studio, including any prerequisites and parameters.
services: chaos-studio
author: rsgel
ms.topic: article
ms.date: 01/02/2024
ms.author: abbyweisberg
ms.reviewer: prashabora
ms.service: azure-chaos-studio
ms.custom: linux-related-content
---

# Azure Chaos Studio fault and action library

This article lists the faults you can use in Chaos Studio, organized by the applicable resource type. To understand which role assignments are recommended for each resource type, see [Supported resource types and role assignments for Azure Chaos Studio](./chaos-studio-fault-providers.md).

## Agent-based faults

Agent-based faults are injected into **Azure Virtual Machines** or **Virtual Machine Scale Set** instances by installing the Chaos Studio Agent. Find the service-direct fault options for these resources below in the [Virtual Machine](#virtual-machines-service-direct) and [Virtual Machine Scale Set](#virtual-machine-scale-set) tables.

| Applicable OS types | Fault name                                                                  | Applicable scenarios                                        |
|---------------------|-----------------------------------------------------------------------------|-------------------------------------------------------------|
| Windows, Linux      | [CPU Pressure](#cpu-pressure)                                               | Compute capacity loss, resource pressure                    |
| Windows, Linux      | [Kill Process](#kill-process)                                               | Dependency disruption                                       |
| Windows             | [Pause Process](#pause-process)                                             | Dependency disruption, service disruption                   |
| Windows<sup>1</sup>, Linux<sup>2</sup>      | [Network Disconnect](#network-disconnect)                                   | Network disruption                                          |
| Windows<sup>1</sup>, Linux<sup>2</sup>      | [Network Latency](#network-latency)                                         | Network performance degradation                             |
| Windows<sup>1</sup>, Linux<sup>2</sup>      | [Network Packet Loss](#network-packet-loss)                                 | Network reliability issues                                  |
| Windows, Linux<sup>2</sup>      | [Network Isolation](#network-isolation)                                     | Network disruption                                          |
| Windows             | [DNS Failure](#dns-failure)                                                 | DNS resolution issues                                       |
| Windows             | [Network Disconnect (Via Firewall)](#network-disconnect-via-firewall)       | Network disruption                                          |
| Windows, Linux      | [Physical Memory Pressure](#physical-memory-pressure)                       | Memory capacity loss, resource pressure                     |
| Windows, Linux      | [Stop Service](#stop-service)                                               | Service disruption/restart                                  |
| Windows             | [Time Change](#time-change)                                                 | Time synchronization issues                                 |
| Windows             | [Virtual Memory Pressure](#virtual-memory-pressure)                         | Memory capacity loss, resource pressure                     |
| Linux               | [Arbitrary Stress-ng Stressor](#arbitrary-stress-ng-stressor)               | General system stress testing                               |
| Linux               | [Linux DiskIO Pressure](#linux-disk-io-pressure)                            | Disk I/O performance degradation                            |
| Windows             | [DiskIO Pressure](#disk-io-pressure)                                        | Disk I/O performance degradation                            |

<sup>1</sup> TCP/UDP packets only. <sup>2</sup> Outbound network traffic only.

## App Service

This section applies to the `Microsoft.Web/sites` resource type. [Learn more about App Service](/azure/app-service/overview).

| Fault name | Applicable scenarios |
|------------|----------------------|
| [Stop App Service](#stop-app-service) | Service disruption |

## Autoscale Settings

This section applies to the `Microsoft.Insights/autoscaleSettings` resource type. [Learn more about Autoscale Settings](../azure-monitor/autoscale/autoscale-overview.md).

| Fault name | Applicable scenarios |
|------------|----------------------|
| [Disable Autoscale](#disable-autoscale) | Compute capacity loss (when used with Virtual Machine Scale Set Shutdown) |

## Azure Kubernetes Service

This section applies to the `Microsoft.ContainerService/managedClusters` resource type. [Learn more about Azure Kubernetes Service](/azure/aks/intro-kubernetes).

| Fault name | Applicable scenarios |
|------------|----------------------|
| [AKS Chaos Mesh DNS Chaos](#aks-chaos-mesh-dns-chaos) | DNS resolution issues |
| [AKS Chaos Mesh HTTP Chaos](#aks-chaos-mesh-http-chaos) | Network disruption |
| [AKS Chaos Mesh IO Chaos](#aks-chaos-mesh-io-chaos) | Disk degradation/pressure |
| [AKS Chaos Mesh Kernel Chaos](#aks-chaos-mesh-kernel-chaos) | Kernel disruption |
| [AKS Chaos Mesh Network Chaos](#aks-chaos-mesh-network-chaos) | Network disruption |
| [AKS Chaos Mesh Pod Chaos](#aks-chaos-mesh-pod-chaos) | Container disruption |
| [AKS Chaos Mesh Stress Chaos](#aks-chaos-mesh-stress-chaos) | System stress testing |
| [AKS Chaos Mesh Time Chaos](#aks-chaos-mesh-time-chaos) | Time synchronization issues |

## Cloud Services (Classic)

This section applies to the `Microsoft.ClassicCompute/domainNames` resource type. [Learn more about Cloud Services (Classic)](/azure/cloud-services/cloud-services-choose-me).

| Fault name | Applicable scenarios |
|------------|----------------------|
| [Cloud Service Shutdown](#cloud-services-classic-shutdown) | Compute loss |

## Clustered Cache for Redis

This section applies to the `Microsoft.Cache/redis` resource type. [Learn more about Clustered Cache for Redis](/azure/azure-cache-for-redis/cache-overview).

| Fault name | Applicable scenarios |
|------------|----------------------|
| [Azure Cache for Redis (Reboot)](#azure-cache-for-redis-reboot) | Dependency disruption (caches) |

## Cosmos DB

This section applies to the `Microsoft.DocumentDB/databaseAccounts` resource type. [Learn more about Cosmos DB](/azure/cosmos-db/introduction).

| Fault name | Applicable scenarios |
|------------|----------------------|
| [Cosmos DB Failover](#cosmos-db-failover) | Database failover |

## Event Hubs

This section applies to the `Microsoft.EventHub/namespaces` resource type. [Learn more about Event Hubs](/azure/event-hubs/event-hubs-about).

| Fault name | Applicable scenarios |
|------------|----------------------|
| [Change Event Hub State](#change-event-hub-state) | Messaging infrastructure misconfiguration/disruption |

## Key Vault

This section applies to the `Microsoft.KeyVault/vaults` resource type. [Learn more about Key Vault](/azure/key-vault/general/basic-concepts).

| Fault name | Applicable scenarios |
|------------|----------------------|
| [Key Vault: Deny Access](#key-vault-deny-access) | Certificate denial |
| [Key Vault: Disable Certificate](#key-vault-disable-certificate) | Certificate disruption |
| [Key Vault: Increment Certificate Version](#key-vault-increment-certificate-version) | Certificate version increment |
| [Key Vault: Update Certificate Policy](#key-vault-update-certificate-policy) | Certificate policy changes/misconfigurations |

## Network Security Groups

This section applies to the `Microsoft.Network/networkSecurityGroups` resource type. [Learn more about network security groups](/azure/virtual-network/network-security-groups-overview).

| Fault name | Applicable scenarios |
|------------|----------------------|
| [NSG Security Rule](#nsg-security-rule) | Network disruption (for many Azure services) |

## Service Bus

This section applies to the `Microsoft.ServiceBus/namespaces` resource type. [Learn more about Service Bus](/azure/service-bus-messaging/service-bus-messaging-overview).

| Fault name | Applicable scenarios |
|------------|----------------------|
| [Change Queue State](#service-bus-change-queue-state) | Messaging infrastructure misconfiguration/disruption |
| [Change Subscription State](#service-bus-change-subscription-state) | Messaging infrastructure misconfiguration/disruption |
| [Change Topic State](#service-bus-change-topic-state) | Messaging infrastructure misconfiguration/disruption |

## Virtual Machines (service-direct)

This section applies to the `Microsoft.Compute/virtualMachines` resource type. [Learn more about Virtual Machines](/azure/virtual-machines/overview).

| Fault name | Applicable scenarios |
|------------|----------------------|
| [VM Redeploy](#vm-redeploy) | Compute disruption, maintenance events |
| [VM Shutdown](#virtual-machine-shutdown) | Compute loss/disruption |

## Virtual Machine Scale Set

This section applies to the `Microsoft.Compute/virtualMachineScaleSets` resource type. [Learn more about Virtual Machine Scale Sets](/azure/virtual-machine-scale-sets/overview).

| Fault name | Applicable scenarios |
|------------|----------------------|
| [Virtual Machine Scale Set Shutdown](#virtual-machine-scale-set-shutdown-version-10) | Compute loss/disruption |
| [Virtual Machine Scale Set Shutdown (2.0)](#virtual-machine-scale-set-shutdown-version-20) | Compute loss/disruption (by Availability Zone) |

## Orchestration actions

These actions are building blocks for constructing effective experiments. Use them in combination with other faults, such as running a load test while in parallel shutting down compute instances in a zone.

| Action category | Fault name |
|-----------------|------------|
| Load | [Start load test (Azure Load Testing)](#start-load-test-azure-load-testing) |
| Load | [Stop load test (Azure Load Testing)](#stop-load-test-azure-load-testing) |
| Time delay | [Delay](#delay) |

## Details: Agent-based faults

### Network Disconnect

| Property | Value |
|-|-|
| Capability name | NetworkDisconnect-1.1 |
| Target type | Microsoft-Agent |
| Supported OS types | Windows, Linux (outbound traffic only) |
| Description | Blocks network traffic for specified port range and network block. At least one destinationFilter or inboundDestinationFilter array must be provided. |
| Prerequisites | **Windows:** The agent must run as administrator, which happens by default if installed as a VM extension. |
| | **Linux:** The `tc` (Traffic Control) package is used for network faults. If it isn't already installed, the agent automatically attempts to install it from the default package manager. |
| Urn | urn:csci:microsoft:agent:networkDisconnect/1.1 |
| Fault type | Continuous. |
| Parameters (key, value) |  |
| destinationFilters | Delimited JSON array of packet filters defining which outbound packets to target. Maximum of 16.|
| inboundDestinationFilters | Delimited JSON array of packet filters defining which inbound packets to target. Maximum of 16. |
| virtualMachineScaleSetInstances | An array of instance IDs when you apply this fault to a virtual machine scale set. Required for virtual machine scale sets in uniform orchestration mode. [Learn more about instance IDs](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-instance-ids#scale-set-instance-id-for-uniform-orchestration-mode). |

The parameters **destinationFilters** and **inboundDestinationFilters** use the following array of packet filters.

| Property | Value |
|-|-|
| address | IP address that indicates the start of the IP range. |
| subnetMask | Subnet mask for the IP address range. |
| portLow | (Optional) Port number of the start of the port range. |
| portHigh | (Optional) Port number of the end of the port range. |

#### Sample JSON

```json
{
  "name": "branchOne",
  "actions": [
    {
      "type": "continuous",
      "name": "urn:csci:microsoft:agent:networkDisconnect/1.1",
      "parameters": [
        {
          "key": "destinationFilters",
          "value": "[ { \"address\": \"23.45.229.97\", \"subnetMask\": \"255.255.255.224\", \"portLow\": \"5000\", \"portHigh\": \"5200\" } ]"
        },
        {
          "key": "inboundDestinationFilters",
          "value": "[ { \"address\": \"23.45.229.97\", \"subnetMask\": \"255.255.255.224\", \"portLow\": \"5000\", \"portHigh\": \"5200\" } ]"
        },
        {
          "key": "virtualMachineScaleSetInstances",
          "value": "[0,1,2]"
        }
      ],
      "duration": "PT10M",
      "selectorid": "myResources"
    }
  ]
}
```

#### Limitations

* The agent-based network faults currently only support IPv4 addresses.
* The network disconnect fault only affects new connections. Existing active connections continue to persist. You can restart the service or process to force connections to break.
* When running on Windows, the network disconnect fault currently only works with TCP or UDP packets.
* When running on Linux, this fault can only affect **outbound** traffic, not inbound traffic. The fault can affect **both inbound and outbound** traffic on Windows environments (via the `inboundDestinationFilters` and `destinationFilters` parameters).

### Network Disconnect (Via Firewall)

| Property | Value |
|-|-|
| Capability name | NetworkDisconnectViaFirewall-1.0 |
| Target type | Microsoft-Agent |
| Supported OS types | Windows |
| Description | Applies a Windows Firewall rule to block outbound traffic for specified port range and network block. |
| Prerequisites | Agent must run as administrator. If the agent is installed as a VM extension, it runs as administrator by default. |
| Urn | urn:csci:microsoft:agent:networkDisconnectViaFirewall/1.0 |
| Fault type | Continuous. |
| Parameters (key, value) |  |
| destinationFilters | Delimited JSON array of packet filters that define which outbound packets to target for fault injection. |
| address | IP address that indicates the start of the IP range. |
| subnetMask | Subnet mask for the IP address range. |
| portLow | (Optional) Port number of the start of the port range. |
| portHigh | (Optional) Port number of the end of the port range. |
| virtualMachineScaleSetInstances | An array of instance IDs when you apply this fault to a virtual machine scale set. Required for virtual machine scale sets in uniform orchestration mode. [Learn more about instance IDs](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-instance-ids#scale-set-instance-id-for-uniform-orchestration-mode). |

#### Sample JSON

```json
{
  "name": "branchOne",
  "actions": [
    {
      "type": "continuous",
      "name": "urn:csci:microsoft:agent:networkDisconnectViaFirewall/1.0",
      "parameters": [
        {
          "key": "destinationFilters",
          "value": "[ { \"Address\": \"23.45.229.97\", \"SubnetMask\": \"255.255.255.224\", \"PortLow\": \"5000\", \"PortHigh\": \"5200\" } ]"
        },
        {
          "key": "virtualMachineScaleSetInstances",
          "value": "[0,1,2]"
        }
      ],
      "duration": "PT10M",
      "selectorid": "myResources"
    }
  ]
}
```

#### Limitations

* The agent-based network faults currently only support IPv4 addresses.
* This fault currently only affects new connections. Existing active connections are unaffected. You can restart the service or process to force connections to break.

### Network Latency

| Property | Value |
|-|-|
| Capability name | NetworkLatency-1.1 |
| Target type | Microsoft-Agent |
| Supported OS types | Windows, Linux (outbound traffic only) |
| Description | Increases network latency for a specified port range and network block. At least one destinationFilter or inboundDestinationFilter array must be provided. |
| Prerequisites | **Windows:** The agent must run as administrator, which happens by default if installed as a VM extension. |
| | **Linux:** The `tc` (Traffic Control) package is used for network faults. If it isn't already installed, the agent automatically attempts to install it from the default package manager. |
| Urn | urn:csci:microsoft:agent:networkLatency/1.1 |
| Fault type | Continuous. |
| Parameters (key, value) |  |
| latencyInMilliseconds | Amount of latency to be applied in milliseconds. |
| destinationFilters | Delimited JSON array of packet filters defining which outbound packets to target. Maximum of 16.|
| inboundDestinationFilters | Delimited JSON array of packet filters defining which inbound packets to target. Maximum of 16. |
| virtualMachineScaleSetInstances | An array of instance IDs when you apply this fault to a virtual machine scale set. Required for virtual machine scale sets in uniform orchestration mode. [Learn more about instance IDs](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-instance-ids#scale-set-instance-id-for-uniform-orchestration-mode). |

The parameters **destinationFilters** and **inboundDestinationFilters** use the following array of packet filters.

| Property | Value |
|-|-|
| address | IP address that indicates the start of the IP range. |
| subnetMask | Subnet mask for the IP address range. |
| portLow | (Optional) Port number of the start of the port range. |
| portHigh | (Optional) Port number of the end of the port range. |

#### Sample JSON

```json
{
  "name": "branchOne",
  "actions": [
    {
      "type": "continuous",
      "name": "urn:csci:microsoft:agent:networkLatency/1.1",
      "parameters": [
        {
          "key": "destinationFilters",
          "value": "[ { \"address\": \"23.45.229.97\", \"subnetMask\": \"255.255.255.224\", \"portLow\": \"5000\", \"portHigh\": \"5200\" } ]"
        },
        {
          "key": "inboundDestinationFilters",
          "value": "[ { \"address\": \"23.45.229.97\", \"subnetMask\": \"255.255.255.224\", \"portLow\": \"5000\", \"portHigh\": \"5200\" } ]"
        },
        {
          "key": "latencyInMilliseconds",
          "value": "100",
        },
        {
          "key": "virtualMachineScaleSetInstances",
          "value": "[0,1,2]"
        }
      ],
      "duration": "PT10M",
      "selectorid": "myResources"
    }
  ]
}
```

#### Limitations

* The agent-based network faults currently only support IPv4 addresses.
* When running on Linux, the network latency fault can only affect **outbound** traffic, not inbound traffic. The fault can affect **both inbound and outbound** traffic on Windows environments (via the `inboundDestinationFilters` and `destinationFilters` parameters).
* When running on Windows, the network latency fault currently only works with TCP or UDP packets.
* This fault currently only affects new connections. Existing active connections are unaffected. You can restart the service or process to force connections to break.

### Network Packet Loss

| Property | Value |
|-|-|
| Capability name | NetworkPacketLoss-1.0 |
| Target type | Microsoft-Agent |
| Supported OS types | Windows, Linux (outbound traffic only) |
| Description | Introduces packet loss for outbound traffic at a specified rate, between 0.0 (no packets lost) and 1.0 (all packets lost). This action can help simulate scenarios like network congestion or network hardware issues. |
| Prerequisites | **Windows:** The agent must run as administrator, which happens by default if installed as a VM extension. |
| | **Linux:** The `tc` (Traffic Control) package is used for network faults. If it isn't already installed, the agent automatically attempts to install it from the default package manager. |
| Urn | urn:csci:microsoft:agent:networkPacketLoss/1.0 |
| Fault type | Continuous. |
| Parameters (key, value) |  |
| packetLossRate | The rate at which packets matching the destination filters will be lost, ranging from 0.0 to 1.0. |
| virtualMachineScaleSetInstances | An array of instance IDs when you apply this fault to a virtual machine scale set. Required for virtual machine scale sets in uniform orchestration mode. [Learn more about instance IDs](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-instance-ids#scale-set-instance-id-for-uniform-orchestration-mode). |
| destinationFilters | Delimited JSON array of packet filters (parameters below) that define which outbound packets to target for fault injection. Maximum of three.|
| address | IP address that indicates the start of the IP range. |
| subnetMask | Subnet mask for the IP address range. |
| portLow | (Optional) Port number of the start of the port range. |
| portHigh | (Optional) Port number of the end of the port range. |

#### Sample JSON

```json
{
  "name": "branchOne",
  "actions": [
    {
      "type": "continuous",
      "name": "urn:csci:microsoft:agent:networkPacketLoss/1.0",
      "parameters": [
            {
                "key": "destinationFilters",
                "value": "[{\"address\":\"23.45.229.97\",\"subnetMask\":\"255.255.255.224\",\"portLow\":5000,\"portHigh\":5200}]"
            },
            {
                "key": "packetLossRate",
                "value": "0.5"
            },
            {
                "key": "virtualMachineScaleSetInstances",
                "value": "[0,1,2]"
            }
        ],
      "duration": "PT10M",
      "selectorid": "myResources"
    }
  ]
}
```

#### Limitations

* The agent-based network faults currently only support IPv4 addresses.
* When running on Windows, the network packet loss fault currently only works with TCP or UDP packets.
* When running on Linux, this fault can only affect **outbound** traffic, not inbound traffic. The fault can affect **both inbound and outbound** traffic on Windows environments (via the `inboundDestinationFilters` and `destinationFilters` parameters).
* This fault currently only affects new connections. Existing active connections are unaffected. You can restart the service or process to force connections to break.

### Network Isolation

| Property | Value |
|-|-|
| Capability name | NetworkIsolation-1.0 |
| Target type | Microsoft-Agent |
| Supported OS types | Windows, Linux (outbound only) |
| Description | Fully isolate the virtual machine from network connections by dropping all IP-based inbound (on Windows) and outbound (on Windows and Linux) packets for the specified duration. At the end of the duration, network connections will be re-enabled. Because the agent depends on network traffic, this action cannot be canceled and will run to the specified duration. |
| Prerequisites | **Windows:** The agent must run as administrator, which happens by default if installed as a VM extension. |
| | **Linux:** The `tc` (Traffic Control) package is used for network faults. If it isn't already installed, the agent automatically attempts to install it from the default package manager. |
| Urn | urn:csci:microsoft:agent:networkIsolation/1.0 |
| Fault type | Continuous. |
| Parameters (key, value) |  |
| virtualMachineScaleSetInstances | An array of instance IDs when you apply this fault to a virtual machine scale set. Required for virtual machine scale sets in uniform orchestration mode, optional otherwise. [Learn more about instance IDs](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-instance-ids#scale-set-instance-id-for-uniform-orchestration-mode). |

#### Sample JSON

```json
{
  "name": "branchOne",
  "actions": [
    {
      "type": "continuous",
      "name": "urn:csci:microsoft:agent:networkIsolation/1.0",
      "parameters": [],
      "duration": "PT10M",
      "selectorid": "myResources"
    }
  ]
}
```

#### Limitations

* Because the agent depends on network traffic, **this action cannot be canceled** and will run to the specified duration. Use with caution.
* This fault currently only affects new connections. Existing active connections are unaffected. You can restart the service or process to force connections to break.
* When running on Linux, this fault can only affect **outbound** traffic, not inbound traffic. The fault can affect **both inbound and outbound** traffic on Windows environments.


### DNS Failure

| Property | Value |
|-|-|
| Capability name | DnsFailure-1.0 |
| Target type | Microsoft-Agent |
| Supported OS types | Windows |
| Description | Substitutes DNS lookup request responses with a specified error code. DNS lookup requests that are substituted must:<ul><li>Originate from the VM.</li><li>Match the defined fault parameters.</li></ul>DNS lookups that aren't made by the Windows DNS client aren't affected by this fault. |
| Prerequisites | None. |
| Urn | urn:csci:microsoft:agent:dnsFailure/1.0 |
| Fault type | Continuous. |
| Parameters (key, value) |  |
| hosts | Delimited JSON array of host names to fail DNS lookup request for.<br><br>This property accepts wildcards (`*`), but only for the first subdomain in an address and only applies to the subdomain for which they're specified. For example:<ul><li>\*.microsoft.com is supported.</li><li>subdomain.\*.microsoft isn't supported.</li><li>\*.microsoft.com doesn't work for multiple subdomains in an address, such as subdomain1.subdomain2.microsoft.com.</li></ul>   |
| dnsFailureReturnCode | DNS error code to be returned to the client for the lookup failure (FormErr, ServFail, NXDomain, NotImp, Refused, XDomain, YXRRSet, NXRRSet, NotAuth, NotZone). For more information on DNS return codes, see the [IANA website](https://www.iana.org/assignments/dns-parameters/dns-parameters.xml#dns-parameters-6). |
| virtualMachineScaleSetInstances | An array of instance IDs when you apply this fault to a virtual machine scale set. Required for virtual machine scale sets in uniform orchestration mode. [Learn more about instance IDs](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-instance-ids#scale-set-instance-id-for-uniform-orchestration-mode). |

#### Sample JSON

```json
{
  "name": "branchOne",
  "actions": [
    {
      "type": "continuous",
      "name": "urn:csci:microsoft:agent:dnsFailure/1.0",
      "parameters": [
        {
          "key": "hosts",
          "value": "[ \"www.bing.com\", \"msdn.microsoft.com\" ]"
        },
        {
          "key": "dnsFailureReturnCode",
          "value": "ServFail"
        },
        {
          "key": "virtualMachineScaleSetInstances",
          "value": "[0,1,2]"
        }
      ],
      "duration": "PT10M",
      "selectorid": "myResources"
    }
  ]
}
```

#### Limitations

* The DNS Failure fault requires Windows 2019 RS5 or newer.
* DNS Cache is ignored during the duration of the fault for the host names defined in the fault.

### CPU Pressure

| Property | Value |
|-|-|
| Capability name | CPUPressure-1.0 |
| Target type | Microsoft-Agent |
| Supported OS types | Windows, Linux |
| Description | Adds CPU pressure, up to the specified value, on the VM where this fault is injected during the fault action. The artificial CPU pressure is removed at the end of the duration or if the experiment is canceled. On Windows, the **% Processor Utility** performance counter is used at fault start to determine current CPU percentage, which is subtracted from the `pressureLevel` defined in the fault so that **% Processor Utility** hits approximately the `pressureLevel` defined in the fault parameters. |
| Prerequisites | **Linux**: The **stress-ng** utility needs to be installed. Installation happens automatically as part of agent installation, using the default package manager, on several operating systems including Debian-based (like Ubuntu), Red Hat Enterprise Linux, and OpenSUSE. For other distributions, including Azure Linux, you must install **stress-ng** manually. For more information, see the [upstream project repository](https://github.com/ColinIanKing/stress-ng). |
| | **Windows**: None. |
| Urn | urn:csci:microsoft:agent:cpuPressure/1.0 |
| Fault type | Continuous. |
| Parameters (key, value)  | |
| pressureLevel | An integer between 1 and 95 that indicates how much CPU pressure (%) is applied to the VM in terms of **% CPU Usage** |
| virtualMachineScaleSetInstances | An array of instance IDs when you apply this fault to a virtual machine scale set. Required for virtual machine scale sets in uniform orchestration mode. [Learn more about instance IDs](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-instance-ids#scale-set-instance-id-for-uniform-orchestration-mode). |

#### Sample JSON
```json
{
  "name": "branchOne",
  "actions": [
    {
      "type": "continuous",
      "name": "urn:csci:microsoft:agent:cpuPressure/1.0",
      "parameters": [
        {
          "key": "pressureLevel",
          "value": "95"
        },
        {
          "key": "virtualMachineScaleSetInstances",
          "value": "[0,1,2]"
        }
      ],
      "duration": "PT10M",
      "selectorid": "myResources"
    }
  ]
}
```

#### Limitations
Known issues on Linux:
* The stress effect might not be terminated correctly if `AzureChaosAgent` is unexpectedly killed.

### Physical Memory Pressure

| Property | Value |
|-|-|
| Capability name | PhysicalMemoryPressure-1.0 |
| Target type | Microsoft-Agent |
| Supported OS types | Windows, Linux |
| Description | Adds physical memory pressure, up to the specified value, on the VM where this fault is injected during the fault action. The artificial physical memory pressure is removed at the end of the duration or if the experiment is canceled. |
| Prerequisites | **Linux**: The **stress-ng** utility needs to be installed. Installation happens automatically as part of agent installation, using the default package manager, on several operating systems including Debian-based (like Ubuntu), Red Hat Enterprise Linux, and OpenSUSE. For other distributions, including Azure Linux, you must install **stress-ng** manually. For more information, see the [upstream project repository](https://github.com/ColinIanKing/stress-ng). |
| | **Windows**: None. |
| Urn | urn:csci:microsoft:agent:physicalMemoryPressure/1.0 |
| Fault type | Continuous. |
| Parameters (key, value) |  |
| pressureLevel | An integer between 1 and 95 that indicates how much physical memory pressure (%) is applied to the VM. |
| virtualMachineScaleSetInstances | An array of instance IDs when you apply this fault to a virtual machine scale set. Required for virtual machine scale sets in uniform orchestration mode. [Learn more about instance IDs](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-instance-ids#scale-set-instance-id-for-uniform-orchestration-mode). |

#### Sample JSON

```json
{
  "name": "branchOne",
  "actions": [
    {
      "type": "continuous",
      "name": "urn:csci:microsoft:agent:physicalMemoryPressure/1.0",
      "parameters": [
        {
          "key": "pressureLevel",
          "value": "95"
        },
        {
          "key": "virtualMachineScaleSetInstances",
          "value": "[0,1,2]"
        }
      ],
      "duration": "PT10M",
      "selectorid": "myResources"
    }
  ]
}
```

#### Limitations
Currently, the Windows agent doesn't reduce memory pressure when other applications increase their memory usage. If the overall memory usage exceeds 100%, the Windows agent might crash.

### Virtual Memory Pressure

| Property | Value |
|-|-|
| Capability name | VirtualMemoryPressure-1.0 |
| Target type | Microsoft-Agent |
| Supported OS types | Windows |
| Description | Adds virtual memory pressure, up to the specified value, on the VM where this fault is injected during the fault action. The artificial virtual memory pressure is removed at the end of the duration or if the experiment is canceled. |
| Prerequisites | None. |
| Urn | urn:csci:microsoft:agent:virtualMemoryPressure/1.0 |
| Fault type | Continuous. |
| Parameters (key, value) |  |
| pressureLevel | An integer between 1 and 95 that indicates how much physical memory pressure (%) is applied to the VM. |
| virtualMachineScaleSetInstances | An array of instance IDs when you apply this fault to a virtual machine scale set. Required for virtual machine scale sets in uniform orchestration mode. [Learn more about instance IDs](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-instance-ids#scale-set-instance-id-for-uniform-orchestration-mode). |

#### Sample JSON

```json
{
  "name": "branchOne",
  "actions": [
    {
      "type": "continuous",
      "name": "urn:csci:microsoft:agent:virtualMemoryPressure/1.0",
      "parameters": [
        {
          "key": "pressureLevel",
          "value": "95"
        },
        {
          "key": "virtualMachineScaleSetInstances",
          "value": "[0,1,2]"
        }
      ],
      "duration": "PT10M",
      "selectorid": "myResources"
    }
  ]
}
```

### Disk IO Pressure

| Property | Value |
|-|-|
| Capability name | DiskIOPressure-1.1 |
| Target type | Microsoft-Agent |
| Supported OS types | Windows |
| Description | Uses the [diskspd utility](https://github.com/Microsoft/diskspd/wiki) to add disk pressure to a Virtual Machine. Pressure is added to the primary disk by default, or the disk specified with the targetTempDirectory parameter. This fault has five different modes of execution. The artificial disk pressure is removed at the end of the duration or if the experiment is canceled. |
| Prerequisites | None. |
| Urn | urn:csci:microsoft:agent:diskIOPressure/1.1 |
| Fault type | Continuous. |
| Parameters (key, value) |  |
| pressureMode | The preset mode of disk pressure to add to the primary storage of the VM. Must be one of the `PressureModes` in the following table. |
| targetTempDirectory | (Optional) The directory to use for applying disk pressure. For example, `D:/Temp`. If the parameter is not included, pressure is added to the primary disk. |
| virtualMachineScaleSetInstances | An array of instance IDs when you apply this fault to a virtual machine scale set. Required for virtual machine scale sets in uniform orchestration mode. [Learn more about instance IDs](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-instance-ids#scale-set-instance-id-for-uniform-orchestration-mode). |

#### Pressure modes

| PressureMode | Description |
| -- | -- |
| PremiumStorageP10IOPS | numberOfThreads = 1<br/>randomBlockSizeInKB = 64<br/>randomSeed = 10<br/>numberOfIOperThread = 25<br/>sizeOfBlocksInKB = 8<br/>sizeOfWriteBufferInKB = 64<br/>fileSizeInGB = 2<br/>percentOfWriteActions = 50 |
| PremiumStorageP10Throttling |<br/>numberOfThreads = 2<br/>randomBlockSizeInKB = 64<br/>randomSeed = 10<br/>numberOfIOperThread = 25<br/>sizeOfBlocksInKB = 64<br/>sizeOfWriteBufferInKB = 64<br/>fileSizeInGB = 1<br/>percentOfWriteActions = 50 |
| PremiumStorageP50IOPS | numberOfThreads = 32<br/>randomBlockSizeInKB = 64<br/>randomSeed = 10<br/>numberOfIOperThread = 32<br/>sizeOfBlocksInKB = 8<br/>sizeOfWriteBufferInKB = 64<br/>fileSizeInGB = 1<br/>percentOfWriteActions = 50 |
| PremiumStorageP50Throttling | numberOfThreads = 2<br/>randomBlockSizeInKB = 1024<br/>randomSeed = 10<br/>numberOfIOperThread = 2<br/>sizeOfBlocksInKB = 1024<br/>sizeOfWriteBufferInKB = 1024<br/>fileSizeInGB = 20<br/>percentOfWriteActions = 50|
| Default | numberOfThreads = 2<br/>randomBlockSizeInKB = 64<br/>randomSeed = 10<br/>numberOfIOperThread = 2<br/>sizeOfBlocksInKB = 64<br/>sizeOfWriteBufferInKB = 64<br/>fileSizeInGB = 1<br/>percentOfWriteActions = 50 |

#### Sample JSON

```json
{
  "name": "branchOne",
  "actions": [
    {
      "type": "continuous",
      "name": "urn:csci:microsoft:agent:diskIOPressure/1.1",
      "parameters": [
        {
          "key": "pressureMode",
          "value": "PremiumStorageP10IOPS"
        },
        {
          "key": "targetTempDirectory",
          "value": "C:/temp/"
        },
        {
          "key": "virtualMachineScaleSetInstances",
          "value": "[0,1,2]"
        }
      ],
      "duration": "PT10M",
      "selectorid": "myResources"
    }
  ]
}
```

### Linux Disk IO Pressure

| Property | Value |
|-|-|
| Capability name | LinuxDiskIOPressure-1.1 |
| Target type | Microsoft-Agent |
| Supported OS types | Linux |
| Description | Uses stress-ng to apply pressure to the disk. One or more worker processes are spawned that perform I/O processes with temporary files. Pressure is added to the primary disk by default, or the disk specified with the targetTempDirectory parameter. For information on how pressure is applied, see the [stress-ng](https://wiki.ubuntu.com/Kernel/Reference/stress-ng) article. |
| Prerequisites | **Linux**: The **stress-ng** utility needs to be installed. Installation happens automatically as part of agent installation, using the default package manager, on several operating systems including Debian-based (like Ubuntu), Red Hat Enterprise Linux, and OpenSUSE. For other distributions, including Azure Linux, you must install **stress-ng** manually. For more information, see the [upstream project repository](https://github.com/ColinIanKing/stress-ng). |
| Urn | urn:csci:microsoft:agent:linuxDiskIOPressure/1.1 |
| Fault type | Continuous. |
| Parameters (key, value) |  |
| workerCount | Number of worker processes to run. Setting `workerCount` to 0 generates as many worker processes as there are number of processors. |
| fileSizePerWorker | Size of the temporary file that a worker performs I/O operations against. Integer plus a unit in bytes (b), kilobytes (k), megabytes (m), or gigabytes (g) (for example, `4m` for 4 megabytes and `256g` for 256 gigabytes). |
| blockSize | Block size to be used for disk I/O operations, greater than 1 byte and less than 4 megabytes (maximum value is `4095k`). Integer plus a unit in bytes, kilobytes, or megabytes (for example, `512k` for 512 kilobytes). |
| targetTempDirectory | (Optional) The directory to use for applying disk pressure. For example, `/tmp/`. If the parameter is not included, pressure is added to the primary disk. |
| virtualMachineScaleSetInstances | An array of instance IDs when you apply this fault to a virtual machine scale set. Required for virtual machine scale sets in uniform orchestration mode. [Learn more about instance IDs](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-instance-ids#scale-set-instance-id-for-uniform-orchestration-mode). |

#### Sample JSON

These sample values produced ~100% disk pressure when tested on a `Standard_D2s_v3` virtual machine with Premium SSD LRS. A large fileSizePerWorker and smaller blockSize help stress the disk fully.

```json
{
  "name": "branchOne",
  "actions": [
    {
      "type": "continuous",
      "name": "urn:csci:microsoft:agent:linuxDiskIOPressure/1.1",
      "parameters": [
        {
          "key": "workerCount",
          "value": "4"
        },
        {
          "key": "fileSizePerWorker",
          "value": "2g"
        },
        {
          "key": "blockSize",
          "value": "64k"
        },
        {
          "key": "targetTempDirectory",
          "value": "/tmp/"
        }
      ],
      "duration": "PT10M",
      "selectorid": "myResources"
    }
  ]
}
```


### Stop Service

| Property | Value |
|-|-|
| Capability name | StopService-1.0 |
| Target type | Microsoft-Agent |
| Supported OS types | Windows, Linux |
| Description | Stops a Windows service or a Linux systemd service during the fault. Restarts it at the end of the duration or if the experiment is canceled. |
| Prerequisites | None. |
| Urn | urn:csci:microsoft:agent:stopService/1.0 |
| Fault type | Continuous. |
| Parameters (key, value) |  |
| serviceName | Name of the Windows service or Linux systemd service you want to stop. |
| virtualMachineScaleSetInstances | An array of instance IDs when you apply this fault to a virtual machine scale set. Required for virtual machine scale sets in uniform orchestration mode. [Learn more about instance IDs](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-instance-ids#scale-set-instance-id-for-uniform-orchestration-mode). |

#### Sample JSON

```json
{
  "name": "branchOne",
  "actions": [
    {
      "type": "continuous",
      "name": "urn:csci:microsoft:agent:stopService/1.0",
      "parameters": [
        {
          "key": "serviceName",
          "value": "nvagent"
        },
        {
          "key": "virtualMachineScaleSetInstances",
          "value": "[0,1,2]"
        }
      ],
      "duration": "PT10M",
      "selectorid": "myResources"
    }
  ]
}
```

#### Limitations
* **Windows**: Display names for services aren't supported. Use `sc.exe query` in the command prompt to explore service names.
* **Linux**: Other service types besides systemd, like sysvinit, aren't supported.


### Kill Process

| Property | Value |
|-|-|
| Capability name | KillProcess-1.0 |
| Target type | Microsoft-Agent |
| Supported OS types | Windows, Linux |
| Description | Kills all the **running** instances of a process that matches the process name sent in the fault parameters. Within the duration set for the fault action, a process is killed repetitively based on the value of the kill interval specified. This fault is a destructive fault where system admin would need to manually recover the process if self-healing is configured for it. Note that this fault will error when used on an empty name process, when used with an unspecified interval, or when we cannot find the target process name that we want to kill.|
| Prerequisites | None. |
| Urn | urn:csci:microsoft:agent:killProcess/1.0 |
| Fault type | Continuous. |
| Parameters (key, value) |  |
| processName | Name of a process to continuously kill (without the .exe). The process does not need to be running when the fault begins executing. |
| killIntervalInMilliseconds | Amount of time the fault waits in between successive kill attempts in milliseconds. |
| virtualMachineScaleSetInstances | An array of instance IDs when you apply this fault to a virtual machine scale set. Required for virtual machine scale sets in uniform orchestration mode. [Learn more about instance IDs](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-instance-ids#scale-set-instance-id-for-uniform-orchestration-mode). |

#### Sample JSON

```json
{
  "name": "branchOne",
  "actions": [
    {
      "type": "continuous",
      "name": "urn:csci:microsoft:agent:killProcess/1.0",
      "parameters": [
        {
          "key": "processName",
          "value": "myapp"
        },
        {
          "key": "killIntervalInMilliseconds",
          "value": "1000"
        },
        {
          "key": "virtualMachineScaleSetInstances",
          "value": "[0,1,2]"
        }
      ],
      "duration": "PT10M",
      "selectorid": "myResources"
    }
  ]
}
```

### Pause Process

| Property | Value |
|-|-|
| Capability name | PauseProcess-1.0 |
| Target type | Microsoft-Agent |
| Supported OS types | Windows |
| Description | Pauses (suspends) the specified processes for the specified duration. If there are multiple processes with the same name, this fault suspends all of those processes. Within the fault's duration, the processes are paused repetitively at the specified interval. At the end of the duration or if the experiment is canceled, the processes will resume. |
| Prerequisites | None. |
| Urn | urn:csci:microsoft:agent:pauseProcess/1.0 |
| Fault type | Continuous. |
| Parameters (key, value) |  |
| processNames | Delimited JSON array of process names defining which processes are to be paused. Maximum of 4. The process name can optionally include the ".exe" extension. |
| pauseIntervalInMilliseconds | Amount of time the fault waits between successive pausing attempts, in milliseconds. |
| virtualMachineScaleSetInstances | An array of instance IDs when you apply this fault to a virtual machine scale set. Required for virtual machine scale sets in uniform orchestration mode. [Learn more about instance IDs](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-instance-ids#scale-set-instance-id-for-uniform-orchestration-mode). |

#### Sample JSON

```json
{
  "name": "branchOne",
  "actions": [
    {
      "type": "continuous",
      "name": "urn:csci:microsoft:agent:pauseProcess/1.0",
      "parameters": [
        {
          "key": "processNames",
          "value": "[ \"test-0\", \"test-1.exe\" ]"
        },
        {
          "key": "pauseIntervalInMilliseconds",
          "value": "1000"
        }
      ],
      "duration": "PT10M",
      "selectorid": "myResources"
    }
  ]
}
```

#### Limitations

Currently, a maximum of 4 process names can be listed in the processNames parameter.

### Time Change

| Property | Value |
|-|-|
| Capability name | TimeChange-1.0 |
| Target type | Microsoft-Agent |
| Supported OS types | Windows |
| Description | Changes the system time of the virtual machine and resets the time at the end of the experiment or if the experiment is canceled. |
| Prerequisites | None. |
| Urn | urn:csci:microsoft:agent:timeChange/1.0 |
| Fault type | Continuous. |
| Parameters (key, value) |  |
| dateTime | A DateTime string in [ISO8601 format](https://www.cryptosys.net/pki/manpki/pki_iso8601datetime.html). If `YYYY-MM-DD` values are missing, they're defaulted to the current day when the experiment runs. If Thh:mm:ss values are missing, the default value is 12:00:00 AM. If a 2-digit year is provided (`YY`), it's converted to a 4-digit year (`YYYY`) based on the current century. If the timezone `<Z>` is missing, the default offset is the local timezone. `<Z>` must always include a sign symbol (negative or positive). |
| virtualMachineScaleSetInstances | An array of instance IDs when you apply this fault to a virtual machine scale set. Required for virtual machine scale sets in uniform orchestration mode. [Learn more about instance IDs](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-instance-ids#scale-set-instance-id-for-uniform-orchestration-mode). |

#### Sample JSON

```json
{
  "name": "branchOne",
  "actions": [
    {
      "type": "continuous",
      "name": "urn:csci:microsoft:agent:timeChange/1.0",
      "parameters": [
        {
          "key": "dateTime",
          "value": "2038-01-01T03:14:07"
        },
        {
          "key": "virtualMachineScaleSetInstances",
          "value": "[0,1,2]"
        }
      ],
      "duration": "PT10M",
      "selectorid": "myResources"
    }
  ]
}
```

### Arbitrary Stress-ng Stressor

| Property | Value |
|-|-|
| Capability name | StressNg-1.0 |
| Target type | Microsoft-Agent |
| Supported OS types | Linux |
| Description | Runs any stress-ng command by passing arguments directly to stress-ng. Useful when one of the predefined faults for stress-ng doesn't meet your needs. |
| Prerequisites | **Linux**: The **stress-ng** utility needs to be installed. Installation happens automatically as part of agent installation, using the default package manager, on several operating systems including Debian-based (like Ubuntu), Red Hat Enterprise Linux, and OpenSUSE. For other distributions, including Azure Linux, you must install **stress-ng** manually. For more information, see the [upstream project repository](https://github.com/ColinIanKing/stress-ng). |
| Urn | urn:csci:microsoft:agent:stressNg/1.0 |
| Fault type | Continuous. |
| Parameters (key, value) |  |
| stressNgArguments | One or more arguments to pass to the stress-ng process. For information on possible stress-ng arguments, see the [stress-ng](https://wiki.ubuntu.com/Kernel/Reference/stress-ng) article. **NOTE: Do NOT include the "-t " argument because it will cause an error. Experiment length is defined directly in the Azure chaos experiment UI, NOT in the stressNgArguments.** |

#### Sample JSON

```json
{
  "name": "branchOne",
  "actions": [
    {
      "type": "continuous",
      "name": "urn:csci:microsoft:agent:stressNg/1.0",
      "parameters": [
        {
          "key": "stressNgArguments",
          "value": "--random 64"
        },
        {
          "key": "virtualMachineScaleSetInstances",
          "value": "[0,1,2]"
        }
      ],
      "duration": "PT10M",
      "selectorid": "myResources"
    }
  ]
}
```


## Details: Service-direct faults


### Stop App Service
	
| Property  | Value |
| ---- | --- |
| Capability name | Stop-1.0 |
| Target type | Microsoft-AppService |
| Description | Stops the targeted App Service applications, then restarts them at the end of the fault duration. This action applies to resources of the "Microsoft.Web/sites" type, including App Service, API Apps, Mobile Apps, and Azure Functions. |
| Prerequisites | None. |
| Urn | urn:csci:microsoft:appService:stop/1.0 |
| Fault type | Continuous. |
| Parameters (key, value) | None. |

#### Sample JSON

```json
{
  "name": "branchOne",
  "actions": [
    {
      "type": "continuous",
      "name": "urn:csci:microsoft:appService:stop/1.0",
      "duration": "PT10M",
      "parameters":[],
      "selectorid": "myResources"
    }
  ]
}
```


### Disable Autoscale

| Property | Value |
| --- | --- |
| Capability name | DisableAutoscale |
| Target type | Microsoft-AutoscaleSettings |
| Description | Disables the [autoscale service](/azure/azure-monitor/autoscale/autoscale-overview). When autoscale is disabled, resources such as virtual machine scale sets, web apps, service bus, and [more](/azure/azure-monitor/autoscale/autoscale-overview#supported-services-for-autoscale) aren't automatically added or removed based on the load of the application. |
| Prerequisites | The autoScalesetting resource that's enabled on the resource must be onboarded to Chaos Studio. |
| Urn | urn:csci:microsoft:autoscalesettings:disableAutoscale/1.0 |
| Fault type | Continuous. |
| Parameters (key, value) |   |
| enableOnComplete | Boolean. Configures whether autoscaling is reenabled after the action is done. Default is `true`. |

#### Sample JSON
```json
{
  "name": "BranchOne", 
  "actions": [ 
    { 
    "type": "continuous", 
    "name": "urn:csci:microsoft:autoscaleSetting:disableAutoscale/1.0", 
    "parameters": [ 
     { 
      "key": "enableOnComplete", 
      "value": "true" 
      }                 
  ],                                 
   "duration": "PT2M", 
   "selectorId": "Selector1",           
  } 
 ] 
} 
```


### AKS Chaos Mesh Network Chaos

| Property | Value |
|-|-|
| Capability name | NetworkChaos-2.2 |
| Target type | Microsoft-AzureKubernetesServiceChaosMesh |
| Supported node pool OS types | Linux |
| Description | Causes a network fault available through [Chaos Mesh](https://chaos-mesh.org/docs/simulate-network-chaos-on-kubernetes/) to run against your Azure Kubernetes Service (AKS) cluster. Useful for re-creating AKS incidents that result from network outages, delays, duplications, loss, and corruption. |
| Prerequisites | The AKS cluster must [have Chaos Mesh deployed](chaos-studio-tutorial-aks-portal.md). |
| Urn | urn:csci:microsoft:azureKubernetesServiceChaosMesh:networkChaos/2.2 |
| Parameters (key, value) |  |
| jsonSpec | A JSON-formatted Chaos Mesh spec that uses the [NetworkChaos kind](https://chaos-mesh.org/docs/simulate-network-chaos-on-kubernetes/#create-experiments-using-the-yaml-files). You can use a YAML-to-JSON converter like [Convert YAML To JSON](https://www.convertjson.com/yaml-to-json.htm) to convert the Chaos Mesh YAML to JSON and minify it. Use single-quotes within the JSON or escape the quotes with a backslash character. Only include the YAML under the `jsonSpec` property. Don't include information like metadata and kind. Specifying duration within the `jsonSpec` isn't necessary, but it's used if available. |

#### Sample JSON

```json
{
  "name": "branchOne",
  "actions": [
    {
      "type": "continuous",
      "name": "urn:csci:microsoft:azureKubernetesServiceChaosMesh:networkChaos/2.2",
      "parameters": [
        {
            "key": "jsonSpec",
            "value": "{\"action\":\"delay\",\"mode\":\"one\",\"selector\":{\"namespaces\":[\"default\"]},\"delay\":{\"latency\":\"200ms\",\"correlation\":\"100\",\"jitter\":\"0ms\"}}}"
        }
    ],
      "selectorid": "myResources"
    }
  ]
}
```

### AKS Chaos Mesh Pod Chaos

| Property | Value |
|-|-|
| Capability name | PodChaos-2.2 |
| Target type | Microsoft-AzureKubernetesServiceChaosMesh |
| Supported node pool OS types | Linux |
| Description | Causes a pod fault available through [Chaos Mesh](https://chaos-mesh.org/docs/simulate-pod-chaos-on-kubernetes/) to run against your AKS cluster. Useful for re-creating AKS incidents that are a result of pod failures or container issues. |
| Prerequisites | The AKS cluster must [have Chaos Mesh deployed](chaos-studio-tutorial-aks-portal.md). |
| Urn | urn:csci:microsoft:azureKubernetesServiceChaosMesh:podChaos/2.2 |
| Parameters (key, value) |  |
| jsonSpec | A JSON-formatted Chaos Mesh spec that uses the [PodChaos kind](https://chaos-mesh.org/docs/simulate-pod-chaos-on-kubernetes/#create-experiments-using-yaml-configuration-files). You can use a YAML-to-JSON converter like [Convert YAML To JSON](https://www.convertjson.com/yaml-to-json.htm) to convert the Chaos Mesh YAML to JSON and minify it. Use single-quotes within the JSON or escape the quotes with a backslash character. Only include the YAML under the `jsonSpec` property. Don't include information like metadata and kind. Specifying duration within the `jsonSpec` isn't necessary, but it's used if available. |

#### Sample JSON

```json
{
  "name": "branchOne",
  "actions": [
    {
      "type": "continuous",
      "name": "urn:csci:microsoft:azureKubernetesServiceChaosMesh:podChaos/2.2",
      "parameters": [
        {
            "key": "jsonSpec",
            "value": "{\"action\":\"pod-failure\",\"mode\":\"all\",\"selector\":{\"namespaces\":[\"default\"]}}"
        }
    ],
      "selectorid": "myResources"
    }
  ]
}
```

### AKS Chaos Mesh Stress Chaos

| Property | Value |
|-|-|
| Capability name | StressChaos-2.2 |
| Target type | Microsoft-AzureKubernetesServiceChaosMesh |
| Supported node pool OS types | Linux |
| Description | Causes a stress fault available through [Chaos Mesh](https://chaos-mesh.org/docs/simulate-heavy-stress-on-kubernetes/) to run against your AKS cluster. Useful for re-creating AKS incidents because of stresses over a collection of pods, for example, due to high CPU or memory consumption. |
| Prerequisites | The AKS cluster must [have Chaos Mesh deployed](chaos-studio-tutorial-aks-portal.md). |
| Urn | urn:csci:microsoft:azureKubernetesServiceChaosMesh:stressChaos/2.2 |
| Parameters (key, value) |  |
| jsonSpec | A JSON-formatted Chaos Mesh spec that uses the [StressChaos kind](https://chaos-mesh.org/docs/simulate-heavy-stress-on-kubernetes/#create-experiments-using-the-yaml-file). You can use a YAML-to-JSON converter like [Convert YAML To JSON](https://www.convertjson.com/yaml-to-json.htm) to convert the Chaos Mesh YAML to JSON and minify it. Use single-quotes within the JSON or escape the quotes with a backslash character. Only include the YAML under the `jsonSpec` property. Don't include information like metadata and kind. Specifying duration within the `jsonSpec` isn't necessary, but it's used if available. |

#### Sample JSON

```json
{
  "name": "branchOne",
  "actions": [
    {
      "type": "continuous",
      "name": "urn:csci:microsoft:azureKubernetesServiceChaosMesh:stressChaos/2.2",
      "parameters": [
        {
            "key": "jsonSpec",
            "value": "{\"mode\":\"one\",\"selector\":{\"namespaces\":[\"default\"]},\"stressors\":{\"cpu\":{\"workers\":1,\"load\":50},\"memory\":{\"workers\":4,\"size\":\"256MB\"}}"
        }
    ],
      "selectorid": "myResources"
    }
  ]
}
```

### AKS Chaos Mesh IO Chaos

| Property | Value |
|-|-|
| Capability name | IOChaos-2.2 |
| Target type | Microsoft-AzureKubernetesServiceChaosMesh |
| Supported node pool OS types | Linux |
| Description | Causes an IO fault available through [Chaos Mesh](https://chaos-mesh.org/docs/simulate-io-chaos-on-kubernetes/) to run against your AKS cluster. Useful for re-creating AKS incidents because of IO delays and read/write failures when you use IO system calls such as `open`, `read`, and `write`. |
| Prerequisites | The AKS cluster must [have Chaos Mesh deployed](chaos-studio-tutorial-aks-portal.md). |
| Urn | urn:csci:microsoft:azureKubernetesServiceChaosMesh:IOChaos/2.2 |
| Parameters (key, value) |  |
| jsonSpec | A JSON-formatted Chaos Mesh spec that uses the [IOChaos kind](https://chaos-mesh.org/docs/simulate-io-chaos-on-kubernetes/#create-experiments-using-the-yaml-files). You can use a YAML-to-JSON converter like [Convert YAML To JSON](https://www.convertjson.com/yaml-to-json.htm) to convert the Chaos Mesh YAML to JSON and minify it. Use single-quotes within the JSON or escape the quotes with a backslash character. Only include the YAML under the `jsonSpec` property. Don't include information like metadata and kind. Specifying duration within the `jsonSpec` isn't necessary, but it's used if available. |

#### Sample JSON

```json
{
  "name": "branchOne",
  "actions": [
    {
      "type": "continuous",
      "name": "urn:csci:microsoft:azureKubernetesServiceChaosMesh:IOChaos/2.2",
      "parameters": [
        {
            "key": "jsonSpec",
            "value": "{\"action\":\"latency\",\"mode\":\"one\",\"selector\":{\"app\":\"etcd\"},\"volumePath\":\"\/var\/run\/etcd\",\"path\":\"\/var\/run\/etcd\/**\/*\",\"delay\":\"100ms\",\"percent\":50}"
        }
    ],
      "selectorid": "myResources"
    }
  ]
}
```

### AKS Chaos Mesh Time Chaos

| Property | Value |
|-|-|
| Capability name | TimeChaos-2.2 |
| Target type | Microsoft-AzureKubernetesServiceChaosMesh |
| Supported node pool OS types | Linux |
| Description | Causes a change in the system clock on your AKS cluster by using  [Chaos Mesh](https://chaos-mesh.org/docs/simulate-time-chaos-on-kubernetes/). Useful for re-creating AKS incidents that result from distributed systems falling out of sync, missing/incorrect leap year/leap second logic, and more. |
| Prerequisites | The AKS cluster must [have Chaos Mesh deployed](chaos-studio-tutorial-aks-portal.md). |
| Urn | urn:csci:microsoft:azureKubernetesServiceChaosMesh:timeChaos/2.2 |
| Parameters (key, value) |  |
| jsonSpec | A JSON-formatted Chaos Mesh spec that uses the [TimeChaos kind](https://chaos-mesh.org/docs/simulate-time-chaos-on-kubernetes/#create-experiments-using-the-yaml-file). You can use a YAML-to-JSON converter like [Convert YAML To JSON](https://www.convertjson.com/yaml-to-json.htm) to convert the Chaos Mesh YAML to JSON and minify it. Use single-quotes within the JSON or escape the quotes with a backslash character. Only include the YAML under the `jsonSpec` property. Don't include information like metadata and kind. Specifying duration within the `jsonSpec` isn't necessary, but it's used if available. |

#### Sample JSON

```json
{
  "name": "branchOne",
  "actions": [
    {
      "type": "continuous",
      "name": "urn:csci:microsoft:azureKubernetesServiceChaosMesh:timeChaos/2.2",
      "parameters": [
        {
            "key": "jsonSpec",
            "value": "{\"mode\":\"one\",\"selector\":{\"namespaces\":[\"default\"]},\"timeOffset\":\"-10m100ns\"}"
        }
    ],
      "selectorid": "myResources"
    }
  ]
}
```

### AKS Chaos Mesh Kernel Chaos

| Property | Value |
|-|-|
| Capability name | KernelChaos-2.2 |
| Target type | Microsoft-AzureKubernetesServiceChaosMesh |
| Supported node pool OS types | Linux |
| Description | Causes a kernel fault available through [Chaos Mesh](https://chaos-mesh.org/docs/simulate-kernel-chaos-on-kubernetes/) to run against your AKS cluster. Useful for re-creating AKS incidents because of Linux kernel-level errors, such as a mount failing or memory not being allocated. |
| Prerequisites | The AKS cluster must [have Chaos Mesh deployed](chaos-studio-tutorial-aks-portal.md). |
| Urn | urn:csci:microsoft:azureKubernetesServiceChaosMesh:kernelChaos/2.2 |
| Parameters (key, value) |  |
| jsonSpec | A JSON-formatted Chaos Mesh spec that uses the [KernelChaos kind](https://chaos-mesh.org/docs/simulate-kernel-chaos-on-kubernetes/#configuration-file). You can use a YAML-to-JSON converter like [Convert YAML To JSON](https://www.convertjson.com/yaml-to-json.htm) to convert the Chaos Mesh YAML to JSON and minify it. Use single-quotes within the JSON or escape the quotes with a backslash character. Only include the YAML under the `jsonSpec` property. Don't include information like metadata and kind. Specifying duration within the `jsonSpec` isn't necessary, but it's used if available. |

#### Sample JSON

```json
{
  "name": "branchOne",
  "actions": [
    {
      "type": "continuous",
      "name": "urn:csci:microsoft:azureKubernetesServiceChaosMesh:kernelChaos/2.2",
      "parameters": [
        {
            "key": "jsonSpec",
            "value": "{\"mode\":\"one\",\"selector\":{\"namespaces\":[\"default\"]},\"failKernRequest\":{\"callchain\":[{\"funcname\":\"__x64_sys_mount\"}],\"failtype\":0}}"
        }
    ],
      "selectorid": "myResources"
    }
  ]
}
```

### AKS Chaos Mesh HTTP Chaos

| Property | Value |
|-|-|
| Capability name | HTTPChaos-2.2 |
| Target type | Microsoft-AzureKubernetesServiceChaosMesh |
| Supported node pool OS types | Linux |
| Description | Causes an HTTP fault available through [Chaos Mesh](https://chaos-mesh.org/docs/simulate-http-chaos-on-kubernetes/) to run against your AKS cluster. Useful for re-creating incidents because of HTTP request and response processing failures, such as delayed or incorrect responses. |
| Prerequisites | The AKS cluster must [have Chaos Mesh deployed](chaos-studio-tutorial-aks-portal.md). |
| Urn | urn:csci:microsoft:azureKubernetesServiceChaosMesh:httpChaos/2.2 |
| Parameters (key, value) |  |
| jsonSpec | A JSON-formatted Chaos Mesh spec that uses the [HTTPChaos kind](https://chaos-mesh.org/docs/simulate-http-chaos-on-kubernetes/#create-experiments). You can use a YAML-to-JSON converter like [Convert YAML To JSON](https://www.convertjson.com/yaml-to-json.htm) to convert the Chaos Mesh YAML to JSON and minify it. Use single-quotes within the JSON or escape the quotes with a backslash character. Only include the YAML under the `jsonSpec` property. Don't include information like metadata and kind. Specifying duration within the `jsonSpec` isn't necessary, but it's used if available. |

#### Sample JSON

```json
{
  "name": "branchOne",
  "actions": [
    {
      "type": "continuous",
      "name": "urn:csci:microsoft:azureKubernetesServiceChaosMesh:httpChaos/2.2",
      "parameters": [
        {
            "key": "jsonSpec",
            "value": "{\"mode\":\"all\",\"selector\":{\"namespaces\":[\"default\"]},\"target\":\"Request\",\"port\":80,\"method\":\"GET\",\"path\":\"/api\",\"abort\":true}"
        }
    ],
      "selectorid": "myResources"
    }
  ]
}
```

### AKS Chaos Mesh DNS Chaos

| Property | Value |
|-|-|
| Capability name | DNSChaos-2.2 |
| Target type | Microsoft-AzureKubernetesServiceChaosMesh |
| Supported node pool OS types | Linux |
| Description | Causes a DNS fault available through [Chaos Mesh](https://chaos-mesh.org/docs/simulate-dns-chaos-on-kubernetes/) to run against your AKS cluster. Useful for re-creating incidents because of DNS failures. |
| Prerequisites | The AKS cluster must [have Chaos Mesh deployed](chaos-studio-tutorial-aks-portal.md) and the [DNS service must be installed](https://chaos-mesh.org/docs/simulate-dns-chaos-on-kubernetes/#deploy-chaos-dns-service). |
| Urn | urn:csci:microsoft:azureKubernetesServiceChaosMesh:dnsChaos/2.2 |
| Parameters (key, value) |  |
| jsonSpec | A JSON-formatted Chaos Mesh spec that uses the [DNSChaos kind](https://chaos-mesh.org/docs/simulate-dns-chaos-on-kubernetes/#create-experiments-using-the-yaml-file). You can use a YAML-to-JSON converter like [Convert YAML To JSON](https://www.convertjson.com/yaml-to-json.htm) to convert the Chaos Mesh YAML to JSON and minify it. Use single-quotes within the JSON or escape the quotes with a backslash character. Only include the YAML under the `jsonSpec` property. Don't include information like metadata and kind. Specifying duration within the `jsonSpec` isn't necessary, but it's used if available. |

#### Sample JSON

```json
{
  "name": "branchOne",
  "actions": [
    {
      "type": "continuous",
      "name": "urn:csci:microsoft:azureKubernetesServiceChaosMesh:dnsChaos/2.2",
      "parameters": [
        {
            "key": "jsonSpec",
            "value": "{\"action\":\"random\",\"mode\":\"all\",\"patterns\":[\"google.com\",\"chaos-mesh.*\",\"github.?om\"],\"selector\":{\"namespaces\":[\"default\"]}}"
        }
    ],
      "selectorid": "myResources"
    }
  ]
}
```

### Cloud Services (Classic) Shutdown

| Property | Value |
|-|-|
| Capability name | Shutdown-1.0 |
| Target type | Microsoft-DomainName |
| Description | Stops a deployment during the fault. Restarts the deployment at the end of the fault duration or if the experiment is canceled. |
| Prerequisites | None. |
| Urn | urn:csci:microsoft:domainName:shutdown/1.0 |
| Fault type | Continuous. |
| Parameters | None.  |

#### Sample JSON

```json
{
  "name": "branchOne",
  "actions": [
    {
      "type": "continuous",
      "name": "urn:csci:microsoft:domainName:shutdown/1.0",
      "parameters": [],
      "duration": "PT10M",
      "selectorid": "myResources"
    }
  ]
}
```

### Azure Cache for Redis (Reboot)

| Property | Value |
|-|-|
| Capability name | Reboot-1.0 |
| Target type | Microsoft-AzureClusteredCacheForRedis |
| Description | Causes a forced reboot operation to occur on the target to simulate a brief outage. |
| Prerequisites | N/A |
| Urn | urn:csci:microsoft:azureClusteredCacheForRedis:reboot/1.0 |
| Fault type | Discrete. |
| Parameters (key, value) |  |
| rebootType | The node types where the reboot action is to be performed, which can be specified as PrimaryNode, SecondaryNode, or AllNodes.  |
| shardId | The ID of the shard to be rebooted. Only relevant for Premium tier caches. |

#### Sample JSON

```json
{
  "name": "branchOne",
  "actions": [
    {
      "type": "discrete",
      "name": "urn:csci:microsoft:azureClusteredCacheForRedis:reboot/1.0",
      "parameters": [
        {
          "key": "RebootType",
          "value": "AllNodes"
        },
        {
          "key": "ShardId",
          "value": "0"
        }
      ],
      "selectorid": "myResources"
    }
  ]
}
```

#### Limitations

* The reboot fault causes a forced reboot to better simulate an outage event, which means there's the potential for data loss to occur.
* The reboot fault is a **discrete** fault type. Unlike continuous faults, it's a one-time action and has no duration.


### Cosmos DB Failover

| Property | Value |
|-|-|
| Capability name | Failover-1.0 |
| Target type | Microsoft-CosmosDB |
| Description | Causes an Azure Cosmos DB account with a single write region to fail over to a specified read region to simulate a [write region outage](/azure/cosmos-db/high-availability). |
| Prerequisites | None. |
| Urn | `urn:csci:microsoft:cosmosDB:failover/1.0` |
| Fault type | Continuous. |
| Parameters (key, value) |  |
| readRegion | The read region that should be promoted to write region during the failover, for example, `East US 2`. |

#### Sample JSON

```json
{
  "name": "branchOne",
  "actions": [
    {
      "type": "continuous",
      "name": "urn:csci:microsoft:cosmosDB:failover/1.0",
      "parameters": [
        {
          "key": "readRegion",
          "value": "West US 2"
        }
      ],
      "duration": "PT10M",
      "selectorid": "myResources"
    }
  ]
}
```

### Change Event Hub State
	
| Property  | Value |
| ---- | --- |
| Capability name | ChangeEventHubState-1.0 |
| Target type | Microsoft-EventHub |
| Description | Sets individual event hubs to the desired state within an Azure Event Hubs namespace. You can affect specific event hub names or use “*” to affect all within the namespace. This action can help test your messaging infrastructure for maintenance or failure scenarios. This is a discrete fault, so the entity will not be returned to the starting state automatically. |
| Prerequisites | An Azure Event Hubs namespace with at least one [event hub entity](/azure/event-hubs/event-hubs-create). |
| Urn | urn:csci:microsoft:eventHub:changeEventHubState/1.0 |
| Fault type | Discrete. |
| Parameters (key, value) | |
| desiredState | The desired state for the targeted event hubs. The possible states are Active, Disabled, and SendDisabled. |
| eventHubs | A comma-separated list of the event hub names within the targeted namespace. Use "*" to affect all entities within the namespace. |

#### Sample JSON

```json
{
  "name": "Branch1",
    "actions": [
        {
            "selectorId": "Selector1",
            "type": "discrete",
            "parameters": [
                {
                    "key": "eventhubs",
                    "value": "[\"*\"]"
                },
                {
                    "key": "desiredState",
                    "value": "Disabled"
                }
            ],
            "name": "urn:csci:microsoft:eventHub:changeEventHubState/1.0"
        }
    ]
}
```


### Key Vault: Deny Access

| Property | Value |
|-|-|
| Capability name | DenyAccess-1.0 |
| Target type | Microsoft-KeyVault |
| Description | Blocks all network access to a key vault by temporarily modifying the key vault network rules. This action prevents an application dependent on the key vault from accessing secrets, keys, and/or certificates. If the key vault allows access to all networks, this setting is changed to only allow access from selected networks. No virtual networks are in the allowed list at the start of the fault. All networks are allowed access at the end of the fault duration. If the key vault is set to only allow access from selected networks, any virtual networks in the allowed list are removed at the start of the fault. They're restored at the end of the fault duration. |
| Prerequisites | The target key vault can't have any firewall rules and must not be set to allow Azure services to bypass the firewall. If the target key vault is set to only allow access from selected networks, there must be at least one virtual network rule. The key vault can't be in recover mode. |
| Urn | urn:csci:microsoft:keyVault:denyAccess/1.0 |
| Fault type | Continuous. |
| Parameters (key, value) | None. |

#### Sample JSON

```json
{
  "name": "branchOne",
  "actions": [
    {
      "type": "continuous",
      "name": "urn:csci:microsoft:keyvault:denyAccess/1.0",
      "parameters": [],
      "duration": "PT10M",
      "selectorid": "myResources"
    }
  ]
}
```

### Key Vault: Disable Certificate

| Property  | Value |
| ---- | --- |
| Capability name | DisableCertificate-1.0 |
| Target type | Microsoft-KeyVault |
| Description | By using certificate properties, the fault disables the certificate for a specific duration (provided by the user). It enables the certificate after this fault duration. |
| Prerequisites | None. |
| Urn | urn:csci:microsoft:keyvault:disableCertificate/1.0 |
| Fault type | Continuous. |
| Parameters (key, value) | |
| certificateName | Name of Azure Key Vault certificate on which the fault is executed. |
| version | Certificate version that should be disabled. If not specified, the latest version is disabled. |

#### Sample JSON

```json
{
  "name": "branchOne",
  "actions": [
    {
      "type": "continuous",
      "name": "urn:csci:microsoft:keyvault:disableCertificate/1.0",
      "parameters": [
        {
            "key": "certificateName",
            "value": "<name of AKV certificate>"
        },
        {
            "key": "version",
            "value": "<certificate version>"
        }

],
      "duration": "PT10M",
      "selectorid": "myResources"
    }
  ]
}
```

### Key Vault: Increment Certificate Version
	
| Property  | Value |
| ---- | --- |
| Capability name | IncrementCertificateVersion-1.0 |
| Target type | Microsoft-KeyVault |
| Description | Generates a new certificate version and thumbprint by using the Key Vault Certificate client library. Current working certificate is upgraded to this version. Certificate version is not reverted after the fault duration. |
| Prerequisites | None. |
| Urn | urn:csci:microsoft:keyvault:incrementCertificateVersion/1.0 |
| Fault type | Discrete. |
| Parameters (key, value) | |
| certificateName | Name of Azure Key Vault certificate on which the fault is executed. |

#### Sample JSON

```json
{
  "name": "branchOne",
  "actions": [
    {
      "type": "discrete",
      "name": "urn:csci:microsoft:keyvault:incrementCertificateVersion/1.0",
      "parameters": [
        {
            "key": "certificateName",
            "value": "<name of AKV certificate>"
        }
    ],
      "duration": "PT10M",
      "selectorid": "myResources"
    }
  ]
}
```

### Key Vault: Update Certificate Policy

| Property  | Value |        
| ---- | --- |  
| Capability name | UpdateCertificatePolicy-1.0        |
| Target type | Microsoft-KeyVault        |
| Description | Certificate policies (for example, certificate validity period, certificate type, key size, or key type) are updated based on user input and reverted after the fault duration.        |
| Prerequisites | None. |
| Urn | urn:csci:microsoft:keyvault:updateCertificatePolicy/1.0        |
| Fault type | Continuous.        |
| Parameters (key, value) |     |    
| certificateName | Name of Azure Key Vault certificate on which the fault is executed. |
| version | Certificate version that should be updated. If not specified, the latest version is updated. |
| enabled | Boolean. Value that indicates if the new certificate version is enabled.  |
| validityInMonths | Validity period of the certificate in months.  |
| certificateTransparency | Indicates whether the certificate should be published to the certificate transparency list when created.  |
| certificateType | Certificate type. |
| contentType | Content type of the certificate. For example, it's Pkcs12 when the certificate contains raw PFX bytes or Pem when it contains ASCII PEM-encoded bytes. Pkcs12 is the default value assumed. |
| keySize | Size of the RSA key: 2048, 3072, or 4096. |
| exportable | Boolean. Value that indicates if the certificate key is exportable from the vault or secure certificate store. |
| reuseKey | Boolean. Value that indicates if the certificate key should be reused when the certificate is rotated.|
| keyType | Type of backing key generated when new certificates are issued, such as RSA or EC. |

#### Sample JSON

```json
{
  "name": "branchOne",
  "actions": [
    {
      "type": "continuous",
      "name": "urn:csci:microsoft:keyvault:updateCertificatePolicy/1.0",
      "parameters": [
        {
            "key": "certificateName",
            "value": "<name of AKV certificate>"
        },
        {
            "key": "version",
            "value": "<certificate version>"
        },
        {
            "key": "enabled",
            "value": "True"
        },
        {
            "key": "validityInMonths",
            "value": "12"
        },
        {
            "key": "certificateTransparency",
            "value": "True"
        },
        {
            "key": "certificateType",
            "value": "<certificate type>"
        },
        {
            "key": "contentType",
            "value": "Pem"
        },
        {
            "key": "keySize",
            "value": "4096"
        },
                {
            "key": "exportable",
            "value": "True"
        },
        {
            "key": "reuseKey",
            "value": "False"
        },
        {
            "key": "keyType",
            "value": "RSA"
        }

     ],
      "duration": "PT10M",
      "selectorid": "myResources"
    }
  ]
}
```


### NSG Security Rule

| Property | Value |
|-|-|
| Capability name | SecurityRule-1.0, SecurityRule-1.1 |
| Target type | Microsoft-NetworkSecurityGroup |
| Description | Enables manipulation or rule creation in an existing Azure network security group (NSG) or set of Azure NSGs, assuming the rule definition is applicable across security groups. Useful for: <ul><li>Simulating an outage of a downstream or cross-region dependency/nondependency.<li>Simulating an event that's expected to trigger a logic to force a service failover.<li>Simulating an event that's expected to trigger an action from a monitoring or state management service.<li>Using as an alternative for blocking or allowing network traffic where Chaos Agent can't be deployed. |
| Prerequisites | None. |
| Urn | urn:csci:microsoft:networkSecurityGroup:securityRule/1.0, urn:csci:microsoft:networkSecurityGroup:securityRule/1.1 |
| Fault type | Continuous. |
| Parameters (key, value) |  |
| name | A unique name for the security rule that's created. The fault fails if another rule already exists on the NSG with the same name. Must begin with a letter or number. Must end with a letter, number, or underscore. May contain only letters, numbers, underscores, periods, or hyphens. |
| protocol | Protocol for the security rule. Must be Any, TCP, UDP, or ICMP. |
| sourceAddresses | A string that represents a JSON-delimited array of CIDR-formatted IP addresses. Can also be a [service tag name](/azure/virtual-network/service-tags-overview) for an inbound rule, for example, `AppService`. An asterisk `*` can also be used to match all source IPs. |
| destinationAddresses | A string that represents a JSON-delimited array of CIDR-formatted IP addresses. Can also be a [service tag name](/azure/virtual-network/service-tags-overview) for an outbound rule, for example, `AppService`. An asterisk `*` can also be used to match all destination IPs. |
| action | Security group access type. Must be either Allow or Deny. |
| destinationPortRanges | A string that represents a JSON-delimited array of single ports and/or port ranges, such as 80 or 1024-65535. |
| sourcePortRanges | A string that represents a JSON-delimited array of single ports and/or port ranges, such as 80 or 1024-65535. |
| priority | A value between 100 and 4096 that's unique for all security rules within the NSG. The fault fails if another rule already exists on the NSG with the same priority. |
| direction | Direction of the traffic affected by the security rule. Must be either Inbound or Outbound. |

#### Sample JSON

```json
{ 
  "name": "branchOne", 
  "actions": [ 
    { 
      "type": "continuous", 
      "name": "urn:csci:microsoft:networkSecurityGroup:securityRule/1.0", 
      "parameters": [ 
          { 
              "key": "name", 
              "value": "Block_SingleHost_to_Networks" 

          }, 
          { 
              "key": "protocol", 
              "value": "Any" 
          }, 
          { 
              "key": "sourceAddresses", 
              "value": "[\"10.1.1.128/32\"]"
          }, 
          { 
              "key": "destinationAddresses", 
              "value": "[\"10.20.0.0/16\",\"10.30.0.0/16\"]"
          }, 
          { 
              "key": "access", 
              "value": "Deny" 
          }, 
          { 
              "key": "destinationPortRanges", 
              "value": "[\"80-8080\"]"
          }, 
          { 
              "key": "sourcePortRanges", 
              "value": "[\"*\"]"
          }, 
          { 
              "key": "priority", 
              "value": "100" 
          }, 
          { 
              "key": "direction", 
              "value": "Outbound" 
          } 
      ], 
      "duration": "PT10M", 
      "selectorid": "myResources" 
    } 
  ] 
} 
```

#### Limitations

* The fault can only be applied to an existing NSG.
* When an NSG rule that's intended to deny traffic is applied, existing connections won't be broken until they've been **idle** for 4 minutes. One workaround is to add another branch in the same step that uses a fault that would cause existing connections to break when the NSG fault is applied. For example, killing the process, temporarily stopping the service, or restarting the VM would cause connections to reset.
* Rules are applied at the start of the action. Any external changes to the rule during the duration of the action cause the experiment to fail.
* Creating or modifying Application Security Group rules isn't supported.
* Priority values must be unique on each NSG targeted. Attempting to create a new rule that has the same priority value as another causes the experiment to fail.
* The NSG Security Rule **version 1.1** fault supports an additional `flushConnection` parameter. This functionality has an **active known issue**: if `flushConnection` is enabled, the fault may result in a "FlushingNetworkSecurityGroupConnectionIsNotEnabled" error. To avoid this error temporarily, disable the `flushConnection` parameter or use the NSG Security Rule version **1.0** fault.


### Service Bus: Change Queue State
	
| Property  | Value |
| ---- | --- |
| Capability name | ChangeQueueState-1.0 |
| Target type | Microsoft-ServiceBus |
| Description | Sets Queue entities within a Service Bus namespace to the desired state. You can affect specific entity names or use “*” to affect all. This action can help test your messaging infrastructure for maintenance or failure scenarios. This is a discrete fault, so the entity will not be returned to the starting state automatically. |
| Prerequisites | A Service Bus namespace with at least one [Queue entity](/azure/service-bus-messaging/service-bus-quickstart-portal). |
| Urn | urn:csci:microsoft:serviceBus:changeQueueState/1.0 |
| Fault type | Discrete. |
| Parameters (key, value) | |
| desiredState | The desired state for the targeted queues. The possible states are Active, Disabled, SendDisabled, and ReceiveDisabled. |
| queues | A comma-separated list of the queue names within the targeted namespace. Use "*" to affect all queues within the namespace. |

#### Sample JSON

```json
{
  "name": "branchOne",
  "actions": [
    {
      "type": "discrete",
      "name": "urn:csci:microsoft:serviceBus:changeQueueState/1.0",
      "parameters":[
          {
            "key": "desiredState",
            "value": "Disabled"
          },
          {
            "key": "queues",
            "value": "samplequeue1,samplequeue2"
          }
      ],
      "selectorid": "myServiceBusSelector"
    }
  ]
}
```

#### Limitations

* A maximum of 1000 queue entities can be passed to this fault.

### Service Bus: Change Subscription State
	
| Property  | Value |
| ---- | --- |
| Capability name | ChangeSubscriptionState-1.0 |
| Target type | Microsoft-ServiceBus |
| Description | Sets Subscription entities within a Service Bus namespace and Topic to the desired state. You can affect specific entity names or use “*” to affect all. This action can help test your messaging infrastructure for maintenance or failure scenarios. This is a discrete fault, so the entity will not be returned to the starting state automatically. |
| Prerequisites | A Service Bus namespace with at least one [Subscription entity](/azure/service-bus-messaging/service-bus-quickstart-topics-subscriptions-portal). |
| Urn | urn:csci:microsoft:serviceBus:changeSubscriptionState/1.0 |
| Fault type | Discrete. |
| Parameters (key, value) | |
| desiredState | The desired state for the targeted subscriptions. The possible states are Active and Disabled. |
| topic | The parent topic containing one or more subscriptions to affect. |
| subscriptions | A comma-separated list of the subscription names within the targeted namespace. Use "*" to affect all subscriptions within the namespace. |

#### Sample JSON

```json
{
  "name": "branchOne",
  "actions": [
    {
      "type": "discrete",
      "name": "urn:csci:microsoft:serviceBus:changeSubscriptionState/1.0",
      "parameters":[
          {
            "key": "desiredState",
            "value": "Disabled"
          },
          {
            "key": "topic",
            "value": "topic01"
          },
          {
            "key": "subscriptions",
            "value": "*"
          }
      ],
      "selectorid": "myServiceBusSelector"
    }
  ]
}
```

#### Limitations

* A maximum of 1000 subscription entities can be passed to this fault.

### Service Bus: Change Topic State
	
| Property  | Value |
| ---- | --- |
| Capability name | ChangeTopicState-1.0 |
| Target type | Microsoft-ServiceBus |
| Description | Sets the specified Topic entities within a Service Bus namespace to the desired state. You can affect specific entity names or use “*” to affect all. This action can help test your messaging infrastructure for maintenance or failure scenarios. This is a discrete fault, so the entity will not be returned to the starting state automatically. |
| Prerequisites | A Service Bus namespace with at least one [Topic entity](/azure/service-bus-messaging/service-bus-quickstart-topics-subscriptions-portal). |
| Urn | urn:csci:microsoft:serviceBus:changeTopicState/1.0 |
| Fault type | Discrete. |
| Parameters (key, value) | |
| desiredState | The desired state for the targeted topics. The possible states are Active and Disabled. |
| topics | A comma-separated list of the topic names within the targeted namespace. Use "*" to affect all topics within the namespace. |

#### Sample JSON

```json
{
  "name": "branchOne",
  "actions": [
    {
      "type": "discrete",
      "name": "urn:csci:microsoft:serviceBus:changeTopicState/1.0",
      "parameters":[
          {
            "key": "desiredState",
            "value": "Disabled"
          },
          {
            "key": "topics",
            "value": "*"
          }
      ],
      "selectorid": "myServiceBusSelector"
    }
  ]
}
```

#### Limitations

* A maximum of 1000 topic entities can be passed to this fault.

### VM Redeploy
	
| Property  | Value |
| ---- | --- |
| Capability name | Redeploy-1.0 |
| Target type | Microsoft-VirtualMachine |
| Description | Redeploys a VM by shutting it down, moving it to a new node in the Azure infrastructure, and powering it back on. This helps validate your workload's resilience to maintenance events. |
| Prerequisites | None. |
| Urn | urn:csci:microsoft:virtualMachine:redeploy/1.0 |
| Fault type | Discrete. |
| Parameters (key, value) | None. |

#### Sample JSON

```json
{
  "name": "branchOne",
  "actions": [
    {
      "type": "discrete",
      "name": "urn:csci:microsoft:virtualMachine:redeploy/1.0",
      "parameters":[],
      "selectorid": "myResources"
    }
  ]
}
```

#### Limitations

* The Virtual Machine Redeploy operation is throttled within an interval of 10 hours. If your experiment fails with a "Too many redeploy requests" error, wait for 10 hours to retry the experiment.


### Virtual Machine Shutdown

| Property | Value |
|-|-|
| Capability name | Shutdown-1.0 |
| Target type | Microsoft-VirtualMachine |
| Supported OS types | Windows, Linux. |
| Description | Shuts down a VM for the duration of the fault. Restarts it at the end of the experiment or if the experiment is canceled. Only Azure Resource Manager VMs are supported. |
| Prerequisites | None. |
| Urn | urn:csci:microsoft:virtualMachine:shutdown/1.0 |
| Fault type | Continuous. |
| Parameters (key, value) |  |
| abruptShutdown | (Optional) Boolean that indicates if the VM should be shut down gracefully or abruptly (destructive). |

#### Sample JSON

```json
{
  "name": "branchOne",
  "actions": [
    {
      "type": "continuous",
      "name": "urn:csci:microsoft:virtualMachine:shutdown/1.0",
      "parameters": [
        {
          "key": "abruptShutdown",
          "value": "false"
        }
      ],
      "duration": "PT10M",
      "selectorid": "myResources"
    }
  ]
}
```


### Virtual Machine Scale Set Shutdown

This fault has two available versions that you can use, Version 1.0 and Version 2.0. The main difference is that Version 2.0 allows you to filter by availability zones, only shutting down instances within a specified zone or zones.

#### Virtual Machine Scale Set Shutdown Version 1.0

| Property | Value |
|-|-|
| Capability name | Version 1.0 |
| Target type | Microsoft-VirtualMachineScaleSet |
| Supported OS types | Windows, Linux. |
| Description | Shuts down or kills a virtual machine scale set instance during the fault and restarts the VM at the end of the fault duration or if the experiment is canceled. |
| Prerequisites | None. |
| Urn | urn:csci:microsoft:virtualMachineScaleSet:shutdown/1.0 |
| Fault type | Continuous. |
| Parameters (key, value) |  |
| abruptShutdown | (Optional) Boolean that indicates if the virtual machine scale set instance should be shut down gracefully or abruptly (destructive). |
| instances | A string that's a delimited array of virtual machine scale set instance IDs to which the fault is applied. |

##### Version 1.0 sample JSON

```json
{
  "name": "branchOne",
  "actions": [
    {
      "type": "continuous",
      "name": "urn:csci:microsoft:virtualMachineScaleSet:shutdown/1.0",
      "parameters": [
        {
          "key": "abruptShutdown",
          "value": "true"
        },
        {
          "key": "instances",
          "value": "[\"1\",\"3\"]"
        }
      ],
      "duration": "PT10M",
      "selectorid": "myResources"
    }
  ]
}
```

#### Virtual Machine Scale Set Shutdown Version 2.0

| Property | Value |
|-|-|
| Capability name | Shutdown-2.0 |
| Target type | Microsoft-VirtualMachineScaleSet |
| Supported OS types | Windows, Linux. |
| Description | Shuts down or kills a virtual machine scale set instance during the fault. Restarts the VM at the end of the fault duration or if the experiment is canceled. Supports [dynamic targeting](chaos-studio-tutorial-dynamic-target-cli.md). |
| Prerequisites | None. |
| Urn | urn:csci:microsoft:virtualMachineScaleSet:shutdown/2.0 |
| Fault type | Continuous. |
| [filter](/azure/templates/microsoft.chaos/experiments?pivots=deployment-language-arm-template#filter-objects-1) | (Optional) Available starting with Version 2.0. Used to filter the list of targets in a selector. Currently supports filtering on a list of zones. The filter is only applied to virtual machine scale set resources within a zone:<ul><li>If no filter is specified, this fault shuts down all instances in the virtual machine scale set.</li><li>The experiment targets all virtual machine scale set instances in the specified zones.</li><li>If a filter results in no targets, the experiment fails.</li></ul> |
| Parameters (key, value) |  |
| abruptShutdown | (Optional) Boolean that indicates if the virtual machine scale set instance should be shut down gracefully or abruptly (destructive). |

##### Version 2.0 sample JSON snippets

The following snippets show how to configure both [dynamic filtering](chaos-studio-tutorial-dynamic-target-cli.md) and the shutdown 2.0 fault.

Configure a filter for dynamic targeting:

```json
{
  "type": "List",
  "id": "myResources",
  "targets": [
    {
      "id": "<targetResourceId>",
      "type": "ChaosTarget"
    }
  ],
  "filter": {
    "type": "Simple",
    "parameters": {
      "zones": [
        "1"
      ]
    }
  }
}
```

Configure the shutdown fault:

```json
{
  "name": "branchOne",
  "actions": [
    {
      "name": "urn:csci:microsoft:virtualMachineScaleSet:shutdown/2.0",
      "type": "continuous",
      "selectorId": "myResources",
      "duration": "PT10M",
      "parameters": [
        {
          "key": "abruptShutdown",
          "value": "false"
        }
      ]
    }
  ]
}
```

#### Limitations
Currently, only virtual machine scale sets configured with the **Uniform** orchestration mode are supported. If your virtual machine scale set uses **Flexible** orchestration, you can use the Azure Resource Manager virtual machine shutdown fault to shut down selected instances.




## Details: Orchestration actions

### Delay

| Property | Value |
|-|-|
| Fault provider | N/A |
| Supported OS types | N/A |
| Description | Adds a time delay before, between, or after other experiment actions. This action isn't a fault and is used to synchronize actions within an experiment. Use this action to wait for the impact of a fault to appear in a service, or wait for an activity outside of the experiment to complete. For example, your experiment could wait for autohealing to occur before injecting another fault. |
| Prerequisites | N/A |
| Urn | urn:csci:microsoft:chaosStudio:timedDelay/1.0 |
| Duration | The duration of the delay in ISO 8601 format (for example, PT10M). |

#### Sample JSON

```json
{
  "name": "branchOne",
  "actions": [ 
    {
      "type": "delay",
      "name": "urn:csci:microsoft:chaosStudio:timedDelay/1.0",
      "duration": "PT10M"
    }
  ] 
}
```

### Start Load Test (Azure Load Testing)
	
| Property  | Value |
| ---- | --- |
| Capability name | Start-1.0 |
| Target type | Microsoft-AzureLoadTest |
| Description | Starts a load test (from Azure Load Testing) based on the provided load test ID. |
| Prerequisites | A load test with a valid load test ID must be created in the [Azure Load Testing service](/azure/load-testing/quickstart-create-and-run-load-test). |
| Urn | urn:csci:microsoft:azureLoadTest:start/1.0 |
| Fault type | Discrete. |
| Parameters (key, value) |     |    
| testID | The ID of a specific load test created in the Azure Load Testing service. |

#### Sample JSON

```json
{
  "name": "branchOne",
  "actions": [
    {
      "type": "discrete",
      "name": "urn:csci:microsoft:azureLoadTest:start/1.0",
      "parameters": [
        {
            "key": "testID",
            "value": "0"
        }
    ],
      "selectorid": "myResources"
    }
  ]
}
```

### Stop Load Test (Azure Load Testing)
	
| Property  | Value |
| ---- | --- |
| Capability name | Stop-1.0 |
| Target type | Microsoft-AzureLoadTest |
| Description | Stops a load test (from Azure Load Testing) based on the provided load test ID. |
| Prerequisites | A load test with a valid load test ID must be created in the [Azure Load Testing service](/azure/load-testing/quickstart-create-and-run-load-test). |
| Urn | urn:csci:microsoft:azureLoadTest:stop/1.0 |
| Fault type | Discrete. |
| Parameters (key, value) |     |    
| testID | The ID of a specific load test created in the Azure Load Testing service. |

#### Sample JSON

```json
{
  "name": "branchOne",
  "actions": [
    {
      "type": "discrete",
      "name": "urn:csci:microsoft:azureLoadTest:stop/1.0",
      "parameters": [
        {
            "key": "testID",
            "value": "0"
        }
    ],
      "selectorid": "myResources"
    }
  ]
}
```
