#
# parse-config-lib.pl
#
# dnsmasq webmin module library module
#

#
# the config hash holds the parsed config file(s)
# 
# --no-hosts
# --addn-hosts=<file>
# --hostsdir=<path>
# --expand-hosts
# --local-ttl=<time>
# --dhcp-ttl=<time>
# --neg-ttl=<time>
# --max-ttl=<time>
# --max-cache-ttl=<time>
# --min-cache-ttl=<time>
# --auth-ttl=<time>
# --log-queries
# --log-facility=<facility>
# --log-debug
# --log-async[=<lines>]
# --pid-file=<path>
# --user=<username>
# --group=<groupname>
# --port=<port>
# --edns-packet-max=<size>
# --query-port=<query_port>
# --min-port=<port>
# --max-port=<port>
# --interface=<interface name>
# --except-interface=<interface name>
# --auth-server=<domain>,[<interface>|<ip-address>...]
# --local-service
# --no-dhcp-interface=<interface name>
# --listen-address=<ipaddr>
# --bind-interfaces
# --bind-dynamic
# --localise-queries
# --bogus-priv
# --alias=[<old-ip>]|[<start-ip>-<end-ip>],<new-ip>[,<mask>]
# --bogus-nxdomain=<ipaddr>[/prefix]
# --ignore-address=<ipaddr>[/prefix]
# --filterwin2k
# --resolv-file=<file>
# --no-resolv
# --enable-dbus[=<service-name>]
# --enable-ubus[=<service-name>]
# --strict-order
# --all-servers
# --dns-loop-detect
# --stop-dns-rebind
# --rebind-localhost-ok
# --rebind-domain-ok=[<domain>]|[[/<domain>/[<domain>/]
# --no-poll
# --clear-on-reload
# --domain-needed
# --local=[/[<domain>]/[domain/]][<ipaddr>[#<port>]][@<interface>][@<source-ip>[#<port>]]
# --server=[/[<domain>]/[domain/]][<ipaddr>[#<port>]][@<interface>][@<source-ip>[#<port>]]
# --rev-server=<ip-address>/<prefix-len>[,<ipaddr>][#<port>][@<interface>][@<source-ip>[#<port>]]
# --address=/<domain>[/<domain>...]/[<ipaddr>]
# --ipset=/<domain>[/<domain>...]/<ipset>[,<ipset>...]
# --connmark-allowlist-enable[=<mask>]
# --connmark-allowlist=<connmark>[/<mask>][,<pattern>[/<pattern>...]]
# --mx-host=<mx name>[[,<hostname>],<preference>]
# --mx-target=<hostname>
# --selfmx
# --localmx
# --srv-host=<_service>.<_prot>.[<domain>],[<target>[,<port>[,<priority>[,<weight>]]]]
# --host-record=<name>[,<name>....],[<IPv4-address>],[<IPv6-address>][,<TTL>]
# --dynamic-host=<name>,[IPv4-address],[IPv6-address],<interface>
# --txt-record=<name>[[,<text>],<text>]
# --ptr-record=<name>[,<target>]
# --naptr-record=<name>,<order>,<preference>,<flags>,<service>,<regexp>[,<replacement>]
# --caa-record=<name>,<flags>,<tag>,<value>
# --cname=<cname>,[<cname>,]<target>[,<TTL>]
# --dns-rr=<name>,<RR-number>,[<hex data>]
# --interface-name=<name>,<interface>[/4|/6]
# --synth-domain=<domain>,<address range>[,<prefix>[*]]
# --dumpfile=<path/to/file>
# --dumpmask=<mask>
# --add-mac[=base64|text]
# --add-cpe-id=<string>
# --add-subnet[[=[<IPv4 address>/]<IPv4 prefix length>][,[<IPv6 address>/]<IPv6 prefix length>]]
# --umbrella[=deviceid:<deviceid>[,orgid:<orgid>]]
# --cache-size=<cachesize>
# --no-negcache
# --dns-forward-max=<queries>
# --dnssec
# --trust-anchor=[<class>],<domain>,<key-tag>,<algorithm>,<digest-type>,<digest>
# --dnssec-check-unsigned[=no]
# --dnssec-no-timecheck
# --dnssec-timestamp=<path>
# --proxy-dnssec
# --dnssec-debug
# --auth-zone=<domain>[,<subnet>[/<prefix length>][,<subnet>[/<prefix length>].....][,exclude:<subnet>[/<prefix length>]].....]
# --auth-soa=<serial>[,<hostmaster>[,<refresh>[,<retry>[,<expiry>]]]]
# --auth-sec-servers=<domain>[,<domain>[,<domain>...]]
# --auth-peer=<ip-address>[,<ip-address>[,<ip-address>...]]
# --conntrack
# --dhcp-range=[tag:<tag>[,tag:<tag>],][set:<tag>,]<start-addr>[,<end-addr>|<mode>][,<netmask>[,<broadcast>]][,<lease time>]
# --dhcp-range=[tag:<tag>[,tag:<tag>],][set:<tag>,]<start-IPv6addr>[,<end-IPv6addr>|constructor:<interface>][,<mode>][,<prefix-len>][,<lease time>]
# --dhcp-host=[<hwaddr>][,id:<client_id>|*][,set:<tag>][tag:<tag>][,<ipaddr>][,<hostname>][,<lease_time>][,ignore]
# --dhcp-hostsfile=<path>
# --dhcp-optsfile=<path>
# --dhcp-hostsdir=<path>
# --dhcp-optsdir=<path>
# --read-ethers
# --dhcp-option=[tag:<tag>,[tag:<tag>,]][encap:<opt>,][vi-encap:<enterprise>,][vendor:[<vendor-class>],][<opt>|option:<opt-name>|option6:<opt>|option6:<opt-name>],[<value>[,<value>]]
# --dhcp-option-force=[tag:<tag>,[tag:<tag>,]][encap:<opt>,][vi-encap:<enterprise>,][vendor:[<vendor-class>],]<opt>,[<value>[,<value>]]
# --dhcp-no-override
# --dhcp-relay=<local address>,<server address>[,<interface]
# --dhcp-vendorclass=set:<tag>,[enterprise:<IANA-enterprise number>,]<vendor-class>
# --dhcp-userclass=set:<tag>,<user-class>
# --dhcp-mac=set:<tag>,<MAC address>
# --dhcp-circuitid=set:<tag>,<circuit-id>
# --dhcp-remoteid=set:<tag>,<remote-id>
# --dhcp-subscrid=set:<tag>,<subscriber-id>
# --dhcp-proxy[=<ip addr>]......
# --dhcp-match=set:<tag>,<option number>|option:<option name>|vi-encap:<enterprise>[,<value>]
# --dhcp-name-match=set:<tag>,<name>[*]
# --tag-if=set:<tag>[,set:<tag>[,tag:<tag>[,tag:<tag>]]]
# --dhcp-ignore=tag:<tag>[,tag:<tag>]
# --dhcp-ignore-names[=tag:<tag>[,tag:<tag>]]
# --dhcp-generate-names=tag:<tag>[,tag:<tag>]
# --dhcp-broadcast[=tag:<tag>[,tag:<tag>]]
# --dhcp-boot=[tag:<tag>,]<filename>,[<servername>[,<server address>|<tftp_servername>]]
# --dhcp-sequential-ip
# --dhcp-ignore-clid
# --pxe-service=[tag:<tag>,]<CSA>,<menu text>[,<basename>|<bootservicetype>][,<server address>|<server_name>]
# --pxe-prompt=[tag:<tag>,]<prompt>[,<timeout>]
# --dhcp-pxe-vendor=<vendor>[,...]
# --dhcp-lease-max=<number>
# --dhcp-authoritative
# --dhcp-rapid-commit
# --dhcp-alternate-port[=<server port>[,<client port>]]
# --bootp-dynamic[=<network-id>[,<network-id>]]
# --no-ping
# --log-dhcp
# --quiet-dhcp
# --quiet-dhcp6
# --quiet-ra
# --dhcp-leasefile=<path>
# --dhcp-duid=<enterprise-id>,<uid>
# --dhcp-script=<path>
# --dhcp-luascript=<path>
# --dhcp-scriptuser=<user>
# --script-arp
# --leasefile-ro
# --script-on-renewal
# --bridge-interface=<interface>,<alias>[,<alias>]
# --shared-network=<interface>,<addr>
# --shared-network=<addr>,<addr>
# --domain=<domain>[,<address range>[,local]]
# --dhcp-fqdn
# --dhcp-client-update
# --enable-ra
# --ra-param=<interface>,[mtu:<integer>|<interface>|off,][high,|low,]<ra-interval>[,<router lifetime>]
# --dhcp-reply-delay=[tag:<tag>,]<integer>
# --enable-tftp[=<interface>[,<interface>]]
# --tftp-root=<directory>[,<interface>]
# --tftp-no-fail
# --tftp-unique-root[=ip|mac]
# --tftp-secure
# --tftp-lowercase
# --tftp-max=<connections>
# --tftp-mtu=<mtu size>
# --tftp-no-blocksize
# --tftp-port-range=<start>,<end>
# --tftp-single-port
# --conf-file=<file>
# --conf-dir=<directory>[,<file-extension>......],
# --servers-file=<file>

# type:
#   int ------- integer
#   string ---- string
#   file ------ filename
#   dir ------- directory
#   path ------ file or directory
#   bool ------ boolean (option exists or it doesn't); cannot have any other value
#   var ------- various and/or multiple values
# arr:
#   1 --------- option may be specified multiple times
# default:
#   value if none is specified
# mult:
#   {char} ---- (complete) specified value may be specified multiple times, separated by the specified character

use strict;
use warnings;
use v5.10; # at least for Perl 5.10
# use Data::Dumper;
use experimental qw( switch );

our %dnsmconfigvals = (
    "no-hosts"                  => { "idx" => 0,   "valtype" => "bool",    "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "addn-hosts"                => { "idx" => 1,   "valtype" => "path",    "section" => "dns",   "arr" => 1, "mult" => "", "special" => 0 }, # =<file>
    "hostsdir"                  => { "idx" => 2,   "valtype" => "dir",     "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0 }, # =<path>
    "expand-hosts"              => { "idx" => 3,   "valtype" => "bool",    "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "local-ttl"                 => { "idx" => 4,   "valtype" => "int",     "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0, "default" => 0 }, # =<time>
    "dhcp-ttl"                  => { "idx" => 5,   "valtype" => "int",     "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0, "default" => 0 }, # =<time>
    "neg-ttl"                   => { "idx" => 6,   "valtype" => "int",     "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0, "default" => 0 }, # =<time>
    "max-ttl"                   => { "idx" => 7,   "valtype" => "int",     "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0, "default" => 0 }, # =<time>
    "max-cache-ttl"             => { "idx" => 8,   "valtype" => "int",     "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0, "default" => 0 }, # =<time>
    "min-cache-ttl"             => { "idx" => 9,   "valtype" => "int",     "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0, "default" => 0 }, # =<time>
    "auth-ttl"                  => { "idx" => 10,  "valtype" => "int",     "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0, "default" => 0 }, # =<time>
    "log-queries"               => { "idx" => 11,  "valtype" => "bool",    "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "log-facility"              => { "idx" => 12,  "valtype" => "string",  "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0 }, # =<facility>
    "log-debug"                 => { "idx" => 13,  "valtype" => "bool",    "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "log-async"                 => { "idx" => 14,  "valtype" => "int",     "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0, "default" => 5, "val_optional" => 1 }, # [=<lines>]
    "pid-file"                  => { "idx" => 15,  "valtype" => "file",    "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0 }, # =<path>
    "user"                      => { "idx" => 16,  "valtype" => "string",  "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0, "default" => "nobody" }, # =<username>
    "group"                     => { "idx" => 17,  "valtype" => "string",  "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0, "default" => "dip" }, # =<groupname>
    "port"                      => { "idx" => 18,  "valtype" => "int",     "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0, "default" => 53 }, # =<port>
    "edns-packet-max"           => { "idx" => 19,  "valtype" => "int",     "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0, "default" => 4096 }, # =<size>
    "query-port"                => { "idx" => 20,  "valtype" => "int",     "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0 }, # =<query_port>
    "min-port"                  => { "idx" => 21,  "valtype" => "int",     "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0, "default" => 1024 }, # =<port>
    "max-port"                  => { "idx" => 22,  "valtype" => "int",     "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0 }, # =<port>
    "interface"                 => { "idx" => 23,  "valtype" => "string",  "section" => "dns",   "arr" => 1, "mult" => "", "special" => 0 }, # =<interface name>
    "except-interface"          => { "idx" => 24,  "valtype" => "string",  "section" => "dns",   "arr" => 1, "mult" => "", "special" => 0 }, # =<interface name>
    "auth-server"               => { "idx" => 25,  "valtype" => "var",     "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0 }, # TODO edit # =<domain>,[<interface>|<ip-address>...]
    "local-service"             => { "idx" => 26,  "valtype" => "bool",    "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "no-dhcp-interface"         => { "idx" => 27,  "valtype" => "string",  "section" => "dns",   "arr" => 1, "mult" => "", "special" => 0 }, # =<interface name>
    "listen-address"            => { "idx" => 28,  "valtype" => "ip",      "section" => "dns",   "arr" => 1, "mult" => "", "special" => 0 }, # =<ipaddr>
    "bind-interfaces"           => { "idx" => 29,  "valtype" => "bool",    "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "bind-dynamic"              => { "idx" => 30,  "valtype" => "bool",    "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "localise-queries"          => { "idx" => 31,  "valtype" => "bool",    "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "bogus-priv"                => { "idx" => 32,  "valtype" => "bool",    "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "alias"                     => { "idx" => 33,  "valtype" => "var",     "section" => "dns",   "arr" => 1, "mult" => "", "special" => 0 }, # =[<old-ip>]|[<start-ip>-<end-ip>],<new-ip>[,<mask>] # previously "dns_forced"?
    "bogus-nxdomain"            => { "idx" => 34,  "valtype" => "var",     "section" => "dns",   "arr" => 1, "mult" => "", "special" => 0 }, # =<ipaddr>[/prefix]
    "ignore-address"            => { "idx" => 35,  "valtype" => "var",     "section" => "dns",   "arr" => 1, "mult" => "", "special" => 0 }, # =<ipaddr>[/prefix]
    "filterwin2k"               => { "idx" => 36,  "valtype" => "bool",    "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "resolv-file"               => { "idx" => 37,  "valtype" => "file",    "section" => "dns",   "arr" => 1, "mult" => "", "special" => 0, "default" => "/etc/resolv.conf" }, # =<file>
    "no-resolv"                 => { "idx" => 38,  "valtype" => "bool",    "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "enable-dbus"               => { "idx" => 39,  "valtype" => "string",  "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0, "default" => "uk.org.thekelleys.dnsmasq", "val_optional" => 1 }, # [=<service-name>]
    "enable-ubus"               => { "idx" => 40,  "valtype" => "string",  "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0, "default" => "dnsmasq", "val_optional" => 1 }, # [=<service-name>]
    "strict-order"              => { "idx" => 41,  "valtype" => "bool",    "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "all-servers"               => { "idx" => 42,  "valtype" => "bool",    "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "dns-loop-detect"           => { "idx" => 43,  "valtype" => "bool",    "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "stop-dns-rebind"           => { "idx" => 44,  "valtype" => "bool",    "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "rebind-localhost-ok"       => { "idx" => 45,  "valtype" => "bool",    "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "rebind-domain-ok"          => { "idx" => 46,  "valtype" => "string",  "section" => "dns",   "arr" => 0, "mult" => "/", "special" => 0 }, # TODO edit # =[<domain>]|[[/<domain>/[<domain>/]
    "no-poll"                   => { "idx" => 47,  "valtype" => "bool",    "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "clear-on-reload"           => { "idx" => 48,  "valtype" => "bool",    "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "domain-needed"             => { "idx" => 49,  "valtype" => "bool",    "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "local"                     => { "idx" => 50,  "valtype" => "var",     "section" => "dns",   "arr" => 1, "mult" => "", "special" => 1 }, # =[/[<domain>]/[domain/]][<ipaddr>[#<port>]][@<interface>][@<source-ip>[#<port>]]
    "server"                    => { "idx" => 51,  "valtype" => "var",     "section" => "dns",   "arr" => 1, "mult" => "", "special" => 1 }, # =[/[<domain>]/[domain/]][<ipaddr>[#<port>]][@<interface>][@<source-ip>[#<port>]]
    "rev-server"                => { "idx" => 52,  "valtype" => "var",     "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0 }, # TODO edit # =<ip-address>/<prefix-len>[,<ipaddr>][#<port>][@<interface>][@<source-ip>[#<port>]]
    "address"                   => { "idx" => 53,  "valtype" => "var",     "section" => "dns",   "arr" => 1, "mult" => "", "special" => 0 }, # TODO edit # =/<domain>[/<domain>...]/[<ipaddr>]
    "ipset"                     => { "idx" => 54,  "valtype" => "var",     "section" => "dns",   "arr" => 0, "mult" => "", "special" => 1 }, # TODO edit # =/<domain>[/<domain>...]/<ipset>[,<ipset>...]
    "connmark-allowlist-enable" => { "idx" => 55,  "valtype" => "string",  "section" => "dns",   "arr" => 0, "mult" => "", "special" => 1, "val_optional" => 1 }, # [=<mask>]
    "connmark-allowlist"        => { "idx" => 56,  "valtype" => "var",     "section" => "dns",   "arr" => 1, "mult" => "", "special" => 1 }, # TODO edit # =<connmark>[/<mask>][,<pattern>[/<pattern>...]] 
    "mx-host"                   => { "idx" => 57,  "valtype" => "var",     "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0 }, # TODO edit # =<mx name>[[,<hostname>],<preference>]
    "mx-target"                 => { "idx" => 58,  "valtype" => "string",  "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0 }, # =<hostname>
    "selfmx"                    => { "idx" => 59,  "valtype" => "bool",    "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "localmx"                   => { "idx" => 60,  "valtype" => "bool",    "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "srv-host"                  => { "idx" => 61,  "valtype" => "var",     "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0 }, # TODO edit # =<_service>.<_prot>.[<domain>],[<target>[,<port>[,<priority>[,<weight>]]]]
    "host-record"               => { "idx" => 62,  "valtype" => "var",     "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0 }, # TODO edit # =<name>[,<name>....],[<IPv4-address>],[<IPv6-address>][,<TTL>]
    "dynamic-host"              => { "idx" => 63,  "valtype" => "var",     "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0 }, # TODO edit # =<name>,[IPv4-address],[IPv6-address],<interface>
    "txt-record"                => { "idx" => 64,  "valtype" => "var",     "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0 }, # TODO edit # =<name>[[,<text>],<text>]
    "ptr-record"                => { "idx" => 65,  "valtype" => "var",     "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0 }, # TODO edit # =<name>[,<target>]
    "naptr-record"              => { "idx" => 66,  "valtype" => "var",     "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0 }, # TODO edit # =<name>,<order>,<preference>,<flags>,<service>,<regexp>[,<replacement>]
    "caa-record"                => { "idx" => 67,  "valtype" => "var",     "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0 }, # TODO edit # =<name>,<flags>,<tag>,<value>
    "cname"                     => { "idx" => 68,  "valtype" => "var",     "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0 }, # TODO edit # =<cname>,[<cname>,]<target>[,<TTL>]
    "dns-rr"                    => { "idx" => 69,  "valtype" => "var",     "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0 }, # TODO edit # =<name>,<RR-number>,[<hex data>]
    "interface-name"            => { "idx" => 70,  "valtype" => "var",     "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0 }, # TODO edit # =<name>,<interface>[/4|/6]
    "synth-domain"              => { "idx" => 71,  "valtype" => "var",     "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0 }, # TODO edit # =<domain>,<address range>[,<prefix>[*]]
    "dumpfile"                  => { "idx" => 72,  "valtype" => "file",    "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0 }, # =<path/to/file>
    "dumpmask"                  => { "idx" => 73,  "valtype" => "string",  "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0 }, # =<mask>
    "add-mac"                   => { "idx" => 74,  "valtype" => "string",  "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0, "val_optional" => 1 }, # [=base64|text]
    "add-cpe-id"                => { "idx" => 75,  "valtype" => "string",  "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0 }, # =<string>
    "add-subnet"                => { "idx" => 76,  "valtype" => "var",     "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0, "val_optional" => 1 }, # TODO edit # [[=[<IPv4 address>/]<IPv4 prefix length>][,[<IPv6 address>/]<IPv6 prefix length>]]
    "umbrella"                  => { "idx" => 77,  "valtype" => "var",     "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0, "val_optional" => 1 }, # TODO edit # [=deviceid:<deviceid>[,orgid:<orgid>]]
    "cache-size"                => { "idx" => 78,  "valtype" => "int",     "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0, "default" => 150 }, # =<cachesize>
    "no-negcache"               => { "idx" => 79,  "valtype" => "bool",    "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "dns-forward-max"           => { "idx" => 80,  "valtype" => "int",     "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0, "default" => 150 }, # =<queries>
    "dnssec"                    => { "idx" => 81,  "valtype" => "bool",    "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "trust-anchor"              => { "idx" => 82,  "valtype" => "var",     "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0 }, # TODO edit # =[<class>],<domain>,<key-tag>,<algorithm>,<digest-type>,<digest>
    "dnssec-check-unsigned"     => { "idx" => 83,  "valtype" => "string",  "section" => "dns",   "arr" => 0, "mult" => "", "special" => 1, "default" => 1, "val_optional" => 1 }, # [=no]
    "dnssec-no-timecheck"       => { "idx" => 84,  "valtype" => "bool",    "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "dnssec-timestamp"          => { "idx" => 85,  "valtype" => "file",    "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0 }, # =<path>
    "proxy-dnssec"              => { "idx" => 86,  "valtype" => "bool",    "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "dnssec-debug"              => { "idx" => 87,  "valtype" => "bool",    "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "auth-zone"                 => { "idx" => 88,  "valtype" => "var",     "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0 }, # TODO edit # =<domain>[,<subnet>[/<prefix length>][,<subnet>[/<prefix length>].....][,exclude:<subnet>[/<prefix length>]].....]
    "auth-soa"                  => { "idx" => 89,  "valtype" => "var",     "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0 }, # TODO edit # =<serial>[,<hostmaster>[,<refresh>[,<retry>[,<expiry>]]]]
    "auth-sec-servers"          => { "idx" => 90,  "valtype" => "string",  "section" => "dns",   "arr" => 0, "mult" => ",", "special" => 0 }, # TODO edit # =<domain>[,<domain>[,<domain>...]]
    "auth-peer"                 => { "idx" => 91,  "valtype" => "ip",      "section" => "dns",   "arr" => 0, "mult" => ",", "special" => 0 }, # TODO edit # =<ip-address>[,<ip-address>[,<ip-address>...]]
    "conntrack"                 => { "idx" => 92,  "valtype" => "bool",    "section" => "dns",   "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "dhcp-range"                => { "idx" => 93,  "valtype" => "var",     "section" => "dhcp",  "arr" => 1, "mult" => "", "special" => 0 }, # TODO edit # =[tag:<tag>[,tag:<tag>],][set:<tag>,]<start-addr>[,<end-addr>|<mode>][,<netmask>[,<broadcast>]][,<lease time>] -OR- =[tag:<tag>[,tag:<tag>],][set:<tag>,]<start-IPv6addr>[,<end-IPv6addr>|constructor:<interface>][,<mode>][,<prefix-len>][,<lease time>]
    "dhcp-host"                 => { "idx" => 94,  "valtype" => "var",     "section" => "dhcp",  "arr" => 1, "mult" => "", "special" => 0 }, # TODO edit # =[<hwaddr>][,id:<client_id>|*][,set:<tag>][tag:<tag>][,<ipaddr>][,<hostname>][,<lease_time>][,ignore]
    "dhcp-hostsfile"            => { "idx" => 95,  "valtype" => "path",    "section" => "dhcp",  "arr" => 0, "mult" => "", "special" => 0 }, # =<path>
    "dhcp-optsfile"             => { "idx" => 96,  "valtype" => "path",    "section" => "dhcp",  "arr" => 0, "mult" => "", "special" => 0 }, # =<path>
    "dhcp-hostsdir"             => { "idx" => 97,  "valtype" => "dir",     "section" => "dhcp",  "arr" => 0, "mult" => "", "special" => 0 }, # =<path>
    "dhcp-optsdir"              => { "idx" => 98,  "valtype" => "dir",     "section" => "dhcp",  "arr" => 0, "mult" => "", "special" => 0 }, # =<path>
    "read-ethers"               => { "idx" => 99,  "valtype" => "bool",    "section" => "dhcp",  "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "dhcp-option"               => { "idx" => 100, "valtype" => "var",     "section" => "dhcp",  "arr" => 1, "mult" => "", "special" => 0 }, # =[tag:<tag>,[tag:<tag>,]][encap:<opt>,][vi-encap:<enterprise>,][vendor:[<vendor-class>],][<opt>|option:<opt-name>|option6:<opt>|option6:<opt-name>],[<value>[,<value>]]
    "dhcp-option-force"         => { "idx" => 101, "valtype" => "var",     "section" => "dhcp",  "arr" => 1, "mult" => "", "special" => 0 }, # =[tag:<tag>,[tag:<tag>,]][encap:<opt>,][vi-encap:<enterprise>,][vendor:[<vendor-class>],][<opt>|option:<opt-name>|option6:<opt>|option6:<opt-name>],[<value>[,<value>]]
    "dhcp-no-override"          => { "idx" => 102, "valtype" => "bool",    "section" => "dhcp",  "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "dhcp-relay"                => { "idx" => 103, "valtype" => "var",     "section" => "dhcp",  "arr" => 0, "mult" => "", "special" => 0 }, # TODO edit # =<local address>,<server address>[,<interface]
    "dhcp-vendorclass"          => { "idx" => 104, "valtype" => "var",     "section" => "dhcp",  "arr" => 1, "mult" => "", "special" => 0 }, # =set:<tag>,[enterprise:<IANA-enterprise number>,]<vendor-class>
    "dhcp-userclass"            => { "idx" => 105, "valtype" => "var",     "section" => "dhcp",  "arr" => 1, "mult" => "", "special" => 0 }, # =set:<tag>,<user-class>
    "dhcp-mac"                  => { "idx" => 106, "valtype" => "var",     "section" => "dhcp",  "arr" => 0, "mult" => "", "special" => 0 }, # TODO edit # =set:<tag>,<MAC address>
    "dhcp-circuitid"            => { "idx" => 107, "valtype" => "var",     "section" => "dhcp",  "arr" => 0, "mult" => "", "special" => 0 }, # TODO edit # =set:<tag>,<circuit-id>
    "dhcp-remoteid"             => { "idx" => 108, "valtype" => "var",     "section" => "dhcp",  "arr" => 0, "mult" => "", "special" => 0 }, # TODO edit # =set:<tag>,<remote-id>
    "dhcp-subscrid"             => { "idx" => 109, "valtype" => "var",     "section" => "dhcp",  "arr" => 0, "mult" => "", "special" => 0 }, # TODO edit # =set:<tag>,<subscriber-id>
    "dhcp-proxy"                => { "idx" => 110, "valtype" => "ip",      "section" => "dhcp",  "arr" => 0, "mult" => ",", "special" => 0, "val_optional" => 1 }, # TODO edit # [=<ip addr>]......
    "dhcp-match"                => { "idx" => 111, "valtype" => "var",     "section" => "dhcp",  "arr" => 0, "mult" => "", "special" => 0 }, # TODO edit # =set:<tag>,<option number>|option:<option name>|vi-encap:<enterprise>[,<value>]
    "dhcp-name-match"           => { "idx" => 112, "valtype" => "var",     "section" => "dhcp",  "arr" => 0, "mult" => "", "special" => 0 }, # TODO edit # =set:<tag>,<name>[*]
    "tag-if"                    => { "idx" => 113, "valtype" => "var",     "section" => "dhcp",  "arr" => 0, "mult" => "", "special" => 0 }, # TODO edit # =set:<tag>[,set:<tag>[,tag:<tag>[,tag:<tag>]]]
    "dhcp-ignore"               => { "idx" => 114, "valtype" => "var",     "section" => "dhcp",  "arr" => 0, "mult" => ",", "special" => 0 }, # TODO edit # =tag:<tag>[,tag:<tag>]
    "dhcp-ignore-names"         => { "idx" => 115, "valtype" => "var",     "section" => "dhcp",  "arr" => 0, "mult" => ",", "special" => 0, "val_optional" => 1 }, # TODO edit # [=tag:<tag>[,tag:<tag>]]
    "dhcp-generate-names"       => { "idx" => 116, "valtype" => "var",     "section" => "dhcp",  "arr" => 0, "mult" => ",", "special" => 0 }, # TODO edit # =tag:<tag>[,tag:<tag>]
    "dhcp-broadcast"            => { "idx" => 117, "valtype" => "var",     "section" => "dhcp",  "arr" => 0, "mult" => ",", "special" => 0, "val_optional" => 1 }, # TODO edit # [=tag:<tag>[,tag:<tag>]]
    "dhcp-boot"                 => { "idx" => 118, "valtype" => "var",     "section" => "t_b_p", "arr" => 0, "mult" => "", "special" => 0 }, # TODO edit # =[tag:<tag>,]<filename>,[<servername>[,<server address>|<tftp_servername>]]
    "dhcp-sequential-ip"        => { "idx" => 119, "valtype" => "bool",    "section" => "dhcp",  "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "dhcp-ignore-clid"          => { "idx" => 120, "valtype" => "bool",    "section" => "dhcp",  "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "pxe-service"               => { "idx" => 121, "valtype" => "var",     "section" => "t_b_p", "arr" => 0, "mult" => "", "special" => 0 }, # TODO edit # =[tag:<tag>,]<CSA>,<menu text>[,<basename>|<bootservicetype>][,<server address>|<server_name>]
    "pxe-prompt"                => { "idx" => 122, "valtype" => "var",     "section" => "t_b_p", "arr" => 0, "mult" => "", "special" => 0 }, # TODO edit # =[tag:<tag>,]<prompt>[,<timeout>]
    "dhcp-pxe-vendor"           => { "idx" => 123, "valtype" => "string",  "section" => "t_b_p", "arr" => 0, "mult" => "", "special" => 0 }, # TODO edit # =<vendor>[,...]
    "dhcp-lease-max"            => { "idx" => 124, "valtype" => "int",     "section" => "dhcp",  "arr" => 0, "mult" => "", "special" => 0, "default" => 1000 }, # =<number>
    "dhcp-authoritative"        => { "idx" => 125, "valtype" => "bool",    "section" => "dhcp",  "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "dhcp-rapid-commit"         => { "idx" => 126, "valtype" => "bool",    "section" => "dhcp",  "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "dhcp-alternate-port"       => { "idx" => 127, "valtype" => "var",     "section" => "dhcp",  "arr" => 0, "mult" => "", "special" => 0, "val_optional" => 1 }, # TODO edit # [=<server port>[,<client port>]]
    "bootp-dynamic"             => { "idx" => 128, "valtype" => "string",  "section" => "t_b_p", "arr" => 1, "mult" => ",", "special" => 0, "val_optional" => 1 }, # TODO edit # [=<network-id>[,<network-id>]]
    "no-ping"                   => { "idx" => 129, "valtype" => "bool",    "section" => "dhcp",  "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "log-dhcp"                  => { "idx" => 130, "valtype" => "bool",    "section" => "dhcp",  "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "quiet-dhcp"                => { "idx" => 131, "valtype" => "bool",    "section" => "dhcp",  "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "quiet-dhcp6"               => { "idx" => 132, "valtype" => "bool",    "section" => "dhcp",  "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "quiet-ra"                  => { "idx" => 133, "valtype" => "bool",    "section" => "dhcp",  "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "dhcp-leasefile"            => { "idx" => 134, "valtype" => "file",    "section" => "dhcp",  "arr" => 0, "mult" => "", "special" => 0 }, # =<path>
    "dhcp-duid"                 => { "idx" => 135, "valtype" => "var",     "section" => "dhcp",  "arr" => 0, "mult" => "", "special" => 0 }, # TODO edit # =<enterprise-id>,<uid>
    "dhcp-script"               => { "idx" => 136, "valtype" => "file",    "section" => "dhcp",  "arr" => 0, "mult" => "", "special" => 0 }, # =<path>
    "dhcp-luascript"            => { "idx" => 137, "valtype" => "file",    "section" => "dhcp",  "arr" => 0, "mult" => "", "special" => 0 }, # =<path>
    "dhcp-scriptuser"           => { "idx" => 138, "valtype" => "string",  "section" => "dhcp",  "arr" => 0, "mult" => "", "special" => 0, "default" => "root" }, # =<username>
    "script-arp"                => { "idx" => 139, "valtype" => "bool",    "section" => "dhcp",  "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "leasefile-ro"              => { "idx" => 140, "valtype" => "bool",    "section" => "dhcp",  "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "script-on-renewal"         => { "idx" => 141, "valtype" => "bool",    "section" => "dhcp",  "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "bridge-interface"          => { "idx" => 142, "valtype" => "var",     "section" => "dhcp",  "arr" => 1, "mult" => "", "special" => 0 }, # TODO edit # =<interface>,<alias>[,<alias>]
    "shared-network"            => { "idx" => 143, "valtype" => "var",     "section" => "dhcp",  "arr" => 0, "mult" => "", "special" => 0 }, # TODO edit # =<interface|addr>,<addr>
    "domain"                    => { "idx" => 144, "valtype" => "var",     "section" => "dhcp",  "arr" => 1, "mult" => "", "special" => 0 }, # TODO edit # =<domain>[,<address range>[,local]]
    "dhcp-fqdn"                 => { "idx" => 145, "valtype" => "bool",    "section" => "dhcp",  "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "dhcp-client-update"        => { "idx" => 146, "valtype" => "bool",    "section" => "dhcp",  "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "enable-ra"                 => { "idx" => 147, "valtype" => "bool",    "section" => "dhcp",  "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "ra-param"                  => { "idx" => 148, "valtype" => "var",     "section" => "dhcp",  "arr" => 0, "mult" => "", "special" => 0 }, # TODO edit # =<interface>,[mtu:<integer>|<interface>|off,][high,|low,]<ra-interval>[,<router lifetime>]
    "dhcp-reply-delay"          => { "idx" => 149, "valtype" => "var",     "section" => "dhcp",  "arr" => 0, "mult" => "", "special" => 0 }, # TODO edit # =[tag:<tag>,]<integer>
    "enable-tftp"               => { "idx" => 150, "valtype" => "string",  "section" => "t_b_p", "arr" => 0, "mult" => "", "special" => 0, "val_optional" => 1 }, # TODO edit # [=<interface>[,<interface>]]
    "tftp-root"                 => { "idx" => 151, "valtype" => "var",     "section" => "t_b_p", "arr" => 0, "mult" => "", "special" => 0 }, # TODO edit # =<directory>[,<interface>]
    "tftp-no-fail"              => { "idx" => 152, "valtype" => "bool",    "section" => "t_b_p", "arr" => 0, "mult" => "", "special" => 0, "default" => 0 }, # TODO edit
    "tftp-unique-root"          => { "idx" => 153, "valtype" => "var",     "section" => "t_b_p", "arr" => 0, "mult" => "", "special" => 0, "val_optional" => 1 }, # TODO edit # [=ip|mac]
    "tftp-secure"               => { "idx" => 154, "valtype" => "bool",    "section" => "t_b_p", "arr" => 0, "mult" => "", "special" => 0, "default" => 0 }, # TODO edit
    "tftp-lowercase"            => { "idx" => 155, "valtype" => "bool",    "section" => "t_b_p", "arr" => 0, "mult" => "", "special" => 0, "default" => 0 }, # TODO edit
    "tftp-max"                  => { "idx" => 156, "valtype" => "int",     "section" => "t_b_p", "arr" => 0, "mult" => "", "special" => 0 }, # TODO edit # =<connections>
    "tftp-mtu"                  => { "idx" => 157, "valtype" => "int",     "section" => "t_b_p", "arr" => 0, "mult" => "", "special" => 0 }, # TODO edit # =<mtu size>
    "tftp-no-blocksize"         => { "idx" => 158, "valtype" => "bool",    "section" => "t_b_p", "arr" => 0, "mult" => "", "special" => 0, "default" => 0 }, # TODO edit
    "tftp-port-range"           => { "idx" => 159, "valtype" => "var",     "section" => "t_b_p", "arr" => 0, "mult" => "", "special" => 0 }, # TODO edit # =<start>,<end>
    "tftp-single-port"          => { "idx" => 160, "valtype" => "bool",    "section" => "t_b_p", "arr" => 0, "mult" => "", "special" => 0, "default" => 0 }, # TODO edit
    "conf-file"                 => { "idx" => 161, "valtype" => "path",    "section" => "dns",   "arr" => 1, "mult" => "", "special" => 0 }, # TODO edit # =<file>
    "conf-dir"                  => { "idx" => 162, "valtype" => "var",     "section" => "dns",   "arr" => 1, "mult" => "", "special" => 0 }, # TODO edit # =<directory>[,<file-extension>......],
    "servers-file"              => { "idx" => 163, "valtype" => "file",    "section" => "dns",   "arr" => 1, "mult" => "", "special" => 0 }, # TODO edit # =<file>
);

our @confbools = ( ); # options which may not contain any parameters/values
our @confsingles = ( ); # options which may contain no more than one parameter/value
our @confarrs = ( ); # options which may be specified more than once
our @confdns = ( ); # options which are specific to DNS
our @confdhcp = ( ); # options which are specific to DHCP
our @conft_b_p = ( ); # options which are specific to TFTP/Bootp/PXE

my $key;
my $vals;
while ( ($key, $vals) = each %dnsmconfigvals ) {
    if ( $vals->{"valtype"} eq "bool" ) {
        push( @confbools, $key );
    }
    if ( $vals->{"valtype"} ne "var" ) {
        push( @confsingles, $key );
    }
    if ( $vals->{"arr"} == 1 ) {
        push( @confarrs, $key );
    }
    if ( $vals->{"section"} eq "dns") {
        push ( @confdns, $key );
    }
    if ( $vals->{"section"} eq "dhcp") {
        push ( @confdhcp, $key );
    }
    if ( $vals->{"section"} eq "t_b_p") {
        push ( @conft_b_p, $key );
    }
}
@confbools = (sort { $dnsmconfigvals{$a}->{"idx"} <=> $dnsmconfigvals{$b}->{"idx"} } @confbools );
@confsingles = (sort { $dnsmconfigvals{$a}->{"idx"} <=> $dnsmconfigvals{$b}->{"idx"} } @confsingles );
@confarrs = (sort { $dnsmconfigvals{$a}->{"idx"} <=> $dnsmconfigvals{$b}->{"idx"} } @confarrs );
@confdns = (sort { $dnsmconfigvals{$a}->{"idx"} <=> $dnsmconfigvals{$b}->{"idx"} } @confdns );
@confdhcp = (sort { $dnsmconfigvals{$a}->{"idx"} <=> $dnsmconfigvals{$b}->{"idx"} } @confdhcp );
@conft_b_p = (sort { $dnsmconfigvals{$a}->{"idx"} <=> $dnsmconfigvals{$b}->{"idx"} } @conft_b_p );

# our $IPADDR = "((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])";
our $IPADDR = "(?:(?:25[0-5]|(?:2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(?:25[0-5]|(?:2[0-4]|1{0,1}[0-9]){0,1}[0-9])";
# $IPV6ADDR = "([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])";
# our $IPV6ADDR = "[0-9a-fA-F\:]*";
our $IPV6ADDR = "[0-9a-fA-F]{1,4}\:+[0-9a-fA-F\:]*";
our $MAC = "(?:[0-9a-fA-F]{2})(?:[:-](?:[0-9a-fA-F]{2}|\\*)){5}";
our $TIME = "[0-9]{1,3}[mh]";
our $FILE = "[0-9a-zA-Z\_\.\/\-]+";
our $NUMBER="[0-9]+";
my $TAG = "(set|tag):([!0-9a-zA-Z\_\.\-]*)";
my $IPV6PROP = "ra-only|ra-names|ra-stateless|slaac";
my $OPTION = "option6?:([0-9a-zA-Z\-]*)|[0-9]{1,3}";
my $NAME = "[a-zA-Z\_\.][0-9a-zA-Z\_\.\-]*";
# my $DUID = "([0-9a-fA-F]{4}[:]{2}){1}([:][0-9a-fA-F]{4}){1,31}";
my $DUID = "id([:-][0-9a-fA-F]{2}){5,128}";
my $INFINIBAND = "id:[fF]{2}:00:00:00:00:00:02:00:00:02:[cC]9:00:([0-9a-fA-F]{2}[:-]){7}([0-9a-fA-F]{2})";
my $CLIENTID = "id:([0-9a-fA-F]{2}[:-]){3}([0-9a-fA-F]{2})";
my $CLIENTID_NAME = "id:([0-9a-zA-Z\_\*\-]*)";

#
# parse the configuration file and populate the %dnsmconfig structure
# 
sub parse_config_file {
    my $lineno;
    my ($dnsmconfig_ref, $config_file, $config_filename, $is_not_main_config) = @_;

    if ($is_not_main_config != 1) { # initialize the config with all known options 
                                    # (except those that can be specified multiple times)
        push ( @{ $$dnsmconfig_ref{"configfiles"} }, $config_filename);
        while ( ($key, $vals) = each %dnsmconfigvals ) {
            if ( ! grep { /^$key$/ } ( @confarrs ) ) {
                $$dnsmconfig_ref{$key}{"used"} = 0;
                $$dnsmconfig_ref{$key}{"line"} = -1;
                $$dnsmconfig_ref{$key}{"file"} = $config_filename;
            }
        }
    }
    else {
        push ( @{ $$dnsmconfig_ref{"configfiles"} }, $$config_filename);
    }

    $lineno=0;
    foreach my $line (@$$config_file) {
        my $remainder;
        my %temp;
        my $found = 0;
        my @line_set_tags = ( );
        
        $lineno++;
        if (defined ($line)) {
            #
            # we always use regexp starting with 
            # ^[\#]*[\s]*
            # because that allows for a commented out line with
            #  possibly space(s) between the comment marker and keyword
            # while rejecting any comments that carry our keyword
            #
            # reject lines blank at start!
            next if ($line !~ /^[0-9a-zA-Z\_\-\#]/);
            foreach my $b ( @confbools ) {
                # print $b;
                if ($line =~ /^[\#]*[\s]*$b[\s]*$/ ) {
                    if ($$dnsmconfig_ref{$b}{"used"} == 0) { # only overwrite if the last value read is not used (commented)
                        $$dnsmconfig_ref{$b}{"used"} = ($line!~/^\#/);
                        $$dnsmconfig_ref{$b}{"line"} = $lineno;
                        $$dnsmconfig_ref{$b}{"file"} = $config_filename;
                    }
                    $found = 1;
                    last;
                }
            }
            next if ($found == 1);
            if ($line =~ /(^[\#]*[\s]*([a-z0-9\-]+))\=(.*)$/ ) {
                my $option = $2;
                $remainder = $3;
                %temp = ( );
                $temp{"used"} = ($line !~ /^\#/);
                $temp{"line"} = $lineno;
                $temp{"file"} = $config_filename;
                $temp{"full"} = $line;
                # $temp{"filearray"}=\$config_file;
                if ( ! grep { /^$option$/ } ( keys %dnsmconfigvals ) ) {
                    print "Error in line $lineno ($option: unknown option)! ";
                    $$dnsmconfig_ref{"errors"}++;
                    next;
                }
                my %confvar = %dnsmconfigvals{"$option"};
                if ( $confvar{"mult"} ne "" ) {
                    my $sep = $confvar{"mult"};
                    # $temp{"val"} = @();
                    while ( $remainder =~ /^$sep?($NAME)($sep[0-9a-zA-Z\.\-\/]*)*/ ) {
                        push @{ $temp{"val"} }, ( $1 );
                        $remainder = $2;
                    }
                }
                elsif ( grep { /^$option$/ } ( @confsingles ) ) {
                    $temp{"val"} = $remainder;
                    # $temp{"val"} = "test";
                }
                else {
                    my %valtemp = ();
                    $valtemp{"full"} = $remainder;
                    if ($option eq "local") {
                        $option = "server";
                    }
                    given ( "$option" ){
                        when ("auth-server") { # =<domain>,[<interface>[/4|/6]|<ip-address>...]
                            if( $remainder =~ /^($NAME),(.*)$/ ) {
                                $valtemp{"domain"} = $1;
                                $remainder = $2;
                            }
                            if( $remainder =~ /^(.*)$/ ) {
                                $valtemp{"for"} = $1;
                            }
                        }
                        when ("alias") { # =[<old-ip>]|[<start-ip>-<end-ip>],<new-ip>[,<mask>]
                            $valtemp{"netmask-used"} = 0;
                            # our $IPADDR = "(?:(?:25[0-5]|(?:2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(?:25[0-5]|(?:2[0-4]|1{0,1}[0-9]){0,1}[0-9])";
                            if ( $remainder =~ /^($IPADDR\-$IPADDR)\,($IPADDR)\,($IPADDR)$/ ) { # range with netmask
                                $valtemp{"from"} = $1;
                                $valtemp{"to"} = $2;
                                $valtemp{"netmask"} = $3;
                                $valtemp{"netmask-used"} = 1;
                            }
                            elsif ( $remainder =~ /^($IPADDR\-$IPADDR)\,($IPADDR)$/ ) { # range without netmask
                                $valtemp{"from"} = $1;
                                $valtemp{"to"} = $2;
                            }
                            elsif ( $remainder =~ /^($IPADDR)\,($IPADDR)\,($IPADDR)$/ ) { # IP with netmask
                                $valtemp{"from"} = $1;
                                $valtemp{"to"} = $2;
                                $valtemp{"netmask"} = $3;
                                $valtemp{"netmask-used"} = 1;
                            }
                            elsif ( $remainder =~ /^($IPADDR)\,($IPADDR)$/ ) { # IP without netmask
                                $valtemp{"from"} = $1;
                                $valtemp{"to"} = $2;
                            }
                        }
                        when ("bogus-nxdomain") { # =<ipaddr>[/prefix]
                            if ( $remainder =~ /^($IPADDR(\/[0-9]{1,2})?)$/ ) {
                                $valtemp{"addr"} = $1;
                            }
                        }
                        when ("ignore-address") { # =<ipaddr>[/prefix]
                            if ( $remainder =~ /^\/($IPADDR(\/[0-9]{1,2})?)$/ ) {
                                $valtemp{"ip"} = $1;
                            }
                        }
                        when ("server") { # =[/[<domain>]/[domain/]][<ipaddr>[#<port>]][@<interface>][@<source-ip>[#<port>]]
                            while ( $remainder =~ /^\/((?:[a-z0-9](?:[a-z0-9\-]{0,61}[a-z0-9\.])?)+[a-z0-9][a-z0-9\-]{0,61}[a-z0-9])\/(.*)$/ ) {
                                push( @{ $valtemp{"domain"} }, $1 );
                                $remainder = $2;
                            }
                            if ( $remainder =~ /^($IPADDR(#[0-9]{1,5})?)(.*)$/ ) {
                                $valtemp{"ip"} = $1;
                                $remainder = $2;
                            }
                            elsif ( $remainder =~ /^($IPV6ADDR(%[a-zA-Z0-9])?)(.*)$/ ) {
                                $valtemp{"ip"} = $1;
                                $remainder = $2;
                            }
                            if ( $remainder =~ /^@(.*)$/ ) {
                                $valtemp{"source"} = $1;
                            }
                        }
                        when ("rev-server") { # =<ip-address>/<prefix-len>[,<ipaddr>][#<port>][@<interface>][@<source-ip>[#<port>]]
                            if ( $remainder =~ /^\/($IPADDR\/[0-9]{1,2})(,.*)$/ ) {
                                $valtemp{"domain"} = $1;
                                $remainder = $2;
                            }
                            if ( $remainder =~ /^\/($IPADDR(#[0-9]{1,5})?)(,.*)$/ ) {
                                $valtemp{"ip"} = $1;
                                $remainder = $2;
                            }
                            elsif ( $remainder =~ /^\/($IPV6ADDR(%[a-zA-Z0-9])?)(.*)$/ ) {
                                $valtemp{"ip"} = $1;
                                $remainder = $2;
                            }
                            if ( $remainder =~ /^@(.*)$/ ) {
                                $valtemp{"source"} = $1;
                            }
                        }
                        when ("address") { # =/<domain>[/<domain>...]/[<ipaddr>]
                            if ( $remainder =~ /^\/(.*)\/($IPADDR)?$/ ) {
                                $valtemp{"domain"}=$1;
                                if ( defined ($2) ) {
                                    $valtemp{"addr"}=$2;
                                }
                            }
                            elsif ( $remainder =~ /^\/(.*)\/($IPV6ADDR)?$/ ) {
                                $valtemp{"domain"}=$1;
                                if ( defined ($2) ) {
                                    $valtemp{"addr"}=$2;
                                }
                            }
                            else
                            {
                                print "Error in line $lineno (address)! ";
                                $$dnsmconfig_ref{"errors"}++;
                            }
                        }
                        when ("ipset") { # =/<domain>[/<domain>...]/<ipset>[,<ipset>...]
                            if ( $remainder =~ /^\/([a-zA-Z\_\.][0-9a-zA-Z\_\.\-\/]*)\/([0-9a-zA-Z\,\.\-]*)$/ ) {
                                $valtemp{"domains"}=$1;
                                $valtemp{"ipsets"}=$2;
                            }
                        }
                        when ("connmark-allowlist") { # =<connmark>[/<mask>][,<pattern>[/<pattern>...]]
                            if( $remainder =~ /^($NAME)(\/($NAME))?(,(.*))*$/ ) {
                                $valtemp{"connmark"} = $1;
                                if ( defined ($3) ) {
                                    $valtemp{"mask"} = $3;
                                }
                                if ( defined ($5) ) {
                                    $valtemp{"pattern"} = $5;
                                }
                            }
                            else {
                                $valtemp{"connmark"} = $remainder;
                            }
                        }
                        when ("mx-host") { # =<mx name>[[,<hostname>],<preference>]
                            if( $remainder =~ /^($NAME)((?:,)(.*))*$/ ) {
                                $valtemp{"mxname"} = $1;
                                $remainder = $3;
                                if ( $remainder =~ /^($NAME)((?:,)(.*))*$/ ) {
                                    $valtemp{"host"}=$1;
                                    $valtemp{"preference"}=$3;
                                }
                                else {
                                    $valtemp{"preference"}=$remainder;
                                }
                            }
                            else {
                                $valtemp{"mxname"}=$remainder;
                            }
                        }
                        when ("srv-host") { # =<_service>.<_prot>.[<domain>],[<target>[,<port>[,<priority>[,<weight>]]]]
                            if( $remainder =~ /^((_[a-zA-Z]*)\.(_[a-zA-Z]*)\.)(.*)$/ ) {
                                $valtemp{"service"} = $2;
                                $valtemp{"prot"} = $3;
                                $remainder = $4;
                                if ( $remainder =~ /^($NAME)((?:,)(.*))*$/ ) {
                                    $valtemp{"domain"}=$1;
                                    $remainder=$3;
                                }
                                if ( $remainder =~ /^($NAME)((?:,)(.*))*$/ ) {
                                    $valtemp{"target"}=$1;
                                    $remainder=$3;
                                    if ( $remainder =~ /^($NUMBER)((?:,)(.*))*$/ ) {
                                        $valtemp{"port"}=$1;
                                        $remainder=$3;
                                    }
                                }
                            }
                            else {
                                $valtemp{"mxname"}=$remainder;
                            }
                        }
                        when ("host-record") { # =<name>[,<name>....],[<IPv4-address>],[<IPv6-address>][,<TTL>]
                            if ( $remainder =~ /^(.*)((?:,)($IPADDR))((?:,)(.*))*$/ ) {
                                $valtemp{"ipv4"} = $3;
                                $remainder = $1 . $4;
                            }
                            if ( $remainder =~ /^(.*)((?:,)($IPV6ADDR))((?:,)(.*))*$/ ) {
                                $valtemp{"ipv6"} = $3;
                                $remainder = $1 . $4;
                            }
                            if ( $remainder =~ /^(.*)((?:,)([0-9]{1,5}))$/ ) {
                                $valtemp{"ttl"} = $3;
                                $remainder = $1;
                            }
                            $valtemp{"name"} = $remainder;
                        }
                        when ("dynamic-host") { # =<name>[,IPv4-address][,IPv6-address],<interface>
                            if ( $remainder =~ /^(.*)((?:,)($IPADDR))((?:,)(.*))$/ ) {
                                $valtemp{"ipv4"} = $3;
                                $remainder = $1 . $4;
                            }
                            if ( $remainder =~ /^(.*)((?:,)($IPV6ADDR))((?:,)(.*))$/ ) {
                                $valtemp{"ipv6"} = $3;
                                $remainder = $1 . $4;
                            }
                            if ( $remainder =~ /^(.*)((?:,)(.*))$/ ) {
                                $valtemp{"name"} = $1;
                                $valtemp{"interface"} = $3;
                            }
                        }
                        when ("txt-record") { # =<name>[[,<text>],<text>]
                            if ( $remainder =~ /^(.*)((?:,)(.*))$/ ) {
                                $valtemp{"name"} = $1;
                                $valtemp{"text"} = $3;
                            }
                        }
                        when ("ptr-record") { # =<name>[,<target>]
                            if ( $remainder =~ /^(.*)((?:,)(.*))$/ ) {
                                $valtemp{"name"} = $1;
                                if ( defined($3) ) {
                                    $valtemp{"target"} = $3;
                                }
                            }
                        }
                        when ("naptr-record") { # =<name>,<order>,<preference>,<flags>,<service>,<regexp>[,<replacement>]
                            if ( $remainder =~ /^(.*)((?:,)(.*))$/ ) {
                                $valtemp{"name"} = $1;
                                $remainder = $3;
                            }
                            if ( $remainder =~ /^(.*)((?:,)(.*))$/ ) {
                                $valtemp{"order"} = $1;
                                $remainder = $3;
                            }
                            if ( $remainder =~ /^(.*)((?:,)(.*))$/ ) {
                                $valtemp{"preference"} = $1;
                                $remainder = $3;
                            }
                            if ( $remainder =~ /^(.*)((?:,)(.*))$/ ) {
                                $valtemp{"flags"} = $1;
                                $remainder = $3;
                            }
                            if ( $remainder =~ /^(.*)((?:,)(.*))$/ ) {
                                $valtemp{"service"} = $1;
                                $remainder = $3;
                            }
                            if ( $remainder =~ /^(.*)((?:,)(.*))*$/ ) {
                                $valtemp{"regexp"} = $1;
                                if ( defined($3) ) {
                                    $valtemp{"replacement"} = $3;
                                }
                            }
                        }
                        when ("caa-record") { # =<name>,<flags>,<tag>,<value>
                            if ( $remainder =~ /^(.*)((?:,)(.*))$/ ) {
                                $valtemp{"name"} = $1;
                                $remainder = $3;
                            }
                            if ( $remainder =~ /^(.*)((?:,)(.*))$/ ) {
                                $valtemp{"flags"} = $1;
                                $remainder = $3;
                            }
                            if ( $remainder =~ /^(.*)((?:,)(.*))$/ ) {
                                $valtemp{"tag"} = $1;
                                $valtemp{"value"} = $3;
                            }
                        }
                        when ("cname") { # =<cname>,[<cname>,]<target>[,<TTL>]
                            if ( $remainder =~ /^(.*)((?:,)([0-9]{1,5}))$/ ) {
                                $valtemp{"ttl"} = $3;
                                $remainder = $1;
                            }
                            if ( $remainder =~ /^(.*)((?:,)(.*))$/ ) {
                                $valtemp{"target"} = $3;
                                $valtemp{"cname"} = $3;
                            }
                        }
                        when ("dns-rr") { # =<name>,<RR-number>,[<hex data>]
                            if ( $remainder =~ /^(.*)((?:,)(.*))$/ ) {
                                $valtemp{"name"} = $1;
                                $remainder = $3;
                            }
                            if ( $remainder =~ /^(.*)((?:,)(.*))*$/ ) {
                                $valtemp{"rrnumber"} = $1;
                                if ( defined($3) ) {
                                    $valtemp{"hexdata"} = $3;
                                }
                            }
                        }
                        when ("interface-name") { # =<name>,<interface>[/4|/6]
                            if ( $remainder =~ /^(.*)((?:,)(.*))$/ ) {
                                $valtemp{"name"} = $1;
                                $valtemp{"interface"} = $3;
                            }
                        }
                        when ("synth-domain") { # =<domain>,<address range>[,<prefix>[*]]
                            if ( $remainder =~ /^(.*)((?:,)(.*))$/ ) {
                                $valtemp{"domain"} = $1;
                                $remainder = $3;
                            }
                            if ( $remainder =~ /^(.*)((?:,)(.*))*$/ ) {
                                $valtemp{"addressrange"} = $1;
                                if ( defined($3) ) {
                                    $valtemp{"prefix"} = $3;
                                }
                            }
                        }
                        when ("add-subnet") { # [[=[<IPv4 address>/]<IPv4 prefix length>][,[<IPv6 address>/]<IPv6 prefix length>]]
                            if ( $remainder =~ /^($IPADDR(\/[0-9]{1,5})?)((?:,)(.*))*$/ ) {
                                $valtemp{"ipv4"} = $1;
                                $remainder = $4;
                            }
                            if ( $remainder =~ /^($IPV6ADDR(\/[0-9]{1,5})?)$/ ) {
                                $valtemp{"ipv6"} = $1;
                            }
                        }
                        when ("umbrella") { # [=deviceid:<deviceid>[,orgid:<orgid>]]
                            if ( $remainder =~ /^((?:deviceid:)(.*))((?:,orgid:)(.*))*$/ ) {
                                $valtemp{"deviceid"} = $2;
                                if ( defined($4) ) {
                                    $valtemp{"orgid"} = $4;
                                }
                            }
                        }
                        when ("trust-anchor") { # =[<class>,]<domain>,<key-tag>,<algorithm>,<digest-type>,<digest>
                            if ( $remainder =~ /^(.*)((?:,)(.*))$/ ) {
                                $valtemp{"digest"} = $3;
                                $remainder = $1;
                            }
                            if ( $remainder =~ /^(.*)((?:,)(.*))$/ ) {
                                $valtemp{"digesttype"} = $3;
                                $remainder = $1;
                            }
                            if ( $remainder =~ /^(.*)((?:,)(.*))$/ ) {
                                $valtemp{"algorithm"} = $3;
                                $remainder = $1;
                            }
                            if ( $remainder =~ /^(.*)((?:,)(.*))$/ ) {
                                $valtemp{"keytag"} = $3;
                                $remainder = $1;
                            }
                            if ( $remainder =~ /^(.*)((?:,)(.*))*$/ ) {
                                $valtemp{"domain"} = $1;
                                if ( defined($1) ) {
                                    $valtemp{"class"} = $1;
                                }
                            }
                        }
                        when ("auth-zone") { # =<domain>[,<subnet>[/<prefix length>][,<subnet>[/<prefix length>].....][,exclude:<subnet>[/<prefix length>]].....]
                            if ( $remainder =~ /^(.*)((?:,)(.*))$/ ) {
                                $valtemp{"domain"} = $1;
                                $remainder = $3;
                                if ( $remainder =~ /((?:exclude:)(.*))*$/ ) {
                                    while ( $remainder =~ /^(.*)((?:,exclude:)(.*))$/ ) {
                                        push( @{ $valtemp{"exclude"} }, $3 );
                                        $remainder = $1;
                                    }
                                }
                                if ( $remainder ne "" ) {
                                    while ( $remainder =~ /^(.*)((?:,)(.*))$/ ) {
                                        push( @{ $valtemp{"include"} }, $3 );
                                        $remainder = $1;
                                    }
                                }
                            }
                        }
                        when ("auth-soa") { # =<serial>[,<hostmaster>[,<refresh>[,<retry>[,<expiry>]]]]
                            if ( $remainder =~ /^(.*)((?:,)(.*))$/ ) {
                                $valtemp{"serial"} = $1;
                                $remainder = $3;
                                if ( $remainder =~ /^(.*)((?:,)(.*))*$/ ) {
                                    $valtemp{"hostmaster"} = $1;
                                    $remainder = $3;
                                    if ( $remainder =~ /^(.*)((?:,)(.*))*$/ ) {
                                        $valtemp{"refresh"} = $1;
                                        $remainder = $3;
                                        if ( $remainder =~ /^(.*)((?:,)(.*))*$/ ) {
                                            $valtemp{"retry"} = $1;
                                            $remainder = $3;
                                            if ( $remainder =~ /^(.*)((?:,)(.*))*$/ ) {
                                                $valtemp{"expiry"} = $1;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        when ("dhcp-range") { # =[tag:<tag>[,tag:<tag>],][set:<tag>,]<start-addr>[,<end-addr>|<mode>][,<netmask>[,<broadcast>]][,<lease time>] -OR- =[tag:<tag>[,tag:<tag>],][set:<tag>,]<start-IPv6addr>[,<end-IPv6addr>|constructor:<interface>][,<mode>][,<prefix-len>][,<lease time>]
                            while ($remainder =~ /^($TAG)\,([0-9a-zA-Z\.\,\-\_: ]*)/ ) { # first get tag
                                my $tagdirective = $1;
                                $remainder = $4;
                                if ($tagdirective =~ /^(set|tag):([0-9a-zA-Z\-\_]*)/) {
                                    my %valtemp_tag = ();
                                    $valtemp_tag{"tag-set"} = ($1 eq "set");
                                    my $tag = $2;
                                    $valtemp_tag{"tagname"} = $tag;

                                    push(@line_set_tags, $tag);

                                    push @{ $valtemp{"tag"} }, { %valtemp_tag };
                                    # if ( $valtemp_tag{"tag-set"} ) {
                                    #     if ( ! grep { /^$tag$/ } ( @line_set_tags ) ) {
                                    #         push(@line_set_tags, $tag);
                                    #     }
                                    # }
                                }
                            }
                            $valtemp{"ipversion"} = 4;
                            if ($remainder =~ /^($IPADDR)((?:\,)([0-9a-zA-Z\.\,\-\_]*))*/ ) { # IPv4
                                # ...start...
                                $valtemp{"start"} = $1;
                                $remainder = $3;
                                if ($remainder =~ /^($IPADDR)((?:\,)([0-9a-zA-Z\.\,\-\_]*))*/ ) {
                                    # ...end...
                                    $valtemp{"end"} = $1;
                                    $remainder = $3;
                                }
                                $valtemp{"mask"}="";
                                $valtemp{"mask-used"}=0;
                                if ($remainder =~ /^($IPADDR)((?:\,)([0-9a-zA-Z\.\,\-\_]*))*/ ) {
                                    # ...netmask, time (optionally)
                                    $valtemp{"mask"} = $1;
                                    $valtemp{"mask-used"}=1;
                                    $remainder = $3;
                                }
                                if ($remainder =~ /^(static)((?:\,)([0-9a-zA-Z\.\,\-\_]*))*/ ) {
                                    $valtemp{"static"} = $1;
                                    $remainder = $3;
                                }
                                if ($remainder =~ /^($TIME)/ ) {
                                    # ...time (optionally)
                                    $valtemp{"leasetime"} = $1;
                                    $valtemp{"time-used"} = ($1 =~ /^\d/);
                                    $remainder = $2;
                                }
                            }
                            elsif ($remainder =~ /^($IPV6ADDR)\,[\s]*([0-9a-zA-Z\.\,\-\_: ]*)/ ) { # IPv6
                                # start...
                                # $temp{"id"}="";
                                $valtemp{"id-used"} = 0;
                                $valtemp{"start"} = $1;
                                $remainder = $2 . $3;
                                $valtemp{"prefix-length"} = 64;
                                $valtemp{"ipversion"} = 6;
                                if ($remainder =~ /^($IPV6ADDR)\,[\s]*([0-9a-zA-Z\.\,\-\_: ]*)/ ) {
                                    # ...end
                                    $valtemp{"end"} = $1;
                                    $remainder = $2 . $3;
                                }
                                $valtemp{"ra-only"} = 0;
                                $valtemp{"ra-names"} = 0;
                                $valtemp{"ra-stateless"} = 0;
                                $valtemp{"slaac"} = 0;
                                while ($remainder =~ /^($IPV6PROP)(\,[\s]*([0-9a-zA-Z\.\,\-\_: ]*))*/ ) {
                                    # ...IPv6-only properties
                                    if ($1 eq "ra-only") {
                                        $valtemp{"ra-only"} = 1;
                                    }
                                    if ($1 eq "ra-names") {
                                        $valtemp{"ra-names"} = 1;
                                    }
                                    if ($1 eq "ra-stateless") {
                                        $valtemp{"ra-stateless"} = 1;
                                    }
                                    if ($1 eq "slaac") {
                                        $valtemp{"slaac"} = 1;
                                    }
                                    $remainder = $3;
                                }
                                if ($remainder =~ /^([0-9]{1,3})\,[\s]*($TIME)/ ) {
                                    # ...prefix-length, time (optionally)
                                    $valtemp{"prefix-length"} = $1;
                                    $valtemp{"leasetime"}=$2;
                                    $valtemp{"time-used"}=($2 =~ /^\d/);
                                }
                                elsif ($remainder =~ /^($TIME)/ ) {
                                    # ...time (optionally)
                                    $valtemp{"leasetime"}=$1;
                                    $valtemp{"time-used"}=($1 =~ /^\d/);
                                }
                            }
                            else
                            {
                                print "Error in line $lineno (dhcp-range)! ";
                                $$dnsmconfig_ref{"errors"}++;
                            }
                        }
                        when ("dhcp-host") { # =[<hwaddr>][,id:<client_id>|*][,set:<tag>][tag:<tag>][,<ipaddr>][,<hostname>][,<lease_time>][,ignore]
                            if ($remainder =~ /^(([0-9a-zA-Z\,\.\-\_: ]*)(\,))(($TIME)|infinite)$/ && defined ($4)) {
                                # time (optional)
                                $remainder = $2;
                                $valtemp{"leasetime"}=$4;
                                $valtemp{"time-used"}=($4 =~ /^\d/);
                            }
                            if ($remainder =~ /^([0-9a-zA-Z\.\,\-\_:\* ]*)($TAG)((,)([0-9a-zA-Z\.\,\-\_:\* ]*))*$/ && defined ($3) && defined ($4)) {
                                $valtemp{"tag-set"}=($3 eq "set");
                                $valtemp{"tagname"}=$4;
                                $remainder = $1 . $7;
                            }
                            $valtemp{"mac"} = "";
                            $valtemp{"ipversion"} = 4;
                            if ($remainder =~ /^([0-9a-zA-Z\.\,\-\_:]*)($INFINIBAND)(,([0-9a-zA-Z\.\,\-\_:\*]*))*$/ && defined ($2)) {
                                $remainder = $1 . $6;
                                $valtemp{"infiniband"}=$2; # TODO - infiniband?
                            }
                            elsif ($remainder =~ /^([0-9a-zA-Z\.\,\-\_:]*)($CLIENTID)(,([0-9a-zA-Z\.\,\-\_:\*]*))*$/ && defined ($2)) {
                                $remainder = $1 . $6;
                                $valtemp{"clientid"}=$2;
                            }
                            elsif ($remainder =~ /^(([0-9a-zA-Z\.\,\-\_:\[\]]*,[\h]*)*)($DUID)((,[\h]*([0-9a-zA-Z\.\,\-\_\:\[\]]*))*)$/ && defined ($3)) {
                                $valtemp{"clientid"} = $3;
                                $valtemp{"ipversion"} = 6;
                                my $firstpart = $1;
                                my $lastpart = $5;
                                if ($firstpart =~ /(.*)(,[\h]*)$/) {
                                    $firstpart = $1;
                                }
                                if ($lastpart =~ /^(,[\h]*)(.*)/) {
                                    $lastpart = $2;
                                }
                                $remainder = $firstpart . (defined($firstpart) && defined($lastpart) ? ", " . $lastpart : $lastpart);
                            }
                            else {
                                while ($remainder =~ /^([0-9a-zA-Z\.\,\-\_:\*]*)($MAC)(,([0-9a-zA-Z\.\,\-\_:\*]*))*$/ ) { # IPv4 only
                                    $remainder = $1 . $4;
                                    if (defined ($2)) {
                                        $valtemp{"mac"} = ($valtemp{"mac"} eq "" ? $2 : $2 . "," . $valtemp{"mac"});
                                    }
                                    else {
                                        last;
                                    }
                                }
                            }
                            if ($remainder =~ /^([0-9a-zA-Z\.\,\-\_:\*]*)($CLIENTID_NAME)(,([0-9a-zA-Z\.\,\-\_:\*]*))*$/ && defined ($2)) {
                                $remainder = $1 . $5;
                                $valtemp{"clientid"} = $2;
                                if ($valtemp{"mac"} ne "") {
                                    $valtemp{"ignore-clientid"} = $valtemp{"clientid"};
                                    $valtemp{"clientid"} = "";
                                }
                            }
                            if ($remainder =~ /^(([0-9a-zA-Z\.\,\-\_:\*]*)(,))*(ignore)$/  && defined ($4)) {
                                # ...time (optionally)
                                $remainder = $2;
                                $valtemp{"leasetime"} = "ignore";
                            }
                            if ($remainder =~ /^((?:[0-9a-zA-Z\,\-\_:]*)(?:,))*($IPADDR)(,([0-9a-zA-Z\.\,\-\_:]*))*$/ && defined ($2)) {
                                $remainder = $1 . (defined ($3) && defined ($4) ? "," . $4 : "");
                                $valtemp{"ip"} = $2;
                            }
                            elsif ($remainder =~ /^(([0-9a-zA-Z\,\-\_\:]*\,\h*)*)(\[($IPV6ADDR)\])(,\h*[0-9a-zA-Z\.\-\_:]*)*\h*$/ && defined ($3)) { # IPv6
                                $remainder= $1 . (defined ($1) && defined ($5) ? "," . $5 : "");
                                $valtemp{"ip"} = $3;
                                $valtemp{"ipversion"} = 6;
                            }
                            $valtemp{"id-used"} = 0;
                            if ($remainder =~ /^([\h\,]*)($NAME)([\h\,]*)$/ ) {
                                # network id...
                                $valtemp{"id"}=$2;
                                $valtemp{"id-used"} = 1;
                                # $remainder = $2;
                            }
                            # $temp{"id"}=$remainder;
                            # $temp{"id-used"} = 1;
                        }
                        when ("dhcp-option") { # =[tag:<tag>,[tag:<tag>,]][encap:<opt>,][vi-encap:<enterprise>,][vendor:[<vendor-class>],][<opt>|option:<opt-name>|option6:<opt>|option6:<opt-name>],[<value>[,<value>]]
                            # too many to classify - all values as string!
                            $remainder =~ s/^\s+|\s+$//g ;
                            $valtemp{"forced"} = 0;
                            $valtemp{"tag"} = ( );
                            # $TAG = "(set|tag):([0-9a-zA-Z\_\.\-]*)";
                            while ($remainder =~ /^($TAG)((,[\s]*)([0-9a-zA-Z\,\_\.:;\-\/\\ \'\"\=\[\]\#\(\)]*))*$/) {
                                my $tag  = $3;
                                push @{ $valtemp{"tag"} }, $tag;
                                $remainder = $6;
                                $remainder =~ s/^\s+|\s+$//g ;
                            }
                            if ($remainder =~ /^(vendor:([a-zA-Z\-\_]*))((,[\s]*)([0-9a-zA-Z\,\_\.:;\-\/\\ \'\"\=\[\]\#\(\)]*))*$/) {
                                $valtemp{"vendor"} = $2;
                                $remainder = $5;
                                $remainder =~ s/^\s+|\s+$//g ;
                            }
                            if ($remainder =~ /^(encap:([0-9a-zA-Z\-\_]*))(([\s]*,[\s]*)([0-9a-zA-Z\,\_\.:;\-\/\\ \'\"\=\[\]\#\(\)]*))*$/) {
                                $valtemp{"encap"} = $2;
                                $remainder = $5;
                                $remainder =~ s/^\s+|\s+$//g ;
                            }
                            if ($remainder =~ /^(vi-encap:([0-9a-zA-Z\-\_]*))(([\s]*,[\s]*)([0-9a-zA-Z\,\_\.:;\-\/\\ \'\"\=\[\]\#\(\)]*))*$/) {
                                $valtemp{"vi-encap"} = $2;
                                $remainder = $5;
                                $remainder =~ s/^\s+|\s+$//g ;
                            }
                            # $OPTION = "option6?:([0-9a-zA-Z\-]*)|[0-9]{1,3}";
                            if ($remainder =~ /^($OPTION)(([\s]*,[\s]*)?([0-9a-zA-Z\,\_\.:;\-\/\\ \'\"\=\[\]\#\(\)]*))$/) {
                                $valtemp{"option"} = (defined ($2) ? $2 : $1);
                                my $opt_id = $1;
                                my $val = $5;
                                $val =~ s/^\s+|\s+$//g ;
                                $valtemp{"value"} = $val;
                                $valtemp{"ipversion"} = $opt_id =~ /^option6/ ? 6 : 4;
                            }
                        }
                        when ("dhcp-option-force") { # =[tag:<tag>,[tag:<tag>,]][encap:<opt>,][vi-encap:<enterprise>,][vendor:[<vendor-class>],][<opt>|option:<opt-name>|option6:<opt>|option6:<opt-name>],[<value>[,<value>]]
                            $option = "dhcp-option";
                            # too many to classify - all values as string!
                            $remainder =~ s/^\s+|\s+$//g ;
                            $valtemp{"forced"} = 1;
                            $valtemp{"tag"} = ( );
                            # $TAG = "(set|tag):([0-9a-zA-Z\_\.\-]*)";
                            while ($remainder =~ /^($TAG)((,[\s]*)([0-9a-zA-Z\,\_\.:;\-\/\\ \'\"\=\[\]\#\(\)]*))*$/) {
                                my $tag  = $3;
                                push @{ $valtemp{"tag"} }, $tag;
                                $remainder = $6;
                                $remainder =~ s/^\s+|\s+$//g ;
                            }
                            if ($remainder =~ /^(vendor:([a-zA-Z\-\_]*))((,[\s]*)([0-9a-zA-Z\,\_\.:;\-\/\\ \'\"\=\[\]\#]*))*$/) {
                                $valtemp{"vendor"} = $2;
                                $remainder = $5;
                                $remainder =~ s/^\s+|\s+$//g ;
                            }
                            if ($remainder =~ /^(encap:([0-9a-zA-Z\-\_]*))(([\s]*,[\s]*)([0-9a-zA-Z\,\_\.:;\-\/\\ \'\"\=\[\]\#]*))*$/) {
                                $valtemp{"encap"} = $2;
                                $remainder = $5;
                                $remainder =~ s/^\s+|\s+$//g ;
                            }
                            if ($remainder =~ /^(vi-encap:([0-9a-zA-Z\-\_]*))(([\s]*,[\s]*)([0-9a-zA-Z\,\_\.:;\-\/\\ \'\"\=\[\]\#]*))*$/) {
                                $valtemp{"vi-encap"} = $2;
                                $remainder = $5;
                                $remainder =~ s/^\s+|\s+$//g ;
                            }
                            # $OPTION = "option6?:([0-9a-zA-Z\-]*)|[0-9]{1,3}";
                            if ($remainder =~ /^($OPTION)(([\s]*,[\s]*)?([0-9a-zA-Z\,\_\.:;\-\/\\ \'\"\=\[\]\#\(\)]*))$/) {
                                $valtemp{"option"} = (defined ($2) ? $2 : $1);
                                my $opt_id = $1;
                                my $val = $5;
                                $val =~ s/^\s+|\s+$//g ;
                                $valtemp{"value"} = $val;
                                $valtemp{"ipversion"} = $opt_id =~ /^option6/ ? 6 : 4;
                            }
                        }
                        when ("dhcp-relay") { # =<local address>,<server address>[,<interface]
                            if ( $remainder =~ /^(.*)((?:,)(.*))$/ ) {
                                $valtemp{"local"} = $1;
                                $remainder = $3;
                            }
                            if ( $remainder =~ /^(.*)((?:,)(.*))*$/ ) {
                                $valtemp{"server"} = $1;
                                if ( defined($3) ) {
                                    $valtemp{"interface"} = $3;
                                }
                            }
                        }
                        when ("dhcp-vendorclass") { # =set:<tag>,[enterprise:<IANA-enterprise number>,]<vendor-class>
                            if ( $remainder =~ /^($TAG|([0-9a-zA-Z\_\.\-]*))\,([0-9a-zA-Z\,\.\-\:]*)$/ ) {
                                $valtemp{"tag"} = (defined ($4)) ? $4 : $3;
                                $valtemp{"vendorclass"} = $5;
                            }
                        }
                        when ("dhcp-userclass") { # =set:<tag>,<user-class>
                            if ( $remainder =~ /^($TAG|([0-9a-zA-Z\_\.\-]*))\,([0-9a-zA-Z\,\.\-\:]*)$/ ) {
                                $valtemp{"tag"} = (defined ($4)) ? $4 : $3;
                                $valtemp{"userclass"} = $5;
                            }
                        }
                        when ("dhcp-mac") { # =set:<tag>,<MAC address>
                            if ( $remainder =~ /^($TAG)\,($MAC)$/ ) {
                                $valtemp{"tag"} = $3;
                                $valtemp{"mac"} = $4;
                            }
                        }
                        when ("dhcp-circuitid") { # =set:<tag>,<circuit-id>
                            if ( $remainder =~ /^($TAG|([0-9a-zA-Z\_\.\-]*))\,([0-9a-zA-Z\,\.\-\:]*)$/ ) {
                                $valtemp{"tag"} = (defined ($4)) ? $4 : $3;
                                $valtemp{"circuitid"} = $5;
                            }
                        }
                        when ("dhcp-remoteid") { # =set:<tag>,<remote-id>
                            if ( $remainder =~ /^($TAG|([0-9a-zA-Z\_\.\-]*))\,([0-9a-zA-Z\,\.\-\:]*)$/ ) {
                                $valtemp{"tag"} = (defined ($4)) ? $4 : $3;
                                $valtemp{"remoteid"} = $5;
                            }
                        }
                        when ("dhcp-subscrid") { # =set:<tag>,<subscriber-id>
                            if ( $remainder =~ /^($TAG|([0-9a-zA-Z\_\.\-]*))\,([0-9a-zA-Z\,\.\-\:]*)$/ ) {
                                $valtemp{"tag"} = (defined ($4)) ? $4 : $3;
                                $valtemp{"subscriberid"} = $5;
                            }
                        }
                        when ("dhcp-match") { # =set:<tag>,<option number>|option:<option name>|vi-encap:<enterprise>[,<value>]
                            if ( $remainder =~ /^($TAG),(.*)$/ ) {
                                $valtemp{"tag"} = $3;
                                $remainder = $4;
                            }
                            if ($remainder =~ /^(vi-encap:([0-9a-zA-Z\-\_]*))(([\s]*,[\s]*)([0-9a-zA-Z\,\_\.:;\-\/\\ \'\"\=\[\]\#]*))*$/) {
                                $valtemp{"vi-encap"} = $2;
                                $remainder = $5;
                                $remainder =~ s/^\s+|\s+$//g ;
                            }
                            elsif ($remainder =~ /^($OPTION)(([\s]*,[\s]*)?([0-9a-zA-Z\,\_\.:;\-\/\\ \'\"\=\[\]\#]*))$/) {
                                $valtemp{"option"} = (defined ($2) ? $2 : $1);
                                $valtemp{"ipversion"} = $1 =~ /^option6/ ? 6 : 4;
                                $remainder = $5;
                                $remainder =~ s/^\s+|\s+$//g ;
                            }
                            my $dhcpmatchval = '';
                            if ($remainder =~ /^(\S+)$/) {
                                $dhcpmatchval = $1;
                                $dhcpmatchval =~ s/^\s+|\s+$//g ;
                                $valtemp{"value"} = $dhcpmatchval;
                            }
                        }
                        when ("dhcp-name-match") { # =set:<tag>,<name>[*]
                            if ( $remainder =~ /^($TAG|([0-9a-zA-Z\_\.\-]*))\,([0-9a-zA-Z\,\.\-\:]*)$/ ) {
                                $valtemp{"tag"} = (defined ($4)) ? $4 : $3;
                                $valtemp{"name"} = $5;
                            }
                        }
                        when ("tag-if") { # =set:<tag>[,set:<tag>[,tag:<tag>[,tag:<tag>]]]
                            while ( $remainder =~ /^((set:)([0-9a-zA-Z\_\.\-!]*))\,([0-9a-zA-Z\,\.\-\:]*)$/ ) {
                                push( @{ $valtemp{"settag"} }, $3 );
                                $remainder = $4;
                            }
                            while ( $remainder =~ /^((tag:)([0-9a-zA-Z\_\.\-!]*))\,([0-9a-zA-Z\,\.\-\:]*)$/ ) {
                                push( @{ $valtemp{"iftag"} }, $3 );
                                $remainder = $4;
                            }
                        }
                        when ("dhcp-ignore") { # =tag:<tag>[,tag:<tag>]
                            while ( $remainder =~ /^((tag:)([0-9a-zA-Z\_\.\-!]*))\,([0-9a-zA-Z\,\.\-\:]*)$/ ) {
                                push( @{ $valtemp{"tag"} }, $3 );
                                $remainder = $4;
                            }
                        }
                        when ("dhcp-ignore-names") { # [=tag:<tag>[,tag:<tag>]]
                            while ( $remainder =~ /^((tag:)([0-9a-zA-Z\_\.\-!]*))\,([0-9a-zA-Z\,\.\-\:]*)$/ ) {
                                push( @{ $valtemp{"tag"} }, $3 );
                                $remainder = $4;
                            }
                        }
                        when ("dhcp-generate-names") { # =tag:<tag>[,tag:<tag>]
                            while ( $remainder =~ /^((tag:)([0-9a-zA-Z\_\.\-!]*))\,([0-9a-zA-Z\,\.\-\:]*)$/ ) {
                                push( @{ $valtemp{"tag"} }, $3 );
                                $remainder = $4;
                            }
                        }
                        when ("dhcp-broadcast") { # [=tag:<tag>[,tag:<tag>]]
                            while ( $remainder =~ /^((tag:)([0-9a-zA-Z\_\.\-!]*))\,([0-9a-zA-Z\,\.\-\:]*)$/ ) {
                                push( @{ $valtemp{"tag"} }, $3 );
                                $remainder = $4;
                            }
                        }
                        when ("dhcp-boot") { # =[tag:<tag>,]<filename>,[<servername>[,<server address>|<tftp_servername>]]
                            if ( $remainder =~ /^($TAG),(.*)$/ ) {
                                $valtemp{"tag"} = $3;
                                $remainder = $4;
                            }
                            if ( $remainder =~ /^([0-9a-zA-Z\.\-\_\/]+)\,(.*)$/ ) {
                                $valtemp{"filename"} = $1;
                                $remainder = $2;
                            }
                            if ( $remainder =~ /^($NAME)\,(.*)$/ ) {
                                $valtemp{"host"} = $1;
                                $valtemp{"address"} = $2;
                            }
                            else {
                                $valtemp{"host"} = $remainder;
                                $valtemp{"address"} = '';
                            }
                        }
                        when ("pxe-service") { # =[tag:<tag>,]<CSA>,<menu text>[,<basename>|<bootservicetype>][,<server address>|<server_name>]
                            if ( $remainder =~ /^($TAG),(.*)$/ ) {
                                $valtemp{"tag"} = $3;
                                $remainder = $4;
                            }
                            if ( $remainder =~ /^([0-9a-zA-Z\_\-]*),(.*)$/ ) {
                                $valtemp{"csa"} = $1;
                                $remainder = $2;
                            }
                            if ( $remainder =~ /^(.*),(.*)$/ ) {
                                $valtemp{"menutext"} = $1;
                                $remainder = $2;
                                if ( $remainder =~ /^(.*),(.*)$/ ) {
                                    $valtemp{"basename"} = $1;
                                    $valtemp{"server"} = $2;
                                }
                                else {
                                    $valtemp{"basename"} = $remainder;
                                }
                            }
                            else {
                                $valtemp{"menutext"} = $remainder;
                            }
                        }
                        when ("pxe-prompt") { # =[tag:<tag>,]<prompt>[,<timeout>]
                            if ( $remainder =~ /^($TAG),(.*)$/ ) {
                                $valtemp{"tag"} = $3;
                                $remainder = $4;
                            }
                            if ( $remainder =~ /^(.*)\,([0-9]{1,9})$/ ) {
                                $valtemp{"prompt"} = $1;
                                $valtemp{"timeout"} = $2;
                            }
                            else {
                                $valtemp{"prompt"} = $remainder;
                            }
                        }
                        when ("dhcp-alternate-port") { # [=<server port>[,<client port>]]
                            if ( $remainder =~ /^(.*)((?:,)(.*))*$/ ) {
                                $valtemp{"serverport"} = $1;
                                if ( defined ($3) ) {
                                    $valtemp{"clientport"} = $3;
                                }
                            }
                        }
                        when ("dhcp-duid") { # =<enterprise-id>,<uid>
                            if ( $remainder =~ /^(.*),(.*)$/ ) {
                                $valtemp{"enterpriseid"} = $1;
                                $valtemp{"uid"} = $2;
                            }
                        }
                        when ("bridge-interface") { # =<interface>,<alias>[,<alias>]
                            if ( $remainder =~ /^(.*),(.*)$/ ) {
                                $valtemp{"interface"} = $1;
                                $remainder = $2;
                                while ( $remainder =~ /^(.*)((?:,)(.*))*$/ ) {
                                    push( @{ $valtemp{"alias"} }, $1 );
                                    $remainder = $3;
                                }
                            }
                        }
                        when ("shared-network") { # =<interface|addr>,<addr>
                            if ( $remainder =~ /^(.*),(.*)$/ ) {
                                $valtemp{"interface"} = $1;
                                $valtemp{"addr"} = $2;
                            }
                        }
                        when ("domain") { # =<domain>[,<address range>[,local]]
                            if ( $remainder =~ /^($NAME|\#)\,([0-9a-zA-Z\,\.\/]*)$/ ) {
                                $valtemp{"domain"} = $1;
                                $remainder = $2;
                                $valtemp{"range"} = '';
                                $valtemp{"local"} = 0;
                                if ( $remainder =~ /^([0-9\.]*)\,([0-9\.]*)$/ ) {
                                    # range = <ip address>,<ip address>
                                    $valtemp{"range"} = $1 . '-' . $2;
                                }
                                elsif ( $remainder =~ /^(([0-9a-z\,\.\/]*)\/(8|16|24))([0-9a-z\,\.\/]*)$/ ) {
                                    # range = <ip address>/<netmask>
                                    $valtemp{"range"} = $1;
                                    if ( $remainder =~ /^(.*),\s*local$/ ) {
                                        $valtemp{"local"} = 1;
                                    }
                                }
                                else {
                                    $valtemp{"range"} = $remainder;
                                }
                            }
                            else {
                                $valtemp{"domain"} = $remainder;
                            }
                        }
                        when ("ra-param") { # =<interface>,[mtu:<integer>|<interface>|off,][high,|low,]<ra-interval>[,<router lifetime>]
                            if ( $remainder =~ /^(.*)\,(.*)$/ ) {
                                $valtemp{"interface"} = $1;
                                $remainder = $2;
                                if ( $remainder =~ /^((?:mtu:)(.*))((?:,)(.*))$/ ) {
                                    $valtemp{"mtu"} = $2;
                                    $remainder = $4;
                                }
                                if ( $remainder =~ /^(high|low)((?:,)(.*))$/ ) {
                                    $valtemp{"priority"} = $1;
                                    $remainder = $3;
                                }
                                if ( $remainder =~ /^(.*)((?:,)(.*))*$/ ) {
                                    $valtemp{"interval"} = $1;
                                    $valtemp{"lifetime"} = $3;
                                }
                                else {
                                    $valtemp{"interval"} = $remainder;
                                }
                            }
                        }
                        when ("dhcp-reply-delay") { # =[tag:<tag>,]<integer>
                            if ( $remainder =~ /^($TAG),(.*)$/ ) {
                                $valtemp{"tag"} = $3;
                                $remainder = $4;
                            }
                            $valtemp{"delay"} = $remainder;
                        }
                        when ("tftp-root") { # =<directory>[,<interface>]
                            if ( $remainder =~ /^(.*),(.*)$/ ) {
                                $valtemp{"directory"} = $1;
                                $valtemp{"interface"} = $2;
                            }
                            else {
                                $valtemp{"directory"} = $remainder;
                            }
                        }
                        when ("tftp-unique-root") { # [=ip|mac]
                            $valtemp{"ip"} = "";
                            $valtemp{"mac"} = "";
                            if ( $remainder =~ /^($IPADDR)$/ ) {
                                $valtemp{"ip"} = $1;
                            }
                            else {
                                $valtemp{"mac"} = $1;
                            }
                        }
                        when ("tftp-port-range") { # =<start>,<end>
                            if ( $remainder =~ /^(.*),(.*)$/ ) {
                                $valtemp{"start"} = $1;
                                $valtemp{"end"} = $2;
                            }
                        }
                        when ("conf-file") {
                            # # Include another lot of configuration options.
                            # #conf-file=/etc/dnsmasq.reservations.conf
                            # #conf-file=/etc/dnsmasq.more.conf
                            $valtemp{"filename"}=$remainder;

                            if ($line !~/^\#/) {
                                my $supp_config_filename = $remainder;
                                my $supp_config_file = &read_file_lines( $supp_config_filename );
                                &parse_config_file( \%$dnsmconfig_ref, \$supp_config_file, \$supp_config_filename, 1 );
                            }
                        }
                        when ("conf-dir") {
                            # # Include another lot of configuration options.
                            # #conf-dir=/etc/dnsmasq.d

                            #  # Include all the files in a directory except those ending in .bak
                            # #conf-dir=/etc/dnsmasq.d,.bak

                            # # Include all files in a directory which end in .conf
                            # conf-dir=/etc/dnsmasq.d/,*.conf
                            my $filter = "";
                            my $exceptions = "";
                            if ( $remainder =~ /^([a-zA-Z0-9\_\.\/]*)\,([a-zA-Z0-9\.*]*)/ ) {
                                $valtemp{"dirname"}=$1;
                                $remainder = $2;
                                $valtemp{"filter"} = "";
                                $valtemp{"exceptions"} = "";
                                if ( $remainder =~ /^\*\.([a-zA-Z0-9\.]*)$/ ) { # Include all files in a directory which end in .*
                                    $filter = ".$1";
                                    $valtemp{"filter"} = "*$filter";
                                }
                                elsif ( $remainder =~ /^[\.]([a-zA-Z0-9\.]*)$/ ) { # Include all the files in a directory except those ending in .*
                                    $exceptions = ".$1";
                                    $valtemp{"exceptions"} = $exceptions;
                                }
                            }
                            else {
                                $valtemp{"dirname"}=$remainder;
                            }

                            if ($line !~ /^\#/) {
                                my @filenames = glob ( $valtemp{"dirname"} . "*" );
                                foreach my $supp_config_filename (@filenames) {
                                    if ($filter ne "") {
                                        next if $supp_config_filename !~ /$filter$/;
                                    }
                                    elsif ($exceptions ne "") {
                                        next if $supp_config_filename =~ /$exceptions$/ ;
                                    }
                                    my $supp_config_file = &read_file_lines( $supp_config_filename );
                                    &parse_config_file( \%$dnsmconfig_ref, \$supp_config_file, \$supp_config_filename, 1 );
                                }
                            }
                        }
                        default {

                        }
                    }
                    $temp{"val"} = { %valtemp };
                }
                if ( grep { /^$option$/ } ( @confarrs ) ) {
                    push @{ $$dnsmconfig_ref{"$option"} }, { %temp };
                }
                else {
                    if ($$dnsmconfig_ref{"$option"}{"used"} == 0) {
                        $$dnsmconfig_ref{"$option"} = { %temp };
                    }
                }
                foreach my $set_tag ( @line_set_tags ) {
                    if (! grep { /^$set_tag$/ } ( @{ $$dnsmconfig_ref{"set_tags"} } ) ) {
                        # print "setting tag: $set_tag<br/>";
                        push( @{ $$dnsmconfig_ref{"set_tags"} }, $set_tag );
                    }
                    # print "setting tag: $set_tag<br/>";
                    # push( @{ $$dnsmconfig_ref{"set_tags"} }, $set_tag );
                }
            }
            # resolv.conf file
            # if (1 == 2) {

            # }
            # # DHCP
            # # A SRV record sending LDAP for the first domain to second domain at the specified port
            # elsif ($line =~ /(^[\#]*[\s]*srv-host\=)($NAME)\,($NAME)\,([0-9]{1,5})/ ) {
            #     %temp = {};
            #     $temp{"source"}=$2;
            #     $temp{"target"}=$3;
            #     $temp{"port"}=$4;
            #     $temp{"used"}=($line !~/^\#/);
            #     $temp{"line"}=$lineno;
            #     $temp{"file"}=$config_filename;
            #     push @{ $$dnsmconfig_ref{"srv-host"} }, { %temp };
            # }
            # # TODO - ptr-record
            # elsif ($line =~ /(^[\#]*[\s]*ptr-record\=)([a-zA-Z0-9\_\.\/]*)/ ) {
            #     %temp = {};
            #     # $temp{}=$2;
            #     # $temp{}=$3;
            #     $temp{"used"}=($line !~/^\#/);
            #     $temp{"line"}=$lineno;
            #     $temp{"file"}=$config_filename;
            #     push @{ $$dnsmconfig_ref{"ptr-record"} }, { %temp };
            # }
            # # TODO - txt-record
            # elsif ($line =~ /(^[\#]*[\s]*txt-record\=)([a-zA-Z0-9\_\.\/]*)/ ) {
            #     %temp = {};
            #     # $temp{}=$2;
            #     # $temp{}=$3;
            #     $temp{"used"}=($line !~/^\#/);
            #     $temp{"line"}=$lineno;
            #     $temp{"file"}=$config_filename;
            #     push @{ $$dnsmconfig_ref{"txt-record"} }, { %temp };
            # }
            # # Provide an alias for a "local" DNS name
            # elsif ($line =~ /(^[\#]*[\s]*cname\=)($NAME)\,($NAME)/ ) {
            #     %temp = {};
            #     $temp{"alias"}=$2;
            #     $temp{"local"}=$3;
            #     $temp{"used"}=($line !~/^\#/);
            #     $temp{"line"}=$lineno;
            #     $temp{"file"}=$config_filename;
            #     push @{ $$dnsmconfig_ref{"cname"} }, { %temp };
            # }
            # # If a DHCP client claims that its name is "wpad", ignore that.
            # elsif ($line =~ /(^[\#]*[\s]*dhcp-name-match\=set:wpad-ignore,wpad)/ ) {
            #     if ($$dnsmconfig_ref->{'dhcp_name_match'}->{"used"} == 0) { # only overwrite if the last value read is not used (commented)
            #         $$dnsmconfig_ref->{'dhcp_name_match'}->{"used"}=($line !~/^\#/);
            #         $$dnsmconfig_ref->{'dhcp_name_match'}->{"line"}=$lineno;
            #         $$dnsmconfig_ref->{'dhcp_name_match'}->{file}=$config_filename;
            #     }
            # }
            # # 
            # elsif ($line =~ /(^[\#]*[\s]*dhcp-ignore-names\=tag:wpad-ignore)/ ) {
            #     if ($$dnsmconfig_ref->{'dhcp_ignore_names'}->{"used"} == 0) { # only overwrite if the last value read is not used (commented)
            #         $$dnsmconfig_ref->{'dhcp_ignore_names'}->{"used"}=($line !~/^\#/);
            #         $$dnsmconfig_ref->{'dhcp_ignore_names'}->{"line"}=$lineno;
            #         $$dnsmconfig_ref->{'dhcp_ignore_names'}->{file}=$config_filename;
            #     }
            # }
            # else {
            #     # everything else that's not a comment 
            #     # we don't understand so it may be an error!
            #     if( $line !~ /^#/ ) {
            #         print "What?:" . $line;
            #         $$dnsmconfig_ref{"errors"}++;
            #     }
            # }
        }
    }
} #end of sub parse_config_file

1;
