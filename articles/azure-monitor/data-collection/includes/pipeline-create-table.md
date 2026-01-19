---
ms.topic: include
ms.date: 01-19-2026
---

## Create table in Log Analytics workspace

Before you configure the data collection process for the pipeline, any destination tables in the Log Analytics workspace must already exist. If you're sending data to a custom table, then you need to create that table before you can create any data flows that send to it. The schema of the table must match the data that it receives. There are multiple steps in the collection process where you can modify the incoming data, so the table schema doesn't need to match the source data that you're collecting. The only requirement for the table in the Log Analytics workspace is that it has a `TimeGenerated` column.

See [Add or delete tables and columns in Azure Monitor Logs](../logs/create-custom-table.md) for details on different methods for creating a table. For example, use the CLI command below to create a table with the three columns called `Body`, `TimeGenerated`, and `SeverityText`.

```azurecli
az monitor log-analytics workspace table create --workspace-name my-workspace --resource-group my-resource-group --name my-table_CL --columns TimeGenerated=datetime Body=string SeverityText=string
```