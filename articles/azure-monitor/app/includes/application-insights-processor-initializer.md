---
ms.topic: include
ms.date: 01/31/2025
---

#### ITelemetryProcessor and ITelemetryInitializer

What's the difference between telemetry processors and telemetry initializers?

* There are some overlaps in what you can do with them. Both can be used to add or modify properties of telemetry, although we recommend that you use initializers for that purpose.
* Telemetry initializers always run before telemetry processors.
* Telemetry initializers may be called more than once. By convention, they don't set any property that was already set.
* Telemetry processors allow you to completely replace or discard a telemetry item.
* All registered telemetry initializers are called for every telemetry item. For telemetry processors, SDK guarantees calling the first telemetry processor. Whether the rest of the processors are called or not is decided by the preceding telemetry processors.
* Use telemetry initializers to enrich telemetry with more properties or override an existing one. Use a telemetry processor to filter out telemetry.

#### Add/modify properties

Use telemetry initializers to enrich telemetry with additional information or to override telemetry properties set by the standard telemetry modules.

For example, Application Insights for a web package collects telemetry about HTTP requests. By default, it flags any request with a response code >=400 as failed. If instead you want to treat 400 as a success, you can provide a telemetry initializer that sets the success property.

If you provide a telemetry initializer, it's called whenever any of the Track*() methods are called. This initializer includes `Track()` methods called by the standard telemetry modules. By convention, these modules don't set any property that was already set by an initializer. Telemetry initializers are called before calling telemetry processors, so any enrichments done by initializers are visible to processors.


