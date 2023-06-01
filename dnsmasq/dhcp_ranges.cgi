#!/usr/bin/perl
#
#    DNSMasq Webmin Module - # TODO dhcp_ranges.cgi; DHCP ranges config
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

&parse_config_file( \%dnsmconfig, \$config_file, $config_filename );

my @list_link_buttons = &list_links( "sel", 0, "dhcp_range_apply.cgi", "dhcp-range=0.0.0.0,0.0.0.0", "dhcp_ranges.cgi", &text("add_", $text{"_range"}) );

my $count;
$count=0;
print &ui_links_row(\@list_link_buttons);
print &ui_columns_start( [ 
    # $text{"net_id"},
    "",
    $text{"enabled"},
    $text{"from_ip"},
    $text{"to_ip"},
    $text{"mask"},
    $text{"leasetime"},
    $text{"dhcp_if_tags"}, 
    $text{"dhcp_set_tags"}, 
    $text{"flags"},
    ], 100, undef, undef, &ui_columns_header( [ $text{"index_dhcp_range"} . &ui_help($text{"p_man_desc_dhcp_range"}) ], [ 'class="table-title" colspan=4' ] ), 1 );
foreach my $range ( @{$dnsmconfig{"dhcp-range"}} ) {
    local @cols;
    my $edit = "<a href=range_edit.cgi?idx=$count>".$range->{"val"}->{"start"}."</a>";
    my $if_tags = "";
    my $set_tags = "";
    if ($range->{"val"}->{"tag"}) {
        foreach my $tag ( @{ $range->{"val"}->{"tag"}} ) {
            if ( $tag->{"tag-set"} ) {
                if ( $set_tags ne "" ) {
                    $set_tags .= ",";
                }
                $set_tags .= $tag->{"tagname"};
            }
            else {
                if ( $if_tags ne "" ) {
                    $if_tags .= ",";
                }
                $if_tags .= $tag->{"tagname"};
            }
        }
    }
    push ( @cols, &ui_checkbox("enabled", "1", "", $range->{"used"}?1:0, undef, 1) );
    push ( @cols, $edit );
    push ( @cols, $range->{"val"}->{"end"} );
    push ( @cols, $range->{"val"}->{"mask"} );
    push ( @cols, $range->{"val"}->{"leasetime"} );
    push ( @cols, $if_tags );
    push ( @cols, $set_tags );
    push ( @cols, $range->{"val"}->{"ra-only"}."-".$range->{"val"}->{"ra-names"}."-".$range->{"val"}->{"ra-stateless"}."-".$range->{"val"}->{"slaac"} );
    print &ui_checked_columns_row( \@cols, undef, "sel", $count );
    $count++;
}
print &ui_columns_end();
print &ui_links_row(\@list_link_buttons);
print &ui_submit($text{"enable_sel"}, "enable_sel");
print &ui_submit($text{"disable_sel"}, "disable_sel");
print &ui_submit($text{"delete_sel"}, "delete_sel");
print &ui_form_end( );
ui_print_footer("index.cgi?mode=dhcp", $text{"index_dhcp_settings"}, "index.cgi?mode=dns", $text{"index_dns_settings"});

### END of dhcp_ranges.cgi ###.
