#!/usr/bin/perl
#
#    DNSMasq Webmin Module - dhcp_client_option_apply.cgi; update DHCP client options     
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

my $returnto = $in{"returnto"} || "dhcp_client_options.cgi";
my $returnlabel = $in{"returnlabel"} || $text{"index_dhcp_settings_basic"};

# check for errors in read config
if( $dnsmconfig{"errors"} > 0 ) {
    my $line="error.cgi?line=xx&type=" . &urlize($text{"err_configbad"});
    &redirect( $line );
    exit;
}
# check for input data errors
# adjust everything to what we got

# adjust everything to what we got

# $action = $in{"enable_sel"} ? "enable" : $in{"disable_sel"} ? "disable" : $in{"delete_sel"} ? "delete" : "";
# if ($action ne "") {
#     &update_selected("dhcp-option", $action, \@sel, \%$dnsmconfig);
# }

# =[tag:<tag>,[tag:<tag>,]][encap:<opt>,][vi-encap:<enterprise>,][vendor:[<vendor-class>],][<opt>|option:<opt-name>|option6:<opt>|option6:<opt-name>],[<value>[,<value>]]

if ($in{'new_dhcp_option'} ne "") {
    my $val = "";
    if ($in{"new_dhcp_option_tag"} ne "") {
        my $tag = $in{"new_dhcp_option_tag"};
        if ( $tag !~ /^tag:/ ) {
            $tag = "tag:" . $tag;
        }
        $val .= $tag;
    }
    if ($in{"new_dhcp_option_encap"} ne "") {
        my $encap = $in{"new_dhcp_option_encap"};
        if ( $encap !~ /^encap:/ ) {
            $encap = "encap:" . $encap;
        }
        $val .= (($val) ? "," : "") . $encap;
    }
    if ($in{"new_dhcp_option_vi-encap"} ne "") {
        my $viencap = $in{"new_dhcp_option_vi-encap"};
        if ( $viencap !~ /^encap:/ ) {
            $viencap = "vi-encap:" . $viencap;
        }
        $val .= (($val) ? "," : "") . $viencap;
    }
    if ($in{"new_dhcp_option_vendor"} ne "") {
        my $vendor = $in{"new_dhcp_option_vendor"};
        if ( $vendor !~ /^vendor:/ ) {
            $vendor = "vendor:" . $vendor;
        }
        $val .= (($val) ? "," : "") . $vendor;
    }
    $val .= $in{"new_dhcp_option_dhcp_option"};
    if ($in{"new_dhcp_option_value"} ne "") {
        $val .= "," . $in{"new_dhcp_option_value"};
    }
    if ($in{"new_dhcp_option_forced"} == 1) {
        &add_to_list( "dhcp-option-force", $val );
    }
    else {
        &add_to_list( "dhcp-option", $val );
    }
}
elsif ($in{"dhcp_option_idx"} ne "" && $in{"dhcp_option_option"} ne "") {
    my $item = $dnsmconfig{"dhcp-option"}[$in{"dhcp_option_idx"}];
    my $file_arr = &read_file_lines($item->{"file"});
    my $val = "";
    my $line = "dhcp-option=";
    if ($in{"dhcp_option_forced"} == 1) {
        $line = "dhcp-option-force=";
    }
    if ($in{"dhcp_option_tag"} ne "") {
        my $tag = $in{"dhcp_option_tag"};
        if ( $tag !~ /^tag:/ ) {
            $tag = "tag:" . $tag;
        }
        $val .= $tag;
    }
    if ($in{"dhcp_option_encap"} ne "") {
        my $encap = $in{"dhcp_option_encap"};
        if ( $encap !~ /^encap:/ ) {
            $encap = "encap:" . $encap;
        }
        $val .= (($val) ? "," : "") . $encap;
    }
    if ($in{"dhcp_option_vi-encap"} ne "") {
        my $viencap = $in{"dhcp_option_vi-encap"};
        if ( $viencap !~ /^vi-encap:/ ) {
            $viencap = "vi-encap:" . $viencap;
        }
        $val .= (($val) ? "," : "") . $viencap;
    }
    if ($in{"dhcp_option_vendor"} ne "") {
        my $vendor = $in{"dhcp_option_vendor"};
        if ( $vendor !~ /^vendor:/ ) {
            $vendor = "vendor:" . $vendor;
        }
        $val .= (($val) ? "," : "") . $vendor;
    }
    $val .= (($val) ? "," : "") . $in{"dhcp_option_option"};
    if ($in{"dhcp_option_value"} ne "") {
        $val .= "," . $in{"dhcp_option_value"};
    }
    &update($item->{"line"}, $line . $val, \@$file_arr, 0);
    &flush_file_lines();
}
else {
    my @sel = split(/\0/, $in{'sel'});
    @sel || &error($text{'selected_none'});
    
    &do_selected_action( [ "dhcp_option" ], \@sel, \%$dnsmconfig );
}

#
# re-load client options page
&redirect( $returnto );

# 
# sub-routines
#
### END of dhcp_client_options.cgi ###.
