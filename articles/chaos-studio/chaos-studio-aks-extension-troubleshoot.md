---
title: Troubleshoot the Chaos Studio extension for AKS
description: Troubleshoot the Chaos Studio extension for AKS by symptom. Fix installation errors, connection problems, and pod fault runs that fail or don't end cleanly.
author: nikhilkaul-msft
ms.author: nikhilkaul
ms.service: azure-chaos-studio
ms.topic: troubleshooting-general
ms.date: 11/16/2026
ai-usage: ai-assisted
---

# Troubleshoot the Chaos Studio extension for AKS

Use this article when you can't install the [Chaos Studio extension for Azure Kubernetes Service (AKS)](chaos-studio-aks-extension-overview.md), or when a pod fault fails, doesn't finish, or doesn't end cleanly. Find your symptom or error message in the tables.

For problems with Workspaces and Scenarios that aren't specific to the extension, see [Troubleshoot Chaos Studio Workspaces and Scenarios](troubleshoot-workspaces-scenarios.md). For Chaos Mesh faults in Experiments (classic), see [Troubleshoot Experiments (classic)](troubleshooting.md).

## Collect information

Run these read-only commands first. Replace the placeholders with your values.

```azurecli
az k8s-extension show \
  --resource-group <aks-resource-group> \
  --cluster-name <aks-cluster-name> \
  --cluster-type managedClusters \
  --name chaos-studio
```

```bash
kubectl get pods --namespace chaos-infrastructure --output wide
kubectl get events --namespace chaos-infrastructure --sort-by=.lastTimestamp
kubectl get chaosresults --all-namespaces
```

Write down the following items:

- The full error message and the time of the operation.
- The extension version and the `provisioningState` value from the first command.
- The value of the `chaosDaemon.enabled` configuration setting from the first command.
- The ID of the Scenario run, if the problem is a run.

## Installation fails

If installation fails partway through, the Azure CLI reports the failed phase in a message that starts with `Chaos <phase> failed`. The message says that the extension, the connection, and the Workspace permissions were retained. Correct the cause, and then run the same `az k8s-extension create` command again.

| Error or symptom | Cause | What to do |
| --- | --- | --- |
| `'chaos-workspace-id' is required.` | The command doesn't include the Workspace resource ID. | Add `--configuration-settings chaos-workspace-id=<workspace-resource-id>`. |
| `AKS Workload Identity must be enabled before installing` | The cluster doesn't have Microsoft Entra Workload ID turned on. | Turn on [Workload ID](/azure/aks/workload-identity-overview) on the cluster, and then install again. |
| `The AKS OIDC issuer must be enabled and expose an issuer URL` | The cluster doesn't have the OpenID Connect (OIDC) issuer turned on. | Turn on the [OIDC issuer](/azure/aks/use-oidc-issuer), and then install again. |
| `Azure RBAC for Kubernetes must be enabled before installing` | The cluster doesn't use Azure role-based access control (RBAC) for Kubernetes authorization. | Turn on [Azure RBAC for Kubernetes authorization](/azure/aks/entra-id-authorization), and then install again. |
| `Microsoft.ChaosStudio supports only AKS clusters` | The `--cluster-type` value isn't `managedClusters`. | Use `--cluster-type managedClusters`. |
| `The Chaos Studio workspace must expose a system-assigned identity or exactly one user-assigned managed identity` | The Workspace doesn't have exactly one usable managed identity. It has none, it has more than one, or it has both kinds. | Give the Workspace a system-assigned identity or exactly one user-assigned identity, not both. |
| `RoleDefinitionLimitExceeded` | An earlier version of the `k8s-extension` Azure CLI extension tried to create a custom role, and the tenant reached its limit for custom roles. | Upgrade to version 1.9.5 or later, which assigns a built-in role. Run `az extension add --name k8s-extension --upgrade`. |
| An authorization error for `Microsoft.Authorization/roleAssignments/write` | Your account can't assign roles on the cluster. The Contributor role doesn't include this permission. | Ask an administrator for the missing permission, or ask someone who has all the [permissions you need to install](chaos-studio-aks-extension-install.md#permissions-you-need-to-install) to install the extension. |
| `LocationRequired: The location property is required for this definition.` | The service rejected the request to create the Workspace connection. Your input didn't cause this error, and changing your input doesn't fix it. | See [Get help](#get-help). |
| `A connection already exists without its extension; refusing to adopt its identity.` | An earlier installation left a Workspace connection for this cluster. | See [Get help](#get-help) to remove the leftover connection before you install again. |
| `Changing 'chaos-workspace-id' on an installed extension is not supported` | You tried to point an installed extension at another Workspace. | [Remove the extension](chaos-studio-aks-extension-install.md#remove-the-extension), and then install it again with the new Workspace. |
| The command prompts you to sign in with a device code. | kubelogin is asking for credentials for the cluster. | Set the environment variable `AAD_LOGIN_METHOD` to `azurecli`, and then run the command again. |
| A warning that starts with `Deployment Safeguards prevents the Chaos daemon` | Deployment Safeguards enforces policies on the cluster and doesn't exclude the `chaos-infrastructure` namespace. The extension installs without the network fault component. | To use the network faults, see [Network faults fail with AksLitmusDaemonUnavailable](#network-faults-fail-with-akslitmusdaemonunavailable). |
| Extension pods stay in the `Pending` state. | Kubernetes can't schedule the pods. A common cause is that no Linux amd64 node has enough free CPU and memory. | Run `kubectl describe pod <pod-name> --namespace chaos-infrastructure` and read the scheduling events. If resources are insufficient, add Linux amd64 capacity. Clusters with only arm64 node pools aren't supported. |
| Extension pods show `ImagePullBackOff`. | The cluster can't pull an extension image. The images come from Microsoft Artifact Registry (`mcr.microsoft.com`). | Run `kubectl describe pod <pod-name> --namespace chaos-infrastructure` and read the image pull error. Check that the cluster allows outbound access to `mcr.microsoft.com`. |

## The connection status shows Pending

The Workspace connection status shows `Pending` even when the connection works. This status is a known issue. Use these checks instead:

1. Check that the extension `provisioningState` is `Succeeded`.
1. Check that the `chaos-subscriber` pod in the `chaos-infrastructure` namespace is running and ready.
1. Run a short pod delete Scenario on a test workload and check that it completes. See [Run a pod fault](chaos-studio-aks-extension-install.md#run-a-pod-fault).

## A Scenario can't be created or doesn't start

| Error or symptom | Cause | What to do |
| --- | --- | --- |
| `ResourceDiscoveryNotReadyError` | The Workspace didn't finish its first discovery of the resources in its scope. | Wait for discovery to finish, and then start the run again. |
| `ConnectionTargetOutOfScope` | The AKS cluster isn't in the scope of the Workspace. | Add the cluster, its resource group, or its subscription to the Workspace scope. |
| `ScenarioPlanNoActionsError: No actionable steps found in the execution plan.` | The run found no target for the Action. Possible causes are that the Workspace didn't discover the cluster yet or that the Action doesn't identify the cluster. | Check that the Workspace discovered the cluster. Pass the cluster resource ID to `externalResource.resourceId` through a Scenario parameter, as the [example Scenario](chaos-studio-aks-extension-install.md#create-the-scenario) shows. |
| An authorization error says that the Workspace identity is missing a permission. | The Workspace identity doesn't have a role that it needs. | Check that the Workspace identity has the Reader role on the Workspace scope and the **Chaos Kubernetes Extension Operator** role on the cluster. If an earlier version of the Azure CLI installed the extension, the identity can have a custom role instead. In that case, also assign the Reader role on the cluster to the Workspace identity. |
| The run fails soon after it starts, and the Action duration is shorter than 1 minute. | The minimum Action duration is 1 minute. | Set the Action `duration` to `PT1M` or longer. |

## A fault fails or has no effect

| Error or symptom | Cause | What to do |
| --- | --- | --- |
| `No Chaos Studio subscriber is currently connected for cluster` | The extension isn't installed on the cluster, or it can't reach Chaos Studio. | Check that the `chaos-subscriber` pod is running and ready. Check that the cluster allows outbound HTTPS access to Chaos Studio and to Microsoft Entra ID. |
| A message that says pods `could not be scheduled` | Kubernetes can't schedule the pods that run the fault. The message names the reason, such as insufficient CPU, insufficient memory, or no matching node. | Resolve the issue identified in the message. For insufficient resources, add capacity on Linux amd64 nodes. Then run the Scenario again. |
| `Experiment '<name>' finished with verdict 'Fail'` or `'Error'` | The fault started but didn't complete in the cluster. | Run the `kubectl get chaosresults` command that the message contains, and read the reason. |
| `ChaosEngine '<name>' failed.` | The fault didn't complete in the cluster. | Check that the target namespace is in the list that you set at installation. Check the events in the `chaos-infrastructure` namespace and in the target namespace. |
| Pod delete fails in a namespace that enforces Pod Security Admission. | Kubernetes rejects the pod that runs the fault in a namespace that enforces the `restricted` level. | Run pod delete tests in a namespace that doesn't enforce `restricted`. |
| Pod CPU hog or pod memory hog fails to start or to stop. | One possible cause is that the target container doesn't include a shell and standard utilities such as `awk`. | Check the fault's error message. Use a target container image that includes these tools. |
| A container restarts during pod memory hog. | Memory pressure can push a container over its memory limit. | Check why the container stopped. This result can be the effect that you wanted to test. To avoid the restart, lower `memoryConsumptionMegabytes`. |
| The run completes, but no pod is affected. | A common cause is that the label selector or the namespace doesn't match the pods that you expected. | Run `kubectl get pods --namespace <namespace> --selector <label-selector>` and compare the result with your Action parameters. Then check the Kubernetes events in the target namespace. |

### Network faults fail with AksLitmusDaemonUnavailable

Pod network latency and pod network loss need the extension's network fault component, which runs as the `chaos-daemon` pods. Installation skips this component when [Deployment Safeguards](/azure/aks/deployment-safeguards) enforces policies on the cluster and doesn't exclude the `chaos-infrastructure` namespace. AKS Automatic clusters enforce Deployment Safeguards by default.

1. Check the `chaosDaemon.enabled` configuration setting of the extension. The value `false` means that installation skipped the component.
1. Ask the cluster administrator to exclude the `chaos-infrastructure` namespace from Deployment Safeguards. This exclusion removes Safeguards protection from that namespace.
1. [Remove the extension](chaos-studio-aks-extension-install.md#remove-the-extension), and then install it again. The exclusion alone doesn't add the component to an existing installation.

Pod delete, pod CPU hog, and pod memory hog don't need this component.

## A run stays in the Running state

A run can stay in the **Running** state when a fault targets a namespace that isn't in the list that you set at installation. Later runs on the same cluster can also fail.

1. Cancel the run.
1. Check the `namespace` parameter of the Action against the `experiments.targetNamespaces` settings of the extension. To see the settings, run the `az k8s-extension show` command in [Collect information](#collect-information).
1. Correct the `namespace` parameter, or install the extension again with the namespace in the list. See [Choose the workload namespaces](chaos-studio-aks-extension-install.md#choose-the-workload-namespaces).
1. If later runs still fail after you cancel, see [Get help](#get-help).

## A network fault stays in effect after the run ends

If a container in a target pod restarts during pod network latency or pod network loss, the extension can't remove the network effect from that pod. The pod keeps the added latency or packet loss after the run ends. The run can still show **Succeeded**.

To remove the effect, delete the affected pods so that Kubernetes creates new ones. Use the method that fits the workload that owns the pods. For example, the following command replaces all pods of a deployment:

```bash
kubectl rollout restart deployment <deployment-name> --namespace <namespace>
```

To make a restart less likely, check that the liveness probes of the target pods tolerate failures for longer than the fault duration. A network fault can make a liveness probe fail, and Kubernetes then restarts the container. Containers can also restart for other reasons, so check the pods after every network fault.

## The run status doesn't match what happened in the cluster

The Scenario run status can differ from the effect in the cluster. For example, a run can show **Succeeded** while a network fault is still in effect on a pod. Confirm the result with Kubernetes events, pod status, and your application metrics. For more information, see [Interpret the results](chaos-studio-aks-extension-overview.md#interpret-the-results).

## Resources remain after you remove the extension

The `az k8s-extension delete` command doesn't delete the `chaos-infrastructure` namespace or the Kubernetes resources that remain in it. This behavior is expected. The command removes the extension, its Workspace connection, and the role assignment that installation created for the Workspace identity.

## Get help

To get help with the extension, create a support request for Azure Chaos Studio in the [Azure portal](https://portal.azure.com/#view/Microsoft_Azure_Support/HelpAndSupportBlade). Include the information from [Collect information](#collect-information). Don't include access tokens or other credentials.

To report a bug or request a feature, open an issue in the [Chaos Studio repository on GitHub](https://github.com/microsoft/chaos-studio/issues).

## Related content

- [Chaos Studio extension for AKS overview](chaos-studio-aks-extension-overview.md)
- [Install the Chaos Studio extension for AKS and run a pod fault](chaos-studio-aks-extension-install.md)
- [Troubleshoot Chaos Studio Workspaces and Scenarios](troubleshoot-workspaces-scenarios.md)
