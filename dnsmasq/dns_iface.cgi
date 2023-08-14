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
# read posted data
&ReadParse();

# &header($text{"index_title"}, "", "intro", 1, 0, 0, &restart_button(), undef, undef, $text{"index_dns_iface_settings"});
&header($text{"index_title"}, "", "intro", 1, 0, 0, &restart_button(), "<script type='text/javascript'>//test</script>", "body-stuff-test", $text{"index_dns_iface_settings"});

my $returnto = $in{"returnto"} || "dns_iface.cgi";
my $returnlabel = $in{"returnlabel"} || $text{"index_dns_iface_settings"};
my $apply_cgi = "dns_iface_apply.cgi";

my @tds = ( $td_left, $td_left, $td_left );

sub show_interface {
    my $internalfield = "interface";
    my $configfield = &internal_to_config($internalfield);
    my $edit_link;
    my $hidden_edit_input_fields;
    my $formid = "listen_iface_form";
    my $count=0;
    print &ui_form_start( $apply_cgi . "?mode=$internalfield", "post", undef, "id='$formid'" );
    # my @list_link_buttons = &list_links( "sel", 0, $apply_cgi, "interface=new", "dns_iface.cgi", &text("add_", $text{"_iface"}) );
    my @list_link_buttons = &list_links( "sel", 0 );
    my ($iface_chooser_button, $hidden_input_fields, $submit_script) = &add_interface_chooser_button( &text("add_", $text{"_iface"}), "new_listen_iface", $formid );
    print &ui_links_row(\@list_link_buttons);
    print $hidden_input_fields . $iface_chooser_button;
    print &ui_columns_start( [
        "",
        $text{"enabled"},
        $text{"p_label_interface"},
        ], 100, undef, undef, &ui_columns_header( [ &show_title_with_help($internalfield, $configfield) ], [ 'class="table-title" colspan=4' ] ), 1 );
    foreach my $item ( @{$dnsmconfig{"interface"}} ) {
        local @cols;
        push ( @cols, &ui_checkbox("enabled", "1", "", $item->{"used"}?1:0, undef, 1) );
        push ( @cols, $item->{"val"} );
        print &ui_clickable_checked_columns_row( \@cols, \@tds, "sel", $count );
        $count++;
    }
    print &ui_columns_end();
    print &ui_links_row(\@list_link_buttons);
    print $hidden_input_fields . $iface_chooser_button;
    print "<p>" . $text{"with_selected"} . "</p>";
    print &ui_submit($text{"enable_sel"}, "enable_sel_$internalfield");
    print &ui_submit($text{"disable_sel"}, "disable_sel_$internalfield");
    print &ui_submit($text{"delete_sel"}, "delete_sel_$internalfield");
    print $submit_script;
    print &ui_form_end();
    print &ui_hr();
}

sub show_except_interface {
    my $internalfield = "except_interface";
    my $configfield = &internal_to_config($internalfield);
    my $formid = "except_iface_form";
    my $count=0;
    print &ui_form_start( $apply_cgi . "?mode=$internalfield", "post", undef, "id='$formid'" );

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
    foreach my $item ( @{$dnsmconfig{"except-interface"}} ) {
        local @cols;
        push ( @cols, &ui_checkbox("enabled", "1", "", $item->{"used"}?1:0, undef, 1) );
        push ( @cols, $item->{"val"} );
        print &ui_clickable_checked_columns_row( \@cols, \@tds, "sel", $count );
        $count++;
    }
    print &ui_columns_end();
    print &ui_links_row(\@list_link_buttons);
    print $hidden_input_fields . $iface_chooser_button;
    print "<p>" . $text{"with_selected"} . "</p>";
    print &ui_submit($text{"enable_sel"}, "enable_sel_$internalfield");
    print &ui_submit($text{"disable_sel"}, "disable_sel_$internalfield");
    print &ui_submit($text{"delete_sel"}, "delete_sel_$internalfield");
    print $submit_script;
    print &ui_form_end();
    print &ui_hr();
}

sub show_no_dhcp_interface {
    my $internalfield = "no_dhcp_interface";
    my $configfield = &internal_to_config($internalfield);
    my $edit_link;
    my $hidden_edit_input_fields;
    my $formid = "no_dhcp_iface_form";
    my $count=0;
    print &ui_form_start( $apply_cgi . "?mode=$internalfield", "post", undef, "id='$formid'" );
    my @list_link_buttons = &list_links( "sel", 2 );
    my ($iface_chooser_button, $hidden_input_fields, $submit_script) = &add_interface_chooser_button( &text("add_", $text{"_iface"}), "new_no_dhcp_iface", $formid );
    print &ui_links_row(\@list_link_buttons);
    print $hidden_input_fields . $iface_chooser_button;
    print &ui_columns_start( [
        "",
        $text{"enabled"},
        $text{"p_label_interface"},
        ], 100, undef, undef, &ui_columns_header( [ &show_title_with_help($internalfield, $configfield) ], [ 'class="table-title" colspan=4' ] ), 1 );
    foreach my $item ( @{$dnsmconfig{"no-dhcp-interface"}} ) {
        local @cols;
        push ( @cols, &ui_checkbox("enabled", "1", "", $item->{"used"}?1:0, undef, 1) );
        push ( @cols, $item->{"val"} );
        print &ui_clickable_checked_columns_row( \@cols, \@tds, "sel", $count );
        $count++;
    }
    print &ui_columns_end();
    print &ui_links_row(\@list_link_buttons);
    print $hidden_input_fields . $iface_chooser_button;
    print "<p>" . $text{"with_selected"} . "</p>";
    print &ui_submit($text{"enable_sel"}, "enable_sel_$internalfield");
    print &ui_submit($text{"disable_sel"}, "disable_sel_$internalfield");
    print &ui_submit($text{"delete_sel"}, "delete_sel_$internalfield");
    print $submit_script;
    print &ui_form_end();
    print &ui_hr();
}

sub show_listen_address {
    my $internalfield = "listen_address";
    my $configfield = &internal_to_config($internalfield);
    my @newfields = ("val");
    my @editfields = ( "idx", @newfields );
    my $formid = $internalfield . "_form";
    my @list_link_buttons = &list_links( "sel", 3 );
    my ($add_new_button, $hidden_add_input_fields) = &add_item_button(&text("add_", $text{"_listen"}), $internalfield, $text{"p_label_listen_address"}, 700, 355, $formid, \@newfields );
    push(@list_link_buttons, $add_new_button);

    my $count=0;
    print &ui_form_start( $apply_cgi . "?mode=$internalfield", "post", undef, "id='$formid'" );
    print &ui_links_row(\@list_link_buttons);
    my $edit_link;
    my $w = 700;
    my $h = 505;
    my $hidden_edit_input_fields;
    print &ui_columns_start( [
        "",
        $text{"enabled"},
        $text{"ip_address"},
        ], 100, undef, undef, &ui_columns_header( [ &show_title_with_help($internalfield, $configfield) ], [ 'class="table-title" colspan=3' ] ), 1 );
    foreach my $item ( @{$dnsmconfig{$configfield}} ) {
        local @cols;
        ($edit_link, $hidden_edit_input_fields) = &edit_item_link($item->{"val"}, $internalfield, $text{"p_label_$internalfield"}, $count, $formid, $w, $h, \@editfields);
        push ( @cols, &ui_checkbox("enabled", "1", "", $item->{"used"}?1:0, undef, 1) );
        push ( @cols, $edit_link );
        print &ui_clickable_checked_columns_row( \@cols, \@tds, "sel", $count );
        $count++;
    }
    print &ui_columns_end();
    print &ui_links_row(\@list_link_buttons);
    print "<p>" . $text{"with_selected"} . "</p>";
    print &ui_submit($text{"enable_sel"}, "enable_sel_$internalfield");
    print &ui_submit($text{"disable_sel"}, "disable_sel_$internalfield");
    print &ui_submit($text{"delete_sel"}, "delete_sel_$internalfield");
    print $hidden_add_input_fields;
    print $hidden_edit_input_fields;
    print &ui_form_end();
    print &ui_hr();
}

@tabs = (   [ 'basic', $text{'index_basic'} ],
            [ 'interface', $text{"p_desc_interface"} ],
            [ 'except_interface', $text{"p_desc_except_interface"} ],
            [ 'no_dhcp_interface', $text{"p_desc_no_dhcp_interface"} ],
            [ 'listen_address', $text{"p_desc_listen_address"} ],
        );
my $mode = $in{"mode"} || "basic";
print ui_tabs_start(\@tabs, 'mode', $mode);

print ui_tabs_start_tab('mode', 'basic');
my @page_fields = ();
foreach my $configfield ( @confdns ) {
    next if ( %dnsmconfigvals{"$configfield"}->{"page"} ne "3" );
    push( @page_fields, $configfield );
}
&show_basic_fields( \%dnsmconfig, "dns_iface", \@page_fields, $apply_cgi, $text{"index_dns_iface_settings"} );
print ui_tabs_end_tab('mode', 'basic');

print ui_tabs_start_tab('mode', 'interface');
# &show_interface();
&show_field_table("interface", $apply_cgi . "?mode=interface", $text{"_iface"}, \%dnsmconfig);
print ui_tabs_end_tab('mode', 'interface');

print ui_tabs_start_tab('mode', 'except_interface');
# &show_except_interface();
&show_field_table("except_interface", $apply_cgi . "?mode=except_interface", $text{"_iface"}, \%dnsmconfig);
print ui_tabs_end_tab('mode', 'except_interface');

print ui_tabs_start_tab('mode', 'no_dhcp_interface');
# &show_no_dhcp_interface();
&show_field_table("no_dhcp_interface", $apply_cgi . "?mode=no_dhcp_interface", $text{"_iface"}, \%dnsmconfig);
print ui_tabs_end_tab('mode', 'no_dhcp_interface');

print ui_tabs_start_tab('mode', 'listen_address');
# &show_listen_address();
&show_field_table("listen_address", $apply_cgi . "?mode=listen_address", $text{"_listen"}, \%dnsmconfig);
print ui_tabs_end_tab('mode', 'listen_address');

print ui_tabs_end();

print &add_js();

ui_print_footer("index.cgi?mode=dns", $text{"index_dns_settings"});

### END of dns_iface.cgi ###.
