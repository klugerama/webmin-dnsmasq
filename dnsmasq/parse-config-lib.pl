#
# parse-config-lib.pl
#
# dnsmasq webmin module library module
#

# use strict;
use warnings;
use v5.10; # at least for Perl 5.10
# use Data::Dumper;
use experimental qw( switch );

#
# the config hash holds the parsed config file(s)
# 

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
our %dnsmconfigvals = (
    "no-hosts"                  => { "idx" => 0,   "valtype" => "bool",    "section" => "dns",   "page" => "1", "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "addn-hosts"                => { "idx" => 1,   "valtype" => "path",    "section" => "dns",   "page" => "1", "arr" => 1, "mult" => "", "special" => 0 }, # =<file>
    "hostsdir"                  => { "idx" => 2,   "valtype" => "dir",     "section" => "dns",   "page" => "1", "arr" => 1, "mult" => "", "special" => 0 }, # =<path>
    "expand-hosts"              => { "idx" => 3,   "valtype" => "bool",    "section" => "dns",   "page" => "1", "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "local-ttl"                 => { "idx" => 4,   "valtype" => "int",     "section" => "dns",   "page" => "1", "arr" => 0, "mult" => "", "special" => 0, "default" => 0 }, # =<time>
    "dhcp-ttl"                  => { "idx" => 5,   "valtype" => "int",     "section" => "dns",   "page" => "1", "arr" => 0, "mult" => "", "special" => 0, "default" => 0 }, # =<time>
    "neg-ttl"                   => { "idx" => 6,   "valtype" => "int",     "section" => "dns",   "page" => "1", "arr" => 0, "mult" => "", "special" => 0, "default" => 0 }, # =<time>
    "max-ttl"                   => { "idx" => 7,   "valtype" => "int",     "section" => "dns",   "page" => "1", "arr" => 0, "mult" => "", "special" => 0, "default" => 0 }, # =<time>
    "max-cache-ttl"             => { "idx" => 8,   "valtype" => "int",     "section" => "dns",   "page" => "1", "arr" => 0, "mult" => "", "special" => 0, "default" => 0 }, # =<time>
    "min-cache-ttl"             => { "idx" => 9,   "valtype" => "int",     "section" => "dns",   "page" => "1", "arr" => 0, "mult" => "", "special" => 0, "default" => 0 }, # =<time>
    "auth-ttl"                  => { "idx" => 10,  "valtype" => "int",     "section" => "dns",   "page" => "7", "arr" => 0, "mult" => "", "special" => 0, "default" => 0 }, # =<time>
    "log-queries"               => { "idx" => 11,  "valtype" => "string",  "section" => "dns",   "page" => "1", "arr" => 0, "mult" => "", "special" => 0, "default" => 0 }, # [=extra]
    "log-facility"              => { "idx" => 12,  "valtype" => "string",  "section" => "dns",   "page" => "1", "arr" => 0, "mult" => "", "special" => 0 }, # =<facility>
    "log-debug"                 => { "idx" => 13,  "valtype" => "bool",    "section" => "dns",   "page" => "1", "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "log-async"                 => { "idx" => 14,  "valtype" => "int",     "section" => "dns",   "page" => "1", "arr" => 0, "mult" => "", "special" => 0, "default" => 5, "val_optional" => 1 }, # [=<lines>]
    "pid-file"                  => { "idx" => 15,  "valtype" => "file",    "section" => "dns",   "page" => "1", "arr" => 0, "mult" => "", "special" => 0 }, # =<path>
    "user"                      => { "idx" => 16,  "valtype" => "string",  "section" => "dns",   "page" => "1", "arr" => 0, "mult" => "", "special" => 0, "default" => "nobody" }, # =<username>
    "group"                     => { "idx" => 17,  "valtype" => "string",  "section" => "dns",   "page" => "1", "arr" => 0, "mult" => "", "special" => 0, "default" => "dip" }, # =<groupname>
    "port"                      => { "idx" => 18,  "valtype" => "int",     "section" => "dns",   "page" => "1", "arr" => 0, "mult" => "", "special" => 0, "default" => 53 }, # =<port>
    "edns-packet-max"           => { "idx" => 19,  "valtype" => "int",     "section" => "dns",   "page" => "1", "arr" => 0, "mult" => "", "special" => 0, "default" => 4096 }, # =<size>
    "query-port"                => { "idx" => 20,  "valtype" => "int",     "section" => "dns",   "page" => "1", "arr" => 0, "mult" => "", "special" => 0 }, # =<query_port>
    "min-port"                  => { "idx" => 21,  "valtype" => "int",     "section" => "dns",   "page" => "1", "arr" => 0, "mult" => "", "special" => 0, "default" => 1024 }, # =<port>
    "max-port"                  => { "idx" => 22,  "valtype" => "int",     "section" => "dns",   "page" => "1", "arr" => 0, "mult" => "", "special" => 0 }, # =<port>
    "interface"                 => { "idx" => 23,  "valtype" => "string",  "section" => "dns",   "page" => "3", "arr" => 1, "mult" => "", "special" => 0 }, # =<interface name>
    "except-interface"          => { "idx" => 24,  "valtype" => "string",  "section" => "dns",   "page" => "3", "arr" => 1, "mult" => "", "special" => 0 }, # =<interface name>
    "auth-server"               => { "idx" => 25,  "valtype" => "var",     "section" => "dns",   "page" => "7", "arr" => 0, "mult" => "", "special" => 0 }, # =<domain>,[<interface>|<ip-address>...]
    "local-service"             => { "idx" => 26,  "valtype" => "bool",    "section" => "dns",   "page" => "1", "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "no-dhcp-interface"         => { "idx" => 27,  "valtype" => "string",  "section" => "dns",   "page" => "3", "arr" => 1, "mult" => "", "special" => 0 }, # =<interface name>
    "listen-address"            => { "idx" => 28,  "valtype" => "ip",      "section" => "dns",   "page" => "3", "arr" => 1, "mult" => "", "special" => 0 }, # =<ipaddr>
    "bind-interfaces"           => { "idx" => 29,  "valtype" => "bool",    "section" => "dns",   "page" => "3", "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "bind-dynamic"              => { "idx" => 30,  "valtype" => "bool",    "section" => "dns",   "page" => "3", "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "localise-queries"          => { "idx" => 31,  "valtype" => "bool",    "section" => "dns",   "page" => "1", "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "bogus-priv"                => { "idx" => 32,  "valtype" => "bool",    "section" => "dns",   "page" => "1", "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "alias"                     => { "idx" => 33,  "valtype" => "var",     "section" => "dns",   "page" => "4", "arr" => 1, "mult" => "", "special" => 0 }, # =[<old-ip>]|[<start-ip>-<end-ip>],<new-ip>[,<mask>] # previously "dns_forced"?
    "bogus-nxdomain"            => { "idx" => 34,  "valtype" => "var",     "section" => "dns",   "page" => "4", "arr" => 1, "mult" => "", "special" => 0 }, # =<ipaddr>[/prefix]
    "ignore-address"            => { "idx" => 35,  "valtype" => "var",     "section" => "dns",   "page" => "4", "arr" => 1, "mult" => "", "special" => 0 }, # =<ipaddr>[/prefix]
    "filterwin2k"               => { "idx" => 36,  "valtype" => "bool",    "section" => "dns",   "page" => "1", "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "resolv-file"               => { "idx" => 37,  "valtype" => "file",    "section" => "dns",   "page" => "1", "arr" => 1, "mult" => "", "special" => 0, "default" => "/etc/resolv.conf" }, # =<file>
    "no-resolv"                 => { "idx" => 38,  "valtype" => "bool",    "section" => "dns",   "page" => "1", "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "enable-dbus"               => { "idx" => 39,  "valtype" => "string",  "section" => "dns",   "page" => "1", "arr" => 0, "mult" => "", "special" => 0, "default" => "uk.org.thekelleys.dnsmasq", "val_optional" => 1 }, # [=<service-name>]
    "enable-ubus"               => { "idx" => 40,  "valtype" => "string",  "section" => "dns",   "page" => "1", "arr" => 0, "mult" => "", "special" => 0, "default" => "dnsmasq", "val_optional" => 1 }, # [=<service-name>]
    "strict-order"              => { "idx" => 41,  "valtype" => "bool",    "section" => "dns",   "page" => "2", "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "all-servers"               => { "idx" => 42,  "valtype" => "bool",    "section" => "dns",   "page" => "2", "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "dns-loop-detect"           => { "idx" => 43,  "valtype" => "bool",    "section" => "dns",   "page" => "1", "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "stop-dns-rebind"           => { "idx" => 44,  "valtype" => "bool",    "section" => "dns",   "page" => "4", "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "rebind-localhost-ok"       => { "idx" => 45,  "valtype" => "bool",    "section" => "dns",   "page" => "4", "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "rebind-domain-ok"          => { "idx" => 46,  "valtype" => "string",  "section" => "dns",   "page" => "4", "arr" => 0, "mult" => "/", "special" => 0 }, # =[<domain>]|[[/<domain>/[<domain>/]
    "no-poll"                   => { "idx" => 47,  "valtype" => "bool",    "section" => "dns",   "page" => "1", "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "clear-on-reload"           => { "idx" => 48,  "valtype" => "bool",    "section" => "dns",   "page" => "1", "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "domain-needed"             => { "idx" => 49,  "valtype" => "bool",    "section" => "dns",   "page" => "1", "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "local"                     => { "idx" => 50,  "valtype" => "var",     "section" => "dns",   "page" => "2", "arr" => 1, "mult" => "", "special" => 1 }, # =[/[<domain>]/[domain/]][<ipaddr>[#<port>]][@<interface>][@<source-ip>[#<port>]]
    "server"                    => { "idx" => 51,  "valtype" => "var",     "section" => "dns",   "page" => "2", "arr" => 1, "mult" => "", "special" => 1 }, # =[/[<domain>]/[domain/]][<ipaddr>[#<port>]][@<interface>][@<source-ip>[#<port>]]
    "rev-server"                => { "idx" => 52,  "valtype" => "var",     "section" => "dns",   "page" => "2", "arr" => 1, "mult" => "", "special" => 0 }, # =<ip-address>/<prefix-len>[,<ipaddr>][#<port>][@<interface>][@<source-ip>[#<port>]]
    "address"                   => { "idx" => 53,  "valtype" => "var",     "section" => "dns",   "page" => "4", "arr" => 1, "mult" => "", "special" => 0 }, # =/<domain>[/<domain>...]/[<ipaddr>]
    "ipset"                     => { "idx" => 54,  "valtype" => "var",     "section" => "dns",   "page" => "5", "arr" => 1, "mult" => "", "special" => 1 }, # =/<domain>[/<domain>...]/<ipset>[,<ipset>...]
    "connmark-allowlist-enable" => { "idx" => 55,  "valtype" => "string",  "section" => "dns",   "page" => "5", "arr" => 0, "mult" => "", "special" => 1, "val_optional" => 1 }, # [=<mask>]
    "connmark-allowlist"        => { "idx" => 56,  "valtype" => "var",     "section" => "dns",   "page" => "5", "arr" => 1, "mult" => "", "special" => 1 }, # =<connmark>[/<mask>][,<pattern>[/<pattern>...]] 
    "mx-host"                   => { "idx" => 57,  "valtype" => "var",     "section" => "dns",   "page" => "5", "arr" => 0, "mult" => "", "special" => 0 }, # =<mx name>[[,<hostname>],<preference>]
    "mx-target"                 => { "idx" => 58,  "valtype" => "string",  "section" => "dns",   "page" => "5", "arr" => 0, "mult" => "", "special" => 0 }, # =<hostname>
    "selfmx"                    => { "idx" => 59,  "valtype" => "bool",    "section" => "dns",   "page" => "5", "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "localmx"                   => { "idx" => 60,  "valtype" => "bool",    "section" => "dns",   "page" => "5", "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "srv-host"                  => { "idx" => 61,  "valtype" => "var",     "section" => "dns",   "page" => "5", "arr" => 0, "mult" => "", "special" => 0 }, # =<_service>.<_prot>.[<domain>],[<target>[,<port>[,<priority>[,<weight>]]]]
    "host-record"               => { "idx" => 62,  "valtype" => "var",     "section" => "dns",   "page" => "5", "arr" => 0, "mult" => "", "special" => 0 }, # =<name>[,<name>....],[<IPv4-address>],[<IPv6-address>][,<TTL>]
    "dynamic-host"              => { "idx" => 63,  "valtype" => "var",     "section" => "dns",   "page" => "5", "arr" => 0, "mult" => "", "special" => 0 }, # =<name>,[IPv4-address],[IPv6-address],<interface>
    "txt-record"                => { "idx" => 64,  "valtype" => "var",     "section" => "dns",   "page" => "5", "arr" => 0, "mult" => "", "special" => 0 }, # =<name>[[,<text>],<text>]
    "ptr-record"                => { "idx" => 65,  "valtype" => "var",     "section" => "dns",   "page" => "5", "arr" => 0, "mult" => "", "special" => 0 }, # =<name>[,<target>]
    "naptr-record"              => { "idx" => 66,  "valtype" => "var",     "section" => "dns",   "page" => "5", "arr" => 0, "mult" => "", "special" => 0 }, # =<name>,<order>,<preference>,<flags>,<service>,<regexp>[,<replacement>]
    "caa-record"                => { "idx" => 67,  "valtype" => "var",     "section" => "dns",   "page" => "5", "arr" => 0, "mult" => "", "special" => 0 }, # =<name>,<flags>,<tag>,<value>
    "cname"                     => { "idx" => 68,  "valtype" => "var",     "section" => "dns",   "page" => "5", "arr" => 0, "mult" => "", "special" => 0 }, # =<cname>,[<cname>,]<target>[,<TTL>]
    "dns-rr"                    => { "idx" => 69,  "valtype" => "var",     "section" => "dns",   "page" => "5", "arr" => 0, "mult" => "", "special" => 0 }, # =<name>,<RR-number>,[<hex data>]
    "interface-name"            => { "idx" => 70,  "valtype" => "var",     "section" => "dns",   "page" => "5", "arr" => 0, "mult" => "", "special" => 0 }, # =<name>,<interface>[/4|/6]
    "synth-domain"              => { "idx" => 71,  "valtype" => "var",     "section" => "dns",   "page" => "5", "arr" => 0, "mult" => "", "special" => 0 }, # =<domain>,<address range>[,<prefix>[*]]
    "dumpfile"                  => { "idx" => 72,  "valtype" => "file",    "section" => "dns",   "page" => "1", "arr" => 0, "mult" => "", "special" => 0 }, # =<path/to/file>
    "dumpmask"                  => { "idx" => 73,  "valtype" => "string",  "section" => "dns",   "page" => "1", "arr" => 0, "mult" => "", "special" => 0 }, # =<mask>
    "add-mac"                   => { "idx" => 74,  "valtype" => "string",  "section" => "dns",   "page" => "2", "arr" => 0, "mult" => "", "special" => 0, "val_optional" => 1 }, # [=base64|text]
    "add-cpe-id"                => { "idx" => 75,  "valtype" => "string",  "section" => "dns",   "page" => "2", "arr" => 0, "mult" => "", "special" => 0 }, # =<string>
    "add-subnet"                => { "idx" => 76,  "valtype" => "var",     "section" => "dns",   "page" => "2", "arr" => 0, "mult" => "", "special" => 0, "val_optional" => 1 }, # [[=[<IPv4 address>/]<IPv4 prefix length>][,[<IPv6 address>/]<IPv6 prefix length>]]
    "umbrella"                  => { "idx" => 77,  "valtype" => "var",     "section" => "dns",   "page" => "2", "arr" => 0, "mult" => "", "special" => 0, "val_optional" => 1 }, # [=deviceid:<deviceid>[,orgid:<orgid>]]
    "cache-size"                => { "idx" => 78,  "valtype" => "int",     "section" => "dns",   "page" => "1", "arr" => 0, "mult" => "", "special" => 0, "default" => 150 }, # =<cachesize>
    "no-negcache"               => { "idx" => 79,  "valtype" => "bool",    "section" => "dns",   "page" => "1", "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "dns-forward-max"           => { "idx" => 80,  "valtype" => "int",     "section" => "dns",   "page" => "1", "arr" => 0, "mult" => "", "special" => 0, "default" => 150 }, # =<queries>
    "dnssec"                    => { "idx" => 81,  "valtype" => "bool",    "section" => "dns",   "page" => "6", "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "trust-anchor"              => { "idx" => 82,  "valtype" => "var",     "section" => "dns",   "page" => "6", "arr" => 0, "mult" => "", "special" => 0 }, # =[<class>],<domain>,<key-tag>,<algorithm>,<digest-type>,<digest>
    "dnssec-check-unsigned"     => { "idx" => 83,  "valtype" => "string",  "section" => "dns",   "page" => "6", "arr" => 0, "mult" => "", "special" => 1, "default" => 1, "val_optional" => 1 }, # [=no]
    "dnssec-no-timecheck"       => { "idx" => 84,  "valtype" => "bool",    "section" => "dns",   "page" => "6", "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "dnssec-timestamp"          => { "idx" => 85,  "valtype" => "file",    "section" => "dns",   "page" => "6", "arr" => 0, "mult" => "", "special" => 0 }, # =<path>
    "proxy-dnssec"              => { "idx" => 86,  "valtype" => "bool",    "section" => "dns",   "page" => "6", "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "dnssec-debug"              => { "idx" => 87,  "valtype" => "bool",    "section" => "dns",   "page" => "6", "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "auth-zone"                 => { "idx" => 88,  "valtype" => "var",     "section" => "dns",   "page" => "7", "arr" => 0, "mult" => "", "special" => 0 }, # =<domain>[,<subnet>[/<prefix length>][,<subnet>[/<prefix length>]|<interface>.....][,exclude:<subnet>[/<prefix length>]|<interface>].....]
    "auth-soa"                  => { "idx" => 89,  "valtype" => "var",     "section" => "dns",   "page" => "7", "arr" => 0, "mult" => "", "special" => 0 }, # =<serial>[,<hostmaster>[,<refresh>[,<retry>[,<expiry>]]]]
    "auth-sec-servers"          => { "idx" => 90,  "valtype" => "string",  "section" => "dns",   "page" => "7", "arr" => 0, "mult" => ",", "special" => 0 }, # =<domain>[,<domain>[,<domain>...]]
    "auth-peer"                 => { "idx" => 91,  "valtype" => "ip",      "section" => "dns",   "page" => "7", "arr" => 0, "mult" => ",", "special" => 0 }, # =<ip-address>[,<ip-address>[,<ip-address>...]]
    "conntrack"                 => { "idx" => 92,  "valtype" => "bool",    "section" => "dns",   "page" => "5", "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "dhcp-range"                => { "idx" => 93,  "valtype" => "var",     "section" => "dhcp",  "page" => "5", "arr" => 1, "mult" => "", "special" => 0 }, # TODO edit # =[tag:<tag>[,tag:<tag>],][set:<tag>,]<start-addr>[,<end-addr>|<mode>][,<netmask>[,<broadcast>]][,<lease time>] -OR- =[tag:<tag>[,tag:<tag>],][set:<tag>,]<start-IPv6addr>[,<end-IPv6addr>|constructor:<interface>][,<mode>][,<prefix-len>][,<lease time>]
    "dhcp-host"                 => { "idx" => 94,  "valtype" => "var",     "section" => "dhcp",  "page" => "6", "arr" => 1, "mult" => "", "special" => 0 }, # TODO edit # =[<hwaddr>][,id:<client_id>|*][,set:<tag>][tag:<tag>][,<ipaddr>][,<hostname>][,<lease_time>][,ignore]
    "dhcp-hostsfile"            => { "idx" => 95,  "valtype" => "path",    "section" => "dhcp",  "page" => "1", "arr" => 0, "mult" => "", "special" => 0 }, # =<path>
    "dhcp-optsfile"             => { "idx" => 96,  "valtype" => "path",    "section" => "dhcp",  "page" => "1", "arr" => 0, "mult" => "", "special" => 0 }, # =<path>
    "dhcp-hostsdir"             => { "idx" => 97,  "valtype" => "dir",     "section" => "dhcp",  "page" => "1", "arr" => 0, "mult" => "", "special" => 0 }, # =<path>
    "dhcp-optsdir"              => { "idx" => 98,  "valtype" => "dir",     "section" => "dhcp",  "page" => "1", "arr" => 0, "mult" => "", "special" => 0 }, # =<path>
    "read-ethers"               => { "idx" => 99,  "valtype" => "bool",    "section" => "dhcp",  "page" => "1", "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "dhcp-option"               => { "idx" => 100, "valtype" => "var",     "section" => "dhcp",  "page" => "3", "arr" => 1, "mult" => "", "special" => 0 }, # =[tag:<tag>,[tag:<tag>,]][encap:<opt>,][vi-encap:<enterprise>,][vendor:[<vendor-class>],][<opt>|option:<opt-name>|option6:<opt>|option6:<opt-name>],[<value>[,<value>]]
    "dhcp-option-force"         => { "idx" => 101, "valtype" => "var",     "section" => "dhcp",  "page" => "3", "arr" => 1, "mult" => "", "special" => 0 }, # =[tag:<tag>,[tag:<tag>,]][encap:<opt>,][vi-encap:<enterprise>,][vendor:[<vendor-class>],][<opt>|option:<opt-name>|option6:<opt>|option6:<opt-name>],[<value>[,<value>]]
    "dhcp-no-override"          => { "idx" => 102, "valtype" => "bool",    "section" => "dhcp",  "page" => "1", "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "dhcp-relay"                => { "idx" => 103, "valtype" => "var",     "section" => "dhcp",  "page" => "1", "arr" => 0, "mult" => "", "special" => 0 }, # =<local address>,<server address>[,<interface]
    "dhcp-vendorclass"          => { "idx" => 104, "valtype" => "var",     "section" => "dhcp",  "page" => "4", "arr" => 1, "mult" => "", "special" => 0 }, # =set:<tag>,[enterprise:<IANA-enterprise number>,]<vendor-class>
    "dhcp-userclass"            => { "idx" => 105, "valtype" => "var",     "section" => "dhcp",  "page" => "4", "arr" => 1, "mult" => "", "special" => 0 }, # =set:<tag>,<user-class>
    "dhcp-mac"                  => { "idx" => 106, "valtype" => "var",     "section" => "dhcp",  "page" => "4", "arr" => 0, "mult" => "", "special" => 0 }, # =set:<tag>,<MAC address>
    "dhcp-circuitid"            => { "idx" => 107, "valtype" => "var",     "section" => "dhcp",  "page" => "4", "arr" => 0, "mult" => "", "special" => 0 }, # =set:<tag>,<circuit-id>
    "dhcp-remoteid"             => { "idx" => 108, "valtype" => "var",     "section" => "dhcp",  "page" => "4", "arr" => 0, "mult" => "", "special" => 0 }, # =set:<tag>,<remote-id>
    "dhcp-subscrid"             => { "idx" => 109, "valtype" => "var",     "section" => "dhcp",  "page" => "4", "arr" => 0, "mult" => "", "special" => 0 }, # =set:<tag>,<subscriber-id>
    "dhcp-proxy"                => { "idx" => 110, "valtype" => "ip",      "section" => "dhcp",  "page" => "4", "arr" => 0, "mult" => ",", "special" => 0, "val_optional" => 1 }, # [=<ip addr>]......
    "dhcp-match"                => { "idx" => 111, "valtype" => "var",     "section" => "dhcp",  "page" => "4", "arr" => 0, "mult" => "", "special" => 0 }, # =set:<tag>,<option number>|option:<option name>|vi-encap:<enterprise>[,<value>]
    "dhcp-name-match"           => { "idx" => 112, "valtype" => "var",     "section" => "dhcp",  "page" => "4", "arr" => 0, "mult" => "", "special" => 0 }, # =set:<tag>,<name>[*]
    "tag-if"                    => { "idx" => 113, "valtype" => "var",     "section" => "dhcp",  "page" => "4", "arr" => 0, "mult" => "", "special" => 0 }, # =set:<tag>[,set:<tag>[,tag:<tag>[,tag:<tag>]]]
    "dhcp-ignore"               => { "idx" => 114, "valtype" => "var",     "section" => "dhcp",  "page" => "4", "arr" => 0, "mult" => ",", "special" => 0 }, # =tag:<tag>[,tag:<tag>]
    "dhcp-ignore-names"         => { "idx" => 115, "valtype" => "var",     "section" => "dhcp",  "page" => "4", "arr" => 0, "mult" => ",", "special" => 0, "val_optional" => 1 }, # [=tag:<tag>[,tag:<tag>]]
    "dhcp-generate-names"       => { "idx" => 116, "valtype" => "var",     "section" => "dhcp",  "page" => "4", "arr" => 0, "mult" => ",", "special" => 0 }, # =tag:<tag>[,tag:<tag>]
    "dhcp-broadcast"            => { "idx" => 117, "valtype" => "var",     "section" => "dhcp",  "page" => "4", "arr" => 0, "mult" => ",", "special" => 0, "val_optional" => 1 }, # [=tag:<tag>[,tag:<tag>]]
    "dhcp-boot"                 => { "idx" => 118, "valtype" => "var",     "section" => "t_b_p", "page" => "2", "arr" => 0, "mult" => "", "special" => 0 }, # =[tag:<tag>,]<filename>,[<servername>[,<server address>|<tftp_servername>]]
    "dhcp-sequential-ip"        => { "idx" => 119, "valtype" => "bool",    "section" => "dhcp",  "page" => "1", "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "dhcp-ignore-clid"          => { "idx" => 120, "valtype" => "bool",    "section" => "dhcp",  "page" => "1", "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "pxe-service"               => { "idx" => 121, "valtype" => "var",     "section" => "t_b_p", "page" => "2", "arr" => 0, "mult" => "", "special" => 0 }, # =[tag:<tag>,]<CSA>,<menu text>[,<basename>|<bootservicetype>][,<server address>|<server_name>]
    "pxe-prompt"                => { "idx" => 122, "valtype" => "var",     "section" => "t_b_p", "page" => "2", "arr" => 0, "mult" => "", "special" => 0 }, # =[tag:<tag>,]<prompt>[,<timeout>]
    "dhcp-pxe-vendor"           => { "idx" => 123, "valtype" => "string",  "section" => "t_b_p", "page" => "2", "arr" => 0, "mult" => "", "special" => 0 }, # =<vendor>[,...]
    "dhcp-lease-max"            => { "idx" => 124, "valtype" => "int",     "section" => "dhcp",  "page" => "1", "arr" => 0, "mult" => "", "special" => 0, "default" => 1000 }, # =<number>
    "dhcp-authoritative"        => { "idx" => 125, "valtype" => "bool",    "section" => "dhcp",  "page" => "1", "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "dhcp-rapid-commit"         => { "idx" => 126, "valtype" => "bool",    "section" => "dhcp",  "page" => "1", "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "dhcp-alternate-port"       => { "idx" => 127, "valtype" => "var",     "section" => "dhcp",  "page" => "1", "arr" => 0, "mult" => "", "special" => 0, "val_optional" => 1 }, # [=<server port>[,<client port>]]
    "bootp-dynamic"             => { "idx" => 128, "valtype" => "string",  "section" => "t_b_p", "page" => "2", "arr" => 1, "mult" => "", "special" => 0, "val_optional" => 1 }, # [=<network-id>[,<network-id>]]
    "no-ping"                   => { "idx" => 129, "valtype" => "bool",    "section" => "dhcp",  "page" => "1", "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "log-dhcp"                  => { "idx" => 130, "valtype" => "bool",    "section" => "dhcp",  "page" => "1", "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "quiet-dhcp"                => { "idx" => 131, "valtype" => "bool",    "section" => "dhcp",  "page" => "1", "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "quiet-dhcp6"               => { "idx" => 132, "valtype" => "bool",    "section" => "dhcp",  "page" => "1", "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "quiet-ra"                  => { "idx" => 133, "valtype" => "bool",    "section" => "dhcp",  "page" => "1", "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "dhcp-leasefile"            => { "idx" => 134, "valtype" => "file",    "section" => "dhcp",  "page" => "1", "arr" => 0, "mult" => "", "special" => 0 }, # =<path>
    "dhcp-duid"                 => { "idx" => 135, "valtype" => "var",     "section" => "dhcp",  "page" => "1", "arr" => 0, "mult" => "", "special" => 0 }, # =<enterprise-id>,<uid>
    "dhcp-script"               => { "idx" => 136, "valtype" => "file",    "section" => "dhcp",  "page" => "1", "arr" => 0, "mult" => "", "special" => 0 }, # =<path>
    "dhcp-luascript"            => { "idx" => 137, "valtype" => "file",    "section" => "dhcp",  "page" => "1", "arr" => 0, "mult" => "", "special" => 0 }, # =<path>
    "dhcp-scriptuser"           => { "idx" => 138, "valtype" => "string",  "section" => "dhcp",  "page" => "1", "arr" => 0, "mult" => "", "special" => 0, "default" => "root" }, # =<username>
    "script-arp"                => { "idx" => 139, "valtype" => "bool",    "section" => "dhcp",  "page" => "1", "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "leasefile-ro"              => { "idx" => 140, "valtype" => "bool",    "section" => "dhcp",  "page" => "1", "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "script-on-renewal"         => { "idx" => 141, "valtype" => "bool",    "section" => "dhcp",  "page" => "1", "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "bridge-interface"          => { "idx" => 142, "valtype" => "var",     "section" => "dhcp",  "page" => "1", "arr" => 1, "mult" => "", "special" => 0 }, # TODO edit # =<interface>,<alias>[,<alias>]
    "shared-network"            => { "idx" => 143, "valtype" => "var",     "section" => "dhcp",  "page" => "1", "arr" => 0, "mult" => "", "special" => 0 }, # =<interface|addr>,<addr>
    "domain"                    => { "idx" => 144, "valtype" => "var",     "section" => "dhcp",  "page" => "2", "arr" => 1, "mult" => "", "special" => 0 }, # =<domain>[,<address range>[,local]]
    "dhcp-fqdn"                 => { "idx" => 145, "valtype" => "bool",    "section" => "dhcp",  "page" => "1", "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "dhcp-client-update"        => { "idx" => 146, "valtype" => "bool",    "section" => "dhcp",  "page" => "1", "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "enable-ra"                 => { "idx" => 147, "valtype" => "bool",    "section" => "dhcp",  "page" => "1", "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "ra-param"                  => { "idx" => 148, "valtype" => "var",     "section" => "dhcp",  "page" => "1", "arr" => 0, "mult" => "", "special" => 0 }, # =<interface>,[mtu:<integer>|<interface>|off,][high,|low,]<ra-interval>[,<router lifetime>]
    "dhcp-reply-delay"          => { "idx" => 149, "valtype" => "var",     "section" => "dhcp",  "page" => "1", "arr" => 0, "mult" => "", "special" => 0 }, # =[tag:<tag>,]<integer>
    "enable-tftp"               => { "idx" => 150, "valtype" => "string",  "section" => "t_b_p", "page" => "1", "arr" => 0, "mult" => "", "special" => 0, "val_optional" => 1 }, # [=<interface>[,<interface>]]
    "tftp-root"                 => { "idx" => 151, "valtype" => "var",     "section" => "t_b_p", "page" => "1", "arr" => 0, "mult" => "", "special" => 0 }, # =<directory>[,<interface>]
    "tftp-no-fail"              => { "idx" => 152, "valtype" => "bool",    "section" => "t_b_p", "page" => "1", "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "tftp-unique-root"          => { "idx" => 153, "valtype" => "string",  "section" => "t_b_p", "page" => "1", "arr" => 0, "mult" => "", "special" => 0, "val_optional" => 1 }, # [=ip|mac]
    "tftp-secure"               => { "idx" => 154, "valtype" => "bool",    "section" => "t_b_p", "page" => "1", "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "tftp-lowercase"            => { "idx" => 155, "valtype" => "bool",    "section" => "t_b_p", "page" => "1", "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "tftp-max"                  => { "idx" => 156, "valtype" => "int",     "section" => "t_b_p", "page" => "1", "arr" => 0, "mult" => "", "special" => 0 }, # =<connections>
    "tftp-mtu"                  => { "idx" => 157, "valtype" => "int",     "section" => "t_b_p", "page" => "1", "arr" => 0, "mult" => "", "special" => 0 }, # =<mtu size>
    "tftp-no-blocksize"         => { "idx" => 158, "valtype" => "bool",    "section" => "t_b_p", "page" => "1", "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "tftp-port-range"           => { "idx" => 159, "valtype" => "var",     "section" => "t_b_p", "page" => "1", "arr" => 0, "mult" => "", "special" => 0 }, # =<start>,<end>
    "tftp-single-port"          => { "idx" => 160, "valtype" => "bool",    "section" => "t_b_p", "page" => "1", "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "conf-file"                 => { "idx" => 161, "valtype" => "var",     "section" => "dns",   "page" => "6", "arr" => 1, "mult" => "", "special" => 0 }, # =<file>
    "conf-dir"                  => { "idx" => 162, "valtype" => "var",     "section" => "dns",   "page" => "6", "arr" => 1, "mult" => "", "special" => 0 }, # =<directory>[,<file-extension>......],
    "servers-file"              => { "idx" => 163, "valtype" => "var",     "section" => "dns",   "page" => "6", "arr" => 1, "mult" => "", "special" => 0 }, # =<file>
);

our @confbools = ( ); # options which may not contain any parameters/values
our @confvars = ( ); # options which may contain more than one parameter/value
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
    if ( $vals->{"valtype"} eq "var" ) {
        push( @confvars, $key ); 
    }
    else {
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
@confvars = (sort { $dnsmconfigvals{$a}->{"idx"} <=> $dnsmconfigvals{$b}->{"idx"} } @confvars );
@confarrs = (sort { $dnsmconfigvals{$a}->{"idx"} <=> $dnsmconfigvals{$b}->{"idx"} } @confarrs );
@confdns = (sort { $dnsmconfigvals{$a}->{"idx"} <=> $dnsmconfigvals{$b}->{"idx"} } @confdns );
@confdhcp = (sort { $dnsmconfigvals{$a}->{"idx"} <=> $dnsmconfigvals{$b}->{"idx"} } @confdhcp );
@conft_b_p = (sort { $dnsmconfigvals{$a}->{"idx"} <=> $dnsmconfigvals{$b}->{"idx"} } @conft_b_p );
our %configfield_fields = ( );

sub init_configfield_fields {
    %configfield_fields = ( 
        "no_hosts" => { 
            "param_order" => [ "val" ],
            "val" => {
                "valtype" => "bool",
                "default" => 0,
            }
        },
        "addn_hosts" => { 
            "param_order" => [ "val" ],
            "val" => {
                "length" => 15,
                "valtype" => "path",
                "default" => "",
                "template" => "<" . $text{"tmpl_path_to_file_or_directory"} . ">"
            }
        }, # =<file>
        "hostsdir" => { 
            "param_order" => [ "val" ],
            "val" => {
                "length" => 15,
                "valtype" => "path",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_filename"},
                "template" => "<" . $text{"tmpl_path_to_directory"} . ">"
            }
        }, # =<path>
        "expand_hosts" => { 
            "param_order" => [ "val" ],
            "val" => {
                "valtype" => "bool",
                "default" => 0
            }
        },
        "local_ttl" => { 
            "param_order" => [ "val" ],
            "val" => {
                "length" => 3,
                "valtype" => "int",
                "default" => 0,
                "required" => 1,
                "label" => $text{"p_label_val_ttl"},
                "template" => "<" . $text{"tmpl_TTL"} . ">"
            }
        }, # =<time>
        "dhcp_ttl" => { 
            "param_order" => [ "val" ],
            "val" => {
                "length" => 3,
                "valtype" => "int",
                "default" => 0,
                "required" => 1,
                "label" => $text{"p_label_val_ttl"},
                "template" => "<" . $text{"tmpl_TTL"} . ">"
            }
        }, # =<time>
        "neg_ttl" => { 
            "param_order" => [ "val" ],
            "val" => {
                "length" => 3,
                "valtype" => "int",
                "default" => 0,
                "required" => 1,
                "label" => $text{"p_label_val_ttl"},
                "template" => "<" . $text{"tmpl_TTL"} . ">"
            }
        }, # =<time>
        "max_ttl" => { 
            "param_order" => [ "val" ],
            "val" => {
                "length" => 3,
                "valtype" => "int",
                "default" => 0,
                "required" => 1,
                "label" => $text{"p_label_val_ttl"},
                "template" => "<" . $text{"tmpl_TTL"} . ">"
            }
        }, # =<time>
        "max_cache_ttl" => { 
            "param_order" => [ "val" ],
            "val" => {
                "length" => 3,
                "valtype" => "int",
                "default" => 0,
                "required" => 1,
                "label" => $text{"p_label_val_ttl"},
                "template" => "<" . $text{"tmpl_TTL"} . ">"
            }
        }, # =<time>
        "min_cache_ttl" => { 
            "param_order" => [ "val" ],
            "val" => {
                "length" => 3,
                "valtype" => "int",
                "default" => 0,
                "required" => 1,
                "label" => $text{"p_label_val_ttl"},
                "template" => "<" . $text{"tmpl_TTL"} . ">"
            }
        }, # =<time>
        "auth_ttl" => { 
            "param_order" => [ "val" ],
            "val" => {
                "length" => 3,
                "valtype" => "int",
                "default" => 0,
                "required" => 1,
                "label" => $text{"p_label_val_ttl"},
                "template" => "<" . $text{"tmpl_TTL"} . ">"
            }
        }, # =<time>
        "log_queries" => { 
            "param_order" => [ "val" ],
            "val" => {
                "length" => 3,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "template" => "extra" # literal value
            }
        },
        "log_facility" => { 
            "param_order" => [ "val" ],
            "val" => {
                "length" => 15,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "template" => "<" . $text{"tmpl_log_facility"} . ">"
            }
        }, # =<facility>
        "log_debug" => {
            "param_order" => [ "val" ],
            "val" => {
                "valtype" => "bool",
                "default" => 0
            }
        },
        "log_async" => {
            "param_order" => [ "val" ],
            "val" => {
                "length" => 3,
                "valtype" => "int",
                "default" => 5,
                "required" => 0,
                "label" => $text{"p_label_val_ttl"},
                "template" => "<" . $text{"tmpl_log_async"} . ">",
            }
        }, # [=<lines>] 
        "pid_file" => {
            "param_order" => [ "val" ],
            "val" => {
                "length" => 15,
                "valtype" => "file",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_filename"},
                "template" => "<" . $text{"tmpl_path_to_file"} . ">"
            }
        }, # =<path>
        "user" => { 
            "param_order" => [ "val" ],
            "val" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_username"},
                "template" => "<" . $text{"tmpl_username"} . ">"
            }
        }, # =<username>
        "group" => { 
            "param_order" => [ "val" ],
            "val" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_groupname"},
                "template" => "<" . $text{"tmpl_groupname"} . ">"
            }
        }, # =<groupname>
        "port" => { 
            "param_order" => [ "val" ],
            "val" => {
                "length" => 3,
                "valtype" => "int",
                "default" => 0,
                "required" => 1,
                "label" => $text{"p_label_val_port"},
                "template" => "<" . $text{"tmpl_port"} . ">"
            }
        }, # =<port>
        "edns_packet_max" => { 
            "param_order" => [ "val" ],
            "val" => {
                "length" => 3,
                "valtype" => "int",
                "default" => 0,
                "required" => 1,
                "label" => $text{"p_label_val_size"},
                "template" => "<" . $text{"tmpl_size"} . ">"
            }
        }, # =<size>
        "query_port" => { 
            "param_order" => [ "val" ],
            "val" => {
                "length" => 3,
                "valtype" => "int",
                "default" => 0,
                "required" => 1,
                "label" => $text{"p_label_val_port"},
                "template" => "<" . $text{"tmpl_port"} . ">"
            }
        }, # =<query_port>
        "min_port" => { 
            "param_order" => [ "val" ],
            "val" => {
                "length" => 3,
                "valtype" => "int",
                "default" => 0,
                "required" => 1,
                "label" => $text{"p_label_val_port"},
                "template" => "<" . $text{"tmpl_port"} . ">"
            }
        }, # =<port>
        "max_port" => { 
            "param_order" => [ "val" ],
            "val" => {
                "length" => 3,
                "valtype" => "int",
                "default" => 0,
                "required" => 1,
                "label" => $text{"p_label_val_port"},
                "template" => "<" . $text{"tmpl_port"} . ">"
            }
        }, # =<port>
        "interface" => { 
            "param_order" => [ "val" ],
            "val" => {
                "length" => 10,
                "valtype" => "interface",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_interface"},
                "template" => "<" . $text{"tmpl_interface"} . ">"
            }
        }, # =<interface name>
        "except_interface" => { 
            "param_order" => [ "val" ],
            "val" => {
                "length" => 10,
                "valtype" => "interface",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_interface"},
                "template" => "<" . $text{"tmpl_interface"} . ">"
            }
        }, # =<interface name>
        "auth_server" => {
            "param_order" => [ "domain", "for" ],
            "domain" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_domain"},
                "template" => "<" . $text{"tmpl_domain"} . ">"
            },
            "for" => {
                "length" => 15,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_interface_or_ip_address"},
                "template" => "<" . $text{"tmpl_interface"} . ">|<" . $text{"tmpl_ip"} . ">..."
            }
        }, # =<domain>,[<interface>|<ip-address>...]
        "local_service" => { 
            "param_order" => [ "val" ],
            "val" => {
                "valtype" => "bool",
                "default" => 0,
            }
        },
        "no_dhcp_interface" => { 
            "param_order" => [ "val" ],
            "val" => {
                "length" => 10,
                "valtype" => "interface",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_interface"},
                "template" => "<" . $text{"tmpl_interface"} . ">"
            }
        }, # =<interface name>
        "listen_address" => { 
            "param_order" => [ "val" ],
            "val" => {
                "length" => 10,
                "valtype" => "ip",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_ip_address"},
                "template" => $text{"tmpl_ip"}
            }
        }, # =<ipaddr>
        "bind_interfaces" => { 
            "param_order" => [ "val" ],
            "val" => {
                "valtype" => "bool",
                "default" => 0,
            }
        },
        "bind_dynamic" => { 
            "param_order" => [ "val" ],
            "val" => {
                "valtype" => "bool",
                "default" => 0,
            }
        },
        "localise_queries" => { 
            "param_order" => [ "val" ],
            "val" => {
                "valtype" => "bool",
                "default" => 0,
            }
        },
        "bogus_priv" => { 
            "param_order" => [ "val" ],
            "val" => {
                "valtype" => "bool",
                "default" => 0,
            }
        },
        "alias" => { 
            "param_order" => [ "from", "to", "netmask" ],
            "from" => {
                "length" => 10,
                "valtype" => "ip",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_from_addresses"},
                "template" => $text{"tmpl_ip"} . "|" . $text{"tmpl_ip"} . "-" . $text{"tmpl_ip"}
            },
            "to" => {
                "length" => 10,
                "valtype" => "ip",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_to_address"},
                "template" => $text{"tmpl_ip"}
            },
            "netmask" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_netmask"},
                "template" => $text{"tmpl_netmask"}
            },
        }, # =[<old-ip>]|[<start-ip>-<end-ip>],<new-ip>[,<mask>]
        "bogus_nxdomain" => { 
            "param_order" => [ "addr" ],
            "addr" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_ip_address"},
                "template" => $text{"tmpl_ip"} . "[/" . $text{"tmpl_prefix"} . "]"
            }
        }, # =<ipaddr>[/prefix]
        "ignore_address" => { 
            "param_order" => [ "ip" ],
            "ip" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_ip_address"},
                "template" => $text{"tmpl_ip"} . "[/" . $text{"tmpl_prefix"} . "]"
            }
        }, # =<ipaddr>[/prefix]
        "filterwin2k" => { 
            "param_order" => [ "val" ],
            "val" => {
                "valtype" => "bool",
                "default" => 0,
            }
        },
        "resolv_file" => { 
            "param_order" => [ "val" ],
            "val" => {
                "length" => 15,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "template" => "<" . $text{"tmpl_path_to_file"} . ">"
            }
        }, # =<file>
        "no_resolv" => { 
            "param_order" => [ "val" ],
            "val" => {
                "valtype" => "bool",
                "default" => 0
            },
        },
        "enable_dbus" => { 
            "param_order" => [ "val" ],
            "val" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_service_name"},
                "template" => "<" . $text{"tmpl_service_name"} . ">"
            },
        }, # [=<service-name>]
        "enable_ubus" => { 
            "param_order" => [ "val" ],
            "val" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_service_name"},
                "template" => "<" . $text{"tmpl_service_name"} . ">"
            },
        }, # [=<service-name>]
        "strict_order" => { 
            "param_order" => [ "val" ],
            "val" => {
                "valtype" => "bool",
                "default" => 0,
            }
        },
        "all_servers" => { 
            "param_order" => [ "val" ],
            "val" => {
                "valtype" => "bool",
                "default" => 0,
            }
        },
        "dns_loop_detect" => { 
            "param_order" => [ "val" ],
            "val" => {
                "valtype" => "bool",
                "default" => 0,
            }
        },
        "stop_dns_rebind" => { 
            "param_order" => [ "val" ],
            "val" => {
                "valtype" => "bool",
                "default" => 0,
            }
        },
        "rebind_localhost_ok" => { 
            "param_order" => [ "val" ],
            "val" => {
                "valtype" => "bool",
                "default" => 0,
            }
        },
        "rebind_domain_ok" => { 
            "param_order" => [ "val" ],
            "val" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_domains"},
                "template" => "<" . $text{"tmpl_domain"} . ">",
                "arr" => 1,
                "sep" => "/",
            }
        }, # =[<domain>]|[[/<domain>/[<domain>/]
        "no_poll" => { 
            "param_order" => [ "val" ],
            "val" => {
                "valtype" => "bool",
                "default" => 0,
            }
        },
        "clear_on_reload" => { 
            "param_order" => [ "val" ],
            "val" => {
                "valtype" => "bool",
                "default" => 0,
            }
        },
        "domain_needed" => { 
            "param_order" => [ "val" ],
            "val" => {
                "valtype" => "bool",
                "default" => 0,
            }
        },
        "local" => { 
            "param_order" => [ "domain", "ip", "source" ],
            "domain" => {
                "length" => 15,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_domains"},
                "template" => "<" . $text{"tmpl_domain"} . ">/|/<" . $text{"tmpl_domain"} . ">/[<" . $text{"tmpl_domain"} . ">/]",
                "arr" => 1,
                "sep" => "/",
            },
            "ip" => {
                "length" => 10,
                "valtype" => "ip",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_ip_address"},
                "template" => $text{"tmpl_ip"} . "[#" . $text{"tmpl_port"} . "]"
            },
            "source" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_source_interface_or_address"},
                "template" => "@" . $text{"tmpl_interface"} . "|@" . $text{"tmpl_ip"} . "[#" . $text{"tmpl_port"} . "]"
            }
        }, # =[/[<domain>]/[domain/]][<ipaddr>[#<port>]][@<interface>][@<source-ip>[#<port>]]
        "server" => { 
            "param_order" => [ "domain", "ip", "source" ],
            "domain" => {
                "length" => 15,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_domains"},
                "template" => "<" . $text{"tmpl_domain"} . ">/|/<" . $text{"tmpl_domain"} . ">/[<" . $text{"tmpl_domain"} . ">/]",
                "arr" => 1,
                "sep" => "/",
            },
            "ip" => {
                "length" => 10,
                "valtype" => "ip",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_ip_address"},
                "template" => "[" . $text{"tmpl_ip"} . "][#" . $text{"tmpl_port"} . "]"
            },
            "source" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_source_interface_or_address"},
                "template" => "@<" . $text{"tmpl_interface"} . ">|@" . $text{"tmpl_ip"} . "[#" . $text{"tmpl_port"} . "]"
            }
        }, # =[/[<domain>]/[domain/]][<ipaddr>[#<port>]][@<interface>][@<source-ip>[#<port>]]
        "rev_server" => {
            "param_order" => [ "domain", "ip", "source" ],
            "domain" => {
                "length" => 15,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_ip_address"},
                "template" => $text{"tmpl_ip"} . "/" . $text{"tmpl_prefix_length"}
            },
            "ip" => {
                "length" => 10,
                "valtype" => "ip",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_ip_address"},
                "template" => "[" . $text{"tmpl_ip"} . "][#" . $text{"tmpl_port"} . "]"
            },
            "source" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_source_interface_or_address"},
                "template" => "@<" . $text{"tmpl_interface"} . ">|@" . $text{"tmpl_ip"} . "[#" . $text{"tmpl_port"} . "]"
            }
        }, # =<ip-address>/<prefix-len>[,<ipaddr>][#<port>][@<interface>][@<source-ip>[#<port>]]
        "address" => { 
            "param_order" => [ "domain", "ip" ],
            "domain" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_domains"},
                "template" => "<" . $text{"tmpl_domain"} . ">/|/<" . $text{"tmpl_domain"} . ">/[<" . $text{"tmpl_domain"} . ">/]",
            },
            "ip" => {
                "length" => 10,
                "valtype" => "ip",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_ip_address"},
                "template" => $text{"tmpl_ip"}
            },
        }, # =/<domain>[/<domain>...]/[<ipaddr>]
        "ipset" => { 
            "param_order" => [ "domain", "ipset" ],
            "domain" => {
                "length" => 20,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_domains"},
                "template" => "<" . $text{"tmpl_domain"} . ">[/<" . $text{"tmpl_domain"} . ">...]",
                "arr" => 1,
                "sep" => "/",
            },
            "ipset" => {
                "length" => 15,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_ipsets"},
                "template" => "<" . $text{"tmpl_ipset"} . ">[,<" . $text{"tmpl_ipset"} . ">...]",
                "arr" => 1,
                "sep" => ",",
            },
        }, # =/<domain>[/<domain>...]/<ipset>[,<ipset>...]
        "connmark_allowlist_enable" => { 
            "param_order" => [ "val" ],
            "val" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_mask"},
                "template" => "<" . $text{"tmpl_mask"} . ">"
            }
        }, # [=<mask>]
        "connmark_allowlist" => { 
            "param_order" => [ "connmark", "mask", "pattern" ],
            "connmark" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_connmark"},
                "template" => "<" . $text{"tmpl_connmark"} . ">"
            },
            "mask" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_mask"},
                "template" => "<" . $text{"tmpl_mask"} . ">"
            },
            "pattern" => {
                "length" => 20,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_pattern"},
                "template" => "<" . $text{"tmpl_pattern"} . ">[/<" . $text{"tmpl_pattern"} . ">...]"
            },
        }, # =<connmark>[/<mask>][,<pattern>[/<pattern>...]]
        "mx_host" => { 
            "param_order" => [ "mxname", "host", "preference" ],
            "mxname" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_mxname"},
                "template" => "<" . $text{"tmpl_name"} . ">"
            },
            "host" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_hostname"},
                "template" => "<" . $text{"tmpl_hostname"} . ">"
            },
            "preference" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_preference"},
                "template" => "<" . $text{"tmpl_preference"} . ">"
            },
        }, # =<mx name>[[,<hostname>],<preference>]
        "mx_target" => { 
            "param_order" => [ "val" ],
            "val" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_target"},
                "template" => "<" . $text{"tmpl_hostname"} . ">"
            }
        }, # =<hostname>
        "selfmx" => { 
            "param_order" => [ "val" ],
            "val" => {
                "valtype" => "bool",
                "default" => 0,
            }
        },
        "localmx" => { 
            "param_order" => [ "val" ],
            "val" => {
                "valtype" => "bool",
                "default" => 0,
            }
        },
        "srv_host" => { 
            "param_order" => [ "service", "prot", "domain", "target", "port", "priority", "weight" ],
            "service" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_service"},
                "template" => "<" . $text{"tmpl_srv_host_service"} . ">"
            },
            "prot" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_protocol"},
                "template" => "<" . $text{"tmpl_prot"} . ">"
            },
            "domain" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_domain"},
                "template" => "<" . $text{"tmpl_domain"} . ">"
            },
            "target" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_target"},
                "template" => "<" . $text{"tmpl_target"} . ">"
            },
            "port" => {
                "length" => 3,
                "valtype" => "int",
                "default" => 0,
                "required" => 0,
                "label" => $text{"p_label_val_port"},
                "template" => "<" . $text{"tmpl_port"} . ">"
            },
            "priority" => {
                "length" => 3,
                "valtype" => "int",
                "default" => 0,
                "required" => 0,
                "label" => $text{"p_label_val_priority"},
                "template" => "<" . $text{"tmpl_srv_host_priority"} . ">"
            },
            "weight" => {
                "length" => 3,
                "valtype" => "int",
                "default" => 0,
                "required" => 0,
                "label" => $text{"p_label_val_weight"},
                "template" => "<" . $text{"tmpl_weight"} . ">"
            },
        }, # =<_service>.<_prot>.[<domain>],[<target>[,<port>[,<priority>[,<weight>]]]]
        "host_record" => { 
            "param_order" => [ "name", "ipv4", "ipv6", "ttl" ],
            "name" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_names"},
                "template" => "<" . $text{"tmpl_name"} . ">[,<" . $text{"tmpl_name"} . ">]",
            },
            "ipv4" => {
                "length" => 10,
                "valtype" => "ip",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_ipv4_address"},
                "template" => $text{"tmpl_ip"},
            },
            "ipv6" => {
                "length" => 10,
                "valtype" => "ip",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_ipv6_address"},
                "template" => $text{"tmpl_ip6"},
            },
            "ttl" => {
                "length" => 10,
                "valtype" => "int",
                "default" => 0,
                "required" => 0,
                "label" => $text{"p_label_val_ttl"},
                "template" => "<" . $text{"tmpl_TTL"} . ">",
            },
        }, # =<name>[,<name>....],[<IPv4-address>],[<IPv6-address>][,<TTL>]
        "dynamic_host" => { 
            "param_order" => [ "name", "ipv4", "ipv6", "interface" ],
            "name" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_name"},
                "template" => "<" . $text{"tmpl_name"} . ">"
            },
            "ipv4" => {
                "length" => 10,
                "valtype" => "ip",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_ipv4_address"},
                "template" => $text{"tmpl_ip"}
            },
            "ipv6" => {
                "length" => 10,
                "valtype" => "ip",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_ipv6_address"},
                "template" => $text{"tmpl_ip6"}
            },
            "interface" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_interface"},
                "template" => "<" . $text{"tmpl_interface"} . ">"
            },
        }, # =<name>,[IPv4-address],[IPv6-address],<interface>
        "txt_record" => { 
            "param_order" => [ "name", "text" ],
            "name" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_name"},
                "template" => "<" . $text{"tmpl_name"} . ">"
            },
            "text" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_text"},
                "template" => "[,<" . $text{"tmpl_text"} . ">],<" . $text{"tmpl_text"} . ">"
            },
        }, # =<name>[[,<text>],<text>]
        "ptr_record" => { 
            "param_order" => [ "name", "target" ],
            "name" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_name"},
                "template" => "<" . $text{"tmpl_name"} . ">"
            },
            "target" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_target"},
                "template" => "<" . $text{"tmpl_target"} . ">"
            },
        }, # =<name>[,<target>]
        "naptr_record" => { 
            "param_order" => [ "name", "order", "preference", "flags", "service", "regexp", "replacement" ],
            "name" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_name"},
                "template" => "<" . $text{"tmpl_name"} . ">",
            },
            "order" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_order"},
                "template" => "<" . $text{"tmpl_order"} . ">",
            },
            "preference" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_preference"},
                "template" => "<" . $text{"tmpl_preference"} . ">",
            },
            "flags" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_flags"},
                "template" => "<" . $text{"tmpl_flags"} . ">",
            },
            "service" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_service"},
                "template" => "<" . $text{"tmpl_service"} . ">",
            },
            "regexp" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_regexp"},
                "template" => "<" . $text{"tmpl_regexp"} . ">",
            },
            "replacement" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_replacement"},
                "template" => "<" . $text{"tmpl_replacement"} . ">",
            },
        }, # =<name>,<order>,<preference>,<flags>,<service>,<regexp>[,<replacement>]
        "caa_record" => { 
            "param_order" => [ "name", "flags", "tag", "value" ],
            "name" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_name"},
                "template" => "<" . $text{"tmpl_name"} . ">"
            },
            "flags" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_flags"},
                "template" => "<" . $text{"tmpl_flags"} . ">"
            },
            "tag" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_tag"},
                "template" => "<" . $text{"tmpl_tag"} . ">"
            },
            "value" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_value"},
                "template" => "<" . $text{"tmpl_value"} . ">"
            },
        }, # =<name>,<flags>,<tag>,<value>
        "cname" => { 
            "param_order" => [ "cname", "target", "ttl" ],
            "cname" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_cnames"},
                "template" => "<" . $text{"tmpl_cname"} . ">[,<" . $text{"tmpl_cname"} . ">]"
            },
            "target" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_target"},
                "template" => "<" . $text{"tmpl_target"} . ">"
            },
            "ttl" => {
                "length" => 3,
                "valtype" => "int",
                "default" => 0,
                "required" => 0,
                "label" => $text{"p_label_val_ttl"},
                "template" => "<" . $text{"tmpl_TTL"} . ">"
            },
        }, # =<cname>,[<cname>,]<target>[,<TTL>]
        "dns_rr" => { 
            "param_order" => [ "name", "rrnumber", "hexdata" ],
            "name" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_name"},
                "template" => "<" . $text{"tmpl_name"} . ">"
            },
            "rrnumber" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_rrnumber"},
                "template" => "<" . $text{"tmpl_rrnumber"} . ">"
            },
            "hexdata" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_hexdata"},
                "template" => "<" . $text{"tmpl_hexdata"} . ">"
            },
        }, # =<name>,<RR-number>,[<hex data>]
        "interface_name" => { 
            "param_order" => [ "name", "interface" ],
            "name" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_name"},
                "template" => "<" . $text{"tmpl_name"} . ">"
            },
            "interface" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_interface"},
                "template" => "<" . $text{"tmpl_interface"} . ">[/4|/6]"
            },
        }, # =<name>,<interface>[/4|/6]
        "synth_domain" => { 
            "param_order" => [ "domain", "addressrange", "prefix" ],
            "domain" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_domain"},
                "template" => "<" . $text{"tmpl_domain"} . ">"
            },
            "addressrange" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_address_range"},
                "template" => $text{"tmpl_address_range"}
            },
            "prefix" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_prefix"},
                "template" => "<" . $text{"tmpl_prefix"} . ">[*]"
            },
        }, # =<domain>,<address range>[,<prefix>[*]]
        "dumpfile" => { 
            "param_order" => [ "val" ],
            "val" => {
                "length" => 15,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_filename"},
                "template" => "<" . $text{"tmpl_path_to_file"} . ">"
            }
        }, # =<path/to/file>
        "dumpmask" => { 
            "param_order" => [ "val" ],
            "val" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_mask"},
                "template" => "<" . $text{"tmpl_mask"} . ">"
            }
        }, # =<mask>
        "add_mac" => { 
            "param_order" => [ "val" ],
            "val" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "template" => "base64|text"
            }
        }, # [=base64|text]
        "add_cpe_id" => { 
            "param_order" => [ "val" ],
            "val" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "template" => "<" . $text{"tmpl_string"} . ">"
            }
        }, # =<string>
        "add_subnet" => { 
            "param_order" => [ "ipv4", "ipv6" ],
            "ipv4" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_ipv4_address"},
                "template" => "<" . $text{"tmpl_ip"} . ">"
            },
            "ipv6" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_ipv6_address"},
                "template" => $text{"tmpl_ip6"}
            },
        }, # [[=[<IPv4 address>/]<IPv4 prefix length>][,[<IPv6 address>/]<IPv6 prefix length>]]
        "umbrella" => {  
            "param_order" => [ "deviceid", "orgid" ],
            "deviceid" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_deviceid"},
                "template" => "deviceid:<" . $text{"tmpl_deviceid"} . ">"
            },
            "orgid" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_orgid"},
                "template" => "orgid:<" . $text{"tmpl_orgid"} . ">"
            },
        }, # [=deviceid:<deviceid>[,orgid:<orgid>]]
        "cache_size" => { 
            "param_order" => [ "val" ],
            "val" => {
                "length" => 3,
                "valtype" => "int",
                "default" => 0,
                "required" => 1,
                "template" => "<" . $text{"tmpl_integer"} . ">"
            }
        }, # =<cachesize>
        "no_negcache" => { 
            "param_order" => [ "val" ],
            "val" => {
                "valtype" => "bool",
                "default" => 0,
            }
        },
        "dns_forward_max" => { 
            "param_order" => [ "val" ],
            "val" => {
                "length" => 3,
                "valtype" => "int",
                "default" => 0,
                "required" => 1,
                "template" => "<" . $text{"tmpl_integer"} . ">"
            }
        }, # =<queries>
        "dnssec" => { 
            "param_order" => [ "val" ],
            "val" => {
                "valtype" => "bool",
                "default" => 0,
            }
        },
        "trust_anchor" => { 
            "param_order" => [ "class", "domain", "keytag", "algorithm", "digesttype", "digest" ],
            "class" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_class"},
                "template" => "<" . $text{"tmpl_class"} . ">"
            },
            "domain" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_domain"},
                "template" => "<" . $text{"tmpl_domain"} . ">"
            },
            "keytag" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_keytag"},
                "template" => "<" . $text{"tmpl_key_tag"} . ">"
            },
            "algorithm" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_algorithm"},
                "template" => "<" . $text{"tmpl_algorithm"} . ">"
            },
            "digesttype" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_digesttype"},
                "template" => "<" . $text{"tmpl_digest_type"} . ">"
            },
            "digest" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_digest"},
                "template" => "<" . $text{"tmpl_digest"} . ">"
            },
        }, # =[<class>],<domain>,<key-tag>,<algorithm>,<digest-type>,<digest>
        "dnssec_check_unsigned" => { 
            "param_order" => [ "val" ],
            "val" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "no",
                "required" => 0,
                "template" => "[no]" # literal value
            }
        }, # [=no]
        "dnssec_no_timecheck" => { 
            "param_order" => [ "val" ],
            "val" => {
                "valtype" => "bool",
                "default" => 0,
            }
        },
        "dnssec_timestamp" => { 
            "param_order" => [ "val" ],
            "val" => {
                "length" => 15,
                "valtype" => "file",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_filename"},
                "template" => "<" . $text{"tmpl_path_to_file"} . ">"
            }
        }, # =<path>
        "proxy_dnssec" => { 
            "param_order" => [ "val" ],
            "val" => {
                "valtype" => "bool",
                "default" => 0,
            }
        },
        "dnssec_debug" => { 
            "param_order" => [ "val" ],
            "val" => {
                "valtype" => "bool",
                "default" => 0,
            }
        },
        "auth_zone" => { 
            "param_order" => [ "domain", "include", "exclude" ],
            "domain" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_domain"},
                "template" => "<" . $text{"tmpl_domain"} . ">"
            },
            "include" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "arr" => 1,
                "sep" => ",",
                "label" => $text{"p_label_val_include_subnets_or_interfaces"},
                "template" => "<" . $text{"tmpl_subnet"} . ">[/<" . $text{"tmpl_prefix_length"} . ">]|<" . $text{"tmpl_interface"} . ">"
            },
            "exclude" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "arr" => 1,
                "sep" => ",",
                "label" => $text{"p_label_val_exclude_subnets_or_interfaces"},
                "template" => "<" . $text{"tmpl_subnet"} . ">[/<" . $text{"tmpl_prefix_length"} . ">]|<" . $text{"tmpl_interface"} . ">"
            }
        }, # =<domain>[,<subnet>[/<prefix length>][,<subnet>[/<prefix length>]|<interface>.....][,exclude:<subnet>[/<prefix length>]|<interface>].....]
        "auth_soa" => {
            "param_order" => [ "serial", "hostmaster", "refresh", "retry", "expiry" ],
            "serial" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_serial"},
                "template" => "<" . $text{"tmpl_serial"} . ">"
            },
            "hostmaster" => {
                "length" => 15,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_hostmaster"},
                "template" => "<" . $text{"tmpl_hostmaster"} . ">"
            },
            "refresh" => {
                "length" => 2,
                "valtype" => "int",
                "default" => 0,
                "required" => 0,
                "label" => $text{"p_label_val_refresh"},
                "template" => "<" . $text{"tmpl_integer"} . ">"
            },
            "retry" => {
                "length" => 2,
                "valtype" => "int",
                "default" => 0,
                "required" => 0,
                "label" => $text{"p_label_val_retry"},
                "template" => "<" . $text{"tmpl_integer"} . ">"
            },
            "expiry" => {
                "length" => 2,
                "valtype" => "int",
                "default" => 0,
                "required" => 0,
                "label" => $text{"p_label_val_expiry"},
                "template" => "<" . $text{"tmpl_expiry"} . ">"
            }
        }, # =<serial>[,<hostmaster>[,<refresh>[,<retry>[,<expiry>]]]]
        "auth_sec_servers" => { 
            "param_order" => [ "val" ],
            "val" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_domains"},
                "template" => "<" . $text{"tmpl_domain"} . ">",
                "arr" => 1,
                "sep" => ",",
            }
        }, # =<domain>[,<domain>[,<domain>...]]
        "auth_peer" => { 
            "param_order" => [ "val" ],
            "val" => {
                "length" => 10,
                "valtype" => "ip",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_ip_address"},
                "template" => $text{"tmpl_ip"},
                "arr" => 1,
                "sep" => ",",
            }
        }, # =<ip-address>[,<ip-address>[,<ip-address>...]]
        "conntrack" => { 
            "param_order" => [ "val" ],
            "val" => {
                "valtype" => "bool",
                "default" => 0,
            }
        },
        "dhcp_range" => { 
            "param_order" => [ "tag", "settag", "start", "end", "static", "proxy", "ra-only", "ra-names", "ra-stateless", "slaac", "ra-advrouter", "off-link", "mask", "broadcast", "prefix-length", "leasetime" ],
            "tag" => {
                "length" => 15,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_tags"},
                "template" => "<tag:" . $text{"tmpl_tag"} . ">[,tag:<" . $text{"tmpl_tag"} . ">]",
                "arr" => 1,
                "sep" => ",",
            },
            "settag" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_set_tag"},
                "template" => "set:<" . $text{"tmpl_tag"} . ">"
            },
            "start" => {
                "length" => 12,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_start_ip_address"},
                "template" => $text{"tmpl_ip"},
                "template6" => $text{"tmpl_ip6"},
            },
            "end" => {
                "length" => 12,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_end_ip_address"},
                "template" => $text{"tmpl_ip"},
                "template6" => $text{"tmpl_ip6"},
            },
            "static" => {
                "valtype" => "bool",
                "default" => 0,
                "label" => $text{"p_label_val_static"},
            },
            "proxy" => {
                "ipversion" => 4,
                "valtype" => "bool",
                "default" => 0,
                "label" => $text{"p_label_val_proxy"},
            },
            "ra-only" => {
                "ipversion" => 6,
                "valtype" => "bool",
                "default" => 0,
                "label" => $text{"p_label_val_ra-only"},
            },
            "ra-names" => {
                "ipversion" => 6,
                "valtype" => "bool",
                "default" => 0,
                "label" => $text{"p_label_val_ra-names"},
            },
            "ra-stateless" => {
                "ipversion" => 6,
                "valtype" => "bool",
                "default" => 0,
                "label" => $text{"p_label_val_ra-stateless"},
            },
            "slaac" => {
                "ipversion" => 6,
                "valtype" => "bool",
                "default" => 0,
                "label" => $text{"p_label_val_slaac"},
            },
            "ra-advrouter" => {
                "ipversion" => 6,
                "valtype" => "bool",
                "default" => 0,
                "label" => $text{"p_label_val_ra-advrouter"},
            },
            "off-link" => {
                "ipversion" => 6,
                "valtype" => "bool",
                "default" => 0,
                "label" => $text{"p_label_val_off-link"},
            },
            "mask" => {
                "ipversion" => 4,
                "length" => 12,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_netmask"},
                "template" => $text{"tmpl_netmask"}
            },
            "broadcast" => {
                "ipversion" => 4,
                "length" => 12,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_broadcast"},
                "template" => $text{"tmpl_netmask"}
            },
            "prefix-length" => {
                "ipversion" => 6,
                "length" => 3,
                "valtype" => "int",
                "default" => 0,
                "required" => 0,
                "label" => $text{"p_label_val_prefix_length"},
                "template" => "<" . $text{"tmpl_prefix_length"} . ">"
            },
            "leasetime" => {
                "length" => 3,
                "valtype" => "int",
                "default" => 0,
                "required" => 0,
                "label" => $text{"p_label_val_leasetime"},
                "template" => "<" . $text{"tmpl_leasetime"} . ">"
            },
        }, # =[tag:<tag>[,tag:<tag>],][set:<tag>,]<start-addr>[,<end-addr>|<mode>][,<netmask>[,<broadcast>]][,<lease time>] -OR- =[tag:<tag>[,tag:<tag>],][set:<tag>,]<start-IPv6addr>[,<end-IPv6addr>|constructor:<interface>][,<mode>][,<prefix-len>][,<lease time>]
        "dhcp_host" => { 
            "param_order" => [ "mac", "clientid", "infiniband", "settag", "tag", "ip", "hostname", "leasetime", "ignore" ],
            "mac" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_hwaddr"},
                "template" => $text{"tmpl_mac"}
            },
            "clientid" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_clientid"},
                "template" => "id:<" . $text{"tmpl_clientid"} . ">|*"
            },
            "infiniband" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_infiniband"},
                "template" => "id:<" . $text{"tmpl_infiniband"} . ">"
            },
            "settag" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_set_tags"},
                "template" => "set:<" . $text{"tmpl_tag"} . ">",
                "arr" => 1,
                "sep" => ",",
            },
            "tag" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_tags"},
                "template" => "tag:<" . $text{"tmpl_tag"} . ">"
            },
            "ip" => {
                "length" => 10,
                "valtype" => "ip",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_ip_address"},
                "template" => $text{"tmpl_ip"} . "|[" . $text{"tmpl_ip6"} . "]",
            },
            "hostname" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_hostname"},
                "template" => "<" . $text{"tmpl_hostname"} . ">"
            },
            "leasetime" => {
                "length" => 3,
                "valtype" => "int",
                "default" => 0,
                "required" => 0,
                "label" => $text{"p_label_val_leasetime"},
                "template" => "<" . $text{"tmpl_leasetime"} . ">"
            },
            "ignore" => {
                "valtype" => "bool",
                "default" => 0,
                "label" => $text{"p_label_val_ignore"},
            },
        }, # =[<hwaddr>][,id:<client_id>|*][,set:<tag>][tag:<tag>][,<ipaddr>][,<hostname>][,<lease_time>][,ignore]
        "dhcp_hostsfile" => { 
            "param_order" => [ "val" ],
            "val" => {
                "length" => 15,
                "valtype" => "path",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_filename"},
                "template" => "<" . $text{"tmpl_path_to_file"} . ">"
            }
        }, # =<path>
        "dhcp_optsfile" => { 
            "param_order" => [ "val" ],
            "val" => {
                "length" => 15,
                "valtype" => "path",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_filename"},
                "template" => "<" . $text{"tmpl_path_to_file"} . ">"
            }
        }, # =<path>
        "dhcp_hostsdir" => { 
            "param_order" => [ "val" ],
            "val" => {
                "length" => 15,
                "valtype" => "path",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_dirname"},
                "template" => "<" . $text{"tmpl_path_to_directory"} . ">"
            }
        }, # =<path>
        "dhcp_optsdir" => { 
            "param_order" => [ "val" ],
            "val" => {
                "length" => 15,
                "valtype" => "path",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_dirname"},
                "template" => "<" . $text{"tmpl_path_to_directory"} . ">"
            }
        }, # =<path>
        "read_ethers" => { 
            "param_order" => [ "val" ],
            "val" => {
                "valtype" => "bool",
                "default" => 0,
            }
        },
        "dhcp_option" => { 
            "param_order" => [ "option", "value", "tag", "vendor", "encap", "vi-encap", "forced" ],
            "option" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_option"},
                "template" => "<" . $text{"tmpl_option"} . ">|option:<" . $text{"tmpl_option_name"} . ">|option6:<" . $text{"tmpl_option"} . ">|option:<" . $text{"tmpl_option_name"} . ">"
            },
            "value" => {
                "length" => 20,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_value"},
                "template" => "<" . $text{"tmpl_value"} . ">[,<" . $text{"tmpl_value"} . ">]"
            },
            "tag" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_tags"},
                "template" => "tag:<" . $text{"tmpl_tag"} . ">[,tag:<" . $text{"tmpl_tag"} . ">]",
                "arr" => 1,
                "sep" => ",",
            },
            "vendor" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_option_vendor"},
                "template" => "vendor:<" . $text{"tmpl_vendorclass"} . ">"
            },
            "encap" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_encap"},
                "template" => "encap:<" . $text{"tmpl_option"} . ">"
            },
            "vi-encap" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_vi_encap"},
                "template" => "vi-encap:<" . $text{"tmpl_enterprise"} . ">"
            },
            "forced" => {
                "valtype" => "bool",
                "default" => 0,
                "label" => $text{"p_label_val_dhcp_option_forced"},
            },
        }, # =[tag:<tag>,[tag:<tag>,]][encap:<opt>,][vi-encap:<enterprise>,][vendor:[<vendor-class>],][<opt>|option:<opt-name>|option6:<opt>|option6:<opt-name>],[<value>[,<value>]]
        "dhcp_option_force" => { 
            "param_order" => [ "tag", "encap", "vi-encap", "vendor", "option", "value" ],
            "tag" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_tags"},
                "template" => "tag:<" . $text{"tmpl_tag"} . ">[,tag:<" . $text{"tmpl_tag"} . ">]"
            },
            "encap" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_encap"},
                "template" => "encap:<" . $text{"tmpl_option"} . ">"
            },
            "vi-encap" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_vi_encap"},
                "template" => "vi-encap:<" . $text{"tmpl_enterprise"} . ">"
            },
            "vendor" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_option_vendor"},
                "template" => "vendor:<" . $text{"tmpl_vendorclass"} . ">"
            },
            "option" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_option"},
                "template" => "<" . $text{"tmpl_option"} . ">|option:<" . $text{"tmpl_option_name"} . ">|option6:<" . $text{"tmpl_option"} . ">|option:<" . $text{"tmpl_option_name"} . ">"
            },
            "value" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_value"},
                "template" => "<" . $text{"tmpl_value"} . ">[,<" . $text{"tmpl_value"} . ">]"
            },
        }, # =[tag:<tag>,[tag:<tag>,]][encap:<opt>,][vi-encap:<enterprise>,][vendor:[<vendor-class>],][<opt>|option:<opt-name>|option6:<opt>|option6:<opt-name>],[<value>[,<value>]]
        "dhcp_no_override" => { 
            "param_order" => [ "val" ],
            "val" => {
                "valtype" => "bool",
                "default" => 0,
            }
        },
        "dhcp_relay" => { 
            "param_order" => [ "local", "server", "interface" ],
            "local" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_local_address"},
                "template" => "<" . $text{"tmpl_address"} . ">"
            },
            "server" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_server_address"},
                "template" => "<" . $text{"tmpl_address"} . ">"
            },
            "interface" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_interface"},
                "template" => "<" . $text{"tmpl_interface"} . ">"
            },
        }, # =<local address>,<server address>[,<interface]
        "dhcp_vendorclass" => { 
            "param_order" => [ "tag", "vendorclass" ],
            "tag" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_set_tag"},
                "template" => "set:<" . $text{"tmpl_tag"} . ">"
            },
            "vendorclass" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_vendorclass"},
                "template" => "<[enterprise:<" . $text{"tmpl_enterprise"} . ">,]<" . $text{"tmpl_vendorclass"} . ">"
            },
        }, # =set:<tag>,[enterprise:<IANA-enterprise number>,]<vendor-class>
        "dhcp_userclass" => { 
            "param_order" => [ "tag", "userclass" ],
            "tag" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_set_tag"},
                "template" => "set:<" . $text{"tmpl_tag"} . ">"
            },
            "userclass" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_userclass"},
                "template" => "<" . $text{"tmpl_userclass"} . ">"
            },
        }, # =set:<tag>,<user-class>
        "dhcp_mac" => { 
            "param_order" => [ "tag", "mac" ],
            "tag" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_set_tag"},
                "template" => "set:<" . $text{"tmpl_tag"} . ">"
            },
            "mac" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_hwaddr"},
                "template" => $text{"tmpl_mac"}
            },
        }, # =set:<tag>,<MAC address>
        "dhcp_circuitid" => { 
            "param_order" => [ "tag", "circuitid" ],
            "tag" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_set_tag"},
                "template" => "set:<" . $text{"tmpl_tag"} . ">"
            },
            "circuitid" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_circuitid"},
                "template" => "<" . $text{"tmpl_circuitid"} . ">"
            },
        }, # =set:<tag>,<circuit-id>
        "dhcp_remoteid" => { 
            "param_order" => [ "tag", "remoteid" ],
            "tag" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_set_tag"},
                "template" => "set:<" . $text{"tmpl_tag"} . ">"
            },
            "remoteid" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_remoteid"},
                "template" => "<" . $text{"tmpl_remoteid"} . ">"
            },
        }, # =set:<tag>,<remote-id>
        "dhcp_subscrid" => { 
            "param_order" => [ "tag", "subscriberid" ],
            "tag" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_set_tag"},
                "template" => "set:<" . $text{"tmpl_tag"} . ">"
            },
            "subscriberid" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_subscriberid"},
                "template" => "<" . $text{"tmpl_subscriberid"} . ">"
            },
        }, # =set:<tag>,<subscriber-id>
        "dhcp_proxy" => { 
            "param_order" => [ "val" ],
            "val" => {
                "length" => 10,
                "valtype" => "ip",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_ip_addresses"},
                "template" => $text{"tmpl_ip"}
            }
        }, # [=<ip addr>]......
        "dhcp_match" => { 
            "param_order" => [ "tag", "option", "vi-encap", "value" ],
            "tag" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_set_tag"},
                "template" => "set:<" . $text{"tmpl_tag"} . ">"
            },
            "option" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_option"},
                "template" => "<" . $text{"tmpl_option"} . ">|option:<" . $text{"tmpl_option_name"} . ">"
            },
            "vi-encap" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_vi_encap"},
                "template" => "vi-encap:<" . $text{"tmpl_enterprise"} . ">"
            },
            "value" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_value"},
                "template" => "<" . $text{"tmpl_value"} . ">"
            },
        }, # =set:<tag>,<option number>|option:<option name>|vi-encap:<enterprise>[,<value>]
        "dhcp_name_match" => { 
            "param_order" => [ "tag", "name" ],
            "tag" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_set_tag"},
                "template" => "set:<" . $text{"tmpl_tag"} . ">"
            },
            "name" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_name"},
                "template" => "<" . $text{"tmpl_name"} . ">[*]"
            },
        }, # =set:<tag>,<name>[*]
        "tag_if" => { 
            "param_order" => [ "settag", "iftag" ],
            "settag" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_set_tags"},
                "template" => "set:<" . $text{"tmpl_tag"} . ">[,set:<" . $text{"tmpl_tag"} . ">]"
            },
            "iftag" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_tags"},
                "template" => "tag:<" . $text{"tmpl_tag"} . ">[,tag:<" . $text{"tmpl_tag"} . ">]"
            },
        }, # =set:<tag>[,set:<tag>[,tag:<tag>[,tag:<tag>]]]
        "dhcp_ignore" => { 
            "param_order" => [ "tag" ],
            "tag" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_tags"},
                "template" => "tag:<" . $text{"tmpl_tag"} . ">[,tag:<" . $text{"tmpl_tag"} . ">]"
            },
        }, # =tag:<tag>[,tag:<tag>]
        "dhcp_ignore_names" => { 
            "param_order" => [ "tag" ],
            "tag" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_tags"},
                "template" => "tag:<" . $text{"tmpl_tag"} . ">[,tag:<" . $text{"tmpl_tag"} . ">]"
            },
        }, # [=tag:<tag>[,tag:<tag>]]
        "dhcp_generate_names" => { 
            "param_order" => [ "tag" ],
            "tag" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_tags"},
                "template" => "tag:<" . $text{"tmpl_tag"} . ">[,tag:<" . $text{"tmpl_tag"} . ">]"
            },
        }, # =tag:<tag>[,tag:<tag>]
        "dhcp_broadcast" => { 
            "param_order" => [ "tag" ],
            "tag" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_tags"},
                "template" => "tag:<" . $text{"tmpl_tag"} . ">[,tag:<" . $text{"tmpl_tag"} . ">]"
            },
        }, # [=tag:<tag>[,tag:<tag>]]
        "dhcp_boot" => { 
            "param_order" => [ "tag", "filename", "host", "address" ],
            "tag" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_tag"},
                "template" => "tag:<" . $text{"tmpl_tag"} . ">",
            },
            "filename" => {
                "length" => 15,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_filename"},
                "template" => "<" . $text{"tmpl_path_to_file"} . ">",
            },
            "host" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_server_name"},
                "template" => "<" . $text{"tmpl_servername"} . ">",
            },
            "address" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_server_address"},
                "template" => "<" . $text{"tmpl_server_address"} . "|" . $text{"tmpl_tftp_server_name"} . ">",
            },
        }, # =[tag:<tag>,]<filename>,[<servername>[,<server address>|<tftp_servername>]]
        "dhcp_sequential_ip" => { 
            "param_order" => [ "val" ],
            "val" => {
                "valtype" => "bool",
                "default" => 0,
            }
        },
        "dhcp_ignore_clid" => { 
            "param_order" => [ "val" ],
            "val" => {
                "valtype" => "bool",
                "default" => 0,
            }
        },
        "pxe_service" => { 
            "param_order" => [ "tag", "csa", "menutext", "basename", "server" ],
            "tag" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_tag"},
                "template" => "tag:<" . $text{"tmpl_tag"} . ">"
            },
            "csa" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_csa"},
                "template" => "<" . $text{"tmpl_csa"} . ">"
            },
            "menutext" => {
                "length" => 15,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_menutext"},
                "template" => "<" . $text{"tmpl_menu_text"} . ">"
            },
            "basename" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_basename"},
                "template" => "<" . $text{"tmpl_base_name"} . ">|<" . $text{"tmpl_boot_service_type"} . ">"
            },
            "server" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_server_address_or_name"},
                "template" => "<" . $text{"tmpl_server_address"} . ">|<" . $text{"tmpl_servername"} . ">"
            },
        }, # =[tag:<tag>,]<CSA>,<menu text>[,<basename>|<bootservicetype>][,<server address>|<server_name>]
        "pxe_prompt" => { 
            "param_order" => [ "tag", "prompt", "timeout" ],
            "tag" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_tag"},
                "template" => "tag:<" . $text{"tmpl_tag"} . ">"
            },
            "prompt" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_prompt"},
                "template" => "<" . $text{"tmpl_prompt"} . ">"
            },
            "timeout" => {
                "length" => 3,
                "valtype" => "int",
                "default" => 0,
                "required" => 0,
                "label" => $text{"p_label_val_timeout"},
                "template" => "<" . $text{"tmpl_integer"} . ">"
            },
        }, # =[tag:<tag>,]<prompt>[,<timeout>]
        "dhcp_pxe_vendor" => { 
            "param_order" => [ "val" ],
            "val" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_vendor"},
                "template" => "<" . $text{"tmpl_string"} . ">[,<" . $text{"tmpl_string"} . ">...]"
            }
        }, # =<vendor>[,...]
        "dhcp_lease_max" => { 
            "param_order" => [ "val" ],
            "val" => {
                "length" => 3,
                "valtype" => "int",
                "default" => 0,
                "required" => 1,
                "label" => $text{"p_label_val_leasetime"},
                "template" => "<" . $text{"tmpl_integer"} . ">"
            }
        }, # =<number>
        "dhcp_authoritative" => { 
            "param_order" => [ "val" ],
            "val" => {
                "valtype" => "bool",
                "default" => 0,
            }
        },
        "dhcp_rapid_commit" => { 
            "param_order" => [ "val" ],
            "val" => {
                "valtype" => "bool",
                "default" => 0,
            }
        },
        "dhcp_alternate_port" => { 
            "param_order" => [ "serverport", "clientport" ],
            "serverport" => {
                "length" => 3,
                "valtype" => "int",
                "default" => 0,
                "required" => 0,
                "label" => $text{"p_label_val_serverport"},
                "template" => "<" . $text{"tmpl_port"} . ">"
            },
            "clientport" => {
                "length" => 3,
                "valtype" => "int",
                "default" => 0,
                "required" => 0,
                "label" => $text{"p_label_val_clientport"},
                "template" => "<" . $text{"tmpl_port"} . ">"
            },
        }, # [=<server port>[,<client port>]]
        "bootp_dynamic" => { 
            "param_order" => [ "val" ],
            "val" => {
                "length" => 20,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_networkids"},
                "template" => "<" . $text{"tmpl_network_id"} . ">[,<" . $text{"tmpl_network_id"} . ">]",
                "arr" => 1,
                "sep" => ",",
            },
        }, # [=<network-id>[,<network-id>]]
        "no_ping" => { 
            "param_order" => [ "val" ],
            "val" => {
                "valtype" => "bool",
                "default" => 0,
            }
        },
        "log_dhcp" => { 
            "param_order" => [ "val" ],
            "val" => {
                "valtype" => "bool",
                "default" => 0,
            }
        },
        "quiet_dhcp" => { 
            "param_order" => [ "val" ],
            "val" => {
                "valtype" => "bool",
                "default" => 0,
            }
        },
        "quiet-dhcp6" => { 
            "param_order" => [ "val" ],
            "val" => {
                "valtype" => "bool",
                "default" => 0,
            }
        },
        "quiet_ra" => { 
            "param_order" => [ "val" ],
            "val" => {
                "valtype" => "bool",
                "default" => 0,
            }
        },
        "dhcp_leasefile" => { 
            "param_order" => [ "val" ],
            "val" => {
                "length" => 15,
                "valtype" => "file",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_filename"},
                "template" => "<" . $text{"tmpl_path_to_file"} . ">"
            },
        }, # =<path>
        "dhcp_duid" => { 
            "param_order" => [ "enterpriseid", "uid" ],
            "enterpriseid" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_enterpriseid"},
                "template" => "<" . $text{"tmpl_enterprise"} . ">"
            },
            "uid" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_uid"},
                "template" => "<" . $text{"tmpl_uid"} . ">"
            },
        }, # =<enterprise-id>,<uid>
        "dhcp_script" => { 
            "param_order" => [ "val" ],
            "val" => {
                "length" => 15,
                "valtype" => "file",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_filename"},
                "template" => "<" . $text{"tmpl_path_to_file"} . ">"
            }
        }, # =<path>
        "dhcp_luascript" => { 
            "param_order" => [ "val" ],
            "val" => {
                "length" => 15,
                "valtype" => "file",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_filename"},
                "template" => "<" . $text{"tmpl_path_to_file"} . ">"
            }
        }, # =<path>
        "dhcp_scriptuser" => { 
            "param_order" => [ "val" ],
            "val" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_username"},
                "template" => "<" . $text{"tmpl_username"} . ">"
            }
        }, # =<username>
        "script_arp" => { 
            "param_order" => [ "val" ],
            "val" => {
                "valtype" => "bool",
                "default" => 0,
            }
        },
        "leasefile_ro" => { 
            "param_order" => [ "val" ],
            "val" => {
                "valtype" => "bool",
                "default" => 0,
            }
        },
        "script_on_renewal" => { 
            "param_order" => [ "val" ],
            "val" => {
                "valtype" => "bool",
                "default" => 0,
            }
        },
        "bridge_interface" => { 
            "param_order" => [ "interface", "alias" ],
            "interface" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_interface"},
                "template" => "<" . $text{"tmpl_interface"} . ">"
            },
            "alias" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_aliases"},
                "template" => "<" . $text{"tmpl_alias"} . ">[,<" . $text{"tmpl_alias"} . ">]"
            },
        }, # =<interface>,<alias>[,<alias>]
        "shared_network" => { 
            "param_order" => [ "interface", "addr" ],
            "interface" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_interface_or_ip_address"},
                "template" => "<" . $text{"tmpl_interface"} . ">|<" . $text{"tmpl_address"} . ">"
            },
            "addr" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_ip_address"},
                "template" => "<" . $text{"tmpl_address"} . ">"
            },
        }, # =<interface|addr>,<addr>
        "domain" => { 
            "param_order" => [ "domain", "range", "local" ],
            "domain" => {
                "length" => 15,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_domain"},
                "template" => "<" . $text{"tmpl_domain"} . ">"
            },
            "range" => {
                "length" => 15,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_address_range"},
                "template" => "<" . $text{"tmpl_address_range"} . ">"
            },
            "local" => {
                "valtype" => "bool",
                "default" => 0,
                "label" => $text{"p_label_val_local"},
            },
        }, # =<domain>[,<address range>[,local]]
        "dhcp_fqdn" => { 
            "param_order" => [ "val" ],
            "val" => {
                "valtype" => "bool",
                "default" => 0,
            }
        },
        "dhcp_client_update" => { 
            "param_order" => [ "val" ],
            "val" => {
                "valtype" => "bool",
                "default" => 0,
            }
        },
        "enable_ra" => { 
            "param_order" => [ "val" ],
            "val" => {
                "valtype" => "bool",
                "default" => 0,
            }
        },
        "ra_param" => { 
            "param_order" => [ "interface", "mtu", "priority", "interval", "lifetime" ],
            "interface" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_interface"},
                "template" => "<" . $text{"tmpl_interface"} . ">"
            },
            "mtu" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_mtu"},
                "template" => "mtu:<" . $text{"tmpl_integer"} . ">|<" . $text{"tmpl_interface"} . ">|off"
            },
            "priority" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_priority"},
                "template" => "<high|low>" # literal value
            },
            "interval" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_interval"},
                "template" => "<" . $text{"tmpl_integer"} . ">"
            },
            "lifetime" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_lifetime"},
                "template" => "<" . $text{"tmpl_integer"} . ">"
            },
        }, # =<interface>,[mtu:<integer>|<interface>|off,][high,|low,]<ra-interval>[,<router lifetime>]
        "dhcp_reply_delay" => { 
            "param_order" => [ "tag", "delay" ],
            "tag" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_tag"},
                "template" => "tag:<" . $text{"tmpl_tag"} . ">"
            },
            "delay" => {
                "length" => 3,
                "valtype" => "int",
                "default" => 0,
                "required" => 1,
                "label" => $text{"p_label_val_delay"},
                "template" => "<" . $text{"tmpl_integer"} . ">"
            },
        }, # =[tag:<tag>,]<integer>
        "enable_tftp" => { 
            "param_order" => [ "val" ],
            "val" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_interfaces"},
                "template" => "<" . $text{"tmpl_interface"} . ">[,<" . $text{"tmpl_interface"} . ">]"
            },
        }, # [=<interface>[,<interface>]]
        "tftp_root" => { 
            "param_order" => [ "directory", "interface" ],
            "directory" => {
                "length" => 15,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_dirname"},
                "template" => "<" . $text{"tmpl_path_to_directory"} . ">"
            },
            "interface" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_interface"},
                "template" => "<" . $text{"tmpl_interface"} . ">"
            },
        }, # =<directory>[,<interface>]
        "tftp_no_fail" => { 
            "param_order" => [ "val" ],
            "val" => {
                "valtype" => "bool",
                "default" => 0,
            }
        },
        "tftp_unique_root" => { 
            "param_order" => [ "val" ],
            "val" => {
                "length" => 15,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => "ip|mac",
                "template" => "ip|mac" # literal value
            },
        }, # [=ip|mac]
        "tftp_secure" => { 
            "param_order" => [ "val" ],
            "val" => {
                "valtype" => "bool",
                "default" => 0,
            }
        },
        "tftp_lowercase" => { 
            "param_order" => [ "val" ],
            "val" => {
                "valtype" => "bool",
                "default" => 0,
            }
        },
        "tftp_max" => { 
            "param_order" => [ "val" ],
            "val" => {
                "length" => 3,
                "valtype" => "int",
                "default" => 0,
                "required" => 1,
                "label" => $text{"p_label_val_max_connections"},
                "template" => "<" . $text{"tmpl_integer"} . ">"
            }
        }, # =<connections>
        "tftp_mtu" => { 
            "param_order" => [ "val" ],
            "val" => {
                "length" => 3,
                "valtype" => "int",
                "default" => 0,
                "required" => 1,
                "label" => $text{"p_label_val_mtu"},
                "template" => "<" . $text{"tmpl_mtu"} . ">"
            }
        }, # =<mtu size>
        "tftp_no_blocksize" => { 
            "param_order" => [ "val" ],
            "val" => {
                "valtype" => "bool",
                "default" => 0,
            }
        },
        "tftp_port_range" => { 
            "param_order" => [ "start", "end" ],
            "start" => {
                "length" => 3,
                "valtype" => "int",
                "default" => 0,
                "required" => 1,
                "label" => $text{"p_label_val_start_port"},
                "template" => "<" . $text{"tmpl_port"} . ">"
            },
            "end" => {
                "length" => 3,
                "valtype" => "int",
                "default" => 0,
                "required" => 1,
                "label" => $text{"p_label_val_end_port"},
                "template" => "<" . $text{"tmpl_port"} . ">"
            },
        }, # =<start>,<end>
        "tftp_single_port" => { 
            "param_order" => [ "val" ],
            "val" => {
                "valtype" => "bool",
                "default" => 0,
            }
        },
        "conf_file" => { 
            "param_order" => [ "filename" ],
            "filename" => {
                "length" => 75,
                "valtype" => "file",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_filename"},
                "template" => "<" . $text{"tmpl_path_to_file"} . ">"
            }
        }, # =<file>
        "conf_dir" => { 
            "param_order" => [ "dirname", "filter", "exceptions" ],
            "dirname" => {
                "length" => 75,
                "valtype" => "dir",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_dirname"},
                "template" => "<" . $text{"tmpl_path_to_directory"} . ">"
            },
            "filter" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_filter"},
                "template" => $text{"tmpl_filter"}
            },
            "exceptions" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_exceptions"},
                "template" => $text{"tmpl_exceptions"}
            },
        }, # =<directory>[,<file-extension>......],
        "servers_file" => { 
            "param_order" => [ "filename" ],
            "filename" => {
                "length" => 75,
                "valtype" => "file",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_filename"},
                "template" => "<" . $text{"tmpl_path_to_file"} . ">"
            }
        }, # =<file>
    );
}

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
my $SETTAG = "(?:set:)[!0-9a-zA-Z\_\.\-]*";
my $IPV6PROP = "static|ra-only|ra-names|ra-stateless|slaac|ra-advrouter|off-link";
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
    &init_configfield_fields();
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

    my $max_iterations = 20;
    my $current = 0;
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
                my $configfield = $2;
                my $internalfield = &config_to_internal($configfield);
                $remainder = $3;
                %temp = ( );
                $temp{"used"} = ($line !~ /^\#/);
                $temp{"line"} = $lineno;
                $temp{"file"} = $config_filename;
                $temp{"full"} = $line;
                # $temp{"filearray"}=\$config_file;
                if ( ! grep { /^$configfield$/ } ( keys %dnsmconfigvals ) ) {
                    print "Error in line $lineno ($configfield: unknown option)! ";
                    $$dnsmconfig_ref{"errors"}++;
                    next;
                }
                my %confvar = %dnsmconfigvals{"$configfield"};
                if ( $confvar{"mult"} ne "" ) {
                    my $sep = $confvar{"mult"};
                    # $temp{"val"} = @();
                    while ( $remainder =~ /^$sep?($NAME)($sep[0-9a-zA-Z\.\-\/]*)*/ ) {
                        push @{ $temp{"val"} }, ( $1 );
                        $remainder = $2;
                    }
                }
                elsif ( grep { /^$configfield$/ } ( @confsingles ) ) {
                    if ($configfield_fields->{$internalfield}->{"val"}->{"arr"} == 1) {
                        push( @{$temp{"val"}}, split(",", $remainder) );
                    }
                    else {
                        $temp{"val"} = $remainder;
                    }
                    # $temp{"val"} = "test";
                }
                else {
                    my %valtemp = ();
                    $valtemp{"full"} = $remainder;
                    if ($configfield eq "local") {
                        $configfield = "server";
                        $valtemp{"is_local"} = 1;
                    }
                    given ( "$configfield" ){
                        when ("auth-server") { # =<domain>,[<interface>[/4|/6]|<ip-address>...]
                            if( $remainder =~ /^($NAME),(.*)$/ ) {
                                $valtemp{"domain"} = $1;
                                $valtemp{"for"} = $2;
                            }
                            else {
                                $valtemp{"domain"} = $remainder;
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
                        when ("local") { # =[/[<domain>]/[domain/]][<ipaddr>[#<port>]][@<interface>][@<source-ip>[#<port>]]
                            $current = 0;
                            while ( $remainder =~ /^\/((?:[a-z0-9](?:[a-z0-9\-]{0,61}[a-z0-9\.])?)+[a-z0-9][a-z0-9\-]{0,61}[a-z0-9])\/(.*)$/ ) {
                                push( @{ $valtemp{"domain"} }, $1 );
                                $remainder = $2;
                                last if ($current++ >= $max_iterations);
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
                        when ("server") { # =[/[<domain>]/[domain/]][<ipaddr>[#<port>]][@<interface>][@<source-ip>[#<port>]]
                            $current = 0;
                            while ( $remainder =~ /^\/((?:[a-z0-9](?:[a-z0-9\-]{0,61}[a-z0-9\.])?)+[a-z0-9][a-z0-9\-]{0,61}[a-z0-9])\/(.*)$/ ) {
                                push( @{ $valtemp{"domain"} }, $1 );
                                $remainder = $2;
                                last if ($current++ >= $max_iterations);
                            }
                            if ( $remainder =~ /^($IPADDR(#[0-9]{1,5})?)(.*)$/ ) {
                                $valtemp{"ip"} = $1;
                                $remainder = $3;
                            }
                            elsif ( $remainder =~ /^($IPV6ADDR(%[a-zA-Z0-9])?)(.*)$/ ) {
                                $valtemp{"ip"} = $1;
                                $remainder = $3;
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
                                    $valtemp{"addr"} = $2;
                                }
                            }
                            elsif ( $remainder =~ /^\/(.*)\/($IPV6ADDR)?$/ ) {
                                $valtemp{"domain"}=$1;
                                if ( defined ($2) ) {
                                    $valtemp{"addr"} = $2;
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
                                my $domains = $1;
                                my $ipsets = $2;
                                $current = 0;
                                while ($domains =~ /^([a-zA-Z\_\.][0-9a-zA-Z\_\.\-]*)((?:\/)(.*))*$/ ) {
                                    push( @{ $valtemp{"domain"} }, $1 );
                                    $domains = $3;
                                    last if ($current++ >= $max_iterations);
                                }
                                $current = 0;
                                while ($ipsets =~ /^([0-9a-zA-Z\.\-]+)((?:,)(.*))*$/ && defined($1) ) {
                                    push( @{ $valtemp{"ipset"} }, $1 );
                                    $ipsets = $3;
                                    last if ($current++ >= $max_iterations);
                                }
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
                                        if ( $remainder =~ /^($NUMBER)((?:,)(.*))*$/ ) {
                                            $valtemp{"priority"}=$1;
                                            $remainder=$3;
                                            if ( $remainder =~ /^($NUMBER)((?:,)(.*))*$/ ) {
                                                $valtemp{"weight"}=$1;
                                            }
                                        }
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
                            if ( $remainder =~ /^($NAME)((?:,)(.*))*$/ ) {
                                $valtemp{"domain"} = $1;
                                $remainder = $3;
                                if ( $remainder =~ /(exclude:.*)*$/ ) {
                                    $current = 0;
                                    while ( $remainder =~ /((?:exclude:)($IPADDR))((?:,exclude:)(.*))*$/ ) {
                                        push( @{ $valtemp{"exclude"} }, $2 );
                                        $remainder = $4;
                                        last if ($current++ >= $max_iterations);
                                    }
                                }
                                if ( $remainder ne "" ) {
                                    $current = 0;
                                    while ( $remainder =~ /^($IPADDR)((?:,)(.*))*$/ ) {
                                        push( @{ $valtemp{"include"} }, $1 );
                                        $remainder = $3;
                                        last if ($current++ >= $max_iterations);
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
                            $current = 0;
                            while ($remainder =~ /^($TAG)\,([0-9a-zA-Z\.\,\-\_: ]*)/ ) { # first get tag
                                my $tagdirective = $1;
                                $remainder = $4;
                                if ($tagdirective =~ /^tag:([0-9a-zA-Z\-\_]*)/) {
                                    my $tag = $1;
                                    push(@{ $valtemp{"tag"} }, $tag);
                                }
                                elsif ($tagdirective =~ /^set:([0-9a-zA-Z\-\_]*)/) {
                                    my $tag = $1;
                                    push(@line_set_tags, $tag);

                                    $valtemp{"settag"} = $tag;
                                }
                                last if ($current++ >= $max_iterations);
                            }
                            $valtemp{"ipversion"} = 4;
                            $valtemp{"static"} = 0;
                            if ($remainder =~ /^($IPADDR)((?:\,)([0-9a-zA-Z\.\,\-\_]*))*/ ) { # IPv4
                                # ...start...
                                $valtemp{"start"} = $1;
                                $remainder = $3;
                                $valtemp{"proxy"} = 0;
                                if ($remainder =~ /^($IPADDR)((?:\,)([0-9a-zA-Z\.\,\-\_]*))*/ ) {
                                    # ...end...
                                    $valtemp{"end"} = $1;
                                    $remainder = $3;
                                }
                                elsif ($remainder =~ /^(static)((?:\,)([0-9a-zA-Z\.\,\-\_]*))*/ ) {
                                    $valtemp{"static"} = 1;
                                    $remainder = $3;
                                }
                                elsif ($remainder =~ /^(proxy)((?:\,)([0-9a-zA-Z\.\,\-\_]*))*/ ) {
                                    $valtemp{"proxy"} = 1;
                                    $remainder = $3;
                                }
                                $valtemp{"mask"} = "";
                                $valtemp{"mask-used"} = 0;
                                if ($remainder =~ /^($IPADDR)((?:\,)([0-9a-zA-Z\.\,\-\_]*))*/ ) {
                                    # ...netmask
                                    $valtemp{"mask"} = $1;
                                    $valtemp{"mask-used"} = 1;
                                    $remainder = $3;
                                    if ($remainder =~ /^($IPADDR)((?:\,)([0-9a-zA-Z\.\,\-\_]*))*/ ) {
                                        # ...broadcast
                                        $valtemp{"broadcast"} = $1;
                                        $remainder = $3;
                                    }
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
                                $valtemp{"ra-advrouter"} = 0;
                                $valtemp{"off-link"} = 0;
                                $current = 0;
                                while ($remainder =~ /^($IPV6PROP)(\,[\s]*([0-9a-zA-Z\.\,\-\_: ]*))*/ ) {
                                    if ($1 eq "static") {
                                        $valtemp{"static"} = 1;
                                    }
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
                                    if ($1 eq "ra-advrouter") {
                                        $valtemp{"ra-advrouter"} = 1;
                                    }
                                    if ($1 eq "off-link") {
                                        $valtemp{"off-link"} = 1;
                                    }
                                    $remainder = $3;
                                    last if ($current++ >= $max_iterations);
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
                            else {
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
                            $current = 0;
                            while ($remainder =~ /^([0-9a-zA-Z\.\,\-\_:\* ]*)($SETTAG)((,)([0-9a-zA-Z\.\,\-\_:\* ]*))*$/ && defined ($3) && defined ($4)) {
                                push( @{$valtemp{"settag"}}, $2);
                                $remainder = $1 . $5;
                                last if ($current++ >= $max_iterations);
                            }
                            if ($remainder =~ /^([0-9a-zA-Z\.\,\-\_:\* ]*)($TAG)((,)([0-9a-zA-Z\.\,\-\_:\* ]*))*$/ && defined ($3) && defined ($4)) {
                                $valtemp{"tag"}=$4;
                                $remainder = $1 . $7;
                            }
                            $valtemp{"mac"} = "";
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
                                $current = 0;
                                while ($remainder =~ /^([0-9a-zA-Z\.\,\-\_:\*]*)($MAC)(,([0-9a-zA-Z\.\,\-\_:\*]*))*$/ ) { # IPv4 only
                                    $remainder = $1 . $4;
                                    if (defined ($2)) {
                                        $valtemp{"mac"} = ($valtemp{"mac"} eq "" ? $2 : $2 . "," . $valtemp{"mac"});
                                    }
                                    else {
                                        last;
                                    }
                                    last if ($current++ >= $max_iterations);
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
                            $valtemp{"ignore"} = 0;
                            if ($remainder =~ /^(([0-9a-zA-Z\.\,\-\_:\*]*)(,))*(ignore)$/  && defined ($4)) {
                                # ...time (optionally)
                                $remainder = $2;
                                $valtemp{"ignore"} = 1;
                            }
                            $valtemp{"ip"} = "";
                            $current = 0;
                            while ($remainder =~ /^((?:[0-9a-zA-Z\,\-\_:]*)(?:,))*($IPADDR)(,([0-9a-zA-Z\.\,\-\_:]*))*$/ && defined ($2)) {
                                $remainder = $1 . (defined ($3) && defined ($4) ? "," . $4 : "");
                                $valtemp{"ip"} = ($valtemp{"ip"} ? "," : "") . $2;
                                last if ($current++ >= $max_iterations);
                            }
                            if ($remainder =~ /^(([0-9a-zA-Z\,\-\_\:]*\,\h*)*)(\[($IPV6ADDR)\])(,\h*[0-9a-zA-Z\.\-\_:]*)*\h*$/ && defined ($3)) { # IPv6
                                $remainder= $1 . (defined ($1) && defined ($5) ? "," . $5 : "");
                                $valtemp{"ip"} .= ($valtemp{"ip"} ? "," : "") . $3;
                            }
                            $valtemp{"hostname-used"} = 0;
                            if ($remainder =~ /^([\h\,]*)($NAME)([\h\,]*)$/ ) {
                                # network id...hostname?
                                $valtemp{"hostname"}=$2;
                                $valtemp{"hostname-used"} = 1;
                                # $remainder = $2;
                            }
                        }
                        when ("dhcp-option") { # =[tag:<tag>,[tag:<tag>,]][encap:<opt>,][vi-encap:<enterprise>,][vendor:[<vendor-class>],][<opt>|option:<opt-name>|option6:<opt>|option6:<opt-name>],[<value>[,<value>]]
                            # too many to classify - all values as string!
                            $remainder =~ s/^\s+|\s+$//g ;
                            $valtemp{"forced"} = 0;
                            $valtemp{"tag"} = ( );
                            $current = 0;
                            # $TAG = "(set|tag):([0-9a-zA-Z\_\.\-]*)";
                            while ($remainder =~ /^($TAG)((,[\s]*)([0-9a-zA-Z\,\_\.:;\-\/\\ \'\"\=\[\]\#\(\)]*))*$/) {
                                my $tag  = $3;
                                push @{ $valtemp{"tag"} }, $tag;
                                $remainder = $6;
                                $remainder =~ s/^\s+|\s+$//g ;
                                last if ($current++ >= $max_iterations);
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
                            $configfield = "dhcp-option";
                            # too many to classify - all values as string!
                            $remainder =~ s/^\s+|\s+$//g ;
                            $valtemp{"forced"} = 1;
                            $valtemp{"tag"} = ( );
                            $current = 0;
                            # $TAG = "(set|tag):([0-9a-zA-Z\_\.\-]*)";
                            while ($remainder =~ /^($TAG)((,[\s]*)([0-9a-zA-Z\,\_\.:;\-\/\\ \'\"\=\[\]\#\(\)]*))*$/) {
                                my $tag  = $3;
                                push @{ $valtemp{"tag"} }, $tag;
                                $remainder = $6;
                                $remainder =~ s/^\s+|\s+$//g ;
                                last if ($current++ >= $max_iterations);
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
                            $current = 0;
                            while ( $remainder =~ /^((set:)([0-9a-zA-Z\_\.\-!]*))\,([0-9a-zA-Z\,\.\-\:]*)$/ ) {
                                push( @{ $valtemp{"settag"} }, $3 );
                                $remainder = $4;
                                last if ($current++ >= $max_iterations);
                            }
                            $current = 0;
                            while ( $remainder =~ /^((tag:)([0-9a-zA-Z\_\.\-!]*))\,([0-9a-zA-Z\,\.\-\:]*)$/ ) {
                                push( @{ $valtemp{"iftag"} }, $3 );
                                $remainder = $4;
                                last if ($current++ >= $max_iterations);
                            }
                        }
                        when ("dhcp-ignore") { # =tag:<tag>[,tag:<tag>]
                            $current = 0;
                            while ( $remainder =~ /^((tag:)([0-9a-zA-Z\_\.\-!]*))\,([0-9a-zA-Z\,\.\-\:]*)$/ ) {
                                push( @{ $valtemp{"tag"} }, $3 );
                                $remainder = $4;
                                last if ($current++ >= $max_iterations);
                            }
                        }
                        when ("dhcp-ignore-names") { # [=tag:<tag>[,tag:<tag>]]
                            $current = 0;
                            while ( $remainder =~ /^((tag:)([0-9a-zA-Z\_\.\-!]*))\,([0-9a-zA-Z\,\.\-\:]*)$/ ) {
                                push( @{ $valtemp{"tag"} }, $3 );
                                $remainder = $4;
                                last if ($current++ >= $max_iterations);
                            }
                        }
                        when ("dhcp-generate-names") { # =tag:<tag>[,tag:<tag>]
                            $current = 0;
                            while ( $remainder =~ /^((tag:)([0-9a-zA-Z\_\.\-!]*))\,([0-9a-zA-Z\,\.\-\:]*)$/ ) {
                                push( @{ $valtemp{"tag"} }, $3 );
                                $remainder = $4;
                                last if ($current++ >= $max_iterations);
                            }
                        }
                        when ("dhcp-broadcast") { # [=tag:<tag>[,tag:<tag>]]
                            $current = 0;
                            while ( $remainder =~ /^((tag:)([0-9a-zA-Z\_\.\-!]*))\,([0-9a-zA-Z\,\.\-\:]*)$/ ) {
                                push( @{ $valtemp{"tag"} }, $3 );
                                $remainder = $4;
                                last if ($current++ >= $max_iterations);
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
                                $current = 0;
                                while ( $remainder =~ /^(.*)((?:,)(.*))*$/ ) {
                                    push( @{ $valtemp{"alias"} }, $1 );
                                    $remainder = $3;
                                    last if ($current++ >= $max_iterations);
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
                                if ( $remainder =~ /^([0-9\.]*)\,([0-9\.]*)([0-9a-z\,\.\/]*)*$/ ) {
                                    # range = <ip address>,<ip address>
                                    $valtemp{"range"} = $1 . ',' . $2;
                                    if ( $remainder =~ /,\s*local$/ ) {
                                        $valtemp{"local"} = 1;
                                    }
                                }
                                elsif ( $remainder =~ /^(([0-9\,\.\/]*)\/(8|16|24))([0-9a-z\,\.\/]*)*$/ ) {
                                    # range = <ip address>/<netmask>
                                    $valtemp{"range"} = $1;
                                    if ( $remainder =~ /,\s*local$/ ) {
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
                        when ("servers-file") {
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
                        default {

                        }
                    }
                    $temp{"val"} = { %valtemp };
                }
                if ( grep { /^$configfield$/ } ( @confarrs ) ) {
                    push @{ $$dnsmconfig_ref{"$configfield"} }, { %temp };
                }
                else {
                    if ($$dnsmconfig_ref{"$configfield"}{"used"} == 0) {
                        $$dnsmconfig_ref{"$configfield"} = { %temp };
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
        }
    }
} #end of sub parse_config_file

1;
