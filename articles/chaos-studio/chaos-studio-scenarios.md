---
title: Scenarios in Azure Chaos Studio
description: Reference for all available Scenarios in Azure Chaos Studio Workspaces. Each Scenario simulates a real outage pattern using composed Actions.
author: nikhilkaul-msft
ms.topic: reference
ms.date: 06/17/2026
ai-usage: ai-assisted
---

# Scenarios in Azure Chaos Studio

A Scenario is a preconfigured resilience test that simulates a specific outage pattern. Each Scenario composes one or more Actions into a sequence that mirrors how real failures cascade across Azure resources. When you create a [Workspace](chaos-studio-workspaces-overview.md), Chaos Studio discovers your resources and shows you which Scenarios apply to them.

This page lists the Scenarios available in Azure Chaos Studio Workspaces. Chaos Studio ships a set of supported Scenario templates that cover the most common outage patterns. You can run these templates as-is, or use the [Scenario designer](#create-a-custom-scenario) to customize your own.

> [!NOTE]
> Azure Chaos Studio Workspaces and Scenarios are in public preview.

## Supported Scenario templates

The following Scenarios are available in the public preview. Each one is a supported template that you can run without any custom configuration beyond the parameters it requires.

### Zone and networking Scenarios

These Scenarios simulate failures in network connectivity and availability zone infrastructure, the most common categories of cloud outages.

#### DNS Outage

Blocks DNS resolution by applying a network security group (NSG) rule that denies outbound traffic on port 53. Tests whether your application handles DNS failures gracefully, including fallback behavior, retry logic, and cached resolution.

| Property | Value |
|---|---|
| Actions | NSG ApplyNSGRule (block port 53) |
| Target resources | Network Security Group, Virtual Network |
| Outage category | Networking |

#### Microsoft Entra ID Outage

Blocks connectivity to Microsoft Entra ID endpoints by applying an NSG rule that denies outbound traffic to Microsoft Entra ID service tags. Tests whether your application can tolerate an identity provider outage, including authentication failures, token refresh failures, and downstream authorization cascades.

| Property | Value |
|---|---|
| Actions | NSG ApplyNSGRule (block Entra ID endpoints) |
| Target resources | Network Security Group, Virtual Network |
| Outage category | Networking / Identity |

#### Compute Zone Down

Simulates a full availability zone failure by shutting down virtual machines and Azure Virtual Machine Scale Sets instances in a target zone. Availability zone failures are among the most impactful cloud incidents, making this Scenario a high-priority starting point for resilience testing.

| Property | Value |
|---|---|
| Actions | VM Shutdown (zone filter), Virtual Machine Scale Set Shutdown (zone filter) |
| Target resources | Virtual Machines, Virtual Machine Scale Sets |
| Outage category | Zone / Datacenter |

### Database failover Scenarios

In Azure Chaos Studio, database failover is delivered as part of the Compute Zone Down Scenarios rather than as standalone failover Scenarios. These variants combine a zone-level compute failure with a database failover to test whether your application recovers within its recovery time objective (RTO), including connection retry, pool exhaustion, and data consistency after failover.

#### Compute Zone Down + PostgreSQL Failover

Extends the Compute Zone Down Scenario with an Azure Database for PostgreSQL flexible server failover.

| Property | Value |
|---|---|
| Actions | VM Shutdown (zone filter), Virtual Machine Scale Set Shutdown (zone filter), PostgreSQL Flexible Server Failover |
| Target resources | Virtual Machines, Virtual Machine Scale Sets, Azure Database for PostgreSQL flexible server |
| Outage category | Zone / Datacenter + Data |

#### Compute Zone Down + SQL Managed Instance Failover

Extends the Compute Zone Down Scenario with an Azure SQL Managed Instance failover.

| Property | Value |
|---|---|
| Actions | VM Shutdown (zone filter), Virtual Machine Scale Set Shutdown (zone filter), SQL Managed Instance Failover |
| Target resources | Virtual Machines, Virtual Machine Scale Sets, Azure SQL Managed Instance |
| Outage category | Zone / Datacenter + Data |

### Cache resilience Scenarios

These Scenarios test how your application handles cache failures, including the cache stampede pattern, where many clients simultaneously try to rebuild an expired or lost cache entry.

#### Cache Stampede

Simulates a cache stampede by flushing the Azure Managed Redis cache and restarting the database and App Service instances at the same time, so concurrent clients fall back to the origin data store together. Tests whether your application's request coalescing, backoff, and load-shedding logic prevent the origin from being overwhelmed.

| Property | Value |
|---|---|
| Actions | Azure Managed Redis FlushDatabase, MySQL Flexible Server Restart, App Service Restart |
| Target resources | Azure Managed Redis, Azure Database for MySQL flexible server, App Service |
| Outage category | Cache / Load |

#### Cache Stampede with Process Crash

Combines a cache stampede with an App Service process crash to test recovery when the cache layer and a compute instance fail together. This variant kills the App Service process instead of restarting it.

> [!NOTE]
> This Scenario is supported for Windows App Service only. Linux App Service isn't supported.

| Property | Value |
|---|---|
| Actions | Azure Managed Redis FlushDatabase, MySQL Flexible Server Restart, App Service Kill Process |
| Target resources | Azure Managed Redis, Azure Database for MySQL flexible server, App Service (Windows) |
| Outage category | Cache / Load |

### Messaging and event-driven Scenarios

#### Event-Driven Messaging Disruption

Disables Service Bus queues and Event Hubs entities to test how your event-driven microservices architecture handles messaging infrastructure failures. Validates dead-letter handling, retry policies, and backpressure mechanisms.

| Property | Value |
|---|---|
| Actions | Service Bus ChangeQueueState (disable), Event Hubs ChangeEventHubState (disable) |
| Target resources | Service Bus Namespace, Event Hubs Namespace |
| Outage category | Messaging |

When the run ends, Chaos Studio re-enables the affected Service Bus queues and Event Hubs entities automatically.

## Create a custom Scenario

When the supported templates don't match what you need, customize your own Scenario with the Chaos Studio **Scenario designer** in the Azure portal. You start from a template, adjust its Actions and parameters, and save named configurations that you can run or edit later. To author a Scenario programmatically instead, define it as a `Microsoft.Chaos/workspaces/scenarios` resource (see [How a custom Scenario is structured](#how-a-custom-scenario-is-structured)).

### Use the Scenario designer in the portal

1. In your Workspace, select **Designer** in the left navigation.

1. Search for or browse the template that's closest to the outage pattern you want, then select **Use Template**. Templates are grouped by category, such as Compute and Database.

   :::image type="content" source="images/scenario-designer-templates.png" alt-text="Screenshot of the Scenario designer showing template categories and the Compute Zone Down template with a Use Template button.":::

1. The designer opens the template on a canvas that shows its Actions and how they run. For example, the Compute Zone Down template runs two Actions in parallel: `vmssZoneShutdown` and `vmZoneShutdown`, each for 15 minutes.

   :::image type="content" source="images/scenario-designer-compute-zone-down.png" alt-text="Screenshot of the Scenario designer canvas showing the Compute Zone Down template with two parallel shutdown Actions and the Configure scenario pane.":::

1. In the **Configure scenario** pane, set the **Scenario name**, give the configuration a **Name**, and set the **Configuration Parameters** (such as the duration and the zones to target). A Scenario can hold multiple named configurations.

   :::image type="content" source="images/scenario-designer-configured.png" alt-text="Screenshot of the Scenario designer with a scenario name and configuration name filled in and configuration parameters set.":::

1. Select **Create** to save the Scenario. Saved Scenarios appear under **My scenarios**, where you can run them or edit their configurations.

### How a custom Scenario is structured

A Scenario is a `Microsoft.Chaos/workspaces/scenarios` resource. Each Scenario has:

- **Actions**: One or more Actions that define the Scenario's orchestration. Each Action references an action type by ID and version (for example, `microsoft-compute-shutdown/1.0`), runs for an ISO 8601 **duration** (such as `PT30M` for 30 minutes), and takes action-specific **parameters**.
- **Parameters**: Scenario-level parameters that callers supply at run time, such as which availability zone to target. Each parameter has a name, a type (`string`, `number`, `boolean`, `array`, or `object`), an optional default, and a `required` flag. Reference a parameter inside an Action with the macro syntax `%%{parameters.<name>}%%`.
- **Dependencies**: Use an Action's `runAfter` property to control sequencing. You specify the Actions to wait for, the lifecycle state that triggers the next Action (`Start`, `Running`, `Success`, `Failure`, `Skipped`, or `AnyTerminal`), and how multiple dependencies are evaluated (`All`, `Any`, or `AtLeastOne`). You can also set `waitBefore` to delay an Action and `timeout` to cap its execution time.

This model lets you reproduce cascading failures. For example, shut down a zone, wait for it to take effect, and then trigger a database failover only after the compute disruption is running.

### Example: custom Scenario in Bicep

The following Bicep defines a Scenario that shuts down virtual machines in a parameterized availability zone, then fails over a PostgreSQL Flexible Server after the shutdown is running:

```bicep
resource customScenario 'Microsoft.Chaos/workspaces/scenarios@2026-05-01-preview' = {
  parent: workspace
  name: 'zone-down-then-db-failover'
  properties: {
    description: 'Shut down a zone, then fail over the database.'
    parameters: [
      {
        name: 'zone'
        type: 'string'
        required: true
        description: 'Availability zone to take down.'
      }
    ]
    actions: [
      {
        name: 'shutdown-zone'
        actionId: 'microsoft-compute-shutdown/1.0'
        description: 'Shut down VMs in the target zone.'
        duration: 'PT10M'
        parameters: [
          {
            key: 'zones'
            value: '%%{parameters.zone}%%'
          }
        ]
      }
      {
        name: 'db-failover'
        actionId: 'microsoft-azurePostgreSql-failover/1.0'
        description: 'Fail over the PostgreSQL flexible server.'
        duration: 'PT5M'
        runAfter: {
          behavior: 'All'
          items: [
            {
              type: 'Action'
              name: 'shutdown-zone'
              onActionLifecycle: 'Running'
            }
          ]
        }
      }
    ]
  }
}
```

Action IDs follow the format `{publisher}-{service}-{action}/{version}`. For the full resource schema, including every Action and parameter property, see the [Microsoft.Chaos/workspaces/scenarios template reference](/azure/templates/microsoft.chaos/workspaces/scenarios). For the list of Actions you can compose, see the [Fault and action library](chaos-studio-fault-library.md).

## What determines which Scenarios appear in your Workspace

Chaos Studio matches Scenarios to resources based on the Workspace scope. A Scenario appears in your library if your scope contains the resource types that the Scenario's Actions affect. For Scenarios that compose multiple Actions across resource types (for example, the Compute Zone Down + PostgreSQL Failover Scenario), all required resource types must be present in the scope.

If you deploy new resources within the Workspace scope, they're discovered automatically, and new Scenarios might appear in your library.

## Resource exclusions

When you configure a Scenario, you can exclude specific resources from the run. Resource exclusions let you protect critical resources (such as a production database or a shared jumpbox) while still running the Scenario against everything else in scope. Exclusions are set per Scenario, so you can fine-tune each test without changing the Workspace scope itself.

## Next steps

- [Quickstart: Create a Workspace and run your first Scenario](quickstart-create-workspace.md)
- [Scenario reports in Azure Chaos Studio](chaos-studio-scenario-reports.md)
- [Fault and action library](chaos-studio-fault-library.md)
