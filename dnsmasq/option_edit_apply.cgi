#!/usr/bin/perl
#
#    DNSMasq Webmin Module - option_edit_apply.cgi; do the update      
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

require 'dnsmasq-lib.pl';

my %access=&get_module_acl;

## put in ACL checks here if needed

my $config_filename = $config{config_file};
my $config_file = &read_file_lines( $config_filename );

&parse_config_file( \%dnsmconfig, \$config_file, $config_filename );

# read posted data
&ReadParse();

# check for errors in read config
if( $dnsmconfig{"errors"} > 0 ) {
	my $line= "error.cgi?line=x&type=".$text{"p_label_dhcp_option"};
	&redirect( $line );
	exit;
}

# adjust everything to what we got
#
if ($in{"delete"}) {
    my $file_arr = &read_file_lines($dnsmconfig{"dhcp-option"}[$in{"idx"}]->{"file"});

    &update( $dnsmconfig{"dhcp-option"}[$in{"idx"}]->{"line"}, "",
        \@$file_arr, 2 );
    #
    # write file!!
    &flush_file_lines();
}
elsif ($in{"submit"}) {
    # =[tag:<tag>,[tag:<tag>,]][encap:<opt>,][vi-encap:<enterprise>,][vendor:[<vendor-class>],][<opt>|option:<opt-name>|option6:<opt>|option6:<opt-name>],[<value>[,<value>]]
    my $line;
    if ($in{"forced"} == 1) {
        $line = "dhcp-option-force=";
    }
    else {
        $line = "dhcp-option=";
    }
    my @tags = split(/\0/, $in{"tag"});
    foreach my $tag ( @tags ) {
        # print "found tag: $tag<br/>";
        $line .= "tag:$tag,";
    }
    if ($in{"encap"}) {
        $line .= "encap:" . $in{"encap"} . ",";
    }
    if ($in{"vi_encap"}) {
        $line .= "vi-encap:" . $in{"vi_encap"} . ",";
    }
    if ($in{"vendor"}) {
        $line .= "vendor:" . $in{"vendor"} . ",";
    }
    my $option;
    if ( $in{"option"} =~ /^[0-9]+$/ ) {
        $option = $in{"option"};
    }
    else {
        $option = "option:" . $in{"option"};
    }
    $line .= $option;
    if ($in{"value"}) {
        $line .= "," . $in{"value"};
    }

    my $file_arr = &read_file_lines($dnsmconfig{"dhcp-option"}[$in{"idx"}]->{"file"});

    &update( $dnsmconfig{"dhcp-option"}[$in{"idx"}]->{"line"}, $line,
        \@$file_arr, ( $in{"enabled"} == 1 ? 0 : 1 ) );
    #
    # write file!!
    &flush_file_lines();
}
#
# re-load client_options page
&redirect( "dhcp_client_options.cgi" );

# 
# sub-routines
#
### END of option_edit_apply.cgi ###.
