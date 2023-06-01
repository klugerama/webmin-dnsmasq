#!/usr/bin/perl
#
#    DNSMasq Webmin Module - # TODO dns_servers.cgi; Upstream Servers config
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

&header( "DNSMasq settings", "" );

print "<h2>";
print $text{"index_dns_servers"};
print "</h2>";

my $formid = "dns_servers_form";
my $context = "server";
my @newfields = ("domain", "ip", "source");
my @editfields = ( "idx", @newfields );
my @list_link_buttons = &list_links( "sel", 0 );
my ($button, $hidden_add_input_fields, $add_new_script) = &add_item_button(&text("add_", $text{"_srv"}), $context, $text{"index_dns_servers"}, 700, 505, $formid, \@newfields );
# my @list_link_buttons = &list_links( "sel", 0, "dns_servers_apply.cgi", "server=0.0.0.0", "dns_servers.cgi", &text("add_", $text{"_dns_serv"}) );
push(@list_link_buttons, $button);

my $count=0;
print &ui_form_start( "dns_servers_apply.cgi", "post", undef, "id='$formid'" );
print &ui_links_row(\@list_link_buttons);
my $edit_link_domain;
my $edit_link_ip;
my $edit_link_source;
my $hidden_edit_input_fields;
my $edit_script;
my @tds = ( $td_left, $td_left, $td_left, $td_left, $td_left, $td_left );
print &ui_columns_start( [
    "",
    $text{"enabled"},
    $text{"domain"},
    $text{"ip_address"},
    $text{"source"},
    ""
    ], 100, undef, undef, &ui_columns_header( [ $text{"index_dns_servers"} . &ui_help($text{"p_man_desc_server"}) ], [ 'class="table-title" colspan=5' ] ), 1 );
foreach my $server ( @{$dnsmconfig{"server"}} ) {
    local %val = %{ $server->{"val"} };
    local @cols;
    local ( $mover, $edit );
    $mover = &get_mover_buttons("srv_move.cgi", $count, int(@{$dnsmconfig{"server"}}) );
    # $edit = "<a href=dns_servers_edit.cgi?idx=$count>".$val{"ip"}."</a>";
    ($edit_link_domain, $hidden_edit_input_fields, $edit_script) = &edit_item_link(join(",", @{$val{"domain"}}), $context, $text{"index_dns_servers"}, $count, $formid, 700, 505, \@editfields);
    ($edit_link_ip) = &edit_item_link($val{"ip"}, $context, $text{"index_dns_servers"}, $count, $formid, 700, 505, \@editfields);
    ($edit_link_source) = &edit_item_link($val{"source"}, $context, $text{"index_dns_servers"}, $count, $formid, 700, 505, \@editfields);
    push ( @cols, &ui_checkbox("enabled", "1", "", $server->{"used"}?1:0, undef, 1) );
    push ( @cols, $edit_link_domain );
    push ( @cols, $edit_link_ip );
    push ( @cols, $edit_link_source );
    push ( @cols, $mover );
    print &ui_checked_columns_row( \@cols, \@tds, "sel", $count );
    $count++;
}
print &ui_columns_end();
print &ui_links_row(\@list_link_buttons);
print "<p>" . $text{"with_selected"} . "</p>";
print &ui_submit($text{"enable_sel"}, "enable_sel");
print &ui_submit($text{"disable_sel"}, "disable_sel");
print &ui_submit($text{"delete_sel"}, "delete_sel");
# print $button;
print $hidden_add_input_fields;
print $add_new_script;
print &add_js(1,1,0);
print &ui_hr();
print $hidden_edit_input_fields . $edit_script;
print &ui_form_end();
ui_print_footer("index.cgi?mode=dns", $text{"index_dns_settings"});

### END of dns_servers.cgi ###.
