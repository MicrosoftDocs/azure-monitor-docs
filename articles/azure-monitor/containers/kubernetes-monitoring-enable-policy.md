---
title: Enable monitoring for Kubernetes clusters using Azure Policy
description: Learn how to enable Container insights and Managed Prometheus on an Azure Kubernetes Service (AKS) cluster.
ms.topic: how-to
ms.custom: devx-track-azurecli, linux-related-content
ms.reviewer: aul
ms.date: 03/11/2024
---

# Enable monitoring for Kubernetes clusters using Azure Policy

As described in [Kubernetes monitoring in Azure Monitor](./container-insights-overview.md), multiple features of Azure Monitor work together to provide complete monitoring of your Azure Kubernetes Service (AKS) or Azure Arc-enabled Kubernetes clusters. This article describes how to enable these features using the Azure portal.

## Prometheus

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

## Container logs

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

## Next steps

* If you experience issues while you attempt to onboard the solution, review the [Troubleshooting guide](container-insights-troubleshoot.md).
* With monitoring enabled to collect health and resource utilization of your AKS cluster and workloads running on them, learn [how to use](container-insights-analyze.md) Container insights.
