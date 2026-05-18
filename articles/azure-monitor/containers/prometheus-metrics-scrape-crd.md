---
title: Create custom Prometheus scrape job from your Kubernetes cluster using CRDs
description: Describes how to create and apply pod and service monitors to scrape Prometheus metrics in Azure Monitor to Kubernetes cluster.
ms.topic: how-to
ms.date: 08/25/2025
ms.reviewer: aul
---
# Create custom Prometheus scrape job from your Kubernetes cluster using CRDs

[Customize collection of Prometheus metrics from your Kubernetes cluster](./prometheus-metrics-scrape-configuration.md) describes how to use ConfigMap to customize scraping of Prometheus metrics from default targets in your Kubernetes cluster. This article describes how to use custom resource definitions (CRDs) to create custom scrape jobs for further customization and additional targets.

## Custom resource definitions (CRDs)

Enabling Azure Monitor managed service for Prometheus automatically deploys custom resource definitions (CRD) for [pod monitors](https://github.com/Azure/prometheus-collector/blob/main/otelcollector/deploy/addon-chart/azure-monitor-metrics-addon/templates/ama-metrics-podmonitor-crd.yaml) and [service monitors](https://github.com/Azure/prometheus-collector/blob/main/otelcollector/deploy/addon-chart/azure-monitor-metrics-addon/templates/ama-metrics-servicemonitor-crd.yaml). These CRDs are the same as [OSS Pod monitors](https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/api-reference/api.md) and [OSS service monitors](https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/api-reference/api.md) for Prometheus except for a change in the group name. If you have existing Prometheus CRDs and custom resources on your cluster, these CRDs won't conflict with the CRDs created by the add-on. At the same time, the managed Prometheus addon does not pick up the CRDs created for the OSS Prometheus. This separation is intentional for the purposes of isolation of scrape jobs.

## Create a Pod or Service Monitor

Use the [Pod and Service Monitor templates](https://github.com/Azure/prometheus-collector/tree/main/otelcollector/customresources) and follow the API specification to create your custom resources([PodMonitor](https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/api-reference/api.md) and [Service Monitor](https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/api-reference/api.md)). The only change required to the existing OSS CRs(Custom Resources) for being picked up by the Managed Prometheus is the API group - **azmonitoring.coreos.com/v1**.


> [!IMPORTANT]
> Make sure to use the **labelLimit, labelNameLengthLimit and labelValueLengthLimit** specified in the templates so that they are not dropped during processing. See [Scrape config settings](#scrape-config-settings) below for details on the different sections of this file.

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

## Deploy a Pod or Service Monitor

Deploy the pod or service monitor using `kubectl apply` as in the following examples.

### Create a sample application

Deploy a sample application exposing prometheus metrics to be configured by pod/service monitor.

```bash
kubectl apply -f https://raw.githubusercontent.com/Azure/prometheus-collector/refs/heads/main/internal/referenceapp/prometheus-reference-app.yaml
```

##### Create a pod monitor and/or service monitor to scrape metrics

Deploy a pod monitor that is configured to scrape the application from the previous step.

##### Pod Monitor

```bash
kubectl apply -f https://raw.githubusercontent.com/Azure/prometheus-collector/refs/heads/main/otelcollector/deploy/example-custom-resources/pod-monitor/pod-monitor-reference-app.yaml
```

##### Service Monitor

```bash
kubectl apply -f https://raw.githubusercontent.com/Azure/prometheus-collector/refs/heads/main/otelcollector/deploy/example-custom-resources/service-monitor/service-monitor-reference-app.yaml
```

### Troubleshooting

When the pod or service monitors are successfully applied, the addon should automatically start collecting metrics from the targets. See [Troubleshoot collection of Prometheus metrics in Azure Monitor](./prometheus-metrics-troubleshoot.md) for general troubleshooting of custom resources and also to ensure the targets show up in 127.0.0.1/targets.




## Scrape config settings
The following sections describe the settings supported in the Prometheus configuration file used in the CRD. See the [Prometheus configuration reference](https://prometheus.io/docs/prometheus/latest/configuration/configuration/) for more details on these settings.

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
The settings provided in the global section apply to all scrape jobs in the CRD but are overridden if they are specified in the individual jobs.

> [!NOTE]
> If you want to use global settings that apply to all the scrape jobs, and only have custom resources, you still need to create a ConfigMap with just the global settings. Settings for each of these in the custom resources will override the ones in the global section

### Scrape configs
The supported methods of target discovery for custom resources are currently pod and service monitor.

### Pod and Service Monitors
Targets discovered using pod and service monitors have different `__meta_*` labels depending on what monitor is used. You can use the labels in the `relabelings` section to filter targets or replace labels for the targets. See the [Pod and Service Monitor examples](https://github.com/Azure/prometheus-collector/tree/main/otelcollector/deploy/example-custom-resources) of pod and service monitors.

### Relabelings
The `relabelings` section is applied at the time of target discovery and applies to each target for the job. The following examples show ways to use `relabelings`.

**Add a label**
Add a new label called `example_label` with the value `example_value` to every metric of the job. Use `__address__` as the source label only because that label always exists and adds the label for every target of the job.

```yaml
relabelings:
- sourceLabels: [__address__]
  targetLabel: example_label
  replacement: 'example_value'
```

**Use Pod or Service Monitor labels**

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

**Job and instance relabeling**

You can change the `job` and `instance` label values based on the source label, just like any other label.

```yaml
# Replace the job name with the pod label 'k8s app'
relabelings:
- sourceLabels: [__meta_kubernetes_pod_label_k8s_app]
  targetLabel: job

# Replace the instance name with the node name. This is helpful to replace a node IP
# and port with a value that is more readable
relabelings:
- sourceLabels: [__meta_kubernetes_node_name]
  targetLabel: instance
```

> [!NOTE]
> If you have relabeling configs, ensure that the relabeling does not filter out the targets, and the labels configured correctly match the targets.

### Metric relabelings

Metric relabelings are applied after scraping and before ingestion. Use the `metricRelabelings` section to filter metrics after scraping. See the following examples.

**Drop metrics by name**

```yaml
# Drop the metric named 'example_metric_name'
metricRelabelings:
- sourceLabels: [__name__]
  action: drop
  regex: 'example_metric_name'
```

**Keep only certain metrics by name**

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

**Filter metrics by labels**

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

**Rename metrics**
Metric renaming isn't supported.


## Basic Authentication and Bearer Tokens

> [!NOTE]
> On Kubernetes 1.37 and later, Azure Managed Prometheus (or ama-metrics) uses namespace-scoped access to Kubernetes secrets for PodMonitor and ServiceMonitor configurations. You must configure namespace-scoped secrets access if you're running Kubernetes 1.37 or later and your ServiceMonitor or PodMonitor uses basicAuth and any configuration that references Kubernetes secrets.

### Scoped Secrets Access for Pod/ServiceMonitors

On Kubernetes 1.37 and later, Azure Managed Prometheus (or ama-metrics) will use namespace-scoped access to Kubernetes secrets for PodMonitor and ServiceMonitor configurations. Previously, the ama-metrics component had cluster-wide permissions to read secrets across all namespaces. This update improves security by requiring explicit, namespace-level access to secrets used for basic authentication

With this change:
- Access to secrets is limited only to namespaces you explicitly configure
- You must grant Role-based access control (RBAC) permissions in each namespace where secrets are used

### Default behavior by Kubernetes version

**Kubernetes versions earlier than 1.37**
- Cluster-wide secrets access is still enabled for backward compatibility
- Follow the steps [here](#configure-basic-authentication-for-kubernetes-136-and-earlier) to configure basic auth for ServiceMonitor and PodMonitor

**Kubernetes version 1.37 and later**
- Cluster-wide secrets access is removed
- By default, no namespaces are monitored for secrets
- You must:
    1. Configure allowed namespaces
    2. Add RBAC permissions in each namespace

### When you need to configure this
You must configure namespace-scoped secrets access if you're running Kubernetes 1.37 or later and your ServiceMonitor or PodMonitor uses basicAuth and any configuration that references Kubernetes secrets.

### Configure secrets access for PodMonitor and ServiceMonitor for Basic Auth

Follow these steps to allow Azure Managed Prometheus to read secrets securely.

### Step 1: Create the Basic Auth Secret

Create a secret in the namespace where your application runs:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: my-basic-auth
  namespace: my-app          # <-- your application namespace
type: Opaque
data:
  username: <base64-encoded-username>
  password: <base64-encoded-password>
```

### Step 2: Reference the Secret in Your ServiceMonitor/PodMonitor

**ServiceMonitor example:**

```yaml
apiVersion: azmonitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: my-service-monitor
  namespace: my-app
spec:
  selector:
    matchLabels:
      app: my-app
  endpoints:
    - port: metrics
      basicAuth:
        username:
          name: my-basic-auth    # Secret name from Step 1
          key: username
        password:
          name: my-basic-auth
          key: password
```

**PodMonitor example:**

```yaml
apiVersion: azmonitoring.coreos.com/v1
kind: PodMonitor
metadata:
  name: my-pod-monitor
  namespace: my-app
spec:
  selector:
    matchLabels:
      app: my-app
  podMetricsEndpoints:
    - port: metrics
      basicAuth:
        username:
          name: my-basic-auth
          key: username
        password:
          name: my-basic-auth
          key: password
```

### Step 3: Configure `secrets_access_namespaces`

Edit the [ama-metrics-settings-configmap.yaml](https://aka.ms/azureprometheus-addon-settings-configmap) to include the namespace(s) where your secrets live:

```yaml
kind: ConfigMap
apiVersion: v1
metadata:
  name: ama-metrics-settings-configmap
  namespace: kube-system
data:
  prometheus-collector-settings: |-
    cluster_alias = ""
    secrets_access_namespaces = "kube-system,my-app"
```

> [!NOTE]
> - Use a comma-separated list of namespaces
> - Include kube-system if you also have secrets there
> - Changes take effect after the ama-metrics pod restarts

### Step 4: Create RBAC in Each Namespace (Kubernetes >= 1.37)

On Kubernetes >= 1.37, the ClusterRole no longer grants cluster-wide secrets access. You must create a `Role` and `RoleBinding` in **every** namespace listed in `secrets_access_namespaces` (including `kube-system` if needed). Apply the following in each namespace. Replace `my-app` with the target namespace:

**Create a Role:**

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: ama-metrics-secrets-reader
  namespace: my-app              # <-- repeat for each namespace
rules:
  - apiGroups: [""]
    resources: ["secrets"]
    verbs: ["get", "list", "watch"]
```

**Create a RoleBinding:**

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: ama-metrics-secrets-rolebinding
  namespace: my-app              # <-- repeat for each namespace
subjects:
  - kind: ServiceAccount
    name: ama-metrics-serviceaccount
    namespace: kube-system       # <-- SA lives in kube-system
roleRef:
  kind: Role
  name: ama-metrics-secrets-reader
  apiGroup: rbac.authorization.k8s.io
```

> [!NOTE]
> Cross-namespace note: The RoleBinding in `my-app` references the ServiceAccount in `kube-system`. This is valid Kubernetes RBAC — a RoleBinding can reference a subject from any namespace.

### Step 5: Verify

After the `ama-metrics` pod restarts:

1. Check the target allocator logs for:
   ```
   SecretsAccessNamespaces from configmap: [kube-system my-app]
   ```
2. Confirm your ServiceMonitor/PodMonitor targets appear in the target allocator's discovered targets.
3. Verify that scrape results include metrics from the basic-auth-protected endpoints.

---

### Example: Multiple Namespaces

If you have secrets in `my-app`, `backend`, and `monitoring`:

1. **ConfigMap setting:**
   ```toml
   secrets_access_namespaces = "kube-system,my-app,backend,monitoring"
   ```

2. **RBAC (>= 1.37 only):** Create the Role + RoleBinding (from Step 4) in each of `my-app`, `backend`, and `monitoring`.

---

### Troubleshooting

| Symptom | Cause | Fix |
|---------|-------|-----|
| ServiceMonitor targets not discovered | Secret not readable by target allocator | Ensure namespace is in `secrets_access_namespaces` AND Role+RoleBinding exists |
| `forbidden: User "system:serviceaccount:kube-system:ama-metrics-serviceaccount" cannot list resource "secrets"` in TA logs | Missing RBAC in the namespace | Create Role+RoleBinding in that namespace (Step 4) |
| Targets discovered but scrape fails with 401 | Secret exists but credentials wrong | Verify the Secret's `data` fields have correct base64-encoded values |
| Setting ignored after configmap update | Pod hasn't restarted | Restart the `ama-metrics` pod to pick up new configmap values |


## Configure Basic Authentication for Kubernetes 1.36 and earlier

Scraping targets using basic auth or bearer tokens is supported using PodMonitors and ServiceMonitors. Make sure that the secret containing the username/password/token is in the same namespace as the pod/service monitor. This behavior is the same as OSS prometheus-operator.

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

   - Use the following example to provide the TLS config setting for a PodMonitor or ServiceMonitor:

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

   If you want to use both basic auth or bearer token (file based credentials) and TLS authentication settings in your CRD, ensure that the secret `ama-metrics-mtls-secret` includes all the keys under the data section with their corresponding base64-encoded values, as shown below:

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


## Next steps

- [Learn more about collecting Prometheus metrics](../essentials/prometheus-metrics-overview.md).
