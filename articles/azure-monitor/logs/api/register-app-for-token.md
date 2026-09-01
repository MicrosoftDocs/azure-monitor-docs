---
title: Register an App to Request Authorization Tokens and Work with APIs
description: How to register an app and assign a role so it can request a token and work with APIs
ms.topic: how-to
ms.custom: cbo-v1.4
ms.date: 08/24/2026
ai-usage: ai-assisted
---

# Register an app to request authorization tokens and work with APIs

To access Azure REST APIs such as the Log Analytics API, or to send custom metrics, generate an authorization token based on a client ID and secret. Pass the token in your REST API request. This article shows you how to register a client app and create a client secret to generate a token.

## Prerequisites

- To register an application, you need a Microsoft Entra directory role such as [Application Developer](/entra/identity/role-based-access-control/permissions-reference#application-developer).
- To assign a role to the app, you need [Owner](/azure/role-based-access-control/built-in-roles#owner) or [User Access Administrator](/azure/role-based-access-control/built-in-roles#user-access-administrator) permissions on the scope where you assign the role.

## Register an app

Create a service principal and register an app by using the Azure portal, Azure CLI, or Azure PowerShell.

# [Portal](#tab/portal)

1. To register an app, open the Microsoft Entra ID Overview page in the Azure portal.

1. Select **App registrations** from the side bar.
:::image type="content" source="../media/api-register-app/active-directory-overview-page.png" alt-text="A screenshot showing the Microsoft Entra overview page.":::  

1. Select **New registration**
1. On the Register an application page, enter a **Name** for the application. 
1. Select **Register**

1. On the app's overview page, select **Certificates and Secrets**
1. Note the **Application (client) ID**. It's used in the HTTP request for a token.
:::image type="content" source="../media/api-register-app/app-registration-overview.png" alt-text="A screenshot showing the App registrations overview page in Microsoft Entra ID.":::
  
1. In the **Client secrets tab** Select **New client secret**
1. Enter a **Description** and select **Add**
 :::image type="content" source="../media/api-register-app/add-a-client-secret.png" alt-text="A screenshot showing the Add client secret page.":::
  
1. Copy and save the client secret **Value**.  

   > [!NOTE]
   > Client secret values can only be viewed immediately after creation. Be sure to save the secret before leaving the page.  

     :::image type="content" source="../media/api-register-app/client-secret.png" alt-text="A screenshot showing the client secrets page.":::

Assign a role to the app for the resources that you want to access with the API:

1. In the Azure portal, go to the resource, resource group, or subscription where you want to grant access, and select **Access control (IAM)**.
1. Select **Add** > **Add role assignment**.
1. On the **Role** tab, select the **Reader** role, and then select **Next**.
1. On the **Members** tab, select **Assign access to** > **User, group, or service principal**, then select **Select members** and choose your app.
1. Select **Review + assign**.

# [Azure CLI](#tab/cli)

The following Azure CLI example uses the [`az ad sp create-for-rbac`](/cli/azure/ad/sp#az-ad-sp-create-for-rbac) command. It creates a Microsoft Entra application and service principal by using the `--name` parameter.

```bash
# Set variables
servicePrincipalName="<ServicePrincipalDisplayName>"

# Create the service principal and app registration
az ad sp create-for-rbac --name "$servicePrincipalName"
```

The response looks as follows:

```json
{
  "appId": "00001111-aaaa-2222-bbbb-3333cccc4444",
  "displayName": "AzMonAPIApp",
  "password": "123456.ABCDE.~XYZ876123ABcEdB7169",
  "tenant": "aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e"
}
```

> [!IMPORTANT]
> The output includes credentials that you must protect. Don't include these credentials in your code or check them into source control.

The following Azure CLI example uses the [`az role assignment create`](/cli/azure/role/assignment#az-role-assignment-create) command. It grants the service principal access to the resources you target with the API by using the `--scope` parameter.

```bash
# Set variables
appId="<AppId>"
roleName="<RoleName>"
scope="<ScopeResourceId>"

# Assign the role to the service principal
az role assignment create \
  --assignee "$appId" \
  --role "$roleName" \
  --scope "$scope"
```

# [Azure PowerShell](#tab/powershell)

The following Azure PowerShell example uses the [`New-AzADServicePrincipal`](/powershell/module/az.resources/new-azadserviceprincipal) cmdlet. It creates the app registration and assigns a role by using the `Scope` parameter.

```powershell
# Set variables
$servicePrincipalName = "<ServicePrincipalDisplayName>"
$roleName = "<RoleName>"
$scope = "<ScopeResourceId>"

# Create a Microsoft Entra application and service principal with an auto-generated credential
$servicePrincipal = New-AzADServicePrincipal -DisplayName $servicePrincipalName

# Save the generated secret securely. It can't be retrieved after this point.
$servicePrincipal.PasswordCredentials.SecretText

# Define parameters for New-AzRoleAssignment
$newAzRoleAssignmentParams = @{
    RoleDefinitionName   = $roleName
    ServicePrincipalName = $servicePrincipal.AppId
    Scope                = $scope
}

# Assign the role to the service principal
New-AzRoleAssignment @newAzRoleAssignmentParams
```

---

## Next steps

You registered an app and assigned it a role. Next, use your app, client ID, and client secret to generate a bearer token to access the REST API.

The role you assign depends on the resource type and the API that you use. For example:

- For read access to a Log Analytics workspace, assign the **Reader** role on the workspace. For more information, see [Access the API](./access-api.md).
- To send custom metrics for a resource, assign the **Monitoring Metrics Publisher** role on the resource. For more information, see [Send metrics to the Azure Monitor metric database using REST API](../../essentials/metrics-store-custom-rest-api.md).

For more information about assigning roles, see [Assign Azure roles using the Azure portal](/azure/role-based-access-control/role-assignments-portal).

> [!NOTE]
> When using Microsoft Entra authentication, it might take up to 60 minutes for the Azure Application Insights REST API to recognize new role-based access control (RBAC) permissions. While permissions are propagating, REST API calls might fail with error code 403.
