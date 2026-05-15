---
ms.topic: include
ms.date: 05/03/2026
---

### Filter and preprocess telemetry

For JavaScript web applications, use telemetry initializers to filter, modify, or enrich telemetry before it's sent.

* Return `false` from an initializer to drop a telemetry item before it is sent.
* Add or modify fields on the telemetry item to enrich telemetry with values that are useful for filtering and analysis.
* Use SDK sampling configuration to reduce telemetry volume when you need statistical sampling instead of explicit filtering.

> [!WARNING]
> Filtering telemetry can skew portal statistics and can make it harder to follow related items. Prefer sampling when you need volume reduction without explicitly excluding specific telemetry.