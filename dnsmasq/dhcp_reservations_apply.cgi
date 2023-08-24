#!/usr/bin/perl
#
#    DNSMasq Webmin Module - # TODO dhcp_reservations_apply.cgi; update DHCP reservations     
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

my $returnto = $in{"returnto"} || "dhcp_reservations.cgi";
my $returnlabel = $in{"returnlabel"} || $text{"index_dhcp_settings_basic"};

sub eval_input_fields {
    # =[<hwaddr>][,id:<client_id>|*][,set:<tag>][tag:<tag>][,<ipaddr>][,<hostname>][,<lease_time>][,ignore]
    # "mac", "clientid", "infiniband", "settag", "tag", "ip", "hostname", "leasetime", "ignore"
    my ($is_new) = @_;

    my $par_prefix = ($is_new == 1 ? "new_" : "") . "dhcp_host_";
    my $val = "";
    if ($in{$par_prefix . "mac"} ne "") {
        $val .= ($val ? "," : "") . $in{$par_prefix . "mac"};
    }
    if ($in{$par_prefix . "clientid"} ne "") {
        $val .= ($val ? "," : "") . $in{$par_prefix . "clientid"};
    }
    elsif ($in{$par_prefix . "infiniband"} ne "") {
        $val .= ($val ? "," : "") . $in{$par_prefix . "infiniband"};
    }
    if ($in{$par_prefix . "settag"} ne "") {
        my $settag = "";
        my $settagin = $in{$par_prefix . "settag"};
        foreach my $t ( @{ split( ",", $settagin ) } ) {
            $settag .= ( length( $settag ) ? "," : "" ) . ( $t !~ /^set:/ ) ? "set:" : "" . $t;
        }
        $val .= ($val ? "," : "") . $settag;
    }
    if ($in{$par_prefix . "tag"} ne "") {
        my $tag = $in{$par_prefix . "tag"};
        $tag = ( $tag !~ /^tag:/ ) ? "tag:" : "" . $tag;
        $val .= ($val ? "," : "") . $tag;
    }
    if ($in{$par_prefix . "ip"} ne "") {
        $val .= ($val ? "," : "") . $in{$par_prefix . "ip"};
    }
    if ($in{$par_prefix . "hostname"} ne "") {
        $val .= ($val ? "," : "") . $in{$par_prefix . "hostname"};
    }
    if ($in{$par_prefix . "leasetime"} ne "") {
        $val .= ($val ? "," : "") . $in{$par_prefix . "leasetime"};
    }
    if ($in{$par_prefix . "ignore"} == 1) {
        $val .= ($val ? "," : "") . "ignore";
    }
    return $val;
}

if ($in{'new_dhcp_host_'} ne "") {
    my $val = &eval_input_fields(1);
    &add_to_list( "dhcp-host", $val );
}
elsif ($in{"dhcp_host_idx"} ne "") {
    my $item = $dnsmconfig{"dhcp-host"}[$in{"dhcp_host_idx"}];
    my $file_arr = &read_file_lines($item->{"file"});
    my $val = "dhcp-host=" . &eval_input_fields();
    &update($item->{"line"}, $val, \@$file_arr, 0);
    &flush_file_lines();
}
else {
    my @sel = split(/\0/, $in{'sel'});
    &do_selected_action( [ "dhcp_host" ], \@sel, \%$dnsmconfig );
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
### END of dhcp_reservations_apply.cgi ###.
