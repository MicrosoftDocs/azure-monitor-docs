---
title: Deploy Service Health alert rules at scale using Azure Policy 
description: This article details a process by which users can deploy Service Health alerts across subscriptions via Azure policy.
ms.topic: conceptual
ms.date: 7/15/2025
---

# Deploy Service Health alerts at scale using Azure policy


This article explains how to deploy Service Health alerts across subscriptions using Azure policy.

## Requirements

See the permissions and roles required to run Azure Policy in Role-Based Access Control (RBAC) [Azure RBAC permissions in Azure Policy](/azure/governance/policy/overview#azure-rbac-permissions-in-azure-policy).

## Steps to deploy Service Health alert rules using Azure Policy

Service Health Alert rules can be deployed on a single subscription, or across all subscriptions in a management group by running the **Configure subscriptions to enable Service Health Monitoring Alert Rules** built-in policy.


1. From the Azure portal, navigate to **Home > Policy**. 
:::image type="content"source="./media/service-health-alerts-deploy/policy-home-authoring.png"alt-text="Screenshot of policy page."Lightbox="./media/service-health-alerts-deploy/policy-home-authoring.png"::: 
1. Under Authoring > Assignments, check if *Configure subscriptions to enable Service Health Monitoring Alert Rules* is assigned. 
1. If  not already assigned, under Authoring > Definitions, search for *Configure subscriptions to enable Service Health Monitoring Alert Rules* and select it. <!-- to be replaced by clicking link -->
1.  Select **Assign policy.** 
    :::image type="content"source="./media/service-health-alerts-deploy/assign-policy.png"alt-text="Screenshot of policy page to select the assigned policy."Lightbox="./media/service-health-alerts-deploy/assign-policy.png"::: 
 

1. In the **Basics** tab:

    :::image type="content"source="./media/service-health-alerts-deploy/policy-home-tabs.png"alt-text="Screenshot of policy page with tabs."Lightbox="./media/service-health-alerts-deploy/policy-home-tabs.png":::

    - Set the **Scope** to the management group that contains the subscriptions you want the service health alerts deployed to. You can also choose to scope it to a single subscription. This policy doesn't support a resource group-level scope.
    - Under **Exclusions**, add any subscriptions that the policy shouldn’t update. These subscriptions aren't checked for compliance and don't have any alert rules or resources created through the policy.
    - Don't use any resource selectors.
    - Make sure the Policy Definition contains **Configure subscriptions to enable Service Health Monitoring Alert** rules. You can also update the assignment name and description if needed.
    

1. In the **Parameters** tab: 
    - You can set the optional customization options (see [Default Behavior](#default-behavior) and [Customization Options](#customization-options)).
    
    
1. In the **Remediation** tab:

    :::image type="content"source="./media/service-health-alerts-deploy/policy-remediation.png"alt-text="Screenshot of Remediation tab."Lightbox="./media/service-health-alerts-deploy/policy-remediation.png":::

    - Ensure the system assigned managed identity is selected, or assign a user assigned managed identity.
    - Select **Create a remediation task** to automatically apply the policy to existing subscriptions. Without this step, the policy only applies to new subscriptions.
1. Select **Review and save** the assignment.


## Default behavior

When remediation runs, the policy automatically creates the following resources in all subscriptions that aren’t compliant:
- A resource group named **rg-serviceHealthAlert**.
- An enabled alert rule named **ServiceHealthSubscriptionAlertRule**. 
- An action group named **ag-ServiceHealthAlertActionGroup**. 


By default, the alert rules and action groups are configured to email subscription owners for all types service health events.

:::image type="content"source="./media/service-health-alerts-deploy/default-behavior.png"alt-text="Screenshot of path of default behavior."Lightbox="./media/service-health-alerts-deploy/default-behavior.png":::


## Customization options

>[!Note]
> On the **Parameters** tab, check to turn off *Only show parameters that need input or review* which will display all the parameters supported by the policy.

:::image type="content"source="./media/service-health-alerts-deploy/policy-parameters-1.png"alt-text="Screenshot of screen to set up parameters."Lightbox="./media/service-health-alerts-deploy/policy-parameters-1.png":::


- **Effect**: Allows the user to set the mode of the policy. <br>
    - *Disabled*: The policy doesn't run. <br>
    - *AuditIfNotExists*: The policy reports compliance but doesn't create any resources. It checks for the existence of an alert rule that has:<br>
        - The appropriate state is (enabled/disabled).<br>
        - A mapping to the action group is specified.<br>
        - A condition that checks for the event types is specified.<br>
    - *DeployIfNotExists*: During remediation, if the subscription is found to be noncompliant, it creates or updates the resources.

- **Alert rule enabled**:<br> The state of the alert rule (enabled or disabled) created by this policy can be updated to enable or disable alert rules across subscriptions.

- **Alert rule name**:<br> The name of the alert rule the policy creates. The policy doesn’t check the rule’s name, it only looks at the alert conditions, state, and whether it links to an action group. <br>If a rule already exists that meets these requirements, the policy doesn't create a new one, even if the name is different. Changing the name doesn't remove any existing alert rules.

- **Alert rule event types**:<br> The [Service Health Event Types](./service-health-portal-update.md#service-health-events) the alert rule checks for. This alert rule can be used to update the alerting condition across subscriptions. 

- **Existing action group resource ids**:<br> Enter the resource IDs of existing action groups within the management group or subscription (based on the policy’s scope) that should be used to send alerts. This action group can be used to alert across subscriptions.<br>For more information, see [Action Groups](/azure/azure-monitor/alerts/action-groups). 

:::image type="content"source="./media/service-health-alerts-deploy/alert-across-subscriptions.png"alt-text="Screenshot of the path of alerts across subscriptions."Lightbox="./media/service-health-alerts-deploy/alert-across-subscriptions.png":::


- **New action group creation**:<br>
    - If set to **true**, the policy creates a new action group for alerts. <br>
    - If set to **false**, no new action group is created. This step creates an action group in each subscription. 
<br>It can be used along side the **Existing action group resource ids** parameter. Both are mapped to the alert rule. 

- **New action group name**: <br>Enter an action group name to create new action group. Updating the name doesn't delete any previously created action group. The alert rule mapping to the action group is updated.

- **New action group roles to email**:<br> Arm built-in roles to notify using the new action group. <br>The policy only checks if the alert rule is linked to the action groups, it doesn’t use this parameter to check compliance. If you change this setting after assigning the policy, it won’t update the action group.<br> To apply updates across subscriptions, change the **Alert rule enabled** or **Alert rule event types** parameters, or set a new action group using the **New action group name** parameter. <br>
Possible values include:
    - Contributor
    - Owner
    - Reader
    - Monitoring Reader
    - Monitoring Contributor

- **New action group resources**:<br> Resources to be used by the new action group to send alerts. <br> The specified resources must already exist. <br>Currently email, logic app, Event Hubs, webhook, and Azure function are supported resources. <br>
Refer to documentation for [Action Groups](/azure/azure-monitor/alerts/action-groups). <br>The policy only checks if the alert rule is linked to the action groups as it doesn’t use this parameter to check compliance. If you change this setting after assigning the policy, it won’t update the action group. <br> To apply updates across subscriptions, change the **Alert rule enabled** or **Alert rule event types** settings, or set a new action group using the **New action group name** option. 

- **Resource group name**:<br> This resource group name is used only if the policy needs to create an alert rule or action group.<br> The policy doesn’t check the resource group name, it only checks the alert rule’s conditions, state, and if it links to an action group.<br> If a matching rule exists in a different resource group, the policy doesn't create a new one. Changing the name doesn't delete any existing resource group, alert rule, or action group.

- **Resource group location**:<br> The location used to create the resource group.

- **Resource tags**:<br> Tags on the resources created by this policy.


