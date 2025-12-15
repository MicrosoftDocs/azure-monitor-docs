---
title: Security advisories configure subscriptions
description: This article describes how to set up and define access to Security advisories through the Azure portal.
ms.topic: how-to
ms.date: 12/15/2025
---

# Configure Tenant and Subscription access to view Security advisories

To access and view Security advisories you must have the correct role access. This article describes the steps to create tenant or subscription - based access.

**Access the Azure portal**<br> 
Log into the [Azure portal](https://ms.portal.azure.com/#home) and navigate to the **Subscriptions** section.


**Select the Subscription**: Choose the subscription that you want to manage for Security advisory access.

**Navigate to Access Control (IAM)**: Select **Access control (IAM)** to manage user roles.

**Add the role assignment**: Select **Add role assignment** to assign the necessary roles. <br>Users must have elevated roles such as *Owner* or *Contributor* to view sensitive information in Security advisories. Only users with elevated roles can access sensitive information on the Summary, Issue updates, and Impacted resources tabs.

**Verify the user roles**: Ensure that the user you're assigning has the appropriate Role-Based Access Control (RBAC) permissions. <br>Users with only reader access can't view sensitive details unless they're assigned the appropriate elevated permissions.

1.  **Update the email addresses**: To ensure that security notifications are received, verify that the email address associated with the user in Azure Active Directory is current. 
    1.  Navigate to Azure Active Directory 
    1.  Select **Users**
    1.  Check the user’s profile for the correct email address 
Make sure that the Subscription Administrator and Tenant Global Admin roles have the right contact information to receive notifications for security issues impacting at the subscription and tenant levels.
For more information about assigning roles in Azure, see [Assign Azure roles using the Azure portal](/azure/role-based-access-control/role-assignments-portal)