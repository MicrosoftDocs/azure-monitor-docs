---
title: Migrate to Azure Monitor Agent from Azure Diagnostic extensions (WAD/LAD)
description: Guidance for migrating to Azure Monitor Agent from WAD/LAD agents
ms.topic: concept-article
ms.date: 11/11/2025

# Customer intent: As an azure administrator, I want to understand the process of migrating from the WAD/LAD agents agent to the AMA agent.

---

# Migrate to Azure Monitor Agent from Azure Diagnostic extensions (WAD/LAD)

The Azure Diagnostics extensions (WAD/LAD) are on a deprecation path and will retire on **March 31, 2026**. Read the full migration guidance [here](./diagnostics-extension-overview#migration-guidance).  
As one of the migration options, customers can migrate to [Azure Monitor Agent (AMA)](./agents-overview.md) configured with [Data Collection Rules (DCRs)](./data-collection-rule-overview) to continue collecting guest OS logs and performance data and to unlock multi-destination routing, centralized and more secure configuration, and at-scale management.

## Comparison of WAD/LAD agents and AMA

| Area | WAD/LAD | AMA |
|------|---------|-----|
| Status | Legacy; retiring March 31, 2026 | Current and strategic agent |
| Config model | XML/JSON/WAD, LAD schema | Centralized DCRs in Azure |
| Security | Storage keys, classic auth patterns | Azure Managed Identity based access; modern TLS endpoints | 
| Network | Per extension outbound | Standardized endpoints/service tags for AMA and DCEs |

## 
