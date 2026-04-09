---
title: Azure Monitor pipeline FAQ
description: Frequently asked questions for Azure Monitor pipeline, including architecture, deployment, data collection, and configuration.
ai-usage: ai-assisted
ms.topic: overview
ms.date: 03/20/2026
ms.custom: references_regions, devx-track-azurecli, doc-kit-assisted
---


# Azure Monitor pipeline FAQ

## Overview & Concepts

### What is Azure Monitor pipeline?

The Azure Monitor pipeline extends enterprise-grade telemetry ingestion to any environment, providing a **single point of control** to securely ingest data, optimize data before ingestion, optimize costs, and ensure consistent delivery to the cloud.

It runs on Azure Arc–enabled Kubernetes clusters and uses open-source technologies from the **OpenTelemetry ecosystem**, enabling portability and interoperability across environments.  
[Learn more](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/pipeline-overview)

***

### When should I use Azure Monitor pipeline?

Azure Monitor pipeline is designed for scenarios where telemetry originates outside Azure, where data volume is high, or where connectivity to Azure may be intermittent or restricted. In these cases, the pipeline allows data to be processed locally before being sent to Azure Monitor.

| Customer challenge                      | How Azure Monitor pipeline helps                                                                                   |
| --------------------------------------- | ------------------------------------------------------------------------------------------------------------------ |
| Telemetry generated outside Azure       | Enables centralized ingestion into Azure Monitor from on‑premises and multicloud environments                      |
| Very high telemetry volume              | Collects and processes data locally at scale before cloud ingestion                                                |
| Intermittent or restricted connectivity | Buffers data locally in configured persistent storage and backfills to Azure Monitor once connectivity is restored |
| Bandwidth or ingestion cost constraints | Filters and aggregates telemetry before sending data to Azure Monitor                                              |

***

### How is Azure Monitor pipeline different from Azure Monitor Agent (AMA)?

Azure Monitor pipeline and Azure Monitor Agent (AMA) address **different telemetry ingestion needs** and are often **complementary**.

**Azure Monitor Agent (AMA)** is designed for **direct, cloud-connected collection** from Azure and Arc-enabled resources. It is ideal when:

*   Resources can reliably connect to Azure
*   Telemetry volumes are moderate
*   You want simple, agent-based collection managed centrally in Azure

**Azure Monitor pipeline**, on the other hand, is designed for **edge, hybrid, and high-scale scenarios**. It is preferred when:

*   Telemetry originates outside Azure (on‑premises, edge, third‑party clouds)
*   Network connectivity is intermittent or restricted
*   You need local buffering, high-throughput ingestion, or pre-ingestion filtering and transformations
*   Clients cannot send data directly to Azure Monitor

**In short:**

*   **AMA** → *agent-based, direct ingestion*
*   **Azure Monitor pipeline** → *gateway-based, resilient, scalable ingestion*

Many architectures use **both together**—AMA for Azure-connected resources, and Azure Monitor pipeline as a **central ingestion gateway** for edge and multicloud telemetry.

***

### Is Azure Monitor pipeline tied to a specific cloud provider?

No. Azure Monitor pipeline is designed for hybrid and multicloud environments. It runs on Azure Arc–enabled Kubernetes clusters and leverages open-source OpenTelemetry technologies, enabling portability and interoperability across environments.  
[Learn more](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/pipeline-overview)

***

## Deployment & Architecture

### Where does Azure Monitor pipeline run?

Azure Monitor pipeline runs as containerized components on an Azure Arc–enabled Kubernetes cluster. This enables deployment close to data sources in:

*   On‑premises data centers
*   Edge locations
*   Other cloud environments

[Learn more](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/pipeline-overview)

***

### What infrastructure is required to deploy Azure Monitor pipeline?

Azure Monitor pipeline is designed to scale with your telemetry needs. You deploy it on an **Arc-enabled Kubernetes cluster**, and the **size and configuration of the cluster depend on expected data volume, throughput, and resiliency requirements**.

Using Azure Monitor pipeline sizing guidance, you can start with a small footprint for modest ingestion needs and scale up predictably as volume grows.  
*Learn more: Sizing guidance*

***

### Which Kubernetes distributions are supported?

Azure Monitor pipeline supports multiple Kubernetes distributions when deployed through Azure Arc. Supported distributions and regions are documented and may change over time as support expands.  
[Learn more](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/pipeline-overview#supported-configurations)

***

## Data Collection & Processing

### What types of data can Azure Monitor pipeline collect?

Azure Monitor pipeline collects telemetry data from local or external clients and delivers it to Azure Monitor.  
*Learn more about supported data sources*

***

### Does Azure Monitor pipeline support data transformations?

Yes. Azure Monitor pipeline supports local data transformations such as:

*   Filtering
*   Schematization
*   Aggregation

Applying transformations locally allows customers to control which telemetry is forwarded for centralized analysis.  
[Learn more](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/pipeline-transformations?tabs=portal)

***

### How does Azure Monitor pipeline help reduce network usage?

By filtering or aggregating telemetry before sending it to Azure, Azure Monitor pipeline reduces network bandwidth usage. This is especially valuable in bandwidth-constrained or cost-sensitive environments.  
[Learn more](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/pipeline-transformations?tabs=portal)

***

## Reliability, Scale & Connectivity

### How does Azure Monitor pipeline handle connectivity interruptions?

If connectivity to Azure is unavailable, Azure Monitor pipeline buffers telemetry data locally in your configured persistent storage. Once connectivity is restored, buffered telemetry is backfilled to Azure Monitor, maintaining continuity of monitoring data.

***

## Configuration & Management

### How is Azure Monitor pipeline configured?

Azure Monitor pipeline can be configured using:

*   Azure portal (guided experience)
*   CLI or ARM templates (advanced scenarios)

This flexibility allows customers to choose the level of operational control that best fits their needs.

***

### Is Azure Monitor pipeline fully managed by Azure?

Azure provides management and integration with Azure Monitor. However, customers are responsible for operating and maintaining the environment where the pipeline runs. This shared responsibility model allows customers to retain control over their local infrastructure.

***
