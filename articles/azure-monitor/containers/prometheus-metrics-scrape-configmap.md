---
title: Create custom Prometheus scrape job from your Kubernetes cluster using ConfigMap
description: Describes how to create custom configuration file Prometheus metrics in Azure Monitor and use validation tool before applying to Kubernetes cluster.
ms.topic: troubleshooting-general
ms.date: 5/25/2025
ms.reviewer: aul
---

# Create custom Prometheus scrape job from your Kubernetes cluster using ConfigMap

[Customize collection of Prometheus metrics from your Kubernetes cluster](./prometheus-metrics-scrape-configuration.md) describes how to use ConfigMap to customize scraping of Prometheus metrics from default targets in your Kubernetes cluster. This article describes how to use ConfigMap to create custom scrape jobs for further customization and additional targets.

## ConfigMaps

The following table describes the ConfigMaps used to create custom scraping jobs. These ConfigMaps don't exist by default in the cluster when Managed Prometheus is enabled. 

| ConfigMap | Description |
|:---|:---|
| [`ama-metrics-prometheus-config`](https://aka.ms/azureprometheus-addon-rs-ConfigMap) (**Recommended**) | When a ConfigMap with this name is created, scrape jobs defined in it are run from the Azure monitor metrics replica pod running in the cluster. |
| [`ama-metrics-prometheus-config-node`](https://aka.ms/azureprometheus-addon-ds-ConfigMap) (**Advanced**) |  Provide Prometheus scrape config for addon DaemonSet that runs on every Linux node in the cluster and any node level targets on each node. See [Advanced Setup](#advanced-setup-configure-custom-prometheus-scrape-jobs-for-the-daemonset). |
| [`ama-metrics-prometheus-config-node-windows`](https://aka.ms/azureprometheus-addon-ds-ConfigMap-windows) (**Advanced**) | Provide Prometheus scrape config for addon DaemonSet that runs on every Windows node in the cluster and any node level targets on each node. See [Advanced Setup](#advanced-setup-configure-custom-prometheus-scrape-jobs-for-the-daemonset). |


## Create Prometheus configuration file
Instead of directly modifying `ama-metrics-prometheus-config`, it's easier to create a config file and then convert it to a ConfigMap. See [Scrape config settings](#scrape-config-settings) below for details on the different sections of this file.

Create a Prometheus scrape configuration file named `prometheus-config` using the following format. This lists the scrape configs under the section `scrape_configs`  section and can optionally use the global section for setting the global `scrape_interval`, `scrape_timeout`, and `external_labels`. Refer to Prometheus.io [scrape configuration reference](https://aka.ms/azureprometheus-promioconfig-scrape) for complete details on the options for a scrape config. 

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

Following is a sample Prometheus scrape config file:

```yaml
global:
  scrape_interval: 30s
scrape_configs:
- job_name: my_static_config
  scrape_interval: 60s
  static_configs:
    - targets: ['my-static-service.svc.cluster.local:1234']
- job_name: prometheus_example_app
  scheme: http
  kubernetes_sd_configs:
    - role: service
  relabel_configs:
    - source_labels: [__meta_kubernetes_service_name]
      action: keep
      regex: "prometheus-example-service"
```

> [!TIP]
> See the [Prometheus examples](https://aka.ms/azureprometheus-promsampleossconfig) of scrape configs for a Kubernetes cluster.


## Validate the scrape config file

The agent uses a custom `promconfigvalidator` tool to validate the Prometheus config given to it through the ConfigMap. If the config isn't valid, then the custom configuration is rejected by the agent. Once you create your Prometheus config file, you can use this tool to validate your config before creating a ConfigMap for the agent.

The `promconfigvalidator` tool is shipped inside the Azure Monitor metrics addon pod. You can use any of the `ama-metrics-node-*` pods in `kube-system` namespace in your cluster to download the tool for validation. Use `kubectl cp` to download the tool and its configuration with the following command.

```bash
for podname in $(kubectl get pods -l rsName=ama-metrics -n=kube-system -o json | jq -r '.items[].metadata.name'); do kubectl cp -n=kube-system "${podname}":/opt/promconfigvalidator ./promconfigvalidator;  kubectl cp -n=kube-system "${podname}":/opt/microsoft/otelcollector/collector-config-template.yml ./collector-config-template.yml; chmod 500 promconfigvalidator; done
```

After copying the executable and the yaml, locate the path of your Prometheus configuration file. Then replace `<config path>`  in the command and run the validator with the following command.

```bash
./promconfigvalidator/promconfigvalidator --config "<config path>" --otelTemplate "./promconfigvalidator/collector-config-template.yml"
```

Running the validator generates the merged configuration file `merged-otel-config.yaml` if no path is provided with the optional `output` parameter. Don't use this autogenerated merged file as it's only used for tool validation and debugging purposes.

## Deploy config file as ConfigMap
Your custom Prometheus configuration file is consumed as a field named `prometheus-config` inside the `ama-metrics-prometheus-config`,  `ama-metrics-prometheus-config-node`, or `ama-metrics-prometheus-config-node-windows` ConfigMap in the `kube-system` namespace. Create a ConfigMap from the scrape config file by renaming your Prometheus configuration file to `prometheus-config` with no file extension and running one or more of the following sample commands, depending on which ConfigMap you want to create for your custom scrape job config.

**Create ConfigMap to be used by replicaset:**

```bash
kubectl create ConfigMap ama-metrics-prometheus-config --from-file=prometheus-config -n kube-system
```
This creates a ConfigMap named `ama-metrics-prometheus-config` in `kube-system` namespace. To see if there any issues with the config validation, processing, or merging, you can look at the `ama-metrics` replica pods

**Create ConfigMap to be used by Linux DaemonSet:**

```bash
kubectl create ConfigMap ama-metrics-prometheus-config-node --from-file=prometheus-config -n kube-system
```
This creates a ConfigMap named `ama-metrics-prometheus-config-node` in `kube-system` namespace. To see if there any issues with the config validation, processing, or merging, you can look at the `ama-metrics-node` linux deamonset pods


**Create ConfigMap to be used by Windows DaemonSet**
```bash
kubectl create ConfigMap ama-metrics-prometheus-config-node-windows --from-file=prometheus-config -n kube-system
```

This creates a ConfigMap named `ama-metrics-prometheus-config-node-windows` in `kube-system` namespace. To see if there any issues with the config validation, processing, or merging, you can look at the `ama-metrics-win-node` windows deamonset pods


## Troubleshooting
If you successfully created the ConfigMap in the **kube-system** namespace and still don't see the custom targets being scraped, check for errors in the **replica pod** logs for **ama-metrics-prometheus-config** ConfigMap or **DaemonSet pod** logs for **ama-metrics-prometheus-config-node** ConfigMap using *kubectl logs* and make sure there are no errors in the *Start Merging Default and Custom Prometheus Config* section with prefix *prometheus-config-merger*


### Scrape configs

Currently, the supported methods of target discovery for a [scrape config](https://aka.ms/azureprometheus-promioconfig-scrape) are either [`static_configs`](https://aka.ms/azureprometheus-promioconfig-static) or [`kubernetes_sd_configs`](https://aka.ms/azureprometheus-promioconfig-sdk8s) for specifying or discovering targets.

A static config has a list of static targets and any extra labels to add to them as in the following.

```yaml
scrape_configs:
  - job_name: example
    - targets: [ '10.10.10.1:9090', '10.10.10.2:9090', '10.10.10.3:9090' ... ]
    - labels: [ label1: value1, label1: value2, ... ]
```

Targets discovered using `kubernetes_sd_configs` each have different `__meta_*` labels depending on what role is specified. You can use the labels in the `relabel_configs` section to filter targets or replace labels for the targets.


### Relabel configs
The `relabel_configs` section is applied at the time of target discovery and applies to each target for the job. The following examples show ways to use `relabel_configs`.

**Add a label**
Add a new label called `example_label` with the value `example_value` to every metric of the job. Use `__address__` as the source label only because that label always exists and adds the label for every target of the job.

```yaml
relabel_configs:
- source_labels: [__address__]
  target_label: example_label
  replacement: 'example_value'
```

**Use Kubernetes Service Discovery labels**

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

**Job and instance relabeling**

You can change the `job` and `instance` label values based on the source label, just like any other label.

```yaml
# Replace the job name with the pod label 'k8s app'
relabel_configs:
- source_labels: [__meta_kubernetes_pod_label_k8s_app]
  target_label: job

# Replace the instance name with the node name. This is helpful to replace a node IP
# and port with a value that is more readable
relabel_configs:
- source_labels: [__meta_kubernetes_node_name]
  target_label: instance
```

### Metric relabel configs

Metric relabel configs are applied after scraping and before ingestion. Use the `metric_relabel_configs` section to filter metrics after scraping. See the following examples.

**Drop metrics by name**

```yaml
# Drop the metric named 'example_metric_name'
metric_relabel_configs:
- source_labels: [__name__]
  action: drop
  regex: 'example_metric_name'
```

**Keep only certain metrics by name**

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


**Filter metrics by labels**

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

**Rename metrics**
Metric renaming isn't supported.

> [!NOTE]
> 
> If you want to add labels to all the jobs in your custom configuration, explicitly add labels using `metrics_relabel_configs` for each job. Global external labels are not supported using ConfigMap based prometheus configuration.
> ```yaml
> relabel_configs:
> - source_labels: [__address__]
>   target_label: example_label
>   replacement: 'example_value'
> ```
>



## Basic Authentication and Bearer Tokens

If you're using username, password, or credentials as plaintext in the scrape configuration, no additional changes are required. The values specified in the configuration will be used for scraping. If you're using the `username_file` or `password_file` (or any `_file` configuration settings) for `basic_auth` or `bearer_token` settings in your prometheus configuration, follow the steps below:

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
   
2. Provide the filepath in the custom scrape config in the ConfigMap:

   **Basic Auth**
   The `username` field should contain the actual username string. The `password_file` field should contain the path to the file that contains the password.
   
   ```yaml
   # Sets the `Authorization` header on every scrape request with the
   # configured username and password.
   basic_auth:
     username: <username string>
     password_file: /etc/prometheus/certs/password1
   ```

   **Bearer Token**
   The `bearer_token_file` field should contain the path to the file that contains the token.

   ```yaml
   # Sets the `Authorization` header on every scrape request with the bearer token
   # read from the configured file. It is mutually exclusive with `bearer_token`.
   bearer_token_file: /etc/prometheus/certs/password1
   ```

See [Prometheus scrape_config documentation](https://prometheus.io/docs/prometheus/1.8/configuration/configuration/#scrape_config) for more information on these settings.
   


### TLS-based scraping

If you want to scrape Prometheus metrics from an https endpoint, the Prometheus config, PodMonitor, or ServiceMonitor should have the `scheme` set to `https` and extra TLS settings. 

1. Create a secret in the `kube-system` namespace named `ama-metrics-mtls-secret`. Each key-value pair specified in the data section of the secret object will be mounted as a separate file in this /etc/prometheus/certs location with file names that are the same as the keys specified in the data section. The secret values should be base64-encoded.

   Following is an example YAML of a secret:
   
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

   The `ama-metrics-mtls-secret` secret is mounted on to the `ama-metrics` pods at the path `/etc/prometheus/certs/` and is made available to the Prometheus scraper. The key will be the file name. The value is base64 decoded and added as the contents of the file within the container.

2. Provide the filepath in the Prometheus config, PodMonitor, or ServiceMonitor:

   - Use the following example to provide the TLS config setting in a ConfigMap:
   
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

   

### Basic Auth and TLS

   If you want to use both basic auth or bearer token (file based credentials) and TLS authentication settings in your ConfigMap, ensure that the secret `ama-metrics-mtls-secret` includes all the keys under the data section with their corresponding base64-encoded values, as shown in the following example:

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


> [!NOTE]
> 
> The `/etc/prometheus/certs/` path is mandatory, but `password1` can be any string and needs to match the key for the data in the secret created above. This is because the secret `ama-metrics-mtls-secret` is mounted in the path `/etc/prometheus/certs/` within the container.
>
> The base64-encoded value is automatically decoded by the ama-metrics pods when the secret is mounted as file. Ensure secret name is `ama-metrics-mtls-secret` and is in `kube-system` namespace.
> 
> The secret should be created first, and then the ConfigMap, PodMonitor, or ServiceMonitor should be created in `kube-system` namespace. The order of secret creation matters. When there's no secret but a ConfigMap, PodMonitor, or ServiceMonitor pointing to the secret, the following error will be in the ama-metrics prometheus-collector container logs: `no file found for cert....`
>
> See [tls_config](https://aka.ms/tlsconfigsetting) for more details on TLS configuration settings.

## Advanced setup: Configure custom Prometheus scrape jobs for the DaemonSet

The `ama-metrics` Replica pod consumes the custom Prometheus config and scrapes the specified targets. For a cluster with a large number of nodes and pods and a large volume of metrics to scrape, some of the applicable custom scrape targets can be off-loaded from the single `ama-metrics` Replica pod to the `ama-metrics` DaemonSet pod.

The `ama-metrics-prometheus-config-node` ConfigMap, is similar to the replica-set ConfigMap, and can be created to have static scrape configs on each node. The scrape config should only target a single node and shouldn't use service discovery/pod annotations. Otherwise, each node tries to scrape all targets and makes many calls to the Kubernetes API server.

Custom scrape targets can follow the same format by using `static_configs` with targets and using the `$NODE_IP` environment variable and specifying the port to scrape. Each pod of the DaemonSet takes the config, scrapes the metrics, and sends them for that node.

The following `node-exporter` config is one of the default targets for the DaemonSet pods. It uses the `$NODE_IP` environment variable, which is already set for every `ama-metrics` add-on container to target a specific port on the node.

 ```yaml
 - job_name: nodesample
   scrape_interval: 30s
   scheme: http
   metrics_path: /metrics
   relabel_configs:
   - source_labels: [__metrics_path__]
     regex: (.*)
     target_label: metrics_path
   - source_labels: [__address__]
     replacement: '$NODE_NAME'
     target_label: instance
   static_configs:
   - targets: ['$NODE_IP:9100']
 ```


## Scrape config settings
The following sections describe the settings supported in the Prometheus configuration file used in the ConfigMap. See the [Prometheus configuration reference](https://prometheus.io/docs/prometheus/latest/configuration/configuration/) for more details on these settings.

### Global settings
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
> If you want to use global settings that apply to all the scrape jobs, and only have [Custom Resources](prometheus-metrics-scrape-crd.md) you would still need to create a ConfigMap with just the global settings(Settings for each of these in the custom resources will override the ones in the global section)


## Next steps

- [Learn more about collecting Prometheus metrics](../essentials/prometheus-metrics-overview.md).
