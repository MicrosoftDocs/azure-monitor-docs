---
title: Enable monitoring for AKS clusters
description: Learn how to enable Container insights and Managed Prometheus on an Azure Kubernetes Service (AKS) cluster.
ms.topic: how-to
ms.custom: devx-track-azurecli, linux-related-content
ms.reviewer: aul
ms.date: 08/25/2025
---

# Enable monitoring for AKS clusters

This article describes how to enable complete monitoring of your Kubernetes clusters using the following Azure Monitor features:

- [Managed Prometheus](../essentials/prometheus-metrics-overview.md) for metric collection
- [Container insights](./container-insights-overview.md) for log collection
- [Managed Grafana](/azure/managed-grafana/overview) for visualization
- Control plane logs


## Prerequisites

- You require at least [Contributor](/azure/role-based-access-control/built-in-roles#contributor) access to the cluster for onboarding.
- You require [Monitoring Reader](../roles-permissions-security.md#monitoring-reader) or [Monitoring Contributor](../roles-permissions-security.md#monitoring-contributor) to view data after monitoring is enabled.




## Workspaces

The following table describes the workspaces that are required to support Managed Prometheus and Container insights. You can create each workspace as part of the onboarding process or use an existing workspace. See [Design a Log Analytics workspace architecture](../logs/workspace-design.md) for guidance on how many workspaces to create and where they should be placed. 

| Feature | Workspace | Notes |
|:---|:---|:---|
| Managed Prometheus | [Azure Monitor workspace](../essentials/azure-monitor-workspace-overview.md) | `Contributor` permission is enough for enabling the addon to send data to the Azure Monitor workspace. You will need `Owner` level permission to link your Azure Monitor Workspace to view metrics in Azure Managed Grafana. This is required because the user executing the onboarding step, needs to be able to give the Azure Managed Grafana System Identity `Monitoring Reader` role on the Azure Monitor Workspace to query the metrics. |
| Container insights | [Log Analytics workspace](../logs/log-analytics-workspace-overview.md) | You can attach a cluster to a Log Analytics workspace in a different Azure subscription in the same Microsoft Entra tenant, but you must use the Azure CLI or an Azure Resource Manager template. You can't currently perform this configuration with the Azure portal.<br><br>If you're connecting an existing cluster to a Log Analytics workspace in another subscription, the *Microsoft.ContainerService* resource provider must be registered in the subscription with the Log Analytics workspace. For more information, see [Register resource provider](/azure/azure-resource-manager/management/resource-providers-and-types#register-resource-provider).<br><br>For a list of the supported mapping pairs to use for the default workspace, see [Region mappings supported by Container insights](container-insights-region-mapping.md). See [Configure Azure Monitor with Network Security Perimeter](../fundamentals/network-security-perimeter.md) for guidance on how to configure the workspace with network security perimeter. |
| Managed Grafana | [Azure Managed Grafana workspace](/azure/managed-grafana/quickstart-managed-grafana-portal#create-an-azure-managed-grafana-workspace) | [Link your Grafana workspace to your Azure Monitor workspace](/azure/managed-grafana/how-to-connect-azure-monitor-workspace) to make the Prometheus metrics collected from your cluster available to Grafana dashboards. |


## Enable Prometheus metrics
Use one of the following methods to enable scraping of Prometheus metrics from your cluster and enable Managed Grafana to visualize the metrics. See [Link a Grafana workspace](/azure/managed-grafana/quickstart-managed-grafana-portal) for options to connect your Azure Monitor workspace and Azure Managed Grafana workspace.


### Prerequisites

- The cluster must use [managed identity authentication](/azure/aks/use-managed-identity).
- The following resource providers must be registered in the subscription of the cluster and the Azure Monitor workspace:
    - Microsoft.ContainerService
    - Microsoft.Insights
    - Microsoft.AlertsManagement
    - Microsoft.Monitor
    - The following resource providers must be registered in the subscription of the Grafana workspace subscription:
        - Microsoft.Dashboard


> [!IMPORTANT]
> 
> - If you deploy using a template or Azure Policy, ensure that the Data Collection Endpoints, Data Collection Rules and the Data Collection Rule Associations are named `MSProm-<Location of Azure Monitor Workspace>-<Name of cluster resource>` or the onboarding process won't complete successfully.
> 
> - If you have a single Azure Monitor Resource that is [private-linked](../logs/private-link-configure.md#connect-resources-to-the-ampls), then Prometheus enablement won't work if the AKS cluster and Azure Monitor Workspace are in different regions. Create a new DCE and DCRA in the same cluster region. Associate the new DCE with the cluster and name the new DCRA as `configurationAccessEndpoint`. See [Enable private link for Kubernetes monitoring in Azure Monitor](./kubernetes-monitoring-private-link.md).

### [CLI](#tab/cli)

If you don't specify an existing Azure Monitor workspace in the following commands, the default workspace for the resource group will be used. If a default workspace doesn't already exist in the cluster's region, one with a name in the format `DefaultAzureMonitorWorkspace-<mapped_region>` will be created in a resource group with the name `DefaultRG-<cluster_region>`.

#### Prerequisites

- Az CLI version of 2.49.0 or higher is required. 
- The aks-preview extension must be [uninstalled from AKS clusters](/cli/azure/azure-cli-extensions-overview) by using the command `az extension remove --name aks-preview`. 
- The k8s-extension extension must be installed using the command `az extension add --name k8s-extension`.
- The k8s-extension version 1.4.1 or higher is required. 



Use the `-enable-azure-monitor-metrics` option `az aks create` or `az aks update` depending whether you're creating a new cluster or updating an existing cluster to install the metrics add-on that scrapes Prometheus metrics.

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

#### Optional parameters
Each of the commands above allow the following optional parameters. The parameter name is different for each, but their use is the same.

| Parameter | Name and Description |
|:---|:---|
| Annotation keys | `--ksm-metric-annotations-allow-list`<br><br>Comma-separated list of Kubernetes annotations keys used in the resource's `kube_resource_annotations` metric. For example, kube_pod_annotations is the annotations metric for the pods resource. By default, this metric contains only name and namespace labels. To include more annotations, provide a list of resource names in their plural form and Kubernetes annotation keys that you want to allow for them. A single `*` can be provided for each resource to allow any annotations, but this has severe performance implications. For example, `pods=[kubernetes.io/team,...],namespaces=[kubernetes.io/team],...`. |
| Label keys | `--ksm-metric-labels-allow-list`<br><br>Comma-separated list of more Kubernetes label keys that is used in the resource's kube_resource_labels metric kube_resource_labels metric. For example, kube_pod_labels is the labels metric for the pods resource. By default this metric contains only name and namespace labels. To include more labels, provide a list of resource names in their plural form and Kubernetes label keys that you want to allow for them A single `*` can be provided for each resource to allow any labels, but i this has severe performance implications. For example, `pods=[app],namespaces=[k8s-label-1,k8s-label-n,...],...`. |
| Recording rules | `--enable-windows-recording-rules`<br><br>Lets you enable the recording rule groups required for proper functioning of the Windows dashboards. |


### [Azure Resource Manager](#tab/arm)

### Enable with ARM templates

#### Prerequisites

- The Azure Monitor workspace and Azure Managed Grafana instance must already be created.
- The template must be deployed in the same resource group as the Azure Managed Grafana instance.
- If the Azure Managed Grafana instance is in a subscription other than the Azure Monitor workspace subscription, register the Azure Monitor workspace subscription with the `Microsoft.Dashboard` resource provider using the guidance at [Register resource provider](/azure/azure-resource-manager/management/resource-providers-and-types#register-resource-provider).
- Users with the `User Access Administrator` role in the subscription of the AKS cluster can enable the `Monitoring Reader` role directly by deploying the template.

> [!NOTE]
> Currently in Bicep, there's no way to explicitly scope the `Monitoring Reader` role assignment on a string parameter "resource ID" for an Azure Monitor workspace like in an ARM template. Bicep expects a value of type `resource | tenant`. There is also no REST API [spec](https://github.com/Azure/azure-rest-api-specs) for an Azure Monitor workspace.
> 
> Therefore, the default scoping for the `Monitoring Reader` role is on the resource group. The role is applied on the same Azure Monitor workspace by inheritance, which is the expected behavior. After you deploy this Bicep template, the Grafana instance is given `Monitoring Reader` permissions for all the Azure Monitor workspaces in that resource group.


#### Retrieve required values for Grafana resource
If the Azure Managed Grafana instance is already linked to an Azure Monitor workspace, then you must include this list in the template. On the **Overview** page for the Azure Managed Grafana instance in the Azure portal, select **JSON view**, and copy the value of `azureMonitorWorkspaceIntegrations` which will look similar to the sample below. If it doesn't exist, then the instance hasn't been linked with any Azure Monitor workspace.

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

1. Download the required files for the type of Kubernetes cluster you're working with.

    **AKS cluster ARM**

    - Template file: [https://aka.ms/azureprometheus-enable-arm-template](https://aka.ms/azureprometheus-enable-arm-template)
    - Parameter file: [https://aka.ms/azureprometheus-enable-arm-template-parameters](https://aka.ms/azureprometheus-enable-arm-template-parameters)

    **AKS cluster Bicep**

    - Template file: [https://aka.ms/azureprometheus-enable-bicep-template](https://aka.ms/azureprometheus-enable-bicep-template)
    - Parameter file: [https://aka.ms/azureprometheus-enable-bicep-template-parameters](https://aka.ms/azureprometheus-enable-arm-template-parameters)
    - DCRA module: [https://aka.ms/nested_azuremonitormetrics_dcra_clusterResourceId](https://aka.ms/nested_azuremonitormetrics_dcra_clusterResourceId)
    - Profile module: [https://aka.ms/nested_azuremonitormetrics_profile_clusterResourceId](https://aka.ms/nested_azuremonitormetrics_profile_clusterResourceId)
    - Azure Managed Grafana Role Assignment module: [https://aka.ms/nested_grafana_amw_role_assignment](https://aka.ms/nested_grafana_amw_role_assignment)




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

    **ARM**

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

4. Deploy the template with the parameter file by using any valid method for deploying Resource Manager templates. For examples of different methods, see [Deploy the sample templates](../resource-manager-samples.md#deploy-the-sample-templates).


### [Terraform](#tab/terraform)

### Enable with Terraform

#### Prerequisites

- The Azure Monitor workspace and Azure Managed Grafana workspace must already be created.
- The template needs to be deployed in the same resource group as the Azure Managed Grafana workspace.
- Users with the User Access Administrator role in the subscription of the AKS cluster can enable the Monitoring Reader role directly by deploying the template.
- If the Azure Managed Grafana instance is in a subscription other than the Azure Monitor Workspaces subscription, register the Azure Monitor Workspace subscription with the `Microsoft.Dashboard` resource provider by following [this documentation](/azure/azure-resource-manager/management/resource-providers-and-types#register-resource-provider).

#### Retrieve required values for a Grafana resource

On the **Overview** page for the Azure Managed Grafana instance in the Azure portal, select **JSON view**.

If you're using an existing Azure Managed Grafana instance that's already linked to an Azure Monitor workspace, you need the list of Grafana integrations. Copy the value of the `azureMonitorWorkspaceIntegrations` field. If it doesn't exist, the instance hasn't been linked with any Azure Monitor workspace. Update the `azure_monitor_workspace_integrations` block in `main.tf` with the list of grafana integrations.

```.tf
  azure_monitor_workspace_integrations {
    resource_id  = var.monitor_workspace_id[var.monitor_workspace_id1, var.monitor_workspace_id2]
  }
```

#### Download and edit the templates

If you're deploying a new AKS cluster using Terraform with managed Prometheus addon enabled, follow these steps:

1. Download all files under [AddonTerraformTemplate](https://aka.ms/AAkm357).
2. Edit the variables in variables.tf file with the correct parameter values.
3. Run `terraform init -upgrade` to initialize the Terraform deployment.
4. Run `terraform plan -out main.tfplan` to initialize the Terraform deployment.
5. Run `terraform apply main.tfplan` to apply the execution plan to your cloud infrastructure.


Note: Pass the variables for `annotations_allowed` and `labels_allowed` keys in main.tf only when those values exist. These are optional blocks.

> [!NOTE]
> Edit the main.tf file appropriately before running the terraform template. Add in any existing azure_monitor_workspace_integrations values to the grafana resource before running the template. Else, older values get deleted and replaced with what is there in the template during deployment. Users with 'User Access Administrator' role in the subscription  of the AKS cluster can enable 'Monitoring Reader' role directly by deploying the template. Edit the grafanaSku parameter if you're using a nonstandard SKU and finally run this template in the Grafana Resource's resource group.

### [Azure Policy](#tab/policy)

### Enable with Azure Policy

1. Download Azure Policy template and parameter files.

   - Template file: [https://aka.ms/AddonPolicyMetricsProfile](https://aka.ms/AddonPolicyMetricsProfile)
   - Parameter file: [https://aka.ms/AddonPolicyMetricsProfile.parameters](https://aka.ms/AddonPolicyMetricsProfile.parameters)

1. Create the policy definition using the following CLI command:

      `az policy definition create --name "Prometheus Metrics addon" --display-name "Prometheus Metrics addon" --mode Indexed --metadata version=1.0.0 category=Kubernetes --rules AddonPolicyMetricsProfile.rules.json --params AddonPolicyMetricsProfile.parameters.json`

1. After you create the policy definition, in the Azure portal, select **Policy** and then **Definitions**. Select the policy definition you created.
1. Select **Assign** and fill in the details on the **Parameters** tab. Select **Review + Create**.
1. If you want to apply the policy to an existing cluster, create a **Remediation task** for that cluster resource from **Policy Assignment**.

After the policy is assigned to the subscription, whenever you create a new cluster without Prometheus enabled, the policy will run and deploy to enable Prometheus monitoring.

### [Azure portal](#portal)

### New AKS cluster (Prometheus, Container insights, and Grafana)

When you create a new AKS cluster in the Azure portal, **Enable Container Logs**, **Enable Prometheus metrics**, **Enable Grafana**, and **Enable Recommended Alerts** checkboxes are checked by default in the Monitoring tab.

:::image type="content" source="media/prometheus-metrics-enable/aks-integrations.png" lightbox="media/prometheus-metrics-enable/aks-integrations.png" alt-text="Screenshot of Monitoring tab for new AKS cluster.":::

### Existing cluster (Prometheus, Container insights, and Grafana)

1. Navigate to your cluster in the Azure portal.
2. In the service menu, select **Monitor** > **Monitor Settings**.
3. Prometheus metrics, Grafana and Container Logs and events are selected for you. If you have existing Azure Monitor workspace, Grafana workspace and Log Analytics workspace, then they're selected for you.
4. Select **Advanced settings** if you want to select alternate workspaces or create new ones. The **Logging profiles and Classic profiles** setting allows you to modify the default collection details to reduce your monitoring costs. See [Enable cost optimization settings in Container insights](./container-insights-cost-config.md) for details.
5. Select **Configure**.


---



## Enable Container logging
Use one of the following methods to enable container logging for your cluster. 


> [!IMPORTANT] 
> Check the references below for configuration requirements for particular scenarios.
> 
> - If you have a single Azure Monitor Resource that is private-linked, you can't enable Container insights using the Azure portal. See [Enable private link for Kubernetes monitoring in Azure Monitor](./kubernetes-monitoring-private-link.md#container-insights-log-analytics-workspace).
>
> - To enable container logging with network security perimeter see [Configure Azure Monitor with Network Security Perimeter](../fundamentals/network-security-perimeter.md) to configure your Log Analytics workspace.
>
> - To enable high scale mode, follow the onboarding process at [Enable high scale mode for Monitoring add-on](./container-insights-high-scale.md#enable-high-scale-mode-for-monitoring-add-on). You must also ConfigMap as described in [Update ConfigMap](./container-insights-high-scale.md#update-configmap), and the DCR stream needs to be changed from `Microsoft-ContainerLogV2` to `Microsoft-ContainerLogV2-HighScale`.

### [CLI](#tab/cli)

Use one of the following commands to enable monitoring of your cluster. If you don't specify an existing Log Analytics workspace, the default workspace for the resource group will be used. If a default workspace doesn't already exist in the cluster's region, one will be created with a name in the format `DefaultWorkspace-<GUID>-<Region>`.

#### Prerequisites

- Azure CLI version 2.75.0 or higher
- Managed identity authentication is default in CLI version 2.49.0 or higher.
- Azure k8s-extension version 1.3.7 or higher
- Managed identity authentication is the default in k8s-extension version 1.43.0 or higher.
- For CLI version 2.74.0 or higher, the logging schema will be configured to [ContainerLogV2](container-insights-logs-schema.md) using [ConfigMap](container-insights-data-collection-configmap.md).

> [!NOTE]
> You can enable the **ContainerLogV2** schema for a cluster either using the cluster's Data Collection Rule (DCR) or ConfigMap. If both settings are enabled, the ConfigMap will take precedence. Stdout and stderr logs will only be ingested to the ContainerLog table when both the DCR and ConfigMap are explicitly set to off.

#### AKS cluster

```azurecli
### Use default Log Analytics workspace
az aks enable-addons --addon monitoring --name <cluster-name> --resource-group <cluster-resource-group-name>

### Use existing Log Analytics workspace
az aks enable-addons --addon monitoring --name <cluster-name> --resource-group <cluster-resource-group-name> --workspace-resource-id <workspace-resource-id>

### Use legacy authentication
az aks enable-addons --addon monitoring --name <cluster-name> --resource-group <cluster-resource-group-name> --workspace-resource-id <workspace-resource-id> --enable-msi-auth-for-monitoring false
```

**Example**

```azurecli
az aks enable-addons --addon monitoring --name "my-cluster" --resource-group "my-resource-group" --workspace-resource-id "/subscriptions/my-subscription/resourceGroups/my-resource-group/providers/Microsoft.OperationalInsights/workspaces/my-workspace"
```

### [Azure Resource Manager](#tab/arm)

Both ARM and Bicep templates are provided in this section.

#### Prerequisites
 
- The template must be deployed in the same resource group as the cluster.

#### Download and install template

1. Download and edit template and parameter file

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
    | `workspaceRegion` | Region of the Log Analytics workspace. |
    | `workspaceDomain` | Domain of the Log Analytics workspace.<br>`opinsights.azure.com` for Azure public cloud<br>`opinsights.azure.us` for AzureUSGovernment. |
    | `resourceTagValues` | Tag values specified for the existing Container insights extension data collection rule (DCR) of the cluster and the name of the DCR. The name will be `MSCI-<clusterName>-<clusterRegion>` and this resource created in an AKS clusters resource group. For first time onboarding, you can set arbitrary tag values. |
   | enableContainerLogV2 | Flag to indicate whether to use ContainerLogV2 or not. |
   | enableRetinaNetworkFlowLogs | Flag to indicate whether to enable Retina Network Flow Logs or not. |
   | enableSyslog | Flag to indicate to enable Syslog collection or not. |
   | syslogLevels  | Log levels for Syslog collection |
   | syslogFacilities | Facilities for Syslog collection |
   | dataCollectionInterval | Data collection interval for applicable inventory and perf data collection. Default is 1m |
   | namespaceFilteringModeForDataCollection | Data collection namespace filtering mode for applicable inventory and perf data collection. Default is off. |
   | namespacesForDataCollection | Namespaces for data collection for applicable for inventory and perf data collection. |
   | streams | Streams for data collection. For retina networkflow logs feature, include `Microsoft-RetinaNetworkFlowLogs`. For high scale mode, replace the stream `Microsoft-ContainerLogV2` with `Microsoft-ContainerLogV2-HighScale` in the template. |
   | useAzureMonitorPrivateLinkScope | Flag to indicate whether to configure Azure Monitor Private Link Scope or not. |
   | azureMonitorPrivateLinkScopeResourceId  |  Azure Resource ID of the Azure Monitor Private Link Scope. |


4. Deploy the template with the parameter file by using any valid method for deploying Resource Manager templates. For examples of different methods, see [Deploy the sample templates](../resource-manager-samples.md#deploy-the-sample-templates).



### [Terraform](#tab/terraform)

#### New AKS cluster

1.	Download Terraform template file depending on whether you want to enable Syslog collection.

    **Syslog**
    - [https://aka.ms/enable-monitoring-msi-syslog-terraform](https://aka.ms/enable-monitoring-msi-syslog-terraform)

    **No Syslog** 
    - [https://aka.ms/enable-monitoring-msi-terraform](https://aka.ms/enable-monitoring-msi-terraform)

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


#### Existing AKS cluster
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

### [Azure Policy](#tab/policy)

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

### [Azure portal](#tab/portal)

---


## Enable control plane logs
Control plane logs must be enabled separately from Prometheus metrics and container logging. You can send these logs to the same Log Analytics workspace as your container logs, but they aren't accessible from the **Monitor** menu for the cluster. Instead, you can access them using queries in [Log Analytics](../logs/log-analytics-overview.md) and use them for [log alerts](../alerts/alerts-log-query.md).

Control plane logs are implemented as [resource logs](../platform/resource-logs.md) in Azure Monitor. To collect these logs, create a [diagnostic setting](../platform/diagnostic-settings.md) for the cluster. 

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

### [Azure Resource Manager](#tab/arm)

### [Terraform](#tab/terraform)

### [Azure Policy](#tab/policy) 

### [Azure portal](*#portal)

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

## Differences between Windows and Linux clusters

The main differences in monitoring a Windows Server cluster compared to a Linux cluster include:

- Windows doesn't have a Memory RSS metric. As a result, it isn't available for Windows nodes and containers. The [Working Set](/windows/win32/memory/working-set) metric is available.
- Disk storage capacity information isn't available for Windows nodes.
- Only pod environments are monitored, not Docker environments.
- With the preview release, a maximum of 30 Windows Server containers are supported. This limitation doesn't apply to Linux containers.

>[!NOTE]
> Container insights support for the Windows Server 2022 operating system is in preview.


The containerized Linux agent (replicaset pod) makes API calls to all the Windows nodes on Kubelet secure port (10250) within the cluster to collect node and container performance-related metrics. Kubelet secure port (:10250) should be opened in the cluster's virtual network for both inbound and outbound for Windows node and container performance-related metrics collection to work.

If you have a Kubernetes cluster with Windows nodes, review and configure the network security group and network policies to make sure the Kubelet secure port (:10250) is open for both inbound and outbound in the cluster's virtual network.



## Next steps

* If you experience issues while you attempt to onboard the solution, review the [Troubleshooting guide](container-insights-troubleshoot.md).
* With monitoring enabled to collect health and resource utilization of your AKS cluster and workloads running on them, learn [how to use](container-insights-analyze.md) Container insights.



> [!IMPORTANT]
> Kubernetes clusters generate a lot of log data, which can result in significant costs if you aren't selective about the logs that you collect. Before you enable monitoring for your cluster, see the following articles to ensure that your environment is optimized for cost and that you limit your log collection to only the data that you require:
> 
>- [Configure data collection and cost optimization in Container insights using data collection rule](./container-insights-data-collection-dcr.md)<br>Details on customizing log collection once you've enabled monitoring, including using preset cost optimization configurations.
>- [Best practices for monitoring Kubernetes with Azure Monitor](../best-practices-containers.md)<br>Best practices for monitoring Kubernetes clusters organized by the five pillars of the [Azure Well-Architected Framework](/azure/architecture/framework/), including cost optimization.
>- [Cost optimization in Azure Monitor](../best-practices-cost.md)<br>Best practices for configuring all features of Azure Monitor to optimize your costs and limit the amount of data that you collect.
