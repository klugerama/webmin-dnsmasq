#!/usr/bin/perl
#
#    DNSMasq Webmin Module - dhcp.cgi; DHCP config
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

sub show_dhcp_settings {
    my @links = ["dhcp_basic.cgi", "dhcp_vendorclass.cgi","dhcp_userclass.cgi","dhcp_ranges.cgi","dhcp_reservations.cgi"];
    my @titles = [$text{"dhcp_settings"},$text{"dhcp_vendorclass"},$text{"dhcp_userclass"},$text{"dhcp_range"},$text{"spec_hosts"}];
    my @icons = ["images/icon.gif","images/icon.gif","images/icon.gif","images/icon.gif","images/icon.gif"];
    print icons_table(@links, @titles, @icons);
    # print "<br><hr><br><a href=\"dhcp_basic.cgi\">" . $text{"index_dns_settings"} . "</a><br/>";
    # print "<a href=\"dhcp_vendorclass.cgi\">" . $text{"dhcp_vendorclass"} . "</a><br/>";
    # print "<a href=\"dhcp_userclass.cgi\">" . $text{"dhcp_userclass"} . "</a><br/>";
    # print "<a href=\"dhcp_ranges.cgi\">" . $text{"dhcp_range"} . "</a><br/>";
    # print "<a href=\"dhcp_reservations.cgi\">" . $text{"spec_hosts"} . "</a><br/>";
    # print "<hr />\n";
    # print "<a href=\"index.cgi\">" . $text{"index_dns_settings"} . "</a></>";
    # # &footer("/", $text{"index"});
}
1;
# uses the index entry in /lang/en



## if subroutines are not in an extra file put them here


### END of dhcp.cgi ###.
