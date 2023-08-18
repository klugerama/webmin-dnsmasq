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

my %access=&get_module_acl;

## put in ACL checks here if needed

my $config_filename = $config{config_file};
my $config_file = &read_file_lines( $config_filename );

&parse_config_file( \%dnsmconfig, \$config_file, $config_filename );
# read posted data
&ReadParse();

&header($text{"index_title"}, "", "intro", 1, 0, 0, &restart_button(), undef, undef, $text{"index_dhcp_tags"});
print &header_style();

my $returnto = $in{"returnto"} || "dhcp_tags.cgi";
my $returnlabel = $in{"returnlabel"} || $text{"index_dhcp_tags"};
my $apply_cgi = "dhcp_tags_apply.cgi";

my @page_fields = ();
foreach my $configfield ( @confdhcp ) {
    next if ( %dnsmconfigvals{"$configfield"}->{"page"} ne "4" );
    push( @page_fields, $configfield );
}
my @tabs = (
            # [ 'basic', $text{'index_basic'} ], # there aren't any basic fields here!
            [ 'basic_match', $text{"index_dhcp_other_tags"} ],
            [ 'userclass', $text{"index_dhcp_userclass"} ],
            [ 'vendorclass', $text{"index_dhcp_vendorclass"} ],
        );
my $mode = $in{mode} || "basic_match";
print ui_tabs_start(\@tabs, 'mode', $mode);

# there aren't any basic fields here!
# print ui_tabs_start_tab('mode', 'basic');
# &show_basic_fields( \%dnsmconfig, "dhcp_tag", \@page_fields, "dhcp_tag_apply.cgi", $text{"index_basic"} );
# print ui_tabs_end_tab('mode', 'basic');

print ui_tabs_start_tab('mode', 'basic_match');
&show_other_fields( \%dnsmconfig, "dhcp_tag", \@page_fields, "dhcp_tag_apply.cgi", $text{"index_dhcp_other_tags"} );
print ui_tabs_end_tab('mode', 'basic_match');

print ui_tabs_start_tab('mode', 'userclass');
&show_field_table("dhcp_userclass", $apply_cgi,$text{"userclass"}, \%dnsmconfig, 2);
print ui_tabs_end_tab('mode', 'userclass');

print ui_tabs_start_tab('mode', 'vendorclass');
&show_field_table("dhcp_vendorclass", $apply_cgi,$text{"vendorclass"}, \%dnsmconfig, 3);
print ui_tabs_end_tab('mode', 'vendorclass');

print ui_tabs_end();

print &add_js();
ui_print_footer("index.cgi?mode=dhcp", $text{"index_dhcp_settings"}, "index.cgi?mode=dns", $text{"index_dns_settings"});

### END of dhcp_tags.cgi ###.
