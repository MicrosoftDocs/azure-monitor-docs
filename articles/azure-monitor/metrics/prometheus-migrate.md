---
title: Migrate from Self-Hosted Prometheus to Azure Monitor Managed Service for Prometheus
description: Guidance for organizations that are planning to migrate from self-managed Prometheus to Azure Monitor managed service for Prometheus.
ms.topic: conceptual
ms.date: 06/13/2025
---

# Migrate from self-hosted Prometheus to Azure Monitor managed service for Prometheus

[Azure Monitor and Prometheus](./prometheus-metrics-overview.md) describes Azure Monitor managed service for Prometheus which is a fully managed service that enables you to collect, store, and analyze Prometheus metrics without maintaining your own Prometheus server. This article provides guidance for migrating to this Azure service from your existing self-managed Prometheus for monitoring of your virtual machines and Kubernetes clusters. 

## Key concepts

### Metric collection
Use Azure Managed Prometheus in either of the following configurations:

- **Fully managed service or replacement for self-managed Prometheus**<br>Azure Monitor installs a managed add-on in your AKS or Arc-enabled Kubernetes cluster to collect data. You can use custom resources (pod and service monitors) and the add-on ConfigMaps to configure data collection. The format of the pod/service monitors and ConfigMaps are the same as open-source Prometheus. In this way, you can use existing configs directly with Azure Managed Prometheus.
- **Remote-write target**<br>Use Prometheus remote write to send metrics from your existing Prometheus server running in Azure or non-Azure environments to send data to an Azure Monitor workspace. You can then gradually migrate from self-hosted to the fully managed add-on.

### Storage

Prometheus metrics are stored in an [Azure Monitor workspace](azure-monitor-workspace-overview.md), which is a unique environment for data that Azure Monitor collects. Each workspace has its own data repository, configuration, and permissions. Data is stored for 18 months.

### Alerting

[Azure Managed Prometheus rule groups](prometheus-rule-groups.md) provide a managed and scalable way to create and update [recording rules and alerts](https://prometheus.io/docs/prometheus/latest/configuration/recording_rules/#configuring-rules). You can convert your existing recording rules and alerts to an Azure Managed Prometheus rule group. Prometheus alerts are integrated with other [alerts in Azure Monitor](../alerts/alerts-overview.md).

### Visualization

[Azure Managed Grafana](/azure/managed-grafana/overview) is a data visualization platform built on top of the Grafana software by Grafana Labs. Microsoft operates and supports this fully managed Azure service. Whether you're using Azure Managed Grafana or self-hosted Grafana, you can query metrics from an Azure Monitor workspace. When you enable Managed Prometheus for your AKS or Azure Arc-enabled Kubernetes, out-of-the-box dashboards are provided that are the same as the ones used by open-source [Prometheus Operator](https://github.com/prometheus-operator/kube-prometheus).

> [!NOTE]
> [Azure Monitor dashboards with Grafana](../visualize/visualize-grafana-overview.md) is now in public preview. This version of Grafana is hosted in Azure and requires no configuration to connect to Azure Monitor managed service for Prometheus. 

### Cost

Pricing is based on metrics ingestion and query volume. For more information on metrics pricing, see [Azure Monitor pricing](https://azure.microsoft.com/pricing/details/monitor/). You can use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator/) to estimate the cost.

## Limitations and differences from open-source Prometheus

- The minimum frequency for scraping and storing metrics is one second.
- Certain limitations apply to metric names, label names, and label values. See [Metric names, label names, and label values](./prometheus-metrics-details.md#metric-names-label-names--label-values).
- Certain limitations apply to the PromQL query API for Azure Managed Prometheus. See [Query Prometheus metrics by using the API and PromQL](./prometheus-api-promql.md#api-limitations).
- The `PrometheusRule` CRD isn't supported with Azure Managed Prometheus.
- Azure Monitor managed service for Prometheus is case-insensitive. See [Case sensitivity in Azure Managed Prometheus](./prometheus-metrics-details.md#case-sensitivity).


## Evaluate your current configuration

Before you begin the migration, review the following details of your current self-hosted Prometheus stack.

### Installed Prometheus version

The Prometheus version is required if you're using remote write to send data to an Azure Monitor workspace. See [Supported versions](./prometheus-remote-write-virtual-machines.md#supported-versions).


### Capacity requirements

An Azure Monitor workspace is highly scalable and can support a large volume of metrics ingestion. You can increase the default limits as your scale requires it.

- For the managed add-on, the data volume of metrics depends on the size of the AKS cluster and how many workloads you plan to run. You can enable Azure Managed Prometheus on a few clusters to estimate the metrics volume.
- If you plan to use remote write before you fully migrate to the managed add-on agent, you can determine the metrics ingestion volume based on historical usage. You can also inspect the metric `prometheus_remote_storage_samples_in_total` to evaluate the metrics volume being sent through remote write.

### Additional details

Review the following configurations for your self-hosted Prometheus setup. This assessment helps to identify any customizations that require attention during migration.

- Alerting and recording rules configuration
- Active data sources and exporters
- Dashboards

## Configure Azure Managed Prometheus

Enable Azure Managed Prometheus by [creating an Azure Monitor workspace](azure-monitor-workspace-manage.md) as the remote endpoint to send metrics from your Prometheus setup by using remote write.

Once Managed Prometheus is enabled, you can either [enable the managed Prometheus add-on for your AKS and Arc-enabled clusters](../containers/kubernetes-monitoring-enable.md), or you can configure [remote write](./prometheus-remote-write.md) to send data from your self-hosted Prometheus environment to Azure Managed Prometheus without directly onboarding your existing clusters. You may choose to keep your self-hosted Prometheus environment long term or just keep remote write enabled as a temporary solution while you migrate to the managed add-on.


## Configure metrics collection and exporters

**Managed add-on**

Review the default metrics collected by the managed add-on at [Default Prometheus metrics configuration in Azure Monitor](../containers/prometheus-metrics-scrape-default.md). The predefined targets that you can enable or disable are the same as the targets that are available with the open-source Prometheus operator. The only difference is that the metrics collected by default are the ones queried by the automatically provisioned dashboards. 

- Customize collection for default targets by [modifying the metrics setting ConfigMap](../containers/prometheus-metrics-scrape-configuration.md). For additional targets or more significant customizations, create a custom scrape job using either [ConfigMaps](../containers/prometheus-metrics-scrape-configmap.md) or [custom resource definitions (CRDs)](../containers/prometheus-metrics-scrape-crd.md).
- Review the list of [commonly used workloads](../containers/prometheus-exporters.md) that have curated configurations and instructions to help you set up metrics collection with Azure Managed Prometheus.
- If you're using pod monitors and service monitors to monitor your workloads, migrate them to Azure Managed Prometheus by changing `apiVersion` to `azmonitoring.coreos.com/v1`.
- If you have an existing Prometheus configuration YAML file, convert them into the ConfigMap add-on. See [Deploy config file as ConfigMap](../containers/prometheus-metrics-scrape-configmap.md#deploy-config-file-as-configmap).

**Remote-write**

If you're using remote-write to forward scraped metrics to an Azure Monitor workspace, configure filtering or relabeling before you send metrics. See [Prometheus remote-write configuration](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#remote_write). Also consider [remote-write tuning](https://prometheus.io/docs/practices/remote_write/) to adjust configuration settings for better performance. Consider reducing `max_shards` and increasing capacity and `max_samples_per_send` to avoid memory issues.


## Migrate alerts and dashboards

### Alerting rules and recording rules

Azure Managed Prometheus supports Prometheus alerting rules and recording rules with Prometheus rule groups. When you [enable Managed Prometheus for your Kubernetes cluster](../containers/kubernetes-monitoring-enable.md), [recommended recording rules](../containers/prometheus-metrics-scrape-default.md#recording-rules) are automatically configured, and you can enable a set of [alerts recommended by the Prometheus community](../containers/kubernetes-metric-alerts.md).

If you have existing alerting and recording rules in your self-hosted Prometheus environment that you want to retain, see [Convert your existing rules to a Prometheus rule group Azure Resource Manager template](./prometheus-rule-groups.md#convert-prometheus-rules-file-to-a-managed-prometheus-rule-group).


### Dashboards

If you're using Grafana, [connect Grafana to Azure Monitor Prometheus metrics](prometheus-grafana.md). You can reuse existing dashboards by [importing them to Grafana](/azure/managed-grafana/how-to-create-dashboard#import-a-grafana-dashboard).

If you're using the Azure Managed Grafana or Azure Monitor dashboards with Grafana, the default or recommended dashboards are automatically provisioned. See [Default Prometheus metrics configuration in Azure Monitor](../containers/prometheus-metrics-scrape-default.md#dashboards) to review the list of automatically provisioned dashboards.

## Test and validate

After your migration is finished, validate that your setup is working as expected:

- Verify that you can query metrics from an Azure Monitor workspace. See [Azure Monitor metrics explorer with PromQL](./metrics-explorer.md).
- Verify that you can access the Prometheus interface for Azure Managed Prometheus to verify jobs and confirm that targets are scraped. See [Access Prometheus interface for Azure Managed Prometheus](../containers/prometheus-metrics-troubleshoot.md#prometheus-interface).
- Verify that any alerting workflows trigger as expected.
- If you configured remote write, see [Verify remote-write deployment](./prometheus-remote-write-virtual-machines.md#verify-that-remote-write-data-is-flowing).
- For more troubleshooting guidance, see [Troubleshoot collection of Prometheus metrics in Azure Monitor](../containers/prometheus-metrics-troubleshoot.md).

## Monitor limits and quotas

Azure Monitor workspaces have default limits and quotas for ingestion. You might experience throttling as you onboard more clusters and reach the ingestion limits. [Monitor and alert on the workspace ingestion limits](azure-monitor-workspace-monitor-ingest-limits.md) to ensure that you don't reach throttling limits.

## Related content

- Review [best practices for scaling an Azure Monitor workspace](azure-monitor-workspace-scaling-best-practice.md).
- Enable [Managed Prometheus for AKS/Azure Arc-enabled clusters](../containers/kubernetes-monitoring-enable.md).
