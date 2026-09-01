---
title: Troubleshoot the .NET Profiler
description: Diagnose and fix Application Insights Profiler for .NET issues. Learn how to check endpoints, .NET versions, service plans, and profiler status.
ms.topic: troubleshooting-general
ms.date: 03/06/2026
ms.reviewer: charles.weininger
ai-usage: ai-assisted
#customer intent: As an application developer using Application Insights Profiler for .NET, I need to diagnose any problems that might occur in using Profiler.
---

# Troubleshoot Application Insights Profiler for .NET

Application Insights Profiler for .NET captures performance traces that identify the slow code paths in your running application. When the Profiler doesn't start, traces don't show up, requests time out, or a configuration or hosting problem gets in the way, you lose that visibility into where your app spends its time.

This article walks you through the checks that get the Profiler working again, including verifying endpoints, supported .NET runtimes, service plans, network connectivity, and service-specific diagnostics.

## Are you using the appropriate .NET Profiler endpoint?

Currently, only [Azure Government](/azure/azure-government/compare-azure-government-global-azure#application-insights) and [Microsoft Azure operated by 21Vianet](/azure/china/resources-developer-guide#application-insights) require endpoint modifications.

|App setting    | US Government Cloud | China Cloud |
|---------------|---------------------|-------------|
|`ApplicationInsightsProfilerEndpoint`         | `https://profiler.monitor.azure.us`    | `https://profiler.monitor.azure.cn` |
|`ApplicationInsightsEndpoint` | `https://dc.applicationinsights.us` | `https://dc.applicationinsights.azure.cn` |

<a name="is-your-app-running-on-the-right-version"></a>
## Is your app running on a supported .NET version?

The Profiler supports [.NET Framework 4.6.2 or later](https://dotnet.microsoft.com/download/dotnet-framework).

If your web app is an ASP.NET Core application, it must run on the [latest supported ASP.NET Core runtime](https://dotnet.microsoft.com/download/dotnet).

<a name="are-you-using-the-right-azure-service-plan"></a>
## Are you using a supported Azure service plan?

Profiler for .NET isn't currently supported on free or shared App Service plans. Upgrade to one of the basic plans for Profiler to start working.

> [!NOTE]
> The Azure Functions consumption plan isn't supported. See [Enable the .NET Profiler for Azure Functions apps](./profiler-azure-functions.md).

## Are you searching for .NET Profiler data within the right time frame?

If the data you're trying to view is older than 15 days, try limiting your time filter and try again. Traces are deleted after 15 days.

## Are you aware of the .NET Profiler sampling rate and overhead?

The .NET Profiler randomly runs two minutes per hour on each virtual machine (VM) hosting applications with Profiler enabled.

[!INCLUDE [profiler-overhead](./includes/profiler-overhead.md)]

<a name="can-you-access-the-gateway"></a>
## Can you access the .NET Profiler gateway?

Check that a firewall or proxies aren't blocking access to the Application Insights Profiler gateway at `https://gateway.azureserviceprofiler.net`.

## Are you seeing timeouts or do you need to check if the .NET Profiler is running?

The Profiler uploads profiling data only when it can attach the data to a request that happens while the Profiler is running. The .NET Profiler collects data for two minutes each hour. You can also trigger the Profiler by [starting a profiling session](./profiler-settings.md#profile-now).

The Profiler writes trace messages and custom events to your Application Insights resource. You can use these events to see how the Profiler is running.

Search for trace messages and custom events that the .NET Profiler sends to your Application Insights resource.

1. In your Application Insights resource, select **Search** from the top menu.

   :::image type="content" source="./media/profiler-troubleshooting/search-trace-messages.png" lightbox="./media/profiler-troubleshooting/search-trace-messages.png" alt-text="Screenshot that shows selecting the Search button from the Application Insights resource.":::

1. Use the following search string to find the relevant data:

   ```text
   stopprofiler OR startprofiler OR upload OR ServiceProfilerSample
   ```

   :::image type="content" source="./media/profiler-troubleshooting/search-results.png" lightbox="./media/profiler-troubleshooting/search-results.png" alt-text="Screenshot that shows the search results from aforementioned search string.":::

   The preceding search results include two examples of searches from two Application Insights resources:

   - If the application isn't receiving requests while the Profiler is running, the message explains that the Profiler canceled the upload because of no activity.

   - The Profiler starts and sends custom events when it detects requests that happen while the Profiler is running. If the `ServiceProfilerSample` custom event appears, it means that the Profiler captured a profile, which is available on the Application Insights **Performance** page.

   If no records appear, the Profiler isn't running or took too long to respond. Make sure [Profiler is enabled on your Azure service](./profiler.md).

## The .NET Profiler is on, but it didn't capture any traces

Even if you enable the Profiler, it might not capture or upload traces. This behavior is common in the following situations:

1. **No incoming requests to your application:**

   Manually invoke your application, or create an [availability test](../app/availability.md) or a [load test](/azure/load-testing/overview-what-is-azure-load-testing).

1. **No incoming telemetry acknowledged by Application Insights:**

   - If traffic is coming to your application: validate that Application Insights [Live Metrics](../app/live-stream.md) shows incoming requests.
   - If the `Incoming Requests` charts are empty (no data or showing zero): [troubleshoot Application Insights](/troubleshoot/azure/azure-monitor/app-insights/telemetry/asp-net-troubleshoot-no-data).
   - If you host your .NET application on Azure App Service, see [Troubleshoot Application Insights integration with Azure App Service](/troubleshoot/azure/azure-monitor/app-insights/telemetry/troubleshoot-app-service-issues).

1. **Profiler setting for Sampling is turned off:**

   If no profiler traces are available, check the Profiler Sampling setting.

   1. Open **Application Insights** > **Performance**.
   1. Select **Profiler**.
   1. Select the **Triggers** button.
   1. In the **Trigger Settings**, make sure **Sampling** is on.

1. **Still no traces uploaded?**

   [Create a support request](https://ms.portal.azure.com/#blade/Microsoft_Azure_Support/HelpAndSupportBlade/overview?DMC=troubleshoot), ask [Azure community support](/answers/products/azure?product=all), or submit product feedback to the [Azure feedback community](https://feedback.azure.com/d365community).

## Double counting in parallel threads

When two or more parallel threads associate with a request, the stack viewer's total time metric might exceed the request's duration. In this case, the total thread time surpasses the actual elapsed time.

For example, one thread might wait for the other thread to finish. The viewer tries to detect this situation and omits the uninteresting wait. In doing so, it errs on the side of displaying too much information rather than omitting what might be critical information.

When you see parallel threads in your traces, determine which threads are waiting so that you can identify the hot path for the request. Usually, the thread that quickly goes into a wait state waits on the other threads. Concentrate on the other threads and ignore the time in the waiting threads.

## Azure App Service

For the .NET Profiler to work properly, ensure that you:

- Enable [Application Insights](./profiler.md) for your web app with the [right settings](./profiler.md#for-application-insights-and-app-service-in-different-subscriptions).

- Run the [**ApplicationInsightsProfiler3** WebJob](./profiler.md#enable-application-insights-and-the-net-profiler). To check the WebJob:

  1. Go to [Kudu](https://github.com/projectkudu/kudu/wiki/Accessing-the-kudu-service). In the Azure portal:

     1. In your App Service instance, select **Advanced Tools** in the left pane.

     1. Select **Go**.

  1. On the top menu, select **Tools** > **WebJobs dashboard**. The **WebJobs** pane opens.

     If **ApplicationInsightsProfiler3** doesn't show up, restart your App Service application.

     :::image type="content" source="./media/profiler-troubleshooting/profiler-web-job.png" lightbox="./media/profiler-troubleshooting/profiler-web-job.png" alt-text="Screenshot that shows the WebJobs pane with the name, status, and last runtime of jobs.":::

  1. To view the details of the WebJob, including the log, select the **ApplicationInsightsProfiler3** link. The **Continuous WebJob Details** pane opens.

     :::image type="content" source="./media/profiler-troubleshooting/profiler-web-job-log.png" lightbox="./media/profiler-troubleshooting/profiler-web-job-log.png" alt-text="Screenshot that shows the Continuous WebJob Details pane.":::

If the .NET Profiler still isn't working, download the log and [submit an Azure support ticket](https://azure.microsoft.com/support/).

## Check the Diagnostic Services site extension status page

If you enable the .NET Profiler through the [Application Insights page](profiler.md) in the Azure portal, the Diagnostic Services site extension manages it. The status page for this extension shows the installation state of the .NET Profiler and [Snapshot Debugger](../snapshot-debugger/snapshot-debugger.md) agents. If there's an unexpected error, it appears along with steps to fix it.

To open the status page, use the Kudu management site for App Service to get its base URL:

1. Open your App Service application in the Azure portal.
1. Select **Advanced Tools**.
1. Select **Go**.
1. On the Kudu management site, append `/DiagnosticServices` to the URL and select **Enter**.

The status page URL ends like `https://<kudu-url>/DiagnosticServices`.

> [!NOTE]
> The domain of the status page link varies depending on the cloud. This domain is the same as the Kudu management site for App Service.

A status page appears similar to the following example.

:::image type="content" source="../app/media/diagnostic-services-site-extension/status-page.png" lightbox="../app/media/diagnostic-services-site-extension/status-page.png" alt-text="Screenshot that shows the Diagnostic Services status page.":::

> [!NOTE]
> Codeless installation of Application Insights Profiler for .NET follows the .NET Core support policy. For more information about supported runtimes, see [.NET Core support policy](https://dotnet.microsoft.com/platform/support/policy/dotnet-core).

<a name="manual-installation"></a>
## Manually install the .NET Profiler on Azure App Service

When you configure the .NET Profiler, the process updates the web app's settings. If necessary, you can [apply the updates manually](./profiler.md#verify-the-always-on-setting-is-enabled).

## Too many active profiling sessions

In Azure App Service, you can have only **one profiling session at a time per VM**. Azure App Service enforces this limit at the VM level across all applications and deployment slots running in an App Service plan.
This limit applies equally to profiling sessions you start through *Diagnose and solve problems*, Kudu, and Application Insights Profiler for .NET.

For a single app scaled out to multiple instances, each instance runs on a separate VM and can run its own profiling session independently. The contention occurs only when multiple apps or deployment slots on the same App Service plan share the same VM.

If the .NET Profiler tries to start a session when another session is already running on the same VM, it logs an error in the Application Log and the continuous WebJob log for `ApplicationInsightsProfiler3`.

You might see one of the following messages in the logs:

- `Microsoft.ServiceProfiler.Exceptions.TooManyETWSessionException`
- `Error: StartProfiler failed. Details: System.Runtime.InteropServices.COMException (0xE111005E): Exception from HRESULT: 0xE111005E`

The error code `0xE111005E` indicates that a profiling session couldn't start because another session is already running.

To avoid the error and reduce noise in your deployment logs:

- Move some web apps to a different App Service plan so they don't share VMs.
- Disable the Profiler on applications that don't need profiling.
- Stop any unused deployment slots. Each running slot has the Profiler active and competes for the profiling session on its VM.
- During deployments, consider temporarily disabling the Profiler on staging slots to prevent errors caused by slot swaps triggering concurrent sessions.

## Deployment error: Directory Not Empty 'D:\\home\\site\\wwwroot\\App_Data\\jobs'

If you redeploy your web app to a Web Apps resource with the .NET Profiler enabled, you might see the following message:

`Directory Not Empty 'D:\home\site\wwwroot\App_Data\jobs'`

This error occurs if you run Web Deploy from scripts or from Azure Pipelines. Resolve it by adding the following deployment parameters to the Web Deploy task:

```cmd
-skip:Directory='.*\\App_Data\\jobs\\continuous\\ApplicationInsightsProfiler.*' -skip:skipAction=Delete,objectname='dirPath',absolutepath='.*\\App_Data\\jobs\\continuous$' -skip:skipAction=Delete,objectname='dirPath',absolutepath='.*\\App_Data\\jobs$'  -skip:skipAction=Delete,objectname='dirPath',absolutepath='.*\\App_Data$'
```

These parameters prevent Web Deploy from deleting the directories that Application Insights Profiler for .NET uses and unblock the redeploy process. They don't affect the Profiler instance that's currently running.

The command adds four skip rules so that Web Deploy leaves the running Profiler WebJob in place:

- Skip the `App_Data\jobs\continuous\ApplicationInsightsProfiler*` directory.
- Skip deletion of the `App_Data\jobs\continuous` directory.
- Skip deletion of the `App_Data\jobs` directory.
- Skip deletion of the `App_Data` directory.

## Is Application Insights Profiler for .NET running?

The Profiler runs as a continuous WebJob named **ApplicationInsightsProfiler3** in the web app. To check its status and view its logs, see the [Azure App Service](#azure-app-service) section.

<a name="virtual-machines"></a>
## Troubleshoot the .NET Profiler on Azure virtual machines

To check whether Azure Diagnostics configures the .NET Profiler correctly:

1. Verify that the deployed Azure Diagnostics configuration matches your expectations.
1. Ensure Azure Diagnostics passes the correct connection string on the Profiler command line.
1. Review the Profiler log file to see whether the .NET Profiler ran but returned an error.

To check the settings that configure Azure Diagnostics:

1. Sign in to the virtual machine.

1. Open the log file at this location. The plug-in version might be newer on your machine.

   ```cmd
   c:\WindowsAzure\logs\Plugins\Microsoft.Azure.Diagnostics.PaaSDiagnostics\1.11.3.12\DiagnosticsPlugin.log
   ```

1. Search the file for the string `WadCfg` to find the settings that Azure Diagnostics passes to the virtual machine to configure Azure Diagnostics.

1. Verify that the connection string that the .NET Profiler sink uses is correct.

1. Check the command line that starts Profiler. The command line arguments are in the following file (the drive could be `c:` or `d:` and the directory might be hidden):

   ```cmd
   C:\ProgramData\ApplicationInsightsProfiler\config.json
   ```

1. Ensure that the connection string on the Profiler command line is correct.

1. By using the path in the preceding `config.json` file, check the Profiler log file, called `BootstrapN.log`. It shows:

   - The debug information that indicates the settings that Profiler uses.
   - Status and error messages from Profiler.

   Find the file:

   ```cmd
   C:\WindowsAzure\Logs\Plugins\Microsoft.Azure.Diagnostics.IaaSDiagnostics\1.17.0.6\ApplicationInsightsProfiler
   ```

1. If the .NET Profiler is running while your application is receiving requests, it logs the following message to confirm it detected activity for the resource that your connection string identifies. The log text uses the legacy `iKey` label: `Activity detected from iKey.`

1. When Profiler uploads the trace, the following message appears: `Start to upload trace.`

## Edit network proxy or firewall rules

If your application connects to the internet by using a proxy or a firewall, you might need to update the rules to communicate with the .NET Profiler.

The Azure Monitor service tag includes the IP addresses that Application Insights Profiler for .NET uses. For more information, see [Azure service tags overview](/azure/virtual-network/service-tags-overview).

[!INCLUDE [bring-your-own-storage-troubleshooting](./includes/bring-your-own-storage-troubleshooting.md)]

<a name="support"></a>
## Get support for Application Insights Profiler for .NET

If you still need help with Application Insights Profiler for .NET, submit a support ticket by selecting the question mark icon in the Azure portal. Include the correlation ID from the error message.
