---
title: Submit data for externally evaluated signals
description: Learn how to submit, refresh, and verify data for externally evaluated signals in Azure Monitor health models by using the Azure CLI.
ms.topic: how-to
ms.reviewer: megangoode
ms.date: 08/20/2026
ai-usage: ai-assisted
ms.custom:
  - devx-track-azurecli
---

# Submit data for externally evaluated signals by using the Health Report Ingestion API (preview)

Use the [Health Report Ingestion API](/rest/api/health-models/entities/ingest-health-report?view=rest-health-models-2026-05-01-preview&preserve-view=true) to add health signals that an external system calculates to an existing [Azure Monitor health model](./overview.md). For example, a synthetic test or an on-premises monitoring system can report the current state of a component that Azure Monitor doesn't evaluate directly.

Each report applies to a named signal on an entity. The health model includes the signal in the entity's health calculation and propagates the resulting state through the model's relationships. Reports expire unless the external system refreshes them.

> [!IMPORTANT]
> Azure Monitor health models and the `health-models` Azure CLI extension are in preview and might change. Microsoft provides limited support for preview features. See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to features that are in preview or otherwise not yet released into general availability.

## Prerequisites

- An Azure account with an active subscription. [Create an account for free](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn).
- An existing Azure Monitor health model that contains the entity that receives the report. The API doesn't create entities.
- Permission to perform write actions on the health model.
- Azure CLI 2.75.0 or later. Run `az --version` to check your version.
- The `health-models` Azure CLI extension.

Sign in to Azure and install or update the extension:

# [Azure CLI (Bash)](#tab/azure-cli-bash)

```azurecli
az login
az extension add --name health-models --upgrade
```

# [Azure CLI (PowerShell)](#tab/azure-cli-powershell)

```azurepowershell
az login
az extension add --name health-models --upgrade
```

---

## Set environment values

Select your shell and set values for the target health model and entity. The remaining commands use these values.

# [Azure CLI (Bash)](#tab/azure-cli-bash)

```azurecli
resourceGroupName="<resource-group-name>"
healthModelName="<health-model-name>"
entityName="<entity-name>"
```

# [Azure CLI (PowerShell)](#tab/azure-cli-powershell)

```azurepowershell
$resourceGroupName = "<resource-group-name>"
$healthModelName = "<health-model-name>"
$entityName = "<entity-name>"
```

---

Replace the placeholder values with the names of your resource group, health model, and entity.

## Review the health report request

A health report requires a signal name and health state. Include the other fields when the external system has supporting values or context.

| Field | Required | Description |
|:---|:---:|:---|
| `signalName` | Yes | Name of the external signal. If the signal doesn't exist on the entity, the health model creates it. The name must be 3 through 260 characters, contain only letters, numbers, and hyphens, and start and end with a letter or number. |
| `healthState` | Yes | State to report: `Healthy`, `Degraded`, `Unhealthy`, or `Unknown`. |
| `value` | No | Numeric value that the external system evaluated, such as CPU utilization. |
| `evaluationRules` | No | Thresholds and operators that the external system used to evaluate the value. If you include this object, `unhealthyRule` is required and `degradedRule` is optional. |
| `expiresInMinutes` | No | Time to live for the report. The default is 60 minutes, and the allowed range is 1 through 10,080 minutes. |
| `additionalContext` | No | Description or other context for the report, up to 4,096 characters. |

## Submit a health report

Submit a degraded CPU signal with a value of 82.5 and a 10-minute time to live.

# [Azure CLI (Bash)](#tab/azure-cli-bash)

```azurecli
evaluationRules="{degraded-rule:{operator:GreaterThan,threshold:70},"
evaluationRules+="unhealthy-rule:{operator:GreaterThan,threshold:90}}"

az monitor health-models entity ingest-health-report \
  --resource-group "$resourceGroupName" \
  --health-model-name "$healthModelName" \
  --entity-name "$entityName" \
  --signal-name "cpu-utilization" \
  --health-state Degraded \
  --value 82.5 \
  --evaluation-rules "$evaluationRules" \
  --expires-in-minutes 10 \
  --additional-context "CPU remained above 80 percent for 5 minutes."
```

# [Azure CLI (PowerShell)](#tab/azure-cli-powershell)

```azurepowershell
$evaluationRules = "{degraded-rule:{operator:GreaterThan,threshold:70},"
$evaluationRules += "unhealthy-rule:{operator:GreaterThan,threshold:90}}"

az monitor health-models entity ingest-health-report `
  --resource-group $resourceGroupName `
  --health-model-name $healthModelName `
  --entity-name $entityName `
  --signal-name "cpu-utilization" `
  --health-state Degraded `
  --value 82.5 `
  --evaluation-rules $evaluationRules `
  --expires-in-minutes 10 `
  --additional-context "CPU remained above 80 percent for 5 minutes."
```

---

The command returns no output when the request succeeds.

## Verify the report

Health recalculation might take a few seconds. Query the entity's current state:

# [Azure CLI (Bash)](#tab/azure-cli-bash)

```azurecli
az monitor health-models entity show \
  --resource-group "$resourceGroupName" \
  --health-model-name "$healthModelName" \
  --entity-name "$entityName" \
  --query "properties.healthState" -o tsv
```

# [Azure CLI (PowerShell)](#tab/azure-cli-powershell)

```azurepowershell
az monitor health-models entity show `
  --resource-group $resourceGroupName `
  --health-model-name $healthModelName `
  --entity-name $entityName `
  --query "properties.healthState" -o tsv
```

---

For the example report, the command returns `Degraded` unless another signal or child dependency puts the entity in a worse state.

Query the external signal to verify its state, value, report time, and context:

# [Azure CLI (Bash)](#tab/azure-cli-bash)

```azurecli
query="properties.signalGroups.external.signals[?name=='cpu-utilization']"
query+=".{signal:name,state:status.healthState,value:status.value,"
query+="reportedAt:status.reportedAt,context:status.additionalContext}"

az monitor health-models entity show \
  --resource-group "$resourceGroupName" \
  --health-model-name "$healthModelName" \
  --entity-name "$entityName" \
  --query "$query" -o table
```

# [Azure CLI (PowerShell)](#tab/azure-cli-powershell)

```azurepowershell
$query = "properties.signalGroups.external.signals[?name=='cpu-utilization']"
$query += ".{signal:name,state:status.healthState,value:status.value,"
$query += "reportedAt:status.reportedAt,context:status.additionalContext}"

az monitor health-models entity show `
  --resource-group $resourceGroupName `
  --health-model-name $healthModelName `
  --entity-name $entityName `
  --query $query -o table
```

---

In the Azure portal, open the health model, select the entity, and review its external signals and current health state.

## Keep the report current

An external system should submit a new report before the previous report's time to live ends. For example, submit every 5 minutes when `expiresInMinutes` is 15. Each report for the same entity and signal name replaces the previous report with the latest state, value, expiration, and context.

When the monitored condition recovers, submit another report for the same signal with `healthState` set to `Healthy`. The latest observation then contributes a healthy state to the entity calculation.

## Understand report expiration and propagation

When the time to live ends, the health model removes the external signal from the entity and recalculates the entity's health without that signal. Submit another report with the same signal name to add it again.

While a report is active, its state contributes to the entity's health in the same way as other signals. The entity's resulting state propagates to its parents according to the model's relationships and [health propagation settings](./rollup.md). Query parent entities or view the graph in the Azure portal to confirm the expected propagation.

## Related content

- [Azure Monitor health model concepts](./concepts.md)
- [Use the Azure CLI with Azure Monitor health models](./cli.md)
- [Analyze health state in Azure Monitor health models](./analyze-health.md)