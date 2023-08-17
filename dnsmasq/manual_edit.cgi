#!/usr/bin/perl
#
#    DNSMasq Webmin Module - # TODO manual_edit.cgi; Manually edit config files
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

&ReadParse();

# $access{'types'} eq '*' && $access{'virts'} eq '*' ||
# 	&error($text{'manual_ecannot'});
# &ui_print_header(undef, $text{'index_dns_manual_edit'}, "");
&header($text{"index_title"}, "", "intro", 1, 0, 0, &restart_button(), undef, undef, $text{"index_dns_manual_edit"});
print &header_style();

my $returnto = $in{"returnto"} || "manual_edit.cgi";
my $returnlabel = $in{"returnlabel"} || $text{"index_dns_manual_edit"};

@files = @{ $dnsmconfig{"configfiles"} };
$in{'file'} = $files[0] if ($in{'file'} eq '');
print "<form action=manual_edit.cgi>\n";
print "<input type=submit value='$text{'manual_file'}'>\n";
print "<select name=file>\n";
foreach $f (@files) {
    printf "<option %s>%s</option>\n",
        $f eq $in{'file'} ? 'selected' : '', $f;
    $found++ if ($f eq $in{'file'});
}
print "</select></form>\n";
$found || &error($text{'manual_efile'});

print &ui_form_start("manual_edit_save.cgi", "form-data");
print &ui_hidden("file", $in{'file'}),"\n";

$data = &read_file_lines($in{'file'}, 1);
$data = join("\n", @{$data});

print &ui_textarea("data", $data, 20, 80, undef, undef, "style='width:100%'"),"<br>\n";
print &ui_form_end([ [ "save", $text{'save'} ] ]);

&ui_print_footer("index.cgi?mode=dns", $text{"index_dns_settings"});

### END of manual_edit.cgi ###.
