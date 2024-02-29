#!/usr/bin/perl
#
#    DNSMasq Webmin Module - dhcp_domain_name.cgi; DHCP domain name config     
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

require "dnsmasq-lib.pl";

## put in ACL checks here if needed

my $config_filename = $config{config_file};
my $config_file = &read_file_lines( $config_filename );

&parse_config_file( \%dnsmconfig, \$config_file, $config_filename );

&ReadParse();

my ($error_check_action, $error_check_result) = &check_for_file_errors( $0, $dnsmasq::text{"index_title"}, \%dnsmconfig );
if ($error_check_action eq "redirect") {
    &redirect ( $error_check_result );
}

my ($section, $page) = &get_context($0);

&ui_print_header($dnsmasq::text{"index_dhcp_domain_name"} . &icon_if_disabled($section), $dnsmasq::text{"index_title"}, "", "intro", 1, 0, 0, &restart_button());
print &header_js(\%dnsmconfig);
print $error_check_result;

my $returnto = $in{"returnto"} || "dhcp_domain_name.cgi";
my $returnlabel = $in{"returnlabel"} || $dnsmasq::text{"index_dhcp_domain_name"};
my $apply_cgi = "dhcp_domain_name_apply.cgi";

&show_field_table("domain", $apply_cgi, $dnsmasq::text{"_domain"}, \%dnsmconfig, 1);

print &add_js();

&ui_print_footer("index.cgi?tab=dhcp", $dnsmasq::text{"index_dhcp_settings"}, "index.cgi?tab=dns", $dnsmasq::text{"index_dns_settings"});

### END of dhcp_domain_name.cgi ###.
