#!/usr/bin/perl
#
#    DNSMasq Webmin Module - dns_servers_apply.cgi; update DNS server info     
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

require "dnsmasq-lib.pl";

my %access=&get_module_acl();

## put in ACL checks here if needed

my $config_filename = $config{config_file};
my $config_file = &read_file_lines( $config_filename );

&parse_config_file( \%dnsmconfig, \$config_file, $config_filename );
# read posted data
&ReadParse();

my $tab = $in{"tab"} || "basic";
my $returnto = $in{"returnto"} || "dns_servers.cgi?tab=$tab";
my $returnlabel = $in{"returnlabel"} || $text{"index_dhcp_settings_basic"};
# check for input data errors

# adjust everything to what we got
my $result = "";
my @sel = split(/\0/, $in{'sel'});

if ($in{"submit"}) {
    &apply_simple_vals("dns", \@sel, "2");
}
elsif ($in{"new_server_domain"} ne "" || $in{"new_server_ip"} ne "") {
    my $newval = "";
    if ($in{"new_server_domain"} ne "") {
        $newval .= "/" . $in{"new_server_domain"} . "/";
    }
    if ($in{"new_server_ip"} ne "") {
        $newval .= $in{"new_server_ip"};
    }
    if ($in{"new_server_source"} ne "") {
        $newval .= "," . $in{"new_server_source"};
    }
    &add_to_list("server", $newval);
}
elsif ($in{"server_idx"} ne "") {
    my $item = $dnsmconfig{"server"}[$in{"server_idx"}];
    my $file_arr = &read_file_lines($item->{"file"});
    my $newval = $item->{"val"}->{"is_local"} ? "local=" : "server=";
    if ($in{"server_domain"} ne "") {
        $newval .= "/" . $in{"server_domain"} . "/";
    }
    if ($in{"server_ip"} ne "") {
        $newval .= $in{"server_ip"};
    }
    if ($in{"server_source"} ne "") {
        $newval .= "," . $in{"server_source"};
    }
    &update($item->{"line"}, $newval, \@$file_arr, 0);
    &flush_file_lines();
}
elsif ($in{"new_rev_server_domain"} ne "" || $in{"new_rev_server_ip"} ne "") {
    my $newval = "";
    if ($in{"new_rev_server_domain"} ne "") {
        $newval .= "/" . $in{"new_rev_server_domain"} . "/";
    }
    if ($in{"new_rev_server_ip"} ne "") {
        $newval .= $in{"new_rev_server_ip"};
    }
    if ($in{"new_rev_server_source"} ne "") {
        $newval .= "," . $in{"new_rev_server_source"};
    }
    &add_to_list("rev-server", $newval);
}
elsif ($in{"rev_server_idx"} ne "") {
    my $item = $dnsmconfig{"rev-server"}[$in{"rev_server_idx"}];
    my $file_arr = &read_file_lines($item->{"file"});
    my $newval = "rev-server=";
    if ($in{"rev_server_domain"} ne "") {
        $newval .= "/" . $in{"rev_server_domain"} . "/";
    }
    if ($in{"rev_server_ip"} ne "") {
        $newval .= $in{"rev_server_ip"};
    }
    if ($in{"rev_server_source"} ne "") {
        $newval .= "," . $in{"rev_server_source"};
    }
    &update($item->{"line"}, $newval, \@$file_arr, 0);
    &flush_file_lines();
}
else {
    # my $action = $in{"enable_sel_server"} ? "enable" : $in{"disable_sel_server"} ? "disable" : $in{"delete_sel_server"} ? "delete" : "";
    # if ($action ne "") {
    #     @sel || &error($text{'selected_none'});

    #     &update_selected("server", $action, \@sel, \%$dnsmconfig);
    # }
    # else {
    #     $action = $in{"enable_sel_rev_server"} ? "enable" : $in{"disable_sel_rev_server"} ? "disable" : $in{"delete_sel_rev_server"} ? "delete" : "";
    #     if ($action ne "") {
    #         @sel || &error($text{'selected_none'});

    #         &update_selected("rev-server", $action, \@sel, \%$dnsmconfig);
    #     }
    # }
    &do_selected_action( [ "server", "rev_server" ], \@sel, \%$dnsmconfig );
}

#
# write file!!
&flush_file_lines();
#
# re-load basic page
&redirect( $returnto );

# 
# sub-routines
#
### END of dns_servers_apply.cgi ###.
