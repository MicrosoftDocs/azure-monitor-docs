---
title: Azure Monitor pipeline pod placement
description: Inspect Azure Monitor pipeline pod placement and troubleshoot Kubernetes scheduling issues.
ai-usage: ai-assisted
ms.topic: article
ms.date: 10/23/2026
ms.custom: references_regions, devx-track-azurecli
---

# Azure Monitor pipeline pod placement

Kubernetes schedules the pods for your [Azure Monitor pipeline instances](./pipeline-overview.md) across the available cluster nodes. Use this article to configure collector placement, check node capacity, and troubleshoot scheduling issues.

> [!NOTE]
> For configuration details for earlier deployments, see [Legacy pod placement](./pipeline-configure-legacy.md#legacy-placement).

## When to use pod placement

Review pod placement for the following requirements:

- **Ensure performance isolation** in multitenant clusters where multiple teams share infrastructure.
- **Target high-capacity nodes** for resource-intensive telemetry workloads.
- **Prevent port exhaustion** by limiting the number of instances per node.
- **Enforce compliance requirements** such as data residency or security zones.
- **Optimize resource utilization** by distributing instances across availability zones.

## Plan node capacity

Before deploying or scaling a pipeline:

- Ensure eligible nodes have enough CPU and memory for the pipeline workloads.
- Check that node labels, taints, and availability zones match the workload's scheduling requirements.
- Allow enough nodes for the replica count and any pod anti-affinity rules.
- Confirm that persistent volumes are accessible from the nodes where pods can run.
- Leave capacity for rolling updates and temporary node failures.

For capacity guidance, see [Size Azure Monitor pipeline](./pipeline-sizing.md). For Kubernetes scheduling concepts, see [Assigning pods to nodes](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/).

## Configure collector placement

Execution placement requires pipeline extension version **0.1.4 or later**. Confirm that the version is registered for your extension type, region, and release train. These settings control collector pods, not the controller Deployment.

For example, label at least two schedulable nodes that have sufficient CPU and memory for two collector replicas:

```bash
kubectl label nodes <node-a> <node-b> workload-type=telemetry
kubectl get nodes --selector workload-type=telemetry --label-columns workload-type,kubernetes.io/hostname
```

In the [CLI ARM template](./pipeline-configure-cli.md#deploy-the-arm-template), the `extensionConfigurationSettings` parameter maps to the extension's `properties.configurationSettings`. Merge these entries into the parameters file's `parameters` object, preserving other required extension settings:

```json
{
  "extensionVersion": {
    "value": "0.1.4"
  },
  "extensionConfigurationSettings": {
    "value": {
      "controllerManager.manager.env.pipelineReplicas": "2",
      "controllerManager.manager.env.pipelineExecutionPlacement.constraints[0].capability": "workload-type",
      "controllerManager.manager.env.pipelineExecutionPlacement.constraints[0].operator": "In",
      "controllerManager.manager.env.pipelineExecutionPlacement.constraints[0].values[0]": "telemetry",
      "controllerManager.manager.env.pipelineExecutionPlacement.distribution.maxInstancesPerHost": "1"
    }
  }
}
```

Review and redeploy the complete ARM template. Don't add placement or replica count to either DCR. Use flat indexed setting names with string values as shown, not an entire JSON placement object encoded as a string. Arc passes these settings through Helm's value parser to build the structured placement value.

The `capability` value is a Kubernetes node-label key. All constraints must match:

- `In` and `NotIn` require a nonempty `values` array.
- `Exists` and `DoesNotExist` test for the label key; omit `values`.
- `distribution.maxInstancesPerHost` supports only `1`. It creates required pod anti-affinity between collectors in the same extension instance, using `kubernetes.io/hostname`.

Set `pipelineReplicas` separately; placement doesn't increase the replica count. The example requires two eligible hosts because its two collectors can't share a host. Without enough eligible nodes that meet the constraints and have sufficient CPU and memory, a collector remains `Pending`. Placement doesn't add nodes or tolerations, or change volume access modes or topology.

When updating an existing configuration, review all indexed constraints and values. Updating index `0` doesn't remove additional entries. Manage an Arc extension through Arc or its ARM template, not through direct Helm upgrades or StatefulSet patches. For persistent buffering across hosts, also satisfy the [persistent storage prerequisites](./pipeline-configure-cli.md#configure-persistent-storage).

## Inspect current placement

List the pipeline pods and the nodes that host them:

```bash
kubectl get pods --namespace <pipeline-namespace> -o wide
```

Inspect node labels and available resources:

```bash
kubectl get nodes --show-labels
kubectl describe node <node-name>
```

Inspect a pod's scheduling requirements and events:

```bash
kubectl describe pod <pod-name> --namespace <pipeline-namespace>
kubectl get pod <pod-name> --namespace <pipeline-namespace> -o yaml
```

Review `nodeSelector`, affinity, tolerations, and resource requests in the pod specification. Compare these requirements with the labels, taints, and available capacity of the cluster's nodes.

For the preceding example, require two ready collector replicas on different nodes labeled `workload-type=telemetry`. Inspect the collector StatefulSet for required node affinity and required pod anti-affinity by using `kubernetes.io/hostname`. Also, read the Arc extension's version and persisted `configurationSettings` to confirm that the intended settings were applied.

<a id="troubleshooting"></a>

## Troubleshoot pending pods

A pod stays `Pending` when Kubernetes can't find a node that meets its scheduling and resource requirements. Check the pod's events for the specific cause.

| Scheduling issue | Action |
|:---|:---|
| Insufficient CPU or memory. | Add node capacity or reduce competing workloads. |
| No nodes match a selector or node affinity rule. | Verify node labels and confirm that eligible nodes are available. |
| A node has an untolerated taint. | Review the node's intended workload and the pod's tolerations. |
| Pod anti-affinity prevents placement. | Ensure enough eligible nodes are available for the replicas. |
| A volume can't be attached or mounted. | Check persistent volume claims, storage availability, and volume topology restrictions. |

After correcting the cause, confirm that the pod reaches `Running` and that telemetry reaches the destination workspace.

## Verify placement after changes

After a cluster upgrade, node replacement, or pipeline update:

1. List pipeline pods and confirm that they run on the expected nodes.
1. Check for pending pods or repeated scheduling failures.
1. Review CPU, memory, and storage utilization.
1. Verify end-to-end data delivery.

## Related articles

- Learn about the service in [What is Azure Monitor pipeline?](./pipeline-overview.md)
- Set up the service in [Configure Azure Monitor pipeline](./pipeline-configure.md)
- Configure the pipeline by using [Configure Azure Monitor pipeline with CLI or ARM templates](./pipeline-configure-cli.md)
