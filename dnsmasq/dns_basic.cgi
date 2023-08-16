#!/usr/bin/perl
#
#    DNSMasq Webmin Module - dns_basic.cgi; basic DNS config     
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

&header($text{"index_title"}, "", "intro", 1, 0, 0, &restart_button(), undef, undef, $text{"index_dns_settings_basic"});

my $mode = $in{mode} || "basic";
my $returnto = $in{"returnto"} || "dns_basic.cgi";
my $returnlabel = $in{"returnlabel"} || $text{"index_dns_settings_basic"};
my $apply_cgi = "dns_basic_apply.cgi";
my @tds = ( $td_left, $td_left, $td_left );
our $formidx = 1;

my @vals = (
    {
        "internalfield" => "addn_hosts",
        "add_button_text" => $text{"_hostsfile"},
        "val_label" => $text{"p_label_val_filename"},
        "chooser_mode" => 0
    },
    {
        "internalfield" => "hostsdir",
        "add_button_text" => $text{"_hostsdir"},
        "val_label" => $text{"p_label_val_directory"},
        "chooser_mode" => 1
    },
    {
        "internalfield" => "resolv_file",
        "add_button_text" => $text{"_resolvfile"},
        "val_label" => $text{"p_label_val_filename"},
        "chooser_mode" => 0
    },
);

sub show_path_list {
    my ($internalfield, $add_button_text, $val_label, $chooser_mode) = @_;
    my $configfield = &internal_to_config($internalfield);
    my $count=0;
    my $edit_link;
    my $hidden_edit_input_fields;
    my $edit_submit_script;
    my $formid = $internalfield . "_form";
    my $g = &ui_form_start( $apply_cgi . "?mode=$internalfield", "post", undef, "id='$formid'" );
    my @list_link_buttons = &list_links( "sel", $formidx++ );
    my ($file_chooser_button, $hidden_add_input_fields) = &add_file_chooser_button( &text("add_", $add_button_text), "new_" . $internalfield, $chooser_mode, $formid );
    $g .= &ui_links_row(\@list_link_buttons);
    $g .= $hidden_add_input_fields;
    $g .= $file_chooser_button;
    $g.= &ui_columns_start( [ 
        "",
        $text{"enabled"}, 
        $val_label, 
        # "full" 
    ], 100, undef, undef, &ui_columns_header( [ &show_title_with_help($internalfield, $configfield) ], [ 'class="table-title" colspan=3' ] ), 1 );

    foreach my $item ( @{$dnsmconfig{$configfield}} ) {
        local @cols;
        push ( @cols, &ui_checkbox("enabled", "1", "", $item->{"used"}?1:0, undef, 1) );
        # edit_file_chooser_link(text, input, type, current_value, idx, formid, [chroot], [addmode])
        ($edit_link, $hidden_edit_input_fields, $edit_submit_script) = &edit_file_chooser_link($item->{"val"}, $internalfield, $chooser_mode, $item->{"val"}, $count, $formid);
        push ( @cols, $edit_link );
        $g .= &ui_clickable_checked_columns_row( \@cols, \@tds, "sel", $count );
        $count++;
    }
    $g .= &ui_columns_end();
    $g .= &ui_links_row(\@list_link_buttons);
    $g .= $hidden_add_input_fields;
    $g .= $file_chooser_button;
    $g .= "<p>" . $text{"with_selected"} . "</p>";
    $g .= &ui_submit($text{"enable_sel"}, "enable_sel_$internalfield");
    $g .= &ui_submit($text{"disable_sel"}, "disable_sel_$internalfield");
    $g .= &ui_submit($text{"delete_sel"}, "delete_sel_$internalfield");
    $g .= $hidden_edit_input_fields;
    $g .= $edit_submit_script;
    $g .= &ui_form_end( );
    print $g;
}

my @page_fields = ();
foreach my $configfield ( @confdns ) {
    next if ( %dnsmconfigvals{"$configfield"}->{"page"} ne "1" );
    push( @page_fields, $configfield );
}
my @tabs = ( [ 'basic', $text{'index_basic'} ] );
foreach my $v ( @vals ) {
    push(@tabs, [ $v->{"internalfield"}, $text{"p_desc_" . $v->{"internalfield"}} ]);
}
print ui_tabs_start(\@tabs, 'mode', $mode);

print ui_tabs_start_tab('mode', 'basic');
&show_basic_fields( \%dnsmconfig, "dns_basic", \@page_fields, $apply_cgi . "?mode=basic", $text{"index_dns_settings_basic"} );
print ui_tabs_end_tab('mode', 'basic');

foreach my $v ( @vals ) {
    print ui_tabs_start_tab('mode', $v->{"internalfield"});
    &show_path_list($v->{"internalfield"}, $v->{"add_button_text"}, $v->{"val_label"}, $v->{"chooser_mode"});
    print ui_tabs_end_tab('mode', $v->{"internalfield"});
}

print ui_tabs_end();

print &add_js();

ui_print_footer("index.cgi?mode=dns", $text{"index_dns_settings"});

### END of dns_basic.cgi ###.
