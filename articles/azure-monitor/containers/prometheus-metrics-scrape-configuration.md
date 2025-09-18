---
title: Customize scraping of Prometheus metrics in Azure Monitor
description: Customize metrics scraping for a Kubernetes cluster with the metrics add-on in Azure Monitor.
ms.topic: how-to
ms.date: 09/10/2025
ms.reviewer: aul
---

# Customize collection of Prometheus metrics from your Kubernetes cluster

When you enable collection of Prometheus metrics from your Kubernetes cluster, it uses a [default collection](./prometheus-metrics-scrape-default.md) to determine what metrics to collect. This article describes how you can customize this collection to meet your specific monitoring requirements.

## ConfigMap

The following ConfigMap is used to configure scrape configuration and other settings for the metrics add-on. This ConfigMap doesn't exist by default in the cluster when Managed Prometheus is enabled. 

| ConfigMap | Description |
|:---|:---|
| [`ama-metrics-settings-configmap`](https://aka.ms/azureprometheus-addon-settings-configmap) | Includes the following basic settings.<br>- Cluster alias. Changes the value of the `cluster` label in every metric ingested from the cluster.<br>- Enable/disable default scrape targets. <br>- Enable pod annotation based scraping per namespace.<br>- Metric keep lists. Controls which metrics are allowed from each default target.<br>- Scrape intervals for predefined targets.<br>- Debug mode to identify missing metric issues. See [troubleshooting](prometheus-metrics-troubleshoot.md#debug-mode). |

Modify the settings in the ConfigMap based on the guidance below and then apply it using the following command: `kubectl apply -f .\ama-metrics-settings-configmap.yaml`. AMA-Metrics pods will pick them up and restart in 2-3 minutes to apply the configuration settings specified. 


## Enable and disable default targets
The following table has a list of all the default targets that the Azure Monitor metrics add-on can scrape by default and whether it's initially enabled. Default targets are scraped every 30 seconds. A replica is deployed to scrape cluster-wide targets such as kube-state-metrics. A DaemonSet is also deployed to scrape node-wide targets such as kubelet.

| Key | Type | Enabled | Pod | Description |
|-----|------|----------|----|-------------|
| kubelet | bool | `true` | Linux DaemonSet | Scrape kubelet in every node in the K8s cluster without any extra scrape config. |
| cadvisor | bool | `true` | Linux DaemonSet | Scrape cadvisor in every node in the K8s cluster without any extra scrape config.<br>Linux only. |
| kubestate | bool | `true` | Linux replica | Scrape kube-state-metrics in the K8s cluster (installed as a part of the add-on) without any extra scrape config. |
| nodeexporter | bool | `true` | Linux DaemonSet | Scrape node metrics without any extra scrape config.<br>Linux only. |
| coredns | bool | `false` | Linux replica | Scrape coredns service in the K8s cluster without any extra scrape config. |
| kubeproxy | bool | `false` | Linux DaemonSet | Scrape kube-proxy in every Linux node discovered in the K8s cluster without any extra scrape config.<br>Linux only. |
| apiserver | bool | `false` | Linux replica | Scrape the Kubernetes API server in the K8s cluster without any extra scrape config. |
| windowsexporter | bool | `false` | Windows DaemonSet | Scrape windows-exporter in every node in the K8s cluster without any extra scrape config.<br>Windows only. |
| windowskubeproxy | bool | `false` | Windows DaemonSet | Scrape windows-kube-proxy in every node in the K8s cluster without any extra scrape config.<br>Windows only. |
| prometheuscollectorhealth | bool | `false` | Linux replica | Scrape information about the prometheus-collector container, such as the amount and size of time series scraped. |

If you want to turn on the scraping of the default targets that aren't enabled by default, edit the [configmap](https://aka.ms/azureprometheus-addon-settings-configmap) `ama-metrics-settings-configmap` to update the targets listed under `default-scrape-settings-enabled` to `true`. Apply the configmap to your cluster.

## Enable pod annotation-based scraping
Add annotations to the pods in your cluster to scrape application pods without creating a custom Prometheus config. To enable scraping pods with specific annotations, add the regex for the namespace(s) of the pods with annotations you want to scrape to `podannotationnamespaceregex` in . For example, the following setting scrapes pods with annotations only in the namespaces `kube-system` and `my-namespace`:

```yaml
pod-annotation-based-scraping: |-
    podannotationnamespaceregex = "kube-system|my-namespace"
```

Add annotations to the `metadata` section of the pod definition. `prometheus.io/scrape: "true"` is required for the pod to be scraped, while `prometheus.io/path` and `prometheus.io/port` indicate the path and port that the metrics are hosted at on the pod. The annotations for a pod that is hosting metrics at `<pod IP>:8080/metrics` would be:

```yaml
metadata:   
  annotations:
    prometheus.io/scrape: 'true'
    prometheus.io/path: '/metrics'
    prometheus.io/port: '8080'
```
> [!WARNING]
> Scraping the pod annotations from many namespaces can generate a very large volume of metrics depending on the number of pods that have annotations.

## Customize metrics collected by default targets
Only minimal metrics are collected for default targets as described in [minimal-ingestion-profile](prometheus-metrics-scrape-configuration-minimal.md). To collect all metrics from default targets, set `minimalingestionprofile` to `false` and update the keep-lists under `default-targets-metrics-keep-list` for each target you want to change.

For example, `kubelet` is the metric filtering setting for the default target kubelet. Use the following script to filter *in* metrics collected for the default targets by using regex-based filtering.

```
kubelet = "metricX|metricY"
apiserver = "mymetric.*"
```

> [!NOTE]
> If you use quotation marks or backslashes in the regex, you need to escape them by using a backslash like the examples `"test\'smetric\"s\""` and `testbackslash\\*`.

If you want further customize default targets to change properties like collection frequency or labels, then disable that target by setting its value to `false`. Then create a custom job for the target. see [Customize scraping of Prometheus metrics in Azure Monitor](#configure-custom-prometheus-scrape-jobs).

### Cluster alias
The last part of the cluster's resource ID is appended to every time series to uniquely identifiy the data. For example, if the resource ID is `/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourcegroups/rg-name/providers/Microsoft.ContainerService/managedClusters/myclustername`, the cluster label is `myclustername`.

To override this cluster label, update the setting `cluster_alias` under `prometheus-collector-settings`. The new label also shows up in the cluster parameter dropdown in the Grafana dashboards instead of the default one.

> [!NOTE]
> Only alphanumeric characters are allowed. Any other characters are replaced with `_`. 
> If you are enabling recording and alerting rules, make sure to use the cluster alias name in the cluster name parameter of the rule onboarding template for the rules to work.

## Debug mode

> [!WARNING]
> This mode can affect performance and should only be enabled for a short time for debugging purposes.

To view every metric that's being scraped for debugging purposes, the metrics add-on agent can be configured to run in debug mode by updating the setting `enabled` to `true` under the `debug-mode` setting 


## Scrape interval settings

Update the duration in the setting `default-targets-scrape-interval-settings` to update the scrape interval settings for any target. Use the scrape interval format specified in [Configuration file](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#configuration-file) as in the following example:

```
default-targets-scrape-interval-settings: |-
    kubelet = "60s"
    coredns = "30s"
    cadvisor = "30s"
    kubeproxy = "30s"
    apiserver = "30s"
    kubestate = "30s"
    nodeexporter = "30s"
    windowsexporter = "30s"
    windowskubeproxy = "30s"
    kappiebasic = "30s"
    prometheuscollectorhealth = "30s"
    podannotations = "30s"
```


## Next steps

[Setup Alerts on Prometheus metrics](./container-insights-metric-alerts.md)<br>
[Query Prometheus metrics](../essentials/prometheus-grafana.md)<br>
[Learn more about collecting Prometheus metrics](../essentials/prometheus-metrics-overview.md)
