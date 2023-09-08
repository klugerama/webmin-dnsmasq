#!/usr/bin/perl
#
#    DNSMasq Webmin Module - dns_basic_apply.cgi; update basic DNS info     
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
my $returnto = $in{"returnto"} || "dns_basic.cgi?tab=$tab";
my $returnlabel = $in{"returnlabel"} || $text{"index_dns_settings_basic"};

my @sel = split(/\0/, $in{'sel'});
my @hosts_file_adds = split(/\0/, $in{'new_addn_hosts'});
my @hostsdir_adds = split(/\0/, $in{'new_hostsdir'});
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
elsif ($in{"addn_hosts"} ne "" && $in{"addn_hosts_idx"} ne "") {
    my $item = $dnsmconfig{"addn-hosts"}[$in{"addn_hosts_idx"}];
    my $val = "addn-hosts=" . $in{"addn_hosts"};
    &save_update($item->{"file"}, $item->{"line"}, $val);
}
elsif (@hostsdir_adds) {

    foreach my $hostsdir_add (@hostsdir_adds) {
        if ($hostsdir_add ne "") {
            &add_to_list( "hostsdir", $hostsdir_add );
        }
    }

}
elsif ($in{"hostsdir"} ne "" && $in{"hostsdir_idx"} ne "") {
    my $item = $dnsmconfig{"hostsdir"}[$in{"hostsdir_idx"}];
    my $val = "hostsdir=" . $in{"hostsdir"};
    &save_update($item->{"file"}, $item->{"line"}, $val);
}
elsif (@resolv_file_adds) {

    foreach my $resolv_file_add (@resolv_file_adds) {
        if ($resolv_file_add ne "") {
            &add_to_list( "resolv-file", $resolv_file_add );
        }
    }

}
elsif ($in{"resolv_file"} ne "" && $in{"resolv_file_idx"} ne "") {
    my $item = $dnsmconfig{"resolv-file"}[$in{"resolv_file_idx"}];
    my $val = "resolv-file=" . $in{"resolv_file"};
    &save_update($item->{"file"}, $item->{"line"}, $val);
}
else {
    &do_selected_action( [ "addn_hosts", "hostsdir", "resolv_file" ], \@sel, \%$dnsmconfig );
}
#
# re-load basic page
&redirect( $returnto );

### END of dns_basic_apply.cgi ###.
