#!/usr/bin/perl
#
#    DNSMasq Webmin Module - dns_iface.cgi; network interfaces
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

&header($text{"index_title"}, "", "intro", 1, 0, 0, &restart_button(), undef, undef, $text{"index_dns_iface_settings"});
print &header_style();

my $returnto = $in{"returnto"} || "dns_iface.cgi";
my $returnlabel = $in{"returnlabel"} || $text{"index_dns_iface_settings"};
my $apply_cgi = "dns_iface_apply.cgi";

my @tds = ( $td_left, $td_left, $td_left );
our $formidx = 0;

my @vals = ( "interface", "except_interface", "no_dhcp_interface" );

my @page_fields = ();
foreach my $configfield ( @confdns ) {
    next if ( %dnsmconfigvals{"$configfield"}->{"page"} ne "3" );
    push( @page_fields, $configfield );
}
my @tabs = (   [ 'basic', $text{'index_basic'} ] );
foreach my $v ( @vals ) {
    push(@tabs, [ $v, $text{"p_desc_" . $v} ]);
}
push(@tabs, [ 'listen_address', $text{"p_desc_listen_address"} ]);

my $mode = $in{"mode"} || "basic";
print ui_tabs_start(\@tabs, 'mode', $mode);

print ui_tabs_start_tab('mode', 'basic');
&show_basic_fields( \%dnsmconfig, "dns_iface", \@page_fields, $apply_cgi, $text{"index_dns_iface_settings"} );
print ui_tabs_end_tab('mode', 'basic');

foreach my $v ( @vals ) {
    print ui_tabs_start_tab('mode', $v);
    &show_field_table($v, $apply_cgi . "?mode=" . $v, $text{"_iface"}, \%dnsmconfig, $formidx++);
    print ui_tabs_end_tab('mode', $v);
}

print ui_tabs_start_tab('mode', 'listen_address');
&show_field_table("listen_address", $apply_cgi . "?mode=listen_address", $text{"_listen"}, \%dnsmconfig, $formidx++);
print ui_tabs_end_tab('mode', 'listen_address');

print ui_tabs_end();

print &add_js();

ui_print_footer("index.cgi?mode=dns", $text{"index_dns_settings"});

### END of dns_iface.cgi ###.
