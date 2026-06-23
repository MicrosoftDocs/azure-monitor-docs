---
title: Application Insights Geolocation and IP Address Handling
description: Understand how Application Insights handles IP addresses and geolocation.
ms.topic: how-to
ms.date: 03/15/2026
ai-usage: ai-assisted
---

# Application Insights geolocation and IP address handling

This article explains how geolocation lookup and IP address handling work in [Application Insights](app-insights-overview.md).

## Default behavior

By default, IP addresses are temporarily collected but not stored.

When telemetry is sent to Azure, the IP address is used in a geolocation lookup. The result is used to populate the fields `client_City`, `client_StateOrProvince`, and `client_CountryOrRegion`. The address is then discarded, and `0.0.0.0` is written to the `client_IP` field.

The telemetry types are:

* **Browser telemetry**: Application Insights collects the sender's IP address. The ingestion endpoint calculates the IP address.
* **Server telemetry**: The Application Insights telemetry module temporarily collects the client IP address when the `X-Forwarded-For` header isn't set. When the incoming IP address list has more than one item, the last IP address is used to populate geolocation fields.

This behavior is by design to help avoid unnecessary collection of personal data and IP address location information.

When IP addresses aren't collected, city and other geolocation attributes also aren't collected.

## Storage of IP address data

> [!WARNING]
> The default and our recommendation are to not collect IP addresses. If you override this behavior, verify the collection doesn't break any compliance requirements or local regulations.
>
> To learn more about handling personal data, see [Guidance for personal data](../logs/personal-data-mgmt.md).

> [!NOTE]
> The IP addresses associated with telemetry ingested before enabling the `DisableIpMasking` property continue to be displayed as `0.0.0.0`. Only telemetry ingested after this change reflects the actual IP address information.

To enable IP collection and storage, the `DisableIpMasking` property of the Application Insights component must be set to `true`.

If you use OpenTelemetry, you can also populate the request IP used for geolocation by setting the `client.address` span attribute. The stored `client_IP` value still follows the masking behavior described in this article unless `DisableIpMasking` is enabled. For more information, see [Set the user IP](opentelemetry-add-modify.md#set-the-user-ip).

For broader control over sensitive telemetry, such as generative AI prompts and responses, set the relevant tables as protected. Protected tables block standard and custom read roles by default until you grant explicit access. For more information, see [Configure protected tables in Azure Monitor Logs](../logs/protected-tables-configure.md).

## Disable IP masking

> [!TIP]
> If you need to modify the behavior for only a single Application Insights resource, use the Azure portal.

# [Portal](#tab/portal)

1. Go to your Application Insights resource, and then select **Automation** > **Export template**.

1. Select **Deploy**.

    :::image type="content" source="media/ip-collection/deploy.png" lightbox="media/ip-collection/deploy.png" alt-text="Screenshot that shows the Deploy button.":::

1. Select **Edit template**.

    :::image type="content" source="media/ip-collection/edit-template.png" lightbox="media/ip-collection/edit-template.png" alt-text="Screenshot that shows the Edit button, along with a warning about the resource group.":::

    > [!NOTE]
    > If you experience the error shown in the preceding screenshot, you can resolve it. It states: "The resource group is in a location that isn't supported by one or more resources in the template. Please choose a different resource group." Temporarily select a different resource group from the dropdown list and then reselect your original resource group.

1. In the JSON template, locate `properties` inside `resources`. Add a comma to the last JSON field, and then add the following new line: `"DisableIpMasking": true`. Then select **Save**.

    :::image type="content" source="media/ip-collection/save.png" lightbox="media/ip-collection/save.png" alt-text="Screenshot that shows the addition of a comma and a new line after the property for request source.":::

1. Select **Review + create** > **Create**.

    > [!NOTE]
    > If you see "Your deployment failed," look through your deployment details for the one with the type `microsoft.insights/components` and check the status. If that one succeeds, the changes made to `DisableIpMasking` were deployed.

1. After the deployment is complete, new telemetry data will be recorded.

    If you select and edit the template again, only the default template without the newly added property is shown. If you aren't seeing IP address data and want to confirm that `"DisableIpMasking": true` is set, run the following PowerShell commands:

    ```powershell
    # Set variables
    $resourceGroupName = "<ResourceGroupName>"
    $resourceName = "<ResourceName>"

    # Define parameters for Get-AzResource
    $getAzResourceParams = @{
        Name              = $resourceName
        ResourceType      = "Microsoft.Insights/components"
        ResourceGroupName = $resourceGroupName
    }

    # Retrieve the Application Insights resource and display its properties
    $appInsights = Get-AzResource @getAzResourceParams
    $appInsights.Properties
    ```

    A list of properties is returned as a result. One of the properties should read `DisableIpMasking: true`. If you run the PowerShell commands before you deploy the new property with Azure Resource Manager, the property doesn't exist.

# [Azure CLI](#tab/cli)

[!INCLUDE [Azure CLI using REST](../includes/cli-using-rest.md)]

```bash
# Set variables
resourceGroupName="<ResourceGroupName>"
resourceName="<ResourceName>"
apiVersion="2020-02-02"

# Get the subscription ID from the current Azure CLI context
subscriptionId=$(az account show --query id --output tsv)

# Build the full resource ID for the Application Insights component
resourceId="/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.Insights/components/$resourceName"

# Disable IP masking on the Application Insights resource
az rest \
  --method put \
  --uri "$resourceId?api-version=$apiVersion" \
  --body @./components.json
```

**Payload file components.json:**

```json
{
  "location": "<AzureRegion>",
  "kind": "web",
  "properties": {
    "Application_Type": "web",
    "DisableIpMasking": true,
    "WorkspaceResourceId": "/subscriptions/<SubscriptionId>/resourceGroups/<ResourceGroupName>/providers/Microsoft.OperationalInsights/workspaces/<WorkspaceName>"
  }
}
```

# [Azure PowerShell](#tab/powershell)

The following Azure PowerShell example uses the [Update-AzApplicationInsights](/powershell/module/az.applicationinsights/update-azapplicationinsights) cmdlet.

```powershell
# Set variables
$resourceGroupName = "<ResourceGroupName>"
$resourceName = "<ResourceName>"

# Define parameters for Update-AzApplicationInsights
$updateAzApplicationInsightsParams = @{
    ResourceGroupName = $resourceGroupName
    Name              = $resourceName
    DisableIPMasking  = $true
}

# Disable IP masking on the Application Insights resource
Update-AzApplicationInsights @updateAzApplicationInsightsParams
```

[!INCLUDE [Azure PowerShell default endpoint](../includes/powershell-default-endpoint.md)]

# [REST](#tab/rest)

The following REST example uses the [Components - Create Or Update](/rest/api/application-insights/components/create-or-update) REST API operation.

```REST
PUT https://management.azure.com/subscriptions/{SubscriptionId}/resourceGroups/{ResourceGroupName}/providers/Microsoft.Insights/components/{ResourceName}?api-version=2020-02-02
Authorization: Bearer {AccessToken}
Content-Type: application/json

{
  "location": "<AzureRegion>",
  "kind": "web",
  "properties": {
    "Application_Type": "web",
    "DisableIpMasking": true,
    "WorkspaceResourceId": "/subscriptions/<SubscriptionId>/resourceGroups/<ResourceGroupName>/providers/Microsoft.OperationalInsights/workspaces/<WorkspaceName>"
  }
}
```

# [Bicep](#tab/bicep)

The following Bicep example uses the [Microsoft.Insights/components](/azure/templates/microsoft.insights/components?pivots=deployment-language-bicep) resource type.

```bicep
param subscriptionId string = '<SubscriptionId>'
param resourceGroupName string = '<ResourceGroupName>'
param resourceName string = '<ResourceName>'
param azureRegion string = '<AzureRegion>'
param workspaceName string = '<WorkspaceName>'

var workspaceResourceId = '/subscriptions/${subscriptionId}/resourceGroups/${resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/${workspaceName}'

resource applicationInsightsComponent 'Microsoft.Insights/components@2020-02-02' = {
  name: resourceName
  location: azureRegion
  kind: 'web'
  properties: {
    Application_Type: 'web'
    DisableIpMasking: true
    WorkspaceResourceId: workspaceResourceId
  }
}
```

# [ARM (JSON)](#tab/arm)

The following ARM (JSON) example uses the [Microsoft.Insights/components](/azure/templates/microsoft.insights/components?pivots=deployment-language-arm-template) resource type.

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "subscriptionId": {
      "type": "string",
      "defaultValue": "<SubscriptionId>"
    },
    "resourceGroupName": {
      "type": "string",
      "defaultValue": "<ResourceGroupName>"
    },
    "resourceName": {
      "type": "string",
      "defaultValue": "<ResourceName>"
    },
    "azureRegion": {
      "type": "string",
      "defaultValue": "<AzureRegion>"
    },
    "workspaceName": {
      "type": "string",
      "defaultValue": "<WorkspaceName>"
    }
  },
  "variables": {
    "workspaceResourceId": "[format('/subscriptions/{0}/resourceGroups/{1}/providers/Microsoft.OperationalInsights/workspaces/{2}', parameters('subscriptionId'), parameters('resourceGroupName'), parameters('workspaceName'))]"
  },
  "resources": [
    {
      "type": "Microsoft.Insights/components",
      "apiVersion": "2020-02-02",
      "name": "[parameters('resourceName')]",
      "location": "[parameters('azureRegion')]",
      "kind": "web",
      "properties": {
        "Application_Type": "web",
        "DisableIpMasking": true,
        "WorkspaceResourceId": "[variables('workspaceResourceId')]"
      }
    }
  ]
}
```

---
<!--
| Variable | Placeholder | Purpose |
|----------|-------------|---------|
| subscriptionId | \<SubscriptionId\> | • Retrieved (CLI)<br>• User input (REST, Bicep & ARM) |
| resourceGroupName | \<ResourceGroupName\> | User input |
| resourceName | \<ResourceName\> | User input |
| azureRegion | \<AzureRegion\> | User input |
| workspaceName | \<WorkspaceName\> | User input |
| apiVersion | 2020-02-02 | [Reference](../fundamentals/azure-monitor-rest-api-index.md) |
-->
## Next steps

* Learn more about [personal data collection](../logs/personal-data-mgmt.md) in Azure Monitor.
* Learn how to [set the user IP](opentelemetry-add-modify.md#set-the-user-ip) using OpenTelemetry.
