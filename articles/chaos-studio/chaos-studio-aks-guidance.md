---
title: Test AKS resilience with Chaos Studio Workspaces
description: Test AKS node resilience with Chaos Studio Workspaces by scoping Compute Zone Down to node scale sets and measuring application behavior during disruption.
author: nikhilkaul-msft
ms.topic: how-to
ms.date: 10/14/2026
ai-usage: ai-assisted
---

# Test AKS resilience with Chaos Studio Workspaces

Use [Chaos Studio Workspaces](chaos-studio-workspaces-overview.md) to test how an Azure Kubernetes Service (AKS) workload responds when node virtual machines in a selected availability zone shut down. The Compute Zone Down Scenario targets node scale sets in the cluster's infrastructure resource group. It tests node infrastructure, not in-cluster pod faults, and doesn't reproduce every effect of an availability-zone outage.

[!INCLUDE [chaos-studio-workspaces-preview](includes/chaos-studio-workspaces-preview.md)]

## Limitations

For node-level tests during the Workspaces public preview, review these limitations:

- There isn't yet a first-class AKS zone-down Scenario that understands the cluster as a whole. The [Compute Zone Down Scenario](chaos-studio-scenarios.md#compute-zone-down) targets virtual machines and virtual machine scale sets directly.
- To test AKS node resilience, scope the Workspace to include the cluster's *infrastructure* resource group (named beginning with `MC_` by default), not just the resource group that contains the cluster resource. For background, see [Why a Workspace scoped to your AKS cluster finds no compute targets](#why-a-workspace-scoped-to-your-aks-cluster-finds-no-compute-targets).
- This approach targets the node pools' virtual machine scale sets. It doesn't apply to node pools created by node autoprovisioning (NAP).

For the full list of preview limitations, see [Limitations and known issues in Chaos Studio Workspaces](chaos-studio-workspaces-limitations.md).

This node-level approach doesn't require the AKS extension. The extension's pod-level tests have a separate, allow-listed preview; access to the Workspaces public preview doesn't grant extension access. See [Chaos Studio extension for AKS (preview) overview](chaos-studio-aks-extension-overview.md).

## Before you start: verify your cluster topology

Before a node shutdown test, understand how the workload is distributed and what capacity remains if the selected nodes are unavailable. Review both your node pool configuration and the actual placement of nodes and workload replicas:

- Check which availability zones contain nodes and workload replicas. Node placement alone doesn't establish that the application is zone-resilient. See [Availability zones in AKS](/azure/aks/availability-zones).
- Assess whether the remaining nodes have enough capacity for the affected workload. Consider scheduling constraints and dependencies as well as available compute capacity.
- Pick a target zone that has instances in the node scale sets you intend to test. A zone filter with no matching instances doesn't exercise the expected failure.

Define the application outcome you expect before you run the Scenario. For example, measure whether requests continue succeeding and accepted work persists while nodes are unavailable. Record normal behavior under representative test traffic, agree on stop conditions, and identify who will recover the workload if it doesn't recover as expected.

## Find the infrastructure resource group and node scale sets

1. Find the cluster's infrastructure resource group. In the Azure portal, open your AKS cluster and select **Settings** > **Properties**. Select the **Infrastructure resource group** link. To find the resource group with Azure CLI, replace `<ResourceGroupName>` and `<ClusterName>` with your cluster's resource group and name:

    ```azurecli
    az aks show --resource-group <ResourceGroupName> --name <ClusterName> --query nodeResourceGroup -o tsv
    ```

1. In the infrastructure resource group, find the resources of type **Virtual machine scale set**. There's typically one per node pool, with names like `aks-agentpool-12345678-vmss`. Note the ones for the node pools you want to test.

1. To review the node pool's configured zones, return to your AKS cluster and select **Settings** > **Node pools**. Select the node pool name and check **Availability zones**. Also verify that the zone you plan to target contains instances in the selected scale sets.

If you don't have a workload ready for testing, start with a sample application. For an end-to-end walkthrough that starts from a fresh cluster and a sample application, see [Tutorial: Deploy a sample application and test its zone resilience with Chaos Studio](chaos-studio-tutorial-sample-app.md).

## Run the Compute Zone Down Scenario

> [!WARNING]
> This approach acts directly on infrastructure that AKS manages for you. AKS reconciliation and the cluster autoscaler might change capacity during or after the run, affecting both the disruption and your measurements. Run this test in a preproduction cluster first. Obtain explicit approval from the cluster and workload owners for the targets, expected impact, stop conditions, and recovery plan.

1. [Create a Workspace](quickstart-create-workspace.md) with its scope set to the cluster's infrastructure resource group, and grant the Workspace's managed identity the [required roles](chaos-studio-workspace-permissions.md). Review the discovered resources and confirm that the scope doesn't include infrastructure you haven't approved for testing.

1. Configure the **Compute Zone Down** Scenario, selecting the availability zone you verified earlier. Review its Actions, target resources, and duration before starting. The Scenario shuts down matching virtual machines and virtual machine scale set instances; it doesn't target the AKS cluster resource itself.

1. Start application traffic and monitoring before the run so that you have a baseline. Monitor request success, latency, and the persistence of accepted work as appropriate for your test. Also observe cluster behavior, for example with these commands:

    ```bash
    # Watch nodes go down and recover
    kubectl get nodes -w

    # Check which nodes host the pods
    kubectl get pods -o wide --all-namespaces
    ```

1. Run the Scenario and observe whether the intended nodes become unavailable. Track changes in pod readiness, scheduling, and application behavior. Don't assume that pods reschedule successfully, that disruption is brief, or that pods automatically redistribute when nodes return. Follow your agreed stop and recovery procedures if the test reaches a stop condition.

1. Continue monitoring after the run ends. Verify node readiness, workload health, and accepted work before declaring recovery complete.

## Interpret the results

In the [Scenario report](chaos-studio-scenario-reports.md), a **Succeeded** status means an Action completed normally. Check its targeted resources and timing against your node observations to establish whether the intended disruption occurred. A **Skipped** status means the Action didn't execute. Possible causes include no matching targets or unmet preconditions. See [A run affects nothing (all Actions skipped)](troubleshoot-workspaces-scenarios.md#a-run-affects-nothing-all-actions-skipped).

The run itself succeeding doesn't mean your application passed the test. Kubernetes replacing a pod isn't the same as requests continuing to succeed or accepted work remaining stored. Investigate findings such as the following:

- If the application stayed unavailable after pods rescheduled, check readiness, dependencies, traffic routing, and application errors.
- If pods stayed pending, examine scheduling events for capacity shortages, placement constraints, or storage availability.
- If requests failed or accepted work was lost, investigate the application behavior even if the shutdown Actions succeeded.
- If recovery exceeded your objective, use the run timeline and application observations to identify where the delay occurred.

Pair the Scenario report with cluster and application monitoring to judge recovery end to end. AKS or autoscaling activity can change the conditions during the test. Record those changes, verify the environment is healthy afterward, and use comparable traffic and configuration for a rerun. Missing observations or a run that didn't affect the intended nodes don't establish resilience.

## Why a Workspace scoped to your AKS cluster finds no compute targets

When you create an AKS cluster, AKS creates a managed *infrastructure* resource group (named beginning with `MC_` by default) that contains the cluster's node virtual machine scale sets, load balancers, and related infrastructure resources. The cluster resource itself lives in the resource group you chose; the nodes don't.

Because Workspace discovery is bounded by the [scope](chaos-studio-workspace-permissions.md#scope-determines-which-resources-a-workspace-can-discover), a Workspace scoped only to the resource group that contains the AKS *cluster resource* doesn't discover the cluster's node scale sets. Include the infrastructure resource group to discover those resources. You might still discover and target other compute resources in the scope, so review the target list rather than assuming a run affects nothing.

## Alternatives

For pod-level testing through Workspaces, [request access and prepare for the AKS extension preview](chaos-studio-aks-extension-install.md). Confirm which faults and cluster configurations are available for your approved version before designing the test. A pod disruption doesn't substitute for a node-level zone test.

[AKS Chaos Mesh faults with Experiments (classic)](chaos-studio-tutorial-aks-portal.md) remain available through their existing workflow and don't require this extension.

## Next steps

- [Troubleshoot Workspaces and Scenarios in Azure Chaos Studio](troubleshoot-workspaces-scenarios.md).
- [Scenarios in Azure Chaos Studio](chaos-studio-scenarios.md).
- [Permissions and identity in Chaos Studio Workspaces](chaos-studio-workspace-permissions.md).
