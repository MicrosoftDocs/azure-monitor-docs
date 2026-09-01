---
title: Troubleshoot Application Insights Snapshot Debugger
description: Troubleshoot Application Insights Snapshot Debugger to resolve enablement issues and view snapshots for exceptions. Follow these steps to fix common problems.
ms.reviewer: charles.weininger
reviewer: cweining
ms.topic: troubleshooting-general
ms.date: 03/12/2026
ms.custom: devdivchpfy22, devx-track-dotnet
#customer intent: As an application developer using Azure App Service applications, I need to troubleshoot Snapshot Debugger issues so that I can successfully view snapshots.
---

# <a id="troubleshooting"></a>Troubleshoot problems enabling Application Insights Snapshot Debugger or viewing snapshots

If you enabled Application Insights Snapshot Debugger for your application, but aren't seeing snapshots for exceptions, use these instructions to troubleshoot.

Snapshot generation fails for different reasons. Start by running the Snapshot Health Check to identify some common causes.

## <a id="unsupported-scenarios"></a>Unsupported Snapshot Collector scenarios

Scenarios where Snapshot Collector isn't supported:

| Scenario | Side Effects | Recommendation |
|----------|--------------|----------------|
| When you use the Snapshot Collector SDK in your application directly (`.csproj`) and enable the advanced option *Interop*. | You lose the local Application Insights SDK, including Snapshot Collector telemetry. Therefore, no snapshots are available. <br/>Your application could crash at startup with `System.ArgumentException: telemetryProcessorType does not implement ITelemetryProcessor`.<br/>For more information about the Application Insights feature *Interop*, see [Troubleshoot Application Insights integration](/troubleshoot/azure/azure-monitor/app-insights/telemetry/troubleshoot-app-service-issues). | If you're using the advanced option *Interop*, enable codeless Snapshot Collector injection through the Azure portal. |

## Make sure you're using the appropriate Snapshot Debugger endpoint

Currently, the only regions that require endpoint modifications are [Azure Government](/azure/azure-government/compare-azure-government-global-azure#application-insights) and [Microsoft Azure operated by 21Vianet](/azure/china/resources-developer-guide).

For App Service and applications that use the Application Insights SDK, update the connection string by using the supported overrides for Snapshot Debugger:

| Connection String Property | US Government Cloud                 | China Cloud                         |
|----------------------------|-------------------------------------|-------------------------------------|
| SnapshotEndpoint           | `https://snapshot.monitor.azure.us` | `https://snapshot.monitor.azure.cn` |

For more information, see [Connection string with explicit endpoint overrides](../app/connection-strings.md?tabs=net#connection-string-with-explicit-endpoint-overrides).

For Function App, update the *host.json* by using the supported overrides:

| Property      | US Government Cloud                 | China Cloud                         |
|---------------|-------------------------------------|-------------------------------------|
| AgentEndpoint | `https://snapshot.monitor.azure.us` | `https://snapshot.monitor.azure.cn` |

Example of the *host.json* updated with the US Government Cloud agent endpoint:

```json
{
    "version": "2.0",
    "logging": {
        "applicationInsights": {
            "samplingExcludedTypes": "Request",
            "samplingSettings": {
                "isEnabled": true
            },
            "snapshotConfiguration": {
                "isEnabled": true,
                "agentEndpoint": "https://snapshot.monitor.azure.us"
            }
        }
    }
}
```

## Use the Snapshot Health Check

Several common problems result in the **Open Debug Snapshot** button not appearing. For example:

- Using an outdated Snapshot Collector.
- Reaching the daily upload limit.
- The snapshot takes a long time to upload.

Access the Snapshot Health Check to troubleshoot common problems through a link in the **Exception** pane of the end-to-end trace view.

:::image type="content" source="./media/snapshot-debugger/enter-snapshot-health-check.png" alt-text="Screenshot showing how to enter Snapshot Health Check.":::

The interactive, chat-like interface looks for common problems and guides you to fix them.

:::image type="content" source="./media/snapshot-debugger/health-check.png" alt-text="Screenshot showing the interactive Health Check window listing the problems and suggestions how to fix them.":::

If that approach doesn't solve the problem, refer to the following manual troubleshooting steps.

## <a id="SSL"></a>Check TLS/SSL client settings (ASP.NET)

If you have an ASP.NET application hosted in Azure App Service or in IIS on a virtual machine, your application could fail to connect to the Snapshot Debugger service due to a missing TLS security protocol.

[The Snapshot Debugger endpoint requires TLS version 1.2](snapshot-debugger-upgrade.md?toc=/azure/azure-monitor/toc.json). The set of security protocols is one of the quirks that the `httpRuntime targetFramework` value in the `system.web` section of `web.config` enables.

If the `httpRuntime targetFramework` is 4.5.2 or lower, then TLS 1.2 isn't included by default.

> [!NOTE]
> The `httpRuntime targetFramework` value is independent of the target framework used when building your application.

To check the setting, open your `web.config` file and find the `system.web` section. Ensure that the `targetFramework` for `httpRuntime` is set to 4.6 or higher.

```xml
<system.web>
    ...
    <httpRuntime targetFramework="4.7.2" />
    ...
</system.web>
```

> [!NOTE]
> Modifying the `httpRuntime targetFramework` value changes the runtime quirks that apply to your application and can cause other, subtle behavior changes. Test your application thoroughly after making this change. For compatibility changes, see [Retargeting changes](/dotnet/framework/migration-guide/application-compatibility#retargeting-changes).

> [!NOTE]
> If the `targetFramework` is 4.7 or higher, Windows determines the available protocols. In Azure App Service, TLS 1.2 is available. However, if you're using your own virtual machine, you might need to enable TLS 1.2 in the operating system.

## Snapshot Debugger overhead scenarios

The Snapshot Debugger is designed for use in production environments. The default settings include rate limits to minimize the impact on your applications.

You might experience small CPU, memory, and I/O overhead associated with the Snapshot Debugger in the following scenarios.

**When your application throws an exception:**

- Creating a signature for the problem type and deciding whether to create a snapshot adds a small CPU and memory overhead.

- If deoptimization is enabled, re-JITing the method that threw the exception adds overhead. This overhead occurs the next time that method runs. Depending on the size of the method, it could be between 1 ms and 100 ms of CPU time.

**If the exception handler decides to create a snapshot:**

- Creating the process snapshot takes about half a second (P50 = 0.3 s, P90 = 1.2 s, P95 = 1.9 s) and pauses the thread that threw the exception during that time. Other threads aren't blocked.

- Converting the process snapshot to a minidump and uploading it to Application Insights takes several minutes.

  - Convert: P50 = 63 s, P90 = 187 s, P95 = 275 s.
  - Upload: P50 = 31 s, P90 = 75 s, P95 = 98 s.
    
  Snapshot Uploader, which runs in a separate process, performs this conversion. The Snapshot Uploader process runs at below normal CPU priority and uses low priority I/O.
    
  Snapshot Uploader first writes the minidump to disk. The disk space is roughly the same as the working set of the original process. Writing the minidump can cause page faults as it reads memory.
    
  Snapshot Uploader compresses the minidump during upload, which consumes both CPU and memory. The CPU, memory, and disk overhead are proportional to the size of the process snapshot. Snapshot Uploader processes snapshots serially.

**When your application calls `TrackException`:**

The Snapshot Debugger checks whether the exception is new or whether a snapshot was created for it. This check adds a small CPU overhead.

## <a id="preview-versions-of-net-core"></a>Enable Snapshot Debugger for preview versions of .NET Core

If you're using a preview version of .NET Core or your application references Application Insights SDK, directly or indirectly through a dependent assembly, follow the instructions for [Enable Snapshot Debugger for other environments](snapshot-debugger-vm.md?toc=/azure/azure-monitor/toc.json).

## Check the Diagnostic Services site extension status page

If you enabled Snapshot Debugger through the [Application Insights pane](snapshot-debugger-app-service.md?toc=/azure/azure-monitor/toc.json) in the Azure portal, the Diagnostic Services site extension enabled it.

> [!NOTE]
> Codeless installation of Application Insights Snapshot Debugger follows the .NET Core support policy.
> For more information about supported runtimes, see [.NET Core Support Policy](https://dotnet.microsoft.com/platform/support/policy/dotnet-core).

Check the status page of this extension at the following URL:
`https://<kudu-url>/DiagnosticServices`.

> [!NOTE]
> The domain of the status page link varies depending on the cloud.

This domain is the same as the Kudu management site for App Service. The status page shows the installation state of the [.NET Profiler](./../profiler/profiler.md) and Snapshot Collector agents. If an unexpected error occurs, the page shows how to fix it.

Use the Kudu management site for App Service to get the base URL of this status page:

1. In the Azure portal, open your App Service application.
1. In the left menu, select **Development Tools** > **Advanced Tools**.
1. Select **Go**.
1. When you're on the Kudu management site, in the URL, append `/DiagnosticServices` and press **Enter**. It ends like this: `https://<kudu-url>/DiagnosticServices`

## Upgrade to the latest version of the NuGet package

Based on how you enabled Snapshot Debugger, see the following options:

- If you enabled Snapshot Debugger through the [Application Insights pane in the Azure portal](snapshot-debugger-app-service.md?toc=/azure/azure-monitor/toc.json), your application already runs the latest NuGet package.

- If you enabled Snapshot Debugger by including the [Microsoft.ApplicationInsights.SnapshotCollector](https://www.nuget.org/packages/Microsoft.ApplicationInsights.SnapshotCollector) NuGet package, use Visual Studio's NuGet Package Manager to ensure you're using the latest version of `Microsoft.ApplicationInsights.SnapshotCollector`.

For the latest updates and bug fixes, see [the release notes](https://github.com/microsoft/ApplicationInsights-SnapshotCollector/blob/main/CHANGELOG.md).

## Check the uploader logs

After a snapshot is created, a separate uploader process creates a minidump file (*.dmp*) on disk and uploads it, along with any associated PDBs, to Application Insights Snapshot Debugger storage. After the uploader uploads the minidump successfully, it deletes the minidump from disk. The uploader process keeps its log files on disk. In an App Service environment, you can find these logs in `D:\Home\LogFiles`. Use the Kudu management site for App Service to find these log files.

1. In the Azure portal, open your App Service application.
1. In the left menu, select **Development Tools** > **Advanced Tools**.
1. Select **Go**.
1. In **Debug console**, select **CMD**.
1. Select **LogFiles**.

You should see at least one file with a name that begins with `Uploader_` or `SnapshotUploader_` and a `.log` extension. Select the appropriate icon to download any log files or open them in a browser.

The file name includes a unique suffix that identifies the App Service instance. If more than one machine hosts your App Service instance, each machine has separate log files. When the uploader detects a new minidump file, it records the file in the log. Here's an example of a successful snapshot and upload:

```
SnapshotUploader.exe Information: 0 : Received Fork request ID <request-ID> from process <ID> (Low pri)
    DateTime=2018-03-09T01:42:41.8571711Z
SnapshotUploader.exe Information: 0 : Creating minidump from Fork request ID <request-ID> from process 6368 (Low pri)
    DateTime=2018-03-09T01:42:41.8571711Z
SnapshotUploader.exe Information: 0 : Dump placeholder file created: <request-ID>.dm_
    DateTime=2018-03-09T01:42:41.8728496Z
SnapshotUploader.exe Information: 0 : Dump available <request-ID>.dmp
    DateTime=2018-03-09T01:42:45.7525022Z
SnapshotUploader.exe Information: 0 : Successfully wrote minidump to D:\local\Temp\Dumps\<connection-string>\<request-ID>.dmp
    DateTime=2018-03-09T01:42:45.7681360Z
SnapshotUploader.exe Information: 0 : Uploading D:\local\Temp\Dumps\<connection-string>\<request-ID>.dmp, 214.42 MB (uncompressed)
    DateTime=2018-03-09T01:42:45.7681360Z
SnapshotUploader.exe Information: 0 : Upload successful. Compressed size 86.56 MB
    DateTime=2018-03-09T01:42:59.6184651Z
SnapshotUploader.exe Information: 0 : Extracting PDB info from D:\local\Temp\Dumps\<connection-string>\<request-ID>.dmp.
    DateTime=2018-03-09T01:42:59.6184651Z
SnapshotUploader.exe Information: 0 : Matched 2 PDB(s) with local files.
    DateTime=2018-03-09T01:42:59.6809606Z
SnapshotUploader.exe Information: 0 : Stamp does not want any of our matched PDBs.
    DateTime=2018-03-09T01:42:59.8059929Z
SnapshotUploader.exe Information: 0 : Deleted D:\local\Temp\Dumps\<connection-string>\<request-ID>.dmp
    DateTime=2018-03-09T01:42:59.8530649Z
```

> [!NOTE]
> The previous example is from version 1.2.0 of the `Microsoft.ApplicationInsights.SnapshotCollector` NuGet package. In earlier versions, the uploader process is called `MinidumpUploader.exe` and the log is less detailed.

In the previous example, the connection string should match the connection string for your application.

The request ID associates the minidump with a snapshot. You can use this ID later to locate the associated exception record in Application Insights Analytics.

The uploader scans for new PDBs about once every 15 minutes. Here's an example:

```
SnapshotUploader.exe Information: 0 : PDB rescan requested.
    DateTime=2018-03-09T01:47:19.4457768Z
SnapshotUploader.exe Information: 0 : Scanning D:\home\site\wwwroot for local PDBs.
    DateTime=2018-03-09T01:47:19.4457768Z
SnapshotUploader.exe Information: 0 : Local PDB scan complete. Found 2 PDB(s).
    DateTime=2018-03-09T01:47:19.4614027Z
SnapshotUploader.exe Information: 0 : Deleted PDB scan marker : D:\local\Temp\Dumps\<connection-string>\<process-ID>.pdbscan
    DateTime=2018-03-09T01:47:19.4614027Z
```

For applications that *aren't* hosted in App Service, the uploader logs are in the same folder as the minidumps: `%TEMP%\Dumps\<string>`, where `<string>` is your connection string.

## Troubleshoot Cloud Services

In Cloud Services, the default temporary folder might be too small to hold the minidump files, which can cause lost snapshots. The space you need depends on the total working set of your application and the number of concurrent snapshots.

The working set of a 32-bit ASP.NET web role is usually between 200 MB and 500 MB. Plan for at least two concurrent snapshots. For example, if your application uses 1 GB of total working set, ensure there's at least 2 GB of disk space to store snapshots.

Configure your Cloud Service role with a dedicated local resource for snapshots:

1. Add a new local resource to your Cloud Service by editing the Cloud Service definition (*.csdef*) file. The following example defines a resource called `SnapshotStore` with a size of 5 GB.

    ```xml
    <LocalResources>
        <LocalStorage name="SnapshotStore" cleanOnRoleRecycle="false" sizeInMB="5120" />
    </LocalResources>
    ```

1. Modify your role's startup code to add an environment variable that points to the `SnapshotStore` local resource. For Worker Roles, add the code to your role's `OnStart` method:

    ```csharp
    public override bool OnStart()
    {
        Environment.SetEnvironmentVariable("SNAPSHOTSTORE", RoleEnvironment.GetLocalResource("SnapshotStore").RootPath);
        return base.OnStart();
    }
    ```

    For Web Roles (ASP.NET), add the code to your web application's `Application_Start` method:

    ```csharp
    using Microsoft.WindowsAzure.ServiceRuntime;
    using System;
    namespace MyWebRoleApp
    {
        public class MyMvcApplication : System.Web.HttpApplication
        {
            protected void Application_Start()
            {
                Environment.SetEnvironmentVariable("SNAPSHOTSTORE", RoleEnvironment.GetLocalResource("SnapshotStore").RootPath);
                // TODO: The rest of your application startup code
            }
        }
    }
   ```

1. Update your role's *ApplicationInsights.config* file to override the temporary folder location that `SnapshotCollector` uses.

    ```xml
    <TelemetryProcessors>
        <Add Type="Microsoft.ApplicationInsights.SnapshotCollector.SnapshotCollectorTelemetryProcessor, Microsoft.ApplicationInsights.SnapshotCollector">
            <!-- Use the SnapshotStore local resource for snapshots -->
            <TempFolder>%SNAPSHOTSTORE%</TempFolder>
            <!-- Other SnapshotCollector configuration options -->
        </Add>
    </TelemetryProcessors>
   ```

## <a id="overriding-the-shadow-copy-folder"></a>Override the shadow copy folder

When the Snapshot Collector starts up, it tries to find a folder on disk that's suitable for running the Snapshot Uploader process. The chosen folder is known as the *shadow copy folder*.

The Snapshot Collector checks several well-known locations and makes sure it has permission to copy the Snapshot Uploader binaries. It uses the following environment variables:

- `Fabric_Folder_App_Temp`
- `LOCALAPPDATA`
- `APPDATA`
- `TEMP`

**If Snapshot Collector can't find a suitable folder,** it reports an error saying *"Couldn't find a suitable shadow copy folder."*

**If the copy fails,** Snapshot Collector reports a `ShadowCopyFailed` error.

**If Snapshot Collector can't launch the uploader,** it reports an `UploaderCannotStartFromShadowCopy` error. The body of the message often contains `System.UnauthorizedAccessException`. This error usually occurs because the application is running under an account with reduced permissions. The account has permission to write to the shadow copy folder, but it doesn't have permission to run the code.

Since these errors usually happen during startup, an `ExceptionDuringConnect` error saying *Uploader failed to start* often follows them.

To work around these errors, specify the shadow copy folder manually by using the `ShadowCopyFolder` configuration option. For example, use *ApplicationInsights.config*:

```xml
<TelemetryProcessors>
    <Add Type="Microsoft.ApplicationInsights.SnapshotCollector.SnapshotCollectorTelemetryProcessor, Microsoft.ApplicationInsights.SnapshotCollector">
        <!-- Override the default shadow copy folder. -->
        <ShadowCopyFolder>D:\SnapshotUploader</ShadowCopyFolder>
        <!-- Other SnapshotCollector configuration options -->
    </Add>
</TelemetryProcessors>
```

Or, if you're using *appsettings.json* with a .NET Core application:

```json
{
    "ApplicationInsights": {
        "ConnectionString": "<your connection string>"
    },
    "SnapshotCollectorConfiguration": {
        "ShadowCopyFolder": "D:\\SnapshotUploader"
    }
}
```

## Use Application Insights search to find exceptions with snapshots

When Snapshot Debugger creates a snapshot, it tags the throwing exception with a snapshot ID. The snapshot ID appears as a custom property when your application reports the exception to Application Insights. By using **Search** in Application Insights, you can find all records with the `ai.snapshot.id` custom property.

1. Browse to your Application Insights resource in the Azure portal.
1. Select **Investigate** > **Search**.
1. Type `ai.snapshot.id` in the search text box and press **Enter**.

:::image type="content" source="./media/snapshot-debugger/search-snapshot-portal.png" alt-text="Screenshot showing search for telemetry with a snapshot ID in the Azure portal.":::

If this search returns no results, your application didn't report any snapshots to Application Insights in the selected time range.

To search for a specific snapshot ID from the Uploader logs, type that ID in the search box. If you can't find records for a snapshot that you know was uploaded, follow these steps:

1. Double-check that you're looking at the right Application Insights resource by verifying the connection string.

1. By using the timestamp from the Uploader log, adjust the Time Range filter of the search to cover that time range.

If you still don't see an exception with that snapshot ID, then your application didn't report the exception record to Application Insights. This situation can happen if your application crashed after it took the snapshot but before it reported the exception record. In this case, check the App Service logs under `Diagnose and solve problems` to see whether there were unexpected restarts or unhandled exceptions.

## Edit network proxy or firewall rules

If your application connects to the internet through a proxy or a firewall, you might need to update the rules to communicate with the Snapshot Debugger service.

The Azure Monitor service tag includes the IPs that Application Insights Snapshot Debugger uses. For more information, see [Azure service tags overview for virtual network security](/azure/virtual-network/service-tags-overview).

## Are there any billing costs when using snapshots?

Snapshot Debugger doesn't incur any charges against your subscription. It stores the collected snapshot files separately from the telemetry that the Application Insights SDKs collect, and no charges apply to snapshot ingestion or storage.

[!INCLUDE [bring-your-own-storage-troubleshooting](../profiler/includes/bring-your-own-storage-troubleshooting.md)]
