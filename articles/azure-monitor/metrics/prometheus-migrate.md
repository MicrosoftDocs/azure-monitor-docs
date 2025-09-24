---
title: Migrate from Self-Hosted Prometheus to Azure Monitor Managed Service for Prometheus
description: Guidance for organizations that are planning to migrate from self-managed Prometheus to Azure Monitor managed service for Prometheus.
ms.topic: conceptual
ms.date: 06/13/2025
---

# Migrate from self-hosted Prometheus to Azure Monitor managed service for Prometheus

This article provides guidance for organizations that are planning to migrate from self-managed Prometheus to Azure Monitor managed service for Prometheus. Prometheus is a widely adopted open-source monitoring solution known for its powerful capabilities in collecting, storing, and querying time-series data. You might start with self-managed Prometheus setups, but as your systems scale, the operational overhead of managing Prometheus environments can become significant. [Azure Monitor managed service for Prometheus](./prometheus-metrics-overview.md) delivers the core benefits of Prometheus along with scalability and reduced maintenance efforts.

## Benefits of Azure Monitor managed service for Prometheus

You can use Azure Monitor managed service for Prometheus to use Prometheus functionality while you benefit from Azure cloud-native, enterprise-grade capabilities. Key advantages are:

- A fully managed service:
  - Automatic upgrades and scaling.
  - Data retention for 18 months with no cost for storage.
  - [Simple pricing based on ingestion and query](https://azure.microsoft.com/pricing/details/monitor/).
- Monitoring and observability:
  - [End-to-end, at-scale monitoring](../containers/kubernetes-monitoring-overview.md).
  - Out-of-the-box dashboards, alerts, and scrape configurations.
  - Native integration with key Azure Kubernetes Service (AKS) components, including [Customer Control Plane](/azure/azure-resource-manager/management/control-plane-and-data-plane) and [Advanced Container Networking Services](/azure/aks/advanced-container-networking-services-overview).
  - [Compliance with Azure Trust Center](azure-monitor-workspace-overview.md#data-considerations).
- Native integration with other Azure services, such as [Azure Managed Grafana](/azure/managed-grafana/overview) or [Azure Monitor dashboards with Grafana](../visualize/visualize-use-grafana-dashboards.md) for dashboarding.

## Key concepts

### Metric collection

Use Azure Managed Prometheus in either of the following configurations:

- **Fully managed service or drop-in replacement for self-managed Prometheus**: In this case, a managed add-on within your AKS or Azure Arc-enabled Kubernetes cluster collects data. You can use custom resources (pod and service monitors) and the add-on ConfigMaps to configure data collection. The format of the pod/service monitors and ConfigMaps are the same as open-source Prometheus. In this way, you can use existing configs directly with Azure Managed Prometheus.
- **Remote-write target**: Use Prometheus remote write to send metrics from your existing Prometheus server running in Azure or non-Azure environments to send data to an Azure Monitor workspace. You can gradually migrate from self-hosted to the fully managed add-on.

[Enabling the Azure Managed Prometheus add-on](../containers/kubernetes-monitoring-enable.md) in an AKS cluster deploys the [pod monitor](https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/api-reference/api.md#monitoring.coreos.com/v1.PodMonitor) and [service monitor](https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/api-reference/api.md#monitoring.coreos.com/v1.ServiceMonitor) custom resource definitions (CRDs) so that you can create your own custom resources. Use pod monitors and service monitors to customize scraping targets, similar to the open-source software Prometheus Operator.

> [!NOTE]
> Currently, the `PrometheusRule` CRD isn't supported with Azure Managed Prometheus.

### Storage

Prometheus metrics are stored in an [Azure Monitor workspace](azure-monitor-workspace-overview.md), which is a unique environment for data that Azure Monitor collects. Each workspace has its own data repository, configuration, and permissions. Data is stored for 18 months.

> [!NOTE]
> Log Analytics workspaces contain logs and metrics data from multiple Azure resources. Azure Monitor workspaces currently contain only metrics related to Prometheus.

### Alerting

[Azure Managed Prometheus rule groups](prometheus-rule-groups.md) provide a managed and scalable way to create and update recording rules and alerts. The rule groups are following on [Prometheus rules configuration](https://prometheus.io/docs/prometheus/latest/configuration/recording_rules/#configuring-rules). You can convert your existing recording rules and alerts to an Azure Managed Prometheus rule group. Prometheus alerts are integrated with other [alerts in Azure Monitor](../alerts/alerts-overview.md).

### Visualization

[Azure Managed Grafana](/azure/managed-grafana/overview) is a data visualization platform built on top of the Grafana software by Grafana Labs. Microsoft operates and supports this fully managed Azure service. Whether you're using Azure Managed Grafana or self-hosted Grafana, you can query metrics from an Azure Monitor workspace. When you enable Managed Prometheus for your AKS or Azure Arc-enabled Kubernetes, we provide out-of-the-box dashboards that are the same as the ones used by open-source [Prometheus Operator](https://github.com/prometheus-operator/kube-prometheus).

## Limitations and differences from open-source Prometheus

The following limitations apply to Azure Monitor managed service for Prometheus:

- The minimum frequency for scraping and storing metrics is one second. See [Case sensitivity in Azure Managed Prometheus](./prometheus-metrics-details.md#case-sensitivity).
- Certain limitations apply to metric names, label names, and label values. See [Metric names, label names, and label values](./prometheus-metrics-details.md#metric-names-label-names--label-values).
- Certain limitations apply to the PromQL query API for Azure Managed Prometheus. See [Query Prometheus metrics by using the API and PromQL](./prometheus-api-promql.md#api-limitations).
- The `PrometheusRule` CRD isn't supported with Azure Managed Prometheus.

## 1. Evaluate your current setup

Before you begin the migration, review the following details of your current self-hosted Prometheus stack.

#### Capacity requirements

An Azure Monitor workspace is highly scalable and can support a large volume of metrics ingestion. You can increase the default limits as your scale requires it.

- For the managed add-on, the data volume of metrics depends on the size of the AKS cluster and how many workloads you plan to run. You can enable Azure Managed Prometheus on a few clusters to estimate the metrics volume.
- If you plan to use remote write before you fully migrate to the managed add-on agent, you can determine the metrics ingestion volume based on historical usage. You can also inspect the metric `prometheus_remote_storage_samples_in_total` to evaluate the metrics volume being sent through remote write.

#### Installed Prometheus version

The Prometheus version is required if you're using remote write to send data to an Azure Monitor workspace. See [Supported versions](./prometheus-remote-write-virtual-machines.md#supported-versions).

#### Cost

Pricing is based on metrics ingestion and query volume. For more information on metrics pricing, see [Azure Monitor pricing](https://azure.microsoft.com/pricing/details/monitor/). You can use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator/) to estimate the cost.

#### More details

Review the following configurations for your self-hosted Prometheus setup. This assessment helps to identify any customizations that require attention during migration.

- Alerting and recording rules configuration
- Active data sources and exporters
- Dashboards

## 2. Configure Azure Managed Prometheus

There are two methods to configure Azure Managed Prometheus, as described on the following tabs.

### [Managed add-on](#tab/entra-application)

To enable the managed Prometheus add-on for your AKS cluster and provision your Azure Monitor workspace, see [Enable monitoring for Kubernetes clusters](../containers/kubernetes-monitoring-enable.md).

### [Remote write](#tab/remote-write)

1. [Create an Azure Monitor workspace](azure-monitor-workspace-manage.md) as the remote endpoint to send metrics from your Prometheus setup by using remote write.
1. [Configure remote write](prometheus-remote-write-virtual-machines.md) in your Prometheus setup to send data to an Azure Monitor workspace.

---

## 3. Configure metrics collection and exporters

There are two methods to configure metrics collection, as described on the following tabs.

### [Managed add-on](#tab/entra-application)

1. Review the default data/metrics collected by the managed add-on at [Default Prometheus metrics configuration in Azure Monitor](../containers/prometheus-metrics-scrape-default.md). The predefined targets that you can enable or disable are the same as the targets that are available with the open-source Prometheus operator. The only difference is that the metrics collected by default are the ones queried by the automatically provisioned dashboards. These default metrics are referred to as [minimal ingestion profile](../containers/prometheus-metrics-scrape-default.md#minimal-ingestion-profile).

1. To customize the targets that are scraped by using the add-on, configure the data collection by using the [add-on ConfigMap](../containers/prometheus-metrics-scrape-validate.md) or by using [custom resources (pod and service monitors)](../containers/prometheus-metrics-scrape-crd.md).
    - If you're using pod monitors and service monitors to monitor your workloads, migrate them to Azure Managed Prometheus by changing `apiVersion` to `azmonitoring.coreos.com/v1`.
    - The Azure Managed Prometheus add-on ConfigMap follows the same format as open-source Prometheus. If you have an existing Prometheus configuration YAML file, convert them into the ConfigMap add-on. See [Create and validate custom configuration file for Prometheus metrics in Azure Monitor](../containers/prometheus-metrics-scrape-validate.md#deploy-config-file-as-configmap).
1. Review the list of [commonly used workloads](../containers/prometheus-exporters.md) that have curated configurations and instructions to help you set up metrics collection with Azure Managed Prometheus.

### [Remote write](#tab/remote-write)

With the Prometheus remote-write configuration, you can forward scraped metrics to an Azure Monitor workspace. You can configure filtering or relabeling before you send metrics. See [Prometheus remote-write configuration](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#remote_write).

Also consider [remote-write tuning](https://prometheus.io/docs/practices/remote_write/) to adjust configuration settings for better performance. Consider reducing `max_shards` and increasing capacity and `max_samples_per_send` to avoid memory issues.

---

## 4. Migrate alerts and dashboards

### Alerting rules and recording rules

Azure Managed Prometheus supports Prometheus alerting rules and recording rules with Prometheus rule groups. See [Convert your existing rules to a Prometheus rule group Azure Resource Manager template](./prometheus-rule-groups.md#convert-prometheus-rules-file-to-a-managed-prometheus-rule-group).

With the managed add-on, recommended recording rules are automatically set up as you enable Managed Prometheus for your AKS or Azure Arc-enabled cluster. To review the list of automatically provisioned recording rules, see [Default Prometheus metrics configuration in Azure Monitor](../containers/prometheus-metrics-scrape-default.md#recording-rules). Prometheus community recommended alerts are also available, and you can create them out-of-the-box.

### Dashboards

If you're using Grafana, [connect Grafana to Azure Monitor Prometheus metrics](prometheus-grafana.md). You can reuse existing dashboards by [importing them to Grafana](/azure/managed-grafana/how-to-create-dashboard#import-a-grafana-dashboard).
If you're using the Azure Managed Grafana or Azure Monitor dashboards with Grafana, the default or recommended dashboards are automatically set up and provisioned so that you can visualize the metrics. To review the list of automatically provisioned dashboards, see [Default Prometheus metrics configuration in Azure Monitor](../containers/prometheus-metrics-scrape-default.md#dashboards).

## 5. Test and validate

After your migration is finished, validate that your setup is working as expected:

- Verify that you can query metrics from an Azure Monitor workspace. You can query the metrics directly from the **Metrics** option for the workspace instance in the Azure portal or with a Grafana instance connected to the workspace.
- Verify that you can access the Prometheus interface for Azure Managed Prometheus to verify jobs and confirm that targets are scraped. See [Access Prometheus interface for Azure Managed Prometheus](../containers/prometheus-metrics-troubleshoot.md#prometheus-interface).
- Verify that any alerting workflows trigger as expected.
- Verify that remote write is working as expected. See [Verify remote-write deployment](./prometheus-remote-write-virtual-machines.md#verify-that-remote-write-data-is-flowing).
- For more troubleshooting guidance, see [Troubleshoot collection of Prometheus metrics in Azure Monitor](../containers/prometheus-metrics-troubleshoot.md).

## 6. Monitor limits and quotas

Azure Monitor workspaces have default limits and quotas for ingestion. You might experience throttling as you onboard more clusters and reach the ingestion limits. [Monitor and alert on the workspace ingestion limits](azure-monitor-workspace-monitor-ingest-limits.md) to ensure that you don't reach throttling limits.

## Related content

- Review [best practices for scaling an Azure Monitor workspace](azure-monitor-workspace-scaling-best-practice.md).
- Enable [Managed Prometheus for AKS/Azure Arc-enabled clusters](../containers/kubernetes-monitoring-enable.md).
