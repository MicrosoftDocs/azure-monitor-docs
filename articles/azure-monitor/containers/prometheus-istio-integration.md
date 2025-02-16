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

[Istio](https://istio.io/) is an open-source service mesh that layers transparently onto existing distributed applications. Istio’s powerful features provide a uniform and more efficient way to secure, connect, and monitor services especially in a distributed application architecture. It helps developers handle service-to-service interactions by providing features like traffic management, observability, security, and policy enforcement without modifying application code. Istio is widely used in modern cloud-native applications, especially those running on Kubernetes.

Azure Kubernetes Service (AKS) now provides an [Istio-based service mesh add-on](/azure/aks/istio-about) that is officially supported and tested for integration with AKS.

Azure Monitor managed service for Prometheus allows you to collect and analyze metrics at scale. Prometheus metrics are stored in Azure Monitor Workspaces. The workspace supports analysis tools like Azure Managed Grafana, Azure Monitor metrics explorer with PromQL, and open source tools such as PromQL and Grafana.

This document provides step-by-step guide on how you can use Azure Monitor managed service for Prometheus to collect Istio metrics, either using open-source Istio or AKS service-mesh Istio add-on, and visualize them in Azure Managed Grafana.

## Prerequisites

1.	Azure CLI installed and configured. To install or upgrade, see [Install Azure CLI](/azure/install-azure-cli). If you are using, AKS Istio add-on, you will need Azure CLI version 2.57.0 or later installed. You can run az --version to verify version.
2.	Kubectl installed to interact with your Kubernetes cluster. 

## Limitations

- For a list of limitations with AKS service-mesh based Istio add-on, see [Istio-based service mesh add-on for Azure Kubernetes Service](/azure/aks/istio-about#limitations).
- Currently there is no support for using Kiali service mesh visualization with Azure Managed Prometheus.


## Setup Istio, Azure Managed Prometheus and Azure Managed Grafana

### Create an AKS cluster with Managed Prometheus enabled

First, you need to create an AKS cluster or use an existing one, and enable Managed Prometheus and Managed Grafana enabled. For instructions on how to do this, see [Enable Prometheus and Grafana in an AKS cluster](/azure/azure-monitor/containers/kubernetes-monitoring-enable?tabs=cli#enable-prometheus-and-grafana).

If you are using Azure CLI to create a new AKS cluster, you can use the below commands:

```bash
az group create --name myResourceGroup --location eastus
az aks create --resource-group myResourceGroup --name myAKSCluster --node-count 2  --enable-azure-monitor-metrics --generate-ssh-keys
```

### Setup Istio









## Prerequisites

+ Kafka cluster running on AKS
+ Azure Managed prometheus enabled on the AKS cluster - [Enable Azure Managed Prometheus on AKS](kubernetes-monitoring-enable.md#enable-prometheus-and-grafana)


### Install Kafka Exporter
Install the [Kafka Exporter](https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus-kafka-exporter) using the helm chart.

```bash
helm install azmon-kafka-exporter --namespace=azmon-kafka-exporter --create-namespace --version 2.10.0 prometheus-community/prometheus-kafka-exporter --set kafkaServer="{kafka-server.namespace.svc:9092,.....}" --set prometheus.serviceMonitor.enabled=true --set prometheus.serviceMonitor.apiVersion=azmonitoring.coreos.com/v1
```

> [!NOTE] 
> Managed prometheus pod/service monitor configuration with helm chart installation is only supported with the helm chart version >=2.10.0.
>
> The [prometheus kafka exporter](https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus-kafka-exporter) helm chart can be configured with [values](https://github.com/prometheus-community/helm-charts/blob/main/charts/prometheus-kafka-exporter/values.yaml) yaml.
Please specify the right server addresses where the kafka servers can be reached. Set the server address(es) using the argument "kafkaServer".
>
> If you want to configure any other service or pod monitors, please follow the instructions [here](prometheus-metrics-scrape-crd.md#create-a-pod-or-service-monitor).


### Import the Grafana Dashboard

To import the Grafana Dashboards using the ID or JSON, follow the instructions to [Import a dashboard from Grafana Labs](/azure/managed-grafana/how-to-create-dashboard#import-a-grafana-dashboard). </br>

[Kafka Exporter Grafana Dashboard](https://grafana.com/grafana/dashboards/7589-kafka-exporter-overview/)(ID-7589)

### Deploy Rules
1. Download the template and parameter files

    **Alerting Rules**
   - [Template file](https://github.com/Azure/prometheus-collector/blob/main/Azure-ARM-templates/Workload-Rules/Kafka/kafka-alerting-rules.json)
   - [Parameter file](https://github.com/Azure/prometheus-collector/blob/main/Azure-ARM-templates/Workload-Rules/Alert-Rules-Parameters.json)


2. Edit the following values in the parameter files. Retrieve the resource ID of the resources from the **JSON View** of their **Overview** page.

    | Parameter | Value |
    |:---|:---|
    | `azureMonitorWorkspace` | Resource ID for the Azure Monitor workspace. Retrieve from the **JSON view** on the **Overview** page for the Azure Monitor workspace. |
    | `location` | Location of the Azure Monitor workspace. Retrieve from the **JSON view** on the **Overview** page for the Azure Monitor workspace. |
    | `clusterName` | Name of the AKS cluster. Retrieve from the **JSON view** on the **Overview** page for the cluster. |
    | `actionGroupId` | Resource ID for the alert action group. Retrieve from the **JSON view** on the **Overview** page for the action group. Learn more about [action groups](../alerts/action-groups.md) |

3. Deploy the template by using any standard methods for installing ARM templates. For guidance, see [ARM template samples for Azure Monitor](../resource-manager-samples.md).

4. Once deployed, you can view the rules in the Azure portal as described in - [Prometheus Alerts](../essentials/prometheus-rule-groups.md#view-prometheus-rule-groups)

> [!Note] 
> Review the alert thresholds to make sure it suits your cluster/workloads and update it accordingly.
>
> Please note that the above rules are not scoped to a cluster. If you would like to scope the rules to a specific cluster, see [Limiting rules to a specific cluster](../essentials/prometheus-rule-groups.md#limiting-rules-to-a-specific-cluster) for more details.
>
> Learn more about [Prometheus Alerts](../essentials/prometheus-rule-groups.md).
>
> If you want to use any other OSS prometheus alerting/recording rules please use the converter here to create the azure equivalent prometheus rules [az-prom-rules-converter](https://aka.ms/az-prom-rules-converter)


### More jmx_exporter metrics using strimzi
If you are using the [strimzi operator](https://github.com/strimzi/strimzi-kafka-operator.git) for deploying the kafka clusters, deploy the pod monitors to get more jmx_exporter metrics.
> [!Note] 
> Metrics need to be exposed by the kafka cluster deployments like the examples [here](https://github.com/strimzi/strimzi-kafka-operator/tree/main/examples/metrics). Refer to the kafka-.*-metrics.yaml files to configure metrics to be exposed. 
>
>The pod monitors here also assume that the namespace where the kafka workload is deployed in 'kafka'. Update it accordingly if the workloads are deployed in another namespace.

```yaml
apiVersion: azmonitoring.coreos.com/v1
kind: PodMonitor
metadata:
  name: azmon-cluster-operator-metrics
  labels:
    app: strimzi
spec:
  selector:
    matchLabels:
      strimzi.io/kind: cluster-operator
  namespaceSelector:
    matchNames:
      - kafka
  podMetricsEndpoints:
  - path: /metrics
    port: http
---
apiVersion: azmonitoring.coreos.com/v1
kind: PodMonitor
metadata:
  name: azmon-entity-operator-metrics
  labels:
    app: strimzi
spec:
  selector:
    matchLabels:
      app.kubernetes.io/name: entity-operator
  namespaceSelector:
    matchNames:
      - kafka
  podMetricsEndpoints:
  - path: /metrics
    port: healthcheck
---
apiVersion: azmonitoring.coreos.com/v1
kind: PodMonitor
metadata:
  name: azmon-bridge-metrics
  labels:
    app: strimzi
spec:
  selector:
    matchLabels:
      strimzi.io/kind: KafkaBridge
  namespaceSelector:
    matchNames:
      - kafka
  podMetricsEndpoints:
  - path: /metrics
    port: rest-api
---
apiVersion: azmonitoring.coreos.com/v1
kind: PodMonitor
metadata:
  name: azmon-kafka-resources-metrics
  labels:
    app: strimzi
spec:
  selector:
    matchExpressions:
      - key: "strimzi.io/kind"
        operator: In
        values: ["Kafka", "KafkaConnect", "KafkaMirrorMaker", "KafkaMirrorMaker2"]
  namespaceSelector:
    matchNames:
      - kafka
  podMetricsEndpoints:
  - path: /metrics
    port: tcp-prometheus
    relabelings:
    - separator: ;
      regex: __meta_kubernetes_pod_label_(strimzi_io_.+)
      replacement: $1
      action: labelmap
    - sourceLabels: [__meta_kubernetes_namespace]
      separator: ;
      regex: (.*)
      targetLabel: namespace
      replacement: $1
      action: replace
    - sourceLabels: [__meta_kubernetes_pod_name]
      separator: ;
      regex: (.*)
      targetLabel: kubernetes_pod_name
      replacement: $1
      action: replace
    - sourceLabels: [__meta_kubernetes_pod_node_name]
      separator: ;
      regex: (.*)
      targetLabel: node_name
      replacement: $1
      action: replace
    - sourceLabels: [__meta_kubernetes_pod_host_ip]
      separator: ;
      regex: (.*)
      targetLabel: node_ip
      replacement: $1
      action: replace
```

#### Alerts with strimzi
Rich set of alerts based off of strimzi metrics can also be configured by refering to the [examples](https://github.com/strimzi/strimzi-kafka-operator/blob/main/examples/metrics/prometheus-install/prometheus-rules.yaml).

> [!NOTE] 
> If using any other way of exposing the jmx_exporter on your kafka cluster, please follow the instructions [here](prometheus-metrics-scrape-crd.md) on how to configure the pod or service monitors accordingly.

### Grafana Dashboards for more jmx metrics with strimzi
Please also see the [grafana-dashboards-for-strimzi](https://github.com/strimzi/strimzi-kafka-operator/tree/main/examples/metrics/grafana-dashboards) to view dashboards for metrics exposed by strimzi operator.


### Troubleshooting
When the service monitors or pod monitors are successfully applied, if you want to make sure that the service monitor targets get picked up by the addon, follow the instructions [here](prometheus-metrics-troubleshoot.md#prometheus-interface). 

