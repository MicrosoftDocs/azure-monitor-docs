---
title: Troubleshoot Container insights | Microsoft Docs
description: This article describes how you can troubleshoot and resolve issues with Container insights.
ms.topic: troubleshooting-general
ms.date: 01/29/2025
ms.reviewer: aul

---

# Troubleshoot Container insights

This article discusses some common issues and troubleshooting steps when using Container insights to monitor your Kubernetes cluster. 

## Duplicate alerts are being created
You might have enabled Prometheus alert rules without disabling Container insights recommended alerts. See [Migrate from Container insights recommended alerts to Prometheus recommended alert rules (preview)](container-insights-metric-alerts.md#migrate-from-metric-rules-to-prometheus-rules-preview).

## Cluster permissions

If you don't have required permissions to the cluster, you may see the error message, `You do not have the right cluster permissions which will restrict your access to Container Insights features. Please reach out to your cluster admin to get the right permission.`

Container Insights previously allowed users to access the Azure portal experience based on the access permission of the Log Analytics workspace. It now checks cluster-level permission to provide access to the Azure portal experience. You might need your cluster admin to assign this permission.

For basic read-only cluster level access, assign the **Monitoring Reader** role for the following types of clusters.

- AKS without Kubernetes role-based access control (RBAC) authorization enabled
- AKS enabled with Microsoft Entra SAML-based single sign-on
- AKS enabled with Kubernetes RBAC authorization
- AKS configured with the cluster role binding clusterMonitoringUser
- [Azure Arc-enabled Kubernetes clusters](/azure/azure-arc/kubernetes/overview)

See [Assign role permissions to a user or group](/azure/aks/control-kubeconfig-access#assign-role-permissions-to-a-user-or-group) for details on how to assign these roles for AKS and [Access and identity options for Azure Kubernetes Service (AKS)](/azure/aks/concepts-identity) to learn more about role assignments.


## Onboarding and update issues
The following sections describe issues you might encounter when you onboard or update Container insights on your cluster.

### Missing subscription registration

If you see the error `Missing Subscription registration`, register the resource provider **Microsoft.OperationsManagement** in the subscription of your Log Analytics workspace. See [Resolve errors for resource provider registration](/azure/azure-resource-manager/templates/error-register-resource-provider).

### Authorization error

When you enable Container insights or update a cluster, you might receive an error like `The client <user's identity> with object id <user's objectId> does not have authorization to perform action Microsoft.Authorization/roleAssignments/write over scope.`

During the onboarding or update process, an attempt is made to assign the **Monitoring Metrics Publisher** role to the cluster resource. The user initiating the process must have access to the **Microsoft.Authorization/roleAssignments/write** permission on the AKS cluster resource scope. Only members of the Owner and User Access Administrator built-in roles are granted access to this permission. If your security policies require you to assign granular-level permissions, see [Azure custom roles](/azure/role-based-access-control/custom-roles) and assign permission to the users who require it. Assign the **Publisher** role to the **Monitoring Metrics** with the Azure portal using the guidance at [Assign Azure roles by using the Azure portal](/azure/role-based-access-control/role-assignments-portal).

### Can't upgrade a cluster
If you can't upgrade Container insights on an AKS cluster after it's been installed, the Log Analytics workspace where the cluster was sending its data may have been deleted. [Disable monitoring](kubernetes-monitoring-disable.md) for the cluster and [enable Container insights](kubernetes-monitoring-enable.md) again using another workspace.

### Installation of Azure Monitor Containers extension fails
The error `manifests contain a resource that already exists` indicates that resources of the Container insights agent already exist on an Azure Arc-enabled Kubernetes cluster, which means that the Container insights agent is already installed. Solve this issue by cleaning up the existing resources of the Container insights agent and then enable the Azure Monitor Containers Extension.

##### AKS clusters
Run the following commands and look for the Azure Monitor Agent add-on profile to verify whether the AKS Monitoring Add-on is enabled:

```azurecli
az  account set -s <clusterSubscriptionId>
az aks show -g <clusterResourceGroup> -n <clusterName>
```
If the output includes an Azure Monitor Agent add-on profile config with a Log Analytics workspace resource ID, the AKS Monitoring Add-on is enabled and must be disabled with the following command.

```azurecli
az aks disable-addons -a monitoring -g <clusterResourceGroup> -n <clusterName>
```

##### Non-AKS clusters
Run the following command against the cluster to verify whether the `azmon-containers-release-1` Helm chart release exists.

```bash
helm list  -A
```

If the output indicates that the `azmon-containers-release-1` exists, delete the Helm chart release with the following command.

```bash
helm del azmon-containers-release-1
```


## Missing data
It may take up to 15 minutes for data to appear after you enable Container insights on a cluster. If you don't see data after 15 minutes, see the following sections for potential issues and solutions.

### Error message retrieving data 
The error message `Error retrieving data` might occur if the Log Analytics workspace where the cluster was sending its data has been deleted. If this is the case, [disable](kubernetes-monitoring-disable.md) monitoring for the cluster and [enable](kubernetes-monitoring-enable.md) Container insights again using another workspace. 

### Local authentication disabled
Check if the Log Analytics workspace is configured for local authentication with the following CLI command.<br><br> `az resource show  --ids "/subscriptions/[Your subscription ID]/resourcegroups/[Your resource group]/providers/microsoft.operationalinsights/workspaces/[Your workspace name]"`<br><br>If `disableLocalAuth = true`, then run the following command.<br><br>`az resource update --ids "/subscriptions/[Your subscription ID]/resourcegroups/[Your resource group]/providers/microsoft.operationalinsights/workspaces/[Your workspace name]" --api-version "2021-06-01" --set properties.features.disableLocalAuth=False` |

### Daily cap met
When the daily cap is limit is met for a Log Analytics workspace, it will stop collecting data until the reset time. See [Log Analytics Daily Cap](../logs/daily-cap.md).

### DCR not deployed with Terraform
If Container insights is enabled using Terraform and `msi_auth_for_monitoring_enabled` is set to `true`, ensure that DCR and DCRA resources are also deployed to enable log collection. See [Enable Container insights using Terraform](./kubernetes-monitoring-enable-terraform.md).

### Container insights not reporting any information
Use the following steps if you can't view status information or no results are returned from a log query.

1. Check the status of the agent with the following command:

    `kubectl get ds ama-logs --namespace=kube-system`

    The number of pods should be equal to the number of Linux nodes on the cluster. The output should resemble the following example, which indicates that it was deployed properly:

    ```
    User@aksuser:~$ kubectl get ds ama-logs --namespace=kube-system
    NAME       DESIRED   CURRENT   READY     UP-TO-DATE   AVAILABLE   NODE SELECTOR    AGE
    ama-logs   2         2         2         2            2           <none>           1d
    ```

1. If you have Windows Server nodes, check the status of the agent by running the following command:

    `kubectl get ds ama-logs-windows --namespace=kube-system`

    The number of pods should be equal to the number of Windows nodes on the cluster. The output should resemble the following example, which indicates that it was deployed properly:

    ```
    User@aksuser:~$ kubectl get ds ama-logs-windows --namespace=kube-system
    NAME                   DESIRED   CURRENT   READY     UP-TO-DATE   AVAILABLE   NODE SELECTOR    AGE
    ama-logs-windows           2         2         2         2            2           <none>       1d
    ```

1. Check the deployment status by using the following command:

    `kubectl get deployment ama-logs-rs --namespace=kube-system`

    The output should resemble the following example, which indicates that it was deployed properly:

    ```
    User@aksuser:~$ kubectl get deployment ama-logs-rs --namespace=kube-system
    NAME          READY   UP-TO-DATE   AVAILABLE   AGE
    ama-logs-rs   1/1     1            1           24d
    ```

1. Check the status of the pod to verify that it's running by using the command `kubectl get pods --namespace=kube-system`.

    The output should resemble the following example with a status of `Running` for ama-logs:

    ```
    User@aksuser:~$ kubectl get pods --namespace=kube-system
    NAME                                READY     STATUS    RESTARTS   AGE
    aks-ssh-139866255-5n7k5             1/1       Running   0          8d
    azure-vote-back-4149398501-7skz0    1/1       Running   0          22d
    azure-vote-front-3826909965-30n62   1/1       Running   0          22d
    ama-logs-484hw                      1/1       Running   0          1d
    ama-logs-fkq7g                      1/1       Running   0          1d
    ama-logs-windows-6drwq              1/1       Running   0          1d
    ```

1. If the pods are in a running state, but there is no data in Log Analytics or data appears to only send during a certain part of the day, it might be an indication that the daily cap has been met. When this limit is met each day, data stops ingesting into the Log Analytics Workspace and resets at the reset time. For more information, see [Log Analytics Daily Cap](../../azure-monitor/logs/daily-cap.md#determine-your-daily-cap).


### Metrics aren't being collected

1. Verify that the **Monitoring Metrics Publisher** role assignment exists by using the following CLI command:

    ``` azurecli
    az role assignment list --assignee "SP/UserassignedMSI for Azure Monitor Agent" --scope "/subscriptions/<subid>/resourcegroups/<RG>/providers/Microsoft.ContainerService/managedClusters/<clustername>" --role "Monitoring Metrics Publisher"
    ```
    For clusters with MSI, the user-assigned client ID for Azure Monitor Agent changes every time monitoring is enabled and disabled, so the role assignment should exist on the current MSI client ID.

1. For clusters with Microsoft Entra pod identity enabled and using MSI:

   - Verify that the required label **kubernetes.azure.com/managedby: aks** is present on the Azure Monitor Agent pods by using the following command:

        `kubectl get pods --show-labels -n kube-system | grep ama-logs`

    - Verify that exceptions are enabled when pod identity is enabled by using one of the supported methods at https://github.com/Azure/aad-pod-identity#1-deploy-aad-pod-identity.

        Run the following command to verify:

        `kubectl get AzurePodIdentityException -A -o yaml`

        You should receive output similar to the following example:

        ```
        apiVersion: "aadpodidentity.k8s.io/v1"
        kind: AzurePodIdentityException
        metadata:
        name: mic-exception
        namespace: default
        spec:
        podLabels:
        app: mic
        component: mic
        ---
        apiVersion: "aadpodidentity.k8s.io/v1"
        kind: AzurePodIdentityException
        metadata:
        name: aks-addon-exception
        namespace: kube-system
        spec:
        podLabels:
        kubernetes.azure.com/managedby: aks
        ```

### Performance charts don't show CPU or memory of nodes and containers on a non-Azure cluster

Container insights agent pods use the `cAdvisor` endpoint on the node agent to gather performance metrics. Verify the containerized agent on the node is configured to allow `cAdvisor secure port: 10250` or  `cAdvisor unsecure port: 10255` to be opened on all nodes in the cluster to collect performance metrics. See [prerequisites for hybrid Kubernetes clusters](./container-insights-hybrid-setup.md#prerequisites).

### Image and Name values not populated in the ContainerLog table

For agent version `ciprod12042019` and later, these two properties aren't populated by default for every log line to minimize cost incurred on log data collected. You can either enable collection of these properties or modify your queries to include these properties from other tables.

Modify your queries to include `Image` and `ImageTag` properties from the `ContainerInventory` table by joining on `ContainerID` property. You can include the `Name` property (as it previously appeared in the `ContainerLog` table) from the `KubepodInventory` table's `ContainerName` field by joining on the `ContainerID` property. 
          
The following sample query shows how to get use joins to retrieve these values.

```
//Set the time window for the query
let startTime = ago(1h);
let endTime = now();
//
//Get the latest Image & ImageTag for every containerID
let ContainerInv = ContainerInventory | where TimeGenerated >= startTime and TimeGenerated < endTime | summarize arg_max(TimeGenerated, *)  by ContainerID, Image, ImageTag | project-away TimeGenerated | project ContainerID1=ContainerID, Image1=Image ,ImageTag1=ImageTag;
//
//Get the latest Name for every containerID
let KubePodInv  = KubePodInventory | where ContainerID != "" | where TimeGenerated >= startTime | where TimeGenerated < endTime | summarize arg_max(TimeGenerated, *)  by ContainerID2 = ContainerID, Name1=ContainerName | project ContainerID2 , Name1;
//
//Join the above to get a jointed table that has name, image & imagetag. Outer left is used in case there are no kubepod records or if they're latent
let ContainerData = ContainerInv | join kind=leftouter (KubePodInv) on $left.ContainerID1 == $right.ContainerID2;
//
//Join ContainerLog table with the jointed table above, project-away redundant fields/columns, and rename columns that were rewritten. Outer left is used so logs aren't lost even if no container metadata for loglines is found.
ContainerLog
| where TimeGenerated >= startTime and TimeGenerated < endTime
| join kind= leftouter (
  ContainerData
) on $left.ContainerID == $right.ContainerID2 | project-away ContainerID1, ContainerID2, Name, Image, ImageTag | project-rename Name = Name1, Image=Image1, ImageTag=ImageTag1
```

> [!WARNING]
> Enabling the properties isn't recommended for large clusters that have more than 50 nodes. It generates API server calls from every node in the cluster and also increases data size for every log line collected.

To enable collection of these fields so you don't have to modify your queries, enable the setting `log_collection_settings.enrich_container_logs` in the agent config map as described in the [data collection configuration settings](./container-insights-data-collection-configmap.md).

### Logs not being collected on Azure Local cluster
If you registered your cluster and/or configured Insights for Azure Local before November 2023, features that use the Azure Monitor agent on Azure Local, such as Arc for Servers Insights, VM Insights, Container Insights, Defender for Cloud, or Microsoft Sentinel might not be collecting logs and event data properly. See [Repair AMA agent for Azure Local](/azure/azure-local/manage/monitor-hci-single?tabs=22h2-and-later#repair-ama-for-azure-stack-hci) for steps to reconfigure the agent and Insights for Azure Local.

### Missing data on large clusters
If data is missing from any of the following tables, the likely issue is related to parsing of the large payloads because of a large number of pods or nodes. This is known issue in the ruby plugin to parse the large JSON payload  because of the default PODS_CHUNK_SIZE, which is 1000.

There are plans to adjust the default PODS_CHUNK_SIZE value to smaller value to address this issue.

- KubePodInventory
- KubeNodeInventory
- KubeEvents
- KubePVInventory
- KubeServices 

1. Verify whether you've configured smaller `PODS_CHUNK_SIZE` value on your cluster using the following commands.
   
    ```bash
    # verify if kube context being set for right cluster
    kubectl cluster-info
    
    # check if the configmap configured with smaller PODS_CHUNK_SIZE chunksize already
    kubectl logs <ama-logs-rs pod name> -n kube-system -c ama-logs | grep PODS_CHUNK_SIZE

    # If it's configured, the output will be similar to "Using config map value: PODS_CHUNK_SIZE = 10"
    ```
2. If the cluster is already configured for a smaller `PODS_CHUNK_SIZE` value, then you need to enable the cluster for large cluster.

3. If the cluster is using the default `PODS_CHUNK_SIZE=1000`, then check if the cluster has a large number of pods or nodes.

    ```bash
    # check the total number of PODS
    kubectl get pods -A -o wide | wc -l

    # check the total number of NODES
    kubectl get nodes -o wide | wc -l
    ```

4. After confirming the number of pods and nodes is reasonably high, and the cluster is using the default `PODS_CHUNK_SIZE=1000` then use the following commands to configure the configmap.

    ```bash
    # Check if the cluster has container-azm-ms-agentconfig configmap in kube-system namespace
    kubectl get cm -n kube-system | grep container-azm-ms-agentconfig
    
    # If there is no existing container-azm-ms-agentconfig configmap, then configmap needs to be downloaded  and applied
    curl -L https://raw.githubusercontent.com/microsoft/Docker-Provider/refs/heads/ci_prod/kubernetes/container-azm-ms-agentconfig.yaml -o container-azm-ms-agentconfig
    kubectl apply -f container-azm-ms-agentconfig
    
    # Edit the configmap and uncomment agent_settings.chunk_config and PODS_CHUNK_SIZE lines under agent-settings: |- in the configmap
    kubectl edit cm -n kube-system  container-azm-ms-agentconfig -o yaml
    ```
    
## Agent OOM killed

### Daemonset container getting OOM killed

1. Start by identifying which container is getting OOM killed using the following commands. This will identify `ama-logs`, `ama-logs-prometheus`, or both.

    ```bash
    # verify if kube context being set for right cluster
    kubectl cluster-info

    # get the ama-logs pods and status
    kubectl get pods -n kube-system -o custom-columns=NAME:.metadata.name | grep -E ama-logs-[a-z0-9]{5}

    # from the result of above command, find out which ama-logs pod instance getting OOM killed
    kubectl describe pod <ama-logs-pod> -n kube-system

    # review the output of the above command to findout which ama-logs container is getting OOM killed
    ```

2. Check if there are network errors in `mdsd.err` log file using the following commands.
  
    ```bash
    mkdir log
    # for ama-logs-prometheus container use -c ama-logs-prometheus instead of -c ama-logs
    kubectl cp -c ama-logs kube-system/<ama-logs pod name>:/var/opt/microsoft/linuxmonagent/log log
    cd log
    cat mdsd.err
    ```

3. If errors are because of the outbound endpoint is blocked, see [Network firewall requirements for monitoring Kubernetes cluster](./kubernetes-monitoring-firewall.md) for endpoint requirements.

4. If errors are because of missing Data collection endpoint (DCE) or Data Collection rule (DCR), then reenable Container insights using the guidance at [Enable monitoring for Kubernetes clusters](./kubernetes-monitoring-enable.md).

5. If there are no errors, then this may be related to log scale. See [High scale logs collection in Container Insights (Preview)](./container-insights-high-scale.md).


### Replicaset container getting OOM killed

1. Identify how frequently `ama-logs-rs` pod getting OOM killed with the following commands.

    ```bash
    # verify if kube context being set for right cluster
    kubectl cluster-info

    # get the ama-logs pods and status
    kubectl get pods -n kube-system -o wide | grep ama-logs-rs

    # from the result of above command, find out which ama-logs pod instance getting OOM killed
    kubectl describe pod <ama-logs-rs-pod> -n kube-system

    # review the output of the above command to confirm the OOM kill
    ```

2. If ama-logs-rs getting OOM killed, then check if there are network errors with the following commands.

    ```bash
     mkdir log
     kubectl cp -c ama-logs kube-system/<ama-logs-rs pod name>:/var/opt/microsoft/linuxmonagent/log log
     cd log
     cat mdsd.err
    ```

3. If errors are because of the outbound endpoint is blocked, see [Network firewall requirements for monitoring Kubernetes cluster](./kubernetes-monitoring-firewall.md) for endpoint requirements.

4. If errors are because of missing Data collection endpoint (DCE) or Data Collection rule (DCR), then reenable Container insights using the guidance at [Enable monitoring for Kubernetes clusters](./kubernetes-monitoring-enable.md).

5. If there are no network errors, check if the cluster level prometheus scraping is enabled by reviewing the  [prometheus_data_collection_settings.cluster] settings in configmap.

    ```bash
    # Check if the cluster has container-azm-ms-agentconfig configmap in kube-system namespace
    kubectl get cm -n kube-system | grep container-azm-ms-agentconfig
    # If there is no existing container-azm-ms-agentconfig configmap, then means cluster level prometheus data collection not enabled
    ```
6. Check the cluster size in terms of the nodes and pods count.

    ```bash
    # Check if the cluster has container-azm-ms-agentconfig configmap in kube-system namespace
    NodeCount=$(kubectl get nodes | wc -l)
    echo "Total number of nodes: ${NodeCount}"
    PodCount=$(kubectl get pods -A -o wide | wc -l)
    echo "Total number of pods: ${PodCount}"
    
    # If there is no existing container-azm-ms-agentconfig configmap, then means cluster level prometheus data collection is not enabled.
    ```

7. If you determine the issue is related to scale of the cluster, then ama-logs-rs memory limit needs to be increased. Open a support case with Microsoft to make this request.


## Latency issues
By default Container insights collects monitoring data every 60 seconds unless you configure data collection settings or add a [transformation](../essentials/data-collection-transformations.md). See [Log data ingestion time in Azure Monitor](../logs/data-ingestion-time.md) for detailed information on latency and expected ingestion times in a Log Analytics workspace.

Check the  latencies for the reported table and time window in the log analytics workspace associated to the clusters using the following query.

```kusto
let clusterResourceId = "/subscriptions/<subscriptionId>/resourceGroups/<rgName>/providers/Microsoft.ContainerService/managedClusters/<clusterName>";
let startTime = todatetime('2024-11-20T20:34:11.9117523Z');
let endTime = todatetime('2024-11-21T20:34:11.9117523Z');
KubePodInventory #Update this table name to the one you want to check
| where _ResourceId =~ clusterResourceId
| where TimeGenerated >= startTime and TimeGenerated <= endTime
| extend E2EIngestionLatency = ingestion_time() - TimeGenerated
| extend AgentLatency = _TimeReceived - TimeGenerated
| summarize max(E2EIngestionLatency), max(AgentLatency) by Computer
| project Computer, max_AgentLatency, max_ingestionLatency = (max_E2EIngestionLatency -  max_AgentLatency),max_E2EIngestionLatency
```

If you're seeing high agent latencies, check if you configured a different log collection interval than default of 60 seconds in the Container Insights DCR.

``` sh
# set the subscriptionId of the cluster
az account set -s "<subscriptionId>"
# check if ContainerInsightsExtension  data collection rule association exists
az monitor data-collection rule association list --resource <clusterResourceId>
# get the data collection rule resource id associated to ContainerInsightsExtension from above step
az monitor data-collection rule show  --ids  <dataCollectionRuleResourceIdFromAboveStep>
# check if there are any data collection settings related to interval from the output of the above step
```

## Multiline logging issues
[Multi-line log feature](./container-insights-logs-schema.md#multi-line-logging) can be enabled with configmap and supports the following scenarios.

- Supports log messages up to 64KB instead of the default limit of 16KB.
- Stitches exception call stack traces for supported languages .NET, Go, Python and Java.

Verify that the multiline feature and ContainerLogV2 schema are enabled with the following commands.

``` bash
    # get the list of ama-logs and these pods should be in Running state
    # If these are not in Running state, then this needs to be investigated
    kubectl get po -n kube-system | grep ama-logs

    # exec into any one of the ama-logs daemonset pod and check for the environment variables
    kubectl exec -it  ama-logs-xxxxx -n kube-system -c ama-logs -- bash

    # after exec into the container run this command
    env | grep AZMON_MULTILINE

    # result should have environment variables which indicates the multiline and languages enabled
    AZMON_MULTILINE_LANGUAGES=java,go
    AZMON_MULTILINE_ENABLED=true

    # check if the containerlog v2 schema enabled or not
    env | grep AZMON_CONTAINER_LOG_SCHEMA_VERSION

    # output should be v2. If not v2, then check whether this is being enabled through DCR
    AZMON_CONTAINER_LOG_SCHEMA_VERSION=v2
```


