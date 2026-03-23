---
title: Ingest OTLP Data into Azure Monitor with OTel Collector (Preview)
description: Learn how to send OpenTelemetry Protocol (OTLP) telemetry data directly to Azure Monitor cloud ingestion endpoints using the OpenTelemetry Collector.
ms.topic: how-to
ms.date: 03/19/2026
ai-usage: ai-assisted
---

# Ingest OTLP data into Azure Monitor with OTel Collector (Preview)

Azure Monitor now supports native ingestion of OpenTelemetry Protocol (OTLP) signals, enabling you to send telemetry data directly from OpenTelemetry-instrumented applications to Azure Monitor.

> [!IMPORTANT]
> * This feature is a **preview**. Preview features are provided without a service-level agreement and aren't recommended for production workloads.
> * For more information, see [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).

## Overview

Azure Monitor can receive OTLP signals through three ingestion mechanisms:

* **OpenTelemetry Collector** - Send data directly to Azure Monitor cloud ingestion endpoints from any OTel Collector deployment.
<<<<<<< HEAD
* **Azure Monitor Agent (AMA)** - Ingest data from applications running on Azure VMs, Virtual Machine Scale Sets, or Azure Arc-enabled servers.
=======
* **Azure Monitor Agent (AMA)** - Ingest data from applications running on Azure VMs, Virtual Machine Scale Sets, or Azure Arc-enabled servers. See [Ingest OTLP data into Azure Monitor with AMA](opentelemetry-ingest-agent.md) for details.
>>>>>>> b6f7dc3efbcf20631ba1eee9163ca0e619b27dab
* **Azure Kubernetes Service (AKS) add-on** - Collect telemetry from containerized applications in AKS clusters. See [Enable Azure Monitor OpenTelemetry for Kubernetes clusters](kubernetes-open-protocol.md) for details.

This article covers the OTel Collector method of collecting OTLP signals.

## Prerequisites

> [!div class="checklist"]
> * Azure subscription: If you don't have one, [create an Azure subscription for free](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn).
> * [OpenTelemetry SDK](https://opentelemetry.io/docs/languages/) instrumented application (any supported language).
> * For OpenTelemetry Collector deployments: Collector version 0.132.0 or higher with the Azure Authentication extension.

## Set up OTLP data ingestion

You can configure OTLP data ingestion in Azure Monitor using one of two approaches. The Application Insights-based approach is recommended for most scenarios as it automates resource creation and enables built-in troubleshooting experiences.

### Option 1: Create an Application Insights resource with OTLP support (Recommended)

This method automatically provisions all required Azure resources and configures their relationships, enabling you to use Application Insights for application performance monitoring, distributed tracing, and failure analysis.

1. Register the Application Insights OTLP preview features and provider:

    ```bash
    az feature register --name OtlpApplicationInsights --namespace Microsoft.Insights
    az feature list -o table --query "[?contains(name, 'Microsoft.Insights/OtlpApplicationInsights')].{Name:name,State:properties.state}"
    
    az provider register -n Microsoft.Insights
    ```

1. In the Azure portal, create a new Application Insights resource.

1. On the **Basics** tab, select the **Enable OTLP support** checkbox.

    :::image type="content" source="./media/opentelemetry-protocol-ingestion/create-app-insights-resource.png" lightbox="./media/opentelemetry-protocol-ingestion/create-app-insights-resource.png" alt-text="Screenshot showing the Create Application Insights page with Enable OTLP support option selected.":::

1. Complete the resource creation process.

1. After deployment, navigate to the **Overview** page of your Application Insights resource.

1. Locate the **OTLP Connection Info** section and copy the following values:

    * Data Collection Rule (DCR) resource ID
    * Endpoint URLs for traces, logs, and metrics (if using OpenTelemetry Collector)
    
    :::image type="content" source="./media/opentelemetry-protocol-ingestion/connection-info.png" lightbox="./media/opentelemetry-protocol-ingestion/connection-info.png" alt-text="Screenshot showing OTLP connection information on the Application Insights Overview page.":::

Proceed to [Configure your OpenTelemetry Collector](#configure-your-opentelemetry-collector).

### Option 2: Manual resource orchestration

This option requires you to manually create and configure Data Collection Endpoints (DCE), Data Collection Rules (DCR), and destination workspaces. Use this approach when you need custom configurations or want to reuse existing resources.

#### Create destination workspaces

If you don't have existing workspaces, create the following resources in the same Azure region:

* **Log Analytics workspace (LAW)** - Stores log and trace data
* **Azure Monitor workspace (AMW)** - Stores metrics data

Record the resource IDs of both workspaces for later use.

#### (Optional) Create an Application Insights resource

To enable Application Insights troubleshooting experiences with your OTLP data:

1. Create an Application Insights resource in the same region as your workspaces.
1. Clear the **Enable OTLP support** checkbox to avoid creating duplicate resources.
1. Copy the Application Insights resource ID.

> [!NOTE]
> If you skip this step you need to modify the ARM template in the next section to remove Application Insights references.

#### Deploy the Data Collection Endpoint and Rule

1. In the Azure portal, search for **Deploy a custom template** and select it.

1. Select **Build your own template in the editor**.

1. Copy the template content from the [Azure Monitor Community repository](https://github.com/microsoft/AzureMonitorCommunity/blob/master/Azure%20Services/Azure%20Monitor/OpenTelemetry/OTLP_DCE_DCR_ARM_Template.txt).

1. Paste the template into the editor and update the parameters with your workspace resource IDs and (optionally) Application Insights resource ID.

1. Set the location to match your workspace region.

1. Review and create the deployment.

1. After deployment completes, navigate to the created DCR and copy its resource ID from the **Overview** page.

## Configure your OpenTelemetry Collector

### Configure Microsoft Entra authentication

The OpenTelemetry Collector requires Microsoft Entra authentication to send data to Azure Monitor.

**For Azure VMs and Virtual Machine Scale Sets:**

1. Enable system-assigned managed identity on your compute resource.
1. Assign the **Monitoring Metrics Publisher** role to the managed identity.
1. Leave the `managed_identity` section blank in your collector configuration to use the system-assigned identity.

**For non-Azure environments:**

Configure the Azure Authentication extension in your collector with an appropriate Microsoft Entra identity:

```yaml
extensions:
  azureauth/monitor:
    managed_identity:
      client_id: "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"  # Your identity client ID
    scopes:
      - https://monitor.azure.com/.default
```

For workload identities, service principals, or other Microsoft Entra identities, provide the `client_id` of the identity that needs to authenticate.

### Grant permissions to the Data Collection Rule

The identity used by your collector needs permission to write data to your DCR:

1. Navigate to your DCR in the Azure portal.

1. Select **Access control (IAM)** in the left navigation.

1. Select **Add** > **Add role assignment**.

    :::image type="content" source="./media/opentelemetry-protocol-ingestion/data-collection-rule-access-control.png" lightbox="./media/opentelemetry-protocol-ingestion/data-collection-rule-access-control.png" alt-text="Screenshot showing how to add a role assignment to a Data Collection Rule.":::

1. Select **Monitoring Metrics Publisher** and select **Next**.

    :::image type="content" source="./media/opentelemetry-protocol-ingestion/role-assignment-metrics-publisher.png" lightbox="./media/opentelemetry-protocol-ingestion/role-assignment-metrics-publisher.png" alt-text="Screenshot showing the Monitoring Metrics Publisher role selection.":::

1. For **Assign access to**, select **User, group, or service principal**.

1. Select **Select members** and choose your application or managed identity.

    :::image type="content" source="./media/opentelemetry-protocol-ingestion/role-assignment-select-members.png" lightbox="./media/opentelemetry-protocol-ingestion/role-assignment-select-members.png" alt-text="Screenshot showing member selection for role assignment.":::

1. Select **Review + assign** to save the role assignment.

### Construct endpoint URLs

If you created your resources using the Application Insights method, you already have the endpoint URLs from the OTLP Connection Info section. Skip to [Update collector configuration](#update-collector-configuration).

For manually orchestrated resources, construct the endpoint URLs:

1. Navigate to your Data Collection Endpoint in the Azure portal.

1. Select **JSON View** from the **Overview** page.

1. Copy the `logsIngestion` and `metricsIngestion` endpoint values:

    ```json
    "logsIngestion": {
        "endpoint": "https://<name>.<location>-1.ingest.monitor.azure.com"
    },
    "metricsIngestion": {
        "endpoint": "https://<name>.<location>-1.metrics.ingest.monitor.azure.com"
    }
    ```

1. Navigate to your Data Collection Rule and copy the **Immutable ID** from the **Overview** page.

1. Construct your endpoint URLs using this pattern:

    **Metrics endpoint:**
    ```
    https://<metrics-dce-domain>/datacollectionRules/<dcr-immutable-id>/streams/microsoft-otelmetrics/otlp/v1/metrics
    ```
    
    **Logs endpoint:**
    ```
    https://<logs-dce-domain>/datacollectionRules/<dcr-immutable-id>/streams/Microsoft-OTLP-Logs/otlp/v1/logs
    ```
    
    **Traces endpoint:**
    ```
    https://<logs-dce-domain>/datacollectionRules/<dcr-immutable-id>/streams/Microsoft-OTLP-Traces/otlp/v1/traces
    ```
    
    > [!NOTE]
    > The traces endpoint uses the logs DCE domain.

### Update collector configuration

Configure your OpenTelemetry Collector with the authentication extension and Azure Monitor endpoints. Here's a sample configuration:

```yaml
receivers:
  otlp:
    protocols:
      grpc:
        endpoint: localhost:4317
      http:
        endpoint: localhost:4318

processors:
  batch:

extensions:
  azureauth/monitor:
    use_default: true
    scopes:
      - https://monitor.azure.com/.default

exporters:
  otlphttp/azuremonitor:
    traces_endpoint: "https://<logs-dce-domain>/datacollectionRules/<dcr-immutable-id>/streams/opentelemetry_traces/otlp/v1/traces"
    logs_endpoint: "https://<logs-dce-domain>/datacollectionRules/<dcr-immutable-id>/streams/opentelemetry_logs/otlp/v1/logs"
    metrics_endpoint: "https://<metrics-dce-domain>/datacollectionRules/<dcr-immutable-id>/streams/microsoft-otelmetrics/otlp/v1/metrics"
    auth:
      authenticator: azureauth/monitor

service:
  extensions:
    - azureauth/monitor
  pipelines:
    traces:
      receivers: [otlp]
      processors: [batch]
      exporters: [otlphttp/azuremonitor]
    metrics:
      receivers: [otlp]
      processors: [batch]
      exporters: [otlphttp/azuremonitor]
    logs:
      receivers: [otlp]
      processors: [batch]
      exporters: [otlphttp/azuremonitor]
```

> [!IMPORTANT]
> - Application Insights experiences including prebuilt dashboards and queries expect and require OTLP metrics with delta temporality and exponential histogram aggregation.
>
> - If you emit OTLP metrics from an OpenTelemetry SDK, configure your OTLP exporter to produce the metrics with delta temporality. For more information, see [Metrics Exporters - OTLP](https://opentelemetry.io/docs/specs/otel/metrics/sdk_exporters/otlp/).
>
> - If OTLP metrics received by the OpenTelemetry collector are in cumulative temporality, add `processors: [cumulativetodelta]` to the metrics section of the OpenTelemetry collector config to convert to delta. For more information, see [cumulativetodeltaprocessor on GitHub](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/processor/cumulativetodeltaprocessor).


## Next steps

<<<<<<< HEAD
=======
* [Ingest OTLP data with Azure Monitor Agent](opentelemetry-ingest-agent.md)
>>>>>>> b6f7dc3efbcf20631ba1eee9163ca0e619b27dab
* [OpenTelemetry on Azure](../app/opentelemetry-overview.md)
* [Monitor AKS with OpenTelemetry](kubernetes-open-protocol.md)
* [Dashboards with Grafana in Application Insights](../app/grafana-dashboards.md)
* [OpenTelemetry documentation](https://opentelemetry.io/docs/)
