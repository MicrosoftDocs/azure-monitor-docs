---
title: Performance Benchmark for forwarding Gateway using Azure Monitor Agent 
description: Performance data for the AMA running in a gateway scenario
ms.topic: conceptual
author: guywi-ms
ms.author: guywild
ms.date: 4/07/2023
ms.reviewer: jeffwo
 
# Customer intent: As a deployment engineer, I can scope the resources required to scale my gateway data colletors the use the Azure Monitor Agent. 

---
# Azure Monitor Agent Performance Benchmark

The agent can handle many thousands of events per second in the gateway event forwarding scenario. The exact throughput rate depends on various factors such as the size of each event, the specific data type, and physical hardware resources. This article describes the Microsoft internal benchmark used for testing the agent throughput of 10k Syslog events in the forwarder scenario. The benchmark results should provide a guide to size the resources that you need in your environment.

> [!NOTE]
> The results in this article are informational about the performance of AMA in the forwarding scenario only and do not constitute any service agreement on the part of Microsoft.   

## Best practices for agent as a forwarder. 

- The Linux AMA should target 10k EPS. There's a 20k EPS warning which doesn't mean data lost. AMA doesn't guarantee a lossless connection. However, loss is more likely when EPS is over 10k.
- The forwarder should be on a dedicated system to eliminate potential interference from other workloads. 
- The forwarder system should be monitored for CPU, memory, and disk utilization to prevent overloads from causing data loss. 
- The load balancer and redundant forwarder systems should be used to improve reliability and scalability. For other considerations for forwarders, see the Log Analytics Gateway documentation. 

## Agent Performance 

The benchmark is run in a controlled environment to get repeatable, accurate, and statistically significant results. The resources consumed by the agent are measured under a load of 10,000 simulated Syslog events per second. The simulated load is run on the same physical hardware that the agent under test is on. Test trials are run for seven days. For each trial, performance metrics are sampled every second to collect CPU, memory, and network maximum and average usage. This approach provides the right information to help you estimate the resources needed for your environment. 

> [!NOTE]
> The results do not measure the end-to-end throughput ingested by a Log Analytics Workspace (or other telemetry sinks), as there may be end-to-end variability due to network and backend pipeline performance.   

The benchmarks are run on an Azure VM Standard_F8s_v2 system using AMA Linux version 1.25.2 and 10 GB of disk space for the event cache. 

- vCPU’s:	8 with HyperThreading (800% CPU is possible) 
- Memory: 	16 GiB 
- Temp Storage:	64 GiB 
- Max Disk IOPS:	6400 
- Network:	12500 Mbps Max on all 4 physical NICs 



## Results 

| Perf Metric | Ave (Max) Med |
|:---|:---:|
| CPU %           | 51 (262)     |
| Memory RSS MB      | 276 (1,017)  |
| Network KBps    | 338 (18,033) |


## Frequently asked questions

This section provides answers to common questions.

### How much data is sent per agent?

The amount of data sent per agent depends on:      

* The solutions you've enabled.
* The number of logs and performance counters being collected.
* The volume of data in the logs.

See [Analyze usage in a Log Analytics workspace](../logs/analyze-usage.md).

For computers that are able to run the WireData agent, use the following query to see how much data is being sent:

```kusto
WireData
| where ProcessName == "C:\\Program Files\\Microsoft Monitoring Agent\\Agent\\MonitoringHost.exe"
| where Direction == "Outbound"
| summarize sum(TotalBytes) by Computer 
```

### How much network bandwidth is used by the Microsoft Monitoring Agent when it sends data to Azure Monitor?

Bandwidth is a function of the amount of data sent. Data is compressed as it's sent over the network.

## Next steps

- [Connect computers without internet access by using the Log Analytics gateway in Azure Monitor](gateway.md)
- [Install the Azure Monitor Agent](azure-monitor-agent-manage.md) on Windows and Linux virtual machines.
- [Create a data collection rule](azure-monitor-agent-data-collection.md) to collect data from the agent and send it to Azure Monitor.
