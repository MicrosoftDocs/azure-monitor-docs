---
ms.topic: include
ms.date: 03/12/2026
---

Get an authentication token by using any of the following methods:

* CLI
* REST API
* SDK

When requesting a token, you must provide a `resource` parameter. The `resource` parameter is the URL of the resource you want to access.

Resources include:

* `https://management.azure.com`
* `https://api.loganalytics.io`
* `https://monitoring.azure.com`

> [!TIP]
> Microsoft recommends that you use the most secure authentication flow available. Consider using [managed identities](/entra/identity/managed-identities-azure-resources/overview) for Azure resources where possible, which eliminates the need to manage credentials in your code.

## [CLI](#tab/cli)

### Get a token by using Azure CLI

To get a token by using the Azure CLI, use the following command:

```azurecli
az account get-access-token --resource https://monitoring.azure.com
```

For more information, see [az account get-access-token](/cli/azure/account#az-account-get-access-token).

## [REST](#tab/rest)

### Get a token by using a REST request

Use the following REST API call to get a token. This request uses a client ID and client secret to authenticate the request. The client ID and client secret are obtained when you register your application with Microsoft Entra ID. For more information, see [Register an App to request authorization tokens and work with APIs](/azure/azure-monitor/logs/api/register-app-for-token?tabs=portal).

> [!IMPORTANT]
> Microsoft recommends that you use the most secure authentication flow available. Consider using [managed identities](/entra/identity/managed-identities-azure-resources/overview) instead of client secrets when your application runs on Azure. If you must use client credentials, store your secrets securely in [Azure Key Vault](/azure/key-vault/general/overview).

```console
curl -X POST 'https://login.microsoftonline.com/<tenant_id>/oauth2/token' \
-H 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'grant_type=client_credentials' \
--data-urlencode 'client_id=<your_apps_client_id>' \
--data-urlencode 'client_secret=<your_apps_client_secret>' \
--data-urlencode 'resource=https://monitoring.azure.com'
```

The response body appears in the following format:

```JSON
{
    "token_type": "Bearer",
    "expires_in": "86399",
    "ext_expires_in": "86399",
    "expires_on": "1672826207",
    "not_before": "1672739507",
    "resource": "https://monitoring.azure.com",
    "access_token": "eyJ0eXAiOiJKV1Qi....gpHWoRzeDdVQd2OE3dNsLIvUIxQ"
}
```

## [SDK](#tab/SDK)

### Get a token by using the SDKs

The following code samples show how to get a token by using:

* C#
* Node.js
* Python

#### C#

The recommended approach is to use the `DefaultAzureCredential` class from the Azure.Identity library. This method uses the default Azure credentials to authenticate the request and works with managed identities, environment variables, the Azure CLI, and other credential sources without requiring explicit secrets in your code.

```csharp
using Azure.Identity;
using Azure.Core;

var credential = new DefaultAzureCredential();
var token = credential.GetToken(new TokenRequestContext(new[] { "https://management.azure.com/.default" }));
```

You can also specify your managed identity credentials:

```csharp
string userAssignedClientId = "<your_managed_identity_client_id>";
var credential = new DefaultAzureCredential(
    new DefaultAzureCredentialOptions
    {
        ManagedIdentityClientId = userAssignedClientId
    });

var token = credential.GetToken(new TokenRequestContext(new[] { "https://management.azure.com/.default" }));
```

For more information, see [DefaultAzureCredential Class](/dotnet/api/azure.identity.defaultazurecredential).

#### Node.js

For information on authentication with JavaScript and Node.js, see [How to authenticate JavaScript apps to Azure services using the Azure SDK for JavaScript](/azure/developer/javascript/sdk/authentication/overview).

The recommended approach is to use the `DefaultAzureCredential` class. This method uses the default Azure credentials to authenticate the request and works with managed identities without requiring explicit secrets in your code.

```javascript
const { DefaultAzureCredential } = require("@azure/identity");

const credential = new DefaultAzureCredential();
const accessToken = await credential.getToken("https://management.azure.com/.default");
```

You can also use the `InteractiveBrowserCredential` class to get the credentials. This method provides a browser-based authentication experience for users to authenticate with Azure services.

For more information, see [DefaultAzureCredential Class](/javascript/api/@azure/identity/defaultazurecredential) and [InteractiveBrowserCredential Class](/javascript/api/@azure/identity/interactivebrowsercredential).

If your application runs outside Azure and you need to use a service principal, use the `ClientSecretCredential` class:

> [!IMPORTANT]
> Microsoft recommends that you use the most secure authentication flow available. Consider using [managed identities](/entra/identity/managed-identities-azure-resources/overview) instead of client secrets when your application runs on Azure. If you must use client credentials, store your secrets securely in [Azure Key Vault](/azure/key-vault/general/overview).

```javascript
const { ClientSecretCredential } = require("@azure/identity");

const credential = new ClientSecretCredential(
    "<tenant_id>",
    "<client_id>",
    "<client_secret>"
);
const accessToken = await credential.getToken("https://management.azure.com/.default");
```

For more information, see [ClientSecretCredential Class](/javascript/api/@azure/identity/clientsecretcredential).

#### Python

The recommended approach is to use the `DefaultAzureCredential` class. This method uses the default Azure credentials to authenticate the request and works with managed identities without requiring explicit secrets in your code.

```python
from azure.identity import DefaultAzureCredential

credential = DefaultAzureCredential()
token = credential.get_token("https://management.azure.com/.default")
print(token.token)
```

You can also use the `InteractiveBrowserCredential` class to get the credentials. This method provides a browser-based authentication experience for users to authenticate with Azure services.

For more information, see [DefaultAzureCredential Class](/python/api/azure-identity/azure.identity.defaultazurecredential) and [InteractiveBrowserCredential Class](/python/api/azure-identity/azure.identity.interactivebrowsercredential).

If your application runs outside Azure and you need to use a service principal, use the `ClientSecretCredential` class:

> [!IMPORTANT]
> Microsoft recommends that you use the most secure authentication flow available. Consider using [managed identities](/entra/identity/managed-identities-azure-resources/overview) instead of client secrets when your application runs on Azure. If you must use client credentials, store your secrets securely in [Azure Key Vault](/azure/key-vault/general/overview).

```python
from azure.identity import ClientSecretCredential

credential = ClientSecretCredential(
    tenant_id="<tenant_id>",
    client_id="<client_id>",
    client_secret="<client_secret>"
)
token = credential.get_token("https://management.azure.com/.default")
print(token.token)
```

For more information, see [ClientSecretCredential Class](/python/api/azure-identity/azure.identity.clientsecretcredential).

---
