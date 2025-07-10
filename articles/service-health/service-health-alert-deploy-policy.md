---
title: Deploy Service Health Alert Rules at Scale using Azure Policy 
description: This article details a process by which users can deploy service health alerts across subscriptions via Azure policy
ms.topic: conceptual
ms.date: 7/10/2025
---

# Deploy Service Health Alerts at Scale using Azure Policy


This article explains how to deploy service health alerts across subscriptions via Azure policy.

## Requirements

See permissions and roles required to run Azure Policy in [Azure RBAC permissions in Azure Policy](./policy/overview#azure-rbac-permissions-in-azure-policy).

## Steps to deploy Service Health Alert Rules using Azure Policy

Service Health Alert Rules can be deployed on a single subscription or across all subscriptions in a management group by running the **Configure subscriptions to enable Service Health Monitoring Alert Rules** built-in policy.

1.  Navigate to Home > Policy. 
- Under Authoring > Assignments, check if "Configure subscriptions to enable Service Health Monitoring Alert Rules" isn't already deployed 
- Under Authoring > Definitions, search for "Configure subscriptions to enable Service Health Monitoring Alert Rules" and select it <!-- to be replaced by clicking link -->
2.  Select Assign policy 
- Under the Basics tab:
    - Set the **Scope** to the management group that updates the policy subscriptions. You can also choose to scope it to a single subscription. This policy doesn't support resource group-level scope.
    - Under **Exclusions**, add any subscriptions that the policy shouldn’t update. These subscriptions aren't checked for compliance and don't have any alert rules or resources created through the policy.
    - Don't use any resource selectors
    - Ensure the Policy Definition contains "Configure subscriptions to enable Service Health Monitoring Alert Rules" and optionally edit the assignment name and description
- Under Parameters tab: 
    - Set the optional customization options (see [Default Behavior](#default-behavior) and [Customization Options](#customization-options)).
- Under Remediation
    - Ensure the system assigned managed identity is selected, or assign a user assigned managed identity.
    - Select **Create a remediation task** to automatically apply the policy to existing subscriptions. Without this step, the policy only applies to new subscriptions.

## Default Behavior

By default on remediation, the policy creates the following resources in all noncompliant subscriptions: 
- A resource Group named **rg-serviceHealthAlert**
- An enabled alert rule named **ServiceHealthSubscriptionAlertRule** 
- An action group named **ag-ServiceHealthAlertActionGroup** 


By default, the alert rules and action groups are configured to email subscription owners for all service health events types.

:::image type="content"source="./media/service-health-alerts-deploy/default-behavior-1.png"alt-text="Screenshot of path of default behavior."Lightbox="./media/service-health-alerts-deploy/default-behavior-1.png":::


## Customization Options

Under the Parameters Tab uncheck the *Only show parameters that need input or review* to show the parameters the policy supports.

:::image type="content"source="./media/service-health-alerts-deploy/policy-parameters-1.png"alt-text="Screenshot of screen to set up parameters."Lightbox="./media/service-health-alerts-deploy/policy-parameters-1.png":::


- **Effect**: Allows the user to set the mode of the policy. <br>
    - *Disabled*: The policy doesn't run <br>
    - *AuditIfNotExists*: The policy reports compliance but doesn't create any resources. It checks for the existence of an alert rule that has:<br>
        - The appropriate state (enabled/disabled)<br>
        - A mapping to the action group specified<br>
        - A condition that checks for the event types specified<br>
    - *DeployIfNotExists*: On remediation if the subscription is found to be noncompliant it creates/updates the resources.

- **Alert rule enabled**: The state of the alert rule (enabled/disabled) created by this policy. can be updated to enable/disable alert rules across subscriptions

- **Alert rule name**: This is the name of the alert rule the policy creates. The policy doesn’t check the rule’s name, it only looks at the alert conditions, state, and whether it links to an action group. <br>If a rule already exists that meets these requirements, the policy doesn't create a new one, even if the name is different. Changing the name doesn't remove any existing alert rules.

- **Alert rule event types**: The [Service Health Event Types](/service-health-overview.md#service-health-events) the alert rule checks for. This alert rule can be used to update the alerting condition across subscriptions. 

- **Existing action group resource ids**: The resource IDs of existing action groups in the Management Group/Subscription (depending on policy assignment scope) to be used to send alerts.<br> This action group can be used to alert across subscriptions. <br>Refer to the documentation for [Action Groups](/azure/azure-monitor/alerts/action-groups). 

:::image type="content"source="./media/service-health-alerts-deploy/alert-across-subscriptions.png"alt-text="Screenshot of the path of alerts across subscriptions."Lightbox="./media/service-health-alerts-deploy/alert-across-subscriptions.png":::



- **New action group creation**:<br>
    - If set to true, the policy creates a new action group for alerts. <br>
    - If set to false, no new action group is created. This step creates an action group in each subscription. 
<br>It can be used along side the **Existing action group resource ids** parameter. Both are mapped to the alert rule. 

- **New action group name**: Enter an action group name to create new action group. Updating the name doesn't delete any previously created action group. The alert rule mapping to the action group is updated.

- **New action group roles to email**: Arm built-in roles to notify using the new action group. <br>The policy only checks if the alert rule is linked to the action groups, it doesn’t use this parameter to check compliance.  If you change this setting after assigning the policy, it won’t update the action group.<br> To apply updates across subscriptions, change the **Alert rule enabled** or **Alert rule event types** parameters, or set a new action group using the **New action group name** parameter. <br>
Possible values include:
    - Contributor
    - Owner
    - Reader
    - Monitoring Reader
    - Monitoring Contributor

- **New action group resources**: Resources to be used by the new action group to send alerts. <br> The specified resources must already exist. <br>Currently email, logic app, Event Hubs, webhook, and Azure function are supported resources. <br>
Refer to documentation for [Action Groups](/azure/azure-monitor/alerts/action-groups). <br>The policy only checks if the alert rule is linked to the action groups as it doesn’t use this parameter to check compliance. If you change this setting after assigning the policy, it won’t update the action group. <br> To apply updates across subscriptions, change the **Alert rule enabled** or **Alert rule event types** settings, or set a new action group using the **New action group name** option. 

- **Resource group name**: This resource group name is used only if the policy needs to create an alert rule or action group.<br> The policy doesn’t check the resource group name, it only checks the alert rule’s conditions, state, and if it links to an action group.<br> If a matching rule exists in a different resource group, the policy doesn't create a new one. Changing the name doesn't delete any existing resource group, alert rule, or action group.

- **Resource group location**: Location used to create the resource group.

- **Resource tags**: Tags on the resources created by this policy.


