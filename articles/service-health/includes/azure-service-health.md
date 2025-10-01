---
ms.service: azure-service-health
ms.custom: devx-track-azurepowershell
ms.topic: include
ms.date: 10/01/2025
---

#### Active Service Health events by subscription 

This query shows all active Service Health events—such as service issues, planned maintenance, health advisories, and security advisories, grouped by event type and includes a count of the impacted services.

An example would show each event type including a count showing how many subscriptions affected by it.

>[!NOTE]
>Emerging issues aren't tied to subscription IDs and as a result can't be queried via ARG, which is subscription ID based. For more information, open [this page](/rest/api/resourcehealth/emerging-issues).


```kusto
ServiceHealthResources
| where type =~ 'Microsoft.ResourceHealth/events'
| extend eventType = tostring(properties.EventType), status = properties.Status, description = properties.Title, trackingId = properties.TrackingId, summary = properties.Summary, priority = properties.Priority, impactStartTime = properties.ImpactStartTime, impactMitigationTime = properties.ImpactMitigationTime
| where eventType == 'ServiceIssue' and status == 'Active'
| summarize count(subscriptionId) by name
```

# [Azure CLI](#tab/azure-cli)

```azurecli-interactive
az graph query -q "ServiceHealthResources | where type =~ 'Microsoft.ResourceHealth/events' | extend eventType = tostring(properties.EventType), status = properties.Status, description = properties.Title, trackingId = properties.TrackingId, summary = properties.Summary, priority = properties.Priority, impactStartTime = properties.ImpactStartTime, impactMitigationTime = properties.ImpactMitigationTime | where eventType == 'ServiceIssue' and status == 'Active' | summarize count(subscriptionId) by name"
```

# [Azure PowerShell](#tab/azure-powershell)

```azurepowershell-interactive
Search-AzGraph -Query "ServiceHealthResources | where type =~ 'Microsoft.ResourceHealth/events' | extend eventType = tostring(properties.EventType), status = properties.Status, description = properties.Title, trackingId = properties.TrackingId, summary = properties.Summary, priority = properties.Priority, impactStartTime = properties.ImpactStartTime, impactMitigationTime = properties.ImpactMitigationTime | where eventType == 'ServiceIssue' and status == 'Active' | summarize count(subscriptionId) by name"
```

# [Portal](#tab/azure-portal)

- Azure portal: <a href="https://portal.azure.com/#blade/HubsExtension/ArgQueryBlade/query/ServiceHealthResources%0D%0A%7C%20where%20type%20%3D~%20%27Microsoft.ResourceHealth%2Fevents%27%0D%0A%7C%20extend%20eventType%20%3D%20tostring%28properties.EventType%29%2C%20status%20%3D%20properties.Status%2C%20description%20%3D%20properties.Title%2C%20trackingId%20%3D%20properties.TrackingId%2C%20summary%20%3D%20properties.Summary%2C%20priority%20%3D%20properties.Priority%2C%20impactStartTime%20%3D%20properties.ImpactStartTime%2C%20impactMitigationTime%20%3D%20properties.ImpactMitigationTime%0D%0A%7C%20where%20eventType%20%3D%3D%20%27ServiceIssue%27%20and%20status%20%3D%3D%20%27Active%27%0D%0A%7C%20summarize%20count%28subscriptionId%29%20by%20name" target="_blank">portal.azure.com</a>
- Azure Government portal: <a href="https://portal.azure.us/#blade/HubsExtension/ArgQueryBlade/query/ServiceHealthResources%0D%0A%7C%20where%20type%20%3D~%20%27Microsoft.ResourceHealth%2Fevents%27%0D%0A%7C%20extend%20eventType%20%3D%20tostring%28properties.EventType%29%2C%20status%20%3D%20properties.Status%2C%20description%20%3D%20properties.Title%2C%20trackingId%20%3D%20properties.TrackingId%2C%20summary%20%3D%20properties.Summary%2C%20priority%20%3D%20properties.Priority%2C%20impactStartTime%20%3D%20properties.ImpactStartTime%2C%20impactMitigationTime%20%3D%20properties.ImpactMitigationTime%0D%0A%7C%20where%20eventType%20%3D%3D%20%27ServiceIssue%27%20and%20status%20%3D%3D%20%27Active%27%0D%0A%7C%20summarize%20count%28subscriptionId%29%20by%20name" target="_blank">portal.azure.us</a>
- Microsoft Azure operated by 21Vianet portal: <a href="https://portal.azure.cn/#blade/HubsExtension/ArgQueryBlade/query/ServiceHealthResources%0D%0A%7C%20where%20type%20%3D~%20%27Microsoft.ResourceHealth%2Fevents%27%0D%0A%7C%20extend%20eventType%20%3D%20tostring%28properties.EventType%29%2C%20status%20%3D%20properties.Status%2C%20description%20%3D%20properties.Title%2C%20trackingId%20%3D%20properties.TrackingId%2C%20summary%20%3D%20properties.Summary%2C%20priority%20%3D%20properties.Priority%2C%20impactStartTime%20%3D%20properties.ImpactStartTime%2C%20impactMitigationTime%20%3D%20properties.ImpactMitigationTime%0D%0A%7C%20where%20eventType%20%3D%3D%20%27ServiceIssue%27%20and%20status%20%3D%3D%20%27Active%27%0D%0A%7C%20summarize%20count%28subscriptionId%29%20by%20name" target="_blank">portal.azure.cn</a>

---

#### All active health advisory events

This query lists all active health advisory events from Service Health across every subscription you have access to.

```kusto
ServiceHealthResources
| where type =~ 'Microsoft.ResourceHealth/events'
| extend eventType = properties.EventType, status = properties.Status, description = properties.Title, trackingId = properties.TrackingId, summary = properties.Summary, priority = properties.Priority, impactStartTime = properties.ImpactStartTime, impactMitigationTime = todatetime(tolong(properties.ImpactMitigationTime))
| where eventType == 'HealthAdvisory' and impactMitigationTime > now()
```

# [Azure CLI](#tab/azure-cli)

```azurecli-interactive
az graph query -q "ServiceHealthResources | where type =~ 'Microsoft.ResourceHealth/events' | extend eventType = properties.EventType, status = properties.Status, description = properties.Title, trackingId = properties.TrackingId, summary = properties.Summary, priority = properties.Priority, impactStartTime = properties.ImpactStartTime, impactMitigationTime = todatetime(tolong(properties.ImpactMitigationTime)) | where eventType == 'HealthAdvisory' and impactMitigationTime > now()"
```

# [Azure PowerShell](#tab/azure-powershell)

```azurepowershell-interactive
Search-AzGraph -Query "ServiceHealthResources | where type =~ 'Microsoft.ResourceHealth/events' | extend eventType = properties.EventType, status = properties.Status, description = properties.Title, trackingId = properties.TrackingId, summary = properties.Summary, priority = properties.Priority, impactStartTime = properties.ImpactStartTime, impactMitigationTime = todatetime(tolong(properties.ImpactMitigationTime)) | where eventType == 'HealthAdvisory' and impactMitigationTime > now()"
```

# [Portal](#tab/azure-portal)

- Azure portal: <a href="https://portal.azure.com/#blade/HubsExtension/ArgQueryBlade/query/ServiceHealthResources%0D%0A%7C%20where%20type%20%3D~%20%27Microsoft.ResourceHealth%2Fevents%27%0D%0A%7C%20extend%20eventType%20%3D%20properties.EventType%2C%20status%20%3D%20properties.Status%2C%20description%20%3D%20properties.Title%2C%20trackingId%20%3D%20properties.TrackingId%2C%20summary%20%3D%20properties.Summary%2C%20priority%20%3D%20properties.Priority%2C%20impactStartTime%20%3D%20properties.ImpactStartTime%2C%20impactMitigationTime%20%3D%20todatetime%28tolong%28properties.ImpactMitigationTime%29%29%0D%0A%7C%20where%20eventType%20%3D%3D%20%27HealthAdvisory%27%20and%20impactMitigationTime%20%3E%20now%28%29" target="_blank">portal.azure.com</a>
- Azure Government portal: <a href="https://portal.azure.us/#blade/HubsExtension/ArgQueryBlade/query/ServiceHealthResources%0D%0A%7C%20where%20type%20%3D~%20%27Microsoft.ResourceHealth%2Fevents%27%0D%0A%7C%20extend%20eventType%20%3D%20properties.EventType%2C%20status%20%3D%20properties.Status%2C%20description%20%3D%20properties.Title%2C%20trackingId%20%3D%20properties.TrackingId%2C%20summary%20%3D%20properties.Summary%2C%20priority%20%3D%20properties.Priority%2C%20impactStartTime%20%3D%20properties.ImpactStartTime%2C%20impactMitigationTime%20%3D%20todatetime%28tolong%28properties.ImpactMitigationTime%29%29%0D%0A%7C%20where%20eventType%20%3D%3D%20%27HealthAdvisory%27%20and%20impactMitigationTime%20%3E%20now%28%29" target="_blank">portal.azure.us</a>
- Azure operated by 21Vianet portal: <a href="https://portal.azure.cn/#blade/HubsExtension/ArgQueryBlade/query/ServiceHealthResources%0D%0A%7C%20where%20type%20%3D~%20%27Microsoft.ResourceHealth%2Fevents%27%0D%0A%7C%20extend%20eventType%20%3D%20properties.EventType%2C%20status%20%3D%20properties.Status%2C%20description%20%3D%20properties.Title%2C%20trackingId%20%3D%20properties.TrackingId%2C%20summary%20%3D%20properties.Summary%2C%20priority%20%3D%20properties.Priority%2C%20impactStartTime%20%3D%20properties.ImpactStartTime%2C%20impactMitigationTime%20%3D%20todatetime%28tolong%28properties.ImpactMitigationTime%29%29%0D%0A%7C%20where%20eventType%20%3D%3D%20%27HealthAdvisory%27%20and%20impactMitigationTime%20%3E%20now%28%29" target="_blank">portal.azure.cn</a>

---
#### All upcoming service retirement events

This query returns all upcoming Service Health events for Retirements across all your subscriptions.

```kusto
ServiceHealthResources
where type =~ 'Microsoft.ResourceHealth/events'
| extend eventType = properties.EventType, eventSubType = properties.EventSubType
| where eventType == "HealthAdvisory" and eventSubType == "Retirement"
|extend status = properties.Status, description = properties.Title, trackingId = properties.TrackingId, summary = properties.Summary, priority = properties.Priority, impactStartTime = todatetime(tolong(properties.ImpactStartTime)), impactMitigationTime = todatetime(tolong(properties.ImpactMitigationTime)), impact = properties.Impact
| where impactMitigationTime > datetime(now)
|project trackingId, subscriptionId, status, eventType, eventSubType, summary, description, priority, impactStartTime, impactMitigationTime, impact
```
---
#### All active planned maintenance events

This query finds and returns a list of all active planned maintenance Service Health events across all the subscriptions you have access to.

```kusto
ServiceHealthResources
| where type =~ 'Microsoft.ResourceHealth/events'
| extend eventType = properties.EventType, status = properties.Status, description = properties.Title, trackingId = properties.TrackingId, summary = properties.Summary, priority = properties.Priority, impactStartTime = properties.ImpactStartTime, impactMitigationTime = todatetime(tolong(properties.ImpactMitigationTime))
| where eventType == 'PlannedMaintenance' and impactMitigationTime > now()
```

# [Azure CLI](#tab/azure-cli)

```azurecli-interactive
az graph query -q "ServiceHealthResources | where type =~ 'Microsoft.ResourceHealth/events' | extend eventType = properties.EventType, status = properties.Status, description = properties.Title, trackingId = properties.TrackingId, summary = properties.Summary, priority = properties.Priority, impactStartTime = properties.ImpactStartTime, impactMitigationTime = todatetime(tolong(properties.ImpactMitigationTime)) | where eventType == 'PlannedMaintenance' and impactMitigationTime > now()"
```

# [Azure PowerShell](#tab/azure-powershell)

```azurepowershell-interactive
Search-AzGraph -Query "ServiceHealthResources | where type =~ 'Microsoft.ResourceHealth/events' | extend eventType = properties.EventType, status = properties.Status, description = properties.Title, trackingId = properties.TrackingId, summary = properties.Summary, priority = properties.Priority, impactStartTime = properties.ImpactStartTime, impactMitigationTime = todatetime(tolong(properties.ImpactMitigationTime)) | where eventType == 'PlannedMaintenance' and impactMitigationTime > now()"
```

# [Portal](#tab/azure-portal)

- Azure portal: <a href="https://portal.azure.com/#blade/HubsExtension/ArgQueryBlade/query/ServiceHealthResources%0D%0A%7C%20where%20type%20%3D~%20%27Microsoft.ResourceHealth%2Fevents%27%0D%0A%7C%20extend%20eventType%20%3D%20properties.EventType%2C%20status%20%3D%20properties.Status%2C%20description%20%3D%20properties.Title%2C%20trackingId%20%3D%20properties.TrackingId%2C%20summary%20%3D%20properties.Summary%2C%20priority%20%3D%20properties.Priority%2C%20impactStartTime%20%3D%20properties.ImpactStartTime%2C%20impactMitigationTime%20%3D%20todatetime%28tolong%28properties.ImpactMitigationTime%29%29%0D%0A%7C%20where%20eventType%20%3D%3D%20%27PlannedMaintenance%27%20and%20impactMitigationTime%20%3E%20now%28%29" target="_blank">portal.azure.com</a>
- Azure Government portal: <a href="https://portal.azure.us/#blade/HubsExtension/ArgQueryBlade/query/ServiceHealthResources%0D%0A%7C%20where%20type%20%3D~%20%27Microsoft.ResourceHealth%2Fevents%27%0D%0A%7C%20extend%20eventType%20%3D%20properties.EventType%2C%20status%20%3D%20properties.Status%2C%20description%20%3D%20properties.Title%2C%20trackingId%20%3D%20properties.TrackingId%2C%20summary%20%3D%20properties.Summary%2C%20priority%20%3D%20properties.Priority%2C%20impactStartTime%20%3D%20properties.ImpactStartTime%2C%20impactMitigationTime%20%3D%20todatetime%28tolong%28properties.ImpactMitigationTime%29%29%0D%0A%7C%20where%20eventType%20%3D%3D%20%27PlannedMaintenance%27%20and%20impactMitigationTime%20%3E%20now%28%29" target="_blank">portal.azure.us</a>
- Azure operated by 21Vianet portal: <a href="https://portal.azure.cn/#blade/HubsExtension/ArgQueryBlade/query/ServiceHealthResources%0D%0A%7C%20where%20type%20%3D~%20%27Microsoft.ResourceHealth%2Fevents%27%0D%0A%7C%20extend%20eventType%20%3D%20properties.EventType%2C%20status%20%3D%20properties.Status%2C%20description%20%3D%20properties.Title%2C%20trackingId%20%3D%20properties.TrackingId%2C%20summary%20%3D%20properties.Summary%2C%20priority%20%3D%20properties.Priority%2C%20impactStartTime%20%3D%20properties.ImpactStartTime%2C%20impactMitigationTime%20%3D%20todatetime%28tolong%28properties.ImpactMitigationTime%29%29%0D%0A%7C%20where%20eventType%20%3D%3D%20%27PlannedMaintenance%27%20and%20impactMitigationTime%20%3E%20now%28%29" target="_blank">portal.azure.cn</a>

---

#### All active Service Health events

Use this query to list all active Service Health events, like service issues, planned maintenance, health advisories, and security advisories across all your subscriptions.

```kusto
ServiceHealthResources
| where type =~ 'Microsoft.ResourceHealth/events'
| extend eventType = properties.EventType, status = properties.Status, description = properties.Title, trackingId = properties.TrackingId, summary = properties.Summary, priority = properties.Priority, impactStartTime = properties.ImpactStartTime, impactMitigationTime = properties.ImpactMitigationTime
| where (eventType in ('HealthAdvisory', 'SecurityAdvisory', 'PlannedMaintenance') and impactMitigationTime > now()) or (eventType == 'ServiceIssue' and status == 'Active')
```

# [Azure CLI](#tab/azure-cli)

```azurecli-interactive
az graph query -q "ServiceHealthResources | where type =~ 'Microsoft.ResourceHealth/events' | extend eventType = properties.EventType, status = properties.Status, description = properties.Title, trackingId = properties.TrackingId, summary = properties.Summary, priority = properties.Priority, impactStartTime = properties.ImpactStartTime, impactMitigationTime = properties.ImpactMitigationTime | where (eventType in ('HealthAdvisory', 'SecurityAdvisory', 'PlannedMaintenance') and impactMitigationTime > now()) or (eventType == 'ServiceIssue' and status == 'Active')"
```

# [Azure PowerShell](#tab/azure-powershell)

```azurepowershell-interactive
Search-AzGraph -Query "ServiceHealthResources | where type =~ 'Microsoft.ResourceHealth/events' | extend eventType = properties.EventType, status = properties.Status, description = properties.Title, trackingId = properties.TrackingId, summary = properties.Summary, priority = properties.Priority, impactStartTime = properties.ImpactStartTime, impactMitigationTime = properties.ImpactMitigationTime | where (eventType in ('HealthAdvisory', 'SecurityAdvisory', 'PlannedMaintenance') and impactMitigationTime > now()) or (eventType == 'ServiceIssue' and status == 'Active')"
```

# [Portal](#tab/azure-portal)

- Azure portal: <a href="https://portal.azure.com/#blade/HubsExtension/ArgQueryBlade/query/ServiceHealthResources%0D%0A%7C%20where%20type%20%3D~%20%27Microsoft.ResourceHealth%2Fevents%27%0D%0A%7C%20extend%20eventType%20%3D%20properties.EventType%2C%20status%20%3D%20properties.Status%2C%20description%20%3D%20properties.Title%2C%20trackingId%20%3D%20properties.TrackingId%2C%20summary%20%3D%20properties.Summary%2C%20priority%20%3D%20properties.Priority%2C%20impactStartTime%20%3D%20properties.ImpactStartTime%2C%20impactMitigationTime%20%3D%20properties.ImpactMitigationTime%0D%0A%7C%20where%20%28eventType%20in%20%28%27HealthAdvisory%27%2C%20%27SecurityAdvisory%27%2C%20%27PlannedMaintenance%27%29%20and%20impactMitigationTime%20%3E%20now%28%29%29%20or%20%28eventType%20%3D%3D%20%27ServiceIssue%27%20and%20status%20%3D%3D%20%27Active%27%29" target="_blank">portal.azure.com</a>
- Azure Government portal: <a href="https://portal.azure.us/#blade/HubsExtension/ArgQueryBlade/query/ServiceHealthResources%0D%0A%7C%20where%20type%20%3D~%20%27Microsoft.ResourceHealth%2Fevents%27%0D%0A%7C%20extend%20eventType%20%3D%20properties.EventType%2C%20status%20%3D%20properties.Status%2C%20description%20%3D%20properties.Title%2C%20trackingId%20%3D%20properties.TrackingId%2C%20summary%20%3D%20properties.Summary%2C%20priority%20%3D%20properties.Priority%2C%20impactStartTime%20%3D%20properties.ImpactStartTime%2C%20impactMitigationTime%20%3D%20properties.ImpactMitigationTime%0D%0A%7C%20where%20%28eventType%20in%20%28%27HealthAdvisory%27%2C%20%27SecurityAdvisory%27%2C%20%27PlannedMaintenance%27%29%20and%20impactMitigationTime%20%3E%20now%28%29%29%20or%20%28eventType%20%3D%3D%20%27ServiceIssue%27%20and%20status%20%3D%3D%20%27Active%27%29" target="_blank">portal.azure.us</a>
- Azure operated by 21Vianet portal: <a href="https://portal.azure.cn/#blade/HubsExtension/ArgQueryBlade/query/ServiceHealthResources%0D%0A%7C%20where%20type%20%3D~%20%27Microsoft.ResourceHealth%2Fevents%27%0D%0A%7C%20extend%20eventType%20%3D%20properties.EventType%2C%20status%20%3D%20properties.Status%2C%20description%20%3D%20properties.Title%2C%20trackingId%20%3D%20properties.TrackingId%2C%20summary%20%3D%20properties.Summary%2C%20priority%20%3D%20properties.Priority%2C%20impactStartTime%20%3D%20properties.ImpactStartTime%2C%20impactMitigationTime%20%3D%20properties.ImpactMitigationTime%0D%0A%7C%20where%20%28eventType%20in%20%28%27HealthAdvisory%27%2C%20%27SecurityAdvisory%27%2C%20%27PlannedMaintenance%27%29%20and%20impactMitigationTime%20%3E%20now%28%29%29%20or%20%28eventType%20%3D%3D%20%27ServiceIssue%27%20and%20status%20%3D%3D%20%27Active%27%29" target="_blank">portal.azure.cn</a>

---

#### All active service issue events

This query finds and lists all active service issues (outages) and Service Health events across all subscriptions.

```kusto
ServiceHealthResources
| where type =~ 'Microsoft.ResourceHealth/events'
| extend eventType = properties.EventType, status = properties.Status, description = properties.Title, trackingId = properties.TrackingId, summary = properties.Summary, priority = properties.Priority, impactStartTime = properties.ImpactStartTime, impactMitigationTime = properties.ImpactMitigationTime
| where eventType == 'ServiceIssue' and status == 'Active'
```

# [Azure CLI](#tab/azure-cli)

```azurecli-interactive
az graph query -q "ServiceHealthResources | where type =~ 'Microsoft.ResourceHealth/events' | extend eventType = properties.EventType, status = properties.Status, description = properties.Title, trackingId = properties.TrackingId, summary = properties.Summary, priority = properties.Priority, impactStartTime = properties.ImpactStartTime, impactMitigationTime = properties.ImpactMitigationTime | where eventType == 'ServiceIssue' and status == 'Active'"
```

# [Azure PowerShell](#tab/azure-powershell)

```azurepowershell-interactive
Search-AzGraph -Query "ServiceHealthResources | where type =~ 'Microsoft.ResourceHealth/events' | extend eventType = properties.EventType, status = properties.Status, description = properties.Title, trackingId = properties.TrackingId, summary = properties.Summary, priority = properties.Priority, impactStartTime = properties.ImpactStartTime, impactMitigationTime = properties.ImpactMitigationTime | where eventType == 'ServiceIssue' and status == 'Active'"
```

# [Portal](#tab/azure-portal)

- Azure portal: <a href="https://portal.azure.com/#blade/HubsExtension/ArgQueryBlade/query/ServiceHealthResources%0D%0A%7C%20where%20type%20%3D~%20%27Microsoft.ResourceHealth%2Fevents%27%0D%0A%7C%20extend%20eventType%20%3D%20properties.EventType%2C%20status%20%3D%20properties.Status%2C%20description%20%3D%20properties.Title%2C%20trackingId%20%3D%20properties.TrackingId%2C%20summary%20%3D%20properties.Summary%2C%20priority%20%3D%20properties.Priority%2C%20impactStartTime%20%3D%20properties.ImpactStartTime%2C%20impactMitigationTime%20%3D%20properties.ImpactMitigationTime%0D%0A%7C%20where%20eventType%20%3D%3D%20%27ServiceIssue%27%20and%20status%20%3D%3D%20%27Active%27" target="_blank">portal.azure.com</a>
- Azure Government portal: <a href="https://portal.azure.us/#blade/HubsExtension/ArgQueryBlade/query/ServiceHealthResources%0D%0A%7C%20where%20type%20%3D~%20%27Microsoft.ResourceHealth%2Fevents%27%0D%0A%7C%20extend%20eventType%20%3D%20properties.EventType%2C%20status%20%3D%20properties.Status%2C%20description%20%3D%20properties.Title%2C%20trackingId%20%3D%20properties.TrackingId%2C%20summary%20%3D%20properties.Summary%2C%20priority%20%3D%20properties.Priority%2C%20impactStartTime%20%3D%20properties.ImpactStartTime%2C%20impactMitigationTime%20%3D%20properties.ImpactMitigationTime%0D%0A%7C%20where%20eventType%20%3D%3D%20%27ServiceIssue%27%20and%20status%20%3D%3D%20%27Active%27" target="_blank">portal.azure.us</a>
- Azure operated by 21Vianet portal: <a href="https://portal.azure.cn/#blade/HubsExtension/ArgQueryBlade/query/ServiceHealthResources%0D%0A%7C%20where%20type%20%3D~%20%27Microsoft.ResourceHealth%2Fevents%27%0D%0A%7C%20extend%20eventType%20%3D%20properties.EventType%2C%20status%20%3D%20properties.Status%2C%20description%20%3D%20properties.Title%2C%20trackingId%20%3D%20properties.TrackingId%2C%20summary%20%3D%20properties.Summary%2C%20priority%20%3D%20properties.Priority%2C%20impactStartTime%20%3D%20properties.ImpactStartTime%2C%20impactMitigationTime%20%3D%20properties.ImpactMitigationTime%0D%0A%7C%20where%20eventType%20%3D%3D%20%27ServiceIssue%27%20and%20status%20%3D%3D%20%27Active%27" target="_blank">portal.azure.cn</a>

---
