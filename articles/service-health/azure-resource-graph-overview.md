---
title: Azure Resource Graph Overview
description: Learn about the Azure Resource Graph table properties.
ms.topic: concept-article
ms.date: 01/22/2026

---
# Azure Resource Graph tables overview

Azure Resource Graph (ARG) provides a way for you to query Azure resources across your subscriptions using Kusto Query Language (KQL). 
This article gives a detailed breakdown of the fields commonly found in ARG tables, especially the fields that are relevant to Azure Service Health and governance scenarios.

Use the Service Health table to query:
-  Service Health Event properties (microsoft.resourcehealth/events)
-  Service Health Impacted Resources properties (microsoft.resourcehealth/events/impactedresources)<br>

Use the Resource Health table to query:
-  Resource Health properties (microsoft.resourcehealth/availabilitystatuses and microsoft.resourcehealth/resourceannotations)<br>
For more information on the HealthResources table, see [VM availability information in Azure Resource Graph](/azure/virtual-machines/resource-graph-availability/).
 


| Query       |Tables                                       |Value type                                         | Information |
|-------------|---------------------------------------------|---------------------------------------------------|-------------|
| Service Health Event<br>Service Health Impacted Resources | ServiceHealthResources<br>ServiceHealthResources  | microsoft.resourcehealth/events<br>microsoft.resourcehealth/events/impactedresources                     | Service Health events such as outages, planned maintenance, or other incidents.<br>The specific Azure resources affected by those events.|
| Resource Health (only virtual machines)                   | HealthResources                                   | microsoft.resourcehealth/availabilitystatuses, microsoft.resourcehealth/resourceannotations  | VM health monitoring, diagnostics|


This table shows the core fields in the ARG table for the Service Health, Impacted Resources, and Resource Health queries that represent the metadata about Azure resources.

|Field Name      |Description                                                                 |
|----------------|----------------------------------------------------------------------------|
|id              | Full Azure resource ID (for example, /subscriptions/<`subscription-id`>/providers/Microsoft.ResourceHealth/events/<`tracking-id`>)|
|name            | Name of the resource                                                       |
|type            | Resource type (for example, Microsoft.Compute/virtualMachines)             |
|tenantId        | ID of tenant the resource belongs to                                       |
|location        | Azure region where the resource is deployed (default is Global)            |
|subscriptionId  | ID of the subscription the resource belongs to                             |
|resourceGroup   | Name of the resource group                                                 |
|tags            | Key-value pairs assigned to the resource                                   |
|properties      | JSON objects containing resource-specific properties                       |
|sku             | SKU details (tier, name) for applicable resources                          |
|kind            | Resource kind (used in App Services, for example, functionapp, or webapp)  |
|managedBy       | Indicates if another Azure service manages the resource                    |
|identity        | Identity configuration (for example, system-assigned or user-assigned)     |
|plan            | Marketplace plan details                                                   |
|zones           | Availability zones the resource is deployed in                             |
|extendedLocation| Extended location details (for example, custom locations)                  |


## Service Health

The **ServiceHealthResources** queries returns data about resources within your subscriptions that are affected by service health events.<br>

These notifications are a subclass of activity log events and can also be found in the [Azure activity log](/azure/azure-monitor/platform/activity-log). <br>

Depending on the event classification, **EventType** and **EventSubtype** service health notifications could be either informational or actionable.


### Service Health Event properties (microsoft.resourcehealth/events)


:::image type="content"source="./media/resource-graph-overview/service-health-properties.png"alt-text="Screenshot of the fields shown in the Service Health properties column."Lightbox="./media/resource-graph-overview/service-health-properties.png":::

The values in the `properties` field are used for querying Azure Service Health events.

There are some common properties that exist across all the different event types, but everything under `properties` should be considered dynamic based on the event type.<br>

These fields are used together to track, filter, and analyze service health events across your Azure environment. <br>For example, you can query for all `Critical ServiceIssue` events in a specific location that are still `Active`.

This table lists all the properties you can use in your Service Health and Impacted Resources queries.


|Property                         |Description                                                                   |
|---------------------------------|------------------------------------------------------------------------------|
|`EventType`                      | High-level classification: ServiceIssue, PlannedMaintenance, HealthAdvisory, Billing, SecurityAdvisory, EmergingIssues, and Post Incident Review (PIR)       |
|`EventSubType`                   | Specific subtype: Retirement, TaxChanges, PriceChanges, MeterIDChanges, ForeignExchangeRateChange, UnauthorizedPartyAbuse, Underbilling, and Overbilling        |
|`Status`                         | Current status of the event: Active or Resolved                              |
|`EventLevel`                     | Severity: Informational, Warning, Critical, Error                            |
|`Level`                          | Often mirrors EventLevel and is used for UI rendering                        |
|`EventSource`                    | Indicates the source system that generated the event as ServiceHealthResources or HealthResources |
|`TrackingId`                     | Unique identifier for the event                                              |
|`Title`                          | Title of the event                                                           |
|`Summary`                        | Description of the event <br>*At this time to get full text of the description, you can use either Service Health API (description property) or the Activity Log (communication property)*.         |
|`Priority`                       | Priority level assigned to the event                                         |
|`ImpactStartTime`                | When the event causing the impact began                                      |
|`ImpactMitigationTime`           | When mitigation is expected or completed                                     |
|`Impact`                         | Description of the impact on services                                        |
|`Region`                         | Which regions and services are impacted |
|`RecommendedActions`             | Suggested actions for users and/or admins                                    |     
|`ExternalIncidentId`             | Incident ID used externally (for example in ServiceNow)                      |
|`PlatformInitiated`              | Indicates if the Azure platform triggers the event (for example, an automated mitigation or system-triggered maintenance)|     
|`SubscriptionId`                 | The unique identifier of the Azure subscription affected by the event        |
|`LastUpdateTime`                 | Timestamp of the most recent update to the event                             |     
|`CurrencyType`                   | The currency used in billing-related events (for example, USD, EUR)          |
|`impactType`                     | The nature of the impact (for example, SubscriptionList, ServicesForSubTenants)|     
|`BillingId`                      | Identifier used to associate the event with a billing account or transaction |
|`EventTags`                      | Metadata tags used to categorize or filter events (for example, Security, Maintenance, Outage)  |     
|`duration`                       | Descriptive label or title for the event                                     |



>[!NOTE]
>The "properties" structure is dynamic and varies by EventType and EventSubType. Not all fields are present in every event.<br>
>Fields like `isEventSensitive` might be empty or omitted unless the event is security-related.<br> 
>The `EventSubType` is often empty unless the event is a billing or retirement advisory. <br>For more information, see [Service Health event tags](service-health-event-tags.md) and [Filter notifications using Event Level](/azure/service-health/metadata-filter).

Access control systems ensure that only authorized individuals with a valid need can view sensitive information. For more information, see [View and access Security advisories](security-advisories-elevated-access.md).

**How These Fields Work Together**

- **Governance & Monitoring**: Combine `EventType`, `Severity`, and `Status` that monitors ongoing issues and assess their impact.
- **Filtering & Alerting**: Use `SubscriptionId`, and `Impact` that filters events relevant to specific teams or workloads.
- **Historical Analysis**: Use `ImpactStartTime` and `ImpactMitigationTime` to understand event timelines and Service Level Agreement (SLA) implications.
- **REST API Integration**: These fields are exposed through the [Azure Service Health REST API](/events/list-by-subscription-id), allowing programmatic access and automation.
- **Filter and Scope Events**: `SubscriptionId`, `Impact`, `TrackingId`, and `PlatformInitiated` help narrow down which resources are affected and how.
- **Track and Analyze**: `LastUpdateTime`, `Header`, and `EventTags` support monitoring and historical analysis.
- **Support Financial and Compliance Workflows**: `BillingId` and `CurrencyType` are essential for billing-related events and audits.


## Impacted Resources
:::image type="content"source="./media/resource-graph-overview/impacted-resources-properties.png"alt-text="Screenshot of the fields shown in the Impacted Resources properties column."Lightbox="./media/resource-graph-overview/impacted-resources-properties.png":::

Set the `type` column in the ServiceHealthResources table to **microsoft.resourcehealth/events/impactedresources** so it opens the query to search for information about the impacted resources by Service Health events such as outages, planned maintenance, or security advisories.


### Impacted Resources properties

|Field name           |Description |
|---------------------|---------|
|`resourceName`       | Name of the impacted resource         |
|`resourceGroupName`  | Name of Resource Group        |
|`targetResourceType` | Type of the impacted resource         |
|`targetResourceId`   | Full resource ID |
|`targetRegion`       | Region of the impacted resource        |
|`systemData`         | Metadata about who created or modified the entry       |
|`maintenanceStartTime`  |When the event causing the impact began  |
|`maintenanceEndTime`  |When the event causing the impact ended  |
|`targetResourceType`  | Type of the impacted resource (for example, Microsoft.Compute/virtualMachines) |
|`targetResourceId`  | Full resource ID of the impacted resource  |
|`resourceGroup`  |Name of the Resource Group  |
|`targetRegion`  |Region of the impacted resource  |
|`staus`  |Current status of the event  |
|`info`  |  |


## Resource Health

There are two types of tables in the **HealthResources** Azure Resource Graph (ARG) that provide detailed information about the health status of your Azure resources, especially virtual machines.

**microsoft.resourcehealth/availabilitystatuses**<br>
This table provides the latest availability status of Azure resources—primarily virtual machines (VMs)—based on health checks performed by the Azure platform.

You can use this query to:
- **Track VM Health across your environment**: Get a consolidated view of the health status of virtual machines across all subscriptions or resource groups.
- **Diagnose issues quickly**: Identify which VMs are marked as Unavailable or Degraded, and investigate the underlying causes.
- **Audit downtime sources**: Determine whether service interruptions result from platform-initiated events (like maintenance) or customer actions.
- **Create operational dashboards**: Visualize real-time health data to monitor service-level agreements (SLAs) and maintain operational awareness.
- **Add context with annotations**: Combine this table with `resourceannotations` to understand the reasons behind availability changes, such as restarts or outages.


**microsoft.resourcehealth/resourceannotations** <br>
This table provides detailed annotations about changes in the availability of Azure resources—especially virtual machines (VMs). It adds context such as failure attribution, downtime analysis, and impact metadata. These fields help you understand why a VM's availability changed, whether it was due to platform maintenance, customer actions, or unexpected failures.

You can use this query to:

- **Investigate VM downtime**: Understand the root cause of availability changes.
- **Correlate health events**: Join with `availabilitystatuses` to get both status and context.
- **Audit platform actions**: Identify whether Azure initiated a restart or shutdown.
- **Improve SLA tracking**: Attribute failures to specific causes for business impact analysis.
- **Build dashboards**: Visualize health annotations alongside other resource metadata.

For more information about these tables, see [VM availability resource graph](/azure/virtual-machines/resource-graph-availability).

### HealthResources properties

:::image type="content"source="./media/resource-graph-overview/resource-health-properties.png"alt-text="Screenshot of the fields shown in the Resource Health properties column."Lightbox="./media/resource-graph-overview/resource-health-properties.png":::

These property fields provide the actual health information:

|Property                    |Description                                                                           |
|-------------------------------|--------------------------------------------------------------------------------------|
|`availabilityState`            | Current health status: Available, Unavailable, or Degraded                           |
|`previousAvailabilityState`    | Previous health status before the current state                                      |
|`reasonType`                   | Reason for the current health state (for instance, PlatformInitiated, UserInitiated) |
|`reasonChronicityType`         | Indicates whether the issue is Persistent or Transient                               |
|`annotationName`               | Descriptive label for the health event (for example, VirtualMachineRestarted)        |
|`title`                        | Title of the Health event                                                            |
|`summary`                      | Summary of the health event                                                          |
|`impactStartTime`              | Timestamp when the event began                                                       |
|`impactMitigationTime`         | Timestamp when mitigation is expected or completed                                   |
|`recommendedActions`           | Suggested actions for the user                                                       |

**How These Fields Work Together**

- **Monitoring & Alerting**: `availabilityState`, `reasonType`, and `impactStartTime` help identify and respond to outages or degradations.
- **Root Cause Analysis**: `reasonChronicityType`, `annotationName`, and `summary` provide context for troubleshooting.
- **Governance & Reporting**: `location`, `subscriptionId`, and `resourceGroup` allow filtering and aggregation across environments.
- **Automation**: `recommendedActions` can be used to trigger automated remediation workflows.

## Troubleshooting

**Question**<br>
Why are the `maintenanceStartTime`, `maintenanceEndTime`, and `info` showing as null in my ARG query results?<br>
**Answer**<br>
These fields can appear null in ARG queries for microsoft.resourcehealth events due to several factors. Understanding the fields can help you interpret the data more accurately.
-  **Event type dependency**:<br>
Only Planned Maintenance events include maintenance timing details. Other event types like Service Issue or Security Advisory don't use those fields, so they're null.
<!--- **Incomplete ingestion data**: Sometimes the upstream ingestion pipeline from Azure Change Management or partners might not populate the maintenance timing fields, especially during rapid incident responses or edge cases.-->
- **Event lifecycle and access control**:<br>
    - Newly created or early-stage events might not have the full details to populate the fields or confirmed maintenance windows. 
    - Some sensitive events require elevated permissions to view complete data. Without the right access, the fields appear blank.
- **Event history and recommendations**:
    - Filter for PlannedMaintenance events.
    - Confirm your role and access permissions.
    - Check the event status.
    - Report any consistent data gaps through the appropriate support channels.

If the `maintenanceStartTime`, `maintenanceEndTime`, or `info` are showing null in the ARG query results, you should check the Planned maintenance pane.
:::image type="content"source="./media/resource-graph-overview/resource-health-null-fields.png"alt-text="Screenshot of the Planned maintenance pane."Lightbox="./media/resource-graph-overview/resource-health-null-fields.png":::


For more information about queries, see:<br> 
- [Service Health sample queries](resource-graph-samples.md)
- [Resource health sample queries](resource-graph-health-samples.md)
- [Impacted Resources sample queries](resource-graph-impacted-samples.md)
- [Resource types and health checks](resource-health-checks-resource-types.md)