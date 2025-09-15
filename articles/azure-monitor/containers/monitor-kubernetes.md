---
title: Monitor Kubernetes clusters using Azure Monitor and cloud native tools
description: Describes how to monitor the health and performance of the different layers of your Kubernetes environment using Azure Monitor and cloud native services in Azure.
ms.topic: article
ms.date: 04/25/2025
---

# Monitor Kubernetes clusters using Azure Monitor and cloud native tools

[Kubernetes monitoring in Azure Monitor](./kubernetes-monitoring-overview.md) describes the Azure Monitor services used to provide complete monitoring of your Kubernetes environment and the workloads that run on it. This article provides best practices for how to leverage these services to monitor the different layers of your Kubernetes environment based on the typical roles that manage them. 

Following is an illustration of a common model of a typical Kubernetes environment, starting from the infrastructure layer up through applications. Each layer has distinct monitoring requirements that are addressed by different services and typically managed by different roles in the organization.

:::image type="content" source="media/monitor-kubernetes/layers-with-roles.png" alt-text="Diagram of layers of Kubernetes environment with related administrative roles." lightbox="media/monitor-kubernetes/layers-with-roles.png"  border="false":::

Responsibility for the different layers of a Kubernetes environment and the applications that depend on it are typically addressed by multiple roles. Depending on the size of your organization, these roles may be performed by different people or even different teams. The following table describes the different roles while the sections below provide the monitoring scenarios that each will typically encounter.

| Roles | Description |
|:---|:---|
| [Developer](#developer) | Develop and maintaining the application running on the cluster. Responsible for application specific traffic including application performance and failures. Maintains reliability of the application according to SLAs. |
| [Platform engineer](#platform-engineer) | Responsible for the Kubernetes cluster. Provisions and maintains the platform used by developer. |
| [Network engineer](#network-engineer) | Responsible for traffic between workloads and any ingress/egress with the cluster. Analyzes network traffic and performs threat analysis. |

## Network engineer
The *Network Engineer* is responsible for traffic between workloads and any ingress/egress with the cluster. They analyze network traffic and perform threat analysis.

:::image type="content" source="media/monitor-kubernetes/layers-network-engineer.png" alt-text="Diagram of layers of Kubernetes environment for network engineer." lightbox="media/monitor-kubernetes/layers-network-engineer.png"  border="false":::

### Monitor level 1 - Network

Following are common scenarios for monitoring the network.

- Create [flow logs](/azure/network-watcher/network-watcher-nsg-flow-logging-overview) with [Network Watcher](/azure/network-watcher/network-watcher-monitoring-overview) to log information about the IP traffic flowing through network security groups used by your cluster and then use [traffic analytics](/azure/network-watcher/traffic-analytics) to analyze and provide insights on this data. Use the same Log Analytics workspace for traffic analytics that you use for your container logs and control plane logs.
- Using [traffic analytics](/azure/network-watcher/traffic-analytics), determine if any traffic is flowing either to or from any unexpected ports used by the cluster and also if any traffic is flowing over public IPs that shouldn't be exposed. Use this information to determine whether your network rules need modification.
- For AKS clusters, use the [Network Observability add-on for AKS (preview)](https://aka.ms/NetObsAddonDoc) to monitor and observe access between services in the cluster (east-west traffic).


## Platform engineer

The *platform engineer*, also known as the cluster administrator, is responsible for the Kubernetes cluster itself. They provision and maintain the platform used by developers. They need to understand the health of the cluster and its components, and be able to troubleshoot any detected issues. They also need to understand the cost to operate the cluster and potentially to be able to allocate costs to different teams.

:::image type="content" source="media/monitor-kubernetes/layers-platform-engineer.png" alt-text="Diagram of layers of Kubernetes environment for platform engineer." lightbox="media/monitor-kubernetes/layers-platform-engineer.png"  border="false":::

Large organizations may also have a *fleet architect*, which is similar to the platform engineer but is responsible for multiple clusters. They need visibility across the entire environment and must perform administrative tasks at scale. At scale recommendations are included in the guidance below. See [What is Azure Kubernetes Fleet Manager?](/azure/kubernetes-fleet/overview) for details on creating a Fleet resource for multi-cluster and at-scale scenarios.


### Configure monitoring for platform engineer

The sections below identify the steps for monitoring of your Kubernetes environment using the Azure services in [Container levels](./kubernetes-monitoring-overview.md#container-levels). Functionality and integration options are provided for each to help you determine where you may need to modify this configuration to meet your particular requirements. Onboarding Managed Prometheus and container logging can be part of the same experience as described in [Enable monitoring for Kubernetes clusters](../containers/kubernetes-monitoring-enable.md). The following sections described each separately so you can consider your all of your onboarding and configuration options for each.

#### Enable scraping of Prometheus metrics

> [!IMPORTANT]
>  To use Azure Monitor managed service for Prometheus, you need to have an [Azure Monitor workspace](../metrics/azure-monitor-workspace-overview.md). For information on design considerations for a workspace configuration, see [Azure Monitor workspace architecture](../metrics/azure-monitor-workspace-overview.md#azure-monitor-workspace-architecture).

Enable scraping of Prometheus metrics by Azure Monitor managed service for Prometheus from your cluster either when it's created or add this functionality to an existing cluster. See [Enable Prometheus metrics](./kubernetes-monitoring-enable.md#enable-prometheus-metrics-and-container-logging) for details.

If you already have a Prometheus environment that you want to use for your AKS clusters, then enable Azure Monitor managed service for Prometheus and then use remote-write to send data to your existing Prometheus environment. You can also [use remote-write to send data from your existing self-managed Prometheus environment to Azure Monitor managed service for Prometheus](./prometheus-remote-write.md). 

See [Default Prometheus metrics configuration in Azure Monitor](./prometheus-metrics-scrape-default.md) for details on the metrics that are collected by default and their frequency of collection. If you want to customize the configuration, see [Customize scraping of Prometheus metrics in Azure Monitor managed service for Prometheus](./prometheus-metrics-scrape-configuration.md).


#### Enable Grafana for analysis of Prometheus data

> [!NOTE]
> [Azure Monitor dashboards with Grafana](../visualize/visualize-grafana-overview.md) is currently in public preview and can replace Managed Grafana. This version of Grafana has no cost, requires no configuration, and presents dashboards in the Azure portal.Use Managed Grafana if you want to create dashboards that combine data from multiple data sources or if you want to integrate with an existing Grafana environment.

[Create an instance of Managed Grafana](/azure/managed-grafana/quickstart-managed-grafana-portal) and [link it to your Azure Monitor workspace](../metrics/azure-monitor-workspace-manage.md#link-a-grafana-workspace) so that you can use your Prometheus data as a data source. You can also manually perform this configuration using [add Azure Monitor managed service for Prometheus as data source](../metrics/prometheus-grafana.md). A variety of [prebuilt dashboards](../visualize/visualize-use-managed-grafana-how-to.md) are available for monitoring Kubernetes clusters including several that present similar information as Container insights views. 

If you have an existing Grafana environment, then you can continue to use it and add Azure Monitor managed service for [Prometheus as a data source](https://grafana.com/docs/grafana/latest/datasources/prometheus/). You can also [add the Azure Monitor data source to Grafana](https://grafana.com/docs/grafana/latest/datasources/azure-monitor/) to use data collected by Container insights in custom Grafana dashboards. Perform this configuration if you want to focus on Grafana dashboards rather than using the Container insights views and reports.

#### Enable collection of container logs

> [!IMPORTANT]
>  To use Azure Monitor managed service for Prometheus, you need to have a [Log Analytics workspace](../metrics/azure-monitor-workspace-overview.md). For information on design considerations for a workspace configuration, see [Azure Monitor workspace architecture](../metrics/azure-monitor-workspace-overview.md#azure-monitor-workspace-architecture).

When you enable collection of container logs for your Kubernetes cluster, Azure Monitor deploys a containerized version of the [Azure Monitor agent](../agents/azure-monitor-agent-overview.md) that sends stdout/stderr and infrastructure logs to a [Log Analytics workspace](../logs/log-analytics-workspace-overview.md) in Azure Monitor where they can be analyzed using [Kusto Query Language (KQL)](../logs/log-query-overview.md).

See [Enable monitoring for AKS clusters](./kubernetes-monitoring-enable.md#enable-prometheus-metrics-and-container-logging) for prerequisites and configuration options for onboarding your Kubernetes clusters. Onboard using Azure Policy to ensure that all clusters retain a consistent configuration. 

Once container logging is enabled for a cluster, perform the following actions to optimize your installation.

- If you only use logs for occasional troubleshooting, then consider configuring this table as [basic logs](../logs/logs-table-plans.md).
- Use cost presets described in [Enable cost optimization settings in Container insights](../containers/container-insights-cost-config.md#enable-cost-settings) to reduce your cost for Container insights data ingestion by reducing the amount of data that's collected. Disable collection of metrics by configuring Container insights to only collect **Logs and events** since many of the same metric values as [Prometheus](#enable-scraping-of-prometheus-metrics).

If you have an existing solution for collection of logs, then follow the guidance for that tool or enable log collection with Azure Monitor and use the [data export feature of Log Analytics workspace](../logs/logs-data-export.md) to send data to [Azure Event Hubs](/azure/event-hubs/event-hubs-about) to forward to alternate systems.


#### Collect control plane logs for AKS clusters

The logs for AKS control plane components are implemented in Azure as [resource logs](../platform/resource-logs.md). [Create a diagnostic setting](./kubernetes-monitoring-enable.md#enable-control-plane-logs) for each AKS cluster to send resource logs to a Log Analytics workspace. Use Azure Policy to ensure consistent configuration across multiple clusters.

There's a cost for sending resource logs to a workspace, so you should only collect those log categories that you intend to use. For a description of the categories that are available for AKS, see [Resource logs](/azure/aks/monitor-aks-reference#resource-logs).  Start by collecting a minimal number of categories and then modify the diagnostic setting to collect additional categories as your needs increase and as you understand your associated costs. You can send logs to an Azure storage account to reduce costs if you need to retain the information for compliance reasons. For details on the cost of ingesting and retaining log data, see [Azure Monitor Logs pricing details](../logs/cost-logs.md).

If you're unsure which resource logs to initially enable, use the following recommendations, which are based on the most common customer requirements. You can enable other categories later if you need to.

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

If you have an existing solution for collection of logs, either follow the guidance for that tool or enable log collection with Azure Monitor and use the [data export feature of Log Analytics workspace](../logs/logs-data-export.md) to send data to Azure event hub to forward to alternate system.

#### Collect Activity log for AKS clusters
Configuration changes to your AKS clusters are stored in the [Activity log](../platform/activity-log.md). [Create a diagnostic setting to send this data to your Log Analytics workspace](../platform/activity-log.md#export-activity-log) to analyze it with other monitoring data.  There's no cost for this data collection, and you can analyze or alert on the data using Log Analytics.


### Monitor level 2 - Cluster level components

The cluster level includes the following components:

| Component | Monitoring requirements |
|:---|:---|
| Node |  Understand the readiness status and performance of CPU, memory, disk and IP usage for each node and proactively monitor their usage trends before deploying any workloads. |

Following are common scenarios for monitoring the cluster level components.

**Azure portal**<br>
- Use the unified monitoring dashboard in the Azure portal to see the performance of the nodes in your cluster, including CPU and memory utilization.
- Use the **Nodes** view to see the health of each node and the health and performance of the pods running on them. For more information on analyzing node health and performance, see [Analyze Kubernetes cluster performance in the Azure portal.](./container-insights-analyze.md).
- Under **Reports**, use the **Node Monitoring** workbooks to analyze disk capacity, disk IO, and GPU usage. For more information about these workbooks, see [Node Monitoring workbooks](kubernetes-workbooks.md#node-monitoring-workbooks).
- Under **Monitoring**, select **Workbooks**, then **Subnet IP Usage** to see the IP allocation and assignment on each node for a selected time-range.

**Grafana dashboards**<br>
- Use the [prebuilt dashboard](../visualize/visualize-use-managed-grafana-how-to.md) in Managed Grafana for **Kubelet** to see the health and performance of each.
- Use Grafana dashboards with [Prometheus metric values](../containers/prometheus-metrics-scrape-default.md) related to disk such as `node_disk_io_time_seconds_total` and `windows_logical_disk_free_bytes` to monitor attached storage.
- Multiple [Kubernetes dashboards](https://grafana.com/grafana/dashboards/?search=kubernetes) are available that visualize the performance and health of your nodes based on data stored in Prometheus.

**Log Analytics**
- Select the [Containers category](../logs/queries.md?tabs=groupby#find-and-filter-queries) in the [queries dialog](../logs/queries.md#queries-dialog) for your Log Analytics workspace to access prebuilt log queries for your cluster, including the **Image inventory** log query that retrieves data from the [ContainerImageInventory](/azure/azure-monitor/reference/tables/containerimageinventory) table populated by Container insights.

**Troubleshooting**<br>
- For troubleshooting scenarios, you may need to access nodes directly for maintenance or immediate log collection. For security purposes, AKS nodes aren't exposed to the internet but you can use the `kubectl debug` command to SSH to the AKS nodes. For more information on this process, see [Connect with SSH to Azure Kubernetes Service (AKS) cluster nodes for maintenance or troubleshooting](/azure/aks/ssh).

**Cost analysis**<br>
-  Configure [OpenCost](https://www.opencost.io), which is an open-source, vendor-neutral CNCF sandbox project for understanding your Kubernetes costs, to support your analysis of your cluster costs. It exports detailed costing data to Azure storage.
- Use data from OpenCost to breakdown relative usage of the cluster by different teams in your organization so that you can allocate the cost between each.
- Use data from OpenCost to ensure that the cluster is using the full capacity of its nodes by densely packing workloads, using fewer large nodes as opposed to many smaller nodes. 


### Monitor level 3 - Managed Kubernetes components

The managed Kubernetes level includes the following components:

| Component | Monitoring |
|:---|:---|
| API Server | Monitor the status of API server and identify any increase in request load and bottlenecks if the service is down. |
| Kubelet | Monitor Kubelet to help troubleshoot pod management issues, pods not starting, nodes not ready, or pods getting killed.  |

Following are common scenarios for monitoring your managed Kubernetes components.

**Azure portal**<br>
- Use [metrics explorer](../metrics/metrics-explorer.md) to view the **Inflight Requests** counter for the cluster.
- Use the [Kubelet workbook](./kubernetes-workbooks.md#resource-monitoring-workbooks) to see the health and performance of each kubelet.

**Grafana**<br>
- Use the [prebuilt dashboard](../visualize/visualize-use-managed-grafana-how-to.md) in Managed Grafana for **Kubelet** to see the health and performance of each kubelet.
- Use a dashboard such as [Kubernetes apiserver](https://grafana.com/grafana/dashboards/12006) for a complete view of the API server performance. This includes such values as request latency and workqueue processing time.

**Log Analytics**<br>
- Use [log queries with resource logs](/azure/aks/monitor-aks#sample-log-queries) to analyze [control plane logs](#collect-control-plane-logs-for-aks-clusters) generated by AKS components.
- Any configuration activities for AKS are logged in the Activity log. When you [send the Activity log to a Log Analytics workspace](#collect-activity-log-for-aks-clusters) you can analyze it with Log Analytics. For example, the following sample query can be used to return records identifying a successful upgrade across all your AKS clusters. 

    ``` kql
    AzureActivity
    | where CategoryValue == "Administrative"
    | where OperationNameValue == "MICROSOFT.CONTAINERSERVICE/MANAGEDCLUSTERS/WRITE"
    | extend properties=parse_json(Properties_d) 
    | where properties.message == "Upgrade Succeeded"
    | order by TimeGenerated desc
    ```


**Troubleshooting**<br>
- For troubleshooting scenarios, you can access kubelet logs using the process described at [Get kubelet logs from Azure Kubernetes Service (AKS) cluster nodes](/azure/aks/kubelet-logs).

### Monitor level 4 - Kubernetes objects and workloads

The Kubernetes objects and workloads level includes the following components:

| Component | Monitoring requirements |
|:---|:---|
| Deployments | Monitor actual vs desired state of the deployment and the status and resource utilization of the pods running on them.  |
| Pods | Monitor status and resource utilization, including CPU and memory, of the pods running on your AKS cluster. |
| Containers | Monitor resource utilization, including CPU and memory, of the containers running on your AKS cluster. |

Following are common scenarios for monitoring your Kubernetes objects and workloads.


**Azure portal**<br>
- Use the **Nodes** and **Controllers** views to see the health and performance of the pods running on them and drill down to the health and performance of their containers.
- Use the **Containers** view to see the health and performance for the containers. For more information on analyzing container health and performance, see [Analyze Kubernetes cluster data with Container insights](./container-insights-analyze.md).
- Use the [Deployments workbook](./kubernetes-workbooks.md#resource-monitoring-workbooks) to see deployment metrics. For more information, see [Deployment & HPA metrics with Container Insights](container-insights-deployment-hpa-metrics.md).


**Grafana dashboards**<br>
- Use the [prebuilt dashboards](../visualize/visualize-use-managed-grafana-how-to.md) in Managed Grafana for **Nodes** and **Pods** to view their health and performance.
- Multiple [Kubernetes dashboards](https://grafana.com/grafana/dashboards/?search=kubernetes) are available that visualize the performance and health of your nodes based on data stored in Prometheus.


**Live data**
- In troubleshooting scenarios, Container Insights provides access to live AKS container logs (stdout/stderror), events and pod metrics. For more information about this feature, see [How to view Kubernetes logs, events, and pod metrics in real-time](container-insights-livedata-overview.md).

### Alerts for the platform engineer

[Alerts in Azure Monitor](..//alerts/alerts-overview.md) proactively notify you of interesting data and patterns in your monitoring data. They allow you to identify and address issues in your system before your customers notice them. If you have an existing [ITSM solution](../alerts/itsmc-overview.md) for alerting, you can [integrate it with Azure Monitor](../alerts/itsmc-overview.md). You can also [export workspace data](../logs/logs-data-export.md) to send data from your Log Analytics workspace to another location that supports your current alerting solution.

#### Alert types
The following table describes the different types of custom alert rules that you can create based on the data collected by the services described above.

| Alert type | Description |
|:---|:---|
| Prometheus alerts | [Prometheus alerts](../alerts/prometheus-alerts.md) are written in Prometheus Query Language (Prom QL) and applied on Prometheus metrics stored in [Azure Monitor managed services for Prometheus](../metrics/prometheus-metrics-overview.md). Recommended alerts already include the most common Prometheus alerts, and you can [create addition alert rules](../metrics/prometheus-rule-groups.md) as required. |
| Metric alert rules | Metric alert rules use the same metric values as the Metrics explorer. In fact, you can create an alert rule directly from the metrics explorer with the data you're currently analyzing. Metric alert rules can be useful to alert on AKS performance using any of the values in [AKS data reference metrics](/azure/aks/monitor-aks-reference#metrics). |
| Log search alert rules | Use log search alert rules to generate an alert from the results of a log query. For more information, see [How to create log search alerts from Container Insights](./container-insights-log-alerts.md) and [How to query logs from Container Insights](./container-insights-log-query.md). |

#### Recommended alerts
Start with a set of recommended Prometheus alerts from [Metric alert rules in Container insights (preview)](container-insights-metric-alerts.md#prometheus-alert-rules) which include the most common alerting conditions for a Kubernetes cluster. You can add more alert rules later as you identify additional alerting conditions.

## Developer

In addition to developing the application, the *developer* maintains the application running on the cluster. They're responsible for application specific traffic including application performance and failures and maintain reliability of the application according to company-defined SLAs.

:::image type="content" source="media/monitor-kubernetes/layers-developer.png" alt-text="Diagram of layers of Kubernetes environment for developer." lightbox="media/monitor-kubernetes/layers-developer.png"  border="false":::

### Azure services for developer

The following table lists the services that are commonly used by the developer to monitor the health and performance of the application running on the cluster.  

See [Data Collection Basics of Azure Monitor Application Insights](../app/opentelemetry-overview.md) for options on configuring data collection from the application running on your cluster and decision criteria on the best method for your particular requirements. 

### Monitor level 5 - Application

Following are common scenarios for monitoring your application.

**Application performance**<br>
- Use the **Performance** view in Application insights to view the performance of different operations in your application.
- Use the [.NET Profiler](../profiler/profiler-overview.md) to capture and view performance traces for your application.
- Use the [Application Map](../app/app-map.md) to view the dependencies between your application components and identify any bottlenecks.
- Enable [distributed tracing](../app/distributed-trace-data.md), which provides a performance profiler that works like call stacks for cloud and microservices architectures, to gain better observability into the interaction between services.

**Application failures**<br>
- Use the **Failures** tab of Application insights to view the number of failed requests and the most common exceptions.
- Ensure that alerts for [failure anomalies](../alerts/proactive-failure-diagnostics.md) identified with [smart detection](../alerts/proactive-diagnostics.md) are configured properly.

**Health monitoring**<br>
- Create an [Availability test](../app/availability-overview.md) in Application insights to create a recurring test to monitor the availability and responsiveness of your application.
- Use the [SLA report](../app/sla-report.md) to calculate and report SLA for web tests.
- Use [annotations](../app/release-and-work-item-insights.md?tabs=release-annotations) to identify when a new build is deployed so that you can visually inspect any change in performance after the update.

**Application logs**<br>
- Container insights sends stdout/stderr logs to a Log Analytics workspace. See [Resource logs](/azure/aks/monitor-aks-reference#resource-logs) for a description of the different logs and [Kubernetes Services](/azure/azure-monitor/logs/manage-logs-tables) for a list of the tables each is sent to.

**Service mesh**

- For AKS clusters, deploy the [Istio-based service mesh add-on](/azure/aks/istio-about) which provides observability to your microservices architecture. [Istio](https://istio.io/) is an open-source service mesh that layers transparently onto existing distributed applications. The add-on assists in the deployment and management of Istio for AKS.

## See also

- See [Monitoring AKS](/azure/aks/monitor-aks) for guidance on monitoring specific to Azure Kubernetes Service (AKS).


