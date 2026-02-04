---
title: Azure Chaos Studio compatibility
description: Understand the compatibility of Azure Chaos Studio with specific operating systems and tools.
services: chaos-studio
author: rsgel 
ms.topic: overview
ms.date: 01/26/2024
ms.reviewer: carlsonr
---

# Azure Chaos Studio version compatibility

The following reference shows relevant version support and compatibility within Chaos Studio.

## Chaos Mesh compatibility

Faults within Azure Kubernetes Service resources currently integrate with the open-source project [Chaos Mesh](https://chaos-mesh.org/), which is part of the [Cloud Native Computing Foundation](https://www.cncf.io/projects/chaosmesh/). Review [Create a chaos experiment that uses a Chaos Mesh fault to kill AKS pods with the Azure portal](chaos-studio-tutorial-aks-portal.md) for more details on using Azure Chaos Studio with Chaos Mesh.

Find Chaos Mesh's support policy and release dates here: [Supported Releases](https://chaos-mesh.org/supported-releases/).

Chaos Studio currently tests with the following version combinations. 

| Chaos Studio fault version | Kubernetes version | Chaos Mesh version | Notes |
|:---:|:---:|:---:|:---:|
| 2.2 | 1.34 | 2.8.0 | |
| 2.2 | 1.33 | 2.8.0 | |
| 2.2 | 1.32 | 2.8.0 | |
| 2.2 | 1.34 | 2.7.3 | |
| 2.2 | 1.33 | 2.7.3 | |
| 2.2 | 1.32 | 2.7.3 | |
| 2.1 | 1.34 | 2.8.0 | |
| 2.1 | 1.33 | 2.8.0 | |
| 2.1 | 1.32 | 2.8.0 | |
| 2.1 | 1.34 | 2.7.3 | |
| 2.1 | 1.33 | 2.7.3 | |
| 2.1 | 1.32 | 2.7.3 | |

The *Chaos Studio fault version* column refers to the individual fault version for each AKS Chaos Mesh fault used in the experiment JSON, for example `urn:csci:microsoft:azureKubernetesServiceChaosMesh:podChaos/2.2`. If a past version of the corresponding Chaos Studio fault remains available from the Chaos Studio API (for example, `...podChaos/2.1`), it is within support.

## Browser compatibility

Review the Azure portal documentation on [Supported devices](/azure/azure-portal/azure-portal-supported-browsers-devices) for more information on browser support.

## Agent compatibility

To learn more about Chaos Studio agent compatibility with Virtual Machine operating systems, review the [Chaos Agent Version Compatibility](chaos-agent-os-support.md) page.
