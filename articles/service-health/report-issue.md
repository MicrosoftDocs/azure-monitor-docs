---
title: Report an issue in Azure Service Health 
description: Learn how to access and report an issue in Azure Service Health.
ms.topic: overview
ms.date: 09/08/2025
---

# How to report an issue in Azure Service Health (Preview)

Even if there are no active issues shown in the Service Health portal, you can now report a service-level or resource-level impact. This tool allows you to notify Microsoft about an issue even when it isn't identified as part of a broader outage.<br>

When you submit an issue, our team reviews the submitted report, and if an outage is identified you see it on the Azure Service Health portal. For more information, see [Azure Impact Reporting](/azure/azure-impact-reporting).

## Access permission

You don’t  need to be a subscription owner or an administrator to report service-level issues.<br>
To generate resource-level impact reports, ensure the following prerequisites are met:

- **Register the Microsoft.Impact resource provider** in your Azure subscription.
- **Role assignment**: If you're not a subscription administrator, the Impact Reporter role must be assigned to you on the subscription where the resource is located.


To report a single issue, you must have the correct permission.

>[!NOTE]
>This option to report an issue isn't available on the Billing panel.

## How to report a resource-level issue



To report an issue, follow these steps.
1. Select **Report an Issue**.

:::image type="content" source="media/report-issue/report-an-issue-main.png" alt-text="Screenshot of the screen to report an issue." lightbox="media/report-issue/report-an-issue-main.png":::

2. Select **Single resource**.

:::image type="content" source="media/report-issue/report-an-issue-submit.png" alt-text="Screenshot of the screen to select single resource." lightbox="media/report-issue/report-an-issue-submit.png":::

3. Fill out the required fields.
    - Subscription
    - Impacted resource
    - What is the business impact?
    - Impact start date and time.

>[!NOTE]
> For resource-level impacts the start time must be within the last 10 days.

4. Select **Submit**.

When your issue is reported, you should see this message. 
:::image type="content" source="media/report-issue/report-an-issue-success.png" alt-text="Screenshot of the message your report on a resource issue is a success." lightbox="media/report-issue/report-an-issue-success.png":::

If an outage is found, you will see it on the portal.

If you get this error, it means you don’t have permission.

:::image type="content" source="media/report-issue/report-an-issue-error.png" alt-text="Screenshot of the message you don't have access." lightbox="media/report-issue/report-an-issue-error.png":::

## How to report service-level issues

The steps to report an issue about Multiple resources is the same a reporting a single resource issue. The difference is that you don’t need the same permission.

1. Select **Multiple resources / entire service**.

:::image type="content" source="media/report-issue/report-an-issue-multiple.png" alt-text="Screenshot of screen to report several issues." lightbox="media/report-issue/report-an-issue-multiple.png":::

2. Fill out the required fields.
1. Select **Submit**.

When your issue is reported, you should see this message. 
:::image type="content" source="media/report-issue/report-an-issue-success-service-level.png" alt-text="Screenshot of the message your service issue report is a success." lightbox="media/report-issue/report-an-issue-success-service-level.png":::

## What to expect after you submit an issue
We review your report, and if an outage is confirmed, it appears on the Service Issues page in Azure Service Health.

For more information about reporting, see [Azure Impact reporting](/azure/azure-impact-reporting/view-impact-insights).

## For more information

-  [Resource types and health checks in Azure Resource Health](resource-health-checks-resource-types.md)
-  [Resource Health frequently asked questions](resource-health-faq.yml)
-  [Azure service health notifications](service-health-notifications-properties.md)
-  [Service Health frequently asked questions](service-health-faq.yml)
-  [Configure Alerts for Service Health](./alerts-activity-log-service-notifications-portal.md) 
