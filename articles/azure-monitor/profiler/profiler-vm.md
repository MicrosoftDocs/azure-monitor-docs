---
title: Enable .NET Profiler on VMs
description: Profile web apps running on a Windows virtual machine or a Windows virtual machine scale set by using Application Insights Profiler for .NET.
ms.topic: how-to
ms.date: 03/12/2026
ms.reviewer: charles.weininger
ai-usage: ai-assisted
#customer intent: As an application developer, I need to know how to run Application Insights Profiler for .NET for an app on an Azure virtual machine.
---

# Enable the .NET Profiler for web apps on a Windows virtual machine

[!INCLUDE [updated-for-az](~/reusable-content/ce-skilling/azure/includes/updated-for-az.md)]

Application Insights Profiler for .NET captures traces that show which code paths slow down your web app when it's running under load. With this information, you can pinpoint the methods that create performance bottlenecks and focus your optimization work where it has the most effect.

In this article, you enable Profiler for .NET for a web app that runs on a Windows virtual machine (VM) or virtual machine scale set in Azure. Profiler for .NET doesn't support on-premises servers.

In this article, you learn how to:

> [!div class="checklist"]
> - Add the Application Insights SDK to your application.
> - Confirm the latest stable release of the Application Insights SDK.
> - Enable the .NET Profiler by using Visual Studio and an Azure Resource Manager template (ARM template), PowerShell, or Azure Resource Explorer.

## Prerequisites

- A functioning [ASP.NET Core application](/aspnet/core/getting-started).
- An [Application Insights resource](../app/create-workspace-resource.md).
- The ARM templates for the Azure Diagnostics extension:

  - [Virtual machine](https://github.com/Azure/azure-docs-json-samples/blob/master/application-insights/WindowsVirtualMachine.json)
  - [Virtual machine scale set](https://github.com/Azure/azure-docs-json-samples/blob/master/application-insights/WindowsVirtualMachineScaleSet.json)

## Add the Application Insights SDK to your application

1. Open your ASP.NET Core project in Visual Studio.

1. Select **Project** > **Add Application Insights Telemetry**.

1. Select **Azure Application Insights**, then select **Next**.

1. Select the subscription where your Application Insights resource lives, then select **Next**.

1. Select where to save the connection string, then select **Next**.

1. Select **Finish**.

> [!NOTE]
> For full instructions, including how to enable Application Insights on your ASP.NET Core application without Visual Studio, see [Monitor .NET and Node.js applications](/azure/azure-monitor/app/asp-net-core).

## Confirm the latest stable release of the Application Insights SDK

1. Go to **Project** > **Manage NuGet Packages**.

1. Select **Microsoft.ApplicationInsights.AspNetCore**.

1. On the side pane, select the latest version of the SDK from the dropdown list.

1. Select **Update**.

   :::image type="content" source="../app/media/classic-api/update-nuget-package.png" alt-text="Screenshot that shows where to select the Application Insights package for update.":::

<a name="enable-the-net-profiler"></a>

## Enable the .NET Profiler on a Windows VM or virtual machine scale set

Enable Profiler in one of these ways:

- Within your ASP.NET Core application by using an ARM template and Visual Studio. **Recommended.**
- By using a PowerShell command.
- By using Azure Resource Explorer.

# [Visual Studio and ARM template](#tab/vs-arm)

Using an ARM template and Visual Studio is the recommended method for enabling the .NET Profiler on a Windows VM or virtual machine scale set.

### Install the Azure Diagnostics extension

1. Choose which ARM template to use:

   - [Virtual machine](https://github.com/Azure/azure-docs-json-samples/blob/master/application-insights/WindowsVirtualMachine.json)
   - [Virtual machine scale set](https://github.com/Azure/azure-docs-json-samples/blob/master/application-insights/WindowsVirtualMachineScaleSet.json)

1. In the template, locate the resource of type `extension`.

1. In Visual Studio, open the `arm.json` file that the Application Insights SDK added to your ASP.NET Core application.

1. Add the resource type `extension` from the template to the `arm.json` file to set up a VM or virtual machine scale set with Azure Diagnostics.

1. In the `WadCfg` node, add your Application Insights connection string to `MyApplicationInsightsProfilerSink`.

   ```json
   "WadCfg": {
     "SinksConfig": {
       "Sink": [
         {
           "name": "MyApplicationInsightsProfilerSink",
           "ApplicationInsightsProfiler": "YOUR_APPLICATION_INSIGHTS_CONNECTION_STRING"
         }
       ]
     }
   }
   ```

1. Deploy your application.

# [PowerShell](#tab/powershell)

The following PowerShell commands work for existing VMs and touch only the Azure Diagnostics extension.

> [!NOTE]
> If you deploy the VM again, you lose the sink. You need to update the configuration you use when you deploy the VM to preserve this setting.

### Add the Profiler sink by using the Azure Diagnostics configuration

1. Create a temporary file to store the diagnostics configuration.

   ```powershell
   $ConfigFilePath = [IO.Path]::GetTempFileName()
   ```

1. Export the currently deployed Azure Diagnostics configuration to the file.

   ```powershell
   (Get-AzVMDiagnosticsExtension -ResourceGroupName "YOUR_RESOURCE_GROUP" -VMName "YOUR_VM").PublicSettings | Out-File -Verbose $ConfigFilePath
   ```

1. Add the Application Insights Profiler sink to the `SinksConfig` node under `WadCfg` in the exported file.

   ```json
   "WadCfg": {
     "SinksConfig": {
       "Sink": [
         {
           "name": "MyApplicationInsightsProfilerSink",
           "ApplicationInsightsProfiler": "YOUR_APPLICATION_INSIGHTS_CONNECTION_STRING"
         }
       ]
     }
   }
   ```

1. Apply the updated configuration to the VM.

   ```powershell
   Set-AzVMDiagnosticsExtension -ResourceGroupName "YOUR_RESOURCE_GROUP" -VMName "YOUR_VM" -DiagnosticsConfigurationPath $ConfigFilePath
   ```

   > [!NOTE]
   > `Set-AzVMDiagnosticsExtension` might require the `-StorageAccountName` argument. If your original diagnostics configuration had the `storageAccountName` property in the `protectedSettings` section, which isn't downloadable, be sure to pass the same original value you had in this cmdlet call.

# [Azure Resource Explorer](#tab/azure-resource-explorer)

### Set the Profiler sink by using Azure Resource Explorer

Because the Azure portal doesn't provide a way to set the Application Insights Profiler for .NET sink, use [Azure Resource Explorer](https://resources.azure.com) to set the sink.

> [!NOTE]
> If you deploy the VM again, you lose the sink. To preserve this setting, update the configuration you use when you deploy the VM.

1. Verify that the Azure Diagnostics extension is installed by viewing your virtual machine's extensions.

   :::image type="content" source="./media/profiler-vm/wad-extension.png" alt-text="Screenshot that shows checking if the Azure Diagnostics extension is installed." lightbox="./media/profiler-vm/wad-extension.png":::

1. Find the Azure Diagnostics extension for your VM:

   1. Go to [Azure Resource Explorer](https://resources.azure.com).
   1. Expand **subscriptions** and find the subscription that holds the resource group with your VM.
   1. Drill down to your VM extensions by selecting your resource group. Then select **Microsoft.Compute** > **virtualMachines** > **[your virtual machine]** > **extensions**.

      :::image type="content" source="./media/profiler-vm/azure-resource-explorer.png" alt-text="Screenshot that shows going to WAD configuration in Azure Resource Explorer.":::

1. Add the Application Insights Profiler for .NET sink to the `SinksConfig` node under `WadCfg`. If you don't already have a `SinksConfig` section, you might need to add one. To add the sink:

   - Specify the proper Application Insights connection string in your settings.
   - Switch the Explorer mode to **Read/Write** in the upper-right corner.
   - Select **Edit**.

     :::image type="content" source="./media/profiler-vm/resource-explorer-sinks-config.png" alt-text="Screenshot that shows adding the Application Insights Profiler sink." lightbox="./media/profiler-vm/resource-explorer-sinks-config.png":::

     ```json
     "WadCfg": {
       "SinksConfig": {
         "Sink": [
           {
             "name": "MyApplicationInsightsProfilerSink",
             "ApplicationInsightsProfiler": "YOUR_APPLICATION_INSIGHTS_CONNECTION_STRING"
           }
         ]
       }
     }
     ```

1. After you finish editing the configuration, select **PUT**.

1. If the **PUT** is successful, a green check mark appears in the middle of the screen.

   :::image type="content" source="./media/profiler-vm/resource-explorer-put.png" alt-text="Screenshot that shows sending the PUT request to apply changes.":::

---

## Enable the IIS HTTP Tracing feature

If the application runs through Internet Information Services (IIS), enable the IIS HTTP Tracing Windows feature:

1. Establish remote access to the environment.

1. Use the [Add Windows features](/iis/configuration/system.webserver/tracing/) window, or run the following command in PowerShell as administrator:

   ```powershell
   Enable-WindowsOptionalFeature -FeatureName IIS-HttpTracing -Online -All
   ```

   If you can't establish remote access, use the [Azure CLI](/cli/azure/get-started-with-azure-cli) to run the following command:

   ```azurecli
   az vm run-command invoke -g YOUR_RESOURCE_GROUP -n YOUR_VM --command-id RunPowerShellScript --scripts "Enable-WindowsOptionalFeature -FeatureName IIS-HttpTracing -Online -All"
   ```

1. Deploy your application.

## Next step

> [!div class="nextstepaction"]
> [Generate load and view .NET Profiler traces](./profiler-data.md)
