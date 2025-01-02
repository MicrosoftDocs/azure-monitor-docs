---
title: Monitor applications on AKS with Azure Monitor Application Insights (Preview)
description: Azure Monitor integrates seamlessly with your application running on Azure Kubernetes Service and allows you to spot the problems with your apps quickly.
ms.topic: conceptual
ms.custom: devx-track-extended-java
ms.date: 10/10/2024
ms.reviewer: abinetabate
---

# Autoinstrumentation for Azure Kubernetes Service (Preview)

> [!IMPORTANT]
> See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability.

This guide walks through enabling Azure Monitor Application Insights for Azure Kubernetes Service (AKS) workloads without modifying source code.

We cover [installing the aks-preview Azure CLI extension](#install-the-aks-preview-azure-cli-extension), [registering the AzureMonitorAppMonitoringPreview feature flag](#register-the-azuremonitorappmonitoringpreview-feature-flag), [preparing a cluster](#prepare-a-cluster), [onboarding deployments](#onboard-deployments), and [restarting deployments](#restart-deployment). These steps result in autoinstrumentation injecting the Azure Monitor OpenTelemetry Distro in application pods to generate telemetry. For more on autoinstrumentation and its benefits, see [What is autoinstrumentation for Azure Monitor Application Insights?](codeless-overview.md).


## Prerequisites

* An [AKS cluster](/azure/aks/learn/quick-kubernetes-deploy-portal) running a [kubernetes deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) using Java or Node.js in the Azure public cloud
* [A workspace-based Application Insights resource](create-workspace-resource.md#workspace-based-application-insights-resources).

> [!WARNING]
> - This feature is incompatible with both Windows (any architecture) and Linux ARM64 node pools.

## Install the aks-preview Azure CLI extension

[!INCLUDE [preview features callout](~/reusable-content/ce-skilling/azure/includes/aks/includes/preview/preview-callout.md)]

To install the aks-preview extension, run the following command:

```azurecli
az extension add --name aks-preview
```

Run the following command to update to the latest version of the extension released:

```azurecli
az extension update --name aks-preview
```

## Register the `AzureMonitorAppMonitoringPreview` feature flag

```azurecli
# Log into Azure CLI
az login

# Register the feature flag for Azure Monitor App Monitoring in preview
az feature register --namespace 'Microsoft.ContainerService' --name 'AzureMonitorAppMonitoringPreview'

# List the registration state of the Azure Monitor App Monitoring Preview feature
az feature list -o table --query "[?contains(name, 'Microsoft.ContainerService/AzureMonitorAppMonitoringPreview')].{Name:name,State:properties.state}"

# Once the feature shows as registered in the prior step, re-register the Microsoft.ContainerService provider to apply the new feature settings
az provider register --namespace Microsoft.ContainerService

# Check the registration state of the Microsoft.ContainerService provider
az feature show --namespace "Microsoft.ContainerService" --name "AzureMonitorAppMonitoringPreview" --query "properties.state"
```

## Prepare a cluster

To prepare a cluster, run the following Azure CLI command.

```azurecli
az aks update --resource-group={resource_group} --name={cluster_name} --enable-azure-monitor-app-monitoring 
```

> [!Tip]
> AKS Clusters can be prepared for this feature during cluster creation. To learn more, see [Prepare a cluster during AKS cluster create](#prepare-a-cluster-during-aks-cluster-create).

## Onboard deployments

Deployments can be onboarded in two ways: _namespace-wide_ or _per-deployment_. Use the namespace-wide method to onboard all deployments within a namespace. For selective or variably configured onboarding across multiple deployments, employ the per-deployment approach.

### Namespace-wide onboarding

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
    autoInstrumentationPlatforms: # required
      - Java
      - NodeJs
  destination: # required
    applicationInsightsConnectionString: "InstrumentationKey=11111111-1111-1111-1111-111111111111;IngestionEndpoint=https://eastus2-3.in.applicationinsights.azure.com/;LiveEndpoint=https://eastus2.livediagnostics.monitor.azure.com/"
```

At a minimum, the following configuration is required:

- `spec.settings.autoInstrumentationPlatforms`: One or more values based on the languages your pods are running.
- `spec.destination.applicationInsightsConnectionString`: The connections string of an Application Insights resource. 

> [!TIP]
> - Use [annotations](#annotations) if per-deployment overrides are required. For more information, see [annotations](#annotations).
> - [Restart deployments](#restart-deployment) for settings to take effect.

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
        autoInstrumentationPlatforms: # required
          - Java
          - NodeJs
      destination: # required
        applicationInsightsConnectionString: "InstrumentationKey=11111111-1111-1111-1111-111111111111;IngestionEndpoint=https://eastus2-3.in.applicationinsights.azure.com/;LiveEndpoint=https://eastus2.livediagnostics.monitor.azure.com/"
    ```
    
    At a minimum, the following configuration is required:
    - `spec.destination.applicationInsightsConnectionString`: The connections string of an Application Insights resource.

    > [!TIP]
    > `spec.settings.autoInstrumentationPlatforms` is ignored in non-default _Instrumentation_ custom resources. The language is determined by the annotation used to associate a deployment to the custom resource.

3. Associate each deployment with the appropriate custom resource using [annotations](#annotations). The annotation overrides the language set in the custom resource.

    > [!IMPORTANT]
    > Always add annotations at the `spec.template.metadata.annotations` level of your deployment to avoid mistakenly adding them to the deployment’s own annotations.

    Example:
    
    ```yml
    instrumentation.opentelemetry.io/inject-java="cr1"
    ```
> [!TIP]
> [Resart deployments](#restart-deployment) for settings to take effect.

### Mixed mode onboarding

Use mixed mode when most deployments use a default configuration and a few deployments must use different configurations.

1. Implement [namespace-wide onboarding](#namespace-wide-onboarding) to define the default configuration.
2. Create [per-deployment onboarding](#per-deployment-onboarding) configurations, which override the default configuration for specific resources.

## Restart deployment

Run the following command after all custom resources are created and deployments are optionally annotated.

```shell
kubectl rollout restart deployment <deployment-name> -n mynamespace1
```

This command causes autoinstrumentation to take effect, enabling Application Insights. You can verify Application Insights is enabled by generating traffic and navigating to your resource. Your app is represented as a cloud role in Application Insights experiences. You're able to use all Application Insights Experiences except Live Metrics and Application Insights Code Analysis features. Learn more about the available Application Insights experiences [here](app-insights-overview.md#experiences). 

## Remove Autoinstrumentation for AKS

Ensure that you don't have any instrumented deployments. To uninstrument an instrumented deployment, remove the associated Instrumentation custom resource and run `kubectl rollout restart` on the deployment. Next run the following command.

```azurecli
az aks update --resource-group={resource_group} --name={cluster_name} --disable-azure-monitor-app-monitoring 
```

 > [!NOTE]
 > If you have instrumented deployments remaining after the feature is disabled they will continue to be instrumented unitl they are redeployed to their original uninstrumented state or deleted.

## Annotations

### Disabling autoinstrumentation

The following annotations disable autoinstrumentation for the language indicated.

- Java: `instrumentation.opentelemetry.io/inject-java`
- Node.js: `instrumentation.opentelemetry.io/inject-nodejs`

  ```yml
  instrumentation.opentelemetry.io/inject-java="false"
  ```
To turn autoinstrumentation back on after disabling.

  ```yml
  instrumentation.opentelemetry.io/inject-java="true"
  ```

### Enabling logs in Application Insights

You can opt to collect logs in Application Insights as an addition to or replacement for Container Insights logs. 

Enabling logs in Application Insights provide correlated logs, allowing users to easily view distributed traces alongside their related logs. Further, some microservices don't write logs to the console so Container Insights isn't able to collect them and only Application Insights instrumentation captures these logs.

Conversely, Application Insights might not be able to instrument all microservices. As an example, those using NGINX or unsupported languages. Users might prefer to rely on Container Insights logs only for such microservices.

You can also choose to enable both sources for logs if you have multiple observability teams such as infra engineers using Container Insights and developers using Application Insights.

Review the console logging configurations in your application's code to determine whether you want to enable Application Insights Logs, Container Insights Logs, or both. If you disable Container Insights logs, see [Container Insights settings](../containers/container-insights-data-collection-configure.md?tabs=portal#configure-data-collection-using-configmap).

> [!IMPORTANT]
> This feature will not collect application logs from standard logging frameworks and send them to Application Insights unless you enable logs in Application Insights. This is to avoid unnecessary duplication and increased cost.

Use the following annotation to enable logs in Application Insights

- monitor.azure.com/enable-application-logs

> [!IMPORTANT]
> Always add annotations at the `spec.template.metadata.annotations` level of your deployment to avoid mistakenly adding them to the deployment’s own annotations.

  ```yml
  monitor.azure.com/enable-application-logs="true"
  ```

## Prepare a cluster during AKS cluster create

AKS Clusters can be prepared for this feature during cluster creation. Run the following Azure CLI command if you prefer to have the cluster prepped during creation. Application monitoring isn't enabled just because your cluster is prepped. You must deploy an application and onboard the application to this feature.

```azurecli
az aks create --resource-group={resource_group} --name={cluster_name} --enable-azure-monitor-app-monitoring --generate-ssh-keys
```


## Frequently asked questions

#### Does AKS autoinstrumentation support custom metrics?

If you want custom metrics in Node.js, manually instrument applications with the [Azure Monitor OpenTelemetry Distro.](opentelemetry-enable.md)

Java allows custom metrics with autoinstrumentation. You can [collect custom metrics](opentelemetry-add-modify.md?tabs=java#add-custom-metrics) by updating your code and enabling this feature. If your code already has custom metrics, then they flow through when autoinstrumentation is enabled.

#### Does AKS autoinstrumentation work with applications instrumented with an Open Source Software (OSS) OpenTelemetry SDK?

AKS autoinstrumentation can disrupt the telemetry sent to third parties by an OSS OpenTelemetry SDK.

#### Can AKS autoinstrumentation coexist with manual instrumentation?

AKS autoinstrumentation is designed to coexist with both manual instrumentation options: the Application Insights classic API SDK and OpenTelemetry Distro.

It always prevents duplicate data and ensures custom metrics work.

Refer to this chart to determine when autoinstrumentation or manual instrumentation takes precedence.

| Language | Precedence             |
|----------|------------------------|
| Node.js  | Manual instrumentation |
| Java     | Autoinstrumentation    |

#### How do I ensure I'm using the latest and most secure versions of Azure Monitor OpenTelemetry Distro?

Vulnerabilities detected in the Azure Monitor OpenTelemetry Distro are prioritized, fixed, and released in the next version.

AKS autoinstrumentation injects the latest version of the Azure Monitor OpenTelemetry Distro into your application pods every time your deployment is changed or restarted.

The OpenTelemetry Distro can become vulnerable on deployments that aren't changed or restarted for extended periods of time. For this reason, we suggest updating or restarting deployments weekly to ensure a recent version of the Distro is being used.

#### How do I learn more about the Azure Monitor OpenTelemetry Distro?

This feature achieves autoinstrumentation by injecting Azure Monitor OpenTelemetry Distro into application pods. 

For Java, this feature integrates the standalone Azure Monitor OpenTelemetry Distro for Java. See our [Java distro documentation](opentelemetry-enable.md?tabs=java) to learn more about the Java instrumentation binary. 

For Node.js, we inject an autoinstrumentation binary based on our Azure Monitor OpenTelemetry Distro for Node.js. For more information, see [Node.js distro documentation](opentelemetry-enable.md?tabs=nodejs). Keep in mind that we don't have a standalone autoinstrumentation for Node.js so our distro documentation is geared towards manual instrumentation. You can ignore code based configurations steps related to manual instrumentation. However, everything else in our distro documentation such as default settings, environment variable configurations, etc. is applicable to this feature.

## Troubleshooting

#### Missing telemetry

The following steps can help to resolve problems when no data appears in your Application Insights workspace-based resource.

1. Confirm the pod is in the running state.

2. Verify the deployment is instrumented.
    
    Check the `monitor.azure.com/instrumentation` annotation on the deployment itself and the latest replica set that belongs to it.
    
    The annotation should be present with proper JSON in the following pattern: `{"crName":"crName1","crResourceVersion":"20177993","platforms":["Java"]}`

    If the annotation **isn't present**, then the deployment isn't instrumented and the following steps need to be completed.
    
    1. Prepare the cluster. For more information, see [Prepare the cluster](#prepare-a-cluster).
    2. Confirm your _Instrumentation_ custom resource is in the correct namespace as the deployment.
    3. Confirm your _Instrumentation_ custom resource contains the correct connection string and instrumentation platform.
    4. Restart the deployment. For more information, see [Restart deployment](#restart-deployment).
    
    If the annotation **is present**, then the deployment is instrumented and you should proceed to the next step.

3. Check for networking errors in the SDK log located in the pod’s logs volume, `/var/log/applicationinsights`.
    
    As an example, the following errors indicate a connectivity problem.
    
    - `Ingestion endpoint could not be reached.`
    - `Error: getaddrinfo ENOTFOUND eastus2-3.in.applicationinsights.azure.com`
    - `getaddrinfo ENOTFOUND eastus2-3.in.applicationinsights.azure.com`
    
    If this type of error exists, sign into the container and test connectivity to the endpoint.
    
    `kubectl exec -ti customer-java-1-1234567890-abcde -- /bin/bash`
    
    If connectivity can't be established, then troubleshoot the network connectivity problem such as a firewall or name resolution issue.


[!INCLUDE [azure-monitor-app-insights-test-connectivity](../includes/azure-monitor-app-insights-test-connectivity.md)]

## Next steps

* Learn more about [Azure Monitor](../overview.md) and [Application Insights](./app-insights-overview.md).
* See what [Application Map](./app-map.md?tabs=net) can do for your business.
