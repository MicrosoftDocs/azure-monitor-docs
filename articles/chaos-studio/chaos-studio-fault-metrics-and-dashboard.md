---
title: Measuring Fault Impact with an Azure Workbook
description: Learn to troubleshoot common problems when you use Azure Chaos Studio.
author: nikhilkaul-msft
ms.reviewer: nikhilkaul
ms.topic: how-to
ms.date: 07/25/2025
ms.custom: template-how-to
---


# Measuring Fault Impact with an Azure Workbook

A chaos experiment is only useful if you can measure the impact. While you can view metrics on individual resources, a centralized dashboard using Azure Workbooks provides a "single pane of glass" view to correlate the fault with its impact across multiple resources. This workbook will serve as a reusable tool for all chaos experiments.

The ability to visualize the direct correlation between your chaos experiments and their impact on system metrics is crucial for understanding system resilience. Azure Workbooks offer a powerful, customizable solution that allows you to create dynamic dashboards that can be reused across different experiments, resource groups, and subscriptions. By centralizing your fault analysis in a single dashboard, you can quickly identify how different types of faults affect your infrastructure and applications, enabling you to make informed decisions about system improvements and disaster recovery planning.

## Creating Your Fault Analysis Workbook

Follow these step-by-step instructions to create a reusable workbook for analyzing the impact of your chaos experiments:

1. Navigate to **Azure Monitor** in the Azure portal.

2. Select **Workbooks** from the left menu.

3. Click **+ New** to create an empty workbook.

4. To make the workbook reusable across different experiments, you'll need to add parameters. Click **+ Add** and select **Add parameters**.

5. Create three text parameters that will allow you to specify different target resources for each experiment:
   - **Subscription** (Set "Required")
   - **ResourceGroup** (Set "Required") 
   - **TargetResource** (Set "Required")

   These parameters will be filled in each time you run an experiment, making the workbook flexible for use across different resources.

6. Now you'll add your first metric chart to visualize the impact. Click **+ Add** and select **Add metric**.

7. Configure the metric chart using the parameters you just created:
   - **Source**: Azure
   - **Resource type**: Virtual machines
   - **Subscription**: Select "Parameter" and choose the **Subscription** parameter
   - **Resource group**: Select "Parameter" and choose the **ResourceGroup** parameter
   - **Resource**: Select "Parameter" and choose the **TargetResource** parameter

8. In the metric configuration, add a common metric like **Percentage CPU**. You can add multiple metrics (e.g., **Available Memory Bytes**, **Network In Total**) to the same chart to get a comprehensive view of the resource's performance.

9. Click **Done editing** and then **Save** the workbook with a descriptive name like "Chaos Experiment Analysis Dashboard."

You can now add more metric charts for other resource types (like App Service, AKS, Cosmos DB) by repeating steps 7-9 and changing the **Resource type**. This modular approach allows you to build a comprehensive dashboard that covers all the resources involved in your chaos experiments.

## Recommended Metrics for Your Dashboard

To help you build an effective dashboard, the following table maps each fault in the Chaos Studio library to the key Azure Monitor metrics that reveal its impact.

### Agent-Based Faults
*Target Resource: Virtual Machine / Virtual Machine Scale Set*

| Fault Name | Recommended Azure Monitor Metric(s) | Notes |
| :--- | :--- | :--- |
| **CPU Pressure** | `Percentage CPU`, `CPU Credits Remaining` | Look for CPU to spike to the configured pressure level. |
| **Physical/Virtual Memory Pressure** | `Available Memory Bytes`, `Percentage Memory` | Available memory should drop significantly. |
| **Disk I/O Pressure** | `OS Disk Read Bytes/sec`, `OS Disk Write Bytes/sec`, `OS Disk Queue Depth`, `Data Disk Latency` | Expect a spike in I/O operations and latency. |
| **Kill Process / Stop Service** | Application-level: `Http Server Errors (5xx)`, `Response Time`. <br> Platform-level: `Percentage CPU` (may drop). | Platform metrics won't show a single process. Look for secondary effects. |
| **Network Disconnect** | `Network In Total`, `Network Out Total`, `Outbound Flows`, `Inbound Flows` | Traffic should drop to zero for the duration of the fault. |
| **Network Latency** | Platform-level: `Outbound Flows RTT` (Network Watcher). <br> Application-level: `Dependency Duration`, `Response Time`. | Expect a clear increase in round-trip time or dependency call times. |
| **Network Packet Loss** | `TCP Segments Retransmitted`, `Outbound Packets Dropped` | These metrics indicate the network stack is working harder to resend lost data. |
| **DNS Failure** | Application-level: `Dependency call failure rate` (from Application Insights). | Best observed at the application level as it tries and fails to resolve DNS names. |
| **Time Change** | (No direct metric) | Validate impact by checking application or guest OS logs for time-skew errors. |
| **Arbitrary stress-ng Stressor** | (Varies) | Use the metric that corresponds to the stressor you enabled. |

### Azure Kubernetes Service (AKS) Faults
*Target Resource: AKS Cluster (Metrics typically viewed via Container Insights)*

| Fault Name | Recommended Azure Monitor Metric(s) | Notes |
| :--- | :--- | :--- |
| **Pod Chaos** | `kube_pod_container_status_restarts_total`, `kube_deployment_status_replicas_ready`, `kube_pod_status_ready` | Look for pod restarts to increment or the number of ready pods to drop. |
| **Network Chaos**| `ingress_controller_request_duration_seconds` (Latency), `node_network_in_bytes`, `node_network_out_bytes` | Latency faults will increase request duration. |
| **Stress Chaos** | `Container CPU Usage Percentage`, `Container Memory Working Set Bytes`, `node_cpu_usage_percentage` | Look for resource usage to spike at the container and/or node level. |
| **I/O Chaos**    | `node_disk_io_time_seconds_total`, `node_disk_read_bytes_total` | These node-level metrics will show increased I/O activity and latency. |
| **DNS Chaos**    | Prometheus: `coredns_dns_request_failures_total`. <br> Application-level: `Dependency call failure rate`. | Best observed within the cluster's CoreDNS or at the application level. |
| **HTTP Chaos**   | `ingress_controller_requests` (with status code dimension), `Http Server Errors`, `apiserver_current_inflight_requests` | Look for an increase in HTTP 5xx errors or failed requests. |

### PaaS & Other Resource Faults

| Fault Category | Fault Name | Target Resource Type | Recommended Azure Monitor Metric(s) |
| :--- | :--- | :--- | :--- |
| **App Service** | **Stop App Service** | App Service | `Http 5xx`, `Requests`, `Response Time`, `Health check status` |
| **Autoscale** | **Disable Autoscale** | Autoscale Settings | `Virtual Machine Scale Set Instance Count` (will not increase), `Average Percentage CPU` (will rise) |
| **Cache for Redis** | **Reboot Cache Node** | Azure Cache for Redis | `Connected Clients` (will dip), `Server Load` (will spike), `Errors` (Type: Failover), `Cache Latency` |
| **Cosmos DB** | **Cosmos DB Failover** | Cosmos DB Account | `Server Side Latency`, `Total Requests` (by StatusCode), `Throttled Requests`, `Service Availability` |
| **Event Hubs** | **Change Event Hub State** | Event Hubs Namespace | `Incoming Requests`, `Throttled Requests`, `User Errors`, `Active Connections` |
| **Key Vault** | **Deny Access / Disable Cert** | Key Vault | `Availability`, `Service Api Latency`, `Service Api Results` (by ResultType) |
| **Network** | **NSG Security Rule** | Network Security Group | On affected VM: `Inbound/Outbound Flows`. <br> In NSG Flow Logs: `[Rule Name]_Denied_Packets` |
| **Service Bus** | **Change Queue State** | Service Bus Namespace | `Incoming Messages`, `User Errors`, `Server Errors`, `Active Messages` |
| **Virtual Machine**| **VM Shutdown/Redeploy**| Virtual Machine | `VM Availability`, `Percentage CPU` (will drop to zero), `Network In/Out Total` |
| **VM Scale Set** | **VMSS Shutdown** | VM Scale Set | `Virtual Machine Scale Set Instance Count`, `Instance-level Percentage CPU` |

### Orchestration

| Fault Name | Notes |
| :--- | :--- |
| **Start/Stop Load Test** | This is not a fault. Metrics should be observed on the resources targeted by the Azure Load Testing service. |
| **Delay** | This is a wait action. It has no direct metric impact but is used to control the timing of your experiment steps. |
