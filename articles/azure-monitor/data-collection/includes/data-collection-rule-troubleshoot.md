---
ms.topic: include
ms.date: 05/21/2025
---

## Verify and troubleshoot data collection

Once you install the DCR, it may take several minutes for the changes to take effect and data to be collected with the updated DCR. If you don't see any data being collected, use the [DCR monitoring](../data-collection-monitor.md) features, which include metrics and logs to help troubleshooting.

[DCR metrics](../data-collection-monitor.md#dcr-metrics) are collected automatically for all DCRs, and you can analyze them using metrics explorer like the platform metrics for other Azure resources. Enable [DCR error logs](../data-collection-monitor.md#enable-dcr-error-logs) to get detailed error information when data processing isn't successful.

- Check metrics such as `Logs Ingestion Bytes per Min` and `Logs Rows Received per Min` to ensure that the data is reaching Azure Monitor. If not, then check your data source to ensure that it's sending data as expected.
- Check `Logs Rows Dropped per Min` to see if any rows are being dropped. This may not indicate an error since the rows could be dropped by a transformation. If the rows dropped is the same as `Logs Rows Dropped per Min` though, then no data gets ingested in the workspace. Examine the `Logs Transformation Errors per Min` to see if there are any transformation errors.
- Check `Logs Transformation Errors per Min` to determine if there are any errors from transformations applied to the incoming data. This could be due to changes in the data structure or the transformation itself.
- Check the `DCRLogErrors` table for any ingestion errors that may have been logged. This can provide additional detail in identifying the root cause of the issue.