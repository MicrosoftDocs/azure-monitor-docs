---
title: Enable application monitoring in Azure App Service for .NET, Node.js, Python, and Java applications - Azure Monitor | Microsoft Docs
description: Application performance monitoring for Azure App Service. Chart load and response time, dependency information, and set alerts on performance.
ms.topic: how-to
ms.date: 02/28/2025
---

# Enable application monitoring in Azure App Service for .NET, Node.js, Python, and Java applications

Autoinstrumentation, also referred to as *runtime* monitoring, is the easiest way to enable Application Insights for Azure App Service without requiring any code changes or advanced configurations. Based on your specific scenario, evaluate whether you require more advanced monitoring through [manual instrumentation](opentelemetry-overview.md).

[!INCLUDE [azure-monitor-instrumentation-key-deprecation](~/reusable-content/ce-skilling/azure/includes/azure-monitor-instrumentation-key-deprecation.md)]

## Enable Application Insights

## [ASP.NET Core](#tab/aspnetcore)

> [!IMPORTANT]
> If both autoinstrumentation monitoring and manual SDK-based instrumentation are detected, only the manual instrumentation settings are honored. This arrangement prevents duplicate data from being sent. To learn more, see [Troubleshoot Application Insights integration with Azure App Service](/troubleshoot/azure/azure-monitor/app-insights/telemetry/troubleshoot-app-service-issues).

> [!NOTE]
> * Only .NET Core [Long Term Support](https://dotnet.microsoft.com/platform/support/policy/dotnet-core) (LTS) releases are supported.
> * [Trim self-contained deployments](/dotnet/core/deploying/trimming/trim-self-contained) is *not supported*. Use [manual instrumentation](dotnet.md#manual-installation) instead.

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
> If both autoinstrumentation monitoring and manual SDK-based instrumentation are detected, only the manual instrumentation settings are honored. This arrangement prevents duplicate data from being sent. To learn more, see [Troubleshoot Application Insights integration with Azure App Service](/troubleshoot/azure/azure-monitor/app-insights/telemetry/troubleshoot-app-service-issues).

> [!NOTE]
> The combination of `APPINSIGHTS_JAVASCRIPT_ENABLED` and `urlCompression` isn't supported.

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
> If both autoinstrumentation monitoring and manual SDK-based instrumentation are detected, only the manual instrumentation settings are honored. This arrangement prevents duplicate data from being sent. To learn more, see the [Troubleshoot Application Insights integration with Azure App Service](/troubleshoot/azure/azure-monitor/app-insights/telemetry/troubleshoot-app-service-issues).

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

## [Python](#tab/python)

> [!NOTE]
> * Only use autoinstrumentation on App Service if you aren't using manual instrumentation of OpenTelemetry in your code, such as the [Azure Monitor OpenTelemetry Distro](./opentelemetry-enable.md?tabs=python) or the [Azure Monitor OpenTelemetry Exporter](/python/api/overview/azure/monitor-opentelemetry-exporter-readme). This is to prevent duplicate data from being sent. To learn more about this, check out [Troubleshoot Application Insights integration with Azure App Service](/troubleshoot/azure/azure-monitor/app-insights/telemetry/troubleshoot-app-service-issues).
>
> * [Live Metrics](live-stream.md) isn't available for autoinstrumented Python applications running on Azure App Service. To use this feature, manually instrument your application with the [Azure Monitor OpenTelemetry Distro](opentelemetry-enable.md) instead.

Application Insights for Python integrates with code-based Linux Azure App Service Deploy as Code. Integration with Deploy as Container is not currently available. The integration is GA and adds the Python SDK, which is in GA. It instruments popular Python libraries in your code, letting you automatically gather and correlate dependencies, logs, and metrics. To see which calls and metrics are collected, see [Python libraries](#python-libraries)

Logging telemetry is collected at the level of the root logger. To learn more about Python's native logging hierarchy, visit the [Python logging documentation](https://docs.python.org/3/library/logging.html).

### Prerequisites

> [!div class="checklist"]
> * Python versions 3.9-3.13
> * Linux OS
> * App Service must be Deployed as Code. Custom containers aren't supported.

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

If the upgrade is done from a version before 2.5.1, check that the `ApplicationInsights` DLLs are removed from the application bin folder. For more information, see [Troubleshoot Application Insights integration with Azure App Service](/troubleshoot/azure/azure-monitor/app-insights/telemetry/troubleshoot-app-service-issues).

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

If the upgrade is done from a version before 2.5.1, check that the `ApplicationInsights` DLLs are removed from the application bin folder. For more information, see [Troubleshoot Application Insights integration with Azure App Service](/troubleshoot/azure/azure-monitor/app-insights/telemetry/troubleshoot-app-service-issues).

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

## [Python](#tab/python)

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

## [Python](#tab/python)

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

## [Python](#tab/python)

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

## [Python](#tab/python)

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

See the dedicated [troubleshooting article](/troubleshoot/azure/azure-monitor/app-insights/telemetry/troubleshoot-app-service-issues).

## Next steps

* Review frequently asked questions (FAQ): [Monitoring in Azure App Service for .NET, Node.js, Python, and Java applications FAQ](application-insights-faq.yml#monitoring-in-azure-app-service-for--net--node-js--python--and-java-applications). 
* [Enable the .NET Profiler for Azure App Service apps](./profiler.md) on your live app.
* [Enable Azure diagnostics](../agents/diagnostics-extension-to-application-insights.md) to be sent to Application Insights.
* [Monitor service health metrics](../data-platform.md) to make sure your service is available and responsive.
* [Receive alert notifications](../alerts/alerts-overview.md) whenever operational events happen or metrics cross a threshold.
* [Set up availability tests](availability-overview.md) for your application.

