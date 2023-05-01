#!/usr/bin/perl
#
#    DNSMasq Webmin Module - dhcp.cgi; DHCP config
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

&header($text{"index_title"}, "", "intro", 1, 0, 0, &restart_button());

my $config_filename = $config{config_file};
my $config_file = &read_file_lines( $config_filename );

&parse_config_file( \%dnsmconfig, \$config_file, \$config_filename );

@links = ( );
push(@links, &select_all_link("e"),
            &select_invert_link("e"));
my $count;
my $width;
$count=0;
$width="width=auto";
print "<h2>".$text{"dhcp_options"}."</h2>";
print &ui_form_start( 'dhcp_apply.cgi', "get" );
print &ui_links_row(\@links);
print &ui_columns_start( [
    $text{"dhcp_option"},
    $text{"value"},
    $text{"dhcp_tag"},
    $text{"vendor"},
    $text{"dhcp_encap"},
    $text{"forced"},
    # $text{"enabled"}
    ], 100 );
foreach my $option ( @{$dnsmconfig{"dhcp-option"}} ) {
    my $edit = "<a href=option_edit.cgi?idx=$count>".$option->{"val"}->{"option"}."</a>";
    my $forced_cb = &ui_checkbox("forced", "1", "", $option->{"val"}->{"forced"});
    my $enabled_cb = &ui_checkbox("used", "1", "", $option->{"used"});
    print &ui_checked_columns_row( [
            $edit,
            $option->{"val"}->{"value"},
            $option->{"val"}->{"tag"},
            $option->{"val"}->{"vendor"},
            $option->{"val"}->{"encap"},
            $forced_cb,
            # $enabled_cb
            ],
            [ $width, $width, $width, $width, $width, $width ] );
    $count++;
}
print &ui_columns_end();
print &ui_links_row(\@links);
print &ui_form_end( );
print "<br><a href=add.cgi?what=dhcp-option=27&where=dhcp.cgi>".
    $text{"add_"}." ".$text{"_dhcp"}."</a><br><hr><br>";

print &ui_form_start( 'dhcp_apply.cgi', "get" );
print "<h2>".$text{"misc"}."</h2><br>";
print $text{"dhcp_authoritative"}."(".$dnsmconfig{"dhcp-authoritative"}->{"line"}.")".&ui_yesno_radio( "dhcp-authoritative", 
            ($dnsmconfig{"dhcp-authoritative"}->{"used"})?1:0 );
print "<br><br>".$text{"read_ethers"}.&ui_yesno_radio( "ethers", 
            ($dnsmconfig{"read-ethers"}->{"used"})?1:0 );
print "<br><br>".$text{"use_bootp"}.&ui_yesno_radio ( "bootp",
            ($dnsmconfig{"dhcp-boot"}->{"used"})?1:0 );
print "<br>".$text{"bootp_host"}.&ui_textbox( "bootp_host",
            $dnsmconfig{"dhcp-boot"}->{"val"}->{"host"}, 80 );
print "<br>".$text{"bootp_file"}.&ui_textbox( "bootp_file",
            $dnsmconfig{"dhcp-boot"}->{"val"}->{"filename"}, 80 );
print "<br>".$text{"bootp_address"}.&ui_textbox( "bootp_addr",
            $dnsmconfig{"dhcp-boot"}->{"val"}->{"address"}, 80 );
print "<br><br>".$text{"max_leases"}.&ui_textbox( "max_leases",
            $dnsmconfig{"dhcp-leasemax"}->{"val"}->{"max"}, 10 );
print "<br><br>".$text{"leasefile"}.&ui_yesno_radio( "useleasefile",
            ($dnsmconfig{"dhcp-leasefile"}->{"used"})?1:0 );
print "<br>".$text{"lfiletouse"}.&ui_textbox( "leasefile",
            $dnsmconfig{"dhcp-leasefile"}->{"val"}->{"filename"}, 80 );
print "<br><br>".&ui_submit( $text{"save_button"} );
print &ui_form_end( );
ui_print_footer("index.cgi?mode=dhcp", $text{"dhcp_settings"}, "index.cgi?mode=dns", $text{"index_dns_settings"});

### END of dhcp_basic.cgi ###.
