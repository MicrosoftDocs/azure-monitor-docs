---
title: Customize scraping of Prometheus metrics in Azure Monitor
description: Customize metrics scraping for a Kubernetes cluster with the metrics add-on in Azure Monitor.
ms.topic: conceptual
ms.date: 2/28/2024
ms.reviewer: aul
---

# Customize scraping of Prometheus metrics in Azure Monitor managed service for Prometheus

This article provides instructions on customizing metrics scraping for a Kubernetes cluster with the [metrics addon](kubernetes-monitoring-enable.md#enable-prometheus-and-grafana) in Azure Monitor.

## Configmaps

Four different configmaps can be configured to provide scrape configuration and other settings for the metrics add-on. All config-maps should be applied to `kube-system` namespace for any cluster.

> [!NOTE]
> None of the four configmaps exist by default in the cluster when Managed Prometheus is enabled. Depending on what needs to be customized, you need to deploy any or all of these four configmaps with the same name specified, in `kube-system` namespace. AMA-Metrics pods will pick up these configmaps after you deploy them to `kube-system` namespace, and will restart in 2-3 minutes to apply the configuration settings specified in the configmap(s). 


1. [`ama-metrics-settings-configmap`](https://aka.ms/azureprometheus-addon-settings-configmap)
   This config map has below simple settings that can be configured. You can take the configmap from the above git hub repo, change the settings are required and apply/deploy the configmap to `kube-system` namespace for your cluster
      * cluster alias (to change the value of `cluster` label in every time-series/metric that's ingested from a cluster)
      * enable/disable default scrape targets - Turn ON/OFF default scraping based on targets. Scrape configuration for these default targets are already pre-defined/built-in
      * enable pod annotation based scraping per namespace
      * metric keep-lists - this setting is used to control which metrics are listed to be allowed from each default target and to change the default behavior
      * scrape intervals for default/pre-definetargets. `30 secs` is the default scrape frequency and it can be changed per default target using this configmap
      * debug-mode - turning this ON helps to debug missing metric/ingestion issues - see more on [troubleshooting](prometheus-metrics-troubleshoot.md#debug-mode)
2. [`ama-metrics-prometheus-config`](https://aka.ms/azureprometheus-addon-rs-configmap)
   This config map can be used to provide Prometheus scrape config for addon replica. Addon runs a singleton replica, and any cluster level services can be discovered and scraped by providing scrape jobs in this configmap. You can take the sample configmap from the above git hub repo, add scrape jobs that you  would need and apply/deploy the config map to `kube-system` namespace for your cluster.
   **Although this is supported, please note that the recommended way of scraping custom targets is using [custom resources](prometheus-metrics-scrape-configuration.md#custom-resource-definitions)**
3. [`ama-metrics-prometheus-config-node`](https://aka.ms/azureprometheus-addon-ds-configmap) (**Advanced**)
    This config map can be used to provide Prometheus scrape config for addon DaemonSet that runs on every **Linux** node in the cluster, and any node level targets on each node can be scraped by providing scrape jobs in this configmap. When you use this configmap, you can use `$NODE_IP` variable in your scrape config, which gets substituted by corresponding  node's ip address in DaemonSet pod running on each node. This way you get access to scrape anything that runs on that node from the metrics addon DaemonSet. **Please be careful when you use discoveries in scrape config in this node level config map, as every node in the cluster will setup & discover the target(s) and will collect redundant metrics**.
    You can take the sample configmap from the above git hub repo, add scrape jobs that you  would need and apply/deploy the config map to `kube-system` namespace for your cluster
4. [`ama-metrics-prometheus-config-node-windows`](https://aka.ms/azureprometheus-addon-ds-configmap-windows) (**Advanced**)
    This config map can be used to provide Prometheus scrape config for addon DaemonSet that runs on every **Windows** node in the cluster, and node level targets on each node can be scraped by providing scrape jobs in this configmap. When you use this configmap, you can use `$NODE_IP` variable in your scrape config, which will be substituted by corresponding  node's ip address in DaemonSet pod running on each node. This way you get access to scrape anything that runs on that node from the metrics addon DaemonSet. **Please be careful when you use discoveries in scrape config in this node level config map, as every node in the cluster will setup & discover the target(s) and will collect redundant metrics**.
    You can take the sample configmap from the above git hub repo, add scrape jobs that you  would need and apply/deploy the config map to `kube-system` namespace for your cluster

## Custom Resource Definitions
The Azure Monitor metrics add-on supports scraping Prometheus metrics using Prometheus - Pod Monitors and Service Monitors, similar to the OSS Prometheus operator. Enabling the add-on will deploy the Pod and Service Monitor custom resource definitions to allow you to create your own custom resources. 
Follow the instructions to [create and apply custom resources](prometheus-metrics-scrape-crd.md) on your cluster.

## Metrics add-on settings configmap

The [ama-metrics-settings-configmap](https://aka.ms/azureprometheus-addon-settings-configmap) can be downloaded, edited, and applied to the cluster to customize the out-of-the-box features of the metrics add-on.

### Enable and disable default targets
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

### Enable pod annotation-based scraping
To scrape application pods without needing to create a custom Prometheus config, annotations can be added to the pods. The annotation `prometheus.io/scrape: "true"` is required for the pod to be scraped. The annotations `prometheus.io/path` and `prometheus.io/port` indicate the path and port that the metrics are hosted at on the pod. The annotations for a pod that is hosting metrics at `<pod IP>:8080/metrics` would be:

```yaml
metadata:   
  annotations:
    prometheus.io/scrape: 'true'
    prometheus.io/path: '/metrics'
    prometheus.io/port: '8080'
```

Scraping these pods with specific annotations is disabled by default. To enable, in the `ama-metrics-settings-configmap`, add the regex for the namespace(s) of the pods with annotations you wish to scrape as the value of the field `podannotationnamespaceregex`.

For example, the following setting scrapes pods with annotations only in the namespaces `kube-system` and `my-namespace`:

```yaml
pod-annotation-based-scraping: |-
    podannotationnamespaceregex = "kube-system|my-namespace"
```

> [!WARNING]
> Scraping the pod annotations from many namespaces can generate a very large volume of metrics depending on the number of pods that have annotations.

### Customize metrics collected by default targets
By default, for all the default targets, only minimal metrics used in the default recording rules, alerts, and Grafana dashboards are ingested as described in [minimal-ingestion-profile](prometheus-metrics-scrape-configuration-minimal.md). To collect all metrics from default targets, update the keep-lists in the settings configmap under `default-targets-metrics-keep-list`, and set `minimalingestionprofile` to `false`.

To allowlist more metrics in addition to default metrics that are listed to be allowed, for any default targets, edit the settings under `default-targets-metrics-keep-list` for the corresponding job you want to change.

For example, `kubelet` is the metric filtering setting for the default target kubelet. Use the following script to filter *in* metrics collected for the default targets by using regex-based filtering.

```
kubelet = "metricX|metricY"
apiserver = "mymetric.*"
```

> [!NOTE]
> If you use quotation marks or backslashes in the regex, you need to escape them by using a backslash like the examples `"test\'smetric\"s\""` and `testbackslash\\*`.

To further customize the default jobs to change properties like collection frequency or labels, disable the corresponding default target by setting the configmap value for the target to `false`. Then apply the job by using a custom configmap. For details on custom configuration, see [Customize scraping of Prometheus metrics in Azure Monitor](prometheus-metrics-scrape-configuration.md#configure-custom-prometheus-scrape-jobs).

### Cluster alias
The cluster label appended to every time series scraped uses the last part of the full AKS cluster's Azure Resource Manager resource ID. For example, if the resource ID is `/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourcegroups/rg-name/providers/Microsoft.ContainerService/managedClusters/myclustername`, the cluster label is `myclustername`.

To override the cluster label in the time series scraped, update the setting `cluster_alias` to any string under `prometheus-collector-settings` in the [configmap](https://aka.ms/azureprometheus-addon-settings-configmap) `ama-metrics-settings-configmap`. You can create this configmap if it doesn't exist in the cluster or you can edit the existing one if it already exists in your cluster.

The new label also shows up in the cluster parameter dropdown in the Grafana dashboards instead of the default one.

> [!NOTE]
> Only alphanumeric characters are allowed. Any other characters are replaced with `_`. This change is to ensure that different components that consume this label adhere to the basic alphanumeric convention.
> If you are enabling recording and alerting rules, please make sure to use the cluster alias name in the cluster name parameter of the rule onboarding template for the rules to work.

### Debug mode

> [!WARNING]
> This mode can affect performance and should only be enabled for a short time for debugging purposes.

To view every metric that's being scraped for debugging purposes, the metrics add-on agent can be configured to run in debug mode by updating the setting `enabled` to `true` under the `debug-mode` setting in the [configmap](https://aka.ms/azureprometheus-addon-settings-configmap) `ama-metrics-settings-configmap`. You can either create this configmap or edit an existing one. For more information, see the [Debug mode section in Troubleshoot collection of Prometheus metrics](prometheus-metrics-troubleshoot.md#debug-mode).

### Scrape interval settings
To update the scrape interval settings for any target, you can update the duration in the setting `default-targets-scrape-interval-settings` for that target in the [configmap](https://aka.ms/azureprometheus-addon-settings-configmap) `ama-metrics-settings-configmap`. You have to set the scrape intervals in the correct format specified in [this website](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#configuration-file). Otherwise, the default value of 30 seconds is applied to the corresponding targets. For example - If you want to update the scrape interval for the `kubelet` job to `60s` then you can update the following section in the YAML:

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
and apply the YAML using the following command: `kubectl apply -f .\ama-metrics-settings-configmap.yaml`

## Configure custom Prometheus scrape jobs

You can scrape Prometheus metrics using Prometheus - Pod Monitors and Service Monitors(**Recommended**), similar to the OSS Prometheus operator.
Follow the instructions to [create and apply custom resources](prometheus-metrics-scrape-crd.md) on your cluster.

Additionally, you can follow the instructions to [create, validate, and apply the configmap](prometheus-metrics-scrape-validate.md) for your cluster.
The configuration format is similar to [Prometheus configuration file](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#configuration-file). 

## Prometheus configuration tips and examples

Learn some tips from examples in this section.

### [Configuration using CRD for custom scrape config](#tab/CRDConfig)
Use the [Pod and Service Monitor templates](https://github.com/Azure/prometheus-collector/tree/main/otelcollector/customresources) and follow the API specification to create your custom resources([PodMonitor](https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/api.md#podmonitor) and [Service Monitor](https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/api.md#monitoring.coreos.com/v1.ServiceMonitor)). **Note** that the only change required to the existing OSS CRs for being picked up by the Managed Prometheus is the API group - **azmonitoring.coreos.com/v1**. See [here](prometheus-metrics-scrape-crd.md) to learn more


### [Configuration file for custom scrape config](#tab/ConfigFile)

The configuration format is the same as the [Prometheus configuration file](https://aka.ms/azureprometheus-promioconfig). Currently, the following sections are supported:

```yaml
global:
  scrape_interval: <duration>
  scrape_timeout: <duration>
  external_labels:
    <labelname1>: <labelvalue>
    <labelname2>: <labelvalue>
scrape_configs:
  - <job-x>
  - <job-y>
```

Any other unsupported sections must be removed from the config before they're applied as a configmap. Otherwise, the custom configuration fails validation and isn't applied.

See the [Apply config file](prometheus-metrics-scrape-validate.md#deploy-config-file-as-configmap) section to create a configmap from the Prometheus config.

---

> [!NOTE]
> When custom scrape configuration fails to apply because of validation errors, default scrape configuration continues to be used.

## Global settings
The configuration format for global settings is the same as supported by [OSS prometheus configuration](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#configuration-file) 

```yaml
global:
  scrape_interval: <duration>
  scrape_timeout: <duration>
  external_labels:
    <labelname1>: <labelvalue>
    <labelname2>: <labelvalue>
scrape_configs:
  - <job-x>
  - <job-y>
```
The settings provided in the global section apply to all scrape jobs (both jobs in Configmap and Custom resources) but are overridden if they are specified in the individual jobs.

> [!NOTE]
> If you want to use global settings that apply to all the scrape jobs, and only have [Custom Resources](prometheus-metrics-scrape-crd.md) you would still need to create a configmap with just the global settings(Settings for each of these in the custom resources will override the ones in the global section)


## Scrape configs
### [Scrape Configs using CRD](#tab/CRDScrapeConfig)
Currently, the supported methods of target discovery for custom resources are pod and service monitor

#### Pod and Service Monitors
Targets discovered using pod and service monitors have different `__meta_*` labels depending on what monitor is used. You can use the labels in the `relabelings` section to filter targets or replace labels for the targets.

See the [Pod and Service Monitor examples](https://github.com/Azure/prometheus-collector/tree/main/otelcollector/deploy/example-custom-resources) of pod and service monitors.

### Relabelings
The `relabelings` section is applied at the time of target discovery and applies to each target for the job. The following examples show ways to use `relabelings`.

#### Add a label
Add a new label called `example_label` with the value `example_value` to every metric of the job. Use `__address__` as the source label only because that label always exists and adds the label for every target of the job.

```yaml
relabelings:
- sourceLabels: [__address__]
  targetLabel: example_label
  replacement: 'example_value'
```

#### Use Pod or Service Monitor labels

Targets discovered using pod and service monitors have different `__meta_*` labels depending on what monitor is used. The `__*` labels are dropped after discovering the targets. To filter by using them at the metrics level, first keep them using `relabelings` by assigning a label name. Then use `metricRelabelings` to filter.

```yaml
# Use the kubernetes namespace as a label called 'kubernetes_namespace'
relabelings:
- sourceLabels: [__meta_kubernetes_namespace]
  action: replace
  targetLabel: kubernetes_namespace

# Keep only metrics with the kubernetes namespace 'default'
metricRelabelings:
- sourceLabels: [kubernetes_namespace]
  action: keep
  regex: 'default'
```

#### Job and instance relabeling

You can change the `job` and `instance` label values based on the source label, just like any other label.

```yaml
# Replace the job name with the pod label 'k8s app'
relabelings:
- sourceLabels: [__meta_kubernetes_pod_label_k8s_app]
  targetLabel: job

# Replace the instance name with the node name. This is helpful to replace a node IP
# and port with a value that is more readable
relabelings:
- sourceLabels: [__meta_kubernetes_node_name]]
  targetLabel: instance
```

> [!NOTE]
> If you have relabeling configs, ensure that the relabeling does not filter out the targets, and the labels configured correctly match the targets.

### Metric Relabelings

Metric relabelings are applied after scraping and before ingestion. Use the `metricRelabelings` section to filter metrics after scraping. The following examples show how to do so.

#### Drop metrics by name

```yaml
# Drop the metric named 'example_metric_name'
metricRelabelings:
- sourceLabels: [__name__]
  action: drop
  regex: 'example_metric_name'
```

#### Keep only certain metrics by name

```yaml
# Keep only the metric named 'example_metric_name'
metricRelabelings:
- sourceLabels: [__name__]
  action: keep
  regex: 'example_metric_name'
```

```yaml
# Keep only metrics that start with 'example_'
metricRelabelings:
- sourceLabels: [__name__]
  action: keep
  regex: '(example_.*)'
```

#### Rename metrics
Metric renaming isn't supported.

#### Filter metrics by labels

```yaml
# Keep metrics only where example_label = 'example'
metricRelabelings:
- sourceLabels: [example_label]
  action: keep
  regex: 'example'
```

```yaml
# Keep metrics only if `example_label` equals `value_1` or `value_2`
metricRelabelings:
- sourceLabels: [example_label]
  action: keep
  regex: '(value_1|value_2)'
```

```yaml
# Keep metrics only if `example_label_1 = value_1` and `example_label_2 = value_2`
metricRelabelings:
- sourceLabels: [example_label_1, example_label_2]
  separator: ';'
  action: keep
  regex: 'value_1;value_2'
```

```yaml
# Keep metrics only if `example_label` exists as a label
metricRelabelings:
- sourceLabels: [example_label_1]
  action: keep
  regex: '.+'
```


### [Scrape Configs using Config file](#tab/ConfigFileScrapeConfig)
Currently, the supported methods of target discovery for a [scrape config](https://aka.ms/azureprometheus-promioconfig-scrape) are either [`static_configs`](https://aka.ms/azureprometheus-promioconfig-static) or [`kubernetes_sd_configs`](https://aka.ms/azureprometheus-promioconfig-sdk8s) for specifying or discovering targets.

#### Static config

A static config has a list of static targets and any extra labels to add to them.

```yaml
scrape_configs:
  - job_name: example
    - targets: [ '10.10.10.1:9090', '10.10.10.2:9090', '10.10.10.3:9090' ... ]
    - labels: [ label1: value1, label1: value2, ... ]
```

#### Kubernetes Service Discovery config

Targets discovered using [`kubernetes_sd_configs`](https://aka.ms/azureprometheus-promioconfig-sdk8s) each have different `__meta_*` labels depending on what role is specified. You can use the labels in the `relabel_configs` section to filter targets or replace labels for the targets.

See the [Prometheus examples](https://aka.ms/azureprometheus-promsampleossconfig) of scrape configs for a Kubernetes cluster.

### Relabel configs
The `relabel_configs` section is applied at the time of target discovery and applies to each target for the job. The following examples show ways to use `relabel_configs`.

#### Add a label
Add a new label called `example_label` with the value `example_value` to every metric of the job. Use `__address__` as the source label only because that label always exists and adds the label for every target of the job.

```yaml
relabel_configs:
- source_labels: [__address__]
  target_label: example_label
  replacement: 'example_value'
```

#### Use Kubernetes Service Discovery labels

If a job is using [`kubernetes_sd_configs`](https://aka.ms/azureprometheus-promioconfig-sdk8s) to discover targets, each role has associated `__meta_*` labels for metrics. The `__*` labels are dropped after discovering the targets. To filter by using them at the metrics level, first keep them using `relabel_configs` by assigning a label name. Then use `metric_relabel_configs` to filter.

```yaml
# Use the kubernetes namespace as a label called 'kubernetes_namespace'
relabel_configs:
- source_labels: [__meta_kubernetes_namespace]
  action: replace
  target_label: kubernetes_namespace

# Keep only metrics with the kubernetes namespace 'default'
metric_relabel_configs:
- source_labels: [kubernetes_namespace]
  action: keep
  regex: 'default'
```

#### Job and instance relabeling

You can change the `job` and `instance` label values based on the source label, just like any other label.

```yaml
# Replace the job name with the pod label 'k8s app'
relabel_configs:
- source_labels: [__meta_kubernetes_pod_label_k8s_app]
  target_label: job

# Replace the instance name with the node name. This is helpful to replace a node IP
# and port with a value that is more readable
relabel_configs:
- source_labels: [__meta_kubernetes_node_name]]
  target_label: instance
```

### Metric relabel configs

Metric relabel configs are applied after scraping and before ingestion. Use the `metric_relabel_configs` section to filter metrics after scraping. The following examples show how to do so.

#### Drop metrics by name

```yaml
# Drop the metric named 'example_metric_name'
metric_relabel_configs:
- source_labels: [__name__]
  action: drop
  regex: 'example_metric_name'
```

#### Keep only certain metrics by name

```yaml
# Keep only the metric named 'example_metric_name'
metric_relabel_configs:
- source_labels: [__name__]
  action: keep
  regex: 'example_metric_name'
```

```yaml
# Keep only metrics that start with 'example_'
metric_relabel_configs:
- source_labels: [__name__]
  action: keep
  regex: '(example_.*)'
```

#### Rename metrics
Metric renaming isn't supported.

#### Filter metrics by labels

```yaml
# Keep metrics only where example_label = 'example'
metric_relabel_configs:
- source_labels: [example_label]
  action: keep
  regex: 'example'
```

```yaml
# Keep metrics only if `example_label` equals `value_1` or `value_2`
metric_relabel_configs:
- source_labels: [example_label]
  action: keep
  regex: '(value_1|value_2)'
```

```yaml
# Keep metrics only if `example_label_1 = value_1` and `example_label_2 = value_2`
metric_relabel_configs:
- source_labels: [example_label_1, example_label_2]
  separator: ';'
  action: keep
  regex: 'value_1;value_2'
```

```yaml
# Keep metrics only if `example_label` exists as a label
metric_relabel_configs:
- source_labels: [example_label_1]
  action: keep
  regex: '.+'
```

> [!NOTE]
> 
> If you wish to add labels to all the jobs in your custom configuration, explicitly add labels using metrics_relabel_configs for each job. Global external labels are not supported via configmap based prometheus configuration.
> ```yaml
> relabel_configs:
> - source_labels: [__address__]
>   target_label: example_label
>   replacement: 'example_value'
> ```
>

---



### Basic Authentication and Bearer Tokens
### [Scrape Configs using ConfigMap](#tab/ConfigFileScrapeConfigBasicAuth)

For using the `basic_auth` or `bearer_token` settings in your prometheus configuration, follow the steps below:

1. Create a secret in the `kube-system` namespace named `ama-metrics-mtls-secret`.
   
   The name of the key `password1` can be anything as long as it matches the file name in the `password_file` filepath in the Prometheus scrape config in the next step. The value for the key needs to be base64-encoded.
   
   ```yaml
   apiVersion: v1
   kind: Secret
   metadata:
     name: ama-metrics-mtls-secret
     namespace: kube-system
   type: Opaque
   data:
     password1: <base64-encoded-string>
   ```
   
   The `ama-metrics-mtls-secret` secret is mounted on to the `ama-metrics` pods at the path `/etc/prometheus/certs/` and is made available to the Prometheus scraper. The key (`password1` in the above example) will be the file name. The value is base64 decoded and added as the contents of the file within the container.
   
2. Then, in the custom scrape config in the configmap, provide the filepath:

   #### Basic Auth
   The `username` field should contain the actual username string. The `password_file` field should contain the path to the file that contains the password.
   
   ```yaml
   # Sets the `Authorization` header on every scrape request with the
   # configured username and password.
   basic_auth:
     username: <username string>
     password_file: /etc/prometheus/certs/password1
   ```

   #### Bearer Token
   The `bearer_token_file` field should contain the path to the file that contains the token.
   
   ```yaml
   # Sets the `Authorization` header on every scrape request with the bearer token
   # read from the configured file. It is mutually exclusive with `bearer_token`.
   bearer_token_file: /etc/prometheus/certs/password1
   ```

More info about these settings can be found in the [Prometheus scrape_config documentation](https://prometheus.io/docs/prometheus/1.8/configuration/configuration/#scrape_config).
   
### [Scrape Config using CRD (Pod/Service Monitor)](#tab/CRDScrapeConfigBasicAuth)
Scraping targets using basic auth or bearer tokens is currently not supported using PodMonitors or ServiceMonitors. Support for this will be added in an upcoming release. For now, the Pod or Service Monitor should be converted into a Prometheus scrape config and put in the custom scrape config configmap. Then basic auth and bearer tokens is supported.

---

If you are using both basic auth and TLS auth, refer to the [section](#basic-auth-and-tls) below.
For more details, refer to the [note section](#note) below.


### TLS-based scraping

If you want to scrape Prometheus metrics from an https endpoint, the Prometheus config, PodMonitor, or ServiceMonitor should have the `scheme` set to `https` and extra TLS settings. 

1. Create a secret in the `kube-system` namespace named `ama-metrics-mtls-secret`. Each key-value pair specified in the data section of the secret object will be mounted as a separate file in this /etc/prometheus/certs location with file names that are the same as the keys specified in the data section. The secret values should be base64-encoded.

   Below is an example YAML of a secret:

   ```yaml
   apiVersion: v1
   kind: Secret
   metadata:
     name: ama-metrics-mtls-secret
     namespace: kube-system
   type: Opaque
   data:
     <certfile>: base64_cert_content    
     <keyfile>: base64_key_content 
   ```
      
   The `ama-metrics-mtls-secret` secret is mounted on to the `ama-metrics` pods at the path `/etc/prometheus/certs/` and is made available to the Prometheus scraper. The key (`password1` in the above example) will be the file name. The value is base64 decoded and added as the contents of the file within the container.


2. Then, in the Prometheus config, PodMonitor, or ServiceMonitor, provide the filepath:
   
### [Scrape Configs using ConfigMap](#tab/ConfigFileScrapeConfigTLSAuth)

   - To provide the TLS config setting in a configmap, follow the below example:
   
   ```yaml
   tls_config:
      # CA certificate to validate API server certificate with.
      ca_file: /etc/prometheus/certs/<certfile>

      # Certificate and key files for client cert authentication to the server.
      cert_file: /etc/prometheus/certs/<certfile>
      key_file: /etc/prometheus/certs/<keyfile>

      # Disable validation of the server certificate.
      insecure_skip_verify: false
   ```

### [Scrape Config using CRD (Pod/Service Monitor)](#tab/CRDScrapeConfigTLSAuth)

   - To provide the TLS config setting for a PodMonitor or ServiceMonitor, follow the below example:
   
   ```yaml
    tlsConfig:
      ca:
        secret:
          key: "<certfile>"
          name: "ama-metrics-mtls-secret"
      cert:
        secret:
          key: "<certfile>"
          name: "ama-metrics-mtls-secret"
      keySecret:
          key: "<keyfile>"
          name: "ama-metrics-mtls-secret"
      insecureSkipVerify: false
   ```

---
   
### Basic Auth and TLS

   If you want to use both basic and TLS authentication settings in your configmap/CRD, ensure that the secret `ama-metrics-mtls-secret` includes all the keys under the data section with their corresponding base64-encoded values, as shown below:
   
   ```yaml
   apiVersion: v1
   kind: Secret
   metadata:
     name: ama-metrics-mtls-secret
     namespace: kube-system
   type: Opaque
   data:
     certfile: base64_cert_content    # used for TLS
     keyfile: base64_key_content      # used for TLS
     password1: base64-encoded-string # used for basic auth
     password2: base64-encoded-string # used for basic auth
   ```

### Note
> [!NOTE]
> 
> The `/etc/prometheus/certs/` path is mandatory, but `password1` can be any string and needs to match the key for the data in the secret created above. This is because the secret `ama-metrics-mtls-secret` is mounted in the path `/etc/prometheus/certs/` within the container.
>
> The base64-encoded value is automatically decoded by the ama-metrics pods when the secret is mounted as file.
>
> Ensure secret name is `ama-metrics-mtls-secret` and it is in `kube-system` namespace.
> 
> The secret should be created first, and then the configmap, PodMonitor, or ServiceMonitor should be created in `kube-system` namespace. The order of secret creation matters. When there's no secret but a configmap, PodMonitor, or ServiceMonitor pointing to the secret, the following error will be in the ama-metrics prometheus-collector container logs: `no file found for cert....`
> 
> To read more on TLS configuration settings, please follow this [Configurations](https://aka.ms/tlsconfigsetting).

## Next steps

[Setup Alerts on Prometheus metrics](./container-insights-metric-alerts.md)<br>
[Query Prometheus metrics](../essentials/prometheus-grafana.md)<br>
[Learn more about collecting Prometheus metrics](../essentials/prometheus-metrics-overview.md)
