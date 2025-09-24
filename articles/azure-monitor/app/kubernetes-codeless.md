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

This guide walks through enabling Azure Monitor Application Insights for Azure Kubernetes Service (AKS) workloads without modifying source code. Also covered will be options for OpenTelemetry support for both Azure Monitor Distros and non-Microsoft OSS OpenTelemetry SDKs.

We cover [installing the aks-preview Azure CLI extension](#install-the-aks-preview-azure-cli-extension), [registering the AzureMonitorAppMonitoringPreview feature flag](#register-the-azuremonitorappmonitoringpreview-feature-flag), [preparing a cluster](#prepare-a-cluster), [onboarding deployments](#onboard-deployments), and [restarting deployments](#restart-deployment). These steps result in autoinstrumentation injecting the Azure Monitor OpenTelemetry Distro in application pods to generate telemetry. If an application is already instrumented with an OSS OpenTelemetry SDK (regardless of the language) and there's no need for autoinstrumentation - configuring the existing SDK to send OpenTelemetry data to an Application Insights component and an Azure Monitor workspace is also supported. For more on autoinstrumentation and its benefits, see [What is autoinstrumentation for Azure Monitor Application Insights?](codeless-overview.md).


## Prerequisites

* An [AKS cluster](/azure/aks/learn/quick-kubernetes-deploy-portal) running a [kubernetes deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) using Java or Node.js in the Azure public cloud
* [A workspace-based Application Insights resource](create-workspace-resource.md#create-and-configure-application-insights-resources).
* If OpenTelemetry is used, the Application Insights resource must be OTLP-enabled.
* Azure CLI 2.60.0 or greater. For more information, see [How to install the Azure CLI](/cli/azure/install-azure-cli), [What version of the Azure CLI is installed?](/cli/azure/install-azure-cli#what-version-of-the-azure-cli-is-installed), and [How to update the Azure CLI](/cli/azure/update-azure-cli).

> [!WARNING]
> - This feature is incompatible with Windows (any architecture) and Linux Arm64 node pools.

## Install the aks-preview Azure CLI extension

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

To prepare a cluster, run one of the following Azure CLI commands depending on your needs.

If you only want to ingest into Application Insights components and Log Analytics workspaces using autoinstrumentation and don't need OpenTelemetry support:

```azurecli
az aks update --resource-group={resource_group} --name={cluster_name} --enable-azure-monitor-app-monitoring 
```

If you do need OpenTelemetry support that also enables you to ingest OpenTelemetry signals in case your application is instrumented with a non-Microsoft OSS SDK into Azure Monitor workspaces:

```azurecli
az aks update --resource-group={resource_group} --name={cluster_name} --enable-azure-monitor-app-monitoring --enable-azure-monitor-metrics	--enable-azure-monitor-logs --enable-opentelemetry-metrics --enable-opentelemetry-logs
```

> [!Tip]
> AKS Clusters can be prepared for this feature during cluster creation. To learn more, see [Prepare a cluster during AKS cluster create](#prepare-a-cluster-during-aks-cluster-create).

## Onboard deployments

Deployments can be onboarded in two ways: _namespace-wide_ or _per-deployment_. Use the namespace-wide method to onboard all deployments within a namespace. For selective or variably configured onboarding across multiple deployments, employ the per-deployment approach.

### Namespace-wide onboarding

To onboard all deployments within a namespace, create a single _Instrumentation_ custom resource named `default` in that namespace. Update `applicationInsightsConnectionString` to have the connection string of your Application Insights resource.

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
    autoInstrumentationPlatforms:
      - Java
      - NodeJs
  destination: # required
    applicationInsightsConnectionString: "InstrumentationKey=11111111-1111-1111-1111-111111111111;IngestionEndpoint=https://eastus2-3.in.applicationinsights.azure.com/;LiveEndpoint=https://eastus2.livediagnostics.monitor.azure.com/"
```

At a minimum, the following configuration is required:

- `spec.settings.autoInstrumentationPlatforms`: Empty array, or one or more values based on the languages your pods are running. Currently supported values are: `Java`, `NodeJs`. If an empty array is provided - autoconfiguration will be performed instead of autoinstrumentation: no distro will be places on the pod, but OpenTelemetry environment variables will be placed to configure any application already instrumented by an OSS OpenTelemetry SDK in any language to send telemetry to the specified Application Insights resource.
- `spec.destination.applicationInsightsConnectionString`: The connections string of an Application Insights resource to receive telemetry.

> [!IMPORTANT]
> If you're using OpenTelemetry to ingest into the Application Insights resource, you must also create a Data Collection Rule Association (DCR-A) between that Application Insights resource's DCR and the AKS cluster. See [here](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview#data-collection-rule-associations-dcra) for details.

> [!TIP]
> - Use `autoInstrumentationPlatforms: []` syntax to specify an empty array.
> - Use [annotations](#annotations) if per-deployment overrides are required. For more information, see [annotations](#annotations).
> - [Restart deployments](#restart-deployment) for settings to take effect.

### Per-deployment onboarding

Use per-deployment onboarding to ensure deployments are instrumented with different languages or to direct telemetry to separate Application Insights resources.

1. Create a unique _Instrumentation_ custom resource for each scenario. Avoid using the name `default`, which is used for namespace-wide onboarding.

    Create _Instrumentation_ custom resources to configure Application Insights in the namespace. Update `applicationInsightsConnectionString` to have the connection string of your Application Insights resource. 

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
        autoInstrumentationPlatforms: [] # not used since the language will be specified in the annotation
      destination: # required
        applicationInsightsConnectionString: "InstrumentationKey=11111111-1111-1111-1111-111111111111;IngestionEndpoint=https://eastus2-3.in.applicationinsights.azure.com/;LiveEndpoint=https://eastus2.livediagnostics.monitor.azure.com/"
    ```
    
    At a minimum, the following configuration is required:
    - `spec.destination.applicationInsightsConnectionString`: The connections string of an Application Insights resource.
  
    > [!IMPORTANT]
    > If you're using OpenTelemetry to ingest into the Application Insights resource, you must also create a Data Collection Rule Association (DCR-A) between that Application Insights resource's DCR and the AKS cluster. See [here](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview#data-collection-rule-associations-dcra) for details.
  
    The value of `autoInstrumentationPlatforms` will be ignored; the language (or no language, i.e. autoconfiguration) is specified in the annotation that associates the custom resource with a deployment (see below).

3. Associate each deployment with the appropriate custom resource using [annotations](#annotations). The annotation overrides the language set in the custom resource.

    > [!IMPORTANT]
    > To avoid adding them to the deployment's annotations by mistake, add annotations at the `spec.template.metadata.annotations` level of your deployment.

    Supported annotations:
    - Java: `instrumentation.opentelemetry.io/inject-java: "cr1"`
    - Node.js: `instrumentation.opentelemetry.io/inject-nodejs: "cr1"`
    - Autoconfiguration: `instrumentation.opentelemetry.io/inject-configuration: "cr1"`
   
    For autoconfiguration, no autoinstrumentation occurs (meaning no distro is places onto the pod); instead, OpenTelemetry configuration is performed via environment variables, so that whatever OSS OpenTelemetry SDK the application is already instrumented with will be directed to send OpenTelemetry telemetry to the provided Application Insights resource.
    
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

1. Implement [namespace-wide onboarding](#namespace-wide-onboarding) to define the default configuration.
2. Create [per-deployment onboarding](#per-deployment-onboarding) configurations, which override the default configuration for specific resources.

## Restart deployment

Run the following command after all custom resources are created and deployments are optionally annotated.

```shell
kubectl rollout restart deployment <deployment-name> -n mynamespace1
```

This command causes autoinstrumentation to take effect, enabling Application Insights. You can verify Application Insights is enabled by generating traffic and navigating to your resource. Your app is represented as a cloud role in Application Insights experiences. You're able to use all Application Insights Experiences except Live Metrics and Application Insights Code Analysis features. Learn more about the available Application Insights experiences [here](app-insights-overview.md#application-insights-experiences).

## Remove Autoinstrumentation for AKS

Ensure that you don't have any instrumented deployments. To uninstrument an instrumented deployment, remove the associated Instrumentation custom resource and run `kubectl rollout restart` on the deployment. Next run the following command.

```azurecli
az aks update --resource-group={resource_group} --name={cluster_name} --disable-azure-monitor-app-monitoring 
```

 > [!NOTE]
 > If instrumented deployments remain after the feature is disabled, they continue to be instrumented until redeployed to their original uninstrumented state or deleted.

## Annotations

### Disabling autoinstrumentation

The following annotations disable autoinstrumentation and autoconfiguration for the language indicated.

- Java: `instrumentation.opentelemetry.io/inject-java`
- Node.js: `instrumentation.opentelemetry.io/inject-nodejs`
- Autoconfiguration: `instrumentation.opentelemetry.io/inject-configuration`

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

Conversely, Application Insights might not be able to instrument all microservices. As an example, those using NGINX or unsupported languages. Users might prefer to rely on Container Insights logs only for such microservices.

You can also choose to enable both sources for logs if you have multiple observability teams such as infra engineers using Container Insights and developers using Application Insights.

Review the console logging configurations in your application's code to determine whether you want to enable Application Insights Logs, Container Insights Logs, or both. If you disable Container Insights logs, see [Container Insights settings](../containers/container-insights-data-collection-configure.md?tabs=portal#configure-data-collection-using-configmap).

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

If you only want to ingest into Application Insights components and Log Analytics workspaces using autoinstrumentation and don't need OpenTelemetry support:

```azurecli
az aks create --resource-group={resource_group} --name={cluster_name} --enable-azure-monitor-app-monitoring --generate-ssh-keys
```

If you do need OpenTelemetry support that also enables you to ingest OpenTelemetry signals in case your application is instrumented with a non-Microsoft OSS SDK into Azure Monitor workspaces:

```azurecli
az aks update --resource-group={resource_group} --name={cluster_name} --enable-azure-monitor-app-monitoring --enable-azure-monitor-metrics	--enable-azure-monitor-logs --enable-opentelemetry-metrics --enable-opentelemetry-logs --generate-ssh-keys
```

## Next steps
- To review frequently asked questions (FAQ), see [Autoinstrumentation for Azure Kubernetes Service FAQ](application-insights-faq.yml#autoinstrumentation-for-azure-kubernetes-service)
- To review our dedicated troubleshooting guide, see [Troubleshooting autoinstrumentation for Azure Kubernetes Service](/troubleshoot/azure/azure-monitor/app-insights/telemetry/troubleshoot-aks-autoinstrumentation).
- Learn more about [Azure Monitor](../overview.md) and [Application Insights](./app-insights-overview.md).
- See what [Application Map](./app-map.md?tabs=net) can do for your business.
