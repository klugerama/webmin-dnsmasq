#!/usr/bin/perl
#
#    DNSMasq Webmin Module - dhcp_domain_name_apply.cgi; update DHCP domain name info     
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

my $returnto = $in{"returnto"} || "dhcp_domain_name.cgi";
my $returnlabel = $in{"returnlabel"} || $dnsmasq::text{"index_dhcp_domain_name"};

if ($in{'new_domain_domain'} ne "") {
    my $val = $in{"new_domain_domain"};
    if ($in{"new_domain_range"} ne "") {
        $val .= "," . $in{"new_domain_range"};
        if ($in{"new_domain_local"} == 1) {
            $val .= ",local";
        }
    }
    &add_to_list( "domain", $val );
}
elsif ($in{"domain_idx"} ne "" && $in{"domain_domain"} ne "") {
    my $item = $dnsmconfig{"domain"}[$in{"domain_idx"}];
    my $val = "domain=" . $in{"domain_domain"};
    if ($in{"domain_range"} ne "") {
        $val .= "," . $in{"domain_range"};
        if ($in{"domain_local"} == 1) {
            $val .= ",local";
        }
    }
    &save_update($item->{"file"}, $item->{"line"}, $val);
}
else {
    my @sel = split(/\0/, $in{'sel'});
    &do_selected_action( [ "domain" ], \@sel, \%$dnsmconfig );
}

#
# re-load basic page
&redirect( $returnto );

# 
# sub-routines
#
### END of dhcp_domain_name_apply.cgi ###.
