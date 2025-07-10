---
title: Query map data from VM Insights
description: VM Insights solution collects metrics and log data to and this article describes the records and includes sample queries.
ms.topic: how-to
ms.date: 10/29/2024
---

# Query map data from VM Insights

> [!IMPORTANT]
>  The Dependency Agent and the Map experience in VM Insights will be retired on 30 June 2028. See [our retirement guidance](https://aka.ms/DependencyAgentRetirement) for more details.
> 
When you [enable processes and dependencies](vminsights-enable-portal.md#enable-vm-insights-using-the-azure-portal), in VM insights, computer and process inventory data is collected to support the map feature. In addition to analyzing this data with the map, you can query it directly with Log Analytics. This article describes the available data and provides sample queries.

VM Insights collects performance and connection metrics, computer and process inventory data, and health state information and forwards it to the Log Analytics workspace in Azure Monitor. This data is available for [query](../logs/log-query-overview.md) in Azure Monitor. You can apply this data to scenarios that include migration planning, capacity analysis, discovery, and on-demand performance troubleshooting.

> [!NOTE]
> You must have processes and dependencies enabled for VM insights for the tables discussed in this article to be created.

## Map records

One record is generated per hour for each unique computer and process in addition to the records that are generated when a process or computer starts or is added to VM Insights. The fields and values in the [VMComputer](../reference/tables/vmcomputer.md) table map to fields of the Machine resource in the ServiceMap Azure Resource Manager API. The fields and values in the [VMProcess](../reference/tables/vmprocess.md) table map to the fields of the Process resource in the ServiceMap Azure Resource Manager API. The `_ResourceId` field matches the name field in the corresponding Resource Manager resource.

There are internally generated properties you can use to identify unique processes and computers:

* Computer: Use *_ResourceId* to uniquely identify a computer in a Log Analytics workspace.
* Process: Use *_ResourceId* to uniquely identify a process in a Log Analytics workspace.

Because multiple records can exist for a specified process and computer in a specified time range, queries can return more than one record for the same computer or process. To include only the most recent record, add `| summarize arg_max(TimeGenerated, *) by ResourceId` to the query.

## Connections and ports

[VMConnection](../reference/tables/vmconnection.md) and [VMBoundPort](../reference/tables/vmboundport.md) provide information about the connections for a machine (inbound and outbound) and the server ports that are open/active on them. Connection metrics are also exposed via APIs that provide the means to obtain a specific metric during a time window. TCP connections resulting from *accepting* on a listening socket are inbound, while connections created by *connecting* to a given IP and port are outbound. The `Direction` property represents the direction of a connection, which can be set to either `inbound` or `outbound`.

Records in these tables are generated from data reported by the Dependency Agent. Every record represents an observation over a 1-minute time interval. The `TimeGenerated` property indicates the start of the time interval. Each record contains information to identify the respective entity, that is, connection or port, and metrics associated with that entity. Currently, only network activity that occurs using TCP over IPv4 is reported.

To manage cost and complexity, connection records don't represent individual physical network connections. Multiple physical network connections are grouped into a logical connection, which is then reflected in the respective table. Meaning, records in `VMConnection` table represent a logical grouping and not the individual physical connections that are being observed. Physical network connection sharing the same value for the following attributes during a given one-minute interval, are aggregated into a single logical record in `VMConnection`.

## Metrics

[VMConnection](../reference/tables/vmconnection.md) and [VMBoundPort](../reference/tables/vmboundport.md) include metric data with  information about the volume of data sent and received on a given logical connection or network port (`BytesSent`, `BytesReceived`). Also included is the response time, which is how long caller waits for a request sent over a connection to be processed and responded to by the remote endpoint (`ResponseTimeMax`, `ResponseTimeMin`, `ResponseTimeSum`). The response time reported is an estimation of the true response time of the underlying application protocol. It's computed using heuristics based on the observation of the flow of data between the source and destination end of a physical network connection. Conceptually, it's the difference between the time the last byte of a request leaves the sender, and the time when the last byte of the response arrives back to it. These two timestamps are used to delineate request and response events on a given physical connection. The difference between them represents the response time of a single request.

This algorithm is an approximation that may work with varying degree of success depending on the actual application protocol used for a given network connection. For example, the current approach works well for request-response based protocols such as HTTP(S), but doesn't work with one-way or message queue-based protocols.

Some important points to consider include:

1. If a process accepts connections on the same IP address but over multiple network interfaces, a separate record for each interface is reported.
1. Records with wildcard IP contain no activity. They're included to represent the fact that a port on the machine is open to inbound traffic.
1. To reduce verbosity and data volume, records with wildcard IP are omitted when there's a matching record (for the same process, port, and protocol) with a specific IP address. When a wildcard IP record is omitted, the `IsWildcardBind` record property with the specific IP address is set to `True` to indicate that the port is exposed over every interface of the reporting machine.
1. Ports that are bound only on a specific interface have `IsWildcardBind` set to `False`.

## Naming and Classification

For convenience, the IP address of the remote end of a connection is included in the `RemoteIp` property. For inbound connections, `RemoteIp` is the same as `SourceIp`, while for outbound connections, it's the same as `DestinationIp`. The `RemoteDnsCanonicalNames` property represents the DNS canonical names reported by the machine for `RemoteIp`. The `RemoteDnsQuestions` property represents the DNS questions reported by the machine for `RemoteIp`. The `RemoveClassification` property is reserved for future use.

## Malicious IP

Every `RemoteIp` property in the `VMConnection` table is checked against a set of IPs with known malicious activity. If the `RemoteIp` is identified as malicious, the following properties are populated. If the IP isn't considered malicious, the properties are empty. 

- `MaliciousIp`
- `IndicatorThreadType`
- `Description`
- `TLPLevel` 
- `Confidence`
- `Severity`
- `FirstReportedDateTime` 
- `LastReportedDateTime`
- `IsActive`
- `ReportReferenceLink` 
- `AdditionalInformation`


## Sample map queries

**List all known machines**

```kusto
VMComputer | summarize arg_max(TimeGenerated, *) by _ResourceId
```

**When was the VM last rebooted**

```kusto
let Today = now(); VMComputer | extend DaysSinceBoot = Today - BootTime | summarize by Computer, DaysSinceBoot, BootTime | sort by BootTime asc
```

**Summary of Azure VMs by image, location, and SKU**

```kusto
VMComputer | where AzureLocation != "" | summarize by Computer, AzureImageOffering, AzureLocation, AzureImageSku
```

**List the physical memory capacity of all managed computers**

```kusto
VMComputer | summarize arg_max(TimeGenerated, *) by _ResourceId | project PhysicalMemoryMB, Computer
```

**List computer name, DNS, IP, and OS**

```kusto
VMComputer | summarize arg_max(TimeGenerated, *) by _ResourceId | project Computer, OperatingSystemFullName, DnsNames, Ipv4Addresses
```

**Find all processes with "sql" in the command line**

```kusto
VMProcess | where CommandLine contains_cs "sql" | summarize arg_max(TimeGenerated, *) by _ResourceId
```

**Find a machine (most recent record) by resource name**

```kusto
search in (VMComputer) "m-4b9c93f9-bc37-46df-b43c-899ba829e07b" | summarize arg_max(TimeGenerated, *) by _ResourceId
```

**Find a machine (most recent record) by IP address**

```kusto
search in (VMComputer) "10.229.243.232" | summarize arg_max(TimeGenerated, *) by _ResourceId
```

**List all known processes on a specified machine**

```kusto
VMProcess | where Machine == "m-559dbcd8-3130-454d-8d1d-f624e57961bc" | summarize arg_max(TimeGenerated, *) by _ResourceId
```

**List all computers running SQL Server**

```kusto
VMComputer | where AzureResourceName in ((search in (VMProcess) "*sql*" | distinct Machine)) | distinct Computer
```

**List all unique product versions of curl in my datacenter**

```kusto
VMProcess | where ExecutableName == "curl" | distinct ProductVersion
```

**Bytes sent and received trends**

```kusto
VMConnection | summarize sum(BytesSent), sum(BytesReceived) by bin(TimeGenerated,1hr), Computer | order by Computer desc | render timechart
```

**Which Azure VMs are transmitting the most bytes**

```kusto
VMConnection | join kind=fullouter(VMComputer) on $left.Computer == $right.Computer | summarize count(BytesSent) by Computer, AzureVMSize | sort by count_BytesSent desc
```

**Link status trends**

```kusto
VMConnection | where TimeGenerated >= ago(24hr) | where Computer == "acme-demo" | summarize dcount(LinksEstablished), dcount(LinksLive), dcount(LinksFailed), dcount(LinksTerminated) by bin(TimeGenerated, 1h) | render timechart
```

**Connection failures trend**

```kusto
VMConnection | where Computer == "acme-demo" | extend bythehour = datetime_part("hour", TimeGenerated) | project bythehour, LinksFailed | summarize failCount = count() by bythehour | sort by bythehour asc | render timechart
```

**Bound Ports**

```kusto
VMBoundPort
| where TimeGenerated >= ago(24hr)
| where Computer == 'admdemo-appsvr'
| distinct Port, ProcessName
```

**Number of open ports across machines**

```kusto
VMBoundPort
| where Ip != "127.0.0.1"
| summarize by Computer, Machine, Port, Protocol
| summarize OpenPorts=count() by Computer, Machine
| order by OpenPorts desc
```

**Score processes in your workspace by the number of ports they have open**

```kusto
VMBoundPort
| where Ip != "127.0.0.1"
| summarize by ProcessName, Port, Protocol
| summarize OpenPorts=count() by ProcessName
| order by OpenPorts desc
```

**Aggregate behavior for each port**

This query can then be used to score ports by activity, for example, ports with most inbound/outbound traffic or ports with most connections.

```kusto
VMBoundPort
| where Ip != "127.0.0.1"
| summarize BytesSent=sum(BytesSent), BytesReceived=sum(BytesReceived), LinksEstablished=sum(LinksEstablished), LinksTerminated=sum(LinksTerminated), arg_max(TimeGenerated, LinksLive) by Machine, Computer, ProcessName, Ip, Port, IsWildcardBind
| project-away TimeGenerated
| order by Machine, Computer, Port, Ip, ProcessName
```

**Summarize the outbound connections from a group of machines**

```kusto
// the machines of interest
let machines = datatable(m: string) ["m-82412a7a-6a32-45a9-a8d6-538354224a25"];
// map of ip to monitored machine in the environment
let ips=materialize(VMComputer
| summarize ips=makeset(todynamic(Ipv4Addresses)) by MonitoredMachine=AzureResourceName
| mvexpand ips to typeof(string));
// all connections to/from the machines of interest
let out=materialize(VMConnection
| where Machine in (machines)
| summarize arg_max(TimeGenerated, *) by ConnectionId);
// connections to localhost augmented with RemoteMachine
let local=out
| where RemoteIp startswith "127."
| project ConnectionId, Direction, Machine, Process, ProcessName, SourceIp, DestinationIp, DestinationPort, Protocol, RemoteIp, RemoteMachine=Machine;
// connections not to localhost augmented with RemoteMachine
let remote=materialize(out
| where RemoteIp !startswith "127."
| join kind=leftouter (ips) on $left.RemoteIp == $right.ips
| summarize by ConnectionId, Direction, Machine, Process, ProcessName, SourceIp, DestinationIp, DestinationPort, Protocol, RemoteIp, RemoteMachine=MonitoredMachine);
// the remote machines to/from which we have connections
let remoteMachines = remote | summarize by RemoteMachine;
// all augmented connections
(local)
| union (remote)
//Take all outbound records but only inbound records that come from either //unmonitored machines or monitored machines not in the set for which we are computing dependencies.
| where Direction == 'outbound' or (Direction == 'inbound' and RemoteMachine !in (machines))
| summarize by ConnectionId, Direction, Machine, Process, ProcessName, SourceIp, DestinationIp, DestinationPort, Protocol, RemoteIp, RemoteMachine
// identify the remote port
| extend RemotePort=iff(Direction == 'outbound', DestinationPort, 0)
// construct the join key we'll use to find a matching port
| extend JoinKey=strcat_delim(':', RemoteMachine, RemoteIp, RemotePort, Protocol)
// find a matching port
| join kind=leftouter (VMBoundPort 
| where Machine in (remoteMachines) 
| summarize arg_max(TimeGenerated, *) by PortId 
| extend JoinKey=strcat_delim(':', Machine, Ip, Port, Protocol)) on JoinKey
// aggregate the remote information
| summarize Remote=makeset(iff(isempty(RemoteMachine), todynamic('{}'), pack('Machine', RemoteMachine, 'Process', Process1, 'ProcessName', ProcessName1))) by ConnectionId, Direction, Machine, Process, ProcessName, SourceIp, DestinationIp, DestinationPort, Protocol
```

## Next steps

* Get started with writing log queries in Azure Monitor by reviewing [how to use Log Analytics](../logs/log-analytics-tutorial.md).
* Learn more about [writing search queries](../logs/get-started-queries.md).
