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

&ui_print_header($text{"errors_heading"}, $text{"index_title"}, "", "intro", 1, 0, 0, &restart_button());
print &header_style();

# output as web page
&ReadParse();

my $returnto = $in{"returnto"} || "index.cgi?tab=dns";
my $returnlabel = $in{"returnlabel"} || $text{"index_dns_settings"};

## Insert Output code here

# print "<h2 style=\"color: red;\">".$text{"error_heading"}."</h2>";
# print "<br><br>";

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
    push ( @column_headers, $text{"err_" . $key} );
}
push ( @column_headers, "" );
print &ui_columns_start( \@column_headers, );
$count = 0;
foreach my $error ( @{$dnsmconfig{"error"}} ) {
    my @cols;
    my $link_target = "";
    my $configfield = $error->{"configfield"};
    my $internalfield = &config_to_internal($configfield);
    my $fd = $dnsmconfigvals{"$configfield"};
    my $nav = %{%dnsmnav{$fd->{"section"}}}{$fd->{"page"}};
    $link_target = $nav->{"cgi_name"} . "?forced_edit=1&bad_ifield=$internalfield&line=" . $error->{"line"} . "&custom_error=" . $error->{"custom_error"};
    if ($nav->{"tab"}) {
        $link_target .= "&tab=" . $nav->{"tab"}->{$fd->{"tab"}};
    }
    if ($error->{"idx"} ne "-1") {
        $link_target .= "&bad_idx=" . $error->{"idx"};
    }
    foreach my $key ( @error_fields ) {
        my $link = "<a href=\"" . $link_target . "\">" . $error->{$key} . "</a>";
        push ( @cols, $link );
    }
    push ( @cols, "<a href=\"manual_edit.cgi?file=" . $error->{"file"} . "&line=" . $error->{"line"} . "\" class=\"btn btn-tiny\"><i class='fa fa-fw fa-files-o -cs' style='margin-right:5px;'></i>Manual Edit</a>" );
    print &ui_clickable_checked_columns_row( \@cols, undef, "sel", $count, 1 );
    $count++;
}
print &ui_columns_end();
print &ui_links_row(\@list_link_buttons);
print "<p>" . $text{"with_selected"} . "</p>";
print &ui_submit($text{"disable_sel"}, "disable_sel");
print &ui_submit($text{"delete_sel"}, "delete_sel");
print &ui_form_end();

print &add_js();

&ui_print_footer($returnto, $returnlabel);

### END of error.cgi ###.
