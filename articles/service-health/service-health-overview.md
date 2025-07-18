---
title: Azure Service Health Portal Classic Experience Overview
description: Learn how to use the customizable dashboard in the Service Health portal to track the health of your Azure services in the regions where you use them. 
ms.topic: how-to
ms.date: 07/18/2025


---
# Service Health portal classic experience overview

The [Service Health portal](https://portal.azure.com/#view/Microsoft_Azure_Health/AzureHealthBrowseBlade/~/serviceIssues) is part of the [Service Health service](overview.md). The portal provides you with a customizable dashboard that tracks the health of your Azure services in the regions where you use them. In this dashboard, you can track active events like ongoing service issues, upcoming planned maintenance, or relevant health advisories. You can use the Service Health dashboard to create and manage Service Health alerts, which proactively notify you when service issues are affecting you.

>[!Note]
>This article describes the older "classic" portal experience, which will be removed later this year. We recommend using the new [Service Health](service-health-portal-update.md) portal instead. 
>For more information, see [Azure Service Health](https://aka.ms/azureservicehealth).

## Service Health events

The [Service Health portal](https://portal.azure.com/#view/Microsoft_Azure_Health/AzureHealthBrowseBlade/~/serviceIssues) tracks four types of health events that might affect your resources:

- **Service issues**: Problems with the Azure services that affect you right now.
- **Planned maintenance**: Upcoming maintenance that can affect the availability of your services in the future.  
- **Health advisories**: Changes in Azure services that require your attention. Examples include deprecation of Azure features or upgrade requirements (like needing to upgrade to a supported PHP framework).
- **Security advisories**: Security-related notifications or violations that might affect the availability of your Azure services.

When events become inactive, they get placed in your health history for up to 90 days.

> [!NOTE]
> To view Service Health events, users must be [granted the Reader role](/azure/role-based-access-control/role-assignments-portal) on a subscription.

## Get started with the Service Health portal

To open your Service Health dashboard, select **Service Health** under **Azure services** in the Azure portal. If you're using a custom dashboard, select **More services** and search for Service Health.

:::image type="content" source="./media/service-health-overview/azure-service-health-overview-1a.png" alt-text="Screenshot that shows how to select Service Health and More services in the Azure portal." lightbox="media/service-health-overview/azure-service-health-overview-1a.png":::

## See current issues that are affecting your services

Select **Service issues** on the left menu to see ongoing problems in Azure services that are affecting your resources. You learn when the issue began, and what services and regions are affected. You can also read the most recent update to understand what Azure is doing to resolve the issue.

:::image type="content" source="./media/service-health-overview/azure-service-health-overview-2.png" alt-text="Screenshot that shows the Service issues pane." lightbox="media/service-health-overview/azure-service-health-overview-2.png":::

From the **Service issues** pane, select the **Potential impact** tab to see a list of the specific resources you own that might be affected by the issue. You can download a CSV file of these resources to share with your team.

:::image type="content" source="./media/service-health-overview/azure-service-health-overview-4.png" alt-text="Screenshot that shows the Potential impact tab." lightbox="media/service-health-overview/azure-service-health-overview-4.png":::

## See emerging issues that might affect your services

In certain situations, widespread service issues might be posted to the [Azure status page](https://azure.status.microsoft) before targeted communications can be sent to affected customers. To ensure that Azure Service Health provides a comprehensive view of issues that might affect you, active Azure status page issues appear in Service Health as *emerging issues*. When an event is active on the Azure status page, an **Emerging issues** banner is present in Service Health. Select the banner to see the full details of the issue.

:::image type="content" source="./media/service-health-overview/azure-service-health-emerging-issue.png" alt-text="Screenshot that shows the Emerging issues banner." lightbox="media/service-health-overview/azure-service-health-emerging-issue.png":::

## Get links and explanations that you can download

You can get a link for the issue to use in your problem management system. You can download PDF (and sometimes CSV) files to share with people who don't have access to the Azure portal.

:::image type="content" source="./media/service-health-overview/azure-service-health-overview-3.png" alt-text="Screenshot that shows how to download files." lightbox="media/service-health-overview/azure-service-health-overview-3.png":::

## Get support from Microsoft

Contact support if your resource remains in an unhealthy or unusable state even after the issue is marked as resolved. Use the support links on the right of the page.  

## Pin a personalized health map to your dashboard

You can use filters in Service Health to show your business-critical subscriptions, regions, and resource types. You can save a filter and pin a personalized health world map to your portal dashboard.

:::image type="content" source="./media/service-health-overview/azure-service-health-overview-6a.png" alt-text="Screenshot that shows how to pin a personalized health map." lightbox="media/service-health-overview/azure-service-health-overview-6a.png":::

## Configure Service Health alerts

When your business-critical resources are affected, Service Health integrates with Azure Monitor to alert you via emails, text messages, and webhook notifications. Set up an activity log alert for the appropriate Service Health event. You can route that alert to the appropriate people in your organization by using action groups. For more information, see [Configure alerts for Service Health](./alerts-activity-log-service-notifications-portal.md).

>[!VIDEO https://learn-video.azurefd.net/vod/player?id=fd3fa0ee-3cc4-4c58-9bb5-e7aef5009b34]

## Related content

Set up alerts so you're notified of health issues. 
Learn about [best practices for setting up Azure Service Health alerts](https://learn-video.azurefd.net/vod/player?id=771688cf-0348-44c4-ba48-f36bcd0aba3f).
