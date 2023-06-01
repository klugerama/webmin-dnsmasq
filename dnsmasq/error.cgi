#!/usr/bin/perl
#
#    DNSMasq Webmin Module - error.cgi; report errors
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

## Insert Output code here

# output as web page
&ReadParse();

print "<h3>".$text{"error_heading"}."</h3>";
print "<br><br>";
print $text{"err_line"} . " " . $in{"line"};
print "<br>\n";
print $text{"err_type"} . " " . $in{"type"};
print "<br><br>\n";
print $text{"err_help"};
# &footer("/", $text{"index"});
my $returnto = $in{"returnto"} || "index.cgi?mode=dns";
my $returnlabel = $in{"returnlabel"} || $text{"index_dns_settings"};
&ui_print_footer($returnto, $returnlabel);

# uses the index entry in /lang/en

## if subroutines are not in an extra file put them here


### END of error.cgi ###.
