---
title: Legacy authentication for Container Insights 
description: This article describes how to configure authentication for the containerized agent used by Container insights.
ms.topic: article
ms.custom: devx-track-azurecli
ms.date: 04/23/2025
ms.reviewer: aul
---

# Legacy authentication for Container Insights 

Container Insights defaults to managed identity authentication, which has a monitoring agent that uses the [cluster's managed identity](/azure/aks/use-managed-identity) to send data to Azure Monitor. It replaced the legacy certificate-based local authentication and removed the requirement of adding a Monitoring Metrics Publisher role to the cluster.

This article describes how to migrate to managed identity authentication if you enabled Container insights using legacy authentication method and also how to enable legacy authentication if you have that requirement.

> [!IMPORTANT]
> If you have a cluster with legacy authentication and Log Analytics workspace keys are rotated, then monitoring data will stop flowing to the Log Analytics workspace. You must disable and then reenable the Container insights addon to get monitoring data to start flowing again with the new rotated workspace keys.  You should migrate to Container insights managed identity authentication which doesn't use Log Analytics workspace keys.

## Find clusters using Legacy authentication

The following queries lists the clusters using legacy authentication in Container Insights. To run the queries, use the [Resource Graph Explorer](https://portal.azure.com/#view/HubsExtension/ArgQueryBlade). The query runs in the existing Azure portal scope. For more information on how to set scope and run Azure Resource Graph queries in the portal, see [Quickstart: Run Resource Graph query using Azure portal](/azure/governance/resource-graph/first-query-portal).

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

If you enabled Container insights before managed identity authentication was available, you can use the following methods to migrate your clusters.

## [Azure portal](#tab/portal-azure-monitor)

You can migrate to Managed Identity authentication from the *Monitor settings* panel for your AKS cluster. From the **Monitoring** section, click on the **Insights** tab. In the Insights tab, click on the *Monitor Settings* option and check the box for *Use managed identity*

:::image type="content" source="./media/container-insights-authentication/monitor-settings.png" alt-text="Screenshot that shows the settings panel." lightbox="media/container-insights-authentication/monitor-settings.png":::

If you don't see the *Use managed identity* option, you are using an SPN cluster. In that case, you must use command line tools to migrate. See other tabs for migration instructions and templates.



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

>[!NOTE]
> Managed identity authentication is not supported for Arc-enabled Kubernetes clusters with **ARO**.

1. Retrieve the Log Analytics workspace configured for Container insights extension.

    ```cli
    az k8s-extension show --name azuremonitor-containers --cluster-name \<cluster-name\> --resource-group \<resource-group\> --cluster-type connectedClusters -n azuremonitor-containers 
    ```

2. Enable Container insights extension with managed identity authentication option using the workspace returned in the first step. 

    ```cli
    az k8s-extension create --name azuremonitor-containers --cluster-name \<cluster-name\> --resource-group \<resource-group\> --cluster-type connectedClusters --extension-type Microsoft.AzureMonitor.Containers --configuration-settings amalogs.useAADAuth=true logAnalyticsWorkspaceResourceID=\<workspace-resource-id\> 
    ```


## [Shell script](#tab/script)

The shell script below is the recommeded migration method for bulk migration of multiple machines. Please make sure you meet the cluster network meets our [our firewall requirements](https://learn.microsoft.com/azure/azure-monitor/containers/kubernetes-monitoring-firewall) before running the script. 

You can also [download the script file](https://github.com/microsoft/Docker-Provider/blob/ci_prod/scripts/troubleshoot/cluster-migration/migrate-to-container-insights-msi.sh) directly from our Github repository. 

    ```shell
        #!/bin/bash
        #
        # Script to migrate container insights monitoring to managed identity authentication
        # For network and firewall endpoints setup, refer to following doc for detailed configuration:
        # https://learn.microsoft.com/en-us/azure/azure-monitor/containers/kubernetes-monitoring-firewall
        # High Level Steps:
        # 1. Prerequisites Check:
        #    - Validate Azure CLI and login status
        #    - Verify subscription access
        #    - Check cluster identity type
        #    - Verify container insights MSI status
        #    - Check cluster health
        #
        # 2. Cluster Discovery:
        #    - Scan specified subscriptions
        #    - Filter by cluster types (AKS/Arc)
        #    - List eligible clusters
        #
        # 3. Migration Process:
        #    - Get Log Analytics workspace ID
        #    - Disable monitoring addon
        #    - Re-enable with MSI auth
        #
        # Usage:
        #   ./migrate-to-container-insights-msi.sh -s <subscriptionIds> -c <clusterTypes>
        #
        # Example:
        #   ./migrate-to-container-insights-msi.sh -s "sub1,sub2" -c "aks,arc"
        #
        
        # Function to display usage
        usage() {
            echo "Usage: $0 -s <subscriptionIds> -c <clusterTypes>"
            echo "  -s : Comma-separated list of subscription IDs"
            echo "  -c : Comma-separated list of cluster types (aks,arc)"
            echo "Example:"
            echo "  $0 -s \"subId1,subId2\" -c \"aks,arc\""
            exit 1
        }
        
        # Function to check prerequisites for a cluster
        check_prerequisites() {
            local cluster_type=$1
            local resource_group=$2
            local name=$3
        
            if [ "$cluster_type" = "aks" ]; then
                # 1. Check AKS cluster health first
                local provisioning_state=$(az aks show -g "$resource_group" -n "$name" --query "provisioningState" -o tsv)
                if [ "$provisioning_state" != "Succeeded" ]; then
                    echo "Cluster not ready (current state: $provisioning_state)" >&2
                    return 1
                fi
        
                # 2. Check if cluster uses managed identity
                local identity_type=$(az aks show -g "$resource_group" -n "$name" --query "identity.type" -o tsv)
                if [ "$identity_type" != "SystemAssigned" ] && [ "$identity_type" != "UserAssigned" ]; then
                    echo "Current identity type: $identity_type (requires SystemAssigned or UserAssigned)" >&2
                    echo "To migrate to managed identity, visit: https://learn.microsoft.com/en-us/azure/aks/use-managed-identity" >&2
                    echo "Please migrate to managed identity and then rerun this script" >&2
                    return 1
                fi
        
                # 3. Check if monitoring is enabled
                # Case-insensitive check for monitoring status
                local monitoring_enabled=$(az aks show -g "$resource_group" -n "$name" --query "addonProfiles.omsagent.enabled || addonProfiles.omsAgent.enabled" -o tsv | tr '[:upper:]' '[:lower:]')
                if [ "$monitoring_enabled" != "true" ]; then
                    echo "Container insights not enabled on this cluster" >&2
                    return 1
                fi
        
                # 4. Check if monitoring is already using MSI
                local auth_mode=$(az aks show -g "$resource_group" -n "$name" --query "addonProfiles.omsagent.config.useAADAuth || addonProfiles.omsAgent.config.useAADAuth || addonProfiles.omsagent.config.useaadauth || addonProfiles.omsAgent.config.useaadauth || ''" -o tsv | tr '[:upper:]' '[:lower:]')
                if [ "$auth_mode" = "true" ]; then
                    echo "Monitoring already using MSI authentication" >&2
                    return 1
                fi
            
            elif [ "$cluster_type" = "arc" ]; then
                # 1. Check Arc cluster health first
                local cluster_state=$(az connectedk8s show -g "$resource_group" -n "$name" --query "provisioningState" -o tsv)
                if [ "$cluster_state" != "Succeeded" ]; then
                    echo "Arc cluster not ready (current state: $cluster_state)" >&2
                    return 1
                fi
        
                # 2. Check if cluster uses managed identity
                local identity_type=$(az connectedk8s show -g "$resource_group" -n "$name" --query "identity.type" -o tsv)
                if [ "$identity_type" != "SystemAssigned" ] && [ "$identity_type" != "UserAssigned" ]; then
                    echo "Current identity type: $identity_type (requires SystemAssigned or UserAssigned)" >&2
                    echo "Arc-enabled clusters require managed identity for monitoring. Current authentication method: Service Principal" >&2
                    echo "To use managed identity:" >&2
                    echo "1. Offboard monitoring" >&2
                    echo "2. Delete and re-register Arc connection using managed identity" >&2
                    echo "3. Re-onboard monitoring with the new identity" >&2
                    echo "Please migrate to managed identity and then rerun this script" >&2
                    return 1
                fi
        
                # 3. Check if extension exists and its state
                local extension_state=$(az k8s-extension show --name azuremonitor-containers \
                                      --cluster-name "$name" \
                                      --resource-group "$resource_group" \
                                      --cluster-type connectedClusters \
                                      --query "provisioningState" -o tsv 2>/dev/null)
                if [ -z "$extension_state" ]; then
                    echo "Container insights extension not installed" >&2
                    return 1
                fi
                if [ "$extension_state" != "Succeeded" ]; then
                    echo "Container insights extension not ready (current state: $extension_state)" >&2
                    return 1
                fi
        
                # 4. Check if already using MSI authentication
                local use_aad_auth=$(az k8s-extension show --name azuremonitor-containers \
                                    --cluster-name "$name" \
                                    --resource-group "$resource_group" \
                                    --cluster-type connectedClusters \
                                    --query "configurationSettings.\"amalogs.useAADAuth\"" -o tsv | tr '[:upper:]' '[:lower:]')
                if [ "$use_aad_auth" = "true" ]; then
                    echo "Monitoring already using MSI authentication" >&2
                    return 1
                fi
            fi
        
            return 0
        }
        
        # Function to get AMPLS ID for private cluster
        get_ampls_id() {
            local workspace_id=$1
            
            # Parse workspace details
            local workspace_name=$(echo "$workspace_id" | cut -d'/' -f9)
            local workspace_rg=$(echo "$workspace_id" | cut -d'/' -f5)
            
            # Get AMPLS ID
            az monitor log-analytics workspace show \
              --workspace-name "$workspace_name" \
              --resource-group "$workspace_rg" \
              --query "privateLinkScopedResources[0].resourceId" -o tsv | sed 's|/scopedresources/.*||'
        }
        
        # Function to discover clusters
        discover_clusters() {
            local subscription_id=$1
            local cluster_type=$2
            
            case $cluster_type in
                "aks")
                    az aks list --query "[].{name:name,resourceGroup:resourceGroup}" -o tsv
                    ;;
                "arc")
                    az connectedk8s list --query "[].{name:name,resourceGroup:resourceGroup}" -o tsv
                    ;;
                *)
                    echo "[Error] Invalid cluster type: $cluster_type (must be aks or arc)"
                    echo ""
                    ;;
            esac
        }
        
        # Function to perform migration
        perform_migration() {
            local cluster_type=$1
            local resource_group=$2
            local name=$3
            local workspace_id=$4
            local max_attempts=3
            local attempt=1
        
            # 1. Disable monitoring with retries
            echo "[$(date)] Disabling monitoring for $name"
            while [ $attempt -le $max_attempts ]; do
                if [ "$cluster_type" = "aks" ]; then
                    az aks disable-addons -a monitoring -g "$resource_group" -n "$name"
                    
                    # Wait for 3 minutes
                    echo "[$(date)] Waiting 3 minutes for disable operation to complete (attempt $attempt/$max_attempts)..."
                    sleep 180
        
                    # Check if monitoring is actually disabled
                    local monitoring_state=$(az aks show -g "$resource_group" -n "$name" --query "addonProfiles.omsagent.enabled || addonProfiles.omsAgent.enabled" -o tsv | tr '[:upper:]' '[:lower:]')
                    if [ "$monitoring_state" != "true" ]; then
                        echo "[$(date)] Successfully disabled monitoring"
                        break
                    else
                        echo "[$(date)] Monitoring is still enabled after attempt $attempt"
                        if [ $attempt -eq $max_attempts ]; then
                            echo "[Error] Failed to disable monitoring after $max_attempts attempts"
                            return 1
                        fi
                        attempt=$((attempt + 1))
                    fi
                else
                    az k8s-extension delete --name azuremonitor-containers -g "$resource_group" -c "$name" --cluster-type connectedClusters --yes && break
                    
                    if [ $attempt -eq $max_attempts ]; then
                        echo "[Error] Could not disable monitoring after $max_attempts attempts"
                        return 1
                    fi
                    attempt=$((attempt + 1))
                    echo "[$(date)] Retrying disable operation (attempt $attempt/$max_attempts)..."
                    sleep 180
                fi
            done
        
            # 2. Re-enable monitoring with MSI
            echo "[$(date)] Re-enabling monitoring with MSI for $name"
            if [ "$cluster_type" = "aks" ]; then
                # Check if private cluster
                local is_private=$(az aks show -g "$resource_group" -n "$name" \
                  --query "apiServerAccessProfile.enablePrivateCluster" -o tsv)
        
                if [ "$is_private" = "true" ]; then
                    echo "[$(date)] Private cluster detected, preserving AMPLS configuration"
                    # For private clusters, get AMPLS ID
                    local ampls_id=$(get_ampls_id "$workspace_id")
                    if [ -n "$ampls_id" ]; then
                        echo "[$(date)] Using AMPLS: $ampls_id"
                        az aks enable-addons -a monitoring -g "$resource_group" -n "$name" \
                          --workspace-resource-id "$workspace_id" \
                          --ampls-resource-id "$ampls_id" || {
                            echo "[Error] Could not enable monitoring with MSI and AMPLS"
                            return 1
                        }
                    else
                        echo "[Error] Could not get AMPLS ID for private cluster"
                        return 1
                    fi
                else
                    echo "[$(date)] Non-private cluster, proceeding without AMPLS"
                    # For non-private clusters, proceed without AMPLS
                    az aks enable-addons -a monitoring -g "$resource_group" -n "$name" \
                      --workspace-resource-id "$workspace_id" || {
                        echo "[Error] Could not enable monitoring with MSI"
                        return 1
                    }
                fi
                
                # Verify MSI auth is enabled
                local auth_mode=$(az aks show -g "$resource_group" -n "$name" --query "addonProfiles.omsagent.config.useAADAuth || addonProfiles.omsAgent.config.useAADAuth || addonProfiles.omsagent.config.useaadauth || addonProfiles.omsAgent.config.useaadauth || ''" -o tsv | tr '[:upper:]' '[:lower:]')
                [ "$auth_mode" = "true" ] || {
                    echo "[Error] MSI authentication not enabled after configuration"
                    return 1
                }
            else
                az k8s-extension create --name azuremonitor-containers \
                  -g "$resource_group" -c "$name" \
                  --cluster-type connectedClusters \
                  --extension-type Microsoft.AzureMonitor.Containers \
                  --configuration-settings logAnalyticsWorkspaceResourceID="$workspace_id" \
                  --configuration-settings useManagedIdentityForAuth="true" || {
                    echo "[Error] Could not configure monitoring with MSI"
                    return 1
                }
            fi
        
            return 0
        }
        
        # Parse command line arguments
        while getopts "s:c:h" opt; do
            case $opt in
                s) subscription_ids="$OPTARG" ;;
                c) cluster_types="$OPTARG" ;;
                h) usage ;;
                ?) usage ;;
            esac
        done
        
        # Validate required parameters
        if [ -z "$subscription_ids" ] || [ -z "$cluster_types" ]; then
            echo "[Error] Missing required parameters"
            usage
        fi
        
        # Arrays to track cluster status
        successful_clusters=()
        skipped_clusters=()
        failed_clusters=()
        
        echo "=== STEP 1: Prerequisites Check ==="
        # Check Azure CLI installation
        command -v az > /dev/null || {
            echo "[Error] Azure CLI not found. Please install Azure CLI"
            exit 1
        }
        
        # Check Azure CLI version
        az_version=$(az version --query \"azure-cli\" -o tsv)
        if [ "$(printf '%s\n' "2.49.0" "$az_version" | sort -V | head -n1)" != "2.49.0" ]; then
            echo "[Error] Azure CLI version must be 2.49.0 or higher (current version: $az_version)"
            exit 1
        fi
        
        # Check login status and verify subscriptions
        az account show > /dev/null || {
            echo "[Error] Azure login required. Run 'az login'"
            exit 1
        }
        
        # Verify all subscriptions exist and are accessible
        IFS=',' read -ra SUBS <<< "$subscription_ids"
        available_subs=$(az account list --query "[].id" -o tsv)
        
        for sub in "${SUBS[@]}"; do
            sub=$(echo "$sub" | xargs)
            echo "$available_subs" | grep -q "^$sub$" || {
                echo "[Error] Cannot access subscription: $sub"
                exit 1
            }
        done
        
        echo "=== STEP 2: Cluster Discovery ==="
        # Process each subscription
        IFS=',' read -ra SUBS <<< "$subscription_ids"
        for subscription_id in "${SUBS[@]}"; do
            subscription_id=$(echo "$subscription_id" | xargs)
            echo "[$(date)] Processing subscription: $subscription_id"
            
            # Set subscription
            az account set -s "$subscription_id" || {
                echo "[Error] Cannot access subscription: $subscription_id"
                continue
            }
        
            # Process each cluster type
            IFS=',' read -ra TYPES <<< "$cluster_types"
            for cluster_type in "${TYPES[@]}"; do
                cluster_type=$(echo "$cluster_type" | xargs | tr '[:upper:]' '[:lower:]')
                
                # Discover clusters
                clusters=$(discover_clusters "$subscription_id" "$cluster_type")
        
                echo "=== STEP 3: Migration Process ==="
                # Process each discovered cluster
                if [ -n "$clusters" ]; then
                    while IFS=$'\t' read -r name resource_group; do
                    [ -z "$name" ] && continue
                    
                    echo "[$(date)] Processing $cluster_type cluster: $name"
        
                    # Check prerequisites
                    prereq_result=$(check_prerequisites "$cluster_type" "$resource_group" "$name" 2>&1)
                    if [ $? -ne 0 ]; then
                        skipped_clusters+=("$name - Prerequisites failed: $prereq_result")
                        continue
                    fi
        
                    # Get workspace ID
                    echo "[$(date)] Getting workspace ID for $name"
                    if [ "$cluster_type" = "aks" ]; then
                        workspace_id=$(az aks show -g "$resource_group" -n "$name" --query "addonProfiles.omsagent.config.logAnalyticsWorkspaceResourceID || addonProfiles.omsAgent.config.logAnalyticsWorkspaceResourceID || addonProfiles.omsagent.config.loganalyticsworkspaceresourceid || addonProfiles.omsAgent.config.loganalyticsworkspaceresourceid" -o tsv)
                    else
                        workspace_id=$(az k8s-extension show --name azuremonitor-containers --resource-group "$resource_group" --cluster-name "$name"  --cluster-type connectedClusters --query "configurationSettings.logAnalyticsWorkspaceResourceID" -o tsv)
                    fi
        
                    if [ -z "$workspace_id" ] || [ "$workspace_id" = "null" ]; then
                        echo "[Skip] No workspace ID found for $name"
                        skipped_clusters+=("$name - No workspace ID configured")
                        continue
                    fi
        
                    # Perform migration
                    if perform_migration "$cluster_type" "$resource_group" "$name" "$workspace_id"; then
                        echo "[$(date)] Successfully migrated $name"
                        successful_clusters+=("$name")
                    else
                        echo "[$(date)] Failed to migrate $name"
                        failed_clusters+=("$name")
                    fi
                    done <<< "$clusters"
                fi
            done
        done
        
        # Print summary
        echo -e "\n[$(date)] Migration Summary:"
        
        echo -e "\nSuccessful clusters (${#successful_clusters[@]}):"
        for cluster in "${successful_clusters[@]}"; do
            echo "  ✓ $cluster"
        done
        
        echo -e "\nSkipped clusters (${#skipped_clusters[@]}):"
        for cluster in "${skipped_clusters[@]}"; do
            echo "  ⚠ $cluster"
        done
        
        echo -e "\nFailed clusters (${#failed_clusters[@]}):"
        for cluster in "${failed_clusters[@]}"; do
            echo "  ✗ $cluster"
        done 
        ```

---


## Enable legacy authentication
If you require legacy authentication, see [Enable Container insights](kubernetes-monitoring-enable.md#enable-container-insights) which has examples of different options for enabling Container insights.


## Next steps
If you experience issues when you upgrade the agent, review the [troubleshooting guide](container-insights-troubleshoot.md) for support.





