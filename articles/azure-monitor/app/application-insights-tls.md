---
title: Application Insights TLS Support
description: Application Insights TLS Support
ms.topic: conceptual
ms.date: 04/01/2025
ms.reviewer: cogoodson
---

# TLS Support in Application Insights

This article describes how Application Insights uses Transport Layer Security (TLS) and what you need to know to stay compliant with Azure TLS support requirements.

## Supported TLS configurations

To provide best-in-class encryption, Application Insights uses Transport Layer Security (TLS) 1.2 and 1.3 as the encryption mechanisms of choice. In addition, the following Cipher suites and Elliptical curves are also supported within each version.

| Version | Cipher suites | Elliptical curves |
|---------|---------|---------|
| TLS 1.2 | • TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384<br>• TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256<br>• TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384<br>• TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256<br>• TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384<br>• TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256<br>• TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384<br>• TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256 | • NistP384<br>• NistP256 |
| TLS 1.3 | • TLS_AES_256_GCM_SHA384<br>• TLS_AES_128_GCM_SHA256 | • NistP384<br>• NistP256 |

### Deprecating TLS configuration

> [!IMPORTANT]
> On 1 May 2025, in alignment with the [Azure wide legacy TLS retirement](https://azure.microsoft.com/updates/azure-support-tls-will-end-by-31-october-2024-2/), TLS 1.0/1.1 protocol versions and the listed TLS 1.2/1.3 legacy Cipher suites and Elliptical curves will be retired for Application Insights.

#### TLS 1.0 and TLS 1.1

TLS 1.0 and TLS 1.1 are being retired.

#### TLS 1.2 and TLS 1.3

| Version | Cipher suites | Elliptical curves |
|---------|---------|---------|
| TLS 1.2 | • TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA<br>• TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA<br>• TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA<br>• TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA<br>• TLS_RSA_WITH_AES_256_GCM_SHA384<br>• TLS_RSA_WITH_AES_128_GCM_SHA256<br>• TLS_RSA_WITH_AES_256_CBC_SHA256<br>• TLS_RSA_WITH_AES_128_CBC_SHA256<br>• TLS_RSA_WITH_AES_256_CBC_SHA<br>• TLS_RSA_WITH_AES_128_CBC_SHA | • curve25519 |
| TLS 1.3 | | • curve25519 |


## Frequently asked questions

This section provides answers to common questions.

#### How do I ensure my resources are not impacted?

To avoid any impact, each remote endpoint (including dependent requests) your resource interacts with needs to support at least one combination of the same Protocol Version, Cipher Suite, and Elliptical Curve listed above. If the remote endpoint doesn't support the needed TLS configuration, it needs to be updated with support for some combination of the above-mentioned post-deprecation TLS configuration.

#### After May 1, 2025, what will the behavior be for impacted resources?

You may notice some features in Application Insights start to fail as data is no longer ingested or application components cannot be accessed.

#### Which components does the deprecation affect?

The TLS deprecation detailed in this document should only affect the behavior after May 1, 2025. For more information about CRUD operations, see [Azure Resource Manager TLS Support](/azure/azure-resource-manager/management/tls-support). This resource provides more details on TLS support and deprecation timelines.

#### Where can I get TLS support?

For any general questions around the legacy TLS problem, see [Solving TLS problems](/security/engineering/solving-tls1-problem).

## Next steps

- TODO