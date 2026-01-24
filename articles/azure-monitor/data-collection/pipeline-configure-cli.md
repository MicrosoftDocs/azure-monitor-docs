---
title: Configure Azure Monitor pipeline using CLI
description: Use CLI to configure Azure Monitor pipeline which extends Azure Monitor data collection into your own data center. 
ms.topic: how-to
ms.date: 01/15/2026
---

# Configure Azure Monitor pipeline using CLI

The [Azure Monitor pipeline](./pipeline-overview.md) extends the data collection capabilities of Azure Monitor to edge and multicloud environments. This article describes how to enable and configure the Azure Monitor pipeline in your environment using CLI.

## Prerequisites

For prerequisites and an overview of the pipeline and its components, see [Azure Monitor pipeline overview](./pipeline-overview.md).






Install the DCR using the following command:

```azurecli
az monitor data-collection rule create --name <dcr-name> --location <location> --resource-group <resource-group> --rule-file '<dcr-file-path.json>'

## Example
az monitor data-collection rule create --name my-pipeline-dcr --location westus2 --resource-group 'my-resource-group' --rule-file 'C:\MyDCR.json'
```





Install the template using the following command:

```azurecli
az deployment group create --resource-group <resource-group-name> --template-file <path-to-template>

## Example
az deployment group create --resource-group my-resource-group --template-file C:\MyPipelineConfig.json

```


### [Syslog](#tab/syslog)

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "description": "This template deploys an edge pipeline for azure monitor."
    },
    "resources": [
        {
            "type": "Microsoft.monitor/pipelineGroups",
            "location": "eastus2euap",
            "apiVersion": "2025-03-01-preview",
            "extendedLocation": {
                "name": "/subscriptions/215b5735-fa8b-4dd4-86dc-997320c68c2d/resourceGroups/rg-drewrelmas/providers/Microsoft.ExtendedLocation/customLocations/drewrelmas-customlocation-eastus2",
                "type": "CustomLocation"
            },
            "name": "drewrelmas-aep-eastus2euap",
            "properties": {
                "receivers": [
                    {
                        "type": "Syslog",
                        "name": "syslog-receiver",
                        "syslog": {
                            "endpoint": "0.0.0.0:514"
                        }
                    }
                ],
                "processors": [
                    {
                        "type": "MicrosoftSyslog",
                        "name": "ms-syslog-processor"
                    },
                    {
                        "type": "Batch",
                        "name": "batch-processor",
                        "batch": {
                            "timeout": 60000
                        }
                    },
                    {
                        "type": "TransformLanguage",
                        "name": "my-transform",
                        "transformLanguage": {
                            "transformStatement": "source"
                        }
                    }
                ],
                "exporters": [
                    {
                        "type": "AzureMonitorWorkspaceLogs",
                        "name": "syslog-eus2",
                        "azureMonitorWorkspaceLogs": {
                            "api": {
                                "dataCollectionEndpointUrl": "https://drewrelmas-dce-eastus2-t9si.eastus2-1.ingest.monitor.azure.com",
                                "dataCollectionRule": "dcr-9f8a459b3c224fddb626170fc08d66f9",
                                "stream": "Microsoft-Syslog-FullyFormed",
                                "schema": {
                                    "recordMap": [
                                        {
                                            "from": "attributes.CollectorHostName",
                                            "to": "CollectorHostName"
                                        },
                                        {
                                            "from": "attributes.Computer",
                                            "to": "Computer"
                                        },
                                        {
                                            "from": "attributes.EventTime",
                                            "to": "EventTime"
                                        },
                                        {
                                            "from": "attributes.Facility",
                                            "to": "Facility"
                                        },
                                        {
                                            "from": "attributes.HostIP",
                                            "to": "HostIP"
                                        },
                                        {
                                            "from": "attributes.HostName",
                                            "to": "HostName"
                                        },
                                        {
                                            "from": "attributes.ProcessID",
                                            "to": "ProcessID"
                                        },
                                        {
                                            "from": "attributes.ProcessName",
                                            "to": "ProcessName"
                                        },
                                        {
                                            "from": "attributes.SeverityLevel",
                                            "to": "SeverityLevel"
                                        },
                                        {
                                            "from": "attributes.SourceSystem",
                                            "to": "SourceSystem"
                                        },
                                        {
                                            "from": "attributes.SyslogMessage",
                                            "to": "SyslogMessage"
                                        },
                                        {
                                            "from": "attributes.TimeGenerated",
                                            "to": "TimeGenerated"
                                        }
                                    ]
                                }
                            }
                        }
                    }
                ],
                "service": {
                    "pipelines": [
                        {
                            "name": "syslog-pipeline",
                            "receivers": [
                                "syslog-receiver"
                            ],
                            "processors": [
                                "ms-syslog-processor",
                                "batch-processor",
                                "my-transform"
                            ],
                            "exporters": [
                                "syslog-eus2"
                            ],
                            "type": "Logs"
                        }
                    ]
                }
            }
        }
    ]
}
```


### [CEF](#tab/cef)

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "description": "This template deploys an edge pipeline for azure monitor."
    },
    "resources": [
        {
            "type": "Microsoft.monitor/pipelineGroups",
            "location": "eastus2euap",
            "apiVersion": "2025-03-01-preview",
            "extendedLocation": {
                "name": "/subscriptions/215b5735-fa8b-4dd4-86dc-997320c68c2d/resourceGroups/rg-drewrelmas/providers/Microsoft.ExtendedLocation/customLocations/drewrelmas-customlocation-eastus2",
                "type": "CustomLocation"
            },
            "name": "drewrelmas-aep-eastus2euap",
            "properties": {
                "receivers": [
                    {
                        "type": "Syslog",
                        "name": "cef-receiver",
                        "syslog": {
                            "endpoint": "0.0.0.0:515"
                        }
                    }
                ],
                "processors": [
                    {
                        "type": "MicrosoftCommonSecurityLog",
                        "name": "ms-cef-processor"
                    },
                    {
                        "type": "Batch",
                        "name": "batch-processor",
                        "batch": {
                            "timeout": 60000
                        }
                    },
                    {
                        "type": "TransformLanguage",
                        "name": "my-transform",
                        "transformLanguage": {
                            "transformStatement": "source"
                        }
                    }
                ],
                "exporters": [
                    {
                        "type": "AzureMonitorWorkspaceLogs",
                        "name": "cef-eus2",
                        "azureMonitorWorkspaceLogs": {
                            "api": {
                                "dataCollectionEndpointUrl": "https://drewrelmas-dce-eastus2-t9si.eastus2-1.ingest.monitor.azure.com",
                                "dataCollectionRule": "dcr-9f8a459b3c224fddb626170fc08d66f9",
                                "stream": "Microsoft-CommonSecurityLog-FullyFormed",
                                "schema": {
                                    "recordMap": [
                                        {
                                            "from": "attributes.Computer",
                                            "to": "Computer"
                                        },
                                        {
                                            "from": "attributes.TimeGenerated",
                                            "to": "TimeGenerated"
                                        },
                                        {
                                            "from": "attributes.CollectorHostName",
                                            "to": "CollectorHostName"
                                        },
                                        {
                                            "from": "attributes.DeviceVendor",
                                            "to": "DeviceVendor"
                                        },
                                        {
                                            "from": "attributes.DeviceProduct",
                                            "to": "DeviceProduct"
                                        },
                                        {
                                            "from": "attributes.DeviceVersion",
                                            "to": "DeviceVersion"
                                        },
                                        {
                                            "from": "attributes.DeviceEventClassID",
                                            "to": "DeviceEventClassID"
                                        },
                                        {
                                            "from": "attributes.Activity",
                                            "to": "Activity"
                                        },
                                        {
                                            "from": "attributes.LogSeverity",
                                            "to": "LogSeverity"
                                        },
                                        {
                                            "from": "attributes.OriginalLogSeverity",
                                            "to": "OriginalLogSeverity"
                                        },
                                        {
                                            "from": "attributes.AdditionalExtensions",
                                            "to": "AdditionalExtensions"
                                        },
                                        {
                                            "from": "attributes.ApplicationProtocol",
                                            "to": "ApplicationProtocol"
                                        },
                                        {
                                            "from": "attributes.EventCount",
                                            "to": "EventCount"
                                        },
                                        {
                                            "from": "attributes.DestinationDnsDomain",
                                            "to": "DestinationDnsDomain"
                                        },
                                        {
                                            "from": "attributes.DestinationServiceName",
                                            "to": "DestinationServiceName"
                                        },
                                        {
                                            "from": "attributes.DestinationTranslatedAddress",
                                            "to": "DestinationTranslatedAddress"
                                        },
                                        {
                                            "from": "attributes.DestinationTranslatedPort",
                                            "to": "DestinationTranslatedPort"
                                        },
                                        {
                                            "from": "attributes.CommunicationDirection",
                                            "to": "CommunicationDirection"
                                        },
                                        {
                                            "from": "attributes.DeviceDnsDomain",
                                            "to": "DeviceDnsDomain"
                                        },
                                        {
                                            "from": "attributes.DeviceExternalID",
                                            "to": "DeviceExternalID"
                                        },
                                        {
                                            "from": "attributes.DeviceFacility",
                                            "to": "DeviceFacility"
                                        },
                                        {
                                            "from": "attributes.DeviceInboundInterface",
                                            "to": "DeviceInboundInterface"
                                        },
                                        {
                                            "from": "attributes.DeviceName",
                                            "to": "DeviceName"
                                        },
                                        {
                                            "from": "attributes.DeviceNtDomain",
                                            "to": "DeviceNtDomain"
                                        },
                                        {
                                            "from": "attributes.DeviceOutboundInterface",
                                            "to": "DeviceOutboundInterface"
                                        },
                                        {
                                            "from": "attributes.DevicePayloadId",
                                            "to": "DevicePayloadId"
                                        },
                                        {
                                            "from": "attributes.ProcessName",
                                            "to": "ProcessName"
                                        },
                                        {
                                            "from": "attributes.DeviceTranslatedAddress",
                                            "to": "DeviceTranslatedAddress"
                                        },
                                        {
                                            "from": "attributes.DestinationHostName",
                                            "to": "DestinationHostName"
                                        },
                                        {
                                            "from": "attributes.DestinationMACAddress",
                                            "to": "DestinationMACAddress"
                                        },
                                        {
                                            "from": "attributes.DestinationNTDomain",
                                            "to": "DestinationNTDomain"
                                        },
                                        {
                                            "from": "attributes.DestinationProcessId",
                                            "to": "DestinationProcessId"
                                        },
                                        {
                                            "from": "attributes.DestinationUserPrivileges",
                                            "to": "DestinationUserPrivileges"
                                        },
                                        {
                                            "from": "attributes.DestinationProcessName",
                                            "to": "DestinationProcessName"
                                        },
                                        {
                                            "from": "attributes.DestinationPort",
                                            "to": "DestinationPort"
                                        },
                                        {
                                            "from": "attributes.DestinationIP",
                                            "to": "DestinationIP"
                                        },
                                        {
                                            "from": "attributes.DeviceTimeZone",
                                            "to": "DeviceTimeZone"
                                        },
                                        {
                                            "from": "attributes.DestinationUserID",
                                            "to": "DestinationUserID"
                                        },
                                        {
                                            "from": "attributes.DestinationUserName",
                                            "to": "DestinationUserName"
                                        },
                                        {
                                            "from": "attributes.DeviceAddress",
                                            "to": "DeviceAddress"
                                        },
                                        {
                                            "from": "attributes.DeviceMacAddress",
                                            "to": "DeviceMacAddress"
                                        },
                                        {
                                            "from": "attributes.ProcessID",
                                            "to": "ProcessID"
                                        },
                                        {
                                            "from": "attributes.ExternalID",
                                            "to": "ExternalID"
                                        },
                                        {
                                            "from": "attributes.ExtID",
                                            "to": "ExtID"
                                        },
                                        {
                                            "from": "attributes.FileCreateTime",
                                            "to": "FileCreateTime"
                                        },
                                        {
                                            "from": "attributes.FileHash",
                                            "to": "FileHash"
                                        },
                                        {
                                            "from": "attributes.FileID",
                                            "to": "FileID"
                                        },
                                        {
                                            "from": "attributes.FileModificationTime",
                                            "to": "FileModificationTime"
                                        },
                                        {
                                            "from": "attributes.FilePath",
                                            "to": "FilePath"
                                        },
                                        {
                                            "from": "attributes.FilePermission",
                                            "to": "FilePermission"
                                        },
                                        {
                                            "from": "attributes.FileType",
                                            "to": "FileType"
                                        },
                                        {
                                            "from": "attributes.FileName",
                                            "to": "FileName"
                                        },
                                        {
                                            "from": "attributes.FileSize",
                                            "to": "FileSize"
                                        },
                                        {
                                            "from": "attributes.ReceivedBytes",
                                            "to": "ReceivedBytes"
                                        },
                                        {
                                            "from": "attributes.Message",
                                            "to": "Message"
                                        },
                                        {
                                            "from": "attributes.OldFileCreateTime",
                                            "to": "OldFileCreateTime"
                                        },
                                        {
                                            "from": "attributes.OldFileHash",
                                            "to": "OldFileHash"
                                        },
                                        {
                                            "from": "attributes.OldFileID",
                                            "to": "OldFileID"
                                        },
                                        {
                                            "from": "attributes.OldFileModificationTime",
                                            "to": "OldFileModificationTime"
                                        },
                                        {
                                            "from": "attributes.OldFileName",
                                            "to": "OldFileName"
                                        },
                                        {
                                            "from": "attributes.OldFilePath",
                                            "to": "OldFilePath"
                                        },
                                        {
                                            "from": "attributes.OldFilePermission",
                                            "to": "OldFilePermission"
                                        },
                                        {
                                            "from": "attributes.OldFileSize",
                                            "to": "OldFileSize"
                                        },
                                        {
                                            "from": "attributes.OldFileType",
                                            "to": "OldFileType"
                                        },
                                        {
                                            "from": "attributes.SentBytes",
                                            "to": "SentBytes"
                                        },
                                        {
                                            "from": "attributes.EventOutcome",
                                            "to": "EventOutcome"
                                        },
                                        {
                                            "from": "attributes.Protocol",
                                            "to": "Protocol"
                                        },
                                        {
                                            "from": "attributes.Reason",
                                            "to": "Reason"
                                        },
                                        {
                                            "from": "attributes.RequestURL",
                                            "to": "RequestURL"
                                        },
                                        {
                                            "from": "attributes.RequestClientApplication",
                                            "to": "RequestClientApplication"
                                        },
                                        {
                                            "from": "attributes.RequestContext",
                                            "to": "RequestContext"
                                        },
                                        {
                                            "from": "attributes.RequestCookies",
                                            "to": "RequestCookies"
                                        },
                                        {
                                            "from": "attributes.RequestMethod",
                                            "to": "RequestMethod"
                                        },
                                        {
                                            "from": "attributes.ReceiptTime",
                                            "to": "ReceiptTime"
                                        },
                                        {
                                            "from": "attributes.SourceHostName",
                                            "to": "SourceHostName"
                                        },
                                        {
                                            "from": "attributes.SourceMACAddress",
                                            "to": "SourceMACAddress"
                                        },
                                        {
                                            "from": "attributes.SourceNTDomain",
                                            "to": "SourceNTDomain"
                                        },
                                        {
                                            "from": "attributes.SourceDnsDomain",
                                            "to": "SourceDnsDomain"
                                        },
                                        {
                                            "from": "attributes.SourceServiceName",
                                            "to": "SourceServiceName"
                                        },
                                        {
                                            "from": "attributes.SourceTranslatedAddress",
                                            "to": "SourceTranslatedAddress"
                                        },
                                        {
                                            "from": "attributes.SourceTranslatedPort",
                                            "to": "SourceTranslatedPort"
                                        },
                                        {
                                            "from": "attributes.SourceProcessId",
                                            "to": "SourceProcessId"
                                        },
                                        {
                                            "from": "attributes.SourceUserPrivileges",
                                            "to": "SourceUserPrivileges"
                                        },
                                        {
                                            "from": "attributes.SourceProcessName",
                                            "to": "SourceProcessName"
                                        },
                                        {
                                            "from": "attributes.SourcePort",
                                            "to": "SourcePort"
                                        },
                                        {
                                            "from": "attributes.SourceIP",
                                            "to": "SourceIP"
                                        },
                                        {
                                            "from": "attributes.SourceUserID",
                                            "to": "SourceUserID"
                                        },
                                        {
                                            "from": "attributes.SourceUserName",
                                            "to": "SourceUserName"
                                        },
                                        {
                                            "from": "attributes.EventType",
                                            "to": "EventType"
                                        },
                                        {
                                            "from": "attributes.DeviceEventCategory",
                                            "to": "DeviceEventCategory"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomIPv6Address1",
                                            "to": "DeviceCustomIPv6Address1"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomIPv6Address1Label",
                                            "to": "DeviceCustomIPv6Address1Label"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomIPv6Address2",
                                            "to": "DeviceCustomIPv6Address2"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomIPv6Address2Label",
                                            "to": "DeviceCustomIPv6Address2Label"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomIPv6Address3",
                                            "to": "DeviceCustomIPv6Address3"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomIPv6Address3Label",
                                            "to": "DeviceCustomIPv6Address3Label"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomIPv6Address4",
                                            "to": "DeviceCustomIPv6Address4"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomIPv6Address4Label",
                                            "to": "DeviceCustomIPv6Address4Label"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomFloatingPoint1",
                                            "to": "DeviceCustomFloatingPoint1"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomFloatingPoint1Label",
                                            "to": "DeviceCustomFloatingPoint1Label"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomFloatingPoint2",
                                            "to": "DeviceCustomFloatingPoint2"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomFloatingPoint2Label",
                                            "to": "DeviceCustomFloatingPoint2Label"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomFloatingPoint3",
                                            "to": "DeviceCustomFloatingPoint3"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomFloatingPoint3Label",
                                            "to": "DeviceCustomFloatingPoint3Label"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomFloatingPoint4",
                                            "to": "DeviceCustomFloatingPoint4"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomFloatingPoint4Label",
                                            "to": "DeviceCustomFloatingPoint4Label"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomNumber1",
                                            "to": "DeviceCustomNumber1"
                                        },
                                        {
                                            "from": "attributes.FieldDeviceCustomNumber1",
                                            "to": "FieldDeviceCustomNumber1"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomNumber1Label",
                                            "to": "DeviceCustomNumber1Label"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomNumber2",
                                            "to": "DeviceCustomNumber2"
                                        },
                                        {
                                            "from": "attributes.FieldDeviceCustomNumber2",
                                            "to": "FieldDeviceCustomNumber2"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomNumber2Label",
                                            "to": "DeviceCustomNumber2Label"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomNumber3",
                                            "to": "DeviceCustomNumber3"
                                        },
                                        {
                                            "from": "attributes.FieldDeviceCustomNumber3",
                                            "to": "FieldDeviceCustomNumber3"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomNumber3Label",
                                            "to": "DeviceCustomNumber3Label"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomString1",
                                            "to": "DeviceCustomString1"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomString1Label",
                                            "to": "DeviceCustomString1Label"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomString2",
                                            "to": "DeviceCustomString2"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomString2Label",
                                            "to": "DeviceCustomString2Label"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomString3",
                                            "to": "DeviceCustomString3"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomString3Label",
                                            "to": "DeviceCustomString3Label"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomString4",
                                            "to": "DeviceCustomString4"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomString4Label",
                                            "to": "DeviceCustomString4Label"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomString5",
                                            "to": "DeviceCustomString5"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomString5Label",
                                            "to": "DeviceCustomString5Label"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomString6",
                                            "to": "DeviceCustomString6"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomString6Label",
                                            "to": "DeviceCustomString6Label"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomDate1",
                                            "to": "DeviceCustomDate1"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomDate1Label",
                                            "to": "DeviceCustomDate1Label"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomDate2",
                                            "to": "DeviceCustomDate2"
                                        },
                                        {
                                            "from": "attributes.DeviceCustomDate2Label",
                                            "to": "DeviceCustomDate2Label"
                                        },
                                        {
                                            "from": "attributes.FlexDate1",
                                            "to": "FlexDate1"
                                        },
                                        {
                                            "from": "attributes.FlexDate1Label",
                                            "to": "FlexDate1Label"
                                        },
                                        {
                                            "from": "attributes.FlexNumber1",
                                            "to": "FlexNumber1"
                                        },
                                        {
                                            "from": "attributes.FlexNumber1Label",
                                            "to": "FlexNumber1Label"
                                        },
                                        {
                                            "from": "attributes.FlexNumber2",
                                            "to": "FlexNumber2"
                                        },
                                        {
                                            "from": "attributes.FlexNumber2Label",
                                            "to": "FlexNumber2Label"
                                        },
                                        {
                                            "from": "attributes.FlexString1",
                                            "to": "FlexString1"
                                        },
                                        {
                                            "from": "attributes.FlexString1Label",
                                            "to": "FlexString1Label"
                                        },
                                        {
                                            "from": "attributes.FlexString2",
                                            "to": "FlexString2"
                                        },
                                        {
                                            "from": "attributes.FlexString2Label",
                                            "to": "FlexString2Label"
                                        },
                                        {
                                            "from": "attributes.DeviceAction",
                                            "to": "DeviceAction"
                                        },
                                        {
                                            "from": "attributes.SimplifiedDeviceAction",
                                            "to": "SimplifiedDeviceAction"
                                        },
                                        {
                                            "from": "attributes.RemoteIP",
                                            "to": "RemoteIP"
                                        },
                                        {
                                            "from": "attributes.RemotePort",
                                            "to": "RemotePort"
                                        },
                                        {
                                            "from": "attributes.SourceSystem",
                                            "to": "SourceSystem"
                                        }
                                    ]
                                }
                            }
                        }
                    }
                ],
                "service": {
                    "pipelines": [
                        {
                            "name": "cef-pipeline",
                            "receivers": [
                                "cef-receiver"
                            ],
                            "processors": [
                                "ms-cef-processor",
                                "batch-processor",
                                "my-transform"
                            ],
                            "exporters": [
                                "cef-eus2"
                            ],
                            "type": "Logs"
                        }
                    ]
                }
            }
        }
    ]
}
```
---


## Next steps

* [Verify the pipeline configuration](./pipeline-configure.md#verify-configuration).
* [Configure clients](./pipeline-configure-clients.md) to use the pipeline.
* Modify data before it's sent to the cloud using [pipeline transformations](./pipeline-transformations.md).
