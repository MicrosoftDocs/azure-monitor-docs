---
title: Report an impact in Azure Service Health 
description: Learn how to access and report an impact in Azure Service Health.
ms.topic: overview
ms.date: 04/23/2026
---

# How to report an impact in Azure Service Health (Preview)

Even if there are no active issues shown in the Service Health portal, you can now report a service-level or resource-level impact. This tool allows you to notify Microsoft about an impact even when it isn't identified as part of a broader outage.<br>

When you submit an impact, if an outage is identified you see it on the Azure Service Health portal. For more information, see [Azure Impact Reporting](/azure/azure-impact-reporting).

## Access permission



To generate impact reports, ensure the following prerequisites are met:

- **Register the Microsoft.Impact resource provider** in your Azure subscription.
- **Role assignment**: If you're not a subscription administrator, the Impact Reporter role must be assigned to you on the subscription where the resource is located.


To report a single impact, you must have the correct permission.

>[!NOTE]
>This option to report an impact isn't available on the Billing panel.

## How to report a resource-level impact

Both service-level and resource-level reports have the same requirements:
- The start time is within the last 10 days. 
- You need to have admin access or an Impact reporter role on the subscription.

To report an impact, follow these steps.
1. Select **Report an impact**.

:::image type="content" source="media/report-issue/report-an-impact-main.png" alt-text="Screenshot of the screen to report an impact." lightbox="media/report-issue/report-an-impact-main.png":::

2. Select **Single resource**.

*Choose this option if the problem seems to be isolated to one resource*.

:::image type="content" source="media/report-issue/report-an-impact-specific.png" alt-text="Screenshot of the screen to select single resource." lightbox="media/report-issue/report-an-impact-specific.png":::

The *Start* time requirement is the same for both service and resource impacts.

>[!TIP]
>The Impact *start* time and *end* time fields use your local timezone, not UTC.

3. Fill out the required fields.
    - Subscription
    - Impacted resource
    - What is the business impact?
    - Impact start date and time.

>[!NOTE]
> The start time must be within the last 10 days.

4. Select **Submit**.

When your impact is reported, you should see this message. 
:::image type="content" source="media/report-issue/report-an-issue-success-resource.png" alt-text="Screenshot of the message your report on a resource impact is a success." lightbox="media/report-issue/report-an-issue-success-resource.png":::

If an outage is found, you see it on the portal.

If you get this error, it means you don’t have permission.

:::image type="content" source="media/report-issue/report-an-issue-error.png" alt-text="Screenshot of the message you don't have access." lightbox="media/report-issue/report-an-issue-error.png":::

## How to report service impacts


1. Select **Multiple resources / entire service**.

*Choose this option if several resources or your overall app experience is affected and you believe Azure could be the cause.*

:::image type="content" source="media/report-issue/report-an-impact-multiple.png" alt-text="Screenshot of screen to report several impacts." lightbox="media/report-issue/report-an-impact-multiple.png":::

2. Fill out the required fields.
1. Select **Submit**.

When your issue is reported, you should see this message. 
:::image type="content" source="media/report-issue/report-an-issue-success-service-level.png" alt-text="Screenshot of the message your service impact report is a success." lightbox="media/report-issue/report-an-issue-success-service-level.png":::

The *Submit* state is the same for both service and resource impacts.

## What to expect after you submit an impact
We review your report, and if an outage is confirmed, it appears on the Service Issues page in Azure Service Health.

For more information about reporting, see [Azure Impact reporting](/azure/azure-impact-reporting/view-impact-insights).

## How to view the reported service impacts

You can see a list of all your reported impacts on the following panel.


:::image type="content" source="media/report-issue/report-impact-main.png" alt-text="Screenshot of the list of service impacts that you report." lightbox="media/report-issue/report-impact-main.png":::


You also have the option to see the details of what was impacted in a report.

:::image type="content" source="media/report-issue/report-impact-detail.png" alt-text="Screenshot of the details of the service impact you reported." lightbox="media/report-issue/report-impact-detail.png":::

- This page shows all reports on subscriptions where you have the necessary access. This means you can see reports from other people submitted on their subscriptions.
- This page also shows reports made programmatically via the Create Workload Impacts API. For more information, see [Workload Impacts-Create-REST API](/rest/api/impact/workload-impacts/create?view=rest-impact-2025-01-01-preview&tabs=HTTP).

>[!NOTE]
> Reports created in April 2026 or earlier might not appear on this page, but those reports were still processed successfully. Because of updates to the **Report an Impact form preview**, some older details can’t be shown here.



## For more information

-  [Resource types and health checks in Azure Resource Health](resource-health-checks-resource-types.md)
-  [Resource Health frequently asked questions](resource-health-faq.yml)
-  [Azure service health notifications](service-health-notifications-properties.md)
-  [Service Health frequently asked questions](service-health-faq.yml)
-  [Configure Alerts for Service Health](./alerts-activity-log-service-notifications-portal.md) 
