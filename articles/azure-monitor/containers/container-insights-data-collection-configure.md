---
title: Configure Container insights data collection
description: Details on configuring data collection in Azure Monitor Container insights after you enable it on your Kubernetes cluster.
ms.topic: how-to
ms.date: 05/14/2024
ms.reviewer: aul
---

# Configure log collection in Container insights

This article provides details on how to configure data collection in [Container insights](./container-insights-overview.md) for your Kubernetes cluster once it's been onboarded. For guidance on enabling Container insights on your cluster, see [Enable monitoring for Kubernetes clusters](./kubernetes-monitoring-enable.md).

## Configuration methods
There are two methods use to configure and filter data being collected in Container insights. Depending on the setting, you may be able to choose between the two methods or you may be required to use one or the other. The two methods are described in the table below with detailed information in the following sections.

| Method | Description |
|:---|:---| 
| [Data collection rule (DCR)](#configure-data-collection-using-dcr) | [Data collection rules](../essentials/data-collection-rule-overview.md) are sets of instructions supporting data collection using the [Azure Monitor pipeline](../essentials/pipeline-overview.md). A DCR is created when you enable Container insights, and you can modify the settings in this DCR either using the Azure portal or other methods. | 
| [ConfigMap](#configure-data-collection-using-configmap) | [ConfigMaps](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/) are a Kubernetes mechanism that allows you to store non-confidential data such as a configuration file or environment variables. Container insights looks for a ConfigMap on each cluster with particular settings that define data that it should collect.|

## Configure data collection using DCR







## Configure data collection using ConfigMap


> [!IMPORTANT]
> ConfigMap is a global list and there can be only one ConfigMap applied to the agent for Container insights. Applying another ConfigMap will overrule the previous ConfigMap collection settings.











## Next steps

- See [Filter log collection in Container insights](./container-insights-data-collection-filter.md) for details on saving costs by configuring Container insights to filter data that you don't require.

