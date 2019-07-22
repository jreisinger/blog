DNS database
============

Zone

* a portion of the DNS namespace
* a domain name that has been delegated to other servers/administrators

Zone files

* a zone's DNS database
* set of text files maintained by the sysadmin on the zone's master name server

Zone files have two types of entries:

* parser commands
* resource records

Parser commands (directives)
----------------------------

`$ORIGIN <domain-name>` - sets/changes the origin, i.e. the default domain (defaults to the domain name specified in the name server's config file)

`$INCLUDE <filename> [origin]` - allows you to separate records into files or to keep cryptographic keys in a file with restricted permissions

`$TTL <default-ttl>` - must be the first line of the zone file

Resource records
----------------

    [name] [ttl] [class] type data
    
name

* host or domain (if ommitted referes to the previous entity)
* relative or absolute (ends with a dot)

ttl

* how long can data be cached and still considered valid
* defaults to `$TTL` directive
* once records are cached outside you local network, you cannot force them to be discarded

class

* network type: IN (default), HS, CH (ChaosNet :-)

type

    SOA    Start of Authority (Defines a DNS zone)
    NS     Name Server
    A      IPv4 Address (Name-to-address translation)
    AAAA   IPv6 Address
    PTR    Pointer (Address-to-name translation)
    MX     Mail Exchanger (Controls email routing)
    DNSKEY Public Key (Public key for a DNS name - used for DNSSEC)
    SPF    Sender Policy (Identifies mail servers, inhibits forging)
    DKIM   DomainKeys Identified Mail (Signature system for email - verify sender and message integrity)
    CNAME  Canonical Name (Nicknames or aliases for a host)
    SRV    Services (Gives locations of well-known services)
    TXT    Text (Comments or untyped information; used for trying out new ideas)

*SPF* - allows administrators to specify which hosts are allowed to send mail on
behalf of a given domain by creating a specific SPF record (or TXT record) in
the Domain Name System (DNS).

*DKIM* - powered by asymmetric cryptography

1. The sender's Mail Transfer Agent (MTA) signs every outgoing message with a
private key.
2. The recipient retrieves the public key from the sender's DNS records and
verifies if the message body and some of the header fields were not altered
since the message signing took place.

Special characters in resource records

    ;   comment
    @   the current zone name
    ()  allows data to span lines
    *   wild card (`name` field only)

Name server taxonomy
====================

authoritative - an official representative of a zone

* master, primary - gets data from a disk file
* slave, secondary - copies data from the master

non-authoritative - answers queries from cache; doesn't know if the data is still valid

* caching - caches data from previous queries; usually has no local zones
* forwarder - performs queries on behalf of many clients; builds a large cache

recursive - queries on your behalf until it returns either an answer or an error

non-recursive - refers you to another server if it can't answer a query

*Note*: resolver libraries do not understand referrals. Any local nameserver listed in a client's `resolv.conf` file must be recursive.

Testing and debugging
=====================

Tools
-----

dig

    dig [@server] [-x addr] [name] [type] [+trace]

host

    host name|addr [server]
 
nslookup (Cricket Liu doesn't like it :-))

    nslookup [name|addr] [server]

Howtos
------

Find out the names of the authoritative nameservers for a domain

```
dig ist.ac.at ns
```

Find out a master nameserver

```
dig ist.ac.at soa
```

Find out the version of a bind nameserver (can be concealed in some cases)

```
dig @ns1.ist.ac.at version.bind txt chaos
```


Checking for open resolvers: http://dns.measurement-factory.com/tools/ => open resolver test

* recursive, caching name server that accepts and answers queries from anyone
 on the Internet
* resources consumption
* resolver's cache poisoning
* amplification of DDoS attacks

Find DNS server used by your system:

```
# Ubuntu 16.04
nmcli device show | grep IP4.DNS
```
 
Sources
=======

* [ULSAH](http://ulsah.com/) ch. 17. DNS: The Domain Name System
* [SPF](https://www.digitalocean.com/community/tutorials/how-to-use-an-spf-record-to-prevent-spoofing-improve-e-mail-reliability)
* [DKIM](https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-dkim-with-postfix-on-debian-wheezy)
