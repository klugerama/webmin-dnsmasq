#!/usr/bin/perl
#
#    DNSMasq Webmin Module - dns_addn_config.cgi; basic DNS config     
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

my ($error_check_action, $error_check_result) = &check_for_file_errors( $0, $text{"index_title"}, \%dnsmconfig );
if ($error_check_action eq "redirect") {
    &redirect ( $error_check_result );
}

&ui_print_header($text{"index_dns_addn_config"}, $text{"index_title"}, "", "intro", 1, 0, 0, &restart_button());
print &header_style();
print $error_check_result;

my $tab = $in{"tab"} || "conf_file";
my $returnto = $in{"returnto"} || "dns_addn_config.cgi";
my $returnlabel = $in{"returnlabel"} || $text{"index_dns_addn_config"};
my $apply_cgi = "dns_addn_config_apply.cgi";
my $formidx = 0;

my @vals = (
    {
        "internalfield" => "conf_file",
        "add_button_text" => $text{"_file"},
    },
    {
        "internalfield" => "servers_file",
        "add_button_text" => $text{"_file"},
    },
    {
        "internalfield" => "conf_dir",
        "add_button_text" => $text{"_dir"},
    },
);

my @tabs = ( );
foreach my $v ( @vals ) {
    push(@tabs, [ $v->{"internalfield"}, $text{"p_desc_" . $v->{"internalfield"}} ]);
}

print ui_tabs_start(\@tabs, 'tab', $tab);

foreach my $v ( @vals ) {
    print ui_tabs_start_tab('tab', $v->{"internalfield"});
    &show_field_table($v->{"internalfield"}, $apply_cgi . "?tab=" . $v->{"internalfield"}, $v->{"add_button_text"}, \%dnsmconfig, $formidx++);
    print ui_tabs_end_tab('tab', $v->{"internalfield"});
}

print ui_tabs_end();

print &add_js();

ui_print_footer("index.cgi?tab=dns", $text{"index_dns_settings"});

### END of dns_addn_config.cgi ###.
