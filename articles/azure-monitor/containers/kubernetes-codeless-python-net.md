---
title: Enable Azure Kubernetes Service autoinstrumentation for Python and .NET (limited preview)
description: Learn how to onboard to the limited preview of Azure Kubernetes Service (AKS) autoinstrumentation for Python and .NET workloads.
ms.topic: how-to
ms.date: 03/16/2026
---

# Enable AKS autoinstrumentation for Python and .NET (limited preview)

Azure Kubernetes Service (AKS) autoinstrumentation is a feature that attaches Azure Monitor Application Insights SDK distros to your workload without requiring code changes. It works with workloads running as Kubernetes deployments in AKS. Currently, support for Java and Node.Js is in public preview, while support for Python and .NET is in limited preview. This article details the onboarding process that allows a select group of limited preview customers to enable Python and .NET support for their AKS clusters.

>[!IMPORTANT]
> - This feature is a **limited preview**. Preview features are provided without a service-level agreement and aren't recommended for production workloads.
> - For more information, see [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).

## Onboard to the limited preview

This section outlines the process of enabling the limited preview feature. It significantly references public preview documentation at [Autoinstrumentation for Azure Kubernetes Service (Preview)](kubernetes-codeless.md), as most of the steps are the same. Limited preview-specific aspects are explicitly called out.

- Review the _Prerequisites_ section at [Autoinstrumentation for Azure Kubernetes Service (Preview)](kubernetes-codeless.md#prerequisites). The limitations apply to the limited preview except support is added for Python and .NET.
- Enable the public preview feature for the entire cluster by following the instructions outlined in the following sections of the article:
  - [Install the aks-preview Azure CLI extension](kubernetes-codeless.md#install-the-aks-preview-azure-cli-extension)
  - [Register the AzureMonitorAppMonitoringPreview feature flag](kubernetes-codeless.md#register-the-azuremonitorappmonitoringpreview-feature-flag)
  - [Prepare a cluster](kubernetes-codeless.md#prepare-a-cluster)
- Choose a deployment that you want to instrument and onboard it by following the information at [Per-deployment onboarding](kubernetes-codeless.md#per-deployment-onboarding). The following points explain what you need to do differently for limited preview:
  - Keep in mind that namespace-wide onboarding (described in the previous section) is **_not available_** for limited preview languages.
  - Instead of using public preview annotations for Java and Node.Js mentioned in the document (`instrumentation.opentelemetry.io/inject-java` and `instrumentation.opentelemetry.io/inject-nodejs`), use limited preview annotations:
    - `instrumentation.opentelemetry.io/limited-preview-inject-python` for Python
    - `instrumentation.opentelemetry.io/limited-preview-inject-dotnet` for .NET
  - If you don't have an Application Insights resource yet, create one. Then copy its connection string (found in the Overview area of the Application Insights resource) into the `spec.destination.applicationInsightsConnectionString` field of the custom resource (CR), as instructed.
  - Put the CR into the same namespace as the deployment you're instrumenting.
  - Place the `instrumentation.opentelemetry.io/limited-preview-inject-*` annotation correctly. Put it under `spec.template.metadata.annotations` in the deployment, so that it exists at the pod level, _not_ at the deployment level.
- Restart the deployment you're onboarding after setup completes, as described in the [Restart deployment](../app/kubernetes-codeless.md#restart-deployment) section. This step isn't required if the CR already exists when you add the annotation. Afterward, you don't need to restart or redeploy the deployment every time you change the CR.
- Make sure the deployment runs (under load if applicable). Wait three minutes and confirm that the Application Insights resource (or the underlying Log Analytics workspace) has telemetry.

## Support

Contact us at [otel@microsoft.com](mailto:otel@microsoft.com) with your experiences, questions, or suggestions.