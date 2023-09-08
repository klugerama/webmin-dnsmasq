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

## put in ACL checks here if needed

my $config_filename = $config{config_file};
my $config_file = &read_file_lines( $config_filename );

&parse_config_file( \%dnsmconfig, \$config_file, $config_filename );

# read posted data
&ReadParse();

my $tab = $in{"tab"} || "basic";
my $returnto = $in{"returnto"} || "dns_records.cgi?tab=$tab";
my $returnlabel = $in{"returnlabel"} || $text{"index_dns_records_settings"};

# check for input data errors
if( ($in{resolv_std}) && ($in{resolv_file} !~ /^$FILE$/) ) {
	my $line = "error.cgi?line=".$text{"p_label_resolv_file"};
	$line .= "&type=" . &urlize($text{"err_filebad"});
	&redirect( $line );
	exit;
}
# adjust everything to what we got
my $result = "";
my @sel = split(/\0/, $in{'sel'});

if ($in{"submit"}) {
    &apply_simple_vals("dns", \@sel, "5");
}
elsif ($in{"new_ipset_domain"} ne "" && $in{"new_ipset_ipset"} ne "" ) {
    my $newval = "/" . $in{"new_ipset_domain"} . "/" . $in{"new_ipset_ipset"};
    &add_to_list("ipset", $newval);
}
elsif ($in{"ipset_idx"} ne "") {
    my $item = $dnsmconfig{"ipset"}[$in{"ipset_idx"}];
    my $val = "ipset=/" . $in{"ipset_domain"} . "/" . $in{"ipset_ipset"};
    &save_update($item->{"file"}, $item->{"line"}, $val);
}
elsif ($in{"new_connmark_allowlist_connmark"} ne "" ) {
    my $newval = $in{"new_connmark_allowlist_connmark"};
    if ($in{"new_connmark_allowlist_mask"}) {
        $newval .= "/" . $in{"new_connmark_allowlist_mask"};
    }
    if ($in{"new_connmark_allowlist_pattern"}) {
        $newval .= "," . $in{"new_connmark_allowlist_pattern"};
    }
    &add_to_list("connmark-allowlist", $newval);
}
elsif ($in{"connmark_allowlist_idx"} ne "") {
    my $item = $dnsmconfig{"connmark_allowlist"}[$in{"connmark_allowlist_idx"}];
    my $val = "connmark-allowlist=" . $in{"connmark_allowlist_connmark"};
    if ($in{"connmark_allowlist_mask"}) {
        $val .= "/" . $in{"connmark_allowlist_mask"};
    }
    if ($in{"connmark_allowlist_pattern"}) {
        $val .= "," . $in{"connmark_allowlist_pattern"};
    }
    &save_update($item->{"file"}, $item->{"line"}, $val);
}
else {
    &do_selected_action( [ "ipset", "connmark_allowlist" ], \@sel, \%$dnsmconfig );
}

#
# re-load basic page
&redirect( $returnto . "?tab=" . $tab );

# 
# sub-routines
#
### END of dns_servers_apply.cgi ###.
