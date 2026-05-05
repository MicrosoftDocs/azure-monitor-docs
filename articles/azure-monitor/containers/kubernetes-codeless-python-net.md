---
title: Enable Azure Kubernetes Service autoinstrumentation for Python and .NET (limited preview)
description: Learn how to onboard to the limited preview of Azure Kubernetes Service (AKS) autoinstrumentation for Python and .NET workloads.
ms.topic: how-to
ms.reviewer: kaprince
ms.date: 04/01/2026
---

# Enable AKS autoinstrumentation for Python and .NET (limited preview)

Azure Kubernetes Service (AKS) autoinstrumentation is a feature that attaches Azure Monitor Application Insights SDK distros to your workload without requiring code changes. It works with workloads running as Kubernetes deployments in AKS. Currently, support for Java and Node.js is in public preview, while support for Python and .NET is in limited preview. This article details the onboarding process that allows a select group of limited preview customers to enable Python and .NET support for their AKS clusters.

>[!IMPORTANT]
> - This feature is a **limited preview**. Preview features are provided without a service-level agreement and aren't recommended for production workloads.
> - For more information, see [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).


You can use Python and .NET with both the AKS OTLP public preview and AKS autoinstrumentation (non-OTLP).

## Onboard to the limited preview

This section outlines the process of enabling the limited preview feature. It significantly references public preview documentation at [Autoinstrumentation for Azure Kubernetes Service (Preview)](kubernetes-codeless.md), as most of the steps are the same. The documentation explicitly calls out limited preview-specific aspects.

> [!IMPORTANT]
> Application Insights experiences including prebuilt dashboards and queries expect and require OTLP metrics with delta temporality and exponential histogram aggregation.
>
> When using AKS auto-instrumentation, Azure Monitor automatically uses environment variables to configure SDKs to export metrics with delta temporality and exponential histograms. No additional user configuration is required.
>
> For more information, see [Metrics Exporters - OTLP](https://opentelemetry.io/docs/specs/otel/metrics/sdk_exporters/otlp/).

1. Review the _Prerequisites_ section at [Autoinstrumentation for Azure Kubernetes Service](kubernetes-codeless.md#prerequisites). The limitations apply to the limited preview except support is added for Python and .NET.
1. Prepare the cluster by following the instructions at [prepare a cluster](kubernetes-codeless.md#prepare-a-cluster).    
1. Choose a deployment that you want to instrument and onboard it by following the information at [Per-deployment onboarding](kubernetes-codeless.md#per-deployment-onboarding). The following points explain what you need to do differently for limited preview:
    - Keep in mind that namespace-wide onboarding (described in the previous section) is **_not available_** for limited preview languages.
    - Instead of using public preview annotations for Java and Node.js mentioned in the document (`instrumentation.opentelemetry.io/inject-java` and `instrumentation.opentelemetry.io/inject-nodejs`), use private preview annotations:
        - `instrumentation.opentelemetry.io/private-preview-inject-python` for Python
        - `instrumentation.opentelemetry.io/private-preview-inject-dotnet` for .NET
    - If you don't have an Application Insights resource yet, create one. Then copy its connection string (found in the Overview area of the Application Insights resource) into the `spec.destination.applicationInsightsConnectionString` field of the custom resource (CR), as instructed.
    - Put the CR into the same namespace as the deployment you're instrumenting.
    - Place the `instrumentation.opentelemetry.io/private-preview-inject-*` annotation correctly. Put it under `spec.template.metadata.annotations` in the deployment, so that it exists at the pod level, _not_ at the deployment level.
1. Restart the deployment you're onboarding after setup completes, as described in the [Restart deployment](../app/kubernetes-codeless.md#restart-deployment) section. This step isn't required if the CR already exists when you add the annotation. Afterward, you don't need to restart or redeploy the deployment every time you change the CR.
1. Make sure the deployment runs (under load if applicable). Wait three minutes and confirm that the Application Insights resource (or the underlying Log Analytics workspace) has telemetry.

## Support

Contact us at [otel@microsoft.com](mailto:otel@microsoft.com) with your experiences, questions, or suggestions.