---
title: Move from Experiments (classic) to Chaos Studio Workspaces
description: Learn how to move Azure Chaos Studio Experiments (classic) to Chaos Studio Workspaces, map experiments to Scenarios, and clean up classic resources.
author: nikhilkaul-msft
ms.topic: how-to
ms.date: 09/25/2026
ai-usage: ai-assisted
---

# Move from Experiments (classic) to Chaos Studio Workspaces

Experiments (classic) is being replaced by [Chaos Studio Workspaces](chaos-studio-workspaces-overview.md), the current resource model for Azure Chaos Studio. It's still Chaos Studio, with the same `Microsoft.Chaos` resource provider and a new way to define and run tests. Use this guide to check which model you use, map your experiments to Scenarios, test them in a Workspace, and remove classic resources you no longer need.

[!INCLUDE [chaos-studio-workspaces-preview](includes/chaos-studio-workspaces-preview.md)]

## Identify which resource model you use

Both models use the `Microsoft.Chaos` resource provider, but each has different resource types. Check the resource type to identify the model when you review a resource or run, or submit a support request.

| Detail | Chaos Studio Workspaces | Experiments (classic) |
|---|---|---|
| Resource types | `Microsoft.Chaos/workspaces`, `Microsoft.Chaos/workspaces/scenarios` | `Microsoft.Chaos/experiments`, `Microsoft.Chaos/targets` |
| Azure portal | **Chaos Studio** > **Workspaces** | **Chaos Studio** > **Experiments** and **Targets** |
| Azure CLI | [`az chaos` extension](chaos-studio-manage-cli.md) | `az rest` calls to the [REST API](chaos-studio-samples-rest-api.md) |
| Unit of testing | Scenario, run from a Workspace | Experiment |

To find classic resources in your subscriptions, [sign in to the Azure CLI and install the Resource Graph extension](/azure/governance/resource-graph/first-query-azurecli), and then run the following queries. Experiments are in the `resources` table, and targets are in the [`chaosresources` table](/azure/governance/resource-graph/reference/supported-tables-resources#chaosresources).

```azurecli
az graph query -q "resources | where type =~ 'microsoft.chaos/experiments' | project name, resourceGroup, subscriptionId"
az graph query -q "chaosresources | where type =~ 'microsoft.chaos/targets' | summarize count() by subscriptionId, resourceGroup"
```

Resource Graph returns only resources you have permission to read. If both queries return no results and you can read the relevant subscriptions, you don't have classic resources to move. For new tests, start with the [Workspaces quickstart](quickstart-create-workspace.md).

## Map classic concepts to Workspaces

A Workspace handles most of the setup steps you do manually in Experiments (classic). Use this table to see how familiar concepts translate to Workspaces.

| Experiments (classic) | Chaos Studio Workspaces |
|---|---|
| Enable a target and capabilities on each resource. | Set the Workspace scope to a subscription, resource group, or service group. The Workspace [discovers supported resources](chaos-studio-workspaces-overview.md#scope-types) automatically. |
| Build an experiment from faults, steps, and branches. | Start from a [Scenario template](chaos-studio-scenarios.md#supported-scenario-templates), or customize one in the [Scenario designer](chaos-studio-scenarios.md#create-a-custom-scenario). Use `runAfter` dependencies to sequence Actions. |
| Select target resources for each fault. | The Scenario applies to the discovered resources in scope. Use [resource exclusions](chaos-studio-scenarios.md#resource-exclusions) to protect specific resources. |
| Assign a managed identity and roles to each experiment. | Assign roles once to the [Workspace identity](chaos-studio-workspace-permissions.md). All Scenarios in the Workspace share this identity. The Workspace checks permissions before a run starts. |
| Deploy the experiment in a supported region, with targets in a targeting region. | Deploy the Workspace in a [supported Workspace region](chaos-studio-region-availability.md#regional-availability-of-chaos-studio-workspaces). It can act on resources in any Azure region. |
| Install the Chaos Studio agent on each VM for agent-based faults. | Agent-based Scenarios install and remove the agent automatically during a run. |
| Review experiment execution details. | Generate a [Scenario report](chaos-studio-scenario-reports.md) for each run. |

## Find the Scenario for each experiment

Use this table to find a starting point for common classic tests, not a one-to-one replacement. Compare the template's Actions, target resource types, parameters, and recovery behavior with your experiment. Some templates combine several disruptions. Customize the template in the Scenario designer, and exclude resources you don't intend to affect.

| Classic test | Workspaces Scenario |
|---|---|
| [Simulate a DNS outage with NSG rules (classic)](chaos-studio-tutorial-dns-outage.md) | [DNS Outage](chaos-studio-scenarios.md#dns-outage) |
| [Simulate a Microsoft Entra ID outage (classic)](chaos-studio-tutorial-aad-outage-portal.md) | [Microsoft Entra ID Outage](chaos-studio-scenarios.md#microsoft-entra-id-outage) |
| [Simulate zone down on VM scale sets (classic)](chaos-studio-tutorial-availability-zone-down-portal.md) | [Compute Zone Down](chaos-studio-scenarios.md#compute-zone-down) shuts down zonal compute resources, but doesn't include the classic template's Disable Autoscale Action. |
| VM or virtual machine scale set shutdown in an availability zone | [Compute Zone Down](chaos-studio-scenarios.md#compute-zone-down) uses a zone filter; it isn't a replacement for every VM shutdown test. |
| Azure Cache for Redis primary-node reboot | [Zone Down](chaos-studio-scenarios.md#zone-down) reboots the primary node and also shuts down zonal scale set instances. The [cache resilience Scenarios](chaos-studio-scenarios.md#cache-resilience-scenarios) flush Azure Managed Redis instead; they don't reproduce an Azure Cache for Redis reboot. |
| Disable Service Bus queues or Event Hubs entities | [Event-Driven Messaging Disruption](chaos-studio-scenarios.md#event-driven-messaging-disruption) disables these entities and re-enables them after the run. It doesn't cover Service Bus topic or subscription state changes. |
| Agent-based CPU pressure or physical memory pressure on a standalone VM | [CPU Pressure](chaos-studio-scenarios.md#cpu-pressure) or [Physical Memory Pressure](chaos-studio-scenarios.md#physical-memory-pressure) |
| Zone resilience of AKS node pools | [Test AKS resilience with Chaos Studio Workspaces](chaos-studio-aks-guidance.md) |

## Check for capabilities that aren't in Workspaces yet

Some classic capabilities aren't available in the Workspaces preview. If an experiment needs one of them, keep it in Experiments (classic) for now. Also keep tests in classic if you require a generally available resource model. Evaluate your other tests in Workspaces in a preproduction environment.

| Required capability or configuration | Status in Workspaces |
|---|---|
| Faults outside the supported Scenario catalog | The full classic fault library isn't available. Check the [Scenario templates and their Actions](chaos-studio-scenarios.md#supported-scenario-templates) before moving a test. |
| AKS Chaos Mesh faults and other in-cluster pod faults | Not available. Use [AKS Chaos Mesh faults with Experiments (classic)](chaos-studio-tutorial-aks-portal.md). |
| Agent-based faults other than CPU and physical memory pressure, and agent faults on virtual machine scale sets, Arm-based VM sizes, or VMs without public outbound connectivity | Not available. Review [Workspaces agent-based Scenario requirements](chaos-studio-scenarios.md#agent-based-scenario-requirements). If you keep an agent-based test in classic, check the classic [agent OS support](chaos-agent-os-support.md) and [private networking requirements](chaos-studio-private-networking.md). |
| Dynamic targeting | Not available. Use [dynamic targeting with Experiments (classic)](chaos-studio-tutorial-dynamic-target-portal.md). |
| Scheduled runs | Not available. Use [scheduled experiments with Experiments (classic)](tutorial-schedule.md). |
| Customer-managed keys | Not available. Use [customer-managed keys with Experiments (classic)](chaos-studio-configure-customer-managed-keys.md). |
| PowerShell, Python SDK, and JavaScript SDK | Not available. Use the Azure portal, `az chaos` CLI, Bicep, ARM templates, the REST API, or the .NET SDK. |

Service-direct Scenarios work with privately networked target resources; the public outbound connectivity requirement applies to agent-based Scenarios. Also check each Scenario's requirements, such as Windows-only support for Cache Stampede with Process Crash. For the current list of limitations, see [Chaos Studio Workspaces limitations](chaos-studio-workspaces-limitations.md). To request a capability, [open an issue on GitHub](https://github.com/microsoft/chaos-studio/issues).

## Run the equivalent Scenario in a Workspace

Run each replacement Scenario in a preproduction environment before you remove the classic experiment.

1. Create a Workspace scoped to the subscription, resource group, or service group that contains the resources your experiment targets. Follow the [Workspaces quickstart](quickstart-create-workspace.md) in the portal, or [bootstrap a Workspace with the Azure CLI](chaos-studio-manage-cli.md#bootstrap-a-workspace-with-one-command).
1. Grant the Workspace identity the roles that the Scenario requires. See [Permissions and identity in Chaos Studio Workspaces](chaos-studio-workspace-permissions.md#role-assignments-the-workspace-identity-needs) for the list of roles.
1. Check that the Workspace discovers the resources your experiment targets. If any are missing, see [Troubleshoot Chaos Studio Workspaces and Scenarios](troubleshoot-workspaces-scenarios.md).
1. Configure the Scenario with the Actions and supported parameters needed to reproduce your test, including zone and duration where applicable. Exclude any resources that your experiment didn't target.
1. Run the Scenario, and then generate its Scenario report. Compare its Actions, affected resources, and recovery behavior with your experiment's execution details to confirm that it reproduces the intended test.
1. Update any automation that starts the classic experiment to start the Scenario from its configuration with the [`az chaos` CLI](chaos-studio-manage-cli.md#run-the-scenario). To deploy the Scenario definition, use a [`Microsoft.Chaos/workspaces/scenarios` template](chaos-studio-scenarios.md#example-custom-scenario-in-bicep). For Terraform, use the AzAPI provider with [Workspaces](/azure/templates/microsoft.chaos/workspaces?tabs=terraform) and [Scenarios](/azure/templates/microsoft.chaos/workspaces/scenarios?tabs=terraform). Deploying these resources doesn't start a run.

## Clean up classic resources

After the Scenario replaces your experiment, remove the classic resources to prevent further runs and remove permissions you no longer need.

1. Delete the experiment. In the Azure portal, go to **Chaos Studio** > **Experiments**, select the experiment, and select **Delete**. To use the REST API, see [Delete an experiment](chaos-studio-samples-rest-api.md#delete-an-experiment).
1. Remove role assignments that are no longer needed from the experiment's managed identity on the target resources. If it uses a user-assigned identity, first check whether other experiments, Workspaces, or resources still use that identity and its permissions.
1. Disable any targets that no other classic experiment uses. In the Azure portal, go to **Chaos Studio** > **Targets**, select the resources, and select **Disable targets**.
1. If you installed the Chaos Studio agent for agent-based experiments and no remaining classic experiment needs it on the VM or scale set, [uninstall the agent](chaos-agent-uninstall.md). Workspaces Scenarios install and remove the agent automatically.

## Next steps

- [Chaos Studio Workspaces overview](chaos-studio-workspaces-overview.md).
- [Quickstart: Create a Workspace and run a Scenario](quickstart-create-workspace.md).
- [Scenarios and outage templates for Chaos Studio Workspaces](chaos-studio-scenarios.md).
- [Chaos Studio Workspaces vs. Experiments (classic)](chaos-studio-workspaces-vs-experiments.md).
