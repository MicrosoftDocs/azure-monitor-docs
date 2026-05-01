---
title: Supported metrics - NGINX.NGINXPLUS/nginxDeployments
description: Reference for NGINX.NGINXPLUS/nginxDeployments metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: NGINX.NGINXPLUS/nginxDeployments, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for NGINX.NGINXPLUS/nginxDeployments

The following table lists the metrics available for the NGINX.NGINXPLUS/nginxDeployments resource type.

**Table headings**

**Metric** - The metric display name as it appears in the Azure portal.
**Name in Rest API** - Metric name as referred to in the [REST API](/azure/azure-monitor/essentials/rest-api-walkthrough).
**Unit** - Unit of measure.
**Aggregation** - The default [aggregation](/azure/azure-monitor/essentials/metrics-aggregation-explained) type. Valid values: Average, Minimum, Maximum, Total, Count.
**Dimensions** - [Dimensions](/azure/azure-monitor/essentials/metrics-aggregation-explained#dimensions-splitting-and-filtering) available for the metric.
**Time Grains** - [Intervals at which the metric is sampled](/azure/azure-monitor/essentials/metrics-aggregation-explained#granularity). For example, `PT1M` indicates that the metric is sampled every minute, `PT30M` every 30 minutes, `PT1H` every hour, and so on.
**DS Export**- Whether the metric is exportable to Azure Monitor Logs via Diagnostic Settings.

For information on exporting metrics, see - [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics) and [Create diagnostic settings in Azure Monitor](/azure/azure-monitor/essentials/create-diagnostic-settings?tabs=portal).

For information on metric retention, see [Azure Monitor Metrics overview](/azure/azure-monitor/essentials/data-platform-metrics#retention-of-metrics).


For a list of supported logs, see [Supported log categories - NGINX.NGINXPLUS/nginxDeployments](../supported-logs/nginx-nginxplus-nginxdeployments-logs.md)


### Category: nginx cache statistics
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Cache bypass bytes**<br><br>The total number of bytes served by bypassing the cache during the aggregation interval. |`plus.cache.bypass.bytes` |Bytes |Total (Sum) |`build`, `version`, `cache_zone`|PT1M |Yes|
|**Cache bypass bytes written**<br><br>The total number of bytes that bypassed the cache and were written back to the cache during the aggregation interval. |`plus.cache.bypass.bytes_written` |Bytes |Total (Sum) |`build`, `version`, `cache_zone`|PT1M |Yes|
|**Cache bypass responses**<br><br>The total number of responses that bypassed the cache during the aggregation interval. |`plus.cache.bypass.responses` |Count |Total (Sum) |`build`, `version`, `cache_zone`|PT1M |Yes|
|**Cache bypass responses written**<br><br>The total number of responses that bypassed the cache and were written back to the cache during the aggregation interval. |`plus.cache.bypass.responses_written` |Count |Total (Sum) |`build`, `version`, `cache_zone`|PT1M |Yes|
|**Cache expired bytes**<br><br>The total number of bytes served from the cache after expiration and refresh from the origin server during the aggregation interval. |`plus.cache.expired.bytes` |Bytes |Total (Sum) |`build`, `version`, `cache_zone`|PT1M |Yes|
|**Cache expired bytes written**<br><br>The total number of bytes written back to the cache after expiration and refresh from the origin server during the aggregation interval. |`plus.cache.expired.bytes_written` |Bytes |Total (Sum) |`build`, `version`, `cache_zone`|PT1M |Yes|
|**Cache expired responses**<br><br>The total number of cache responses that expired and had to be refreshed from the origin server during the aggregation interval. |`plus.cache.expired.responses` |Count |Total (Sum) |`build`, `version`, `cache_zone`|PT1M |Yes|
|**Cache expired responses written**<br><br>The total number of expired cache responses that were refreshed and written back to the cache during the aggregation interval. |`plus.cache.expired.responses_written` |Count |Total (Sum) |`build`, `version`, `cache_zone`|PT1M |Yes|
|**Cache hit bytes**<br><br>The total number of bytes served from the cache during the aggregation interval. |`plus.cache.hit.bytes` |Bytes |Total (Sum) |`build`, `version`, `cache_zone`|PT1M |Yes|
|**Cache hit ratio**<br><br>The average ratio of cache hits to misses during the aggregation interval |`plus.cache.hit.ratio` |Count |Average |`build`, `version`, `cache_zone`|PT1M |Yes|
|**Cache hit responses**<br><br>The total number of responses that were served from the cache during the aggregation interval. |`plus.cache.hit.responses` |Count |Total (Sum) |`build`, `version`, `cache_zone`|PT1M |Yes|
|**Cache max size**<br><br>The max size of the cache during the aggregation interval. |`plus.cache.max_size` |Count |Maximum |`build`, `version`, `cache_zone`|PT1M |Yes|
|**Cache miss bytes**<br><br>The total number of bytes served from the origin server due to cache misses during the aggregation interval. |`plus.cache.miss.bytes` |Bytes |Total (Sum) |`build`, `version`, `cache_zone`|PT1M |Yes|
|**Cache miss responses**<br><br>The total number of responses that were not served from the cache (cache misses) during the aggregation interval. |`plus.cache.miss.responses` |Count |Total (Sum) |`build`, `version`, `cache_zone`|PT1M |Yes|
|**Cache revalidated bytes**<br><br>The total number of bytes served from the cache after successful revalidation with the origin server during the aggregation interval. |`plus.cache.revalidated.bytes` |Bytes |Total (Sum) |`build`, `version`, `cache_zone`|PT1M |Yes|
|**Cache revalidated responses**<br><br>The total number of cache responses that were successfully revalidated with the origin server during the aggregation interval. |`plus.cache.revalidated.responses` |Count |Total (Sum) |`build`, `version`, `cache_zone`|PT1M |Yes|
|**Cache Size**<br><br>The average size of the cache during the aggregation interval. |`plus.cache.size` |Count |Average |`build`, `version`, `cache_zone`|PT1M |Yes|
|**Cache stale bytes**<br><br>The total number of bytes served from stale cache content during the aggregation interval. |`plus.cache.stale.bytes` |Bytes |Total (Sum) |`build`, `version`, `cache_zone`|PT1M |Yes|
|**Cache stale responses**<br><br>The total number of responses served from stale cache content during the aggregation interval. |`plus.cache.stale.responses` |Count |Total (Sum) |`build`, `version`, `cache_zone`|PT1M |Yes|
|**Cache updating bytes**<br><br>The total number of bytes served from the cache while the cache is being updated during the aggregation interval. |`plus.cache.updating.bytes` |Bytes |Total (Sum) |`build`, `version`, `cache_zone`|PT1M |Yes|
|**Cache updating responses**<br><br>The total number of responses served from the cache while the cache is being updated during the aggregation interval. |`plus.cache.updating.responses` |Count |Total (Sum) |`build`, `version`, `cache_zone`|PT1M |Yes|

### Category: nginx connections statistics
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Accepted connections**<br><br>The total number of accepted client connections during the aggregation interval |`nginx.conn.accepted` |Count |Total (Sum) |`build`, `version`|PT1M |Yes|
|**Active connections**<br><br>The total number of active client connections during the aggregation interval |`nginx.conn.active` |Count |Total (Sum) |`build`, `version`|PT1M |Yes|
|**Current connections**<br><br>The total number of active and idle client connections during the aggregation interval |`nginx.conn.current` |Count |Total (Sum) |`build`, `version`|PT1M |Yes|
|**Dropped connections**<br><br>The total number of dropped client connections during the aggregation interval |`nginx.conn.dropped` |Count |Total (Sum) |`build`, `version`|PT1M |Yes|
|**Idle connections**<br><br>The total number of idle client connections during the aggregation interval |`nginx.conn.idle` |Count |Total (Sum) |`build`, `version`|PT1M |Yes|

### Category: nginx requests and response statistics
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**HTTP limit conn passed**<br><br>The total number of connections that were neither limited nor accounted as limited during the aggregation interval |`nginx.http.limit_conns.passed` |Count |Total (Sum) |`build`, `version`, `limit_conn_zone`|PT1M |Yes|
|**HTTP limit conn rejected**<br><br>The total number of connections that were rejected during the aggregation interval |`nginx.http.limit_conns.rejected` |Count |Total (Sum) |`build`, `version`, `limit_conn_zone`|PT1M |Yes|
|**HTTP limit conn rejected dry-run**<br><br>The total number of connections accounted as rejected in the dry run mode during the aggregation interval |`nginx.http.limit_conns.rejected_dry_run` |Count |Total (Sum) |`build`, `version`, `limit_conn_zone`|PT1M |Yes|
|**HTTP limit requests delayed**<br><br>The total number of requests that were delayed during the aggregation interval |`nginx.http.limit_reqs.delayed` |Count |Total (Sum) |`build`, `version`, `limit_req_zone`|PT1M |Yes|
|**HTTP limit requests delayed dry-run**<br><br>The total number of requests accounted as delayed in the dry run mode during the aggregation interval |`nginx.http.limit_reqs.delayed_dry_run` |Count |Total (Sum) |`build`, `version`, `limit_req_zone`|PT1M |Yes|
|**HTTP limit requests passed**<br><br>The total number of requests that were neither limited nor accounted as limited during the aggregation interval |`nginx.http.limit_reqs.passed` |Count |Total (Sum) |`build`, `version`, `limit_req_zone`|PT1M |Yes|
|**HTTP limit requests rejected**<br><br>The total number of requests that were rejected during the aggregation interval |`nginx.http.limit_reqs.rejected` |Count |Total (Sum) |`build`, `version`, `limit_req_zone`|PT1M |Yes|
|**HTTP limit requests rejected dry-run**<br><br>The total number of requests accounted as rejected in the dry run mode during the aggregation interval |`nginx.http.limit_reqs.rejected_dry_run` |Count |Total (Sum) |`build`, `version`, `limit_req_zone`|PT1M |Yes|
|**Total HTTP requests**<br><br>The total number of HTTP requests during the aggregation interval |`nginx.http.request.count` |Count |Total (Sum) |`build`, `version`|PT1M |Yes|
|**Current HTTP requests**<br><br>The number of current requests during the aggregation interval |`nginx.http.request.current` |Count |Total (Sum) |`build`, `version`|PT1M |Yes|
|**Location zone HTTP bytes received**<br><br>The total number of bytes received from clients during the aggregation interval for location zones |`plus.http.location_zone.request.bytes_rcvd` |Bytes |Total (Sum) |`build`, `version`, `location_zone`|PT1M |Yes|
|**Location zone HTTP bytes sent**<br><br>The total number of bytes sent to clients during the aggregation interval for location zones |`plus.http.location_zone.request.bytes_sent` |Bytes |Total (Sum) |`build`, `version`, `location_zone`|PT1M |Yes|
|**Location zone HTTP requests**<br><br>The total number of HTTP requests during the aggregation interval for location zones |`plus.http.location_zone.request.count` |Count |Total (Sum) |`build`, `version`, `location_zone`|PT1M |Yes|
|**Location zone HTTP responses**<br><br>The total number of HTTP responses during the aggregation interval for location zones |`plus.http.location_zone.response.count` |Count |Total (Sum) |`build`, `version`, `location_zone`|PT1M |Yes|
|**Location zone HTTP 1xx responses**<br><br>The total number of HTTP responses with a 1xx status code during the aggregation interval for location zones |`plus.http.location_zone.status.1xx` |Count |Total (Sum) |`build`, `version`, `location_zone`|PT1M |Yes|
|**Location zone HTTP 2xx responses**<br><br>The total number of HTTP responses with a 2xx status code during the aggregation interval for location zones |`plus.http.location_zone.status.2xx` |Count |Total (Sum) |`build`, `version`, `location_zone`|PT1M |Yes|
|**Location zone HTTP 3xx responses**<br><br>The total number of HTTP responses with a 3xx status code during the aggregation interval for location zones |`plus.http.location_zone.status.3xx` |Count |Total (Sum) |`build`, `version`, `location_zone`|PT1M |Yes|
|**Location zone HTTP 4xx responses**<br><br>The total number of HTTP responses with a 4xx status code during the aggregation interval for location zones |`plus.http.location_zone.status.4xx` |Count |Total (Sum) |`build`, `version`, `location_zone`|PT1M |Yes|
|**Location zone HTTP 5xx responses**<br><br>The total number of HTTP responses with a 5xx status code during the aggregation interval for location zones |`plus.http.location_zone.status.5xx` |Count |Total (Sum) |`build`, `version`, `location_zone`|PT1M |Yes|
|**Location zone HTTP status processing**<br><br>The number of client requests that are currently being processed for location zones |`plus.http.location_zone.status.processing` |Count |Average |`build`, `version`, `location_zone`|PT1M |Yes|
|**Server zone HTTP bytes received**<br><br>The total number of bytes received from clients during the aggregation interval for server zones |`plus.http.request.bytes_rcvd` |Bytes |Total (Sum) |`build`, `version`, `server_zone`|PT1M |Yes|
|**Server zone HTTP bytes sent**<br><br>The total number of bytes sent to clients during the aggregation interval for server zones |`plus.http.request.bytes_sent` |Bytes |Total (Sum) |`build`, `version`, `server_zone`|PT1M |Yes|
|**Server zone HTTP requests**<br><br>The total number of HTTP requests during the aggregation interval for server zones |`plus.http.request.count` |Count |Total (Sum) |`build`, `version`, `server_zone`|PT1M |Yes|
|**Server zone HTTP responses**<br><br>The total number of HTTP responses during the aggregation interval for server zones |`plus.http.response.count` |Count |Total (Sum) |`build`, `version`, `server_zone`|PT1M |Yes|
|**Server zone HTTP 1xx responses**<br><br>The total number of HTTP responses with a 1xx status code during the aggregation interval for server zones |`plus.http.status.1xx` |Count |Total (Sum) |`build`, `version`, `server_zone`|PT1M |Yes|
|**Server zone HTTP 2xx responses**<br><br>The total number of HTTP responses with a 2xx status code during the aggregation interval for server zones |`plus.http.status.2xx` |Count |Total (Sum) |`build`, `version`, `server_zone`|PT1M |Yes|
|**Server zone HTTP 3xx responses**<br><br>The total number of HTTP responses with a 3xx status code during the aggregation interval for server zones |`plus.http.status.3xx` |Count |Total (Sum) |`build`, `version`, `server_zone`|PT1M |Yes|
|**Server zone HTTP 4xx responses**<br><br>The total number of HTTP responses with a 4xx status code during the aggregation interval for server zones |`plus.http.status.4xx` |Count |Total (Sum) |`build`, `version`, `server_zone`|PT1M |Yes|
|**Server zone HTTP 5xx responses**<br><br>The total number of HTTP responses with a 5xx status code during the aggregation interval for server zones |`plus.http.status.5xx` |Count |Total (Sum) |`build`, `version`, `server_zone`|PT1M |Yes|
|**Server zone HTTP status processing**<br><br>The number of client requests that are currently being processed for server zones |`plus.http.status.processing` |Count |Average |`build`, `version`, `server_zone`|PT1M |Yes|

### Category: nginx resolver statistics
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Resolve address requests**<br><br>The number of requests to resolve addresses to names during the aggregation interval |`plus.resolvers.requests.addr` |Count |Total (Sum) |`build`, `version`, `resolver_zone`|PT1M |Yes|
|**Resolve name requests**<br><br>The number of requests to resolve names to addresses during the aggregation interval |`plus.resolvers.requests.name` |Count |Total (Sum) |`build`, `version`, `resolver_zone`|PT1M |Yes|
|**Resolve SRV requests**<br><br>The number of requests to resolve SRV records during the aggregation interval |`plus.resolvers.requests.srv` |Count |Total (Sum) |`build`, `version`, `resolver_zone`|PT1M |Yes|
|**FORMERR responses**<br><br>The number of FORMERR (Format error) responses during the aggregation interval |`plus.resolvers.responses.formerr` |Count |Total (Sum) |`build`, `version`, `resolver_zone`|PT1M |Yes|
|**Successful responses**<br><br>The number of successful responses during the aggregation interval |`plus.resolvers.responses.noerror` |Count |Total (Sum) |`build`, `version`, `resolver_zone`|PT1M |Yes|
|**NOTIMP responses**<br><br>The number of NOTIMP (Unimplemented) responses during the aggregation interval |`plus.resolvers.responses.notimp` |Count |Total (Sum) |`build`, `version`, `resolver_zone`|PT1M |Yes|
|**NXDOMAIN responses**<br><br>The number of NXDOMAIN (Host not found) responses during the aggregation interval |`plus.resolvers.responses.nxdomain` |Count |Total (Sum) |`build`, `version`, `resolver_zone`|PT1M |Yes|
|**Refused responses**<br><br>The number of REFUSED (Operation refused) responses during the aggregation interval |`plus.resolvers.responses.refused` |Count |Total (Sum) |`build`, `version`, `resolver_zone`|PT1M |Yes|
|**SERVFAIL responses**<br><br>The number of SERVFAIL (Server failure) responses during the aggregation interval |`plus.resolvers.responses.servfail` |Count |Total (Sum) |`build`, `version`, `resolver_zone`|PT1M |Yes|
|**Timed out requests**<br><br>The number of timed out requests during the aggregation interval |`plus.resolvers.responses.timedout` |Count |Total (Sum) |`build`, `version`, `resolver_zone`|PT1M |Yes|
|**Unknown error responses**<br><br>The number of requests completed with an unknown error during the aggregation interval |`plus.resolvers.responses.unknown` |Count |Total (Sum) |`build`, `version`, `resolver_zone`|PT1M |Yes|

### Category: nginx ssl statistics
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Handshakes failed - timeout**<br><br>The number of SSL handshakes failed because of a timeout during the aggregation interval |`plus.http.ssl.handshake_timeout` |Count |Total (Sum) |`build`, `version`, `server_zone`|PT1M |Yes|
|**HTTP successful SSL handshakes**<br><br>The total number of successful SSL handshakes during the aggregation interval |`plus.http.ssl.handshakes` |Count |Total (Sum) |`build`, `version`, `server_zone`|PT1M |Yes|
|**HTTP failed SSL handshakes**<br><br>The total number of failed SSL handshakes during the aggregation interval |`plus.http.ssl.handshakes.failed` |Count |Total (Sum) |`build`, `version`, `server_zone`|PT1M |Yes|
|**Handshakes failed - no shared cipher**<br><br>The number of SSL handshakes failed because of no shared cipher during the aggregation interval |`plus.http.ssl.no_common_cipher` |Count |Total (Sum) |`build`, `version`, `server_zone`|PT1M |Yes|
|**Handshakes failed - no common protocol**<br><br>The number of SSL handshakes failed because of no common protocol during the aggregation interval |`plus.http.ssl.no_common_protocol` |Count |Total (Sum) |`build`, `version`, `server_zone`|PT1M |Yes|
|**Handshakes failed - certificate rejected**<br><br>The number of failed SSL handshakes when nginx presented the certificate to the client but it was rejected with a corresponding alert message during the aggregation interval |`plus.http.ssl.peer_rejected_cert` |Count |Total (Sum) |`build`, `version`, `server_zone`|PT1M |Yes|
|**HTTP SSL session reuses**<br><br>The total number of session reuses during SSL handshakes in the aggregation interval |`plus.http.ssl.session.reuses` |Count |Total (Sum) |`build`, `version`, `server_zone`|PT1M |Yes|
|**Verify failures - expired cert**<br><br>SSL certificate verification errors - an expired or not yet valid certificate was presented by a client during the aggregation interval |`plus.http.ssl.verify_failures.expired_cert` |Count |Total (Sum) |`build`, `version`, `server_zone`|PT1M |Yes|
|**Verify failures - no certificate**<br><br>SSL certificate verification errors - a client did not provide the required certificate during the aggregation interval |`plus.http.ssl.verify_failures.no_cert` |Count |Total (Sum) |`build`, `version`, `server_zone`|PT1M |Yes|
|**Verify failures - other**<br><br>SSL certificate verification errors - other SSL certificate verification errors during the aggregation interval |`plus.http.ssl.verify_failures.other` |Count |Total (Sum) |`build`, `version`, `server_zone`|PT1M |Yes|
|**Verify failures - revoked cert**<br><br>SSL certificate verification errors - a revoked certificate was presented by a client during the aggregation interval |`plus.http.ssl.verify_failures.revoked_cert` |Count |Total (Sum) |`build`, `version`, `server_zone`|PT1M |Yes|
|**Failed SSL handshakes**<br><br>The total number of failed SSL handshakes during the aggregation interval |`plus.ssl.failed` |Count |Total (Sum) |`build`, `version`|PT1M |Yes|
|**Handshakes failed - timeout**<br><br>The number of SSL handshakes failed because of a timeout during the aggregation interval |`plus.ssl.handshake_timeout` |Count |Total (Sum) |`build`, `version`|PT1M |Yes|
|**Successful SSL handshakes**<br><br>The total number of successful SSL handshakes during the aggregation interval |`plus.ssl.handshakes` |Count |Total (Sum) |`build`, `version`|PT1M |Yes|
|**Handshakes failed - no shared cipher**<br><br>The number of SSL handshakes failed because of no shared cipher during the aggregation interval |`plus.ssl.no_common_cipher` |Count |Total (Sum) |`build`, `version`|PT1M |Yes|
|**Handshakes failed - no common protocol**<br><br>The number of SSL handshakes failed because of no common protocol during the aggregation interval |`plus.ssl.no_common_protocol` |Count |Total (Sum) |`build`, `version`|PT1M |Yes|
|**Handshakes failed - certificate rejected**<br><br>The number of failed SSL handshakes when nginx presented the certificate to the client but it was rejected with a corresponding alert message during the aggregation interval |`plus.ssl.peer_rejected_cert` |Count |Total (Sum) |`build`, `version`|PT1M |Yes|
|**SSL session reuses**<br><br>The total number of session reuses during SSL handshakes in the aggregation interval |`plus.ssl.reuses` |Count |Total (Sum) |`build`, `version`|PT1M |Yes|
|**Cert verify failures - expired cert**<br><br>SSL certificate verification errors - an expired or not yet valid certificate was presented by a client during the aggregation interval |`plus.ssl.verify_failures.expired_cert` |Count |Total (Sum) |`build`, `version`|PT1M |Yes|
|**Cert verify failures - hostname mismatch**<br><br>SSL certificate verification errors - server's certificate doesn't match the hostname during the aggregation interval |`plus.ssl.verify_failures.hostname_mismatch` |Count |Total (Sum) |`build`, `version`|PT1M |Yes|
|**Cert verify failures - no cert**<br><br>SSL certificate verification errors - a client did not provide the required certificate during the aggregation interval |`plus.ssl.verify_failures.no_cert` |Count |Total (Sum) |`build`, `version`|PT1M |Yes|
|**Cert verify failures - other**<br><br>SSL certificate verification errors - other SSL certificate verification errors during the aggregation interval |`plus.ssl.verify_failures.other` |Count |Total (Sum) |`build`, `version`|PT1M |Yes|
|**Cert verify failures - revoked cert**<br><br>SSL certificate verification errors - a revoked certificate was presented by a client during the aggregation interval |`plus.ssl.verify_failures.revoked_cert` |Count |Total (Sum) |`build`, `version`|PT1M |Yes|

### Category: nginx stream statistics
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Connections passed**<br><br>The total number of connections that were neither limited nor accounted as limited |`plus.stream.limit_conns.passed` |Count |Total (Sum) |`build`, `version`, `limit_conn_zone`|PT1M |Yes|
|**Connections rejected**<br><br>The total number of connections that were rejected |`plus.stream.limit_conns.rejected` |Count |Total (Sum) |`build`, `version`, `limit_conn_zone`|PT1M |Yes|
|**Connections rejected dry run**<br><br>The total number of connections accounted as rejected in the dry run mode |`plus.stream.limit_conns.rejected_dry_run` |Count |Total (Sum) |`build`, `version`, `limit_conn_zone`|PT1M |Yes|
|**Request bytes received**<br><br>The total number of bytes received from clients |`plus.stream.request.bytes_rcvd` |Bytes |Total (Sum) |`build`, `version`, `server_zone`|PT1M |Yes|
|**Request bytes sent**<br><br>The total number of bytes sent to clients |`plus.stream.request.bytes_sent` |Bytes |Total (Sum) |`build`, `version`, `server_zone`|PT1M |Yes|
|**SSL handshake failed - timeout**<br><br>The number of SSL handshakes failed because of a timeout during the aggregation interval |`plus.stream.ssl.handshake_timeout` |Count |Total (Sum) |`build`, `version`, `server_zone`|PT1M |Yes|
|**SSL handshakes total**<br><br>The total number of successful SSL handshakes during the aggregation interval |`plus.stream.ssl.handshakes` |Count |Total (Sum) |`build`, `version`, `server_zone`|PT1M |Yes|
|**SSL handshakes failed**<br><br>The total number of failed SSL handshakes during the aggregation interval |`plus.stream.ssl.handshakes.failed` |Count |Total (Sum) |`build`, `version`, `server_zone`|PT1M |Yes|
|**SSL handshake failed - no common cipher**<br><br>The number of SSL handshakes failed because of no shared cipher during the aggregation interval |`plus.stream.ssl.no_common_cipher` |Count |Total (Sum) |`build`, `version`, `server_zone`|PT1M |Yes|
|**SSL HS failed - no common protocol**<br><br>The number of SSL handshakes failed because of no common protocol during the aggregation interval |`plus.stream.ssl.no_common_protocol` |Count |Total (Sum) |`build`, `version`, `server_zone`|PT1M |Yes|
|**SSL handshake failed - rejected cert**<br><br>The number of failed SSL handshakes when nginx presented the certificate to the client but it was rejected with a corresponding alert message during the aggregation interval |`plus.stream.ssl.peer_rejected_cert` |Count |Total (Sum) |`build`, `version`, `server_zone`|PT1M |Yes|
|**SSL session reuses**<br><br>The total number of session reuses during SSL handshakes in the aggregation interval |`plus.stream.ssl.session.reuses` |Count |Total (Sum) |`build`, `version`, `server_zone`|PT1M |Yes|
|**SSL verify failures - expired cert**<br><br>SSL certificate verification errors - an expired or not yet valid certificate was presented by a client during the aggregation interval |`plus.stream.ssl.verify_failures.expired_cert` |Count |Total (Sum) |`build`, `version`, `server_zone`|PT1M |Yes|
|**SSL verify failures - no certificate**<br><br>SSL certificate verification errors - a client did not provide the required certificate during the aggregation interval |`plus.stream.ssl.verify_failures.no_cert` |Count |Total (Sum) |`build`, `version`, `server_zone`|PT1M |Yes|
|**SSL verify failures - other**<br><br>SSL certificate verification errors - other SSL certificate verification errors during the aggregation interval |`plus.stream.ssl.verify_failures.other` |Count |Total (Sum) |`build`, `version`, `server_zone`|PT1M |Yes|
|**SSL verify failures - revoked cert**<br><br>SSL certificate verification errors - a revoked certificate was presented by a client during the aggregation interval |`plus.stream.ssl.verify_failures.revoked_cert` |Count |Total (Sum) |`build`, `version`, `server_zone`|PT1M |Yes|
|**Status 2xx**<br><br>The total number of sessions completed with status codes '2xx' |`plus.stream.status.2xx` |Count |Total (Sum) |`build`, `version`, `server_zone`|PT1M |Yes|
|**Status 4xx**<br><br>The total number of sessions completed with status codes '4xx' |`plus.stream.status.4xx` |Count |Total (Sum) |`build`, `version`, `server_zone`|PT1M |Yes|
|**Status 5xx**<br><br>The total number of sessions completed with status codes '5xx' |`plus.stream.status.5xx` |Count |Total (Sum) |`build`, `version`, `server_zone`|PT1M |Yes|
|**Accepted connections**<br><br>The average number of connections accepted from clients |`plus.stream.status.connections` |Count |Average |`build`, `version`, `server_zone`|PT1M |Yes|
|**Connections discarded**<br><br>The average number of connections completed without creating a session |`plus.stream.status.discarded` |Count |Average |`build`, `version`, `server_zone`|PT1M |Yes|
|**Connections processing**<br><br>The average number of client connections that are currently being processed |`plus.stream.status.processing` |Count |Average |`build`, `version`, `server_zone`|PT1M |Yes|
|**Upstream active connections**<br><br>The current number of connections |`plus.stream.upstream.peers.conn.active` |Count |Total (Sum) |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**Upstream downstart**<br><br>The time when the server became 'unavail', 'checking', or 'unhealthy', in the ISO 8601 format with millisecond resolution |`plus.stream.upstream.peers.downstart` |MilliSeconds |Minimum |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**Upstream downtime**<br><br>Total time the server was in the 'unavail', 'checking', and 'unhealthy' states |`plus.stream.upstream.peers.downtime` |Count |Total (Sum) |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**Upstream fails**<br><br>The total number of unsuccessful attempts to communicate with the server |`plus.stream.upstream.peers.fails` |Count |Total (Sum) |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**Upstream health checks**<br><br>The total number of health check requests made |`plus.stream.upstream.peers.health_checks.checks` |Count |Total (Sum) |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**Upstream health checks fails**<br><br>The number of failed health checks |`plus.stream.upstream.peers.health_checks.fails` |Count |Total (Sum) |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**Upstream last health check pass**<br><br>Boolean indicating whether the last health check request was successful and passed tests |`plus.stream.upstream.peers.health_checks.last_passed` |Count |Minimum |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**Upstream health checks unhealthy**<br><br>How many times the server became unhealthy (state 'unhealthy') |`plus.stream.upstream.peers.health_checks.unhealthy` |Count |Total (Sum) |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**Upstream request bytes received**<br><br>The total number of bytes received from this server |`plus.stream.upstream.peers.request.bytes_rcvd` |Bytes |Total (Sum) |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**Upstream request bytes sent**<br><br>The total number of bytes sent to this server |`plus.stream.upstream.peers.request.bytes_sent` |Bytes |Total (Sum) |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**Upstream response time**<br><br>The average time to receive the last byte of data |`plus.stream.upstream.peers.response.time` |Count |Average |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**Upstream state checking**<br><br>Boolean indicating if any of the upstream servers are being checked |`plus.stream.upstream.peers.state.checking` |Count |Minimum |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**Upstream state down**<br><br>Boolean indicating if any of the upstream servers are down |`plus.stream.upstream.peers.state.down` |Count |Minimum |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**Upstream state draining**<br><br>Boolean indicating if any of the upstream servers are draining |`plus.stream.upstream.peers.state.draining` |Count |Minimum |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**Upstream state unavailable**<br><br>Boolean indicating if any of the upstream servers are unavailable |`plus.stream.upstream.peers.state.unavail` |Count |Minimum |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**Upstream state unhealthy**<br><br>Boolean indicating if any of the upstream servers are unhealthy |`plus.stream.upstream.peers.state.unhealthy` |Count |Minimum |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**Upstream state up**<br><br>Boolean indicating if all upstream servers are up |`plus.stream.upstream.peers.state.up` |Count |Minimum |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**Upstream unavail**<br><br>How many times the server became unavailable for client connections (state 'unavail') due to the number of unsuccessful attempts reaching the max_fails threshold |`plus.stream.upstream.peers.unavail` |Count |Total (Sum) |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**Upstream zombies**<br><br>The current number of servers removed from the group but still processing active client connections |`plus.stream.upstream.zombies` |Count |Average |`build`, `version`|PT1M |Yes|
|**Zone sync bytes in**<br><br>The number of bytes received by all nodes during the aggregation interval |`plus.stream.zone_sync.status.bytes_in` |Bytes |Total (Sum) |`build`, `version`|PT1M |Yes|
|**Zone sync bytes out**<br><br>The number of bytes sent by all nodes during the aggregation interval |`plus.stream.zone_sync.status.bytes_out` |Bytes |Total (Sum) |`build`, `version`|PT1M |Yes|
|**Zone sync messages in**<br><br>The number of messages received by all nodes during the aggregation interval |`plus.stream.zone_sync.status.msgs_in` |Count |Total (Sum) |`build`, `version`|PT1M |Yes|
|**Zone sync messages out**<br><br>The number of messages sent by all nodes during the aggregation interval |`plus.stream.zone_sync.status.msgs_out` |Count |Total (Sum) |`build`, `version`|PT1M |Yes|
|**Zone sync records pending**<br><br>The average number of records that need to be sent to the cluster during the aggregation interval |`plus.stream.zone_sync.zones.records_pending` |Count |Average |`build`, `version`, `shared_memory_zone`|PT1M |Yes|
|**Zone sync records total**<br><br>The average number of records stored in the shared memory zone by all nodes during the aggregation interval |`plus.stream.zone_sync.zones.records_total` |Count |Average |`build`, `version`, `shared_memory_zone`|PT1M |Yes|

### Category: nginx system statistics
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**CPU utilization**<br><br>System CPU Utilization |`system.cpu` |Count |Average |\<none\>|PT1M |Yes|
|**Interface bytes received**<br><br>System Interface Bytes Received |`system.interface.bytes_rcvd` |Bytes |Total (Sum) |`interface`|PT1M |Yes|
|**Interface bytes sent**<br><br>System Interface Bytes Sent |`system.interface.bytes_sent` |Bytes |Total (Sum) |`interface`|PT1M |Yes|
|**Interface egress throughput**<br><br>System Interface Egress Throughput, i.e. bytes sent per second |`system.interface.egress_throughput` |BytesPerSecond |Total (Sum) |`interface`|PT1M |Yes|
|**Interface packets received**<br><br>System Interface Packets Received |`system.interface.packets_rcvd` |Count |Total (Sum) |`interface`|PT1M |Yes|
|**Interface packets sent**<br><br>System Interface Packets Sent |`system.interface.packets_sent` |Count |Total (Sum) |`interface`|PT1M |Yes|
|**Interface total bytes**<br><br>System Interface Total Bytes, sum of bytes_sent and bytes_rcvd |`system.interface.total_bytes` |Bytes |Total (Sum) |`interface`|PT1M |Yes|

### Category: nginx upstream statistics
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Upstream keepalive connections**<br><br>The current number of idle keepalive connections |`plus.http.upstream.keepalives` |Count |Total (Sum) |`build`, `version`|PT1M |Yes|
|**Upstream active connections**<br><br>The number of active client connections during the aggregation interval |`plus.http.upstream.peers.conn.active` |Count |Total (Sum) |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**Upstream total connections**<br><br>The total number of client connections forwarded to this server during the aggregation interval |`plus.http.upstream.peers.connections` |Count |Total (Sum) |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**Upstream server downstart**<br><br>The time when the server became 'unavail', 'checking', or 'unhealthy', as a UTC timestamp |`plus.http.upstream.peers.downstart` |Count |Minimum |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**Upstream server fails**<br><br>The total number of unsuccessful attempts to communicate with the server during the aggregation interval |`plus.http.upstream.peers.fails` |Count |Total (Sum) |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**Upstream server header time**<br><br>The average time to get the response header from the server |`plus.http.upstream.peers.header.time` |Count |Average |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**Upstream server health checks**<br><br>The total number of health check requests made during the aggregation interval |`plus.http.upstream.peers.health_checks.checks` |Count |Total (Sum) |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**Upstream server health checks fails**<br><br>The number of failed health checks during the aggregation interval |`plus.http.upstream.peers.health_checks.fails` |Count |Total (Sum) |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**Upstream server health checks last pass**<br><br>Indicating if the last health check request was successful and passed tests |`plus.http.upstream.peers.health_checks.last_passed` |Count |Minimum |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**Upstream server health checks unhealthy**<br><br>How many times the server became unhealthy (state 'unhealthy') during the aggregation interval |`plus.http.upstream.peers.health_checks.unhealthy` |Count |Total (Sum) |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**Upstream server request bytes received**<br><br>The total number of bytes received in HTTP requests during the aggregation interval |`plus.http.upstream.peers.request.bytes_rcvd` |Bytes |Total (Sum) |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**Upstream server request bytes sent**<br><br>The total number of bytes sent in HTTP requests during the aggregation interval |`plus.http.upstream.peers.request.bytes_sent` |Bytes |Total (Sum) |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**Upstream HTTP requests**<br><br>The total number of HTTP requests during the aggregation interval |`plus.http.upstream.peers.request.count` |Count |Total (Sum) |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**Upstream server HTTP responses**<br><br>The total number of HTTP responses during the aggregation interval |`plus.http.upstream.peers.response.count` |Count |Total (Sum) |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**Upstream server response time**<br><br>The average time to get the full response from the server during the aggregation interval |`plus.http.upstream.peers.response.time` |Count |Average |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**Upstream SSL handshake timeout**<br><br>The number of SSL handshakes failed because of a timeout during the aggregation interval |`plus.http.upstream.peers.ssl.handshake_timeout` |Count |Total (Sum) |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**Upstream SSL handshakes**<br><br>The total number of successful SSL handshakes during the aggregation interval |`plus.http.upstream.peers.ssl.handshakes` |Count |Total (Sum) |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**Upstream SSL handshakes failed**<br><br>The total number of failed SSL handshakes during the aggregation interval |`plus.http.upstream.peers.ssl.handshakes.failed` |Count |Total (Sum) |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**Upstream SSL no common protocol**<br><br>The number of SSL handshakes failed because of no common protocol during the aggregation interval |`plus.http.upstream.peers.ssl.no_common_protocol` |Count |Total (Sum) |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**SSL handshake failed - rejected cert**<br><br>The number of failed SSL handshakes when nginx presented the certificate to the client but it was rejected with a corresponding alert message during the aggregation interval |`plus.http.upstream.peers.ssl.peer_rejected_cert` |Count |Total (Sum) |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**Upstream SSL session reuses**<br><br>The total number of session reuses during SSL handshake in the aggregation interval |`plus.http.upstream.peers.ssl.session.reuses` |Count |Total (Sum) |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**SSL verify failures - expired cert**<br><br>SSL certificate verification errors - an expired or not yet valid certificate was presented by a client during the aggregation interval |`plus.http.upstream.peers.ssl.verify_failures.expired_cert` |Count |Total (Sum) |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**SSL verify failures - hostname mismatch**<br><br>SSL certificate verification errors - server's certificate doesn't match the hostname during the aggregation interval |`plus.http.upstream.peers.ssl.verify_failures.hostname_mismatch` |Count |Total (Sum) |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**SSL verify failures - other**<br><br>SSL certificate verification errors - other SSL certificate verification errors during the aggregation interval |`plus.http.upstream.peers.ssl.verify_failures.other` |Count |Total (Sum) |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**SSL verify failures - revoked cert**<br><br>SSL certificate verification errors - a revoked certificate was presented by a client during the aggregation interval |`plus.http.upstream.peers.ssl.verify_failures.revoked_cert` |Count |Total (Sum) |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**Upstream server state checking**<br><br>Current state of upstream servers in deployment. If any of the upstream servers in the deployment is being checked then the value will be 1. If no upstream server is being checked then the value will be 0 |`plus.http.upstream.peers.state.checking` |Count |Maximum |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**Upstream server state down**<br><br>Current state of upstream servers in deployment. If any of the upstream servers in the deployment are down, then the value will be 1. If no upstream server is down, then the value will be 0 |`plus.http.upstream.peers.state.down` |Count |Maximum |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**Upstream server state draining**<br><br>Current state of upstream servers in deployment. If any of the upstream servers in the deployment are draining, then the value will be 1. If no upstream server is draining, then the value will be 0 |`plus.http.upstream.peers.state.draining` |Count |Maximum |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**Upstream server state unavailable**<br><br>Current state of upstream servers in deployment. If any of the upstream servers in the deployment are unavailable, then the value will be 1. If no upstream server is unavailable, then the value will be 0 |`plus.http.upstream.peers.state.unavail` |Count |Maximum |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**Upstream server state unhealthy**<br><br>Current state of upstream servers in deployment. If any of the upstream servers in the deployment are unhealthy then the value will be 1. If no upstream server is unhealthy then the value will be 0 |`plus.http.upstream.peers.state.unhealthy` |Count |Maximum |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**Upstream server state up**<br><br>Current state of upstream servers in deployment. If all upstream servers in the deployment are up, then the value will be 1. If any upstream server is not up, then the value will be 0 |`plus.http.upstream.peers.state.up` |Count |Minimum |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**Upstream server HTTP 1xx responses**<br><br>The total number of HTTP responses with a 1xx status code during the aggregation interval |`plus.http.upstream.peers.status.1xx` |Count |Total (Sum) |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**Upstream server HTTP 2xx responses**<br><br>The total number of HTTP responses with a 2xx status code during the aggregation interval |`plus.http.upstream.peers.status.2xx` |Count |Total (Sum) |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**Upstream server HTTP 3xx responses**<br><br>The total number of HTTP responses with a 3xx status code during the aggregation interval |`plus.http.upstream.peers.status.3xx` |Count |Total (Sum) |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**Upstream server HTTP 4xx responses**<br><br>The total number of HTTP responses with a 4xx status code during the aggregation interval |`plus.http.upstream.peers.status.4xx` |Count |Total (Sum) |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**Upstream server HTTP 5xx responses**<br><br>The total number of HTTP responses with a 5xx status code during the aggregation interval |`plus.http.upstream.peers.status.5xx` |Count |Total (Sum) |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**Upstream server unavailable**<br><br>The number of times the server became unavailable for client requests (state 'unavail') due to the number of unsuccessful attempts reaching the max_fails threshold during the aggregation interval |`plus.http.upstream.peers.unavail` |Count |Total (Sum) |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**Upstream queue max size**<br><br>The maximum number of requests that can be in the queue at the same time |`plus.http.upstream.queue.maxsize` |Count |Average |`build`, `version`|PT1M |Yes|
|**Upstream queue overflows**<br><br>The total number of requests rejected due to the queue overflow |`plus.http.upstream.queue.overflows` |Count |Total (Sum) |`build`, `version`|PT1M |Yes|
|**Upstream queue size**<br><br>The current number of requests in the queue |`plus.http.upstream.queue.size` |Count |Average |`build`, `version`|PT1M |Yes|
|**Upstream zombies**<br><br>The current number of servers removed from the group but still processing active client requests |`plus.http.upstream.zombies` |Count |Average |`build`, `version`|PT1M |Yes|
|**Stream SSL handshake timeout**<br><br>The number of SSL handshakes failed because of a timeout during the aggregation interval |`plus.stream.upstream.peers.ssl.handshake_timeout` |Count |Total (Sum) |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**Stream SSL handshakes total**<br><br>The total number of successful SSL handshakes during the aggregation interval |`plus.stream.upstream.peers.ssl.handshakes` |Count |Total (Sum) |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**Stream SSL handshakes failed**<br><br>The total number of failed SSL handshakes during the aggregation interval |`plus.stream.upstream.peers.ssl.handshakes.failed` |Count |Total (Sum) |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**Stream HS failed - no common protocol**<br><br>The number of SSL handshakes failed because of no common protocol during the aggregation interval |`plus.stream.upstream.peers.ssl.no_common_protocol` |Count |Total (Sum) |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**Stream verify failure - rejected cert**<br><br>The number of failed SSL handshakes when nginx presented the certificate to the client but it was rejected with a corresponding alert message during the aggregation interval |`plus.stream.upstream.peers.ssl.peer_rejected_cert` |Count |Total (Sum) |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**Stream SSL session reuses**<br><br>The total number of session reuses during SSL handshake in the aggregation interval |`plus.stream.upstream.peers.ssl.session.reuses` |Count |Total (Sum) |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**Stream verify failure - expired cert**<br><br>SSL certificate verification errors - an expired or not yet valid certificate was presented by a client during the aggregation interval |`plus.stream.upstream.peers.ssl.verify_failures.expired_cert` |Count |Total (Sum) |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**Stream verify failure hostname mismatch**<br><br>SSL certificate verification errors - server's certificate doesn't match the hostname during the aggregation interval |`plus.stream.upstream.peers.ssl.verify_failures.hostname_mismatch` |Count |Total (Sum) |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**Stream SSL verify failure - other**<br><br>SSL certificate verification errors - other SSL certificate verification errors during the aggregation interval |`plus.stream.upstream.peers.ssl.verify_failures.other` |Count |Total (Sum) |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|
|**Stream verify failure - revoked cert**<br><br>SSL certificate verification errors - a revoked certificate was presented by a client during the aggregation interval |`plus.stream.upstream.peers.ssl.verify_failures.revoked_cert` |Count |Total (Sum) |`build`, `version`, `upstream`, `peer.address`, `peer.name`|PT1M |Yes|

### Category: nginx worker statistics
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Worker connections accepted**<br><br>The total number of client connections accepted by the worker process during the aggregation interval |`plus.worker.conn.accepted` |Count |Total (Sum) |`build`, `version`, `worker_id`|PT1M |Yes|
|**Active worker connections**<br><br>The current number of active client connections that are currently being handled by the worker process during the aggregation interval |`plus.worker.conn.active` |Count |Total (Sum) |`build`, `version`, `worker_id`|PT1M |Yes|
|**Worker connections dropped**<br><br>The total number of client connections dropped by the worker process during the aggregation interval |`plus.worker.conn.dropped` |Count |Total (Sum) |`build`, `version`, `worker_id`|PT1M |Yes|
|**Idle worker connections**<br><br>The number of idle client connections that are currently being handled by the worker process during the aggregation interval |`plus.worker.conn.idle` |Count |Total (Sum) |`build`, `version`, `worker_id`|PT1M |Yes|
|**Current worker HTTP requests**<br><br>The current number of client requests that are currently being processed by the worker process during the aggregation interval |`plus.worker.http.request.current` |Count |Total (Sum) |`build`, `version`, `worker_id`|PT1M |Yes|
|**Total worker HTTP requests**<br><br>The total number of client requests received by the worker process during the aggregation interval |`plus.worker.http.request.total` |Count |Total (Sum) |`build`, `version`, `worker_id`|PT1M |Yes|

### Category: nginxaas statistics
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**NCU provisioned**<br><br>The number of successfully provisioned NCUs during the aggregation interval. During scaling events, this may lag behind ncu.requested as the system works to achieve the request. Available for Standard plan deployments |`ncu.provisioned` |Count |Total (Sum) |\<none\>|PT1M |Yes|
|**NCU requested**<br><br>The requested number of NCUs during the aggregation interval. Describes the goal state of the system. Available for Standard plan deployments |`ncu.requested` |Count |Total (Sum) |\<none\>|PT1M |Yes|
|**NGINXaaS capacity percentage**<br><br>The percentage of the deployment's total capacity being used. This may burst above 100%. Available for Standard plan deployments |`nginxaas.capacity.percentage` |Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Certificates**<br><br>The number of certificates added to the NGINXaaS deployment dimensioned by the name of the certificate and its status |`nginxaas.certificates` |Count |Total (Sum) |`name`, `status`|PT1M |Yes|
|**Maxmind status**<br><br>The status of any MaxMind license in use for downloading geoip2 databases. Refer to License Health to learn more about the status dimension |`nginxaas.maxmind` |Count |Total (Sum) |`status`|PT1M |Yes|
|**Ports used**<br><br>The number of listen ports used by the deployment during the aggregation interval. |`ports.used` |Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Listener backlog length**<br><br>The length of listener backlog during the aggregation interval. This represents the number of pending connections in the queue at any given time. |`system.listener_backlog.length` |Count |Total (Sum) |`listen_address`, `file_desc`|PT1M |Yes|
|**Max listener backlog**<br><br>The max listener backlog during the aggregation interval. The number of incoming connections that can be queued by the operating system before NGINX accepts and processes them. |`system.listener_backlog.max` |Count |Maximum |`listen_addr`, `file_desc`|PT1M |Yes|
|**Listener backlog queue limit**<br><br>The queue limit for listener backlog during the aggregation interval. This indicates the maximum number of pending connections that can be queued for a specific listener before the server starts refusing new connections. |`system.listener_backlog.queue_limit` |Count |Total (Sum) |`listen_address`, `file_desc`|PT1M |Yes|
|**Worker connections**<br><br>The number of nginx worker connections used on the dataplane. This metric is one of the factors which determines the deployment's consumed NCU value |`system.worker_connections` |Count |Total (Sum) |`pid`, `process_name`|PT1M |Yes|
|**Web application firewall enabled**<br><br>Current status of Web Application Firewall on the deployment. |`waf.enabled` |Count |Total (Sum) |\<none\>|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
