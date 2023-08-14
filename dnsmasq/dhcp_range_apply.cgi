#!/usr/bin/perl
#
#    DNSMasq Webmin Module - # TODO dhcp_range_apply.cgi; update DHCP address ranges
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
my $returnto = $in{"returnto"} || "dhcp_range.cgi?mode=$mode";
my $returnlabel = $in{"returnlabel"} || $text{"index_dhcp_range"};

# check for errors in read config
if( $dnsmconfig{"errors"} > 0 ) {
    my $line = "error.cgi?line=xx&type=" . &urlize($text{"err_configbad"});
    &redirect( $line );
    exit;
}

my $result = "";

# =[tag:<tag>[,tag:<tag>],][set:<tag>,]<start-addr>[,<end-addr>|<mode>][,<netmask>[,<broadcast>]][,<lease time>] 
# -OR- 
# =[tag:<tag>[,tag:<tag>],][set:<tag>,]<start-IPv6addr>[,<end-IPv6addr>|constructor:<interface>][,<mode>][,<prefix-len>][,<lease time>]
sub eval_input_fields {
    my ($is_new) = @_;

    my $par_prefix = ($is_new == 1) ? "new_" : "";
    my $val = "";
    if ($in{$par_prefix . "dhcp_range_tag"} ne "") {
        my $tag = "";
        my $tagin = $in{$par_prefix . "dhcp_range_tag"};
        foreach my $t ( @{ split( ",", $tagin ) } ) {
            $tag .= ( length( $tag ) ? "," : "" ) . ( $t !~ /^(tag|set):/ ) ? "tag:" : "" . $t;
        }
        $val .= $tag;
    }
    if ($in{$par_prefix . "dhcp_range_settag"} ne "") {
        my $settag = $in{$par_prefix . "dhcp_range_settag"};
        if ( $settag !~ /^set:/ ) {
            $settag = "set:" . $settag;
        }
        $val .= "," . $settag;
    }
    my $val = ($val ? "," : "") . $in{$par_prefix . "dhcp_range_start"};
    if ($in{$par_prefix . "dhcp_range_ipversion"} == 4) {
        if ($in{$par_prefix . "dhcp_range_end"} ne "") {
            $val .= "," . $in{$par_prefix . "dhcp_range_end"};
        }
        elsif ($in{$par_prefix . "dhcp_range_static"} == 1) {
            $val .= ",static";
        }
        elsif ($in{$par_prefix . "dhcp_range_proxy"} == 1) {
            $val .= ",proxy";
        }
        if ($in{$par_prefix . "dhcp_range_mask"} ne "") {
            $val .= "," . $in{$par_prefix . "dhcp_range_mask"};
            if ($in{$par_prefix . "dhcp_range_broadcast"} ne "") {
                $val .= "," . $in{$par_prefix . "dhcp_range_broadcast"};
            }
        }
    }
    if ($in{$par_prefix . "dhcp_range_ipversion"} == 6) {
        if ($in{$par_prefix . "dhcp_range_end"} ne "") {
            $val .= "," . $in{$par_prefix . "dhcp_range_end"};
        }
        foreach my $mode ( "static", "ra-only", "ra-names", "ra-stateless", "slaac", "ra-advrouter", "off-link" ) {
            if ($in{$par_prefix . "dhcp_range_$mode"} == 1) {
                $val .= ",$mode";
            }
        }
        if ($in{$par_prefix . "dhcp_range_prefix-length"} ne "") {
            $val .= "," . $in{$par_prefix . "dhcp_range_prefix-length"};
        }
    }
    if ($in{$par_prefix . "dhcp_range_leasetime"} ne "") {
        $val .= "," . $in{$par_prefix . "dhcp_range_leasetime"};
    }
    return $val;
}

if ($in{'new_dhcp_range_start'} ne "") {
    my $val = &eval_input_fields(1);
    &add_to_list( "dhcp-range", $val );
}
elsif ($in{"dhcp_range_idx"} ne "" && $in{"dhcp_range_start"} ne "") {
    my $item = $dnsmconfig{"dhcp-range"}[$in{"dhcp_range_idx"}];
    my $file_arr = &read_file_lines($item->{"file"});
    my $val = "dhcp-range=" . &eval_input_fields();
    &update($item->{"line"}, $val, \@$file_arr, 0);
    &flush_file_lines();
}
else {
    my @sel = split(/\0/, $in{'sel'});
    &do_selected_action( [ "dhcp_range" ], \@sel, \%$dnsmconfig );
}

#
# re-load basic page
&redirect( $returnto );

# 
# sub-routines
#
### END of dhcp_range_apply.cgi ###.
