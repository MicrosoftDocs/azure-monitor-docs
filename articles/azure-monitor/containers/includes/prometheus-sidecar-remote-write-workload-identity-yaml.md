---
ms.topic: include
ms.date: 05/21/2025
---

```yml
prometheus:
  prometheusSpec:
    externalLabels:
          cluster: <AKS-CLUSTER-NAME>
    podMetadata:
        labels:
            azure.workload.identity/use: "true"
    ## https://prometheus.io/docs/prometheus/latest/configuration/configuration/#remote_write    
    remoteWrite:
    - url: 'http://localhost:8081/api/v1/write'

    containers:
    - name: prom-remotewrite
      image: <CONTAINER-IMAGE-VERSION>
      imagePullPolicy: Always
      ports:
        - name: rw-port
          containerPort: 8081
      env:
      - name: INGESTION_URL
        value: <INGESTION_URL>
      - name: LISTENING_PORT
        value: '8081'
      - name: IDENTITY_TYPE
        value: workloadIdentity
      # Required for non-public clouds.
      # Supported CLOUD values: AZURE_PUBLIC (default), AZURE_GOVERNMENT, AZURE_CHINA, AZURE_CUSTOM.
      # For Azure Government, uncomment CLOUD and INGESTION_AAD_AUDIENCE.
      # - name: CLOUD
      #   value: AZURE_GOVERNMENT
      # - name: INGESTION_AAD_AUDIENCE
      #   value: https://monitor.azure.us/.default
      # For air-gapped/sovereign clouds (e.g. USNat, USSec), use AZURE_CUSTOM and also set AAD_HOST_ENDPOINT.
      # - name: CLOUD
      #   value: AZURE_CUSTOM
      # - name: AAD_HOST_ENDPOINT
      #   value: <authority-host-url-for-your-cloud>
      # - name: INGESTION_AAD_AUDIENCE
      #   value: <audience-url-for-your-cloud>/.default
```