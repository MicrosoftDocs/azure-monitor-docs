---
title: Diagnostic Settings FAQ
description: Frequently Asked Questions about working with diagnostic settings.
ms.topic: how-to
ms.custom: references_regions
ms.date: 03/31/2026
ms.author: shseth
---

# Frequently asked questions – Platform logs exported through diagnostic settings

### Q : What is changing with platform logs exported through diagnostic settings?

Billing will apply to certain platform logs exported using Azure Diagnostic Settings when they are streamed to destinations such as:
- Azure Storage  
- Azure Event Hubs  
- Partner solutions  

This billing change applies only to platform log categories that are **not eligible for free export**. 

---

### Q : Are all platform logs billable?

No.

Some platform log categories remain eligible for **free export**.

Only platform logs that are:
- Not eligible for free export  
- Exported to Azure Storage, Event Hubs, or partner solutions  

will incur export charges.

---

### Q : When does this change take effect?

Billing for streaming platform logs began on **February 1, 2022** for select resource types. Starting in **May 2026**, billing will be enabled for all remaining Azure resource types (excluding logs eligible for free export). 

---

### Q : How can I determine if a platform log category is billable?

You can review the **"Costs to export"** column in the Azure Monitor documentation under:

> Logs categories by resource type

- **Yes** → Billable log category  
- **No / Blank** → Free log category 

---

### Q : What determines whether export charges apply?

Export charges depend on:
- The platform log category selected for the resource type  
- The destination to which the logs are exported 

---

### Q : Does this affect platform logs sent to Log Analytics workspaces?

No.

Exporting platform logs to a Log Analytics workspace **does not incur any separate export charge**.  
Platform logs sent to Log Analytics continue to be billed under existing Log Analytics ingestion pricing.

This update only affects exports sent to:
- Azure Storage  
- Azure Event Hubs  
- Partner solutions 

---

### Q : Are metrics affected by this change?

No.

This announcement applies only to **platform logs** exported through Diagnostic Settings.  
Metrics are not affected. 

---

### Q : Can I control which platform logs are exported?

Yes.

Diagnostic Settings allows you to selectively enable or disable individual platform log categories to help manage cost and data volume. 

---

### Q : How are export charges measured?

Charges are based on the **size of exported platform logs**, calculated as:

- The number of bytes in exported JSON-formatted log data  
- 1 GB = 1,000,000,000 bytes 

---

### Q : What actions should I take to manage potential costs?

Here are some recommendations: 
- Review existing Diagnostic Settings configurations  
- Identify which platform logs are currently exported  
- Validate whether those logs are eligible for free export  
- Adjust log categories or export destinations as needed 
