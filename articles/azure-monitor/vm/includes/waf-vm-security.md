---
ms.topic: include
ms.date: 03/19/2025
---

#### Implement security monitoring of VMs using Azure security services

While Azure Monitor can collect security events from your VMs, it isn't intended to be used for security monitoring. Azure includes multiple services such as [Microsoft Defender for Cloud](/azure/defender-for-cloud/) and [Microsoft Sentinel](/azure/sentinel/) that together provide a complete security monitoring solution. See [Security monitoring](../monitor-virtual-machine.md#security-monitoring) for a comparison of these services.

#### Connect VMs to Azure Monitor through a private endpoint using Azure private link 

Microsoft secures connections to public endpoints with end-to-end encryption. If you require a private endpoint, use [Azure private link](../../../azure-monitor/logs/private-link-security.md) to allow resources to connect to your Log Analytics workspace through authorized private networks. You can also use Private link to force workspace data ingestion through ExpressRoute or a VPN.

**Instructions**:  [Design your Azure Private Link setup](../../../azure-monitor/logs/private-link-design.md) 
