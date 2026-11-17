---
title: PII redaction in Azure Monitor Logs (preview)
description: Add a sensitive-information scanner to a data collection rule to redact PII in Azure Monitor Logs. Sign up for the preview and test with synthetic data.
ms.topic: how-to
ms.date: 11/05/2026
ai-usage: ai-generated
---

# Redact sensitive information in Azure Monitor Logs (preview)

Use an ingestion-time transformation to detect sensitive information, such as email addresses and credit card numbers, and replace it before records are stored in a Log Analytics table. This article shows how to add the `scan.SensitiveInfo` processor to a data collection rule (DCR), choose detection types and a protection method, and verify the results with synthetic telemetry.

> [!IMPORTANT]
> PII redaction is a signup-based preview. Any customer can apply through the [PII redaction preview signup form](https://aka.ms/pii-redaction-preview). After your subscription is enabled, you can configure the processor. See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for preview terms.

## Prerequisites

- Preview access enabled for your subscription.
- A DCR that sends data to a Log Analytics table. For data collected without a DCR, see [Use the workspace transformation DCR](#use-the-workspace-transformation-dcr).
- Permission to create or update DCRs and query the destination table. See [Permissions for DCRs](data-collection-rule-create-edit.md#permissions).
- Azure CLI. The examples use `az rest` with DCR API version `2025-05-11`, which supports [multi-stage transformations](data-collection-transformations.md#multi-stage-transformations-preview).

## Choose the DCR

The scanner runs in Azure Monitor at the ingestion-time stage of a DCR, after data arrives and before it's stored. Add the scanner to the DCR that processes your data:

| Data | DCR to update |
| :--- | :--- |
| Data collected by Azure Monitor Agent | The DCR associated with the agent |
| Data sent through the Logs Ingestion API | The DCR that the API call targets |
| Data sent to a supported table without a DCR, such as Application Insights telemetry or resource logs from diagnostic settings | The [workspace transformation DCR](#use-the-workspace-transformation-dcr) |

If a table receives data through several DCRs, add the scanner to each of them. The scanner processes new records that arrive after the DCR takes effect. Coordinate changes with the owners of applications that share the DCR or destination table.

## Choose detection and protection

Select the built-in types that match your requirements. For type IDs, default placeholders, and configuration properties, see the [`scan.SensitiveInfo` reference](data-collection-rule-structure.md#scansensitiveinfo).

Choose one protection method for the processor:

- `obfuscate`: Replace each match with a type-specific placeholder or your own replacement text.
- `hash`: Replace each match with a deterministic token. Repeated values produce the same token, so you can correlate records that contain the same value.

For example, placeholder replacement can change:

```text
User alex@example.com connected from 192.0.2.10.
```

to:

```text
User [REDACTED_EMAIL] connected from [REDACTED_IPV4].
```

The scanner replaces the matched text and keeps the rest of the value.

## Add the scanner to a DCR

Each ingestion-time transformation starts with a header processor that matches the data flow's input stream: [`header.StandardStream`](data-collection-rule-structure.md#headerstandardstream) for standard streams such as `Microsoft-Syslog`, or [`header.CustomStream`](data-collection-rule-structure.md#headercustomstream) for custom streams such as `Custom-AppEvents`. Add the scanner as the last processor.

1. Export the DCR with API version `2025-05-11` and save a copy for rollback. Replace the placeholders in the commands with your resource values.

    ```azurecli
    az rest --method get --url "https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{dcrResourceGroup}/providers/Microsoft.Insights/dataCollectionRules/{dcrName}?api-version=2025-05-11" --output json
    ```

1. In `properties.transformations`, add a named transformation with the header processor and the scanner. In the data flow, set `transform` to the transformation name. The following excerpt shows the `dataFlows` and `transformations` entries for a Logs Ingestion API custom stream:

    ```json
    {
      "dataFlows": [
        {
          "streams": ["Custom-AppEvents"],
          "destinations": ["workspace"],
          "transform": "redactAppEvents",
          "outputStream": "Custom-AppEvents_CL"
        }
      ],
      "transformations": [
        {
          "name": "redactAppEvents",
          "headerProcessor": {
            "processor": "header.CustomStream",
            "configuration": {
              "streamId": "Custom-AppEvents"
            }
          },
          "processors": [
            {
              "processor": "scan.SensitiveInfo",
              "configuration": {
                "defaultStrategy": "obfuscate",
                "types": ["Email", "PhoneNumber", "CreditCardNumber", "NationalId.US.SSN", "IPAddress.v4"]
              }
            }
          ]
        }
      ]
    }
    ```

    If the data flow already uses `transformKql`, move its query into a [`transform.KQL`](data-collection-rule-structure.md#transformkql) processor placed before the scanner, and replace `transformKql` with `transform` in the data flow. If the transformation already has processors, keep them and add the scanner after them. If other data flows share the named transformation, create a separate transformation for the flow you're changing.

    The scanner processes string values in dynamic columns, so keep these columns in their original type.

1. Save the updated definition as `dcr.json`, deploy it, and read it back with the same API version.

    ```azurecli
    az rest --method put --url "https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{dcrResourceGroup}/providers/Microsoft.Insights/dataCollectionRules/{dcrName}?api-version=2025-05-11" --body @dcr.json
    ```

    ```azurecli
    az rest --method get --url "https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{dcrResourceGroup}/providers/Microsoft.Insights/dataCollectionRules/{dcrName}?api-version=2025-05-11" --output json
    ```

    Confirm the stream and header, transformation reference, selected types, and scanner position. Check that the other settings in the rule are unchanged.

## Use the workspace transformation DCR

For data sent to a supported table without a DCR, add the scanner to the [workspace transformation DCR](data-collection-transformations.md#workspace-transformation-dcr). A workspace has one workspace transformation DCR, which can contain transformations for multiple tables. It applies to all records that reach those tables without a collection DCR. For supported tables, see [Logs table feature support](../reference/tables-features.md).

This procedure also requires permission to update the destination table and the workspace.

1. Enable each destination table for workspace transformations through the Tables API. Every transformed table requires this step, including tables whose schema stays the same. Follow [Update table schema](../logs/tutorial-workspace-transformations-api.md#update-table-schema) and keep the table's existing columns.

1. Read the workspace's current DCR link.

    ```azurecli
    az rest --method get --url "https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{workspaceResourceGroup}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}?api-version=2023-09-01" --query properties.defaultDataCollectionRuleResourceId --output tsv
    ```

1. If a DCR is linked, add the scanner to it as described in [Add the scanner to a DCR](#add-the-scanner-to-a-dcr), using `header.StandardStream` with the table's stream, such as `Microsoft-Table-AppTraces`. Otherwise, create a DCR from the following complete example. Replace `{workspaceRegion}` with your workspace's region and the resource ID placeholders with your workspace values.

    ```json
    {
      "kind": "WorkspaceTransforms",
      "location": "{workspaceRegion}",
      "properties": {
        "dataSources": {},
        "destinations": {
          "logAnalytics": [
            {
              "name": "targetWorkspace",
              "workspaceResourceId": "/subscriptions/{subscriptionId}/resourceGroups/{workspaceResourceGroup}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}"
            }
          ]
        },
        "dataFlows": [
          {
            "streams": ["Microsoft-Table-AppTraces"],
            "destinations": ["targetWorkspace"],
            "transform": "redactAppTraces"
          }
        ],
        "transformations": [
          {
            "name": "redactAppTraces",
            "headerProcessor": {
              "processor": "header.StandardStream",
              "configuration": {
                "streamId": "Microsoft-Table-AppTraces"
              }
            },
            "processors": [
              {
                "processor": "scan.SensitiveInfo",
                "configuration": {
                  "defaultStrategy": "obfuscate",
                  "types": ["Email", "PhoneNumber", "CreditCardNumber", "NationalId.US.SSN", "IPAddress.v4"]
                }
              }
            ]
          }
        ]
      }
    }
    ```

    Deploy it with the `put` command in [Add the scanner to a DCR](#add-the-scanner-to-a-dcr).

1. To link a new DCR, follow [Link workspace to DCR](../logs/tutorial-workspace-transformations-api.md#link-workspace-to-dcr) to set the workspace's `properties.defaultDataCollectionRuleResourceId` property to the DCR's resource ID.

## Verify new telemetry

Send synthetic test data through the same collection path as your production data. Use fictitious values, such as reserved example domains and documentation IP address ranges.

1. Wait for the configuration to take effect, then send a record with a unique marker such as `PII_PREVIEW_TEST_001` and synthetic email and IP address values in a string column. If the stream has a dynamic column, include a test value there too.
1. Query the destination table. For example, for Application Insights data in `AppTraces`:

    ```kusto
    AppTraces
    | where TimeGenerated > ago(1h)
    | where Message contains "PII_PREVIEW_TEST_001"
    | project TimeGenerated, Message, Properties
    | order by TimeGenerated desc
    ```

1. Confirm that the test records arrived and that matches in string and dynamic columns are replaced with the expected placeholders or tokens.
1. Repeat the test for each selected type and each DCR and table that you configured. Confirm that your queries, alerts, and workbooks work with the redacted values.

For example, if you send this property bag with the `Email` type selected:

```json
{
  "contact": "alex@example.com",
  "items": ["alex@example.com", 42, true]
}
```

The stored value is:

```json
{
  "contact": "[REDACTED_EMAIL]",
  "items": ["[REDACTED_EMAIL]", 42, true]
}
```

## Monitor and change the configuration

Use [DCR monitoring](data-collection-monitor.md) to track transformation metrics, and enable error logging to the `DCRLogErrors` table.

| Symptom | Checks |
| :--- | :--- |
| Values aren't replaced | Confirm that preview access is enabled, the data flow references the transformation, and the type IDs are correct. For the workspace transformation DCR, also confirm the workspace link. |
| Unexpected values are replaced | Some values resemble a detected pattern, for example version numbers that look like IPv4 addresses. Review the selected types. |
| Expected records are missing | Check `DCRLogErrors`, ingestion metrics, and any filters in the transformation. |
| The processor is missing after an edit | Read the DCR with API version `2025-05-11`, and edit it with tools that support that API version. |

Configuration changes apply to new records. Values redacted in existing records stay redacted.

## Detection scope and costs

- The scanner detects the five built-in types listed in the [processor reference](data-collection-rule-structure.md#scansensitiveinfo).
- Pattern matching can produce false positives and false negatives. Test with the formats and locales that your workload uses.
- The `scan.SensitiveInfo` processor is a regular part of data transformation and doesn't incur a separate processing charge. Standard [transformation costs](data-collection-transformations.md#cost-for-transformations) apply based on the destination table plan. Placeholders and hash tokens can be longer than the original value.

## Related content

- [`scan.SensitiveInfo` configuration reference](data-collection-rule-structure.md#scansensitiveinfo)
- [Multi-stage transformations](data-collection-transformations.md#multi-stage-transformations-preview)
- [Create a transformation](data-collection-transformations-create.md)
- [Manage personal data in Azure Monitor Logs](../logs/personal-data-mgmt.md)
- [Monitor DCR data collection](data-collection-monitor.md)
