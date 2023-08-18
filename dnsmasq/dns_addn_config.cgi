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
# read posted data
&ReadParse();

&header($text{"index_title"}, "", "intro", 1, 0, 0, &restart_button(), undef, undef, $text{"index_dns_addn_config"});
print &header_style();

my $mode = $in{mode} || "conf_file";
my $returnto = $in{"returnto"} || "dns_addn_config.cgi";
my $returnlabel = $in{"returnlabel"} || $text{"index_dns_addn_config"};
my $apply_cgi = "dns_addn_config_apply.cgi";
my $formidx = 0;

my @vals = (
    {
        "internalfield" => "conf_file",
        "add_button_text" => $text{"_filename"},
    },
    {
        "internalfield" => "servers_file",
        "add_button_text" => $text{"_filename"},
    },
);

sub show_conf_dir {
    my @edit_link = ( "", "" );
    my $hidden_edit_input_fields;
    my $count=0;
    my $internalfield = "conf_dir";
    my $configfield = &internal_to_config($internalfield);
    my $definition = %configfield_fields{$internalfield};
    my $formid = $internalfield . "_form";
    my @newfields = ( "dirname", "filter", "exceptions" );
    my @editfields = ( "idx", @newfields );
    print &ui_form_start( $apply_cgi . "?mode=$internalfield", "post", undef, "id=\"$formid\"" );
    @list_link_buttons = &list_links( "sel", 2 );
    my ($file_chooser_button, $hidden_input_fields) = &add_file_chooser_button( &text("add_", $text{"_directory"}), "new_" . $internalfield, 1, $formid );
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
        # first call to &edit_item_link should capture link and fields; subsequent calls (1 for each field) only need the link
        ($edit_link[0], $hidden_edit_input_fields) = &edit_item_link($val{"filter"}, $internalfield, $text{"p_desc_$internalfield"}, $count, $formid, \@editfields);
        ($edit_link[1]) = &edit_item_link($val{"exceptions"}, $internalfield, $text{"p_desc_$internalfield"}, $count, $formid, \@editfields);
        push ( @cols, &ui_checkbox("enabled", "1", "", $item->{"used"}?1:0, undef, 1) );
        push ( @cols, &ui_filebox($formid."_fn", $item->{"val"}->{"dirname"}, $definition->{"dirname"}->{"length"}, 0, undef, "idx=\"$count\"", 1) );
        push ( @cols, $edit_link[0] );
        push ( @cols, $edit_link[1] );
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
    print $hidden_edit_input_fields;
    print &ui_form_end( );
}

my @tabs = ( );
foreach my $v ( @vals ) {
    push(@tabs, [ $v->{"internalfield"}, $text{"p_desc_" . $v->{"internalfield"}} ]);
}
push(@tabs, [ 'conf_dir', $text{"p_desc_conf_dir"} ]);

print ui_tabs_start(\@tabs, 'mode', $mode);

foreach my $v ( @vals ) {
    print ui_tabs_start_tab('mode', $v->{"internalfield"});
    &show_field_table($v->{"internalfield"}, $apply_cgi . "?mode=" . $v->{"internalfield"}, $v->{"add_button_text"}, \%dnsmconfig, $formidx++);
    print ui_tabs_end_tab('mode', $v->{"internalfield"});
}

print ui_tabs_start_tab('mode', 'conf_dir');
&show_conf_dir();
print ui_tabs_end_tab('mode', 'conf_dir');

print ui_tabs_end();

print &add_js();

ui_print_footer("index.cgi?mode=dns", $text{"index_dns_settings"});

### END of dns_addn_config.cgi ###.
