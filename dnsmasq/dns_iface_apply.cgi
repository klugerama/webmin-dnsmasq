#!/usr/bin/perl
#
#    DNSMasq Webmin Module - iface_apply.cgi; do the update      
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

my $mode = $in{"mode"} || "basic";
my $returnto = $in{"returnto"} || "dns_iface.cgi?mode=$mode";
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
my @listen_iface_adds = split(/\0/, $in{'new_interface'});
my @except_iface_adds = split(/\0/, $in{'new_except_interface'});
my @no_dhcp_iface_adds = split(/\0/, $in{'new_no_dhcp_interface'});
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
elsif ($in{"interface_idx"} ne "" && $in{"interface_val"} ne "") {
    my $item = $dnsmconfig{"interface"}[$in{"interface_idx"}];
    my $file_arr = &read_file_lines($item->{"file"});
    my $val = "interface=" . $in{"interface_val"};
    &update($item->{"line"}, $val, \@$file_arr, 0);
    &flush_file_lines();
}
elsif (@except_iface_adds && join("", @except_iface_adds) ne "") {

    foreach my $except_iface_add (@except_iface_adds) {
        if ($except_iface_add ne "") {
            &add_to_list( "except-interface", $except_iface_add );
        }
    }

}
elsif ($in{"except_interface_idx"} ne "" && $in{"except_interface_val"} ne "") {
    my $item = $dnsmconfig{"except-interface"}[$in{"except_interface_idx"}];
    my $file_arr = &read_file_lines($item->{"file"});
    my $val = "except-interface=" . $in{"except_interface_val"};
    &update($item->{"line"}, $val, \@$file_arr, 0);
    &flush_file_lines();
}
elsif (@no_dhcp_iface_adds && join("", @no_dhcp_iface_adds) ne "") {

    foreach my $no_dhcp_iface_add (@no_dhcp_iface_adds) {
        if ($no_dhcp_iface_add ne "") {
            &add_to_list( "no-dhcp-interface", $no_dhcp_iface_add );
        }
    }

}
elsif ($in{"no_dhcp_interface_idx"} ne "" && $in{"no_dhcp_interface_val"} ne "") {
    my $item = $dnsmconfig{"no-dhcp-interface"}[$in{"no_dhcp_interface_idx"}];
    my $file_arr = &read_file_lines($item->{"file"});
    my $val = "no-dhcp-interface=" . $in{"no_dhcp_interface_val"};
    &update($item->{"line"}, $val, \@$file_arr, 0);
    &flush_file_lines();
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
    &do_selected_action( [ "interface", "except_interface", "no_dhcp_interface", "listen_address" ], \@sel, \%$dnsmconfig );
}

# re-load iface page
&redirect( $returnto );

# 
# sub-routines
#
### END of iface_apply.cgi ###.
