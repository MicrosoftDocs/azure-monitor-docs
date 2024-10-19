---
title: Azure Monitor log analytics queries by tables
description: Azure Monitor log analytics queries by tables
author: EdB-MSFT
ms.topic: reference
ms.service: azure-monitor
ms.date: 09/26/2024
ms.author: edbaynash
ms.reviewer: lualderm

---

# Azure Monitor log analytics sample queries.

[Azure Monitor resource logs](/azure/azure-monitor/essentials/platform-logs-overview) are logs emitted by Azure services that describe the operation of those services or resources. When exported to a [Log Analytics workspace](/azure/azure-monitor/logs/log-analytics-workspace-overview) the logs are stored in tables. This set of articles contains sample queries to retrieve data from the log analytics tables. The queries are also available in the Log Analytics workspace.


## Sample queries by table

## [AACAudit](./queries/AACAudit.md)

- [Most recent delete key-value operations](./queries/AACAudit.md#most-recent-delete-key-value-operations)
- [Most recent client error](./queries/AACAudit.md#most-recent-client-error)

## [AACHttpRequest](./queries/AACHttpRequest.md)

- [Throttled Requests](./queries/AACHttpRequest.md#throttled-requests)
- [Most common server errors](./queries/AACHttpRequest.md#most-common-server-errors)
- [Most Active Clients by IP Address](./queries/AACHttpRequest.md#most-active-clients-by-ip-address)

## [AADCustomSecurityAttributeAuditLogs](./queries/AADCustomSecurityAttributeAuditLogs.md)

- [User's custom security attribute audits](./queries/AADCustomSecurityAttributeAuditLogs.md#users-custom-security-attribute-audits)

## [AADDomainServicesAccountLogon](./queries/AADDomainServicesAccountLogon.md)

- [Show logs from AADDomainServicesAccountLogon table](./queries/AADDomainServicesAccountLogon.md#show-logs-from-aaddomainservicesaccountlogon-table)

## [AADDomainServicesAccountManagement](./queries/AADDomainServicesAccountManagement.md)

- [Show logs from AADDomainServicesAccountManagement table](./queries/AADDomainServicesAccountManagement.md#show-logs-from-aaddomainservicesaccountmanagement-table)

## [AADDomainServicesDirectoryServiceAccess](./queries/AADDomainServicesDirectoryServiceAccess.md)

- [Show logs from AADDomainServicesDirectoryServiceAccess table](./queries/AADDomainServicesDirectoryServiceAccess.md#show-logs-from-aaddomainservicesdirectoryserviceaccess-table)

## [AADDomainServicesLogonLogoff](./queries/AADDomainServicesLogonLogoff.md)

- [Show logs from AADDomainServicesLogonLogoff table](./queries/AADDomainServicesLogonLogoff.md#show-logs-from-aaddomainserviceslogonlogoff-table)

## [AADDomainServicesPolicyChange](./queries/AADDomainServicesPolicyChange.md)

- [Show logs from AADDomainServicesPolicyChange table](./queries/AADDomainServicesPolicyChange.md#show-logs-from-aaddomainservicespolicychange-table)

## [AADDomainServicesPrivilegeUse](./queries/AADDomainServicesPrivilegeUse.md)

- [Show logs from AADDomainServicesPrivilegeUse table](./queries/AADDomainServicesPrivilegeUse.md#show-logs-from-aaddomainservicesprivilegeuse-table)

## [AADManagedIdentitySignInLogs](./queries/AADManagedIdentitySignInLogs.md)

- [Most active managed identities](./queries/AADManagedIdentitySignInLogs.md#most-active-managed-identities)

## [AADNonInteractiveUserSignInLogs](./queries/AADNonInteractiveUserSignInLogs.md)

- [Users with multiple cities](./queries/AADNonInteractiveUserSignInLogs.md#users-with-multiple-cities)
- [Most active ip addresses](./queries/AADNonInteractiveUserSignInLogs.md#most-active-ip-addresses)

## [AADProvisioningLogs](./queries/AADProvisioningLogs.md)

- [Provisioning actions for the last week](./queries/AADProvisioningLogs.md#provisioning-actions-for-the-last-week)
- [Provisioning errors](./queries/AADProvisioningLogs.md#provisioning-errors)
- [Provisioned objects by day](./queries/AADProvisioningLogs.md#provisioned-objects-by-day)

## [AADRiskyUsers](./queries/AADRiskyUsers.md)

- [High risk users](./queries/AADRiskyUsers.md#high-risk-users)

## [AADServicePrincipalRiskEvents](./queries/AADServicePrincipalRiskEvents.md)

- [Active service principal risk detections](./queries/AADServicePrincipalRiskEvents.md#active-service-principal-risk-detections)

## [AADServicePrincipalSignInLogs](./queries/AADServicePrincipalSignInLogs.md)

- [Most active service principals](./queries/AADServicePrincipalSignInLogs.md#most-active-service-principals)
- [Inactive service principals](./queries/AADServicePrincipalSignInLogs.md#inactive-service-principals)

## [AADUserRiskEvents](./queries/AADUserRiskEvents.md)

- [Recent user risk events](./queries/AADUserRiskEvents.md#recent-user-risk-events)
- [Active user risk detections](./queries/AADUserRiskEvents.md#active-user-risk-detections)

## [ABSBotRequests](./queries/ABSBotRequests.md)

- [Clients To Direct Line Channel](./queries/ABSBotRequests.md#clients-to-direct-line-channel)
- [Bot To Channels](./queries/ABSBotRequests.md#bot-to-channels)
- [Channels To Bot](./queries/ABSBotRequests.md#channels-to-bot)
- [Requests From Facebook To Azure Bot Service](./queries/ABSBotRequests.md#requests-from-facebook-to-azure-bot-service)
- [Requests From Azure Bot Service To Facebook API](./queries/ABSBotRequests.md#requests-from-azure-bot-service-to-facebook-api)
- [Activities Sent from Clients to Direct Line](./queries/ABSBotRequests.md#activities-sent-from-clients-to-direct-line)
- [Direct Line Channel Logs](./queries/ABSBotRequests.md#direct-line-channel-logs)
- [Failed Requests](./queries/ABSBotRequests.md#failed-requests)
- [Direct Line Channel Response Codes Line Chart](./queries/ABSBotRequests.md#direct-line-channel-response-codes-line-chart)
- [Requests Duration Line Chart](./queries/ABSBotRequests.md#requests-duration-line-chart)
- [Response Codes Line Chart](./queries/ABSBotRequests.md#response-codes-line-chart)
- [Response Codes PieChart](./queries/ABSBotRequests.md#response-codes-piechart)
- [Request Operations PieChart](./queries/ABSBotRequests.md#request-operations-piechart)

## [ACICollaborationAudit](./queries/ACICollaborationAudit.md)

- [How many times a resource was granted grants per pipeline run?](./queries/ACICollaborationAudit.md#how-many-times-a-resource-was-granted-grants-per-pipeline-run)
- [What entitlements was granted to my resource?](./queries/ACICollaborationAudit.md#what-entitlements-was-granted-to-my-resource)
- [What resources was granted accessed by an entitlement?](./queries/ACICollaborationAudit.md#what-resources-was-granted-accessed-by-an-entitlement)
- [Which participants was granted accessed to my resource?](./queries/ACICollaborationAudit.md#which-participants-was-granted-accessed-to-my-resource)

## [ACRConnectedClientList](./queries/ACRConnectedClientList.md)

- [Unique Redis client IP addresses](./queries/ACRConnectedClientList.md#unique-redis-client-ip-addresses)
- [Redis client connections per hour](./queries/ACRConnectedClientList.md#redis-client-connections-per-hour)

## [ACREntraAuthenticationAuditLog](./queries/ACREntraAuthenticationAuditLog.md)

- [Microsoft Entra authentication audit log](./queries/ACREntraAuthenticationAuditLog.md#microsoft-entra-authentication-audit-log)

## [ACSAdvancedMessagingOperations](./queries/ACSAdvancedMessagingOperations.md)

- [Advanced Messaging operations](./queries/ACSAdvancedMessagingOperations.md#advanced-messaging-operations)
- [Advanced Messaging operation duration percentiles](./queries/ACSAdvancedMessagingOperations.md#advanced-messaging-operation-duration-percentiles)
- [Advanced Messaging top 5 IP addresses per operation](./queries/ACSAdvancedMessagingOperations.md#advanced-messaging-top-5-ip-addresses-per-operation)
- [Advanced Messaging operational errors](./queries/ACSAdvancedMessagingOperations.md#advanced-messaging-operational-errors)
- [Advanced Messaging operation result counts](./queries/ACSAdvancedMessagingOperations.md#advanced-messaging-operation-result-counts)
- [Advanced Messaging channel activity](./queries/ACSAdvancedMessagingOperations.md#advanced-messaging-channel-activity)
- [Advanced Messaging message status count](./queries/ACSAdvancedMessagingOperations.md#advanced-messaging-message-status-count)

## [ACSAuthIncomingOperations](./queries/ACSAuthIncomingOperations.md)

- [List distinct auth operations](./queries/ACSAuthIncomingOperations.md#list-distinct-auth-operations)
- [Calculate auth operation duration percentiles](./queries/ACSAuthIncomingOperations.md#calculate-auth-operation-duration-percentiles)
- [Top 5 IP addresses per auth operation](./queries/ACSAuthIncomingOperations.md#top-5-ip-addresses-per-auth-operation)
- [Auth operational errors](./queries/ACSAuthIncomingOperations.md#auth-operational-errors)
- [Auth operation result counts](./queries/ACSAuthIncomingOperations.md#auth-operation-result-counts)

## [ACSBillingUsage](./queries/ACSBillingUsage.md)

- [Get long calls](./queries/ACSBillingUsage.md#get-long-calls)
- [Usage breakdown](./queries/ACSBillingUsage.md#usage-breakdown)
- [Record count breakdown](./queries/ACSBillingUsage.md#record-count-breakdown)
- [Participant Phone Numbers](./queries/ACSBillingUsage.md#participant-phone-numbers)

## [ACSCallAutomationIncomingOperations](./queries/ACSCallAutomationIncomingOperations.md)

- [Call Automation operations](./queries/ACSCallAutomationIncomingOperations.md#call-automation-operations)
- [Calculate Call Automation operation duration percentiles](./queries/ACSCallAutomationIncomingOperations.md#calculate-call-automation-operation-duration-percentiles)
- [Top 5 IP addresses per Call Automation operation](./queries/ACSCallAutomationIncomingOperations.md#top-5-ip-addresses-per-call-automation-operation)
- [Call Automation operational errors](./queries/ACSCallAutomationIncomingOperations.md#call-automation-operational-errors)
- [Call Automation operation result counts](./queries/ACSCallAutomationIncomingOperations.md#call-automation-operation-result-counts)
- [Call Automation logs for call connection ID](./queries/ACSCallAutomationIncomingOperations.md#call-automation-logs-for-call-connection-id)
- [Call Automation API operations on a call](./queries/ACSCallAutomationIncomingOperations.md#call-automation-api-operations-on-a-call)
- [CallDiagnostics log for CallAutomation API call](./queries/ACSCallAutomationIncomingOperations.md#calldiagnostics-log-for-callautomation-api-call)
- [CallSummary log for CallAutomation API call](./queries/ACSCallAutomationIncomingOperations.md#callsummary-log-for-callautomation-api-call)

## [ACSCallAutomationMediaSummary](./queries/ACSCallAutomationMediaSummary.md)

- [Loop play success rate](./queries/ACSCallAutomationMediaSummary.md#loop-play-success-rate)
- [Play to participant success rate](./queries/ACSCallAutomationMediaSummary.md#play-to-participant-success-rate)
- [Recognize success rate](./queries/ACSCallAutomationMediaSummary.md#recognize-success-rate)
- [Success rate by sub operation name](./queries/ACSCallAutomationMediaSummary.md#success-rate-by-sub-operation-name)

## [ACSCallClientMediaStatsTimeSeries](./queries/ACSCallClientMediaStatsTimeSeries.md)

- [Metrics per each media type](./queries/ACSCallClientMediaStatsTimeSeries.md#metrics-per-each-media-type)
- [Metric histogram per media type and direction](./queries/ACSCallClientMediaStatsTimeSeries.md#metric-histogram-per-media-type-and-direction)

## [ACSCallClientOperations](./queries/ACSCallClientOperations.md)

- [Count client operations by type](./queries/ACSCallClientOperations.md#count-client-operations-by-type)
- [Outgoing call failure reasons](./queries/ACSCallClientOperations.md#outgoing-call-failure-reasons)
- [Search calls by keyword](./queries/ACSCallClientOperations.md#search-calls-by-keyword)
- [Search all user facing diagnostics in a call](./queries/ACSCallClientOperations.md#search-all-user-facing-diagnostics-in-a-call)
- [Search all participants in a call](./queries/ACSCallClientOperations.md#search-all-participants-in-a-call)
- [Search all client operations in a call](./queries/ACSCallClientOperations.md#search-all-client-operations-in-a-call)

## [ACSCallDiagnostics](./queries/ACSCallDiagnostics.md)

- [Streams per call](./queries/ACSCallDiagnostics.md#streams-per-call)
- [Streams per call histogram](./queries/ACSCallDiagnostics.md#streams-per-call-histogram)
- [Media type ratio](./queries/ACSCallDiagnostics.md#media-type-ratio)
- [Transport type ratio](./queries/ACSCallDiagnostics.md#transport-type-ratio)
- [Average telemetry values](./queries/ACSCallDiagnostics.md#average-telemetry-values)
- [Jitter average histogram](./queries/ACSCallDiagnostics.md#jitter-average-histogram)
- [Jitter max histogram](./queries/ACSCallDiagnostics.md#jitter-max-histogram)
- [Packet loss rate average histogram](./queries/ACSCallDiagnostics.md#packet-loss-rate-average-histogram)
- [Packet loss rate max histogram](./queries/ACSCallDiagnostics.md#packet-loss-rate-max-histogram)
- [Round trip time average histogram](./queries/ACSCallDiagnostics.md#round-trip-time-average-histogram)
- [Round trip time max histogram](./queries/ACSCallDiagnostics.md#round-trip-time-max-histogram)
- [Jitter quality ratio](./queries/ACSCallDiagnostics.md#jitter-quality-ratio)
- [Packet loss rate quality ratio](./queries/ACSCallDiagnostics.md#packet-loss-rate-quality-ratio)
- [Round trip time quality ratio](./queries/ACSCallDiagnostics.md#round-trip-time-quality-ratio)
- [CallDiagnostics log for CallAutomation API call](./queries/ACSCallDiagnostics.md#calldiagnostics-log-for-callautomation-api-call)
- [Search calls by keyword](./queries/ACSCallDiagnostics.md#search-calls-by-keyword)
- [Search all participants in a call](./queries/ACSCallDiagnostics.md#search-all-participants-in-a-call)

## [ACSCallRecordingIncomingOperations](./queries/ACSCallRecordingIncomingOperations.md)

- [Call Recording operations](./queries/ACSCallRecordingIncomingOperations.md#call-recording-operations)
- [Calculate Call Recording operation duration percentiles](./queries/ACSCallRecordingIncomingOperations.md#calculate-call-recording-operation-duration-percentiles)
- [Top 5 IP addresses per Call Recording operation](./queries/ACSCallRecordingIncomingOperations.md#top-5-ip-addresses-per-call-recording-operation)
- [Call Recording operational errors](./queries/ACSCallRecordingIncomingOperations.md#call-recording-operational-errors)
- [Call Recording operation result counts](./queries/ACSCallRecordingIncomingOperations.md#call-recording-operation-result-counts)
- [Call Recording logs by ID](./queries/ACSCallRecordingIncomingOperations.md#call-recording-logs-by-id)

## [ACSCallRecordingSummary](./queries/ACSCallRecordingSummary.md)

- [Call Recording duration histogram](./queries/ACSCallRecordingSummary.md#call-recording-duration-histogram)
- [Call Recording duration percentiles](./queries/ACSCallRecordingSummary.md#call-recording-duration-percentiles)
- [Call Recording's end reason ratio](./queries/ACSCallRecordingSummary.md#call-recordings-end-reason-ratio)
- [Daily Call Recordings](./queries/ACSCallRecordingSummary.md#daily-call-recordings)
- [Hourly Call Recordings](./queries/ACSCallRecordingSummary.md#hourly-call-recordings)
- [Call Recording's mode ratio](./queries/ACSCallRecordingSummary.md#call-recordings-mode-ratio)

## [ACSCallSummary](./queries/ACSCallSummary.md)

- [Participants per call](./queries/ACSCallSummary.md#participants-per-call)
- [Participant Phone Numbers](./queries/ACSCallSummary.md#participant-phone-numbers)
- [Participants per group call](./queries/ACSCallSummary.md#participants-per-group-call)
- [Call type ratio](./queries/ACSCallSummary.md#call-type-ratio)
- [Call duration histogram](./queries/ACSCallSummary.md#call-duration-histogram)
- [Call duration percentiles](./queries/ACSCallSummary.md#call-duration-percentiles)
- [Daily calls](./queries/ACSCallSummary.md#daily-calls)
- [Hourly calls](./queries/ACSCallSummary.md#hourly-calls)
- [Endpoints per call](./queries/ACSCallSummary.md#endpoints-per-call)
- [SDK version ratio](./queries/ACSCallSummary.md#sdk-version-ratio)
- [OS version ratio](./queries/ACSCallSummary.md#os-version-ratio)
- [CallSummary log for CallAutomation API call](./queries/ACSCallSummary.md#callsummary-log-for-callautomation-api-call)
- [Search calls by keyword](./queries/ACSCallSummary.md#search-calls-by-keyword)
- [Search all participants in a call](./queries/ACSCallSummary.md#search-all-participants-in-a-call)
- [Search all client operations in a call](./queries/ACSCallSummary.md#search-all-client-operations-in-a-call)

## [ACSCallSurvey](./queries/ACSCallSurvey.md)

- [Overall call rating](./queries/ACSCallSurvey.md#overall-call-rating)
- [Audio rating](./queries/ACSCallSurvey.md#audio-rating)
- [Video rating](./queries/ACSCallSurvey.md#video-rating)
- [Screenshare rating](./queries/ACSCallSurvey.md#screenshare-rating)
- [Overall call issues](./queries/ACSCallSurvey.md#overall-call-issues)
- [Audio issues](./queries/ACSCallSurvey.md#audio-issues)
- [Video issues](./queries/ACSCallSurvey.md#video-issues)
- [Screenshare issues](./queries/ACSCallSurvey.md#screenshare-issues)
- [Search calls by keyword](./queries/ACSCallSurvey.md#search-calls-by-keyword)
- [Search all participants in a call](./queries/ACSCallSurvey.md#search-all-participants-in-a-call)

## [ACSChatIncomingOperations](./queries/ACSChatIncomingOperations.md)

- [Chat operations](./queries/ACSChatIncomingOperations.md#chat-operations)
- [Calculate chat operation duration percentiles](./queries/ACSChatIncomingOperations.md#calculate-chat-operation-duration-percentiles)
- [Top 5 IP addresses per chat operation](./queries/ACSChatIncomingOperations.md#top-5-ip-addresses-per-chat-operation)
- [Chat operational errors](./queries/ACSChatIncomingOperations.md#chat-operational-errors)
- [Chat operation result counts](./queries/ACSChatIncomingOperations.md#chat-operation-result-counts)

## [ACSEmailSendMailOperational](./queries/ACSEmailSendMailOperational.md)

- [Email Send Request Summary](./queries/ACSEmailSendMailOperational.md#email-send-request-summary)

## [ACSEmailStatusUpdateOperational](./queries/ACSEmailStatusUpdateOperational.md)

- [Email failed deliveries by recipient ID](./queries/ACSEmailStatusUpdateOperational.md#email-failed-deliveries-by-recipient-id)
- [Email Failed Deliveries by Message Id](./queries/ACSEmailStatusUpdateOperational.md#email-failed-deliveries-by-message-id)
- [Email Bounced and Suppressed Recipients](./queries/ACSEmailStatusUpdateOperational.md#email-bounced-and-suppressed-recipients)

## [ACSJobRouterIncomingOperations](./queries/ACSJobRouterIncomingOperations.md)

- [Job Router operations](./queries/ACSJobRouterIncomingOperations.md#job-router-operations)
- [Calculate Job Router operation duration percentiles](./queries/ACSJobRouterIncomingOperations.md#calculate-job-router-operation-duration-percentiles)
- [Top 5 IP addresses per Job Router operation](./queries/ACSJobRouterIncomingOperations.md#top-5-ip-addresses-per-job-router-operation)
- [Job Router operational errors](./queries/ACSJobRouterIncomingOperations.md#job-router-operational-errors)
- [Job Router operation result counts](./queries/ACSJobRouterIncomingOperations.md#job-router-operation-result-counts)

## [ACSRoomsIncomingOperations](./queries/ACSRoomsIncomingOperations.md)

- [Rooms operational errors](./queries/ACSRoomsIncomingOperations.md#rooms-operational-errors)
- [Rooms operation result counts](./queries/ACSRoomsIncomingOperations.md#rooms-operation-result-counts)
- [Rooms operation summary](./queries/ACSRoomsIncomingOperations.md#rooms-operation-summary)

## [ACSSMSIncomingOperations](./queries/ACSSMSIncomingOperations.md)

- [List distinct SMS operations](./queries/ACSSMSIncomingOperations.md#list-distinct-sms-operations)
- [Calculate SMS operation duration percentiles](./queries/ACSSMSIncomingOperations.md#calculate-sms-operation-duration-percentiles)
- [Top 5 IP addresses per SMS operation](./queries/ACSSMSIncomingOperations.md#top-5-ip-addresses-per-sms-operation)
- [SMS operational errors](./queries/ACSSMSIncomingOperations.md#sms-operational-errors)
- [SMS operation result counts](./queries/ACSSMSIncomingOperations.md#sms-operation-result-counts)

## [ADAssessmentRecommendation](./queries/ADAssessmentRecommendation.md)

- [AD Recommendations by Focus Area](./queries/ADAssessmentRecommendation.md#ad-recommendations-by-focus-area)
- [AD Recommendations by Computer](./queries/ADAssessmentRecommendation.md#ad-recommendations-by-computer)
- [AD Recommendations by Forest](./queries/ADAssessmentRecommendation.md#ad-recommendations-by-forest)
- [AD Recommendations by Domain](./queries/ADAssessmentRecommendation.md#ad-recommendations-by-domain)
- [AD Recommendations by DomainController](./queries/ADAssessmentRecommendation.md#ad-recommendations-by-domaincontroller)
- [AD Recommendations by AffectedObjectType](./queries/ADAssessmentRecommendation.md#ad-recommendations-by-affectedobjecttype)
- [How many times did each unique AD Recommendation trigger?](./queries/ADAssessmentRecommendation.md#how-many-times-did-each-unique-ad-recommendation-trigger)
- [High priority AD Assessment security recommendations](./queries/ADAssessmentRecommendation.md#high-priority-ad-assessment-security-recommendations)

## [ADFActivityRun](./queries/ADFActivityRun.md)

- [Activity Runs Availability](./queries/ADFActivityRun.md#activity-runs-availability)
- [Activity runs latest Status](./queries/ADFActivityRun.md#activity-runs-latest-status)

## [ADFPipelineRun](./queries/ADFPipelineRun.md)

- [PipelineRuns Availability](./queries/ADFPipelineRun.md#pipelineruns-availability)
- [Pipeline runs latest Status](./queries/ADFPipelineRun.md#pipeline-runs-latest-status)

## [ADFSSignInLogs](./queries/ADFSSignInLogs.md)

- [Top ADFS account lockouts](./queries/ADFSSignInLogs.md#top-adfs-account-lockouts)

## [ADFTriggerRun](./queries/ADFTriggerRun.md)

- [TriggerRuns Availability](./queries/ADFTriggerRun.md#triggerruns-availability)
- [Trigger runs latest Status](./queries/ADFTriggerRun.md#trigger-runs-latest-status)

## [ADTDataHistoryOperation](./queries/ADTDataHistoryOperation.md)

- [Data History operation failure logs](./queries/ADTDataHistoryOperation.md#data-history-operation-failure-logs)
- [Data History egress latency](./queries/ADTDataHistoryOperation.md#data-history-egress-latency)

## [ADTDigitalTwinsOperation](./queries/ADTDigitalTwinsOperation.md)

- [DigitalTwin Error Summary](./queries/ADTDigitalTwinsOperation.md#digitaltwin-error-summary)
- [DigitalTwin API Usage](./queries/ADTDigitalTwinsOperation.md#digitaltwin-api-usage)

## [ADTEventRoutesOperation](./queries/ADTEventRoutesOperation.md)

- [EventRoutes API Usage](./queries/ADTEventRoutesOperation.md#eventroutes-api-usage)

## [ADTModelsOperation](./queries/ADTModelsOperation.md)

- [Model Error Summary](./queries/ADTModelsOperation.md#model-error-summary)
- [Model API Usage](./queries/ADTModelsOperation.md#model-api-usage)

## [ADTQueryOperation](./queries/ADTQueryOperation.md)

- [Query Error Summary](./queries/ADTQueryOperation.md#query-error-summary)

## [ADXIngestionBatching](./queries/ADXIngestionBatching.md)

- [Ingestion batching size](./queries/ADXIngestionBatching.md#ingestion-batching-size)
- [Ingestion batching summary](./queries/ADXIngestionBatching.md#ingestion-batching-summary)
- [Ingestion batching duration timechart](./queries/ADXIngestionBatching.md#ingestion-batching-duration-timechart)

## [ADXTableUsageStatistics](./queries/ADXTableUsageStatistics.md)

- [Table usage by number of queries](./queries/ADXTableUsageStatistics.md#table-usage-by-number-of-queries)
- [Table usage by application](./queries/ADXTableUsageStatistics.md#table-usage-by-application)
- [Table data scanned - top time windows](./queries/ADXTableUsageStatistics.md#table-data-scanned---top-time-windows)
- [Table data scanned - top tables](./queries/ADXTableUsageStatistics.md#table-data-scanned---top-tables)

## [AEWComputePipelinesLogs](./queries/AEWComputePipelinesLogs.md)

- [AEWComputePipelinesLogs get daily tasks count](./queries/AEWComputePipelinesLogs.md#aewcomputepipelineslogs-get-daily-tasks-count)
- [AEWComputePipelinesLogs get failed tasks detail](./queries/AEWComputePipelinesLogs.md#aewcomputepipelineslogs-get-failed-tasks-detail)
- [AEWComputePipelinesLogs get long running jobs](./queries/AEWComputePipelinesLogs.md#aewcomputepipelineslogs-get-long-running-jobs)
- [AEWComputePipelinesLogs get task E2E latency time](./queries/AEWComputePipelinesLogs.md#aewcomputepipelineslogs-get-task-e2e-latency-time)

## [AFSAuditLogs](./queries/AFSAuditLogs.md)

- [Aggregate operations query](./queries/AFSAuditLogs.md#aggregate-operations-query)
- [Unauthorized requests query](./queries/AFSAuditLogs.md#unauthorized-requests-query)

## [AGCAccessLogs](./queries/AGCAccessLogs.md)

- [Client requests per hour](./queries/AGCAccessLogs.md#client-requests-per-hour)
- [5xx HTTP responses per hour](./queries/AGCAccessLogs.md#5xx-http-responses-per-hour)
- [4xx HTTP responses per hour](./queries/AGCAccessLogs.md#4xx-http-responses-per-hour)

## [AGSGrafanaLoginEvents](./queries/AGSGrafanaLoginEvents.md)

- [Show login error events](./queries/AGSGrafanaLoginEvents.md#show-login-error-events)

## [AHDSDicomAuditLogs](./queries/AHDSDicomAuditLogs.md)

- [DICOM privileged operations](./queries/AHDSDicomAuditLogs.md#dicom-privileged-operations)

## [AHDSDicomDiagnosticLogs](./queries/AHDSDicomDiagnosticLogs.md)

- [Log count per log starting with Dicom100 error code and CorrelationId](./queries/AHDSDicomDiagnosticLogs.md#log-count-per-log-starting-with-dicom100-error-code-and-correlationid)

## [AHDSMedTechDiagnosticLogs](./queries/AHDSMedTechDiagnosticLogs.md)

- [Most recent actionable MedTech logs](./queries/AHDSMedTechDiagnosticLogs.md#most-recent-actionable-medtech-logs)
- [Log count per MedTech log or exception type](./queries/AHDSMedTechDiagnosticLogs.md#log-count-per-medtech-log-or-exception-type)
- [MedTech healthcheck exceptions](./queries/AHDSMedTechDiagnosticLogs.md#medtech-healthcheck-exceptions)
- [MedTech normalization stage logs](./queries/AHDSMedTechDiagnosticLogs.md#medtech-normalization-stage-logs)
- [MedTech FHIR conversion stage logs](./queries/AHDSMedTechDiagnosticLogs.md#medtech-fhir-conversion-stage-logs)

## [AKSAudit](./queries/AKSAudit.md)

- [Volume of Kubernetes audit events per SourceIp](./queries/AKSAudit.md#volume-of-kubernetes-audit-events-per-sourceip)

## [AKSAuditAdmin](./queries/AKSAuditAdmin.md)

- [Volume of admin Kubernetes audit events per username](./queries/AKSAuditAdmin.md#volume-of-admin-kubernetes-audit-events-per-username)
- [Admin Kubernetes audit events for deployment](./queries/AKSAuditAdmin.md#admin-kubernetes-audit-events-for-deployment)

## [AKSControlPlane](./queries/AKSControlPlane.md)

- [Cluster Autoscaler logs](./queries/AKSControlPlane.md#cluster-autoscaler-logs)
- [Kubernetes API server logs](./queries/AKSControlPlane.md#kubernetes-api-server-logs)

## [ALBHealthEvent](./queries/ALBHealthEvent.md)

- [Latest Snat Port Exhaustion Per LB Frontend](./queries/ALBHealthEvent.md#latest-snat-port-exhaustion-per-lb-frontend)

## [AMSKeyDeliveryRequests](./queries/AMSKeyDeliveryRequests.md)

- [Key delivery successful request count by key type](./queries/AMSKeyDeliveryRequests.md#key-delivery-successful-request-count-by-key-type)
- [Key delivery failed requests](./queries/AMSKeyDeliveryRequests.md#key-delivery-failed-requests)
- [Key delivery requests latency at 95 and 99 percentiles](./queries/AMSKeyDeliveryRequests.md#key-delivery-requests-latency-at-95-and-99-percentiles)

## [AMSLiveEventOperations](./queries/AMSLiveEventOperations.md)

- [Live event ingest discontinuity operation count](./queries/AMSLiveEventOperations.md#live-event-ingest-discontinuity-operation-count)
- [Live event error operations](./queries/AMSLiveEventOperations.md#live-event-error-operations)

## [AMSMediaAccountHealth](./queries/AMSMediaAccountHealth.md)

- [Media account health events](./queries/AMSMediaAccountHealth.md#media-account-health-events)

## [AMSStreamingEndpointRequests](./queries/AMSStreamingEndpointRequests.md)

- [Streaming endpoint successful request count by client IP](./queries/AMSStreamingEndpointRequests.md#streaming-endpoint-successful-request-count-by-client-ip)
- [Streaming endpoint informational requests](./queries/AMSStreamingEndpointRequests.md#streaming-endpoint-informational-requests)

## [AOIDatabaseQuery](./queries/AOIDatabaseQuery.md)

- [Queries executed by a user on dataproduct](./queries/AOIDatabaseQuery.md#queries-executed-by-a-user-on-dataproduct)

## [AOIDigestion](./queries/AOIDigestion.md)

- [Row digestion errors](./queries/AOIDigestion.md#row-digestion-errors)
- [Failed file digestion by source](./queries/AOIDigestion.md#failed-file-digestion-by-source)

## [AOIStorage](./queries/AOIStorage.md)

- [Ingestion operation on storage](./queries/AOIStorage.md#ingestion-operation-on-storage)
- [Delete operation on storage](./queries/AOIStorage.md#delete-operation-on-storage)
- [Read operation on storage](./queries/AOIStorage.md#read-operation-on-storage)
- [Read operation on input storage](./queries/AOIStorage.md#read-operation-on-input-storage)

## [ASCDeviceEvents](./queries/ASCDeviceEvents.md)

- [Azure Sphere device authentication and attestation failures](./queries/ASCDeviceEvents.md#azure-sphere-device-authentication-and-attestation-failures)
- [Azure Sphere device events timeline](./queries/ASCDeviceEvents.md#azure-sphere-device-events-timeline)
- [Azure Sphere device heartbeat events timechart](./queries/ASCDeviceEvents.md#azure-sphere-device-heartbeat-events-timechart)
- [Azure Sphere devices not updated to latest OS](./queries/ASCDeviceEvents.md#azure-sphere-devices-not-updated-to-latest-os)
- [Azure Sphere device telemetry events summary](./queries/ASCDeviceEvents.md#azure-sphere-device-telemetry-events-summary)

## [ASRJobs](./queries/ASRJobs.md)

- [Get all test failover jobs run](./queries/ASRJobs.md#get-all-test-failover-jobs-run)

## [ASRReplicatedItems](./queries/ASRReplicatedItems.md)

- [Get replication health status history](./queries/ASRReplicatedItems.md#get-replication-health-status-history)

## [ASimDnsActivityLogs](./queries/ASimDnsActivityLogs.md)

- [Count DNS failures for a source by source and type](./queries/ASimDnsActivityLogs.md#count-dns-failures-for-a-source-by-source-and-type)
- [Identify excessive query for a nonexistent domain by a source](./queries/ASimDnsActivityLogs.md#identify-excessive-query-for-a-nonexistent-domain-by-a-source)

## [AVNMConnectivityConfigurationChange](./queries/AVNMConnectivityConfigurationChange.md)

- [Recent connectivity configuration changes](./queries/AVNMConnectivityConfigurationChange.md#recent-connectivity-configuration-changes)
- [Recent failed connectivity configuration changes](./queries/AVNMConnectivityConfigurationChange.md#recent-failed-connectivity-configuration-changes)

## [AVNMIPAMPoolAllocationChange](./queries/AVNMIPAMPoolAllocationChange.md)

- [AVNM IPAM pool allocation changes](./queries/AVNMIPAMPoolAllocationChange.md#avnm-ipam-pool-allocation-changes)
- [Failed AVNM IPAM pool allocation changes](./queries/AVNMIPAMPoolAllocationChange.md#failed-avnm-ipam-pool-allocation-changes)

## [AVNMNetworkGroupMembershipChange](./queries/AVNMNetworkGroupMembershipChange.md)

- [Get recent Network Group Membership changes](./queries/AVNMNetworkGroupMembershipChange.md#get-recent-network-group-membership-changes)
- [Failed Network Group Membership Changes](./queries/AVNMNetworkGroupMembershipChange.md#failed-network-group-membership-changes)

## [AVNMRuleCollectionChange](./queries/AVNMRuleCollectionChange.md)

- [Get recent security admin rule collection changes](./queries/AVNMRuleCollectionChange.md#get-recent-security-admin-rule-collection-changes)
- [Get recent failed security admin rule collection changes](./queries/AVNMRuleCollectionChange.md#get-recent-failed-security-admin-rule-collection-changes)

## [AVSSyslog](./queries/AVSSyslog.md)

- [Get DNS failures](./queries/AVSSyslog.md#get-dns-failures)
- [Get distributed Firewall logs](./queries/AVSSyslog.md#get-distributed-firewall-logs)
- [Get audit events for VM created](./queries/AVSSyslog.md#get-audit-events-for-vm-created)
- [Get audit events for VM deleted](./queries/AVSSyslog.md#get-audit-events-for-vm-deleted)
- [Get audit events for VM powered on](./queries/AVSSyslog.md#get-audit-events-for-vm-powered-on)
- [Get audit events for VM disconnected](./queries/AVSSyslog.md#get-audit-events-for-vm-disconnected)
- [Get audit events for VM rebooted](./queries/AVSSyslog.md#get-audit-events-for-vm-rebooted)
- [Get audit events for VM migrated](./queries/AVSSyslog.md#get-audit-events-for-vm-migrated)
- [Get audit events for host added](./queries/AVSSyslog.md#get-audit-events-for-host-added)
- [Get audit events for host shutdown](./queries/AVSSyslog.md#get-audit-events-for-host-shutdown)
- [Get audit events for host enter maintenance mode](./queries/AVSSyslog.md#get-audit-events-for-host-enter-maintenance-mode)
- [Get audit events for host exit maintenance mode](./queries/AVSSyslog.md#get-audit-events-for-host-exit-maintenance-mode)
- [Get audit events for host connected](./queries/AVSSyslog.md#get-audit-events-for-host-connected)
- [Get audit events for host connection lost](./queries/AVSSyslog.md#get-audit-events-for-host-connection-lost)
- [Get audit events for cluster](./queries/AVSSyslog.md#get-audit-events-for-cluster)
- [Get audit events count for NSX](./queries/AVSSyslog.md#get-audit-events-count-for-nsx)
- [Get audit events count for vCenter](./queries/AVSSyslog.md#get-audit-events-count-for-vcenter)
- [Get audit events for role added](./queries/AVSSyslog.md#get-audit-events-for-role-added)
- [Get AVS events with severity of Info](./queries/AVSSyslog.md#get-avs-events-with-severity-of-info)

## [AWSCloudTrail](./queries/AWSCloudTrail.md)

- [New users per region](./queries/AWSCloudTrail.md#new-users-per-region)
- [All AWS CloudTrail events](./queries/AWSCloudTrail.md#all-aws-cloudtrail-events)
- [AWSCT for user](./queries/AWSCloudTrail.md#awsct-for-user)
- [AWS console sign in](./queries/AWSCloudTrail.md#aws-console-sign-in)

## [AWSGuardDuty](./queries/AWSGuardDuty.md)

- [High severity findings](./queries/AWSGuardDuty.md#high-severity-findings)

## [AWSVPCFlow](./queries/AWSVPCFlow.md)

- [Rejected IPv4 actions](./queries/AWSVPCFlow.md#rejected-ipv4-actions)

## [AZFWApplicationRule](./queries/AZFWApplicationRule.md)

- [Application rule logs](./queries/AZFWApplicationRule.md#application-rule-logs)
- [All firewall decisions](./queries/AZFWApplicationRule.md#all-firewall-decisions)

## [AZFWDnsQuery](./queries/AZFWDnsQuery.md)

- [DNS proxy logs](./queries/AZFWDnsQuery.md#dns-proxy-logs)

## [AZFWFatFlow](./queries/AZFWFatFlow.md)

- [Azure Firewall Top Flow Logs](./queries/AZFWFatFlow.md#azure-firewall-top-flow-logs)

## [AZFWFlowTrace](./queries/AZFWFlowTrace.md)

- [Azure Firewall flow trace logs](./queries/AZFWFlowTrace.md#azure-firewall-flow-trace-logs)

## [AZFWIdpsSignature](./queries/AZFWIdpsSignature.md)

- [IDPS event logs](./queries/AZFWIdpsSignature.md#idps-event-logs)
- [All firewall decisions](./queries/AZFWIdpsSignature.md#all-firewall-decisions)

## [AZFWInternalFqdnResolutionFailure](./queries/AZFWInternalFqdnResolutionFailure.md)

- [Internal FQDN resolution failures](./queries/AZFWInternalFqdnResolutionFailure.md#internal-fqdn-resolution-failures)

## [AZFWNatRule](./queries/AZFWNatRule.md)

- [DNAT rule logs](./queries/AZFWNatRule.md#dnat-rule-logs)
- [All firewall decisions](./queries/AZFWNatRule.md#all-firewall-decisions)

## [AZFWNetworkRule](./queries/AZFWNetworkRule.md)

- [Network rule logs](./queries/AZFWNetworkRule.md#network-rule-logs)
- [All firewall decisions](./queries/AZFWNetworkRule.md#all-firewall-decisions)

## [AZFWThreatIntel](./queries/AZFWThreatIntel.md)

- [Threat intelligence logs](./queries/AZFWThreatIntel.md#threat-intelligence-logs)
- [All firewall decisions](./queries/AZFWThreatIntel.md#all-firewall-decisions)

## [AZKVAuditLogs](./queries/AZKVAuditLogs.md)

- [Are there any failures?](./queries/AZKVAuditLogs.md#are-there-any-failures)
- [Are there any slow requests?](./queries/AZKVAuditLogs.md#are-there-any-slow-requests)
- [How active has this KeyVault been?](./queries/AZKVAuditLogs.md#how-active-has-this-keyvault-been)
- [How fast is this KeyVault serving requests?](./queries/AZKVAuditLogs.md#how-fast-is-this-keyvault-serving-requests)
- [What changes occurred last month?](./queries/AZKVAuditLogs.md#what-changes-occurred-last-month)
- [Who is calling this KeyVault?](./queries/AZKVAuditLogs.md#who-is-calling-this-keyvault)

## [AZMSDiagnosticErrorLogs](./queries/AZMSDiagnosticErrorLogs.md)

- [Publish detailed error logs](./queries/AZMSDiagnosticErrorLogs.md#publish-detailed-error-logs)
- [Publish detailed error logs](./queries/AZMSDiagnosticErrorLogs.md#publish-detailed-error-logs)

## [AZMSHybridConnectionsEvents](./queries/AZMSHybridConnectionsEvents.md)

- [Publish HTTP send data for hybrid connection](./queries/AZMSHybridConnectionsEvents.md#publish-http-send-data-for-hybrid-connection)

## [AZMSOperationalLogs](./queries/AZMSOperationalLogs.md)

- [Publish success data for topics](./queries/AZMSOperationalLogs.md#publish-success-data-for-topics)
- [Publish failures for subscription](./queries/AZMSOperationalLogs.md#publish-failures-for-subscription)
- [Publish failures for namespace](./queries/AZMSOperationalLogs.md#publish-failures-for-namespace)
- [Publish success data for topics](./queries/AZMSOperationalLogs.md#publish-success-data-for-topics)
- [Publish failures for Topics](./queries/AZMSOperationalLogs.md#publish-failures-for-topics)
- [Publish failures for subscription](./queries/AZMSOperationalLogs.md#publish-failures-for-subscription)
- [Publish failures for namespace](./queries/AZMSOperationalLogs.md#publish-failures-for-namespace)

## [AZMSRunTimeAuditLogs](./queries/AZMSRunTimeAuditLogs.md)

- [Publish successful connection for AMQP protocol](./queries/AZMSRunTimeAuditLogs.md#publish-successful-connection-for-amqp-protocol)
- [Publish failed AAD logs](./queries/AZMSRunTimeAuditLogs.md#publish-failed-aad-logs)
- [Publish failed SAS logs](./queries/AZMSRunTimeAuditLogs.md#publish-failed-sas-logs)
- [Publish failure for send message](./queries/AZMSRunTimeAuditLogs.md#publish-failure-for-send-message)
- [Publish failure for Namespace](./queries/AZMSRunTimeAuditLogs.md#publish-failure-for-namespace)
- [[Classic] Errors in the last 7 days](./queries/AZMSRunTimeAuditLogs.md#classic-errors-in-the-last-7-days)
- [Publish successful connection for AMQP protocol](./queries/AZMSRunTimeAuditLogs.md#publish-successful-connection-for-amqp-protocol)
- [Publish failures for send message](./queries/AZMSRunTimeAuditLogs.md#publish-failures-for-send-message)
- [Publish failure for namespace](./queries/AZMSRunTimeAuditLogs.md#publish-failure-for-namespace)
- [Publish failed AAD logs](./queries/AZMSRunTimeAuditLogs.md#publish-failed-aad-logs)
- [Publish failed SAS logs](./queries/AZMSRunTimeAuditLogs.md#publish-failed-sas-logs)

## [AZMSVnetConnectionEvents](./queries/AZMSVnetConnectionEvents.md)

- [Publish deny connection by namespace](./queries/AZMSVnetConnectionEvents.md#publish-deny-connection-by-namespace)
- [Publish namespace vnet data](./queries/AZMSVnetConnectionEvents.md#publish-namespace-vnet-data)
- [Publish deny connection by namespace](./queries/AZMSVnetConnectionEvents.md#publish-deny-connection-by-namespace)
- [Publish virtual network events by namespace](./queries/AZMSVnetConnectionEvents.md#publish-virtual-network-events-by-namespace)
- [Publish deny connection by namespace](./queries/AZMSVnetConnectionEvents.md#publish-deny-connection-by-namespace)
- [Publish virtual network events by namespace](./queries/AZMSVnetConnectionEvents.md#publish-virtual-network-events-by-namespace)

## [AddonAzureBackupJobs](./queries/AddonAzureBackupJobs.md)

- [Distribution of Backup Jobs by Status](./queries/AddonAzureBackupJobs.md#distribution-of-backup-jobs-by-status)
- [Distribution of Restore Jobs by Status](./queries/AddonAzureBackupJobs.md#distribution-of-restore-jobs-by-status)
- [All Successful Jobs](./queries/AddonAzureBackupJobs.md#all-successful-jobs)
- [All Failed Jobs](./queries/AddonAzureBackupJobs.md#all-failed-jobs)

## [AddonAzureBackupStorage](./queries/AddonAzureBackupStorage.md)

- [Trend of total Cloud Storage consumed](./queries/AddonAzureBackupStorage.md#trend-of-total-cloud-storage-consumed)

## [AegDataPlaneRequests](./queries/AegDataPlaneRequests.md)

- [Unique unauthorized or forbidden client IP addresses](./queries/AegDataPlaneRequests.md#unique-unauthorized-or-forbidden-client-ip-addresses)

## [AegDeliveryFailureLogs](./queries/AegDeliveryFailureLogs.md)

- [Delivery failures by topic and error](./queries/AegDeliveryFailureLogs.md#delivery-failures-by-topic-and-error)
- [Delivery failures by topic and error](./queries/AegDeliveryFailureLogs.md#delivery-failures-by-topic-and-error)
- [Delivery failures by domain and error](./queries/AegDeliveryFailureLogs.md#delivery-failures-by-domain-and-error)
- [Topics Average Delivery Latency](./queries/AegDeliveryFailureLogs.md#topics-average-delivery-latency)
- [Domains Average Delivery Latency ](./queries/AegDeliveryFailureLogs.md#domains-average-delivery-latency)

## [AegPublishFailureLogs](./queries/AegPublishFailureLogs.md)

- [Publish failures by topic and error](./queries/AegPublishFailureLogs.md#publish-failures-by-topic-and-error)
- [Publish failures by topic and error](./queries/AegPublishFailureLogs.md#publish-failures-by-topic-and-error)
- [Publish failures by domain and error](./queries/AegPublishFailureLogs.md#publish-failures-by-domain-and-error)

## [AgriFoodApplicationAuditLogs](./queries/AgriFoodApplicationAuditLogs.md)

- [Failed authorization](./queries/AgriFoodApplicationAuditLogs.md#failed-authorization)

## [AgriFoodFarmManagementLogs](./queries/AgriFoodFarmManagementLogs.md)

- [Status of farm management operations for a farmer](./queries/AgriFoodFarmManagementLogs.md#status-of-farm-management-operations-for-a-farmer)
- [Status of all operations for a farmer](./queries/AgriFoodFarmManagementLogs.md#status-of-all-operations-for-a-farmer)
- [Usage trend for top 100 farmers based on the operations performed](./queries/AgriFoodFarmManagementLogs.md#usage-trend-for-top-100-farmers-based-on-the-operations-performed)

## [AgriFoodJobProcessedLogs](./queries/AgriFoodJobProcessedLogs.md)

- [Job execution statistics for a farmer](./queries/AgriFoodJobProcessedLogs.md#job-execution-statistics-for-a-farmer)

## [AlertEvidence](./queries/AlertEvidence.md)

- [Alerts involving a user](./queries/AlertEvidence.md#alerts-involving-a-user)

## [AlertInfo](./queries/AlertInfo.md)

- [Alerts by MITRE ATT&CK technique](./queries/AlertInfo.md#alerts-by-mitre-attck-technique)

## [AmlComputeClusterEvent](./queries/AmlComputeClusterEvent.md)

- [Get cluster events for clusters for specific VM size](./queries/AmlComputeClusterEvent.md#get-cluster-events-for-clusters-for-specific-vm-size)
- [Get number of running nodes](./queries/AmlComputeClusterEvent.md#get-number-of-running-nodes)
- [Graph of Running and Idle Node instances](./queries/AmlComputeClusterEvent.md#graph-of-running-and-idle-node-instances)

## [AmlComputeCpuGpuUtilization](./queries/AmlComputeCpuGpuUtilization.md)

- [Plot compute cluster utilization](./queries/AmlComputeCpuGpuUtilization.md#plot-compute-cluster-utilization)

## [AmlComputeJobEvent](./queries/AmlComputeJobEvent.md)

- [Get failed jobs](./queries/AmlComputeJobEvent.md#get-failed-jobs)
- [Get records for a job](./queries/AmlComputeJobEvent.md#get-records-for-a-job)
- [Display top 5 longest job runs](./queries/AmlComputeJobEvent.md#display-top-5-longest-job-runs)

## [AmlDataSetEvent](./queries/AmlDataSetEvent.md)

- [Count datasets reads](./queries/AmlDataSetEvent.md#count-datasets-reads)

## [AmlEnvironmentEvent](./queries/AmlEnvironmentEvent.md)

- [Request the history of accessing environment](./queries/AmlEnvironmentEvent.md#request-the-history-of-accessing-environment)

## [AmlModelsEvent](./queries/AmlModelsEvent.md)

- [Found users who accessed models](./queries/AmlModelsEvent.md#found-users-who-accessed-models)

## [AmlOnlineEndpointConsoleLog](./queries/AmlOnlineEndpointConsoleLog.md)

- [Online endpoint console logs](./queries/AmlOnlineEndpointConsoleLog.md#online-endpoint-console-logs)

## [AmlOnlineEndpointEventLog](./queries/AmlOnlineEndpointEventLog.md)

- [Online endpoint failure events](./queries/AmlOnlineEndpointEventLog.md#online-endpoint-failure-events)

## [AmlOnlineEndpointTrafficLog](./queries/AmlOnlineEndpointTrafficLog.md)

- [Online endpoint failed requests](./queries/AmlOnlineEndpointTrafficLog.md#online-endpoint-failed-requests)

## [AmlRegistryWriteEventsLog](./queries/AmlRegistryWriteEventsLog.md)

- [All WRITE events](./queries/AmlRegistryWriteEventsLog.md#all-write-events)

## [Anomalies](./queries/Anomalies.md)

- [Get Production Anomalies (last day)](./queries/Anomalies.md#get-production-anomalies-last-day)
- [Get Flighting Anomalies (last day)](./queries/Anomalies.md#get-flighting-anomalies-last-day)

## [ApiManagementGatewayLogs](./queries/ApiManagementGatewayLogs.md)

- [Number of requests](./queries/ApiManagementGatewayLogs.md#number-of-requests)
- [Logs of the last 100 calls](./queries/ApiManagementGatewayLogs.md#logs-of-the-last-100-calls)
- [Number of calls by APIs](./queries/ApiManagementGatewayLogs.md#number-of-calls-by-apis)
- [Bandwidth consumed](./queries/ApiManagementGatewayLogs.md#bandwidth-consumed)
- [Request sizes](./queries/ApiManagementGatewayLogs.md#request-sizes)
- [Response sizes](./queries/ApiManagementGatewayLogs.md#response-sizes)
- [Client TLS versions](./queries/ApiManagementGatewayLogs.md#client-tls-versions)
- [Error reasons breakdown](./queries/ApiManagementGatewayLogs.md#error-reasons-breakdown)
- [Last 100 failed requests](./queries/ApiManagementGatewayLogs.md#last-100-failed-requests)
- [Get failed requests due to issues related to the backend](./queries/ApiManagementGatewayLogs.md#get-failed-requests-due-to-issues-related-to-the-backend)
- [Get failed requests due to issues not related to the backend](./queries/ApiManagementGatewayLogs.md#get-failed-requests-due-to-issues-not-related-to-the-backend)
- [Overall latency](./queries/ApiManagementGatewayLogs.md#overall-latency)
- [Backend latency](./queries/ApiManagementGatewayLogs.md#backend-latency)
- [Client latency](./queries/ApiManagementGatewayLogs.md#client-latency)
- [Cache hit ratio](./queries/ApiManagementGatewayLogs.md#cache-hit-ratio)

## [AppDependencies](./queries/AppDependencies.md)

- [Failing dependencies](./queries/AppDependencies.md#failing-dependencies)

## [AppEnvSpringAppConsoleLogs](./queries/AppEnvSpringAppConsoleLogs.md)

- [Latest Container App first party Spring App errors](./queries/AppEnvSpringAppConsoleLogs.md#latest-container-app-first-party-spring-app-errors)

## [AppExceptions](./queries/AppExceptions.md)

- [Top 3 browser exceptions](./queries/AppExceptions.md#top-3-browser-exceptions)

## [AppPageViews](./queries/AppPageViews.md)

- [Page views trend](./queries/AppPageViews.md#page-views-trend)
- [Slowest pages](./queries/AppPageViews.md#slowest-pages)

## [AppPlatformLogsforSpring](./queries/AppPlatformLogsforSpring.md)

- [Show the application logs which contain the "error" or "exception" terms](./queries/AppPlatformLogsforSpring.md#show-the-application-logs-which-contain-the-error-or-exception-terms)
- [Show the error and exception number of each application](./queries/AppPlatformLogsforSpring.md#show-the-error-and-exception-number-of-each-application)

## [AppPlatformSystemLogs](./queries/AppPlatformSystemLogs.md)

- [Show the config server logs](./queries/AppPlatformSystemLogs.md#show-the-config-server-logs)
- [Show the service registry logs](./queries/AppPlatformSystemLogs.md#show-the-service-registry-logs)
- [Show the Spring Cloud Gateway logs](./queries/AppPlatformSystemLogs.md#show-the-spring-cloud-gateway-logs)
- [Show the API portal logs](./queries/AppPlatformSystemLogs.md#show-the-api-portal-logs)
- [Show the Application Configuration Service logs](./queries/AppPlatformSystemLogs.md#show-the-application-configuration-service-logs)
- [Show the Spring Cloud Gateway operator logs](./queries/AppPlatformSystemLogs.md#show-the-spring-cloud-gateway-operator-logs)

## [AppRequests](./queries/AppRequests.md)

- [Response time trend](./queries/AppRequests.md#response-time-trend)
- [Request count trend](./queries/AppRequests.md#request-count-trend)
- [Response time buckets](./queries/AppRequests.md#response-time-buckets)
- [Operations performance](./queries/AppRequests.md#operations-performance)
- [Top 10 countries by traffic](./queries/AppRequests.md#top-10-countries-by-traffic)
- [Failed requests – top 10](./queries/AppRequests.md#failed-requests--top-10)
- [Failed operations](./queries/AppRequests.md#failed-operations)
- [Exceptions causing request failures](./queries/AppRequests.md#exceptions-causing-request-failures)

## [AppServiceAppLogs](./queries/AppServiceAppLogs.md)

- [Count app logs by severity](./queries/AppServiceAppLogs.md#count-app-logs-by-severity)
- [App logs for each App Service](./queries/AppServiceAppLogs.md#app-logs-for-each-app-service)

## [AppServiceAuditLogs](./queries/AppServiceAuditLogs.md)

- [Audit Logs relating to unexpected users](./queries/AppServiceAuditLogs.md#audit-logs-relating-to-unexpected-users)

## [AppServiceAuthenticationLogs](./queries/AppServiceAuthenticationLogs.md)

- [Most recent errors from App Service Authentication](./queries/AppServiceAuthenticationLogs.md#most-recent-errors-from-app-service-authentication)
- [Most recent warnings from App Service Authentication](./queries/AppServiceAuthenticationLogs.md#most-recent-warnings-from-app-service-authentication)
- [Top 100 most frequent errors and warnings from App Service Authentication](./queries/AppServiceAuthenticationLogs.md#top-100-most-frequent-errors-and-warnings-from-app-service-authentication)

## [AppServiceConsoleLogs](./queries/AppServiceConsoleLogs.md)

- [Find console logs relating to application startup](./queries/AppServiceConsoleLogs.md#find-console-logs-relating-to-application-startup)

## [AppServiceFileAuditLogs](./queries/AppServiceFileAuditLogs.md)

- [File Audit Logs relating to a "Delete" operation](./queries/AppServiceFileAuditLogs.md#file-audit-logs-relating-to-a-delete-operation)

## [AppServiceHTTPLogs](./queries/AppServiceHTTPLogs.md)

- [App Service Health](./queries/AppServiceHTTPLogs.md#app-service-health)
- [Failure Categorization](./queries/AppServiceHTTPLogs.md#failure-categorization)
- [Response times of requests](./queries/AppServiceHTTPLogs.md#response-times-of-requests)
- [Top 5 Clients](./queries/AppServiceHTTPLogs.md#top-5-clients)
- [Top 5 Machines](./queries/AppServiceHTTPLogs.md#top-5-machines)

## [AutoscaleEvaluationsLog](./queries/AutoscaleEvaluationsLog.md)

- [Review Autoscale evaluations](./queries/AutoscaleEvaluationsLog.md#review-autoscale-evaluations)

## [AutoscaleScaleActionsLog](./queries/AutoscaleScaleActionsLog.md)

- [Display top Autoscale 50 logs](./queries/AutoscaleScaleActionsLog.md#display-top-autoscale-50-logs)
- [Autoscale operation status](./queries/AutoscaleScaleActionsLog.md#autoscale-operation-status)
- [Autoscale failed operations](./queries/AutoscaleScaleActionsLog.md#autoscale-failed-operations)

## [AzureActivity](./queries/AzureActivity.md)

- [[Classic] Find In AzureActivity](./queries/AzureActivity.md#classic-find-in-azureactivity)
- [Shut down Virtual Machines](./queries/AzureActivity.md#shut-down-virtual-machines)
- [Latest 50 logs](./queries/AzureActivity.md#latest-50-logs)
- [Operations' status](./queries/AzureActivity.md#operations-status)
- [Recent Azure Activity logs](./queries/AzureActivity.md#recent-azure-activity-logs)
- [Failed operations](./queries/AzureActivity.md#failed-operations)
- [Resources creation](./queries/AzureActivity.md#resources-creation)
- [Find In AzureActivity](./queries/AzureActivity.md#find-in-azureactivity)
- [Show logs from AzureActivity table](./queries/AzureActivity.md#show-logs-from-azureactivity-table)
- [Show logs from AzureActivity table](./queries/AzureActivity.md#show-logs-from-azureactivity-table)
- [Display top 50 Activity log events](./queries/AzureActivity.md#display-top-50-activity-log-events)
- [Display Activity log Administrative events](./queries/AzureActivity.md#display-activity-log-administrative-events)
- [VM creation](./queries/AzureActivity.md#vm-creation)
- [Display Activity log events generated from Policy](./queries/AzureActivity.md#display-activity-log-events-generated-from-policy)
- [List callers and their associated action in last 48 hours](./queries/AzureActivity.md#list-callers-and-their-associated-action-in-last-48-hours)
- [All Azure Activity](./queries/AzureActivity.md#all-azure-activity)
- [Azure Activity for user](./queries/AzureActivity.md#azure-activity-for-user)
- [Successful key enumaration](./queries/AzureActivity.md#successful-key-enumaration)
- [Network Access JIT initiation](./queries/AzureActivity.md#network-access-jit-initiation)
- [Azure Activity operation statistics](./queries/AzureActivity.md#azure-activity-operation-statistics)

## [AzureAttestationDiagnostics](./queries/AzureAttestationDiagnostics.md)

- [Are there any authorization failures?](./queries/AzureAttestationDiagnostics.md#are-there-any-authorization-failures)
- [Are there any slow requests?](./queries/AzureAttestationDiagnostics.md#are-there-any-slow-requests)
- [How active has this Attestation provider been?](./queries/AzureAttestationDiagnostics.md#how-active-has-this-attestation-provider-been)
- [Who is calling this attestation provider?](./queries/AzureAttestationDiagnostics.md#who-is-calling-this-attestation-provider)
- [Have there been any changes to attestation policy?](./queries/AzureAttestationDiagnostics.md#have-there-been-any-changes-to-attestation-policy)
- [Have there been any errors attempting to configure the attestation policy?](./queries/AzureAttestationDiagnostics.md#have-there-been-any-errors-attempting-to-configure-the-attestation-policy)

## [AzureBackupOperations](./queries/AzureBackupOperations.md)

- [Get all backup operations](./queries/AzureBackupOperations.md#get-all-backup-operations)

## [AzureDiagnostics](./queries/AzureDiagnostics.md)

- [Errors in automation jobs](./queries/AzureDiagnostics.md#errors-in-automation-jobs)
- [Find logs reporting errors in automation jobs from the last day](./queries/AzureDiagnostics.md#find-logs-reporting-errors-in-automation-jobs-from-the-last-day)
- [Azure Automation jobs that are failed, suspended, or stopped](./queries/AzureDiagnostics.md#azure-automation-jobs-that-are-failed-suspended-or-stopped)
- [Runbook completed successfully with errors](./queries/AzureDiagnostics.md#runbook-completed-successfully-with-errors)
- [View historical job status](./queries/AzureDiagnostics.md#view-historical-job-status)
- [Azure Automation jobs that are Completed](./queries/AzureDiagnostics.md#azure-automation-jobs-that-are-completed)
- [Successful tasks per job](./queries/AzureDiagnostics.md#successful-tasks-per-job)
- [Failed tasks per job](./queries/AzureDiagnostics.md#failed-tasks-per-job)
- [Task durations](./queries/AzureDiagnostics.md#task-durations)
- [Pool resizes](./queries/AzureDiagnostics.md#pool-resizes)
- [Pool resize failures](./queries/AzureDiagnostics.md#pool-resize-failures)
- [[Microsoft CDN (classic)] Requests per hour](./queries/AzureDiagnostics.md#microsoft-cdn-classic-requests-per-hour)
- [[Microsoft CDN (classic)] Traffic by URL](./queries/AzureDiagnostics.md#microsoft-cdn-classic-traffic-by-url)
- [[Microsoft CDN (classic)] 4XX error rate by URL](./queries/AzureDiagnostics.md#microsoft-cdn-classic-4xx-error-rate-by-url)
- [[Microsoft CDN (classic)] Request errors by user agent](./queries/AzureDiagnostics.md#microsoft-cdn-classic-request-errors-by-user-agent)
- [[Microsoft CDN (classic)] Top 10 URL request count](./queries/AzureDiagnostics.md#microsoft-cdn-classic-top-10-url-request-count)
- [[Microsoft CDN (classic)] Unique IP request count](./queries/AzureDiagnostics.md#microsoft-cdn-classic-unique-ip-request-count)
- [[Microsoft CDN (classic)] Top 10 client IPs and HTTP versions](./queries/AzureDiagnostics.md#microsoft-cdn-classic-top-10-client-ips-and-http-versions)
- [[Azure Front Door Standard/Premium] Top 20 blocked clients by IP and rule](./queries/AzureDiagnostics.md#azure-front-door-standardpremium-top-20-blocked-clients-by-ip-and-rule)
- [[Azure Front Door Standard/Premium] Requests to origin by route](./queries/AzureDiagnostics.md#azure-front-door-standardpremium-requests-to-origin-by-route)
- [[Azure Front Door Standard/Premium] Request errors by user agent](./queries/AzureDiagnostics.md#azure-front-door-standardpremium-request-errors-by-user-agent)
- [[Azure Front Door Standard/Premium] Top 10 client IPs and http versions](./queries/AzureDiagnostics.md#azure-front-door-standardpremium-top-10-client-ips-and-http-versions)
- [[Azure Front Door Standard/Premium] Request errors by host and path](./queries/AzureDiagnostics.md#azure-front-door-standardpremium-request-errors-by-host-and-path)
- [[Azure Front Door Standard/Premium] Firewall blocked request count per hour](./queries/AzureDiagnostics.md#azure-front-door-standardpremium-firewall-blocked-request-count-per-hour)
- [[Azure Front Door Standard/Premium] Firewall request count by host, path, rule, and action](./queries/AzureDiagnostics.md#azure-front-door-standardpremium-firewall-request-count-by-host-path-rule-and-action)
- [[Azure Front Door Standard/Premium] Requests per hour](./queries/AzureDiagnostics.md#azure-front-door-standardpremium-requests-per-hour)
- [[Azure Front Door Standard/Premium] Top 10 URL request count](./queries/AzureDiagnostics.md#azure-front-door-standardpremium-top-10-url-request-count)
- [ [Azure Front Door Standard/Premium] Top 10 URL request count ](./queries/AzureDiagnostics.md#azure-front-door-standardpremium-top-10-url-request-count)
- [[Azure Front Door Standard/Premium]  Unique IP request count](./queries/AzureDiagnostics.md#azure-front-door-standardpremium--unique-ip-request-count)
- [Find In AzureDiagnostics](./queries/AzureDiagnostics.md#find-in-azurediagnostics)
- [Execution time exceeding a threshold](./queries/AzureDiagnostics.md#execution-time-exceeding-a-threshold)
- [Show the Slowest queries ](./queries/AzureDiagnostics.md#show-the-slowest-queries)
- [Show Query's statistics](./queries/AzureDiagnostics.md#show-querys-statistics)
- [Review audit log events in GENERAL class ](./queries/AzureDiagnostics.md#review-audit-log-events-in-general-class)
- [Review audit log events in CONNECTION class ](./queries/AzureDiagnostics.md#review-audit-log-events-in-connection-class)
- [Execution time exceeding a threshold](./queries/AzureDiagnostics.md#execution-time-exceeding-a-threshold)
- [Show the Slowest queries ](./queries/AzureDiagnostics.md#show-the-slowest-queries)
- [Show Query's statistics](./queries/AzureDiagnostics.md#show-querys-statistics)
- [Review audit log events in GENERAL class ](./queries/AzureDiagnostics.md#review-audit-log-events-in-general-class)
- [Review audit log events in CONNECTION class ](./queries/AzureDiagnostics.md#review-audit-log-events-in-connection-class)
- [Autovacuum events](./queries/AzureDiagnostics.md#autovacuum-events)
- [Server restarts](./queries/AzureDiagnostics.md#server-restarts)
- [Find Errors](./queries/AzureDiagnostics.md#find-errors)
- [Unauthorized connections](./queries/AzureDiagnostics.md#unauthorized-connections)
- [Deadlocks](./queries/AzureDiagnostics.md#deadlocks)
- [Lock contention](./queries/AzureDiagnostics.md#lock-contention)
- [Audit logs](./queries/AzureDiagnostics.md#audit-logs)
- [Audit logs for table(s) and event type(s)](./queries/AzureDiagnostics.md#audit-logs-for-tables-and-event-types)
- [Queries with execution time exceeding a threshold](./queries/AzureDiagnostics.md#queries-with-execution-time-exceeding-a-threshold)
- [Slowest queries](./queries/AzureDiagnostics.md#slowest-queries)
- [Query statistics](./queries/AzureDiagnostics.md#query-statistics)
- [Execution count trends](./queries/AzureDiagnostics.md#execution-count-trends)
- [Top wait events](./queries/AzureDiagnostics.md#top-wait-events)
- [Wait event trends](./queries/AzureDiagnostics.md#wait-event-trends)
- [Connectvity errors](./queries/AzureDiagnostics.md#connectvity-errors)
- [Devices with most throttling errors](./queries/AzureDiagnostics.md#devices-with-most-throttling-errors)
- [Dead endpoints](./queries/AzureDiagnostics.md#dead-endpoints)
- [Error summary](./queries/AzureDiagnostics.md#error-summary)
- [Recently connected devices](./queries/AzureDiagnostics.md#recently-connected-devices)
- [SDK version of devices](./queries/AzureDiagnostics.md#sdk-version-of-devices)
- [Consumed RU/s in last 24 hours](./queries/AzureDiagnostics.md#consumed-rus-in-last-24-hours)
- [Collections with throttles (429) in past 24 hours](./queries/AzureDiagnostics.md#collections-with-throttles-429-in-past-24-hours)
- [Top operations by consumed Request Units (RUs) in last 24 hours](./queries/AzureDiagnostics.md#top-operations-by-consumed-request-units-rus-in-last-24-hours)
- [Top logical partition keys by storage](./queries/AzureDiagnostics.md#top-logical-partition-keys-by-storage)
- [[Classic] Duration of Capture failure](./queries/AzureDiagnostics.md#classic-duration-of-capture-failure)
- [[Classic] Join request for client](./queries/AzureDiagnostics.md#classic-join-request-for-client)
- [[Classic] Access to keyvault - key not found](./queries/AzureDiagnostics.md#classic-access-to-keyvault---key-not-found)
- [[Classic] Operation performed with keyvault](./queries/AzureDiagnostics.md#classic-operation-performed-with-keyvault)
- [Errors in the last 7 days](./queries/AzureDiagnostics.md#errors-in-the-last-7-days)
- [Duration of Capture failure](./queries/AzureDiagnostics.md#duration-of-capture-failure)
- [Join request for client](./queries/AzureDiagnostics.md#join-request-for-client)
- [Access to keyvault - key not found](./queries/AzureDiagnostics.md#access-to-keyvault---key-not-found)
- [Operation performed with keyvault](./queries/AzureDiagnostics.md#operation-performed-with-keyvault)
- [[Classic] How active has this KeyVault been?](./queries/AzureDiagnostics.md#classic-how-active-has-this-keyvault-been)
- [[Classic] Who is calling this KeyVault?](./queries/AzureDiagnostics.md#classic-who-is-calling-this-keyvault)
- [[Classic] Are there any slow requests?](./queries/AzureDiagnostics.md#classic-are-there-any-slow-requests)
- [[Classic] How fast is this KeyVault serving requests?](./queries/AzureDiagnostics.md#classic-how-fast-is-this-keyvault-serving-requests)
- [[Classic] Are there any failures?](./queries/AzureDiagnostics.md#classic-are-there-any-failures)
- [[Classic] What changes occurred last month?](./queries/AzureDiagnostics.md#classic-what-changes-occurred-last-month)
- [[Classic] List all input deserialization errors](./queries/AzureDiagnostics.md#classic-list-all-input-deserialization-errors)
- [[Classic] Find In AzureDiagnostics](./queries/AzureDiagnostics.md#classic-find-in-azurediagnostics)
- [Total billable executions](./queries/AzureDiagnostics.md#total-billable-executions)
- [Logic App execution distribution by workflows](./queries/AzureDiagnostics.md#logic-app-execution-distribution-by-workflows)
- [Logic App execution distribution by status](./queries/AzureDiagnostics.md#logic-app-execution-distribution-by-status)
- [Triggered failures count](./queries/AzureDiagnostics.md#triggered-failures-count)
- [Requests per hour](./queries/AzureDiagnostics.md#requests-per-hour)
- [Non-SSL requests per hour](./queries/AzureDiagnostics.md#non-ssl-requests-per-hour)
- [Failed requests per hour](./queries/AzureDiagnostics.md#failed-requests-per-hour)
- [Errors by user agent](./queries/AzureDiagnostics.md#errors-by-user-agent)
- [Errors by URI](./queries/AzureDiagnostics.md#errors-by-uri)
- [Top 10 Client IPs](./queries/AzureDiagnostics.md#top-10-client-ips)
- [Top HTTP versions](./queries/AzureDiagnostics.md#top-http-versions)
- [Network security events](./queries/AzureDiagnostics.md#network-security-events)
- [Requests per hour](./queries/AzureDiagnostics.md#requests-per-hour)
- [Forwarded backend requests by routing rule](./queries/AzureDiagnostics.md#forwarded-backend-requests-by-routing-rule)
- [Request errors by host and path](./queries/AzureDiagnostics.md#request-errors-by-host-and-path)
- [Request errors by user agent](./queries/AzureDiagnostics.md#request-errors-by-user-agent)
- [Top 10 client IPs and http versions](./queries/AzureDiagnostics.md#top-10-client-ips-and-http-versions)
- [Firewall blocked request count per hour](./queries/AzureDiagnostics.md#firewall-blocked-request-count-per-hour)
- [Top 20 blocked clients by IP and rule](./queries/AzureDiagnostics.md#top-20-blocked-clients-by-ip-and-rule)
- [Firewall request count by host, path, rule, and action](./queries/AzureDiagnostics.md#firewall-request-count-by-host-path-rule-and-action)
- [Application rule log data](./queries/AzureDiagnostics.md#application-rule-log-data)
- [Network rule log data](./queries/AzureDiagnostics.md#network-rule-log-data)
- [Threat Intelligence rule log data](./queries/AzureDiagnostics.md#threat-intelligence-rule-log-data)
- [Azure Firewall log data](./queries/AzureDiagnostics.md#azure-firewall-log-data)
- [Azure Firewall DNS proxy log data](./queries/AzureDiagnostics.md#azure-firewall-dns-proxy-log-data)
- [BGP route table](./queries/AzureDiagnostics.md#bgp-route-table)
- [BGP informational messages](./queries/AzureDiagnostics.md#bgp-informational-messages)
- [Endpoints with monitoring Status down](./queries/AzureDiagnostics.md#endpoints-with-monitoring-status-down)
- [Successful P2S connections](./queries/AzureDiagnostics.md#successful-p2s-connections)
- [Failed P2S connections](./queries/AzureDiagnostics.md#failed-p2s-connections)
- [Gateway configuration changes](./queries/AzureDiagnostics.md#gateway-configuration-changes)
- [S2S tunnel connet/disconnect events](./queries/AzureDiagnostics.md#s2s-tunnel-connetdisconnect-events)
- [BGP route updates](./queries/AzureDiagnostics.md#bgp-route-updates)
- [Show logs from AzureDiagnostics table](./queries/AzureDiagnostics.md#show-logs-from-azurediagnostics-table)
- [Failed backup jobs](./queries/AzureDiagnostics.md#failed-backup-jobs)
- [[Classic] List Management operations](./queries/AzureDiagnostics.md#classic-list-management-operations)
- [[Classic] Error Summary](./queries/AzureDiagnostics.md#classic-error-summary)
- [[Classic] Keyvault access attempt - key not found](./queries/AzureDiagnostics.md#classic-keyvault-access-attempt---key-not-found)
- [[Classic] AutoDeleted entities](./queries/AzureDiagnostics.md#classic-autodeleted-entities)
- [[Classic] Keyvault performed operational](./queries/AzureDiagnostics.md#classic-keyvault-performed-operational)
- [Management operations in the last 7 days](./queries/AzureDiagnostics.md#management-operations-in-the-last-7-days)
- [Errors summary](./queries/AzureDiagnostics.md#errors-summary)
- [Keyvault access attempt - key not found](./queries/AzureDiagnostics.md#keyvault-access-attempt---key-not-found)
- [AutoDeleted entities](./queries/AzureDiagnostics.md#autodeleted-entities)
- [Keyvault performed operational](./queries/AzureDiagnostics.md#keyvault-performed-operational)
- [Storage on managed instances above 90%](./queries/AzureDiagnostics.md#storage-on-managed-instances-above-90)
- [CPU utilization treshold above 95% on managed instances](./queries/AzureDiagnostics.md#cpu-utilization-treshold-above-95-on-managed-instances)
- [Display all active intelligent insights](./queries/AzureDiagnostics.md#display-all-active-intelligent-insights)
- [Wait stats](./queries/AzureDiagnostics.md#wait-stats)
- [List all input data errors](./queries/AzureDiagnostics.md#list-all-input-data-errors)
- [List all input deserialization errors](./queries/AzureDiagnostics.md#list-all-input-deserialization-errors)
- [List all InvalidInputTimeStamp errors](./queries/AzureDiagnostics.md#list-all-invalidinputtimestamp-errors)
- [List all InvalidInputTimeStampKey errors](./queries/AzureDiagnostics.md#list-all-invalidinputtimestampkey-errors)
- [Events that arrived late](./queries/AzureDiagnostics.md#events-that-arrived-late)
- [Events that arrived early](./queries/AzureDiagnostics.md#events-that-arrived-early)
- [Events that arrived out of order](./queries/AzureDiagnostics.md#events-that-arrived-out-of-order)
- [All output data errors](./queries/AzureDiagnostics.md#all-output-data-errors)
- [List all RequiredColumnMissing errors](./queries/AzureDiagnostics.md#list-all-requiredcolumnmissing-errors)
- [List all ColumnNameInvalid errors](./queries/AzureDiagnostics.md#list-all-columnnameinvalid-errors)
- [List all TypeConversionError errors](./queries/AzureDiagnostics.md#list-all-typeconversionerror-errors)
- [List all RecordExceededSizeLimit errors](./queries/AzureDiagnostics.md#list-all-recordexceededsizelimit-errors)
- [List all DuplicateKey errors](./queries/AzureDiagnostics.md#list-all-duplicatekey-errors)
- [All logs with level "Error"](./queries/AzureDiagnostics.md#all-logs-with-level-error)
- [Operations that have "Failed"](./queries/AzureDiagnostics.md#operations-that-have-failed)
- [Output Throttling logs (Cosmos DB, Power BI, Event Hubs)](./queries/AzureDiagnostics.md#output-throttling-logs-cosmos-db-power-bi-event-hubs)
- [Transient input and output errors](./queries/AzureDiagnostics.md#transient-input-and-output-errors)
- [Summary of all data errors in the last 7 days](./queries/AzureDiagnostics.md#summary-of-all-data-errors-in-the-last-7-days)
- [Summary of all errors in the last 7 days](./queries/AzureDiagnostics.md#summary-of-all-errors-in-the-last-7-days)
- [Summary of 'Failed' operations in the last 7 days](./queries/AzureDiagnostics.md#summary-of-failed-operations-in-the-last-7-days)

## [AzureLoadTestingOperation](./queries/AzureLoadTestingOperation.md)

- [Azure load test creation count](./queries/AzureLoadTestingOperation.md#azure-load-test-creation-count)
- [Azure load test run creation count](./queries/AzureLoadTestingOperation.md#azure-load-test-run-creation-count)

## [AzureMetrics](./queries/AzureMetrics.md)

- [Pie chart of HTTP response codes](./queries/AzureMetrics.md#pie-chart-of-http-response-codes)
- [Line chart of response times](./queries/AzureMetrics.md#line-chart-of-response-times)
- [[Classic] Find In AzureMetrics](./queries/AzureMetrics.md#classic-find-in-azuremetrics)
- [Latest metrics](./queries/AzureMetrics.md#latest-metrics)
- [Find In AzureMetrics](./queries/AzureMetrics.md#find-in-azuremetrics)
- [ExpressRoute Circuit BitsInPerSecond traffic graph](./queries/AzureMetrics.md#expressroute-circuit-bitsinpersecond-traffic-graph)
- [ExpressRoute Circuit BitsOutPerSecond traffic graph](./queries/AzureMetrics.md#expressroute-circuit-bitsoutpersecond-traffic-graph)
- [ExpressRoute Circuit ArpAvailablility graph](./queries/AzureMetrics.md#expressroute-circuit-arpavailablility-graph)
- [ExpressRoute Circuit BGP availability](./queries/AzureMetrics.md#expressroute-circuit-bgp-availability)
- [Avg CPU usage](./queries/AzureMetrics.md#avg-cpu-usage)
- [Performance troubleshooting](./queries/AzureMetrics.md#performance-troubleshooting)
- [Loading Data](./queries/AzureMetrics.md#loading-data)
- [P2S connection count](./queries/AzureMetrics.md#p2s-connection-count)
- [P2S bandwidth utilization](./queries/AzureMetrics.md#p2s-bandwidth-utilization)
- [Gateway throughput](./queries/AzureMetrics.md#gateway-throughput)
- [Show logs from AzureMetrics table](./queries/AzureMetrics.md#show-logs-from-azuremetrics-table)
- [Show logs from AzureMetrics table](./queries/AzureMetrics.md#show-logs-from-azuremetrics-table)
- [Cluster availability (KeepAlive)](./queries/AzureMetrics.md#cluster-availability-keepalive)

## [CCFApplicationLogs](./queries/CCFApplicationLogs.md)

- [CCF application errors](./queries/CCFApplicationLogs.md#ccf-application-errors)

## [CIEventsAudit](./queries/CIEventsAudit.md)

- [CIEventsAudit - API response codes line chart](./queries/CIEventsAudit.md#cieventsaudit---api-response-codes-line-chart)
- [CIEventsAudit - result type ClientError](./queries/CIEventsAudit.md#cieventsaudit---result-type-clienterror)
- [CIEventsAudit - security level Error](./queries/CIEventsAudit.md#cieventsaudit---security-level-error)
- [CIEvents - all events for a specific correlation id](./queries/CIEventsAudit.md#cievents---all-events-for-a-specific-correlation-id)
- [CIEventsAudit - all events for a specific instance ID](./queries/CIEventsAudit.md#cieventsaudit---all-events-for-a-specific-instance-id)

## [CIEventsOperational](./queries/CIEventsOperational.md)

- [CIEventsOperational - event type ApiEvent](./queries/CIEventsOperational.md#cieventsoperational---event-type-apievent)
- [CIEventsOperational- event type WorkflowEvent](./queries/CIEventsOperational.md#cieventsoperational--event-type-workflowevent)
- [CIEvents - all events for a specific correlation id](./queries/CIEventsOperational.md#cievents---all-events-for-a-specific-correlation-id)
- [CIEventsOperational - all events for a specific instance ID](./queries/CIEventsOperational.md#cieventsoperational---all-events-for-a-specific-instance-id)

## [CassandraLogs](./queries/CassandraLogs.md)

- [Cassandra logs](./queries/CassandraLogs.md#cassandra-logs)
- [Cassandra errors or warnings](./queries/CassandraLogs.md#cassandra-errors-or-warnings)

## [ChaosStudioExperimentEventLogs](./queries/ChaosStudioExperimentEventLogs.md)

- [Failed experiment runs](./queries/ChaosStudioExperimentEventLogs.md#failed-experiment-runs)
- [Experiment events on last experiment run](./queries/ChaosStudioExperimentEventLogs.md#experiment-events-on-last-experiment-run)

## [CloudAppEvents](./queries/CloudAppEvents.md)

- [File name extension change](./queries/CloudAppEvents.md#file-name-extension-change)

## [CloudHsmServiceOperationAuditLogs](./queries/CloudHsmServiceOperationAuditLogs.md)

- [Are there any slow requests?](./queries/CloudHsmServiceOperationAuditLogs.md#are-there-any-slow-requests)
- [How active has this Cloud HSM been?](./queries/CloudHsmServiceOperationAuditLogs.md#how-active-has-this-cloud-hsm-been)
- [Are there any failures?](./queries/CloudHsmServiceOperationAuditLogs.md#are-there-any-failures)

## [CommonSecurityLog](./queries/CommonSecurityLog.md)

- [Palo Alto collector machine usage](./queries/CommonSecurityLog.md#palo-alto-collector-machine-usage)
- [Cisco ASA events type usage](./queries/CommonSecurityLog.md#cisco-asa-events-type-usage)
- [Device events volume statistics](./queries/CommonSecurityLog.md#device-events-volume-statistics)

## [ConfidentialWatchlist](./queries/ConfidentialWatchlist.md)

- [Get confidential Watchlist aliases](./queries/ConfidentialWatchlist.md#get-confidential-watchlist-aliases)
- [Lookup events using a confidential Watchlist](./queries/ConfidentialWatchlist.md#lookup-events-using-a-confidential-watchlist)

## [ConfigurationChange](./queries/ConfigurationChange.md)

- [Stopped Windows services ](./queries/ConfigurationChange.md#stopped-windows-services)
- [Software changes](./queries/ConfigurationChange.md#software-changes)
- [Service changes](./queries/ConfigurationChange.md#service-changes)
- [Software change type per computer](./queries/ConfigurationChange.md#software-change-type-per-computer)
- [Stopped services](./queries/ConfigurationChange.md#stopped-services)
- [Software change count per category](./queries/ConfigurationChange.md#software-change-count-per-category)
- [Removed software changes](./queries/ConfigurationChange.md#removed-software-changes)

## [ConfigurationData](./queries/ConfigurationData.md)

- [Recent stopped auto services](./queries/ConfigurationData.md#recent-stopped-auto-services)

## [ContainerAppConsoleLogs](./queries/ContainerAppConsoleLogs.md)

- [Latest Container App user errors](./queries/ContainerAppConsoleLogs.md#latest-container-app-user-errors)

## [ContainerImageInventory](./queries/ContainerImageInventory.md)

- [Image inventory](./queries/ContainerImageInventory.md#image-inventory)
- [Find In ContainerImageInventory](./queries/ContainerImageInventory.md#find-in-containerimageinventory)

## [ContainerInventory](./queries/ContainerInventory.md)

- [Container Lifecycle Information](./queries/ContainerInventory.md#container-lifecycle-information)

## [ContainerLog](./queries/ContainerLog.md)

- [Find a value in Container Logs Table](./queries/ContainerLog.md#find-a-value-in-container-logs-table)
- [Billable Log Data by log-type](./queries/ContainerLog.md#billable-log-data-by-log-type)
- [List container logs per namespace](./queries/ContainerLog.md#list-container-logs-per-namespace)
- [Find In ContainerLog](./queries/ContainerLog.md#find-in-containerlog)

## [ContainerLogV2](./queries/ContainerLogV2.md)

- [Find In ContainerLogV2](./queries/ContainerLogV2.md#find-in-containerlogv2)

## [ContainerNodeInventory](./queries/ContainerNodeInventory.md)

- [Find In ContainerNodeInventory](./queries/ContainerNodeInventory.md#find-in-containernodeinventory)

## [ContainerRegistryLoginEvents](./queries/ContainerRegistryLoginEvents.md)

- [Show login events reported over the last hour](./queries/ContainerRegistryLoginEvents.md#show-login-events-reported-over-the-last-hour)

## [ContainerRegistryRepositoryEvents](./queries/ContainerRegistryRepositoryEvents.md)

- [Show registry events reported over the last hour](./queries/ContainerRegistryRepositoryEvents.md#show-registry-events-reported-over-the-last-hour)

## [ContainerServiceLog](./queries/ContainerServiceLog.md)

- [Find In ContainerServiceLog](./queries/ContainerServiceLog.md#find-in-containerservicelog)

## [CoreAzureBackup](./queries/CoreAzureBackup.md)

- [Backup Items by Vault and Backup item type](./queries/CoreAzureBackup.md#backup-items-by-vault-and-backup-item-type)

## [DCRLogErrors](./queries/DCRLogErrors.md)

- [Ingestion and Transformation errors from data collection rules](./queries/DCRLogErrors.md#ingestion-and-transformation-errors-from-data-collection-rules)

## [DNSQueryLogs](./queries/DNSQueryLogs.md)

- [DNS queries by virtual network and return code](./queries/DNSQueryLogs.md#dns-queries-by-virtual-network-and-return-code)

## [DataTransferOperations](./queries/DataTransferOperations.md)

- [Discovered object](./queries/DataTransferOperations.md#discovered-object)
- [Terminal object state](./queries/DataTransferOperations.md#terminal-object-state)

## [DatabricksWorkspaceLogs](./queries/DatabricksWorkspaceLogs.md)

- [List all Databricks Diagnostic Settings categories](./queries/DatabricksWorkspaceLogs.md#list-all-databricks-diagnostic-settings-categories)

## [DataverseActivity](./queries/DataverseActivity.md)

- [Dataverse events filtered by operation type](./queries/DataverseActivity.md#dataverse-events-filtered-by-operation-type)

## [DevCenterDiagnosticLogs](./queries/DevCenterDiagnosticLogs.md)

- [Failed actions query](./queries/DevCenterDiagnosticLogs.md#failed-actions-query)

## [DevCenterResourceOperationLogs](./queries/DevCenterResourceOperationLogs.md)

- [Hibernate Unsupported Check](./queries/DevCenterResourceOperationLogs.md#hibernate-unsupported-check)

## [DeviceCalendar](./queries/DeviceCalendar.md)

- [Exchange Error](./queries/DeviceCalendar.md#exchange-error)

## [DeviceCleanup](./queries/DeviceCleanup.md)

- [Cleanup Failure](./queries/DeviceCleanup.md#cleanup-failure)

## [DeviceHardwareHealth](./queries/DeviceHardwareHealth.md)

- [Hardware Minor](./queries/DeviceHardwareHealth.md#hardware-minor)
- [Hardware Alert](./queries/DeviceHardwareHealth.md#hardware-alert)

## [DeviceHealth](./queries/DeviceHealth.md)

- [Software Alert](./queries/DeviceHealth.md#software-alert)

## [DeviceSkypeHeartbeat](./queries/DeviceSkypeHeartbeat.md)

- [Skype Error](./queries/DeviceSkypeHeartbeat.md#skype-error)

## [DeviceTvmSecureConfigurationAssessment](./queries/DeviceTvmSecureConfigurationAssessment.md)

- [Devices with antivirus configurations issue](./queries/DeviceTvmSecureConfigurationAssessment.md#devices-with-antivirus-configurations-issue)

## [DeviceTvmSoftwareInventory](./queries/DeviceTvmSoftwareInventory.md)

- [Unsupported software titles](./queries/DeviceTvmSoftwareInventory.md#unsupported-software-titles)

## [DeviceTvmSoftwareVulnerabilities](./queries/DeviceTvmSoftwareVulnerabilities.md)

- [Devices affected by a specific vulnerability](./queries/DeviceTvmSoftwareVulnerabilities.md#devices-affected-by-a-specific-vulnerability)

## [DnsEvents](./queries/DnsEvents.md)

- [Clients Resolving Malicious Domains](./queries/DnsEvents.md#clients-resolving-malicious-domains)

## [EGNFailedHttpDataPlaneOperations](./queries/EGNFailedHttpDataPlaneOperations.md)

- [TLS 1.3 Lower query](./queries/EGNFailedHttpDataPlaneOperations.md#tls-13-lower-query)

## [EGNFailedMqttConnections](./queries/EGNFailedMqttConnections.md)

- [Authentication error query](./queries/EGNFailedMqttConnections.md#authentication-error-query)

## [EGNMqttDisconnections](./queries/EGNMqttDisconnections.md)

- [Disconnections reason query](./queries/EGNMqttDisconnections.md#disconnections-reason-query)
- [Session disconnections query](./queries/EGNMqttDisconnections.md#session-disconnections-query)

## [EGNSuccessfulHttpDataPlaneOperations](./queries/EGNSuccessfulHttpDataPlaneOperations.md)

- [TLS 1.3 Lower query](./queries/EGNSuccessfulHttpDataPlaneOperations.md#tls-13-lower-query)

## [EGNSuccessfulMqttConnections](./queries/EGNSuccessfulMqttConnections.md)

- [Session connections query](./queries/EGNSuccessfulMqttConnections.md#session-connections-query)

## [EmailAttachmentInfo](./queries/EmailAttachmentInfo.md)

- [Files from malicious sender](./queries/EmailAttachmentInfo.md#files-from-malicious-sender)
- [Emails to external domains with attachments](./queries/EmailAttachmentInfo.md#emails-to-external-domains-with-attachments)

## [EmailEvents](./queries/EmailEvents.md)

- [Phishing emails from the top 10 sender domains](./queries/EmailEvents.md#phishing-emails-from-the-top-10-sender-domains)
- [Emails with malware](./queries/EmailEvents.md#emails-with-malware)

## [EmailPostDeliveryEvents](./queries/EmailPostDeliveryEvents.md)

- [Post-delivery administrator actions](./queries/EmailPostDeliveryEvents.md#post-delivery-administrator-actions)
- [Unremediated post-delivery phishing email detections](./queries/EmailPostDeliveryEvents.md#unremediated-post-delivery-phishing-email-detections)
- [Full email processing details](./queries/EmailPostDeliveryEvents.md#full-email-processing-details)

## [EmailUrlInfo](./queries/EmailUrlInfo.md)

- [URLs in an email](./queries/EmailUrlInfo.md#urls-in-an-email)

## [Event](./queries/Event.md)

- [Memory usage percentage](./queries/Event.md#memory-usage-percentage)
- [Avg node CPU usage percentage](./queries/Event.md#avg-node-cpu-usage-percentage)
- [Virtual machines failed](./queries/Event.md#virtual-machines-failed)
- [Total virtual machines in a cluster.](./queries/Event.md#total-virtual-machines-in-a-cluster)
- [Available volume capacity in a cluster.](./queries/Event.md#available-volume-capacity-in-a-cluster)
- [Volume latency](./queries/Event.md#volume-latency)
- [Volume IOPS](./queries/Event.md#volume-iops)
- [Volume throughput](./queries/Event.md#volume-throughput)
- [Cluster node down](./queries/Event.md#cluster-node-down)
- [Memory usage percentage](./queries/Event.md#memory-usage-percentage)
- [Ingestion latency (end-to-end) timechart - Event table](./queries/Event.md#ingestion-latency-end-to-end-timechart---event-table)
- [Show the trend of a selected event](./queries/Event.md#show-the-trend-of-a-selected-event)
- [Error event on computer missing security co critical update](./queries/Event.md#error-event-on-computer-missing-security-co-critical-update)
- [All Events in the past hour](./queries/Event.md#all-events-in-the-past-hour)
- [Events started](./queries/Event.md#events-started)
- [Events by event source](./queries/Event.md#events-by-event-source)
- [Events by event ID](./queries/Event.md#events-by-event-id)
- [Warning events](./queries/Event.md#warning-events)
- [Count of warning events](./queries/Event.md#count-of-warning-events)
- [Events in OM between 2000 to 3000](./queries/Event.md#events-in-om-between-2000-to-3000)
- [Windows Fireawall policy settings](./queries/Event.md#windows-fireawall-policy-settings)
- [Windows Fireawall policy settings changed by machines](./queries/Event.md#windows-fireawall-policy-settings-changed-by-machines)

## [FailedIngestion](./queries/FailedIngestion.md)

- [Failed ingestions by errors](./queries/FailedIngestion.md#failed-ingestions-by-errors)
- [Failed ingestions timechart](./queries/FailedIngestion.md#failed-ingestions-timechart)
- [Failed Ingestions](./queries/FailedIngestion.md#failed-ingestions)

## [FunctionAppLogs](./queries/FunctionAppLogs.md)

- [Show application logs from Function Apps](./queries/FunctionAppLogs.md#show-application-logs-from-function-apps)
- [Show logs with warnings or exceptions](./queries/FunctionAppLogs.md#show-logs-with-warnings-or-exceptions)
- [Error and exception count](./queries/FunctionAppLogs.md#error-and-exception-count)
- [Function activity over time](./queries/FunctionAppLogs.md#function-activity-over-time)
- [Function results](./queries/FunctionAppLogs.md#function-results)
- [Function Error rate](./queries/FunctionAppLogs.md#function-error-rate)

## [GCPAuditLogs](./queries/GCPAuditLogs.md)

- [PubSub subscription logs with severity info](./queries/GCPAuditLogs.md#pubsub-subscription-logs-with-severity-info)

## [Heartbeat](./queries/Heartbeat.md)

- [Count heartbeats](./queries/Heartbeat.md#count-heartbeats)
- [Last heartbeat of each computer](./queries/Heartbeat.md#last-heartbeat-of-each-computer)
- [Ingestion latency (end-to-end) spikes - Heartbeat table](./queries/Heartbeat.md#ingestion-latency-end-to-end-spikes---heartbeat-table)
- [Agent latency spikes - Heartbeat table](./queries/Heartbeat.md#agent-latency-spikes---heartbeat-table)
- [Recently stopped heartbeats - Heartbeat table](./queries/Heartbeat.md#recently-stopped-heartbeats---heartbeat-table)
- [Computers availability today](./queries/Heartbeat.md#computers-availability-today)
- [Unavailable computers](./queries/Heartbeat.md#unavailable-computers)
- [Availability rate](./queries/Heartbeat.md#availability-rate)
- [Not reporting VMs](./queries/Heartbeat.md#not-reporting-vms)
- [Computers list](./queries/Heartbeat.md#computers-list)
- [Find In Heartbeat](./queries/Heartbeat.md#find-in-heartbeat)

## [IdentityDirectoryEvents](./queries/IdentityDirectoryEvents.md)

- [Group Membership changed](./queries/IdentityDirectoryEvents.md#group-membership-changed)
- [Password change event](./queries/IdentityDirectoryEvents.md#password-change-event)

## [IdentityLogonEvents](./queries/IdentityLogonEvents.md)

- [LDAP authentication processes with cleartext passwords](./queries/IdentityLogonEvents.md#ldap-authentication-processes-with-cleartext-passwords)

## [IdentityQueryEvents](./queries/IdentityQueryEvents.md)

- [SAMR queries to Active Directory](./queries/IdentityQueryEvents.md#samr-queries-to-active-directory)

## [InsightsMetrics](./queries/InsightsMetrics.md)

- [IoT Edge: Device offline or not sending messages upstream at expected rate](./queries/InsightsMetrics.md#iot-edge-device-offline-or-not-sending-messages-upstream-at-expected-rate)
- [IoT Edge: Edge Hub queue size over threshold](./queries/InsightsMetrics.md#iot-edge-edge-hub-queue-size-over-threshold)
- [Maximum node disk ](./queries/InsightsMetrics.md#maximum-node-disk)
- [Prometheus disk read per second per node](./queries/InsightsMetrics.md#prometheus-disk-read-per-second-per-node)
- [Find In InsightsMetrics](./queries/InsightsMetrics.md#find-in-insightsmetrics)
- [What data is being collected?](./queries/InsightsMetrics.md#what-data-is-being-collected)
- [Virtual Machine available memory](./queries/InsightsMetrics.md#virtual-machine-available-memory)
- [Chart CPU usage trends by computer](./queries/InsightsMetrics.md#chart-cpu-usage-trends-by-computer)
- [Virtual Machine free disk space ](./queries/InsightsMetrics.md#virtual-machine-free-disk-space)
- [Track VM Availability using Heartbeat ](./queries/InsightsMetrics.md#track-vm-availability-using-heartbeat)
- [Top 10 Virtual Machines by CPU utilization](./queries/InsightsMetrics.md#top-10-virtual-machines-by-cpu-utilization)
- [Bottom 10 Free disk space %](./queries/InsightsMetrics.md#bottom-10-free-disk-space-)

## [KubeEvents](./queries/KubeEvents.md)

- [Kubernetes events](./queries/KubeEvents.md#kubernetes-events)
- [Find In KubeEvents](./queries/KubeEvents.md#find-in-kubeevents)

## [KubeMonAgentEvents](./queries/KubeMonAgentEvents.md)

- [Find In KubeMonAgentEvents](./queries/KubeMonAgentEvents.md#find-in-kubemonagentevents)

## [KubeNodeInventory](./queries/KubeNodeInventory.md)

- [Avg node CPU usage percentage per minute ](./queries/KubeNodeInventory.md#avg-node-cpu-usage-percentage-per-minute)
- [Avg node memory usage percentage per minute](./queries/KubeNodeInventory.md#avg-node-memory-usage-percentage-per-minute)
- [Readiness status per node](./queries/KubeNodeInventory.md#readiness-status-per-node)
- [Find In KubeNodeInventory](./queries/KubeNodeInventory.md#find-in-kubenodeinventory)

## [KubePodInventory](./queries/KubePodInventory.md)

- [Pods in crash loop](./queries/KubePodInventory.md#pods-in-crash-loop)
- [Pods in pending state](./queries/KubePodInventory.md#pods-in-pending-state)
- [Find In KubePodInventory](./queries/KubePodInventory.md#find-in-kubepodinventory)

## [KubeServices](./queries/KubeServices.md)

- [Find In KubeServices](./queries/KubeServices.md#find-in-kubeservices)

## [LAQueryLogs](./queries/LAQueryLogs.md)

- [Most Requested ResourceIds](./queries/LAQueryLogs.md#most-requested-resourceids)
- [Unauthorized Users](./queries/LAQueryLogs.md#unauthorized-users)
- [Throttled Users](./queries/LAQueryLogs.md#throttled-users)
- [Request Count by ResponseCode](./queries/LAQueryLogs.md#request-count-by-responsecode)
- [Top 10 resource intensive queries](./queries/LAQueryLogs.md#top-10-resource-intensive-queries)
- [Top 10 longest time range queries](./queries/LAQueryLogs.md#top-10-longest-time-range-queries)

## [LASummaryLogs](./queries/LASummaryLogs.md)

- [Bin Rules Query Duration](./queries/LASummaryLogs.md#bin-rules-query-duration)

## [LogicAppWorkflowRuntime](./queries/LogicAppWorkflowRuntime.md)

- [Count of failed workflow operations from Logic App Workflow Runtime](./queries/LogicAppWorkflowRuntime.md#count-of-failed-workflow-operations-from-logic-app-workflow-runtime)

## [MDCDetectionDNSEvents](./queries/MDCDetectionDNSEvents.md)

- [All DNS events where the domain queried was 'www.google.com' ordered by time](./queries/MDCDetectionDNSEvents.md#all-dns-events-where-the-domain-queried-was-wwwgooglecom-ordered-by-time)

## [MDCDetectionFimEvents](./queries/MDCDetectionFimEvents.md)

- [All FIM events for directories](./queries/MDCDetectionFimEvents.md#all-fim-events-for-directories)

## [MDCDetectionGatingValidationEvents](./queries/MDCDetectionGatingValidationEvents.md)

- [All recent Gating validation events](./queries/MDCDetectionGatingValidationEvents.md#all-recent-gating-validation-events)

## [MNFDeviceUpdates](./queries/MNFDeviceUpdates.md)

- [Find all entries where value is active](./queries/MNFDeviceUpdates.md#find-all-entries-where-value-is-active)
- [Find all entries where value is up](./queries/MNFDeviceUpdates.md#find-all-entries-where-value-is-up)
- [Find all events of the type VxlanVlanToVniVlan](./queries/MNFDeviceUpdates.md#find-all-events-of-the-type-vxlanvlantovnivlan)
- [Find all entries where afisafiname is not of the type L2VPN_EVPN](./queries/MNFDeviceUpdates.md#find-all-entries-where-afisafiname-is-not-of-the-type-l2vpn_evpn)
- [Find all entries where network instance name is of the type workload-mgmt](./queries/MNFDeviceUpdates.md#find-all-entries-where-network-instance-name-is-of-the-type-workload-mgmt)

## [MNFSystemSessionHistoryUpdates](./queries/MNFSystemSessionHistoryUpdates.md)

- [Find all entries where session update user is admin](./queries/MNFSystemSessionHistoryUpdates.md#find-all-entries-where-session-update-user-is-admin)

## [MNFSystemStateMessageUpdates](./queries/MNFSystemStateMessageUpdates.md)

- [Find all errors from Syslog](./queries/MNFSystemStateMessageUpdates.md#find-all-errors-from-syslog)

## [MicrosoftDataShareReceivedSnapshotLog](./queries/MicrosoftDataShareReceivedSnapshotLog.md)

- [List received snapshots by duration](./queries/MicrosoftDataShareReceivedSnapshotLog.md#list-received-snapshots-by-duration)
- [Count failed received snapshots](./queries/MicrosoftDataShareReceivedSnapshotLog.md#count-failed-received-snapshots)
- [Frequent errors in received snapshots](./queries/MicrosoftDataShareReceivedSnapshotLog.md#frequent-errors-in-received-snapshots)
- [Chart of daily received snapshots](./queries/MicrosoftDataShareReceivedSnapshotLog.md#chart-of-daily-received-snapshots)

## [MicrosoftDataShareSentSnapshotLog](./queries/MicrosoftDataShareSentSnapshotLog.md)

- [List sent snapshots by duration](./queries/MicrosoftDataShareSentSnapshotLog.md#list-sent-snapshots-by-duration)
- [Count failed sent snapshots](./queries/MicrosoftDataShareSentSnapshotLog.md#count-failed-sent-snapshots)
- [Frequent errors in sent snapshots](./queries/MicrosoftDataShareSentSnapshotLog.md#frequent-errors-in-sent-snapshots)
- [Chart of daily sent snapshots](./queries/MicrosoftDataShareSentSnapshotLog.md#chart-of-daily-sent-snapshots)

## [MicrosoftGraphActivityLogs](./queries/MicrosoftGraphActivityLogs.md)

- [Frequent users endpoint callers](./queries/MicrosoftGraphActivityLogs.md#frequent-users-endpoint-callers)
- [Failed groups endpoint requests](./queries/MicrosoftGraphActivityLogs.md#failed-groups-endpoint-requests)

## [MicrosoftPurviewInformationProtection](./queries/MicrosoftPurviewInformationProtection.md)

- [Microsoft Purview Information Protection events](./queries/MicrosoftPurviewInformationProtection.md#microsoft-purview-information-protection-events)

## [NGXOperationLogs](./queries/NGXOperationLogs.md)

- [Show NGINXaaS access logs](./queries/NGXOperationLogs.md#show-nginxaas-access-logs)
- [Show NGINXaaS error logs](./queries/NGXOperationLogs.md#show-nginxaas-error-logs)

## [NGXSecurityLogs](./queries/NGXSecurityLogs.md)

- [Show NGINXaaS security logs](./queries/NGXSecurityLogs.md#show-nginxaas-security-logs)

## [NWConnectionMonitorPathResult](./queries/NWConnectionMonitorPathResult.md)

- [Path diagnostics](./queries/NWConnectionMonitorPathResult.md#path-diagnostics)

## [NWConnectionMonitorTestResult](./queries/NWConnectionMonitorTestResult.md)

- [Failed tests](./queries/NWConnectionMonitorTestResult.md#failed-tests)
- [Tests performance](./queries/NWConnectionMonitorTestResult.md#tests-performance)

## [NetworkSessions](./queries/NetworkSessions.md)

- [Get traffic to non standard ports](./queries/NetworkSessions.md#get-traffic-to-non-standard-ports)
- [High volume traffic to uncommon domains](./queries/NetworkSessions.md#high-volume-traffic-to-uncommon-domains)

## [OEPAirFlowTask](./queries/OEPAirFlowTask.md)

- [DAG type vs DAG runs summary statitics](./queries/OEPAirFlowTask.md#dag-type-vs-dag-runs-summary-statitics)
- [Correlation IDs of all DAG runs](./queries/OEPAirFlowTask.md#correlation-ids-of-all-dag-runs)
- [Logs of a DAG run](./queries/OEPAirFlowTask.md#logs-of-a-dag-run)
- [Error logs of a DAG run](./queries/OEPAirFlowTask.md#error-logs-of-a-dag-run)

## [OLPSupplyChainEntityOperations](./queries/OLPSupplyChainEntityOperations.md)

- [Count of successful warehouse delete requests](./queries/OLPSupplyChainEntityOperations.md#count-of-successful-warehouse-delete-requests)

## [OfficeActivity](./queries/OfficeActivity.md)

- [All Office Activity](./queries/OfficeActivity.md#all-office-activity)
- [Users accessing files](./queries/OfficeActivity.md#users-accessing-files)
- [File upload operation](./queries/OfficeActivity.md#file-upload-operation)
- [Office activity for user](./queries/OfficeActivity.md#office-activity-for-user)
- [Creation of Forward rule](./queries/OfficeActivity.md#creation-of-forward-rule)
- [Suspicious file name](./queries/OfficeActivity.md#suspicious-file-name)

## [Perf](./queries/Perf.md)

- [Non-RDMA activity](./queries/Perf.md#non-rdma-activity)
- [RDMA activity](./queries/Perf.md#rdma-activity)
- [What data is being collected?](./queries/Perf.md#what-data-is-being-collected)
- [Memory and CPU usage](./queries/Perf.md#memory-and-cpu-usage)
- [CPU usage trends over the last day](./queries/Perf.md#cpu-usage-trends-over-the-last-day)
- [Top 10 computers with the highest disk space](./queries/Perf.md#top-10-computers-with-the-highest-disk-space)
- [What data is being collected?](./queries/Perf.md#what-data-is-being-collected)
- [Virtual Machine available memory](./queries/Perf.md#virtual-machine-available-memory)
- [Chart CPU usage trends](./queries/Perf.md#chart-cpu-usage-trends)
- [Virtual Machine free disk space](./queries/Perf.md#virtual-machine-free-disk-space)
- [Top 10 Virtual Machines by CPU utilization](./queries/Perf.md#top-10-virtual-machines-by-cpu-utilization)
- [Bottom 10 Free disk space %](./queries/Perf.md#bottom-10-free-disk-space-)
- [Container CPU](./queries/Perf.md#container-cpu)
- [Container memory](./queries/Perf.md#container-memory)
- [Instances Avg CPU usage growth from last week](./queries/Perf.md#instances-avg-cpu-usage-growth-from-last-week)
- [Find In Perf](./queries/Perf.md#find-in-perf)

## [PowerAppsActivity](./queries/PowerAppsActivity.md)

- [Power Apps events filtered activity type](./queries/PowerAppsActivity.md#power-apps-events-filtered-activity-type)

## [PowerAutomateActivity](./queries/PowerAutomateActivity.md)

- [Power Automate events filtered by activity type](./queries/PowerAutomateActivity.md#power-automate-events-filtered-by-activity-type)

## [PowerBIActivity](./queries/PowerBIActivity.md)

- [PowerBI events filtered by organization ID](./queries/PowerBIActivity.md#powerbi-events-filtered-by-organization-id)

## [PowerPlatformAdminActivity](./queries/PowerPlatformAdminActivity.md)

- [Power Platform administration events](./queries/PowerPlatformAdminActivity.md#power-platform-administration-events)

## [PowerPlatformConnectorActivity](./queries/PowerPlatformConnectorActivity.md)

- [Power Platform Connector events filtered by by activity type](./queries/PowerPlatformConnectorActivity.md#power-platform-connector-events-filtered-by-by-activity-type)

## [PowerPlatformDlpActivity](./queries/PowerPlatformDlpActivity.md)

- [Power Platform DLP events filtered by by activity type](./queries/PowerPlatformDlpActivity.md#power-platform-dlp-events-filtered-by-by-activity-type)

## [ProjectActivity](./queries/ProjectActivity.md)

- [MS Project events filtered by organization ID](./queries/ProjectActivity.md#ms-project-events-filtered-by-organization-id)

## [ProtectionStatus](./queries/ProtectionStatus.md)

- [Signatures out of date](./queries/ProtectionStatus.md#signatures-out-of-date)
- [Protection Status updates](./queries/ProtectionStatus.md#protection-status-updates)
- [Malware detection](./queries/ProtectionStatus.md#malware-detection)

## [PurviewSecurityLogs](./queries/PurviewSecurityLogs.md)

- [Audit collection delete events](./queries/PurviewSecurityLogs.md#audit-collection-delete-events)

## [REDConnectionEvents](./queries/REDConnectionEvents.md)

- [Unique authenticated Redis client IP addresses](./queries/REDConnectionEvents.md#unique-authenticated-redis-client-ip-addresses)
- [Redis client authentication requests per hour](./queries/REDConnectionEvents.md#redis-client-authentication-requests-per-hour)
- [Redis client connections per hour](./queries/REDConnectionEvents.md#redis-client-connections-per-hour)
- [Redis client disconnections per hour](./queries/REDConnectionEvents.md#redis-client-disconnections-per-hour)
- [Unsuccessful authentication attempts on Redis cache](./queries/REDConnectionEvents.md#unsuccessful-authentication-attempts-on-redis-cache)

## [ResourceManagementPublicAccessLogs](./queries/ResourceManagementPublicAccessLogs.md)

- [Group number of requests based on the IP address](./queries/ResourceManagementPublicAccessLogs.md#group-number-of-requests-based-on-the-ip-address)
- [Number of opertions triggered](./queries/ResourceManagementPublicAccessLogs.md#number-of-opertions-triggered)
- [Calls based on the target URI](./queries/ResourceManagementPublicAccessLogs.md#calls-based-on-the-target-uri)
- [Calls based on operation name](./queries/ResourceManagementPublicAccessLogs.md#calls-based-on-operation-name)
- [Calls based on user](./queries/ResourceManagementPublicAccessLogs.md#calls-based-on-user)

## [SQLAssessmentRecommendation](./queries/SQLAssessmentRecommendation.md)

- [SQL Recommendations by Focus Area](./queries/SQLAssessmentRecommendation.md#sql-recommendations-by-focus-area)
- [SQL Recommendations by Computer](./queries/SQLAssessmentRecommendation.md#sql-recommendations-by-computer)
- [SQL Recommendations by Instance](./queries/SQLAssessmentRecommendation.md#sql-recommendations-by-instance)
- [SQL Recommendations by Database](./queries/SQLAssessmentRecommendation.md#sql-recommendations-by-database)
- [SQL Recommendations by AffectedObjectType](./queries/SQLAssessmentRecommendation.md#sql-recommendations-by-affectedobjecttype)
- [How many times did each unique SQL Recommendation trigger?](./queries/SQLAssessmentRecommendation.md#how-many-times-did-each-unique-sql-recommendation-trigger)
- [High priority SQL Assessment recommendations](./queries/SQLAssessmentRecommendation.md#high-priority-sql-assessment-recommendations)

## [SecurityAttackPathData](./queries/SecurityAttackPathData.md)

- [All attack paths by specific risk level](./queries/SecurityAttackPathData.md#all-attack-paths-by-specific-risk-level)

## [SecurityEvent](./queries/SecurityEvent.md)

- [Security Events most common event IDs](./queries/SecurityEvent.md#security-events-most-common-event-ids)
- [Members added to security groups](./queries/SecurityEvent.md#members-added-to-security-groups)
- [Uses of clear text password](./queries/SecurityEvent.md#uses-of-clear-text-password)
- [Windows failed logins](./queries/SecurityEvent.md#windows-failed-logins)
- [All Security Activities](./queries/SecurityEvent.md#all-security-activities)
- [Security Activities on the Device](./queries/SecurityEvent.md#security-activities-on-the-device)
- [Security Activities for Admin](./queries/SecurityEvent.md#security-activities-for-admin)
- [Logon Activity by Device](./queries/SecurityEvent.md#logon-activity-by-device)
- [Devices With More Than 10 Logons](./queries/SecurityEvent.md#devices-with-more-than-10-logons)
- [Accounts Terminated Antimalware](./queries/SecurityEvent.md#accounts-terminated-antimalware)
- [Devices with Antimalware Terminated](./queries/SecurityEvent.md#devices-with-antimalware-terminated)
- [Devices Where Hash Was Executed](./queries/SecurityEvent.md#devices-where-hash-was-executed)
- [Process Names Executed](./queries/SecurityEvent.md#process-names-executed)
- [Devices With Security Log Cleared](./queries/SecurityEvent.md#devices-with-security-log-cleared)
- [Logon Activity by Account](./queries/SecurityEvent.md#logon-activity-by-account)
- [Accounts With Less Than 5 Times Logons](./queries/SecurityEvent.md#accounts-with-less-than-5-times-logons)
- [Remoted Logged Accounts on Devices](./queries/SecurityEvent.md#remoted-logged-accounts-on-devices)
- [Computers With Guest Account Logons](./queries/SecurityEvent.md#computers-with-guest-account-logons)
- [Members Added to Security Enabled Groups](./queries/SecurityEvent.md#members-added-to-security-enabled-groups)
- [Domain Security Policy Changes](./queries/SecurityEvent.md#domain-security-policy-changes)
- [System Audit Policy Changes](./queries/SecurityEvent.md#system-audit-policy-changes)
- [Suspicious Executables](./queries/SecurityEvent.md#suspicious-executables)
- [Logons With Clear Text Password](./queries/SecurityEvent.md#logons-with-clear-text-password)
- [Computers With Cleaned Event Logs](./queries/SecurityEvent.md#computers-with-cleaned-event-logs)
- [Accounts Failed to Logon](./queries/SecurityEvent.md#accounts-failed-to-logon)
- [Locked Accounts](./queries/SecurityEvent.md#locked-accounts)
- [Change or Reset Passwords Attempts](./queries/SecurityEvent.md#change-or-reset-passwords-attempts)
- [Groups Created or Modified](./queries/SecurityEvent.md#groups-created-or-modified)
- [Remote Procedure Call Attempts](./queries/SecurityEvent.md#remote-procedure-call-attempts)
- [User Accounts Changed](./queries/SecurityEvent.md#user-accounts-changed)

## [SentinelAudit](./queries/SentinelAudit.md)

- [Failures updating Office365-Sharepoint related Sentinel resources](./queries/SentinelAudit.md#failures-updating-office365-sharepoint-related-sentinel-resources)

## [SignalRServiceDiagnosticLogs](./queries/SignalRServiceDiagnosticLogs.md)

- [Client connection IDs](./queries/SignalRServiceDiagnosticLogs.md#client-connection-ids)
- [Connection close reasons](./queries/SignalRServiceDiagnosticLogs.md#connection-close-reasons)
- [IP addresses](./queries/SignalRServiceDiagnosticLogs.md#ip-addresses)
- [Logs relating to specific connection ID](./queries/SignalRServiceDiagnosticLogs.md#logs-relating-to-specific-connection-id)
- [Logs relating to specific message tracing ID](./queries/SignalRServiceDiagnosticLogs.md#logs-relating-to-specific-message-tracing-id)
- [Logs relating to specific user ID](./queries/SignalRServiceDiagnosticLogs.md#logs-relating-to-specific-user-id)
- [Logs with warning or exceptions](./queries/SignalRServiceDiagnosticLogs.md#logs-with-warning-or-exceptions)
- [Server connection IDs](./queries/SignalRServiceDiagnosticLogs.md#server-connection-ids)
- [Time chart of operation names](./queries/SignalRServiceDiagnosticLogs.md#time-chart-of-operation-names)
- [Transport types](./queries/SignalRServiceDiagnosticLogs.md#transport-types)
- [User IDs](./queries/SignalRServiceDiagnosticLogs.md#user-ids)

## [SigninLogs](./queries/SigninLogs.md)

- [All SiginLogs events](./queries/SigninLogs.md#all-siginlogs-events)
- [Resources accessed by user](./queries/SigninLogs.md#resources-accessed-by-user)
- [User count per Resource](./queries/SigninLogs.md#user-count-per-resource)
- [User count per Application](./queries/SigninLogs.md#user-count-per-application)
- [Failed Signin reasons](./queries/SigninLogs.md#failed-signin-reasons)
- [Failed MFA challenge](./queries/SigninLogs.md#failed-mfa-challenge)
- [Failed App tried silent signin](./queries/SigninLogs.md#failed-app-tried-silent-signin)
- [Failed login Count](./queries/SigninLogs.md#failed-login-count)
- [Signin Locations](./queries/SigninLogs.md#signin-locations)
- [Logins To Resource](./queries/SigninLogs.md#logins-to-resource)

## [StorageBlobLogs](./queries/StorageBlobLogs.md)

- [Most common errors](./queries/StorageBlobLogs.md#most-common-errors)
- [Operations causing most errors](./queries/StorageBlobLogs.md#operations-causing-most-errors)
- [Operations with the highest latency](./queries/StorageBlobLogs.md#operations-with-the-highest-latency)
- [Operations causing server side throttling](./queries/StorageBlobLogs.md#operations-causing-server-side-throttling)
- [Show anonymous requests](./queries/StorageBlobLogs.md#show-anonymous-requests)
- [Frequent operations chart](./queries/StorageBlobLogs.md#frequent-operations-chart)

## [StorageCacheOperationEvents](./queries/StorageCacheOperationEvents.md)

- [Failed operation](./queries/StorageCacheOperationEvents.md#failed-operation)
- [Failed priming job](./queries/StorageCacheOperationEvents.md#failed-priming-job)
- [Completed long-running asynchronous operations](./queries/StorageCacheOperationEvents.md#completed-long-running-asynchronous-operations)

## [StorageCacheUpgradeEvents](./queries/StorageCacheUpgradeEvents.md)

- [Upgrade events](./queries/StorageCacheUpgradeEvents.md#upgrade-events)

## [StorageCacheWarningEvents](./queries/StorageCacheWarningEvents.md)

- [Active warning events](./queries/StorageCacheWarningEvents.md#active-warning-events)

## [StorageMalwareScanningResults](./queries/StorageMalwareScanningResults.md)

- [Malicious blobs per storage account](./queries/StorageMalwareScanningResults.md#malicious-blobs-per-storage-account)
- [Unsuccessful Scans](./queries/StorageMalwareScanningResults.md#unsuccessful-scans)

## [SucceededIngestion](./queries/SucceededIngestion.md)

- [Succeeded ingestions](./queries/SucceededIngestion.md#succeeded-ingestions)
- [Succeeded ingestions timechart](./queries/SucceededIngestion.md#succeeded-ingestions-timechart)

## [SynapseLinkEvent](./queries/SynapseLinkEvent.md)

- [Synapse Link table fail events](./queries/SynapseLinkEvent.md#synapse-link-table-fail-events)

## [Syslog](./queries/Syslog.md)

- [Find Linux kernel events](./queries/Syslog.md#find-linux-kernel-events)
- [All Syslog](./queries/Syslog.md#all-syslog)
- [All Syslog with errors](./queries/Syslog.md#all-syslog-with-errors)
- [All Syslog by facility](./queries/Syslog.md#all-syslog-by-facility)
- [All Syslog by process name](./queries/Syslog.md#all-syslog-by-process-name)
- [Users Added to Linux Group by Computer](./queries/Syslog.md#users-added-to-linux-group-by-computer)
- [New Linux Group Created by Computer](./queries/Syslog.md#new-linux-group-created-by-computer)
- [Failed Linux User Password Change](./queries/Syslog.md#failed-linux-user-password-change)
- [Computers With Failed Ssh Logons](./queries/Syslog.md#computers-with-failed-ssh-logons)
- [Computers With Failed Su Logons](./queries/Syslog.md#computers-with-failed-su-logons)
- [Computers With Failed Sudo Logons](./queries/Syslog.md#computers-with-failed-sudo-logons)

## [TSIIngress](./queries/TSIIngress.md)

- [Show event source connection errors](./queries/TSIIngress.md#show-event-source-connection-errors)
- [10 latest Ingress logs](./queries/TSIIngress.md#10-latest-ingress-logs)
- [Show deserialization errors](./queries/TSIIngress.md#show-deserialization-errors)

## [UCDOAggregatedStatus](./queries/UCDOAggregatedStatus.md)

- [Content distribution in Gigabytes](./queries/UCDOAggregatedStatus.md#content-distribution-in-gigabytes)

## [UCDOStatus](./queries/UCDOStatus.md)

- [Device configuration](./queries/UCDOStatus.md#device-configuration)

## [Update](./queries/Update.md)

- [Missing security or critical updates](./queries/Update.md#missing-security-or-critical-updates)
- [Updates available for Windows machines](./queries/Update.md#updates-available-for-windows-machines)
- [Updates available for Linux machines](./queries/Update.md#updates-available-for-linux-machines)
- [Missing updates summary](./queries/Update.md#missing-updates-summary)
- [Missing updates list](./queries/Update.md#missing-updates-list)
- [Computer with missing updates](./queries/Update.md#computer-with-missing-updates)
- [Missing required updates for server](./queries/Update.md#missing-required-updates-for-server)
- [Missing critical security updates](./queries/Update.md#missing-critical-security-updates)
- [Missing security or critical where update is manual](./queries/Update.md#missing-security-or-critical-where-update-is-manual)
- [Missing update rollups](./queries/Update.md#missing-update-rollups)
- [Distinct missing updates cross computers](./queries/Update.md#distinct-missing-updates-cross-computers)

## [UpdateRunProgress](./queries/UpdateRunProgress.md)

- [Patch installation failure for your machines](./queries/UpdateRunProgress.md#patch-installation-failure-for-your-machines)

## [UpdateSummary](./queries/UpdateSummary.md)

- [Summary of updates available across machines](./queries/UpdateSummary.md#summary-of-updates-available-across-machines)
- [Missing update specific product](./queries/UpdateSummary.md#missing-update-specific-product)
- [Automatic update configuration](./queries/UpdateSummary.md#automatic-update-configuration)
- [Automatic update configuration is disabled](./queries/UpdateSummary.md#automatic-update-configuration-is-disabled)

## [UrlClickEvents](./queries/UrlClickEvents.md)

- [Links where a user was allowed to proceed](./queries/UrlClickEvents.md#links-where-a-user-was-allowed-to-proceed)

## [Usage](./queries/Usage.md)

- [Usage by data types](./queries/Usage.md#usage-by-data-types)
- [Billable performance data](./queries/Usage.md#billable-performance-data)
- [Volume of solutions' data](./queries/Usage.md#volume-of-solutions-data)
- [Total workspace ingestion over the last 24 hours](./queries/Usage.md#total-workspace-ingestion-over-the-last-24-hours)
- [Container Insight solution billable data](./queries/Usage.md#container-insight-solution-billable-data)

## [VCoreMongoRequests](./queries/VCoreMongoRequests.md)

- [Mongo vCore requests P99 duration by operation](./queries/VCoreMongoRequests.md#mongo-vcore-requests-p99-duration-by-operation)
- [Mongo vCore requests binned by duration](./queries/VCoreMongoRequests.md#mongo-vcore-requests-binned-by-duration)
- [Failed Mongo vCore requests](./queries/VCoreMongoRequests.md#failed-mongo-vcore-requests)
- [Mongo vCore requests by user agent](./queries/VCoreMongoRequests.md#mongo-vcore-requests-by-user-agent)

## [VIAudit](./queries/VIAudit.md)

- [Video Indexer Audit by account id](./queries/VIAudit.md#video-indexer-audit-by-account-id)
- [Video Indexer Audit top 10 users by operations](./queries/VIAudit.md#video-indexer-audit-top-10-users-by-operations)
- [Video Indexer Audit parsed error message](./queries/VIAudit.md#video-indexer-audit-parsed-error-message)
- [Video Indexer Audit failed operations](./queries/VIAudit.md#video-indexer-audit-failed-operations)

## [VIIndexing](./queries/VIIndexing.md)

- [Failed Indexing operations](./queries/VIIndexing.md#failed-indexing-operations)
- [Top 10 users](./queries/VIIndexing.md#top-10-users)

## [W3CIISLog](./queries/W3CIISLog.md)

- [List IIS log entries](./queries/W3CIISLog.md#list-iis-log-entries)
- [Display breakdown respond codes](./queries/W3CIISLog.md#display-breakdown-respond-codes)
- [Maximum time taken for each page](./queries/W3CIISLog.md#maximum-time-taken-for-each-page)
- [Show 404 pages list](./queries/W3CIISLog.md#show-404-pages-list)
- [Average HTTP request time](./queries/W3CIISLog.md#average-http-request-time)
- [Servers with internal server error](./queries/W3CIISLog.md#servers-with-internal-server-error)
- [Count IIS log entries by HTTP request method](./queries/W3CIISLog.md#count-iis-log-entries-by-http-request-method)
- [Count IIS log entries by HTTP user agent](./queries/W3CIISLog.md#count-iis-log-entries-by-http-user-agent)
- [Count IIS log entries by client IP address](./queries/W3CIISLog.md#count-iis-log-entries-by-client-ip-address)
- [IIS log entries for client IP](./queries/W3CIISLog.md#iis-log-entries-for-client-ip)
- [Count of IIS log entries by URL](./queries/W3CIISLog.md#count-of-iis-log-entries-by-url)
- [Count of IIS log entries by host](./queries/W3CIISLog.md#count-of-iis-log-entries-by-host)
- [Total bytes traffic by client IP](./queries/W3CIISLog.md#total-bytes-traffic-by-client-ip)
- [Bytes received by each IIS computer](./queries/W3CIISLog.md#bytes-received-by-each-iis-computer)
- [Bytes responded to clients by each IIS server IP](./queries/W3CIISLog.md#bytes-responded-to-clients-by-each-iis-server-ip)
- [Average HTTP request time by client IP](./queries/W3CIISLog.md#average-http-request-time-by-client-ip)

## [WVDAgentHealthStatus](./queries/WVDAgentHealthStatus.md)

- [Active sessions on SessionHost](./queries/WVDAgentHealthStatus.md#active-sessions-on-sessionhost)
- [HealthChecks of SessionHost](./queries/WVDAgentHealthStatus.md#healthchecks-of-sessionhost)

## [WVDCheckpoints](./queries/WVDCheckpoints.md)

- [Published remote resources by count of users](./queries/WVDCheckpoints.md#published-remote-resources-by-count-of-users)

## [WVDConnectionNetworkData](./queries/WVDConnectionNetworkData.md)

- [Average round-trip time over time](./queries/WVDConnectionNetworkData.md#average-round-trip-time-over-time)
- [Average BW across all connections](./queries/WVDConnectionNetworkData.md#average-bw-across-all-connections)
- [Top 10 users with the highest round-trip time](./queries/WVDConnectionNetworkData.md#top-10-users-with-the-highest-round-trip-time)
- [Top 10 users with lowest bandwidth](./queries/WVDConnectionNetworkData.md#top-10-users-with-lowest-bandwidth)
- [Summary of Round-trip time and bandwidth](./queries/WVDConnectionNetworkData.md#summary-of-round-trip-time-and-bandwidth)

## [WVDConnections](./queries/WVDConnections.md)

- [Connection Errors](./queries/WVDConnections.md#connection-errors)
- [Session duration](./queries/WVDConnections.md#session-duration)
- [Top 10 users by average connection duration](./queries/WVDConnections.md#top-10-users-by-average-connection-duration)
- [Top 10 most active users](./queries/WVDConnections.md#top-10-most-active-users)
- [Average connection duration by hostpool](./queries/WVDConnections.md#average-connection-duration-by-hostpool)
- [Client-side operating system information by user count](./queries/WVDConnections.md#client-side-operating-system-information-by-user-count)
- [Azure Virtual Desktop client usage information](./queries/WVDConnections.md#azure-virtual-desktop-client-usage-information)
- [Average session logon time](./queries/WVDConnections.md#average-session-logon-time)

## [WVDErrors](./queries/WVDErrors.md)

- [Top 10 connection errors](./queries/WVDErrors.md#top-10-connection-errors)
- [Top 10 feed errors](./queries/WVDErrors.md#top-10-feed-errors)

## [WaaSDeploymentStatus](./queries/WaaSDeploymentStatus.md)

- [Update deployment failures](./queries/WaaSDeploymentStatus.md#update-deployment-failures)
- [Devices pending reboot to complete update](./queries/WaaSDeploymentStatus.md#devices-pending-reboot-to-complete-update)
- [Devices with a Safeguard Hold](./queries/WaaSDeploymentStatus.md#devices-with-a-safeguard-hold)
- [Target build distribution of devices with a safeguard hold](./queries/WaaSDeploymentStatus.md#target-build-distribution-of-devices-with-a-safeguard-hold)

## [WaaSUpdateStatus](./queries/WaaSUpdateStatus.md)

- [Distribution of device Servicing Branch](./queries/WaaSUpdateStatus.md#distribution-of-device-servicing-branch)
- [Distribution of device OS Edition](./queries/WaaSUpdateStatus.md#distribution-of-device-os-edition)
- [Feature Update Deferral Configurations](./queries/WaaSUpdateStatus.md#feature-update-deferral-configurations)
- [Feature Update Pause Configurations](./queries/WaaSUpdateStatus.md#feature-update-pause-configurations)
- [Quality Update Deferral Configurations](./queries/WaaSUpdateStatus.md#quality-update-deferral-configurations)
- [Quality Update Pause Configurations](./queries/WaaSUpdateStatus.md#quality-update-pause-configurations)

## [Watchlist](./queries/Watchlist.md)

- [Get Watchlist aliases](./queries/Watchlist.md#get-watchlist-aliases)
- [Lookup events using a Watchlist](./queries/Watchlist.md#lookup-events-using-a-watchlist)

## [WindowsEvent](./queries/WindowsEvent.md)

- [WindowsEvent Audit Policy Events](./queries/WindowsEvent.md#windowsevent-audit-policy-events)

## [WireData](./queries/WireData.md)

- [Agents that provide wire data](./queries/WireData.md#agents-that-provide-wire-data)
- [IP Addresses of the agents providing wire data](./queries/WireData.md#ip-addresses-of-the-agents-providing-wire-data)
- [All Outbound communications by Remote IP Address](./queries/WireData.md#all-outbound-communications-by-remote-ip-address)
- [Bytes sent by Application Protocol](./queries/WireData.md#bytes-sent-by-application-protocol)
- [Bytes received by Protocol Name](./queries/WireData.md#bytes-received-by-protocol-name)
- [Total bytes by IP version](./queries/WireData.md#total-bytes-by-ip-version)
- [Remote IP addresses that have communicated with agents on the subnet '10.0.0.0/8' (any direction)](./queries/WireData.md#remote-ip-addresses-that-have-communicated-with-agents-on-the-subnet-100008-any-direction)
- [Processes that initiated or received network traffic](./queries/WireData.md#processes-that-initiated-or-received-network-traffic)
- [Amount of Network Traffic by Process](./queries/WireData.md#amount-of-network-traffic-by-process)

## [WorkloadDiagnosticLogs](./queries/WorkloadDiagnosticLogs.md)

- [Workload Monitoring Insights data collection warnings or errors](./queries/WorkloadDiagnosticLogs.md#workload-monitoring-insights-data-collection-warnings-or-errors)

## Next steps

- [Analyze logs from Azure storage with Log Analytics](/azure/azure-monitor/essentials/resource-logs#send-to-log-analytics-workspace)
- [Learn more about resource logs](/azure/azure-monitor/essentials/platform-logs-overview)
- [Change resource log diagnostic settings using the Azure Monitor REST API](/rest/api/monitor/diagnosticsettings)
