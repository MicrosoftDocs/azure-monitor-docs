---
title: Configure clients to use Azure Monitor pipeline
description: Use CLI or ARM templates to configure Azure Monitor pipeline which extends Azure Monitor data collection into your own data center. 
ms.topic: how-to
ms.date: 01/15/2026
ms.custom: references_regions, devx-track-azurecli
---

# Configure clients to use Azure Monitor pipeline

The [Azure Monitor pipeline](./pipeline-overview.md) extends the data collection capabilities of Azure Monitor to edge and multicloud environments. This article describes how to enable and configure the Azure Monitor pipeline in your environment.Once your pipeline extension and instance are installed, then you need to configure your clients to send data to the pipeline.

### Retrieve ingress endpoint

Each client requires the external IP address of the Azure Monitor pipeline service. Use the following command to retrieve this address:

```azurecli
kubectl get services -n <namespace where azure monitor pipeline was installed>
```

* If the application producing logs is external to the cluster, copy the *external-ip* value of the service *\<pipeline name\>-service* or *\<pipeline name\>-external-service* with the load balancer type.
* If the application is on a pod within the cluster, copy the *cluster-ip* value. 

> [!NOTE]
> If the external-ip field is set to *pending*, you need to configure an external IP for this ingress manually according to your cluster configuration.

| Client | Description |
|:-------|:------------|
| Syslog | Update Syslog clients to send data to the pipeline endpoint and the port of your Syslog dataflow. |
| OTLP | The Azure Monitor pipeline exposes a gRPC-based OTLP endpoint on port 4317. Configuring your instrumentation to send to this OTLP endpoint will depend on the instrumentation library itself. See [OTLP endpoint or Collector](https://opentelemetry.io/docs/instrumentation/python/exporters/#otlp-endpoint-or-collector) for OpenTelemetry documentation. The environment variable method is documented at [OTLP Exporter Configuration](https://opentelemetry.io/docs/concepts/sdk-configuration/otlp-exporter-configuration/). |

## Verify data

The final step is to verify that the data is received in the Log Analytics workspace. You can perform this verification by running a query in the Log Analytics workspace to retrieve data from the table.

:::image type="content" source="./media/pipeline-configure/log-results-syslog.png" lightbox="./media/pipeline-configure/log-results-syslog.png" alt-text="Screenshot of log query that returns of Syslog collection."::: 



## Next steps

* Modify data before it's sent to the cloud using [pipeline transformations](./pipeline-transformations.md).
