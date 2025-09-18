---
title: Create and apply Pod and Service Monitors for Prometheus metrics in Azure Monitor
description: Describes how to create and apply pod and service monitors to scrape Prometheus metrics in Azure Monitor to Kubernetes cluster.
ms.topic: how-to
ms.date: 08/25/2025
ms.reviewer: aul
---
# Customize collection using CRDs (Service and Pod Monitors)


The enablement of Managed Prometheus automatically deploys the custom resource definitions (CRD) for [pod monitors](https://github.com/Azure/prometheus-collector/blob/main/otelcollector/deploy/addon-chart/azure-monitor-metrics-addon/templates/ama-metrics-podmonitor-crd.yaml) and [service monitors](https://github.com/Azure/prometheus-collector/blob/main/otelcollector/deploy/addon-chart/azure-monitor-metrics-addon/templates/ama-metrics-servicemonitor-crd.yaml). These custom resource definitions are the same custom resource definitions (CRD) as [OSS Pod monitors](https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/api-reference/api.md) and [OSS service monitors](https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/api-reference/api.md) for Prometheus, except for a change in the group name. If you have existing Prometheus CRDs and custom resources on your cluster, these CRDs won't conflict with the CRDs created by the add-on. At the same time, the managed Prometheus addon does not pick up the CRDs created for the OSS Prometheus. This separation is intentional for the purposes of isolation of scrape jobs.

## Create a Pod or Service Monitor

Use the [Pod and Service Monitor templates](https://github.com/Azure/prometheus-collector/tree/main/otelcollector/customresources) and follow the API specification to create your custom resources([PodMonitor](https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/api-reference/api.md) and [Service Monitor](https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/api-reference/api.md)). **Note** that the only change required to the existing OSS CRs(Custom Resources) for being picked up by the Managed Prometheus is the API group - **azmonitoring.coreos.com/v1**.
>Note - Please make sure to use the **labelLimit, labelNameLengthLimit and labelValueLengthLimit** specified in the templates so that they are not dropped during processing.

Your pod and service monitors should look like the following examples:

### Example Pod Monitor

```yaml
# Note the API version is azmonitoring.coreos.com/v1 instead of monitoring.coreos.com/v1
apiVersion: azmonitoring.coreos.com/v1
kind: PodMonitor

# Can be deployed in any namespace
metadata:
  name: reference-app
  namespace: app-namespace
spec:
  labelLimit: 63
  labelNameLengthLimit: 511
  labelValueLengthLimit: 1023

  # The selector specifies which pods to filter for
  selector:

    # Filter by pod labels
    matchLabels:
      environment: test
    matchExpressions:
      - key: app
        operator: In
        values: [app-frontend, app-backend]

    # [Optional] Filter by pod namespace. Required if service is in another namespace.
    namespaceSelector:
      matchNames: [app-frontend, app-backend]

  # [Optional] Labels on the pod with these keys will be added as labels to each metric scraped
  podTargetLabels: [app, region, environment]

  # Multiple pod endpoints can be specified. Port requires a named port.
  podMetricsEndpoints:
    - port: metricscs from the exa
```

### Example Service Monitor

```yaml
# Note the API version is azmonitoring.coreos.com/v1 instead of monitoring.coreos.com/v1
apiVersion: azmonitoring.coreos.com/v1
kind: ServiceMonitor

# Can be deployed in any namespace
metadata:
  name: reference-app
  namespace: app-namespace
spec:
  labelLimit: 63
  labelNameLengthLimit: 511
  labelValueLengthLimit: 1023

  # The selector filters endpoints by service labels.
  selector:
    matchLabels:
      app: reference-app

  # Multiple endpoints can be specified. Port requires a named port.
  endpoints:
  - port: metrics
```

### Deploy a Pod or Service Monitor

You can then deploy the pod or service monitor using kubectl apply.

When applied, any errors in the custom resources should show up and the pod or service monitors should fail to apply.  
A successful pod monitor creation looks like the following -

```bash
podmonitor.azmonitoring.coreos.com/my-pod-monitor created
```

### Examples

#### Create a sample application

Deploy a sample application exposing prometheus metrics to be configured by pod/service monitor.

```bash
kubectl apply -f https://raw.githubusercontent.com/Azure/prometheus-collector/refs/heads/main/internal/referenceapp/prometheus-reference-app.yaml
```

#### Create a pod monitor and/or service monitor to scrape metrics 

Deploy a pod monitor that is configured to scrape metrimple application from the previous step.

##### Pod Monitor

```bash
kubectl apply -f https://raw.githubusercontent.com/Azure/prometheus-collector/refs/heads/main/otelcollector/deploy/example-custom-resources/pod-monitor/pod-monitor-reference-app.yaml
```

##### Service Monitor

```bash
kubectl apply -f https://raw.githubusercontent.com/Azure/prometheus-collector/refs/heads/main/otelcollector/deploy/example-custom-resources/service-monitor/service-monitor-reference-app.yaml
```

### Troubleshooting

When the pod or service monitors are successfully applied, the addon should automatically start collecting metrics from the targets. To confirm this, follow the instructions [here](prometheus-metrics-troubleshoot.md#prometheus-interface) for general troubleshooting of custom resources and also to ensure the targets show up in 127.0.0.1/targets.

  :::image type="content" source="media/prometheus-metrics-troubleshoot/image-pod-service-monitor.png" alt-text="Screenshot showing targets for pod/service monitor" lightbox="media/prometheus-metrics-troubleshoot/image-pod-service-monitor.png":::






## Prometheus configuration tips and examples

Use the [Pod and Service Monitor templates](https://github.com/Azure/prometheus-collector/tree/main/otelcollector/customresources) and follow the API specification to create your custom resources([PodMonitor](https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/api-reference/api.md) and [Service Monitor](https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/api-reference/api.md)). **Note** that the only change required to the existing OSS CRs for being picked up by the Managed Prometheus is the API group - **azmonitoring.coreos.com/v1**. See [here](prometheus-metrics-scrape-crd.md) to learn more




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



## Basic Authentication and Bearer Tokens

Scraping targets using basic auth or bearer tokens is supported using PodMonitors and ServiceMonitors. Make sure that the secret containing the username/password/token is in the same namespace as the pod/service monitor (This behavior is the same as OSS prometheus-operator)



If you are using both file based credentials for basic auth (username_file, password_file or credentials_file) and TLS auth, refer to the [section](#basic-auth-and-tls) below.
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

   The `ama-metrics-mtls-secret` secret is mounted on to the `ama-metrics` pods at the path `/etc/prometheus/certs/` and is made available to the Prometheus scraper. The key ( `password1` in the above example) will be the file name. The value is base64 decoded and added as the contents of the file within the container.

2. Then, in the Prometheus config, PodMonitor, or ServiceMonitor, provide the filepath:

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

### Basic Auth and TLS

   If you want to use both basic auth or bearer token (file based credentials) and TLS authentication settings in your configmap/CRD, ensure that the secret `ama-metrics-mtls-secret` includes all the keys under the data section with their corresponding base64-encoded values, as shown below:

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

- [Learn more about collecting Prometheus metrics](../essentials/prometheus-metrics-overview.md).
