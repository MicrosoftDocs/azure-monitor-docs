---
title: Enable application monitoring in Azure App Service for .NET, Node.js, Python, and Java applications - Azure Monitor | Microsoft Docs
description: Application performance monitoring for Azure App Service. Chart load and response time, dependency information, and set alerts on performance.
ms.topic: how-to
ms.date: 02/28/2025
ms.reviewer: abinetabate
---

# Enable application monitoring in Azure App Service for .NET, Node.js, Python, and Java applications

Autoinstrumentation, also referred to as *runtime* monitoring, is the easiest way to enable Application Insights for Azure App Service without requiring any code changes or advanced configurations. Based on your specific scenario, evaluate whether you require more advanced monitoring through [manual instrumentation](opentelemetry-overview.md).

[!INCLUDE [azure-monitor-instrumentation-key-deprecation](~/reusable-content/ce-skilling/azure/includes/azure-monitor-instrumentation-key-deprecation.md)]

## Enable Application Insights

## [ASP.NET Core](#tab/aspnetcore)

> [!IMPORTANT]
> If both autoinstrumentation monitoring and manual SDK-based instrumentation are detected, only the manual instrumentation settings are honored. This arrangement prevents duplicate data from being sent. To learn more, see [Troubleshooting](#troubleshooting).

> [!NOTE]
> * Only .NET Core [Long Term Support](https://dotnet.microsoft.com/platform/support/policy/dotnet-core) (LTS) releases are supported.
> * [Trim self-contained deployments](/dotnet/core/deploying/trimming/trim-self-contained) is *not supported*. Use [manual instrumentation](./asp-net-core.md) instead.

### Autoinstrumentation in the Azure portal

1. Select **Application Insights** in the left-hand navigation menu of your app service, then select **Enable**.

    :::image type="content"source="./media/codeless-app-service/enable.png" alt-text=" Screenshot that shows the Application Insights tab with Enable selected.":::

1. Create a new resource or select an existing Application Insights resource for this application.

    > [!NOTE]
    > When you select **OK** to create a new resource, you're prompted to **Apply monitoring settings**. Selecting **Continue** links your new Application Insights resource to your app service. Your app service then restarts.

    :::image type="content"source="./media/codeless-app-service/change-resource.png" alt-text="Screenshot that shows the Change your resource dropdown.":::

1. After you specify which resource to use, you can choose how you want Application Insights to collect data per platform for your application. ASP.NET Core collection options are **Recommended** or **Disabled**.

    :::image type="content"source="./media/codeless-app-service/instrument-net-core.png" alt-text=" Screenshot that shows instrumenting your application section.":::

## [.NET](#tab/net)

> [!IMPORTANT]
> If both autoinstrumentation monitoring and manual SDK-based instrumentation are detected, only the manual instrumentation settings are honored. This arrangement prevents duplicate data from being sent. To learn more, see [Troubleshooting](#troubleshooting).

> [!NOTE]
> The combination of `APPINSIGHTS_JAVASCRIPT_ENABLED` and `urlCompression` isn't supported. For more information, see [Troubleshooting](#appinsights_javascript_enabled-and-urlcompression-not-supported).

### Autoinstrumentation in the Azure portal

1. Select **Application Insights** in the left-hand navigation menu of your app service, then select **Enable**.

    :::image type="content"source="./media/codeless-app-service/enable.png" alt-text=" Screenshot that shows the Application Insights tab with Enable selected.":::

1. Create a new resource or select an existing Application Insights resource for this application.

    > [!NOTE]
    > When you select **OK** to create a new resource, you're prompted to **Apply monitoring settings**. Selecting **Continue** links your new Application Insights resource to your app service. Your app service then restarts.

    :::image type="content"source="./media/codeless-app-service/change-resource.png" alt-text="Screenshot that shows the Change your resource dropdown.":::

1. After you specify which resource to use, you can choose how you want Application Insights to collect data per platform for your application. ASP.NET app monitoring is on by default with two different levels of collection, **Recommended** and **Basic**.

    :::image type="content"source="./media/codeless-app-service/instrument-net.png" alt-text="Screenshot that shows the Application Insights site extensions page with Create new resource selected.":::

     The following table summarizes the data collected for each route.
            
    | Data                                                                                     | Recommended | Basic                                      |
    |------------------------------------------------------------------------------------------|-------------|--------------------------------------------|
    | Adds CPU, memory, and I/O usage trends                                                   | Yes         | No                                         |
    | Collects usage trends, and enables correlation from availability results to transactions | Yes         | Yes                                        |
    | Collects exceptions unhandled by the host process                                        | Yes         | Yes                                        |
    | Improves APM metrics accuracy under load, when sampling is used                          | Yes         | Yes                                        |
    | Correlates micro-services across request/dependency boundaries                           | Yes         | No (single-instance APM capabilities only) |

## [Java](#tab/java)

> [!NOTE]
> With Spring Boot Native Image applications, use the [Azure Monitor OpenTelemetry Distro / Application Insights in Spring Boot native image Java application](https://aka.ms/AzMonSpringNative) project instead of the Application Insights Java agent solution described here.

This integration adds [Application Insights Java 3.x](./opentelemetry-enable.md?tabs=java) and autocollects telemetry. You can further apply extra configurations and [add your own custom telemetry](./opentelemetry-add-modify.md?tabs=java#modify-telemetry).

### Autoinstrumentation in the Azure portal

1. Select **Application Insights** in the left-hand navigation menu of your app service, then select **Enable**.

    :::image type="content"source="./media/codeless-app-service/enable.png" alt-text=" Screenshot that shows the Application Insights tab with Enable selected.":::

1. Create a new resource or select an existing Application Insights resource for this application.

    > [!NOTE]
    > When you select **OK** to create a new resource, you're prompted to **Apply monitoring settings**. Selecting **Continue** links your new Application Insights resource to your app service. Your app service then restarts.

    :::image type="content"source="./media/codeless-app-service/change-resource.png" alt-text="Screenshot that shows the Change your resource dropdown.":::

## [Node.js](#tab/nodejs)

> [!IMPORTANT]
> If both autoinstrumentation monitoring and manual SDK-based instrumentation are detected, only the manual instrumentation settings are honored. This arrangement prevents duplicate data from being sent. To learn more, see the [Troubleshooting section](#troubleshooting).

>[!NOTE]
> You can configure the automatically attached agent using the `APPLICATIONINSIGHTS_CONFIGURATION_CONTENT` environment variable in the App Service Environment variable blade. For details on the configuration options that can be passed via this environment variable, see [Node.js Configuration](https://github.com/microsoft/ApplicationInsights-node.js#Configuration).

Application Insights for Node.js is integrated with Azure App Service on Linux - both code-based and custom containers, and with App Service on Windows for code-based apps. The integration is in public preview.

### Autoinstrumentation in the Azure portal

1. Select **Application Insights** in the left-hand navigation menu of your app service, then select **Enable**.

    :::image type="content"source="./media/codeless-app-service/enable.png" alt-text=" Screenshot that shows the Application Insights tab with Enable selected.":::

1. Create a new resource or select an existing Application Insights resource for this application.

    > [!NOTE]
    > When you select **OK** to create a new resource, you're prompted to **Apply monitoring settings**. Selecting **Continue** links your new Application Insights resource to your app service. Your app service then restarts.

    :::image type="content"source="./media/codeless-app-service/change-resource.png" alt-text="Screenshot that shows the Change your resource dropdown.":::

1. Once you specified which resource to use, you're all set to go.

    :::image type="content"source="./media/codeless-app-service/app-service-node.png" alt-text="Screenshot of instrument your application."::: 

## [Python (Preview)](#tab/python)

> [!IMPORTANT]
> See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability.

> [!NOTE]
> * Only use autoinstrumentation on App Service if you aren't using manual instrumentation of OpenTelemetry in your code, such as the [Azure Monitor OpenTelemetry Distro](./opentelemetry-enable.md?tabs=python) or the [Azure Monitor OpenTelemetry Exporter](/python/api/overview/azure/monitor-opentelemetry-exporter-readme). This is to prevent duplicate data from being sent. To learn more about this, check out the [troubleshooting section](#troubleshooting) in this article.
>
> * [Live Metrics](live-stream.md) isn't available for autoinstrumented Python applications running on Azure App Service. To use this feature, manually instrument your application with the [Azure Monitor OpenTelemetry Distro](opentelemetry-enable.md) instead.

Application Insights for Python integrates with code-based Linux Azure App Service. The integration is in public preview and adds the Python SDK, which is in GA. It instruments popular Python libraries in your code, letting you automatically gather and correlate dependencies, logs, and metrics. To see which calls and metrics are collected, see [Python libraries](#python-libraries)

Logging telemetry is collected at the level of the root logger. To learn more about Python's native logging hierarchy, visit the [Python logging documentation](https://docs.python.org/3/library/logging.html).

### Prerequisites

> [!div class="checklist"]
> * Python version 3.11 or earlier.
> * App Service must be deployed as code. Custom containers aren't supported.

### Autoinstrumentation in the Azure portal

1. Select **Application Insights** in the left-hand navigation menu of your app service, then select **Enable**.

    :::image type="content"source="./media/codeless-app-service/enable.png" alt-text=" Screenshot that shows the Application Insights tab with Enable selected.":::

1. Create a new resource or select an existing Application Insights resource for this application.

    > [!NOTE]
    > When you select **OK** to create a new resource, you're prompted to **Apply monitoring settings**. Selecting **Continue** links your new Application Insights resource to your app service. Your app service then restarts.

    :::image type="content"source="./media/codeless-app-service/change-resource.png" alt-text="Screenshot that shows the Change your resource dropdown.":::

1. You specify the resource, and it's ready to use.

    :::image type="content"source="./media/codeless-app-service/app-service-python.png" alt-text="Screenshot of instrument your application." lightbox="./media/codeless-app-service/app-service-python.png":::

### Python libraries

After instrumenting, you collect calls and metrics from these Python libraries:

| Instrumentation | Supported library Name | Supported versions |
| --------------- | ---------------------- | ------------------ |
| [OpenTelemetry Django Instrumentation](https://github.com/open-telemetry/opentelemetry-python-contrib/tree/main/instrumentation/opentelemetry-instrumentation-django) | [django](https://pypi.org/project/Django/) | [link](https://github.com/open-telemetry/opentelemetry-python-contrib/blob/main/instrumentation/opentelemetry-instrumentation-django/src/opentelemetry/instrumentation/django/package.py#L16) |
| [OpenTelemetry FastApi Instrumentation](https://github.com/open-telemetry/opentelemetry-python-contrib/tree/main/instrumentation/opentelemetry-instrumentation-fastapi) | [fastapi](https://pypi.org/project/fastapi/) | [link](https://github.com/open-telemetry/opentelemetry-python-contrib/blob/main/instrumentation/opentelemetry-instrumentation-fastapi/src/opentelemetry/instrumentation/fastapi/package.py#L16) |
| [OpenTelemetry Flask Instrumentation](https://github.com/open-telemetry/opentelemetry-python-contrib/tree/main/instrumentation/opentelemetry-instrumentation-flask) | [flask](https://pypi.org/project/Flask/) | [link](https://github.com/open-telemetry/opentelemetry-python-contrib/blob/main/instrumentation/opentelemetry-instrumentation-flask/src/opentelemetry/instrumentation/flask/package.py#L16) |
| [OpenTelemetry Psycopg2 Instrumentation](https://github.com/open-telemetry/opentelemetry-python-contrib/tree/main/instrumentation/opentelemetry-instrumentation-psycopg2) | [psycopg2](https://pypi.org/project/psycopg2/) | [link](https://github.com/open-telemetry/opentelemetry-python-contrib/blob/main/instrumentation/opentelemetry-instrumentation-psycopg2/src/opentelemetry/instrumentation/psycopg2/package.py#L16) |
| [OpenTelemetry Requests Instrumentation](https://github.com/open-telemetry/opentelemetry-python-contrib/tree/main/instrumentation/opentelemetry-instrumentation-requests) | [requests](https://pypi.org/project/requests/) | [link](https://github.com/open-telemetry/opentelemetry-python-contrib/blob/main/instrumentation/opentelemetry-instrumentation-requests/src/opentelemetry/instrumentation/requests/package.py#L16) |
| [OpenTelemetry UrlLib Instrumentation](https://github.com/open-telemetry/opentelemetry-python-contrib/tree/main/instrumentation/opentelemetry-instrumentation-urllib3) | [urllib](https://docs.python.org/3/library/urllib.html) | All |
| [OpenTelemetry UrlLib3 Instrumentation](https://github.com/open-telemetry/opentelemetry-python-contrib/tree/main/instrumentation/opentelemetry-instrumentation-urllib3) | [urllib3](https://pypi.org/project/urllib3/) | [link](https://github.com/open-telemetry/opentelemetry-python-contrib/blob/main/instrumentation/opentelemetry-instrumentation-urllib3/src/opentelemetry/instrumentation/urllib3/package.py#L16) |

### Django instrumentation

In order to use the OpenTelemetry Django instrumentation, you need to set the `DJANGO_SETTINGS_MODULE` environment variable in the App Service settings to point from your app folder to your settings module. 

For more information, see the [Django documentation](https://docs.djangoproject.com/en/4.2/topics/settings/#envvar-DJANGO_SETTINGS_MODULE).

### Add a community instrumentation library

You can collect more data automatically when you include instrumentation libraries from the OpenTelemetry community.

[!INCLUDE [azure-monitor-app-insights-opentelemetry-community-library-warning](includes/azure-monitor-app-insights-opentelemetry-community-library-warning.md)]

To add the community OpenTelemetry Instrumentation Library, install it via your app's `requirements.txt` file. OpenTelemetry autoinstrumentation automatically picks up and instruments all installed libraries. Find the list of community libraries [here](https://github.com/open-telemetry/opentelemetry-python-contrib/tree/main/instrumentation).

---

## Manually upgrade the monitoring extension/agent

## [ASP.NET Core](#tab/aspnetcore)

### Upgrade from versions 2.8.9 and up

Upgrading from version 2.8.9 happens automatically, without any extra actions. The new monitoring bits are delivered in the background to the target app service, and are picked up on application restart.

To check which version of the extension you're running, go to `https://yoursitename.scm.azurewebsites.net/ApplicationInsights`.

:::image type="content"source="./media/codeless-app-service/extension-version.png" alt-text="Screenshot that shows the URL path to check the version of the extension you're running." border="false":::

### Upgrade from versions 1.0.0 - 2.6.5

Starting with version 2.8.9, the preinstalled site extension is used. If you're using an earlier version, you can update via one of two ways:

* [Upgrade by enabling via the Azure portal](#enable-application-insights): Even if you have the Application Insights extension for App Service installed, the UI shows only the **Enable** button. Behind the scenes, the old private site extension is removed.

* [Upgrade through PowerShell](#enable-through-powershell):

    1. Set the application settings to enable the preinstalled site extension `ApplicationInsightsAgent`. For more information, see [Enable through PowerShell](#enable-through-powershell).
    1. Manually remove the private site extension named **Application Insights extension for Azure App Service**.

If the upgrade is done from a version before 2.5.1, check that the `ApplicationInsights` DLLs are removed from the application bin folder. For more information, see [Troubleshooting](#troubleshooting).

## [.NET](#tab/net)

### Upgrade from versions 2.8.9 and up

Upgrading from version 2.8.9 happens automatically, without any extra actions. The new monitoring bits are delivered in the background to the target app service, and are picked up on application restart.

To check which version of the extension you're running, go to `https://yoursitename.scm.azurewebsites.net/ApplicationInsights`.

:::image type="content"source="./media/codeless-app-service/extension-version.png" alt-text="Screenshot that shows the URL path to check the version of the extension you're running." border="false":::

### Upgrade from versions 1.0.0 - 2.6.5

Starting with version 2.8.9, the preinstalled site extension is used. If you're using an earlier version, you can update via one of two ways:

* [Upgrade by enabling via the Azure portal](#enable-application-insights): Even if you have the Application Insights extension for App Service installed, the UI shows only the **Enable** button. Behind the scenes, the old private site extension is removed.

* [Upgrade through PowerShell](#enable-through-powershell):

    1. Set the application settings to enable the preinstalled site extension `ApplicationInsightsAgent`. For more information, see [Enable through PowerShell](#enable-through-powershell).
    1. Manually remove the private site extension named **Application Insights extension for Azure App Service**.

If the upgrade is done from a version before 2.5.1, check that the `ApplicationInsights` DLLs are removed from the application bin folder. For more information, see [Troubleshooting](#troubleshooting).

## [Java](#tab/java)

The Application Insights Java version is updated automatically as part of App Service updates. If you encounter an issue that got fixed in the latest version of the Application Insights Java agent, you can update it manually.

1. Upload the Java agent jar file to App Service.

    a. First, get the latest version of Azure CLI by following the instructions [here](/cli/azure/install-azure-cli-windows?tabs=azure-cli).

    b. Next, get the latest version of the Application Insights Java agent by following the instructions [here](./opentelemetry-enable.md?tabs=java).

    c. Then, deploy the Java agent jar file to App Service using the following command: `az webapp deploy --src-path applicationinsights-agent-{VERSION_NUMBER}.jar --target-path java/applicationinsights-agent-{VERSION_NUMBER}.jar --type static --resource-group {YOUR_RESOURCE_GROUP} --name {YOUR_APP_SVC_NAME}`. Alternatively, you can use [this guide](/azure/app-service/quickstart-java?tabs=javase&pivots=platform-linux#3---configure-the-maven-plugin) to deploy the agent through the Maven plugin.

1. Disable Application Insights via the Application Insights tab in the Azure portal.

1. Once the agent jar file is uploaded, go to App Service configurations. If you need to use **Startup Command** for Linux, include JVM arguments:

    :::image type="content"source="./media/codeless-app-service/startup-command.png" alt-text="Screenshot of startup command.":::
    
    **Startup Command** doesn't honor `JAVA_OPTS` for JavaSE or `CATALINA_OPTS` for Tomcat.
    
    If you don't use **Startup Command**, create a new environment variable, `JAVA_OPTS` for JavaSE or `CATALINA_OPTS` for Tomcat, with the value
    `-javaagent:{PATH_TO_THE_AGENT_JAR}/applicationinsights-agent-{VERSION_NUMBER}.jar`.

1. To apply the changes, restart the app.

> [!NOTE]
> If you set the `JAVA_OPTS` for JavaSE or `CATALINA_OPTS` for Tomcat environment variable, you have to disable Application Insights in the Azure portal. Alternatively, if you prefer to enable Application Insights from the Azure portal, make sure that you don't set the `JAVA_OPTS` for JavaSE or `CATALINA_OPTS` for Tomcat variable in App Service configurations settings.

## [Node.js](#tab/nodejs)

The Application Insights Node.js version is updated automatically as part of App Service updates and *can't be updated manually*.

If you encounter an issue that got fixed in the latest version of the [Application Insights SDK](nodejs.md), you can remove autoinstrumentation and manually instrument your application with the most recent SDK version.

## [Python (Preview)](#tab/python)

The Application Insights Python version is updated automatically as part of App Service updates and *can't be updated manually*.

---

## Configure the monitoring extension/agent

## [ASP.NET Core](#tab/aspnetcore)

We currently don't offer options to configure the monitoring extension for ASP.NET Core.

## [.NET](#tab/net)

To configure sampling, which you could previously control via the *applicationinsights.config* file, you can now interact with it via application settings with the corresponding prefix `MicrosoftAppInsights_AdaptiveSamplingTelemetryProcessor`.
    
* For example, to change the initial sampling percentage, you can create an application setting of `MicrosoftAppInsights_AdaptiveSamplingTelemetryProcessor_InitialSamplingPercentage` and a value of `100`.

* To disable sampling, set `MicrosoftAppInsights_AdaptiveSamplingTelemetryProcessor_MinSamplingPercentage` to a value of `100`.

* Supported settings include:
    * `MicrosoftAppInsights_AdaptiveSamplingTelemetryProcessor_InitialSamplingPercentage`
    * `MicrosoftAppInsights_AdaptiveSamplingTelemetryProcessor_MinSamplingPercentage`
    * `MicrosoftAppInsights_AdaptiveSamplingTelemetryProcessor_EvaluationInterval`
    * `MicrosoftAppInsights_AdaptiveSamplingTelemetryProcessor_MaxTelemetryItemsPerSecond`

* For the list of supported adaptive sampling telemetry processor settings and definitions, see the [code](https://github.com/microsoft/ApplicationInsights-dotnet/blob/master/BASE/Test/ServerTelemetryChannel.Test/TelemetryChannel.Tests/AdaptiveSamplingTelemetryProcessorTest.cs) and [sampling documentation](./sampling.md#configuring-adaptive-sampling-for-aspnet-applications).

## [Java](#tab/java)

After specifying which resource to use, you can configure the Java agent. If you don't configure the Java agent, default configurations apply.

The full [set of configurations](./java-standalone-config.md) is available. You just need to paste a valid [json file](./java-standalone-config.md#an-example). **Exclude the connection string and any configurations that are in preview** - you're able to add the items that are currently in preview as they become generally available.

Once you modify the configurations through the Azure portal, `APPLICATIONINSIGHTS_CONFIGURATION_FILE` environment variable are automatically populated and appear in App Service settings panel. This variable contains the full json content that you pasted in the Azure portal configuration text box for your Java app. 

:::image type="content"source="./media/codeless-app-service/create-app-service-ai.png" alt-text="Screenshot of instrument your application.":::

## [Node.js](#tab/nodejs)

The Node.js agent can be configured using JSON. Set the `APPLICATIONINSIGHTS_CONFIGURATION_CONTENT` environment variable to the JSON string or set the `APPLICATIONINSIGHTS_CONFIGURATION_FILE` environment variable to the file path containing the JSON.

```json
"samplingPercentage": 80,
"enableAutoCollectExternalLoggers": true,
"enableAutoCollectExceptions": true,
"enableAutoCollectHeartbeat": true,
"enableSendLiveMetrics": true,
...

```

The full [set of configurations](https://github.com/microsoft/ApplicationInsights-node.js#configuration) is available. You just need to use a valid json file.

## [Python (Preview)](#tab/python)

You can configure with [OpenTelemetry environment variables](https://opentelemetry.io/docs/reference/specification/sdk-environment-variables/) such as:

| **Environment Variable** | **Description** |
|--------------------------|-----------------|
| `OTEL_SERVICE_NAME`, `OTEL_RESOURCE_ATTRIBUTES` | Specifies the OpenTelemetry [Resource Attributes](https://opentelemetry.io/docs/specs/otel/resource/sdk/) associated with your application. You can set any Resource Attributes with [OTEL_RESOURCE_ATTRIBUTES](https://opentelemetry-python.readthedocs.io/en/latest/sdk/environment_variables.html?highlight=OTEL_RESOURCE_ATTRIBUTES%20#opentelemetry-sdk-environment-variables) or use [OTEL_SERVICE_NAME](https://opentelemetry-python.readthedocs.io/en/latest/sdk/environment_variables.html?highlight=OTEL_RESOURCE_ATTRIBUTES%20#opentelemetry.sdk.environment_variables.OTEL_SERVICE_NAME) to only set the `service.name`. |
| `OTEL_LOGS_EXPORTER` | If set to `None`, disables collection and export of logging telemetry. |
| `OTEL_METRICS_EXPORTER` | If set to `None`, disables collection and export of metric telemetry. |
| `OTEL_TRACES_EXPORTER` | If set to `None`, disables collection and export of distributed tracing telemetry. |
| `OTEL_BLRP_SCHEDULE_DELAY` | Specifies the logging export interval in milliseconds. Defaults to 5000. |
| `OTEL_BSP_SCHEDULE_DELAY` | Specifies the distributed tracing export interval in milliseconds. Defaults to 5000. |
| `OTEL_TRACES_SAMPLER_ARG` | Specifies the ratio of distributed tracing telemetry to be [sampled](./sampling.md). Accepted values range from 0 to 1. The default is 1.0, meaning no telemetry is sampled out. |
| `OTEL_PYTHON_DISABLED_INSTRUMENTATIONS` | Specifies which OpenTelemetry instrumentations to disable. When disabled, instrumentations aren't executed as part of autoinstrumentation. Accepts a comma-separated list of lowercase [library names](#enable-application-insights). For example, set it to `"psycopg2,fastapi"` to disable the Psycopg2 and FastAPI instrumentations. It defaults to an empty list, enabling all supported instrumentations. |

---

## Enable client-side monitoring

## [ASP.NET Core](#tab/aspnetcore)

Client-side monitoring is enabled by default for ASP.NET Core apps with **Recommended** collection, regardless of whether the app setting `APPINSIGHTS_JAVASCRIPT_ENABLED` is present.

If you want to disable client-side monitoring:

1. Select **Settings** > **Configuration**.
1. Under **Application settings**, create a **New application setting** with the following information:

    * **Name**: `APPINSIGHTS_JAVASCRIPT_ENABLED`
    * **Value**: `false`

1. **Save** the settings. Restart your app.

## [.NET](#tab/net)

Client-side monitoring is an opt-in for ASP.NET. To enable client-side monitoring:

1. Select **Settings** > **Configuration**.
1. Under **Application settings**, create a new application setting:

     - **Name**: Enter **APPINSIGHTS_JAVASCRIPT_ENABLED**.
     - **Value**: Enter **true**.

1. Save the settings and restart your app.

To disable client-side monitoring, either remove the associated key value pair from **Application settings** or set the value to **false**.

## [Java](#tab/java)

To enable client-side monitoring, the Java agent can inject the [Browser SDK Loader (Preview)](javascript-sdk.md?tabs=javascriptwebsdkloaderscript#add-the-javascript-code) into your application's HTML pages, including configuring the appropriate connection string.

For more information, go to [Configuration options: Azure Monitor Application Insights for Java](java-standalone-config.md#browser-sdk-loader-preview).

## [Node.js](#tab/nodejs)

To enable client-side monitoring for your Node.js application, you need to [manually add the client-side JavaScript SDK to your application](./javascript.md).

## [Python (Preview)](#tab/python)

To enable client-side monitoring for your Python application, you need to [manually add the client-side JavaScript SDK to your application](./javascript.md).

---

## Automate monitoring

In order to enable telemetry collection with Application Insights, only the following Application settings need to be set:

## [ASP.NET Core](#tab/aspnetcore)

:::image type="content"source="./media/codeless-app-service/application-settings-net-core.png" alt-text="Screenshot that shows App Service application settings with Application Insights settings.":::

### Application settings definitions

| App setting name | Definition | Value |
|------------------|:-----------|------:|
| ApplicationInsightsAgent_EXTENSION_VERSION | Main extension, which controls runtime monitoring. | `~2` for Windows or `~3` for Linux |
| XDT_MicrosoftApplicationInsights_Mode | In default mode, only essential features are enabled to ensure optimal performance. | `disabled` or `recommended`. |
| XDT_MicrosoftApplicationInsights_PreemptSdk | For ASP.NET Core apps only. Enables Interop (interoperation) with the Application Insights SDK. Loads the extension side by side with the SDK and uses it to send telemetry. (Disables the Application Insights SDK.) | `1` |

## [.NET](#tab/net)

:::image type="content"source="./media/codeless-app-service/application-settings-net.png" alt-text="Screenshot that shows App Service application settings with Application Insights settings.":::

### Application settings definitions

| App setting name | Definition | Value |
|------------------|:-----------|------:|
| ApplicationInsightsAgent_EXTENSION_VERSION | Main extension, which controls runtime monitoring. | `~2` |
| XDT_MicrosoftApplicationInsights_Mode |  In default mode, only essential features are enabled to ensure optimal performance. | `default` or `recommended` |
| InstrumentationEngine_EXTENSION_VERSION | Controls if the binary-rewrite engine `InstrumentationEngine` are turned on. This setting has performance implications and affects cold start/startup time. | `~1` |
| XDT_MicrosoftApplicationInsights_BaseExtensions | Controls if SQL and Azure table text are captured along with the dependency calls. Performance warning: Application cold startup time is affected. This setting requires the `InstrumentationEngine`. | `~1` |

## [Java](#tab/java)

:::image type="content"source="./media/codeless-app-service/application-settings-java.png" alt-text="Screenshot of App Service Application Settings with available Application Insights settings.":::

### Application settings definitions

| App setting name                           | Definition                                         | Value                                    |
|--------------------------------------------|----------------------------------------------------|-----------------------------------------:|
| ApplicationInsightsAgent_EXTENSION_VERSION | Main extension, which controls runtime monitoring. | `~2` in Windows or `~3` in Linux.        |
| XDT_MicrosoftApplicationInsights_Java      | Flag to control if Java agent is included.         | `0` or `1` (only applicable in Windows). |

> [!NOTE]
> Snapshot Debugger isn't available for Java applications.

## [Node.js](#tab/nodejs)

:::image type="content"source="./media/codeless-app-service/application-settings-nodejs.png" alt-text="Screenshot of App Service Application Settings with available Application Insights settings."::: 

### Application settings definitions

| App setting name                           | Definition                                         | Value                                    |
|--------------------------------------------|----------------------------------------------------|-----------------------------------------:|
| ApplicationInsightsAgent_EXTENSION_VERSION | Main extension, which controls runtime monitoring. | `~2` in Windows or `~3` in Linux.        |
| XDT_MicrosoftApplicationInsights_NodeJS    | Flag to control if Node.js agent is included.      | `0` or `1` (only applicable in Windows). |

> [!NOTE]
> Snapshot Debugger isn't available for Node.js applications.

## [Python (Preview)](#tab/python)

:::image type="content"source="./media/codeless-app-service/application-settings-python.png" alt-text="Screenshot of App Service Application Settings with available Application Insights settings." lightbox="./media/codeless-app-service/application-settings-python.png":::

### Application settings definitions

| App setting name                           | Definition                                                 | Value                                    |
|--------------------------------------------|------------------------------------------------------------|-----------------------------------------:|
| APPLICATIONINSIGHTS_CONNECTION_STRING      | Connections string for your Application Insights resource. | Example: abcd1234-ab12-cd34-abcd1234abcd |
| ApplicationInsightsAgent_EXTENSION_VERSION | Main extension, which controls runtime monitoring.         | `~3`                                     |

> [!NOTE]
> Snapshot Debugger isn't available for Python applications.

---

[!INCLUDE [azure-web-apps-arm-automation](includes/azure-monitor-app-insights-azure-web-apps-arm-automation.md)]

## Troubleshooting

[!INCLUDE [azure-monitor-app-insights-test-connectivity](includes/azure-monitor-app-insights-test-connectivity.md)]

## [ASP.NET Core](#tab/aspnetcore)

> [!NOTE]
> When you create a web app with the `ASP.NET Core` runtimes in App Service, it deploys a single static HTML page as a starter website. We *do not* recommend that you troubleshoot an issue with the default template. Deploy an application before you troubleshoot an issue.

### Missing telemetry

#### Windows

1. Check that the `ApplicationInsightsAgent_EXTENSION_VERSION` app setting is set to a value of `~2`.

1. Browse to `https://yoursitename.scm.azurewebsites.net/ApplicationInsights`.

    :::image type="content"source="./media/codeless-app-service/app-insights-sdk-status.png" alt-text="Screenshot that shows the link above the results page."border ="false":::
    
    * Confirm that **Application Insights Extension Status** is `Pre-Installed Site Extension, version 2.8.x.xxxx, is running.`
    
        If it isn't running, follow the instructions in the section [Enable Application Insights monitoring](#enable-application-insights).

    * Confirm that the status source exists and looks like `Status source D:\home\LogFiles\ApplicationInsights\status\status_RD0003FF0317B6_4248_1.json`.

        If a similar value isn't present, it means the application isn't currently running or isn't supported. To ensure that the application is running, try manually visiting the application URL/application endpoints, which allows the runtime information to become available.

    * Confirm that **IKeyExists** is `True`. If it's `False`, add `APPINSIGHTS_INSTRUMENTATIONKEY` and `APPLICATIONINSIGHTS_CONNECTION_STRING` with your ikey GUID to your application settings.

    * If your application refers to any Application Insights packages, enabling the App Service integration might not take effect, and the data might not appear in Application Insights. An example would be if you previously instrumented, or attempted to instrument, your app with the [ASP.NET Core SDK](./asp-net-core.md). To fix the issue, in the Azure portal, turn on **Interop with Application Insights SDK**.
    
        > [!IMPORTANT]
        > This functionality is in preview.

        :::image type="content"source="./media/codeless-app-service/interop.png" alt-text=" Screenshot that shows the interop setting enabled.":::
        
        The data is sent using a codeless approach, even if the Application Insights SDK was originally used or attempted to be used.

        > [!IMPORTANT]
        > If the application used the Application Insights SDK to send any telemetry, the telemetry will be disabled. In other words, custom telemetry (for example, any `Track*()` methods) and custom settings (such as sampling) will be disabled.

#### Linux

1. Check that the `ApplicationInsightsAgent_EXTENSION_VERSION` app setting is set to a value of `~3`.

1. Browse to `https://your site name.scm.azurewebsites.net/ApplicationInsights`.

1. Within this site, confirm:
    * The status source exists and looks like `Status source /var/log/applicationinsights/status_abcde1234567_89_0.json`.
    * The value `Auto-Instrumentation enabled successfully` is displayed. If a similar value isn't present, it means the application isn't running or isn't supported. To ensure that the application is running, try manually visiting the application URL/application endpoints, which allows the runtime information to become available.
    * **IKeyExists** is `True`. If it's `False`, add `APPINSIGHTS_INSTRUMENTATIONKEY` and `APPLICATIONINSIGHTS_CONNECTION_STRING` with your ikey GUID to your application settings.
    
    :::image type="content" source="media/codeless-app-service/auto-instrumentation-status.png" alt-text="Screenshot that shows the autoinstrumentation status webpage." lightbox="media/codeless-app-service/auto-instrumentation-status.png":::

### Default website deployed with web apps doesn't support automatic client-side monitoring

When you create a web app with the ASP.NET Core runtimes in App Service, it deploys a single static HTML page as a starter website. The static webpage also loads an ASP.NET-managed web part in IIS. This behavior allows for testing codeless server-side monitoring but doesn't support automatic client-side monitoring.

If you want to test out codeless server and client-side monitoring for ASP.NET Core in an App Service web app, we recommend following the official guides for [creating an ASP.NET Core web app](/azure/app-service/quickstart-dotnetcore). Afterwards, use the instructions in the current article to enable monitoring.

### PHP and WordPress aren't supported

PHP and WordPress sites aren't supported. There's currently no officially supported SDK/agent for server-side monitoring of these workloads. To track client-side transactions on a PHP or WordPress site, add the client-side JavaScript to your webpages using the [JavaScript SDK](./javascript.md).

The following table provides an explanation of what these values mean, their underlying causes, and recommended fixes.

| Problem value | Explanation | Fix |
|---------------|-------------|-----|
| `AppAlreadyInstrumented:true` | This value indicates that the extension detected some aspect of the SDK already present in the application and backs off. A reference to `Microsoft.ApplicationInsights.AspNetCore` or `Microsoft.ApplicationInsights` can cause this value. | Remove the references. Some of these references are added by default from certain Visual Studio templates. Older versions of Visual Studio reference `Microsoft.ApplicationInsights`. |
| `AppAlreadyInstrumented:true` | The presence of `Microsoft.ApplicationsInsights` DLL in the app folder from a previous deployment can also cause this value. | Clean the app folder to ensure that these DLLs are removed. Check both your local app's bin directory and the *wwwroot* directory on the App Service. (To check the wwwroot directory of your App Service web app, select **Advanced Tools (Kudu**) > **Debug console** > **CMD** > **home\site\wwwroot**). |
| `IKeyExists:false` | This value indicates that the instrumentation key isn't present in the app setting `APPINSIGHTS_INSTRUMENTATIONKEY`. Possible causes include accidentally removing the values or forgetting to set the values in automation script. | Make sure the setting is present in the App Service application settings. |

## [.NET](#tab/net)

> [!NOTE]
> When you create a web app with the `ASP.NET` runtimes in App Service, it deploys a single static HTML page as a starter website. We do *not* recommend that you troubleshoot an issue with a default template. Deploy an application before you troubleshoot an issue.

### Missing telemetry

1. Check that the `ApplicationInsightsAgent_EXTENSION_VERSION` app setting is set to a value of `~2`.

1. Browse to `https://yoursitename.scm.azurewebsites.net/ApplicationInsights`.  

    :::image type="content"source="./media/codeless-app-service/app-insights-sdk-status.png" alt-text="Screenshot that shows the preceding link's results page."border ="false":::

    * Confirm that `Application Insights Extension Status` is `Pre-Installed Site Extension, version 2.8.x.xxxx` and is running.

        If it isn't running, follow the instructions to [enable Application Insights monitoring](#enable-application-insights).

    * Confirm that the status source exists and looks like `Status source D:\home\LogFiles\ApplicationInsights\status\status_RD0003FF0317B6_4248_1.json`.

        If a similar value isn't present, it means the application isn't currently running or isn't supported. To ensure that the application is running, try manually visiting the application URL/application endpoints, which allows the runtime information to become available.

    * Confirm that `IKeyExists` is `true`.
        If not, add `APPINSIGHTS_INSTRUMENTATIONKEY` and `APPLICATIONINSIGHTS_CONNECTION_STRING` with your instrumentation key GUID to your application settings.

    * Confirm that there are no entries for `AppAlreadyInstrumented`, `AppContainsDiagnosticSourceAssembly`, and `AppContainsAspNetTelemetryCorrelationAssembly`.

        If any of these entries exist, remove the following packages from your application: `Microsoft.ApplicationInsights`, `System.Diagnostics.DiagnosticSource`, and `Microsoft.AspNet.TelemetryCorrelation`.

### Default website deployed with web apps doesn't support automatic client-side monitoring

When you create a web app with the ASP.NET runtimes in App Service, it deploys a single static HTML page as a starter website. The static webpage also loads an ASP.NET-managed web part in IIS. This page allows for testing codeless server-side monitoring but doesn't support automatic client-side monitoring.

If you want to test out codeless server and client-side monitoring for ASP.NET in an App Service web app, we recommend following the official guides for [creating an ASP.NET Framework web app](/azure/app-service/quickstart-dotnetcore?tabs=netframework48). Afterwards, use the instructions in the current article to enable monitoring.

### APPINSIGHTS_JAVASCRIPT_ENABLED and urlCompression not supported

If you use `APPINSIGHTS_JAVASCRIPT_ENABLED=true` in cases where content is encoded, you might get errors like:

* 500 URL rewrite error.
* 500.53 URL rewrite module error with the message "Outbound rewrite rules can't be applied when the content of the HTTP response is encoded ('gzip')."

An error occurs because the `APPINSIGHTS_JAVASCRIPT_ENABLED` application setting is set to `true` and content encoding is present at the same time. This scenario isn't supported yet. The workaround is to remove `APPINSIGHTS_JAVASCRIPT_ENABLED` from your application settings. Unfortunately, if client/browser-side JavaScript instrumentation is still required, manual SDK references are needed for your webpages. Follow the [instructions](https://github.com/Microsoft/ApplicationInsights-JS#snippet-setup-ignore-if-using-npm-setup) for manual instrumentation with the JavaScript SDK.

For the latest information on the Application Insights agent/extension, see the [release notes](https://github.com/MohanGsk/ApplicationInsights-Home/blob/master/app-insights-web-app-extensions-releasenotes.md).

### PHP and WordPress aren't supported

PHP and WordPress sites aren't supported. There's currently no officially supported SDK/agent for server-side monitoring of these workloads. To track client-side transactions on a PHP or WordPress site, add the client-side JavaScript to your webpages using the [JavaScript SDK](./javascript.md).

The following table provides an explanation of what these values mean, their underlying causes, and recommended fixes.

| Problem value | Explanation | Fix |
|---------------|-------------|-----|
| `AppAlreadyInstrumented:true` | This value indicates that the extension detected some aspect of the SDK already present in the application and backs off. A reference to `System.Diagnostics.DiagnosticSource`, `Microsoft.AspNet.TelemetryCorrelation`, or `Microsoft.ApplicationInsights` can cause this value. | Remove the references. Some of these references are added by default from certain Visual Studio templates. Older versions of Visual Studio might add references to `Microsoft.ApplicationInsights`. |
|`AppAlreadyInstrumented:true` | The presence of the preceding DLLs in the app folder from a previous deployment can also cause this value. | Clean the app folder to ensure that these DLLs are removed. Check both your local app's bin directory and the wwwroot directory on the App Service resource. To check the wwwroot directory of your App Service web app, select **Advanced Tools (Kudu)** > **Debug console** > **CMD** > **home\site\wwwroot**. |
| `AppContainsAspNetTelemetryCorrelationAssembly: true` | This value indicates that the extension detected references to `Microsoft.AspNet.TelemetryCorrelation` in the application and backs off. | Remove the reference. |
| `AppContainsDiagnosticSourceAssembly**:true`| This value indicates that the extension detected references to `System.Diagnostics.DiagnosticSource` in the application and backs off.| For ASP.NET, remove the reference. |
| `IKeyExists:false` | This value indicates that the instrumentation key isn't present in the app setting `APPINSIGHTS_INSTRUMENTATIONKEY`. Possible causes might be that the values were accidentally removed, or you forgot to set the values in the automation script. | Make sure the setting is present in the App Service application settings. |

### System.IO.FileNotFoundException after 2.8.44 upgrade

The 2.8.44 version of autoinstrumentation upgrades Application Insights SDK to 2.20.0. The Application Insights SDK has an indirect reference to `System.Runtime.CompilerServices.Unsafe.dll` through `System.Diagnostics.DiagnosticSource.dll`. If the application has [binding redirect](/dotnet/framework/configure-apps/file-schema/runtime/bindingredirect-element) for `System.Runtime.CompilerServices.Unsafe.dll` and if this library isn't present in the application folder, it might throw `System.IO.FileNotFoundException`.

To resolve this issue, remove the binding redirect entry for `System.Runtime.CompilerServices.Unsafe.dll` from the web.config file. If the application wanted to use `System.Runtime.CompilerServices.Unsafe.dll`, set the binding redirect as shown here:

```  
<dependentAssembly>
    <assemblyIdentity name="System.Runtime.CompilerServices.Unsafe" publicKeyToken="b03f5f7f11d50a3a" culture="neutral" />
    <bindingRedirect oldVersion="0.0.0.0-4.0.4.1" newVersion="4.0.4.1" />
</dependentAssembly>
```

As a temporary workaround, you could set the app setting `ApplicationInsightsAgent_EXTENSION_VERSION` to a value of `2.8.37`. This setting triggers App Service to use the old Application Insights extension. Temporary mitigations should only be used as an interim.

## [Java](#tab/java)

### Missing telemetry

1. Check that `ApplicationInsightsAgent_EXTENSION_VERSION` app setting is set to a value of `~2` on Windows, `~3` on Linux

1. Examine the log file to see that the agent started successfully: browse to `https://yoursitename.scm.azurewebsites.net/`, under SSH change to the root directory, the log file is located under LogFiles/ApplicationInsights.
  
    :::image type="content"source="./media/codeless-app-service/app-insights-java-status.png" alt-text="Screenshot of the link above results page."::: 

1. After enabling application monitoring for your Java app, you can validate that the agent is working by looking at the live metrics - even before you deploy and app to App Service you'll see some requests from the environment. Remember that the full set of telemetry is only available when you have your app deployed and running.

1. Set `APPLICATIONINSIGHTS_SELF_DIAGNOSTICS_LEVEL` environment variable to `debug` if you don't see any errors and there's no telemetry.

## [Node.js](#tab/nodejs)

### Missing telemetry

#### Windows

1. Check that `ApplicationInsightsAgent_EXTENSION_VERSION` app setting is set to a value of `~2`.
1. Browse to `https://yoursitename.scm.azurewebsites.net/ApplicationInsights`.  

    :::image type="content"source="./media/codeless-app-service/app-insights-sdk-status.png" alt-text="Screenshot of the link above results page."border ="false"::: 

    - Confirm that the `Application Insights Extension Status` is `Pre-Installed Site Extension, version 2.8.x.xxxx, is running.` 

         If it isn't running, follow the [enable Application Insights monitoring instructions](#enable-application-insights).

    - Navigate to *D:\local\Temp\status.json* and open *status.json*.

    Confirm that `SDKPresent` is set to false, `AgentInitializedSuccessfully` to true and `IKey` to have a valid iKey.

    Example of the JSON file:

    ```json
        "AppType":"node.js",
                
        "MachineName":"c89d3a6d0357",
                
        "PID":"47",
                
        "AgentInitializedSuccessfully":true,
                
        "SDKPresent":false,
                
        "IKey":"00000000-0000-0000-0000-000000000000",
                
        "SdkVersion":"1.8.10"
    
    ```

    If `SDKPresent` is true, it means the extension detected that some aspect of the SDK is already present in the Application, and will back-off.

#### Linux

1. Check that `ApplicationInsightsAgent_EXTENSION_VERSION` app setting is set to a value of `~3`.
1. Navigate to */var/log/applicationinsights/* and open *status.json*.

    Confirm that `SDKPresent` is set to false, `AgentInitializedSuccessfully` to true and `IKey` to have a valid iKey.

    Example of the JSON file:

    ```json
        "AppType":"node.js",
                
        "MachineName":"c89d3a6d0357",
                
        "PID":"47",
                
        "AgentInitializedSuccessfully":true,
                
        "SDKPresent":false,
                
        "IKey":"00000000-0000-0000-0000-000000000000",
                
        "SdkVersion":"1.8.10"
    
    ```

    If `SDKPresent` is true, it means the extension detected that some aspect of the SDK is already present in the Application, and will back-off.

## [Python (Preview)](#tab/python)

### Duplicate telemetry

Only use autoinstrumentation on App Service if you aren't using manual instrumentation of OpenTelemetry in your code, such as the [Azure Monitor OpenTelemetry Distro](./opentelemetry-enable.md?tabs=python) or the [Azure Monitor OpenTelemetry Exporter](/python/api/overview/azure/monitor-opentelemetry-exporter-readme).

Using autoinstrumentation on top of the manual instrumentation could cause duplicate telemetry and increase your cost. In order to use App Service OpenTelemetry autoinstrumentation, first remove manual instrumentation of OpenTelemetry from your code.

If you're seeing unexpected charges or high costs in Application Insights, this guide can help. It covers common causes like high telemetry volume, data ingestion spikes, and misconfigured sampling. It's especially useful if you're troubleshooting issues related to cost spikes, telemetry volume, sampling not working, data caps, high ingestion, or unexpected billing. To get started, see [Troubleshoot high data ingestion in Application Insights](/troubleshoot/azure/azure-monitor/app-insights/telemetry/troubleshoot-high-data-ingestion).

### Missing telemetry

If you're missing telemetry, follow these steps to confirm that autoinstrumentation is enabled correctly.

1. Confirm that autoinstrumentation is enabled in the Application Insights experience on your App Service resource.

    :::image type="content"source="./media/codeless-app-service/enable.png" alt-text="Screenshot of Application Insights tab with enable selected." lightbox="./media/codeless-app-service/enable.png"::: 

1. Confirm that the `ApplicationInsightsAgent_EXTENSION_VERSION` app setting is set to a value of `~3` and that your `APPLICATIONINSIGHTS_CONNECTION_STRING` points to the appropriate Application Insights resource.
    
    :::image type="content"source="./media/codeless-app-service/application-settings-python.png" alt-text="Screenshot of App Service Application Settings with available Application Insights settings." lightbox="./media/codeless-app-service/application-settings-python.png":::

1. Check autoinstrumentation diagnostics and status logs.

    a. Navigate to */var/log/applicationinsights/* and open status_*.json.

    b. Confirm that `AgentInitializedSuccessfully` is set to true and `IKey` to have a valid iKey.

    Example JSON file:

    ```json
        "AgentInitializedSuccessfully":true,
                
        "AppType":"python",
                
        "MachineName":"c89d3a6d0357",
                
        "PID":"47",
                
        "IKey":"00000000-0000-0000-0000-000000000000",
                
        "SdkVersion":"1.0.0"
    
    ```

    The `applicationinsights-extension.log` file in the same folder may show other helpful diagnostics.

### Django apps

If your app uses Django and is either failing to start or using incorrect settings, make sure to set the `DJANGO_SETTINGS_MODULE` environment variable. See the [Django Instrumentation](#django-instrumentation) section for details.

For the latest updates and bug fixes, [consult the release notes](web-app-extension-release-notes.md).
          
---
## Next steps

* Review frequently asked questions (FAQ): [Monitoring in Azure App Service for .NET, Node.js, Python, and Java applications FAQ](application-insights-faq.yml#monitoring-in-azure-app-service-for--net--node-js--python--and-java-applications). 
* [Enable the .NET Profiler for Azure App Service apps](./profiler.md) on your live app.
* [Enable Azure diagnostics](../agents/diagnostics-extension-to-application-insights.md) to be sent to Application Insights.
* [Monitor service health metrics](../data-platform.md) to make sure your service is available and responsive.
* [Receive alert notifications](../alerts/alerts-overview.md) whenever operational events happen or metrics cross a threshold.
* [Set up availability tests](availability-overview.md) for your application.

