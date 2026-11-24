---
title: Azure Monitor pipeline versions and upgrades
description: Manage Azure Monitor pipeline extension versions and plan upgrades for DCR-based and legacy deployments.
ai-usage: ai-assisted
ms.topic: concept-article
ms.date: 11/23/2026
---

# Azure Monitor pipeline versions and upgrades

Version and upgrade behavior depends on the pipeline deployment model and hosting platform.

## DCR-based Arc-enabled Kubernetes deployment

Install the `microsoft.monitor.pipeline` extension version documented in the [DCR-based deployment guide](./pipeline-configure-cli.md). When you pin a version, use `--auto-upgrade-mode none`.

Check the installed version and release train:

```azurecli
az k8s-extension show \
  --name <extension-name> \
  --cluster-name <cluster-name> \
  --resource-group <cluster-resource-group> \
  --cluster-type connectedClusters \
  --query "{installedVersion:currentVersion,releaseTrain:releaseTrain,provisioningState:provisioningState}"
```

Review extension settings, DCR compatibility, persistent buffers, and certificate behavior before changing versions. Validate configuration and telemetry delivery after an upgrade.

## Linux VM or Arc-enabled Linux server

Follow the version requirements and upgrade guidance in [Configure Azure Monitor pipeline on Linux VMs](./pipeline-configure-vm.md).

## Legacy PipelineGroup deployment

For existing deployments that use the `microsoft.monitor.pipelinecontroller` extension, see [Legacy Azure Monitor pipeline extension versions](./pipeline-extension-versions.md). Don't use legacy version guidance for a DCR-based `microsoft.monitor.pipeline` deployment.
