#
# dnsmasq-lib.pl
#
# dnsmasq webmin module library module
#
#
# the config hash holds the parsed config file
# 
my %config = {
    errors => 0,
    port => { used => 0, line => 0, file => "", port = 53 },
    domain_needed => { line => 0, used => 0, file => "" },
    bogus_priv => { line =>0, used => 0, file => "" },
    conf_file => { used => 0, line => 0, file => "", filename => "" },
    conf_dir => { used => 0, line => 0, file => "", dirname => "", filter => "", exceptions => "" },
    dnssec => { line =>0, used => 0, file => "" },
    dnssec_check_unsigned => { line =>0, used => 0, file => "" },
    filterwin2k => { line => 0, used => 0, file => "" },
    resolv_file => { line => 0, used => 0, file => "",				
            filename => "/etc/hosts" },
    strict_order => { line => 0, used => 0, file => "" },
    no_resolv => { line => 0, used => 0, file => "" },
    no_poll => { line => 0, used => 0, file => "" },
    locals => [],
    forced => [], # address
    ip_set => [],
    servers => [],
    user => { used => 0, file => "", user =>"" },
    group => { used => 0, file => "", group => "" },
    interface =>  [],
    ex_interface =>  [],
    listen_address => 	[],
    no_dhcp_interface =>  [],
    bind_interfaces => { used => 0, line => 0, file => "" },
    no_hosts => { used => 0, line => 0, file => "" },
    addn_hosts => { used => 0, line => 0, file => "" },
    expand_hosts => { used => 0, line => 0, file => "" },
    domain => { used => 0, line => 0, file => "", domain => "" },
    dhcp_range => [],
    dhcp_host => [],
    enable_ra => { used => 0, line => 0, file => "" },
    dhcp_ignore => [],
    vendor_class => [],
    user_class => [],
    dhcp_mac => [],
    read_ethers => { used => 0, line => 0, file => "" },
    dhcp_option => [],
    dhcp_option_force => [],
    dhcp_boot => { used => 0, line => 0, file => "",
            host => "", address => "" },
    dhcp_match => [],
    pxe_prompt => { used => 0, line => 0, file => "" },
    pxe_service => [],
    enable_tftp => { used => 0, line => 0, file => "" },
    tftp_root => { used => 0, line => 0, file => "" },
    tftp_no_fail => { used => 0, line => 0, file => "" },
    tftp_secure => { used => 0, line => 0, file => "" },
    tftp_no_blocksize => { used => 0, line => 0, file => "" },
    dhcp_leasemax => { used => 0, line => 0, file => "", max => 0 },
    dhcp_leasefile => { used => 0, line => 0, file => "", filename => "" },
    dhcp_authoritative => { used => 0, line => 0, file => "" },
    dhcp_script => { used => 0, line => 0, file => "", filename => "" },
    cache_size => { used => 0, line =>0, file => "", size => 0 },
    neg_cache => { used => 0, line => 0, file => "" },
    local_ttl => { used => 0, line => 0, file => "", ttl => 0 },
    bogus_nxdomain => [],
    alias => [],
    mx_host => { used => 0, line => 0, file => "", host => "" },
    mx_target => { used => 0, line => 0, file => "", host => "" },
    localmx => { used => 0, line => 0, file => "" },	
    selfmx => { used => 0, line => 0, file => "" },
    srv_host => [],
    ptr_record => [],
    txt_record => [],
    cname => { used => 0, line => 0, file => "" },
    log_queries => { used => 0, line => 0, file => "" },	
    log_dhcp => { used => 0, line => 0, file => "" },	
    log_facility => { used => 0, line => 0, file => "", filename => "" },	
    dhcp_name_match => { used => 0, line => 0, file => "" },
    dhcp_ignore_names => { used => 0, line => 0, file => "" }
};
#
# parse the configuration file and populate the %config structure
# 
sub parse_config_file {
    my $lineno;
    my $config = shift;
    my $config_file = shift;
    $IPADDR = "((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])";
    $IPV6ADDR = "([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])";
    $NAME = "[a-zA-Z\_\.][0-9a-zA-Z\_\.\-]*";
    $TIME = "[0-9}+[h|m]*";
    $FILE = "[0-9a-zA-Z\_\-\.\/]+";
    $NUMBER="[0-9]+";
    $TAG = "(set|tag):([0-9a-zA-Z\_\.\-]*)";
    $IPV6PROP = "ra-only|ra-names|ra-stateless|slaac";

    $lineno=0;
    foreach my $line (@$$config_file) {
        my $subline;
        my %temp;
        
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
            # MX records server?
            if ( $line =~ /(^[\#]*[\s]*port)\=([0-9]{1,5})/ ) {
                $$config{port}{port}=$2;
                $$config{port}{line}=$lineno;
                $$config{port}{used}=($line!~/^\#/);
                # $$config{port}{file}=$config_file;
            }
            elsif ( $line =~ /(^[\#]*[\s]*mx-host)\=([0-9a-zA-Z\.\-]*)/ ) {
            }
            elsif ($line =~ /(^[\#]*[\s]*mx-target)\=([0-9a-zA-Z\.\-]*)/ ) {
            }
            elsif ($line =~ /^[\#]*[\s]*selfmx/ ) {
                $$config{selfmx}{line}=$lineno;
                $$config{selfmx}{used}=($line !~ /^\#/);
            }
            elsif ($line =~ /^[\#]*[\s]*localmx/ ) {
                $$config{localmx}{line}=$lineno;
                $$config{localmx}{used}=($line !~ /^\#/);
            }
            # forward names without a domain?
            elsif ($line =~ /^[\#]*[\s]*domain-needed/ ) {
                $$config{domain_needed}{used}=($line!~/^\#/);
                $$config{domain_needed}{line}=$lineno;
            }
            #forward names in nonrouted address space?
            elsif ($line =~ /^[\#]*[\s]*bogus-priv/ ) {
                $$config{bogus_priv}{used}=($line!~/^\#/);
                $$config{bogus_priv}{line}=$lineno;
            }
            # filter windows wierdo names?
            elsif ($line =~ /^[\#]*[\s]*filterwin2k/ ) {
                $$config{filterwin2k}{used}=($line!~/^\#/);
                $$config{filterwin2k}{line}=$lineno;
            }
            # resolv.conf file
            elsif ($line =~ /(^[\#]*[\s]*resolv-file\=)([0-9a-zA-Z\/\.\-]*)/ ) {
                $$config{resolv_file}{filename}=$2;
                $$config{resolv_file}{line}=$lineno;
                $$config{resolv_file}{used}=($line!~/^\#/);
            }
            # any resolv.conf file at all?
            elsif ($line =~ /^[\#]*[\s]*no-resolv/ ) {
                $$config{no_resolv}{used}=($line!~/^\#/);
                $$config{no_resolv}{line}=$lineno;
            }
            # upstream servers in order?
            elsif ($line =~ /^[\#]*[\s]*strict-order/ ) {
                $$config{strict_order}{used}=($line!~/^\#/);
                $$config{strict_order}{line}=$lineno;
            }
            # check resolv. conf regularly?
            elsif ($line =~ /^[\#]*[\s]*no-poll/ ){
                $$config{no_poll}{used}=($line!~/^\#/);
                $$config{no_poll}{line}=$lineno;
            }
            # extra name servers?
            elsif ($line =~ /(^[\#]*[\s]*server\=)([0-9a-zA-Z\.\-\/\@\#]*)/ ) {
                $subline=$2;
                %temp = {};
                if ( $subline =~ /\/($NAME)\/($IPADDR)/ ) {
                    $temp{domain}=$1;
                    $temp{domain_used}=1;
                    $temp{address}=$2;
                    $temp{line}=$lineno;
                    $temp{used}= ($line !~ /^\#/);
                    push @{ $$config{servers} }, { %temp };
                }
                elsif ( $subline =~ /\/($NAME)\/($IPV6ADDR)/ ) {
                    $temp{domain}=$1;
                    $temp{domain_used}=1;
                    $temp{address}=$2;
                    $temp{line}=$lineno;
                    $temp{used}= ($line !~ /^\#/);
                    push @{ $$config{servers} }, { %temp };
                }
                elsif ( $subline =~ /($IPADDR)/ ) {
                    $temp{domain}="";
                    $temp{domain_used}=0;
                    $temp{address}=$1;
                    $temp{line}=$lineno;
                    $temp{used}= ($line !~ /^\#/);
                    push @{ $$config{servers} }, { %temp };
                }
                else
                {
                    print "Error in line $lineno (server)! ";
                    $$config{errors}++;
                }
            }
            # local-only domains
            elsif ($line =~ /(^[\#]*[\s]*local\=)([0-9a-zA-Z\.\-\/]*)/ ) {
                $subline=$2;
                %temp={};
                if( $subline =~ /\/($NAME)\// ) {
                    $temp{domain}=$1;
                    $temp{lineno}=$lineno;
                    $temp{used}=($line !~ /^\#/);
                    push @{ $$config{locals} }, { %temp };
                }
                else
                {
                    print "Error in line $lineno (local)! ";
                    $$config{errors}++;
                }
            }
            # force lookups to addresses
            elsif ($line =~ /(^[\#]*[\s]*address\=)([0-9a-zA-Z:\.\-\/]*)/ ) {
                $subline=$2;
                %temp = {};
                if( $subline =~ /\/($NAME)\/($IPADDR)/ ) {
                    $temp{line}=$lineno;
                    $temp{domain}=$1;
                    $temp{addr}=$2;
                    $temp{used}=($line !~ /^\#/);
                    push @{ $$config{forced} }, { %temp };
                }
                elsif ( $subline =~ /\/($NAME)\/($IPV6ADDR)/ ) {
                    $temp{line}=$lineno;
                    $temp{domain}=$1;
                    $temp{addr}=$2;
                    $temp{used}= ($line !~ /^\#/);
                    push @{ $$config{forced} }, { %temp };
                }
                else
                {
                    print "Error in line $lineno (address)! ";
                    $$config{errors}++;
                }
            }
            # deprecated /etc/ppp/resolv.conf permissions
            elsif ($line =~ /(^[\#]*[\s]*user\=)([0-9a-zA-Z\.\-\/]*)/ ) {
            }
            elsif ($line =~ /(^[\#]*[\s]*group\=)([0-9a-zA-Z\.\-\/]*)/ ) {
            }
            # where and how do we listen?
            elsif ($line =~ /(^[\#]*[\s]*listen-address\=)([0-9\.]*)/ ) {
                $subline=$2;
                %temp = {};
                if( $subline =~ /($IPADDR)/ ) {
                    $temp{line}=$lineno;
                    $temp{address}=$1;
                    $temp{used}= ($line !~ /^\#/);
                    push @{ $$config{listen_address} }, { %temp };
                }
                elsif ( $subline =~ /($IPV6ADDR)/ ) {
                    $temp{line}=$lineno;
                    $temp{address}=$1;
                    $temp{used}= ($line !~ /^\#/);
                    push @{ $$config{listen_address} }, { %temp };
                }
                elsif ( $subline eq "" ) {
                    $temp{line}=$lineno;
                    $temp{address}="";
                    $temp{used}= ($line !~ /^\#/);
                    push @{ $$config{listen_address} }, { %temp };
                }
                else
                {
                    print "Error in line $lineno (listen-address)! ";
                    $$config{errors}++;
                }
            }
            elsif ($line =~ /(^[\#]*[\s]*except-interface\=)([0-9a-zA-Z\.\-\/]*)/ ) {
                $subline=$2;
                %temp = {};
                if( $subline =~ /($NAME)/ ) {
                    $temp{line}=$lineno;
                    $temp{iface}=$1;
                    $temp{used}= ($line !~ /^\#/);
                    push @{ $$config{ex_interface} }, { %temp };
                }
                elsif( $subline eq "" ) {
                    $temp{line}=$lineno;
                    $temp{iface}="";
                    $temp{used}= ($line !~ /^\#/);
                    push @{ $$config{ex_interface} }, { %temp };
                }
                else
                {
                    print "Error in line $lineno (except-interface)! ";
                    $$config{errors}++;
                }
            }
            elsif ($line =~ /(^[\#]*[\s]*interface\=)([0-9a-zA-Z\.\-\/]*)/ ) {
                $subline=$2;
                %temp = {};
                if( $subline =~ /($NAME)/ ) {
                    $temp{line}=$lineno;
                    $temp{iface}=$1;
                    $temp{used}= ($line !~ /^\#/);
                    push @{ $$config{interface} }, { %temp };
                }
                else
                {
                    print "Error in line $lineno (interface)! ";
                    $$config{errors}++;
                }
            }
            elsif ($line =~ /^[\#]*[\s]*bind-interfaces/ ) {
                $$config{bind_interfaces}{used}=($line!~/^\#/);
                $$config{bind_interfaces}{line}=$lineno;
            }
            # hosts file
            elsif ($line =~ /^[\#]*[\s]*no-hosts/ ) {
                $$config{no_hosts}{used}=($line!~/^\#/);
                $$config{no_hosts}{line}=$lineno;
            }
            elsif ($line =~ /(^[\#]*[\s]*addn-hosts\=)([0-9a-zA-Z\_\.\-\/]*)/ ) {
                $$config{addn_hosts}{line}=$lineno;
                $$config{addn_hosts}{file}=$2;
                $$config{addn_hosts}{used}=($line!~/^\#/);
            }
            # add domain to hosts file?
            elsif ($line =~ /^[\#]*[\s]*expand-hosts/ ) {
                $$config{expand_hosts}{used}=($line!~/^\#/);
                $$config{expand_hosts}{line}=$lineno;
            } 
            # translate wild-card responses to NXDOMAIN
            elsif ($line =~ /(^[\#]*[\s]*bogus-nxdomain\=)([0-9\.]*)/ ) {
                $subline=$2;
                %temp = {};
                if( $subline =~ /($IPADDR)/ ) {
                    $temp{line}=$lineno;
                    $temp{addr}=$1;
                    $temp{used}= ($line !~ /^\#/);
                    push @{ $$config{bogus_nxdomain} }, { %temp };
                }
                else
                {
                    print "Error in line $lineno (bogus-nxdomain)! ";
                    $$config{errors}++;
                }
            }
            # local domain
            elsif ($line =~ /(^[\#]*[\s]*domain\=)([0-9a-zA-Z\.\-\/]*)/ ) {
                $$config{domain}{line}=$lineno;
                $$config{domain}{domain}=$2;
                $$config{domain}{used}=($line!~/^\#/);
            }
            # cache size
            elsif ($line =~ /(^[\#]*[\s]*cache-size\=)([0-9]*)/ ) {
                $$config{cache_size}{line}=$lineno;
                $$config{cache_size}{size}=$2;
                $$config{cache_size}{used}=($line !~/^\#/);
            }
            # negative cache 
            elsif ($line =~ /(^[\#]*[\s]*no-negcache)/ ) {
                $$config{neg_cache}{line}=$lineno;
                $$config{neg_cache}{used}=($line !~/^\#/);
            }
            # local ttl
            elsif ($line =~ /(^[\#]*[\s]*local-ttl\=)([0-9]*)/ ) {
                $$config{local_ttl}{line}=$lineno;
                $$config{local_ttl}{ttl}=$2;
                $$config{local_ttl}{used}=($line !~/^\#/);
            }
            # log requests? 
            elsif ($line =~ /(^[\#]*[\s]*log-queries)/ ) {
                $$config{log_queries}{line}=$lineno;
                $$config{log_queries}{used}=($line !~/^\#/);
            }
            # alias IP addresses
            elsif ($line =~ /(^[\#]*[\s]*alias\=)([0-9\.\,\-]*)/ ) {
                $subline=$2;
                %temp = {};
                if ( $subline =~ /($IPADDR\-$IPADDR)\,($IPADDR)\,($IPADDR)/ ) { # range with netmask
                    $temp{line}=$lineno;
                    $temp{from}=$1;
                    $temp{to}=$2;
                    $temp{netmask}=$3;
                    $temp{netmask_used}=1;
                    $temp{used}= ($line !~ /^\#/);
                    push @{ $$config{alias} }, { %temp };
                }
                elsif ( $subline =~ /($IPADDR)\,($IPADDR)\,($IPADDR)/ ) { # with netmask
                    $temp{line}=$lineno;
                    $temp{from}=$1;
                    $temp{to}=$2;
                    $temp{netmask}=$3;
                    $temp{netmask_used}=1;
                    $temp{used}= ($line !~ /^\#/);
                    push @{ $$config{alias} }, { %temp };
                }
                elsif ( $subline =~ /($IPADDR)\,($IPADDR)/ ) { # no netmask
                    $temp{line}=$lineno;
                    $temp{from}=$1;
                    $temp{to}=$2;
                    $temp{netmask}=0;
                    $temp{netmask_used}=0;
                    $temp{used}= ($line !~ /^\#/);
                    push @{ $$config{alias} }, { %temp };
                }
                else
                {
                    print "Error in line $lineno (alias)! ";
                    $$config{errors}++;
                }
            }
            # DHCP
            # address range to use
            elsif ($line =~ /(^[\#]*[\s]*dhcp-range\=)([0-9a-zA-Z\.\,\-\_:]*)/ ) {
                %temp={};
                $remainder=$2;
                $temp{line}=$lineno;
                $temp{used}=($line !~/^\#/);
                if ($remainder =~ /^($TAG)\,([0-9a-zA-Z\.\,\-\_]*)/ ) { # first get tag
                    $tag = $1;
                    $remainder = $4;
                    if ($1 =~ /^(set):([0-9a-zA-Z\.\,\-\_]*)/) {
                        $temp{tag_set}=($1 eq "set");
                        $temp{tag_depends}=($1 eq "tag");
                        $temp{tagname}=$2;
                    }
                }
                $temp{id_used}=0;
                if ($remainder =~ /^($NAME)\,([0-9a-zA-Z\.\,\-\_]*)/ ) {
                    # network id...
                    $temp{id}=$1;
                    $temp{id_used}=1;
                    $remainder = $2;
                }
                if ($remainder =~ /^($IPADDR)\,([0-9a-zA-Z\.\,\-\_]*)/ ) { # IPv4
                    # ...start...
                    $temp{start}=$1;
                    $remainder = $2;
                    if ($remainder =~ /^($IPADDR)\,([0-9a-zA-Z\.\,\-\_]*)/ ) {
                        # ...end...
                        $temp{end}=$1;
                        $remainder = $2;
                    }
                    $temp{mask}="";
                    $temp{mask_used}=0;
                    if ($remainder =~ /^($IPADDR)/ ) {
                        # ...netmask, time (optionally)
                        $temp{mask}=$1;
                        $temp{mask_used}=1;
                    }
                    if ($remainder =~ /^(static)\,([0-9a-zA-Z\.\,\-\_]*)/ ) {
                        $temp{static}=1;
                        $remainder = $2;
                    }
                    if ($remainder =~ /^(\d{1,2}[mh])/ ) {
                        # ...time (optionally)
                        $temp{leasetime}=$1;
                        $temp{time_used}=($1 =~ /^\d/);
                        $remainder = $2;
                    }
                    push @{ $$config{dhcp_range} }, { %temp };
                }
                elsif ($remainder =~ /^($IPV6ADDR)\,[\s]*([0-9a-zA-Z\.\,\-\_:]*)/ ) { # IPv6
                    # start...
                    $temp{id}="";
                    $temp{id_used}=0;
                    $temp{start}=$1;
                    $remainder=$31;
                    $temp{prefix_length}=64;
                    if ($remainder =~ /^($IPV6ADDR)\,[\s]*([0-9a-zA-Z\.\,\-\_:]*)/ ) {
                        # ...end
                        $temp{end}=$1;
                        $remainder=$31;
                    }
                    while ($remainder =~ /^($IPV6PROPS)\,[\s]*([0-9a-zA-Z\.\,\-\_:]*)/ ) {
                        # ...IPv6-only properties
                        $temp{ra-only}=($1 eq "ra-only");
                        $temp{ra-names}=($1 eq "ra-names");
                        $temp{ra-stateless}=($1 eq "ra-stateless");
                        $temp{slaac}=($1 eq "slaac");
                        $remainder = $2;
                    }
                    if ($remainder =~ /^(\d{1,3})\,[\s]*(\d{1,2}[mh])/ ) {
                        # ...prefix-length, time (optionally)
                        $temp{prefix_length}=$1;
                        $temp{leasetime}=$2;
                        $temp{time_used}=($2 =~ /^\d/);
                    }
                    elsif ($remainder =~ /^(\d{1,2}[mh])/ ) {
                        # ...time (optionally)
                        $temp{leasetime}=$1;
                        $temp{time_used}=($1 =~ /^\d/);
                    }
                    push @{ $$config{dhcp_range} }, { %temp };
                }
                else
                {
                    print "Error in line $lineno (dhcp-range)! ";
                    $$config{errors}++;
                }
            }
            # specify hosts
            elsif ($line =~ /(^[\#]*[\s]*dhcp-host\=)([0-9a-zA-Z\.\:\,\*]*)/) {
                # too many to classify - all as string!
                %temp = {};
                $temp{line}=$lineno;
                $temp{option}=$2;
                $temp{used}=($line !~/^\#/);
                push @{ $$config{dhcp_host} }, { %temp };
            }
            # vendor class
            elsif ($line =~ /(^[\#]*[\s]*dhcp-vendorclass\=)($NAME)\,($NAME)/ ) {
                %temp = {};
                $temp{line}=$lineno;
                $temp{class}=$2;
                $temp{vendor}=$3;
                $temp{used}=($line !~/^\#/);
                push @{ $$config{vendor_class} }, { %temp };
            }
            # user class
            elsif ($line =~ /(^[\#]*[\s]*dhcp-userclass\=)($NAME)\,($NAME)/ ) {
                %temp = {};
                $temp{line}=$lineno;
                $temp{class}=$2;
                $temp{user}=$3;
                $temp{used}=($line !~/^\#/);
                push @{ $$config{user_class} }, { %temp };
            }
            # /etc/ethers?
            elsif ($line =~ /(^[\#]*[\s]*read-ethers)/ ) {
                $$config{read_ethers}{line}=$lineno;
                $$config{read_ethers}{used}=($line !~/^\#/);
            }
            # dchp options
            elsif ($line =~ /(^[\#]*[\s]*dhcp-option\=)([0-9a-zA-Z\,\_\.]*)/ ) {
                # too many to classify - all as string!
                %temp = {};
                $temp{line}=$lineno;
                $temp{option}=$2;
                $temp{used}=($line !~/^\#/);
                push @{ $$config{dhcp_option} }, { %temp };
            }
            # lease time
            elsif ($line =~ /(^[\#]*[\s]*dhcp-lease-max\=)([0-9]*)/ ) {
                $$config{dhcp_leasemax}{line}=$lineno;
                $$config{dhcp_leasemax}{max}=$2;
                $$config{dhcp_leasemax}{used}=($line !~/^\#/);
            }
            # bootp host & file
            elsif ($line =~ /(^[\#]*[\s]*dhcp-boot\=)([0-9a-zA-Z0-9\,\_\.\/]*)/ ) {
                $subline=$2;
                if( $subline =~ /([0-9a-zA-Z\.\-\_\/]+)\,($NAME)\,($IPADDR)/ ) {
                    $$config{dhcp_boot}{line}=$lineno;
                    $$config{dhcp_boot}{file}=$1;
                    $$config{dhcp_boot}{host}=$2;
                    $$config{dhcp_boot}{address}=$3;
                    $$config{dhcp_boot}{used}=($line !~/^\#/);
                }
            }
            #  leases file
            elsif ($line =~ /(^[\#]*[\s]*dhcp-leasefile\=)([0-9a-zA-Z0-9\_\.\/]*)/ ) {
                $$config{dhcp_leasefile}{line}=$lineno;
                $$config{dhcp_leasefile}{file}=$2;
                $$config{dhcp_leasefile}{used}=($line !~/^\#/);
            }
            elsif ($line =~ /(^[\#]*[\s]*conf-file\=)([0-9a-zA-Z0-9\_\.\/]*)/ ) {
            # Additional configuration files
            
                # # Include another lot of configuration options.
                # #conf-file=/etc/dnsmasq.reservations.conf
                # #conf-file=/etc/dnsmasq.more.conf
            }
            elsif ($line =~ /(^[\#]*[\s]*conf-dir\=)([0-9a-zA-Z0-9,\_\.\/]*)/ ) {
            # Additional configuration files
            
                # # Include another lot of configuration options.
                # #conf-dir=/etc/dnsmasq.d

                # # Include all the files in a directory except those ending in .bak
                # #conf-dir=/etc/dnsmasq.d,.bak

                # # Include all files in a directory which end in .conf
                # conf-dir=/etc/dnsmasq.d/,*.conf

            }
            else
            {
                # everything else that's not a comment 
                # we don't understand so it may be an error!
                if( $line !~ /^#/ ) {
                    $config{errors}++;
                }
            }
        }
    }
} #end of sub read_config_file
#
# update the config file array
#
# arguments are:
# 	$lineno - the line number (array index) to update
# 	$text   - the new contents of the line
# 	$file   - reference to the array to change
# 	$comm   - put a comment marker ('#') at start of line?
# 	          false (0) means comment the line
#
sub update {
    my $lineno = shift;
    my $text = shift;
    my $file = shift;
    my $comm = shift;
    my $line;

    $line = ( $comm != 0 ) ?
        $text :
        "#" . $text;
    if ( $lineno == 0 ) {
        push @$file, $line;
    }
    else {
        @$file[$lineno]=$line;
    }
} # end of sub update
1;
