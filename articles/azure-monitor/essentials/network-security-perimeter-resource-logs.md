---
title: 'Diagnostic logging for Azure Network Security Perimeter'
description: Learn the options for storing diagnostic logs for Network Security Perimeter and how to enable logging through the Azure portal.
author: mbender-ms
ms.author: mbender
ms.service: private-link
ms.topic: conceptual
ms.date: 04/24/2024
#CustomerIntent: As a network administrator, I want to enable diagnostic logging for Azure Network Security Perimeter, so that I can monitor and analyze the network traffic to and from my resources.
---

# Diagnostic logging for Azure Network Security Perimeter

In this article, you learn about activity and access logs for network security perimeter. You learn how to enable different categories of access logs and send them to different destinations. Finally, you'll learn how to retrieve access logs from a Log Analytics workspace.

## Activity log

Azure generates the activity log for all resources by default. It provides a record of basic operations such as creation and configuration changes made the network security perimeter. The logs are preserved for 90 days in the Azure event logs store. Learn more about these logs by reading the [View events and activity log](/azure/azure-monitor/essentials/activity-log) article.

## Access logs
Network security perimeter access logs categories are based on the results of access rules evaluation. They're implemented as [resource logs in Azure Monitor](../essentials/resource-logs.md). Use the guidance at [Diagnostic settings in Azure Monitor](../essentials/diagnostic-settings.md) for details on creating a diagnostic setting to collect resource logs. You can send them to a Log Analytics workspace, storage account, or event hub.

:::image type="content" source="media/network-security-perimeter-concepts/network-security-perimeter.png" alt-text="Screenshot of diagnostic settings options for network security perimeter." lightbox="media/network-security-perimeter-concepts/network-security-perimeter.png":::


Diagnostic settings specify different log categories you want to collect. The following table lists each of the access log categories including the modes in which they're applicable. The **Name** is used for the category in the Azure portal, while you use the **Log Category** when you create the diagnostic setting using other methods.

| Name | Log category | Description | Applicable to Modes |
| --- | --- | --- | --- |
| Public inbound access allowed by NSP access rules. | `perimeterPublicInboundPerimeterRulesAllowed` | Inbound access is allowed based on network security perimeter access rules | Learning/Enforced |
| Public inbound access denied by NSP access rules. | `perimeterPublicInboundPerimeterRulesDenied` | Public inbound access denied by network security perimeter | Enforced |
| Public outbound access allowed by NSP access rules. | `perimeterPublicOutboundPerimeterRulesAllowed` | Outbound access is allowed based on network security perimeter access rules | Learning/Enforced |
| Public outbound access denied by NSP access rules. | `perimeterPublicOutboundPerimeterRulesDenied` | Public outbound access denied by network security perimeter | Enforced |
| Inbound access allowed within same perimeter. | `perimeterIntraPerimeterInboundAllowed` | Inbound access within perimeter | Learning/Enforced |
| Public inbound access allowed by PaaS resource rules | `perimeterPublicInboundResourceRulesAllowed` | When network security perimeter rules deny, and Inbound access allowed based on PaaS resource rules | Learning |
| Public inbound access denied by PaaS resource rules | `perimeterPublicInboundResourceRulesDenied` | When network security perimeter rules deny, Inbound access denied by PaaS resource rules | Learning |
| Public outbound access allowed by PaaS resource rules | `perimeterPublicOutboundResourceRulesAllowed` | When network security perimeter rules deny, Outbound access allowed based on PaaS resource rules | Learning |
| Public outbound access denied by PaaS resource rules | `perimeterPublicOutboundResourceRulesDenied` | When network security perimeter rules deny, Outbound access denied by PaaS resource rules | Learning |
| Private endpoint traffic allowed | `perimeterPrivateInboundAllowed` | Private endpoint traffic | Learning/Enforced |
| Cross perimeter outbound access allowed by perimeter link | `perimeterCrossPerimeterOutboundAllowed` | Outbound access based on 'Link' rules | Learning/Enforced |
| Cross perimeter inbound access allowed by perimeter link | `perimeterCrossPerimeterInboundAllowed` | Inbound access based on 'Link' rules | Learning/Enforced |
| Outbound attempted to sme or different perimeter | `perimeterOutboundAttempt` | Outbound attempt within network security perimeter or between two 'linked' network security perimeters | Learning/Enforced |


## Retrieve access logs from Log Analytics workspace

When you send access logs to a Log Analytics workspace, they're stored in a table named `NSPAccessLogs` with the following schema.


| Column Name | Meaning | Example Value |
|:---|:---|:---|
| ResultDescription | Name of the network access operation | IngestDataToCollectionEndpoint<br>IngestDataFromCollectionEndpointToWorkspace<br>IngestDataToWorkspace<br>Microsoft.OperationalInsights/workspaces/query |
| Profile | Which Network Security Perimeter the search service was associated with | MyProfile |
| ServiceResourceId | Resource ID of the search service | LA-Workspace-resource-id<br>DCE-resource-id |
| Matched Rule | JSON description of the rule that was matched by the log | {"accessRule":"allow-demo-vm-01-IP-address"}<br>{"accessRule":"DefaultAllowAll"}<br>{"accessRule":"DefaultAllowWithinPerimeter"}<br>{"accessRule":"DefaultDenyAll"}<br>{"accessRule":"DefaultDenyBySecuredByPerimeter"} |
SourceIPAddress | Source IP of the inbound network access, if applicable | 1.1.1.1 |
| AccessRuleVersion | Version of the NSP access rules used to enforce the network access rules | 0 |

See [Query Azure Monitor logs](/azure/azure-monitor/log-query-overview) for more information on querying logs in Log Analytics. Followng are some sample queries:

**Retrieve all access logs**

```kusto
NSPAccessLogs
```

**Retrieve all denied requests**

```kusto
NSPAccessLogs
| where ResultDescription contains "Denied"
```

**Count records by profile and rule**

```kusto
NSPAccessLogs
| summarize count() by Profile, MatchedRule
```

****

```kusto
NSPAccessLogs
| where Category contains "NspPublicInboundPerimeterRulesDenied"
| summarize count() by Location,ResultDescription,SourceIpAddress
```

## Retrieving access logs from Azure storage
When you send access logs to an Azure storage account, the storage account will have containers for every log category. The folder structure inside the container matches the resource ID of the Network Security Perimeter and the time the logs were taken. 

:::image type="content" source="media/network-security-perimeter-concepts/storage-account.png" alt-text="Screenshot of storage account with network security perimeter resource logs." lightbox="media/network-security-perimeter-concepts/storage-account.png":::

Each line on the JSON log file contains a record of the Network Security Perimeter network access that matches the log category. For example, the inbound perimeter rules allowed category log uses the following format:

```json
{
    "time": "2024-04-26T00:58:01",
    "resourceId": "/SUBSCRIPTIONS/88E5BE3-6163-4AE6-9B38-9F10C1429F24/RESOURCEGROUPS/MSUNDARAM-NSP-DEMO-NCUS/PROVIDERS/MICROSOFT.NETWORK/NETWORKSECURITYPERIMETERS/AZMON-NSP-DEMO-NCUS",
    "category": "NspPublicInboundPerimeterRulesAllowed",
    "location": "northcentralus",
    "properties": {
        "profile": "msundaramProfile",
        "serviceResourceId": "/subscriptions/88E5BE3-6163-4ae6-9b38-9f10c1429f24/resourceGroups/msundaram-nsp-demo-ncus/providers/Microsoft.OperationalInsights/workspaces/LA-WS-Test-NSP",
        "serviceFeatureNames": [
            "*"
        ],
        "accessRulesVersion": "",
        "matchedRule": {
            "accessRule": "allow-demo-vm-01-IP-address"
        },
        "source": {
            "ipAddress": "172.183.184.225",
            "resourceId": "",
            "parameters": "CallerInfo: OMS",
            "port": "50196",
            "protocol": "https"
        },
        "serviceFqdn": ""
    }
}
```

## Next steps

> [!div class="nextstepaction"]
> [Create a network security perimeter in the Azure portal](/azure/private-link/create-network-security-perimeter-portal).