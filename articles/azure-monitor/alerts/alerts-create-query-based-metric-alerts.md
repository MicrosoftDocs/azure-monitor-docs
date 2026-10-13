---
title: Create Query-Based Metric Alerts (Preview)
description: This article explains how to create query-based metric alert rules in Azure Monitor using PromQL, covering prerequisites, rule configuration options, managed identity requirements, deployment methods, and how to view and manage alerts in the Azure portal.
ms.topic: how-to
ms.custom: cbo-v1.6
ms.date: 07/29/2026
ai-usage: ai-assisted
---

# Create query-based metric alerts (Preview)

This article explains how to create query-based metric alert rules in Azure Monitor using PromQL, covering prerequisites, rule configuration options, managed identity requirements, deployment methods, and how to view and manage alerts in the Azure portal.

## Prerequisites

> [!div class="checklist"]
> * Read the [query based metric alerts overview](alerts-query-based-metric-alerts-overview.md).
> * A system-assigned or user-assigned managed identity. To use a user-assigned managed identity with your query-based metric alert rules, create the managed identity in advance and configure it with *Monitoring Reader* role (or equivalent permissions) on the rule scope. For more information about creating and using managed identities, see [Azure managed identities](/entra/identity/managed-identities-azure-resources/overview).
> * A resource emitting Prometheus or OTel-based metrics to an Azure Monitor Workspace (AMW). The resources currently supported are Azure Kubernetes Service (AKS), Azure virtual machines, Arc-enabled servers or Arc-enabled clusters. Custom OTel metrics emitted directly to AMW by your workload are also supported. For more information, see:
>     * [Enable Azure Monitor managed service for Prometheus](/azure/azure-monitor/metrics/prometheus-metrics-overview#enable-azure-monitor-managed-service-for-prometheus).
>     * [Enable Prometheus and Grafana](/azure/azure-monitor/containers/kubernetes-monitoring-enable?tabs=cli#enable-prometheus-and-grafana) for details.
> * To create resource-centric alert rules, your Azure Monitor Workspace must be [enabled for resource-centric stamping and access](#enable-workspace-resource-centric-stamping-and-access).

## Enable workspace resource-centric stamping and access

Enable resource-centric stamping and access for a workspace by using one of the following methods:

# [Azure CLI](#tab/cli)

The following Azure CLI example uses the [`az monitor account create`](/cli/azure/monitor/account#az-monitor-account-create) command. It enables resource-centric stamping and access by using the `--enable-access-using-resource-permissions` parameter.

```bash
# Set variables
resourceGroupName="<ResourceGroupName>"
accountName="<AccountName>"
azureRegion="<AzureRegion>"

# Enable resource-centric stamping and access
az monitor account create \
  --resource-group "$resourceGroupName" \
  --name "$accountName" \
  --location "$azureRegion" \
  --enable-access-using-resource-permissions true
```

[!INCLUDE [Azure CLI default endpoint](../includes/cli-default-endpoint.md)]

# [Azure PowerShell](#tab/powershell)

The following Azure PowerShell example uses the [`New-AzMonitorWorkspace`](/powershell/module/az.monitor/new-azmonitorworkspace) cmdlet. It enables resource-centric stamping and access by using the `-MetricEnableAccessUsingResourcePermission` parameter.

```powershell
# Set variables
$resourceGroupName = "<ResourceGroupName>"
$accountName = "<AccountName>"
$azureRegion = "<AzureRegion>"

# Define parameters for New-AzMonitorWorkspace
$newAzMonitorWorkspaceParams = @{
    ResourceGroupName                         = $resourceGroupName
    Name                                      = $accountName
    Location                                  = $azureRegion
    MetricEnableAccessUsingResourcePermission = $true
}

# Enable resource-centric stamping and access
New-AzMonitorWorkspace @newAzMonitorWorkspaceParams
```

[!INCLUDE [Azure PowerShell default endpoint](../includes/powershell-default-endpoint.md)]

# [REST](#tab/rest)

The following REST example uses the [`Azure Monitor Workspaces - Create Or Update`](../fundamentals/azure-monitor-rest-api-index.md#op-monitor-azure-monitor-workspaces) REST API operation.

```REST
PUT https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Monitor/accounts/{accountName}?api-version={apiVersion}
Authorization: Bearer {accessToken}
Content-Type: application/json

{
  "location": "<AzureRegion>",
  "properties": {
    "metrics": {
      "enableAccessUsingResourcePermissions": true
    }
  }
}
```

# [Bicep](#tab/bicep)

> [!NOTE]
> Template deployments are create-or-update operations, not partial PATCH operations. Retain the complete configuration of your existing Azure Monitor workspace when adapting this example.

The following Bicep example uses the [`Microsoft.Monitor/accounts`](/azure/templates/microsoft.monitor/accounts?pivots=deployment-language-bicep) resource type.

This template includes the workspace resource declaration and its resource-centric access setting. Before using it to update an existing workspace:

* Set `accountName` and `azureRegion` to the existing workspace's name and region.
* Set `properties.metrics.enableAccessUsingResourcePermissions` to `true`. Don't replace the existing `metrics` or `properties` object with only the members shown.
* Retain the other members of `metrics` and `properties`, including `publicNetworkAccess`, from your maintained definition.
* Keep the workspace's `name`, `location`, `identity`, and `tags` unchanged.
* Keep all other resource declarations in your complete template.
* Don't deploy this example unchanged over an existing workspace. It shows the access setting, not your workspace's complete configuration.

```bicep
param accountName string = '<AccountName>'
param azureRegion string = '<AzureRegion>'

resource monitorWorkspace 'Microsoft.Monitor/accounts@<ApiVersion>' = {
  name: accountName
  location: azureRegion
  properties: {
    metrics: {
      enableAccessUsingResourcePermissions: true
    }
  }
}
```

# [ARM template](#tab/arm)

> [!NOTE]
> Template deployments are create-or-update operations, not partial PATCH operations. Retain the complete configuration of your existing Azure Monitor workspace when adapting this example.

The following ARM template example uses the [`Microsoft.Monitor/accounts`](/azure/templates/microsoft.monitor/accounts?pivots=deployment-language-arm-template) resource type.

This template includes the workspace resource declaration and its resource-centric access setting. Before using it to update an existing workspace:

* Set `accountName` and `azureRegion` to the existing workspace's name and region.
* Set `properties.metrics.enableAccessUsingResourcePermissions` to `true`. Don't replace the existing `metrics` or `properties` object with only the members shown.
* Retain the other members of `metrics` and `properties`, including `publicNetworkAccess`, from your maintained definition.
* Keep the workspace's `name`, `location`, `identity`, and `tags` unchanged.
* Keep all other resource declarations in your complete template.
* Don't deploy this example unchanged over an existing workspace. It shows the access setting, not your workspace's complete configuration.

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "accountName": {
      "type": "string",
      "defaultValue": "<AccountName>"
    },
    "azureRegion": {
      "type": "string",
      "defaultValue": "<AzureRegion>"
    }
  },
  "resources": [
    {
      "type": "Microsoft.Monitor/accounts",
      "apiVersion": "<ApiVersion>",
      "name": "[parameters('accountName')]",
      "location": "[parameters('azureRegion')]",
      "properties": {
        "metrics": {
          "enableAccessUsingResourcePermissions": true
        }
      }
    }
  ]
}
```

---

## Deploy a query-based metric alert

Create and configure query-based metric alert rules by using the Azure portal or one of the programmatic approaches in this section. The REST, Azure CLI, and Azure PowerShell examples use direct REST requests to create or update the alert rule, while the Bicep and ARM template examples use deployment templates.

The examples in this section create a resource-centric, query-based metric alert rule that uses an Azure Kubernetes Service (AKS) cluster as its scope and a user-assigned managed identity. The following sections describe some of the required properties and configuration options.

# [Portal](#tab/portal-2)

> [!NOTE]
> In the Azure portal, select only one resource type at a time. For example, you can't select virtual machines and Kubernetes services.
<!--
> [!VIDEO f94188c4-ca77-41bd-984f-cda31a59a41b]
-->
From the *Create an alert rule* page:

1. Select **Select scope**. The Select a resource screen appears.

1. From the **Subscription** dropdown list, select one or more subscriptions checkboxes. All resource groups within that chosen subscription appear.

1. From the Resource types dropdown list, filter for *Virtual machines*,  *Azure Monitor Workspaces*, *Kubernetes services* or choose an entire resource group or subscription.

1. Select the checkbox next to the resources you want to use.

1. Select **Apply**.

1. Select **Next: Condition** or the **Condition** tab.

1. From the **Signal** dropdown list, either:

    * See all signals to use a previously created PromQL query, then select the query you want to use. The PromQL field appears populated with the query. Then, continue to edit the query in the editor field.
    * Custom PromQL query to create a new one. The PromQL field appears empty and ready for your query editing. Enter the PromQL query in the field.

1. Select the Alerting options:

    1. From the **Check every** dropdown list, select the checking interval.
    1. From the **Wait for** dropdown list, select the delay time for the alert. Default is no delay.

1. From here, configure the alert as you would any other alert. See the other alert creation guides in the documentation.

# [Azure CLI](#tab/cli-2)

The following Azure CLI example uses [az rest](/cli/azure/reference-index#az-rest) to call the [`Metric Alerts - Create Or Update`](../fundamentals/azure-monitor-rest-api-index.md#op-monitor-metric-alerts) REST API operation.

```bash
# Set variables
resourceGroupName="<ResourceGroupName>"
ruleName="<RuleName>"
apiVersion="<ApiVersion>"
payloadFile="./query-based-metric-alert.json"

# Get the subscription ID from the current Azure CLI context
subscriptionId=$(az account show --query id --output tsv)

# Build request URL
apiEndpoint="https://management.azure.com"
path="/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName"
provider="Microsoft.Insights/metricAlerts/$ruleName"
queryString="?api-version=$apiVersion"
url="$apiEndpoint$path/providers/$provider$queryString"

# Create the query-based metric alert rule
az rest --method put --url "$url" --body "@$payloadFile"
```

**Payload file (query-based-metric-alert.json):**

<br>
<details>
<summary>Create resource-centric query-based metric alert rule with user-assigned identity</summary>

```json
{
  "location": "<AzureRegion>",
  "identity": {
    "type": "UserAssigned",
    "userAssignedIdentities": {
      "/subscriptions/<SubscriptionId>/resourceGroups/<ResourceGroupName>/providers/Microsoft.ManagedIdentity/userAssignedIdentities/<UserAssignedMiName>": {}
    }
  },
  "properties": {
    "enabled": true,
    "description": "Sample query-based metric alert rule",
    "severity": 3,
    "targetResourceType": "microsoft.monitor/accounts",
    "scopes": [
      "/subscriptions/<SubscriptionId>/resourceGroups/<ResourceGroupName>/providers/Microsoft.ContainerService/managedClusters/<ClusterName>"
    ],
    "evaluationFrequency": "PT1M",
    "criteria": {
      "allOf": [
        {
          "name": "KubeContainerOOMKilledCount",
          "query": "sum by (cluster,container,controller,namespace)(kube_pod_container_status_last_terminated_reason{reason=\"OOMKilled\"} * on(cluster,namespace,pod) group_left(controller) label_replace(kube_pod_owner, \"controller\", \"$1\", \"owner_name\", \"(.*)\")) > 0",
          "criterionType": "StaticThresholdCriterion"
        }
      ],
      "odata.type": "Microsoft.Azure.Monitor.PromQLCriteria",
      "failingPeriods": {
        "for": "PT5M"
      }
    },
    "resolveConfiguration": {
      "autoResolved": true,
      "timeToResolve": "PT2M"
    },
    "actions": [
      {
        "actionGroupId": "/subscriptions/<SubscriptionId>/resourceGroups/<ResourceGroupName>/providers/Microsoft.Insights/actionGroups/<ActionGroupName>"
      }
    ],
    "actionProperties": {
      "Email.Subject": "Prometheus alert - Container killed due to OOM in cluster: ${data.alertContext.condition.allOf[0].dimensions.cluster} in pod: ${data.alertContext.condition.allOf[0].dimensions.pod} container: ${data.alertContext.condition.allOf[0].dimensions.container}"
    },
    "customProperties": {
      "Alert Summary": "Prometheus alert - Container killed due to OOM in cluster: ${data.alertContext.condition.allOf[0].dimensions.cluster} in pod: ${data.alertContext.condition.allOf[0].dimensions.pod} container: ${data.alertContext.condition.allOf[0].dimensions.container}"
    }
  }
}
```

</details>

# [Azure PowerShell](#tab/powershell-2)

The following Azure PowerShell example uses [Invoke-AzRestMethod](/powershell/module/az.accounts/invoke-azrestmethod) to call the [`Metric Alerts - Create Or Update`](../fundamentals/azure-monitor-rest-api-index.md#op-monitor-metric-alerts) REST API operation.

```powershell
# Set variables
$resourceGroupName = "<ResourceGroupName>"
$ruleName = "<RuleName>"
$apiVersion = "<ApiVersion>"
$payloadFile = "./query-based-metric-alert.json"

# Get the subscription ID from the current Azure PowerShell context
$subscriptionId = (Get-AzContext).Subscription.Id

# Build request URL
$apiEndpoint = "https://management.azure.com"
$path = "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName"
$provider = "Microsoft.Insights/metricAlerts/$ruleName"
$queryString = "?api-version=$apiVersion"
$url = "$apiEndpoint$path/providers/$provider$queryString"

# Define parameters for Invoke-AzRestMethod
$invokeAzRestMethodParams = @{
    Method  = "PUT"
    Uri     = $url
    Payload = Get-Content -Raw -Path $payloadFile
}

# Create the query-based metric alert rule
Invoke-AzRestMethod @invokeAzRestMethodParams
```

**Payload file (query-based-metric-alert.json):**

<br>
<details>
<summary>Create resource-centric query-based metric alert rule with user-assigned identity</summary>

```json
{
  "location": "<AzureRegion>",
  "identity": {
    "type": "UserAssigned",
    "userAssignedIdentities": {
      "/subscriptions/<SubscriptionId>/resourceGroups/<ResourceGroupName>/providers/Microsoft.ManagedIdentity/userAssignedIdentities/<UserAssignedMiName>": {}
    }
  },
  "properties": {
    "enabled": true,
    "description": "Sample query-based metric alert rule",
    "severity": 3,
    "targetResourceType": "microsoft.monitor/accounts",
    "scopes": [
      "/subscriptions/<SubscriptionId>/resourceGroups/<ResourceGroupName>/providers/Microsoft.ContainerService/managedClusters/<ClusterName>"
    ],
    "evaluationFrequency": "PT1M",
    "criteria": {
      "allOf": [
        {
          "name": "KubeContainerOOMKilledCount",
          "query": "sum by (cluster,container,controller,namespace)(kube_pod_container_status_last_terminated_reason{reason=\"OOMKilled\"} * on(cluster,namespace,pod) group_left(controller) label_replace(kube_pod_owner, \"controller\", \"$1\", \"owner_name\", \"(.*)\")) > 0",
          "criterionType": "StaticThresholdCriterion"
        }
      ],
      "odata.type": "Microsoft.Azure.Monitor.PromQLCriteria",
      "failingPeriods": {
        "for": "PT5M"
      }
    },
    "resolveConfiguration": {
      "autoResolved": true,
      "timeToResolve": "PT2M"
    },
    "actions": [
      {
        "actionGroupId": "/subscriptions/<SubscriptionId>/resourceGroups/<ResourceGroupName>/providers/Microsoft.Insights/actionGroups/<ActionGroupName>"
      }
    ],
    "actionProperties": {
      "Email.Subject": "Prometheus alert - Container killed due to OOM in cluster: ${data.alertContext.condition.allOf[0].dimensions.cluster} in pod: ${data.alertContext.condition.allOf[0].dimensions.pod} container: ${data.alertContext.condition.allOf[0].dimensions.container}"
    },
    "customProperties": {
      "Alert Summary": "Prometheus alert - Container killed due to OOM in cluster: ${data.alertContext.condition.allOf[0].dimensions.cluster} in pod: ${data.alertContext.condition.allOf[0].dimensions.pod} container: ${data.alertContext.condition.allOf[0].dimensions.container}"
    }
  }
}
```

</details>

# [REST](#tab/rest-2)

The following REST example uses the [`Metric Alerts - Create Or Update`](../fundamentals/azure-monitor-rest-api-index.md#op-monitor-metric-alerts) REST API operation.

<br>
<details>
<summary>Create resource-centric query-based metric alert rule with user-assigned identity</summary>

```REST
PUT https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/metricAlerts/{ruleName}?api-version={apiVersion}
Authorization: Bearer {accessToken}
Content-Type: application/json

{
  "location": "<AzureRegion>",
  "identity": {
    "type": "UserAssigned",
    "userAssignedIdentities": {
      "/subscriptions/<SubscriptionId>/resourceGroups/<ResourceGroupName>/providers/Microsoft.ManagedIdentity/userAssignedIdentities/<UserAssignedMiName>": {}
    }
  },
  "properties": {
    "enabled": true,
    "description": "Sample query-based metric alert rule",
    "severity": 3,
    "targetResourceType": "microsoft.monitor/accounts",
    "scopes": [
      "/subscriptions/<SubscriptionId>/resourceGroups/<ResourceGroupName>/providers/Microsoft.ContainerService/managedClusters/<ClusterName>"
    ],
    "evaluationFrequency": "PT1M",
    "criteria": {
      "allOf": [
        {
          "name": "KubeContainerOOMKilledCount",
          "query": "sum by (cluster,container,controller,namespace)(kube_pod_container_status_last_terminated_reason{reason=\"OOMKilled\"} * on(cluster,namespace,pod) group_left(controller) label_replace(kube_pod_owner, \"controller\", \"$1\", \"owner_name\", \"(.*)\")) > 0",
          "criterionType": "StaticThresholdCriterion"
        }
      ],
      "odata.type": "Microsoft.Azure.Monitor.PromQLCriteria",
      "failingPeriods": {
        "for": "PT5M"
      }
    },
    "resolveConfiguration": {
      "autoResolved": true,
      "timeToResolve": "PT2M"
    },
    "actions": [
      {
        "actionGroupId": "/subscriptions/<SubscriptionId>/resourceGroups/<ResourceGroupName>/providers/Microsoft.Insights/actionGroups/<ActionGroupName>"
      }
    ],
    "actionProperties": {
      "Email.Subject": "Prometheus alert - Container killed due to OOM in cluster: ${data.alertContext.condition.allOf[0].dimensions.cluster} in pod: ${data.alertContext.condition.allOf[0].dimensions.pod} container: ${data.alertContext.condition.allOf[0].dimensions.container}"
    },
    "customProperties": {
      "Alert Summary": "Prometheus alert - Container killed due to OOM in cluster: ${data.alertContext.condition.allOf[0].dimensions.cluster} in pod: ${data.alertContext.condition.allOf[0].dimensions.pod} container: ${data.alertContext.condition.allOf[0].dimensions.container}"
    }
  }
}
```

</details>

# [Bicep](#tab/bicep-2)

> [!NOTE]
> Template deployments are create-or-update operations. Deploying this template updates the existing alert rule rather than applying a partial change.

The following Bicep example uses the [`Microsoft.Insights/metricAlerts`](/azure/templates/microsoft.insights/metricalerts?pivots=deployment-language-bicep) resource type.

[!INCLUDE [alerts-query-based-metric-alert-template-bicep](includes/alerts-query-based-metric-alert-template-bicep.md)]

# [ARM template](#tab/arm-2)

> [!NOTE]
> Template deployments are create-or-update operations. Deploying this template updates the existing alert rule rather than applying a partial change.

The following ARM template example uses the [`Microsoft.Insights/metricAlerts`](/azure/templates/microsoft.insights/metricalerts?pivots=deployment-language-arm-template) resource type.

[!INCLUDE [alerts-query-based-metric-alert-template-json](includes/alerts-query-based-metric-alert-template-json.md)]

---

## Query-based metric alert configuration details

> [!NOTE]
> The following examples show individual properties, not complete alert definitions. The JSON examples are request-body fragments for REST, Azure CLI with `az rest`, and Azure PowerShell with `Invoke-AzRestMethod`. The Bicep examples define configuration values for the alert resource. For complete Bicep and ARM templates, see [Deploy a query-based metric alert](#deploy-a-query-based-metric-alert).

Apply these configuration examples as follows:

* Keep Bicep parameter and variable declarations at file scope.
* Apply the selected `identity` or `properties.scopes` example inside your complete `Microsoft.Insights/metricAlerts` resource definition.
* For JSON, use the same property path in the complete request body.
* Retain all unrelated settings, including `properties.criteria.allOf`, `properties.actions`, `properties.actionProperties`, `properties.customProperties`, and the resource's tags.
* Choose the identity and scope configuration that matches the rule; the examples are alternatives, not settings to combine.
* If you're adding a user-assigned identity to an existing user-assigned configuration, retain its other `identity.userAssignedIdentities` entries.
* If you're editing one resource ID in a multi-resource `properties.scopes` array, retain the other resource IDs that the rule should still target.
* Use a single-entry scope example to replace the array only when that replacement is intended.
* These excerpts don't merge settings or apply partial updates.

### User-assigned managed identity

Create and configure the user-assigned managed identity with permissions before including it in the rule configuration. Set `identity.type` to `UserAssigned` and include the managed identity resource ID in `identity.userAssignedIdentities`.

# [Bicep](#tab/bicep-3)

The following Bicep example uses the [`Microsoft.Insights/metricAlerts`](/azure/templates/microsoft.insights/metricalerts?pivots=deployment-language-bicep) resource type. Assign `alertIdentity` to the resource's `identity` property.

```bicep
param subscriptionId string = '<SubscriptionId>'
param resourceGroupName string = '<ResourceGroupName>'
param userAssignedMiName string = '<UserAssignedMiName>'

var userAssignedIdentityResourceId = resourceId(
  subscriptionId,
  resourceGroupName,
  'Microsoft.ManagedIdentity/userAssignedIdentities',
  userAssignedMiName
)

var alertIdentity = {
  type: 'UserAssigned'
  userAssignedIdentities: {
    '${userAssignedIdentityResourceId}': {}
  }
}
```

# [JSON](#tab/json-3)

The following JSON example shows the `identity` property in the [`Metric Alerts - Create Or Update`](../fundamentals/azure-monitor-rest-api-index.md#op-monitor-metric-alerts) request body.

```json
{
  "identity": {
    "type": "UserAssigned",
    "userAssignedIdentities": {
      "/subscriptions/<SubscriptionId>/resourceGroups/<ResourceGroupName>/providers/Microsoft.ManagedIdentity/userAssignedIdentities/<UserAssignedMiName>": {}
    }
  }
}
```

---

> [!NOTE]
> If the managed identity isn't configured correctly with the needed permissions/role, the alert rule might be created successfully but alert evaluations fail since access to the metrics isn't possible.

### System-assigned managed identity

Metric alert rules support automatic role assignment for system-assigned managed identities.

This feature simplifies the process of granting permissions to your managed identities and allows your alert rule to be operational immediately after being created.

For automatic role assignment to succeed, you must have one of the following roles on the rule scope:

* *Owner*
* *User Access Administrator*
* A custom role with *Microsoft.Authorization/roleAssignments/write* permission
* [Delegated admin permissions for the target scope](/azure/role-based-access-control/delegate-role-assignments-portal). To create a metric alert rule with a system-assigned managed identity that is automatically assigned the proper role, you must be allowed to grant Monitoring Reader role on the target scope.

> [!NOTE]
> If you try to create a rule that uses a system-assigned managed identity and you don't have permissions for automatic role assignment, the rule creation fails.

Set the `identity.type` property to `SystemAssigned`.

# [Bicep](#tab/bicep-3)

The following Bicep example uses the [`Microsoft.Insights/metricAlerts`](/azure/templates/microsoft.insights/metricalerts?pivots=deployment-language-bicep) resource type. Assign `alertIdentity` to the resource's `identity` property.

```bicep
var alertIdentity = {
  type: 'SystemAssigned'
}
```

# [JSON](#tab/json-3)

The following JSON example shows the `identity` property in the [`Metric Alerts - Create Or Update`](../fundamentals/azure-monitor-rest-api-index.md#op-monitor-metric-alerts) request body.

```json
{
  "identity": {
    "type": "SystemAssigned"
  }
}
```

---

A new system-assigned managed identity is created with the rule.

### Query-based rule conditions

To create a query-based alert rule condition, set `odata.type` to `Microsoft.Azure.Monitor.PromQLCriteria`. In this case, define the condition by using a PromQL expression in the query property.

The optional property `for` causes the alert rule to wait for a certain duration after the first time the condition is met before an alert fires. For example, if you set `for` to 10 minutes, the alert rule condition must be met during each evaluation for 10 minutes before the alert eventually fires.

> [!NOTE]
> The metric alert rule query and for properties are equivalent to the Prometheus alert rule expression and for clauses, respectively.

### Resource-centric and workspace-centric rule scope types

Query-based metric alert rules support two types of query scope:

#### Resource scope (resource-centric rules)

Query metrics are emitted to any workspace by:

* a specific Azure resource, or by multiple resources from the same subscription, or
* a resource group such as Azure Kubernetes clusters (AKS), or
* a Virtual Machine (VM).

For resource-centric rules, the following scope options are supported:

# [Bicep](#tab/bicep-3)

The following Bicep example uses the [`Microsoft.Insights/metricAlerts`](/azure/templates/microsoft.insights/metricalerts?pivots=deployment-language-bicep) resource type. Define the scope values, and then set `properties.scopes` to one of the options in the table.

```bicep
param subscriptionId string = '<SubscriptionId>'
param resourceGroupName string = '<ResourceGroupName>'
param clusterName string = '<ClusterName>'

var clusterResourceId = resourceId(
  subscriptionId,
  resourceGroupName,
  'Microsoft.ContainerService/managedClusters',
  clusterName
)
```

| Scope | Example |
|-------|---------|
| Single resource | `scopes: [clusterResourceId]` |
| Resource group | `scopes: ['/subscriptions/${subscriptionId}/resourceGroups/${resourceGroupName}']` |
| Subscription | `scopes: ['/subscriptions/${subscriptionId}']` |

# [JSON](#tab/json-3)

The following JSON examples show the `properties.scopes` options in the [`Metric Alerts - Create Or Update`](../fundamentals/azure-monitor-rest-api-index.md#op-monitor-metric-alerts) request body.

| Scope | Example |
|-------|---------|
| Single resource | `"scopes": ["/subscriptions/<SubscriptionId>/resourceGroups/<ResourceGroupName>/providers/Microsoft.ContainerService/managedClusters/<ClusterName>"]` |
| Resource group | `"scopes": ["/subscriptions/<SubscriptionId>/resourceGroups/<ResourceGroupName>"]` |
| Subscription | `"scopes": ["/subscriptions/<SubscriptionId>"]` |

---

The system locates the Workspace where the resource metrics reside. The rule query must refer only to metrics emitted by the scoped resource.

#### Azure Monitor Workspace scope (workspace-centric rules)

Query metrics emitted to a specific Azure Monitor Workspace, regardless of the emitting resources.

For workspace scope, include the workspace Azure Resource Manager ID in the `scopes` array.

# [Bicep](#tab/bicep-3)

The following Bicep example uses the [`Microsoft.Insights/metricAlerts`](/azure/templates/microsoft.insights/metricalerts?pivots=deployment-language-bicep) resource type. Set `properties.scopes` to `[workspaceResourceId]`.

```bicep
param subscriptionId string = '<SubscriptionId>'
param resourceGroupName string = '<ResourceGroupName>'
param accountName string = '<AccountName>'

var workspaceResourceId = resourceId(
  subscriptionId,
  resourceGroupName,
  'Microsoft.Monitor/accounts',
  accountName
)
```

# [JSON](#tab/json-3)

The following JSON example shows the `properties.scopes` value in the [`Metric Alerts - Create Or Update`](../fundamentals/azure-monitor-rest-api-index.md#op-monitor-metric-alerts) request body.

`"scopes": ["/subscriptions/<SubscriptionId>/resourceGroups/<ResourceGroupName>/providers/Microsoft.Monitor/accounts/<AccountName>"]`

---

The rule query can refer to any metrics stored in the Azure Monitor Workspace.

## View query-based alerts in the Azure portal

Use the Azure portal to review fired alerts and their rule definitions.

### View fired query-based metric alerts

View fired and resolved query-based metric alerts in the Azure portal together with all other alert types:

1. On the Monitor menu in the Azure portal, select **Alerts**.
1. If *Monitor service* doesn't appear as a filter option, select **Add Filter** and add it.
1. Set the **Monitor service filter** to *Metric query*.
1. Select the **alert name** to view the details of a specific fired or resolved alert.

Alerts fired for a specific resource are also available from the resource itself. On the resource menu in the Azure portal, select Alerts, and then filter for the Metric Query monitoring service.

### View alert rule details in the Azure portal

View query-based metric alert rules in the Azure portal together with all other alert rules. Filter for only query-based metric rules, and set the **Signal types** filter to *Metrics* to see all metric alert rules, including query-based rules.

## Modify a query-based alert

> [!NOTE]
> To modify an existing rule in your subscription by using an ARM template or Bicep templates, edit the template file and repeat the deployment procedure.

To edit a query-based metric alert rule in the Azure portal:

1. From the home screen in the Azure portal, search for or select **Monitor**. The Azure Monitor home screen appears.
1. Select **Alerts**. A listing of all the alerts you have access to appears.
1. Select the alert you want to work with. The alert properties screen appears.
1. Select **Go to alert rule**. The alert rule screen appears.
1. Select **Edit**. The alert editing screen appears.
1. Continue as you would while creating a new alert rule.
