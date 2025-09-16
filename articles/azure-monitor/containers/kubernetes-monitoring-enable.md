---
title: Enable monitoring for AKS clusters
description: Learn how to enable monitoring for Azure Kubernetes Service (AKS) cluster with Azure Monitor.
ms.topic: how-to
ms.custom: devx-track-azurecli, linux-related-content
ms.reviewer: aul
ms.date: 08/25/2025
---

# Enable monitoring for AKS clusters
As described in [Kubernetes monitoring in Azure Monitor](./kubernetes-monitoring-overview.md), multiple features of Azure Monitor work together to provide complete monitoring of your Azure Kubernetes Service (AKS) clusters. This article describes how to enable the following features for AKS clusters:

- Prometheus metrics
- Managed Grafana
- Container logging
- Control plane logs


## Prerequisites

- You require at least [Contributor](/azure/role-based-access-control/built-in-roles#contributor) access to the cluster for onboarding.
- You require [Monitoring Reader](../roles-permissions-security.md#monitoring-reader) or [Monitoring Contributor](../roles-permissions-security.md#monitoring-contributor) to view data after monitoring is enabled.




## Create workspaces

The following table describes the workspaces that are required to support the Azure Monitor features enabled in this article. If you don't already have an existing workspace of each type, you can create them as part of the onboarding process.  See [Design a Log Analytics workspace architecture](../logs/workspace-design.md) for guidance on how many workspaces to create and where they should be placed. 

| Feature | Workspace | Notes |
|:---|:---|:---|
| Managed Prometheus | [Azure Monitor workspace](../metrics/azure-monitor-workspace-overview.md) | If you don't specify an existing Azure Monitor workspace when onboarding, the default workspace for the resource group will be used. If a default workspace doesn't already exist in the cluster's region, one with a name in the format `DefaultAzureMonitorWorkspace-<mapped_region>` will be created in a resource group with the name `DefaultRG-<cluster_region>`.<br><br>`Contributor` permission is enough for enabling the addon to send data to the Azure Monitor workspace. You will need `Owner` level permission to link your Azure Monitor Workspace to view metrics in Azure Managed Grafana. This is required because the user executing the onboarding step, needs to be able to give the Azure Managed Grafana System Identity `Monitoring Reader` role on the Azure Monitor Workspace to query the metrics. |
| Container logging<br>Control plane logs | [Log Analytics workspace](../logs/log-analytics-workspace-overview.md) | You can attach a cluster to a Log Analytics workspace in a different Azure subscription in the same Microsoft Entra tenant, but you must use the Azure CLI or an Azure Resource Manager template. You can't currently perform this configuration with the Azure portal.<br><br>If you're connecting an existing cluster to a Log Analytics workspace in another subscription, the *Microsoft.ContainerService* resource provider must be registered in the subscription with the Log Analytics workspace. For more information, see [Register resource provider](/azure/azure-resource-manager/management/resource-providers-and-types#register-resource-provider).<br><br>If you don't specify an existing Log Analytics workspace, the default workspace for the resource group will be used. If a default workspace doesn't already exist in the cluster's region, one will be created with a name in the format `DefaultWorkspace-<GUID>-<Region>`.<br><br>For a list of the supported mapping pairs to use for the default workspace, see [Region mappings supported by Container insights](container-insights-region-mapping.md). See [Configure Azure Monitor with Network Security Perimeter](../fundamentals/network-security-perimeter.md) for guidance on how to configure the workspace with network security perimeter. |
| Managed Grafana | [Azure Managed Grafana workspace](/azure/managed-grafana/quickstart-managed-grafana-portal#create-an-azure-managed-grafana-workspace) | [Link your Grafana workspace to your Azure Monitor workspace](/azure/managed-grafana/how-to-connect-azure-monitor-workspace) to make the Prometheus metrics collected from your cluster available to Grafana dashboards. |


## Enable Prometheus metrics and container logging
When you enable Prometheus and container logging on a cluster, a containerized version of the [Azure Monitor agent](../agents/azure-monitor-agent-overview.md) is installed in the cluster. You can configure these features at the same time on a new or existing cluster, or enable each feature separately. 

Enable Managed Grafana for your cluster at the same time that you enable scraping of Prometheus metrics. See [Link a Grafana workspace](/azure/managed-grafana/quickstart-managed-grafana-portal) for options to connect your Azure Monitor workspace and Azure Managed Grafana workspace.


### Prerequisites

- The cluster must use [managed identity authentication](/azure/aks/use-managed-identity).
- The following resource providers must be registered in the subscription of the cluster and the Azure Monitor workspace:
    - Microsoft.ContainerService
    - Microsoft.Insights
    - Microsoft.AlertsManagement
    - Microsoft.Monitor
- The following resource providers must be registered in the subscription of the Grafana workspace subscription:
    - Microsoft.Dashboard



### [CLI](#tab/cli)

### Prerequisites

- Managed identity authentication is default in CLI version 2.49.0 or higher.
- The aks-preview extension must be [uninstalled from AKS clusters](/cli/azure/azure-cli-extensions-overview) by using the command `az extension remove --name aks-preview`. 


### Prometheus metrics

Use the `-enable-azure-monitor-metrics` option with [az aks create](/cli/azure/aks#az-aks-create) or [az aks update](/cli/azure/aks#az-aks-update) depending whether you're creating a new cluster or updating an existing cluster to install the metrics add-on that scrapes Prometheus metrics. This will use the configuration described in [Default Prometheus metrics configuration in Azure Monitor](./prometheus-metrics-scrape-default.md). To modify this configuration, see [Customize scraping of Prometheus metrics in Azure Monitor managed service for Prometheus](./prometheus-metrics-scrape-configuration.md).

See the following examples.

```azurecli
### Use default Azure Monitor workspace
az aks create/update --enable-azure-monitor-metrics --name <cluster-name> --resource-group <cluster-resource-group>

### Use existing Azure Monitor workspace
az aks create/update --enable-azure-monitor-metrics --name <cluster-name> --resource-group <cluster-resource-group> --azure-monitor-workspace-resource-id <workspace-name-resource-id>

### Use an existing Azure Monitor workspace and link with an existing Grafana workspace
az aks create/update --enable-azure-monitor-metrics --name <cluster-name> --resource-group <cluster-resource-group> --azure-monitor-workspace-resource-id <azure-monitor-workspace-name-resource-id> --grafana-resource-id  <grafana-workspace-name-resource-id>

### Use optional parameters
az aks create/update --enable-azure-monitor-metrics --name <cluster-name> --resource-group <cluster-resource-group> --ksm-metric-labels-allow-list "namespaces=[k8s-label-1,k8s-label-n]" --ksm-metric-annotations-allow-list "pods=[k8s-annotation-1,k8s-annotation-n]"
```

**Example**

```azurecli
az aks create/update --enable-azure-monitor-metrics --name "my-cluster" --resource-group "my-resource-group" --azure-monitor-workspace-resource-id "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-group/providers/microsoft.monitor/accounts/my-workspace"
```

#### Optional parameters
Each of the commands above allow the following optional parameters. The parameter name is different for each, but their use is the same.

| Parameter | Name and Description |
|:---|:---|
| Annotation keys | `--ksm-metric-annotations-allow-list`<br><br>Comma-separated list of Kubernetes annotations keys used in the resource's `kube_resource_annotations` metric. For example, kube_pod_annotations is the annotations metric for the pods resource. By default, this metric contains only name and namespace labels. To include more annotations, provide a list of resource names in their plural form and Kubernetes annotation keys that you want to allow for them. A single `*` can be provided for each resource to allow any annotations, but this has severe performance implications. For example, `pods=[kubernetes.io/team,...],namespaces=[kubernetes.io/team],...`. |
| Label keys | `--ksm-metric-labels-allow-list`<br><br>Comma-separated list of more Kubernetes label keys that is used in the resource's kube_resource_labels metric kube_resource_labels metric. For example, kube_pod_labels is the labels metric for the pods resource. By default this metric contains only name and namespace labels. To include more labels, provide a list of resource names in their plural form and Kubernetes label keys that you want to allow for them A single `*` can be provided for each resource to allow any labels, but i this has severe performance implications. For example, `pods=[app],namespaces=[k8s-label-1,k8s-label-n,...],...`. |
| Recording rules | `--enable-windows-recording-rules`<br><br>Lets you enable the recording rule groups required for proper functioning of the Windows dashboards. |

#### Container logs

Use the `--addon monitoring` option with [az aks create](/cli/azure/aks#az-aks-create) for a new cluster or [az aks enable-addon](/cli/azure/aks#az-aks-enable-addons) to update an existing cluster to enable collection of container logs. See below to modify the log collection settings.

See the following examples.

```azurecli
### Use default Log Analytics workspace
az aks enable-addons --addon monitoring --name <cluster-name> --resource-group <cluster-resource-group-name>

### Use existing Log Analytics workspace
az aks enable-addons --addon monitoring --name <cluster-name> --resource-group <cluster-resource-group-name> --workspace-resource-id <workspace-resource-id>

### Use custom log configuration file
az aks enable-addons --addon monitoring --name <cluster-name> --resource-group <cluster-resource-group-name> --workspace-resource-id <workspace-resource-id> --data-collection-settings dataCollectionSettings.json

### Use legacy authentication
az aks enable-addons --addon monitoring --name <cluster-name> --resource-group <cluster-resource-group-name> --workspace-resource-id <workspace-resource-id> --enable-msi-auth-for-monitoring false
```

**Example**

```azurecli
az aks enable-addons --addon monitoring --name "my-cluster" --resource-group "my-resource-group" --workspace-resource-id "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-group/providers/Microsoft.OperationalInsights/workspaces/my-workspace"
```

#### Log configuration file

To customize log collection settings for the cluster, you can provide the configuration as a JSON file using the following format. If you don't provide a configuration file, the default settings identified in the table below are used.

```json
{
  "interval": "1m",
  "namespaceFilteringMode": "Include",
  "namespaces": ["kube-system"],
  "enableContainerLogV2": true, 
  "streams": ["Microsoft-Perf", "Microsoft-ContainerLogV2"]
}
```

Each of the settings in the configuration is described in the following table.

| Name | Description |
|:---|:---|
| `interval` | Determines how often the agent collects data.  Valid values are 1m - 30m in 1m intervals If the value is outside the allowed range, then it defaults to *1 m*.<br><br>Default: 1m.  |
| `namespaceFilteringMode` | *Include*: Collects only data from the values in the *namespaces* field.<br>*Exclude*: Collects data from all namespaces except for the values in the *namespaces* field.<br>*Off*: Ignores any *namespace* selections and collect data on all namespaces.<br><br>Default: Off |
| `namespaces` | Array of comma separated Kubernetes namespaces to collect inventory and perf data based on the _namespaceFilteringMode_.<br>For example, *namespaces = ["kube-system", "default"]* with an _Include_ setting collects only these two namespaces. With an _Exclude_ setting, the agent collects data from all other namespaces except for _kube-system_ and _default_. With an _Off_ setting, the agent collects data from all namespaces including _kube-system_ and _default_. Invalid and unrecognized namespaces are ignored.<br><br>None. |
|  `enableContainerLogV2` | Boolean flag to enable ContainerLogV2 schema. If set to true, the stdout/stderr Logs are ingested to [ContainerLogV2](container-insights-logs-schema.md) table. If not, the container logs are ingested to **ContainerLog** table, unless otherwise specified in the ConfigMap. When specifying the individual streams, you must include the corresponding table for ContainerLog or ContainerLogV2.<br><br>Default: True |
| `streams` | An array of table streams. See [Stream values](#stream-values) for a list of the valid streams and their corresponding tables.<br><br>Default: ContainerLogV2, KubeEvents, KubePodInventory |



### [ARM](#tab/arm)

### Prerequisites

- The Azure Monitor workspace and Azure Managed Grafana instance must already be created.
- The template must be deployed in the same resource group as the Azure Managed Grafana instance.
- If the Azure Managed Grafana instance is in a subscription other than the Azure Monitor workspace subscription, register the Azure Monitor workspace subscription with the `Microsoft.Dashboard` resource provider using the guidance at [Register resource provider](/azure/azure-resource-manager/management/resource-providers-and-types#register-resource-provider).
- Users with the `User Access Administrator` role in the subscription of the AKS cluster can enable the `Monitoring Reader` role directly by deploying the template.

> [!NOTE]
> Currently in Bicep, there's no way to explicitly scope the `Monitoring Reader` role assignment on a string parameter "resource ID" for an Azure Monitor workspace like in an ARM template. Bicep expects a value of type `resource | tenant`. There is also no REST API [spec](https://github.com/Azure/azure-rest-api-specs) for an Azure Monitor workspace.
> 
> Therefore, the default scoping for the `Monitoring Reader` role is on the resource group. The role is applied on the same Azure Monitor workspace by inheritance, which is the expected behavior. After you deploy this Bicep template, the Grafana instance is given `Monitoring Reader` permissions for all the Azure Monitor workspaces in that resource group.

### Prometheus metrics

#### Retrieve required values for Grafana resource
If the Azure Managed Grafana instance is already linked to an Azure Monitor workspace, then you must include this list in the template or it will be overwritten. On the **Overview** page for the Azure Managed Grafana instance in the Azure portal, select **JSON view**, and copy the value of `azureMonitorWorkspaceIntegrations` which will look similar to the sample below. If it doesn't exist, then the instance hasn't been linked with any Azure Monitor workspace.

```json
"properties": {
    "grafanaIntegrations": {
        "azureMonitorWorkspaceIntegrations": [
            {
                "azureMonitorWorkspaceResourceId": "full_resource_id_1"
            },
            {
                "azureMonitorWorkspaceResourceId": "full_resource_id_2"
            }
        ]
    }
}
```

#### Download and edit template and parameter file

1. Download the required files.

    **Bicep**

    - Template file: [https://aka.ms/azureprometheus-enable-bicep-template](https://aka.ms/azureprometheus-enable-bicep-template)
    - Parameter file: [https://aka.ms/azureprometheus-enable-bicep-template-parameters](https://aka.ms/azureprometheus-enable-arm-template-parameters)
    - DCRA module: [https://aka.ms/nested_azuremonitormetrics_dcra_clusterResourceId](https://aka.ms/nested_azuremonitormetrics_dcra_clusterResourceId)
    - Profile module: [https://aka.ms/nested_azuremonitormetrics_profile_clusterResourceId](https://aka.ms/nested_azuremonitormetrics_profile_clusterResourceId)
    - Azure Managed Grafana Role Assignment module: [https://aka.ms/nested_grafana_amw_role_assignment](https://aka.ms/nested_grafana_amw_role_assignment)

    **JSON**

    - Template file: [https://aka.ms/azureprometheus-enable-arm-template](https://aka.ms/azureprometheus-enable-arm-template)
    - Parameter file: [https://aka.ms/azureprometheus-enable-arm-template-parameters](https://aka.ms/azureprometheus-enable-arm-template-parameters)



2. Edit the following values in the parameter file. The same set of values are used for both the ARM and Bicep templates. Retrieve the resource ID of the resources from the **JSON View** of their **Overview** page.


    | Parameter | Value |
    |:---|:---|
    | `azureMonitorWorkspaceResourceId` | Resource ID for the Azure Monitor workspace. Retrieve from the **JSON view** on the **Overview** page for the Azure Monitor workspace. |
    | `azureMonitorWorkspaceLocation` | Location of the Azure Monitor workspace. Retrieve from the **JSON view** on the **Overview** page for the Azure Monitor workspace. |
    | `clusterResourceId` | Resource ID for the AKS cluster. Retrieve from the **JSON view** on the **Overview** page for the cluster. |
    | `clusterLocation` | Location of the AKS cluster. Retrieve from the **JSON view** on the **Overview** page for the cluster. |
    | `metricLabelsAllowlist` | Comma-separated list of Kubernetes labels keys to be used in the resource's labels metric. |
    | `metricAnnotationsAllowList` | Comma-separated list of more Kubernetes label keys to be used in the resource's annotations metric. |
    | `grafanaResourceId` | Resource ID for the managed Grafana instance. Retrieve from the **JSON view** on the **Overview** page for the Grafana instance. |
    | `grafanaLocation`   | Location for the managed Grafana instance. Retrieve from the **JSON view** on the **Overview** page for the Grafana instance. |
    | `grafanaSku`        | SKU for the managed Grafana instance. Retrieve from the **JSON view** on the **Overview** page for the Grafana instance. Use the **sku.name**. |



3. Open the template file and update the `grafanaIntegrations` property at the end of the file with the values that you retrieved from the Grafana instance. This will look similar to the following samples. In these samples, `full_resource_id_1` and `full_resource_id_2` were already in the Azure Managed Grafana resource JSON. The final `azureMonitorWorkspaceResourceId` entry is already in the template and is used to link to the Azure Monitor workspace resource ID provided in the parameters file.

    **Bicep**

    ```bicep
        resource grafanaResourceId_8 'Microsoft.Dashboard/grafana@2022-08-01' = {
            name: split(grafanaResourceId, '/')[8]
            sku: {
                name: grafanaSku
            }
            identity: {
                type: 'SystemAssigned'
            }
            location: grafanaLocation
            properties: {
                grafanaIntegrations: {
                    azureMonitorWorkspaceIntegrations: [
                        {
                            azureMonitorWorkspaceResourceId: 'full_resource_id_1'
                        }
                        {
                            azureMonitorWorkspaceResourceId: 'full_resource_id_2'
                        }
                        {
                            azureMonitorWorkspaceResourceId: azureMonitorWorkspaceResourceId
                        }
                    ]
                }
            }
        }
    ```

    **JSON**

    ```json
    {
        "type": "Microsoft.Dashboard/grafana",
        "apiVersion": "2022-08-01",
        "name": "[split(parameters('grafanaResourceId'),'/')[8]]",
        "sku": {
            "name": "[parameters('grafanaSku')]"
        },
        "location": "[parameters('grafanaLocation')]",
        "properties": {
            "grafanaIntegrations": {
            "azureMonitorWorkspaceIntegrations": [
                {
                    "azureMonitorWorkspaceResourceId": "full_resource_id_1"
                },
                {
                    "azureMonitorWorkspaceResourceId": "full_resource_id_2"
                },
                {
                    "azureMonitorWorkspaceResourceId": "[parameters('azureMonitorWorkspaceResourceId')]"
                }
            ]
            }
        }
    }
    ```


4. Deploy the template with the parameter file by using any valid method for deploying Resource Manager templates. For examples of different methods, see [Deploy the sample templates](../resource-manager-samples.md#deploy-the-sample-templates).

### Container logs

#### Prerequisites
 
- The template must be deployed in the same resource group as the cluster.

#### Download and install template

1. Download and edit template and parameter file.

    **Bicep**
    - Template file (Syslog): [https://aka.ms/enable-monitoring-msi-syslog-bicep-template](https://aka.ms/enable-monitoring-msi-syslog-bicep-template)
    - Parameter file (Syslog): [https://aka.ms/enable-monitoring-msi-syslog-bicep-parameters](https://aka.ms/enable-monitoring-msi-syslog-bicep-parameters)
    - Template file (No Syslog): [https://aka.ms/enable-monitoring-msi-bicep-template](https://aka.ms/enable-monitoring-msi-bicep-template)
    - Parameter file (No Syslog): [https://aka.ms/enable-monitoring-msi-bicep-parameters](https://aka.ms/enable-monitoring-msi-bicep-parameters)
  
    **ARM**
   - Template file: [https://aka.ms/aks-enable-monitoring-msi-onboarding-template-file](https://aka.ms/aks-enable-monitoring-msi-onboarding-template-file)
   - Parameter file: [https://aka.ms/aks-enable-monitoring-msi-onboarding-template-parameter-file](https://aka.ms/aks-enable-monitoring-msi-onboarding-template-parameter-file)


2. Edit the following values in the parameter file. The same set of values are used for both the ARM and Bicep templates. Retrieve the resource ID of the resources from the **JSON View** of their **Overview** page.

    | Parameter | Description |
    |:---|:---|
    | `aksResourceId`  | Resource ID of the cluster. |
    | `aksResourceLocation` | Location of the cluster. |
    | `workspaceResourceId` | Resource ID of the Log Analytics workspace. |
    | `resourceTagValues` | Tag values specified for the existing Container insights extension data collection rule (DCR) of the cluster and the name of the DCR. The name will be `MSCI-<clusterName>-<clusterRegion>` and this resource created in an AKS clusters resource group. For first time onboarding, you can set arbitrary tag values. |
    | `enableRetinaNetworkFlowLogs` | Flag to indicate whether to enable Retina Network Flow Logs. |
    | `enableContainerLogV2` | Boolean flag to enable ContainerLogV2 schema. If set to true, the stdout/stderr Logs are sent to [ContainerLogV2](container-insights-logs-schema.md) table. If not, the container logs are sent to **ContainerLog** table, unless otherwise specified in the ConfigMap. When specifying the individual streams, you must include the corresponding table for ContainerLog or ContainerLogV2. |
    | `enableSyslog` | Specifies whether Syslog collection should be enabled. |
    | `syslogLevels` | If Syslog collection is enabled, specifies the log levels to collect. |
    | `dataCollectionInterval` | Determines how often the agent collects data.  Valid values are 1m - 30m in 1m intervals The default value is 1m. If the value is outside the allowed range, then it defaults to *1 m*. |
    | `namespaceFilteringModeForDataCollection` | *Include*: Collects only data from the values in the *namespaces* field.<br>*Exclude*: Collects data from all namespaces except for the values in the *namespaces* field.<br>*Off*: Ignores any *namespace* selections and collect data on all namespaces.
    | `namespacesForDataCollection` | Array of comma separated Kubernetes namespaces to collect inventory and perf data based on the _namespaceFilteringMode_.<br>For example, *namespaces = ["kube-system", "default"]* with an _Include_ setting collects only these two namespaces. With an _Exclude_ setting, the agent collects data from all other namespaces except for _kube-system_ and _default_. With an _Off_ setting, the agent collects data from all namespaces including _kube-system_ and _default_. Invalid and unrecognized namespaces are ignored. |
    | `streams` | An array of table streams. See [Stream values](#stream-values) for a list of the valid streams and their corresponding tables.<br><br>To enable [high scale mode](./container-insights-high-scale.md) for container logs, use `Microsoft-ContainerLogV2-HighScale`.  |
    | `useAzureMonitorPrivateLinkScope` | Specifies whether to use private link for the cluster connection to Azure Monitor. |
    | `azureMonitorPrivateLinkScopeResourceId` | If private link is used, resource ID of the private link scope.  |

3. Deploy the template with the parameter file by using any valid method for deploying Resource Manager templates. For examples of different methods, see [Deploy the sample templates](../resource-manager-samples.md#deploy-the-sample-templates).


### [Terraform](#tab/terraform)

#### Prerequisites

- The Azure Monitor workspace and Azure Managed Grafana workspace must already be created.
- The template needs to be deployed in the same resource group as the Azure Managed Grafana workspace.
- Users with the User Access Administrator role in the subscription of the AKS cluster can enable the Monitoring Reader role directly by deploying the template.
- If the Azure Managed Grafana instance is in a subscription other than the Azure Monitor Workspaces subscription, register the Azure Monitor Workspace subscription with the `Microsoft.Dashboard` resource provider by following [this documentation](/azure/azure-resource-manager/management/resource-providers-and-types#register-resource-provider).

#### Retrieve required values for Grafana resource
If the Azure Managed Grafana instance is already linked to an Azure Monitor workspace, then you must include this list in the template or it will be overwritten. On the **Overview** page for the Azure Managed Grafana instance in the Azure portal, select **JSON view**, and copy the value of `azureMonitorWorkspaceIntegrations` which will look similar to the sample below. If it doesn't exist, then the instance hasn't been linked with any Azure Monitor workspace.

```json
"properties": {
    "grafanaIntegrations": {
        "azureMonitorWorkspaceIntegrations": [
            {
                "azureMonitorWorkspaceResourceId": "full_resource_id_1"
            },
            {
                "azureMonitorWorkspaceResourceId": "full_resource_id_2"
            }
        ]
    }
}
```

Update the `azure_monitor_workspace_integrations` block in `main.tf` with the list of grafana integrations.

```.tf
  azure_monitor_workspace_integrations {
    resource_id  = var.monitor_workspace_id[var.monitor_workspace_id1, var.monitor_workspace_id2]
  }
```

#### Download and edit templates

**New AKS cluster**

1. Download all files under [AddonTerraformTemplate](https://aka.ms/AAkm357).
2. Edit the variables in variables.tf file with the correct parameter values.
3. Run `terraform init -upgrade` to initialize the Terraform deployment.
4. Run `terraform plan -out main.tfplan` to initialize the Terraform deployment.
5. Run `terraform apply main.tfplan` to apply the execution plan to your cloud infrastructure.


Note: Pass the variables for `annotations_allowed` and `labels_allowed` keys in main.tf only when those values exist. These are optional blocks.

> [!NOTE]
> Edit the main.tf file appropriately before running the terraform template. Add in any existing azure_monitor_workspace_integrations values to the grafana resource before running the template. Else, older values get deleted and replaced with what is there in the template during deployment. Users with 'User Access Administrator' role in the subscription  of the AKS cluster can enable 'Monitoring Reader' role directly by deploying the template. Edit the grafanaSku parameter if you're using a nonstandard SKU and finally run this template in the Grafana Resource's resource group.


#### Container logs

**New AKS cluster**

1.	Download Terraform template file depending on whether you want to enable Syslog collection.

    - Syslog: [https://aka.ms/enable-monitoring-msi-syslog-terraform](https://aka.ms/enable-monitoring-msi-syslog-terraform)
    - No Syslog: [https://aka.ms/enable-monitoring-msi-terraform](https://aka.ms/enable-monitoring-msi-terraform)

2.	Adjust the `azurerm_kubernetes_cluster` resource in *main.tf* based on your cluster settings.
3.	Update parameters in *variables.tf* to replace values in "<>"

    | Parameter | Description |
    |:---|:---|
    | `aks_resource_group_name` | Use the values on the AKS Overview page for the resource group. |
    | `resource_group_location` | Use the values on the AKS Overview page for the resource group. |
    | `cluster_name` | Define the cluster name that you would like to create. |
    | `workspace_resource_id` | Use the resource ID of your Log Analytics workspace. |
    | `workspace_region` | Use the location of your Log Analytics workspace. |
    | `resource_tag_values` | Match the existing tag values specified for the existing Container insights extension data collection rule (DCR) of the cluster and the name of the DCR. The name will match `MSCI-<clusterName>-<clusterRegion>` and this resource is created in the same resource group as the AKS clusters. For first time onboarding, you can set the arbitrary tag values. |
    | `enabledContainerLogV2` | Set this parameter value to be true to use the default recommended ContainerLogV2. |
    | Cost optimization parameters | Refer to [Data collection parameters](container-insights-cost-config.md#data-collection-parameters) |
    | `streams` | Streams for data collection. For retina networkflow logs feature, include `Microsoft-RetinaNetworkFlowLogs`. For high scale mode, replace the stream `Microsoft-ContainerLogV2` with `Microsoft-ContainerLogV2-HighScale` in the template.   |
    | `use_azure_monitor_private_link_scope`  | Flag to indicate whether to configure Azure Monitor Private Link Scope.  |
    | `azure_monitor_private_link_scope_resource_id` | Azure Resource ID of the Azure Monitor Private Link Scope. |
    


4.	Run `terraform init -upgrade` to initialize the Terraform deployment.
5.	Run `terraform plan -out main.tfplan` to initialize the Terraform deployment.
6.	Run `terraform apply main.tfplan` to apply the execution plan to your cloud infrastructure.


**Existing AKS cluster**
1.	Import the existing cluster resource first with the command: ` terraform import azurerm_kubernetes_cluster.k8s <aksResourceId>`
2.	Add the oms_agent add-on profile to the existing azurerm_kubernetes_cluster resource.
    ```
    oms_agent {
        log_analytics_workspace_id = var.workspace_resource_id
        msi_auth_for_monitoring_enabled = true
      }
    ```
3.	Copy the DCR and DCRA resources from the Terraform templates
4.	Run `terraform plan -out main.tfplan` and make sure the change is adding the oms_agent property. Note: If the `azurerm_kubernetes_cluster` resource defined is different during terraform plan, the existing cluster will get destroyed and recreated.
5.	Run `terraform apply main.tfplan` to apply the execution plan to your cloud infrastructure.

> [!TIP]
> - Edit the `main.tf` file appropriately before running the terraform template
> - Data will start flowing after 10 minutes since the cluster needs to be ready first
> - WorkspaceID needs to match the format `/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/example-resource-group/providers/Microsoft.OperationalInsights/workspaces/workspaceValue`
> - If resource group already exists, run `terraform import azurerm_resource_group.rg /subscriptions/<Subscription_ID>/resourceGroups/<Resource_Group_Name>` before terraform plan


### [Azure portal](#tab/portal)

You can enable Prometheus metrics and container logs when you create a new AKS cluster or on an existing cluster in the Azure portal. In both cases, the configuration experience is the same.

### New AKS cluster

When you create a new AKS cluster in the Azure portal, configure monitoring in the **Monitoring** tab.

:::image type="content" source="media/kubernetes-monitoring-enable-aks/new-cluster-monitoring-tab.png" lightbox="media/kubernetes-monitoring-enable-aks/new-cluster-monitoring-tab.png" alt-text="Screenshot of Monitoring tab for new AKS cluster.":::


### Existing cluster

Navigate to your cluster in the Azure portal. In the service menu, select **Monitor** and then **Monitor Settings**.

:::image type="content" source="media/kubernetes-monitoring-enable-aks/existing-cluster-monitoring-tab.png" lightbox="media/kubernetes-monitoring-enable-aks/existing-cluster-monitoring-tab.png" alt-text="Screenshot of Monitoring tab for existing AKS cluster.":::

### Configuration options
Configuration options are the same for both new and existing clusters. The only difference is you may need to select **Advanced settings** to view all options for an existing cluster.

:::image type="content" source="media/prometheus-metrics-enable/aks-integrations.png" lightbox="media/prometheus-metrics-enable/aks-integrations.png" alt-text="Screenshot of monitoring configuration for AKS cluster.":::


3. Prometheus metrics, Grafana and Container Logs and events are selected for you. If you have existing Azure Monitor workspace, Grafana workspace and Log Analytics workspace, then they're selected for you.
4. Select **Advanced settings** if you want to select alternate workspaces or create new ones. The **Logging profiles and Classic profiles** setting allows you to modify the default collection details to reduce your monitoring costs. See [Enable cost optimization settings in Container insights](./container-insights-cost-config.md) for details.
5. Select **Configure**.


For container logs, you must select a logging profile, which defines which logs will be collected and at what frequency. The available profiles are listed in the following table. 

:::image type="content" source="media/container-insights-cost-config/cost-settings-onboarding.png" alt-text="Screenshot that shows the onboarding options." lightbox="media/container-insights-cost-config/cost-settings-onboarding.png" :::

| Cost preset | Collection frequency | Namespace filters | Syslog collection | Collected data |
| --- | --- | --- | --- | --- |
| Logs and Events (Default) | 1 m | None | Not enabled | ContainerLogV2<br>KubeEvents<br>KubePodInventory |
| Syslog | 1 m | None | Enabled by default | All standard container insights tables |
| Standard | 1 m | None | Not enabled | All standard container insights tables |
| Cost-optimized | 5 m | Excludes kube-system, gatekeeper-system, azure-arc | Not enabled | All standard container insights tables |

If you want to customize the settings, click **Edit collection settings**. Each of these settings is described in the following table.

:::image type="content" source="media/container-insights-cost-config/advanced-collection-settings.png" alt-text="Screenshot that shows the collection settings options." lightbox="media/container-insights-cost-config/advanced-collection-settings.png" :::

| Name | Description |
|:---|:---|
| Collection frequency | Determines how often the agent collects data.  Valid values are 1m - 30m in 1m intervals The default value is 1m. This option can't be configured through the ConfigMap.|
| Namespace filtering | *Off*: Collects data on all namespaces.<br>*Include*: Collects only data from the values in the *namespaces* field.<br>*Exclude*: Collects data from all namespaces except for the values in the *namespaces* field.<br><br>Array of comma separated Kubernetes namespaces to collect inventory and perf data based on the _namespaceFilteringMode_. For example, *namespaces = ["kube-system", "default"]* with an _Include_ setting collects only these two namespaces. With an _Exclude_ setting, the agent collects data from all other namespaces except for _kube-system_ and _default_.  |
| Collected Data | Defines which Container insights tables to collect. See below for a description of each grouping.  |
| Enable ContainerLogV2 | Boolean flag to enable [ContainerLogV2 schema](./container-insights-logs-schema.md). If set to true, the stdout/stderr Logs are ingested to [ContainerLogV2](container-insights-logs-schema.md) table. If not, the container logs are ingested to **ContainerLog** table, unless otherwise specified in the ConfigMap. When specifying the individual streams, you must include the corresponding table for ContainerLog or ContainerLogV2. |
| Enable Syslog collection | Enables Syslog collection from the cluster. |


The **Collected data** option allows you to select the tables that are populated for the cluster. The tables are grouped by the most common scenarios. 

:::image type="content" source="media/container-insights-cost-config/collected-data-options.png" alt-text="Screenshot that shows the collected data options." lightbox="media/container-insights-cost-config/collected-data-options.png" :::

| Grouping | Tables | Notes |
| --- | --- | --- |
| All (Default) | All standard container insights tables | Required for enabling the default Container insights visualizations |
| Performance | Perf, InsightsMetrics | |
| Logs and events | ContainerLog or ContainerLogV2, KubeEvents, KubePodInventory | Recommended if you have enabled managed Prometheus metrics |
| Workloads, Deployments, and HPAs | InsightsMetrics, KubePodInventory, KubeEvents, ContainerInventory, ContainerNodeInventory, KubeNodeInventory, KubeServices | |
| Persistent Volumes | InsightsMetrics, KubePVInventory | |

### [Azure Policy](#tab/policy)

#### Prometheus metrics

1. Download Azure Policy template and parameter files.

   - Template file: [https://aka.ms/AddonPolicyMetricsProfile](https://aka.ms/AddonPolicyMetricsProfile)
   - Parameter file: [https://aka.ms/AddonPolicyMetricsProfile.parameters](https://aka.ms/AddonPolicyMetricsProfile.parameters)

2. Create the policy definition using the following CLI command:

      `az policy definition create --name "Prometheus Metrics addon" --display-name "Prometheus Metrics addon" --mode Indexed --metadata version=1.0.0 category=Kubernetes --rules AddonPolicyMetricsProfile.rules.json --params AddonPolicyMetricsProfile.parameters.json`

3. After you create the policy definition, in the Azure portal, select **Policy** and then **Definitions**. Select the policy definition you created.
4. Select **Assign** and fill in the details on the **Parameters** tab. Select **Review + Create**.
1. If you want to apply the policy to an existing cluster, create a **Remediation task** for that cluster resource from **Policy Assignment**.

After the policy is assigned to the subscription, whenever you create a new cluster without Prometheus enabled, the policy will run and deploy to enable Prometheus monitoring.

#### Azure portal

1. From the **Definitions** tab of the **Policy** menu in the Azure portal, create a policy definition with the following details.

    - **Definition location**: Azure subscription where the policy definition should be stored.
    - **Name**: AKS-Monitoring-Addon
    - **Description**: Azure custom policy to enable the Monitoring Add-on onto Azure Kubernetes clusters.
    - **Category**: Select **Use existing** and then *Kubernetes* from the dropdown list.
    - **Policy rule**: Replace the existing sample JSON with the contents of [https://aka.ms/aks-enable-monitoring-custom-policy](https://aka.ms/aks-enable-monitoring-custom-policy).

1. Select the new policy definition **AKS Monitoring Addon**.
1. Select **Assign** and specify a **Scope** of where the policy should be assigned.
1. Select **Next** and provide the resource ID of the Log Analytics workspace.
1. Create a remediation task if you want to apply the policy to existing AKS clusters in the selected scope.
1. Select **Review + create** to create the policy assignment.

#### Azure CLI

1. Download Azure Policy template and parameter files.

   - Template file: [https://aka.ms/enable-monitoring-msi-azure-policy-template](https://aka.ms/enable-monitoring-msi-azure-policy-template)
   - Parameter file: [https://aka.ms/enable-monitoring-msi-azure-policy-parameters](https://aka.ms/enable-monitoring-msi-azure-policy-parameters)


2. Create the policy definition using the following CLI command:

    ```azurecli
    az policy definition create --name "AKS-Monitoring-Addon-MSI" --display-name "AKS-Monitoring-Addon-MSI" --mode Indexed --metadata version=1.0.0 category=Kubernetes --rules azure-policy.rules.json --params azure-policy.parameters.json
    ```

3. Create the policy definition using the following CLI command:

    ```azurecli
    az policy assignment create --name aks-monitoring-addon --policy "AKS-Monitoring-Addon-MSI" --assign-identity --identity-scope /subscriptions/<subscriptionId> --role Contributor --scope /subscriptions/<subscriptionId> --location <location> -p "{ \"workspaceResourceId\": { \"value\": \"/subscriptions/<subscriptionId>/resourcegroups/<resourceGroupName>/providers/microsoft.operationalinsights/workspaces/<workspaceName>\" }, \"resourceTagValues\": { \"value\": {} }, \"workspaceRegion\": { \"value\": \"<location>\" }}"
    ```

After the policy is assigned to the subscription, whenever you create a new cluster without Container insights enabled, the policy will run and deploy to enable Container insights monitoring. 

---

### Stream values
When you specify the tables to collect using CLI or ARM, you specify a stream name that corresponds to a particular table in the Log Analytics workspace. The following table lists the stream name for each table.

> [!NOTE]
> If you're familiar with the [structure of a data collection rule](../essentials/data-collection-rule-structure.md), the stream names in this table are specified in the [Data flows](../essentials/data-collection-rule-structure.md#data-flows) section of the DCR.

| Stream | Container insights table |
| --- | --- |
| Microsoft-ContainerInventory | ContainerInventory |
| Microsoft-ContainerLog | ContainerLog |
| Microsoft-ContainerLogV2 | ContainerLogV2 |
| Microsoft-ContainerLogV2-HighScale | ContainerLogV2 (High scale mode)<sup>1</sup> |
| Microsoft-ContainerNodeInventory | ContainerNodeInventory |
| Microsoft-InsightsMetrics | InsightsMetrics |
| Microsoft-KubeEvents | KubeEvents |
| Microsoft-KubeMonAgentEvents | KubeMonAgentEvents |
| Microsoft-KubeNodeInventory | KubeNodeInventory |
| Microsoft-KubePodInventory | KubePodInventory |
| Microsoft-KubePVInventory | KubePVInventory |
| Microsoft-KubeServices | KubeServices |
| Microsoft-Perf | Perf |

<sup>1</sup> Don't use both Microsoft-ContainerLogV2 and Microsoft-ContainerLogV2-HighScale together. This will result in duplicate data.

### Applicable tables and metrics
The settings for **collection frequency** and **namespace filtering** don't apply to all log data. The following tables list the tables in the Log Analytics workspace along with the settings that apply to each. 

| Table name | Interval? | Namespaces? | Remarks |
|:---|:---:|:---:|:---|
| ContainerInventory | Yes | Yes | |
| ContainerNodeInventory | Yes | No | Data collection setting for namespaces isn't applicable since Kubernetes Node isn't a namespace scoped resource |
| KubeNodeInventory | Yes | No | Data collection setting for namespaces isn't applicable Kubernetes Node isn't a namespace scoped resource |
| KubePodInventory | Yes | Yes ||
| KubePVInventory | Yes | Yes | |
| KubeServices | Yes | Yes | |
| KubeEvents | No | Yes | Data collection setting for interval isn't applicable for the Kubernetes Events |
| Perf | Yes | Yes | Data collection setting for namespaces isn't applicable for the Kubernetes Node related metrics since the Kubernetes Node isn't a namespace scoped object. |
| InsightsMetrics| Yes | Yes | Data collection settings are only applicable for the metrics collecting the following namespaces: container.azm.ms/kubestate, container.azm.ms/pv and container.azm.ms/gpu |

> [!NOTE]
> Namespace filtering does not apply to ama-logs agent records. As a result, even if the kube-system namespace is listed among excluded namespaces, records associated to ama-logs agent container will still be ingested. 

| Metric namespace | Interval? | Namespaces? | Remarks |
|:---|:---:|:---:|:---|
| Insights.container/nodes| Yes | No | Node isn't a namespace scoped resource |
|Insights.container/pods | Yes | Yes| |
| Insights.container/containers | Yes | Yes | |
| Insights.container/persistentvolumes | Yes | Yes | |

### Special scenarios
Check the references below for configuration requirements for particular scenarios.
 
- If you're using private link, see [Enable private link for Kubernetes monitoring in Azure Monitor](./kubernetes-monitoring-private-link.md).
- To enable container logging with network security perimeter see [Configure Azure Monitor with Network Security Perimeter](../fundamentals/network-security-perimeter.md) to configure your Log Analytics workspace.
- To enable high scale mode, follow the onboarding process at [Enable high scale mode for Monitoring add-on](./container-insights-high-scale.md#enable-high-scale-mode-for-monitoring-add-on). You must also ConfigMap as described in [Update ConfigMap](./container-insights-high-scale.md#update-configmap), and the DCR stream needs to be changed from `Microsoft-ContainerLogV2` to `Microsoft-ContainerLogV2-HighScale`.


## Enable control plane logs
Control plane logs are implemented as [resource logs](../platform/resource-logs.md) in Azure Monitor. To collect these logs, create a [diagnostic setting](../platform/diagnostic-settings.md) for the cluster. Send them to the same Log Analytics workspace as your container logs.


### [CLI](#tab/cli)

Use the [az monitor diagnostic-settings create](/cli/azure/monitor/diagnostic-settings#az-monitor-diagnostic-settings-create) command to create a diagnostic setting with the [Azure CLI](/cli/azure/monitor). See the documentation for this command for descriptions of its parameters.

The following example creates a diagnostic setting that sends all Kubernetes categories to a Log Analytics workspace. This includes [resource-specific mode](../platform/resource-logs.md#resource-specific) to send the logs to specific tables listed in [Supported resource logs for Microsoft.ContainerService/fleets](/azure/aks/monitor-aks-reference#resource-logs).

```azurecli
az monitor diagnostic-settings create \
--name 'Collect control plane logs' \
--resource  /subscriptions/<subscription ID>/resourceGroups/<resource group name>/providers/Microsoft.ContainerService/managedClusters/<cluster-name> \
--workspace /subscriptions/<subscription ID>/resourcegroups/<resource group name>/providers/microsoft.operationalinsights/workspaces/<log analytics workspace name> \
--logs '[{"category": "karpenter-events","enabled": true},{"category": "kube-audit","enabled": true},
{"category": "kube-apiserver","enabled": true},{"category": "kube-audit-admin","enabled": true},{"category": "kube-controller-manager","enabled": true},{"category": "kube-scheduler","enabled": true},{"category": "cluster-autoscaler","enabled": true},{"category": "cloud-controller-manager","enabled": true},{"category": "guard","enabled": true},{"category": "csi-azuredisk-controller","enabled": true},{"category": "csi-azurefile-controller","enabled": true},{"category": "csi-snapshot-controller","enabled": true},{"category": "fleet-member-agent","enabled": true},{"category": "fleet-member-net-controller-manager","enabled": true},{"category": "fleet-mcs-controller-manager","enabled": true}]'
--metrics '[{"category": "AllMetrics","enabled": true}]' \
--export-to-resource-specific true
```

### [ARM](#tab/arm)
Following are sample template and parameter files to create a diagnostic setting for control plane logs. Modify the templates to collect different categories or to send the logs to a different destination.

**Bicep**

```bicep
param clusterName string
param workspaceId string
param settingName string

resource cluster 'Microsoft.ContainerService/managedClusters@2021-05-01-preview' existing = {
  name: clusterName
}

resource setting 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: settingName
  scope: cluster
  properties: {
    workspaceId: workspaceId
    logs: [
      {
        category: 'kube-apiserver'
        enabled: true
      }
      {
        category: 'kube-audit'
        enabled: true
      }
      {
        category: 'kube-audit-admin'
        enabled: true
      }
      {
        category: 'kube-controller-manager'
        enabled: true
      }
      {
        category: 'kube-scheduler'
              }
      {
        category: 'cluster-autoscaler'
        enabled: true
      }
      {
        category: 'guard'
        enabled: true
      }
    ]
  }
}
```


**JSON**

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "clusterName": {
            "type": "String"
        },
        "workspaceId": {
            "type": "String"
        },
        "settingName": {
            "type": "String"
        }
    },
    "resources": [
        {
            "type": "Microsoft.Insights/diagnosticSettings",
            "apiVersion": "2021-05-01-preview",
            "scope": "[format('Microsoft.ContainerService/managedClusters/{0}', parameters('clusterName'))]",
            "name": "[parameters('settingName')]",
            "properties": {
                "workspaceId": "[parameters('workspaceId')]",
                "logs": [
                    {
                        "category": "kube-apiserver",
                        "enabled": true
                    },
                    {
                        "category": "kube-audit",
                        "enabled": true
                    },
                    {
                        "category": "kube-audit-admin",
                        "enabled": true
                    },
                    {
                        "category": "kube-controller-manager",
                        "enabled": true
                    },
                    {
                        "category": "kube-scheduler",
                        "enabled": false
                    },
                    {
                        "category": "cluster-autoscaler",
                        "enabled": true
                    },
                    {
                        "category": "guard",
                        "enabled": true
                    }
                ]
            }
        }
    ]
}
```

**Parameter file**

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "settingName": {
        "value": "<cluster-name>"
    },
    "workspaceId": {
      "value": "/subscriptions/<subscription id>/resourcegroups/<resourcegroup name>/providers/microsoft.operationalinsights/workspaces/<workspace name>"
    },
    "scope": {
      "value": "Microsoft.<resource type>/<resourceName>"
    }
  }
}
```



### [Terraform](#tab/terraform)
Use the following template to create a diagnostic setting for control plane logs. Modify the template to collect different categories or to send the logs to a different destination.

```terraformprovider "azurerm" {
  features {}
}

variable "setting_name" {
  type        = string
  description = "Name for the diagnostic setting."
}

variable "workspace_id" {
  type        = string
  description = "Resource ID of the Log Analytics workspace."
}

variable "cluster_id" {
  type        = string
  description = "Resource ID of the AKS cluster to attach diagnostics to."
}

resource "azurerm_monitor_diagnostic_setting" "aks" {
  name                       = var.setting_name
  target_resource_id         = var.cluster_id
  log_analytics_workspace_id = var.workspace_id

  log {
    category = "kube-apiserver"
    enabled  = true
  }

  log {
    category = "kube-audit"
    enabled  = true
  }

  log {
    category = "kube-audit-admin"
    enabled  = true
  }

  log {
    category = "kube-controller-manager"
    enabled  = true
  }

  log {
    category = "kube-scheduler"
    enabled  = false
  }

  log {
    category = "cluster-autoscaler"
    enabled  = true
  }

  log {
    category = "guard"
    enabled  = true
  }
}
```


### [Azure portal](#tab/portal)
Select **Diagnostic settings** from the **Monitoring** section of the menu for the cluster. Then select **+ Add diagnostic setting**.

:::image type="content" source="media/kubernetes-monitoring-enable-portal/diagnostic-setting-new.png" alt-text="Screenshot that shows creation of a new diagnostic setting." lightbox="media/kubernetes-monitoring-enable-portal/diagnostic-setting-new.png" :::

Select **Send to Log Analytics workspace** and select the same workspace where you send your container logs. Then select the different **Categories** that you want to collect. Give the **Diagnostic setting name** a descriptive name such as *Collect Control Plane Logs*.

:::image type="content" source="media/kubernetes-monitoring-enable-portal/diagnostic-setting-details.png" alt-text="Screenshot that shows details of a new diagnostic setting." lightbox="media/kubernetes-monitoring-enable-portal/diagnostic-setting-details.png" :::

### Verify deployment
Within a few minutes after enabling monitoring, you should be able to use the following methods to verify that the monitoring features are enabled.

- The cluster should move from the **Unmonitored clusters** view to the **Monitored clusters** view in Container insights multi-cluster view.
- The **Monitor** view for the cluster should start to populate with data and no longer provide an option to enable monitoring. This includes the **Nodes**, **Workloads**, and **Containers** tabs.

### [Azure Policy](#tab/policy) 
See [Create diagnostic settings at scale using built-in Azure Policies](../platform/diagnostic-settings-policy.md) for details about using Azure Policy to create diagnostic settings at scale.


---




## Verify deployment
Use the [kubectl command line tool](/azure/aks/learn/quick-kubernetes-deploy-cli#connect-to-the-cluster) to verify that the agent is deployed properly.

### Managed Prometheus

**Verify that the DaemonSet was deployed properly on the Linux node pools**

```AzureCLI
kubectl get ds ama-metrics-node --namespace=kube-system
```

The number of pods should be equal to the number of Linux nodes on the cluster. The output should resemble the following example:

```output
User@aksuser:~$ kubectl get ds ama-metrics-node --namespace=kube-system
NAME               DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
ama-metrics-node   1         1         1       1            1           <none>          10h
```

**Verify that Windows nodes were deployed properly**

```AzureCLI
kubectl get ds ama-metrics-win-node --namespace=kube-system
```

The number of pods should be equal to the number of Windows nodes on the cluster. The output should resemble the following example:

```output
User@aksuser:~$ kubectl get ds ama-metrics-node --namespace=kube-system
NAME                   DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
ama-metrics-win-node   3         3         3       3            3           <none>          10h
```

**Verify that the two ReplicaSets were deployed for Prometheus**

```AzureCLI
kubectl get rs --namespace=kube-system
```

The output should resemble the following example:

```output
User@aksuser:~$kubectl get rs --namespace=kube-system
NAME                            DESIRED   CURRENT   READY   AGE
ama-metrics-5c974985b8          1         1         1       11h
ama-metrics-ksm-5fcf8dffcd      1         1         1       11h
```


### Container logging

**Verify that the DaemonSets were deployed properly on the Linux node pools**

```AzureCLI
kubectl get ds ama-logs --namespace=kube-system
```

The number of pods should be equal to the number of Linux nodes on the cluster. The output should resemble the following example:

```output
User@aksuser:~$ kubectl get ds ama-logs --namespace=kube-system
NAME       DESIRED   CURRENT   READY     UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
ama-logs   2         2         2         2            2           <none>          1d
```

**Verify that Windows nodes were deployed properly**

```
kubectl get ds ama-logs-windows --namespace=kube-system
```

The number of pods should be equal to the number of Windows nodes on the cluster. The output should resemble the following example:

```output
User@aksuser:~$ kubectl get ds ama-logs-windows --namespace=kube-system
NAME                   DESIRED   CURRENT   READY     UP-TO-DATE   AVAILABLE   NODE SELECTOR     AGE
ama-logs-windows           2         2         2         2            2       <none>            1d
```


**Verify deployment of the container logging solution**

```
kubectl get deployment ama-logs-rs --namespace=kube-system
```

The output should resemble the following example:

```output
User@aksuser:~$ kubectl get deployment ama-logs-rs --namespace=kube-system
NAME          READY   UP-TO-DATE   AVAILABLE   AGE
ama-logs-rs   1/1     1            1           24d
```

**View configuration with CLI**

Use the `aks show` command to find out whether the solution is enabled, the Log Analytics workspace resource ID, and summary information about the cluster.

```azurecli
az aks show --resource-group <resourceGroupofAKSCluster> --name <nameofAksCluster>
```

The command will return JSON-formatted information about the solution. The `addonProfiles` section should include information on the `omsagent` as in the following example:

```output
"addonProfiles": {
    "omsagent": {
        "config": {
            "logAnalyticsWorkspaceResourceID": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourcegroups/my-resource-group/providers/microsoft.operationalinsights/workspaces/my-workspace",
            "useAADAuth": "true"
        },
        "enabled": true,
        "identity": null
    },
}
```





## Next steps

* If you experience issues attempting to onboard, review the [Troubleshooting guide](container-insights-troubleshoot.md).
* Learn how to [Analyze Kubernetes monitoring data in the Azure portal](container-insights-analyze.md) Container insights.

