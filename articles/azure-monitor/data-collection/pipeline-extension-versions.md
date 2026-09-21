---
title: Azure Monitor pipeline extension versions
description: Extension versions and release notes for Azure Monitor pipeline. 
ms.topic: how-to
ms.date: 09/21/2026
ms.custom: references_regions, devx-track-azurecli
---

# Azure Monitor pipeline extension versions

This article describes the version details for the Azure Monitor pipeline Arc-enabled Kubernetes extension. This extension deploys the pipeline on Arc-enabled Kubernetes clusters in your on-premises, edge, hybrid, or multicloud environments.

- The team releases pipeline versions once each month. If there are any critical bug fixes or security patches, the team might release additional hotfix versions.
- The latest version rolls out over a fortnight, and you might see it in some regions before others.
- You can manually install the release once it's available in your region.

## Version details

### Version 1.7.0 - September 16, 2026

- **Improved support for restricted clusters** — the operator now runs as a non-root user, allowing installation on clusters that enforce the Kubernetes Pod Security `restricted` profile, including Tanzu environments.
- **Complete Syslog receive counts in pipeline monitoring** — the **Logs accepted (preview)** and **Logs rejected (preview)** metrics now count records from Syslog receivers even when no `allowedFormats` filter is configured. Previously, those receivers could omit receive counts, making the metrics appear lower than the actual traffic. See [Monitor pipeline health and performance](./pipeline-troubleshoot.md#monitor-pipeline-health-and-performance).
- **Built-in diagnostic collection** — added a diagnostic script to the `azure-monitor-pipeline-forensics` ConfigMap so it can be retrieved directly from a running cluster.
- **Security and reliability improvements** — updated the pipeline runtime, Azure Linux base image, and supporting dependencies.

### Version 1.6.1 - August 26, 2026

> [!IMPORTANT]
> Self-monitoring metric names changed in this release. Update queries, alerts, dashboards, and workbooks that use `exporter_sent_log_records` or `exporter_send_failed_log_records`. Use `exported_log_records` and `log_records_failed_to_export` instead.

- **Expanded pipeline self-monitoring** — added preview metrics for accepted and rejected logs, export results, records awaiting export, processor activity, processing duration, persistent-storage utilization, and records dropped from persistent storage.
- **Fewer unnecessary rollouts** — stabilized generated configuration when multiple Syslog receivers are present, preventing unchanged pipeline groups from restarting.
- **Security and reliability improvements** — updated the pipeline runtime, collector authentication components, Azure Linux base image, and supporting dependencies.

### Version 1.5.2 - August 4, 2026

> [!WARNING]
> When upgrading from a version earlier than 1.5, data currently stored in a durable buffer is orphaned by a storage-path change and isn't forwarded. This affects only pipelines with durable buffering enabled. Allow the durable buffer to drain before upgrading.

- **Improved error-log visibility** — error records now identify the affected pipeline component and emitting event. This release also fixes an issue that prevented some delivered error logs from appearing in `AzureMonitorPipelineLogErrors`.
- **Reliable durable buffering with multiple replicas** — each collector replica now uses a separate location on shared persistent storage, preventing replicas from conflicting over buffered data.
- **Improved Syslog filtering reliability** — fixed a crash that could occur when applying format filters to Syslog data.
- **Security and reliability improvements** — updated the Go runtime, pipeline image, and Azure Linux base image.

### Version 1.4.0 - June 24, 2026

- **Requests identify the originating pipeline** — API header now includes information identifying the pipeline extension, version, and platform, making outgoing requests easier to trace.
- **Improved overflow handling** — when the on-disk buffer is full, the pipeline now drops the oldest persisted data (first-in, first-out) instead of applying backpressure to incoming data.

### Version 1.3.0 - May 27, 2026

- **Clearer error messages** for unsupported pipeline components, making issues faster to diagnose.
- **Improved Tanzu support** with a deployment reliability fix.
- **ARM64 and multi-architecture support** added to the pipeline image.
- **Security:** Updated the Go runtime to the latest patched version.

*Note: An internal telemetry library update in this release has no impact on customer-facing metrics.*

### Version 1.2.0 - May 13, 2026

- **ARM64 production support** via multi-architecture packaging.
- **Reduced log noise** from Azure Monitor exporter heartbeat failures.
- **More detailed error messages** — rate-limit and server errors now include the response body.
- **Lower network usage** during deployments by reusing already-present container images.
- **Improved performance** in the durable buffering layer.
- **KQL alignment:** `substring` now matches the documented specification.
- **Bug fixes:** Reliable multi-architecture image publishing and consistent build versioning.

### Version v1.1.1 - April 2026 (General Availability)
- Added pipeline self-monitoring with metrics (CPU utilization, memory usage, process uptime, exported logs, failed log exports) enabled by default, and resource logs available when diagnostic settings are configured. See [Monitor pipeline health and performance](./pipeline-troubleshoot.md#monitor-pipeline-health-and-performance).
- Added ARM64 (aarch64) support, enabling deployment on a wider range of infrastructure environments.
- Stability, performance, and security improvements for general availability.

### Version v0.158.0 - Mar 2026 (Preview)
- Added change to install and enable the `microsoft.extensiondiagnostics` extension for collection of Microsoft-internal telemetry, such as usage, diagnostic, and performance data to operate, secure, and improve Azure Monitor pipeline. This extension might create additional pods in the `azure-arc` namespace.
- Fixed all known security vulnerabilities and compliance issues.

### Version v0.157.0 - Feb 2026 (Preview)
- Added **support for TLS and mutual TLS (mTLS)** for TCP‑based ingestion endpoints, improving security and compliance. [Learn more](./pipeline-tls.md).
> [!WARNING]
> If you update from an existing installation, this change is **breaking** as it now requires the installation of the Certificate Manager extension and gateway. Without these components, the update or deployment fails.
> See the [updated prerequisites](./pipeline-configure.md#prerequisites) for how to install the additional components. You can also [disable the default TLS, mTLS configuration](./pipeline-tls.md#option-3-disable-tls-and-mtls).
- Fixed an issue where `RemoteIP` and `RemotePort` fields were incorrectly swapped during Common Event Format (CEF) log processing.
- Updated the underlying Azure Linux base image to the latest compliant version.

### Version v0.155.0 - Jan 2026 (Preview)
- Added support for pre-ingestion, KQL‑based data transformations in preview, so you can **filter, reshape, and aggregate logs** (via portal or ARM templates) by using built‑in syntax and schema validation to optimize costs and ensure clean, standardized data. [Learn more](./pipeline-transformations.md).
- Added support for sending **Syslog to Log Analytics standard tables**, by using built-in schematization for raw Syslog events.
- Added support for sending Syslog in Common Event Format (CEF) to the Log Analytics standard table **CommonSecurityLog** used for Microsoft Sentinel, by using built-in schematization for raw events.
- Improved Syslog normalization by correctly mapping Syslog `SeverityText` into the expected Log Analytics schema.
- Fixed collector crash scenarios when multiple OTLP receivers were configured.
- Moved pipeline images to Azure Linux Core 3.0 as Mariner 2.0 reached deprecation.
- Added support for [new regions](./pipeline-overview.md#supported-configurations).
- Fixed all known security and compliance issues.

## Related articles

- Learn about the service in [What is Azure Monitor pipeline?](./pipeline-overview.md)
- Set up the service in [Configure Azure Monitor pipeline](./pipeline-configure.md)
- Secure ingestion by using [Azure Monitor pipeline TLS configuration](./pipeline-tls.md)
