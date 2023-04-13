#!/usr/bin/perl
#
#    DNSMasq Webmin Module - dns_apply.cgi; update basic DNS info     
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
	my $line = "error.cgi?line=xx&type=".$text{err_configbad};
	&redirect( $line );
	exit;
}
# check user input for obvious errors
if( $in{local_domain} !~ /^$FILE$/ ) {
	my $line = "error.cgi?line=".$text{local_domain};
	$line .= "&type=".$text{err_domainbad};
	&redirect( $line );
	exit;
}
if( ($in{xhosts}) && ($in{addn_hosts} !~ /^$FILE$/) ) {
	my $line = "error.cgi?line=".$text{xhostsfile};
	$line .= "&type=".$text{err_filebad};
	&redirect( $line );
	exit;
}
if( ($in{cache_size}) && ($in{cust_cache_size} !~ /^$NUMBER/) ) {
	my $line = "error.cgi?line=".$text{cust_cache_size};
	$line .= "&type=".$text{err_numbbad};
	&redirect( $line );
	exit;
}
if( ($in{local_ttl}) && ($in{ttl} !~ /^$NUMBER/) ) {
	my $line = "error.cgi?line=".$text{ttl};
	$line .= "&type=".$text{err_numbbad};
	&redirect( $line );
	exit;
}
# adjust everything to what we got

#
#our local domain
#
&update( $config{domain}{line}, "local=".$in{local_domain}, 
	$config_file, 1 );
#
# need domains for forwarded lookups?
# 
&update( $config{domain_needed}{line}, "domain-needed", 
	$config_file, ( $in{domain_needed} == 1 ) );

#
# add local domain to local hosts?
# 
&update( $config{expand_hosts}{line}, "expand-hosts", 
	$config_file, ( $in{expand_hosts} == 1 ) );
#
# reverse lookups of local subnets propogating?
# 
# NOTE: reversed logic in question!
&update( $config{bogus_priv}{line}, "bogus-priv", 
	$config_file, ( $in{bogus_priv} == 0 ) );
#
# reverse lookups of local subnets propogating?
# 
&update( $config{filterwin2k}{line}, "filterwin2k", 
	$config_file, ( $in{filterwin2k} == 1 ) );
#
# read /etc/hosts?
# 
#  NOTE: reverse logic in config file
&update( $config{no_hosts}{line}, "no-hosts", 
	$config_file, ( $in{hosts} == 0 ) );
#
# read extra hosts file?
# 
&update( $config{addn_hosts}{line}, "addn-hosts=".$in{addn_hosts}, 
	$config_file, ( $in{xhosts} == 1 ) );
#
# negative caching?
# 
# NOTE: reverse logic in config file
&update( $config{neg_cache}{line}, "no-negcache", 
	$config_file, ( $in{neg_cache} == 0 ) );
#
# custom cache size?
# 
&update( $config{cache_size}{line}, "cache-size=".$in{cust_cache_size}, 
	$config_file, ( $in{cache_size} == 1 ) );
#
# log all lookups?
# 
&update( $config{log_queries}{line}, "log-queries", 
	$config_file, ( $in{log_queries} == 1 ) );
#
# cache size?
# 
&update( $config{local_ttl}{line}, "local-ttl=".$in{ttl}, 
	$config_file, ( $in{local_ttl} == 1) );
#
#
#
# write file!!
&flush_file_lines();
#
# re-load basic page
&redirect( "index.cgi" );

# 
# sub-routines
#
### END of dns_apply.cgi ###.
