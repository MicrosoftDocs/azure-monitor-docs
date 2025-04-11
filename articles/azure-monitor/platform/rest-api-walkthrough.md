---
title: Azure monitoring REST API walkthrough
description: How to authenticate requests and use the Azure Monitor REST API to retrieve available metric definitions, metric values, and activity logs.
ms.topic: conceptual
ms.date: 01/27/2025
ms.custom: has-adal-ref
ms.reviewer: priyamishra
---

# Azure monitoring REST API walkthrough

This article shows you how to use the [Azure Monitor REST API reference](/rest/api/monitor/).

Retrieve metric definitions, dimension values, and metric values using the Azure Monitor API and use the data in your applications, or store in a database for analysis. You can also list alert rules and view activity logs using the Azure Monitor API.

## Authenticate Azure Monitor requests

Request submitted using the Azure Monitor API use the Azure Resource Manager authentication model. All requests are authenticated with Microsoft Entra ID. One approach to authenticating the client application is to create a Microsoft Entra service principal and retrieve an authentication token. You can create a Microsoft Entra service principal using the Azure portal, CLI, or PowerShell. For more information, see [Register an App to request authorization tokens and work with APIs](../logs/api/register-app-for-token.md).

### Retrieve a token

Once you've created a service principal, retrieve an access token. Specify `resource=https://management.azure.com` in the token request.

[!INCLUDE [Get a token](../fundamentals/includes/get-authentication-token.md)]

After authenticating and retrieving a token, use the access token in your Azure Monitor API requests by including the header `'Authorization: Bearer <access token>'`

> [!NOTE]
> For more information on working with the Azure REST API, see the [Azure REST API reference](/rest/api/azure/).

## Retrieve the resource ID

Using the REST API requires the resource ID of the target Azure resource.
Resource IDs follow the following pattern:

`/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/<provider>/<resource name>/`

For example 

* **Azure IoT Hub**: /subscriptions/\<subscription-id>/resourceGroups/\<resource-group-name>/providers/Microsoft.Devices/IotHubs/\<iot-hub-name>
* **Elastic SQL pool**: /subscriptions/\<subscription-id>/resourceGroups/\<resource-group-name>/providers/Microsoft.Sql/servers/\<pool-db>/elasticpools/\<sql-pool-name>
* **Azure SQL Database (v12)**: /subscriptions/\<subscription-id>/resourceGroups/\<resource-group-name>/providers/Microsoft.Sql/servers/\<server-name>/databases/\<database-name>
* **Azure Service Bus**: /subscriptions/\<subscription-id>/resourceGroups/\<resource-group-name>/providers/Microsoft.ServiceBus/\<namespace>/\<servicebus-name>
* **Azure Virtual Machine Scale Sets**: /subscriptions/\<subscription-id>/resourceGroups/\<resource-group-name>/providers/Microsoft.Compute/virtualMachineScaleSets/\<vm-name>
* **Azure Virtual Machines**: /subscriptions/\<subscription-id>/resourceGroups/\<resource-group-name>/providers/Microsoft.Compute/virtualMachines/\<vm-name>
* **Azure Event Hubs**: /subscriptions/\<subscription-id>/resourceGroups/\<resource-group-name>/providers/Microsoft.EventHub/namespaces/\<eventhub-namespace>

Use the Azure portal, PowerShell, or the Azure CLI to find the resource ID.

### [Azure portal](#tab/portal)

To find the resourceID in the portal, from the resource's overview page, select **JSON view**.

:::image type="content" source="media/rest-api-walkthrough/json-view-azure-portal.png" lightbox="media/rest-api-walkthrough/json-view-azure-portal.png" alt-text="A screenshot showing the overview page for a resource with the JSON view link highlighted.":::

The Resource JSON page is displayed. The resource ID can be copied using the icon on the right of the ID. 

:::image type="content" source="media/rest-api-walkthrough/resourceid-azure-portal.png" lightbox="media/rest-api-walkthrough/resourceid-azure-portal.png" alt-text="A screenshot showing the Resource JSON page for a resource.":::

### [PowerShell](#tab/powershell)

The resource ID can be retrieved by using Azure PowerShell cmdlets too. For example, to obtain the resource ID for an Azure logic app, execute the `Get-AzureLogicApp` cmdlet, as in the following example:

```powershell
Get-AzLogicApp -ResourceGroupName azmon-rest-api-walkthrough -Name contosotweets
```

The result should be similar to the following example:

```output
Id             : /subscriptions/12345678-abcd-98765432-abcdef012345/resourceGroups/azmon-rest-api-walkthrough/providers/Microsoft.Logic/workflows/ContosoTweets
Name           : ContosoTweets
Type           : Microsoft.Logic/workflows
Location       : centralus
ChangedTime    : 8/21/2017 6:58:57 PM
CreatedTime    : 8/18/2017 7:54:21 PM
AccessEndpoint : https://prod-08.centralus.logic.azure.com:443/workflows/f3a91b352fcc47e6bff989b85446c5db
State          : Enabled
Definition     : {$schema, contentVersion, parameters, triggers...}
Parameters     : {[$connections, Microsoft.Azure.Management.Logic.Models.WorkflowParameter]}
SkuName        :
AppServicePlan :
PlanType       :
PlanId         :
Version        : 08586982649483762729
```

### [Azure CLI](#tab/cli)

To retrieve the resource ID for an Azure Storage account by using the Azure CLI, execute the `az storage account show` command, as shown in the following example:

```azurecli
az storage account show -g azmon-rest-api-walkthrough -n azmonstorage001
```

The result should be similar to the following example:

```json
{
  "accessTier": null,
  "creationTime": "2023-08-18T19:58:41.840552+00:00",
  "customDomain": null,
  "enableHttpsTrafficOnly": false,
  "encryption": null,
  "id": "/subscriptions/12345678-abcd-98765432-abcdef012345/resourceGroups/azmon-rest-api-walkthrough/providers/Microsoft.Storage/storageAccounts/azmonstorage001",
  "identity": null,
  "kind": "Storage",
  "lastGeoFailoverTime": null,
  "location": "centralus",
  "name": "azmonstorage001",
  "networkAcls": null,
  "primaryEndpoints": {
    "blob": "https://azmonstorage001.blob.core.windows.net/",
    "file": "https://azmonstorage001.file.core.windows.net/",
    "queue": "https://azmonstorage001.queue.core.windows.net/",
    "table": "https://azmonstorage001.table.core.windows.net/"
  },
  "primaryLocation": "centralus",
  "provisioningState": "Succeeded",
  "resourceGroup": "azmon-rest-api-walkthrough",
  "secondaryEndpoints": null,
  "secondaryLocation": "eastus2",
  "sku": {
    "name": "Standard_GRS",
    "tier": "Standard"
  },
  "statusOfPrimary": "available",
  "statusOfSecondary": "available",
  "tags": {},
  "type": "Microsoft.Storage/storageAccounts"
}
```

> [!NOTE]
> Azure logic apps aren't yet available via the Azure CLI. For this reason, an Azure Storage account is shown in the preceding example.

---

## API endpoints

The API endpoints use the following pattern:

`/<resource URI>/providers/microsoft.insights/<metrics|metricDefinitions>?api-version=<apiVersion>`

The `resource URI` is composed of the following components:

`/subscriptions/<subscription id>/resourcegroups/<resourceGroupName>/providers/<resourceProviderNamespace>/<resourceType>/<resourceName>/`

> [!IMPORTANT]
> Be sure to include `/providers/microsoft.insights/` after the resource URI when you make an API call to retrieve metrics or metric definitions.

## Retrieve metric definitions

Use the [Azure Monitor Metric Definitions REST API](/rest/api/monitor/metricdefinitions) to access the list of metrics that are available for a service. Use the following request format to retrieve metric definitions.

```HTTP
GET /subscriptions/<subscription id>/resourcegroups/<resourceGroupName>/providers/<resourceProviderNamespace>/<resourceType>/<resourceName>/providers/microsoft.insights/metricDefinitions?api-version=<apiVersion>
Host: management.azure.com
Content-Type: application/json
Authorization: Bearer <access token>

```

For example, The following request retrieves the metric definitions for an Azure Storage account:

```curl
curl --location --request GET 'https://management.azure.com/subscriptions/12345678-abcd-98765432-abcdef012345/resourceGroups/azmon-rest-api-walkthrough/providers/Microsoft.Storage/storageAccounts/ContosoStorage/providers/microsoft.insights/metricDefinitions?api-version=2018-01-01'
--header 'Authorization: Bearer eyJ0eXAiOi...xYz
```

The following JSON shows an example response body. In this example, only the second metric has dimensions:

```json
{
    "value": [
        {
            "id": "/subscriptions/12345678-abcd-98765432-abcdef012345/resourceGroups/azmon-rest-api-walkthrough/providers/Microsoft.Storage/storageAccounts/ContosoStorage/providers/microsoft.insights/metricdefinitions/UsedCapacity",
            "resourceId": "/subscriptions/12345678-abcd-98765432-abcdef012345/resourceGroups/azmon-rest-api-walkthrough/providers/Microsoft.Storage/storageAccounts/ContosoStorage",
            "namespace": "Microsoft.Storage/storageAccounts",
            "category": "Capacity",
            "name": {
                "value": "UsedCapacity",
                "localizedValue": "Used capacity"
            },
            "isDimensionRequired": false,
            "unit": "Bytes",
            "primaryAggregationType": "Average",
            "supportedAggregationTypes": [
                "Total",
                "Average",
                "Minimum",
                "Maximum"
            ],
            "metricAvailabilities": [
                {
                    "timeGrain": "PT1H",
                    "retention": "P93D"
                },
                 ...
                {
                    "timeGrain": "PT12H",
                    "retention": "P93D"
                },
                {
                    "timeGrain": "P1D",
                    "retention": "P93D"
                }
            ]
        },
        {
            "id": "/subscriptions/12345678-abcd-98765432-abcdef012345/resourceGroups/azmon-rest-api-walkthrough/providers/Microsoft.Storage/storageAccounts/ContosoStorage/providers/microsoft.insights/metricdefinitions/Transactions",
            "resourceId": "/subscriptions/12345678-abcd-98765432-abcdef012345/resourceGroups/azmon-rest-api-walkthrough/providers/Microsoft.Storage/storageAccounts/ContosoStorage",
            "namespace": "Microsoft.Storage/storageAccounts",
            "category": "Transaction",
            "name": {
                "value": "Transactions",
                "localizedValue": "Transactions"
            },
            "isDimensionRequired": false,
            "unit": "Count",
            "primaryAggregationType": "Total",
            "supportedAggregationTypes": [
                "Total"
            ],
            "metricAvailabilities": [
                {
                    "timeGrain": "PT1M",
                    "retention": "P93D"
                },
                {
                    "timeGrain": "PT5M",
                    "retention": "P93D"
                },
                ...
                {
                    "timeGrain": "PT30M",
                    "retention": "P93D"
                },
                {
                    "timeGrain": "PT1H",
                    "retention": "P93D"
                },
                ...
                {
                    "timeGrain": "P1D",
                    "retention": "P93D"
                }
            ],
            "dimensions": [
                {
                    "value": "ResponseType",
                    "localizedValue": "Response type"
                },
                {
                    "value": "GeoType",
                    "localizedValue": "Geo type"
                },
                {
                    "value": "ApiName",
                    "localizedValue": "API name"
                }
            ]
        },
        ...
    ]
}
```

> [!NOTE]
> We recommend using API version "2018-01-01" or later. Older versions of the metric definitions API don't support dimensions.

## Retrieve dimension values

After the retrieving the available metric definitions, retrieve the range of values for the metric's dimensions. Use dimension values to filter or segment the metrics in your queries. Use the [Azure Monitor Metrics REST API](/rest/api/monitor/metrics) to find all of the values for a given metric dimension.

Use the metric's `name.value` element in the filter definitions. If no filters are specified, the default metric is returned. The API only allows one dimension to have a wildcard filter. 
Specify the request for dimension values using the `"resultType=metadata"` query parameter. The `resultType` is omitted for a metric values request.

> [!NOTE]
> To retrieve dimension values by using the Azure Monitor REST API, use the API version "2019-07-01" or later.

Use the following request format to retrieve dimension values:

```HTTP
GET /subscriptions/<subscription-id>/resourceGroups/
<resource-group-name>/providers/<resource-provider-namespace>/
<resource-type>/<resource-name>/providers/microsoft.insights/
metrics?metricnames=<metric>
&timespan=<starttime/endtime>
&$filter=<filter>
&resultType=metadata
&api-version=<apiVersion> HTTP/1.1
Host: management.azure.com
Content-Type: application/json
Authorization: Bearer <access token>
```

The following example retrieves the list of dimension values that were emitted for the `API Name` dimension of the `Transactions` metric, where the `GeoType` dimension has a value of `Primary`, for the specified time range. 

```curl
curl --location --request GET 'https://management.azure.com/subscriptions/12345678-abcd-98765432-abcdef012345/resourceGroups/azmon-rest-api-walkthrough/providers/Microsoft.Storage/storageAccounts/ContosoStorage/providers/microsoft.insights/metrics \
?metricnames=Transactions \
&timespan=2023-03-01T00:00:00Z/2023-03-02T00:00:00Z \
&resultType=metadata \
&$filter=GeoType eq \'Primary\' and ApiName eq \'*\' \
&api-version=2019-07-01'
-header 'Content-Type: application/json' \
--header 'Authorization: Bearer eyJ0e..meG1lWm9Y'
```

The following JSON shows an example response body:

```json
{
  "timespan": "2023-03-01T00:00:00Z/2023-03-02T00:00:00Z",
  "value": [
    {
      "id": "/subscriptions/12345678-abcd-98765432-abcdef012345/resourceGroups/azmon-rest-api-walkthrough/providers/Microsoft.Storage/storageAccounts/ContosoStorage/providers/Microsoft.Insights/metrics/Transactions",
      "type": "Microsoft.Insights/metrics",
      "name": {
        "value": "Transactions",
        "localizedValue": "Transactions"
      },
      "unit": "Count",
      "timeseries": [
        {
          "metadatavalues": [
            {
              "name": {
                "value": "apiname",
                "localizedValue": "apiname"
              },
              "value": "DeleteBlob"
            }
          ]
        },
        {
          "metadatavalues": [
            {
              "name": {
                "value": "apiname",
                "localizedValue": "apiname"
              },
              "value": "SetBlobProperties"
            }
          ]
        },
        ...
      ]
    }
  ],
  "namespace": "Microsoft.Storage/storageAccounts",
  "resourceregion": "eastus"
}
```

## Retrieve metric values

After retrieving the metric definitions and dimension values, retrieve the metric values. Use the [Azure Monitor Metrics REST API](/rest/api/monitor/metrics) to retrieve the metric values.

Use the metric's `name.value` element in the filter definitions. If no dimension filters are specified, the rolled up, aggregated metric is returned.

### Multiple time series

A time series is a set of data points that are ordered by time for a given combination of dimensions. A dimension is an aspect of the metric that describes the data point such as resource Id, region, or ApiName.

* To fetch multiple time series with specific dimension values, specify a filter query parameter that specifies both dimension values such as `"&$filter=ApiName eq 'ListContainers' or ApiName eq 'GetBlobServiceProperties'"`. In this example, you get a time series where `ApiName` is `ListContainers` and a second time series where `ApiName` is `GetBlobServiceProperties`.

* To return a time series for every value of a given dimension, use an `*` filter such as `"&$filter=ApiName eq '*'"`. Use the `Top` and `OrderBy` query parameters to limit and sort the number of time series returned. In this example, you get a time series for every value of `ApiName`in the result set. If no data is returned, the API returns an empty time series `"timeseries": []`.

> [!NOTE]
> To retrieve multi-dimensional metric values using the Azure Monitor REST API, use the API version "2019-07-01" or later.

Use the following request format to retrieve metric values:

```HTTP
GET /subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/<resource-provider-namespace>/<resource-type>/<resource-name>/providers/microsoft.insights/metrics?metricnames=<metric>&timespan=<starttime/endtime>&$filter=<filter>&interval=<timeGrain>&aggregation=<aggreation>&api-version=<apiVersion>
Host: management.azure.com
Content-Type: application/json
Authorization: Bearer <access token>
```

The following example retrieves the top three APIs, by the number of `Transactions` in descending value order, during a 5-minute range, where the `GeoType` dimension has a value of `Primary`:

```curl
curl --location --request GET 'https://management.azure.com/subscriptions/12345678-abcd-98765432-abcdef012345/resourceGroups/azmon-rest-api-walkthrough/providers/Microsoft.Storage/storageAccounts/ContosoStorage/providers/microsoft.insights/metrics \
?metricnames=Transactions \
&timespan=2023-03-01T02:00:00Z/2023-03-01T02:05:00Z \
& $filter=apiname eq '\''GetBlobProperties'\'
&interval=PT1M \
&aggregation=Total \
&top=3 \
&orderby=Total desc \
&api-version=2019-07-01"' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer yJ0eXAiOi...g1dCI6Ii1LS'
```

The following JSON shows an example response body:

```json
{
  "cost": 0,
  "timespan": "2023-03-01T02:00:00Z/2023-03-01T02:05:00Z",
  "interval": "PT1M",
  "value": [
    {
      "id": "/subscriptions/12345678-abcd-98765432-abcdef012345/resourceGroups/azmon-rest-api-walkthrough/providers/Microsoft.Storage/storageAccounts/ContosoStorage/providers/Microsoft.Insights/metrics/Transactions",
      "type": "Microsoft.Insights/metrics",
      "name": {
        "value": "Transactions",
        "localizedValue": "Transactions"
      },
      "unit": "Count",
      "timeseries": [
        {
          "metadatavalues": [
            {
              "name": {
                "value": "apiname",
                "localizedValue": "apiname"
              },
              "value": "GetBlobProperties"
            }
          ],
          "data": [
            {
              "timeStamp": "2023-09-19T02:00:00Z",
              "total": 2
            },
            {
              "timeStamp": "2023-09-19T02:01:00Z",
              "total": 1
            },
            {
              "timeStamp": "2023-09-19T02:02:00Z",
              "total": 3
            },
            {
              "timeStamp": "2023-09-19T02:03:00Z",
              "total": 7
            },
            {
              "timeStamp": "2023-09-19T02:04:00Z",
              "total": 2
            }
          ]
        },
        ...
      ]
    }
  ],
  "namespace": "Microsoft.Storage/storageAccounts",
  "resourceregion": "eastus"
}
```

## Querying metrics for multiple resources at a time.

In addition to querying for metrics on an individual resource, some resource types also support querying for multiple resources in a single request. These APIs are what power the [multi-resource experience in Azure metrics explorer](../metrics/analyze-metrics.md). The set of resources types that support querying for multiple metrics can be seen on the [Metrics blade in Azure monitor](https://portal.azure.com/#view/Microsoft_Azure_Monitoring/AzureMonitoringBrowseBlade/~/metrics) via the resource type drop-down in the scope selector on the context blade. For more information, see the [multi-resource UX documentation](../metrics/analyze-metrics.md).

There are some important differences between querying metrics for multiple and individual resources.

* Metrics multi-resource APIs operate at the subscription level instead of the resource ID level. This restriction means users querying these APIs must have [Monitoring Reader](/azure/role-based-access-control/built-in-roles#monitoring-reader) permissions on the subscription itself.
* Metrics multi-resource APIs only support a single resourceType per query, which must be specified in the form of a metric namespace query parameter.
* Metrics multi-resource APIs only support a single Azure region per query, which must be specified in the form of a region query parameter.

### Querying metrics for multiple resources examples

The following example shows an individual metric definitions request:

```
GET https://management.azure.com/subscriptions/12345678-abcd-98765432-abcdef012345/resourceGroups/EASTUS-TESTING/providers/Microsoft.Compute/virtualMachines/TestVM1/providers/microsoft.insights/metricdefinitions?api-version=2021-05-01
```

The following request shows the equivalent metric definitions request for multiple resources. The only changes are the subscription path instead of a resource ID path, and the addition of `region` and `metricNamespace` query parameters.

```
GET https://management.azure.com/subscriptions/12345678-abcd-98765432-abcdef012345/providers/microsoft.insights/metricdefinitions?api-version=2021-05-01&region=eastus&metricNamespace=microsoft.compute/virtualmachines
```

The following example shows an individual metrics request:

```
GET https://management.azure.com/subscriptions/12345678-abcd-98765432-abcdef012345/resourceGroups/EASTUS-TESTING/providers/Microsoft.Compute/virtualMachines/TestVM1/providers/microsoft.Insights/metrics?timespan=2023-06-25T22:20:00.000Z/2023-06-26T22:25:00.000Z&interval=PT5M&metricnames=Percentage CPU&aggregation=average&api-version=2021-05-01
```

Below is an equivalent metrics request for multiple resources:

```
GET https://management.azure.com/subscriptions/12345678-abcd-98765432-abcdef012345/providers/microsoft.Insights/metrics?timespan=2023-06-25T22:20:00.000Z/2023-06-26T22:25:00.000Z&interval=PT5M&metricnames=Percentage CPU&aggregation=average&api-version=2021-05-01&region=eastus&metricNamespace=microsoft.compute/virtualmachines&$filter=Microsoft.ResourceId eq '*'
```

> [!NOTE] 
> A `Microsoft.ResourceId eq '*'` filter is added in the example for the multi resource metrics requests. The `*` filter tells the API to return a separate time series for each virtual machine resource that has data in the subscription and region. Without the filter the API would return a single time series aggregating the average CPU for all VMs. The times series for each resource is differentiated by the `Microsoft.ResourceId` metadata value on each time series entry, as can be seen in the following sample return value. If there are no resourceIds retrieved by this query an empty time series`"timeseries": []` is returned.

```JSON
{
    "timespan": "2023-06-25T22:35:00Z/2023-06-26T22:40:00Z",
    "interval": "PT6H",
    "value": [
        {
            "id": "subscriptions/12345678-abcd-98765432-abcdef012345/providers/Microsoft.Insights/metrics/Percentage CPU",
            "type": "Microsoft.Insights/metrics",
            "name": {
                "value": "Percentage CPU",
                "localizedValue": "Percentage CPU"
            },
            "displayDescription": "The percentage of allocated compute units that are currently in use by the Virtual Machine(s)",
            "unit": "Percent",
            "timeseries": [
                {
                    "metadatavalues": [
                        {
                            "name": {
                                "value": "Microsoft.ResourceId",
                                "localizedValue": "Microsoft.ResourceId"
                            },
                            "value": "/subscriptions/12345678-abcd-98765432-abcdef012345/resourceGroups/EASTUS-TESTING/providers/Microsoft.Compute/virtualMachines/TestVM1"
                        }
                    ],
                    "data": [
                        {
                            "timeStamp": "2023-06-25T22:35:00Z",
                            "average": 3.2618888888888886
                        },
                        {
                            "timeStamp": "2023-06-26T04:35:00Z",
                            "average": 4.696944444444445
                        },
                        {
                            "timeStamp": "2023-06-26T10:35:00Z",
                            "average": 6.19701388888889
                        },
                        {
                            "timeStamp": "2023-06-26T16:35:00Z",
                            "average": 2.630347222222222
                        },
                        {
                            "timeStamp": "2023-06-26T22:35:00Z",
                            "average": 21.288999999999998
                        }
                    ]
                },
                {
                    "metadatavalues": [
                        {
                            "name": {
                                "value": "Microsoft.ResourceId",
                                "localizedValue": "Microsoft.ResourceId"
                            },
                            "value": "/subscriptions/12345678-abcd-98765432-abcdef012345/resourceGroups/EASTUS-TESTING/providers/Microsoft.Compute/virtualMachines/TestVM2"
                        }
                    ],
                    "data": [
                        {
                            "timeStamp": "2023-06-25T22:35:00Z",
                            "average": 7.567069444444444
                        },
                        {
                            "timeStamp": "2023-06-26T04:35:00Z",
                            "average": 5.111835883171071
                        },
                        {
                            "timeStamp": "2023-06-26T10:35:00Z",
                            "average": 10.078277777777778
                        },
                        {
                            "timeStamp": "2023-06-26T16:35:00Z",
                            "average": 8.399097222222222
                        },
                        {
                            "timeStamp": "2023-06-26T22:35:00Z",
                            "average": 2.647
                        }
                    ]
                },
                {
                    "metadatavalues": [
                        {
                            "name": {
                                "value": "Microsoft.ResourceId",
                                "localizedValue": "Microsoft.ResourceId"
                            },
                            "value": "/subscriptions/12345678-abcd-98765432-abcdef012345/resourceGroups/Common-TESTING/providers/Microsoft.Compute/virtualMachines/CommonVM1"
                        }
                    ],
                    "data": [
                        {
                            "timeStamp": "2023-06-25T22:35:00Z",
                            "average": 6.892319444444444
                        },
                        {
                            "timeStamp": "2023-06-26T04:35:00Z",
                            "average": 3.5054305555555554
                        },
                        {
                            "timeStamp": "2023-06-26T10:35:00Z",
                            "average": 8.398817802503476
                        },
                        {
                            "timeStamp": "2023-06-26T16:35:00Z",
                            "average": 6.841666666666667
                        },
                        {
                            "timeStamp": "2023-06-26T22:35:00Z",
                            "average": 3.3850000000000002
                        }
                    ]
                }
            ],
            "errorCode": "Success"
        }
    ],
    "namespace": "microsoft.compute/virtualmachines",
    "resourceregion": "eastus"
}
```
 
### Troubleshooting querying metrics for multiple resources

* Empty time series returned `"timeseries": []`

    * An empty time series is returned when no data is available for the specified time range and filter. The most common cause is specifying a time range that doesn't contain any data. For example, if the time range is set to a future date.
    * Another common cause is specifying a filter that doesn't match any resources. For example, if the filter specifies a dimension value that doesn't exist on any resources in the subscription and region combination, `"timeseries": []` is returned. 

* Wildcard filters

    Using a wildcard filter such as `Microsoft.ResourceId eq '*'` causes the API to return a time series for every resourceId in the subscription and region. If the subscription and region combination contains no resources, an empty time series is returned. The same query without the wildcard filter would return a single time series, aggregating the requested metric over the requested dimensions, for example subscription and region.
 
* 401 authorization errors

    The individual resource metrics APIs requires a user have the [Monitoring Reader](/azure/role-based-access-control/built-in-roles#monitoring-reader) permission on the resource being queried. Because the multi resource metrics APIs are subscription level APIs, users must have the [Monitoring Reader](/azure/role-based-access-control/built-in-roles#monitoring-reader) permission for the queried subscription to use the multi resource metrics APIs. Even if users have Monitoring Reader on all the resources in a subscription, the request fails if the user doesn't have Monitoring Reader on the subscription itself.

* 529 throttling errors

    The 529 error code indicates that the metrics backend is currently throttling your requests. The recommended action is to implement an exponential backoff retry scheme. For more information on throttling, see [Understand how Azure Resource Manager throttles requests](/azure/azure-resource-manager/management/request-limits-and-throttling).

## Next steps

* Review the [overview of monitoring](../fundamentals/overview.md).
* View the [supported metrics with Azure Monitor](../reference/metrics-index.md).
* Review the [Microsoft Azure Monitor REST API reference](/rest/api/monitor/).
* Review the new [Azure Monitor Query client libraries](https://devblogs.microsoft.com/azure-sdk/announcing-the-new-azure-monitor-query-client-libraries/)
* Review the [Azure Management Library](/previous-versions/azure/reference/mt417623(v=azure.100)).
* [Retrieve activity log data using Azure monitor REST API](rest-activity-log.md).
