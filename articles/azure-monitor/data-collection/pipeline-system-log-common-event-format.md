---
title: Collect Syslog and CEF with Azure Monitor pipeline
description: Learn how Azure Monitor pipeline receives, processes, and routes Syslog and Common Event Format data.
ai-usage: ai-assisted
ms.topic: concept-article
ms.date: 11/23/2026
---

# Collect Syslog and CEF with Azure Monitor pipeline

Azure Monitor pipeline receives Syslog from network devices, applications, Linux hosts, and other senders that support standard network-based logging. Common Event Format (CEF) messages use the same Syslog receiver.

## Support

| Source | Input | Azure Monitor destination | Status |
|:---|:---|:---|:---|
| Syslog | RFC 3164 or RFC 5424 over TCP or UDP | `Syslog` or a custom table in a Log Analytics workspace | Generally available |
| CEF | CEF messages over Syslog | `CommonSecurityLog` in a Microsoft Sentinel-enabled Log Analytics workspace | Generally available |

Syslog and CEF are supported when the pipeline runs on Arc-enabled Kubernetes, a Linux VM in Azure, or an Arc-enabled Linux server. See [Support and availability](./pipeline-support.md) for deployment-platform status and requirements.

## Configure collection

For Arc-enabled Kubernetes, use DCR-based configuration for all new deployments:

- [Collect Syslog over UDP](./pipeline-configure-cli.md#deploy-the-arm-template).
- [Collect Syslog over TLS](./pipeline-configure-cli.md#example-collect-syslog-over-tls).
- [Collect CEF into Microsoft Sentinel](./pipeline-configure-cli.md#collect-cef-into-microsoft-sentinel).

For a Linux VM or Arc-enabled Linux server, see [Configure Azure Monitor pipeline on Linux VMs](./pipeline-configure-vm.md).

Use UDP only on trusted networks because it doesn't encrypt telemetry. For encrypted TCP ingestion, see [Gateway and TLS](./pipeline-security.md).

## Process data

Pipeline KQL transformations can filter, reshape, or aggregate Syslog and CEF before the data is sent to Azure Monitor. See [Transformations](./pipeline-transformations.md) and [Aggregation and filtering](./pipeline-filter-aggregate.md).
