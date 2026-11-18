---
title: Configure Azure Monitor pipeline
description: Configure Azure Monitor pipeline with settings and dataflow DCRs, associate them with the pipeline extension, and verify data collection.
ai-usage: ai-assisted
ms.topic: how-to
ms.date: 11/18/2026
ms.custom: references_regions, devx-track-azurecli
---

# Configure Azure Monitor pipeline

This article describes DCR-based configuration for [Azure Monitor pipeline](./pipeline-overview.md) on Arc-enabled Kubernetes (preview). The `microsoft.monitor.pipeline` extension runs the pipeline instance. Use one settings data collection rule (DCR) for its listening endpoints and TLS configuration, and one or more dataflow DCRs for collection and destination routing. Associate these DCRs with the extension to apply the configuration.

During public preview, use Azure CLI or ARM templates to deploy and manage this configuration, including native OpenTelemetry (OTel) logs, metrics, and traces. The existing Azure portal configuration experience continues to use the PipelineGroup-based model and doesn't configure the DCR-based preview.

For Linux VMs in Azure and Arc-enabled Linux servers, see [Configure Azure Monitor pipeline on Linux VMs (preview)](./pipeline-configure-vm.md). Those deployments use a VM extension and different DCR association scopes.

For an explanation of how endpoints, TLS configurations, streams, destinations, and associations fit together, see [Understand the configuration model](./pipeline-configure-cli.md#understand-the-configuration-model).

> [!NOTE]
> For an existing installation that uses the `microsoft.monitor.pipelinecontroller` extension, see [Legacy pipeline configuration](./pipeline-configure-legacy.md). That guide includes a command to check your installed extension type and version.

## Supported regions

During public preview of DCR-based configuration, the `microsoft.monitor.pipeline` extension is deployed in the following regions. Availability also depends on Azure Arc-enabled Kubernetes and the required Certificate Manager extension being supported in the cluster region.

- Australia Central
- Australia East
- Australia Southeast
- Austria East
- Belgium Central
- Brazil South
- Canada Central
- Canada East
- Central India
- Central US
- Chile Central
- Denmark East
- East Asia
- East US
- East US 2
- France Central
- Germany West Central
- Indonesia Central
- Italy North
- Japan East
- Japan West
- Jio India West
- Korea Central
- Korea South
- Malaysia West
- Mexico Central
- New Zealand North
- North Central US
- North Europe
- Norway East
- Poland Central
- Qatar Central
- South Africa North
- South Central US
- South India
- Southeast Asia
- Spain Central
- Sweden Central
- Switzerland North
- UAE North
- UK South
- UK West
- West Central US
- West Europe
- West India
- West US
- West US 2
- West US 3

For current public-region availability, see [Product availability by region](https://azure.microsoft.com/explore/global-infrastructure/products-by-region/table).

## Prerequisites

- An Azure subscription and permission to create pipeline extensions, DCRs, DCR associations, and role assignments. Deployment uses these permissions to create the resources, including the ingestion role assignment.
- An [Arc-enabled Kubernetes cluster](/azure/azure-arc/kubernetes/overview). To connect a cluster to Azure Arc, see [Connect an existing Kubernetes cluster to Azure Arc](/azure/azure-arc/kubernetes/quickstart-connect-cluster).
- [Install cert-manager](/azure/azure-arc/kubernetes/cert-manager-overview) on your Arc-enabled Kubernetes cluster before installing the pipeline extension.
- A Log Analytics workspace in a [supported region](#supported-regions). Create the DCRs in the workspace's region. To create a workspace, see [Create a Log Analytics workspace in the Azure portal](../logs/quick-create-workspace.md).
- An Azure Monitor workspace if you collect OpenTelemetry metrics. To create one, see [Create an Azure Monitor workspace](../metrics/azure-monitor-workspace-manage.md#create-an-azure-monitor-workspace).
- A custom table if your dataflow sends logs to a custom destination table. See [Create a custom log table in Azure Monitor](../logs/create-custom-table.md).
- Microsoft Sentinel enabled on the workspace if you collect CEF into the `CommonSecurityLog` table.
- Azure CLI and `kubectl` access to the cluster if you deploy with CLI or ARM templates.

## Choose a configuration method

Select the approach that fits your needs:

| Configuration | Method | Guidance |
| --- | --- | --- |
| DCR-based configuration on Arc-enabled Kubernetes (preview) | Azure CLI or ARM templates | [DCR-based deployment](./pipeline-configure-cli.md). |
| PipelineGroup-based configuration on Arc-enabled Kubernetes | Azure portal or existing CLI/ARM procedures | [Portal guide](./pipeline-configure-portal.md) and [PipelineGroup configuration](./pipeline-configure-legacy.md). |
| Linux VMs and Arc-enabled Linux servers (preview) | VM or Arc-enabled server extension | [Linux VM guide](./pipeline-configure-vm.md). |

## Set up the pipeline

Deploy the pipeline extension and configure its instance-specific settings and dataflows:

1. Install the `microsoft.monitor.pipeline` Arc extension with a managed identity. Set its version and namespace through the [extension deployment settings](./pipeline-configure-cli.md#configure-extension-settings).
1. Create a settings DCR with `kind: PipelineSettings`. Store runtime settings in `properties.pipelineSettings`, including named listening endpoints in `endpoints` and named TLS configurations in `tlsConfigurations`. For encrypted TCP ingestion, select a TLS configuration from each endpoint's `networkingConfig.tlsConfiguration`.
1. Create one or more dataflow DCRs. Define data sources, streams, destinations, and routing, and reference the named endpoints in the settings DCR.
1. Associate the settings DCR and each dataflow DCR with the same pipeline extension. Create each association under the Arc connected cluster and set `properties.scopeToResourceId` to the extension's full resource ID.
1. [Verify the configuration](#verify-the-configuration) before connecting data sources.

Deployment automatically assigns **Monitoring Metrics Publisher** to the extension's managed identity on the dataflow DCR. The provided ARM template includes the role-assignment resource, so you don't need a separate manual assignment. When extending the template with additional dataflow DCRs, include the corresponding role-assignment resources.

For deployment steps, use [Configure Azure Monitor pipeline with CLI or ARM templates](./pipeline-configure-cli.md).

### Connect data sources

Configure clients to send telemetry to the listening endpoints defined in the settings DCR.

- For clients outside the cluster, [configure a Kubernetes gateway](./pipeline-kubernetes-gateway.md) and point clients to its reachable IP address and port.
- For encrypted ingestion, review [TLS configuration](./pipeline-tls.md). Selecting TCP as the transport protocol doesn't enable TLS.
- Use UDP only on trusted networks because it doesn't encrypt telemetry.

## Verify the configuration

Check configuration delivery and telemetry delivery separately:

1. Confirm that the extension's provisioning state is `Succeeded` and its managed identity is available.
1. Confirm that the settings DCR and every dataflow DCR have an association referencing the intended DCR and the same pipeline extension.
1. Verify that the automatically created **Monitoring Metrics Publisher** role assignment targets the extension's managed identity on the dataflow DCR. This check of the deployment doesn't require a separate manual assignment step.
1. Check that the pipeline pods are running and the listener service is available.
1. Send a test message with a unique marker and query the destination workspace for that marker.

For commands and a Syslog test, see [Verify the deployment](./pipeline-configure-cli.md#verify-the-deployment).

### Verify pipeline components running in the cluster

Discover the collector service and pods by using the namespace and name of the installed pipeline extension, not a DCR or dataflow name:

```bash
kubectl get services,pods --namespace <extension-namespace> \
  --selector "app.kubernetes.io/instance=<extension-name>,app.kubernetes.io/name=pipeline"
```

Verify that the collector pods are ready and that the receiver service has type `ClusterIP` and exposes the configured ports.

Current pipeline deployments don't automatically create `<pipeline-name>-external-service`. For clients outside the cluster, configure and verify a separate gateway as described in [Configure a Kubernetes gateway for Azure Monitor pipeline](./pipeline-kubernetes-gateway.md).

### Verify heartbeat

Each pipeline that you configure in your pipeline instance sends a heartbeat record to the `Heartbeat` table in your Log Analytics workspace every minute. If the pipeline instance has multiple workspaces, the first configured workspace is used.

The `OSName`, `OSMajorVersion`, and `OSMinorVersion` columns describe the operating system in the pipeline collector container. These values can differ from the Kubernetes node's operating system. For example, an Azure Linux 3 container can report `OSMajorVersion` as `3` even when the nodes run Ubuntu. Don't use these columns to identify the pipeline instance or determine whether deployment succeeded.

To find the collector pod names for your pipeline, run:

```bash
kubectl get pods --namespace <extension-namespace> \
  --selector "app.kubernetes.io/instance=<extension-name>,app.kubernetes.io/name=pipeline"
```

Use the following query to check for recent heartbeat records from a collector pod. Replace `<collector-pod-name>` with a pod name from the command output, and repeat the query for each collector pod.

```kusto
Heartbeat
| where TimeGenerated > ago(15m)
| where Computer == "<collector-pod-name>"
| project TimeGenerated, Computer, OSName, OSMajorVersion, OSMinorVersion
| order by TimeGenerated desc
```

Heartbeat delivery doesn't by itself verify end-to-end ingestion of client data.

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

**Solution:** Install the Certificate Manager extension first to start the pipeline operator successfully. For installation instructions, see [Install cert-manager for Arc-enabled Kubernetes](/azure/azure-arc/kubernetes/cert-manager-overview).

Verify the Certificate Manager extension is installed:

```bash
az k8s-extension list --cluster-name <cluster-name> --resource-group <resource-group> --cluster-type connectedClusters --query "[?extensionType=='microsoft.certmanagement'].{Name:name, State:provisioningState}" -o table
```

The extension should show a `Succeeded` provisioning state.

</details>

## Related articles

- Continue with [Configure Azure Monitor pipeline using CLI or ARM templates](./pipeline-configure-cli.md).
- Expose the pipeline to external clients by using [Azure Monitor pipeline - Gateway for Kubernetes deployment](./pipeline-kubernetes-gateway.md).
- Configure client connections in [Configure a Kubernetes gateway for Azure Monitor pipeline](./pipeline-kubernetes-gateway.md).
- Modify data before it's sent to the cloud by using [pipeline transformations](./pipeline-transformations.md).
- Diagnose configuration and ingestion issues in [Troubleshoot Azure Monitor pipeline](./pipeline-troubleshoot.md).
