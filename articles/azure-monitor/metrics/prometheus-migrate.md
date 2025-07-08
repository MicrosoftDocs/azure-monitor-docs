---
title: Migrate from Self-hosted Prometheus to Azure Monitor Managed Service for Prometheus
description: Guidance for organizations planning to migrate from self-managed Prometheus to Azure Monitor managed service for Prometheus.
ms.topic: conceptual
ms.date: 06/13/2025
---

# Migrate from Self-hosted Prometheus to Azure Monitor Managed Service for Prometheus
This article provides guidance for organizations planning to migrate from self-managed Prometheus to Azure Monitor managed service for Prometheus. Prometheus is a widely adopted open-source monitoring solution known for its powerful capabilities in collecting, storing, and querying time-series data. You may start with self-managed Prometheus setups, but as your systems scale, the operational overhead of managing Prometheus environments can become significant. [Azure Monitor managed service for Prometheus](./prometheus-metrics-overview.md) delivers the core benefits of Prometheus along with scalability, and reduced maintenance efforts. 


## Benefits of Azure Monitor Managed Service for Prometheus
Azure Monitor managed service for Prometheus enables you to leverage Prometheus functionality while benefiting from Azure’s cloud-native, enterprise-grade capabilities. The key advantages include:

- Fully managed service
  - Automatic upgrades and scaling.
  - Data retention for 18 months with no cost for storage
  - [Simple pricing based on ingestion and query](https://azure.microsoft.com/pricing/details/monitor/)
- Monitoring and observability
  - [End-to-end, at-scale monitoring](../containers/container-insights-overview.md)
  - Out-of-the-box dashboards, alerts, and scrape configurations
  - Native integration with key AKS components including [Customer Control Plane](/azure/azure-resource-manager/management/control-plane-and-data-plane) and [Advanced Container Networking Services](/azure/aks/advanced-container-networking-services-overview).
  - [Compliance with Azure Trust Center](azure-monitor-workspace-overview.md#data-considerations)
- Native integration with other Azure services, such as  [Azure Managed Grafana](/azure/managed-grafana/overview) or [Azure Monitor Dashboards with Grafana](../visualize/visualize-use-grafana-dashboards.md) for dashboarding

## Key concepts

### Metric collection

Use Azure Managed Prometheus in either of the following configurations:

- **Fully managed service or drop-in replacement for self-managed Prometheus**: In this case data is collected by a managed add-on within your AKS or ARC-enabled K8S cluster. Data collection can be configured using Custom resources (Pod and service monitors) and/or the add-on ConfigMaps. The format of the pod/service monitors and ConfigMaps are same as open-source Prometheus, enabling you to use existing configs directly with Azure Managed Prometheus.
- **Remote-write target**: Use Prometheus remote_write to send metrics from your existing Prometheus server running in Azure or non-Azure environments to send data to Azure Monitor Workspace. This can be ideal for gradual migration from self-hosted to the fully managed add-on.

[Enabling Managed Prometheus add-on](../containers/kubernetes-monitoring-enable.md) in an AKS cluster will deploy the [Pod](https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/api-reference/api.md#monitoring.coreos.com/v1.PodMonitor) and [Service Monitor](https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/api-reference/api.md#monitoring.coreos.com/v1.ServiceMonitor) custom resource definitions to allow you to create your own custom resources. Customize scraping targets using Pod Monitors and Service Monitors, similar to the OSS Prometheus Operator.

> [!NOTE]
> Currently PrometheusRule CRD is not supported with Azure Managed Prometheus.

### Storage
Prometheus metrics are stored in [Azure Monitor workspace (AMW)](azure-monitor-workspace-overview.md), which is a unique environment for data collected by Azure Monitor. Each workspace has its own data repository, configuration, and permissions. Data is stored for 18 months.

> [!NOTE]
> Log Analytics workspaces contain logs and metrics data from multiple Azure resources, while Azure Monitor workspaces currently contain only metrics related to Prometheus. 

### Alerting

[Azure Managed Prometheus Rule Groups](prometheus-rule-groups.md) provides a managed and scalable way to create and update recording rules and alerts. The Rule Groups are following on [Prometheus rules configuration](https://prometheus.io/docs/prometheus/latest/configuration/recording_rules/#configuring-rules) and you can convert your existing recording rules and alerts to an Azure Managed Prometheus Rule Group. Prometheus alerts are integrated with other [alerts in Azure Monitor](../alerts/alerts-overview.md).

### Visualization

[Azure Managed Grafana](/azure/managed-grafana/overview) is a data visualization platform built on top of the Grafana software by Grafana Labs. It's built as a fully managed Azure service operated and supported by Microsoft. Whether you are using Azure Managed Grafana or self-hosted Grafana, you can query metrics from Azure Monitor Workspace. When you enable Managed Prometheus for your AKS or ARC-enabled Kubernetes, we provision out-of-box dashboards that are same as the ones used by open-source [Prometheus Operator](https://github.com/prometheus-operator/kube-prometheus).

## Limitations and differences from open-source Prometheus
The following limitations apply to Azure Monitor managed service for Prometheus:

- The minimum frequency for scraping and storing metrics is 1 second. See [Case-sensitivity in Azure Managed Prometheus](./prometheus-metrics-overview.md#case-sensitivity).
- Certain limitations apply to Metric names, label names & label values. See [Metric names, label names & label values](./prometheus-metrics-overview.md#metric-names-label-names--label-values).
- Certain limitations apply to PromQL query API for Azure Managed Prometheus. See [Query Prometheus metrics using the API and PromQL](./prometheus-api-promql.md#api-limitations).
- PrometheusRule CRD is not supported with Azure Managed Prometheus.

## 1. Evaluate your current setup

Before you begin the migration, review the following details of your current self-hosted Prometheus stack:

**Capacity requirements**<br>
Azure Monitor workspace is highly scalable and can support a very large volume of metrics ingestion. By default, there are limits which can be easily increased as your scale requires it.

- For the managed add-on, the data volume of metrics depends on the size of the AKS cluster and how many workloads you plan to run. You can enable Azure Managed Prometheus on a few clusters to estimate the metrics volume. 
- If you plan to use remote write before fully migrating to the managed add-on agent, you can determine the metrics ingestion volume based on historical usage. You can also inspect the metric `prometheus_remote_storage_samples_in_total` to evaluate the metrics volume being sent through remote-write.
 
**Installed Prometheus version**<br>
The Prometheus version is required if you're using remote_write to send data to Azure Monitor workspace. See [Supported versions](./prometheus-remote-write-virtual-machines.md#supported-versions).

**Cost**<br>
Pricing is based on metrics ingestion and query volume. See details on Metrics pricing in [Azure Monitor pricing](https://azure.microsoft.com/pricing/details/monitor/). You can use [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator/) to estimate the cost.

**Additional details**<br>
Review the below configurations for your self-hosted Prometheus setup. This assessment will help identify any customizations requiring attention during migration.

- Alerting and recording rules configuration
- Active data sources and exporters
- Dashboards
 

## 2. Configure Azure Managed Prometheus

There are two methods to configure Azure Managed Prometheus as described in the following tabs.

### [Managed add-on](#tab/entra-application)

See [Enable Managed Prometheus for your AKS or ARC-enabled cluster](../containers/kubernetes-monitoring-enable.md) to enable the managed Prometheus add-on for your AKS cluster and provision your Azure Monitor workspace.

### [Remote-write](#tab/remote-write)

1. [Create an Azure Monitor Workspace](azure-monitor-workspace-manage.md) as the remote endpoint to send metrics from your Prometheus setup using remote-write.
2. [Configure remote-write](prometheus-remote-write-virtual-machines.md) in your Prometheus setup to send data to the Azure Monitor Workspace.

---

## 3. Configure metrics collection and exporters

There are two methods to configure metrics collection as described in the following tabs.

### [Managed add-on](#tab/entra-application)

1. Review the default data/metrics collected by the managed add-on at [Default Prometheus metrics configuration in Azure Monitor](../containers/prometheus-metrics-scrape-default.md). The predefined targets that you can enable/disable are the same as those available with the open-source Prometheus operator. The only difference is that the metrics collected by default are the ones queried by the auto-provisioned dashboards. These default metrics are referred to as [minimal ingestion profile](../containers/prometheus-metrics-scrape-default.md#minimal-ingestion-profile).

2. To customize the targets scraped using the add-on, configure the data collection using the [add-on ConfigMap](../containers/prometheus-metrics-scrape-validate.md) or using [Custom resources (Pod and Service Monitors)](../containers/prometheus-metrics-scrape-crd.md). 
    - If you're using Pod Monitor and Service Monitors to monitor your workloads, migrate them to Azure Managed Prometheus by changing the `apiVersion` in the Pod/Service Monitors to `azmonitoring.coreos.com/v1`.
    - The Azure Managed Prometheus add-on ConfigMap follows the same format as open-source Prometheus, so if you have an existing Prometheus config yaml file, convert them into add-on ConfigMap. See [Create and validate custom configuration file for Prometheus metrics in Azure Monitor](../containers/prometheus-metrics-scrape-validate.md#deploy-config-file-as-configmap).
3. Review the list of [commonly used workloads](../containers/prometheus-exporters.md) that have curated configurations and instructions to help you set up metrics collection with Azure Managed Prometheus.

### [Remote-write](#tab/remote-write)
Prometheus remote-write configuration allows you to forward scraped metrics to an Azure Monitor Workspace. You can configure filtering or relabeling before sending metrics. See [Prometheus remote-write configuration](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#remote_write).

Also consider [Remote write tuning](https://prometheus.io/docs/practices/remote_write/) to adjust configuration settings for better performance. Consider reducing `max_shards` and increasing capacity and `max_samples_per_send` to avoid memory issues. 

---

## 4. Migrate alerts and dashboards

### Alerting Rules and recording rules
Azure Managed Prometheus supports Prometheus alerting rules and recording rules with Prometheus Rule Groups. See [Convert your existing rules to a Prometheus Rule group ARM template](./prometheus-rule-groups.md#converting-prometheus-rules-file-to-a-prometheus-rule-group-arm-template).

With the managed add-on, recommended recording rules are automatically set up as you enable Managed Prometheus for your AKS or ARC-enabled cluster. Review the list of automatically provisioned recording rules at [Default Prometheus metrics configuration in Azure Monitor](../containers/prometheus-metrics-scrape-default.md#recording-rules). Prometheus community recommended alerts are also available and can be created out-of-box.

### Dashboards
If you are using Grafana, [Connect Grafana to Azure Monitor Prometheus metrics](prometheus-grafana.md). You can reuse existing dashboards by [importing them to Grafana](/azure/managed-grafana/how-to-create-dashboard#import-a-grafana-dashboard).
If you are using the Azure Managed Grafana or Azure Monitor dashboards with Grafana, default/recommended dashboards are automatically set up and provisioned to enable you to visualize the metrics. Review the list of automatically provisioned dashboards at [Default Prometheus metrics configuration in Azure Monitor](../containers/prometheus-metrics-scrape-default.md#dashboards).

## 5. Test and validate
Once your migration is complete, use the following steps to validate that your setup is working as expected.

1. Verify that you're able to query metrics from the Azure Monitor workspace. You can query the metrics directly from the **Metrics** option for the workspace instance in the Azure portal or with a Grafana instance connected to the workspace.
2. Verify that you can access the Prometheus interface for Azure Managed Prometheus to verify jobs and targets scraped. See [Access Prometheus interface for Azure Managed Prometheus](../containers/prometheus-metrics-troubleshoot.md#prometheus-interface).
3. Verify that any alerting workflows trigger as expected.
4. Verify that remote-write is working as expected. See [verify remote-write deployment](./prometheus-remote-write-virtual-machines.md#verify-that-remote-write-data-is-flowing).
5. For additional troubleshooting guidance, see [Troubleshoot collection of Prometheus metrics in Azure Monitor](../containers/prometheus-metrics-troubleshoot.md).

## 6. Monitor limits and quotas
Azure Monitor workspaces have default limits and quotas for ingestion. You may experience throttling as you onboard more clusters and reach the ingestion limits. [Monitor and alert on the workspace ingestion limits](azure-monitor-workspace-monitor-ingest-limits.md) to ensure that you don't reach throttling limits.


## Next steps

- Review [best practices for scaling Azure Monitor Workspace](azure-monitor-workspace-scaling-best-practice.md).
- [Enable Managed Prometheus for AKS/ARC-enabled clusters](../containers/kubernetes-monitoring-enable.md).


