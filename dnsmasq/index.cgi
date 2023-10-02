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

## put in ACL checks here if needed

# read config file
my $config_filename = $config{config_file};
my $config_file = &read_file_lines( $config_filename );

&parse_config_file( \%dnsmconfig, \$config_file, $config_filename );

# read posted data
&ReadParse();

my ($error_check_action, $error_check_result) = &check_for_file_errors( $0, $text{"index_dns_settings"}, \%dnsmconfig );
if ($error_check_action eq "redirect") {
    &redirect ( $error_check_result );
}

## Insert Output code here
&ui_print_header(undef, $text{"index_title"}, "", "intro", 1, 0, 0, &restart_button());
print &header_js(\%dnsmconfig);
print $error_check_result;

my @tabs = ( );
foreach my $c ( @section ) {
    push(@tabs, [$c, $text{"index_" . $c . "_settings"} . &icon_if_disabled($c)]);
}

my $tab = @section[0];
if ( defined ($in{"tab"}) ) {
    $tab = $in{"tab"};
}

print &ui_tabs_start(\@tabs, 'tab', $tab);

foreach my $c ( @section ) {
    print &ui_tabs_start_tab('tab', $c);
    show_main_icons_section($c);
    print &ui_tabs_end_tab('tab', $c);
}

print &ui_tabs_end();

print &add_js();

&ui_print_footer();

### END of index.cgi ###.
