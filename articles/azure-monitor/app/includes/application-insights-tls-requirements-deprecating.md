---
ms.topic: include
ms.date: 05/01/2025
---

#### Deprecating Transport Layer Security (TLS) configurations

> [!IMPORTANT]
> To improve security, Azure blocks the following TLS configurations for Application Insights on May 1, 2025. This change is part of the [Azure-wide legacy TLS retirement](https://azure.microsoft.com/updates/azure-support-tls-will-end-by-31-october-2024-2/):
>
> - TLS 1.0 and TLS 1.1 protocol versions  
> - Legacy TLS 1.2 and TLS 1.3 cipher suites  
> - Legacy TLS elliptical curves

#### TLS 1.0 and TLS 1.1

TLS 1.0 and TLS 1.1 are being retired.

#### TLS 1.2 and TLS 1.3

| Version | Cipher suites | Elliptical curves |
|---------|---------|---------|
| TLS 1.2 | * TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA<br>* TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA<br>* TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA<br>* TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA<br>* TLS_RSA_WITH_AES_256_GCM_SHA384<br>* TLS_RSA_WITH_AES_128_GCM_SHA256<br>* TLS_RSA_WITH_AES_256_CBC_SHA256<br>* TLS_RSA_WITH_AES_128_CBC_SHA256<br>* TLS_RSA_WITH_AES_256_CBC_SHA<br>* TLS_RSA_WITH_AES_128_CBC_SHA | * curve25519 |
| TLS 1.3 | | * curve25519 |
