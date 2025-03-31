---
ms.topic: include
ms.date: 03/31/2025
---

## Supported TLS configurations

To provide best-in-class encryption, Application Insights uses Transport Layer Security (TLS) 1.2 and 1.3 as the encryption mechanisms of choice. In addition, the following Cipher suites and Elliptical curves are also supported within each version.

| Version | Cipher suites | Elliptical curves |
|---------|---------|---------|
| TLS 1.2 | • TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384<br>• TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256<br>• TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384<br>• TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256<br>• TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384<br>• TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256<br>• TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384<br>• TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256 | • NistP384<br>• NistP256 |
| TLS 1.3 | • TLS_AES_256_GCM_SHA384<br>• TLS_AES_128_GCM_SHA256 | • NistP384<br>• NistP256 |

### Deprecating TLS configuration

> [!IMPORTANT]
> To improve security, Azure retires the following TLS configurations for Application Insights on May 1, 2025. This change is part of the [Azure-wide legacy TLS retirement](https://azure.microsoft.com/updates/azure-support-tls-will-end-by-31-october-2024-2/):
>
> - TLS 1.0 and TLS 1.1 protocol versions  
> - Legacy TLS 1.2 and TLS 1.3 cipher suites  
> - Legacy TLS elliptical curves

#### TLS 1.0 and TLS 1.1

TLS 1.0 and TLS 1.1 are being retired.

#### TLS 1.2 and TLS 1.3

| Version | Cipher suites | Elliptical curves |
|---------|---------|---------|
| TLS 1.2 | • TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA<br>• TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA<br>• TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA<br>• TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA<br>• TLS_RSA_WITH_AES_256_GCM_SHA384<br>• TLS_RSA_WITH_AES_128_GCM_SHA256<br>• TLS_RSA_WITH_AES_256_CBC_SHA256<br>• TLS_RSA_WITH_AES_128_CBC_SHA256<br>• TLS_RSA_WITH_AES_256_CBC_SHA<br>• TLS_RSA_WITH_AES_128_CBC_SHA | • curve25519 |
| TLS 1.3 | | • curve25519 |