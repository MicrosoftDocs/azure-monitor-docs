---
title: Set up Prometheus remote write by using managed identity authentication
description: Learn how to set up remote write in Azure Monitor managed service for Prometheus. Use managed identity authentication to send data from a self-managed Prometheus server running in your Azure Kubernetes Server (AKS) cluster or Azure Arc-enabled Kubernetes cluster.
ms.topic: how-to
ms.date: 4/18/2024
---

# Send Prometheus data to Azure Monitor using managed identity authentication

This article describes how to set up [remote write](prometheus-remote-write.md) to send data from a self-managed Prometheus server running in your Azure Kubernetes Service (AKS) cluster or Azure Arc-enabled Kubernetes cluster by using managed identity authentication and a side car container provided by Azure Monitor. You can either use an existing identity that's created by AKS or [create your own](/azure/active-directory/managed-identities-azure-resources/how-manage-user-assigned-managed-identities). Both options are described here.

> [!NOTE]
> If you are using the user-assigned managed identity, we recommend that you directly configure Prometheus running on your Kubernetes cluster to remote-write into Azure Monitor Workspace. See [Send Prometheus data to Azure Monitor using user-assigned managed identity](../essentials/prometheus-remote-write-virtual-machines.md#set-up-authentication-for-remote-write) to learn more. The steps below use the Azure Monitor side car container.

## Cluster configurations

This article applies to the following cluster configurations:

- Azure Kubernetes Service cluster
- Azure Arc-enabled Kubernetes cluster


## Prerequisites

### Supported versions

- Prometheus versions greater than v2.45 are required for user-assigned managed identity authentication.
- Prometheus versions v3.50 or greater are required for system-assigned managed identity authentication.


### Azure Monitor workspace

This article covers sending Prometheus metrics to an Azure Monitor workspace. To create an Azure monitor workspace, see [Manage an Azure Monitor workspace](/azure/azure-monitor/essentials/azure-monitor-workspace-manage#create-an-azure-monitor-workspace).

## Permissions

Administrator permissions for the cluster or resource are required to complete the steps in this article.

## Set up an application for managed identity

The process to set up Prometheus remote write for an application by using managed identity authentication involves completing the following tasks:

1. Get the name of the cluster's node resource group.
1. Get the client ID of the user-assigned managed identity.
1. Assign the Monitoring Metrics Publisher role on the workspace data collection rule to the managed identity.
1. Give the cluster access to the managed identity.
1. Deploy a sidecar container to set up remote write.

The tasks are described in the following sections.

### Get the name of the cluster's node resource group

The node resource group of the cluster contains resources that you use in other steps in this process. This resource group has the name `MC_<RESOURCE-GROUP>_<CLUSTER-NAME>_<REGION>`. You can find the resource group name by using the **Resource groups** menu in the Azure portal.

:::image type="content" source="media/prometheus-remote-write-managed-identity/resource-groups.png" alt-text="Screenshot that shows a list of resource groups." lightbox="media/prometheus-remote-write-managed-identity/resource-groups.png":::

### Get the client ID of the user-assigned managed identity

You must get the client ID of the identity that you're going to use. Copy the client ID to use later in the process.

Instead of creating your own client ID, you can use one of the identities that are created by AKS. To learn more about the identities, see [Use a managed identity in Azure Kubernetes Service](/azure/aks/use-managed-identity).

This article uses the kubelet identity. The name of this identity is `<CLUSTER-NAME>-agentpool`, and it's in the node resource group of the cluster.

:::image type="content" source="media/prometheus-remote-write-managed-identity/resource-group-details.png" alt-text="Screenshot that shows a list of resources that are in the node resource group." lightbox="media/prometheus-remote-write-managed-identity/resource-group-details.png":::

Select the `<CLUSTER-NAME>-agentpool` managed identity. On the **Overview** page, copy the value for **Client ID**. For more information, see [Manage user-assigned managed identities](/azure/active-directory/managed-identities-azure-resources/how-manage-user-assigned-managed-identities).

:::image type="content" source="media/prometheus-remote-write-managed-identity/client-id.png" alt-text="Screenshot that shows a client ID on an overview page for a managed identity." lightbox="media/prometheus-remote-write-managed-identity/client-id.png":::

### Assign the Monitoring Metrics Publisher role on the workspace data collection rule to the managed identity

The managed identity must be assigned the Monitoring Metrics Publisher role on the data collection rule that is associated with your Azure Monitor workspace.

1. On the resource menu for your Azure Monitor workspace, select **Overview**. For **Data collection rule**, select the link.

    :::image type="content" source="media/prometheus-remote-write-managed-identity/azure-monitor-account-data-collection-rule.png" alt-text="Screenshot that shows the data collection rule that's associated with an Azure Monitor workspace." lightbox="media/prometheus-remote-write-managed-identity/azure-monitor-account-data-collection-rule.png":::

1. On the resource menu for the data collection rule, select **Access control (IAM)**.

1. Select **Add**, and then select **Add role assignment**.

    :::image type="content" source="media/prometheus-remote-write-managed-identity/data-collection-rule-add-role-assignment.png" alt-text="Screenshot that shows adding a role assignment on Access control pages." lightbox="media/prometheus-remote-write-managed-identity/data-collection-rule-add-role-assignment.png":::

1. Select the **Monitoring Metrics Publisher** role, and then select **Next**.

    :::image type="content" source="media/prometheus-remote-write-managed-identity/add-role-assignment.png" alt-text="Screenshot that shows a list of role assignments." lightbox="media/prometheus-remote-write-managed-identity/add-role-assignment.png":::

1. Select **Managed Identity**, and then choose **Select members**. Select the subscription that contains the user-assigned identity, and then select **User-assigned managed identity**. Select the user-assigned identity that you want to use, and then choose **Select**.

    :::image type="content" source="media/prometheus-remote-write-managed-identity/select-managed-identity.png" alt-text="Screenshot that shows selecting a user-assigned managed identity." lightbox="media/prometheus-remote-write-managed-identity/select-managed-identity.png":::

1. To complete the role assignment, select **Review + assign**.

### Give the AKS cluster access to the managed identity

This step isn't required if you're using an AKS identity. An AKS identity already has access to the cluster.

> [!IMPORTANT]
> To complete the steps in this section, you must have owner or user access administrator permissions for the cluster.

1. Identify the virtual machine scale sets in the [node resource group](#get-the-name-of-the-clusters-node-resource-group) for your cluster.

    :::image type="content" source="media/prometheus-remote-write-managed-identity/resource-group-details-virtual-machine-scale-sets.png" alt-text="Screenshot that shows virtual machine scale sets in the node resource group." lightbox="media/prometheus-remote-write-managed-identity/resource-group-details-virtual-machine-scale-sets.png":::

2. For each virtual machine scale set, run the following command in the Azure CLI:

    ```azurecli
    az vmss identity assign -g <NODE-RESOURCE-GROUP> -n <VMSS-NAME> --identities <USER-ASSIGNED-IDENTITY-RESOURCE-ID>
    ```

### Deploy a sidecar container to set up remote write

1. Copy the following YAML and save it to a file. The YAML uses port 8081 as the listening port. If you use a different port, modify the port in the YAML.

    [!INCLUDE[managed-identity-yaml](includes/prometheus-sidecar-remote-write-managed-identity-yaml.md)]

1. Replace the following values in the YAML:

    | Value | Description |
    |:---|:---|
    | `<AKS-CLUSTER-NAME>` | The name of your AKS cluster. |
    | `<CONTAINER-IMAGE-VERSION>` | [!INCLUDE [version](includes/prometheus-remotewrite-image-version.md)]<br> The remote write container image version.   |
    | `<INGESTION-URL>` | The value for **Metrics ingestion endpoint** from the **Overview** page for the Azure Monitor workspace. |
    | `<MANAGED-IDENTITY-CLIENT-ID>` | The value for **Client ID** from the **Overview** page for the managed identity. |
    | `<CLUSTER-NAME>` | Name of the cluster that Prometheus is running on. |

   > [!IMPORTANT]
   > For Azure Government cloud, add the following environment variables in the `env` section of the YAML file:
   >
   > `- name: INGESTION_AAD_AUDIENCE value: https://monitor.azure.us/`

1. Open Azure Cloud Shell and upload the YAML file.
1. Use Helm to apply the YAML file and update your Prometheus configuration:

    ```azurecli
    # set context to your cluster 
    az aks get-credentials -g <aks-rg-name> -n <aks-cluster-name> 
 
    # use Helm to update your remote write config 
    helm upgrade -f <YAML-FILENAME>.yml prometheus prometheus-community/kube-prometheus-stack --namespace <namespace where Prometheus pod resides> 
    ```

## Verification and troubleshooting

For verification and troubleshooting information, see [Troubleshooting remote write](/azure/azure-monitor/containers/prometheus-remote-write-troubleshooting)  and [Azure Monitor managed service for Prometheus remote write](prometheus-remote-write.md#verify-remote-write-is-working-correctly).

## Next steps

- [Collect Prometheus metrics from an AKS cluster](../containers/kubernetes-monitoring-enable.md)
- [Learn more about Azure Monitor managed service for Prometheus](../essentials/prometheus-metrics-overview.md)
- [Remote write in Azure Monitor managed service for Prometheus](prometheus-remote-write.md)
- [Send Prometheus data to Azure Monitor by using Microsoft Entra authentication](./prometheus-remote-write-active-directory.md)
- [Send Prometheus data to Azure Monitor by using Microsoft Entra Workload ID (preview) authentication](./prometheus-remote-write-azure-workload-identity.md)
- [Send Prometheus data to Azure Monitor by using Microsoft Entra pod-managed identity (preview) authentication](./prometheus-remote-write-azure-ad-pod-identity.md)



## Verify remote write is working correctly

Use the following methods to verify that Prometheus data is being sent into your Azure Monitor workspace.

### Kubectl commands

Use the following command to view logs from the side car container. Remote write data is flowing if the output has nonzero value for `avgBytesPerRequest` and `avgRequestDuration`.

```azurecli
kubectl logs <Prometheus-Pod-Name> <Azure-Monitor-Side-Car-Container-Name> --namespace <namespace-where-Prometheus-is-running>
# example: kubectl logs prometheus-prometheus-kube-prometheus-prometheus-0 prom-remotewrite --namespace monitoring
```

The output from this command has the following format:

```
time="2022-11-02T21:32:59Z" level=info msg="Metric packets published in last 1 minute" avgBytesPerRequest=19713 avgRequestDurationInSec=0.023 failedPublishing=0 successfullyPublished=122
```

### Azure Monitor metrics explorer with PromQL

To check if the metrics are flowing to the Azure Monitor workspace, from your Azure Monitor workspace in the Azure portal, select **Metrics**. Use the metrics explorer to query the metrics that you're expecting from the self-managed Prometheus environment. For more information, see [Metrics explorer](/azure/azure-monitor/essentials/metrics-explorer).


### Prometheus explorer in Azure Monitor Workspace

Prometheus Explorer provides a convenient way to interact with Prometheus metrics within your Azure environment, making monitoring and troubleshooting more efficient. To use the Prometheus explorer, from to your Azure Monitor workspace in the Azure portal and select **Prometheus Explorer** to query the metrics that you're expecting from the self-managed Prometheus environment.
For more information, see [Prometheus explorer](/azure/azure-monitor/essentials/prometheus-workbooks).

### Grafana

Use PromQL queries in Grafana and verify that the results return expected data. For more information on configuring Grafana for Azure managed service for Prometheus, see [Use Azure Monitor managed service for Prometheus as data source for Grafana using managed system identity](../essentials/prometheus-grafana.md) 


## Troubleshoot remote write 

If remote data isn't appearing in your Azure Monitor workspace, see [Troubleshoot remote write](../containers/prometheus-remote-write-troubleshooting.md) for common issues and solutions. 