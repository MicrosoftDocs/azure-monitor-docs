---
ms.topic: include
ms.date: 02/09/2026
---

## Prerequisites

* [Arc-enabled Kubernetes cluster](/azure/azure-arc/kubernetes/overview) in your own environment with an external IP address. See [Connect an existing Kubernetes cluster to Azure Arc](/azure/azure-arc/kubernetes/quickstart-connect-cluster) for details on enabling Arc for a cluster.
* Enable custom locations features on your cluster. See [Create and manage custom locations on Azure Arc-enabled Kubernetes](/azure/azure-arc/kubernetes/custom-locations#enable-custom-locations-on-your-cluster).
* Log Analytics workspace in Azure Monitor to receive the data from the pipeline. See [Create a Log Analytics workspace in the Azure portal](../logs/quick-create-workspace.md) for details on creating a workspace.
* Register the following resources in your Azure subscription. See [Azure resource providers and types](/azure/azure-resource-manager/management/resource-providers-and-types).
    * Microsoft.Insights
    * Microsoft.Monitor 

