---
title: Configure subscriptions for Security advisories
description: This article describes how to set up and define access to Security advisories through the Azure portal.
ms.topic: how-to
ms.date: 01/05/2026
---

# Configure Subscription access to view Security advisories

To access and view Security advisories, you must have the correct role access. This article describes the steps to create tenant or subscription - based access.

Subscription‑based access means you can only see Security Advisories that apply to the specific Azure subscription you’re permitted to view.

Tenant-based access applies to the entire Microsoft Entra ID tenant, meaning it covers all subscriptions in that organization.

For more information about the roles required to view Security Advisories, including custom roles, refer to [Role Based Access (RBAC) for Sensitive Security](/azure/service-health/impacted-resources-security#role-based-access-rbac-for-sensitive-security-incident-resource-impact-and-sensitive-details).

## Subscription-based access

The following steps explain how to set up a subscription to view Security advisories.

**1. Access the Azure portal**<br> 
Log into the [Azure portal](https://ms.portal.azure.com/#home) and navigate to the **Subscriptions** section.

:::image type="content"source="./media/assign-roles/select-subscription.png"alt-text="A screenshot of Azure portal to select and open the subscription panel."Lightbox="./media/assign-roles/select-subscription.png":::


**2. Select the Subscription**

Choose the subscription that you want to manage for Security advisory access.

:::image type="content"source="./media/assign-roles/subscription-screen.png"alt-text="A screenshot of subscription panel."Lightbox="./media/assign-roles/subscription-screen.png":::


**3. Navigate to Access control (IAM)** 

Select **Access control (IAM)** to manage user roles.

:::image type="content"source="./media/assign-roles/access-control-screen.png"alt-text="A screenshot of the Access control screen panel."Lightbox="./media/assign-roles/access-control-screen.png":::


**4. Add the role assignment**

 Select **Add role assignment** to assign the necessary roles. <br>Users must have elevated roles such as *Owner* or *Contributor* to view sensitive information in Security advisories. Only users with elevated roles can access sensitive information on the Summary, Issue updates, and Impacted resources tabs.

:::image type="content"source="./media/assign-roles/add-role.png"alt-text="A screenshot of menu to add a role."Lightbox="./media/assign-roles/add-role.png":::


**5. Verify the user roles** 

Ensure that the user you're assigning has the appropriate **Role-Based Access Control (RBAC)** permissions. <br>Users with only reader access can't view sensitive details unless they're assigned the appropriate elevated permissions. 
- The **Reader** role can only view. 
- The **Contributor** role:
    - Can create, modify, and delete any Azure resource in the subscription.
    - Can deploy and manage Virtual Machines (VMs), storage accounts, networks, and functions
    - Can't manage Access control Identity & Access Management (IAM)
- The **Co-administrator** role:
    - Can view, modify resources, Manage access control (IAM) with almost the same access as a full subscription.
    - Can't change the service administrator for a subscription.
- The **Custom Role**:
    - You or your subscription administrator define the permissions for this role.


**6. Update the email addresses** 

To ensure that security notifications are received, verify that the email address associated with the user is current follow these steps.<br> 
    
1. Navigate to **Microsoft Entra ID**.<br>
2. Select **Users**.<br>
3. Check the user’s profile for the correct email address.

Make sure that the Subscription Administrator and Tenant Global Admin roles have the right contact information to receive notifications for security issues impacting at the subscription and tenant levels.
For more information about assigning roles in Azure, see [Assign Azure roles using the Azure portal](/azure/role-based-access-control/role-assignments-portal).

## Tenant-based access

Tenant admin access in Azure refers to the permissions granted to roles that allow users to manage and view resources at the tenant level.<br> These roles include Global Administrator, Application Administrator, and others. Tenant admin access enables users to manage users, groups, and permissions within the organization, and view tenant-level events in the Azure Service Health portal.

>[!NOTE] 
>Tenant-level alerts require tenant admin–level read access.

**1. Identify who needs tenant-level access**

Determine which users or teams require visibility into:
- Organization-wide security advisories
- Sensitive advisory details (Summary, Issue Updates, Impacted Resources)
  >[!NOTE] 
  > Only tenant admin level roles can view tenant scoped security advisories. For more information on who can access Security advisories, see [Who can view Security advisories](/azure/service-health/security-advisories-elevated-access#who-can-view-security-advisories).

**2. Access the Azure portal**<br> 
Log into the [Azure portal](https://ms.portal.azure.com/#home) and navigate to the **Microsoft Entra ID** section.

:::image type="content"source="./media/assign-roles/microsoft-entra-signin.png"alt-text="A screenshot of the portal with Microsoft Entra ID sign-in."Lightbox="./media/assign-roles/microsoft-entra-signin.png":::


**3.** Add **Roles and administrators**<br> 
Select **Roles and administrators** from the side panel.

:::image type="content"source="./media/assign-roles/roles-admin-sign-open.png"alt-text="A screenshot of the Roles and administrators panel."Lightbox="./media/assign-roles/roles-admin-sign-open.png":::


**4. Select the role**<br> 
Select the role directly to open a new window.

:::image type="content"source="./media/assign-roles/select-role-description.png"alt-text="A screenshot of the list of roles to choose from."Lightbox="./media/assign-roles/select-role-description.png":::

**5. Add Assignment**

On this panel there are three tabs, *Eligible assignments*, *Active assignments* and *Expired assignments*. Select **+ Add assignments**. 

:::image type="content"source="./media/assign-roles/add-assignment-1.png"alt-text="A screenshot of panel showing assignments for this role."Lightbox="./media/assign-roles/add-assignment-1.png":::

1. A new pane appears where you choose who should receive this role. Use the search box to find:
- A user account
- A Microsoft 365 group
- An application / service principal (if you're assigning to identity app)
2. Select the correct identity from the results.

>[!TIP] 
>Only groups and people who can be assigned appear on the list.

**6. Confirm the assignment**
1. Select **Next** (if prompted). 
1. Select **Assign**.
1. The user/group/app appears under the role's *Assignments* tab.

**7. Verify the permissions** (Optional)
1. Sign out and then sign in again.
1. Confirm the access to the feature they need (for instance viewing tenant-level Security advisories in Service health).


