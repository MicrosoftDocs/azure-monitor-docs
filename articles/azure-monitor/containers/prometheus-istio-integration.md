---
title: Collect Istio metrics with Azure Managed Prometheus
description: Describes how to configure Istio monitoring using Prometheus metrics in Azure Monitor to Kubernetes cluster.
ms.topic: conceptual
ms.date: 2/15/2025
ms.reviewer: sunasing
ms.service: azure-monitor
ms.subservice: containers
---
# Collect Istio metrics with Azure Managed Prometheus

## Introduction

[Istio](https://istio.io/) is an open-source service mesh that layers transparently onto existing distributed applications. Istio’s powerful features provide a uniform and more efficient way to secure, connect, and monitor services especially in a distributed application architecture. It helps developers handle service-to-service interactions by providing features like traffic management, observability, security, and policy enforcement without modifying application code. Istio is widely used in modern cloud-native applications, especially on Kubernetes.

Azure Kubernetes Service (AKS) now provides an [Istio-based service mesh add-on](/azure/aks/istio-about) that is officially supported and tested for integration with AKS.

Azure Monitor managed service for Prometheus allows you to collect and analyze metrics at scale. Prometheus metrics are stored in Azure Monitor Workspaces. The workspace supports analysis tools like Azure Managed Grafana, Azure Monitor metrics explorer with PromQL, and open source tools such as PromQL and Grafana.

This document provides step-by-step guide on how you can use Azure Monitor managed service for Prometheus to collect Istio metrics, either using open-source Istio or AKS service-mesh Istio add-on, and visualize them in Azure Managed Grafana.

## Prerequisites

1.	Azure CLI installed and configured. To install or upgrade, see [Install Azure CLI](/cli/azure/install-azure-cli). If you are using AKS Istio add-on, you need Azure CLI version 2.57.0 or later installed. You can run az --version to verify version.
2.	Kubectl installed to interact with your Kubernetes cluster. 

## Limitations

- For a list of limitations with AKS service-mesh based Istio add-on, see [Istio-based service mesh add-on for Azure Kubernetes Service](/azure/aks/istio-about#limitations).
- Currently there is no support to collect metrics from Istio setup with mutual TLS authentication.
- Currently there is no support for using Kiali service mesh visualization with Azure Managed Prometheus.

## Set up Istio, Azure Managed Prometheus, and Azure Managed Grafana

### Create an AKS cluster with Managed Prometheus enabled

First, you need to create an AKS cluster or use an existing one, and enable Managed Prometheus and Managed Grafana enabled. For instructions, see [Enable Prometheus and Grafana in an AKS cluster](./kubernetes-monitoring-enable.md#enable-prometheus-and-grafana).

If you are using Azure CLI to create a new AKS cluster, you can use the below commands:

```bash
az group create --name myResourceGroup --location eastus
az aks create --resource-group myResourceGroup --name myAKSCluster --node-count 2  --enable-azure-monitor-metrics --generate-ssh-keys
```

### Set up Istio

You can use Azure Managed Prometheus to collect metrics from both open-source Istio and AKS service-mesh Istio add-on.

- To set up AKS service-mesh Istio add-on, see [Deploy Istio-based service mesh add-on for Azure Kubernetes Service](/azure/aks/istio-deploy-addon).
- To set up open-source Istio, see [Istio / Installation Guides](https://istio.io/latest/docs/setup/install/).


### Get AKS Credentials

```bash
az account set --subscription <subscription id>
az aks get-credentials --resource-group myResourceGroup --name myAKSCluster
```

### Set up Managed Prometheus to collect Istio metrics

To collect metrics from your Istio setup with Managed Prometheus, you can use pod annotations which are automatically setup with Istio. You need to enable pod annotation based scraping in Managed Prometheus.

To enable the same, customize the Managed Prometheus configmap: ama-metrics-settings-configmap.yaml to include the istio-system namespace and the namespaces that istio sidecar is setup. For example, if you have setup istio to inject the sidecar in “my-namespace”, update the configmap as below:

```yaml
pod-annotation-based-scraping: |-
    podannotationnamespaceregex = "istio-system|my-namespace"
```

For more information on pod-annotations based scraping, see [Enable pod-annotation based scraping](./prometheus-metrics-scrape-configuration.md#enable-pod-annotation-based-scraping).

Apply the updated configmap to your AKS cluster:

```bash
kubectl apply -f ama-metrics-settings-configmap.yaml
```

## Query Istio metrics

The metrics scraped from Istio are stored in the Azure Monitor workspace that is associated with Managed Prometheus. You can query the metrics directly from the workspace or through the Azure managed Grafana instance connected to the workspace.

View Istio metrics in the Azure Monitor Workspace using the following steps:

1.	In the Azure portal, navigate to your AKS cluster.
2.	Under Monitoring, select Insights and then Monitor Settings

:::image type="content" source="./media/monitor-kubernetes/amp-istio-query.png" lightbox="./media/monitor-kubernetes/amp-istio-query.png" alt-text="Diagram that shows how to view the Azure Monitor Workspace.":::

3. Click on the Azure Monitor Workspace instance and on the instance overview page, click on the **Metrics** section to query metrics to query for *istio_requests_total*.
4. Alternatively, you can click on the Managed Grafana instance, and on the instance overview page, click on the Endpoint URL. This will navigate to the Grafana portal where you can query the Azure Container Storage metrics. The data source is automatically configured for you to query metrics from the associated Azure Monitor Workspace.

To learn more about querying Prometheus metrics from Azure Monitor Workspace, see [Query Prometheus metrics](../essentials/prometheus-grafana.md).


## Import Grafana dashboard for istiod

To import the Grafana Dashboards using the ID or JSON, follow the instructions to [Import a dashboard in Grafana](/azure/managed-grafana/how-to-create-dashboard#import-a-grafana-dashboard).

- [Istio Control Plane Dashboard | Grafana Labs](https://grafana.com/grafana/dashboards/7645-istio-control-plane-dashboard/) (ID: 7645)
- [Istio Service SLO Demo | Grafana Labs](https://grafana.com/grafana/dashboards/21793-service-slo/) (ID: 21793)

## Summary

In this tutorial, we demonstrated how to configure Azure Managed Prometheus for collecting metrics from open-source Istio or AKS service-mesh Istio add-on. We then showed how to query the collected metrics in Azure Monitor. By following these steps, you can effectively monitor Istio using Managed Prometheus on Azure, gaining valuable insights into your applications’ performance and behavior.

## Troubleshooting

To troubleshoot any issues, see [here](prometheus-metrics-troubleshoot.md#prometheus-interface).

