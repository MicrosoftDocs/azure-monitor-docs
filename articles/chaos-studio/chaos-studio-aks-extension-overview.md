---
title: Chaos Studio extension for AKS (preview) overview
description: Learn what the Chaos Studio extension for AKS does, when to use its pod-level faults, how it connects to a Workspace, and its preview requirements and known issues.
author: nikhilkaul-msft
ms.topic: concept-article
ms.date: 10/14/2026
ai-usage: ai-assisted
---

# Chaos Studio extension for AKS (preview) overview

The Azure Chaos Studio extension for Azure Kubernetes Service (AKS) injects faults into the pods of your workloads. Use it to check whether your application keeps serving users when pods fail, run out of CPU or memory, or lose network quality. For example, you can delete the pods of a checkout service under test traffic and check that requests still succeed and that every acknowledged order is stored.

You run the faults as Actions in [Chaos Studio Workspaces](chaos-studio-workspaces-overview.md) Scenarios. The extension runs the open-source [LitmusChaos](https://litmuschaos.io/) engine inside your cluster. You don't write Litmus resources yourself.

> [!IMPORTANT]
> The extension is in a limited preview. Microsoft enables it only for allow-listed subscriptions. During the preview, the extension is available in West Central US. To request access, [open an issue in the Chaos Studio GitHub repository](https://github.com/microsoft/chaos-studio/issues/new/choose). Workspaces public preview access doesn't give you access to the extension.

## When to use the extension

Use the extension when your question is about how an application behaves inside the cluster. Kubernetes can replace a pod and still lose requests or data. A pod-level test shows both the cluster response and the user outcome.

Use a different test for other failure boundaries:

- To test the loss of nodes in an availability zone, use [AKS node resilience testing with Workspaces](chaos-studio-aks-guidance.md). A pod fault isn't a zone outage.
- To use Chaos Mesh faults, use [AKS Chaos Mesh faults with Experiments (classic)](chaos-studio-tutorial-aks-portal.md). That workflow doesn't need the extension.

## Common scenarios

### Test pod replacement under load

Use **pod delete** on the pods of one service while test traffic runs. Measure request success, latency, and the time until replacement pods serve traffic. For stateful work, check that every acknowledged request has a stored result after the test.

### Check autoscaling and resource limits

Use **pod CPU hog** or **pod memory hog** on a service. Check whether the Horizontal Pod Autoscaler adds replicas and whether your CPU and memory limits protect neighboring workloads. Watch for pods that Kubernetes evicts or restarts because they run out of memory.

### Test timeouts and retries to dependencies

Use **pod network latency** on the pods that call a database or downstream API. Check that timeouts, retries, and circuit breakers act as you expect. Measure the effect on end-to-end latency for users.

### Test behavior when packets drop

Use **pod network loss** to drop a percentage of the network packets of selected pods. Check whether clients retry correctly and whether health probes mark the pods unhealthy at the right time.

## Available faults

All faults use Action version 1.0. In the Action catalog, the version is `1.0.0`, for example `urn:csci:microsoft:containerservice:poddelete/1.0.0`.

| Fault | Name in the Action URN | What it does |
| --- | --- | --- |
| Pod delete | `poddelete` | Deletes the selected pods. |
| Pod CPU hog | `podcpuhog` | Consumes CPU in the selected pods. |
| Pod memory hog | `podmemoryhog` | Consumes memory in the selected pods. |
| Pod network latency | `podnetworklatency` | Adds latency to the network traffic of the selected pods. |
| Pod network loss | `podnetworkloss` | Drops a percentage of the network packets of the selected pods. |

The minimum fault duration is 1 minute (`PT1M`).

## How it works

1. You create a Workspace that has a user-assigned managed identity. The Workspace scope must include the AKS cluster resource. For more information, see [Permissions and identity in Chaos Studio Workspaces](chaos-studio-workspace-permissions.md).
1. You install the extension on the cluster with the Azure CLI. Installation connects the cluster to the Workspace and gives the Workspace identity a role on the cluster. For details, see [Review the permissions for installation](chaos-studio-aks-extension-install.md#review-the-permissions-for-installation).
1. You add a pod fault Action to a Scenario and select the target pods.
1. When the Scenario runs, a component in the cluster receives the Action and runs the fault with LitmusChaos.

The cluster connects outbound to Chaos Studio. You don't open inbound ports on the cluster. The cluster also pulls the extension images from Microsoft Container Registry and authenticates with Microsoft Entra ID.

## Preview requirements and limitations

- **Access.** Your subscription must be on the preview allow list. To request access, [open an issue in the Chaos Studio GitHub repository](https://github.com/microsoft/chaos-studio/issues/new/choose).
- **Region.** During the preview, the extension is available in West Central US.
- **Cluster features.** The cluster must have [Microsoft Entra Workload ID](/azure/aks/workload-identity-overview), the [OIDC issuer](/azure/aks/use-oidc-issuer), and [Azure RBAC for Kubernetes authorization](/azure/aks/manage-azure-rbac) turned on.
- **Node pools.** Faults affect pods on Linux amd64 nodes. In a cluster with amd64 and arm64 node pools, faults affect only pods on amd64 nodes. Clusters with only arm64 node pools and Windows node pools aren't supported.
- **Deployment Safeguards.** If [Deployment Safeguards](/azure/aks/deployment-safeguards) enforces policies on the cluster, the network faults aren't available. Pod delete, CPU hog, and memory hog still work. For details, see [Check your cluster configuration](chaos-studio-aks-extension-install.md#check-your-cluster-configuration).
- **Azure CLI.** Use version 1.9.4 or later of the `k8s-extension` Azure CLI extension.
- **Other configurations.** If your cluster uses a configuration that this article doesn't list, ask about it in your access request.

## Known issues

- **Connection status shows Pending.** The Workspace connection status shows `Pending` even when the connection works. Don't use the connection status to decide whether the extension is ready. Check the extension provisioning state and run a short test.
- **Short durations fail.** A fault duration shorter than 1 minute (`PT1M`) fails.
- **Installation in a second subscription fails with older CLI versions.** Versions of the `k8s-extension` Azure CLI extension earlier than 1.9.4 can fail when you install in more than one subscription in the same tenant. Upgrade to version 1.9.4 or later.

## Interpret the results

A completed Action shows that Chaos Studio ran the fault. It doesn't show that your application recovered. Compare these sources of evidence:

| Evidence | What it tells you |
| --- | --- |
| The [Scenario report](chaos-studio-scenario-reports.md) | Whether the Action completed, and when it ran. |
| Kubernetes events and pod status | Which pods the fault affected, and how Kubernetes responded. |
| Application metrics and test traffic | Whether users could still complete their tasks. |
| Data checks | Whether the application kept the work it acknowledged. |

If the fault didn't affect the pods that handled your test traffic, the run doesn't answer your question. Record the result as inconclusive, not as a pass.

## Choose between Workspaces and Experiments (classic)

The extension works only with Workspaces. For a comparison of the two resource models, see [Choose between Chaos Studio Workspaces and Experiments (classic)](chaos-studio-workspaces-vs-experiments.md). To move existing tests, see [Move from Experiments (classic) to Chaos Studio Workspaces](chaos-studio-migrate-from-classic.md).

## Next steps

- [Prepare to use the Chaos Studio extension for AKS](chaos-studio-aks-extension-install.md)
- [Permissions and identity in Chaos Studio Workspaces](chaos-studio-workspace-permissions.md)
- [Chaos Studio Workspaces limitations](chaos-studio-workspaces-limitations.md)
- [Scenario reports in Chaos Studio Workspaces](chaos-studio-scenario-reports.md)
