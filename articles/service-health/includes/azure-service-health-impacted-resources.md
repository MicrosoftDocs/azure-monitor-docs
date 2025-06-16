---
ms.service: azure-service-health
ms.topic: include
ms.date: 6/16/2025
---

#### Confirmed impacted resources

This query finds and returns a list of all impacted resources affected by service issues (outages) and Service Health events across all subscriptions you access.

```kusto
ServiceHealthResources
| where type == "microsoft.resourcehealth/events/impactedresources"
| extend TrackingId = split(split(id, "/events/", 1)[0], "/impactedResources", 0)[0]
| extend p = parse_json(properties)
| project subscriptionId, TrackingId, resourceName= p.resourceName, resourceGroup=p.resourceGroup, resourceType=p.targetResourceType, details = p, id
```

# [Azure CLI](#tab/azure-cli)

```azurecli-interactive
az graph query -q "ServiceHealthResources | where type == 'microsoft.resourcehealth/events/impactedresources' | extend TrackingId = split(split(id, '/events/', 1)[0], '/impactedResources', 0)[0] | extend p = parse_json(properties) | project subscriptionId, TrackingId, resourceName= p.resourceName, resourceGroup=p.resourceGroup, resourceType=p.targetResourceType, details = p, id"
```

# [Azure PowerShell](#tab/azure-powershell)

```azurepowershell-interactive
Search-AzGraph -Query "ServiceHealthResources | where type == 'microsoft.resourcehealth/events/impactedresources' | extend TrackingId = split(split(id, '/events/', 1)[0], '/impactedResources', 0)[0] | extend p = parse_json(properties) | project subscriptionId, TrackingId, resourceName= p.resourceName, resourceGroup=p.resourceGroup, resourceType=p.targetResourceType, details = p, id"
```

# [Portal](#tab/azure-portal)

- Azure portal: <a href="https://portal.azure.com/?feature.customportal=false#blade/HubsExtension/ArgQueryBlade/query/ServiceHealthResources%0a%7c%20where%20type%20%3d%3d%20%27microsoft.resourcehealth%2fevents%2fimpactedresources%27%0a%7c%20extend%20TrackingId%20%3d%20split(split(id%2c%20%27%2fevents%2f%27%2c%201)%5b0%5d%2c%20%27%2fimpactedResources%27%2c%200)%5b0%5d%0a%7c%20extend%20p%20%3d%20parse_json(properties)%0a%7c%20project%20subscriptionId%2c%20TrackingId%2c%20resourceName%3d%20p.resourceName%2c%20resourceGroup%3dp.resourceGroup%2c%20resourceType%3dp.targetResourceType%2c%20details%20%3d%20p%2c%20id" target="_blank">portal.azure.com</a>
- Azure Government portal: <a href="https://portal.azure.us/?feature.customportal=false#blade/HubsExtension/ArgQueryBlade/query/ServiceHealthResources%0a%7c%20where%20type%20%3d%3d%20%27microsoft.resourcehealth%2fevents%2fimpactedresources%27%0a%7c%20extend%20TrackingId%20%3d%20split(split(id%2c%20%27%2fevents%2f%27%2c%201)%5b0%5d%2c%20%27%2fimpactedResources%27%2c%200)%5b0%5d%0a%7c%20extend%20p%20%3d%20parse_json(properties)%0a%7c%20project%20subscriptionId%2c%20TrackingId%2c%20resourceName%3d%20p.resourceName%2c%20resourceGroup%3dp.resourceGroup%2c%20resourceType%3dp.targetResourceType%2c%20details%20%3d%20p%2c%20id" target="_blank">portal.azure.us</a>
- Azure operated by 21Vianet portal: <a href="https://portal.azure.cn/?feature.customportal=false#blade/HubsExtension/ArgQueryBlade/query/ServiceHealthResources%0a%7c%20where%20type%20%3d%3d%20%27microsoft.resourcehealth%2fevents%2fimpactedresources%27%0a%7c%20extend%20TrackingId%20%3d%20split(split(id%2c%20%27%2fevents%2f%27%2c%201)%5b0%5d%2c%20%27%2fimpactedResources%27%2c%200)%5b0%5d%0a%7c%20extend%20p%20%3d%20parse_json(properties)%0a%7c%20project%20subscriptionId%2c%20TrackingId%2c%20resourceName%3d%20p.resourceName%2c%20resourceGroup%3dp.resourceGroup%2c%20resourceType%3dp.targetResourceType%2c%20details%20%3d%20p%2c%20id" target="_blank">portal.azure.cn</a>

---

#### Confirmed impacted resources with more details

This query retrieves all resources affected by Service Health issues (such as outages) across all the subscriptions you have access to. It also includes extra details from the `resources` table.


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

```azurecli-interactive
az graph query -q "ServiceHealthResources | where type == 'microsoft.resourcehealth/events/impactedresources' | extend TrackingId = split(split(id, '/events/', 1)[0], '/impactedResources', 0)[0] | extend p =  parse_json(properties) | project subscriptionId, TrackingId, targetResourceId = tostring(p.targetResourceId), details = p | join kind=inner (resources) on $left.targetResourceId == $right.id"
```

# [Azure PowerShell](#tab/azure-powershell)

```azurepowershell-interactive
Search-AzGraph -Query "ServiceHealthResources | where type == 'microsoft.resourcehealth/events/impactedresources' | extend TrackingId = split(split(id, '/events/', 1)[0], '/impactedResources', 0)[0] | extend p =  parse_json(properties) | project subscriptionId, TrackingId, targetResourceId = tostring(p.targetResourceId), details = p | join kind=inner (resources) on $left.targetResourceId == $right.id"
```

# [Portal](#tab/azure-portal)

- Azure portal: <a href="https://portal.azure.com/?feature.customportal=false#blade/HubsExtension/ArgQueryBlade/query/ServiceHealthResources%0a%7c%20where%20type%20%3d%3d%20%27microsoft.resourcehealth%2fevents%2fimpactedresources%27%0a%7c%20extend%20TrackingId%20%3d%20split(split(id%2c%20%27%2fevents%2f%27%2c%201)%5b0%5d%2c%20%27%2fimpactedResources%27%2c%200)%5b0%5d%0a%7c%20extend%20p%20%3d%20%20parse_json(properties)%0a%7c%20project%20subscriptionId%2c%20TrackingId%2c%20targetResourceId%20%3d%20tostring(p.targetResourceId)%2c%20details%20%3d%20p%0a%7c%20join%20kind%3dinner%20(%0a%09resources%0a%09)%0a%09on%20%24left.targetResourceId%20%3d%3d%20%24right.id" target="_blank">portal.azure.com</a>
- Azure Government portal: <a href="https://portal.azure.us/?feature.customportal=false#blade/HubsExtension/ArgQueryBlade/query/ServiceHealthResources%0a%7c%20where%20type%20%3d%3d%20%27microsoft.resourcehealth%2fevents%2fimpactedresources%27%0a%7c%20extend%20TrackingId%20%3d%20split(split(id%2c%20%27%2fevents%2f%27%2c%201)%5b0%5d%2c%20%27%2fimpactedResources%27%2c%200)%5b0%5d%0a%7c%20extend%20p%20%3d%20%20parse_json(properties)%0a%7c%20project%20subscriptionId%2c%20TrackingId%2c%20targetResourceId%20%3d%20tostring(p.targetResourceId)%2c%20details%20%3d%20p%0a%7c%20join%20kind%3dinner%20(%0a%09resources%0a%09)%0a%09on%20%24left.targetResourceId%20%3d%3d%20%24right.id" target="_blank">portal.azure.us</a>
- Azure operated by 21Vianet portal: <a href="https://portal.azure.cn/?feature.customportal=false#blade/HubsExtension/ArgQueryBlade/query/ServiceHealthResources%0a%7c%20where%20type%20%3d%3d%20%27microsoft.resourcehealth%2fevents%2fimpactedresources%27%0a%7c%20extend%20TrackingId%20%3d%20split(split(id%2c%20%27%2fevents%2f%27%2c%201)%5b0%5d%2c%20%27%2fimpactedResources%27%2c%200)%5b0%5d%0a%7c%20extend%20p%20%3d%20%20parse_json(properties)%0a%7c%20project%20subscriptionId%2c%20TrackingId%2c%20targetResourceId%20%3d%20tostring(p.targetResourceId)%2c%20details%20%3d%20p%0a%7c%20join%20kind%3dinner%20(%0a%09resources%0a%09)%0a%09on%20%24left.targetResourceId%20%3d%3d%20%24right.id" target="_blank">portal.azure.cn</a>

---
