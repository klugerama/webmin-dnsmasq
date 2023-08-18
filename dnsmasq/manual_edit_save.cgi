#!/usr/bin/perl
#
#    DNSMasq Webmin Module - manual_edit_save.cgi; update config files
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

&ReadParseMime();

my $returnto = $in{"returnto"} || "manual_edit.cgi";
my $returnlabel = $in{"returnlabel"} || $text{"index_dns_manual_edit"};
# $access{'types'} eq '*' && $access{'virts'} eq '*' ||
# 	&error($text{'manual_ecannot'});

@files = @{ $dnsmconfig{"configfiles"} };
&indexof($in{'file'}, @files) >= 0 || &error($text{'manual_efile'});

$temp = &transname();
&execute_command("cp ".quotemeta($in{'file'})." $temp");
$in{'data'} =~ s/\r//g;
&lock_file($in{'file'});
&open_tempfile(FILE, ">$in{'file'}");
&print_tempfile(FILE, $in{'data'});
&close_tempfile(FILE);
&unlock_file($in{'file'});
if ($config{'test_manual'}) {
	$err = &test_config();
	if ($err) {
		&execute_command("mv $temp '$in{'file'}'");
		&error(&text('manual_etest', "<pre>$err</pre>"));
		}
	}
unlink($temp);
&webmin_log("manual", undef, undef, { 'file' => $in{'file'} });
#
# re-load basic page
&redirect( $returnto );

### END of manual_edit_save.cgi ###.
