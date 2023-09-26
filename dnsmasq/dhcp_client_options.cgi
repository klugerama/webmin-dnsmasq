#!/usr/bin/perl
#
#    DNSMasq Webmin Module - dhcp_client_options.cgi; DHCP client option settings
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

## put in ACL checks here if needed

my $config_filename = $config{config_file};
my $config_file = &read_file_lines( $config_filename );

&parse_config_file( \%dnsmconfig, \$config_file, $config_filename );

my ($error_check_action, $error_check_result) = &check_for_file_errors( $0, $text{"index_title"}, \%dnsmconfig );
if ($error_check_action eq "redirect") {
    &redirect ( $error_check_result );
}

&ui_print_header($text{"index_dhcp_client_options"}, $text{"index_title"}, "", "intro", 1, 0, 0, &restart_button());
print &header_js();
print $error_check_result;

my $returnto = $in{"returnto"} || "dhcp_client_options.cgi";
my $returnlabel = $in{"returnlabel"} || $text{"index_dhcp_client_options"};
my $apply_cgi = "dhcp_client_options_apply.cgi";

# &show_field_table("dhcp_option", $apply_cgi, $text{"_dhcp_option"}, \%dnsmconfig, 1);
our $internalfield = "dhcp_option";
my $configfield = &internal_to_config($internalfield);
my $definition = %configfield_fields{$internalfield};
my $formidx = 0;

sub show_dhcp_option_list {
    my ($ipver, $formidx) = @_;
    my $version_excluded = ($ipver == 4 ? 6 : 4);
    my $edit_link;
    my $hidden_edit_input_fields;
    my @column_headers = ( "", $text{"enabled"}, );
    my @newfields = ( "ipversion" );
    foreach my $param ( @{$definition->{"param_order"}} ) {
        next if ($definition->{$param}->{"ipversion"} == $version_excluded);
        push( @newfields, $param );
        push( @column_headers, $definition->{$param}->{"label"} );
    }
    my @editfields = ( "cfg_idx", @newfields );
    my $formid = $internalfield . "_" . $ipver . "_form";
    my @tds = ( &get_class_tag($td_label_class), &get_class_tag($td_left_class), &get_class_tag($td_left_class) ); # extra column for set-tags
    foreach my $param ( @newfields ) {
        push( @tds, &get_class_tag($td_left_class) );
    }
    my @list_link_buttons = &list_links( "sel", $formidx );
    my ($add_button, $hidden_add_input_fields) = &add_item_button(&text("add_", $text{"_dhcp_option"}), $internalfield, $text{"p_desc_$internalfield"}, $formid, \@newfields, "ipversion=ip" . $ipver );
    push(@list_link_buttons, $add_button);

    my $count = -1;
    print &ui_form_start( $apply_cgi . "?ipversion=ip" . $ipver, "post", undef, "id='$formid'" );
    print &ui_links_row(\@list_link_buttons);
    print &ui_columns_start( \@column_headers, 100, undef, undef, &ui_columns_header( [ &show_title_with_help($internalfield, $configfield) ], [ 'class="table-title" colspan=' . @column_headers ] ), 1 );
    foreach my $item ( @{$dnsmconfig{$configfield}} ) {
        $count++;
        next if ($item->{"val"}->{"ipversion"} == $version_excluded);
        local @cols;
        push ( @cols, &ui_checkbox("enabled", "1", "", $item->{"used"}?1:0, undef, 1) );
        my @vals = ( );
        foreach my $param ( @{$definition->{"param_order"}} ) {
            next if ($definition->{$param}->{"ipversion"} == $version_excluded);
            if ($definition->{$param}->{"arr"} == 1) {
                push( @vals, join($definition->{$param}->{"sep"}, @{$item->{"val"}->{$param}}) );
            }
            elsif ($definition->{$param}->{"valtype"} eq "bool") {
                push( @vals, &ui_checkbox(undef, "1", "", $item->{"val"}->{$param} ));
            }
            else {
                push( @vals, $item->{"val"}->{$param} );
            }
        }
        foreach my $val ( @vals ) {
            # first call to &edit_item_link should capture link and fields; subsequent calls (1 for each field) only need the link
            if ( ! $hidden_edit_input_fields) {
                ($edit_link, $hidden_edit_input_fields) = &edit_item_link($val, $internalfield, $text{"p_desc_$internalfield"}, $count, $formid, \@editfields, $item->{"cfg_idx"}, ($in{"show_validation"} ? "show_validation=" . $in{"show_validation"} : "") . "&ipversion=ip" . $ipver);
            }
            else {
                ($edit_link) = &edit_item_link($val, $internalfield, $text{"p_desc_$internalfield"}, $count, $formid, \@editfields, $item->{"cfg_idx"}, ($in{"show_validation"} ? "show_validation=" . $in{"show_validation"} : "") . "&ipversion=ip" . $ipver);
            }
            push( @cols, $edit_link );
        }
        print &ui_clickable_checked_columns_row( \@cols, \@tds, "sel", $count );
    }
    print &ui_columns_end();
    print &ui_links_row(\@list_link_buttons);
    print "<p>" . $text{"with_selected"} . "</p>";
    print &ui_submit($text{"button_enable_sel"}, "enable_sel_$internalfield");
    print &ui_submit($text{"button_disable_sel"}, "disable_sel_$internalfield");
    print &ui_submit($text{"button_delete_sel"}, "delete_sel_$internalfield");
    print $hidden_add_input_fields;
    print $hidden_edit_input_fields;
    print &ui_form_end();
}

my @tabs = (   [ 'ip4', $text{"dhcp_ipversion4"} ],
            [ 'ip6', $text{"dhcp_ipversion6"} ] );
my $ipversion = $in{"ipversion"} || "ip4";
print &ui_tabs_start(\@tabs, "ipversion", $ipversion);

print &ui_tabs_start_tab("ipversion", 'ip4');
&show_dhcp_option_list(4, $formidx++);
print &ui_tabs_end_tab("ipversion", 'ip4');

print &ui_tabs_start_tab("ipversion", 'ip6');
&show_dhcp_option_list(6, $formidx++);
print &ui_tabs_end_tab("ipversion", 'ip6');

print &ui_tabs_end();

print &add_js();

&ui_print_footer("index.cgi?tab=dhcp", $text{"index_dhcp_settings"}, "index.cgi?tab=dns", $text{"index_dns_settings"});

### END of dhcp_client_options.cgi ###.
