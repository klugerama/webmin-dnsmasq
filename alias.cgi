#!/usr/bin/perl
#
#    DNSMasq Webmin Module - alias.cgi; aliasing and redirection
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


## Insert Output code here
# read config file
$config_file = &read_file_lines( $config{config_file} );
# pass into data structure


# output as web page


&parse_config_file( \%config, \$config_file );
if( $config{errors} > 0 )
{
	my $line="error.cgi?line=xx&type=".$text{err_configbad};
	&redirect( $line );
	exit;
}
&header($text{'index_title'}, "", "intro", 1, 1, undef,
        "Written by Neil Fisher<BR><A HREF=mailto:neil\@magnecor.com.au>Author</A><BR><A HREF=http://www.authorpage.invalid>Home://page</A>");
print "<hr>\n";
# uses the index_title entry from ./lang/en or appropriate
print "<br>\n";
print "<h2>".$text{forced}."</h2>";
print "<br><br>\n";
my $count=0;
print &ui_columns_start( [ $text{forced_domain}, $text{forced_ip},
			$text{in_use} ], 100 );
foreach my $frcd ( @{$config{forced}} )
{
	my $edit = "<a href=forced_edit.cgi?idx=$count>".$$frcd{domain}."</a>";
	print &ui_columns_row( [ $edit, $$frcd{addr}, ($$frcd{used}) ?
			$text{used} : $text{not_used} ],
			[ "width=30%", "width=30%", "width=30%" ] );
	$count++;
}
print &ui_columns_end();
print "<br>\n";
print "<a href=add.cgi?what=address=/new/0.0.0.0&where=alias.cgi>".
	$text{forced_add}."</a>";
print "<br>\n";
print "<br><br>\n";
print "<hr>";
print "<br>\n";
print "<h2>".$text{alias}."</h2>";
print "<br><br>\n";
$count=0;
print &ui_columns_start( [ $text{forced_from}, $text{forced_ip},
			$text{forced_mask}, $text{in_use} ], 100 );
foreach my $frcd ( @{$config{alias}} )
{
	my $edit = "<a href=alias_edit.cgi?idx=$count>".$$frcd{from}."</a>";
	print &ui_columns_row( [ 
			$edit, $$frcd{to}, 
			($$frcd{netmask_used}) ?  
				$$frcd{netmask} : "255.255.255.255",
			($$frcd{used}) ?
				$text{used} : $text{not_used} ],
			[ "width=25%", "width=25%", "width=25%", "width=25%" ] );
	$count++;
}
print &ui_columns_end();
print "<br>\n";
print "<a href=add.cgi?what=alias=0.0.0.0,0.0.0.0&where=alias.cgi>".
	$text{alias_add}."</a>";
print "<br>\n";
print "<hr>";
print "<br>\n";
print "<h2>".$text{nx}."</h2>";
print "<br><br>\n";
$count=0;
print &ui_columns_start( [ $text{forced_from}, $text{in_use} ], 100 );
foreach my $frcd ( @{$config{bogus}} )
{
	my $edit = "<a href=nx_edit.cgi?idx=$count>".$$frcd{addr}."</a>";
	print &ui_columns_row( [ 
			$edit, 
			($$frcd{used}) ?
				$text{used} : $text{not_used} ],
			[ "width=50%", "width=50%" ] );
	$count++;
}
print &ui_columns_end();
print "<br>\n";
print "<a href=add.cgi?what=bogus-nxdomain=0.0.0.0&where=alias.cgi>".
	$text{nx_add}."</a>";
print "<br>\n";
print "<hr>";
print "<br><br>\n";
print "<br><br>\n";
print "<a href=\"index.cgi\">";
print $text{'DNS_settings'};
print "</a><br>";
print "<a href=\"servers.cgi\">";
print $text{'DNS_servers'};
print "</a><br>";
print "<a href=\"iface.cgi\">";
print $text{'iface_config'};
print "</a><br>";
print "<hr>";
print "<a href=\"dhcp.cgi\">";
print $text{'DHCP_config'};
print "</a><br>";
&footer("/", $text{'index'});
# uses the index entry in /lang/en



## if subroutines are not in an extra file put them here


### END of alias.cgi ###.
