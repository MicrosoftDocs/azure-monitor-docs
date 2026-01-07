---
title: Azure Monitor pipeline pod placement
description: Configuration of Azure Monitor pipeline for edge and multicloud scenarios
ms.topic: article
ms.date: 05/21/2025
ms.custom: references_regions, devx-track-azurecli
---

# Azure Monitor pipeline pod placement guide

Azure Monitor pipeline provides native controls for managing how your Azure Monitor pipeline instances are scheduled across Kubernetes cluster nodes. The executionPlacement configuration allows you to:

- Target specific nodes based on their capabilities (e.g., high-resource nodes, specific zones)
- Control instance distribution to prevent resource contention
- Enforce isolation policies for high-scale deployments

This feature is designed to be platform-agnostic, meaning the configuration model remains consistent regardless of the underlying infrastructure (Kubernetes, VMs, etc.).

## When to Use Pod Placement 

Consider using executionPlacement configuration if you need to:

- **Ensure performance isolation** in multi-tenant clusters where multiple teams share infrastructure
- **Target high-capacity nodes** for resource-intensive telemetry workloads
- **Prevent port exhaustion** by limiting the number of instances per node
- **Enforce compliance requirements** such as data residency or security zones
- **Optimize resource utilization** by distributing instances across availability zones

## Configuration Model 

## Top-Level Structure 

Add the executionPlacement property to your PipelineGroup resource properties:

```json
{
    "properties": {
    "executionPlacement": {
        "constraints": \[**...**\],
        "distribution": {**...**}
        }
    } 
}
```

## Field Definitions 

### executionPlacement

**Type:** Object (optional)

Top-level configuration object for placement preferences. When omitted, default Kubernetes scheduling behavior applies.

### constraints

**Type:** Array of PlacementConstraint objects (optional)

A list of placement constraints that define **where** your pipeline instances should run. All constraints are required - instances will only be scheduled on nodes that satisfy **all** specified constraints.

**PlacementConstraint Properties:**

| Property | Type | Required | Description |
|:---|:---|:---|:---|
| capability | string | Yes | The node attribute/label to match (e.g., zone, gpu, team, pipeline) |
| operator | string | Yes | Matching logic: In, NotIn, Exists, DoesNotExist |
| values | array of strings | Conditional | Values to match for the capability. Required for In and NotIn, not used for Exists and DoesNotExist. |

 **Supported Operators:**

- **In**: Node must have the capability with one of the specified values. **Requires** values array with at least one value.
- **NotIn**: Node must not have the capability with any of the specified values. **Requires** values array with at least one value.
- **Exists**: Node must have the capability (any value). **Does not use** values field - omit it or leave empty.
- **DoesNotExist**: Node must not have the capability. **Does not use** values field - omit it or leave empty.

## Validation Rules 

To ensure proper configuration, the following validation rules apply:

## Constraint Validation 

- **capability** field is required and must be a non-empty string
- **operator** field is required and must be one of: In, NotIn, Exists, DoesNotExist 
- **values** field requirements depend on the operator:
    - **Required for In and NotIn**: Must provide a non-empty array of strings o **Not allowed for Exists and DoesNotExist**: Must be omitted or empty
- Invalid operator/values combinations will result in configuration errors 
 
## Distribution Validation

- **maxInstancesPerHost** must be a positive integer
- Currently only 1 is supported for strict isolation
- Other values will be rejected during configuration 
 
**Example Invalid Configurations:**

```json
// INVALID: Using "Exists" with values
{
    "capability": "gpu",
    "operator": "Exists",
    "values": ["nvidia"] // ERROR: Exists operator does not accept values 
}

// INVALID: Using "In" without values 
{ 
    "capability": "zone", 
    "operator": "In"  // ERROR: In operator requires values array 
} 
 
// INVALID: Unsupported maxInstancesPerHost value 
{ 
    "distribution": { 
    "maxInstancesPerHost": 2  // ERROR: Currently only 1 is supported   } 
} 
```

### distribution

**Type:** Object (optional)

Distribution policy for controlling how many instances can run per node.

**DistributionPolicy Properties:**

| Property | Type | Required | Description |
|:---|:---|:---|:---|
| maxInstancesPerHost | integer | No | Maximum instances per node for this specific pipelineGroup. Currently supports 1 (strict isolation) or unset (no limit). |


## Important Behaviors 

### Per-PipelineGroup Scoping 

The `maxInstancesPerHost` constraint applies only to replicas of the same pipelineGroup:

- Different pipelineGroups **can** share the same node
- Multiple replicas of the **same** pipelineGroup cannot share a node (when maxInstancesPerHost: 1) 

**Example:**

Node capacity: Can host multiple pods

PipelineGroup A: maxInstancesPerHost: 1, replicas: 3
PipelineGroup B: maxInstancesPerHost: 1, replicas: 3

Valid placement:
    Node 1: PipelineGroupA-replica1 + PipelineGroupB-replica1
    Node 2: PipelineGroupA-replica2 + PipelineGroupB-replica2
    Node 3: PipelineGroupA-replica3 + PipelineGroupB-replica3

Invalid placement (violates constraint):
    Node 1: PipelineGroupA-replica1 + PipelineGroupA-replica2 
    
Scheduling Enforcement

- **Placement constraints are enforced at deployment time** - rules apply when you create or update your PipelineGroup resource
- **Constraint violations prevent successful deployment** - if placement requirements cannot be satisfied, your PipelineGroup instances will not deploy and will remain in a pending state
- **Configuration changes trigger redeployment** - updates to executionPlacement settings in your PipelineGroup will redeploy instances with the new constraints

## Automatic Pod Labeling 

The operator automatically applies a pipeline label to all pods with the value set to the pipelineGroup name. This label is used internally for anti-affinity enforcement when maxInstancesPerHost: 1 is configured. You don’t need to manually label pods - this is handled automatically.

## Configuration Examples 

### Example 1: Default Scheduling 

No configuration needed - instances use default Kubernetes scheduling:

```json
{
    "properties": {
    // No executionPlacement configuration
    } 
}
```

**Behavior:**

- Scheduler uses default node selection
- Multiple instances can be scheduled on the same node

### Example 2: Node Labeling for Team Isolation 

Target nodes dedicated to your observability team to avoid noisy neighbor issues:

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

**Behavior:**

- Only nodes labeled team=observability-team are eligible
- Multiple instances can run on the same dedicated node **Kubernetes Requirement:**

Label your nodes with:

`kubectl label nodes <node-name> team=observability-team`

### Example 3: Zone-Based Placement 

Ensure your pipeline runs only in specific availability zones:

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

**Behavior:**

- Only nodes in zones us-east-1a or us-east-1b are eligible
- Helps meet data residency or compliance requirements

### Example 4: Strict Isolation with Node Labeling (Recommended for High-Scale) 

Combine node targeting with strict isolation - exactly one instance per node:

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

**Behavior:**

- Only nodes labeled with workload-type=telemetry-processing are eligible
- Exactly one instance per eligible node (strict isolation)
- Prevents port conflicts and ensures resource isolation
- Pods remain unscheduled if constraints cannot be satisfied **Kubernetes Requirement:**

Label your nodes with: 

`kubectl label nodes \<node-name\> workload-type=telemetry-processing`

**Note:** The operator automatically applies the pipeline label to pods for anti-affinity enforcement - you only need to label nodes with your custom constraint labels.

**Use Cases:**

- High-throughput environments requiring dedicated resources
- Preventing node port exhaustion
- Ensuring predictable performance per instance

## Example 5: High-Resource Node Targeting 

Target nodes with high CPU and memory capacity for resource-intensive telemetry processing:

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

**Behavior:**

- Only nodes with specified high-capacity instance types are eligible
- Ensures sufficient resources for high-throughput telemetry workloads

### Example 6: Multiple Constraints 

Combine multiple constraints - all must be satisfied:

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


**Behavior:**

- Nodes must be labeled for the observability team **AND**
- Nodes must be in specified zones **AND**
- Nodes must not have GPU accelerators **AND**
- Maximum one instance per eligible node

## Troubleshooting 

### Pods Not Scheduling 

If your pipeline instances remain in a Pending state:

1.  **Check node availability:** kubectl get nodes --show-labels

Verify that nodes exist with the required labels from your constraints configuration.

2.  **Check pod events:** kubectl describe pod \<pod-name\>

Look for scheduling failure messages indicating unmet constraints.

3.  **Verify constraint configuration:**

    - Ensure capability names match actual node labels.
    - Confirm operator and values are correct.
    - Check for typos in label names or values

4.  **Check anti-affinity conflicts:**

If using maxInstancesPerHost: 1, ensure you have enough eligible nodes for all replicas:

```
# Count eligible nodes
kubectl get nodes -l \<your-label-selector\>
```

You need at least as many eligible nodes as your replica count.

## Common Issues 

**Issue:** Pods stuck in Pending state with message “0/N nodes are available”

**Solution:** The cluster doesn’t have enough nodes matching your placement constraints. Either:

- Add more nodes with the required labels
- Adjust your constraints to be less restrictive
- Manually reduce the replicas count in your PipelineGroup configuration

**Issue:** Configuration changes not applied

**Solution:** executionPlacement changes require a rolling restart. Check that:

- The PipelineGroup resource was successfully updated
- The operator is running and processing changes
- Review operator logs for any errors

**Issue:** Multiple replicas on same node despite maxInstancesPerHost: 1

**Solution:** This setting only applies **within a pipelineGroup**. If you see multiple pods:

- Check if they belong to different pipelineGroups (this is expected behavior)
- Verify the pipeline label is correctly applied to pods
- Review pod anti-affinity rules in the StatefulSet spec

## Kubernetes Implementation Details 

For advanced users and debugging, here’s how `executionPlacement` translates to Kubernetes:

### Node Affinity (constraints) 

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

## Pod Anti-Affinity (maxInstancesPerHost: 1) 

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

This ensures pods with the same pipeline label value (i.e., replicas of the same pipelineGroup) cannot be scheduled on the same node.

## Limitations 

- **Binary distribution control:** maxInstancesPerHost currently supports only 1 (strict isolation) or unset (no limit)
- **No automatic node provisioning:** The system doesn’t automatically add nodes if constraints cannot be satisfied
- **Kubernetes-specific implementation:** While the API is platform-agnostic, current implementation is Kubernetes-only



## Next steps

* [Read more about data collection rules (DCRs) in Azure Monitor](data-collection-rule-overview.md).
