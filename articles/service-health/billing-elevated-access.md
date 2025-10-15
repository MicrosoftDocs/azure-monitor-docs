---
title: In-portal Billing Communications
description: This article describes how to view and use in-portal Billing communications
ms.topic: overview
ms.date: 10/15/2025
---

# In-portal Billing Communications

## Overview

The in-portal billing communication in [Service Health](service-health-overview.md) shows billing updates for users with the **subscription owner** or **subscription contributor** roles. These users can view updates in both the **Billing Updates** pane and the Service Health API.

:::image type="content"source="./media/billing-elevated-access/in-portal-billing-main.png"alt-text="A screenshot of the In-portal billing main pane."Lightbox="./media/billing-elevated-access/in-portal-billing-main.png":::


To help you track billing changes, the communication includes updates that relate to your subscription. Users without these roles can’t access the **Billing Updates** pane.

:::image type="content"source="./media/billing-elevated-access/in-portal-billing-2.png"alt-text="A screenshot of in-portal billing main pane with more information."Lightbox="./media/billing-elevated-access/in-portal-billing-2.png":::


The **Billing pdates** pane includes billing communication types such as:

- Overbilling notifications
- Underbilling notifications
- Tax rate changes
- Foreign exchange rate changes
- Price changes

You can view up to three months of billing updates in the user interface and retrieve up to 12 months through the API. Billing communication events are available through the Service Health portal and the API.

**Requirements:**

- Subscription owner or subscription contributor role
- Access to the Service Health portal or API


## Access requirements

The detail pages for billing communication event types appear in the **Billing Updates** pane in [Service Health](service-health-overview.md). Only users with elevated access can open the pane.

To view the **Billing pdates** pane, you need to have access as one of the following roles:

- Subscription owner
- Subscription contributor
- Custom role with the required permissions

Users without access see a message at the top of the pane.

:::image type="content"source="./media/billing-elevated-access/in-portal-billing-access.png"alt-text="Screenshot of no in-portal billing access."Lightbox="./media/billing-elevated-access/in-portal-billing-access.png":::

## How to view billing events

Azure customers with any of the elevated accesses defined here can view billing communication events through the **Billing updates** pane  in the [Service Health](service-health-overview.md) portal, and through the API access to retrieve billing event data,
  
:::image type="content"source="./media/billing-elevated-access/in-portal-billing-details.png"alt-text="A screenshot of Billing event details."Lightbox="./media/billing-elevated-access/in-portal-billing-details.png":::

Or use an **Azure Resource Graph (ARG)** using supported queries.
  
:::image type="content"source="./media/billing-elevated-access/in-portal-billing-azure-resource-graph-query.png"alt-text="A screenshot of sample Azure graph query."Lightbox="./media/billing-elevated-access/in-portal-billing-azure-resource-graph-query.png":::

### Filtering and sorting
At the top of the pane, there are several options to sort the information.

:::image type="content"source="./media/billing-elevated-access/in-portal-billing-sort-bar.png"alt-text="A screenshot of filtering options."Lightbox="./media/billing-elevated-access/in-portal-billing-sort-bar.png":::

- Scope
- Subscription
- Region
- Service
- Event level
