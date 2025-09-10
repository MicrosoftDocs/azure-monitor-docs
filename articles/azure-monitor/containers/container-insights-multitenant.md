---
title: Multitenant managed logging in Container insights
description: Concepts and onboarding steps for multitenant logging in Container insights.
ms.topic: article
ms.custom: references_regions
ms.date: 08/14/2025
ms.reviewer: viviandiec
---

# Multitenant managed logging in Container insights 

Multitenant logging in Container insights is useful for customers who operate shared cluster platforms using AKS. You may need the ability to configure container console log collection in a way that segregates logs by different teams so that each has access to the container logs of the containers running in K8s namespaces that they own and the ability to access the billing and management associated with the Azure Log analytics workspace. For example, container logs from infrastructure namespaces such as kube-system can be directed to a specific Log Analytics workspace for the infrastructure team, while each application team's container logs can be sent to their respective workspaces.

This article describes how multitenant logging works in Container insights, the scenarios it supports, and how to onboard your cluster to use this feature.

## Scenarios

The multitenant logging feature in Container insights supports the following scenarios:

* **Multitenancy.** Sends container logs (stdout & stderr) from one or more K8s namespaces to corresponding Log Analytics workspace.

    :::image type="content" source="media/container-insights-multitenant/multitenancy.png" lightbox="media/container-insights-multitenant/multitenancy.png" alt-text="Diagram that illustrates multitenancy for Container insights." border="false" :::

* **Multihoming:** Sends the same set of container logs (stdout & stderr) from one or more K8s namespaces to multiple Log Analytics workspaces.

    :::image type="content" source="media/container-insights-multitenant/multihoming.png" lightbox="media/container-insights-multitenant/multihoming.png" alt-text="Diagram that illustrates multihoming for Container insights." border="false" :::

## How it works

Container insights use a [data collection rule (DCR)](../data-collection/data-collection-rule-overview.md) to define the data collection settings for your AKS cluster. A default **ContainerInsights** Extension DCR is created automatically when you [enable Container insights](kubernetes-monitoring-enable.md#container-insights). This DCR is a singleton meaning there is one DCR per Kubernetes cluster.

For multitenant logging, Container Insights adds support for [ContainerLogV2Extension](https://github.com/microsoft/Docker-Provider/blob/ci_prod/scripts/onboarding/aks/multi-tenancy/existingClusterOnboarding.json) DCRs, which are used to define collection of container logs for K8s namespaces. Multiple [ContainerLogV2Extension](https://github.com/microsoft/Docker-Provider/blob/ci_prod/scripts/onboarding/aks/multi-tenancy/existingClusterOnboarding.json) DCRs can be created with different settings for different namespaces and all associated with the same AKS cluster. 

When you enable the multitenancy feature through a ConfigMap, the Container Insights agent periodically fetches both the default **ContainerInsights** extension DCR and the **ContainerLogV2Extension** DCRs associated with the AKS cluster. This fetch is performed every 5 minutes beginning when the container is started. If any additional **ContainerLogV2Extension** DCRs are added, they'll be recognized the next time the fetch is performed. All configured streams in the default DCR aside from container logs continue to be sent to the Log Analytics workspace in the default **ContainerInsights** DCR as usual.

The following logic is used to determine how to process each log entry:

* If there is a **ContainerLogV2Extension** DCR for the namespace of the log entry, that DCR is used to process the entry. This includes the Log Analytics workspace destination and any ingestion-time transformation.
* If there isn't a **ContainerLogV2Extension** DCR for the namespace of the log entry, the default **ContainerInsights** DCR is used to process the entry. You can disable the default DCR ingestion with the ConfigMap entry `disable_fallback_ingestion = false` under `[log_collection_settings.multi_tenancy]`.

## Limitations

* See [Limitations for high scale logs collection in Container Insights](container-insights-high-scale.md#limitations).
* A maximum of 30 **ContainerLogV2Extension** DCR associations are supported per cluster.

## Prerequisites 

* High log scale mode must be configured for the cluster using the guidance at [High scale logs collection in Container Insights](container-insights-high-scale.md).
* A [data collection endpoint (DCE)](../data-collection/data-collection-endpoint-overview.md) is created with the [DCR for each application or infrastructure team](#create-dcr-for-each-application-or-infrastructure-team). The **Logs Ingestion** endpoint of each DCE must be configured in the firewall as described in [Network firewall requirements for high scale logs collection in Container Insights](container-insights-high-scale.md#network-firewall-requirements).

## Enable multitenancy for the cluster

1. Follow the guidance in [Configure and deploy ConfigMap](container-insights-data-collection-configmap.md#configure-and-deploy-configmap) to download and update ConfigMap for the cluster. 

1.  Enable high scale mode by changing the `enabled` setting under `agent_settings.high_log_scale` as follows. 

    ```yaml
    agent-settings: |-
        [agent_settings.high_log_scale]
            enabled = true
    ```

1.  Enable multitenancy by changing the `enabled` setting under `log_collection_settings.multi_tenancy` as follows. 

    ```yaml
    log-data-collection-settings: |-
        [log_collection_settings]
           [log_collection_settings.multi_tenancy]
            enabled = true 
            disable_fallback_ingestion = false # If enabled, logs of the k8s namespaces for which ContainerLogV2Extension DCR is not configured will not be ingested to the default DCR.

1. Apply the ConfigMap to the cluster with the following commands.

    ```bash
    kubectl config set-context <cluster-name>
    kubectl apply -f <configmap_yaml_file.yaml>
    ```

### Create DCR for each application or infrastructure team

The following sections provide details on different methods to create a separate DCR for each application or infrastructure team. Each will include a set of K8s namespaces and a Log Analytics workspace destination.

> [!TIP]
> For multihoming, deploy a separate DCR template and parameter file for each Log Analytics workspace and include the same set of K8s namespaces. This will enable the same logs to be sent to multiple workspaces. For example, if you want to send logs for app-team-1, app-team-2 to both LAW1 and LAW2, 
>
> * Create DCR1 and include LAW1 for app-team-1 and app-team-2 namespaces
> * Create DCR2 and include LAW2 for app-team-1 and app-team-2 namespaces

Each of the methods below use the same parameters in the following table.

| Parameter Name | Description |
|:---------------|:------------|
| `aksResourceId` | Azure Resource ID of the AKS cluster |
| `aksResourceLocation` | Azure Region of the AKS cluster |
| `workspaceResourceId` | Azure Resource ID of the Log Analytics workspace |
| `workspaceRegion` | Azure Region of the Log Analytics workspace |
| `K8sNamespaces` | List of K8s namespaces for logs to be sent to the Log Analytics workspace defined in this parameter file. |
| `resourceTagValues` | Azure Resource Tags to use on AKS, data collection rule (DCR), and data collection endpoint (DCE). |
| `transformKql` | KQL filter for advance filtering using ingestion-time transformation. For example, to exclude the logs for a specific pod, use `source \| where PodName != '<podName>'`. See [Transformations in Azure Monitor](../data-collection/data-collection-transformations.md) for details. |
| `useAzureMonitorPrivateLinkScope` | Indicates whether to configure Azure Monitor Private Link Scope. |
| `azureMonitorPrivateLinkScopeResourceId` | Azure Resource ID of the Azure Monitor Private Link Scope. |

### [ARM](#tab/arm)

1. Retrieve one of the following ARM template and parameter file.

    **AKS Cluster**
    Template: [https://aka.ms/aks-enable-monitoring-multitenancy-onboarding-template-file](https://aka.ms/aks-enable-monitoring-multitenancy-onboarding-template-file)<br>
    Parameter: [https://aka.ms/aks-enable-monitoring-multitenancy-onboarding-template-parameter-file](https://aka.ms/aks-enable-monitoring-multitenancy-onboarding-template-parameter-file)

    **Arc-enabled Cluster**
    Template: [https://aka.ms/arc-enable-monitoring-multitenancy-template](https://aka.ms/arc-enable-monitoring-multitenancy-template)<br>
    Parameter: [https://aka.ms/arc-enable-monitoring-multitenancy-template](https://aka.ms/arc-enable-monitoring-multitenancy-template)

1. Edit the parameter file with values in the table above.
    
1. Deploy the template using the parameter file with the following command.

    ```azurecli
    az deployment group create --name AzureMonitorDeployment --resource-group <aksClusterResourceGroup> --template-file existingClusterOnboarding.json --parameters existingClusterParam.json
    ```

### [Bicep](#tab/bicep)

1. Retrieve the following ARM template and parameter file. 

    Template:  [https://aka.ms/aks-enable-monitoring-multitenancy-template-bicep](https://aka.ms/aks-enable-monitoring-multitenancy-template-bicep)
    Parameter:  [https://aka.ms/aks-enable-monitoring-multitenancy-template-parameter-bicep](https://aka.ms/aks-enable-monitoring-multitenancy-template-parameter-bicep)

1. Edit the parameter file with values in the table above.

3. Deploy the template using the parameter file with the following command. 

    ```azurecli
    az deployment group create --name AzureMonitorDeployment --resource-group <aksClusterResourceGroup> --template-file existingClusterOnboarding.bicep --parameters existingClusterParam.json 
    ```dotnetcli
    
### [Terraform](#tab/terraform)

1. Retrieve all the templates in [https://aka.ms/aks-enable-monitoring-multitenancy-templates-terraform ](https://aka.ms/aks-enable-monitoring-multitenancy-templates-terraform).

2. Modify the `terraform.tfvars` file with the configuration values in the table above. 

3. Initialize Terraform: 
   `terraform init`

4. Review the planned changes: 

    `terraform plan` 

5. Initialize Terraform: 

    `terraform apply`

---

## Disabling multitenant logging

> [!NOTE]
> See [Disable monitoring of your Kubernetes cluster](kubernetes-monitoring-disable.md) if you want to completely disable Container insights for the cluster.

Use the following steps to disable multitenant logging on a cluster.

1. Use the following command to list all the DCR associations for the cluster.
    
    ```azurecli
    az monitor data-collection rule association list-by-resource --resource /subscriptions/<subId>/resourcegroups/<rgName>/providers/Microsoft.ContainerService/managedClusters/<clusterName>
    ```

1. Use the following command to delete all DCR associations for ContainerLogV2 extension.
    
    ```azurecli
    az monitor data-collection rule association delete --association-name <ContainerLogV2ExtensionDCRA> --resource /subscriptions/<subId>/resourcegroups/<rgName>/providers/Microsoft.ContainerService/managedClusters/<clusterName>
    ```
    
1. Delete the ContainerLogV2Extension DCR.
    
    ```azurecli
    az monitor data-collection rule delete --name <ContainerLogV2Extension DCR> --resource-group <rgName>
    ``````

1. Edit `container-azm-ms-agentconfig` and change the value for `enabled` under `[log_collection_settings.multi_tenancy]` from `true` to `false`.

    ```bash
    kubectl edit cm container-azm-ms-agentconfig -n kube-system -o yaml
    ```

## Troubleshooting 

Perform the following steps to troubleshoot issues with multitenant logging in Container insights.

1.  Verify that [high scale logging](container-insights-high-scale.md) is enabled for the cluster.
  
    ```bash
      # get the list of ama-logs and these pods should be in Running state
      # If these are not in Running state, then this needs to be investigated
      kubectl get po -n kube-system | grep ama-logs
      # get the logs one of the ama-logs daemonset pod and check for log message indicating high scale enabled
      kubectl logs ama-logs-xxxxx -n kube-system -c ama-logs | grep high
      # output should be something like
       "Using config map value: enabled = true for high log scale config"
    ```

1. Verify that [ContainerLogV2 schema](container-insights-logs-schema.md) is enabled for the cluster.

    ```bash
      # get the list of ama-logs and these pods should be in Running state
      # If these are not in Running state, then this needs to be investigated
      kubectl get po -n kube-system | grep ama-logs
      # exec into any one of the ama-logs daemonset pod and check for the environment variables
      kubectl exec -it  ama-logs-xxxxx -n kube-system -c ama-logs -- bash
      # check if the containerlog v2 schema enabled or not
      env | grep AZMON_CONTAINER_LOG_SCHEMA_VERSION
      # output should be v2. If not v2, then check whether this is being enabled through DCR
      AZMON_CONTAINER_LOG_SCHEMA_VERSION=v2
      # check if its enabled through DCR
      grep -r "enableContainerLogV2" /etc/mdsd.d/config-cache/configchunks/
      # validate the enableContainerLogV2 configured with true or not from JSON output
    ```

1.  Verify that multitenancy is enabled for the cluster.
    
    ```bash
      # get the list of ama-logs and these pods should be in Running state
      # If these are not in Running state, then this needs to be investigated
      kubectl get po -n kube-system | grep ama-logs
      # get the logs one of the ama-logs daemonset pod and check for log message indicating high scale enabled
      kubectl logs ama-logs-xxxxx -n kube-system -c ama-logs | grep multi_tenancy
      # output should be something like
      "config::INFO: Using config map setting multi_tenancy enabled: true, advanced_mode_enabled: false and namespaces: [] for Multitenancy log collection"
    ```

1. Verify that the DCRs and DCEs related to **ContainerInsightsExtension** and **ContainerLogV2Extension** are created.
   
    ```bash
        az account set -s <clustersubscriptionId>
        az monitor data-collection rule association list-by-resource --resource "<clusterResourceId>"
        # output should list both ContainerInsightsExtension and ContainerLogV2Extension DCRs associated to the cluster
        # From the output, for each dataCollectionRuleId and check dataCollectionEndpoint associated or not
        az monitor data-collection rule show --ids <dataCollectionRuleId>
        # you can also check the extension settings for the K8s namespace configuration
   ```

1. Verify that the agent is downloading all the associated DCRs.
 
    ```bash
      # get the list of ama-logs and these pods should be in Running state
      # If these are not in Running state, then this needs to be investigated
      kubectl get po -n kube-system | grep ama-logs
      # exec into any one of the ama-logs daemonset pod and check for the environment variables
      kubectl exec -it  ama-logs-xxxxx -n kube-system -c ama-logs -- bash
      # check if its enabled through DCR
      grep -r "ContainerLogV2Extension" /etc/mdsd.d/config-cache/configchunks
      # output should list all the associated DCRs and configuration
      # if there are no DCRs downloaded then likely Agent has issues to pull associate DCRs and this could be missing network or firewall issue and check for errors in mdsd.err log file
      cat /var/opt/microsoft/linuxmonagent/log/mdsd.err
    ```

1. Check if there are any errors in fluent-bit-out-oms-runtime.log file

    ```bash
      # get the list of ama-logs and these pods should be in Running state
      # If these are not in Running state, then this needs to be investigated
      kubectl get po -n kube-system | grep ama-logs
      # exec into any one of the ama-logs daemonset pod and check for the environment variables
      kubectl exec -it ama-logs-xxxxx -n kube-system -c ama-logs -- bash
      # check for errors
      cat /var/opt/microsoft/docker-cimprov/log/fluent-bit-out-oms-runtime.log
    ```

## Next steps

* Read more about [Container insights](container-insights-overview.md).
