---
title: Sample queries for Azure Service Health Impacted resources
description: Azure Resource Graph sample queries for Impacted resources showing the use of resource types and tables to access Azure Service Health related Impacted resources.
ms.date: 05/27/2026
ms.topic: sample
ms.custom: subject-resourcegraph-sample, devx-track-azurepowershell, devx-track-azurecli
---

# Sample queries for Azure Service Health Impacted resources - Azure Service Health | Microsoft Learn

This page is a collection of [Azure Resource Graph](/en-us/azure/governance/resource-graph/overview) sample queries for Azure Service Health Impacted resources.

>[!Note]
>After each query, you should see the updated results within 5 minutes in general.

## Overview

This page helps you monitor and understand the health of your Azure services and resources using Kusto Query Language (KQL) through Azure Resource Graph.

It includes sample queries specifically for Azure Service Health.

## Impacted resource sample queries

[!INCLUDE [azure-service-health-impacted-resources](includes/azure-service-health-impacted-resources.md)]

#### Confirmed impacted resources for planned maintenance

**Overview** This document explains how to use Azure Resource Graph (ARG) queries to correlate **Planned Maintenance** with **Azure Service Health** data. Together, they identify impacted resources, determine the maintenance status and if any action is required.

### Query 1 – Maintenance updates and impacted resources

#### Purpose

This query identifies all resources associated with a specific **Planned Maintenance notification ID**.

### Data sources

- `maintenanceresources` (`microsoft.maintenance/updates`)
- `servicehealthresources` (`microsoft.resourcehealth/events/impactedresources`)

### Key logic explained

1. **Maintenance updates path**

    - Parses the `properties` payload and expands `value[]`.
    - Filters by `notificationId` and `subscriptionId`.
    - Extracts resource ID, group, type, and maintenance status.
2. **Service Health impacted resources path**

    - Filters the impacted resources referencing the same notification ID.
    - Extracts the target resource metadata from `properties.targetResourceId`.
3. **Union**

    - Merges both datasets into a unified resource-level view.

### Output

A consolidated list of impacted resources with their maintenance status.

```kusto
maintenanceresources
| where type == 'microsoft.maintenance/updates'
| extend p = parse_json(properties)
| mv-expand d = p.value
| where tostring(d.notificationId) == 'PYN_-ZL8'
| extend
    targetResourceId = tolower(name),
    plannedMaintenanceId = tostring(d.notificationId),
    status = tostring(d.status),
    resourceGroup = tostring(
        split(split(id, '/resourceGroups/')[1], '/')[0]
    ),
    resourceType = strcat(
        tostring(split(split(id, '/providers/')[1], '/')[0]),
        '/',
        tostring(split(split(id, '/providers/')[1], '/')[1])
    )
| project targetResourceId, subscriptionId, resourceGroup, resourceType, plannedMaintenanceId, status, source = 'Maintenance'
| union (
servicehealthresources
| where type =~ 'microsoft.resourcehealth/events/impactedresources'
| where id contains 'PYN_-ZL8'
| extend p = parse_json(properties)
| extend
    targetResourceId = tolower(tostring(p.targetResourceId)),
    status = tostring(p.status),
    resourceGroup = tostring(split(split(tostring(p.targetResourceId), '/resourceGroups/')[1], '/')[0]),
    resourceType = strcat(
        tostring(split(split(tostring(p.targetResourceId), '/providers/')[1], '/')[0]),
        '/',
        tostring(split(split(tostring(p.targetResourceId), '/providers/')[1], '/')[1])
    )
| project targetResourceId, subscriptionId, resourceGroup, resourceType, status
)
| project subscriptionId, targetResourceId, resourceGroup, resourceType, plannedMaintenanceId, status

```

### Query 2 – Service Health event to resource resolution

### Purpose

Starting from a **Service Health event**, determine the exact **hosts**, **VMs**, or **VMSS instances** under maintenance, and determine if a **customer remediation** (Maintenance Extension) is required.

### Data sources

- `servicehealthresources` (`events` and `impactedresources`)
- `maintenanceresources` (`microsoft.maintenance/updates`)

### Output

A resource-resolved view indicating the maintenance state, and the required user action.

```kusto
servicehealthresources
| where type =~ 'microsoft.resourcehealth/events'
| where name contains '1J14-8LG'
| project plannedMaintenanceID = tostring(properties.ExternalIncidentId)
| join kind=inner (
maintenanceresources
| where ['type'] == 'microsoft.maintenance/updates'
| extend prop = parse_json(properties)
| mv-expand Value = prop.value
| where tostring(Value.maintenanceScope) == 'Host'
| extend plannedMaintenanceID = tostring(Value.properties.plannedMaintenanceId)
| extend name = tolower(name)
| extend controlledMaintenanceEndTime = tostring(Value.endTimeUtc)
| extend status = tostring(Value.properties.plannedMaintenanceStatus)
| extend isVmssInstance = name has '/virtualmachinescalesets/'
| extend isHost = name has '/hostgroups/hosts/'
| extend vmssName = extract(@'/virtualmachinescalesets/([^/]+)/', 1, name)
| extend vmssInstance = extract(@'/virtualmachines/([^/]+)$', 1, name)
| extend vmName = extract(@'/virtualmachines/([^/]+)$', 1, name)
| extend hostName = extract(@'/hosts/([^/]+)$', 1, name)
| extend targetResourceName =
    iff(isHost, hostName,
        iff(isVmssInstance, strcat(vmssName, '_', vmssInstance), vmName))
| extend targetResourceType =
    iff(isVmssInstance,
        'microsoft.compute/virtualmachinescalesets/virtualmachines',
        iff(isHost,
            'microsoft.compute/hostgroups/hosts',
            'microsoft.compute/virtualmachines'))
| extend needsMaintenanceExtension =
    not(status in ('InProgress', 'RetryLater', 'NoUpdatesPending', 'Completed'))
| extend targetExtensionName =
    iff(needsMaintenanceExtension, 'Microsoft_Azure_Maintenance', '')
| extend targetBladeName =
    iff(needsMaintenanceExtension, 'PlannedMaintenance.ReactView', '')
| extend targetParameters =
    iff(needsMaintenanceExtension,
        strcat('{\"id\":\"', name, '\"}'),
        '')
) on plannedMaintenanceID
| project
    targetResourceId = name,
    targetResourceType,
    targetRegion = location,
    targetResourceGroup = resourceGroup,
    subscriptionId,
    plannedMaintenanceID,
    targetResourceName ,
    controlledMaintenanceEndTime,
    status,
    targetExtensionName =
        iff(
            status in ('InProgress','RetryLater','NoUpdatesPending','Completed'),
            '',
            'Microsoft_Azure_Maintenance'
        ),
    targetBladeName =
        iff(
            status in ('InProgress','RetryLater','NoUpdatesPending','Completed'),
            '',
            'PlannedMaintenance.ReactView'
        ),
    targetParameters =
        iff(
            status in ('InProgress','RetryLater','NoUpdatesPending','Completed'),
            '',
            targetParameters
        )
| union (
    servicehealthresources
    | where type =~ 'microsoft.resourcehealth/events/impactedresources'
    | where id contains '1J14-8LG'
    | extend p = parse_json(properties)
    | project  targetResourceId = tostring(p.targetResourceId),targetResourceType = tostring(p.targetResourceType), targetResourceName=tostring(p.resourceName),targetRegion=tostring(p.targetRegion), subscriptionId)
| project targetResourceId, targetResourceType, targetResourceName, targetRegion,subscriptionId,plannedMaintenanceID,status

```

#### Confirmed impacted resources for other event types

This query finds and returns a list of all impacted resources affected by service issues (outages) and Service Health events across all subscriptions you access.

```kusto
ServiceHealthResources
| where type == "microsoft.resourcehealth/events/impactedresources"
| extend TrackingId = split(split(id, "/events/", 1)[0], "/impactedResources", 0)[0]
| extend p = parse_json(properties)
| project subscriptionId, TrackingId, resourceName= p.resourceName, resourceGroup=p.resourceGroup, resourceType=p.targetResourceType, details = p, id
```

# [Azure CLI](#tab/azure-cli)
```azurecli
az graph query -q "ServiceHealthResources | where type == 'microsoft.resourcehealth/events/impactedresources' | extend TrackingId = split(split(id, '/events/', 1)[0], '/impactedResources', 0)[0] | extend p = parse_json(properties) | project subscriptionId, TrackingId, resourceName= p.resourceName, resourceGroup=p.resourceGroup, resourceType=p.targetResourceType, details = p, id"
```

# [Azure PowerShell](#tab/azure-powershell)
```azurepowershell
Search-AzGraph -Query "ServiceHealthResources | where type == 'microsoft.resourcehealth/events/impactedresources' | extend TrackingId = split(split(id, '/events/', 1)[0], '/impactedResources', 0)[0] | extend p = parse_json(properties) | project subscriptionId, TrackingId, resourceName= p.resourceName, resourceGroup=p.resourceGroup, resourceType=p.targetResourceType, details = p, id"
```

# [Portal](#tab/azure-portal)
- Azure portal: [portal.azure.com](https://portal.azure.com/?feature.customportal=false#blade/HubsExtension/ArgQueryBlade/query/ServiceHealthResources%0a%7c%20where%20type%20%3d%3d%20%27microsoft.resourcehealth%2fevents%2fimpactedresources%27%0a%7c%20extend%20TrackingId%20%3d%20split%28split%28id%2c%20%27%2fevents%2f%27%2c%201%29%5b0%5d%2c%20%27%2fimpactedResources%27%2c%200%29%5b0%5d%0a%7c%20extend%20p%20%3d%20parse_json%28properties%29%0a%7c%20project%20subscriptionId%2c%20TrackingId%2c%20resourceName%3d%20p.resourceName%2c%20resourceGroup%3dp.resourceGroup%2c%20resourceType%3dp.targetResourceType%2c%20details%20%3d%20p%2c%20id)
- Azure Government portal: [portal.azure.us](https://portal.azure.us/?feature.customportal=false#blade/HubsExtension/ArgQueryBlade/query/ServiceHealthResources%0a%7c%20where%20type%20%3d%3d%20%27microsoft.resourcehealth%2fevents%2fimpactedresources%27%0a%7c%20extend%20TrackingId%20%3d%20split%28split%28id%2c%20%27%2fevents%2f%27%2c%201%29%5b0%5d%2c%20%27%2fimpactedResources%27%2c%200%29%5b0%5d%0a%7c%20extend%20p%20%3d%20parse_json%28properties%29%0a%7c%20project%20subscriptionId%2c%20TrackingId%2c%20resourceName%3d%20p.resourceName%2c%20resourceGroup%3dp.resourceGroup%2c%20resourceType%3dp.targetResourceType%2c%20details%20%3d%20p%2c%20id)
- Azure operated by 21Vianet portal: [portal.azure.cn](https://portal.azure.cn/?feature.customportal=false#blade/HubsExtension/ArgQueryBlade/query/ServiceHealthResources%0a%7c%20where%20type%20%3d%3d%20%27microsoft.resourcehealth%2fevents%2fimpactedresources%27%0a%7c%20extend%20TrackingId%20%3d%20split%28split%28id%2c%20%27%2fevents%2f%27%2c%201%29%5b0%5d%2c%20%27%2fimpactedResources%27%2c%200%29%5b0%5d%0a%7c%20extend%20p%20%3d%20parse_json%28properties%29%0a%7c%20project%20subscriptionId%2c%20TrackingId%2c%20resourceName%3d%20p.resourceName%2c%20resourceGroup%3dp.resourceGroup%2c%20resourceType%3dp.targetResourceType%2c%20details%20%3d%20p%2c%20id)

---

#### Confirmed impacted resources with more details

This query retrieves all resources affected by Service Health issues such as outages, across all the subscriptions you have access to. It also includes extra details from the `resources` table.

```kusto
servicehealthresources
| where type == "microsoft.resourcehealth/events/impactedresources"
| extend TrackingId = split(split(id, "/events/", 1)[0], "/impactedResources", 0)[0]
| extend p = parse_json(properties)
| project subscriptionId, TrackingId, targetResourceId= tostring(p.targetResourceId), details = p
| join kind=inner (
    resources
    )
    on $left.targetResourceId == $right.id
```

# [Azure CLI](#tab/azure-cli)
```azurecli
az graph query -q "ServiceHealthResources | where type == 'microsoft.resourcehealth/events/impactedresources' | extend TrackingId = split(split(id, '/events/', 1)[0], '/impactedResources', 0)[0] | extend p =  parse_json(properties) | project subscriptionId, TrackingId, targetResourceId = tostring(p.targetResourceId), details = p | join kind=inner (resources) on $left.targetResourceId == $right.id"
```

# [Azure PowerShell](#tab/azure-powershell)
```azurepowershell
Search-AzGraph -Query "ServiceHealthResources | where type == 'microsoft.resourcehealth/events/impactedresources' | extend TrackingId = split(split(id, '/events/', 1)[0], '/impactedResources', 0)[0] | extend p =  parse_json(properties) | project subscriptionId, TrackingId, targetResourceId = tostring(p.targetResourceId), details = p | join kind=inner (resources) on $left.targetResourceId == $right.id"
```

# [Portal](#tab/azure-portal)
- Azure portal: [portal.azure.com](https://portal.azure.com/?feature.customportal=false#blade/HubsExtension/ArgQueryBlade/query/ServiceHealthResources%0a%7c%20where%20type%20%3d%3d%20%27microsoft.resourcehealth%2fevents%2fimpactedresources%27%0a%7c%20extend%20TrackingId%20%3d%20split%28split%28id%2c%20%27%2fevents%2f%27%2c%201%29%5b0%5d%2c%20%27%2fimpactedResources%27%2c%200%29%5b0%5d%0a%7c%20extend%20p%20%3d%20%20parse_json%28properties%29%0a%7c%20project%20subscriptionId%2c%20TrackingId%2c%20targetResourceId%20%3d%20tostring%28p.targetResourceId%29%2c%20details%20%3d%20p%0a%7c%20join%20kind%3dinner%20%28%0a%09resources%0a%09%29%0a%09on%20%24left.targetResourceId%20%3d%3d%20%24right.id)
- Azure Government portal: [portal.azure.us](https://portal.azure.us/?feature.customportal=false#blade/HubsExtension/ArgQueryBlade/query/ServiceHealthResources%0a%7c%20where%20type%20%3d%3d%20%27microsoft.resourcehealth%2fevents%2fimpactedresources%27%0a%7c%20extend%20TrackingId%20%3d%20split%28split%28id%2c%20%27%2fevents%2f%27%2c%201%29%5b0%5d%2c%20%27%2fimpactedResources%27%2c%200%29%5b0%5d%0a%7c%20extend%20p%20%3d%20%20parse_json%28properties%29%0a%7c%20project%20subscriptionId%2c%20TrackingId%2c%20targetResourceId%20%3d%20tostring%28p.targetResourceId%29%2c%20details%20%3d%20p%0a%7c%20join%20kind%3dinner%20%28%0a%09resources%0a%09%29%0a%09on%20%24left.targetResourceId%20%3d%3d%20%24right.id)
- Azure operated by 21Vianet portal: [portal.azure.cn](https://portal.azure.cn/?feature.customportal=false#blade/HubsExtension/ArgQueryBlade/query/ServiceHealthResources%0a%7c%20where%20type%20%3d%3d%20%27microsoft.resourcehealth%2fevents%2fimpactedresources%27%0a%7c%20extend%20TrackingId%20%3d%20split%28split%28id%2c%20%27%2fevents%2f%27%2c%201%29%5b0%5d%2c%20%27%2fimpactedResources%27%2c%200%29%5b0%5d%0a%7c%20extend%20p%20%3d%20%20parse_json%28properties%29%0a%7c%20project%20subscriptionId%2c%20TrackingId%2c%20targetResourceId%20%3d%20tostring%28p.targetResourceId%29%2c%20details%20%3d%20p%0a%7c%20join%20kind%3dinner%20%28%0a%09resources%0a%09%29%0a%09on%20%24left.targetResourceId%20%3d%3d%20%24right.id)
