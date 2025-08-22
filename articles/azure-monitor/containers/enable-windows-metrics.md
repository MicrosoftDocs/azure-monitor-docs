
---
title: Enable monitoring for Kubernetes clusters
description: Learn how to enable Windows metrics collection in AKS clusters (preview).
ms.custom: devx-track-azurecli, linux-related-content
ms.reviewer: aul
ms.date: 03/11/2024
---


# Enable Windows metrics collection in AKS clusters (preview)

Windows metric collection has been enabled for AKS clusters as of version 6.4.0-main-02-22-2023-3ee44b9e of the Managed Prometheus addon container. Onboarding to the Azure Monitor Metrics add-on enables the Windows DaemonSet pods to start running on your node pools. Both Windows Server 2019 and Windows Server 2022 are supported. Follow these steps to enable the pods to collect metrics from your Windows node pools.

> [!NOTE]
> There is no CPU/Memory limit in `windows-exporter-daemonset.yaml` so it may over-provision the Windows nodes. For details see [Resource reservation](https://kubernetes.io/docs/concepts/configuration/windows-resource-management/#resource-reservation)
>   
> As you deploy workloads, set resource memory and CPU limits on containers. This also subtracts from NodeAllocatable and helps the cluster-wide scheduler in determining which pods to place on which nodes.
> Scheduling pods without limits may over-provision the Windows nodes and in extreme cases can cause the nodes to become unhealthy.



1. Manually install windows-exporter on AKS nodes to access Windows metrics by deploying the [windows-exporter-daemonset YAML](https://github.com/prometheus-community/windows_exporter/blob/master/kubernetes/windows-exporter-daemonset.yaml) file. Enable the following collectors:

   * `[defaults]`
   * `container`
   * `memory`
   * `process`
   * `cpu_info`
   
   For more collectors, please see [Prometheus exporter for Windows metrics](https://github.com/prometheus-community/windows_exporter#windows_exporter).

   Deploy the [windows-exporter-daemonset YAML](https://github.com/prometheus-community/windows_exporter/blob/master/kubernetes/windows-exporter-daemonset.yaml) file. Note that if there are any taints applied in the node, you will need to apply the appropriate tolerations.

   ```
       kubectl apply -f windows-exporter-daemonset.yaml
   ```

1. Apply the [ama-metrics-settings-configmap](https://github.com/Azure/prometheus-collector/blob/main/otelcollector/configmaps/ama-metrics-settings-configmap.yaml) to your cluster. Set the `windowsexporter` and `windowskubeproxy` Booleans to `true`. For more information, see [Metrics add-on settings configmap](./prometheus-metrics-scrape-configuration.md#metrics-add-on-settings-configmap).
1. Enable the recording rules that are required for the out-of-the-box dashboards:

   * If onboarding using the CLI, include the option `--enable-windows-recording-rules`.
   * If onboarding using an ARM template, Bicep, or Azure Policy, set `enableWindowsRecordingRules` to `true` in the parameters file.
   * If the cluster is already onboarded, use [this ARM template](https://github.com/Azure/prometheus-collector/blob/main/AddonArmTemplate/WindowsRecordingRuleGroupTemplate/WindowsRecordingRules.json) and [this parameter file](https://github.com/Azure/prometheus-collector/blob/main/AddonArmTemplate/WindowsRecordingRuleGroupTemplate/WindowsRecordingRulesParameters.json) to create the rule groups. This will add the required recording rules and is not an ARM operation on the cluster and does not impact current monitoring state of the cluster.

1. [Only for Windows nodes in ARC-enabled clusters] If you are enabling Managed Prometheus for an ARC-enabled cluster, you can configure Managed Prometheus that is running on a Linux node within the cluster to scrape metrics from endpoints running on the Windows nodes. Add the following scrape job to [ama-metrics-prometheus-config-configmap.yaml](https://aka.ms/ama-metrics-prometheus-config-configmap) and apply the configmap to your cluster.

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

```AzureCLI
kubectl apply -f ama-metrics-prometheus-config-configmap.yaml
```
