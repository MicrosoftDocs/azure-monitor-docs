---
title: Remote-write in Azure Monitor Managed Service for Prometheus
description: Describes how to configure remote-write to send data from self-managed Prometheus running in your AKS cluster or Azure Arc-enabled Kubernetes cluster 
ms.topic: how-to
ms.date: 09/16/2024
---

# Connect self-managed Prometheus to Azure Monitor managed service for Prometheus
Azure Monitor managed service for Prometheus is intended to be a replacement for self managed Prometheus so you don't need to manage a Prometheus server in your Kubernetes clusters. There may be scenarios though where you want to continue to use self-managed Prometheus in your Kubernetes clusters while also sending data to Managed Prometheus for long term data retention and to create a centralized view across your clusters. This may be a temporary solution while you migrate to Managed Prometheus or a long term solution if you have specific requirements for self-managed Prometheus.


## Architecture
[Remote_write](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#remote_write) is a feature in Prometheus that allows you to send metrics from a local Prometheus instance to remote storage or to another Prometheus instance. Use this feature to send metrics from self-managed Prometheus running in your Kubernetes clusters or virtual machines to an Azure Monitor workspace used by Managed Prometheus.

The following diagram illustrates this configuration. A data collection rule (DCR) in Azure Monitor provides an endpoint for the self-managed Prometheus to send metrics to and defines the Azure Monitor workspace where the data will be sent.

:::image type="content" source="../metrics/media/prometheus-remote-write-configure/overview.png" alt-text="Diagram showing use of remote-write to send metrics from local Prometheus to Managed Prometheus." lightbox="../metrics/media/prometheus-remote-write-configure/overview.png"  border="false":::


## Authentication types
The configuration requirements for remote-write depend on the authentication type used to connect to the Azure Monitor workspace. The following table describes the supported authentication types. The details for each configuration are described in the following sections.

| Type | Clusters supported |
|:---|:---|
| System-assigned managed identity | Azure Kubernetes service (AKS)<br>Azure VM/VMSS |
| User-assigned managed identity | Azure Kubernetes service (AKS)<br>Arc-enabled Kubernetes<br>Azure VM/VMSS<br>Arc-enabled servers |
| Microsoft Entra ID | Azure Kubernetes service (AKS)<br>Arc-enabled Kubernetes cluster<br>Cluster running in another cloud or on-premises<br>Azure VM/VMSS<br>Arc-enabled servers<br>VM running in another cloud or on-premises|
| Microsoft Entra ID Workload Identity | Azure Kubernetes service (AKS)<br>Azure Arc-enabled Kubernetes cluster | Azure Monitor [side car container](/azure/architecture/patterns/sidecar) is required to provide an abstraction for ingesting Prometheus remote write metrics and helps in authenticating packets. See [Send Prometheus data to Azure Monitor by using Microsoft Entra Workload ID authentication](./prometheus-remote-write-azure-workload-identity.md) for configuration. |

## Azure Monitor workspace

Your Azure Monitor workspace must be created before you can configure remote-write. If you don't already have one, see [Manage an Azure Monitor workspace](azure-monitor-workspace-manage.md#create-an-azure-monitor-workspace).


## Create identity for authentication

### [System-assigned Managed identity](#tab/system-managed-identity)

**Azure VM/VMSS**
Select **Identity** under the **Settings** section of the menu for the VM/VMSS in the Azure portal to verify whether system-assigned managed identity is enabled. Ifnot, you can enable it from this page. See [Configure system-assigned managed identity](/entra/identity/managed-identities-azure-resources/how-to-configure-managed-identities#system-assigned-managed-identity) for details on enabling system-assigned managed identity in Azure VM/VMSS.

You can also enable system-assigned managed identity for an Azure VM using the following CLI command:

```azurecli
az vm identity assign --resource-group <resource-group-name> --name <vm-name>
```

**AKS**
For AKS, the managed identity must be assigned to virtual machine scale sets in the cluster. AKS creates a resource group that contains the virtual machine scale sets. Select **Properties** in the **Settings** section of the menu for the AKS cluster in the Azure portal, and the **Infrastructure resource group** will list this resource group. Select this resource group to view its virtual machine scale sets. Enable system-assigned managed identity for each from **Identity** in the **Settings** section of their menu in the Azure portal.

You can also enable system-assigned managed identity for an ASK cluster using the following CLI command:

```azurecli
az aks update --resource-group <resource-group-name> --name <cluster-name> --enable-managed-identity
```


### [User-assigned Managed identity](#tab/user-managed-identity)

**Azure portal**

1. Complete the steps to [Create a user-assigned managed identity](/entra/identity/managed-identities-azure-resources/how-manage-user-assigned-managed-identities#create-a-user-assigned-managed-identity)
2. Note the Application (client) ID which you'll need to configure remote-write.

**CLI**

```azurecli
# Create the managed identity
az identity create --name <identity name> --resource-group <resource group name>

# Assign to VM
az vm identity assign -g <resource group name> -n <virtual machine name> --identities <user assigned identity resource ID>

# Assign to VMSS
az vmss identity assign -g <resource group name> -n <scale set name> --identities <user assigned identity resource ID>

# Assign to AKS cluster
az aks update --resource-group <cluster-rg> --name <cluster-name> --assign-identity <uami-resource-id>
```


### [Entra ID](#tab/entra-id)

**Azure portal**

1. Complete the steps to [register an application with Microsoft Entra ID](/azure/active-directory/develop/howto-create-service-principal-portal) and create a service principal. Follow the option to create a [client secret](/azure/active-directory/develop/howto-create-service-principal-portal#option-3-create-a-new-client-secret).
2. Note the following values which you'll need to configure remote-write:
   - Application (client) ID
   - Directory (tenant) ID
   - Client secret value

**CLI**

```azurecli
az ad sp create-for-rbac --name <application name> --role "Monitoring Metrics Publisher" --scopes <azure monitor workspace data collection rule Id>
```
---

## Assign roles
Once the identity that you're going to use is created, it needs to be given access to the data collection rule (DCR) associated with the Azure Monitor workspace that will receive the remote-write data. You'll specify this identity in the remote-write configuration for the cluster or VM.

### [System-assigned Managed identity](#tab/managed-identity)

1. On the Azure Monitor workspace's overview pane, select the Data collection rule link. This opens the data collection rule (DCR) that is associated with the workspace.
2. On the page for the data collection rule, select **Access control (IAM)**.
3. Select **Add**  and then **Add role assignment**.
4. Select the **Monitoring Metrics Publisher** role, and then select **Next**.
5. Select **Managed Identity** and then **Select members**.
6. In the **Managed identity** dropdown, select **Kubernetes service** in the **System-assigned managed identity** section.
7. Select your cluster from the list, and then choose **Select**.
8. Select **Review + assign** to complete the role assignment.

```azurecli
az role assignment create --role "Monitoring Metrics Publisher" --assignee <managed identity client ID> --scope <data collection rule resource ID>
```

### [User-assigned Managed identity](#tab/managed-identity)

1. On the Azure Monitor workspace's overview pane, select the Data collection rule link. This opens the data collection rule (DCR) that is associated with the workspace.
2. On the page for the data collection rule, select **Access control (IAM)**.
3. Select **Add** and then **Add role assignment**.
4. Select the **Monitoring Metrics Publisher** role, and then select **Next**.
6. Select **Managed identity**, and then choose **Select members**. 
7. In the **Managed identity** dropdown, select **User-assigned managed identity** section. Select the identity that you created, and then choose **Select**.
8. Select **Review + assign** to complete the role assignment.

```azurecli
az role assignment create --role "Monitoring Metrics Publisher" --assignee <managed identity client ID> --scope <data collection rule resource ID>
```

### [Entra ID](#tab/entra-id)

1. On the Azure Monitor workspace's overview pane, select the Data collection rule link. This opens the data collection rule (DCR) that is associated with the workspace.
2. On the page for the data collection rule, select **Access control (IAM)**.
3. Select **Add**  and then **Add role assignment**.
4. Select the **Monitoring Metrics Publisher** role, and then select **Next**.
5. Select **User, group, or service principal**, and then choose **Select members**. Select the application that you created, and then choose **Select**.
6. Select **Review + assign** to complete the role assignment.

```azurecli
az role assignment create --role "Monitoring Metrics Publisher" --assignee-object-id <sp-object-id> --assignee-principal-type ServicePrincipal --scope <data collection rule resource ID>
```

---


## Configure remote-write in self-managed Prometheus
The final step is to add remote write to the configuration of your self-managed Prometheus server. In addition to details for the identity that you created, you'll also need the metrics ingestion endpoint for the Azure Monitor workspace. Get this value from the **Overview** page for your Azure Monitor workspace in the Azure portal.

:::image type="content" source="media/prometheus-remote-write-virtual-machines/metrics-ingestion-endpoint.png" lightbox="media/prometheus-remote-write-virtual-machines/metrics-ingestion-endpoint.png" alt-text="Screenshot that shows the metrics ingestion endpoint for an Azure Monitor workspace.":::


```azurecli
remote_write:   
  - url: "<metrics ingestion endpoint for your Azure Monitor workspace>"
    azuread:
      cloud: 'AzurePublic'  # Options are 'AzurePublic', 'AzureChina', or 'AzureGovernment'.
      managed_identity:  
        client_id: "<client-id of the managed identity>"
      oauth:  
        client_id: "<client-id from the Entra app>"
        client_secret: "<client secret from the Entra app>"
        tenant_id: "<Azure subscription tenant Id>"
```

```azurecli
remote_write:   
  - url: "<metrics ingestion endpoint for your Azure Monitor workspace>"
    azuread:
      cloud: 'AzurePublic'  # Options are 'AzurePublic', 'AzureChina', or 'AzureGovernment'.
      managed_identity:  
        client_id: "<client-id of the managed identity>"
      oauth:  
        client_id: "<client-id from the Entra app>"
        client_secret: "<client secret from the Entra app>"
        tenant_id: "<Azure subscription tenant Id>"
```

**VM/VMSS**


## Configure remote-write in self-managed Prometheus
Remote write is configured in the Prometheus configuration file `prometheus.yml`.

```yml
  GNU nano 6.4                                                                                             prometheus.yaml                                                                                                       
apiVersion: v1
kind: ConfigMap
metadata:
  name: prometheus-server-conf
  namespace: monitoring
data:
  prometheus.yml: |-
   global:
     scrape_interval: 15s
     evaluation_interval: 15s
     external_labels:
       cluster: "aks11"

   scrape_configs:
     - job_name: "prometheus"
       static_configs:
         - targets: ["localhost:9090"]

   remote_write:
     - url: "https://aks-amw-0mi2.eastus-1.metrics.ingest.monitor.azure.com/dataCollectionRules/dcr-17695c1c649c4ff6a8b5fbdd64f96bdd/streams/Microsoft-PrometheusMetrics/api/v1/write?api-version=2023-04-24"
       azuread:
         cloud: 'AzurePublic'
         managed_identity:
         #  client_id: "381a840f-f3c9-426b-9259-d868b14d9b38"
           client_id: ""
         #oauth:
         #  client_id: "8e547ddf-a7de-46ed-9269-5526a55d3211"
```



| Authentication | 

## Release notes

For detailed release notes on the remote write side car image, please refer to the [remote write release notes](https://github.com/Azure/prometheus-collector/blob/main/REMOTE-WRITE-RELEASENOTES.md).


## Next steps

- [Learn more about Azure Monitor managed service for Prometheus](../essentials/prometheus-metrics-overview.md).
- [Collect Prometheus metrics from an AKS cluster](../containers/kubernetes-monitoring-enable.md)
