---
title: Create an Azure Monitor Health Model with the Azure CLI (Preview)
description: Use the health-models Azure CLI extension (preview) to create and operate an Azure Monitor health model end to end.
ms.topic: how-to
ms.reviewer: anbossar
ms.date: 07/21/2026
ai-usage: ai-assisted
ms.custom:
  - devx-track-azurecli
---

# Use the Azure CLI (preview)

Use the `health-models` Azure CLI extension (preview) to build, update, and query your health models.

> [!IMPORTANT]
> The `health-models` Azure CLI extension is in preview and might change. Microsoft provides limited support for this feature. See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in preview or otherwise not yet released into general availability.

In this article, you learn how to use the Azure Health Models CLI extension to [create](./create.md), configure, and query a health model. Run the commands in sequence. Delete the resources when you finish to avoid extra costs.

Run `az monitor health-models --help` at any point to see the available commands and their syntax.

To build a health model in the portal instead, see [Create a health model](./create.md).

## Prerequisites

- Azure CLI 2.75.0 or later. Sign in with `az login`.
- Permission to create resources and assign roles in the target subscription.
- Bash with `curl`, or PowerShell 5.1 or later.

## Install the extension

# [Azure CLI bash](#tab/cli-bash)

```bash
az extension add --name health-models
```

# [Azure CLI PowerShell](#tab/cli-powershell)

```powershell
az extension add --name health-models
```

---

The `az monitor health-models` commands are now available.

## Guide an AI assistant

Ask an AI assistant to draft the commands. Verify every generated command before you run it.

Use this prompt:

> Use Azure CLI to help me work with the health models. Install the `health-models` extension with `az extension add --name health-models`. Inspect what the extension can do by exploring the various `az monitor health-models ... --help` outputs. Use documented Azure CLI syntax.

## Scenario introduction

Create a static App Service app. Send successful requests to the root path and failed requests to missing paths. Use the App Service `Http4xx` metric to report the failed requests in a health model.

This tutorial creates the following resources in your subscription:

- A resource group.
- An App Service plan that uses the Free F1 SKU.
- A static App Service app.
- A health model with a system-assigned managed identity and a **Reader** role assignment.

## Settings

Select your shell. Microsoft Learn keeps your tab selection for the remaining command groups. Set these values for your run. Later commands reuse them.

# [Azure CLI bash](#tab/cli-bash)

```bash
# Set variables
export suffix="$(date -u +%m%d%H%M%S)-$(printf '%08x' "$((RANDOM << 16 | RANDOM))")"
export location="swedencentral"
export resourceGroupName="hm-cli-web-$suffix"
export planName="hm-cli-plan-$suffix"
export appName="hm-cli-app-$suffix"
export appDir="$(mktemp -d)"
export modelName="hm-cli-model-$suffix"
```

# [Azure CLI PowerShell](#tab/cli-powershell)

```powershell
# Set variables
$env:suffix = [DateTime]::UtcNow.ToString("MMddHHmmss") + "-" +
  [guid]::NewGuid().ToString("N").Substring(0, 8)
$env:location = "swedencentral"
$env:resourceGroupName = "hm-cli-web-$env:suffix"
$env:planName = "hm-cli-plan-$env:suffix"
$env:appName = "hm-cli-app-$env:suffix"
$appDirName = "hm-cli-web-" + [guid]::NewGuid().ToString("N")
$env:appDir = Join-Path ([System.IO.Path]::GetTempPath()) $appDirName
New-Item -ItemType Directory -Path $env:appDir | Out-Null
$env:modelName = "hm-cli-model-$env:suffix"
```

---

## 1. Create an app to monitor

Create a local `index.html` file:

Portal: [Create an App Service app in the Azure portal](/azure/app-service/quickstart-nodejs?pivots=development-environment-azure-portal#create-azure-resources).

# [Azure CLI bash](#tab/cli-bash)

```bash
cat > "$appDir/index.html" <<HTML
<!doctype html>
<html lang="en">
<head><meta charset="utf-8"><title>$appName health model tutorial</title></head>
<body><h1>$appName is running</h1></body>
</html>
HTML
```

# [Azure CLI PowerShell](#tab/cli-powershell)

```powershell
@"
<!doctype html>
<html lang="en">
<head><meta charset="utf-8"><title>$env:appName health model tutorial</title></head>
<body><h1>$env:appName is running</h1></body>
</html>
"@ | Set-Content -Path (Join-Path $env:appDir "index.html") -Encoding utf8
```

---

Create a resource group:

# [Azure CLI bash](#tab/cli-bash)

```bash
az group create -n "$resourceGroupName" -l "$location" \
  --query "{location:location,provisioningState:properties.provisioningState}" -o table
```

# [Azure CLI PowerShell](#tab/cli-powershell)

```powershell
az group create -n "$env:resourceGroupName" -l "$env:location" `
  --query "{location:location,provisioningState:properties.provisioningState}" -o table
```

---

```output
Location       ProvisioningState
-------------  -------------------
swedencentral  Succeeded
```

Create a Linux F1 App Service plan and app. Deploy `index.html` from its explicit source path:

# [Azure CLI bash](#tab/cli-bash)

```bash
az appservice plan create -g "$resourceGroupName" -n "$planName" -l "$location" \
  --sku F1 --is-linux --query "{tier:sku.tier,linux:reserved}" -o table

az webapp create -g "$resourceGroupName" -p "$planName" -n "$appName" \
  --runtime "PHP:8.5" --query "{state:state}" -o table

az webapp deploy -g "$resourceGroupName" -n "$appName" \
  --src-path "$appDir/index.html" --type static --target-path index.html \
  --async false --track-status true \
  --query "{status:properties.status || status}" -o table

export appId="$(az webapp show -n "$appName" -g "$resourceGroupName" --query id -o tsv)"
appHost="$(az webapp show -n "$appName" -g "$resourceGroupName" \
  --query defaultHostName -o tsv)"
export appUrl="https://$appHost"

printf 'App URL: %s\n' "$appUrl"
```

# [Azure CLI PowerShell](#tab/cli-powershell)

```powershell
az appservice plan create -g "$env:resourceGroupName" -n "$env:planName" `
  -l "$env:location" --sku F1 --is-linux `
  --query "{tier:sku.tier,linux:reserved}" -o table

az webapp create -g "$env:resourceGroupName" -p "$env:planName" -n "$env:appName" `
  --runtime "PHP:8.5" --query "{state:state}" -o table

az webapp deploy -g "$env:resourceGroupName" -n "$env:appName" `
  --src-path (Join-Path $env:appDir "index.html") --type static --target-path index.html `
  --async false --track-status true `
  --query "{status:properties.status || status}" -o table

$env:appId = az webapp show -n "$env:appName" -g "$env:resourceGroupName" `
  --query id -o tsv
$appHost = az webapp show -n "$env:appName" -g "$env:resourceGroupName" `
  --query defaultHostName -o tsv
$env:appUrl = "https://$appHost"

Write-Output "App URL: $env:appUrl"
```

---

```output
Tier       Linux
---------  -------
LinuxFree  True

State
-------
Running

Status
-----------------
RuntimeSuccessful

App URL: https://hm-cli-app-example.azurewebsites.net
```

Open the app URL in a browser, or fetch it from your shell. The page includes the unique app name:

# [Azure CLI bash](#tab/cli-bash)

```bash
curl --fail --silent "$appUrl/"
```

# [Azure CLI PowerShell](#tab/cli-powershell)

```powershell
(Invoke-WebRequest -Uri "$env:appUrl/" -UseBasicParsing).Content
```

---

```output
<!doctype html>
<html lang="en">
<head><meta charset="utf-8"><title>hm-cli-app-example health model tutorial</title></head>
<body><h1>hm-cli-app-example is running</h1></body>
</html>
```

## 2. Create the health model

Create the model with a system-assigned managed identity. The model uses this identity to read resource metrics:

Portal: [Create a health model in the Azure portal](./create.md#create-a-health-model).

# [Azure CLI bash](#tab/cli-bash)

```bash
az monitor health-models create -g "$resourceGroupName" -n "$modelName" -l "$location" \
  --mi-system-assigned --query "{location:location,identity:identity.type}" -o table
```

# [Azure CLI PowerShell](#tab/cli-powershell)

```powershell
az monitor health-models create -g "$env:resourceGroupName" -n "$env:modelName" `
  -l "$env:location" --mi-system-assigned `
  --query "{location:location,identity:identity.type}" -o table
```

---

```output
Identity        Location
--------------  -------------
SystemAssigned  swedencentral
```

## 3. Grant the model access to the app

Give the model's identity the **Reader** role on the app:

Portal: [Assign the Reader role to the model identity in the Azure portal](/azure/role-based-access-control/role-assignments-portal#step-4-select-who-needs-access).

# [Azure CLI bash](#tab/cli-bash)

```bash
export principalId="$(az monitor health-models show -g "$resourceGroupName" \
  -n "$modelName" --query identity.principalId -o tsv)"

az role assignment create --assignee-object-id "$principalId" \
  --assignee-principal-type ServicePrincipal --role "Reader" --scope "$appId" \
  --query "{role:roleDefinitionName}" -o table
```

# [Azure CLI PowerShell](#tab/cli-powershell)

```powershell
$env:principalId = az monitor health-models show -g "$env:resourceGroupName" `
  -n "$env:modelName" --query identity.principalId -o tsv

az role assignment create --assignee-object-id "$env:principalId" `
  --assignee-principal-type ServicePrincipal --role "Reader" --scope "$env:appId" `
  --query "{role:roleDefinitionName}" -o table
```

---

```output
Role
------
Reader
```

## 4. Create an authentication setting

A signal uses an authentication setting to select the identity that reads its data. Set `managed-identity-name=SystemAssigned` to use the model's system-assigned identity:

Portal: [Create an authentication setting in the Azure portal](./create.md#identity).

# [Azure CLI bash](#tab/cli-bash)

```bash
az monitor health-models authentication-setting create -g "$resourceGroupName" \
  --health-model-name "$modelName" -n "auth-system" \
  --managed-identity managed-identity-name=SystemAssigned \
  --query "{name:name}" -o table
```

# [Azure CLI PowerShell](#tab/cli-powershell)

```powershell
az monitor health-models authentication-setting create -g "$env:resourceGroupName" `
  --health-model-name "$env:modelName" -n "auth-system" `
  --managed-identity managed-identity-name=SystemAssigned `
  --query "{name:name}" -o table
```

---

```output
Name
-----------
auth-system
```

## 5. Define the request-failure signal

App Service emits separate metrics for each HTTP status class:

- `Requests` counts requests for every resulting HTTP status.
- `Http4xx` counts responses with a status from 400 through 499.
- `Http5xx` counts responses with a status from 500 through 599.

App Service doesn't emit one built-in metric that combines all non-success status classes. This tutorial generates 404 responses, so it uses `Http4xx`.

Portal: [Create an Azure resource metric signal in the Azure portal](./tutorial-signals.md#add-an-azure-resource-metric-signal).

List the live metric definitions for the app:

# [Azure CLI bash](#tab/cli-bash)

```bash
# Project the metric definitions into table columns
query="[?name.value=='Requests' || name.value=='Http4xx' || name.value=='Http5xx']"
query+=".{metric:name.value,namespace:namespace,unit:unit,"
query+="aggregation:primaryAggregationType,"
query+="timeGrains:join(',',metricAvailabilities[].timeGrain)}"

# List the metric definitions
az monitor metrics list-definitions --resource "$appId" --query "$query" -o table
```

# [Azure CLI PowerShell](#tab/cli-powershell)

```powershell
# Project the metric definitions into table columns
$query = "[?name.value=='Requests' || name.value=='Http4xx' || name.value=='Http5xx']"
$query += ".{metric:name.value,namespace:namespace,unit:unit,"
$query += "aggregation:primaryAggregationType,"
$query += "timeGrains:join(',',metricAvailabilities[].timeGrain)}"

# List the metric definitions
az monitor metrics list-definitions --resource "$env:appId" --query "$query" -o table
```

---

```output
Metric    Namespace            Unit    Aggregation    TimeGrains
--------  -------------------  ------  -------------  -----------------------------------------
Requests  Microsoft.Web/sites  Count   Total          PT1M,PT5M,PT15M,PT30M,PT1H,PT6H,PT12H,P1D
Http4xx   Microsoft.Web/sites  Count   Total          PT1M,PT5M,PT15M,PT30M,PT1H,PT6H,PT12H,P1D
Http5xx   Microsoft.Web/sites  Count   Total          PT1M,PT5M,PT15M,PT30M,PT1H,PT6H,PT12H,P1D
```

Create one signal definition from `Http4xx`. Mark the signal as degraded above zero failed requests per minute and unhealthy above five:

# [Azure CLI bash](#tab/cli-bash)

```bash
# Build the metric definition and the evaluation rules
azureResourceMetric="{metric-namespace:Microsoft.Web/sites,metric-name:Http4xx,"
azureResourceMetric+="aggregation-type:Total,time-grain:PT1M}"
evaluationRules="{degraded-rule:{operator:GreaterThan,threshold:0},"
evaluationRules+="unhealthy-rule:{operator:GreaterThan,threshold:5}}"

# Create the signal definition
az monitor health-models signal-definition create -g "$resourceGroupName" \
  --health-model-name "$modelName" -n "sd-http-4xx" \
  --display-name "HTTP 4xx responses" --refresh-interval PT1M --data-unit Count \
  --azure-resource-metric "$azureResourceMetric" \
  --evaluation-rules "$evaluationRules" \
  --query "{name:name}" -o table
```

# [Azure CLI PowerShell](#tab/cli-powershell)

```powershell
# Build the metric definition and the evaluation rules
$azureResourceMetric = "{metric-namespace:Microsoft.Web/sites,metric-name:Http4xx,"
$azureResourceMetric += "aggregation-type:Total,time-grain:PT1M}"
$evaluationRules = "{degraded-rule:{operator:GreaterThan,threshold:0},"
$evaluationRules += "unhealthy-rule:{operator:GreaterThan,threshold:5}}"

# Create the signal definition
az monitor health-models signal-definition create -g "$env:resourceGroupName" `
  --health-model-name "$env:modelName" -n "sd-http-4xx" `
  --display-name "HTTP 4xx responses" --refresh-interval PT1M --data-unit Count `
  --azure-resource-metric "$azureResourceMetric" `
  --evaluation-rules "$evaluationRules" `
  --query "{name:name}" -o table
```

---

```output
Name
-------------
sd-http-4xx
```

## 6. Create an entity

Create an entity that references the app and the `Http4xx` signal definition. The signal determines the entity's health state. For more information, see [Configure health rollup](./rollup.md).

Portal: [Add an entity in the Azure portal](./designer.md#add-an-entity).

# [Azure CLI bash](#tab/cli-bash)

```bash
# Build the signal group
signalGroups="{azure-resource:{authentication-setting:auth-system,"
signalGroups+="azure-resource-id:$appId,"
signalGroups+="signals:[{name:http-4xx,signal-definition-name:sd-http-4xx}]}}"

# Create the entity
az monitor health-models entity create -g "$resourceGroupName" \
  --health-model-name "$modelName" -n "WebApp" \
  --display-name "Tutorial web app" --impact Standard \
  --signal-groups "$signalGroups" \
  --query "{name:name}" -o table
```

# [Azure CLI PowerShell](#tab/cli-powershell)

```powershell
# Build the signal group
$signalGroups = "{azure-resource:{authentication-setting:auth-system,"
$signalGroups += "azure-resource-id:$env:appId,"
$signalGroups += "signals:[{name:http-4xx,signal-definition-name:sd-http-4xx}]}}"

# Create the entity
az monitor health-models entity create -g "$env:resourceGroupName" `
  --health-model-name "$env:modelName" -n "WebApp" `
  --display-name "Tutorial web app" --impact Standard `
  --signal-groups "$signalGroups" `
  --query "{name:name}" -o table
```

---

```output
Name
------
WebApp
```

## 7. Connect the entity to the model root

Azure creates each health model with a root entity that has the model's name. Connect the app entity to the root entity:

Portal: [Create a relationship in the Azure portal](./designer.md#relationships).

# [Azure CLI bash](#tab/cli-bash)

```bash
az monitor health-models relationship create -g "$resourceGroupName" \
  --health-model-name "$modelName" -n "root-to-web-app" \
  --parent-entity-name "$modelName" --child-entity-name "WebApp" \
  --query "{name:name}" -o table
```

# [Azure CLI PowerShell](#tab/cli-powershell)

```powershell
az monitor health-models relationship create -g "$env:resourceGroupName" `
  --health-model-name "$env:modelName" -n "root-to-web-app" `
  --parent-entity-name "$env:modelName" --child-entity-name "WebApp" `
  --query "{name:name}" -o table
```

---

```output
Name
-------------------
root-to-web-app
```

## 8. Generate successful and failed requests

Each iteration sends one successful request and one failing request, then waits. This traffic generates the metrics that the health model evaluates.

Portal: [Open the App Service log stream in the Azure portal](/azure/app-service/troubleshoot-diagnostic-logs#azure-portal).

# [Azure CLI bash](#tab/cli-bash)

```bash
for i in {1..60}; do
  curl --silent --output /dev/null "$appUrl/"
  curl --silent --output /dev/null "$appUrl/missing-$suffix-$i"
  sleep 5
done
```

# [Azure CLI PowerShell](#tab/cli-powershell)

```powershell
foreach ($i in 1..60) {
  Invoke-WebRequest -Uri "$env:appUrl/" -UseBasicParsing | Out-Null
  $missingUrl = "$env:appUrl/missing-$env:suffix-$i"
  try {
    Invoke-WebRequest -Uri $missingUrl -UseBasicParsing -ErrorAction Stop | Out-Null
  }
  catch {
  }
  Start-Sleep -Seconds 5
}
```

---

## 9. Observe the metrics and current health

Azure Monitor publishes App Service metrics once per minute. Wait a minute and then query the `Total` values at the `PT1M` time grain:

Portal: [Chart the App Service request metrics in metrics explorer](../metrics/analyze-metrics.md#create-a-metric-chart).

# [Azure CLI bash](#tab/cli-bash)

```bash
az monitor metrics list --resource "$appId" \
  --metrics Requests Http4xx --aggregation Total --interval PT1M --offset 30m \
  --query "value[].{metric:name.value,total:sum(timeseries[].data[].total)}" -o table
```

# [Azure CLI PowerShell](#tab/cli-powershell)

```powershell
az monitor metrics list --resource "$env:appId" `
  --metrics Requests Http4xx --aggregation Total --interval PT1M --offset 30m `
  --query "value[].{metric:name.value,total:sum(timeseries[].data[].total)}" -o table
```

---

```output
Metric    Total
--------  -----
Requests  120
Http4xx   60
```

The metric is available. Review how it appears as a signal in the health model:

# [Azure CLI bash](#tab/cli-bash)

```bash
# Project the signal states into table columns
query="properties.signalGroups.azureResource.signals[]"
query+=".{signal:name,state:status.healthState,value:status.value}"

# Show the entity signals
az monitor health-models entity show -g "$resourceGroupName" \
  --health-model-name "$modelName" -n "WebApp" --query "$query" -o table
```

# [Azure CLI PowerShell](#tab/cli-powershell)

```powershell
# Project the signal states into table columns
$query = "properties.signalGroups.azureResource.signals[]"
$query += ".{signal:name,state:status.healthState,value:status.value}"

# Show the entity signals
az monitor health-models entity show -g "$env:resourceGroupName" `
  --health-model-name "$env:modelName" -n "WebApp" --query "$query" -o table
```

---

```output
Signal    State      Value
--------  ---------  -----
http-4xx  Unhealthy  12.0
```

The signal is `Unhealthy` because the failed-request count exceeds five in one minute.

## 10. Query the signal history

Run `get-signal-history` to return the last 24 hours of state history for the `Http4xx` signal:

Portal: [Inspect signal history in the entity details pane](./analyze-health.md#entity-details).

# [Azure CLI bash](#tab/cli-bash)

```bash
az monitor health-models entity get-signal-history -g "$resourceGroupName" \
  --health-model-name "$modelName" --entity-name "WebApp" --signal-name "http-4xx" \
  --query "history[].{timestamp:occurredAt,currentState:healthState,value:value}" -o table
```

# [Azure CLI PowerShell](#tab/cli-powershell)

```powershell
az monitor health-models entity get-signal-history -g "$env:resourceGroupName" `
  --health-model-name "$env:modelName" --entity-name "WebApp" --signal-name "http-4xx" `
  --query "history[].{timestamp:occurredAt,currentState:healthState,value:value}" -o table
```

---

```output
Timestamp             CurrentState  Value
--------------------  ------------  -----
2026-07-21T20:43:00Z  Unhealthy     12.0
```

## 11. Query the entity health-state history

Run `get-history` to return the entity's state transitions:

Portal: [View entity health changes on the timeline](./analyze-health.md#timeline-view).

# [Azure CLI bash](#tab/cli-bash)

```bash
# Project the state transitions into table columns
query="history[].{timestamp:occurredAt,previousState:previousState,"
query+="currentState:newState}"

# Show the entity health-state history
az monitor health-models entity get-history -g "$resourceGroupName" \
  --health-model-name "$modelName" --entity-name "WebApp" --query "$query" -o table
```

# [Azure CLI PowerShell](#tab/cli-powershell)

```powershell
# Project the state transitions into table columns
$query = "history[].{timestamp:occurredAt,previousState:previousState,"
$query += "currentState:newState}"

# Show the entity health-state history
az monitor health-models entity get-history -g "$env:resourceGroupName" `
  --health-model-name "$env:modelName" --entity-name "WebApp" --query "$query" -o table
```

---

```output
Timestamp             PreviousState  CurrentState
--------------------  -------------  ------------
2026-07-21T20:43:00Z  Degraded       Unhealthy
```

The app becomes unhealthy at the timestamp in this row, when its state changes from `Degraded` to `Unhealthy` after the `Http4xx` value exceeds five.

The metric scenario is complete. The next two optional sections show how to add additional context and report health from another system.

## 12. Optional: Annotate an entity

Use data annotations to attach point-in-time context to an entity. An annotation can represent a new application release, or mark the time of an outage or another event, so that you correlate it with the entity's health history.

For the focused procedure to add, retrieve, and view annotations, see [Add data annotations to Azure Monitor health models](./data-annotations.md).

Portal: [Review point-in-time entity health on the timeline](./analyze-health.md#timeline-view).

## 13. Optional: Report external health

Use `ingest-health-report` to report a health state from your system. The external report is independent of the App Service metric signal. Choose any value for `--signal-name`. If the name doesn't match a signal, the model adds an `External` signal to the entity:

For a focused procedure that covers request fields, report expiration, and refresh behavior, see [Submit data for externally evaluated signals](./health-report-ingestion.md).

Portal: [Inspect the reported external signal in entity details](./analyze-health.md#entity-details).

# [Azure CLI bash](#tab/cli-bash)

```bash
# Build the evaluation rules
evaluationRules="{degraded-rule:{operator:GreaterThan,threshold:70},"
evaluationRules+="unhealthy-rule:{operator:GreaterThan,threshold:90}}"

# Report the external health state
az monitor health-models entity ingest-health-report -g "$resourceGroupName" \
  --health-model-name "$modelName" --entity-name "WebApp" \
  --signal-name "availability-check" --health-state Degraded --value 85.5 \
  --evaluation-rules "$evaluationRules" \
  --additional-context "Synthetic availability check reported elevated latency" \
  --expires-in-minutes 60
```

# [Azure CLI PowerShell](#tab/cli-powershell)

```powershell
# Build the evaluation rules
$evaluationRules = "{degraded-rule:{operator:GreaterThan,threshold:70},"
$evaluationRules += "unhealthy-rule:{operator:GreaterThan,threshold:90}}"

# Report the external health state
az monitor health-models entity ingest-health-report -g "$env:resourceGroupName" `
  --health-model-name "$env:modelName" --entity-name "WebApp" `
  --signal-name "availability-check" --health-state Degraded --value 85.5 `
  --evaluation-rules "$evaluationRules" `
  --additional-context "Synthetic availability check reported elevated latency" `
  --expires-in-minutes 60
```

---

The command returns no output. List the entity's external signals:

# [Azure CLI bash](#tab/cli-bash)

```bash
# Project the external signals into table columns
query="properties.signalGroups.*.signals[] | [?signalKind=='External']"
query+=".{signal:name,kind:signalKind,state:status.healthState,value:status.value}"

# Show the external signals
az monitor health-models entity show -g "$resourceGroupName" \
  --health-model-name "$modelName" -n "WebApp" --query "$query" -o table
```

# [Azure CLI PowerShell](#tab/cli-powershell)

```powershell
# Project the external signals into table columns
$query = "properties.signalGroups.*.signals[] | [?signalKind=='External']"
$query += ".{signal:name,kind:signalKind,state:status.healthState,value:status.value}"

# Show the external signals
az monitor health-models entity show -g "$env:resourceGroupName" `
  --health-model-name "$env:modelName" -n "WebApp" --query "$query" -o table
```

---

```output
Signal              Kind      State     Value
------------------  --------  --------  -----
availability-check  External  Degraded  85.5
```

View the reported value in the signal history:

# [Azure CLI bash](#tab/cli-bash)

```bash
az monitor health-models entity get-signal-history -g "$resourceGroupName" \
  --health-model-name "$modelName" --entity-name "WebApp" \
  --signal-name "availability-check" \
  --query "history[].{timestamp:occurredAt,currentState:healthState,value:value}" -o table
```

# [Azure CLI PowerShell](#tab/cli-powershell)

```powershell
az monitor health-models entity get-signal-history -g "$env:resourceGroupName" `
  --health-model-name "$env:modelName" --entity-name "WebApp" `
  --signal-name "availability-check" `
  --query "history[].{timestamp:occurredAt,currentState:healthState,value:value}" -o table
```

---

```output
Timestamp                          CurrentState  Value
---------------------------------  ------------  -----
2026-07-21T21:37:43.6900448+00:00  Degraded      85.5
```

## Clean up

Delete the resource group, verify that Azure removed it, and delete the local app directory:

# [Azure CLI bash](#tab/cli-bash)

```bash
az group delete -n "$resourceGroupName" --yes
az group exists -n "$resourceGroupName"

rm -rf -- "$appDir"
if [[ -e "$appDir" ]]; then
  printf 'Local app directory still exists\n' >&2
  exit 1
fi
printf 'Local app directory exists: false\n'
```

# [Azure CLI PowerShell](#tab/cli-powershell)

```powershell
az group delete -n "$env:resourceGroupName" --yes
az group exists -n "$env:resourceGroupName"

Remove-Item -LiteralPath $env:appDir -Recurse -Force
$localDirectoryExists = Test-Path -LiteralPath $env:appDir
$existsText = $localDirectoryExists.ToString().ToLowerInvariant()
Write-Output "Local app directory exists: $existsText"
if ($localDirectoryExists) {
  throw "Local app directory still exists"
}
```

---

```output
false
Local app directory exists: false
```

## Resource schema reference

Each CLI parameter maps to a property of the `Microsoft.CloudHealth/healthModels` resource. For the full schema, see:

- [Health model resource schema](/azure/templates/microsoft.cloudhealth/healthmodels)
- [Signal definition schema](/azure/templates/microsoft.cloudhealth/healthmodels/signaldefinitions)
- [Entity schema](/azure/templates/microsoft.cloudhealth/healthmodels/entities)

## Next steps

Learn how to analyze your health model and investigate problems.

> [!div class="nextstepaction"]
> [Analyze the health of an Azure Monitor health model](./analyze-health.md)
