#!/usr/bin/perl
#
#    DNSMasq Webmin Module - dhcp_tags.cgi; DHCP tag matching
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

&ui_print_header($dnsmasq::text{"index_dhcp_tags"} . &icon_if_disabled($section), $dnsmasq::text{"index_title"}, "", "intro", 1, 0, 0, &restart_button());
print &header_js(\%dnsmconfig);
print $error_check_result;

my $returnto = $in{"returnto"} || "dhcp_tags.cgi";
my $returnlabel = $in{"returnlabel"} || $dnsmasq::text{"index_dhcp_tags"};
my $apply_cgi = "dhcp_tags_apply.cgi";

my @tabs = (
            # [ 'basic', $dnsmasq::text{'index_basic'} ], # there aren't any basic fields here!
            [ 'basic_match', $dnsmasq::text{"index_dhcp_other_tags"} ],
            [ 'userclass', $dnsmasq::text{"index_dhcp_userclass"} ],
            [ 'vendorclass', $dnsmasq::text{"index_dhcp_vendorclass"} ],
        );
my $tab = $in{"tab"} || "basic_match";
print &ui_tabs_start(\@tabs, 'tab', $tab);

# there aren't any basic fields here!
# print &ui_tabs_start_tab('tab', 'basic');
# &show_basic_fields( \%dnsmconfig, "dhcp_tag", $page_fields, "dhcp_tag_apply.cgi", $dnsmasq::text{"index_basic"} );
# print &ui_tabs_end_tab('tab', 'basic');

print &ui_tabs_start_tab('tab', 'basic_match');
&show_other_fields( \%dnsmconfig, "dhcp_tag", $page_fields, "dhcp_tag_apply.cgi", $dnsmasq::text{"index_dhcp_other_tags"} );
print &ui_tabs_end_tab('tab', 'basic_match');

print &ui_tabs_start_tab('tab', 'userclass');
&show_field_table("dhcp_userclass", $apply_cgi, $dnsmasq::text{"_userclass"}, \%dnsmconfig, 2);
print &ui_tabs_end_tab('tab', 'userclass');

print &ui_tabs_start_tab('tab', 'vendorclass');
&show_field_table("dhcp_vendorclass", $apply_cgi, $dnsmasq::text{"_vendorclass"}, \%dnsmconfig, 3);
print &ui_tabs_end_tab('tab', 'vendorclass');

print &ui_tabs_end();

print &add_js();
&ui_print_footer("index.cgi?tab=dhcp", $dnsmasq::text{"index_dhcp_settings"}, "index.cgi?tab=dns", $dnsmasq::text{"index_dns_settings"});

### END of dhcp_tags.cgi ###.
