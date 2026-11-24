---
title: Configure Azure Monitor pipeline transformations
description: Configure Azure Monitor pipeline transformations to filter and manipulate log data before it's sent to Azure Monitor in the cloud.
ai-usage: ai-assisted
ms.topic: article
ms.date: 11/23/2026
ms.custom: references_regions, devx-track-azurecli
---


# Azure Monitor pipeline transformations

If you need to reduce the volume of data sent to Azure Monitor, clean up incoming records, or change data into a format that works better for analysis, transform the data before it leaves your cluster. Azure Monitor pipeline transformations let you filter, aggregate, and modify incoming log data in the pipeline before sending it to the cloud.

> [!IMPORTANT]
> Pipeline KQL transformations apply only to log data sources: Syslog, CEF, and OpenTelemetry logs. They don't apply to OpenTelemetry metrics or traces.

This article shows how to configure transformations in a DCR by using an ARM template. It also explains how aggregations work and which KQL operators Azure Monitor pipeline transformations support. For existing portal or PipelineGroup deployments, see [Legacy transformations](./pipeline-configure-legacy.md#legacy-transformations).

## Basic query structure
Like Azure Monitor transformations, all pipeline transformation queries start with `source`, which is a virtual table that represents the input stream. You can then use any supported KQL operators to filter, modify, or add columns to the data as you would with any other table. The query is applied individually to each entry sent by the data source.

For more details on the query structure and supported operators, see [Basic query structure](./data-collection-transformations-create.md#basic-query-structure).

## Define a transformation
You define pipeline transformations as part of a dataflow. Define your own custom transformation or use prebuilt templates for common patterns. Syntax validation, such as checking KQL expressions, is available to help ensure accuracy before saving your configuration. These capabilities provide flexible and powerful data shaping directly within your monitoring infrastructure.

### Configure a transformation in an ARM template

Add a named transformation to `properties.transformations` in the dataflow DCR. For example, the following fragment filters out Syslog records from the `auth` facility:

```json
{
  "transformations": [
    {
      "name": "filterAuth",
      "headerProcessor": {
        "processor": "header.SyslogFullyFormed"
      },
      "processors": [
        {
          "processor": "transform.KQL",
          "configuration": {
            "expression": "source | where Facility != 'auth'"
          }
        }
      ]
    }
  ]
}
```

Set `properties.dataSources.syslog[].transform` to `"filterAuth"` on the Syslog source that uses this transformation. Retain that source's `mode`, `streams`, and `endpointRouting`, and keep the DCR's destinations, data flows, and endpoint-routing references.

An explicit transformation replaces implicit normalization. The `header.SyslogFullyFormed` step preserves the Syslog normalization before the KQL filter runs. Use a transformation appropriate to the source's schema rather than applying this Syslog header to other signal types.

### Filter OpenTelemetry logs

Use the `header.OtelLogs` header processor to normalize native OpenTelemetry (OTel) logs into the fields available to the KQL transformation. Define a named transformation in `properties.transformations`, and select it from `properties.dataSources.otelLogs[].transform`.

The following fragment keeps OTel log records with an INFO or higher `severity_number` and drops TRACE and DEBUG records. It also copies all resource attributes to `OTelLogs.ResourceAttributes`:

```json
{
  "transformations": [
    {
      "name": "filterVerboseOtelLogs",
      "headerProcessor": {
        "processor": "header.OtelLogs"
      },
      "processors": [
        {
          "processor": "transform.KQL",
          "configuration": {
            "expression": "source | where severity_number >= 9"
          }
        }
      ]
    }
  ],
  "dataSources": {
    "otelLogs": [
      {
        "name": "otelLogs",
        "mode": "pipeline",
        "enrichWithResourceAttributes": [
          "*"
        ],
        "streams": [
          "Microsoft-OTel-Logs"
        ],
        "endpointRouting": [
          "otlp-grpc"
        ],
        "transform": "filterVerboseOtelLogs"
      }
    ]
  }
}
```

Merge the fragment into the OTel dataflow DCR's `properties` object. Retain its destinations, data flows, and endpoint-routing reference. The transformation affects only the OTel logs source that selects it. Use an explicit attribute-name array instead of `["*"]` when you need only selected resource attributes. Don't add `transform` to `otelMetrics` or `otelTraces`; KQL transformations aren't supported for those signal types.

Use the normalized fields exposed by `header.OtelLogs`, such as `severity_number`, in the transformation expression. Destination columns in the [`OTelLogs` table schema](../reference/tables/otellogs.md), such as `SeverityNumber`, aren't necessarily valid transformation input field names. Test the expression with representative records before deployment and verify the output in the destination table.

### Configure a transformation for an existing portal deployment

> [!IMPORTANT]
> The Azure portal uses legacy PipelineGroup configuration. Use it only to manage an existing deployment. Configure all new deployments with DCRs and ARM templates.

In the Azure portal, select **Add Data Transformations**. From the transformation editor, select a template that provides predefined queries for common scenarios. Use the template as a starting point and modify the KQL query as needed. Use the **Custom** template to start with a blank query.

:::image type="content" source="./media/pipeline-transformations/template.png" lightbox="./media/pipeline-transformations/template.png" alt-text="Screenshot of template selection for a transformation.":::

After you define the query, select **Check KQL syntax** before saving the dataflow. For Syslog and CEF data, the checker also verifies that the transformed output matches the destination table schema. If the transformation renames or adds columns as part of an aggregation, send the data to a custom table.

:::image type="content" source="./media/pipeline-configure/check-syntax.gif" lightbox="./media/pipeline-configure/check-syntax.gif" alt-text="Screenshot of KQL syntax checker and a typical error message.":::

## Aggregations
An aggregation in KQL summarizes data from multiple records into a single record based on specified criteria. For example, you can aggregate log entries to calculate the average value of a numeric property or count the number of occurrences of specific events over a defined time period. Aggregations help reduce data volume and provide insights by condensing large datasets into meaningful summaries.

Aggregations run over batches of data rather than individual records. The batch interval determines the aggregation window. For example, a one-minute batch interval creates an aggregated record each minute.

For deployments described in the [legacy transformation guide](./pipeline-configure-legacy.md#legacy-transformations), aggregation requires a `Batch` step before the transformation. Those deployments use one-minute batches by default. Change **Batch interval** by updating `batch.timeout` in the ARM template; the Azure portal can't change that interval. The legacy guide retains the ARM template examples for this configuration. Don't copy the legacy `Batch` configuration into a DCR; use named DCR transformations as shown earlier for DCR-based deployments.

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

- When you use the `summarize` operator for aggregation, batching in the pipeline introduces an automatic latency of up to five minutes.
- For earlier deployments, keep the required `Batch` step before an aggregation and configure its interval in the ARM template. Account for batching latency when you evaluate data freshness.
- If an aggregation includes `bin()`, you might receive multiple records for the same time interval. This result occurs because of batching and the streaming nature of data ingestion.
- If the transformation alters the schema of Syslog or CEF data, send the data to a custom table. When you create the transformation by using the Azure portal, the only columns exposed are `SeverityText`, `Body`, and `TimeGenerated`.




## Supported KQL

Expand the following sections for KQL functions and operators that Azure Monitor pipeline transformations support:

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
- Manage transformations in an existing portal deployment by using [Manage a legacy Azure Monitor pipeline deployment in the Azure portal](./pipeline-configure-portal.md).
- Learn more about schemas and streams in [Data collection rules (DCRs) in Azure Monitor](data-collection-rule-overview.md).
