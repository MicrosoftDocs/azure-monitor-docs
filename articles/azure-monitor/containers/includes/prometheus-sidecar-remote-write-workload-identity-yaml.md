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
      # Supported CLOUD values: AZUREPUBLIC (default), AZUREGOVERNMENT, AZURECHINA, AZURECUSTOM.
      # For Azure Government, uncomment CLOUD and INGESTION_AAD_AUDIENCE.
      # - name: CLOUD
      #   value: AZUREGOVERNMENT
      # - name: INGESTION_AAD_AUDIENCE
      #   value: https://monitor.azure.us/.default
      # For other sovereign or custom clouds, use AZURECUSTOM.
      # The workload identity webhook automatically injects the authority host.
      # - name: CLOUD
      #   value: AZURECUSTOM
      # - name: INGESTION_AAD_AUDIENCE
      #   value: <audience-url-for-your-cloud>/.default
```