#!/usr/bin/perl
#
#    DNSMasq Webmin Module - # TODO dns_iface.cgi; network interfaces
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

&header($text{"index_title"}, "", "intro", 1, 0, 0, &restart_button(), undef, undef, $text{"index_dns_iface_settings"});

# print "<h2>";
# print $text{"index_dns_iface_settings"};
# print "</h2><hr/>";

my $returnto = $in{"returnto"} || "dns_iface.cgi";
my $returnlabel = $in{"returnlabel"} || $text{"index_dns_iface_settings"};

my $td_left = "style=\"text-align: left; width: auto;\"";
my $td_right = "style=\"text-align: right; width: auto;\"";
my @tds = ( $td_left, $td_left, $td_left );
sub show_interface {
    my $internalfield = "interface";
    my $configfield = &internal_to_config($internalfield);
    my $edit_link;
    my $hidden_edit_input_fields;
    my $edit_script;
    my $formid = "listen_iface_form";
    my $count=0;
    print &ui_form_start( 'dns_iface_apply.cgi', "post", undef, "id='$formid'" );
    # my @list_link_buttons = &list_links( "sel", 0, "dns_iface_apply.cgi", "interface=new", "dns_iface.cgi", &text("add_", $text{"_iface"}) );
    my @list_link_buttons = &list_links( "sel", 0 );
    my ($iface_chooser_button, $hidden_input_fields, $submit_script) = &add_interface_chooser_button( &text("add_", $text{"_iface"}), "new_listen_iface", $formid );
    print &ui_links_row(\@list_link_buttons);
    print $hidden_input_fields . $iface_chooser_button;
    print &ui_columns_start( [
        "",
        $text{"enabled"},
        $text{"p_label_interface"},
        ], 100, undef, undef, &ui_columns_header( [ &show_title_with_help($internalfield, $configfield) ], [ 'class="table-title" colspan=4' ] ), 1 );
    foreach my $iface ( @{$dnsmconfig{"interface"}} ) {
        local @cols;
        # my $edit = "<a href=iface_edit.cgi?idx=$count>".$$iface{"val"}."</a>"; # TODO edit
        push ( @cols, &ui_checkbox("enabled", "1", "", $iface->{"used"}?1:0, undef, 1) );
        # push ( @cols, $edit );
        push ( @cols, $iface->{"val"} );
        print &ui_checked_columns_row( \@cols, \@tds, "sel", $count );
        $count++;
    }
    print &ui_columns_end();
    print &ui_links_row(\@list_link_buttons);
    print $hidden_input_fields . $iface_chooser_button;
    print "<p>" . $text{"with_selected"} . "</p>";
    print &ui_submit($text{"enable_sel"}, "enable_sel_iface");
    print &ui_submit($text{"disable_sel"}, "disable_sel_iface");
    print &ui_submit($text{"delete_sel"}, "delete_sel_iface");
    print $submit_script;
    print &ui_form_end();
    print &ui_hr();
}

sub show_except_interface {
    my $internalfield = "except_interface";
    my $configfield = &internal_to_config($internalfield);
    my $formid = "except_iface_form";
    my $count=0;
    print &ui_form_start( 'dns_iface_apply.cgi', "post", undef, "id='$formid'" );

    # @list_link_buttons = &list_links( "sel", 1, "dns_iface_apply.cgi", "except-interface=new", "dns_iface.cgi", &text("add_", $text{"_iface"}) );
    my @list_link_buttons = &list_links( "sel", 1 );
    my ($iface_chooser_button, $hidden_input_fields, $submit_script) = &add_interface_chooser_button( &text("add_", $text{"_iface"}), "new_except_iface", $formid );
    print &ui_links_row(\@list_link_buttons);
    print $hidden_input_fields . $iface_chooser_button;
    print &ui_columns_start( [
        "",
        $text{"enabled"},
        $text{"p_label_interface"},
        ], 100, undef, undef, &ui_columns_header( [ &show_title_with_help($internalfield, $configfield) ], [ 'class="table-title" colspan=4' ] ), 1 );
    foreach my $iface ( @{$dnsmconfig{"except-interface"}} ) {
        local @cols;
        # my $edit = "<a href=xiface_edit.cgi?idx=$count>".$$iface{"val"}."</a>"; # TODO edit
        push ( @cols, &ui_checkbox("enabled", "1", "", $iface->{"used"}?1:0, undef, 1) );
        # push ( @cols, $edit );
        push ( @cols, $iface->{"val"} );
        print &ui_checked_columns_row( \@cols, \@tds, "sel", $count );
        $count++;
    }
    print &ui_columns_end();
    print &ui_links_row(\@list_link_buttons);
    print $hidden_input_fields . $iface_chooser_button;
    print "<p>" . $text{"with_selected"} . "</p>";
    print &ui_submit($text{"enable_sel"}, "enable_sel_except_iface");
    print &ui_submit($text{"disable_sel"}, "disable_sel_except_iface");
    print &ui_submit($text{"delete_sel"}, "delete_sel_except_iface");
    print $submit_script;
    print &ui_form_end();
    print &ui_hr();
}

sub show_no_dhcp_interface {
    my $internalfield = "no_dhcp_interface";
    my $configfield = &internal_to_config($internalfield);
    my $edit_link;
    my $hidden_edit_input_fields;
    my $edit_script;
    my $formid = "no_dhcp_iface_form";
    my $count=0;
    print &ui_form_start( 'dns_iface_apply.cgi', "post", undef, "id='$formid'" );
    # @list_link_buttons = &list_links( "sel", 2, "dns_iface_apply.cgi", "no-dhcp-interface=new", "dns_iface.cgi", &text("add_", $text{"_iface"}) );
    my @list_link_buttons = &list_links( "sel", 2 );
    my ($iface_chooser_button, $hidden_input_fields, $submit_script) = &add_interface_chooser_button( &text("add_", $text{"_iface"}), "new_no_dhcp_iface", $formid );
    print &ui_links_row(\@list_link_buttons);
    print $hidden_input_fields . $iface_chooser_button;
    print &ui_columns_start( [
        "",
        $text{"enabled"},
        $text{"p_label_interface"},
        ], 100, undef, undef, &ui_columns_header( [ &show_title_with_help($internalfield, $configfield) ], [ 'class="table-title" colspan=4' ] ), 1 );
    foreach my $iface ( @{$dnsmconfig{"no-dhcp-interface"}} ) {
        local @cols;
        # my $edit = "<a href=xiface_edit.cgi?idx=$count>".$$iface{"val"}."</a>";
        push ( @cols, &ui_checkbox("enabled", "1", "", $iface->{"used"}?1:0, undef, 1) );
        # push ( @cols, $edit );
        push ( @cols, $iface->{"val"} );
        print &ui_checked_columns_row( \@cols, \@tds, "sel", $count );
        $count++;
    }
    print &ui_columns_end();
    print &ui_links_row(\@list_link_buttons);
    print $hidden_input_fields . $iface_chooser_button;
    print "<p>" . $text{"with_selected"} . "</p>";
    print &ui_submit($text{"enable_sel"}, "enable_sel_no_dhcp_iface");
    print &ui_submit($text{"disable_sel"}, "disable_sel_no_dhcp_iface");
    print &ui_submit($text{"delete_sel"}, "delete_sel_no_dhcp_iface");
    print $submit_script;
    print &ui_form_end();
    print &ui_hr();
}

sub show_listen_address {
    my $internalfield = "listen_address";
    my $configfield = &internal_to_config($internalfield);
    my $edit_link;
    my $hidden_edit_input_fields;
    my $edit_script;
    my @newfields = ("val");
    my @editfields = ( "idx", @newfields );
    my $formid = "listen_address_form";
    my $count=0;
    print &ui_form_start( 'dns_iface_apply.cgi', "post", undef, "id='$formid'" );
    # @list_link_buttons = &list_links( "sel", 3, "dns_iface_apply.cgi", "listen-address=0.0.0.0", "dns_iface.cgi", &text("add_", $text{"_addr"}) );
    my @list_link_buttons = &list_links( "sel", 3 );
    my ($add_button, $hidden_add_input_fields, $add_new_script) = &add_item_button(&text("add_", $text{"_listen"}), $internalfield, $text{"p_label_listen_address"}, 700, 355, $formid, \@newfields );
    push(@list_link_buttons, $add_button);
    print &ui_links_row(\@list_link_buttons);
    print $hidden_add_input_fields . $add_new_script;
    print &ui_columns_start( [
        "",
        $text{"enabled"},
        $text{"ip_address"},
        ], 100, undef, undef, &ui_columns_header( [ &show_title_with_help($internalfield, $configfield) ], [ 'class="table-title" colspan=3' ] ), 1 );
    foreach my $address ( @{$dnsmconfig{"listen-address"}} ) {
        local @cols;
        # my $edit = "<a href=listen_edit.cgi?idx=$count>".$$address{"val"}."</a>";
        ($edit_link, $hidden_edit_input_fields, $edit_script) = &edit_item_link($address->{"val"}, $internalfield, $text{"p_label_listen_address"}, $count, $formid, 700, 355, \@editfields);
        push ( @cols, &ui_checkbox("enabled", "1", "", $address->{"used"}?1:0, undef, 1) );
        # push ( @cols, $edit );
        push ( @cols, $edit_link );
        print &ui_checked_columns_row( \@cols, \@tds, "sel", $count );
        $count++;
    }
    print &ui_columns_end();
    print $hidden_edit_input_fields . $edit_script;
    print &ui_links_row(\@list_link_buttons);
    print "<p>" . $text{"with_selected"} . "</p>";
    print &ui_submit($text{"enable_sel"}, "enable_sel_listen_address");
    print &ui_submit($text{"disable_sel"}, "disable_sel_listen_address");
    print &ui_submit($text{"delete_sel"}, "delete_sel_listen_address");
    print &ui_form_end();
    print &ui_hr();
}

@tabs = (   [ 'basic', $text{'index_basic'} ],
            [ 'interface', $text{"p_desc_interface"} ],
            [ 'except_interface', $text{"p_desc_except_interface"} ],
            [ 'no_dhcp_interface', $text{"p_desc_no_dhcp_interface"} ],
            [ 'listen_address', $text{"p_desc_listen_address"} ],
        );
my $mode = $in{mode} || "basic";
print ui_tabs_start(\@tabs, 'mode', $mode);

print ui_tabs_start_tab('mode', 'basic');
my @page_fields = ();
foreach my $configfield ( @confdns ) {
    next if ( %dnsmconfigvals{"$configfield"}->{"page"} ne "3" );
    push( @page_fields, $configfield );
}
&show_basic_fields( \%dnsmconfig, "dns_iface", \@page_fields, "dns_iface_apply.cgi", $text{"index_dns_iface_settings"} );
print ui_tabs_end_tab('mode', 'basic');

print ui_tabs_start_tab('mode', 'interface');
&show_interface();
print ui_tabs_end_tab('mode', 'interface');

print ui_tabs_start_tab('mode', 'except_interface');
&show_except_interface();
print ui_tabs_end_tab('mode', 'except_interface');

print ui_tabs_start_tab('mode', 'no_dhcp_interface');
&show_no_dhcp_interface();
print ui_tabs_end_tab('mode', 'no_dhcp_interface');

print ui_tabs_start_tab('mode', 'listen_address');
&show_listen_address();
print ui_tabs_end_tab('mode', 'listen_address');

print ui_tabs_end();

print &add_js();
ui_print_footer("index.cgi?mode=dns", $text{"index_dns_settings"});

### END of dns_iface.cgi ###.
