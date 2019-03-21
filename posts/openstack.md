Initiliaze (env. vars etc.)

```
source ~/.openrc
```

Networking (Neutron)

```
openstack network list              # all nets
openstack network show <id>         # details
openstack ip availability show <id> # IP addresses
```

Heat

```
heat stack-list
heat stack-show <id>
heat resource-list <id>                         # list stack resources
heat resource-show <stack-id> <resource-name>   # resource details
```

[Allowed Address Pairs](https://docs.openstack.org/dragonflow/latest/specs/allowed_address_pairs.html)

* feature that allows adding additional IP/MAC address pairs on a port to allow traffic that matches those specified values

[Floating IP address (FIP)](https://docs.openstack.org/ocata/user-guide/cli-manage-ip-addresses.html)

[Releases](https://en.wikipedia.org/wiki/OpenStack#Release_history) (Ocata, Pike, ...)
