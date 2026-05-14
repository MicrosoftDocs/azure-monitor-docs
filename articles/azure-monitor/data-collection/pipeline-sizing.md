---
title: Azure Monitor pipeline performance and sizing
description: Learn how to size Azure Monitor pipeline for your throughput requirements, including measured baselines across node sizes, scaling strategies, and capacity planning examples.
ai-usage: ai-assisted
ms.topic: best-practice
ms.date: 05/14/2026
ms.custom: references_regions

#customer intent: As a cloud architect or operations engineer, I want to understand Azure Monitor pipeline throughput and how to size a deployment so that I can allocate the right cluster resources for my expected log volume.
---

# Azure Monitor pipeline performance and sizing

Azure Monitor pipeline delivers high-throughput log ingestion on minimal infrastructure. A single pipeline replica on a commodity 8-core node sustains **~200,000 syslog messages per second end-to-end into Log Analytics** — roughly **17 billion events or ~20 TB per day** — while consuming only **~2.8 GB of working-set memory**. Throughput scales linearly with CPU cores and replicas, so capacity planning reduces to picking a per-vCPU rate and a replica count. Scale vertically with larger nodes, horizontally with more replicas, or both. When overloaded, the pipeline backpressures senders rather than dropping data.

> [!NOTE]
> The performance data in this article was collected using pipeline version [v0.159](./pipeline-extension-versions.md#version-v01580---mar-2026-preview) in May 2026 with TCP transport, ~1.2 KB payloads, and TLS disabled. Your results might vary based on payload size, TLS configuration, network latency, and cluster workload.

## Pipeline types tested

Three pipeline configurations were tested, each representing a different level of processing:

- **Syslog Basic.** No auto-schematization. The pipeline exports the syslog message to a custom Log Analytics table with three columns: `TimeGenerated`, `Body` (the full syslog message as-is), and `SeverityText`.

- **Syslog Fully Formed.** Auto-schematization of the syslog message. The pipeline parses the message and maps it into the standard [Syslog](/azure/azure-monitor/reference/tables/syslog) table schema with structured columns: `EventTime`, `Facility`, `SeverityLevel`, `Computer`, `HostName`, `HostIP`, `ProcessName`, `ProcessID`, `SyslogMessage`, and others.

- **CEF Fully Formed.** Auto-schematization of the syslog message and the CEF payload. The pipeline parses and maps into the standard [CommonSecurityLog](/azure/azure-monitor/reference/tables/commonsecuritylog) table schema with 90+ columns: `DeviceVendor`, `DeviceProduct`, `Activity`, `SourceIP`, `DestinationIP`, `DeviceAction`, `Protocol`, `RequestURL`, and many more.

The throughput difference between pipeline types reflects the schematization cost. Syslog Basic passes data through without mapping fields, while Syslog Fully Formed and CEF Fully Formed parse and map fields into their respective standard table schemas.

## Measured throughput

All values are from a single replica under sustained full load, measured end-to-end into a Log Analytics workspace. Each message has randomized fields (IPs, ports, session IDs) to reflect realistic payloads. Values are rounded to reflect run-to-run variance (±5–10%).

| vCPUs | Example node | Syslog Basic | Syslog Fully Formed | CEF Fully Formed |
|:---|:---|:---|:---|:---|
| 2 | `Standard_D2as_v6` | ~50,000/sec | ~35,000/sec | ~17,000/sec |
| 4 | `Standard_D4as_v6` | ~100,000/sec | ~70,000/sec | ~35,000/sec |
| 8 | `Standard_D8as_v6` | ~200,000/sec | ~150,000/sec | ~65,000/sec |
| 16 | `Standard_D16as_v6` | ~400,000/sec | ~300,000/sec | ~130,000/sec |

The pipeline automatically uses all available CPU cores. No configuration changes are needed when you move to a larger node.

> [!IMPORTANT]
> Ensure senders open **at least as many concurrent TCP connections as there are CPU cores** on the pipeline node. The pipeline distributes incoming traffic across cores by source connection, so too few connections leave cores idle. More connections improve distribution.

## Capacity planning

### Per-vCPU baselines

Throughput and memory scale linearly with CPU cores. The per-vCPU rates are consistent across node sizes, which makes them the simplest starting point for capacity planning.

| Pipeline type | Per-vCPU throughput | Per-vCPU memory (at saturation) |
|:---|:---|:---|
| Syslog Basic | ~25,000 logs/sec | ~330 MB |
| Syslog Fully Formed | ~18,000 logs/sec | ~350 MB |
| CEF Fully Formed | ~8,000 logs/sec | ~300 MB |

At idle (no traffic), a pipeline replica uses approximately **150 MB** regardless of node size.

To estimate total memory for a saturated replica, use: `150 MB + per-vCPU memory × vCPUs`. For example, a Syslog Basic replica on an 8-core node needs approximately 150 + 330 × 8 = ~2.8 GB.

For example, 8 total cores — deployed as 1 × 8-core or 2 × 4-core — yield approximately the same Syslog Basic throughput (~200,000 logs/sec) and consume approximately the same total memory (~2.8 GB).

### Horizontal scaling

Adding replicas scales throughput linearly. These values are measured on 4-core nodes, with each replica running on a dedicated node.

| Pipeline type | 1 replica | 2 replicas | 4 replicas | 8 replicas |
|:---|:---|:---|:---|:---|
| Syslog Basic | ~100,000/sec | ~200,000/sec | ~400,000/sec | ~800,000/sec |
| Syslog Fully Formed | ~70,000/sec | ~140,000/sec | ~280,000/sec | ~560,000/sec |
| CEF Fully Formed | ~35,000/sec | ~70,000/sec | ~140,000/sec | ~280,000/sec |

> [!IMPORTANT]
> Run each pipeline replica on its own node. Co-locating replicas on the same node causes CPU contention and affects throughput.

### Size for a target throughput

To calculate the resources you need:

1. Identify your pipeline type — the per-vCPU rate varies significantly (Syslog Basic is ~3x faster than CEF Fully Formed due to schematization cost). Look up the rate from the [baselines table](#per-vcpu-baselines).
1. Divide your peak logs/sec by the per-vCPU rate.
1. Add 30% headroom and round up to get total vCPUs.
1. Distribute those vCPUs across replicas (one per node).

#### Worked example: Syslog Basic at 400,000 messages/sec

1. Per-vCPU rate: **25,000/sec**
1. Base vCPUs: 400,000 ÷ 25,000 = 16
1. With 30% headroom: 16 × 1.3 = **21 vCPUs**
1. Deploy as 6 replicas on 4-core nodes or 3 replicas on 8-core nodes

#### Quick reference

| Pipeline type | Peak target | vCPUs needed (with 30% headroom) | Example deployment |
|:---|:---|:---|:---|
| Syslog Basic | 400,000/sec | 21 | 6 replicas on 4-core nodes or 3 replicas on 8-core nodes |
| Syslog Fully Formed | 200,000/sec | 15 | 4 replicas on 4-core nodes or 2 replicas on 8-core nodes |
| CEF Fully Formed | 100,000/sec | 17 | 5 replicas on 4-core nodes or 3 replicas on 8-core nodes |

## Overload behavior

When incoming traffic exceeds pipeline capacity, the pipeline applies **TCP backpressure** to senders rather than dropping messages. If you observe sender-side slowdowns or increasing send latency, that's the backpressure signal indicating you need to scale up (more cores per node) or scale out (more replicas).

## Factors that might affect throughput

The baselines in this article are measured under controlled conditions. The following factors might affect throughput in your environment:

- **TLS/mTLS.** Current tests run with TLS disabled. Enabling TLS adds encryption overhead per connection.
- **Durable buffering.** Current tests run without disk-backed buffers. Enabling durable buffers adds disk I/O overhead but improves reliability during connectivity gaps.
- **Network latency to Log Analytics.** Tests ran on an AKS cluster in Azure with low-latency connectivity. Edge or on-premises deployments with higher network latency to Azure might see reduced effective throughput.
- **Variable payloads.** The baselines use ~1.2 KB messages. Real-world traffic with variable message sizes and formats might affect parsing throughput.
- **Additional KQL transformations.** The baselines already include the cost of syslog/CEF parsing. Adding extra KQL transformations before export adds further processing overhead per message.
- **External ingress (gateway).** Sending traffic through a gateway like Traefik adds network hops and potential TLS termination overhead compared to in-cluster delivery.

## Test setup

- **Nodes tested**: `Standard_D2as_v6` (2 vCPU, 8 GB), `Standard_D4as_v6` (4 vCPU, 16 GB), `Standard_D8as_v6` (8 vCPU, 32 GB), `Standard_D16as_v6` (16 vCPU, 64 GB)
- **Transport**: TCP
- **Payload**: RFC 5424 formatted syslog messages, ~1.2 KB each, with randomized fields (IPs, ports, session IDs, counters) per message. Syslog Basic and Syslog Fully Formed use a generic (non-CEF) message body. CEF Fully Formed uses a CEF-formatted message body.
- The load generator runs in the same cluster on separate nodes. For single-replica vertical tests it uses minimal resources; for multi-replica horizontal tests, multiple load-generator pods run on dedicated nodes to fully saturate the pipeline.
- Each test run scrapes the pipeline's internal Prometheus metrics to measure exact receive and export counts, and queries Log Analytics to verify end-to-end delivery. Pipeline received = exported = Log Analytics received.
- Memory figures are **working set** as reported by `kubectl top pods`.

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

## Related articles

- [What is Azure Monitor pipeline?](./pipeline-overview.md)
- [Configure Azure Monitor pipeline](./pipeline-configure.md)
- [Azure Monitor pipeline extension versions](./pipeline-extension-versions.md)
- [Pod placement](./pipeline-pod-placement.md)
