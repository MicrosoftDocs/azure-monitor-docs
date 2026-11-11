---
title: Monitor AKS applications with OpenTelemetry Protocol (OTLP)
description: Enable application monitoring for Azure Kubernetes Service (AKS) namespaces and deployments and send OpenTelemetry Protocol (OTLP) telemetry to Application Insights using Azure Monitor.
ms.topic: how-to
ms.date: 11/06/2026
ms.reviewer: kaprince
ms.custom: references_regions
---

# Monitor AKS applications with OTLP and Azure Monitor

OpenTelemetry provides a standardized way to emit traces, logs, and metrics. Azure Monitor supports monitoring applications that run on Azure Kubernetes Service (AKS) by using the OpenTelemetry Protocol (OTLP) for instrumentation and data collection.

> [!TIP]
> For a conceptual overview of OpenTelemetry options in Azure Monitor — native OTLP ingestion, the Microsoft OpenTelemetry Distro, and end-to-end observability experiences — see [OpenTelemetry with Azure Monitor](opentelemetry-options.md).

## Key capabilities

- Enable cluster-level monitoring to install Azure Monitor components on the AKS cluster.
- Create an Application Insights resource with OTLP ingestion enabled.
- Onboard applications at the namespace or deployment scope by using either:
  - **Autoinstrumentation** with language-specific OpenTelemetry instrumentation.
  - **Autoconfiguration** for applications already instrumented with the open-source OpenTelemetry Software Development Kits (SDKs).
    - Autoconfiguration applies only to applications that are already instrumented with OpenTelemetry. When you select autoconfiguration, Azure Monitor doesn't add instrumentation to your application. Instead, it sets environment variables at the platform level so existing OpenTelemetry SDKs export telemetry to Application Insights. You're responsible for instrumenting the application (for example, by using OpenTelemetry SDKs or annotations) before you enable autoconfiguration.

Telemetry flows to **Application Insights**, where you analyze application performance in context with Container Insights.

> [!IMPORTANT]
> Unsupported node pools: **Windows (any architecture)**.

## Roles and responsibilities

Use the following guidance to separate platform (cluster) responsibilities from application development (workload) responsibilities. *Cluster administrator* refers to the team that's responsible for the AKS cluster and Azure Monitor telemetry pipeline. *Developer* refers to the team that owns the application code and its telemetry configuration.

| Cluster administrator responsibilities | Developer responsibilities |
|---|---|
| Enable and maintain the cluster-level monitoring integration (AKS Monitor settings / add-ons). | Instrument application code using OpenTelemetry SDKs (or adopt supported auto-instrumentation where applicable). |
| Create, configure, and govern shared Azure resources used for ingestion and storage (Application Insights, Azure Monitor workspace, Log Analytics workspace, DCR/DCE where applicable). | Configure application telemetry (resource attributes, sampling, log correlation, and exporter settings) and validate signal correctness. |
| Manage identities and permissions required for telemetry export (managed identities, Microsoft Entra app registrations/service principals, RBAC role assignments). | Onboard workloads at the namespace or deployment scope (labels/annotations/configuration resources) following the platform's supported pattern. |
| Define and enforce cluster governance (namespaces, network policy, admission controls, quotas/limits) that can impact telemetry collection. | Perform application rollout restarts when required to apply monitoring changes to pods/deployments. |
| Operate and troubleshoot platform components (Azure Monitor Agent/Managed Prometheus/collectors deployed as add-ons), including upgrades and rollback plans. | Troubleshoot application-level telemetry gaps (missing spans/metrics/logs, incorrect attributes, high cardinality, and noisy logs) and remediate in code/config. |
| Provide supported recommended baseline configurations (standard ports/endpoints, required temporality/aggregation expectations, approved exporters/processors). | Own SLOs/alerting for the application and use Azure Monitor / Application Insights experiences to investigate regressions. |

*Out of scope for cluster admins: changing application code, selecting libraries, and defining business-level telemetry semantics.*

*Out of scope for developers: changing cluster add-ons, platform RBAC, shared ingestion resource topology, or cluster networking.*

**Common collaboration points:**

- Agree on naming and labeling standards (`service.name`, `k8s.deployment.name`, and namespace conventions) so data is queryable and dashboards work across teams.
- Align on performance and cost guardrails (sampling strategy, log verbosity, and metric cardinality) and who changes what when limits are exceeded.
- Define a support workflow for telemetry issues (what developers check first vs. when to escalate to the cluster admin team).
- Plan changes jointly when they span both layers (for example, switching ingestion method, changing endpoint/temporality expectations, or introducing a collector).


## Prerequisites

- An AKS cluster in Azure public cloud that runs at least one Kubernetes deployment.
- Azure CLI **2.91.0** or later. Install or update by using the guidance in **Install the Azure CLI** documentation.
  Verify the version:
  ```bash
  az version
  ```
- The `aks-preview` extension isn't required. If it's installed, update it or remove it so an older extension doesn't override the core `az aks` commands.

## 1. Prepare the cluster

Prepare the cluster by using the Azure portal, Azure CLI, an ARM template, or Bicep.

The commands in this and the following sections specify subscriptions explicitly so AKS, infrastructure monitoring, and Application Insights resources can be in different subscriptions.

> [!IMPORTANT]
> - Managed Prometheus (Azure Monitor metrics) must be enabled before the OTLP metrics receiver. Azure CLI can enable both in the same `az aks update` operation. Disabling Managed Prometheus also disables the OTLP metrics receiver.
> - Container Insights (Azure Monitor logs) must be enabled before the OTLP logs and traces receiver. Azure CLI can enable both in the same `az aks update` operation. Disabling Container Insights also disables the OTLP logs and traces receiver.
> - You can enable both infrastructure-monitoring features and both OTLP receivers together by using Azure CLI.

### [Azure portal](#tab/azure-portal)

1. In the AKS resource, select **Monitor (Insights)**, and then select **Monitor Settings**.
1. On the **Capabilities** tab, ensure the cluster is already onboarded to Azure Monitor metrics and logs. If it isn't, follow [Enable monitoring for AKS clusters](kubernetes-monitoring-enable.md), wait for onboarding to finish, and then return to **Monitor Settings**.
1. Turn on **Enable support for auto-instrumentation** and **Enable support for data collection from vendor-neutral OpenTelemetry SDKs**.
1. Confirm that the Azure Monitor workspace selected for Managed Prometheus isn't an Application Insights managed workspace. Infrastructure and application metrics must use different Azure Monitor workspaces.
1. Select **Review + enable**, confirm the summary, and then select **Enable**.

To enable or disable one receiver independently, use Azure CLI, ARM, or Bicep.

Before onboarding workloads, complete [Verify receiver readiness before restarting workloads](#verify-receiver-readiness-before-restarting-workloads).

:::image type="content" source="./media/kubernetes-open-protocol/azure-settings-enable-application.png" lightbox="./media/kubernetes-open-protocol/azure-settings-enable-application.png" alt-text="A screenshot of the AKS Monitor overview with the Monitor Settings option.":::

:::image type="content" source="./media/kubernetes-open-protocol/azure-settings-review-enable.png" lightbox="./media/kubernetes-open-protocol/azure-settings-review-enable.png" alt-text="A screenshot of the Monitor Settings Capabilities page with application-monitoring options selected.":::

### [Azure CLI](#tab/azure-cli)

#### Check the current monitoring configuration

```azurecli
az aks show \
  --subscription "<aks-subscription-name-or-id>" \
  --resource-group <aks-resource-group> \
  --name <aks-name> \
  --query "{prometheus:azureMonitorProfile.metrics.enabled, containerInsights:azureMonitorProfile.containerInsights.enabled || addonProfiles.omsagent.enabled || addonProfiles.omsAgent.enabled}"
```

For first-time onboarding, you can enable both infrastructure-monitoring features and all three application-monitoring profiles in one operation. This command uses the default workspaces:

```azurecli
az aks update \
  --subscription "<aks-subscription-name-or-id>" \
  --resource-group <aks-resource-group> \
  --name <aks-name> \
  --enable-azure-monitor-metrics \
  --enable-azure-monitor-logs \
  --enable-azure-monitor-app-monitoring \
  --enable-opentelemetry-metrics \
  --enable-opentelemetry-logs-traces
```

If you use the combined command, skip the remaining enable commands in this tab. Otherwise, enable only the missing infrastructure-monitoring feature. The following commands use the default workspaces.

If Managed Prometheus is missing:

```azurecli
az aks update \
  --subscription "<aks-subscription-name-or-id>" \
  --resource-group <aks-resource-group> \
  --name <aks-name> \
  --enable-azure-monitor-metrics
```

If Container Insights is missing:

```azurecli
az aks update \
  --subscription "<aks-subscription-name-or-id>" \
  --resource-group <aks-resource-group> \
  --name <aks-name> \
  --enable-azure-monitor-logs
```

For existing workspace parameters and other onboarding options, see [Enable monitoring for AKS clusters](kubernetes-monitoring-enable.md). The infrastructure Azure Monitor workspace must be different from the Application Insights managed workspace.

#### Enable all application-monitoring profiles

```azurecli
az aks update \
  --subscription "<aks-subscription-name-or-id>" \
  --resource-group <aks-resource-group> \
  --name <aks-name> \
  --enable-azure-monitor-app-monitoring \
  --enable-opentelemetry-metrics \
  --enable-opentelemetry-logs-traces
```

#### Enable or disable one OTLP receiver

Each command changes only the specified receiver profile.

To enable only the metrics receiver:

```azurecli
az aks update \
  --subscription "<aks-subscription-name-or-id>" \
  --resource-group <aks-resource-group> \
  --name <aks-name> \
  --enable-opentelemetry-metrics
```

To disable only the metrics receiver:

```azurecli
az aks update \
  --subscription "<aks-subscription-name-or-id>" \
  --resource-group <aks-resource-group> \
  --name <aks-name> \
  --disable-opentelemetry-metrics \
  --yes
```

To enable only the logs and traces receiver:

```azurecli
az aks update \
  --subscription "<aks-subscription-name-or-id>" \
  --resource-group <aks-resource-group> \
  --name <aks-name> \
  --enable-opentelemetry-logs-traces
```

To disable only the logs and traces receiver:

```azurecli
az aks update \
  --subscription "<aks-subscription-name-or-id>" \
  --resource-group <aks-resource-group> \
  --name <aks-name> \
  --disable-opentelemetry-logs-traces \
  --yes
```

#### Change receiver ports

For default ports, port conflicts, and custom-port instructions, see [Resolve OTLP receiver port conflicts](#resolve-otlp-receiver-port-conflicts).

#### Apply receiver changes to existing workloads

If workloads are already instrumented, select the target cluster under an explicit context name, wait for the webhook deployment to update, and then restart the affected deployments:

```azurecli
az aks get-credentials \
  --subscription "<aks-subscription-name-or-id>" \
  --resource-group <aks-resource-group> \
  --name <aks-name> \
  --context <aks-context-name>
```

Complete [Verify receiver readiness before restarting workloads](#verify-receiver-readiness-before-restarting-workloads), and then restart the affected deployments:

```bash
kubectl --context <aks-context-name> rollout restart deployment -n <your-namespace>
```

During initial onboarding, don't restart workloads here. Step 3 restarts them after you apply the Instrumentation resource.

### [Bicep/ARM](#tab/bicep-arm)

#### Check the current monitoring configuration

```azurecli
az aks show \
  --subscription "<aks-subscription-name-or-id>" \
  --resource-group <aks-resource-group> \
  --name <aks-name> \
  --query "{prometheus:azureMonitorProfile.metrics.enabled, containerInsights:azureMonitorProfile.containerInsights.enabled || addonProfiles.omsagent.enabled || addonProfiles.omsAgent.enabled}"
```

If both values are `null` or `false`, neither Managed Prometheus nor Container Insights is enabled.

To enable either feature separately, follow [Enable monitoring for AKS clusters](kubernetes-monitoring-enable.md). If both features are disabled, you can instead use the prerequisite template in this tab to enable both.

#### Download the templates and parameter files

**Bicep**

- Prerequisite [template](https://github.com/microsoft/Docker-Provider/blob/ci_prod/scripts/onboarding/aks/application-monitoring/bicep/aks-otlp-monitoring-prerequisites.bicep) and [parameter file](https://github.com/microsoft/Docker-Provider/blob/ci_prod/scripts/onboarding/aks/application-monitoring/bicep/aks-otlp-monitoring-prerequisites.parameters.json).
- [Linked-template helper](https://github.com/microsoft/Docker-Provider/blob/ci_prod/scripts/onboarding/aks/application-monitoring/bicep/linked-template-deployment.bicep). Save it in the same folder as the prerequisite template. Don't deploy it directly.
- Application-monitoring profile [template](https://github.com/microsoft/Docker-Provider/blob/ci_prod/scripts/onboarding/aks/application-monitoring/bicep/aks-app-monitoring-profile.bicep) and [parameter file](https://github.com/microsoft/Docker-Provider/blob/ci_prod/scripts/onboarding/aks/application-monitoring/bicep/aks-app-monitoring-profile.parameters.json).

**ARM**

- Prerequisite [template](https://github.com/microsoft/Docker-Provider/blob/ci_prod/scripts/onboarding/aks/application-monitoring/arm/aks-otlp-monitoring-prerequisites.json) and [parameter file](https://github.com/microsoft/Docker-Provider/blob/ci_prod/scripts/onboarding/aks/application-monitoring/arm/aks-otlp-monitoring-prerequisites.parameters.json).
- Application-monitoring profile [template](https://github.com/microsoft/Docker-Provider/blob/ci_prod/scripts/onboarding/aks/application-monitoring/arm/aks-app-monitoring-profile.json) and [parameter file](https://github.com/microsoft/Docker-Provider/blob/ci_prod/scripts/onboarding/aks/application-monitoring/arm/aks-app-monitoring-profile.parameters.json).

#### Configure the parameter files

Use a dedicated monitoring resource group and unique names for the Azure Monitor workspace, Log Analytics workspace, and Managed Grafana resource. Retrieve resource IDs from the **JSON View** of each resource's **Overview** page.

| Parameter | Template | Description |
| --- | --- | --- |
| `clusterResourceId` | Prerequisites | Full resource ID of the AKS cluster. |
| `clusterLocation` | Both | Azure region of the AKS cluster. |
| `monitoringWorkspaceLocation` | Prerequisites | Region for the infrastructure Azure Monitor and Log Analytics workspaces. |
| `createAzureMonitorWorkspace` | Prerequisites | When `true`, create an infrastructure Azure Monitor workspace. When `false`, reuse `azureMonitorWorkspaceResourceId`. |
| `azureMonitorWorkspaceName` | Prerequisites | Unique name for the infrastructure Azure Monitor workspace. |
| `azureMonitorWorkspaceResourceId` | Prerequisites | Existing infrastructure Azure Monitor workspace resource ID when `createAzureMonitorWorkspace=false`. The workspace must be in the deployment resource group and `monitoringWorkspaceLocation`. |
| `createLogAnalyticsWorkspace` | Prerequisites | When `true`, create a Container Insights Log Analytics workspace. When `false`, reuse `logAnalyticsWorkspaceResourceId`. |
| `logAnalyticsWorkspaceName` | Prerequisites | Unique name for the Container Insights Log Analytics workspace. |
| `logAnalyticsWorkspaceResourceId` | Prerequisites | Existing Log Analytics workspace resource ID when `createLogAnalyticsWorkspace=false`. The workspace must be in `monitoringWorkspaceLocation`. |
| `logAnalyticsWorkspaceRetentionInDays` | Prerequisites | Retention period for a new Log Analytics workspace, from 30 through 730 days. |
| `managedGrafanaName` | Prerequisites | Unique name for the dedicated Azure Managed Grafana resource. |
| `managedGrafanaLocation` | Prerequisites | Region for Azure Managed Grafana. |
| `managedGrafanaSku` | Prerequisites | SKU for Azure Managed Grafana. The sample uses `Standard`. |
| `grafanaAdminPrincipalId` | Prerequisites | Optional object ID of a user, group, or service principal to grant Grafana Admin. If empty, no principal receives Grafana data-plane access. |
| `grafanaAdminPrincipalType` | Prerequisites | Type of `grafanaAdminPrincipalId`: `User`, `Group`, `ForeignGroup`, or `ServicePrincipal`. |
| `metricLabelsAllowlist` | Prerequisites | Optional Kubernetes label allow list passed to Managed Prometheus. |
| `metricAnnotationsAllowList` | Prerequisites | Optional Kubernetes annotation allow list passed to Managed Prometheus. |
| `enableControlPlaneMetrics` | Prerequisites | Enable collection of AKS control-plane metrics. |
| `containerInsightsStreams` | Prerequisites | Container Insights DCR streams to collect. The sample uses `Microsoft-ContainerInsights-Group-Default`. |
| `containerInsightsCollectionInterval` | Prerequisites | Container Insights collection interval. The sample uses `1m`. |
| `preserveClusterTags` | Prerequisites | Preserve existing AKS tags when the onboarding template updates the cluster. |
| `clusterTags` | Prerequisites | Complete replacement set of AKS tags when `preserveClusterTags=false`. An empty object removes the existing tags. |
| `tags` | Prerequisites | Optional tags for the workspaces and Azure Managed Grafana resource. |
| `clusterName` | Profile | Name of the AKS cluster. |
| `autoInstrumentationEnabled` | Profile | Desired final state of autoinstrumentation. |
| `openTelemetryMetricsEnabled` | Profile | Desired final state of the metrics receiver. |
| `openTelemetryMetricsHttpPort` | Profile | Optional metrics HTTP/Protobuf host port. Use `0` for the service default. |
| `openTelemetryMetricsGrpcPort` | Profile | Optional metrics gRPC host port. Use `0` for the service default. |
| `openTelemetryLogsAndTracesEnabled` | Profile | Desired final state of the logs and traces receiver. |
| `openTelemetryLogsAndTracesHttpPort` | Profile | Optional logs and traces HTTP/Protobuf host port. Use `0` for the service default. |
| `openTelemetryLogsAndTracesGrpcPort` | Profile | Optional logs and traces gRPC host port. Use `0` for the service default. |

The profile template applies all three boolean values on every deployment. For the full OTLP experience, set all three to `true`.

The deployment identity needs Contributor on the resource groups and `Microsoft.Authorization/roleAssignments/write` inherited from the monitoring resource group or a higher scope. The permission must cover the Azure Monitor workspace and Grafana resource that the deployment creates.

#### Deploy the templates

Deploy the prerequisite template and its parameter file to the monitoring resource group only when both monitoring values are `null` or `false`. It creates infrastructure workspaces and a dedicated Azure Managed Grafana resource, which incurs Azure charges. If either monitoring feature is already enabled, don't deploy this wrapper. Enable only the missing feature by following [Enable monitoring for AKS clusters](kubernetes-monitoring-enable.md), preserving the existing workspaces and associations.

Deploy the application-monitoring profile template and its parameter file to the AKS resource group. Use any valid Resource Manager deployment method. For examples, see [Deploy the sample templates](../fundamentals/resource-manager-samples.md#deploy-the-sample-templates).

Set all three booleans to the desired final profile state:

| Desired state | `autoInstrumentationEnabled` | `openTelemetryMetricsEnabled` | `openTelemetryLogsAndTracesEnabled` |
| --- | --- | --- | --- |
| Autoinstrumentation and both receivers | `true` | `true` | `true` |
| Autoinstrumentation and metrics only | `true` | `true` | `false` |
| Autoinstrumentation and logs/traces only | `true` | `false` | `true` |
| Autoinstrumentation only | `true` | `false` | `false` |
| Both receivers without autoinstrumentation | `false` | `true` | `true` |
| Metrics receiver only | `false` | `true` | `false` |
| Logs/traces receiver only | `false` | `false` | `true` |
| All profiles disabled | `false` | `false` | `false` |

Before you set `autoInstrumentationEnabled=false`, delete the applicable `Instrumentation` resources and restart affected deployments while the webhook is still enabled. For more information, see [Remove autoinstrumentation for AKS](kubernetes-codeless.md#remove-autoinstrumentation-for-aks).

Every profile deployment reapplies both receivers. For each enabled receiver that uses custom ports, keep both of its `*Port` values in the parameter file. A value of `0` restores the service default.

Before redeploying a receiver that uses custom ports, review [Resolve OTLP receiver port conflicts](#resolve-otlp-receiver-port-conflicts).

#### Apply receiver changes to existing workloads

If workloads are already instrumented, select the target cluster under an explicit context name, wait for the webhook deployment to update, and then restart the affected deployments:

```azurecli
az aks get-credentials \
  --subscription "<aks-subscription-name-or-id>" \
  --resource-group <aks-resource-group> \
  --name <aks-name> \
  --context <aks-context-name>
```

Complete [Verify receiver readiness before restarting workloads](#verify-receiver-readiness-before-restarting-workloads), and then restart the affected deployments:

```bash
kubectl --context <aks-context-name> rollout restart deployment -n <your-namespace>
```

During initial onboarding, don't restart workloads here. Step 3 restarts them after you apply the Instrumentation resource.

If a prerequisite deployment fails with `OperationNotAllowed` because Azure Policy, an add-on, or another operation is updating the cluster, wait for the cluster provisioning state to return to `Succeeded`, and then redeploy with the same parameter file.

For workspace reuse, permissions, and other operational safeguards, see the [template README](https://github.com/microsoft/Docker-Provider/blob/ci_prod/scripts/onboarding/aks/application-monitoring/README.md).

---

## 2. Create an Application Insights resource with OTLP support

Create or select an Application Insights resource that supports OTLP and uses **Managed workspaces**.

### [Azure portal](#tab/azure-portal)

1. In the Azure portal, create a new Application Insights resource.
1. Set **OTLP support** to **On**.
1. Set **Use managed workspaces** to **Yes**.

### [Azure CLI](#tab/azure-cli)

The [`az monitor app-insights component create`](/cli/azure/monitor/app-insights/component#az-monitor-app-insights-component-create) command doesn't expose the OTLP managed-workspace settings. Use the generic resource command with the stable Application Insights API:

```azurecli
az resource create \
  --subscription "<application-insights-subscription-name-or-id>" \
  --resource-group <application-insights-resource-group> \
  --name <application-insights-name> \
  --resource-type Microsoft.Insights/components \
  --api-version 2020-02-02 \
  --is-full-object \
  --properties '{
    "location": "<application-insights-location>",
    "kind": "web",
    "properties": {
      "Application_Type": "web",
      "AzureMonitorWorkspaceIngestionMode": "Enabled",
      "Flow_Type": "Bluefield",
      "Request_Source": "rest"
    }
  }'
```

Confirm that Application Insights created its managed workspaces and DCR:

```azurecli
az resource show \
  --subscription "<application-insights-subscription-name-or-id>" \
  --resource-group <application-insights-resource-group> \
  --resource-type Microsoft.Insights/components \
  --name <application-insights-name> \
  --api-version 2020-02-02 \
  --query "{logAnalyticsWorkspace:properties.WorkspaceResourceId, azureMonitorWorkspace:properties.AzureMonitorWorkspaceResourceId, dataCollectionRule:properties.DataCollectionRuleResourceId}"
```

### [Bicep/ARM](#tab/bicep-arm)

#### Download the template and parameter file

- **Bicep:** [Template](https://github.com/microsoft/Docker-Provider/blob/ci_prod/scripts/onboarding/aks/application-monitoring/bicep/application-insights-otlp.bicep) and [parameter file](https://github.com/microsoft/Docker-Provider/blob/ci_prod/scripts/onboarding/aks/application-monitoring/bicep/application-insights-otlp.parameters.json).
- **ARM:** [Template](https://github.com/microsoft/Docker-Provider/blob/ci_prod/scripts/onboarding/aks/application-monitoring/arm/application-insights-otlp.json) and [parameter file](https://github.com/microsoft/Docker-Provider/blob/ci_prod/scripts/onboarding/aks/application-monitoring/arm/application-insights-otlp.parameters.json).

#### Configure the parameters

| Parameter | Description |
| --- | --- |
| `applicationInsightsName` | Name of the OTLP-enabled Application Insights component. |
| `location` | Azure region for Application Insights and its managed workspaces. |
| `useManagedWorkspaces` | When `true`, create the managed Log Analytics and Azure Monitor workspaces. When `false`, reuse both workspace resource IDs. |
| `logAnalyticsWorkspaceResourceId` | Existing Log Analytics workspace resource ID when `useManagedWorkspaces=false`. |
| `azureMonitorWorkspaceResourceId` | Existing Azure Monitor workspace resource ID when `useManagedWorkspaces=false`. |
| `tags` | Optional tags to apply to the Application Insights component. |

#### Deploy the template

Edit the matching parameter file. Keep `useManagedWorkspaces=true` for the default configuration. Deploy the template and parameter file to the Application Insights resource group by using any valid Resource Manager deployment method. For examples, see [Deploy the sample templates](../fundamentals/resource-manager-samples.md#deploy-the-sample-templates).

---

> [!IMPORTANT]
> - Use an **Azure Monitor workspace** that's **different** from the workspace used for infrastructure metrics in step 1.
> - Managed workspaces create a separate Azure Monitor workspace for Application Insights application telemetry using a distinct workspace from the one used for infrastructure metrics.
> - Enabling OTLP support is a one-way operation. For Azure CLI, ARM, or Bicep, use a new Application Insights resource name unless you intend to permanently enable OTLP support on an existing component.

## 3. Onboard applications to Application Insights

You can onboard **all deployments in a namespace** or target **individual deployments** later. The Azure CLI, ARM, and Bicep options configure the Azure data collection rule (DCR) association, then use Kubernetes YAML for the in-cluster configuration.

### Choose the OTLP transport protocol for SDK autoconfiguration

For applications already instrumented with OpenTelemetry SDKs, add the protocol annotation at `spec.template.metadata.annotations` when the exporter needs an explicit protocol.

| Annotation value | Behavior |
| --- | --- |
| Omitted or `"http/protobuf"` | Use OTLP over HTTP/Protobuf. This is the default. |
| `"grpc"` | Use OTLP over gRPC. |

Choose the value that matches the protocol configured by the application's OTLP exporter. If the application code hardcodes the exporter protocol, the annotation must match it.

For example, the following deployment uses gRPC with SDK autoconfiguration:

```yml
spec:
  template:
    metadata:
      annotations:
        instrumentation.opentelemetry.io/inject-configuration: "cr1"
        instrumentation.opentelemetry.io/otel-protocol: "grpc"
```

Keep any annotation that selects a named `Instrumentation` resource. With namespace-wide SDK autoconfiguration, add only the protocol annotation because the deployment already uses the `default` resource.

### Verify receiver readiness before restarting workloads

An AKS cluster update can take a few minutes. Before restarting workloads, confirm that the cluster provisioning state is `Succeeded`. You can check **Provisioning state** on the cluster **Overview** page or run:

```azurecli
az aks show \
  --subscription "<aks-subscription-name-or-id>" \
  --resource-group <aks-resource-group> \
  --name <aks-name> \
  --query provisioningState \
  --output tsv
```

Wait until the command returns `Succeeded`.

### Configure application monitoring for a namespace

#### [Azure portal](#tab/azure-portal)

##### 3.1 Open the namespace

1. In the AKS resource, expand **Kubernetes resources**.
1. Open **Namespaces**, and then select the namespace that hosts your workloads.

:::image type="content" source="./media/kubernetes-open-protocol/azure-namespaces-list.png" lightbox="./media/kubernetes-open-protocol/azure-namespaces-list.png" alt-text="A screenshot of the Azure namespaces list under Kubernetes resources.":::

##### 3.2 Configure application monitoring

When you enable OTLP, Application Insights adds support for open-source, vendor-neutral OpenTelemetry SDKs and OTLP endpoints, and stores metrics in an Azure Monitor workspace.

If you don't enable OTLP, Application Insights only uses Azure Monitor autoinstrumentation and classic ingestion.

> [!IMPORTANT]
> Use the portal for a new namespace configuration. To update an `Instrumentation` resource created with YAML, or to guarantee the exact existing Application Insights destination, use the Azure CLI or Bicep/ARM tab. The portal can fail to resolve a complete existing connection string or recognize its OTLP-enabled destination.

1. Select **Application Monitoring**.
1. Choose the OTLP-enabled Application Insights resource that you created previously in [step 2](#2-create-an-application-insights-resource-with-otlp-support). Verify that the pane identifies the resource as OTLP-enabled. If you select a resource without OTLP support, the pane can still display the **Instrumentation Type** options, but user-configured instrumentation isn't supported for that resource.

1. Choose an **Instrumentation Type**:  
    - **User-configured instrumentation per deployment**
      - Autoconfiguration sets environment variables so existing SDKs export telemetry to Application Insights.
      - Each deployment must already have autoinstrumentation annotations or manual instrumentation. For more information, see [Per deployment onboarding](kubernetes-codeless.md#per-deployment-onboarding).
    - **Java auto-instrumentation for all deployments** for automatic injection of the Azure Monitor OpenTelemetry Distro into Java applications.
      - All deployments in the namespace use Java autoinstrumentation by default. Use annotations to change the language or exclude a deployment. For more information, see [Automatic instrumentation](../app/codeless-overview.md) and [Per deployment onboarding](kubernetes-codeless.md#per-deployment-onboarding).
    - **NodeJS auto-instrumentation for all deployments** for automatic injection of OpenTelemetry instrumentation into Node.js applications.
       - All deployments in the namespace use Node.js autoinstrumentation by default. Use annotations to change the language or exclude a deployment. For more information, see [Automatic instrumentation](../app/codeless-overview.md) and [Per deployment onboarding](kubernetes-codeless.md#per-deployment-onboarding).
    > [!NOTE]
    > The Azure portal only allows you to apply autoinstrumentation or autoconfiguration to a single namespace. If you need to use both options within a single namespace, use [advanced onboarding with custom resources](#advanced-onboarding-custom-resources).
1. If you selected **User-configured instrumentation per deployment** and the application's exporter uses gRPC, add the protocol annotation described in [Choose the OTLP transport protocol for SDK autoconfiguration](#choose-the-otlp-transport-protocol-for-sdk-autoconfiguration) before restarting it.
1. Leave **Perform rollout restart of all deployments** unchecked. You perform the restart manually in the next step.
1. Select **Configure**.  
  :::image type="content" source="./media/kubernetes-open-protocol/application-configuration-pane.png" lightbox="./media/kubernetes-open-protocol/application-configuration-pane.png" alt-text="A screenshot of the configuration pane for application with resource and language selections.":::

##### 3.3 Restart deployments to apply changes

Complete [Verify receiver readiness before restarting workloads](#verify-receiver-readiness-before-restarting-workloads).

Restart deployments in the target namespace from **Run command** in the portal or from your terminal:

```bash
kubectl rollout restart deployment -n <your-namespace>
```

In **Run command**, make sure **Dry Run** is off, and then select **Send**.

:::image type="content" source="./media/kubernetes-open-protocol/azure-run-command-rollout.png" lightbox="./media/kubernetes-open-protocol/azure-run-command-rollout.png" alt-text="A screenshot of the Azure run command screen showing rollout restart command.":::

##### 3.4 Confirm instrumented status

Return to **Application Monitoring** for the namespace. Expand **Deployments in this namespace** and confirm that deployments show **Instrumented** status.

:::image type="content" source="./media/kubernetes-open-protocol/application-deployments-status.png" lightbox="./media/kubernetes-open-protocol/application-deployments-status.png" alt-text="A screenshot of the Application deployments list showing instrumented status.":::

> [!TIP]
> After a few minutes, telemetry appears in the connected Application Insights resource.

#### [Azure CLI](#tab/azure-cli)

##### Retrieve the required resource values

Retrieve the AKS resource ID and location:

```azurecli
az aks show \
  --subscription "<aks-subscription-name-or-id>" \
  --resource-group <aks-resource-group> \
  --name <aks-name> \
  --query "{resourceId:id, location:location}"
```

Retrieve the Application Insights DCR:

```azurecli
az resource show \
  --subscription "<application-insights-subscription-name-or-id>" \
  --resource-group <application-insights-resource-group> \
  --resource-type Microsoft.Insights/components \
  --name <application-insights-name> \
  --api-version 2020-02-02 \
  --query properties.DataCollectionRuleResourceId \
  --output tsv
```

##### Create the DCR association

Use API version `2025-05-11`. The generic `az resource create --is-full-object` command also requires a location value in its request, so use the AKS cluster location:

```azurecli
az resource create \
  --subscription "<aks-subscription-name-or-id>" \
  --id "<aks-resource-id>/providers/Microsoft.Insights/dataCollectionRuleAssociations/<association-name>" \
  --api-version 2025-05-11 \
  --is-full-object \
  --properties '{
    "location": "<aks-location>",
    "properties": {
      "description": "Associates the Application Insights OTLP data collection rule with the AKS cluster.",
      "dataCollectionRuleId": "<data-collection-rule-resource-id>"
    }
  }'
```

Use a stable association name that's unique on the cluster. Rerunning the command with the same name updates the existing association.

##### Configure the Kubernetes resources

Select the target cluster under an explicit context name:

```azurecli
az aks get-credentials \
  --subscription "<aks-subscription-name-or-id>" \
  --resource-group <aks-resource-group> \
  --name <aks-name> \
  --context <aks-context-name>
```

Retrieve the complete Application Insights connection string:

```azurecli
az resource show \
  --subscription "<application-insights-subscription-name-or-id>" \
  --resource-group <application-insights-resource-group> \
  --resource-type Microsoft.Insights/components \
  --name <application-insights-name> \
  --api-version 2020-02-02 \
  --query properties.ConnectionString \
  --output tsv
```

Download the samples for your onboarding scenario:

- Namespace-wide Java or Node.js autoinstrumentation: [Instrumentation resource](https://github.com/microsoft/Docker-Provider/blob/ci_prod/scripts/onboarding/aks/application-monitoring/kubernetes/instrumentation-codeless.yaml). The sample defaults to Java; replace `Java` with `NodeJs` for a Node.js-only namespace.
- Namespace-wide autoconfiguration for applications already instrumented with OpenTelemetry SDKs: [OTLP Instrumentation resource](https://github.com/microsoft/Docker-Provider/blob/ci_prod/scripts/onboarding/aks/application-monitoring/kubernetes/instrumentation-otlp.yaml).
- Per-deployment onboarding: [named Instrumentation resource](https://github.com/microsoft/Docker-Provider/blob/ci_prod/scripts/onboarding/aks/application-monitoring/kubernetes/instrumentation-per-deployment.yaml). Use the [autoinstrumentation workload examples](https://github.com/microsoft/Docker-Provider/blob/ci_prod/scripts/onboarding/aks/application-monitoring/kubernetes/workload-autoinstrumentation.example.yaml) or [autoconfiguration workload example](https://github.com/microsoft/Docker-Provider/blob/ci_prod/scripts/onboarding/aks/application-monitoring/kubernetes/workload-autoconfiguration.example.yaml) as annotation references for your existing deployment manifests. Copy the appropriate `inject-*` annotation. For SDK autoconfiguration, add the protocol annotation when the application's exporter uses gRPC. The application-log annotation is optional and can duplicate logs collected by Container Insights, which can increase ingestion cost. Don't apply the example deployments as-is.

In the Instrumentation manifest, replace the namespace and connection-string placeholders. The complete connection string must include `ApplicationId`. Don't commit a rendered manifest that contains the connection string.

Apply the Instrumentation resource:

```bash
kubectl --context <aks-context-name> apply -f <instrumentation-file>
```

Complete [Verify receiver readiness before restarting workloads](#verify-receiver-readiness-before-restarting-workloads).

For namespace-wide onboarding, restart all deployments in the namespace.

```bash
kubectl --context <aks-context-name> rollout restart deployment -n <your-namespace>
```

For per-deployment onboarding, apply the annotation changes and restart each affected deployment by name.

```bash
kubectl --context <aks-context-name> rollout restart deployment <deployment-name> -n <your-namespace>
```

#### [Bicep/ARM](#tab/bicep-arm)

##### Download the association template and parameter file

- **Bicep:** [Template](https://github.com/microsoft/Docker-Provider/blob/ci_prod/scripts/onboarding/aks/application-monitoring/bicep/associate-application-insights-dcr.bicep) and [parameter file](https://github.com/microsoft/Docker-Provider/blob/ci_prod/scripts/onboarding/aks/application-monitoring/bicep/associate-application-insights-dcr.parameters.json).
- **ARM:** [Template](https://github.com/microsoft/Docker-Provider/blob/ci_prod/scripts/onboarding/aks/application-monitoring/arm/associate-application-insights-dcr.json) and [parameter file](https://github.com/microsoft/Docker-Provider/blob/ci_prod/scripts/onboarding/aks/application-monitoring/arm/associate-application-insights-dcr.parameters.json).

##### Deploy the association

Edit the matching parameter file. Use the Application Insights resource ID from step 2 or from the resource's **JSON View**:

| Parameter | Description |
| --- | --- |
| `clusterName` | Name of the AKS cluster. |
| `clusterLocation` | Azure region of the AKS cluster. |
| `applicationInsightsResourceId` | Resource ID of the OTLP-enabled Application Insights component. The template resolves its DCR resource ID internally. |
| `associationName` | Optional stable association name. Leave it empty to generate a deterministic name from the Application Insights resource ID. |

Deploy the template and parameter file to the AKS resource group by using any valid Resource Manager deployment method. The deployment identity must be able to read the Application Insights resource, including when it's in another subscription. If an earlier version of this template created the association, set `associationName` to its current name so the deployment updates it instead of creating another association. For examples, see [Deploy the sample templates](../fundamentals/resource-manager-samples.md#deploy-the-sample-templates).

##### Configure the Kubernetes resources

Select the target cluster under an explicit context name:

```azurecli
az aks get-credentials \
  --subscription "<aks-subscription-name-or-id>" \
  --resource-group <aks-resource-group> \
  --name <aks-name> \
  --context <aks-context-name>
```

Retrieve the complete Application Insights connection string:

```azurecli
az resource show \
  --subscription "<application-insights-subscription-name-or-id>" \
  --resource-group <application-insights-resource-group> \
  --resource-type Microsoft.Insights/components \
  --name <application-insights-name> \
  --api-version 2020-02-02 \
  --query properties.ConnectionString \
  --output tsv
```

Download the samples for your onboarding scenario:

- Namespace-wide Java or Node.js autoinstrumentation: [Instrumentation resource](https://github.com/microsoft/Docker-Provider/blob/ci_prod/scripts/onboarding/aks/application-monitoring/kubernetes/instrumentation-codeless.yaml). The sample defaults to Java; replace `Java` with `NodeJs` for a Node.js-only namespace.
- Namespace-wide autoconfiguration for applications already instrumented with OpenTelemetry SDKs: [OTLP Instrumentation resource](https://github.com/microsoft/Docker-Provider/blob/ci_prod/scripts/onboarding/aks/application-monitoring/kubernetes/instrumentation-otlp.yaml).
- Per-deployment onboarding: [named Instrumentation resource](https://github.com/microsoft/Docker-Provider/blob/ci_prod/scripts/onboarding/aks/application-monitoring/kubernetes/instrumentation-per-deployment.yaml). Use the [autoinstrumentation workload examples](https://github.com/microsoft/Docker-Provider/blob/ci_prod/scripts/onboarding/aks/application-monitoring/kubernetes/workload-autoinstrumentation.example.yaml) or [autoconfiguration workload example](https://github.com/microsoft/Docker-Provider/blob/ci_prod/scripts/onboarding/aks/application-monitoring/kubernetes/workload-autoconfiguration.example.yaml) as annotation references for your existing deployment manifests. Copy the appropriate `inject-*` annotation. For SDK autoconfiguration, add the protocol annotation when the application's exporter uses gRPC. The application-log annotation is optional and can duplicate logs collected by Container Insights, which can increase ingestion cost. Don't apply the example deployments as-is.

In the Instrumentation manifest, replace the namespace and connection-string placeholders. The complete connection string must include `ApplicationId`. Don't commit a rendered manifest that contains the connection string.

Apply the Instrumentation resource:

```bash
kubectl --context <aks-context-name> apply -f <instrumentation-file>
```

Complete [Verify receiver readiness before restarting workloads](#verify-receiver-readiness-before-restarting-workloads).

For namespace-wide onboarding, restart all deployments in the namespace.

```bash
kubectl --context <aks-context-name> rollout restart deployment -n <your-namespace>
```

For per-deployment onboarding, apply the annotation changes and restart each affected deployment by name.

```bash
kubectl --context <aks-context-name> rollout restart deployment <deployment-name> -n <your-namespace>
```

---

> [!IMPORTANT]
> Application Insights experiences, including prebuilt dashboards and queries, expect and require OTLP metrics with delta temporality and exponential histogram aggregation.
>
> When you use AKS auto-instrumentation or auto-configuration, Azure Monitor automatically uses environment variables to configure SDKs to export metrics with delta temporality and exponential histograms. You don't need to provide any extra configuration.
>
> For more information, see [Metrics Exporters - OTLP](https://opentelemetry.io/docs/specs/otel/metrics/sdk_exporters/otlp/).


## 4. View application signals in Container Insights

Explore application performance in the context of your cluster by using Container Insights. From **Monitor** in the AKS resource, open **Controllers** and then select a controller. When the application-performance pane is available, it shows request failures, slow operations, and suggested investigations. If the pane instead asks you to enable Application Insights, use the deployment or pod **View in Application Insights** link to open the Application Insights Performance experience.

:::image type="content" source="./media/kubernetes-open-protocol/azure-controller-performance-view.png" lightbox="./media/kubernetes-open-protocol/azure-controller-performance-view.png" alt-text="A screenshot of the controller view showing performance metrics.":::

For Java autoinstrumented workloads, you can also select an application component node in Application Map.

:::image type="content" source="./media/kubernetes-open-protocol/azure-controller-performance-alternate-view.png" lightbox="./media/kubernetes-open-protocol/azure-controller-performance-alternate-view.png" alt-text="A screenshot of the controller view showing failed requests.":::

Select the node and then **Investigate Pods** in the AKS monitoring tile. SDK-autoconfigured components don't currently show this tile. For those components, use their Kubernetes resource attributes to locate the workload in the AKS resource.

## Advanced onboarding (custom resources)

Use the Kubernetes custom resources when you need more control. For more information, see [Per deployment onboarding](kubernetes-codeless.md#per-deployment-onboarding).

### Autoinstrumentation (Java, Node.js)

Follow the **namespace-wide** or **per-deployment** onboarding guidance in the article linked earlier to inject language-specific OpenTelemetry instrumentation into your pods. Java uses the Azure Monitor OpenTelemetry Distro. For manual Node.js instrumentation, use the [Microsoft OpenTelemetry Distro](../app/opentelemetry-enable.md?tabs=nodejs).

> [!NOTE]
> To participate in the limited public preview of Autoinstrumentation for .NET or Python, see [Enable AKS autoinstrumentation for Python and .NET (limited preview)](kubernetes-codeless-python-net.md).

### Autoconfiguration (apps already instrumented with OpenTelemetry SDKs)

Autoconfiguration sets environment variables so existing SDKs export telemetry to Application Insights through the Azure Monitor Agent on the cluster. It doesn't place any SDK on the pod.

> [!IMPORTANT]
> In both examples, replace the sample connection string with the complete `ConnectionString` value from the OTLP-enabled Application Insights resource. The value must include `ApplicationId`, which the webhook uses to set `microsoft.applicationId` for Application Insights DCR routing.

- **Namespace-wide**: Set the **Instrumentation** custom resource with an empty platforms list.
  ```yml
  apiVersion: monitor.azure.com/v1
  kind: Instrumentation
  metadata:
    name: default
    namespace: mynamespace1
  spec:
    settings:
      autoInstrumentationPlatforms: []
    destination: # required
      applicationInsightsConnectionString: "InstrumentationKey=11111111-1111-1111-1111-111111111111;IngestionEndpoint=https://eastus2-3.in.applicationinsights.azure.com/;LiveEndpoint=https://eastus2.livediagnostics.monitor.azure.com/;ApplicationId=22222222-2222-2222-2222-222222222222"
  ```
- **Per-deployment**: Create an **Instrumentation** custom resource with a name other than `default` (for example, `cr1`).
  ```yml
  apiVersion: monitor.azure.com/v1
  kind: Instrumentation
  metadata:
    name: cr1
    namespace: mynamespace1
  spec:
    settings:
      autoInstrumentationPlatforms: []
    destination: # required
      applicationInsightsConnectionString: "InstrumentationKey=11111111-1111-1111-1111-111111111111;IngestionEndpoint=https://eastus2-3.in.applicationinsights.azure.com/;LiveEndpoint=https://eastus2.livediagnostics.monitor.azure.com/;ApplicationId=22222222-2222-2222-2222-222222222222"
  ```

  > [!NOTE]
  > If the named custom resource targets a different OTLP-enabled Application Insights resource than the resource already configured for the cluster, associate the destination resource's DCR with the AKS cluster. Reusing the same resource doesn't require another association. For more information, see [Manage data collection rule associations](../data-collection/data-collection-rule-associations.md).

  Add the annotation to each deployment that should use the custom resource:
  ```yml
  apiVersion: apps/v1
  kind: Deployment
  ...
  spec:
    template:
      metadata:
        annotations:
          instrumentation.opentelemetry.io/inject-configuration: "cr1"
  ```

- **Exclude deployments from a default CR**: When you use namespace-wide onboarding for user-configured instrumentation, a default custom resource is created, the `spec.settings.autoInstrumentationPlatforms` setting is left empty and all deployments are configured to send OTLP data to the connection string defined in `applicationInsightsConnectionString`. Use the annotation value `"false"` to exclude a deployment.
  
  ```yml
  apiVersion: apps/v1
  kind: Deployment
  ...
  spec:
    template:
      metadata:
        annotations:
          instrumentation.opentelemetry.io/inject-configuration: "false"
  ```

## Clean up OTLP resources

Before deleting an OTLP-enabled Application Insights resource or its resource group, delete every AKS association that points to its DCR. Otherwise, deletion of the Application Insights managed resource group can fail and roll back.

List every association from the DCR:

```azurecli
az rest \
  --method get \
  --url "https://management.azure.com<dcr-resource-id>/associations?api-version=2025-05-11" \
  --query "{associationIds:value[].id,nextLink:nextLink}"
```

Delete every resource ID in `associationIds`. If `nextLink` isn't empty, run `az rest --method get --url "<nextLink>"` and process that page too. Continue until no `nextLink` is returned.

```azurecli
az resource delete \
  --ids "<association-resource-id>" \
  --api-version 2025-05-11
```

Repeat the initial association query and verify that `associationIds` is empty before deleting the Application Insights resource or its resource group. If an `ai_*_managed` resource group remains from an earlier failed deletion, run the association query again, and then delete the managed resource group. Its managed Log Analytics workspace can remain soft-deleted during the 14-day recovery period.

## Limitations

The feature is available in all public cloud regions except:

- Israel Central
- Israel North West
- Qatar Central
- UAE North
- UAE Central

If you need programmatic names for these regions, see [Azure regions list](/azure/reliability/regions-list?tabs=all#azure-regions-list-1).

### Limits

- The feature accepts only **OTLP/HTTP** or **OTLP/gRPC** with **binary Protobuf**. It doesn't support JSON payloads. You need to configure your OTLP exporter accordingly when using autoconfiguration with the open-source, vendor-neutral SDKs.

- The feature supports up to **30** Data Collection Rule (DCR) associations per AKS cluster.
- The tested scale for logs and traces is **50,000 events per second (EPS)**. You can expect approximately **250 MiB** extra memory usage and **0.5 vCPU** per cluster for this feature.

### Unsupported scenarios

- Compression in OpenTelemetry SDK exporters.
- Namespaces with **Istio mutual TLS (mTLS)** enabled.
- **HTTPS** endpoints in the instrumentation configuration.

### Scenarios not validated

- AKS clusters that use an HTTP proxy.
- AKS clusters that use Private Link.
- AKS dual-stack clusters.

## Resolve OTLP receiver port conflicts

The OTLP receivers bind host ports on each Linux node. A conflicting DaemonSet, host-networked pod, or other host-port workload can prevent a receiver from starting.

| Receiver | HTTP/Protobuf default | gRPC default |
| --- | --- | --- |
| Logs and traces | `28331` | `28332` |
| Metrics | `28333` | `28334` |

The Azure portal uses the default ports. To select different ports, use Azure CLI, ARM, or Bicep.

When you enable, reenable, or redeploy a receiver that uses custom ports, provide both custom port settings again. Disabling a receiver clears its custom port settings.

### [Azure CLI](#tab/azure-cli-ports)

Update only the receiver that has a conflict. The receiver must already be enabled, or you must include its `--enable-*` option in the same command.

For logs and traces:

```azurecli
az aks update \
  --subscription "<aks-subscription-name-or-id>" \
  --resource-group <aks-resource-group> \
  --name <aks-name> \
  --opentelemetry-logs-traces-port-http <logs-and-traces-http-port> \
  --opentelemetry-logs-traces-port-grpc <logs-and-traces-grpc-port>
```

For metrics:

```azurecli
az aks update \
  --subscription "<aks-subscription-name-or-id>" \
  --resource-group <aks-resource-group> \
  --name <aks-name> \
  --opentelemetry-metrics-port-http <metrics-http-port> \
  --opentelemetry-metrics-port-grpc <metrics-grpc-port>
```

### [Bicep/ARM](#tab/bicep-arm-ports)

Use the application-monitoring profile template and its matching parameter file:

- **Bicep:** [Template](https://github.com/microsoft/Docker-Provider/blob/ci_prod/scripts/onboarding/aks/application-monitoring/bicep/aks-app-monitoring-profile.bicep) and [parameter file](https://github.com/microsoft/Docker-Provider/blob/ci_prod/scripts/onboarding/aks/application-monitoring/bicep/aks-app-monitoring-profile.parameters.json).
- **ARM:** [Template](https://github.com/microsoft/Docker-Provider/blob/ci_prod/scripts/onboarding/aks/application-monitoring/arm/aks-app-monitoring-profile.json) and [parameter file](https://github.com/microsoft/Docker-Provider/blob/ci_prod/scripts/onboarding/aks/application-monitoring/arm/aks-app-monitoring-profile.parameters.json).

Set all three profile booleans to the desired final state. For the receiver that has a conflict, keep its boolean set to `true` and provide both custom port values:

| Receiver | Parameter values |
| --- | --- |
| Logs and traces | `openTelemetryLogsAndTracesEnabled=true` and both `openTelemetryLogsAndTraces*Port` values. |
| Metrics | `openTelemetryMetricsEnabled=true` and both `openTelemetryMetrics*Port` values. |

If the other receiver is enabled with custom ports, also provide both of its port values. Otherwise, that receiver returns to the service defaults.

Deploy the template and parameter file to the AKS resource group by using any valid Resource Manager deployment method. For examples, see [Deploy the sample templates](../fundamentals/resource-manager-samples.md#deploy-the-sample-templates).

---

### Apply the updated ports

Complete [Verify receiver readiness before restarting workloads](#verify-receiver-readiness-before-restarting-workloads), and then restart the affected deployments so the injected exporter endpoints use the new ports:

```bash
kubectl --context <aks-context-name> rollout restart deployment -n <your-namespace>
```

Confirm the resulting AKS profile:

```azurecli
az aks show \
  --subscription "<aks-subscription-name-or-id>" \
  --resource-group <aks-resource-group> \
  --name <aks-name> \
  --query azureMonitorProfile.appMonitoring
```

## Next steps

- Learn how [codeless instrumentation works for Kubernetes and how to onboard deployments](kubernetes-codeless.md#onboard-deployments).
- Review the **Enable monitoring for AKS clusters** article to understand infrastructure monitoring with Azure Monitor.
- Learn to configure application monitoring with Azure Monitor and OTLP for [other environments](https://aka.ms/otelignitedoc) with the Azure Monitor Agent or the open-source OpenTelemetry Collector.

## Support

If documentation and the steps in this article don't resolve your issue or you want to provide feedback, email the Azure Monitor OpenTelemetry team at [otel@microsoft.com](mailto:otel@microsoft.com).
