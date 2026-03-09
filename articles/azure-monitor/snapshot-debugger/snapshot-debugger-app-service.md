---
title: Enable Snapshot Debugger for .NET apps in Azure App Service | Microsoft Docs
description: Learn how to enable Snapshot Debugger for .NET apps in Azure App Service by using the Azure portal or an Azure Resource Manager template.
ms.topic: how-to
ms.reviewer: charles.weininger
reviewer: cweining
ms.date: 03/10/2026
ms.custom: devdivchpfy22, devx-track-arm-template, devx-track-dotnet
#customer intent: As an application developer, I want to know how to enable Snapshot Debugger for my .NET apps in the Azure App Service.
---

# Enable Snapshot Debugger for .NET apps in Azure App Service

Snapshot Debugger currently supports ASP.NET and ASP.NET Core apps running on Azure App Service on Windows service plans. 

> [!NOTE]
> If you're using a preview version of .NET Core, or your application references Application Insights SDK, directly or indirectly through a dependent assembly, follow the instructions for [Enable Snapshot Debugger for other environments](snapshot-debugger-vm.md) to include the [`Microsoft.ApplicationInsights.SnapshotCollector`](https://www.nuget.org/packages/Microsoft.ApplicationInsights.SnapshotCollector) NuGet package with the application.

We recommend that you run your application on the Basic or higher service tiers when using Snapshot Debugger. For most applications:

- The Free and Shared service tiers don't have enough memory or disk space to save snapshots. 
- The Consumption tier isn't currently available for Snapshot Debugger.

Although Snapshot Debugger is preinstalled as part of the App Services runtime, you need to turn it on to get snapshots for your App Service app. Codeless installation of Snapshot Debugger follows [the .NET Core support policy.](https://dotnet.microsoft.com/platform/support/policy/dotnet-core).

# [Azure portal](#tab/portal)

You can enable Snapshot Debugger in the Azure portal after deploying your .NET App Services web app.

1. Navigate to your App Services web app in the [Azure portal](https:portal.azure.com).

1. In the left menu, select **Monitoring** > **Application Insights**.

   :::image type="content" source="./media/snapshot-debugger/application-insights-app-services.png" alt-text="Screenshot showing where to enable Application Insights in App Services.":::

1. Select **Turn on Application Insights**.

   If you have an existing Application Insights resource you'd rather use, select that option under **Change your resource**.

1. Under **Instrument your application**, select **.NET**.

1. Switch both Snapshot Debugger toggles to **On**.
  
   :::image type="content" source="./media/snapshot-debugger/enablement-ui.png" alt-text="Screenshot showing how to add Application Insights site extension.":::
  
1. Snapshot Debugger is now enabled.

## Disable Snapshot Debugger

To disable Snapshot Debugger for your App Services resource:

1. Navigate to your App Service in the Azure portal. 

1. In the left menu, select **Monitoring** > **Application Insights**.

1. Switch the Snapshot Debugger toggles to **Off**.

# [Azure Resource Manager](#tab/arm)

You can also enable Snapshot Debugger and .NET Profiler using app settings in the Azure Resource Manager template. For example:

```json
{
  "apiVersion": "2023-12-01",
  "name": "[parameters('webSiteName')]",
  "type": "Microsoft.Web/sites",
  "location": "[resourceGroup().location]",
  "dependsOn": [
    "[variables('hostingPlanName')]"
  ],
  "tags": { 
    "[concat('hidden-related:', resourceId('Microsoft.Web/serverfarms', variables('hostingPlanName')))]": "empty",
    "displayName": "Website"
  },
  "properties": {
    "name": "[parameters('webSiteName')]",
    "serverFarmId": "[resourceId('Microsoft.Web/serverfarms', variables('hostingPlanName'))]"
  },
  "resources": [
    {
      "apiVersion": "2015-08-01",
      "name": "appsettings",
      "type": "config",
      "dependsOn": [
        "[parameters('webSiteName')]",
        "[concat('AppInsights', parameters('webSiteName'))]"
      ],
      "properties": {
        "APPINSIGHTS_INSTRUMENTATIONKEY": "[reference(resourceId('Microsoft.Insights/components', concat('AppInsights', parameters('webSiteName'))), '2014-04-01').InstrumentationKey]",
        // "Turn on" a Snapshot Debugger version
        "APPINSIGHTS_SNAPSHOTFEATURE_VERSION": "1.0.0",
        "DiagnosticServices_EXTENSION_VERSION": "~3",
        "ApplicationInsightsAgent_EXTENSION_VERSION": "~2"
      }
    }
  ]
},
```

---

Generate traffic to your application that can trigger an exception. Then, wait 10 to 15 minutes for snapshots to be sent to the Application Insights instance.

## Enable Snapshot Debugger for other cloud regions

Currently, the only regions that require endpoint modifications are [Azure Government](/azure/azure-government/compare-azure-government-global-azure#application-insights) and [Microsoft Azure operated by 21Vianet](/azure/china/resources-developer-guide) through the Application Insights Connection String.

| Connection String Property | US Government Cloud                 | China Cloud                         |
|----------------------------|-------------------------------------|-------------------------------------|
| SnapshotEndpoint           | `https://snapshot.monitor.azure.us` | `https://snapshot.monitor.azure.cn` |

For more information about other connection overrides, see [Application Insights documentation](../app/connection-strings.md?tabs=net#connection-string-with-explicit-endpoint-overrides).

## Configure Snapshot Debugger

### Enable Microsoft Entra authentication for snapshot ingestion

Snapshot Debugger supports Microsoft Entra authentication for snapshot ingestion. For all snapshots of your application to be ingested, your application must be authenticated and provide the required application settings to the Snapshot Debugger agent.

> [!NOTE]
> Currently, Snapshot Debugger only supports Microsoft Entra authentication when you reference and configure Microsoft Entra ID using the Application Insights SDK in your application.

1. Add the managed identity that authenticates against your Application Insights resource to your App Service. You can create either:

   - [A System-Assigned Managed identity](/azure/app-service/overview-managed-identity?tabs=portal%2chttp#add-a-system-assigned-identity).
   - [A User-Assigned Managed identity](/azure/app-service/overview-managed-identity?tabs=portal%2chttp#add-a-user-assigned-identity).

1. In the Azure portal, [configure and turn on Microsoft Entra ID in your Application Insights resource](../app/azure-ad-authentication.md?tabs=net#configure-and-enable-azure-ad-based-authentication).

1. Add the following application setting. This setting tells the Snapshot Debugger agent which managed identity to use:

   For System-Assigned Identity:

   | App Setting                               | Value            |
   |-------------------------------------------|------------------|
   | APPLICATIONINSIGHTS_AUTHENTICATION_STRING | Authorization=AD |

   For User-Assigned Identity:

   | App Setting                               | Value            |
   |-------------------------------------------|------------------|
   | APPLICATIONINSIGHTS_AUTHENTICATION_STRING | Authorization=AD;ClientID={Client ID of the User-Assigned Identity} |

## Unsupported scenarios

The following scenario demonstrate where Snapshot Collector isn't supported.

| Scenario | Side Effects | Recommendation |
|----------|--------------|----------------|
| You're using the Snapshot Collector SDK in your application directly (*.csproj*) and enabled the advanced option *Interop*. | The local Application Insights SDK, including Snapshot Collector telemetry, is lost and no Snapshots are available.<br/>Your application could crash at startup with `System.ArgumentException: telemetryProcessorTypedoes not implement ITelemetryProcessor.`<br/>[Learn more about the Application Insights feature Interop.](../app/azure-web-apps-net-core.md#troubleshooting) | If you're using the advanced option *Interop*, use the codeless Snapshot Collector injection, enabled through the Azure portal. |

## Related content

- View [snapshots](snapshot-debugger-data.md?toc=/azure/azure-monitor/toc.json#access-debug-snapshots-in-the-portal) in the Azure portal.
- [Troubleshoot Snapshot Debugger issues](snapshot-debugger-troubleshoot.md).

[Enablement UI]: ./media/snapshot-debugger/enablement-ui.png
[snapshot-debugger-app-setting]:./media/snapshot-debugger/snapshot-debugger-app-setting.png
