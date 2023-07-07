#!/usr/bin/perl
#
#    DNSMasq Webmin Module - # TODO dns_records.cgi; Upstream Servers config
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

&header( $text{"index_title"}, "", "intro", 1, 0, 0, &restart_button(), undef, undef, $text{"index_dns_records_settings"} );

my $returnto = $in{"returnto"} || "dns_records.cgi";
my $returnlabel = $in{"returnlabel"} || $text{"index_dns_records_settings"};

sub show_ipsets {
    my @edit_link = ( "", "" );
    my $hidden_edit_input_fields;
    my $edit_script;
    my $internalfield = "ipset";
    my $configfield = &internal_to_config($internalfield);
    my $formid = "ipset_form";
    my @newfields = ( "domain", "ipset" );
    my @editfields = ( "idx", @newfields );
    my $w = 500;
    my $h = 505;
    my @list_link_buttons = &list_links( "sel", 0 );
    my ($add_new_button, $hidden_add_input_fields, $add_new_script) = &add_item_button(&text("add_", $text{"_ipset"}), $internalfield, $text{"p_desc_$internalfield"}, $w, $h, $formid, \@newfields );
    push(@list_link_buttons, $add_new_button);
    my @tds = ( $td_left, $td_left, $td_left, $td_left, $td_left, $td_left );

    my $count=0;
    print &ui_form_start( "dns_records_apply.cgi", "post", undef, "id=\"$formid\"" );
    print &ui_links_row(\@list_link_buttons);
    print $hidden_add_input_fields . $add_new_script;
    print &ui_columns_start( [ 
        "",
        $text{"enabled"},
        $text{"domain"},
        $text{"ipset"},
        ], 100, undef, undef, &ui_columns_header( [ &show_title_with_help($internalfield, $configfield) ], [ 'class="table-title" colspan=4' ] ), 1 );
    foreach my $alias ( @{$dnsmconfig{$configfield}} ) {
        local %val = %{ $alias->{"val"} };
        local @cols;
        ($edit_link[0], $hidden_edit_input_fields, $edit_script) = &edit_item_link($val{"domain"}, $internalfield, $text{"p_desc_$internalfield"}, $count, $formid, $w, $h, \@editfields);
        ($edit_link[1]) = &edit_item_link($val{"ipset"}, $internalfield, $text{"p_desc_$internalfield"}, $count, $formid, $w, $h, \@editfields);
        push ( @cols, &ui_checkbox("enabled", "1", "", $alias->{"used"}?1:0, undef, 1) );
        push ( @cols, $edit_link[0] );
        push ( @cols, $edit_link[1] );
        print &ui_checked_columns_row( \@cols, \@tds, "sel", $count );
        $count++;
    }
    print &ui_columns_end();
    print &ui_links_row(\@list_link_buttons);
    print "<p>" . $text{"with_selected"} . "</p>";
    print &ui_submit($text{"enable_sel"}, "enable_sel_$internalfield");
    print &ui_submit($text{"disable_sel"}, "disable_sel_$internalfield");
    print &ui_submit($text{"delete_sel"}, "delete_sel_$internalfield");
    print $hidden_edit_input_fields . $edit_script;
    print &ui_form_end();
}

sub show_connmark {
    my @edit_link = ( "", "", "" );
    my $hidden_edit_input_fields;
    my $edit_script;
    my $internalfield = "connmark_allowlist";
    my $configfield = &internal_to_config($internalfield);
    my $formid = "connmark_allowlist_form";
    my @newfields = ( "connmark", "mask", "pattern" );
    my @editfields = ( "idx", @newfields );
    my $w = 500;
    my $h = 505;
    my @list_link_buttons = &list_links( "sel", 0 );
    my ($add_new_button, $hidden_add_input_fields, $add_new_script) = &add_item_button(&text("add_", $text{"_connmark"}), $internalfield, $text{"p_desc_$internalfield"}, $w, $h, $formid, \@newfields );
    push(@list_link_buttons, $add_new_button);
    my @tds = ( $td_left, $td_left, $td_left, $td_left, $td_left, $td_left );

    my $count=0;
    print &ui_form_start( "dns_records_apply.cgi", "post", undef, "id=\"$formid\"" );
    print &ui_links_row(\@list_link_buttons);
    print $hidden_add_input_fields . $add_new_script;
    print &ui_columns_start( [ 
        "",
        $text{"enabled"},
        $text{"p_label_val_connmark"},
        $text{"p_label_val_mask"},
        $text{"p_label_val_pattern"},
        ], 100, undef, undef, &ui_columns_header( [ &show_title_with_help($internalfield, $configfield) ], [ 'class="table-title" colspan=5' ] ), 1 );
    foreach my $alias ( @{$dnsmconfig{$configfield}} ) {
        local %val = %{ $alias->{"val"} };
        local @cols;
        ($edit_link[0], $hidden_edit_input_fields, $edit_script) = &edit_item_link($val{"connmark"}, $internalfield, $text{"p_desc_$internalfield"}, $count, $formid, $w, $h, \@editfields);
        ($edit_link[1]) = &edit_item_link($val{"mask"}, $internalfield, $text{"p_desc_$internalfield"}, $count, $formid, $w, $h, \@editfields);
        ($edit_link[2]) = &edit_item_link($val{"pattern"}, $internalfield, $text{"p_desc_$internalfield"}, $count, $formid, $w, $h, \@editfields);
        push ( @cols, &ui_checkbox("enabled", "1", "", $alias->{"used"}?1:0, undef, 1) );
        push ( @cols, $edit_link[0] );
        push ( @cols, $edit_link[1] );
        push ( @cols, $edit_link[2] );
        print &ui_checked_columns_row( \@cols, \@tds, "sel", $count );
        $count++;
    }
    print &ui_columns_end();
    print &ui_links_row(\@list_link_buttons);
    print "<p>" . $text{"with_selected"} . "</p>";
    print &ui_submit($text{"enable_sel"}, "enable_sel_$internalfield");
    print &ui_submit($text{"disable_sel"}, "disable_sel_$internalfield");
    print &ui_submit($text{"delete_sel"}, "delete_sel_$internalfield");
    print $hidden_edit_input_fields . $edit_script;
    print &ui_form_end();
}

my @page_fields = ();
foreach my $configfield ( @confdns ) {
    next if ( %dnsmconfigvals{"$configfield"}->{"page"} ne "5" );
    push( @page_fields, $configfield );
}

@tabs = (   [ 'basic', $text{'index_basic'} ],
            [ 'ipset', $text{"index_dns_ipset"} ],
            [ 'connmark', $text{"index_dns_connmark"} ],
            [ 'recs', $text{"index_dns_records"} ],
        );
my $mode = $in{mode} || "basic";
print ui_tabs_start(\@tabs, 'mode', $mode);

print ui_tabs_start_tab('mode', 'basic');
&show_basic_fields( \%dnsmconfig, "dns_records", \@page_fields, "dns_records_apply.cgi", $text{"index_basic"} );
print ui_tabs_end_tab('mode', 'basic');

print ui_tabs_start_tab('mode', 'ipset');
&show_ipsets();
print ui_tabs_end_tab('mode', 'ipset');

print ui_tabs_start_tab('mode', 'connmark');
&show_connmark();
print ui_tabs_end_tab('mode', 'connmark');

print ui_tabs_start_tab('mode', 'recs');
&show_other_fields( \%dnsmconfig, "dns_records", \@page_fields, "dns_records_apply.cgi", $text{"index_dns_records"} );
print ui_tabs_end_tab('mode', 'recs');

print ui_tabs_end();

print &add_js();
ui_print_footer("index.cgi?mode=dns", $text{"index_dns_settings"});

### END of dns_records.cgi ###.
