---
title: What is Azure Monitor pipeline?
description: Learn what Azure Monitor pipeline is, when to use it, and the recommended setup sequence for edge and multicloud data collection.
ai-usage: ai-assisted
ms.topic: overview
ms.date: 11/17/2026
ms.custom: references_regions, devx-track-azurecli, doc-kit-assisted
---


# What is Azure Monitor pipeline?

Azure Monitor can already collect telemetry from on-premises, edge, and multicloud environments. In many enterprise environments, sending large volumes of telemetry directly to the cloud can increase ingestion costs, introduce reliability risks during connectivity loss, and limit your control over what data is collected. Azure Monitor pipeline builds on existing Azure Monitor collection capabilities for these scenarios.

Azure Monitor pipeline provides centralized governance and a single point of control that runs close to your data sources, so you can filter, transform, aggregate, and route telemetry before you send it to Azure Monitor. This approach helps you reduce ingestion volume, improve reliability in disconnected environments, and apply consistent data processing across hybrid and multicloud deployments. Built on OpenTelemetry technology, the pipeline supports standard ingestion protocols including Syslog and OTLP. It can receive OpenTelemetry (OTel) logs, metrics, and traces from a wide range of clients and environments.

The following diagram shows an example that sends Syslog and OTLP data to a Log Analytics workspace. OTel metrics use an Azure Monitor workspace as their destination.

Azure Monitor pipeline runs on Arc-enabled Kubernetes. You can also deploy it on a Linux VM in Azure or an Arc-enabled Linux server (public preview) without Kubernetes. For deployment guidance, supported configurations, and preview limitations, see [Configure Azure Monitor pipeline on Linux VMs](./pipeline-configure-vm.md).

:::image type="content" source="media/pipeline-overview/architecture.png" alt-text="Diagram showing typical Azure Monitor pipeline architecture with multiple locations and devices." lightbox="media/pipeline-overview/architecture.png" border="false":::

## Why use Azure Monitor pipeline?

Use Azure Monitor pipeline when direct-to-cloud collection doesn't meet your security, scale, cost, or resiliency requirements.

| Need | How the pipeline helps |
|:---|:---|
| Bandwidth or ingestion cost constraints | Filters and aggregates data before cloud ingestion to reduce your network bandwidth requirements. |
| High telemetry volume | Processes data locally at scale to handle sustained high-throughput scenarios before sending to Azure Monitor. |
| Intermittent or restricted connectivity | When persistent storage is enabled, stores data locally so it survives process restarts or connectivity loss and backfills automatically when connectivity returns. |
| Formatting of telemetry | Auto-schematizes Syslog and CEF data to standard tables. |

## Supported data sources

Azure Monitor pipeline currently receives and processes the following data source types:

| Data source | Details | Destination | Status |
|:---|:---|:---|:---|
| Syslog | Supports RFC 3164 and RFC 5424 over TCP and UDP. CEF is supported as Syslog data through the same receiver. | The `Syslog` or `CommonSecurityLog` table, or a custom table in a Log Analytics workspace. | Generally available |
| OTel logs (OTLP) | Supports ingestion of OTel logs from clients to Azure Monitor. | The [`OTelLogs`](../reference/tables/otellogs.md) table or a custom table in a Log Analytics workspace. | Preview |
| OTel metrics (OTLP) | Supports ingestion of OTel metrics from clients to Azure Monitor. | An [Azure Monitor workspace](../metrics/azure-monitor-workspace-overview.md). | Preview |
| OTel traces (OTLP) | Supports ingestion of OTel traces from clients to Azure Monitor. | The [`OTelEvents`](../reference/tables/otelevents.md), [`OTelSpans`](../reference/tables/otelspans.md), and [`OTelResources`](../reference/tables/otelresources.md) tables in a Log Analytics workspace. | Preview |

## Key capabilities

Azure Monitor pipeline includes a set of capabilities that help address common ingestion challenges in hybrid and multicloud environments.

- Secure ingestion endpoints support TLS and optional mutual TLS (mTLS), so you can encrypt telemetry in transit and restrict ingestion to trusted clients.
- Local processing can filter, aggregate, and reshape telemetry before it reaches Azure Monitor, which helps reduce ingestion cost and keep cloud analytics focused on higher-value data.
- Supported Syslog and CEF data can be auto-schematized for Azure Monitor tables such as `Syslog` and `CommonSecurityLog`, which helps reduce downstream parsing effort.
- Optional persistent storage writes telemetry to durable local storage so it survives process restarts and connectivity interruptions. The pipeline automatically backfills data when connectivity returns.
- Built-in monitoring exposes health and performance signals for the pipeline itself, so you can see whether it is receiving, processing, and forwarding telemetry.
- Sizing guidance helps you plan the Kubernetes infrastructure for your expected telemetry volume and workload characteristics.

## How Azure Monitor pipeline works

The Kubernetes-hosted pipeline is a containerized solution that runs on an [Arc-enabled Kubernetes cluster](/azure/azure-arc/kubernetes/overview) in your datacenter, edge location, or another cloud provider. It receives telemetry from clients over standard protocols such as Syslog and OpenTelemetry (OTLP), processes that telemetry, and sends it to Azure Monitor. The pipeline is configured through the Azure portal, ARM templates, Bicep, or Azure CLI.

> [!NOTE]
> Azure provides Azure Monitor pipeline with management and integration to Azure Monitor, but you're responsible for operating and maintaining the Kubernetes environment where the pipeline runs. This shared responsibility model allows you to retain control over your local infrastructure.

A typical Kubernetes deployment is shown in the preceding image and includes the following components:

- The pipeline runs on an Azure Arc-enabled Kubernetes cluster at each on-premises, edge, or multicloud location.
- Clients send Syslog data, including CEF, to the pipeline over TCP or UDP on port 514 by default.
- Clients send OTel logs, metrics, and traces over OTLP to the pipeline on TCP port 4317 by default (this feature is in preview).
- An optional gateway exposes pipeline receivers to clients outside the cluster.
- Optional TLS or mutual TLS (mTLS) secures ingestion traffic.
- Optional transformations filter or reshape data before it's sent to its Azure Monitor destination.
- The pipeline forwards data across local firewalls to a Log Analytics workspace or Azure Monitor workspace.
- Once data is collected, it's available to Azure Monitor features that access the destination workspace.



## Pipeline configuration

For DCR-based configuration on Arc-enabled Kubernetes (public preview), each pipeline instance runs through a `microsoft.monitor.pipeline` Arc extension. Configure the instance with one pipeline settings DCR and one or more dataflow DCRs. The settings DCR describes the instance's runtime settings; the dataflow DCRs describe what to collect and where to send it. Associations deliver that configuration to the extension.

This preview includes native OTel logs, metrics, and traces and is configured through [Azure CLI or ARM templates](./pipeline-configure-cli.md). The [current Azure portal experience](./pipeline-configure-portal.md) continues to use PipelineGroup-based configuration. For Linux VMs and Arc-enabled Linux servers, follow the separate [VM extension guidance](./pipeline-configure-vm.md).

| Component | Purpose |
|:---|:---|
| **Arc extension** | Deploy and run a pipeline instance with its own namespace and managed identity. Configure the extension's version. |
| **Pipeline settings DCR** | Store instance-specific runtime settings in `properties.pipelineSettings`, including named listening endpoints and TLS configurations with certificate references. This DCR has `kind: PipelineSettings`. Endpoints select a named TLS configuration. |
| **Dataflow DCR** | Define data sources, transformations, streams, and destination routing. Reference a named endpoint in the settings DCR to connect collection logic to a listener. |
| **DCR associations** | Deliver the settings DCR and each dataflow DCR to the same pipeline extension. Create each association under the Arc connected cluster and set `properties.scopeToResourceId` to the full resource ID of that extension. |

For example, a settings DCR opens a UDP Syslog endpoint named `syslog514`. The dataflow DCR selects that endpoint, accepts RFC 3164 and RFC 5424 messages, and routes the Syslog stream to a Log Analytics workspace. Both DCRs are associated with the same extension instance so the endpoint and collection configuration are applied together.

For encrypted TCP ingestion, define a named TLS configuration in the settings DCR and reference it from the endpoint. Dataflow DCRs reference the endpoint, not the certificate. You can manage collection and routing in multiple dataflow DCRs while sharing the instance's settings.

The extension applies the combined runtime configuration from its associated DCRs. Configuration delivery and telemetry delivery are separate: DCR associations select the configuration for the instance, while clients send telemetry to the instance's exposed listeners.

For deployment examples, see [Syslog over UDP](./pipeline-configure-cli.md#deploy-the-arm-template), [Syslog over TLS](./pipeline-configure-cli.md#example-collect-syslog-over-tls), [Syslog with mTLS](./pipeline-tls-custom.md#configure-pipeline), [CEF into Microsoft Sentinel](./pipeline-configure-cli.md#collect-cef-into-microsoft-sentinel), and [OTel logs, metrics, and traces](./pipeline-configure-cli.md#collect-otel-logs-metrics-and-traces).

## Azure Monitor pipeline compared to Azure Monitor agent

Azure Monitor pipeline and [Azure Monitor agent (AMA)](/azure/azure-monitor/agents/azure-monitor-agent-overview) serve different purposes and are often deployed together.

Azure Monitor agent runs on each monitored machine, or as a containerized agent in a monitored Kubernetes cluster. It collects guest operating system, workload, and Kubernetes infrastructure telemetry close to the resource.

Azure Monitor pipeline runs off the monitored resources as centralized collection infrastructure. It receives supported telemetry over the network and fans in data from many producers before sending it to Azure Monitor.

| Aspect | Azure Monitor agent | Azure Monitor pipeline |
|:---|:---|:---|
| Deployment scope | On each monitored machine or Kubernetes cluster | Centrally on Arc-enabled Kubernetes, or on Linux VMs in Azure and Arc-enabled Linux servers (preview) |
| Collection pattern | Collects locally from the monitored resource | Receives supported telemetry over the network from many producers |
| Use when | You need data from inside each resource or per-resource collection and resilience | You need centralized governance, high-volume fan-in, processing, or persistent buffering |

Use Azure Monitor pipeline when centralized collection is the right architecture for governance, scale, processing, cost control, or resilience. It also supports sources that can't run an agent, such as network devices and appliances. Combine Azure Monitor agent and pipeline where supported when you need collection close to individual resources and centralized processing across a site or network.

For guidance on selecting a collection architecture, see [Choose a topology for your operational needs](data-collection-overview.md#3-choose-a-topology-for-your-operational-needs).

## Supported configurations

The following table applies to Arc-enabled Kubernetes deployments. Support depends on both the region and the Kubernetes distribution versions supported for the required `cert-manager` extension. For Azure VM and Arc-enabled Linux server requirements and preview limitations, see [Configure Azure Monitor pipeline on Linux VMs](./pipeline-configure-vm.md).

| Supported Kubernetes distributions | Supported regions |
|:---|:---|
| - VMware Tanzu Kubernetes Grid multicloud (TKGm) v1.28.11<br>- SUSE Rancher K3s v1.33.3+k3s1<br>- AKS Arc v1.32.7 | - Australia East<br>- Brazil South<br>- Canada Central<br>- Central India<br>- Central US<br>- Central US EUAP<br>- East Asia<br>- East US<br>- East US 2<br>- East US 2 EUAP<br>- France Central<br>- Germany West Central<br>- Italy North<br>- Japan East<br>- Korea Central<br>- North Central US<br>- North Europe<br>- Norway East<br>- South Africa North<br>- South India<br>- Sweden Central<br>- Switzerland North<br>- UK South<br>- UK West<br>- West Central US<br>- West Europe<br>- West US<br>- West US 2<br>- West US 3 |

Supported regions, see [Product availability by region](https://azure.microsoft.com/explore/global-infrastructure/products-by-region/table).

## Related articles

- Complete the cluster setup in [Configure Azure Monitor pipeline](./pipeline-configure.md).
- Configure the VM hosting options in [Configure Azure Monitor pipeline on Linux VMs (preview)](./pipeline-configure-vm.md).
- Review gateway guidance in [Azure Monitor pipeline - Gateway for Kubernetes deployment](./pipeline-kubernetes-gateway.md).
- Review encryption options in [Azure Monitor pipeline TLS configuration](./pipeline-tls.md).
- Review data shaping options in [Transform data with Azure Monitor pipeline](./pipeline-transformations.md).
- Plan deployment capacity in [Size Azure Monitor pipeline](./pipeline-sizing.md).
