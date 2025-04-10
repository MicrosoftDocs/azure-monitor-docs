---
ms.topic: include
ms.date: 03/31/2025
---

#### Determine if TLS retirement affects you

Application Insights and Azure Monitor don't control the TLS version used for HTTPS connections. The TLS version depends on the operating system and runtime environment where your application runs.

To confirm the TLS version in use:

- Review the documentation for your operating system and runtime or framework.
- Contact the appropriate support team if you need further help. Don't open a support request with Application Insights.

**Runtime examples:**

- **.NET / .NET Core**: Applications targeting .NET Framework 4.6.2 or later, or .NET Core, use TLS 1.2+ by default. Older versions require explicit configuration using `ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12`.
- **Java**: Applications must run on Java 8u161 or newer. Use `System.setProperty("https.protocols", "TLSv1.2");` to enforce TLS 1.2.
- **Python**: Use a Python distribution built with OpenSSL 1.0.1 or newer. Enforce TLS 1.2 with `ssl.SSLContext(ssl.PROTOCOL_TLSv1_2)`.
- **Node.js**: Use Node.js version 10 or later. Check the OpenSSL version with `process.versions.openssl` and enforce TLS 1.2 in HTTPS request configurations.

#### How do I ensure my resources aren't affected?

To avoid service disruptions, each remote endpoint (including dependent requests) your resource interacts with needs to support at least one combination of the same Protocol Version, Cipher Suite, and Elliptical Curve mentioned earlier. If the remote endpoint doesn't support the needed TLS configuration, it needs to be updated with support for some combination of the above-mentioned post-deprecation TLS configuration.

#### After May 1, 2025, what is the behavior for affected resources?

Affected Application Insights resources stop ingesting data and can't access required application components. As a result, some features stop working.

#### Which components does the deprecation affect?

The Transport Layer Security (TLS) deprecation detailed in this document should only affect the behavior after May 1, 2025. For more information about CRUD operations, see [Azure Resource Manager TLS Support](/azure/azure-resource-manager/management/tls-support). This resource provides more details on TLS support and deprecation timelines.

#### Where can I get Transport Layer Security (TLS) support?

For any general questions around the legacy TLS problem, see [Solving TLS problems](/security/engineering/solving-tls1-problem).