---
title: Migrate from Self-hosted Prometheus to Azure Monitor Managed Service for Prometheus
description: Guidance for organizations planning to migrate from self-managed Prometheus to Azure Monitor managed service for Prometheus.
ms.topic: conceptual
ms.date: 06/13/2025
---

# Migrate from Self-hosted Prometheus to Azure Monitor Managed Service for Prometheus
Prometheus is a widely adopted open-source monitoring solution known for its powerful capabilities in collecting, storing, and querying time-series data. Many organizations start with self-managed Prometheus set ups, but as systems scale, the operational overhead of managing Prometheus environments can become significant. Azure Monitor managed service for Prometheus offers a compelling alternative, delivering the core benefits of Prometheus along with scalability, and reduced maintenance efforts. 
This document provides guidance for organizations planning to migrate from self-managed Prometheus to Azure Monitor managed service for Prometheus.

## Why migrate to Azure Monitor Managed Service for Prometheus?
Azure Monitor’s managed service for Prometheus enables users to leverage Prometheus functionality while benefiting from Azure’s cloud-native, enterprise-grade capabilities. The key advantages include:

- Fully managed service with:
  - Automatic upgrades and scaling.
  - [Simple pricing based on ingestion and query](https://azure.microsoft.com/pricing/details/monitor/)
  - Data retention for 18 months (with no cost for storage)
- Monitoring and observability, including:
  - [End-to-end, at-scale monitoring](../containers/container-insights-overview.md)
  - Out-of-the-box dashboards, alerts, and scrape configurations
  - Native integration with key AKS components viz. Customer Control Plane, ACNS, etc.
  - [Compliance with Azure Trust Center](azure-monitor-workspace-overview.md#data-considerations)
- Native integration with other Azure services, such as  [Azure Managed Grafana](/azure/managed-grafana/overview) or [Azure Monitor Dashboards with Grafana](../visualize/visualize-use-grafana-dashboards.md) for dashboarding

## Introduction to key concepts

- [**Metric collection**] Data Collection and customization: You can use Azure Managed Prometheus as
  - **A fully managed service or drop-in replacement for self-managed Prometheus**: In this case data is collected by a managed add-on within your AKS or ARC-enabled K8S cluster. Data collection can be configured using Custom resources (Pod and service monitors) and/or the add-on ConfigMaps. The format of the pod/service monitors and ConfigMaps are same as open-source Prometheus, enabling you to use existing configs directly with Azure Managed Prometheus.
  - **A remote-write target**: You can use Prometheus remote_write to send metrics from your existing Prometheus server running in Azure or non-Azure environments to send data to Azure Monitor Workspace. This can be ideal for gradual migration from self-hosted to the fully managed add-on.

- [**Metric collection**] **Prometheus Operator and Custom Resource Definitions**: [Enabling Managed Prometheus add-on](../containers/kubernetes-monitoring-enable.md) in an AKS cluster will deploy the [Pod](https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/api.md#monitoring.coreos.com/v1.PodMonitor) and [Service Monitor](https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/api.md#monitoring.coreos.com/v1.ServiceMonitor) custom resource definitions to allow you to create your own custom resources. Customers can customize scraping targets using Pod Monitors and Service Monitors, similar to the OSS Prometheus Operator.

> [!NOTE]
> Currently PrometheusRule CRD is not supported with Azure Managed Prometheus.


- [**Storage**] **Data is stored in Azure Monitor Workspace**: Prometheus metrics are stored in [Azure Monitor workspace (AMW)](azure-monitor-workspace-overview.md), which is a unique environment for data collected by Azure Monitor. Each workspace has its own data repository, configuration, and permissions. Data is stored for 18 months.

> [!NOTE]
> Log Analytics workspaces contain logs and metrics data from multiple Azure resources, whereas Azure Monitor workspaces currently contain only metrics related to Prometheus. Azure Monitor workspaces will eventually contain all metric data collected by Azure Monitor.

- **[Alerting] Prometheus Rule Groups for Recording Rules and Alerts**: [Azure Managed Prometheus Rule Groups](prometheus-rule-groups.md) provides a managed and scalable way to create and update recording rules and alerts. The Rule Groups are following on [Prometheus rules configuration](https://prometheus.io/docs/prometheus/latest/configuration/recording_rules/#configuring-rules) and you can convert your existing recording rules and alerts to an Azure Managed Prometheus Rule Group.

- **[Visualization] Azure Managed Grafana (or Bring your own Grafana)**: Azure Managed Grafana is a data visualization platform built on top of the Grafana software by Grafana Labs. It's built as a fully managed Azure service operated and supported by Microsoft. Whether you are using Azure Managed Grafana or self-hosted Grafana, you can query metrics from Azure Monitor Workspace. When you enable Managed Prometheus for your AKS or ARC-enabled Kubernetes, we provision out-of-box dashboards that are same as the ones used by open-source [Prometheus Operator](https://github.com/prometheus-operator/kube-prometheus).

## Limitations and differences from open-source Prometheus
The following limitations apply to Azure Monitor managed service for Prometheus:

- The minimum frequency for scraping and storing metrics is 1 second.
- **Case sensitivity**: Azure Monitor managed service for Prometheus is a case-insensitive system. It treats strings (such as metric names, label names, or label values) as the same time series if they differ from another time series only by the case of the string. For more details see [Case-sensitivity in Azure Managed Prometheus](./prometheus-metrics-overview.md#case-sensitivity).
- Certain limitations apply to Metric names, label names & label values. See [here](./prometheus-metrics-overview.md#metric-names-label-names--label-values) for more details.
- Certain limitations apply to PromQL query API for Azure Managed Prometheus. See: [Query Prometheus metrics using the API and PromQL](./prometheus-api-promql.md#api-limitations).
- PrometheusRule CRD is not supported with Azure Managed Prometheus.

## 1. Evaluate your current set up

Before migration, review your self-hosted Prometheus stack:

- **Evaluate capacity requirements**: Azure Monitor Workspace is highly scalable and can support a very large volume of metrics ingestion. By default, there are limits which can be easily increased as per your scale needs.
  - For the managed add-on, the data volume of metrics depends upon the size of the AKS cluster, and how many workloads you plan to run. You can enable Azure Managed Prometheus on a few clusters to estimate the metrics volume. Follow the guide below to learn more.
  - In case you plan to remote write before fully migrating to the Managed add-on agent, you can determine the metrics ingestion volume based on historical usage. You can also look at the metric “prometheus_remote_storage_samples_in_total” to evaluate the metrics volume being sent out through remote-write.
 
- **Installed Prometheus version**: This is needed in case you are using remote_write to send data to Azure Monitor Workspace. See [here](./prometheus-remote-write-virtual-machines.md#supported-versions) for supported versions.

- **Evaluate cost**: Pricing is based on metrics ingestion ($0.16/10M samples) and query ($0.001/10 million samples) volume. See details on Metrics pricing in [Azure Monitor pricing](https://azure.microsoft.com/pricing/details/monitor/). You can use [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator/) to estimate the cost.

- Review the below configurations for your self-hosted Prometheus set up
  - Alerting and recording rules configuration
  - Active data sources and exporters
  - Dashboards
 
This assessment will help identify any customizations requiring attention during migration.

## 2. set up Azure Monitor environment

### Setting up Azure Managed Prometheus via managed add-on
[Enable Managed Prometheus for your AKS or ARC-enabled cluster](../containers/kubernetes-monitoring-enable.md): This will enable the managed Prometheus add-on for your AKS cluster, and provision Azure Monitor Workspace and, you can optionally enable Azure Managed Grafana.

### Setting up Azure Managed Prometheus via remote-write

1. [Create an Azure Monitor Workspace](azure-monitor-workspace-manage.md): Create an Azure Monitor Workspace as the remote endpoint to send metrics from your Prometheus set up using remote-write.
2. [Configure remote-write](prometheus-remote-write-virtual-machines.md) in your Prometheus set up to send data to Azure Monitor Workspace.

## 3. Configure metrics collection and exporters

### Configuring data collection with managed add-on

1. Review the default data/metrics collected by the managed add-on: [Default Prometheus metrics configuration in Azure Monitor](../containers/prometheus-metrics-scrape-default.md). Note that the predefined targets that you can enable/disable are the same as those available with the open-source Prometheus operator, the only difference is that by default we collect metrics that are queried by the auto-provisioned dashboards. The default metrics collected are also referred to as “minimal ingestion profile”.
2. Customize data collection: To customize the targets scraped using the add-on, you can configure the data collection [using the add-on ConfigMap](../containers/prometheus-metrics-scrape-validate.md) or [using Custom resources (Pod and Service Monitors)](../containers/prometheus-metrics-scrape-crd.md). 
    - If you are using Pod Monitor and Service Monitors to monitor your workloads, you can easily migrate them to Azure Managed Prometheus by changing the apiVersion in the Pod/Service Monitors to **azmonitoring.coreos.com/v1**.
    - The Azure Managed Prometheus add-on ConfigMap follows the same format as open-source Prometheus, so in case you have an existing Prometheus config yaml file, you can convert them into add-on ConfigMap. See [here](../containers/prometheus-metrics-scrape-validate.md#deploy-config-file-as-configmap) for more details.
3. Review the list of [commonly used workloads](../containers/prometheus-exporters.md) that have curated configurations and instructions to help you set up metrics collection with Azure Managed Prometheus.

### Configuring data collection with remote-write
Prometheus remote-write configuration allows you to forward scraped metrics to Azure Monitor Workspace. You can configure filtering or relabeling before sending metrics. See [Prometheus remote-write configuration](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#remote_write) for more details.
Also consider [Remote write tuning](https://prometheus.io/docs/practices/remote_write/) to adjust configuration settings for better performance. Consider reducing max_shards and increasing capacity and max_samples_per_send to avoid memory issues. 

## 4. Migrate alerts and dashboards

### Alerting Rules and recording rules
Azure Managed Prometheus supports Prometheus alerting rules and recording rules via Prometheus Rule Groups. [Convert your existing rules to a Prometheus Rule group ARM template](./prometheus-rule-groups.md#converting-prometheus-rules-file-to-a-prometheus-rule-group-arm-template).

Note that with the managed add-on, recommended recording rules are automatically set up as you enable Managed Prometheus for the AKS / ARC-enabled cluster. Review the list of automatically provisioned recording rules [here](../containers/prometheus-metrics-scrape-default.md#recording-rules).

In addition, Prometheus community recommended alerts are also available and can be created out-of-box.

### Dashboards
If you are using Grafana, [Connect Grafana to Azure Monitor Prometheus metrics](prometheus-grafana.md). You can reuse existing dashboards by [importing them to Grafana](/azure/managed-grafana/how-to-create-dashboard#import-a-grafana-dashboard).
If you are using the Azure Managed Grafana or Azure Monitor dashboards with Grafana, default/recommended dashboards are automatically set up and provisioned to enable you to visualize the metrics from the get go. Review the list of automatically provisioned dashboards here.

## 5. Test and validate
1. Verify if you are able to query metrics from Azure Monitor Workspace. You can query the metrics directly from the workspace (In the Azure portal, select the AMW instance -> Metrics) or through Azure managed Grafana instance connected to the workspace.
2. You can access the Prometheus interface for Azure Managed Prometheus to verify jobs/targets scraped: [See Access Prometheus interface for Azure Managed Prometheus](../containers/prometheus-metrics-troubleshoot.md#prometheus-interface).
3. Check alerting workflows and ensure that they trigger appropriately.
4. For remote-write, [verify remote-write deployment](./prometheus-remote-write-virtual-machines.md#verify-that-remote-write-data-is-flowing).
5. For more troubleshooting guidance, see [Troubleshoot collection of Prometheus metrics in Azure Monitor](../containers/prometheus-metrics-troubleshoot.md).

## 6. Monitor limits and quotas
Prometheus metrics are ingested into an Azure Monitor workspace. Azure monitor workspaces have default limits and quotas for ingestion. As you onboard more clusters, you might reach the ingestion limits, and throttling can occur. In order to avoid throttling, [monitor and alert on the workspace ingestion limits](azure-monitor-workspace-monitor-ingest-limits.md).


## Next steps

- Review [best practices for scaling Azure Monitor Workspace](azure-monitor-workspace-scaling-best-practice.md).
- [Enable Managed Prometheus for AKS/ARC-enabled clusters](../containers/kubernetes-monitoring-enable.md).


