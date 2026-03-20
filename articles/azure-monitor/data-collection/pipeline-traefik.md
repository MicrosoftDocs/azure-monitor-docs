---
title: Azure Monitor pipeline - Traefik Gateway
description: Secure the connection from your remote clients to Azure Monitor pipeline using a gateway.
ms.topic: article
ms.date: 01/15/2026
ms.custom: references_regions, devx-track-azurecli
---

# Traefik Gateway for Azure Monitor Pipeline

This guide covers deploying a Traefik reverse-proxy gateway to expose Azure
Monitor Pipeline receivers to clients external to the Kubernetes cluster. It
addresses the following scenarios:

| Scenario | Section |
|---|---|
| **Greenfield** — first gateway + first pipeline | [1. Greenfield deployment](#1-greenfield-deployment) |
| **Brownfield 2A** — add a new receiver (new port) to an existing pipeline | [2A. Add a new receiver](#2a-add-a-new-receiver-new-port) |
| **Brownfield 2B** — add a new client to an existing receiver | [2B. Add a new client](#2b-add-a-new-client-to-an-existing-receiver) |
| **Brownfield 2C** — deploy a new Pipeline Group alongside an existing one | [2C. New Pipeline Group instance](#2c-new-pipeline-group-instance) |

> [!NOTE]
> Traefik gateway will only work in environments where Kubernetes Load Balancers
> can be deployed successfully, such as when running on a supported cloud provider
> like Azure.

## Placeholders

Replace the angle-bracket placeholders throughout this document with values
specific to your environment.

| Placeholder | Description | Example |
|---|---|---|
| `<pipeline-name>` | Name of the Azure Monitor Pipeline Group resource | `syslog-pipeline` |
| `<pipeline-namespace>` | Kubernetes namespace where both the pipeline and the Traefik gateway are deployed | `test` |
| `<receiver-port>` | TCP port the pipeline receiver listens on | `514` (syslog), `4317` (OTLP) |
| `<entrypoint-name>` | Name of the Traefik entrypoint for the receiver port | `tcp-syslog`, `tcp-otlp` |
| `<helm-release>` | Helm release name for the Traefik installation | `traefik-<pipeline-name>` |

## Prerequisites

See the prerequisites in [Configure Azure Monitor pipeline](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/pipeline-configure#prerequisites)
for details on enabling and configuring the Azure Monitor pipeline. The
following additional prerequisites apply to the Traefik gateway:

- **Traefik Helm chart** — the Helm repository must be accessible from the
  workstation running `helm`.
- **Namespace label** — the pipeline namespace must be labeled so that the
  operator distributes the trust bundle ConfigMap:
  ```bash
  kubectl label namespace <pipeline-namespace> arc-amp-trust-bundle=true
  ```
- **Pipeline Group deployed** — the Azure Monitor Pipeline Group must already be
  running (or being deployed alongside the gateway). The pipeline's ClusterIP
  `Service` and the `arc-amp-trust-bundle` ConfigMap must exist before Traefik
  can route traffic.

---

## Canonical resource files

The two YAML files below are referenced by every scenario in this document.
Inline comments indicate which fields apply to specific scenarios. Save them as
`certificates.yaml` and `routing.yaml` respectively.

### certificates.yaml

```yaml
# certificates.yaml
# Creates a short-lived client certificate that the gateway presents to the
# pipeline when dialing the mTLS backend.
# Applicable to: Greenfield (Section 1), Brownfield 2A, Brownfield 2C.
# NOT required for TLS-disabled ingestion (see Option 2 in Section 1).
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: gateway-client-cert
  namespace: <pipeline-namespace>       # Deploy in the pipeline namespace
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

### routing.yaml

```yaml
# routing.yaml
# Contains both the ServersTransportTCP (mTLS backend settings) and the
# IngressRouteTCP (TCP routing rule).
#
# For TLS-disabled ingestion, skip the ServersTransportTCP entirely and remove
# the tls/serversTransport fields from the IngressRouteTCP service entry
# (see Option 2 notes inline below).
#
# Create one copy of each resource per receiver/port combination.
# For example, a pipeline exposing both syslog (514) and OTLP (4317) requires
# two ServersTransportTCP + IngressRouteTCP pairs.
---
# ServersTransportTCP — mTLS settings for the backend connection
# Skip this resource entirely for TLS-disabled ingestion (Option 2).
apiVersion: traefik.io/v1alpha1
kind: ServersTransportTCP
metadata:
  name: <pipeline-name>-mtls-transport
  namespace: <pipeline-namespace>
  labels:
    # Label selector for Traefik instance isolation.
    # Include this label from the start so the gateway is ready for future
    # multi-pipeline scenarios without requiring a disruptive Helm upgrade.
    # The value must match the labelSelector configured in the Helm install.
    traefik-instance: <pipeline-name>-gateway
spec:
  tls:
    serverName: "<pipeline-name>-service.<pipeline-namespace>.svc.cluster.local"
    rootCAs:
      - configMap: arc-amp-trust-bundle
    certificatesSecrets:
      - gateway-client-tls
    insecureSkipVerify: false
---
# IngressRouteTCP — TCP routing rule
apiVersion: traefik.io/v1alpha1
kind: IngressRouteTCP
metadata:
  name: <pipeline-name>-<entrypoint-name>-route
  namespace: <pipeline-namespace>
  labels:
    # Same label selector as above.
    traefik-instance: <pipeline-name>-gateway
spec:
  entryPoints:
    # Must match the port name used in the Traefik Helm install
    # (e.g., ports.<entrypoint-name>.port=<receiver-port>).
    - <entrypoint-name>
  routes:
    - match: HostSNI(`*`)
      services:
        - name: <pipeline-name>-service
          port: <receiver-port>
          # --- TLS-enabled (Option 1) fields START ---
          # CRITICAL: this flag ENABLES TLS when Traefik dials the backend.
          tls: true
          serversTransport: <pipeline-name>-mtls-transport
          # --- TLS-enabled (Option 1) fields END ---
          # For TLS-disabled ingestion (Option 2), remove the 'tls' and
          # 'serversTransport' keys above. Traefik will forward TCP traffic
          # to the backend in plain text.
```

---

## 1. Greenfield deployment

**Scenario:** The cluster has no existing gateway or Azure Monitor Pipeline. Deploy one gateway and one Azure Monitor Pipeline Group for the first time.

This section provides two options. Choose the option that matches the TLS
configuration of the pipeline:

- **Option 1 — TLS-enabled (mTLS backend):** The pipeline has TLS enabled.
  Remote clients connect to the gateway over plain TCP; the gateway terminates
  the connection and dials the pipeline backend over mTLS.
- **Option 2 — TLS-disabled:** The pipeline has TLS disabled. The gateway
  forwards TCP traffic to the backend without TLS.

```text
Option 1 (TLS-enabled):
  Client ── TCP ──▶ Traefik ══ mTLS ══▶ Pipeline Service:514

Option 2 (TLS-disabled):
  Client ── TCP ──▶ Traefik ── TCP ──▶ Pipeline Service:514
```

The steps below use **syslog on port 514** as the running example. Substitute the
port, entrypoint name, and service name for any TCP-based receiver.

> [!IMPORTANT]
> Even though only one pipeline exists at this point, the instructions below
> include **label selectors** (`providers.kubernetesCRD.labelSelector` in the
> Helm values and matching `traefik-instance` labels on the routing resources).
> This prepares the gateway for future multi-pipeline scenarios and avoids a
> disruptive Helm upgrade later. If a second pipeline is added in the future
> with its own dedicated gateway, label selectors ensure each Traefik instance
> only processes routes intended for its own pipeline.

### Step 1: Install Traefik CRDs

Traefik Custom Resource Definitions are installed once per cluster. If they
already exist, the command is a no-op.

```bash
helm repo add traefik https://traefik.github.io/charts 2>/dev/null || true
helm repo update traefik
helm show crds traefik/traefik | kubectl apply -f -
```

### Step 2: Create the gateway client certificate (Option 1 only)

> Skip this step for TLS-disabled ingestion (Option 2).

Apply `certificates.yaml` (see [Canonical resource files](#certificatesyaml)):

```bash
kubectl apply -f certificates.yaml
kubectl wait --for=condition=ready certificate gateway-client-cert \
  -n <pipeline-namespace> --timeout=120s
```

Verify the Secret was created:

```bash
kubectl get secret gateway-client-tls -n <pipeline-namespace>
```

### Step 3: Configure Traefik routing

Apply `routing.yaml` (see [Canonical resource files](#routingyaml)).

- **Option 1 (TLS-enabled):** Use `routing.yaml` as-is.
- **Option 2 (TLS-disabled):** Remove the `ServersTransportTCP` resource
  and remove the `tls` and `serversTransport` fields from the
  `IngressRouteTCP` service entry (see inline comments in the file).

Replace the placeholders with your values. For a syslog receiver:

| Placeholder | Value |
|---|---|
| `<pipeline-name>` | your pipeline name |
| `<pipeline-namespace>` | your pipeline namespace |
| `<entrypoint-name>` | `tcp-syslog` |
| `<receiver-port>` | `514` |

```bash
kubectl apply -f routing.yaml
```

### Step 4: Install Traefik

Deploy Traefik in the same namespace as the pipeline.

**Option 1 — TLS-enabled (mTLS backend):**

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

**Option 2 — TLS-disabled:**

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

> [!NOTE]
> After installation, Helm may display a warning:
> `🚨 Resources populated with this chart don't match with labelSelector ... 🚨`
> This is safe to ignore — it refers to Traefik's default dashboard
> `IngressRoute`, not your pipeline routing resources.

### Step 5: Verify the gateway

1. Confirm the Traefik pod is running:

   ```bash
   kubectl get pods -n <pipeline-namespace> -l app.kubernetes.io/name=traefik
   ```

2. Get the gateway's external IP:

   ```bash
   GATEWAY_IP=$(kubectl get svc traefik-<pipeline-name> \
     -n <pipeline-namespace> \
     -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
   echo "Gateway IP: $GATEWAY_IP"
   ```

3. Verify the routing resources:

   ```bash
   kubectl get ingressroutetcp -n <pipeline-namespace>
   kubectl get serverstransporttcp -n <pipeline-namespace>
   ```

4. Check Traefik logs for errors:

   ```bash
   kubectl logs -n <pipeline-namespace> \
     -l app.kubernetes.io/name=traefik --tail=50
   ```

Clients can now connect to `$GATEWAY_IP:514` to send data to the pipeline.

### Certificate management (Option 1)

- **Gateway client certificate:** Issued by
  `arc-amp-client-root-ca-cluster-issuer` and auto-renewed by cert-manager.
- **Pipeline server certificate:** Automatically managed by the pipeline
  operator with zero-downtime rotation.
- **Trust bundles:** Automatically distributed to namespaces labeled with
  `arc-amp-trust-bundle=true`.

---

## 2. Brownfield — Modifying an existing deployment

The following sections cover changes to a cluster that already has at least one
gateway and one Azure Monitor Pipeline Group deployed (using the greenfield
steps above or an equivalent setup).

> [!WARNING]
> When a `helm upgrade` is required, the Traefik pod restarts and the gateway is
> **briefly unavailable** (on the order of seconds). All existing client
> connections through that gateway are interrupted during the restart. Perform
> Helm upgrades during a maintenance window when possible.

---

### 2A. Add a new receiver (new port)

**Scenario:** The existing Pipeline Group is configured with a new receiver
(for example, an OTLP receiver on port 4317 is added alongside an existing
syslog receiver on 514). The gateway must expose the new port.

#### Approach: Modify the existing gateway

##### Step 1: Create routing resources for the new receiver

Create a new `ServersTransportTCP` and `IngressRouteTCP` pair for the new
receiver. Use the same `routing.yaml` template from the
[Canonical resource files](#routingyaml) section with the new receiver's values.

For an OTLP receiver example:

| Placeholder | Value |
|---|---|
| `<pipeline-name>` | same pipeline name as the existing deployment |
| `<pipeline-namespace>` | same pipeline namespace |
| `<entrypoint-name>` | `tcp-otlp` |
| `<receiver-port>` | `4317` |

> [!NOTE]
> For TLS-disabled ingestion, skip the `ServersTransportTCP` and remove the
> `tls`/`serversTransport` fields from the `IngressRouteTCP`, as described in
> the inline comments in `routing.yaml`.

The label (`traefik-instance: <pipeline-name>-gateway`) must match the
`labelSelector` already configured on the existing Traefik instance.

```bash
kubectl apply -f routing-otlp.yaml
```

##### Step 2: Upgrade Traefik to open the new port

Run `helm upgrade` with `--reuse-values` to preserve the existing port
definitions and add the new port:

```bash
helm upgrade traefik-<pipeline-name> traefik/traefik \
    --namespace <pipeline-namespace> \
    --reuse-values \
    --set ports.tcp-otlp.port=4317 \
    --set ports.tcp-otlp.expose.default=true \
    --set ports.tcp-otlp.exposedPort=4317 \
    --set ports.tcp-otlp.protocol=TCP
```

> [!WARNING]
> This `helm upgrade` triggers a pod restart. Existing client connections
> (including those on the syslog port) are briefly interrupted. Perform this
> during a maintenance window.

##### Step 3: Verify

```bash
kubectl get svc traefik-<pipeline-name> -n <pipeline-namespace> -o yaml
kubectl get ingressroutetcp -n <pipeline-namespace>
```

Confirm the service now exposes both ports (514 and 4317). Clients can connect
to `$GATEWAY_IP:4317` for OTLP traffic.

#### Alternative approach: Add a second gateway for the new receiver

> [!NOTE]
> **Open action item** — This approach needs feasibility evaluation before use in
> production.

Instead of adding a port to the existing Traefik instance, deploy a **second
Traefik instance** dedicated to the new receiver. Each gateway would have its
own LoadBalancer IP and manage a single port.

```text
Client A → 20.x.x.1:514  → Traefik instance 1 → [mTLS] → pipeline-service:514
Client B → 20.x.x.2:4317 → Traefik instance 2 → [mTLS] → pipeline-service:4317
```

**Trade-offs:**

| | Modify existing gateway | Dedicated second gateway |
|---|---|---|
| LoadBalancer IPs | 1 | 2 |
| Port isolation | Shared failure domain | Fully independent |
| Helm upgrade impact | Restarts affect all ports | Each gateway upgraded independently |
| Operational overhead | Lower — single release | Higher — two Helm releases, two services |

---

### 2B. Add a new client to an existing receiver

**Scenario:** An additional client needs to send data to the **same receiver on
the same port** (for example, a second network switch sending syslog to port
514).

**No changes are required** to the gateway or the Pipeline Group.

The new client connects to the same gateway external IP and port used by the
existing client:

```text
Existing Client → GATEWAY_IP:514 → Traefik → pipeline-service:514
New Client      → GATEWAY_IP:514 → Traefik → pipeline-service:514
```

Retrieve the gateway IP if needed:

```bash
GATEWAY_IP=$(kubectl get svc traefik-<pipeline-name> \
  -n <pipeline-namespace> \
  -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo "Gateway IP: $GATEWAY_IP"
```

Point the new client at `$GATEWAY_IP:514`. No Helm upgrade, no routing changes,
and no certificate changes are needed.

---

### 2C. New Pipeline Group instance

**Scenario:** A completely new Azure Monitor Pipeline Group is being deployed
alongside an existing one on the same cluster.

Deploy a **new, dedicated gateway** for the new pipeline (one gateway per
pipeline). This provides full isolation between the existing and new pipelines:
independent scaling, independent upgrades, and no shared failure domain.

#### Steps

Follow the [greenfield deployment](#1-greenfield-deployment) procedure with
these values adjusted for the new pipeline:

1. **Step 1 — Install Traefik CRDs:** Skip if CRDs were already installed
   during the first gateway deployment.
2. **Step 2 — Create the gateway client certificate:** Apply
   `certificates.yaml` with `namespace` set to the new pipeline's namespace.
   The same certificate spec can be reused; only the namespace differs. (Skip
   for TLS-disabled ingestion.)
3. **Step 3 — Configure Traefik routing:** Apply `routing.yaml` with the new
   pipeline's name, namespace, receiver port, and entrypoint name. The
   `traefik-instance` label value must be unique (for example,
   `<new-pipeline-name>-gateway`).
4. **Step 4 — Install Traefik:** Use a **distinct Helm release name** (for
   example, `traefik-<new-pipeline-name>`). The `labelSelector` must match the
   label set in step 3.
5. **Step 5 — Verify:** The new gateway receives its own LoadBalancer IP.

```text
Client A → 20.x.x.1:514 → Traefik instance 1 → [mTLS] → pipeline-1-service:514
Client B → 20.x.x.2:514 → Traefik instance 2 → [mTLS] → pipeline-2-service:514
```

> [!NOTE]
> Adding a new pipeline with its own gateway does **not** affect the existing
> gateway or its clients. No `helm upgrade` is required on the existing Traefik
> instance.

---

## Troubleshooting

### Check certificate status

```bash
kubectl get certificate -n <pipeline-namespace>
kubectl describe certificate gateway-client-cert -n <pipeline-namespace>
```

### Check Traefik routing

```bash
kubectl get ingressroutetcp -n <pipeline-namespace> -l traefik-instance=<pipeline-name>-gateway -o yaml
kubectl get serverstransporttcp -n <pipeline-namespace> -l traefik-instance=<pipeline-name>-gateway -o yaml
```

### Check Traefik logs for TLS errors

```bash
kubectl logs -n <pipeline-namespace> \
  -l app.kubernetes.io/instance=traefik-<pipeline-name> --tail=50 | grep -i "tls\|error\|certificate"
```

### Check pipeline pods are running

```bash
kubectl get pods -n <pipeline-namespace> -l pipeline=<pipeline-name>
```

### Check pipeline collector logs

```bash
kubectl logs -n <pipeline-namespace> -l pipeline=<pipeline-name> --tail=50
```

### Verify LoadBalancer IP is assigned

```bash
kubectl get svc traefik-<pipeline-name> -n <pipeline-namespace>
```

If the `EXTERNAL-IP` column shows `<pending>`, the cloud provider has not yet
assigned an IP. Verify that the cluster supports LoadBalancer-type services.

---

## Next steps

- Read more about [data collection rules (DCRs)](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview) in Azure Monitor.
- Learn about [Traefik](https://doc.traefik.io/traefik/) and the
  [Traefik Kubernetes CRD provider](https://doc.traefik.io/traefik/providers/kubernetes-crd/).