---
ms.topic: include
ms.date: 01/31/2025
---

### Filter and preprocess telemetry

You can write code to filter, modify, or enrich your telemetry before it's sent from the SDK. The processing includes data that's sent from the standard telemetry modules, such as HTTP request collection and dependency collection.

* [Filtering](#filtering) can modify or discard telemetry before it's sent from the SDK by implementing `ITelemetryProcessor`. For example, you could reduce the volume of telemetry by excluding requests from robots. Unlike sampling, You have full control over what is sent or discarded, but it affects any metrics based on aggregated logs. Depending on how you discard items, you might also lose the ability to navigate between related items.

* Add or Modify properties to any telemetry sent from your app by implementing an `ITelemetryInitializer`. For example, you could add calculated values or version numbers by which to filter the data in the portal.

* [Sampling](../sampling.md) reduces the volume of telemetry without affecting your statistics. It keeps together related data points so that you can navigate between them when you diagnose a problem. In the portal, the total counts are multiplied to compensate for the sampling.

> [!NOTE]
> [The SDK API](../api-custom-events-metrics.md) is used to send custom events and metrics.

#### Filtering

This technique gives you direct control over what's included or excluded from the telemetry stream. Filtering can be used to drop telemetry items from being sent to Application Insights. You can use filtering with sampling, or separately.

To filter telemetry, you write a telemetry processor and register it with `TelemetryConfiguration`. All telemetry goes through your processor. You can choose to drop it from the stream or give it to the next processor in the chain. Telemetry from the standard modules, such as the HTTP request collector and the dependency collector, and telemetry you tracked yourself is included. For example, you can filter out telemetry about requests from robots or successful dependency calls.

> [!WARNING]
> Filtering the telemetry sent from the SDK by using processors can skew the statistics that you see in the portal and make it difficult to follow related items.
>
> Instead, consider using [sampling](../sampling.md).
