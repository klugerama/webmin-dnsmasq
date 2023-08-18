#!/usr/bin/perl
#
#    DNSMasq Webmin Module - dns_alias_apply.cgi; do the update      
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

my $mode = $in{"mode"} || "basic";
my $returnto = $in{"returnto"} || "dns_alias.cgi?mode=$mode";
my $returnlabel = $in{"returnlabel"} || $text{"index_dhcp_settings_basic"};

# check for errors in read config
if( $dnsmconfig{"errors"} > 0 ) {
    my $line="error.cgi?line=xx&type=" . &urlize($text{"err_configbad"});
    &redirect( $line );
    exit;
}
# check for input data errors

# first get each checked item's filename

my @sel = split(/\0/, $in{'sel'});

# adjust everything to what we got
#
if ($in{"submit"}) {
    &apply_simple_vals("dns", \@sel, "4");

    &check_other_vals("dns", \@sel);

    if ($in{"rebind_domain_ok_val"}) {
        my @rebind_domain_ok_val = split(/\0/, $in{'rebind_domain_ok_val'});
        my $item = $dnsmconfig{"rebind-domain-ok"};
        my $file_arr = &read_file_lines($item->{"file"});
        my $val = "rebind-domain-ok=";
        if (@rebind_domain_ok_val == 1) {
            $val .= @rebind_domain_ok_val[0];
        }
        else {
            foreach my $dom (@rebind_domain_ok_val) {
                $val .= "/" . $dom;
            }
            $val .= "/";
        }
        &update($item->{"line"}, $val, \@$file_arr, 0);
        &flush_file_lines();
    }
}
elsif ($in{'new_alias_from'} ne "") {
    my $val = $in{"new_alias_from"};
    $val .= "," . $in{"new_alias_to"};
    if ($in{"new_alias_netmask"} ne "") {
        $val .= "," . $in{"new_alias_netmask"};
    }
    &add_to_list( "alias", $val );
}
elsif ($in{'new_bogus_nxdomain_ip'} ne "") {
    my $val = $in{"new_bogus_nxdomain_ip"};
    &add_to_list( "bogus-nxdomain", $val );
}
elsif ($in{'new_address_domain'} ne "") {
    my $val = "/" . $in{"new_address_domain"};
    $val .= "/" . $in{"new_address_ip"};
    &add_to_list( "address", $val );
}
elsif ($in{'new_ignore_address_ip'} ne "") {
    my $val = $in{"new_ignore_address_ip"};
    &add_to_list( "ignore-address", $val );
}
elsif ($in{"alias_idx"} ne "" && $in{"alias_from"} ne "") {
    my $item = $dnsmconfig{"alias"}[$in{"alias_idx"}];
    my $file_arr = &read_file_lines($item->{"file"});
    my $val = "alias=" . $in{"alias_from"};
    $val .= "," . $in{"alias_to"};
    if ($in{"alias_netmask"} ne "") {
        $val .= "," . $in{"alias_netmask"};
    }
    &update($item->{"line"}, $val, \@$file_arr, 0);
    &flush_file_lines();
}
elsif ($in{"bogus_nxdomain_idx"} ne "" && $in{"bogus_nxdomain_ip"} ne "") {
    my $item = $dnsmconfig{"bogus-nxdomain"}[$in{"bogus_nxdomain_idx"}];
    my $file_arr = &read_file_lines($item->{"file"});
    my $val = "bogus-nxdomain=" . $in{"bogus_nxdomain_ip"};
    &update($item->{"line"}, $val, \@$file_arr, 0);
    &flush_file_lines();
}
elsif ($in{"address_idx"} ne "" && $in{"address_domain"} ne "") {
    my $item = $dnsmconfig{"address"}[$in{"address_idx"}];
    my $file_arr = &read_file_lines($item->{"file"});
    my $val = "address=" . "/" . $in{"address_domain"};
    $val .= "/" . $in{"address_ip"};
    &update($item->{"line"}, $val, \@$file_arr, 0);
    &flush_file_lines();
}
elsif ($in{"ignore_address_idx"} ne "" && $in{"ignore_address_ip"} ne "") {
    my $item = $dnsmconfig{"ignore-address"}[$in{"ignore_address_idx"}];
    my $file_arr = &read_file_lines($item->{"file"});
    my $val = "ignore-address=" . $in{"ignore_address_ip"};
    &update($item->{"line"}, $val, \@$file_arr, 0);
    &flush_file_lines();
}
else {
    &do_selected_action( [ "alias", "bogus_nxdomain", "address", "ignore_address" ], \@sel, \%$dnsmconfig );
}

#
# re-load basic page
&redirect( $returnto );

# 
# sub-routines
#
### END of dns_alias_apply.cgi ###.
