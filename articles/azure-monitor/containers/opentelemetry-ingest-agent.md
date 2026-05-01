---
title: Ingest OTLP Data into Azure Monitor with AMA (Preview)
description: Learn how to send OpenTelemetry Protocol (OTLP) telemetry data to Azure Monitor using Azure Monitor Agent on VMs, Scale Sets, and Arc-enabled servers.
ms.topic: how-to
ms.date: 05/01/2026
ms.reviewer: kaprince
ai-usage: ai-assisted
---

# Ingest OTLP data into Azure Monitor by using AMA (Preview)

Azure Monitor now supports native ingestion of OpenTelemetry Protocol (OTLP) signals. You can send telemetry data directly from OpenTelemetry-instrumented applications to Azure Monitor.

> [!IMPORTANT]
> * This feature is in **preview**. Preview features are provided without a service-level agreement and aren't recommended for production workloads.
> * For more information, see [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).

## Overview

Azure Monitor can receive OTLP signals through three ingestion mechanisms:

* **OpenTelemetry Collector** - Send data directly to Azure Monitor cloud ingestion endpoints from any OTel Collector deployment. For more information, see [Ingest OTLP data into Azure Monitor with OTel Collector](opentelemetry-protocol-ingestion.md).
* **Azure Monitor Agent (AMA)** - Ingest data from applications running on Azure VMs, Virtual Machine Scale Sets, or Azure Arc-enabled servers.
* **Azure Kubernetes Service (AKS) add-on** - Collect telemetry from containerized applications in AKS clusters. For more information, see [Enable Azure Monitor OpenTelemetry for Kubernetes clusters](kubernetes-open-protocol.md).

This article covers the Azure Monitor Agent method of collecting OTLP signals.

## Prerequisites

> [!div class="checklist"]
> * Azure subscription: If you don't have one, [create an Azure subscription for free](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn).
> * [OpenTelemetry SDK](https://opentelemetry.io/docs/languages/) instrumented application (any supported language).
> * For VMs and Virtual Machine Scale Sets deployments: Azure Monitor Agent version 1.38.1 or higher (Windows) or 1.37.0 or higher (Linux).

## Set up OTLP data ingestion

You can configure OTLP data ingestion in Azure Monitor by using one of two approaches. The Application Insights-based approach is recommended for most scenarios as it automates resource creation and enables built-in troubleshooting experiences.

### Option 1: Create an Application Insights resource with OTLP support (Recommended)

This method automatically creates all required Azure resources and configures their relationships. You can use Application Insights for application performance monitoring, distributed tracing, and failure analysis.

1. Register the Application Insights OTLP preview features and provider.

    ```bash
    az feature register --name OtlpApplicationInsights --namespace Microsoft.Insights
    az feature list -o table --query "[?contains(name, 'Microsoft.Insights/OtlpApplicationInsights')].{Name:name,State:properties.state}"
    
    az provider register -n Microsoft.Insights
    ```

1. In the Azure portal, create a new Application Insights resource.

1. On the **Basics** tab, select the **Enable OTLP support** checkbox.

    :::image type="content" source="./media/opentelemetry-protocol-ingestion/create-app-insights-resource.png" lightbox="./media/opentelemetry-protocol-ingestion/create-app-insights-resource.png" alt-text="Screenshot showing the Create Application Insights page with Enable OTLP support option selected.":::

1. Complete the resource creation process.

1. After deployment, go to the **Overview** page of your Application Insights resource.

1. In the **OTLP Connection Info** section, copy the following values:

    * Data Collection Rule (DCR) resource ID
    * Endpoint URLs for traces, logs, and metrics (if you're using OpenTelemetry Collector)
    
    :::image type="content" source="./media/opentelemetry-protocol-ingestion/connection-info.png" lightbox="./media/opentelemetry-protocol-ingestion/connection-info.png" alt-text="Screenshot showing OTLP connection information on the Application Insights Overview page.":::

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
> If you skip this step, you need to modify the ARM template in the next section to remove Application Insights references.

#### Deploy the Data Collection Endpoint and Rule

1. In the Azure portal, search for **Deploy a custom template** and select it.
1. Select **Build your own template in the editor**.
1. Copy the template content from the [Azure Monitor Community repository](https://github.com/microsoft/AzureMonitorCommunity/blob/master/Azure%20Services/Azure%20Monitor/OpenTelemetry/OTLP_DCE_DCR_ARM_Template.txt).
1. Paste the template into the editor and update the parameters with your workspace resource IDs and (optionally) Application Insights resource ID.  
    > [!NOTE]
    > The stream name from the community DCR template is used to create the URL. You can *optionally* change the stream name in the DCR definition and match it when creating the DCE name. The stream name should start with `Custom-Metrics-` followed by a letter and then any combination of alphanumeric characters, `-`, and `_`.
1. Set the location to match your workspace region.
1. Review and create the deployment.
1. After deployment completes, go to the created DCR and copy its resource ID from the **Overview** page.

### Deploy Azure Monitor Agent

Install the Azure Monitor Agent by using Azure CLI or PowerShell. For detailed instructions, see [Install and manage Azure Monitor Agent](../agents/azure-monitor-agent-manage.md?tabs=azure-powershell).

Verify that you're installing the minimum required version:

* **Windows**: Version 1.38.1 or higher
* **Linux**: Version 1.37.0 or higher

### Associate the DCR with your compute resources

Create an association between your Data Collection Rule and the VMs, Virtual Machine Scale Sets, or Arc-enabled servers running your instrumented applications:

1. Go to your DCR in the Azure portal.
1. Under **Configuration**, select **Resources**.
1. Select **Add** and choose the compute resources to associate.

For programmatic association, see [Manage data collection rule associations](../data-collection/data-collection-rule-associations.md).

### Configure application environment

Set the following configuration in your application environment:

1. Add the `microsoft.applicationId` resource attribute with the Application Insights connection string application ID (the GUID portion after `InstrumentationKey=`). This attribute is required if Application Insights creates the DCR in use. It's also required if you include the Application Insights ID in the manually created DCR to separate ingested data per Application Insights resource.

1. Configure the OpenTelemetry SDK to send data to localhost by using these ports:

    * **Metrics**: Port 4317 (gRPC)
    * **Logs and Traces**: Port 4319 (gRPC)

You might need to alter your OTLP exporter to separate metrics versus logs and traces data across these ports.

> [!IMPORTANT]
> Application Insights experiences, including prebuilt dashboards and queries, expect and require OTLP metrics with delta temporality and exponential histogram aggregation.

#### Example environment variable configuration

Here's an example configuration for setting environment variables. `microsoft.applicationId` is required if using App Insights based DCR.

```bash
export OTEL_EXPORTER_OTLP_METRICS_ENDPOINT="http://localhost:4317"
export OTEL_EXPORTER_OTLP_TRACES_ENDPOINT="http://localhost:4319"
export OTEL_EXPORTER_OTLP_LOGS_ENDPOINT="http://localhost:4319"
export OTEL_RESOURCE_ATTRIBUTES="microsoft.applicationId=<your-application-id>"
export OTEL_EXPORTER_OTLP_METRICS_TEMPORALITY_PREFERENCE=delta
export OTEL_EXPORTER_OTLP_METRICS_DEFAULT_HISTOGRAM_AGGREGATION=base2_exponential_bucket_histogram
```

> [!NOTE]
> The Azure Monitor Agent running on the VM handles authentication and routing to Azure Monitor endpoints.

### Configure Microsoft Entra authentication

You must enable system-assigned managed identity on your compute resource. Assign the **Monitoring Metrics Publisher** role to the managed identity. The managed identity AMA uses needs permission to write data to your DCR.

1. Go to your DCR in the Azure portal.
1. In the left navigation, select **Access control (IAM)**.
1. Select **Add** > **Add role assignment**.  
    :::image type="content" source="./media/opentelemetry-ingest-agent/data-collection-rule-access-control.png" lightbox="./media/opentelemetry-ingest-agent/data-collection-rule-access-control.png" alt-text="Screenshot showing how to add a role assignment to a Data Collection Rule.":::
1. Select **Monitoring Metrics Publisher** and select **Next**.  
    :::image type="content" source="./media/opentelemetry-ingest-agent/role-assignment-metrics-publisher.png" lightbox="./media/opentelemetry-ingest-agent/role-assignment-metrics-publisher.png" alt-text="Screenshot showing the Monitoring Metrics Publisher role selection.":::
1. For **Assign access to**, select **Managed Identity**.
1. Next to **Members**, select **+ Select members** and choose your managed identity.
1. Select **Review + assign** to save the role assignment.

> [!IMPORTANT]
> - Application Insights experiences, including prebuilt dashboards and queries, expect and require OTLP metrics with delta temporality and exponential histogram aggregation.

## Next steps

* [Ingest OTLP data with OTel Collector](opentelemetry-protocol-ingestion.md)
* [OpenTelemetry on Azure](../app/opentelemetry-overview.md)
* [Monitor AKS with OpenTelemetry](kubernetes-open-protocol.md)
* [Dashboards with Grafana in Application Insights](../app/grafana-dashboards.md)
* [OpenTelemetry documentation](https://opentelemetry.io/docs/)
