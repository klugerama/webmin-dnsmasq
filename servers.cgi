#!/usr/bin/perl
#
#    DNSMasq Webmin Module - server.cgi; Upstream Servers config
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

my $count=0;
&header( "DNSMasq settings", "" );
&parse_config_file( \%config, \$config_file );
print "<h2>";
print $text{'DNS_servers'};
print "</h2>";
print &ui_form_start( "srv_apply.cgi", "post" );
print "<h3>".$text{dynamic}."</h3>";
print $text{resolv};
print &ui_yesno_radio( "resolv", ($config{no_resolv}{used}?0:1) );
print "<br>".$text{resolv_file_explicit};
print &ui_yesno_radio( "resolv_std", ($config{resolv_file}{used}?1:0) );
print "<br>".$text{resolv_file};
print &ui_textbox( "resolv_file", $config{resolv_file}{filename}, 50 );
print "<br><br>".$text{poll}."<br>";
print &ui_yesno_radio( "poll", ($config{no_poll}{used}?0:1) );
print "<br><br>".$text{strict_order};
print &ui_yesno_radio( "strict", ($config{strict_order}{used}?1:0) );
print "<br><br><h3>".$text{in_file}."</h3>";
print &ui_columns_start( [ $text{domain}, $text{address}, 
			   $text{in_use}, "" ], 100 );
foreach my $server ( @{$config{servers}} )
{
	local ( $mover, $edit );
	if( $count == @{$config{servers}}-1 )
	{
		$mover="<img src=images/gap.gif>";
	}
	else
	{	
		$mover = "<a href='srv_move.cgi?idx=$count&".
		"dir=down'><img src=".
		"images/down.gif border=0></a>";
	}
        if( $count == 0 )
	{
		$mover.="<img src=images/gap.gif>";
	}
	else
	{
		$mover .= "<a href='srv_move.cgi?idx=$count&".
		"dir=up'><img src=images/up.gif ".
		"border=0></a>";
	}
	$edit = "<a href=srv_edit.cgi?idx=$count>".$$server{address}."</a>";
	print &ui_columns_row( [ $$server{domain}, $edit,
		($$server{used})?$text{used}:$text{not_used}, $mover ],
       		[ "width=30%", "width=30%", "width=30%", "width=10%" ]	);
	$count++;
}
print &ui_columns_end();
print "<br><a href=add.cgi?what=server=0.0.0.0&where=servers.cgi>".
		$text{new_dns_serv}."</a><hr>";
print "<br>" . &ui_submit( $text{'save_button'} );
print &ui_form_end();
print "<hr>";
print "<a href=\"index.cgi\">";
print $text{'DNS_settings'};
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
&footer("/", $text{'index'});
# uses the index entry in /lang/en



## if subroutines are not in an extra file put them here


### END of servers.cgi ###.
