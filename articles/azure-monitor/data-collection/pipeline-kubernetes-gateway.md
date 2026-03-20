---
title: Configure a Kubernetes gateway for Azure Monitor pipeline
description: Deploy a dedicated Kubernetes gateway for a new Azure Monitor pipeline receiver.
ai-usage: ai-assisted
ms.topic: how-to
ms.date: 03/20/2026
ms.custom: references_regions, devx-track-azurecli
---

# Configure a Kubernetes gateway for Azure Monitor pipeline

Azure Monitor pipeline services are deployed as Kubernetes `ClusterIP` services, so clients outside the cluster can't reach them directly. A gateway exposes the receiver endpoint to external clients such as network devices, firewalls, and other telemetry sources.

This article shows how to deploy a dedicated Traefik gateway for a new pipeline group. For a first deployment, start with one pipeline group and one dedicated gateway. If you need to modify an existing gateway deployment, see [Modify a Kubernetes gateway for Azure Monitor pipeline](./pipeline-kubernetes-gateway-brownfield.md).

> [!NOTE]
> Traefik is used in this article as an example gateway implementation. You can use another gateway if it can expose the pipeline service to external clients and meet your security and routing requirements.
>
> This guidance assumes the cluster can deploy Kubernetes `LoadBalancer` services successfully, such as on a supported cloud provider like Azure.

## Prerequisites

- Azure Monitor pipeline installed and working. See [Configure Azure Monitor pipeline](./pipeline-configure.md).
- Access to `kubectl`, `helm`, and the target cluster.
- Access to the Traefik Helm repository from the workstation that runs `helm`.
- A deployed pipeline group and its Kubernetes service.
- A namespace label that allows the pipeline trust bundle to be distributed:
  ```bash
  kubectl label namespace <pipeline-namespace> arc-amp-trust-bundle=true
  ```

## When to use this article

Use this article when clients outside the cluster need to send data to a pipeline receiver and the pipeline group doesn't already have a gateway. The recommended starting design is one dedicated gateway per pipeline group. That design keeps the setup easier and avoids sharing ports, upgrades, and failures across unrelated pipelines.

If you already have a gateway and need to add a new receiver, onboard another client to an existing receiver, or deploy another pipeline group on the same cluster, see [Modify a Kubernetes gateway for Azure Monitor pipeline](./pipeline-kubernetes-gateway-brownfield.md).

## Prepare the Traefik resources

The procedure below uses syslog on port `514`. Replace the placeholders with the values for your pipeline.

| Placeholder | Description | Example |
|:------------|:------------|:--------|
| `<pipeline-name>` | Azure Monitor pipeline group name. | `syslog-pipeline` |
| `<pipeline-namespace>` | Namespace that contains the pipeline and gateway. | `monitoring` |
| `<receiver-port>` | Receiver port exposed by the pipeline service. | `514` |
| `<entrypoint-name>` | Traefik entry point for that receiver port. | `tcp-syslog` |

> [!IMPORTANT]
> Even though only one pipeline is being used, the instructions below include **label selectors** (`providers.kubernetesCRD.labelSelector` in the Helm values and matching `traefik-instance` labels on the routing resources). This prepares the gateway for future multi-pipeline scenarios and avoids a disruptive Helm upgrade later. If a second pipeline is added in the future with its own dedicated gateway, label selectors ensure each Traefik instance only processes routes intended for its own pipeline.



### Install Traefik custom resource definitions (CRDs)

Install the Traefik CRDs once per cluster.

```bash
helm repo add traefik https://traefik.github.io/charts 2>/dev/null || true
helm repo update traefik
helm show crds traefik/traefik | kubectl apply -f -
```

## Configure gateway authentication

#### [TLS enabled](#tab/tls-enabled)

If the pipeline uses TLS, the gateway needs a client certificate so it can authenticate to the pipeline backend.

Save the following as `certificates.yaml`:

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

## Configure Traefik routing

#### [TLS enabled](#tab/tls-enabled)

When the pipeline uses TLS, create both a `ServersTransportTCP` resource and an `IngressRouteTCP` resource. The label selector prepares the gateway for future multi-pipeline scenarios without requiring a disruptive Helm change later.

Save the following as `routing.yaml` and replace the placeholders with your values. For a syslog receiver:

| Placeholder | Value |
|---|---|
| `<pipeline-name>` | your pipeline name |
| `<pipeline-namespace>` | your pipeline namespace |
| `<entrypoint-name>` | `tcp-syslog` |
| `<receiver-port>` | `514` |

```yaml
# routing.yaml
# Create one copy of each resource per receiver/port combination.
# For example, a pipeline exposing both syslog (514) and OTLP (4317) requires
# two ServersTransportTCP + IngressRouteTCP pairs.
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
          tls: true
          serversTransport: <pipeline-name>-mtls-transport
```

Apply the routing resources.

```bash
kubectl apply -f routing.yaml
```

#### [TLS disabled](#tab/tls-disabled)

When the pipeline does not use TLS, create only the `IngressRouteTCP` resource.

Save the following as `routing.yaml`:

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

Deploy Traefik in the same namespace as the pipeline. This keeps the trust bundle ConfigMap and, when TLS is enabled, the gateway client certificate in the same namespace as the routing resources.

#### [TLS](#tab/tls-enabled)

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

#### [TLS disabled](#tab/tls-disabled)

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

---

> [!NOTE]
> Helm might show a warning about resources that don't match the `labelSelector`. That warning refers to Traefik's default dashboard route, not to the pipeline routing resources in this article.

## Verify the gateway

1. Confirm the Traefik pod is running.

   ```bash
   kubectl get pods -n <pipeline-namespace> -l app.kubernetes.io/name=traefik
   ```

2. Get the external IP for the gateway service.

   ```bash
   GATEWAY_IP=$(kubectl get svc traefik-<pipeline-name> \
     -n <pipeline-namespace> \
     -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
   echo "Gateway IP: $GATEWAY_IP"
   ```

3. Verify the routing resources.

   ```bash
   kubectl get ingressroutetcp -n <pipeline-namespace>
   kubectl get serverstransporttcp -n <pipeline-namespace>
   ```

4. Check the Traefik logs for errors.

   ```bash
   kubectl logs -n <pipeline-namespace> \
     -l app.kubernetes.io/name=traefik --tail=50
   ```

Clients can now connect to `$GATEWAY_IP:<receiver-port>` to send data through the gateway to the pipeline.

## Certificate management for TLS-enabled ingestion

- Gateway client certificates are issued by `arc-amp-client-root-ca-cluster-issuer` and renewed by cert-manager.
- Pipeline server certificates are managed by the operator and rotate without downtime.
- Trust bundles are distributed automatically to namespaces labeled with `arc-amp-trust-bundle=true`.

## Troubleshooting

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
  -l app.kubernetes.io/instance=traefik-<pipeline-name> --tail=50 | grep -i "tls\|error\|certificate"
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

## Related content

- Modify an existing gateway deployment by using [Modify a Kubernetes gateway for Azure Monitor pipeline](./pipeline-kubernetes-gateway-brownfield.md).
- Plan advanced shared-gateway topologies by using [Azure Monitor pipeline - Traefik gateway for multiple pipelines](./pipeline-kubernetes-gateway-multiple.md).
- Configure TLS by using [Transport Layer Security (TLS) in Azure Monitor pipeline](./pipeline-tls.md).
- Configure your senders by using [Configure clients for Azure Monitor pipeline](./pipeline-configure-clients.md).