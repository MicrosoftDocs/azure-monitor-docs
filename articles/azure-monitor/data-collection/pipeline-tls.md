---
title: Azure Monitor pipeline TLS configuration
description: Secure data ingestion to Azure Monitor pipeline by configuring TLS.
ai-usage: ai-assisted
ms.topic: article
ms.date: 11/23/2026
ms.custom: references_regions, devx-track-azurecli
---

# Azure Monitor pipeline TLS configuration

Use this article to choose how to secure TCP-based ingestion for [Azure Monitor pipeline](./pipeline-overview.md). The pipeline supports TLS and mutual TLS (mTLS) for TCP-based receivers through two certificate management approaches:

- **Default TLS**: Automated certificate management with zero-downtime rotation, managed by the Certificate Manager extension.
- **Bring Your Own Certificates (BYOC)**: Customer-managed certificates and keys that you create with your own PKI for the Azure Monitor pipeline receiver TLS endpoint to use.

Choose one of the following approaches:

- Use automated certificate management with zero-downtime rotation.
- Provide your own server certificate and key.
- Provide your own CA for client certificate validation.

Use the following sections to choose the approach that fits your deployment.

## Prerequisites

See the prerequisites in [Configure Azure Monitor pipeline](./pipeline-configure.md#prerequisites) for details on the requirements for enabling and configuring the Azure Monitor pipeline.  
Additionally, add the following to your cluster:

- Access to `kubectl` and the Azure CLI for the Arc-enabled cluster context.
- For automated certificate management, the [cert-manager extension](/azure/azure-arc/kubernetes/cert-manager-overview) installed on the cluster.

## TLS modes

TLS controls encryption and client authentication on the pipeline's listening endpoints:

| Connection security | Description |
|:---|:---|
| Mutual TLS (mTLS) | Encrypts traffic and authenticates both the server and the client with certificates. |
| Server-only TLS | Encrypts traffic and authenticates the server without requiring a client certificate. |
| No TLS | Sends traffic without encryption or certificate authentication. |

In DCR mode, TCP receivers use the operator's default mTLS material unless a named TLS configuration overrides that behavior. Select a named mode explicitly when you need server-only TLS or unencrypted TCP. Configure clients to trust the server certificate's issuing CA. UDP traffic isn't protected by TLS; use UDP only on trusted networks.

For an existing legacy portal deployment, enable **transport security (TLS)** when you [manage the pipeline](./pipeline-configure-portal.md#review-basic-settings). To require client certificates, also enable **Require client authentication within cluster**.

## Store TLS configuration in the settings DCR

TLS is an instance-specific runtime setting. Store it in the `PipelineSettings` DCR alongside the listening endpoints, not in each dataflow DCR or in the extension's installation parameters.

1. Add a named entry to `properties.pipelineSettings.tlsConfigurations`. Set its `mode` to `serverOnly` or `mutualTls`. Omit certificate references to use the operator's automatically managed material, or supply your own certificate references as described in [Using your own certificate management](./pipeline-tls-custom.md).
1. Set `properties.pipelineSettings.endpoints[].networkingConfig.tlsConfiguration` to that entry's name on the TCP endpoint you want to secure.
1. Keep the dataflow DCR's endpoint routing pointed at that endpoint. Collection logic references the endpoint; it doesn't need its own copy of the TLS settings.
1. Associate the settings DCR and dataflow DCR with the same extension so that the instance receives both configurations.

Endpoints can select the same named TLS configuration or different configurations when they need different certificates or client-authentication requirements. Certificate material stays in Kubernetes Secrets or ConfigMaps in the pipeline namespace; the DCR stores references. Keep private keys in Secrets.

Use the [server-only TLS example](./pipeline-configure-cli.md#example-collect-syslog-over-tls) to configure encrypted Syslog collection, or the [mTLS settings DCR example](./pipeline-tls-custom.md#configure-pipeline) to also require client certificates. For the wider resource model and associations, see [Understand the configuration model](./pipeline-configure-cli.md#understand-the-configuration-model).

## Option 1: Default TLS (automated certificate management)

Use this option when you want the Certificate Manager extension to manage certificate issuance and rotation for you.

For more information about how to set up automated certificate management, see [TLS configuration - Using automated certificate management](./pipeline-tls-automated.md).

For example, use this `properties.pipelineSettings` object for Syslog with explicit default mTLS. It references a named configuration without embedding certificates:

```json
{
  "endpoints": [
    {
      "name": "syslog6514",
      "type": "syslog",
      "networkingConfig": {
        "endpoint": "0.0.0.0:6514",
        "transportProtocol": "tcp",
        "tlsConfiguration": "managed-mtls"
      }
    }
  ],
  "tlsConfigurations": [
    {
      "name": "managed-mtls",
      "mode": "mutualTls"
    }
  ]
}
```

The operator supplies the server certificate, matching private key, and client CA. Configure clients to trust the managed server CA and present a certificate from the managed client CA. See [Client certificate setup](./pipeline-tls-automated.md#step-3-create-client-certificate-for-mtls).

To use default server-only TLS, replace the configuration entry with the following and change the endpoint's `tlsConfiguration` to `managed-server-tls`. Clients still validate the server certificate, but don't present client certificates:

```json
{
  "name": "managed-server-tls",
  "mode": "serverOnly"
}
```

## Option 2: BYOC (Bring Your Own Certificates)

Use this option when you need to use your own certificates or integrate with your existing PKI. By using BYOC, you can:

- Replace the default collector server certificate with your own
- Provide your own CA for client certificate validation
- Integrate with Azure Key Vault for certificate storage

For more information about how this works and how to set up, see [TLS configuration - Using your own certificate management](./pipeline-tls-custom.md).

## Option 3: Disable TLS and mTLS

Disable TLS only on a trusted network where unencrypted ingestion meets your security requirements. Clear **Enable transport security (TLS)** when you configure the pipeline, and configure clients to use an unencrypted connection.

For ARM template configuration, use this `properties.pipelineSettings` object to explicitly disable TLS on a TCP listener. The disabled configuration contains no certificate references:

```json
{
  "endpoints": [
    {
      "name": "syslog514",
      "type": "syslog",
      "networkingConfig": {
        "endpoint": "0.0.0.0:514",
        "transportProtocol": "tcp",
        "tlsConfiguration": "unencrypted"
      }
    }
  ],
  "tlsConfigurations": [
    {
      "name": "unencrypted",
      "mode": "disabled"
    }
  ]
}
```

Private Link secures the pipeline-to-Azure Monitor connection, not client-to-pipeline traffic. It doesn't replace TLS on a listening endpoint.

## Connect directly or through a gateway

A client can connect directly to a reachable collector TLS endpoint when it trusts the issuing CA and the certificate covers the hostname it uses. For mTLS, it must also present a trusted client certificate. An external connection isn't required to use a gateway solely because it originates outside the cluster; reachability, certificate names, trust, and certificate rotation must all be handled.

The [gateway examples](./pipeline-kubernetes-gateway.md) configure TLS or mTLS on the gateway-to-collector connection. That protects the backend hop only. To encrypt the external client-to-gateway hop, configure client-facing TLS termination or TLS passthrough and the corresponding certificate and client-trust requirements. Don't treat backend TLS alone as end-to-end protection.

## Related articles

- Use the default certificate flow in [TLS configuration - Using automated certificate management](./pipeline-tls-automated.md).
- Use customer-managed certificates in [TLS configuration - Using your own certificate management](./pipeline-tls-custom.md).
- Expose secure receivers to external clients by using [Configure a Kubernetes gateway for Azure Monitor pipeline](./pipeline-kubernetes-gateway.md).
- Configure client connections in [Configure a Kubernetes gateway for Azure Monitor pipeline](./pipeline-kubernetes-gateway.md).
