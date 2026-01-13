---
title: Performance in Forwarding to Azure Monitor Agent
description: Learn about performance benchmark data for the Azure Monitor Agent running in a gateway event forwarding scenario.
ms.topic: article
ms.date: 11/14/2024
ms.reviewer: jeffwo
# Customer intent: As a deployment engineer, I can scope the resources required to scale my gateway data collectors the use the Azure Monitor Agent. 
---

# Azure Monitor Agent performance benchmark

The Azure Monitor Agent can handle many thousands of events per second (EPS) in the gateway event forwarding scenario. The exact throughput rate depends on various factors like the size of each event, the specific data type, and physical hardware resources.

This article describes the Microsoft internal benchmark that's used for testing the agent throughput of 10,000 (10K) syslog events in the gateway forwarder scenario. The benchmark results should provide a guide to size the resources that you need in your environment.

> [!NOTE]
> The results in this article are only informational related to the performance of Azure Monitor Agent in a gateway forwarding scenario. The results and the information in the article don't constitute any service agreement on the part of Microsoft.

## Best practices for agent as a forwarder

- The Linux Azure Monitor Agent should target 10,000 EPS. A 20,000 EPS warning might occur, but it doesn't mean that data is lost. The Azure Monitor Agent doesn't guarantee a lossless connection. Loss is more likely when EPS is over 10,000.
  - The Azure Monitor Agent should target 5,000 EPS. The EPS might be higher, but there's no warning or throttling that occurs. This threshold is set based on the limit of 5,000 EPS from the Windows Event service.
- The forwarder should be on a dedicated system to eliminate potential interference from other workloads.
- The forwarder system should be monitored for CPU, memory, and disk utilization to prevent overloads from causing data loss.
- The load balancer and redundant forwarder systems should be used to improve reliability and scalability. For other considerations for forwarders, see the Log Analytics gateway documentation.

## Agent performance

The benchmark is run in a controlled environment to get repeatable, accurate, and statistically significant results. The resources consumed by the agent are measured under a load of 10,000 simulated syslog events per second. The simulated load is run on the same physical hardware that the agent being tested is on. Test trials run for seven days. For each trial, performance metrics are sampled every second to collect CPU, memory, and network maximum and average usage. This approach provides the right information to help you estimate the resources needed for your environment.

> [!NOTE]
> Performance testing results don't measure the end-to-end throughput ingested by a Log Analytics workspace (or other telemetry sinks). End-to-end variability might occur due to network and back-end pipeline performance.

The benchmarks are run on an Azure virtual machine Standard_F8s_v2 system. It uses Azure Monitor Agent Linux version 1.25.2 with 10 GB of disk space for the event cache.

- vCPUs: Eight with Hyper-Threading (800% CPU is possible)
- Memory: 16 GiB
- Temp storage: 64 GiB
- Max disk input/output operations per second: 6,400
- Network: 12,500 Mbps max on all four physical network interface cards

## Results

| Perf Metric | Ave (Max) Med |
|:---|:---:|
| **CPU %**           | 51 (262)     |
| **Memory RSS MB**      | 276 (1,017)  |
| **Network KBps**    | 338 (18,033) |

## FAQs

Get answers to common questions.

### How much data is sent per agent?

The amount of data sent per agent depends on:

- The solutions you enabled
- The number of logs and performance counters that are collected
- The volume of data in the logs

For more information, see [Analyze usage in a Log Analytics workspace](../logs/analyze-usage.md).

For computers that are able to run the WireData Agent, use the following query to see how much data is sent:

```kusto
WireData
| where ProcessName == "C:\\Program Files\\Microsoft Monitoring Agent\\Agent\\MonitoringHost.exe"
| where Direction == "Outbound"
| summarize sum(TotalBytes) by Computer 
```

### How much network bandwidth is used by the Microsoft Monitoring Agent when it sends data to Azure Monitor?

Bandwidth is a function of the amount of data that gets sent. Data is compressed as it gets sent over the network.

## Related content

- [Use the Log Analytics gateway in Azure Monitor](gateway.md) when connecting computers without internet access.
- [Install the Azure Monitor Agent](../vm/data-collection.md) on Windows and Linux virtual machines.
- [Create a data collection rule](azure-monitor-agent-data-collection.md) to collect data from the agent and send it to Azure Monitor.
