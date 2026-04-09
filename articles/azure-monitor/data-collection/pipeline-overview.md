---
title: What is Azure Monitor pipeline?
description: Learn what Azure Monitor pipeline is, when to use it, and the recommended setup sequence for edge and multicloud data collection.
ai-usage: ai-assisted
ms.topic: overview
ms.date: 03/20/2026
ms.custom: references_regions, devx-track-azurecli, doc-kit-assisted
---


# What is Azure Monitor pipeline?

Telemetry from on-premises, edge, and multicloud environments can create challenges with scale, cost, and reliability when you use direct-to-cloud collection. Azure Monitor pipeline provides a single point of control for enterprise telemetry ingestion in these scenarios. It helps you collect, transform, route, and buffer telemetry before sending it to Azure Monitor in the cloud. This process helps you optimize data before ingestion and reduce costs. Built on open-source technologies from the OpenTelemetry ecosystem, the pipeline is portable and interoperable across environments.

:::image type="content" source="media/pipeline-overview/architecture.png" alt-text="Diagram showing typical Azure Monitor pipeline architecture with multiple locations and devices." lightbox="media/pipeline-overview/architecture.png" border="false":::

This article is the starting point for Azure Monitor pipeline. Use it to understand when to use the pipeline and the recommended sequence for setting up end-to-end data collection.

## Why use Azure Monitor pipeline?

Use Azure Monitor pipeline when direct-to-cloud collection doesn't meet your security, scale, cost, or resiliency requirements.

| Need | How the pipeline helps |
|:---|:---|
| Telemetry originates outside Azure | Centralizes ingestion from on-premises, edge, and multicloud sources into Azure Monitor with one consistent control point. |
| Bandwidth or ingestion cost constraints | Filters and aggregates data before cloud ingestion so you reduce network transfer and pay to ingest higher-value telemetry. |
| High telemetry volume | Processes data locally at scale to handle sustained high-throughput scenarios before sending to Azure Monitor. |
| Intermittent or restricted connectivity | Buffers data in persistent storage during disruptions and backfills automatically when connectivity returns. |

## Supported data sources

Azure Monitor pipeline currently receives and processes the following data source types:

| Data source | Status |
|:---|:---|
| Syslog | Generally available |
| Common Event Format (CEF) | Generally available |
| OpenTelemetry Protocol (OTLP) | Preview |

The pipeline collects Syslog and CEF data from network devices and local servers. OTLP data comes from applications instrumented with OpenTelemetry SDKs. You can configure custom ports and add extra receivers as needed through pipeline transformations and extensions.

## How Azure Monitor pipeline works

The pipeline is a containerized solution that runs on an [Arc-enabled Kubernetes cluster](/azure/azure-arc/kubernetes/overview) in your datacenter, edge location, or another cloud provider. It's built on open-source technologies from the OpenTelemetry ecosystem and includes the components needed to receive telemetry from local clients, process that telemetry, and send it to Azure Monitor.

> [!NOTE]
> Azure provides Azure Monitor pipeline with management and integration to Azure Monitor, but you're responsible for operating and maintaining the Kubernetes environment where the pipeline runs. This shared responsibility model allows you to retain control over your local infrastructure.

A typical deployment is shown in the preceding image and includes the following components:

- The pipeline runs on an Arc-enabled Kubernetes cluster at each on-premises, edge, or multicloud location.
- Clients send Syslog (including CEF) data to the pipeline on TCP port 514 by default.
- Clients send OpenTelemetry Protocol (OTLP) data to the pipeline on TCP port 4317 by default (this feature is in Preview).
- An optional gateway exposes pipeline receivers to clients outside the cluster.
- Optional TLS or mutual TLS (mTLS) secures ingestion traffic.
- Optional transformations filter or reshape data before it's sent to a Log Analytics workspace.
- The pipeline forwards data across local firewalls to Log Analytics workspaces in Azure Monitor.
- Once data is collected, it's available to any Azure Monitor feature that accesses that workspace.



## Azure Monitor pipeline compared to Azure Monitor Agent

Azure Monitor pipeline and [Azure Monitor Agent (AMA)](/azure/azure-monitor/agents/azure-monitor-agent-overview) address different telemetry ingestion needs but often work well together.

| Capability | Azure Monitor pipeline | Azure Monitor Agent |
|:---|:---|:---|
| Ingestion model | Gateway-based, resilient, scalable | Agent-based, direct to cloud |
| Best for | Edge, hybrid, and multicloud environments with high volume or restricted connectivity | Azure and Arc-enabled resources with reliable cloud connectivity |
| Buffering | Persistent storage with configurable retention (up to 48 hours), backfills when connectivity returns | Configurable disk cache (4 GB to 1 TB), data exceeding cache is lost |
| Pre-ingestion transformations | Filters, aggregates, and reshapes data locally before cloud ingestion | KQL transformations via data collection rules |
| Scale | High-throughput telemetry at scale | Moderate telemetry volumes |

Many architectures use both together. AMA handles Azure-connected resources, and Azure Monitor pipeline serves as a central ingestion gateway for edge and multicloud telemetry.

## Setup sequence

Use the following sequence for a new deployment:

1. Complete the shared cluster setup in [Configure Azure Monitor pipeline](./pipeline-configure.md) to prepare the cluster.
1. Consider [pod placement](./pipeline-pod-placement.md) for the pipeline.
1. Choose a configuration method for the pipeline:
     - [Configure Azure Monitor pipeline using the Azure portal](./pipeline-configure-portal.md)
     - [Configure Azure Monitor pipeline using CLI or ARM templates](./pipeline-configure-cli.md)
1. Expose the pipeline through a gateway so that external clients can reach the pipeline receivers to send data to them. See [Azure Monitor pipeline - Gateway for Kubernetes deployment](./pipeline-kubernetes-gateway.md).
1. If you need encrypted ingestion, configure TLS. See [Azure Monitor pipeline TLS configuration](./pipeline-tls.md).
1. Configure connections for your clients to the cluster. See [Configure a Kubernetes gateway for Azure Monitor pipeline](./pipeline-kubernetes-gateway.md).
1. If you need to filter, aggregate, or reshape incoming data, add [pipeline transformations](./pipeline-transformations.md).
1. After the core flow is working, review [Extension versions](./pipeline-extension-versions.md) for version details.

## Supported configurations

| Supported distros | Supported locations |
|:---|:---|
| - Canonical<br>- Cluster API Provider for Azure<br>- K3<br>- Rancher Kubernetes Engine<br>- VMware Tanzu Kubernetes Grid | - Canada Central<br>- East US<br>- East US2<br>- Italy North<br>- West US2<br>- West Europe<br> |

For more information, see [Product availability by region](https://azure.microsoft.com/explore/global-infrastructure/products-by-region/table).

## Related articles

- Complete the shared setup in [Configure Azure Monitor pipeline](./pipeline-configure.md).
- Review gateway guidance in [Azure Monitor pipeline - Gateway for Kubernetes deployment](./pipeline-kubernetes-gateway.md).
- Review encryption options in [Azure Monitor pipeline TLS configuration](./pipeline-tls.md).
