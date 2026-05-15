---
title: Supported metrics - Microsoft.DocumentDB/cassandraClusters
description: Reference for Microsoft.DocumentDB/cassandraClusters metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.DocumentDB/cassandraClusters, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.DocumentDB/cassandraClusters

The following table lists the metrics available for the Microsoft.DocumentDB/cassandraClusters resource type.

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


For a list of supported logs, see [Supported log categories - Microsoft.DocumentDB/cassandraClusters](../supported-logs/microsoft-documentdb-cassandraclusters-logs.md)


### Category: Cassandra Cache
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**cache capacity**<br><br>Cache capacity (bytes). |`cassandra_cache_capacity` |Bytes |Average, Minimum, Maximum, Count |`cassandra_datacenter`, `cassandra_node`, `cache_name`|PT1M |No|
|**cache entries**<br><br>Total number of cache entries. |`cassandra_cache_entries` |Count |Average, Minimum, Maximum, Count |`cassandra_datacenter`, `cassandra_node`, `cache_name`|PT1M |No|
|**cache hit rate**<br><br>All time cache hit rate. |`cassandra_cache_hit_rate` |Percent |Average |`cassandra_datacenter`, `cassandra_node`, `cache_name`|PT1M |No|
|**cache hits**<br><br>Number of cache hits. |`cassandra_cache_hits` |Count |Average, Minimum, Maximum, Count |`cassandra_datacenter`, `cassandra_node`, `cache_name`|PT1M |No|
|**cache miss latency average (microseconds)**<br><br>Average cache miss latency (microseconds). |`cassandra_cache_miss_latency_histogram` |Count |Average |`cassandra_datacenter`, `cassandra_node`, `quantile`|PT1M |No|
|**cache miss latency p99 (microseconds)**<br><br>p99 latency of misses. |`cassandra_cache_miss_latency_p99` |Count |Average |`cassandra_datacenter`, `cassandra_node`, `cache_name`|PT1M |No|
|**cache requests**<br><br>Number of cache requests. |`cassandra_cache_requests` |Count |Average, Minimum, Maximum, Count |`cassandra_datacenter`, `cassandra_node`, `cache_name`|PT1M |No|
|**occupied cache size**<br><br>Size of occupied cache (bytes). |`cassandra_cache_size` |Bytes |Average, Minimum, Maximum, Count |`cassandra_datacenter`, `cassandra_node`, `cache_name`|PT1M |No|

### Category: Cassandra Client
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**auth failure (deprecated)**<br><br>Number of failed client authentication requests. |`cassandra_client_auth_failure` |Count |Total (Sum) |`cassandra_datacenter`, `cassandra_node`|PT1M |No|
|**auth failure (deprecated)**<br><br>Number of failed client authentication requests. |`cassandra_client_auth_failure2` |Count |Total (Sum) |`cassandra_datacenter`, `cassandra_node`|PT1M |No|
|**client auth failure**<br><br>Number of failed client authentication requests. |`cassandra_client_auth_failure3` |Count |Average, Minimum, Maximum, Count |`cassandra_datacenter`, `cassandra_node`|PT1M |No|
|**client auth success**<br><br>Number of successful client authentication requests. |`cassandra_client_auth_success` |Count |Average, Minimum, Maximum, Count |`cassandra_datacenter`, `cassandra_node`|PT1M |No|
|**connected native clients**<br><br>Number of connected native clients. |`cassandra_client_connected_native_clients` |Count |Average, Minimum, Maximum, Count |`cassandra_datacenter`, `cassandra_node`|PT1M |No|

### Category: Cassandra Client Request
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**condition not met**<br><br>Cumulative number of transaction preconditions did not match current values. |`cassandra_client_request_condition_not_met` |Count |Average, Minimum, Maximum, Count |`cassandra_datacenter`, `cassandra_node`, `request_type`|PT1M |No|
|**contention average**<br><br>How many contended reads/writes were encountered in average. |`cassandra_client_request_contention_histogram` |Count |Average |`cassandra_datacenter`, `cassandra_node`, `request_type`|PT1M |No|
|**contention p99**<br><br>p99 how many contended writes were encountered. |`cassandra_client_request_contention_histogram_p99` |Count |Average |`cassandra_datacenter`, `cassandra_node`, `request_type`|PT1M |No|
|**failures (deprecated)**<br><br>Number of transaction failures encountered. |`cassandra_client_request_failures` |Count |Total (Sum) |`cassandra_datacenter`, `cassandra_node`, `request_type`|PT1M |No|
|**failures (deprecated)**<br><br>Number of transaction failures encountered. |`cassandra_client_request_failures2` |Count |Total (Sum) |`cassandra_datacenter`, `cassandra_node`, `request_type`|PT1M |No|
|**client failures**<br><br>Cumulative number of transaction failures encountered. |`cassandra_client_request_failures3` |Count |Average, Minimum, Maximum, Count |`cassandra_datacenter`, `cassandra_node`, `request_type`|PT1M |No|
|**client request latency average (microseconds)**<br><br>Average client request latency (microseconds). |`cassandra_client_request_latency_histogram` |Count |Average |`cassandra_datacenter`, `cassandra_node`, `quantile`, `request_type`|PT1M |No|
|**client request latency max (microseconds)**<br><br>Maximum client request latency (microseconds). |`cassandra_client_request_latency_max` |Count |Maximum |`ClusterResourceName`, `DataCenterResourceName`, `Address`, `request_type`|PT1M |No|
|**client request latency p99 (microseconds)**<br><br>p99 client request latency (microseconds). |`cassandra_client_request_latency_p99` |Count |Average |`cassandra_datacenter`, `cassandra_node`, `request_type`|PT1M |No|
|**timeouts (deprecated)**<br><br>Number of timeouts encountered. |`cassandra_client_request_timeouts` |Count |Total (Sum) |`cassandra_datacenter`, `cassandra_node`, `request_type`|PT1M |No|
|**timeouts (deprecated)**<br><br>Number of timeouts encountered. |`cassandra_client_request_timeouts2` |Count |Total (Sum) |`cassandra_datacenter`, `cassandra_node`, `request_type`|PT1M |No|
|**client timeouts**<br><br>Cumulative number of timeouts encountered in client requests. |`cassandra_client_request_timeouts3` |Count |Average, Minimum, Maximum, Count |`cassandra_datacenter`, `cassandra_node`, `request_type`|PT1M |No|
|**unfinished commit**<br><br>Cumulative number of transactions that were committed on write. |`cassandra_client_request_unfinished_commit` |Count |Average, Minimum, Maximum, Count |`cassandra_datacenter`, `cassandra_node`, `request_type`|PT1M |No|

### Category: Cassandra CommitLog
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Commit latency on waiting average (microseconds).**<br><br>Average time spent waiting on CL fsync (microseconds); for Periodic this is only occurs when the sync is lagging its sync interval. |`cassandra_commit_log_waiting_on_commit_latency_histogram` |Count |Average |`cassandra_datacenter`, `cassandra_node`, `quantile`|PT1M |No|

### Category: Cassandra CQL
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**prepared statements executed**<br><br>Total number of prepared statements executed. |`cassandra_cql_prepared_statements_executed` |Count |Average, Minimum, Maximum, Count |`cassandra_datacenter`, `cassandra_node`|PT1M |No|
|**regular statements executed**<br><br>Total number of non prepared statements executed. |`cassandra_cql_regular_statements_executed` |Count |Average, Minimum, Maximum, Count |`cassandra_datacenter`, `cassandra_node`|PT1M |No|

### Category: Cassandra DroppedMessage
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**dropped messages count**<br><br>Total count of dropped messages. |`cassandra_dropped_message_count` |Count |Average, Minimum, Maximum, Count |`cassandra_datacenter`, `cassandra_node`, `message_type`|PT1M |No|
|**cross-node dropped latency**<br><br>Average dropped latency across nodes. |`cassandra_dropped_message_cross_node_latency` |MilliSeconds |Average, Minimum, Maximum, Count |`cassandra_datacenter`, `cassandra_node`, `message_type`|PT1M |No|
|**cross-node dropped latency p99**<br><br>99th percentile of dropped latency across nodes. |`cassandra_dropped_message_cross_node_latency_p99` |MilliSeconds |Average, Minimum, Maximum, Count |`cassandra_datacenter`, `cassandra_node`, `message_type`|PT1M |No|
|**internal dropped latency**<br><br>Average dropped latency within node. |`cassandra_dropped_message_internal_latency` |MilliSeconds |Average, Minimum, Maximum, Count |`cassandra_datacenter`, `cassandra_node`, `message_type`|PT1M |No|
|**dropped messages rate**<br><br>Rate of dropped messages. |`cassandra_dropped_message_rate` |Count |Average, Minimum, Maximum, Count |`cassandra_datacenter`, `cassandra_node`, `message_type`|PT1M |No|

### Category: Cassandra HintsService
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**hints failed rate**<br><br>Rate of the hints that failed deliver. |`cassandra_hints_failed_rate` |Count |Average, Minimum, Maximum, Count |`cassandra_datacenter`, `cassandra_node`|PT1M |No|
|**hints succeeded rate**<br><br>Rate of the hints successfully delivered. |`cassandra_hints_succeeded_rate` |Count |Average, Minimum, Maximum, Count |`cassandra_datacenter`, `cassandra_node`|PT1M |No|
|**hints timed out rate**<br><br>Rate of the hints that timed out. |`cassandra_hints_timed_out_rate` |Count |Average, Minimum, Maximum, Count |`cassandra_datacenter`, `cassandra_node`|PT1M |No|

### Category: Cassandra JVM
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**jvm gc count**<br><br>Total number of collections that have occurred. |`cassandra_jvm_gc_count` |Count |Average, Minimum, Maximum, Count |`cassandra_datacenter`, `cassandra_node`|PT1M |No|
|**jvm gc time**<br><br>Approximate accumulated collection elapsed time. |`cassandra_jvm_gc_time` |MilliSeconds |Average, Minimum, Maximum, Count |`cassandra_datacenter`, `cassandra_node`|PT1M |No|

### Category: Cassandra Storage
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**total hints**<br><br>Cumulative number of total hints in storage. |`cassandra_storage_total_hints_counter_total` |Count |Average, Minimum, Maximum, Count |`cassandra_datacenter`, `cassandra_node`|PT1M |No|
|**total hints in progress**<br><br>Number of total hints in progress. |`cassandra_storage_total_hints_in_progress_counter_total` |Count |Average, Minimum, Maximum, Count |`cassandra_datacenter`, `cassandra_node`|PT1M |No|

### Category: Cassandra Table
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**all memtables live data size**<br><br>Total amount of live data stored in the memtables (2i and pending flush memtables included) that resides off-heap, excluding any data structure overhead. |`cassandra_table_all_memtables_live_data_size` |Bytes |Average, Minimum, Maximum, Count |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**all memtables off heap size**<br><br>Total amount of data stored in the memtables (2i and pending flush memtables included) that resides off-heap. |`cassandra_table_all_memtables_off_heap_size` |Bytes |Average, Minimum, Maximum, Count |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**bloom filter disk space used**<br><br>Disk space used by bloom filter (bytes). |`cassandra_table_bloom_filter_disk_space_used` |Bytes |Average, Minimum, Maximum, Count |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**bloom filter false positives**<br><br>Number of false positives on table's bloom filter. |`cassandra_table_bloom_filter_false_positives` |Count |Average, Minimum, Maximum, Count |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**bloom filter false ratio**<br><br>False positive ratio of table's bloom filter. |`cassandra_table_bloom_filter_false_ratio` |Percent |Average, Minimum, Maximum, Count |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**bloom filter off-heap memory used**<br><br>Off-heap memory used by bloom filter. |`cassandra_table_bloom_filter_off_heap_memory_used` |Bytes |Average, Minimum, Maximum, Count |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**bytes flushed**<br><br>Total number of bytes flushed since server [re]start. |`cassandra_table_bytes_flushed` |Bytes |Average, Minimum, Maximum, Count |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**cas commit average (microseconds)**<br><br>Average latency of paxos commit round. |`cassandra_table_cas_commit` |Count |Average |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**cas commit p99 (microseconds)**<br><br>p99 latency of paxos commit round. |`cassandra_table_cas_commit_p99` |Count |Average |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**cas prepare average (microseconds)**<br><br>Average latency of paxos prepare round. |`cassandra_table_cas_prepare` |Count |Average |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**cas prepare p99 (microseconds)**<br><br>p99 latency of paxos prepare round. |`cassandra_table_cas_prepare_p99` |Count |Average |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**cas propose average (microseconds)**<br><br>Average latency of paxos propose round. |`cassandra_table_cas_propose` |Count |Average |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**cas propose p99 (microseconds)**<br><br>p99 latency of paxos propose round. |`cassandra_table_cas_propose_p99` |Count |Average |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**col update time delta average**<br><br>Average column update time delta on this table. |`cassandra_table_col_update_time_delta_histogram` |Count |Average |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**col update time delta p99**<br><br>p99 column update time delta on this table. |`cassandra_table_col_update_time_delta_histogram_p99` |Count |Average |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**compaction bytes written**<br><br>Total number of bytes written by compaction since server [re]start. |`cassandra_table_compaction_bytes_written` |Bytes |Average, Minimum, Maximum, Count |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**compression metadata off-heap memory used**<br><br>Off-heap memory used by compression metadata. |`cassandra_table_compression_metadata_off_heap_memory_used` |Bytes |Average, Minimum, Maximum, Count |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**compression ratio**<br><br>Current compression ratio for all SSTables. |`cassandra_table_compression_ratio` |Percent |Average, Minimum, Maximum, Count |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**coordinator read latency average (microseconds)**<br><br>Average coordinator read latency for this table. |`cassandra_table_coordinator_read_latency` |Count |Average |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**coordinator read latency p99 (microseconds)**<br><br>p99 coordinator read latency for this table. |`cassandra_table_coordinator_read_latency_p99` |Count |Average |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**coordinator scan latency average (microseconds)**<br><br>Average coordinator range scan latency for this table. |`cassandra_table_coordinator_scan_latency` |Count |Average |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**coordinator scan latency p99 (microseconds)**<br><br>p99 coordinator range scan latency for this table. |`cassandra_table_coordinator_scan_latency_p99` |Count |Average |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**dropped mutations (deprecated)**<br><br>Number of dropped mutations on this table. |`cassandra_table_dropped_mutations` |Count |Total (Sum) |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**dropped mutations (deprecated)**<br><br>Number of dropped mutations on this table. |`cassandra_table_dropped_mutations2` |Count |Total (Sum) |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**dropped mutations**<br><br>Total number of dropped mutations on this table. |`cassandra_table_dropped_mutations3` |Count |Average, Minimum, Maximum, Count |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**estimated column count average**<br><br>Estimated number of columns in average. |`cassandra_table_estimated_column_count_histogram` |Count |Average |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**estimated column count p99**<br><br>p99 estimated number of columns. |`cassandra_table_estimated_column_count_histogram_p99` |Count |Average |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**estimated partition count**<br><br>Approximate number of keys in table. |`cassandra_table_estimated_partition_count` |Count |Average, Minimum, Maximum, Count |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**estimated partition size average**<br><br>Estimated partition size in average. |`cassandra_table_estimated_partition_size_histogram` |Bytes |Average |`cassandra_datacenter`, `cassandra_node`, `quantile`, `table`, `keyspace`|PT1M |No|
|**estimated partition size p99**<br><br>p99 estimated partition size (bytes). |`cassandra_table_estimated_partition_size_histogram_p99` |Bytes |Average |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**index summary off-heap memory used**<br><br>Off-heap memory used by index summary. |`cassandra_table_index_summary_off_heap_memory_used` |Bytes |Average, Minimum, Maximum, Count |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**key cache hit rate**<br><br>Key cache hit rate for this table. |`cassandra_table_key_cache_hit_rate` |Percent |Average |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**live disk space used**<br><br>Disk space used by SSTables belonging to this table (bytes). |`cassandra_table_live_disk_space_used` |Bytes |Average, Minimum, Maximum, Count |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**live scanned average**<br><br>Average live cells scanned in queries on this table. |`cassandra_table_live_scanned_histogram` |Count |Average |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**live scanned p99**<br><br>p99 live cells scanned in queries on this table. |`cassandra_table_live_scanned_histogram_p99` |Count |Average |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**live sstable count**<br><br>Number of SSTables on disk for this table. |`cassandra_table_live_sstable_count` |Count |Average, Minimum, Maximum, Count |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**max partition size**<br><br>Size of the largest compacted partition (bytes). |`cassandra_table_max_partition_size` |Bytes |Maximum |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**mean partition size**<br><br>Size of the average compacted partition (bytes). |`cassandra_table_mean_partition_size` |Bytes |Average |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**memtable columns count**<br><br>Total number of columns present in the memtable. |`cassandra_table_memtable_columns_count` |Count |Average, Minimum, Maximum, Count |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**memtable off heap size**<br><br>Total amount of data stored in the memtable that resides off-heap, including column related overhead and partitions overwritten. |`cassandra_table_memtable_off_heap_size` |Bytes |Average, Minimum, Maximum, Count |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**memtable on heap size**<br><br>Total amount of data stored in the memtable that resides on-heap, including column related overhead and partitions overwritten. |`cassandra_table_memtable_on_heap_size` |Bytes |Average, Minimum, Maximum, Count |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**memtable switch count**<br><br>Number of times flush has resulted in the memtable being switched out. |`cassandra_table_memtable_switch_count` |Count |Average, Minimum, Maximum, Count |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**min partition size**<br><br>Size of the smallest compacted partition (bytes). |`cassandra_table_min_partition_size` |Bytes |Minimum |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**pending compactions (deprecated)**<br><br>Estimate of number of pending compactions for this table. |`cassandra_table_pending_compactions` |Count |Total (Sum) |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**pending compactions (deprecated)**<br><br>Estimate of number of pending compactions for this table. |`cassandra_table_pending_compactions2` |Count |Total (Sum) |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**pending compactions**<br><br>Estimate of number of pending compactions for this table. |`cassandra_table_pending_compactions3` |Count |Average, Minimum, Maximum, Count |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**pending flushes (deprecated)**<br><br>Estimated number of flush tasks pending for this table. |`cassandra_table_pending_flushes` |Count |Total (Sum) |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**pending flushes (deprecated)**<br><br>Estimated number of flush tasks pending for this table. |`cassandra_table_pending_flushes2` |Count |Total (Sum) |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**pending flushes**<br><br>Estimated number of flush tasks pending for this table. |`cassandra_table_pending_flushes3` |Count |Average, Minimum, Maximum, Count |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**percent repaired**<br><br>Percent of table data that is repaired on disk. |`cassandra_table_percent_repaired` |Percent |Average |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**range latency average (microseconds)**<br><br>Average local range scan latency for this table. |`cassandra_table_range_latency` |Count |Average |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**range latency p99 (microseconds)**<br><br>p99 local range scan latency for this table. |`cassandra_table_range_latency_p99` |Count |Average |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**read latency average (microseconds)**<br><br>Average local read latency for this table. |`cassandra_table_read_latency` |Count |Average |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**read latency p99 (microseconds)**<br><br>p99 local read latency for this table. |`cassandra_table_read_latency_p99` |Count |Average |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**row cache hit**<br><br>Number of table row cache hits. |`cassandra_table_row_cache_hit` |Count |Average, Minimum, Maximum, Count |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**row cache hit out of range**<br><br>Number of table row cache hits that do not satisfy the query filter, thus went to disk. |`cassandra_table_row_cache_hit_out_of_range` |Count |Average, Minimum, Maximum, Count |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**row cache miss**<br><br>Number of table row cache misses. |`cassandra_table_row_cache_miss` |Count |Average, Minimum, Maximum, Count |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**speculative retries**<br><br>Number of times speculative retries were sent for this table. |`cassandra_table_speculative_retries` |Count |Average, Minimum, Maximum, Count |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**sstables per read average**<br><br>Average number of sstable data files accessed per single partition read. SSTables skipped due to Bloom Filters, min-max key or partition index lookup are not taken into account. |`cassandra_table_sstables_per_read_histogram` |Count |Average |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**sstables per read p99**<br><br>p99 number of sstable data files accessed per single partition read. SSTables skipped due to Bloom Filters, min-max key or partition index lookup are not taken into account. |`cassandra_table_sstables_per_read_histogram_p99` |Count |Average |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**tombstone scanned average**<br><br>Average tombstones scanned in queries on this table. |`cassandra_table_tombstone_scanned_histogram` |Count |Average |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**tombstone scanned p99**<br><br>p99 tombstones scanned in queries on this table. |`cassandra_table_tombstone_scanned_histogram_p99` |Count |Average |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**total disk space used (deprecated)**<br><br>Total disk space used by SSTables belonging to this table, including obsolete ones waiting to be GC'd. |`cassandra_table_total_disk_space_used` |Bytes |Total (Sum) |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|
|**total disk space used (deprecated)**<br><br>Total disk space used by SSTables belonging to this table, including obsolete ones waiting to be GC'd. |`cassandra_table_total_disk_space_used2` |Bytes |Total (Sum) |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|
|**total disk space used**<br><br>Total disk space used by SSTables belonging to this table, including obsolete ones waiting to be GC'd. |`cassandra_table_total_disk_space_used3` |Bytes |Average, Minimum, Maximum, Count |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**view lock acquire time average**<br><br>Average time taken acquiring a partition lock for materialized view updates on this table. |`cassandra_table_view_lock_acquire_time` |Count |Average |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**view lock acquire time p99**<br><br>p99 time taken acquiring a partition lock for materialized view updates on this table. |`cassandra_table_view_lock_acquire_time_p99` |Count |Average |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**view read time average**<br><br>Average time taken during the local read of a materialized view update. |`cassandra_table_view_read_time` |Count |Average |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**view read time p99**<br><br>p99 time taken during the local read of a materialized view update. |`cassandra_table_view_read_time_p99` |Count |Average |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**waiting on free memtable space average**<br><br>Average time spent waiting for free memtable space, either on- or off-heap. |`cassandra_table_waiting_on_free_memtable_space` |Count |Average |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**waiting on free memtable space p99**<br><br>p99 time spent waiting for free memtable space, either on- or off-heap. |`cassandra_table_waiting_on_free_memtable_space_p99` |Count |Average |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**write latency average (microseconds)**<br><br>Average local write latency for this table. |`cassandra_table_write_latency` |Count |Average |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|
|**write latency p99 (microseconds)**<br><br>p99 local write latency for this table. |`cassandra_table_write_latency_p99` |Count |Average |`cassandra_datacenter`, `cassandra_node`, `table`, `keyspace`|PT1M |No|

### Category: Cassandra ThreadPool
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**active tasks**<br><br>Number of tasks being actively worked on by this pool. |`cassandra_thread_pools_active_tasks` |Count |Average, Minimum, Maximum, Count |`cassandra_datacenter`, `cassandra_node`, `pool_name`, `pool_type`|PT1M |No|
|**currently blocked tasks (deprecated)**<br><br>Number of tasks that are currently blocked due to queue saturation but on retry will become unblocked. |`cassandra_thread_pools_currently_blocked_tasks` |Count |Total (Sum) |`cassandra_datacenter`, `cassandra_node`, `pool_name`, `pool_type`|PT1M |No|
|**currently blocked tasks (deprecated)**<br><br>Number of tasks that are currently blocked due to queue saturation but on retry will become unblocked. |`cassandra_thread_pools_currently_blocked_tasks2` |Count |Total (Sum) |`cassandra_datacenter`, `cassandra_node`, `pool_name`, `pool_type`|PT1M |No|
|**currently blocked tasks**<br><br>Number of tasks that are currently blocked due to queue saturation but on retry will become unblocked. |`cassandra_thread_pools_currently_blocked_tasks3` |Count |Average, Minimum, Maximum, Count |`cassandra_datacenter`, `cassandra_node`, `pool_name`, `pool_type`|PT1M |No|
|**max pool size**<br><br>Maximum number of threads in this pool. |`cassandra_thread_pools_max_pool_size` |Count |Maximum |`cassandra_datacenter`, `cassandra_node`, `pool_name`, `pool_type`|PT1M |No|
|**pending tasks**<br><br>Number of queued tasks queued up on this pool. |`cassandra_thread_pools_pending_tasks` |Count |Average, Minimum, Maximum, Count |`cassandra_datacenter`, `cassandra_node`, `pool_name`, `pool_type`|PT1M |No|
|**total blocked tasks**<br><br>Total number of tasks that were blocked due to queue saturation. |`cassandra_thread_pools_total_blocked_tasks` |Count |Average, Minimum, Maximum, Count |`cassandra_datacenter`, `cassandra_node`, `pool_name`, `pool_type`|PT1M |No|

### Category: System
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**CPU usage active**<br><br>CPU usage (active). |`cpu` |Percent |Average |`ClusterResourceName`, `DataCenterResourceName`, `Address`, `Kind`, `CPU`|PT1M |Yes|
|**disk utilization**<br><br>Disk utilization rate. |`disk_utilization` |Percent |Average |`ClusterResourceName`, `DataCenterResourceName`, `Address`|PT1M |Yes|
|**disk I/O merged reads**<br><br>Cumulative disk I/O merged reads. |`diskio_merged_reads` |Count |Average, Minimum, Maximum, Count |`ClusterResourceName`, `DataCenterResourceName`, `Address`, `Kind`|PT1M |No|
|**disk I/O merged writes**<br><br>Cumulative disk I/O merged writes. |`diskio_merged_writes` |Count |Average, Minimum, Maximum, Count |`ClusterResourceName`, `DataCenterResourceName`, `Address`, `Kind`|PT1M |No|
|**disk I/O read bytes**<br><br>Cumulative disk I/O read bytes. |`diskio_read_bytes` |Bytes |Average, Minimum, Maximum, Count |`ClusterResourceName`, `DataCenterResourceName`, `Address`, `Kind`|PT1M |No|
|**disk I/O read time (milliseconds)**<br><br>Cumulative disk I/O read time (milliseconds). |`diskio_read_time` |MilliSeconds |Average, Minimum, Maximum, Count |`ClusterResourceName`, `DataCenterResourceName`, `Address`, `Kind`|PT1M |No|
|**disk I/O read counts**<br><br>Cumulative disk I/O read counts. |`diskio_reads` |Count |Average, Minimum, Maximum, Count |`ClusterResourceName`, `DataCenterResourceName`, `Address`, `Kind`|PT1M |No|
|**disk I/O write bytes**<br><br>Cumulative disk I/O write bytes. |`diskio_write_bytes` |Bytes |Average, Minimum, Maximum, Count |`ClusterResourceName`, `DataCenterResourceName`, `Address`, `Kind`|PT1M |No|
|**disk I/O write time (milliseconds)**<br><br>Cumulative disk I/O write time (milliseconds). |`diskio_write_time` |MilliSeconds |Average, Minimum, Maximum, Count |`ClusterResourceName`, `DataCenterResourceName`, `Address`, `Kind`|PT1M |No|
|**disk I/O write counts**<br><br>Cumulative disk I/O write counts. |`diskio_writes` |Count |Average, Minimum, Maximum, Count |`ClusterResourceName`, `DataCenterResourceName`, `Address`, `Kind`|PT1M |No|
|**network received bytes**<br><br>Cumulative network received bytes. |`ethtool_rx_bytes` |Bytes |Average, Minimum, Maximum, Count |`ClusterResourceName`, `DataCenterResourceName`, `Address`, `Kind`|PT1M |No|
|**network received packets**<br><br>Cumulative network received packets. |`ethtool_rx_packets` |Count |Average, Minimum, Maximum, Count |`ClusterResourceName`, `DataCenterResourceName`, `Address`, `Kind`|PT1M |No|
|**network transmitted bytes**<br><br>Cumulative network transmitted bytes. |`ethtool_tx_bytes` |Bytes |Average, Minimum, Maximum, Count |`ClusterResourceName`, `DataCenterResourceName`, `Address`, `Kind`|PT1M |No|
|**network transmitted packets**<br><br>Cumulative network transmitted packets. |`ethtool_tx_packets` |Count |Average, Minimum, Maximum, Count |`ClusterResourceName`, `DataCenterResourceName`, `Address`, `Kind`|PT1M |No|
|**IOPS (including throughput)**<br><br>I/O operations and bytes per second. |`iops` |Count |Average |`ClusterResourceName`, `DataCenterResourceName`, `Address`, `Kind`|PT1M |Yes|
|**memory utilization**<br><br>Memory utilization rate. |`percent_mem` |Percent |Average |`ClusterResourceName`, `DataCenterResourceName`, `Address`|PT1M |Yes|
|**RAID array degraded**<br><br>Whether RAID array is degraded. 1 means degraded, 0 means not degraded. |`raid_array_degraded` |Count |Average, Maximum, Minimum |`DataCenterResourceName`, `Address`, `RaidArrayName`, `RaidArrayType`|PT1M |No|
|**RAID array rebuild**<br><br>Percentage of RAID array rebuild. |`raid_array_rebuild` |Percent |Average, Minimum, Maximum |`DataCenterResourceName`, `Address`, `RaidArrayName`, `RaidArrayType`|PT1M |No|
|**average CPU usage active**<br><br>Average CPU usage (active) across all the CPUs. |`total_cpu` |Percent |Average |`ClusterResourceName`, `DataCenterResourceName`, `Address`, `Kind`|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
