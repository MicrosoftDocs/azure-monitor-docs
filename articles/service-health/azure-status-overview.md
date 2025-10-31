---
title: Azure Status Overview
description: Learn how to use the Azure status page to get a global view into the health of Azure services.
ms.topic: overview
ms.date: 10/31/2025

---
# Azure status overview

The [Azure status](https://azure.status.microsoft/) page provides you with a global view of the health of Azure services and regions, along with service availability.

Anyone can visit the **Azure status** page and view incidents related to all services that report service health and incidents with wide-ranging impact. However, we strongly encourage current Azure users to use the personalized experience in [Azure Service Health](https://aka.ms/azureservicehealth) as it includes all the outages, upcoming planned maintenance activities, and service advisories.

:::image type="content"source="./media/azure-status-overview/azure-status.png"alt-text="Screenshot of the top-level Azure status page."Lightbox="./media/azure-status-overview/azure-status.png":::

## Azure status updates

The **Azure status** page is updated in real time as the health of Azure services changes. If you leave the **Azure status** page open, you can control the rate at which the page refreshes with new data. At the top of the page you can see the last time the page was updated.

:::image type="content"source="./media/azure-status-overview/update.png"alt-text="Screenshot of the Azure status refresh page."Lightbox="./media/azure-status-overview/update.png":::

## Azure status banner

The status banner on the **Azure status** page highlights active incidents that affect Azure services.

:::image type="content"source="./media/azure-status-overview/banner.png"alt-text="Screenshot of an Azure status banner example."Lightbox="./media/azure-status-overview/banner.png":::

## Current Impact tab

The **Current Impact** tab displays active events that affect the entirety of Azure. Use [Service Health](service-health-overview.md) to view other issues that might be affecting your services.  

:::image type="content"source="./media/azure-status-overview/current-impact.png"alt-text="Screenshot of the Azure status Current Impact tab."Lightbox="./media/azure-status-overview/current-impact.png":::

## Azure status history

Although the **Azure status** page shows the latest health information, you can view older events on the **Azure status history** pane. The **Azure status history** page is used to provide Post Incident Reviews (PIRs) for Scenario 1 events.

:::image type="content"source="./media/azure-status-overview/status-history.png"alt-text="Screenshot of the Azure status history page."Lightbox="./media/azure-status-overview/status-history.png":::

> [!NOTE]
> Post Incident Review (PIR) was previously called Root Cause Analysis (RCA).

## RSS feed

You can also subscribe to the Azure status [RSS feed](https://azure.status.microsoft/status/feed/) to view changes to the health of Azure services.

## Publishing communications to the Azure status page

We send most of our service issue communications as targeted notifications to affected customers and partners. These communications are delivered through [Service Health](https://azure.microsoft.com/features/service-health/) in the Azure portal and trigger any configured [Service Health alerts](./alerts-activity-log-service-notifications-portal.md?toc=%2fazure%2fservice-health%2ftoc.json).

The public **Azure status** page is used only to communicate about service issues that fall under the following three scenarios:

* **Scenario 1** <br>A service issue has broad/significant customer impact across multiple services that affect a full region or multiple regions. In Scenario 1 events, we notify you because customer-configured resilience like high availability/disaster recovery might not be sufficient to avoid impact.
* **Scenario 2** <br>A service issue impedes you from accessing the Azure portal or Service Health, and we're unable to contact you via our standard outage communications path.
* **Scenario 3** <br>A service issue has broad/significant customer impact, but we can't yet confirm which customers, regions, or services are affected. We can't send targeted communications, so we provide public updates.

### Information published on the status history page

You can view older events by using the [Azure status history](https://azure.status.microsoft/status/history/) page. This page only contains PIRs for incidents that happen on or after November 20, 2019.

The **Azure status history** page displays Post-Incident Reviews (PIR) only for Scenario 1 events. We're committed to publishing PIRs publicly for service issues with the broadest impact, like issues with both multiple-service and multiple-region impacts. We conduct and publish PIRs to ensure all customers and the industry at large can:

* Learn from our retrospectives on these issues.  
* Understand what steps we're taking to make such issues less likely and/or less impactful in the future.

During Scenario 2 and 3 events, we might communicate publicly on the **Azure status** page as a workaround to reach affected customers when standard, targeted communication routes aren't available.

After a Scenario 2 or 3 issue is mitigated, we conduct a thorough impact analysis to determine which customer subscriptions were affected. We provide the relevant PIR only to affected customers via [Service Health](https://azure.microsoft.com/features/service-health/) in the Azure portal.

## Related content

* Learn how you can get a more personalized view into Azure health by using [Service Health](./service-health-portal-update.md).
* Learn how you can get a more granular view into the health of your specific Azure resources by using [Azure Resource Health](./resource-health-overview.md).
