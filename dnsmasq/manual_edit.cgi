#!/usr/bin/perl
#
#    DNSMasq Webmin Module - manual_edit.cgi; Manually edit config files
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

&ReadParse();

# $access{'types'} eq '*' && $access{'virts'} eq '*' ||
# 	&error($text{'manual_ecannot'});
# &ui_print_header(undef, $text{'index_dns_manual_edit'}, "");

# check for errors in read config
my $error_message = "<div>";
my $line = defined($in{"line"}) ? $in{"line"} : -1;
my $file = $in{"file"};
@files = @{ $dnsmconfig{"configfiles"} };
$file = $files[0] if ($file eq "");
if( $dnsmconfig{"error"}) {
    $error_message .= "<h2>" . @{$dnsmconfig{"error"}} . " errors found in configuration</h2><br/><br/>";
    foreach my $e ( @{$dnsmconfig{"error"}} ) {
        # $error_message .= "File: " . $e->{"file"} . " line: " . $e->{"line"} . "<br/>";
        if ($line == -1) {
            $line = $e->{"line"};
            $file = $e->{"file"};
        }
    }
}
elsif ( $dnsmconfig{"errors"} > 0) {
    $error_message .= "<h2>" . $dnsmconfig->{"errors"} . " errors found in configuration</h2><br/><br/>";
}
$error_message .= "</div>";

&ui_print_header($text{"index_dns_manual_edit"}, $text{"index_title"}, "", "intro", 1, 0, 0, &restart_button());
print &header_style();

print $error_message;
if ($line != -1) {
    print "<script type='text/javascript'>\n"
        . "\$(document).ready(function() {\n"
        . "  setTimeout(function() {\n"
        . "    for (var i in window) {\n"
        . "      if (i.startsWith(\"__cm_editor_\") && typeof window[i] == \"object\") {\n"
        . "        window[i].doc.setSelection({line: " . ($line - 1) . ", ch:0},{line: " . $line . ", ch:0});\n"
        . "      }\n"
        . "    }\n"
        . "  }, 5);\n"
        . "});\n"
        . "</script>\n";
}

my $returnto = $in{"returnto"} || "manual_edit.cgi";
my $returnlabel = $in{"returnlabel"} || $text{"index_dns_manual_edit"};

print "<form action=manual_edit.cgi>\n";
print "<input type=submit value='$text{'manual_file'}'>\n";
print "<select name=file>\n";
foreach $f (@files) {
    printf "<option %s>%s</option>\n",
        $f eq $file ? 'selected' : '', $f;
    $found++ if ($f eq $file);
}
print "</select></form>\n";
$found || &error($text{'manual_efile'});

print &ui_form_start("manual_edit_save.cgi", "form-data");
print &ui_hidden("file", $file),"\n";

$data = &read_file_lines($file, 1);
$data = join("\n", @{$data});

print &ui_textarea("data", $data, 20, 80, undef, undef, "style='width:100%'"),"<br>\n";
print &ui_form_end([ [ "save", $text{'save_button'} ] ]);

&ui_print_footer("index.cgi?tab=dns", $text{"index_dns_settings"});

### END of manual_edit.cgi ###.
