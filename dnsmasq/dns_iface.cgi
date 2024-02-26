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

## put in ACL checks here if needed

my $config_filename = $config{config_file};
my $config_file = &read_file_lines( $config_filename );

&parse_config_file( \%dnsmconfig, \$config_file, $config_filename );
# read posted data
&ReadParse();

my ($error_check_action, $error_check_result) = &check_for_file_errors( $0, $dnsmasq::text{"index_title"}, \%dnsmconfig );
if ($error_check_action eq "redirect") {
    &redirect ( $error_check_result );
}

my ($section, $page) = &get_context($0);
my ($page_fields) = &get_page_fields($0);

&ui_print_header($dnsmasq::text{"index_dns_iface_settings"} . &icon_if_disabled($section), $dnsmasq::text{"index_title"}, "", "intro", 1, 0, 0, &restart_button());
print &header_js(\%dnsmconfig);
print $error_check_result;

my $returnto = $in{"returnto"} || "dns_iface.cgi";
my $returnlabel = $in{"returnlabel"} || $dnsmasq::text{"index_dns_iface_settings"};
my $apply_cgi = "dns_iface_apply.cgi";

my @tds = ( &get_class_tag($td_left_class), &get_class_tag($td_left_class), &get_class_tag($td_left_class) );
our $formidx = 0;

my @vals = ( "interface", "except_interface", "no_dhcp_interface" );

my @tabs = (   [ 'basic', $dnsmasq::text{'index_basic'} ] );
foreach my $v ( @vals ) {
    push(@tabs, [ $v, $dnsmasq::text{"p_desc_" . $v} ]);
}
push(@tabs, [ 'listen_address', $dnsmasq::text{"p_desc_listen_address"} ]);

my $tab = $in{"tab"} || "basic";
print &ui_tabs_start(\@tabs, 'tab', $tab);

print &ui_tabs_start_tab('tab', 'basic');
&show_basic_fields( \%dnsmconfig, "dns_iface", $page_fields, $apply_cgi, $dnsmasq::text{"index_dns_iface_settings"} );
print &ui_tabs_end_tab('tab', 'basic');

foreach my $v ( @vals ) {
    print &ui_tabs_start_tab('tab', $v);
    &show_field_table($v, $apply_cgi . "?tab=" . $v, $dnsmasq::text{"_iface"}, \%dnsmconfig, $formidx++);
    print &ui_tabs_end_tab('tab', $v);
}

print &ui_tabs_start_tab('tab', 'listen_address');
&show_field_table("listen_address", $apply_cgi . "?tab=listen_address", $dnsmasq::text{"_listen"}, \%dnsmconfig, $formidx++);
print &ui_tabs_end_tab('tab', 'listen_address');

print &ui_tabs_end();

print &add_js();

&ui_print_footer("index.cgi?tab=dns", $dnsmasq::text{"index_dns_settings"});

### END of dns_iface.cgi ###.
