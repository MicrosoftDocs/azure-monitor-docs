---
title: OTLP Signal Ingestion in Azure Monitor (Limited Preview)
description: Configure OpenTelemetry Protocol (OTLP) ingestion into Azure Monitor using Azure Monitor Agent, Data Collection Rules and Endpoints, or the OpenTelemetry Collector.
ms.topic: how-to
ms.date: 11/08/2025
ROBOTS: NOINDEX
---

# OTLP Signal Ingestion in Azure Monitor (Limited Preview)

This article shows how to ingest OpenTelemetry Protocol (OTLP) **signals**—metrics, logs, and traces—into Azure Monitor using platform ingestion components. It covers **Azure Monitor Agent (AMA)**, **Data Collection Rules (DCRs)**, **Data Collection Endpoints (DCEs)**, and the **OpenTelemetry (OTel) Collector**. Applications running on Azure Kubernetes Service (AKS) can use the AKS add-on, which is covered in a separate guide.

> [!IMPORTANT]
> This feature is a **limited preview**:
>
> - **Use** only allow-listed subscriptions.
> - **Deploy** in **South Central US** or **West Europe**.
> - **Instrument** applications with **OpenTelemetry SDKs**.
> - **Use** OTLP over **HTTP/protobuf** with the OTel Collector. The team plans to add **gRPC** in a future milestone.
> - **Contact** the team with questions or feedback at **otel@microsoft.com**.

## Prerequisites

- An allow-listed Azure subscription.
- Permission to create Azure Monitor resources.
- OpenTelemetry SDK instrumentation in your applications.

## Components

- **Azure Monitor Agent (AMA):** Agent that receives OTLP signals from applications and forwards them to Azure Monitor.
- **Data Collection Rule (DCR):** Rule that defines how logs, metrics, and traces are collected and routed to destinations.
- **Data Collection Endpoint (DCE):** Endpoint that exposes ingestion endpoints for Azure Monitor.
- **Azure Monitor Workspace (AMW) and Log Analytics workspace (LAW):** Destinations for metrics and logs/traces.
- **OpenTelemetry Collector:** Optional component that exports OTLP signals to Azure Monitor ingestion endpoints.
- **Microsoft Entra ID:** Identity platform used for authentication.

## Step 1: Create destinations and collection resources (manual orchestration)

You can create the ingestion resources without using Application Insights. Use this path when your organization manages ingestion centrally.

1. **Create workspaces.** Create an **Azure Monitor Workspace (AMW)** and a **Log Analytics workspace (LAW)** in **South Central US** or **West Europe**. Copy the resource identifiers (IDs).
2. **Deploy DCE and DCR with the template.**
   - In the Azure portal, open **Deploy a custom template**, then **Build your own template in the editor**.
   - Paste the template from the AzureMonitorCommunity repository:  
     `microsoft/AzureMonitorCommunity > Azure Services > Azure Monitor > OpenTelemetry > OTLP_DCE_DCR_ARM_Template.txt`
   - Set the location to **South Central US** or **West Europe** and provide the Azure Monitor Workspace (AMW) and Log Analytics Workspace (LAW) resource IDs.
   - Deploy the template.

### If you opt out of Application Insights

The community template can include an **Application Insights** resource and references to it. When you **do not** want to deploy Application Insights in this ingestion-only scenario:

1. **Remove the Application Insights resource** from the template’s `resources` array.
2. **Remove template references** that point to the Application Insights resource. In particular, delete any occurrences of the following properties from the template (wherever they appear):
   ```json
   "enrichWithReference": "applicationInsightsResource",
   "replaceResourceIdWithReference": true
   ```
3. **Remove or clear any template parameters** that request an Application Insights **resource ID**.
4. **Validate the template** in the portal editor and redeploy.

> [!TIP]
> If you later decide to use Application Insights experiences with your OTLP data, you can create an Application Insights resource in the same region and relate it to your existing ingestion setup without changing the ingestion endpoints.

After deployment, copy the **Data Collection Rule (DCR)** link for later steps. Azure Monitor now accepts OTLP signals targeted to this data collection rule (DCR).

## Step 2: Choose and configure an ingestion path

### Option A: Use Azure Monitor Agent (recommended for Virtual Machine (VM)/Azure Virtual Machine Scale Sets/Arc)

1. **Install the agent.**
   - On **Windows**, use AMA **1.38.1** or later.
   - On **Linux**, use AMA **1.37.0** or later.
2. **Associate the DCR.** Associate the DCR with each VM, Virtual Machine Scale Sets, or Arc-enabled server that runs the OTel-instrumented application.
3. **Configure local ports.**
   - **4317 (gRPC)** for **metrics**
   - **4319 (gRPC)** for **logs and traces**
   - **Host:** `localhost`

### Option B: Use the OpenTelemetry Collector

Use the `contrib` distribution **0.132.0** or later, or a custom build that includes Azure authentication components.

#### Authenticate the Collector

If the Collector runs on **Azure VMs or VMSS**, enable a **system-assigned managed identity** and assign the following role. Otherwise, create a **Microsoft Entra ID application (service principal)**.

1. **Register an application.** In **Microsoft Entra ID**, open **App registrations** and select **New registration**.

   :::image type="content" source="./media/3.png" alt-text="Microsoft Entra ID App registrations menu listing existing applications.":::

   :::image type="content" source="./media/4.png" alt-text="Register an application form with name and supported account types fields.":::

2. **Capture IDs.** After registration, note the **Application (client) ID** and **Directory (tenant) ID**.

   :::image type="content" source="./media/5.png" alt-text="Application registration overview showing the client ID and tenant ID values.":::

3. **Create a client secret.** Open **Certificates & secrets**, select **New client secret**, provide a description, and select an expiration.

   :::image type="content" source="./media/6.png" alt-text="Add a client secret panel with description and expiration options.":::

4. **Store the secret.** Select **Add**, then copy the secret value and store it securely.

   :::image type="content" source="./media/7.png" alt-text="Certificates & secrets list showing a newly created client secret and its value.":::

#### Assign permissions to the DCR

1. Open the **DCR** and navigate to **Access control (IAM)**. Select **Add role assignment**.

   :::image type="content" source="./media/8.png" alt-text="Access control (IAM) menu for the Data Collection Rule.":::

2. Select **Monitoring Metrics Publisher** and continue.

   :::image type="content" source="./media/9.png" alt-text="Add role assignment flow highlighting the Monitoring Metrics Publisher role.":::

3. For **Assign access to**, select **User, group, or service principal**, choose the application or managed identity, and select **Select**.

   :::image type="content" source="./media/10.png" alt-text="Member selection dialog for choosing a service principal.":::

4. Review and assign the role.

   :::image type="content" source="./media/11.png" alt-text="Review and assign step confirming the role assignment to the selected principal.":::

#### Build the ingestion endpoint URLs

1. Open the **DCE** and select **JSON view**. Copy the **logsIngestion** and **metricsIngestion** endpoint domains.

   :::image type="content" source="./media/12.png" alt-text="Data Collection Endpoint page with JSON view selected, showing logsIngestion and metricsIngestion endpoint values.":::

   Example structure:

   ```json
   "logsIngestion": {
     "endpoint": "https://<XYZ>.southcentralus-1.ingest.monitor.azure.com"
   },
   "metricsIngestion": {
     "endpoint": "https://<XYZ>.southcentralus-1.metrics.ingest.monitor.azure.com"
   }
   ```

2. Open the **DCR** and copy the **Immutable ID** from the **Overview** menu.

   :::image type="content" source="./media/13.png" alt-text="Data Collection Rule overview showing the Immutable ID value.":::

3. Combine the values to form the three OTLP endpoints:

   - **Metrics**  
     ```
     https://<Metrics-DCE-domain>/datacollectionRules/<DCR-ImmutableID>/streams/microsoft-otelmetrics/otlp/v1/metrics
     ```
   - **Logs**  
     ```
     https://<Logs-DCE-domain>/datacollectionRules/<DCR-ImmutableID>/streams/opentelemetry_logs/otlp/v1/logs
     ```
   - **Traces**  
     ```
     https://<Logs-DCE-domain>/datacollectionRules/<DCR-ImmutableID>/streams/opentelemetry_traces/otlp/v1/traces
     ```

   > [!NOTE]
   > The **traces** URL uses the `logs` Data Collection Endpoint (DCE) domain.

#### Configure the Collector exporters

Use a configuration that authenticates to Azure Monitor and exports to the three OTLP endpoints mentioned earlier. A sample configuration is available in the AzureMonitorCommunity repository:  
`microsoft/AzureMonitorCommunity > Azure Services > Azure Monitor > OpenTelemetry > SampleOTelCollectorConfig.yaml`

## Verify ingestion

1. Generate traffic to the OpenTelemetry-instrumented application.
2. Use **Log Analytics** to query logs and traces with **Kusto Query Language (KQL)**.
3. Use **Metrics explorer** to chart metrics stored in your **Azure Monitor Workspace** or **Log Analytics workspace**.

## Reference

### Supported regions

- South Central US
- West Europe

### Supported protocols

- OTel Collector: OTLP over **HTTP/protobuf** (current). The team plans to add OTLP over **gRPC** in a future milestone.
- AMA-based path: Application-to-agent communication over **gRPC** on local ports.

### Ports for AMA-based ingestion

- 4317 (gRPC) for metrics
- 4319 (gRPC) for logs and traces
- Host: `localhost`

## FAQ

**No data appears after setup. What should I check?**  
Confirm subscription and region eligibility, verify DCR associations, validate authentication to ingestion endpoints, and generate application traffic.

**Which OTel Collector distribution should I use?**  
Use the `contrib` distribution **0.132.0** or later, or a custom build with Azure authentication components.
