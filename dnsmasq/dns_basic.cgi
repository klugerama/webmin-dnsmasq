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

&header($text{"index_title"}, "", "intro", 1, 0, 0, &restart_button(), undef, undef, $text{"index_dns_settings_basic"});

my $returnto = $in{"returnto"} || "dns_basic.cgi";
my $returnlabel = $in{"returnlabel"} || $text{"index_dns_settings_basic"};
my $apply_cgi = "dns_basic_apply.cgi";

sub show_addn_hosts {
    my $internalfield = "addn_hosts";
    my $configfield = &internal_to_config($internalfield);
    my $count=0;
    my $formid = $internalfield . "_form";
    my $g = &ui_form_start( $apply_cgi, "post", undef, "id='$formid'" );
    my @list_link_buttons = &list_links( "sel", 2 );
    my ($file_chooser_button, $hidden_input_fields, $submit_script) = &add_file_chooser_button( &text("add_", $text{"_hostsfile"}), "new_" . $internalfield . "_file", 0, $formid );
    $g .= &ui_links_row(\@list_link_buttons);
    $g .= $hidden_input_fields;
    $g .= $file_chooser_button;
    $g.= &ui_columns_start( [ 
        # "line", 
        # $text{""}, 
        "",
        $text{"enabled"}, 
        $text{"filename"}, 
        # "full" 
    ], 100, undef, undef, &ui_columns_header( [ &show_title_with_help($internalfield, $configfield) ], [ 'class="table-title" colspan=3' ] ), 1 );

    foreach my $hosts ( @{$dnsmconfig{$configfield}} ) {
        local @cols;
        push ( @cols, &ui_checkbox("enabled", "1", "", $hosts->{"used"}?1:0, undef, 1) );
        push ( @cols, $hosts->{"val"} );
        $g .= &ui_checked_columns_row( \@cols, undef, "sel", $count );
        $count++;
    }
    $g .= &ui_columns_end();
    $g .= &ui_links_row(\@list_link_buttons);
    $g .= $hidden_input_fields;
    $g .= $file_chooser_button;
    $g .= "<p>" . $text{"with_selected"} . "</p>";
    $g .= &ui_submit($text{"enable_sel"}, "enable_sel_$internalfield");
    $g .= &ui_submit($text{"disable_sel"}, "disable_sel_$internalfield");
    $g .= &ui_submit($text{"delete_sel"}, "delete_sel_$internalfield");
    $g .= $submit_script;
    $g .= &ui_form_end( );
    print $g;
}

sub show_hostsdir {
    my $internalfield = "hostsdir";
    my $configfield = &internal_to_config($internalfield);
    my $count=0;
    my $formid = $internalfield . "_form";
    my $g = &ui_form_start( $apply_cgi, "post", undef, "id='$formid'" );
    my @list_link_buttons = &list_links( "sel", 2);
    my ($file_chooser_button, $hidden_input_fields, $submit_script) = &add_file_chooser_button( &text("add_", $text{"_hostsdir"}), "new_" . $internalfield . "_dir", 1, $formid );
    $g .= &ui_links_row(\@list_link_buttons);
    $g .= $hidden_input_fields;
    $g .= $file_chooser_button;
    $g.= &ui_columns_start( [ 
        # "line", 
        # $text{""}, 
        "",
        $text{"enabled"}, 
        $text{"directory"}, 
        # "full" 
    ], 100, undef, undef, &ui_columns_header( [ &show_title_with_help($internalfield, $configfield) ], [ 'class="table-title" colspan=3' ] ), 1 );

    foreach my $dir ( @{$dnsmconfig{$configfield}} ) {
        local @cols;
        push ( @cols, &ui_checkbox("enabled", "1", "", $dir->{"used"}?1:0, undef, 1) );
        push ( @cols, $dir->{"val"} );
        $g .= &ui_clickable_checked_columns_row( \@cols, undef, "sel", $count );
        $count++;
    }
    $g .= &ui_columns_end();
    $g .= &ui_links_row(\@list_link_buttons);
    $g .= $hidden_input_fields;
    $g .= $file_chooser_button;
    $g .= "<p>" . $text{"with_selected"} . "</p>";
    $g .= &ui_submit($text{"enable_sel"}, "enable_sel_$internalfield");
    $g .= &ui_submit($text{"disable_sel"}, "disable_sel_$internalfield");
    $g .= &ui_submit($text{"delete_sel"}, "delete_sel_$internalfield");
    $g .= $submit_script;
    $g .= &ui_form_end( );
    print $g;
}

sub show_resolv_file {
    my $internalfield = "resolv_file";
    my $configfield = &internal_to_config($internalfield);
    my $count=0;
    my $formid = $internalfield . "_form";
    my $g = &ui_form_start( $apply_cgi, "post", undef, "id='$formid'" );
    my @list_link_buttons = &list_links( "sel", 3 );
    my ($file_chooser_button, $hidden_input_fields, $submit_script) = &add_file_chooser_button( &text("add_", $text{"_resolvfile"}), "new_" . $internalfield . "_file", 0, $formid );
    $g .= &ui_links_row(\@list_link_buttons);
    # $g .= $file_chooser_button;
    $g .= $hidden_input_fields;
    $g .= $file_chooser_button;
    $g.= &ui_columns_start( [ 
        # "line", 
        # $text{""}, 
        "",
        $text{"enabled"}, 
        $text{"filename"}, 
        # "full" 
    ], 100, undef, undef, &ui_columns_header( [ &show_title_with_help($internalfield, $configfield) ], [ 'class="table-title" colspan=3' ] ), 1 );

    foreach my $rfile ( @{$dnsmconfig{$configfield}} ) {
        local @cols;
        push ( @cols, &ui_checkbox("enabled", "1", "", $rfile->{"used"}?1:0, undef, 1) );
        push ( @cols, $rfile->{"val"} );
        $g .= &ui_clickable_checked_columns_row( \@cols, undef, "sel", $count );
        $count++;
    }
    $g .= &ui_columns_end();
    $g .= &ui_links_row(\@list_link_buttons);
    $g .= $hidden_input_fields;
    $g .= $file_chooser_button;
    $g .= "<p>" . $text{"with_selected"} . "</p>";
    $g .= &ui_submit($text{"enable_sel"}, "enable_sel_$internalfield");
    $g .= &ui_submit($text{"disable_sel"}, "disable_sel_$internalfield");
    $g .= &ui_submit($text{"delete_sel"}, "delete_sel_$internalfield");
    $g .= $submit_script;
    $g .= &ui_form_end( );
    print $g;
}

@tabs = (   [ 'basic', $text{'index_basic'} ],
            [ 'addn_hosts', $text{"p_desc_addn_hosts"} ],
            [ 'hostsdir', $text{"p_desc_hostsdir"} ],
            [ 'resolv_file', $text{"p_desc_resolv_file"} ] );
my $mode = $in{mode} || "basic";
print ui_tabs_start(\@tabs, 'mode', $mode);

print ui_tabs_start_tab('mode', 'basic');
my @page_fields = ();
foreach my $configfield ( @confdns ) {
    next if ( %dnsmconfigvals{"$configfield"}->{"page"} ne "1" );
    push( @page_fields, $configfield );
}
&show_basic_fields( \%dnsmconfig, "dns_basic", \@page_fields, "dns_basic_apply.cgi", $text{"index_dns_settings_basic"} );
print ui_tabs_end_tab('mode', 'basic');

print ui_tabs_start_tab('mode', 'addn_hosts');
&show_addn_hosts();
print ui_tabs_end_tab('mode', 'addn_hosts');

print ui_tabs_start_tab('mode', 'hostsdir');
&show_hostsdir();
print ui_tabs_end_tab('mode', 'hostsdir');

print ui_tabs_start_tab('mode', 'resolv_file');
&show_resolv_file();
print ui_tabs_end_tab('mode', 'resolv_file');

print ui_tabs_end();

print &add_js();

ui_print_footer("index.cgi?mode=dns", $text{"index_dns_settings"});

### END of dns_basic.cgi ###.
