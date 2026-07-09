---
author: bandersmsft
ms.author: banders
ms.service: azure-monitor
ms.subservice: containers
ms.topic: include
ms.date: 07/08/2026
---

Windows metric collection is enabled starting with version 6.4.0-main-02-22-2023-3ee44b9e of the Managed Prometheus add-on container. When you onboard to the Azure Monitor Metrics add-on, the Windows DaemonSet pods start running on your node pools. Both Windows Server 2019 and Windows Server 2022 are supported. Follow these steps to enable the pods to collect metrics from your Windows node pools.

> [!NOTE]
> The `windows-exporter-daemonset.yaml` file doesn't set CPU or memory limits, so it might overprovision the Windows nodes. For more information, see [Resource reservation](https://kubernetes.io/docs/concepts/configuration/windows-resource-management/#resource-reservation).
>
> As you deploy workloads, set resource memory and CPU limits on containers. This setting also subtracts from NodeAllocatable and helps the cluster-wide scheduler determine which pods to place on which nodes. Scheduling pods without limits might overprovision the Windows nodes and, in extreme cases, can cause the nodes to become unhealthy.

### Install Windows exporter

To access Windows metrics, manually install the windows-exporter on your cluster nodes by deploying the [windows-exporter-daemonset YAML](https://github.com/prometheus-community/windows_exporter/blob/master/kubernetes/windows-exporter-daemonset.yaml) file. Enable the following collectors. For more collectors, see [Prometheus exporter for Windows metrics](https://github.com/prometheus-community/windows_exporter#windows_exporter).

- `[defaults]`
  - `container`
  - `memory`
  - `process`
  - `cpu_info`

Deploy the [windows-exporter-daemonset YAML](https://github.com/prometheus-community/windows_exporter/blob/master/kubernetes/windows-exporter-daemonset.yaml) file. If the node has taints, you need to apply the appropriate tolerations.

```bash
kubectl apply -f windows-exporter-daemonset.yaml
```

### Enable Windows metrics

Set the `windowsexporter` and `windowskubeproxy` Booleans to `true` in your metrics settings ConfigMap and apply it to the cluster. See [Customize collection of Prometheus metrics from your Kubernetes cluster using ConfigMap](../prometheus-metrics-scrape-configuration.md).

### Enable recording rules

Enable the recording rules that are required for the out-of-the-box dashboards:

- If you're onboarding by using CLI, include the option `--enable-windows-recording-rules`.
- If you're onboarding by using an ARM template, Bicep, or Azure Policy, set `enableWindowsRecordingRules` to `true` in the parameters file.
- If the cluster is already onboarded, use [this ARM template](https://github.com/Azure/prometheus-collector/blob/main/AddonArmTemplate/WindowsRecordingRuleGroupTemplate/WindowsRecordingRules.json) and [this parameter file](https://github.com/Azure/prometheus-collector/blob/main/AddonArmTemplate/WindowsRecordingRuleGroupTemplate/WindowsRecordingRulesParameters.json) to create the rule groups. This process adds the required recording rules and isn't an ARM operation on the cluster. It doesn't impact the current monitoring state of the cluster.
