---
title: Configure Azure Monitor pipeline
description: Learn how to prepare your cluster, install cert-manager, and choose a configuration method for Azure Monitor pipeline.
ai-usage: ai-assisted
ms.topic: how-to
ms.date: 03/20/2026
ms.custom: references_regions, devx-track-azurecli
---

# Configure Azure Monitor pipeline

Use this article for initial setup for [Azure Monitor pipeline](./pipeline-overview.md). It prepares your Arc-enabled Kubernetes cluster for the pipeline by validating prerequisites, installing cert-manager, and routing you to the correct configuration method for your deployment.

## Use the shared setup flow

For a new deployment, use this sequence:

1. Complete the prerequisites in this article.
1. Install cert-manager on the Arc-enabled Kubernetes cluster.
1. Choose a configuration method:
   - [Configure Azure Monitor pipeline using the Azure portal](./pipeline-configure-portal.md)
   - [Configure Azure Monitor pipeline using CLI or ARM templates](./pipeline-configure-cli.md)
1. If clients need access from outside the cluster, expose the pipeline through a gateway. See [Azure Monitor pipeline - Gateway for Kubernetes deployment](./pipeline-kubernetes-gateway.md).
1. If you need encrypted ingestion, configure TLS. Start with [Azure Monitor pipeline TLS configuration](./pipeline-tls.md).
1. Configure your external clients to connect to the right gateway IP and port. See [Configure a Kubernetes gateway for Azure Monitor pipeline](./pipeline-kubernetes-gateway.md#add-a-new-client-to-an-existing-receiver).
1. If you need to filter, aggregate, or reshape incoming data, add [pipeline transformations](./pipeline-transformations.md).

## Prerequisites

- An [Arc-enabled Kubernetes cluster](/azure/azure-arc/kubernetes/overview) in your environment with an external IP address. To connect a cluster to Azure Arc, see [Connect an existing Kubernetes cluster to Azure Arc](/azure/azure-arc/kubernetes/quickstart-connect-cluster).
- Custom locations enabled on the Arc-enabled Kubernetes cluster. See [Create and manage custom locations on Azure Arc-enabled Kubernetes](/azure/azure-arc/kubernetes/custom-locations#enable-custom-locations-on-your-cluster).
- An Azure subscription with the following resource providers registered. See [Azure resource providers and types](/azure/azure-resource-manager/management/resource-providers-and-types).
  - `Microsoft.Insights`
  - `Microsoft.Monitor`
- A Log Analytics workspace in Azure Monitor to receive data from the pipeline. To create a workspace, see [Create a Log Analytics workspace in the Azure portal](../logs/quick-create-workspace.md).
- A DCR and DCE is required. These resources are created automatically when you create a pipeline and dataflow using the Azure portal. [Configure Azure Monitor pipeline using CLI or ARM templates](./pipeline-configure-cli.md) includes steps to create these resources.
- (Optional) A custom table in the Log Analytics workspace if you don't want to use the default `Syslog` or `CommonSecurityLog` tables for Syslog data. To create a custom table, see [Create a custom log table in Azure Monitor](../logs/create-custom-table.md).

## Install cert-manager for Arc-enabled Kubernetes

This section describes how to install cert-manager as an Azure Arc extension. You need to install cert-manager for the Azure Monitor pipeline. When you install cert-manager as a cluster managed extension (CME), it registers the `cert-manager` and `trust-manager` services on your cluster.

Supported Kubernetes distributions for the cert-manager extension on Arc-enabled Kubernetes include the following versions:
- VMware Tanzu Kubernetes Grid multicloud (TKGm) v1.28.11
- SUSE Rancher K3s v1.33.3+k3s1
- AKS Arc v1.32.7


### Remove existing cert-manager and trust-manager instances

> [!WARNING]
> Between uninstalling the open source version and installing the Arc extension, certificate rotation doesn't occur, and trust bundles aren't distributed to the new namespaces. Ensure this period is as short as possible to minimize potential security risks. Uninstalling the open source cert-manager and trust-manager doesn't remove any existing certificates or related resources you created. These resources remain usable once the Azure cert-manager is installed.

Remove any existing instances of `cert-manager` and `trust-manager` from the cluster. You must remove any open source versions before installing the Microsoft version. The specific steps for removal depend on your installation method. For detailed guidance, see [Uninstalling cert-manager](https://cert-manager.io/docs/installation/uninstall/) and [Uninstalling trust-manager](https://cert-manager.io/docs/trust/trust-manager/installation/#uninstalling). If you used Helm for installation, use the following command to check which namespaces cert-manager and trust-manager use.

`helm list -A | grep -E 'trust-manager|cert-manager'`

If you have an existing cert-manager extension installed, uninstall it by using the following commands:

```azurecli
export RESOURCE_GROUP="<resource-group-name>"
export CLUSTER_NAME="<arc-enabled-cluster-name>"
export LOCATION="<arc-enabled-cluster-location>"

NAME_OF_OLD_EXTENSION=$(az k8s-extension list --resource-group ${RESOURCE_GROUP} --cluster-name ${CLUSTER_NAME})
az k8s-extension delete --name ${NAME_OF_OLD_EXTENSION} --cluster-name ${CLUSTER_NAME} \
  --resource-group ${RESOURCE_GROUP} --cluster-type connectedClusters
```
### Install cert-manager extension

Use the following command to connect your cluster to Azure Arc if it isn't already connected.

```azurecli
az connectedk8s connect --name ${CLUSTER_NAME} --resource-group ${RESOURCE_GROUP} --location ${LOCATION}
```

Install the cert-manager extension by using the following command:

```azurecli
az k8s-extension create \
  --resource-group ${RESOURCE_GROUP} \
  --cluster-name ${CLUSTER_NAME} \
  --cluster-type connectedClusters \
  --name "azure-cert-management" \
  --extension-type "microsoft.certmanagement" \
  --release-train stable \
  --config subcharts.zdtrcontroller.enabled=true
```

## Choose a configuration method

Select the approach that fits your needs:

| Method | When to use | Key features |
|--------|-------------|--------------|
| **[Azure portal](./pipeline-configure-portal.md)** | * Getting started<br>* Simple configurations<br>* Quick deployment | * Guided UI experience<br>* Automatic component creation<br>* Built-in validation |
| **[CLI/ARM templates](./pipeline-configure-cli.md)** | * Advanced scenarios<br>* Automation needed<br>* Custom requirements | * Full configuration control<br>* Caching support<br>* Custom tables<br>* Infrastructure as code |

> [!TIP]
> **New to Azure Monitor pipeline?** Start with the portal. You can always switch to CLI/ARM templates later for advanced features.


## Verify the configuration

After you complete the configuration by using your chosen method, use the following steps to verify that the pipeline is running correctly in your environment.

### Verify pipeline components running in the cluster

In the Azure portal, go to the **Kubernetes services** menu and select your Azure Arc-enabled Kubernetes cluster. Select **Services and ingresses** and make sure that you see the following services:

* \<pipeline name\>-external-service
* \<pipeline name\>-service

:::image type="content" source="./media/pipeline-configure/pipeline-cluster-components.png" lightbox="./media/pipeline-configure/pipeline-cluster-components.png" alt-text="Screenshot of cluster components supporting Azure Monitor pipeline."::: 

Select the entry for **\<pipeline name\>-external-service** and note the IP address and port in the **Endpoints** column. This IP address and port is the external address that your clients send data to. For more information, see [Configure a Kubernetes gateway for Azure Monitor pipeline](./pipeline-kubernetes-gateway.md).

### Verify heartbeat

Each pipeline that you configure in your pipeline instance sends a heartbeat record to the `Heartbeat` table in your Log Analytics workspace every minute. The contents of the `OSMajorVersion` column should match the name of your pipeline instance. If the pipeline instance has multiple workspaces, the first configured workspace is used.

To retrieve the heartbeat records, use a log query as shown in the following example:

:::image type="content" source="./media/pipeline-configure/heartbeat-records.png" lightbox="./media/pipeline-configure/heartbeat-records.png" alt-text="Screenshot of log query that returns heartbeat records for Azure Monitor pipeline.":::

## Set up Private Link

When you enable Private Link, keep in mind the following key points about the architecture:

- Pipeline instances run inside a Kubernetes cluster ([AKS](/azure/aks/intro-kubernetes) or Azure Arc-enabled Kubernetes).
- The cluster connects to an Azure virtual network that hosts a [private endpoint](/azure/private-link/private-endpoint-overview).
- The pipeline exports telemetry privately to Azure Monitor by using:
  - [Azure Monitor Private Link Scope (AMPLS)](/azure/azure-monitor/logs/private-link-security)
  - A private endpoint in the customer-managed virtual network
- You disable public network access on the data collection endpoint (DCE).

> [!NOTE]
> Clients can still send telemetry to the pipeline's public, internal, or load-balancer endpoint. Private Link secures the cluster-to-Azure Monitor leg only.

### Prerequisites for Private Link

Before you begin, make sure you create the following resources:

- A Kubernetes cluster:
  - [Azure Kubernetes Service (AKS)](/azure/aks/intro-kubernetes), or
  - A Kubernetes cluster connected by using Azure Arc-enabled Kubernetes
- Network connectivity from the cluster to an Azure virtual network
- A Log Analytics workspace
- A data collection endpoint (DCE)
- A deployed Azure Monitor pipeline that exports to the DCE
- Azure CLI (latest version)
- Azure permissions to create:
  - Private endpoints
  - [Private DNS zones](/azure/dns/private-dns-overview)
  - [Azure Monitor Private Link Scopes](/azure/azure-monitor/logs/private-link-security)

> [!NOTE]
> For Azure Arc-enabled Kubernetes, create the private endpoint in an Azure virtual network reachable from the cluster, for example, via VPN, ExpressRoute, or a peered VNet.

### Identify the virtual network and subnet for the private endpoint

Create the private endpoint in a customer-managed Azure virtual network that the Kubernetes cluster can reach.

#### Supported scenarios

- **AKS** - Use the AKS node virtual network.
- **Azure Arc-enabled Kubernetes** - Use:
  - An Azure VNet connected through VPN or ExpressRoute, or
  - A peered VNet that the cluster can access

#### Requirements for the subnet

- The subnet must allow private endpoints.
- You must disable private endpoint network policies on the subnet.

Disable private endpoint network policies:

```azurecli
az network vnet subnet update \
  --ids <subnet-id> \
  --disable-private-endpoint-network-policies true
```

### Create a private endpoint for Azure Monitor

Create a private endpoint in the chosen Azure virtual network subnet and associate it with the Azure Monitor Private Link scope.

```azurecli
az network private-endpoint create \
  --name <private-endpoint-name> \
  --resource-group <resource-group> \
  --location <region> \
  --subnet <subnet-id> \
  --private-connection-resource-id <ampls-id> \
  --group-id azuremonitor \
  --connection-name <connection-name>
```

Retrieve the private endpoint IP address (used for validation):

```azurecli
az network private-endpoint show \
  --name <private-endpoint-name> \
  --resource-group <resource-group> \
  --query "networkInterfaces[0].id" -o tsv
```

### Configure private DNS zones

Link the [private DNS zones](/azure/azure-monitor/logs/private-link-configure#review-your-endpoints-dns-settings) to the Azure virtual network that hosts the private endpoint, not necessarily the Kubernetes cluster itself.

Make sure the following zones exist and are linked to the virtual network:

- `privatelink.monitor.azure.com`
- `privatelink.oms.opinsights.azure.com`
- `privatelink.ods.opinsights.azure.com`
- `privatelink.agentsvc.azure-automation.net`
- `privatelink.blob.core.windows.net`

> [!NOTE]
> Kubernetes clusters (including Azure Arc-enabled clusters) must be able to resolve these names through the virtual network DNS configuration.

### Validate Private Link

After configuration:

- Pipeline pods resolve Azure Monitor endpoints to private IP addresses.
- Telemetry flows into Log Analytics.
- The DCE blocks public network access.

For Azure Arc-enabled Kubernetes clusters, validate that:

- DNS resolution works from inside cluster pods.
- Network routing allows traffic to the Azure private endpoint.

## Troubleshooting

<details>
<summary><b>Operator pod in CrashLoopBackOff - Certificate Manager extension Not Found</b></summary>

If you see the operator pod continuously restarting with `CrashLoopBackOff` status as in the following example:

```bash
kubectl get pods -n mon
NAME                                                              READY   STATUS             RESTARTS       AGE
edge-pipeline-pipeline-operator-controller-manager-6f847d4njwcn   1/2     CrashLoopBackOff   11 (24s ago)   31m
```
Check the logs by using the following command:

```bash
kubectl logs <operator-pod-name> -n mon
```

You might see an error similar to the following message:

```
AttemptTlsBootstrap returned an error:  failed to apply resource: the server could not find the requested resource (patch clusterissuers.meta.k8s.io arc-amp-selfsigned-cluster-issuer)
Please ensure Azure Arc Cert Manager Extension is installed on the cluster.
panic: failed to apply resource: the server could not find the requested resource (patch clusterissuers.meta.k8s.io arc-amp-selfsigned-cluster-issuer)
```

**Cause:** The pipeline operator depends on the Azure Arc Certificate Manager extension, which provides the certificate infrastructure (`ClusterIssuer` resources). The operator can't start without it.

**Solution:** Install the Certificate Manager extension first to start the pipeline operator successfully. For installation instructions, see [Install cert-manager for Arc-enabled Kubernetes](./pipeline-configure.md#install-cert-manager-for-arc-enabled-kubernetes).

Verify the Certificate Manager extension is installed:

```bash
az k8s-extension list --cluster-name <cluster-name> --resource-group <resource-group> --cluster-type connectedClusters --query "[?extensionType=='microsoft.certmanagement'].{Name:name, State:provisioningState}" -o table
```

The extension should show a `Succeeded` provisioning state.

</details>

## Related articles

- Continue with [Configure Azure Monitor pipeline using the Azure portal](./pipeline-configure-portal.md) or [Configure Azure Monitor pipeline using CLI or ARM templates](./pipeline-configure-cli.md).
- Expose the pipeline to external clients by using [Azure Monitor pipeline - Gateway for Kubernetes deployment](./pipeline-kubernetes-gateway.md).
- Configure client connections in [Configure a Kubernetes gateway for Azure Monitor pipeline](./pipeline-kubernetes-gateway.md).
- Modify data before it's sent to the cloud by using [pipeline transformations](./pipeline-transformations.md).
