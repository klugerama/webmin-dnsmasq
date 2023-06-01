#!/usr/bin/perl
#
#    DNSMasq Webmin Module - # TODO dhcp_client_options.cgi; DHCP client option settings
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

&header($text{"index_title"}, "", "intro", 1, 0, 0, &restart_button());

my @list_link_buttons = &list_links( "sel", 0, "option_edit.cgi", "dhcp-option=27", "dhcp_client_options.cgi", &text("add_", $text{"_dhcp_option"}) );

my $count;
$count=0;
print &ui_form_start( 'dhcp_client_options_apply.cgi', "post" );
print &ui_links_row(\@list_link_buttons);
print &ui_columns_start( [
    "",
    $text{"enabled"},
    $text{"_dhcp_option"},
    $text{"value"},
    $text{"dhcp_tag_s"},
    $text{"vendor"},
    $text{"dhcp_encap"},
    $text{"forced"},
    ], 100, undef, undef, &ui_columns_header( [ $text{"dhcp_options"} ], [ 'class="table-title" colspan=8' ] ), 1 );
foreach my $option ( @{$dnsmconfig{"dhcp-option"}} ) {
    local @cols;
    local %val = %{ $option->{"val"} };
    local $tags = "";
    if ($val{"tag"} > 0) {
        $tags = join ",", @{ $val{"tag"} };
    }
    push ( @cols, &ui_checkbox("enabled", "1", "", $option->{"used"}?1:0, undef, 1) );
    push ( @cols, "<a href=option_edit.cgi?idx=$count>".$val{"option"}."</a>" );
    push ( @cols, $val{"value"} ? $val{"value"} : "" );
    push ( @cols, $tags );
    push ( @cols, $val{"vendor"} ? $val{"vendor"} : "" );
    push ( @cols, $val{"encap"} ? $val{"encap"} : "" );
    push ( @cols, &ui_checkbox("forced", "1", "", $val{"forced"}, undef, 1) );
    print &ui_checked_columns_row( \@cols, undef, "sel", $count );
    $count++;
}
print &ui_columns_end();
print &ui_links_row(\@list_link_buttons);
print "<p>" . $text{"with_selected"} . "</p>";
print &ui_submit($text{"enable_sel"}, "enable_sel");
print &ui_submit($text{"disable_sel"}, "disable_sel");
print &ui_submit($text{"delete_sel"}, "delete_sel");
print &ui_hr();
print &ui_form_end();

&ui_print_footer("index.cgi?mode=dhcp", $text{"index_dhcp_settings"}, "index.cgi?mode=dns", $text{"index_dns_settings"});

### END of dhcp_basic.cgi ###.
