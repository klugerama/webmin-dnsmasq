#!/usr/bin/perl
#
#    DNSMasq Webmin Module - range_edit.cgi;  DHCP range edit
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
print "<h2>".$text{range_edit}."</h2>";
print &ui_form_start( "range_edit_apply.cgi", "post" );
print &ui_hidden( "idx", $in{idx} );
print "<br>".$text{in_use}.&ui_yesno_radio( "used",
				($config{dhcp_range}[$in{idx}]{used})?1:0 );
print "<br>".$text{ided}.&ui_yesno_radio( "ided", 
				($config{dhcp_range}[$in{idx}]{id_used})?1:0 );
print "<br>".$text{id};
print &ui_textbox( "id", $config{dhcp_range}[$in{idx}]{id}, 50 );
print "<br>".$text{forced_from};
print &ui_textbox( "from", $config{dhcp_range}[$in{idx}]{start}, 18 );
print "<br>".$text{forced_ip};
print &ui_textbox( "to", $config{dhcp_range}[$in{idx}]{end}, 18 );
print "<br>".$text{forced_mask_used}.&ui_yesno_radio( "masked", 
				($config{dhcp_range}[$in{idx}]{mask_used})?1:0 );
print "<br>".$text{forced_mask};
print &ui_textbox( "mask", $config{dhcp_range}[$in{idx}]{mask}, 18 );
print "<br>".$text{timed}.&ui_yesno_radio( "timed", 
				($config{dhcp_range}[$in{idx}]{time_used})?1:0 );
print "<br>".$text{leasetime};
print &ui_textbox( "time", $config{dhcp_range}[$in{idx}]{leasetime}, 18 );
print "<br><br>" . &ui_submit( $text{'save_button'} )."<br>";
print &ui_form_end();
print "<a href=delete.cgi?idx=".$in{idx}."&what=dhcp_range&where=dhcp.cgi".
		">".$text{delet}."</a>";
print "<br><a href=dhcp.cgi>".$text{DHCP_settings}."</a>";
&footer( "/", $text{'index'});
#

# 
# sub-routines
#
### END of range_edit.cgi ###.
