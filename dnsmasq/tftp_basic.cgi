#!/usr/bin/perl
#
#    DNSMasq Webmin Module - tftp_basic.cgi; TFTP/Bootp config
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

&ui_print_header($dnsmasq::text{"index_tftp_settings_basic"} . &icon_if_disabled($section), $dnsmasq::text{"index_title"}, undef, "intro", 1, 0, 0, &restart_button());
print &header_js(\%dnsmconfig);
print $error_check_result;

my $returnto = $in{"returnto"} || "tftp_basic.cgi";
my $returnlabel = $in{"returnlabel"} || $dnsmasq::text{"index_tftp_settings_basic"};
my $apply_cgi = "tftp_basic_apply.cgi";

&show_basic_fields( \%dnsmconfig, "tftp_basic", $page_fields, $apply_cgi, $dnsmasq::text{"index_tftp_settings_basic"} );

&show_other_fields( \%dnsmconfig, "tftp_basic", $page_fields, $apply_cgi, " " );

print &add_js();

&ui_print_footer("index.cgi?tab=tftp", $dnsmasq::text{"index_tftp_settings"}, "index.cgi?tab=dns", $dnsmasq::text{"index_dns_settings"});

### END of tftp_basic.cgi ###.
