---
title: Customize scraping of Prometheus metrics in Azure Monitor using ConfigMap
description: Customize metrics scraping for a Kubernetes cluster with the metrics add-on in Azure Monitor.
ms.topic: how-to
ms.date: 09/10/2025
ms.reviewer: aul
---

# Customize collection of Prometheus metrics from your Kubernetes cluster using ConfigMap

When you enable collection of Prometheus metrics from your Kubernetes cluster, it uses a [default collection](./prometheus-metrics-scrape-default.md) to determine what metrics to collect. This article describes how you can customize this collection to meet your specific monitoring requirements.

## ConfigMap

The following ConfigMap is used to configure scrape configuration and other settings for the metrics add-on. This ConfigMap doesn't exist by default in the cluster when Managed Prometheus is enabled. 

| ConfigMap | Description |
|:---|:---|
| [`ama-metrics-settings-configmap`](https://aka.ms/azureprometheus-addon-settings-configmap) | Includes the following basic settings.<br>- Cluster alias. Changes the value of the `cluster` label in every metric ingested from the cluster.<br>- Enable/disable default scrape targets. <br>- Enable pod annotation based scraping per namespace.<br>- Metric keep lists. Controls which metrics are allowed from each default target.<br>- Scrape intervals for predefined targets.<br>- Debug mode to identify missing metric issues. See [troubleshooting](prometheus-metrics-troubleshoot.md#debug-mode). |

Modify the settings in the ConfigMap based on the guidance below and then apply it using the following command. AMA-Metrics pods will pick them up and restart in 2-3 minutes to apply the configuration settings specified. 

```bash
kubectl apply -f .\ama-metrics-settings-configmap.yaml
```


## Enable and disable default targets
[Default Prometheus metrics configuration in Azure Monitor](./prometheus-metrics-scrape-default.md) lists the default targets and metrics that are collected by default from your Kubernetes cluster. To enable/disable scraping of any of these targets, update the setting for the target in the `default-scrape-settings-enabled` section of the ConfigMap to `true` or `false`.

For example, to enable scraping of `coredns` which is disabled by default, update the setting as follows:

```yaml
default-scrape-settings-enabled: |-
    kubelet = true
    coredns = true
    cadvisor = true
    kubeproxy = false
    ...
```

## Scrape interval settings
The default scrape interval for all default targets is 30 seconds. To modify this interval for any target, you can update the setting in the `default-targets-scrape-interval-settings` section of the ConfigMap.

For example, to change the scrape interval for `kubelet` to 60 seconds, update the setting as follows:

```yaml
default-targets-scrape-interval-settings: |-
    kubelet = "60s"
    coredns = "30s"
    cadvisor = "30s"
    ...
```

## Enable pod annotation-based scraping
Add annotations to the pods in your cluster to scrape application pods without creating a custom Prometheus config. To enable scraping pods with specific annotations, add the regex for the namespace(s) of the pods with annotations you want to scrape to `podannotationnamespaceregex` in the `podannotationnamespaceregex` section of the ConfigMap . 

For example, the following setting scrapes pods with annotations only in the namespaces `kube-system` and `my-namespace`:

```yaml
pod-annotation-based-scraping: |-
    podannotationnamespaceregex = "kube-system|my-namespace"
```

Add annotations to the `metadata` section of the ConfigMap. `prometheus.io/scrape: "true"` is required for the pod to be scraped, while `prometheus.io/path` and `prometheus.io/port` indicate the path and port that the metrics are hosted at on the pod. The following sample defines annotations for a pod that is hosting metrics at `<pod IP>:8080/metrics`.

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
Only minimal metrics are collected for default targets as described in [Minimal ingestion profile for Prometheus metrics in Azure Monitor](prometheus-metrics-scrape-configuration-minimal.md). To collect all metrics from default targets, set `minimalingestionprofile` to `false` in the `default-targets-metrics-keep-list` section of the ConfigMap. 

```yaml
minimalingestionprofile = false
```

Alternatively, you can add metrics to be collected for any default target by updating its keep-lists under `default-targets-metrics-keep-list`.

For example, `kubelet` is the metric filtering setting for the default target kubelet. Use the following script to filter in metrics collected for the default targets by using regex-based filtering.

```bash
kubelet = "metricX|metricY"
apiserver = "mymetric.*"
```

> [!NOTE]
> If you use quotation marks or backslashes in the regex, you need to escape them by using a backslash like the examples `"test\'smetric\"s\""` and `testbackslash\\*`.

If you want to further customize default targets to change properties like collection frequency or labels, then disable that target by setting its value to `false`. Then create a custom job for the target as described in [Customize scraping of Prometheus metrics in Azure Monitor](./prometheus-metrics-scrape-configmap.md).

### Cluster alias
The last part of the cluster's resource ID is appended to every time series to uniquely identify the data. For example, if the resource ID is `/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourcegroups/rg-name/providers/Microsoft.ContainerService/managedClusters/myclustername`, the cluster label is `myclustername`. To override this cluster label, update the setting `cluster_alias` under `prometheus-collector-settings`. 

> [!NOTE]
> Only alphanumeric characters are allowed. Any other characters are replaced with `_`. 
> If you are enabling recording and alerting rules, make sure to use the cluster alias name in the cluster name parameter of the rule onboarding template for the rules to work.

```yml
  prometheus-collector-settings: |-
    cluster_alias = ""
```


## Debug mode

To view every metric that's being scraped for debugging purposes, the metrics add-on agent can be configured to run in debug mode by updating the setting `enabled` to `true` under the `debug-mode` setting 

> [!WARNING]
> This mode can affect performance and should only be enabled for a short time for debugging purposes.




## Next steps

[Setup Alerts on Prometheus metrics](./container-insights-metric-alerts.md)<br>
[Query Prometheus metrics](../essentials/prometheus-grafana.md)<br>
[Learn more about collecting Prometheus metrics](../essentials/prometheus-metrics-overview.md)
