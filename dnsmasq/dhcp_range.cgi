#!/usr/bin/perl
#
#    DNSMasq Webmin Module - # TODO dhcp_range.cgi; DHCP address ranges
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

&header($text{"index_title"}, "", "intro", 1, 0, 0, &restart_button(), undef, undef, $text{"index_dhcp_range"});
print &header_style();

my $returnto = $in{"returnto"} || "dhcp_range.cgi";
my $returnlabel = $in{"returnlabel"} || $text{"index_dhcp_range"};
my $apply_cgi = "dhcp_range_apply.cgi";

our $internalfield = "dhcp_range";
my $configfield = &internal_to_config($internalfield);
my $definition = %configfield_fields{$internalfield};

sub show_ip4 {
    my $edit_link;
    my $hidden_edit_input_fields;
    my @modes = ();
    my @newfields = ( "ipversion" );
    foreach my $param ( @{$definition->{"param_order"}} ) {
        next if ($definition->{$param}->{"ipversion"} == 6);
        if ($definition->{$param}->{"valtype"} eq "bool") {
            push( @modes, $param );
        }
        push( @newfields, $param );
    }
    my @editfields = ( "idx", @newfields );
    my $formid = $internalfield . "_4_form";
    my @tds = ( $td_label, $td_left, $td_left ); # extra column for set-tags
    my @column_headers = ( "",
        $text{"enabled"},
        $text{"p_label_val_start_ip_address"},
        $text{"p_label_val_end_ip_address"},
        $text{"p_label_val_netmask"},
        $text{"p_label_val_broadcast"},
        $text{"p_label_val_leasetime"},
        $text{"p_label_val_tags"}, 
        $text{"p_label_val_set_tag"} );
    foreach my $bool ( @modes ) {
        push( @column_headers, $text{"p_label_val_short_" . $bool} . &ui_help($text{"p_label_val_" . $bool}) );
    }
    foreach my $param ( @newfields ) {
        push( @tds, $td_left );
    }
    # my @list_link_buttons = &list_links( "sel", 0, $apply_cgi, "dhcp-range=0.0.0.0,0.0.0.0", $returnto, &text("add_", $text{"_range"}) );
    my @list_link_buttons = &list_links( "sel", 3 );
    my ($add_button, $hidden_add_input_fields) = &add_item_button(&text("add_", $text{"_range"}), $internalfield, $text{"p_desc_$internalfield"}, $formid, \@newfields, "ipversion=ip4" );
    push(@list_link_buttons, $add_button);

    my $count = -1;
    print &ui_form_start( $apply_cgi . "?mode=modal_ip4", "post", undef, "id='$formid'" );
    print &ui_links_row(\@list_link_buttons);
    print &ui_columns_start( \@column_headers, 100, undef, undef, &ui_columns_header( [ &show_title_with_help($internalfield, $configfield) ], [ 'class="table-title" colspan=' . @column_headers ] ), 1 );
    foreach my $item ( @{$dnsmconfig{$configfield}} ) {
        $count++;
        next if ($item->{"val"}->{"ipversion"} == 6);
        local @cols;
        push ( @cols, &ui_checkbox("enabled", "1", "", $item->{"used"}?1:0, undef, 1) );
        my @vals = ( 
            $item->{"val"}->{"start"}, 
            $item->{"val"}->{"end"}, 
            $item->{"val"}->{"mask"}, 
            $item->{"val"}->{"broadcast"}, 
            $item->{"val"}->{"leasetime"}, 
            join(",", @{$item->{"val"}->{"tag"}}), 
            $item->{"val"}->{"settag"} );
        foreach my $bool ( @modes ) {
            push( @vals, &ui_checkbox(undef, "1", "", $item->{"val"}->{$bool} ));
        }
        foreach my $val ( @vals ) {
            # first call to &edit_item_link should capture link and fields; subsequent calls (1 for each field) only need the link
            if ( ! $hidden_edit_input_fields) {
                ($edit_link, $hidden_edit_input_fields) = &edit_item_link($val, $internalfield, $text{"p_desc_$internalfield"}, $count, $formid, \@editfields, "ipversion=ip4");
            }
            else {
                ($edit_link) = &edit_item_link($val, $internalfield, $text{"p_desc_$internalfield"}, $count, $formid, \@editfields, "ipversion=ip4");
            }
            push( @cols, $edit_link );
        }
        print &ui_clickable_checked_columns_row( \@cols, \@tds, "sel", $count );
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
}

sub show_ip6 {
    my $edit_link;
    my $hidden_edit_input_fields;
    my @modes = ();
    my @newfields = ( "ipversion" );
    foreach my $param ( @{$definition->{"param_order"}} ) {
        next if ($definition->{$param}->{"ipversion"} == 4);
        if ($definition->{$param}->{"valtype"} eq "bool") {
            push( @modes, $param );
        }
        push( @newfields, $param );
    }
    my @editfields = ( "idx", @newfields );
    my $formid = $internalfield . "_6_form";
    my @tds = ( $td_label, $td_left, $td_left ); # extra column for set-tags
    my @column_headers = ( "",
        $text{"enabled"},
        $text{"p_label_val_start_ip_address"},
        $text{"p_label_val_end_ip_address"},
        $text{"p_label_val_prefix_length"},
        $text{"p_label_val_leasetime"},
        $text{"p_label_val_tags"}, 
        $text{"p_label_val_set_tag"} );
    foreach my $bool ( @modes ) {
        push( @column_headers, $text{"p_label_val_short_" . $bool} . &ui_help($text{"p_label_val_" . $bool}) );
    }
    foreach my $param ( @newfields ) {
        push( @tds, $td_left );
    }
    my @list_link_buttons = &list_links( "sel", 3 );
    my ($add_button, $hidden_add_input_fields) = &add_item_button(&text("add_", $text{"_range"}), $internalfield, $text{"p_desc_$internalfield"}, $formid, \@newfields, "ipversion=ip6" );
    push(@list_link_buttons, $add_button);

    my $count = -1;
    print &ui_form_start( $apply_cgi . "?mode=modal_ip4", "post", undef, "id='$formid'" );
    print &ui_links_row(\@list_link_buttons);
    print &ui_columns_start( \@column_headers, 100, undef, undef, &ui_columns_header( [ &show_title_with_help($internalfield, $configfield) ], [ 'class="table-title" colspan=' . @column_headers ] ), 1 );
    foreach my $item ( @{$dnsmconfig{$configfield}} ) {
        $count++;
        next if ($item->{"val"}->{"ipversion"} == 4);
        local @cols;
        push ( @cols, &ui_checkbox("enabled", "1", "", $item->{"used"}?1:0, undef, 1) );
        my @vals = ( 
            $item->{"val"}->{"start"}, 
            $item->{"val"}->{"end"}, 
            $item->{"val"}->{"prefix-length"}, 
            $item->{"val"}->{"leasetime"}, 
            join(",", @{$item->{"val"}->{"tag"}}), 
            $item->{"val"}->{"settag"} );
        foreach my $bool ( @modes ) {
            push( @vals, &ui_checkbox(undef, "1", "", $item->{"val"}->{$bool} ));
        }
        foreach my $val ( @vals ) {
            # first call to &edit_item_link should capture link and fields; subsequent calls (1 for each field) only need the link
            if ( ! $hidden_edit_input_fields) {
                ($edit_link, $hidden_edit_input_fields) = &edit_item_link($val, $internalfield, $text{"p_desc_$internalfield"}, $count, $formid, \@editfields, "ipversion=ip6");
            }
            else {
                ($edit_link) = &edit_item_link($val, $internalfield, $text{"p_desc_$internalfield"}, $count, $formid, \@editfields, "ipversion=ip6");
            }
            push( @cols, $edit_link );
        }
        print &ui_clickable_checked_columns_row( \@cols, undef, "sel", $count );
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
}

my @tabs = (   [ 'ip4', $text{"dhcp_ipversion4"} ],
            [ 'ip6', $text{"dhcp_ipversion6"} ] );
my $ipversion = $in{"ipversion"} || "ip4";
print ui_tabs_start(\@tabs, "ipversion", $ipversion);

print ui_tabs_start_tab("ipversion", 'ip4');
&show_ip4();
print ui_tabs_end_tab("ipversion", 'ip4');

print ui_tabs_start_tab("ipversion", 'ip6');
&show_ip6();
print ui_tabs_end_tab("ipversion", 'ip6');

print ui_tabs_end();

print &add_js();

ui_print_footer("index.cgi?mode=dhcp", $text{"index_dhcp_settings"}, "index.cgi?mode=dns", $text{"index_dns_settings"});

### END of dhcp_range.cgi ###.
