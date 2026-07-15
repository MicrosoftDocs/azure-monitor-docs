---
title: Test AKS resilience with Chaos Studio Workspaces (preview limitations)
description: Understand the current limitations of Azure Kubernetes Service (AKS) support in Chaos Studio Workspaces, and how to test AKS node zone resilience today by scoping a Workspace to the cluster's infrastructure resource group.
author: nikhilkaul-msft
ms.topic: how-to
ms.date: 07/14/2026
ai-usage: ai-assisted
---

# Test AKS resilience with Chaos Studio Workspaces (preview limitations)

This article explains the current state of Azure Kubernetes Service (AKS) support in Azure Chaos Studio [Workspaces](chaos-studio-workspaces-overview.md), and walks through an interim approach for testing the zone resilience of AKS node pools during the public preview: simulating a compute failure that shuts down the cluster's node virtual machines in one availability zone, then observing how the cluster and your workloads respond.

> [!NOTE]
> Azure Chaos Studio workspaces and scenarios are in public preview.

## Current state of AKS support in Workspaces

AKS-specific Scenario support in Workspaces is limited during the public preview. The [Compute Zone Down Scenario](chaos-studio-scenarios.md#compute-zone-down) targets virtual machines and virtual machine scale sets directly; there isn't yet a first-class AKS zone-down Scenario that understands the cluster as a whole. You can still test the zone resilience of an AKS cluster's nodes today, but doing so requires scoping the Workspace deliberately, as described in the following section.

## Why a Workspace scoped to your AKS cluster finds no compute targets

When you create an AKS cluster, AKS creates a managed *infrastructure* resource group (named beginning with `MC_` by default) that contains the cluster's node virtual machine scale sets, load balancers, and related infrastructure resources. The cluster resource itself lives in the resource group you chose; the nodes don't.

Because Workspace discovery is bounded by the [scope](chaos-studio-workspace-permissions.md#scope-determines-which-resources-a-workspace-can-discover), a Workspace scoped to the resource group that contains the AKS *cluster resource* doesn't discover the node pools. The node pools live in the infrastructure resource group. The result is a Workspace that appears to contain your cluster but surfaces no actionable compute targets, and zone-down runs whose Actions all show a **Skipped** status.

## Before you start: verify your cluster topology

This test simulates a zone failure, so it's only meaningful against a cluster that's built to survive one. In the Azure portal, open your AKS cluster and select **Settings** > **Node pools**, then verify:

- **Availability zones**: Each node pool you want to test spans multiple zones (for example, "1, 2, 3"). If your node pools aren't zone-redundant, address that first. See [Availability zones in AKS](/azure/aks/availability-zones).
- **Node count**: There are enough nodes for a meaningful test - ideally two or more per zone. If a pool has fewer than three nodes, scale it up before testing.
- **Capacity headroom**: The remaining zones can absorb the workload from the zone you take down. If they can't, pods stay pending during the test - which is itself a resilience finding, but make sure that's a result you're prepared for.
- **Pick a target zone that has nodes in it.** The Scenario's Actions filter by zone; if you target a zone with no instances, nothing happens and the Actions skip.

> [!NOTE]
> This approach targets the node pools' virtual machine scale sets. It doesn't apply to node pools created by node autoprovisioning (NAP).

## Find the infrastructure resource group and node scale sets

1. Find the cluster's infrastructure resource group. In the Azure portal, open your AKS cluster and select **Settings** > **Properties**. Select the **Infrastructure resource group** link. To find the resource group with Azure CLI:

    ```azurecli
    az aks show --resource-group myResourceGroup --name myAKSCluster --query nodeResourceGroup -o tsv
    ```

1. In the infrastructure resource group, find the resources of type **Virtual machine scale set**. There's typically one per node pool, with names like `aks-agentpool-12345678-vmss`. Note the ones for the node pools you want to test.

1. Open a scale set and select **Settings** > **Instances** to verify that instances are distributed across zones and that the zone you plan to target actually has running instances.

Optionally, deploy a sample application to the cluster before the test so you can observe application-level impact - whether the app stays reachable while nodes are down.

## Run the Compute Zone Down Scenario

> [!WARNING]
> This approach acts directly on infrastructure that AKS manages for you. AKS reconciliation and the cluster autoscaler might recreate or rebalance instances during or after the run. This action can affect both the disruption and your measurements. Run this test in a preproduction cluster first, and only opt in after understanding the caveats.

1. [Create a Workspace](quickstart-create-workspace.md) with its scope set to the cluster's infrastructure resource group, and grant the Workspace's managed identity the required roles. After discovery completes, the node virtual machine scale sets appear as discovered resources.

1. Configure the **Compute Zone Down** Scenario, selecting the availability zone you verified earlier. The Scenario's Actions shut down the virtual machine and virtual machine scale set instances in the target zone for the configured duration. The instances restart when the Action's duration ends.

1. Before you start the run, set up something to watch. In the AKS cluster's **Monitoring** > **Metrics** blade, chart a per-node metric such as CPU usage split by node, and keep the tab open during the run. Or watch from inside the cluster:

    ```bash
    # Watch nodes go down and recover
    kubectl get nodes -w

    # Check pod distribution across zones
    kubectl get pods -o wide --all-namespaces
    ```

1. Run the Scenario and observe. It can take a few minutes after the run starts for the shutdowns to take effect and appear in metrics, so don't be alarmed if nothing changes immediately. As the target zone's nodes go down, expect the node count to drop, pods to reschedule to the remaining zones (with a brief window of disruption if you're testing a live application), and the load to stabilize at a higher level on the remaining nodes. When the instances restart at the end of the run, nodes rejoin the cluster and pods rebalance over the following minutes.

## Interpret the results

In the [Scenario report](chaos-studio-scenario-reports.md), a **Succeeded** status on the shutdown actions indicates the run found node instances in the target zone and disrupted them. If the shutdown actions show **Skipped**, the run found no matching targets - usually the scope doesn't include the infrastructure resource group, or the targeted zone had no instances. See [A run affects nothing (all Actions Skipped)](troubleshoot-workspaces-scenarios.md#a-run-affects-nothing-all-actions-skipped).

The run itself succeeding doesn't mean your cluster passed the test. Signs of a resilience gap worth investigating:

- Your application stayed down after pods rescheduled - check replica counts, pod disruption budgets, and whether resource constraints prevented scheduling.
- Pods stayed pending during the run - the remaining zones didn't have capacity to absorb the lost zone.
- Recovery took longer than your recovery time objective once the zone's instances returned.

Pair the Scenario report with your own cluster and application monitoring to judge recovery behavior end to end - AKS might begin recreating or rebalancing instances while the run is still in progress.

## Alternatives

For in-cluster fault injection (pod failures, network faults, stress inside the cluster), the classic experiments model supports AKS Chaos Mesh faults today. See [Create an experiment that uses Chaos Mesh faults on AKS](chaos-studio-tutorial-aks-portal.md).

## Next steps

- [Troubleshoot Workspaces and Scenarios in Azure Chaos Studio](troubleshoot-workspaces-scenarios.md)
- [Scenarios in Azure Chaos Studio](chaos-studio-scenarios.md)
- [Permissions and identity in Chaos Studio Workspaces](chaos-studio-workspace-permissions.md)
