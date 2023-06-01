#!/usr/bin/perl
#
#    DNSMasq Webmin Module - # TODO dhcp_reservations.cgi; DHCP reservations config
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

my @list_link_buttons = &list_links( "sel", 0, "dhcp_res_apply.cgi", "dhcp-host=new,0.0.0.0", "dhcp_reservations.cgi", &text("add_", $text{"_host"}) );

my $count;
my $width;
$count=0;
$width="width=auto";
print &ui_form_start( 'dhcp_res_apply.cgi', "post" );
print &ui_links_row(\@list_link_buttons);
print &ui_columns_start( [ 
    # "line", 
    "",
    $text{"enabled"}, 
    $text{"dhcp_res_name"}, 
    $text{"dhcp_res_ip"}, 
    $text{"dhcp_res_mac"}, 
    $text{"dhcp_res_ignore_client_id"}, 
    $text{"dhcp_res_tag"}, 
    $text{"dhcp_res_time"}, 
    # "full" 
], 100, undef, undef, &ui_columns_header( [ $text{"dhcp_res_title"} . &ui_help($text{"p_man_desc_dhcp_host"}) ], [ 'class="table-title" colspan=4' ] ), 1 );
foreach my $host ( @{$dnsmconfig{"dhcp-host"}} ) {
    local @cols;
    if ($host->{"val"}->{"ipversion"} == 4) {
        my $edit = "<a href=host_edit.cgi?idx=$count>".$host->{"val"}->{"id"}."</a>";
        push ( @cols, &ui_checkbox("enabled", "1", "", $host->{"used"}?1:0, undef, 1) );
        push ( @cols, $edit );
        push ( @cols, $host->{"val"}->{"ip"} );
        push ( @cols, $host->{"val"}->{"infiniband"} . $host->{"val"}->{"clientid"} . $host->{"val"}->{"mac"} );
        push ( @cols, $host->{"val"}->{"ignore_clientid"} );
        push ( @cols, $host->{"val"}->{"tagname"} );
        push ( @cols, $host->{"val"}->{"leasetime"} );
        print &ui_checked_columns_row( \@cols, undef, "sel", $count );
    }
    $count++;
}
print &ui_columns_end();
print &ui_links_row(\@list_link_buttons);
print &ui_submit($text{"enable_sel"}, "enable_sel");
print &ui_submit($text{"disable_sel"}, "disable_sel");
print &ui_submit($text{"delete_sel"}, "delete_sel");
print &ui_form_end( );

@list_link_buttons = &list_links( "sel", 1, "dhcp_res_apply.cgi", "dhcp-host=new,0.0.0.0", "dhcp_reservations.cgi", &text("add_", $text{"_host"}) );

$count=0;
$width="width=auto";
print &ui_form_start( 'dhcp_res_apply.cgi', "get" );
print &ui_links_row(\@list_link_buttons);
print &ui_columns_start( [ 
    # "line", 
    "",
    $text{"enabled"},
    $text{"dhcp_res_name"}, 
    $text{"dhcp_res_ip"}, 
    $text{"dhcp_res_mac"}, 
    $text{"dhcp_res_ignore_client_id"}, 
    $text{"dhcp_res_tag"}, 
    $text{"dhcp_res_time"}, 
    # "full" 
], 100, undef, undef, &ui_columns_header( [ $text{"dhcp6_res_title"} ], [ 'class="table-title" colspan=4' ] ), 1 );
foreach my $host ( @{$dnsmconfig{"dhcp-host"}} ) {
    if ($host->{"val"}->{"ipversion"} == 6) {
        my $edit = "<a href=host_edit.cgi?idx=$count>".$host->{"val"}->{"id"}."</a>";
        push ( @cols, &ui_checkbox("enabled", "1", "", $host->{"used"}?1:0, undef, 1) );
        push ( @cols, $edit );
        push ( @cols, $host->{"val"}->{"ip"} );
        push ( @cols, $host->{"val"}->{"infiniband"} . $host->{"val"}->{"clientid"} . $host->{"val"}->{"mac"} );
        push ( @cols, $host->{"val"}->{"ignore_clientid"} );
        push ( @cols, $host->{"val"}->{"tagname"} );
        push ( @cols, $host->{"val"}->{"leasetime"} );
        print &ui_checked_columns_row( \@cols, undef, "sel", $count );
        print &ui_hidden("id_" . $count . "_line", $host->{"line"});
        print &ui_hidden("id_" . $count . "_file", $host->{"file"});
    }
    $count++;
}
print &ui_columns_end();
print &ui_links_row(\@list_link_buttons);
print &ui_submit($text{"enable_sel"}, "enable_sel");
print &ui_submit($text{"disable_sel"}, "disable_sel");
print &ui_submit($text{"delete_sel"}, "delete_sel");
print &ui_form_end( );
ui_print_footer("index.cgi?mode=dhcp", $text{"index_dhcp_settings"}, "index.cgi?mode=dns", $text{"index_dns_settings"});

### END of dhcp_reservations.cgi ###.
