#!/usr/bin/perl
#
#    DNSMasq Webmin Module - # TODO dhcp_tags.cgi; DHCP tag matching
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

# my $headstuff = &add_js($formid, $internalfield);
&header($text{"index_title"}, "", "intro", 1, 0, 0, &restart_button(), undef, undef, $text{"index_dhcp_tags"});

my $returnto = $in{"returnto"} || "dhcp_tags.cgi";
my $returnlabel = $in{"returnlabel"} || $text{"index_dhcp_tags"};
my $apply_cgi = "dhcp_tags_apply.cgi";

sub show_userclass {
    my $formid = "userclass_form";
    my $internalfield = "dhcp_userclass";
    my $configfield = &internal_to_config($internalfield);
    my @newfields = ( "tag", "userclass" );
    my @editfields = ( "idx", @newfields );
    my @list_link_buttons = &list_links( "sel", 0 );
    my ($add_new_button, $hidden_add_input_fields, $add_new_script) = &add_item_button(&text("add_", $text{"userclass"}), $internalfield, $text{"userclass"}, 500, 435, $formid, \@newfields );
    push(@list_link_buttons, $add_new_button);

    my $count;
    $count=0;
    print &ui_form_start( "dhcp_userclass_apply.cgi", "post", undef, "id=\"$formid\"" );
    print &ui_links_row(\@list_link_buttons);

    print $hidden_add_input_fields . $add_new_script;
    my $edit_link_tag;
    my $edit_link_userclass;
    my $hidden_edit_input_fields;
    my $edit_script;
    my @tds = ( $td_left, $td_left, $td_left, $td_left );
    print &ui_columns_start( [ 
            "",
            $text{"enabled"}, 
            $text{"p_label_val_tags"}, 
            $text{"userclass"},
        ], 100, undef, undef, &ui_columns_header( [ &show_title_with_help($internalfield, $configfield) ], [ 'class="table-title" colspan=4' ] ), 1 );
    foreach my $class ( @{$dnsmconfig{"dhcp-userclass"}} ) {
        local %val = %{ $class->{"val"} };
        local @cols;
        ($edit_link_tag, $hidden_edit_input_fields, $edit_script) = &edit_item_link($val{"tag"}, $internalfield, $text{"userclass"}, $count, $formid, 500, 465, \@editfields);
        ($edit_link_userclass) = &edit_item_link($val{"userclass"}, $internalfield, $text{"userclass"}, $count, $formid, 500, 465, \@editfields);
        push ( @cols, &ui_checkbox("enabled", "1", "", $class->{"used"}?1:0, undef, 1) );
        push ( @cols, $edit_link_tag );
        push ( @cols, $edit_link_userclass );
        print &ui_checked_columns_row( \@cols, \@tds, "sel", $count );
        $count++;
    }
    print &ui_columns_end();
    print &ui_links_row(\@list_link_buttons);
    print "<p>" . $text{"with_selected"} . "</p>";
    print &ui_submit($text{"enable_sel"}, "enable_sel_$internalfield");
    print &ui_submit($text{"disable_sel"}, "disable_sel_$internalfield");
    print &ui_submit($text{"delete_sel"}, "delete_sel_$internalfield");
    print &ui_hr();
    print $hidden_edit_input_fields . $edit_script;
    print &ui_form_end( );
}

sub show_vendorclass {
    my $formid = "vendorclass_form";
    my $internalfield = "dhcp_vendorclass";
    my $configfield = &internal_to_config($internalfield);
    my @newfields = ( "tag", "vendorclass" );
    my @editfields = ( "idx", "tag", "vendorclass" );
    my @list_link_buttons = &list_links( "sel", 0 );
    my ($add_new_button, $hidden_add_input_fields, $add_new_script) = &add_item_button(&text("add_", $text{"vendorclass"}), $internalfield, $text{"vendorclass"}, 500, 465, $formid, \@newfields );
    push(@list_link_buttons, $add_new_button);

    my $count;
    $count=0;
    print &ui_form_start( "dhcp_vendorclass_apply.cgi", "post", undef, "id=\"$formid\"" );
    print &ui_links_row(\@list_link_buttons);

    print $hidden_add_input_fields . $add_new_script;
    my @edit_link = ( "", "" );
    my $hidden_edit_input_fields;
    my $edit_script;
    my @tds = ( $td_left, $td_left, $td_left, $td_left );
    print &ui_columns_start( [
            "",
            $text{"enabled"}, 
            $text{"p_label_val_tags"}, 
            $text{"vendorclass"}, 
        ], 100, undef, undef, &ui_columns_header( [ &show_title_with_help($internalfield, $configfield) ], [ 'class="table-title" colspan=4' ] ), 1 );
    foreach my $class ( @{$dnsmconfig{"dhcp-vendorclass"}} ) {
        local %val = %{ $class->{"val"} };
        local @cols;
        # first call to &edit_item_link should capture link, fields, and script; subsequent calls (1 for each field) only need the link
        ($edit_link[0], $hidden_edit_input_fields, $edit_script) = &edit_item_link($val{"tag"}, $internalfield, $text{"vendorclass"}, $count, $formid, 500, 465, \@editfields);
        ($edit_link[1]) = &edit_item_link($val{"vendorclass"}, $internalfield, $text{"vendorclass"}, $count, $formid, 500, 465, \@editfields);
        push ( @cols, &ui_checkbox("enabled", "1", "", $class->{"used"}?1:0, undef, 1) );
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
    print &ui_hr();
    print $hidden_edit_input_fields . $edit_script;
    print &ui_form_end( );
}

my @page_fields = ();
foreach my $configfield ( @confdhcp ) {
    next if ( %dnsmconfigvals{"$configfield"}->{"page"} ne "4" );
    push( @page_fields, $configfield );
}
@tabs = (
            # [ 'basic', $text{'index_basic'} ], # there aren't any basic fields here!
            [ 'basic_match', $text{"index_dhcp_other_tags"} ],
            [ 'userclass', $text{"index_dhcp_userclass"} ],
            [ 'vendorclass', $text{"index_dhcp_vendorclass"} ],
        );
my $mode = $in{mode} || "basic_match";
print ui_tabs_start(\@tabs, 'mode', $mode);

# there aren't any basic fields here!
# print ui_tabs_start_tab('mode', 'basic');
# &show_basic_fields( \%dnsmconfig, "dhcp_tag", \@page_fields, "dhcp_tag_apply.cgi", $text{"index_basic"} );
# print ui_tabs_end_tab('mode', 'basic');

print ui_tabs_start_tab('mode', 'basic_match');
&show_other_fields( \%dnsmconfig, "dhcp_tag", \@page_fields, "dhcp_tag_apply.cgi", $text{"index_dhcp_other_tags"} );
print ui_tabs_end_tab('mode', 'basic_match');

print ui_tabs_start_tab('mode', 'userclass');
&show_userclass();
print ui_tabs_end_tab('mode', 'userclass');

print ui_tabs_start_tab('mode', 'vendorclass');
&show_vendorclass();
print ui_tabs_end_tab('mode', 'vendorclass');

print ui_tabs_end();

print &add_js();
ui_print_footer("index.cgi?mode=dhcp", $text{"index_dhcp_settings"}, "index.cgi?mode=dns", $text{"index_dns_settings"});

### END of dhcp_tags.cgi ###.
