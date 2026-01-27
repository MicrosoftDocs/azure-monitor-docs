---
title: Configure Azure Monitor pipeline transformations
description: Configure Azure Monitor pipeline transformations to filter and manipulate log data before it's sent to Azure Monitor in the cloud.
ms.topic: article
ms.date: 01/15/2026
ms.custom: references_regions, devx-track-azurecli
---


# Azure Monitor pipeline transformations

Azure Monitor pipeline data transformations allow you to filter and manipulate log data before it's sent to Azure Monitor in the cloud. Transformations enable you to structure incoming data according to your analytics needs, ensuring that only relevant information is sent to Azure Monitor and that it's in an appropriate format to be processed.

Benefits of using pipeline transformations include:

- **Lower costs:** Filter and aggregate data to reduce ingestion volume and in turn lower ingestion costs 
- **Better analytics:** Standardized schemas for faster queries and cleaner dashboards.
- **Future proof:** Built-in schema validation prevents surprises during deployment.

Azure Monitor pipeline solves the challenges of high ingestion costs and complex analytics by enabling transformations before ingestion, so your data is clean, structured, and optimized before it even hits your Log Analytics Workspace. 


## Basic query structure
Like Azure Monitor transformations, all pipeline transformation queries start with `source`, which is a virtual table that represents the input stream. You can then use any supported KQL operators to filter, modify, or add columns to the data as you would with any other table. The query is applied individually to each entry sent by the data source.

See [Basic query structure](./data-collection-transformations-create.md#basic-query-structure) for more details on the query structure and supported operators.

## Define a transformation
Pipeline transformations are defined as part of a dataflow. You can configure them using either the Azure portal or ARM templates. You can define your own custom transformation or use prebuilt templates for common patterns. Syntax validation, such as checking KQL expressions, is available to help ensure accuracy before saving your configuration. These capabilities allow for flexible and powerful data shaping directly within your monitoring infrastructure.

### [Azure portal](#tab/portal)

To define a transformation in the Azure portal, select **Add Data Transformations**, which opens the transformation editor. Select a template which provides predefined queries for common scenarios. Use the template as a starting point and modify the KQL query as needed to fit your requirements. Use the **Custom** template to start with a blank query.

:::image type="content" source="./media/pipeline-transformations/template.png" lightbox="./media/pipeline-transformations/template.png" alt-text="Screenshot of template selection for a transformation.":::

Once you have the query defined, click **Check KQL syntax**.

### [ARM](#tab/arm)

The transformation is defined in the `processors` section of the data flow in the ARM template. The `type` of the processor must be set to `TransformLanguage`, and the KQL query is specified in the `transformLanguage/transformStatement` property. The processor is then referenced in the `service/pipelines` section of the data flow configuration.

The following example shows a transformation that filters out syslog records with a `Facility` of `auth`. 

```json
"processors": [
    {
        "type": "TransformLanguage",
        "name": "facility-filter",
        "transformLanguage": {
            "transformStatement": "source | where Facility != 'auth'"
        }
    }
]
```

This processor would then be referenced in the `service/pipelines` section similar to the following:

```json
    "service": {
        "pipelines": [
            {
                "name": "FilteredSyslogs",
                "receivers": [
                    "receiver-Syslog"
                ],
                "processors": [
                    "facility-filter"
                ],
                "exporters": [
                    "exporter-log-analytics-workspace"
                ],
                "type": "logs"
            }
        ]
    }
```

See [Configure Azure Monitor pipeline](./pipeline-configure.md) for more details and examples of the processor configuration file.

---

## Aggregations
An aggregation in KQL summarizes data from multiple records into a single record based on specified criteria. For example, you can aggregate log entries to calculate the average value of numeric property or count the number of occurrences of specific events over a defined time period. Aggregations help reduce data volume and provide insights by condensing large datasets into meaningful summaries.

Data in Azure Monitor pipeline is retrieved and processed in batches of one minute intervals by default. Aggregations in a pipeline transformation are performed over each batch of data meaning that an aggregated record will be created each minute. To change this time window, you can configure the `Batch` processor in the pipeline configuration as described in [Pipeline configuration](./pipeline-configure.md#pipeline-configuration). You can't change the time interval using the Azure portal.

> [!NOTE]
> When using the `summarize` operator for aggregation, an automatic latency of up to 5 minutes may be introduced due to batching in the UI.
>
> If an aggregation includes bin(), you may receive multiple records for the same time interval. This occurs because of batching and the streaming nature of data ingestion.


Aggregations are defined using the [summarize](/kusto/query/summarize-operator) operator in KQL. You specify the aggregation functions and the grouping criteria. For example, the following query counts the number of events collected over the past minute grouped by `DestinationIP` and `DestinationPort`:

```kusto
source 
| summarize EventCount=count() by DestinationIP, DestinationPort
```

The following example extracts CPU usage values from syslog messages, then calculates the average and maximum CPU usage over one-minute intervals:

```kusto
source
| where Facility == "daemon"
| where SyslogMessage has "CPU="
| parse SyslogMessage with * "CPU=" CPUValue:int * 
| summarize AvgCPU = avg(CPUValue), MaxCPU = max(CPUValue)
```

## Supported KQL
Expand the following sections for KQL functions and operators are supported in Azure Monitor pipeline transformations:

<details>
<summary><b>Aggregations</b></summary>

- `sum()`
- `max()`
- `min()`
- `avg()`
- `count()`
- `bin()`

</details>

<details>
<summary><b>Filtering</b></summary>

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

</details>

<details>
<summary><b>Schematization</b></summary>

- `extend`
- `project`
- `project-away`
- `project-rename`
- `project-keep`
- `iif`
- `case`
- `coalesce`
- `parse_json`

</details>

<details>
<summary><b>Functions</b></summary>

- `let`

</details>

<details>
<summary><b>String functions</b></summary>

- `strlen`
- `replace_string`
- `substring`
- `strcat`
- `strcat_delim`
- `extract`

</details>

<details>
<summary><b>Conversion</b></summary>

- `tostring`
- `toint`
- `tobool`
- `tofloat`
- `tolong`
- `toreal`
- `todouble`
- `todatetime`
- `totimespan`

</details>


## Next steps

* [Read more about data collection rules (DCRs) in Azure Monitor](data-collection-rule-overview.md).
