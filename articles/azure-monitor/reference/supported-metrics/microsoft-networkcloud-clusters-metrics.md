---
title: Supported metrics - Microsoft.NetworkCloud/clusters
description: Reference for Microsoft.NetworkCloud/clusters metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 07/13/2026
ms.custom: Microsoft.NetworkCloud/clusters, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.NetworkCloud/clusters

The following table lists the metrics available for the Microsoft.NetworkCloud/clusters resource type.

**Table headings**

- **Metric** - The metric display name as it appears in the Azure portal.
- **Name in Rest API** - Metric name as referred to in the [REST API](/azure/azure-monitor/essentials/rest-api-walkthrough).
- **Advanced platform metrics** - A premium, [paid tier of platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform) in Azure Monitor that provide more granular observability for Azure resources.
- **Unit** - Unit of measure.
- **Aggregation** - The default [aggregation](/azure/azure-monitor/essentials/metrics-aggregation-explained) type. Valid values: Average, Minimum, Maximum, Total, Count.
- **Dimensions** - [Dimensions](/azure/azure-monitor/essentials/metrics-aggregation-explained#dimensions-splitting-and-filtering) available for the metric.
- **Time Grains** - [Intervals at which the metric is sampled](/azure/azure-monitor/essentials/metrics-aggregation-explained#granularity). For example, `PT1M` indicates that the metric is sampled every minute, `PT30M` every 30 minutes, `PT1H` every hour, and so on.
- **DS Export** -S Whether the metric is exportable to Azure Monitor Logs via Diagnostic Settings.

For information on exporting metrics, see - [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics) and [Create diagnostic settings in Azure Monitor](/azure/azure-monitor/essentials/create-diagnostic-settings?tabs=portal).

For information on metric retention, see [Azure Monitor Metrics overview](/azure/azure-monitor/essentials/data-platform-metrics#retention-of-metrics).


For a list of supported logs, see [Supported log categories - Microsoft.NetworkCloud/clusters](../supported-logs/microsoft-networkcloud-clusters-logs.md)


### Category: API Server
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**APIServer Audit Requests Rejected Total**<br><br>Counter of API server requests rejected due to an error in the audit logging backend. |`ApiserverAuditRequestsRejectedTotal` | No | Count |Average |`Component`, `Pod Name`|PT1M |No|
|**APIServer Clnt Cert Exp Sec Sum (Preview)**<br><br>Sum of API server client certificate expiration. |`ApiserverClientCertificateExpirationSecondsSum` | No | Seconds |Average |`Component`, `Pod Name`|PT1M |No|
|**APIServer Storage Data Key Gen Fail**<br><br>Total number of operations that failed Data Encryption Key (DEK) generation. |`ApiserverStorageDataKeyGenerationFailuresTotal` | No | Count |Average |`Component`, `Pod Name`|PT1M |No|
|**APIServer TLS Handshake Err (Preview)**<br><br>Number of requests dropped with 'TLS handshake' error. |`ApiserverTlsHandshakeErrorsTotal` | No | Count |Average |`Component`, `Pod Name`|PT1M |No|

### Category: Availability
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Memory Used (Preview)**<br><br>The used memory of the node. |`Cluster Node Memory Used` | No | Bytes |Minimum, Maximum, Average, Total (Sum) |`ClusterName`, `ClusterNodeName`|PT1M |No|
|**Memory Available (Preview)**<br><br>The available memory of the node. |`Memory Available Bytes` | No | Bytes |Minimum, Maximum, Average, Total (Sum) |`ClusterName`, `ClusterNodeName`|PT1M |No|
|**Memory Total (Preview)**<br><br>The total physical memory of the node. |`Memory Total Bytes` | No | Bytes |Minimum, Maximum, Average, Total (Sum) |`ClusterName`, `ClusterNodeName`|PT1M |No|
|**VM Memory Used (Preview)**<br><br>Amount of virtual machine memory that is in use. |`VmMemoryUsed` | No | Bytes |Minimum, Maximum, Average |`ClusterName`, `ClusterNodeName`, `Instance`|PT1M |No|

### Category: Calico
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Felix Active Local Endpoints**<br><br>Number of active endpoints on this host. |`FelixActiveLocalEndpoints` | No | Count |Average |`Host`|PT1M |No|
|**Felix Cluster Num Host Endpoints**<br><br>Total number of host endpoints cluster-wide. |`FelixClusterNumHostEndpoints` | No | Count |Average |`Host`|PT1M |No|
|**Felix Cluster Number of Hosts**<br><br>Total number of Calico hosts in the cluster. |`FelixClusterNumHosts` | No | Count |Average |`Host`|PT1M |No|
|**Felix Cluster Nmbr Workload Endpoints**<br><br>Total number of workload endpoints cluster-wide. |`FelixClusterNumWorkloadEndpoints` | No | Count |Average |`Host`|PT1M |No|
|**Felix Interface Dataplane Failures**<br><br>Number of times dataplane updates failed and will be retried. |`FelixIntDataplaneFailures` | No | Count |Average |`Host`|PT1M |No|
|**Felix Ipset Errors**<br><br>Number of 'ipset' command failures. |`FelixIpsetErrors` | No | Count |Average |`Host`|PT1M |No|
|**Felix Ipsets Calico**<br><br>Number of active Calico IP sets. |`FelixIpsetsCalico` | No | Count |Average |`Host`|PT1M |No|
|**Felix IP Tables Restore Errors**<br><br>Number of 'iptables-restore' errors. |`FelixIptablesRestoreErrors` | No | Count |Average |`Host`|PT1M |No|
|**Felix IP Tables Save Errors**<br><br>Number of 'iptables-save' errors. |`FelixIptablesSaveErrors` | No | Count |Average |`Host`|PT1M |No|
|**Felix Resyncs Started**<br><br>Number of times Felix has started resyncing with the datastore. |`FelixResyncsStarted` | No | Count |Average |`Host`|PT1M |No|
|**Felix Resync State**<br><br>Current datastore state. |`FelixResyncState` | No | Unspecified |Average |`Host`|PT1M |No|
|**Typha Client Latency Secs**<br><br>Per-client latency: how far behind the current state each client is. |`TyphaClientLatencySecsCount` | No | Count |Average |`Pod Name`|PT1M |No|
|**Typha Connections Accepted**<br><br>Total number of connections accepted over time. |`TyphaConnectionsAccepted` | No | Count |Average |`Pod Name`|PT1M |No|
|**Typha Connections Dropped**<br><br>Total number of connections dropped due to rebalancing. |`TyphaConnectionsDropped` | No | Count |Average |`Pod Name`|PT1M |No|
|**Typha Ping Latency**<br><br>Round-trip ping latency to client. Typha's protocol includes a regular ping keepalive to verify that the connection is still up. |`TyphaPingLatencyCount` | No | Count |Average |`Pod Name`|PT1M |No|

### Category: Container
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Container FS I/O Time Seconds Total (Preview)**<br><br>Time taken for container Input/Output (I/O) operations. |`ContainerFsIoTimeSecondsTotal` | No | Seconds |Average |`Device`, `Host`|PT1M |No|
|**Container Memory Fail Count**<br><br>Number of times a container's memory usage limit is hit. In the absence of data, this metric will default to 0. |`ContainerMemoryFailcnt` | No | Count |Average |`Container`, `Host`, `Namespace`, `Pod`|PT1M |No|
|**Container Memory Usage Bytes**<br><br>Current memory usage, including all memory regardless of when it was accessed. In the absence of data, this metric will default to 0. |`ContainerMemoryUsageBytes` | No | Bytes |Average |`Container`, `Host`, `Namespace`, `Pod`|PT1M |No|
|**Container Scrape Error**<br><br>Indicates whether there was an error while getting container metrics. |`ContainerScrapeError` | No | Unspecified |Average |`Host`|PT1M |No|
|**Container Tasks State (Deprecated)**<br><br>Number of tasks or processes in a given state (sleeping, running, stopped, uninterruptible, or waiting) in a container. |`ContainerTasksState` | No | Count |Average |`Container`, `Host`, `Namespace`, `Pod`, `State`|PT1M |No|

### Category: Controller
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Controller Reconcile Errors Total**<br><br>Total number of reconciliation errors per controller. |`ControllerRuntimeReconcileErrorsTotal2` | No | Count |Average |`Controller`, `Namespace`, `Pod Name`|PT1M |No|
|**Controller Reconciliations Total**<br><br>Total number of reconciliations per controller. |`ControllerRuntimeReconcileTotal2` | No | Count |Average |`Controller`, `Namespace`, `Pod Name`|PT1M |No|

### Category: CoreDNS
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**CoreDNS Requests Total**<br><br>Total number of DNS requests recieved by a CoreDNS server. |`CorednsDnsRequestsTotal` | No | Count |Average |`Family`, `Pod Name`, `Proto`, `Server`, `Type`|PT1M |No|
|**CoreDNS Responses Total**<br><br>Total number of DNS responses sent by a CoreDNS server. |`CorednsDnsResponsesTotal` | No | Count |Average |`Pod Name`, `Server`, `Rcode`|PT1M |No|
|**CoreDNS Frwd Hlthchk Broken**<br><br>Total number of times the health checks for all upstream DNS servers has failed. |`CorednsForwardHealthcheckBrokenTotal2` | No | Count |Average |`Pod Name`, `Namespace`|PT1M |No|
|**CoreDNS Frwd Max Concurrent Rejects**<br><br>Total number of rejected queries due to concurrent queries reaching the maximum limit. |`CorednsForwardMaxConcurrentRejectsTotal2` | No | Count |Average |`Pod Name`, `Namespace`|PT1M |No|
|**CoreDNS Health Request Failures Total**<br><br>The number of times the self health check failed for a CoreDNS server. |`CorednsHealthRequestFailuresTotal` | No | Count |Average |`Pod Name`|PT1M |No|
|**CoreDNS Panics Total**<br><br>Total number of unexpected errors (panics) that have occurred in a CoreDNS server. |`CorednsPanicsTotal` | No | Count |Average |`Pod Name`|PT1M |No|
|**CoreDNS Reload Failed Total**<br><br>Total number of failed attempts CoreDNS has had when reloading its configuration. |`CorednsReloadFailedTotal2` | No | Count |Average |`Pod Name`, `Namespace`|PT1M |No|

### Category: Daemonset
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Daemonsets Current Number Scheduled**<br><br>Number of daemonsets currently scheduled. In the absence of data, this metric will default to 0. |`KubeDaemonsetStatusCurrentNumberScheduled` | No | Count |Average |`Daemonset`, `Namespace`|PT1M |No|
|**Daemonsets Desired Number Scheduled**<br><br>Number of daemonsets desired scheduled. In the absence of data, this metric will default to 0. |`KubeDaemonsetStatusDesiredNumberScheduled` | No | Count |Average |`Daemonset`, `Namespace`|PT1M |No|
|**Daemonsets Not Scheduled**<br><br>Number of daemonsets not scheduled. In the absence of data, this metric will default to 150. |`KubeDaemonsetStatusNotScheduled` | No | Count |Average |`Daemonset`, `Namespace`|PT1M |No|

### Category: Deployment
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Deployment Replicas Available**<br><br>Number of deployment replicas available. In the absence of data, this metric will default to 0. |`KubeDeploymentStatusReplicasAvailable` | No | Count |Average |`Deployment`, `Namespace`|PT1M |No|
|**Deployment Replicas Available Percent**<br><br>Percentage of deployment replicas available. In the absence of data, this metric will default to 0. |`KubeDeploymentStatusReplicasAvailablePercent` | No | Percent |Average |`Deployment`, `Namespace`|PT1M |No|
|**Deployment Replicas Ready**<br><br>Number of deployment replicas ready. |`KubeDeploymentStatusReplicasReady` | No | Count |Average |`Deployment`, `Namespace`|PT1M |No|
|**Deployment Replicas Unavailable**<br><br>Number of deployment replicas unavailable. |`KubeDeploymentStatusReplicasUnavailable` | No | Count |Average |`Deployment`, `Namespace`|PT1M |No|

### Category: Etcd
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Etcd Database Utilization Percentage**<br><br>The percentage of the Etcd Database utilized. In the absence of data, this metric will default to 0. |`EtcdDBUtilizationPercent` | No | Percent |Average |`Pod Name`|PT1M |No|
|**Etcd Disk Backend Commit Duration Sec**<br><br>The cumulative sum of the time taken for etcd to commit transactions to its backend disk storage. |`EtcdDiskBackendCommitDurationSecondsSum` | No | Seconds |Total (Sum) |`Component`, `Pod Name`, `Tier`|PT1M |No|
|**Etcd Disk WAL Fsync Duration Sec**<br><br>The cumulative sum of of the time that etcd has spent performing fsync operations on the write-ahead log (WAL) file. |`EtcdDiskWalFsyncDurationSecondsSum` | No | Seconds |Total (Sum) |`Component`, `Pod Name`, `Tier`|PT1M |No|
|**Etcd Server Health Failures**<br><br>Total number of failed health checks performed on an etcd server. In the absence of data, this metric will default to 0. |`EtcdServerHealthFailures` | No | Count |Average |`Pod Name`|PT1M |No|
|**Etcd Server Is Leader**<br><br>Indicates whether an etcd server the leader of the cluster; 1 if is, 0 otherwise. |`EtcdServerIsLeader` | No | Unspecified |Count |`Component`, `Pod Name`, `Tier`|PT1M |No|
|**Etcd Server Is Learner**<br><br>Indicates whether an etcd server a learner within the cluster; 1 if is, 0 otherwise. |`EtcdServerIsLearner` | No | Unspecified |Count |`Component`, `Pod Name`, `Tier`|PT1M |No|
|**Etcd Server Leader Changes Seen Total**<br><br>The number of leader changes seen within the etcd cluster. |`EtcdServerLeaderChangesSeenTotal` | No | Count |Average |`Component`, `Pod Name`, `Tier`|PT1M |No|
|**Etcd Server Proposals Applied Total**<br><br>The total number of consensus proposals that have been successfully applied. |`EtcdServerProposalsAppliedTotal` | No | Count |Average |`Component`, `Pod Name`, `Tier`|PT1M |No|
|**Etcd Server Proposals Committed Total**<br><br>The total number of consensus proposals that have been committed. |`EtcdServerProposalsCommittedTotal` | No | Count |Average |`Component`, `Pod Name`, `Tier`|PT1M |No|
|**Etcd Server Proposals Failed Total**<br><br>The total number of failed consensus proposals. |`EtcdServerProposalsFailedTotal` | No | Count |Average |`Component`, `Pod Name`, `Tier`|PT1M |No|
|**Etcd Server Slow Apply Total (Preview)**<br><br>The total number of etcd apply requests that took longer than expected. |`EtcdServerSlowApplyTotal` | No | Count |Average |`Pod Name`, `Tier`|PT1M |No|

### Category: Job
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Jobs Active**<br><br>Number of jobs active. In the absence of data, this metric will default to 0. |`KubeJobStatusActive` | No | Count |Average |`Job`, `Namespace`|PT1M |No|
|**Jobs Failed**<br><br>Number and reason of jobs failed. |`KubeJobStatusFailedReasons` | No | Count |Average |`Job`, `Namespace`, `Reason`|PT1M |No|
|**Jobs Succeeded**<br><br>Number of jobs succeeded. In the absence of data, this metric will default to 0. |`KubeJobStatusSucceeded` | No | Count |Average |`Job`, `Namespace`|PT1M |No|

### Category: Kubelet
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Kubelet Running Containers**<br><br>Number of containers currently running. |`KubeletRunningContainers` | No | Count |Average |`Container State`, `Host`|PT1M |No|
|**Kubelet Running Pods**<br><br>Number of pods running on the node. |`KubeletRunningPods` | No | Count |Average |`Host`|PT1M |No|
|**Kubelet Runtime Operations Errors Total**<br><br>Cumulative number of runtime operation errors by operation type. |`KubeletRuntimeOperationsErrorsTotal` | No | Count |Average |`Host`, `Operation Type`|PT1M |No|
|**Kubelet Started Pods Errors Total**<br><br>Cumulative number of errors when starting pods. |`KubeletStartedPodsErrorsTotal` | No | Count |Average |`Host`|PT1M |No|

### Category: Network Cloud
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**CPU Pinning Map (Preview)**<br><br>Pinning map of virtual CPUs (vCPUs) to CPUs. |`NcVmiCpuAffinity` | No | Count |Average |`CPU`, `NUMA Node`, `VMI Name`, `VMI Namespace`, `VMI Node`, `VMI State`|PT1M |No|

### Category: Nexus Cluster
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Cluster Heartbeat Connection Status (Deprecated)**<br><br>Indicates whether the Cluster is having issues communicating with the Cluster Manager. The value of the metric is 0 when the connection is healthy and 1 when it is unhealthy. |`NexusClusterHeartbeatConnectionStatus` | No | Count |Average |`Reason`|PT1M |No|
|**Cluster Machine Group Upgrade**<br><br>Tracks Cluster Machine Group Upgrades performed. The value of the metric is 0 when the result is successful and 1 for all other results. |`NexusClusterMachineGroupUpgrade` | No | Count |Average |`Machine Group`, `Result`, `Upgraded From Version`, `Upgraded To Version`|PT1M |No|

### Category: Node
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Node Resources Allocatable**<br><br>Node resources allocatable for pods. |`KubeNodeStatusAllocatable` | No | Count |Average |`Node`, `Resource`, `Unit`|PT1M |No|
|**Node Resources Capacity**<br><br>Total amount of node resources available. |`KubeNodeStatusCapacity` | No | Count |Average |`Node`, `Resource`, `Unit`|PT1M |No|
|**Node Status Condition**<br><br>The condition of a node. |`KubeNodeStatusCondition` | No | Count |Average |`Condition`, `Node`, `Status`|PT1M |No|

### Category: Pod
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Container Resources Limits**<br><br>The container's resources limits. In the absence of data, this metric will default to 0. |`KubePodContainerResourceLimits` | No | Count |Average |`Container`, `Namespace`, `Node`, `Pod`, `Resource`, `Unit`|PT1M |No|
|**Container Resources Requests**<br><br>The container's resources requested. In the absence of data, this metric will default to 0. |`KubePodContainerResourceRequests` | No | Count |Average |`Container`, `Namespace`, `Node`, `Pod`, `Resource`, `Unit`|PT1M |No|
|**Container State Started (Preview)**<br><br>Unix timestamp start time of a container. In the absence of data, this metric will default to 0. |`KubePodContainerStateStarted` | No | Count |Average |`Container`, `Namespace`, `Pod`|PT1M |No|
|**Container Status Last Terminated Reason**<br><br>The reason of a container's last terminated status. In the absence of data, this metric will default to 0. |`KubePodContainerStatusLastTerminatedReason` | No | Count |Average |`Container`, `Namespace`, `Pod`, `Reason`|PT1M |No|
|**Container Status Ready**<br><br>Describes whether the container's readiness check succeeded. In the absence of data, this metric will default to 0. |`KubePodContainerStatusReady` | No | Count |Average |`Container`, `Namespace`, `Pod`|PT1M |No|
|**Container Restarts**<br><br>The number of container restarts. |`KubePodContainerStatusRestartsTotal` | No | Count |Average |`Container`, `Namespace`, `Pod`|PT1M |No|
|**Container Status Running**<br><br>The number of containers with a status of 'running'. In the absence of data, this metric will default to 0. |`KubePodContainerStatusRunning` | No | Count |Average |`Container`, `Namespace`, `Pod`|PT1M |No|
|**Container Status Terminated**<br><br>The number of containers with a status of 'terminated'. In the absence of data, this metric will default to 0. |`KubePodContainerStatusTerminated` | No | Count |Average |`Container`, `Namespace`, `Pod`|PT1M |No|
|**Container Status Terminated Reason**<br><br>The number and reason of containers with a status of 'terminated'. |`KubePodContainerStatusTerminatedReasons` | No | Count |Average |`Container`, `Namespace`, `Pod`, `Reason`|PT1M |No|
|**Container Status Waiting**<br><br>The number of containers with a status of 'waiting'. In the absence of data, this metric will default to 0. |`KubePodContainerStatusWaiting` | No | Count |Average |`Container`, `Namespace`, `Pod`|PT1M |No|
|**Container Status Waiting Reason**<br><br>The number and reason of containers with a status of 'waiting'. In the absence of data, this metric will default to 0. |`KubePodContainerStatusWaitingReason` | No | Count |Average |`Container`, `Namespace`, `Pod`, `Reason`|PT1M |No|
|**Pod Deletion Timestamp (Preview)**<br><br>The timestamp of the pod's deletion. In the absence of data, this metric will default to 0. |`KubePodDeletionTimestamp` | No | Count |Average |`Namespace`, `Pod`|PT1M |No|
|**Pod Init Container Ready**<br><br>The number of ready pod init containers. In the absence of data, this metric will default to 0. |`KubePodInitContainerStatusReady` | No | Count |Average |`Namespace`, `Container`, `Pod`|PT1M |No|
|**Pod Init Container Restarts**<br><br>The number of pod init containers restarts. |`KubePodInitContainerStatusRestartsTotal` | No | Count |Average |`Namespace`, `Container`, `Pod`|PT1M |No|
|**Pod Init Container Running**<br><br>The number of running pod init containers. In the absence of data, this metric will default to 0. |`KubePodInitContainerStatusRunning` | No | Count |Average |`Namespace`, `Container`, `Pod`|PT1M |No|
|**Pod Init Container Terminated**<br><br>The number of terminated pod init containers. In the absence of data, this metric will default to 0. |`KubePodInitContainerStatusTerminated` | No | Count |Average |`Namespace`, `Container`, `Pod`|PT1M |No|
|**Pod Init Container Terminated Reason**<br><br>The number of pod init containers with terminated reason. In the absence of data, this metric will default to 0. |`KubePodInitContainerStatusTerminatedReason` | No | Count |Average |`Namespace`, `Container`, `Pod`, `Reason`|PT1M |No|
|**Pod Init Container Waiting**<br><br>The number of pod init containers waiting. In the absence of data, this metric will default to 0. |`KubePodInitContainerStatusWaiting` | No | Count |Average |`Namespace`, `Container`, `Pod`|PT1M |No|
|**Pod Init Container Waiting Reason**<br><br>The reason the pod init container is waiting. In the absence of data, this metric will default to 0. |`KubePodInitContainerStatusWaitingReason` | No | Count |Average |`Namespace`, `Container`, `Pod`, `Reason`|PT1M |No|
|**Pod Status Phase**<br><br>The pod status phase. In the absence of data, this metric will default to 0. |`KubePodStatusPhases` | No | Count |Average |`Namespace`, `Pod`, `Phase`|PT1M |No|
|**Pod Ready State**<br><br>Signifies if the pod is in ready state. In the absence of data, this metric will default to 0. |`KubePodStatusReady` | No | Count |Average |`Namespace`, `Pod`, `Condition`|PT1M |No|
|**Pod Status Reason**<br><br>NodeAffinity |`KubePodStatusReason` | No | Count |Average |`Namespace`, `Pod`, `Reason`|PT1M |No|

### Category: Saturation
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Percentage CPU (Preview)**<br><br>The percentage of processor time that is not idle. |`Cluster Node CPU Utilization` | No | Percent |Minimum, Maximum, Average, Count |`ClusterName`, `ClusterNodeName`|PT1M |No|
|**Percentage Memory (Preview)**<br><br>The memory usage of the node, including unused allocated memory. |`Cluster Node Memory Usage` | No | Percent |Minimum, Maximum, Average, Total (Sum) |`ClusterName`, `ClusterNodeName`|PT1M |No|
|**VM Memory Available (Preview)**<br><br>Amount of virtual machine memory that is available. |`VmMemoryAvailable` | No | Bytes |Minimum, Maximum, Total (Sum), Count, Average |`ClusterName`, `ClusterNodeName`, `Instance`|PT1M |No|
|**VM Memory Used Percentage (Preview)**<br><br>Percentage of virtual machine memory that is in use. |`VmMemoryUsedPercentage` | No | Percent |Minimum, Maximum, Average |`ClusterName`, `ClusterNodeName`, `Instance`|PT1M |No|
|**VM Percentage CPU (Preview)**<br><br>Virtual machine CPU utilization. |`VmPercentageCPU` | No | Percent |Minimum, Maximum, Total (Sum), Count, Average |`ClusterName`, `ClusterNodeName`, `Instance`|PT1M |No|

### Category: Statefulset
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Statefulset Desired Replicas Number**<br><br>The desired number of statefulset replicas. |`KubeStatefulsetReplicas` | No | Count |Average |`Namespace`, `Statefulset`|PT1M |No|
|**Statefulset Replicas Difference**<br><br>The difference between desired and current number of replicas per statefulset. In the absence of data, this metric will default to 0. |`KubeStatefulsetStatusReplicaDifference` | No | Count |Average |`Namespace`, `Statefulset`|PT1M |No|
|**Statefulset Replicas Number**<br><br>The number of replicas per statefulset. In the absence of data, this metric will default to 0. |`KubeStatefulsetStatusReplicas` | No | Count |Average |`Namespace`, `Statefulset`|PT1M |No|

### Category: Storage
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**NFS Volume Size Bytes**<br><br>Total Size of the NFS volume. |`NfsVolumeSizeBytes` | No | Bytes |Average |`CSN Name`|PT1M |No|
|**NFS Volume Used Bytes**<br><br>Size of NFS volume used. |`NfsVolumeUsedBytes` | No | Bytes |Average |`CSN Name`|PT1M |No|
|**NFS Volume Used Percent**<br><br>Percent of NFS volume used. |`NfsVolumeUsedPercent` | No | Percent |Average |`CSN Name`|PT1M |No|
|**Storage control-plane connectivity (Preview)**<br><br>Cluster's connectivity status to the storage appliance. In the absence of data, this metric will default to 0. |`StorageControlPlaneConnectivity` | No | Count |Average |`Appliance Name`, `Node`, `Endpoint`, `State`|PT1M |No|

### Category: Telegraf
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Telegraf Internal Agent Gather Errors**<br><br>This metric tracks the number of errors that occur during the gather phase of the Telegraf agent's operation. These errors can happen for various reasons, such as issues with input plugins or problems accessing data sources. |`TelegrafInternalAgentGatherErrors` | No | Count |Average |`Host`|PT1M |No|
|**Telegraf Internal Agent Gather Timeouts**<br><br>The number of Telegraf internal agent gather timeouts. Timeouts can happen if the data sources are slow to respond or if there are network issues. |`TelegrafInternalAgentGatherTimeouts` | No | Count |Average |`Host`|PT1M |No|
|**Telegraf Internal Agent Metrics Dropped**<br><br>This metric tracks the number of metrics that have been dropped by the Telegraf agent during its operation. Metrics can be dropped for various reasons, such as buffer overflows, write errors, or other issues that prevent the metrics from being successfully processed and sent to the output destination. |`TelegrafInternalAgentMetricsDropped` | No | Count |Average |`Host`|PT1M |No|
|**Telegraf Internal Agent Metrics Gathered**<br><br>This metric tracks the number of metrics that have been successfully gathered by the Telegraf agent. |`TelegrafInternalAgentMetricsGathered` | No | Count |Average |`Host`|PT1M |No|
|**Telegraf Internal Agent Metrics Written**<br><br>This metric tracks the number of metrics that have been successfully written by the Telegraf agent to the output destination. |`TelegrafInternalAgentMetricsWritten` | No | Count |Average |`Host`|PT1M |No|
|**Telegraf Write Buffer Percent Used**<br><br>Percentage of metric write buffer that is being used. In the absence of data, this metric will default to 0. |`TelegrafWriteBufferPercentUsed` | No | Percent |Average |`Host`, `Output`|PT1M |Yes|

### Category: Traffic
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Network In/Sec (Preview)**<br><br>Rate of data received by the network device |`Network Device Bytes Received/sec` | No | BytesPerSecond |Minimum, Maximum, Average, Total (Sum), Count |`ClusterName`, `ClusterNodeName`, `Device`|PT1M |No|
|**Network Out/Sec (Preview)**<br><br>Rate of data sent by the network device. |`Network Device Bytes Sent/sec` | No | BytesPerSecond |Minimum, Maximum, Average, Total (Sum), Count |`ClusterName`, `ClusterNodeName`, `Device`|PT1M |No|
|**Network Packets In/Sec (Preview)**<br><br>Rate of packets received by the network device |`Network Device Packets Received/sec` | No | CountPerSecond |Minimum, Maximum, Average, Total (Sum), Count |`ClusterName`, `ClusterNodeName`, `Device`|PT1M |No|
|**Network Packets Out/Sec (Preview)**<br><br>Rate of packets sent by the network device. |`Network Device Packets Sent/sec` | No | CountPerSecond |Minimum, Maximum, Average, Total (Sum), Count |`ClusterName`, `ClusterNodeName`, `Device`|PT1M |No|
|**Storage Read Bytes/Sec (Preview)**<br><br>Rate of data read by the host from the storage endpoint. |`Storage Endpoint Read Bytes/sec` | No | BytesPerSecond |Minimum, Maximum, Average, Total (Sum), Count |`ClusterName`, `ClusterNodeName`, `StorageEndpoint`|PT1M |No|
|**Storage Read Operations/sec (Preview)**<br><br>Rate of read operations by the host from the storage endpoint. |`Storage Endpoint Read Operations/sec` | No | CountPerSecond |Minimum, Maximum, Average, Total (Sum), Count |`ClusterName`, `ClusterNodeName`, `StorageEndpoint`|PT1M |No|
|**Storage Write Bytes/Sec (Preview)**<br><br>Rate of data written by the host to the storage endpoint. |`Storage Endpoint Write Bytes/sec` | No | BytesPerSecond |Minimum, Maximum, Average, Total (Sum), Count |`ClusterName`, `ClusterNodeName`, `StorageEndpoint`|PT1M |No|
|**Storage Write Operations/sec (Preview)**<br><br>Rate of write operations by the host to the storage endpoint. |`Storage Endpoint Write Operations/sec` | No | CountPerSecond |Minimum, Maximum, Average, Total (Sum), Count |`ClusterName`, `ClusterNodeName`, `StorageEndpoint`|PT1M |No|
|**VM Network In/Sec (Preview)**<br><br>Rate of network bytes received by the virtual machine interfaces per second. |`VmNetworkReceiveBytesPerSecond` | No | BytesPerSecond |Minimum, Maximum, Average, Total (Sum), Count |`ClusterName`, `ClusterNodeName`, `Instance`, `Interface`|PT1M |No|
|**VM Network Out/Sec (Preview)**<br><br>Rate of network bytes transmitted by the virtual machine interfaces per second. |`VmNetworkTransmitBytesPerSecond` | No | BytesPerSecond |Minimum, Maximum, Average, Total (Sum), Count |`ClusterName`, `ClusterNodeName`, `Instance`, `Interface`|PT1M |No|

### Category: VMOrchestrator
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Kubevirt Info**<br><br>Kubevirt version information. |`KubevirtInfo` | No | Unspecified |Average |`Kube Version`|PT1M |No|
|**Kubevirt Virt Controller Leading**<br><br>Indication of whether the virt-controller is leading. The value is 1 if the virt-controller is leading, 0 otherwise. In the absence of data, this metric will default to 0. |`KubevirtVirtControllerLeadingStatus` | No | Unspecified |Average |`Pod Name`|PT1M |No|
|**Kubevirt Virt Controller Ready**<br><br>Indication for a virt-controller that is ready to take the lead. The value is 1 if the virt-controller is ready, 0 otherwise. In the absence of data, this metric will default to 0. |`KubevirtVirtControllerReadyStatus` | No | Unspecified |Average |`Pod Name`|PT1M |No|
|**Kubevirt Virt Operator Ready**<br><br>Indication for a virt operator being ready. The value is 1 if the virt operator is ready, 0 otherwise. In the absence of data, this metric will default to 0. |`KubevirtVirtOperatorReadyStatus` | No | Unspecified |Average |`Pod Name`|PT1M |No|
|**Kubevirt VMI Memory Balloon Bytes**<br><br>Current balloon size. In the absence of data, this metric will default to 0. |`KubevirtVmiMemoryActualBalloonBytes` | No | Bytes |Average |`Name`, `Node`|PT1M |No|
|**Kubevirt VMI Memory Available Bytes**<br><br>Amount of usable memory as seen by the domain. This value may not be accurate if a balloon driver is in use or if the guest OS does not initialize all assigned pages. In the absence of data, this metric will default to 0. |`KubevirtVmiMemoryAvailableBytes` | No | Bytes |Average |`Name`, `Node`|PT1M |No|
|**Kubevirt VMI Mem Dom Bytes**<br><br>The amount of memory allocated to the domain. The memory value in the domain XML file. |`KubevirtVmiMemoryDomainBytes` | No | Bytes |Average |`Node`|PT1M |No|
|**Kubevirt VMI Mem Swp In Traffic Bytes**<br><br>The total amount of data read from swap space of the guest. |`KubevirtVmiMemorySwapInTrafficBytes` | No | Bytes |Average |`Name`, `Node`|PT1M |No|
|**Kubevirt VMI Mem Swp Out Traffic Bytes**<br><br>The total amount of memory written out to swap space of the guest. |`KubevirtVmiMemorySwapOutTrafficBytes` | No | Bytes |Average |`Name`, `Node`|PT1M |No|
|**Kubevirt VMI Memory Unused Bytes**<br><br>The amount of memory left completely unused by the system. Memory that is available but used for reclaimable caches should NOT be reported as free. In the absence of data, this metric will default to 0. |`KubevirtVmiMemoryUnusedBytes` | No | Bytes |Average |`Name`, `Node`|PT1M |No|
|**Kubevirt VMI Memory Usage**<br><br>The amount of memory used as a percentage. In the absence of data, this metric will default to 0. |`KubevirtVmiMemoryUsage` | No | Percent |Average |`Name`, `Node`|PT1M |No|
|**Kubevirt VMI Outdated Count**<br><br>Indication for the total number of VirtualMachineInstance (VMI) workloads that are not running within the most up-to-date version of the virt-launcher environment. In the absence of data, this metric will default to 0. |`KubevirtVmiNumberOfOutdatedInstances` | No | Count |Average |\<none\>|PT1M |No|
|**Kubevirt VMI Storage IOPS Read Total**<br><br>Total number of Input/Output (I/O) read operations. |`KubevirtVmiStorageIopsReadTotal` | No | Count |Average |`Drive`, `Name`, `Node`|PT1M |No|
|**Kubevirt VMI Storage IOPS Write Total**<br><br>Total number of Input/Output (I/O) write operations. |`KubevirtVmiStorageIopsWriteTotal` | No | Count |Average |`Drive`, `Name`, `Node`|PT1M |No|
|**Kubevirt VMI Storage Read Times Total**<br><br>Total time spent on read operations from storage. |`KubevirtVmiStorageReadTimesSecondsTotal` | No | Seconds |Average |`Drive`, `Name`, `Node`|PT1M |No|
|**Kubevirt VMI Storage Write Times Total**<br><br>Total time spent on write operations to storage. |`KubevirtVmiStorageWriteTimesSecondsTotal` | No | Seconds |Average |`Drive`, `Name`, `Node`|PT1M |No|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
