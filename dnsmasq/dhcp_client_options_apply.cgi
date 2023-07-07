#!/usr/bin/perl
#
#    DNSMasq Webmin Module - # TODO dhcp_basic_apply.cgi; update misc DHCP info     
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

my $config_filename = $config{config_file};
my $config_file = &read_file_lines( $config_filename );

&parse_config_file( \%dnsmconfig, \$config_file, $config_filename );

# read posted data
&ReadParse();

my $returnto = $in{"returnto"} || "dhcp_domain_name.cgi";
my $returnlabel = $in{"returnlabel"} || $text{"index_dhcp_settings_basic"};
# check for errors in read config
if( $dnsmconfig{"errors"} > 0 ) {
    my $line="error.cgi?line=xx&type=" . &urlize($text{"err_configbad"});
    &redirect( $line );
    exit;
}
# check for input data errors
# adjust everything to what we got

my @sel = split(/\0/, $in{'sel'});
@sel || &error($text{'selected_none'});

# adjust everything to what we got

$action = $in{"enable_sel"} ? "enable" : $in{"disable_sel"} ? "disable" : $in{"delete_sel"} ? "delete" : "";
if ($action ne "") {
    &update_selected("dhcp-option", $action, \@sel, \%$dnsmconfig);
}

#
# re-load client options page
&redirect( "dhcp_client_options.cgi" );

# 
# sub-routines
#
### END of dhcp_client_options.cgi ###.
