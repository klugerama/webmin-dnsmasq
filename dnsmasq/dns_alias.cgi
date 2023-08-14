#!/usr/bin/perl
#
#    DNSMasq Webmin Module - # TODO dns_alias.cgi; aliasing and redirection
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

&header($text{"index_title"}, "", "intro", 1, 0, 0, &restart_button(), "<script type='text/javascript'>//test</script>", "body-stuff-test", $text{"index_dns_alias_settings"});

my $returnto = $in{"returnto"} || "dns_alias.cgi";
my $returnlabel = $in{"returnlabel"} || $text{"index_dns_alias_settings"};
my $apply_cgi = "dns_alias_apply.cgi";

sub show_alias {
    my $formid = "alias_form";
    my $internalfield = "alias";
    my $configfield = &internal_to_config($internalfield);
    my @newfields = ( "from", "to", "netmask" );
    my @editfields = ( "idx", @newfields );
    my @list_link_buttons = &list_links( "sel", 0 );
    my ($add_new_button, $hidden_add_input_fields) = &add_item_button(&text("add_", $text{"_alias"}), $internalfield, $text{"alias"}, $w, $h, $formid, \@newfields );
    push(@list_link_buttons, $add_new_button);

    my $count=0;
    print &ui_form_start( $apply_cgi . "?mode=alias", "post", undef, "id=\"$formid\"" );
    print &ui_links_row(\@list_link_buttons);
    my @edit_link = ( "", "", "" );
    my $w = 500;
    my $h = 505;
    my $hidden_edit_input_fields;
    my @tds = ( $td_left, $td_left, $td_left, $td_left, $td_left, $td_left );
    print &ui_columns_start( [ 
        "",
        $text{"enabled"},
        $text{"p_label_val_start_ip_address"},
        $text{"p_label_val_end_ip_address"},
        $text{"p_label_val_netmask"},
        ], 100, undef, undef, &ui_columns_header( [ &show_title_with_help($internalfield, $configfield) ], [ 'class="table-title" colspan=5' ] ), 1 );
    foreach my $item ( @{$dnsmconfig{$configfield}} ) {
        local %val = %{ $item->{"val"} };
        local @cols;
        ($edit_link[0], $hidden_edit_input_fields) = &edit_item_link($val{"from"}, $internalfield, $text{"p_desc_$internalfield"}, $count, $formid, $w, $h, \@editfields);
        ($edit_link[1]) = &edit_item_link($val{"to"}, $internalfield, $text{"p_desc_$internalfield"}, $count, $formid, $w, $h, \@editfields);
        ($edit_link[2]) = &edit_item_link($val{"netmask-used"} ? $val{"netmask"} : "(255.255.255.255)", $internalfield, $text{"p_desc_$internalfield"}, $count, $formid, $w, $h, \@editfields);
        push ( @cols, &ui_checkbox("enabled", "1", "", $item->{"used"}?1:0, undef, 1) );
        push ( @cols, $edit_link[0] );
        push ( @cols, $edit_link[1] );
        push ( @cols, $edit_link[2] );
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

sub show_nx {
    my @edit_link = ( "" );
    my $hidden_edit_input_fields;
    my $internalfield = "bogus_nxdomain";
    my $configfield = &internal_to_config($internalfield);
    my $formid = $internalfield . "_form";
    my @newfields = ( "ip" );
    my @editfields = ( "idx", @newfields );
    my $w = 500;
    my $h = 375;
    my @list_link_buttons = &list_links( "sel", 1 );
    my ($add_new_button, $hidden_add_input_fields) = &add_item_button(&text("add_", $text{"_nx"}), $internalfield, $text{"p_desc_$internalfield"}, $w, $h, $formid, \@newfields );
    push(@list_link_buttons, $add_new_button);
    my @tds = ( $td_left, $td_left, $td_left );

    my $count=0;
    print &ui_form_start( "dns_alias_apply.cgi", "post", undef, "id=\"$formid\"" );
    print &ui_links_row(\@list_link_buttons);
    print $hidden_add_input_fields;
    print &ui_columns_start( [
        "",
        $text{"enabled"},
        $text{"ip_address"},
        ], 100, undef, undef, &ui_columns_header( [ &show_title_with_help($internalfield, $configfield) ], [ 'class="table-title" colspan=3' ] ), 1 );
    foreach my $item ( @{$dnsmconfig{$configfield}} ) {
        local %val = %{ $item->{"val"} };
        local @cols;
        ($edit_link[0], $hidden_edit_input_fields) = &edit_item_link($val{"addr"}, $internalfield, $text{"p_desc_$internalfield"}, $count, $formid, $w, $h, \@editfields);
        push ( @cols, &ui_checkbox("enabled", "1", "", $item->{"used"}?1:0, undef, 1) );
        push ( @cols, $edit_link[0] );
        print &ui_clickable_checked_columns_row( \@cols, \@tds, "sel", $count );
        $count++;
    }
    print &ui_columns_end();
    print &ui_links_row(\@list_link_buttons);
    print "<p>" . $text{"with_selected"} . "</p>";
    print &ui_submit($text{"enable_sel"}, "enable_sel_$internalfield");
    print &ui_submit($text{"disable_sel"}, "disable_sel_$internalfield");
    print &ui_submit($text{"delete_sel"}, "delete_sel_$internalfield");
    print $hidden_edit_input_fields;
    print &ui_form_end();
    print &ui_hr();
}

sub show_address {
    my @edit_link = ( "", "", "" );
    my $hidden_edit_input_fields;
    my $internalfield = "address";
    my $configfield = &internal_to_config($internalfield);
    my $formid = $internalfield . "_form";
    my @newfields = ( "domain", "addr" );
    my @editfields = ( "idx", @newfields );
    my $w = 500;
    my $h = 565;
    my @list_link_buttons = &list_links( "sel", 0 );
    my ($add_new_button, $hidden_add_input_fields) = &add_item_button(&text("add_", $text{"_addr"}), $internalfield, $text{"p_desc_$internalfield"}, $w, $h, $formid, \@newfields );
    push(@list_link_buttons, $add_new_button);
    my @tds = ( $td_left, $td_left, $td_left, $td_left );

    my $count=0;
    print &ui_form_start( "dns_alias_apply.cgi", "post", undef, "id=\"$formid\"" );
    print &ui_links_row(\@list_link_buttons);
    print $hidden_add_input_fields;
    print &ui_columns_start( [ 
        "",
        $text{"enabled"},
        $text{"domain"},
        $text{"ip_address"},
        ], 100, undef, undef, &ui_columns_header( [ &show_title_with_help($internalfield, $configfield) ], [ 'class="table-title" colspan=4' ] ), 1 );
    foreach my $item ( @{$dnsmconfig{$configfield}} ) {
        local %val = %{ $item->{"val"} };
        local @cols;
        ($edit_link[0], $hidden_edit_input_fields) = &edit_item_link($val{"domain"}, $internalfield, $text{"p_desc_$internalfield"}, $count, $formid, $w, $h, \@editfields);
        ($edit_link[1]) = &edit_item_link($val{"addr"}, $internalfield, $text{"p_desc_$internalfield"}, $count, $formid, $w, $h, \@editfields);
        push ( @cols, &ui_checkbox("enabled", "1", "", $item->{"used"}?1:0, undef, 1) );
        push ( @cols, $edit_link[0] );
        push ( @cols, $edit_link[1] );
        print &ui_clickable_checked_columns_row( \@cols, \@tds, "sel", $count );
        $count++;
    }
    print &ui_columns_end();
    print &ui_links_row(\@list_link_buttons);
    print "<p>" . $text{"with_selected"} . "</p>";
    print &ui_submit($text{"enable_sel"}, "enable_sel_$internalfield");
    print &ui_submit($text{"disable_sel"}, "disable_sel_$internalfield");
    print &ui_submit($text{"delete_sel"}, "delete_sel_$internalfield");
    print $hidden_edit_input_fields;
    print &ui_form_end();
    print &ui_hr();
}

sub show_ignore_address {
    my @edit_link = ( "", "", "" );
    my $hidden_edit_input_fields;
    my $internalfield = "ignore_address";
    my $configfield = &internal_to_config($internalfield);
    my $formid = $internalfield . "_form";
    my @newfields = ( "ip" );
    my @editfields = ( "idx", @newfields );
    my $w = 500;
    my $h = 565;
    my @list_link_buttons = &list_links( "sel", 0 );
    my ($add_new_button, $hidden_add_input_fields) = &add_item_button(&text("add_", $text{"_addr"}), $internalfield, $text{"p_desc_$internalfield"}, $w, $h, $formid, \@newfields );
    push(@list_link_buttons, $add_new_button);
    my @tds = ( $td_left, $td_left, $td_left, $td_left );

    my $count=0;
    print &ui_form_start( "dns_alias_apply.cgi", "post", undef, "id=\"$formid\"" );
    print &ui_links_row(\@list_link_buttons);
    print &ui_columns_start( [ 
        "",
        $text{"enabled"},
        $text{"ip_address"},
        ], 100, undef, undef, &ui_columns_header( [ &show_title_with_help($internalfield, $configfield) ], [ 'class="table-title" colspan=3' ] ), 1 );
    foreach my $item ( @{$dnsmconfig{$configfield}} ) {
        local %val = %{ $item->{"val"} };
        local @cols;
        ($edit_link[0], $hidden_edit_input_fields) = &edit_item_link($val{"ip"}, $internalfield, $text{"p_desc_$internalfield"}, $count, $formid, $w, $h, \@editfields);
        push ( @cols, &ui_checkbox("enabled", "1", "", $item->{"used"}?1:0, undef, 1) );
        push ( @cols, $edit_link[0] );
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
}

my @page_fields = ();
foreach my $configfield ( @confdns ) {
    next if ( %dnsmconfigvals{"$configfield"}->{"page"} ne "4" );
    push( @page_fields, $configfield );
}
@tabs = (
            [ 'basic', $text{'index_basic'} ],
            [ 'other', $text{"index_other"} ],
            [ 'alias', $text{"p_desc_alias"} ],
            [ 'nx', $text{"p_desc_bogus_nxdomain"} ],
            [ 'address', $text{"p_desc_address"} ],
            [ 'ignore_address', $text{"p_desc_ignore_address"} ]
        );
my $mode = $in{mode} || "basic";
print ui_tabs_start(\@tabs, 'mode', $mode);

print ui_tabs_start_tab('mode', 'basic');
&show_basic_fields( \%dnsmconfig, "dns_alias", \@page_fields, $apply_cgi, $text{"index_dns_alias"} );
print ui_tabs_end_tab('mode', 'basic');

print ui_tabs_start_tab('mode', 'other');
&show_other_fields( \%dnsmconfig, "dns_alias", \@page_fields, $apply_cgi, $text{"index_other"} );
print ui_tabs_end_tab('mode', 'other');

print ui_tabs_start_tab('mode', 'alias');
&show_alias();
print ui_tabs_end_tab('mode', 'alias');

print ui_tabs_start_tab('mode', 'nx');
&show_nx();
print ui_tabs_end_tab('mode', 'nx');

print ui_tabs_start_tab('mode', 'address');
&show_address();
print ui_tabs_end_tab('mode', 'address');

print ui_tabs_start_tab('mode', 'ignore_address');
&show_ignore_address();
print ui_tabs_end_tab('mode', 'ignore_address');

print ui_tabs_end();

print &add_js();

ui_print_footer("index.cgi?mode=dns", $text{"index_dns_settings"});

### END of dns_alias.cgi ###.
