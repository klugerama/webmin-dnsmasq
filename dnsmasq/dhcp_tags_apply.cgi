#!/usr/bin/perl
#
#    DNSMasq Webmin Module - dhcp_tags_apply.cgi; update DHCP tag matching 
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
my $returnto = $in{"returnto"} || "dhcp_tags.cgi?tab=$tab";
my $returnlabel = $in{"returnlabel"} || $dnsmasq::text{"index_dhcp_tags"};

# adjust everything to what we got

if ($in{"new_dhcp_userclass_userclass"} ne "") {
    my $newval = "set:" . $in{"new_dhcp_userclass_tag"} . "," . $in{"new_dhcp_userclass_userclass"};
    &add_to_list("dhcp-userclass", $newval);
}
elsif ($in{"dhcp_userclass_idx"} ne "") {
    my $item = $dnsmconfig{"dhcp-userclass"}[$in{"dhcp_userclass_idx"}];
    my $val = "dhcp-userclass=set:" . $in{"dhcp_userclass_tag"} . "," . $in{"dhcp_userclass_userclass"};
    &save_update($item->{"file"}, $item->{"lineno"}, $val);
}
elsif ($in{"new_dhcp_vendorclass_vendorclass"} && $in{"new_dhcp_vendorclass_vendorclass"} ne "") {
    my $newval = "set:" . $in{"new_dhcp_vendorclass_tag"} . "," . $in{"new_dhcp_vendorclass_vendorclass"};
    &add_to_list("dhcp-vendorclass", $newval);
}
elsif ($in{"dhcp_vendorclass_idx"} ne "") {
    my $item = $dnsmconfig{"dhcp-vendorclass"}[$in{"dhcp_vendorclass_idx"}];
    my $val = "dhcp-vendorclass=set:" . $in{"dhcp_vendorclass_tag"} . "," . $in{"dhcp_vendorclass_vendorclass"};
    &save_update($item->{"file"}, $item->{"lineno"}, $val);
}
else {
    my @sel = split(/\0/, $in{'sel'});
    @sel || &error($dnsmasq::text{'selected_none'});

    &do_selected_action( [ "dhcp_userclass", "dhcp_vendorclass" ], \@sel, \%$dnsmconfig );
}

#
# re-load tag page
&redirect( $returnto );

### END of dhcp_tags_apply.cgi ###.
