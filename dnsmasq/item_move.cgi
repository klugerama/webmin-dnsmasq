#!/usr/bin/perl
#
#    DNSMasq Webmin Module - item_move.cgi; move array items up or down     
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

my %access=&get_module_acl();

## put in ACL checks here if needed


## sanity checks


## Insert Output code here
# read config file
my $config_filename = $config{config_file};
my $config_file = &read_file_lines( $config_filename );
# pass into data structure
&parse_config_file( \%dnsmconfig, \$config_file, $config_filename );
# read posted data
&ReadParse();

my $returnto = $in{"returnto"};
my $returnlabel = $in{"returnlabel"} || $text{"index_dns_settings_basic"};
# check for errors in read config
# if( $dnsmconfig{"errors"} > 0 ) {
# 	&ui_print_header(undef, $text{"index_title"}, "" );
# 	print "<hr><h2>";
# 	print $text{"warn_errors"};
# 	print $dnsmconfig{"errors"};
# 	print $text{"didnt_apply"};
# 	print "</h3><hr>\n";
# 	&footer( "/", $text{"index"});
# 	exit;
# }
# adjust everything to what we got
#
my $internalfield = $in{"internalfield"};
my $selected=$dnsmconfig{$internalfield}[$in{idx}]{"line"};
if( $in{dir} eq "up" ) {
	$dnsmconfig{$internalfield}[$in{idx}]{"line"}=$dnsmconfig{$internalfield}[$in{idx}-1]{"line"};
	$dnsmconfig{$internalfield}[$in{idx}-1]{"line"}=$selected;
}
else {
	$dnsmconfig{$internalfield}[$in{idx}]{"line"}=$dnsmconfig{$internalfield}[$in{idx}+1]{"line"};
	$dnsmconfig{$internalfield}[$in{idx}+1]{"line"}=$selected;
}
foreach my $item (@{$dnsmconfig{$internalfield}}) {
	$line = $item->{"full"};
	&update( $item->{"line"}, $line, 
		$config_file, ($item->{"used"}?0:1) );
}
#
# write file!!
&flush_file_lines();
#
# re-load basic page
&redirect( $returnto );

# 
# sub-routines
#
### END of item_move.cgi ###.
