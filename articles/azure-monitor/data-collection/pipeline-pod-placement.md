---
title: Azure Monitor pipeline pod placement
description: Manage how Azure Monitor pipeline instances are scheduled across Kubernetes cluster nodes by configuring pod placement.
ms.topic: article
ms.date: 01/15/2026
ms.custom: references_regions, devx-track-azurecli
---

# Azure Monitor pipeline pod placement

Pod placement allows you to manage how your [Azure Monitor pipeline instances](./pipeline-overview.md) are scheduled across Kubernetes cluster nodes. This feature allows you to target specific nodes based on their capabilities, control instance distribution to prevent resource contention, and enforce isolation policies for high-scale deployments.

## When to Use Pod Placement 

Consider using pod placement configuration for the following capabilities:

- **Ensure performance isolation** in multi-tenant clusters where multiple teams share infrastructure.
- **Target high-capacity nodes** for resource-intensive telemetry workloads.
- **Prevent port exhaustion** by limiting the number of instances per node.
- **Enforce compliance requirements** such as data residency or security zones.
- **Optimize resource utilization** by distributing instances across availability zones.

## Configuration
Pod placement can currently only be configured using ARM/Bicep templates, either when creating a new pipeline group or editing an existing one. Add the `executionPlacement` property to your `pipelineGroups` resource properties using the following structure. If the `executionPlacement` property is omitted from the configuration, then default Kubernetes scheduling behavior applies. The details for each field are described in the next section.

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

The `constraints` field contains a list of objects that define where your pipeline instances should run. Instances will only be scheduled on nodes that satisfy all specified constraints. Each constraint consists of the properties in the following table.


| Property | Type | Required | Description |
|:---|:---|:---|:---|
| `capability` | string | Yes | The node attribute or label to match. Examples include `zone`, `gpu`, `team`, `pipeline`. |
| `operator` | string | Yes | Matching logic with the following allowed values:<br><br>- `In`:<br>Node must have the capability with one of the specified values.<br>- `NotIn`:<br>Node must not have the capability with any of the specified values.<br>- `ExiFsts`:<br>Node must have any value in the capability. The `values` property isn't used.<br>- `DoesNotExist`:<br>Node must not have the capability. The `values` property isn't used.|
| `values` | array of strings | Conditional | Values to match for the capability. Not used for `Exists` and `DoesNotExist`. |


### distribution

The `distribution` field contains the distribution policy for controlling how many instances can run per node. The distribution consists of the properties in the following table.

| Property | Type | Required | Description |
|:---|:---|:---|:---|
| `maxInstancesPerHost` | integer | No | Maximum instances per node for this specific pipelineGroup. The only currently allowed value is `1` which indicates strict isolation. If no value is specified, then there's no limit per host. |

The maximum instances per node applies only to replicas of the same pipeline group. Different pipelineGroups can share the same node.

    
## Deployment
Execution placement rules are applied immediately when you create or update your pipeline group resource. If placement requirements cannot be satisfied, for example due to a bad configuration, your pipeline group instances will not deploy and will remain in a pending state. Updates to execution placement settings will redeploy instances of your pipeline group with the new constraints.

## Automatic pod labeling 

A pipeline label is automatically added to all pods with the value set to the `pipelineGroup` name. This label is used internally for anti-affinity enforcement when `maxInstancesPerHost: 1` is configured. You don’t need to manually label pods since this is handled automatically.

## Configuration Examples 

### Default Scheduling 

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

Target nodes dedicated to your observability team to avoid noisy neighbor issues.

- Only nodes labeled `team=observability-team` are eligible.
- Multiple instances can run on the same dedicated node.
- Label your nodes with the following command:
  - `kubectl label nodes <node-name> team=observability-team`

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

Ensure your pipeline runs only in specific availability zones.

- Only nodes in zones `us-east-1a` or `us-east-1b` are eligible.
- Helps meet data residency or compliance requirements.

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

Combine node targeting with strict isolation. Allows exactly one instance per node which is recommended for high scale environments.

- Only nodes labeled with `workload-type=telemetry-processing` are eligible.
- Strict isolation, exactly one instance per eligible node.
- Prevents port conflicts and ensures resource isolation.
- Pods remain unscheduled if constraints cannot be satisfied.
- Label your nodes with the following command:
  - `kubectl label nodes \<node-name\> workload-type=telemetry-processing`


This strategy is recommended for the following use cases:

- High-throughput environments requiring dedicated resources.
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

Perform the following steps to identify and issues if your pipeline instances remain in a pending state.

1.  Check node availability with the command `kubectl get nodes --show-labels`. Verify that nodes exist with the required labels from your constraints configuration.

2.  Check pod events with the command `kubectl describe pod <pod-name>`. Look for scheduling failure messages indicating unmet constraints.

3.  Verify constraint configuration:

    - Ensure capability names match actual node labels.
    - Confirm operator and values are correct.
    - Check for typos in label names or values.

4.  If using `maxInstancesPerHost: 1`, ensure you have enough eligible nodes for all replicas. You need at least as many eligible nodes as your replica count. Use the command `kubectl get nodes -l <your-label-selector>` to count eligible nodes:


## Common Issues 

**Pods stuck in Pending state with message "0/N nodes are available"**
The cluster doesn’t have enough nodes matching your placement constraints. Correct with one of the following actions.

- Add more nodes with the required labels.
- Adjust your constraints to be less restrictive.
- Manually reduce the replicas count in your pipeline group configuration.

**Configuration changes not applied**

Execution placement changes require a rolling restart. Check the following.

- The pipeline group resource was successfully updated.
- The operator is running and processing changes.
- Review operator logs for any errors.

**Multiple replicas on same node despite `maxInstancesPerHost: 1`**

This setting only applies within a pipeline group. 

- Check if the pods belong to different pipeline groups.
- Verify the pipeline label is correctly applied to pods.
- Review pod anti-affinity rules in the `StatefulSet` spec.

## Kubernetes Implementation Details 

For advanced users and debugging, following are the affinity and anti-affinity rules in the [pod spec](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/) resulting from pod placement.

**Node Affinity (constraints)**

Defined by `constraints`. Each constraint maps to a node affinity rule in the pod spec.

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

Defined by `maxInstancesPerHost`. This ensures pods with the same pipeline label value, which are replicas of the same pipelineGroup, cannot be scheduled on the same node.

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





## Next steps

* [Read more about data collection rules (DCRs) in Azure Monitor](data-collection-rule-overview.md).
