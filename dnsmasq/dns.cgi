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
    my @links = ();
    my @titles = ();
    my @icons = ();

    my @buttons = (
        {
            "link" => "dns_basic.cgi",
            "title" => $text{"index_dns_settings_basic"},
            "icon" => "basic.gif",
            "page" => 1
        },
        {
            "link" => "dns_servers.cgi",
            "title" => $text{"index_dns_servers"},
            "icon" => "servers.gif",
            "page" => 2
        },
        {
            "link" => "dns_iface.cgi",
            "title" => $text{"index_dns_iface_settings"},
            "icon" => "network.gif",
            "page" => 3
        },
        {
            "link" => "dns_alias.cgi",
            "title" => $text{"index_dns_alias_settings"},
            "icon" => "alias.gif",
            "page" => 4
        },
        {
            "link" => "dns_records.cgi",
            "title" => $text{"index_dns_records_settings"},
            "icon" => "records.gif",
            "page" => 5
        },
        {
            "link" => "dns_sec.cgi",
            "title" => $text{"index_dns_sec_settings"},
            "icon" => "lock.gif",
            "page" => 6
        },
        {
            "link" => "dns_auth.cgi",
            "title" => $text{"index_dns_auth_settings"},
            "icon" => "forwarding.gif",
            "page" => 7
        },
        {
            "link" => "dns_addn_config.cgi",
            "title" => $text{"index_dns_addn_config"},
            "icon" => "files.gif",
            "page" => 8
        },
        {
            "link" => "manual_edit.cgi?type=config",
            "title" => $text{"index_dns_config_edit"},
            "icon" => "manual.gif",
            "page" => 9
        },
        {
            "link" => "manual_edit.cgi?type=script",
            "title" => $text{"index_dns_scripts_edit"},
            "icon" => "manual.gif",
            "page" => 10
        },
        {
            "link" => "dnsmasq_control.cgi",
            "title" => $text{"index_dns_control"},
            "icon" => "misc.gif",
            "page" => 11
        },
        {
            "link" => "view_log.cgi",
            "title" => $text{"index_dns_view_log"},
            "icon" => "logs.gif",
            "page" => 12
        },
    );
    local $i;
    for ($i = 0; $i < @buttons; $i++ ) {
        push(@links, $buttons[$i]->{"link"} );
        push(@titles, $buttons[$i]->{"title"} );
        push(@icons, "images/" . ($current_theme ? "theme/" : "") . $buttons[$i]->{"icon"} );
    }

    print &icons_table(\@links, \@titles, \@icons);
    # &footer("/", $text{"index"});
}
1;
# uses the index entry in /lang/en

## if subroutines are not in an extra file put them here

### END of dns.cgi ###.
