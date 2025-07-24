---
title: Impacted Resources from Outages
description: This article details where to find information from Azure Service Health about how Azure outages might affect your resources.
ms.topic: concept-article
ms.date: 07/11/2025
---

# Impacted Resources from Outages

[Azure Service Health](https://azure.microsoft.com/get-started/azure-portal/service-health/) helps customers monitor any health events that affect their subscriptions and tenants. In the Azure portal, the **Service Issues** pane within **Service Health** displays any ongoing problems in Azure services that are affecting your resources. <br>You can see when each issue began and which services and regions are impacted. 

This article explains what Service Health communicates and where to find information about your impacted resources.

### View impacted resources

In the Azure portal, the **Impacted Resources** tab under **Service Health** > **Service Issues** displays resources that are or might be impacted by an outage. Service Health provides this information to users when an outage impacts their resources:

|Column  |Description |
|---------|---------|
|**Resource Name**|Name of the resource. The name is a clickable link that goes to the Resource Health page to show the resource. If no Resource Health signal is available for the resource, this name is text only.|
|**Resource Health**|Health status of the resource: <br><br>**Available**: Your resource is healthy, but a service event might impact it at a some point in time. <br>**Degraded** or **Unavailable**: A customer-initiated action or a platform-initiated action might cause this status. It means your resource was impacted but might now be healthy, pending a status update. <br>**Unknown**:  This status means that the system doesn't any health information from the resource for more than 10 minutes. However, it isn't necessarily an indication of a problem with the resource itself, as it often reflects a lack of telemetry or communication from the resource provider. <br>:::image type="content" source="./media/impacted-resource-outage/rh-cropped.PNG" alt-text="Screenshot of health statuses for a resource.":::|
|**Impact Type**|Indication of whether the resource is or might be impacted: <br><br>**Confirmed**: The resource is impacted from an outage. Check the **Summary** section for any action items that you can take to remediate the problem. <br><br>**Potential**: The resource isn't impacted, but it could potentially be affected because it's under a service or region experiencing an outage. Check the **Resource Health** column to make sure that everything is working as planned.|
|**Resource Type**|Type of impacted resource (for example, virtual machine).|
|**Resource Group**|Resource group that contains the impacted resource.|
|**Location**|Location that contains the impacted resource.|
|**Subscription ID**|Unique ID for the subscription that contains the impacted resource.|
|**Subscription Name**|Subscription name for the subscription that contains the impacted resource.|

The following is an example of outage **Impacted Resources** from the subscription and tenant scope.

:::image type="content"source="./media/impacted-resource-outage/ir-portal-crop.png"alt-text="Screenshot of information about subscription impacted resources in Azure Service Health."Lightbox="./media/impacted-resource-outage/ir-portal-crop.png":::

>[!Note]
>Not all resources in subscription scope will show a Resource Health status. The status appears only on resources for which a Resource Health signal is available. The status of resources for which a Resource Health signal is not available appears as **N/A**, and the corresponding **Resource Name** value is text instead of a clickable link.

:::image type="content"source="./media/impacted-resource-outage/ir-tenant.png"alt-text="Screenshot of information about tenant impacted resources in Azure Service Health."Lightbox="./media/impacted-resource-outage/ir-tenant.png":::

>[!Note]
>Resource Health status, tenant name, and tenant ID are not included at the tenant level scope. The corresponding **Resource Name** value is text only instead of a clickable link.

### Filter results

You can adjust the results using these filters:

- **Impact type**: Select **Confirmed** or **Potential**.
- **Subscription ID**: Show all subscription IDs that the user can access.
- **Status**: Focus on Resource Health status by selecting **Available**, **Unavailable**, **Degraded**, **Unknown**, or **N/A**.

### Export to CSV

To export the list of impacted resources to an Excel file, select the **Export to CSV** option.

### Access impacted resources programmatically via an API

You can get information about outage-impacted resources programmatically by using the Events API. For details on how to access this data, see [API documentation](/rest/api/resourcehealth/2022-10-01/impacted-resources).

### Frequently Asked Questions

|Question|Answer|
|--------|------|
|Are the Impacted resources only available for 'Active' service health events?|Yes, the Azure portal shows Impacted resources only for Active events in Service Issues.|
|Is there a retention period for impacted resources? |The retention period is 90 days in Azure Resource Graph.|




### Next steps
- [Introduction to the Azure Service Health dashboard](service-health-overview.md)
- [Introduction to Azure Resource Health](resource-health-overview.md)
- [Resource Health Frequently asked questions](resource-health-faq.yml)
