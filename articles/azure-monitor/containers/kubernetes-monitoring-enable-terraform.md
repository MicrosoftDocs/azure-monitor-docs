---
title: Enable monitoring for Kubernetes clusters using Terraform
description: Learn how to enable container logging and Managed Prometheus on an Azure Kubernetes Service (AKS) cluster using Terraform
ms.topic: how-tos
ms.custom: devx-track-azurecli, linux-related-content
ms.reviewer: aul
ms.date: 08/25/2025
---

# Enable monitoring for Kubernetes clusters using Terraform

As described in [Kubernetes monitoring in Azure Monitor](./container-insights-overview.md), multiple features of Azure Monitor work together to provide complete monitoring of your Azure Kubernetes Service (AKS) or Azure Arc-enabled Kubernetes clusters. This article describes how to enable the following features using CLI:

- Prometheus metrics
- Container logging
- Control plane logs

## Prerequisites

- Azure Monitor workspace and Log Analytics workspace must already exist.
- Users with the User Access Administrator role in the subscription of the AKS cluster can enable the Monitoring Reader role directly by deploying the template.

## Prometheus metrics

1. Download all files under [AddonTerraformTemplate](https://aka.ms/AAkm357).
2. Edit the variables in `variables.tf` file with the correct parameter values.
3. Run `terraform init -upgrade` to initialize the Terraform deployment.
4. Run `terraform plan -out main.tfplan` to initialize the Terraform deployment.
5. Run `terraform apply main.tfplan` to apply the execution plan to your cloud infrastructure.


Note: Pass the variables for `annotations_allowed` and `labels_allowed` keys in main.tf only when those values exist. These are optional blocks.

> [!NOTE]
> Edit the main.tf file appropriately before running the terraform template. Add in any existing azure_monitor_workspace_integrations values to the grafana resource before running the template. Else, older values get deleted and replaced with what is there in the template during deployment. Users with 'User Access Administrator' role in the subscription  of the AKS cluster can enable 'Monitoring Reader' role directly by deploying the template. Edit the grafanaSku parameter if you're using a nonstandard SKU and finally run this template in the Grafana Resource's resource group.

## Container logs

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


4.	Run `terraform init -upgrade` to initialize the Terraform deployment.
5.	Run `terraform plan -out main.tfplan` to initialize the Terraform deployment.
6.	Run `terraform apply main.tfplan` to apply the execution plan to your cloud infrastructure.


#### Existing AKS cluster
1.	Import the existing cluster resource with the command: ` terraform import azurerm_kubernetes_cluster.k8s <aksResourceId>`
2.	Add the oms_agent add-on profile to the existing `azurerm_kubernetes_cluster` resource.
    ```
    oms_agent {
        log_analytics_workspace_id = var.workspace_resource_id
        msi_auth_for_monitoring_enabled = true
      }
    ```
3.	Copy the DCR and DCRA resources from the Terraform templates.
4.	Run `terraform plan -out main.tfplan` and make sure the change is adding the `oms_agent` property. If the `azurerm_kubernetes_cluster` resource defined is different during terraform plan, the existing cluster will get destroyed and recreated.
5.	Run `terraform apply main.tfplan` to apply the execution plan to your cloud infrastructure.

> [!TIP]
> - Edit the `main.tf` file appropriately before running the terraform template
> - Data will start flowing after 10 minutes since the cluster needs to be ready first
> - WorkspaceID needs to match the format `/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/example-resource-group/providers/Microsoft.OperationalInsights/workspaces/workspaceValue`
> - If resource group already exists, run `terraform import azurerm_resource_group.rg /subscriptions/<Subscription_ID>/resourceGroups/<Resource_Group_Name>` before terraform plan


## Next steps

* If you experience issues while you attempt to onboard the solution, review the [Troubleshooting guide](container-insights-troubleshoot.md).
* With monitoring enabled to collect health and resource utilization of your AKS cluster and workloads running on them, learn [how to use](container-insights-analyze.md) Container insights.
