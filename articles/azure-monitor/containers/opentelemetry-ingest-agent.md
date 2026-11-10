---
title: Ingest OTLP Data into Azure Monitor with AMA
description: Learn how to send OpenTelemetry Protocol (OTLP) telemetry data to Azure Monitor using Azure Monitor Agent on VMs, Scale Sets, and Arc-enabled servers.
ms.topic: how-to
ms.date: 11/09/2026
ms.reviewer: kaprince
ai-usage: ai-assisted
---

# Ingest OTLP data into Azure Monitor by using AMA

Azure Monitor now supports native ingestion of OpenTelemetry Protocol (OTLP) signals. You can send telemetry data directly from OpenTelemetry-instrumented applications to Azure Monitor.

> [!TIP]
> For a conceptual overview of OpenTelemetry options in Azure Monitor: native OTLP ingestion, the Microsoft OpenTelemetry distro, and end-to-end observability experiences, see [OpenTelemetry with Azure Monitor](opentelemetry-options.md).

## Overview

Azure Monitor can receive OTLP signals through three ingestion mechanisms:

* **OpenTelemetry Collector** - Send data directly to Azure Monitor cloud ingestion endpoints from any OTel Collector deployment. For more information, see [Ingest OTLP data into Azure Monitor with OTel Collector](opentelemetry-protocol-ingestion.md).
* **Azure Monitor Agent (AMA)** - Ingest data from applications running on Azure VMs, Virtual Machine Scale Sets, or Azure Arc-enabled servers.
* **Azure Kubernetes Service (AKS) add-on** - Collect telemetry from containerized applications in AKS clusters. For more information, see [Enable Azure Monitor OpenTelemetry for Kubernetes clusters](kubernetes-open-protocol.md).

This article covers the Azure Monitor Agent method of collecting OTLP signals.

> [!IMPORTANT]
> OTLP ingestion through Azure Monitor Agent is generally available only on Linux, starting with version 1.45.1.

## Prerequisites

> [!div class="checklist"]
> * Azure subscription: If you don't have one, [create an Azure subscription for free](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn).
> * [OpenTelemetry SDK](https://opentelemetry.io/docs/languages/) instrumented application (any supported language).
> * Azure Monitor Agent installed on your VMs, Virtual Machine Scale Sets, or Azure Arc-enabled servers. For the minimum version for your operating system and OTLP protocol, see [Deploy Azure Monitor Agent](#deploy-azure-monitor-agent). General availability applies only to Linux.

## Set up OTLP data ingestion

You can configure OTLP data ingestion in Azure Monitor by using one of two approaches. The Application Insights-based approach is recommended for most scenarios as it automates resource creation and enables built-in troubleshooting experiences.

### Option 1: Create an Application Insights resource with OTLP support (Recommended)

This method automatically creates all required Azure resources and configures their relationships. You can use Application Insights for application performance monitoring, distributed tracing, and failure analysis.

1. In the Azure portal, create a new Application Insights resource.

1. On the **Basics** tab, set **OTLP support** to **On**.

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
1. Set **OTLP support** to **Off** to avoid creating duplicate resources.
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

## Deploy Azure Monitor Agent

Install the Azure Monitor Agent by using Azure CLI or PowerShell. For detailed instructions, see [Install and manage Azure Monitor Agent](../agents/azure-monitor-agent-manage.md?tabs=azure-powershell).

Verify that you're installing the minimum required version for your operating system and OTLP protocol:

| Operating system | OTLP gRPC | OTLP gRPC and OTLP HTTP/Protobuf |
|---|---|---|
| Linux | Version 1.37.0 or later. | Version 1.45.1 or later. |
| Windows | Version 1.38.1 or later. | Version 1.46.1 or later. |

OTLP ingestion is generally available only on Linux.

## Associate the DCR with your compute resources

Create an association between your Data Collection Rule and the VMs, Virtual Machine Scale Sets, or Arc-enabled servers running your instrumented applications:

1. Go to your DCR in the Azure portal.
1. Under **Configuration**, select **Resources**.
1. Select **Add** and choose the compute resources to associate.

For programmatic association, see [Manage data collection rule associations](../data-collection/data-collection-rule-associations.md).

## Configure application environment

Set the following configuration in your application environment:

1. Add the `microsoft.applicationId` resource attribute with the GUID after `ApplicationId=` in the Application Insights connection string, not the instrumentation key. This attribute is required if Application Insights creates the DCR in use.

    > [!TIP]
    > Use separate DCRs that filter by different `microsoft.applicationId` values to route data to multiple Application Insights resources.

1. Configure the OpenTelemetry SDK to send data to localhost by using these default ports:

    | Signal | gRPC default | HTTP/Protobuf default |
    | --- | --- | --- |
    | Metrics | `4317` | `4318` |
    | Logs and traces | `4319` | `4320` |

Ports 4319 and 4320 are Microsoft-picked ports for the Azure Monitor Agent path, not canonical OTLP ports. The [OTLP protocol specification](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/protocol/README.md) defines 4317 (gRPC) and 4318 (HTTP) as the standard ports.

Configure separate endpoints for metrics and for logs and traces because they use different ports.

> [!IMPORTANT]
> Application Insights experiences, including prebuilt dashboards and queries, expect and require OTLP metrics with delta temporality and exponential histogram aggregation.

### Example environment variable configuration

Choose the example for your OTLP protocol. Replace `<your-application-id>` with the Application Insights application ID. The `microsoft.applicationId` resource attribute is required when you use a DCR created by Application Insights.

#### [gRPC](#tab/ama-grpc)

Use the following environment variables to send metrics to port 4317 and logs and traces to port 4319:

```bash
export OTEL_EXPORTER_OTLP_PROTOCOL="grpc"
export OTEL_EXPORTER_OTLP_METRICS_ENDPOINT="http://localhost:4317"
export OTEL_EXPORTER_OTLP_TRACES_ENDPOINT="http://localhost:4319"
export OTEL_EXPORTER_OTLP_LOGS_ENDPOINT="http://localhost:4319"
export OTEL_RESOURCE_ATTRIBUTES="microsoft.applicationId=<your-application-id>"
export OTEL_EXPORTER_OTLP_METRICS_TEMPORALITY_PREFERENCE=delta
export OTEL_EXPORTER_OTLP_METRICS_DEFAULT_HISTOGRAM_AGGREGATION=base2_exponential_bucket_histogram
```

Port 4319, used above for traces and logs, is specific to the Azure Monitor Agent local endpoint.

#### [HTTP/Protobuf](#tab/ama-http-protobuf)

Use the following environment variables to send metrics to port 4318 and logs and traces to port 4320. HTTP/Protobuf requires Azure Monitor Agent version 1.45.1 or later on Linux, or version 1.46.1 or later on Windows.

For HTTP/Protobuf, include the signal path in each endpoint. OpenTelemetry SDKs use signal-specific endpoint URLs as-is.

```bash
export OTEL_EXPORTER_OTLP_PROTOCOL="http/protobuf"
export OTEL_EXPORTER_OTLP_METRICS_ENDPOINT="http://localhost:4318/v1/metrics"
export OTEL_EXPORTER_OTLP_TRACES_ENDPOINT="http://localhost:4320/v1/traces"
export OTEL_EXPORTER_OTLP_LOGS_ENDPOINT="http://localhost:4320/v1/logs"
export OTEL_RESOURCE_ATTRIBUTES="microsoft.applicationId=<your-application-id>"
export OTEL_EXPORTER_OTLP_METRICS_TEMPORALITY_PREFERENCE=delta
export OTEL_EXPORTER_OTLP_METRICS_DEFAULT_HISTOGRAM_AGGREGATION=base2_exponential_bucket_histogram
```

---

> [!NOTE]
> The Azure Monitor Agent running on the VM handles authentication and routing to Azure Monitor endpoints.

### Customize listener ports (preview)

If a default OTLP port conflicts with another application or service, use an Agent Settings DCR to override the listener port with a port you choose. Port customization remains in preview.

For the available OTLP port settings and instructions to create and apply an Agent Settings DCR, see [Configure agents with Azure Monitor Agent settings](../agents/agent-settings.md#supported-parameters).

After you change a listener port, update the corresponding OpenTelemetry exporter endpoint to use the same port. For HTTP/Protobuf endpoints, keep the signal-specific path.

## Authentication and permissions

OTLP ingestion through Azure Monitor Agent (AMA) uses a data collection rule (DCR) to associate supported Azure resources with OTLP ingestion endpoints, including virtual machines, virtual machine scale sets, and Azure Arc–enabled servers. AMA retrieves its settings from Azure Monitor and sends telemetry through the ingestion pipeline. The agent doesn't require separate permissions or role assignments.

In contrast, direct ingestion methods such as the OpenTelemetry Collector send OTLP telemetry to Azure Monitor ingestion endpoints from external sources or service. For these scenarios, authenticate by using a Microsoft Entra identity. Then use RBAC to assign the Monitoring Metrics Publisher role on the DCR to the identity used by the OpenTelemetry Collector.

For more information about Collector-specific setup, see [Ingest OTLP data into Azure Monitor by using OTel Collector](opentelemetry-protocol-ingestion.md).

## Next steps

* [Ingest OTLP data with OTel Collector](opentelemetry-protocol-ingestion.md)
* [OpenTelemetry on Azure](../app/opentelemetry-overview.md)
* [Monitor AKS with OpenTelemetry](kubernetes-open-protocol.md)
* [Dashboards with Grafana in Application Insights](../app/grafana-dashboards.md)
* [OpenTelemetry documentation](https://opentelemetry.io/docs/)
