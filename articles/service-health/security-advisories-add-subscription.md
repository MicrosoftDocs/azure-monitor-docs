---
title: Configure subscriptions for Security advisories
description: This article describes how to set up and define access to Security advisories through the Azure portal.
ms.topic: how-to
ms.date: 12/16/2025
---

# Configure Tenant and Subscription access to view Security advisories

To access and view Security advisories, you must have the correct role access. This article describes the steps to create tenant or subscription - based access.

**1. Access the Azure portal**<br> 
Log into the [Azure portal](https://ms.portal.azure.com/#home) and navigate to the **Subscriptions** section.

:::image type="content"source="./media/assign-roles/select-subscription.png"alt-text="A screenshot of Azure portal to select and open the subscription panel."Lightbox="./media/assign-roles/select-subscription.png":::


**2. Select the Subscription**

Choose the subscription that you want to manage for Security advisory access.

:::image type="content"source="./media/assign-roles/subscription-screen.png"alt-text="A screenshot of subscription panel."Lightbox="./media/assign-roles/subscription-screen.png":::


**3. Navigate to Access Control (IAM)** 

Select **Access control (IAM)** to manage user roles.

:::image type="content"source="./media/assign-roles/access-control-screen.png"alt-text="A screenshot of the Access control screen screen panel."Lightbox="./media/assign-roles/access-control-screen.png":::


**4. Add the role assignment**

 Select **Add role assignment** to assign the necessary roles. <br>Users must have elevated roles such as *Owner* or *Contributor* to view sensitive information in Security advisories. Only users with elevated roles can access sensitive information on the Summary, Issue updates, and Impacted resources tabs.

:::image type="content"source="./media/assign-roles/add-role.png"alt-text="A screenshot of menu to add a role."Lightbox="./media/assign-roles/add-role.png":::


**5. Verify the user roles** 

Ensure that the user you're assigning has the appropriate Role-Based Access Control (RBAC) permissions. <br>Users with only reader access can't view sensitive details unless they're assigned the appropriate elevated permissions.

**6. Update the email addresses** 

To ensure that security notifications are received, verify that the email address associated with the user is current. 
    1. Navigate to Azure Active Directory. 
    1. Select **Users**.
    1. Check the user’s profile for the correct email address.

Make sure that the Subscription Administrator and Tenant Global Admin roles have the right contact information to receive notifications for security issues impacting at the subscription and tenant levels.
For more information about assigning roles in Azure, see [Assign Azure roles using the Azure portal](/azure/role-based-access-control/role-assignments-portal)