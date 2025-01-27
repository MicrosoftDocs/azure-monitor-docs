---
title: Virtual machine guest metrics
description: Guest metrics colleceted by the Azure Monitor agent
author: EdB-MSFT
ms.author: edbaynash
services: azure-monitor
ms.topic: conceptual
ms.date: 01/27/2025
---


# Virtual machine guest metrics


The Azure Monitor agent collects guest metrics from Windows and Linux virtual machines. These metrics are collected from the guest operating system and are useful for monitoring the performance of the virtual machine. The metrics are collected at 15 second intervals and are stored in the Azure Monitor Log Analytics workspace. The metrics are collected by the Azure Monitor agent and are not dependent on the virtual machine being connected to the internet.

For more information on how to collect data from a virtual machine using  Azure Monitor agent, see [Collect performance counters with Azure Monitor Agent](../agents/data-collection-performance.md).

## Performance counters

The following performance counters are collected by the Azure Monitor agent:

### [Windows virtual machines](#tab/windows)

###  Performance counters collected from Windows virtual machines

The following performance counters are collected by the Azure Monitor agent for Windows virtual machines:

| Metric                                                                 | Category | Interval | Unit            |
|------------------------------------------------------------------------|----------|----------|-----------------|
| \Processor Information(_Total)\% Processor Time                        | CPU      | PT1M     | Percent         |
| \Processor Information(_Total)\% Privileged Time                       | CPU      | PT1M     | Percent         |
| \Processor Information(_Total)\% User Time                             | CPU      | PT1M     | Percent         |
| \Processor Information(_Total)\Processor Frequency                     | CPU      | PT1M     | Count           |
| \System\Processes                                                      | CPU      | PT1M     | Count           |
| \Process(_Total)\Thread Count                                          | CPU      | PT1M     | Count           |
| \Process(_Total)\Handle Count                                          | CPU      | PT1M     | Count           |
| \System\System Up Time                                                 | CPU      | PT1M     | Count           |
| \System\Context Switches/sec                                           | CPU      | PT1M     | CountPerSecond  |
| \System\Processor Queue Length                                         | CPU      | PT1M     | Count           |
| \ASP.NET Applications(Total)\Requests/Sec                              | ASPNET   | PT1M     | Count           |
| \ASP.NET Applications(Total)\Sessions Active                           | ASPNET   | PT1M     | Count           |
| \ASP.NET Applications(Total)\Sessions Abandoned                        | ASPNET   | PT1M     | Count           |
| \ASP.NET Applications(Total)\Sessions Timed Out                        | ASPNET   | PT1M     | Count           |
| \ASP.NET Applications(Total)\Sessions Total                            | ASPNET   | PT1M     | Count           |
| \ASP.NET Applications(Total)\Transactions Aborted                      | ASPNET   | PT1M     | Count           |
| \ASP.NET Applications(Total)\Transactions Committed                    | ASPNET   | PT1M     | Count           |
| \ASP.NET Applications(Total)\Transactions Pending                      | ASPNET   | PT1M     | Count           |
| \ASP.NET Applications(Total)\Transactions Total                        | ASPNET   | PT1M     | Count           |
| \ASP.NET Applications(Total)\Transactions/Sec                          | ASPNET   | PT1M     | Count           |
| \ASP.NET Apps v4.0.30319(Total)\Anonymous Requests                     | ASPNET   | PT1M     | Count           |
| \ASP.NET Apps v4.0.30319(Total)\Anonymous Requests/Sec                 | ASPNET   | PT1M     | Count           |
| \ASP.NET Apps v4.0.30319(Total)\Cache Total Entries                    | ASPNET   | PT1M     | Count           |
| \ASP.NET Apps v4.0.30319(Total)\Cache Total Turnover Rate              | ASPNET   | PT1M     | Count           |
| \ASP.NET Apps v4.0.30319(Total)\Cache Total Hits                       | ASPNET   | PT1M     | Count           |
| \ASP.NET Apps v4.0.30319(Total)\Cache Total Misses                     | ASPNET   | PT1M     | Count           |
| \ASP.NET Apps v4.0.30319(Total)\Cache Total Hit Ratio                  | ASPNET   | PT1M     | Count           |
| \ASP.NET Apps v4.0.30319(Total)\Cache API Entries                      | ASPNET   | PT1M     | Count           |
| \ASP.NET Apps v4.0.30319(Total)\Cache API Turnover Rate                | ASPNET   | PT1M     | Count           |
| \ASP.NET Apps v4.0.30319(Total)\Cache API Hits                         | ASPNET   | PT1M     | Count           |
| \ASP.NET Apps v4.0.30319(Total)\Cache API Misses                       | ASPNET   | PT1M     | Count           |
| \ASP.NET Apps v4.0.30319(Total)\Cache API Hit Ratio                    | ASPNET   | PT1M     | Count           |
| \ASP.NET Apps v4.0.30319(Total)\Output Cache Entries                   | ASPNET   | PT1M     | Count           |
| \ASP.NET Apps v4.0.30319(Total)\Output Cache Turnover Rate             | ASPNET   | PT1M     | Count           |
| \ASP.NET Apps v4.0.30319(Total)\Output Cache Hits                      | ASPNET   | PT1M     | Count           |
| \ASP.NET Apps v4.0.30319(Total)\Output Cache Misses                    | ASPNET   | PT1M     | Count           |
| \ASP.NET Apps v4.0.30319(Total)\Output Cache Hit Ratio                 | ASPNET   | PT1M     | Count           |
| \ASP.NET Apps v4.0.30319(Total)\Compilations Total                     | ASPNET   | PT1M     | Count           |
| \ASP.NET Apps v4.0.30319(Total)\Debugging Requests                     | ASPNET   | PT1M     | Count           |
| \ASP.NET Apps v4.0.30319(Total)\Errors During Preprocessing            | ASPNET   | PT1M     | Count           |
| \ASP.NET Apps v4.0.30319(Total)\Errors During Compilation              | ASPNET   | PT1M     | Count           |
| \ASP.NET Apps v4.0.30319(Total)\Errors During Execution                | ASPNET   | PT1M     | Count           |
| \ASP.NET Apps v4.0.30319(Total)\Errors Unhandled During Execution      | ASPNET   | PT1M     | Count           |
| \ASP.NET Apps v4.0.30319(Total)\Errors Unhandled During Execution/Sec  | ASPNET   | PT1M     | Count           |
| \ASP.NET Apps v4.0.30319(Total)\Errors Total                           | ASPNET   | PT1M     | Count           |
| \ASP.NET Apps v4.0.30319(Total)\Errors Total/Sec                       | ASPNET   | PT1M     | Count           |
| \ASP.NET Apps v4.0.30319(Total)\Pipeline Instance Count                | ASPNET   | PT1M     | Count           |
| \ASP.NET Apps v4.0.30319(Total)\Request Bytes In Total                 | ASPNET   | PT1M     | Count           |
| \ASP.NET Apps v4.0.30319(Total)\Request Bytes Out Total                | ASPNET   | PT1M     | Count           |
| \ASP.NET Apps v4.0.30319(Total)\Requests Executing                     | ASPNET   | PT1M     | Count           |
| \ASP.NET Apps v4.0.30319(Total)\Requests Failed                        | ASPNET   | PT1M     | Count           |
| \ASP.NET Apps v4.0.30319(Total)\Requests Not Found                     | ASPNET   | PT1M     | Count           |
| \ASP.NET Apps v4.0.30319(Total)\Requests Not Authorized                | ASPNET   | PT1M     | Count           |
| \ASP.NET Apps v4.0.30319(Total)\Requests In Application Queue          | ASPNET   | PT1M     | Count           |
| \ASP.NET Apps v4.0.30319(Total)\Requests Timed Out                     | ASPNET   | PT1M     | Count           |
| \ASP.NET Apps v4.0.30319(Total)\Requests Succeeded                     | ASPNET   | PT1M     | Count           |
| \ASP.NET Apps v4.0.30319(Total)\Requests Total                         | ASPNET   | PT1M     | Count           |
| \ASP.NET Apps v4.0.30319(Total)\Requests/Sec                           | ASPNET   | PT1M     | Count           |
| \Process(w3wp)\% Processor Time                                        | ASPNET   | PT1M     | Count           |
| \Process(w3wp)\Virtual Bytes                                           | ASPNET   | PT1M     | Count           |
| \Process(w3wp)\Private Bytes                                           | ASPNET   | PT1M     | Count           |
| \Process(w3wp)\Thread Count                                            | ASPNET   | PT1M     | Count           |
| \Process(w3wp)\Handle Count                                            | ASPNET   | PT1M     | Count           |
| \Web Service(_Total)\Bytes Total/sec                                   | ASPNET   | PT1M     | Count           |
| \Web Service(_Total)\Current Connections                               | ASPNET   | PT1M     | Count           |
| \Web Service(_Total)\Total Method Requests/sec                         | ASPNET   | PT1M     | Count           |
| \Web Service(_Total)\ISAPI Extension Requests/sec                      | ASPNET   | PT1M     | Count           |
| \SQLServer:Buffer Manager\Page reads/sec                               | SQLSERVER| PT1M     | Count           |
| \SQLServer:Buffer Manager\Page writes/sec                              | SQLSERVER| PT1M     | Count           |
| \SQLServer:Buffer Manager\Checkpoint pages/sec                         | SQLSERVER| PT1M     | Count           |
| \SQLServer:Buffer Manager\Lazy writes/sec                              | SQLSERVER| PT1M     | Count           |
| \SQLServer:Buffer Manager\Buffer cache hit ratio                       | SQLSERVER| PT1M     | Count           |
| \SQLServer:Buffer Manager\Database pages                               | SQLSERVER| PT1M     | Count           |
| \SQLServer:Memory Manager\Total Server Memory (KB)                     | SQLSERVER| PT1M     | Count           |
| \SQLServer:Memory Manager\Memory Grants Pending                        | SQLSERVER| PT1M     | Count           |
| \SQLServer:General Statistics\User Connections                         | SQLSERVER| PT1M     | Count           |
| \SQLServer:SQL Statistics\Batch Requests/sec                           | SQLSERVER| PT1M     | Count           |
| \SQLServer:SQL Statistics\SQL Compilations/sec                         | SQLSERVER| PT1M     | Count           |
| \SQLServer:SQL Statistics\SQL Re-Compilations/sec                      | SQLSERVER| PT1M     | Count           |


### [Windows virtual machines](#tab/linux)

###  Performance counters collected from Linux virtual machines

The following performance counters are collected by the Azure Monitor agent for Linux virtual machines:


| Metric                                      | Description               | Interval | Unit            |
|---------------------------------------------|---------------------------|----------|-----------------|
| /builtin/disk/averagediskqueuelength        | Disk queue length         | PT15S    | Count           |
| /builtin/disk/averagereadtime               | Disk read time            | PT15S    | Seconds         |
| /builtin/disk/averagetransfertime           | Disk transfer time        | PT15S    | Seconds         |
| /builtin/disk/averagewritetime              | Disk write time           | PT15S    | Seconds         |
| /builtin/disk/bytespersecond                | Disk total bytes          | PT15S    | BytesPerSecond  |
| /builtin/disk/readbytespersecond            | Disk read guest OS        | PT15S    | BytesPerSecond  |
| /builtin/disk/readspersecond                | Disk reads                | PT15S    | CountPerSecond  |
| /builtin/disk/transferspersecond            | Disk transfers            | PT15S    | CountPerSecond  |
| /builtin/disk/writebytespersecond           | Disk write guest OS       | PT15S    | BytesPerSecond  |
| /builtin/disk/writespersecond               | Disk writes               | PT15S    | CountPerSecond  |
| /builtin/filesystem/bytespersecond          | Filesystem bytes/sec      | PT15S    | BytesPerSecond  |
| /builtin/filesystem/bytesreadpersecond      | Filesystem read bytes/sec | PT15S    | CountPerSecond  |
| /builtin/filesystem/byteswrittenpersecond   | Filesystem write bytes/sec| PT15S    | CountPerSecond  |
| /builtin/filesystem/freespace               | Filesystem free space     | PT15S    | Bytes           |
| /builtin/filesystem/percentfreeinodes       | Filesystem % free inodes  | PT15S    | Percent         |
| /builtin/filesystem/percentfreespace        | Filesystem % free space   | PT15S    | Percent         |
| /builtin/filesystem/percentusedinodes       | Filesystem % used inodes  | PT15S    | Percent         |
| /builtin/filesystem/percentusedspace        | Filesystem % used space   | PT15S    | Percent         |
| /builtin/filesystem/readspersecond          | Filesystem reads/sec      | PT15S    | CountPerSecond  |
| /builtin/filesystem/transferspersecond      | Filesystem transfers/sec  | PT15S    | CountPerSecond  |
| /builtin/filesystem/usedspace               | Filesystem used space     | PT15S    | Bytes           |
| /builtin/filesystem/writespersecond         | Filesystem writes/sec     | PT15S    | CountPerSecond  |
| /builtin/memory/availablememory             | Memory available          | PT15S    | Bytes           |
| /builtin/memory/availableswap               | Swap available            | PT15S    | Bytes           |
| /builtin/memory/pagespersec                 | Pages                     | PT15S    | CountPerSecond  |
| /builtin/memory/pagesreadpersec             | Page reads                | PT15S    | CountPerSecond  |
| /builtin/memory/pageswrittenpersec          | Page writes               | PT15S    | CountPerSecond  |
| /builtin/memory/percentavailablememory      | Mem. percent available    | PT15S    | Percent         |
| /builtin/memory/percentavailableswap        | Swap percent available    | PT15S    | Percent         |
| /builtin/memory/percentusedmemory           | Memory percentage         | PT15S    | Percent         |
| /builtin/memory/percentusedswap             | Swap percent used         | PT15S    | Percent         |
| /builtin/memory/usedmemory                  | Memory used               | PT15S    | Bytes           |
| /builtin/memory/usedswap                    | Swap used                 | PT15S    | Bytes           |
| /builtin/network/bytesreceived              | Network in guest OS       | PT15S    | Bytes           |
| /builtin/network/bytestotal                 | Network total bytes       | PT15S    | Bytes           |
| /builtin/network/bytestransmitted           | Network out guest OS      | PT15S    | Bytes           |
| /builtin/network/packetsreceived            | Packets received          | PT15S    | Count           |
| /builtin/network/packetstransmitted         | Packets sent              | PT15S    | Count           |
| /builtin/network/totalcollisions            | Network collisions        | PT15S    | Count           |
| /builtin/network/totalrxerrors              | Packets received errors   | PT15S    | Count           |
| /builtin/network/totaltxerrors              | Packets sent errors       | PT15S    | Count           |
| /builtin/processor/percentidletime          | CPU idle time             | PT15S    | Percent         |
| /builtin/processor/percentinterrupttime     | CPU interrupt time        | PT15S    | Percent         |
| /builtin/processor/percentiowaittime        | CPU IO wait time          | PT15S    | Percent         |
| /builtin/processor/percentnicetime          | CPU nice time             | PT15S    | Percent         |
| /builtin/processor/percentprivilegedtime    | CPU privileged time       | PT15S    | Percent         |
| /builtin/processor/percentprocessortime     | CPU percentage guest OS   | PT15S    | Percent         |

