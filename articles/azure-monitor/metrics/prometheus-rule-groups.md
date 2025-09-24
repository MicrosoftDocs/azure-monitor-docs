---
title: Rule Groups in Azure Monitor Managed Service for Prometheus
description: Description of rule groups in Azure Monitor managed service for Prometheus which alerting and data computation.
ms.topic: how-to
ms.date: 11/09/2024
---

# Azure Monitor managed service for Prometheus rule groups

Rules in Prometheus act on data as the data is collected, either to precompute values stored in the time series or to alert on predefined conditions in your collected metrics. Azure Monitor managed service for Prometheus provides predefined sets of each type of rule and allows you to create and manage custom rules using the Azure portal. 

## Rule groups and types
A Prometheus rule group is a collection of alert rules/or and recording rules that are evaluated together. Every rule must be a member of a single rule group. Rule groups define the scope of all the rules in the group and the frequency that they're evaluated.

There are two types of Prometheus rules.

| Type | Description |
|:-----|:------------|
| Alert | [Alert rules](https://aka.ms/azureprometheus-promio-alertrules) let you create an Azure Monitor alert based on the results of a Prometheus Query Language (PromQL) query. Alerts fired by Azure Managed Prometheus alert rules are processed and trigger notifications in similar ways to other Azure Monitor alerts. |
| Recording | [Recording rules](https://aka.ms/azureprometheus-promio-recrules) allow you to precompute frequently needed or computationally extensive expressions and store their result as a new set of time series. Time series created by recording rules are ingested back to your Azure Monitor workspace as new Prometheus metrics. |

Azure Managed Prometheus rule groups follow the structure and terminology of the [open-source Prometheus rule groups](https://prometheus.io/docs/prometheus/latest/configuration/recording_rules/). Rule names, expressions, labels, and annotations are all supported in Azure. 

There are some differences between Azure Managed Prometheus rule groups and open-source Prometheus rule groups though. Azure Managed Prometheus rule groups are managed as Azure resources and include information required for resource management, such as the subscription and resource group where the Azure rule group should reside. Alert rules include dedicated properties, such as alert severity, action group association, and alert autoresolve configuration, that allow alerts to be processed like other Azure Monitor alerts. 


## Scope of a rule group
The scope of a rule group in Azure Managed Prometheus rule groups defines what resources the rules in the group are applied to. Individual rules can't be applied directly to a Kubernetes cluster. The following table describes the different rule group scopes. 

| Scope | Description |
|:---|:---|
| All clusters in the workspace | All enabled rules in the group will be applied to all clusters currently connected to the Azure Monitor workspace. |
| Specific cluster - Cluster name | All enabled rules in the group will be applied only to the selected cluster. |
| Specific cluster - Cluster name in query | All enabled rules in the group will be applied clusters with the specified text in their name. |


## View  Prometheus rule groups
There are multiple ways to view Prometheus rule groups and their rules in the Azure portal.

**Rules in an Azure Monitor workspace**
Select **Rule groups** from an Azure Monitor workspace in the Azure portal to view all rule groups in that workspace. You can expand any rule group to view the list of rules in that group. Select any group or rule to view its details.

:::image type="content" source="media/prometheus-rule-groups/rule-groups-workspace.png" alt-text="Screenshot of Prometheus rule groups from Azure Monitor workspace." lightbox="media/prometheus-rule-groups/rule-groups-workspace.png"  border="false":::

**All rules**
From the **Alerts** page in the **Monitor** menu in the Azure portal, select **Prometheus rule groups** to view all rules groups in subscriptions you have access to. 

:::image type="content" source="media/prometheus-metrics-rule-groups/prometheus-rule-groups-from-alerts.png" alt-text="Screenshot that shows how to view Prometheus rule groups from the alerts screen.":::

This view identifies the workspace where the rule group is located, whether it's enabled, and the cluster if the rule group is limited to a specific cluster scope. Use the filters at the top of the screen to narrow the list of rule groups by various properties. You can delete multiple rule groups from this view by selecting them and then clicking **Delete**. This can be useful, for example, to cleanup rule groups that are no longer needed after deleting a cluster.

:::image type="content" source="media/prometheus-rule-groups/rule-groups-all.png" alt-text="Screenshot of all Prometheus rule groups." lightbox="media/prometheus-rule-groups/rule-groups-all.png"  border="false":::

> [!TIP]
> You can also access this same view from the **Alerts** page of a Kubernetes cluster. This will set the initial filter to the rule groups scoped to that cluster.


## Create Prometheus rule groups and rules

### [Azure portal](#tab/portal)


Open the **All rules** view described about and select **+ Create**

:::image type="content" source="media/prometheus-metrics-rule-groups/create-rule-group.png" lightbox="media/prometheus-metrics-rule-groups/create-rule-group.png" alt-text="Screenshot that shows option to create a new Prometheus rule group.":::

**Scope**

| Setting | Description |
|:---|:---|
| Azure Monitor workspace | The Azure Monitor workspace the rule group will query data from. This value can't be changed for an existing rule group. |
| Location | Location of the selected Azure Monitor workspace. |
| Cluster | Specifies where rule group applies to all clusters in the workspace or a specific cluster. Either select a specific cluster or enter text to match against cluster names. |

**Details**

| Setting | Description |
|:---|:---|
| Subscription | Subscription where the rule group resource will be created. This value can't be changed for an existing rule group. |
| Resource group | Resource group where the rule group resource will be created. This value can't be changed for an existing rule group. |
| Name | Name of the rule group resource. This name must be unique within the selected resource group. This value can't be changed for an existing rule group. |
| Description | Description of the rule group. |
| Evaluate every | Frequency that the rules in the group are evaluated. Default is 1 minute. |
| Enabled | Enable or disable the rule group. Disabled rule groups will still be created, but the rules will only be run if the group is enabled. |
| Labels | Optional label key/value pairs for the rule. These labels are added to the metric created by the rule. |

**Rules**
Select **Add recording rule** or **Add alert rule** to add rules to the group. Each tpe of rule has different settings as described below.

**Recording rules**

| Setting | Description |
|:---|:---|
| Name | Name of the recording rule. This name is used for the metric created by the rule. |
| Enabled | Specifies whether the rule is enabled or disabled. Disabled rules will be created, but won't be evaluated until enabled. |
| Expression | PromQL expression that defines the rule. Select **Run Query** to see the results of the expression query visualized in the preview chart. Modify the preview time range to zoom in or out on the expression result history. |

**Alert rules**

| Setting | Description |
|:---|:---|
| Name | Name of the recording rule. This name is the name of alerts fired by the rule. |
| Severity | Severity value for alerts fired by this rule. |
| Expression | PromQL expression that defines the rule. Select **Run Query** to see the results of the expression query visualized in the preview chart. Modify the preview time range to zoom in or out on the expression result history. |
| Wait for | Time period between when the alert expression first becomes true and until the alert is fired.
| Labels | Optional label key/value pairs for the rule. These labels are added to the alerts fired by the rule. |
| Annotations | Optional annotation key/value pairs for the rule. These annotations are added to the alerts fired by the rule. |
| Action groups | [Action groups](../alerts/action-groups.md) that define the response to the alert being fired. |
| Enabled | Specifies whether the rule is enabled or disabled. Disabled rules will be created, but won't be evaluated until enabled. |
| Automatically resolve alerts |  Automatically resolve alerts if the rule condition is no longer true during the **Time to auto-resolve** period. |



#### Configure the rule group scope

On the **Scope** tab:

1. Select the Azure Monitor workspace from a list of workspaces that are available in your subscriptions. The rules in this group query data from this workspace.

1. To limit your rule group to a cluster scope, select the **Specific cluster** option:

    * Select the cluster from the list of clusters that are already connected to the selected Azure Monitor workspace.
    * The default **Cluster name** value is entered for you. Change this value only if you changed your cluster label value by using [cluster_alias](../containers/prometheus-metrics-scrape-configuration.md#cluster-alias).

1. Select **Next** to configure the rule group details.

   :::image type="content" source="media/prometheus-metrics-rule-groups/create-new-rule-group-scope.png" alt-text="Screenshot that shows configuration of Prometheus rule group scope.":::

### [CLI](#tab/cli)
Use the [az alerts-management prometheus-rule-group create](/cli/azure/alerts-management/prometheus-rule-group#commands) command to create a new Prometheus rule group.


```azurecli
 az alerts-management prometheus-rule-group create \
--name my-rule-group --resource-group my-resource-group --location westus --enabled \
--description "Sample Prometheus resource group" --interval PT10M \
--scopes "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourcegroups/testrg/providers/microsoft.monitor/accounts/testaccount" \
--rules [{"record":"test","expression":"test","labels":{"team":"prod"}},{"alert":"Billing_Processing_Very_Slow","expression":"test","enabled":"true","severity":2,"for":"PT5M","labels":{"team":"prod"},"annotations":{"annotationName1":"annotationValue1"},"resolveConfiguration":{"autoResolved":"true","timeToResolve":"PT10M"},"actions":[{"actionGroupId":"/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/testrg/providers/microsoft.insights/actionGroups/test-action-group-name1","actionProperties":{"key11":"value11","key12":"value12"}},{"actionGroupId":"/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/testrg/providers/microsoft.insights/actionGroups/test-action-group-name2","actionProperties":{"key21":"value21","key22":"value22"}}]}]
```

### [PowerShell](#powershell)
To create a Prometheus rule group by using PowerShell, use the [new-azprometheusrulegroup](/powershell/module/az.alertsmanagement/new-azprometheusrulegroup) cmdlet.


```powershell
$rule1 = New-AzPrometheusRuleObject -Record "job_type:billing_jobs_duration_seconds:99p5m"
$action = New-AzPrometheusRuleGroupActionObject -ActionGroupId /subscriptions/fffffffff-ffff-ffff-ffff-ffffffffffff/resourceGroups/MyresourceGroup/providers/microsoft.insights/actiongroups/MyActionGroup -ActionProperty @{"key1" = "value1"}
$Timespan = New-TimeSpan -Minutes 15
$rule2 = New-AzPrometheusRuleObject -Alert Billing_Processing_Very_Slow -Expression "job_type:billing_jobs_duration_seconds:99p5m > 30" -Enabled $false -Severity 3 -For $Timespan -Label @{"team"="prod"} -Annotation @{"annotation" = "value"} -ResolveConfigurationAutoResolved $true -ResolveConfigurationTimeToResolve $Timespan -Action $action
$rules = @($rule1, $rule2)
$scope = "/subscriptions/fffffffff-ffff-ffff-ffff-ffffffffffff/resourcegroups/MyresourceGroup/providers/microsoft.monitor/accounts/MyAccounts"
New-AzPrometheusRuleGroup -ResourceGroupName MyresourceGroup -RuleGroupName MyRuleGroup -Location eastus -Rule $rules -Scope $scope -Enabled
```

### [ARM](#tab/arm)

The following sample template creates a Prometheus rule group, including one recording rule and one alert rule. This template creates a resource of type `Microsoft.AlertsManagement/prometheusRuleGroups`. The scope of this group is limited to a single AKS cluster. The rules run in the order in which they appear within a group.

``` json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {},
    "variables": {},
    "resources": [
        {
           "name": "sampleRuleGroup",
           "type": "Microsoft.AlertsManagement/prometheusRuleGroups",
           "apiVersion": "2023-03-01",
           "location": "northcentralus",
           "properties": {
                "description": "Sample Prometheus Rule Group",
                "scopes": [
                    "/subscriptions/<subscription-id>/resourcegroups/<resource-group-name>/providers/microsoft.monitor/accounts/<azure-monitor-workspace-name>",
                    "/subscriptions/<subscription-id>/resourcegroups/<resource-group-name>/providers/microsoft.containerservice/managedclusters/<myClusterName>"
                ],
                "enabled": true,
                "clusterName": "<myCLusterName>",
                "interval": "PT1M",
                "rules": [
                    {
                        "record": "instance:node_cpu_utilisation:rate5m",
                        "expression": "1 - avg without (cpu) (sum without (mode)(rate(node_cpu_seconds_total{job=\"node\", mode=~\"idle|iowait|steal\"}[5m])))",
                        "labels": {
                            "workload_type": "job"
                        },
                        "enabled": true
                    },
                    {
                        "alert": "KubeCPUQuotaOvercommit",
                        "expression": "sum(min without(resource) (kube_resourcequota{job=\"kube-state-metrics\", type=\"hard\", resource=~\"(cpu|requests.cpu)\"})) /  sum(kube_node_status_allocatable{resource=\"cpu\", job=\"kube-state-metrics\"}) > 1.5",
                        "for": "PT5M",
                        "labels": {
                            "team": "prod"
                        },
                        "annotations": {
                            "description": "Cluster has overcommitted CPU resource requests for Namespaces.",
                            "runbook_url": "https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubecpuquotaovercommit",
                            "summary": "Cluster has overcommitted CPU resource requests."
                        },
                        "enabled": true,
                        "severity": 3,
                        "resolveConfiguration": {
                            "autoResolved": true,
                            "timeToResolve": "PT10M"
                        },
                        "actions": [
                            {
                               "actionGroupID": "/subscriptions/<subscription-id>/resourcegroups/<resource-group-name>/providers/microsoft.insights/actiongroups/<action-group-name>"
                            }
                        ]
                    }
                ]
            }
        }
    ]
}        
```

The rule group contains the following properties.

| Name | Required | Type | Description |
|:-----|:---------|:-----|:------------|
| `name` | True | string | Prometheus rule group name. |
| `type` | True | string | `Microsoft.AlertsManagement/prometheusRuleGroups` |
| `apiVersion` | True | string | `2023-03-01` |
| `location` | True | string | Resource location out of supported regions. |
| `properties.description` | False | string | Rule group description. |
| `properties.scopes` | True | string[] | Must include the target Azure Monitor workspace ID. Can optionally include one more cluster ID. |
| `properties.enabled` | False | Boolean | Enable/disable the group. Default is `true`. |
| `properties.clusterName` | False | string | Must match the `cluster` label that's added to metrics scraped from your target cluster. By default, set to the last part (resource name) of the cluster ID that appears in `scopes[]`. |
| `properties.interval` | False | string | Group evaluation interval. Default = `PT1M`. |

### Recording rules

The `rules` section contains the following properties for recording rules.

| Name | Required | Type | Description |
|:-----|:---------|:-----|:------------|
| `record` | True | string | Recording rule name. This name is used for the new time series. |
| `expression` | True | string | PromQL expression to calculate the new time series value. |
| `labels` | True | string | Prometheus rule labels key/value pairs. These labels are added to the recorded time series. |
| `enabled` | False | boolean | Enable/disable group. Default is `true`. |

### Alert rules

The `rules` section contains the following properties for alerting rules.

| Name | Required | Type | Description |
|:-----|:---------|:-----|:------------|
| `alert` | False | string | Alert rule name. |
| `expression` | True | string | PromQL expression to evaluate. |
| `for` | False | string | Alert firing timeout. Values = `PT1M`, `PT5M`, etc. |
| `labels` | False | object | Prometheus alert rule labels. These labels are added to alerts fired by this rule. |
| `rules.annotations` | False | object | Annotations key/value pairs to add to the alert. |
| `enabled` | False | Boolean | Enable/disable group. Default is `true`. |
| `rules.severity` | False | integer | Alert severity. 0-4, default is `3` (informational). |
| `rules.resolveConfigurations.autoResolved` | False | Boolean | When enabled, the alert is automatically resolved when the condition is no longer true. Default = `true`. |
| `rules.resolveConfigurations.timeToResolve` | False | string | Alert autoresolution timeout. Default = `PT5M`. |
| `rules.action[].actionGroupId` | false | string | One or more action group resource IDs. Each is activated when an alert is fired. |

---


## Convert Prometheus rules file to a Managed Prometheus rule group 

If you have a [Prometheus rules configuration file](https://prometheus.io/docs/prometheus/latest/configuration/recording_rules/#configuring-rules) in YAML format, you can convert it to an ARM template for an Azure Managed Prometheus rule group using the [az-prom-rules-converter utility](https://github.com/Azure/prometheus-collector/tree/main/tools/az-prom-rules-converter#az-prom-rules-converter). The rules file can contain the definition of one or more rule groups.

In addition to the rules file, the utility requires other properties needed to create the Azure Prometheus rule groups including subscription, resource group, location, target Azure Monitor workspace, target cluster ID and name, and action groups. The utility creates a template file that you can deploy using any standard methods for deploying ARM templates.



### Limit rules to a specific cluster

You can optionally limit the rules in a rule group to query data originating from a single specific cluster by adding a cluster scope to your rule group or by using the rule group `clusterName` property.
Limit rules to a single cluster if your Azure Monitor workspace contains a large amount of data from multiple clusters. In such a case, there's a concern that running a single set of rules on all the data might cause performance or throttling issues. By using the cluster scope, you can create multiple rule groups, each configured with the same rules, with each group covering a different cluster.

To limit your rule group to a cluster scope [by using an ARM template](#create-a-prometheus-rule-group-by-using-an-arm-template), add the Azure resource ID value of your cluster to the rule group `scopes[]` list. *The scopes list must still include the Azure Monitor workspace resource ID.* The following cluster resource types are supported as a cluster scope:

* Azure Kubernetes Service clusters (`Microsoft.ContainerService/managedClusters`)
* Azure Arc-enabled Kubernetes clusters (`Microsoft.kubernetes/connectedClusters`)
* Azure connected appliances (`Microsoft.ResourceConnector/appliances`)

In addition to the cluster ID, you can configure the `clusterName` property of your rule group. The `clusterName` property must match the `cluster` label that's added to your metrics when scraped from a specific cluster. By default, this label is set to the last part (resource name) of your cluster ID. If you changed this label by using the [cluster_alias](../containers/prometheus-metrics-scrape-configuration.md#cluster-alias) setting in your cluster scraping ConfigMap, you must include the updated value in the rule group `clusterName` property. If your scraping uses the default `cluster` label value, the `clusterName` property is optional.

Here's an example of how a rule group is configured to limit query to a specific cluster:

``` json
{
    "name": "sampleRuleGroup",
    "type": "Microsoft.AlertsManagement/prometheusRuleGroups",
    "apiVersion": "2023-03-01",
    "location": "northcentralus",
    "properties": {
         "description": "Sample Prometheus Rule Group limited to a specific cluster",
         "scopes": [
             "/subscriptions/<subscription-id>/resourcegroups/<resource-group-name>/providers/microsoft.monitor/accounts/<azure-monitor-workspace-name>",
             "/subscriptions/<subscription-id>/resourcegroups/<resource-group-name>/providers/microsoft.containerservice/managedclusters/<myClusterName>"
         ],
         "clusterName": "<myCLusterName>",
         "rules": [
             {
                ...
             }
         ]
    }
}        
```

If both the cluster ID scope and `clusterName` property aren't specified for a rule group, the rules in the group query data from all the clusters in the workspace from all clusters.





#### Configure the rule group details



:::image type="content" source="media/prometheus-metrics-rule-groups/create-new-rule-group-recording.png" alt-text="Screenshot that shows configuration of a Prometheus rule group recording rule.":::


:::image type="content" source="media/prometheus-metrics-rule-groups/create-new-rule-group-alert.png" alt-text="Screenshot that shows configuration of Prometheus rule group alert rule.":::

> [!NOTE]
> For alert rules, the expression query typically returns only time series that fulfill the expression condition. If the preview chart isn't shown and you get the message "The query returned no result," it's likely that the condition wasn't fulfilled in the preview time range.

#### Finish creating the rule group

1. On the **Tags** tab, set any required Azure resource tags to be added to the rule group resource.

    :::image type="content" source="media/prometheus-metrics-rule-groups/create-new-rule-group-tags.png" alt-text="Screenshot that shows the Tags tab when creating a new alert rule.":::

1. On the **Review + create** tab, the rule group is validated and lets you know about any issues. On this tab, you can also select the **View automation template** option and download the template for the group that you're about to create.

1. After validation passes and you review the settings, select **Create**.

    :::image type="content" source="media/prometheus-metrics-rule-groups/create-new-rule-group-review-create.png" alt-text="Screenshot that shows the Review + create tab when you create a new alert rule.":::

1. You can follow up on the rule group deployment to make sure that it finishes successfully or to be notified of any error.



## Disable and enable rule groups

To enable or disable a rule, select the rule group in the Azure portal. Select either **Enable** or **Disable** to change its status.

## Related content

* [Learn more about the Azure alerts](../alerts/alerts-types.md)
* [Prometheus documentation for recording rules](https://aka.ms/azureprometheus-promio-recrules)
* [Prometheus documentation for alerting rules](https://aka.ms/azureprometheus-promio-alertrules)
