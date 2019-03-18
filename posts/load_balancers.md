Load balancer types
-------------------

DNS Round Robin
* simple to set up
* difficult to control, not very responsive
* if one replica dies, the clients will try to access it until the cache
    expires
* no control over which backend (replica) receives the traffic

L3 and L4
* simple and fast
* each TCP session is redirected to one of the replicas
* L3 - all traffic from a given source IP will be sent to the same server
    regardless of the number of TCP sessions it has generated
* L4 - track also source and destination port (finer granularity)

L7
* can examine what's inside the HTTP protocol - like headers (cookies), URLs - and
    make decisions based on that
* `X-Forwarded-For:` - header that can be inserted by a LB containing list of IPs
traversed before the packet got to the LB

Load balancing methods

* Round Robin (RR)
* Weighted RR
* Least Loaded (LL)
* LL with slow start
* Utilization limit
* Latency
* Cascade

Solutions for "shared state problem" (ex. authenticated user)

* Sticky connections
* Shared state (Memcached, Redis)
* Hybrid

User identity

* can't be based on the source IP (NAT, DHCP, Wifi -> cellular, multiple
    browsers on one host)
* server generates a secret and sends it back to the browser
* browser attaches this secret to each request
* name of this scheme - *cookie*
* name of the secret - *session ID*

Scale vs. Resiliency

Source: PoCSA
