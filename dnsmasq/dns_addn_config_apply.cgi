#!/usr/bin/perl
#
#    DNSMasq Webmin Module - dns_addn_config_apply.cgi; update basic DNS info     
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

## put in ACL checks here if needed

my $config_filename = $config{config_file};
my $config_file = &read_file_lines( $config_filename );

&parse_config_file( \%dnsmconfig, \$config_file, $config_filename );
# read posted data
&ReadParse();

my $tab = $in{"tab"} || "basic";
my $returnto = $in{"returnto"} || "dns_addn_config.cgi?tab=$tab";
my $returnlabel = $in{"returnlabel"} || $text{"index_dns_settings_basic"};

# adjust everything to what we got

my $result = "";
my @sel = split(/\0/, $in{'sel'});
my @conf_file_adds = split(/\0/, $in{'new_conf_file'});
my @servers_file_adds = split(/\0/, $in{'new_servers_file'});
my @conf_dir_adds = split(/\0/, $in{'new_conf_dir'});

if ($in{"conf_dir_idx"} ne "" && ($in{"conf_dir_filter"} ne "" || $in{"conf_dir_exceptions"} ne "")) {
    my $item = $dnsmconfig{"conf_dir"}[$in{"conf_dir_idx"}];
    my $val = "conf-dir=" . $in{"conf_dir_dirname"};
    if ($in{"conf_dir_filter"} ne "") {
        $val .= "," . $in{"conf_dir_filter"};
    }
    elsif ($in{"conf_dir_exceptions"} ne "") {
        $val .= "," . $in{"conf_dir_exceptions"};
    }
    &save_update($item->{"file"}, $item->{"line"}, $val);
}
elsif (@conf_file_adds) {
    foreach my $conf_file_add (@conf_file_adds) {
        if ($conf_file_add ne "") {
            &add_to_list( "conf-file", $conf_file_add );
        }
    }
}
elsif (@servers_file_adds) {
    foreach my $servers_file_add (@servers_file_adds) {
        if ($servers_file_add ne "") {
            &add_to_list( "servers-file", $servers_file_add );
        }
    }
}
elsif (@conf_dir_adds) {
    foreach my $conf_dir_add (@conf_dir_adds) {
        if ($conf_dir_add ne "") {
            &add_to_list( "conf-dir", $conf_dir_add );
        }
    }
}
else {
    # $action = $in{"enable_sel_conf_file"} ? "enable" : $in{"disable_sel_conf_file"} ? "disable" : $in{"delete_sel_conf_file"} ? "delete" : "";
    # if ($action ne "") {
    #     @sel || &error($text{'selected_none'});
    #     &update_selected("conf-file", $action, \@sel, \%$dnsmconfig);
    # }
    # else {
    #     $action = $in{"enable_sel_servers_file"} ? "enable" : $in{"disable_sel_servers_file"} ? "disable" : $in{"delete_sel_servers_file"} ? "delete" : "";
    #     if ($action ne "") {
    #         @sel || &error($text{'selected_none'});
    #         &update_selected("servers-file", $action, \@sel, \%$dnsmconfig);
    #     }
    #     else {
    #         $action = $in{"enable_sel_conf_dir"} ? "enable" : $in{"disable_sel_conf_dir"} ? "disable" : $in{"delete_sel_conf_dir"} ? "delete" : "";
    #         if ($action ne "") {
    #             @sel || &error($text{'selected_none'});
    #             &update_selected("conf-dir", $action, \@sel, \%$dnsmconfig);
    #         }
    #     }
    # }
    &do_selected_action( [ "conf_file", "servers_file", "conf_dir" ], \@sel, \%$dnsmconfig );
}
#
# re-load additional config files page
&redirect( $returnto );

# 
# sub-routines
#
### END of dns_apply.cgi ###.
