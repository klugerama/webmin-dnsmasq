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

## put in ACL checks here if needed

my $config_filename = $config{config_file};
my $config_file = &read_file_lines( $config_filename );

&parse_config_file( \%dnsmconfig, \$config_file, $config_filename );

&ReadParseMime();

my $type = $in{"type"} || "config";
my $returnto = $in{"returnto"} || "manual_edit.cgi?type=" . $type . "&file=" . $in{'file'} . "&line=" . $in{'line'} . "&ch=" . $in{'ch'};
my $returnlabel = $in{"returnlabel"} || $dnsmasq::text{"index_dns_config_edit"};

my @files = ();
if ($type eq "config") {
    push( @files, @{ $dnsmconfig{"configfiles"} } );
    &indexof($in{'file'}, @files) >= 0 || &error($dnsmasq::text{'manual_econffile'});
}
else {
    push( @files, @{ $dnsmconfig{"scripts"} });
    &indexof($in{'file'}, @files) >= 0 || &error($dnsmasq::text{'manual_escriptfile'});
}

$temp = &transname();
&execute_command("cp ".quotemeta($in{'file'})." $temp");
$in{'data'} =~ s/\r//g;
&lock_file($in{'file'});
&open_tempfile(FILE, ">$in{'file'}");
&print_tempfile(FILE, $in{'data'});
&close_tempfile(FILE);
&unlock_file($in{'file'});
if ($config{'test_config'}) {
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
