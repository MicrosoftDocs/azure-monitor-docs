---
ms.topic: include
ms.date: 05/03/2026
---

#### JavaScript telemetry initializers

Telemetry initializers run before a JavaScript telemetry item is sent. Use them to add, modify, or drop browser telemetry. Returning `false` from an initializer drops the item.

Use telemetry initializers for targeted enrichment or filtering. Use sampling when you need volume reduction without explicitly excluding specific telemetry.