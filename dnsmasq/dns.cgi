#!/usr/bin/perl
#
#    DNSMasq Webmin Module - dns.cgi; basic DNS config     
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

sub show_dns_settings {
    my @links = ["dns_basic.cgi", "dns_servers.cgi","dns_iface.cgi","dns_alias.cgi"];
    my @titles = [$text{"index_dns_settings_basic"},$text{"dns_servers_config"},$text{"dns_iface_config"},$text{"dns_alias_config"}];
    my @icons = ["images/icon.gif","images/icon.gif","images/icon.gif","images/icon.gif"];
    print icons_table(@links, @titles, @icons);


    # print "<hr>";
    # print "<a href=\"dns_servers.cgi\">";
    # print $text{"dns_servers_config"};
    # print "</a><br>";
    # print "<a href=\"dns_iface.cgi\">";
    # print $text{"dns_iface_config"};
    # print "</a><br>";
    # print "<a href=\"dns_alias.cgi\">";
    # print $text{"dns_alias_config"};
    # print "</a><br>";
    # print "<hr>";
    # print "<a href=\"restart.cgi\">";
    # print $text{"restart"};
    # print "</a><br>";
    # &footer("/", $text{"index"});
}
1;
# uses the index entry in /lang/en



## if subroutines are not in an extra file put them here


### END of index.cgi ###.
