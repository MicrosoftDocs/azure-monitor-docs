---
title: Authenticate to Azure Monitor APIs
description: Choose an authentication method for Azure Monitor REST APIs, then assign the role and request the token audience each API requires.
ms.topic: how-to
ms.custom: cbo-v1.4
ms.date: 08/24/2026
ai-usage: ai-assisted
---

# Authenticate to Azure Monitor APIs

Azure Monitor REST APIs accept Microsoft Entra ID access tokens. Which method your code uses to get a token depends on where the code runs, not on which API it calls. Managed identity and workload identity federation store no credential at all and are the recommended choices. An app registration with a client certificate or secret is the fallback of last resort.

This article helps you pick a method, links to the Microsoft Entra ID procedure for each, and lists the role each Azure Monitor API requires. For the token audience to request, see [Authentication and token audiences](../../fundamentals/azure-monitor-rest-api-index.md#authentication-and-token-audiences).

## Prerequisites

- Permission to assign Azure roles on the target Azure Monitor resource, such as [Owner](/azure/role-based-access-control/built-in-roles#owner) or [User Access Administrator](/azure/role-based-access-control/built-in-roles#user-access-administrator).
- For the app registration path, a Microsoft Entra directory role such as [Application Developer](/entra/identity/role-based-access-control/permissions-reference#application-developer).

## Choose an authentication method

| Where your code runs | Method | Stored credential |
|---|---|---|
| Azure compute, including virtual machines, App Service, Functions, Azure Kubernetes Service, and Container Apps | [Managed identity](/entra/identity/managed-identities-azure-resources/overview) | None |
| GitHub Actions, Azure Pipelines, another cloud, or Kubernetes outside Azure | [Workload identity federation](/entra/workload-id/workload-identity-federation) | None |
| A developer workstation | [`DefaultAzureCredential`](/azure/developer/intro/passwordless-overview) with your own sign-in | None |
| A host that supports neither managed identity nor federation | App registration with a [certificate credential](/entra/identity-platform/how-to-add-credentials) | Certificate |
| No other option applies | App registration with a client secret | Secret |

Managed identity removes credential handling entirely, because the platform issues the token and rotates the underlying credential for you. Start there whenever the code runs on Azure compute.

Workload identity federation extends the same benefit outside Azure. An external identity provider issues a token that Microsoft Entra ID trusts, so no secret is stored in a pipeline or a cluster.

> [!IMPORTANT]
> Many tenants block client secret creation through policy, so an app registration that depends on a secret might fail even after the registration itself succeeds. Choose a certificate credential when federation isn't available. For the reasoning behind this order of preference, see [Secretless authentication in Azure](/entra/identity/managed-identities-azure-resources/secretless-authentication).

## Roles to assign

Assign the role to the identity you choose. Then request a token for the API's audience, listed in [Authentication and token audiences](../../fundamentals/azure-monitor-rest-api-index.md#authentication-and-token-audiences).

| API | Role to assign | Assign at |
|---|---|---|
| [Log Analytics Query API](access-api.md) | [Log Analytics Reader](/azure/role-based-access-control/built-in-roles#log-analytics-reader) | Log Analytics workspace |
| [Logs Ingestion API](../logs-ingestion-api-overview.md) | [Monitoring Metrics Publisher](/azure/role-based-access-control/built-in-roles#monitoring-metrics-publisher) | Data collection rule |
| [Custom metrics API](../../metrics/metrics-store-custom-rest-api.md) | Monitoring Metrics Publisher | The resource that emits the metrics |
| Azure Monitor control plane operations | Varies by operation | Resource or resource group |

The `Reader` role also grants query access to a workspace, but it has broader permissions than querying needs. For narrower alternatives, including table-level access, see [Manage access to Log Analytics workspaces](../manage-access.md).

## Assign the role

Assign the role from the previous section to the identity your code runs as. For a managed identity, use its principal object ID. For an app registration, use the service principal object ID.

# [Azure CLI](#tab/cli)

The following Azure CLI example uses the [`az role assignment create`](/cli/azure/role/assignment#az-role-assignment-create) command. It grants an identity access to an Azure Monitor resource by using the `--scope` parameter.

```bash
# Set variables
principalId="<PrincipalObjectId>"
roleName="<RoleName>"
scope="<ScopeResourceId>"

# Assign the role to the identity
az role assignment create \
  --assignee-object-id "$principalId" \
  --assignee-principal-type ServicePrincipal \
  --role "$roleName" \
  --scope "$scope"
```

# [Azure PowerShell](#tab/powershell)

The following Azure PowerShell example uses the [`New-AzRoleAssignment`](/powershell/module/az.resources/new-azroleassignment) cmdlet. It grants an identity access to an Azure Monitor resource by using the `Scope` parameter.

```powershell
# Set variables
$principalId = "<PrincipalObjectId>"
$roleName = "<RoleName>"
$scope = "<ScopeResourceId>"

# Define parameters for New-AzRoleAssignment
$newAzRoleAssignmentParams = @{
    ObjectId           = $principalId
    RoleDefinitionName = $roleName
    Scope              = $scope
}

# Assign the role to the identity
New-AzRoleAssignment @newAzRoleAssignmentParams
```

---

## Use a managed identity

1. Enable a managed identity on the Azure resource that runs your code. The procedure differs by service, so see [Managed identities for Azure resources](/entra/identity/managed-identities-azure-resources/overview) and follow the link for your host.
1. Assign the role from [Roles to assign](#roles-to-assign) to the identity.
1. Acquire tokens with [`DefaultAzureCredential`](/azure/developer/intro/passwordless-overview), which resolves the managed identity automatically when the code runs on Azure and falls back to your developer sign-in locally.

The Azure Monitor client libraries accept a credential object directly, so the library handles token acquisition, caching, and refresh. See [Azure Monitor Query client library](/dotnet/api/overview/azure/monitor.query-readme) and [Azure Monitor Ingestion client library](/dotnet/api/overview/azure/monitor.ingestion-readme).

## Use workload identity federation

Workload identity federation lets a workload outside Azure exchange a token from its own identity provider for a Microsoft Entra ID token. No secret is stored in the pipeline, cluster, or external cloud.

1. [Register an application](/entra/identity-platform/quickstart-register-app) in Microsoft Entra ID.
1. [Configure a federated identity credential](/entra/workload-id/workload-identity-federation-create-trust) for your provider, such as GitHub Actions, Kubernetes, or another cloud.
1. Assign the role from [Roles to assign](#roles-to-assign) to the application's service principal.

For the supported providers and the trust model, see [Workload identity federation](/entra/workload-id/workload-identity-federation).

## Register an app with a credential

Use this method only when neither managed identity nor workload identity federation applies.

1. [Register an application](/entra/identity-platform/quickstart-register-app) in Microsoft Entra ID, and record the application (client) ID and directory (tenant) ID.
1. [Add a credential](/entra/identity-platform/how-to-add-credentials) to the registration. Choose a certificate over a client secret, and review [Security best practices for application properties](/entra/identity-platform/security-best-practices-for-app-registration).
1. Assign the role from [Roles to assign](#roles-to-assign) to the application's service principal.

Create the registration, its service principal, and a self-signed certificate in a single step:

# [Azure CLI](#tab/cli)

The following Azure CLI example uses the [`az ad sp create-for-rbac`](/cli/azure/ad/sp#az-ad-sp-create-for-rbac) command. It creates a certificate credential instead of a client secret by using the `--create-cert` parameter.

```bash
# Set variables
servicePrincipalName="<ServicePrincipalDisplayName>"

# Create the app registration and service principal with a certificate credential
az ad sp create-for-rbac --name "$servicePrincipalName" --create-cert
```

The command writes the certificate to a `.pem` file in your profile directory and prints its path. Protect that file the same way you protect a secret, and assign the role separately as shown in [Assign the role](#assign-the-role).

# [Azure PowerShell](#tab/powershell)

The following Azure PowerShell example uses the [`New-AzADServicePrincipal`](/powershell/module/az.resources/new-azadserviceprincipal) cmdlet. It creates the app registration and service principal, then reads the generated credential once.

```powershell
# Set variables
$servicePrincipalName = "<ServicePrincipalDisplayName>"

# Create the app registration and service principal
$servicePrincipal = New-AzADServicePrincipal -DisplayName $servicePrincipalName

# Read the generated secret. It can't be retrieved after this point.
$servicePrincipal.PasswordCredentials.SecretText
```

To replace the generated secret with a certificate, see [Add and manage application credentials in Microsoft Entra ID](/entra/identity-platform/how-to-add-credentials).

---

## Considerations

- **Client secrets are frequently blocked.** Tenant policy commonly prevents secret creation, and a registration that depends on one then fails at runtime. Treat a secret as a temporary measure and plan a move to federation or a certificate.
- **The implicit grant flow is deprecated.** Don't use it for new work. Use the authorization code flow with Proof Key for Code Exchange (PKCE) for user-facing apps, as described in [Microsoft identity platform and OAuth 2.0 authorization code flow](/entra/identity-platform/v2-oauth2-auth-code-flow).
- **Resource owner password credentials (ROPC) is not supported.** It can't satisfy multifactor authentication or Conditional Access requirements.
- **Token lifetime is limited.** Cache a token until it nears expiry rather than requesting one per call, and let the Azure SDK credential classes handle refresh where possible.

## Related content

- [Access the Azure Monitor Log Analytics API](access-api.md)
- [Logs Ingestion API in Azure Monitor](../logs-ingestion-api-overview.md)
- [Send metrics to the Azure Monitor metric database using REST API](../../metrics/metrics-store-custom-rest-api.md)
- [Secretless authentication in Azure](/entra/identity/managed-identities-azure-resources/secretless-authentication)
- [Manage access to Log Analytics workspaces](../manage-access.md)