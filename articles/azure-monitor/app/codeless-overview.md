---
title: Autoinstrumentation for Azure Monitor Application Insights
description: Overview of autoinstrumentation for Azure Monitor Application Insights codeless application performance management.
ms.topic: how-to
ms.custom: devx-track-js
ms.date: 03/28/2026
---

# Autoinstrumentation for Azure Monitor Application Insights

Autoinstrumentation automatically collects telemetry and sends it to your [Application Insights](app-insights-overview.md) resource, enabling portal experiences like the [application dashboard](overview-dashboard.md) and [application map](app-map.md).

The autoinstrumentation process varies by language and platform, but often involves a toggle button in the Azure portal. The following example shows a toggle button for [Azure App Service](/azure/app-service/getting-started#getting-started-with-azure-app-service) autoinstrumentation.

:::image type="content"source="./media/codeless-app-service/enable.png" alt-text=" Screenshot that shows the Application Insights tab with Enable selected." lightbox="./media/codeless-app-service/enable.png":::

> [!TIP]
> *We don't provide autoinstrumentation specifics for all languages and platforms in this article.* For detailed information, select the corresponding link in the [Supported environments, languages, and resource providers table](#supported-environments-languages-and-resource-providers). In many cases, autoinstrumentation is enabled by default.

## Supported environments, languages, and resource providers

The following table shows the current state of autoinstrumentation availability.

Links are provided to more information for each supported scenario.

> [!NOTE]
> If your hosting environment or resource provider isn't listed in the following table, see [getting started](app-insights-overview.md#getting-started).

| Environment/Resource provider                       | .NET Framework                                                                                                               | .NET Core / .NET                                                                                                             | Java                                                                                                                         | Node.js                                                                                                                                                               | Python                                                                                                                   |
| --------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------ |
| Azure App Service on Windows - Publish as Code      | [ :white_check_mark: :link: ](codeless-app-service.md?tabs=net)                                                             | [ :white_check_mark: :link: ](codeless-app-service.md?tabs=aspnetcore) ¹                                                     | [ :white_check_mark: :link: ](codeless-app-service.md?tabs=java) ¹                                                           | [ :white_check_mark: :link: ](codeless-app-service.md?tabs=nodejs) ¹                                                                                                  | :x:                                                                                                                      |
| Azure App Service on Windows - Publish as Container | [ :white_check_mark: :link: ](https://azure.github.io/AppService/2022/04/11/windows-containers-app-insights-preview.html) ²³ | [ :white_check_mark: :link: ](https://azure.github.io/AppService/2022/04/11/windows-containers-app-insights-preview.html) ²³ | [ :white_check_mark: :link: ](https://azure.github.io/AppService/2022/04/11/windows-containers-app-insights-preview.html) ²³ | [ :white_check_mark: :link: ](https://techcommunity.microsoft.com/t5/apps-on-azure-blog/public-preview-application-insights-auto-instrumentation-for/ba-p/3947971) ²³ | :x:                                                                                                                      |
| Azure App Service on Linux - Publish as Code        | :x:                                                                                                                          | [ :white_check_mark: :link: ](codeless-app-service.md?tabs=aspnetcore) ¹                                                     | [ :white_check_mark: :link: ](codeless-app-service.md?tabs=java) ¹                                                           | [ :white_check_mark: :link: ](codeless-app-service.md?tabs=nodejs)¹                                                                                                   | [ :white_check_mark: :link: ](codeless-app-service.md?tabs=python)                                                       |
| Azure App Service on Linux - Publish as Container   | :x:                                                                                                                          | [ :white_check_mark: :link: ](codeless-app-service.md?tabs=aspnetcore) ³                                                     | [ :white_check_mark: :link: ](codeless-app-service.md?tabs=java) ³                                                           | [ :white_check_mark: :link: ](codeless-app-service.md?tabs=nodejs) ³                                                                                                  | :x:                                                                                                                      |
| Azure Functions                                     | [ :white_check_mark: :link: ](/azure/azure-functions/opentelemetry-howto) ¹                                                  | [ :white_check_mark: :link: ](/azure/azure-functions/opentelemetry-howto) ¹                                                  | [ :white_check_mark: :link: ](/azure/azure-functions/opentelemetry-howto) ¹                                                  | [ :white_check_mark: :link: ](/azure/azure-functions/opentelemetry-howto) ¹                                                                                           | [ :white_check_mark: :link: ](/azure/azure-functions/opentelemetry-howto#distributed-tracing-for-python-function-apps) ¹ |
| Azure Spring Apps                                   | :x:                                                                                                                          | :x:                                                                                                                          | [ :white_check_mark: :link: ](/azure/spring-apps/enterprise/how-to-application-insights)                                     | :x:                                                                                                                                                                   | :x:                                                                                                                      |
| Azure Kubernetes Service (AKS)                      | :x:                                                                                                                          | :x:                                                                                                                          | [ :white_check_mark: :link: ](../containers/kubernetes-codeless.md)²                                                         | [ :white_check_mark: :link: ](../containers/kubernetes-codeless.md)²                                                                                                  | :x:                                                                                                                      |

**Footnotes**
- ¹: Application Insights is on by default and enabled automatically.
- ²: This feature is in public preview. See [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).
- ³: Autoinstrumentation only supports single-container applications. For multi-container applications, manual instrumentation is required using the [Azure Monitor OpenTelemetry Distro](opentelemetry-enable.md).

> [!TIP]
> Switch to code-based instrumentation with the [OpenTelemetry Distro](opentelemetry-enable.md) if you want more configuration and extensibility options.

## Next steps

- [Use OpenTelemetry with Azure Functions](/azure/azure-functions/opentelemetry-howto)
- [Monitor Azure App Service](/azure/app-service/monitor-app-service)
- [Troubleshoot Application Insights autoinstrumentation](/troubleshoot/azure/azure-monitor/app-insights/telemetry/auto-instrumentation-troubleshoot)
- [Troubleshoot Application Insights integration with Azure App Service](/troubleshoot/azure/azure-monitor/app-insights/telemetry/troubleshoot-app-service-issues)
- [Troubleshoot missing application telemetry in Azure Monitor Application Insights](/troubleshoot/azure/azure-monitor/app-insights/telemetry/investigate-missing-telemetry)
- [Autoinstrumentation FAQ](application-insights-faq.yml#autoinstrumentation)