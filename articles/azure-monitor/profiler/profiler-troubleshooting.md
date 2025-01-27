---
title: Troubleshoot Application Insights Profiler for .NET
description: Walk through troubleshooting steps and information to enable and use Application Insights Profiler for .NET.
ms.topic: conceptual
ms.date: 08/19/2024
ms.reviewer: charles.weininger
---

# Troubleshoot Application Insights Profiler for .NET

This article presents troubleshooting steps and information to enable you to use Application Insights Profiler for .NET.

## Are you using the appropriate .NET Profiler endpoint?

Currently, the only regions that require endpoint modifications are [Azure Government](/azure/azure-government/compare-azure-government-global-azure#application-insights) and [Microsoft Azure operated by 21Vianet](/azure/china/resources-developer-guide).

|App setting    | US Government Cloud | China Cloud |
|---------------|---------------------|-------------|
|ApplicationInsightsProfilerEndpoint         | `https://profiler.monitor.azure.us`    | `https://profiler.monitor.azure.cn` |
|ApplicationInsightsEndpoint | `https://dc.applicationinsights.us` | `https://dc.applicationinsights.azure.cn` |

## Is your app running on the right version?

The Profiler is supported on the [.NET Framework later than 4.6.2](https://dotnet.microsoft.com/download/dotnet-framework).

If your web app is an ASP.NET Core application, it must be running on the [latest supported ASP.NET Core runtime](https://dotnet.microsoft.com/download/dotnet/8.0).

## Are you using the right Azure service plan?

Profiler for .NET isn't currently supported on free or shared app service plans. Upgrade to one of the basic plans for Profiler to start working.

> [!NOTE]
> The Azure Functions consumption plan isn't supported. See [Profile live Azure Functions app with Application Insights](./profiler-azure-functions.md).

## Are you searching for .NET Profiler data within the right time frame?

If the data you're trying to view is older than two weeks, try limiting your time filter and try again. Traces are deleted after seven days.

## Are you aware of the .NET Profiler sampling rate and overhead? 

The .NET Profiler randomly runs two minutes per hour on each virtual machine hosting applications with Profiler enabled.

[!INCLUDE [profiler-overhead](./includes/profiler-overhead.md)]

## Can you access the gateway?

Check that a firewall or proxies aren't blocking your access to [this webpage](https://gateway.azureserviceprofiler.net).

## Are you seeing timeouts or do you need to check to see if the .NET Profiler is running?

Profiling data is uploaded only when it can be attached to a request that happened while Profiler was running. The .NET Profiler collects data for two minutes each hour. You can also trigger the Profiler by [starting a profiling session](./profiler-settings.md#profile-now).

The Profiler writes trace messages and custom events to your Application Insights resource. You can use these events to see how the Profiler is running.

Search for trace messages and custom events sent by the .NET Profiler to your Application Insights resource.

1. In your Application Insights resource, select **Search** from the top menu.

   :::image type="content" source="./media/profiler-troubleshooting/search-trace-messages.png" lightbox="./media/profiler-troubleshooting/search-trace-messages.png" alt-text="Screenshot that shows selecting the Search button from the Application Insights resource.":::

1. Use the following search string to find the relevant data:

   ```
   stopprofiler OR startprofiler OR upload OR ServiceProfilerSample
   ```

   :::image type="content" source="./media/profiler-troubleshooting/search-results.png" lightbox="./media/profiler-troubleshooting/search-results.png" alt-text="Screenshot that shows the search results from aforementioned search string.":::

   The preceding search results include two examples of searches from two AI resources:

   - If the application isn't receiving requests while Profiler is running, the message explains that the upload was canceled because of no activity.

   - Profiler started and sent custom events when it detected requests that happened while Profiler was running. If the `ServiceProfilerSample` custom event is displayed, it means that a profile was captured and is available in the **Application Insights Performance** pane.

   If no records are displayed, Profiler isn't running or took too long to respond. Make sure [Profiler is enabled on your Azure service](./profiler.md).

## The .NET Profiler is on, but no traces captured

Even when the Profiler is enabled, it may not capture or upload traces, especially in these situations:

1. **No incoming requests to your application:**   
     You can manually invoke your application or create an [availability test](../app/availability.md), or a [load test](/azure/load-testing/overview-what-is-azure-load-testing). 

1. **No incoming telemetry acknowledged by Application Insights:**  
    - If there is traffic coming to your application: validate that there are incoming requests showing in Application Insights [Live Metrics](../app/live-stream.md). 
    - If the `Incoming Requests` charts are empty (no data or showing zero): [troubleshoot Application Insights](/troubleshoot/azure/azure-monitor/app-insights/telemetry/asp-net-troubleshoot-no-data). 
    - If you are hosting your .NET application on Azure App Service: [try the App Service .NET troubleshooting steps](../app/azure-web-apps-net.md#troubleshooting).

1. **Profiler setting for Sampling is turned off:**   
    If still no profiler traces are available, check the Profiler Sampling setting.   
      1. Open **Application Insights** > **Performance** blade. 
      1. Click on **Profiler**.
      1. Click on the **Triggers** button. 
      1. In the Trigger Settings, ensure the **Sampling** toggle is on.

1. **Still no traces uploaded?**  
    [Create a support request](https://ms.portal.azure.com/#blade/Microsoft_Azure_Support/HelpAndSupportBlade/overview?DMC=troubleshoot), or ask [Azure community support](/answers/products/azure?product=all). You can also submit product feedback to [Azure feedback community](https://feedback.azure.com/d365community).

## Double counting in parallel threads

When two or more parallel threads are associated with a request, the total time metric in the stack viewer might be more than the duration of the request. In that case, the total thread time is more than the actual elapsed time.

For example, one thread might be waiting on the other to be completed. The viewer tries to detect this situation and omits the uninteresting wait. In doing so, it errs on the side of displaying too much information rather than omitting what might be critical information.

When you see parallel threads in your traces, determine which threads are waiting so that you can identify the hot path for the request. Usually, the thread that quickly goes into a wait state is waiting on the other threads. Concentrate on the other threads and ignore the time in the waiting threads.

## Troubleshoot the .NET Profiler on your specific Azure service

The following sections walk you through troubleshooting steps for using Profiler on Azure App Service or Azure Cloud Services.

### Azure App Service

For the .NET Profiler to work properly, make sure:

- Your web app has [Application Insights enabled](./profiler.md) with the [right settings](./profiler.md#for-application-insights-and-app-service-in-different-subscriptions).

- The [**ApplicationInsightsProfiler3** WebJob]() is running. To check the webjob:
   1. Go to [Kudu](https://github.com/projectkudu/kudu/wiki/Accessing-the-kudu-service). In the Azure portal:
      1. In your App Service instance, select **Advanced Tools** on the left pane.
      1. Select **Go**.
   1. On the top menu, select **Tools** > **WebJobs dashboard**.
      The **WebJobs** pane opens.

      If **ApplicationInsightsProfiler3** doesn't show up, restart your App Service application.

      :::image type="content" source="./media/profiler-troubleshooting/profiler-web-job.png" lightbox="./media/profiler-troubleshooting/profiler-web-job.png" alt-text="Screenshot that shows the WebJobs pane, which displays the name, status, and last runtime of jobs.":::

   1. To view the details of the WebJob, including the log, select the **ApplicationInsightsProfiler3** link.
     The **Continuous WebJob Details** pane opens.

      :::image type="content" source="./media/profiler-troubleshooting/profiler-web-job-log.png" lightbox="./media/profiler-troubleshooting/profiler-web-job-log.png" alt-text="Screenshot that shows the Continuous WebJob Details pane.":::

If the .NET Profiler still isn't working for you, download the log and [submit an Azure support ticket](https://azure.microsoft.com/support/).

#### Check the Diagnostic Services site extension status page

If you enabled the .NET Profiler through the [Application Insights pane](profiler.md) in the portal, it's managed by the Diagnostic Services site extension. You can check the status page of this extension by going to
`https://{site-name}.scm.azurewebsites.net/DiagnosticServices`.

> [!NOTE]
> The domain of the status page link varies depending on the cloud. This domain is the same as the Kudu management site for App Service.

The status page shows the installation state of the .NET Profiler and [Snapshot Debugger](../snapshot-debugger/snapshot-debugger.md) agents. If there was an unexpected error, it appears along with steps on how to fix it.

You can use the Kudu management site for App Service to get the base URL of this status page:

1. Open your App Service application in the Azure portal.
1. Select **Advanced Tools**.
1. Select **Go**.
1. On the Kudu management site:
   1. Append `/DiagnosticServices` to the URL.
   1. Select Enter.

It ends like `https://<kudu-url>/DiagnosticServices`.

A status page appears similar to the following example.

:::image type="content" source="../app/media/diagnostic-services-site-extension/status-page.png" lightbox="../app/media/diagnostic-services-site-extension/status-page.png" alt-text="Screenshot that shows the Diagnostic Services status page.":::

> [!NOTE]
> Codeless installation of Application Insights Profiler for .NET follows the .NET Core support policy. For more information about supported runtimes, see [.NET Core support policy](https://dotnet.microsoft.com/platform/support/policy/dotnet-core).

#### Manual installation

When you configure the .NET Profiler, updates are made to the web app's settings. If necessary, you can [apply the updates manually](./profiler.md#verify-the-always-on-setting-is-enabled).

#### Too many active profiling sessions

In Azure App Service, there's a limit of only **one profiling session at a time**. This limit is enforced at the VM level across all applications and deployment slots running in an App Service Plan. 
This limit applies equally to profiling sessions started via *Diagnose and solve problems*, Kudu, and Application Insights Profiler for .NET.

If the .NET Profiler tries to start a session when another is already running, an error is logged in the Application Log and also the continuous WebJob log for `ApplicationInsightsProfiler3`.

You may see one of the following messages in the logs:

- `Microsoft.ServiceProfiler.Exceptions.TooManyETWSessionException`
- `Error: StartProfiler failed. Details: System.Runtime.InteropServices.COMException (0xE111005E): Exception from HRESULT: 0xE111005E`

The error code `0xE111005E` indicates that a profiling session couldn't start because another session is already running.

To avoid the error, move some web apps to a different App Service Plan or disable the Profiler on some of the applications. If you use deployment slots, be sure to stop any unused slots.

#### Deployment error: Directory Not Empty 'D:\\home\\site\\wwwroot\\App_Data\\jobs'

If you're redeploying your web app to a Web Apps resource with the .NET Profiler enabled, you might see the following message:

"Directory Not Empty 'D:\\home\\site\\wwwroot\\App_Data\\jobs'"

This error occurs if you run Web Deploy from scripts or from Azure Pipelines. Resolve it by adding the following deployment parameters to the Web Deploy task:

```
-skip:Directory='.*\\App_Data\\jobs\\continuous\\ApplicationInsightsProfiler.*' -skip:skipAction=Delete,objectname='dirPath',absolutepath='.*\\App_Data\\jobs\\continuous$' -skip:skipAction=Delete,objectname='dirPath',absolutepath='.*\\App_Data\\jobs$'  -skip:skipAction=Delete,objectname='dirPath',absolutepath='.*\\App_Data$'
```

These parameters delete the folder used by Application Insights Profiler for .NET and unblock the redeploy process. They don't affect the Profiler instance that's currently running.

#### Is Application Insights Profiler for .NET running?

The Profiler runs as a continuous WebJob in the web app. You can open the web app resource in the [Azure portal](https://portal.azure.com). In the **WebJobs** pane, check the status of **ApplicationInsightsProfiler**. If it isn't running, open **Logs** to get more information.

### VMs and Azure Cloud Services

To see whether the .NET Profiler is configured correctly by Azure Diagnostics:

1. Verify that the content of the Azure Diagnostics configuration deployed is what you expect.

1. Make sure Azure Diagnostics passes the proper iKey on the Profiler command line.

1. Check the Profiler log file to see whether the .NET Profiler ran but returned an error.

To check the settings that were used to configure Azure Diagnostics:

1. Sign in to the virtual machine (VM).

1. Open the log file at this location. The plug-in version might be newer on your machine.

    For VMs:
    ```
    c:\WindowsAzure\logs\Plugins\Microsoft.Azure.Diagnostics.PaaSDiagnostics\1.11.3.12\DiagnosticsPlugin.log
    ```

    For Azure Cloud Services:
    ```
    c:\logs\Plugins\Microsoft.Azure.Diagnostics.PaaSDiagnostics\1.11.3.12\DiagnosticsPlugin.log
    ```

1. In the file, search for the string `WadCfg` to find the settings that were passed to the VM to configure Azure Diagnostics.

1. Check to see whether the iKey used by the .NET Profiler sink is correct.

1. Check the command line that starts Profiler. The command line arguments are in the following file (the drive could be `c:` or `d:` and the directory might be hidden):

    For VMs:
    ```
    C:\ProgramData\ApplicationInsightsProfiler\config.json
    ```

    For Azure Cloud Services:
    ```
    D:\ProgramData\ApplicationInsightsProfiler\config.json
    ```

1. Make sure that the iKey on the Profiler command line is correct.

1. By using the path found in the preceding *config.json* file, check the Profiler log file, called `BootstrapN.log`. It displays:

   - The debug information that indicates the settings that Profiler is using.
   - Status and error messages from Profiler.

    You can find the file:

    For VMs:
    ```
    C:\WindowsAzure\Logs\Plugins\Microsoft.Azure.Diagnostics.IaaSDiagnostics\1.17.0.6\ApplicationInsightsProfiler
    ```

    For Azure Cloud Services:
    ```
    C:\Logs\Plugins\Microsoft.Azure.Diagnostics.IaaSDiagnostics\1.17.0.6\ApplicationInsightsProfiler
    ```

1. If the .NET Profiler is running while your application is receiving requests, the following message appears: "Activity detected from iKey."

1. When the trace is being uploaded, the following message appears: "Start to upload trace."

### Edit network proxy or firewall rules

If your application connects to the internet via a proxy or a firewall, you might need to update the rules to communicate with the .NET Profiler.

The IPs used by Application Insights Profiler for .NET are included in the Azure Monitor service tag. For more information, see [Service tags documentation](/azure/virtual-network/service-tags-overview).

## Support

If you still need help, submit a support ticket in the Azure portal. Include the correlation ID from the error message.
