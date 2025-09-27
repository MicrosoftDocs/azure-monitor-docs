---
title: Default Prometheus metrics configuration in Azure Monitor
description: This article lists the default targets, dashboards, and recording rules for Prometheus metrics in Azure Monitor.
ms.topic: article
ms.date: 09/10/2025
ms.reviewer: aul
---

# Default Prometheus metrics configuration in Azure Monitor
When you enable Prometheus metrics collection in Azure Monitor from your Kubernetes cluster, it uses a default configuration for targets, dashboards, and recording rules. This article describes the default configuration and the scenarios where you may choose to customize it for your specific requirements.

## Minimal ingestion profile
**Minimal ingestion profile** is a setting that is enabled by default when Prometheus metrics are enabled in Azure Monitor for a cluster. This setting reduces the volume of metrics ingested by limiting them to only metrics used by default dashboards, default recording rules, and default alerts. These targets and metrics are listed in this article. If this setting is disabled, then all available metrics for the default targets are collected which can significantly increase ingestion volume.

You can change the minimal ingestion profile setting by modifying the metrics setting ConfigMap as described in [Customize scraping of Prometheus metrics in Azure Monitor using ConfigMap](./prometheus-metrics-scrape-configuration.md).

## Customization scenarios
You may choose to use the default configuration or customize collection for your particular requirements. The following table lists the four potential collection scenarios and the recommended method to achieve each.

| Scenario | Method |
|:---|:---|
| Ingest only minimal metrics for each default target. | No change needed. Use the default behavior without modification. Only metrics listed in this article are ingested for each of the default targets. |
| Ingest a few other metrics for one or more default targets in addition to minimal metrics. | Keep minimal ingestion enabled and specify the appropriate keep lists specific to the target. See [Customize metrics collected by default targets](./prometheus-metrics-scrape-configuration.md#customize-metrics-collected-by-default-targets). |
| Ingest only a specific set of metrics for a default target. | Disable minimal ingestion and specify the appropriate keep list specific to the target in a custom scrape job. See [Create custom Prometheus scrape job from your Kubernetes cluster using ConfigMap](./prometheus-metrics-scrape-configmap.md). |
| Ingest all metrics scraped for the default target. | Disable minimal ingestion and don't specify any keep list for that target. See [Customize metrics collected by default targets](./prometheus-metrics-scrape-configuration.md#customize-metrics-collected-by-default-targets) |


## Targets scraped by default
Following are the targets that the Azure Monitor metrics add-on can scrape by default and the conditions under which they are enabled. See [Enable and disable default targets](./prometheus-metrics-scrape-configuration.md#enable-and-disable-default-targets) to enable/disable default targets.

The following targets are enabled by default.

- `cadvisor`
- `nodeexporter`
- `kubelet`
- `kube-state-metrics`
- `networkobservabilityRetina`

Th following targets are enabled when [control plane metrics (preview)](/azure/aks/monitor-aks#monitor-aks-control-plane-metrics-preview) is enabled.

- `controlplane-apiserver`
- `controlplane-etcd` 

The following targets are enable when [Container Network Observability](/azure/aks/advanced-network-observability-concepts) is enabled.

- `networkobservabilityHubble`
- `networkobservabilityCilium` 

The following targets are enabled when [Azure Container Storage](/azure/storage/container-storage/container-storage-introduction) is enabled.

- `acstor-capacity-provisioner`
- `acstor-metrics-exporter`

The following targets are disabled by default.

- `coredns`
- `kubeproxy`
- `apiserver`

The following targets are disabled by default and require [Windows metrics collection (preview)](./enable-windows-metrics.md) to be enabled.

- `windows-exporter`
- `kube-proxy-windows`


## Metrics collected from default targets

The following metrics are collected by default from each default target. All other metrics are dropped through relabeling rules. The target must be enabled for the metrics to be collected.

#### kubelet

- `kubelet_volume_stats_used_bytes`
- `kubelet_node_name`
- `kubelet_running_pods`
- `kubelet_running_pod_count`
- `kubelet_running_containers`
- `kubelet_running_container_count`
- `volume_manager_total_volumes`
- `kubelet_node_config_error`
- `kubelet_runtime_operations_total`
- `kubelet_runtime_operations_errors_total`
- `kubelet_runtime_operations_duration_seconds` `kubelet_runtime_operations_duration_seconds_bucket` `kubelet_runtime_operations_duration_seconds_sum` `kubelet_runtime_operations_duration_seconds_count`
- `kubelet_pod_start_duration_seconds` `kubelet_pod_start_duration_seconds_bucket` `kubelet_pod_start_duration_seconds_sum` `kubelet_pod_start_duration_seconds_count`
- `kubelet_pod_worker_duration_seconds` `kubelet_pod_worker_duration_seconds_bucket` `kubelet_pod_worker_duration_seconds_sum` `kubelet_pod_worker_duration_seconds_count`
- `storage_operation_duration_seconds` `storage_operation_duration_seconds_bucket` `storage_operation_duration_seconds_sum` `storage_operation_duration_seconds_count`
- `storage_operation_errors_total`
- `kubelet_cgroup_manager_duration_seconds` `kubelet_cgroup_manager_duration_seconds_bucket` `kubelet_cgroup_manager_duration_seconds_sum` `kubelet_cgroup_manager_duration_seconds_count`
- `kubelet_pleg_relist_duration_seconds` `kubelet_pleg_relist_duration_seconds_bucket` `kubelet_pleg_relist_duration_sum` `kubelet_pleg_relist_duration_seconds_count`
- `kubelet_pleg_relist_interval_seconds` `kubelet_pleg_relist_interval_seconds_bucket` `kubelet_pleg_relist_interval_seconds_sum` `kubelet_pleg_relist_interval_seconds_count`
- `rest_client_requests_total`
- `rest_client_request_duration_seconds` `rest_client_request_duration_seconds_bucket` `rest_client_request_duration_seconds_sum` `rest_client_request_duration_seconds_count`
- `process_resident_memory_bytes`
- `process_cpu_seconds_total`
- `go_goroutines`
- `kubelet_volume_stats_capacity_bytes`
- `kubelet_volume_stats_available_bytes`
- `kubelet_volume_stats_inodes_used`
- `kubelet_volume_stats_inodes`
- `kubernetes_build_info"`

#### coredns

- `coredns_build_info`
- `coredns_panics_total`
- `coredns_dns_responses_total`
- `coredns_forward_responses_total`
- `coredns_dns_request_duration_seconds`  `coredns_dns_request_duration_seconds_bucket`  `coredns_dns_request_duration_seconds_sum`  `coredns_dns_request_duration_seconds_count`
- `coredns_forward_request_duration_seconds`  `coredns_forward_request_duration_seconds_bucket`  `coredns_forward_request_duration_seconds_sum`  `coredns_forward_request_duration_seconds_count`
- `coredns_dns_requests_total`
- `coredns_forward_requests_total`
- `coredns_cache_hits_total`
- `coredns_cache_misses_total`
- `coredns_cache_entries`
- `coredns_plugin_enabled`
- `coredns_dns_request_size_bytes` `coredns_dns_request_size_bytes_bucket` `coredns_dns_request_size_bytes_sum` `coredns_dns_request_size_bytes_count` 
- `coredns_dns_response_size_bytes`  `coredns_dns_response_size_bytes_bucket`  `coredns_dns_response_size_bytes_sum`  `coredns_dns_response_size_bytes_count`
- `coredns_dns_response_size_bytes`  `coredns_dns_response_size_bytes_bucket`  `coredns_dns_response_size_bytes_sum`  `coredns_dns_response_size_bytes_count` 
- `process_resident_memory_bytes`
- `process_cpu_seconds_total`
- `go_goroutines`
- `kubernetes_build_info"`

#### cadvisor

- `container_spec_cpu_period`
- `container_spec_cpu_quota`
- `container_cpu_usage_seconds_total`
- `container_memory_rss`
- `container_network_receive_bytes_total`
- `container_network_transmit_bytes_total`
- `container_network_receive_packets_total`
- `container_network_transmit_packets_total`
- `container_network_receive_packets_dropped_total`
- `container_network_transmit_packets_dropped_total`
- `container_fs_reads_total`
- `container_fs_writes_total`
- `container_fs_reads_bytes_total`
-  `container_fs_writes_bytes_total`
- `container_memory_working_set_bytes`
- `container_memory_cache`
- `container_memory_swap`
- `container_cpu_cfs_throttled_periods_total`
- `container_cpu_cfs_periods_total`
- `kubernetes_build_info"`

#### kubeproxy
- `kubeproxy_sync_proxy_rules_duration_seconds` `kubeproxy_sync_proxy_rules_duration_seconds_bucket` `kubeproxy_sync_proxy_rules_duration_seconds_sum` `kubeproxy_sync_proxy_rules_duration_seconds_count` `kubeproxy_network_programming_duration_seconds`
- `kubeproxy_network_programming_duration_seconds` `kubeproxy_network_programming_duration_seconds_bucket` `kubeproxy_network_programming_duration_seconds_sum` `kubeproxy_network_programming_duration_seconds_count` `rest_client_requests_total`
- `rest_client_request_duration_seconds` `rest_client_request_duration_seconds_bucket` `rest_client_request_duration_seconds_sum` `rest_client_request_duration_seconds_count`
- `process_resident_memory_bytes`
- `process_cpu_seconds_total`
- `go_goroutines`
- `kubernetes_build_info"`

#### apiserver
-  `apiserver_request_duration_seconds` `apiserver_request_duration_seconds_bucket` `apiserver_request_duration_seconds_sum` `apiserver_request_duration_seconds_count` 
-  `apiserver_request_total` 
-  `workqueue_adds_total``workqueue_depth`
-  `workqueue_queue_duration_seconds` `workqueue_queue_duration_seconds_bucket` `workqueue_queue_duration_seconds_sum` `workqueue_queue_duration_seconds_count` 
-  `process_resident_memory_bytes`
-  `process_cpu_seconds_total`
-  `go_goroutines`
-  `kubernetes_build_info"`

#### kube-state

- `kube_job_status_succeeded`
- `kube_job_spec_completions`
- `kube_daemonset_status_desired_number_scheduled`
- `kube_daemonset_status_number_ready`
- `kube_deployment_status_replicas_ready`
- `kube_pod_container_status_last_terminated_reason`
- `kube_pod_container_status_waiting_reason`
- `kube_pod_container_status_restarts_total`
- `kube_node_status_allocatable`
- `kube_pod_owner`
- `kube_pod_container_resource_requests`
- `kube_pod_status_phase`
- `kube_pod_container_resource_limits`
- `kube_replicaset_owner`
- `kube_resourcequota`
- `kube_namespace_status_phase`
- `kube_node_status_capacity`
- `kube_node_info`
- `kube_pod_info`
- `kube_deployment_spec_replicas`
- `kube_deployment_status_replicas_available`
- `kube_deployment_status_replicas_updated`
- `kube_statefulset_status_replicas_ready`
- `kube_statefulset_status_replicas`
- `kube_statefulset_status_replicas_updated`
- `kube_job_status_start_time`
- `kube_job_status_active`
- `kube_job_failed`
- `kube_horizontalpodautoscaler_status_desired_replicas`
- `kube_horizontalpodautoscaler_status_current_replicas`
- `kube_horizontalpodautoscaler_spec_min_replicas`
- `kube_horizontalpodautoscaler_spec_max_replicas`
- `kubernetes_build_info`
- `kube_node_status_condition`
- `kube_node_spec_taint`
- `kube_pod_container_info`
- `kube_resource_labels` (ex - kube_pod_labels, kube_deployment_labels)
- `kube_resource_annotations` (ex - kube_pod_annotations, kube_deployment_annotations)

#### nodeexporter

- `node_cpu_seconds_total`
- `node_memory_MemAvailable_bytes`
- `node_memory_Buffers_bytes`
- `node_memory_Cached_bytes`
- `node_memory_MemFree_bytes`
- `node_memory_Slab_bytes`
- `node_memory_MemTotal_bytes`
- `node_netstat_Tcp_RetransSegs`
- `node_netstat_Tcp_OutSegs`
- `node_netstat_TcpExt_TCPSynRetrans`
- `node_load1``node_load5`
- `node_load15`
- `node_disk_read_bytes_total`
- `node_disk_written_bytes_total`
- `node_disk_io_time_seconds_total`
- `node_filesystem_size_bytes`
- `node_filesystem_avail_bytes`
- `node_filesystem_readonly`
- `node_network_receive_bytes_total`
- `node_network_transmit_bytes_total`
- `node_vmstat_pgmajfault`
- `node_network_receive_drop_total`
- `node_network_transmit_drop_total`
- `node_disk_io_time_weighted_seconds_total`
- `node_exporter_build_info`
- `node_time_seconds`
- `node_uname_info"`


#### windowsexporter
- `windows_system_system_up_time`
- `windows_cpu_time_total`
- `windows_memory_available_bytes`
- `windows_os_visible_memory_bytes`
- `windows_memory_cache_bytes`
- `windows_memory_modified_page_list_bytes`
- `windows_memory_standby_cache_core_bytes`
- `windows_memory_standby_cache_normal_priority_bytes`
- `windows_memory_standby_cache_reserve_bytes`
- `windows_memory_swap_page_operations_total`
- `windows_logical_disk_read_seconds_total`
- `windows_logical_disk_write_seconds_total`
- `windows_logical_disk_size_bytes`
- `windows_logical_disk_free_bytes`
- `windows_net_bytes_total`
- `windows_net_packets_received_discarded_total`
- `windows_net_packets_outbound_discarded_total`
- `windows_container_available`
- `windows_container_cpu_usage_seconds_total`
- `windows_container_memory_usage_commit_bytes`
- `windows_container_memory_usage_private_working_set_bytes`
- `windows_container_network_receive_bytes_total`
- `windows_container_network_transmit_bytes_total`

#### windowskubeproxy
- `kubeproxy_sync_proxy_rules_duration_seconds`
- `kubeproxy_sync_proxy_rules_duration_seconds_bucket`
- `kubeproxy_sync_proxy_rules_duration_seconds_sum`
- `kubeproxy_sync_proxy_rules_duration_seconds_count`
- `rest_client_requests_total`
- `rest_client_request_duration_seconds`
- `rest_client_request_duration_seconds_bucket`
- `rest_client_request_duration_seconds_sum`
- `rest_client_request_duration_seconds_count`
- `process_resident_memory_bytes`
- `process_cpu_seconds_total`
- `go_goroutines`

#### networkobservabilityHubble
- See [Container Network Observability metrics](/azure/aks/advanced-network-observability-concepts#metrics).

#### networkobservabilityCilium
- See [Container Network Observability metrics](/azure/aks/advanced-network-observability-concepts#metrics).

#### controlplane-apiserver

- `apiserver_request_total`
- `apiserver_cache_list_fetched_objects_total`
- `apiserver_cache_list_returned_objects_total`
- `apiserver_flowcontrol_demand_seats_average`
- `apiserver_flowcontrol_current_limit_seats`
- `apiserver_request_sli_duration_seconds_bucket{le=+inf}`
- `apiserver_request_sli_duration_seconds_count`
- `apiserver_request_sli_duration_seconds_sum`
- `process_start_time_seconds`
- `apiserver_request_duration_seconds_bucket{le=+inf}`
- `apiserver_request_duration_seconds_count`
- `apiserver_request_duration_seconds_sum`
- `apiserver_storage_list_fetched_objects_total`
- `apiserver_storage_list_returned_objects_total`
- `apiserver_current_inflight_requests`

> [!NOTE]
> `apiserver_request_duration_seconds` and `apiserver_request_sli_duration_seconds` are histogram metrics which have high cardinality and all series are not collected by default. Only the sum and count are used for gathering the average latencies.

#### controlplane-cluster-autoscaler

- `rest_client_requests_total`
- `cluster_autoscaler_last_activity`
- `cluster_autoscaler_cluster_safe_to_autoscale`
- `cluster_autoscaler_scale_down_in_cooldown`
- `cluster_autoscaler_scaled_up_nodes_total`
- `cluster_autoscaler_unneeded_nodes_count`
- `cluster_autoscaler_unschedulable_pods_count`
- `cluster_autoscaler_nodes_count`
- `cloudprovider_azure_api_request_errors`
- `cloudprovider_azure_api_request_duration_seconds_bucket`
- `cloudprovider_azure_api_request_duration_seconds_count`

#### controlplane-node-auto-provisioning

- `karpenter_pods_state`
- `karpenter_nodes_created_total`
- `karpenter_nodes_terminated_total`
- `karpenter_nodeclaims_disrupted_total`
- `karpenter_voluntary_disruption_eligible_nodes`
- `karpenter_voluntary_disruption_decisions_total`

#### controlplane-kube-scheduler
- `scheduler_pending_pods`
- `scheduler_unschedulable_pods`
- `scheduler_pod_scheduling_attempts`
- `scheduler_queue_incoming_pods_total`
- `scheduler_preemption_attempts_total`
- `scheduler_preemption_victims`
- `scheduler_scheduling_attempt_duration_seconds`
- `scheduler_schedule_attempts_total`
- `scheduler_pod_scheduling_duration_seconds`

#### controlplane-kube-controller-manager
- `rest_client_request_duration_seconds`
- `rest_client_requests_total`
- `workqueue_depth`

#### controlplane-etcd
- `etcd_server_has_leader`
- `rest_client_requests_total`
- `etcd_mvcc_db_total_size_in_bytes`
- `etcd_mvcc_db_total_size_in_use_in_bytes`
- `etcd_server_slow_read_indexes_total`
- `etcd_server_slow_apply_total`
- `etcd_network_client_grpc_sent_bytes_total`
- `etcd_server_heartbeat_send_failures_total`


#### acstor-capacity-provisioner (job=acstor-capacity-provisioner)
- See [Azure Container Storage metrics](/azure/storage/container-storage/enable-monitoring#metrics-collected-for-default-targets).

#### acstor-metrics-exporter (job=acstor-metrics-exporter)
- See [Azure Container Storage metrics](/azure/storage/container-storage/enable-monitoring#metrics-collected-for-default-targets).


## Dashboards

The following default dashboards are automatically provisioned and configured by Azure Monitor managed service for Prometheus when you [link your Azure Monitor workspace to an Azure Managed Grafana instance](../essentials/azure-monitor-workspace-manage.md#link-a-grafana-workspace). They are provisioned in the specified Azure Grafana instance under the `Managed Prometheus` folder. These are the standard open source community dashboards for monitoring Kubernetes clusters with Prometheus and Grafana. 

- `Kubernetes / Compute Resources / Cluster`
- `Kubernetes / Compute Resources / Namespace (Pods)`
- `Kubernetes / Compute Resources / Node (Pods)`
- `Kubernetes / Compute Resources / Pod`
- `Kubernetes / Compute Resources / Namespace (Workloads)`
- `Kubernetes / Compute Resources / Workload`
- `Kubernetes / Kubelet`
- `Node Exporter / USE Method / Node`
- `Node Exporter / Nodes`
- `Kubernetes / Compute Resources / Cluster (Windows)`
- `Kubernetes / Compute Resources / Namespace (Windows)`
- `Kubernetes / Compute Resources / Pod (Windows)`
- `Kubernetes / USE Method / Cluster (Windows)`
- `Kubernetes / USE Method / Node (Windows)`

## Recording rules

The following default recording rules are automatically configured by Azure Monitor managed service for Prometheus when you [configure Prometheus metrics to be scraped from an Azure Kubernetes Service (AKS) cluster](kubernetes-monitoring-enable.md). Source code for these recording rules can be found in [this GitHub repository](https://aka.ms/azureprometheus-mixins). These are the standard open source recording rules used in the dashboards above.

- `cluster:node_cpu:ratio_rate5m`
- `namespace_cpu:kube_pod_container_resource_requests:sum`
- `namespace_cpu:kube_pod_container_resource_limits:sum`
- `:node_memory_MemAvailable_bytes:sum`
- `namespace_memory:kube_pod_container_resource_requests:sum`
- `namespace_memory:kube_pod_container_resource_limits:sum`
- `namespace_workload_pod:kube_pod_owner:relabel`
- `node_namespace_pod_container:container_cpu_usage_seconds_total:sum_irate`
- `cluster:namespace:pod_cpu:active:kube_pod_container_resource_requests`
- `cluster:namespace:pod_cpu:active:kube_pod_container_resource_limits`
- `cluster:namespace:pod_memory:active:kube_pod_container_resource_requests`
- `cluster:namespace:pod_memory:active:kube_pod_container_resource_limits`
- `node_namespace_pod_container:container_memory_working_set_bytes`
- `node_namespace_pod_container:container_memory_rss`
- `node_namespace_pod_container:container_memory_cache`
- `node_namespace_pod_container:container_memory_swap`
- `instance:node_cpu_utilisation:rate5m`
- `instance:node_load1_per_cpu:ratio`
- `instance:node_memory_utilisation:ratio`
- `instance:node_vmstat_pgmajfault:rate5m`
- `instance:node_network_receive_bytes_excluding_lo:rate5m`
- `instance:node_network_transmit_bytes_excluding_lo:rate5m`
- `instance:node_network_receive_drop_excluding_lo:rate5m`
- `instance:node_network_transmit_drop_excluding_lo:rate5m`
- `instance_device:node_disk_io_time_seconds:rate5m`
- `instance_device:node_disk_io_time_weighted_seconds:rate5m`
- `instance:node_num_cpu:sum`
- `node:windows_node:sum`
- `node:windows_node_num_cpu:sum`
- `:windows_node_cpu_utilisation:avg5m`
- `node:windows_node_cpu_utilisation:avg5m`
- `:windows_node_memory_utilisation:`
- `:windows_node_memory_MemFreeCached_bytes:sum`
- `node:windows_node_memory_totalCached_bytes:sum`
- `:windows_node_memory_MemTotal_bytes:sum`
- `node:windows_node_memory_bytes_available:sum`
- `node:windows_node_memory_bytes_total:sum`
- `node:windows_node_memory_utilisation:ratio`
- `node:windows_node_memory_utilisation:`
- `node:windows_node_memory_swap_io_pages:irate`
- `:windows_node_disk_utilisation:avg_irate`
- `node:windows_node_disk_utilisation:avg_irate`
- `node:windows_node_filesystem_usage:`
- `node:windows_node_filesystem_avail:`
- `:windows_node_net_utilisation:sum_irate`
- `node:windows_node_net_utilisation:sum_irate`
- `:windows_node_net_saturation:sum_irate`
- `node:windows_node_net_saturation:sum_irate`
- `windows_pod_container_available`
- `windows_container_total_runtime`
- `windows_container_memory_usage`
- `windows_container_private_working_set_usage`
- `windows_container_network_received_bytes_total`
- `windows_container_network_transmitted_bytes_total`
- `kube_pod_windows_container_resource_memory_request`
- `kube_pod_windows_container_resource_memory_limit`
- `kube_pod_windows_container_resource_cpu_cores_request`
- `kube_pod_windows_container_resource_cpu_cores_limit`
- `namespace_pod_container:windows_container_cpu_usage_seconds_total:sum_rate`

## Prometheus visualization recording rules

The following recording rules are automatically deployed to support Prometheus visualizations.

- `ux:cluster_pod_phase_count:sum`
- `ux:node_cpu_usage:sum_irate`
- `ux:node_memory_usage:sum`
- `ux:controller_pod_phase_count:sum`
- `ux:controller_container_count:sum`
- `ux:controller_workingset_memory:sum`
- `ux:controller_cpu_usage:sum_irate`
- `ux:controller_rss_memory:sum`
- `ux:controller_resource_limit:sum`
- `ux:controller_container_restarts:max`
- `ux:pod_container_count:sum`
- `ux:pod_cpu_usage:sum_irate`
- `ux:pod_workingset_memory:sum`
- `ux:pod_rss_memory:sum`
- `ux:pod_resource_limit:sum`
- `ux:pod_container_restarts:max`
- `ux:node_network_receive_drop_total:sum_irate`
- `ux:node_network_transmit_drop_total:sum_irate`

The following recording rules are required for Windows support. They're deployed automitcally but aren't enabled by default. See [enabling and disabling rule groups](../essentials/prometheus-rule-groups.md#disable-and-enable-rule-groups) to enable them. 

- `ux:node_cpu_usage_windows:sum_irate`
- `ux:node_memory_usage_windows:sum`
- `ux:controller_cpu_usage_windows:sum_irate`
- `ux:controller_workingset_memory_windows:sum`
- `ux:pod_cpu_usage_windows:sum_irate`
- `ux:pod_workingset_memory_windows:sum`

## Next steps

[Customize scraping of Prometheus metrics.](prometheus-metrics-scrape-configuration.md)
