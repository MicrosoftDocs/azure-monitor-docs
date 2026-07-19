---
title: Test workload resiliency on AKS with Chaos Studio (preview)
description: Learn how to test the resiliency of workloads running on Azure Kubernetes Service (AKS) by using Azure Chaos Studio workspaces to simulate an availability zone failure.
author: nikhilkaul-msft
ms.topic: how-to
ms.date: 07/17/2026
ai-usage: ai-assisted
---

# Test workload resiliency on AKS with Chaos Studio (preview)

This article explains how to use Azure Chaos Studio [workspaces](chaos-studio-workspaces-overview.md) to test the resiliency of workloads running on Azure Kubernetes Service (AKS). You simulate a compute failure that shuts down the cluster's node virtual machines in one availability zone, then observe how the cluster and your workloads respond.

[!INCLUDE [chaos-studio-workspaces-preview](includes/chaos-studio-workspaces-preview.md)]

## Limitations

AKS-specific scenario support in workspaces is limited during the public preview:

- There isn't yet a first-class AKS zone-down scenario that understands the cluster as a whole. The [Compute Zone Down scenario](chaos-studio-scenarios.md#compute-zone-down) targets virtual machines and virtual machine scale sets directly.
- To test AKS node resilience, you must deliberately scope the workspace to the cluster's *infrastructure* resource group (named beginning with `MC_` by default), not the resource group that contains the cluster resource. For background, see [Why a workspace scoped to your AKS cluster finds no compute targets](#why-a-workspace-scoped-to-your-aks-cluster-finds-no-compute-targets).
- This approach targets the node pools' virtual machine scale sets. It doesn't apply to node pools created by node autoprovisioning (NAP).

For the full list of preview limitations, see [Limitations and known issues in Chaos Studio workspaces](chaos-studio-workspaces-limitations.md).

## Before you start: verify your cluster topology

This test simulates a zone failure, so it's only meaningful against a cluster that's built to survive one. In the Azure portal, open your AKS cluster and select **Settings** > **Node pools**, then verify:

- **Availability zones**: Each node pool you want to test spans multiple zones (for example, "1, 2, 3"). If your node pools aren't zone-redundant, address that first. See [Availability zones in AKS](/azure/aks/availability-zones).
- **Node count**: There are enough nodes for a meaningful test - ideally two or more per zone. If a pool has fewer than three nodes, scale it up before testing.
- **Capacity headroom**: The remaining zones can absorb the workload from the zone you take down. If they can't, pods stay pending during the test - which is itself a resilience finding, but make sure that's a result you're prepared for.
- **Pick a target zone that has nodes in it.** The scenario's actions filter by zone; if you target a zone with no instances, nothing happens and the actions skip.

## Find the infrastructure resource group and node scale sets

1. Find the cluster's infrastructure resource group. In the Azure portal, open your AKS cluster and select **Settings** > **Properties**. Select the **Infrastructure resource group** link. To find the resource group with Azure CLI:

    ```azurecli
    az aks show --resource-group myResourceGroup --name myAKSCluster --query nodeResourceGroup -o tsv
    ```

1. In the infrastructure resource group, find the resources of type **Virtual machine scale set**. There's typically one per node pool, with names like `aks-agentpool-12345678-vmss`. Note the ones for the node pools you want to test.

1. To validate how nodes are distributed across zones, return to your AKS cluster and select **Settings** > **Node pools**. Select the node pool name and check **Availability zones**.

Optionally, deploy a sample application to the cluster before the test so you can observe application-level impact - whether the app stays reachable while nodes are down.

## Run the Compute Zone Down scenario

> [!WARNING]
> This approach acts directly on infrastructure that AKS manages for you. AKS reconciliation and the cluster autoscaler might recreate or rebalance instances during or after the run. This action can affect both the disruption and your measurements. Run this test in a preproduction cluster first, and only opt in after understanding the caveats.

1. [Create a workspace](quickstart-create-workspace.md) with its scope set to the cluster's infrastructure resource group, and grant the workspace's managed identity the required roles. After discovery completes, the node virtual machine scale sets appear as discovered resources.

1. Configure the **Compute Zone Down** scenario, selecting the availability zone you verified earlier. The scenario's actions shut down the virtual machine and virtual machine scale set instances in the target zone for the configured duration. The instances restart when the action's duration ends.

1. Before you start the run, set up something to watch. In the AKS cluster's **Monitoring** > **Metrics** blade, chart a per-node metric such as CPU usage split by node, and keep the tab open during the run. Or watch from inside the cluster:

    ```bash
    # Watch nodes go down and recover
    kubectl get nodes -w

    # Check pod distribution across zones
    kubectl get pods -o wide --all-namespaces
    ```

1. Run the scenario and observe. It can take a few minutes after the run starts for the shutdowns to take effect and appear in metrics, so don't be alarmed if nothing changes immediately. As the target zone's nodes go down, expect the node count to drop, pods to reschedule to the remaining zones (with a brief window of disruption if you're testing a live application), and the load to stabilize at a higher level on the remaining nodes. When the instances restart at the end of the run, nodes rejoin the cluster and pods rebalance over the following minutes.

## Interpret the results

In the [scenario report](chaos-studio-scenario-reports.md), a **Succeeded** status on the shutdown actions indicates the run found node instances in the target zone and disrupted them. If the shutdown actions show **Skipped**, the run found no matching targets - usually the scope doesn't include the infrastructure resource group, or the targeted zone had no instances. See [A run affects nothing (all Actions skipped)](troubleshoot-workspaces-scenarios.md#a-run-affects-nothing-all-actions-skipped).

The run itself succeeding doesn't mean your cluster passed the test. Signs of a resilience gap worth investigating:

- Your application stayed down after pods rescheduled - check replica counts, pod disruption budgets, and whether resource constraints prevented scheduling.
- Pods stayed pending during the run - the remaining zones didn't have capacity to absorb the lost zone.
- Recovery took longer than your recovery time objective once the zone's instances returned.

Pair the scenario report with your own cluster and application monitoring to judge recovery behavior end to end - AKS might begin recreating or rebalancing instances while the run is still in progress.

## Why a workspace scoped to your AKS cluster finds no compute targets

When you create an AKS cluster, AKS creates a managed *infrastructure* resource group (named beginning with `MC_` by default) that contains the cluster's node virtual machine scale sets, load balancers, and related infrastructure resources. The cluster resource itself lives in the resource group you chose; the nodes don't.

Because workspace discovery is bounded by the [scope](chaos-studio-workspace-permissions.md#scope-determines-which-resources-a-workspace-can-discover), a workspace scoped to the resource group that contains the AKS *cluster resource* doesn't discover the node pools. The node pools live in the infrastructure resource group. The result is a workspace that appears to contain your cluster but surfaces no actionable compute targets, and zone-down runs whose actions all show a **Skipped** status.

## Alternatives

For in-cluster fault injection (pod failures, network faults, stress inside the cluster), the classic experiments model supports AKS Chaos Mesh faults today. See [Create an experiment that uses Chaos Mesh faults on AKS](chaos-studio-tutorial-aks-portal.md).

## Next steps

- [Troubleshoot workspaces and scenarios in Azure Chaos Studio](troubleshoot-workspaces-scenarios.md)
- [Scenarios in Azure Chaos Studio](chaos-studio-scenarios.md)
- [Permissions and identity in Chaos Studio Workspaces](chaos-studio-workspace-permissions.md)
