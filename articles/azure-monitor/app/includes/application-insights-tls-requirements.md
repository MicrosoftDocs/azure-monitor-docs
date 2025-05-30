---
ms.topic: include
ms.date: 03/31/2025
---

#### Supported TLS configurations

Application Insights uses Transport Layer Security (TLS) 1.2 and 1.3. In addition, the following Cipher suites and Elliptical curves are also supported within each version.

| Version | Cipher suites | Elliptical curves |
|---------|---------|---------|
| TLS 1.2 | • TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384<br>• TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256<br>• TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384<br>• TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256<br>• TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384<br>• TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256<br>• TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384<br>• TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256 | • NistP384<br>• NistP256 |
| TLS 1.3 | • TLS_AES_256_GCM_SHA384<br>• TLS_AES_128_GCM_SHA256 | • NistP384<br>• NistP256 |
