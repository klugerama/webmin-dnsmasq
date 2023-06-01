#!/usr/bin/perl
#
#    DNSMasq Webmin Module - # TODO iface_apply.cgi; do the update      
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

my $returnto = $in{"returnto"} || "dns_iface.cgi";
my $returnlabel = $in{"returnlabel"} || $text{"index_dns_iface_settings"};
# check for errors in read config
if( $dnsmconfig{"errors"} > 0 ) {
	my $line = "error.cgi?line=xx&type=" . &urlize($text{"err_configbad"});
	&redirect( $line );
	exit;
}

# # adjust everything to what we got
# #
# &update( $dnsmconfig{"bind-interfaces"}->{"line"}, "bind-interfaces",
# 	$config_file, ( $in{"bind_interfaces"} == 1 ) );
# #
# # write file!!
# &flush_file_lines();
#

my @sel = split(/\0/, $in{'sel'});
my @listen_iface_adds = split(/\0/, $in{'new_listen_iface'});
my @except_iface_adds = split(/\0/, $in{'new_except_iface'});
my @no_dhcp_iface_adds = split(/\0/, $in{'new_no_dhcp_iface'});
my @listen_address_adds = split(/\0/, $in{'new_listen_address'});

my @dns_bools = ();
my @dns_singles = ();
foreach my $configfield ( @confdns ) {
    next if ( grep { /^$configfield$/ } ( @confarrs ) );
    next if ( %dnsmconfigvals{"$configfield"}->{"mult"} ne "" );
    if ( grep { /^$configfield$/ } ( @confbools ) ) {
        push @dns_bools, $configfield;
    }
    elsif ( grep { /^$configfield$/ } ( @confsingles ) ) {
        push @dns_singles, $configfield;
    }
}

if (@listen_iface_adds && join("", @listen_iface_adds) ne "") {

    foreach my $listen_iface_add (@listen_iface_adds) {
        if ($listen_iface_add ne "") {
            &add_to_list( "interface", $listen_iface_add );
        }
    }

}
elsif (@except_iface_adds && join("", @except_iface_adds) ne "") {

    foreach my $except_iface_add (@except_iface_adds) {
        if ($except_iface_add ne "") {
            &add_to_list( "except-interface", $except_iface_add );
        }
    }

}
elsif (@no_dhcp_iface_adds && join("", @no_dhcp_iface_adds) ne "") {

    foreach my $no_dhcp_iface_add (@no_dhcp_iface_adds) {
        if ($no_dhcp_iface_add ne "") {
            &add_to_list( "no-dhcp-interface", $no_dhcp_iface_add );
        }
    }

}
elsif (@listen_address_adds && join("", @listen_address_adds) ne "") {

    foreach my $listen_address_add (@listen_address_adds) {
        if ($listen_address_add ne "") {
            &add_to_list( "listen-address", $listen_address_add );
        }
    }

}
elsif ($in{"listen_address_idx"} ne "" && $in{"listen_address_val"} ne "") {
    my $item = $dnsmconfig{"listen-address"}[$in{"listen_address_idx"}];
    my $file_arr = &read_file_lines($item->{"file"});
    my $val = "listen-address=" . $in{"listen_address_val"};
    &update($item->{"line"}, $val, \@$file_arr, 0);
    &flush_file_lines();
}
else {
    my $action = $in{"enable_sel_iface"} ? "enable" : $in{"disable_sel_iface"} ? "disable" : $in{"delete_sel_iface"} ? "delete" : "";
    if ($action ne "") {
        @sel || &error($text{'selected_none'});

        &update_selected("interface", $action, \@sel, \%$dnsmconfig);
    }
    else {
        $action = $in{"enable_sel_except_iface"} ? "enable" : $in{"disable_sel_except_iface"} ? "disable" : $in{"delete_sel_except_iface"} ? "delete" : "";
        if ($action ne "") {
            @sel || &error($text{'selected_none'});

            &update_selected("except-interface", $action, \@sel, \%$dnsmconfig);
        }
        else {
            $action = $in{"enable_sel_no_dhcp_iface"} ? "enable" : $in{"disable_sel_no_dhcp_iface"} ? "disable" : $in{"delete_sel_no_dhcp_iface"} ? "delete" : "";
            if ($action ne "") {
                @sel || &error($text{'selected_none'});

                &update_selected("no-dhcp-interface", $action, \@sel, \%$dnsmconfig);
            }
            else {
                $action = $in{"enable_sel_listen_address"} ? "enable" : $in{"disable_sel_listen_address"} ? "disable" : $in{"delete_sel_listen_address"} ? "delete" : "";
                if ($action ne "") {
                    @sel || &error($text{'selected_none'});

                    &update_selected("listen-address", $action, \@sel, \%$dnsmconfig);
                }
            }
        }
    }
}

# re-load iface page
&redirect( $returnto );

# 
# sub-routines
#
### END of iface_apply.cgi ###.
