---
title: Microsoft Entra Authentication for Application Insights
description: Learn how to enable Microsoft Entra authentication to ensure that only authenticated telemetry is ingested in your Application Insights resources.
ms.topic: how-to
ms.date: 03/06/2026
ai-usage: ai-assisted
ms.devlang: csharp
ms.custom: sfi-ropc-nochange
---

# Microsoft Entra authentication for Application Insights

Application Insights now supports [Microsoft Entra authentication](/entra/identity/authentication/overview-authentication). By using Microsoft Entra ID, you can ensure that only authenticated telemetry is ingested in your Application Insights resources.

Using various authentication systems can be cumbersome and risky because it's difficult to manage credentials at scale. You can now choose to [opt out of local authentication](#disable-local-authentication) to ensure only telemetry exclusively authenticated by using [managed identities](/azure/active-directory/managed-identities-azure-resources/overview) and [Microsoft Entra ID](/azure/active-directory/fundamentals/active-directory-whatis) is ingested in your resource.

This feature enhances the security and reliability of the telemetry used to make critical operational ([alerting](../alerts/alerts-overview.md#what-are-azure-monitor-alerts) and [autoscaling](../autoscale/autoscale-overview.md#overview-of-autoscale-in-azure)) and business decisions.

## Prerequisites

To enable Microsoft Entra authenticated ingestion, complete the following steps:

> [!div class="checklist"]
> * Be familiar with [Managed identity](/azure/active-directory/managed-identities-azure-resources/overview), [Service principal](/azure/active-directory/develop/howto-create-service-principal-portal), and [Assigning Azure roles](/azure/role-based-access-control/role-assignments-portal).
> * Have an Owner role to the resource group, required for granting access by using [Azure built-in roles](/azure/role-based-access-control/built-in-roles).
> * Understand the [unsupported scenarios](#unsupported-scenarios).

## Unsupported scenarios

The following Software Development Kits (SDKs) and features don't support use with Microsoft Entra authenticated ingestion:

* Application Insights Java 2.x SDK. Microsoft Entra authentication is only available for Application Insights Java Agent greater than or equal to 3.2.0.
* [Application Insights JavaScript SDK](javascript-sdk.md).
* [Application Insights OpenCensus Python SDK (retired)](/previous-versions/azure/azure-monitor/app/opencensus-python) with Python version 3.4 and 3.5.
* [Automatic instrumentation for Python on Azure App Service](azure-web-apps-python.md).

<a name='configure-and-enable-azure-ad-based-authentication'></a>

## Configure and enable Microsoft Entra ID-based authentication

1. Create an identity by using a managed identity or a service principal if you don't already have one.

    * Use a managed identity:

        [Set up a managed identity for your Azure service](/azure/active-directory/managed-identities-azure-resources/services-support-managed-identities) (Virtual Machines or App Service).

    * Don't use a service principal:

        For more information about how to create a Microsoft Entra application and service principal that can access resources, see [Create a service principal](/azure/active-directory/develop/howto-create-service-principal-portal).

1. Assign the required role to the Azure identity, service principal, or Azure user account.

    Follow the steps in [Assign Azure roles](/azure/role-based-access-control/role-assignments-portal) to add the Monitoring Metrics Publisher role to the expected identity, service principal, or Azure user account by setting the target Application Insights resource as the role scope.

    > [!NOTE]
    > Although the Monitoring Metrics Publisher role says "metrics," it publishes all telemetry to the Application Insights resource.

1. Follow the configuration guidance in accordance with the language that follows.

# [ASP.NET Core](#tab/aspnetcore)

> [!NOTE]
> * Support for Microsoft Entra ID in the Application Insights .NET SDK is included starting with [version 2.18-Beta3](https://www.nuget.org/packages/Microsoft.ApplicationInsights/2.18.0-beta3).
>
> * The SDK supports the credential classes provided by [Azure Identity](https://github.com/Azure/azure-sdk-for-net/tree/main/sdk/identity/Azure.Identity#credential-classes).

### Prerequisites

* Use `DefaultAzureCredential` for local development.

* Sign in to Visual Studio by using the expected Azure user account. For more information, see [Authenticate via Visual Studio](https://github.com/Azure/azure-sdk-for-net/tree/main/sdk/identity/Azure.Identity#authenticate-via-visual-studio).

* Use `ManagedIdentityCredential` for system-assigned and user-assigned managed identities.

    * For system-assigned, use the default constructor without parameters.
    * For user-assigned, provide the client ID to the constructor.

### Configuration guidance

1. Install the latest [Azure.Identity](https://www.nuget.org/packages/Azure.Identity) package.

    ```dotnetcli
    dotnet add package Azure.Identity
    ```

1. Provide the desired credential class.

    ```csharp
    // Create a new ASP.NET Core web application builder.
    var builder = WebApplication.CreateBuilder(args);

    // Add the OpenTelemetry telemetry service to the application.
    // This service will collect and send telemetry data to Azure Monitor.
    builder.Services.AddOpenTelemetry().UseAzureMonitor(options => {
        // Set the Azure Monitor credential to the DefaultAzureCredential.
        // This credential will use the Azure identity of the current user or
        // the service principal that the application is running as to authenticate
        // to Azure Monitor.
        options.Credential = new DefaultAzureCredential();
    });

    // Build the ASP.NET Core web application.
    var app = builder.Build();

    // Start the ASP.NET Core web application.
    app.Run();
    ```

#### Environment variable configuration

Use the `APPLICATIONINSIGHTS_AUTHENTICATION_STRING` environment variable to let Application Insights authenticate to Microsoft Entra ID and send telemetry when using [Azure App Services autoinstrumentation](./azure-web-apps-net-core.md) and [Configure monitoring for Azure Functions](/azure/azure-functions/configure-monitoring).

* **System-assigned identity:**

    | App setting | Value |
    |-------------|-------|
    | APPLICATIONINSIGHTS_AUTHENTICATION_STRING | `Authorization=AAD` |

* **User-assigned identity:**

    | App setting | Value |
    |-------------|-------|
    | APPLICATIONINSIGHTS_AUTHENTICATION_STRING | `Authorization=AAD;ClientId={Client id of the User-Assigned Identity}` |

# [.NET](#tab/net)

> [!NOTE]
> * Support for Microsoft Entra ID in the Application Insights .NET SDK is included starting with [version 2.18-Beta3](https://www.nuget.org/packages/Microsoft.ApplicationInsights/2.18.0-beta3).
>
> * The SDK supports the credential classes provided by [Azure Identity](https://github.com/Azure/azure-sdk-for-net/tree/main/sdk/identity/Azure.Identity#credential-classes).

### Prerequisites

* Use `DefaultAzureCredential` for local development.

* Sign in to Visual Studio by using the expected Azure user account. For more information, see [Authenticate via Visual Studio](https://github.com/Azure/azure-sdk-for-net/tree/main/sdk/identity/Azure.Identity#authenticate-via-visual-studio).

* Use `ManagedIdentityCredential` for system-assigned and user-assigned managed identities.

    * For system-assigned, use the default constructor without parameters.
    * For user-assigned, provide the client ID to the constructor.

### Configuration guidance

1. Install the latest [Azure.Identity](https://www.nuget.org/packages/Azure.Identity) package.

    ```dotnetcli
    dotnet add package Azure.Identity
    ```

1. Provide the desired credential class.

    ```csharp
    // Create a DefaultAzureCredential.
    var credential = new DefaultAzureCredential();

    // Create a new OpenTelemetry tracer provider and set the credential.
    // It is important to keep the TracerProvider instance active throughout the process lifetime.
    var tracerProvider = Sdk.CreateTracerProviderBuilder()
        .AddAzureMonitorTraceExporter(options =>
        {
            options.Credential = credential;
        })
        .Build();

    // Create a new OpenTelemetry meter provider and set the credential.
    // It is important to keep the MetricsProvider instance active throughout the process lifetime.
    var metricsProvider = Sdk.CreateMeterProviderBuilder()
        .AddAzureMonitorMetricExporter(options =>
        {
            options.Credential = credential;
        })
        .Build();

    // Create a new logger factory and add the OpenTelemetry logger provider with the credential.
    // It is important to keep the LoggerFactory instance active throughout the process lifetime.
    var loggerFactory = LoggerFactory.Create(builder =>
    {
        builder.AddOpenTelemetry(logging =>
        {
            logging.AddAzureMonitorLogExporter(options =>
            {
                options.Credential = credential;
            });
        });
    });
    ```

#### Environment variable configuration

Use the `APPLICATIONINSIGHTS_AUTHENTICATION_STRING` environment variable to let Application Insights authenticate to Microsoft Entra ID and send telemetry when using [Azure App Services autoinstrumentation](./azure-web-apps-net-core.md).

* **System-assigned identity:**

    | App setting | Value |
    |-------------|-------|
    | APPLICATIONINSIGHTS_AUTHENTICATION_STRING | `Authorization=AAD` |

* **User-assigned identity:**

    | App setting | Value |
    |-------------|-------|
    | APPLICATIONINSIGHTS_AUTHENTICATION_STRING | `Authorization=AAD;ClientId={Client id of the User-Assigned Identity}` |

# [Java](#tab/java)

> [!NOTE]
> * The Application Insights Java agent supports Microsoft Entra ID starting with [Java 3.2.0-BETA](https://github.com/microsoft/ApplicationInsights-Java/releases/tag/3.2.0-BETA).
>
> * The SDK supports the credential classes provided by [Azure Identity](https://github.com/Azure/azure-sdk-for-net/tree/main/sdk/identity/Azure.Identity#credential-classes).

### Configuration guidance

1. [Configure your application with the Java agent.](opentelemetry-enable.md?tabs=java#enable-opentelemetry-with-application-insights)

    > [!IMPORTANT]
    > Use the full connection string, which includes `IngestionEndpoint`, when you configure your app with the Java agent. For example, use `InstrumentationKey=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX;IngestionEndpoint=https://XXXX.applicationinsights.azure.com/`.

1. Add the JSON configuration to the *ApplicationInsights.json* configuration file depending on the authentication you're using. Use managed identities for authentication.

#### Environment variable configuration

The `APPLICATIONINSIGHTS_AUTHENTICATION_STRING` environment variable enables Application Insights to authenticate with Microsoft Entra ID and send telemetry. Configure it based on the type of identity you're using:

* **System-assigned identity:**

    Set the `APPLICATIONINSIGHTS_AUTHENTICATION_STRING` environment variable to:

    ```plaintext
    Authorization=AAD
    ```

* **User-assigned identity:**

    Set the `APPLICATIONINSIGHTS_AUTHENTICATION_STRING` environment variable to:

    ```plaintext
    Authorization=AAD;ClientId={Client id of the User-Assigned Identity}
    ```

    Replace `{Client id of the User-Assigned Identity}` with the actual client ID of your user-assigned identity.

Set the `APPLICATIONINSIGHTS_AUTHENTICATION_STRING` environment variable using this string.

* **In Unix/Linux:**

    ```shell
    export APPLICATIONINSIGHTS_AUTHENTICATION_STRING="Authorization=AAD"
    ```

* **In Windows:**

    ```shell
    set APPLICATIONINSIGHTS_AUTHENTICATION_STRING="Authorization=AAD"
    ```

After setting it, restart your application. It now sends telemetry to Application Insights using Microsoft Entra authentication.

### Manual configuration

> [!NOTE]
> * For more information about migrating from the `2.X` SDK to the `3.X` Java agent, see [Upgrading from Application Insights Java 2.x SDK](java-standalone-upgrade-from-2x.md).
> * For more information about Java, see the [Java supplemental documentation](java-standalone-config.md).

**System-assigned managed identity:**

The following example shows how to configure the Java agent to use system-assigned managed identity for authentication with Microsoft Entra ID.

```JSON
{
  "connectionString": "App Insights Connection String with IngestionEndpoint",
  "authentication": {
    "enabled": true,
    "type": "SAMI"
  }
}
```

**User-assigned managed identity:**

The following example shows how to configure the Java agent to use user-assigned managed identity for authentication with Microsoft Entra ID.

```JSON
{
  "connectionString": "App Insights Connection String with IngestionEndpoint",
  "authentication": {
    "enabled": true,
    "type": "UAMI",
    "clientId":"<USER-ASSIGNED MANAGED IDENTITY CLIENT ID>"
  }
}
```

:::image type="content" source="media/azure-ad-authentication/user-assigned-managed-identity.png" alt-text="Screenshot that shows user-assigned managed identity." lightbox="media/azure-ad-authentication/user-assigned-managed-identity.png":::

# [Java native](#tab/java-native)

Microsoft Entra ID authentication isn't available for GraalVM Native applications.

# [Node.js](#tab/nodejs)

> [!NOTE]
> * Support for Microsoft Entra ID in the Application Insights Node.JS is included starting with [version 2.1.0-beta.1](https://www.npmjs.com/package/applicationinsights/v/2.1.0-beta.1).
>
> * The SDK supports the credential classes provided by [Azure Identity](https://github.com/Azure/azure-sdk-for-js/tree/main/sdk/identity/identity#credential-classes).

### Prerequisites

* Use `DefaultAzureCredential` for local development.

* Use `ManagedIdentityCredential` for system-assigned and user-assigned managed identities.

    * For system-assigned, use the default constructor without parameters.
    * For user-assigned, provide the client ID to the constructor.

* Use `ClientSecretCredential` for service principals.

    * Provide the tenant ID, client ID, and client secret to the constructor.

### Environment variable configuration

Use the `APPLICATIONINSIGHTS_AUTHENTICATION_STRING` environment variable to let Application Insights authenticate to Microsoft Entra ID and send telemetry when using [Azure App Service monitoring without code changes](./codeless-app-service.md).

* For system-assigned identity:

| App setting                               | Value               |
|-------------------------------------------|---------------------|
| APPLICATIONINSIGHTS_AUTHENTICATION_STRING | `Authorization=AAD` |

* For user-assigned identity:

| App setting                               | Value                                                                  |
|-------------------------------------------|------------------------------------------------------------------------|
| APPLICATIONINSIGHTS_AUTHENTICATION_STRING | `Authorization=AAD;ClientId={Client id of the User-Assigned Identity}` |

### Manual configuration

The following sample applies when using @azure/monitor-opentelemetry:

```typescript
// Import the useAzureMonitor function, the AzureMonitorOpenTelemetryOptions class, and the ManagedIdentityCredential class from the @azure/monitor-opentelemetry and @azure/identity packages, respectively.
const { useAzureMonitor, AzureMonitorOpenTelemetryOptions } = require("@azure/monitor-opentelemetry");
const { ManagedIdentityCredential } = require("@azure/identity");

// Create a new ManagedIdentityCredential object.
const credential = new ManagedIdentityCredential();

// Create a new AzureMonitorOpenTelemetryOptions object and set the credential property to the credential object.
const options: AzureMonitorOpenTelemetryOptions = {
    azureMonitorExporterOptions: {
        connectionString:
            process.env["APPLICATIONINSIGHTS_CONNECTION_STRING"] || "<your connection string>",
        credential: credential
    }
};

// Enable Azure Monitor integration using the useAzureMonitor function and the AzureMonitorOpenTelemetryOptions object.
useAzureMonitor(options);
```

The following sample applies when using `applicationinsights` npm package.

```typescript
// Import the applicationinsights module and the DefaultAzureCredential class from the @azure/identity package.
const appInsights = require("applicationinsights");
const { DefaultAzureCredential } = require("@azure/identity");

// Create a new DefaultAzureCredential object to authenticate with Azure Active Directory.
const credential = new DefaultAzureCredential();

// Set up Application Insights with a connection string, then start the Application Insights client.
appInsights.setup("InstrumentationKey=00000000-0000-0000-0000-000000000000;IngestionEndpoint=https://xxxx.applicationinsights.azure.com/").start();

// Assign the DefaultAzureCredential object to the aadTokenCredential property of the default Application Insights client configuration for authentication.
appInsights.defaultClient.config.aadTokenCredential = credential;
```

# [Python](#tab/python)

> [!NOTE]
> * The SDK supports the credential classes provided by [Azure Identity](https://github.com/Azure/azure-sdk-for-net/tree/main/sdk/identity/Azure.Identity#credential-classes).
>
> * We provide information on configuring OpenCensus (retired) separately. See [Configure and enable Microsoft Entra ID-based authentication](/previous-versions/azure/azure-monitor/app/opencensus-python#configure-and-enable-microsoft-entra-id-based-authentication).

### Prerequisites

* Use `DefaultAzureCredential` for local development.

* Use `ManagedIdentityCredential` for system-assigned and user-assigned managed identities.

    * For system-assigned, use the default constructor without parameters.
    * For user-assigned, provide the `client_id` to the constructor.

* Use `ClientSecretCredential` for service principals.

    * Provide the tenant ID, client ID, and client secret to the constructor.

### Configuration guidance

* If you're using `ManagedIdentityCredential`:

    ```python
    # Import the `ManagedIdentityCredential` class from the `azure.identity` package.
    from azure.identity import ManagedIdentityCredential
    # Import the `configure_azure_monitor()` function from the `azure.monitor.opentelemetry` package.
    from azure.monitor.opentelemetry import configure_azure_monitor
    from opentelemetry import trace

    # Configure the Distro to authenticate with Azure Monitor using a managed identity credential.
    credential = ManagedIdentityCredential(client_id="<client_id>")
    configure_azure_monitor(
        connection_string="your-connection-string",
        credential=credential,
    )

    tracer = trace.get_tracer(__name__)

    with tracer.start_as_current_span("hello with aad managed identity"):
        print("Hello, World!")
    ```

* If you're using `ClientSecretCredential`:

    ```python
    # Import the `ClientSecretCredential` class from the `azure.identity` package.
    from azure.identity import ClientSecretCredential
    # Import the `configure_azure_monitor()` function from the `azure.monitor.opentelemetry` package.
    from azure.monitor.opentelemetry import configure_azure_monitor
    from opentelemetry import trace

    # Configure the Distro to authenticate with Azure Monitor using a client secret credential.
    credential = ClientSecretCredential(
        tenant_id="<tenant_id",
        client_id="<client_id>",
        client_secret="<client_secret>",
    )
    configure_azure_monitor(
        connection_string="your-connection-string",
        credential=credential,
    )

    with tracer.start_as_current_span("hello with aad client secret identity"):
        print("Hello, World!")
    ```

---

## Query Application Insights by using Microsoft Entra authentication

You can submit a query request by using the Azure Monitor Application Insights endpoint `https://api.applicationinsights.io`. To access the endpoint, you must authenticate through Microsoft Entra ID.

### Set up authentication

To access the API, register a client app with Microsoft Entra ID and request a token.

1. [Register an app in Microsoft Entra ID](../logs/api/register-app-for-token.md).

1. On the app's overview page, select **API permissions**.
1. Select **Add a permission**.
1. On the **APIs my organization uses** tab, search for **Application Insights** and select **Application Insights API** from the list.

1. Select **Delegated permissions**.
1. Select the **Data.Read** checkbox.
1. Select **Add permissions**.

After you register your app and grant it permissions to use the API, grant your app access to your Application Insights resource.

1. From your **Application Insights resource** overview page, select **Access control (IAM)**.
1. Select **Add role assignment**.

1. Select the **Reader** role and then select **Members**.

1. On the **Members** tab, choose **Select members**.
1. Enter the name of your app in the **Select** box.
1. Select your app and choose **Select**.
1. Select **Review + assign**.

1. After you finish the Active Directory setup and permissions, request an authorization token.

>[!NOTE]
> For this example, use the Reader role. This role is one of many built-in roles and might include more permissions than you require. You can create more granular roles and permissions.

### Request an authorization token

Before you begin, make sure you have all the values required to make the request successfully. All requests require:

* Your Microsoft Entra tenant ID.
* Your App Insights App ID - If you're currently using API Keys, it's the same app ID.
* Your Microsoft Entra client ID for the app.
* A Microsoft Entra client secret for the app.

The Application Insights API supports Microsoft Entra authentication with three different [Microsoft Entra ID OAuth2](/azure/active-directory/develop/active-directory-protocols-oauth-code) flows:

* Client credentials
* Authorization code
* Implicit

#### Client credentials flow

In the client credentials flow, use the token with the Application Insights endpoint. Make a single request to receive a token by using the credentials you provide for your app when you [register an app in Microsoft Entra ID](../logs/api/register-app-for-token.md).

Use the `https://api.applicationinsights.io` endpoint.

##### Client credentials token URL (POST request)

```http
POST /{TenantId}/oauth2/token
Host: https://login.microsoftonline.com
Content-Type: application/x-www-form-urlencoded

grant_type=client_credentials
&client_id=<ClientId>
&resource=https://api.applicationinsights.io
&client_secret=<ClientSecret>
```

A successful request receives an access token in the response:

```json
{
  "token_type": "Bearer",
  "expires_in": "86399",
  "ext_expires_in": "86399",
  "access_token": "eyJ0eXAiOiJKV1QiLCJ.....Ax"
}
```

Use the token in requests to the Application Insights endpoint:

```http
POST /v1/apps/{AppId}/query?timespan=P1D
Host: https://api.applicationinsights.io
Authorization: Bearer {AccessToken}
Content-Type: application/json

{
  "query": "requests | take 10"
}
```

**Response example:**

```json
{
  "tables": [
    {
      "name": "PrimaryResult",
      "columns": [
        {
          "name": "timestamp",
          "type": "datetime"
        },
        {
          "name": "id",
          "type": "string"
        },
        {
          "name": "source",
          "type": "string"
        },
        {
          "name": "name",
          "type": "string"
        },
        {
          "name": "url",
          "type": "string"
        },
        {
          "name": "success",
          "type": "string"
        },
        {
          "name": "resultCode",
          "type": "string"
        },
        {
          "name": "duration",
          "type": "real"
        },
        {
          "name": "performanceBucket",
          "type": "string"
        },
        {
          "name": "customDimensions",
          "type": "dynamic"
        },
        {
          "name": "customMeasurements",
          "type": "dynamic"
        },
        {
          "name": "operation_Name",
          "type": "string"
        },
        {
          "name": "operation_Id",
          "type": "string"
        },
        {
          "name": "operation_ParentId",
          "type": "string"
        },
        {
          "name": "operation_SyntheticSource",
          "type": "string"
        },
        {
          "name": "session_Id",
          "type": "string"
        },
        {
          "name": "user_Id",
          "type": "string"
        },
        {
          "name": "user_AuthenticatedId",
          "type": "string"
        },
        {
          "name": "user_AccountId",
          "type": "string"
        },
        {
          "name": "application_Version",
          "type": "string"
        },
        {
          "name": "client_Type",
          "type": "string"
        },
        {
          "name": "client_Model",
          "type": "string"
        },
        {
          "name": "client_OS",
          "type": "string"
        },
        {
          "name": "client_IP",
          "type": "string"
        },
        {
          "name": "client_City",
          "type": "string"
        },
        {
          "name": "client_StateOrProvince",
          "type": "string"
        },
        {
          "name": "client_CountryOrRegion",
          "type": "string"
        },
        {
          "name": "client_Browser",
          "type": "string"
        },
        {
          "name": "cloud_RoleName",
          "type": "string"
        },
        {
          "name": "cloud_RoleInstance",
          "type": "string"
        },
        {
          "name": "appId",
          "type": "string"
        },
        {
          "name": "appName",
          "type": "string"
        },
        {
          "name": "iKey",
          "type": "string"
        },
        {
          "name": "sdkVersion",
          "type": "string"
        },
        {
          "name": "itemId",
          "type": "string"
        },
        {
          "name": "itemType",
          "type": "string"
        },
        {
          "name": "itemCount",
          "type": "int"
        }
      ],
      "rows": [
        [
          "2018-02-01T17:33:09.788Z",
          "|0qRud6jz3k0=.c32c2659_",
          null,
          "GET Reports/Index",
          "http://fabrikamfiberapp.azurewebsites.net/Reports",
          "True",
          "200",
          "3.3833",
          "<250ms",
          "{\"_MS.ProcessedByMetricExtractors\":\"(Name:'Requests', Ver:'1.0')\"}",
          null,
          "GET Reports/Index",
          "0qRud6jz3k0=",
          "0qRud6jz3k0=",
          "Application Insights Availability Monitoring",
          "aaaaaaaa-0000-1111-2222-bbbbbbbbbbbb",
          "us-va-ash-azr_aaaaaaaa-0000-1111-2222-bbbbbbbbbbbb",
          null,
          null,
          "AutoGen_49c3aea0-4641-4675-93b5-55f7a62d22d3",
          "PC",
          null,
          null,
          "52.168.8.0",
          "Boydton",
          "Virginia",
          "United States",
          null,
          "fabrikamfiberapp",
          "RD00155D5053D1",
          "bbbbbbbb-1111-2222-3333-cccccccccccc",
          "fabrikamprod",
          "cccccccc-2222-3333-4444-dddddddddddd",
          "web:2.5.0-33031",
          "dddddddd-3333-4444-5555-eeeeeeeeeeee",
          "request",
          "1"
        ],
        [
          "2018-02-01T17:33:15.786Z",
          "|x/Ysh+M1TfU=.c32c265a_",
          null,
          "GET Home/Index",
          "http://fabrikamfiberapp.azurewebsites.net/",
          "True",
          "200",
          "716.2912",
          "500ms-1sec",
          "{\"_MS.ProcessedByMetricExtractors\":\"(Name:'Requests', Ver:'1.0')\"}",
          null,
          "GET Home/Index",
          "x/Ysh+M1TfU=",
          "x/Ysh+M1TfU=",
          "Application Insights Availability Monitoring",
          "eeeeeeee-4444-5555-6666-ffffffffffff",
          "emea-se-sto-edge_eeeeeeee-4444-5555-6666-ffffffffffff",
          null,
          null,
          "AutoGen_49c3aea0-4641-4675-93b5-55f7a62d22d3",
          "PC",
          null,
          null,
          "51.141.32.0",
          "Cardiff",
          "Cardiff",
          "United Kingdom",
          null,
          "fabrikamfiberapp",
          "RD00155D5053D1",
          "bbbbbbbb-1111-2222-3333-cccccccccccc",
          "fabrikamprod",
          "cccccccc-2222-3333-4444-dddddddddddd",
          "web:2.5.0-33031",
          "ffffffff-5555-6666-7777-aaaaaaaaaaaa",
          "request",
          "1"
        ]
      ]
    }
  ]
}
```

#### Authorization code flow

The main OAuth2 flow supported is through [authorization codes](/azure/active-directory/develop/active-directory-protocols-oauth-code). This method requires two HTTP requests to acquire a token with which to call the Azure Monitor Application Insights API. There are two URLs, with one endpoint per request. The following sections describe their formats.

##### Authorization code URL (GET request)

```http
GET https://login.microsoftonline.com/{TenantId}/oauth2/authorize?
client_id=<ClientId>
&response_type=code
&redirect_uri=<RedirectUri>
&resource=https://api.applicationinsights.io
```

When you make a request to the authorized URL, the `client\_id` is the application ID from your Microsoft Entra app, copied from the app's properties menu. The `redirect\_uri` is the `homepage/login` URL from the same Microsoft Entra app. When a request is successful, this endpoint redirects you to the sign-in page you provided at sign-up with the authorization code appended to the URL. See the following example:

```http
http://<RedirectUri>/?code=<AuthorizationCode>&session_state=<SessionState>
```

At this point, you obtain an authorization code, which you now use to request an access token.

##### Authorization code token URL (POST request)

```http
POST /{TenantId}/oauth2/token HTTP/1.1
Host: https://login.microsoftonline.com
Content-Type: application/x-www-form-urlencoded

grant_type=authorization_code
&client_id=<ClientId>
&code=<AuthorizationCode>
&redirect_uri=<RedirectUri>
&resource=https://api.applicationinsights.io
&client_secret=<ClientSecret>
```

All values are the same as before, with some additions. The authorization code is the same code you received in the previous request after a successful redirect. Combine the code with the key obtained from the Microsoft Entra app. If you didn't save the key, you can delete it and create a new one from the keys tab of the Microsoft Entra app menu. The response is a JSON string that contains the token with the following schema. Types are indicated for the token values.

**Response example:**

```json
{
  "access_token": "eyJ0eXAiOiJKV1QiLCJ.....Ax",
  "expires_in": "3600",
  "ext_expires_in": "1503641912",
  "id_token": "not_needed_for_app_insights",
  "not_before": "1503638012",
  "refresh_token": "eyJ0esdfiJKV1ljhgYF.....Az",
  "resource": "https://api.applicationinsights.io",
  "scope": "Data.Read",
  "token_type": "bearer"
}
```

The access token portion of this response is what you present to the Application Insights API in the `Authorization: Bearer` header. You can also use the refresh token in the future to acquire a new access\_token and refresh\_token when yours go stale. For this request, the format and endpoint are:

```http
POST /{TenantId}/oauth2/token HTTP/1.1
Host: https://login.microsoftonline.com
Content-Type: application/x-www-form-urlencoded

client_id=<ClientId>
&refresh_token=<RefreshToken>
&grant_type=refresh_token
&resource=https://api.applicationinsights.io
&client_secret=<ClientSecret>
```

**Response example:**

```json
{
  "token_type": "Bearer",
  "expires_in": "3600",
  "expires_on": "1460404526",
  "resource": "https://api.applicationinsights.io",
  "access_token": "eyJ0eXAiOiJKV1QiLCJ.....Ax",
  "refresh_token": "eyJ0esdfiJKV1ljhgYF.....Az"
}
```

#### Implicit code flow

The Application Insights API supports the OAuth2 [implicit flow](/azure/active-directory/develop/active-directory-dev-understanding-oauth2-implicit-grant). This flow requires only one request, but it doesn't provide a refresh token.

##### Implicit code authorization URL

```http
GET https://login.microsoftonline.com/{TenantId}/oauth2/authorize?
client_id=<ClientId>
&response_type=token
&redirect_uri=<RedirectUri>
&resource=https://api.applicationinsights.io
```

A successful request redirects to your redirect URI with the token in the URL:

```http
http://<RedirectUri>/#access_token=<AccessToken>&token_type=Bearer&expires_in=3600&session_state=<SessionState>
```

This access\_token acts as the `Authorization: Bearer` header value when you send it to the Application Insights API to authorize requests.

## Disable local authentication

After you enable Microsoft Entra authentication, you can disable local authentication. When you disable local authentication, you can ingest telemetry authenticated exclusively by Microsoft Entra ID. This configuration affects data access, such as through API keys.

You can disable local authentication by using the Azure portal, Azure Policy, or programmatically.

### Azure portal

1. From your Application Insights resource, select **Properties** under **Configure** in the menu on the left. Select **Enabled (click to change)** if the local authentication is enabled.

    :::image type="content" source="./media/azure-ad-authentication/enabled.png" alt-text="Screenshot that shows Properties under the Configure section and the Enabled/Disabled local authentication button.":::

1. Select **Disabled** and apply your changes.

    :::image type="content" source="./media/azure-ad-authentication/disable.png" alt-text="Screenshot that shows local authentication with the Enabled/Disabled button.":::

1. After disabling local authentication on your resource, you see the corresponding information in the **Overview** pane.

    :::image type="content" source="./media/azure-ad-authentication/overview.png" alt-text="Screenshot that shows the Overview tab with the Disabled (select to change) local authentication button.":::

### Azure Policy

Azure Policy for `DisableLocalAuth` denies users the ability to create a new Application Insights resource without this property set to `true`. The policy name is `Application Insights components should block non-Azure Active Directory based ingestion`.

To apply this policy definition to your subscription, [create a new policy assignment and assign the policy](/azure/governance/policy/assign-policy-portal).

The following example shows the policy template definition:

```json
{
  "properties": {
    "displayName": "Application Insights components should block non-Azure Active Directory based ingestion",
    "policyType": "BuiltIn",
    "mode": "Indexed",
    "description": "Improve Application Insights security by disabling log ingestion that are not AAD-based.",
    "metadata": {
      "version": "1.0.0",
      "category": "Monitoring"
    },
    "parameters": {
      "effect": {
        "type": "String",
        "metadata": {
          "displayName": "Effect",
          "description": "The effect determines what happens when the policy rule is evaluated to match"
        },
        "allowedValues": [
          "audit",
          "deny",
          "disabled"
        ],
        "defaultValue": "audit"
      }
    },
    "policyRule": {
      "if": {
        "allOf": [
          {
            "field": "type",
            "equals": "Microsoft.Insights/components"
          },
          {
            "field": "Microsoft.Insights/components/DisableLocalAuth",
            "notEquals": "true"
          }
        ]
      },
      "then": {
        "effect": "[parameters('effect')]"
      }
    }
  }
}
```

### Programmatic enablement

Use the `DisableLocalAuth` property to disable local authentication on your Application Insights resource. When you set this property to `true`, it enforces that Microsoft Entra authentication must be used for all access.

The following example shows the Azure Resource Manager template you can use to create a workspace-based Application Insights resource with `LocalAuth` disabled.

```json
{
  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "name": {
      "type": "string"
    },
    "type": {
      "type": "string"
    },
    "regionId": {
      "type": "string"
    },
    "tagsArray": {
      "type": "object"
    },
    "requestSource": {
      "type": "string"
    },
    "workspaceResourceId": {
      "type": "string"
    },
    "disableLocalAuth": {
      "type": "bool"
    }
  },
  "resources": [
    {
      "name": "[parameters('name')]",
      "type": "microsoft.insights/components",
      "location": "[parameters('regionId')]",
      "tags": "[parameters('tagsArray')]",
      "apiVersion": "2020-02-02-preview",
      "dependsOn": [],
      "properties": {
        "Application_Type": "[parameters('type')]",
        "Flow_Type": "Redfield",
        "Request_Source": "[parameters('requestSource')]",
        "WorkspaceResourceId": "[parameters('workspaceResourceId')]",
        "DisableLocalAuth": "[parameters('disableLocalAuth')]"
      }
    }
  ]
}
```

### Token audience

When developing a custom client to obtain an access token from Microsoft Entra ID for submitting telemetry to Application Insights, refer to the following table to determine the appropriate audience string for your particular host environment.

| Azure cloud version                        | Token audience value        |
|--------------------------------------------|-----------------------------|
| Azure public cloud                         | `https://monitor.azure.com` |
| Microsoft Azure operated by 21Vianet cloud | `https://monitor.azure.cn`  |
| Azure US Government cloud                  | `https://monitor.azure.us`  |

If you're using sovereign clouds, you can find the audience information in the connection string as well. The connection string follows this structure:

*InstrumentationKey={profile.InstrumentationKey};IngestionEndpoint={ingestionEndpoint};LiveEndpoint={liveDiagnosticsEndpoint};AADAudience={aadAudience}*

The audience parameter, AADAudience, can vary depending on your specific environment.

## Troubleshooting

For troubleshooting guidance, see [Troubleshoot Microsoft Entra authentication issues](/troubleshoot/azure/azure-monitor/app-insights/telemetry/investigate-missing-telemetry#troubleshoot-microsoft-entra-authentication-issues).

## Next steps

* [Monitor your telemetry in the Azure portal](overview-dashboard.md).
* [Diagnose with Live Metrics Stream](live-stream.md).
* [Query Application Insights using Microsoft Entra authentication](./app-insights-azure-ad-api.md).
