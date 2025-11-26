---
title: Resource-scoped queries for Azure Monitor workspace
description: Learn how to query Azure Monitor workspace metrics using resource-scoped queries with PromQL, including setup, authentication, and error handling.
ms.topic: how-to
ms.date: 11/26/2025
author: tylerkight
ms.author: tylerkight
---

# Resource-scoped queries for Azure Monitor workspace

This article explains how to query Azure Monitor workspace metrics in the context of specific Azure resources rather than querying the workspace directly. Resource-scoped querying enables you to query metrics for resources you have access to without requiring direct access to the underlying Azure Monitor workspace.

## Overview

Resource-scoped querying provides a more flexible and secure way to access metrics stored in Azure Monitor workspaces:

- **Query by resource context**: Query metrics scoped to specific Azure resources, resource groups, or subscriptions
- **Simplified access control**: Users only need read access to the resources they're monitoring, not the workspace itself (when workspace is configured appropriately)
- **Automatic resource discovery**: No need to know which workspace contains metrics for a given resource
- **Enhanced security**: Follows least privilege access principles by limiting metric visibility to authorized resources

## Prerequisites

- One or more Azure resources sending metrics to an Azure Monitor workspace
- [Azure Monitor workspace](azure-monitor-workspace-overview.md) configured to receive metrics
- Appropriate [Azure RBAC permissions](#permissions-required) for the resources you want to query
- Understanding of [PromQL basics](prometheus-api-promql.md)

## Resource-scoped vs workspace-scoped queries

| Aspect | Workspace-scoped | Resource-scoped |
|--------|------------------|-----------------|
| **Query endpoint** | `https://<workspace-id>.<region>.prometheus.monitor.azure.com` | `https://query.<region>.prometheus.monitor.azure.com` |
| **Scope** | All metrics in a specific workspace | Metrics for specific resource(s), resource group(s), or subscription(s) |
| **Access requirements** | Workspace read permissions required | Resource read permissions required (workspace access optional, depends on [access mode](azure-monitor-workspace-manage-access.md)) |
| **Use case** | Central monitoring teams with broad access | Application teams monitoring their own resources |
| **Resource filtering** | Manual filtering using `Microsoft.resourceid` dimension | Automatic filtering based on query scope |

## Query endpoint and authentication

### Regional query endpoint

Resource-scoped queries use a regional endpoint that automatically routes requests to the appropriate workspace(s):

```
https://query.<region>.prometheus.monitor.azure.com
```

**Examples:**
- `https://query.centralus.prometheus.monitor.azure.com`
- `https://query.westeurope.prometheus.monitor.azure.com`

> [!TIP]
> While you can query from any region, querying from the same region as your workspace(s) provides optimal performance. Cross-region queries are automatically routed but may have slightly higher latency. In addition, consider GDPR compliance when collecting Query Diagnostic Logs, as the regional endpoint you query against informs the region those logs are stored in.

### Scoping header

Resource-scoped queries require an HTTP header to specify the scope:

| Header Key | Header Value |
|------------|--------------|
| `x-ms-azure-scoping` | Full Azure Resource ID, Resource Group ID, or Subscription ID |

**Examples:**

```http
# Resource scope
x-ms-azure-scoping: /subscriptions/{subscription-id}/resourceGroups/{resource-group}/providers/Microsoft.Compute/virtualMachines/{vm-name}

# Resource group scope  
x-ms-azure-scoping: /subscriptions/{subscription-id}/resourceGroups/{resource-group}

# Subscription scope
x-ms-azure-scoping: /subscriptions/{subscription-id}
```

### Authentication

Resource-scoped queries support the following authentication methods:

- **Microsoft Entra ID (formerly Azure AD)**: User credentials or service principal
- **Managed Identity**: System-assigned or user-assigned managed identities

The authenticated identity must have **Monitoring Reader** role (or higher) on the resources being queried.

## Resource dimensions

Azure Monitor automatically stamps the following dimensions on metrics ingested via Azure Monitor Agent (as of September 2024):

| Dimension | Description | Example Value |
|-----------|-------------|---------------|
| `Microsoft.resourceid` | Full resource ID | `/subscriptions/.../virtualMachines/vm-01` |
| `Microsoft.subscriptionid` | Subscription GUID | `12345678-1234-1234-1234-123456789012` |
| `Microsoft.resourcegroupname` | Resource group name | `production-rg` |
| `Microsoft.resourcetype` | Resource type | `Microsoft.Compute/virtualMachines` |
| `Microsoft.amwresourceid` | Workspace storing the metric | `/subscriptions/.../providers/Microsoft.Monitor/accounts/my-amw` |

> [!IMPORTANT]
> When querying in resource-scoped mode, filter on **`"Microsoft.resourceid"`** rather than other identifiers like `instance`, `host.name`, or `service.instance.id` to ensure accurate scoping.

### Dimension visibility

- **Resource-scoped queries**: All `Microsoft.*` dimensions are visible and can be used in PromQL queries
- **Workspace-scoped queries**: Only `Microsoft.resourceid` is visible by default to minimize confusion for container-centric scenarios

## Query examples

### Basic resource-scoped query

```bash
# Query CPU utilization for a specific VM
curl -X GET \
  'https://query.eastus.prometheus.monitor.azure.com/api/v1/query?query=avg({"system.cpu.utilization"})+by+("Microsoft.resourceid")' \
  -H 'Authorization: Bearer <token>' \
  -H 'x-ms-azure-scoping: /subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/prod-rg/providers/Microsoft.Compute/virtualMachines/vm-01'
```

### Resource group scope

```promql
# Query all VMs in a resource group
avg({"system.cpu.utilization"}) by ("Microsoft.resourceid")
```

With header:
```
x-ms-azure-scoping: /subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/prod-rg
```

### Subscription scope with filtering

```promql
# Query specific resource types across a subscription
avg({"system.cpu.utilization"}) by ("Microsoft.resourceid")
{
  "Microsoft.resourcetype"="Microsoft.Compute/virtualMachines"
}
```

With header:
```
x-ms-azure-scoping: /subscriptions/12345678-1234-1234-1234-123456789012
```

### Using with Grafana

1. Create a new Prometheus data source in Grafana
2. Set the Prometheus server URL to `https://query.eastus.prometheus.monitor.azure.com` (or your region)
3. Configure authentication:
   - For Azure Managed Prometheus data source: Use Azure authentication
   - For OSS Prometheus data source: Use Managed Identity with Monitoring Reader role
4. Add a custom HTTP header:
   - Key: `x-ms-azure-scoping`
   - Value: Resource ID, resource group ID, or subscription ID

**Example with Grafana variables:**

Create a variable for dynamic scoping:
- Name: `ResourceScope`
- Type: `Custom`
- Values: List of resource IDs or subscription IDs

Use `${ResourceScope}` as the header value to switch between resources without duplicating dashboards.

## Permissions required

### Resource-scoped queries

The authenticated identity must have one of the following roles on the resources being queried:

- **Monitoring Reader** (minimum, recommended)
- **Reader**
- **Contributor**
- **Owner**

### Workspace access mode dependency

Resource-scoped query behavior depends on the workspace [access control mode](azure-monitor-workspace-manage-access.md):

| Access Mode | Permissions Required |
|-------------|---------------------|
| **Use resource or workspace permissions** (default for new workspaces) | Only resource read access required |
| **Require workspace permissions** | Resource read access AND workspace read access required |

> [!TIP]
> Configure your workspaces with **Use resource or workspace permissions** mode to enable true resource-scoped access without workspace permissions. This is enabled by default on all newly created AMWs after October 2025.

## Supported scenarios

Resource-scoped querying is supported in the following Azure Monitor experiences:

### Portal experiences

- **Metrics blade**: When viewing metrics for a resource (VM, AKS, App Service, etc.), click "View AMW metrics in editor" to query using PromQL
- **Dashboards**: Create resource-scoped metric charts using the PromQL editor
- **Workbooks**: Reference resource-scoped metrics in workbook queries

### Grafana

- Create dashboards scoped to subscriptions, resource groups, or individual resources
- Use Grafana variables to switch between resource scopes dynamically
- Leverage Azure Managed Prometheus data source for simplified authentication

### Alerting

- **Metric alerts**: Create resource-scoped Prometheus alerts using the unified alert control plane
- **Prometheus rule groups**: Define recording rules and alert rules scoped to specific resources

### Curated experiences

Resource-scoped querying is the default for:

- **VM Insights v2**: OpenTelemetry-based performance counters
- **Application Insights**: OpenTelemetry metrics in Azure Monitor workspace
- **Container Insights**: Post-migration to resource-scoped model

## Error handling

Resource-scoped queries may return the following errors:

### Missing authentication header

**HTTP 401 Unauthorized**

```json
{
  "error": {
    "code": "AuthenticationFailed",
    "message": "Authentication failed. The 'Authorization' header is missing."
  }
}
```

**Solution**: Include a valid Bearer token in the `Authorization` header.

### Missing or invalid scoping header

**HTTP 400 Bad Request**

```json
{
  "error": {
    "code": "BadArgumentError",
    "message": "The 'x-ms-azure-scoping' header is missing or malformed."
  }
}
```

**Solution**: Verify the `x-ms-azure-scoping` header contains a valid Azure Resource ID, resource group ID, or subscription ID.

### Insufficient permissions

**HTTP 403 Forbidden**

```json
{
  "error": {
    "code": "InsufficientAccessError",
    "message": "The provided credentials have insufficient access to perform the requested operation",
    "innererror": {
      "code": "AuthorizationFailedError",
      "message": "User does not have access to read metrics for this resource"
    }
  }
}
```

**Solution**: Verify the authenticated identity has Monitoring Reader role (or higher) on the resources specified in the scoping header. If the workspace is in "Require workspace permissions" mode, also verify access to the workspace.

### Invalid token

**HTTP 403 Forbidden**

```json
{
  "error": {
    "code": "InvalidAuthenticationToken",
    "message": "The access token is invalid."
  }
}
```

**Solution**: Ensure the token is valid, not expired, and obtained for the correct resource (`https://prometheus.monitor.azure.com`).

### Query syntax errors

**HTTP 400 Bad Request** or **HTTP 422 Unprocessable Entity**

```json
{
  "error": {
    "code": "QueryValidationError",
    "message": "Failed parsing the query"
  }
}
```

**Solution**: Verify PromQL syntax. See [PromQL documentation](https://prometheus.io/docs/prometheus/latest/querying/basics/) for query syntax reference.

### Query timeout

**HTTP 503 Service Unavailable**

```json
{
  "status": "error",
  "errorType": "timeout",
  "error": "query timed out"
}
```

**Solution**: Simplify the query, reduce the time range, or use [recording rules](prometheus-rule-groups.md) to pre-aggregate data.

### No data returned

**HTTP 200 OK** with empty results

```json
{
  "status": "success",
  "data": {
    "resultType": "vector",
    "result": []
  }
}
```

**Possible causes:**
- No metrics exist for the specified resource in the queried time range
- Metrics are not stamped with `Microsoft.resourceid` dimension (only metrics ingested via Azure Monitor Agent are automatically stamped)
- Resource ID in scoping header doesn't match the `Microsoft.resourceid` value in stored metrics

**Solution**: Verify data ingestion, check dimension values using workspace-scoped queries, and confirm the scoping header matches actual resource IDs.

## Best practices

1. **Use subscription scope by default**: Query at the subscription level and filter by `"Microsoft.resourcetype"` or `"Microsoft.resourceid"` for better flexibility

2. **Group by resource ID**: Always include `by ("Microsoft.resourceid")` in aggregations to maintain resource-level granularity

   ```promql
   avg({"system.cpu.utilization"}) by ("Microsoft.resourceid")
   ```

3. **Leverage recording rules**: For complex or frequently-run queries, use [recording rules](prometheus-rule-groups.md) to pre-aggregate data and reduce query load

4. **Configure workspace access mode**: Set workspaces to "Use resource or workspace permissions" mode to enable true resource-scoped access

5. **Query from the same region**: While cross-region queries work, querying from the same region as your workspace provides optimal performance

6. **Use Managed Identity in Grafana**: For Grafana deployments, use Managed Identity authentication to avoid managing credentials

## Common scenarios

### Application team monitoring

**Scenario**: Jane manages an application spanning multiple VMs but doesn't have access to the central monitoring workspace.

**Solution**: Jane's identity has Monitoring Reader on her resource group. She creates Grafana dashboards using:
- Prometheus URL: `https://query.eastus.prometheus.monitor.azure.com`
- Scoping header: `/subscriptions/{sub-id}/resourceGroups/jane-app-rg`

She can query all metrics for her resources without workspace access.

### Multi-tenant monitoring

**Scenario**: Bob manages infrastructure for multiple application teams and needs to grant each team access to only their resources.

**Solution**:
1. Bob configures the central workspace with "Use resource or workspace permissions" access mode
2. Each team receives Monitoring Reader role on their resource group
3. Teams create resource-scoped queries using their resource group ID
4. Bob maintains workspace-scoped queries for cross-team monitoring

### Kubernetes namespace isolation

**Scenario**: Tim has access to a specific AKS namespace but not the entire cluster.

**Solution**: Tim queries using the namespace resource ID:
```
x-ms-azure-scoping: /subscriptions/{sub-id}/resourceGroups/{rg}/providers/Microsoft.ContainerService/managedClusters/{cluster}/namespaces/{namespace}
```

He can create alerts and dashboards for his namespace without accessing cluster-wide metrics.

## Limitations

- **Comma-separated scopes**: Querying multiple unrelated resources in a single request (comma-separated resource IDs) is not yet supported
- **Non-Azure resources**: Resource-scoped queries require Azure Resource IDs. Arc-enabled resources are supported.
- **Dimension stamping**: Only metrics ingested via Azure Monitor Agent (since September 2025) have `Microsoft.*` dimensions automatically stamped
- **Cross-workspace queries**: Implicit cross-workspace queries within a resource scope are supported, but explicit workspace identifiers cannot be used in resource-scoped queries

## Related content

- [Manage access to Azure Monitor workspaces](azure-monitor-workspace-manage-access.md)
- [PromQL best practices for OpenTelemetry metrics](prometheus-opentelemetry-best-practices.md)
- [PromQL for system metrics and performance counters](prometheus-system-metrics-best-practices.md)
- [Query Prometheus metrics using the API and PromQL](prometheus-api-promql.md)
- [Azure Monitor workspace overview](azure-monitor-workspace-overview.md)
