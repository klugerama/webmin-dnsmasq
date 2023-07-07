#!/usr/bin/perl
#
#    DNSMasq Webmin Module - # TODO dns_basic_apply.cgi; update basic DNS info     
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

my %access=&get_module_acl;

## put in ACL checks here if needed

my $config_filename = $config{config_file};
my $config_file = &read_file_lines( $config_filename );

&parse_config_file( \%dnsmconfig, \$config_file, $config_filename );
# read posted data
&ReadParse();

my $returnto = $in{"returnto"} || "dns_basic.cgi";
my $returnlabel = $in{"returnlabel"} || $text{"index_dns_settings_basic"};
# check for errors in read config
if( $dnsmconfig{"errors"} > 0 ) {
    my $line = "error.cgi?line=xx&type=" . &urlize($text{"err_configbad"});
    &redirect( $line );
    exit;
}

my @sel = split(/\0/, $in{'sel'});
my @hosts_file_adds = split(/\0/, $in{'new_addn_hosts_file'});
my @hostsdir_adds = split(/\0/, $in{'new_hostsdir_dir'});
my @resolv_file_adds = split(/\0/, $in{'new_resolv_file'});

if ($in{"submit"}) {
    &apply_simple_vals("dns", \@sel, "1");
}
elsif (@hosts_file_adds) {

    foreach my $hosts_file_add (@hosts_file_adds) {
        if ($hosts_file_add ne "") {
            &add_to_list( "addn-hosts", $hosts_file_add );
        }
    }

}
elsif (@hostsdir_adds) {

    foreach my $hostsdir_add (@hostsdir_adds) {
        if ($hostsdir_add ne "") {
            &add_to_list( "hostsdir", $hostsdir_add );
        }
    }

}
elsif (@resolv_file_adds) {

    foreach my $resolv_file_add (@resolv_file_adds) {
        if ($resolv_file_add ne "") {
            &add_to_list( "resolv-file", $resolv_file_add );
        }
    }

}
else {
    my $action = $in{"enable_sel_addn_hosts"} ? "enable" : $in{"disable_sel_addn_hosts"} ? "disable" : $in{"delete_sel_addn_hosts"} ? "delete" : "";
    if ($action ne "") {
        @sel || &error($text{'selected_none'});

        &update_selected("addn-hosts", $action, \@sel, \%$dnsmconfig);
    }
    else {
        $action = $in{"enable_sel_hostsdir"} ? "enable" : $in{"disable_sel_hostsdir"} ? "disable" : $in{"delete_sel_hostsdir"} ? "delete" : "";
        if ($action ne "") {
            @sel || &error($text{'selected_none'});

            &update_selected("hostsdir", $action, \@sel, \%$dnsmconfig);
        }
        else {
            $action = $in{"enable_sel_resolv_file"} ? "enable" : $in{"disable_sel_resolv_file"} ? "disable" : $in{"delete_sel_resolv_file"} ? "delete" : "";
            if ($action ne "") {
                @sel || &error($text{'selected_none'});

                &update_selected("resolv-file", $action, \@sel, \%$dnsmconfig);
            }
        }
    }
}
#
# re-load basic page
&redirect( $returnto );

# 
# sub-routines
#
### END of dns_basic_apply.cgi ###.
