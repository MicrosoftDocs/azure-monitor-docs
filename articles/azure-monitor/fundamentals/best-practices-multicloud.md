---
title: Multicloud monitoring with Azure Monitor
description: Guidance and recommendations for using Azure Monitor to monitor resources and applications in other clouds.
ms.topic: best-practice
ms.date: 08/07/2026
ms.reviewer:
ai-usage: ai-assisted

---

# Multicloud monitoring with Azure Monitor

In addition to monitoring services and applications in Azure, Azure Monitor can provide complete monitoring for your resources and applications running in other clouds, including Amazon Web Services (AWS) and Google Cloud Platform (GCP). This article describes features of Azure Monitor that allow you to provide complete monitoring across your AWS and GCP environments.

The following table maps common workloads to their AWS and GCP equivalents, the Azure Monitor capability that monitors them, and the technology that enables collection.

| Workload | AWS | GCP | Azure Monitor capability | Enabling technology |
|----------|-----|-----|--------------------------|---------------------|
| Virtual machines | EC2 instances | Compute Engine VMs | VM insights, guest telemetry | Azure Arc-enabled servers, Azure Monitor Agent |
| Kubernetes clusters | EKS | GKE | Container insights, Managed Prometheus | Azure Arc-enabled Kubernetes, Prometheus remote write |
| Applications | Any host | Any host | Application Insights | Application Insights SDKs |
| Audit and security logs | CloudTrail | Cloud Audit Logs | Log Analytics, Microsoft Sentinel | Microsoft Sentinel connectors, Logs Ingestion API |
| Custom data | Any REST source | Any REST source | Log Analytics | Logs Ingestion API, Logstash plugin |

## Monitor virtual machines in AWS and GCP

[Azure Arc-enabled servers](/azure/azure-arc/servers/overview) provide a consistent experience between both Azure virtual machines and your AWS EC2 or GCP virtual machine (VM) instances. This management experience includes standard Azure constructs such as Azure Policy and tags. The [Azure Monitor Agent](../agents/azure-monitor-agent-overview.md) collects telemetry from the client operating system of virtual machines regardless of their location. Use the same [data collection rules](../data-collection/data-collection-rule-overview.md) that define your data collection across all of the virtual machines in your different cloud environments. With [VM insights](../vm/monitor-vm.md) in Azure Monitor, view your hybrid machines right alongside your Azure machines and onboard them using identical methods.

* [Plan and deploy Azure Arc-enabled servers](/azure/azure-arc/servers/plan-at-scale-deployment)
* [Manage Azure Monitor Agent](../agents/azure-monitor-agent-manage.md)
* [Enable VM monitoring](../vm/vm-enable-monitoring.md)

If you use Defender for Cloud for security management and threat detection, use auto provisioning to automate the deployment of the Azure Arc agent to your AWS EC2 and GCP VM instances.

* [Connect your AWS accounts to Microsoft Defender for Cloud](/azure/defender-for-cloud/quickstart-onboard-aws)
* [Connect your GCP projects to Microsoft Defender for Cloud](/azure/defender-for-cloud/quickstart-onboard-gcp)

## Monitor AWS EKS and GCP GKE clusters

[Managed Prometheus](../metrics/prometheus-metrics-overview.md) and [Container insights](../containers/kubernetes-monitoring-overview.md) in Azure Monitor use [Azure Arc-enabled Kubernetes](/azure/azure-arc/kubernetes/overview) to provide a consistent experience between both [Azure Kubernetes Service (AKS)](/azure/aks/intro-kubernetes) and Kubernetes clusters in your AWS EKS or GCP GKE instances. View your hybrid clusters right alongside your Azure machines and onboard them using the same methods. This management experience includes standard Azure constructs such as Azure Policy and tags.

Use Prometheus [remote write](../metrics/prometheus-remote-write.md) from your on-premises, AWS, or GCP clusters to send data to Azure managed service for Prometheus.

The [Azure Monitor Agent](../agents/azure-monitor-agent-overview.md) installed by Container insights collects telemetry from the client operating system of clusters regardless of their location. Use the same analysis tools, [Managed Grafana](/azure/managed-grafana/overview), and Container insights, to monitor clusters across your different cloud environments.

* [Connect an existing Kubernetes cluster to Azure Arc](/azure/azure-arc/kubernetes/quickstart-connect-cluster)
* [Enable monitoring for Azure Arc-enabled Kubernetes clusters](../containers/kubernetes-monitoring-enable-arc.md)
* [Monitoring Azure Kubernetes Service (AKS) with Azure Monitor](/azure/aks/monitor-aks)

## Monitor applications hosted outside Azure

Instrument applications hosted outside Azure to send telemetry to [Azure Monitor Application Insights](../app/app-insights-overview.md) by using SDKs for [supported languages](../app/app-insights-overview.md#getting-started). Plan regular maintenance to keep the SDKs within the versions covered by the [Application Insights SDK support guidance](/troubleshoot/azure/azure-monitor/app-insights/telemetry/sdk-support-guidance).

* If you use [Grafana](https://grafana.com/grafana/) for visualization of monitoring data across your different clouds, use the [Azure Monitor data source](https://grafana.com/docs/grafana/latest/datasources/azure-monitor/) to include application log and metric data in your dashboards.
* If you use [Datadog](https://www.datadoghq.com/), use [Azure integrations](https://www.datadoghq.com/blog/azure-monitoring-enhancements/) to include application log and metric data in your Datadog UI.

## Collect AWS and GCP audit logs

In addition to monitoring the health of your cloud resources, consolidate auditing data from your AWS and GCP clouds into your Log Analytics workspace to unify your analysis and reporting. Use Microsoft Sentinel to consolidate audit data. Microsoft Sentinel uses the same workspace as Azure Monitor and provides extra features for collecting and analyzing security and auditing data.

Use the first-party Microsoft Sentinel connectors to ingest AWS and GCP audit data. If a first-party connector doesn't cover a scenario, the community-maintained samples that follow can fill the gap.

To ingest AWS service log data into Microsoft Sentinel, use the following methods:

* [Microsoft Sentinel connector for Amazon Web Services](/azure/sentinel/connect-aws) (first-party)
* [Azure function sample](https://github.com/andedevsecops/AWS-CloudTrail-AzFunc) (community-maintained)
* [AWS Lambda function sample](https://github.com/andedevsecops/aws-data-connector-az-sentinel) (community-maintained)

To collect GCP audit and Pub/Sub events and ingest them into Microsoft Sentinel or a Log Analytics workspace, use the following methods:

* [Microsoft Sentinel connector for Google Cloud Platform](/azure/sentinel/connect-google-cloud-platform) (first-party)
* [Azure Log Analytics output plugin for Logstash](https://github.com/Azure/Azure-Sentinel/tree/master/DataConnectors/microsoft-logstash-output-azure-loganalytics) (first-party)
* [Google Cloud Storage Input Plugin](https://www.elastic.co/guide/en/logstash/current/plugins-inputs-google_cloud_storage.html) (third-party)
* [GCP Cloud Functions sample](https://github.com/andedevsecops/azure-sentinel-gcp-data-connector) (community-maintained)
* [Google_pubsub input plugin](https://www.elastic.co/guide/en/logstash/current/plugins-inputs-google_pubsub.html#plugins-inputs-google_pubsub) (third-party)

## Collect custom data from AWS and GCP

To collect data from your AWS and GCP resources that doesn't fit into standard collection methods, use the following methods:

* Send custom log data from any REST API client with the [Logs Ingestion API in Azure Monitor](../logs/logs-ingestion-api-overview.md)
* Use Logstash to collect data and the [Azure Log Analytics output plugin for Logstash](https://github.com/Azure/Azure-Sentinel/tree/master/DataConnectors/microsoft-logstash-output-azure-loganalytics) to ingest it into a Log Analytics workspace.

## Manage non-Azure machines

Use [Azure Update Manager](/azure/update-manager/overview) to assess update compliance and install operating system updates on Windows and Linux servers in Azure, on-premises, and in other clouds. Update Manager supports Azure Arc-enabled servers and doesn't depend on Azure Automation or Log Analytics.

Use [Azure Change Tracking and Inventory](/azure/azure-change-tracking-inventory/overview-monitoring-agent) to monitor configuration changes and collect inventory from Azure and Arc-enabled servers. Change Tracking and Inventory uses the Azure Monitor Agent and data collection rules to send data to a Log Analytics workspace. It tracks files, registry keys, software, Windows services, and Linux daemons. This capability is separate from update assessment and patching in Update Manager.

For process automation, use [Azure Automation](/azure/automation/overview). [Hybrid Runbook Worker](/azure/automation/automation-hybrid-runbook-worker) runs Azure Automation runbooks directly on Azure Arc-enabled servers so the runbooks can manage local resources.
