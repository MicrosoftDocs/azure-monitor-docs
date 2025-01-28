---
title: Enable Application Insights Profiler for .NET for Azure Cloud Services
description: Profile Azure Cloud Services in real time with Application Insights Profiler for .NET.
ms.topic: how-to
ms.custom: engagement
ms.date: 08/16/2024
---

# Enable the .NET Profiler for Azure Cloud Services

You can receive performance traces for your instance of [Azure Cloud Services](/azure/cloud-services-extended-support/overview) by enabling the Application Insights Profiler for .NET. The Profiler is installed on your instance of Azure Cloud Services via the [Azure Diagnostics extension](../agents/diagnostics-extension-overview.md).

In this guide, you learn how to:
> [!div class="checklist"]
> - Enable your instance of Azure Cloud Services to send diagnostics data to Application Insights.
> - Configure the Azure Diagnostics extension within your solution to install the .NET Profiler.
> - Deploy your service and generate traffic to view Profiler traces.

## Prerequisites

- Make sure you've [set up diagnostics for your instance of Azure Cloud Services](/visualstudio/azure/vs-azure-tools-diagnostics-for-cloud-services-and-virtual-machines).
- Use [.NET Framework 4.6.1](/dotnet/framework/migration-guide/how-to-determine-which-versions-are-installed) or newer.
  - If you're using [OS Family 4](/azure/cloud-services/cloud-services-guestos-update-matrix#family-4-releases), install .NET Framework 4.6.1 or newer with a [startup task](/azure/cloud-services/cloud-services-dotnet-install-dotnet).
  - [OS Family 5](/azure/cloud-services/cloud-services-guestos-update-matrix#family-5-releases) includes a compatible version of .NET Framework by default.

## Track requests with Application Insights

When you publish your instance of Azure Cloud Services to the Azure portal, add the [Application Insights SDK to Azure Cloud Services](../app/azure-web-apps-net-core.md).

:::image type="content" source="./media/profiler-cloudservice/enable-app-insights.png" alt-text="Screenshot that shows the checkbox for sending information to Application Insights.":::

After you've added the SDK and published your instance of Azure Cloud Services to the Azure portal, track requests by using Application Insights:

- **For ASP.NET web roles**: Application Insights tracks the requests automatically.
- **For worker roles**: You need to [add code manually to your application to track requests](profiler-trackrequests.md).

## Configure the Azure Diagnostics extension

Locate the Azure Diagnostics *diagnostics.wadcfgx* file for your application role.

:::image type="content" source="./media/profiler-cloudservice/diagnostics-file.png" alt-text="Screenshot that shows the diagnostics file in the Azure Cloud Services solution explorer.":::

Add the following `SinksConfig` section as a child element of `WadCfg`:

```xml
<WadCfg>
  <DiagnosticMonitorConfiguration>...</DiagnosticMonitorConfiguration>
  <SinksConfig>
    <Sink name="MyApplicationInsightsProfiler">
      <!-- Replace with your own Application Insights instrumentation key. -->
      <ApplicationInsightsProfiler>00000000-0000-0000-0000-000000000000</ApplicationInsightsProfiler>
    </Sink>
  </SinksConfig>
</WadCfg>
```

> [!NOTE]
> The instrumentation keys that are used by the application and the `ApplicationInsightsProfiler` sink must match.

Deploy your service with the new Diagnostics configuration. Application Insights Profiler for .NET is now configured to run on your instance of Azure Cloud Services.

## Next steps

> [!div class="nextstepaction"]
> [Generate load and view the .NET Profiler traces](./profiler-data.md)

[!INCLUDE [azure-monitor-log-analytics-rebrand](~/reusable-content/ce-skilling/azure/includes/azure-monitor-instrumentation-key-deprecation.md)]
