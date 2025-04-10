---
title: Collect Istio Metrics with Managed Service for Prometheus
description: This article describes how to configure Istio monitoring by using Prometheus metrics in Azure Monitor to a Kubernetes cluster.
ms.topic: conceptual
ms.date: 2/15/2025
ms.reviewer: sunasing
---

# Collect Istio metrics by using managed service for Prometheus

[Istio](https://istio.io/) is an open-source service mesh that layers transparently onto existing distributed applications. It provides a uniform and efficient way to secure, connect, and monitor services, especially in a distributed application architecture.

Istio helps developers handle service-to-service interactions by providing features like traffic management, observability, security, and policy enforcement without modifying application code. It's widely used in modern cloud-native applications, especially on Kubernetes.

Azure Kubernetes Service (AKS) now provides an [Istio-based service mesh add-on](/azure/aks/istio-about) that's officially supported and tested for integration with AKS and Azure Arc-enabled Kubernetes.

With the Azure Monitor *managed service for Prometheus* feature, you can collect and analyze metrics at scale. Prometheus metrics are stored in Azure Monitor workspaces. The workspaces support analysis tools like Azure Managed Grafana, Azure Monitor metrics explorer with PromQL, and open-source tools such as PromQL and Grafana.

This article provides step-by-step guidance on using Azure Monitor managed service for Prometheus to collect Istio metrics via the open-source Istio-based service mesh add-on for AKS or for Azure Arc-enabled Kubernetes. You can then visualize the metrics in Azure Managed Grafana.

## Prerequisites

- Azure CLI installed and configured. To install or upgrade, see [Install the Azure CLI](/cli/azure/install-azure-cli).

  If you're using the Istio-based service mesh add-on for AKS, you need Azure CLI version 2.57.0 or later installed. You can run `az --version` to verify the version.
- Kubectl installed to interact with your Kubernetes cluster.

## Limitations

- For a list of limitations with using the Istio-based service mesh add-on for AKS, see the [overview article about the add-on](/azure/aks/istio-about#limitations).
- Currently, there's no support to collect metrics from Istio setup with mutual TLS authentication.
- Currently, there's no support for using Kiali service mesh visualization with managed service for Prometheus.

## Set up Istio, managed service for Prometheus, and Azure Managed Grafana

### Create an AKS cluster with managed service for Prometheus enabled

First, you need to create an AKS cluster (or use an existing one), and enable managed service for Prometheus and Azure Managed Grafana. For instructions, see [Enable Prometheus and Grafana in an AKS cluster](./kubernetes-monitoring-enable.md#enable-prometheus-and-grafana).

If you're using the Azure CLI to create a new AKS cluster, you can use these commands:

```bash
az group create --name myResourceGroup --location eastus
az aks create --resource-group myResourceGroup --name myAKSCluster --node-count 2  --enable-azure-monitor-metrics --generate-ssh-keys
```

### Set up Istio

You can use managed service for Prometheus to collect metrics from both open-source Istio and the Istio-based service mesh add-on for AKS:

- To set up the Istio-based service mesh add-on for AKS, see [Deploy Istio-based service mesh add-on for Azure Kubernetes Service](/azure/aks/istio-deploy-addon).
- To set up open-source Istio, see the [Istio installation guides](https://istio.io/latest/docs/setup/install/).

### Get AKS credentials

```bash
az account set --subscription <subscription id>
az aks get-credentials --resource-group myResourceGroup --name myAKSCluster
```

### Set up managed service for Prometheus to collect Istio metrics

To collect metrics from your Istio setup with managed service for Prometheus, you can use pod annotations. These annotations are automatically set up with Istio. You need to enable pod annotation-based scraping in managed service for Prometheus.

To enable the scraping, customize the managed service for Prometheus configuration map (ama-metrics-settings-configmap.yaml) to include the `istio-system` namespace and the namespaces for the Istio sidecar setup. For example, if you set up Istio to inject the sidecar in `my-namespace`, update the configuration map as follows:

```yaml
pod-annotation-based-scraping: |-
    podannotationnamespaceregex = "aks-istio-system|my-namespace"
```

> [!WARNING]
> Scraping the pod annotations from many namespaces can generate a large volume of metrics, depending on the number of pods that have annotations.

For more information, see [Enable pod annotation-based scraping](./prometheus-metrics-scrape-configuration.md#enable-pod-annotation-based-scraping).

Apply the updated configuration map to your AKS cluster:

```bash
kubectl apply -f ama-metrics-settings-configmap.yaml
```

## Query Istio metrics

The metrics scraped from Istio are stored in the Azure Monitor workspace that'is associated with managed service for Prometheus. You can query the metrics directly from the workspace or through the Azure Managed Grafana instance that's connected to the workspace.

View Istio metrics in the Azure Monitor workspace by using the following steps:

1. In the Azure portal, go to your AKS cluster.

2. Under **Monitoring**, select **Insights** > **Monitor Settings**.

   :::image type="content" source="./media/monitor-kubernetes/amp-istio-query.png" lightbox="./media/monitor-kubernetes/amp-istio-query.png" alt-text="Diagram that shows selections for viewing the Azure Monitor Workspace.":::

3. Select the Azure Monitor Workspace instance. On the instance overview page, select the **Metrics** section to query metrics to query for *istio_requests_total*.

4. Alternatively, you can click on the Azure Managed Grafana instance, and on the instance overview page, click on the Endpoint URL. This will navigate to the Grafana portal where you can query the Azure Container Storage metrics. The data source is automatically configured for you to query metrics from the associated Azure Monitor Workspace.

To learn more about querying Prometheus metrics from Azure Monitor Workspace, see [Query Prometheus metrics](../essentials/prometheus-grafana.md).

## Import Grafana dashboard for istiod

To import the Grafana Dashboards using the ID or JSON, follow the instructions to [Import a dashboard in Grafana](/azure/managed-grafana/how-to-create-dashboard#import-a-grafana-dashboard).

- [Istio Control Plane Dashboard | Grafana Labs](https://grafana.com/grafana/dashboards/7645-istio-control-plane-dashboard/) (ID: 7645)
- [Istio Service SLO Demo | Grafana Labs](https://grafana.com/grafana/dashboards/21793-service-slo/) (ID: 21793)

## Summary

In this tutorial, we demonstrated how to configure managed service for Prometheus for collecting metrics from open-source Istio or AKS service-mesh Istio add-on. We then showed how to query the collected metrics in Azure Monitor. By following these steps, you can effectively monitor Istio using managed service for Prometheus on Azure, gaining valuable insights into your applications' performance and behavior.

## Troubleshooting

To troubleshoot any issues, see [here](prometheus-metrics-troubleshoot.md#prometheus-interface).
