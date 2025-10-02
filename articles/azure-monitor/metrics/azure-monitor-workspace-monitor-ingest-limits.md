---
title: Monitor Azure Monitor workspace metrics ingestion
description: How to monitor Azure Monitor workspace metrics ingestion and set up an alert on Azure Monitor Workspace ingestion limits
ms.topic: how-to
ms.date: 10/06/2024
---

# Monitor Azure Monitor workspace metrics ingestion

Prometheus metrics are ingested into an Azure Monitor workspace. Azure monitor workspaces have default limits and quotas for ingestion. When you reach the ingestion limits, throttling can occur. In order to avoid throttling, you can monitor and alert on the workspace ingestion limits. 

For more information on Prometheus and Azure Monitor workspace limits and quotas, see [Azure Monitor service limits](../fundamentals/service-limits.md#prometheus-metrics).

## View limits and set up recommended alerts

Azure Monitor Workspace exposes a set of metrics that provide insight into ingestion limits and utilization. In the Azure portal, navigate to your Azure Monitor workspace and select **Metrics** under the **Monitoring** section.

1. In the **Select metric** dropdown, select **View standard metrics with the builder**.
1. In the **Add metric** dropdown, select **Add with builder**.
1. In the **Metric** drop-down, select **Active Time Series % Utilization** and **Events Per Minute Received % Utilization** and verify that they are below 100%.

You can **set up recommended alerts** for Azure Monitor Workspace to monitor the ingestion limits, you can either [enable recommended out-of-the-box alerts](../alerts/alerts-overview.md#recommended-alert-rules) rules, or manually [create new alert rules](#query-and-alert-on-workspace-ingestion-metrics).

To enable the recommended alert rules, navigate to the Azure Monitor Workspace in Azure portal.
1. In the Monitoring section, select **Alerts** > **Set up recommended alerts**. The **Set up recommended alert rules** pane opens with a list of recommended alert rules for your Azure Monitor workspace.  
        
   :::image type="content" source="media/azure-monitor-workspace-monitor-ingest-limits/azure-monitor-workspace-recommended-alerts.png" lightbox="media/azure-monitor-workspace-monitor-ingest-limits/azure-monitor-workspace-recommended-alerts.png" alt-text="Screenshot of Azure Monitor Workspace recommended alert rules pane.":::

1. In the **Select Alert rules** section, select all of the rules you want to enable. 
1. In the **Notify me by** section, select the way you want to be notified if an alert is triggered.
1. Select **Use an existing action group**, and enter the details of the existing action group if you want to use an action group that already exists.
1. Select **Save**.

## Request for an increase in ingestion limits (Preview)

Request for an increase in ingestion limits using Azure Resource Manager API. This API is in Preview and below conditions apply with this API:

- Request for an increase in limit from the default 1 Million events/min or active Timeseries to up to 20 Million events/min or active Timeseries with an API update through cli or through ARM update. For limits above 20 Million, create a support ticket.
  - For limit increase request up to 2 Million, request is autoapproved.
  - For limit increase request above 2 Million, current ingestion usage should be at 50% of desired limit, that is, if the current limit is 5 Million, they can request for increase upto 10 Million. You can request up to 20 Million.
  - For requests beyond 20 Million, create a support ticket.
- Creation of an Azure Monitor Workspace always applies the default limits. **Creating** an Azure Monitor Workspace with custom limits is not supported.

This document explains how to use the ARM API to update the data ingestion limits of your Azure Monitor Workspaces. 

### Prerequisites

- A command-line tool to run the ARM template commands, such as Azure PowerShell, or Azure CLI

### Step 1: Download the ARM templates and update the parameters

Download the ARM template files ([AMWLimitIncrease-Template.json](https://github.com/Azure/prometheus-collector/blob/main/internal/docs/AMWLimitIncrease-Template.json) and [AMWLimitIncrease-Parameters.json](https://github.com/Azure/prometheus-collector/blob/main/internal/docs/AMWLimitIncrease-Parameters.json) and update the Parameters.json file with the *subscription id*, *name of the resource group where the AMW is in*, *Name of the AMW*, *location of the AMW*, and required ingestion limits (maximum is 20000000).

### Step 2: Execute the ARM update

Run the below commands from the downloaded ARM templates folder:

For Azure CLI:

```azurecli
az login
az account set --subscription <subscriptionId>
az deployment group create --name AmwLimits --resource-group <resourceGroupName> --template-file AMWLimitIncrease-Template.json --parameters AMWLimitIncrease-Parameters.json
```

For Azure PowerShell:

```
Connect-AzAccount
New-AzResourceGroupDeployment -Name AmwLimits -ResourceGroupName  <resourceGroupName> -TemplateFile AMWLimitIncrease-Template.json -TemplateParameterFile AMWLimitIncrease-Parameters.json
```

### Step 3: Verify if the limits are updated

To verify if the limits are updated successfully, you can go to the Azure portal, navigate to the Azure Monitor Workspace -> Metrics explorer -> In the Metric dropdown, select "View standard metrics with the builder", and then verify if the updated limits are applied to the "Active Time Series Limit" and "Events per minute Ingested Limit".

### Troubleshoot issues with increasing ingestion limits using ARM API

If you see an error when using the API to request for a limit increase, check the error response to find the cause of the error.

-	Requested limit is above 20 Million: "ActiveTimeSeries quota requested exceeds the maximum limit of {MaxAutoApprovedActiveTimeSeries}": This error occurs when you request for a limit of 20 Million or more events/min or Active Timeseries. Currently the API only supports an increase up to 20M. You can request for more ingestion limit by creating a support ticket.
-	Usage is less compared to requested limit: The current utilization does not meet the criteria for MaxTimeSeries quota requested. This error occurs when your current ingestion is less than 50% of the requested limit. Reach the required usage threshold of 50% of desired limit before requesting an increase, or request a limit increase of up to 200% of your current usage. To check the current usage, go to the Azure portal, navigate to the Azure Monitor Workspace -> Metrics explorer -> In the Metric dropdown, select "View standard metrics with the builder," and then select "Active Time Series % Utilization" and "Events per minute received % Utilization".


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

    :::image type="content" source="media/azure-monitor-workspace-monitor-ingest-limits/create-alert.png" lightbox="media/azure-monitor-workspace-monitor-ingest-limits/create-alert.png" alt-text="Screenshot that shows how to create an alert for Azure Monitor Workspace limits.":::

See your alerts in the Azure portal by selecting **Alerts** under the **Monitoring** section of your Azure Monitor workspace.

The alert is fired if the ingestion utilization is more than the threshold. Request an increase in the limit by creating a support ticket.

## Next steps

* [Azure Monitor service limits](../fundamentals/service-limits.md#prometheus-metrics)
* [Create an alert rule in Azure Monitor](../alerts/alerts-create-metric-alert-rule.md)
* [Create a metric alert for an Azure resource](../alerts/tutorial-metric-alert.md)
