---
title: Querying logs for Azure resources
description: In Log Analytics, queries typically execute in the context of a workspace. A workspace may contain data for many resources, making it difficult to isolate data for a particular resource.
ms.date: 01/26/2026
ms.topic: concept-article
---

# Querying logs for Azure resources

In Azure Monitor Log Analytics, queries typically execute in the context of a workspace. A workspace may contain data for many resources, making it difficult to isolate data for a particular resource. Resources might additionally send data to multiple workspaces. To simplify this experience, the REST API permits querying Azure resources directly for their logs.

## URL formats

### Request format

Consider the following example to understand the request format:

| Request portion | Syntax  |
|----|----|
| Azure resource with a fully qualified identifier | `/subscriptions/<sid>/resourceGroups/<rg>/providers/<providerName>/<resourceType>/<resourceName>` |
| Request format for this resource's logs against the direct API endpoint | `https://api.loganalytics.azure.com/v1/subscriptions/<sid>/resourceGroups/<rg>/providers/<providerName>/<resourceType>/<resourceName>/query` |

### Response format

Azure resource queries produce the [same response shape](response-format.md) as queries targeting a Log Analytics workspace.

## Table access and RBAC

The best way to control access at the table level is to implement [Granular RBAC](../manage-table-access.md#configure-granular-rbac-for-table-level-access).

## Workspace access control

Azure resource queries examine Log Analytics workspaces as possible data sources. However, administrators can restrict access to the workspace via roles and restrict access to the tables with granular RBAC. By default, the API only returns results from workspaces and tables the user has permissions to access. To ensure resource queries adhere to workspace and table RBAC, see the details outlined in the [granular RBAC FAQ](../granular-rbac-log-analytics.md#frequently-asked-questions).

## Troubleshooting

Here's a brief listing of common failure scenarios when querying Azure resources along with a description of symptomatic behavior.

### Azure resource doesn't exist

```json
HTTP/1.1 404 Not Found 
{ 
    "error": { 
        "message": "The resource /subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/test-rg/providers/microsoft.storage/storageaccounts/exampleResource was not found", 
        "code": "ResourceNotFoundError" 
    }
}
```

### No access to resource

```json
HTTP/1.1 403 Forbidden 
{
    "error": { 
        "message": "The provided credentials have insufficient access to perform the requested operation", 
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

### Partial access

There are some scenarios where a user may have partial permissions to access a particular resource's logs. This is the case if the user is missing either:

* Access to the workspace containing logs for the Azure resource.
* Access to the tables referenced in the query.

By default, these scenarios produce a successful response with HTTP status of 200, but the data sources the user doesn't have permissions to access are silently filtered out. 

To see detailed information about a user's access to the Azure resource, the underlying Log Analytics workspaces, and to specific tables, include the following header with your request:

| Request header | Purpose |
|---|---|
|`Prefer: include-permissions=true`| Enable verbose access permission details in response |

Here's an example of the additional JSON section included with the response when that header is included:

```json
{ 
    "permissions": { 
        "resources": [ 
            { 
                "resourceId": "/subscriptions/<id>/resourceGroups<id>/providers/Microsoft.Compute/virtualMachines/VM1", 
                "dataSources": [ 
                    "/subscriptions/<id>/resourceGroups/<id>/providers/Microsoft.OperationalInsights/workspaces/WS1" 
                ] 
            }, 
            { 
                "resourceId": "/subscriptions/<id>/resourceGroups/<id>/providers/Microsoft.Compute/virtualMachines/VM2", 
                "denyTables": [ 
                    "SecurityEvent", 
                    "SecurityBaseline" 
                ], 
                "dataSources": [ 
                    "/subscriptions/<id>/resourceGroups/<id>/providers/Microsoft.OperationalInsights/workspaces/WS2",
                    "/subscriptions/<id>/resourceGroups/<id>/providers/Microsoft.OperationalInsights/workspaces/WS3" 
                ] 
            } 
        ], 
        "dataSources": [ 
            { 
                "resourceId": "/subscriptions/<id>/resourceGroups/<id>/providers/Microsoft.OperationalInsights/workspaces/WS1", 
                "denyTables": [ 
                    "Tables.Custom" 
                ] 
            }, 
            { 
                "resourceId": "/subscriptions/<id>/resourceGroups/<id>/providers/Microsoft.OperationalInsights/workspaces/WS2" 
            } 
        ] 
    } 
}
```

The `resources` payload describes an attempt to query two VMs. VM1 sends data to workspace WS1, while VM2 sends data to two workspaces: WS2 and WS3. Additionally, the user doesn't have permission to query the `SecurityEvent` or `SecurityBaseline` tables for the resource.

The `dataSources` payload filters the results further by describing which workspaces the user can query. Here, the user doesn't have permissions to query WS3, and another table filtered out of WS1.

When the access controls are considered for the data, the query returns the following:

* Logs for VM1 in WS1, excluding `Tables.Custom` from the workspace.
* Logs for VM2, excluding `SecurityEvent` and `SecurityBaseline`, in WS2.
