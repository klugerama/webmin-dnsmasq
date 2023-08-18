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

my %access=&get_module_acl;

## put in ACL checks here if needed

my $config_filename = $config{config_file};
my $config_file = &read_file_lines( $config_filename );

&parse_config_file( \%dnsmconfig, \$config_file, $config_filename );
# read posted data
&ReadParse();

my $returnto = $in{"returnto"} || "dns_auth.cgi";
my $returnlabel = $in{"returnlabel"} || $text{"index_dns_auth_settings"};
# check for errors in read config
if( $dnsmconfig{"errors"} > 0 ) {
	my $line = "error.cgi?line=xx&type=" . &urlize($text{"err_configbad"});
	&redirect( $line );
	exit;
}
# check for input data errors

# adjust everything to what we got
my $result = "";
my @sel = split(/\0/, $in{'sel'});

if ($in{"submit"}) {
    &apply_simple_vals("dns", \@sel, "7");

    &check_other_vals("dns", \@sel);

    if ($in{"auth_server_def"} == 1) {
        my $item = $dnsmconfig{"auth-server"};
        my $file_arr = &read_file_lines($item->{"file"});
        &update($item->{"line"}, $val, \@$file_arr, 1);
        &flush_file_lines();
    }
    elsif ($in{"auth_server_domain"}) {
        my $item = $dnsmconfig{"auth-server"};
        my $file_arr = &read_file_lines($item->{"file"});
        my $val = "auth-server=" . $in{"auth_server_domain"};
        if ($in{"auth_server_for"}) {
            $val .= "," . $in{"auth_server_for"};
        }
        &update($item->{"line"}, $val, \@$file_arr, 0);
        &flush_file_lines();
    }
    if ($in{"auth_zone_def"} == 1) {
        my $item = $dnsmconfig{"auth-zone"};
        my $file_arr = &read_file_lines($item->{"file"});
        &update($item->{"line"}, $val, \@$file_arr, 1);
        &flush_file_lines();
    }
    elsif ($in{"auth_zone_domain"}) {
        my $item = $dnsmconfig{"auth-zone"};
        my $file_arr = &read_file_lines($item->{"file"});
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
        &update($item->{"line"}, $val, \@$file_arr, 0);
        &flush_file_lines();
    }
    if ($in{"auth_soa_def"} == 1) {
        my $item = $dnsmconfig{"auth-soa"};
        my $file_arr = &read_file_lines($item->{"file"});
        &update($item->{"line"}, $val, \@$file_arr, 1);
        &flush_file_lines();
    }
    elsif ($in{"auth_soa_serial"}) { #"serial", "hostmaster", "refresh", "retry", "expiry"
        my $item = $dnsmconfig{"auth-soa"};
        my $file_arr = &read_file_lines($item->{"file"});
        my $val = "auth-soa=" . $in{"auth_soa_serial"};
        foreach my $p ( "hostmaster", "refresh", "retry", "expiry" ) {
            if ($in{"auth_soa_$p"}) {
                $val .= "," . $in{"auth_soa_$p"};
            }
        }
        &update($item->{"line"}, $val, \@$file_arr, 0);
        &flush_file_lines();
    }
    if ($in{"auth_sec_servers_def"} == 1) {
        my $item = $dnsmconfig{"auth-sec-servers"};
        my $file_arr = &read_file_lines($item->{"file"});
        &update($item->{"line"}, $val, \@$file_arr, 1);
        &flush_file_lines();
    }
    elsif ($in{"auth_sec_servers_val"}) { 
        my $item = $dnsmconfig{"auth-sec-servers"};
        my $file_arr = &read_file_lines($item->{"file"});
        my $val = "auth-sec-servers=";
        my @auth_sec_servers = split(/\0/, $in{'auth_sec_servers_val'});
        foreach my $domain (@auth_sec_servers) {
            $val .= "," . $domain;
        }
        &update($item->{"line"}, $val, \@$file_arr, 0);
        &flush_file_lines();
    }
    if ($in{"auth_peer_def"} == 1) {
        my $item = $dnsmconfig{"auth-peer"};
        my $file_arr = &read_file_lines($item->{"file"});
        &update($item->{"line"}, $val, \@$file_arr, 1);
        &flush_file_lines();
    }
    elsif ($in{"auth_peer_val"}) { 
        my $item = $dnsmconfig{"auth-peer"};
        my $file_arr = &read_file_lines($item->{"file"});
        my $val = "auth-peer=";
        my @auth_peer = split(/\0/, $in{'auth_peer_val'});
        foreach my $ip (@auth_peer) {
            $val .= "," . $ip;
        }
        &update($item->{"line"}, $val, \@$file_arr, 0);
        &flush_file_lines();
    }
}
elsif ($in{"auth_server_domain"} ne "") { # =<domain>,[<interface>|<ip-address>...]
    my $item = $dnsmconfig{"auth-server"};
    my $file_arr = &read_file_lines($item->{"file"});
    my $newval = "auth-server=";
    $newval .= $in{"auth_server_domain"};
    if ($in{"auth_server_for"} ne "") {
        $newval .= "," . $in{"auth_server_for"};
    }
    &update($item->{"line"}, $newval, \@$file_arr, 0);
    &flush_file_lines();
}
elsif ($in{"auth_zone_domain"} ne "") { # =<domain>[,<subnet>[/<prefix length>][,<subnet>[/<prefix length>]|<interface>.....][,exclude:<subnet>[/<prefix length>]|<interface>].....]
    my $item = $dnsmconfig{"auth-zone"};
    my $file_arr = &read_file_lines($item->{"file"});
    my $newval = "auth-zone=";
    $newval .= $in{"auth_server_domain"};
    if ($in{"auth_server_include"} ne "") {
        $newval .= "," . $in{"auth_server_include"};
    }
    if ($in{"auth_server_exclude"} ne "") {
        $newval .= ",exclude:" . $in{"auth_server_exclude"};
    }
    &update($item->{"line"}, $newval, \@$file_arr, 0);
    &flush_file_lines();
}
elsif ($in{"auth_soa_serial"} ne "") { # =<serial>[,<hostmaster>[,<refresh>[,<retry>[,<expiry>]]]]
    my $item = $dnsmconfig{"auth-soa"};
    my $file_arr = &read_file_lines($item->{"file"});
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
    &update($item->{"line"}, $newval, \@$file_arr, 0);
    &flush_file_lines();
}
else {
    # my $action = $in{"enable_sel_server"} ? "enable" : $in{"disable_sel_server"} ? "disable" : $in{"delete_sel_server"} ? "delete" : "";
    # if ($action ne "") {
    #     @sel || &error($text{'selected_none'});

    #     &update_selected("server", $action, \@sel, \%$dnsmconfig);
    # }
    # else {
    #     $action = $in{"enable_sel_rev_server"} ? "enable" : $in{"disable_sel_rev_server"} ? "disable" : $in{"delete_sel_rev_server"} ? "delete" : "";
    #     if ($action ne "") {
    #         @sel || &error($text{'selected_none'});

    #         &update_selected("rev-server", $action, \@sel, \%$dnsmconfig);
    #     }
    # }
    &do_selected_action( [ "server", "rev_server" ], \@sel, \%$dnsmconfig );
}

#
# write file!!
&flush_file_lines();
#
# re-load basic page
&redirect( $returnto );

# 
# sub-routines
#
### END of dns_auth_apply.cgi ###.
