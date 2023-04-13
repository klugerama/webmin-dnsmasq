#!/usr/bin/perl
#
#    DNSMasq Webmin Module - iface.cgi; network interfaces
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
print $text{'iface_listen'};
print "</h2>";
print &ui_columns_start( [ $text{iface}, $text{in_use} ], 100 );
foreach my $iface ( @{$config{interface}} ) {
	my $edit = "<a href=iface_edit.cgi?idx=$count>".$$iface{iface}."</a>";
	print &ui_columns_row( [ $edit, ($$iface{used})?$text{used}:$text{not_used} ],
       		[ "width=30%", "width=30%", "width=30%" ]	);
	$count++;
}
print &ui_columns_end();
print "<br><a href=add.cgi?what=interface=new&where=iface.cgi>".
		$text{new_iface}."</a><hr>";
print "<h2>";
print $text{'xiface_listen'};
print "</h2>";
$count=0;
print &ui_columns_start( [ $text{xiface}, $text{in_use} ], 100 );
foreach my $iface ( @{$config{ex_interface}} ) {
	my $edit = "<a href=xiface_edit.cgi?idx=$count>".$$iface{iface}."</a>";
	print &ui_columns_row( [ $edit, ($$iface{used})?$text{used}:$text{not_used} ],
       		[ "width=30%", "width=30%", "width=30%" ]	);
	$count++;
}
print &ui_columns_end();
print "<br><a href=add.cgi?what=except-interface=new&where=iface.cgi>".
		$text{new_iface}."</a><hr>";
print "<h2>";
print $text{'listen_addr'};
print "</h2>";
$count=0;
print &ui_columns_start( [ $text{listen_addr}, $text{in_use} ], 100 );
foreach my $iface ( @{$config{listen_on}} ) {
	my $edit = "<a href=listen_edit.cgi?idx=$count>".$$iface{address}."</a>";
	print &ui_columns_row( [ $edit, ($$iface{used})?$text{used}:$text{not_used} ],
       		[ "width=30%", "width=30%", "width=30%" ]	);
	$count++;
}
print &ui_columns_end();
print "<br>";
print "<br><a href=add.cgi?what=listen-address=0.0.0.0&where=iface.cgi>".
		$text{new_addr}."</a><hr><br>";
print &ui_form_start( 'iface_apply.cgi', "post" );
print $text{bind_iface};
print &ui_yesno_radio( "bind_iface", ($config{bind_interfaces}{used})?1:0 );
print "<br>".&ui_submit( $text{save_button} );
print &ui_form_end();
print "<hr><br><a href=\"index.cgi\">".$text{'DNS_settings'}."</a><br>";
print "<a href=\"servers.cgi\">".$text{'servers_config'}."</a><br>";
print "<a href=\"alias.cgi\">".$text{'alias_config'}."</a><br>";
print "<hr>";
print "<a href=\"dhcp.cgi\">";
print $text{'DHCP_config'};
print "</a><br>";
&footer("/", $text{'index'});
# uses the index entry in /lang/en



## if subroutines are not in an extra file put them here


### END of iface.cgi ###.
