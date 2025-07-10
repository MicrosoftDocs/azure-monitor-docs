---
title: Use Azure Policy to Install the Azure Monitor Agent
description: Learn about options for managing the Azure Monitor Agent on Azure virtual machines and Azure Arc-enabled servers.
ms.topic: install-set-up-deploy
ms.date: 11/14/2024
ms.custom: devx-track-azurepowershell, devx-track-azurecli
ms.reviewer: jeffwo

---

# Use Azure Policy to install and manage the Azure Monitor Agent

You can use [Azure Policy](/azure/governance/policy/overview) to automatically install the Azure Monitor Agent on existing and new virtual machines and have relevant data collection rules (DCRs) automatically associated with them. This article describes the built-in policies and initiatives you can use for this functionality and Azure Monitor features that can help you manage them.

Use the following policies and policy initiatives to automatically install the agent and associate it with a DCR each time you create a virtual machine, virtual machine scale set, or Azure Arc-enabled server.

> [!NOTE]
> Azure Monitor has a preview [DCR](../essentials/data-collection-rule-overview.md) experience that simplifies creating assignments for policies and initiatives that use DCRs. The experience includes initiatives that install the Azure Monitor Agent. You can choose to use that experience to create assignments for the initiatives described in this article. For more information, see [Manage data collection rule associations in Azure Monitor](../data-collection/data-collection-rule-associations.md#preview-dcr-experience).

## Prerequisites

Before you begin, review [prerequisites for agent installation](azure-monitor-agent-manage.md#prerequisites).

> [!NOTE]
> Per Microsoft identity platform best practices, policies for installing the Azure Monitor Agent on virtual machines and virtual machine scale sets rely on a user-assigned managed identity. This option is the more scalable and resilient managed identity for these resources.
>
> For Azure Arc-enabled servers, policies rely on a system-assigned managed identity as currently the only supported option.

## Built-in policies

You can choose to use the individual policies from the policy initiatives described in the next section to perform a single action at scale. For example, if you want to automatically install only the agent, use the second agent installation policy in the initiative.

:::image type="content" source="media/azure-monitor-agent-install/built-in-ama-dcr-policy.png" lightbox="media/azure-monitor-agent-install/built-in-ama-dcr-policy.png" alt-text="Screenshot of the Azure Policy Definitions page that shows policies contained within the initiative for configuring Azure Monitor Agent.":::

## Built-in policy initiatives

Built-in policy initiatives for Windows and Linux virtual machines and scale sets provide end-to-end, at-scale onboarding by using the Azure Monitor Agent:

- [Deploy the Azure Monitor Agent for Windows client machines by using user-assigned managed identity-based auth and associate it with a DCR](https://ms.portal.azure.com/#view/Microsoft_Azure_Policy/InitiativeDetailBlade/id/%2Fproviders%2FMicrosoft.Authorization%2FpolicySetDefinitions%2F0d1b56c6-6d1f-4a5d-8695-b15efbea6b49/scopes~/%5B%22%2Fsubscriptions%2Fae71ef11-a03f-4b4f-a0e6-ef144727c711%22%5D)
- [Deploy the Azure Monitor Agent for Linux client machines by using user-assigned managed identity-based auth and associate it with a DCR](https://ms.portal.azure.com/#view/Microsoft_Azure_Policy/InitiativeDetailBlade/id/%2Fproviders%2FMicrosoft.Authorization%2FpolicySetDefinitions%2Fbabf8e94-780b-4b4d-abaa-4830136a8725/scopes~/%5B%22%2Fsubscriptions%2Fae71ef11-a03f-4b4f-a0e6-ef144727c711%22%5D)  

> [!NOTE]
> The policy definitions include only the list of Windows and Linux versions that Microsoft supports. To add a custom image, use the **Additional Virtual Machine Images** parameter.

These initiatives contain individual policies that:

- (Optional) Create and assign one built-in user-assigned managed identity per subscription and per region. [Learn more](/azure/active-directory/managed-identities-azure-resources/how-to-assign-managed-identity-via-azure-policy#policy-definition-and-details).
  - **Bring Your Own User-Assigned Identity**:
  
     - If set to **false**, it creates the built-in user-assigned managed identity in the predefined resource group and assigns it to all the machines that the policy is applied to. The location of the resource group can be configured in the **Built-In-Identity-RG Location** parameter.
     - If set to **true**, you can instead use an existing user-assigned identity that is automatically assigned to all the machines that the policy is applied to.
- Install Azure Monitor Agent extension on the machine, and configure it to use the user-assigned identity as specified by the following parameters:

   - **Bring Your Own User-Assigned Identity**:
      
      - If set to **false**, it configures the agent to use the built-in user-assigned managed identity created by the preceding policy.
      - If set to **true**, it configures the agent to use an existing user-assigned identity.
  - **User-Assigned Managed Identity Name**: If you use your own identity (**true** is selected), specify the name of the identity that's assigned to the machines.
  - **User-Assigned Managed Identity Resource Group**: If you use your own identity (**true** is selected), specify the resource group where the identity exists.
  - **Additional Virtual Machine Images**: Pass additional virtual machine image names that you want to apply the policy to, if they are not already included.
  - **Built-In-Identity-RG Location**: If you use a built-in user-assigned managed identity, specify the location to create the identity and the resource group. This parameter is used only when the **Bring Your Own User-Assigned Managed Identity** parameter is set to **false**.
- Create and deploy the association to link the machine to specified DCR.

  - **Data Collection Rule Resource Id**: The Azure Resource Manager **resourceId** value of the rule you want to associate via this policy to all machines the policy is applied to.

    :::image type="content" source="media/azure-monitor-agent-install/built-in-ama-dcr-initiatives.png" lightbox="media/azure-monitor-agent-install/built-in-ama-dcr-initiatives.png" alt-text="Screenshot that shows the Azure Policy Definitions page with two built-in policy initiatives for configuring the Azure Monitor Agent.":::

## Known issues

- Managed identity default behavior. [Learn more](/azure/active-directory/managed-identities-azure-resources/managed-identities-faq#what-identity-will-imds-default-to-if-dont-specify-the-identity-in-the-request).
- Possible race condition when using a built-in user-assigned identity creation policy. [Learn more](/azure/active-directory/managed-identities-azure-resources/how-to-assign-managed-identity-via-azure-policy#known-issues).
- Assigning policy to resource groups. If the assignment scope of the policy is a resource group and not a subscription, the identity that's used by the policy assignment (which is different from the user-assigned identity that's used by agent) must be manually granted [specific roles](/azure/active-directory/managed-identities-azure-resources/how-to-assign-managed-identity-via-azure-policy#required-authorization) before assignment or remediation. Failing to do this step results in *deployment failures*.
- Other [managed identity limitations](/azure/active-directory/managed-identities-azure-resources/managed-identities-faq#limitations).

### Remediation

The initiatives or policies apply to each virtual machine as it's created. A [remediation task](/azure/governance/policy/how-to/remediate-resources) deploys the policy definitions in the initiative to existing resources. You can configure the Azure Monitor Agent for any resources that were already created.

When you create the assignment by using the Azure portal, you have the option of creating a remediation task at the same time. For information on the remediation, see [Remediate noncompliant resources by using Azure Policy](/azure/governance/policy/how-to/remediate-resources).

:::image type="content" source="media/azure-monitor-agent-install/built-in-ama-dcr-remediation.png" lightbox="media/azure-monitor-agent-install/built-in-ama-dcr-remediation.png" alt-text="Screenshot that shows initiative remediation for the Azure Monitor Agent.":::

## Related content

[Create a DCR](./azure-monitor-agent-send-data-to-event-hubs-and-storage.md) to collect data from the agent and send it to Azure Monitor.
