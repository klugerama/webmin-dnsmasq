#!/usr/bin/perl
#
#    DNSMasq Webmin Module - # TODO dns_records.cgi; Upstream Servers config
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

my %access=&get_module_acl;

## put in ACL checks here if needed

my $config_filename = $config{config_file};
my $config_file = &read_file_lines( $config_filename );

&parse_config_file( \%dnsmconfig, \$config_file, $config_filename );

&ReadParse();

&header( $text{"index_title"}, "", "intro", 1, 0, 0, &restart_button(), undef, undef, $text{"index_dns_records_settings"} );

my $returnto = $in{"returnto"} || "dns_records.cgi";
my $returnlabel = $in{"returnlabel"} || $text{"index_dns_records_settings"};
my $apply_cgi = "dns_records_apply.cgi";

my @page_fields = ();
foreach my $configfield ( @confdns ) {
    next if ( %dnsmconfigvals{"$configfield"}->{"page"} ne "5" );
    push( @page_fields, $configfield );
}

@tabs = (   [ 'basic', $text{'index_basic'} ],
            [ 'recs', $text{"index_dns_records"} ],
            [ 'ipset', $text{"index_dns_ipset"} ],
            [ 'connmark', $text{"index_dns_connmark"} ],
        );
my $mode = $in{"mode"} || "basic";
print ui_tabs_start(\@tabs, 'mode', $mode);

print ui_tabs_start_tab('mode', 'basic');
&show_basic_fields( \%dnsmconfig, "dns_records", \@page_fields, $apply_cgi . "?mode=basic", $text{"index_basic"} );
print ui_tabs_end_tab('mode', 'basic');

print ui_tabs_start_tab('mode', 'recs');
&show_other_fields( \%dnsmconfig, "dns_records", \@page_fields, $apply_cgi . "?mode=recs", $text{"index_dns_records"} );
print ui_tabs_end_tab('mode', 'recs');

print ui_tabs_start_tab('mode', 'ipset');
&show_field_table("ipset", $apply_cgi . "?mode=ipset", $text{"_listen"}, \%dnsmconfig);
print ui_tabs_end_tab('mode', 'ipset');

print ui_tabs_start_tab('mode', 'connmark');
&show_field_table("connmark_allowlist", $apply_cgi . "?mode=connmark", $text{"_connmark"}, \%dnsmconfig);
print ui_tabs_end_tab('mode', 'connmark');

print ui_tabs_end();

print &add_js();
ui_print_footer("index.cgi?mode=dns", $text{"index_dns_settings"});

### END of dns_records.cgi ###.
