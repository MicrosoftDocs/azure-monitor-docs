---
title: Azure Monitor pipeline TLS configuration
description: Secure the connection from your Azure Monitor pipeline to Azure Monitor by configuring TLS.
ms.topic: article
ms.date: 01/15/2026
ms.custom: references_regions, devx-track-azurecli
---

# Azure Monitor pipeline TLS configuration (preview)

The [Azure Monitor pipeline](./pipeline-overview.md) extends the data collection capabilities of Azure Monitor to your local data center and multicloud environments. Azure Monitor pipeline supports both TLS and mutual TLS (mTLS) for TCP‑based receivers through two certificate management approaches:

- **Default TLS**: Automated certificate management with zero-downtime rotation, managed by the Certificate Manager extension
- **Bring Your Own Certificates (BYOC)**: Customer-managed certificates and keys created by users with their own PKI that the Azure Monitor receiver TLS endpoint should use

With these options, you can:

- Use automated certificate management for simplified operations and zero-downtime rotation
- Provide your own keys and certificates that the Azure Monitor receiver TLS endpoint should use
- Configure TLS with your own CA cert and PKI that Azure Monitor should provision certs from for its receiver TLS endpoint

This article describes how to secure the connection between your pipeline and clients using TLS. You can use the default automated certificate management or use your existing PKI to issue and manage certificates to automate certificate issuance and renewal.

## TLS Modes

The Azure Monitor pipeline supports three TLS modes:

- **mutualTls** (default): Full mTLS with both server and client certificate authentication
- **serverOnly**: TLS encryption without client certificate validation
- **disabled**: Plain text communication

## Prerequisites

- Arc-enabled Kubernetes cluster with Azure Monitor pipeline installed.
- `kubectl` and `az access` to the Arc‑enabled cluster context.

## Install cert-manager for Arc-enabled Kubernetes

This section describes how to install cert-manager as an Azure Arc extension. Installing cert-manager is required for both Default TLS and BYOC certificate management.

> [!NOTE]
>
> Supported Kubernetes distributions for cert‑manager extension on Arc-enabled Kubernetes include the following.
>
> - VMware Tanzu Kubernetes Grid multicloud (TKGm) v1.28.11
> - SUSE Rancher K3s v1.33.3+k3s1
> - AKS Arc v1.32.7

Installing cert-manager as a cluster managed extension (CME) will register the `cert-manager` and `trust-manager` services on your cluster.

Remove any existing instances of `cert‑manager` and `trust‑manager` from the cluster. Any open source versions must be removed before installing the Microsoft version.

> [!WARNING]
> Between uninstalling the open source version and installing the Arc extension, certificate rotation won't occur, and trust bundles won't be distributed to the new namespaces. Ensure this period is as short as possible to minimize potential security risks. Uninstalling the open source cert-manager and trust-manager doesn't remove any existing certificates or related resources you created. These will remain usable once the Azure cert-manager is installed.

The specific steps for removal will depend on your installation method. See [Uninstalling cert-manager](https://cert-manager.io/docs/installation/uninstall/) and [Uninstalling trust-manager](https://cert-manager.io/docs/trust/trust-manager/installation/#uninstalling) for detailed guidance. If you used Helm for installation, use the following command to check which namespace cert-manager and trust-manager installed using this command.

`helm list -A | grep -E 'trust-manager|cert-manager'`

If you have an existing cert-manager extension installed, uninstall it using the following commands:

```azurecli
export RESOURCE_GROUP="<resource-group-name>"
export CLUSTER_NAME="<arc-enabled-cluster-name>"
export LOCATION="<arc-enabled-cluster-location"

NAME_OF_OLD_EXTENSION=$(az k8s-extension list --resource-group ${RESOURCE_GROUP} --cluster-name ${CLUSTER_NAME})
az k8s-extension delete --name ${NAME_OF_OLD_EXTENSION} --cluster-name ${CLUSTER_NAME} \
  --resource-group ${RESOURCE_GROUP} --cluster-type connectedClusters
```

Use the following command to connect your cluster to Arc if it wasn't already connected.

```azurecli
az connectedk8s connect --name ${CLUSTER_NAME} --resource-group ${RESOURCE_GROUP} --location ${LOCATION}
```

Install the cert‑manager extension using the following command:

```azurecli
az k8s-extension create \
  --resource-group ${RESOURCE_GROUP} \
  --cluster-name ${CLUSTER_NAME} \
  --cluster-type connectedClusters \
  --name "azure-cert-management" \
  --extension-type "microsoft.certmanagement" \
  --release-train stable
```

## Option 1: Default TLS (automated certificate management)

The Certificate Manager extension provides automated certificate lifecycle management with zero-downtime rotation. This means certificates are automatically renewed and rotated without any service interruption or manual intervention.

### How automated certificate management works

The automated certificate management includes:

- **Server Certificates**: Unique TLS certificates for each collector service
- **Client CA Certificates**: Client CA Certificates for mTLS authentication
- **Cluster Issuer for client certificates**: Use cluster issuer `arc-amp-client-root-ca-cluster-issuer` to issue client certificates for mTLS
- **Trust Bundles**: Automatically distributed CA certificates for validation
- **Zero-Downtime Rotation**: Certificates are renewed seamlessly without service interruption

### Certificate lifecycle

Following are the details of the lifecycle for server and client certificates:

**Server leaf Certificates:**

- Duration: 48 hours (2 days)
- Automatic renewal 24 hours before expiration
- Managed automatically by the pipeline operator

**Client Certificates:**

Client certificate lifetimes are controlled by clients, but must meet zero-downtime rotation constraints. The certificate must renew within 2 days.

Recommended configurations:
- `duration: 48h` and `renewBefore: 24h` 
- `duration: 72h` and `renewBefore: 25h` 
- `duration: 24h` and `renewBefore: 12h`

> [!NOTE]
> Client certificates generated using this option should only be used for intra-cluster communication with the pipeline—that is, by clients running within the same Kubernetes cluster. Do NOT use these certificates for clients connecting from outside the cluster. External clients should instead connect through a gateway (see [Setup Gateway for Azure Monitor Pipeline](#setup-gateway-for-azure-monitor-pipeline)).

> [!WARNING]
> Client certificates that don't renew within 2 days may become invalid when the CA rotates. Always set `renewBefore` to ensure renewal happens before the CA enters its next incubation period.

### Using automated certificate management

When you deploy a pipeline group with default settings, the operator automatically:

- Creates unique TLS certificates for each collector service
- Configures collectors to use managed server certificates
- Distributes trust bundles containing server or client CA certificates to labeled namespaces. It's the responsibility of the user to label the client namespace so the server CA certificate configmap is available in the client namespace.
- Enables mTLS with automatic certificate rotation

#### Step 1: Deploy pipeline group

Deploy a pipeline group with default TLS settings (mTLS enabled). No tlsConfigurations needed for default mTLS behavior.

#### Step 2: Get server CA certificate for client validation

Clients need the server CA certificate to validate the collector's TLS certificate. The pipeline operator automatically distributes CA certificates via trust bundles.

Label your client namespace to receive the server trust bundle:

```bash
kubectl label namespace <client-namespace> arc-amp-trust-bundle=true
```

Extract the server CA certificate:

```bash
# Get the server CA certificate from the trust bundle
kubectl get configmap arc-amp-trust-bundle \
      -n <client-namespace> \
      -o jsonpath='{.data.ca\.crt}' > server-ca.pem
```

The trust bundle is automatically updated during certificate rotation, ensuring clients always have valid CA certificates to validate server connections.

#### Step 3: Create Client Certificate for mTLS

For mutual TLS authentication, intra-cluster clients need their own certificates issued by the managed client CA.

> [!NOTE]
>
> The `arc-amp-client-root-ca-cluster-issuer` ClusterIssuer should only be used to issue client certificates for intra-cluster clients. Do NOT use certificates issued by this ClusterIssuer for clients connecting from outside the cluster. External clients should instead connect through a gateway (see [Setup Gateway for Azure Monitor Pipeline](#setup-gateway-for-azure-monitor-pipeline)).

Create a certificate resource in your namespace with values that meet zero-downtime rotation constraints:

Save the following YAML to a file named `client-certificate.yaml`:

```yml
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: my-client-certificate
  namespace: <client-namespace>
spec:
  secretName: my-client-tls
  issuerRef:
    name: arc-amp-client-root-ca-cluster-issuer
    kind: ClusterIssuer
    group: cert-manager.io
  commonName: my-client
  usages:
    - client auth
  duration: 48h      # Must renew within 2 days to meet rotation constraints
  renewBefore: 24h   # Renews at 24 hours, well before CA rotation
  privateKey:
    algorithm: ECDSA
    size: 256
```

Apply the certificate:

```bash
kubectl apply -f client-certificate.yaml
```

Wait for cert-manager to issue the certificate (usually within seconds):

```bash
kubectl get certificate my-client-certificate -n <client-namespace> -w
```

#### Step 4: Extract Client Certificate and Key

Once the certificate is issued, extract the client certificate and private key:

```bash
# Extract client certificate
kubectl get secret my-client-tls -n <client-namespace> \
  -o jsonpath='{.data.tls\.crt}' | base64 -d > client-cert.pem

# Extract client private key
kubectl get secret my-client-tls -n <client-namespace> \
  -o jsonpath='{.data.tls\.key}' | base64 -d > client-key.pem
```

#### Step 5: Connect with mTLS

Use the extracted certificates to establish an mTLS connection.

**Service DNS Names:**

The pipeline service is accessible via these DNS names (from most to least specific):

- `<pipeline-name>-service.<namespace>.svc.cluster.local` (fully qualified)
- `<pipeline-name>-service.<namespace>.svc` (cross-namespace)
- `<pipeline-name>-service.<namespace>` (namespace-qualified)
- `<pipeline-name>-service` (within same namespace)

## Option 2: BYOC (Bring Your Own Certificates)

Customers can provide their own certificates to meet compliance, security, and custom PKI requirements. With BYOC, you can:

- Replace the default collector server certificate with your own
- Provide your own CA for client certificate validation
- Integrate with Azure Key Vault for certificate storage

### Configure cert-manager with external PKI

The following example uses LetsEncrypt, but you can use any supported external PKI.

#### Create issuer resource for external PKI

Save the following YAML to a file named external-pki-issuer.yaml.

```yml
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: external-pki-issuer
  namespace: pipeline
spec:
  acme:
    # You must replace this email address with your own.
    # Let's Encrypt will use this to contact you about expiring
    # certificates, and issues related to your account.
    email: user@example.com
    # If the ACME server supports profiles, you can specify the profile name here.
    # See #acme-certificate-profiles below.
    profile: tlsserver
    server: https://acme-staging-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      # Secret resource that will be used to store the account's private key.
      # This is your identity with your ACME provider. Any secret name may be
      # chosen. It will be populated with data automatically, so generally
      # nothing further needs to be done with the secret. If you lose this
      # identity/secret, you will be able to generate a new one and generate
      # certificates for any/all domains managed using your previous account,
      # but you will be unable to revoke any certificates generated using that
      # previous account.
      name: example-issuer-account-key
    # Add a single challenge solver, HTTP01 using nginx
    solvers:
    - http01:
        ingress:
          ingressClassName: nginx
```

Apply the YAML to your cluster using the following command.

```bash
kubectl apply -f external-pki-issuer.yaml
```

### Create certificate resource

Save the following YAML to a file named `azmonpipeline-server-cert.yaml`.

```yml
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: azmonpipeline-server-cert
  namespace: pipeline
spec:
  secretName: collector-server-tls
  issuerRef:
    name: external-pki-issuer
  commonName: azmonpipeline-receiver.pipeline.svc.cluster.local
  dnsNames: azmonpipeline-receiver.pipeline.svc.cluster.local
```

Apply the YAML to your cluster using the following command. cert‑manager will populate the collector-server-tls secret with certificate and key.

```bash
kubectl apply -f azmonpipeline-server-cert.yaml
```

### BYOC server certificate requirements

When bringing your own server certificate:

- **Certificate and Private Key**: Both must be provided together.
- **DNS Subject Alternative Names (SANs)**: The certificate must include appropriate SANs matching the service endpoints.

The server certificate must include the service FQDN at minimum:

```ini
<pipeline-name>-service.<namespace>.svc.cluster.local
```

Optionally include shorter variants for flexibility:

```ini
<pipeline-name>-service.<namespace>.svc
<pipeline-name>-service.<namespace>
<pipeline-name>-service
```

**Example:**

For a pipeline named `byoc-pipeline` in the `production` namespace, the certificate must include:

```ini
DNS SANs:
  - byoc-pipeline-service.production.svc.cluster.local
  - byoc-pipeline-service.production.svc (optional)
  - byoc-pipeline-service.production (optional)
  - byoc-pipeline-service (optional)
```

### Certificate Storage

Certificates and keys must be stored in Kubernetes resources in the **same namespace** as the pipeline group:

- **Certificates**: Can be stored in Secrets or ConfigMaps
- **Private Keys**: Must be stored in Secrets only (for security)

### Configure TLS or mTLS

#### Create Kubernetes secrets

In order to provide your own certificate and key for client or the pipeline, it must be stored in a Kubernetes secret. Ensure that the following secrets exist in the pipeline namespace so the ARM template can reference them directly.

  - Kubernetes TLS secret named `collector-server-tls` containing `tls.crt` and `tls.key` for the collector
  - Opaque secret named `byoc-client-root-ca-secret` that stores `ca.crt`

```bash
kubectl create secret tls my-tls-secret --cert=tls.crt --key=tls.key -n <namespace>
```

You can optionally leverage the [Secret Store Extension (SSE)](/azure/azure-arc/kubernetes/secret-store-extension) to automatically synchronize certificates from Azure Key Vault to Kubernetes secrets. This provides a secure and automated way to manage certificate lifecycle without manually creating secrets.

To encrypt Secrets at rest, see [Update the key vault mode for an Azure Kubernetes Service (AKS) cluster](/azure/aks/update-kms-key-vault).


#### Configure pipeline

Use one of the following templates to configure TLS or mTLS for your Azure Monitor pipeline receivers. Before you deploy the template, change the `tlsConfigurations` section to provide your required TLS settings according to the following guidelines:

- Set `name` to a friendly identifier, such as `byoc-mtls`, and reference that identifier from any receiver in the `tlsConfiguration` field.
- If the receiver omits `tlsConfiguration`, it uses the platform’s default TLS chain created during bootstrap which covers server-side encryption only.
- Receivers can share the same TLS configuration, or you can define multiple entries and map each receiver to the appropriate configuration.
- For BYOC, specify Kubernetes secrets or ConfigMaps for `tlsCertificate` and `clientCa` and specify the correct key for `subLocation` (`tls.crt`, `tls.key`, `ca.crt`).
- Specify one of the following values for `mode`:
  - `serverOnly`: Encrypted transport only, no client authentication.
  - `mutualTls`: Clients must present certificates.
  - `disabled`: TLS is not required and all TLS material is cleared


### [ARM](#tab/arm)

```json
{
  "type": "Microsoft.Monitor/pipelineGroups",
  "apiVersion": "2025-03-01-preview",
  "name": "byoc-cm-pipeline-arm",
  "location": "eastus2",
  "properties": {
    "receivers": [
      {
        "name": "syslog",
        "type": "Syslog",
        "tlsConfiguration": "byoc-mtls",
        "syslog": { "endpoint": "0.0.0.0:514" }
      }
    ],
    "tlsConfigurations": [
      {
        "name": "byoc-mtls",
        "mode": "mutualTls",
        "tlsCertificate": {
          "certificate": {
            "type": "kubernetesSecret",
            "location": "collector-server-tls",
            "subLocation": "tls.crt"
          },
          "privateKey": {
            "type": "kubernetesSecret",
            "location": "collector-server-tls",
            "subLocation": "tls.key"
          }
        },
        "clientCa": {
          "type": "kubernetesSecret",
          "location": "byoc-client-root-ca-secret",
          "subLocation": "ca.crt"
        }
      }
    ]
  }
}
```

### [Bicep](#tab/bicep)

```bicep
param name string = 'byoc-sample'
param location string = resourceGroup().location

resource pipelineGroup 'Microsoft.Monitor/pipelineGroups@2025-03-01-preview' = {
  name: '${name}-pipeline'
  location: location
  properties: {
    receivers: [
      {
        name: '${name}-syslog'
        type: 'Syslog'
        tlsConfiguration: '${name}-mtls'
        syslog: {
          endpoint: '0.0.0.0:514'
        }
      }
    ]
    tlsConfigurations: [
      {
        name: '${name}-mtls'
        mode: 'mutualTls'
        tlsCertificate: {
          certificate: {
            type: 'kubernetesSecret'
            location: 'collector-server-tls'
            subLocation: 'tls.crt'
          }
          privateKey: {
            type: 'kubernetesSecret'
            location: 'collector-server-tls'
            subLocation: 'tls.key'
          }
        }
        clientCa: {
          type: 'kubernetesSecret'
          location: 'byoc-client-root-ca-secret'
          subLocation: 'ca.crt'
        }
      }
    ]
  }
}
```
---

## Example configurations
The following section provide different configurations to include in the `tlsCertificate` section of the pipeline configuration shown above. Plug in the appropriate JSON snippet based on your desired configuration before applying to the configuration to the pipeline.

**Default TLS**

```json
{			
"name": "default-server-tls",			
"mode": "serverOnly"			
}	
```

**BYOC mTLS**

```json
{
  "name": "byoc-mtls",
  "mode": "mutualTls",
  "tlsCertificate": {
    "certificate": {
      "type": "kubernetesSecret",
      "location": "collector-server-tls",
      "subLocation": "tls.crt"
    },
    "privateKey": {
      "type": "kubernetesSecret",
      "location": "collector-server-tls",
      "subLocation": "tls.key"
    }
  },
  "clientCA": {
    "type": "kubernetesSecret",
    "location": "byoc-client-root-ca-secret",
    "subLocation": "ca.crt"
  }
}
```

**BYOC TLS**

```json
{
  "name": "byoc-server-tls",
  "mode": "serverOnly",
  "tlsCertificate": {
    "certificate": {
      "type": "kubernetesSecret",
      "location": "collector-server-tls",
      "subLocation": "tls.crt"
    },
    "privateKey": {
      "type": "kubernetesSecret",
      "location": "collector-server-tls",
      "subLocation": "tls.key"
    }
  }
}
```

**Server: Default, Client: BYOC**

```json
{
  "name": "default-server-byoc-client",
  "clientCA": {
    "type": "kubernetesSecret",
    "location": "custom-client-root-ca",
    "subLocation": "ca.crt"
  }
}
```

**Server: BYOC, Client: default**

```json
{
  "name": "byoc-server-default-client",
  "tlsCertificate": {
    "certificate": {
      "type": "kubernetesSecret",
      "location": "collector-server-tls",
      "subLocation": "tls.crt"
    },
    "privateKey": {
      "type": "kubernetesSecret",
      "location": "collector-server-tls",
      "subLocation": "tls.key"
    }
  }
}
```

**Disable TLS**

```json
{
  "name": "tls-disabled",
  "mode": "disabled"
}
```


## Setup gateway for Azure Monitor Pipeline

Azure Monitor Pipeline extension deploys OpenTelemetry collectors with ClusterIP services, which are only accessible within the Kubernetes cluster. To expose these pipelines to external clients, you need to deploy a gateway solution.

### Gateway Architecture Options

This guide provides an example using Traefik with the **Insecure Frontend + mTLS Backend** architecture, which provides:

- Simple client connectivity (no client-side TLS configuration)
- Strong security between gateway and pipeline (mutual TLS)
- Gateway authenticates to the pipeline as a trusted client

### Gateway Prerequisites

Before deploying the gateway, ensure:

- **Azure Monitor Pipeline Operator** is installed and running
- **cert-manager** extension is installed (required for certificate management)
- **Traefik** Helm chart is available (we'll install it)
- **Namespace labeled** for trust bundle distribution:

```bash
kubectl label namespace <pipeline-namespace> arc-amp-trust-bundle=true
```

### Step 1: Deploy the pipeline

Create a syslog pipeline with default mTLS settings:

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "description": "This template deploys an edge pipeline for azure monitor."
    },
    "resources": [
        {
            "type": "Microsoft.monitor/pipelineGroups",
            "location": "eastus2euap",
            "apiVersion": "2025-03-01-preview",
            "extendedLocation": {
                "name": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resouce-group/providers/Microsoft.ExtendedLocation/customLocations/my-customlocation-eastus2",
                "type": "CustomLocation"
            },
            "name": "syslog-pipeline",
            "properties": {
                "receivers": [
                    {
                        "type": "Syslog",
                        "name": "syslog-tcp",
                        "syslog": {
                            "endpoint": "0.0.0.0:514",
                            "protocol": "rfc5424",
                            "transportProtocol": tcp
                        }
                    }
                ],
                "processors": [
                    {
                        "type": "MicrosoftSyslog",
                        "name": "ms-syslog-processor"
                    },
                    {
                        "type": "Batch",
                        "name": "batch-processor",
                        "batch": {
                            "timeout": 60000
                        }
                    },
                    {
                        "type": "TransformLanguage",
                        "name": "my-transform",
                        "transformLanguage": {
                            "transformStatement": "source"
                        }
                    }
                ],
                "exporters": [
                    {
                        "type": "AzureMonitorWorkspaceLogs",
                        "name": "syslog-eus2",
                        "azureMonitorWorkspaceLogs": {
                            "api": {
                                "dataCollectionEndpointUrl": "https://my-dce-eastus2-t9si.eastus2-1.ingest.monitor.azure.com",
                                "dataCollectionRule": "dcr-00000000000000000000000000000000",
                                "stream": "Microsoft-Syslog-FullyFormed",
                                "schema": {
                                    "recordMap": [
                                        {
                                            "from": "attributes.CollectorHostName",
                                            "to": "CollectorHostName"
                                        },
                                        {
                                            "from": "attributes.Computer",
                                            "to": "Computer"
                                        },
                                        {
                                            "from": "attributes.EventTime",
                                            "to": "EventTime"
                                        },
                                        {
                                            "from": "attributes.Facility",
                                            "to": "Facility"
                                        },
                                        {
                                            "from": "attributes.HostIP",
                                            "to": "HostIP"
                                        },
                                        {
                                            "from": "attributes.HostName",
                                            "to": "HostName"
                                        },
                                        {
                                            "from": "attributes.ProcessID",
                                            "to": "ProcessID"
                                        },
                                        {
                                            "from": "attributes.ProcessName",
                                            "to": "ProcessName"
                                        },
                                        {
                                            "from": "attributes.SeverityLevel",
                                            "to": "SeverityLevel"
                                        },
                                        {
                                            "from": "attributes.SourceSystem",
                                            "to": "SourceSystem"
                                        },
                                        {
                                            "from": "attributes.SyslogMessage",
                                            "to": "SyslogMessage"
                                        },
                                        {
                                            "from": "attributes.TimeGenerated",
                                            "to": "TimeGenerated"
                                        }
                                    ]
                                }
                            }
                        }
                    }
                ],
                "service": {
                    "pipelines": [
                        {
                            "name": "syslog-pipeline",
                            "receivers": [
                                "syslog-receiver"
                            ],
                            "processors": [
                                "ms-syslog-processor",
                                "batch-processor",
                                "my-transform"
                            ],
                            "exporters": [
                                "syslog-eus2"
                            ],
                            "type": "Logs"
                        }
                    ]
                }
            }
        }
    ]
}
```

TLS is enabled by default with mutualTls mode. No tlsConfigurations needed for default behavior.

### Step 2: Create gateway client certificate

The gateway needs a client certificate to authenticate to the pipeline. Create a certificate issued by the managed client CA:

```yml
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: gateway-client-cert
  namespace: test
spec:
  secretName: gateway-client-tls
  duration: 48h
  renewBefore: 24h
  issuerRef:
    name: arc-amp-client-root-ca-cluster-issuer
    kind: ClusterIssuer
    group: cert-manager.io
  commonName: traefik-gateway-client
  usages:
    - client auth
  privateKey:
    algorithm: ECDSA
    size: 256
```

Apply the certificate:

```bash
kubectl apply -f certificates.yaml
kubectl wait --for=condition=ready certificate gateway-client-cert -n test --timeout=120s
```

### Step 3: Install CRDs

```bash
helm repo add traefik https://traefik.github.io/charts 2>/dev/null || true
helm repo update traefik
helm show crds traefik/traefik | kubectl apply -f
```


### Step 4: Configure Traefik routing with mTLS Backend

Create the `ServersTransportTCP` and `IngressRouteTCP`. Since Traefik is deployed in the same namespace as the pipeline, it can directly access the trust bundle ConfigMap and client certificate Secret.

```yml
# ServersTransportTCP - Defines mTLS settings for backend connection
apiVersion: traefik.io/v1alpha1
kind: ServersTransportTCP
metadata:
  name: syslog-pipeline-mtls-transport
  namespace: test
spec:
  tls:
    # Server name for SNI and certificate validation
    serverName: "syslog-pipeline-service.test.svc.cluster.local"
    # Root CA to verify the pipeline's server certificate
    # Uses the trust bundle ConfigMap distributed by the operator
    rootCAs:
      - configMap: arc-amp-trust-bundle
    # Client certificate for Traefik to present to pipeline (mTLS)
    # This secret is created by cert-manager from the Certificate in Step 2
    certificatesSecrets:
      - gateway-client-tls
    insecureSkipVerify: false
---
# IngressRouteTCP - TCP routing with mTLS backend
apiVersion: traefik.io/v1alpha1
kind: IngressRouteTCP
metadata:
  name: syslog-route
  namespace: test
spec:
  entryPoints:
    - tcp-syslog
  routes:
    - match: HostSNI(`*`)
      services:
        - name: syslog-pipeline-service
          port: 514
          # CRITICAL: This flag ENABLES TLS when dialing the backend
          tls: true
          serversTransport: syslog-pipeline-mtls-transport
```

Apply the routing configuration:

```bash
kubectl apply -f routing.yaml
```

### Step 5: Install Traefik

Deploy Traefik in the **same namespace** as the pipeline. This simplifies configuration because:

- The `arc-amp-trust-bundle` ConfigMap (server CA) is already in this namespace
- The `gateway-client-tls` Secret (client cert) is created here by cert-manager
- No cross-namespace access configuration required

Install Traefik in the same namespace as the pipeline:

```bash
helm repo add traefik https://traefik.github.io/charts
helm repo update
helm install traefik traefik/traefik \
    --namespace test \
    --set deployment.replicas=1 \
    --set providers.kubernetesIngress.enabled=false \
    --set providers.kubernetesCRD.enabled=true \
    --set ports.tcp-syslog.port=514 \
    --set ports.tcp-syslog.expose.default=true \
    --set ports.tcp-syslog.exposedPort=514 \
    --set ports.tcp-syslog.protocol=TCP \
    --set service.type=LoadBalancer \
    --wait

```


### Step 6: Test the gateway

Get the gateway's external IP:

```bash
GATEWAY_IP=$(kubectl get svc traefik -n test -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo "Gateway IP: $GATEWAY_IP"
```

Clients can use this IP and port 514 to send syslog messages over TCP to the syslog pipeline.

### Certificate Management

- **Gateway Client Certificate**: Issued by `arc-amp-client-root-ca-cluster-issuer`, auto-renewed by cert-manager
- **Pipeline Server Certificate**: Automatically managed by the operator with zero-downtime rotation
- **Trust Bundles**: Automatically distributed to labeled namespaces

### Gateway Troubleshooting

**Check certificate status**

```bash
kubectl get certificate -n test
kubectl describe certificate gateway-client-cert -n test
```

**Check Traefik routing**

```bash
kubectl get ingressroutetcp -n test
kubectl get serverstransporttcp -n test -o yaml
```

**Check Traefik logs for TLS errors**

```bash
kubectl logs -n test -l app.kubernetes.io/name=traefik --tail=50 | grep -i "tls\|error\|certificate"
```

**Check pipeline logs**

```bash
kubectl logs -n test -l app.kubernetes.io/name=syslog-pipeline -c collector --tail=50
```

**Common Issues**

| Issue | Cause | Solution |
|------ |------ |--------- |
| `tls: bad certificate` | Gateway cert not trusted by pipeline | Verify cert is issued by `arc-amp-client-root-ca-cluster-issuer`. |
| `certificate signed by unknown authority` | Trust bundle not found or wrong key | Verify `arc-amp-trust-bundle` ConfigMap exists and has `ca.crt` key. |
| Connection refused | `tls: true` missing on service | Add `tls: true` to IngressRouteTCP service. |
| Deprecation warning for `rootCAsSecrets` | Using old Traefik API | Use `rootCAs` with `secret:` or `configMap:` format. |

## Next steps
- Read more about [data collection rules (DCRs)](../data-collection/data-collection-rule-overview.md) in Azure Monitor.