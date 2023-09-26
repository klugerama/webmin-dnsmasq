#!/usr/bin/perl
#
#    DNSMasq Webmin Module - dns_basic.cgi; basic DNS config     
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

my ($error_check_action, $error_check_result) = &check_for_file_errors( $0, $text{"index_title"}, \%dnsmconfig );
if ($error_check_action eq "redirect") {
    &redirect ( $error_check_result );
}

&ui_print_header($text{"index_dns_settings_basic"}, $text{"index_title"}, "", "intro", 1, 0, 0, &restart_button());
print &header_js();
print $error_check_result;

my $table_header_warn = "";
if (%dnsmconfig{"port"}->{"used"} && %dnsmconfig{"port"}->{"val"} eq "0") {
    $table_header_warn = " <div " . &get_class_tag([$dnsm_header_warn_box_class, $warn_class]) . ">" . $text{"dns_disabled"} . " " . &ui_help($text{"dns_disabled_help"}) . "</div>";
}

my $tab = $in{"tab"} || "basic";
my $returnto = $in{"returnto"} || "dns_basic.cgi";
my $returnlabel = $in{"returnlabel"} || $text{"index_dns_settings_basic"};
my $apply_cgi = "dns_basic_apply.cgi";
my @tds = ( &get_class_tag($td_left_class), &get_class_tag($td_left_class), &get_class_tag($td_left_class) );
our $formidx = 1;

my @vals = (
    {
        "internalfield" => "addn_hosts",
        "add_button_text" => $text{"_hostsfile"},
        "val_label" => $text{"p_label_val_filename"},
        "chooser_mode" => 0
    },
    {
        "internalfield" => "hostsdir",
        "add_button_text" => $text{"_hostsdir"},
        "val_label" => $text{"p_label_val_directory"},
        "chooser_mode" => 1
    },
    {
        "internalfield" => "resolv_file",
        "add_button_text" => $text{"_resolvfile"},
        "val_label" => $text{"p_label_val_filename"},
        "chooser_mode" => 0
    },
);

my @page_fields = ();
foreach my $configfield ( @confdns ) {
    next if ( %dnsmconfigvals{"$configfield"}->{"page"} ne "1" );
    push( @page_fields, $configfield );
}
my @tabs = ( [ 'basic', $text{'index_basic'} ] );
foreach my $v ( @vals ) {
    push(@tabs, [ $v->{"internalfield"}, $text{"p_desc_" . $v->{"internalfield"}} ]);
}
print ui_tabs_start(\@tabs, 'tab', $tab);

print ui_tabs_start_tab('tab', 'basic');
&show_basic_fields( \%dnsmconfig, "dns_basic", \@page_fields, $apply_cgi . "?tab=basic", $text{"index_dns_settings_basic"} );
print ui_tabs_end_tab('tab', 'basic');

foreach my $v ( @vals ) {
    print ui_tabs_start_tab('tab', $v->{"internalfield"});
    &show_path_list($v->{"internalfield"}, $apply_cgi . "?tab=" . $v->{"internalfield"}, $v->{"add_button_text"}, $v->{"val_label"}, $v->{"chooser_mode"}, $formidx++);
    print ui_tabs_end_tab('tab', $v->{"internalfield"});
}

print ui_tabs_end();

print &add_js();

ui_print_footer("index.cgi?tab=dns", $text{"index_dns_settings"});

### END of dns_basic.cgi ###.
