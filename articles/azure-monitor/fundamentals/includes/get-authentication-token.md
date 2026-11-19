---
ms.topic: include
ms.date: 08/24/2026
---

Get an authentication token by using any of the following methods. The Azure CLI and the Azure SDKs acquire and refresh tokens for you, so prefer them over a raw token request.

## [CLI](#tab/cli)

### Get a token using Azure CLI

Use the [`az account get-access-token`](/cli/azure/account#az-account-get-access-token) command, passing the token audience for the API you're calling.

```bash
# Set variables
tokenAudience="<TokenAudience>"

# Get an access token for the audience
az account get-access-token \
  --scope "$tokenAudience/.default" \
  --query accessToken \
  --output tsv
```

## [SDK](#tab/SDK)

### Get a token using the SDKs

Use the `DefaultAzureCredential` class to acquire tokens. It resolves a managed identity when the code runs on Azure and falls back to your developer sign-in locally, so the same code works in both places without a stored credential.

For the tradeoffs and how to pin a specific credential in production, see [Best practices for Azure SDK authentication](/dotnet/azure/sdk/authentication/best-practices?tabs=aspdotnet#use-deterministic-credentials-in-production-environments).

#### C\#

For more information, see [DefaultAzureCredential Class](/dotnet/api/azure.identity.defaultazurecredential).

#### Node.js

For more information, see [How to authenticate JavaScript apps to Azure services using the Azure SDK for JavaScript](/azure/developer/javascript/sdk/authentication/overview).

#### Python

For more information, see [DefaultAzureCredential Class](/python/api/azure-identity/azure.identity.defaultazurecredential) and [InteractiveBrowserCredential Class](/python/api/azure-identity/azure.identity.interactivebrowsercredential).

## [REST](#tab/rest)

### Get a token by using a REST request

Request a token directly only when neither the Azure CLI nor an SDK is available in your environment. This flow needs an app registration credential, which many tenants restrict by policy. For methods that store no credential, see [Secretless authentication in Azure](/entra/identity/managed-identities-azure-resources/secretless-authentication).

The following request uses the Microsoft identity platform v2.0 endpoint and the client credentials grant.

```bash
curl -X POST 'https://login.microsoftonline.com/<TenantId>/oauth2/v2.0/token' \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  --data-urlencode 'grant_type=client_credentials' \
  --data-urlencode 'client_id=<ClientId>' \
  --data-urlencode 'client_secret=<ClientSecret>' \
  --data-urlencode 'scope=<TokenAudience>/.default'
```

The response body appears in the following format:

```json
{
    "token_type": "Bearer",
    "expires_in": 3599,
    "access_token": "******"
}
```

---