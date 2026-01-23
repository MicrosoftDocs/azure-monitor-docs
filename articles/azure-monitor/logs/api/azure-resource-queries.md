---
title: Querying logs for Azure resources
description: In Log Analytics, queries typically execute in the context of a workspace. A workspace may contain data for many resources, making it difficult to isolate data for a particular resource.
ms.date: 08/12/2024
ms.topic: concept-article
---

# Querying logs for Azure resources

In Azure Monitor Log Analytics, queries typically execute in the context of a workspace. A workspace may contain data for many resources, making it difficult to isolate data for a particular resource. Resources might additionally send data to multiple workspaces. To simplify this experience, the REST API permits querying Azure resources directly for their logs.

## URL formats

### Request format

Consider an Azure resource with a fully qualified identifier:

```
/subscriptions/<sid>/resourceGroups/<rg>/providers/<providerName>/<resourceType>/<resourceName>
```

A query for this resource's logs against the direct API endpoint would go to the following URL:

```
https://api.loganalytics.azure.com/v1/subscriptions/<sid>/resourceGroups/<rg>/providers/<providerName>/<resourceType>/<resourceName>/query
```

A query to the same resource via ARM would use the following URL:

```
https://management.azure.com/subscriptions/<sid>/resourceGroups/<rg>/providers/<providerName>/<resourceType>/<resourceName>/providers/microsoft.insights/logs?api-version=2018-03-01-preview
```

Essentially, this URL is the fully qualified Azure resource plus the extension provider: `/providers/microsoft.insights/logs`.

### Response format

Azure resource queries produce the [same response shape](response-format.md) as queries targeting a Log Analytics workspace.

## Table access and RBAC

The best way to control access at the table level is to implement [Granular RBAC](manage-table-access.md#configure-granular-rbac-for-table-level-access).

## Workspace access control

Azure resource queries examine Log Analytics workspaces as possible data sources. However, administrators can restrict access to the workspace via roles and restrict access to the tables with granular RBAC. By default, the API only returns results from workspaces and tables the user has permissions to access.

However, to see ensure adherence to RBAC at these levels, see the details outlined in the [granular RBAC FAQ](granular-rbac-log-analytics.md#frequently-asked-questions)

## Error responses

Here's a brief listing of common failure scenarios when querying Azure resources along with a description of symptomatic behavior.

### Azure resource doesn't exist

```
    HTTP/1.1 404 Not Found 
    { 
        "error": { 
            "message": "The resource /subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourcegroups/test-rg/providers/microsoft.storage/storageaccounts/exampleResource was not found", 
            "code": "ResourceNotFoundError" 
        }
    }
}
```

### No access to resource

```json
HTTP/1.1 403 Forbidden 
{
    "error": { 
        "message": "The provided credentials have insufficient access to  perform the requested operation", 
        "code": "InsufficientAccessError", 
        "innererror": { 
            "code": "AuthorizationFailedError",
            "message": "User '92eba38a-70da-42b0-ab83-ffe82cce658f' does not have access to read logs for this resource"
        }
    } 
}
```

### No logs from resource, or no permission to workspace containing those logs

Depending on the precise combination of data and permissions, the response either contains a 200 with no resulting data, or throws a syntax error (4xx error).

## Partial access

There are some scenarios where a user may have partial permissions to access a particular resource's logs. This is the case if the user is missing either:

* Access to the workspace containing logs for the Azure resource.
* Access to the tables reference in the query.

They see a normal response, with data sources the user doesn't have permissions to access silently filtered out. To see information about a user's access to an Azure resource, the underlying Log Analytics workspaces, and to specific tables, include the header `Prefer: include-permissions=true` with requests. This causes the response JSON to include a section like the following example:

```json
{ 
    "permissions": { 
        "resources": [ 
            { 
                "resourceId": "/subscriptions/<id>/resourceGroups<id>/providers/Microsoft.Compute/virtualMachines/VM1", 
                "dataSources": [ 
                    "/subscriptions/<id>/resourceGroups<id>/providers/Microsoft.OperationalInsights/workspaces/WS1" 
                ] 
            }, 
            { 
                "resourceId": "/subscriptions/<id>/resourceGroups<id>/providers/Microsoft.Compute/virtualMachines/VM2", 
                "denyTables": [ 
                    "SecurityEvent", 
                    "SecurityBaseline" 
                ], 
                "dataSources": [ 
                    "/subscriptions/<id>/resourceGroups<id>/providers/Microsoft.OperationalInsights/workspaces/WS2",
                    "/subscriptions/<id>/resourceGroups<id>/providers/Microsoft.OperationalInsights/workspaces/WS3" 
                ] 
            } 
        ], 
        "dataSources": [ 
            { 
                "resourceId": "/subscriptions/<id>/resourceGroups<id>/providers/Microsoft.OperationalInsights/workspaces/WS1", 
                "denyTables": [ 
                    "Tables.Custom" 
                ] 
            }, 
            { 
                "resourceId": "/subscriptions/<id>/resourceGroups<id>/providers/Microsoft.OperationalInsights/workspaces/WS2" 
            } 
        ] 
    } 
}
```

The `resources` payload describes an attempt to query two VMs. VM1 sends data to workspace WS1, while VM2 sends data to two workspaces: WS2 and WS3. Additionally, the user doesn't have permission to query the `SecurityEvent` or `SecurityBaseline` tables for the resource.

The `dataSources` payload filters the results further by describing which workspaces the user can query. Here, the user doesn't have permissions to query WS3, and another table filtered out of WS1.

To clearly state what data such a query would return:

* Logs for VM1 in WS1, excluding `Tables.Custom` from the workspace.
* Logs for VM2, excluding `SecurityEvent` and `SecurityBaseline`, in WS2.
