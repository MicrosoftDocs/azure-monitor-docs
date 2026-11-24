---
title: Secure access to Azure Monitor pipeline
description: Expose Azure Monitor pipeline receivers through a Kubernetes gateway and protect TCP ingestion with TLS or mutual TLS.
ai-usage: ai-assisted
ms.topic: concept-article
ms.date: 11/23/2026
---

# Secure access to Azure Monitor pipeline

Clients need a reachable pipeline listener and, for TCP ingestion, an appropriate transport-security configuration.

## Expose receivers

Pipeline services are cluster-internal by default. For clients outside the Arc-enabled Kubernetes cluster, [configure a Kubernetes gateway](./pipeline-kubernetes-gateway.md) and expose only the required receiver ports.

A gateway and the pipeline receiver are separate TLS hops. If the gateway terminates the client connection, configure and verify its client-facing TLS separately from the gateway-to-pipeline connection.

## Choose a TLS mode

| Mode | Protection |
|:---|:---|
| Mutual TLS (mTLS) | Encrypts traffic and authenticates both the server and client. |
| Server-only TLS | Encrypts traffic and authenticates the server. |
| Disabled | Sends unencrypted traffic. Use only on trusted networks. |

Store named TLS configurations in the pipeline settings DCR and select them from TCP endpoints. UDP traffic isn't protected by TLS.

- Start with [Azure Monitor pipeline TLS configuration](./pipeline-tls.md).
- Use [automated certificate management](./pipeline-tls-automated.md) for managed issuance and rotation.
- Use [customer-managed certificates](./pipeline-tls-custom.md) when certificates come from your own PKI.

The documented OTLP listener requires mTLS by default. OTel clients must trust the server CA and present a trusted client certificate.
