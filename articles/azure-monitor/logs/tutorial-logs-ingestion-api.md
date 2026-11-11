---
title: 'Tutorial: Send data to Azure Monitor Logs with Logs ingestion API (Resource Manager templates)'
description: Tutorial on how sending data to a Log Analytics workspace in Azure Monitor using the Logs ingestion API. Supporting components configured using Resource Manager templates.
ms.topic: tutorial
ms.custom: cbo-v1.6
ms.date: 08/29/2025
ai-usage: ai-assisted
---

# Tutorial: Send data to Azure Monitor using Logs ingestion API (Resource Manager templates)

The [Logs Ingestion API](logs-ingestion-api-overview.md) in Azure Monitor allows you to send custom data to a Log Analytics workspace. This tutorial uses Azure Resource Manager templates (ARM templates) to walk through configuration of the components required to support the API and then provides a sample application using both the REST API and client libraries for [.NET](/dotnet/api/overview/azure/Monitor.Ingestion-readme), [Go](https://pkg.go.dev/github.com/Azure/azure-sdk-for-go/sdk/monitor/ingestion/azlogs), [Java](/java/api/overview/azure/monitor-ingestion-readme), [JavaScript](/javascript/api/overview/azure/monitor-ingestion-readme), and [Python](/python/api/overview/azure/monitor-ingestion-readme).

> [!NOTE]
> This tutorial uses ARM templates to configure the components required to support the Logs ingestion API. See [Tutorial: Send data to Azure Monitor Logs with Logs ingestion API (Azure portal)](tutorial-logs-ingestion-portal.md) for a similar tutorial that uses the Azure portal UI to configure these components.

The steps required to configure the Logs ingestion API are as follows:

1. [Create a Microsoft Entra application](#create-azure-ad-application) to authenticate against the API.
1. [Create a custom table in a Log Analytics workspace](#create-new-table-in-log-analytics-workspace). This is the table you'll be sending data to.
1. [Create a data collection rule (DCR)](#create-data-collection-rule) to direct the data to the target table. 
1. [Give the Microsoft Entra application access to the DCR](#assign-permissions-to-a-dcr).
1. See [Sample code to send data to Azure Monitor using Logs ingestion API](tutorial-logs-ingestion-code.md) for sample code to send data to using the Logs ingestion API.

> [!NOTE]
> This article includes options for using a DCR ingestion endpoint or a data collection endpoint (DCE). Choose either one, but a DCE is required with Logs ingestion API if private link is used. See [When is a DCE required?](../data-collection/data-collection-endpoint-overview.md#when-is-a-dce-required).

## Prerequisites
To complete this tutorial, you need:

* A Log Analytics workspace where you have at least [contributor rights](manage-access.md#azure-rbac).
* [Permissions to create DCR objects](../data-collection/data-collection-rule-create-edit.md#permissions) in the workspace.

## Collect workspace details

Start by gathering information that you'll need from your workspace.

Go to your workspace in the **Log Analytics workspaces** menu in the Azure portal. On the **Properties** page, copy the **Resource ID** and save it for later use. Record the subscription ID, resource group name, workspace name, and workspace region.

> [!NOTE]
> The templates use those individual values to construct the workspace resource ID.

:::image type="content" source="media/tutorial-logs-ingestion-api/workspace-resource-id.png" lightbox="media/tutorial-logs-ingestion-api/workspace-resource-id.png" alt-text="Screenshot that shows the workspace resource ID.":::

<a name='create-azure-ad-application'></a>

## Create Microsoft Entra application
Start by registering a Microsoft Entra application to authenticate against the API.

> [!NOTE]
> Any Resource Manager authentication scheme is supported, but this tutorial follows the [Client Credential Grant Flow scheme](/azure/active-directory/develop/v2-oauth2-client-creds-grant-flow).

1. On the **Microsoft Entra ID** menu in the Azure portal, select **App registrations** > **New registration**.

    :::image type="content" source="media/tutorial-logs-ingestion-portal/new-app-registration.png" lightbox="media/tutorial-logs-ingestion-portal/new-app-registration.png" alt-text="Screenshot that shows the app registration screen.":::

1. Give the application a name and change the tenancy scope if the default isn't appropriate for your environment. A **Redirect URI** isn't required.

    :::image type="content" source="media/tutorial-logs-ingestion-portal/new-app-name.png" lightbox="media/tutorial-logs-ingestion-portal/new-app-name.png" alt-text="Screenshot that shows app details.":::

1. After registration, you can view the details of the application. Note the **Application (client) ID** and the **Directory (tenant) ID**. You'll need these values later in the process.

    :::image type="content" source="media/tutorial-logs-ingestion-portal/new-app-id.png" lightbox="media/tutorial-logs-ingestion-portal/new-app-id.png" alt-text="Screenshot that shows the app ID.":::

1. Generate an application client secret, which is similar to creating a password to use with a username. Select **Certificates & secrets** > **New client secret**. Give the secret a name to identify its purpose and select an **Expires** duration.

    > [!NOTE]
    > The option **12 months** is selected here. For a production implementation, follow best practices for a secret rotation procedure or use a more secure authentication mode, such as a certificate.

    :::image type="content" source="media/tutorial-logs-ingestion-portal/new-app-secret.png" lightbox="media/tutorial-logs-ingestion-portal/new-app-secret.png" alt-text="Screenshot that shows the secret for the new app.":::

1. Select **Add** to save the secret and then note the **Value**. Ensure that you record this value because you can't recover it after you leave this page. Use the same security measures as you would for safekeeping a password because it's the functional equivalent.

    :::image type="content" source="media/tutorial-logs-ingestion-portal/new-app-secret-value.png" lightbox="media/tutorial-logs-ingestion-portal/new-app-secret-value.png" alt-text="Screenshot that shows the secret value for the new app.":::

## Create data collection endpoint

A [DCE](../data-collection/data-collection-endpoint-overview.md) provides an ingestion endpoint for data sent to Azure Monitor. Skip this section if you use the DCR ingestion endpoint without private link. If you use a DCE, configure it, link it to the DCR, and use its ingestion endpoint in your application. The DCE must be in the same region as the DCR and the destination Log Analytics workspace.

1. In the Azure portal's search box, enter **template** and then select **Deploy a custom template**.

    :::image type="content" source="media/tutorial-workspace-transformations-api/deploy-custom-template.png" lightbox="media/tutorial-workspace-transformations-api/deploy-custom-template.png" alt-text="Screenshot that shows how to deploy a custom template.":::

1. Select **Build your own template in the editor**.

    :::image type="content" source="media/tutorial-workspace-transformations-api/build-custom-template.png" lightbox="media/tutorial-workspace-transformations-api/build-custom-template.png" alt-text="Screenshot that shows how to build a template in the editor.":::

1. For the portal procedure, use the **ARM template** tab, configure the template in the editor, and select **Save**. You can instead use the Bicep equivalent with the [Bicep deployment commands](/azure/azure-resource-manager/bicep/deploy-to-resource-group).

    :::image type="content" source="media/tutorial-workspace-transformations-api/edit-template.png" lightbox="media/tutorial-workspace-transformations-api/edit-template.png" alt-text="Screenshot that shows how to edit an ARM template.":::

    > [!NOTE]
    > The following templates create a DCE for this tutorial:
    >
    > * Use the same region as the workspace and DCR.
    > * The sample enables public network access. For private-link ingestion, follow [Azure Monitor Private Link configuration](../fundamentals/private-link-configure.md) and retain the required network settings.
    >
    > Template deployments create or update resources; they aren't partial PATCH operations. If you reuse an existing DCE, preserve its network access, identity, tags, and other required configuration.

    # [Bicep](#tab/bicep)

    The following Bicep example uses the [`Microsoft.Insights/dataCollectionEndpoints`](/azure/templates/microsoft.insights/datacollectionendpoints?pivots=deployment-language-bicep) resource type.

    ```bicep
    @description('Specifies the name of the data collection endpoint to create.')
    param dataCollectionEndpointName string = '<DataCollectionEndpointName>'

    @description('Specifies the region for the data collection endpoint.')
    param azureRegion string = '<AzureRegion>'

    resource dataCollectionEndpoint 'Microsoft.Insights/dataCollectionEndpoints@<ApiVersion>' = {
      name: dataCollectionEndpointName
      location: azureRegion
      properties: {
        networkAcls: {
          publicNetworkAccess: 'Enabled'
        }
      }
    }

    output dataCollectionEndpointId string = dataCollectionEndpoint.id
    ```

    # [ARM template](#tab/arm)

    The following ARM template example uses the [`Microsoft.Insights/dataCollectionEndpoints`](/azure/templates/microsoft.insights/datacollectionendpoints?pivots=deployment-language-arm-template) resource type.

    ```json
    {
      "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
      "contentVersion": "1.0.0.0",
      "parameters": {
        "dataCollectionEndpointName": {
          "type": "string",
          "defaultValue": "<DataCollectionEndpointName>",
          "metadata": {
            "description": "Specifies the name of the data collection endpoint to create."
          }
        },
        "azureRegion": {
          "type": "string",
          "defaultValue": "<AzureRegion>",
          "metadata": {
            "description": "Specifies the region for the data collection endpoint."
          }
        }
      },
      "resources": [
        {
          "type": "Microsoft.Insights/dataCollectionEndpoints",
          "apiVersion": "<ApiVersion>",
          "name": "[parameters('dataCollectionEndpointName')]",
          "location": "[parameters('azureRegion')]",
          "properties": {
            "networkAcls": {
              "publicNetworkAccess": "Enabled"
            }
          }
        }
      ],
      "outputs": {
        "dataCollectionEndpointId": {
          "type": "string",
          "value": "[resourceId('Microsoft.Insights/dataCollectionEndpoints', parameters('dataCollectionEndpointName'))]"
        }
      }
    }
    ```

    ---

1. On the **Custom deployment** screen, specify a **Subscription** and **Resource group** to store the DCE, and provide the template parameters. Set `azureRegion` to the workspace's region.

    :::image type="content" source="media/tutorial-logs-ingestion-api/data-collection-endpoint-custom-deploy.png" lightbox="media/tutorial-logs-ingestion-api/data-collection-endpoint-custom-deploy.png" alt-text="Screenshot to edit custom deployment values.":::

1. Select **Review + create** and then select **Create** after you review the details.

1. Select **JSON View** to view other details for the DCE. Copy the **Resource ID** and the **logsIngestion endpoint** which you'll need in a later step.

    :::image type="content" source="media/tutorial-logs-ingestion-api/data-collection-endpoint-json.png" lightbox="media/tutorial-logs-ingestion-api/data-collection-endpoint-json.png" alt-text="Screenshot that shows the DCE resource ID.":::


## Create new table in Log Analytics workspace

A custom table must be created before you can send data to it. Consider these constraints when you create the table:

* Each column requires the `name`, `type`, and `description` properties.
* The properties `isHidden` and `isDefaultDisplay` both default to `false` if you don't specify them.
* Possible data types are `string`, `int`, `long`, `real`, `boolean`, `dateTime`, and `dynamic`. The API and portal UI accept `guid` as a column type, but GUIDs are stored and queried as `string` type. When you define the stream in your data collection rule, declare GUID columns as `string`. For more information, see [GUID columns and data type differences](logs-table-overview.md#column-data-types).
* Custom tables must use a suffix of `_CL`.

> [!NOTE]
> This tutorial uses PowerShell from Azure Cloud Shell to make REST API calls by using the Azure Monitor **Tables** API. You can use any other valid method to make these calls.
>
> Use a new `MyTable_CL` table for this tutorial. Before applying the request to an existing table, preserve its other columns and its plan and retention settings.

1. Select the **Cloud Shell** button in the Azure portal and ensure the environment is set to **PowerShell**.

    :::image type="content" source="media/tutorial-workspace-transformations-api/open-cloud-shell.png" lightbox="media/tutorial-workspace-transformations-api/open-cloud-shell.png" alt-text="Screenshot that shows opening Cloud Shell.":::

1. Run the following code in Cloud Shell to create the tutorial's `MyTable_CL` table.

    > [!NOTE]
    > The table name matches the DCR output stream and the linked application samples.

    The following Azure PowerShell example uses [Invoke-AzRestMethod](/powershell/module/az.accounts/invoke-azrestmethod) to call the [`Tables - Create Or Update`](../fundamentals/azure-monitor-rest-api-index.md#op-logs-tables) REST API operation.

    <br>
    <details>
    <summary>Create new table in Log Analytics workspace</summary>

    ```powershell
    # Set variables
    $resourceGroupName = "<ResourceGroupName>"
    $workspaceName = "<WorkspaceName>"
    $tableName = "MyTable_CL"
    $apiVersion = "<ApiVersion>"

    # Get the subscription ID from the current Azure PowerShell context
    $subscriptionId = (Get-AzContext).Subscription.Id

    # Build request URL
    $apiEndpoint = "https://management.azure.com"
    $path = "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName"
    $provider = "Microsoft.OperationalInsights/workspaces/$workspaceName"
    $queryString = "?api-version=$apiVersion"
    $url = "$apiEndpoint$path/providers/$provider/tables/$tableName$queryString"

    # Build request body
    $tableParams = @'
    {
      "properties": {
        "schema": {
          "name": "MyTable_CL",
          "columns": [
            {
              "name": "TimeGenerated",
              "type": "dateTime",
              "description": "The time at which the data was generated"
            },
            {
              "name": "Computer",
              "type": "string",
              "description": "The computer that generated the data"
            },
            {
              "name": "AdditionalContext",
              "type": "dynamic",
              "description": "Additional message properties"
            },
            {
              "name": "CounterName",
              "type": "string",
              "description": "Name of the counter"
            },
            {
              "name": "CounterValue",
              "type": "real",
              "description": "Value collected for the counter"
            }
          ]
        }
      }
    }
    '@

    # Define parameters for Invoke-AzRestMethod
    $invokeAzRestMethodParams = @{
      Uri = $url
      Method = "PUT"
      Payload = $tableParams
    }

    # Create the table
    Invoke-AzRestMethod @invokeAzRestMethodParams
    ```

    </details>

## Create data collection rule

The [DCR](../data-collection/data-collection-rule-overview.md) defines how the data will be handled once it's received. This includes:

* Schema of data that's sent to the endpoint.
* [Transformation](../data-collection/data-collection-transformations.md) that's applied to the data before it's sent to the workspace.
* Destination workspace and table for the transformed data.

> [!NOTE]
> Before you deploy either DCR template:
>
> * Create the `MyTable_CL` table in the destination workspace with the schema from the preceding section.
> * Use the same Azure region for the DCR, workspace, and DCE when applicable.
> * Choose the DCR ingestion endpoint variant, or use the DCE variant with an existing DCE and its subscription, resource group, and resource name.
> * When you reuse an existing DCR, retain the streams, destinations, data flows, identity, and other settings that it still requires.
>
> Template deployments create or update resources; they aren't partial PATCH operations. When reusing a DCR, preserve its existing streams, destinations, data flows, identity, and other required settings.

1. In the Azure portal's search box, enter **template** and then select **Deploy a custom template**.

    :::image type="content" source="media/tutorial-workspace-transformations-api/deploy-custom-template.png" lightbox="media/tutorial-workspace-transformations-api/deploy-custom-template.png" alt-text="Screenshot that shows how to deploy a custom template.":::

1. Select **Build your own template in the editor**.

    :::image type="content" source="media/tutorial-workspace-transformations-api/build-custom-template.png" lightbox="media/tutorial-workspace-transformations-api/build-custom-template.png" alt-text="Screenshot that shows how to build a template in the editor.":::

1. Choose the endpoint variant that you need. For the portal procedure, configure the template from its **ARM template** tab in the editor and then select **Save**. Alternatively, deploy its Bicep counterpart with the [Bicep deployment commands](/azure/azure-resource-manager/bicep/deploy-to-resource-group).

    :::image type="content" source="media/tutorial-workspace-transformations-api/edit-template.png" lightbox="media/tutorial-workspace-transformations-api/edit-template.png" alt-text="Screenshot that shows how to edit an ARM template.":::

    ### DCR ingestion endpoint

    > [!NOTE]
    > Notice the following details in the DCR defined in this template:
    >
    > * `streamDeclarations`: Column definitions of the incoming data.
    > * `destinations`: Destination workspace.
    > * `dataFlows`: Matches the stream with the destination workspace and specifies the transformation query and the destination table. The output of the destination query is what gets sent to the destination table.

    # [Bicep](#tab/bicep)

    The following Bicep example uses the [`Microsoft.Insights/dataCollectionRules`](/azure/templates/microsoft.insights/datacollectionrules?pivots=deployment-language-bicep) resource type.

    <br>
    <details>
    <summary>Create a DCR with a direct ingestion endpoint</summary>

    ```bicep
    @description('Specifies the name of the data collection rule to create.')
    param dataCollectionRuleName string = '<DataCollectionRuleName>'

    @description('Specifies the region for the data collection rule.')
    param azureRegion string = '<AzureRegion>'

    @description('Specifies the subscription that contains the workspace.')
    param workspaceSubscriptionId string = '<WorkspaceSubscriptionId>'

    @description('Specifies the resource group that contains the workspace.')
    param workspaceResourceGroupName string = '<WorkspaceResourceGroupName>'

    @description('Specifies the name of the existing Log Analytics workspace.')
    param workspaceName string = '<WorkspaceName>'

    var workspaceResourceId = resourceId(
      workspaceSubscriptionId,
      workspaceResourceGroupName,
      'Microsoft.OperationalInsights/workspaces',
      workspaceName
    )

    resource dataCollectionRule 'Microsoft.Insights/dataCollectionRules@<ApiVersion>' = {
      name: dataCollectionRuleName
      location: azureRegion
      kind: 'Direct'
      properties: {
        streamDeclarations: {
          'Custom-MyTable': {
            columns: [
              {
                name: 'Time'
                type: 'datetime'
              }
              {
                name: 'Computer'
                type: 'string'
              }
              {
                name: 'AdditionalContext'
                type: 'string'
              }
              {
                name: 'CounterName'
                type: 'string'
              }
              {
                name: 'CounterValue'
                type: 'real'
              }
            ]
          }
        }
        destinations: {
          logAnalytics: [
            {
              workspaceResourceId: workspaceResourceId
              name: 'myworkspace'
            }
          ]
        }
        dataFlows: [
          {
            streams: [
              'Custom-MyTable'
            ]
            destinations: [
              'myworkspace'
            ]
            transformKql: 'source | extend jsonContext = parse_json(AdditionalContext) | project TimeGenerated = Time, Computer, AdditionalContext = jsonContext, CounterName=tostring(jsonContext.CounterName), CounterValue=toreal(jsonContext.CounterValue)'
            outputStream: 'Custom-MyTable_CL'
          }
        ]
      }
    }

    output dataCollectionRuleId string = dataCollectionRule.id
    ```

    </details>

    # [ARM template](#tab/arm)

    The following ARM template example uses the [`Microsoft.Insights/dataCollectionRules`](/azure/templates/microsoft.insights/datacollectionrules?pivots=deployment-language-arm-template) resource type.

    <br>
    <details>
    <summary>Create a DCR with a direct ingestion endpoint</summary>

    ```json
    {
      "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
      "contentVersion": "1.0.0.0",
      "parameters": {
        "dataCollectionRuleName": {
          "type": "string",
          "defaultValue": "<DataCollectionRuleName>",
          "metadata": {
            "description": "Specifies the name of the data collection rule to create."
          }
        },
        "azureRegion": {
          "type": "string",
          "defaultValue": "<AzureRegion>",
          "metadata": {
            "description": "Specifies the region for the data collection rule."
          }
        },
        "workspaceSubscriptionId": {
          "type": "string",
          "defaultValue": "<WorkspaceSubscriptionId>",
          "metadata": {
            "description": "Specifies the subscription that contains the workspace."
          }
        },
        "workspaceResourceGroupName": {
          "type": "string",
          "defaultValue": "<WorkspaceResourceGroupName>",
          "metadata": {
            "description": "Specifies the resource group that contains the workspace."
          }
        },
        "workspaceName": {
          "type": "string",
          "defaultValue": "<WorkspaceName>",
          "metadata": {
            "description": "Specifies the name of the existing Log Analytics workspace."
          }
        }
      },
      "variables": {
        "workspaceResourceId": "[resourceId(parameters('workspaceSubscriptionId'), parameters('workspaceResourceGroupName'), 'Microsoft.OperationalInsights/workspaces', parameters('workspaceName'))]"
      },
      "resources": [
        {
          "type": "Microsoft.Insights/dataCollectionRules",
          "apiVersion": "<ApiVersion>",
          "name": "[parameters('dataCollectionRuleName')]",
          "location": "[parameters('azureRegion')]",
          "kind": "Direct",
          "properties": {
            "streamDeclarations": {
              "Custom-MyTable": {
                "columns": [
                  {
                    "name": "Time",
                    "type": "datetime"
                  },
                  {
                    "name": "Computer",
                    "type": "string"
                  },
                  {
                    "name": "AdditionalContext",
                    "type": "string"
                  },
                  {
                    "name": "CounterName",
                    "type": "string"
                  },
                  {
                    "name": "CounterValue",
                    "type": "real"
                  }
                ]
              }
            },
            "destinations": {
              "logAnalytics": [
                {
                  "workspaceResourceId": "[variables('workspaceResourceId')]",
                  "name": "myworkspace"
                }
              ]
            },
            "dataFlows": [
              {
                "streams": [
                  "Custom-MyTable"
                ],
                "destinations": [
                  "myworkspace"
                ],
                "transformKql": "source | extend jsonContext = parse_json(AdditionalContext) | project TimeGenerated = Time, Computer, AdditionalContext = jsonContext, CounterName=tostring(jsonContext.CounterName), CounterValue=toreal(jsonContext.CounterValue)",
                "outputStream": "Custom-MyTable_CL"
              }
            ]
          }
        }
      ],
      "outputs": {
        "dataCollectionRuleId": {
          "type": "string",
          "value": "[resourceId('Microsoft.Insights/dataCollectionRules', parameters('dataCollectionRuleName'))]"
        }
      }
    }
    ```

    </details>

    ---
    
    ### Data collection endpoint

    > [!NOTE]
    > Notice the following details in the DCR defined in this template:
    >
    > * `dataCollectionEndpointId`: Resource ID of the data collection endpoint.
    > * `streamDeclarations`: Column definitions of the incoming data.
    > * `destinations`: Destination workspace.
    > * `dataFlows`: Matches the stream with the destination workspace and specifies the transformation query and the destination table. The output of the destination query is what gets sent to the destination table.

    # [Bicep](#tab/bicep)

    The following Bicep example uses the [`Microsoft.Insights/dataCollectionRules`](/azure/templates/microsoft.insights/datacollectionrules?pivots=deployment-language-bicep) resource type.

    <br>
    <details>
    <summary>Create a DCR that uses a data collection endpoint</summary>

    ```bicep
    @description('Specifies the name of the data collection rule to create.')
    param dataCollectionRuleName string = '<DataCollectionRuleName>'

    @description('Specifies the region for the data collection rule.')
    param azureRegion string = '<AzureRegion>'

    @description('Specifies the subscription that contains the workspace.')
    param workspaceSubscriptionId string = '<WorkspaceSubscriptionId>'

    @description('Specifies the resource group that contains the workspace.')
    param workspaceResourceGroupName string = '<WorkspaceResourceGroupName>'

    @description('Specifies the name of the existing Log Analytics workspace.')
    param workspaceName string = '<WorkspaceName>'

    @description('Specifies the subscription that contains the data collection endpoint.')
    param endpointSubscriptionId string = '<EndpointSubscriptionId>'

    @description('Specifies the resource group that contains the data collection endpoint.')
    param endpointResourceGroupName string = '<EndpointResourceGroupName>'

    @description('Specifies the name of the existing data collection endpoint.')
    param dataCollectionEndpointName string = '<DataCollectionEndpointName>'

    var workspaceResourceId = resourceId(
      workspaceSubscriptionId,
      workspaceResourceGroupName,
      'Microsoft.OperationalInsights/workspaces',
      workspaceName
    )
    var endpointResourceId = resourceId(
      endpointSubscriptionId,
      endpointResourceGroupName,
      'Microsoft.Insights/dataCollectionEndpoints',
      dataCollectionEndpointName
    )

    resource dataCollectionRule 'Microsoft.Insights/dataCollectionRules@<ApiVersion>' = {
      name: dataCollectionRuleName
      location: azureRegion
      kind: 'Direct'
      properties: {
        dataCollectionEndpointId: endpointResourceId
        streamDeclarations: {
          'Custom-MyTable': {
            columns: [
              {
                name: 'Time'
                type: 'datetime'
              }
              {
                name: 'Computer'
                type: 'string'
              }
              {
                name: 'AdditionalContext'
                type: 'string'
              }
              {
                name: 'CounterName'
                type: 'string'
              }
              {
                name: 'CounterValue'
                type: 'real'
              }
            ]
          }
        }
        destinations: {
          logAnalytics: [
            {
              workspaceResourceId: workspaceResourceId
              name: 'myworkspace'
            }
          ]
        }
        dataFlows: [
          {
            streams: [
              'Custom-MyTable'
            ]
            destinations: [
              'myworkspace'
            ]
            transformKql: 'source | extend jsonContext = parse_json(AdditionalContext) | project TimeGenerated = Time, Computer, AdditionalContext = jsonContext, CounterName=tostring(jsonContext.CounterName), CounterValue=toreal(jsonContext.CounterValue)'
            outputStream: 'Custom-MyTable_CL'
          }
        ]
      }
    }

    output dataCollectionRuleId string = dataCollectionRule.id
    ```

    </details>

    # [ARM template](#tab/arm)

    The following ARM template example uses the [`Microsoft.Insights/dataCollectionRules`](/azure/templates/microsoft.insights/datacollectionrules?pivots=deployment-language-arm-template) resource type.

    <br>
    <details>
    <summary>Create a DCR that uses a data collection endpoint</summary>

    ```json
    {
      "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
      "contentVersion": "1.0.0.0",
      "parameters": {
        "dataCollectionRuleName": {
          "type": "string",
          "defaultValue": "<DataCollectionRuleName>",
          "metadata": {
            "description": "Specifies the name of the data collection rule to create."
          }
        },
        "azureRegion": {
          "type": "string",
          "defaultValue": "<AzureRegion>",
          "metadata": {
            "description": "Specifies the region for the data collection rule."
          }
        },
        "workspaceSubscriptionId": {
          "type": "string",
          "defaultValue": "<WorkspaceSubscriptionId>",
          "metadata": {
            "description": "Specifies the subscription that contains the workspace."
          }
        },
        "workspaceResourceGroupName": {
          "type": "string",
          "defaultValue": "<WorkspaceResourceGroupName>",
          "metadata": {
            "description": "Specifies the resource group that contains the workspace."
          }
        },
        "workspaceName": {
          "type": "string",
          "defaultValue": "<WorkspaceName>",
          "metadata": {
            "description": "Specifies the name of the existing Log Analytics workspace."
          }
        },
        "endpointSubscriptionId": {
          "type": "string",
          "defaultValue": "<EndpointSubscriptionId>",
          "metadata": {
            "description": "Specifies the subscription that contains the data collection endpoint."
          }
        },
        "endpointResourceGroupName": {
          "type": "string",
          "defaultValue": "<EndpointResourceGroupName>",
          "metadata": {
            "description": "Specifies the resource group that contains the data collection endpoint."
          }
        },
        "dataCollectionEndpointName": {
          "type": "string",
          "defaultValue": "<DataCollectionEndpointName>",
          "metadata": {
            "description": "Specifies the name of the existing data collection endpoint."
          }
        }
      },
      "variables": {
        "workspaceResourceId": "[resourceId(parameters('workspaceSubscriptionId'), parameters('workspaceResourceGroupName'), 'Microsoft.OperationalInsights/workspaces', parameters('workspaceName'))]",
        "endpointResourceId": "[resourceId(parameters('endpointSubscriptionId'), parameters('endpointResourceGroupName'), 'Microsoft.Insights/dataCollectionEndpoints', parameters('dataCollectionEndpointName'))]"
      },
      "resources": [
        {
          "type": "Microsoft.Insights/dataCollectionRules",
          "apiVersion": "<ApiVersion>",
          "name": "[parameters('dataCollectionRuleName')]",
          "location": "[parameters('azureRegion')]",
          "kind": "Direct",
          "properties": {
            "dataCollectionEndpointId": "[variables('endpointResourceId')]",
            "streamDeclarations": {
              "Custom-MyTable": {
                "columns": [
                  {
                    "name": "Time",
                    "type": "datetime"
                  },
                  {
                    "name": "Computer",
                    "type": "string"
                  },
                  {
                    "name": "AdditionalContext",
                    "type": "string"
                  },
                  {
                    "name": "CounterName",
                    "type": "string"
                  },
                  {
                    "name": "CounterValue",
                    "type": "real"
                  }
                ]
              }
            },
            "destinations": {
              "logAnalytics": [
                {
                  "workspaceResourceId": "[variables('workspaceResourceId')]",
                  "name": "myworkspace"
                }
              ]
            },
            "dataFlows": [
              {
                "streams": [
                  "Custom-MyTable"
                ],
                "destinations": [
                  "myworkspace"
                ],
                "transformKql": "source | extend jsonContext = parse_json(AdditionalContext) | project TimeGenerated = Time, Computer, AdditionalContext = jsonContext, CounterName=tostring(jsonContext.CounterName), CounterValue=toreal(jsonContext.CounterValue)",
                "outputStream": "Custom-MyTable_CL"
              }
            ]
          }
        }
      ],
      "outputs": {
        "dataCollectionRuleId": {
          "type": "string",
          "value": "[resourceId('Microsoft.Insights/dataCollectionRules', parameters('dataCollectionRuleName'))]"
        }
      }
    }
    ```

    </details>

    ---

1. On the **Custom deployment** screen, specify a **Subscription** and **Resource group** to store the DCR. Provide `dataCollectionRuleName`, `azureRegion`, `workspaceSubscriptionId`, `workspaceResourceGroupName`, and `workspaceName`. For the DCE variant, also provide `endpointSubscriptionId`, `endpointResourceGroupName`, and `dataCollectionEndpointName`. Set `azureRegion` to the workspace's region.

    :::image type="content" source="media/tutorial-workspace-transformations-api/custom-deployment-values.png" lightbox="media/tutorial-workspace-transformations-api/custom-deployment-values.png" alt-text="Screenshot that shows how to edit custom deployment values.":::

1. Select **Review + create** and then select **Create** after you review the details.

1. When the deployment is complete, expand the **Deployment details** box and select your DCR to view its details. Select **JSON View**.

    :::image type="content" source="media/tutorial-workspace-transformations-api/data-collection-rule-details.png" lightbox="media/tutorial-workspace-transformations-api/data-collection-rule-details.png" alt-text="Screenshot that shows DCR details.":::

1. Copy the **Immutable ID** and **Logs ingestion URI** for the DCR. You'll use these when you [send data to Azure Monitor using the API](tutorial-logs-ingestion-code.md).

    :::image type="content" source="media/tutorial-logs-ingestion-api/data-collection-rule-json-view.png" lightbox="media/tutorial-logs-ingestion-api/data-collection-rule-json-view.png" alt-text="Screenshot that shows DCR JSON view.":::

## Assign permissions to a DCR

After the DCR has been created, the application needs to be given permission to it. Permission will allow any application using the correct application ID and application key to send data to the new DCR.

1. From the DCR in the Azure portal, select **Access Control (IAM)** > **Add role assignment**.

    :::image type="content" source="media/tutorial-logs-ingestion-portal/add-role-assignment.png" lightbox="media/tutorial-logs-ingestion-portal/custom-log-create.png" alt-text="Screenshot that shows adding a custom role assignment to DCR.":::

1. Select **Monitoring Metrics Publisher** and select **Next**. You could instead create a custom action with the `Microsoft.Insights/Telemetry/Write` data action.

    :::image type="content" source="media/tutorial-logs-ingestion-portal/add-role-assignment-select-role.png" lightbox="media/tutorial-logs-ingestion-portal/add-role-assignment-select-role.png" alt-text="Screenshot that shows selecting a role for DCR role assignment.":::

1. Select **User, group, or service principal** for **Assign access to** and choose **Select members**. Select the application that you created and choose **Select**.

    :::image type="content" source="media/tutorial-logs-ingestion-portal/add-role-assignment-select-member.png" lightbox="media/tutorial-logs-ingestion-portal/add-role-assignment-select-member.png" alt-text="Screenshot that shows selecting members for the DCR role assignment.":::

1. Select **Review + assign** and verify the details before you save your role assignment.

    :::image type="content" source="media/tutorial-logs-ingestion-portal/add-role-assignment-save.png" lightbox="media/tutorial-logs-ingestion-portal/add-role-assignment-save.png" alt-text="Screenshot that shows saving the DCR role assignment.":::

## Sample code

See [Sample code to send data to Azure Monitor using Logs ingestion API](tutorial-logs-ingestion-code.md) for sample code using the components created in this tutorial.

## Next steps

* [Complete a similar tutorial using the Azure portal](tutorial-logs-ingestion-portal.md)
* [Read more about custom logs](logs-ingestion-api-overview.md)
* [Learn more about writing transformation queries](../data-collection/data-collection-transformations.md)
