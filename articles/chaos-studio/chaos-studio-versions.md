---
title: Azure Chaos Studio version compatibility
description: Learn about version compatibility for Chaos Mesh, AKS, agent operating systems, and browser support in Azure Chaos Studio.
services: chaos-studio
author: rsgel 
ms.topic: overview
ms.date: 06/10/2026
ms.reviewer: carlsonr
ai-usage: ai-assisted
---

# Azure Chaos Studio version compatibility

This page lists tested version combinations for components that Chaos Studio integrates with.

## Chaos Mesh compatibility

Faults that target Azure Kubernetes Service (AKS) resources integrate with the open-source [Chaos Mesh](https://chaos-mesh.org/) project, part of the [Cloud Native Computing Foundation](https://www.cncf.io/projects/chaosmesh/). For setup instructions, see [Create a chaos experiment that uses a Chaos Mesh fault to kill AKS pods](chaos-studio-tutorial-aks-portal.md).

For the Chaos Mesh support policy and release dates, see [Supported Releases](https://chaos-mesh.org/supported-releases/).

Chaos Studio currently tests with the following version combinations:

| Chaos Studio fault version | Kubernetes version | Chaos Mesh version |
|:---:|:---:|:---:|
| 2.2 | 1.34 | 2.8.0 |
| 2.2 | 1.33 | 2.8.0 |
| 2.2 | 1.32 | 2.8.0 |
| 2.2 | 1.34 | 2.7.3 |
| 2.2 | 1.33 | 2.7.3 |
| 2.2 | 1.32 | 2.7.3 |
| 2.1 | 1.34 | 2.8.0 |
| 2.1 | 1.33 | 2.8.0 |
| 2.1 | 1.32 | 2.8.0 |
| 2.1 | 1.34 | 2.7.3 |
| 2.1 | 1.33 | 2.7.3 |
| 2.1 | 1.32 | 2.7.3 |

The *Chaos Studio fault version* column refers to the fault version in the experiment JSON, for example `urn:csci:microsoft:azureKubernetesServiceChaosMesh:podChaos/2.2`. Older fault versions may remain callable through the API, but only the version combinations listed in this table are tested and supported.

## Agent OS compatibility

For supported operating systems for the Chaos Studio agent, see [Agent OS support](chaos-agent-os-support.md).

## Browser compatibility

For supported browsers, see [Supported devices](/azure/azure-portal/azure-portal-supported-browsers-devices).
