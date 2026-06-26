---
ms.service: azure-service-health
title: Azure Service Health Planned Maintenance and Service Health
author: Jo Calland
ms.author: Jo Calland
ms.date: 06/26/2026
ms.topic: include
---


#### Confirmed impacted resources for planned maintenance

**Overview**
This document explains how to use Azure Resource Graph (ARG) queries to correlate **Planned Maintenance** with **Azure Service Health** data. Together, they identify impacted resources, determine the maintenance status, and specify if any action is required.

---

### Query 1 – Maintenance updates and impacted resources

#### Purpose
This query identifies all resources associated with a specific **Planned Maintenance notification ID**.

### Data sources
- `maintenanceresources` (`microsoft.maintenance/updates`)
- `servicehealthresources` (`microsoft.resourcehealth/events/impactedresources`)


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

---

### Query 2 – Service Health event to resource resolution

### Purpose
Starting from a **Service Health event**, determine the exact **hosts**, **VMs**, or **VMSS instances** under maintenance, and determine if a **customer remediation** (Maintenance Extension) is required.

### Data sources
- `servicehealthresources` (`events` and `impactedresources`)
- `maintenanceresources` (`microsoft.maintenance/updates`)
<!--
### Key logic explained
1. **Event to maintenance mapping**
   - Extracts `ExternalIncidentId` from Service Health events.
   - Uses it as `plannedMaintenanceID`.

1. **Maintenance join**
   - Joins with host-scoped maintenance updates.
   - Extracts the maintenance status and the end time.

1. **Resource classification**
   - Detects Host vs VM vs VMSS instance through resource ID parsing.
   - Generates user-friendly resource names.

1. **Actionability logic**
   - Determines whether the Maintenance extension is required.
   - Suppresses the extension or blade when maintenance is already complete, or in progress.

1. **Union with impacted resources**
   - Ensures visibility even when maintenance metadata is missing. -->

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
