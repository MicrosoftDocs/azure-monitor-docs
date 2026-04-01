---
title: Configure Azure Monitor pipeline transformations
description: Configure Azure Monitor pipeline transformations to filter and manipulate log data before it's sent to Azure Monitor in the cloud.
ms.topic: article
ms.date: 01/15/2026
ms.custom: references_regions, devx-track-azurecli
---


# Azure Monitor pipeline transformations

Azure Monitor pipeline data transformations let you filter and manipulate log data before sending it to Azure Monitor in the cloud. Transformations help you structure incoming data according to your analytics needs, ensuring that only relevant information is sent to Azure Monitor and that it's in an appropriate format for processing.

Benefits of using pipeline transformations include:

- **Lower costs:** Filter and aggregate data to reduce ingestion volume which lowers ingestion costs.
- **Better analytics:** Standardized schemas for faster queries and cleaner dashboards.
- **Future-proof:** Built-in schema validation helps prevent surprises during deployment.

Azure Monitor pipeline transformations address the challenges of high ingestion costs and complex analytics by reducing data volume before ingestion. Your data is clean, structured, and optimized before it even reaches your Log Analytics Workspace. 


## Basic query structure
Like Azure Monitor transformations, all pipeline transformation queries start with `source`, which is a virtual table that represents the input stream. You can then use any supported KQL operators to filter, modify, or add columns to the data as you would with any other table. The query is applied individually to each entry sent by the data source.

For more details on the query structure and supported operators, see [Basic query structure](./data-collection-transformations-create.md#basic-query-structure).

## Define a transformation
You define pipeline transformations as part of a dataflow. Configure them by using either the Azure portal or ARM templates. Define your own custom transformation or use prebuilt templates for common patterns. Syntax validation, such as checking KQL expressions, is available to help ensure accuracy before saving your configuration. These capabilities provide flexible and powerful data shaping directly within your monitoring infrastructure.

### [Azure portal](#tab/portal)

To define a transformation in the Azure portal, select **Add Data Transformations**. From the transformation editor, select a template that provides predefined queries for common scenarios. Use the template as a starting point and modify the KQL query as needed to fit your requirements. Use the **Custom** template to start with a blank query.

:::image type="content" source="./media/pipeline-transformations/template.png" lightbox="./media/pipeline-transformations/template.png" alt-text="Screenshot of template selection for a transformation.":::

After you define the query, select **Check KQL syntax** to validate the syntax of the query before saving the dataflow. For syslog and CEF data, the checker also verifies that the data resulting from the transformation matches the schema of the table the data is sent to. If the transformation renames or adds columns as part of an aggregation, for example, you're prompted to either remove those transformations or send the data to a custom table instead. An example is shown in the following image.

:::image type="content" source="./media/pipeline-configure/check-syntax.gif" lightbox="./media/pipeline-configure/check-syntax.gif" alt-text="Screenshot of KQL syntax checker and typical error message.":::

### [ARM](#tab/arm)

Define the transformation in the `processors` section of the data flow in the ARM template. Set the `type` of the processor to `TransformLanguage`. Specify the KQL query in the `transformLanguage/transformStatement` property. Reference the processor in the `service/pipelines` section of the data flow configuration.

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

Reference this processor in the `service/pipelines` section similar to the following:

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

For more details and examples of the processor configuration file, see [Configure Azure Monitor pipeline](./pipeline-configure.md).

---

## Aggregations
An aggregation in KQL summarizes data from multiple records into a single record based on specified criteria. For example, you can aggregate log entries to calculate the average value of a numeric property or count the number of occurrences of specific events over a defined time period. Aggregations help reduce data volume and provide insights by condensing large datasets into meaningful summaries.

Azure Monitor retrieves and processes data in batches of one-minute intervals by default. Aggregations form in a pipeline transformation over each batch of data, so the process creates an aggregated record each minute. To change this time window, configure the `Batch` processor in the pipeline configuration as described in [Pipeline configuration](./pipeline-configure-cli.md#create-the-pipeline-configuration). You can't change the time interval by using the Azure portal.

Define aggregations by using the [`summarize`](/kusto/query/summarize-operator) operator in KQL. Specify the aggregation functions and the grouping criteria. For example, the following query counts the number of events collected over the past minute grouped by `DestinationIP` and `DestinationPort`:

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

### Aggregation notes

- When you use the `summarize` operator for aggregation, batching in the pipeline introduces an automatic latency of up to five minutes before seeing the results in the UI.
- You always need a [batch processor](./pipeline-configure-cli.md#create-the-pipeline-configuration) to perform aggregations. Modify the batch processor to change the aggregation interval. Avoid using batch processor to send data with minimum latency. 
- If an aggregation includes `bin()`, you might receive multiple records for the same time interval. This result occurs because of batching and the streaming nature of data ingestion.
- Transformations work on fully formed Syslog or CEF data. If the transformation alters the schema, send the data to a custom table. When you create the transformation by using the Azure portal, the only columns exposed are `SeverityText`, `Body`, and `TimeGenerated`.




## Supported KQL

Expand the following sections for KQL functions and operators that are supported in Azure Monitor pipeline transformations:

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


## Related articles

- Set up the service in [Configure Azure Monitor pipeline](./pipeline-configure.md).
- Configure transformations in the Azure portal by using [Configure Azure Monitor pipeline with the Azure portal](./pipeline-configure-portal.md).
- Configure transformations by using templates in [Configure Azure Monitor pipeline with CLI or ARM templates](./pipeline-configure-cli.md).
- Read more about schemas and streams in [Data collection rules (DCRs) in Azure Monitor](data-collection-rule-overview.md).
