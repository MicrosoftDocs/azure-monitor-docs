---
title: Monitor Azure Monitor workspace metrics ingestion
description: How to monitor Azure Monitor workspace metrics ingestion and set up an alert on Azure Monitor workspace ingestion limits
ms.topic: how-to
ms.custom: references_regions
ms.date: 08/07/2026
ai-usage: ai-assisted
---

# Monitor Azure Monitor workspace metrics ingestion

Prometheus metrics are ingested into an Azure Monitor workspace. Azure Monitor workspaces have default limits and quotas for ingestion. When you reach the ingestion limits, throttling can occur. To avoid throttling, monitor and alert on the workspace ingestion limits.

For more information on Prometheus and Azure Monitor workspace limits and quotas, see [Azure Monitor service limits](../fundamentals/service-limits.md#prometheus-metrics).

## Ingestion limits

The following table summarizes the default ingestion limits for an Azure Monitor workspace and the maximum available through the ingestion-limit increase API.

| Limit | Default | Maximum | Notes |
|:------|:--------|:--------|:------|
| Events per minute | 1 million | 20 million (through the API) | Increases above 20 million require a support ticket. |
| Active time series | 1 million | 20 million (through the API) | Increases above 20 million require a support ticket. |

Limit increases up to 2 million are autoapproved. For increases above 2 million, current ingestion usage must reach 50% of the desired limit. For example, a workspace at a current limit of 5 million qualifies for an increase up to 10 million. For details, see [Request for an increase in ingestion limits (Preview)](#request-for-an-increase-in-ingestion-limits-preview).

## Prerequisites

* The Monitoring Contributor role, or an equivalent role, on the Azure Monitor workspace to create the recommended alert rules.
* Write access on the Azure Monitor workspace to request an ingestion-limit increase through the API.

## View limits and set up recommended alerts

An Azure Monitor workspace exposes a set of metrics that provide insight into ingestion limits and utilization. In the Azure portal, go to your Azure Monitor workspace and select **Metrics** under the **Monitoring** section.

1. In the **Select metric** dropdown, select **View standard metrics with the builder**.
1. In the **Add metric** dropdown, select **Add with builder**.
1. In the **Metric** drop-down, select **Active Time Series % Utilization** and **Events Per Minute Received % Utilization** and verify that they are below 100%.

The portal metric display names map to the following metric IDs used in the alert templates:

| Portal metric | Metric ID |
|:--------------|:----------|
| Active Time Series % Utilization | `ActiveTimeSeriesPercentUtilization` |
| Events Per Minute Received % Utilization | `EventsPerMinuteIngestedPercentUtilization` |

To monitor the ingestion limits, set up recommended alerts. Either [enable recommended out-of-the-box alert rules](../alerts/alerts-overview.md#recommended-alert-rules) or manually [create new alert rules](#query-and-alert-on-workspace-ingestion-metrics). The following alerts and default thresholds are created when you set up recommended alerts for an Azure Monitor workspace. You can change the default threshold values in the setup pane.

| Alert name | Description | Default threshold | Aggregation window (minutes) |
|:-----------|:------------|:-----------------:|:----------------------------:|
| AMW Is Approaching Event Ingestion Limit | The Events per min Ingestion utilization is above 75% of the current limit. | >75% | 30 |
| AMW Is Approaching Active TimeSeries Ingestion Limit | The TimeSeries Ingestion utilization is above 75% of the current limit. | >75% | 30 |
| AMW Is At High Risk Of Exceeding Event Ingestion Limit | The Events per min Ingestion utilization is above 95% of the current limit, and is at risk of getting throttled. [Request an increase](https://go.microsoft.com/fwlink/?linkid=2270124). | >95% | 30 |
| AMW Is At High Risk Of Exceeding Active TimeSeries Ingestion Limit | The TimeSeries Ingestion utilization is above 95% of the current limit, and is at risk of getting throttled. [Request an increase](https://go.microsoft.com/fwlink/?linkid=2270124). | >95% | 30 |

The alerts evaluate every five minutes (evaluation frequency) over a 30-minute aggregation window.

### [Azure portal](#tab/portal)

To enable the recommended alert rules, go to the Azure Monitor workspace in the Azure portal.
1. In the Monitoring section, select **Alerts** > **Set up recommended alerts**. The **Set up recommended alert rules** pane opens with a list of recommended alert rules for your Azure Monitor workspace.

    :::image type="content" source="media/azure-monitor-workspace-monitor-ingest-limits/azure-monitor-workspace-recommended-alerts.png" lightbox="media/azure-monitor-workspace-monitor-ingest-limits/azure-monitor-workspace-recommended-alerts.png" alt-text="Screenshot of Azure Monitor workspace recommended alert rules pane.":::

1. In the **Select Alert rules** section, select all of the rules you want to enable.
1. In the **Notify me by** section, select the way you want to be notified if an alert is triggered.
1. Select **Use an existing action group**, and enter the details of the existing action group if you want to use an action group that already exists.
1. Select **Save**.

### [ARM template (JSON)](#tab/arm)

These templates create the four recommended ingestion-limit alerts for an Azure Monitor workspace. To enable the recommended alert rules, use the following ARM template (JSON) and parameters files with any of the [standard deployment options](../fundamentals/resource-manager-samples.md#deploy-the-sample-templates).

**Template File**:

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "actionGroupResourceId": {
            "type": "string",
            "metadata": {
                "description": "Action Group ResourceId"
            }
        },
        "azureMonitorWorkspaceResourceId": {
            "type": "string",
            "metadata": {
                "description": "ResourceId of Azure Monitor Workspace (AMW) to associate to"
            }
        }
    },
    "variables": {
        "amwName": "[last(split(parameters('azureMonitorWorkspaceResourceId'), '/'))]"
    },
    "resources": [
        {
            "name": "[concat('AMW Is Approaching Event Ingestion Limit - ', variables('amwName'))]",
            "type": "Microsoft.Insights/metricAlerts",
            "apiVersion": "2024-03-01-preview",
            "location": "global",
            "tags": {
                "alertRuleCreatedWithAlertsRecommendations": "true"
            },
            "properties":
            {
                "description": "AMW Is Approaching Event Ingestion Limit - Request for an increase https://go.microsoft.com/fwlink/?linkid=2270124",
                "severity": 3,
                "enabled": true,
                "scopes": [
                    "[parameters('azureMonitorWorkspaceResourceId')]"
                ],
                "evaluationFrequency": "PT5M",
                "windowSize": "PT30M",
                "criteria": {
                    "allOf": [
                    {
                        "threshold": 75,
                        "name": "EventsCriteria",
                        "metricName": "EventsPerMinuteIngestedPercentUtilization",
                        "operator": "GreaterThan",
                        "timeAggregation": "Average",
                        "criterionType": "StaticThresholdCriterion"
                    }
                ],
                "odata.type": "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                },
                "actions": [
                    {
                        "actionGroupId": "[parameters('actionGroupResourceId')]"
                    }
                ]
            }
        },
        {
            "name": "[concat('AMW Is Approaching Active TimeSeries Ingestion Limit - ', variables('amwName'))]",
            "type": "Microsoft.Insights/metricAlerts",
            "apiVersion": "2024-03-01-preview",
            "location": "global",
            "tags": {
                "alertRuleCreatedWithAlertsRecommendations": "true"
            },
            "properties":
            {
                "description": "AMW Is Approaching Active Timeseries Limit - Request for an increase https://go.microsoft.com/fwlink/?linkid=2270124",
                "severity": 3,
                "enabled": true,
                "scopes": [
                    "[parameters('azureMonitorWorkspaceResourceId')]"
                ],
                "evaluationFrequency": "PT5M",
                "windowSize": "PT30M",
                "criteria": {
                    "allOf": [
                    {
                        "threshold": 75,
                        "name": "TimeSeriesCriteria",
                        "metricName": "ActiveTimeSeriesPercentUtilization",
                        "operator": "GreaterThan",
                        "timeAggregation": "Average",
                        "criterionType": "StaticThresholdCriterion"
                    }
                ],
                "odata.type": "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                },
                "actions": [
                    {
                        "actionGroupId": "[parameters('actionGroupResourceId')]"
                    }
                ]
            }
        },
        {
            "name": "[concat('AMW Is At High Risk Of Exceeding Event Ingestion Limit - ', variables('amwName'))]",
            "type": "Microsoft.Insights/metricAlerts",
            "apiVersion": "2024-03-01-preview",
            "location": "global",
            "tags": {
                "alertRuleCreatedWithAlertsRecommendations": "true"
            },
            "properties":
            {
                "description": "AMW Is At High Risk Of Exceeding Event Ingestion Limit - Request for an increase https://go.microsoft.com/fwlink/?linkid=2270124",
                "severity": 2,
                "enabled": true,
                "scopes": [
                    "[parameters('azureMonitorWorkspaceResourceId')]"
                ],
                "evaluationFrequency": "PT5M",
                "windowSize": "PT30M",
                "criteria": {
                    "allOf": [
                    {
                        "threshold": 95,
                        "name": "EventsCriteria",
                        "metricName": "EventsPerMinuteIngestedPercentUtilization",
                        "operator": "GreaterThan",
                        "timeAggregation": "Average",
                        "criterionType": "StaticThresholdCriterion"
                    }
                ],
                "odata.type": "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                },
                "actions": [
                    {
                        "actionGroupId": "[parameters('actionGroupResourceId')]"
                    }
                ]
            }
        },
        {
            "name": "[concat('AMW Is At High Risk Of Exceeding Active TimeSeries Ingestion Limit - ', variables('amwName'))]",
            "type": "Microsoft.Insights/metricAlerts",
            "apiVersion": "2024-03-01-preview",
            "location": "global",
            "tags": {
                "alertRuleCreatedWithAlertsRecommendations": "true"
            },
            "properties":
            {
                "description": "AMW Is At High Risk Of Exceeding Active TimeSeries Limit - Request for an increase https://go.microsoft.com/fwlink/?linkid=2270124",
                "severity": 2,
                "enabled": true,
                "scopes": [
                    "[parameters('azureMonitorWorkspaceResourceId')]"
                ],
                "evaluationFrequency": "PT5M",
                "windowSize": "PT30M",
                "criteria": {
                    "allOf": [
                    {
                        "threshold": 95,
                        "name": "TimeSeriesCriteria",
                        "metricName": "ActiveTimeSeriesPercentUtilization",
                        "operator": "GreaterThan",
                        "timeAggregation": "Average",
                        "criterionType": "StaticThresholdCriterion"
                    }
                ],
                "odata.type": "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                },
                "actions": [
                    {
                        "actionGroupId": "[parameters('actionGroupResourceId')]"
                    }
                ]
            }
        }
    ]
}
```

**Parameters file**: Update `<ResourceId of the Azure Monitor Workspace>` and `<ResourceId of the Action Group>` in the *Parameters.json* file.

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "azureMonitorWorkspaceResourceId": {
            "value": "<ResourceId of the Azure Monitor Workspace>"
        },
        "actionGroupResourceId": {
            "value": "<ResourceId of the Action Group>"
        }
    }
}
```

Run the below commands to execute the Resource Manager template deployment:

**Azure CLI**

```azurecli
az login
az account set --subscription <subscriptionId>
az deployment group create --name AMWRecAlerts --resource-group <resourceGroupName> --template-file <template-file-as-above.json> --parameters <parameters-file-as-above.json>
```

**Azure PowerShell**

```powershell
Connect-AzAccount
New-AzResourceGroupDeployment -Name AMWRecAlerts -ResourceGroupName <resourceGroupName> -TemplateFile <template-file-as-above.json> -TemplateParameterFile <parameters-file-as-above.json>
```

### [Bicep](#tab/bicep)

These templates create the four recommended ingestion-limit alerts for an Azure Monitor workspace. To enable the recommended alert rules, use the Bicep template and parameters file.

**Template File**:

```bicep
@description('Action Group ResourceId')
param actionGroupResourceId string

@description('ResourceId of Azure Monitor Workspace (AMW) to associate to')
param azureMonitorWorkspaceResourceId string

var amwName = last(split(azureMonitorWorkspaceResourceId, '/'))

resource AMW_Is_Approaching_Event_Ingestion_Limit_amw 'Microsoft.Insights/metricAlerts@2024-03-01-preview' = {
    name: 'AMW Is Approaching Event Ingestion Limit - ${amwName}'
    location: 'global'
    tags: {
        alertRuleCreatedWithAlertsRecommendations: 'true'
    }
    properties: {
        description: 'AMW Is Approaching Event Ingestion Limit - Request for an increase https://go.microsoft.com/fwlink/?linkid=2270124'
        severity: 3
        enabled: true
        scopes: [
            azureMonitorWorkspaceResourceId
        ]
        evaluationFrequency: 'PT5M'
        windowSize: 'PT30M'
        criteria: {
            allOf: [
                {
                    threshold: 75
                    name: 'EventsCriteria'
                    metricName: 'EventsPerMinuteIngestedPercentUtilization'
                    operator: 'GreaterThan'
                    timeAggregation: 'Average'
                    criterionType: 'StaticThresholdCriterion'
                }
            ]
            'odata.type': 'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'
        }
        actions: [
            {
                actionGroupId: actionGroupResourceId
            }
        ]
    }
}

resource AMW_Is_Approaching_Active_TimeSeries_Ingestion_Limit_amw 'Microsoft.Insights/metricAlerts@2024-03-01-preview' = {
    name: 'AMW Is Approaching Active TimeSeries Ingestion Limit - ${amwName}'
    location: 'global'
    tags: {
        alertRuleCreatedWithAlertsRecommendations: 'true'
    }
    properties: {
        description: 'AMW Is Approaching Active Timeseries Limit - Request for an increase https://go.microsoft.com/fwlink/?linkid=2270124'
        severity: 3
        enabled: true
        scopes: [
            azureMonitorWorkspaceResourceId
        ]
        evaluationFrequency: 'PT5M'
        windowSize: 'PT30M'
        criteria: {
            allOf: [
                {
                    threshold: 75
                    name: 'TimeSeriesCriteria'
                    metricName: 'ActiveTimeSeriesPercentUtilization'
                    operator: 'GreaterThan'
                    timeAggregation: 'Average'
                    criterionType: 'StaticThresholdCriterion'
                }
            ]
          'odata.type': 'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'
        }
        actions: [
            {
                actionGroupId: actionGroupResourceId
            }
        ]
    }
}

resource AMW_Is_At_High_Risk_Of_Exceeding_Event_Ingestion_Limit_amw 'Microsoft.Insights/metricAlerts@2024-03-01-preview' = {
    name: 'AMW Is At High Risk Of Exceeding Event Ingestion Limit - ${amwName}'
    location: 'global'
    tags: {
        alertRuleCreatedWithAlertsRecommendations: 'true'
    }
    properties: {
        description: 'AMW Is At High Risk Of Exceeding Event Ingestion Limit - Request for an increase https://go.microsoft.com/fwlink/?linkid=2270124'
        severity: 2
        enabled: true
        scopes: [
            azureMonitorWorkspaceResourceId
        ]
        evaluationFrequency: 'PT5M'
        windowSize: 'PT30M'
        criteria: {
            allOf: [
                {
                    threshold: 95
                    name: 'EventsCriteria'
                    metricName: 'EventsPerMinuteIngestedPercentUtilization'
                    operator: 'GreaterThan'
                    timeAggregation: 'Average'
                    criterionType: 'StaticThresholdCriterion'
                }
            ]
            'odata.type': 'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'
        }
        actions: [
            {
                actionGroupId: actionGroupResourceId
            }
        ]
    }
}

resource AMW_Is_At_High_Risk_Of_Exceeding_Active_TimeSeries_Ingestion_Limit_amw 'Microsoft.Insights/metricAlerts@2024-03-01-preview' = {
    name: 'AMW Is At High Risk Of Exceeding Active TimeSeries Ingestion Limit - ${amwName}'
    location: 'global'
    tags: {
        alertRuleCreatedWithAlertsRecommendations: 'true'
    }
    properties: {
        description: 'AMW Is At High Risk Of Exceeding Active TimeSeries Limit - Request for an increase https://go.microsoft.com/fwlink/?linkid=2270124'
        severity: 2
        enabled: true
        scopes: [
            azureMonitorWorkspaceResourceId
        ]
        evaluationFrequency: 'PT5M'
        windowSize: 'PT30M'
        criteria: {
            allOf: [
                {
                    threshold: 95
                    name: 'TimeSeriesCriteria'
                    metricName: 'ActiveTimeSeriesPercentUtilization'
                    operator: 'GreaterThan'
                    timeAggregation: 'Average'
                    criterionType: 'StaticThresholdCriterion'
                }
            ]
            'odata.type': 'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'
        }
        actions: [
            {
                actionGroupId: actionGroupResourceId
            }
        ]
    }
}
```

**Parameters file**: Update `<ResourceId of the Azure Monitor Workspace>` and `<ResourceId of the Action Group>` in the *parameters.bicepparam* file.

```bicep
// Save as: parameters.bicepparam
// Update the path in `using` to point to your Bicep template file.
using '<template-file-as-above.bicep>'

param azureMonitorWorkspaceResourceId string = '<ResourceId of the Azure Monitor Workspace>'
param actionGroupResourceId string = '<ResourceId of the Action Group>'
```

Run the below commands to execute the Bicep template deployment:

**Azure CLI**

```azurecli
az login
az account set --subscription <subscriptionId>
az deployment group create --name AMWRecAlerts --resource-group <resourceGroupName> --template-file <template-file-as-above.bicep> --parameters <parameters-file-as-above.bicepparam>
```

**Azure PowerShell**

```powershell
Connect-AzAccount
New-AzResourceGroupDeployment -Name AMWRecAlerts -ResourceGroupName <resourceGroupName> -TemplateFile <template-file-as-above.bicep> -TemplateParameterFile <parameters-file-as-above.bicepparam>
```

---

## Request for an increase in ingestion limits (Preview)

Request for an increase in ingestion limits using Azure Resource Manager API. This API is in Preview and below conditions apply with this API:

* Request an increase from the default 1 million events per minute or active time series to up to 20 million events per minute or active time series by using an API update through the CLI or an ARM template deployment. For limits above 20 million, create a support ticket.
    * For a limit increase request up to 2 million, the request is autoapproved.
    * For a limit increase request above 2 million, current ingestion usage must be at 50% of the desired limit. For example, if the current limit is 5 million, the maximum request is 10 million, up to an overall maximum of 20 million.
    * For requests beyond 20 million, create a support ticket.
* Creation of an Azure Monitor workspace always applies the default limits. **Creating** an Azure Monitor workspace with custom limits isn't supported.

This article explains how to use the Azure Resource Manager API to update the data ingestion limits of your Azure Monitor workspaces.

### Limit-increase prerequisites

A command-line tool to run the ARM template commands, such as Azure PowerShell, or Azure CLI.

### Step 1: Download the ARM templates and update the parameters

> [!NOTE]
> If you prefer Bicep over an ARM template (JSON), decompile the following template and parameters files. For more information, see [Decompile a JSON Azure Resource Manager template to Bicep](/azure/azure-resource-manager/bicep/decompile?tabs=azure-cli).

Download the ARM template files ([AMWLimitIncrease-Template.json](https://github.com/Azure/prometheus-collector/blob/main/internal/docs/AMWLimitIncrease-Template.json) and [AMWLimitIncrease-Parameters.json](https://github.com/Azure/prometheus-collector/blob/main/internal/docs/AMWLimitIncrease-Parameters.json)) and update the Parameters.json file with the *subscription id*, *name of the resource group that contains the Azure Monitor workspace*, *name of the Azure Monitor workspace*, *location of the Azure Monitor workspace*, and required ingestion limits (maximum is 20000000).

### Step 2: Deploy the ARM template

Run the below commands from the downloaded ARM templates folder:

**Azure CLI**

```azurecli
az login
az account set --subscription <subscriptionId>
az deployment group create --name AmwLimits --resource-group <resourceGroupName> --template-file AMWLimitIncrease-Template.json --parameters AMWLimitIncrease-Parameters.json
```

**Azure PowerShell**

```powershell
Connect-AzAccount
New-AzResourceGroupDeployment -Name AmwLimits -ResourceGroupName <resourceGroupName> -TemplateFile AMWLimitIncrease-Template.json -TemplateParameterFile AMWLimitIncrease-Parameters.json
```

### Step 3: Verify if the limits are updated

To verify the limits updated successfully, go to the Azure portal, navigate to the Azure Monitor workspace, open Metrics explorer, and in the Metric dropdown select **View standard metrics with the builder**. Then verify that the updated limits apply to the **Active Time Series Limit** and **Events per minute Ingested Limit**.

### Troubleshoot issues with increasing ingestion limits using the Azure Resource Manager API

If you see an error when using the API to request for a limit increase, check the error response to find the cause of the error.

* Requested limit is above 20 million: `ActiveTimeSeries quota requested exceeds the maximum limit of {MaxAutoApprovedActiveTimeSeries}`: This error occurs when you request a limit above 20 million events per minute or active time series. Currently, the API only supports an increase up to 20 million. To request a higher ingestion limit, create a support ticket.

* Usage is less compared to requested limit: The current utilization doesn't meet the criteria for MaxTimeSeries quota requested. This error occurs when your current ingestion is less than 50% of the requested limit. Reach the required usage threshold of 50% of desired limit before requesting an increase, or request a limit increase of up to 200% of your current usage. To check the current usage, go to the Azure portal, navigate to the Azure Monitor workspace, open Metrics explorer, and in the Metric dropdown select "View standard metrics with the builder," and then select "Active Time Series % Utilization" and "Events per minute received % Utilization".

## Request for an increase in ingestion limits through support ticket

To open a support ticket:

1. Select **Support + Troubleshooting** from the left pane of the Azure portal. 
1. Enter *Service and subscription limits (quotas)* in the search field and select **Go**.
1. Select **Service and subscription limits (quotas)**, select **Next**, then select **Create a new support request**.
1. Select your subscription and then select **Managed Prometheus** as the **Quota type**.
1. Complete the requested details and submit the request.

## Query and alert on workspace ingestion metrics

To query Azure Monitor workspace metrics to monitor the ingestion limits, use the following steps:

1. In the Azure portal, navigate to your Azure Monitor workspace and select **Metrics** under the **Monitoring** section.

1. In the **Add metric** dropdown, select **Add with builder**.

1. Select the Azure Monitor workspace as scope.

1. Select **Standard metrics** for the **Metric Namespace**.

1. In the **Metric** drop-down, select **Active Time Series % Utilization** and **Events Per Minute Received % Utilization** and verify that they are below 100%.

    :::image type="content" source="media/azure-monitor-workspace-monitor-ingest-limits/monitor-ingest-limits.png" lightbox="media/azure-monitor-workspace-monitor-ingest-limits/monitor-ingest-limits.png" alt-text="Screenshot that shows a metrics chart for Azure Monitor workspace metrics.":::

1. Select **New alert rule** to create an Azure alert. Set an Azure Alert to monitor the utilization and fire an alert when the utilization is greater than a certain threshold. For more information, see [Create a metric alert for an Azure resource](../alerts/tutorial-metric-alert.md).

    :::image type="content" source="media/azure-monitor-workspace-monitor-ingest-limits/create-alert.png" lightbox="media/azure-monitor-workspace-monitor-ingest-limits/create-alert.png" alt-text="Screenshot that shows how to create an alert for Azure Monitor workspace limits.":::

See your alerts in the Azure portal by selecting **Alerts** under the **Monitoring** section of your Azure Monitor workspace.

The alert is fired if the ingestion utilization is more than the threshold. Request an increase in the limit by creating a support ticket.

## Next steps

* [Azure Monitor service limits](../fundamentals/service-limits.md#prometheus-metrics)
* [Create an alert rule in Azure Monitor](../alerts/alerts-create-metric-alert-rule.md)
* [Create a metric alert for an Azure resource](../alerts/tutorial-metric-alert.md)
