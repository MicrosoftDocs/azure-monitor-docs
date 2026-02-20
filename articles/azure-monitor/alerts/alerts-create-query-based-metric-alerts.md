---
title: Create Query-Based Metric Alerts
description: "This article explains how to create query-based metric alert rules in Azure Monitor using PromQL, covering prerequisites, rule configuration options, managed identity requirements, deployment methods, and how to view and manage alerts in the Azure portal."
ms.topic: how-to
ms.date: 10/11/2025
ms.custom: references_regions
---

# Create query-based metric alerts (preview)

This article explains how to create query-based metric alert rules in Azure Monitor using PromQL, covering prerequisites, rule configuration options, managed identity requirements, deployment methods, and how to view and manage alerts in the Azure portal.

## Prerequisites

> [!div class="checklist"]
> * Read the [query based metric alerts overview](alerts-query-based-metric-alerts-overview.md).
> * A system-assigned or user-assigned managed identity. To use a user-assigned managed identity with your query-based metric alert rules, create the managed identity in advance and configure it with *Monitoring Reader* role (or equivalent permissions) on the rule scope. For more information about creating and using managed identities, see [Azure managed identities](/entra/identity/managed-identities-azure-resources/overview).
> * A resource emitting Prometheus or OTel-based metrics to an Azure Monitor Workspace (AMW). The resources currently supported are Azure Kubernetes Service (AKS), Azure virtual machines, ARC servers or ARC-enabled clusters. Custom OTel metrics emitted directly to AMW by your workload are also supported.
>     * See [Enable Azure Monitor managed service for Prometheus](/azure/azure-monitor/metrics/prometheus-metrics-overview#enable-azure-monitor-managed-service-for-prometheus).
>     * See [Enable Prometheus and Grafana](/azure/azure-monitor/containers/kubernetes-monitoring-enable?tabs=cli#enable-prometheus-and-grafana) for details.
> * To create resource-centric alert rules, your Azure Monitor Workspace must be [enabled for resource-centric stamping and access](#enable-workspace-resource-centric-stamping-and-access).

## Enable workspace resource-centric stamping and access

You can enable resource-centric stamping and access for a Workspace in one of two ways:

### Use a PUT request

Use a PUT request.

```
PUT https://management.azure.com/subscriptions/{{subscription}}/resourcegroups/{{resource_name}}/providers/microsoft.monitor/accounts/{{account_name}}?api-version=2025-05-03-preview
Authorization: Bearer {{token}}
Content-Type: application/json
{
  "location": "eastus",
  "properties": {
    "metrics": {
      "enableAccessUsingResourcePermissions": true
    }
  }
}
```

## Deploy a query-based metric alert

## [Azure portal](#tab/portal)

> [!NOTE]
> You can only select one resource type at a time in the Azure portal. For example, you can't select virtual machines and Kubernetes services.
<!--
> [!VIDEO f94188c4-ca77-41bd-984f-cda31a59a41b]
-->
From the *Create an alert rule* page:

1. Select **Select scope**. The Select a resource screen appears.

1. From the **Subscription** dropdown list, select one or more subscriptions checkboxes. All resource groups within that chosen subscription appear.

1. From the Resource types dropdown list, filter for *Virtual machines*,  *Azure Monitor workspaces*, *Kubernetes services* or choose an entire resource group or subscription.

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

## View query-based alerts in the Azure portal

### View fired query-based metric alerts

You can view fired and resolved query-based metric alerts in the Azure portal together with all other alert types:

1.	On the Monitor menu in the Azure portal, select **Alerts**.
1.	If *Monitor service* doesn't appear as a filter option, select **Add Filter** and add it.
1.	Set the **Monitor service filter** to *Metric query*.
1.	Select the **alert name** to view the details of a specific fired or resolved alert.

You can also view alerts fired for a specific resource. On the resource  menu in the Azure portal, select Alerts. You can then filter for the Metric Query monitoring service.

### View alert rule details in the Azure portal

You can view query-based metric alert rules in the Azure portal together with all other alert rules. Filter for only query-based metric rules, and set the **Signal types** filter to *Metrics* to see all metric alert rules, including query-based rules.

## Edit a rule in the Azure portal

To edit a query-based metric alert rule in the Azure portal:

1. From the home screen in the Azure portal, search for or select **Monitor**. The Azure Monitor home screen appears.
1. Select **Alerts**. A listing of all the alerts you have access to appears.
1. Select the alert you want to work with. The alert properties screen appears.
1. Select **Go to alert rule**. The alert rule screen appears.
1. Select **Edit**. The alert editing screen appears. 
1. Continue as you would while creating a new alert rule.

## [ARM & Bicep templates](#tab/arm)

You can use an ARM (JSON) or Bicep template to create and configure query-based metric alert rules. Here are the steps:

1. Add environment-specific parameters to the template as needed.
1. Deploy the template using any deployment method, such as Azure CLI, Azure PowerShell, or Azure Resource Manager Rest APIs.

Some of the required parameters are discussed in the following sections, and there's a template example you can start with.

### User-assigned managed identity

Create and configure the user-assigned managed identity with permissions before including it in the rule configuration. Set `identity` -> `type` to `UserAssigned` and include the MI resource ID in `identity` -> `userAssignedIdentities`, as in the following example:

**ARM (JSON)**

```json
{
    "identity": {
        "type": "UserAssigned",
        "userAssignedIdentities": {
            "/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.ManagedIdentity/userAssignedIdentities/<user-assigned-mi-name>": {}
        }
    },
}
```

**Bicep**

```bicep
{
    identity: {
        type: 'UserAssigned'
        userAssignedIdentities: {
            '/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.ManagedIdentity/userAssignedIdentities/<user-assigned-mi-name>': {}
        }
    }
}
```

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
> If you try to create a rule using system-assigned AI and you don’t have permissions for automatic role assignment, the rule creation fails.

Set the `identity` -> `type` property to `SystemAssigned` as in the following example:

**ARM (JSON)**

```json
{
    "identity": {
        "type": "SystemAssigned"
      }
}
```

**Bicep**

```bicep
{
    identity: {
        type: 'SystemAssigned'
      }
}
```

A new System Assigned MI is created with the rule.

## Query-based rule conditions

To configure a Query-based metric alert rules, the condition property `odata.type`  should be set to `Microsoft.Azure.Monitor.PromQLCriteria`

To create a query-based rule condition, `odata.type` should be set to `Microsoft.Azure.Monitor.PromQLCriteria`. In this case, the condition is defined using a PromQL expression in the new query property. 

The optional property `for` causes the alert rule to wait for a certain duration after the first time the condition is met before an alert is fired. For example, if `for` is set to 10 minutes, the alert rule condition must be met during each evaluation for 10 minutes before the alert is eventually fired. 

> [!NOTE]
> The metric alert rule query and for properties are equivalent to the Prometheus alert rule expression and for clauses, respectively.

## Resource-centric and workspace-centric rule scope types

Query-based metric alert rule support two types of query scope:

### Resource scope (resource-centric rules)

You can query metrics emitted to any Workspace by:

* a specific Azure resource, or by multiple resources from the same subscription or 
* a resource group such as Azure Kubernetes clusters (AKS) or 
* a Virtual Machine (VM).

For resource-centric rules, the following scope options are supported:

* A single resource - include a single Azure Resource Manager resource ID in the Scopes[] list. Example: 

    * ARM (JSON): `"scopes": ["/subscriptions/<subscription-id>/resourcegroups/<resource-group-name>/providers/microsoft.containerservice/managedclusters/<myClusterName>"]`
    * Bicep: `scopes: ['/subscriptions/<subscription-id>/resourcegroups/<resource-group-name>/providers/microsoft.containerservice/managedclusters/<myClusterName>']`

* A resource group - include the resource group ID in the Scopes[] list. Example: 

    * ARM (JSON): `"scopes": ["/subscriptions/<subscription-id>/resourcegroups/<resource-group-name>"]`
    * Bicep: `scopes: ['/subscriptions/<subscription-id>/resourcegroups/<resource-group-name>']`

* A subscription - include the subscription ID in the Scopes[] list. Example: 

    * ARM (JSON): `"scopes": ["/subscriptions/<subscription-id>"]`
    * Bicep: `scopes: ['/subscriptions/<subscription-id>']`

The system locates the Workspace where the resource metrics reside. The rule query must refer only to metrics emitted by the scoped resource.

### Azure Monitor Workspace scope (workspace-centric rules)

You can query metrics emitted to a specific Azure Monitor Workspace, regardless of the emitting resources.

For workspace scope, include the Workspace Azure Resource Manager ID in the Scopes[] list. Example: 

* ARM (JSON): `"scopes": ["/subscriptions/<subscription-id>/resourcegroups/<resource-group-name>/providers/microsoft.monitor/accounts/<myAMWName>"]`
* Bicep: `scopes: ['/subscriptions/<subscription-id>/resourcegroups/<resource-group-name>/providers/microsoft.monitor/accounts/<myAMWName>']`

The rule query can refer to any metrics stored in the Azure Monitor Workspace.

### ARM & Bicep template examples

The following template creates a resource-centric, query-based metric alert rule with an Azure Kubernetes Service (AKS) as its scope, using a user-assigned managed identity.

Edit it to include your specific scope, location, query, action groups, and other parameters.

**ARM (JSON)**

[!INCLUDE [alerts-query-based-metric-alert-template-json](includes/alerts-query-based-metric-alert-template-json.md)]

**Bicep**

[!INCLUDE [alerts-query-based-metric-alert-template-bicep](includes/alerts-query-based-metric-alert-template-bicep.md)]

## Modify a query-based alert

To modify an existing rule in your subscription, edit the template file and repeat the deployment procedure.

## [CLI](#tab/cli)

You can deploy a metric alert template using the CLI.

1.	Open a terminal or command prompt.

1.	Sign in /authenticate to Azure.

1.	Set the subscription to the one you want to use, either with the subscription name or the ID.

    * Change the active subscription using the subscription name.
        `az account set --subscription "My Demos"`

    * Change the active subscription using the subscription ID.
        `az account set --subscription "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"`

1.	[Deploy the template](/azure/azure-resource-manager/templates/deploy-cli#deploy-local-template).

    `az deployment group create --name ExampleDeployment --resource-group ExampleGroup --template-file <path-to-template> --parameters storageAccountType=Standard_GRS`

1.	Check updated rule (Optional. Use the name you set in the template).

    `az resource show --ids /subscriptions/<subscriptionId>/resourceGroups/<resource group name>/providers/Microsoft.Insights/metricAlerts/<rule name>`

---

## View or modify query-based metric alerts in the portal

To view or modify query-based metric alerts in the Azure portal, see the [Azure portal tab](#view-query-based-alerts-in-the-azure-portal) of this document.
