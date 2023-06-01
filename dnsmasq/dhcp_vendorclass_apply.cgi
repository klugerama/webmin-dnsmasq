#!/usr/bin/perl
#
#    DNSMasq Webmin Module - # TODO dhcp_vendorclass_apply.cgi; update DHCP vendor classes     
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

require 'dnsmasq-lib.pl';

my %access=&get_module_acl;

## put in ACL checks here if needed


## sanity checks


## Insert Output code here
# read config file
my $config_filename = $config{config_file};
my $config_file = &read_file_lines( $config_filename );
# pass into data structure
&parse_config_file( \%dnsmconfig, \$config_file, $config_filename );
# read posted data
&ReadParse();

my $returnto = $in{"returnto"} || "dhcp_vendorclass.cgi";
my $returnlabel = $in{"returnlabel"} || $text{"index_dhcp_settings_basic"};
# check for errors in read config
if( $dnsmconfig{"errors"} > 0 ) {
    my $line="error.cgi?line=xx&type=" . &urlize($text{"err_configbad"});
    &redirect( $line );
    exit;
}
# check for input data errors

# first get each checked item's filename

my @sel = split(/\0/, $in{'sel'});

# adjust everything to what we got
$action = ( $in{"enable_sel"} ? "enable" : ( $in{"disable_sel"} ? "disable" : ( $in{"delete_sel"} ? "delete" : "" ) ) );
if ($action ne "") {
    @sel || &error($text{'selected_none'});
    &update_selected("dhcp-vendorclass", $action, \@sel, \%$dnsmconfig);
}
elsif ($in{"new_dhcp_vendorclass_vendorclass"} && $in{"new_dhcp_vendorclass_vendorclass"} ne "") {
    my $newval = "set:" . $in{"new_dhcp_vendorclass_tag"} . "," . $in{"new_dhcp_vendorclass_vendorclass"};
    &add_to_list("dhcp-vendorclass", $newval);
}
elsif ($in{"dhcp_vendorclass_idx"} ne "") {
    my $item = $dnsmconfig{"dhcp-vendorclass"}[$in{"dhcp_vendorclass_idx"}];
    my $file_arr = &read_file_lines($item->{"file"});
    my $val = "dhcp-vendorclass=set:" . $in{"dhcp_vendorclass_tag"} . "," . $in{"dhcp_vendorclass_vendorclass"};
    &update($item->{"line"}, $val, \@$file_arr, 0);
    &flush_file_lines();
}

#
# re-load vendorclass page
&redirect( $returnto );

### END of dhcp_vendorclass_apply.cgi ###.
