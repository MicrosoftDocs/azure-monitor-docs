---
title: Azure Monitor pipeline extension versions
description: Extension versions and release notes for Azure Monitor pipeline. 
ms.topic: how-to
ms.date: 02/06/2026
ms.custom: references_regions, devx-track-azurecli
---

# Azure Monitor pipeline extension versions
This article describes the version details for the Azure Monitor pipeline Arc-enabled Kubernetes extension. This extension deploys the pipeline on Arc-enabled Kubernetes clusters in your on-premise, edge, hybrid or multicloud environments.

- Pipeline versions release once each month.
- The latest version deploys over a fortnight, and you might see it in some regions before others.
- You can manually install the release once it is in a VMs region.

## Version details

### Version v0.155.0 - Jan 2026
- Added support for pre-ingestion, KQL‑based data transformations, letting you **filter, reshape, and aggregate logs** (via portal or ARM templates) with built‑in syntax/schema validation to optimize costs and ensure clean, standardized data. [Learn more](./pipeline-transformations.md)
- Fixed mapping of Syslog `SeverityText` values to expected values in Log Analytics standard tables.
- Critical security and compliance fixes
