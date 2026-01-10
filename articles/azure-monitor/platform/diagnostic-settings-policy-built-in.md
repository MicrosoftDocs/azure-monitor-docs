---
title: Enable Diagnostic Settings by Category Group Using Built-in Policies
description: Use Azure built-in policies to create diagnostic settings in Azure Monitor.
ms.topic: how-to
ms.custom: devx-track-azurecli, devx-track-azurepowershell
ms.date: 07/14/2025
ms.reviewer: lualderm
--- 

# Create diagnostic settings at scale by using built-in Azure policies

[Azure Policy](/azure/governance/policy/overview) provides a method to enable logging at scale with [diagnostic settings](./diagnostic-settings.md) for Azure Monitor. This article describes how to use a set of built-in policies to direct resource logs for [supported resources](#supported-resources) to Log Analytics workspaces, event hubs, and storage accounts.

To create a custom policy definition for a resource type that doesn't have a built-in policy, see [Create diagnostic settings at scale by using custom Azure policies](./diagnostic-settings-policy.md).

## Assign an initiative or policy

An [initiative](/azure/governance/policy/concepts/initiative-definition-structure) is a collection of policies. Rather than assigning multiple policies to a scope, you can assign a single initiative that includes the various policies you need. You can later add policies to this initiative without changing the assignment.

A set of built-in initiatives is available to help you apply diagnostic settings for various destinations. Each destination type has a unique initiative for the `allLogs` and `audit` category groups. Each initiative contains the entire set of built-in policies for the supported resources.

Deploy a built-in initiative or policy for diagnostic settings by using one of the following methods.

### [Azure portal](#tab/portal)

Use the following steps to apply an initiative or policy by using the Azure portal:

1. On the **Policy** page in the Azure portal, select **Definitions**.

2. Set the following filter:

   1. For **Category**, select **Monitoring**.
   2. For **Definition type**, select **Initiative** or **Policy**.

3. Locate and select the initiative or policy that you want to assign:

   * For initiatives, enter **audit** or **allLogs** in the **Search** box and then select the initiative for your destination.

        :::image type="content" source="./media/diagnostic-settings-policy-built-in/initiatives.png" lightbox="./media/diagnostic-settings-policy-built-in/initiatives.png" alt-text="Screenshot that shows a list of initiatives.":::

   * For policies, enter the name of your resource type in the **Search** box and then select the policy for your resource type and destination. The following example sends key vault data to a Log Analytics workspace.

        :::image type="content" source="./media/diagnostic-settings-policy-built-in/policy-definitions.png" lightbox="./media/diagnostic-settings-policy-built-in/policy-definitions.png" alt-text="Screenshot of the pane for policy definitions.":::

4. On the pane for the selected policy, select **Assign initiative**.

    :::image type="content" source="./media/diagnostic-settings-policy-built-in/assign-initiative.png"  lightbox="./media/diagnostic-settings-policy-built-in/assign-initiative.png" alt-text="Screenshot that shows the option to assign an initiative.":::

5. On the **Basics** tab, in the **Scope** box, set a scope for the assignment. The scope can be a management group, subscription, or resource group. The initiative or policy is applied to all resources within the scope.

    :::image type="content" source="./media/diagnostic-settings-policy-built-in/assign-initiatives-basics.png"  lightbox="./media/diagnostic-settings-policy-built-in/assign-initiatives-basics.png" alt-text="Screenshot that shows the Basics tab for assigning an initiative.":::  

6. Select the **Parameters** tab, and then select the specific destination where you want to send the logs. These details vary for each destination type. For more information on the parameters for each destination type, see [Parameters](#parameters) later in this article.

    :::image type="content" source="./media/diagnostic-settings-policy-built-in/assign-initiatives-parameters.png" lightbox="./media/diagnostic-settings-policy-built-in/assign-initiatives-parameters.png" alt-text="Screenshot that shows the Parameters tab for assigning an initiative.":::

7. Select the **Remediation** tab. Creating a remediation task applies the policy to existing resources in the scope. Without a remediation task, the initiative or policy assignment applies only to new resources created after the assignment.

   Select the **Create a remediation task** checkbox, and then ensure that **Create a Managed Identity** is selected. Under **Type of Managed Identity**, select **System assigned managed identity**.

    :::image type="content" source="./media/diagnostic-settings-policy-built-in/assign-policy-remediation.png" lightbox="./media/diagnostic-settings-policy-built-in/assign-policy-remediation.png" alt-text="Screenshot of the Remediation tab and selections for creating a system-assigned managed identity.":::

8. Select **Review + create**, and then select **Create**.

### [PowerShell](#tab/Powershell)

Use the [New-AzPolicyAssignment](/powershell/module/az.resources/new-azpolicyassignment) command to create an assignment for an initiative or policy. The following example shows how to assign the initiative to send logs for the `audit` category group to a Log Analytics workspace.

1. Set up your environment variables:

    ```azurepowershell
    $subscriptionId = <your subscription ID>;
    $rg = Get-AzResourceGroup -Name <your resource group name>;
    Select-AzSubscription $subscriptionId;
    $logAnalyticsWorkspaceId=</subscriptions/$subscriptionId/resourcegroups/$rg.ResourceGroupName/providers/microsoft.operationalinsights/workspaces/<your log analytics workspace>;
    ```

1. Get the definition by using either `Get-AzPolicySetDefinition` for initiatives or `Get-AzPolicyDefinition` for policies:

    ```azurepowershell
    # Initiative
    $definition = Get-AzPolicySetDefinition | Where-Object {$_.DisplayName -eq 'Enable allLogs category group resource logging for supported resources to Log Analytics'}

    # Policy
    $definition = Get-AzPolicyDefinition | Where-Object {$_.DisplayName -eq 'Enable logging by category group for Key vaults (microsoft.keyvault/vaults) to Log Analytics'}
    ```

1. Set an assignment name and configure parameters. For this example, the parameters include the Log Analytics workspace ID. For information on the parameters for other destination types, See [Parameters](#parameters) later in this article.

    ```azurepowershell
    $assignmentName = <your assignment name>;
    $params =  @{"logAnalytics"="/subscriptions/$subscriptionId/resourcegroups/$($rg.ResourceGroupName)/providers/microsoft.operationalinsights/workspaces/<your log analytics workspace>"}  
    ```

1. Create the assignment by using the parameters:

    ```azurepowershell
    $policyAssignment=New-AzPolicyAssignment -Name $assignmentName  -Scope $rg.ResourceId -PolicySetDefinition $definition -PolicyparameterObject $params -IdentityType 'SystemAssigned' -Location eastus
    ```

1. Assign the `Contributor` role to the system-assigned managed identity. For other initiatives, check which roles are required.

    ```azurepowershell
    New-AzRoleAssignment -Scope $rg.ResourceId -ObjectId $policyAssignment.Identity.PrincipalId -RoleDefinitionName Contributor
    ```

1. Scan for policy compliance. The `Start-AzPolicyComplianceScan` command takes a few minutes to return.

    ```azurepowershell
    Start-AzPolicyComplianceScan -ResourceGroupName $rg.ResourceGroupName;
    ```

1. Get a list of resources to remediate and the required parameters by calling `Get-AzPolicyState`:

    ```azurepowershell
    $assignmentState=Get-AzPolicyState -PolicyAssignmentName  $assignmentName -ResourceGroupName $rg.ResourceGroupName;   
    $policyAssignmentId=$assignmentState.PolicyAssignmentId[0];
    $policyDefinitionReferenceIds=$assignmentState.PolicyDefinitionReferenceId;
    ```

1. For each resource type that has noncompliant resources, start a remediation task:

    ```azurepowershell
        $policyDefinitionReferenceIds | ForEach-Object {
              $referenceId = $_
              Start-AzPolicyRemediation -ResourceGroupName $rg.ResourceGroupName  -PolicyAssignmentId $policyAssignmentId   -PolicyDefinitionReferenceId $referenceId -Name "$($rg.ResourceGroupName) remediation $referenceId";
        }
    ```

1. Check the compliance state when the remediation tasks finish:

    ```azurepowershell
    Get-AzPolicyState -PolicyAssignmentName  $assignmentName -ResourceGroupName $rg.ResourceGroupName|select-object IsCompliant, ResourceID
    ```

### [CLI](#tab/cli)

Use the following commands to apply a policy by using the Azure CLI. For more information on policy assignment by using the Azure CLI, see [Azure CLI reference: az policy assignment](/cli/azure/policy/assignment#az-policy-assignment-create).

1. Create a policy assignment by using [`az policy assignment create`](/cli/azure/policy/assignment#az-policy-assignment-create). This step requires the name or ID of the initiative or policy definition instead of the display name.

    ```azurecli
    # Initiative        
    az policy assignment create --name <policy assignment name>  --policy-set-definition "a0a0a0a0-bbbb-cccc-dddd-e1e1e1e1e1e1"  --scope <scope> --params "{\"logAnalytics\": {\"value\": \"<log analytics workspace resource ID>\"}}" --mi-system-assigned --location <location>
    
    # Policy
    az policy assignment create --name <policy assignment name>  --policy "a0a0a0a0-bbbb-cccc-dddd-e1e1e1e1e1e1"  --scope <scope> --params "{\"logAnalytics\": {\"value\": \"<log analytics workspace resource ID"}}" --mi-system-assigned --location <location>
    ```

1. Assign the required role to the identity that you created for the policy assignment. Find the role in the policy definition by searching for `roleDefinitionIds`:

    ```json
       ...},
          "roleDefinitionIds": [
            "/providers/Microsoft.Authorization/roleDefinitions/92aaf0da-9dab-42b6-94a3-d43ce8d16293"
          ],
          "deployment": {
            "properties": {...
    ```

    Assign the required role by using [`az policy assignment identity assign`](/cli/azure/policy/assignment/identity):

    ```azurecli
    az policy assignment identity assign --system-assigned --resource-group <resource group name> --role <role name or ID> --identity-scope </scope> --name <policy assignment name>
    ```

    For example:

    ```azurecli
    az policy assignment identity assign --system-assigned --resource-group rg-001  --role 92aaf0da-9dab-42b6-94a3-d43ce8d16293 --identity-scope /subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/rg001 --name policy-assignment-1
    ```

1. Create remediation tasks for the policies in the initiative.

    Remediation tasks are created per policy. Each task is for a specific `definition-reference-id` parameter, specified in the initiative as `policyDefinitionReferenceId`. To find the `definition-reference-id` parameter, use the following command:

    ```azurecli
    az policy set-definition show --name a0a0a0a0-bbbb-cccc-dddd-e1e1e1e1e1e1 |grep policyDefinitionReferenceId
    ```

    Remediate the resources by using [`az policy remediation create`](/cli/azure/policy/remediation#az-policy-remediation-create):

    ```azurecli
    az policy remediation create --resource-group <resource group name> --policy-assignment <assignment name> --name <remediation task name> --definition-reference-id  "policy specific reference ID"  --resource-discovery-mode ReEvaluateCompliance
    ```

    For example:

    ```azurecli
    az policy remediation create --resource-group "cli-example-01" --policy-assignment assign-cli-example-01 --name "rem-assign-cli-example-01" --definition-reference-id  "keyvault-vaults"  --resource-discovery-mode ReEvaluateCompliance
    ```

    To create a remediation task for all of the policies in the initiative, use the following example:

    ```azurecli
    for policyDefinitionReferenceId in $(az policy set-definition show --name a0a0a0a0-bbbb-cccc-dddd-e1e1e1e1e1e1 |grep policyDefinitionReferenceId |cut -d":" -f2|sed s/\"//g) 
    do 
        az policy remediation create --resource-group "cli-example-01" --policy-assignment assign-cli-example-01 --name remediate-$policyDefinitionReferenceId --definition-reference-id $policyDefinitionReferenceId; 
    done 
    ```

1. Trigger a scan to find existing resources by using [`az policy state trigger-scan`](/cli/azure/policy/state#az-policy-state-trigger-scan):

    ```azurecli
    az policy state trigger-scan --resource-group rg-001
    ```

1. Create a remediation task to apply the policy to existing resources by using [`az policy remediation create`](/cli/azure/policy/remediation#az-policy-remediation-create):

    ```azurecli
    az policy remediation create -g <resource group name> --policy-assignment <policy assignment name> --name <remediation name> 
    ```

    For example:

    ```azurecli
    az policy remediation create -g rg-001 -n remediation-001 --policy-assignment policy-assignment-1
    ```

---

## Create a remediation task

Policies are applied to new resources when they're created. Use a remediation task to apply the policy to existing resources. For an initiative, you must create a remediation task for each policy in the initiative.

Each of the preceding processes includes the steps to create a remediation task when you assign the initiative or policy. You can also create a remediation task after the assignment is created:

1. In the Azure portal, select **Remediation**, and then select your policy.
1. Select **Remediate**.

Track the status of your remediation task on the **Remediation tasks** tab of the **Remediation** pane for the policy.

:::image type="content" source="./media/diagnostic-settings-policy-built-in/remediation-after-assignment.png"  lightbox="./media/diagnostic-settings-policy-built-in/remediation-after-assignment.png" alt-text="Screenshot that shows the Remediation pane for a policy.":::

For more information on remediation tasks, see [Remediate noncompliant resources](/azure/governance/policy/how-to/remediate-resources).

## Parameters

### Common parameters

The following table describes the common parameters for each set of policies and initiatives that create diagnostic settings.

|Parameter|Description|Valid values|Default|
|---|---|---|---|
|`effect`|Parameter to enable or disable the execution of the policy|`DeployIfNotExists`,<br>`AuditIfNotExists`,<br>`Disabled`|`DeployIfNotExists`|
|`diagnosticSettingName`|Diagnostic setting name|Not specified|`setByPolicy-{LogAnalytics\|EventHubs\|Storage}`|
|`categoryGroup`|Diagnostic category group|`none`,<br>`audit`,<br>`allLogs`|`audit`|
|`resourceTypeList`|For initiatives, a list of resource types to be evaluated for the existence of diagnostic settings|Supported resources|All supported resources|

### Log Analytics parameters

The following table describes the parameters for each set of policies and initiatives that use Log Analytics as a destination.

|Parameter|Description|Valid values|Default|
|---|---|---|---|
|`resourceLocationList`|Resource location list to send logs to a nearby Log Analytics workspace. <br>An asterisk (`*`) selects all locations.|Supported locations|`*`|
|`logAnalytics`|Log Analytics workspace.|Not specified|Not specified|

### Event hub parameters

The following table describes the parameters for each set of policies and initiatives that use an event hub as a destination.

|Parameter|Description|Valid values|Default|
|---|---|---|---|
|`resourceLocation`|The resource location must be the same location as the event hub namespace.|Supported locations||
|`eventHubAuthorizationRuleId`|Authorization rule ID for the event hub. The authorization rule is at the level of the event hub namespace. For example: `/subscriptions/{subscription ID}/resourceGroups/{resource group}/providers/Microsoft.EventHub/namespaces/{Event Hub namespace}/authorizationrules/{authorization rule}`|Not specified|Not specified|
|`eventHubName`|Event hub name|Not specified|`Monitoring`|

### Policy parameters for storage accounts

The following table describes the parameters for each set of policies and initiatives that use a storage account as a destination.

|Parameter|Description|Valid values|Default|
|---|---|---|---|
|`resourceLocation`|Resource location, which must be in the same location as the storage account|Supported locations|Not specified|
|`storageAccount`|Resource ID for the storage account|Not specified|Not specified|

## Supported resources

Built-in log policies for Log Analytics workspaces, event hubs, and storage accounts exist for the following resources.

|Resource type|All logs|Audit logs|
|---|---|---|
|`microsoft.aad/domainservices`|Yes|Yes|
|`microsoft.agfoodplatform/farmbeats`|Yes|Yes|
|`microsoft.analysisservices/servers`|Yes|No|
|`microsoft.apimanagement/service`|Yes|Yes|
|`microsoft.app/managedenvironments`|Yes|Yes|
|`microsoft.appconfiguration/configurationstores`|Yes|Yes|
|`microsoft.appplatform/spring`|Yes|No|
|`microsoft.attestation/attestationproviders`|Yes|Yes|
|`microsoft.automation/automationaccounts`|Yes|Yes|
|`microsoft.autonomousdevelopmentplatform/workspaces`|Yes|No|
|`microsoft.avs/privateclouds`|Yes|Yes|
|`microsoft.azureplaywrightservice/accounts`|Yes|Yes|
|`microsoft.azuresphere/catalogs`|Yes|Yes|
|`microsoft.batch/batchaccounts`|Yes|Yes|
|`microsoft.botservice/botservices`|Yes|No|
|`microsoft.cache/redis`|Yes|Yes|
|`microsoft.cache/redisenterprise/databases`|Yes|Yes|
|`microsoft.cdn/cdnwebapplicationfirewallpolicies`|Yes|No|
|`microsoft.cdn/profiles`|Yes|Yes|
|`microsoft.cdn/profiles/endpoints`|Yes|No|
|`microsoft.chaos/experiments`|Yes|Yes|
|`microsoft.classicnetwork/networksecuritygroups`|Yes|No|
|`microsoft.cloudtest/hostedpools`|Yes|No|
|`microsoft.codesigning/codesigningaccounts`|Yes|Yes|
|`microsoft.cognitiveservices/accounts`|Yes|Yes|
|`microsoft.communication/communicationservices`|Yes|No|
|`microsoft.community/communitytrainings`|Yes|Yes|
|`microsoft.confidentialledger/managedccfs`|Yes|Yes|
|`microsoft.connectedcache/enterprisemcccustomers`|Yes|No|
|`microsoft.connectedcache/ispcustomers`|Yes|No|
|`microsoft.containerinstance/containergroups`|Yes|No|
|`microsoft.containerregistry/registries`|Yes|Yes|
|`microsoft.customproviders/resourceproviders`|Yes|No|
|`microsoft.d365customerinsights/instances`|Yes|No|
|`microsoft.dashboard/grafana`|Yes|Yes|
|`microsoft.databricks/workspaces`|Yes|No|
|`microsoft.datafactory/factories`|Yes|No|
|`microsoft.datalakeanalytics/accounts`|Yes|No|
|`microsoft.datalakestore/accounts`|Yes|No|
|`microsoft.dataprotection/backupvaults`|Yes|No|
|`microsoft.datashare/accounts`|Yes|No|
|`microsoft.dbformariadb/servers`|Yes|No|
|`microsoft.dbformysql/flexibleservers`|Yes|Yes|
|`microsoft.dbformysql/servers`|Yes|No|
|`microsoft.dbforpostgresql/flexibleservers`|Yes|Yes|
|`microsoft.dbforpostgresql/servergroupsv2`|Yes|No|
|`microsoft.dbforpostgresql/servers`|Yes|No|
|`microsoft.desktopvirtualization/applicationgroups`|Yes|No|
|`microsoft.desktopvirtualization/hostpools`|Yes|No|
|`microsoft.desktopvirtualization/scalingplans`|Yes|No|
|`microsoft.desktopvirtualization/workspaces`|Yes|No|
|`microsoft.devcenter/devcenters`|Yes|Yes|
|`microsoft.devices/iothubs`|Yes|Yes|
|`microsoft.devices/provisioningservices`|Yes|No|
|`microsoft.digitaltwins/digitaltwinsinstances`|Yes|No|
|`microsoft.documentdb/cassandraclusters`|Yes|Yes|
|`microsoft.documentdb/databaseaccounts`|Yes|Yes|
|`microsoft.documentdb/mongoclusters`|Yes|Yes|
|`microsoft.eventgrid/domains`|Yes|Yes|
|`microsoft.eventgrid/partnernamespaces`|Yes|Yes|
|`microsoft.eventgrid/partnertopics`|Yes|No|
|`microsoft.eventgrid/systemtopics`|Yes|No|
|`microsoft.eventgrid/topics`|Yes|Yes|
|`microsoft.eventhub/namespaces`|Yes|Yes|
|`microsoft.experimentation/experimentworkspaces`|Yes|No|
|`microsoft.healthcareapis/services`|Yes|No|
|`microsoft.healthcareapis/workspaces/dicomservices`|Yes|No|
|`microsoft.healthcareapis/workspaces/fhirservices`|Yes|No|
|`microsoft.healthcareapis/workspaces/iotconnectors`|Yes|No|
|`microsoft.insights/autoscalesettings`|Yes|No|
|`microsoft.insights/components`|Yes|No|
|`microsoft.insights/datacollectionrules`|Yes|No|
|`microsoft.keyvault/managedhsms`|Yes|Yes|
|`microsoft.keyvault/vaults`|Yes|Yes|
|`microsoft.kusto/clusters`|Yes|Yes|
|`microsoft.loadtestservice/loadtests`|Yes|Yes|
|`microsoft.logic/integrationaccounts`|Yes|No|
|`microsoft.logic/workflows`|Yes|No|
|`microsoft.machinelearningservices/registries`|Yes|Yes|
|`microsoft.machinelearningservices/workspaces`|Yes|Yes|
|`microsoft.machinelearningservices/workspaces/onlineendpoints`|Yes|No|
|`microsoft.managednetworkfabric/networkdevices`|Yes|No|
|`microsoft.media/mediaservices`|Yes|Yes|
|`microsoft.media/mediaservices/liveevents`|Yes|Yes|
|`microsoft.media/mediaservices/streamingendpoints`|Yes|Yes|
|`microsoft.netapp/netappaccounts/capacitypools/volumes`|Yes|Yes|
|`microsoft.network/applicationgateways`|Yes|No|
|`microsoft.network/azurefirewalls`|Yes|No|
|`microsoft.network/bastionhosts`|Yes|Yes|
|`microsoft.network/dnsresolverpolicies`|Yes|No|
|`microsoft.network/expressroutecircuits`|Yes|No|
|`microsoft.network/frontdoors`|Yes|Yes|
|`microsoft.network/loadbalancers`|Yes|No|
|`microsoft.network/networkmanagers`|Yes|Yes|
|`microsoft.network/networkmanagers/ipampools`|Yes|Yes|
|`microsoft.network/networksecuritygroups`|Yes|No|
|`microsoft.network/networksecurityperimeters`|Yes|No|
|`microsoft.network/p2svpngateways`|Yes|Yes|
|`microsoft.network/publicipaddresses`|Yes|Yes|
|`microsoft.network/publicipprefixes`|Yes|Yes|
|`microsoft.network/trafficmanagerprofiles`|Yes|No|
|`microsoft.network/virtualnetworkgateways`|Yes|Yes|
|`microsoft.network/virtualnetworks`|Yes|No|
|`microsoft.network/vpngateways`|Yes|No|
|`microsoft.networkanalytics/dataproducts`|Yes|Yes|
|`microsoft.networkcloud/baremetalmachines`|Yes|No|
|`microsoft.networkcloud/clusters`|Yes|No|
|`microsoft.networkcloud/storageappliances`|Yes|No|
|`microsoft.networkfunction/azuretrafficcollectors`|Yes|No|
|`microsoft.notificationhubs/namespaces`|Yes|Yes|
|`microsoft.notificationhubs/namespaces/notificationhubs`|Yes|Yes|
|`microsoft.openenergyplatform/energyservices`|Yes|No|
|`microsoft.operationalinsights/workspaces`|Yes|Yes|
|`microsoft.powerbi/tenants/workspaces`|Yes|No|
|`microsoft.powerbidedicated/capacities`|Yes|No|
|`microsoft.purview/accounts`|Yes|Yes|
|`microsoft.recoveryservices/vaults`|Yes|No|
|`microsoft.relay/namespaces`|Yes|No|
|`microsoft.search/searchservices`|Yes|Yes|
|`microsoft.servicebus/namespaces`|Yes|Yes|
|`microsoft.servicenetworking/trafficcontrollers`|Yes|No|
|`microsoft.signalrservice/signalr`|Yes|Yes|
|`microsoft.signalrservice/webpubsub`|Yes|Yes|
|`microsoft.sql/managedinstances`|Yes|Yes|
|`microsoft.sql/managedinstances/databases`|Yes|No|
|`microsoft.sql/servers/databases`|Yes|Yes|
|`microsoft.storagecache/caches`|Yes|No|
|`microsoft.storagemover/storagemovers`|Yes|No|
|`microsoft.streamanalytics/streamingjobs`|Yes|No|
|`microsoft.synapse/workspaces`|Yes|Yes|
|`microsoft.synapse/workspaces/bigdatapools`|Yes|Yes|
|`microsoft.synapse/workspaces/kustopools`|Yes|Yes|
|`microsoft.synapse/workspaces/scopepools`|Yes|Yes|
|`microsoft.synapse/workspaces/sqlpools`|Yes|Yes|
|`microsoft.timeseriesinsights/environments`|Yes|No|
|`microsoft.timeseriesinsights/environments/eventsources`|Yes|No|
|`microsoft.videoindexer/accounts`|Yes|No|
|`microsoft.web/hostingenvironments`|Yes|Yes|
|`microsoft.workloads/sapvirtualinstances`|Yes|Yes|

## Related content

* [Create diagnostic settings at scale by using Azure Policy](./diagnostic-settings-policy.md)
* [Azure Policy built-in definitions for Azure Monitor](../policy-reference.md)
* [Azure Policy overview](/azure/governance/policy/overview)
* [Azure Enterprise Policy as Code](https://techcommunity.microsoft.com/t5/core-infrastructure-and-security/azure-enterprise-policy-as-code-a-new-approach/ba-p/3607843)
