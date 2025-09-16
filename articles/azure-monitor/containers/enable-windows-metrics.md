---
title: Enable Windows metrics collection in AKS clusters (preview)
description: Learn how to enable Windows metrics collection in AKS clusters (preview).
ms.topic: article
ms.custom: devx-track-azurecli, linux-related-content
ms.reviewer: aul
ms.date: 08/25/2025
---


# Enable Windows metrics collection in AKS clusters (preview)

Windows metric collection is enabled for AKS clusters as of version 6.4.0-main-02-22-2023-3ee44b9e of the Managed Prometheus addon container. Onboarding to the Azure Monitor Metrics add-on enables the Windows DaemonSet pods to start running on your node pools. Both Windows Server 2019 and Windows Server 2022 are supported. Follow these steps to enable the pods to collect metrics from your Windows node pools.

> [!NOTE]
> There's no CPU/Memory limit in `windows-exporter-daemonset.yaml` so it may over-provision the Windows nodes. For details see [Resource reservation](https://kubernetes.io/docs/concepts/configuration/windows-resource-management/#resource-reservation)
>   
> As you deploy workloads, set resource memory and CPU limits on containers. This also subtracts from NodeAllocatable and helps the cluster-wide scheduler in determining which pods to place on which nodes.
> Scheduling pods without limits may over-provision the Windows nodes and in extreme cases can cause the nodes to become unhealthy.

## Install Windows exporter

Manually install windows-exporter on AKS nodes to access Windows metrics by deploying the [windows-exporter-daemonset YAML](https://github.com/prometheus-community/windows_exporter/blob/master/kubernetes/windows-exporter-daemonset.yaml) file. Enable the following collectors:

   * `[defaults]`
   * `container`
   * `memory`
   * `process`
   * `cpu_info`
   
   For more collectors, see [Prometheus exporter for Windows metrics](https://github.com/prometheus-community/windows_exporter#windows_exporter).

   Deploy the [windows-exporter-daemonset YAML](https://github.com/prometheus-community/windows_exporter/blob/master/kubernetes/windows-exporter-daemonset.yaml) file. If there are any taints applied in the node, you need to apply the appropriate tolerations.

   ```
       kubectl apply -f windows-exporter-daemonset.yaml
   ```
## Apply ConfigMap

Apply the [ama-metrics-settings-configmap](https://github.com/Azure/prometheus-collector/blob/main/otelcollector/configmaps/ama-metrics-settings-configmap.yaml) to your cluster. Set the `windowsexporter` and `windowskubeproxy` Booleans to `true`. For more information, see [Metrics add-on settings configmap](./prometheus-metrics-scrape-configuration.md#metrics-add-on-settings-configmap).

## Enable recording rules

Enable the recording rules that are required for the out-of-the-box dashboards:

   * If onboarding using the CLI, include the option `--enable-windows-recording-rules`.
   * If onboarding using an ARM template, Bicep, or Azure Policy, set `enableWindowsRecordingRules` to `true` in the parameters file.
   * If the cluster is already onboarded, use [this ARM template](https://github.com/Azure/prometheus-collector/blob/main/AddonArmTemplate/WindowsRecordingRuleGroupTemplate/WindowsRecordingRules.json) and [this parameter file](https://github.com/Azure/prometheus-collector/blob/main/AddonArmTemplate/WindowsRecordingRuleGroupTemplate/WindowsRecordingRulesParameters.json) to create the rule groups. This adds the required recording rules and isn't an ARM operation on the cluster and doesn't impact current monitoring state of the cluster.

## Add scrape job for Arc-enabled clusters

If you're enabling Managed Prometheus for an ARC-enabled cluster, you can configure Managed Prometheus that is running on a Linux node within the cluster to scrape metrics from endpoints running on the Windows nodes. Add the following scrape job to [ama-metrics-prometheus-config-configmap.yaml](https://aka.ms/ama-metrics-prometheus-config-configmap) and apply the configmap to your cluster.

```yaml
  scrape_configs:
    - job_name: windows-exporter
      scheme: http
      scrape_interval: 30s
      label_limit: 63
      label_name_length_limit: 511
      label_value_length_limit: 1023
      tls_config:
        ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
        insecure_skip_verify: true
      bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
      kubernetes_sd_configs:
      - role: node
      relabel_configs:
      - source_labels: [__meta_kubernetes_node_name]
        target_label: instance
      - action: keep
        source_labels: [__meta_kubernetes_node_label_kubernetes_io_os]
        regex: windows
      - source_labels:
        - __address__
        action: replace
        target_label: __address__
        regex: (.+?)(\:\d+)?
        replacement: $$1:9182
```

## Differences between Windows and Linux clusters

The main differences in monitoring a Windows Server cluster compared to a Linux cluster include:

- Windows doesn't have a Memory RSS metric. As a result, it isn't available for Windows nodes and containers. The [Working Set](/windows/win32/memory/working-set) metric is available.
- Disk storage capacity information isn't available for Windows nodes.
- Only pod environments are monitored, not Docker environments.
- With the preview release, a maximum of 30 Windows Server containers are supported. This limitation doesn't apply to Linux containers.

>[!NOTE]
> Container insights support for the Windows Server 2022 operating system is in preview.


The containerized Linux agent (replicaset pod) makes API calls to all the Windows nodes on Kubelet secure port (10250) within the cluster to collect node and container performance-related metrics. Kubelet secure port (:10250) should be opened in the cluster's virtual network for both inbound and outbound for Windows node and container performance-related metrics collection to work.

If you have a Kubernetes cluster with Windows nodes, review and configure the network security group and network policies to make sure the Kubelet secure port (:10250) is open for both inbound and outbound in the cluster's virtual network.

```AzureCLI
kubectl apply -f ama-metrics-prometheus-config-configmap.yaml
```