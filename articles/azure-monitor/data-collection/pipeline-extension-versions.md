---
title: Azure Monitor pipeline extension versions
description: Extension versions and release notes for Azure Monitor pipeline. 
ms.topic: how-to
ms.date: 02/06/2026
ms.custom: references_regions, devx-track-azurecli
---

# Azure Monitor pipeline extension versions
This article describes the version details for the Azure Monitor pipeline Arc-enabled Kubernetes extension. This extension deploys the pipeline on Arc-enabled Kubernetes clusters in your on premise, edge, hybrid or multicloud environments.

- Pipeline versions release once each month. If there are any critical bug fixes or security patches, additional hotfix releases can happen.
- The latest version deploys over a fortnight, and you might see it in some regions before others.
- You can manually install the release once it is in a VMs region.

## Version details

### Version v0.155.0 - Jan 2026
- Added support for pre-ingestion, KQL‑based data transformations in preview, letting you **filter, reshape, and aggregate logs** (via portal or ARM templates) with built‑in syntax/schema validation to optimize costs and ensure clean, standardized data. [Learn more](./pipeline-transformations.md)
- Added support for sending **Syslog to Log Analytics standard tables**, using built-in schematization for raw syslog events
- Added support for sending Syslog in Common Event Format (CEF) to Log Analytics standard table **CommonSecurityLog** used for Sentinel, using built-in schematization for raw events
- Improved Syslog normalization by correctly mapping Syslog `SeverityText` into the expected Log Analytics schema
- Fixed collector crash scenarios when multiple OTLP receivers were configured
- Moved pipeline images to Azure Linux Core 3.0 as Mariner 2.0 reached deprecation
- Critical security and compliance fixes
