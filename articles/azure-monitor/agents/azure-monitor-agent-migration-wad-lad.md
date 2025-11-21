---
title: Migrate to Azure Monitor Agent from Azure Diagnostic extensions (WAD/LAD)
description: Guidance for migrating to Azure Monitor Agent from WAD/LAD agents
ms.topic: concept-article
ms.date: 11/11/2025

# Customer intent: As an azure administrator, I want to understand the process of migrating from the WAD/LAD agents agent to the AMA agent.

---

# Migrate to Azure Monitor Agent from Azure Diagnostic extensions (WAD/LAD)

The Azure Diagnostics extensions (WAD/LAD) are on a deprecation path and will retire on **March 31, 2026**. Read the full migration guidance [here](./diagnostics-extension-overview.md#migration-guidance).  
As one of the migration options, customers can migrate to [Azure Monitor Agent (AMA)](./agents-overview.md) configured with [Data Collection Rules (DCRs)](./data-collection-rule-overview.md) to continue collecting guest OS logs and performance data and to unlock multi-destination routing, centralized and more secure configuration, and at-scale management. **Note**: DCRs provide transformations (ingestion-time filtering, parsing) to reduce cost and tailor schemas—something not available in WAD/LAD.

## Comparison of WAD/LAD agents and AMA

| Area | WAD/LAD | AMA |
|------|---------|-----|
| Status | Legacy; retiring March 31, 2026 | Current and strategic agent |
| Config model | XML/JSON/WAD, LAD schema | Centralized DCRs in Azure, also providing transformations (ingestion-time filtering, parsing) to reduce cost and tailor schemas |
| Security | Storage keys, classic auth patterns | Azure Managed Identity based access; modern TLS endpoints | 
| Network | Per extension outbound | Standardized endpoints/service tags for AMA and DCEs |


## Migration Steps

### Phase 1: Discover & assess
i) Inventory machines running WAD/LAD
-   For per-VM view in Azure portal, navigate to **Extensions + applications** tab.
-   For fleet view, use Azure Resource Graph query from the [WAD/LAD overview article](./diagnostics-extension-overview.md) to find extensions by publisher == "Microsoft.Azure.Diagnostics". [learn.microsoft.com]

ii) Extract current diagnostics config - Gather WAD public config XML (Windows) and LAD JSON (Linux) to list counters, events, syslog facilities/severities, file paths, transfer schedules, and destinations. 

iii) Prioritize what to keep / drop - Use this moment to reduce noise and unused data types, if any. With DCR transformations, you can additionally [filter to essential signals](../data-collection/data-collection-rule-overview.md#transformations).

### Phase 2: Design DCRs
Create DCRs that replicate the WAD/LAD intent:

- [Standard VM data sources](../vm/data-collection.md#add-data-sources) like Windows events (e.g., System, Application, Security), Linux syslog, performance counters. 
- [Custom text logs](../vm/data-collection-log-text.md) (same file paths wildcards; ensure custom tables exist; often requires a DCE) sent to low-cost [Auxiliary tier](../logs/data-platform-logs.md#table-plans) in Log Analytics. [learn.microsoft.com]
- [ADX-destination routing] (../vm/send-fabric-destination.md#create-a-data-collection-ruledocs.azure.cn)

**Note**: Keep Windows and Linux in separate DCRs to avoid accidental counter duplication (same metric from both naming styles).

### Phase 3: Deploy AMA and assign DCRs at scale
i) Prepare prerequisites for [AMA installation](./azure-monitor-agent-requirements.md) and [DCR association](../data-collection/data-collection-rule-create-edit.md#permissions), including verifying [supported OS], [network settings](./azure-monitor-agent-network-configuration.md) 
ii) Ensure you have Log Analytics workspace setup with [Auxiliary tier](../logs/data-platform-logs.md#table-plans) as needed.
iii) (Recommended) Use Azure Policy [built‑in initiatives to install AMA](./azure-monitor-agent-policy.md) on Windows/Linux and associate DCRs. Using policy ensures new machines are auto-onboarded and existing machines are remediated, aligning to the migration best practices.

### Phase 4: Validate

- Agent health: Confirm AzureMonitorWindowsAgent / AzureMonitorLinuxAgent extension status is **Provisioning succeeded”=** on VMs.
- Data flow:
  - Logs: Query in Log Analytics workspace (e.g., Event, Syslog, custom table) as per the DCR data source.
  - Perf counters to Metrics: switch VM Metrics blade to the Virtual machine guest namespace to see counters via AMA-to-Metrics routing.

### Phase 5: Remove WAD/LAD
- Coordinate a cutover window per environment (Dev → Test → Prod).
- Stop/Remove the Microsoft.Azure.Diagnostics extension from each VM after AMA data parity is confirmed; this is explicitly recommended to avoid double ingestion and extra costs.

## Common Troubleshooting tips
- **Agent installed but no service visible on Windows**: AMA runs under an extension model/process; verify via VM Extensions blade and DCR association rather than looking for an “Azure Monitor Agent” service.
- **No data from custom logs**: Confirm custom table exists, DCE configured (where required), file patterns are correct, and the record delimiter/time format matches your files.
- **Firewall/proxy blocked**: Validate outbound 443 to the control, DCR, ODS, and DCE ingest endpoints; HTTPS inspection must be disabled.
