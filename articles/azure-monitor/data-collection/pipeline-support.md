---
title: Azure Monitor pipeline support and availability
description: Review supported deployment platforms, configuration methods, Kubernetes distributions, and regions for Azure Monitor pipeline.
ai-usage: ai-assisted
ms.topic: reference
ms.date: 11/23/2026
ms.custom: references_regions
---

# Azure Monitor pipeline support and availability

Use this article to determine where Azure Monitor pipeline can run and which configuration model to use. For supported telemetry inputs, see [Sources](./pipeline-sources.md). For supported outputs, see [Destinations](./pipeline-destinations.md).

Support status applies independently to the deployment platform, configuration model, and telemetry source. For example, Syslog collection is generally available, while DCR-based configuration on Arc-enabled Kubernetes is in preview.

## Deployment platforms

| Deployment platform | Configuration | Status | Guidance |
|:---|:---|:---|:---|
| Azure Arc-enabled Kubernetes | DCR-based configuration with the `microsoft.monitor.pipeline` extension | Preview; recommended for all new Kubernetes deployments | [Configure with DCRs](./pipeline-configure-cli.md). |
| Linux VM in Azure | DCR-based configuration with the Azure Monitor pipeline VM extension | Preview | [Configure on a Linux VM](./pipeline-configure-vm.md). |
| Azure Arc-enabled Linux server | DCR-based configuration with the Azure Monitor pipeline extension | Preview | [Configure on an Arc-enabled Linux server](./pipeline-configure-vm.md#arc-enabled-linux-servers). |
| Azure Arc-enabled Kubernetes | PipelineGroup configuration with the `microsoft.monitor.pipelinecontroller` extension | Legacy; existing deployments only | [Manage an existing deployment](./pipeline-configure-legacy.md). |

Virtual Machine Scale Sets aren't currently supported for the Linux VM deployment.

## Supported Kubernetes distributions

Azure Monitor pipeline supports the following Kubernetes distributions and versions:

- VMware Tanzu Kubernetes Grid multicloud (TKGm) v1.28.11.
- SUSE Rancher K3s v1.33.3+k3s1.
- AKS Arc v1.32.7.

These entries are the officially supported configurations. Other Kubernetes distributions or versions might technically run the extension, but they're not supported unless they're listed here. Availability also depends on Azure Arc-enabled Kubernetes and the required Certificate Manager extension being supported in the cluster region.

## Choose a configuration method

| Scenario | Method | Recommendation |
|:---|:---|:---|
| New deployment on Arc-enabled Kubernetes | Azure CLI or ARM templates with DCR-based configuration | Use for all new deployments. |
| New deployment on a Linux VM or Arc-enabled Linux server | Azure CLI and Bicep with DCR-based configuration | Use the VM extension preview guidance. |
| Existing PipelineGroup deployment | Azure portal or existing CLI and ARM template procedures | Use only to manage an existing deployment. Don't create a new PipelineGroup deployment. |

The Azure portal currently creates a legacy PipelineGroup deployment. It doesn't configure the DCR-based model.

## Supported regions for DCR-based Kubernetes deployments

During preview, deploy the DCRs in the same region as the destination workspace. The `microsoft.monitor.pipeline` extension is available in the following regions:

| Region | Region | Region |
|:---|:---|:---|
| Australia Central | Australia East | Australia Southeast |
| Austria East | Belgium Central | Brazil South |
| Canada Central | Canada East | Central India |
| Central US | Chile Central | Denmark East |
| East Asia | East US | East US 2 |
| France Central | Germany West Central | Indonesia Central |
| Italy North | Japan East | Japan West |
| Jio India West | Korea Central | Korea South |
| Malaysia West | Mexico Central | New Zealand North |
| North Central US | North Europe | Norway East |
| Poland Central | Qatar Central | South Africa North |
| South Central US | South India | Southeast Asia |
| Spain Central | Sweden Central | Switzerland North |
| UAE North | UK South | UK West |
| West Central US | West Europe | West India |
| West US | West US 2 | West US 3 |

For current public-region availability, see [Product availability by region](https://azure.microsoft.com/explore/global-infrastructure/products-by-region/table). For existing PipelineGroup deployments, see [legacy supported regions](./pipeline-configure-legacy.md#legacy-overview-supported-configurations).

## Related content

- Review supported telemetry inputs in [Azure Monitor pipeline sources](./pipeline-sources.md).
- Review supported outputs in [Azure Monitor pipeline destinations](./pipeline-destinations.md).
- Compare deployment options in [Plan and deploy Azure Monitor pipeline](./pipeline-configure.md).
