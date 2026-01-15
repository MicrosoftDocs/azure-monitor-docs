---
title: Configure Azure Monitor pipeline transformations
description: Configure Azure Monitor pipeline transformations to filter and manipulate log data before it's sent to Azure Monitor in the cloud.
ms.topic: article
ms.date: 01/15/2026
ms.custom: references_regions, devx-track-azurecli
---


# Azure Monitor pipeline transformations

Azure Monitor pipeline data transformations allow you to filter and manipulate log data before it's sent to Azure Monitor in the cloud. Transformations enable you to structure incoming data according to your analytics needs, ensuring that only relevant information is sent to Azure Monitor and that it's in an appropriate format to be processed.

Specific uses for pipeline transformations include:

- Filter records and columns to drop noise and reduce size of data sent to Azure Monitor
- Aggregate data to summarize high-volume logs into actionable insights 
- Modify schema of incoming data to match required format for ingestion


## Comparison to Azure Monitor transformations

Azure Monitor pipeline data transformations provide similar functionality as [data transformations](./data-collection-transformations.md) in Azure Monitor. Both allow you to apply a KQL query to incoming data to filter or modify that data before it's sent to the next to the next step in the data flow.

Azure Monitor transformations are run after the data is received by Azure Monitor but before it's ingested in the Log Analytics workspace. Azure Monitor pipeline transformations are applied earlier in the data flow, allowing for data shaping and filtering before the data is sent to Azure Monitor. This makes pipeline transformations useful for reducing data volume and network bandwidth when sending data from edge or multicloud environments.

The following table summarizes the key differences between Azure Monitor pipeline transformations and Azure Monitor transformations:

| Feature | Azure Monitor Pipeline Transformations | Azure Monitor Transformations |
|:---|:---|:---|
| When applied | Before data is sent to Azure Monitor | After data is received by Azure Monitor.<br>Before it's stored in Log Analytics workspace |
| Definition | Defined in data flows in Azure Monitor pipeline | Defined in Data Collection Rules (DCRs) in Azure Monitor |
| Language | Kusto Query Language (KQL) | Kusto Query Language (KQL) |
| Aggregations supported? | Yes | No |
| Template supported? | Yes | No |

The data that's ingested into Azure Monitor is a combination of the pipeline transformation and any subsequent Azure Monitor transformations. The only requirement is that the output schema of the pipeline transformation must match the input schema expected by the Azure Monitor transformation. While you can filter data in either transformation, it's generally more efficient to filter data in the pipeline transformations since this reduces the amount of data sent over the network.

## Basic query structure
Like Azure Monitor transformations, all pipeline transformation queries start with `source`, which is a virtual table that represents the input stream. You can then use any supported KQL operators to filter, modify, or add columns to the data as you would with any other table. The query is applied individually to each entry sent by the data source.

See [Basic query structure](./data-collection-transformations-create.md#basic-query-structure) for more details on the query structure and supported operators.

## Define a transformation
Pipeline transformations are defined as part of a dataflow. You can configure them using either the Azure portal or ARM templates. You can define your own custom transformation or use prebuilt templates for common patterns. Syntax validation, such as checking KQL expressions, is available to help ensure accuracy before saving your configuration. These capabilities allow for flexible and powerful data shaping directly within your monitoring infrastructure.

### [Azure portal](#tab/portal)

To define a transformation in the Azure portal, select **Add Data Transformations**, which opens the transformation editor. You can either create a custom transformation by writing your own KQL query or select from a list of predefined templates for common scenarios. Use the template as a starting point and modify the KQL query as needed to fit your requirements.

:::image type="content" source="./media/pipeline-transformations/template.png" lightbox="./media/pipeline-transformations/template.png" alt-text="Screenshot of template selection for a transformation.":::

Once you have the query defined, click **Check KQL syntax**.

### [ARM](#tab/arm)

The transformation is defined in the `processors` section of the data flow in the ARM template. 

```json
"processors": [
        {
            "type": "MicrosoftSyslog",
            "name": "ms-syslog-processor"
        },
        {
            "type": "TransformLanguage",
            "name": "facility-filter",
            "transformLanguage": {
                "transformStatement": "source | where Facility != 'auth'"
            }
        }
    ],
```

---

## Aggregations
An aggregation in KQL summarizes data from multiple records into a single record based on specified criteria. For example, you can aggregate log entries to calculate the average value of numeric property or count the number of occurrences of specific events over a defined time period. Aggregations help reduce data volume and provide insights by condensing large datasets into meaningful summaries.

> [!NOTE]
> Aggregations are not supported in Azure Monitor transformations; they are only available in pipeline transformations.

Aggregations are defined using the [summarize](/kusto/query/summarize-operator) operator in KQL. You specify the aggregation functions and the grouping criteria. To perform time-based aggregations, you typically use the `bin()` function to group data into fixed time intervals.

For example, the 

```kusto
source 
| summarize EventCount=count() by TimeGenerated=bin(TimeGenerated, 1m), DestinationIP, DestinationPort
```


The default time interval for aggregations is 1 minute, meaning that all records within each one-minute window are grouped together for aggregation. This is the only time interval supported in the Azure portal. To specify different time intervals, you must use ARM templates.

## Supported KQL

### Aggregations

- `sum()`
- `max()`
- `min()`
- `avg()`
- `count()`
- `bin()`

### Filtering

- `where`
- `contains`
- `has`
- `in`
- `and`
- `or`
- `==`
- `!=`
- `>`
- `>=`
- `<`
- `<=`

### Schematization

- `extend`
- `project`
- `project-away`
- `project-rename`
- `project-keep`
- `iif`
- `case`
- `coalesce`
- `parse_json`

### Functions

- `let`

### String functions

- `strlen`
- `replace_string`
- `substring`
- `strcat`
- `strcat_delim`
- `extract`

### Conversion

- `tostring`
- `toint`
- `tobool`
- `tofloat`
- `tolong`
- `toreal`
- `todouble`
- `todatetime`
- `totimespan`

## Next steps

* [Read more about data collection rules (DCRs) in Azure Monitor](data-collection-rule-overview.md).
