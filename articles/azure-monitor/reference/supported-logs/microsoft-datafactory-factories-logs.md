---
title: Supported log categories - Microsoft.DataFactory/factories
description: Reference for Microsoft.DataFactory/factories in Azure Monitor Logs.
ms.topic: generated-reference
ms.date: 08/21/2026
ms.custom: Microsoft.DataFactory/factories, arm

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported logs for Microsoft.DataFactory/factories

The following table lists the types of logs available for the Microsoft.DataFactory/factories resource type.

For a list of supported metrics, see [Supported metrics - Microsoft.DataFactory/factories](../supported-metrics/microsoft-datafactory-factories-metrics.md)


|Category|Costs to export|Log table|[Supports basic log plan](/azure/azure-monitor/logs/basic-logs-configure?tabs=portal-1#compare-the-basic-and-analytics-log-data-plans)|[Supports ingestion-time transformation](/azure/azure-monitor/essentials/data-collection-transformations)|Example queries|
|---|---|---|---|---|---|
|ActivityRuns|No|[ADFActivityRun](/azure/azure-monitor/reference/tables/adfactivityrun)|No|Yes|[Queries](/azure/azure-monitor/reference/queries/adfactivityrun)|
|AirflowDagProcessingLogs|Yes|[AirflowDagProcessingLogs](/azure/azure-monitor/reference/tables/airflowdagprocessinglogs)<p>ADF Airflow dag processing logs|No|Yes||
|AirflowSchedulerLogs|Yes|[ADFAirflowSchedulerLogs](/azure/azure-monitor/reference/tables/adfairflowschedulerlogs)<p>ADF Airflow scheduler logs|No|Yes||
|AirflowTaskLogs|Yes|[ADFAirflowTaskLogs](/azure/azure-monitor/reference/tables/adfairflowtasklogs)<p>ADF Airflow task logs|No|Yes||
|AirflowWebLogs|Yes|[ADFAirflowWebLogs](/azure/azure-monitor/reference/tables/adfairflowweblogs)<p>ADF Airflow web logs|No|Yes||
|AirflowWorkerLogs|Yes|[ADFAirflowWorkerLogs](/azure/azure-monitor/reference/tables/adfairflowworkerlogs)<p>ADF Airflow worker logs|No|Yes||
|PipelineRuns|No|[ADFPipelineRun](/azure/azure-monitor/reference/tables/adfpipelinerun)|No|Yes|[Queries](/azure/azure-monitor/reference/queries/adfpipelinerun)|
|SandboxActivityRuns|Yes|[ADFSandboxActivityRun](/azure/azure-monitor/reference/tables/adfsandboxactivityrun)|No|Yes||
|SandboxPipelineRuns|Yes|[ADFSandboxPipelineRun](/azure/azure-monitor/reference/tables/adfsandboxpipelinerun)|No|Yes||
|SSISIntegrationRuntimeLogs|No|[ADFSSISIntegrationRuntimeLogs](/azure/azure-monitor/reference/tables/adfssisintegrationruntimelogs)<p>ADF SSIS integration runtime logs|No|Yes||
|SSISPackageEventMessageContext|No|[ADFSSISPackageEventMessageContext](/azure/azure-monitor/reference/tables/adfssispackageeventmessagecontext)<p>ADF SSIS package execution event message context|No|Yes||
|SSISPackageEventMessages|No|[ADFSSISPackageEventMessages](/azure/azure-monitor/reference/tables/adfssispackageeventmessages)<p>ADF SSIS package execution event messages|No|Yes||
|SSISPackageExecutableStatistics|No|[ADFSSISPackageExecutableStatistics](/azure/azure-monitor/reference/tables/adfssispackageexecutablestatistics)<p>ADF SSIS package execution executable statistics|No|Yes||
|SSISPackageExecutionComponentPhases|No|[ADFSSISPackageExecutionComponentPhases](/azure/azure-monitor/reference/tables/adfssispackageexecutioncomponentphases)<p>ADF SSIS package execution component phases|No|Yes||
|SSISPackageExecutionDataStatistics|No|[ADFSSISPackageExecutionDataStatistics](/azure/azure-monitor/reference/tables/adfssispackageexecutiondatastatistics)<p>ADF SSIS package execution data statistics|No|Yes||
|TriggerRuns|No|[ADFTriggerRun](/azure/azure-monitor/reference/tables/adftriggerrun)|No|Yes|[Queries](/azure/azure-monitor/reference/queries/adftriggerrun)|

## Next Steps

* [Learn more about resource logs](/azure/azure-monitor/essentials/platform-logs-overview)
* [Stream resource logs to Event Hubs](/azure/azure-monitor/essentials/resource-logs#send-to-azure-event-hubs)
* [Change resource log diagnostic settings using the Azure Monitor REST API](/rest/api/monitor/diagnosticsettings)
* [Analyze logs from Azure storage with Log Analytics](/azure/azure-monitor/essentials/resource-logs#send-to-log-analytics-workspace)
* [Optimize log queries in Azure Monitor](/azure/azure-monitor/logs/query-optimization)
* [Aggregate data in a Log Analytics workspace by using summary rules (Preview)](/azure/azure-monitor/logs/summary-rules)
