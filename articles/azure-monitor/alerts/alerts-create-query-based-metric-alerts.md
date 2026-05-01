---
title: Create Query-Based Metric Alerts (Preview)
description: This article explains how to create query-based metric alert rules in Azure Monitor using PromQL, covering prerequisites, rule configuration options, managed identity requirements, deployment methods, and how to view and manage alerts in the Azure portal.
ms.topic: how-to
ms.date: 10/11/2025
ms.custom: ai-assisted
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

You can enable resource-centric stamping and access for a workspace using one of the following methods:

> [!NOTE]
> All methods use the preview API version 2025-05-03-preview. The `properties.metrics.enableAccessUsingResourcePermissions` shape is not available in the most recent GA version 2023-04-03.

# [REST](#tab/rest-1)

```REST
PUT https://management.azure.com/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/microsoft.monitor/accounts/{accountName}?api-version={apiVersion}
Authorization: Bearer {token}
Content-Type: application/json

{
  "location": "{location}",
  "properties": {
    "metrics": {
      "enableAccessUsingResourcePermissions": true
    }
  }
}
```

# [Azure CLI](#tab/cli-1)

[!INCLUDE [Azure CLI using REST](../includes/cli-using-rest.md)]

```azurecli
subscriptionId="aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e"
resourceGroupName="myResourceGroup"
accountName="myAccountName"
apiVersion="2025-05-03-preview"
providers="microsoft.monitor/accounts/$accountName"
resourceId="/subscriptions/$subscriptionId/resourcegroups/$resourceGroupName/providers/$providers"
payloadFile="./enable-stamping.json"

az account set --subscription "$subscriptionId"

az rest \
  --method put \
  --uri "$resourceId?api-version=$apiVersion" \
  --body @"$payloadFile"
```

**Payload file (enable-stamping.json):**

```json
{
  "location": "eastus",
  "properties": {
    "metrics": {
      "enableAccessUsingResourcePermissions": true
    }
  }
}
```

# [PowerShell](#tab/powershell-1)

[!INCLUDE [Azure PowerShell using REST](../includes/powershell-using-rest.md)]

```azurepowershell
$subscriptionId = "aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e"
$resourceGroupName = "myResourceGroup"
$accountName = "myAccountName"
$apiVersion = "2025-05-03-preview"
$providers = "microsoft.monitor/accounts/$accountName"
$resourceId = "/subscriptions/$subscriptionId/resourcegroups/$resourceGroupName/providers/$providers"
$payloadFile = ".\enable-stamping.json"

Set-AzContext -Subscription $subscriptionId

$restParams = @{
    Path    = "$resourceId?api-version=$apiVersion"
    Method  = "PUT"
    Payload = Get-Content -Raw -Path $payloadFile
}

Invoke-AzRestMethod @restParams
```

**Payload file (enable-stamping.json):**

```json
{
  "location": "eastus",
  "properties": {
    "metrics": {
      "enableAccessUsingResourcePermissions": true
    }
  }
}
```

# [ARM (JSON)](#tab/arm-1)

The following ARM (JSON) example uses the [Microsoft.Monitor accounts](/azure/templates/microsoft.monitor/accounts?pivots=deployment-language-arm-template) resource type.

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "accountName": {
      "type": "string",
      "defaultValue": "myAccountName"
    },
    "location": {
      "type": "string",
      "defaultValue": "eastus"
    }
  },
  "resources": [
    {
      "type": "Microsoft.Monitor/accounts",
      "apiVersion": "2025-05-03-preview",
      "name": "[parameters('accountName')]",
      "location": "[parameters('location')]",
      "properties": {
        "metrics": {
          "enableAccessUsingResourcePermissions": true
        }
      }
    }
  ]
}
```

# [Bicep](#tab/bicep-1)

The following Bicep example uses the [Microsoft.Monitor accounts](/azure/templates/microsoft.monitor/accounts?pivots=deployment-language-bicep) resource type.

```bicep
param accountName string = 'myAccountName'
param location string = 'eastus'

resource monitorWorkspace 'Microsoft.Monitor/accounts@2025-05-03-preview' = {
  name: accountName
  location: location
  properties: {
    metrics: {
      enableAccessUsingResourcePermissions: true
    }
  }
}
```

---

| Variable | Example value | Purpose |
|----------|---------------|---------|
| host | *management.azure.com* | Implicit ARM endpoint |
| subscriptionId | aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e | User input |
| resourceGroupName | myResourceGroup | User input |
| accountName | myAccountName | User input |
| location | eastus | User input |
| apiVersion | 2025-05-03-preview | [Reference](../fundamentals/azure-monitor-rest-api-index.md) |

## Deploy a query-based metric alert

You can create and configure query-based metric alert rules by using the Azure portal or one of the programmatic approaches in this section. The REST, Azure CLI, and Azure PowerShell examples use direct REST requests to create or update the alert rule, while the ARM (JSON) and Bicep examples use template-based deployments.

The examples in this section create a resource-centric, query-based metric alert rule that uses an Azure Kubernetes Service (AKS) cluster as its scope and a user-assigned managed identity. The following sections describe some of the required properties and configuration options. Edit the examples to use your own scope, location, query, action groups, and other values.

# [Portal](#tab/portal-2)

> [!NOTE]
> You can only select one resource type at a time in the Azure portal. For example, you can't select virtual machines and Kubernetes services.
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

# [REST](#tab/rest-2)

```REST
PUT https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/metricAlerts/{ruleName}?api-version={apiVersion}
Authorization: Bearer {token}
Content-Type: application/json

{
  "location": "<location>",
  "identity": {
    "type": "UserAssigned",
    "userAssignedIdentities": {
      "/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.ManagedIdentity/userAssignedIdentities/<userAssignedMiName>": {}
    }
  },
  "properties": {
    "enabled": true,
    "description": "Sample query-based metric alert rule",
    "severity": 3,
    "targetResourceType": "microsoft.monitor/accounts",
    "scopes": [
      "/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.ContainerService/managedClusters/<clusterName>"
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
        "actionGroupId": "/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.Insights/actionGroups/<actionGroupName>"
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

# [Azure CLI](#tab/cli-2)

[!INCLUDE [Azure CLI using REST](../includes/cli-using-rest.md)]

```azurecli
subscriptionId="aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e"
resourceGroupName="myResourceGroup"
ruleName="Sample query based alert rule"
userAssignedMiName="myUserAssignedIdentity"
clusterName="myCluster"
actionGroupName="myActionGroup"
apiVersion="2024-03-01-preview"
resourceId="/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.Insights/metricAlerts/$ruleName"
payloadFile=./query-based-metric-alert.json

az account set --subscription $subscriptionId

az rest \
  --method put \
  --uri "https://management.azure.com$resourceId?api-version=$apiVersion" \
  --body @$payloadFile
```

**Payload file (query-based-metric-alert.json):**

> [!NOTE]
> Azure CLI doesn't support deployment-style parameters in JSON payload files for `az rest`. Because the JSON file is used directly as the request body, this example includes example values in the file.

```json
{
  "location": "eastus",
  "identity": {
    "type": "UserAssigned",
    "userAssignedIdentities": {
      "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/myResourceGroup/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myUserAssignedIdentity": {}
    }
  },
  "properties": {
    "enabled": true,
    "description": "Sample query-based metric alert rule",
    "severity": 3,
    "targetResourceType": "microsoft.monitor/accounts",
    "scopes": [
      "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/myResourceGroup/providers/Microsoft.ContainerService/managedClusters/myCluster"
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
        "actionGroupId": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/myResourceGroup/providers/Microsoft.Insights/actionGroups/myActionGroup"
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

# [PowerShell](#tab/powershell-2)

[!INCLUDE [Azure PowerShell using REST](../includes/powershell-using-rest.md)]

```azurepowershell
$subscriptionId = "aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e"
$resourceGroupName = "myResourceGroup"
$ruleName = "Sample query based alert rule"
$userAssignedMiName = "myUserAssignedIdentity"
$clusterName = "myCluster"
$actionGroupName = "myActionGroup"
$apiVersion = "2024-03-01-preview"
$resourceId = "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.Insights/metricAlerts/$ruleName"
$payloadFile = ".\query-based-metric-alert.json"

Set-AzContext -Subscription $subscriptionId

$restParams = @{
    Path    = "$resourceId?api-version=$apiVersion"
    Method  = "PUT"
    Payload = Get-Content -Raw -Path $payloadFile
}

Invoke-AzRestMethod @restParams
```

**Payload file (query-based-metric-alert.json):**

> [!NOTE]
> Azure PowerShell doesn't support deployment-style parameters in JSON payload files for Invoke-AzRestMethod. Because the JSON file is used directly as the request body, this example includes example values in the file.

```json
{
  "location": "eastus",
  "identity": {
    "type": "UserAssigned",
    "userAssignedIdentities": {
      "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/myResourceGroup/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myUserAssignedIdentity": {}
    }
  },
  "properties": {
    "enabled": true,
    "description": "Sample query-based metric alert rule",
    "severity": 3,
    "targetResourceType": "microsoft.monitor/accounts",
    "scopes": [
      "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/myResourceGroup/providers/Microsoft.ContainerService/managedClusters/myCluster"
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
        "actionGroupId": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/myResourceGroup/providers/Microsoft.Insights/actionGroups/myActionGroup"
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

# [ARM (JSON)](#tab/arm-2)

The following ARM (JSON) example uses the [Microsoft.Insights metricAlerts](/azure/templates/microsoft.insights/metricalerts?pivots=deployment-language-arm-template) resource type.

[!INCLUDE [alerts-query-based-metric-alert-template-json](includes/alerts-query-based-metric-alert-template-json.md)]

# [Bicep](#tab/bicep-2)

The following Bicep example uses the [Microsoft.Insights metricAlerts](/azure/templates/microsoft.insights/metricalerts?pivots=deployment-language-bicep) resource type.

[!INCLUDE [alerts-query-based-metric-alert-template-bicep](includes/alerts-query-based-metric-alert-template-bicep.md)]

---

| Variable | Example value | Purpose |
|----------|---------------|---------|
| host | *management.azure.com* | Implicit ARM endpoint |
| subscriptionId | aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e | User input |
| resourceGroupName | myResourceGroup | User input |
| ruleName | myRule | User input |
| location | eastus | User input |
| userAssignedMiName | myUserAssignedIdentity | User input |
| clusterName | myCluster | User input |
| actionGroupName | myActionGroup | User input |
| apiVersion | 2024-03-01-preview | [Reference](../fundamentals/azure-monitor-rest-api-index.md) |

## Query-based metric alert configuration details

> [!NOTE]
> In the following sections, the JSON examples apply to ARM (JSON) templates and to the JSON request bodies used by REST, Azure CLI with `az rest`, and Azure PowerShell with `Invoke-AzRestMethod`. The Bicep examples show the equivalent configuration in Bicep syntax.

### User-assigned managed identity

Create and configure the user-assigned managed identity with permissions before including it in the rule configuration. Set `identity` -> `type` to `UserAssigned` and include the MI resource ID in `identity` -> `userAssignedIdentities`, as in the following example:

# [JSON](#tab/json-3)

```json
{
  "identity": {
    "type": "UserAssigned",
    "userAssignedIdentities": {
      "/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.ManagedIdentity/userAssignedIdentities/<userAssignedMiName>": {}
    }
  }
}
```

# [Bicep](#tab/bicep-3)

```bicep
{
  identity: {
    type: 'UserAssigned',
    userAssignedIdentities: {
      '/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.ManagedIdentity/userAssignedIdentities/<userAssignedMiName>': {}
    }
  }
}
```

---

> [!NOTE] 
> If the managed identity isn't configured correctly with the needed permissions/role, the alert rule might be created successfully but alert evaluations fail since access to the metrics isn't possible.

### System assigned managed identity

Metric alert rules support automatic role assignment for system-assigned managed identities.

This feature simplifies the process of granting permissions to your managed identities and allows your alert rule to be operational immediately after being created.

For automatic role assignment to succeed, you must have one of the following roles on the rule scope:

* *Owner* 
* *User Access Administrator* 
* A custom role with *Microsoft.Authorization/roleAssignments/write* permission 
* [Delegated admin permissions for the target scope](/azure/role-based-access-control/delegate-role-assignments-portal). For creating metric alert rule with system-assigned managed identity, you must be allowed to grant Monitoring Reader role on the target scope.

> [!NOTE]
> If you try to create a rule using system-assigned managed identity and you don’t have permissions for automatic role assignment, the rule creation fails.

Set the `identity` -> `type` property to `SystemAssigned` as in the following example:

# [JSON](#tab/json-3)

```json
{
  "identity": {
    "type": "SystemAssigned"
  }
}
```

# [Bicep](#tab/bicep-3)

```bicep
{
  identity: {
    type: 'SystemAssigned'
  }
}
```

---

A new System Assigned MI is created with the rule.

### Query-based rule conditions

To configure a Query-based metric alert rules, the condition property `odata.type`  should be set to `Microsoft.Azure.Monitor.PromQLCriteria`

To create a query-based rule condition, `odata.type` should be set to `Microsoft.Azure.Monitor.PromQLCriteria`. In this case, the condition is defined using a PromQL expression in the new query property. 

The optional property `for` causes the alert rule to wait for a certain duration after the first time the condition is met before an alert is fired. For example, if `for` is set to 10 minutes, the alert rule condition must be met during each evaluation for 10 minutes before the alert is eventually fired. 

> [!NOTE]
> The metric alert rule query and for properties are equivalent to the Prometheus alert rule expression and for clauses, respectively.

### Resource-centric and workspace-centric rule scope types

Query-based metric alert rule support two types of query scope:

#### Resource scope (resource-centric rules)

You can query metrics emitted to any Workspace by:

* a specific Azure resource, or by multiple resources from the same subscription or 
* a resource group such as Azure Kubernetes clusters (AKS) or 
* a Virtual Machine (VM).

For resource-centric rules, the following scope options are supported:

# [JSON](#tab/json-3)

| Scope | Example |
|-------|---------|
| Single resource | `"scopes": ["/subscriptions/<subscriptionId>/resourcegroups/<resourceGroupName>/providers/microsoft.containerservice/managedclusters/<clusterName>"]` |
| Resource group | `"scopes": ["/subscriptions/<subscriptionId>/resourcegroups/<resourceGroupName>"]` |
| Subscription | `"scopes": ["/subscriptions/<subscriptionId>"]` |

# [Bicep](#tab/bicep-3)

| Scope | Example |
|-------|---------|
| Single resource | `scopes: ['/subscriptions/<subscriptionId>/resourcegroups/<resourceGroupName>/providers/microsoft.containerservice/managedclusters/<clusterName>']` |
| Resource group | `scopes: ['/subscriptions/<subscriptionId>/resourcegroups/<resourceGroupName>']` |
| Subscription | `scopes: ['/subscriptions/<subscriptionId>']` |

---

The system locates the Workspace where the resource metrics reside. The rule query must refer only to metrics emitted by the scoped resource.

#### Azure Monitor Workspace scope (workspace-centric rules)

You can query metrics emitted to a specific Azure Monitor Workspace, regardless of the emitting resources.

For workspace scope, include the Workspace Azure Resource Manager ID in the Scopes[] list.

# [JSON](#tab/json-3)

Example: `"scopes": ["/subscriptions/<subscriptionId>/resourcegroups/<resourceGroupName>/providers/microsoft.monitor/accounts/<azureMonitorWorkspaceName>"]`

# [Bicep](#tab/bicep-3)

Example: `scopes: ['/subscriptions/<subscriptionId>/resourcegroups/<resourceGroupName>/providers/microsoft.monitor/accounts/<azureMonitorWorkspaceName>']`

---

The rule query can refer to any metrics stored in the Azure Monitor Workspace.

## View query-based alerts in the Azure portal

### View fired query-based metric alerts

You can view fired and resolved query-based metric alerts in the Azure portal together with all other alert types:

1. On the Monitor menu in the Azure portal, select **Alerts**.
1. If *Monitor service* doesn't appear as a filter option, select **Add Filter** and add it.
1. Set the **Monitor service filter** to *Metric query*.
1. Select the **alert name** to view the details of a specific fired or resolved alert.

You can also view alerts fired for a specific resource. On the resource menu in the Azure portal, select Alerts. You can then filter for the Metric Query monitoring service.

### View alert rule details in the Azure portal

You can view query-based metric alert rules in the Azure portal together with all other alert rules. Filter for only query-based metric rules, and set the **Signal types** filter to *Metrics* to see all metric alert rules, including query-based rules.

## Modify a query-based alert

> [!NOTE]
> To modify an existing rule in your subscription using ARM (JSON) or Bicep templates, edit the template file and repeat the deployment procedure.

To edit a query-based metric alert rule in the Azure portal:

1. From the home screen in the Azure portal, search for or select **Monitor**. The Azure Monitor home screen appears.
1. Select **Alerts**. A listing of all the alerts you have access to appears.
1. Select the alert you want to work with. The alert properties screen appears.
1. Select **Go to alert rule**. The alert rule screen appears.
1. Select **Edit**. The alert editing screen appears.
1. Continue as you would while creating a new alert rule.
