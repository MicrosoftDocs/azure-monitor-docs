---
title: Application Insights IP address collection | Microsoft Docs
description: Understand how Application Insights handles IP addresses and geolocation.
ms.topic: how-to
ms.date: 03/05/2025
ms.reviewer: mmcc
---

# Geolocation and IP address handling

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
> The IP addresses associated with telemetry ingested before enabling the `DisableIpMasking` property continues to be displayed as `0.0.0.0`. Only telemetry ingested after this change reflects the actual IP address information.

To enable IP collection and storage, the `DisableIpMasking` property of the Application Insights component must be set to `true`.

## Disable IP masking

> [!TIP]
> If you need to modify the behavior for only a single Application Insights resource, use the Azure portal.

### [Portal](#tab/portal)

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

    If you select and edit the template again, only the default template without the newly added property. If you aren't seeing IP address data and want to confirm that `"DisableIpMasking": true` is set, run the following PowerShell commands:
    
    ```powershell
    # Replace <application-insights-resource-name> and <resource-group-name> with the appropriate resource and resource group name.

    # If you aren't using Azure Cloud Shell, you need to connect to your Azure account
    # Connect-AzAccount

    $AppInsights = Get-AzResource -Name '<application-insights-resource-name>' -ResourceType 'microsoft.insights/components' -ResourceGroupName '<resource-group-name>'
    $AppInsights.Properties
    ```
    
    A list of properties is returned as a result. One of the properties should read `DisableIpMasking: true`. If you run the PowerShell commands before you deploy the new property with Azure Resource Manager, the property doesn't exist.

### [Azure CLI](#tab/cli)

> [!NOTE]
> Currently, Azure doesn't provide a way to disable IP masking for Application Insights via the Azure CLI. To disable IP masking programmatically, use Azure PowerShell.

### [PowerShell](#tab/powershell)

To disable IP masking using [Azure PowerShell](/powershell/azure/what-is-azure-powershell), use the following command and replace the placeholders `<application-insights-resource-name>` and `<resource-group-name>` with your specific values:

```powershell
Update-AzApplicationInsights -Name "<application-insights-resource-name>" -ResourceGroupName "<resource-group-name>" -DisableIPMasking:$true
```

For more information about the `Update-AzApplicationInsights` cmdlet, see the [Azure PowerShell documentation](/powershell/module/az.applicationinsights/update-azapplicationinsights).

### [REST API](#tab/rest)

To disable IP masking using the [REST API](/rest/api/azure/), use the following request and replace the placeholders `<subscription-id>`, `<resource-group-name>`, `<application-insights-resource-name>`, `<access-token>`, and `<azure-region-name>` with your specific values:

```json
PATCH https://management.azure.com/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/microsoft.insights/components/<application-insights-resource-name>?api-version=2018-05-01-preview HTTP/1.1
Host: management.azure.com
Authorization: Bearer <access-token>
Content-Type: application/json

{
    "location": "<azure-region-name>",
    "kind": "web",
    "properties": {
        "Application_Type": "web",
        "DisableIpMasking": true
    }
}
```

For more information about configuring Application Insights resources using the REST API, see the [REST API documentation](/rest/api/application-insights/components/create-or-update).

### [Bicep](#tab/bicep)

To disable IP masking using [Bicep](/azure/azure-resource-manager/bicep/overview), use the following template and replace the placeholders `<application-insights-resource-name>` and `<azure-region-name>` with your specific values:

```bicep
resource appInsights 'microsoft.insights/components@2020-02-02' = {
    name: '<application-insights-resource-name>'
    location: '<azure-region-name>'

    kind: 'web'
    properties: {
        Application_Type: 'web'
        DisableIpMasking: true
    }
}
```

### [ARM (JSON)](#tab/arm)

To disable IP masking using [ARM (JSON)](/azure/azure-resource-manager/templates/overview), use the following template and replace the placeholders `<subscription-id>`, `<resource-group-name>`, `<application-insights-resource-name>`, and `<azure-region-name>` with your specific values:

```json
{
    "id": "/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/microsoft.insights/components/<application-insights-resource-name>",
    "name": "<application-insights-resource-name>",
    "type": "microsoft.insights/components",
    "location": "<azure-region-name>",

    "kind": "web",
    "properties": {
        "Application_Type": "web",
        "DisableIpMasking": true
    }
}
```

---

## Next steps

* Learn more about [personal data collection](../logs/personal-data-mgmt.md) in Azure Monitor.
* Learn how to [set the user IP](opentelemetry-add-modify.md#set-the-user-ip) using OpenTelemetry.
