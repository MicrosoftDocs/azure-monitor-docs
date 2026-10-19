---
title: Prepare to use the Chaos Studio extension for AKS (preview)
description: Check prerequisites and permissions, check your cluster configuration, verify the installation, plan a controlled test, and remove the Chaos Studio extension for AKS.
author: nikhilkaul-msft
ms.topic: how-to
ms.date: 10/18/2026
ai-usage: ai-assisted
---

# Prepare to use the Chaos Studio extension for AKS (preview)

This article helps you prepare a cluster and a workspace for the [Chaos Studio extension for Azure Kubernetes Service (AKS)](chaos-studio-aks-extension-overview.md). You check the prerequisites and permissions, verify the installation, and plan your first pod-level test.

> [!IMPORTANT]
> The extension is in a limited preview. Microsoft enables it only for allow-listed subscriptions. During the preview, you can use the extension with a Workspace in West Central US, West US 2, North Europe, Sweden Central, UK South, and Japan East. Your AKS cluster can be in any region that supports AKS extensions. To get access, see [Request access](#request-access).

## Prerequisites

- An Azure subscription that's on the preview allow list. To request access, see [Request access](#request-access).
- A [Chaos Studio Workspace](quickstart-create-workspace.md) that has a user-assigned managed identity. The workspace scope must include the AKS cluster resource. For more information, see [Permissions and identity in Chaos Studio Workspaces](chaos-studio-workspace-permissions.md).
- An AKS cluster with [Microsoft Entra Workload ID](/azure/aks/workload-identity-overview), the [OIDC issuer](/azure/aks/use-oidc-issuer), and [Azure RBAC for Kubernetes authorization](/azure/aks/manage-azure-rbac) turned on. Installation checks these features.
- Version 1.9.4 or later of the `k8s-extension` Azure CLI extension.
- The permissions in [Review the permissions for installation](#review-the-permissions-for-installation).

To install or upgrade the `k8s-extension` Azure CLI extension, run:

```azurecli
az extension add --name k8s-extension --upgrade
```

To check the installed version, run:

```azurecli
az extension show --name k8s-extension --query version --output tsv
```

The command returns `1.9.4` or a later version.

## Request access

1. [open an issue in the Chaos Studio GitHub repository](https://github.com/microsoft/chaos-studio/issues/new/choose).
1. Include your subscription ID, the region of your Workspace, and the faults that you plan to use.
1. Wait for the Chaos Studio team to confirm that your subscription is on the allow list. The team also sends you the installation instructions.

## Review the permissions for installation

You don't assign roles for the extension yourself. Installation creates the resources and role assignment that the extension needs. The person who installs the extension needs the permissions in this section.

### What installation creates

| Resource | What installation does |
| --- | --- |
| Subscriber identity | Creates a user-assigned managed identity and its federated identity credential in the cluster resource group. The in-cluster component uses this identity. It gets no Azure role assignments. |
| Custom role | Creates a custom role in the subscription, if the role doesn't exist yet. Later installations in the subscription reuse the role. |
| Role assignment | Assigns the custom role to the Workspace's user-assigned managed identity at the AKS cluster scope. |
| Cluster extension | Installs the extension in the `chaos-infrastructure` namespace. |
| Workspace connection | Creates a connection between the Workspace and the cluster. The resource type is `Microsoft.Chaos/workspaces/connections`. |

### Custom role permissions

During the preview, the role is a custom role named `Chaos Studio Kubernetes Operator (<subscription-id>)`. If an earlier version of the Azure CLI created a role named `Chaos Studio Kubernetes Operator` in the subscription, installation reuses that role.

The role contains these permissions:

| Type | Permission |
| --- | --- |
| Action | `Microsoft.ContainerService/managedClusters/read` |
| Data action | `Microsoft.ContainerService/managedClusters/serviceaccounts/impersonate/action` |
| Data action | `Microsoft.ContainerService/managedClusters/pods/read` |

Microsoft plans to replace this custom role with a built-in role. The role name and permissions might change during the preview. The fault runs inside the cluster through the extension.

### Permissions you need to install

| Installation step | Permissions | Scope |
| --- | --- | --- |
| Read the cluster and the Workspace. | `Microsoft.ContainerService/managedClusters/read`, `Microsoft.Chaos/workspaces/read` | Cluster, Workspace |
| Read the Deployment Safeguards configuration. | `Microsoft.ContainerService/deploymentSafeguards/read` | Cluster |
| Create the subscriber identity and its federated credential. | `Microsoft.ManagedIdentity/userAssignedIdentities/write`, `Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials/write` | Cluster resource group |
| Create the custom role, if it doesn't exist. | `Microsoft.Authorization/roleDefinitions/write` | Subscription |
| Assign the role to the Workspace identity. | `Microsoft.Authorization/roleAssignments/write` | Cluster |
| Install the extension. | `Microsoft.KubernetesConfiguration/extensions/write` | Cluster |
| Connect the Workspace to the cluster. | `Microsoft.Chaos/workspaces/connections/write` | Workspace |

In built-in roles, you need Owner, or Contributor and User Access Administrator, on the cluster and its resource group. You also need Contributor on the Workspace.

> [!NOTE]
> The first person to install the extension in a subscription also needs Owner or User Access Administrator at the subscription scope to create the custom role. Later installations reuse the role.

To remove the extension, you need the matching delete permissions.

## Check your cluster configuration

Check the following items before you install:

- **Node pools.** Faults affect pods on Linux amd64 nodes. In a cluster with amd64 and arm64 node pools, faults affect only pods on amd64 nodes. Clusters with only arm64 node pools and Windows node pools aren't supported.
- **Deployment Safeguards.** If [Deployment Safeguards](/azure/aks/deployment-safeguards) is set to enforce, installation shows a warning. It installs the extension without the component that the network faults need. Pod delete, CPU hog, and memory hog still work. Pod network latency and pod network loss fail with the error `AksLitmusDaemonUnavailable`. To use the network faults, exclude the `chaos-infrastructure` namespace from Deployment Safeguards and install again. This exclusion removes Safeguards protection from that namespace.
- **Other configurations.** If your cluster uses a configuration that this article doesn't list, ask about it in your access request.

## Install and verify the extension

Install the extension by using the instructions that the Chaos Studio team sends you. Then verify the installation.

### Run the checks

1. Check the provisioning state of the extension. Replace the placeholders with your values:

    ```azurecli
    az k8s-extension show --cluster-type managedClusters --cluster-name <aks-cluster-name> --resource-group <aks-resource-group> --name <extension-name> --query provisioningState --output tsv
    ```

1. Check the pods of the extension:

    ```bash
    kubectl get pods --namespace chaos-infrastructure
    ```

### Check the result

- The first command returns `Succeeded`.
- In the second command, each pod shows `Running` and all of its containers are ready.
- The Workspace connection status shows `Pending`. This status is a known issue. It doesn't mean that the connection failed.

To confirm that the extension can run a fault, run a short scenario with **pod delete** on a test workload. Use a duration of at least 1 minute (`PT1M`).

## Plan a controlled test

> [!WARNING]
> Faults can interrupt requests and put application data at risk. Get approval from the owners of the cluster and the workload before you start a run.

1. Select a preproduction workload that you can recover. Write down the cluster, namespace, and pods that the fault can affect.
1. State the expected behavior in measurable terms. For example, 99% of checkout requests succeed and every acknowledged order is stored.
1. Select the fault that tests that behavior. Check that your pod selection matches only the pods that you intend to affect.
1. Start test traffic and record normal behavior before the fault.
1. Agree on a stop condition and on the person who stops the test.
1. Run the Scenario. Watch the application during the fault and after it ends.
1. Compare the [Scenario report](chaos-studio-scenario-reports.md) with your application metrics and Kubernetes events. A completed Action doesn't prove that the application recovered.

Keep the Scenario, the test traffic configuration, and the results. Run the same test again after you change the application, so you can compare the results.

## Remove the extension

Remove the extension with the Azure CLI. Don't delete the Helm release, the identities, or the namespace directly.

```azurecli
az k8s-extension delete --cluster-type managedClusters --cluster-name <aks-cluster-name> --resource-group <aks-resource-group> --name <extension-name>
```

The command deletes the Workspace connection before it deletes the extension. It keeps the Workspace and the cluster.

After removal, some Kubernetes resources, such as the `chaos-infrastructure` namespace, can remain in the cluster. Check the cluster before you assume that it's clean. Don't delete the custom role while other installations in the subscription use it.

## Next steps

- [Chaos Studio extension for AKS (preview) overview](chaos-studio-aks-extension-overview.md)
- [Permissions and identity in Chaos Studio Workspaces](chaos-studio-workspace-permissions.md)
- [Test AKS resilience with Chaos Studio Workspaces](chaos-studio-aks-guidance.md)
- [Scenario reports in Chaos Studio Workspaces](chaos-studio-scenario-reports.md)
