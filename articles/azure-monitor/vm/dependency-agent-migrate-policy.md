---
title: Migrate Dependency Agent policy and initiative assignments
description: Learn how to find Azure Policy and initiative assignments that use Dependency Agent, replace unsupported initiatives, disable Dependency Agent parameters in supported initiatives, and remove standalone assignments.
ms.service: azure-monitor
ms.topic: how-to
ai-usage: ai-assisted
ms.custom: doc-kit-assisted
ms.date: 07/07/2026
ms.subservice: virtual-machines
---

# Migrate Dependency Agent policy and initiative assignments

The Map feature and the Dependency Agent in VM Insights retire on 30 June 2028. As the retirement date approaches, review any Azure policy and initiative assignments that install or depend on Dependency Agent.  

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

1. Save the query to a local `.kql` file, such as `find-unsupported-assignments.kql`.
1. Run the query with the following command.

```azurecli
az rest --method POST \
  --url "https://management.azure.com/providers/Microsoft.ResourceGraph/resources?api-version=2022-10-01" \
  --body "$(python3 -c "import json; q=open('./find-unsupported-assignments.kql').read(); print(json.dumps({'query': q, 'options': {'resultFormat': 'objectArray'}}))")"
```

### [PowerShell](#tab/powershell)

1. Save the query to a local `.kql` file, such as `find-unsupported-assignments.kql`.
1. Run the query with the following command.

```powershell
$query = Get-Content -Path .\find-unsupported-assignments.kql -Raw
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

### Get a data collection rule resource ID

The replacement initiative requires the resource ID of a data collection rule (DCR) that collects VM insights data to your Azure Monitor workspace. If you don't already have one, migrate your machines to Azure Monitor agent by following [Migrate from Log Analytics agent to Azure Monitor agent](../agents/azure-monitor-agent-migration.md). That migration creates the required DCR. Record the DCR resource ID; you use it in the following section.

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
dcrId="<dcr-resource-id>"

identity="<identity-name>"
identityId=$(az identity show \
  --name "$identity" \
  --resource-group "$resourceGroup" \
  --query id \
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
  --mi-user-assigned "$identityId" \
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
$DcrResourceId = "<dcr-resource-id>"

$Parameters = @{
  bringYourOwnUserAssignedManagedIdentity = $true
  dcrResourceId = $DcrResourceId
  userAssignedManagedIdentityResourceGroup = $Identity.ResourceGroupName
  userAssignedManagedIdentityName = $Identity.Name
}

New-AzPolicyAssignment `
  -Name "<assignment-name>" `
  -DisplayName "<assignment-display-name>" `
  -PolicySetDefinition $PolicySetDefinition `
  -Scope "<scope>" `
  -PolicyParameterObject $Parameters `
  -IdentityType UserAssigned `
  -IdentityId $Identity.Id `
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
dcrId="<dcr-resource-id>"

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
$DcrResourceId = "<dcr-resource-id>"

$Parameters = @{
  bringYourOwnUserAssignedManagedIdentity = $false
  dcrResourceId = $DcrResourceId
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

## Update initiative assignments that enable Dependency Agent

Some initiative assignments include parameters that enable Dependency Agent policies. Use the following process to find those assignments and disable the Dependency Agent-related parameters.

### Find initiative assignments that enable Dependency Agent

Expand the following section to view the query, and then run it by using one of the following methods. Save the query to a local `.kql` file, such as `find-initiative-assignments.kql`.

<details>
<summary><b>Show query</b></summary>

```kusto
policyresources
| where type == "microsoft.authorization/policysetdefinitions"
| where id in (
    '/providers/Microsoft.Authorization/policySetDefinitions/2b00397d-c309-49c4-aa5a-f0b2c5bc6321',
    '/providers/Microsoft.Authorization/policySetDefinitions/924bfe3a-762f-40e7-86dd-5c8b95eb09e6',
    '/providers/Microsoft.Authorization/policySetDefinitions/f5bf694c-cca7-4033-b883-3a23327d5485',
    '/providers/Microsoft.Authorization/policySetDefinitions/7326812a-86a4-40c8-af7c-8945de9c4913',
    '/providers/Microsoft.Authorization/policySetDefinitions/6ce73208-883e-490f-a2ac-44aac3b3687f',
    '/providers/Microsoft.Authorization/policySetDefinitions/60205a79-6280-4e20-a147-e2011e09dc78',
    '/providers/Microsoft.Authorization/policySetDefinitions/53ad89f5-8542-49e9-ba81-1cbd686e0d52',
    '/providers/Microsoft.Authorization/policySetDefinitions/4fcabc2a-30b2-4ba5-9fbb-b1a4e08fb721',
    '/providers/Microsoft.Authorization/policySetDefinitions/4476df0a-18ab-4bfe-b6ad-cccae1cf320f',
    '/providers/Microsoft.Authorization/policySetDefinitions/38916c43-6876-4971-a4b1-806aa7e55ccc',
    '/providers/Microsoft.Authorization/policySetDefinitions/8791506a-dec4-497a-a83f-3abfde37c400',
    '/providers/Microsoft.Authorization/policySetDefinitions/a4087154-2edb-4329-b56a-1cc986807f3c',
    '/providers/Microsoft.Authorization/policySetDefinitions/f8f5293d-df94-484a-a3e7-6b422a999d91',
    '/providers/Microsoft.Authorization/policySetDefinitions/42346945-b531-41d8-9e46-f95057672e88',
    '/providers/Microsoft.Authorization/policySetDefinitions/e3030e83-88d5-4f23-8734-6577a2c97a32',
    '/providers/Microsoft.Authorization/policySetDefinitions/184a0e05-7b06-4a68-bbbe-13b8353bc613',
    '/providers/Microsoft.Authorization/policySetDefinitions/f48ecfa6-581c-43f9-8141-cd4adc72cf26',
    '/providers/Microsoft.Authorization/policySetDefinitions/03055927-78bd-4236-86c0-f36125a10dc9',
    '/providers/Microsoft.Authorization/policySetDefinitions/1f3afdf9-d0c9-4c3d-847f-89da613e70a8',
    '/providers/Microsoft.Authorization/policySetDefinitions/7bc7cd6c-4114-ff31-3cac-59be3157596d',
    '/providers/Microsoft.Authorization/policySetDefinitions/4e50fd13-098b-3206-61d6-d1d78205cb45',
    '/providers/Microsoft.Authorization/policySetDefinitions/7f89f09c-48c1-f28d-1bd5-84f3fb22f86c',
    '/providers/Microsoft.Authorization/policySetDefinitions/abf84fac-f817-a70c-14b5-47eec767458a',
    '/providers/Microsoft.Authorization/policySetDefinitions/d0d5578d-cc08-2b22-31e3-f525374f235a',
    '/providers/Microsoft.Authorization/policySetDefinitions/32ff9e30-4725-4ca7-ba3a-904a7721ee87',
    '/providers/Microsoft.Authorization/policySetDefinitions/3e0c67fc-8c7c-406c-89bd-6b6bdc986a22',
    '/providers/Microsoft.Authorization/policySetDefinitions/89c6cddc-1c73-4ac1-b19c-54d1a15a42f2',
    '/providers/Microsoft.Authorization/policySetDefinitions/046796ef-e8a7-4398-bbe9-cce970b1a3ae',
    '/providers/Microsoft.Authorization/policySetDefinitions/e0d47b75-5d99-442a-9d60-07f2595ab095',
    '/providers/Microsoft.Authorization/policySetDefinitions/e0782c37-30da-4a78-9f92-50bfe7aa2553',
    '/providers/Microsoft.Authorization/policySetDefinitions/d8b2ffbe-c6a8-4622-965d-4ade11d1d2ee',
    '/providers/Microsoft.Authorization/policySetDefinitions/a06d5deb-24aa-4991-9d58-fa7563154e31',
    '/providers/Microsoft.Authorization/policySetDefinitions/175daf90-21e1-4fec-b745-7b4c909aa94c',
    '/providers/Microsoft.Authorization/policySetDefinitions/7499005e-df5a-45d9-810f-041cf346678c',
    '/providers/Microsoft.Authorization/policySetDefinitions/8d792a84-723c-4d92-a3c3-e4ed16a2d133',
    '/providers/Microsoft.Authorization/policySetDefinitions/f9a961fa-3241-4b20-adc4-bbf8ad9d7197',
    '/providers/Microsoft.Authorization/policySetDefinitions/d5264498-16f4-418a-b659-fa7ef418175f',
    '/providers/Microsoft.Authorization/policySetDefinitions/e95f5a9f-57ad-4d03-bb0b-b1d16db93693',
    '/providers/Microsoft.Authorization/policySetDefinitions/cf25b9c1-bd23-4eb6-bd2c-f4f3ac644a5f',
    '/providers/Microsoft.Authorization/policySetDefinitions/179d1daa-458f-4e47-8086-2a68d0d6c38f',
    '/providers/Microsoft.Authorization/policySetDefinitions/f9c0485f-da8e-43b5-961e-58ebd54b907c',
    '/providers/Microsoft.Authorization/policySetDefinitions/a169a624-5599-4385-a696-c8d643089fab',
    '/providers/Microsoft.Authorization/policySetDefinitions/e3ec7e09-768c-4b64-882c-fcada3772047'
)
| join kind=inner (
    policyresources
    | where type == 'microsoft.authorization/policyassignments'
    | extend policyDefinitionId = tostring(properties.policyDefinitionId)
) on $left.id == $right.policyDefinitionId
| extend
    enableProcessAndDependencies = isnotempty(properties.parameters.enableProcessesAndDependencies),
    effectVm = isnotempty(properties.parameters['effect-11ac78e3-31bc-4f0c-8434-37ab963cea07']),
    effectVmss = isnotempty(properties.parameters['effect-e2dd799a-a932-4e9d-ac17-d473bc3c6c10']),
    ASCDependencyAgentAuditWindowsEffect = isnotempty(properties.parameters['ASCDependencyAgentAuditWindowsEffect']),
    ASCDependencyAgentAuditLinuxEffect = isnotempty(properties.parameters['ASCDependencyAgentAuditLinuxEffect']),
    effectAscWindows = isnotempty(properties.parameters['effect-2f2ee1de-44aa-4762-b6bd-0893fc3f306d']),
    effectAscLinux = isnotempty(properties.parameters['effect-04c4380f-3fae-46e8-96c9-30193528f602'])
| extend
    NoParams = not(
        enableProcessAndDependencies or
        effectVm or
        effectVmss or
        ASCDependencyAgentAuditWindowsEffect or
        ASCDependencyAgentAuditLinuxEffect or
        effectAscWindows or
        effectAscLinux
    ),
    enableProcessAndDependencies = (
        enableProcessAndDependencies and
        tobool(properties1.parameters.enableProcessesAndDependencies.value)
    ),
    effectVm = (
        effectVm and (
            isempty(properties1.parameters['effect-11ac78e3-31bc-4f0c-8434-37ab963cea07']) or
            tostring(properties1.parameters['effect-11ac78e3-31bc-4f0c-8434-37ab963cea07'].value) == "AuditIfNotExists"
        )
    ),
    effectVmss = (
        effectVmss and (
            isempty(properties1.parameters['effect-e2dd799a-a932-4e9d-ac17-d473bc3c6c10']) or
            tostring(properties1.parameters['effect-e2dd799a-a932-4e9d-ac17-d473bc3c6c10'].value) == "AuditIfNotExists"
        )
    ),
    ASCDependencyAgentAuditWindowsEffect = (
        ASCDependencyAgentAuditWindowsEffect and (
            isempty(properties1.parameters['ASCDependencyAgentAuditWindowsEffect']) or
            tostring(properties1.parameters['ASCDependencyAgentAuditWindowsEffect'].value) == "AuditIfNotExists"
        )
    ),
    ASCDependencyAgentAuditLinuxEffect = (
        ASCDependencyAgentAuditLinuxEffect and (
            isempty(properties1.parameters['ASCDependencyAgentAuditLinuxEffect']) or
            tostring(properties1.parameters['ASCDependencyAgentAuditLinuxEffect'].value) == "AuditIfNotExists"
        )
    ),
    effectAscWindows = (
        effectAscWindows and (
            isempty(properties1.parameters['effect-2f2ee1de-44aa-4762-b6bd-0893fc3f306d']) or
            tostring(properties1.parameters['effect-2f2ee1de-44aa-4762-b6bd-0893fc3f306d'].value) == "AuditIfNotExists"
        )
    ),
    effectAscLinux = (
        effectAscLinux and (
            isempty(properties1.parameters['effect-04c4380f-3fae-46e8-96c9-30193528f602']) or
            tostring(properties1.parameters['effect-04c4380f-3fae-46e8-96c9-30193528f602'].value) == "AuditIfNotExists"
        )
    )
| where enableProcessAndDependencies or effectVm or effectVmss or ASCDependencyAgentAuditWindowsEffect or ASCDependencyAgentAuditLinuxEffect or effectAscWindows or effectAscLinux or NoParams
| extend Scope = tostring(properties1.scope)
| extend
    ResourceContainerId = iff(isnotempty(subscriptionId1), strcat("/subscriptions/", tolower(subscriptionId1)), tolower(Scope))
| join kind=leftouter (
    resourcecontainers
    | extend ResourceContainerId = tolower(id)
) on ResourceContainerId
| extend
    ExtractedTypeAndName = extract_all(@"([^/]+)/([^/]+)$", Scope)[0],
    ResourceContainerName = iff(isnull(properties2.displayName), name2, tostring(properties2.displayName))
| extend
    ResourceType = ExtractedTypeAndName[0],
    DisplayName = tostring(properties1.displayName),
    Parameters = bag_pack (
        "1", enableProcessAndDependencies,
        "2", effectVm,
        "3", effectVmss,
        "4", ASCDependencyAgentAuditWindowsEffect,
        "5", ASCDependencyAgentAuditLinuxEffect,
        "6", effectAscWindows,
        "7", effectAscLinux,
        "8", NoParams
    )
| mv-expand kind=array Parameter = Parameters
| where tobool(Parameter[1])
| summarize
        Actions=strcat_array(make_list(Parameter[0]), ", ")
    by
        Resource = case (
            ResourceType =~ 'subscriptions', ResourceContainerName,
            ResourceType =~ 'resourcegroups', strcat(ResourceContainerName, '/', resourceGroup1),
            ResourceType =~ 'managementgroups', iff(isnotempty(ResourceContainerName), ResourceContainerName, ExtractedTypeAndName[1]),
            strcat(ResourceContainerName, '/', resourceGroup1, '/', ExtractedTypeAndName[1])
        ),
        tostring(ResourceType),
        AssignmentName = iff(isnotempty(DisplayName), DisplayName, name1),
        AssignmentId=id1,
        Scope
| sort by
    tolower(Resource) asc,
    tolower(ResourceType) asc,
    tolower(AssignmentName) asc
```

</details>

### [Azure portal](#tab/portal)

1. Open [Azure Resource Graph Explorer](/azure/governance/resource-graph/first-query-portal).
1. Set the scope that contains the policy assignments that you want to review.
1. Paste the query from the preceding section, and then select **Run query**.
1. Record the `AssignmentName`, `AssignmentId`, `Scope`, and `Actions` values for each result. The `Actions` value is a comma-separated list of action numbers. Look up each number in the mapping table in the next section to determine the parameter change to apply.

### [Azure CLI](#tab/cli)

```azurecli
az rest --method POST \
  --url "https://management.azure.com/providers/Microsoft.ResourceGraph/resources?api-version=2022-10-01" \
  --body "$(python3 -c "import json; q=open('./find-initiative-assignments.kql').read(); print(json.dumps({'query': q, 'options': {'resultFormat': 'objectArray'}}))")"
```

### [PowerShell](#tab/powershell)

```powershell
$query = Get-Content -Path .\find-initiative-assignments.kql -Raw
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
| `6` | Effect for policy: Network traffic data collection agent should be installed on Windows virtual machines | `effect-2f2ee1de-44aa-4762-b6bd-0893fc3f306d` | `Disabled` |
| `7` | Effect for policy: Network traffic data collection agent should be installed on Linux virtual machines | `effect-04c4380f-3fae-46e8-96c9-30193528f602` | `Disabled` |
| `8` | Initiative has no parameter to disable Dependency Agent policies | Not applicable | Not applicable |

> [!NOTE]
> If the query returns action `8`, the assignment uses an initiative that includes Dependency Agent policies but doesn't expose parameters to disable them. To offboard from Dependency Agent under this initiative, remove the assignment. If you still need the other policies in the initiative, create a custom initiative that excludes the Dependency Agent policies and assign that instead.

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

Expand the following section to view the query, and then run it by using one of the following methods. Save the query to a local `.kql` file, such as `find-standalone-assignments.kql`.

<details>
<summary><b>Show query</b></summary>

```kusto
policyresources
| where type == 'microsoft.authorization/policyassignments'
| where properties.policyDefinitionId in (
    '/providers/Microsoft.Authorization/policyDefinitions/053d3325-282c-4e5c-b944-24faffd30d77',
    '/providers/Microsoft.Authorization/policyDefinitions/08a4470f-b26d-428d-97f4-7e3e9c92b366',
    '/providers/Microsoft.Authorization/policyDefinitions/11ac78e3-31bc-4f0c-8434-37ab963cea07',
    '/providers/Microsoft.Authorization/policyDefinitions/1c210e94-a481-4beb-95fa-1571b434fb04',
    '/providers/Microsoft.Authorization/policyDefinitions/2fea0c12-e7d4-4e03-b7bf-c34b2b8d787d',
    '/providers/Microsoft.Authorization/policyDefinitions/32133ab0-ee4b-4b44-98d6-042180979d50',
    '/providers/Microsoft.Authorization/policyDefinitions/3be22e3b-d919-47aa-805e-8985dbeb0ad9',
    '/providers/Microsoft.Authorization/policyDefinitions/4da21710-ce6f-4e06-8cdb-5cc4c93ffbee',
    '/providers/Microsoft.Authorization/policyDefinitions/5c3bc7b8-a64c-4e08-a9cd-7ff0f31e1138',
    '/providers/Microsoft.Authorization/policyDefinitions/5ee9e9ed-0b42-41b7-8c9c-3cfb2fbe2069',
    '/providers/Microsoft.Authorization/policyDefinitions/765266ab-e40e-4c61-bcb2-5a5275d0b7c0',
    '/providers/Microsoft.Authorization/policyDefinitions/7c4214e9-ea57-487a-b38e-310ec09bc21d',
    '/providers/Microsoft.Authorization/policyDefinitions/84cfed75-dfd4-421b-93df-725b479d356a',
    '/providers/Microsoft.Authorization/policyDefinitions/89ca9cc7-25cd-4d53-97ba-445ca7a1f222',
    '/providers/Microsoft.Authorization/policyDefinitions/91cb9edd-cd92-4d2f-b2f2-bdd8d065a3d4',
    '/providers/Microsoft.Authorization/policyDefinitions/a0f27bdc-5b15-4810-b81d-7c4df9df1a37',
    '/providers/Microsoft.Authorization/policyDefinitions/af0082fd-fa58-4349-b916-b0e47abb0935',
    '/providers/Microsoft.Authorization/policyDefinitions/c7f3bf36-b807-4f18-82dc-f480ad713635',
    '/providers/Microsoft.Authorization/policyDefinitions/d55b81e1-984f-4a96-acab-fae204e3ca7f',
    '/providers/Microsoft.Authorization/policyDefinitions/deacecc0-9f84-44d2-bb82-46f32d766d43',
    '/providers/Microsoft.Authorization/policyDefinitions/e2dd799a-a932-4e9d-ac17-d473bc3c6c10',
    '/providers/Microsoft.Authorization/policyDefinitions/f47b5582-33ec-4c5c-87c0-b010a6b2e917',
    '/providers/Microsoft.Authorization/policyDefinitions/2f2ee1de-44aa-4762-b6bd-0893fc3f306d',
    '/providers/Microsoft.Authorization/policyDefinitions/04c4380f-3fae-46e8-96c9-30193528f602'
)
| extend Scope = tostring(properties.scope)
| extend
    ResourceContainerId = iff(isnotempty(subscriptionId), strcat("/subscriptions/", tolower(subscriptionId)), tolower(Scope))
| join kind=leftouter (
    resourcecontainers
    | extend ResourceContainerId = tolower(id)
) on ResourceContainerId
| extend
    ExtractedTypeAndName = extract_all(@"([^/]+)/([^/]+)$", Scope)[0],
    ResourceContainerName = iff(isnull(properties1.displayName), name1, tostring(properties1.displayName))
| extend
    ResourceType = ExtractedTypeAndName[0],
    DisplayName = tostring(properties.displayName)
| project
    Resource = case (
        ResourceType =~ 'subscriptions', ResourceContainerName,
        ResourceType =~ 'resourcegroups', strcat(ResourceContainerName, '/', resourceGroup),
        ResourceType =~ 'managementgroups', iff(isnotempty(ResourceContainerName), ResourceContainerName, ExtractedTypeAndName[1]),
        strcat(ResourceContainerName, '/', resourceGroup, '/', ExtractedTypeAndName[1])
    ),
    ResourceType,
    AssignmentName = iff(isnotempty(DisplayName), DisplayName, name),
    AssignmentId=id,
    Scope
| sort by
    tolower(Resource) asc,
    tolower(ResourceType) asc,
    tolower(AssignmentName) asc
```

</details>

### [Azure portal](#tab/portal)

1. Open [Azure Resource Graph Explorer](/azure/governance/resource-graph/first-query-portal).
1. Set the scope that contains the policy assignments that you want to review.
1. Paste the query from the preceding section, and then select **Run query**.
1. Review the `AssignmentName`, `AssignmentId`, `Scope`, and `ResourceType` values in the results. The query already filters to policy assignments that reference known Dependency Agent policy definitions, so any result represents an assignment to remove.

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
