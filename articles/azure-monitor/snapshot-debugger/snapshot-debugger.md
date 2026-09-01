---
title: Snapshot Debugger for .NET Exception Debugging
description: Learn how to use Snapshot Debugger to automatically capture debug snapshots of source code and variables when exceptions occur in your live .NET apps.
ms.reviewer: charles.weininger
reviewer: cweining
ms.topic: how-to
ms.custom: devx-track-dotnet, devdivchpfy22, engagement
ms.date: 03/10/2026
#customer intent: As a developer, I need to understand at a high level how Snapshot Debugger collects a snapshot when an exception occurs in a .NET application.
---

# Debug exceptions in .NET applications by using Snapshot Debugger

When enabled, Snapshot Debugger automatically collects a debug snapshot of the source code and variables when an exception occurs in your live .NET application. The Snapshot Debugger in [Application Insights](../app/app-insights-overview.md):

- Monitors system-generated logs from your web app.
- Collects snapshots on your top-throwing exceptions.
- Provides information you need to diagnose issues in production.

## Supported applications and environments

### Applications

Snapshot collection is available for:

- .NET Framework 4.6.2 and newer versions.
- [.NET 6.0 or later](https://dotnet.microsoft.com/download) on Windows.

### Environments

Snapshot Debugger supports the following environments:

- [Azure App Service](snapshot-debugger-app-service.md?toc=/azure/azure-monitor/toc.json)
- [Azure Functions](snapshot-debugger-function-app.md?toc=/azure/azure-monitor/toc.json)
- [Azure Cloud Services](snapshot-debugger-vm.md?toc=/azure/azure-monitor/toc.json) running OS family 4 or later
- [Azure Service Fabric](snapshot-debugger-vm.md?toc=/azure/azure-monitor/toc.json) running on Windows Server 2012 R2 or later
- [Azure Virtual Machines and Azure Virtual Machine Scale Sets](snapshot-debugger-vm.md?toc=/azure/azure-monitor/toc.json) running Windows Server 2012 R2 or later
- [On-premises virtual or physical machines](snapshot-debugger-vm.md?toc=/azure/azure-monitor/toc.json) running Windows Server 2012 R2 or later or Windows 8.1 or later

> [!NOTE]
> Client applications, such as WPF, Windows Forms, or UWP, aren't supported.

## Prerequisites for Snapshot Debugger

### Packages and configurations

- Include the [Snapshot Collector NuGet package](https://www.nuget.org/packages/Microsoft.ApplicationInsights.SnapshotCollector) in your application.
- Configure collection parameters in [`ApplicationInsights.config`](../app/configuration-with-applicationinsights-config.md).

### Permissions

- Verify that you have the [Application Insights Snapshot Debugger](/azure/role-based-access-control/role-assignments-portal) role for the target **Application Insights Snapshot**.

## How Snapshot Debugger works

The Snapshot Debugger works as an [Application Insights telemetry processor](../app/configuration-with-applicationinsights-config.md#telemetry-processors-aspnet). When your application runs, the Snapshot Debugger telemetry processor joins your application's system-generated logs pipeline. 

> [!IMPORTANT]
> Snapshots might contain personal data or other sensitive information in variable and parameter values. Application Insights stores snapshot data in the same region as your resource.

### Snapshot Debugger process

The Snapshot Debugger process starts and ends with the `TrackException` method. A process snapshot is a suspended clone of the running process. Your users experience little to no interruption. In a typical scenario:

1. Your application throws an exception and reports it to Application Insights by calling the [`TrackException`](../app/asp-net-exceptions.md#exceptions) method.

1. The Snapshot Debugger monitors exceptions as they're thrown by subscribing to the [`AppDomain.CurrentDomain.FirstChanceException`](/dotnet/api/system.appdomain.firstchanceexception) event. 

1. The Snapshot Debugger increments a counter for the problem ID. 

   When the counter reaches the `ThresholdForSnapshotting` value, the Snapshot Debugger adds the problem ID to a collection plan.
    
   > [!NOTE]
   > The `ThresholdForSnapshotting` default minimum value is 1. With this value, your app has to trigger the same exception *twice* before the Snapshot Debugger creates a snapshot.

1. The Snapshot Debugger computes the exception event's problem ID and compares it against the problem IDs in the collection plan.

1. If there's a match between problem IDs, the Snapshot Debugger creates a *snapshot* of the running process. 

   The Snapshot Debugger assigns the snapshot a unique identifier and stamps the exception with that identifier. 
   
   > [!NOTE]
   > The `SnapshotsPerTenMinutesLimit` setting limits the snapshot creation rate. By default, the limit is one snapshot every 10 minutes.
   
1. After the `FirstChanceException` handler returns, your application processes the thrown exception as normal. 

1. The exception reaches the `TrackException` method again, which reports it to Application Insights, along with the snapshot identifier.

> [!NOTE]
> Set `IsEnabledInDeveloperMode` to `true` to generate snapshots while you debug in Visual Studio.

### Snapshot Uploader process

While the Snapshot Debugger process continues to run and serve traffic to users with little interruption, it hands off the snapshot to the Snapshot Uploader process. In a typical scenario, the Snapshot Uploader:

1. Creates a minidump.

1. Uploads the minidump to Application Insights, along with any relevant symbol (*.pdb*) files.

> [!NOTE]
> The Snapshot Uploader can upload no more than 50 snapshots per day.

If you enabled the Snapshot Debugger but you aren't seeing snapshots, see the [Troubleshooting guide](snapshot-debugger-troubleshoot.md).

## Upgrade Snapshot Debugger

Snapshot Debugger auto-upgrades by using the built-in, preinstalled Application Insights site extension. 

Manually adding an Application Insights site extension to keep Snapshot Debugger up to date is deprecated.  

## Snapshot Debugger overhead

The Snapshot Debugger is designed for use in production environments. The default settings include rate limits to minimize the impact on your applications. 

However, you might experience small CPU, memory, and I/O overhead associated with the Snapshot Debugger, such as:

- When your application throws an exception
- If the exception handler decides to create a snapshot
- When `TrackException` is called

There's **no additional cost** for storing the data that the Snapshot Debugger captures.

[See example scenarios in which you might experience Snapshot Debugger overhead.](./snapshot-debugger-troubleshoot.md#snapshot-debugger-overhead-scenarios)

## Code Optimizations

If Snapshot Debugger collects snapshots from your app, you might see related exception insights in the [Code Optimizations consolidated overview](../optimization-insights/view-code-optimizations.md#exceptions). 

## Snapshot Debugger limitations

The Snapshot Debugger has the following limitations:

- **Data retention**

  Debug snapshots are stored for 15 days. The default data retention policy is set on a per-application basis. To increase this value, open a support case in the Azure portal. Each Application Insights instance allows a maximum of 50 snapshots per day.

- **Publish symbols**

  The Snapshot Debugger requires symbol files on the production server to:

  - Decode variables
  - Provide a debugging experience in Visual Studio

  By default, Visual Studio 2017 version 15.2 or later publishes symbols for release builds when it publishes to App Service. 

  In prior versions, you must add the following line to your publish profile `.pubxml` file so that symbols are published in release mode:

  ```xml
      <ExcludeGeneratedDebugSymbol>False</ExcludeGeneratedDebugSymbol>
  ```

  For Azure Compute and other types, make sure that the symbol files are either:

  - In the same folder of the main application `.dll` (typically, `wwwroot/bin`), or
  - Available on the current path.

  For more information about the available symbol options, see the [Visual Studio documentation](/visualstudio/ide/reference/advanced-build-settings-dialog-box-csharp). For best results, use *Full*, *Portable*, or *Embedded*.

- **Optimized builds**

  In some cases, you can't view local variables in release builds because the JIT compiler applies optimizations.

  However, in App Service, the Snapshot Debugger can deoptimize throwing methods that are part of its collection plan.

  > [!TIP]
  > Install the Application Insights Site extension in your instance of App Service to get deoptimization support.

## Related content

Enable the Application Insights Snapshot Debugger for your application:

- [Azure App Service](snapshot-debugger-app-service.md?toc=/azure/azure-monitor/toc.json)
- [Azure Functions](snapshot-debugger-function-app.md?toc=/azure/azure-monitor/toc.json)
- [Azure Cloud Services](snapshot-debugger-vm.md?toc=/azure/azure-monitor/toc.json)
- [Azure Service Fabric](snapshot-debugger-vm.md?toc=/azure/azure-monitor/toc.json)
- [Azure Virtual Machines and Virtual Machine Scale Sets](snapshot-debugger-vm.md?toc=/azure/azure-monitor/toc.json)
- [On-premises virtual or physical machines](snapshot-debugger-vm.md?toc=/azure/azure-monitor/toc.json)
