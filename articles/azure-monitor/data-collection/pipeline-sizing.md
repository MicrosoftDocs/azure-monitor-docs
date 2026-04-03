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

The baselines in this article were measured under controlled conditions. The following factors might reduce throughput in your environment and aren't yet reflected in the baselines:

- **External ingress (gateway)**: Sending traffic through a gateway like Traefik adds network hops and potential TLS termination overhead compared to in-cluster delivery.
- **TLS enabled**: Enabling TLS or mTLS adds encryption overhead per connection.
- **Variable payloads**: The baselines use identical ~1.2 KB messages. Real-world traffic with variable message sizes and formats might affect parsing throughput.
- **Durable buffering**: Enabling disk-backed buffers adds I/O overhead but improves reliability during connectivity gaps.
- **Transformations**: Complex KQL transformations applied to data before export add processing overhead per message.

## Related articles

- [What is Azure Monitor pipeline?](./pipeline-overview.md)
- [Configure Azure Monitor pipeline](./pipeline-configure.md)
- [Azure Monitor pipeline extension versions](./pipeline-extension-versions.md)
- [Pod placement](./pipeline-pod-placement.md)
