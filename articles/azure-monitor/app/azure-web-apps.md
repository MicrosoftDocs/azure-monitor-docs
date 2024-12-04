---
title: Monitor Azure App Service performance | Microsoft Docs
description: Application performance monitoring for Azure App Service. Chart load and response time, dependency information, and set alerts on performance.
ms.topic: conceptual
ms.date: 08/11/2023
ms.custom:
---

# Application monitoring for Azure App Service overview

It's now easier than ever to enable monitoring on your web applications based on ASP.NET, ASP.NET Core, Java, and Node.js running on [Azure App Service](/azure/app-service/). Previously, you needed to manually instrument your app, but the latest extension/agent is now built into the App Service image by default.

## Enable Application Insights

There are two ways to enable monitoring for applications hosted on App Service:

- **Autoinstrumentation application monitoring** (ApplicationInsightsAgent).

  This method is the easiest to enable, and no code change or advanced configurations are required. It's often referred to as "runtime" monitoring. For App Service, we recommend that at a minimum you enable this level of monitoring. Based on your specific scenario, you can evaluate whether more advanced monitoring through manual instrumentation is needed.

  When you enable auto-instrumentation it enables Application Insights with a default setting (it includes sampling as well). Even if you set in Azure AppInsights: Sampling: **All Data 100%** this setting will be ignored.

  For a complete list of supported autoinstrumentation scenarios, see [Supported environments, languages, and resource providers](codeless-overview.md#supported-environments-languages-and-resource-providers).

  The following platforms are supported for autoinstrumentation monitoring:

  - [.NET Core](./azure-web-apps-net-core.md)
  - [.NET](./azure-web-apps-net.md)
  - [Java](./azure-web-apps-java.md)
  - [Node.js](./azure-web-apps-nodejs.md)
  - [Python](./azure-web-apps-python.md)

* **Manually instrumenting the application through code** by installing the Application Insights SDK.

  This approach is much more customizable, but it requires the following approaches: SDK for [.NET Core](./asp-net-core.md), [.NET](./asp-net.md), [Node.js](./nodejs.md), [Python](./opentelemetry-enable.md?tabs=python), and a standalone agent for [Java](./opentelemetry-enable.md?tabs=java). This method also means you must manage the updates to the latest version of the packages yourself.
  
  If you need to make custom API calls to track events/dependencies not captured by default with autoinstrumentation monitoring, you need to use this method. To learn more, see [Application Insights API for custom events and metrics](./api-custom-events-metrics.md).

If both autoinstrumentation monitoring and manual SDK-based instrumentation are detected, in .NET and NodeJS only the manual instrumentation settings are honored, while in Java only the autoinstrumentation are emitting the telemetry. In Python, you should only use autoinstrumentation if you aren't using manual instrumentation. This practice is to prevent duplicate data from being sent.

> [!NOTE]
> Snapshot Debugger and Profiler are only available in .NET and .NET Core.

## Release notes

This section contains the release notes for Azure Web Apps based on the latest release for runtime instrumentations with Application Insights.

To find which version of the extension you're currently using, go to `https://<yoursitename>.scm.azurewebsites.net/ApplicationInsights`.

### Latest Version (default) - Linux

#### [ASP.NET Core](#tab/asp.net)
insert ASP.NET Core agent version information and link to releases here

#### [.NET](#tab/.net)
insert .NET agent version information and link to releases here

#### [Java](#tab/java)
insert Java agent version information and link to releases here

#### [Node.js](#tab/nodejs)
Released version 3.x.x of the OpenTelemetry based agent.
Released version 2.x.x of the Application Insights agent.
[Node.js SDK releases](https://github.com/microsoft/ApplicationInsights-node.js/releases)

#### [Python (Preview)](#tab/python)
insert Python agent version information and link to releases here

### Latest Version (default) - Windows

#### [ASP.NET Core](#tab/asp.net)
insert ASAP.NET Core agent version information and link to releases here

#### [.NET](#tab/.net)
insert .NET agent version information and link to releases here

#### [Java](#tab/java)
insert Java agent version information and link to releases here

#### [Node.js](#tab/nodejs)
Released version 3.x.x of the OpenTelemetry based agent.
Released version 2.x.x of the Application Insights agent.
[Node.js SDK releases](https://github.com/microsoft/ApplicationInsights-node.js/releases)

#### [Python (Preview)](#tab/python)
insert Python agent version information and link to releases here

## Frequently asked questions

This section provides answers to common questions.

### What does Application Insights modify in my project?

The details depend on the type of project. For a web application:
          
* Adds these files to your project:
  * ApplicationInsights.config
  * ai.js
* Installs these NuGet packages:
  * Application Insights API: The core API
  * Application Insights API for Web Applications: Used to send telemetry from the server
  * Application Insights API for JavaScript Applications: Used to send telemetry from the client
* The packages include these assemblies:
  * Microsoft.ApplicationInsights
  * Microsoft.ApplicationInsights.Platform
* Inserts items into:
  * Web.config
  * packages.config
* (For new projects only, you [add Application Insights to an existing project manually](./app-insights-overview.md).) Inserts snippets into the client and server code to initialize them with the Application Insights resource ID. For example, in an MVC app, code is inserted into the main page *Views/Shared/\_Layout.cshtml*.
          

## Next steps

Learn how to enable autoinstrumentation application monitoring for your [.NET Core](./azure-web-apps-net-core.md), [.NET](./azure-web-apps-net.md), [Java](./azure-web-apps-java.md), [Nodejs](./azure-web-apps-nodejs.md), or [Python](./azure-web-apps-python.md) application running on App Service.
