---
title: Azure Monitor pipeline extension versions
description: Extension versions and release notes for Azure Monitor pipeline. 
ms.topic: how-to
ms.date: 02/06/2026
ms.custom: references_regions, devx-track-azurecli
---

# Azure Monitor pipeline extension versions

This article describes the version details for the Azure Monitor pipeline Arc-enabled Kubernetes extension. This extension deploys the pipeline on Arc-enabled Kubernetes clusters in your on-premises, edge, hybrid, or multicloud environments.

- The team releases pipeline versions once each month. If there are any critical bug fixes or security patches, the team might release additional hotfix versions.
- The latest version rolls out over a fortnight, and you might see it in some regions before others.
- You can manually install the release once it's available in your region.

## Version details

### Version 1.3.0 - May 27, 2026

- **Clearer error messages** for unsupported pipeline components, making issues faster to diagnose.
- **Improved Tanzu support** with a deployment reliability fix.
- **ARM64 and multi-architecture support** added to the pipeline image.
- **Security:** Updated the Go runtime to the latest patched version.

*Note: An internal telemetry library update in this release has no impact on customer-facing metrics.*

---

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
