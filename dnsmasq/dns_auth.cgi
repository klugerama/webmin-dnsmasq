#!/usr/bin/perl
#
#    DNSMasq Webmin Module - # TODO dns_auth.cgi; authoritative DNS settings
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

&header( $text{"index_title"}, "", "intro", 1, 0, 0, &restart_button(), undef, undef, $text{"index_dns_auth_settings"} );

# print "<h2>";
# print $text{"index_dns_auth_settings"};
# print "</h2>";

my $returnto = $in{"returnto"} || "dns_auth.cgi";
my $returnlabel = $in{"returnlabel"} || $text{"index_dns_auth_settings"};
my $apply_cgi = "dns_auth_apply.cgi";

my @page_fields = ();
foreach my $configfield ( @confdns ) {
    next if ( %dnsmconfigvals{"$configfield"}->{"page"} ne "7" );
    push( @page_fields, $configfield );
}

&show_basic_fields( \%dnsmconfig, "dns_auth", \@page_fields, $apply_cgi, $text{"index_basic"} );

&show_other_fields( \%dnsmconfig, "dns_auth", \@page_fields, $apply_cgi, " " );

print &add_js();

ui_print_footer("index.cgi?mode=dns", $text{"index_dns_settings"});

### END of dns_auth.cgi ###.
