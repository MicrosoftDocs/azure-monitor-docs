---
title: Chaos Studio extension for AKS overview
description: Learn what the Chaos Studio extension for AKS does, which pod faults it runs, how it connects a cluster to a Workspace, and its requirements and known issues.
author: nikhilkaul-msft
ms.author: nikhilkaul
ms.service: azure-chaos-studio
ms.topic: concept-article
ms.date: 11/16/2026
ai-usage: ai-assisted
---

# Chaos Studio extension for AKS overview

The Azure Chaos Studio extension for Azure Kubernetes Service (AKS) injects faults into the pods of your workloads. Use it to check whether your application keeps serving users when pods fail, run out of CPU or memory, or lose network quality. For example, you can delete the pods of a checkout service under test traffic and check that requests still succeed and that every acknowledged order is stored.

You run the faults as Actions in Scenarios within [Chaos Studio Workspaces](chaos-studio-workspaces-overview.md). The extension runs the open-source [LitmusChaos](https://litmuschaos.io/) engine inside your cluster. You don't write Litmus resources yourself.

To install the extension and run your first fault, see [Install the Chaos Studio extension for AKS and run a pod fault](chaos-studio-aks-extension-install.md).

## When to use the extension

Use the extension to test how an application behaves inside the cluster. Even if Kubernetes replaces a pod, requests or data can still be lost. A pod-level test shows how the cluster responds and what users experience.

Use a different test for other failure boundaries:

- To test the loss of nodes in an availability zone, use [AKS node resilience testing with Workspaces](chaos-studio-aks-guidance.md). A pod fault isn't a zone outage.
- To use Chaos Mesh faults, use [AKS Chaos Mesh faults with Experiments (classic)](chaos-studio-tutorial-aks-portal.md). That workflow doesn't need the extension.

## Common use cases

The following examples show how to use each fault to answer a specific question about your application.

### Test pod replacement under load

Use **pod delete** on the pods of one service while test traffic runs. Measure request success, latency, and the time until replacement pods serve traffic. For stateful workloads, check that every acknowledged request has a stored result after the test.

### Check autoscaling and resource limits

Use **pod CPU hog** or **pod memory hog** on a service. Check whether the Horizontal Pod Autoscaler adds replicas and whether your CPU and memory limits protect neighboring workloads. Watch for pods that Kubernetes evicts or restarts because they run out of memory.

### Test timeouts and retries to dependencies

Use **pod network latency** on the pods that call a database or downstream API. Check that timeouts, retries, and circuit breakers act as you expect. Measure the effect on end-to-end latency for users.

### Test behavior when packets drop

Use **pod network loss** to drop a percentage of the network packets of selected pods. Check whether clients retry correctly and whether health probes mark the pods unhealthy at the right time.

## Available faults

The extension provides five faults. Each fault is an Action in the Workspaces Action catalog. All five use Action version `1.0.0`.

| Fault | Action ID | What it does | Can you cancel it? |
| --- | --- | --- | --- |
| Pod delete | `urn:csci:microsoft:containerservice:poddelete/1.0.0` | Deletes the selected pods. Kubernetes controllers create the replacements. | No |
| Pod CPU hog | `urn:csci:microsoft:containerservice:podcpuhog/1.0.0` | Consumes CPU inside the selected containers. | Yes |
| Pod memory hog | `urn:csci:microsoft:containerservice:podmemoryhog/1.0.0` | Consumes memory inside the selected containers. | Yes |
| Pod network latency | `urn:csci:microsoft:containerservice:podnetworklatency/1.0.0` | Adds latency to the network traffic of the selected pods. | Yes |
| Pod network loss | `urn:csci:microsoft:containerservice:podnetworkloss/1.0.0` | Drops a percentage of the network packets of the selected pods. | Yes |

The minimum Action duration is 1 minute (`PT1M`). For the parameters of each fault, see [Fault parameters](chaos-studio-aks-extension-install.md#fault-parameters).

Fault-specific behavior:

- **Pod CPU hog and pod memory hog** run commands inside the target container. The container image needs a shell and standard utilities such as `awk`. Minimal images that don't include these tools aren't suitable targets for these two faults.
- **Pod network latency and pod network loss** act on the network namespace of the pod. All containers in the pod share that namespace, so a fault affects a service mesh sidecar together with the application container. These two faults need the extension's network fault component. For details, see [Check your cluster configuration](chaos-studio-aks-extension-install.md#check-your-cluster-configuration).

## How it works

1. You create a Workspace that has a managed identity. The Workspace scope must include the AKS cluster resource. For more information, see [Permissions and identity in Chaos Studio Workspaces](chaos-studio-workspace-permissions.md).
1. You install the extension on the cluster with the Azure CLI. Installation connects the cluster to the Workspace and assigns a built-in role on the cluster to the Workspace identity. For details, see [Review the permissions for installation](chaos-studio-aks-extension-install.md#review-the-permissions-for-installation).
1. You add a pod fault Action to a Scenario and select the target pods by namespace and label.
1. When the Scenario runs, a component in the cluster receives the Action and runs the fault with LitmusChaos.

The cluster connects outbound to Chaos Studio. You don't open inbound ports on the cluster. The cluster also pulls the extension images from Microsoft Artifact Registry (`mcr.microsoft.com`) and authenticates with Microsoft Entra ID.

## Requirements and limitations

- **Region.** The extension uses the Chaos Studio data plane in the region of your Workspace, not the region of your cluster. Create the Workspace in a region that supports Workspaces. Your AKS cluster can be in any region that supports AKS extensions. For the Workspace regions, see [Regional availability by resource model](chaos-studio-region-availability.md#regional-availability-of-chaos-studio-workspaces).
- **Cluster features.** The cluster must have [Microsoft Entra Workload ID](/azure/aks/workload-identity-overview), the [OpenID Connect (OIDC) issuer](/azure/aks/use-oidc-issuer), and [Azure role-based access control (RBAC) for Kubernetes authorization](/azure/aks/entra-id-authorization) turned on.
- **Namespaces.** The extension runs faults only in the namespaces that you list when you install it. By default, that's only the `default` namespace. For details, see [Choose the workload namespaces](chaos-studio-aks-extension-install.md#choose-the-workload-namespaces).
- **Node pools.** The extension runs on Linux amd64 nodes, and its network fault component runs only on Linux amd64 nodes. In a cluster with amd64 and arm64 node pools, pod network latency and pod network loss affect only pods on amd64 nodes. Pod delete can also delete target pods on arm64 nodes. Make sure that your target selection includes only the pods you intend to affect. Clusters with only arm64 node pools aren't supported. Pods on Windows nodes aren't supported as fault targets.
- **Deployment Safeguards.** If [Deployment Safeguards](/azure/aks/deployment-safeguards) enforces policies on the cluster, the network faults aren't available unless you exclude the extension's namespace. AKS Automatic clusters enforce Deployment Safeguards by default. Pod delete, CPU hog, and memory hog still work. For details, see [Check your cluster configuration](chaos-studio-aks-extension-install.md#check-your-cluster-configuration).
- **Azure CLI.** Use version 1.9.5 or later of the `k8s-extension` Azure CLI extension.

### Validated configurations

The following table summarizes the cluster configurations that Microsoft validated with the extension. A configuration that isn't validated might work. Test it on a nonproduction cluster first.

| Configuration | Status | Notes |
| --- | --- | --- |
| AKS Standard with Linux amd64 node pools | Supported | The primary validated configuration. |
| AKS Automatic | Supported with a limitation | Network faults need a Deployment Safeguards exclusion for the extension's namespace. |
| Kubernetes versions 1.35 and 1.36 | Supported | Other versions aren't validated. |
| Azure CNI | Supported | None. |
| Azure CNI Overlay with the Cilium data plane | Validated for pod delete, network latency, and network loss | CPU hog and memory hog aren't validated on this configuration. |
| Istio-based service mesh add-on, revision `asm-1-29`, with strict mutual TLS | Validated for pod delete, network latency, and network loss | CPU hog and memory hog aren't validated on this configuration. Other revisions and other Istio installations aren't validated. |
| Mixed amd64 and arm64 node pools | Supported with a limitation | The cluster needs schedulable Linux amd64 capacity. Target pods on amd64 nodes. |
| Clusters with only arm64 node pools | Not supported | None. |
| Windows node pools | Not supported as fault targets | The faults target Linux pods only. Clusters that mix Linux and Windows node pools aren't validated. |

Node pools with FIPS enabled, private clusters, and kubenet networking aren't validated.

## Known issues

- **Connection status shows Pending.** The Workspace connection status shows `Pending` even when the connection works. Don't use the connection status to decide whether the extension is ready. Check the extension provisioning state and run a short test.
- **Short durations fail.** An Action duration shorter than 1 minute (`PT1M`) fails.
- **Pod delete fails in restricted namespaces.** If a namespace enforces the Pod Security Admission `restricted` level, Kubernetes rejects the pod that runs the pod delete fault. Run pod delete tests in a namespace that doesn't enforce `restricted`.
- **Network faults end early if the helper pod is deleted.** Pod network latency and pod network loss use a helper pod in the cluster. If something deletes that pod during a run, the network effect stops before the fault duration ends. If a network test ends early, check whether something deleted the helper pod before you evaluate the results.
- **A network fault can stay in effect after the run ends.** If a container in a target pod restarts during pod network latency or pod network loss, the extension can't remove the network effect from that pod. The effect stays on the pod after the run ends, and the run can still show **Succeeded**. If a fault makes the pod's liveness probe fail, it can cause this restart. To remove the effect, delete the affected pods so that Kubernetes creates new ones. For a deployment, for example, run `kubectl rollout restart deployment <deployment-name> --namespace <namespace>`, which replaces all pods of the deployment. To make a restart less likely, check that the liveness probes of the target pods tolerate failures for longer than the fault duration.
- **A run that targets another namespace doesn't fail right away.** If a fault targets pods in a namespace that the extension isn't set up for, the run can stay in the **Running** state instead of failing with a clear error. Later runs on the same cluster can also fail. Cancel the run. If later runs still fail, see [Get help](chaos-studio-aks-extension-troubleshoot.md#get-help).
- **Run status can differ from the effect in the cluster.** The Scenario run status might not match what happened in the cluster. For example, a run can show **Succeeded** while a network fault is still in effect on a pod. A run can also stay in the **Running** state. Check Kubernetes events and your application metrics to confirm the result. For more information, see [Interpret the results](#interpret-the-results).

## Interpret the results

A completed Action shows the outcome that Chaos Studio recorded for the fault. It doesn't show that the fault had the effect you intended, or that your application recovered. Compare these sources of evidence:

| Evidence | What it tells you |
| --- | --- |
| The [Scenario report](chaos-studio-scenario-reports.md) | When the Action ran, and its reported status. The status can differ from the effect in the cluster. |
| Kubernetes events and pod status | Which pods the fault affected, and how Kubernetes responded. |
| Application metrics and test traffic | Whether users could still complete their tasks. |
| Data checks | Whether the application kept the work it acknowledged. |

If the fault didn't affect the pods that handled your test traffic, the run doesn't answer your question. Record the result as inconclusive, not as a pass.

## Choose between Workspaces and Experiments (classic)

The extension works only with Workspaces. For a comparison of the two resource models, see [Choose between Chaos Studio Workspaces and Experiments (classic)](chaos-studio-workspaces-vs-experiments.md). To move existing tests, see [Move from Experiments (classic) to Chaos Studio Workspaces](chaos-studio-migrate-from-classic.md).

## Related content

- [Install the Chaos Studio extension for AKS and run a pod fault](chaos-studio-aks-extension-install.md)
- [Troubleshoot the Chaos Studio extension for AKS](chaos-studio-aks-extension-troubleshoot.md)
- [Permissions and identity in Chaos Studio Workspaces](chaos-studio-workspace-permissions.md)
- [Scenario reports in Chaos Studio Workspaces](chaos-studio-scenario-reports.md)
