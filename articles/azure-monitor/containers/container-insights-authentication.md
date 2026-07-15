---
title: Legacy authentication for Container Insights 
description: This article describes how to configure authentication for the containerized agent used by Container insights.
ms.topic: how-to
ms.custom: devx-track-azurecli
ms.date: 04/23/2025
ms.reviewer: aul
---

# Legacy authentication for Container Insights 

Container Insights defaults to managed identity authentication, which has a monitoring agent that uses the [cluster's managed identity](/azure/aks/use-managed-identity) to send data to Azure Monitor. It replaced the legacy certificate-based local authentication and removed the requirement of adding a Monitoring Metrics Publisher role to the cluster.

> [!IMPORTANT]
> Legacy authentication for Container Insights is retired. [Migrate to managed identity authentication](#migrate-to-managed-identity-authentication). After September 30, 2026, clusters still using legacy authentication aren't supported and no support will be provided for clusters using legacy authentication unless migrated to managed identity authentication.

This article describes how to migrate to managed identity authentication if you enabled Container insights using legacy authentication method, and also how to enable legacy authentication if you have that requirement.

> [!IMPORTANT]
> If you have a cluster with legacy authentication and Log Analytics workspace keys are rotated, then monitoring data will stop flowing to the Log Analytics workspace. You must disable and then reenable the Container insights addon to get monitoring data to start flowing again with the new rotated workspace keys.  You should migrate to Container insights managed identity authentication, which doesn't use Log Analytics workspace keys.

## Find clusters using Legacy authentication

The following queries list the clusters using legacy authentication in Container Insights. To run the queries, use the [Resource Graph Explorer](https://portal.azure.com/#view/HubsExtension/ArgQueryBlade). The query runs in the existing Azure portal scope. For more information on how to set scope and run Azure Resource Graph queries in the portal, see [Quickstart: Run Resource Graph query using Azure portal](/azure/governance/resource-graph/first-query-portal).

**Query for  AKS clusters**   

```AzureResourceGraph
resources        
| where type =~ 'Microsoft.ContainerService/managedClusters'       
| project id, name, aksproperties = parse_json(tolower(properties)), location, identity        
| extend isEnabled = aksproperties.addonprofiles.omsagent.enabled         
| extend workspaceResourceId = iif(isEnabled == true, aksproperties.addonprofiles.omsagent.config.loganalyticsworkspaceresourceid, '')        
| extend useAADAuth  = aksproperties.addonprofiles.omsagent.config.useaadauth  
| where isEnabled =~ "true" and useAADAuth != true 
| extend parts = split(tostring(id), "/")
| extend subscriptionId = parts[2], AKSClusterName = parts[-1], resourceGroupName = parts[4] 
| project AKSClusterName, resourceGroupName, subscriptionId, location, AKSClusterId = tolower(id), workspaceResourceId 

```
**Query for on-prem clusters i.e. clusters using Arc.**

```AzureResourceGraph
KubernetesConfigurationResources          
| where type =~ "Microsoft.KubernetesConfiguration/extensions"           
| extend properties = parse_json(tolower(properties))           
| extend extensionType = properties.extensiontype            
| where extensionType in~ ('microsoft.azuremonitor.containers')           
| extend omsagentUseAADAuth = tostring(properties.configurationsettings.["omsagent.useaadauth"])           
| extend amalogsUseAADAuth = tostring(properties.configurationsettings.["amalogs.useaadauth"])            
| extend useAADAuth = iff(omsagentUseAADAuth == 'true' or amalogsUseAADAuth == 'true', 'true', 'false')            
| extend workspaceResourceId = tostring(properties.configurationsettings.loganalyticsworkspaceresourceid)            
| extend resourceId = tolower(split(id, "/providers/Microsoft.KubernetesConfiguration")[0]) 
| where useAADAuth != "true"
| extend parts = split(tostring(resourceId), "/")
| extend subscriptionId = parts[2], ClusterName = parts[-1], ResourceGroupName = parts[4] 
| project ClusterName, ResourceGroupName,resourceId, subscriptionId, workspaceResourceId

```

## Migrate to managed identity authentication

If you enabled Container insights before managed identity authentication was available, you can use the following methods to migrate your clusters. Managed identity authentication is more secure, performant and gives you access to newer Azure Monitor Container Insights features, such as syslog collection and high scale logs mode.

## [Azure CLI](#tab/cli)

### AKS
AKS clusters must first disable monitoring and then upgrade to managed identity. Only Azure public cloud, Microsoft Azure operated by 21Vianet cloud, and Azure Government cloud are currently supported for this migration. For clusters with user-assigned identity, only Azure public cloud is supported.

> [!NOTE]
> Minimum Azure CLI version 2.49.0 or higher.

1. Get the configured Log Analytics workspace resource ID:

    ```cli
    az aks show -g <resource-group-name> -n <cluster-name> | grep -i "logAnalyticsWorkspaceResourceID"
    ```

2. Disable monitoring with the following command:

      ```cli
      az aks disable-addons -a monitoring -g <resource-group-name> -n <cluster-name> 
      ```

3. If the cluster is using a service principal, upgrade it to system managed identity with the following command:

      ```cli
      az aks update -g <resource-group-name> -n <cluster-name> --enable-managed-identity
      ```

4. Enable the monitoring add-on with the managed identity authentication option by using the Log Analytics workspace resource ID obtained in step 1:

      ```cli
      az aks enable-addons -a monitoring -g <resource-group-name> -n <cluster-name> --workspace-resource-id <workspace-resource-id>
      ```


### Arc-enabled Kubernetes

> [!NOTE]
> Arc-enabled Azure Red Hat OpenShift (ARO) clusters support managed identity authentication. Customers using Arc-enabled ARO clusters can migrate from legacy authentication to managed identity authentication.

1. Retrieve the Log Analytics workspace configured for Container insights extension.

    ```cli
    az k8s-extension show --name azuremonitor-containers --cluster-name \<cluster-name\> --resource-group \<resource-group\> --cluster-type connectedClusters -n azuremonitor-containers 
    ```

2. Enable Container insights extension with managed identity authentication option using the workspace returned in the first step. 

    ```cli
    az k8s-extension create --name azuremonitor-containers --cluster-name \<cluster-name\> --resource-group \<resource-group\> --cluster-type connectedClusters --extension-type Microsoft.AzureMonitor.Containers --configuration-settings amalogs.useAADAuth=true logAnalyticsWorkspaceResourceID=\<workspace-resource-id\> 
    ```


## [Shell script](#tab/script)

This shell script is the recommended migration method for bulk migration of multiple machines. Make sure your cluster network meets [our firewall requirements](/azure/azure-monitor/containers/kubernetes-monitoring-firewall) before running the script. 

[Download the script file](https://github.com/microsoft/Docker-Provider/blob/ci_prod/scripts/troubleshoot/cluster-migration/migrate-to-container-insights-msi.sh) directly from our GitHub repository. The first 30 lines of the script describe how to run it. 


---


### What happens when I migrate to managed identity authentication?

When you migrate to managed identity authentication, Container Insights changes how it authenticates with Azure Monitor. This migration doesn't change your applications, workloads, or Kubernetes resources beyond the Container Insights monitoring configuration.

**What stays the same**

- You keep your existing Log Analytics workspace and previously collected monitoring data.

- Container Insights keeps collecting and sending monitoring data after migration.

- Existing dashboards, workbooks, alerts, and queries that use Container Insights data keep working as long as data is collected successfully after migration.

- You don't need to change your application code or workloads.

**What changes**

- Container Insights stops using legacy authentication and starts using managed identity authentication.

- Your cluster monitoring configuration is updated to use the supported authentication model required for future Container Insights functionality and support.

**Migration impact**

During migration, data collection might be temporarily interrupted while the monitoring configuration is updated. After migration, verify that monitoring data is flowing to your workspace and that your expected monitoring experiences are functioning correctly.

**Recommended validation after migration**

After migrating, validate that:

- Container Insights reports health and telemetry successfully.

- New logs and metrics arrive in your Log Analytics workspace.

- Any custom monitoring configurations continue to function as expected.

- Existing alerts, dashboards, and operational workflows continue to receive data.


## Enable legacy authentication
If you require legacy authentication, see [Enable Container insights](kubernetes-monitoring-enable.md), which has examples of different options for enabling Container insights.


## Next steps
If you experience issues when you upgrade the agent, review the [troubleshooting guide](container-insights-troubleshoot.md) for support.


