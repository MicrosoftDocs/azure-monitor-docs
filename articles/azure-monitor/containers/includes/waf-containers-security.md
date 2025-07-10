---
ms.topic: include
ms.date: 05/21/2025
---

#### Connect clusters to Container insights using managed identity authentication 

[Managed identity authentication](../container-insights-authentication.md) is the default authentication method for new clusters. If you're using legacy authentication, migrate to managed identity to remove the certificate-based local authentication. 

**Instructions**: [Migrate to managed identity authentication](../container-insights-authentication.md)

#### Send data from clusters to Azure Monitor through a private endpoint using Azure private link 

Azure managed service for Prometheus stores its data in an Azure Monitor workspace, which uses a public endpoint by default. Microsoft secures connections to public endpoints with end-to-end encryption. If you require a private endpoint, use [Azure private link](../../../azure-monitor/logs/private-link-security.md) to allow your cluster to connect to the workspace through authorized private networks. Private link can also be used to force workspace data ingestion through ExpressRoute or a VPN.

**Instructions**: See [Enable private link for Kubernetes monitoring in Azure Monitor](../kubernetes-monitoring-private-link.md) for details on configuring your cluster for private link. See [Use private endpoints for Managed Prometheus and Azure Monitor workspace](../../essentials/azure-monitor-workspace-private-endpoint.md) for details on querying your data using private link.

#### Monitor network traffic to and from clusters using traffic analytics 

[Traffic analytics](/azure/network-watcher/traffic-analytics) analyzes Azure Network Watcher NSG flow logs to provide insights into traffic flow in your Azure cloud. Use this tool to ensure there's no data exfiltration for your cluster and to detect if any unnecessary public IPs are exposed.

#### Enable network observability

[Network observability add-on for AKS](https://techcommunity.microsoft.com/t5/azure-observability-blog/comprehensive-network-observability-for-aks-through-azure/ba-p/3825852) provides observability across the multiple layers in the Kubernetes networking stack. Monitor and observe access between services in the cluster (east-west traffic).

**Instructions**: [Set up Container Network Observability for Azure Kubernetes Service (AKS)](/azure/aks/container-network-observability-how-to)

#### Secure your Log Analytics workspace

Container insights sends data to a Log Analytics workspace. Make sure to secure log ingestions and storage in your Log Analytics workspace.

**Instructions**: [Log ingestion and storage](../../fundamentals/best-practices-security.md#log-ingestion-and-storage).


