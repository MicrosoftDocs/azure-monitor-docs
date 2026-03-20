---
title: Modify a Kubernetes gateway for Azure Monitor pipeline
description: Modify an existing Kubernetes gateway for Azure Monitor pipeline by adding ports, clients, or another pipeline group.
ai-usage: ai-assisted
ms.topic: how-to
ms.date: 03/20/2026
ms.custom: references_regions, devx-track-azurecli
---

# Modify a Kubernetes gateway for Azure Monitor pipeline

Use this article after you deploy and verify a gateway for Azure Monitor pipeline. It shows how to extend an existing Traefik-based deployment when you add a receiver, onboard another client to an existing receiver, or deploy another pipeline group on the same cluster.

For a first deployment, see [Configure a Kubernetes gateway for Azure Monitor pipeline](./pipeline-kubernetes-gateway.md).

> [!NOTE]
> Traefik is used in this article as an example gateway implementation. You can use another gateway if it can expose the pipeline service to external clients and meet your security and routing requirements.
>
> This guidance assumes the cluster can deploy Kubernetes `LoadBalancer` services successfully, such as on a supported cloud provider like Azure.

## Prerequisites

- A working gateway deployment for Azure Monitor pipeline. See [Configure a Kubernetes gateway for Azure Monitor pipeline](./pipeline-kubernetes-gateway.md).
- Access to `kubectl`, `helm`, and the target cluster.
- The Traefik custom resource definitions installed on the cluster.
- The existing pipeline group and its Kubernetes service.
- For a new pipeline namespace, a namespace label that allows the pipeline trust bundle to be distributed:
  ```bash
  kubectl label namespace <pipeline-namespace> arc-amp-trust-bundle=true
  ```

## Choose the modification

Use the procedure that matches the change you need to make.

| Scenario | Use this procedure |
|:---------|:-------------------|
| Add a new receiver on a new port to an existing pipeline group | [Add a new receiver on a new port](#add-a-new-receiver-on-a-new-port) |
| Add another client to an existing receiver | [Add another client to an existing receiver](#add-another-client-to-an-existing-receiver) |
| Add another pipeline group on the same cluster | [Add another pipeline group on the same cluster](#add-another-pipeline-group-on-the-same-cluster) |

## Add a new receiver on a new port

Use this procedure when the pipeline group already has a gateway and you need to expose another receiver, such as OTLP on port `4317`, through the same gateway.

1. Save a routing file for the new receiver as `routing-<entrypoint-name>.yaml`.

   For TLS-enabled ingestion, use the following YAML:

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

   If TLS is disabled for that receiver, remove the `ServersTransportTCP` resource and remove the `tls` and `serversTransport` fields from the `IngressRouteTCP` service definition.

2. Apply the new routing resources.

   ```bash
   kubectl apply -f routing-<entrypoint-name>.yaml
   ```

3. Upgrade the existing Traefik release to open the new port.

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

4. Verify that the gateway now exposes the new port.

   ```bash
   kubectl get svc traefik-<pipeline-name> -n <pipeline-namespace>
   kubectl get ingressroutetcp -n <pipeline-namespace>
   kubectl get serverstransporttcp -n <pipeline-namespace>
   ```

## Add another client to an existing receiver

Use this procedure when another client needs to connect to the same receiver and port that the gateway already exposes.

1. Retrieve the existing gateway IP address.

   ```bash
   GATEWAY_IP=$(kubectl get svc traefik-<pipeline-name> \
     -n <pipeline-namespace> \
     -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
   echo "Gateway IP: $GATEWAY_IP"
   ```

2. Point the new client to the existing gateway IP and receiver port.

   No gateway changes are required. Reuse the same IP and port that the current clients use for that receiver.

3. Verify that the client can reach the receiver.

   ```bash
   kubectl logs -n <pipeline-namespace> \
     -l app.kubernetes.io/name=traefik --tail=50
   kubectl logs -n <pipeline-namespace> -l pipeline=<pipeline-name> --tail=50
   ```

## Add another pipeline group on the same cluster

Use this procedure when the cluster already has one working gateway and you need to deploy another dedicated gateway for a different pipeline group.

1. Label the new pipeline namespace so the trust bundle is distributed there.

   ```bash
   kubectl label namespace <pipeline-namespace> arc-amp-trust-bundle=true
   ```

2. If the new pipeline uses TLS, save the following as `certificates.yaml` in the new pipeline namespace and apply it.

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

   ```bash
   kubectl apply -f certificates.yaml
   kubectl wait --for=condition=ready certificate gateway-client-cert \
     -n <pipeline-namespace> --timeout=120s
   kubectl get secret gateway-client-tls -n <pipeline-namespace>
   ```

3. Save the routing resources for the new pipeline as `routing.yaml`.

   For TLS-enabled ingestion, use the following YAML:

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

   If TLS is disabled for the new pipeline receiver, remove the `ServersTransportTCP` resource and remove the `tls` and `serversTransport` fields from the `IngressRouteTCP` service definition.

4. Apply the routing resources for the new pipeline.

   ```bash
   kubectl apply -f routing.yaml
   ```

5. Install a dedicated Traefik release for the new pipeline group.

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

6. Verify the new gateway deployment.

   ```bash
   kubectl get pods -n <pipeline-namespace> -l app.kubernetes.io/name=traefik
   kubectl get svc traefik-<pipeline-name> -n <pipeline-namespace>
   kubectl get ingressroutetcp -n <pipeline-namespace>
   kubectl get serverstransporttcp -n <pipeline-namespace>
   ```

This dedicated-gateway pattern keeps the pipeline groups isolated for upgrades, scaling, and failures.

Shared gateways across multiple pipelines are possible, but they are an advanced exception path. They require unique external ports for each pipeline, routing resources in each pipeline namespace, replicated trust bundle and certificate dependencies per namespace, and upgrades that can interrupt traffic for every pipeline that shares the gateway.

## Troubleshooting

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

## Related content

- Deploy a new gateway by using [Configure a Kubernetes gateway for Azure Monitor pipeline](./pipeline-kubernetes-gateway.md).
- Plan advanced shared-gateway topologies by using [Azure Monitor pipeline - Traefik gateway for multiple pipelines](./pipeline-kubernetes-gateway-multiple.md).
- Configure TLS by using [Transport Layer Security (TLS) in Azure Monitor pipeline](./pipeline-tls.md).
- Configure your senders by using [Configure clients for Azure Monitor pipeline](./pipeline-configure-clients.md).