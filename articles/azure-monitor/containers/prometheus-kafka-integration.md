---
title: Configure Kafka Integration for Prometheus Metrics in Azure Monitor
description: Learn how to configure Kafka monitoring by using Prometheus metrics in Azure Monitor to a Kubernetes cluster.
ms.topic: how-to
ms.date: 3/10/2025
ms.reviewer: rashmy
---

# Collect Apache Kafka metrics by using managed service for Prometheus

Apache Kafka is an open-source, distributed event-streaming platform used by high-performance data pipelines, streaming analytics, data integration, and mission-critical applications.

This article describes how to configure the Azure Monitor *managed service for Prometheus* feature with Azure Kubernetes Service (AKS) and Azure Arc-enabled Kubernetes to monitor Kafka clusters by scraping Prometheus metrics.

## Prerequisites

+ Kafka cluster running on AKS or Azure Arc-enabled Kubernetes - [Deploy Kafka cluster running on AKS](/azure/aks/kafka-infrastructure?pivots=azure-cli)
+ Azure Managed prometheus enabled on the cluster - [Enable Azure Managed Prometheus on AKS](kubernetes-monitoring-enable.md)

## Install the Kafka Exporter

Install the [Prometheus Kafka Exporter](https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus-kafka-exporter) by using the Helm chart:

```bash
helm install azmon-kafka-exporter --namespace=azmon-kafka-exporter --create-namespace --version 2.10.0 prometheus-community/prometheus-kafka-exporter --set kafkaServer="{kafka-server.namespace.svc:9092,.....}" --set prometheus.serviceMonitor.enabled=true --set prometheus.serviceMonitor.apiVersion=azmonitoring.coreos.com/v1
```

You can configure the Kafka Exporter Helm chart with [values](https://github.com/prometheus-community/helm-charts/blob/main/charts/prometheus-kafka-exporter/values.yaml). Specify the right server addresses where the Kafka servers can be reached. Set the server addresses by using the argument `kafkaServer`.

> [!NOTE]
> A managed Prometheus service/pod monitor configuration with Helm chart installation is supported only with the Helm chart version 2.10.0 or later. If you want to configure any other service or pod monitors, follow [these instructions](prometheus-metrics-scrape-crd.md#create-a-pod-or-service-monitor).

## Import the Grafana dashboard

To import the [Grafana dashboard (ID 7589) in the Kafka Exporter](https://grafana.com/grafana/dashboards/7589-kafka-exporter-overview/) by using the ID or JSON, follow the instructions in [Import a dashboard from Grafana Labs](/azure/managed-grafana/how-to-create-dashboard#import-a-grafana-dashboard).

## Deploy rules

1. Download the [template file](https://github.com/Azure/prometheus-collector/blob/main/Azure-ARM-templates/Workload-Rules/Kafka/kafka-alerting-rules.json) and the [parameter file](https://github.com/Azure/prometheus-collector/blob/main/Azure-ARM-templates/Workload-Rules/Alert-Rules-Parameters.json) for alerting rules.

2. Edit the following values in the parameter file.

    | Parameter | Value |
    |:---|:---|
    | `azureMonitorWorkspace` | Resource ID for the Azure Monitor workspace. Retrieve it from **JSON view** on the **Overview** page for the Azure Monitor workspace. |
    | `location` | Location of the Azure Monitor workspace. Retrieve it from **JSON view** on the **Overview** page for the Azure Monitor workspace. |
    | `clusterName` | Name of the AKS or Azure Arc-enabled Kubernetes cluster. Retrieve it from **JSON view** on the **Overview** page for the cluster. |
    | `actionGroupId` | Resource ID for the alert action group. Retrieve it from **JSON view** on the **Overview** page for the action group. [Learn more about action groups](../alerts/action-groups.md). |

3. Deploy the template by using any standard method for installing Azure Resource Manager templates. For guidance, see [Resource Manager template samples for Azure Monitor](../resource-manager-samples.md).

4. After you deploy the template, you can view the rules in the Azure portal, as described in [View Prometheus rule groups](../essentials/prometheus-rule-groups.md#view-prometheus-rule-groups). Review the alert thresholds to make sure that they suit your cluster and workloads. Update the thresholds accordingly.

   > [!NOTE]
   > The rules aren't scoped to a cluster. If you want to scope the rules to a specific cluster, see [Limiting rules to a specific cluster](../essentials/prometheus-rule-groups.md#limiting-rules-to-a-specific-cluster).

You can [learn more about Prometheus alerts](../essentials/prometheus-rule-groups.md). If you want to use any other open-source Prometheus alerting/recording rules, use [az-prom-rules-converter](https://aka.ms/az-prom-rules-converter) to create the Azure-equivalent Prometheus rules.

## Get more JMX Exporter metrics by using Strimzi

If you're using the [Strimzi operator](https://github.com/strimzi/strimzi-kafka-operator.git) for deploying the Kafka clusters, deploy the pod monitors to get more [JMX Exporter](https://github.com/prometheus/jmx_exporter) metrics.

Metrics need to be exposed by the Kafka cluster deployments, like the [examples in GitHub](https://github.com/strimzi/strimzi-kafka-operator/tree/main/examples/metrics). Refer to the kafka-.*-metrics.yaml files to configure metrics to be exposed.

The pod monitors here also assume that the namespace where the Kafka workload is deployed is `kafka`. Update it accordingly if the workloads are deployed in another namespace.

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

## Configure alerts by using Strimzi

You can configure a rich set of alerts based on Strimzi metrics by referring to [these examples](https://github.com/strimzi/strimzi-kafka-operator/tree/main/examples/metrics/prometheus-install/prometheus-rules).

> [!NOTE]
> If you're using any other way of exposing the JMX Exporter on your Kafka cluster, follow the [instructions for configuring the pod or service monitors](prometheus-metrics-scrape-crd.md) accordingly.

## View Grafana dashboards for more JMX metrics by using Strimzi

To view dashboards for metrics that the Strimzi operator exposes, see the [GitHub location of Grafana dashboards for Strimzi](https://github.com/strimzi/strimzi-kafka-operator/tree/main/examples/metrics/grafana-dashboards).

## Troubleshoot

When the service monitors or pod monitors are successfully applied, if you want to make sure that the add-on picks up the service monitor targets, follow [these instructions](prometheus-metrics-troubleshoot.md#prometheus-interface).
