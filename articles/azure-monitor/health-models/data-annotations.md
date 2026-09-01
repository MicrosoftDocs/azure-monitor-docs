---
title: Add data annotations to Azure Monitor health models (preview)
description: Learn how to add, retrieve, and view data annotations that correlate operational events with entity health in Azure Monitor health models.
ms.topic: how-to
ms.reviewer: megangoode
ms.date: 08/21/2026
ai-usage: ai-assisted

#customer intent: As an operator, I want to add context to an entity's health history so that I can correlate health changes with deployments and other operational events.
---

# Add data annotations to Azure Monitor health models (preview)

Data annotations attach point-in-time context to an entity in Azure Monitor health models (preview). Use an annotation to correlate an entity's health history with a deployment, configuration change, incident, or other operational event.

## Prerequisites

- An Azure Monitor health model that contains at least one entity.
- At least the **Monitoring Contributor** role on the health model.
- The [Azure CLI](/cli/azure/install-azure-cli).

## Install the health-models extension

Install or update the `health-models` Azure CLI extension.

```azurecli
az extension add --name health-models --upgrade
```

## Add a data annotation

Add an annotation that identifies a client release. Replace the placeholder values with the names of your resource group, health model, and entity.

The `annotation-details` argument supports up to 10 key-value pairs per annotation. Each value supports up to 256 characters.

# [Azure CLI (Bash)](#tab/azure-cli-bash)

```azurecli
az monitor health-models entity add-data-annotation \
  --resource-group "<resource-group-name>" \
  --health-model-name "<health-model-name>" \
  --entity-name "<entity-name>" \
  --annotation-details "{event:'new-client-release',version:'1.2.3'}" \
  --description "Client version 1.2.3 has been released" \
  --query "{timestamp:createdAt,description:description}" \
  --output table
```

# [Azure CLI (PowerShell)](#tab/azure-cli-powershell)

```azurepowershell
az monitor health-models entity add-data-annotation `
  --resource-group "<resource-group-name>" `
  --health-model-name "<health-model-name>" `
  --entity-name "<entity-name>" `
  --annotation-details "{event:'new-client-release',version:'1.2.3'}" `
  --description "Client version 1.2.3 has been released" `
  --query "{timestamp:createdAt,description:description}" `
  --output table
```

---

The command returns the annotation timestamp and description.

```output
Timestamp                          Description
---------------------------------  ------------------------------------------
2026-07-30T08:00:00.0000000+00:00  Client version 1.2.3 has been released
```

## Retrieve data annotations

List the annotations recorded for the entity to confirm the new entry. By default, the command returns annotations from the previous 24 hours.

# [Azure CLI (Bash)](#tab/azure-cli-bash)

```azurecli
az monitor health-models entity get-data-annotations \
  --resource-group "<resource-group-name>" \
  --health-model-name "<health-model-name>" \
  --entity-name "<entity-name>" \
  --query "annotations[].{timestamp:createdAt,description:description}" \
  --output table
```

# [Azure CLI (PowerShell)](#tab/azure-cli-powershell)

```azurepowershell
az monitor health-models entity get-data-annotations `
  --resource-group "<resource-group-name>" `
  --health-model-name "<health-model-name>" `
  --entity-name "<entity-name>" `
  --query "annotations[].{timestamp:createdAt,description:description}" `
  --output table
```

---

## View data annotations in the Azure portal

1. In the [Azure portal](https://portal.azure.com), open your health model.
1. Under **Health**, select **Graph**.
1. Select the entity whose annotations you want to view.
1. Select the **Data annotations** tab.

Annotations also appear as markers on the [model timeline](./analyze-health.md#data-annotations) and the timeline in entity details. Hover over a marker to view the annotation details.

## Related content

- [Analyze health state in Azure Monitor health models](./analyze-health.md)
- [Use the Azure CLI with Azure Monitor health models](./cli.md)