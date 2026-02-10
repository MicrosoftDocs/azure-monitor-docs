---
title: Configure Azure Monitor pipeline
description: Configure Azure Monitor pipeline which extends Azure Monitor data collection into your data center.
ms.topic: how-to
ms.date: 01/15/2026
ms.custom: references_regions, devx-track-azurecli
---

# Configure Azure Monitor pipeline

The [Azure Monitor pipeline](./pipeline-overview.md) extends the data collection capabilities of Azure Monitor to edge and multicloud environments. This article provides details on enabling and configuring the Azure Monitor pipeline in your environment. 

## Configuration methods
Start with the prerequisites and cert-manager installation steps in this article. Then use one of the following articles depending on your preferred configuration method:

- [Configure Azure Monitor pipeline using the Azure portal](./pipeline-configure-portal.md) for a simplified configuration experience that abstracts away the individual components of the pipeline. This method is recommended if you are new to the pipeline or prefer a more guided experience.
- [Configure Azure Monitor pipeline using CLI or ARM templates](./pipeline-configure.md) for more advanced configuration options such as enabling the cache and configuring custom tables. This method is recommended if you are comfortable with CLI or ARM templates and want more control over the configuration of your pipeline.

## Prerequisites

* [Arc-enabled Kubernetes cluster](/azure/azure-arc/kubernetes/overview) in your own environment with an external IP address. See [Connect an existing Kubernetes cluster to Azure Arc](/azure/azure-arc/kubernetes/quickstart-connect-cluster) for details on enabling Arc for a cluster.
* The Arc-enabled Kubernetes cluster must have the custom locations features enabled. See [Create and manage custom locations on Azure Arc-enabled Kubernetes](/azure/azure-arc/kubernetes/custom-locations#enable-custom-locations-on-your-cluster).
* Log Analytics workspace in Azure Monitor to receive the data from the pipeline. See [Create a Log Analytics workspace in the Azure portal](../logs/quick-create-workspace.md) for details on creating a workspace.
* The following resource providers must be registered in your Azure subscription. See [Azure resource providers and types](/azure/azure-resource-manager/management/resource-providers-and-types).
    * Microsoft.Insights
    * Microsoft.Monitor 
* Install cert-manager as described in the following section.

## Install cert-manager for Arc-enabled Kubernetes

This section describes how to install cert-manager as an Azure Arc extension. Installing cert-manager is required for Azure Monitor pipeline.

> [!NOTE]
>
> Supported Kubernetes distributions for cert‑manager extension on Arc-enabled Kubernetes include the following.
>
> - VMware Tanzu Kubernetes Grid multicloud (TKGm) v1.28.11
> - SUSE Rancher K3s v1.33.3+k3s1
> - AKS Arc v1.32.7

Installing cert-manager as a cluster managed extension (CME) will register the `cert-manager` and `trust-manager` services on your cluster.

Remove any existing instances of `cert‑manager` and `trust‑manager` from the cluster. Any open source versions must be removed before installing the Microsoft version.

> [!WARNING]
> Between uninstalling the open source version and installing the Arc extension, certificate rotation won't occur, and trust bundles won't be distributed to the new namespaces. Ensure this period is as short as possible to minimize potential security risks. Uninstalling the open source cert-manager and trust-manager doesn't remove any existing certificates or related resources you created. These will remain usable once the Azure cert-manager is installed.

The specific steps for removal will depend on your installation method. See [Uninstalling cert-manager](https://cert-manager.io/docs/installation/uninstall/) and [Uninstalling trust-manager](https://cert-manager.io/docs/trust/trust-manager/installation/#uninstalling) for detailed guidance. If you used Helm for installation, use the following command to check which namespace cert-manager and trust-manager installed using this command.

`helm list -A | grep -E 'trust-manager|cert-manager'`

If you have an existing cert-manager extension installed, uninstall it using the following commands:

```azurecli
export RESOURCE_GROUP="<resource-group-name>"
export CLUSTER_NAME="<arc-enabled-cluster-name>"
export LOCATION="<arc-enabled-cluster-location"

NAME_OF_OLD_EXTENSION=$(az k8s-extension list --resource-group ${RESOURCE_GROUP} --cluster-name ${CLUSTER_NAME})
az k8s-extension delete --name ${NAME_OF_OLD_EXTENSION} --cluster-name ${CLUSTER_NAME} \
  --resource-group ${RESOURCE_GROUP} --cluster-type connectedClusters
```

Use the following command to connect your cluster to Arc if it wasn't already connected.

```azurecli
az connectedk8s connect --name ${CLUSTER_NAME} --resource-group ${RESOURCE_GROUP} --location ${LOCATION}
```

Install the cert‑manager extension using the following command:

```azurecli
az k8s-extension create \
  --resource-group ${RESOURCE_GROUP} \
  --cluster-name ${CLUSTER_NAME} \
  --cluster-type connectedClusters \
  --name "azure-cert-management" \
  --extension-type "microsoft.certmanagement" \
  --release-train stable
```


## Verify configuration
Once you've complete the configuration using your chosen method, use the following steps verify that the pipeline is running correctly in your environment.

### Verify pipeline components running in the cluster

In the Azure portal, navigate to the **Kubernetes services** menu and select your Arc-enabled Kubernetes cluster. Select **Services and ingresses** and ensure that you see the following services:

* \<pipeline name\>-external-service
* \<pipeline name\>-service

:::image type="content" source="./media/pipeline-configure/pipeline-cluster-components.png" lightbox="./media/pipeline-configure/pipeline-cluster-components.png" alt-text="Screenshot of cluster components supporting Azure Monitor pipeline."::: 

Click on the entry for **\<pipeline name\>-external-service** and note the IP address and port in the **Endpoints** column. This is the external IP address and port that your clients will send data to. See [Retrieve ingress endpoint](./pipeline-configure-clients.md#retrieve-ingress-endpoint) for retrieving this address from the client.

### Verify heartbeat

Each pipeline configured in your pipeline instance will send a heartbeat record to the `Heartbeat` table in your Log Analytics workspace every minute. The contents of the `OSMajorVersion` column should match the name your pipeline instance. If there are multiple workspaces in the pipeline instance, then the first one configured will be used.

Retrieve the heartbeat records using a log query as in the following example:

:::image type="content" source="./media/pipeline-configure/heartbeat-records.png" lightbox="./media/pipeline-configure/heartbeat-records.png" alt-text="Screenshot of log query that returns heartbeat records for Azure Monitor pipeline.":::

## Troubleshooting

<details>
<summary><b>Operator pod in CrashLoopBackOff - Certificate Manager extension Not Found</b></summary>

If you see the operator pod continuously restarting with `CrashLoopBackOff` status as in the following example:

```bash
kubectl get pods -n mon
NAME                                                              READY   STATUS             RESTARTS       AGE
edge-pipeline-pipeline-operator-controller-manager-6f847d4njwcn   1/2     CrashLoopBackOff   11 (24s ago)   31m
```
Check the logs with the following command:

```bash
kubectl logs <operator-pod-name> -n mon
```

You may see an error similar to the following:

```
AttemptTlsBootstrap returned an error:  failed to apply resource: the server could not find the requested resource (patch clusterissuers.meta.k8s.io arc-amp-selfsigned-cluster-issuer)
Please ensure Azure Arc Cert Manager Extension is installed on the cluster.
panic: failed to apply resource: the server could not find the requested resource (patch clusterissuers.meta.k8s.io arc-amp-selfsigned-cluster-issuer)
```

**Cause:** The pipeline operator depends on the Azure Arc Certificate Manager extension, which provides the certificate infrastructure (`ClusterIssuer` resources). The operator cannot start without it.

**Solution:** Install the Certificate Manager extension first, then the pipeline operator will start successfully. See [Install cert-manager for Arc-enabled Kubernetes](./pipeline-configure.md#install-cert-manager-for-arc-enabled-kubernetes) for installation instructions.

Verify the Certificate Manager extension is installed:

```bash
az k8s-extension list --cluster-name <cluster-name> --resource-group <resource-group> --cluster-type connectedClusters --query "[?extensionType=='microsoft.certmanagement'].{Name:name, State:provisioningState}" -o table
```

The extension should show a `Succeeded` provisioning state.

## Next steps

* [Configure clients](./pipeline-configure-clients.md) to use the pipeline.
* Modify data before it's sent to the cloud using [pipeline transformations](./pipeline-transformations.md).
