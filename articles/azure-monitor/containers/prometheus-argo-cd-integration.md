---
title: Configure Argo CD Integration for Prometheus Metrics in Azure Monitor
description: This article describes how to configure Argo CD monitoring by using Prometheus metrics in Azure Monitor to a Kubernetes cluster.
ms.topic: how-to
ms.date: 3/10/2025
ms.reviewer: rashmy
---

# Collect Argo CD metrics by using managed service for Prometheus

Argo CD is a declarative, GitOps continuous delivery tool for Kubernetes. Argo CD follows the GitOps pattern of using Git repositories as the source of truth for defining the desired application states. It automates the deployment of the desired application states in the specified target environments. Application deployments can track updates to branches or tags, or they can be pinned to a specific version of manifests at a Git commit.

This article describes how to configure the Azure Monitor *managed service for Prometheus* feature with Azure Kubernetes Service (AKS) and Azure Arc-enabled Kubernetes to monitor Argo CD by scraping Prometheus metrics.

## Prerequisites

+ Argo CD running on AKS or Azure Arc-enabled Kubernetes
+ Managed service for Prometheus enabled on the cluster. For more information, see [Enable Prometheus and Grafana](kubernetes-monitoring-enable.md).

## Deploy service monitors

Deploy the following service monitors to configure the managed service for Prometheus add-on to scrape Prometheus metrics from the Argo CD workload.

> [!NOTE]
> Specify the right labels in `matchLabels` for the service monitors if they don't match the configured ones in the sample.

```yaml
apiVersion: azmonitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: azmon-argocd-metrics
spec:
  labelLimit: 63
  labelNameLengthLimit: 511
  labelValueLengthLimit: 1023
  selector:
    matchLabels:
     app.kubernetes.io/name: argocd-metrics
  namespaceSelector:
    any: true
  endpoints:
  - port: metrics
---
apiVersion: azmonitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: azmon-argocd-repo-server-metrics
spec:
  labelLimit: 63
  labelNameLengthLimit: 511
  labelValueLengthLimit: 1023
  selector:
    matchLabels:
      app.kubernetes.io/name: argocd-repo-server
  namespaceSelector:
    any: true
  endpoints:
  - port: metrics
---
apiVersion: azmonitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: azmon-argocd-server-metrics
spec:
  labelLimit: 63
  labelNameLengthLimit: 511
  labelValueLengthLimit: 1023
  selector:
    matchLabels:
      app.kubernetes.io/name: argocd-server-metrics
  namespaceSelector:
    any: true
  endpoints:
  - port: metrics
  ```

> [!NOTE]
> If you want to configure any other service or pod monitors, follow [these instructions](prometheus-metrics-scrape-crd.md#create-a-pod-or-service-monitor).

## Deploy rules

1. Download the [template file](https://github.com/Azure/prometheus-collector/blob/main/Azure-ARM-templates/Workload-Rules/Argo/argocd-alerting-rules.json) and the [parameter file](https://github.com/Azure/prometheus-collector/blob/main/Azure-ARM-templates/Workload-Rules/Alert-Rules-Parameters.json) for alerting rules.

2. Edit the following values in the parameter file.

    | Parameter | Value |
    |:---|:---|
    | `azureMonitorWorkspace` | Resource ID for the Azure Monitor workspace. Retrieve it from **JSON view** on the **Overview** page for the Azure Monitor workspace. |
    | `location` | Location of the Azure Monitor workspace. Retrieve it from **JSON view** on the **Overview** page for the Azure Monitor workspace. |
    | `clusterName` | Name of the AKS cluster. Retrieve it from **JSON view** on the **Overview** page for the cluster. |
    | `actionGroupId` | Resource ID for the alert action group. Retrieve it from **JSON view** on the **Overview** page for the action group. [Learn more about action groups](../alerts/action-groups.md). |

3. Deploy the template by using any standard methods for installing Azure Resource Manager templates. For guidance, see [Resource Manager template samples for Azure Monitor](../resource-manager-samples.md).

4. After you deploy the template, you can view the rules in the Azure portal, as described in [View Prometheus rule groups](../essentials/prometheus-rule-groups.md#view-prometheus-rule-groups). Review the alert thresholds to make sure that they suit your cluster and workloads. Update the thresholds accordingly.

   > [!NOTE]
   > The rules aren't scoped to a cluster. If you want to scope the rules to a specific cluster, see [Limiting rules to a specific cluster](../essentials/prometheus-rule-groups.md#limiting-rules-to-a-specific-cluster).

You can [learn more about Prometheus alerts](../essentials/prometheus-rule-groups.md). If you want to use any other open-source Prometheus alerting/recording rules, use [az-prom-rules-converter](https://aka.ms/az-prom-rules-converter) to create the Azure-equivalent Prometheus rules.

## Import the Grafana dashboard

To import the [Grafana dashboard for Argo CD (ID 14191)](https://grafana.com/grafana/dashboards/14584-argocd/) by using the ID or JSON, follow the instructions in [Import a dashboard from Grafana Labs](/azure/managed-grafana/how-to-create-dashboard#import-a-grafana-dashboard).

## Troubleshoot

When the service monitors are successfully applied, if you want to make sure that the add-on picks up the service monitor targets, follow [these instructions](prometheus-metrics-troubleshoot.md#prometheus-interface).
