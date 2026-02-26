---
title: Monitor applications on AKS with Azure Monitor Application Insights (Preview)
description: Azure Monitor integrates seamlessly with your application running on Azure Kubernetes Service and allows you to spot the problems with your apps quickly.
ms.topic: how-to
ms.custom: devx-track-extended-java
ms.date: 04/03/2025
---

# Autoinstrumentation for Azure Kubernetes Service (Preview)

> [!IMPORTANT]
> See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability.

This guide walks through enabling Azure Monitor Application Insights for Azure Kubernetes Service (AKS) workloads without modifying source code.

We cover [installing the aks-preview Azure CLI extension](#install-the-aks-preview-azure-cli-extension), [registering the AzureMonitorAppMonitoringPreview feature flag](#register-the-azuremonitorappmonitoringpreview-feature-flag), [preparing a cluster](#prepare-a-cluster), [onboarding deployments](#onboard-deployments), and [restarting deployments](#restart-deployment). These steps result in autoinstrumentation injecting the Azure Monitor OpenTelemetry Distro in application pods to generate telemetry. For more on autoinstrumentation and its benefits, see [What is autoinstrumentation for Azure Monitor Application Insights?](../app/codeless-overview.md).


## Prerequisites

* An [AKS cluster](/azure/aks/learn/quick-kubernetes-deploy-portal) running a [kubernetes deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) using Java or Node.js in the Azure public cloud
* [A workspace-based Application Insights resource](../app/create-workspace-resource.md#create-and-configure-application-insights-resources).
* Azure CLI 2.60.0 or greater. For more information, see [How to install the Azure CLI](/cli/azure/install-azure-cli), [What version of the Azure CLI is installed?](/cli/azure/install-azure-cli#what-version-of-the-azure-cli-is-installed), and [How to update the Azure CLI](/cli/azure/update-azure-cli).

> [!WARNING]
> - This feature is incompatible with both Windows (any architecture) and Linux Arm64 node pools.

## Install the AKS-preview Azure CLI extension

[!INCLUDE [preview features callout](~/reusable-content/ce-skilling/azure/includes/aks/includes/preview/preview-callout.md)]

Install the `aks-preview` extension:

```azurecli
az extension add --name aks-preview
```

Update to the latest version of the extension:

```azurecli
az extension update --name aks-preview
```

Verify that the installed Azure CLI version meets the requirement in the [Prerequisites](#prerequisites) section:

```azurecli
az version
```

If the version doesn't meet the requirement, follow the steps mentioned earlier to install and update Azure CLI.

## Register the `AzureMonitorAppMonitoringPreview` feature flag

```azurecli
# Log into Azure CLI
az login

# Register the feature flag for Azure Monitor App Monitoring in preview
az feature register --namespace "Microsoft.ContainerService" --name "AzureMonitorAppMonitoringPreview"

# List the registration state of the Azure Monitor App Monitoring Preview feature
# It could take hours for the registration state to change from Registering to Registered
az feature list -o table --query "[?contains(name, 'Microsoft.ContainerService/AzureMonitorAppMonitoringPreview')].{Name:name,State:properties.state}"

# Once the feature shows as Registered in the prior step, re-register the Microsoft.ContainerService provider to apply the new feature settings
az provider register --namespace "Microsoft.ContainerService"

# Check the registration state of the Microsoft.ContainerService provider
az provider show --namespace "Microsoft.ContainerService" --query "registrationState"
```

## Prepare a cluster

You can prepare a cluster using either the Azure portal or Azure CLI.

#### [Azure portal](#tab/portal)

Use the Azure portal to prepare a cluster.

1. Select the **Monitor** pane.
1. Check the "Enable application monitoring" box.
1. Select the "Review and enable" button.

:::image type="content" source="media/kubernetes-codeless/prepare-a-cluster-1.png" alt-text="Azure portal screenshot showing how to enable Application monitoring for an AKS cluster under monitor settings along with Prometheus, Grafana, and Log Analytics options." lightbox="media/kubernetes-codeless/prepare-a-cluster-1.png":::

#### [Azure CLI](#tab/programmatic)

To prepare a cluster, run the following Azure CLI command.

```azurecli
az aks update --resource-group={resource_group} --name={cluster_name} --enable-azure-monitor-app-monitoring 
```

> [!TIP]
> AKS Clusters can be prepared for this feature during cluster creation. To learn more, see [Prepare a cluster during AKS cluster create](#prepare-a-cluster-during-aks-cluster-create).

---

## Onboard deployments

Deployments can be onboarded in two ways: _namespace-wide_ or _per-deployment_. Use the namespace-wide method to onboard all deployments within a namespace. For selective or variably configured onboarding across multiple deployments, employ the per-deployment approach.

### Namespace-wide onboarding

#### [Azure portal](#tab/portal)

Use the Azure portal for namespace-wide deployment onboarding.

1. From the **Namespaces** pane, choose the namespace to be instrumented.

:::image type="content" source="media/kubernetes-codeless/deployment-1.png" alt-text="Azure portal view showing namespaces and an application monitoring button." lightbox="media/kubernetes-codeless/deployment-1.png":::

2. Select **Application Monitoring**.

:::image type="content" source="media/kubernetes-codeless/deployment-2.png" alt-text="Azure portal view showing configuration of application monitoring for the namespace, including options to select an Application Insights resource, choose language settings, and review unconfigured deployments." lightbox="media/kubernetes-codeless/deployment-2.png":::

3. Select the languages to be instrumented.
4. Leave the **Perform rollout restart of all deployments** box unchecked. You should manually [restart deployments](#restart-deployment) later.
5. Select **Configure**.

:::image type="content" source="media/kubernetes-codeless/deployment-3.png" alt-text="Azure portal view showing configuration of application monitoring for the namespace, where both Node.js and Java are selected for autoinstrumentation." lightbox="media/kubernetes-codeless/deployment-3.png":::

6. Observe the **Application Monitoring Progress** and wait for it to complete.

> [!NOTE]
> * The affected deployments must be restarted before the changes take effect.
> * Manually [restart deployments](#restart-deployment) if you observe progress failures.

:::image type="content" source="media/kubernetes-codeless/app-monitoring-progress.png" alt-text="Azure portal view showing the progress of application monitoring instrumentation." lightbox="media/kubernetes-codeless/app-monitoring-progress.png":::

7. Revisit the **Application Monitoring** section.
8. Verify the "instrumented" status for each namespace in the deployment.

:::image type="content" source="media/kubernetes-codeless/deployment-4.png" alt-text="Azure portal screenshot showing deployments as Instrumented." lightbox="media/kubernetes-codeless/deployment-4.png":::

#### [YAML](#tab/programmatic)

To onboard all deployments within a namespace, create a single _Instrumentation_ custom resource named `default` in each namespace. Update `applicationInsightsConnectionString` to have the connection string of your Application Insights resource.

> [!TIP]
> You can retrieve connection string from the overview page of your Application Insights resource.

```yml
apiVersion: monitor.azure.com/v1
kind: Instrumentation
metadata:
  name: default
  namespace: mynamespace1
spec:
  settings:
    autoInstrumentationPlatforms: []
  destination: # required
    applicationInsightsConnectionString: "InstrumentationKey=11111111-1111-1111-1111-111111111111;IngestionEndpoint=https://eastus2-3.in.applicationinsights.azure.com/;LiveEndpoint=https://eastus2.livediagnostics.monitor.azure.com/"
```

At a minimum, the following configuration is required:

- `spec.settings.autoInstrumentationPlatforms`: One or more values based on the languages your pods are running.
- `spec.destination.applicationInsightsConnectionString`: The connections string of an Application Insights resource. 

> [!TIP]
> - Use [annotations](#annotations) if per-deployment overrides are required. For more information, see [annotations](#annotations).
> - [Restart deployments](#restart-deployment) for settings to take effect.

---

### Per-deployment onboarding

Use per-deployment onboarding to ensure deployments are instrumented with specific languages or to direct telemetry to separate Application Insights resources.

1. Create a unique _Instrumentation_ custom resource for each scenario. Avoid using the name `default`, which is used for namespace-wide onboarding.

    Create _Instrumentation_ custom resources to configure Application Insights in each namespace. Update `applicationInsightsConnectionString` to have the connection string of your Application Insights resource. 

    > [!TIP]
    > You can retrieve connection string from the overview page of your Application Insights resource.

    
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
    - `spec.destination.applicationInsightsConnectionString`: The connections string of an Application Insights resource.

3. Associate each deployment with the appropriate custom resource using [annotations](#annotations). The annotation overrides the language set in the custom resource.

    > [!IMPORTANT]
    > To avoid adding them to the deployment's annotations by mistake, add annotations at the `spec.template.metadata.annotations` level of your deployment.

    Examples:
    - Java: `instrumentation.opentelemetry.io/inject-java: "cr1"`
    - Node.js: `instrumentation.opentelemetry.io/inject-nodejs: "cr1"`
    
    Annotation placement should look as follows.

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

Use mixed mode when most deployments use a default configuration and a few deployments must use different configurations.

1. Implement [namespace-wide onboarding](#onboard-deployments) to define the default configuration.
2. Create [per-deployment onboarding](#per-deployment-onboarding) configurations, which override the default configuration for specific resources.

---

## Restart deployment

You can restart a deployment using either the Azure portal or the Kubernetes command line (`kubectl`) tool.

Run the following command after all custom resources are created and deployments are optionally annotated.

```shell
kubectl rollout restart deployment <deployment-name> -n mynamespace1
```

This command causes autoinstrumentation to take effect, enabling Application Insights. You can verify Application Insights is enabled by generating traffic and navigating to your resource. Your app is represented as a cloud role in Application Insights experiences. You're able to use all Application Insights Experiences except Live Metrics and Application Insights Code Analysis features. Learn more about the available Application Insights experiences [here](../app/app-insights-overview.md#application-insights-experiences).

## Remove Autoinstrumentation for AKS

You can remove AKS autoinstrumentation using either the Azure portal or Azure CLI.

> [!TIP]
> * Removing AKS autoinstrumentation by using the Azure portal or Azure CLI removes it from the entire cluster.
> * To remove autoinstrumentation from a single namespace, delete the associated **Instrumentation** custom resource (CR). (for example, `kubectl delete instrumentation <instrumentation-name> -n <namespace-name>`) 

#### [Azure portal](#tab/portal)

Use the Azure portal to remove autoinstrumentation from the cluster.

1. Select the **Monitor** section.
2. Uncheck the **Enable application monitoring** box.
3. Select **Review + enable**.

:::image type="content" source="media/kubernetes-codeless/remove.png" alt-text="Azure portal view of the monitor settings pane for an AKS cluster showing monitoring capabilities." lightbox="media/kubernetes-codeless/remove.png":::

#### [Azure CLI](#tab/programmatic)

Ensure that you don't have any instrumented deployments. To uninstrument an instrumented deployment, remove the associated Instrumentation custom resource and run `kubectl rollout restart` on the deployment. Next run the following command.

```azurecli
az aks update --resource-group={resource_group} --name={cluster_name} --disable-azure-monitor-app-monitoring 
```

 > [!NOTE]
 > If instrumented deployments remain after the feature is disabled, they continue to be instrumented until redeployed to their original uninstrumented state or deleted.

---

## Annotations

### Disabling autoinstrumentation

The following annotations disable autoinstrumentation.

- Java: `instrumentation.opentelemetry.io/inject-java`
- Node.js: `instrumentation.opentelemetry.io/inject-nodejs`

  ```yml
  instrumentation.opentelemetry.io/inject-java: "false"
  ```
To turn autoinstrumentation back on after disabling.

  ```yml
  instrumentation.opentelemetry.io/inject-java: "true"
  ```

Annotation placement should look as follows.

```yml
apiVersion: apps/v1
kind: Deployment
...
spec:
  template:
    metadata:
      annotations:
        instrumentation.opentelemetry.io/inject-java: "false"
```

### Enabling logs in Application Insights

You can opt to collect logs in Application Insights as an addition to or replacement for Container Insights logs. 

Enabling logs in Application Insights provide correlated logs, allowing users to easily view distributed traces alongside their related logs. Further, some microservices don't write logs to the console so Container Insights isn't able to collect them and only Application Insights instrumentation captures these logs.

Conversely, Application Insights might not be able to instrument all microservices. As an example, those using NGINX or unsupported languages. Users might prefer to rely on container logs only for such microservices.

You can also choose to enable both sources for logs if you have multiple observability teams such as infra engineers using Container Insights and developers using Application Insights.

Review the console logging configurations in your application's code to determine whether you want to enable Application Insights Logs, container logs, or both. If you disable container log collection, see [Filter container log collection with ConfigMap](../containers/kubernetes-data-collection-configmap.md).

> [!IMPORTANT]
> To avoid unnecessary duplication and increased cost, enable logs in Application Insights to allow the feature to collect application logs from standard logging frameworks and send them to Application Insights.

Use the following annotation to enable logs in Application Insights

- monitor.azure.com/enable-application-logs

> [!IMPORTANT]
> To avoid adding them to the deployment's annotations by mistake, add annotations at the `spec.template.metadata.annotations` level of your deployment.

  ```yml
  monitor.azure.com/enable-application-logs: "true"
  ```

## Prepare a cluster during AKS cluster create

AKS Clusters can be prepared for this feature during cluster creation. Run the following Azure CLI command if you prefer to have the cluster prepped during creation. Application monitoring isn't enabled just because your cluster is prepped. You must deploy an application and onboard the application to this feature.

```azurecli
az aks create --resource-group={resource_group} --name={cluster_name} --enable-azure-monitor-app-monitoring --generate-ssh-keys
```

## Frequently asked questions

## Autoinstrumentation for Azure Kubernetes Service

### Does Azure Kubernetes Service (AKS) autoinstrumentation support custom metrics?

If you want custom metrics in Node.js, manually instrument applications with the [Azure Monitor OpenTelemetry Distro](../app/opentelemetry-enable.md)

Java allows custom metrics with autoinstrumentation. You can [collect custom metrics](../app/opentelemetry-add-modify.md?tabs=java#add-custom-metrics) by updating your code and enabling this feature. If your code already has custom metrics, then they flow through when autoinstrumentation is enabled.

---

### Does AKS autoinstrumentation work with applications instrumented with an Open Source Software (OSS) OpenTelemetry SDK?

AKS autoinstrumentation can disrupt the telemetry sent to third parties by an OSS OpenTelemetry SDK.

### Can AKS autoinstrumentation coexist with manual instrumentation?

AKS autoinstrumentation is designed to coexist with both manual instrumentation options: the Application Insights classic API SDK and OpenTelemetry Distro.

It always prevents duplicate data and ensures custom metrics work.

Refer to this chart to determine when autoinstrumentation or manual instrumentation takes precedence.

| Language | Precedence             |
|----------|------------------------|
| Node.js  | Manual instrumentation |
| Java     | Autoinstrumentation    |

### How do I ensure I'm using the latest and most secure versions of Azure Monitor OpenTelemetry Distro?

Vulnerabilities detected in the Azure Monitor OpenTelemetry Distro are prioritized, fixed, and released in the next version.

AKS autoinstrumentation injects the latest version of the Azure Monitor OpenTelemetry Distro into your application pods every time your deployment is changed or restarted.

The OpenTelemetry Distro can become vulnerable on deployments that aren't changed or restarted for extended periods of time. For this reason, we suggest updating or restarting deployments weekly to ensure a recent version of the Distro is being used.

### How do I learn more about the Azure Monitor OpenTelemetry Distro?

This feature achieves autoinstrumentation by injecting Azure Monitor OpenTelemetry Distro into application pods.

For Java, this feature integrates the standalone Azure Monitor OpenTelemetry Distro for Java. See our [Java distro documentation](../app/opentelemetry-enable.md?tabs=java) to learn more about the Java instrumentation binary.

For Node.js, we inject an autoinstrumentation binary based on our Azure Monitor OpenTelemetry Distro for Node.js. For more information, see [Node.js distro documentation](../app/opentelemetry-enable.md?tabs=nodejs). Keep in mind that we don't have a standalone autoinstrumentation for Node.js so our distro documentation is geared towards manual instrumentation. You can ignore code-based configuration steps related to manual instrumentation. However, everything else in our distro documentation such as default settings and environment variable configurations is applicable to this feature.

### Where can I get more information about autoinstrumentation for AKS?

For more information, see [Autoinstrumentation for AKS](../containers/kubernetes-codeless.md).

## Next steps
- To review frequently asked questions (FAQ), see [Autoinstrumentation for Azure Kubernetes Service FAQ](../app/application-insights-faq.yml#autoinstrumentation-for-azure-kubernetes-service)
- To review our dedicated troubleshooting guide, see [Troubleshooting autoinstrumentation for Azure Kubernetes Service](/troubleshoot/azure/azure-monitor/app-insights/telemetry/troubleshoot-aks-autoinstrumentation).
- Learn more about [Azure Monitor](../overview.md) and [Application Insights](../app/app-insights-overview.md).