#!/usr/bin/perl
#
#    DNSMasq Webmin Module - # TODO error.cgi; report errors
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
# read posted data
&ReadParse();

&ui_print_header($dnsmasq::text{"configuration_errors_heading"}, $dnsmasq::text{"index_title"}, "", "intro", 1, 0, 0, &restart_button());
print &header_js(\%dnsmconfig);

# output as web page
&ReadParse();

my $returnto = $in{"returnto"} || "index.cgi?tab=dns";
my $returnlabel = $in{"returnlabel"} || $dnsmasq::text{"index_dns_settings"};

## Insert Output code here

print &ui_form_start($returnto, "post");
print &ui_hidden("returnto", $returnto);
print &ui_hidden("forced_edit", 1);
my $count = 0;
foreach my $error ( @{$dnsmconfig{"error"}} ) {
    print &ui_hidden( "file_" . $count, $error->{"file"} );
    print &ui_hidden( "line_" . $count, $error->{"line"} );
    print &ui_hidden( "configfield_" . $count, $error->{"configfield"} );
    $count++;
}
my @list_link_buttons = &list_links( "sel", 1 );
print &ui_links_row(\@list_link_buttons);
my @error_fields = ( "configfield", "param", "file", "line", "desc" );
my @column_headers = ( "" );
foreach my $key ( @error_fields ) {
    push ( @column_headers, $dnsmasq::text{"err_" . $key} );
}
push ( @column_headers, "" ); # for the manual edit button
print &ui_columns_start( \@column_headers, );
$count = 0;
my @fs = ( "file", "path", "dir" );
foreach my $error ( @{$dnsmconfig{"error"}} ) {
    my @cols;
    my $link_target = "";
    my $configfield = $error->{"configfield"};
    my $internalfield = &config_to_internal($configfield);
    my $is_ignored = grep { $error->{"full"} } ( @{$config{"ignored"}} );
    my $param = $error->{"param"};
    webmin_debug_log("--------ERROR", "configfield: $configfield type: $type param: $param error_type: ". $error->{"error_type"} . " ERR_FILE_PERMS: " . ERR_FILE_PERMS());
    my $type = "";
    if ( grep { /^$configfield$/ } ( keys %dnsmconfigvals ) ) {
        my $fd = $dnsmconfigvals{"$configfield"};
        my $fdef = $configfield_fields{$internalfield};
        my $pdef = \%{ $fdef->{"$param"} };
        $type = $pdef->{"valtype"};
        my $nav = %{%dnsmnav{$fd->{"section"}}}{$fd->{"page"}};
        $link_target = $nav->{"cgi_name"} . "?" . ($nav->{"cgi_params"} ? $nav->{"cgi_params"} . "&" : "") . "forced_edit=1&bad_ifield=$internalfield&line=" . $error->{"line"} . "&show_validation=" . $internalfield . "_" . $error->{"param"} . "&custom_error=" . $error->{"custom_error"};
        if ($nav->{"tab"}) {
            $link_target .= "&tab=" . $nav->{"tab"}->{$fd->{"tab"}};
        }
        if ($error->{"cfg_idx"} ne "-1") {
            $link_target .= "&cfg_idx=" . $error->{"cfg_idx"};
        }
    }
    foreach my $key ( @error_fields ) {
        my $link = "<a href=\"" . $link_target . "\">" . $error->{$key} . "</a>";
        push ( @cols, $link );
    }
    my $buttons = "<a href=\"manual_edit.cgi?file=" . $error->{"file"} . "&line=" . $error->{"line"} . "\" class=\"btn btn-tiny\"><i class='fa fa-fw fa-files-o -cs' style='margin-right:5px;'></i>" . $dnsmasq::text{"button_manual_edit"} . "</a>";
    if ((grep { /^$type$/ } ( @fs )) && $error->{"error_type"} == ERR_FILE_PERMS() && $dnsmasq::access{"change_perms"}) {
        $buttons .= "<a href=\"$returnto" . ($returnto =~ /\?/ ? "&" : "?") . "forced_edit=1&fix_perms=1&ifield=" . $internalfield . "&cfg_idx=" . $error->{"cfg_idx"} . "&param=" . $param . "&foruser=" . $error->{"foruser"} . "&forgroup=" . $error->{"forgroup"} . "&perms_failed=" . $error->{"perms_failed"} . "\" class=\"btn btn-tiny\"><i class='fa fa-fw fa-files-o -cs' style='margin-right:5px;'></i>" . $dnsmasq::text{"button_fix_permissions"} . "</a>";
    }
    if (!$is_ignored) {
        $buttons .= "<a href=\"" . basename($0) . "?forced_edit=1&ignore=1&ifield=" . $internalfield . "&cfg_idx=" . $error->{"cfg_idx"} . "&param=" . $param . "&foruser=" . $error->{"foruser"} . "&forgroup=" . $error->{"forgroup"} . "&perms_failed=" . $error->{"perms_failed"} . "\" class=\"btn btn-tiny\"><i class='fa fa-fw fa-files-o -cs' style='margin-right:5px;'></i>" . $dnsmasq::text{"button_fix_permissions"} . "</a>";
    }
    push ( @cols, $buttons );
    print &ui_clickable_checked_columns_row( \@cols, undef, "sel", $count, 1 );
    $count++;
}
print &ui_columns_end();
print &ui_links_row(\@list_link_buttons);
print "<p>" . $dnsmasq::text{"with_selected"} . "</p>";
print &ui_submit($dnsmasq::text{"button_disable_sel"}, "button_disable_sel");
print &ui_submit($dnsmasq::text{"button_delete_sel"}, "button_delete_sel");
print &ui_form_end();

print &add_js();

&ui_print_footer($returnto, $returnlabel);

### END of error.cgi ###.
