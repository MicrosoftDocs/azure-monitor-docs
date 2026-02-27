---
title: Azure Monitor pipeline - Gateway for Kubernetes deployment
description: Secure the connection from your Azure Monitor pipeline to Azure Monitor by configuring TLS.
ms.topic: article
ms.date: 01/15/2026
ms.custom: references_regions, devx-track-azurecli
---

# Azure Monitor pipeline - Sample gateway setup using Traefik
Azure Monitor pipeline extension gets deployed with ClusterIP services, which are only accessible within the Kubernetes cluster. To expose these pipelines to remote clients external to the cluster (e.g. network switches, firewall devices), you need to deploy a gateway solution.  
This guide shows how to expose an Azure Monitor Pipeline receiver to external clients using a Traefik gateway. 

## Prerequisites

See the prerequisites in [Configure Azure Monitor pipeline](./pipeline-configure#prerequisites) for details on the requirements for enabling and configuring the Azure Monitor pipeline. 
Before deploying the Traefik gateway, here are additional prerequisites:

- **Traefik** Helm chart is available 
- **Namespace labeled** for trust bundle distribution:

```bash
kubectl label namespace <pipeline-namespace> arc-amp-trust-bundle=true
```

## Deploy gateway for TLS secure encrypted ingestion 

### Step 1: Create gateway client certificate

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

###  Troubleshooting

**Check certificate status**

```bash
kubectl get certificate -n test
kubectl describe certificate gateway-client-cert -n test
```

**Check Traefik routing**

```bash
kubectl get ingressroutetcp -n test -o yaml
kubectl get serverstransporttcp -n test -o yaml
```

**Check Traefik logs for TLS errors**

```bash
kubectl logs -n test -l app.kubernetes.io/name=traefik --tail=50 | grep -i "tls\|error\|certificate"
```

**Check pipeline logs**

```bash
kubectl logs -n test -l pipeline=syslog-pipeline
```


## Deploy gateway for ingestion with TLS disabled

### Step 1: Install Traefik CRDs

```bash
helm repo add traefik https://traefik.github.io/charts 2>/dev/null || true
helm repo update traefik
helm show crds traefik/traefik | kubectl apply -f -
```

### Step 2: Configure Traefik TCP Routing

The Traefik `IngressRouteTCP` routes TCP directly to the pipeline service.

Save the following as `routing.yaml`:

```yaml
apiVersion: traefik.io/v1alpha1
kind: IngressRouteTCP
metadata:
  name: syslog-route
  namespace: <pipeline-namespace>
spec:
  entryPoints:
    - tcp-syslog
  routes:
    - match: HostSNI(`*`)
      services:
        - name: <pipeline-name>-service
          port: 514
```

Apply:

```bash
kubectl apply -f routing.yaml
```

### Step 3: Install Traefik

Deploy Traefik in the **same namespace** as the pipeline:

```bash
helm install traefik traefik/traefik \
    --namespace <pipeline-namespace> \
    --set deployment.replicas=1 \
    --set providers.kubernetesIngress.enabled=false \
    --set providers.kubernetesCRD.enabled=true \
    --set ports.tcp-syslog.port=514 \
    --set ports.tcp-syslog.expose.default=true \
    --set ports.tcp-syslog.exposedPort=514 \
    --set ports.tcp-syslog.protocol=TCP \
    --set ports.web.expose.default=false \
    --set ports.websecure.expose.default=false \
    --set service.type=LoadBalancer \
    --wait
```

### Step 4: Get the Gateway's external IP

```bash
GATEWAY_IP=$(kubectl get svc traefik -n <pipeline-namespace> \
  -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo "Gateway IP: $GATEWAY_IP"
```

Use <GATEWAY_IP:514> to send syslogs to the pipeline from a remote client.

---

## Troubleshooting

### Check pipeline pods are running

```bash
kubectl get pods -n <pipeline-namespace> -l pipeline=<pipeline-name>
```

### Check pipeline collector logs

```bash
kubectl logs -n <pipeline-namespace> -l pipeline=<pipeline-name> --tail=50
```

### Check Traefik is running

```bash
kubectl get pods -n <pipeline-namespace> -l app.kubernetes.io/name=traefik
```

### Check IngressRouteTCP is configured

```bash
kubectl get ingressroutetcp -n <pipeline-namespace> -o yaml
```

### Check Traefik logs for routing errors

```bash
kubectl logs -n <pipeline-namespace> -l app.kubernetes.io/name=traefik --tail=50
```

## Next steps
- Read more about [data collection rules (DCRs)](../data-collection/data-collection-rule-overview.md) in Azure Monitor.

