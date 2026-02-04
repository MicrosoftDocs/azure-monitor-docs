---
title: Autoinstrumentation for Azure Monitor Application Insights
description: Overview of autoinstrumentation for Azure Monitor Application Insights codeless application performance management.
ms.topic: how-to
ms.custom: devx-track-js
ms.date: 07/30/2025
---

# What is autoinstrumentation for Azure Monitor Application Insights?

Autoinstrumentation enables [Application Insights](app-insights-overview.md) to make [telemetry](data-model-complete.md) like metrics, requests, and dependencies available in your [Application Insights resource](create-workspace-resource.md). It provides easy access to experiences such as the [application dashboard](overview-dashboard.md) and [application map](app-map.md).

The term "autoinstrumentation" is a portmanteau, a linguistic blend where parts of multiple words combine into a new word. "Autoinstrumentation" combines "auto" and "instrumentation." It sees widespread use in software observability and describes the process of adding instrumentation code to applications without manual coding by developers.

The autoinstrumentation process varies by language and platform, but often involves a toggle button in the Azure portal. The following example shows a toggle button for [Azure App Service](/azure/app-service/getting-started#getting-started-with-azure-app-service) autoinstrumentation.

:::image type="content"source="./media/codeless-app-service/enable.png" alt-text=" Screenshot that shows the Application Insights tab with Enable selected." lightbox="./media/codeless-app-service/enable.png":::

> [!TIP]
> *We do not provide autoinstrumentation specifics for all languages and platforms in this article.* For detailed information, select the corresponding link in the [Supported environments, languages, and resource providers table](#supported-environments-languages-and-resource-providers). In many cases, autoinstrumentation is enabled by default.

## What are the autoinstrumentation advantages?

> [!div class="checklist"]
> - Code changes aren't required.
> - Access to source code isn't required.
> - Configuration changes aren't required.
> - Instrumentation maintenance is eliminated.

## Supported environments, languages, and resource providers

The following table shows the current state of autoinstrumentation availability.

Links are provided to more information for each supported scenario.

> [!NOTE]
> If your hosting environment or resource provider is not listed in the following table, then autoinstrumentation is not supported. In this case, we recommend manually instrumenting using the [Azure Monitor OpenTelemetry Distro](opentelemetry-enable.md). For more information, see [Data Collection Basics of Azure Monitor Application Insights](opentelemetry-overview.md).

| Environment/Resource provider | .NET Framework | .NET Core / .NET | Java | Node.js | Python |
|-------------------------------|----------------|------------------|------|---------|--------|
|Azure App Service on Windows - Publish as Code | [ :white_check_mark: :link: ](codeless-app-service.md?tabs=net) ¹ | [ :white_check_mark: :link: ](codeless-app-service.md?tabs=aspnetcore) ¹ | [ :white_check_mark: :link: ](codeless-app-service.md?tabs=java) ¹ | [ :white_check_mark: :link: ](codeless-app-service.md?tabs=nodejs) ¹ | :x: |
|Azure App Service on Windows - Publish as Container ⁴ | [ :white_check_mark: :link: ](https://azure.github.io/AppService/2022/04/11/windows-containers-app-insights-preview.html) ² | [ :white_check_mark: :link: ](https://azure.github.io/AppService/2022/04/11/windows-containers-app-insights-preview.html) ² | [ :white_check_mark: :link: ](https://azure.github.io/AppService/2022/04/11/windows-containers-app-insights-preview.html) ² | [ :white_check_mark: :link: ](https://techcommunity.microsoft.com/t5/apps-on-azure-blog/public-preview-application-insights-auto-instrumentation-for/ba-p/3947971) ² | :x: |
|Azure App Service on Linux - Publish as Code | :x: | [ :white_check_mark: :link: ](codeless-app-service.md?tabs=aspnetcore) ¹ | [ :white_check_mark: :link: ](codeless-app-service.md?tabs=java) ¹ | [ :white_check_mark: :link: ](codeless-app-service.md?tabs=nodejs)¹ | [ :white_check_mark: :link: ](codeless-app-service.md?tabs=python) |
|Azure App Service on Linux - Publish as Container ⁴ | :x: | [ :white_check_mark: :link: ](codeless-app-service.md?tabs=aspnetcore) | [ :white_check_mark: :link: ](codeless-app-service.md?tabs=java) | [ :white_check_mark: :link: ](codeless-app-service.md?tabs=nodejs) | :x: |
|Azure Functions - basic | [ :white_check_mark: :link: ](monitor-functions.md) ¹ | [ :white_check_mark: :link: ](monitor-functions.md) ¹ | [ :white_check_mark: :link: ](monitor-functions.md) ¹ | [ :white_check_mark: :link: ](monitor-functions.md) ¹ | [ :white_check_mark: :link: ](monitor-functions.md#distributed-tracing-for-python-function-apps) ¹ |
|Azure Functions - dependencies | :x: | :x: | [ :white_check_mark: :link: ](monitor-functions.md) | :x: | :x: |
|Azure Spring Apps | :x: | :x: | [ :white_check_mark: :link: ](/azure/spring-apps/enterprise/how-to-application-insights) | :x: | :x: |
|Azure Kubernetes Service (AKS) | :x: | :x: | [ :white_check_mark: :link: ](./kubernetes-codeless.md)² | [ :white_check_mark: :link: ](./kubernetes-codeless.md)² | :x: |
|Azure VMs Windows | [ :white_check_mark: :link: ](azure-vm-vmss-apps.md) ² ³ | [ :white_check_mark: :link: ](azure-vm-vmss-apps.md) ² ³ | [ :white_check_mark: :link: ](opentelemetry-enable.md?tabs=java) | :x: | :x: |
|On-premises VMs Windows | [ :white_check_mark: :link: ](application-insights-asp-net-agent.md) ³ | [ :white_check_mark: :link: ](application-insights-asp-net-agent.md) ² ³ | [ :white_check_mark: :link: ](opentelemetry-enable.md?tabs=java) | :x: | :x: |
|Standalone agent - any environment | :x: | :x: | [ :white_check_mark: :link: ](opentelemetry-enable.md?tabs=java) | :x: | :x: |

**Footnotes**
- ¹: Application Insights is on by default and enabled automatically.
- ²: This feature is in public preview. See [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).
- ³: An agent must be deployed and configured.
- ⁴: Autoinstrumentation only supports single-container applications. For multi-container applications, manual instrumentation is required using the [Azure Monitor OpenTelemetry Distro](opentelemetry-enable.md).

> [!NOTE]
> Autoinstrumentation was known as "codeless attach" before October 2021.

## Next steps

* To review frequently asked questions (FAQ), see [Autoinstrumentation FAQ](application-insights-faq.yml#autoinstrumentation)
* [Application Insights overview](app-insights-overview.md)
* [Application Insights overview dashboard](overview-dashboard.md)
* [Application map](app-map.md)
