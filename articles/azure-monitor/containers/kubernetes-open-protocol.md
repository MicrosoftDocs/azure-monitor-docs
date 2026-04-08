---
title: Monitor AKS applications with OpenTelemetry Protocol (OTLP) Preview
description: Enable application monitoring for Azure Kubernetes Service (AKS) namespaces and deployments and send OpenTelemetry Protocol (OTLP) telemetry to Application Insights using Azure Monitor.
ms.topic: how-to
ms.date: 04/08/2026
ms.reviewer: kaprince
---

# Monitor AKS applications with OTLP and Azure Monitor (Preview)

OpenTelemetry provides a standardized way to emit traces, logs, and metrics. Azure Monitor adds **Preview** support for monitoring applications that run on Azure Kubernetes Service (AKS) by using the OpenTelemetry Protocol (OTLP) for instrumentation and data collection.

> [!IMPORTANT]
> This feature is a **preview**. Preview features are provided without a service-level agreement and aren't recommended for production workloads. 
>  
> For more information, see [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).

## Key capabilities

- Enable cluster-level monitoring to install Azure Monitor components on the AKS cluster.
- Create an Application Insights resource with OTLP ingestion enabled.
- Onboard applications at the namespace or deployment scope by using either:
  - **Autoinstrumentation** with the Azure Monitor OpenTelemetry distribution.
  - **Autoconfiguration** for applications already instrumented with the open-source OpenTelemetry Software Development Kits (SDKs).
    - Autoconfiguration applies only to applications that are already instrumented with OpenTelemetry. When you select autoconfiguration, Azure Monitor doesn't add instrumentation to your application. Instead, it sets environment variables at the platform level so existing OpenTelemetry SDKs export telemetry to Application Insights. You're responsible for instrumenting the application (for example, by using OpenTelemetry SDKs or annotations) before you enable autoconfiguration.

Telemetry flows to **Application Insights**, where you analyze application performance in context with Container Insights.

> [!IMPORTANT]
> Unsupported node pools: **Windows (any architecture)**.

## Roles and responsibilities

Use the following guidance to separate platform (cluster) responsibilities from application development (workload) responsibilities. *Cluster administrator* refers to the team that's responsible for the AKS cluster and Azure Monitor telemetry pipeline. *Developer* refers to the team that owns the application code and its telemetry configuration.

| Cluster administrator responsibilities | Developer responsibilities |
|---|---|
| Enable and maintain the cluster-level monitoring integration (AKS Monitor settings / add-ons). | Instrument application code using OpenTelemetry SDKs (or adopt supported auto-instrumentation where applicable). |
| Create, configure, and govern shared Azure resources used for ingestion and storage (Application Insights, Azure Monitor workspace, Log Analytics workspace, DCR/DCE where applicable). | Configure application telemetry (resource attributes, sampling, log correlation, and exporter settings) and validate signal correctness. |
| Manage identities and permissions required for telemetry export (managed identities, Microsoft Entra app registrations/service principals, RBAC role assignments). | Onboard workloads at the namespace or deployment scope (labels/annotations/configuration resources) following the platform's supported pattern. |
| Define and enforce cluster governance (namespaces, network policy, admission controls, quotas/limits) that can impact telemetry collection. | Perform application rollout restarts when required to apply monitoring changes to pods/deployments. |
| Operate and troubleshoot platform components (Azure Monitor Agent/Managed Prometheus/collectors deployed as add-ons), including upgrades and rollback plans. | Troubleshoot application-level telemetry gaps (missing spans/metrics/logs, incorrect attributes, high cardinality, and noisy logs) and remediate in code/config. |
| Provide supported recommended baseline configurations (standard ports/endpoints, required temporality/aggregation expectations, approved exporters/processors). | Own SLOs/alerting for the application and use Azure Monitor / Application Insights experiences to investigate regressions. |

*Out of scope for cluster admins: changing application code, selecting libraries, and defining business-level telemetry semantics.*

*Out of scope for developers: changing cluster add-ons, platform RBAC, shared ingestion resource topology, or cluster networking.*

**Common collaboration points:**

- Agree on naming and labeling standards (`service.name`, `k8s.deployment.name`, and namespace conventions) so data is queryable and dashboards work across teams.
- Align on performance and cost guardrails (sampling strategy, log verbosity, and metric cardinality) and who changes what when limits are exceeded.
- Define a support workflow for telemetry issues (what developers check first vs. when to escalate to the cluster admin team).
- Plan changes jointly when they span both layers (for example, switching ingestion method, changing endpoint/temporality expectations, or introducing a collector).


## Prerequisites

- An AKS cluster in Azure public cloud that runs at least one Kubernetes deployment.
- Azure CLI **2.78.0** or later. Install or update by using the guidance in **Install the Azure CLI** documentation.  
  Verify the version:
  ```bash
  az version
  ```
- `aks-preview` Azure CLI extension:
  ```bash
  az extension add --name aks-preview
  az extension update --name aks-preview
  ```

> [!NOTE]
> The Azure Kubernetes Service (AKS) preview APIs are designed to allow you to test and provide feedback on new features before they become generally available. You need to install this `aks-preview` extension before you can register the AzureMonitorAppMonitoringPreview feature flag.

## 1. Register the preview features

When you register the preview features, enable the feature flag on the subscription where you create the Application Insights resource and on the subscription that hosts the AKS cluster.

1. Sign in and select the target subscription:
   ```bash
   az login
   az account set --subscription "<subscription-name>"
   ```

1. Register the AKS preview feature and provider:
   ```bash
   az feature register --namespace "Microsoft.ContainerService" --name "AzureMonitorAppMonitoringPreview"
   az feature list -o table --query "[?contains(name, 'Microsoft.ContainerService/AzureMonitorAppMonitoringPreview')].{Name:name,State:properties.state}"
   az provider register --namespace "Microsoft.ContainerService"
   az provider show --namespace "Microsoft.ContainerService" --query "registrationState"
   ```

1. Register the Application Insights OTLP preview features and provider:
   ```bash
   az feature register --name OtlpApplicationInsights --namespace Microsoft.Insights
   az feature list -o table --query "[?contains(name, 'Microsoft.Insights/OtlpApplicationInsights')].{Name:name,State:properties.state}"

   az provider register -n Microsoft.Insights
   ```

## 2. Prepare the cluster

1. Ensure the cluster is onboarded to Azure Monitor metrics and logs. Use [**Enable monitoring for AKS clusters**](kubernetes-monitoring-enable.md#enable-prometheus-metrics-and-container-logging) in Azure Monitor (Application Insights isn't required yet).
1. Turn on **Enable support for Autoinstrumentation** and **Enable support for data collection from vendor neutral OpenTelemetry SDKs (Preview)**, and then select **Review + enable**.

If you didn't previously onboard the cluster, you can enable Managed Prometheus, Container Logs, and application monitoring at the same time.

:::image type="content" source="./media/kubernetes-open-protocol/azure-settings-enable-application.png" lightbox="./media/kubernetes-open-protocol/azure-settings-enable-application.png" alt-text="A screenshot of the Azure settings page showing enable application option.":::

:::image type="content" source="./media/kubernetes-open-protocol/azure-settings-review-enable.png" lightbox="./media/kubernetes-open-protocol/azure-settings-review-enable.png" alt-text="A screenshot of the Azure settings review page showing enable application option.":::

## 3. Create an Application Insights resource with OTLP support

Create or select an Application Insights resource that supports OTLP and uses **Managed workspaces**.

1. In the Azure portal, create a new Application Insights resource.
1. Turn on **Enable OTLP Support (Preview)**.
1. Set **Use managed workspaces** to **Yes**.  
    :::image type="content" source="./media/kubernetes-open-protocol/application-insights-create-enable.png" lightbox="./media/kubernetes-open-protocol/application-insights-create-enable.png" alt-text="A screenshot of Create Application Insights resource with enable option selected.":::

> [!IMPORTANT]
> - Use an **Azure Monitor workspace** that's **different** from the workspace used for infrastructure metrics in step 2.
> - Managed workspaces create a separate Azure Monitor workspace for Application Insights application telemetry using a distinct workspace from the one used for infrastructure metrics.

## 4. Onboard applications to Application Insights

You can onboard **all deployments in a namespace** or target **individual deployments** later.

### 4.1 Open the namespace

1. In the AKS resource, expand **Kubernetes resources**.
1. Open **Namespaces**, and then select the namespace that hosts your workloads.

:::image type="content" source="./media/kubernetes-open-protocol/azure-namespaces-list.png" lightbox="./media/kubernetes-open-protocol/azure-namespaces-list.png" alt-text="A screenshot of the Azure namespaces list under Kubernetes resources.":::

### 4.2 Configure Application Monitoring (Preview)

When you enable OTLP, Application Insights adds support for open-source, vendor-neutral OpenTelemetry SDKs and OTLP endpoints, and stores metrics in an Azure Monitor workspace.

If you don't enable OTLP, Application Insights only uses Azure Monitor autoinstrumentation and classic ingestion.

1. Select **Application Monitoring (Preview)**.
1. Choose the Application Insights resource with OTLP enabled that you created previously in [step 3](#3-create-an-application-insights-resource-with-otlp-support). If you select or create an Application Insights resource without OTLP by using the **Create New** option, you won't see the **Instrumentation Type** option in the next step.
1. Choose an **Instrumentation Type**:  
    - **User-configured instrumentation per deployment**
      - Autoconfiguration sets environment variables so existing SDKs export telemetry to Application Insights
      - Each deployment must already have autoinstrumentation annotations or manual instrumentation. For more information, see [Per deployment onboarding](kubernetes-codeless.md#per-deployment-onboarding).
    - **Java autoinstrumentation for all deployments** for automatic injection of the Azure Monitor OpenTelemetry distribution into Java applications.  
      - All deployments in the namespace use Java autoinstrumentation by default. Use annotations to change the language or exclude a deployment. For more information, see [Automatic instrumentation](../app/codeless-overview.md) and [Per deployment onboarding](kubernetes-codeless.md#per-deployment-onboarding).
    - **NodeJs autoinstrumentation for all deployments** for automatic injection of the Azure Monitor OpenTelemetry distribution into Node.js applications.  
       - All deployments in the namespace use Node.js autoinstrumentation by default. Use annotations to change the language or exclude a deployment. For more information, see [Automatic instrumentation](../app/codeless-overview.md) and [Per deployment onboarding](kubernetes-codeless.md#per-deployment-onboarding).
    > [!NOTE]
    > The Azure portal only allows you to apply autoinstrumentation OR autoconfiguration to a single namespace. If you need to use both options, see [per-deployment onboarding options](kubernetes-codeless.md#onboard-deployments).
1. Leave **Perform rollout restart of all deployments** unchecked. You perform the restart manually in the next step.
1. Select **Configure**.  
  :::image type="content" source="./media/kubernetes-open-protocol/application-configuration-pane.png" lightbox="./media/kubernetes-open-protocol/application-configuration-pane.png" alt-text="A screenshot of the configuration pane for application with resource and language selections.":::

### 4.3 Restart deployments to apply changes

Restart deployments in the target namespace from **Run command** in the portal or from your terminal:

```bash
kubectl rollout restart deployment -n <your-namespace>
```

:::image type="content" source="./media/kubernetes-open-protocol/azure-run-command-rollout.png" lightbox="./media/kubernetes-open-protocol/azure-run-command-rollout.png" alt-text="A screenshot of the Azure run command screen showing rollout restart command.":::

### 4.4 Confirm instrumented status

Return to **Application Monitoring (Preview)** for the namespace. Expand **Deployments in this namespace** and confirm that deployments show **Instrumented** status.

:::image type="content" source="./media/kubernetes-open-protocol/application-deployments-status.png" lightbox="./media/kubernetes-open-protocol/application-deployments-status.png" alt-text="A screenshot of the Application deployments list showing instrumented status.":::

> [!TIP]
> After a few minutes, telemetry appears in the connected Application Insights resource.


> [!IMPORTANT]
> Application Insights experiences, including prebuilt dashboards and queries, expect and require OTLP metrics with delta temporality and exponential histogram aggregation.
>
> When you use AKS auto-instrumentation or auto-configuration, Azure Monitor automatically uses environment variables to configure SDKs to export metrics with delta temporality and exponential histograms. You don't need to provide any extra configuration.
>
> For more information, see [Metrics Exporters - OTLP](https://opentelemetry.io/docs/specs/otel/metrics/sdk_exporters/otlp/).


## 5. View application signals in Container Insights

Explore application performance in the context of your cluster by using Container Insights. From **Monitor** in the AKS resource, open **Controllers** and then select a controller to review request failures, slow operations, and suggested investigations.

:::image type="content" source="./media/kubernetes-open-protocol/azure-controller-performance-view.png" lightbox="./media/kubernetes-open-protocol/azure-controller-performance-view.png" alt-text="A screenshot of the controller view showing performance metrics.":::

To drill down to Container Insights, select an application component node in the Application Map.

:::image type="content" source="./media/kubernetes-open-protocol/azure-controller-performance-alternate-view.png" lightbox="./media/kubernetes-open-protocol/azure-controller-performance-alternate-view.png" alt-text="A screenshot of the controller view showing failed requests.":::

Select the node and then **Investigate Pods** in the AKS monitoring tile.

## Advanced onboarding (custom resources)

Use the Kubernetes custom resources when you need more control. For more information, see [Per deployment onboarding](kubernetes-codeless.md#per-deployment-onboarding).

### Autoinstrumentation (Java, Node.js)

Follow the **namespace-wide** or **per-deployment** onboarding guidance in the article linked earlier to inject the Azure Monitor OpenTelemetry distribution into your pods.

To participate in the limited public preview of Autoinstrumentation for .NET or Python, see [Enable AKS autoinstrumentation for Python and .NET (limited preview)](kubernetes-codeless-python-net.md).

### Autoconfiguration (apps already instrumented with OpenTelemetry SDKs)

Autoconfiguration sets environment variables so existing SDKs export telemetry to Application Insights through the Azure Monitor Agent on the cluster. It doesn't place any SDK on the pod.

- **Namespace-wide**: Set the **Instrumentation** custom resource with an empty platforms list.
  ```yml
  apiVersion: monitor.azure.com/v1
  kind: Instrumentation
  metadata:
    name: cr1
    namespace: mynamespace1
  spec:
    settings:
      autoInstrumentationPlatforms: []
    destination: # required
      applicationInsightsConnectionString: "InstrumentationKey=11111111-1111-1111-1111-111111111111;IngestionEndpoint=https://eastus2-3.in.applicationinsights.azure.com/;LiveEndpoint=https://eastus2.livediagnostics.monitor.azure.com/"
  ```
- **Per-deployment**: Add the annotation to the deployment and reference your instrumentation custom resource (replace `cr1` with your resource name).
  ```yml
  apiVersion: apps/v1
  kind: Deployment
  ...
  spec:
    template:
      metadata:
        annotations:
          instrumentation.opentelemetry.io/inject-nodejs: "cr1"
  ```

When you use the `inject-configuration` annotation, the `spec.settings.autoInstrumentationPlatforms` setting on the referenced custom resource is ignored and the deployment is configured to send OTLP data to the connection string defined in `applicationInsightsConnectionString`. Use the annotation value `"false"` to exclude a deployment from Autoconfiguration.
  ```yml
  apiVersion: apps/v1
  kind: Deployment
  ...
  spec:
    template:
      metadata:
        annotations:
          instrumentation.opentelemetry.io/inject-nodejs: "false"
  ```

## Limitations

During the preview, the feature is available in all public cloud regions except:

- Israel Central
- Israel North West
- Qatar Central
- UAE North
- UAE Central

If you need programmatic names for these regions, see [Azure regions list](/azure/reliability/regions-list?tabs=all#azure-regions-list-1).

### Limits

- The feature accepts only **OTLP/HTTP** with **binary Protobuf**. It doesn't support JSON payloads or **OTLP/gRPC**. You need to configure your OTLP exporter accordingly.
- The feature supports up to **30** Data Collection Rule (DCR) associations per AKS cluster.
- The tested scale for logs and traces is **50,000 events per second (EPS)**. You can expect approximately **250 MiB** extra memory usage and **0.5 vCPU** per cluster for this feature.

### Unsupported scenarios

- Compression in OpenTelemetry SDK exporters.
- Namespaces with **Istio mutual TLS (mTLS)** enabled.
- **HTTPS** endpoints in the instrumentation configuration.

### Scenarios not validated

- AKS clusters that use an HTTP proxy.
- AKS clusters that use Private Link.
- AKS dual-stack clusters.

## Next steps

- Learn how [codeless instrumentation works for Kubernetes and how to onboard deployments](kubernetes-codeless.md#onboard-deployments).
- Review the **Enable monitoring for AKS clusters** article to understand infrastructure monitoring with Azure Monitor.
- Learn to configure application monitoring with Azure Monitor and OTLP for [other environments](https://aka.ms/otelignitedoc) with the Azure Monitor Agent or the open-source OpenTelemetry Collector.

## Support

If documentation and the steps in this article don't resolve your issue or you want to provide feedback, email the Azure Monitor OpenTelemetry team at [otel@microsoft.com](mailto:otel@microsoft.com).