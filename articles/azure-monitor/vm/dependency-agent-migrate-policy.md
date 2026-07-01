---
title: Migrate Dependency Agent policy and initiative assignments
description: Learn how to find Azure Policy and initiative assignments that use Dependency Agent, replace supported initiatives, and remove remaining assignments.
author: bwren
ms.author: bwren
ms.service: azure-monitor
ms.topic: how-to
ai-usage: ai-assisted
ms.custom: doc-kit-assisted
ms.date: 07/01/2026
ms.subservice: virtual-machines
---

# Migrate Dependency Agent policy and initiative assignments

The Map feature and the Dependency Agent in VM Insights has been deprecated and will be retired on 30 June 2028. As the retirement approaches, you should review any Azure policy and initiative assignments that install or depend on Dependency Agent. 

This article describes how to:

- find affected assignments
- replace unsupported initiatives
- disable Dependency Agent settings in supported initiatives
- remove remaining standalone policy assignments

For retirement dates and overall product impact, see [VM insights Map and Dependency Agent retirement guidance](vminsights-maps-retirement.md). For broader agent migration guidance, see [Migrate from Log Analytics agent to Azure Monitor agent](../agents/azure-monitor-agent-migration.md).

## Prerequisites

- Access to run Azure Resource Graph queries at the management group, subscription, resource group, or virtual machine scope that you want to review.
- Permission to read and update Azure Policy assignments at the target scope.
- A plan to move affected machines to Azure Monitor agent, if you still use Dependency Agent for VM insights Map.
- Either an existing user-assigned managed identity or approval to use the built-in managed identity option if you plan to assign a replacement initiative.

## Verify Azure Monitor agent migration status

Before you replace or update policy and initiative assignments, confirm that affected machines are migrated from Log Analytics agent to Azure Monitor agent. For migration guidance, see [Migrate from Log Analytics agent to Azure Monitor agent](../agents/azure-monitor-agent-migration.md).

## Replace initiative assignments

Some initiatives that use Dependency Agent are no longer supported. Use the following process to find those assignments, remove them, and assign the supported replacement initiative.

### Find unsupported assignments

The following Resource Graph query finds policy initiative assignments that use unsupported VM insights Map and Dependency Agent initiatives. The results include the replacement initiative to assign. Run the query by using any of the methods in the following section. If the query returns results, save them to a CSV.

<details>
<summary><b>Show query</b></summary>

```kusto
policyresources
| where type == 'microsoft.authorization/policyassignments'
| where properties.policyDefinitionId in (
    '/providers/Microsoft.Authorization/policySetDefinitions/1f9b0c83-b4fa-4585-a686-72b74aeabcfd',
    '/providers/Microsoft.Authorization/policySetDefinitions/55f3eceb-5573-4f18-9695-226972c6d74a',
    '/providers/Microsoft.Authorization/policySetDefinitions/59e9c3eb-d8df-473b-8059-23fd38ddd0f0',
    '/providers/Microsoft.Authorization/policySetDefinitions/75714362-cae7-409e-9b99-a8e5075b7fad',
    '/providers/Microsoft.Authorization/policySetDefinitions/9dffaf29-5905-4145-883c-957eb442c226'
)
| extend UnsupportedInitiative = extract(@"(?i)[^/]+/([-0-9a-f]+)$", 1, tostring(properties.policyDefinitionId))
| extend Replacement = case(
        UnsupportedInitiative == '1f9b0c83-b4fa-4585-a686-72b74aeabcfd', 'f5bf694c-cca7-4033-b883-3a23327d5485',
        UnsupportedInitiative == '55f3eceb-5573-4f18-9695-226972c6d74a', '924bfe3a-762f-40e7-86dd-5c8b95eb09e6',
        UnsupportedInitiative == '59e9c3eb-d8df-473b-8059-23fd38ddd0f0', '2b00397d-c309-49c4-aa5a-f0b2c5bc6321',
        UnsupportedInitiative == '75714362-cae7-409e-9b99-a8e5075b7fad', 'f5bf694c-cca7-4033-b883-3a23327d5485',
        UnsupportedInitiative == '9dffaf29-5905-4145-883c-957eb442c226', '924bfe3a-762f-40e7-86dd-5c8b95eb09e6',
        'Unknown'
    )
| extend Scope = tostring(properties.scope)
| extend ResourceContainerId = iff(isnotempty(subscriptionId), strcat('/subscriptions/', tolower(subscriptionId)), tolower(Scope))
| join kind=leftouter (
    resourcecontainers
    | extend ResourceContainerId = tolower(id)
) on ResourceContainerId
| extend ExtractedTypeAndName = extract_all(@"([^/]+)/([^/]+)$", Scope)[0]
| extend ResourceContainerName = iff(isnull(properties1.displayName), name1, tostring(properties1.displayName))
| extend ResourceType = ExtractedTypeAndName[0]
| extend DisplayName = tostring(properties.displayName)
| project
    Resource = case(
        ResourceType =~ 'subscriptions', ResourceContainerName,
        ResourceType =~ 'resourcegroups', strcat(ResourceContainerName, '/', resourceGroup),
        ResourceType =~ 'managementgroups', iff(isnotempty(ResourceContainerName), ResourceContainerName, ExtractedTypeAndName[1]),
        strcat(ResourceContainerName, '/', resourceGroup, '/', ExtractedTypeAndName[1])
    ),
    ResourceType,
    AssignmentName = iff(isnotempty(DisplayName), DisplayName, name),
    UnsupportedInitiative,
    Replacement,
    AssignmentId = id,
    Scope
| sort by tolower(Resource), tolower(ResourceType), tolower(AssignmentName)
```

</details>



### [Azure portal](#tab/portal)

1. Open [Azure Resource Graph Explorer](/azure/governance/resource-graph/first-query-portal).
1. Set the scope to the management group, subscription, resource group, or virtual machine that you want to review.
1. Copy and paste the query into Resource Graph Explorer and select **Run query**.
1. Review the `AssignmentName`, `AssignmentId`, `Replacement`, and `Scope` values in the results.

### [Azure CLI](#tab/cli)

1. Save the query to a local `.kql` file.
1. Run the query with the following command.

```azurecli
query=$(cat ./find-unsupported-assignments.kql)
az graph query -q "$query" --first 1000
```

### [PowerShell](#tab/powershell)

1. Save the query to a local `.kql` file.
1. Run the query with the following command.

```powershell
$Query = Get-Content .\find-unsupported-assignments.kql -Raw
Search-AzGraph -Query $Query -First 1000
```

---

The query output identifies unsupported assignments and the replacement initiative to use.

### Remove unsupported assignment

If the query returns an unsupported initiative assignment, remove it before you create the replacement assignment.

### [Azure portal](#tab/portal)

1. Go to the management group, subscription, resource group, or virtual machine that contains the assignment.
1. Select **Policy**.
1. Search for the assignment using the value in `AssignmentName`.
1. Open the assignment.
1. Select **Delete assignment**.

> [!NOTE]
> For assignments that target virtual machine scale sets, use Azure CLI or PowerShell.

### [Azure CLI](#tab/cli)

```azurecli
assignmentName=$(az policy assignment list \
  --scope "<scope>" \
  --query "[?id=='<assignment-id>'].name" \
  --output tsv)

az policy assignment delete \
  --name "$assignmentName" \
  --scope "<scope>"
```

### [PowerShell](#tab/powershell)

```powershell
Remove-AzPolicyAssignment -Id "<assignment-id>"
```

---

### Create or identify a data collection rule

Before you assign the replacement initiative, use an existing data collection rule that sends required VM insights data to your Azure Monitor workspace, or create one if needed.

### [Azure portal](#tab/portal)

1. Go to the **Monitor** menu in the Azure portal.
1. In the **Settings** section, select **Data collection rules**.
1. Select **Create** to create a new data collection rule.
1. On the **Basics** tab:
    1. Enter values for **Rule Name**, **Subscription**, **Resource group**, and **Region**.
    1. Select **Agent-based - Windows or Linux (most common)** for the **Type of telemetry**.
1. On the **Collect and deliver** tab:
    1. Select **Add new data source**.
1. On the **Data source** tab:
    1. Select **Otel Performance Counters** for **Data source type**.
    1. Select **system** for the only **Performance counter category**.
  1. On the **Destination** tab:
      1. Select **Add destination**.
      1. Select a **Subscription** and an **Azure Monitor Workspace**.
      1. Select **Apply**.
1. Select **Review + create**.

### [Azure CLI](#tab/cli)

This example uses an existing Azure Monitor workspace, builds a minimal data collection rule definition, and then creates the data collection rule.

```azurecli
resourceGroup="<resource-group>"
workspaceName="<azure-monitor-workspace-name>"
dcrName="<dcr-name>"
dcrDescription="<dcr-description>"
location="<location>"
ruleFile="<path-to-rule-file>.json"

workspaceId=$(az monitor account show \
  --name "$workspaceName" \
  --resource-group "$resourceGroup" \
  --query id \
  --output tsv)

cat <<EOF > "$ruleFile"
{
  "location": "$location",
  "properties": {
    "dataSources": {},
    "destinations": {
      "monitoringAccounts": [
        {
          "accountResourceId": "$workspaceId",
          "name": "MonitoringAccountDestination"
        }
      ]
    },
    "dataFlows": [
      {
        "streams": [
          "Microsoft-OtelPerfMetrics"
        ],
        "destinations": [
          "MonitoringAccountDestination"
        ]
      }
    ]
  }
}
EOF

dcrId=$(az monitor data-collection rule create \
  --location "$location" \
  --resource-group "$resourceGroup" \
  --name "$dcrName" \
  --rule-file "$ruleFile" \
  --description "$dcrDescription" \
  --query id \
  --output tsv)
```

### [PowerShell](#tab/powershell)

```powershell
$ResourceGroup = "<resource-group>"
$WorkspaceName = "<azure-monitor-workspace-name>"
$DcrName = "<dcr-name>"
$Location = "<location>"

$workspace = Get-AzMonitorWorkspace `
  -ResourceGroupName $ResourceGroup `
  -Name $WorkspaceName

$Rule = [ordered]@{
  location = $Location
  properties = [ordered]@{
    dataSources = @{}
    destinations = @{
      monitoringAccounts = @(
        [ordered]@{
          accountResourceId = $workspace.Id
          name = "MonitoringAccountDestination"
        }
      )
    }
    dataFlows = @(
      [ordered]@{
        streams = @("Microsoft-OtelPerfMetrics")
        destinations = @("MonitoringAccountDestination")
      }
    )
  }
} | ConvertTo-Json -Depth 4

$dcr = New-AzDataCollectionRule `
  -Name $DcrName `
  -ResourceGroupName $ResourceGroup `
  -JsonString $Rule
```

---

### Assign the replacement initiative by using an existing user-assigned managed identity

If you already use a user-assigned managed identity for Azure Monitor agent policy assignments, update the assignment to use that identity.

### [Azure portal](#tab/portal)

1. Go to the management group, subscription, resource group, or virtual machine where you want to assign the initiative.
1. Select **Policy**.
1. Search for the initiative by using the `Replacement` value returned by the query.
1. Select **Assign initiative**.
1. On the **Parameters** tab, clear **Only show parameters that need input or review**.
1. Set **Bring Your Own User-Assigned Managed Identity** to `true`.
1. Set **VMI Data Collection Rule Resource Id** to the data collection rule resource ID that you created earlier.
1. Set **User-Assigned Managed Identity Name** to the name of the existing user-assigned managed identity.
1. Set **User-Assigned Managed Identity Resource Group** to the resource group that contains the identity.
1. Review any additional [built-in policy initiative parameters](../agents/azure-monitor-agent-policy.md#built-in-policy-initiatives), and then select **Review + create**.

### [Azure CLI](#tab/cli)

```azurecli
location="<location>"
scope="<scope>"
name="<assignment-name>"
displayName="<assignment-display-name>"
initiative="<replacement-initiative-name>"
resourceGroup="<resource-group>"

identity=$(az identity show \
  --name "<identity-name>" \
  --resource-group "$resourceGroup" \
  --query name \
  --output tsv)

params=$(cat <<EOF
{
  "bringYourOwnUserAssignedManagedIdentity": {"value": true},
  "dcrResourceId": {"value": "$dcrId"},
  "userAssignedManagedIdentityResourceGroup": {"value": "$resourceGroup"},
  "userAssignedManagedIdentityName": {"value": "$identity"}
}
EOF
)

az policy assignment create \
  --mi-system-assigned \
  --location "$location" \
  --scope "$scope" \
  --name "$name" \
  --display-name "$displayName" \
  --policy-set-definition "$initiative" \
  --params "$params"
```

### [PowerShell](#tab/powershell)

```powershell
$Identity = Get-AzUserAssignedIdentity `
  -ResourceGroupName "<resource-group>" `
  -Name "<identity-name>"

$PolicySetDefinition = Get-AzPolicySetDefinition -Name "<replacement-initiative-name>"

$Parameters = @{
  bringYourOwnUserAssignedManagedIdentity = $true
  dcrResourceId = $dcr.Id
  userAssignedManagedIdentityResourceGroup = $Identity.ResourceGroupName
  userAssignedManagedIdentityName = $Identity.Name
}

New-AzPolicyAssignment `
  -Name "<assignment-name>" `
  -DisplayName "<assignment-display-name>" `
  -PolicySetDefinition $PolicySetDefinition `
  -Scope "<scope>" `
  -PolicyParameterObject $Parameters `
  -IdentityType SystemAssigned `
  -Location "<location>"
```

---

### Assign the replacement initiative by using the built-in managed identity option

If you don't provide an existing user-assigned managed identity, use the built-in option instead.

### [Azure portal](#tab/portal)

1. Go to the management group, subscription, resource group, or virtual machine where you want to assign the initiative.
1. Select **Policy**.
1. Search for the initiative by using the `Replacement` value returned by the query.
1. Select **Assign initiative**.
1. On the **Parameters** tab, clear **Only show parameters that need input or review**.
1. Set **Bring Your Own User-Assigned Managed Identity** to `false`.
1. Set **VMI Data Collection Rule Resource Id** to the data collection rule resource ID that you created earlier.
1. Review any additional [built-in policy initiative parameters](../agents/azure-monitor-agent-policy.md#built-in-policy-initiatives), and then select **Review + create**.

### [Azure CLI](#tab/cli)

```azurecli
location="<location>"
scope="<scope>"
name="<assignment-name>"
displayName="<assignment-display-name>"
initiative="<replacement-initiative-name>"

params='{
  "bringYourOwnUserAssignedManagedIdentity": {"value": false},
  "dcrResourceId": {"value": "'$dcrId'"}
}'

az policy assignment create \
  --mi-system-assigned \
  --location "$location" \
  --scope "$scope" \
  --name "$name" \
  --display-name "$displayName" \
  --policy-set-definition "$initiative" \
  --params "$params"
```

### [PowerShell](#tab/powershell)

```powershell
$PolicySetDefinition = Get-AzPolicySetDefinition -Name "<replacement-initiative-name>"

$Parameters = @{
  bringYourOwnUserAssignedManagedIdentity = $false
  dcrResourceId = $dcr.Id
}

New-AzPolicyAssignment `
  -Name "<assignment-name>" `
  -DisplayName "<assignment-display-name>" `
  -PolicySetDefinition $PolicySetDefinition `
  -Scope "<scope>" `
  -PolicyParameterObject $Parameters `
  -IdentityType SystemAssigned `
  -Location "<location>"
```

---

## Update supported initiative assignments

Some supported initiative assignments include parameters that enable Dependency Agent policies. Use the following process to find those assignments and disable the Dependency Agent-related parameters.

### Find supported assignments that enable Dependency Agent

Use the following query file:

- [Initiative assignments that use Dependency Agent](https://msazure.visualstudio.com/InfrastructureInsights/_git/DependencyAgent?path=/tools/retirement/initiative-assignments-using-DA.arg&version=GBmaster)

Run the query by using one of the following methods. Save the query to a local `.kql` file, for example `find-supported-assignments.kql`.

### [Azure portal](#tab/portal)

1. Open [Azure Resource Graph Explorer](/azure/governance/resource-graph/first-query-portal).
1. Set the scope that contains the policy assignments that you want to review.
1. Paste the query from the query file, and then select **Run query**.
1. Record the `AssignmentName`, `AssignmentId`, `Action`, and `RecommendedValue` values for each result.

### [Azure CLI](#tab/cli)

```azurecli
az rest \
  --method POST \
  --url "https://management.azure.com/providers/Microsoft.ResourceGraph/resources?api-version=2022-10-01" \
  --body "$(python3 -c \"import json; q=open('./find-supported-assignments.kql').read(); print(json.dumps({'query': q, 'options': {'resultFormat': 'objectArray'}}))\")"
```

### [PowerShell](#tab/powershell)

```powershell
$query = Get-Content -Path .\find-supported-assignments.kql -Raw
$body = @{
    query = $query
    options = @{ resultFormat = "objectArray" }
} | ConvertTo-Json

Invoke-AzRestMethod `
  -Method POST `
  -Uri "https://management.azure.com/providers/Microsoft.ResourceGraph/resources?api-version=2022-10-01" `
  -Payload $body
```

---

### Map the query action to the parameter you need to change

The query returns an `Action` value for each assignment. Use that value to determine which parameter to change.

| Action | Parameter display name | Parameter ID | Required value |
|:---|:---|:---|:---|
| `1` | Enable Processes and Dependencies | `enableProcessesAndDependencies` | `false` |
| `2` | Effect for policy: Dependency agent should be enabled for listed virtual machine images | `effect-11ac78e3-31bc-4f0c-8434-37ab963cea07` | `Disabled` |
| `3` | Effect for policy: Dependency agent should be enabled in virtual machine scale sets for listed virtual machine images | `effect-e2dd799a-a932-4e9d-ac17-d473bc3c6c10` | `Disabled` |
| `4` | Audit Dependency Agent for Windows VMs monitoring | `ASCDependencyAgentAuditWindowsEffect` | `Disabled` |
| `5` | Audit Dependency Agent for Linux VMs monitoring | `ASCDependencyAgentAuditLinuxEffect` | `Disabled` |
| `6` | No parameterized disable option is currently available. | Not applicable | Not applicable |

> [!NOTE]
> If the query returns action `6`, a parameter-based update isn't currently available for that initiative. Follow product team guidance for offboarding when it becomes available.

### Update the assignment

Update the assignment so that the parameter identified by the query uses the value in the preceding table.

### [Azure portal](#tab/portal)

1. Go to the management group, subscription, resource group, or virtual machine that contains the assignment.
1. Select **Policy**.
1. Search for the assignment by using the value in `AssignmentName`.
1. Open the assignment, and then select **Edit assignment**.
1. Select the **Parameters** tab.
1. Clear **Only show parameters that need input or review**.
1. Find the parameter that matches the `Action` value returned by the query.
1. Set the parameter to the required value from the preceding table.
1. Save the assignment.

> [!NOTE]
> For assignments that target virtual machine scale sets, use Azure CLI or PowerShell.

### [Azure CLI](#tab/cli)

```azurecli
scope="<scope>"
assignmentId="<assignment-id>"
parameterId="<parameter-id>"
value="<value>"

output=$(az policy assignment list \
  --scope "$scope" \
  --query "[?id=='$assignmentId'] | [0].[name,parameters]" \
  --output json | python3 -c "import sys, json; data=json.load(sys.stdin); val='$value'; params=data[1] or {}; params.setdefault('$parameterId', {})['value'] = False if val == 'false' else val; print(data[0]); print(json.dumps(params, separators=(',',':')))" )

assignmentName=$(echo "$output" | sed -n '1p')
params=$(echo "$output" | sed -n '2p')

az policy assignment update \
  --name "$assignmentName" \
  --scope "$scope" \
  --params "$params"
```

### [PowerShell](#tab/powershell)

```powershell
$Assignment = Get-AzPolicyAssignment -Id "<assignment-id>"

$Params = @{}
$Assignment.Parameter.psobject.Properties | ForEach-Object {
  $Params[$_.Name] = $_.Value.value
}

$Value = "<value>"
$Params["<parameter-id>"] = if ($Value -eq "false") { $false } else { $Value }

Set-AzPolicyAssignment `
  -Name $Assignment.Name `
  -Scope $Assignment.Scope `
  -PolicyParameterObject $Params
```

---

## Remove standalone policy assignments

Some environments have direct policy assignments that reference Dependency Agent policy definitions instead of initiatives. Use the following process to identify those assignments and remove them.

### Find standalone policy assignments

Use the following query file:

- [Policy assignments that use Dependency Agent](https://msazure.visualstudio.com/InfrastructureInsights/_git/DependencyAgent?path=/tools/retirement/policy-assignments-using-DA.arg&version=GBmaster)

Run the query by using one of the following methods. Save the query to a local `.kql` file, for example `find-standalone-assignments.kql`.

### [Azure portal](#tab/portal)

1. Open [Azure Resource Graph Explorer](/azure/governance/resource-graph/first-query-portal).
1. Set the scope that contains the policy assignments that you want to review.
1. Paste the query from the query file, and then select **Run query**.
1. Review the `AssignmentName`, `PolicyDisplayName`, `AssignmentId`, and `Scope` values in the results.

### [Azure CLI](#tab/cli)

```azurecli
query=$(cat ./find-standalone-assignments.kql)
az graph query -q "$query" --first 1000
```

### [PowerShell](#tab/powershell)

```powershell
$Query = Get-Content .\find-standalone-assignments.kql -Raw
Search-AzGraph -Query $Query -First 1000
```

---

### Remove the assignment

After you confirm that the assignment targets a standalone Dependency Agent policy, remove it by using one of the following methods.

### [Azure portal](#tab/portal)

1. Go to the management group, subscription, resource group, or virtual machine that contains the assignment.
1. Select **Policy**.
1. Search for the assignment by using the value in `AssignmentName`.
1. Open the assignment.
1. Select **Delete assignment**.

### [Azure CLI](#tab/cli)

```azurecli
assignmentName=$(az policy assignment list \
  --scope "<scope>" \
  --query "[?id=='<assignment-id>'].name" \
  --output tsv)

az policy assignment delete \
  --name "$assignmentName" \
  --scope "<scope>"
```

### [PowerShell](#tab/powershell)

```powershell
Remove-AzPolicyAssignment -Id "<assignment-id>"
```

---

## Related content

- [VM insights Map and Dependency Agent retirement guidance](vminsights-maps-retirement.md)
- [Migrate from Log Analytics agent to Azure Monitor agent](../agents/azure-monitor-agent-migration.md)
- [Use Azure Policy to install and manage the Azure Monitor Agent](../agents/azure-monitor-agent-policy.md)
