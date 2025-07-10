---
title: Enable Change Analysis (classic) | Microsoft Docs
description: Use Change Analysis (classic) in Azure Monitor to track and troubleshoot issues on your live site.
ms.topic: how-to
ms.date: 03/25/2025
---

# Enable Change Analysis (classic)

[!INCLUDE [transition](includes/change-analysis-is-moving.md)]

The Change Analysis (classic) service:

- Computes and aggregates change data from the data sources mentioned earlier.
- Provides a set of analytics for users to:

    - Easily move through all resource changes.
    - Identify relevant changes in the troubleshooting or monitoring context.

Register the `Microsoft.ChangeAnalysis` resource provider with an Azure Resource Manager subscription to make the resource properties and configuration change data available. The `Microsoft.ChangeAnalysis` resource provider is automatically registered when you do one of two things:

- Enter any UI entry point, like the web app **Diagnose and solve problems** tool.
- Bring up the Change Analysis (classic) standalone tab.

In this guide, you learn the two ways to enable Change Analysis (classic) for functions and web app in-guest changes:

- For one or a few functions or web apps, [enable Change Analysis (classic) via the UI](#enable-functions-and-web-app-in-guest-change-collection-via-the-change-analysis-classic-portal).
- For a large number of web apps (for example, 50+ web apps), [enable Change Analysis (classic) by using the provided PowerShell script](#enable-change-analysis-classic-at-scale-by-using-powershell).

> [!NOTE]
> Slot-level enablement for functions or web apps isn't supported at the moment.

## Enable functions and web app in-guest change collection via the Change Analysis (classic) portal

For web app in-guest changes, separate enablement is required for scanning code files within a web app. For more information, see [Change Analysis (classic) in the Diagnose and solve problems tool](change-analysis-visualizations.md#view-changes-by-using-the-diagnose-and-solve-problems-tool) section.

> [!NOTE]
> You might not immediately see web app in-guest file changes and configuration changes. Prepare for downtime and restart your web app to view changes within 30 minutes. If you still can't see changes, refer to the [troubleshooting guide](./change-analysis-troubleshoot.md#you-cant-see-in-guest-changes-for-a-newly-enabled-web-app).

1. Go to the Change Analysis (classic) UI in the portal.

1. Enable web app in-guest change tracking by using one of two options:

   - On the banner, select **Enable now**.

     :::image type="content" source="./media/change-analysis/enable-changeanalysis.png" alt-text="Screenshot that shows the application change options on the banner.":::

   - On the top menu, select **Configure**.
   
     :::image type="content" source="./media/change-analysis/configure-button.png" alt-text="Screenshot that shows the application change options on the top menu.":::

1. Toggle on **Change Analysis (classic)** status for applicable resources and select **Save**.

   :::image type="content" source="./media/change-analysis/change-analysis-on.png" alt-text="Screenshot that shows the Enable Change Analysis (classic) user interface.":::
  
## Enable Change Analysis (classic) at scale by using PowerShell

If your subscription includes several web apps, run the following script to enable *all web apps* in your subscription.

### Prerequisites

PowerShell Az module. Follow the instructions in [Install the Azure PowerShell module](/powershell/azure/install-azure-powershell).

### Run the following script

```PowerShell
# Log in to your Azure subscription
Connect-AzAccount

# Get subscription Id
$SubscriptionId = Read-Host -Prompt 'Input your subscription Id'

# Make Feature Flag visible to the subscription
Set-AzContext -SubscriptionId $SubscriptionId

# Register resource provider
Register-AzResourceProvider -ProviderNamespace "Microsoft.ChangeAnalysis"

# Enable each web app
$webapp_list = Get-AzWebApp | Where-Object {$_.kind -eq 'app'}
foreach ($webapp in $webapp_list)
{
    $tags = $webapp.Tags
    $tags["hidden-related:diagnostics/changeAnalysisScanEnabled"]=$true
    Set-AzResource -ResourceId $webapp.Id -Tag $tags -Force
}
```

## Frequently asked questions

This section provides answers to common questions.

### How can I enable Change Analysis (classic) for a web application?

Enable Change Analysis (classic) for web application in-guest changes by using the [Diagnose and solve problems tool](./change-analysis-visualizations.md#view-changes-by-using-the-diagnose-and-solve-problems-tool).

## Related content

- Learn about [visualizations in Change Analysis (classic)](change-analysis-visualizations.md).
- Learn how to [troubleshoot problems in Change Analysis (classic)](change-analysis-troubleshoot.md).
- Enable Application Insights for [Azure web apps](../../azure-monitor/app/azure-web-apps.md).
- Enable Application Insights for [Azure Virtual Machines and Azure Virtual Machine Scale Set IIS-hosted apps](../../azure-monitor/app/azure-vm-vmss-apps.md).
