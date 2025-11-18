---
title: Ingest OpenTelemetry Protocol Signals Into Azure Monitor (Limited Preview)
description: Learn how to send OpenTelemetry Protocol (OTLP) telemetry data directly to Azure Monitor using native ingestion endpoints.
ms.topic: how-to
ms.date: 11/18/2025
ROBOTS: NOINDEX
---

# Ingest OpenTelemetry Protocol signals into Azure Monitor (Limited Preview)

Azure Monitor now supports native ingestion of OpenTelemetry Protocol (OTLP) signals, enabling you to send telemetry data directly from OpenTelemetry-instrumented applications to Azure Monitor without vendor-specific agents or exporters.

> [!IMPORTANT]
> * This feature is a **limited preview**. Preview features are provided without a service-level agreement and aren't recommended for production workloads.
> * For more information, see [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).

> [!NOTE]
> * [Support](#support) for this feature is limited to enrolled subscriptions.
> * [Submit a request](https://aka.ms/azuremonitorotelpreview) to participate.

## Overview

Azure Monitor can receive OTLP signals through three ingestion mechanisms:

* **OpenTelemetry Collector** - Send data directly to Azure Monitor cloud ingestion endpoints from any OTel Collector deployment
* **Azure Monitor Agent (AMA)** - Ingest data from applications running on Azure VMs, Virtual Machine Scale Sets, or Azure Arc-enabled servers
* **Azure Kubernetes Service (AKS) add-on** - Collect telemetry from containerized applications in AKS clusters

This article covers the OpenTelemetry Collector and Azure Monitor Agent methods. For AKS deployments, see [Enable Azure Monitor OpenTelemetry for Kubernetes clusters](../app/kubernetes-open-protocol.md).

## Prerequisites

* An Azure subscription
* [OpenTelemetry SDK](https://opentelemetry.io/docs/languages/) instrumented application (any supported language)
* For VM/VMSS deployments: Azure Monitor Agent version 1.38.1 or higher (Windows) or 1.37.0 or higher (Linux)
* For OpenTelemetry Collector deployments: Collector version 0.132.0 or higher with the Azure Authentication extension

## Choose a deployment method

Select the deployment method that best fits your compute environment:

| Compute environment | Recommended method | Benefits |
|---------------------|--------------------|----------|
| Azure VM, VMSS, or Arc-enabled servers | Azure Monitor Agent | Simplified configuration, no collector management, automatic credential handling |
| Non-Azure compute, containers, or multi-cloud | OpenTelemetry Collector | Maximum flexibility, vendor-neutral, works across any environment |
| Azure Kubernetes Service | AKS add-on | Native integration, automatic pod discovery, minimal configuration |

## Set up OTLP data collection

You can configure OTLP data collection in Azure Monitor using one of two approaches. The Application Insights-based approach is recommended for most scenarios as it automates resource creation and enables built-in troubleshooting experiences.

### Option 1: Create an Application Insights resource with OTLP support (Recommended)

This method automatically provisions all required Azure resources and configures their relationships, enabling you to use Application Insights for application performance monitoring, distributed tracing, and failure analysis.

1. In the Azure portal, create a new Application Insights resource.

1. On the **Basics** tab, select the **Enable OTLP support** checkbox.

    :::image type="content" source="./media/azure-monitor-otlp-ingestion/create-app-insights-resource.png" lightbox="./media/azure-monitor-otlp-ingestion/create-app-insights-resource.png" alt-text="Screenshot showing the Create Application Insights page with Enable OTLP support option selected.":::

1. Complete the resource creation process.

1. After deployment, navigate to the **Overview** page of your Application Insights resource.

1. Locate the **OTLP Connection Info** section and copy the following values:

    * Data Collection Rule (DCR) resource ID
    * Endpoint URLs for traces, logs, and metrics (if using OpenTelemetry Collector)
    
    :::image type="content" source="./media/azure-monitor-otlp-ingestion/otlp-connection-info.png" lightbox="./media/azure-monitor-otlp-ingestion/otlp-connection-info.png" alt-text="Screenshot showing OTLP connection information on the Application Insights Overview page.":::

Proceed to [Configure your telemetry pipeline](#configure-your-telemetry-pipeline).

### Option 2: Manual resource orchestration

This option requires you to manually create and configure Data Collection Endpoints (DCE), Data Collection Rules (DCR), and destination workspaces. Use this approach when you need custom configurations or want to reuse existing resources.

#### Create destination workspaces

If you don't have existing workspaces, create the following resources in the same Azure region:

* **Log Analytics workspace** - Stores log and trace data
* **Azure Monitor workspace** - Stores metrics data

Record the resource IDs of both workspaces for later use.

#### (Optional) Create an Application Insights resource

To enable Application Insights troubleshooting experiences with your OTLP data:

1. Create an Application Insights resource in the same region as your workspaces.
1. Clear the **Enable OTLP support** checkbox to avoid creating duplicate resources.
1. Copy the Application Insights resource ID.

> [!NOTE]
> If you skip this step, you'll need to modify the ARM template in the next section to remove Application Insights references.

#### Deploy the Data Collection Endpoint and Rule

1. In the Azure portal, search for **Deploy a custom template** and select it.

1. Select **Build your own template in the editor**.

1. Copy the template content from the [Azure Monitor Community repository](https://github.com/microsoft/AzureMonitorCommunity/blob/master/Azure%20Services/Azure%20Monitor/OpenTelemetry/OTLP_DCE_DCR_ARM_Template.txt).

1. Paste the template into the editor and update the parameters with your workspace resource IDs and (optionally) Application Insights resource ID.

1. Set the location to match your workspace region.

1. Review and create the deployment.

1. After deployment completes, navigate to the created DCR and copy its resource ID from the **Overview** page.

## Configure your telemetry pipeline

Choose the configuration method based on your compute environment.

### Option 1: Azure Monitor Agent (for Azure VMs, VMSS, and Arc-enabled servers)

The Azure Monitor Agent provides a simplified ingestion path for Azure-hosted and Arc-enabled compute resources.

#### Deploy Azure Monitor Agent

Install the Azure Monitor Agent using Azure CLI or PowerShell. For detailed instructions, see [Install and manage Azure Monitor Agent](../agents/azure-monitor-agent-manage.md?tabs=azure-powershell).

Verify you're installing the minimum required version:

* **Windows**: Version 1.38.1 or higher
* **Linux**: Version 1.37.0 or higher

#### Associate the DCR with your compute resources

Create an association between your Data Collection Rule and the VMs, Virtual Machine Scale Sets, or Arc-enabled servers running your instrumented applications:

1. Navigate to your DCR in the Azure portal.
1. Select **Resources** under **Configuration**.
1. Select **Add** and choose the compute resources to associate.

For programmatic association, see [Manage data collection rule associations](../data-collection/data-collection-rule-associations.md).

#### Configure application environment

Set the following configuration in your application environment:

1. Add the `microsoft.applicationId` resource attribute with the Application Insights connection string application ID (the GUID portion after `InstrumentationKey=`).

1. Configure the OpenTelemetry SDK to send to localhost using these ports:

    * **Metrics**: Port 4317 (gRPC)
    * **Logs and Traces**: Port 4319 (gRPC)

Example environment variable configuration:

```bash
export OTEL_EXPORTER_OTLP_ENDPOINT="http://localhost:4317"
export OTEL_RESOURCE_ATTRIBUTES="microsoft.applicationId=<your-application-id>"
```

> [!NOTE]
> The Azure Monitor Agent running on the VM handles authentication and routing to Azure Monitor endpoints.

### Option 2: OpenTelemetry Collector

For non-Azure environments or when you need maximum flexibility, configure the OpenTelemetry Collector to send data directly to Azure Monitor endpoints.

#### Configure authentication

The OpenTelemetry Collector requires Microsoft Entra authentication to send data to Azure Monitor.

**For Azure VMs and VMSS:**

1. Enable system-assigned managed identity on your compute resource.
1. Assign the **Monitoring Metrics Publisher** role to the managed identity.
1. Leave the `managed_identity` section blank in your collector configuration to use the system-assigned identity.

**For non-Azure environments:**

Configure the Azure Authentication extension in your collector with an appropriate Entra identity:

```yaml
extensions:
  azureauth/monitor:
    managed_identity:
      client_id: "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"  # Your identity client ID
    scopes:
      - https://monitor.azure.com/.default
```

For workload identities, service principals, or other Entra identities, provide the `client_id` of the identity that will authenticate.

#### Grant permissions to the Data Collection Rule

The identity used by your collector needs permission to write data to your DCR:

1. Navigate to your DCR in the Azure portal.

1. Select **Access control (IAM)** in the left navigation.

1. Select **Add** > **Add role assignment**.

    :::image type="content" source="./media/azure-monitor-otlp-ingestion/data-collection-rule-access-control.png" lightbox="./media/azure-monitor-otlp-ingestion/data-collection-rule-access-control.png" alt-text="Screenshot showing how to add a role assignment to a Data Collection Rule.":::

1. Select **Monitoring Metrics Publisher** and select **Next**.

    :::image type="content" source="./media/azure-monitor-otlp-ingestion/role-assignment-metrics-publisher.png" lightbox="./media/azure-monitor-otlp-ingestion/role-assignment-metrics-publisher.png" alt-text="Screenshot showing the Monitoring Metrics Publisher role selection.":::

1. For **Assign access to**, select **User, group, or service principal**.

1. Select **Select members** and choose your application or managed identity.

    :::image type="content" source="./media/azure-monitor-otlp-ingestion/role-assignment-select-members.png" lightbox="./media/azure-monitor-otlp-ingestion/role-assignment-select-members.png" alt-text="Screenshot showing member selection for role assignment.":::

1. Select **Review + assign** to save the role assignment.

    :::image type="content" source="./media/azure-monitor-otlp-ingestion/role-assignment-review-assign.png" lightbox="./media/azure-monitor-otlp-ingestion/role-assignment-review-assign.png" alt-text="Screenshot showing the Review and assign page for the role assignment.":::

#### Construct endpoint URLs

If you created your resources using the Application Insights method, you already have the endpoint URLs from the OTLP Connection Info section. Skip to [Update collector configuration](#update-collector-configuration).

For manually orchestrated resources, construct the endpoint URLs:

1. Navigate to your Data Collection Endpoint in the Azure portal.

1. Select **JSON View** from the **Overview** page.

1. Copy the `logsIngestion` and `metricsIngestion` endpoint values:

    ```json
    "logsIngestion": {
        "endpoint": "https://example-xyz.southcentralus-1.ingest.monitor.azure.com"
    },
    "metricsIngestion": {
        "endpoint": "https://example-xyz.southcentralus-1.metrics.ingest.monitor.azure.com"
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
    https://<logs-dce-domain>/datacollectionRules/<dcr-immutable-id>/streams/opentelemetry_logs/otlp/v1/logs
    ```
    
    **Traces endpoint:**
    ```
    https://<logs-dce-domain>/datacollectionRules/<dcr-immutable-id>/streams/opentelemetry_traces/otlp/v1/traces
    ```
    
    > [!NOTE]
    > The traces endpoint uses the logs DCE domain, not the metrics domain.

#### Update collector configuration

Configure your OpenTelemetry Collector with the authentication extension and Azure Monitor endpoints. Here's a sample configuration:

```yaml
extensions:
  azureauth/monitor:
    managed_identity:
      client_id: "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    scopes:
      - https://monitor.azure.com/.default

exporters:
  otlphttp/azuremonitor:
    traces_endpoint: "https://<your-logs-dce-domain>/datacollectionRules/<dcr-id>/streams/opentelemetry_traces/otlp/v1/traces"
    logs_endpoint: "https://<your-logs-dce-domain>/datacollectionRules/<dcr-id>/streams/opentelemetry_logs/otlp/v1/logs"
    metrics_endpoint: "https://<your-metrics-dce-domain>/datacollectionRules/<dcr-id>/streams/microsoft-otelmetrics/otlp/v1/metrics"
    auth:
      authenticator: azureauth/monitor

service:
  extensions: [azureauth/monitor]
  pipelines:
    traces:
      receivers: [otlp]
      exporters: [otlphttp/azuremonitor]
    metrics:
      receivers: [otlp]
      exporters: [otlphttp/azuremonitor]
    logs:
      receivers: [otlp]
      exporters: [otlphttp/azuremonitor]
```

For a complete configuration example, see the [sample configuration file](https://github.com/microsoft/AzureMonitorCommunity/blob/master/Azure%20Services/Azure%20Monitor/OpenTelemetry/SampleOTelCollectorConfig.yaml) in the Azure Monitor Community repository.

## View and analyze your data

After configuring data ingestion, telemetry data flows into your Azure Monitor workspaces:

* **Traces and logs** are stored in your Log Analytics workspace
* **Metrics** are stored in your Azure Monitor workspace
* If you associated an Application Insights resource, you can use Application Insights experiences for end-to-end transaction analysis, application maps, live metrics, and performance profiling

Access your data through:

* **Azure Monitor Logs** - Query traces and logs using Kusto Query Language (KQL)
* **Azure Monitor Metrics Explorer** - Visualize and alert on metrics
* **Application Insights** - Use dedicated troubleshooting and monitoring experiences

## Limitations and known issues

The following Azure regions are not supported during the preview:

* North Central US
* Qatar Central
* Poland Central
* New Zealand North
* Malaysia West
* Indonesia Central
* West India
* Chile Central
* Mexico Central
* Austria East

## Provide feedback

We welcome your feedback on this preview feature. To report issues, ask questions, or share suggestions:

* Email the preview team at otel@microsoft.com
* Use the feedback mechanisms available through the [preview sign-up page](https://aka.ms/AzureMonitorOTelPreview)

## Next steps

* [Learn more about OpenTelemetry](https://opentelemetry.io/docs/)
* [Explore OpenTelemetry SDKs for different languages](https://opentelemetry.io/docs/languages/)
* [Query data in Azure Monitor Logs](../logs/get-started-queries.md)
* [Analyze application performance with Application Insights](../app/app-insights-overview.md)