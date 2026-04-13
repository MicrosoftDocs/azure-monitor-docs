---
title: Best practices for sizing Azure Monitor pipeline
description: Learn how to size Azure Monitor pipeline for your throughput requirements, including per-vCPU baselines, scaling strategies, and capacity planning examples.
ai-usage: ai-assisted
ms.topic: best-practice
ms.date: 03/25/2026
ms.custom: references_regions

#customer intent: As a cloud architect or operations engineer, I want to understand how to size an Azure Monitor pipeline deployment so that I can allocate the right cluster resources for my expected log volume.
---

# Best practices for sizing Azure Monitor pipeline

The Azure Monitor pipeline is CPU-bound and scales linearly with available cores. This article provides throughput baselines, scaling strategies, and capacity planning examples to help you size a pipeline deployment for your environment.

Use these baselines alongside the [Azure Monitor pipeline overview](./pipeline-overview.md) and [Configure Azure Monitor pipeline](./pipeline-configure.md) to plan your deployment.

> [!NOTE]
> The performance data in this article was collected using pipeline version [v0.158](./pipeline-extension-versions.md#version-v01580---mar-2026-preview) in March 2026 with TCP transport, ~1.2 KB payloads, and TLS disabled. Your results might vary based on payload size, TLS configuration, and cluster workload.

## Pipeline Types Tested

Three pipeline configurations were tested, each representing a different level of processing:

- **Syslog Basic** — Minimal processing. The raw syslog message is passed through to a custom Log Analytics table with just 3 columns: `TimeGenerated`, `Body` (the full syslog message as-is), and `SeverityText`. No parsing of the syslog header or payload.

- **Syslog Fully Formed** — The pipeline parses the RFC 5424 syslog header and maps it into the standard [Syslog](/azure/azure-monitor/reference/tables/syslog) table schema with structured columns: `EventTime`, `Facility`, `SeverityLevel`, `Computer`, `HostName`, `HostIP`, `ProcessName`, `ProcessID`, `SyslogMessage`, etc.

- **CEF Fully Formed** — The pipeline parses both the syslog header and the CEF payload inside it, mapping into the standard [CommonSecurityLog](/azure/azure-monitor/reference/tables/commonsecuritylog) table schema with 90+ columns: `DeviceVendor`, `DeviceProduct`, `Activity`, `SourceIP`, `DestinationIP`, `DeviceAction`, `Protocol`, `RequestURL`, and many more.

## Measured Throughput

All numbers are from a single replica under sustained full load for 5 minutes, averaged across 3 consecutive runs. Each message has randomized fields (IPs, ports, session IDs, etc.) to reflect realistic payloads.

**4-core node** (`Standard_D4as_v6`):

| Pipeline type       | Throughput         | Peak memory |
| ------------------- | ------------------ | ----------- |
| Syslog Basic        | **75K logs/sec**   | 782 MB      |
| Syslog Fully Formed | **53K logs/sec**   | 427 MB      |
| CEF Fully Formed    | **23K logs/sec**   | 254 MB      |

The pipeline automatically uses all available CPU cores on the node. No configuration changes are needed when scaling.

## Capacity Planning

Since throughput scales linearly with CPU, the per-vCPU rate is the simplest way to estimate capacity for any node size:

| Pipeline type       | Per-vCPU throughput |
| ------------------- | ------------------- |
| Syslog Basic        | **~19K logs/sec**   |
| Syslog Fully Formed | **~13K logs/sec**   |
| CEF Fully Formed    | **~6K logs/sec**    |

Multiply by cores per node to get per-replica throughput. Add 20–30% buffer for production workloads. To scale beyond a single node, add more replicas — each replica handles traffic independently.

## Per-vCPU throughput baselines

The pipeline scales linearly with CPU cores. Per-vCPU throughput is consistent across node sizes, which makes it the best starting point for capacity planning.

| Pipeline type | Per-vCPU throughput | Memory per vCPU (working set) |
|:---|:---|:---|
| Syslog Basic (passthrough to custom table) | ~32,000 logs/sec | ~250 MB |
| Syslog Fully Formed (parsed into standard Syslog table) | ~8,000 logs/sec | ~200 MB |
| CEF Fully Formed (parsed into standard CommonSecurityLog table) | ~6,500 logs/sec | ~150 MB |

The difference between pipeline types reflects the parsing cost. Syslog Basic passes data through with minimal processing, while Syslog Fully Formed and CEF Fully Formed parse and map fields to their respective standard table schemas.

## Scale vertically, horizontally, or both

To handle more load, use nodes with more CPU cores (vertical scaling), add more pipeline replicas (horizontal scaling), or combine both approaches. All three approaches yield linear throughput increases.

The pipeline automatically uses all available CPU cores per node. You don't need to make any configuration changes when you change node sizes.

**Per-replica throughput** = per-vCPU throughput x cores per node  
**Total throughput** = per-replica throughput x replica count

| Pipeline type | Node | Replicas | Total throughput | Total memory (working set) |
|:---|:---|:---|:---|:---|
| Syslog Basic | 4-core | 1 | 128,000 logs/sec | ~1 GB |
| Syslog Basic | 8-core | 1 | 256,000 logs/sec | ~1.8 GB |
| Syslog Basic | 8-core | 2 | 512,000 logs/sec | ~3.6 GB |
| Syslog Fully Formed | 4-core | 1 | 32,000 logs/sec | ~0.6 GB |
| Syslog Fully Formed | 8-core | 1 | 64,000 logs/sec | ~1.7 GB |
| Syslog Fully Formed | 8-core | 2 | 128,000 logs/sec | ~3.4 GB |
| CEF Fully Formed | 4-core | 1 | 28,000 logs/sec | ~0.5 GB |
| CEF Fully Formed | 8-core | 1 | 56,000 logs/sec | ~1.2 GB |
| CEF Fully Formed | 8-core | 2 | 112,000 logs/sec | ~2.4 GB |

## Plan capacity for a target throughput

Calculate the resources you need for a target throughput by using these three steps:

1. **Per-replica throughput** = per-vCPU throughput × cores available per node.
1. **Replicas needed** = target throughput / per-replica throughput (round up).
1. **Memory per replica** = memory per vCPU × cores available per node.

Add 20-30% buffer to your resource allocation for production workloads. Each replica handles traffic independently, so running more replicas also improves fault tolerance.

### Example: Syslog Basic at 500,000 logs/sec

Per-vCPU throughput for Syslog Basic: ~32,000 logs/sec.

| Node size | Per-replica throughput | Replicas needed | Total CPU | Total memory |
|:---|:---|:---|:---|:---|
| 4-core | 128,000 logs/sec | 4 | 16 cores | ~4 GB |
| 8-core | 256,000 logs/sec | 2 | 16 cores | ~4 GB |
| 16-core | 512,000 logs/sec | 1 | 16 cores | ~4 GB |

### Example: Syslog Fully Formed at 100,000 logs/sec

Per-vCPU throughput for Syslog Fully Formed: ~8,000 logs/sec.

| Node size | Per-replica throughput | Replicas needed | Total CPU | Total memory |
|:---|:---|:---|:---|:---|
| 4-core | 32,000 logs/sec | 4 | 16 cores | ~2.4 GB |
| 8-core | 64,000 logs/sec | 2 | 16 cores | ~3.2 GB |
| 16-core | 128,000 logs/sec | 1 | 16 cores | ~3.2 GB |

### Example: CEF Fully Formed at 100,000 logs/sec

Per-vCPU throughput for CEF Fully Formed: about 6,500 logs/sec.

| Node size | Per-replica throughput | Replicas needed | Total CPU | Total memory |
|:---|:---|:---|:---|:---|
| 4-core | 28,000 logs/sec | 4 | 16 cores | ~2.4 GB |
| 8-core | 56,000 logs/sec | 2 | 16 cores | ~2.4 GB |
| 16-core | 112,000 logs/sec | 1 | 16 cores | ~2.4 GB |

## Factors that might affect throughput

The baselines in this article are measured under controlled conditions. The following factors might reduce throughput in your environment and aren't yet reflected in the baselines:

- **External ingress (gateway)**: Sending traffic through a gateway like Traefik adds network hops and potential TLS termination overhead compared to in-cluster delivery.
- **TLS enabled**: Enabling TLS or mTLS adds encryption overhead per connection.
- **Variable payloads**: The baselines use identical ~1.2 KB messages. Real-world traffic with variable message sizes and formats might affect parsing throughput.
- **Durable buffering**: Enabling disk-backed buffers adds I/O overhead but improves reliability during connectivity gaps.
- **Transformations**: Complex KQL transformations applied to data before export add processing overhead per message.

## Test Setup

- **Node tested**: `Standard_D4as_v6` (4 vCPU, 16 GB)
- **Transport**: TCP
- **Payload**: RFC 5424 formatted syslog messages, ~1.2 KB each, with randomized fields (IPs, ports, session IDs, counters) per message. Syslog Basic and Syslog Fully Formed use a generic (non-CEF) message body. CEF Fully Formed uses a CEF-formatted message body.
- The load generator runs in the same cluster but uses minimal resources (< 2 cores, < 2 GB memory), so the cluster capacity is effectively dedicated to pipeline pods.
- Each test run scrapes the pipeline's internal Prometheus metrics to measure exact receive and export counts, and queries Log Analytics to verify end-to-end delivery. Pipeline received = exported = LA received (99.6–100%).
- Memory figures are **working set** as reported by `kubectl top pods`.
- Azure Monitor Pipeline config used is in [MyPipelineConfig.json](./MyPipelineConfig.json).

<details>
<summary>Sample syslog message (generic, used for Syslog Basic and Syslog Fully Formed)</summary>

```
<13>1 2026-04-03T15:30:00.000000Z loadgen-host ThreatDetection 1234 ID47 - NOTCEF: This is a generic syslog test message for performance benchmarking. source=loadgen action=test severity=info category=benchmark host=testhost process=loadgen pid=5678 user=testuser session=abc123 status=success duration=0 bytes_in=0 bytes_out=0 packets=0 protocol=tcp src_ip=192.168.1.100 dst_ip=10.0.0.1 src_port=44840 dst_port=514 message=Performance test log entry for throughput measurement XXXXXXXXXXXXXX...
```

</details>

<details>
<summary>Sample syslog message (CEF, used for CEF Fully Formed)</summary>

```
<13>1 2026-04-03T15:30:00.000000Z loadgen-host ThreatDetection 1234 ID47 - CEF:0|PaloAltoNetworks|PAN-OS|9.1.8|SSH2 Login Attempt(31914)|SSH2 Login Attempt(31914)|1|act=alert actionflags=0x2000000000000000 app=ssh cat=any cn1=67640598 cn2=1207111110 cnt=1 cs1=THREAT cs2=vulnerability cs3=Tap_Allow dst=172.21.166.15 dpt=22 src=172.21.76.92 spt=44840 proto=tcp dvchost=PA-820 ...
```

</details>


## Known Limitations

The following scenarios have not yet been measured and may affect throughput:

- **TLS**: Current tests run with TLS disabled. Enabling TLS will add encryption overhead.
- **Durable buffering**: Current tests run without disk-backed buffers. Enabling durable buffers adds disk I/O overhead but improves reliability.
- **UDP transport**: The load generator could not saturate the pipeline over UDP, so UDP throughput numbers are not yet available.
- **OTLP (gRPC)**: The load generator could not saturate the pipeline over OTLP either. Measured throughput was ≥29–33K logs/sec with pipeline CPU well below capacity.


## Related articles

- [What is Azure Monitor pipeline?](./pipeline-overview.md)
- [Configure Azure Monitor pipeline](./pipeline-configure.md)
- [Azure Monitor pipeline extension versions](./pipeline-extension-versions.md)
- [Pod placement](./pipeline-pod-placement.md)
