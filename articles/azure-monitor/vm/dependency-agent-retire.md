---
title: Migrate Dependency Agent policy and initiative assignments
description: Identify and update Azure Policy and initiative assignments that use Dependency Agent as VM insights Map approaches retirement.
ai-usage: ai-assisted
ms.topic: how-to
ms.date: 03/17/2026
ms.subservice: virtual-machines
---

# Migrate Dependency Agent policy and initiative assignments

As VM insights Map and Dependency Agent approach retirement, review any Azure Policy and initiative assignments that still install or depend on Dependency Agent. This article explains how to identify unsupported assignments, replace them when a supported alternative exists, and remove or disable remaining assignments that reference Dependency Agent.

For retirement dates and overall product impact, see [VM insights Map and Dependency Agent retirement guidance](vminsights-maps-retirement.md). For migration guidance, see [Migrate from Log Analytics agent to Azure Monitor agent](../agents/azure-monitor-agent-migration.md).

## Before you begin

- Review the retirement guidance and determine whether you can move affected machines to Azure Monitor agent.
- Make sure you have permission to read Azure Resource Graph data and manage Azure Policy assignments at the target scope.
- If you plan to assign a replacement initiative, decide whether you'll use an existing user-assigned managed identity or let the initiative use the built-in option.

> [!IMPORTANT]
> This article links to product team query files for identifying Dependency Agent policy usage. Replace those links with a public source before publishing this article externally.

## Handle unsupported initiative assignments

Some initiatives that use Dependency Agent are no longer supported. Use the query in this section to find unsupported assignments and identify the recommended replacement initiative.

### Run the query

Use the following query file:

- [Unsupported initiatives that use Dependency Agent](https://msazure.visualstudio.com/InfrastructureInsights/_git/DependencyAgent?path=/tools/retirement/unsupported-initiatives-using-DA.arg&version=GBmaster)

You can run the query in any of the following ways:

- Azure portal: Open [Azure Resource Graph Explorer](/azure/governance/resource-graph/first-query-portal), paste the query, and run it at the required scope.
- Azure CLI: Follow [Quickstart: Run a Resource Graph query by using Azure CLI](/azure/governance/resource-graph/first-query-azurecli).
- PowerShell: Follow [Quickstart: Run a Resource Graph query by using Azure PowerShell](/azure/governance/resource-graph/first-query-powershell).

The query output identifies unsupported assignments and the replacement initiative to use.

### Remove the unsupported assignment

If the query returns an unsupported initiative assignment, remove it before you create the replacement assignment.

#### Azure portal

1. Go to the management group, subscription, resource group, or virtual machine that contains the assignment.
1. Select **Policy**.
1. Search for the assignment by using the value in `AssignmentName`.
1. Open the assignment.
1. Select **Delete assignment**.

> [!NOTE]
> For assignments that target virtual machine scale sets, use Azure CLI or PowerShell.

#### Azure CLI

```azurecli
assignmentName=$(az policy assignment list \
  --scope "<scope>" \
  --query "[?id=='<assignment-id>'].name" \
  --output tsv)

az policy assignment delete \
  --name "$assignmentName" \
  --scope "<scope>"
```

#### PowerShell

```powershell
Remove-AzPolicyAssignment -Id "<assignment-id>"
```

### Assign the replacement initiative

Create a data collection rule, and then assign the replacement initiative that the query returned.

#### Create a data collection rule

##### Azure portal

1. Search for **Data Collection Rules** in the Azure portal.
1. Select **Create**.
1. Enter the required values to create the data collection rule.
1. For detailed steps, see [Create and edit a data collection rule](../data-collection/data-collection-rule-create-edit.md?tabs=cli).

##### Azure CLI

This example creates an Azure Monitor workspace if needed, builds a minimal data collection rule definition, and then creates the data collection rule.

```bash
resourceGroup="<resource-group>"
workspaceName="<azure-monitor-workspace-name>"
dcrName="<dcr-name>"
dcrDescription="<dcr-description>"
location="<location>"
ruleFile="<path-to-rule-file>.json"

workspaceId=$(az monitor account create \
  --name "$workspaceName" \
  --resource-group "$resourceGroup" \
  --location "$location" \
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

##### PowerShell

```powershell
$ResourceGroup = "<resource-group>"
$WorkspaceName = "<azure-monitor-workspace-name>"
$DcrName = "<dcr-name>"
$Location = "<location>"

$workspace = New-AzMonitorWorkspace `
  -ResourceGroupName $ResourceGroup `
  -Name $WorkspaceName `
  -Location $Location

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

#### Use an existing user-assigned managed identity

##### Azure portal

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

##### Azure CLI

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

##### PowerShell

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

#### Use the built-in managed identity option

##### Azure portal

1. Go to the management group, subscription, resource group, or virtual machine where you want to assign the initiative.
1. Select **Policy**.
1. Search for the initiative by using the `Replacement` value returned by the query.
1. Select **Assign initiative**.
1. On the **Parameters** tab, clear **Only show parameters that need input or review**.
1. Set **Bring Your Own User-Assigned Managed Identity** to `false`.
1. Set **VMI Data Collection Rule Resource Id** to the data collection rule resource ID that you created earlier.
1. Review any additional [built-in policy initiative parameters](../agents/azure-monitor-agent-policy.md#built-in-policy-initiatives), and then select **Review + create**.

##### Azure CLI

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

##### PowerShell

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

## Update initiative assignments that still include Dependency Agent policies

Some initiative assignments are still supported, but they include parameters that enable Dependency Agent policies. Use the query in this section to find those assignments and then disable the Dependency Agent-related parameters.

### Run the query

Use the following query file:

- [Initiative assignments that use Dependency Agent](https://msazure.visualstudio.com/InfrastructureInsights/_git/DependencyAgent?path=/tools/retirement/initiative-assignments-using-DA.arg&version=GBmaster)

You can run the query in any of the following ways:

- Azure portal: Open [Azure Resource Graph Explorer](/azure/governance/resource-graph/first-query-portal), paste the query, and run it at the required scope.
- Azure CLI: Follow [Quickstart: Run a Resource Graph query by using Azure CLI](/azure/governance/resource-graph/first-query-azurecli).
- PowerShell: Follow [Quickstart: Run a Resource Graph query by using Azure PowerShell](/azure/governance/resource-graph/first-query-powershell).

### Map the query action to the parameter you need to change

The query returns an `Action` value for each assignment. Use that value to determine which parameter to change.

| Action | Parameter display name | Parameter ID | Value |
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

#### Azure portal

1. Go to the management group, subscription, resource group, or virtual machine that contains the assignment.
1. Select **Policy**.
1. Search for the assignment by using the value in `AssignmentName`.
1. Open the assignment, and then select **Edit assignment**.
1. Select the **Parameters** tab.
1. Clear **Only show parameters that need input or review**.
1. Find the parameter that matches the `Action` value from the query output.
1. Set the parameter to the required value from the preceding table.
1. Save the assignment.

> [!NOTE]
> For assignments that target virtual machine scale sets, use Azure CLI or PowerShell.

#### Azure CLI

```bash
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

#### PowerShell

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

## Remove standalone Dependency Agent policy assignments

Some environments have direct policy assignments that reference Dependency Agent policy definitions rather than initiatives. Use the query in this section to identify those assignments and remove them.

### Run the query

Use the following query file:

- [Policy assignments that use Dependency Agent](https://msazure.visualstudio.com/InfrastructureInsights/_git/DependencyAgent?path=/tools/retirement/policy-assignments-using-DA.arg&version=GBmaster)

You can run the query in any of the following ways:

- Azure portal: Open [Azure Resource Graph Explorer](/azure/governance/resource-graph/first-query-portal), paste the query, and run it at the required scope.
- Azure CLI: Follow [Quickstart: Run a Resource Graph query by using Azure CLI](/azure/governance/resource-graph/first-query-azurecli).
- PowerShell: Follow [Quickstart: Run a Resource Graph query by using Azure PowerShell](/azure/governance/resource-graph/first-query-powershell).

### Remove the assignment

Use the same removal process described in [Remove the unsupported assignment](#remove-the-unsupported-assignment).

## Related content

- [VM insights Map and Dependency Agent retirement guidance](./vminsights-maps-retirement.md) - Review retirement dates, impact, and the overall transition guidance.
- [Migrate from Log Analytics agent to Azure Monitor agent](../agents/azure-monitor-agent-migration.md) - Move off the legacy agent if affected machines still use it.
- [Enable VM monitoring in Azure Monitor](./vm-enable-monitoring.md) - Configure current VM monitoring by using Azure Monitor agent and data collection rules.
- [Azure Monitor Agent built-in policy initiatives](../agents/azure-monitor-agent-policy.md#built-in-policy-initiatives) - Review the supported policy initiatives used to deploy Azure Monitor agent.
