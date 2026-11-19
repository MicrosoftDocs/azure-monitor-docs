---
title: Install the Chaos Studio extension for AKS (preview)
description: Install the Chaos Studio extension for AKS, choose workload namespaces, verify the installation, run a pod fault from a Workspace Scenario, and remove it.
author: nikhilkaul-msft
ms.author: nikhilkaul
ms.service: azure-chaos-studio
ms.topic: how-to
ms.date: 11/19/2026
ai-usage: ai-assisted
---

# Install the Chaos Studio extension for AKS (preview) and run a pod fault

[!INCLUDE [chaos-studio-aks-extension-preview](includes/chaos-studio-aks-extension-preview.md)]

This article shows you how to install the [Chaos Studio extension for Azure Kubernetes Service (AKS)](chaos-studio-aks-extension-overview.md) on a cluster, connect it to a Workspace, and run a pod fault. You check the prerequisites and permissions, install and verify the extension, create a Scenario that deletes pods, and run it.

## Prerequisites

- A [Chaos Studio Workspace](quickstart-create-workspace.md) that has a managed identity. Use a system-assigned identity or exactly one user-assigned identity, not both. The Workspace scope must include the AKS cluster resource, and the Workspace identity needs the Reader role on that scope. For more information, see [Permissions and identity in Chaos Studio Workspaces](chaos-studio-workspace-permissions.md).
- An AKS cluster with [Microsoft Entra Workload ID](/azure/aks/workload-identity-overview), the [OpenID Connect (OIDC) issuer](/azure/aks/use-oidc-issuer), and [Azure role-based access control (RBAC) for Kubernetes authorization](/azure/aks/entra-id-authorization) turned on. Installation checks these features.
- Version 1.9.5 or later of the `k8s-extension` Azure CLI extension.
- `kubectl` and [kubelogin](/azure/aks/kubelogin-authentication). Installation uses kubelogin to read namespaces in the cluster. To install both tools, run `az aks install-cli`.
- The `chaos` Azure CLI extension, to run the example Scenario. To install it, run `az extension add --name chaos`.
- The permissions in [Review the permissions for installation](#review-the-permissions-for-installation). To deploy the example Scenario, you also need permission to create deployments in the resource group of the Workspace.

To install or upgrade the `k8s-extension` Azure CLI extension, run:

```azurecli
az extension add --name k8s-extension --upgrade
```

To check the installed version, run:

```azurecli
az extension show --name k8s-extension --query version --output tsv
```

The command returns `1.9.5` or a later version.

## Review the permissions for installation

You don't assign roles for the extension yourself. Installation creates the resources and the role assignment that the extension needs. To install the extension, you need the permissions in this section.

### What installation creates

| Resource | What installation does |
| --- | --- |
| Subscriber identity | AKS creates a user-assigned managed identity for the extension in the node resource group of the cluster, with a federated identity credential for the extension's service account. The in-cluster component uses this identity. It gets no Azure role assignments. |
| Role assignment | Assigns the built-in role **Chaos Kubernetes Extension Operator** to the Workspace identity at the AKS cluster scope. |
| Cluster extension | Installs the extension in the `chaos-infrastructure` namespace. |
| Workspace connection | Creates a connection between the Workspace and the cluster. The resource type is `Microsoft.Chaos/workspaces/connections`. |

### Role permissions

Installation assigns the built-in role **Chaos Kubernetes Extension Operator** to the Workspace identity. The role definition ID is `681440c1-3630-4424-a530-0305ac721cfd`. You don't create or change this role.

The role contains these permissions:

| Type | Permission |
| --- | --- |
| Action | `Microsoft.KubernetesConfiguration/extensions/read` |
| Action | `Microsoft.ContainerService/managedClusters/read` |
| Action | `Microsoft.ContainerService/deploymentSafeguards/read` |
| Action | `Microsoft.Authorization/*/read` |
| Data action | `Microsoft.ContainerService/managedClusters/serviceaccounts/impersonate/action` |
| Data action | `Microsoft.ContainerService/managedClusters/pods/read` |

The fault runs inside the cluster through the extension.

Versions of the `k8s-extension` Azure CLI extension earlier than 1.9.5 created and assigned a custom role named `Chaos Studio Kubernetes Operator (<subscription-id>)` or `Chaos Studio Kubernetes Operator` instead. If you installed the extension with one of those versions, the installation can still have its custom role.

### Permissions you need to install

| Installation step | Permissions | Scope |
| --- | --- | --- |
| Read the cluster and the Workspace. | `Microsoft.ContainerService/managedClusters/read`, `Microsoft.Chaos/workspaces/read` | Cluster, Workspace |
| Read the Deployment Safeguards configuration. | `Microsoft.ContainerService/deploymentSafeguards/read` | Cluster |
| Read the extension's namespace in the cluster. | `Microsoft.ContainerService/managedClusters/listClusterUserCredential/action` and the data action `Microsoft.ContainerService/managedClusters/namespaces/read` | Cluster |
| Assign the role to the Workspace identity. | `Microsoft.Authorization/roleAssignments/write` | Cluster |
| Install the extension. | `Microsoft.KubernetesConfiguration/extensions/write` | Cluster |
| Connect the Workspace to the cluster. | `Microsoft.Chaos/workspaces/connections/write` | Workspace |

For example, the Owner role on the cluster and the Contributor role on the Workspace include the Azure permissions in the preceding table. The Contributor role on the cluster isn't enough, because it can't assign roles. To read namespaces in the cluster, you also need an Azure RBAC for Kubernetes role, such as Azure Kubernetes Service RBAC Cluster Admin.

To remove the extension, you need the matching delete permissions.

## Check your cluster configuration

Check the following items before you install:

- **Node pools.** The extension runs on Linux amd64 nodes, and its network fault component runs only on Linux amd64 nodes. In a cluster with amd64 and arm64 node pools, pod network latency and pod network loss affect only pods on amd64 nodes. Pod delete can also delete target pods on arm64 nodes. Make sure that your target selection includes only the pods you intend to affect. Clusters with only arm64 node pools aren't supported. Pods on Windows nodes aren't supported as fault targets.
- **Deployment Safeguards.** If [Deployment Safeguards](/azure/aks/deployment-safeguards) enforces policies on the cluster and doesn't exclude the `chaos-infrastructure` namespace, installation shows a warning. It installs the extension without the component that the network faults need. AKS Automatic clusters enforce Deployment Safeguards by default. Pod delete, CPU hog, and memory hog still work. Pod network latency and pod network loss fail with the error `AksLitmusDaemonUnavailable`. To use the network faults, exclude the `chaos-infrastructure` namespace from Deployment Safeguards before you install. This exclusion removes Safeguards protection from that namespace.
- **Pod Security Admission.** If a namespace enforces the Pod Security Admission `restricted` level, Kubernetes rejects the pod that runs the pod delete fault. Use a namespace that doesn't enforce `restricted` for pod delete tests.
- **Liveness probes.** If you plan to use the network faults, check the liveness probes of the target pods. If a container restarts during a network fault, the network effect can stay on the pod after the run ends. For details, see [Known issues](chaos-studio-aks-extension-overview.md#known-issues).
- **Container images.** Pod CPU hog and pod memory hog run commands inside the target container. The image needs a shell and standard utilities such as `awk`. Minimal images that don't include these tools aren't suitable targets.
- **Other configurations.** For the configurations that Microsoft validated, see [Validated configurations](chaos-studio-aks-extension-overview.md#validated-configurations).

## Choose the workload namespaces

The extension runs faults only in the namespaces that you list when you install it. You specify the list in the `experiments.targetNamespaces` configuration setting. If you don't set it, the list contains only the `default` namespace.

Before you install:

1. Decide which namespaces contain the workloads that you plan to test.
1. Make sure that each of those namespaces exists in the cluster.
1. Add one indexed configuration setting for each namespace to the installation command, as the following table shows.

| Configuration setting | Example value |
| --- | --- |
| `experiments.targetNamespaces[0]` | `default` |
| `experiments.targetNamespaces[1]` | `checkout` |

If you set index `[0]` to another namespace, that value replaces `default`. To keep `default` in the list, include it explicitly.

Don't list the `chaos-infrastructure` namespace. The `namespace` parameter of a fault doesn't add a namespace to the list. A run that targets a namespace outside the list can stay in the **Running** state. For details, see [Known issues](chaos-studio-aks-extension-overview.md#known-issues).

To change the list after installation, [remove the extension](#remove-the-extension) and install it again with the new settings.

## Install the extension

1. Sign in with the Azure CLI and select the subscription of the cluster:

    ```azurecli
    az login
    az account set --subscription <aks-subscription-id>
    ```

1. Install the extension. Replace the placeholders with your values:

    ```azurecli
    az k8s-extension create \
      --resource-group <aks-resource-group> \
      --cluster-name <aks-cluster-name> \
      --cluster-type managedClusters \
      --name chaos-studio \
      --extension-type Microsoft.ChaosStudio \
      --release-train dev \
      --configuration-settings chaos-workspace-id=<workspace-resource-id>
    ```

    The Workspace resource ID has this form: `/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Chaos/workspaces/<workspace-name>`.

    To test workloads outside the `default` namespace, add the namespace settings to the same parameter:

    ```azurecli
      --configuration-settings chaos-workspace-id=<workspace-resource-id> "experiments.targetNamespaces[0]=default" "experiments.targetNamespaces[1]=<workload-namespace>"
    ```

A successful command installs the extension, assigns the role to the Workspace identity, and creates the Workspace connection. The command can take several minutes.

> [!TIP]
> If the command prompts you to sign in with a device code, kubelogin is asking for credentials for the cluster. To reuse your Azure CLI sign-in, set the environment variable `AAD_LOGIN_METHOD` to `azurecli` and run the command again.

If the command fails, see [Installation fails](chaos-studio-aks-extension-troubleshoot.md#installation-fails). After you correct the cause, run the same command again. Continue with the next section only after the command succeeds.

## Verify the installation

1. Check the provisioning state of the extension:

    ```azurecli
    az k8s-extension show \
      --resource-group <aks-resource-group> \
      --cluster-name <aks-cluster-name> \
      --cluster-type managedClusters \
      --name chaos-studio \
      --query provisioningState --output tsv
    ```

    The command returns `Succeeded`.

1. Get credentials for the cluster, and check that `kubectl` points to it:

    ```azurecli
    az aks get-credentials --resource-group <aks-resource-group> --name <aks-cluster-name>
    kubectl config current-context
    ```

1. Check the pods of the extension:

    ```bash
    kubectl get pods --namespace chaos-infrastructure
    ```

    Each pod shows `Running`, and all of its containers are ready. The list includes a `chaos-operator` pod, a `chaos-subscriber` pod, and one `chaos-daemon` pod for each Linux amd64 node. The `chaos-daemon` pods are missing if installation skipped the network fault component because of Deployment Safeguards.

The Workspace connection status shows `Pending`. This status is a known issue. It doesn't mean that the connection failed. To confirm that the extension can run a fault, run the pod delete Scenario in the next section on a test workload.

## Run a pod fault

In this section, you create a Scenario that deletes the pods of one deployment, and then you run it. The example deletes the pods that have the label `app=store-front` in the `default` namespace. Use a test workload that you can recover. Before you deploy the example, change the `namespace`, `labelSelector`, and `appKind` values to match your test workload. To check your selection, run `kubectl get pods --namespace <namespace> --selector <label-selector>`.

> [!WARNING]
> Faults can interrupt requests and put application data at risk. Get approval from the owners of the cluster and the workload before you start a run.

### Create the Scenario

Set these properties on a pod fault Action:

- An `externalResource` property that contains the resource ID of the AKS cluster. Pass the ID through a Scenario parameter, as the following example shows.
- Parameters that select the pods: at least `namespace` and `labelSelector`.

Save the following Bicep as a file named `pod-delete.bicep`. It defines the Scenario and one configuration that supplies the cluster ID. For the structure of Scenarios, see [How a custom Scenario is structured](chaos-studio-scenarios.md#how-a-custom-scenario-is-structured).

```bicep
param workspaceName string
param aksClusterId string

resource workspace 'Microsoft.Chaos/workspaces@2026-08-01-preview' existing = {
  name: workspaceName
}

resource podDeleteScenario 'Microsoft.Chaos/workspaces/scenarios@2026-08-01-preview' = {
  parent: workspace
  name: 'aks-pod-delete'
  properties: {
    description: 'Delete the store-front pods and watch Kubernetes replace them.'
    parameters: [
      {
        name: 'aksClusterId'
        type: 'String'
        description: 'Resource ID of the AKS cluster.'
        required: true
      }
    ]
    actions: [
      {
        name: 'deleteStoreFrontPods'
        actionId: 'urn:csci:microsoft:containerservice:poddelete/1.0.0'
        description: 'Delete the store-front pods.'
        duration: 'PT1M'
        externalResource: {
          resourceId: '%%{parameters.aksClusterId}%%'
        }
        parameters: [
          { key: 'namespace', value: 'default' }
          { key: 'labelSelector', value: 'app=store-front' }
          { key: 'appKind', value: 'deployment' }
          { key: 'durationSeconds', value: '60' }
          { key: 'podsAffectedPercentage', value: '100' }
          { key: 'force', value: 'false' }
          { key: 'chaosIntervalSeconds', value: '30' }
        ]
      }
    ]
  }
}

resource podDeleteConfiguration 'Microsoft.Chaos/workspaces/scenarios/configurations@2026-08-01-preview' = {
  parent: podDeleteScenario
  name: 'store-front'
  properties: {
    scenarioId: podDeleteScenario.id
    parameters: [
      { key: 'aksClusterId', value: aksClusterId }
    ]
  }
}
```

If the Workspace is in a different subscription than the cluster, run `az account set --subscription <workspace-subscription-id>` first. Deploy the Bicep file to the Workspace's resource group.

```azurecli
az deployment group create \
  --resource-group <workspace-resource-group> \
  --template-file pod-delete.bicep \
  --parameters workspaceName=<workspace-name> aksClusterId=<aks-cluster-resource-id>
```

### Run the Scenario

1. In a second terminal, watch the target pods. If you changed the example, use the namespace and label selector of your workload:

    ```bash
    kubectl get pods --namespace default --selector app=store-front --watch
    ```

1. Start the run with the `chaos` Azure CLI extension. For more information, see [Manage Chaos Studio Workspaces with the Azure CLI](chaos-studio-manage-cli.md). If the command returns the error `ResourceDiscoveryNotReadyError`, wait for the Workspace to finish its first discovery of the resources in its scope, and then run the command again.

    ```azurecli
    az chaos scenario run start \
      --workspace-name <workspace-name> \
      --resource-group <workspace-resource-group> \
      --scenario-name aks-pod-delete \
      --config-name store-front
    ```

1. In the second terminal, check that Kubernetes terminates the selected pods and creates replacements.

1. After the run ends, open the [Scenario report](chaos-studio-scenario-reports.md). Compare it with what you saw in the cluster and in your application metrics. For more information, see [Interpret the results](chaos-studio-aks-extension-overview.md#interpret-the-results).

If the run fails or doesn't affect the pods, see [Troubleshoot the Chaos Studio extension for AKS](chaos-studio-aks-extension-troubleshoot.md).

## Fault parameters

Set parameters as key and value pairs on the Action. Write every value as a string, for example `'60'`. The Action `duration` and the `durationSeconds` parameter are separate settings. The Action `duration` must be at least 1 minute (`PT1M`). The examples in this article set the Action `duration` to at least the value of `durationSeconds`.

### Parameters for all faults

| Parameter | Required | Description |
| --- | --- | --- |
| `namespace` | Yes | The Kubernetes namespace that contains the target pods. The namespace must be in the list that you set at installation. |
| `labelSelector` | Yes | A label selector that identifies the target pods, for example `app=store-front`. |
| `appKind` | No | The kind of workload that owns the pods: `deployment`, `statefulset`, `daemonset`, `deploymentconfig`, or `rollout`. The default is `deployment`. |
| `durationSeconds` | No | How long the fault runs, from 1 to 3,600 seconds. |
| `podsAffectedPercentage` | No | The percentage of matching pods to affect, from 1 to 100. |

### Pod delete

Action ID: `urn:csci:microsoft:containerservice:poddelete/1.0.0`

| Parameter | Required | Description |
| --- | --- | --- |
| `chaosIntervalSeconds` | No | The delay between successive pod deletions, in seconds. |
| `force` | No | Set to `true` to delete pods with no grace period. Set to `false` to terminate them gracefully. |

### Pod CPU hog

Action ID: `urn:csci:microsoft:containerservice:podcpuhog/1.0.0`

| Parameter | Required | Description |
| --- | --- | --- |
| `cpuCores` | No | The number of CPU cores to load in each target container. |
| `targetContainer` | No | The name of the container to stress in each target pod. The default is the first container of the pod. |

### Pod memory hog

Action ID: `urn:csci:microsoft:containerservice:podmemoryhog/1.0.0`

| Parameter | Required | Description |
| --- | --- | --- |
| `memoryConsumptionMegabytes` | No | The amount of memory to consume in each target container, in megabytes. |
| `targetContainer` | No | The name of the container to stress in each target pod. The default is the first container of the pod. |

### Pod network latency

Action ID: `urn:csci:microsoft:containerservice:podnetworklatency/1.0.0`

| Parameter | Required | Description |
| --- | --- | --- |
| `latencyMilliseconds` | No | The latency to add, in milliseconds. The minimum is 1. The default is 2,000. |
| `jitterMilliseconds` | No | The variation in latency, in milliseconds. The value can't be negative. The default is 0. |
| `networkInterface` | No | The network interface to affect. The default is `eth0`. |
| `sequence` | No | The order in which the fault affects the target pods: `parallel` or `serial`. The default is `parallel`. |
| `targetContainer` | No | The name of a container in each target pod. The default is the first container of the pod. |

### Pod network loss

Action ID: `urn:csci:microsoft:containerservice:podnetworkloss/1.0.0`

| Parameter | Required | Description |
| --- | --- | --- |
| `packetLossPercentage` | No | The percentage of packets to drop, from 1 to 100. The default is 100. |
| `networkInterface` | No | The network interface to affect. The default is `eth0`. |
| `sequence` | No | The order in which the fault affects the target pods: `parallel` or `serial`. The default is `parallel`. |
| `targetContainer` | No | The name of a container in each target pod. The default is the first container of the pod. |

## Plan a controlled test

1. Select a preproduction workload that you can recover. Write down the cluster, namespace, and pods that the fault can affect.
1. State the expected behavior in measurable terms. For example, 99% of checkout requests succeed and every acknowledged order is stored.
1. Select the fault that tests that behavior. Check that your pod selection matches only the pods that you intend to affect.
1. Start test traffic and record normal behavior before the fault.
1. Agree on a stop condition and decide who stops the test.
1. Run the Scenario. Watch the application during the fault and after it ends.
1. Compare the [Scenario report](chaos-studio-scenario-reports.md) with your application metrics and Kubernetes events. A completed Action doesn't prove that the application recovered.

Keep the Scenario, the test traffic configuration, and the results. Run the same test again after you change the application, so you can compare the results.

## Remove the extension

Before you remove the extension, cancel any run that's in progress and check that your workloads recovered.

Remove the extension with the Azure CLI. Don't delete the Helm release, the identities, or the namespace directly.

```azurecli
az k8s-extension delete \
  --resource-group <aks-resource-group> \
  --cluster-name <aks-cluster-name> \
  --cluster-type managedClusters \
  --name chaos-studio
```

The command removes the extension, its Workspace connection, and the role assignment that installation created for the Workspace identity. It keeps the Workspace and the cluster.

The command doesn't delete the `chaos-infrastructure` namespace or the Kubernetes resources that remain in it. Check the cluster before you assume that it's clean.

If an earlier version of the Azure CLI extension created a custom role in the subscription, the command doesn't delete that role definition. Don't delete the custom role while other installations in the subscription use it.

## Related content

- [Chaos Studio extension for AKS overview](chaos-studio-aks-extension-overview.md)
- [Troubleshoot the Chaos Studio extension for AKS](chaos-studio-aks-extension-troubleshoot.md)
- [Permissions and identity in Chaos Studio Workspaces](chaos-studio-workspace-permissions.md)
- [Test AKS resilience with Chaos Studio Workspaces](chaos-studio-aks-guidance.md)
