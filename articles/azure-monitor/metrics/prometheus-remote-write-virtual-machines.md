---
title: Send Prometheus Metrics from Virtual Machines, Scale Sets, or Kubernetes Clusters to an Azure Monitor Workspace
description: Learn how to configure remote write to send data from self-managed Prometheus to Azure Monitor managed service for Prometheus.
ms.topic: how-to
ms.custom: devx-track-azurecli
ms.date: 08/07/2024
#customer intent: As an Azure administrator, I want to send Prometheus metrics from my self-managed Prometheus instance to an Azure Monitor workspace.
---

# Send Prometheus metrics from virtual machines, scale sets, or Kubernetes clusters to an Azure Monitor workspace

Prometheus isn't limited to monitoring Kubernetes clusters. Use Prometheus to monitor applications and services running on your servers, wherever they're running. For example, you can monitor applications running on virtual machines, virtual machine scale sets, or even on-premises servers. You can also send Prometheus metrics to an Azure Monitor workspace from your self-managed cluster and Prometheus server.

This article explains how to configure remote write to send data from a self-managed Prometheus instance to an Azure Monitor workspace.

## Options for remote write

Self-managed Prometheus can run in Azure and non-Azure environments. The following are authentication options for remote write to an Azure Monitor workspace, based on the environment where Prometheus is running.

### Azure-managed virtual machines, virtual machine scale sets, and Kubernetes clusters

Use user-assigned managed identity authentication for services running self-managed Prometheus in an Azure environment. Azure-managed services include:

* Azure Virtual Machines
* Azure Virtual Machine Scale Sets
* Azure Kubernetes Service (AKS)

To set up remote write for Azure-managed resources, see [Remote write using user-assigned managed identity authentication](#remote-write-using-user-assigned-managed-identity-authentication) later in this article.

### Virtual machines and Kubernetes clusters running in non-Azure environments

If you have virtual machines or a Kubernetes cluster in non-Azure environments, or you onboarded to Azure Arc, install self-managed Prometheus and configure remote write by using Microsoft Entra application authentication. For more information, see [Remote write using Microsoft Entra application authentication](#remote-write-using-microsoft-entra-application-authentication) later in this article.

Onboarding to Azure Arc-enabled servers allows you to manage and configure non-Azure virtual machines in Azure. For more information, see [Azure Arc-enabled servers](/azure/azure-arc/servers/overview) and [Azure Arc-enabled Kubernetes](/azure/azure-arc/kubernetes/overview). Azure Arc-enabled servers support only Microsoft Entra authentication.

> [!NOTE]
> System-assigned managed identities aren't supported for remote write to Azure Monitor workspaces. Use a user-assigned managed identity or Microsoft Entra application authentication.

## Prerequisites

### Supported versions

* Prometheus versions later than 2.45 are required for managed identity authentication.
* Prometheus versions later than 2.48 are required for Microsoft Entra application authentication.

### Azure Monitor workspace

This article covers sending Prometheus metrics to an Azure Monitor workspace. To create an Azure monitor workspace, see [Manage an Azure Monitor workspace](azure-monitor-workspace-manage.md#create-an-azure-monitor-workspace).

### Permissions

Administrator permissions for the cluster or resource are required to complete the steps in this article.

## Set up authentication for remote write

Depending on the environment where Prometheus is running, you can configure remote write to use a user-assigned managed identity or Microsoft Entra application authentication to send data to an Azure Monitor workspace.

Use the Azure portal or the Azure CLI to create a user-assigned managed identity or Microsoft Entra application.

### [Remote write using a user-assigned managed identity](#tab/managed-identity)

### Remote write using user-assigned managed identity authentication

User-assigned managed identity authentication can be used in any Azure-managed environment. If your Prometheus service is running in a non-Azure environment, you can use Microsoft Entra application authentication.

To configure a user-assigned managed identity for remote write to an Azure Monitor workspace, complete the following steps.

#### Create a user-assigned managed identity

To create a user-managed identity to use in your remote write configuration, see [Manage user-assigned managed identities](/entra/identity/managed-identities-azure-resources/how-manage-user-assigned-managed-identities#create-a-user-assigned-managed-identity).

Note the value of `clientId` for the managed identity that you created. This ID is used in the Prometheus remote write configuration.

#### Assign the Monitoring Metrics Publisher role to the application

On the workspace's data collection rule, assign the Monitoring Metrics Publisher role to the managed identity:

1. On the Azure Monitor workspace's overview pane, select the **Data collection rule** link.

    :::image type="content" source="media/prometheus-remote-write-virtual-machines/select-data-collection-rule.png" lightbox="media/prometheus-remote-write-virtual-machines/select-data-collection-rule.png" alt-text="Screenshot that shows the link to a data collection rule on an Azure Monitor workspace pane.":::

1. On the page for the data collection rule, select **Access control (IAM)**.

1. Select **Add** > **Add role assignment**.

    :::image type="content" source="media/prometheus-remote-write-virtual-machines/data-collection-rule-access-control.png" lightbox="media/prometheus-remote-write-virtual-machines/data-collection-rule-access-control.png" alt-text="Screenshot that shows adding a role assignment for a data collection rule.":::

1. Search for and select **Monitoring Metrics Publisher**, and then select **Next**.

    :::image type="content" source="media/prometheus-remote-write-virtual-machines/add-role-assignment.png" lightbox="media/prometheus-remote-write-virtual-machines/add-role-assignment.png" alt-text="Screenshot that shows the role assignment menu for a data collection rule.":::

1. Select **Managed Identity**.

1. Choose **Select members**.

1. In the **Managed identity** dropdown list, select **User-assigned managed identity**.

1. Select the user-assigned identity that you want to use, and then choose **Select**.

    :::image type="content" source="media/prometheus-remote-write-virtual-machines/select-members.png" lightbox="media/prometheus-remote-write-virtual-machines/select-members.png" alt-text="Screenshot that shows selecting members and a user-assigned managed identity for a data collection rule.":::

1. Select **Review + assign** to complete the role assignment.

#### Assign the managed identity to a virtual machine or a virtual machine scale set

> [!IMPORTANT]
> To complete the steps in this section, you must have Owner or User Access Administrator permissions for the virtual machine or the virtual machine scale set.

1. In the Azure portal, go to the page for the cluster, virtual machine, or virtual machine scale set.
1. Select **Identity**.
1. Select **User assigned**.
1. Select **Add**.
1. Select the user-assigned managed identity that you created, and then select **Add**.

    :::image type="content" source="media/prometheus-remote-write-virtual-machines/assign-user-identity.png" lightbox="media/prometheus-remote-write-virtual-machines/assign-user-identity.png" alt-text="Screenshot that shows the pane for adding a user-assigned managed identity.":::

#### Assign the managed identity for Azure Kubernetes Service

For Azure Kubernetes Service, the managed identity must be assigned to virtual machine scale sets.

AKS creates a resource group that contains the virtual machine scale sets. The resource group name is in the format `MC_<resource group name>_<AKS cluster name>_<region>`.

For each virtual machine scale set in the resource group, assign the managed identity according to the steps in the previous section, [Assign the managed identity to a virtual machine or a virtual machine scale set](#assign-the-managed-identity-to-a-virtual-machine-or-a-virtual-machine-scale-set).

### [Microsoft Entra ID application](#tab/entra-application)

### Remote write using Microsoft Entra application authentication

You can use Microsoft Entra application authentication in any environment. If your Prometheus service is running in an Azure-managed environment, consider using user-assigned managed identity authentication.

To configure remote write to an Azure Monitor workspace by using a Microsoft Entra application, create a Microsoft Entra application. On the Azure Monitor workspace's data collection rule, assign the Monitoring Metrics Publisher role to the Microsoft Entra application.

> [!NOTE]
> Your Microsoft Entra application uses a client secret or password. Client secrets have an expiration date. Make sure to create a new client secret before it expires so you don't lose authenticated access.

#### Create a Microsoft Entra ID application

To create a Microsoft Entra ID application by using the portal, see  [Register an application with Microsoft Entra ID and create a service principal](/entra/identity-platform/howto-create-service-principal-portal#register-an-application-with-microsoft-entra-id-and-create-a-service-principal).

After you create your Microsoft Entra application, get the client ID and generate a client secret:

1. In the list of applications, copy the **Client ID** value for the registered application. This value is used in the Prometheus remote write configuration as the value for `client_id`.

    :::image type="content" source="media/prometheus-remote-write-virtual-machines/find-clinet-id.png" alt-text="Screenshot that shows the application or client ID of a Microsoft Entra application." lightbox="media/prometheus-remote-write-virtual-machines/find-clinet-id.png":::

1. Select **Certificates & secrets**.
1. Select **Client secrets**, and then select **New client secret** to create a secret.
1. Enter a description, set the expiration date, and then select **Add**.

    :::image type="content" source="media/prometheus-remote-write-virtual-machines/create-client-secret.png" alt-text="Screenshot that shows the pane for adding a client secret." lightbox="media/prometheus-remote-write-virtual-machines/create-client-secret.png":::

1. Copy the value of the secret securely. The value is used in the Prometheus remote write configuration as the value for `client_secret`. The client secret value is visible only when it's created, and you can't retrieve it later. If you lose it, you must create a new one.

    :::image type="content" source="media/prometheus-remote-write-virtual-machines/copy-client-secret.png" alt-text="Screenshot that shows a client secret value." lightbox="media/prometheus-remote-write-virtual-machines/copy-client-secret.png":::

#### Assign the Monitoring Metrics Publisher role to the application

Assign the Monitoring Metrics Publisher role on the workspace's data collection rule to the application:

1. On the Azure Monitor workspace's overview pane, select the **Data collection rule** link.

    :::image type="content" source="media/prometheus-remote-write-virtual-machines/select-data-collection-rule.png" alt-text="Screenshot that shows the link to a data collection rule for an Azure Monitor workspace." lightbox="media/prometheus-remote-write-virtual-machines/select-data-collection-rule.png":::

1. On the page for the data collection rule, select **Access control (IAM)**.

1. Select **Add**, and then select **Add role assignment**.

    :::image type="content" source="media/prometheus-remote-write-virtual-machines/data-collection-rule-access-control.png" alt-text="Screenshot that shows adding a role assignment for a data collection rule." lightbox="media/prometheus-remote-write-virtual-machines/data-collection-rule-access-control.png":::

1. Select the **Monitoring Metrics Publisher** role, and then select **Next**.

    :::image type="content" source="media/prometheus-remote-write-virtual-machines/add-role-assignment.png" lightbox="media/prometheus-remote-write-virtual-machines/add-role-assignment.png" alt-text="Screenshot that shows the role assignment box for a data collection rule.":::

1. Select **User, group, or service principal**, and then choose **Select members**. Select the application that you created, and then choose **Select**.

1. To complete the role assignment, select **Review + assign**.

    :::image type="content" source="media/prometheus-remote-write-virtual-machines/select-members-apps.png" alt-text="Screenshot that shows selecting an application to assign to a role." lightbox="media/prometheus-remote-write-virtual-machines/select-members-apps.png":::

### [Azure CLI](#tab/CLI)

### Creation of user-assigned identities and Microsoft Entra ID apps via the Azure CLI

#### Create a user-assigned managed identity

Create a user-assigned managed identity for remote write by using the following steps.

Note the value of `clientId` for the managed identity that you create. This ID is used in the Prometheus remote write configuration.

1. Create a user-assigned managed identity by using the following Azure CLI command:

    ```azurecli
    az account set \
    --subscription <subscription id>

    az identity create \
    --name <identity name> \
    --resource-group <resource group name>
    ```
  
    The following code is an example of the displayed output:

    ```azurecli
    {
      "clientId": "00001111-aaaa-2222-bbbb-3333cccc4444",
      "id": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourcegroups/rg-001/providers/Microsoft.ManagedIdentity/userAssignedIdentities/PromRemoteWriteIdentity",
      "location": "eastus",
      "name": "PromRemoteWriteIdentity",
      "principalId": "aaaaaaaa-bbbb-cccc-1111-222222222222",
      "resourceGroup": "rg-001",
      "systemData": null,
      "tags": {},
      "tenantId": "aaaabbbb-0000-cccc-1111-dddd2222eeee",
      "type": "Microsoft.ManagedIdentity/userAssignedIdentities"
    }
    ```

1. Assign the Monitoring Metrics Publisher role on the workspace's data collection rule to the managed identity:

    ```azurecli
    az role assignment create \
    --role "Monitoring Metrics Publisher" \
    --assignee <managed identity client ID> \
    --scope <data collection rule resource ID>
    ```

    For example:

    ```azurecli
    az role assignment create \
    --role "Monitoring Metrics Publisher" \
    --assignee 00001111-aaaa-2222-bbbb-3333cccc4444 \
    --scope /subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/MA_amw-001_eastus_managed/providers/Microsoft.Insights/dataCollectionRules/amw-001
    ```

1. Assign the managed identity to a virtual machine or a virtual machine scale set.

    Here are the commands for a virtual machine:

    ```azurecli
    az vm identity assign \
    -g <resource group name> \
    -n <virtual machine name> \
    --identities <user assigned identity resource ID>
    ```

    Here are the commands for a virtual machine scale set:

    ```azurecli
    az vmss identity assign \
    -g <resource group name> \
    -n <scale set name> \
    --identities <user assigned identity resource ID>
    ```

    The following example shows the commands for a virtual machine scale set:

    ```azurecli
    az vm identity assign \
    -g rg-prom-on-vm \
    -n win-vm-prom \
    --identities /subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourcegroups/rg-001/providers/Microsoft.ManagedIdentity/userAssignedIdentities/PromRemoteWriteIdentity
    ```

For more information, see [az identity create](/cli/azure/identity#az-identity-create) and [az role assignment create](/cli/azure/role/assignment#az-role-assignment-create).

#### Create a Microsoft Entra application

To create a Microsoft Entra application by using the Azure CLI, and assign the Monitoring Metrics Publisher role, run the following command:

```azurecli
az ad sp create-for-rbac --name <application name> \
--role "Monitoring Metrics Publisher" \
--scopes <azure monitor workspace data collection rule Id>
```

For example:

```azurecli
az ad sp create-for-rbac \
--name PromRemoteWriteApp \
--role "Monitoring Metrics Publisher" \
--scopes /subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/MA_amw-001_eastus_managed/providers/Microsoft.nsights/dataCollectionRules/amw-001
```

The following code is an example of the displayed output:

```azurecli
{
  "appId": "66667777-aaaa-8888-bbbb-9999cccc0000",
  "displayName": "PromRemoteWriteApp",
  "password": "Aa1Bb~2Cc3.-Dd4Ee5Ff6Gg7Hh8Ii9_Jj0Kk1Ll2",
  "tenant": "ffff5f5f-aa6a-bb7b-cc8c-dddddd9d9d9d"
}
```

The output contains the `appId` and `password` values. Save these values to use in the Prometheus remote write configuration as values for `client_id` and `client_secret`. The password or client secret value is visible only when it's created, and you can't retrieve it later. If you lose it, you must create a new one.

For more information, see [az ad app create](/cli/azure/ad/app#az-ad-app-create) and [az ad sp create-for-rbac](/cli/azure/ad/sp#az-ad-sp-create-for-rbac).

---

## Configure remote write

Remote write is configured in the Prometheus configuration file `prometheus.yml` or in Prometheus Operator.

For more information on configuring remote write, see this Prometheus.io article: [Configuration](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#remote_write). For information on tuning the remote write configuration, see [Remote write tuning](https://prometheus.io/docs/practices/remote_write/#remote-write-tuning).

### [Configure remote write for Prometheus running on virtual machines](#tab/prom-vm)

To send data to your Azure Monitor workspace, add the following section to the configuration file (`prometheus.yml`) of your self-managed Prometheus instance:

```yaml
remote_write:   
  - url: "<metrics ingestion endpoint for your Azure Monitor workspace>"
# Microsoft Entra ID configuration.
# The Azure cloud. Options are 'AzurePublic', 'AzureChina', or 'AzureGovernment'.
    azuread:
      cloud: 'AzurePublic'
      managed_identity:
        client_id: "<client-id of the managed identity>"
      oauth:
        client_id: "<client-id from the Entra app>"
        client_secret: "<client secret from the Entra app>"
        tenant_id: "<Azure subscription tenant Id>"
```

### [Configure remote write on Kubernetes for Prometheus Operator](#tab/prom-operator)

### Prometheus Operator

If you're on a Kubernetes cluster that's running Prometheus Operator, use the following steps to send data to your Azure Monitor workspace:

1. If you're using Microsoft Entra authentication, convert the secret by using Base64 encoding, and then apply the secret in your Kubernetes cluster. Save the following code into a YAML file. Skip this step if you're using managed identity authentication.

   ```yaml
   apiVersion: v1
   kind: Secret
   metadata:
     name: remote-write-secret
     namespace: monitoring # Replace with the namespace where Prometheus Operator is deployed.
   type: Opaque
   data:
     password: <base64-encoded-secret>

   ```

   Apply the secret:

   ```azurecli
   # Set context to your cluster 
   az aks get-credentials -g <aks-rg-name> -n <aks-cluster-name> 

   kubectl apply -f <remote-write-secret.yaml>
   ```

1. Update the values for the remote write section in Prometheus Operator. Copy the following YAML and save it as a file. For more information on the Azure Monitor workspace specification for remote write in Prometheus Operator, see the [Prometheus Operator documentation](https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/api-reference/api.md).

   ```yaml
   prometheus:
     prometheusSpec:
       remoteWrite:
       - url: "<metrics ingestion endpoint for your Azure Monitor workspace>"
         azureAd:
   # Microsoft Entra ID configuration.
   # The Azure cloud. Options are 'AzurePublic', 'AzureChina', or 'AzureGovernment'.
           cloud: 'AzurePublic'
           managedIdentity:
             clientId: "<clientId of the managed identity>"
           oauth:
             clientId: "<clientId of the Entra app>"
             clientSecret:
               name: remote-write-secret
               key: password
             tenantId: "<Azure subscription tenant Id>"
   ```

1. Use Helm to update your remote write configuration by using the preceding YAML file:

   ```azurecli
   helm upgrade -f <YAML-FILENAME>.yml prometheus prometheus-community/kube-prometheus-stack --namespace <namespace where Prometheus Operator is deployed>
   ```

---

The `url` parameter specifies the metrics ingestion endpoint of the Azure Monitor workspace. You can find it on the overview pane for your Azure Monitor workspace in the Azure portal.

:::image type="content" source="media/prometheus-remote-write-virtual-machines/metrics-ingestion-endpoint.png" lightbox="media/prometheus-remote-write-virtual-machines/metrics-ingestion-endpoint.png" alt-text="Screenshot that shows the metrics ingestion endpoint for an Azure Monitor workspace.":::

Use either `managed_identity` or `oauth` for Microsoft Entra application authentication, depending on your implementation. Remove the object that you're not using.

Find your client ID for the managed identity by using the following Azure CLI command:

```azurecli
az identity list --resource-group <resource group name>
```

For more information, see [az identity list](/cli/azure/identity#az-identity-list).

To find your client for managed identity authentication in the portal, go to **Managed Identities** in the Azure portal and select the relevant identity name. Copy the value of **Client ID** from the managed identity's **Overview** pane.

:::image type="content" source="media/prometheus-remote-write-virtual-machines/find-clinet-id.png" lightbox="media/prometheus-remote-write-virtual-machines/find-clinet-id.png" alt-text="Screenshot that shows the client ID on the managed identity's overview pane.":::

To find the client ID for the Microsoft Entra ID application, use the following Azure CLI command (or see the first step in the earlier [Remote write using Microsoft Entra application authentication](#remote-write-using-microsoft-entra-application-authentication) section):

```azurecli
$ az ad app list --display-name < application name>
```

For more information, see [az ad app list](/cli/azure/ad/app#az-ad-app-list).

> [!NOTE]
> After you edit the configuration file, restart Prometheus to apply the changes.

## Verify that remote write data is flowing

Use the following methods to verify that Prometheus data is being sent to your Azure Monitor workspace.

### Azure Monitor metrics explorer with PromQL

To check if the metrics are flowing to the Azure Monitor workspace, from your Azure Monitor workspace in the Azure portal, select **Metrics**. Use metrics explorer with Prometheus Query Language (PromQL) to query the metrics that you're expecting from the self-managed Prometheus environment. For more information, see [Azure Monitor metrics explorer with PromQL](metrics-explorer.md).

### Prometheus explorer in the Azure Monitor workspace

Prometheus explorer provides a convenient way to interact with Prometheus metrics within your Azure environment, so that monitoring and troubleshooting are more efficient. To use Prometheus explorer, go to your Azure Monitor workspace in the Azure portal and select **Prometheus Explorer**. You can then query the metrics that you're expecting from the self-managed Prometheus environment.

For more information, see [Query Prometheus metrics using Azure workbooks](prometheus-workbooks.md).

### Grafana

Use PromQL queries in Grafana to verify that the results return the expected data. To configure Grafana, see the [article about getting Grafana set up with managed Prometheus](prometheus-grafana.md).

## Troubleshoot remote write

If remote data isn't appearing in your Azure Monitor workspace, see [Troubleshoot remote write](../containers/prometheus-remote-write-troubleshooting.md) for common problems and solutions.

## Related content

* [Learn more about Azure Monitor managed service for Prometheus](prometheus-metrics-overview.md)
* [Learn about the Azure Monitor reverse proxy sidecar for remote write from self-managed Prometheus running on Kubernetes](../containers/prometheus-remote-write.md)
