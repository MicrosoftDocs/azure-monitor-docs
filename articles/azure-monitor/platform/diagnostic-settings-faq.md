---
title: Diagnostic settings FAQ
description: Frequently Asked Questions about billing enablement with diagnostic settings.
ms.topic: how-to
ms.date: 06/10/2026
ms.author: msundaram
author: msundaram
ai-usage: ai-assisted
---

# Frequently asked questions – Platform logs exported through diagnostic settings

### What is changing with platform logs exported through diagnostic settings?

Billing applies to certain platform logs exported through Azure Diagnostic Settings when you stream them to destinations such as:
- Azure Storage  
- Azure Event Hubs  
- Partner solutions  

This billing change applies only to platform log categories that are **not eligible for free export**. 

---

### Are all platform logs billable?

No.

Some platform log categories remain eligible for **free export**. Billing for certain platform logs depends on both the selected log category and the destination to which you export logs by using diagnostic settings.

Only platform logs that are:
- Not eligible for free export  
- Exported to Azure Storage, Event Hubs, or partner solutions  

Incur export charges.

---

### When does this change take effect?

Billing for streaming platform logs started on **February 1, 2022** for select resource types. On **June 15, 2026**, it expands to all remaining Azure resource types (excluding logs eligible for free export).

---

### How can I determine if a platform log category is billable?

Review the **"Costs to export"** column in the [Azure Monitor resource logs documentation](/azure/azure-monitor/reference/logs-index) under:

> Logs categories by resource type

- **Yes** → Billable log category  
- **No / Blank** → Free log category 

---

### What determines whether export charges apply? Does this change introduce new charges for logs I'm already exporting today?

Starting June 15, 2026, you might incur export charges for certain platform log categories that were previously exported at no charge for some Azure resource types.

Whether export charges apply depends on:

The platform **log category** selected for a specific **resource type**
The **destination** where the logs are being exported (for example, Storage, Event Hubs, or another destination)
---

### Does this change affect platform logs sent to Log Analytics workspaces?

No.

Exporting platform logs to a Log Analytics workspace **doesn't incur any separate export charge**.  
You continue to pay for platform logs sent to Log Analytics under existing Log Analytics ingestion pricing.

This update only affects exports sent to:
- Azure Storage  
- Azure Event Hubs  
- Partner solutions 

---

### Are metrics affected by this change?

No.

This announcement applies only to **platform logs** exported through Diagnostic Settings.  
Metrics aren't affected. 

---

### Can I control which platform logs are exported?

Yes.

Diagnostic Settings enables you to selectively turn on or off individual platform log categories to help manage cost and data volume. 

---

### How are export charges measured?

Charges are based on the **size of exported platform logs** with the **pay-as-you-go** model, calculated as:

- The number of bytes in exported **JSON-formatted log data**
- **1 GB = 1,000,000,000** bytes (10⁹ bytes)

**Simple example (at $0.25 per GB):**

Walk through this simple example of exporting platform logs to an Azure Storage account or an Azure Event Hubs namespace:

| **Item** | **Value** |
|----------|-----------|
| Exported JSON log data|500,000,000,000 bytes|
| Billable volume (÷ 1,000,000,000)|500 GB|
| Export rate (example)|$0.25 per GB|
| Estimated|500 GB × $0.25 = $125.00|

In this example, you pay $125.00 for exporting 500 GB of platform logs.

> [!NOTE]
> The $0.25 per GB rate is shown for illustration only. The actual billing rate varies by region. Confirm the current rate for your region on the Azure Monitor pricing page.

> [!NOTE]
> - **Billing timeline:** Billing for streaming platform logs to an Azure Storage account or an Azure Event Hubs namespace was introduced on **February 1, 2022**; however, **actual billing activation begins on June 15, 2026.**
> - The actual **per-GB rate varies by region**—select your region on the Azure Monitor pricing page to confirm the exact rate ($0.25 is used here only as an example).

Reference: [Azure Monitor pricing](https://azure.microsoft.com/pricing/details/monitor/)

:::image type="content" source="media/diagnostic-settings/azure-monitor-pricing-calculator-platform-logs.png" lightbox="media/diagnostic-settings/azure-monitor-pricing-calculator-platform-logs.png" alt-text="Screenshot of the Azure Monitor pricing calculator for platform logs.":::

---

### What actions should I take to manage potential costs?

Follow these recommendations: 
- Review existing Diagnostic Settings configurations  
- Identify which platform logs are currently exported  
- Check whether those logs are eligible for free export  
- Adjust log categories or export destinations as needed 

---

### How can I review my current export costs in the Azure portal?

> [!NOTE]
> The **Cost Management** and **Cost analysis** view in the Azure portal is available starting June 16, 2026.

1. Open the [Azure portal](https://portal.azure.com/).
1. In the top search bar, type **Subscriptions** and select it.
1. Select your subscription from the list.
1. In the left-hand menu, go to **Cost Management** > **Cost analysis**.
1. Change the view to **Cost by resource**.
1. Add a resource type filter:
   + Select **Add filter** (above the chart or table).
   + Select **Resource type** from the dropdown.
   + Choose one or both values based on your diagnostic settings destination type:
      * `microsoft.storage/storageaccounts`
      * `microsoft.eventhub/namespaces`
   This filter narrows the results to only storage accounts or event hub namespaces.
1. (Optional) Set **Group by** = **Resource** to break down costs per individual resource.
1. Review the table sorted by cost to quickly identify the resources driving the highest spend.
1. Look for the **Platform Logs Data Processed** meter to find the actual cost incurred for each destination.
1. Review the cost per GB based on the region by using the Azure Monitor pricing calculator:
   + Open the Azure Monitor pricing page or calculator.
   + Select the region that matches your resources (pricing for platform logs is set regionally).
   + Review the per-GB rates for data ingestion, retention, and export to validate your cost per GB by region.

Reference: [Azure Monitor pricing](https://azure.microsoft.com/pricing/details/monitor/)

:::image type="content" source="media/diagnostic-settings/platform-logs-billing-meter.png" lightbox="media/diagnostic-settings/platform-logs-billing-meter.png" alt-text="Screenshot of the platform logs billing meter in Cost analysis.":::

---
