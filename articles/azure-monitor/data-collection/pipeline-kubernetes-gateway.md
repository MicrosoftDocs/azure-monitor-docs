---
title: Configure a Kubernetes gateway for Azure Monitor pipeline
description: Expose Azure Monitor pipeline receivers to clients outside the cluster by using a Kubernetes gateway.
ai-usage: ai-assisted
ms.topic: how-to
ms.date: 03/20/2026
ms.custom: references_regions, devx-track-azurecli
---

# Configure a Kubernetes gateway for Azure Monitor pipeline

Use this article after you complete the shared setup in [Configure Azure Monitor pipeline](./pipeline-configure.md). Azure Monitor pipeline services are deployed as Kubernetes `ClusterIP` services, so clients outside the cluster can't reach them directly. A gateway exposes the receiver endpoint to external clients such as network devices, firewalls, and other telemetry sources.

This article uses Traefik as the worked example. For a first deployment, the recommended path is one pipeline group and one dedicated gateway. Treat brownfield changes, shared gateways, and multi-pipeline layouts as advanced scenarios after the core path works.

> [!NOTE]
> Traefik is used in this article as an example gateway implementation. You can use another gateway if it can expose the pipeline service to external clients and meet your security and routing requirements.
>
> This guidance assumes the cluster can deploy Kubernetes `LoadBalancer` services successfully, such as on a supported cloud provider like Azure.

## Prerequisites

- Completion of [Configure Azure Monitor pipeline](./pipeline-configure.md).
- Access to `kubectl`, `helm`, and the target cluster.
- Access to the Traefik Helm repository from the workstation that runs `helm`.
- A deployed pipeline group and its Kubernetes service.
- A namespace label that allows the pipeline trust bundle to be distributed:

  ```bash
  kubectl label namespace <pipeline-namespace> arc-amp-trust-bundle=true
  ```

## When to use a gateway

Use a gateway when clients outside the cluster need to send data to a pipeline receiver and can't connect to the pipeline service directly. For a new deployment, start with one dedicated gateway per pipeline. That design keeps the setup easier to reason about and avoids sharing ports, upgrades, and failures across unrelated pipelines.

| Scenario | Recommended action |
|:---------|:-------------------|
| First deployment | Deploy one gateway for one pipeline group. |
| Add another client to an existing receiver | Reuse the existing gateway IP and port. No gateway changes are required. |
| Add a new receiver on a new port | Update the existing gateway to open the new port and add new routing resources. |
| Add another pipeline group on the same cluster | Deploy another dedicated gateway for the new pipeline group. |

## Prepare the Traefik resources

The greenfield procedure below uses syslog on port `514` as the running example. Replace the placeholders with the values for your pipeline.

| Placeholder | Description | Example |
|:------------|:------------|:--------|
| `<pipeline-name>` | Azure Monitor pipeline group name. | `syslog-pipeline` |
| `<pipeline-namespace>` | Namespace that contains the pipeline and gateway. | `monitoring` |
| `<receiver-port>` | Receiver port exposed by the pipeline service. | `514` |
| `<entrypoint-name>` | Traefik entry point for that receiver port. | `tcp-syslog` |

### Install Traefik custom resource definitions

Install the Traefik custom resource definitions once per cluster.

```bash
helm repo add traefik https://traefik.github.io/charts 2>/dev/null || true
helm repo update traefik
helm show crds traefik/traefik | kubectl apply -f -
```

### Create a gateway client certificate for TLS-enabled ingestion

If the pipeline uses TLS, the gateway needs a client certificate so it can authenticate to the pipeline backend. Skip this step when TLS is disabled.

Save the following as `certificates.yaml`:

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

Apply the certificate and wait for it to become ready.

```bash
kubectl apply -f certificates.yaml
kubectl wait --for=condition=ready certificate gateway-client-cert \
  -n <pipeline-namespace> --timeout=120s
kubectl get secret gateway-client-tls -n <pipeline-namespace>
```

## Deploy the gateway for a new pipeline

This is the recommended starting point for a greenfield deployment.

### Configure routing for TLS-enabled ingestion

When the pipeline uses TLS, create both a `ServersTransportTCP` resource and an `IngressRouteTCP` resource. The label selector prepares the gateway for future multi-pipeline scenarios without requiring a disruptive Helm change later.

Save the following as `routing.yaml`:

```yaml
apiVersion: traefik.io/v1alpha1
kind: ServersTransportTCP
metadata:
  name: <pipeline-name>-mtls-transport
  namespace: <pipeline-namespace>
  labels:
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
apiVersion: traefik.io/v1alpha1
kind: IngressRouteTCP
metadata:
  name: <pipeline-name>-<entrypoint-name>-route
  namespace: <pipeline-namespace>
  labels:
    traefik-instance: <pipeline-name>-gateway
spec:
  entryPoints:
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

### Configure routing for TLS-disabled ingestion

When the pipeline does not use TLS, create only the `IngressRouteTCP` resource.

Save the following as `routing.yaml`:

```yaml
apiVersion: traefik.io/v1alpha1
kind: IngressRouteTCP
metadata:
  name: <pipeline-name>-<entrypoint-name>-route
  namespace: <pipeline-namespace>
  labels:
    traefik-instance: <pipeline-name>-gateway
spec:
  entryPoints:
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

### Install Traefik

Deploy Traefik in the same namespace as the pipeline. This keeps the trust bundle ConfigMap and, when TLS is enabled, the gateway client certificate in the same namespace as the routing resources.

```bash
helm install traefik-<pipeline-name> traefik/traefik \
    --namespace <pipeline-namespace> \
    --set deployment.replicas=1 \
    --set providers.kubernetesIngress.enabled=false \
    --set providers.kubernetesCRD.enabled=true \
    --set "providers.kubernetesCRD.labelSelector=traefik-instance=<pipeline-name>-gateway" \
    --set ports.<entrypoint-name>.port=<receiver-port> \
    --set ports.<entrypoint-name>.expose.default=true \
    --set ports.<entrypoint-name>.exposedPort=<receiver-port> \
    --set ports.<entrypoint-name>.protocol=TCP \
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

4. Check the Traefik logs.

   ```bash
   kubectl logs -n <pipeline-namespace> \
     -l app.kubernetes.io/name=traefik --tail=50
   ```

Clients can now connect to `$GATEWAY_IP:<receiver-port>` to send data through the gateway to the pipeline.

## Modify an existing gateway deployment

Use these scenarios only after the base deployment works.

### Add a new receiver on a new port

Create a new `ServersTransportTCP` and `IngressRouteTCP` pair for the new receiver if TLS is enabled, or a new `IngressRouteTCP` if TLS is disabled. Then run `helm upgrade` with `--reuse-values` to add the new port.

For example, to add an OTLP receiver on port `4317`:

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
> `helm upgrade` restarts the Traefik pod. Existing client connections through that gateway are interrupted briefly, so do this during a maintenance window when possible.

### Add a new client to an existing receiver

No gateway changes are required. Point the new client to the existing gateway IP and receiver port.

```bash
GATEWAY_IP=$(kubectl get svc traefik-<pipeline-name> \
  -n <pipeline-namespace> \
  -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo "Gateway IP: $GATEWAY_IP"
```

### Add another pipeline group on the same cluster

Deploy another dedicated gateway for the new pipeline group by following the same greenfield procedure in this article with a different pipeline name, namespace, and Helm release. This keeps the pipelines isolated for upgrades, scaling, and failures.

Shared gateways across multiple pipelines are possible, but they are an advanced exception path. They require unique external ports for each pipeline, routing resources in each pipeline namespace, replicated trust bundle and certificate dependencies per namespace, and upgrades that can interrupt traffic for every pipeline that shares the gateway.

## Certificate management for TLS-enabled ingestion

- Gateway client certificates are issued by `arc-amp-client-root-ca-cluster-issuer` and renewed by cert-manager.
- Pipeline server certificates are managed by the operator and rotate without downtime.
- Trust bundles are distributed automatically to namespaces labeled with `arc-amp-trust-bundle=true`.

## Troubleshooting

### Check certificate status

```bash
kubectl get certificate -n <pipeline-namespace>
kubectl describe certificate gateway-client-cert -n <pipeline-namespace>
```

### Check Traefik routing resources

```bash
kubectl get ingressroutetcp -n <pipeline-namespace> \
  -l traefik-instance=<pipeline-name>-gateway -o yaml
kubectl get serverstransporttcp -n <pipeline-namespace> \
  -l traefik-instance=<pipeline-name>-gateway -o yaml
```

### Check Traefik logs for TLS or routing errors

```bash
kubectl logs -n <pipeline-namespace> \
  -l app.kubernetes.io/instance=traefik-<pipeline-name> --tail=50 | grep -i "tls\|error\|certificate"
```

### Check pipeline pods and logs

```bash
kubectl get pods -n <pipeline-namespace> -l pipeline=<pipeline-name>
kubectl logs -n <pipeline-namespace> -l pipeline=<pipeline-name> --tail=50
```

### Check the LoadBalancer IP assignment

```bash
kubectl get svc traefik-<pipeline-name> -n <pipeline-namespace>
```

If the external IP remains pending, verify that the cluster supports `LoadBalancer` services and that the cloud provider can allocate one.

## Next steps

- Configure TLS by using [Transport Layer Security (TLS) in Azure Monitor pipeline](./pipeline-tls.md).
- Configure your senders by using [Configure clients for Azure Monitor pipeline](./pipeline-configure-clients.md).

