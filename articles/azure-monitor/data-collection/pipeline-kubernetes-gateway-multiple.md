---
title: Azure Monitor pipeline - Traefik gateway for multiple pipelines
description: Secure the connection from your remote clients to Azure Monitor pipeline using multiple gateways.
ms.topic: article
ms.date: 01/15/2026
ms.custom: references_regions, devx-track-azurecli
---

# Azure Monitor pipeline - Traefik gateway for multiple pipelines

This guide covers deploying Traefik gateways when you have **multiple Azure
Monitor pipelines** on the same cluster.

When multiple pipelines need external exposure, Traefik's architecture requires
planning around port allocation, route isolation, and LoadBalancer IP
usage. This document explains the two deployment models available and their
trade-offs.

> [!NOTE]
> Traefik gateway will only work in environments where Kubernetes Load Balancers
> can be deployed successfully, such as when running on a supported cloud provider
> like Azure.

## Choosing a deployment model

Traefik combines the data plane (proxy) and control plane (configuration watcher)
into a single process. Listening ports are configured at startup and cannot be
changed without restarting Traefik.

There are two ways to deploy Traefik for Azure Monitor pipelines. Choose the
model that fits your environment.

### Model A: One gateway per pipeline

Each pipeline gets its own Traefik Helm release, its own LoadBalancer, and its
own external IP address.

```text
Client A → 20.x.x.1:514  → Traefik instance 1 → [mTLS] → syslog-pipeline-1:514
Client B → 20.x.x.2:514  → Traefik instance 2 → [mTLS] → syslog-pipeline-2:514
Client C → 20.x.x.3:514 → Traefik instance 3 → [mTLS] → syslog-pipeline-3:514
```

**Advantages:**

- Each pipeline is fully independent — scaling, upgrades, and failures are isolated
- Standard ports preserved (clients always connect on 514 for syslog pipelines)
- Adding a new pipeline does not affect existing gateways

**Disadvantages:**

- One LoadBalancer IP per pipeline (may be a concern in IP-limited environments)

### Model B: Shared gateway with multiple ports

Multiple pipelines share a single Traefik instance and LoadBalancer IP, with
each pipeline mapped to a different external port. Every time a new pipeline is added, Traefik needs to be upgraded to open a new port to receive traffic for the new pipeline with a `helm upgrade`.

```text
Client A → 20.x.x.1:514  → Traefik (shared) → [mTLS] → syslog-pipeline-1:514
Client B → 20.x.x.1:1514 → Traefik (shared) → [mTLS] → syslog-pipeline-2:514
Client C → 20.x.x.1:2514 → Traefik (shared) → [mTLS] → syslog-pipeline-3:514
```

The Traefik instance can be in a **different namespace** from the pipelines. However,
the routing resources (`IngressRouteTCP`, `ServersTransportTCP`) must be created
in the **same namespace as the pipeline service** they route to. Traefik must be
configured with `providers.kubernetesCRD.namespaces` to watch the pipeline
namespaces.

**Advantages:**

- Single LoadBalancer IP for all pipelines
- Traefik can serve pipelines across multiple namespaces

**Disadvantages:**

- Pipelines must be assigned different external ports — clients must be configured accordingly
- Adding a new pipeline requires `helm upgrade`, which triggers a rolling restart
  and **briefly interrupts all existing client connections**
- All pipelines share a failure domain

> [!IMPORTANT]
> Traefik resolves Secret and ConfigMap references in the **same namespace as the
> routing resource**, not cross-namespace. The gateway client certificate
> (`gateway-client-tls`) and trust bundle (`arc-amp-trust-bundle`) must exist in
> each pipeline namespace where routing resources are deployed.

## Prerequisites

See the prerequisites in [Configure Azure Monitor pipeline](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/pipeline-configure#prerequisites) for details on the requirements for enabling and configuring the Azure Monitor
pipeline. Before deploying the Traefik gateway, here are additional
prerequisites:

- Traefik Helm chart is available
- Namespace labeled for trust bundle distribution:
  ```bash
  kubectl label namespace <pipeline-namespace> arc-amp-trust-bundle=true
  ```

### Install Traefik CRDs

Traefik CRDs are installed once per cluster:

```bash
helm repo add traefik https://traefik.github.io/charts 2>/dev/null || true
helm repo update traefik
helm show crds traefik/traefik | kubectl apply -f -
```

## Deploy gateway for TLS secure encrypted ingestion

The following example demonstrates a use case where remote clients connect to
the gateway with an insecure connection, while the gateway has an mTLS connection
with the pipeline. This example uses a syslog pipeline on port 514.

### Step 1: Create gateway client certificate

The gateway needs a client certificate to authenticate to the pipeline.

- **Model A:** Create the certificate once in the pipeline namespace.
- **Model B:** Create the certificate in **each pipeline namespace** where routing
  resources are deployed. The same certificate name and spec can be reused across
  namespaces.

```yaml
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: gateway-client-cert
  namespace: <pipeline-namespace>
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
kubectl wait --for=condition=ready certificate gateway-client-cert -n <pipeline-namespace> --timeout=120s
```

### Step 2: Configure Traefik routing with mTLS backend

For each pipeline, create a `ServersTransportTCP` (mTLS settings) and an
`IngressRouteTCP` (routing rule).

- **Model A:** Each resource must carry a label matching its Traefik instance's
  `labelSelector` (e.g., `traefik-instance: <pipeline-name>-gateway`). This ensures
  each Traefik instance only processes routes for its own pipeline.
- **Model B:** Routing resources can skip providing labels since a single Traefik instance serves all pipelines. Each `IngressRouteTCP` must reference a different `entryPoints` value to map to the correct external port.

```yaml
# ServersTransportTCP - Defines mTLS settings for backend connection
apiVersion: traefik.io/v1alpha1
kind: ServersTransportTCP
metadata:
  name: <pipeline-name>-mtls-transport
  namespace: <pipeline-namespace>
  labels:
    traefik-instance: <pipeline-name>-gateway # skip specifying labels in case of Model B
spec:
  tls:
    serverName: "<pipeline-name>-service.<pipeline-namespace>.svc.cluster.local"
    rootCAs:
      - configMap: arc-amp-trust-bundle
    certificatesSecrets:
      - gateway-client-tls
    insecureSkipVerify: false
---
# IngressRouteTCP - TCP routing with mTLS backend
apiVersion: traefik.io/v1alpha1
kind: IngressRouteTCP
metadata:
  name: <pipeline-name>-route
  namespace: <pipeline-namespace>
  labels:
    traefik-instance: <pipeline-name>-gateway # skip specifying labels in case of Model B
spec:
  entryPoints:
    # Must match the port name used in the Traefik Helm install (e.g., ports.tcp-syslog.port=514)
    # Model A: use the same name across all installs (e.g., tcp-syslog)
    # Model B: use a unique name per pipeline (e.g., tcp-syslog-1, tcp-syslog-2)
    - tcp-syslog
  routes:
    - match: HostSNI(`*`)
      services:
        - name: <pipeline-name>-service
          # The pipeline's internal receiver port
          port: 514
          # CRITICAL: This flag ENABLES TLS when dialing the backend
          tls: true
          serversTransport: <pipeline-name>-mtls-transport
```

Apply:

```bash
kubectl apply -f routing.yaml
```

### Step 3: Install Traefik

**Model A** (one gateway per pipeline):

```bash
helm install traefik-<pipeline-name> traefik/traefik \
    --namespace <pipeline-namespace> \
    --set deployment.replicas=1 \
    --set providers.kubernetesIngress.enabled=false \
    --set providers.kubernetesCRD.enabled=true \
    --set "providers.kubernetesCRD.labelSelector=traefik-instance=<pipeline-name>-gateway" \
    --set ports.tcp-syslog.port=514 \
    --set ports.tcp-syslog.expose.default=true \
    --set ports.tcp-syslog.exposedPort=514 \
    --set ports.tcp-syslog.protocol=TCP \
    --set ports.web.expose.default=false \
    --set ports.websecure.expose.default=false \
    --set service.type=LoadBalancer \
    --wait
```

**Model B** (shared gateway — include all pipeline ports at install time):

```bash
helm install traefik-shared traefik/traefik \
    --namespace <gateway-namespace> \
    --set deployment.replicas=1 \
    --set providers.kubernetesIngress.enabled=false \
    --set providers.kubernetesCRD.enabled=true \
    --set "providers.kubernetesCRD.namespaces={<pipeline-namespace-1>,<pipeline-namespace-2>}" \
    --set ports.tcp-syslog-1.port=514 \
    --set ports.tcp-syslog-1.expose.default=true \
    --set ports.tcp-syslog-1.exposedPort=514 \
    --set ports.tcp-syslog-1.protocol=TCP \
    --set ports.tcp-syslog-2.port=1514 \
    --set ports.tcp-syslog-2.expose.default=true \
    --set ports.tcp-syslog-2.exposedPort=1514 \
    --set ports.tcp-syslog-2.protocol=TCP \
    --set ports.web.expose.default=false \
    --set ports.websecure.expose.default=false \
    --set service.type=LoadBalancer \
    --wait
```

When using Model B with pipelines in different namespaces, ensure the gateway
client certificate (`gateway-client-tls` Secret) is created in **each pipeline
namespace**. The `arc-amp-trust-bundle` ConfigMap is automatically distributed to
namespaces labeled with `arc-amp-trust-bundle=true`.

> [!NOTE]
> After installation, Helm may display a warning:
> `🚨 Resources populated with this chart don't match with labelSelector ... 🚨`
> This is safe to ignore (Model A only) — it refers to Traefik's default dashboard
> IngressRoute, not your pipeline routing resources. Model B does not use
> `labelSelector`, so this warning will not appear.

### Step 4: Test the gateway

Get the gateway's external IP:

```bash
# Model A
GATEWAY_IP=$(kubectl get svc traefik-<pipeline-name> -n <pipeline-namespace> -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

# Model B
GATEWAY_IP=$(kubectl get svc traefik-shared -n <gateway-namespace> -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
```

Clients can use this IP and port to send data to the pipeline.

### Adding a new pipeline to an existing gateway (Model B only)

When adding a new pipeline to a shared Traefik instance:

1. Create the gateway client certificate (`gateway-client-tls`) in the new
   pipeline's namespace if it doesn't already exist.
2. Create the new pipeline's `ServersTransportTCP` and `IngressRouteTCP` in the
   pipeline's namespace (with a new entryPoint name).
3. Run `helm upgrade` to add the new port and, if the pipeline is in a new
   namespace, add it to the watched namespace list:

```bash
helm upgrade traefik-shared traefik/traefik \
    --namespace <gateway-namespace> \
    --reuse-values \
    --set "providers.kubernetesCRD.namespaces={<existing-ns-1>,<existing-ns-2>,<new-pipeline-namespace>}" \
    --set ports.tcp-new-pipeline.port=<new-port> \
    --set ports.tcp-new-pipeline.expose.default=true \
    --set ports.tcp-new-pipeline.exposedPort=<new-port> \
    --set ports.tcp-new-pipeline.protocol=TCP
```

> [!NOTE]
> `--reuse-values` preserves existing port definitions. The `namespaces` list
> must include **all** pipeline namespaces (existing and new) because `--set`
> replaces the entire value.

> [!WARNING]
> `helm upgrade` triggers a rolling restart of the Traefik pod. During the
> restart, existing client connections will be interrupted. Plan upgrades during
> maintenance windows when possible.

Learn about [Traefik](https://doc.traefik.io/traefik/) and the [Traefik Kubernetes CRD provider](https://doc.traefik.io/traefik/providers/kubernetes-crd/).

## Next steps
- Read more about [data collection rules (DCRs)](../data-collection/data-collection-rule-overview.md) in Azure Monitor.