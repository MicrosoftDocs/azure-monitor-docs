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

## Next steps

* If you experience issues while you attempt to onboard the solution, review the [Troubleshooting guide](container-insights-troubleshoot.md).
* With monitoring enabled to collect health and resource utilization of your AKS cluster and workloads running on them, learn [how to use](container-insights-analyze.md) Container insights.
