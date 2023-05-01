#!/usr/bin/perl
#
#    DNSMasq Webmin Module - alias_edit.cgi;  IP alias edit
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
    my $line="error.cgi?line=xx&type=".$text{"err_configbad"};
    &redirect( $line );
    exit;
}
# adjust everything to what we got
#
&header( "DNSMasq settings", "" );
print "<h2>".$text{"alias"}."</h2>";
print &ui_form_start( "alias_edit_apply.cgi", "post" );
print &ui_hidden( "idx", $in{idx} );
print $text{"forced_from"}. &ui_textbox( "from", 
                    $dnsmconfig{"alias"}[$in{idx}]{from}, 15 );
print "<br>";
print $text{"forced_ip"}. &ui_textbox( "to", 
                    $dnsmconfig{"alias"}[$in{idx}]{to}, 15 );
print "<br>";
print $text{"netmask_used"}. &ui_yesno_radio( "mask",
                ($dnsmconfig{"alias"}[$in{idx}]{netmask_used})?1:0 );
print $text{"netmask"}. &ui_textbox( "netmask",
                $dnsmconfig{"alias"}[$in{idx}]{netmask}, 15 );
print "<br>".$text{"enabled"}.&ui_yesno_radio( "used",
                ($dnsmconfig{"alias"}[$in{idx}]{used})?1:0 );
print "<br><br>" . &ui_submit( $text{"save_button"} )."<br>";
print &ui_form_end();
print "<a href=delete.cgi?idx=".$in{idx}."&what=alias&where=dns_alias.cgi".
    ">".$text{"delet"}."</a>";
print "<br><a href=dns_alias.cgi>".$text{"dns_alias_config"}."</a>";
&footer( "/", $text{"index"});
#

# 
# sub-routines
#
### END of alias_edit.cgi ###.
