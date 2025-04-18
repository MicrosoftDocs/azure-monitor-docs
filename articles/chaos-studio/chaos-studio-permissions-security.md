---
title: Permissions and security for Azure Chaos Studio
description: Understand how permissions work in Azure Chaos Studio and how you can secure resources from accidental fault injection.
author: prasha-microsoft
ms.author: abbyweisberg
ms.reviewer: carlsonr
ms.service: azure-chaos-studio
ms.topic: conceptual
ms.date: 05/06/2024
ms.custom: template-concept, devx-track-arm-template
---

# Permissions and security in Azure Chaos Studio

Azure Chaos Studio enables you to improve service resilience by systematically injecting faults into your Azure resources. Fault injection is a powerful way to improve service resilience, but it can also be dangerous. Causing failures in your application can have more impact than originally intended and open opportunities for malicious actors to infiltrate your applications.

Chaos Studio has a robust permission model that prevents faults from being run unintentionally or by a bad actor. In this article, you learn how you can secure resources that are targeted for fault injection by using Chaos Studio.

## How can I restrict the ability to inject faults with Chaos Studio?

Chaos Studio has three levels of security to help you control how and when fault injection can occur against a resource:

* First, a chaos experiment is an Azure resource that's deployed to a region, resource group, and subscription. Users must have appropriate Azure Resource Manager permissions to create, update, start, cancel, delete, or view an experiment.

   Each permission is a Resource Manager operation that can be granularly assigned to an identity or assigned as part of a role with wildcard permissions. For example, the Contributor role in Azure has `*/write` permission at the assigned scope, which includes `Microsoft.Chaos/experiments/write` permission.

   When you attempt to control the ability to inject faults against a resource, the most important operation to restrict is `Microsoft.Chaos/experiments/start/action`. This operation starts a chaos experiment that injects faults.

* Second, a chaos experiment has a [system-assigned managed identity](/azure/active-directory/managed-identities-azure-resources/overview) or a [user-assigned managed identity](/azure/active-directory/managed-identities-azure-resources/overview) that executes faults on a resource. If you choose to use a system-assigned managed identity for your experiment, the identity is created at experiment creation time in your Microsoft Entra tenant. User-assigned managed identites may be used across any number of experiments.

   When creating a chaos experiment in the Azure portal, you can choose to enable [automatic role assignment using Azure built-in roles or a custom role](chaos-studio-assign-experiment-permissions.md) on either your system-assigned or user-assigned managed identity selection. Enabling this functionality allows Chaos Studio to create and assign Azure built-in roles or a custom role containing any necessary experiment action capabilities to your experiment's identity (that do not already exist in your identity selection). If a chaos experiment is using a user-assigned managed identity, any custom roles assigned to the experiment identity by Chaos Studio will persist after experiment deletion.
  
  If you choose to grant your experiment permissions manually, you must grant its identity [appropriate permissions](chaos-studio-fault-providers.md) to all target resources. If the experiment identity doesn't have appropriate permission to a resource, it can't execute a fault against that resource.

* Third, each resource must be onboarded to Chaos Studio as [a target with corresponding capabilities enabled](chaos-studio-targets-capabilities.md). If a target or the capability for the fault being executed doesn't exist, the experiment fails without affecting the resource.

## User-assigned Managed Identity

A chaos experiment can utilize a [user-assigned managed identity](/azure/active-directory/managed-identities-azure-resources/overview) to obtain sufficient permissions to inject faults on the experiment's target resources. Additionally, user-assigned managed identities may be used across any number of experiments in Chaos Studio. To utilize this functionality, you must:
* First, create a user-assigned managed identity within the [Managed Identities](/azure/active-directory/managed-identities-azure-resources/overview) service. You may assign your user-assigned managed identity required permissions to run your chaos experiment(s) at this point.
* Second, when creating your chaos experiment in the Azure portal, select a user-assigned managed identity from your Subscription. You can choose to enable [automatic role assignment using Azure built-in roles or a custom role](chaos-studio-assign-experiment-permissions.md) at this step. Enabling this functionality would grant your identity selection any required permissions it may need based on the faults contained in your experiment.
* Third, after you've added all of your faults to your chaos experiment, review if your identity configuration contains all the necessary actions for your chaos experiment to run successfully. If it does not, contact your system administrator for access or edit your experiment's fault selections.

## Agent authentication

When you run agent-based faults, you must install the Chaos Studio agent on your virtual machine (VM) or virtual machine scale set. The agent uses a [user-assigned managed identity](/azure/active-directory/managed-identities-azure-resources/overview) to authenticate to Chaos Studio and an *agent profile* to establish a relationship to a specific VM resource.

When you onboard a VM or virtual machine scale set for agent-based faults, you first create an agent target. The agent target must have a reference to the user-assigned managed identity that's used for authentication. The agent target contains an *agent profile ID*, which is provided as configuration when you install the agent. Agent profiles are unique to each target and targets are unique per resource.

## Azure Resource Manager operations and roles

Chaos Studio has the following operations:

| Operation | Description |
|---|---|
| Microsoft.Chaos/targets/[Read,Write,Delete] | Get, create, update, or delete a target. |
| Microsoft.Chaos/targets/capabilities/[Read,Write,Delete] | Get, create, update, or delete a capability. |
| Microsoft.Chaos/locations/targetTypes/Read | Get all target types. |
| Microsoft.Chaos/locations/targetTypes/capabilityTypes/Read | Get all capability types. |
| Microsoft.Chaos/experiments/[Read,Write,Delete] | Get, create, update, or delete a chaos experiment. |
| Microsoft.Chaos/experiments/start/action | Start a chaos experiment. |
| Microsoft.Chaos/experiments/cancel/action | Stop a chaos experiment. |
| Microsoft.Chaos/experiments/executions/Read | Get the execution status for a run of a chaos experiment. |
| Microsoft.Chaos/experiments/executions/getExecutionDetails/action | Get the execution details (status and errors for each action) for a run of a chaos experiment. |

To assign these permissions granularly, you can [create a custom role](/azure/role-based-access-control/custom-roles). You may also use the following Azure built-in roles to manage access to Chaos Studio:
* **Chaos Studio Experiment Contributor**: Can create, run, and see details for experiments, onboard targets, and manage capabilities.
* **Chaos Studio Operator**: Can run and see details for experiments but cannot create experiments or manage targets and capabilities.
* **Chaos Studio Reader**: Can view targets, capabilities, experiments, and experiment details.
* **Chaos Studio Target Contributor**: Can onboard targets and manage capabilities but cannot create, run, or see details for experiments.

For more detailed information on these built-in roles for Chaos Studio operations, see [RBAC DevOps Roles](/azure/role-based-access-control/built-in-roles#devops).

## Network security

All user interactions with Chaos Studio happen through Azure Resource Manager. If a user starts an experiment, the experiment might interact with endpoints other than Resource Manager, depending on the fault:

* **Service-direct faults**: Most service-direct faults are executed through Azure Resource Manager and don't require any allowlisted network endpoints.
* **Service-direct AKS Chaos Mesh faults:** Service-direct faults for Azure Kubernetes Service that use Chaos Mesh require access to the AKS cluster's Kubernetes API server. Several methods to add the necessary IPs are included on [Authorize Chaos Studio IP addresses for an AKS cluster](chaos-studio-aks-ip-ranges.md).
* **Agent-based faults**: To use agent-based faults, the agent needs access to the Chaos Studio agent service. A VM or virtual machine scale set must have outbound access to the agent service endpoint for the agent to connect successfully. The agent service endpoint is `https://acs-prod-<region>.chaosagent.trafficmanager.net`. You must replace the `<region>` placeholder with the region where your VM is deployed. An example is `https://acs-prod-eastus.chaosagent.trafficmanager.net` for a VM in East US.
* **Agent-based private networking**: The Chaos Studio agent now supports private networking. Please see [Private networking for Chaos Agent](chaos-studio-private-link-agent-service.md). 

## Service tags
A [service tag](/azure/virtual-network/service-tags-overview) is a group of IP address prefixes that can be assigned to inbound and outbound rules for network security groups. It automatically handles updates to the group of IP address prefixes without any intervention. Since service tags primarily enable IP address filtering, service tags alone aren't sufficient to secure traffic.

You can use service tags to explicitly allow inbound traffic from Chaos Studio without the need to know the IP addresses of the platform. Chaos Studio's service tag is `ChaosStudio`.

A limitation of service tags is that they can only be used with applications that have a public IP address. If a resource only has a private IP address, service tags can't route traffic to it.

### Use cases
Chaos Studio uses Service Tags for several use cases.

* To use [agent-based faults](chaos-studio-fault-library.md#agent-based-faults), the Chaos Studio agent running inside customer virtual machines must communicate with the Chaos Studio backend service. The Service Tag lets customers allow-list the traffic from the virtual machine to the Chaos Studio service.
* To use certain faults that require communication outside the `management.azure.com` namespace, like [Chaos Mesh faults](chaos-studio-fault-library.md#azure-kubernetes-service) for Azure Kubernetes Service, traffic comes from the Chaos Studio service to the customer resource. The Service Tag lets customers allow-list the traffic from the Chaos Studio service to the targeted resource.
* Customers can use other Service Tags as part of the Network Security Group Rules fault to affect traffic to/from certain Azure services.

By specifying the `ChaosStudio` Service Tag in security rules, traffic can be allowed or denied for the Chaos Studio service without the need to specify individual IP addresses.

### Security considerations

When evaluating and using service tags, it's important to note that they don't provide granular control over individual IP addresses and shouldn't be relied on as the sole method for securing a network. They aren't a replacement for proper network security measures.

## Data encryption

Chaos Studio encrypts all data by default. Chaos Studio only accepts input for system properties like managed identity object IDs, experiment/step/branch names, and fault parameters. An example is the network port range to block in a network disconnect fault.

These properties shouldn't be used to store sensitive data, such as payment information or passwords. For more information on how Chaos Studio protects your data, see [Azure customer data protection](/azure/security/fundamentals/protection-customer-data).

## Customer Lockbox

Lockbox gives you the control to approve or reject Microsoft engineer request to access your experiment data during a support request.

Lockbox can be enabled for chaos experiment information, and permission to access data is granted by the customer at the subscription level if lockbox is enabled.

Learn more about [Customer Lockbox for Microsoft Azure](/azure/security/fundamentals/customer-lockbox-overview)

## Next steps
Now that you understand how to secure your chaos experiment, you're ready to:

- [Create and run your first experiment](chaos-studio-tutorial-service-direct-portal.md)
- [Create and run your first Azure Kubernetes Service experiment](chaos-studio-tutorial-aks-portal.md)
