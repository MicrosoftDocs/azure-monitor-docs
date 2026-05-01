---
title: Supported metrics - Microsoft.AAD/DomainServices
description: Reference for Microsoft.AAD/DomainServices metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.AAD/DomainServices, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.AAD/DomainServices

The following table lists the metrics available for the Microsoft.AAD/DomainServices resource type.

**Table headings**

**Metric** - The metric display name as it appears in the Azure portal.
**Name in Rest API** - Metric name as referred to in the [REST API](/azure/azure-monitor/essentials/rest-api-walkthrough).
**Unit** - Unit of measure.
**Aggregation** - The default [aggregation](/azure/azure-monitor/essentials/metrics-aggregation-explained) type. Valid values: Average, Minimum, Maximum, Total, Count.
**Dimensions** - [Dimensions](/azure/azure-monitor/essentials/metrics-aggregation-explained#dimensions-splitting-and-filtering) available for the metric.
**Time Grains** - [Intervals at which the metric is sampled](/azure/azure-monitor/essentials/metrics-aggregation-explained#granularity). For example, `PT1M` indicates that the metric is sampled every minute, `PT30M` every 30 minutes, `PT1H` every hour, and so on.
**DS Export**- Whether the metric is exportable to Azure Monitor Logs via Diagnostic Settings.

For information on exporting metrics, see - [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics) and [Create diagnostic settings in Azure Monitor](/azure/azure-monitor/essentials/create-diagnostic-settings?tabs=portal).

For information on metric retention, see [Azure Monitor Metrics overview](/azure/azure-monitor/essentials/data-platform-metrics#retention-of-metrics).


For a list of supported logs, see [Supported log categories - Microsoft.AAD/DomainServices](../supported-logs/microsoft-aad-domainservices-logs.md)


|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**NTDS - LDAP Searches/sec**<br><br>This metric indicates the average number of searches per second for the NTDS object. It is backed by performance counter data from the domain controller, and can be filtered or splitted by role instance. |`\DirectoryServices(NTDS)\LDAP Searches/sec` |CountPerSecond |Average |`DataCenter`, `Tenant`, `Role`, `RoleInstance`, `ScaleUnit`|PT1M |Yes|
|**NTDS - LDAP Successful Binds/sec**<br><br>This metric indicates the number of LDAP successful binds per second for the NTDS object. It is backed by performance counter data from the domain controller, and can be filtered or splitted by role instance. |`\DirectoryServices(NTDS)\LDAP Successful Binds/sec` |CountPerSecond |Average |`DataCenter`, `Tenant`, `Role`, `RoleInstance`, `ScaleUnit`|PT1M |Yes|
|**DNS - Total Query Received/sec**<br><br>This metric indicates the average number of queries received by DNS server in each second. It is backed by performance counter data from the domain controller, and can be filtered or splitted by role instance. |`\DNS\Total Query Received/sec` |CountPerSecond |Average |`DataCenter`, `Tenant`, `Role`, `RoleInstance`, `ScaleUnit`|PT1M |Yes|
|**Total Response Sent/sec**<br><br>This metric indicates the average number of reponses sent by DNS server in each second. It is backed by performance counter data from the domain controller, and can be filtered or splitted by role instance. |`\DNS\Total Response Sent/sec` |CountPerSecond |Average |`DataCenter`, `Tenant`, `Role`, `RoleInstance`, `ScaleUnit`|PT1M |Yes|
|**% Committed Bytes In Use**<br><br>This metric indicates the ratio of Memory\Committed Bytes to the Memory\Commit Limit. Committed memory is the physical memory in use for which space has been reserved in the paging file should it need to be written to disk. The commit limit is determined by the size of the paging file. If the paging file is enlarged, the commit limit increases, and the ratio is reduced. This counter displays the current percentage value only; it is not an average. It is backed by performance counter data from the domain controller, and can be filtered or splitted by role instance. |`\Memory\% Committed Bytes In Use` |Percent |Average |`DataCenter`, `Tenant`, `Role`, `RoleInstance`, `ScaleUnit`|PT1M |Yes|
|**% Processor Time (dns)**<br><br>This metric indicates the percentage of elapsed time that all of dns process threads used the processor to execute instructions. An instruction is the basic unit of execution in a computer, a thread is the object that executes instructions, and a process is the object created when a program is run. Code executed to handle some hardware interrupts and trap conditions are included in this count. It is backed by performance counter data from the domain controller, and can be filtered or splitted by role instance. |`\Process(dns)\% Processor Time` |Percent |Average |`DataCenter`, `Tenant`, `Role`, `RoleInstance`, `ScaleUnit`|PT1M |Yes|
|**% Processor Time (lsass)**<br><br>This metric indicates the percentage of elapsed time that all of lsass process threads used the processor to execute instructions. An instruction is the basic unit of execution in a computer, a thread is the object that executes instructions, and a process is the object created when a program is run. Code executed to handle some hardware interrupts and trap conditions are included in this count. It is backed by performance counter data from the domain controller, and can be filtered or splitted by role instance. |`\Process(lsass)\% Processor Time` |Percent |Average |`DataCenter`, `Tenant`, `Role`, `RoleInstance`, `ScaleUnit`|PT1M |Yes|
|**Total Processor Time**<br><br>This metric indicates the percentage of elapsed time that the processor spends to execute a non-Idle thread. It is calculated by measuring the percentage of time that the processor spends executing the idle thread and then subtracting that value from 100%. (Each processor has an idle thread that consumes cycles when no other threads are ready to run). This counter is the primary indicator of processor activity, and displays the average percentage of busy time observed during the sample interval. It should be noted that the accounting calculation of whether the processor is idle is performed at an internal sampling interval of the system clock (10ms). On todays fast processors, % Processor Time can therefore underestimate the processor utilization as the processor may be spending a lot of time servicing threads between the system clock sampling interval. Workload based timer applications are one example of applications which are more likely to be measured inaccurately as timers are signaled just after the sample is taken. It is backed by performance counter data from the domain controller, and can be filtered or splitted by role instance. |`\Processor(_Total)\% Processor Time` |Percent |Average |`DataCenter`, `Tenant`, `Role`, `RoleInstance`, `ScaleUnit`|PT1M |Yes|
|**Kerberos Authentications**<br><br>This metric indicates the number of times that clients use a ticket to authenticate to this computer per second. It is backed by performance counter data from the domain controller, and can be filtered or splitted by role instance. |`\Security System-Wide Statistics\Kerberos Authentications` |CountPerSecond |Average |`DataCenter`, `Tenant`, `Role`, `RoleInstance`, `ScaleUnit`|PT1M |Yes|
|**NTLM Authentications**<br><br>This metric indicates the number of NTLM authentications processed per second for the Active Directory on this domain contrller or for local accounts on this member server. It is backed by performance counter data from the domain controller, and can be filtered or splitted by role instance. |`\Security System-Wide Statistics\NTLM Authentications` |CountPerSecond |Average |`DataCenter`, `Tenant`, `Role`, `RoleInstance`, `ScaleUnit`|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
