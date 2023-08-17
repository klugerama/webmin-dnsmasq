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
    my @links = ();
    my @titles = ();
    my @icons = ();

    my @buttons = (
        {
            "link" => "dhcp_basic.cgi",
            "title" => $text{"index_dhcp_settings_basic"},
            "icon" => "basic.gif",
            "page" => 1
        },
        {
            "link" => "dhcp_domain_name.cgi",
            "title" => $text{"index_dhcp_domain_name"},
            "icon" => "hostnames.gif",
            "page" => 2
        },
        {
            "link" => "dhcp_client_options.cgi",
            "title" => $text{"index_dhcp_client_options"},
            "icon" => "clients.gif",
            "page" => 3
        },
        {
            "link" => "dhcp_tags.cgi",
            "title" => $text{"index_dhcp_tags"},
            "icon" => "tag.gif",
            "page" => 4
        },
        {
            "link" => "dhcp_range.cgi",
            "title" => $text{"index_dhcp_range"},
            "icon" => "ranges.gif",
            "page" => 5
        },
        {
            "link" => "dhcp_reservations.cgi",
            "title" => $text{"index_dhcp_host_reservations"},
            "icon" => "reservations.gif",
            "page" => 6
        },
    );
    local $i;
    for ($i = 0; $i < @buttons; $i++ ) {
        push(@links, $buttons[$i]->{"link"} );
        push(@titles, $buttons[$i]->{"title"} );
        push(@icons, "images/" . ($current_theme ? "theme/" : "") . $buttons[$i]->{"icon"} );
    }

    print &icons_table(\@links, \@titles, \@icons);

    # print &icons_table(@links, @titles);
}
1;
# uses the index entry in /lang/en



## if subroutines are not in an extra file put them here


### END of dhcp.cgi ###.
