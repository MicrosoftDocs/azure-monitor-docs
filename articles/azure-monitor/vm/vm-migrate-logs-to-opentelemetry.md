---
title: Migrate from logs-based to OpenTelemetry metrics for Azure virtual machines
description: Learn how to migrate your Azure virtual machines from the classic logs-based monitoring experience to the OpenTelemetry-based metrics experience in Azure Monitor.
ms.topic: how-to
ms.date: 03/12/2026
ms.reviewer: xpathak
---

# Migrate from logs-based to OpenTelemetry metrics for Azure virtual machines

This article provides step-by-step guidance for migrating your Azure virtual machines from the classic logs-based monitoring experience to the OpenTelemetry-based metrics experience. The OpenTelemetry experience provides faster queries, lower costs, and cross-platform consistency using open standards.

> [!NOTE]
> The OpenTelemetry metrics experience is currently in public preview.

## Before you begin

Before migrating, review the differences between the two experiences to understand what changes in your monitoring workflow.

### Key differences

| Aspect | Logs-based (classic) | OpenTelemetry-based |
|:---|:---|:---|
| **Storage** | Log Analytics workspace | Azure Monitor workspace |
| **Query language** | KQL (Kusto Query Language) | PromQL (Prometheus Query Language) |
| **Latency** | 1-3 minutes | Near real-time |
| **Cost** | Standard Log Analytics ingestion and retention | Optimized metrics storage |
| **Metric naming** | Platform-specific counters (different for Windows and Linux) | Consistent cross-platform OpenTelemetry naming |
| **Multi-VM views** | Full dashboards and workbooks | Currently limited |

For a complete comparison, see [Compare OpenTelemetry and logs-based experiences](./metrics-opentelemetry-guest.md#compare-opentelemetry-and-logs-based-experiences).

### Migration impact

Consider the following impacts before migrating:

- **Queries and alerts**: Existing KQL queries against the `InsightsMetrics` table won't work with OpenTelemetry metrics stored in Azure Monitor workspace. You need to create new PromQL queries.
- **Dashboards and workbooks**: Custom dashboards and workbooks that use the `InsightsMetrics` table require updates to query the Azure Monitor workspace.
- **Multi-VM views**: If you rely on the multi-VM performance views in the logs-based experience, these aren't currently available in the OpenTelemetry experience.
- **Correlating metrics and logs**: With logs-based collection, you can correlate metrics and logs in a single KQL query. With OpenTelemetry, metrics and logs are stored separately and require separate queries.

## Prerequisites

- An Azure virtual machine with the Azure Monitor agent installed.
- Permissions to create data collection rules and associate them with virtual machines.
- An Azure Monitor workspace for storing OpenTelemetry metrics. If you don't have one, it's created automatically when you enable monitoring. See [Create an Azure Monitor workspace](../metrics/azure-monitor-workspace-manage.md#create-an-azure-monitor-workspace).
- If you plan to keep collecting logs, ensure you have a Log Analytics workspace configured.

## Migration process overview

The migration involves these steps:

1. [Enable OpenTelemetry-based metrics collection](#enable-opentelemetry-based-metrics)
2. [Validate data collection in Azure Monitor workspace](#validate-data-collection)
3. [Remove logs-based DCR association](#remove-logs-based-dcr-association)
4. [Update queries, alerts, and dashboards](#update-queries-alerts-and-dashboards)

## Enable OpenTelemetry-based metrics

You can enable OpenTelemetry metrics collection alongside your existing logs-based collection. This approach lets you validate the new experience before removing the old one.

### [Azure portal](#tab/portal)

1. In the Azure portal, go to your virtual machine.
2. Select **Monitor** from the left menu.
3. Select **Configure** to open the monitoring configuration page.
4. Select **OpenTelemetry-based metrics (preview)**.
5. Choose an Azure Monitor workspace or accept the default workspace. If the workspace doesn't exist, it's created automatically.
6. Select **Review + Enable**, then select **Enable**.

:::image type="content" source="media/tutorial-vm-enable-monitoring/configure-monitor.png" alt-text="Screenshot showing the customize configuration screen for a virtual machine." lightbox="media/tutorial-vm-enable-monitoring/configure-monitor.png":::

### [Azure CLI](#tab/cli)

1. Create a data collection rule (DCR) for OpenTelemetry metrics by saving the following JSON to a file named `otel-dcr.json`. Replace the placeholders with your subscription ID, resource group, and Azure Monitor workspace name.

    ```json
    {
      "properties": {
        "dataSources": {
          "performanceCountersOTel": [
            {
              "streams": ["Microsoft-OtelPerfMetrics"],
              "samplingFrequencyInSeconds": 60,
              "counterSpecifiers": [
                "system.filesystem.usage",
                "system.disk.io",
                "system.disk.operation_time",
                "system.disk.operations",
                "system.memory.usage",
                "system.network.io",
                "system.cpu.time",
                "system.network.dropped",
                "system.network.errors",
                "system.uptime"
              ],
              "name": "OtelPerfCounters"
            }
          ]
        },
        "destinations": {
          "monitoringAccounts": [
            {
              "accountResourceId": "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Monitor/accounts/<workspace-name>",
              "name": "MonitoringAccount"
            }
          ]
        },
        "dataFlows": [
          {
            "streams": ["Microsoft-OtelPerfMetrics"],
            "destinations": ["MonitoringAccount"]
          }
        ]
      }
    }
    ```

2. Create the DCR:

    ```azurecli
    az monitor data-collection rule create \
      --name "MSVMOtel-<region>-<name>" \
      --resource-group <resource-group> \
      --location <location> \
      --rule-file otel-dcr.json
    ```

3. Associate the DCR with your VM:

    ```azurecli
    az monitor data-collection rule association create \
      --name "otel-dcr-association" \
      --rule-id "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Insights/dataCollectionRules/MSVMOtel-<region>-<name>" \
      --resource "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Compute/virtualMachines/<vm-name>"
    ```

### [PowerShell](#tab/powershell)

1. Create a data collection rule (DCR) for OpenTelemetry metrics by saving the following JSON to a file named `otel-dcr.json`. Replace the placeholders with your subscription ID, resource group, and Azure Monitor workspace name.

    ```json
    {
      "properties": {
        "dataSources": {
          "performanceCountersOTel": [
            {
              "streams": ["Microsoft-OtelPerfMetrics"],
              "samplingFrequencyInSeconds": 60,
              "counterSpecifiers": [
                "system.filesystem.usage",
                "system.disk.io",
                "system.disk.operation_time",
                "system.disk.operations",
                "system.memory.usage",
                "system.network.io",
                "system.cpu.time",
                "system.network.dropped",
                "system.network.errors",
                "system.uptime"
              ],
              "name": "OtelPerfCounters"
            }
          ]
        },
        "destinations": {
          "monitoringAccounts": [
            {
              "accountResourceId": "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Monitor/accounts/<workspace-name>",
              "name": "MonitoringAccount"
            }
          ]
        },
        "dataFlows": [
          {
            "streams": ["Microsoft-OtelPerfMetrics"],
            "destinations": ["MonitoringAccount"]
          }
        ]
      }
    }
    ```

2. Create the DCR:

    ```powershell
    New-AzDataCollectionRule `
      -Name "MSVMOtel-<region>-<name>" `
      -ResourceGroupName <resource-group> `
      -Location <location> `
      -RuleFile otel-dcr.json
    ```

3. Associate the DCR with your VM:

    ```powershell
    New-AzDataCollectionRuleAssociation `
      -AssociationName "otel-dcr-association" `
      -ResourceUri "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Compute/virtualMachines/<vm-name>" `
      -DataCollectionRuleId "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Insights/dataCollectionRules/MSVMOtel-<region>-<name>"
    ```

---

## Validate data collection

After enabling OpenTelemetry metrics, verify that data is being collected correctly before removing the logs-based collection.

1. In the Azure portal, go to your virtual machine.
2. Select **Monitor** from the left menu.
3. At the top of the page, select **OpenTelemetry-based metrics (preview)** from the experience selector.
4. Verify that the performance charts display data. It may take a few minutes for data to appear.

You can also query the Azure Monitor workspace directly:

1. In the Azure portal, go to your Azure Monitor workspace.
2. Select **Metrics** from the left menu.
3. Select your VM as the resource.
4. Verify that OpenTelemetry metrics such as `system.cpu.time` and `system.memory.usage` appear in the metric list.

## Remove logs-based DCR association

After you confirm that OpenTelemetry metrics are being collected correctly, you can remove the logs-based DCR association to stop data collection and reduce costs. This doesn't delete historical data in your Log Analytics workspace.

### Identify the logs-based DCR

The logs-based DCR typically has a name in the format `MSVMI-<workspace-name>` or similar.

### [Azure portal](#tab/portal)

1. In the Azure portal, select **Monitor** > **Data Collection Rules**.
2. Select the **Resources** tab.
3. Locate your virtual machine in the list.
4. Select the number in the **Data collection rules** column to view the DCRs associated with the VM.
5. Identify the logs-based DCR. It typically has a name starting with `MSVMI-`.
6. Select the DCR, then select **Delete association** from the toolbar.
7. Confirm the deletion.

### [Azure CLI](#tab/cli)

1. List the DCR associations for your VM and identify the logs-based DCR:

    ```azurecli
    az monitor data-collection rule association list \
      --resource "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Compute/virtualMachines/<vm-name>" \
      --output table
    ```

2. Remove the logs-based DCR association. Replace `<dcr-name>` with the DCR name that starts with `MSVMI-`:

    ```azurecli
    dcraName=$(az monitor data-collection rule association list \
      --resource "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Compute/virtualMachines/<vm-name>" \
      --query "[?contains(dataCollectionRuleId, 'MSVMI')].name" -o tsv)
    
    az monitor data-collection rule association delete \
      --resource "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Compute/virtualMachines/<vm-name>" \
      --name $dcraName
    ```

### [PowerShell](#tab/powershell)

1. List the DCR associations for your VM and identify the logs-based DCR:

    ```powershell
    Get-AzDataCollectionRuleAssociation `
      -TargetResourceId "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Compute/virtualMachines/<vm-name>"
    ```

2. Remove the logs-based DCR association. Replace the DCR ID with the one that contains `MSVMI`:

    ```powershell
    $dcraName = (Get-AzDataCollectionRuleAssociation `
      -TargetResourceId "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Compute/virtualMachines/<vm-name>" | 
      Where-Object {$_.DataCollectionRuleId -like "*MSVMI*"}).Name
    
    Remove-AzDataCollectionRuleAssociation `
      -TargetResourceId "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Compute/virtualMachines/<vm-name>" `
      -AssociationName $dcraName
    ```

---

## Update queries, alerts, and dashboards

After migrating to OpenTelemetry metrics, update any queries, alerts, and dashboards that reference the logs-based data.

### Update queries

Queries need to change from KQL (querying Log Analytics workspace) to PromQL (querying Azure Monitor workspace).

**Logs-based KQL query example:**

```kusto
InsightsMetrics
| where TimeGenerated > ago(1h)
| where Namespace == "Processor" and Name == "UtilizationPercentage"
| summarize avg(Val) by bin(TimeGenerated, 5m)
```

**OpenTelemetry PromQL query example:**

```promql
avg(system_cpu_utilization{state="user"})
```

For more information on querying OpenTelemetry metrics, see [Query Prometheus metrics using Azure Monitor](../essentials/prometheus-api-promql.md).

### Update alerts

1. In the Azure portal, go to **Monitor** > **Alerts**.
2. Select **Alert rules**.
3. Identify alert rules that query the `InsightsMetrics` table.
4. Create new alert rules that query the Azure Monitor workspace using PromQL.
5. After validating the new alerts, disable or delete the old alert rules.

### Update dashboards and workbooks

Update any custom dashboards or workbooks that display logs-based metrics:

1. Identify dashboards and workbooks that query the `InsightsMetrics` table.
2. Update queries to use the Azure Monitor workspace and PromQL.
3. Test the updated visualizations to ensure they display data correctly.

## Considerations

- **Run both experiences in parallel**: Consider running both the logs-based and OpenTelemetry experiences in parallel for a period of time to ensure the new experience meets your monitoring requirements before fully migrating.
- **Data retention**: Removing the logs-based DCR association stops new data collection but doesn't delete historical data in your Log Analytics workspace. Historical data remains available according to your workspace retention settings.
- **Cost optimization**: Running both experiences simultaneously doubles your metrics ingestion costs. Remove the logs-based association as soon as you're confident in the OpenTelemetry experience.
- **Azure Monitor agent**: You don't need to reinstall or update the Azure Monitor agent. The same agent handles both logs-based and OpenTelemetry metrics collection using different DCRs.
- **Multi-VM scale**: To migrate multiple VMs, use Azure Policy or automation scripts to apply the OpenTelemetry DCR and remove logs-based associations at scale. See [Enable VM insights using Azure Policy](./vminsights-enable-policy.md).

## Rollback

If you need to rollback to the logs-based experience:

1. Keep the logs-based DCR. Don't delete it, just remove the association.
2. To re-enable logs-based collection, recreate the association between your VM and the logs-based DCR using the methods described in [Enable VM monitoring in Azure Monitor](./vm-enable-monitoring.md).
3. Remove the OpenTelemetry DCR association if you no longer need it.

## Next steps

- [Customize OpenTelemetry metric collection](./vminsights-opentelemetry.md)
- [OpenTelemetry metrics reference](./metrics-opentelemetry-guest-reference.md)
- [Query Prometheus metrics using Azure Monitor](../essentials/prometheus-api-promql.md)
- [Disable monitoring of your VMs](./vminsights-optout.md)
