---
title: Application Insights TLS Support
description: Application Insights TLS Support
ms.topic: conceptual
ms.date: 04/01/2025
ms.reviewer: cogoodson
---

# TLS Support in Application Insights

This article describes how Application Insights availability tests use Transport Layer Security (TLS) and what you need to know to stay compliant with Azure TLS support requirements.

## Supported TLS configurations

To provide best-in-class encryption, all availability tests use Transport Layer Security (TLS) 1.2 and 1.3 as the encryption mechanisms of choice. In addition, the following Cipher suites and Elliptical curves are also supported within each version.

TLS 1.3 is currently only available in the availability test regions NorthCentralUS, CentralUS, EastUS, SouthCentralUS, and WestUS.

| Version | Cipher suites | Elliptical curves |
|---------|---------|---------|
| TLS 1.2 | • TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384<br>• TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256<br>• TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384<br>• TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256<br>• TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384<br>• TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256<br>• TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384<br>• TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256 | • NistP384<br>• NistP256 |
| TLS 1.3 | • TLS_AES_256_GCM_SHA384<br>• TLS_AES_128_GCM_SHA256 | • NistP384<br>• NistP256 |

### Deprecating TLS configuration

> [!IMPORTANT]
> On 1 May 2025, in alignment with the [Azure wide legacy TLS retirement](https://azure.microsoft.com/updates/azure-support-tls-will-end-by-31-october-2024-2/), TLS 1.0/1.1 protocol versions and the listed TLS 1.2/1.3 legacy Cipher suites and Elliptical curves will be retired for Application Insights availability tests.

#### TLS 1.0 and TLS 1.1

TLS 1.0 and TLS 1.1 are being retired.

#### TLS 1.2 and TLS 1.3

| Version | Cipher suites | Elliptical curves |
|---------|---------|---------|
| TLS 1.2 | • TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA<br>• TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA<br>• TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA<br>• TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA<br>• TLS_RSA_WITH_AES_256_GCM_SHA384<br>• TLS_RSA_WITH_AES_128_GCM_SHA256<br>• TLS_RSA_WITH_AES_256_CBC_SHA256<br>• TLS_RSA_WITH_AES_128_CBC_SHA256<br>• TLS_RSA_WITH_AES_256_CBC_SHA<br>• TLS_RSA_WITH_AES_128_CBC_SHA | • curve25519 |
| TLS 1.3 | | • curve25519 |

## Troubleshooting

> [!WARNING]
> We have recently enabled TLS 1.3 in availability tests. If you're seeing new error messages as a result, ensure that clients running on Windows Server 2022 with TLS 1.3 enabled can connect to your endpoint. If you're unable to do this, you may consider temporarily disabling TLS 1.3 on your endpoint so that availability tests fall back to older TLS versions.
> 
> For additional information, check the  [troubleshooting article](/troubleshoot/azure/azure-monitor/app-insights/troubleshoot-availability).

## Frequently asked questions

This section provides answers to common questions.

#### How does this deprecation impact my web test behavior?

Availability tests act as a distributed client in each of the supported web test locations. Every time a web test is executed the availability test service attempts to reach out to the remote endpoint defined in the web test configuration. A TLS Client Hello message is sent which contains all the currently supported TLS configuration. If the remote endpoint shares a common TLS configuration with the availability test client, then the TLS handshake succeeds. Otherwise, the web test fails with a TLS handshake failure. 

#### How do I ensure my web test isn't impacted?

To avoid any impact, each remote endpoint (including dependent requests) your web test interacts with needs to support at least one combination of the same Protocol Version, Cipher Suite, and Elliptical Curve that availability test does. If the remote endpoint doesn't support the needed TLS configuration, it needs to be updated with support for some combination of the above-mentioned post-deprecation TLS configuration. These endpoints can be discovered through viewing the [Transaction Details](/azure/azure-monitor/app/availability-standard-tests#see-your-availability-test-results) of your web test (ideally for a successful web test execution). 

#### How do I validate what TLS configuration a remote endpoint supports?

There are several tools available to test what TLS configuration an endpoint supports. One way would be to follow the example detailed on this [page](/security/engineering/solving-tls1-problem#appendix-a-handshake-simulation). If your remote endpoint isn't available via the Public internet, you need to ensure you validate the TLS configuration supported on the remote endpoint from a machine that has access to call your endpoint. 

> [!NOTE]
> For steps to enable the needed TLS configuration on your web server, it's best to reach out to the team that owns the hosting platform your web server runs on if the process isn't known. 

#### After May 1, 2025, what will the web test behavior be for impacted tests?

There's no one exception type that all TLS handshake failures impacted by this deprecation would present themselves with. However, the most common exception your web test would start failing with would be `The request was aborted: Couldn't create SSL/TLS secure channel`. You should also be able to see any TLS related failures in the TLS Transport [Troubleshooting Step](/troubleshoot/azure/azure-monitor/app-insights/availability/diagnose-ping-test-failure) for the web test result that is potentially impacted. 

#### Can I view what TLS configuration is currently in use by my web test?

The TLS configuration negotiated during a web test execution can't be viewed. As long as the remote endpoint supports common TLS configuration with availability tests, no impact should be seen post-deprecation. 

#### Which components does the deprecation affect in the availability test service?

The TLS deprecation detailed in this document should only affect the availability test web test execution behavior after May 1, 2025. For more information about interacting with the availability test service for CRUD operations, see [Azure Resource Manager TLS Support](/azure/azure-resource-manager/management/tls-support). This resource provides more details on TLS support and deprecation timelines.

#### Where can I get TLS support?

For any general questions around the legacy TLS problem, see [Solving TLS problems](/security/engineering/solving-tls1-problem).

## Next steps

- TODO