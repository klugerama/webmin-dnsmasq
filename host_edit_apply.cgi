#!/usr/bin/perl
#
#    DNSMasq Webmin Module - host_edit_apply.cgi; do the update      
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
#    This module inherited from the DNSMasq Webmin module by Neil Fisher

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
$config_file = &read_file_lines( $config{config_file} );
# pass into data structure
&parse_config_file( \%config, \$config_file );
# read posted data
&ReadParse();
# check for errors in read config
if( $config{errors} > 0 ) {
	my $line="error.cgi?line=xx&type=".$text{err_configbad};
	&redirect( $line );
	exit;
}
# adjust everything to what we got
#
my $line="dhcp-host=".$in{host};
&update( $config{dhcp_host}[$in{idx}]{line}, $line,
	$config_file, ( $in{used} == 1 ) );
#
# write file!!
&flush_file_lines();
#
# re-load basic page
&redirect( "dhcp.cgi" );

# 
# sub-routines
#
### END of host_edit_apply.cgi ###.
