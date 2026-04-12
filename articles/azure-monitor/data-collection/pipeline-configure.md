---
title: Configure Azure Monitor pipeline
description: Learn how to prepare your cluster, install cert-manager, and choose a configuration method for Azure Monitor pipeline.
ai-usage: ai-assisted
ms.topic: how-to
ms.date: 03/20/2026
ms.custom: references_regions, devx-track-azurecli
---

# Configure Azure Monitor pipeline

This article describes the overall setup process for [Azure Monitor pipeline](./pipeline-overview.md) and provides details for the initial common setup to prepare your Arc-enabled Kubernetes cluster for the pipeline. 

## Complete setup flow

Complete deployment of an Azure Monitor pipeline includes the following steps:

1. Verify the [prerequisites](#prerequisites).
1. [Install cert-manager](#install-cert-manager-for-arc-enabled-kubernetes) on your Arc-enabled Kubernetes cluster.
1. Complete deployment of the pipeline by using either of the following methods:
   - [Configure Azure Monitor pipeline using the Azure portal](./pipeline-configure-portal.md)
   - [Configure Azure Monitor pipeline using CLI or ARM templates](./pipeline-configure-cli.md)
1. If you need to filter, aggregate, or reshape incoming data:
    1. Add [pipeline transformations](./pipeline-transformations.md).
1. If client data sources are outside the cluster:
    1. Expose the pipeline through a gateway. See [Azure Monitor pipeline - Gateway for Kubernetes deployment](./pipeline-kubernetes-gateway.md).
    1. Configure your external clients to connect to the right gateway IP and port. See [Configure a Kubernetes gateway for Azure Monitor pipeline](./pipeline-kubernetes-gateway.md#add-a-new-client-to-an-existing-receiver).
1. If you need encrypted ingestion:
    1. Configure TLS. Start with [Azure Monitor pipeline TLS configuration](./pipeline-tls.md).
1. If default pod placement behavior doesn't meet your performance, isolation, or compliance needs:
    1. Configure [pod placement](./pipeline-pod-placement.md) for the pipeline.

:::image type="content" source="media/pipeline-configure/pipeline-setup-flow.png" alt-text="Diagram of Azure Monitor pipeline setup flow with steps for prerequisites, cert-manager, deployment, and decision points for data, TLS, clients, and scheduling.":::


## Prerequisites

- Azure subscription with the following resource providers registered. See [Azure resource providers and types](/azure/azure-resource-manager/management/resource-providers-and-types).
  - `Microsoft.Insights`
  - `Microsoft.Monitor`
- [Arc-enabled Kubernetes cluster](/azure/azure-arc/kubernetes/overview) in your environment with an external IP address. To connect a cluster to Azure Arc, see [Connect an existing Kubernetes cluster to Azure Arc](/azure/azure-arc/kubernetes/quickstart-connect-cluster).
- Custom locations enabled on the Arc-enabled Kubernetes cluster. See [Create and manage custom locations on Azure Arc-enabled Kubernetes](/azure/azure-arc/kubernetes/custom-locations#enable-custom-locations-on-your-cluster).
- Log Analytics workspace to receive logs from the pipeline. To create a workspace, see [Create a Log Analytics workspace in the Azure portal](../logs/quick-create-workspace.md).
  - (Optional) A custom table in the Log Analytics workspace if you don't want to use the default `Syslog` or `CommonSecurityLog` tables for Syslog data. To create a custom table, see [Create a custom log table in Azure Monitor](../logs/create-custom-table.md).

## Install cert-manager for Arc-enabled Kubernetes

This section describes how to install cert-manager as an Azure Arc extension. You need to install cert-manager for the Azure Monitor pipeline. When you install cert-manager as a cluster managed extension (CME), it registers the `cert-manager` and `trust-manager` services on your cluster.

For the currently supported Kubernetes distributions and regions, see [Supported configurations](./pipeline-overview.md#supported-configurations).


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
| **[CLI/ARM templates](./pipeline-configure-cli.md)** | * Advanced scenarios<br>* Automation needed<br>* Custom requirements | * Full configuration control<br>* Buffering to persistent volume<br>* Custom tables<br>* Infrastructure as code |

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

## Configure private link
Configure [Azure Private Link](../fundamentals/private-link-security.md) to connect to Azure Monitor using a private endpoint. See [Configure private link for Azure Monitor](../fundamentals/private-link-configure.md) for details on creating an Azure Monitor Private link scope and connecting it to a Log Analytics workspace.

When you use private link with Azure Monitor pipeline, keep in mind the following key points about the architecture:

- Pipeline instances run inside an Azure Arc-enabled Kubernetes cluster.
- The cluster connects to an Azure virtual network that hosts a [private endpoint](/azure/private-link/private-endpoint-overview).
- Disable public network access on the data collection endpoint (DCE). The pipeline exports telemetry privately to Azure Monitor by using:
  - [Azure Monitor Private Link Scope (AMPLS)](/azure/azure-monitor/logs/private-link-security)
  - A private endpoint in the customer-managed virtual network

> [!NOTE]
> Clients can still send telemetry to the pipeline's public, internal, or load-balancer endpoint. Private Link only secures the connection from the cluster to Azure Monitor.

### Create virtual network and subnet for the private endpoint

[Create the private endpoint](../fundamentals/private-link-configure.md) in a customer-managed Azure virtual network that the Kubernetes cluster can reach.

### Configure private DNS zones

Link the [private DNS zones](../fundamentals/private-link-configure.md) to the Azure virtual network that hosts the private endpoint, not necessarily the Kubernetes cluster itself. Make sure each of the zones exists and is linked to the virtual network.

> [!NOTE]
> Kubernetes clusters (including Azure Arc-enabled clusters) must be able to resolve these names through the virtual network DNS configuration.


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
