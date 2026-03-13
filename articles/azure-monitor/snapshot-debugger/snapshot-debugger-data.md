---
title: View Application Insights Snapshot Debugger data
description: Learn how to view snapshots collected by the Snapshot Debugger in either the Azure portal or Visual Studio.
ms.reviewer: charles.weininger
reviewer: cweining
ms.topic: how-to
ms.custom: devdivchpfy22
ms.date: 03/11/2026
#customer intent: As an application developer, I need to view debug snapshots to troubleshoot issues with my apps.
---

# View Application Insights Snapshot Debugger data

Snapshots appear as [**Exceptions**](../app/asp-net-exceptions.md) in the Application Insights pane of the Azure portal. View debug snapshots in the Azure portal to examine the call stack and inspect variables at each call stack frame.

For a more powerful debugging experience with source code, open snapshots with Visual Studio Enterprise. You can also set SnapPoints to interactively take snapshots without waiting for an exception. For more information, see [Debug live ASP.NET Azure apps](/visualstudio/debugger/debug-live-azure-applications).

## Prerequisites

Snapshots might include sensitive information. You can view snapshots only if you have the `Application Insights Snapshot Debugger` role.

<a name="access-debug-snapshots-in-the-portal"></a>
## Access debug snapshots in the Azure portal

After an exception occurs in your application and a snapshot is created, you can view snapshots in the [Azure portal](https://portal.azure.com) within 5 to 10 minutes. 

### From the Failures pane

1. In your Application Insights resource, in the left menu, select **Investigate** > **Failures**.

1. In the **Failures** pane, select either:

   - The **Operations** tab
   - The **Exceptions** tab

1. Select the **[x] Samples** in the center column of the page to generate a list of sample operations or exceptions to the right.

   :::image type="content" source="./media/snapshot-debugger/failures-page.png" alt-text="Screenshot showing the Failures Page in Azure portal." lightbox="./media/snapshot-debugger/failures-page.png":::

1. From the list of samples, select an operation or exception to open the **End-to-End Transaction Details** page. From here, select the exception event you'd like to investigate.

   - If a snapshot is available for the given exception, select **Open debug snapshot** in the right pane to view the **Debug Snapshot** page. 
   - If you don't see this option, there might be no snapshot available. See the [troubleshooting guide](./snapshot-debugger-troubleshoot.md#use-the-snapshot-health-check).

   :::image type="content" source="./media/snapshot-debugger/e2e-transaction-page.png" alt-text="Screenshot showing the Open Debug Snapshot button on exception." lightbox="./media/snapshot-debugger/e2e-transaction-page.png":::

1. In the **Debug Snapshot** page, you see a call stack with a local variables pane. Select a call stack frame to view local variables and parameters for that function call in the variables pane.

   :::image type="content" source="./media/snapshot-debugger/open-snapshot-portal.png" alt-text="Screenshot showing the Open debug snapshot highlighted in the Azure portal." lightbox="./media/snapshot-debugger/open-snapshot-portal.png":::

### From the Code Optimizations consolidated overview

You can also view insights on your exception snapshots by using the [Code Optimizations consolidated overview page](../optimization-insights/view-code-optimizations.md#exceptions). 

1. In the Azure portal, search for **Code Optimizations**.

1. Use the filters to narrow down results to your specific Azure subscription and resource. 

1. Under the **Insight type** column in the results window, look for **Exceptions**.

   :::image type="content" source="./media/snapshot-debugger/view-exceptions-in-code-optimizations.png" alt-text="Screenshot showing the Exception snapshot on the Code Optimizations consolidated overview in the Azure portal." lightbox="./media/snapshot-debugger/view-exceptions-in-code-optimizations.png":::

## Download snapshots to view in Visual Studio

To view snapshots in Visual Studio 2017 Enterprise or greater:

1. Select **Download Snapshot** in the **Debug Snapshot** page to download a `.diagsession` file, which can be opened by Visual Studio Enterprise.

1. In Visual Studio, make sure you have the Snapshot Debugger Visual Studio component installed. 

   - **For Visual Studio 2017 Enterprise and greater:** The required Snapshot Debugger component can be selected from the **Individual Component** list in the Visual Studio installer. 
   - **For a version older than Visual Studio 2017 version 15.5:** Install the extension from the [Visual Studio Marketplace](https://aka.ms/snapshotdebugger).

1. Open the `.diagsession` file in Visual Studio to generate the Minidump Debugging page. 

1. Select **Debug Managed Code** to start debugging the snapshot. The snapshot opens to the line of code where the exception was thrown.

   :::image type="content" source="./media/snapshot-debugger/open-snapshot-visual-studio.png" alt-text="Screenshot showing the debug snapshot in Visual Studio." lightbox:::

> [!NOTE]
> The downloaded snapshot includes any symbol files found on your web application server. These symbol files are required to associate snapshot data with source code. For App Service apps, make sure to enable symbol deployment when you publish your web apps.

## Related content

Enable the Snapshot Debugger in your:

- [App Service](./snapshot-debugger-app-service.md)
- [Function App](./snapshot-debugger-function-app.md)
- [Virtual machine or other Azure service](./snapshot-debugger-vm.md)
