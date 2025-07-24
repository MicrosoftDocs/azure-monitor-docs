---
title: Use Microsoft Entra authentication with Chaos Studio AKS faults
description: Learn about the different ways for Chaos Studio to authenticate with your AKS cluster.
services: chaos-studio
author: rsgel
ms.topic: how-to
ms.date: 2/5/2025
ms.author: carlsonr
---

# Use Microsoft Entra authentication with Chaos Studio AKS faults

## Overview

Azure Chaos Studio integrates with Chaos Mesh to run faults on Azure Kubernetes Service (AKS) clusters, like removing pods, CPU stress, network disruption, and more. You can use two different types of authentication to run these faults, depending on your configuration and preferences, either local accounts or AKS-Managed Microsoft Entra authentication:

* Kubernetes local accounts are stored in the Kubernetes API server and can be used to authenticate and authorize requests to the cluster. Learn more about local accounts at this page: [Manage local accounts](/azure/aks/manage-local-accounts-managed-azure-ad).
* AKS-Managed Microsoft Entra authentication allows you to sign in and manage permissions for your cluster using Microsoft Entra credentials and Azure RBAC. Learn how to [Enable AKS-Managed Microsoft Entra authentication](/azure/aks/enable-authentication-microsoft-entra-id).

 > [!NOTE]
> Local account permissions grant access as long as the credentials are on the client machine, while AKS-Managed Microsoft Entra authentication allows more scoped assignment and management of permissions. Learn more about this best practice: [Best practices for cluster security and upgrades](/azure/aks/operator-best-practices-cluster-security?tabs=azure-cli).

Chaos Studio previously only supported using Chaos Mesh with local accounts, but Version 2.2 of all AKS faults now support both local accounts and Microsoft Entra authentication.

## Update targets

Targets (`Microsoft.Chaos/targets`) represent another Azure resource in Chaos Studio's resource model, so you can easily control whether or not a certain resource is enabled for fault injection and what faults can run against it. In this case, the target represents an AKS cluster that you want to affect.

If you're onboarding an AKS cluster as a new Chaos Studio target within the Azure portal, the new fault versions will automatically be available.

If you want to use the new fault version on an existing AKS target, you need to update the target. You can do this in one of two ways:
- Disable and re-enable the target resource. 
    - To do this in the Azure portal, visit the **Targets** pane in the Chaos Studio portal interface, select the relevant AKS cluster(s), and select **Disable targets**. Wait 1-2 minutes or for a confirmation notification, then select **Enable targets** > **Enable service-direct targets** and go through the Review & Create screen.
- Update the enabled capabilities.
    - To do this in the Azure portal, visit the **Targets** pane in Chaos Studio, find the AKS cluster(s), select **Manage actions**, and make sure all of the capabilities are enabled. Select **Save** to finalize the update.

If you're using the API or command-line, follow the instructions at [Create a chaos experiment that uses a Chaos Mesh fault with the Azure CLI](chaos-studio-tutorial-aks-cli.md#enable-chaos-studio-on-your-aks-cluster) to ensure the latest available capabilities are enabled.

## Create a new experiment

When you create a new experiment that uses AKS Chaos Mesh faults in the Azure portal, you may see two versions of each fault, such as "AKS Chaos Mesh DNS Chaos" and "AKS Chaos Mesh DNS Chaos (deprecated)". Select the first option, not the deprecated option.

If you don't see your AKS cluster as a possible target after selecting the fault, you may need to enable the new fault version on the cluster. Visit the Targets page, find your AKS cluster and select **Manage actions**, then make sure all of the capabilities are selected before selecting **Save**.

Follow the [Create a chaos experiment that uses a Chaos Mesh fault to kill AKS pods with the Azure portal](chaos-studio-tutorial-aks-portal.md) tutorial to create an experiment.

## Update an existing experiment

Follow one of these two methods to update your existing experiment.

### [Azure portal](#tab/azure-portal)

1. Open an experiment that contains at least one AKS Chaos Mesh fault. 
1. Select **Edit** on the fault and copy the `jsonSpec` parameter value to your clipboard.
1. Open the fault selection dropdown and select the version of your desired fault without the `(deprecated)` marking.
1. Paste the `jsonSpec` from your clipboard into the parameter field.
1. Save the fault and the experiment.

### [Command line](#tab/command-line)

1. Use the [REST API](chaos-studio-samples-rest-api.md) to get the experiment JSON.
    ```azurecli-interactive
    az rest --method get --url "https://management.azure.com/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.Chaos/experiments/$EXPERIMENT_NAME?api-version=2024-01-01"
    ```
    ```json
    {
      "id": "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.Chaos/experiments/$EXPERIMENT_NAME",
      "identity": {
        "principalId": "aaaaaaaa-bbbb-cccc-1111-222222222222",
        "tenantId": "aaaabbbb-0000-cccc-1111-dddd2222eeee",
        "type": "SystemAssigned"
      },
      "location": "eastus",
      "name": "aks-private-1",
      "properties": {
        "selectors": [
          {
            "id": "1925533b-5a3d-4733-a86d-167ab82f1931",
            "targets": [
              {
                "id": "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.ContainerService/managedClusters/$AKS_CLUSTER_NAME/providers/Microsoft.Chaos/targets/Microsoft-AzureKubernetesServiceChaosMesh",
                "type": "ChaosTarget"
              }
            ],
            "type": "List"
          }
        ],
        "steps": [
          {
            "branches": [
              {
                "actions": [
                  {
                    "duration": "PT10M",
                    "name": "urn:csci:microsoft:azureKubernetesServiceChaosMesh:podChaos/2.1",
                    "parameters": [
                      {
                        "key": "jsonSpec",
                        "value": "{\"action\":\"pod-failure\",\"mode\":\"all\",\"selector\":{\"namespaces\":[\"default\"]}}"
                      }
                    ],
                    "selectorId": "1925533b-5a3d-4733-a86d-167ab82f1931",
                    "type": "continuous"
                  }
                ],
                "name": "Branch 1"
              }
            ],
            "name": "Step 1"
          }
        ]
      },
      "systemData": {
        "createdAt": "2023-07-05T19:08:56.0145761+00:00",
        "createdByType": "User",
        "lastModifiedAt": "2024-10-08T00:00:12.701+00:00"
      },
      "tags": {},
      "type": "Microsoft.Chaos/experiments"
    }
    ```
1. Use a text or code editor to update the fault version for the corresponding fault(s) from 2.1 to 2.2. For example, change the line `"name": "urn:csci:microsoft:azureKubernetesServiceChaosMesh:podChaos/2.1"` to `"name": "urn:csci:microsoft:azureKubernetesServiceChaosMesh:podChaos/2.2"`. Save the file with a name you can reference in the next step, such as `experimentBody.json`.
1. Send the updated experiment JSON to Chaos Studio.
    ```azurecli-interactive
    az rest --method put --url "https://management.azure.com/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.Chaos/experiments/$EXPERIMENT_NAME?api-version=2024-01-01" --body @{experimentBody.json} 
    ```

---

## Permissions

Chaos Studio needs permission to execute faults on your resources. 

When creating an experiment in the Azure portal, you can optionally select **Enable custom role creation and assignment** to let Chaos Studio attempt to assign the necessary permissions to the experiment's managed identity.

If you choose not to use custom role creation, or you're not using the Azure portal, you must do **one of the following** after creating your experiment:
* Manually assign the [Azure Kubernetes Service RBAC Admin](/azure/role-based-access-control/built-in-roles/containers#azure-kubernetes-service-rbac-admin) and [Azure Kubernetes Service Cluster User](/azure/role-based-access-control/built-in-roles/containers#azure-kubernetes-service-cluster-user) roles to the experiment managed identity (system-assigned or user-assigned).
* Manually create a custom role allowing the full list of operations needed in [RBAC operations](#rbac-operations).
* Manually create a custom role allowing a partial list of the operations needed, and deploy a custom YAML file. This process is detailed in [Optional least-privilege access](#optional-least-privilege-access).

### RBAC operations

The following RBAC operations are used for AKS Chaos Mesh faults:
    
- Actions:
    - Microsoft.ContainerService/managedClusters/read
- Data Actions:
    - Microsoft.ContainerService/managedClusters/namespaces/read
    - Microsoft.ContainerService/managedClusters/pods/read
    - Microsoft.ContainerService/managedClusters/apiextensions.k8s.io/customresourcedefinitions/write
    - Microsoft.ContainerService/managedClusters/apiextensions.k8s.io/customresourcedefinitions/read
    - Microsoft.ContainerService/managedClusters/authorization.k8s.io/subjectaccessreviews/write
    - Microsoft.ContainerService/managedClusters/rbac.authorization.k8s.io/clusterroles/read
    - Microsoft.ContainerService/managedClusters/rbac.authorization.k8s.io/clusterroles/write
    - Microsoft.ContainerService/managedClusters/rbac.authorization.k8s.io/clusterroles/delete
    - Microsoft.ContainerService/managedClusters/rbac.authorization.k8s.io/clusterroles/bind/action
    - Microsoft.ContainerService/managedClusters/rbac.authorization.k8s.io/clusterroles/escalate/action
    - Microsoft.ContainerService/managedClusters/rbac.authorization.k8s.io/clusterrolebindings/read
    - Microsoft.ContainerService/managedClusters/rbac.authorization.k8s.io/clusterrolebindings/write
    - Microsoft.ContainerService/managedClusters/rbac.authorization.k8s.io/clusterrolebindings/delete


### Optional least-privilege access

If you prefer not to grant full ClusterRole and ClusterRoleBinding read/write access to the Chaos Studio experiment identity, you can manually create the necessary role and binding for Chaos Mesh. This is necessary for Chaos Mesh to ensure the experiment has permission to target the specified tenant namespace.

There are two steps to this optional configuration.

1. When assigning permissions to the experiment's managed identity, use a custom role with a limited set of permissions. The permissions required are:

    - Actions:
        - Microsoft.ContainerService/managedClusters/read
    - Data Actions:
        - Microsoft.ContainerService/managedClusters/namespaces/read
        - Microsoft.ContainerService/managedClusters/pods/read
        - Microsoft.ContainerService/managedClusters/apiextensions.k8s.io/customresourcedefinitions/write
        - Microsoft.ContainerService/managedClusters/apiextensions.k8s.io/customresourcedefinitions/read
        - Microsoft.ContainerService/managedClusters/authorization.k8s.io/subjectaccessreviews/write

1. Deploy the following YAML configuration to create the role and binding. Learn more about deployments in the AKS documentation: [Deploy an Azure Kubernetes Service (AKS) cluster using Azure portal](/azure/aks/learn/quick-kubernetes-deploy-portal?tabs=azure-cli).

    ```yml
    kind: ClusterRole
    apiVersion: rbac.authorization.k8s.io/v1
    metadata:
      name: role-cluster-manager-pdmas
    rules:
    - apiGroups:
      - chaos-mesh.org
      resources: [ "*" ]
      verbs: ["get", "list", "watch", "create", "delete", "patch", "update"]
     
    ---
    kind: ClusterRoleBinding
    apiVersion: rbac.authorization.k8s.io/v1
    metadata:
      name: cluster-manager-binding
      namespace: {Namespace targeted by experiment}
    subjects:
    - kind: User
      name: {CHAOS-STUDIO-EXPERIMENT-MSI-OBJECT-ID}
    roleRef:
      kind: ClusterRole
      name: role-cluster-manager-pdmas
      apiGroup: rbac.authorization.k8s.io
    
    ```
