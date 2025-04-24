---
title: In-portal Billing Communications
description: This article describes how to view and use in-portal Billing communications
ms.topic: overview
ms.date: 4/24/2025
---

# Overview
The In-portal billing communication in Service Health keeps you informed about your billing updates if you are the subscription owners, or subscription admin and have access to the billing updates blade in the service health portal and API. 
This will help you understand any billing changes that affect your subscription. If you don’t have access to either of these roles, you won’t see the new blade. 

![Screenshot of In-portal billing](./media/billing-elevated-access/in-portal-billing-main.png "main blade.")

It covers various billing communication types such as overbilling, underbilling, tax rate changes, foreign exchange rate changes, and price changes in a new blade in ASH called **Billing updates**. 

![Screenshot of In-portal billing](./media/billing-elevated-access/in-portal-billing-2.png "billing communication events.")

You can view up to 3 months of billing updates on the user interface and retrieve up to 12 months from the API. 
The billing communication events can be viewed through the Service Health portal or using the application programming interface (API). 


## Who can use this
The detail pages for billing communication event types are available in the Billing updates blade. The blade can only be accessed by users with the following elevated access:
- Subscription owner
- Subscription administrator
- Custom roles with the required permissions

If you don't have access to the blade you will see a message on your screen.

![Screenshot of In-portal billing](./media/billing-elevated-access/in-portal-access.png "no access to event details.")


## How to view Billing Events
Azure customers with any of the elevated accesses defined above can view billing communication events through the Billing updates blade in the ASH portal, via the API.<br>
![Screenshot of The in-portal billing](./media/billing-elevated-access/in-portal-billing-details.png "billing event details.")
<br>or in Azure Resource Graph (ARG) as shown here.<br>
![The in-portal billing](./media/billing-elevated-access/in-portal-billing-argquery.png "sample ARG query")