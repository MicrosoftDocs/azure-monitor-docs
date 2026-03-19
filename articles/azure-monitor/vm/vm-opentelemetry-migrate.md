---
title: Migrate from logs-based to OpenTelemetry metrics for Azure virtual machines
description: Learn how to migrate your Azure virtual machines from the classic logs-based monitoring experience to the OpenTelemetry-based metrics experience in Azure Monitor.
ai-usage: ai-assisted
ms.topic: how-to
ms.date: 03/12/2026
ms.reviewer: xpathak
---

# Migrate from logs-based to OpenTelemetry metrics for Azure virtual machines

The [metrics-based experience](./metrics-opentelemetry-guest.md) should be your default monitoring option for virtual machines in Azure Monitor since it's provided at no cost. If you already have the older logs-based experience enabled, the next decision is whether you need keep it enabled and when you can retire it. Since the logs-based experience includes cost for data ingestion and retention, you want to retire it as soon as possible to optimize costs. This article helps you make that decision and walks through the migration process when can retire the logs-based experience.

> [!NOTE]
> The metrics-based experience is currently in public preview.

## Considerations

- **Data retention**: Removing the logs-based DCR association stops new data collection but doesn't delete historical data in your Log Analytics workspace. Historical data remains available according to your workspace retention settings.
- **Cost optimization**: The default metrics-based experience is free. Retiring the logs-based experience can reduce Log Analytics ingestion costs.
- **Azure Monitor agent**: You don't need to reinstall or update the Azure Monitor agent. The same agent handles both logs-based and OpenTelemetry metrics collection using different DCRs.
- **Run both experiences temporarily if needed**: Keep both experiences enabled only long enough to validate replacement queries and dashboards.

## When to keep the logs-based experience

Keep the logs-based experience enabled if any of the following are still true:

- You need to monitor VM Scale Sets.
- You rely on the built-in multi-VM dashboards and workbooks in VM insights.
- You need to correlate metrics and logs in a single KQL query.
- You still use queries, alerts, dashboards, or workbooks that depend on the `InsightsMetrics` table.

If none of these apply, you can retire the logs-based experience and keep the metrics-based experience enabled.

## Before you retire the logs-based experience

Before you retire the logs-based experience, confirm the following:

- Metrics-based monitoring is already enabled for each VM.
- The metrics-based experience shows the performance data that you need.
- You don't need the built-in multi-VM experience.
- Any KQL queries, alerts, dashboards, or workbooks that use `InsightsMetrics` have been updated, retired, or replaced.

## Migration process

Use the following process to retire the logs-based experience:

1. Confirm that metrics-based monitoring is already enabled.
1. Validate that the metrics-based experience meets your monitoring requirements.
1. Update or retire dependencies on `InsightsMetrics`.
1. Remove the logs-based DCR association.

## Confirm that metrics-based monitoring is enabled

This article doesn't cover initial setup. If you haven't enabled metrics-based monitoring yet, use one of these articles first:

- [Enable VM monitoring in Azure Monitor](./vm-enable-monitoring.md)
- [Tutorial: Enable enhanced monitoring for an Azure virtual machine](./tutorial-vm-enable-monitoring.md)

After setup, return to this article to decide whether you can retire logs-based collection.

## Validate the metrics-based experience

Before you remove logs-based collection, verify that the metrics-based experience provides the data you need.

1. Go to the VM in the Azure portal and select **Monitor**.
1. Select the metrics-based experience in the experience selector.
1. Confirm that the performance charts show data.
1. If needed, go to the Azure Monitor workspace and verify that metrics such as `system.cpu.time` and `system.memory.usage` are available.

## Update dependencies

Before you remove the logs-based DCR association, update or retire dependencies on logs-based metrics.

### Update queries

Queries must change from KQL against Log Analytics to PromQL against the Azure Monitor workspace.

**Logs-based KQL query example:**

```kusto
InsightsMetrics
| where TimeGenerated > ago(1h)
| where Namespace == "Processor" and Name == "UtilizationPercentage"
| summarize avg(Val) by bin(TimeGenerated, 5m)
```

### Update alerts, dashboards, and workbooks

- Identify alert rules, dashboards, and workbooks that query the `InsightsMetrics` table.
- Replace them with PromQL-based queries against the Azure Monitor workspace where needed.
- Validate the updated artifacts before you stop logs-based collection.

## Remove the logs-based DCR association

After you update dependencies, remove the logs-based DCR association to stop new logs-based metric collection and reduce Log Analytics ingestion costs. The logs-based DCR typically has a name such as `MSVMI-<workspace-name>`.

### [Azure portal](#tab/portal)

1. In the Azure portal, go to **Monitor** > **Data Collection Rules**.
1. Select the **Resources** tab.
1. Find your VM.
1. Select the number in the **Data collection rules** column.
1. Identify the logs-based DCR. It typically has a name that starts with `MSVMI-`.
1. Select the DCR, and then select **Delete association**.
1. Confirm the deletion.

### [Azure CLI](#tab/cli)

1. List the DCR associations for your VM and identify the logs-based DCR:

```azurecli
az monitor data-collection rule association list \
  --resource "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Compute/virtualMachines/<vm-name>" \
  --output table
```

2. Remove the logs-based DCR association:

```azurecli
dcraName=$(az monitor data-collection rule association list \
  --resource "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Compute/virtualMachines/<vm-name>" \
  --query "[?contains(dataCollectionRuleId, 'MSVMI')].name" \
  --output tsv)

az monitor data-collection rule association delete \
  --resource "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Compute/virtualMachines/<vm-name>" \
  --name "$dcraName"
```

### [PowerShell](#tab/powershell)

1. List the DCR associations for your VM and identify the logs-based DCR:

```powershell
Get-AzDataCollectionRuleAssociation `
  -TargetResourceId "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Compute/virtualMachines/<vm-name>"
```

2. Remove the logs-based DCR association:

```powershell
$dcraName = (Get-AzDataCollectionRuleAssociation `
  -TargetResourceId "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Compute/virtualMachines/<vm-name>" |
  Where-Object { $_.DataCollectionRuleId -like "*MSVMI*" }).Name

Remove-AzDataCollectionRuleAssociation `
  -TargetResourceId "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Compute/virtualMachines/<vm-name>" `
  -AssociationName $dcraName
```

---



## Rollback

If you need to resume the logs-based experience:

1. Recreate the association between the VM and the logs-based DCR.
1. Confirm that the expected `InsightsMetrics` data is flowing again.
1. Remove the metrics-based DCR association if you no longer need it.

For more information about VM monitoring configuration, see [Enable VM monitoring in Azure Monitor](./vm-enable-monitoring.md).

## Remove the VM insights solution

After you remove the logs-based experience from all VMs that use the workspace, you can remove the VM insights solution from that Log Analytics workspace. Do this only when no VMs still depend on the logs-based experience.

For the steps, see [Remove VM insights solution](./vm-disable-monitoring.md#remove-vm-insights-solution).

## Next steps

- [Customize OpenTelemetry metric collection](./vminsights-opentelemetry.md)
- [OpenTelemetry metrics reference](./metrics-guest-reference.md)
- [Query Prometheus metrics using Azure Monitor](../essentials/prometheus-api-promql.md)
- [Disable monitoring of your VMs](./vminsights-optout.md)
