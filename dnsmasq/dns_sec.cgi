#!/usr/bin/perl
#
#    DNSMasq Webmin Module - # TODO dns_sec.cgi; authoritative DNS settings
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

&header( $text{"index_title"}, "", "intro", 1, 0, 0, &restart_button(), undef, undef, $text{"index_dns_sec_settings"} );
print &header_style();

my $returnto = $in{"returnto"} || "dns_sec.cgi";
my $returnlabel = $in{"returnlabel"} || $text{"index_dns_sec_settings"};
my $apply_cgi = "dns_sec_apply.cgi";

my @page_fields = ();
foreach my $configfield ( @confdns ) {
    next if ( %dnsmconfigvals{"$configfield"}->{"page"} ne "6" );
    push( @page_fields, $configfield );
}

sub show_dnssec() {
    my $formid = "dns_sec_form";

    print &ui_form_start( $apply_cgi, "post", undef, "id='$formid'" );
    my @tds = ( $td_label, $td_left, $td_left, $td_left, $td_left, $td_left );
    print &ui_columns_start( [
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        ""
        ], 100, undef, undef, undef, 1 );
    local @cols;
    @cols = &get_field_auto_columns($dnsmconfig, "trust_anchor", 8);
    print &ui_columns_row( \@cols, \@tds );
    @cols = &get_field_auto_columns($dnsmconfig, "dnssec_timestamp", 8);
    print &ui_columns_row( \@cols, \@tds );

    print &ui_columns_end();
    print &ui_hr();
    my @form_buttons = ();
    push( @form_buttons, &ui_submit( $text{"cancel_button"}, "cancel" ) );
    push( @form_buttons, &ui_submit( $text{"save_button"}, "submit" ) );
    print &ui_form_end( \@form_buttons );

}

&show_basic_fields( \%dnsmconfig, "dns_sec", \@page_fields, $apply_cgi, $text{"index_dns_sec"} );

&show_other_fields( \%dnsmconfig, "dns_sec", \@page_fields, $apply_cgi, "" );

# &show_dnssec();

print &add_js();

ui_print_footer("index.cgi?mode=dns", $text{"index_dns_settings"});

### END of dns_sec.cgi ###.
