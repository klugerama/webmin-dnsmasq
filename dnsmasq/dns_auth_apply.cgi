#!/usr/bin/perl
#
#    DNSMasq Webmin Module - dns_auth_apply.cgi; update DNS server info     
#    Copyright (C) 2023 by Loren Cress
#    
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    This module based on the DNSMasq Webmin module by Neil Fisher

require "dnsmasq-lib.pl";

## put in ACL checks here if needed

my $config_filename = $config{config_file};
my $config_file = &read_file_lines( $config_filename );

&parse_config_file( \%dnsmconfig, \$config_file, $config_filename );
# read posted data
&ReadParse();

my $returnto = $in{"returnto"} || "dns_auth.cgi";
my $returnlabel = $in{"returnlabel"} || $text{"index_dns_auth_settings"};
# check for input data errors

# adjust everything to what we got
my $result = "";
my @sel = split(/\0/, $in{'sel'});

if ($in{"submit"}) {
    &apply_simple_vals("dns", \@sel, "7");

    &check_other_vals("dns", \@sel);

    if ($in{"auth_server_def"} == 1) {
        my $item = $dnsmconfig{"auth-server"};
        &save_update($item->{"file"}, $item->{"line"}, undef, 1);
    }
    elsif ($in{"auth_server_domain"}) {
        my $item = $dnsmconfig{"auth-server"};
        my $val = "auth-server=" . $in{"auth_server_domain"};
        if ($in{"auth_server_for"}) {
            $val .= "," . $in{"auth_server_for"};
        }
        &save_update($item->{"file"}, $item->{"line"}, $val);
    }
    if ($in{"auth_zone_def"} == 1) {
        my $item = $dnsmconfig{"auth-zone"};
        &save_update($item->{"file"}, $item->{"line"}, undef, 1);
    }
    elsif ($in{"auth_zone_domain"}) {
        my $item = $dnsmconfig{"auth-zone"};
        my $val = "auth-zone=" . $in{"auth_zone_domain"};
        if ($in{"auth_zone_include"}) {
            my @auth_zone_include = split(/\0/, $in{'auth_zone_include'});
            foreach my $subnet (@auth_zone_include) {
                $val .= "," . $subnet;
            }
        }
        if ($in{"auth_zone_exclude"}) {
            my @auth_zone_exclude = split(/\0/, $in{'auth_zone_exclude'});
            foreach my $subnet (@auth_zone_exclude) {
                $val .= ",exclude:" . $subnet;
            }
        }
        &save_update($item->{"file"}, $item->{"line"}, $val);
    }
    if ($in{"auth_soa_def"} == 1) {
        my $item = $dnsmconfig{"auth-soa"};
        &save_update($item->{"file"}, $item->{"line"}, undef, 1);
    }
    elsif ($in{"auth_soa_serial"}) { #"serial", "hostmaster", "refresh", "retry", "expiry"
        my $item = $dnsmconfig{"auth-soa"};
        my $val = "auth-soa=" . $in{"auth_soa_serial"};
        foreach my $p ( "hostmaster", "refresh", "retry", "expiry" ) {
            if ($in{"auth_soa_$p"}) {
                $val .= "," . $in{"auth_soa_$p"};
            }
        }
        &save_update($item->{"file"}, $item->{"line"}, $val);
    }
    if ($in{"auth_sec_servers_def"} == 1) {
        my $item = $dnsmconfig{"auth-sec-servers"};
        &save_update($item->{"file"}, $item->{"line"}, undef, 1);
    }
    elsif ($in{"auth_sec_servers_val"}) { 
        my $item = $dnsmconfig{"auth-sec-servers"};
        my $val = "auth-sec-servers=";
        my @auth_sec_servers = split(/\0/, $in{'auth_sec_servers_val'});
        foreach my $domain (@auth_sec_servers) {
            $val .= "," . $domain;
        }
        &save_update($item->{"file"}, $item->{"line"}, $val);
    }
    if ($in{"auth_peer_def"} == 1) {
        my $item = $dnsmconfig{"auth-peer"};
        &save_update($item->{"file"}, $item->{"line"}, undef, 1);
    }
    elsif ($in{"auth_peer_val"}) { 
        my $item = $dnsmconfig{"auth-peer"};
        my $val = "auth-peer=";
        my @auth_peer = split(/\0/, $in{'auth_peer_val'});
        foreach my $ip (@auth_peer) {
            $val .= "," . $ip;
        }
        &save_update($item->{"file"}, $item->{"line"}, $val);
    }
}
elsif ($in{"auth_server_domain"} ne "") { # =<domain>,[<interface>|<ip-address>...]
    my $item = $dnsmconfig{"auth-server"};
    my $newval = "auth-server=";
    $newval .= $in{"auth_server_domain"};
    if ($in{"auth_server_for"} ne "") {
        $newval .= "," . $in{"auth_server_for"};
    }
    &save_update($item->{"file"}, $item->{"line"}, $newval);
}
elsif ($in{"auth_zone_domain"} ne "") { # =<domain>[,<subnet>[/<prefix length>][,<subnet>[/<prefix length>]|<interface>.....][,exclude:<subnet>[/<prefix length>]|<interface>].....]
    my $item = $dnsmconfig{"auth-zone"};
    my $newval = "auth-zone=";
    $newval .= $in{"auth_server_domain"};
    if ($in{"auth_server_include"} ne "") {
        $newval .= "," . $in{"auth_server_include"};
    }
    if ($in{"auth_server_exclude"} ne "") {
        $newval .= ",exclude:" . $in{"auth_server_exclude"};
    }
    &save_update($item->{"file"}, $item->{"line"}, $newval);
}
elsif ($in{"auth_soa_serial"} ne "") { # =<serial>[,<hostmaster>[,<refresh>[,<retry>[,<expiry>]]]]
    my $item = $dnsmconfig{"auth-soa"};
    my $newval = "auth-soa=";
    $newval .= $in{"auth_server_serial"};
    if ($in{"auth_server_hostmaster"} ne "") {
        $newval .= "," . $in{"auth_server_hostmaster"};
        if ($in{"auth_server_refresh"} ne "") {
            $newval .= "," . $in{"auth_server_refresh"};
            if ($in{"auth_server_retry"} ne "") {
                $newval .= "," . $in{"auth_server_retry"};
                if ($in{"auth_server_expiry"} ne "") {
                    $newval .= "," . $in{"auth_server_expiry"};
                }
            }
        }
    }
    &save_update($item->{"file"}, $item->{"line"}, $newval);
}
else {
    &do_selected_action( [ "server", "rev_server" ], \@sel, \%$dnsmconfig );
}

#
# re-load basic page
&redirect( $returnto );

# 
# sub-routines
#
### END of dns_auth_apply.cgi ###.
