# Introduction to PromQL

* not an SQL-like language
* PromQL is powerful but most of the time your needs will be simple

## Aggregation Basics

### Gauge

* snapshot of state
* we usually agregate it with sum, avg, min or max

Total FS size on each machine (node_filesystem_size_bytes metric comes from Node exporter):

```
sum(node_filesystem_size_bytes) without(device, fstype, mountpoint)
```

* sum up everything with the same labels ingnore those three

### Counter

* tracks the number or size of events (total since start)
* use `rate` function as counters are always increasing

How many samples Prometheus is ingesting per-second *averaged* over one minute:

```
rate(prometheus_tsdb_head_samples_appended_total[1m])
```

The output of `rate` is a gauge, so e.g. to get total bytes received per machine per second:

```
sum(rate(node_network_receive_bytes_total[5m])) without(device)
```

## Selectors

You almost always will want to limit by job label, e.g.:

```
process_resident_memory_bytes{job="kubelet"}
```

* instant vector (one dimensional list) selector

### Matachers

```
=  --> job="node"
!=
=~ --> jon=~"n.*"  # fully anchored, RE2
!~
```

# Labels

* key-value pairs associated with time series
* together with with metric name uniquely idendify metrics (time series)

There are two types of labels although you don't see any difference among them
in PromQL:

1) Instrumentation labels

* things that are know inside you application

2) Target labels

* identify a specific monitoring target (a target that monitoring scrapes)
* relate more to your architecture
* attached by Prometheus as part of process of scraping metrics
* come from service discovery (metadata) and relabelling
* service discovery metadata are converted to target labels
* default ones: `instance`, `job`

# Sources

* Prometheus: Up & Running (2018)
