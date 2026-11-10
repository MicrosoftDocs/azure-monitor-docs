---
title: Set up codeless monitoring for AKS with Application Insights
description: Enable codeless application monitoring on AKS by using Azure Monitor Application Insights autoinstrumentation for Java and Node.js workloads.
ms.topic: how-to
ms.custom: devx-track-extended-java
ms.date: 11/06/2026
ai-usage: ai-assisted
---

# Autoinstrument AKS apps with Azure Monitor Application Insights

This guide shows how to enable Azure Monitor Application Insights for Azure Kubernetes Service (AKS) workloads without modifying source code.

It covers [preparing a cluster](#prepare-a-cluster), [onboarding deployments](#onboard-deployments), [restarting deployments](#restart-deployment), and [viewing application performance metrics](#view-application-performance-metrics-in-aks). These steps autoinstrument the application pods by injecting language-specific OpenTelemetry instrumentation to generate telemetry. For more information about autoinstrumentation and its benefits, see [What is autoinstrumentation for Azure Monitor Application Insights?](../app/codeless-overview.md)

> [!NOTE]
> To participate in the limited public preview of Autoinstrumentation for .NET or Python, see [Enable AKS autoinstrumentation for Python and .NET (limited preview)](kubernetes-codeless-python-net.md).

## Prerequisites

* An [AKS cluster](/azure/aks/learn/quick-kubernetes-deploy-portal) running a [Kubernetes deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) that uses Java or Node.js in the Azure public cloud
* [A workspace-based Application Insights resource](../app/create-workspace-resource.md#create-and-configure-application-insights-resources). To create one with a template, download the matching files:
  - **Bicep:** [Template](https://github.com/microsoft/Docker-Provider/blob/ci_prod/scripts/onboarding/aks/application-monitoring/bicep/application-insights-codeless.bicep) and [parameter file](https://github.com/microsoft/Docker-Provider/blob/ci_prod/scripts/onboarding/aks/application-monitoring/bicep/application-insights-codeless.parameters.json).
  - **ARM:** [Template](https://github.com/microsoft/Docker-Provider/blob/ci_prod/scripts/onboarding/aks/application-monitoring/arm/application-insights-codeless.json) and [parameter file](https://github.com/microsoft/Docker-Provider/blob/ci_prod/scripts/onboarding/aks/application-monitoring/arm/application-insights-codeless.parameters.json).

  | Parameter | Description |
  | --- | --- |
  | `applicationInsightsName` | Name of the Application Insights component. |
  | `location` | Azure region for Application Insights and the Log Analytics workspace. |
  | `createLogAnalyticsWorkspace` | When `true`, create a Log Analytics workspace. When `false`, reuse `logAnalyticsWorkspaceResourceId`. |
  | `logAnalyticsWorkspaceName` | Name for a new Log Analytics workspace. |
  | `logAnalyticsWorkspaceResourceId` | Existing Log Analytics workspace resource ID when `createLogAnalyticsWorkspace=false`. |
  | `workspaceRetentionInDays` | Retention period for a new Log Analytics workspace, from 30 through 730 days. |
  | `tags` | Optional tags to apply to Application Insights and a new Log Analytics workspace. |

  Edit the parameter file. Use a unique `logAnalyticsWorkspaceName`, or set `createLogAnalyticsWorkspace=false` and provide `logAnalyticsWorkspaceResourceId`. Deploy the template and parameter file by using any valid Resource Manager deployment method. For examples, see [Deploy the sample templates](../fundamentals/resource-manager-samples.md#deploy-the-sample-templates).
* Azure CLI 2.86.0 or greater. For more information, see [How to install the Azure CLI](/cli/azure/install-azure-cli), [What version of the Azure CLI is installed?](/cli/azure/install-azure-cli#what-version-of-the-azure-cli-is-installed), and [How to update the Azure CLI](/cli/azure/update-azure-cli).

> [!WARNING]
> This feature supports Linux node pools only. Windows node pools aren't supported.

## Prepare a cluster

You can prepare a cluster by using the Azure portal, Azure CLI, an ARM template, or Bicep.

#### [Azure portal](#tab/portal)

Use the Azure portal to prepare a cluster.

1. In the AKS resource, select **Monitor (Insights)**, and then select **Monitor Settings**.
1. On the **Capabilities** tab, select **Enable support for auto-instrumentation**.
   :::image type="content" source="media/kubernetes-codeless/monitor-settings-enable-autoinstrumentation.png" alt-text="Screenshot of the Monitor Settings Capabilities tab with the Enable support for auto-instrumentation checkbox selected." lightbox="media/kubernetes-codeless/monitor-settings-enable-autoinstrumentation.png":::
1. Review any other selected monitoring capabilities and workspace choices.
1. Select **Review + enable**, confirm the summary, and then select **Enable**.

#### [Azure CLI](#tab/programmatic)

To prepare a cluster, run the following Azure CLI command.

```azurecli
az aks update --resource-group={resource_group} --name={cluster_name} --enable-azure-monitor-app-monitoring 
```

#### [Bicep/ARM](#tab/bicep-arm)

##### Download the template and parameter file

- **Bicep:** [Template](https://github.com/microsoft/Docker-Provider/blob/ci_prod/scripts/onboarding/aks/application-monitoring/bicep/aks-app-monitoring-profile.bicep) and [parameter file](https://github.com/microsoft/Docker-Provider/blob/ci_prod/scripts/onboarding/aks/application-monitoring/bicep/aks-app-monitoring-profile.parameters.json).
- **ARM:** [Template](https://github.com/microsoft/Docker-Provider/blob/ci_prod/scripts/onboarding/aks/application-monitoring/arm/aks-app-monitoring-profile.json) and [parameter file](https://github.com/microsoft/Docker-Provider/blob/ci_prod/scripts/onboarding/aks/application-monitoring/arm/aks-app-monitoring-profile.parameters.json).

##### Configure the parameters

| Parameter | Description |
| --- | --- |
| `clusterName` | Name of the existing AKS cluster. |
| `clusterLocation` | Azure region of the AKS cluster. |

##### Deploy the template

Edit the matching parameter file. Keep the application-monitoring profile values as provided. Deploy the template and parameter file to the resource group that contains the AKS cluster by using any valid Resource Manager deployment method. For examples, see [Deploy the sample templates](../fundamentals/resource-manager-samples.md#deploy-the-sample-templates).

---

Before onboarding workloads, wait for the autoinstrumentation webhook to exist and become available:

```shell
kubectl --namespace kube-system get deployment app-monitoring-webhook
kubectl --namespace kube-system rollout status deployment/app-monitoring-webhook --timeout=10m
```

If the first command returns `NotFound`, wait for AKS reconciliation and retry it before continuing.

> [!TIP]
> You can prepare AKS clusters for this feature during cluster creation. To learn more, see [Prepare a cluster during AKS cluster create](#prepare-a-cluster-during-aks-cluster-create).

## Onboard deployments

You can onboard deployments in two ways: _namespace-wide_ or _per-deployment_. Use the namespace-wide method to onboard all deployments within a namespace. For selective or variably configured onboarding across multiple deployments, use the per-deployment approach.

### Namespace-wide onboarding

#### [Azure portal](#tab/portal-namespace)

Use the Azure portal for namespace-wide deployment onboarding.

1. From the **Namespaces** pane, select the namespace to instrument.  
  :::image type="content" source="media/kubernetes-codeless/namespaces-select-namespace.png" alt-text="Screenshot of the AKS Namespaces pane listing available namespaces with Kubernetes resources and Namespaces highlighted." lightbox="media/kubernetes-codeless/namespaces-select-namespace.png":::
1. Select **Application Monitoring**.
  :::image type="content" source="media/kubernetes-codeless/configure-monitoring-select-language.png" alt-text="Screenshot of the Configure Application Monitoring panel with the Instrumentation Type dropdown expanded showing language options." lightbox="media/kubernetes-codeless/configure-monitoring-select-language.png":::
1. In **Application Insights**, select an existing workspace-based resource. Keep a value that begins with **(New)** only if you intend to create another Application Insights resource. Verify whether the portal will create or reuse its Log Analytics workspace.
1. Select the languages to instrument.
1. Leave the **Perform rollout restart of all deployments** box unchecked. You should manually [restart deployments](#restart-deployment) later.
1. Select **Configure**.  
  :::image type="content" source="media/kubernetes-codeless/configure-monitoring-java-selected.png" alt-text="Screenshot of the Configure Application Monitoring panel with Java selected and the rollout restart checkbox unchecked." lightbox="media/kubernetes-codeless/configure-monitoring-java-selected.png":::
1. Wait until the application monitoring deployment is complete.
    > [!NOTE]
    > The affected deployments must be restarted before the changes take effect.
1. Complete [Restart deployment](#restart-deployment). After the rollout finishes, return to **Application Monitoring**.
1. Verify the **Instrumented** status for each deployment in the namespace.
  :::image type="content" source="media/kubernetes-codeless/configure-monitoring-verify-instrumented.png" alt-text="Screenshot of the Configure Application Monitoring panel with the Deployments section expanded showing Instrumented status." lightbox="media/kubernetes-codeless/configure-monitoring-verify-instrumented.png":::
1. Generate traffic and confirm that telemetry appears in the Application Insights resource you intended to use.

#### [YAML](#tab/yaml-namespace)

To onboard all deployments within a namespace, create a single _Instrumentation_ custom resource named `default` in each namespace. Update `applicationInsightsConnectionString` to have the connection string of your Application Insights resource.

> [!TIP]
> You can retrieve the connection string from the overview page of your Application Insights resource.

You can start with the downloadable [namespace-wide Instrumentation YAML sample](https://github.com/microsoft/Docker-Provider/blob/ci_prod/scripts/onboarding/aks/application-monitoring/kubernetes/instrumentation-codeless.yaml). The sample defaults to Java. Replace `Java` with `NodeJs` for a Node.js-only namespace.

```yml
apiVersion: monitor.azure.com/v1
kind: Instrumentation
metadata:
  name: default
  namespace: mynamespace1
spec:
  settings:
    autoInstrumentationPlatforms: ["Java"]
  destination: # required
    applicationInsightsConnectionString: "InstrumentationKey=11111111-1111-1111-1111-111111111111;IngestionEndpoint=https://eastus2-3.in.applicationinsights.azure.com/;LiveEndpoint=https://eastus2.livediagnostics.monitor.azure.com/"
```

At a minimum, the following configuration is required:

- `spec.settings.autoInstrumentationPlatforms`: One or more values based on the languages your pods are running.
- `spec.destination.applicationInsightsConnectionString`: The connection string of an Application Insights resource. 

> [!TIP]
> - Use [annotations](#annotations) if per-deployment overrides are required.
> - [Restart deployments](#restart-deployment) for settings to take effect.

---

### Per-deployment onboarding

Use per-deployment onboarding to ensure deployments are instrumented with specific languages or to direct telemetry to separate Application Insights resources.

1. Create a unique _Instrumentation_ custom resource for each scenario. Avoid using the name `default`, which is used for namespace-wide onboarding.

    Create _Instrumentation_ custom resources to configure Application Insights in each namespace. Update `applicationInsightsConnectionString` to have the connection string of your Application Insights resource. 

    You can start with the downloadable [per-deployment Instrumentation YAML sample](https://github.com/microsoft/Docker-Provider/blob/ci_prod/scripts/onboarding/aks/application-monitoring/kubernetes/instrumentation-per-deployment.yaml).

    > [!TIP]
    > You can retrieve the connection string from the overview page of your Application Insights resource.

    
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
    
    At a minimum, the following configuration is required:

    - `spec.settings.autoInstrumentationPlatforms`: For a non-default custom resource, set this required field to an empty array (`[]`). The deployment annotation determines the language.
    - `spec.destination.applicationInsightsConnectionString`: The connection string of an Application Insights resource.

1. Associate each deployment with the appropriate custom resource using [annotations](#annotations). The annotation selects the custom resource and the language to instrument.

    > [!IMPORTANT]
    > To avoid adding them to the deployment's annotations by mistake, add annotations at the `spec.template.metadata.annotations` level of your deployment.

    For complete Java and Node.js deployment examples, see the [workload autoinstrumentation YAML sample](https://github.com/microsoft/Docker-Provider/blob/ci_prod/scripts/onboarding/aks/application-monitoring/kubernetes/workload-autoinstrumentation.example.yaml).

    Examples:
    - Java: `instrumentation.opentelemetry.io/inject-java: "cr1"`
    - Node.js: `instrumentation.opentelemetry.io/inject-nodejs: "cr1"`
    
    Place the annotations as follows.

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

    > [!TIP]
    > [Restart deployments](#restart-deployment) for settings to take effect.

### Mixed mode onboarding

Use mixed mode when most deployments use a default configuration and a few deployments need different configurations.

1. Implement [namespace-wide onboarding](#onboard-deployments) to define the default configuration.
1. Create [per-deployment onboarding](#per-deployment-onboarding) configurations to override the default configuration for specific resources.

---

## Restart deployment

You can restart a deployment from **Run command** in the AKS resource or from a terminal that has `kubectl` access.

Run the following command after you create all custom resources and optionally annotate deployments.

```shell
kubectl rollout restart deployment <deployment-name> -n mynamespace1
```

In the Azure portal, open **Run command**, enter the same command, make sure **Dry Run** is off, and then select **Send**.

ARM templates and Bicep don't have a native resource for a Kubernetes rollout restart.

This command causes autoinstrumentation to take effect, enabling Application Insights. You can verify Application Insights is enabled by generating traffic and navigating to your resource. Your app is represented as a cloud role in Application Insights experiences. You can use all Application Insights experiences except Live Metrics and Code Analysis. To learn more about the available Application Insights experiences, see [Application Insights experiences](../app/app-insights-overview.md#application-insights-experiences).

## View application performance metrics in AKS

When you autoinstrument workloads, application performance metrics appear directly inside the AKS resource blades. You can see how the application is performing without leaving the cluster. These views surface a small set of high-signal metrics for triage. Use Application Insights for full Application Performance Monitoring (APM).

Each scope shows three metrics:

- **Server response time**: Latency and responsiveness of incoming requests.
- **Server requests**: Application load and traffic volume.
- **Failures**: Errors and failed requests.

These metrics appear at three scopes:

- **Namespace**: The **Application performance metrics** tile on the namespace overview aggregates per workload, with top average server response time, top server requests, and top failed requests.
- **Workload (Deployment)**: The deployment overview shows time series across all pods in the workload, with a **View in Application Insights** deep link for full APM.
- **Pod**: The pod overview shows the same time series charts scoped to a single pod.

### View metrics at the namespace scope

1. From your AKS cluster, select **Kubernetes resources** > **Namespaces** in the left navigation.
1. Select the namespace that contains your instrumented workloads.
1. Locate the **Application performance metrics** tile on the namespace overview.

  :::image type="content" source="media/kubernetes-codeless/namespace-application-performance-metrics.png" alt-text="Screenshot of the AKS namespace overview showing the Application performance metrics tile with top average server response time, top server requests, and top failed requests." lightbox="media/kubernetes-codeless/namespace-application-performance-metrics.png":::

### View metrics at the workload scope

1. From your AKS cluster, select **Kubernetes resources** > **Workloads**, and then select the **Deployments** tab.
1. Select an instrumented deployment.
1. Review the time series charts on the deployment overview: Average server response time, Server requests, and Failed requests.
1. Select **View in Application Insights** to open the workload in the full Application Insights experience.

  :::image type="content" source="media/kubernetes-codeless/deployment-application-performance-metrics.png" alt-text="Screenshot of the AKS deployment overview showing the Average server response time, Server requests, and Failed requests charts with the View in Application Insights link." lightbox="media/kubernetes-codeless/deployment-application-performance-metrics.png":::

### View metrics at the pod scope

1. From the deployment overview, scroll to the **Workloads** section and select the **Pods** tab.
1. Select a pod name to open the pod overview.
1. Review the time series charts on the pod overview, scoped to just that pod: Average server response time, Server requests, and Failed requests.
1. Select **View in Application Insights** on any chart to open the pod in the full Application Insights experience.

  :::image type="content" source="media/kubernetes-codeless/pod-application-performance-metrics.png" alt-text="Screenshot of the AKS pod overview showing the Application performance metrics section with Average server response time, Server requests, and Failed requests charts scoped to a single pod." lightbox="media/kubernetes-codeless/pod-application-performance-metrics.png":::

For full APM analysis, including distributed traces, end-to-end transactions, and the Failures and Performance blades, use the [Application Insights overview](../app/app-insights-overview.md).

## Remove autoinstrumentation for AKS

You can remove AKS autoinstrumentation by using Azure CLI, an ARM template, or Bicep.

> [!TIP]
> * Disabling AKS autoinstrumentation at the cluster level removes the webhook from the entire cluster. Clean up instrumented deployments before you disable it.
> * To remove autoinstrumentation from a single namespace, delete the associated **Instrumentation** custom resource (CR). For example, `kubectl delete instrumentation <instrumentation-name> -n <namespace-name>`.

Ensure that you don't have any instrumented deployments. To uninstrument a deployment, remove the associated Instrumentation custom resource and run `kubectl rollout restart` on the deployment while autoinstrumentation is still enabled. Then disable autoinstrumentation at the cluster level.

#### [Azure CLI](#tab/cli-remove)

```azurecli
az aks update --resource-group={resource_group} --name={cluster_name} --disable-azure-monitor-app-monitoring 
```

#### [Bicep/ARM](#tab/bicep-arm-remove)

##### Download the template and parameter file

- **Bicep:** [Template](https://github.com/microsoft/Docker-Provider/blob/ci_prod/scripts/onboarding/aks/application-monitoring/bicep/aks-app-monitoring-profile.bicep) and [parameter file](https://github.com/microsoft/Docker-Provider/blob/ci_prod/scripts/onboarding/aks/application-monitoring/bicep/aks-app-monitoring-profile.parameters.json).
- **ARM:** [Template](https://github.com/microsoft/Docker-Provider/blob/ci_prod/scripts/onboarding/aks/application-monitoring/arm/aks-app-monitoring-profile.json) and [parameter file](https://github.com/microsoft/Docker-Provider/blob/ci_prod/scripts/onboarding/aks/application-monitoring/arm/aks-app-monitoring-profile.parameters.json).

##### Deploy the template

Edit the matching parameter file. Set `autoInstrumentationEnabled=false` and keep the other application-monitoring profile values as provided. Deploy the template and parameter file to the resource group that contains the AKS cluster by using any valid Resource Manager deployment method. For examples, see [Deploy the sample templates](../fundamentals/resource-manager-samples.md#deploy-the-sample-templates).

---

> [!NOTE]
> If instrumented deployments remain after the feature is disabled, they continue to be instrumented. Restore the webhook and restart them after removing their `Instrumentation` resources, or replace or delete and recreate them from the original uninstrumented manifests. `kubectl apply` alone doesn't remove previously injected fields.

## Annotations

Annotations let you customize autoinstrumentation behavior at the deployment level, including disabling instrumentation for specific deployments and enabling application log collection in Application Insights.

### Disabling autoinstrumentation

The following annotations disable autoinstrumentation:

- Java: `instrumentation.opentelemetry.io/inject-java`
- Node.js: `instrumentation.opentelemetry.io/inject-nodejs`

  ```yml
  instrumentation.opentelemetry.io/inject-java: "false"
  ```

### Enabling logs in Application Insights

You can collect logs in Application Insights as an addition to or replacement for Container Insights logs. 

When you enable logs in Application Insights, you get correlated logs, so you can easily view distributed traces alongside their related logs. Some microservices don't write logs to the console, so Container Insights can't collect them. Only Application Insights instrumentation captures these logs.

Conversely, Application Insights might not be able to instrument all microservices. For example, it can't instrument those that use NGINX or unsupported languages. You might prefer to rely on container logs only for such microservices.

If you have multiple observability teams, such as infrastructure engineers using Container Insights and developers using Application Insights, you can choose to enable both sources for logs.

Review the console logging configurations in your application's code to determine whether you want to enable Application Insights Logs, container logs, or both. To disable container log collection, see [Filter container log collection with ConfigMap](../containers/kubernetes-data-collection-configmap.md).

> [!IMPORTANT]
> Enabling Application Insights application logs can duplicate logs that Container Insights already collects and can increase ingestion cost. Enable this annotation only when you need Application Insights logging. If you use it as a replacement for Container Insights logs, filter or disable the duplicate Container Insights collection.

Use the following annotation to enable logs in Application Insights:

- `monitor.azure.com/enable-application-logs`

> [!IMPORTANT]
> To avoid adding them to the deployment's annotations by mistake, add annotations at the `spec.template.metadata.annotations` level of your deployment.

  ```yml
  monitor.azure.com/enable-application-logs: "true"
  ```

## Prepare a cluster during AKS cluster create

You can prepare AKS clusters for this feature during cluster creation by using Azure CLI, an ARM template, or Bicep. Application monitoring isn't enabled just because your cluster is prepared. You must deploy an application and onboard the application to this feature.

#### [Azure CLI](#tab/cli-create)

```azurecli
az aks create --resource-group={resource_group} --name={cluster_name} --enable-azure-monitor-app-monitoring --generate-ssh-keys
```

#### [Bicep/ARM](#tab/bicep-arm-create)

Use API version `2026-06-01` or later, and add `azureMonitorProfile` to the `properties` block of the managed cluster resource in your complete cluster template.

##### Bicep

```bicep
azureMonitorProfile: {
  appMonitoring: {
    autoInstrumentation: {
      enabled: true
    }
  }
}
```

##### ARM

```json
"azureMonitorProfile": {
  "appMonitoring": {
    "autoInstrumentation": {
      "enabled": true
    }
  }
}
```

---

## AKS autoinstrumentation FAQ

The following questions address common scenarios and considerations when using AKS autoinstrumentation, including custom metrics support, compatibility with existing SDKs, and security best practices.

### Does Azure Kubernetes Service (AKS) autoinstrumentation support custom metrics?

Java and Node.js autoinstrumentation can export custom metrics that your code records by using the OpenTelemetry metrics API. To add custom metrics, [update your code to create OpenTelemetry metrics](../app/opentelemetry-add-modify.md#add-custom-metrics). For manual Node.js instrumentation or SDK configuration, use the [Microsoft OpenTelemetry Distro](../app/opentelemetry-enable.md?tabs=nodejs).

### Does AKS autoinstrumentation work with applications instrumented with an Open Source Software (OSS) OpenTelemetry SDK?

AKS autoinstrumentation can disrupt the telemetry sent to third parties by an OSS OpenTelemetry SDK.

### Can AKS autoinstrumentation coexist with manual instrumentation?

AKS autoinstrumentation is designed to coexist with both manual instrumentation options: the Application Insights [classic API](/previous-versions/azure/azure-monitor/app/classic-api) SDK and an OpenTelemetry distro. For manual Node.js instrumentation, use the Microsoft OpenTelemetry Distro. For Java, use the Azure Monitor OpenTelemetry Distro.

It always prevents duplicate data and ensures custom metrics work.

Refer to this chart to determine when autoinstrumentation or manual instrumentation takes precedence.

| Language | Precedence             |
|----------|------------------------|
| Node.js  | Manual instrumentation |
| Java     | Autoinstrumentation    |

<a id="how-do-i-ensure-im-using-the-latest-and-most-secure-versions-of-azure-monitor-opentelemetry-distro"></a>
<a id="how-do-i-ensure-i-m-using-the-latest-and-most-secure-versions-of-azure-monitor-opentelemetry-distro"></a>

### How do I ensure I'm using the latest and most secure instrumentation?

The development team prioritizes and fixes vulnerabilities detected in the injected OpenTelemetry instrumentation in the next version.

AKS autoinstrumentation injects the latest version of the language-specific instrumentation into your application pods every time you change or restart your deployment.

The instrumentation can become vulnerable on deployments that you don't change or restart for extended periods of time. For this reason, update or restart deployments weekly to ensure you're using a recent version.

<a id="how-do-i-learn-more-about-the-azure-monitor-opentelemetry-distro"></a>

### How do I learn more about the OpenTelemetry distros?

This feature achieves autoinstrumentation by injecting language-specific OpenTelemetry instrumentation into application pods.

For Java, this feature integrates the standalone Azure Monitor OpenTelemetry Distro for Java. See the [Java distro documentation](../app/opentelemetry-enable.md?tabs=java) to learn more about the Java instrumentation binary.

For Node.js, the feature injects an OpenTelemetry autoinstrumentation binary. For manual instrumentation, see the [Microsoft OpenTelemetry Distro documentation for Node.js](../app/opentelemetry-enable.md?tabs=nodejs). You can ignore code-based configuration steps related to manual instrumentation when you use AKS autoinstrumentation. Use the AKS configuration guidance in this article for the injected instrumentation.

## Related content
- [Troubleshooting autoinstrumentation for Azure Kubernetes Service](/troubleshoot/azure/azure-monitor/app-insights/telemetry/troubleshoot-aks-autoinstrumentation)
- [Azure Monitor overview](../overview.md)
- [Application Insights overview](../app/app-insights-overview.md)