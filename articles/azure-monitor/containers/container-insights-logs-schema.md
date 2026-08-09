---
title: Configure the ContainerLogV2 schema for Container insights
description: Switch your ContainerLog table to the ContainerLogV2 schema.
ms.topic: how-to
ms.date: 08/07/2026
ai-usage: ai-assisted
ms.reviewer: aul
---

# Configure the ContainerLogV2 schema

Container insights stores log data it collects in a table called *ContainerLogV2* in a Log Analytics workspace. This article describes the schema of this table and configuration options for it. It also compares this table to the legacy *ContainerLog* table and provides detail for migrating from it.


## Table comparison

*ContainerLogV2* is the default schema for CLI version 2.54.0 and greater. This schema is the default table for customers who onboard Container insights with managed identity authentication. Enable ContainerLogV2 explicitly through CLI version 2.51.0 or higher by using data collection settings.

>[!IMPORTANT]
> Support for the *ContainerLog* table retires on 30 September 2026. After that date, the legacy table stops receiving data. Migrate to *ContainerLogV2* before then to avoid gaps in log collection. To switch tables, see [Enable the ContainerLogV2 schema](#enable-the-containerlogv2-schema).

The following table highlights the key differences between using ContainerLogV2 and ContainerLog schema.

| Feature differences | ContainerLog | ContainerLogV2 |
| --- | --- | --- |
| Schema | Details at [ContainerLog](/azure/azure-monitor/reference/tables/containerlog). | Details at [ContainerLogV2](/azure/azure-monitor/reference/tables/containerlogv2).<br>Additional columns are:<br>- `ContainerName`<br>- `PodName`<br>- `PodNamespace`<br>- `LogLevel`<sup>1</sup><br>- `KubernetesMetadata`<sup>2</sup> |
| Onboarding | Only configurable through ConfigMap. | Configurable through both ConfigMap and DCR. <sup>3</sup> |
| Pricing | Only compatible with full-priced analytics logs. | Supports the low-cost [Basic Logs](../logs/logs-table-plans.md) tier in addition to analytics logs. |
| Querying | Requires multiple join operations with inventory tables for standard queries. | Includes additional pod and container metadata to reduce query complexity and join operations. |
| Multiline | Not supported, multiline entries are split into multiple rows. | Support for multiline logging to allow consolidated, single entries for multiline output. |

<sup>1</sup> If `LogMessage` is valid JSON and has a key named `level`, its value is used. Otherwise, regex based keyword matching infers `LogLevel` from `LogMessage`. This inference might result in some misclassifications. `LogLevel` is a string field with a value such as `CRITICAL`, `ERROR`, `WARNING`, `INFO`, `DEBUG`, `TRACE`, or `UNKNOWN`.

<sup>2</sup> `KubernetesMetadata` is an optional column that is enabled with [Kubernetes metadata](#kubernetes-metadata-and-logs-filtering). The value of this field is JSON with the fields `podLabels`, `podAnnotations`, `podUid`, `image`, `imageID`, `imageRepo`, and `imageTag`.

<sup>3</sup> DCR configuration requires [managed identity authentication](./container-insights-authentication.md).

>[!NOTE]
> The `LogMessage` field is dynamic and supports ingesting both JSON and plaintext string formats. 
[Log data export](../logs/logs-data-export.md) to Event Hubs and Storage Account is supported if the incoming `LogMessage` is valid JSON or a valid plain string. 
>
> If the `LogMessage` is malformed JSON, those log messages are ingested with escaping. By default, log messages larger than 16 KB are truncated. With [multiline logging](#multi-line-logging) enabled, log messages larger than 64 KB are truncated.


## Enable the ContainerLogV2 schema
Enable the **ContainerLogV2** schema for a cluster either using the cluster's [log profile](./kubernetes-monitoring-enable.md) or [ConfigMap](./kubernetes-data-collection-configmap.md#configmap-settings). If both settings are enabled, the ConfigMap takes precedence. The `ContainerLog` table is used only when both are explicitly set to off.

> [!IMPORTANT]
> The ContainerLogV2 setting does not control whether data is collected or not. It only specifies which table the data is sent to when it's collected.

Before you enable the **ContainerLogV2** schema, assess whether you have any alert rules that rely on the **ContainerLog** table. Update any such alerts to use the new table. Run the following Azure Resource Graph query to scan for alert rules that reference the `ContainerLog` table.

```Kusto
resources
| where type in~ ('microsoft.insights/scheduledqueryrules') and ['kind'] !in~ ('LogToMetric')
| extend severity = strcat("Sev", properties["severity"])
| extend enabled = tobool(properties["enabled"])
| where enabled in~ ('true')
| where tolower(properties["targetResourceTypes"]) matches regex 'microsoft.operationalinsights/workspaces($|/.*)?' or tolower(properties["targetResourceType"]) matches regex 'microsoft.operationalinsights/workspaces($|/.*)?' or tolower(properties["scopes"]) matches regex 'providers/microsoft.operationalinsights/workspaces($|/.*)?'
| where properties contains "ContainerLog"
| project id,name,type,properties,enabled,severity,subscriptionId
| order by tolower(name) asc
```

## Kubernetes metadata and logs filtering

Kubernetes metadata and logs filtering extends the ContainerLogV2 schema with additional Kubernetes metadata. The logs filtering feature provides filtering capabilities for both workload and platform containers. These features improve visibility into your workloads.

> [!NOTE]
> The Kubernetes metadata and logs filtering Grafana dashboard doesn't currently support Basic Logs.

### Features

- **Enhanced ContainerLogV2 schema**
    When you enable Kubernetes metadata, the `ContainerLogV2` table includes a new column called `KubernetesMetadata`. This column makes troubleshooting easier by using simple log queries and removes the need to join with other tables. The fields in this column include `podLabels`, `podAnnotations`, `podUid`, `image`, `imageID`, `imageRepo`, and `imageTag`. To enable this feature, see [Enable Kubernetes metadata](#enable-kubernetes-metadata).
- **Log level**
    This feature adds a `LogLevel` column to `ContainerLogV2` with the possible values `CRITICAL`, `ERROR`, `WARNING`, `INFO`, `DEBUG`, `TRACE`, or `UNKNOWN`. This column helps you assess application health based on severity level. The Grafana dashboard visualizes log level trends over time to quickly pinpoint affected resources.
- **Grafana dashboard for visualization**
    The Grafana dashboard provides a color-coded visualization of the **log level** and insights into log volume, log rate, and log records. The dashboard breaks down data by computer, pod, and container for targeted troubleshooting. To install the dashboard, see [Install Grafana dashboard](#install-grafana-dashboard).
- **Annotation based log filtering for workloads**
    Efficient log filtering through pod annotations. This allows you to focus on relevant information without sifting through noise. Annotation-based filtering enables you to exclude log collection for certain pods and containers by annotating the pod, which would help reduce the log analytics cost significantly. See [Annotation-based log filtering](./kubernetes-data-collection-configmap.md#annotation-based-filtering-for-workloads) for details on configuring annotation based filtering.
- **ConfigMap based log filtering for platform logs (System Kubernetes Namespaces)**
    Platform logs are emitted by containers in the system (or similar restricted) namespaces. By default, all the container logs from the system namespace are excluded to minimize the cost of data in your Log Analytics workspace. In specific troubleshooting scenarios though, container logs of system container play a crucial role. One example is the `coredns` container in the `kube-system` namespace.

    > [!VIDEO https://learn-video.azurefd.net/vod/player?id=15c1c297-9e96-47bf-a31e-76056d026bd1]


### Enable Kubernetes metadata

> [!IMPORTANT]
> Collection of Kubernetes metadata requires [managed identity authentication](./container-insights-authentication.md#migrate-to-managed-identity-authentication) and [ContainerLogV2](./container-insights-logs-schema.md).


Enable Kubernetes metadata using [ConfigMap](./kubernetes-data-collection-configmap.md#configmap-settings) with the following settings. All metadata fields are collected by default when the `metadata_collection` is enabled. Uncomment `include_fields` to specify individual fields to be collected.

```yaml
[log_collection_settings.metadata_collection]
    enabled = true
    include_fields = ["podLabels","podAnnotations","podUid","image","imageID","imageRepo","imageTag"]
```

After a few minutes, the `KubernetesMetadata` column appears in any log query for the `ContainerLogV2` table, as shown in the following screenshot.


:::image type="content" source="./media/container-insights-logging-v2/container-log-v2.png" lightbox="./media/container-insights-logging-v2/container-log-v2.png" alt-text="Screenshot that shows containerlogv2." border="false":::

### Install Grafana dashboard

> [!IMPORTANT]
> If you enabled Grafana using the guidance at [Enable monitoring for Kubernetes clusters](./kubernetes-monitoring-enable.md) then your Grafana instance should already have access to your Azure Monitor workspace for Prometheus metrics. The Kubernetes Logs Metadata dashboard also requires access to your Log Analytics workspace which contains log data. See [How to modify access permissions to Azure Monitor](/azure/managed-grafana/how-to-permissions) for guidance on granting your Grafana instance the Monitoring Reader role for your Log Analytics workspace.

Import the dashboard from the Grafana gallery at [ContainerLogV2 Dashboard](https://grafana.com/grafana/dashboards/20995-azure-insights-containers-containerlogv2/). Open the dashboard and select values for DataSource, Subscription, ResourceGroup, Cluster, Namespace, and Labels.

:::image type="content" source="./media/container-insights-logging-v2/grafana-3.png" lightbox="./media/container-insights-logging-v2/grafana-3.png" alt-text="Screenshot that shows grafana dashboard." border="false":::

>[!NOTE]
> When you initially load the Grafana dashboard, you might see errors because variables aren't selected yet. To prevent this from recurring, save the dashboard after selecting a set of variables so that it becomes the default on the first open.

## Multi-line logging
Multiline logging stitches together previously split container logs and sends them as single entries to the `ContainerLogV2` table. Enable multiline logging by using ConfigMap as described in [Configure container log collection with ConfigMap](./kubernetes-data-collection-configmap.md).

>[!NOTE]
> The configmap now features a language specification option that allows you to select only the languages you're interested in. This feature can be enabled by editing the languages in the stacktrace_languages option in the [configmap](https://github.com/microsoft/Docker-Provider/blob/ci_prod/kubernetes/container-azm-ms-agentconfig.yaml).

### Limitations

- Multiline logging only stitches exception stack traces from the containers using Java, Python, .NET, and Go. Other multiline log entries, including custom exceptions and arbitrary log messages, are not stitched together.
- Multiline logging isn't supported for Python exception stack traces with [fine-grained-error-locations-in-tracebacks](https://docs.python.org/3/whatsnew/3.11.html#pep-657-fine-grained-error-locations-in-tracebacks). For multiline logging to work, you need to opt-out of this feature as described in [Python documentation](https://peps.python.org/pep-0657/#opt-out-mechanism).
- By default, the container runtime truncates log lines at 16 KB. When you enable multiline logging, `ContainerLogV2` supports log lines up to 64 KB.

### Examples

**Go exception stack trace multi-line logging disabled**

:::image type="content" source="./media/container-insights-logging-v2/multi-line-disabled-go.png" lightbox="./media/container-insights-logging-v2/multi-line-disabled-go.png" alt-text="Screenshot that shows Multi-line logging disabled." border="false":::

**Go exception stack trace multi-line logging enabled**

:::image type="content" source="./media/container-insights-logging-v2/multi-line-enabled-go.png" lightbox="./media/container-insights-logging-v2/multi-line-enabled-go.png" alt-text="Screenshot that shows Multi-line enabled." border="false":::

**Java stack trace multi-line logging enabled**

:::image type="content" source="./media/container-insights-logging-v2/multi-line-enabled-java.png" lightbox="./media/container-insights-logging-v2/multi-line-enabled-java.png" alt-text="Screenshot that shows Multi-line enabled for Java.":::

**Python stack trace multi-line logging enabled**

:::image type="content" source="./media/container-insights-logging-v2/multi-line-enabled-python.png" lightbox="./media/container-insights-logging-v2/multi-line-enabled-python.png" alt-text="Screenshot that shows Multi-line enabled for Python.":::



## Next steps
* Configure [Basic Logs](../logs/logs-table-plans.md) for ContainerLogV2.
* Learn how to [query data](./container-insights-log-query.md#container-logs) from ContainerLogV2.
