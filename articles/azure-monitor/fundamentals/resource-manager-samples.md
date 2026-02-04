---
title: Resource Manager template samples for Azure Monitor
description: Deploy and configure Azure Monitor features by using Resource Manager templates.
ms.topic: sample
ms.date: 05/21/2025
---
# Resource Manager template samples for Azure Monitor

You can deploy and configure Azure Monitor at scale by using [Azure Resource Manager templates](/azure/azure-resource-manager/templates/syntax). This article lists sample templates for Azure Monitor features. You can modify these samples for your particular requirements and deploy them by using any standard method for deploying Resource Manager templates.

## Deploy the sample templates

The basic steps to use one of the template samples are:

1. Copy the template and save it as a JSON file.
1. Modify the parameters for your environment and save the JSON file.
1. Deploy the template by using [any deployment method for Resource Manager templates](/azure/azure-resource-manager/templates/deploy-portal).

Following are basic steps for using different methods to deploy the sample templates. Follow the included links for more information.

## [Azure portal](#tab/portal)

For more information, see [Deploy resources with ARM templates and Azure portal](/azure/azure-resource-manager/templates/deploy-portal).

1. In the Azure portal, select **Create a resource**, search for **template**. and then select **Template deployment**.
1. Select **Create**.
1. Select **Build your own template in editor**.
1. Click **Load file** and select your template file.
1. Click **Save**.
1. Fill in parameter values.
1. Click **Review + Create**.

## [CLI](#tab/cli)

For more information, see [How to use Azure Resource Manager (ARM) deployment templates with Azure CLI](/azure/azure-resource-manager/templates/deploy-cli).

```azurecli
az login
az deployment group create \
    --name AzureMonitorDeployment \
    --resource-group <resource-group> \
    --template-file azure-monitor-deploy.json \
    --parameters azure-monitor-deploy.parameters.json
```

## [PowerShell](#tab/powershell)

For more information, see [Deploy resources with ARM templates and Azure PowerShell](/azure/azure-resource-manager/templates/deploy-powershell).

```powershell
Connect-AzAccount
Select-AzSubscription -SubscriptionName <subscription>
New-AzResourceGroupDeployment -Name AzureMonitorDeployment -ResourceGroupName <resource-group> -TemplateFile azure-monitor-deploy.json -TemplateParameterFile azure-monitor-deploy.parameters.json
```

## [REST API](#tab/api)

For more information, see [Deploy resources with ARM templates and Azure Resource Manager REST API](/azure/azure-resource-manager/templates/deploy-rest).

```rest
PUT https://management.azure.com/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/{deploymentName}?api-version=2020-10-01
```

In the request body, provide a link to your template and parameter file.

```json
{
 "properties": {
   "templateLink": {
     "uri": "http://mystorageaccount.blob.core.windows.net/templates/template.json",
     "contentVersion": "1.0.0.0"
   },
   "parametersLink": {
     "uri": "http://mystorageaccount.blob.core.windows.net/templates/parameters.json",
     "contentVersion": "1.0.0.0"
   },
   "mode": "Incremental"
 }
}
```

---

## List of sample templates

* [Agents](../agents/resource-manager-agent.md): Deploy and configure the Log Analytics agent and a diagnostic extension.
* Alerts:
    * [Log search alert rules](../alerts/resource-manager-alerts-log.md): Configure alerts from log queries and Azure Activity Log.
    * [Metric alert rules](../alerts/resource-manager-alerts-metric.md): Configure alerts from metrics that use different kinds of logic.
* [Application Insights](../app/create-workspace-resource.md)
* [Diagnostic settings](../essentials/resource-manager-diagnostic-settings.md): Create diagnostic settings to forward logs and metrics from different resource types.
* [Enable Prometheus metrics](../containers/kubernetes-monitoring-enable.md?tabs=arm): Install the Azure Monitor agent on your AKS cluster and send Prometheus metrics to your Azure Monitor workspace.
* [Log queries](../logs/resource-manager-log-queries.md): Create saved log queries in a Log Analytics workspace.
* [Log Analytics workspace](../logs/resource-manager-workspace.md): Create a Log Analytics workspace and configure a collection of data sources from the Log Analytics agent.
* [Workbooks](../visualize/resource-manager-workbooks.md): Create workbooks.
* [Azure Monitor for VMs](../vm/resource-manager-vminsights.md): Onboard virtual machines to Azure Monitor for VMs.

## Next steps

Learn more about [Resource Manager templates](/azure/azure-resource-manager/templates/overview).
