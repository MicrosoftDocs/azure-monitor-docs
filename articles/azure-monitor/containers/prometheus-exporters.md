---
title: Integrate Common Workloads with Managed Service for Prometheus
description: This article describes how to integrate AKS workloads with Azure Monitor managed service for Prometheus and lists workloads that are ready to be integrated.
ms.topic: article
ms.date: 03/10/2025
ms.reviewer: rashmy
---

# Use Prometheus exporters for common workloads with managed service for Prometheus

You can use Prometheus exporters to collect metrics from the following sources and send them to an Azure Monitor workspace:

- Non-Microsoft workloads or other applications
- The Azure Monitor *managed service for Prometheus* feature running on Azure Kubernetes Service (AKS) or Azure Arc-enabled Kubernetes

The enablement of managed Prometheus automatically deploys the custom resource definitions (CRDs) for [pod monitors](https://github.com/Azure/prometheus-collector/blob/main/otelcollector/deploy/addon-chart/azure-monitor-metrics-addon/templates/ama-metrics-podmonitor-crd.yaml) and [service monitors](https://github.com/Azure/prometheus-collector/blob/main/otelcollector/deploy/addon-chart/azure-monitor-metrics-addon/templates/ama-metrics-servicemonitor-crd.yaml).

You can configure any Prometheus exporter to work with managed service for Prometheus. For more information, see [Customize collection by using CRDs (service and pod monitors)](./prometheus-metrics-scrape-crd.md).

This article lists commonly used workloads that have curated configurations and instructions to help you set up metrics collection from the workloads. These workloads apply only to managed service for Prometheus. For self-managed Prometheus, refer to the relevant exporter documentation for setting up metrics collection.

## Common workloads

- [Apache Kafka](./prometheus-kafka-integration.md)
- [Argo CD](./prometheus-argo-cd-integration.md)
- [Elasticsearch](./prometheus-elasticsearch-integration.md)
- [Istio](./prometheus-istio-integration.md)
- [NVIDIA DCGM (GPU metrics)](./prometheus-dcgm-integration.md)

## Related content

- [Customize collection by using CRDs (service and pod monitors)](./prometheus-metrics-scrape-crd.md)
- [Customize scraping of Prometheus metrics in Azure Monitor managed service for Prometheus](./prometheus-metrics-scrape-configuration.md)
