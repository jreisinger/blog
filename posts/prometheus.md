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
* use `rate` function for counters as they're always increasing

How many samples Prometheus is ingesting per-second averaged over one minute:

```
rate(prometheus_tsdb_head_samples_appended_total[1m])
```

* an average over the last 1 minute

The output of `rate` is a gauge, so e.g. to get total bytes received per machine per second:

```
sum(rate(node_network_receive_bytes_total[5m])) without(device)
```

# Sources

* Prometheus: Up & Running (2018)
