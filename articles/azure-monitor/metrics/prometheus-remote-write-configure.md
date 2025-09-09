---
title: Connect self-managed Prometheus to Azure Monitor managed service for Prometheus
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
| User-assigned managed identity | Azure Kubernetes service (AKS)<br>Arc-enabled Kubernetes<br>Azure VM/VMSS |
| Microsoft Entra ID | Azure Kubernetes service (AKS)<br>Arc-enabled Kubernetes cluster<br>Cluster running in another cloud or on-premises<br>Azure VM/VMSS<br>Arc-enabled servers<br>VM running in another cloud or on-premises|

> [!NOTE]
>  You can also use authentication with Microsoft Entra ID Workload Identity, but you must use a [side car container](/azure/architecture/patterns/sidecar) to provide an abstraction for ingesting Prometheus remote write metrics and helps in authenticating packets. See [Send Prometheus data to Azure Monitor using Microsoft Entra Workload ID authentication](./prometheus-remote-write-azure-workload-identity.md) for configuration. |

## Azure Monitor workspace

Your Azure Monitor workspace must be created before you can configure remote-write. This automatically enables Managed prometheus. If you don't already have one, see [Manage an Azure Monitor workspace](azure-monitor-workspace-manage.md#create-an-azure-monitor-workspace). 


## Create identity for authentication
Before you can configure remote-write, you must create the identity that you'll use to authenticate to the Azure Monitor workspace. The following sections describe how to create each type of identity if you aren't reusing an existing one.

### [System-assigned Managed identity](#tab/system-managed-identity)

You don't directly create a system-assigned managed identity but instead enable it for an Azure virtual machine or virtual machine scale set. For an Azure VM, you can enable the identity when you create the VM or enable it later from its **Identity** page in the Azure portal. For a VMSS, you must enable it after creation. For the different options to enable system-managed identity, see [Configure managed identities on Azure virtual machines (VMs)](/entra/identity/managed-identities-azure-resources/how-to-configure-managed-identities) and [Configure managed identities for Azure resources on a virtual machine scale set](/entra/identity/managed-identities-azure-resources/how-to-configure-managed-identities-scale-sets).

:::image type="content" source="media/prometheus-remote-write-configure/enable-system-assigned-managed-identity.png" lightbox="media/prometheus-remote-write-configure/enable-system-assigned-managed-identity.png" alt-text="Screenshot that shows the screen to enable system-assigned managed identity for an Azure VM.":::

For an AKS cluster, the managed identity must be assigned to virtual machine scale sets in the cluster. AKS creates a resource group that contains the virtual machine scale sets. Access this resource group from the **Properties** page in the cluster's menu in the Azure portal. Click on **Infrastructure Resource Group** to view list the resources in this resource group. You must enable system managed identity for each virtual machine scale set in the resource group.

:::image type="content" source="media/prometheus-remote-write-configure/infrastructure-resource-group.png" lightbox="media/prometheus-remote-write-configure/infrastructure-resource-group.png" alt-text="Screenshot that shows the infrastructure resource group for an AKS cluster.":::


### [User-assigned Managed identity](#tab/user-managed-identity)

Create a user-assigned managed identity from the **Managed Identities** menu in the Azure portal. See [Manage user-assigned managed identities](/entra/identity/managed-identities-azure-resources/how-manage-user-assigned-managed-identities) for different methods to create a user-assigned managed identity.

Note the **Client ID** of the user-assigned managed identity. You'll need this value later to configure remote-write.

:::image type="content" source="media/prometheus-remote-write-configure/user-assigned-managed-identity.png" lightbox="media/prometheus-remote-write-configure/user-assigned-managed-identity.png" alt-text="Screenshot that shows the details of a user-assigned managed identity.":::


### [Entra ID](#tab/entra-id)

Create an Entra ID from the **Entra ID > App registrations** menu in the Azure portal. See [Register an application with Microsoft Entra ID](/azure/active-directory/develop/quickstart-register-app) for more details and [Create an Azure service principal with Azure CLI](/cli/azure/azure-cli-sp-tutorial-1) and [Use Azure PowerShell to create a service principal with a certificate](/entra/identity-platform/howto-authenticate-service-principal-powershell) for different methods to create an Entra ID.

Note the **Application (client) ID** and **Directory (tenant) ID** of the Entra ID application. You'll need these values later to configure remote-write.

:::image type="content" source="media/prometheus-remote-write-configure/app-registration.png" lightbox="media/prometheus-remote-write-configure/app-registration.png" alt-text="Screenshot that shows the details of an Entra ID.":::

Follow the guidance at [Option 3: Create a new client secret](/entra/identity-platform/howto-create-service-principal-portal#option-3-create-a-new-client-secret) to create a client secret for the Entra ID application. Note the **Value** of the client secret. You'll need this value later to configure remote-write.

:::image type="content" source="media/prometheus-remote-write-configure/client-secret.png" lightbox="media/prometheus-remote-write-configure/client-secret.png" alt-text="Screenshot that shows the client secret for an Entra ID.":::

---

## Assign roles
Once the identity that you're going to use is created, it needs to be given access to the data collection rule (DCR) associated with the Azure Monitor workspace that will receive the remote-write data. This DCR is automatically created when you create the workspace. You'll specify this identity in the remote-write configuration for the cluster or VM.

1. On the Azure Monitor workspace's overview pane, select the Data collection rule link. This opens the data collection rule (DCR) that is associated with the workspace.

    :::image type="content" source="media/prometheus-remote-write-configure/azure-monitor-workspace-data-collection-rule.png" lightbox="media/prometheus-remote-write-configure/azure-monitor-workspace-data-collection-rule.png" alt-text="Screenshot that shows the DCR link for an Azure Monitor workspace.":::

2. On the page for the data collection rule, select **Access control (IAM)**. Select **Add**  and then **Add role assignment**.

    :::image type="content" source="media/prometheus-remote-write-configure/data-collection-rule-access-control.png" lightbox="media/prometheus-remote-write-configure/data-collection-rule-access-control.png" alt-text="Screenshot that shows the Access Control page for a DCR.":::

4. Select the **Monitoring Metrics Publisher** role, and then select **Next**.
  
    :::image type="content" source="media/prometheus-remote-write-configure/add-role-assignment.png" lightbox="media/prometheus-remote-write-configure/add-role-assignment.png" alt-text="Screenshot that shows adding a role assignment to a DCR.":::

5. Select the identity to be assigned the role.
   1. For system-assigned managed identity, select **Managed identity** and then **Select members**. In the **Managed identity** dropdown, select the VM/VMSS or each of the VMSS in the AKS cluster.

    :::image type="content" source="media/prometheus-remote-write-configure/select-members-system-managed-identity.png" lightbox="media/prometheus-remote-write-configure/select-members-system-managed-identity.png" alt-text="Screenshot that shows selection of system-assigned managed identity members.":::

   2. For user-assigned managed identity, select **User-assigned managed identity** section. Select the identity that you created.

    :::image type="content" source="media/prometheus-remote-write-configure/select-members-user-managed-identity.png" lightbox="media/prometheus-remote-write-configure/select-members-user-managed-identity.png" alt-text="Screenshot that shows selection of managed identity members.":::

   3. For Entra ID, select **User, group, or service principal**, and then **Select members**. Select the application that you created, and then choose **Select**.

    :::image type="content" source="media/prometheus-remote-write-configure/select-members-entra-id.png" lightbox="media/prometheus-remote-write-configure/select-members-entra-id.png" alt-text="Screenshot that shows selection of Entra ID members.":::

8. Select **Select** to confirm your selection and then **Review + assign** to complete the role assignment.

---


## Configure remote-write in configuration file
The final step is to add remote write to the [configuration file](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#configuration-file) for your self-managed Prometheus server. In addition to details for the identity that you created, you'll also need the metrics ingestion endpoint for the Azure Monitor workspace. Get this value from the **Overview** page for your Azure Monitor workspace in the Azure portal.

:::image type="content" source="media/prometheus-remote-write-virtual-machines/metrics-ingestion-endpoint.png" lightbox="media/prometheus-remote-write-virtual-machines/metrics-ingestion-endpoint.png" alt-text="Screenshot that shows the metrics ingestion endpoint for an Azure Monitor workspace.":::

The `remote-write` section of the Prometheus configuration file will look similar to the following example, depending on the authentication type that you are using.

**Managed identity**

```azurecli
remote_write:   
  - url: "<metrics ingestion endpoint for your Azure Monitor workspace>"
    azuread:
      cloud: 'AzurePublic'  # Options are 'AzurePublic', 'AzureChina', or 'AzureGovernment'.
      managed_identity:  
        client_id: "<client-id of the managed identity>"
```

**Entra ID**

```azurecli
remote_write:   
  - url: "<metrics ingestion endpoint for your Azure Monitor workspace>"
    azuread:
      cloud: 'AzurePublic'  # Options are 'AzurePublic', 'AzureChina', or 'AzureGovernment'.
      oauth:  
        client_id: "<client-id from the Entra app>"
        client_secret: "<client secret from the Entra app>"
        tenant_id: "<Azure subscription tenant Id>"
```

## Apply configuration file updates

### Virtual Machine
For a virtual machine, the configuration file will be `promtheus.yml` unless you specify a different one using `prometheus --config.file <path-to-config-file>` when starting the Prometheus server.

### Kubernetes cluster
For a Kubernetes cluster, the configuration file is typically stored in a ConfigMap. Following is a sample ConfigMap that includes a remote-write configuration using managed identity  for self-managed Prometheus running in a Kubernetes cluster. 

```yml
  GNU nano 6.4
apiVersion: v1
kind: ConfigMap
metadata:
  name: prometheus-server-conf # must match what your pod mounts
  namespace: monitoring  # adjust to your namespace
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
     - url: "https://aks-amw-0mi2.eastus-1.metrics.ingest.monitor.azure.com/dataCollectionRules/dcr-00000000000000000000000000000000/streams/Microsoft-PrometheusMetrics/api/v1/write?api-version=2023-04-24"
       azuread:
         cloud: 'AzurePublic'
         managed_identity:
           client_id: "00001111-aaaa-2222-bbbb-3333cccc4444"
```

Use the following command  to apply the configuration file updates.

```bash
kubectl apply -f <configmap-file-name>.yaml
```

Restart Prometheus to pick up the new configuration. If you are using a deployment, you can restart the pods by running the following command:

```bash
kubectl -n monitoring rollout restart deploy <prometheus-deployment-name>
```

## Release notes

For detailed release notes on the remote write side car image, please refer to the [remote write release notes](https://github.com/Azure/prometheus-collector/blob/main/REMOTE-WRITE-RELEASENOTES.md).

## Troubleshoot

**HTTP 403 error in the Prometheus log**

It takes about 30 minutes for the assignment of the role to take effect. During this time, you may see an HTTP 403 error in the Prometheus log. Check that you have configured the managed identity or Microsoft Entra ID application correctly with the `Monitoring Metrics Publisher` role on the workspace's DCR. If the configuration is correct, wait 30 minutes for the role assignment to take effect.


**No Kubernetes data is flowing**

If remote data isn't flowing, run the following command to find errors in the remote write container.

```azurecli
kubectl --namespace <Namespace> describe pod <Prometheus-Pod-Name>
```


**Container restarts repeatedly**

A container regularly restarting is likely due to misconfiguration of the container. Run the following command to view the configuration values set for the container. Verify the configuration values especially `AZURE_CLIENT_ID` and `IDENTITY_TYPE`.

```azureccli
kubectl get pod <Prometheus-Pod-Name> -o json | jq -c  '.spec.containers[] | select( .name | contains("<Azure-Monitor-Side-Car-Container-Name>"))'
```

The output from this command has the following format:

```
{"env":[{"name":"INGESTION_URL","value":"https://my-azure-monitor-workspace.eastus2-1.metrics.ingest.monitor.azure.com/dataCollectionRules/dcr-00000000000000000/streams/Microsoft-PrometheusMetrics/api/v1/write?api-version=2021-11-01-preview"},{"name":"LISTENING_PORT","value":"8081"},{"name":"IDENTITY_TYPE","value":"userAssigned"},{"name":"AZURE_CLIENT_ID","value":"00000000-0000-0000-0000-00000000000"}],"image":"mcr.microsoft.com/azuremonitor/prometheus/promdev/prom-remotewrite:prom-remotewrite-20221012.2","imagePullPolicy":"Always","name":"prom-remotewrite","ports":[{"containerPort":8081,"name":"rw-port","protocol":"TCP"}],"resources":{},"terminationMessagePath":"/dev/termination-log","terminationMessagePolicy":"File","volumeMounts":[{"mountPath":"/var/run/secrets/kubernetes.io/serviceaccount","name":"kube-api-access-vbr9d","readOnly":true}]}
```


**Ingestion quotas and limits**

When configuring Prometheus remote write to send data to an Azure Monitor workspace, you typically begin by using the remote write endpoint displayed on the Azure Monitor workspace overview page. This endpoint involves a system-generated Data Collection Rule (DCR) and Data Collection Endpoint (DCE). These resources have ingestion limits. For more information on ingestion limits, see [Azure Monitor service limits](../service-limits.md#prometheus-metrics). When setting up remote write for multiple clusters sending data to the same endpoint, you might reach these limits. Consider [Remote write tuning](https://prometheus.io/docs/practices/remote_write/) to adjust configuration settings for better performance. If you still see data drops, consider creating additional DCRs and DCEs to distribute the ingestion load across multiple endpoints. This approach helps optimize performance and ensures efficient data handling. For more information about creating DCRs and DCEs, see [how to create custom Data collection endpoint(DCE) and custom Data collection rule(DCR) for an existing Azure monitor workspace(AMW) to ingest Prometheus metrics](https://aka.ms/prometheus/remotewrite/dcrartifacts).


## Next steps

- [Learn more about Azure Monitor managed service for Prometheus](../essentials/prometheus-metrics-overview.md).
- [Collect Prometheus metrics from an AKS cluster](../containers/kubernetes-monitoring-enable.md)
