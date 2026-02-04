---
title: Send Azure Diagnostics data to Application Insights
description: Update the Azure Diagnostics public configuration to send data to Application Insights.
ms.topic: how-to
ms.date: 11/14/2024
ms.reviewer: JeffWo
---

# Send Cloud Service, Virtual Machine, or Service Fabric diagnostic data to Application Insights

Cloud services, Virtual Machines, Virtual Machine Scale Sets and Service Fabric all use the Azure Diagnostics extension to collect data. Azure diagnostics sends data to Azure Storage tables. However, you can also pipe all or a subset of the data to other locations using Azure Diagnostics extension 1.5 or later.

This article describes how to send data from the Azure Diagnostics extension to Application Insights.

## Diagnostics configuration explained

The Azure diagnostics extension 1.5 introduced sinks, which are extra locations where you can send diagnostic data.

Example configuration of a sink for Application Insights:

```xml
<SinksConfig>
    <Sink name="ApplicationInsights">
      <ApplicationInsights>{Insert ConnectionString}</ApplicationInsights>
      <Channels>
        <Channel logLevel="Error" name="MyTopDiagData"  />
        <Channel logLevel="Verbose" name="MyLogData"  />
      </Channels>
    </Sink>
</SinksConfig>
```
```JSON
"SinksConfig": {
    "Sink": [
        {
            "name": "ApplicationInsights",
            "ApplicationInsights": "{Insert ConnectionString}",
            "Channels": {
                "Channel": [
                    {
                        "logLevel": "Error",
                        "name": "MyTopDiagData"
                    },
                    {
                        "logLevel": "Error",
                        "name": "MyLogData"
                    }
                ]
            }
        }
    ]
}
```

* The **Sink** *name* attribute is a string value that uniquely identifies the sink.

* The **ApplicationInsights** element specifies the connection string of the Application insights resource where the Azure diagnostics data is sent.
    * If you don't have an existing Application Insights resource, see [Create a new Application Insights resource](/previous-versions/azure/azure-monitor/app/create-new-resource).
    * If you're developing a Cloud Service with Azure SDK 2.8 and later, the connection string is automatically populated. The value is based on the **APPLICATIONINSIGHTS_CONNECTION_STRING** service configuration setting when packaging the Cloud Service project, see [Use Application Insights with Cloud Services](../app/azure-web-apps-net-core.md).

* The **Channels** element contains one or more **Channel** elements.
    * The *name* attribute uniquely refers to that channel.
    * The *loglevel* attribute lets you specify the log level that the channel allows. The available log levels in order of most to least information are:
        * Verbose
        * Information
        * Warning
        * Error
        * Critical

A channel acts like a filter and allows you to select specific log levels to send to the target sink. For example, you could collect verbose logs and send them to storage, but send only Errors to the sink.

The following graphic shows this relationship.
<!-- convertborder later -->
:::image type="content" source="media/diagnostics-extension-to-application-insights/AzDiag_Channels_App_Insights.png" lightbox="media/diagnostics-extension-to-application-insights/AzDiag_Channels_App_Insights.png" alt-text="Diagnostics Public Configuration" border="false":::

The following graphic summarizes the configuration values and how they work. You can include multiple sinks in the configuration at different levels in the hierarchy. The sink at the top level acts as a global setting and the one specified at the individual element acts like an override to that global setting.

:::image type="content" source="media/diagnostics-extension-to-application-insights/Azure_Diagnostics_Sinks.png" lightbox="media/diagnostics-extension-to-application-insights/Azure_Diagnostics_Sinks.png" alt-text="Diagnostics Sinks  Configuration with Application Insights":::

## Complete sink configuration example

Here's a complete example of the public configuration file that:

1. Sends all errors to Application Insights (specified at the **DiagnosticMonitorConfiguration** node).
1. Also sends Verbose level logs for the Application Logs (specified at the **Logs** node).

```xml
<WadCfg>
  <DiagnosticMonitorConfiguration overallQuotaInMB="4096"
       sinks="ApplicationInsights.MyTopDiagData"> <!-- All info below sent to this channel -->
    <DiagnosticInfrastructureLogs />
    <PerformanceCounters>
      <PerformanceCounterConfiguration counterSpecifier="\Processor(_Total)\% Processor Time" sampleRate="PT3M" />
      <PerformanceCounterConfiguration counterSpecifier="\Memory\Available MBytes" sampleRate="PT3M" />
    </PerformanceCounters>
    <WindowsEventLog scheduledTransferPeriod="PT1M">
      <DataSource name="Application!*" />
    </WindowsEventLog>
    <Logs scheduledTransferPeriod="PT1M" scheduledTransferLogLevelFilter="Verbose"
            sinks="ApplicationInsights.MyLogData"/> <!-- This specific info sent to this channel -->
  </DiagnosticMonitorConfiguration>

<SinksConfig>
    <Sink name="ApplicationInsights">
      <ApplicationInsights>{Insert ConnectionString}</ApplicationInsights>
      <Channels>
        <Channel logLevel="Error" name="MyTopDiagData"  />
        <Channel logLevel="Verbose" name="MyLogData"  />
      </Channels>
    </Sink>
  </SinksConfig>
</WadCfg>
```

```JSON
"WadCfg": {
    "DiagnosticMonitorConfiguration": {
        "overallQuotaInMB": 4096,
        "sinks": "ApplicationInsights.MyTopDiagData", "_comment": "All info below sent to this channel",
        "DiagnosticInfrastructureLogs": {
        },
        "PerformanceCounters": {
            "PerformanceCounterConfiguration": [
                {
                    "counterSpecifier": "\\Processor(_Total)\\% Processor Time",
                    "sampleRate": "PT3M"
                },
                {
                    "counterSpecifier": "\\Memory\\Available MBytes",
                    "sampleRate": "PT3M"
                }
            ]
        },
        "WindowsEventLog": {
            "scheduledTransferPeriod": "PT1M",
            "DataSource": [
                {
                    "name": "Application!*"
                }
            ]
        },
        "Logs": {
            "scheduledTransferPeriod": "PT1M",
            "scheduledTransferLogLevelFilter": "Verbose",
            "sinks": "ApplicationInsights.MyLogData", "_comment": "This specific info sent to this channel"
        }
    },
    "SinksConfig": {
        "Sink": [
            {
                "name": "ApplicationInsights",
                "ApplicationInsights": "{Insert ConnectionString}",
                "Channels": {
                    "Channel": [
                        {
                            "logLevel": "Error",
                            "name": "MyTopDiagData"
                        },
                        {
                            "logLevel": "Verbose",
                            "name": "MyLogData"
                        }
                    ]
                }
            }
        ]
    }
}
```

In the previous configuration, the following lines have the following meanings:

### Send all the data Azure diagnostics collects

```xml
<DiagnosticMonitorConfiguration overallQuotaInMB="4096" sinks="ApplicationInsights">
```

```json
"DiagnosticMonitorConfiguration": {
    "overallQuotaInMB": 4096,
    "sinks": "ApplicationInsights",
}
```

### Send only error logs to the Application Insights sink

```xml
<DiagnosticMonitorConfiguration overallQuotaInMB="4096" sinks="ApplicationInsights.MyTopDiagdata">
```

```json
"DiagnosticMonitorConfiguration": {
    "overallQuotaInMB": 4096,
    "sinks": "ApplicationInsights.MyTopDiagData",
}
```

### Send Verbose application logs to Application Insights

```xml
<Logs scheduledTransferPeriod="PT1M" scheduledTransferLogLevelFilter="Verbose" sinks="ApplicationInsights.MyLogData"/>
```
```JSON
"DiagnosticMonitorConfiguration": {
    "overallQuotaInMB": 4096,
    "sinks": "ApplicationInsights.MyLogData",
}
```

## Limitations

* **Channels only log type and not performance counters.** If you specify a channel with a performance counter element, it's ignored.
* **The log level for a channel can't exceed the log level for what is being collected by Azure diagnostics.** For example, you can't collect Application Log errors in the Logs element and try to send Verbose logs to the Application Insight sink. The *scheduledTransferLogLevelFilter* attribute must always collect equal or more logs than the logs you're trying to send to a sink.
* **You can't send blob data collected by Azure diagnostics extension to Application Insights.** For example, anything specified under the *Directories* node. For Crash Dumps, the actual crash dump is sent to blob storage and only a notification that the crash dump was generated is sent to Application Insights.

## Next Steps

* Learn how to [view your Azure diagnostics information](../app/azure-web-apps-net-core.md) in Application Insights.
* Use [PowerShell](/azure/cloud-services/cloud-services-diagnostics-powershell) to enable the Azure diagnostics extension for your application.
* Use [Visual Studio](/visualstudio/azure/vs-azure-tools-diagnostics-for-cloud-services-and-virtual-machines) to enable the Azure diagnostics extension for your application.
