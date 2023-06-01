#!/usr/bin/perl
#
#    DNSMasq Webmin Module - dns_move.cgi; move server     
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

do '../web-lib.pl';
do '../ui-lib.pl';
do 'dnsmasq-lib.pl';

$|=1;
&init_config("DNSMasq");

%access=&get_module_acl;

## put in ACL checks here if needed


## sanity checks


## Insert Output code here
# read config file
$config_filename = $config{config_file};
$config_file = &read_file_lines( $config_filename );
# pass into data structure
&parse_config_file( \%dnsmconfig, \$config_file, $config_filename );
# read posted data
&ReadParse();
# check for errors in read config
if( $dnsmconfig{"errors"} > 0 ) {
	&header( "DNSMasq settings", "" );
	print "<hr><h2>";
	print $text{"warn_errors"};
	print $dnsmconfig{"errors"};
	print $text{"didnt_apply"};
	print "</h3><hr>\n";
	&footer( "/", $text{"index"});
	exit;
}
# adjust everything to what we got
#
my $selected=$dnsmconfig{"servers"}[$in{idx}]{"line"};
if( $in{dir} eq "up" ) {
	$dnsmconfig{"servers"}[$in{idx}]{"line"}=$dnsmconfig{"servers"}[$in{idx}-1]{"line"};
	$dnsmconfig{"servers"}[$in{idx}-1]{"line"}=$selected;
}
else
{
	$dnsmconfig{"servers"}[$in{idx}]{"line"}=$dnsmconfig{"servers"}[$in{idx}+1]{"line"};
	$dnsmconfig{"servers"}[$in{idx}+1]{"line"}=$selected;
}
foreach my $server (@{$dnsmconfig{"servers"}}) {
	$line= ($$server{domain_used}) ?
		"server=/".$$server{domain}."/".$$server{address} :
		"server=".$$server{address};
	&update( $$server{"line"}, $line, 
		$config_file, ($$server{"used"}) );
}
#
# write file!!
&flush_file_lines();
#
# re-load basic page
&redirect( "dns_servers.cgi" );

# 
# sub-routines
#
### END of dns_move.cgi ###.
