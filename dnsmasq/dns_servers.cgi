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

sub print_server_form() {
    my $formid = "dns_servers_form";

    print &ui_form_start( "dns_servers_apply.cgi", "post", undef, "id='$formid'" );
    my @tds = ( $td_left, $td_left, $td_left, $td_left, $td_left, $td_left );
    print &ui_columns_start( [
        "",
        "",
        "",
        "",
        "",
        ""
        ], 100, undef, undef, undef, 1 );
    local %authserver = %{ $dnsmconfig->{"auth-server"} };
    local %val = %{ $authserver->{"val"} };
    local @cols;

    # push ( @cols, &ui_checkbox("auth_server_enabled", "1", 10, $authserver->{"used"}?1:0, "id=\"auth_server_enabled\"") );
    # ui_opt_textbox(name, value, size, option1, [option2], [disabled?], [&extra-fields], [max])
    # ui_textbox(name, value, size, [disabled?], [maxlength], [tags])
    push ( @cols, $text{"p_label_auth_server"} . &ui_help($text{"p_man_desc_auth_server"}) );
    push ( @cols, &ui_opt_textbox( "auth_server_domain", $val->{"domain"}, 10, $text{"disabled"}, undef, $authserver->{"used"}?1:0, [ "auth_server_for" ] ) );
    push ( @cols, &ui_textbox( "auth_server_for", $val->{"for"}, 15 ) );
    print &ui_columns_row( \@cols, \@tds );

    print &ui_columns_end();
    # print $button;
    print &ui_hr();
    my @form_buttons = ();
    # push( @form_buttons, &ui_submit( $text{"cancel_button"}, "cancel", undef, "style='display:inline; float:right;'" ) );
    # push( @form_buttons, &ui_submit( $text{"save_button"}, "submit", undef, "style='display:inline !important; float:right;'" ) );
    push( @form_buttons, &ui_submit( $text{"cancel_button"}, "cancel" ) );
    push( @form_buttons, &ui_submit( $text{"save_button"}, "submit" ) );
    print &ui_form_end( \@form_buttons );

}

sub print_upstream_server_form {
    my $formid = "dns_upstream_servers_form";
    my $context = "server";
    my @newfields = ("domain", "ip", "source");
    my @editfields = ( "idx", @newfields );
    my @list_link_buttons = &list_links( "sel", 0 );
    my ($button, $hidden_add_input_fields, $add_new_script) = &add_item_button(&text("add_", $text{"_upstream_srv"}), $context, $text{"index_dns_servers"}, 700, 505, $formid, \@newfields );
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
        ], 100, undef, undef, &ui_columns_header( [ $text{"table_upstream_dns_servers"} . &ui_help($text{"p_man_desc_server"}) ], [ 'class="table-title" colspan=5' ] ), 1 );
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
    print $hidden_add_input_fields;
    print $add_new_script;
    print &ui_hr();
    print $hidden_edit_input_fields . $edit_script;
    print &ui_form_end();
}

&print_server_form();
&print_upstream_server_form();
print &add_js(1,1,0);

ui_print_footer("index.cgi?mode=dns", $text{"index_dns_settings"});

### END of dns_servers.cgi ###.
