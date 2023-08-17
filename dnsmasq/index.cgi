#!/usr/bin/perl
#
#    DNSMasq Webmin Module - index.cgi; Main navigation
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
#    This module based on the DNSMasq Webmin module originally written by Neil Fisher

require 'dnsmasq-lib.pl';
require 'dns.cgi';
require 'dhcp.cgi';
require 'tftp.cgi';

# $|=1;

my %access=&get_module_acl;

## put in ACL checks here if needed

## sanity checks

# uses the index_title entry from ./lang/en or appropriate

## Insert Output code here
# read config file
my $config_filename = $config{config_file};
my $config_file = &read_file_lines( $config_filename );

&parse_config_file( \%dnsmconfig, \$config_file, $config_filename );
# read posted data
&ReadParse();

# &header($text{"index_title"}, "", "intro", 1, 0, 0, &restart_button(), "<script type='text/javascript'>//test</script>");
&header($text{"index_title"}, "", "intro", 1, 0, 0, "<!-- test rightside -->", "<script type='text/javascript'>//test</script>");
print &header_style();

my $mode = "dns";
if ( defined ($in{mode}) ) {
    $mode = $in{mode};
}

if( $dnsmconfig{"errors"} > 0 ) {
	print "<h3>WARNING: found ";
	print $dnsmconfig{"errors"};
	print "errors in config file!</h3><br>\n";
}
my @tabs = (   [ 'dns', $text{'index_dns_settings'} ],
            [ 'dhcp', $text{'index_dhcp_settings'} ],
            [ 'tftp', $text{'index_tftp_settings'} ] );
print ui_tabs_start(\@tabs, 'mode', $mode);

print ui_tabs_start_tab('mode', 'dns');
show_dns_settings();
print ui_tabs_end_tab('mode', 'dns');

print ui_tabs_start_tab('mode', 'dhcp');
show_dhcp_settings();
print ui_tabs_end_tab('mode', 'dhcp');

print ui_tabs_start_tab('mode', 'tftp');
show_tftp_settings();
print ui_tabs_end_tab('mode', 'tftp');

print ui_tabs_end();

# uses the index entry in /lang/en

## if subroutines are not in an extra file put them here

### END of index.cgi ###.
