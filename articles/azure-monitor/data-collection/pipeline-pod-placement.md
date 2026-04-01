---
title: Azure Monitor pipeline pod placement
description: Manage how Azure Monitor pipeline instances are scheduled across Kubernetes cluster nodes by configuring pod placement.
ms.topic: article
ms.date: 01/15/2026
ms.custom: references_regions, devx-track-azurecli
---

# Azure Monitor pipeline pod placement

As Azure Monitor pipeline scales, default scheduling behavior in your Kubernetes environment might not meet your performance, isolation, or compliance needs. Pod placement helps you manage how your [Azure Monitor pipeline instances](./pipeline-overview.md) are scheduled across Kubernetes cluster nodes. This feature helps you target specific nodes based on their capabilities, control instance distribution to prevent resource contention, and enforce isolation policies for high-scale deployments.

## When to use pod placement

Consider using pod placement configuration for the following capabilities:

- **Ensure performance isolation** in multitenant clusters where multiple teams share infrastructure.
- **Target high-capacity nodes** for resource-intensive telemetry workloads.
- **Prevent port exhaustion** by limiting the number of instances per node.
- **Enforce compliance requirements** such as data residency or security zones.
- **Optimize resource utilization** by distributing instances across availability zones.

## Configuration
You can currently configure pod placement only by using ARM or Bicep templates, either when creating a new pipeline group or editing an existing one. Add the `executionPlacement` property to your `pipelineGroups` resource properties by using the following structure. If you omit the `executionPlacement` property from the configuration, default Kubernetes scheduling behavior applies. The next section describes the details for each field.

```json
{
    "properties": {
    "executionPlacement": {
        "constraints": [...],
        "distribution": {...}
        }
    } 
}
```

### constraints

The `constraints` field contains a list of objects that define where your pipeline instances should run. The scheduler only schedules instances on nodes that satisfy all specified constraints. Each constraint consists of the properties in the following table.


| Property | Type | Required | Description |
|:---|:---|:---|:---|
| `capability` | string | Yes | The node attribute or label to match. Examples include `zone`, `gpu`, `team`, `pipeline`. |
| `operator` | string | Yes | Matching logic with the following allowed values:<br><br>- `In`:<br>Node must have the capability with one of the specified values.<br>- `NotIn`:<br>Node must not have the capability with any of the specified values.<br>- `Exists`:<br>Node must have any value in the capability. The `values` property isn't used.<br>- `DoesNotExist`:<br>Node must not have the capability. The `values` property isn't used.|
| `values` | array of strings | Conditional | Values to match for the capability. Not used for `Exists` and `DoesNotExist`. |


### distribution

The `distribution` field contains the distribution policy for controlling how many instances can run per node. The distribution consists of the properties in the following table.

| Property | Type | Required | Description |
|:---|:---|:---|:---|
| `maxInstancesPerHost` | integer | No | Maximum instances per node for this specific pipelineGroup. The only currently allowed value is `1` which indicates strict isolation. If you don't specify a value, there's no limit per host. |

The maximum instances per node applies only to replicas of the same pipeline group. Different pipelineGroups can share the same node.

    
## Deployment
Execution placement rules are applied immediately when you create or update your pipeline group resource. If placement requirements can't be satisfied, for example due to a bad configuration, your pipeline group instances aren't deployed and remain in a pending state. Updates to execution placement settings redeploy instances of your pipeline group with the new constraints.

## Automatic pod labeling

A pipeline label is automatically added to all pods with the value set to the `pipelineGroup` name. This label is used internally for anti-affinity enforcement when `maxInstancesPerHost: 1` is configured. You don't need to manually label pods since this process is handled automatically.

## Configuration examples

### Default scheduling

No configuration required. Instances use default Kubernetes scheduling.

- Scheduler uses default node selection
- Multiple instances can be scheduled on the same node

```json
{
    "properties": {
    // No executionPlacement configuration
    } 
}
```

### Node labeling for team isolation

Target nodes dedicated to your observability team to avoid noisy neighbor problems. You can run multiple instances on the same dedicated node. In the following example, only nodes labeled `team=observability-team` are eligible. Set the label of your choice on your nodes by using the following command:

```azurecli
kubectl label nodes <node-name> <key>=<value>
```

```json
{
    "properties": {
        "executionPlacement": {
            "constraints": [
                {
                "capability": "team",
                "operator": "In",
                "values": ["observability-team"]
                }
            ]
        }
    } 
}
```


### Zone-based placement

Ensure your pipeline runs only in specific availability zones. This restriction helps you meet data residency or compliance requirements. In the following example, only nodes in zones `us-east-1a` or `us-east-1b` are eligible.

```json
{
    "properties": {
        "executionPlacement": {
            "constraints": [
                {
                "capability": "topology.kubernetes.io/zone",
                "operator": "In",
                "values": ["us-east-1a", "us-east-1b"]
                }
            ]
        }
    } 
}
```

### Strict isolation with node labeling

Combine node targeting with strict isolation. This approach allows exactly one instance per node, which is recommended for high-scale environments. It prevents port conflicts and ensures resource isolation. In the following example, only nodes labeled `workload-type=telemetry-processing` are eligible. Set the label of your choice on your nodes by using the following command:

```azurecli
kubectl label nodes <node-name> <key>=<value>
```


This strategy is recommended for the following use cases:

- High-throughput environments that require dedicated resources.
- Preventing node port exhaustion.
- Ensuring predictable performance per instance.

> [!NOTE]
> The pipeline label is automatically applied to pods for anti-affinity enforcement. You only need to label nodes with your custom constraint labels.


```json
{
    "properties": {
        "executionPlacement": {
            "constraints": [
                {
                    "capability": "workload-type",
                    "operator": "In",
                    "values": ["telemetry-processing"]
                }
            ],
            "distribution": {
                "maxInstancesPerHost": 1
            }
        }
    } 
}
```


### High-resource node targeting

Target nodes with high CPU and memory capacity for resource-intensive telemetry processing.

- Only nodes with specified high-capacity instance types are eligible.
- Ensures sufficient resources for high-throughput telemetry workloads.

```json
{
    "properties": {
        "executionPlacement": {
            "constraints": [
                {
                    "capability": "node.kubernetes.io/instance-type",
                    "operator": "In",
                    "values": ["Standard_D16s_v3", "Standard_D32s_v3"]
                }
            ]
        }
    } 
}
```


### Multiple constraints

Combine multiple constraints. All constraints must be satisfied for a node to be eligible.

- Nodes must be labeled for the observability team.
- Nodes must be in specified zones.
- Nodes must not have GPU accelerators.
- Maximum one instance per eligible node.

```json
{
    "properties": {
        "executionPlacement": {
            "constraints": [
                {
                    "capability": "team",
                    "operator": "In",
                    "values": ["observability-team"]
                },
                {
                    "capability": "topology.kubernetes.io/zone",
                    "operator": "In",
                    "values": ["us-east-1a", "us-east-1b"]
                },
                {
                    "capability": "accelerator",
                    "operator": "DoesNotExist"
                }
            ],
            "distribution": {
                "maxInstancesPerHost": 1
            }
        }
    }
}
```



## Troubleshooting

To identify problems when your pipeline instances stay in a pending state, try the following steps:

1.  Check node availability by running `kubectl get nodes --show-labels`. Make sure nodes have the labels required by your constraints configuration.

2.  Check pod events by running `kubectl describe pod <pod-name>`. Look for scheduling failure messages that show unmet constraints.

3.  Verify constraint configuration:

    - Make sure capability names match actual node labels.
    - Confirm operator and values are correct.
    - Check for typos in label names or values.

4.  If you use `maxInstancesPerHost: 1`, make sure you have enough eligible nodes for all replicas. You need at least as many eligible nodes as your replica count. Run `kubectl get nodes -l <your-label-selector>` to count eligible nodes:


## Common issues

**Pods stuck in Pending state with message "0/N nodes are available"**
The cluster doesn't have enough nodes that match your placement constraints. Fix this problem by using one of the following solutions:

- Add more nodes with the required labels.
- Adjust your constraints to be less restrictive.
- Manually reduce the replicas count in your pipeline group configuration.

**Configuration changes not applied**

Execution placement changes require a rolling restart. Check the following items:

- The pipeline group resource was successfully updated.
- The operator is running and processing changes.
- Review operator logs for any errors.

**Multiple replicas on same node despite `maxInstancesPerHost: 1`**

This setting only applies within a pipeline group. 

- Check if the pods belong to different pipeline groups.
- Verify the pipeline label is correctly applied to pods.
- Review pod anti-affinity rules in the `StatefulSet` spec.

## Kubernetes implementation details

For advanced users and debugging, the following sections describe the affinity and anti-affinity rules in the [pod spec](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/) that result from pod placement.

**Node Affinity (constraints)**

The `constraints` property defines node affinity. Each constraint maps to a node affinity rule in the pod spec.

```yaml
affinity:
    nodeAffinity:
        requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
                - key: <capability>
                  operator: <In|NotIn|Exists|DoesNotExist>
                    values: [<values>]
```

**Pod Anti-Affinity**

The `maxInstancesPerHost` property defines pod anti-affinity. This property ensures that pods with the same pipeline label value, which are replicas of the same pipelineGroup, aren't scheduled on the same node.

```yaml
affinity:
    podAntiAffinity:
        requiredDuringSchedulingIgnoredDuringExecution:
        - labelSelector:
            matchExpressions:
            - key: pipeline
              operator: In
              values:
              - <pipelineGroupName>
          topologyKey: "kubernetes.io/hostname"
```





## Related articles

- Learn about the service in [What is Azure Monitor pipeline?](./pipeline-overview.md)
- Set up the service in [Configure Azure Monitor pipeline](./pipeline-configure.md)
- Configure the pipeline by using [Configure Azure Monitor pipeline with CLI or ARM templates](./pipeline-configure-cli.md)
