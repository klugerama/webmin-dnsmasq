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
#   ip -------- IP address (v4 or v6)
#   var ------- various and/or multiple values
# arr:
#   1 --------- option may be specified multiple times
# default:
#   value if none is specified
# mult:
#   {char} ---- (complete) specified value may be specified multiple times, separated by the specified character
our %dnsmconfigvals = (
    "no-hosts"                  => { "idx" => 0,   "valtype" => "bool",    "section" => "dns",   "page" => "1", "tab" => "1", "arr" => 0, "mult" => "", "default" => 0 },
    "addn-hosts"                => { "idx" => 1,   "valtype" => "path",    "section" => "dns",   "page" => "1", "tab" => "2", "arr" => 1, "mult" => "" }, # =<file>
    "hostsdir"                  => { "idx" => 2,   "valtype" => "dir",     "section" => "dns",   "page" => "1", "tab" => "3", "arr" => 1, "mult" => "" }, # =<path>
    "expand-hosts"              => { "idx" => 3,   "valtype" => "bool",    "section" => "dns",   "page" => "1", "tab" => "1", "arr" => 0, "mult" => "", "default" => 0 },
    "local-ttl"                 => { "idx" => 4,   "valtype" => "int",     "section" => "dns",   "page" => "1", "tab" => "1", "arr" => 0, "mult" => "", "default" => 0 }, # =<time>
    "dhcp-ttl"                  => { "idx" => 5,   "valtype" => "int",     "section" => "dns",   "page" => "1", "tab" => "1", "arr" => 0, "mult" => "", "default" => 0 }, # =<time>
    "neg-ttl"                   => { "idx" => 6,   "valtype" => "int",     "section" => "dns",   "page" => "1", "tab" => "1", "arr" => 0, "mult" => "", "default" => 0 }, # =<time>
    "max-ttl"                   => { "idx" => 7,   "valtype" => "int",     "section" => "dns",   "page" => "1", "tab" => "1", "arr" => 0, "mult" => "", "default" => 0 }, # =<time>
    "max-cache-ttl"             => { "idx" => 8,   "valtype" => "int",     "section" => "dns",   "page" => "1", "tab" => "1", "arr" => 0, "mult" => "", "default" => 0 }, # =<time>
    "min-cache-ttl"             => { "idx" => 9,   "valtype" => "int",     "section" => "dns",   "page" => "1", "tab" => "1", "arr" => 0, "mult" => "", "default" => 0 }, # =<time>
    "auth-ttl"                  => { "idx" => 10,  "valtype" => "int",     "section" => "dns",   "page" => "7", "tab" => "1", "arr" => 0, "mult" => "", "default" => 0 }, # =<time>
    "log-queries"               => { "idx" => 11,  "valtype" => "string",  "section" => "dns",   "page" => "1", "tab" => "1", "arr" => 0, "mult" => "", "default" => 0 }, # [=extra]
    "log-facility"              => { "idx" => 12,  "valtype" => "string",  "section" => "dns",   "page" => "1", "tab" => "1", "arr" => 0, "mult" => "" }, # =<facility>
    "log-debug"                 => { "idx" => 13,  "valtype" => "bool",    "section" => "dns",   "page" => "1", "tab" => "1", "arr" => 0, "mult" => "", "default" => 0 },
    "log-async"                 => { "idx" => 14,  "valtype" => "int",     "section" => "dns",   "page" => "1", "tab" => "1", "arr" => 0, "mult" => "", "default" => 5, "val_optional" => 1 }, # [=<lines>]
    "pid-file"                  => { "idx" => 15,  "valtype" => "file",    "section" => "dns",   "page" => "1", "tab" => "1", "arr" => 0, "mult" => "" }, # =<path>
    "user"                      => { "idx" => 16,  "valtype" => "string",  "section" => "dns",   "page" => "1", "tab" => "1", "arr" => 0, "mult" => "", "default" => "nobody" }, # =<username>
    "group"                     => { "idx" => 17,  "valtype" => "string",  "section" => "dns",   "page" => "1", "tab" => "1", "arr" => 0, "mult" => "", "default" => "dip" }, # =<groupname>
    "port"                      => { "idx" => 18,  "valtype" => "int",     "section" => "dns",   "page" => "1", "tab" => "1", "arr" => 0, "mult" => "", "default" => 53 }, # =<port>
    "edns-packet-max"           => { "idx" => 19,  "valtype" => "int",     "section" => "dns",   "page" => "1", "tab" => "1", "arr" => 0, "mult" => "", "default" => 4096 }, # =<size>
    "query-port"                => { "idx" => 20,  "valtype" => "int",     "section" => "dns",   "page" => "1", "tab" => "1", "arr" => 0, "mult" => "" }, # =<query_port>
    "min-port"                  => { "idx" => 21,  "valtype" => "int",     "section" => "dns",   "page" => "1", "tab" => "1", "arr" => 0, "mult" => "", "default" => 1024 }, # =<port>
    "max-port"                  => { "idx" => 22,  "valtype" => "int",     "section" => "dns",   "page" => "1", "tab" => "1", "arr" => 0, "mult" => "" }, # =<port>
    "interface"                 => { "idx" => 23,  "valtype" => "string",  "section" => "dns",   "page" => "3", "tab" => "2", "arr" => 1, "mult" => "" }, # =<interface name>
    "except-interface"          => { "idx" => 24,  "valtype" => "string",  "section" => "dns",   "page" => "3", "tab" => "3", "arr" => 1, "mult" => "" }, # =<interface name>
    "auth-server"               => { "idx" => 25,  "valtype" => "var",     "section" => "dns",   "page" => "7", "tab" => "1", "arr" => 0, "mult" => "" }, # =<domain>,[<interface>|<ip-address>...]
    "local-service"             => { "idx" => 26,  "valtype" => "bool",    "section" => "dns",   "page" => "1", "tab" => "1", "arr" => 0, "mult" => "", "default" => 0 },
    "no-dhcp-interface"         => { "idx" => 27,  "valtype" => "string",  "section" => "dns",   "page" => "3", "tab" => "4", "arr" => 1, "mult" => "" }, # =<interface name>
    "listen-address"            => { "idx" => 28,  "valtype" => "ip",      "section" => "dns",   "page" => "3", "tab" => "5", "arr" => 1, "mult" => "" }, # =<ipaddr>
    "bind-interfaces"           => { "idx" => 29,  "valtype" => "bool",    "section" => "dns",   "page" => "3", "tab" => "1", "arr" => 0, "mult" => "", "default" => 0 },
    "bind-dynamic"              => { "idx" => 30,  "valtype" => "bool",    "section" => "dns",   "page" => "3", "tab" => "1", "arr" => 0, "mult" => "", "default" => 0 },
    "localise-queries"          => { "idx" => 31,  "valtype" => "bool",    "section" => "dns",   "page" => "1", "tab" => "1", "arr" => 0, "mult" => "", "default" => 0 },
    "bogus-priv"                => { "idx" => 32,  "valtype" => "bool",    "section" => "dns",   "page" => "1", "tab" => "1", "arr" => 0, "mult" => "", "default" => 0 },
    "alias"                     => { "idx" => 33,  "valtype" => "var",     "section" => "dns",   "page" => "4", "tab" => "3", "arr" => 1, "mult" => "" }, # =[<old-ip>]|[<start-ip>-<end-ip>],<new-ip>[,<mask>] # previously "dns_forced"?
    "bogus-nxdomain"            => { "idx" => 34,  "valtype" => "var",     "section" => "dns",   "page" => "4", "tab" => "4", "arr" => 1, "mult" => "" }, # =<ipaddr>[/prefix]
    "ignore-address"            => { "idx" => 35,  "valtype" => "var",     "section" => "dns",   "page" => "4", "tab" => "6", "arr" => 1, "mult" => "" }, # =<ipaddr>[/prefix]
    "filterwin2k"               => { "idx" => 36,  "valtype" => "bool",    "section" => "dns",   "page" => "1", "tab" => "1", "arr" => 0, "mult" => "", "default" => 0 },
    "resolv-file"               => { "idx" => 37,  "valtype" => "file",    "section" => "dns",   "page" => "1", "tab" => "4", "arr" => 1, "mult" => "", "default" => "/etc/resolv.conf" }, # =<file>
    "no-resolv"                 => { "idx" => 38,  "valtype" => "bool",    "section" => "dns",   "page" => "1", "tab" => "1", "arr" => 0, "mult" => "", "default" => 0 },
    "enable-dbus"               => { "idx" => 39,  "valtype" => "string",  "section" => "dns",   "page" => "1", "tab" => "1", "arr" => 0, "mult" => "", "default" => "uk.org.thekelleys.dnsmasq", "val_optional" => 1 }, # [=<service-name>]
    "enable-ubus"               => { "idx" => 40,  "valtype" => "string",  "section" => "dns",   "page" => "1", "tab" => "1", "arr" => 0, "mult" => "", "default" => "dnsmasq", "val_optional" => 1 }, # [=<service-name>]
    "strict-order"              => { "idx" => 41,  "valtype" => "bool",    "section" => "dns",   "page" => "2", "tab" => "1", "arr" => 0, "mult" => "", "default" => 0 },
    "all-servers"               => { "idx" => 42,  "valtype" => "bool",    "section" => "dns",   "page" => "2", "tab" => "1", "arr" => 0, "mult" => "", "default" => 0 },
    "dns-loop-detect"           => { "idx" => 43,  "valtype" => "bool",    "section" => "dns",   "page" => "1", "tab" => "1", "arr" => 0, "mult" => "", "default" => 0 },
    "stop-dns-rebind"           => { "idx" => 44,  "valtype" => "bool",    "section" => "dns",   "page" => "4", "tab" => "1", "arr" => 0, "mult" => "", "default" => 0 },
    "rebind-localhost-ok"       => { "idx" => 45,  "valtype" => "bool",    "section" => "dns",   "page" => "4", "tab" => "1", "arr" => 0, "mult" => "", "default" => 0 },
    "rebind-domain-ok"          => { "idx" => 46,  "valtype" => "string",  "section" => "dns",   "page" => "4", "tab" => "2", "arr" => 0, "mult" => "/" }, # =[<domain>]|[[/<domain>/[<domain>/]
    "no-poll"                   => { "idx" => 47,  "valtype" => "bool",    "section" => "dns",   "page" => "1", "tab" => "1", "arr" => 0, "mult" => "", "default" => 0 },
    "clear-on-reload"           => { "idx" => 48,  "valtype" => "bool",    "section" => "dns",   "page" => "1", "tab" => "1", "arr" => 0, "mult" => "", "default" => 0 },
    "domain-needed"             => { "idx" => 49,  "valtype" => "bool",    "section" => "dns",   "page" => "1", "tab" => "1", "arr" => 0, "mult" => "", "default" => 0 },
    "local"                     => { "idx" => 50,  "valtype" => "var",     "section" => "dns",   "page" => "2", "tab" => "2", "arr" => 1, "mult" => "" }, # =[/[<domain>]/[domain/]][<ipaddr>[#<port>]][@<interface>][@<source-ip>[#<port>]]
    "server"                    => { "idx" => 51,  "valtype" => "var",     "section" => "dns",   "page" => "2", "tab" => "2", "arr" => 1, "mult" => "" }, # =[/[<domain>]/[domain/]][<ipaddr>[#<port>]][@<interface>][@<source-ip>[#<port>]]
    "rev-server"                => { "idx" => 52,  "valtype" => "var",     "section" => "dns",   "page" => "2", "tab" => "3", "arr" => 1, "mult" => "" }, # =<ip-address>/<prefix-len>[,<ipaddr>][#<port>][@<interface>][@<source-ip>[#<port>]]
    "address"                   => { "idx" => 53,  "valtype" => "var",     "section" => "dns",   "page" => "4", "tab" => "5", "arr" => 1, "mult" => "" }, # =/<domain>[/<domain>...]/[<ipaddr>]
    "ipset"                     => { "idx" => 54,  "valtype" => "var",     "section" => "dns",   "page" => "5", "tab" => "3", "arr" => 1, "mult" => "" }, # =/<domain>[/<domain>...]/<ipset>[,<ipset>...]
    "connmark-allowlist-enable" => { "idx" => 55,  "valtype" => "string",  "section" => "dns",   "page" => "5", "tab" => "1", "arr" => 0, "mult" => "", "val_optional" => 1 }, # [=<mask>]
    "connmark-allowlist"        => { "idx" => 56,  "valtype" => "var",     "section" => "dns",   "page" => "5", "tab" => "4", "arr" => 1, "mult" => "" }, # =<connmark>[/<mask>][,<pattern>[/<pattern>...]] 
    "mx-host"                   => { "idx" => 57,  "valtype" => "var",     "section" => "dns",   "page" => "5", "tab" => "2", "arr" => 0, "mult" => "" }, # =<mx name>[[,<hostname>],<preference>]
    "mx-target"                 => { "idx" => 58,  "valtype" => "string",  "section" => "dns",   "page" => "5", "tab" => "1", "arr" => 0, "mult" => "" }, # =<hostname>
    "selfmx"                    => { "idx" => 59,  "valtype" => "bool",    "section" => "dns",   "page" => "5", "tab" => "1", "arr" => 0, "mult" => "", "default" => 0 },
    "localmx"                   => { "idx" => 60,  "valtype" => "bool",    "section" => "dns",   "page" => "5", "tab" => "1", "arr" => 0, "mult" => "", "default" => 0 },
    "srv-host"                  => { "idx" => 61,  "valtype" => "var",     "section" => "dns",   "page" => "5", "tab" => "2", "arr" => 0, "mult" => "" }, # =<_service>.<_prot>.[<domain>],[<target>[,<port>[,<priority>[,<weight>]]]]
    "host-record"               => { "idx" => 62,  "valtype" => "var",     "section" => "dns",   "page" => "5", "tab" => "2", "arr" => 0, "mult" => "" }, # =<name>[,<name>....],[<IPv4-address>],[<IPv6-address>][,<TTL>]
    "dynamic-host"              => { "idx" => 63,  "valtype" => "var",     "section" => "dns",   "page" => "5", "tab" => "2", "arr" => 0, "mult" => "" }, # =<name>,[IPv4-address],[IPv6-address],<interface>
    "txt-record"                => { "idx" => 64,  "valtype" => "var",     "section" => "dns",   "page" => "5", "tab" => "2", "arr" => 0, "mult" => "" }, # =<name>[[,<text>],<text>]
    "ptr-record"                => { "idx" => 65,  "valtype" => "var",     "section" => "dns",   "page" => "5", "tab" => "2", "arr" => 0, "mult" => "" }, # =<name>[,<target>]
    "naptr-record"              => { "idx" => 66,  "valtype" => "var",     "section" => "dns",   "page" => "5", "tab" => "2", "arr" => 0, "mult" => "" }, # =<name>,<order>,<preference>,<flags>,<service>,<regexp>[,<replacement>]
    "caa-record"                => { "idx" => 67,  "valtype" => "var",     "section" => "dns",   "page" => "5", "tab" => "2", "arr" => 0, "mult" => "" }, # =<name>,<flags>,<tag>,<value>
    "cname"                     => { "idx" => 68,  "valtype" => "var",     "section" => "dns",   "page" => "5", "tab" => "2", "arr" => 0, "mult" => "" }, # =<cname>,[<cname>,]<target>[,<TTL>]
    "dns-rr"                    => { "idx" => 69,  "valtype" => "var",     "section" => "dns",   "page" => "5", "tab" => "2", "arr" => 0, "mult" => "" }, # =<name>,<RR-number>,[<hex data>]
    "interface-name"            => { "idx" => 70,  "valtype" => "var",     "section" => "dns",   "page" => "5", "tab" => "2", "arr" => 0, "mult" => "" }, # =<name>,<interface>[/4|/6]
    "synth-domain"              => { "idx" => 71,  "valtype" => "var",     "section" => "dns",   "page" => "5", "tab" => "2", "arr" => 0, "mult" => "" }, # =<domain>,<address range>[,<prefix>[*]]
    "dumpfile"                  => { "idx" => 72,  "valtype" => "file",    "section" => "dns",   "page" => "1", "tab" => "1", "arr" => 0, "mult" => "" }, # =<path/to/file>
    "dumpmask"                  => { "idx" => 73,  "valtype" => "string",  "section" => "dns",   "page" => "1", "tab" => "1", "arr" => 0, "mult" => "" }, # =<mask>
    "add-mac"                   => { "idx" => 74,  "valtype" => "string",  "section" => "dns",   "page" => "2", "tab" => "1", "arr" => 0, "mult" => "", "val_optional" => 1 }, # [=base64|text]
    "add-cpe-id"                => { "idx" => 75,  "valtype" => "string",  "section" => "dns",   "page" => "2", "tab" => "1", "arr" => 0, "mult" => "" }, # =<string>
    "add-subnet"                => { "idx" => 76,  "valtype" => "var",     "section" => "dns",   "page" => "2", "tab" => "1", "arr" => 0, "mult" => "", "val_optional" => 1 }, # [[=[<IPv4 address>/]<IPv4 prefix length>][,[<IPv6 address>/]<IPv6 prefix length>]]
    "umbrella"                  => { "idx" => 77,  "valtype" => "var",     "section" => "dns",   "page" => "2", "tab" => "1", "arr" => 0, "mult" => "", "val_optional" => 1 }, # [=deviceid:<deviceid>[,orgid:<orgid>]]
    "cache-size"                => { "idx" => 78,  "valtype" => "int",     "section" => "dns",   "page" => "1", "tab" => "1", "arr" => 0, "mult" => "", "default" => 150 }, # =<cachesize>
    "no-negcache"               => { "idx" => 79,  "valtype" => "bool",    "section" => "dns",   "page" => "1", "tab" => "1", "arr" => 0, "mult" => "", "default" => 0 },
    "dns-forward-max"           => { "idx" => 80,  "valtype" => "int",     "section" => "dns",   "page" => "1", "tab" => "1", "arr" => 0, "mult" => "", "default" => 150 }, # =<queries>
    "dnssec"                    => { "idx" => 81,  "valtype" => "bool",    "section" => "dns",   "page" => "6", "tab" => "1", "arr" => 0, "mult" => "", "default" => 0 },
    "trust-anchor"              => { "idx" => 82,  "valtype" => "var",     "section" => "dns",   "page" => "6", "tab" => "1", "arr" => 0, "mult" => "" }, # =[<class>],<domain>,<key-tag>,<algorithm>,<digest-type>,<digest>
    "dnssec-check-unsigned"     => { "idx" => 83,  "valtype" => "string",  "section" => "dns",   "page" => "6", "tab" => "1", "arr" => 0, "mult" => "", "default" => 1, "val_optional" => 1 }, # [=no]
    "dnssec-no-timecheck"       => { "idx" => 84,  "valtype" => "bool",    "section" => "dns",   "page" => "6", "tab" => "1", "arr" => 0, "mult" => "", "default" => 0 },
    "dnssec-timestamp"          => { "idx" => 85,  "valtype" => "file",    "section" => "dns",   "page" => "6", "tab" => "1", "arr" => 0, "mult" => "" }, # =<path>
    "proxy-dnssec"              => { "idx" => 86,  "valtype" => "bool",    "section" => "dns",   "page" => "6", "tab" => "1", "arr" => 0, "mult" => "", "default" => 0 },
    "dnssec-debug"              => { "idx" => 87,  "valtype" => "bool",    "section" => "dns",   "page" => "6", "tab" => "1", "arr" => 0, "mult" => "", "default" => 0 },
    "auth-zone"                 => { "idx" => 88,  "valtype" => "var",     "section" => "dns",   "page" => "7", "tab" => "1", "arr" => 0, "mult" => "" }, # =<domain>[,<subnet>[/<prefix length>][,<subnet>[/<prefix length>]|<interface>.....][,exclude:<subnet>[/<prefix length>]|<interface>].....]
    "auth-soa"                  => { "idx" => 89,  "valtype" => "var",     "section" => "dns",   "page" => "7", "tab" => "1", "arr" => 0, "mult" => "" }, # =<serial>[,<hostmaster>[,<refresh>[,<retry>[,<expiry>]]]]
    "auth-sec-servers"          => { "idx" => 90,  "valtype" => "string",  "section" => "dns",   "page" => "7", "tab" => "1", "arr" => 0, "mult" => "," }, # =<domain>[,<domain>[,<domain>...]]
    "auth-peer"                 => { "idx" => 91,  "valtype" => "ip",      "section" => "dns",   "page" => "7", "tab" => "1", "arr" => 0, "mult" => "," }, # =<ip-address>[,<ip-address>[,<ip-address>...]]
    "conntrack"                 => { "idx" => 92,  "valtype" => "bool",    "section" => "dns",   "page" => "5", "tab" => "1", "arr" => 0, "mult" => "", "default" => 0 },
    "dhcp-range"                => { "idx" => 93,  "valtype" => "var",     "section" => "dhcp",  "page" => "5", "tab" => "1", "arr" => 1, "mult" => "" }, # =[tag:<tag>[,tag:<tag>],][set:<tag>,]<start-addr>[,<end-addr>|<mode>][,<netmask>[,<broadcast>]][,<lease time>] -OR- =[tag:<tag>[,tag:<tag>],][set:<tag>,]<start-IPv6addr>[,<end-IPv6addr>|constructor:<interface>][,<mode>][,<prefix-len>][,<lease time>]
    "dhcp-host"                 => { "idx" => 94,  "valtype" => "var",     "section" => "dhcp",  "page" => "6", "tab" => "1", "arr" => 1, "mult" => "" }, # TODO edit # =[<hwaddr>][,id:<client_id>|*][,set:<tag>][tag:<tag>][,<ipaddr>][,<hostname>][,<lease_time>][,ignore]
    "dhcp-hostsfile"            => { "idx" => 95,  "valtype" => "path",    "section" => "dhcp",  "page" => "1", "tab" => "1", "arr" => 0, "mult" => "" }, # =<path>
    "dhcp-optsfile"             => { "idx" => 96,  "valtype" => "path",    "section" => "dhcp",  "page" => "1", "tab" => "1", "arr" => 0, "mult" => "" }, # =<path>
    "dhcp-hostsdir"             => { "idx" => 97,  "valtype" => "dir",     "section" => "dhcp",  "page" => "1", "tab" => "1", "arr" => 0, "mult" => "" }, # =<path>
    "dhcp-optsdir"              => { "idx" => 98,  "valtype" => "dir",     "section" => "dhcp",  "page" => "1", "tab" => "1", "arr" => 0, "mult" => "" }, # =<path>
    "read-ethers"               => { "idx" => 99,  "valtype" => "bool",    "section" => "dhcp",  "page" => "1", "tab" => "1", "arr" => 0, "mult" => "", "default" => 0 },
    "dhcp-option"               => { "idx" => 100, "valtype" => "var",     "section" => "dhcp",  "page" => "3", "tab" => "1", "arr" => 1, "mult" => "" }, # =[tag:<tag>,[tag:<tag>,]][encap:<opt>,][vi-encap:<enterprise>,][vendor:[<vendor-class>],][<opt>|option:<opt-name>|option6:<opt>|option6:<opt-name>],[<value>[,<value>]]
    "dhcp-option-force"         => { "idx" => 101, "valtype" => "var",     "section" => "dhcp",  "page" => "3", "tab" => "1", "arr" => 1, "mult" => "" }, # =[tag:<tag>,[tag:<tag>,]][encap:<opt>,][vi-encap:<enterprise>,][vendor:[<vendor-class>],][<opt>|option:<opt-name>|option6:<opt>|option6:<opt-name>],[<value>[,<value>]]
    "dhcp-no-override"          => { "idx" => 102, "valtype" => "bool",    "section" => "dhcp",  "page" => "1", "tab" => "1", "arr" => 0, "mult" => "", "default" => 0 },
    "dhcp-relay"                => { "idx" => 103, "valtype" => "var",     "section" => "dhcp",  "page" => "1", "tab" => "2", "arr" => 0, "mult" => "" }, # =<local address>,<server address>[,<interface]
    "dhcp-vendorclass"          => { "idx" => 104, "valtype" => "var",     "section" => "dhcp",  "page" => "4", "tab" => "3", "arr" => 1, "mult" => "" }, # =set:<tag>,[enterprise:<IANA-enterprise number>,]<vendor-class>
    "dhcp-userclass"            => { "idx" => 105, "valtype" => "var",     "section" => "dhcp",  "page" => "4", "tab" => "2", "arr" => 1, "mult" => "" }, # =set:<tag>,<user-class>
    "dhcp-mac"                  => { "idx" => 106, "valtype" => "var",     "section" => "dhcp",  "page" => "4", "tab" => "1", "arr" => 0, "mult" => "" }, # =set:<tag>,<MAC address>
    "dhcp-circuitid"            => { "idx" => 107, "valtype" => "var",     "section" => "dhcp",  "page" => "4", "tab" => "1", "arr" => 0, "mult" => "" }, # =set:<tag>,<circuit-id>
    "dhcp-remoteid"             => { "idx" => 108, "valtype" => "var",     "section" => "dhcp",  "page" => "4", "tab" => "1", "arr" => 0, "mult" => "" }, # =set:<tag>,<remote-id>
    "dhcp-subscrid"             => { "idx" => 109, "valtype" => "var",     "section" => "dhcp",  "page" => "4", "tab" => "1", "arr" => 0, "mult" => "" }, # =set:<tag>,<subscriber-id>
    "dhcp-proxy"                => { "idx" => 110, "valtype" => "ip",      "section" => "dhcp",  "page" => "4", "tab" => "1", "arr" => 0, "mult" => ",", "val_optional" => 1 }, # [=<ip addr>]......
    "dhcp-match"                => { "idx" => 111, "valtype" => "var",     "section" => "dhcp",  "page" => "4", "tab" => "1", "arr" => 0, "mult" => "" }, # =set:<tag>,<option number>|option:<option name>|vi-encap:<enterprise>[,<value>]
    "dhcp-name-match"           => { "idx" => 112, "valtype" => "var",     "section" => "dhcp",  "page" => "4", "tab" => "1", "arr" => 0, "mult" => "" }, # =set:<tag>,<name>[*]
    "tag-if"                    => { "idx" => 113, "valtype" => "var",     "section" => "dhcp",  "page" => "4", "tab" => "1", "arr" => 0, "mult" => "" }, # =set:<tag>[,set:<tag>[,tag:<tag>[,tag:<tag>]]]
    "dhcp-ignore"               => { "idx" => 114, "valtype" => "var",     "section" => "dhcp",  "page" => "4", "tab" => "1", "arr" => 0, "mult" => "" }, # =tag:<tag>[,tag:<tag>]
    "dhcp-ignore-names"         => { "idx" => 115, "valtype" => "var",     "section" => "dhcp",  "page" => "4", "tab" => "1", "arr" => 0, "mult" => "", "val_optional" => 1 }, # [=tag:<tag>[,tag:<tag>]]
    "dhcp-generate-names"       => { "idx" => 116, "valtype" => "var",     "section" => "dhcp",  "page" => "4", "tab" => "1", "arr" => 0, "mult" => "" }, # =tag:<tag>[,tag:<tag>]
    "dhcp-broadcast"            => { "idx" => 117, "valtype" => "var",     "section" => "dhcp",  "page" => "4", "tab" => "1", "arr" => 0, "mult" => "", "val_optional" => 1 }, # [=tag:<tag>[,tag:<tag>]]
    "dhcp-boot"                 => { "idx" => 118, "valtype" => "var",     "section" => "t_b_p", "page" => "2", "tab" => "1", "arr" => 0, "mult" => "" }, # =[tag:<tag>,]<filename>,[<servername>[,<server address>|<tftp_servername>]]
    "dhcp-sequential-ip"        => { "idx" => 119, "valtype" => "bool",    "section" => "dhcp",  "page" => "1", "tab" => "1", "arr" => 0, "mult" => "", "default" => 0 },
    "dhcp-ignore-clid"          => { "idx" => 120, "valtype" => "bool",    "section" => "dhcp",  "page" => "1", "tab" => "1", "arr" => 0, "mult" => "", "default" => 0 },
    "pxe-service"               => { "idx" => 121, "valtype" => "var",     "section" => "t_b_p", "page" => "2", "tab" => "1", "arr" => 0, "mult" => "" }, # =[tag:<tag>,]<CSA>,<menu text>[,<basename>|<bootservicetype>][,<server address>|<server_name>]
    "pxe-prompt"                => { "idx" => 122, "valtype" => "var",     "section" => "t_b_p", "page" => "2", "tab" => "1", "arr" => 0, "mult" => "" }, # =[tag:<tag>,]<prompt>[,<timeout>]
    "dhcp-pxe-vendor"           => { "idx" => 123, "valtype" => "string",  "section" => "t_b_p", "page" => "2", "tab" => "1", "arr" => 0, "mult" => "" }, # =<vendor>[,...]
    "dhcp-lease-max"            => { "idx" => 124, "valtype" => "int",     "section" => "dhcp",  "page" => "1", "tab" => "1", "arr" => 0, "mult" => "", "default" => 1000 }, # =<number>
    "dhcp-authoritative"        => { "idx" => 125, "valtype" => "bool",    "section" => "dhcp",  "page" => "1", "tab" => "1", "arr" => 0, "mult" => "", "default" => 0 },
    "dhcp-rapid-commit"         => { "idx" => 126, "valtype" => "bool",    "section" => "dhcp",  "page" => "1", "tab" => "1", "arr" => 0, "mult" => "", "default" => 0 },
    "dhcp-alternate-port"       => { "idx" => 127, "valtype" => "var",     "section" => "dhcp",  "page" => "1", "tab" => "2", "arr" => 0, "mult" => "", "val_optional" => 1 }, # [=<server port>[,<client port>]]
    "bootp-dynamic"             => { "idx" => 128, "valtype" => "string",  "section" => "t_b_p", "page" => "2", "tab" => "1", "arr" => 1, "mult" => "", "val_optional" => 1 }, # [=<network-id>[,<network-id>]]
    "no-ping"                   => { "idx" => 129, "valtype" => "bool",    "section" => "dhcp",  "page" => "1", "tab" => "1", "arr" => 0, "mult" => "", "default" => 0 },
    "log-dhcp"                  => { "idx" => 130, "valtype" => "bool",    "section" => "dhcp",  "page" => "1", "tab" => "1", "arr" => 0, "mult" => "", "default" => 0 },
    "quiet-dhcp"                => { "idx" => 131, "valtype" => "bool",    "section" => "dhcp",  "page" => "1", "tab" => "1", "arr" => 0, "mult" => "", "default" => 0 },
    "quiet-dhcp6"               => { "idx" => 132, "valtype" => "bool",    "section" => "dhcp",  "page" => "1", "tab" => "1", "arr" => 0, "mult" => "", "default" => 0 },
    "quiet-ra"                  => { "idx" => 133, "valtype" => "bool",    "section" => "dhcp",  "page" => "1", "tab" => "1", "arr" => 0, "mult" => "", "default" => 0 },
    "dhcp-leasefile"            => { "idx" => 134, "valtype" => "file",    "section" => "dhcp",  "page" => "1", "tab" => "1", "arr" => 0, "mult" => "" }, # =<path>
    "dhcp-duid"                 => { "idx" => 135, "valtype" => "var",     "section" => "dhcp",  "page" => "1", "tab" => "2", "arr" => 0, "mult" => "" }, # =<enterprise-id>,<uid>
    "dhcp-script"               => { "idx" => 136, "valtype" => "file",    "section" => "dhcp",  "page" => "1", "tab" => "1", "arr" => 0, "mult" => "" }, # =<path>
    "dhcp-luascript"            => { "idx" => 137, "valtype" => "file",    "section" => "dhcp",  "page" => "1", "tab" => "1", "arr" => 0, "mult" => "" }, # =<path>
    "dhcp-scriptuser"           => { "idx" => 138, "valtype" => "string",  "section" => "dhcp",  "page" => "1", "tab" => "1", "arr" => 0, "mult" => "", "default" => "root" }, # =<username>
    "script-arp"                => { "idx" => 139, "valtype" => "bool",    "section" => "dhcp",  "page" => "1", "tab" => "1", "arr" => 0, "mult" => "", "default" => 0 },
    "leasefile-ro"              => { "idx" => 140, "valtype" => "bool",    "section" => "dhcp",  "page" => "1", "tab" => "1", "arr" => 0, "mult" => "", "default" => 0 },
    "script-on-renewal"         => { "idx" => 141, "valtype" => "bool",    "section" => "dhcp",  "page" => "1", "tab" => "1", "arr" => 0, "mult" => "", "default" => 0 },
    "bridge-interface"          => { "idx" => 142, "valtype" => "var",     "section" => "dhcp",  "page" => "1", "tab" => "3", "arr" => 1, "mult" => "" }, # TODO edit # =<interface>,<alias>[,<alias>]
    "shared-network"            => { "idx" => 143, "valtype" => "var",     "section" => "dhcp",  "page" => "1", "tab" => "2", "arr" => 0, "mult" => "" }, # =<interface|addr>,<addr>
    "domain"                    => { "idx" => 144, "valtype" => "var",     "section" => "dhcp",  "page" => "2", "tab" => "1", "arr" => 1, "mult" => "" }, # =<domain>[,<address range>[,local]]
    "dhcp-fqdn"                 => { "idx" => 145, "valtype" => "bool",    "section" => "dhcp",  "page" => "1", "tab" => "1", "arr" => 0, "mult" => "", "default" => 0 },
    "dhcp-client-update"        => { "idx" => 146, "valtype" => "bool",    "section" => "dhcp",  "page" => "1", "tab" => "1", "arr" => 0, "mult" => "", "default" => 0 },
    "enable-ra"                 => { "idx" => 147, "valtype" => "bool",    "section" => "dhcp",  "page" => "1", "tab" => "1", "arr" => 0, "mult" => "", "default" => 0 },
    "ra-param"                  => { "idx" => 148, "valtype" => "var",     "section" => "dhcp",  "page" => "1", "tab" => "2", "arr" => 0, "mult" => "" }, # =<interface>,[mtu:<integer>|<interface>|off,][high,|low,]<ra-interval>[,<router lifetime>]
    "dhcp-reply-delay"          => { "idx" => 149, "valtype" => "var",     "section" => "dhcp",  "page" => "1", "tab" => "2", "arr" => 0, "mult" => "" }, # =[tag:<tag>,]<integer>
    "enable-tftp"               => { "idx" => 150, "valtype" => "string",  "section" => "t_b_p", "page" => "1", "tab" => "1", "arr" => 0, "mult" => "", "val_optional" => 1 }, # [=<interface>[,<interface>]]
    "tftp-root"                 => { "idx" => 151, "valtype" => "var",     "section" => "t_b_p", "page" => "1", "tab" => "1", "arr" => 0, "mult" => "" }, # =<directory>[,<interface>]
    "tftp-no-fail"              => { "idx" => 152, "valtype" => "bool",    "section" => "t_b_p", "page" => "1", "tab" => "1", "arr" => 0, "mult" => "", "default" => 0 },
    "tftp-unique-root"          => { "idx" => 153, "valtype" => "string",  "section" => "t_b_p", "page" => "1", "tab" => "1", "arr" => 0, "mult" => "", "val_optional" => 1 }, # [=ip|mac]
    "tftp-secure"               => { "idx" => 154, "valtype" => "bool",    "section" => "t_b_p", "page" => "1", "tab" => "1", "arr" => 0, "mult" => "", "default" => 0 },
    "tftp-lowercase"            => { "idx" => 155, "valtype" => "bool",    "section" => "t_b_p", "page" => "1", "tab" => "1", "arr" => 0, "mult" => "", "default" => 0 },
    "tftp-max"                  => { "idx" => 156, "valtype" => "int",     "section" => "t_b_p", "page" => "1", "tab" => "1", "arr" => 0, "mult" => "" }, # =<connections>
    "tftp-mtu"                  => { "idx" => 157, "valtype" => "int",     "section" => "t_b_p", "page" => "1", "tab" => "1", "arr" => 0, "mult" => "" }, # =<mtu size>
    "tftp-no-blocksize"         => { "idx" => 158, "valtype" => "bool",    "section" => "t_b_p", "page" => "1", "tab" => "1", "arr" => 0, "mult" => "", "default" => 0 },
    "tftp-port-range"           => { "idx" => 159, "valtype" => "var",     "section" => "t_b_p", "page" => "1", "tab" => "1", "arr" => 0, "mult" => "" }, # =<start>,<end>
    "tftp-single-port"          => { "idx" => 160, "valtype" => "bool",    "section" => "t_b_p", "page" => "1", "tab" => "1", "arr" => 0, "mult" => "", "default" => 0 },
    "conf-file"                 => { "idx" => 161, "valtype" => "var",     "section" => "dns",   "page" => "6", "tab" => "1", "arr" => 1, "mult" => "" }, # =<file>
    "conf-dir"                  => { "idx" => 162, "valtype" => "var",     "section" => "dns",   "page" => "6", "tab" => "3", "arr" => 1, "mult" => "" }, # =<directory>[,<file-extension>......],
    "servers-file"              => { "idx" => 163, "valtype" => "var",     "section" => "dns",   "page" => "6", "tab" => "2", "arr" => 1, "mult" => "" }, # =<file>
);

our %dnsmnav = (
    "dns" => {
        "1" => {
            "cgi_name" => "dns_basic.cgi",
            "tab" => {
                "1" => "basic",
                "2" => "addn_hosts",
                "3" => "hostsdir",
                "4" => "resolv_file"
            }
        },
        "2" => {
            "cgi_name" => "dns_servers.cgi",
            "tab" => {
                "1" => "basic",
                "2" => "server",
                "3" => "rev_server",
            }
        },
        "3" => {
            "cgi_name" => "dns_iface.cgi",
            "tab" => {
                "1" => "basic",
                "2" => "interface",
                "3" => "except_interface",
                "4" => "no_dhcp_interface",
                "5" => "listen_address",
            }
        },
        "4" => {
            "cgi_name" => "dns_alias.cgi",
            "tab" => {
                "1" => "basic",
                "2" => "other",
                "3" => "alias",
                "4" => "bogus_nxdomain",
                "5" => "address",
                "6" => "ignore_address",
            }
        },
        "5" => {
            "cgi_name" => "dns_records.cgi",
            "tab" => {
                "1" => "basic",
                "2" => "recs",
                "3" => "ipset",
                "4" => "connmark_allowlist",
            }
        },
        "6" => {
            "cgi_name" => "dns_sec.cgi",
        },
        "7" => {
            "cgi_name" => "dns_auth.cgi",
        },
        "8" => {
            "cgi_name" => "dns_addn_config.cgi",
            "tab" => {
                "1" => "conf_file",
                "2" => "servers_file",
                "3" => "conf_dir",
            }
        },
        # below entries are never used, but are included for completeness
        "9" => {
            "cgi_name" => "manual_edit.cgi",
            "cgi_params" => "type=config",
        },
        "10" => {
            "cgi_name" => "manual_edit.cgi",
            "cgi_params" => "type=script",
        },
        "11" => {
            "cgi_name" => "dnsmasq_control.cgi",
        },
        "12" => {
            "cgi_name" => "view_log.cgi",
        },
    },
    "dhcp" => {
        "1" => {
            "cgi_name" => "dhcp_basic.cgi",
            "tab" => {
                "1" => "basic",
                "2" => "other",
                "3" => "bridge_interface",
            }
        },
        "2" => {
            "cgi_name" => "dhcp_domain_name.cgi",
        },
        "3" => {
            "cgi_name" => "dhcp_client_options.cgi",
        },
        "4" => {
            "cgi_name" => "dhcp_tags.cgi",
            "tab" => {
                "1" => "basic_match",
                "2" => "userclass",
                "3" => "vendorclass",
            }
        },
        "5" => {
            "cgi_name" => "dhcp_range.cgi",
            "tab" => {
                "1" => "ip4",
                "2" => "ip6",
            }
        },
        "6" => {
            "cgi_name" => "dhcp_reservations.cgi",
        },
    },
    "t_b_p" => {
        "1" => {
            "cgi_name" => "tftp_basic.cgi",
        },
        "2" => {
            "cgi_name" => "tftp_bootp.cgi",
        },
    },
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
        "addn_hosts" => {  # =<file>
            "param_order" => [ "val" ],
            "val" => {
                "length" => 15,
                "valtype" => "path",
                "req_perms" => "read",
                "must_exist" => 1,
                "default" => "",
                "required" => 1,
                "template" => "<" . $text{"tmpl_path_to_file_or_directory"} . ">"
            }
        },
        "hostsdir" => {  # =<path>
            "param_order" => [ "val" ],
            "val" => {
                "length" => 15,
                "valtype" => "path",
                "must_exist" => 1,
                "req_perms" => "read",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_filename"},
                "template" => "<" . $text{"tmpl_path_to_directory"} . ">"
            }
        },
        "expand_hosts" => { 
            "param_order" => [ "val" ],
            "val" => {
                "valtype" => "bool",
                "default" => 0
            }
        },
        "local_ttl" => {  # =<time>
            "param_order" => [ "val" ],
            "val" => {
                "length" => 3,
                "valtype" => "int",
                "default" => 0,
                # "required" => 1,
                "label" => $text{"p_label_val_ttl"},
                "template" => "<" . $text{"tmpl_TTL"} . ">",
                "pattern" => "\\d{1,5}",
                "min" => 0,
            }
        },
        "dhcp_ttl" => {  # =<time>
            "param_order" => [ "val" ],
            "val" => {
                "length" => 3,
                "valtype" => "int",
                "default" => 0,
                # "required" => 1,
                "label" => $text{"p_label_val_ttl"},
                "template" => "<" . $text{"tmpl_TTL"} . ">",
                "pattern" => "\\d{1,5}",
                "min" => 0,
            }
        },
        "neg_ttl" => {  # =<time>
            "param_order" => [ "val" ],
            "val" => {
                "length" => 3,
                "valtype" => "int",
                "default" => 0,
                # "required" => 1,
                "label" => $text{"p_label_val_ttl"},
                "template" => "<" . $text{"tmpl_TTL"} . ">",
                "pattern" => "\\d{1,5}",
                "min" => 0,
            }
        },
        "max_ttl" => {  # =<time>
            "param_order" => [ "val" ],
            "val" => {
                "length" => 3,
                "valtype" => "int",
                "default" => 0,
                # "required" => 1,
                "label" => $text{"p_label_val_ttl"},
                "template" => "<" . $text{"tmpl_TTL"} . ">",
                "pattern" => "\\d{1,5}",
                "min" => 0,
            }
        },
        "max_cache_ttl" => {  # =<time>
            "param_order" => [ "val" ],
            "val" => {
                "length" => 3,
                "valtype" => "int",
                "default" => 0,
                # "required" => 1,
                "label" => $text{"p_label_val_ttl"},
                "template" => "<" . $text{"tmpl_TTL"} . ">",
                "pattern" => "\\d{1,5}",
                "min" => 0,
            }
        },
        "min_cache_ttl" => {  # =<time>
            "param_order" => [ "val" ],
            "val" => {
                "length" => 3,
                "valtype" => "int",
                "default" => 0,
                # "required" => 1,
                "label" => $text{"p_label_val_ttl"},
                "template" => "<" . $text{"tmpl_TTL"} . ">",
                "pattern" => "\\d{1,4}",
                "min" => 0,
                "max" => 3600
            }
        },
        "auth_ttl" => {  # =<time>
            "param_order" => [ "val" ],
            "val" => {
                "length" => 3,
                "valtype" => "int",
                "default" => 0,
                # "required" => 1,
                "label" => $text{"p_label_val_ttl"},
                "template" => "<" . $text{"tmpl_TTL"} . ">",
                "pattern" => "\\d{1,5}",
                "min" => 0,
            }
        },
        "log_queries" => {  # [=extra]
            "param_order" => [ "val" ],
            "val" => {
                "length" => 3,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "template" => "extra", # literal value
                "pattern" => "extra" # literal value
            }
        },
        "log_facility" => {  # =<facility>
            "param_order" => [ "val" ],
            "val" => {
                "length" => 15,
                "valtype" => "string",
                "default" => "",
                # "required" => 1,
                "template" => "<" . $text{"tmpl_log_facility"} . ">",
                "can_be" => "file",
                "req_perms" => "read,write"
            }
        },
        "log_debug" => {
            "param_order" => [ "val" ],
            "val" => {
                "valtype" => "bool",
                "default" => 0
            }
        },
        "log_async" => { # [=<lines>] 
            "param_order" => [ "val" ],
            "val" => {
                "length" => 3,
                "valtype" => "int",
                "default" => 5,
                "required" => 0,
                "label" => $text{"p_label_val_lines"},
                "template" => "<" . $text{"tmpl_log_async"} . ">",
                "pattern" => "\\d{1,10}",
            }
        },
        "pid_file" => { # =<path>
            "param_order" => [ "val" ],
            "val" => {
                "length" => 15,
                "valtype" => "file",
                "req_perms" => "read,write",
                "default" => "",
                # "required" => 1,
                "label" => $text{"p_label_val_filename"},
                "template" => "<" . $text{"tmpl_path_to_file"} . ">"
            }
        },
        "user" => {  # =<username>
            "param_order" => [ "val" ],
            "val" => {
                "length" => 10,
                "valtype" => "user",
                "default" => "nobody",
                "required" => 1,
                "label" => $text{"p_label_val_username"},
                "template" => "<" . $text{"tmpl_username"} . ">"
            }
        },
        "group" => {  # =<groupname>
            "param_order" => [ "val" ],
            "val" => {
                "length" => 10,
                "valtype" => "group",
                "default" => "dip",
                "required" => 1,
                "label" => $text{"p_label_val_groupname"},
                "template" => "<" . $text{"tmpl_groupname"} . ">"
            }
        },
        "port" => {  # =<port>
            "param_order" => [ "val" ],
            "val" => {
                "length" => 3,
                "valtype" => "int",
                "default" => 0,
                "required" => 1,
                "label" => $text{"p_label_val_port"},
                "template" => "<" . $text{"tmpl_port"} . ">",
                "pattern" => "\\d{1,5}",
                "min" => 0,
                "max" => 65535,
                "warn_if" => 0,
            }
        },
        "edns_packet_max" => {  # =<size>
            "param_order" => [ "val" ],
            "val" => {
                "length" => 3,
                "valtype" => "int",
                "default" => 1232,
                "required" => 1,
                "label" => $text{"p_label_val_size"},
                "template" => "<" . $text{"tmpl_size"} . ">",
                "pattern" => "\\d{1,5}",
                "min" => 0,
            }
        },
        "query_port" => {  # =<query_port>
            "param_order" => [ "val" ],
            "val" => {
                "length" => 3,
                "valtype" => "int",
                "default" => 0,
                "required" => 1,
                "label" => $text{"p_label_val_port"},
                "template" => "<" . $text{"tmpl_port"} . ">",
                "pattern" => "\\d{1,5}",
                "min" => 0,
                "max" => 65535
            }
        },
        "min_port" => {  # =<port>
            "param_order" => [ "val" ],
            "val" => {
                "length" => 3,
                "valtype" => "int",
                "default" => 1024,
                "required" => 1,
                "label" => $text{"p_label_val_port"},
                "template" => "<" . $text{"tmpl_port"} . ">",
                "pattern" => "\\d{1,5}",
                "min" => 0,
                "max" => 65535
            }
        },
        "max_port" => {  # =<port>
            "param_order" => [ "val" ],
            "val" => {
                "length" => 3,
                "valtype" => "int",
                "default" => 0,
                "required" => 1,
                "label" => $text{"p_label_val_port"},
                "template" => "<" . $text{"tmpl_port"} . ">",
                "pattern" => "\\d{1,5}",
                "min" => 0,
                "max" => 65535
            }
        },
        "interface" => {  # =<interface name>
            "param_order" => [ "val" ],
            "val" => {
                "length" => 10,
                "valtype" => "interface",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_interface"},
                "template" => "<" . $text{"tmpl_interface"} . ">"
            }
        },
        "except_interface" => {  # =<interface name>
            "param_order" => [ "val" ],
            "val" => {
                "length" => 10,
                "valtype" => "interface",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_interface"},
                "template" => "<" . $text{"tmpl_interface"} . ">"
            }
        },
        "auth_server" => { # =<domain>,[<interface>|<ip-address>...]
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
        },
        "local_service" => { 
            "param_order" => [ "val" ],
            "val" => {
                "valtype" => "bool",
                "default" => 0,
            }
        },
        "no_dhcp_interface" => {  # =<interface name>
            "param_order" => [ "val" ],
            "val" => {
                "length" => 10,
                "valtype" => "interface",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_interface"},
                "template" => "<" . $text{"tmpl_interface"} . ">"
            }
        },
        "listen_address" => {  # =<ipaddr>
            "param_order" => [ "val" ],
            "val" => {
                "length" => 10,
                "valtype" => "ip",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_ip_address"},
                "template" => $text{"tmpl_ip"}
            }
        },
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
        "alias" => {  # =[<old-ip>]|[<start-ip>-<end-ip>],<new-ip>[,<mask>]
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
        },
        "bogus_nxdomain" => {  # =<ipaddr>[/prefix]
            "param_order" => [ "addr" ],
            "addr" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_ip_address"},
                "template" => $text{"tmpl_ip"} . "[/" . $text{"tmpl_prefix"} . "]"
            }
        },
        "ignore_address" => {  # =<ipaddr>[/prefix]
            "param_order" => [ "ip" ],
            "ip" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_ip_address"},
                "template" => $text{"tmpl_ip"} . "[/" . $text{"tmpl_prefix"} . "]"
            }
        },
        "filterwin2k" => { 
            "param_order" => [ "val" ],
            "val" => {
                "valtype" => "bool",
                "default" => 0,
            }
        },
        "resolv_file" => {  # =<file>
            "param_order" => [ "val" ],
            "val" => {
                "length" => 15,
                "valtype" => "file",
                "must_exist" => 1,
                "req_perms" => "read",
                "default" => "",
                "required" => 1,
                "template" => "<" . $text{"tmpl_path_to_file"} . ">"
            }
        },
        "no_resolv" => { 
            "param_order" => [ "val" ],
            "val" => {
                "valtype" => "bool",
                "default" => 0
            },
        },
        "enable_dbus" => {  # [=<service-name>]
            "param_order" => [ "val" ],
            "val" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_service_name"},
                "template" => "<" . $text{"tmpl_service_name"} . ">"
            },
        },
        "enable_ubus" => {  # [=<service-name>]
            "param_order" => [ "val" ],
            "val" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_service_name"},
                "template" => "<" . $text{"tmpl_service_name"} . ">"
            },
        },
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
        "rebind_domain_ok" => {  # =[<domain>]|[[/<domain>/[<domain>/]
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
        },
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
        "local" => {  # =[/[<domain>]/[domain/]][<ipaddr>[#<port>]][@<interface>][@<source-ip>[#<port>]]
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
        },
        "server" => {  # =[/[<domain>]/[domain/]][<ipaddr>[#<port>]][@<interface>][@<source-ip>[#<port>]]
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
        },
        "rev_server" => { # =<ip-address>/<prefix-len>[,<ipaddr>][#<port>][@<interface>][@<source-ip>[#<port>]]
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
        },
        "address" => {  # =/<domain>[/<domain>...]/[<ipaddr>]
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
        },
        "ipset" => {  # =/<domain>[/<domain>...]/<ipset>[,<ipset>...]
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
        },
        "connmark_allowlist_enable" => {  # [=<mask>]
            "param_order" => [ "val" ],
            "val" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_mask"},
                "template" => "<" . $text{"tmpl_mask"} . ">"
            }
        },
        "connmark_allowlist" => {  # =<connmark>[/<mask>][,<pattern>[/<pattern>...]]
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
        },
        "mx_host" => {  # =<mx name>[[,<hostname>],<preference>]
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
                "required" => 0,
                "label" => $text{"p_label_val_hostname"},
                "template" => "<" . $text{"tmpl_hostname"} . ">"
            },
            "preference" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "1",
                "required" => 0,
                "label" => $text{"p_label_val_preference"},
                "template" => "<" . $text{"tmpl_preference"} . ">"
            },
        },
        "mx_target" => {  # =<hostname>
            "param_order" => [ "val" ],
            "val" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_target"},
                "template" => "<" . $text{"tmpl_hostname"} . ">"
            }
        },
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
        "srv_host" => {  # =<_service>.<_prot>.[<domain>],[<target>[,<port>[,<priority>[,<weight>]]]]
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
                "template" => "<" . $text{"tmpl_port"} . ">",
                "pattern" => "\\d{1,5}",
                "min" => 0,
                "max" => 65535
            },
            "priority" => {
                "length" => 3,
                "valtype" => "int",
                "default" => 0,
                "required" => 0,
                "label" => $text{"p_label_val_priority"},
                "template" => "<" . $text{"tmpl_srv_host_priority"} . ">",
                "pattern" => "\\d{1,5}",
                "min" => 0,
                "max" => 65535
            },
            "weight" => {
                "length" => 3,
                "valtype" => "int",
                "default" => 0,
                "required" => 0,
                "label" => $text{"p_label_val_weight"},
                "template" => "<" . $text{"tmpl_weight"} . ">",
                "pattern" => "\\d{1,5}",
                "min" => 0,
                "max" => 65535
            },
        },
        "host_record" => {  # =<name>[,<name>....],[<IPv4-address>],[<IPv6-address>][,<TTL>]
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
                "template" => "<" . $text{"tmpl_TTL"} . ">",,
                "pattern" => "\\d{1,5}"
            },
        },
        "dynamic_host" => {  # =<name>,[IPv4-address],[IPv6-address],<interface>
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
        },
        "txt_record" => {  # =<name>[[,<text>],<text>]
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
        },
        "ptr_record" => {  # =<name>[,<target>]
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
        },
        "naptr_record" => {  # =<name>,<order>,<preference>,<flags>,<service>,<regexp>[,<replacement>]
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
                "template" => "<" . $text{"tmpl_order"} . ">",,
                "pattern" => "\\d{1,5}",
                "min" => 0,
                "max" => 65535
            },
            "preference" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_preference"},
                "template" => "<" . $text{"tmpl_preference"} . ">",,
                "pattern" => "\\d{1,5}",
                "min" => 0,
                "max" => 65535
            },
            "flags" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_flags"},
                "template" => "<" . $text{"tmpl_flags"} . ">",
                "pattern" => "[a-zA-Z0-9]*",
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
        },
        "caa_record" => {  # =<name>,<flags>,<tag>,<value>
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
                "template" => "<" . $text{"tmpl_caa_flags"} . ">",
                "pattern" => "\\d{1,3}",
                "min" => 0,
                "max" => 255,
            },
            "tag" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_tag"},
                "template" => "<" . $text{"tmpl_caa_tag"} . ">",
                "pattern" => "[a-zA-Z0-9]*"
            },
            "value" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_value"},
                "template" => "<" . $text{"tmpl_value"} . ">"
            },
        },
        "cname" => {  # =<cname>,[<cname>,]<target>[,<TTL>]
            "param_order" => [ "cname", "target", "ttl" ],
            "cname" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_cnames"},
                "template" => "<" . $text{"tmpl_cname"} . ">[,<" . $text{"tmpl_cname"} . ">]",
                "arr" => 1,
                "sep" => ","
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
                "template" => "<" . $text{"tmpl_TTL"} . ">",
                "pattern" => "\\d{1,5}"
            },
        },
        "dns_rr" => {  # =<name>,<RR-number>,[<hex data>]
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
                "valtype" => "int",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_rrnumber"},
                "template" => "<" . $text{"tmpl_rrnumber"} . ">",
                "pattern" => "\\d{1,5}",
                "min" => 0,
                "max" => 65535,
            },
            "hexdata" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_hexdata"},
                "template" => "<" . $text{"tmpl_hexdata"} . ">",
                "pattern" => "[a-fA-F0-9\ :]*"
            },
        },
        "interface_name" => {  # =<name>,<interface>[/4|/6]
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
        },
        "synth_domain" => {  # =<domain>,<address range>[,<prefix>[*]]
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
        },
        "dumpfile" => {  # =<path/to/file>
            "param_order" => [ "val" ],
            "val" => {
                "length" => 15,
                "valtype" => "file",
                "req_perms" => "write",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_filename"},
                "template" => "<" . $text{"tmpl_path_to_file"} . ">"
            }
        },
        "dumpmask" => {  # =<mask>
            "param_order" => [ "val" ],
            "val" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_mask"},
                "template" => "<" . $text{"tmpl_mask"} . ">"
            }
        },
        "add_mac" => {  # [=base64|text]
            "param_order" => [ "val" ],
            "val" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "template" => "base64|text", # literal value
                "pattern" => "base64|text" # literal value
            }
        },
        "add_cpe_id" => {  # =<string>
            "param_order" => [ "val" ],
            "val" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "template" => "<" . $text{"tmpl_string"} . ">"
            }
        },
        "add_subnet" => {  # [[=[<IPv4 address>/]<IPv4 prefix length>][,[<IPv6 address>/]<IPv6 prefix length>]]
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
        },
        "umbrella" => {   # [=deviceid:<deviceid>[,orgid:<orgid>]]
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
        },
        "cache_size" => {  # =<cachesize>
            "param_order" => [ "val" ],
            "val" => {
                "length" => 3,
                "valtype" => "int",
                "default" => 0,
                "required" => 1,
                "template" => "<" . $text{"tmpl_integer"} . ">",
                "pattern" => "\\d{1,5}"
            }
        },
        "no_negcache" => { 
            "param_order" => [ "val" ],
            "val" => {
                "valtype" => "bool",
                "default" => 0,
            }
        },
        "dns_forward_max" => {  # =<queries>
            "param_order" => [ "val" ],
            "val" => {
                "length" => 3,
                "valtype" => "int",
                "default" => 150,
                "required" => 1,
                "template" => "<" . $text{"tmpl_integer"} . ">",
                "pattern" => "\\d{1,5}"
            }
        },
        "dnssec" => { 
            "param_order" => [ "val" ],
            "val" => {
                "valtype" => "bool",
                "default" => 0,
            }
        },
        "trust_anchor" => {  # =[<class>],<domain>,<key-tag>,<algorithm>,<digest-type>,<digest>
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
        },
        "dnssec_check_unsigned" => {  # [=no]
            "param_order" => [ "val" ],
            "val" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "no",
                "required" => 0,
                "template" => "[no]", # literal value
                "pattern" => "no" # literal value
            }
        },
        "dnssec_no_timecheck" => { 
            "param_order" => [ "val" ],
            "val" => {
                "valtype" => "bool",
                "default" => 0,
            }
        },
        "dnssec_timestamp" => {  # =<path>
            "param_order" => [ "val" ],
            "val" => {
                "length" => 15,
                "valtype" => "file",
                "req_perms" => "readwrite",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_filename"},
                "template" => "<" . $text{"tmpl_path_to_file"} . ">"
            }
        },
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
        "auth_zone" => {  # =<domain>[,<subnet>[/<prefix length>][,<subnet>[/<prefix length>]|<interface>.....][,exclude:<subnet>[/<prefix length>]|<interface>].....]
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
        },
        "auth_soa" => { # =<serial>[,<hostmaster>[,<refresh>[,<retry>[,<expiry>]]]]
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
                "template" => "<" . $text{"tmpl_integer"} . ">",
                "pattern" => "\\d{1,5}"
            },
            "retry" => {
                "length" => 2,
                "valtype" => "int",
                "default" => 0,
                "required" => 0,
                "label" => $text{"p_label_val_retry"},
                "template" => "<" . $text{"tmpl_integer"} . ">",
                "pattern" => "\\d{1,5}"
            },
            "expiry" => {
                "length" => 2,
                "valtype" => "int",
                "default" => 0,
                "required" => 0,
                "label" => $text{"p_label_val_expiry"},
                "template" => "<" . $text{"tmpl_expiry"} . ">",
                "pattern" => "\\d{1,5}"
            }
        },
        "auth_sec_servers" => {  # =<domain>[,<domain>[,<domain>...]]
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
        },
        "auth_peer" => {  # =<ip-address>[,<ip-address>[,<ip-address>...]]
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
        },
        "conntrack" => { 
            "param_order" => [ "val" ],
            "val" => {
                "valtype" => "bool",
                "default" => 0,
            }
        },
        "dhcp_range" => {  # =[tag:<tag>[,tag:<tag>],][set:<tag>,]<start-addr>[,<end-addr>|<mode>][,<netmask>[,<broadcast>]][,<lease time>] -OR- =[tag:<tag>[,tag:<tag>],][set:<tag>,]<start-IPv6addr>[,<end-IPv6addr>|constructor:<interface>][,<mode>][,<prefix-len>][,<lease time>]
            "param_order" => [ "tag", "settag", "start", "end", "mask", "broadcast", "prefix-length", "leasetime", "static", "proxy", "ra-only", "ra-names", "ra-stateless", "slaac", "ra-advrouter", "off-link" ],
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
                "template" => "<" . $text{"tmpl_prefix_length"} . ">",
                "pattern" => "\\d{1,5}"
            },
            "leasetime" => {
                "length" => 3,
                "valtype" => "time",
                "default" => 0,
                "required" => 0,
                "label" => $text{"p_label_val_leasetime"},
                "template" => "<" . $text{"tmpl_leasetime"} . ">",
                "pattern" => "(\\d{1,5}[mhdw]?|infinite)",
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
                "label" => $text{"p_label_val_proxy"}
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
        },
        "dhcp_host" => {  # =[<hwaddr>][,id:<client_id>|*][,set:<tag>][tag:<tag>][,<ipaddr>][,<hostname>][,<lease_time>][,ignore]
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
                "valtype" => "time",
                "default" => 0,
                "required" => 0,
                "label" => $text{"p_label_val_leasetime"},
                "template" => "<" . $text{"tmpl_leasetime"} . ">",
                "pattern" => "(\\d{1,5}[mhdw]?|infinite)",
            },
            "ignore" => {
                "valtype" => "bool",
                "default" => 0,
                "label" => $text{"p_label_val_ignore"},
            },
        },
        "dhcp_hostsfile" => {  # =<path>
            "param_order" => [ "val" ],
            "val" => {
                "length" => 15,
                "valtype" => "path",
                "must_exist" => 1,
                "req_perms" => "read",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_filename"},
                "template" => "<" . $text{"tmpl_path_to_file"} . ">"
            }
        },
        "dhcp_optsfile" => {  # =<path>
            "param_order" => [ "val" ],
            "val" => {
                "length" => 15,
                "valtype" => "path",
                "must_exist" => 1,
                "req_perms" => "read",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_filename"},
                "template" => "<" . $text{"tmpl_path_to_file"} . ">"
            }
        },
        "dhcp_hostsdir" => {  # =<path>
            "param_order" => [ "val" ],
            "val" => {
                "length" => 15,
                "valtype" => "path",
                "must_exist" => 1,
                "req_perms" => "read",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_dirname"},
                "template" => "<" . $text{"tmpl_path_to_directory"} . ">"
            }
        },
        "dhcp_optsdir" => {  # =<path>
            "param_order" => [ "val" ],
            "val" => {
                "length" => 15,
                "valtype" => "path",
                "must_exist" => 1,
                "req_perms" => "read",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_dirname"},
                "template" => "<" . $text{"tmpl_path_to_directory"} . ">"
            }
        },
        "read_ethers" => { 
            "param_order" => [ "val" ],
            "val" => {
                "valtype" => "bool",
                "default" => 0,
            }
        },
        "dhcp_option" => {  # =[tag:<tag>,[tag:<tag>,]][encap:<opt>,][vi-encap:<enterprise>,][vendor:[<vendor-class>],][<opt>|option:<opt-name>|option6:<opt>|option6:<opt-name>],[<value>[,<value>]]
            "param_order" => [ "option", "value", "tag", "vendor", "encap", "vi-encap", "forced" ],
            "option" => {
                "length" => 15,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_option"},
                "template" => "<" . $text{"tmpl_option"} . ">|option:<" . $text{"tmpl_option_name"} . ">|option6:<" . $text{"tmpl_option"} . ">|option:<" . $text{"tmpl_option_name"} . ">",
                "sel" => [ # https://www.iana.org/assignments/bootp-dhcp-parameters/bootp-dhcp-parameters.xhtml
                    { "name" => "1",   "alt_names" => { "ipv4" => "netmask" },                                                       "desc" => { "ipv4" => $text{"dhcp_opt_desc_1_4"},   "ipv6" => $text{"dhcp_opt_desc_1_6"} }}, 
                    { "name" => "2",   "alt_names" => { "ipv4" => "time-offset" },                                                   "desc" => { "ipv4" => $text{"dhcp_opt_desc_2_4"},   "ipv6" => $text{"dhcp_opt_desc_2_6"} }}, 
                    { "name" => "3",   "alt_names" => { "ipv4" => "router" },                                                        "desc" => { "ipv4" => $text{"dhcp_opt_desc_3_4"},   "ipv6" => $text{"dhcp_opt_desc_3_6"} }}, 
                    { "name" => "4",   "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_4_4"},   "ipv6" => $text{"dhcp_opt_desc_4_6"} }}, 
                    { "name" => "5",   "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_5_4"},   "ipv6" => $text{"dhcp_opt_desc_5_6"} }}, 
                    { "name" => "6",   "alt_names" => { "ipv4" => "dns-server" },                                                    "desc" => { "ipv4" => $text{"dhcp_opt_desc_6_4"},   "ipv6" => $text{"dhcp_opt_desc_6_6"} }}, 
                    { "name" => "7",   "alt_names" => { "ipv4" => "log-server" },                                                    "desc" => { "ipv4" => $text{"dhcp_opt_desc_7_4"},   "ipv6" => $text{"dhcp_opt_desc_7_6"} }}, 
                    { "name" => "8",   "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_8_4"},   "ipv6" => $text{"dhcp_opt_desc_8_6"} }}, 
                    { "name" => "9",   "alt_names" => { "ipv4" => "lpr-server" },                                                    "desc" => { "ipv4" => $text{"dhcp_opt_desc_9_4"},   "ipv6" => $text{"dhcp_opt_desc_9_6"} }}, 
                    { "name" => "10",  "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_10_4"} }}, 
                    { "name" => "11",  "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_11_4"},  "ipv6" => $text{"dhcp_opt_desc_11_6"} }}, 
                    { "name" => "12",  "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_12_4"},  "ipv6" => $text{"dhcp_opt_desc_12_6"} }}, 
                    { "name" => "13",  "alt_names" => { "ipv4" => "boot-file-size" },                                                "desc" => { "ipv4" => $text{"dhcp_opt_desc_13_4"},  "ipv6" => $text{"dhcp_opt_desc_13_6"} }}, 
                    { "name" => "14",  "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_14_4"},  "ipv6" => $text{"dhcp_opt_desc_14_6"} }}, 
                    { "name" => "15",  "alt_names" => { "ipv4" => "domain-name" },                                                   "desc" => { "ipv4" => $text{"dhcp_opt_desc_15_4"},  "ipv6" => $text{"dhcp_opt_desc_15_6"} }}, 
                    { "name" => "16",  "alt_names" => { "ipv4" => "swap-server" },                                                   "desc" => { "ipv4" => $text{"dhcp_opt_desc_16_4"},  "ipv6" => $text{"dhcp_opt_desc_16_6"} }}, 
                    { "name" => "17",  "alt_names" => { "ipv4" => "root-path" },                                                     "desc" => { "ipv4" => $text{"dhcp_opt_desc_17_4"},  "ipv6" => $text{"dhcp_opt_desc_17_6"} }}, 
                    { "name" => "18",  "alt_names" => { "ipv4" => "extension-path" },                                                "desc" => { "ipv4" => $text{"dhcp_opt_desc_18_4"},  "ipv6" => $text{"dhcp_opt_desc_18_6"} }}, 
                    { "name" => "19",  "alt_names" => { "ipv4" => "ip-forward-enable" },                                             "desc" => { "ipv4" => $text{"dhcp_opt_desc_19_4"},  "ipv6" => $text{"dhcp_opt_desc_19_6"} }}, 
                    { "name" => "20",  "alt_names" => { "ipv4" => "non-local-source-routing" },                                      "desc" => { "ipv4" => $text{"dhcp_opt_desc_20_4"},  "ipv6" => $text{"dhcp_opt_desc_20_6"} }}, 
                    { "name" => "21",  "alt_names" => { "ipv4" => "policy-filter",           "ipv6" => "sip-server-domain" },        "desc" => { "ipv4" => $text{"dhcp_opt_desc_21_4"},  "ipv6" => $text{"dhcp_opt_desc_21_6"} }}, 
                    { "name" => "22",  "alt_names" => { "ipv4" => "max-datagram-reassembly", "ipv6" => "sip-server" },               "desc" => { "ipv4" => $text{"dhcp_opt_desc_22_4"},  "ipv6" => $text{"dhcp_opt_desc_22_6"} }}, 
                    { "name" => "23",  "alt_names" => { "ipv4" => "default-ttl",             "ipv6" => "dns-server" },               "desc" => { "ipv4" => $text{"dhcp_opt_desc_23_4"},  "ipv6" => $text{"dhcp_opt_desc_23_6"} }}, 
                    { "name" => "24",  "alt_names" => { "ipv6" => "domain-search" },                                                 "desc" => { "ipv4" => $text{"dhcp_opt_desc_24_4"},  "ipv6" => $text{"dhcp_opt_desc_24_6"} }}, 
                    { "name" => "25",  "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_25_4"},  "ipv6" => $text{"dhcp_opt_desc_25_6"} }}, 
                    { "name" => "26",  "alt_names" => { "ipv4" => "mtu" },                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_26_4"},  "ipv6" => $text{"dhcp_opt_desc_26_6"} }}, 
                    { "name" => "27",  "alt_names" => { "ipv4" => "all-subnets-local",       "ipv6" => "nis-server" },               "desc" => { "ipv4" => $text{"dhcp_opt_desc_27_4"},  "ipv6" => $text{"dhcp_opt_desc_27_6"} }}, 
                    { "name" => "28",  "alt_names" => { "ipv6" => "nis+-server" },                                                   "desc" => { "ipv4" => $text{"dhcp_opt_desc_28_4"},  "ipv6" => $text{"dhcp_opt_desc_28_6"} }}, 
                    { "name" => "29",  "alt_names" => { "ipv6" => "nis-domain" },                                                    "desc" => { "ipv4" => $text{"dhcp_opt_desc_29_4"},  "ipv6" => $text{"dhcp_opt_desc_29_6"} }}, 
                    { "name" => "30",  "alt_names" => { "ipv6" => "nis+-domain" },                                                   "desc" => { "ipv4" => $text{"dhcp_opt_desc_30_4"},  "ipv6" => $text{"dhcp_opt_desc_30_6"} }}, 
                    { "name" => "31",  "alt_names" => { "ipv4" => "router-discovery",        "ipv6" => "sntp-server" },              "desc" => { "ipv4" => $text{"dhcp_opt_desc_31_4"},  "ipv6" => $text{"dhcp_opt_desc_31_6"} }}, 
                    { "name" => "32",  "alt_names" => { "ipv4" => "router-solicitation",     "ipv6" => "information-refresh-time" }, "desc" => { "ipv4" => $text{"dhcp_opt_desc_32_4"},  "ipv6" => $text{"dhcp_opt_desc_32_6"} }}, 
                    { "name" => "33",  "alt_names" => { "ipv4" => "static-route" },                                                  "desc" => { "ipv4" => $text{"dhcp_opt_desc_33_4"},  "ipv6" => $text{"dhcp_opt_desc_33_6"} }}, 
                    { "name" => "34",  "alt_names" => { "ipv4" => "trailer-encapsulation" },                                         "desc" => { "ipv4" => $text{"dhcp_opt_desc_34_4"},  "ipv6" => $text{"dhcp_opt_desc_34_6"} }}, 
                    { "name" => "35",  "alt_names" => { "ipv4" => "arp-timeout" },                                                   "desc" => { "ipv4" => $text{"dhcp_opt_desc_35_4"} }}, 
                    { "name" => "36",  "alt_names" => { "ipv4" => "ethernet-encap" },                                                "desc" => { "ipv4" => $text{"dhcp_opt_desc_36_4"},  "ipv6" => $text{"dhcp_opt_desc_36_6"} }}, 
                    { "name" => "37",  "alt_names" => { "ipv4" => "tcp-ttl" },                                                       "desc" => { "ipv4" => $text{"dhcp_opt_desc_37_4"},  "ipv6" => $text{"dhcp_opt_desc_37_6"} }}, 
                    { "name" => "38",  "alt_names" => { "ipv4" => "tcp-keepalive" },                                                 "desc" => { "ipv4" => $text{"dhcp_opt_desc_38_4"},  "ipv6" => $text{"dhcp_opt_desc_38_6"} }}, 
                    { "name" => "39",  "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_39_4"},  "ipv6" => $text{"dhcp_opt_desc_39_6"} }}, 
                    { "name" => "40",  "alt_names" => { "ipv4" => "nis-domain" },                                                    "desc" => { "ipv4" => $text{"dhcp_opt_desc_40_4"},  "ipv6" => $text{"dhcp_opt_desc_40_6"} }}, 
                    { "name" => "41",  "alt_names" => { "ipv4" => "nis-server" },                                                    "desc" => { "ipv4" => $text{"dhcp_opt_desc_41_4"},  "ipv6" => $text{"dhcp_opt_desc_41_6"} }}, 
                    { "name" => "42",  "alt_names" => { "ipv4" => "ntp-server" },                                                    "desc" => { "ipv4" => $text{"dhcp_opt_desc_42_4"},  "ipv6" => $text{"dhcp_opt_desc_42_6"} }}, 
                    { "name" => "43",  "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_43_4"},  "ipv6" => $text{"dhcp_opt_desc_43_6"} }}, 
                    { "name" => "44",  "alt_names" => { "ipv4" => "netbios-ns" },                                                    "desc" => { "ipv4" => $text{"dhcp_opt_desc_44_4"},  "ipv6" => $text{"dhcp_opt_desc_44_6"} }}, 
                    { "name" => "45",  "alt_names" => { "ipv4" => "netbios-dd" },                                                    "desc" => { "ipv4" => $text{"dhcp_opt_desc_45_4"},  "ipv6" => $text{"dhcp_opt_desc_45_6"} }}, 
                    { "name" => "46",  "alt_names" => { "ipv4" => "netbios-nodetype" },                                              "desc" => { "ipv4" => $text{"dhcp_opt_desc_46_4"},  "ipv6" => $text{"dhcp_opt_desc_46_6"} }}, 
                    { "name" => "47",  "alt_names" => { "ipv4" => "netbios-scope" },                                                 "desc" => { "ipv4" => $text{"dhcp_opt_desc_47_4"},  "ipv6" => $text{"dhcp_opt_desc_47_6"} }}, 
                    { "name" => "48",  "alt_names" => { "ipv4" => "x-windows-fs" },                                                  "desc" => { "ipv4" => $text{"dhcp_opt_desc_48_4"},  "ipv6" => $text{"dhcp_opt_desc_48_6"} }}, 
                    { "name" => "49",  "alt_names" => { "ipv4" => "x-windows-dm" },                                                  "desc" => { "ipv4" => $text{"dhcp_opt_desc_49_4"},  "ipv6" => $text{"dhcp_opt_desc_49_6"} }}, 
                    { "name" => "50",  "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_50_4"},  "ipv6" => $text{"dhcp_opt_desc_50_6"} }}, 
                    { "name" => "51",  "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_51_4"},  "ipv6" => $text{"dhcp_opt_desc_51_6"} }}, 
                    { "name" => "52",  "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_52_4"},  "ipv6" => $text{"dhcp_opt_desc_52_6"} }}, 
                    { "name" => "53",  "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_53_4"},  "ipv6" => $text{"dhcp_opt_desc_53_6"} }}, 
                    { "name" => "54",  "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_54_4"},  "ipv6" => $text{"dhcp_opt_desc_54_6"} }}, 
                    { "name" => "55",  "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_55_4"},  "ipv6" => $text{"dhcp_opt_desc_55_6"} }}, 
                    { "name" => "56",  "alt_names" => { "ipv6" => "ntp-server" },                                                    "desc" => { "ipv4" => $text{"dhcp_opt_desc_56_4"},  "ipv6" => $text{"dhcp_opt_desc_56_6"} }}, 
                    { "name" => "57",  "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_57_4"},  "ipv6" => $text{"dhcp_opt_desc_57_6"} }}, 
                    { "name" => "58",  "alt_names" => { "ipv4" => "T1" },                                                            "desc" => { "ipv4" => $text{"dhcp_opt_desc_58_4"},  "ipv6" => $text{"dhcp_opt_desc_58_6"} }}, 
                    { "name" => "59",  "alt_names" => { "ipv4" => "T2",                      "ipv6" => "bootfile-url" },             "desc" => { "ipv4" => $text{"dhcp_opt_desc_59_4"},  "ipv6" => $text{"dhcp_opt_desc_59_6"} }}, 
                    { "name" => "60",  "alt_names" => { "ipv4" => "vendor-class",            "ipv6" => "bootfile-param" },           "desc" => { "ipv4" => $text{"dhcp_opt_desc_60_4"},  "ipv6" => $text{"dhcp_opt_desc_60_6"} }}, 
                    { "name" => "61",  "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_61_4"},  "ipv6" => $text{"dhcp_opt_desc_61_6"} }}, 
                    { "name" => "62",  "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_62_4"},  "ipv6" => $text{"dhcp_opt_desc_62_6"} }}, 
                    { "name" => "63",  "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_63_4"},  "ipv6" => $text{"dhcp_opt_desc_63_6"} }}, 
                    { "name" => "64",  "alt_names" => { "ipv4" => "nis+-domain" },                                                   "desc" => { "ipv4" => $text{"dhcp_opt_desc_64_4"},  "ipv6" => $text{"dhcp_opt_desc_64_6"} }}, 
                    { "name" => "65",  "alt_names" => { "ipv4" => "nis+-server" },                                                   "desc" => { "ipv4" => $text{"dhcp_opt_desc_65_4"},  "ipv6" => $text{"dhcp_opt_desc_65_6"} }}, 
                    { "name" => "66",  "alt_names" => { "ipv4" => "tftp-server" },                                                   "desc" => { "ipv4" => $text{"dhcp_opt_desc_66_4"},  "ipv6" => $text{"dhcp_opt_desc_66_6"} }}, 
                    { "name" => "67",  "alt_names" => { "ipv4" => "bootfile-name" },                                                 "desc" => { "ipv4" => $text{"dhcp_opt_desc_67_4"},  "ipv6" => $text{"dhcp_opt_desc_67_6"} }}, 
                    { "name" => "68",  "alt_names" => { "ipv4" => "mobile-ip-home" },                                                "desc" => { "ipv4" => $text{"dhcp_opt_desc_68_4"},  "ipv6" => $text{"dhcp_opt_desc_68_6"} }}, 
                    { "name" => "69",  "alt_names" => { "ipv4" => "smtp-server" },                                                   "desc" => { "ipv4" => $text{"dhcp_opt_desc_69_4"},  "ipv6" => $text{"dhcp_opt_desc_69_6"} }}, 
                    { "name" => "70",  "alt_names" => { "ipv4" => "pop3-server" },                                                   "desc" => { "ipv4" => $text{"dhcp_opt_desc_70_4"},  "ipv6" => $text{"dhcp_opt_desc_70_6"} }}, 
                    { "name" => "71",  "alt_names" => { "ipv4" => "nntp-server" },                                                   "desc" => { "ipv4" => $text{"dhcp_opt_desc_71_4"},  "ipv6" => $text{"dhcp_opt_desc_71_6"} }}, 
                    { "name" => "72",  "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_72_4"},  "ipv6" => $text{"dhcp_opt_desc_72_6"} }}, 
                    { "name" => "73",  "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_73_4"},  "ipv6" => $text{"dhcp_opt_desc_73_6"} }}, 
                    { "name" => "74",  "alt_names" => { "ipv4" => "irc-server" },                                                    "desc" => { "ipv4" => $text{"dhcp_opt_desc_74_4"},  "ipv6" => $text{"dhcp_opt_desc_74_6"} }}, 
                    { "name" => "75",  "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_75_4"},  "ipv6" => $text{"dhcp_opt_desc_75_6"} }}, 
                    { "name" => "76",  "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_76_4"},  "ipv6" => $text{"dhcp_opt_desc_76_6"} }}, 
                    { "name" => "77",  "alt_names" => { "ipv4" => "user-class" },                                                    "desc" => { "ipv4" => $text{"dhcp_opt_desc_77_4"},  "ipv6" => $text{"dhcp_opt_desc_77_6"} }}, 
                    { "name" => "78",  "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_78_4"},  "ipv6" => $text{"dhcp_opt_desc_78_6"} }}, 
                    { "name" => "79",  "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_79_4"},  "ipv6" => $text{"dhcp_opt_desc_79_6"} }}, 
                    { "name" => "80",  "alt_names" => { "ipv4" => "rapid-commit" },                                                  "desc" => { "ipv4" => $text{"dhcp_opt_desc_80_4"},  "ipv6" => $text{"dhcp_opt_desc_80_6"} }}, 
                    { "name" => "81",  "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_81_4"},  "ipv6" => $text{"dhcp_opt_desc_81_6"} }}, 
                    { "name" => "82",  "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_82_4"},  "ipv6" => $text{"dhcp_opt_desc_82_6"} }}, 
                    { "name" => "83",  "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_83_4"},  "ipv6" => $text{"dhcp_opt_desc_83_6"} }}, 
                    { "name" => "84",  "alt_names" => { },                                                                           "desc" => { "ipv6" => $text{"dhcp_opt_desc_84_6"} }}, 
                    { "name" => "85",  "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_85_4"},  "ipv6" => $text{"dhcp_opt_desc_85_6"} }}, 
                    { "name" => "86",  "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_86_4"},  "ipv6" => $text{"dhcp_opt_desc_86_6"} }}, 
                    { "name" => "87",  "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_87_4"},  "ipv6" => $text{"dhcp_opt_desc_87_6"} }}, 
                    { "name" => "88",  "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_88_4"},  "ipv6" => $text{"dhcp_opt_desc_88_6"} }}, 
                    { "name" => "89",  "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_89_4"},  "ipv6" => $text{"dhcp_opt_desc_89_6"} }}, 
                    { "name" => "90",  "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_90_4"},  "ipv6" => $text{"dhcp_opt_desc_90_6"} }}, 
                    { "name" => "91",  "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_91_4"},  "ipv6" => $text{"dhcp_opt_desc_91_6"} }}, 
                    { "name" => "92",  "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_92_4"},  "ipv6" => $text{"dhcp_opt_desc_92_6"} }}, 
                    { "name" => "93",  "alt_names" => { "ipv4" => "client-arch" },                                                   "desc" => { "ipv4" => $text{"dhcp_opt_desc_93_4"},  "ipv6" => $text{"dhcp_opt_desc_93_6"} }}, 
                    { "name" => "94",  "alt_names" => { "ipv4" => "client-interface-id" },                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_94_4"},  "ipv6" => $text{"dhcp_opt_desc_94_6"} }}, 
                    { "name" => "95",  "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_95_4"},  "ipv6" => $text{"dhcp_opt_desc_95_6"} }}, 
                    { "name" => "96",  "alt_names" => { },                                                                           "desc" => { "ipv6" => $text{"dhcp_opt_desc_96_6"} }}, 
                    { "name" => "97",  "alt_names" => { "ipv4" => "client-machine-id" },                                             "desc" => { "ipv4" => $text{"dhcp_opt_desc_97_4"},  "ipv6" => $text{"dhcp_opt_desc_97_6"} }}, 
                    { "name" => "98",  "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_98_4"},  "ipv6" => $text{"dhcp_opt_desc_98_6"} }}, 
                    { "name" => "99",  "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_99_4"},  "ipv6" => $text{"dhcp_opt_desc_99_6"} }}, 
                    { "name" => "100", "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_100_4"}, "ipv6" => $text{"dhcp_opt_desc_100_6"} }}, 
                    { "name" => "101", "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_101_4"}, "ipv6" => $text{"dhcp_opt_desc_101_6"} }}, 
                    { "name" => "102", "alt_names" => { },                                                                           "desc" => { "ipv6" => $text{"dhcp_opt_desc_102_6"} }}, 
                    { "name" => "103", "alt_names" => { },                                                                           "desc" => { "ipv6" => $text{"dhcp_opt_desc_103_6"} }}, 
                    { "name" => "104", "alt_names" => { },                                                                           "desc" => { "ipv6" => $text{"dhcp_opt_desc_104_6"} }}, 
                    { "name" => "105", "alt_names" => { },                                                                           "desc" => { "ipv6" => $text{"dhcp_opt_desc_105_6"} }}, 
                    { "name" => "106", "alt_names" => { },                                                                           "desc" => { "ipv6" => $text{"dhcp_opt_desc_106_6"} }}, 
                    { "name" => "107", "alt_names" => { },                                                                           "desc" => { "ipv6" => $text{"dhcp_opt_desc_107_6"} }}, 
                    { "name" => "108", "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_108_4"}, "ipv6" => $text{"dhcp_opt_desc_108_6"} }}, 
                    { "name" => "109", "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_109_4"}, "ipv6" => $text{"dhcp_opt_desc_109_6"} }}, 
                    { "name" => "110", "alt_names" => { },                                                                           "desc" => { "ipv6" => $text{"dhcp_opt_desc_110_6"} }}, 
                    { "name" => "111", "alt_names" => { },                                                                           "desc" => { "ipv6" => $text{"dhcp_opt_desc_111_6"} }}, 
                    { "name" => "112", "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_112_4"}, "ipv6" => $text{"dhcp_opt_desc_112_6"} }}, 
                    { "name" => "113", "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_113_4"}, "ipv6" => $text{"dhcp_opt_desc_113_6"} }}, 
                    { "name" => "114", "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_114_4"}, "ipv6" => $text{"dhcp_opt_desc_114_6"} }}, 
                    { "name" => "115", "alt_names" => { },                                                                           "desc" => { "ipv6" => $text{"dhcp_opt_desc_115_6"} }}, 
                    { "name" => "116", "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_116_4"}, "ipv6" => $text{"dhcp_opt_desc_116_6"} }}, 
                    { "name" => "117", "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_117_4"}, "ipv6" => $text{"dhcp_opt_desc_117_6"} }}, 
                    { "name" => "118", "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_118_4"}, "ipv6" => $text{"dhcp_opt_desc_118_6"} }}, 
                    { "name" => "119", "alt_names" => { "ipv4" => "domain-search" },                                                 "desc" => { "ipv4" => $text{"dhcp_opt_desc_119_4"}, "ipv6" => $text{"dhcp_opt_desc_119_6"} }}, 
                    { "name" => "120", "alt_names" => { "ipv4" => "sip-server" },                                                    "desc" => { "ipv4" => $text{"dhcp_opt_desc_120_4"}, "ipv6" => $text{"dhcp_opt_desc_120_6"} }}, 
                    { "name" => "121", "alt_names" => { "ipv4" => "classless-static-route" },                                        "desc" => { "ipv4" => $text{"dhcp_opt_desc_121_4"}, "ipv6" => $text{"dhcp_opt_desc_121_6"} }}, 
                    { "name" => "122", "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_122_4"}, "ipv6" => $text{"dhcp_opt_desc_122_6"} }}, 
                    { "name" => "123", "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_123_4"}, "ipv6" => $text{"dhcp_opt_desc_123_6"} }}, 
                    { "name" => "124", "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_124_4"}, "ipv6" => $text{"dhcp_opt_desc_124_6"} }}, 
                    { "name" => "125", "alt_names" => { "ipv4" => "vendor-id-encap" },                                               "desc" => { "ipv4" => $text{"dhcp_opt_desc_125_4"}, "ipv6" => $text{"dhcp_opt_desc_125_6"} }}, 
                    { "name" => "126", "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_126_4"}, "ipv6" => $text{"dhcp_opt_desc_126_6"} }}, 
                    { "name" => "127", "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_127_4"}, "ipv6" => $text{"dhcp_opt_desc_127_6"} }}, 
                    { "name" => "128", "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_128_4"}, "ipv6" => $text{"dhcp_opt_desc_128_6"} }}, 
                    { "name" => "129", "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_129_4"}, "ipv6" => $text{"dhcp_opt_desc_129_6"} }}, 
                    { "name" => "130", "alt_names" => { },                                                                           "desc" => { "ipv6" => $text{"dhcp_opt_desc_130_6"} }}, 
                    { "name" => "131", "alt_names" => { },                                                                           "desc" => { "ipv6" => $text{"dhcp_opt_desc_131_6"} }}, 
                    { "name" => "132", "alt_names" => { },                                                                           "desc" => { "ipv6" => $text{"dhcp_opt_desc_132_6"} }}, 
                    { "name" => "133", "alt_names" => { },                                                                           "desc" => { "ipv6" => $text{"dhcp_opt_desc_133_6"} }}, 
                    { "name" => "134", "alt_names" => { },                                                                           "desc" => { "ipv6" => $text{"dhcp_opt_desc_134_6"} }}, 
                    { "name" => "135", "alt_names" => { },                                                                           "desc" => { "ipv6" => $text{"dhcp_opt_desc_135_6"} }}, 
                    { "name" => "136", "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_136_4"}, "ipv6" => $text{"dhcp_opt_desc_136_6"} }}, 
                    { "name" => "137", "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_137_4"}, "ipv6" => $text{"dhcp_opt_desc_137_6"} }}, 
                    { "name" => "138", "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_138_4"}, "ipv6" => $text{"dhcp_opt_desc_138_6"} }}, 
                    { "name" => "139", "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_139_4"}, "ipv6" => $text{"dhcp_opt_desc_139_6"} }}, 
                    { "name" => "140", "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_140_4"}, "ipv6" => $text{"dhcp_opt_desc_140_6"} }}, 
                    { "name" => "141", "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_141_4"}, "ipv6" => $text{"dhcp_opt_desc_141_6"} }}, 
                    { "name" => "142", "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_142_4"}, "ipv6" => $text{"dhcp_opt_desc_142_6"} }}, 
                    { "name" => "143", "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_143_4"}, "ipv6" => $text{"dhcp_opt_desc_143_6"} }}, 
                    { "name" => "144", "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_144_4"}, "ipv6" => $text{"dhcp_opt_desc_144_6"} }}, 
                    { "name" => "145", "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_145_4"}, "ipv6" => $text{"dhcp_opt_desc_145_6"} }}, 
                    { "name" => "146", "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_146_4"}, "ipv6" => $text{"dhcp_opt_desc_146_6"} }}, 
                    { "name" => "147", "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_147_4"}, "ipv6" => $text{"dhcp_opt_desc_147_6"} }}, 
                    { "name" => "148", "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_148_4"} }}, 
                    { "name" => "150", "alt_names" => { "ipv4" => "tftp-server-address" },                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_150_4"} }}, 
                    { "name" => "151", "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_151_4"} }}, 
                    { "name" => "152", "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_152_4"} }}, 
                    { "name" => "153", "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_153_4"} }}, 
                    { "name" => "154", "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_154_4"} }}, 
                    { "name" => "155", "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_155_4"} }}, 
                    { "name" => "156", "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_156_4"} }}, 
                    { "name" => "157", "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_157_4"} }}, 
                    { "name" => "158", "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_158_4"} }}, 
                    { "name" => "159", "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_159_4"} }}, 
                    { "name" => "161", "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_161_4"} }}, 
                    { "name" => "162", "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_162_4"} }}, 
                    { "name" => "175", "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_175_4"} }}, 
                    { "name" => "176", "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_176_4"} }}, 
                    { "name" => "177", "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_177_4"} }}, 
                    { "name" => "208", "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_208_4"} }}, 
                    { "name" => "209", "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_209_4"} }}, 
                    { "name" => "210", "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_210_4"} }}, 
                    { "name" => "211", "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_211_4"} }}, 
                    { "name" => "212", "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_212_4"} }}, 
                    { "name" => "213", "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_213_4"} }}, 
                    { "name" => "220", "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_220_4"} }}, 
                    { "name" => "221", "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_221_4"} }}, 
                    { "name" => "252", "alt_names" => { },                                                                           "desc" => { "ipv4" => $text{"dhcp_opt_desc_252_4"} }}, 
                    { "name" => "255", "alt_names" => { "ipv4" => "server-ip-address" },                                             "desc" => { "ipv4" => $text{"dhcp_opt_desc_255_4"} }}, 
                    # { "name" => "", "alt_names" => { },                                                                        "desc" => $text{"dhcp_opt_desc_"}},
                ]
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
                "ipversion" => 4,
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_option_vendor"},
                "template" => "vendor:<" . $text{"tmpl_vendorclass"} . ">"
            },
            "encap" => {
                "ipversion" => 4,
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
        },
        "dhcp_option_force" => {  # =[tag:<tag>,[tag:<tag>,]][encap:<opt>,][vi-encap:<enterprise>,][vendor:[<vendor-class>],][<opt>|option:<opt-name>|option6:<opt>|option6:<opt-name>],[<value>[,<value>]]
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
        },
        "dhcp_no_override" => { 
            "param_order" => [ "val" ],
            "val" => {
                "valtype" => "bool",
                "default" => 0,
            }
        },
        "dhcp_relay" => {  # =<local address>,<server address>[,<interface]
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
        },
        "dhcp_vendorclass" => {  # =set:<tag>,[enterprise:<IANA-enterprise number>,]<vendor-class>
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
        },
        "dhcp_userclass" => {  # =set:<tag>,<user-class>
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
        },
        "dhcp_mac" => {  # =set:<tag>,<MAC address>
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
                "label" => $text{"p_label_val_hwaddr"},
                "template" => $text{"tmpl_mac"}
            },
        },
        "dhcp_circuitid" => {  # =set:<tag>,<circuit-id>
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
        },
        "dhcp_remoteid" => {  # =set:<tag>,<remote-id>
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
        },
        "dhcp_subscrid" => {  # =set:<tag>,<subscriber-id>
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
        },
        "dhcp_proxy" => {  # [=<ip addr>]......
            "param_order" => [ "val" ],
            "val" => {
                "length" => 10,
                "valtype" => "ip",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_ip_addresses"},
                "template" => $text{"tmpl_ip"}
            }
        },
        "dhcp_match" => {  # =set:<tag>,<option number>|option:<option name>|vi-encap:<enterprise>[,<value>]
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
        },
        "dhcp_name_match" => {  # =set:<tag>,<name>[*]
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
        },
        "tag_if" => {  # =set:<tag>[,set:<tag>[,tag:<tag>[,tag:<tag>]]]
            "param_order" => [ "settag", "iftag" ],
            "settag" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_set_tags"},
                "template" => "set:<" . $text{"tmpl_tag"} . ">[,set:<" . $text{"tmpl_tag"} . ">]",
                "arr" => 1,
                "sep" => ",",
            },
            "iftag" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_tags"},
                "template" => "tag:<" . $text{"tmpl_tag"} . ">[,tag:<" . $text{"tmpl_tag"} . ">]",
                "arr" => 1,
                "sep" => ",",
            },
        },
        "dhcp_ignore" => {  # =tag:<tag>[,tag:<tag>]
            "param_order" => [ "tag" ],
            "tag" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_tags"},
                "template" => "tag:<" . $text{"tmpl_tag"} . ">[,tag:<" . $text{"tmpl_tag"} . ">]",
                "arr" => 1,
                "sep" => ",",
            },
        },
        "dhcp_ignore_names" => {  # [=tag:<tag>[,tag:<tag>]]
            "param_order" => [ "tag" ],
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
        },
        "dhcp_generate_names" => {  # =tag:<tag>[,tag:<tag>]
            "param_order" => [ "tag" ],
            "tag" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_tags"},
                "template" => "tag:<" . $text{"tmpl_tag"} . ">[,tag:<" . $text{"tmpl_tag"} . ">]",
                "arr" => 1,
                "sep" => ",",
            },
        },
        "dhcp_broadcast" => {  # [=tag:<tag>[,tag:<tag>]]
            "param_order" => [ "tag" ],
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
        },
        "dhcp_boot" => {  # =[tag:<tag>,]<filename>,[<servername>[,<server address>|<tftp_servername>]]
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
                "valtype" => "file",
                "req_perms" => "read",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_filename"},
                "template" => "<" . $text{"tmpl_path_to_file"} . ">",
                "script" => 1,
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
        },
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
        "pxe_service" => {  # =[tag:<tag>,]<CSA>,<menu text>[,<basename>|<bootservicetype>][,<server address>|<server_name>]
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
                "template" => "<" . $text{"tmpl_base_name"} . ">|<" . $text{"tmpl_boot_service_type"} . ">",
                "can_be" => "file",
                "req_perms" => "read"
            },
            "server" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_server_address_or_name"},
                "template" => "<" . $text{"tmpl_server_address"} . ">|<" . $text{"tmpl_servername"} . ">"
            },
        },
        "pxe_prompt" => {  # =[tag:<tag>,]<prompt>[,<timeout>]
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
                "template" => "<" . $text{"tmpl_integer"} . ">",
                "pattern" => "\\d{1,5}"
            },
        },
        "dhcp_pxe_vendor" => {  # =<vendor>[,...]
            "param_order" => [ "val" ],
            "val" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_vendor"},
                "template" => "<" . $text{"tmpl_string"} . ">[,<" . $text{"tmpl_string"} . ">...]"
            }
        },
        "dhcp_lease_max" => {  # =<number>
            "param_order" => [ "val" ],
            "val" => {
                "length" => 3,
                "valtype" => "int",
                "default" => 0,
                "required" => 1,
                "label" => $text{"p_label_val_leasetime"},
                "template" => "<" . $text{"tmpl_integer"} . ">",
                "pattern" => "\\d{1,10}"
            }
        },
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
        "dhcp_alternate_port" => {  # [=<server port>[,<client port>]]
            "param_order" => [ "serverport", "clientport" ],
            "serverport" => {
                "length" => 3,
                "valtype" => "int",
                "default" => 0,
                "required" => 0,
                "label" => $text{"p_label_val_serverport"},
                "template" => "<" . $text{"tmpl_port"} . ">",
                "pattern" => "\\d{1,5}",
                "min" => 0,
                "max" => 65535
            },
            "clientport" => {
                "length" => 3,
                "valtype" => "int",
                "default" => 0,
                "required" => 0,
                "label" => $text{"p_label_val_clientport"},
                "template" => "<" . $text{"tmpl_port"} . ">",
                "pattern" => "\\d{1,5}",
                "min" => 0,
                "max" => 65535
            },
        },
        "bootp_dynamic" => {  # [=<network-id>[,<network-id>]]
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
        },
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
        "dhcp_leasefile" => {  # =<path>
            "param_order" => [ "val" ],
            "val" => {
                "length" => 15,
                "valtype" => "file",
                "req_perms" => "read,write",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_filename"},
                "template" => "<" . $text{"tmpl_path_to_file"} . ">"
            },
        },
        "dhcp_duid" => {  # =<enterprise-id>,<uid>
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
        },
        "dhcp_script" => {  # =<path>
            "param_order" => [ "val" ],
            "val" => {
                "length" => 15,
                "valtype" => "file",
                "must_exist" => 1,
                "req_perms" => "read,execute",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_filename"},
                "template" => "<" . $text{"tmpl_path_to_file"} . ">",
                "script" => 1
            }
        },
        "dhcp_luascript" => {  # =<path>
            "param_order" => [ "val" ],
            "val" => {
                "length" => 15,
                "valtype" => "file",
                "must_exist" => 1,
                "req_perms" => "read,execute",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_filename"},
                "template" => "<" . $text{"tmpl_path_to_file"} . ">",
                "script" => 1
            }
        },
        "dhcp_scriptuser" => {  # =<username>
            "param_order" => [ "val" ],
            "val" => {
                "length" => 10,
                "valtype" => "user",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_username"},
                "template" => "<" . $text{"tmpl_username"} . ">"
            }
        },
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
        "bridge_interface" => {  # =<interface>,<alias>[,<alias>]
            "param_order" => [ "interface", "alias" ],
            "interface" => {
                "length" => 10,
                "valtype" => "interface",
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
        },
        "shared_network" => {  # =<interface|addr>,<addr>
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
        },
        "domain" => {  # =<domain>[,<address range>[,local]]
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
        },
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
        "ra_param" => {  # =<interface>,[mtu:<integer>|<interface>|off,][high,|low,]<ra-interval>[,<router lifetime>]
            "param_order" => [ "interface", "mtu", "priority", "interval", "lifetime" ],
            "interface" => {
                "length" => 10,
                "valtype" => "interface",
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
                "template" => "<high|low>", # literal value
                "pattern" => "high|low" # literal value
            },
            "interval" => {
                "length" => 10,
                "valtype" => "int",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_interval"},
                "template" => "<" . $text{"tmpl_integer"} . ">",
                "pattern" => "\\d{1,5}"
            },
            "lifetime" => {
                "length" => 10,
                "valtype" => "int",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_lifetime"},
                "template" => "<" . $text{"tmpl_integer"} . ">",
                "pattern" => "\\d{1,5}"
            },
        },
        "dhcp_reply_delay" => {  # =[tag:<tag>,]<integer>
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
                "template" => "<" . $text{"tmpl_integer"} . ">",
                "pattern" => "\\d{1,5}"
            },
        },
        "enable_tftp" => {  # [=<interface>[,<interface>]]
            "param_order" => [ "val" ],
            "val" => {
                "length" => 10,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_interfaces"},
                "template" => "<" . $text{"tmpl_interface"} . ">[,<" . $text{"tmpl_interface"} . ">]"
            },
        },
        "tftp_root" => {  # =<directory>[,<interface>]
            "param_order" => [ "directory", "interface" ],
            "directory" => {
                "length" => 15,
                "valtype" => "dir",
                "req_perms" => "read",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_dirname"},
                "template" => "<" . $text{"tmpl_path_to_directory"} . ">",
                "pattern" => "(?!.*\\.{2}).*" # man page says: "TFTP paths which include ".." are rejected, to stop clients getting outside the specified root"
            },
            "interface" => {
                "length" => 10,
                "valtype" => "interface",
                "default" => "",
                "required" => 0,
                "label" => $text{"p_label_val_interface"},
                "template" => "<" . $text{"tmpl_interface"} . ">"
            },
        },
        "tftp_no_fail" => { 
            "param_order" => [ "val" ],
            "val" => {
                "valtype" => "bool",
                "default" => 0,
            }
        },
        "tftp_unique_root" => {  # [=ip|mac]
            "param_order" => [ "val" ],
            "val" => {
                "length" => 15,
                "valtype" => "string",
                "default" => "",
                "required" => 0,
                "label" => "ip|mac",
                "template" => "ip|mac", # literal value
                "pattern" => "ip|mac" # literal value
            },
        },
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
        "tftp_max" => {  # =<connections>
            "param_order" => [ "val" ],
            "val" => {
                "length" => 3,
                "valtype" => "int",
                "default" => 0,
                "required" => 1,
                "label" => $text{"p_label_val_max_connections"},
                "template" => "<" . $text{"tmpl_integer"} . ">",
                "pattern" => "\\d{1,5}"
            }
        },
        "tftp_mtu" => {  # =<mtu size>
            "param_order" => [ "val" ],
            "val" => {
                "length" => 3,
                "valtype" => "int",
                "default" => 0,
                "required" => 1,
                "label" => $text{"p_label_val_mtu"},
                "template" => "<" . $text{"tmpl_mtu"} . ">",
                "pattern" => "\\d{1,5}"
            }
        },
        "tftp_no_blocksize" => { 
            "param_order" => [ "val" ],
            "val" => {
                "valtype" => "bool",
                "default" => 0,
            }
        },
        "tftp_port_range" => {  # =<start>,<end>
            "param_order" => [ "start", "end" ],
            "start" => {
                "length" => 3,
                "valtype" => "int",
                "default" => 0,
                "required" => 1,
                "label" => $text{"p_label_val_start_port"},
                "template" => "<" . $text{"tmpl_port"} . ">",
                "pattern" => "\\d{1,5}",
                "min" => 0,
                "max" => 65535
            },
            "end" => {
                "length" => 3,
                "valtype" => "int",
                "default" => 0,
                "required" => 1,
                "label" => $text{"p_label_val_end_port"},
                "template" => "<" . $text{"tmpl_port"} . ">",
                "pattern" => "\\d{1,5}",
                "min" => 0,
                "max" => 65535
            },
        },
        "tftp_single_port" => { 
            "param_order" => [ "val" ],
            "val" => {
                "valtype" => "bool",
                "default" => 0,
            }
        },
        "conf_file" => {  # =<file>
            "param_order" => [ "filename" ],
            "filename" => {
                "length" => 40,
                "valtype" => "file",
                "req_perms" => "read",
                "must_exist" => 1,
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_filename"},
                "template" => "<" . $text{"tmpl_path_to_file"} . ">"
            }
        },
        "conf_dir" => {  # =<directory>[,<file-extension>......],
            "param_order" => [ "dirname", "filter", "exceptions" ],
            "dirname" => {
                "length" => 40,
                "valtype" => "dir",
                "must_exist" => 1,
                "req_perms" => "read",
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
        },
        "servers_file" => {  # =<file>
            "param_order" => [ "filename" ],
            "filename" => {
                "length" => 40,
                "valtype" => "file",
                "must_exist" => 1,
                "req_perms" => "read",
                "default" => "",
                "required" => 1,
                "label" => $text{"p_label_val_filename"},
                "template" => "<" . $text{"tmpl_path_to_file"} . ">"
            }
        },
    );
}

# our $IPADDR = "((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])";
our $IPADDR = "(?:(?:25[0-5]|(?:2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(?:25[0-5]|(?:2[0-4]|1{0,1}[0-9]){0,1}[0-9])";
# $IPV6ADDR = "([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])";
# our $IPV6ADDR = "[0-9a-fA-F\:]*";
our $IPV6ADDR = "[0-9a-fA-F]{1,4}\:+[0-9a-fA-F\:]*";
our $MAC = "(?:[0-9a-fA-F]{2})(?:[:-](?:[0-9a-fA-F]{2}|\\*)){5}";
our $TIME = "(\\d{1,5}[mhdw]?|infinite)";
our $FILE = "[0-9a-zA-Z\_\.\/\-]+";
our $NUMBER="[0-9]+";
my $TAG = "(set|tag):([!0-9a-zA-Z\_\.\-]*)";
my $SETTAG = "(?:set:)[0-9a-zA-Z\_\.\-]*";
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
    # if (&is_installed() != 1) {
    #     return 0;
    # }
    &init_configfield_fields();
    my $lineno;
    my ($dnsmconfig_ref, $config_file, $config_filename) = @_;
    my $is_extra_config = $_[3] ? $_[3] : 0;

    if ($is_extra_config == 0) { # initialize the config with all known options 
                                 # (except those that can be specified multiple times)
        $dnsmconfig_ref->{"configfiles"} = ();
        push ( @{ $dnsmconfig_ref->{"configfiles"} }, $config_filename);
        $dnsmconfig_ref->{"scripts"} = ();
        $dnsmconfig_ref->{"idx"} = ();
        $dnsmconfig_ref->{"error"} = ();
        while ( ($key, $vals) = each %dnsmconfigvals ) {
            if ( ! grep { /^$key$/ } ( @confarrs ) ) {
                $dnsmconfig_ref->{$key}{"used"} = 0;
                $dnsmconfig_ref->{$key}{"line"} = -1;
                $dnsmconfig_ref->{$key}{"file"} = $config_filename;
            }
        }
    }
    else {
        push ( @{ $dnsmconfig_ref->{"configfiles"} }, $$config_filename);
    }

    my $max_iterations = 20;
    my $current = 0;
    $lineno=0;
    foreach my $line (@$$config_file) {
        my $remainder = "";
        my %temp = ();
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
            # $line =~ s/^\s+|\s+$//g;
            next if ($line !~ /^[0-9a-zA-Z\_\-\#]/);
            foreach my $b ( @confbools ) {
                # print $b;
                if ($line =~ /^[\#]*[\s]*$b[\s]*$/ ) {
                    if ($dnsmconfig_ref->{$b}->{"used"} == 0) { # only overwrite if the last value read is not used (commented)
                        $dnsmconfig_ref->{$b}->{"used"} = ($line!~/^\#/);
                        $dnsmconfig_ref->{$b}->{"line"} = $lineno;
                        $dnsmconfig_ref->{$b}->{"file"} = $config_filename;
                    }
                    $found = 1;
                    last;
                }
            }
            next if ($found == 1);
            if ($line =~ /(^[\#]*[\s]*([a-z0-9\-]{3,}))\=(.*)$/ ) {
                my $configfield = $2;
                my $internalfield = &config_to_internal($configfield);
                my $fdef = $configfield_fields{$internalfield};
                $remainder = $3;
                %temp = ( );
                $temp{"used"} = ($line !~ /^\#/);
                $temp{"line"} = $lineno;
                $temp{"file"} = $config_filename;
                $temp{"full"} = $line;
                if ( ! grep { /^$configfield$/ } ( keys %dnsmconfigvals ) ) {
                    # print "Error in line $lineno ($configfield: unknown option)! ";
                    push(@{$dnsmconfig_ref->{"error"}}, &create_error($config_filename, $lineno, &text("err_unknown_", $configfield)));
                    next;
                }
                my $confvar = \%{ $dnsmconfigvals{"$configfield"} };
                if ( $confvar->{"mult"} ne "" ) {
                    my $sep = $confvar->{"mult"};
                    # $temp{"val"} = @();
                    while ( $remainder && $remainder =~ /^$sep?($NAME)($sep[0-9a-zA-Z\.\-\/]*)*/ ) {
                        push @{ $temp{"val"} }, ( $1 );
                        $remainder = $2;
                    }
                }
                elsif ( grep { /^$configfield$/ } ( @confsingles ) ) {
                    if (defined($fdef->{"val"}->{"arr"}) && $fdef->{"val"}->{"arr"} == 1) {
                        push( @{$temp{"val"}}, split(",", $remainder) );
                        if (defined($fdef->{"val"}->{"script"}) && $fdef->{"val"}->{"script"} == 1 && $temp{"used"} && ! grep { $remainder } ( @{ $dnsmconfig_ref->{"scripts"} } )) {
                            push ( @{ $dnsmconfig_ref->{"scripts"} }, $remainder);
                        }
                    }
                    else {
                        $temp{"val"} = $remainder;
                        if (defined($fdef->{"val"}->{"script"}) && $fdef->{"val"}->{"script"} == 1 && $temp{"used"} && ! grep { $remainder } ( @{ $dnsmconfig_ref->{"scripts"} } )) {
                            push ( @{ $dnsmconfig_ref->{"scripts"} }, $remainder);
                        }
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
                    given ( "$configfield" ) {
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
                            if ( $remainder && $remainder =~ /^($IPADDR\-$IPADDR)\,($IPADDR)\,($IPADDR)$/ ) { # range with netmask
                                $valtemp{"from"} = $1;
                                $valtemp{"to"} = $2;
                                $valtemp{"netmask"} = $3;
                                $valtemp{"netmask-used"} = 1;
                            }
                            elsif ( $remainder && $remainder =~ /^($IPADDR\-$IPADDR)\,($IPADDR)$/ ) { # range without netmask
                                $valtemp{"from"} = $1;
                                $valtemp{"to"} = $2;
                            }
                            elsif ( $remainder && $remainder =~ /^($IPADDR)\,($IPADDR)\,($IPADDR)$/ ) { # IP with netmask
                                $valtemp{"from"} = $1;
                                $valtemp{"to"} = $2;
                                $valtemp{"netmask"} = $3;
                                $valtemp{"netmask-used"} = 1;
                            }
                            elsif ( $remainder && $remainder =~ /^($IPADDR)\,($IPADDR)$/ ) { # IP without netmask
                                $valtemp{"from"} = $1;
                                $valtemp{"to"} = $2;
                            }
                        }
                        when ("bogus-nxdomain") { # =<ipaddr>[/prefix]
                            if ( $remainder && $remainder =~ /^($IPADDR(\/[0-9]{1,2})?)$/ ) {
                                $valtemp{"addr"} = $1;
                            }
                        }
                        when ("ignore-address") { # =<ipaddr>[/prefix]
                            if ( $remainder && $remainder =~ /^($IPADDR(\/[0-9]{1,2})?)$/ ) {
                                $valtemp{"ip"} = $1;
                            }
                        }
                        when ("local") { # =[/[<domain>]/[domain/]][<ipaddr>[#<port>]][@<interface>][@<source-ip>[#<port>]]
                            $current = 0;
                            while ( $remainder && $remainder =~ /^\/((?:[a-z0-9#](?:[a-z0-9\-]{0,61}[a-z0-9\.])?)+[a-z0-9][a-z0-9\-]{0,61}[a-z0-9])\/(.*)$/ ) {
                                push( @{ $valtemp{"domain"} }, $1 );
                                $remainder = $2;
                                last if ($current++ >= $max_iterations);
                            }
                            if ( $remainder && $remainder =~ /^($IPADDR(#[0-9]{1,5})?)(.*)$/ ) {
                                $valtemp{"ip"} = $1;
                                $remainder = $2;
                            }
                            elsif ( $remainder && $remainder =~ /^($IPV6ADDR(%[a-zA-Z0-9])?)(.*)$/ ) {
                                $valtemp{"ip"} = $1;
                                $remainder = $2;
                            }
                            if ( $remainder && $remainder =~ /^@(.*)$/ ) {
                                $valtemp{"source"} = $1;
                            }
                        }
                        when ("server") { # =[/[<domain>]/[domain/]][<ipaddr>[#<port>]][@<interface>][@<source-ip>[#<port>]]
                            $current = 0;
                            while ( $remainder && $remainder =~ /^\/((?:[a-z0-9#](?:[a-z0-9\-]{0,61}[a-z0-9\.])?)+[a-z0-9][a-z0-9\-]{0,61}[a-z0-9])\/(.*)$/ ) {
                                push( @{ $valtemp{"domain"} }, $1 );
                                $remainder = $2;
                                last if ($current++ >= $max_iterations);
                            }
                            if ( $remainder && $remainder =~ /^($IPADDR(#[0-9]{1,5})?)(.*)$/ ) {
                                $valtemp{"ip"} = $1;
                                $remainder = $3;
                            }
                            elsif ( $remainder && $remainder =~ /^($IPV6ADDR(%[a-zA-Z0-9])?)(.*)$/ ) {
                                $valtemp{"ip"} = $1;
                                $remainder = $3;
                            }
                            if ( $remainder && $remainder =~ /^@(.*)$/ ) {
                                $valtemp{"source"} = $1;
                            }
                        }
                        when ("rev-server") { # =<ip-address>/<prefix-len>[,<ipaddr>][#<port>][@<interface>][@<source-ip>[#<port>]]
                            if ( $remainder && $remainder =~ /^\/($IPADDR\/[0-9]{1,2})(,.*)$/ ) {
                                $valtemp{"domain"} = $1;
                                $remainder = $2;
                            }
                            if ( $remainder && $remainder =~ /^\/($IPADDR(#[0-9]{1,5})?)(,.*)$/ ) {
                                $valtemp{"ip"} = $1;
                                $remainder = $2;
                            }
                            elsif ( $remainder && $remainder =~ /^\/($IPV6ADDR(%[a-zA-Z0-9])?)(.*)$/ ) {
                                $valtemp{"ip"} = $1;
                                $remainder = $2;
                            }
                            if ( $remainder && $remainder =~ /^@(.*)$/ ) {
                                $valtemp{"source"} = $1;
                            }
                        }
                        when ("address") { # =/<domain>[/<domain>...]/[<ipaddr>]
                            if ( $remainder && $remainder =~ /^\/(.*)\/($IPADDR)?$/ ) {
                                $valtemp{"domain"}=$1;
                                if ( defined ($2) ) {
                                    $valtemp{"ip"} = $2;
                                }
                            }
                            elsif ( $remainder && $remainder =~ /^\/(.*)\/($IPV6ADDR)?$/ ) {
                                $valtemp{"domain"}=$1;
                                if ( defined ($2) ) {
                                    $valtemp{"ip"} = $2;
                                }
                            }
                        }
                        when ("ipset") { # =/<domain>[/<domain>...]/<ipset>[,<ipset>...]
                            if ( $remainder && $remainder =~ /^\/([a-zA-Z\_\.][0-9a-zA-Z\_\.\-\/]*)\/([0-9a-zA-Z\,\.\-]*)$/ ) {
                                my $domains = $1;
                                my $ipsets = $2;
                                $current = 0;
                                while ($domains && $domains =~ /^([a-zA-Z\_\.][0-9a-zA-Z\_\.\-]*)((?:\/)(.*))*$/ ) {
                                    push( @{ $valtemp{"domain"} }, $1 );
                                    $domains = $3;
                                    last if ($current++ >= $max_iterations);
                                }
                                $current = 0;
                                while ( $ipsets && $ipsets =~ /^([0-9a-zA-Z\.\-]+)((?:,)(.*))*$/ && defined($1) ) {
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
                                if ( $remainder && $remainder =~ /^($NAME)((?:,)(.*))*$/ ) {
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
                            if( $remainder && $remainder =~ /^((_[a-zA-Z]*)\.(_[a-zA-Z]*)\.)(.*)$/ ) {
                                $valtemp{"service"} = $2;
                                $valtemp{"prot"} = $3;
                                $remainder = $4;
                                if ( $remainder && $remainder =~ /^($NAME)((?:,)(.*))*$/ ) {
                                    $valtemp{"domain"}=$1;
                                    $remainder=$3;
                                }
                                if ( $remainder && $remainder =~ /^($NAME)((?:,)(.*))*$/ ) {
                                    $valtemp{"target"}=$1;
                                    $remainder=$3;
                                    if ( $remainder && $remainder =~ /^($NUMBER)((?:,)(.*))*$/ ) {
                                        $valtemp{"port"}=$1;
                                        $remainder=$3;
                                        if ( $remainder && $remainder =~ /^($NUMBER)((?:,)(.*))*$/ ) {
                                            $valtemp{"priority"}=$1;
                                            $remainder=$3;
                                            if ( $remainder && $remainder =~ /^($NUMBER)((?:,)(.*))*$/ ) {
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
                            if ( $remainder && $remainder =~ /^(.*)((?:,)($IPADDR))((?:,)(.*))*$/ ) {
                                $valtemp{"ipv4"} = $3;
                                $remainder = $1 . $4;
                            }
                            if ( $remainder && $remainder =~ /^(.*)((?:,)($IPV6ADDR))((?:,)(.*))*$/ ) {
                                $valtemp{"ipv6"} = $3;
                                $remainder = $1 . $4;
                            }
                            if ( $remainder && $remainder =~ /^(.*)((?:,)([0-9]{1,5}))$/ ) {
                                $valtemp{"ttl"} = $3;
                                $remainder = $1;
                            }
                            $valtemp{"name"} = $remainder;
                        }
                        when ("dynamic-host") { # =<name>[,IPv4-address][,IPv6-address],<interface>
                            if ( $remainder && $remainder =~ /^(.*)((?:,)($IPADDR))((?:,)(.*))$/ ) {
                                $valtemp{"ipv4"} = $3;
                                $remainder = $1 . $4;
                            }
                            if ( $remainder && $remainder =~ /^(.*)((?:,)($IPV6ADDR))((?:,)(.*))$/ ) {
                                $valtemp{"ipv6"} = $3;
                                $remainder = $1 . $4;
                            }
                            if ( $remainder && $remainder =~ /^(.*)((?:,)(.*))$/ ) {
                                $valtemp{"name"} = $1;
                                $valtemp{"interface"} = $3;
                            }
                        }
                        when ("txt-record") { # =<name>[[,<text>],<text>]
                            if ( $remainder && $remainder =~ /^(.*)((?:,)(.*))$/ ) {
                                $valtemp{"name"} = $1;
                                $valtemp{"text"} = $3;
                            }
                        }
                        when ("ptr-record") { # =<name>[,<target>]
                            if ( $remainder && $remainder =~ /^(.*)((?:,)(.*))$/ ) {
                                $valtemp{"name"} = $1;
                                if ( defined($3) ) {
                                    $valtemp{"target"} = $3;
                                }
                            }
                        }
                        when ("naptr-record") { # =<name>,<order>,<preference>,<flags>,<service>,<regexp>[,<replacement>]
                            if ( $remainder && $remainder =~ /^(.*)((?:,)(.*))$/ ) {
                                $valtemp{"name"} = $1;
                                $remainder = $3;
                            }
                            if ( $remainder && $remainder =~ /^(.*)((?:,)(.*))$/ ) {
                                $valtemp{"order"} = $1;
                                $remainder = $3;
                            }
                            if ( $remainder && $remainder =~ /^(.*)((?:,)(.*))$/ ) {
                                $valtemp{"preference"} = $1;
                                $remainder = $3;
                            }
                            if ( $remainder && $remainder =~ /^(.*)((?:,)(.*))$/ ) {
                                $valtemp{"flags"} = $1;
                                $remainder = $3;
                            }
                            if ( $remainder && $remainder =~ /^(.*)((?:,)(.*))$/ ) {
                                $valtemp{"service"} = $1;
                                $remainder = $3;
                            }
                            if ( $remainder && $remainder =~ /^(.*)((?:,)(.*))*$/ ) {
                                $valtemp{"regexp"} = $1;
                                if ( defined($3) ) {
                                    $valtemp{"replacement"} = $3;
                                }
                            }
                        }
                        when ("caa-record") { # =<name>,<flags>,<tag>,<value>
                            if ( $remainder && $remainder =~ /^(.*)((?:,)(.*))$/ ) {
                                $valtemp{"name"} = $1;
                                $remainder = $3;
                            }
                            if ( $remainder && $remainder =~ /^(.*)((?:,)(.*))$/ ) {
                                $valtemp{"flags"} = $1;
                                $remainder = $3;
                            }
                            if ( $remainder && $remainder =~ /^(.*)((?:,)(.*))$/ ) {
                                $valtemp{"tag"} = $1;
                                $valtemp{"value"} = $3;
                            }
                        }
                        when ("cname") { # =<cname>,[<cname>,]<target>[,<TTL>]
                            if ( $remainder && $remainder =~ /^(.*)((?:,)([0-9]{1,5}))$/ ) {
                                $valtemp{"ttl"} = $3;
                                $remainder = $1;
                            }
                            if ( $remainder && $remainder =~ /^(.*)((?:,)(.*))$/ ) {
                                $valtemp{"target"} = $3;
                                $valtemp{"cname"} = $3;
                            }
                        }
                        when ("dns-rr") { # =<name>,<RR-number>,[<hex data>]
                            if ( $remainder && $remainder =~ /^(.*)((?:,)(.*))$/ ) {
                                $valtemp{"name"} = $1;
                                $remainder = $3;
                            }
                            if ( $remainder && $remainder =~ /^(.*)((?:,)(.*))*$/ ) {
                                $valtemp{"rrnumber"} = $1;
                                if ( defined($3) ) {
                                    $valtemp{"hexdata"} = $3;
                                }
                            }
                        }
                        when ("interface-name") { # =<name>,<interface>[/4|/6]
                            if ( $remainder && $remainder =~ /^(.*)((?:,)(.*))$/ ) {
                                $valtemp{"name"} = $1;
                                $valtemp{"interface"} = $3;
                            }
                        }
                        when ("synth-domain") { # =<domain>,<address range>[,<prefix>[*]]
                            if ( $remainder && $remainder =~ /^(.*)((?:,)(.*))$/ ) {
                                $valtemp{"domain"} = $1;
                                $remainder = $3;
                            }
                            if ( $remainder && $remainder =~ /^(.*)((?:,)(.*))*$/ ) {
                                $valtemp{"addressrange"} = $1;
                                if ( defined($3) ) {
                                    $valtemp{"prefix"} = $3;
                                }
                            }
                        }
                        when ("add-subnet") { # [[=[<IPv4 address>/]<IPv4 prefix length>][,[<IPv6 address>/]<IPv6 prefix length>]]
                            if ( $remainder && $remainder =~ /^($IPADDR(\/[0-9]{1,5})?)((?:,)(.*))*$/ ) {
                                $valtemp{"ipv4"} = $1;
                                $remainder = $4;
                            }
                            if ( $remainder && $remainder =~ /^($IPV6ADDR(\/[0-9]{1,5})?)$/ ) {
                                $valtemp{"ipv6"} = $1;
                            }
                        }
                        when ("umbrella") { # [=deviceid:<deviceid>[,orgid:<orgid>]]
                            if ( $remainder && $remainder =~ /^((?:deviceid:)(.*))((?:,orgid:)(.*))*$/ ) {
                                $valtemp{"deviceid"} = $2;
                                if ( defined($4) ) {
                                    $valtemp{"orgid"} = $4;
                                }
                            }
                        }
                        when ("trust-anchor") { # =[<class>,]<domain>,<key-tag>,<algorithm>,<digest-type>,<digest>
                            if ( $remainder && $remainder =~ /^(.*)((?:,)(.*))$/ ) {
                                $valtemp{"digest"} = $3;
                                $remainder = $1;
                            }
                            if ( $remainder && $remainder =~ /^(.*)((?:,)(.*))$/ ) {
                                $valtemp{"digesttype"} = $3;
                                $remainder = $1;
                            }
                            if ( $remainder && $remainder =~ /^(.*)((?:,)(.*))$/ ) {
                                $valtemp{"algorithm"} = $3;
                                $remainder = $1;
                            }
                            if ( $remainder && $remainder =~ /^(.*)((?:,)(.*))$/ ) {
                                $valtemp{"keytag"} = $3;
                                $remainder = $1;
                            }
                            if ( $remainder && $remainder =~ /^(.*)((?:,)(.*))*$/ ) {
                                $valtemp{"domain"} = $1;
                                if ( defined($1) ) {
                                    $valtemp{"class"} = $1;
                                }
                            }
                        }
                        when ("auth-zone") { # =<domain>[,<subnet>[/<prefix length>][,<subnet>[/<prefix length>].....][,exclude:<subnet>[/<prefix length>]].....]
                            if ( $remainder && $remainder =~ /^($NAME)((?:,)(.*))*$/ ) {
                                $valtemp{"domain"} = $1;
                                $remainder = $3;
                                if ( $remainder && $remainder =~ /(exclude:.*)*$/ ) {
                                    $current = 0;
                                    while ( $remainder && $remainder =~ /((?:exclude:)($IPADDR))((?:,exclude:)(.*))*$/ ) {
                                        push( @{ $valtemp{"exclude"} }, $2 );
                                        $remainder = $4;
                                        last if ($current++ >= $max_iterations);
                                    }
                                }
                                if ( $remainder ne "" ) {
                                    $current = 0;
                                    while ( $remainder && $remainder =~ /^($IPADDR)((?:,)(.*))*$/ ) {
                                        push( @{ $valtemp{"include"} }, $1 );
                                        $remainder = $3;
                                        last if ($current++ >= $max_iterations);
                                    }
                                }
                            }
                        }
                        when ("auth-soa") { # =<serial>[,<hostmaster>[,<refresh>[,<retry>[,<expiry>]]]]
                            if ( $remainder && $remainder =~ /^(.*)((?:,)(.*))$/ ) {
                                $valtemp{"serial"} = $1;
                                $remainder = $3;
                                if ( $remainder && $remainder =~ /^(.*)((?:,)(.*))*$/ ) {
                                    $valtemp{"hostmaster"} = $1;
                                    $remainder = $3;
                                    if ( $remainder && $remainder =~ /^(.*)((?:,)(.*))*$/ ) {
                                        $valtemp{"refresh"} = $1;
                                        $remainder = $3;
                                        if ( $remainder && $remainder =~ /^(.*)((?:,)(.*))*$/ ) {
                                            $valtemp{"retry"} = $1;
                                            $remainder = $3;
                                            if ( $remainder && $remainder =~ /^(.*)((?:,)(.*))*$/ ) {
                                                $valtemp{"expiry"} = $1;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        when ("dhcp-range") { # =[tag:<tag>[,tag:<tag>],][set:<tag>,]<start-addr>[,<end-addr>|<mode>][,<netmask>[,<broadcast>]][,<lease time>] -OR- =[tag:<tag>[,tag:<tag>],][set:<tag>,]<start-IPv6addr>[,<end-IPv6addr>|constructor:<interface>][,<mode>][,<prefix-len>][,<lease time>]
                            $current = 0;
                            while ( $remainder && $remainder =~ /^($TAG)\,([0-9a-zA-Z\.\,\-\_: ]*)/ ) { # first get tag
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
                            if ( $remainder && $remainder =~ /^($IPADDR)((?:\,)([0-9a-zA-Z\.\,\-\_]*))*/ ) { # IPv4
                                # ...start...
                                $valtemp{"start"} = $1;
                                $remainder = $3;
                                $valtemp{"proxy"} = 0;
                                if ($remainder && $remainder =~ /^($IPADDR)((?:\,)([0-9a-zA-Z\.\,\-\_]*))*/ ) {
                                    # ...end...
                                    $valtemp{"end"} = $1;
                                    $remainder = $3;
                                }
                                elsif ($remainder && $remainder =~ /^(static)((?:\,)([0-9a-zA-Z\.\,\-\_]*))*/ ) {
                                    $valtemp{"static"} = 1;
                                    $remainder = $3;
                                }
                                elsif ($remainder && $remainder =~ /^(proxy)((?:\,)([0-9a-zA-Z\.\,\-\_]*))*/ ) {
                                    $valtemp{"proxy"} = 1;
                                    $remainder = $3;
                                }
                                $valtemp{"mask"} = "";
                                $valtemp{"mask-used"} = 0;
                                if ($remainder && $remainder =~ /^($IPADDR)((?:\,)([0-9a-zA-Z\.\,\-\_]*))*/ ) {
                                    # ...netmask
                                    $valtemp{"mask"} = $1;
                                    $valtemp{"mask-used"} = 1;
                                    $remainder = $3;
                                    if ($remainder && $remainder =~ /^($IPADDR)((?:\,)([0-9a-zA-Z\.\,\-\_]*))*/ ) {
                                        # ...broadcast
                                        $valtemp{"broadcast"} = $1;
                                        $remainder = $3;
                                    }
                                }
                                if ($remainder && $remainder =~ /^(.*)/ ) {
                                    # ...time (optionally)
                                    $valtemp{"leasetime"} = $1;
                                    $valtemp{"time-used"} = ($1 =~ /^\d/);
                                    $remainder = $2;
                                }
                            }
                            elsif ( $remainder && $remainder =~ /^($IPV6ADDR)\,[\s]*([0-9a-zA-Z\.\,\-\_: ]*)/ ) { # IPv6
                                # start...
                                # $temp{"id"}="";
                                $valtemp{"start"} = $1;
                                $remainder = $2 . ($3 ? $3 : "");
                                $valtemp{"prefix-length"} = 64;
                                $valtemp{"ipversion"} = 6;
                                if ( $remainder && $remainder =~ /^($IPV6ADDR)\,[\s]*([0-9a-zA-Z\.\,\-\_: ]*)/ ) {
                                    # ...end
                                    $valtemp{"end"} = $1;
                                    $remainder = $2 . ($3 ? $3 : "");
                                }
                                $valtemp{"ra-only"} = 0;
                                $valtemp{"ra-names"} = 0;
                                $valtemp{"ra-stateless"} = 0;
                                $valtemp{"slaac"} = 0;
                                $valtemp{"ra-advrouter"} = 0;
                                $valtemp{"off-link"} = 0;
                                $current = 0;
                                while ( $remainder && $remainder =~ /^($IPV6PROP)(\,[\s]*([0-9a-zA-Z\.\,\-\_: ]*))*/ ) {
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
                                if ($remainder && $remainder =~ /^([0-9]{1,3})\,[\s]*(.*)/ ) {
                                    # ...prefix-length, time (optionally)
                                    $valtemp{"prefix-length"} = $1;
                                    $valtemp{"leasetime"}=$2;
                                    $valtemp{"time-used"}=($2 =~ /^\d/);
                                }
                                elsif ($remainder && $remainder =~ /^(.*)/ ) {
                                    # ...time (optionally)
                                    $valtemp{"leasetime"}=$1;
                                    $valtemp{"time-used"}=($1 =~ /^\d/);
                                }
                            }
                        }
                        when ("dhcp-host") { # =[<hwaddr>][,id:<client_id>|*][,set:<tag>][tag:<tag>][,<ipaddr>][,<hostname>][,<lease_time>][,ignore]
                            if ( $remainder && $remainder =~ /^(([0-9a-zA-Z\,\.\-\_: ]*)(\,))($TIME)$/ && defined ($4)) {
                                # time (optional)
                                $remainder = $2;
                                $valtemp{"leasetime"}=$4;
                                $valtemp{"time-used"}=($4 =~ /^\d/);
                            }
                            $current = 0;
                            while ($remainder && $remainder =~ /^([0-9a-zA-Z\.\,\-\_:\* ]*)($SETTAG)((,)([0-9a-zA-Z\.\,\-\_:\* ]*))*$/ && defined ($3) && defined ($4)) {
                                push( @{$valtemp{"settag"}}, $2);
                                $remainder = $1 . $5;
                                last if ($current++ >= $max_iterations);
                            }
                            if ( $remainder && $remainder =~ /^([0-9a-zA-Z\.\,\-\_:\* ]*)($TAG)((,)([0-9a-zA-Z\.\,\-\_:\* ]*))*$/ && defined ($3) && defined ($4)) {
                                $valtemp{"tag"}=$4;
                                $remainder = $1 . ($7 ? $7 : "");
                            }
                            $valtemp{"mac"} = "";
                            if ( $remainder && $remainder =~ /^([0-9a-zA-Z\.\,\-\_:]*)($INFINIBAND)(,([0-9a-zA-Z\.\,\-\_:\*]*))*$/ && defined ($2)) {
                                $remainder = $1 . $6;
                                $valtemp{"infiniband"}=$2;
                            }
                            elsif ( $remainder && $remainder =~ /^([0-9a-zA-Z\.\,\-\_:]*)($CLIENTID)(,([0-9a-zA-Z\.\,\-\_:\*]*))*$/ && defined ($2)) {
                                $remainder = $1 . $6;
                                $valtemp{"clientid"}=$2;
                            }
                            elsif ( $remainder && $remainder =~ /^(([0-9a-zA-Z\.\,\-\_:\[\]]*,[\h]*)*)($DUID)((,[\h]*([0-9a-zA-Z\.\,\-\_\:\[\]]*))*)$/ && defined ($3)) {
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
                                while ( $remainder && $remainder =~ /^([0-9a-zA-Z\.\,\-\_:\*]*)($MAC)(,([0-9a-zA-Z\.\,\-\_:\*]*))*$/ ) { # IPv4 only
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
                            if ( $remainder && $remainder =~ /^([0-9a-zA-Z\.\,\-\_:\*]*)($CLIENTID_NAME)(,([0-9a-zA-Z\.\,\-\_:\*]*))*$/ && defined ($2)) {
                                $remainder = $1 . ($5 ? $5 : "");
                                $valtemp{"clientid"} = $2;
                                if ($valtemp{"mac"} ne "") {
                                    $valtemp{"ignore-clientid"} = $valtemp{"clientid"};
                                    $valtemp{"clientid"} = "";
                                }
                            }
                            $valtemp{"ignore"} = 0;
                            if ( $remainder && $remainder =~ /^(([0-9a-zA-Z\.\,\-\_:\*]*)(,))*(ignore)$/  && defined ($4)) {
                                # ...time (optionally)
                                $remainder = $2;
                                $valtemp{"ignore"} = 1;
                            }
                            $valtemp{"ip"} = "";
                            $current = 0;
                            while ($remainder && $remainder =~ /^((?:[0-9a-zA-Z\,\-\_:]*)(?:,))*($IPADDR)(,([0-9a-zA-Z\.\,\-\_:]*))*$/ && defined ($2)) {
                                $remainder = ($1 ? $1 : "") . ($3 && $4 ? "," . $4 : "");
                                $valtemp{"ip"} = ($valtemp{"ip"} ? "," : "") . $2;
                                last if ($current++ >= $max_iterations);
                            }
                            if ($remainder && $remainder =~ /^(([0-9a-zA-Z\,\-\_\:]*\,\h*)*)(\[($IPV6ADDR)\])(,\h*[0-9a-zA-Z\.\-\_:]*)*\h*$/ && defined ($3)) { # IPv6
                                $remainder = $1 . (defined ($1) && defined ($5) ? "," . $5 : "");
                                $valtemp{"ip"} .= ($valtemp{"ip"} ? "," : "") . $3;
                            }
                            $valtemp{"hostname-used"} = 0;
                            if ($remainder && $remainder =~ /^([\h\,]*)($NAME)([\h\,]*)$/ ) {
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
                            while ($remainder && $remainder =~ /^($TAG)((,[\s]*)([0-9a-zA-Z\,\_\.:;\-\/\\ \'\"\=\[\]\#\(\)]*))*$/) {
                                my $tag  = $3;
                                push @{ $valtemp{"tag"} }, $tag;
                                $remainder = $6;
                                $remainder =~ s/^\s+|\s+$//g ;
                                last if ($current++ >= $max_iterations);
                            }
                            if ( $remainder && $remainder =~ /^(vendor:([a-zA-Z\-\_]*))((,[\s]*)([0-9a-zA-Z\,\_\.:;\-\/\\ \'\"\=\[\]\#\(\)]*))*$/) {
                                $valtemp{"vendor"} = $2;
                                $remainder = $5;
                                $remainder =~ s/^\s+|\s+$//g ;
                            }
                            if ( $remainder && $remainder =~ /^(encap:([0-9a-zA-Z\-\_]*))(([\s]*,[\s]*)([0-9a-zA-Z\,\_\.:;\-\/\\ \'\"\=\[\]\#\(\)]*))*$/) {
                                $valtemp{"encap"} = $2;
                                $remainder = $5;
                                $remainder =~ s/^\s+|\s+$//g ;
                            }
                            if ( $remainder && $remainder =~ /^(vi-encap:([0-9a-zA-Z\-\_]*))(([\s]*,[\s]*)([0-9a-zA-Z\,\_\.:;\-\/\\ \'\"\=\[\]\#\(\)]*))*$/) {
                                $valtemp{"vi-encap"} = $2;
                                $remainder = $5;
                                $remainder =~ s/^\s+|\s+$//g ;
                            }
                            # $OPTION = "option6?:([0-9a-zA-Z\-]*)|[0-9]{1,3}";
                            if ( $remainder && $remainder =~ /^($OPTION)(([\s]*,[\s]*)?([0-9a-zA-Z\,\_\.:;\-\/\\ \'\"\=\[\]\#\(\)]*))$/) {
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
                            while ( $remainder && $remainder =~ /^($TAG)((,[\s]*)([0-9a-zA-Z\,\_\.:;\-\/\\ \'\"\=\[\]\#\(\)]*))*$/) {
                                my $tag  = $3;
                                push @{ $valtemp{"tag"} }, $tag;
                                $remainder = $6;
                                $remainder =~ s/^\s+|\s+$//g ;
                                last if ($current++ >= $max_iterations);
                            }
                            if ( $remainder && $remainder =~ /^(vendor:([a-zA-Z\-\_]*))((,[\s]*)([0-9a-zA-Z\,\_\.:;\-\/\\ \'\"\=\[\]\#]*))*$/) {
                                $valtemp{"vendor"} = $2;
                                $remainder = $5;
                                $remainder =~ s/^\s+|\s+$//g ;
                            }
                            if ( $remainder && $remainder =~ /^(encap:([0-9a-zA-Z\-\_]*))(([\s]*,[\s]*)([0-9a-zA-Z\,\_\.:;\-\/\\ \'\"\=\[\]\#]*))*$/) {
                                $valtemp{"encap"} = $2;
                                $remainder = $5;
                                $remainder =~ s/^\s+|\s+$//g ;
                            }
                            if ( $remainder && $remainder =~ /^(vi-encap:([0-9a-zA-Z\-\_]*))(([\s]*,[\s]*)([0-9a-zA-Z\,\_\.:;\-\/\\ \'\"\=\[\]\#]*))*$/) {
                                $valtemp{"vi-encap"} = $2;
                                $remainder = $5;
                                $remainder =~ s/^\s+|\s+$//g ;
                            }
                            # $OPTION = "option6?:([0-9a-zA-Z\-]*)|[0-9]{1,3}";
                            if ( $remainder && $remainder =~ /^($OPTION)(([\s]*,[\s]*)?([0-9a-zA-Z\,\_\.:;\-\/\\ \'\"\=\[\]\#\(\)]*))$/) {
                                $valtemp{"option"} = (defined ($2) ? $2 : $1);
                                my $opt_id = $1;
                                my $val = $5;
                                $val =~ s/^\s+|\s+$//g ;
                                $valtemp{"value"} = $val;
                                $valtemp{"ipversion"} = $opt_id =~ /^option6/ ? 6 : 4;
                            }
                        }
                        when ("dhcp-relay") { # =<local address>,<server address>[,<interface]
                            if ( $remainder && $remainder =~ /^(.*)((?:,)(.*))$/ ) {
                                $valtemp{"local"} = $1;
                                $remainder = $3;
                            }
                            if ( $remainder && $remainder =~ /^(.*)((?:,)(.*))*$/ ) {
                                $valtemp{"server"} = $1;
                                if ( defined($3) ) {
                                    $valtemp{"interface"} = $3;
                                }
                            }
                        }
                        when ("dhcp-vendorclass") { # =set:<tag>,[enterprise:<IANA-enterprise number>,]<vendor-class>
                            if ( $remainder && $remainder =~ /^($TAG|([0-9a-zA-Z\_\.\-]*))\,([0-9a-zA-Z\,\.\-\:]*)$/ ) {
                                $valtemp{"tag"} = (defined ($4)) ? $4 : $3;
                                $valtemp{"vendorclass"} = $5;
                            }
                        }
                        when ("dhcp-userclass") { # =set:<tag>,<user-class>
                            if ( $remainder && $remainder =~ /^($TAG|([0-9a-zA-Z\_\.\-]*))\,([0-9a-zA-Z\,\.\-\:]*)$/ ) {
                                $valtemp{"tag"} = (defined ($4)) ? $4 : $3;
                                $valtemp{"userclass"} = $5;
                            }
                        }
                        when ("dhcp-mac") { # =set:<tag>,<MAC address>
                            if ( $remainder && $remainder =~ /^($TAG)\,($MAC)$/ ) {
                                $valtemp{"tag"} = $3;
                                $valtemp{"mac"} = $4;
                            }
                        }
                        when ("dhcp-circuitid") { # =set:<tag>,<circuit-id>
                            if ( $remainder && $remainder =~ /^($TAG|([0-9a-zA-Z\_\.\-]*))\,([0-9a-zA-Z\,\.\-\:]*)$/ ) {
                                $valtemp{"tag"} = (defined ($4)) ? $4 : $3;
                                $valtemp{"circuitid"} = $5;
                            }
                        }
                        when ("dhcp-remoteid") { # =set:<tag>,<remote-id>
                            if ( $remainder && $remainder =~ /^($TAG|([0-9a-zA-Z\_\.\-]*))\,([0-9a-zA-Z\,\.\-\:]*)$/ ) {
                                $valtemp{"tag"} = (defined ($4)) ? $4 : $3;
                                $valtemp{"remoteid"} = $5;
                            }
                        }
                        when ("dhcp-subscrid") { # =set:<tag>,<subscriber-id>
                            if ( $remainder && $remainder =~ /^($TAG|([0-9a-zA-Z\_\.\-]*))\,([0-9a-zA-Z\,\.\-\:]*)$/ ) {
                                $valtemp{"tag"} = (defined ($4)) ? $4 : $3;
                                $valtemp{"subscriberid"} = $5;
                            }
                        }
                        when ("dhcp-match") { # =set:<tag>,<option number>|option:<option name>|vi-encap:<enterprise>[,<value>]
                            if ( $remainder && $remainder =~ /^($TAG),(.*)$/ ) {
                                $valtemp{"tag"} = $3;
                                $remainder = $4;
                            }
                            if ( $remainder && $remainder =~ /^(vi-encap:([0-9a-zA-Z\-\_]*))(([\s]*,[\s]*)([0-9a-zA-Z\,\_\.:;\-\/\\ \'\"\=\[\]\#]*))*$/) {
                                $valtemp{"vi-encap"} = $2;
                                $remainder = $5;
                                $remainder =~ s/^\s+|\s+$//g ;
                            }
                            elsif ( $remainder && $remainder =~ /^($OPTION)(([\s]*,[\s]*)?([0-9a-zA-Z\,\_\.:;\-\/\\ \'\"\=\[\]\#]*))$/) {
                                $valtemp{"option"} = (defined ($2) ? $2 : $1);
                                $valtemp{"ipversion"} = $1 =~ /^option6/ ? 6 : 4;
                                $remainder = $5;
                                $remainder =~ s/^\s+|\s+$//g ;
                            }
                            my $dhcpmatchval = '';
                            if ( $remainder && $remainder =~ /^(\S+)$/) {
                                $dhcpmatchval = $1;
                                $dhcpmatchval =~ s/^\s+|\s+$//g ;
                                $valtemp{"value"} = $dhcpmatchval;
                            }
                        }
                        when ("dhcp-name-match") { # =set:<tag>,<name>[*]
                            if ( $remainder && $remainder =~ /^($TAG|([0-9a-zA-Z\_\.\-]*))\,([0-9a-zA-Z\,\.\-\:]*)$/ ) {
                                $valtemp{"tag"} = (defined ($4)) ? $4 : $3;
                                $valtemp{"name"} = $5;
                            }
                        }
                        when ("tag-if") { # =set:<tag>[,set:<tag>[,tag:<tag>[,tag:<tag>]]]
                            $current = 0;
                            while ( $remainder && $remainder =~ /^((set:)([0-9a-zA-Z\_\.\-!]*))\,([0-9a-zA-Z\,\.\-\:]*)$/ ) {
                                push( @{ $valtemp{"settag"} }, $3 );
                                $remainder = $4;
                                last if ($current++ >= $max_iterations);
                            }
                            $current = 0;
                            while ( $remainder && $remainder =~ /^((tag:)([0-9a-zA-Z\_\.\-!]*))\,([0-9a-zA-Z\,\.\-\:]*)$/ ) {
                                push( @{ $valtemp{"iftag"} }, $3 );
                                $remainder = $4;
                                last if ($current++ >= $max_iterations);
                            }
                        }
                        when ("dhcp-ignore") { # =tag:<tag>[,tag:<tag>]
                            $current = 0;
                            while ( $remainder && $remainder =~ /^((tag:)([0-9a-zA-Z\_\.\-!]*))\,([0-9a-zA-Z\,\.\-\:]*)$/ ) {
                                push( @{ $valtemp{"tag"} }, $3 );
                                $remainder = $4;
                                last if ($current++ >= $max_iterations);
                            }
                        }
                        when ("dhcp-ignore-names") { # [=tag:<tag>[,tag:<tag>]]
                            $current = 0;
                            while ( $remainder && $remainder =~ /^((tag:)([0-9a-zA-Z\_\.\-!]*))\,([0-9a-zA-Z\,\.\-\:]*)$/ ) {
                                push( @{ $valtemp{"tag"} }, $3 );
                                $remainder = $4;
                                last if ($current++ >= $max_iterations);
                            }
                        }
                        when ("dhcp-generate-names") { # =tag:<tag>[,tag:<tag>]
                            $current = 0;
                            while ( $remainder && $remainder =~ /^((tag:)([0-9a-zA-Z\_\.\-!]*))\,([0-9a-zA-Z\,\.\-\:]*)$/ ) {
                                push( @{ $valtemp{"tag"} }, $3 );
                                $remainder = $4;
                                last if ($current++ >= $max_iterations);
                            }
                        }
                        when ("dhcp-broadcast") { # [=tag:<tag>[,tag:<tag>]]
                            $current = 0;
                            while ( $remainder && $remainder =~ /^((tag:)([0-9a-zA-Z\_\.\-!]*))\,([0-9a-zA-Z\,\.\-\:]*)$/ ) {
                                push( @{ $valtemp{"tag"} }, $3 );
                                $remainder = $4;
                                last if ($current++ >= $max_iterations);
                            }
                        }
                        when ("dhcp-boot") { # =[tag:<tag>,]<filename>,[<servername>[,<server address>|<tftp_servername>]]
                            if ( $remainder && $remainder =~ /^($TAG),(.*)$/ ) {
                                $valtemp{"tag"} = $3;
                                $remainder = $4;
                            }
                            if ( $remainder && $remainder =~ /^([0-9a-zA-Z\.\-\_\/]+)\,(.*)$/ ) {
                                $valtemp{"filename"} = $1;
                                push ( @{ $dnsmconfig_ref->{"scripts"} }, $valtemp{"filename"}) if ($temp{"used"} && ! grep { $valtemp{"filename"} } ( @{ $dnsmconfig_ref->{"scripts"} } ));
                                $remainder = $2;
                            }
                            if ( $remainder && $remainder =~ /^($NAME)\,(.*)$/ ) {
                                $valtemp{"host"} = $1;
                                $valtemp{"address"} = $2;
                            }
                            else {
                                $valtemp{"host"} = $remainder;
                                $valtemp{"address"} = '';
                            }
                        }
                        when ("pxe-service") { # =[tag:<tag>,]<CSA>,<menu text>[,<basename>|<bootservicetype>][,<server address>|<server_name>]
                            if ( $remainder && $remainder =~ /^($TAG),(.*)$/ ) {
                                $valtemp{"tag"} = $3;
                                $remainder = $4;
                            }
                            if ( $remainder && $remainder =~ /^([0-9a-zA-Z\_\-]*),(.*)$/ ) {
                                $valtemp{"csa"} = $1;
                                $remainder = $2;
                            }
                            if ( $remainder && $remainder =~ /^(.*),(.*)$/ ) {
                                $valtemp{"menutext"} = $1;
                                $remainder = $2;
                                if ( $remainder && $remainder =~ /^(.*),(.*)$/ ) {
                                    $valtemp{"basename"} = $1;
                                    $valtemp{"server"} = $2;
                                    if ($valtemp{"basename"} =! /^[0-9]*$/ && $temp{"used"} && ! grep { $valtemp{"basename"} } ( @{ $dnsmconfig_ref->{"scripts"} } )) {
                                        push ( @{ $dnsmconfig_ref->{"scripts"} }, $valtemp{"basename"});
                                    }
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
                            if ( $remainder && $remainder =~ /^($TAG),(.*)$/ ) {
                                $valtemp{"tag"} = $3;
                                $remainder = $4;
                            }
                            if ( $remainder && $remainder =~ /^(.*)\,([0-9]{1,9})$/ ) {
                                $valtemp{"prompt"} = $1;
                                $valtemp{"timeout"} = $2;
                            }
                            else {
                                $valtemp{"prompt"} = $remainder;
                            }
                        }
                        when ("dhcp-alternate-port") { # [=<server port>[,<client port>]]
                            if ( $remainder && $remainder =~ /^(.*)((?:,)(.*))*$/ ) {
                                $valtemp{"serverport"} = $1;
                                if ( defined ($3) ) {
                                    $valtemp{"clientport"} = $3;
                                }
                            }
                        }
                        when ("dhcp-duid") { # =<enterprise-id>,<uid>
                            if ( $remainder && $remainder =~ /^(.*),(.*)$/ ) {
                                $valtemp{"enterpriseid"} = $1;
                                $valtemp{"uid"} = $2;
                            }
                        }
                        when ("bridge-interface") { # =<interface>,<alias>[,<alias>]
                            if ( $remainder && $remainder =~ /^(.*),(.*)$/ ) {
                                $valtemp{"interface"} = $1;
                                $remainder = $2;
                                $current = 0;
                                while ( $remainder && $remainder =~ /^(.*)((?:,)(.*))*$/ ) {
                                    push( @{ $valtemp{"alias"} }, $1 );
                                    $remainder = $3;
                                    last if ($current++ >= $max_iterations);
                                }
                            }
                        }
                        when ("shared-network") { # =<interface|addr>,<addr>
                            if ( $remainder && $remainder =~ /^(.*),(.*)$/ ) {
                                $valtemp{"interface"} = $1;
                                $valtemp{"addr"} = $2;
                            }
                        }
                        when ("domain") { # =<domain>[,<address range>[,local]]
                            if ( $remainder && $remainder =~ /^($NAME|\#)\,([0-9a-zA-Z\,\.\/]*)$/ ) {
                                $valtemp{"domain"} = $1;
                                $remainder = $2;
                                $valtemp{"range"} = '';
                                $valtemp{"local"} = 0;
                                if ( $remainder && $remainder =~ /^([0-9\.]*)\,([0-9\.]*)([0-9a-z\,\.\/]*)*$/ ) {
                                    # range = <ip address>,<ip address>
                                    $valtemp{"range"} = $1 . ',' . $2;
                                    if ( $remainder && $remainder =~ /,\s*local$/ ) {
                                        $valtemp{"local"} = 1;
                                    }
                                }
                                elsif ( $remainder && $remainder =~ /^(([0-9\,\.\/]*)\/(8|16|24))([0-9a-z\,\.\/]*)*$/ ) {
                                    # range = <ip address>/<netmask>
                                    $valtemp{"range"} = $1;
                                    if ( $remainder && $remainder =~ /,\s*local$/ ) {
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
                            if ( $remainder && $remainder =~ /^(.*)\,(.*)$/ ) {
                                $valtemp{"interface"} = $1;
                                $remainder = $2;
                                if ( $remainder && $remainder =~ /^((?:mtu:)(.*))((?:,)(.*))$/ ) {
                                    $valtemp{"mtu"} = $2;
                                    $remainder = $4;
                                }
                                if ( $remainder && $remainder =~ /^(high|low)((?:,)(.*))$/ ) {
                                    $valtemp{"priority"} = $1;
                                    $remainder = $3;
                                }
                                if ( $remainder && $remainder =~ /^(.*)((?:,)(.*))*$/ ) {
                                    $valtemp{"interval"} = $1;
                                    $valtemp{"lifetime"} = $3;
                                }
                                else {
                                    $valtemp{"interval"} = $remainder;
                                }
                            }
                        }
                        when ("dhcp-reply-delay") { # =[tag:<tag>,]<integer>
                            if ( $remainder && $remainder =~ /^($TAG),(.*)$/ ) {
                                $valtemp{"tag"} = $3;
                                $remainder = $4;
                            }
                            $valtemp{"delay"} = $remainder;
                        }
                        when ("tftp-root") { # =<directory>[,<interface>]
                            if ( $remainder && $remainder =~ /^(.*),(.*)$/ ) {
                                $valtemp{"directory"} = $1;
                                $valtemp{"interface"} = $2;
                            }
                            else {
                                $valtemp{"directory"} = $remainder;
                            }
                        }
                        when ("tftp-port-range") { # =<start>,<end>
                            if ( $remainder && $remainder =~ /^(.*),(.*)$/ ) {
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
                            if ( $remainder && $remainder =~ /^([a-zA-Z0-9\_\.\/]*)\,([a-zA-Z0-9\.*]*)/ ) {
                                $valtemp{"dirname"}=$1;
                                $remainder = $2;
                                $valtemp{"filter"} = "";
                                $valtemp{"exceptions"} = "";
                                if ( $remainder && $remainder =~ /^\*\.([a-zA-Z0-9\.]*)$/ ) { # Include all files in a directory which end in .*
                                    $filter = ".$1";
                                    $valtemp{"filter"} = "*$filter";
                                }
                                elsif ( $remainder && $remainder =~ /^[\.]([a-zA-Z0-9\.]*)$/ ) { # Include all the files in a directory except those ending in .*
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
                    my $cfg_idx = 0;
                    if (defined($dnsmconfig_ref->{"idx"}{"$configfield"})) {
                        $cfg_idx = $dnsmconfig_ref->{"idx"}{"$configfield"} + 1;
                    }
                    $dnsmconfig_ref->{"idx"}{"$configfield"} = $cfg_idx;
                    $temp{"cfg_idx"} = $cfg_idx;
                    push @{ $dnsmconfig_ref->{"$configfield"} }, { %temp };
                }
                else {
                    if ($dnsmconfig_ref->{"$configfield"}{"used"} == 0) {
                        $dnsmconfig_ref->{"$configfield"} = { %temp };
                    }
                }
                foreach my $set_tag ( @line_set_tags ) {
                    if (! grep { /^$set_tag$/ } ( @{ $dnsmconfig_ref->{"set_tags"} } ) ) {
                        # print "setting tag: $set_tag<br/>";
                        push( @{ $dnsmconfig_ref->{"set_tags"} }, $set_tag );
                    }
                    # print "setting tag: $set_tag<br/>";
                    # push( @{ $dnsmconfig_ref->{"set_tags"} }, $set_tag );
                }
            }
        }
    }
    if ($access{"edit_hosts"}) {
        if (! grep(/^\/etc\/hosts/, @{ $dnsmconfig_ref->{"configfiles"} } )) {
            push( @{ $dnsmconfig_ref->{"configfiles"} }, "/etc/hosts" );
        }
        foreach my $addn_hosts ( @{ $dnsmconfig_ref->{"addn-hosts"} }) {
            push( @{ $dnsmconfig_ref->{"configfiles"} }, $addn_hosts->{"val"} ) if ($addn_hosts->{"used"} && ! grep(/^$addn_hosts->{"val"}/, @{ $dnsmconfig_ref->{"configfiles"} } ));
        }
    }
    if ($is_extra_config == 0) { # everything should be read in by this point; validate processed values
        my $current_user = getlogin || getpwuid($<);
        my @usernames = &get_usernames_list();
        my @groupnames = &get_groupnames_list();
        my @iface_names = ();
        if (&foreign_available("net") && defined(net::active_interfaces)) {
            &foreign_require("net", "net-lib.pl");
            my @ifaces = net::active_interfaces();
            foreach my $i ( @ifaces ) {
                push( @iface_names, $i->{"fullname"});
            }
        }
        foreach my $configfield ( keys %dnsmconfigvals ) {
            if ( grep { /^$configfield$/ } ( @confarrs ) ) {
                foreach my $item ( @{$dnsmconfig_ref->{"$configfield"}} ) {
                    &validate_value($configfield, $item, $dnsmconfig_ref, $current_user, \@usernames, \@groupnames, \@iface_names);
                }
            }
            else {
                my $item = $dnsmconfig_ref->{"$configfield"};
                &validate_value($configfield, $item, $dnsmconfig_ref, $current_user, \@usernames, \@groupnames, \@iface_names);
            }
        }
    }
} #end of sub parse_config_file

sub validate_value {
    my ($configfield, $item, $dnsmconfig_ref, $current_user, $usernames, $groupnames, $iface_names) = @_;
    # webmin_debug_log("VALIDATE", ("configfield: $configfield -- item is " . ref($item) . " -- var_dump " . &var_dump( $item, 0 )));
    if ($item->{"used"}) {
        my $internalfield = &config_to_internal("$configfield");
        my $fdef = $configfield_fields{$internalfield};
        # webmin_debug_log("----VALIDATE", "configfield: $configfield");
        my $config_filename = $item->{"file"};
        my $lineno = $item->{"line"};
        my $cfg_idx = $item->{"cfg_idx"};
        foreach my $param ( @{$fdef->{"param_order"}} ) {
            my $pdef = \%{ $fdef->{"$param"} };
            my $val = ($param eq "val" ? $item->{"val"} : $item->{"val"}->{$param});
            if (defined($pdef->{"required"}) && $pdef->{"required"} == 1 && (!defined($val) || $val eq "")) {
                push(@{$dnsmconfig_ref->{"error"}}, &create_error($config_filename, $lineno, $text{"err_valreq"}, $configfield, $param, $cfg_idx));
            }
            elsif (defined($val) && $val ne "") {
                # int, file, path, dir, user, group, string, interface, ip, time
                my $type = $pdef->{"valtype"};
                if (defined($pdef->{"can_be"}) && $pdef->{"can_be"} ne "" && $val =~ /\// ) {
                    # if the value "can_be" a file/path/dir, and contains at least one '/' character, treat as file/path/dir for validation
                    $type = $pdef->{"can_be"};
                }
                # webmin_debug_log("--------FIELD0", "configfield: $configfield type: $type file: $config_filename line: $lineno param: $param val: $val");
                given ($type) {
                    when ("int") {
                        if (!&is_integer($val)) {
                            push(@{$dnsmconfig_ref->{"error"}}, &create_error($config_filename, $lineno, $text{"err_numbad"}, $configfield, $param, $cfg_idx));
                        }
                        else {
                            if (defined($pdef->{"max"}) && $val > $pdef->{"max"}) {
                                push(@{$dnsmconfig_ref->{"error"}}, &create_error($config_filename, $lineno, $text{"err_numhigh"} . "(>" . $pdef->{"max"} . ")", $configfield, $param, $cfg_idx));
                            }
                            elsif (defined($pdef->{"min"}) && $val < $pdef->{"min"}) {
                                push(@{$dnsmconfig_ref->{"error"}}, &create_error($config_filename, $lineno, $text{"err_numlow"} . "(<" . $pdef->{"min"} . ")", $configfield, $param, $cfg_idx));
                            }
                        }
                    }
                    when ("file") {
                        my $exists = (-e $val);
                        if (defined($pdef->{"must_exist"}) && $pdef->{"must_exist"} eq "1") {
                            if (! $exists || ! -f $val) {
                                $exists = 0; # if the target is not a file, there's no point in examining permissions
                                push(@{$dnsmconfig_ref->{"error"}}, &create_error($config_filename, $lineno, $text{"err_filebad_exist"}, $configfield, $param, $cfg_idx, $text{"err_filebad_exist"}));
                            }
                        }
                        if ($exists && defined($pdef->{"req_perms"})) {
                            my ($permcheck, $foruser, $forgroup);
                            if (($internalfield eq "dhcp_script" || $internalfield eq "dhcp_luascript") 
                                && ($dnsmconfig_ref->{"dhcp-scriptuser"} && $dnsmconfig_ref->{"dhcp-scriptuser"}->{"used"} == 1)) {
                                ($permcheck, $foruser, $forgroup) = &check_perms_sudo($pdef->{"req_perms"}, $val, $dnsmconfig_ref, $current_user, "dhcp-scriptuser");
                            }
                            else {
                                ($permcheck, $foruser, $forgroup) = &check_perms($pdef->{"req_perms"}, $val, $dnsmconfig_ref, $current_user, "user", "group");
                            }
                            if ($permcheck > 0) {
                                push(@{$dnsmconfig_ref->{"error"}}, &create_error($config_filename, $lineno, &text("err_filebad_perms_", $pdef->{"req_perms"}), $configfield, $param, $cfg_idx, &text("err_filebad_perms_", $pdef->{"req_perms"}), ERR_FILE_PERMS, $foruser, $forgroup, $permcheck));
                            }
                        }
                    }
                    when ("path") {
                        my $exists = (-e $val);
                        if (defined($pdef->{"must_exist"}) && $pdef->{"must_exist"} eq "1") {
                            if (! $exists || (! -f $val && ! -d $val)) {
                                $exists = 0; # if the target is not a file or directory, there's no point in examining permissions
                                push(@{$dnsmconfig_ref->{"error"}}, &create_error($config_filename, $lineno, $text{"err_pathbad_exist"}, $configfield, $param, $cfg_idx, $text{"err_pathbad_exist"}));
                            }
                        }
                        if ($exists && defined($pdef->{"req_perms"})) {
                            my ($permcheck, $foruser, $forgroup) = &check_perms($pdef->{"req_perms"}, $val, $dnsmconfig_ref, $current_user, "user", "group");
                            if ($permcheck > 0) {
                                push(@{$dnsmconfig_ref->{"error"}}, &create_error($config_filename, $lineno, &text("err_pathbad_perms_", $pdef->{"req_perms"}), $configfield, $param, $cfg_idx, &text("err_pathbad_perms_", $pdef->{"req_perms"}), ERR_FILE_PERMS, $foruser | $current_user, $forgroup, $permcheck));
                            }
                        }
                    }
                    when ("dir") {
                        my $exists = (-e $val);
                        if (defined($pdef->{"must_exist"}) && $pdef->{"must_exist"} eq "1") {
                            if (! $exists || ! -d $val) {
                                $exists = 0; # if the target is not a directory, there's no point in examining permissions
                                push(@{$dnsmconfig_ref->{"error"}}, &create_error($config_filename, $lineno, $text{"err_dirbad_exist"}, $configfield, $param, $cfg_idx, $text{"err_dirbad_exist"}));
                            }
                        }
                        if ($exists && defined($pdef->{"req_perms"})) {
                            my ($permcheck, $foruser, $forgroup) = &check_perms($pdef->{"req_perms"}, $val, $dnsmconfig_ref, $current_user, "user", "group");
                            if ($permcheck > 0) {
                                push(@{$dnsmconfig_ref->{"error"}}, &create_error($config_filename, $lineno, &text("err_dirbad_perms_", $pdef->{"req_perms"}), $configfield, $param, $cfg_idx, &text("err_dirbad_perms_", $pdef->{"req_perms"}), ERR_FILE_PERMS, $foruser, $forgroup, $permcheck));
                            }
                        }
                    }
                    when ("user") {
                        if (! grep { /^$val$/ } ( @{$usernames} )) {
                            push(@{$dnsmconfig_ref->{"error"}}, &create_error($config_filename, $lineno, $text{"err_userbad"}, $configfield, $param, $cfg_idx, $text{"err_userbad"}));
                        }
                    }
                    when ("group") {
                        if (! grep { /^$val$/ } ( @{$groupnames} )) {
                            push(@{$dnsmconfig_ref->{"error"}}, &create_error($config_filename, $lineno, $text{"err_groupbad"}, $configfield, $param, $cfg_idx, $text{"err_groupbad"}));
                        }
                    }
                    when ("interface") {
                        if (@{$iface_names}) {
                            if (! grep { /^$val$/ } ( @{$iface_names} )) {
                                push(@{$dnsmconfig_ref->{"error"}}, &create_error($config_filename, $lineno, $text{"err_ifacebad"}, $configfield, $param, $cfg_idx, $text{"err_ifacebad"}));
                            }
                        }
                    }
                    when ("ip") {
                        if (!(&check_ipaddress($val) || &check_ip6address($val))) {
                            push(@{$dnsmconfig_ref->{"error"}}, &create_error($config_filename, $lineno, $text{"err_ipbad"}, $configfield, $param, $cfg_idx));
                        }
                    }
                    when ("time") {
                        if ($val !~ /^($TIME)$/ ) {
                            push(@{$dnsmconfig_ref->{"error"}}, &create_error($config_filename, $lineno, $text{"err_timebad"}, $configfield, $param, $cfg_idx));
                        }
                    }
                    default {
                    }
                }
            }
        }
    }
}

sub check_perms_simple {
    my ($req_perms, $val) = @_;
    my $ret = 0;
    if ($req_perms =~ /read/ && ! -r $val) {
        $ret += 2;
    }
    if ($req_perms =~ /write/ && ! -w $val) {
        $ret += 4;
    }
    if ($req_perms =~ /execute/ && ! -x $val) {
        $ret += 1;
    }
    return $ret;
}

sub check_perms_sudo {
    my ($req_perms, $val, $dnsmconfig_ref, $current_user, $userconfigfield, $groupconfigfield) = @_;
    my $ret = 0;
    my $uname = "";
    my $gname = "";
    if ($current_user eq "root") {
        $uname = ($dnsmconfig_ref->{"$userconfigfield"} && $dnsmconfig_ref->{"$userconfigfield"}->{"used"} == 1) ? $dnsmconfig_ref->{"$userconfigfield"}->{"val"} : $current_user;
        $gname = ($groupconfigfield && $dnsmconfig_ref->{"$groupconfigfield"} && $dnsmconfig_ref->{"$groupconfigfield"}->{"used"} == 1) ? "-g " . $dnsmconfig_ref->{"$groupconfigfield"}->{"val"} : "";
        my $gparam = $gname ? "-g " . $gname : "";
        my $perms = qx(sudo -u $uname $gparam /bin/sh -c "/bin/bash -c "[ -r $val ] && printf r; [ -w $val ] && printf w; [ -x \$(realpath \"$val\") ] && printf x; echo");
        if ($req_perms =~ /read/ && $perms !~ /r/ ) {
            $ret += 2;
        }
        if ($req_perms =~ /write/ && $perms !~ /w/ ) {
            $ret += 3;
        }
        if ($req_perms =~ /execute/ && $perms !~ /x/ ) {
            $ret += 1;
        }
    }
    # if the current user is not root, but dnsmasq is configured to run as a different non-root user,
    # there's no easy way to check permissions on the file so give up validation
    return $ret, $uname, $gname;
}

sub check_perms {
    my ($req_perms, $val, $dnsmconfig_ref, $current_user, $userconfigfield, $groupconfigfield) = @_;
    if (($dnsmconfig_ref->{"$userconfigfield"} && $dnsmconfig_ref->{"$userconfigfield"}->{"used"} == 1)
     || ($groupconfigfield && $dnsmconfig_ref->{"$groupconfigfield"} && $dnsmconfig_ref->{"$groupconfigfield"}->{"used"} == 1)) {
        return &check_perms_sudo($req_perms, $val, $dnsmconfig_ref, $current_user, $userconfigfield, $groupconfigfield);
    }
    else {
        return &check_perms_simple($req_perms, $val);
    }
}

1;
