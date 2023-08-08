#!/usr/bin/perl
#
#    DNSMasq Webmin Module - # TODO dns_servers.cgi; Upstream Servers config
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

# &header($text{"index_title"}, "", "intro", 1, 0, 0, &restart_button(), &header_js(), "body-stuff-test", $text{"index_dns_servers"});
&header($text{"index_title"}, "", "intro", 1, 0, 0, &restart_button(), "<script type='text/javascript>//test</script>", "body-stuff-test", $text{"index_dns_servers"});

my $returnto = $in{"returnto"} || "dns_servers.cgi";
my $returnlabel = $in{"returnlabel"} || $text{"index_dns_servers"};
my $apply_cgi = "dns_servers_apply.cgi";

sub show_server {
    my $formid = "dns_upstream_servers_form";
    my $internalfield = "server";
    my $configfield = &internal_to_config($internalfield);
    my @newfields = ( "domain", "ip", "source" );
    my @editfields = ( "idx", @newfields );
    my @list_link_buttons = &list_links( "sel", 0 );
    my ($button, $hidden_add_input_fields, $add_new_script) = &add_item_button(&text("add_", $text{"_upstream_srv"}), $internalfield, $text{"index_dns_servers"}, 700, 505, $formid, \@newfields );
    push(@list_link_buttons, $button);

    my $count=0;
    print &ui_form_start( $apply_cgi, "post", undef, "id='$formid'" );
    print &ui_links_row(\@list_link_buttons);
    my @edit_link = ( "", "", "" );
    my $w = 700;
    my $h = 505;
    my $hidden_edit_input_fields;
    my $edit_script;
    my @tds = ( $td_left, $td_left, $td_left, $td_left, $td_left, $td_left );
    print &ui_columns_start( [
        "",
        $text{"enabled"},
        $text{"domain"},
        $text{"ip_address"},
        $text{"source"},
        ""
        ], 100, undef, undef, &ui_columns_header( [ &show_title_with_help($internalfield, $configfield) ], [ 'class="table-title" colspan=6' ] ), 1 );
    foreach my $server ( @{$dnsmconfig{"server"}} ) {
        local %val = %{ $server->{"val"} };
        local @cols;
        local $mover;
        $mover = &get_mover_buttons("item_move.cgi?internalfield=$internalfield&returnto=$returnto&returnlabel=$returnlabel", $count, int(@{$dnsmconfig{"server"}}) );
        ($edit_link[0], $hidden_edit_input_fields, $edit_script) = &edit_item_link(join(",", @{$val{"domain"}}), $internalfield, $text{"index_dns_servers"}, $count, $formid, $w, $h, \@editfields);
        ($edit_link[1]) = &edit_item_link($val{"ip"}, $internalfield, $text{"index_dns_servers"}, $count, $formid, $w, $h, \@editfields);
        ($edit_link[2]) = &edit_item_link($val{"source"}, $internalfield, $text{"index_dns_servers"}, $count, $formid, $w, $h, \@editfields);
        push ( @cols, &ui_checkbox("enabled", "1", "", $server->{"used"}?1:0, undef, 1) );
        push ( @cols, $edit_link[0] );
        push ( @cols, $edit_link[1] );
        push ( @cols, $edit_link[2] );
        push ( @cols, $mover );
        # print &ui_checked_columns_row( \@cols, \@tds, "sel", $count );
        # print &ui_clickable_checked_columns_row( \@cols, \@tds, "sel", $count );
        print &ui_clickable_checked_columns_row( \@cols, undef, "sel", $count );
        $count++;
    }
    print &ui_columns_end();
    print &ui_links_row(\@list_link_buttons);
    print "<p>" . $text{"with_selected"} . "</p>";
    print &ui_submit($text{"enable_sel"}, "enable_sel_$internalfield");
    print &ui_submit($text{"disable_sel"}, "disable_sel_$internalfield");
    print &ui_submit($text{"delete_sel"}, "delete_sel_$internalfield");
    print $hidden_add_input_fields . $add_new_script;
    print $hidden_edit_input_fields . $edit_script;
    print &ui_form_end();
    print &ui_hr();
}

sub show_rev_server {
    my $internalfield = "rev_server";
    my $configfield = &internal_to_config($internalfield);
    my $formid = $internalfield . "_form";
    my @newfields = ( "domain", "ip", "source" );
    my @editfields = ( "idx", @newfields );
    my @list_link_buttons = &list_links( "sel", 0 );
    my ($button, $hidden_add_input_fields, $add_new_script) = &add_item_button(&text("add_", $text{"_upstream_srv"}), $internalfield, $text{"table_upstream_dns_rev_servers"}, 700, 505, $formid, \@newfields );
    push(@list_link_buttons, $button);

    my $count=0;
    print &ui_form_start( $apply_cgi, "post", undef, "id='$formid'" );
    print &ui_links_row(\@list_link_buttons);
    my $edit_link = ( "", "", "" );
    my $w = 700;
    my $h = 505;
    my $hidden_edit_input_fields;
    my $edit_script;
    # my @tds = ( $td_left, $td_left, $td_left, $td_left, $td_left, $td_left );
    print &ui_columns_start( [
        "",
        $text{"enabled"},
        $text{"domain"},
        $text{"ip_address"},
        $text{"source"},
        ""
        ], 100, undef, undef, &ui_columns_header( [ &show_title_with_help($internalfield, $configfield) ], [ 'class="table-title" colspan=6' ] ), 1 );
    foreach my $server ( @{$dnsmconfig{$configfield}} ) {
        local %val = %{ $server->{"val"} };
        local @cols;
        local $mover;
        $mover = &get_mover_buttons("item_move.cgi?internalfield=$internalfield&returnto=$returnto&returnlabel=$returnlabel", $count, int(@{$dnsmconfig{$configfield}}) );
        ($edit_link[0], $hidden_edit_input_fields, $edit_script) = &edit_item_link(join(",", @{$val{"domain"}}), $internalfield, $text{"table_upstream_dns_rev_servers"}, $count, $formid, $w, $h, \@editfields);
        ($edit_link[1]) = &edit_item_link($val{"ip"}, $internalfield, $text{"table_upstream_dns_rev_servers"}, $count, $formid, $w, $h, \@editfields);
        ($edit_link[2]) = &edit_item_link($val{"source"}, $internalfield, $text{"table_upstream_dns_rev_servers"}, $count, $formid, $w, $h, \@editfields);
        push ( @cols, &ui_checkbox("enabled", "1", "", $server->{"used"}?1:0, undef, 1) );
        push ( @cols, $edit_link[0] );
        push ( @cols, $edit_link[1] );
        push ( @cols, $edit_link[2] );
        push ( @cols, $mover );
        # print &ui_checked_columns_row( \@cols, \@tds, "sel", $count );
        print &ui_clickable_checked_columns_row( \@cols, undef, "sel", $count );
        $count++;
    }
    print &ui_columns_end();
    print &ui_links_row(\@list_link_buttons);
    print "<p>" . $text{"with_selected"} . "</p>";
    print &ui_submit($text{"enable_sel"}, "enable_sel_$internalfield");
    print &ui_submit($text{"disable_sel"}, "disable_sel_$internalfield");
    print &ui_submit($text{"delete_sel"}, "delete_sel_$internalfield");
    print $hidden_add_input_fields. $add_new_script;
    print $hidden_edit_input_fields . $edit_script;
    print &ui_form_end();
}

@tabs = (   [ 'basic', $text{'index_basic'} ],
            [ 'server', $text{"p_desc_server"} ],
            [ 'rev_server', $text{"p_desc_rev_server"} ] );
my $mode = $in{mode} || "basic";
print ui_tabs_start(\@tabs, 'mode', $mode);

print ui_tabs_start_tab('mode', 'basic');
my @page_fields = ();
foreach my $configfield ( @confdns ) {
    next if ( %dnsmconfigvals{"$configfield"}->{"page"} ne "2" );
    push( @page_fields, $configfield );
}
&show_basic_fields( \%dnsmconfig, "dns_servers", \@page_fields, $apply_cgi, $text{"index_dns_servers"} );
&show_other_fields( \%dnsmconfig, "dns_servers", \@page_fields, $apply_cgi, $text{"index_dns_servers"} );
print ui_tabs_end_tab('mode', 'basic');

print ui_tabs_start_tab('mode', 'server');
&show_server();
print ui_tabs_end_tab('mode', 'server');

print ui_tabs_start_tab('mode', 'rev_server');
&show_rev_server();
print ui_tabs_end_tab('mode', 'rev_server');

print ui_tabs_end();

print &add_js();

ui_print_footer("index.cgi?mode=dns", $text{"index_dns_settings"});

### END of dns_servers.cgi ###.
