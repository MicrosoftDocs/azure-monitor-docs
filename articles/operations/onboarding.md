---
title: Machine enrollment in Azure Operations center
description: Guidance for using machine enrollment in Azure Operations center to streamline onboarding and configuration of virtual machines.
ms.topic: conceptual
ms.date: 09/24/2025
---


# Machine enrollment in Azure Operations center

The machine enrollment feature in Azure operations center simplifies the onboarding and configuration of virtual machines (VMs) across your Azure environment. This feature allows for automated discovery, enrollment, and management of VMs, ensuring they are properly configured for monitoring and operational tasks.

## Features
The features automatically enabled for each VM in the enrolled subscription are listed in the following table.

| Feature | Description |
|:---|:---|
| Azure monitor insights | Monitors and provides insights into VM performance and health. |
| Azure policy and machine configurations | Ensures VMs comply with organizational policies and configurations. |
| Change tracking and inventory | Tracks changes to VM configurations and maintains an inventory of resources. |
| Azure update manager | Manages and automates the deployment of updates to VMs. |

## Concepts
Enable machine enrollment for each subscription to automatically onboard VMs. Once enabled, all existing and new VMs in the subscription are enrolled and configured with the features listed above.

### Excluding VMs

> [!NOTE]
> Is this possible other than manually modifying the policy assignments?

## Required permissions

You must have the following roles in the subscription being enabled:
- Essential Machine Management Administrator
- Managed Identity Operator roles

## Prerequisites

- [Log Analytics workspace](/azure/azure-monitor/logs/quick-create-workspace) to collect log data collected from VMs.
- [Azure Monitor workspace](/azure/azure-monitor/metrics/azure-monitor-workspace-manage) to collect metrics data collected from VMs.
- User assigned managed identity with the following roles assigned for the subscription:
  - Essential Machine Management Onboarding
  - Monitoring Reader



## Onboarding Steps

### 

1. Access the Ops360 portal via your organization's Azure environment.
2. Authenticate using your Azure AD credentials.
3. Configure initial settings, including resource groups and monitoring scope.
4. Invite team members and assign roles.
5. Review licensing and compliance requirements.

## Best Practices
- Start with a pilot group to validate workflows
- Use built-in templates for common operational scenarios
- Leverage agentic guidance for setup



## Enable machine management

### [Azure portal](#tab/portal)

Go to Operations center in the Azure portal and select **Machine enrollment**.

:::image type="content" source="./media/onboarding/machine-enrollment.png" lightbox="./media/onboarding/machine-enrollment.png" alt-text="Screenshot of machine enrollment screen with no subscriptions enabled.":::

Click **Enable** to enable machine management for a subscription.

#### Scope

The **Scope** tab includes the subscription that you want to enable and the managed identity.

| **Setting** | **Description** |
|:---|:---|
| **Select a subscription** | Click to select the subscription to enable. A list is provided with all subscriptions you have access to and the number of Azure VMs and Arc-enable dVMs in each. |
| **Required user role assignments** | Lists the required roles that your user account must be assigned to the managed identity. |
| **Current user role assignments** | Lists the roles that are currently assigned to your user account. |
| **User assigned managed identity** | Select the managed identity to use for onboarding VMs in the subscription. |
| **Required identity role assignment** | Lists the required roles the managed identity must be assigned. |
| **Current identity role assignment** | Lists the roles currently assigned to the managed identity. |

### Configure

The **Configure** tab includes the Log Analytics workspace and Azure Monitor workspace that will collect data from the managed VMs.

| **Setting** | **Description** |
|:---|:---|
| **Log Analytics workspace** | Select the Log Analytics workspace to use for collecting log data from VMs. |
| **Azure Monitor workspace** | Select the Azure Monitor workspace to use for collecting metrics data from VMs. |

## Security

The **Security** tab allows you to select additional security services for the managed VMs.

| **Setting** | **Description** |
|:---|:---|
| **Log Analytics workspace** | Continuously assess your cloud environment with agentless, risk-prioritized insights. Recommended for all workloads.<br><br>This add-on incurs no additional charge.  |
| **Defender CSPM** | Continuously assess your cloud environment with agentless, risk-prioritized insights. Recommended for all workloads.<br><br>This add-on incurs an additional charge. |
| **Defender for cloud** | Comprehensive server protection with integrated endpoint detection and response (EDR), vulnerability management, file integrity monitoring, and advanced threat detection. Recommended for business-critical workloads.<br><br>This add-on incurs an additional charge. |


### [CLI](#tab/cli)

### [PowerShell](#tab/powershell)

### [Bicep](#tab/bicep)

---

## Policy assignments provisioned

| Assignment | Initiative | Description |
|:---|:---|:---|
| Enable Azure Monitor for VMs with Azure Monitoring Agent(AMA) | Enable Azure Monitor for VMs with Azure Monitoring Agent(AMA) | Enables Azure Monitor for VMs with Azure Monitoring Agent (AMA) to collect metrics and logs. |

## Next steps