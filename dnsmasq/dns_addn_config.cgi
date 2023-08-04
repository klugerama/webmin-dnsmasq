#!/usr/bin/perl
#
#    DNSMasq Webmin Module - dns_addn_config.cgi; basic DNS config     
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

&header($text{"index_title"}, "", "intro", 1, 0, 0, &restart_button(), undef, undef, $text{"index_dns_addn_config"});

my $returnto = $in{"returnto"} || "dns_addn_config.cgi";
my $returnlabel = $in{"returnlabel"} || $text{"index_dns_addn_config"};
my $apply_cgi = "dns_addn_config_apply.cgi";

sub show_conf_file {
    my $count=0;
    my $internalfield = "conf_file";
    my $configfield = &internal_to_config($internalfield);
    my $definition = %configfield_fields{$internalfield};
    my $formid = "addnconf_" . $internalfield . "_form";
    print &ui_form_start( $apply_cgi, "post", undef, "id=\"$formid\"" );
    # @list_link_buttons = &list_links( "sel", 0, "dns_addn_config_apply.cgi", "$configfield=new", "dns_addn_config.cgi", &text("add_", $text{"p_label_$internalfield"}) );
    @list_link_buttons = &list_links( "sel", 0 );
    my ($file_chooser_button, $hidden_input_fields, $submit_script) = &add_file_chooser_button( &text("add_", $text{"filename"}), "new_" . $internalfield, 0, $formid );
    print &ui_links_row(\@list_link_buttons);
    print $hidden_input_fields;
    print $file_chooser_button;
    print &ui_columns_start( [ 
        # "line", 
        "",
        $text{"enabled"}, 
        $text{"p_label_conf_file"}, 
        # "full" 
    ], 100, undef, undef, &ui_columns_header( [ &show_title_with_help($internalfield, $configfield) ], [ 'class="table-title" colspan=3' ] ), 1 );

    foreach my $item ( @{$dnsmconfig{$configfield}} ) {
        local @cols;
        push ( @cols, &ui_checkbox("enabled", "1", "", $item->{"used"}?1:0, undef, 1) );
        push ( @cols, &ui_filebox($formid."_fn", $item->{"val"}->{"filename"}, $definition->{"filename"}->{"length"}, 0, undef, "idx=\"$count\"") );
        print &ui_clickable_checked_columns_row( \@cols, undef, "sel", $configfield, 0 );
        $count++;

    }
    print &ui_columns_end();
    print &ui_links_row(\@list_link_buttons);
    print $hidden_input_fields;
    print $file_chooser_button;
    print "<p>" . $text{"with_selected"} . "</p>";
    print &ui_submit($text{"enable_sel"}, "enable_sel_$internalfield");
    print &ui_submit($text{"disable_sel"}, "disable_sel_$internalfield");
    print &ui_submit($text{"delete_sel"}, "delete_sel_$internalfield");
    print $submit_script;
    print &ui_form_end( );
    print &ui_hr();
}

sub show_servers_file {
    my $count=0;
    my $internalfield = "servers_file";
    my $configfield = &internal_to_config($internalfield);
    my $definition = %configfield_fields{$internalfield};
    my $formid = "addnconf_" . $internalfield . "_form";
    print &ui_form_start( $apply_cgi, "post", undef, "id=\"$formid\"" );
    # @list_link_buttons = &list_links( "sel", 1, "dns_addn_config_apply.cgi", "$configfield=new", "dns_addn_config.cgi", &text("add_", $text{"p_label_$internalfield"}) );
    @list_link_buttons = &list_links( "sel", 1 );
    my ($file_chooser_button, $hidden_input_fields, $submit_script) = &add_file_chooser_button( &text("add_", $text{"filename"}), "new_" . $internalfield, 0, $formid );
    print &ui_links_row(\@list_link_buttons);
    print $hidden_input_fields;
    print $file_chooser_button;
    print &ui_columns_start( [ 
        # "line", 
        "",
        $text{"enabled"}, 
        $text{"p_label_$internalfield"}, 
        # "full" 
    ], 100, undef, undef, &ui_columns_header( [ &show_title_with_help($internalfield, $configfield) ], [ 'class="table-title" colspan=3' ] ), 1 );

    foreach my $item ( @{$dnsmconfig{$configfield}} ) {
        local @cols;
        # my $edit = "<a href=dhcp_reservation_edit.cgi?idx=$count>".$item->{"val"}."</a>";
        push ( @cols, &ui_checkbox("enabled", "1", "", $item->{"used"}?1:0, undef, 1) );
        # push ( @cols, &ui_checkbox("enabled", "1", "", $item->{"used"}?1:0, undef, 1) );
        # push ( @cols, $edit );
        push ( @cols, &ui_filebox($formid."_fn", $item->{"val"}->{"filename"}, $definition->{"filename"}->{"length"}, 0, undef, "idx=\"$count\"") );
        # print &ui_checked_columns_row( \@cols, undef, "sel", $count );
        print &ui_clickable_checked_columns_row( \@cols, undef, "sel", $configfield, 0 );
        $count++;

    }
    print &ui_columns_end();
    print &ui_links_row(\@list_link_buttons);
    print $hidden_input_fields;
    print $file_chooser_button;
    print "<p>" . $text{"with_selected"} . "</p>";
    print &ui_submit($text{"enable_sel"}, "enable_sel_$internalfield");
    print &ui_submit($text{"disable_sel"}, "disable_sel_$internalfield");
    print &ui_submit($text{"delete_sel"}, "delete_sel_$internalfield");
    print $submit_script;
    print &ui_form_end( );
    print &ui_hr();
}

sub show_conf_dir {
    my @edit_link = ( "", "" );
    my $hidden_edit_input_fields;
    my $edit_script;
    my $count=0;
    my $internalfield = "conf_dir";
    my $configfield = &internal_to_config($internalfield);
    my $definition = %configfield_fields{$internalfield};
    my $formid = "addnconf_" . $internalfield . "_form";
    my @newfields = ( "dirname", "filter", "exceptions" );
    my @editfields = ( "idx", @newfields );
    print &ui_form_start( $apply_cgi, "post", undef, "id=\"$formid\"" );
    # @list_link_buttons = &list_links( "sel", 2, "dns_addn_config_edit.cgi", "$configfield=new", "dns_addn_config.cgi", &text("add_", $text{"p_label_$internalfield"}) );
    my $w = 500;
    my $h = 505;
    @list_link_buttons = &list_links( "sel", 2 );
    my ($file_chooser_button, $hidden_input_fields, $submit_script) = &add_file_chooser_button( &text("add_", $text{"directory"}), "new_" . $internalfield, 1, $formid );
    print &ui_links_row(\@list_link_buttons);
    print $hidden_input_fields;
    print $file_chooser_button;
    print &ui_columns_start( [ 
        # "line", 
        # $text{""},
        "",
        $text{"enabled"},
        $text{"p_label_conf_dir"},
        $text{"p_label_conf_dir_filter"},
        $text{"p_label_conf_dir_exceptions"},
        # "full" 
    ], 100, undef, undef, &ui_columns_header( [ &show_title_with_help($internalfield, $configfield) ], [ 'class="table-title" colspan=5' ] ), 1 );

    foreach my $item ( @{$dnsmconfig{$configfield}} ) {
        local %val = %{ $item->{"val"} };
        local @cols;
        ($edit_link[0], $hidden_edit_input_fields, $edit_script) = &edit_item_link($val{"filter"}, $internalfield, $text{"p_desc_$internalfield"}, $count, $formid, $w, $h, \@editfields);
        ($edit_link[1]) = &edit_item_link($val{"exceptions"}, $internalfield, $text{"p_desc_$internalfield"}, $count, $formid, $w, $h, \@editfields);
        # my $edit = "<a href=dns_addn_config_edit.cgi?idx=$count>".$confdir->{"val"}->{"dirname"}."</a>";
        push ( @cols, &ui_checkbox("enabled", "1", "", $item->{"used"}?1:0, undef, 1) );
        # push ( @cols, $edit );
        push ( @cols, &ui_filebox($formid."_fn", $item->{"val"}->{"dirname"}, $definition->{"dirname"}->{"length"}, 0, undef, "idx=\"$count\"", 1) );
        # push ( @cols, $item->{"val"}->{"filter"} );
        # push ( @cols, $item->{"val"}->{"exceptions"} );
        push ( @cols, $edit_link[0] );
        push ( @cols, $edit_link[1] );
        # print &ui_checked_columns_row( \@cols, undef, "sel", $count );
        print &ui_clickable_checked_columns_row( \@cols, undef, "sel", $configfield, 0 );
        $count++;

    }
    print &ui_columns_end();
    print &ui_links_row(\@list_link_buttons);
    print $hidden_input_fields;
    print $file_chooser_button;
    print "<p>" . $text{"with_selected"} . "</p>";
    print &ui_submit($text{"enable_sel"}, "enable_sel_$internalfield");
    print &ui_submit($text{"disable_sel"}, "disable_sel_$internalfield");
    print &ui_submit($text{"delete_sel"}, "delete_sel_$internalfield");
    print $hidden_edit_input_fields . $edit_script;
    print &ui_form_end( );
}

@tabs = (   [ 'conf_file', $text{'p_desc_conf_file'} ],
            [ 'servers_file', $text{"p_desc_servers_file"} ],
            [ 'conf_dir', $text{"p_desc_conf_dir"} ],
        );
my $mode = $in{mode} || "conf_file";
print ui_tabs_start(\@tabs, 'mode', $mode);

print ui_tabs_start_tab('mode', 'conf_file');
&show_conf_file();
print ui_tabs_end_tab('mode', 'conf_file');

print ui_tabs_start_tab('mode', 'servers_file');
show_servers_file();
print ui_tabs_end_tab('mode', 'servers_file');

print ui_tabs_start_tab('mode', 'conf_dir');
&show_conf_dir();
print ui_tabs_end_tab('mode', 'conf_dir');

print ui_tabs_end();

print &add_js();

ui_print_footer("index.cgi?mode=dns", $text{"index_dns_settings"});

### END of dns_addn_config.cgi ###.