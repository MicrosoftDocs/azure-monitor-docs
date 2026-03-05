---
title: Troubleshoot issues with the Log Analytics agent for Windows
description: Describe the symptoms, causes, and resolution for the most common issues with the Log Analytics agent for Windows in Azure Monitor.
ms.topic: troubleshooting-general
ms.custom: devx-track-azurecli
ms.date: 11/14/2024
ms.reviewer: JeffWo
---

# Troubleshoot issues with the Log Analytics agent for Windows

This article helps you troubleshoot errors you might experience with the Log Analytics agent for Windows in Azure Monitor. It suggests possible solutions to resolve them.

## Log Analytics Troubleshooting Tool

The Log Analytics agent for Windows Troubleshooting Tool is a collection of PowerShell scripts that help you find and diagnose problems with the Log Analytics agent. The agent installation automatically includes the tool. Running the tool should be your first step in diagnosing an issue.

### Use the Troubleshooting Tool

1. Open the PowerShell prompt as an administrator on the machine where you installed the Log Analytics agent.
1. Go to the directory where the tool is located:

   `cd "C:\Program Files\Microsoft Monitoring Agent\Agent\Troubleshooter"`
1. Run the main script by using this command:

   `.\GetAgentInfo.ps1`
1. Select a troubleshooting scenario.
1. Follow the instructions on the console. The trace logs steps require manual intervention to stop log collection. Based on the reproducibility of the problem, wait for the time duration and select **s** to stop log collection and proceed to the next step.

   The process logs the location of the results file upon completion and opens a new explorer window highlighting it.

### Installation

The Troubleshooting Tool is automatically included when you install the Log Analytics Agent build 10.20.18053.0 and later.

### Scenarios covered

The Troubleshooting Tool checks the following scenarios:

- The agent isn't reporting data or heartbeat data is missing.
- The agent extension deployment is failing.
- The agent is crashing.
- The agent is consuming high CPU or memory.
- Installation and uninstallation experience failures.
- Custom logs have problems.
- OMS Gateway has issues.
- Performance counters have problems.
- Agent logs can't be collected.

>[!NOTE]
>Run the Troubleshooting Tool when you experience an issue. Having the logs initially helps the support team troubleshoot your problem faster.

## Important troubleshooting sources

 To help troubleshoot problems related to the Log Analytics agent for Windows, the agent logs events to the Windows Event Log. It uses the *Application and Services\Operations Manager* section.

## Connectivity issues

If the agent communicates through a proxy server or firewall, restrictions might prevent communication between the source computer and the Azure Monitor service. If misconfiguration blocks communication, registration with a workspace might fail while attempting to install the agent or configure the agent post-setup to report to another workspace. Agent communication might fail after successful registration. This section describes methods to troubleshoot this type of issue by using the Windows agent.

Double-check that the firewall or proxy is configured to allow the ports and URLs described in the following table. Also confirm that HTTP inspection isn't enabled for web traffic. It can prevent a secure TLS channel between the agent and Azure Monitor.

|Agent resource|Ports |Direction |Bypass HTTPS inspection|
|------|---------|--------|--------|   
|*.ods.opinsights.azure.com |Port 443 |Outbound|Yes |  
|*.oms.opinsights.azure.com |Port 443 |Outbound|Yes |  
|*.blob.core.windows.net |Port 443 |Outbound|Yes |  
|*.agentsvc.azure-automation.net |Port 443 |Outbound|Yes |  

For firewall information required for Azure Government, see [Azure Government management](/azure/azure-government/compare-azure-government-global-azure#azure-monitor). You can use the Azure Automation Hybrid Runbook Worker to connect to and register with the Automation service to use runbooks or management solutions. It must be able to reach the required ports and URLs listed at [Configure your network for the Hybrid Runbook Worker](/azure/automation/automation-hybrid-runbook-worker#network-planning).

You can verify if the agent is successfully communicating with Azure Monitor by using several methods:

- Enable the [Azure Log Analytics Agent Health assessment](../insights/solution-agenthealth.md) in the workspace. From the Agent Health dashboard, view the **Count of unresponsive agents** column to quickly see if the agent is listed.
- Run the following query to confirm the agent reports a heartbeat to its configured workspace. Replace `<ComputerName>` with the actual name of the machine.

    ```
    Heartbeat 
    | where Computer like "<ComputerName>"
    | summarize arg_max(TimeGenerated, * ) by Computer 
    ```

    If the computer is successfully communicating with the service, the query returns a result. If the query doesn't return a result, first verify the agent is configured to report to the correct workspace. If everything is configured correctly, proceed to step 3. Search the Windows Event Log to identify if the agent is logging the issue that might be preventing it from communicating with Azure Monitor.

- Another method to identify a connectivity issue is by running the **TestCloudConnectivity** tool. The tool is installed by default with the agent in the folder *%SystemRoot%\Program Files\Microsoft Monitoring Agent\Agent*. From an elevated command prompt, go to the folder and run the tool. The tool returns the results and highlights where the test failed. For example, it might be related to a particular port or URL that was blocked.

    :::image type="content" source="./media/agent-windows-troubleshoot/output-testcloudconnection-tool-01.png" lightbox="./media/agent-windows-troubleshoot/output-testcloudconnection-tool-01.png" alt-text="Screenshot that shows TestCloudConnection tool execution results.":::

- Filter the *Operations Manager* event log by **Event sources** *Health Service Modules*, *HealthService*, and *Service Connector* and filter by **Event Level** *Warning* and *Error* to confirm if it's writing events from the following table. If it does, review the resolution steps included for each possible event.

    |Event ID |Source |Description |Resolution |
    |---------|-------|------------|-----------|
    |2133 and 2129 |Health Service |Connection to the service from the agent failed. |This error occurs when the agent can't communicate directly or through a firewall or proxy server to the Azure Monitor service. Verify agent proxy settings or that the network firewall or proxy allows TCP traffic from the computer to the service.|
    |2138 |Health Service Modules |Proxy requires authentication. |Configure the agent proxy settings and specify the username and password required to authenticate with the proxy server. |
    |2129 |Health Service Modules |Failed connection. Failed TLS negotiation. |Check your network adapter TCP/IP settings and agent proxy settings.|
    |2127 |Health Service Modules |Failure sending data received error code. |If it only happens periodically during the day, it could be a random anomaly that you can ignore. Monitor to understand how often it happens. If it happens often throughout the day, first check your network configuration and proxy settings. If the description includes HTTP error code 404 and it's the agent’s first attempt to send data to the service, it also shows a 500 error. The 500 error contains an inner 404 error code. The 404 error code means "not found," which indicates that the storage area for the new workspace is still being provisioned. On the next retry, data is successfully written to the workspace as expected. An HTTP error 403 might indicate a permission or credentials issue. More information is included with the 403 error to help troubleshoot the issue.|
    |4000 |Service Connector |DNS name resolution failed. |The machine couldn't resolve the internet address used when it sent data to the service. This issue might be DNS resolver settings on your machine, incorrect proxy settings, or a temporary DNS issue with your provider. If it happens periodically, it might result from a transient network-related issue.|
    |4001 |Service Connector |Connection to the service failed. |This error occurs when the agent can't communicate directly or through a firewall or proxy server to the Azure Monitor service. Verify agent proxy settings or that the network firewall or proxy allows TCP traffic from the computer to the service.|
    |4002 |Service Connector |The service returned HTTP status code 403 in response to a query. Check with the service administrator for the health of the service. The query is retried later. |This error is written during the agent's initial registration phase. You see a URL similar to *https://\<workspaceID>.oms.opinsights.azure.com/AgentService.svc/AgentTopologyRequest*. A 403 error code means "forbidden" and might result from a mistyped Workspace ID or key. The date and time might also be incorrect on the computer. If the time is +/- 15 minutes from current time, onboarding fails. To correct this issue, update the date and time of your Windows computer.|

## Data collection problems

After you install the agent and configure it to report to one or more workspaces, it might stop receiving configuration. It can also stop collecting or sending performance data, logs, or other data to the service. This problem depends on what is targeting and is enabled on the computer. You need to determine:

- Is it a particular data type or all data that's not available in the workspace?
- Is the data type specified by a solution or specified as part of the workspace data collection configuration?
- How many computers are affected? Is it a single computer or multiple computers reporting to the workspace?
- Was it working and did it stop at a particular time of day, or was it never collected?
- Is the log search query you're using syntactically correct?
- Has the agent ever received its configuration from Azure Monitor?

The first step in troubleshooting is to determine if the computer is sending a heartbeat event.

```
Heartbeat 
    | where Computer like "<ComputerName>"
    | summarize arg_max(TimeGenerated, * ) by Computer
```

If the query returns results, you need to determine if a particular data type isn't collected and forwarded to the service. This problem might result from the agent not receiving updated configuration from the service or some other symptom that prevents the agent from operating normally. Perform the following steps to further troubleshoot.

1. Open an elevated command prompt on the computer and restart the agent service by entering `net stop healthservice && net start healthservice`.
1. Open the *Operations Manager* event log and search for **event IDs** *7023, 7024, 7025, 7028*, and *1210* from **Event source** *HealthService*. These events indicate the agent is successfully receiving configuration from Azure Monitor and they're actively monitoring the computer. The event description for event ID 1210 also specifies on the last line all of the solutions and Insights that are included in the scope of monitoring on the agent.

    :::image type="content" source="./media/agent-windows-troubleshoot/event-id-1210-healthservice-01.png" lightbox="./media/agent-windows-troubleshoot/event-id-1210-healthservice-01.png" alt-text="Screenshot that shows an Event ID 1210 description.":::

1. Wait several minutes. If you don't see the expected data in the query results or visualization, depending on if you're viewing the data from a solution or Insight, from the *Operations Manager* event log, search for **Event sources** *HealthService* and *Health Service Modules*. Filter by **Event Level** *Warning* and *Error* to confirm if it wrote events from the following table.

    |Event ID |Source |Description |Resolution |
    |---------|-------|------------|-----------|
    |8000 |HealthService |This event specifies if a workflow related to performance, event, or other data type collected is unable to forward to the service for ingestion to the workspace. | Event ID 2136 from source HealthService is written together with this event and can indicate the agent is unable to communicate with the service. Possible reasons might be misconfiguration of the proxy and authentication settings, network outage, or the network firewall or proxy doesn't allow TCP traffic from the computer to the service.|
    |10102 and 10103 |Health Service Modules |Workflow couldn't resolve the data source. |This problem can occur if the specified performance counter or instance doesn't exist on the computer. It can also occur if the workspace data settings define it incorrectly. If it's a user-specified [performance counter](data-sources-performance-counters.md#configure-performance-counters), verify the information specified follows the correct format and exists on the target computers. |
    |26002 |Health Service Modules |Workflow couldn't resolve the data source. |This problem can occur if the specified Windows event log doesn't exist on the computer. This error can be safely ignored if the computer isn't expected to have this event log registered. Otherwise, if it's a user-specified [event log](data-sources-windows-events.md#configure-windows-event-logs), verify the information specified is correct. |
    
