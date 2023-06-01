#!/usr/bin/perl
#
#    DNSMasq Webmin Module - # TODO iface_edit.cgi;  edit interface
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

require 'dnsmasq-lib.pl';
if ( &foreign_available("net") ) {
    &foreign_require("net", "net-lib.pl");
}

my %access=&get_module_acl;

## put in ACL checks here if needed

&header($text{"index_title"}, "", "intro", 1, 0, 0, &restart_button());

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
print "<h2>".&text("edit_", $text{"_iface"})."</h2>";
print &ui_form_start( "iface_edit_apply.cgi", "post" );
print &ui_hidden( "idx", $in{"idx"} );
print "<br>".$text{"enabled"}.&ui_yesno_radio( "used",
				($dnsmconfig{"interface"}[$in{"idx"}]->{"used"})?1:0 );
print "<br>".$text{"p_label_interface"}." ".$text{"_name"};
print &ui_textbox( "interface", $dnsmconfig{"interface"}[$in{"idx"}]->{"val"}, 15 )." ".
		    ( ( &foreign_available("net") ) ? &foreign_call("net", "interfaces_chooser_button", ("interface")) : "" );
print "<br><br>" . &ui_submit( $text{"save_button"} )."<br>";
print &ui_form_end();
print "<a href=delete.cgi?idx=".$in{"idx"}."&what=interface&where=dns_iface.cgi".
	">".$text{"delet"}."</a>";
print "<br><a href=dns_iface.cgi>".$text{"index_dns_iface_settings"}."</a>";
&footer( "/", $text{"index"});
#

# 
# sub-routines
#
### END of iface_edit.cgi ###.
