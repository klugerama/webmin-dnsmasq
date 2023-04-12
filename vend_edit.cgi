#!/usr/bin/perl
#
#    DNSMasq Webmin Module - vend_edit.cgi;  edit vendor class
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
&parse_config_file( \%config, \$config_file );
# read posted data
&ReadParse();
# check for errors in read config
if( $config{errors} > 0 )
{
	&header( "DNSMasq settings", "" );
	print "<hr><h2>";
	print $text{warn_errors};
	print $config{errors};
	print $text{didnt_apply};
	print "</h3><hr>\n";
	&footer( "/", $text{'index'});
	exit;
}
# adjust everything to what we got
#
&header( "DNSMasq settings", "" );
print "<h2>".$text{vendor_classes}."</h2>";
print &ui_form_start( "vend_edit_apply.cgi", "post" );
print &ui_hidden( "idx", $in{idx} );
print $text{in_use}.&ui_yesno_radio( "used",
			($config{vendor_class}[$in{idx}]{used})?1:0 );
print $text{class}. &ui_textbox( "class", 
			$config{vendor_class}[$in{idx}]{class}, 60 );
print "<br>".$text{vendor}. &ui_textbox( "vendor", 
			$config{vendor_class}[$in{idx}]{vendor}, 60 );
print "<br><br>" . &ui_submit( $text{'save_button'} )."<br>";
print &ui_form_end();
print "<a href=delete.cgi?idx=".$in{idx}."&what=vendor_class&where=dhcp.cgi>".
	$text{delet}."</a>";
print "<br><a href=dhcp.cgi>".$text{DHCP_config}."</a>";
&footer( "/", $text{'index'});
#

# 
# sub-routines
#
### END of vend_edit.cgi ###.
