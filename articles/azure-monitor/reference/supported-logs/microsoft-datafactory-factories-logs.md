---
title: Supported log categories - Microsoft.DataFactory/factories
description: Reference for Microsoft.DataFactory/factories in Azure Monitor Logs.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.DataFactory/factories, arm

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported logs for Microsoft.DataFactory/factories

The following table lists the types of logs available for the Microsoft.DataFactory/factories resource type.

For a list of supported metrics, see [Supported metrics - Microsoft.DataFactory/factories](../supported-metrics/microsoft-datafactory-factories-metrics.md)


|Category|Category display name| Log table| [Supports basic log plan](/azure/azure-monitor/logs/basic-logs-configure?tabs=portal-1#compare-the-basic-and-analytics-log-data-plans)|[Supports ingestion-time transformation](/azure/azure-monitor/essentials/data-collection-transformations)| Example queries |Costs to export|
|---|---|---|---|---|---|---|
|`ActivityRuns` |Pipeline activity runs log |[ADFActivityRun](/azure/azure-monitor/reference/tables/adfactivityrun)|No|Yes|[Queries](/azure/azure-monitor/reference/queries/adfactivityrun)|No |
|`AirflowDagProcessingLogs` |Airflow dag processing logs |[AirflowDagProcessingLogs](/azure/azure-monitor/reference/tables/airflowdagprocessinglogs)<p>ADF Airflow dag processing logs|No|Yes||Yes |
|`AirflowSchedulerLogs` |Airflow scheduler logs |[ADFAirflowSchedulerLogs](/azure/azure-monitor/reference/tables/adfairflowschedulerlogs)<p>ADF Airflow scheduler logs|No|Yes||Yes |
|`AirflowTaskLogs` |Airflow task execution logs |[ADFAirflowTaskLogs](/azure/azure-monitor/reference/tables/adfairflowtasklogs)<p>ADF Airflow task logs|No|Yes||Yes |
|`AirflowWebLogs` |Airflow web logs |[ADFAirflowWebLogs](/azure/azure-monitor/reference/tables/adfairflowweblogs)<p>ADF Airflow web logs|No|Yes||Yes |
|`AirflowWorkerLogs` |Airflow worker logs |[ADFAirflowWorkerLogs](/azure/azure-monitor/reference/tables/adfairflowworkerlogs)<p>ADF Airflow worker logs|No|Yes||Yes |
|`PipelineRuns` |Pipeline runs log |[ADFPipelineRun](/azure/azure-monitor/reference/tables/adfpipelinerun)|No|Yes|[Queries](/azure/azure-monitor/reference/queries/adfpipelinerun)|No |
|`SandboxActivityRuns` |Sandbox Activity runs log |[ADFSandboxActivityRun](/azure/azure-monitor/reference/tables/adfsandboxactivityrun)|No|Yes||Yes |
|`SandboxPipelineRuns` |Sandbox Pipeline runs log |[ADFSandboxPipelineRun](/azure/azure-monitor/reference/tables/adfsandboxpipelinerun)|No|Yes||Yes |
|`SSISIntegrationRuntimeLogs` |SSIS integration runtime logs |[ADFSSISIntegrationRuntimeLogs](/azure/azure-monitor/reference/tables/adfssisintegrationruntimelogs)<p>ADF SSIS integration runtime logs|No|Yes||No |
|`SSISPackageEventMessageContext` |SSIS package event message context |[ADFSSISPackageEventMessageContext](/azure/azure-monitor/reference/tables/adfssispackageeventmessagecontext)<p>ADF SSIS package execution event message context|No|Yes||No |
|`SSISPackageEventMessages` |SSIS package event messages |[ADFSSISPackageEventMessages](/azure/azure-monitor/reference/tables/adfssispackageeventmessages)<p>ADF SSIS package execution event messages|No|Yes||No |
|`SSISPackageExecutableStatistics` |SSIS package executable statistics |[ADFSSISPackageExecutableStatistics](/azure/azure-monitor/reference/tables/adfssispackageexecutablestatistics)<p>ADF SSIS package execution executable statistics|No|Yes||No |
|`SSISPackageExecutionComponentPhases` |SSIS package execution component phases |[ADFSSISPackageExecutionComponentPhases](/azure/azure-monitor/reference/tables/adfssispackageexecutioncomponentphases)<p>ADF SSIS package execution component phases|No|Yes||No |
|`SSISPackageExecutionDataStatistics` |SSIS package exeution data statistics |[ADFSSISPackageExecutionDataStatistics](/azure/azure-monitor/reference/tables/adfssispackageexecutiondatastatistics)<p>ADF SSIS package execution data statistics|No|Yes||No |
|`TriggerRuns` |Trigger runs log |[ADFTriggerRun](/azure/azure-monitor/reference/tables/adftriggerrun)|No|Yes|[Queries](/azure/azure-monitor/reference/queries/adftriggerrun)|No |

## Next Steps

* [Learn more about resource logs](/azure/azure-monitor/essentials/platform-logs-overview)
* [Stream resource logs to Event Hubs](/azure/azure-monitor/essentials/resource-logs#send-to-azure-event-hubs)
* [Change resource log diagnostic settings using the Azure Monitor REST API](/rest/api/monitor/diagnosticsettings)
* [Analyze logs from Azure storage with Log Analytics](/azure/azure-monitor/essentials/resource-logs#send-to-log-analytics-workspace)
* [Optimize log queries in Azure Monitor](/azure/azure-monitor/logs/query-optimization)
* [Aggregate data in a Log Analytics workspace by using summary rules (Preview)](/azure/azure-monitor/logs/summary-rules)
