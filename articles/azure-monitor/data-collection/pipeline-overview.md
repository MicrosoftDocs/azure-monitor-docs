---
title: What is Azure Monitor pipeline?
description: Learn what Azure Monitor pipeline is, when to use it, the shared prerequisites, and the recommended setup sequence for edge and multicloud data collection.
ai-usage: ai-assisted
ms.topic: overview
ms.date: 03/20/2026
ms.custom: references_regions, devx-track-azurecli, doc-kit-assisted
---


# What is Azure Monitor pipeline?

Azure Monitor pipeline extends Azure Monitor data collection to local datacenters and multicloud environments. You deploy it on an [Arc-enabled Kubernetes cluster](/azure/azure-arc/kubernetes/overview) so you can collect, transform, route, and buffer telemetry before sending it to Azure Monitor in the cloud.

This article is the starting point for Azure Monitor pipeline. Use it to understand when to use the pipeline, what you need before you begin, and the recommended sequence for setting up end-to-end data collection.

## Why use Azure Monitor pipeline

Use Azure Monitor pipeline when you need Azure Monitor data collection to work beyond a direct cloud-connected model.

- **Scalability**. The pipeline can handle large volumes of data from monitored resources that other collection methods, such as Azure Monitor agent, might limit.
- **Periodic connectivity**. Some environments have unreliable connectivity to the cloud or long unexpected periods without connection. There might also be periods of planned maintenance or need to temporarily disconnect from internet for security reasons. The pipeline can cache data locally and sync with the cloud when connectivity is restored.
- **Reduce network bandwidth**. Transformations in Azure Monitor pipeline can filter and aggregate data before sending it to the cloud, reducing the amount of data transmitted over the network.
- **Centralized ingress for external clients**. A gateway can expose pipeline receivers to clients outside the cluster when those clients can't connect directly to Azure Monitor.

## How Azure Monitor pipeline works

The pipeline is a containerized solution that runs on an Arc-enabled Kubernetes cluster in your datacenter or another cloud provider. It's built on open-source technologies from the OpenTelemetry ecosystem and includes the components needed to receive telemetry from local clients, process that telemetry, and send it to Azure Monitor.

In a typical deployment:

- The pipeline runs on an Arc-enabled Kubernetes cluster.
- Clients send Syslog or OpenTelemetry Protocol (OTLP) data to the pipeline.
- An optional gateway exposes pipeline receivers to clients outside the cluster.
- Optional TLS or mutual TLS (mTLS) secures ingestion traffic.
- Optional transformations filter or reshape data before it's sent to a Log Analytics workspace.

## Before you begin

Use the following shared prerequisites for the Azure Monitor pipeline setup flow:

- An [Arc-enabled Kubernetes cluster](/azure/azure-arc/kubernetes/overview) in your environment with an external IP address. To connect a cluster to Azure Arc, see [Connect an existing Kubernetes cluster to Azure Arc](/azure/azure-arc/kubernetes/quickstart-connect-cluster).
- Custom locations enabled on the Arc-enabled Kubernetes cluster. See [Create and manage custom locations on Azure Arc-enabled Kubernetes](/azure/azure-arc/kubernetes/custom-locations#enable-custom-locations-on-your-cluster).
- A Log Analytics workspace in Azure Monitor to receive data from the pipeline. To create a workspace, see [Create a Log Analytics workspace in the Azure portal](../logs/quick-create-workspace.md).
- An Azure subscription with the following resource providers registered. See [Azure resource providers and types](/azure/azure-resource-manager/management/resource-providers-and-types).
    - `Microsoft.Insights`
    - `Microsoft.Monitor`
- A gateway solution if clients outside the cluster need to send data to the pipeline. Traefik is one example, but other gateway solutions can also work if they meet your routing and security requirements.

You install cert-manager as part of the shared setup flow in [Configure Azure Monitor pipeline](./pipeline-configure.md).

## Recommended setup sequence

For a new deployment, use the following greenfield sequence.

1. Complete the shared cluster setup in [Configure Azure Monitor pipeline](./pipeline-configure.md). This step prepares the cluster and installs cert-manager.
1. Choose a configuration method:
     - [Configure Azure Monitor pipeline using the Azure portal](./pipeline-configure-portal.md)
     - [Configure Azure Monitor pipeline using CLI or ARM templates](./pipeline-configure-cli.md)
1. If clients need access from outside the cluster, expose the pipeline through a gateway. See [Azure Monitor pipeline - Gateway for Kubernetes deployment](./pipeline-kubernetes-gateway.md).
1. If you need encrypted ingestion, configure TLS. Start with [Azure Monitor pipeline TLS configuration](./pipeline-tls.md).
1. Configure your client connections. See [Configure clients](./pipeline-configure-clients.md).
1. If you need to filter, aggregate, or reshape incoming data, add [pipeline transformations](./pipeline-transformations.md).
1. After the core flow is working, review advanced or operational topics such as [Pod placement](./pipeline-pod-placement.md) and [Extension versions](./pipeline-extension-versions.md).

## Supported configurations

| Supported distros | Supported locations |
|:---|:---|
| - Canonical<br>- Cluster API Provider for Azure<br>- K3<br>- Rancher Kubernetes Engine<br>- VMware Tanzu Kubernetes Grid | - Canada Central<br>- East US<br>- East US2<br>- Italy North<br>- West US2<br>- West Europe<br> |

For more information, see [Product availability by region](https://azure.microsoft.com/explore/global-infrastructure/products-by-region/table).

## Sample architecture

The following diagram shows a typical Azure Monitor pipeline deployment.

- The pipeline is deployed in third-party clouds, and any physical locations with devices and applications to collect data from.
- The pipeline is deployed on an Arc-enabled Kubernetes cluster at each location and in each third-party cloud provider.
- Data sources include the following:
    - Syslog being collected from sources such as network devices and agents running on local servers. Collected by default on TCP port 514.
    - OpenTelemetry (OTLP) being collected from applications. Collected by default on TCP port 4317.
- The pipeline forwards data across local firewalls to Log Analytics workspaces in Azure Monitor. 
- Once data is collected from the pipeline, it's available to any Azure Monitor features accessing that data.

:::image type="content" source="media/pipeline-overview/architecture.png" alt-text="Diagram showing typical Azure Monitor pipeline architecture with multiple locations and devices." lightbox="media/pipeline-overview/architecture.png" border="false":::

## Next steps

- Complete the shared setup in [Configure Azure Monitor pipeline](./pipeline-configure.md).
- Review gateway guidance in [Azure Monitor pipeline - Gateway for Kubernetes deployment](./pipeline-kubernetes-gateway.md).
- Review encryption options in [Azure Monitor pipeline TLS configuration](./pipeline-tls.md).
