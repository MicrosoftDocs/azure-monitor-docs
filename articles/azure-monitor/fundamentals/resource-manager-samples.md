---
title: Resource Manager Template Samples for Azure Monitor
description: Deploy and configure Azure Monitor features by using Resource Manager templates.
ms.topic: sample
ms.custom: cbo-v1.6
ms.date: 05/21/2025
ai-usage: ai-assisted
---

# Resource Manager template samples for Azure Monitor

You can deploy and configure Azure Monitor at scale by using [Azure Resource Manager templates](/azure/azure-resource-manager/templates/syntax). This article lists sample templates for Azure Monitor features. You can modify these samples for your particular requirements and deploy them by using any standard method for deploying Resource Manager templates.

## Deploy the sample templates

The basic steps to use one of the template samples are:

1. Copy the template and save it as a JSON file.
1. Modify the parameters for your environment and save the JSON file.
1. Deploy the template by using [any deployment method for Resource Manager templates](/azure/azure-resource-manager/templates/deploy-portal).

For the Azure CLI and Azure PowerShell examples, use a local template file and a matching [parameter file](/azure/azure-resource-manager/templates/parameter-files). For deployment prerequisites, see the guidance for [Azure CLI](/azure/azure-resource-manager/templates/deploy-cli), [Azure PowerShell](/azure/azure-resource-manager/templates/deploy-powershell), or [REST](/azure/azure-resource-manager/templates/deploy-rest).

# [Portal](#tab/portal)

1. In the Azure portal, select **Create a resource**, search for **template**, and then select **Template deployment**.
1. Select **Create**.
1. Select **Build your own template in editor**.
1. Select **Load file** and select your template file.
1. Select **Save**.
1. Fill in parameter values.
1. Select **Review + Create**.

For more information, see [Deploy resources with ARM templates and Azure portal](/azure/azure-resource-manager/templates/deploy-portal).

# [Azure CLI](#tab/cli)

The following Azure CLI example uses the [`az deployment group create`](/cli/azure/deployment/group#az-deployment-group-create) command.

```bash
# Set variables
resourceGroupName="<ResourceGroupName>"
deploymentName="<DeploymentName>"
templateFilePath="<TemplateFilePath>"
parametersFilePath="<ParametersFilePath>"

# Deploy the ARM template
az deployment group create \
  --name "$deploymentName" \
  --resource-group "$resourceGroupName" \
  --template-file "$templateFilePath" \
  --parameters "@$parametersFilePath"
```

[!INCLUDE [Azure CLI default endpoint](../includes/cli-default-endpoint.md)]

# [Azure PowerShell](#tab/powershell)

The following Azure PowerShell example uses the [`New-AzResourceGroupDeployment`](/powershell/module/az.resources/new-azresourcegroupdeployment) cmdlet.

```powershell
# Set variables
$resourceGroupName = "<ResourceGroupName>"
$deploymentName = "<DeploymentName>"
$templateFilePath = "<TemplateFilePath>"
$parametersFilePath = "<ParametersFilePath>"

# Define parameters for New-AzResourceGroupDeployment
$newAzResourceGroupDeploymentParams = @{
    Name                  = $deploymentName
    ResourceGroupName     = $resourceGroupName
    TemplateFile          = $templateFilePath
    TemplateParameterFile = $parametersFilePath
}

# Deploy the ARM template
New-AzResourceGroupDeployment @newAzResourceGroupDeploymentParams
```

[!INCLUDE [Azure PowerShell default endpoint](../includes/powershell-default-endpoint.md)]

# [REST](#tab/rest)

The following REST example uses the [`Deployments - Create Or Update`](azure-monitor-rest-api-index.md#op-monitor-deployments) REST API operation. It deploys a template and parameter file from URIs that Azure Resource Manager can access.

```REST
PUT https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/{deploymentName}?api-version={apiVersion}
Authorization: Bearer {accessToken}
Content-Type: application/json

{
  "properties": {
    "templateLink": {
      "uri": "<TemplateUri>",
      "contentVersion": "<TemplateContentVersion>"
    },
    "parametersLink": {
      "uri": "<ParametersUri>",
      "contentVersion": "<ParametersContentVersion>"
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
* [Diagnostic settings](../data-collection/resource-manager-diagnostic-settings.md): Create diagnostic settings to forward logs and metrics from different resource types.
* [Enable Prometheus metrics](../containers/kubernetes-monitoring-enable.md?tabs=bicep-arm): Install the Azure Monitor agent on your AKS cluster and send Prometheus metrics to your Azure Monitor workspace.
* [Log queries](../logs/resource-manager-log-queries.md): Create saved log queries in a Log Analytics workspace.
* [Log Analytics workspace](../logs/quick-create-workspace.md): Create a Log Analytics workspace and configure a collection of data sources from the Log Analytics agent.
* [Workbooks](../visualize/resource-manager-workbooks.md): Create workbooks.
* [Azure Monitor for VMs](../vm/vm-enable-monitoring.md#deploy-a-complete-onboarding-template): Onboard virtual machines to Azure Monitor for VMs.

## Next steps

Learn more about [Resource Manager templates](/azure/azure-resource-manager/templates/overview).
