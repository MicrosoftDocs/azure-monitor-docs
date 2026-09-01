---
title: .NET Profiler on Service Fabric
description: Profile live Azure Service Fabric apps with Application Insights Profiler for .NET. Learn how to update your Azure Resource Manager template and deploy your cluster.
ms.topic: how-to
ms.custom: references_regions
ms.date: 03/09/2026
ai-usage: ai-assisted
#customer intent: As a developer, I want to install the Azure Diagnostics extension for an Azure Service Fabric cluster so that I can profile my .NET application.
---

# Enable the .NET Profiler for Azure Service Fabric applications

Application Insights Profiler for .NET captures traces that show which lines of code take the most time to run while your application handles real production traffic. As a Service Fabric developer, you use these traces to pinpoint the performance bottlenecks that slow your application in production, without reproducing the problem in a test environment.

Azure Diagnostics includes the Profiler. To collect traces from an Azure Service Fabric cluster, you install the Azure Diagnostics extension by using an Azure Resource Manager template (ARM template).

In this guide, you learn how to:

> [!div class="checklist"]
> * Add the Application Insights Profiler for .NET property to your ARM template.
> * Deploy your Service Fabric cluster with the Application Insights Profiler for .NET connection string.
> * Enable Application Insights on your Service Fabric application.
> * Redeploy your Service Fabric cluster to enable the .NET Profiler.

## Prerequisites

- The Profiler supports .NET Framework and .NET applications.

  - Verify you're using [.NET Framework 4.6.2](/dotnet/framework/migration-guide/how-to-determine-which-versions-are-installed) or later.
  - Confirm that the deployed OS is `Windows Server 2012 R2` or later.

- [An Azure Service Fabric managed cluster](/azure/service-fabric/quickstart-managed-cluster-portal).

## Create a deployment template

1. In your Service Fabric managed cluster, go to where you implemented the [ARM template](https://github.com/Azure/azure-docs-json-samples/blob/master/application-insights/ServiceFabricCluster.json).

1. Locate the `WadCfg` tags in the [Azure Diagnostics](../agents/diagnostics-extension-overview.md) extension in the deployment template file.

1. Add the following `SinksConfig` section as a child element of `WadCfg`. Replace the `ApplicationInsightsProfiler` property value with your own Application Insights connection string:

   ```json
   "settings": {
       "WadCfg": {
           "SinksConfig": {
               "Sink": [
                   {
                       "name": "MyApplicationInsightsProfilerSinkVMSS",
                       "ApplicationInsightsProfiler": "YOUR_APPLICATION_INSIGHTS_CONNECTION_STRING"
                   }
               ]
           }
       }
   }
   ```

   For information about how to add the Diagnostics extension to your deployment template, see [Use monitoring and diagnostics with a Windows VM](/azure/virtual-machines/extensions/diagnostics-template).

## Deploy your Service Fabric cluster

After you update the `WadCfg` configuration with your Application Insights connection string, deploy your Service Fabric cluster.

Application Insights Profiler for .NET is installed and enabled automatically when you install the Azure Diagnostics extension on the cluster.

## Enable Application Insights on your Service Fabric application

For the .NET Profiler to collect profiles for your requests, your Service Fabric application must track operations with Application Insights. Choose the option that matches your application type:

- **For stateless APIs**: See [Write code to track requests with Application Insights Profiler](./profiler-trackrequests.md).
- **For tracking custom operations in other kinds of apps**: See [Monitor .NET and Node.js applications](../app/custom-operations-tracking.md).

After you enable Application Insights, redeploy your application.

## Generate traffic and view the .NET Profiler traces

1. Launch an [availability test](/previous-versions/azure/azure-monitor/app/monitor-web-app-availability) to generate traffic to your application.
1. Wait 10 to 15 minutes for the traces to reach the Application Insights instance.
1. View the [Profiler traces](./profiler-overview.md) by using the Application Insights instance in the Azure portal.

## Next step

> [!div class="nextstepaction"]
> [Generate load and view the .NET Profiler traces](./profiler-data.md)
