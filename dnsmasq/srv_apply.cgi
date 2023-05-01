#!/usr/bin/perl
#
#    DNSMasq Webmin Module - srv_apply.cgi; update DNS server info     
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
&parse_config_file( \%dnsmconfig, \$config_file, \$config_filename );
# read posted data
&ReadParse();
# check for errors in read config
if( $dnsmconfig{"errors"} > 0 ) {
	my $line = "error.cgi?line=xx&type=".$text{"err_configbad"};
	&redirect( $line );
	exit;
}
# check for input data errors
if( ($in{resolv_std}) && ($in{resolv_file} !~ /^$FILE$/) ) {
	my $line = "error.cgi?line=".$text{"resolv_file"};
	$line .= "&type=".$text{"err_filebad"};
	&redirect( $line );
	exit;
}
# adjust everything to what we got

#
# use resolv.conf?
#
&update( $dnsmconfig{"no-resolv"}->{line}, "no-resolv", 
	$config_file, ( $in{resolv} == 0 ) );
#
# standard location for resolv.conf?
# 
&update( $dnsmconfig{"resolv-file"}->{line}, "resolv-file=".$in{resolv_file}, 
	$config_file, ( $in{resolv_std} == 1 ) );

#
# servers in order provided?
# 
&update( $dnsmconfig{"strict-order"}->{line}, "strict-order", 
	$config_file, ( $in{strict} == 1 ) );
#
# poll resolv.conf?
# 
&update( $dnsmconfig{"no-poll"}->{line}, "no-poll", 
	$config_file, ( $in{poll} == 0 ) );
#
#
# write file!!
&flush_file_lines();
#
# re-load basic page
&redirect( "dns_servers.cgi" );

# 
# sub-routines
#
### END of srv_apply.cgi ###.
