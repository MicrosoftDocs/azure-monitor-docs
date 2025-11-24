---
title: Monitor AKS applications with OpenTelemetry Protocol (OTLP) (Limited Preview)
description: Enable application monitoring for Azure Kubernetes Service (AKS) namespaces and deployments and send OpenTelemetry Protocol (OTLP) telemetry to Application Insights using Azure Monitor.
ms.topic: how-to
ms.date: 11/11/2025
ms.reviewer: kaprince
ROBOTS: NOINDEX
---

# Monitor AKS applications with OpenTelemetry Protocol (OTLP) Limited Preview

OpenTelemetry provides a standardized way to emit traces, logs, and metrics. Azure Monitor adds **Limited Preview** support for monitoring applications that run on Azure Kubernetes Service (AKS) by using the OpenTelemetry Protocol (OTLP) for instrumentation and data collection.

> [!IMPORTANT]
> This feature is a **limited preview**. Preview features are provided without a service-level agreement and aren't recommended for production workloads. 
>  
> For more information, see [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).

## Key capabilities:

- Enable cluster-level monitoring to install Azure Monitor components on the AKS cluster.
- Create an Application Insights resource with OTLP ingestion enabled.
- Onboard applications at the namespace or deployment scope by using either:
  - **Autoinstrumentation** with the Azure Monitor OpenTelemetry distribution.
  - **Autoconfiguration** for applications already instrumented with the open-source OpenTelemetry Software Development Kits (SDKs).

Telemetry flows to **Application Insights**, where you analyze application performance in context with Container Insights.

> [!IMPORTANT]
> - Unsupported node pools: **Windows (any architecture)** and **Linux Arm64**.
> The preview features are provided without a service-level agreement and aren't recommended for production workloads. 
> For more information, see [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).

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
> The Azure Kubernetes Service (AKS) preview APIs are designed to allow you to test and provide feedback on new features before they become generally available. This AKS-preview needs to be installed before you can register the AzureMonitorAppMonitoringPreview feature flag.

## 1. Register the preview features

1. Sign in and select the target subscription:
   ```bash
   az login
   az account set --subscription "<subscription-name>"
   ```

2. Register the AKS preview feature and provider:
   ```bash
   az feature register --namespace "Microsoft.ContainerService" --name "AzureMonitorAppMonitoringPreview"
   az feature list -o table --query "[?contains(name, 'Microsoft.ContainerService/AzureMonitorAppMonitoringPreview')].{Name:name,State:properties.state}"
   az provider register --namespace "Microsoft.ContainerService"
   az provider show --namespace "Microsoft.ContainerService" --query "registrationState"
   ```

3. Register the Application Insights OTLP preview features and provider:
   ```bash
   az feature register --name OtlpApplicationInsights --namespace Microsoft.Insights
   az feature list -o table --query "[?contains(name, 'Microsoft.Insights/OtlpApplicationInsights')].{Name:name,State:properties.state}"

   az provider register -n Microsoft.Insights
   ```

## 2. Prepare the cluster

1. Ensure the cluster is onboarded to Azure Monitor metrics and logs. Use **Enable monitoring for AKS clusters** in Azure Monitor (Application Insights isn't required yet).
2. In the Azure portal, open the AKS **Monitor** pane and then **Monitor settings**.  
   Turn on **Enable application monitoring** and select **Review + enable**.

If the cluster wasn't previously onboarded, you can enable Managed Prometheus, Container Logs, and application monitoring at the same time.

:::image type="content" source="./media/kubernetes-open-protocol/azure-settings-enable-application.png" alt-text="A screenshot of the Azure settings page showing enable application option.":::

:::image type="content" source="./media/kubernetes-open-protocol/azure-settings-review-enable.png" alt-text="A screenshot of the Azure settings review page showing enable application option.":::

## 3. Create an Application Insights resource with OTLP support

Create or select an Application Insights resource that supports OTLP and uses **Managed workspaces**.

1. In the Azure portal, create a new Application Insights resource.
2. Turn on **Enable OTLP Support (Preview)**.
3. Set **Use managed workspaces** to **Yes**.

:::image type="content" source="./media/kubernetes-open-protocol/application-insights-create-enable.png" alt-text="A screenshot of Create Application Insights resource with enable option selected.":::

> [!IMPORTANT]
> - Use an **Azure Monitor workspace** that's **different** from the workspace used for infrastructure metrics in step 2.
> - Managed workspaces create a separate Azure Monitor workspace for Application Insights application telemetry; use a distinct workspace from the one used for infrastructure metrics.

## 4. Onboard applications to Application Insights

You can onboard **all deployments in a namespace** or target **individual deployments** later.

### 4.1 Open the namespace

1. In the AKS resource, expand **Kubernetes resources**.
2. Open **Namespaces**, then select the namespace that hosts your workloads.

:::image type="content" source="./media/kubernetes-open-protocol/azure-namespaces-list.png" alt-text="A screenshot of the Azure namespaces list under Kubernetes resources.":::

### 4.2 Configure Application Monitoring (Preview)

1. Select **Application Monitoring (Preview)**.
2. Choose the Application Insights resource with OTLP enabled that was created in the [prior step](#3-create-an-application-insights-resource-with-otlp-support). If an Application Insights resource without OTLP is selected or created on demand using the Create New option, the Instrumentation type option used in the next step will not be visible.
3. Choose **Instrumentation type**:
   - **Autoinstrumentation** for supported languages **Java** and **Node.js**.
   - **Autoconfiguration** for applications already instrumented with OpenTelemetry SDKs.  

    > [!NOTE]
    > - Note that the UI only allows you to apply Autoinstrumentation OR Autoconfigruation to a single namespace. If you need to use both options, see [per-deployment onboarding options in - Learn how codeless instrumentation works for Kubernetes and how to onboard deployments](kubernetes-codeless.md#onboard-deployments).

4. Select the **Application language** that applies to the namespace.
5. Leave **Perform rollout restart of all deployments** cleared. You perform the restart manually in the next step.
6. Select **Configure**.

:::image type="content" source="./media/kubernetes-open-protocol/application-configuration-pane.png" alt-text="A screenshot of the configuration pane for application with resource and language selections.":::

### 4.3 Restart deployments to apply changes

Perform a rollout restart for deployments in the target namespace from **Run command** in the portal or from your terminal:

```bash
kubectl rollout restart deployment -n <your-namespace>
```

:::image type="content" source="./media/kubernetes-open-protocol/azure-run-command-rollout.png" alt-text="A screenshot of the Azure run command screen showing rollout restart command.":::

### 4.4 Confirm instrumented status

Return to **Application Monitoring (Preview)** for the namespace. Expand **Deployments in this namespace** and confirm that deployments show **Instrumented** status.

:::image type="content" source="./media/kubernetes-open-protocol/application-deployments-status.png" alt-text="A screenshot of the Application deployments list showing instrumented status.":::

> [!TIP]
> After a few minutes, telemetry appears in the connected Application Insights resource.

## 5. View application signals in Container Insights

Explore application performance in the context of your cluster using Container Insights. From **Monitor** in the AKS resource, open **Controllers** and then select a controller to review request failures, slow operations, and suggested investigations.

:::image type="content" source="./media/kubernetes-open-protocol/azure-controller-performance-view.png" alt-text="A screenshot of the controller view showing performance metrics.":::

:::image type="content" source="./media/kubernetes-open-protocol/azure-controller-performance-alternate-view.png" alt-text="A screenshot of the controller view showing failed requests.":::

To drill down to Container Insights, select an application component node in the Application Map.

Select the node and then **Investigate Pods** in the AKS monitoring tile.

## Advanced onboarding (custom resources)

Use the Kubernetes custom resources when you need more control. Full instructions are available [here](./kubernetes-codeless.md).

### Autoinstrumentation (Java, Node.js)

Follow the **namespace-wide** or **per-deployment** onboarding guidance in the article linked earlier to inject the Azure Monitor OpenTelemetry distribution into your pods.

### Autoconfiguration (apps already instrumented with OpenTelemetry SDKs)

Autoconfiguration sets environment variables so existing SDKs export telemetry to Application Insights through the Azure Monitor Agent on the cluster. It doesn't place any SDK on the pod.

- **Namespace-wide**: Set the **Instrumentation** custom resource with an empty platforms list:
  ```yaml
  spec:
    settings:
      autoInstrumentationPlatforms: []
  ```
- **Per-deployment**: Add the annotation to the deployment and reference your instrumentation custom resource (replace `cr1` with your resource name):
  ```yaml
  metadata:
    annotations:
      instrumentation.opentelemetry.io/inject-configuration: "cr1"
  ```

When you use the `inject-configuration` annotation, the `spec.settings.autoInstrumentationPlatforms` setting on the referenced custom resource is ignored and the deployment is configured to send OTLP data to the connection string defined in `applicationInsightsConnectionString`. Use the annotation value `"false"` to exclude a deployment from Autoconfiguration:
```yaml
metadata:
  annotations:
    instrumentation.opentelemetry.io/inject-configuration: "false"
```

## Known limitations

### Limits

- Accepts **OTLP/HTTP** with **binary Protobuf** only. JSON payloads and **OTLP/gRPC** aren't supported. Configure your OTLP exporter accordingly.
- Supports a maximum of **30** Data Collection Rule (DCR) associations per AKS cluster.
- Tested scale for logs and traces is **50,000 events per second (EPS)**. Expect approximately **250 MiB** extra memory usage and **0.5 vCPU** per cluster for this feature.

### Unsupported scenarios

- Compression in OpenTelemetry SDK exporters.
- Namespaces with **Istio mutual TLS (mTLS)** enabled.
- **HTTPS** endpoints in the instrumentation configuration.

### Scenarios not validated

- AKS clusters that use an HTTP proxy.
- AKS clusters that use Private Link.
- AKS dual-stack clusters.

## Next steps

- Learn how [codeless instrumentation works for Kubernetes and how to onboard deployments](./kubernetes-codeless.md#onboard-deployments).
- Review the **Enable monitoring for AKS clusters** article to understand infrastructure monitoring with Azure Monitor.
- Learn to configure application monitoring with Azure Monitor and OTLP for [other environments](https://aka.ms/otelignitedoc) with the Azure Monitor Agent or the open-source OpenTelemetry Collector.

## Support

If documentation and the steps in this article don't resolve your issue, email the Azure Monitor OpenTelemetry team at **otel@microsoft.com**.