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

our %dnsmconfigvals = (
    "port"                  => { "valtype" => "int",     "arr" => 0, "mult" => "", "special" => 0, "default" => 53 }, # =<port>
    "domain-needed"         => { "valtype" => "bool",    "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "bogus-priv"            => { "valtype" => "bool",    "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "dnssec"                => { "valtype" => "bool",    "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "dnssec-check-unsigned" => { "valtype" => "string",  "arr" => 0, "mult" => "", "special" => 1, "default" => 1 }, # [=no]
    "filterwin2k"           => { "valtype" => "bool",    "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "resolv-file"           => { "valtype" => "file",    "arr" => 0, "mult" => "", "special" => 0, "default" => "/etc/resolv.conf" }, # =<file>
    "strict-order"          => { "valtype" => "bool",    "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "no-resolv"             => { "valtype" => "bool",    "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "no-poll"               => { "valtype" => "bool",    "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "local"                 => { "valtype" => "var",     "arr" => 0, "mult" => "", "special" => 1 }, # =[/[<domain>]/[domain/]][<ipaddr>[#<port>]][@<interface>][@<source-ip>[#<port>]]
    "server"                => { "valtype" => "var",     "arr" => 0, "mult" => "", "special" => 1 }, # TODO; equivalent to "local" # =[/[<domain>]/[domain/]][<ipaddr>[#<port>]][@<interface>][@<source-ip>[#<port>]]
    "address"               => { "valtype" => "var",     "arr" => 0, "mult" => "", "special" => 0 }, # =/<domain>[/<domain>...]/[<ipaddr>]
    "ipset"                 => { "valtype" => "var",     "arr" => 0, "mult" => "", "special" => 1 }, # =/<domain>[/<domain>...]/<ipset>[,<ipset>...]
    "user"                  => { "valtype" => "string",  "arr" => 0, "mult" => "", "special" => 0, "default" => "nobody" }, # =<username>
    "group"                 => { "valtype" => "string",  "arr" => 0, "mult" => "", "special" => 0, "default" => "dip" }, # =<groupname>
    "interface"             => { "valtype" => "string",  "arr" => 1, "mult" => "", "special" => 0 }, # =<interface name>
    "except-interface"      => { "valtype" => "string",  "arr" => 1, "mult" => "", "special" => 0 }, # =<interface name>
    "listen-address"        => { "valtype" => "string",  "arr" => 1, "mult" => "", "special" => 0 }, # =<ipaddr>
    "no-dhcp-interface"     => { "valtype" => "string",  "arr" => 1, "mult" => "", "special" => 0 }, # =<interface name>
    "bind-interfaces"       => { "valtype" => "bool",    "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "no-hosts"              => { "valtype" => "bool",    "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "addn-hosts"            => { "valtype" => "path",    "arr" => 1, "mult" => "", "special" => 0 }, # =<file>
    "expand-hosts"          => { "valtype" => "bool",    "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "domain"                => { "valtype" => "var",     "arr" => 1, "mult" => "", "special" => 0 }, # TODO # =<domain>[,<address range>[,local]]
    "dhcp-range"            => { "valtype" => "var",     "arr" => 1, "mult" => "", "special" => 0 }, # =[tag:<tag>[,tag:<tag>],][set:<tag>,]<start-addr>[,<end-addr>|<mode>][,<netmask>[,<broadcast>]][,<lease time>] -OR- =[tag:<tag>[,tag:<tag>],][set:<tag>,]<start-IPv6addr>[,<end-IPv6addr>|constructor:<interface>][,<mode>][,<prefix-len>][,<lease time>]
    "dhcp-host"             => { "valtype" => "var",     "arr" => 1, "mult" => "", "special" => 0 }, # =[<hwaddr>][,id:<client_id>|*][,set:<tag>][tag:<tag>][,<ipaddr>][,<hostname>][,<lease_time>][,ignore]
    "enable-ra"             => { "valtype" => "bool",    "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "dhcp-ignore"           => { "valtype" => "var",     "arr" => 0, "mult" => "", "special" => 0 }, # =tag:<tag>[,tag:<tag>]
    "dhcp-vendorclass"      => { "valtype" => "var",     "arr" => 0, "mult" => "", "special" => 0 }, # =set:<tag>,[enterprise:<IANA-enterprise number>,]<vendor-class>
    "dhcp-userclass"        => { "valtype" => "var",     "arr" => 0, "mult" => "", "special" => 0 }, # =set:<tag>,<user-class>
    "dhcp-mac"              => { "valtype" => "var",     "arr" => 0, "mult" => "", "special" => 0 }, # =set:<tag>,<MAC address>
    "read-ethers"           => { "valtype" => "bool",    "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "dhcp-option"           => { "valtype" => "var",     "arr" => 1, "mult" => "", "special" => 0 }, # =[tag:<tag>,[tag:<tag>,]][encap:<opt>,][vi-encap:<enterprise>,][vendor:[<vendor-class>],][<opt>|option:<opt-name>|option6:<opt>|option6:<opt-name>],[<value>[,<value>]]
    "dhcp-option-force"     => { "valtype" => "var",     "arr" => 1, "mult" => "", "special" => 0 }, # TODO # =[tag:<tag>,[tag:<tag>,]][encap:<opt>,][vi-encap:<enterprise>,][vendor:[<vendor-class>],][<opt>|option:<opt-name>|option6:<opt>|option6:<opt-name>],[<value>[,<value>]]
    "dhcp-boot"             => { "valtype" => "var",     "arr" => 0, "mult" => "", "special" => 0 }, # =[tag:<tag>,]<filename>,[<servername>[,<server address>|<tftp_servername>]]
    "dhcp-match"            => { "valtype" => "var",     "arr" => 0, "mult" => "", "special" => 0 }, # =set:<tag>,<option number>|option:<option name>|vi-encap:<enterprise>[,<value>]
    "pxe-prompt"            => { "valtype" => "var",     "arr" => 0, "mult" => "", "special" => 0 }, # =[tag:<tag>,]<prompt>[,<timeout>]
    "pxe-service"           => { "valtype" => "var",     "arr" => 0, "mult" => "", "special" => 0 }, # =[tag:<tag>,]<CSA>,<menu text>[,<basename>|<bootservicetype>][,<server address>|<server_name>]
    "enable-tftp"           => { "valtype" => "string",  "arr" => 0, "mult" => "", "special" => 0 }, # [=<interface>[,<interface>]]
    "tftp-root"             => { "valtype" => "var",     "arr" => 0, "mult" => "", "special" => 0 }, # =<directory>[,<interface>]
    "tftp-no-fail"          => { "valtype" => "bool",    "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "tftp-secure"           => { "valtype" => "bool",    "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "tftp-no-blocksize"     => { "valtype" => "bool",    "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "dhcp-lease-max"        => { "valtype" => "int",     "arr" => 0, "mult" => "", "special" => 0, "default" => 1000 }, # =<number>
    "dhcp-leasefile"        => { "valtype" => "file",    "arr" => 0, "mult" => "", "special" => 0 }, # =<path>
    "dhcp-authoritative"    => { "valtype" => "bool",    "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "dhcp-script"           => { "valtype" => "file",    "arr" => 0, "mult" => "", "special" => 0 }, # =<path>
    "cache-size"            => { "valtype" => "int",     "arr" => 0, "mult" => "", "special" => 0, "default" => 150 }, # =<cachesize>
    "no-negcache"           => { "valtype" => "bool",    "arr" => 0, "mult" => "", "special" => 0, "default" => 0 }, # previously !neg_cache
    "local-ttl"             => { "valtype" => "int",     "arr" => 0, "mult" => "", "special" => 0, "default" => 0 }, # =<time>
    "bogus-nxdomain"        => { "valtype" => "var",     "arr" => 1, "mult" => "", "special" => 0 }, # =<ipaddr>[/prefix]
    "alias"                 => { "valtype" => "var",     "arr" => 0, "mult" => "", "special" => 0 }, # =[<old-ip>]|[<start-ip>-<end-ip>],<new-ip>[,<mask>] # previously "dns_forced"?
    "mx-host"               => { "valtype" => "var",     "arr" => 0, "mult" => "", "special" => 0 }, # =<mx name>[[,<hostname>],<preference>]
    "mx-target"             => { "valtype" => "string",  "arr" => 0, "mult" => "", "special" => 0 }, # =<hostname>
    "localmx"               => { "valtype" => "bool",    "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "selfmx"                => { "valtype" => "bool",    "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "srv-host"              => { "valtype" => "var",     "arr" => 0, "mult" => "", "special" => 0 }, # =<_service>.<_prot>.[<domain>],[<target>[,<port>[,<priority>[,<weight>]]]]
    "ptr-record"            => { "valtype" => "var",     "arr" => 0, "mult" => "", "special" => 0 }, # =<name>[,<target>]
    "txt-record"            => { "valtype" => "var",     "arr" => 0, "mult" => "", "special" => 0 }, # =<name>[[,<text>],<text>]
    "cname"                 => { "valtype" => "var",     "arr" => 0, "mult" => "", "special" => 0 }, # =<cname>,[<cname>,]<target>[,<TTL>]
    "log-queries"           => { "valtype" => "bool",    "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "log-dhcp"              => { "valtype" => "bool",    "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "log-facility"          => { "valtype" => "string",  "arr" => 0, "mult" => "", "special" => 0 }, # =<facility>
    "conf-file"             => { "valtype" => "path",    "arr" => 1, "mult" => "", "special" => 0 }, # =<file>
    "conf-dir"              => { "valtype" => "var",     "arr" => 1, "mult" => "", "special" => 0 }, # =<directory>[,<file-extension>......],
    "dhcp-name-match"       => { "valtype" => "var",     "arr" => 0, "mult" => "", "special" => 0 }, # =set:<tag>,<name>[*]
    "dhcp-ignore-names"     => { "valtype" => "var",     "arr" => 0, "mult" => "", "special" => 0 }, # [=tag:<tag>[,tag:<tag>]]
    "hostsdir"              => { "valtype" => "dir",     "arr" => 0, "mult" => "", "special" => 0 }, # =<path>
    "dhcp-ttl"              => { "valtype" => "int",     "arr" => 0, "mult" => "", "special" => 0, "default" => 0 }, # =<time>
    "neg-ttl"               => { "valtype" => "int",     "arr" => 0, "mult" => "", "special" => 0, "default" => 0 }, # =<time>
    "max-ttl"               => { "valtype" => "int",     "arr" => 0, "mult" => "", "special" => 0, "default" => 0 }, # =<time>
    "max-cache-ttl"         => { "valtype" => "int",     "arr" => 0, "mult" => "", "special" => 0, "default" => 0 }, # =<time>
    "min-cache-ttl"         => { "valtype" => "int",     "arr" => 0, "mult" => "", "special" => 0, "default" => 0 }, # =<time>
    "auth-ttl"              => { "valtype" => "int",     "arr" => 0, "mult" => "", "special" => 0, "default" => 0 }, # =<time>
    "log-debug"             => { "valtype" => "bool",    "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "log-async"             => { "valtype" => "int",     "arr" => 0, "mult" => "", "special" => 0, "default" => 5 }, # [=<lines>]
    "pid-file"              => { "valtype" => "file",    "arr" => 0, "mult" => "", "special" => 0 }, # =<path>
    "edns-packet-max"       => { "valtype" => "int",     "arr" => 0, "mult" => "", "special" => 0, "default" => 4096 }, # =<size>
    "query-port"            => { "valtype" => "int",     "arr" => 0, "mult" => "", "special" => 0 }, # =<query_port>
    "min-port"              => { "valtype" => "int",     "arr" => 0, "mult" => "", "special" => 0, "default" => 1024 }, # =<port>
    "max-port"              => { "valtype" => "int",     "arr" => 0, "mult" => "", "special" => 0 }, # =<port>
    "auth-server"           => { "valtype" => "var",     "arr" => 0, "mult" => "", "special" => 0 }, # =<domain>,[<interface>|<ip-address>...]
    "local-service"         => { "valtype" => "bool",    "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "bind-dynamic"          => { "valtype" => "bool",    "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "localise-queries"      => { "valtype" => "bool",    "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "ignore-address"        => { "valtype" => "var",     "arr" => 0, "mult" => "", "special" => 0 }, # =<ipaddr>[/prefix]
    "enable-dbus"           => { "valtype" => "string",  "arr" => 0, "mult" => "", "special" => 0, "default" => "uk.org.thekelleys.dnsmasq" }, # [=<service-name>]
    "enable-ubus"           => { "valtype" => "string",  "arr" => 0, "mult" => "", "special" => 0, "default" => "dnsmasq" }, # [=<service-name>]
    "all-servers"           => { "valtype" => "bool",    "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "dns-loop-detect"       => { "valtype" => "bool",    "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "stop-dns-rebind"       => { "valtype" => "bool",    "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "rebind-localhost-ok"   => { "valtype" => "bool",    "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "rebind-domain-ok"      => { "valtype" => "string",  "arr" => 0, "mult" => "/", "special" => 0 }, # =[<domain>]|[[/<domain>/[<domain>/]
    "clear-on-reload"       => { "valtype" => "bool",    "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "rev-server"            => { "valtype" => "var",     "arr" => 0, "mult" => "", "special" => 0 }, # =<ip-address>/<prefix-len>[,<ipaddr>][#<port>][@<interface>][@<source-ip>[#<port>]]
    "host-record"           => { "valtype" => "var",     "arr" => 0, "mult" => "", "special" => 0 }, # =<name>[,<name>....],[<IPv4-address>],[<IPv6-address>][,<TTL>]
    "dynamic-host"          => { "valtype" => "var",     "arr" => 0, "mult" => "", "special" => 0 }, # =<name>,[IPv4-address],[IPv6-address],<interface>
    "naptr-record"          => { "valtype" => "var",     "arr" => 0, "mult" => "", "special" => 0 }, # =<name>,<order>,<preference>,<flags>,<service>,<regexp>[,<replacement>]
    "caa-record"            => { "valtype" => "var",     "arr" => 0, "mult" => "", "special" => 0 }, # =<name>,<flags>,<tag>,<value>
    "cname"                 => { "valtype" => "var",     "arr" => 0, "mult" => "", "special" => 0 }, # =<cname>,[<cname>,]<target>[,<TTL>]
    "dns-rr"                => { "valtype" => "var",     "arr" => 0, "mult" => "", "special" => 0 }, # =<name>,<RR-number>,[<hex data>]
    "interface-name"        => { "valtype" => "var",     "arr" => 0, "mult" => "", "special" => 0 }, # =<name>,<interface>[/4|/6]
    "synth-domain"          => { "valtype" => "var",     "arr" => 0, "mult" => "", "special" => 0 }, # =<domain>,<address range>[,<prefix>[*]]
    "dumpfile"              => { "valtype" => "file",    "arr" => 0, "mult" => "", "special" => 0 }, # =<path/to/file>
    "dumpmask"              => { "valtype" => "string",  "arr" => 0, "mult" => "", "special" => 0 }, # =<mask>
    "add-mac"               => { "valtype" => "string",  "arr" => 0, "mult" => "", "special" => 0 }, # [=base64|text]
    "add-cpe-id"            => { "valtype" => "string",  "arr" => 0, "mult" => "", "special" => 0 }, # =<string>
    "add-subnet"            => { "valtype" => "var",     "arr" => 0, "mult" => "", "special" => 0 }, # [[=[<IPv4 address>/]<IPv4 prefix length>][,[<IPv6 address>/]<IPv6 prefix length>]]
    "dns-forward-max"       => { "valtype" => "int",     "arr" => 0, "mult" => "", "special" => 0, "default" => 150 }, # =<queries>
    "trust-anchor"          => { "valtype" => "var",     "arr" => 0, "mult" => "", "special" => 0 }, # =[<class>],<domain>,<key-tag>,<algorithm>,<digest-type>,<digest>
    "dnssec-no-timecheck"   => { "valtype" => "bool",    "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "dnssec-timestamp"      => { "valtype" => "file",    "arr" => 0, "mult" => "", "special" => 0 }, # =<path>
    "proxy-dnssec"          => { "valtype" => "bool",    "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "dnssec-debug"          => { "valtype" => "bool",    "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "auth-zone"             => { "valtype" => "var",     "arr" => 0, "mult" => "", "special" => 0 }, # =<domain>[,<subnet>[/<prefix length>][,<subnet>[/<prefix length>].....][,exclude:<subnet>[/<prefix length>]].....]
    "auth-soa"              => { "valtype" => "var",     "arr" => 0, "mult" => "", "special" => 0 }, # =<serial>[,<hostmaster>[,<refresh>[,<retry>[,<expiry>]]]]
    "auth-sec-servers"      => { "valtype" => "string",  "arr" => 0, "mult" => "", "special" => 0 }, # =<domain>[,<domain>[,<domain>...]]
    "auth-peer"             => { "valtype" => "var",     "arr" => 0, "mult" => "", "special" => 0 }, # =<ip-address>[,<ip-address>[,<ip-address>...]]
    "conntrack"             => { "valtype" => "bool",    "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "dhcp-hostsfile"        => { "valtype" => "path",    "arr" => 0, "mult" => "", "special" => 0 }, # =<path>
    "dhcp-optsfile"         => { "valtype" => "path",    "arr" => 0, "mult" => "", "special" => 0 }, # =<path>
    "dhcp-hostsdir"         => { "valtype" => "dir",     "arr" => 0, "mult" => "", "special" => 0 }, # =<path>
    "dhcp-optsdir"          => { "valtype" => "dir",     "arr" => 0, "mult" => "", "special" => 0 }, # =<path>
    "dhcp-no-override"      => { "valtype" => "bool",    "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "dhcp-relay"            => { "valtype" => "var",     "arr" => 0, "mult" => "", "special" => 0 }, # =<local address>,<server address>[,<interface]
    "dhcp-circuitid"        => { "valtype" => "var",     "arr" => 0, "mult" => "", "special" => 0 }, # =set:<tag>,<circuit-id>
    "dhcp-remoteid"         => { "valtype" => "var",     "arr" => 0, "mult" => "", "special" => 0 }, # =set:<tag>,<remote-id>
    "dhcp-subscrid"         => { "valtype" => "var",     "arr" => 0, "mult" => "", "special" => 0 }, # =set:<tag>,<subscriber-id>
    "dhcp-proxy"            => { "valtype" => "string",  "arr" => 0, "mult" => "", "special" => 0 }, # [=<ip addr>]......
    "tag-if"                => { "valtype" => "var",     "arr" => 0, "mult" => "", "special" => 0 }, # =set:<tag>[,set:<tag>[,tag:<tag>[,tag:<tag>]]]
    "dhcp-generate-names"   => { "valtype" => "var",     "arr" => 0, "mult" => "", "special" => 0 }, # =tag:<tag>[,tag:<tag>]
    "dhcp-broadcast"        => { "valtype" => "var",     "arr" => 0, "mult" => "", "special" => 0 }, # [=tag:<tag>[,tag:<tag>]]
    "dhcp-sequential-ip"    => { "valtype" => "bool",    "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "dhcp-ignore-clid"      => { "valtype" => "bool",    "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "dhcp-pxe-vendor"       => { "valtype" => "string",  "arr" => 0, "mult" => "", "special" => 0 }, # =<vendor>[,...]
    "dhcp-rapid-commit"     => { "valtype" => "bool",    "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "dhcp-alternate-port"   => { "valtype" => "var",     "arr" => 0, "mult" => "", "special" => 0 }, # [=<server port>[,<client port>]]
    "bootp-dynamic"         => { "valtype" => "string",  "arr" => 1, "mult" => "", "special" => 0 }, # [=<network-id>[,<network-id>]]
    "no-ping"               => { "valtype" => "bool",    "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "quiet-dhcp"            => { "valtype" => "bool",    "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "quiet-dhcp6"           => { "valtype" => "bool",    "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "quiet-ra"              => { "valtype" => "bool",    "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "dhcp-duid"             => { "valtype" => "var",     "arr" => 0, "mult" => "", "special" => 0 }, # =<enterprise-id>,<uid>
    "dhcp-luascript"        => { "valtype" => "file",    "arr" => 0, "mult" => "", "special" => 0 }, # =<path>
    "dhcp-scriptuser"       => { "valtype" => "string",  "arr" => 0, "mult" => "", "special" => 0, "default" => "root" }, # =<username>
    "script-arp"            => { "valtype" => "bool",    "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "leasefile-ro"          => { "valtype" => "bool",    "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "script-on-renewal"     => { "valtype" => "bool",    "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "bridge-interface"      => { "valtype" => "var",     "arr" => 0, "mult" => "", "special" => 0 }, # =<interface>,<alias>[,<alias>]
    "shared-network"        => { "valtype" => "var",     "arr" => 0, "mult" => "", "special" => 0 }, # =<interface|addr>,<addr>
    "dhcp-fqdn"             => { "valtype" => "bool",    "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "dhcp-client-update"    => { "valtype" => "bool",    "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "ra-param"              => { "valtype" => "var",     "arr" => 0, "mult" => "", "special" => 0 }, # =<interface>,[mtu:<integer>|<interface>|off,][high,|low,]<ra-interval>[,<router lifetime>]
    "dhcp-reply-delay"      => { "valtype" => "var",     "arr" => 0, "mult" => "", "special" => 0 }, # =[tag:<tag>,]<integer>
    "tftp-unique-root"      => { "valtype" => "string",  "arr" => 0, "mult" => "", "special" => 0 }, # [=ip|mac]
    "tftp-lowercase"        => { "valtype" => "bool",    "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "tftp-max"              => { "valtype" => "int",     "arr" => 0, "mult" => "", "special" => 0 }, # =<connections>
    "tftp-mtu"              => { "valtype" => "int",     "arr" => 0, "mult" => "", "special" => 0 }, # =<mtu size>
    "tftp-port-range"       => { "valtype" => "var",     "arr" => 0, "mult" => "", "special" => 0 }, # =<start>,<end>
    "tftp-single-port"      => { "valtype" => "bool",    "arr" => 0, "mult" => "", "special" => 0, "default" => 0 },
    "servers-file"          => { "valtype" => "file",    "arr" => 1, "mult" => "", "special" => 0 }, # =<file>
);
#
# parse the configuration file and populate the %dnsmconfig structure
# 
sub parse_config_file {
    my $lineno;
    my ($dnsmconfig, $config_file, $config_filename) = @_;
    my @confbools = ( ); # options which may not contain any parameters/values
    my @confsingles = ( ); # options which may contain no more than one parameter/value
    my @confarrs = ( ); # options which may be specified more than once

    my $key;
    my $vals;
    print "<!--";
    while ( ($key, $vals) = each %dnsmconfigvals ) {
        print "$key: " . $vals->{valtype}; # it literally doesn't run without this *print* statement. WTF perl?!?!
        if ( $vals->{valtype} eq "bool" ) {
            push( @confbools, $key );
        }
        if ( $vals->{valtype} ne "var" ) {
            push( @confsingles, $key );
        }
        if ( $vals->{arr} == 1 ) {
            push( @confarrs, $key );
        }
    }
    print "-->";

    # foreach my $bool ( @confbools ) {
    #     print $bool . " -- ";
    # }
    # print Dumper \%dnsmconfigvals;
    my $IPADDR = "((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])";
    # $IPV6ADDR = "([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])";
    my $IPV6ADDR = "[0-9a-fA-F\:]*";
    my $NAME = "[a-zA-Z\_\.][0-9a-zA-Z\_\.\-]*";
    my $MAC = "([0-9a-fA-F]{2})([:-]([0-9a-fA-F]{2}|\\*)){5}";
    my $INFINIBAND = "id:[fF]{2}:00:00:00:00:00:02:00:00:02:[cC]9:00:([0-9a-fA-F]{2}[:-]){7}([0-9a-fA-F]{2})";
    my $CLIENTID = "id:([0-9a-fA-F]{2}[:-]){3}([0-9a-fA-F]{2})";
    my $CLIENTID_NAME = "id:([0-9a-zA-Z\-\_\*]*)";
    # my $DUID = "([0-9a-fA-F]{4}[:]{2}){1}([:][0-9a-fA-F]{4}){1,31}";
    my $DUID = "id([:-][0-9a-fA-F]{2}){5,128}";
    my $TIME = "[0-9]{1,3}[mh]";
    my $FILE = "[0-9a-zA-Z\_\-\.\/]+";
    my $NUMBER="[0-9]+";
    my $TAG = "(set|tag):([0-9a-zA-Z\_\.\-]*)";
    my $IPV6PROP = "ra-only|ra-names|ra-stateless|slaac";
    my $OPTION = "option6?:([0-9a-zA-Z\-]*)|[0-9]{1,3}";

    $lineno=0;
    foreach my $line (@$$config_file) {
        my $remainder;
        my %temp;
        my $found = 0;
        
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
                if ($line =~ /(^[\#]*[\s]*$b)/ ) {
                    if ($$dnsmconfig{$b}{"used"} == 0) { # only overwrite if the last value read is not used (commented)
                        $$dnsmconfig{$b}{"used"}=($line!~/^\#/);
                        $$dnsmconfig{$b}{"line"}=$lineno;
                        $$dnsmconfig{$b}{"file"}=$config_filename;
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
                $temp{"used"}=($line !~ /^\#/);
                $temp{"line"}=$lineno;
                $temp{"file"}=$config_filename;
                if ( ! grep { /^$option$/ } ( keys %dnsmconfigvals ) ) {
                    print "Error in line $lineno ($option: unknown option)! ";
                    $$dnsmconfig{"errors"}++;
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
                    if ($option eq "local") {
                        $option = "server";
                    }
                    given ( "$option" ){
                        when ("server") { #TODO
                            if ( $remainder =~ /\/($NAME)\/($IPADDR)/ ) {
                                $valtemp{"domain"}=$1;
                                $valtemp{"domain-used"}=1;
                                $valtemp{"address"}=$2;
                            }
                            elsif ( $remainder =~ /\/($NAME)\/($IPV6ADDR)/ ) {
                                $valtemp{"domain"}=$1;
                                $valtemp{"domain-used"}=1;
                                $valtemp{"address"}=$2;
                            }
                            elsif ( $remainder =~ /($IPADDR)/ ) {
                                $valtemp{"domain"}="";
                                $valtemp{"domain-used"}=0;
                                $valtemp{"address"}=$1;
                            }
                        }
                        when ("dhcp-range") {
                            if ($remainder =~ /^($TAG)\,([0-9a-zA-Z\.\,\-\_: ]*)/ ) { # first get tag
                                my $tag = $1;
                                $remainder = $4;
                                if ($tag =~ /^(set|tag):([0-9a-zA-Z\-\_]*)/) {
                                    $valtemp{"tag-set"}=($1 eq "set");
                                    $valtemp{"tag-depends"}=($1 eq "tag");
                                    $valtemp{"tagname"}=$2;
                                }
                            }
                            $valtemp{"ipversion"} = 4;
                            if ($remainder =~ /^($IPADDR)\,([0-9a-zA-Z\.\,\-\_]*)/ ) { # IPv4
                                # ...start...
                                $valtemp{"start"} = $1;
                                $remainder = $7;
                                if ($remainder =~ /^($IPADDR)\,([0-9a-zA-Z\.\,\-\_]*)/ ) {
                                    # ...end...
                                    $valtemp{"end"} = $1;
                                    $remainder = $7;
                                }
                                $valtemp{"mask"}="";
                                $valtemp{"mask-used"}=0;
                                if ($remainder =~ /^($IPADDR)\,([0-9a-zA-Z\.\,\-\_]*)/ ) {
                                    # ...netmask, time (optionally)
                                    $valtemp{"mask"} = $1;
                                    $valtemp{"mask-used"}=1;
                                    $remainder = $7;
                                }
                                if ($remainder =~ /^(static)\,([0-9a-zA-Z\.\,\-\_]*)/ ) {
                                    $valtemp{"static"} = $1;
                                    $remainder = $2;
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
                                $$dnsmconfig{"errors"}++;
                            }
                        }
                        when ("dhcp-host") {
                            $valtemp{"full"} = $remainder; # TODO - remove after debugging
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
                                    $remainder = $1 . $7;
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
                            if ($remainder =~ /^(([0-9a-zA-Z\,\-\_:]*)(,))*($IPADDR)(,([0-9a-zA-Z\.\,\-\_:]*))*$/ && defined ($4)) {
                                $remainder = $2 . (defined ($2) && defined ($10) ? "," . $10 : "");
                                $valtemp{"ip"} = $4;
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
                        when ("domain") {
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
                                    $valtemp{"range"}=$remainder;
                                }
                            }
                            else {
                                $valtemp{"domain"}=$remainder;
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
                                &parse_config_file( \%$dnsmconfig, \$supp_config_file, \$supp_config_filename );
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
                                    &parse_config_file( \%$dnsmconfig, \$supp_config_file, \$supp_config_filename );
                                }
                            }
                        }
                        when ("dhcp-option") {
                            # too many to classify - all values as string!
                            $remainder =~ s/^\s+|\s+$//g ;
                            $valtemp{"forced"} = 0;
                            # $TAG = "(set|tag):([0-9a-zA-Z\_\.\-]*)";
                            if ($remainder =~ /^($TAG)((,[\s]*)([0-9a-zA-Z\,\_\.:;\-\/\\ \'\"\=\[\]\#]*))*$/) {
                                $valtemp{"tag"} = $3;
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
                            if ($remainder =~ /^($OPTION)(([\s]*,[\s]*)?([0-9a-zA-Z\,\_\.:;\-\/\\ \'\"\=\[\]\#]*))$/) {
                                $valtemp{"option"} = (defined ($2) ? $2 : $1);
                                my $val = $5;
                                $val =~ s/^\s+|\s+$//g ;
                                $valtemp{"value"} = $val;
                                $valtemp{"ipversion"} = $1 =~ /^option6/ ? 6 : 4;
                            }
                        }
                        when ("dhcp-option-force") {
                            $option = "dhcp-option";
                            # too many to classify - all values as string!
                            $valtemp{"forced"} = 1;
                            $remainder =~ s/^\s+|\s+$//g ;
                            # $TAG = "(set|tag):([0-9a-zA-Z\_\.\-]*)";
                            if ($remainder =~ /^($TAG)((,[\s]*)([0-9a-zA-Z\,\_\.:;\-\/\\ \'\"\=\[\]\#]*))*$/) {
                                $valtemp{"tag"} = $3;
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
                            if ($remainder =~ /^($OPTION)(([\s]*,[\s]*)?([0-9a-zA-Z\,\_\.:;\-\/\\ \'\"\=\[\]\#]*))$/) {
                                $valtemp{"option"} = (defined ($2) ? $2 : $1);
                                my $val = $5;
                                $val =~ s/^\s+|\s+$//g ;
                                $valtemp{"value"} = $val;
                                $valtemp{"ipversion"} = $1 =~ /^option6/ ? 6 : 4;
                            }
                        }
                        when ("address") {
                            if( $remainder =~ /\/($NAME)\/($IPADDR)/ ) {
                                $valtemp{"domain"}=$1;
                                $valtemp{"addr"}=$2;
                            }
                            elsif ( $remainder =~ /\/($NAME)\/($IPV6ADDR)/ ) {
                                $valtemp{"domain"}=$1;
                                $valtemp{"addr"}=$2;
                            }
                            else
                            {
                                print "Error in line $lineno (address)! ";
                                $$dnsmconfig{"errors"}++;
                            }
                        }
                        when ("ipset") {
                            if ( $remainder =~ /^\/([a-zA-Z\_\.][0-9a-zA-Z\_\.\-\/]*)\/([0-9a-zA-Z\,\.\-]*)$/ ) {
                                $valtemp{"domains"}=$1;
                                $valtemp{"ipsets"}=$2;
                            }
                        }
                        when ("dhcp-vendorclass") {
                            if ( $remainder =~ /^($TAG|([a-zA-Z0-9]*))\,([0-9a-zA-Z\,\.\-\:]*)$/ ) {
                                if (defined ($4)) {
                                    $valtemp{"tag"} = $4;
                                }
                                else {
                                    $valtemp{"tag"} = $3;
                                }
                                $valtemp{"vendorclass"} = $4;
                            }
                        }
                        when ("dhcp-userclass") {
                            if ( $remainder =~ /^($TAG|([a-zA-Z0-9]*))\,([0-9a-zA-Z\,\.\-\:]*)$/ ) {
                                if (defined ($4)) {
                                    $valtemp{"tag"} = $4;
                                }
                                else {
                                    $valtemp{"tag"} = $3;
                                }
                                $valtemp{"userclass"} = $4;
                            }
                        }
                        when ("dhcp-mac") {
                            if ( $remainder =~ /^($TAG)\,($MAC)$/ ) {
                                $valtemp{"tag"} = $3;
                                $valtemp{"mac"} = $4;
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
                        when ("tftp-root") { # =<directory>[,<interface>]
                            if ( $remainder =~ /^(.*),(.*)$/ ) {
                                $valtemp{"directory"} = $1;
                                $valtemp{"interface"} = $2;
                            }
                            else {
                                $valtemp{"directory"} = $remainder;
                            }
                        }
                        when ("bogus-nxdomain") { # =<ipaddr>[/prefix]
                            if( $remainder =~ /^($IPADDR)\/(.*)$/ ) {
                                $valtemp{"addr"} = $1;
                                $valtemp{"prefix"} = $2;
                            }
                            else {
                                $valtemp{"addr"} = $remainder;
                            }
                        }
                        when ("alias") { # =[<old-ip>]|[<start-ip>-<end-ip>],<new-ip>[,<mask>]
                            $valtemp{"netmask-used"} = 0;
                            if ( $remainder =~ /($IPADDR\-$IPADDR)\,($IPADDR)\,($IPADDR)$/ ) { # range with netmask
                                $valtemp{"from"} = $1;
                                $valtemp{"to"} = $2;
                                $valtemp{"netmask"} = $3;
                                $valtemp{"netmask-used"} = 1;
                            }
                            elsif ( $remainder =~ /($IPADDR\-$IPADDR)\,($IPADDR)$/ ) { # range without netmask
                                $valtemp{"from"} = $1;
                                $valtemp{"to"} = $2;
                            }
                            elsif ( $remainder =~ /($IPADDR)\,($IPADDR)\,($IPADDR)/ ) { # IP with netmask
                                $valtemp{"from"} = $1;
                                $valtemp{"to"} = $2;
                                $valtemp{"netmask"} = $3;
                                $valtemp{"netmask-used"} = 1;
                            }
                            elsif ( $remainder =~ /($IPADDR)\,($IPADDR)/ ) { # IP without netmask
                                $valtemp{"from"} = $1;
                                $valtemp{"to"} = $2;
                            }
                        }
                        when ("mx-host") { # =<mx name>[[,<hostname>],<preference>]
                            if( $remainder =~ /^($NAME),(.*)$/ ) {
                                $valtemp{"mxname"} = $1;
                                $remainder = $2;
                                if( $remainder =~ /^($NAME),(.*)$/ ) {
                                    $valtemp{"host"}=$1;
                                    $valtemp{"preference"}=$2;
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
                        }
                        # when ("") { # 
                        # }
                        # when ("") { # 
                        # }
                        # when ("") { # 
                        # }
                        # when ("") { # 
                        # }
                        # when ("") { # 
                        # }
                        default {

                        }
                    }
                    $temp{"val"} = { %valtemp };
                }
                if ( grep { /^$option$/ } ( @confarrs ) ) {
                    push @{ $$dnsmconfig{"$option"} }, { %temp };
                }
                else {
                    if ($$dnsmconfig{"$option"}{"used"} == 0) {
                        $$dnsmconfig{"$option"} = { %temp };
                    }
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
            #     push @{ $$dnsmconfig{"srv-host"} }, { %temp };
            # }
            # # TODO - ptr-record
            # elsif ($line =~ /(^[\#]*[\s]*ptr-record\=)([a-zA-Z0-9\_\.\/]*)/ ) {
            #     %temp = {};
            #     # $temp{}=$2;
            #     # $temp{}=$3;
            #     $temp{"used"}=($line !~/^\#/);
            #     $temp{"line"}=$lineno;
            #     $temp{"file"}=$config_filename;
            #     push @{ $$dnsmconfig{"ptr-record"} }, { %temp };
            # }
            # # TODO - txt-record
            # elsif ($line =~ /(^[\#]*[\s]*txt-record\=)([a-zA-Z0-9\_\.\/]*)/ ) {
            #     %temp = {};
            #     # $temp{}=$2;
            #     # $temp{}=$3;
            #     $temp{"used"}=($line !~/^\#/);
            #     $temp{"line"}=$lineno;
            #     $temp{"file"}=$config_filename;
            #     push @{ $$dnsmconfig{"txt-record"} }, { %temp };
            # }
            # # Provide an alias for a "local" DNS name
            # elsif ($line =~ /(^[\#]*[\s]*cname\=)($NAME)\,($NAME)/ ) {
            #     %temp = {};
            #     $temp{"alias"}=$2;
            #     $temp{"local"}=$3;
            #     $temp{"used"}=($line !~/^\#/);
            #     $temp{"line"}=$lineno;
            #     $temp{"file"}=$config_filename;
            #     push @{ $$dnsmconfig{"cname"} }, { %temp };
            # }
            # # If a DHCP client claims that its name is "wpad", ignore that.
            # elsif ($line =~ /(^[\#]*[\s]*dhcp-name-match\=set:wpad-ignore,wpad)/ ) {
            #     if ($$dnsmconfig->{'dhcp_name_match'}->{used} == 0) { # only overwrite if the last value read is not used (commented)
            #         $$dnsmconfig->{'dhcp_name_match'}->{used}=($line !~/^\#/);
            #         $$dnsmconfig->{'dhcp_name_match'}->{line}=$lineno;
            #         $$dnsmconfig->{'dhcp_name_match'}->{file}=$config_filename;
            #     }
            # }
            # # 
            # elsif ($line =~ /(^[\#]*[\s]*dhcp-ignore-names\=tag:wpad-ignore)/ ) {
            #     if ($$dnsmconfig->{'dhcp_ignore_names'}->{used} == 0) { # only overwrite if the last value read is not used (commented)
            #         $$dnsmconfig->{'dhcp_ignore_names'}->{used}=($line !~/^\#/);
            #         $$dnsmconfig->{'dhcp_ignore_names'}->{line}=$lineno;
            #         $$dnsmconfig->{'dhcp_ignore_names'}->{file}=$config_filename;
            #     }
            # }
            # else {
            #     # everything else that's not a comment 
            #     # we don't understand so it may be an error!
            #     if( $line !~ /^#/ ) {
            #         print "What?:" . $line;
            #         $$dnsmconfig{"errors"}++;
            #     }
            # }
        }
    }
} #end of sub parse_config_file

1;
