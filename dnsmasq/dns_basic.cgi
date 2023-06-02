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
my %dnsmconfig = ();

&parse_config_file( \%dnsmconfig, \$config_file, $config_filename );

&header($text{"index_title"}, "", "intro", 1, 0, 0, &restart_button());

my @basic_fields = ();
foreach my $configfield ( @confdns ) {
    next if ( grep { /^$configfield$/ } ( @confarrs ) );
    next if ( %dnsmconfigvals{"$configfield"}->{"mult"} ne "" );
    next if ( ( ! grep { /^$configfield$/ } ( @confbools ) ) && ( ! grep { /^$configfield$/ } ( @confsingles ) ) );
    push @basic_fields, $configfield;
}
my $l = int(@basic_fields / 2);

print &ui_form_start( 'dns_basic_apply.cgi', "post" );
# print "<h2>$text{"index_dns_settings_basic"}</h2>";
# print &ui_table_start( $text{"index_dns_settings_basic"}, "", 4 );
my $cbtd = 'style="width: 15px; height: 31px;"';
my $customcbtd = 'class="ui_checked_checkbox flexed" style="width: 15px; height: 31px;"';
my $td = 'style="height: 31px; white-space: normal !important; word-break: normal;"';
my $bigtd = 'style="height: 31px; white-space: normal !important; word-break: normal;" colspan=2';
my @grid = ();
my @booltds = ( $cbtd, $bigtd );
my @tds = ( $cbtd, $td, $td );
my @cbtds = ( $customcbtd, $td, $td );
foreach my $column_array ([ @basic_fields[0..$l-1] ], [ @basic_fields[$l..$#basic_fields] ]) {
	my $g = &ui_columns_start( [
            "",
            $text{'column_option'},
            $text{'column_value'}
        ], undef, 0, \@tds);

    foreach my $configfield ( @$column_array ) {
        my $inputfield = &config_to_input("$configfield");
        my $help = &ui_help($configfield . ": " . $text{"p_man_desc_$inputfield"});
        if ( grep { /^$configfield$/ } ( @confbools ) ) {
            $g .= &ui_checked_columns_row( [
                    $text{"p_label_$inputfield"} . $help,
                ], \@booltds, "sel", $configfield, ($dnsmconfig{"$configfield"}->{"used"})?1:0
            );
        }
        elsif ( grep { /^$configfield$/ } ( @confsingles ) ) {
            if ( $configfield eq "user" ) {
                $g .= &ui_columns_row( [
                        '<div class="wh-100p flex-wrapper flex-centered flex-start">' . &ui_checkbox("sel", $configfield, undef, ($dnsmconfig{"$configfield"}->{"used"})?1:0, ) . '</div>',
                        $text{"p_label_$inputfield"} . $help,
                        &ui_user_textbox( $inputfield . "val", $dnsmconfig{"$configfield"}->{"val"} )
                    ], \@cbtds
                );
            }
            elsif ( $configfield eq "group" ) {
                $g .= &ui_columns_row( [
                        '<div class="wh-100p flex-wrapper flex-centered flex-start">' . &ui_checkbox("sel", $configfield, undef, ($dnsmconfig{"$configfield"}->{"used"})?1:0, ) . '</div>',
                        $text{"p_label_$inputfield"} . $help,
                        &ui_group_textbox( $inputfield . "val", $dnsmconfig{"$configfield"}->{"val"} )
                    ], \@cbtds
                );
            }
            else {
                $g .= &ui_checked_columns_row( [
                        $text{"p_label_$inputfield"} . $help,
                        &ui_textbox( $inputfield . "val", $dnsmconfig{"$configfield"}->{"val"}, 25 )
                    ], \@tds, "sel", $configfield, ($dnsmconfig{"$configfield"}->{"used"})?1:0
                );
            }
        }
    }
	$g .= &ui_columns_end();
	push(@grid, $g);
}
print &ui_grid_table(\@grid, 2, 100, undef, undef, $text{"index_dns_settings_basic"});

print &ui_submit( $text{"save_button"}, "submit" );
print &ui_form_end( );
print &ui_hr();

my $formid = "addn_hosts_form";
$count=0;
@grid = ();
my $g = &ui_form_start( 'dns_basic_apply.cgi', "post", undef, "id='$formid'" );
my @list_link_buttons = &list_links( "sel", 2);
my ($file_chooser_button, $hidden_input_fields, $submit_script) = &add_file_chooser_button( &text("add_", $text{"_hostsfile"}), "new_addn_hosts_file", 0, $formid );
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
], 100, undef, undef, &ui_columns_header( [ $text{"p_desc_addn_hosts"} . &ui_help($text{"p_man_desc_addn_hosts"}) ], [ 'class="table-title" colspan=3' ] ), 1 );

foreach my $hosts ( @{$dnsmconfig{"addn-hosts"}} ) {
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
$g .= &ui_submit($text{"enable_sel"}, "enable_sel_addn_hosts");
$g .= &ui_submit($text{"disable_sel"}, "disable_sel_addn_hosts");
$g .= &ui_submit($text{"delete_sel"}, "delete_sel_addn_hosts");
$g .= $submit_script;
$g .= &ui_form_end( );
push(@grid, $g);

$formid = "add_resolv_file_form";
$count=0;
$g = &ui_form_start( 'dns_basic_apply.cgi', "post", undef, "id='$formid'" );
@list_link_buttons = &list_links( "sel", 3 );
my ($file_chooser_button, $hidden_input_fields, $submit_script) = &add_file_chooser_button( &text("add_", $text{"_resolvfile"}), "new_resolv_file", 0, $formid );
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
], 100, undef, undef, &ui_columns_header( [ $text{"p_desc_resolv_file"} . &ui_help($text{"p_man_desc_resolv_file"}) ], [ 'class="table-title" colspan=3' ] ), 1 );

foreach my $rfile ( @{$dnsmconfig{"resolv-file"}} ) {
    local @cols;
    push ( @cols, &ui_checkbox("enabled", "1", "", $rfile->{"used"}?1:0, undef, 1) );
    push ( @cols, $rfile->{"val"} );
    $g .= &ui_checked_columns_row( \@cols, undef, "sel", $count );
    $count++;
}
$g .= &ui_columns_end();
$g .= &ui_links_row(\@list_link_buttons);
$g .= $hidden_input_fields;
$g .= $file_chooser_button;
$g .= "<p>" . $text{"with_selected"} . "</p>";
$g .= &ui_submit($text{"enable_sel"}, "enable_sel_resolv_file");
$g .= &ui_submit($text{"disable_sel"}, "disable_sel_resolv_file");
$g .= &ui_submit($text{"delete_sel"}, "delete_sel_resolv_file");
$g .= $submit_script;
$g .= &ui_form_end( );
push(@grid, $g);
print &ui_grid_table(\@grid, 2, 100);

print &ui_hr();

print &add_js(1, 0, 1);

ui_print_footer("index.cgi?mode=dns", $text{"index_dns_settings"});

### END of dns_basic.cgi ###.
