#!/usr/bin/perl
#
#    DNSMasq Webmin Module - index.cgi; basic DNS config     
#    Copyright (C) 2006 by Neil Fisher
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
#    This module inherited from the Webmin Module Template 0.79.1 by tn

do '../web-lib.pl';
do '../ui-lib.pl';
do 'dnsmasq-lib.pl';

$|=1;
&init_config("DNSMasq");

%access=&get_module_acl;

## put in ACL checks here if needed


## sanity checks

&header($text{'index_title'}, "", "intro", 1, 1, undef,
        "Written by Neil Fisher<BR><A HREF=mailto:neil\@magnecor.com.au>Author</A><BR><A HREF=http://www.authorpage.invalid>Home://page</A>");
# uses the index_title entry from ./lang/en or appropriate

## Insert Output code here
# read config file
$config_file = &read_file_lines( $config{config_file} );
# pass into data structure


# output as web page


&header( "DNSMasq settings", "" );
&parse_config_file( \%config, \$config_file );
print "<hr>\n";
if( $config{errors} > 0 )
{
	print "<h3>WARNING: found ";
	print $config{errors};
	print "errors in config file!</h3><br>\n";
}
print &ui_form_start( 'basic_apply.cgi', "post" );
print "<br>\n";
print "<h2>$text{'DNS_settings'}</h2>";
print "<br><br>\n";
print $text{'local_domain'};
print &ui_textbox( "local_domain", $config{domain}{domain}, 32 );
print "<br><br>\n";
print $text{'domain_needed'};
print &ui_yesno_radio( "domain_needed", ($config{domain_needed}{used})?1:0 );
print "<br><br>\n";
print $text{'expand_hosts'};
print &ui_yesno_radio( "expand_hosts", ($config{expand_hosts}{used})?1:0 );
print "<br><br>\n";
print $text{'bogus_priv'};
print &ui_yesno_radio( "bogus_priv", ($config{bogus_priv}{used})?0:1 );
print "<br><br>\n";
print $text{'filterwin2k'};
print &ui_yesno_radio( "filterwin2k", ($config{filterwin2k}{used})?1:0 );
print "<br><br>\n";
print $text{'hosts'};
print &ui_yesno_radio( "hosts", ($config{no_hosts}{used}?0:1) );
print "<br>\n";
print $text{'xhosts'};
print &ui_yesno_radio( "xhosts", ($config{addn_hosts}{used}?1:0) );
print "<br>\n";
print $text{'xhostsfile'};
print &ui_textbox( "addn_hosts", $config{addn_hosts}{file}, 40 );
print "<br><br>\n";
print $text{'neg_cache'};
print &ui_yesno_radio( "neg_cache", ($config{neg_cache}{used}?0:1) );
print "<br><br>\n";
print $text{'cache_size'};
print &ui_yesno_radio( "cache_size", ($config{cache_size}{used}?1:0) );
print "<br>\n";
print $text{'cust_cache_size'};
print &ui_textbox( "cust_cache_size", $config{cache_size}{size}, 40 );
print "<br><br>\n";
print $text{'log_queries'};
print &ui_yesno_radio( "log_queries", ($config{log_queries}{used}?1:0) );
print "<br><br>\n";
print $text{'local_ttl'};
print &ui_yesno_radio( "local_ttl", ($config{local_ttl}{used}?1:0) );
print "<br>\n";
print $text{'ttl'};
print &ui_textbox( "ttl", $config{local_ttl}{ttl}, 40 );
print "<br><br>\n";
print &ui_submit( $text{'save_button'} );
print &ui_form_end( );
print "<hr>";
print "<a href=\"servers.cgi\">";
print $text{'servers_config'};
print "</a><br>";
print "<a href=\"iface.cgi\">";
print $text{'iface_config'};
print "</a><br>";
print "<a href=\"alias.cgi\">";
print $text{'alias_config'};
print "</a><br>";
print "<hr>";
print "<a href=\"dhcp.cgi\">";
print $text{'DHCP_config'};
print "</a><br>";
print "<hr>";
print "<a href=\"restart.cgi\">";
print $text{'restart'};
print "</a><br>";
&footer("/", $text{'index'});
# uses the index entry in /lang/en



## if subroutines are not in an extra file put them here


### END of index.cgi ###.
