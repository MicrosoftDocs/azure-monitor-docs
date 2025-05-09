---
title: In-portal Billing Communications
description: This article describes how to view and use in-portal Billing communications
ms.topic: overview
ms.date: 5/09/2025
---

# Overview

The in-portal billing communication in [Service Health](service-health-overview.md) shows billing updates for users with the **subscription owner** or **subscription admin** roles. These users can view updates in both the **Billing Updates** pane and the Service Health API.

![Screenshot of in-portal billing main pane.](./media/billing-elevated-access/in-portal-billing-main.png "In-portal billing main pane.")

To help you track billing changes, the communication includes updates that relate to your subscription. Users without these roles can’t access the **Billing Updates** pane.

![Screenshot of in-portal billing main pane with more information.](./media/billing-elevated-access/in-portal-billing-2.png "Billing communication events.")

The **Billing Updates** pane includes billing communication types such as:

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

To view the **Billing Updates** pane, you need one of the following roles:

- Subscription owner
- Subscription contributor
- Custom role with the required permissions

Users without access see a message instead of the pane.

![Screenshot of no in-portal billing access.](./media/billing-elevated-access/in-portal-billing-access.png "No access to billing event details.")

## How to view billing events

Azure customers with any of the elevated accesses defined here can view billing communication events through the **Billing Updates pane**  in the [Service Health](service-health-overview.md) portal, and through the API access to retrieve billing event data,
  
  ![Screenshot of the in-portal billing details.](./media/billing-elevated-access/in-portal-billing-details.png "Billing event details.")
or use an **Azure Resource Graph (ARG)** using supported queries.
  
  ![Screenshot of the in-portal billing argument query.](./media/billing-elevated-access/in-portal-billing-azure-resource-graph-query.png "sample azure graph query.")
