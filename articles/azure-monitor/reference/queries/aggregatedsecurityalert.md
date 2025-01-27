---
title: Example log table queries for AggregatedSecurityAlert
description:  Example queries for AggregatedSecurityAlert log table
ms.topic: reference
ms.service: azure-monitor
ms.author: edbaynash
author: EdB-MSFT
ms.date: 11/04/2024

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 

---

# Queries for the AggregatedSecurityAlert table

For information on using these queries in the Azure portal, see [Log Analytics tutorial](/azure/azure-monitor/logs/log-analytics-tutorial). For the REST API, see [Query](/rest/api/loganalytics/query).


### Group Aggregated Security Alerts by Sector  


Aggregated Security alerts grouped by originated sector.  

```query
source
| project
    TimeGenerated = todatetime(TimeGenerated),
    DisplayName = AlertDisplayName,
    AlertName = AlertDisplayName,
    AlertSeverity = Severity,
    Description,
    ProviderName,
    VendorName,
    VendorOriginalId = ProviderAlertId,
    SystemAlertId,
    AlertType,
    ConfidenceLevel,
    ConfidenceScore = tofloat(ConfidenceScore),
    StartTime = todatetime(StartTimeUtc),
    EndTime = todatetime(EndTimeUtc),
    ProcessingEndTime = todatetime(ProcessingEndTime),
    RemediationSteps = tostring(todynamic(RemediationSteps)),
    ExtendedProperties = tostring(todynamic(ExtendedProperties )),
    Entities = tostring(todynamic(Entities)),
    SourceSystem = "Detection",
    ExtendedLinks = tostring(todynamic(ExtendedLinks)),
    ProductName,
    ProductComponentName,
    Status,
    CompromisedEntity,
    Tactics = Intent,
    Techniques = tostring(todynamic(Techniques)),
    SubTechniques = tostring(todynamic(SubTechniques)),
    PartnerId,
    PartnerDisplayName,
    PartnerMetadata = tostring(todynamic(PartnerMetadata)),
    AggregatedSecurityAlertRuleIds,
    AggregatedSecurityAlertRuleNames

```

