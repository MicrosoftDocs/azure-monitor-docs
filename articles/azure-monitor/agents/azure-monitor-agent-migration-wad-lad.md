---
title: Migrate to Azure Monitor Agent from Azure Diagnostic extensions (WAD/LAD)
description: Guidance for migrating to Azure Monitor Agent from WAD/LAD agents
ms.topic: concept-article
ms.date: 11/11/2025
# Customer intent: As an azure administrator, I want to understand the process of migrating from the WAD/LAD agents agent to the AMA agent.
---

# Migrate to Azure Monitor Agent from Azure Diagnostic extensions (WAD/LAD)

The Azure Diagnostics extensions (WAD/LAD) are deprecated and retire on **March 31, 2026**. For full migration guidance, see [here](./diagnostics-extension-overview.md#migration-guidance).  
As a migration option, you can migrate to [Azure Monitor Agent (AMA)](./agents-overview.md). It gets configured with [Data Collection Rules (DCRs)](./data-collection-rule-overview.md) to continue collecting guest OS logs and performance data. It allows multi-destination routing, centralized, a more secure configuration, and at-scale management.

> [!NOTE]
> DCRs provide transformations (ingestion-time filtering, parsing) to reduce cost and tailor schemas - something not available in WAD/LAD.

## Comparison of WAD/LAD agents and AMA

| Area | WAD/LAD | AMA |
|------|---------|-----|
| Status | Legacy; retiring March 31, 2026 | Current and strategic agent |
| Config model | XML/JSON/WAD, LAD schema | Centralized DCRs in Azure, also providing transformations (ingestion-time filtering, parsing) to reduce cost and tailor schemas |
| Security | Storage keys, classic auth patterns | Azure Managed Identity based access; modern Transport Layer Security (TLS) endpoints | 
| Network | Per extension outbound | Standardized endpoints/service tags for AMA and data collection endpoints (DCEs) |

## Migration steps

Use the following phased approach to migrate from WAD/LAD to AMA with DCRs.

### Phase 1: Discover and assess

1. Inventory machines running WAD/LAD
   1. For per-VM view in Azure portal, navigate to **Extensions + applications** tab.
   1. For fleet view, use Azure Resource Graph query from the [WAD/LAD overview article](./diagnostics-extension-overview.md) to find extensions by publisher == `Microsoft.Azure.Diagnostics`.

3. Extract current diagnostics config - Gather WAD public config XML (Windows) and LAD JSON (Linux) to list counters, events, syslog facilities/severities, file paths, transfer schedules, and destinations. 

4. Prioritize what to keep or drop - Use this moment to reduce noise and unused data types, if any. By using DCR transformations, you can additionally [filter to essential signals](../data-collection/data-collection-rule-overview.md#transformations).

### Phase 2: Design DCRs

1. Create DCRs that replicate the WAD/LAD intent:
   1. [Standard VM data sources](../vm/data-collection.md#add-data-sources) like Windows events (for example, System, Application, Security), Linux syslog, performance counters.
   1. [Custom text logs](../vm/data-collection-log-text.md) (same file path wildcards; ensure custom tables exist; often requires a DCE) sent to low-cost [Auxiliary tier](../logs/data-platform-logs.md#table-plans) in Log Analytics.
   1. [ADX-destination routing](../vm/send-fabric-destination.md#create-a-data-collection-rule).

> [!NOTE]
> Keep Windows and Linux in separate DCRs to avoid accidental counter duplication (same metric from both naming styles).

### Phase 3: Deploy AMA and assign DCRs at scale

1. Prepare prerequisites for [AMA installation](./azure-monitor-agent-requirements.md) and [DCR association](../data-collection/data-collection-rule-create-edit.md#permissions), including verifying [supported OS](./azure-monitor-agent-supported-operating-systems.md) and [network settings](./azure-monitor-agent-network-configuration.md). 
2. Ensure you have Log Analytics workspace setup with [Auxiliary tier](../logs/data-platform-logs.md#table-plans) as needed.
1. (Recommended) Use Azure Policy [built‑in initiatives to install AMA](./azure-monitor-agent-policy.md) on Windows and Linux and associate DCRs. By using policy, you auto-onboard new machines and remediate existing machines, aligning to the migration best practices.

### Phase 4: Validate

1. Agent health: Confirm AzureMonitorWindowsAgent and AzureMonitorLinuxAgent extension status is **Provisioning succeeded** on VMs.
2. Data flow:
   1. Logs: Query in Log Analytics workspace (for example, Event, Syslog, custom table) as per the DCR data source.
   1. Performance counters to Metrics: switch to the VM Metrics view to the Virtual machine guest namespace to see counters via AMA-to-Metrics routing.

### Phase 5: Remove WAD/LAD

1. Coordinate a cutover window per environment (Dev → Test → Production).
1. Stop or remove the Microsoft.Azure.Diagnostics extension from each VM after AMA data parity is confirmed. This step is explicitly recommended to avoid double ingestion and extra costs.

## Common troubleshooting tips

- **Agent installed but no service visible on Windows**: AMA runs under an extension model and process. Verify the agent through the VM Extensions area and DCR association rather than looking for an "Azure Monitor Agent" service.
- **No data from custom logs**: Confirm the custom table exists, DCE is configured (where required), file patterns are correct, and the record delimiter and time format matches your files.
- **Firewall or proxy blocked**: Validate outbound port 443 to the control, DCR, ODS, and DCE ingest endpoints. You must disable HTTPS inspection.
