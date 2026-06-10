---
title: Scenarios in Azure Chaos Studio
description: Reference for all available Scenarios in Azure Chaos Studio Workspaces. Each Scenario simulates a real outage pattern using composed Actions.
author: nikhilkaul-msft
ms.topic: reference
ms.date: 06/10/2026
ai-usage: ai-assisted
---

# Scenarios in Azure Chaos Studio

A Scenario is a preconfigured resilience test that simulates a specific outage pattern. Each Scenario composes one or more Actions into a sequence that mirrors how real failures cascade across Azure resources. When you create a [Workspace](chaos-studio-workspaces-overview.md), Chaos Studio discovers your resources and shows you which Scenarios apply to them.

This page lists the Scenarios currently available in Azure Chaos Studio Workspaces. The catalog grows over time — as new Actions ship and new outage patterns are validated, additional Scenarios appear in your Workspace automatically.

## Zone and networking Scenarios

These Scenarios simulate failures in network connectivity and availability zone infrastructure — the most common categories of cloud outages.

### DNS Outage

Blocks DNS resolution by applying a network security group (NSG) rule that denies outbound traffic on port 53. Tests whether your application handles DNS failures gracefully, including fallback behavior, retry logic, and cached resolution.

| Property | Value |
|---|---|
| Actions | NSG ApplyNSGRule (block port 53) |
| Target resources | Network Security Group, Virtual Network |
| Outage category | Networking |

### Entra ID Outage

Blocks connectivity to Microsoft Entra ID endpoints by applying an NSG rule that denies outbound traffic to Entra ID service tags. Tests whether your application can tolerate an identity provider outage — authentication failures, token refresh failures, and downstream authorization cascades.

| Property | Value |
|---|---|
| Actions | NSG ApplyNSGRule (block Entra ID endpoints) |
| Target resources | Network Security Group, Virtual Network |
| Outage category | Networking / Identity |

### Compute Zone Down

Simulates a full availability zone failure by shutting down virtual machines and virtual machine scale set (VMSS) instances in a target zone and killing App Service processes. Availability zone failures are among the most impactful cloud incidents, making this Scenario a high-priority starting point for resilience testing.

| Property | Value |
|---|---|
| Actions | VM Shutdown (zone filter), VMSS Shutdown (zone filter), App Service Kill Process |
| Target resources | Virtual Machines, VMSS, App Service |
| Outage category | Zone / Datacenter |

### Dependency Blackout

Simultaneously blocks access to multiple upstream services — Key Vault, Service Bus, and Event Hubs — to test how your application handles cascading dependency failures.

| Property | Value |
|---|---|
| Actions | NSG ApplyNSGRule (block Key Vault endpoints), Service Bus ChangeQueueState (disable), Event Hubs ChangeEventHubState (disable) |
| Target resources | Key Vault, Service Bus Namespace, Event Hubs Namespace |
| Outage category | Messaging / Security |

## Database failover Scenarios

These Scenarios combine zone-level compute failures with database failovers to test whether your application recovers within its recovery time objective (RTO).

### Compute Zone Down + Database Failover

Extends the Compute Zone Down Scenario by adding a database failover. Tests your application's ability to handle simultaneous compute and data tier failures — connection retry, pool exhaustion, and data consistency after failover. This Scenario works across Azure SQL Database, PostgreSQL Flexible Server, and MySQL Flexible Server, depending on which database resources are in your Workspace scope.

| Property | Value |
|---|---|
| Actions | VM Shutdown (zone filter), VMSS Shutdown (zone filter), Database Failover (SQL DB, PostgreSQL Flexible, or MySQL Flexible) |
| Target resources | Virtual Machines, VMSS, SQL Database / PostgreSQL Flexible Server / MySQL Flexible Server |
| Outage category | Zone / Datacenter + Data |

## Messaging and event-driven Scenarios

### Event-Driven Messaging Disruption

Disables Service Bus queues and Event Hubs entities to test how your event-driven microservices architecture handles messaging infrastructure failures. Validates dead-letter handling, retry policies, and backpressure mechanisms.

| Property | Value |
|---|---|
| Actions | Service Bus ChangeQueueState (disable), Event Hubs ChangeEventHubState (disable) |
| Target resources | Service Bus Namespace, Event Hubs Namespace |
| Outage category | Messaging |

## Nominal operations Scenarios (coming soon)

Nominal Scenarios simulate routine operational events — the kind of disruptions your infrastructure should handle automatically without impacting users.

### VM Maintenance Reboot

Simulates a planned platform maintenance reboot to validate that your application handles VM restarts without service interruption.

| Property | Value |
|---|---|
| Actions | VM Reboot |
| Target resources | Virtual Machines |
| Outage category | Nominal / Operational |

### VMSS Instance Cycling

Simulates a scale-in event by shutting down a subset of VMSS instances. Tests whether your application's autoscaling and health probes correctly detect and replace lost instances.

| Property | Value |
|---|---|
| Actions | VMSS Shutdown (partial) |
| Target resources | VMSS |
| Outage category | Nominal / Operational |

## What determines which Scenarios appear in your Workspace

Chaos Studio matches Scenarios to resources based on the Workspace scope. A Scenario appears in your library if your scope contains the resource types that the Scenario's Actions affect. For Scenarios that compose multiple Actions across resource types (for example, the Compute Zone Down + Database Failover Scenario), all required resource types must be present in the scope.

If you deploy new resources within the Workspace scope, they're discovered automatically and new Scenarios may appear in your library.

## Resource exclusions

When you configure a Scenario, you can exclude specific resources from the run. Resource exclusions let you protect critical resources — such as a production database or a shared jumpbox — while still running the Scenario against everything else in scope. Exclusions are set per Scenario, so you can fine-tune each test without changing the Workspace scope itself.

## Next steps

- [Quickstart: Create a Workspace and run your first Scenario](quickstart-create-workspace.md)
- [Scenario reports in Azure Chaos Studio](chaos-studio-scenario-reports.md)
- [Fault and action library](chaos-studio-fault-library.md)
