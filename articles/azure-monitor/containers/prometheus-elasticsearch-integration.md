---
title: Configure Elasticsearch Integration for Prometheus Metrics in Azure Monitor
description: This article describes how to configure Elasticsearch monitoring by using Prometheus metrics in Azure Monitor to a Kubernetes cluster.
ms.topic: how-to
ms.date: 3/10/2025
ms.reviewer: rashmy
---

# Collect Elasticsearch metrics by using managed service for Prometheus

Elasticsearch is the distributed search and analytics engine at the heart of the Elastic Stack. It's where the indexing, search, and analysis happen.

This article describes how to configure the Azure Monitor *managed service for Prometheus* feature with Azure Kubernetes Service (AKS) and Azure Arc-enabled Kubernetes to monitor Elasticsearch clusters by scraping Prometheus metrics.

## Prerequisites

- Elasticsearch cluster running on AKS or Azure Arc-enabled Kubernetes
- Managed service for Prometheus enabled on the cluster. For more information, see [Enable Prometheus and Grafana](kubernetes-monitoring-enable.md#enable-prometheus-and-grafana).

## Install the Elasticsearch Exporter

Install the [Prometheus Elasticsearch Exporter](https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus-elasticsearch-exporter) by using the Helm chart:

```bash
helm install azmon-elasticsearch-exporter --version 5.7.0 prometheus-community/prometheus-elasticsearch-exporter --set es.uri="https://username:password@elasticsearch-service.namespace:9200" --set podMonitor.enabled=true --set podMonitor.apiVersion=azmonitoring.coreos.com/v1
```

You can configure the Elasticsearch Exporter Helm chart with [values](https://github.com/prometheus-community/helm-charts/blob/main/charts/prometheus-elasticsearch-exporter/values.yaml). Specify the right server addresses where the Elasticsearch servers can be reached.

Based on your configuration, set the username, password, or certificates that are used to authenticate with the Elasticsearch server. Set the address where Elasticsearch is reachable by using the argument `es.uri`.

> [!NOTE]
> A managed Prometheus service/pod monitor configuration with Helm chart installation is supported only with the Helm chart version 5.7.0 or later.
>
> You could also use a service monitor instead of pod monitor by using the `--set serviceMonitor.enabled=true` Helm chart parameter. Make sure to use the API version that managed service for Prometheus supports, by using the parameter `serviceMonitor.apiVersion=azmonitoring.coreos.com/v1`.
>
> If you want to configure any other service or pod monitors, follow [these instructions](prometheus-metrics-scrape-crd.md#create-a-pod-or-service-monitor).

## Deploy rules

1. Download these files for recording rules:

   - [Template file](https://github.com/Azure/prometheus-collector/blob/main/Azure-ARM-templates/Workload-Rules/ElasticSearch/elasticsearch-recording-rules.json)
   - [Parameter file](https://github.com/Azure/prometheus-collector/blob/main/Azure-ARM-templates/Workload-Rules/Recording-Rules-Parameters.json)

   Download these files for alerting rules:

   - [Template file](https://github.com/Azure/prometheus-collector/blob/main/Azure-ARM-templates/Workload-Rules/ElasticSearch/elasticsearch-alerting-rules.json)
   - [Parameter file](https://github.com/Azure/prometheus-collector/blob/main/Azure-ARM-templates/Workload-Rules/Alert-Rules-Parameters.json)

2. Edit the following values in the parameter files.

    | Parameter | Value |
    |:---|:---|
    | `azureMonitorWorkspace` | Resource ID for the Azure Monitor workspace. Retrieve it from **JSON view** on the **Overview** page for the Azure Monitor workspace. |
    | `location` | Location of the Azure Monitor workspace. Retrieve it from **JSON view** on the **Overview** page for the Azure Monitor workspace. |
    | `clusterName` | Name of the cluster. Retrieve it from **JSON view** on the **Overview** page for the cluster. |
    | `actionGroupId` | Resource ID for the alert action group. Retrieve it from **JSON view** on the **Overview** page for the action group. [Learn more about action groups](../alerts/action-groups.md). |

3. Deploy the template by using any standard method for installing Azure Resource Manager templates. For guidance, see [Resource Manager template samples for Azure Monitor](../resource-manager-samples.md).

4. After you deploy the template, you can view the rules in the Azure portal, as described in [View Prometheus rule groups](../essentials/prometheus-rule-groups.md#view-prometheus-rule-groups). Review the alert thresholds to make sure that they suit your cluster and workloads. Update the thresholds accordingly.

   > [!NOTE]
   > The rules aren't scoped to a cluster. If you want to scope the rules to a specific cluster, see [Limiting rules to a specific cluster](../essentials/prometheus-rule-groups.md#limiting-rules-to-a-specific-cluster).

You can [learn more about Prometheus alerts](../essentials/prometheus-rule-groups.md). If you want to use any other open-source Prometheus alerting/recording rules, use [az-prom-rules-converter](https://aka.ms/az-prom-rules-converter) to create the Azure-equivalent Prometheus rules.

## Import the Grafana dashboards

To import the following Grafana dashboards by using the ID or JSON, use the instructions in [Import a dashboard from Grafana Labs](/azure/managed-grafana/how-to-create-dashboard#import-a-grafana-dashboard):

- [Elasticsearch Overview (ID 2322)](https://github.com/grafana/jsonnet-libs/blob/master/elasticsearch-mixin/dashboards/elasticsearch-overview.json)
- [Elasticsearch Exporter Quickstart and Dashboard (ID 14191)](https://grafana.com/grafana/dashboards/14191-elasticsearch-overview/)

## Troubleshoot

When the service monitor is successfully applied, if you want to make sure that the add-on picks up the service monitor targets, follow [these instructions](prometheus-metrics-troubleshoot.md#prometheus-interface).
