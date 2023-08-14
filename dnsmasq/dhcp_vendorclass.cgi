#!/usr/bin/perl
#
#    DNSMasq Webmin Module - # TODO dhcp_vendorclass.cgi; DHCP vendor class config
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

&header($text{"index_title"}, "", "intro", 1, 0, 0, &restart_button(), undef, undef, $text{"index_dhcp_vendorclass"});

my $returnto = $in{"returnto"} || "dhcp_vendorclass.cgi";
my $returnlabel = $in{"returnlabel"} || $text{"index_dhcp_vendorclass"};
my $apply_cgi = "dhcp_vendorclass_apply.cgi";

my $formid = "vendorclass_form";
my $internalfield = "dhcp_vendorclass";
my $configfield = &internal_to_config($internalfield);
my @newfields = ( "tag", "vendorclass" );
my @editfields = ( "idx", "tag", "vendorclass" );
my @list_link_buttons = &list_links( "sel", 0 );
my ($add_new_button, $hidden_add_input_fields) = &add_item_button(&text("add_", $text{"vendorclass"}), $internalfield, $text{"vendorclass"}, 500, 465, $formid, \@newfields );
push(@list_link_buttons, $add_new_button);

my $count;
$count=0;
print &ui_form_start( $apply_cgi, "post", undef, "id=\"$formid\"" );
print &ui_links_row(\@list_link_buttons);

print $hidden_add_input_fields;
my @edit_link = ( "", "" );
my $hidden_edit_input_fields;
my @tds = ( $td_left, $td_left, $td_left, $td_left );
print &ui_columns_start( [
        "",
        $text{"enabled"}, 
        $text{"dhcp_tag_s"}, 
        $text{"vendorclass"}, 
    ], 100, undef, undef, &ui_columns_header( [ $text{"index_dhcp_vendorclass"} . &ui_help($text{"p_man_desc_vendorclass"}) ], [ 'class="table-title" colspan=4' ] ), 1 );
foreach my $class ( @{$dnsmconfig{"dhcp-vendorclass"}} ) {
    local %val = %{ $class->{"val"} };
    local @cols;
    # first call to &edit_item_link should capture link, fields, and script; subsequent calls (1 for each field) only need the link
    ($edit_link[0], $hidden_edit_input_fields) = &edit_item_link($val{"tag"}, $internalfield, $text{"vendorclass"}, $count, $formid, 500, 465, \@editfields);
    ($edit_link[1]) = &edit_item_link($val{"vendorclass"}, $internalfield, $text{"vendorclass"}, $count, $formid, 500, 465, \@editfields);
    push ( @cols, &ui_checkbox("enabled", "1", "", $class->{"used"}?1:0, undef, 1) );
    push ( @cols, $edit_link[0] );
    push ( @cols, $edit_link[1] );
    print &ui_clickable_checked_columns_row( \@cols, \@tds, "sel", $count );
    $count++;
}
print &ui_columns_end();
print &ui_links_row(\@list_link_buttons);
print "<p>" . $text{"with_selected"} . "</p>";
print &ui_submit($text{"enable_sel"}, "enable_sel");
print &ui_submit($text{"disable_sel"}, "disable_sel");
print &ui_submit($text{"delete_sel"}, "delete_sel");
print &ui_hr();
print $hidden_edit_input_fields;
print &ui_form_end( );
print &add_js();
ui_print_footer("index.cgi?mode=dhcp", $text{"index_dhcp_settings"}, "index.cgi?mode=dns", $text{"index_dns_settings"});

### END of dhcp_vendorclass.cgi ###.
