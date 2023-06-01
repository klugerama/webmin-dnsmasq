#!/usr/bin/perl
#
#    DNSMasq Webmin Module - # TODO tftp.cgi; TFTP, bootp, & pxe config     
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

sub show_tftp_settings {
    # &header( "DNSMasq settings", "" );
    # &parse_config_file( \%dnsmconfig, \$config_file, $config_filename );
    print &ui_form_start( 'tftp_apply.cgi', "post" );
    # print "<br>\n";
    # print "<h2>$text{"index_dns_settings"}</h2>";
    # print "<br><br>\n";




    print "<br><br>\n";
    print &ui_submit( $text{"save_button"} );
    print &ui_form_end( );
    print "<hr>";
    print "<a href=\"dns_servers.cgi\">";
    print $text{"index_dns_servers"};
    print "</a><br>";
    print "<a href=\"dns_iface.cgi\">";
    print $text{"index_dns_iface_settings"};
    print "</a><br>";
    print "<a href=\"dns_alias.cgi\">";
    print $text{"index_dns_alias_settings"};
    print "</a><br>";
    print "<hr>";
    print "<a href=\"dhcp.cgi\">";
    print $text{"index_dhcp_config"};
    print "</a><br>";
    print "<hr>";
    print "<a href=\"restart.cgi\">";
    print $text{"restart"};
    print "</a><br>";
    # &footer("/", $text{"index"});
}
1;
# uses the index entry in /lang/en



## if subroutines are not in an extra file put them here


### END of index.cgi ###.
