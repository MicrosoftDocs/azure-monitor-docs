---
title: Connection strings in Application Insights
description: This article explains the components of connection strings and how to use them.
ms.topic: how-to
ms.date: 10/10/2024
---

# Connection strings in Application Insights

Connection strings specify to which Application Insights resource your instrumented application should send telemetry data. A connection string is composed of multiple settings, each represented as a key-value pair and separated by semicolons. This consolidated configuration method simplifies the setup process by eliminating the need for multiple proxy settings.

> [!IMPORTANT]
> The connection string contains an ikey and an ApplicationId.
> 
>The ikey is a unique identifier used by the ingestion service to associate telemetry to a specific Application Insights resource. ***Ikey unique identifiers aren't security tokens or security keys, and aren't considered secrets.***
>Connection strings are enhanced by adding the ApplicationId value. This update is a new feature that supports automatic instrumentation for scenarios utilizing the Open Telemetry SDK.
> If you want to protect your Application Insights resource from misuse, the ingestion endpoint provides authenticated telemetry ingestion options based on [Microsoft Entra ID](azure-ad-authentication.md#microsoft-entra-authentication-for-application-insights).


[!INCLUDE [azure-monitor-instrumentation-key-deprecation](~/reusable-content/ce-skilling/azure/includes/azure-monitor-instrumentation-key-deprecation.md)]

## Connection string capabilities

* **Reliability**: Connection strings make telemetry ingestion more reliable by removing dependencies on global ingestion endpoints.
* **Security**: Connection strings allow authenticated telemetry ingestion by using [Microsoft Entra authentication for Application Insights](azure-ad-authentication.md).
* **Customized endpoints (sovereign or hybrid cloud environments)**: Endpoint settings allow sending data to a specific Azure Government region. ([See examples](connection-strings.md).)
* **Privacy (regional endpoints)**: Connection strings ease privacy concerns by sending data to regional endpoints, ensuring data doesn't leave a geographic region.

## Find your connection string

Your connection string appears in the **Overview** section of your Application Insights resource.

:::image type="content" source="media/migrate-from-instrumentation-keys-to-connection-strings/migrate-from-instrumentation-keys-to-connection-strings.png" alt-text="Screenshot that shows the Application Insights overview and connection string." lightbox="media/migrate-from-instrumentation-keys-to-connection-strings/migrate-from-instrumentation-keys-to-connection-strings.png":::

## Schema

Schema elements are explained in the following sections.

### Max length

The connection has a maximum supported length of 4,096 characters.

### Key-value pairs

A connection string consists of a list of settings represented as key-value pairs separated by a semicolon:
`key1=value1;key2=value2;key3=value3`

> [!TIP]
> Configurable key-value pairs are covered in this document. Some key-value pairs aren't configurable and are set automatically, such as `ApplicationId`. These pairs can be safely ignored if they're observed in your environment.

### Syntax

* `InstrumentationKey` (for example, 00000000-0000-0000-0000-000000000000).
  `InstrumentationKey` is a *required* field.

* `Authorization` (for example, ikey). This setting is optional because today we only support ikey authorization.

* `EndpointSuffix` (for example, applicationinsights.azure.cn). Setting the endpoint suffix tells the SDK which Azure cloud to connect to. The SDK assembles the rest of the endpoint for individual services.

* Explicit endpoints. Any service can be explicitly overridden in the connection string:
    * `IngestionEndpoint` (for example, `https://dc.applicationinsights.azure.com`)
    * `LiveEndpoint` (for example, `https://live.applicationinsights.azure.com`)
    * `ProfilerEndpoint` (for example, `https://profiler.monitor.azure.com`)
    * `SnapshotEndpoint` (for example, `https://snapshot.monitor.azure.com`)

### Endpoint schema

`<prefix>.<suffix>`
* **Prefix:** Defines a service.
* **Suffix:** Defines the common domain name.

#### Valid suffixes

* applicationinsights.azure.cn
* applicationinsights.us

For more information, see [Regions that require endpoint modification](./create-new-resource.md#regions-that-require-endpoint-modification).

#### Valid prefixes

* [Telemetry Ingestion](./app-insights-overview.md): `dc`
* [Live Metrics](./live-stream.md): `live`
* [Profiler for .NET](./profiler-overview.md): `profiler`
* [Snapshot](./snapshot-debugger.md): `snapshot`

## Connection string examples

Here are some examples of connection strings.

### Connection string with an endpoint suffix

`InstrumentationKey=00000000-0000-0000-0000-000000000000;EndpointSuffix=ai.contoso.com;`

In this example, the connection string specifies the endpoint suffix and the SDK constructs service endpoints:

* Authorization scheme defaults to "ikey"
* Instrumentation key: 00000000-0000-0000-0000-000000000000
* The regional service Uniform Resource Identifiers (URIs) are based on the provided endpoint suffix:
    * Ingestion: `https://dc.ai.contoso.com`
    * Live Metrics: `https://live.ai.contoso.com`
    * Profiler for .NET: `https://profiler.ai.contoso.com`
    * Debugger: `https://snapshot.ai.contoso.com`

### Connection string with explicit endpoint overrides

`InstrumentationKey=00000000-0000-0000-0000-000000000000;IngestionEndpoint=https://custom.com:111/;LiveEndpoint=https://custom.com:222/;ProfilerEndpoint=https://custom.com:333/;SnapshotEndpoint=https://custom.com:444/;`

In this example, the connection string specifies explicit overrides for every service. The SDK uses the exact endpoints provided without modification:

* Authorization scheme defaults to "ikey"
* Instrumentation key: 00000000-0000-0000-0000-000000000000
* The regional service URIs are based on the explicit override values:
    * Ingestion: `https://custom.com:111/`
    * Live Metrics: `https://custom.com:222/`
    * Profiler for .NET: `https://custom.com:333/`
    * Debugger: `https://custom.com:444/`

### Connection string with an explicit region

`InstrumentationKey=00000000-0000-0000-0000-000000000000;IngestionEndpoint=https://southcentralus.in.applicationinsights.azure.com/`

In this example, the connection string specifies the South Central US region:

* Authorization scheme defaults to "ikey"
* Instrumentation key: 00000000-0000-0000-0000-000000000000
* The regional service URIs are based on the explicit override values:
    * Ingestion: `https://southcentralus.in.applicationinsights.azure.com/`

To list available regions, run the following command in the [Azure CLI](/cli/azure/account?view=azure-cli-latest#az-account-list-locations&preserve-view=true):

`az account list-locations -o table`

## Set a connection string

All our OpenTelemetry offerings and the following SDK versions onwards support connection strings:

* .NET v2.12.0
* JavaScript v2.3.0
* NodeJS v1.5.0
* Python v1.0.0
* Java v3.1.1

You can set a connection string in code, by using an environment variable, or a configuration file.

### Environment variable

Connection string: `APPLICATIONINSIGHTS_CONNECTION_STRING`

### Code samples

| Language | Classic API | OpenTelemetry |
|-----------------|-------------|---------------|
| ASP.NET Core | [Application Insights SDK](asp-net-core.md#enable-application-insights-server-side-telemetry-no-visual-studio) | [AzMon OTel Distro](opentelemetry-configuration.md?tabs=aspnetcore#connection-string) |
| .NET Framework | [Application Insights SDK](asp-net.md#add-application-insights-manually-no-visual-studio) | [AzMon Exporter](opentelemetry-configuration.md?tabs=net#connection-string) |
| Java | [N/A](java-standalone-upgrade-from-2x.md) | [Java agent](opentelemetry-configuration.md?tabs=java#connection-string) |
| JavaScript | [JavaScript (Web) SDK Loader Script](./javascript-sdk.md?tabs=javascriptwebsdkloaderscript#add-the-javascript-code) | [N/A](application-insights-faq.yml#can-opentelemetry-be-used-for-web-browsers) |
| Node.js | [Application Insights SDK](nodejs.md#basic-usage) | [AzMon OTel Distro](opentelemetry-configuration.md?tabs=nodejs#connection-string) |
| Python | [OpenCensus Python SDK](/previous-versions/azure/azure-monitor/app/opencensus-python#tracing) | [AzMon OTel Distro](opentelemetry-configuration.md?tabs=python#connection-string) |

## Next steps

To review frequently asked questions (FAQ): 

* [Connection strings in Application Insights FAQ](application-insights-faq.yml#connection-strings)

Get started at runtime with:

* [Azure Virtual Machine (VM) and Azure Virtual Machine Scale Sets IIS-hosted apps](./azure-vm-vmss-apps.md)
* [Internet Information Server (IIS) server](./application-insights-asp-net-agent.md)
* [Web Apps feature of Azure App Service](./azure-web-apps.md)

Get started at development time with:

* [ASP.NET Core](./asp-net-core.md)
* [ASP.NET](./asp-net.md)
* [Java](./opentelemetry-enable.md?tabs=java)
* [Node.js](./nodejs.md)
* [Python](/previous-versions/azure/azure-monitor/app/opencensus-python)

