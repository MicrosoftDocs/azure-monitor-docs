---
title: Supported metrics - Microsoft.NetworkCloud/clusters
description: Reference for Microsoft.NetworkCloud/clusters metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.NetworkCloud/clusters, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.NetworkCloud/clusters

The following table lists the metrics available for the Microsoft.NetworkCloud/clusters resource type.

**Table headings**

**Metric** - The metric display name as it appears in the Azure portal.
**Name in Rest API** - Metric name as referred to in the [REST API](/azure/azure-monitor/essentials/rest-api-walkthrough).
**Unit** - Unit of measure.
**Aggregation** - The default [aggregation](/azure/azure-monitor/essentials/metrics-aggregation-explained) type. Valid values: Average, Minimum, Maximum, Total, Count.
**Dimensions** - [Dimensions](/azure/azure-monitor/essentials/metrics-aggregation-explained#dimensions-splitting-and-filtering) available for the metric.
**Time Grains** - [Intervals at which the metric is sampled](/azure/azure-monitor/essentials/metrics-aggregation-explained#granularity). For example, `PT1M` indicates that the metric is sampled every minute, `PT30M` every 30 minutes, `PT1H` every hour, and so on.
**DS Export**- Whether the metric is exportable to Azure Monitor Logs via Diagnostic Settings.

For information on exporting metrics, see - [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics) and [Create diagnostic settings in Azure Monitor](/azure/azure-monitor/essentials/create-diagnostic-settings?tabs=portal).

For information on metric retention, see [Azure Monitor Metrics overview](/azure/azure-monitor/essentials/data-platform-metrics#retention-of-metrics).


For a list of supported logs, see [Supported log categories - Microsoft.NetworkCloud/clusters](../supported-logs/microsoft-networkcloud-clusters-logs.md)


### Category: API Server
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**APIServer Audit Requests Rejected Total**<br><br>Counter of API server requests rejected due to an error in the audit logging backend. |`ApiserverAuditRequestsRejectedTotal` |Count |Average |`Component`, `Pod Name`|PT1M |No|
|**APIServer Clnt Cert Exp Sec Sum (Preview)**<br><br>Sum of API server client certificate expiration. |`ApiserverClientCertificateExpirationSecondsSum` |Seconds |Average |`Component`, `Pod Name`|PT1M |No|
|**APIServer Storage Data Key Gen Fail**<br><br>Total number of operations that failed Data Encryption Key (DEK) generation. |`ApiserverStorageDataKeyGenerationFailuresTotal` |Count |Average |`Component`, `Pod Name`|PT1M |No|
|**APIServer TLS Handshake Err (Preview)**<br><br>Number of requests dropped with 'TLS handshake' error. |`ApiserverTlsHandshakeErrorsTotal` |Count |Average |`Component`, `Pod Name`|PT1M |No|

### Category: Availability
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Memory Used (Preview)**<br><br>The used memory of the node. |`Cluster Node Memory Used` |Bytes |Minimum, Maximum, Average, Total (Sum) |`ClusterName`, `ClusterNodeName`|PT1M |No|
|**Memory Available (Preview)**<br><br>The available memory of the node. |`Memory Available Bytes` |Bytes |Minimum, Maximum, Average, Total (Sum) |`ClusterName`, `ClusterNodeName`|PT1M |No|
|**Memory Total (Preview)**<br><br>The total physical memory of the node. |`Memory Total Bytes` |Bytes |Minimum, Maximum, Average, Total (Sum) |`ClusterName`, `ClusterNodeName`|PT1M |No|

### Category: Calico
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Felix Active Local Endpoints**<br><br>Number of active endpoints on this host. |`FelixActiveLocalEndpoints` |Count |Average |`Host`|PT1M |No|
|**Felix Cluster Num Host Endpoints**<br><br>Total number of host endpoints cluster-wide. |`FelixClusterNumHostEndpoints` |Count |Average |`Host`|PT1M |No|
|**Felix Cluster Number of Hosts**<br><br>Total number of Calico hosts in the cluster. |`FelixClusterNumHosts` |Count |Average |`Host`|PT1M |No|
|**Felix Cluster Nmbr Workload Endpoints**<br><br>Total number of workload endpoints cluster-wide. |`FelixClusterNumWorkloadEndpoints` |Count |Average |`Host`|PT1M |No|
|**Felix Interface Dataplane Failures**<br><br>Number of times dataplane updates failed and will be retried. |`FelixIntDataplaneFailures` |Count |Average |`Host`|PT1M |No|
|**Felix Ipset Errors**<br><br>Number of 'ipset' command failures. |`FelixIpsetErrors` |Count |Average |`Host`|PT1M |No|
|**Felix Ipsets Calico**<br><br>Number of active Calico IP sets. |`FelixIpsetsCalico` |Count |Average |`Host`|PT1M |No|
|**Felix IP Tables Restore Errors**<br><br>Number of 'iptables-restore' errors. |`FelixIptablesRestoreErrors` |Count |Average |`Host`|PT1M |No|
|**Felix IP Tables Save Errors**<br><br>Number of 'iptables-save' errors. |`FelixIptablesSaveErrors` |Count |Average |`Host`|PT1M |No|
|**Felix Resyncs Started**<br><br>Number of times Felix has started resyncing with the datastore. |`FelixResyncsStarted` |Count |Average |`Host`|PT1M |No|
|**Felix Resync State**<br><br>Current datastore state. |`FelixResyncState` |Unspecified |Average |`Host`|PT1M |No|
|**Typha Client Latency Secs**<br><br>Per-client latency: how far behind the current state each client is. |`TyphaClientLatencySecsCount` |Count |Average |`Pod Name`|PT1M |No|
|**Typha Connections Accepted**<br><br>Total number of connections accepted over time. |`TyphaConnectionsAccepted` |Count |Average |`Pod Name`|PT1M |No|
|**Typha Connections Dropped**<br><br>Total number of connections dropped due to rebalancing. |`TyphaConnectionsDropped` |Count |Average |`Pod Name`|PT1M |No|
|**Typha Ping Latency**<br><br>Round-trip ping latency to client. Typha's protocol includes a regular ping keepalive to verify that the connection is still up. |`TyphaPingLatencyCount` |Count |Average |`Pod Name`|PT1M |No|

### Category: Container
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Container FS I/O Time Seconds Total (Preview)**<br><br>Time taken for container Input/Output (I/O) operations. |`ContainerFsIoTimeSecondsTotal` |Seconds |Average |`Device`, `Host`|PT1M |No|
|**Container Memory Fail Count**<br><br>Number of times a container's memory usage limit is hit. In the absence of data, this metric will default to 0. |`ContainerMemoryFailcnt` |Count |Average |`Container`, `Host`, `Namespace`, `Pod`|PT1M |No|
|**Container Memory Usage Bytes**<br><br>Current memory usage, including all memory regardless of when it was accessed. In the absence of data, this metric will default to 0. |`ContainerMemoryUsageBytes` |Bytes |Average |`Container`, `Host`, `Namespace`, `Pod`|PT1M |No|
|**Container Scrape Error**<br><br>Indicates whether there was an error while getting container metrics. |`ContainerScrapeError` |Unspecified |Average |`Host`|PT1M |No|
|**Container Tasks State**<br><br>Number of tasks or processes in a given state (sleeping, running, stopped, uninterruptible, or waiting) in a container. |`ContainerTasksState` |Count |Average |`Container`, `Host`, `Namespace`, `Pod`, `State`|PT1M |No|

### Category: Controller
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Controller Reconcile Errors Total**<br><br>Total number of reconciliation errors per controller. |`ControllerRuntimeReconcileErrorsTotal2` |Count |Average |`Controller`, `Namespace`, `Pod Name`|PT1M |No|
|**Controller Reconciliations Total**<br><br>Total number of reconciliations per controller. |`ControllerRuntimeReconcileTotal2` |Count |Average |`Controller`, `Namespace`, `Pod Name`|PT1M |No|

### Category: CoreDNS
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**CoreDNS Requests Total**<br><br>Total number of DNS requests recieved by a CoreDNS server. |`CorednsDnsRequestsTotal` |Count |Average |`Family`, `Pod Name`, `Proto`, `Server`, `Type`|PT1M |No|
|**CoreDNS Responses Total**<br><br>Total number of DNS responses sent by a CoreDNS server. |`CorednsDnsResponsesTotal` |Count |Average |`Pod Name`, `Server`, `Rcode`|PT1M |No|
|**CoreDNS Frwd Hlthchk Broken**<br><br>Total number of times the health checks for all upstream DNS servers has failed. |`CorednsForwardHealthcheckBrokenTotal2` |Count |Average |`Pod Name`, `Namespace`|PT1M |No|
|**CoreDNS Frwd Max Concurrent Rejects**<br><br>Total number of rejected queries due to concurrent queries reaching the maximum limit. |`CorednsForwardMaxConcurrentRejectsTotal2` |Count |Average |`Pod Name`, `Namespace`|PT1M |No|
|**CoreDNS Health Request Failures Total**<br><br>The number of times the self health check failed for a CoreDNS server. |`CorednsHealthRequestFailuresTotal` |Count |Average |`Pod Name`|PT1M |No|
|**CoreDNS Panics Total**<br><br>Total number of unexpected errors (panics) that have occurred in a CoreDNS server. |`CorednsPanicsTotal` |Count |Average |`Pod Name`|PT1M |No|
|**CoreDNS Reload Failed Total**<br><br>Total number of failed attempts CoreDNS has had when reloading its configuration. |`CorednsReloadFailedTotal2` |Count |Average |`Pod Name`, `Namespace`|PT1M |No|

### Category: Daemonset
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Daemonsets Current Number Scheduled**<br><br>Number of daemonsets currently scheduled. In the absence of data, this metric will default to 0. |`KubeDaemonsetStatusCurrentNumberScheduled` |Count |Average |`Daemonset`, `Namespace`|PT1M |No|
|**Daemonsets Desired Number Scheduled**<br><br>Number of daemonsets desired scheduled. In the absence of data, this metric will default to 0. |`KubeDaemonsetStatusDesiredNumberScheduled` |Count |Average |`Daemonset`, `Namespace`|PT1M |No|
|**Daemonsets Not Scheduled**<br><br>Number of daemonsets not scheduled. In the absence of data, this metric will default to 150. |`KubeDaemonsetStatusNotScheduled` |Count |Average |`Daemonset`, `Namespace`|PT1M |No|

### Category: Deployment
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Deployment Replicas Available**<br><br>Number of deployment replicas available. In the absence of data, this metric will default to 0. |`KubeDeploymentStatusReplicasAvailable` |Count |Average |`Deployment`, `Namespace`|PT1M |No|
|**Deployment Replicas Available Percent**<br><br>Percentage of deployment replicas available. In the absence of data, this metric will default to 0. |`KubeDeploymentStatusReplicasAvailablePercent` |Percent |Average |`Deployment`, `Namespace`|PT1M |No|
|**Deployment Replicas Ready**<br><br>Number of deployment replicas ready. |`KubeDeploymentStatusReplicasReady` |Count |Average |`Deployment`, `Namespace`|PT1M |No|
|**Deployment Replicas Unavailable**<br><br>Number of deployment replicas unavailable. |`KubeDeploymentStatusReplicasUnavailable` |Count |Average |`Deployment`, `Namespace`|PT1M |No|

### Category: Etcd
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Etcd Database Utilization Percentage**<br><br>The percentage of the Etcd Database utilized. In the absence of data, this metric will default to 0. |`EtcdDBUtilizationPercent` |Percent |Average |`Pod Name`|PT1M |No|
|**Etcd Disk Backend Commit Duration Sec**<br><br>The cumulative sum of the time taken for etcd to commit transactions to its backend disk storage. |`EtcdDiskBackendCommitDurationSecondsSum` |Seconds |Total (Sum) |`Component`, `Pod Name`, `Tier`|PT1M |No|
|**Etcd Disk WAL Fsync Duration Sec**<br><br>The cumulative sum of of the time that etcd has spent performing fsync operations on the write-ahead log (WAL) file. |`EtcdDiskWalFsyncDurationSecondsSum` |Seconds |Total (Sum) |`Component`, `Pod Name`, `Tier`|PT1M |No|
|**Etcd Server Health Failures**<br><br>Total number of failed health checks performed on an etcd server. In the absence of data, this metric will default to 0. |`EtcdServerHealthFailures` |Count |Average |`Pod Name`|PT1M |No|
|**Etcd Server Is Leader**<br><br>Indicates whether an etcd server the leader of the cluster; 1 if is, 0 otherwise. |`EtcdServerIsLeader` |Unspecified |Count |`Component`, `Pod Name`, `Tier`|PT1M |No|
|**Etcd Server Is Learner**<br><br>Indicates whether an etcd server a learner within the cluster; 1 if is, 0 otherwise. |`EtcdServerIsLearner` |Unspecified |Count |`Component`, `Pod Name`, `Tier`|PT1M |No|
|**Etcd Server Leader Changes Seen Total**<br><br>The number of leader changes seen within the etcd cluster. |`EtcdServerLeaderChangesSeenTotal` |Count |Average |`Component`, `Pod Name`, `Tier`|PT1M |No|
|**Etcd Server Proposals Applied Total**<br><br>The total number of consensus proposals that have been successfully applied. |`EtcdServerProposalsAppliedTotal` |Count |Average |`Component`, `Pod Name`, `Tier`|PT1M |No|
|**Etcd Server Proposals Committed Total**<br><br>The total number of consensus proposals that have been committed. |`EtcdServerProposalsCommittedTotal` |Count |Average |`Component`, `Pod Name`, `Tier`|PT1M |No|
|**Etcd Server Proposals Failed Total**<br><br>The total number of failed consensus proposals. |`EtcdServerProposalsFailedTotal` |Count |Average |`Component`, `Pod Name`, `Tier`|PT1M |No|
|**Etcd Server Slow Apply Total (Preview)**<br><br>The total number of etcd apply requests that took longer than expected. |`EtcdServerSlowApplyTotal` |Count |Average |`Pod Name`, `Tier`|PT1M |No|

### Category: Job
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Jobs Active**<br><br>Number of jobs active. In the absence of data, this metric will default to 0. |`KubeJobStatusActive` |Count |Average |`Job`, `Namespace`|PT1M |No|
|**Jobs Failed**<br><br>Number and reason of jobs failed. |`KubeJobStatusFailedReasons` |Count |Average |`Job`, `Namespace`, `Reason`|PT1M |No|
|**Jobs Succeeded**<br><br>Number of jobs succeeded. In the absence of data, this metric will default to 0. |`KubeJobStatusSucceeded` |Count |Average |`Job`, `Namespace`|PT1M |No|

### Category: Kubelet
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Kubelet Running Containers**<br><br>Number of containers currently running. |`KubeletRunningContainers` |Count |Average |`Container State`, `Host`|PT1M |No|
|**Kubelet Running Pods**<br><br>Number of pods running on the node. |`KubeletRunningPods` |Count |Average |`Host`|PT1M |No|
|**Kubelet Runtime Operations Errors Total**<br><br>Cumulative number of runtime operation errors by operation type. |`KubeletRuntimeOperationsErrorsTotal` |Count |Average |`Host`, `Operation Type`|PT1M |No|
|**Kubelet Started Pods Errors Total**<br><br>Cumulative number of errors when starting pods. |`KubeletStartedPodsErrorsTotal` |Count |Average |`Host`|PT1M |No|

### Category: Network Cloud
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**CPU Pinning Map (Preview)**<br><br>Pinning map of virtual CPUs (vCPUs) to CPUs. |`NcVmiCpuAffinity` |Count |Average |`CPU`, `NUMA Node`, `VMI Name`, `VMI Namespace`, `VMI Node`, `VMI State`|PT1M |No|

### Category: Nexus Cluster
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Cluster Heartbeat Connection Status (Deprecated)**<br><br>Indicates whether the Cluster is having issues communicating with the Cluster Manager. The value of the metric is 0 when the connection is healthy and 1 when it is unhealthy. |`NexusClusterHeartbeatConnectionStatus` |Count |Average |`Reason`|PT1M |No|
|**Cluster Machine Group Upgrade**<br><br>Tracks Cluster Machine Group Upgrades performed. The value of the metric is 0 when the result is successful and 1 for all other results. |`NexusClusterMachineGroupUpgrade` |Count |Average |`Machine Group`, `Result`, `Upgraded From Version`, `Upgraded To Version`|PT1M |No|

### Category: Node
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Node Resources Allocatable**<br><br>Node resources allocatable for pods. |`KubeNodeStatusAllocatable` |Count |Average |`Node`, `Resource`, `Unit`|PT1M |No|
|**Node Resources Capacity**<br><br>Total amount of node resources available. |`KubeNodeStatusCapacity` |Count |Average |`Node`, `Resource`, `Unit`|PT1M |No|
|**Node Status Condition**<br><br>The condition of a node. |`KubeNodeStatusCondition` |Count |Average |`Condition`, `Node`, `Status`|PT1M |No|

### Category: Pod
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Container Resources Limits**<br><br>The container's resources limits. In the absence of data, this metric will default to 0. |`KubePodContainerResourceLimits` |Count |Average |`Container`, `Namespace`, `Node`, `Pod`, `Resource`, `Unit`|PT1M |No|
|**Container Resources Requests**<br><br>The container's resources requested. In the absence of data, this metric will default to 0. |`KubePodContainerResourceRequests` |Count |Average |`Container`, `Namespace`, `Node`, `Pod`, `Resource`, `Unit`|PT1M |No|
|**Container State Started (Preview)**<br><br>Unix timestamp start time of a container. In the absence of data, this metric will default to 0. |`KubePodContainerStateStarted` |Count |Average |`Container`, `Namespace`, `Pod`|PT1M |No|
|**Container Status Last Terminated Reason**<br><br>The reason of a container's last terminated status. In the absence of data, this metric will default to 0. |`KubePodContainerStatusLastTerminatedReason` |Count |Average |`Container`, `Namespace`, `Pod`, `Reason`|PT1M |No|
|**Container Status Ready**<br><br>Describes whether the container's readiness check succeeded. In the absence of data, this metric will default to 0. |`KubePodContainerStatusReady` |Count |Average |`Container`, `Namespace`, `Pod`|PT1M |No|
|**Container Restarts**<br><br>The number of container restarts. |`KubePodContainerStatusRestartsTotal` |Count |Average |`Container`, `Namespace`, `Pod`|PT1M |No|
|**Container Status Running**<br><br>The number of containers with a status of 'running'. In the absence of data, this metric will default to 0. |`KubePodContainerStatusRunning` |Count |Average |`Container`, `Namespace`, `Pod`|PT1M |No|
|**Container Status Terminated**<br><br>The number of containers with a status of 'terminated'. In the absence of data, this metric will default to 0. |`KubePodContainerStatusTerminated` |Count |Average |`Container`, `Namespace`, `Pod`|PT1M |No|
|**Container Status Terminated Reason**<br><br>The number and reason of containers with a status of 'terminated'. |`KubePodContainerStatusTerminatedReasons` |Count |Average |`Container`, `Namespace`, `Pod`, `Reason`|PT1M |No|
|**Container Status Waiting**<br><br>The number of containers with a status of 'waiting'. In the absence of data, this metric will default to 0. |`KubePodContainerStatusWaiting` |Count |Average |`Container`, `Namespace`, `Pod`|PT1M |No|
|**Container Status Waiting Reason**<br><br>The number and reason of containers with a status of 'waiting'. In the absence of data, this metric will default to 0. |`KubePodContainerStatusWaitingReason` |Count |Average |`Container`, `Namespace`, `Pod`, `Reason`|PT1M |No|
|**Pod Deletion Timestamp (Preview)**<br><br>The timestamp of the pod's deletion. In the absence of data, this metric will default to 0. |`KubePodDeletionTimestamp` |Count |Average |`Namespace`, `Pod`|PT1M |No|
|**Pod Init Container Ready**<br><br>The number of ready pod init containers. In the absence of data, this metric will default to 0. |`KubePodInitContainerStatusReady` |Count |Average |`Namespace`, `Container`, `Pod`|PT1M |No|
|**Pod Init Container Restarts**<br><br>The number of pod init containers restarts. |`KubePodInitContainerStatusRestartsTotal` |Count |Average |`Namespace`, `Container`, `Pod`|PT1M |No|
|**Pod Init Container Running**<br><br>The number of running pod init containers. In the absence of data, this metric will default to 0. |`KubePodInitContainerStatusRunning` |Count |Average |`Namespace`, `Container`, `Pod`|PT1M |No|
|**Pod Init Container Terminated**<br><br>The number of terminated pod init containers. In the absence of data, this metric will default to 0. |`KubePodInitContainerStatusTerminated` |Count |Average |`Namespace`, `Container`, `Pod`|PT1M |No|
|**Pod Init Container Terminated Reason**<br><br>The number of pod init containers with terminated reason. In the absence of data, this metric will default to 0. |`KubePodInitContainerStatusTerminatedReason` |Count |Average |`Namespace`, `Container`, `Pod`, `Reason`|PT1M |No|
|**Pod Init Container Waiting**<br><br>The number of pod init containers waiting. In the absence of data, this metric will default to 0. |`KubePodInitContainerStatusWaiting` |Count |Average |`Namespace`, `Container`, `Pod`|PT1M |No|
|**Pod Init Container Waiting Reason**<br><br>The reason the pod init container is waiting. In the absence of data, this metric will default to 0. |`KubePodInitContainerStatusWaitingReason` |Count |Average |`Namespace`, `Container`, `Pod`, `Reason`|PT1M |No|
|**Pod Status Phase**<br><br>The pod status phase. In the absence of data, this metric will default to 0. |`KubePodStatusPhases` |Count |Average |`Namespace`, `Pod`, `Phase`|PT1M |No|
|**Pod Ready State**<br><br>Signifies if the pod is in ready state. In the absence of data, this metric will default to 0. |`KubePodStatusReady` |Count |Average |`Namespace`, `Pod`, `Condition`|PT1M |No|
|**Pod Status Reason**<br><br>NodeAffinity |`KubePodStatusReason` |Count |Average |`Namespace`, `Pod`, `Reason`|PT1M |No|

### Category: Saturation
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Percentage CPU (Preview)**<br><br>The percentage of processor time that is not idle. |`Cluster Node CPU Utilization` |Percent |Minimum, Maximum, Average, Count |`ClusterName`, `ClusterNodeName`|PT1M |No|
|**Percentage Memory (Preview)**<br><br>The memory usage of the node, including unused allocated memory. |`Cluster Node Memory Usage` |Percent |Minimum, Maximum, Average, Total (Sum) |`ClusterName`, `ClusterNodeName`|PT1M |No|

### Category: Statefulset
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Statefulset Desired Replicas Number**<br><br>The desired number of statefulset replicas. |`KubeStatefulsetReplicas` |Count |Average |`Namespace`, `Statefulset`|PT1M |No|
|**Statefulset Replicas Difference**<br><br>The difference between desired and current number of replicas per statefulset. In the absence of data, this metric will default to 0. |`KubeStatefulsetStatusReplicaDifference` |Count |Average |`Namespace`, `Statefulset`|PT1M |No|
|**Statefulset Replicas Number**<br><br>The number of replicas per statefulset. In the absence of data, this metric will default to 0. |`KubeStatefulsetStatusReplicas` |Count |Average |`Namespace`, `Statefulset`|PT1M |No|

### Category: Storage
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**NFS Volume Size Bytes**<br><br>Total Size of the NFS volume. |`NfsVolumeSizeBytes` |Bytes |Average |`CSN Name`|PT1M |No|
|**NFS Volume Used Bytes**<br><br>Size of NFS volume used. |`NfsVolumeUsedBytes` |Bytes |Average |`CSN Name`|PT1M |No|
|**NFS Volume Used Percent**<br><br>Percent of NFS volume used. |`NfsVolumeUsedPercent` |Percent |Average |`CSN Name`|PT1M |No|
|**Storage control-plane connectivity (Preview)**<br><br>Cluster's connectivity status to the storage appliance. In the absence of data, this metric will default to 0. |`StorageControlPlaneConnectivity` |Count |Average |`Appliance Name`, `Node`, `Endpoint`, `State`|PT1M |No|

### Category: Telegraf
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Telegraf Internal Agent Gather Errors**<br><br>This metric tracks the number of errors that occur during the gather phase of the Telegraf agent's operation. These errors can happen for various reasons, such as issues with input plugins or problems accessing data sources. |`TelegrafInternalAgentGatherErrors` |Count |Average |`Host`|PT1M |No|
|**Telegraf Internal Agent Gather Timeouts**<br><br>The number of Telegraf internal agent gather timeouts. Timeouts can happen if the data sources are slow to respond or if there are network issues. |`TelegrafInternalAgentGatherTimeouts` |Count |Average |`Host`|PT1M |No|
|**Telegraf Internal Agent Metrics Dropped**<br><br>This metric tracks the number of metrics that have been dropped by the Telegraf agent during its operation. Metrics can be dropped for various reasons, such as buffer overflows, write errors, or other issues that prevent the metrics from being successfully processed and sent to the output destination. |`TelegrafInternalAgentMetricsDropped` |Count |Average |`Host`|PT1M |No|
|**Telegraf Internal Agent Metrics Gathered**<br><br>This metric tracks the number of metrics that have been successfully gathered by the Telegraf agent. |`TelegrafInternalAgentMetricsGathered` |Count |Average |`Host`|PT1M |No|
|**Telegraf Internal Agent Metrics Written**<br><br>This metric tracks the number of metrics that have been successfully written by the Telegraf agent to the output destination. |`TelegrafInternalAgentMetricsWritten` |Count |Average |`Host`|PT1M |No|
|**Telegraf Write Buffer Percent Used**<br><br>Percentage of metric write buffer that is being used. In the absence of data, this metric will default to 0. |`TelegrafWriteBufferPercentUsed` |Percent |Average |`Host`, `Output`|PT1M |Yes|

### Category: Traffic
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Network In/Sec (Preview)**<br><br>Rate of data received by the network device |`Network Device Bytes Received/sec` |BytesPerSecond |Minimum, Maximum, Average, Total (Sum), Count |`ClusterName`, `ClusterNodeName`, `Device`|PT1M |No|
|**Network Out/Sec (Preview)**<br><br>Rate of data sent by the network device. |`Network Device Bytes Sent/sec` |BytesPerSecond |Minimum, Maximum, Average, Total (Sum), Count |`ClusterName`, `ClusterNodeName`, `Device`|PT1M |No|
|**Network Packets In/Sec (Preview)**<br><br>Rate of packets received by the network device |`Network Device Packets Received/sec` |CountPerSecond |Minimum, Maximum, Average, Total (Sum), Count |`ClusterName`, `ClusterNodeName`, `Device`|PT1M |No|
|**Network Packets Out/Sec (Preview)**<br><br>Rate of packets sent by the network device. |`Network Device Packets Sent/sec` |CountPerSecond |Minimum, Maximum, Average, Total (Sum), Count |`ClusterName`, `ClusterNodeName`, `Device`|PT1M |No|
|**Storage Read Bytes/Sec (Preview)**<br><br>Rate of data read by the host from the storage endpoint. |`Storage Endpoint Read Bytes/sec` |BytesPerSecond |Minimum, Maximum, Average, Total (Sum), Count |`ClusterName`, `ClusterNodeName`, `StorageEndpoint`|PT1M |No|
|**Storage Read Operations/sec (Preview)**<br><br>Rate of read operations by the host from the storage endpoint. |`Storage Endpoint Read Operations/sec` |CountPerSecond |Minimum, Maximum, Average, Total (Sum), Count |`ClusterName`, `ClusterNodeName`, `StorageEndpoint`|PT1M |No|
|**Storage Write Bytes/Sec (Preview)**<br><br>Rate of data written by the host to the storage endpoint. |`Storage Endpoint Write Bytes/sec` |BytesPerSecond |Minimum, Maximum, Average, Total (Sum), Count |`ClusterName`, `ClusterNodeName`, `StorageEndpoint`|PT1M |No|
|**Storage Write Operations/sec (Preview)**<br><br>Rate of write operations by the host to the storage endpoint. |`Storage Endpoint Write Operations/sec` |CountPerSecond |Minimum, Maximum, Average, Total (Sum), Count |`ClusterName`, `ClusterNodeName`, `StorageEndpoint`|PT1M |No|

### Category: VMOrchestrator
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Kubevirt Info**<br><br>Kubevirt version information. |`KubevirtInfo` |Unspecified |Average |`Kube Version`|PT1M |No|
|**Kubevirt Virt Controller Leading**<br><br>Indication of whether the virt-controller is leading. The value is 1 if the virt-controller is leading, 0 otherwise. In the absence of data, this metric will default to 0. |`KubevirtVirtControllerLeadingStatus` |Unspecified |Average |`Pod Name`|PT1M |No|
|**Kubevirt Virt Controller Ready**<br><br>Indication for a virt-controller that is ready to take the lead. The value is 1 if the virt-controller is ready, 0 otherwise. In the absence of data, this metric will default to 0. |`KubevirtVirtControllerReadyStatus` |Unspecified |Average |`Pod Name`|PT1M |No|
|**Kubevirt Virt Operator Ready**<br><br>Indication for a virt operator being ready. The value is 1 if the virt operator is ready, 0 otherwise. In the absence of data, this metric will default to 0. |`KubevirtVirtOperatorReadyStatus` |Unspecified |Average |`Pod Name`|PT1M |No|
|**Kubevirt VMI Memory Balloon Bytes**<br><br>Current balloon size. In the absence of data, this metric will default to 0. |`KubevirtVmiMemoryActualBalloonBytes` |Bytes |Average |`Name`, `Node`|PT1M |No|
|**Kubevirt VMI Memory Available Bytes**<br><br>Amount of usable memory as seen by the domain. This value may not be accurate if a balloon driver is in use or if the guest OS does not initialize all assigned pages. In the absence of data, this metric will default to 0. |`KubevirtVmiMemoryAvailableBytes` |Bytes |Average |`Name`, `Node`|PT1M |No|
|**Kubevirt VMI Mem Dom Bytes**<br><br>The amount of memory allocated to the domain. The memory value in the domain XML file. |`KubevirtVmiMemoryDomainBytes` |Bytes |Average |`Node`|PT1M |No|
|**Kubevirt VMI Mem Swp In Traffic Bytes**<br><br>The total amount of data read from swap space of the guest. |`KubevirtVmiMemorySwapInTrafficBytes` |Bytes |Average |`Name`, `Node`|PT1M |No|
|**Kubevirt VMI Mem Swp Out Traffic Bytes**<br><br>The total amount of memory written out to swap space of the guest. |`KubevirtVmiMemorySwapOutTrafficBytes` |Bytes |Average |`Name`, `Node`|PT1M |No|
|**Kubevirt VMI Memory Unused Bytes**<br><br>The amount of memory left completely unused by the system. Memory that is available but used for reclaimable caches should NOT be reported as free. In the absence of data, this metric will default to 0. |`KubevirtVmiMemoryUnusedBytes` |Bytes |Average |`Name`, `Node`|PT1M |No|
|**Kubevirt VMI Memory Usage**<br><br>The amount of memory used as a percentage. In the absence of data, this metric will default to 0. |`KubevirtVmiMemoryUsage` |Percent |Average |`Name`, `Node`|PT1M |No|
|**Kubevirt VMI Outdated Count**<br><br>Indication for the total number of VirtualMachineInstance (VMI) workloads that are not running within the most up-to-date version of the virt-launcher environment. In the absence of data, this metric will default to 0. |`KubevirtVmiNumberOfOutdatedInstances` |Count |Average |\<none\>|PT1M |No|
|**Kubevirt VMI Storage IOPS Read Total**<br><br>Total number of Input/Output (I/O) read operations. |`KubevirtVmiStorageIopsReadTotal` |Count |Average |`Drive`, `Name`, `Node`|PT1M |No|
|**Kubevirt VMI Storage IOPS Write Total**<br><br>Total number of Input/Output (I/O) write operations. |`KubevirtVmiStorageIopsWriteTotal` |Count |Average |`Drive`, `Name`, `Node`|PT1M |No|
|**Kubevirt VMI Storage Read Times Total**<br><br>Total time spent on read operations from storage. |`KubevirtVmiStorageReadTimesSecondsTotal` |Seconds |Average |`Drive`, `Name`, `Node`|PT1M |No|
|**Kubevirt VMI Storage Write Times Total**<br><br>Total time spent on write operations to storage. |`KubevirtVmiStorageWriteTimesSecondsTotal` |Seconds |Average |`Drive`, `Name`, `Node`|PT1M |No|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
