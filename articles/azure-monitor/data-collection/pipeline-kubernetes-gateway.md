---
title: Configure a Kubernetes gateway for Azure Monitor pipeline
description: Deploy a dedicated Kubernetes gateway for a new Azure Monitor pipeline receiver.
ai-usage: ai-assisted
ms.topic: how-to
ms.date: 03/20/2026
ms.custom: references_regions, devx-track-azurecli
---

# Configure a Kubernetes gateway for Azure Monitor pipeline

Azure Monitor pipeline services deploy as Kubernetes `ClusterIP` services, so clients outside the cluster can't reach them directly. A gateway exposes the receiver endpoint to external clients such as network devices, firewalls, and other telemetry sources.

This article shows how to deploy and manage a Traefik gateway for Azure Monitor pipeline. It covers a first deployment, adding a receiver to an existing gateway, onboarding another client to an existing receiver, and deploying another pipeline group on the same cluster.

> [!NOTE]
> This article uses Traefik as an example gateway implementation. You can use another gateway if it can expose the pipeline service to external clients and meet your security and routing requirements.
>
> This guidance assumes the cluster can deploy Kubernetes `LoadBalancer` services successfully, such as on a supported cloud provider like Azure.

## Prerequisites

- Azure Monitor pipeline installed and working. See [Configure Azure Monitor pipeline](./pipeline-configure.md).
- Access to `kubectl`, `helm`, and the target cluster.
- Access to the Traefik Helm repository from the workstation that runs `helm`.
- A deployed pipeline group and its Kubernetes service.
- A namespace label that allows the pipeline trust bundle to be distributed. Here's an example command:
  ```bash
  kubectl label namespace <pipeline-namespace> arc-amp-trust-bundle=true
  ```

## When to use this article

Use this article when clients outside the cluster need to send data to a pipeline receiver and the pipeline group doesn't already have a gateway. The recommended starting design is one dedicated gateway per pipeline group. That design keeps the setup easier and avoids sharing ports, upgrades, and failures across unrelated pipelines.

Use the later sections in this article if you already have a gateway and need to add a new receiver, onboard another client to an existing receiver, or deploy another pipeline group on the same cluster.

## Placeholders

This procedure uses multiple YAML files to define configuration. Placeholders in these files indicate where you need to add your own values. The following table describes the placeholders used in the YAML files in this article and gives example values.

| Placeholder | Description | Example |
|---|---|---|
| `<pipeline-name>` | Name of the Azure Monitor Pipeline Group resource | `syslog-pipeline` |
| `<pipeline-namespace>` | Kubernetes namespace where both the pipeline and the Traefik gateway are deployed | `test` |
| `<receiver-port>` | TCP port the pipeline receiver listens on | `514` syslog<br>`4317` OTLP |
| `<entrypoint-name>` | Name of the Traefik entrypoint for the receiver port | `tcp-syslog`, `tcp-otlp` |
| `<helm-release>` | Helm release name for the Traefik installation | `traefik-<pipeline-name>` |



## Single gateway for a new pipeline group

The cluster starts with no existing gateway or Azure Monitor pipeline. Deploy one gateway to one Azure Monitor pipeline group to start with. This deployment might include a backend TLS config of server-only TLS or mutual TLS (mTLS) configuration to secure ingestion, but the same steps apply for non-TLS ingestion.

```text
TLS-enabled:
  Client ── TCP ──▶ Traefik ══ mTLS or TLS ══▶ Pipeline Service:514

TLS-disabled:
  Client ── TCP ──▶ Traefik ── TCP ──▶ Pipeline Service:514
```


> [!IMPORTANT]
> Even though you're using only one pipeline, the following instructions include **label selectors** (`providers.kubernetesCRD.labelSelector` in the Helm values and matching `traefik-instance` labels on the routing resources). This configuration prepares the gateway for future multi-pipeline scenarios and avoids a disruptive Helm upgrade later. If you add a second pipeline in the future with its own dedicated gateway, label selectors ensure each Traefik instance only processes routes intended for its own pipeline.

### Install Traefik custom resource definitions (CRDs)

Install the Traefik CRDs once per cluster.

```bash
helm repo add traefik https://traefik.github.io/charts 2>/dev/null || true
helm repo update traefik
helm show crds traefik/traefik | kubectl apply -f -
```

### Configure gateway authentication

#### [TLS enabled](#tab/tls-enabled)

If the pipeline uses mTLS, the gateway needs a client certificate so it can authenticate to the pipeline backend.

> [!NOTE]
> **BYOC:** If your pipeline uses custom certificates, skip this file and ensure
> a `gateway-client-tls` Secret (with `tls.crt` and `tls.key` signed by your
> BYOC client CA) exists in the pipeline namespace.

Save the following as `certificates.yaml`:

```yaml
# certificates.yaml
# Creates a short-lived client certificate that the gateway presents to the
# Pipeline when dialing the mTLS backend.
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

Apply the certificate and wait for it to become ready.

```bash
kubectl apply -f certificates.yaml
kubectl wait --for=condition=ready certificate gateway-client-cert \
  -n <pipeline-namespace> --timeout=120s
```

Verify the secret was created:

```bash
kubectl get secret gateway-client-tls -n <pipeline-namespace>
```

#### [TLS disabled](#tab/tls-disabled)

Skip this step. The gateway doesn't need a client certificate when the pipeline receiver doesn't use TLS.

---

### Configure Traefik routing

#### [TLS enabled](#tab/tls-enabled)

When the pipeline uses TLS, create both a `ServersTransportTCP` resource and an `IngressRouteTCP` resource. The label selector prepares the gateway for future multi-pipeline scenarios without requiring a disruptive Helm change later.

Save the following code as `routing.yaml`.
```yaml
# routing.yaml
# Create one copy of each resource per receiver/port combination.
# For example, a pipeline exposing both syslog (514) and OTLP (4317) requires
# Two ServersTransportTCP and IngressRouteTCP pairs
---
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
      # Default TLS: use the managed trust bundle ConfigMap.
      - configMap: arc-amp-trust-bundle
      # BYOC: replace the line above with a reference to your BYOC server
      # root CA — the CA that signed the pipeline's server certificate.
      # Use 'secret' for a Secret or 'configMap' for a ConfigMap:
      #   - secret: <byoc-server-root-ca-secret>
      # The server certificate must include the serverName above as a DNS SAN.
      # See: https://learn.microsoft.com/azure/azure-monitor/data-collection/pipeline-tls-custom
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
          tls: true
          serversTransport: <pipeline-name>-mtls-transport
```

Apply the routing resources.

```bash
kubectl apply -f routing.yaml
```

#### [TLS disabled](#tab/tls-disabled)

When the pipeline doesn't use TLS, create only the `IngressRouteTCP` resource.

Save the following code as `routing.yaml`:

```yaml
# routing.yaml
# Create one copy of each resource per receiver/port combination.
# For example, a pipeline exposing both syslog (514) and OTLP (4317) requires two ServersTransportTCP + IngressRouteTCP pairs.
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
```

Apply the routing resource.

```bash
kubectl apply -f routing.yaml
```

---

### Install Traefik

Deploy Traefik in the same namespace as the pipeline. This deployment keeps the trust bundle ConfigMap and, when TLS is enabled, the gateway client certificate in the same namespace as the routing resources. Use the same command whether TLS is enabled or not.

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
> Helm might show a warning about resources that don't match the `labelSelector`. That warning refers to Traefik's default dashboard route, not to the pipeline routing resources in this article.

### Verify the gateway

1. Confirm the Traefik pod is running.

   ```bash
   kubectl get pods -n <pipeline-namespace> -l app.kubernetes.io/name=traefik
   ```

1. Get the external IP for the gateway service to validate it's provisioned successfully.

   ```bash
   GATEWAY_IP=$(kubectl get svc traefik-<pipeline-name> \
     -n <pipeline-namespace> \
     -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
   echo "Gateway IP: $GATEWAY_IP"
   ```

External clients use this gateway IP `$GATEWAY_IP:<receiver-port>` to send data to the pipeline.

### Certificate management for TLS-enabled ingestion

The gateway requires two pieces of TLS material to establish mTLS with the pipeline backend:

- **Client certificate** (`gateway-client-tls` Secret) — presented by Traefik
  to the pipeline. The pipeline's client CA must trust this certificate.
- **Server CA** (`rootCAs` in `ServersTransportTCP`) — used by Traefik to
  verify the pipeline's server certificate.

See the inline comments in `certificates.yaml` and `routing.yaml` for how to configure these certificates for default (automated) TLS versus [BYOC](pipeline-tls-custom.md).

### Troubleshooting

<details>
<summary>Check certificate status</summary>

```bash
kubectl get certificate -n <pipeline-namespace>
kubectl describe certificate gateway-client-cert -n <pipeline-namespace>
```

</details>

<details>
<summary>Check Traefik routing resources</summary>

```bash
kubectl get ingressroutetcp -n <pipeline-namespace> \
  -l traefik-instance=<pipeline-name>-gateway -o yaml
kubectl get serverstransporttcp -n <pipeline-namespace> \
  -l traefik-instance=<pipeline-name>-gateway -o yaml
```

</details>

<details>
<summary>Check Traefik logs for TLS or routing errors</summary>

```bash
kubectl logs -n <pipeline-namespace> \
  -l app.kubernetes.io/instance=traefik-<pipeline-name> --tail=50 | grep -Ei "tls\|error\|certificate"
```

</details>

<details>
<summary>Check pipeline pods and logs</summary>

```bash
kubectl get pods -n <pipeline-namespace> -l pipeline=<pipeline-name>
kubectl logs -n <pipeline-namespace> -l pipeline=<pipeline-name> --tail=50
```

</details>

<details>
<summary>Check the LoadBalancer IP assignment</summary>

```bash
kubectl get svc traefik-<pipeline-name> -n <pipeline-namespace>
```

If the external IP remains pending, verify that the cluster supports `LoadBalancer` services and that the cloud provider can allocate one.

</details>

## Add a new receiver to an existing pipeline group
You can configure the existing pipeline group with a new receiver. For example, you can add an OTLP receiver on port 4317 alongside an existing Syslog receiver on 514. The gateway must expose the new port.


### Create routing resources for the new receiver

Create a new `ServersTransportTCP` and `IngressRouteTCP` pair for the new receiver by using the same `routing.yaml` template described earlier in this article and supplying the new receiver values.

For an OTLP receiver example:

| Placeholder | Value |
|---|---|
| `<pipeline-name>` | same pipeline name as the existing deployment |
| `<pipeline-namespace>` | same pipeline namespace |
| `<entrypoint-name>` | `tcp-otlp` |
| `<receiver-port>` | `4317` |

The label (`traefik-instance: <pipeline-name>-gateway`) must match the `labelSelector` already configured on the existing Traefik instance.

```bash
kubectl apply -f routing-otlp.yaml
```

### Upgrade Traefik to open the new port

Run `helm upgrade` with `--reuse-values` to preserve the existing port definitions and add the new port:

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
> This `helm upgrade` triggers a pod restart. Existing client connections (including those on the syslog port) are briefly interrupted. Perform this action during a maintenance window.

#### Verify

```bash
kubectl get svc traefik-<pipeline-name> -n <pipeline-namespace> -o yaml
kubectl get ingressroutetcp -n <pipeline-namespace>
```

Confirm the service now exposes both ports (514 and 4317). Clients can connect to `$GATEWAY_IP:4317` for OTLP traffic.

## Add a new client to an existing receiver
An additional client needs to send data to the same receiver on the same port. For example, this client could be a second network switch sending syslog to port 514.

In this case, the gateway and the pipeline group require no changes. The new client connects to the same gateway external IP and port used by the existing client:

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
Point the new client at `$GATEWAY_IP:514`. No Helm upgrade, routing changes, or certificate changes are needed.

## New pipeline group instance
Deploy a new pipeline group alongside an existing pipeline group on the same cluster.

Deploy a new dedicated gateway for the new pipeline, one gateway per pipeline. This approach provides full isolation between the existing and new pipelines, including independent scaling, independent upgrades, and no shared failure domain.

Follow the preceding procedure for [Single gateway for new pipeline group](#single-gateway-for-a-new-pipeline-group), adjusting the following values for the new pipeline:

| Task | Guidance |
|---|---|
| Install Traefik CRDs | Skip this task if you already installed CRDs during the first gateway deployment. |
| Create the gateway client certificate | Apply `certificates.yaml` with `namespace` set to the new pipeline's namespace. You can reuse the same certificate spec because only the namespace changes. Skip this task for TLS-disabled ingestion. |
| Configure Traefik routing | Apply `routing.yaml` with the new pipeline name, namespace, receiver port, and entrypoint name. The `traefik-instance` label value must be unique. |
| Install Traefik | Use a distinct Helm release name, such as `traefik-<new-pipeline-name>`. The `labelSelector` must match the label set in the previous task. |
| Verify | Confirm that the new gateway receives its own LoadBalancer IP. |

```text
Client A → 20.x.x.1:514 → Traefik instance 1 → [mTLS] → pipeline-1-service:514
Client B → 20.x.x.2:514 → Traefik instance 2 → [mTLS] → pipeline-2-service:514
```

> [!NOTE]
> Adding a new pipeline with its own gateway doesn't affect the existing gateway or its clients. The existing Traefik instance doesn't require a `helm upgrade`.

## Related articles

- Continue the shared setup in [Configure Azure Monitor pipeline](./pipeline-configure.md).
- Configure TLS by using [Transport Layer Security (TLS) in Azure Monitor pipeline](./pipeline-tls.md).
- Configure your senders by using the gateway endpoint exposed in this article.
