---
ms.topic: include
ms.date: 03/12/2026
---

Get an authentication token using any of the following methods:

* CLI
* REST API
* SDK


## [REST](#tab/rest)

### Get a token using a REST request

Use the following REST API call to get a token. This request uses a client ID and client secret to authenticate the request. The client ID and client secret are obtained when you register your application with Microsoft Entra ID. For more information, see [Register an App to request authorization tokens and work with APIs](/azure/azure-monitor/logs/api/register-app-for-token?tabs=portal).

```console
curl -X POST 'https://login.microsoftonline.com/<tennant ID>/oauth2/token' \
-H 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'grant_type=client_credentials' \
--data-urlencode 'client_id=<your apps client ID>' \
--data-urlencode 'client_secret=<your apps client secret' \
--data-urlencode 'resource={resource URI of the service you want to access, e.g. https://monitoring.azure.com>'}'
```

The response body appears in the following format:

```JSON
{
    "token_type": "Bearer",
    "expires_in": "86399",
    "ext_expires_in": "86399",
    "expires_on": "1672826207",
    "not_before": "1672739507",
    "resource": "{resource URI of the service you want to access, e.g. https://monitoring.azure.com>'}",
    "access_token": "eyJ0eXAiOiJKV1Qi....gpHWoRzeDdVQd2OE3dNsLIvUIxQ"
}
```

## [CLI](#tab/cli)
### Get a token using Azure CLI
To get a token using CLI, you can use the following command

```bash
az account get-access-token
```

For more information, see [az account get-access-token](/cli/azure/account#az-account-get-access-token)

## [SDK](#tab/SDK)

### Get a token using the SDKs

One of the quickest ways to get an authentication token for Azure SDKs is to use the `DefaultAzureCredential` class, but it introduces certain tradeoffs. 

For more information, see [Best practices for Azure SDK authentication](/azure/sdk/authentication/best-practices?tabs=aspdotnet#use-deterministic-credentials-in-production-environments).

* C# 
* NodeJS
* Python

#### C#

For more information, see [DefaultAzureCredential Class](/dotnet/api/azure.identity.defaultazurecredential)

#### Node.js

For information on authentication using JavaScript and NodeJS, see [How to authenticate JavaScript apps to Azure services using the Azure SDK for JavaScript](/azure/developer/javascript/sdk/authentication/overview)

#### Python

For more information, see [DefaultAzureCredential Class](/python/api/azure-identity/azure.identity.defaultazurecredential) and [InteractiveBrowserCredential Class](/python/api/azure-identity/azure.identity.interactivebrowsercredential)

---
