---
title: Azure Monitor pipeline extension versions
description: Extension versions and release notes for Azure Monitor pipeline. 
ms.topic: how-to
ms.date: 02/06/2026
ms.custom: references_regions, devx-track-azurecli
---

# Azure Monitor pipeline extension versions
This article describes the version details for the Azure Monitor pipeline Arc-enabled Kubernetes extension. This extension deploys the pipeline on Arc-enabled Kubernetes clusters in your on-premises, edge, hybrid or multicloud environments.

- Pipeline versions release once each month. If there are any critical bug fixes or security patches, additional hotfix releases can happen.
- The latest version deploys over a fortnight, and you might see it in some regions before others.
- You can manually install the release once it is in a VMs region.

## Version details

### Version v0.158.0 - Mar 2026 (Preview)
- Added change to install and enable the `microsoft.extensiondiagnostics` extension for collection of Microsoft-internal telemetry (e.g. usage, diagnostic, and performance data to operate, secure, and improve Azure Monitor pipeline). Additional pods may be created in the azure-arc namespace for this extension.
- Fixed all known security vulnerabilities and compliance issues.

### Version v0.157.0 - Feb 2026 (Preview)
- Added **support for TLS and mutual TLS (mTLS)** for TCP‑based ingestion endpoints, improving security and compliance. [Learn more](./pipeline-tls.md)
> [!WARNING]
> If updating from an existing installation, this is a **breaking change** as it now requires the installation of cert-manager extension and gateway. Without these components, the update/deployment will fail.
> See the [updated prerequisites](./pipeline-configure.md#prerequisites) for how to install the additional components. You can also [disable the default TLS, mTLS configuration](./pipeline-tls.md#option-3-disable-tls-and-mtls).
- Fixed an issue where `RemoteIP` and `RemotePort` fields were incorrectly swapped during Common Event Format (CEF) log processing.
- Updated the underlying Azure Linux base image to the latest compliant version

### Version v0.155.0 - Jan 2026 (Preview)
- Added support for pre-ingestion, KQL‑based data transformations in preview, letting you **filter, reshape, and aggregate logs** (via portal or ARM templates) with built‑in syntax/schema validation to optimize costs and ensure clean, standardized data. [Learn more](./pipeline-transformations.md)
- Added support for sending **Syslog to Log Analytics standard tables**, using built-in schematization for raw syslog events
- Added support for sending Syslog in Common Event Format (CEF) to Log Analytics standard table **CommonSecurityLog** used for Microsoft Sentinel, using built-in schematization for raw events
- Improved Syslog normalization by correctly mapping Syslog `SeverityText` into the expected Log Analytics schema
- Fixed collector crash scenarios when multiple OTLP receivers were configured
- Moved pipeline images to Azure Linux Core 3.0 as Mariner 2.0 reached deprecation
- Added support for [new regions](./pipeline-overview.md#supported-configurations)
- Fixed all known security and compliance issues
