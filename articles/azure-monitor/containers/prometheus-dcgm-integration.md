---
title: Collect GPU metrics from Nvidia DCGM exporter with Azure Managed Prometheus
description: Describes how to configure GPU monitoring using Prometheus metrics in Azure Monitor to Kubernetes cluster.
ms.topic: conceptual
ms.date: 3/24/2025
ms.reviewer: sunasing
---
# Collect GPU metrics from Nvidia DCGM exporter with Azure Managed Prometheus

**[Nvidia's DCGM exporter](https://docs.nvidia.com/datacenter/cloud-native/gpu-telemetry/latest/dcgm-exporter.html)** enables collecting and exporting Nvidia GPU metrics, such as utilization, memory usage, power consumption etc. You can use this exporter and enable GPU monitoring with Azure Managed Prometheus and Azure Managed Grafana. Follow the steps below to deploy the exporter and set up metrics collection:

## Prerequisites

1. GPU Node Pool: Add a node pool with the required VM SKU that includes GPU support.
1. GPU Driver: Ensure the NVIDIA Kubernetes device plugin driver is running as a DaemonSet on your GPU nodes.
1. Enable Azure Managed Prometheus and Azure Managed Grafana on your AKS cluster. To enable, see [Enable Prometheus and Grafana for AKS cluster](./kubernetes-monitoring-enable.md).

## Update API version in the service monitor and pod monitor of the exporter

To collect the GPU metrics from the DCGM exporter, update the API version of the Service and Pod monitors. 

- Clone this repository: [dcgm-exporter](https://github.com/NVIDIA/dcgm-exporter)
- Once the repository in cloned, navigate to the folder in the repository in your local machine: deployment/template
- Modify the service-monitor.yaml file to update the apiVersion key from **monitoring.coreos.com/v1** to **azmonitoring.coreos.com/v1**. This change allows the DCGM Exporter to use the Azure Managed Prometheus Service Monitor CRD.

```yaml
apiVersion: azmonitoring.coreos.com/v1
```

- GPU node pools often have tolerations and node selector tags. Go to the deployment folder and modify the values.yaml file as needed:

```yaml
nodeSelector:
  accelerator: nvidia

tolerations:
- key: "sku"
  operator: "Equal"
  value: "gpu"
  effect: "NoSchedule"
```

## Packaging the helm chart

- Once the above changes are done, run the following commands in the deployment folder to package the helm chart and login to your container registry

```bash
helm package .
helm registry login <container-registry-url> --username $USER_NAME --password $PASSWORD
```
- Push the helm char to the registry

```bash
helm push dcgm-exporter-3.4.2.tgz oci://<container-registry-url>/helm
```
- Verify that the package is available in the container registry
- Install the chart and verify if the DCGM exporter is running on the GPU nodes as a daemonset.

```bash
helm install dcgm-nvidia oci://<container-registry-url>/helm/dcgm-exporter -n gpu-resources
#Check the installation on your AKS cluster by running:
helm list -n gpu-resources
#Verify the DGCM Exporter:
kubectl get po -n gpu-resources
kubectl get ds -n gpu-resources
```

## Collect GPU metrics with Managed Prometheus

Once the DCGM exporter is running across your GPU nodes, deploy a Pod Monitor to configure collection of GPU metrics with Managed Prometheus.

- Copy the below into a yaml file 

```yaml
apiVersion: azmonitoring.coreos.com/v1
kind: PodMonitor
metadata:
  name: nvidia-dcgm-exporter
  labels:
    app.kubernetes.io/name: nvidia-dcgm-exporter
spec:
  selector:
    matchLabels:
      app.kubernetes.io/name: nvidia-dcgm-exporter
  podMetricsEndpoints:
  - port: metrics
    interval: 30s
  podTargetLabels:
```

- Deploy the yaml file to deploy the Pod Monitor

```bash
kubectl apply -f <path to yaml file>
```

- Check if the Pod Monitor is deployed and running

```bash
kubectl get podmonitor -n <namespace>
```

Managed Prometheus should now be configured to collect GPU metrics from the DCGM exporter.

## Query GPU metrics

The metrics scraped are stored in the Azure Monitor workspace that is associated with Managed Prometheus. You can query the metrics directly from the workspace or through the Azure managed Grafana instance connected to the workspace.

View Istio metrics in the Azure Monitor Workspace using the following steps:

1.	In the Azure portal, navigate to your AKS cluster.
2.	Under Monitoring, select Insights and then Monitor Settings.

:::image type="content" source="./media/monitor-kubernetes/amp-istio-query.png" lightbox="./media/monitor-kubernetes/amp-istio-query.png" alt-text="Diagram that shows how to view the Azure Monitor Workspace.":::

3. Click on the Azure Monitor Workspace instance and on the instance overview page, click on the **Metrics** section to query metrics to query for the metrics.
4. Alternatively, you can click on the Managed Grafana instance, and on the instance overview page, click on the Endpoint URL. This will navigate to the Grafana portal where you can query the Azure Container Storage metrics. The data source is automatically configured for you to query metrics from the associated Azure Monitor Workspace.

To learn more about querying Prometheus metrics from Azure Monitor Workspace, see [Query Prometheus metrics](../essentials/prometheus-grafana.md).


## Import Grafana dashboard for istiod

Follow the instructions to [Import a dashboard in Grafana](/azure/managed-grafana/how-to-create-dashboard#import-a-grafana-dashboard), and import the following dashboard available in the GitHub repository:

- [Grafana dashboard for DCGM exporter](https://github.com/NVIDIA/dcgm-exporter/blob/main/grafana/dcgm-exporter-dashboard.json)

## Summary

In this tutorial, we demonstrated how to configure Azure Managed Prometheus for collecting GPU metrics from Nvidia's DCGM exporter. We then showed how to query the collected metrics in Azure Monitor. By following these steps, you can effectively monitor GPU using Managed Prometheus on Azure, gaining valuable insights into your applications’ performance and behavior.

## Troubleshooting

To troubleshoot any issues, see [here](prometheus-metrics-troubleshoot.md#prometheus-interface).

