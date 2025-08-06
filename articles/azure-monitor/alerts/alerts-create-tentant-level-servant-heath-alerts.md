# Tenant-level Service Health Alerts

## Scenarios and Troubleshooting Guide

Refer to this document for scenarios and common troubleshooting cases when creating and managing tenant-level Service Health (SH) alerts.

### **Scenarios**

1.  **Create the alert rule from the Service Health page**
-   In the Azure portal, go to Monitor \> Service Health, and select “Create service health alert”. A context pane will open.
-   Under **Scope**, select the “Scope level” as Directory. The current directory will be displayed.
-   Under the **Condition** section, select the services, regions, and event types you’re interested in monitoring.
-   Under the **Details** section, name the alert rule and select where to save it.
-   ![A screenshot of a computer AI-generated content may be incorrect.](media/3263ad11f8d9c009e9cfe11ad8ebcc74.png)Under the **Notify me by** section, select what actions to trigger when an alert fires.

**  
**

1.  **Create the alert rule from the Alert rule creation wizard**
-   In the Azure portal, go to Monitor \> Alerts.
-   In the top command bar, select Create \> Alert rule. The alert rule creation wizard will open.
-   In the **Scope** tab, select the “Scope level” as Directory. The current directory will be displayed.
-   In the **Condition** section, select the services, regions, and event types you’re interested in monitoring.
-   Continue creating the alert rule.

    ![](media/854d013cd1ead4b44ef098393baa4de4.png)

![A screenshot of a computer AI-generated content may be incorrect.](media/a428a610b496c97e3415c4e694db4363.png)**  
**

### **Troubleshooting Cases**

### **Case 1: No permissions to create the tenant-level SH alert rule**

To create an alert rule that monitors tenant-level Service Health events, the user needs to have read access to tenant data. Such access can be granted when the user is associated with an Entra role, as indicated here: [Roles with tenant admin access - Azure Service Health \| Microsoft Learn](https://learn.microsoft.com/en-us/azure/service-health/admin-access-reference)

When attempting to create a tenant-level SH alert rule without the required permissions, the user will get an unauthorized error message like the below:

![](media/236fc93ce2eb7e1feb00e05495c694ab.png)

**Recommendation to customer**

Make sure the user attempting to create the alert rule has tenant admin access. If the user lacks the necessary permissions, they will receive a 'No access' result and should consult their subscription owner for the being granted access.

**  
**

### **Case 2: Fired tenant-level SH alerts aren’t shown in the alerts list**

With this release, alerts fired on tenant-level SH events will not be shown in the alerts list.

When a tenant-level SH alert fires, any actions associated with the alert rule (e.g. email, webhook) will contain a link to view the tenant-level event in the Azure Service Health portal page.

In the example below, the alert email contains a link to view the event in the Service Health page, unlike other alert emails which contain a link to view the alert details.

Support for displaying fired tenant-level SH alerts in the alerts lists will be added in future releases.

![](media/c381884777750a2192e58783943520ad.png)

**Recommendation to customer**

The view tenant-level events, users should open the Service Health page in the portal.

### **Case 3: A tenant-level SH alert rule didn’t fire on subscription-level events**

Tenant-level Service Health events only cover tenant-related (i.e. Entra) issues. That means users shouldn’t expect to get both a tenant-level and subscription-level SH alerts for the same problem.

**Recommendation to customer**

In order to monitor both tenant-level and subscription-level SH events, there’s need to create separate alert rules with different scopes:

-   A Service Health alert rule scoped to the tenant
-   A Service Health alert rules scoped to the subscription. A separate alert rule is required for each subscription that customer would like to monitor.

**  
**

### **Getting help**

If the troubleshooting steps provided above have not helped you to resolve the issue, search for [known issues](https://supportability.visualstudio.com/AzureMonitor/_search?text=Tags%3A%22AlertsAndActionGroups%22&type=workitem&pageSize=100&filters=Projects%7BAzureMonitor%7DWork%20Item%20Types%7BKnown%20Issue%7DStates%7BPublished%7D), or reach out for assistance in the [Alerting swarming channel](https://teams.microsoft.com/l/channel/19%3aae954770e1b4435eb09d50f8ef9ca366%40thread.tacv2/Alerts%252C%2520Action%2520Groups?groupId=2fb9049b-bc9c-4cca-a900-84f22c86116c&tenantId=72f988bf-86f1-41af-91ab-2d7cd011db47).

**Product Group Escalation**

Unless you have been directly advised by a member of the product group, a technical advisor or an applicable subject matter expert, ensure you have exhausted your CSS resources before escalating to the Product Group.

To escalate an issue to the product team, review and follow article: [Product Group Escalation](https://dev.azure.com/Supportability/AzureMonitor/_wiki/wikis/AzureMonitor.wiki?wikiVersion=GBwikiMaster&pagePath=/Azure%20Monitor/Collaboration%20Guides/Product%20Group%20Escalation)
