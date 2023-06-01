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

&header($text{"index_title"}, "", "intro", 1, 0, 0, &restart_button());

my $config_filename = $config{config_file};
my $config_file = &read_file_lines( $config_filename );

&parse_config_file( \%dnsmconfig, \$config_file, $config_filename );

sub show_alias {
    my @edit_link = ( "", "", "" );
    my $hidden_edit_input_fields;
    my $edit_script;
    my $formid = "alias_form";
    my $context = "alias";
    my @newfields = ( "from", "to", "netmask" );
    my @editfields = ( "idx", @newfields );
    my $w = 500;
    my $h = 505;
    # my @list_link_buttons = &list_links( "sel", 0, "dns_alias_apply.cgi", "alias=0.0.0.0,0.0.0.0", "dns_alias.cgi", &text("add_", $text{"_alias"}) );
    my @list_link_buttons = &list_links( "sel", 0 );
    my ($add_new_button, $hidden_add_input_fields, $add_new_script) = &add_item_button(&text("add_", $text{"_alias"}), $context, $text{"alias"}, 500, 505, $formid, \@newfields );
    push(@list_link_buttons, $add_new_button);
    my @tds = ( $td_left, $td_left, $td_left, $td_left, $td_left, $td_left );

    # uses the index_title entry from ./lang/en or appropriate
    my $count=0;
    print &ui_form_start( "dns_alias_apply.cgi", "post", undef, "id=\"$formid\"" );
    print &ui_links_row(\@list_link_buttons);
    print $hidden_add_input_fields . $add_new_script;
    print &ui_columns_start( [ 
        "",
        $text{"enabled"},
        $text{"from_ip"},
        $text{"to_ip"},
        $text{"netmask"},
        ], 100, undef, undef, &ui_columns_header( [ $text{"alias"} . &ui_help($text{"p_man_desc_alias"}) ], [ 'class="table-title" colspan=5' ] ), 1 );
    foreach my $alias ( @{$dnsmconfig{"alias"}} ) {
        local %val = %{ $alias->{"val"} };
        local @cols;
        ($edit_link[0], $hidden_edit_input_fields, $edit_script) = &edit_item_link($val{"from"}, $context, $text{"alias"}, $count, $formid, $w, $h, \@editfields);
        ($edit_link[1]) = &edit_item_link($val{"to"}, $context, $text{"alias"}, $count, $formid, $w, $h, \@editfields);
        ($edit_link[2]) = &edit_item_link($val{"netmask-used"} ? $val{"netmask"} : "(255.255.255.255)", $context, $text{"alias"}, $count, $formid, $w, $h, \@editfields);
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
    print &ui_submit($text{"enable_sel"}, "enable_sel_alias");
    print &ui_submit($text{"disable_sel"}, "disable_sel_alias");
    print &ui_submit($text{"delete_sel"}, "delete_sel_alias");
    print $hidden_edit_input_fields . $edit_script;
    print &ui_form_end();
}

sub show_nx {
    my @edit_link = ( "" );
    my $hidden_edit_input_fields;
    my $edit_script;
    my $formid = "nx_form";
    my $context = "bogus_nxdomain";
    my @newfields = ( "ip" );
    my @editfields = ( "idx", @newfields );
    my $w = 500;
    my $h = 375;
    # my @list_link_buttons = &list_links( "sel", 1, "dns_nx_apply.cgi", "bogus-nxdomain=0.0.0.0", ".cgi", &text("add_", $text{"_nx"}) );
    my @list_link_buttons = &list_links( "sel", 1 );
    my ($add_new_button, $hidden_add_input_fields, $add_new_script) = &add_item_button(&text("add_", $text{"_nx"}), $context, $text{"nx"}, $w, $h, $formid, \@newfields );
    push(@list_link_buttons, $add_new_button);
    my @tds = ( $td_left, $td_left, $td_left );

    my $count=0;
    print &ui_form_start( "dns_alias_apply.cgi", "post", undef, "id=\"$formid\"" );
    print &ui_links_row(\@list_link_buttons);
    print $hidden_add_input_fields . $add_new_script;
    print &ui_columns_start( [
        "",
        $text{"enabled"},
        $text{"ip_address"},
        ], 100, undef, undef, &ui_columns_header( [ $text{"nx"} . &ui_help($text{"p_man_desc_bogus_nxdomain"}) ], [ 'class="table-title" colspan=3' ] ), 1 );
    foreach my $nxdomain ( @{$dnsmconfig{"bogus-nxdomain"}} ) {
        local %val = %{ $nxdomain->{"val"} };
        local @cols;
        ($edit_link[0], $hidden_edit_input_fields, $edit_script) = &edit_item_link($val{"addr"}, $context, $text{"nx"}, $count, $formid, $w, $h, \@editfields);
        push ( @cols, &ui_checkbox("enabled", "1", "", $nxdomain->{"used"}?1:0, undef, 1) );
        # push ( @cols, $edit );
        push ( @cols, $edit_link[0] );
        print &ui_checked_columns_row( \@cols, \@tds, "sel", $count );
        $count++;
    }
    print &ui_columns_end();
    print &ui_links_row(\@list_link_buttons);
    print "<p>" . $text{"with_selected"} . "</p>";
    print &ui_submit($text{"enable_sel"}, "enable_sel_nx");
    print &ui_submit($text{"disable_sel"}, "disable_sel_nx");
    print &ui_submit($text{"delete_sel"}, "delete_sel_nx");
    print $hidden_edit_input_fields . $edit_script;
    print &ui_form_end();
}

&show_alias();
print "<hr>";
&show_nx();
print &add_js(1, 1, 0);

ui_print_footer("index.cgi?mode=dns", $text{"index_dns_settings"});

### END of dns_alias.cgi ###.
