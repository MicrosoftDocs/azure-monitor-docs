---
title: Monitor Kubernetes clusters using Azure Monitor and cloud native tools
description: Describes how to monitor the health and performance of the different layers of your Kubernetes environment using Azure Monitor and cloud native services in Azure.
ms.topic: best-practice
ms.date: 08/07/2026
ai-usage: ai-assisted
---

# Monitor Kubernetes clusters using Azure Monitor and cloud native tools

[Kubernetes monitoring in Azure Monitor](./kubernetes-monitoring-overview.md) describes the Azure Monitor services that provide complete monitoring of your Kubernetes environment and the workloads that run on it. This article provides best practices for how to leverage these services to monitor the different layers of your Kubernetes environment based on the typical roles that manage them.

Following is an illustration of a common model of a typical Kubernetes environment, starting from the infrastructure layer up through applications. Each layer has distinct monitoring requirements that are addressed by different services and typically managed by different roles in the organization.

:::image type="content" source="media/monitor-kubernetes/layers-with-roles.png" alt-text="Diagram of layers of Kubernetes environment with related administrative roles." lightbox="media/monitor-kubernetes/layers-with-roles.png"  border="false":::

Multiple roles typically share responsibility for the different layers of a Kubernetes environment and the applications that depend on it. Depending on the size of your organization, different people or teams might fill these roles. The following table describes the roles. The sections that follow provide the monitoring scenarios that each role typically encounters.

| Roles | Description |
|:---|:---|
| [Developer](#developer) | Develop and maintain the application running on the cluster. Responsible for application specific traffic including application performance and failures. Maintains reliability of the application according to SLAs. |
| [Platform engineer](#platform-engineer) | Responsible for the Kubernetes cluster. Provisions and maintains the platform used by developer. |
| [Network engineer](#network-engineer) | Responsible for traffic between workloads and any ingress/egress with the cluster. Analyzes network traffic and performs threat analysis. |

## Network engineer
The *Network Engineer* is responsible for traffic between workloads and any ingress/egress with the cluster. They analyze network traffic and perform threat analysis.

:::image type="content" source="media/monitor-kubernetes/layers-network-engineer.png" alt-text="Diagram of layers of Kubernetes environment for network engineer." lightbox="media/monitor-kubernetes/layers-network-engineer.png"  border="false":::

### Monitor level 1 - Network

This layer covers the network traffic flowing into, out of, and between workloads in the cluster.

Following are common scenarios for monitoring the network.

- Create [virtual network flow logs](/azure/network-watcher/vnet-flow-logs-overview) with [Network Watcher](/azure/network-watcher/network-watcher-monitoring-overview) to log information about IP traffic flowing through the virtual networks used by your cluster. Then use [traffic analytics](/azure/network-watcher/traffic-analytics) to analyze this data and provide insights. Use the same Log Analytics workspace for traffic analytics that you use for your container logs and control plane logs.
- Using [traffic analytics](/azure/network-watcher/traffic-analytics), determine if any traffic is flowing either to or from any unexpected ports used by the cluster and also if any traffic is flowing over public IPs that shouldn't be exposed. Use this information to determine whether your network rules need modification.
- For AKS clusters, use the [Network Observability add-on for AKS (preview)](https://aka.ms/NetObsAddonDoc) to monitor and observe access between services in the cluster (east-west traffic).


## Platform engineer

The *platform engineer*, also known as the cluster administrator, is responsible for the Kubernetes cluster itself. They provision and maintain the platform used by developers. They need to understand the health of the cluster and its components, and be able to troubleshoot any detected issues. They also need to understand the cost to operate the cluster and potentially to be able to allocate costs to different teams.

:::image type="content" source="media/monitor-kubernetes/layers-platform-engineer.png" alt-text="Diagram of layers of Kubernetes environment for platform engineer." lightbox="media/monitor-kubernetes/layers-platform-engineer.png"  border="false":::

Large organizations might also have a *fleet architect*, which is similar to the platform engineer but is responsible for multiple clusters. They need visibility across the entire environment and must perform administrative tasks at scale. At scale recommendations are included in the guidance below. See [What is Azure Kubernetes Fleet Manager?](/azure/kubernetes-fleet/overview) for details on creating a Fleet resource for multi-cluster and at-scale scenarios.


### Configure monitoring for platform engineer

The following sections describe how to monitor your Kubernetes environment by using the Azure services in [Container levels](./kubernetes-monitoring-overview.md#container-levels). Each section provides functionality and integration options to help you determine where you might need to modify this configuration to meet your particular requirements. You can onboard Managed Prometheus and container logging as part of the same experience, as described in [Enable monitoring for Kubernetes clusters](../containers/kubernetes-monitoring-enable.md). The following sections describe each service separately to cover all of your onboarding and configuration options.

#### Enable scraping of Prometheus metrics

> [!IMPORTANT]
>  To use Azure Monitor managed service for Prometheus, you need to have an [Azure Monitor workspace](../metrics/azure-monitor-workspace-overview.md). For information on design considerations for a workspace configuration, see [Azure Monitor workspace architecture](../metrics/azure-monitor-workspace-overview.md#azure-monitor-workspace-architecture).

Enable scraping of Prometheus metrics by Azure Monitor managed service for Prometheus from your cluster either when it's created or add this functionality to an existing cluster. See [Enable Prometheus metrics](./kubernetes-monitoring-enable.md#enable-prometheus-metrics-on-an-aks-cluster) for details.

If you already have a self-managed Prometheus environment, use remote write to [send data from that environment to Azure Monitor managed service for Prometheus](../metrics/prometheus-remote-write.md).

See [Default Prometheus metrics configuration in Azure Monitor](./prometheus-metrics-scrape-default.md) for details on the metrics that are collected by default and their frequency of collection. If you want to customize the configuration, see [Customize scraping of Prometheus metrics in Azure Monitor managed service for Prometheus](./prometheus-metrics-scrape-configuration.md).


#### Enable Grafana for analysis of Prometheus data

> [!NOTE]
> [Azure Monitor dashboards with Grafana](../visualize/visualize-grafana-overview.md) is currently in public preview and can replace Azure Managed Grafana. This version of Grafana has no cost, requires no configuration, and presents dashboards in the Azure portal. Use Azure Managed Grafana to create dashboards that combine data from multiple data sources or to integrate with an existing Grafana environment.

[Create an instance of Azure Managed Grafana](/azure/managed-grafana/quickstart-managed-grafana-portal) and [link it to your Azure Monitor workspace](../metrics/azure-monitor-workspace-manage.md#link-a-grafana-workspace) to use your Prometheus data as a data source. To configure this connection manually, see [add Azure Monitor managed service for Prometheus as data source](../metrics/prometheus-grafana.md). A variety of [prebuilt dashboards](../visualize/visualize-use-managed-grafana-how-to.md) are available for monitoring Kubernetes clusters, including several that present similar information as Container insights views.

If you have an existing Grafana environment, continue to use it and add Azure Monitor managed service for [Prometheus as a data source](https://grafana.com/docs/grafana/latest/datasources/prometheus/). To use data collected by Container insights in custom Grafana dashboards, [add the Azure Monitor data source to Grafana](https://grafana.com/docs/grafana/latest/datasources/azure-monitor/). Perform this configuration to focus on Grafana dashboards rather than the Container insights views and reports.

#### Enable collection of container logs

> [!IMPORTANT]
> Collecting container logs requires a [Log Analytics workspace](../logs/log-analytics-workspace-overview.md).

When you enable collection of container logs for your Kubernetes cluster, Azure Monitor deploys a containerized version of the [Azure Monitor agent](../agents/azure-monitor-agent-overview.md) that sends stdout/stderr and infrastructure logs to a [Log Analytics workspace](../logs/log-analytics-workspace-overview.md) in Azure Monitor where they can be analyzed using [Kusto Query Language (KQL)](../logs/log-query-overview.md).

For prerequisites and configuration options for onboarding your Kubernetes clusters, see [Enable monitoring for AKS clusters](./kubernetes-monitoring-enable.md). Onboard by using Azure Policy to ensure that all clusters retain a consistent configuration.

Once container logging is enabled for a cluster, perform the following actions to optimize your installation.

- If you only use logs for occasional troubleshooting, then consider configuring this table as [basic logs](../logs/logs-table-plans.md).
- Use the [Container insights logs presets](container-insights-cost.md#logs-presets) to reduce your data ingestion costs by limiting the amount of data that's collected. Disable collection of metrics by configuring Container insights to collect only **Logs and events** because Prometheus collects many of the same metric values.

If you have an existing solution for collection of logs, then follow the guidance for that tool or enable log collection with Azure Monitor and use the [data export feature of Log Analytics workspace](../logs/logs-data-export.md) to send data to [Azure Event Hubs](/azure/event-hubs/event-hubs-about) to forward to alternate systems.


#### Collect control plane logs for AKS clusters

The logs for AKS control plane components are implemented in Azure as [resource logs](../platform/resource-logs.md). [Create a diagnostic setting](./kubernetes-monitoring-enable.md#enable-control-plane-logs-on-an-aks-cluster) for each AKS cluster to send resource logs to a Log Analytics workspace. Use Azure Policy to ensure consistent configuration across multiple clusters.

There's a cost for sending resource logs to a workspace, so collect only those log categories that you intend to use. For a description of the categories that are available for AKS, see [Resource logs](/azure/aks/monitor-aks-reference#resource-logs).  Start by collecting a minimal number of categories and then modify the diagnostic setting to collect additional categories as your needs increase and as you understand your associated costs. Send logs to an Azure storage account to reduce costs if you need to retain the information for compliance reasons. For details on the cost of ingesting and retaining log data, see [Azure Monitor Logs pricing details](../logs/cost-logs.md).

If you're unsure which resource logs to initially enable, use the following recommendations, which are based on the most common customer requirements. Enable other categories later as needed.

| Category | Enable? | Destination |
|:---|:---|:---|
| kube-apiserver          | Enable | Log Analytics workspace |
| kube-audit              | Enable | Azure storage. This keeps costs to a minimum yet retains the audit logs if they're required by an auditor. |
| kube-audit-admin        | Enable | Log Analytics workspace |
| kube-controller-manager | Enable | Log Analytics workspace |
| kube-scheduler          | Disable | |
| cluster-autoscaler      | Enable if autoscale is enabled | Log Analytics workspace |
| guard                   | Enable if Microsoft Entra ID is enabled | Log Analytics workspace |
| AllMetrics              | Disable since metrics are collected in Managed Prometheus | Log Analytics workspace |

To forward control plane logs to an existing logging solution, use the [data export feature of the Log Analytics workspace](../logs/logs-data-export.md) as described in [Enable collection of container logs](#enable-collection-of-container-logs).

#### Collect Activity log for AKS clusters
Configuration changes to your AKS clusters are stored in the [Activity log](../platform/activity-log.md). [Create a diagnostic setting to send this data to your Log Analytics workspace](../platform/activity-log.md#export-activity-log) to analyze it with other monitoring data. There's no cost for this data collection, and Log Analytics can analyze or alert on the data.


### Monitor level 2 - Cluster level components

This layer covers the nodes that make up the cluster and their compute, storage, and network capacity.

The cluster level includes the following components:

| Component | Monitoring requirements |
|:---|:---|
| Node |  Understand the readiness status and performance of CPU, memory, disk and IP usage for each node and proactively monitor their usage trends before deploying any workloads. |

Following are common scenarios for monitoring the cluster level components.

#### Azure portal

- Use the unified monitoring dashboard in the Azure portal to see the performance of the nodes in your cluster, including CPU and memory utilization.
- Use the **Nodes** view to see the health of each node and the health and performance of the pods running on them. For more information on analyzing node health and performance, see [Analyze Kubernetes cluster performance in the Azure portal.](./container-insights-analyze.md).
- Under **Reports**, use the **Node Monitoring** workbooks to analyze disk capacity, disk IO, and GPU usage. For more information about these workbooks, see [Node Monitoring workbooks](kubernetes-workbooks.md#node-monitoring-workbooks).
- Under **Monitoring**, select **Workbooks**, then **Subnet IP Usage** to see the IP allocation and assignment on each node for a selected time-range.

#### Grafana dashboards

- Use the [prebuilt dashboards](../visualize/visualize-use-managed-grafana-how-to.md) in Azure Managed Grafana to see the health and performance of your nodes.
- Use Grafana dashboards with [Prometheus metric values](../containers/prometheus-metrics-scrape-default.md) related to disk such as `node_disk_io_time_seconds_total` and `windows_logical_disk_free_bytes` to monitor attached storage.
- Multiple [Kubernetes dashboards](https://grafana.com/grafana/dashboards/?search=kubernetes) are available that visualize the performance and health of your nodes based on data stored in Prometheus.

#### Log Analytics

- Select the [Containers category](../logs/queries.md?tabs=groupby#find-and-filter-queries) in the [queries dialog](../logs/queries.md#queries-dialog) for your Log Analytics workspace to access prebuilt log queries for your cluster, including the **Image inventory** log query that retrieves data from the [ContainerImageInventory](/azure/azure-monitor/reference/tables/containerimageinventory) table populated by Container insights.

#### Troubleshooting

- For troubleshooting scenarios, you might need to access nodes directly for maintenance or immediate log collection. For security purposes, AKS nodes aren't exposed to the internet. The `kubectl debug` command creates a privileged pod on the node through the Kubernetes API. For information about this process and optional SSH access from the privileged pod, see [Connect with SSH to Azure Kubernetes Service (AKS) cluster nodes for maintenance or troubleshooting](/azure/aks/ssh).

#### Cost analysis

-  Configure [OpenCost](https://www.opencost.io), which is an open-source, vendor-neutral CNCF sandbox project for understanding your Kubernetes costs, to support your analysis of your cluster costs. It exports detailed costing data to Azure storage.
- Use data from OpenCost to break down relative usage of the cluster by different teams in your organization and allocate the cost between each.
- Use data from OpenCost to ensure that the cluster is using the full capacity of its nodes by densely packing workloads, using fewer large nodes as opposed to many smaller nodes.


### Monitor level 3 - Managed Kubernetes components

This layer covers the Azure-managed control plane components, such as the API server and kubelet.

The managed Kubernetes level includes the following components:

| Component | Monitoring |
|:---|:---|
| API Server | Monitor the status of API server and identify any increase in request load and bottlenecks if the service is down. |
| Kubelet | Monitor kubelet to help troubleshoot pod management issues, pods not starting, nodes not ready, or pods getting killed.  |

Following are common scenarios for monitoring your managed Kubernetes components.

#### Azure portal

- Use [metrics explorer](../metrics/metrics-explorer.md) to view the **Inflight Requests** counter for the cluster.
- Use the [Kubelet workbook](./kubernetes-workbooks.md#resource-monitoring-workbooks) to see the health and performance of each kubelet.

#### Grafana

- Use the [prebuilt dashboard](../visualize/visualize-use-managed-grafana-how-to.md) in Azure Managed Grafana for **Kubelet** to see the health and performance of each kubelet.
- Use a dashboard such as [Kubernetes apiserver](https://grafana.com/grafana/dashboards/12006) for a complete view of the API server performance. This includes such values as request latency and workqueue processing time.

#### Log Analytics

- Use [log queries with resource logs](/azure/aks/monitor-aks#sample-log-queries) to analyze [control plane logs](#collect-control-plane-logs-for-aks-clusters) generated by AKS components.
- The Activity log records any configuration activities for AKS. After you [send the Activity log to a Log Analytics workspace](#collect-activity-log-for-aks-clusters), analyze it by using Log Analytics. For example, the following sample query returns records that identify a successful upgrade across all your AKS clusters.

    ``` kql
    AzureActivity
    | where CategoryValue == "Administrative"
    | where OperationNameValue == "MICROSOFT.CONTAINERSERVICE/MANAGEDCLUSTERS/WRITE"
    | extend properties=parse_json(Properties_d)
    | where properties.message == "Upgrade Succeeded"
    | order by TimeGenerated desc
    ```


#### Troubleshooting

- For troubleshooting scenarios, access kubelet logs by using the process described at [Get kubelet logs from Azure Kubernetes Service (AKS) cluster nodes](/azure/aks/kubelet-logs).

### Monitor level 4 - Kubernetes objects and workloads

This layer covers the deployments, pods, and containers that run your workloads on the cluster.

The Kubernetes objects and workloads level includes the following components:

| Component | Monitoring requirements |
|:---|:---|
| Deployments | Monitor actual vs desired state of the deployment and the status and resource utilization of the pods running on them.  |
| Pods | Monitor status and resource utilization, including CPU and memory, of the pods running on your AKS cluster. |
| Containers | Monitor resource utilization, including CPU and memory, of the containers running on your AKS cluster. |

Following are common scenarios for monitoring your Kubernetes objects and workloads.


#### Azure portal

- Use the **Nodes** and **Controllers** views to see the health and performance of the pods running on them and drill down to the health and performance of their containers.
- Use the **Containers** view to see the health and performance for the containers. For more information on analyzing container health and performance, see [Analyze Kubernetes cluster data with Container insights](./container-insights-analyze.md).
- Use the [Deployments workbook](./kubernetes-workbooks.md#resource-monitoring-workbooks) to see deployment metrics. For more information, see [Deployment & HPA metrics with Container insights](container-insights-deployment-hpa-metrics.md).


#### Grafana dashboards

- Use the [prebuilt dashboards](../visualize/visualize-use-managed-grafana-how-to.md) in Azure Managed Grafana for **Nodes** and **Pods** to view their health and performance.
- Multiple [Kubernetes dashboards](https://grafana.com/grafana/dashboards/?search=kubernetes) are available that visualize the performance and health of your nodes based on data stored in Prometheus.

#### Live data

- In troubleshooting scenarios, Container insights provides access to live AKS container logs (stdout/stderr), events, and pod metrics. For more information about this feature, see [How to view Kubernetes logs, events, and pod metrics in real-time](container-insights-livedata-overview.md).

### Alerts for the platform engineer

[Alerts in Azure Monitor](../alerts/alerts-overview.md) proactively notify you of interesting data and patterns in your monitoring data. They help you identify and address issues in your system before your customers notice them. If you have an existing [ITSM solution](../alerts/itsmc-overview.md) for alerting, [integrate it with Azure Monitor](../alerts/itsmc-overview.md). To use your current alerting solution, [export workspace data](../logs/logs-data-export.md) from your Log Analytics workspace to another supported location.

#### Alert types
The following table describes the different types of custom alert rules to create based on the data collected by the services described earlier.

| Alert type | Description |
|:---|:---|
| Prometheus alerts | [Prometheus alerts](../alerts/prometheus-alerts.md) are written in Prometheus Query Language (PromQL) and applied on Prometheus metrics stored in [Azure Monitor managed services for Prometheus](../metrics/prometheus-metrics-overview.md). Recommended alerts already include the most common Prometheus alerts. [Create additional alert rules](../metrics/prometheus-rule-groups.md) as required. |
| Metric alert rules | Metric alert rules use the same metric values as the Metrics explorer. In fact, you create an alert rule directly from the metrics explorer with the data you're currently analyzing. Metric alert rules can be useful to alert on AKS performance using any of the values in [AKS data reference metrics](/azure/aks/monitor-aks-reference#metrics). |
| Log search alert rules | Use log search alert rules to generate an alert from the results of a log query. For more information, see [How to create log search alerts from Container insights](./container-insights-log-alerts.md) and [How to query logs from Container insights](./container-insights-log-query.md). |

#### Recommended alerts
Start with the [recommended Prometheus community alert rules](kubernetes-metric-alerts.md#prometheus-community-alert-rules), which include the most common alerting conditions for a Kubernetes cluster. Add more alert rules later as you identify additional alerting conditions.

## Developer

In addition to developing the application, the *developer* maintains the application running on the cluster. They're responsible for application specific traffic including application performance and failures and maintain reliability of the application according to company-defined SLAs.

:::image type="content" source="media/monitor-kubernetes/layers-developer.png" alt-text="Diagram of layers of Kubernetes environment for developer." lightbox="media/monitor-kubernetes/layers-developer.png"  border="false":::

### Monitor level 5 - Application

This layer covers the application code running in your containers, including its performance, failures, and availability.

Implement the [Azure Monitor OpenTelemetry Distro](../app/opentelemetry-enable.md) to enable [Application Insights experiences](../app/app-insights-overview.md#application-insights-experiences) and configure [sampling](../app/opentelemetry-sampling.md#sampling-in-azure-monitor-application-insights-with-opentelemetry) to control costs.

#### Application Insights experiences
- Check the [overview dashboard](../app/overview-dashboard.md) for at-a-glance assessment of application health and performance.
- View [live metrics](../app/live-stream.md) for real-time insight into application activity and performance.
- [Investigate failures, performance, and transactions](../app/failures-performance-transactions.md) to diagnose application health and efficiency.
- Use the [application map](../app/app-map.md) for a visual overview of application architecture and component interactions.
- Create [standard tests](../app/availability.md) to monitor application availability.

#### Application logs

- Container insights sends stdout/stderr logs to a Log Analytics workspace. See [Resource logs](/azure/aks/monitor-aks-reference#resource-logs) for a description of the different logs and [Kubernetes Services](/azure/azure-monitor/logs/manage-logs-tables) for a list of the tables each is sent to.

#### Service mesh

- For AKS clusters, deploy the [Istio-based service mesh add-on](/azure/aks/istio-about) which provides observability to your microservices architecture. [Istio](https://istio.io/) is an open-source service mesh that layers transparently onto existing distributed applications. The add-on assists in the deployment and management of Istio for AKS.

## See also

- See [Enable monitoring for Kubernetes clusters](kubernetes-monitoring-enable.md) to enable Managed Prometheus and log collection on your cluster.