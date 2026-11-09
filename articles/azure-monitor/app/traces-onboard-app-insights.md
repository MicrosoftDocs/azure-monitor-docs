---
title: Onboard Application Insights resources to Azure Monitor traces
description: Learn how to link Application Insights to an Azure Monitor workspace through the Azure portal or an ARM template to collect and analyze distributed traces.
ms.topic: get-started
ms.date: 11/09/2026
ai-usage: ai-assisted
---

# Onboard Application Insights resources to Azure Monitor traces

Onboard an Application Insights resource to store and analyze its distributed traces in an Azure Monitor workspace.

The process has three stages:

1. Meet the prerequisites.
1. Link the Application Insights resource to an Azure Monitor workspace through the Azure portal or an Azure Resource Manager (ARM) template.
1. Confirm that trace data appears in **Traces**.

> [!IMPORTANT]
> Azure Monitor traces and Trace Analytics are in preview. Preview features are provided without a service-level agreement and aren't recommended for production workloads.

## Prerequisites

- An Azure subscription.
- An Azure Monitor workspace in a supported region.
- One or more Application Insights resources in supported regions.
- The required resource providers registered.

### Required permissions

- To onboard resources, you need permission to update the Azure Monitor workspace and the Application Insights resources.
- To query traces or use Trace Analytics, you need at least Monitoring Reader access on the associated Azure Monitor workspace.

Access to the Application Insights resource or Log Analytics workspace alone doesn't grant access to traces in the Azure Monitor workspace. Assign the Monitoring Reader role at workspace scope to grant access to the required resource.

## Plan workspace architecture

Azure Monitor traces assembles related span telemetry from multiple resources into traces. Onboard all related Application Insights resources that you want to analyze together to a single centralized Azure Monitor workspace.

After onboarding, spans emitted by your application instrumentation continue to be ingested into Log Analytics and are also copied to Azure Monitor traces. The associated Azure Monitor workspace contains traces and trace-derived metrics. Its Azure role-based access control (RBAC) assignments, region, and data retention policy can differ from those of your Application Insights resource and Log Analytics workspace.

When possible, use the same Azure Monitor workspace for OpenTelemetry metrics, trace-derived metrics, and traces. Use the fewest Azure Monitor workspaces that meet your data security, data sovereignty, and data retention requirements.

> [!NOTE]
> To delete or purge trace data from an Azure Monitor workspace, submit a separate Azure support request. A request to delete or purge data in Application Insights or Log Analytics doesn't include the copy in Azure Monitor traces.

## Link an Application Insights resource

Linking an Application Insights resource with an Azure Monitor workspace associates the two resources. The workspace stores the trace data and metrics derived from those traces.

Choose either the Azure portal or an ARM template to link the resources.

### Use the Azure portal

Follow these steps to link the resources in the Azure portal.

1. In the Azure portal, open the Application Insights resource.
1. Under **Monitoring**, select **Traces**.
1. Select the option to enable Azure Monitor traces.
1. Select an Azure Monitor workspace.
1. Review the configuration, and then select **Save**.

Repeat these steps for each Application Insights resource that you want to include in at-scale end-to-end trace analysis.

### Use an ARM template

Use an Azure Resource Manager (ARM) template to programmatically link an existing Application Insights resource to an existing Azure Monitor workspace.

You must provide the `azureMonitorWorkspaceName` and `applicationInsightsName` parameters because they don't have default values. Enter the names of your existing Azure Monitor workspace and Application Insights resource when you deploy the template.

This template requires both resources to be in the same resource group and subscription. It doesn't create the Application Insights resource or Azure Monitor workspace.

The template uses API version `2026-09-03-preview` to create or update these resources:

- A `Microsoft.Monitor/accounts/traceContainers` resource named `default` under the Azure Monitor workspace.
- A `Microsoft.Monitor/traceAssociations` resource named `default` scoped to the Application Insights resource.

In addition to the onboarding permissions, you need permission to create resource group deployments. To run the deployment commands, use Azure CLI in Azure Cloud Shell with PowerShell or a local PowerShell session with Azure CLI installed. Sign in to the subscription that contains both resources.

#### Review the template

Save the following template as `TracesOnboarding.ApplicationInsights.Template.json`.

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "metadata": {
    "description": "Onboarding an existing Application Insights resource and Azure Monitor workspace to Azure Monitor traces. Creates or updates the default trace container and component association."
  },
  "parameters": {
    "azureMonitorWorkspaceName": {
      "type": "string",
      "minLength": 1,
      "metadata": {
        "description": "Name of an existing Azure Monitor workspace in the deployment resource group."
      }
    },
    "applicationInsightsName": {
      "type": "string",
      "minLength": 1,
      "metadata": {
        "description": "Name of an existing Application Insights resource in the deployment resource group."
      }
    },
    "traceRetentionInDays": {
      "type": "int",
      "defaultValue": 30,
      "metadata": {
        "description": "Trace retention in days. The service API validates the supported range."
      }
    },
    "traceDurationWindowInSeconds": {
      "type": "int",
      "defaultValue": 600,
      "metadata": {
        "description": "Trace duration window in seconds. The service API validates the supported range."
      }
    },
    "traceMetricsState": {
      "type": "string",
      "defaultValue": "Enabled",
      "allowedValues": [
        "Enabled",
        "Disabled"
      ],
      "metadata": {
        "description": "Whether the Azure Monitor workspace emits trace-derived metrics."
      }
    }
  },
  "variables": {
    "azureMonitorWorkspaceResourceId": "[resourceId('Microsoft.Monitor/accounts', parameters('azureMonitorWorkspaceName'))]",
    "applicationInsightsResourceId": "[resourceId('Microsoft.Insights/components', parameters('applicationInsightsName'))]",
    "traceContainerResourceId": "[resourceId('Microsoft.Monitor/accounts/traceContainers', parameters('azureMonitorWorkspaceName'), 'default')]"
  },
  "resources": [
    {
      "type": "Microsoft.Monitor/accounts/traceContainers",
      "apiVersion": "2026-09-03-preview",
      "name": "[format('{0}/default', parameters('azureMonitorWorkspaceName'))]",
      "properties": {
        "traceRetentionInDays": "[parameters('traceRetentionInDays')]",
        "traceDurationWindowInSeconds": "[parameters('traceDurationWindowInSeconds')]",
        "traceMetricsState": "[parameters('traceMetricsState')]"
      }
    },
    {
      "type": "Microsoft.Monitor/traceAssociations",
      "apiVersion": "2026-09-03-preview",
      "name": "default",
      "scope": "[format('Microsoft.Insights/components/{0}', parameters('applicationInsightsName'))]",
      "dependsOn": [
        "[variables('traceContainerResourceId')]"
      ],
      "properties": {
        "azureMonitorWorkspaceResourceId": "[variables('azureMonitorWorkspaceResourceId')]"
      }
    }
  ],
  "outputs": {
    "traceContainerResourceId": {
      "type": "string",
      "value": "[variables('traceContainerResourceId')]"
    },
    "traceAssociationResourceId": {
      "type": "string",
      "value": "[extensionResourceId(variables('applicationInsightsResourceId'), 'Microsoft.Monitor/traceAssociations', 'default')]"
    }
  }
}
```

#### Configure the parameters

Enter the names of your existing resources for the two required name parameters. You can also override the trace settings.

| Parameter | Description | Default |
|---|---|---|
| `azureMonitorWorkspaceName` | Name of the existing Azure Monitor workspace in the deployment resource group. | None. Required. |
| `applicationInsightsName` | Name of the existing Application Insights resource in the deployment resource group. | None. Required. |
| `traceRetentionInDays` | Trace retention period in days. | `30` |
| `traceDurationWindowInSeconds` | Trace duration window in seconds. | `600` |
| `traceMetricsState` | Whether trace-derived metrics are enabled. Accepts `Enabled` or `Disabled`. | `Enabled` |

> [!IMPORTANT]
> Deploying this template applies the supplied trace settings to the workspace's default trace container, including when that container already exists. These settings affect all Application Insights resources linked to that workspace. Review the values before deployment. If you omit the trace settings parameters, the template applies their default values.

#### Deploy the template

Replace `<subscription-id>` and `<resource-group-name>` with your subscription ID and resource group name. Replace `<azure-monitor-workspace-name>` and `<application-insights-name>` with the names of your existing Azure Monitor workspace and Application Insights resource. Remove the angle brackets when you substitute your values, and keep the quotation marks. Run the command from the folder where you saved the template.

```powershell
az deployment group create `
  --subscription "<subscription-id>" `
  --resource-group "<resource-group-name>" `
  --template-file ".\TracesOnboarding.ApplicationInsights.Template.json" `
  --parameters `
    azureMonitorWorkspaceName="<azure-monitor-workspace-name>" `
    applicationInsightsName="<application-insights-name>" `
    traceRetentionInDays=30 `
    traceDurationWindowInSeconds=600 `
    traceMetricsState=Enabled
```

The deployment returns the trace container and trace association resource IDs.

Repeat the deployment for each Application Insights resource that you want to link, changing `applicationInsightsName` to that resource's name. Keep `azureMonitorWorkspaceName` and the trace settings the same for resources that share the workspace. This example requires each Application Insights resource to be in the workspace's resource group.

After deployment succeeds, follow the steps in [Validate onboarding](#validate-onboarding) and [Confirm trace ingestion](#confirm-trace-ingestion).

## Validate onboarding

After you link the resource, confirm that you can reach trace data from either entry point.

1. Open the Application Insights resource or the associated Azure Monitor workspace.
1. Select **Traces**.

Both entry points use trace data associated with the Azure Monitor workspace. When you open **Traces** from the Application Insights resource, a span filter is applied automatically. It matches only traces that have at least one span emitted to that Application Insights resource.

## Confirm trace ingestion

Confirm that your application's traces arrive and you can find them.

1. Send trace data from an instrumented application.
1. Open **Traces** from the Application Insights resource or the associated Azure Monitor workspace.
1. Set a time range that includes the test request.
1. Run a trace search.

If no traces appear, confirm the following conditions:

- You have the required access described in [Required permissions](#required-permissions).
- Your application is emitting traces to Application Insights.

> [!NOTE]
> If you opened **Traces** from the Application Insights resource, you see only traces with at least one span emitted to that resource.

## Next step

To search and analyze the traces you now collect, see [Search and analyze traces with Trace Analytics](traces-search-analyze.md).