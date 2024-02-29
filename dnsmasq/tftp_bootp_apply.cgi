#!/usr/bin/perl
#
#    DNSMasq Webmin Module - tftp_bootp_apply.cgi; update misc TFTP/Bootp info     
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

## put in ACL checks here if needed

my $config_filename = $config{config_file};
my $config_file = &read_file_lines( $config_filename );

&parse_config_file( \%dnsmconfig, \$config_file, $config_filename );
# read posted data
&ReadParse();

my $returnto = $in{"returnto"} || "tftp_bootp.cgi";
my $returnlabel = $in{"returnlabel"} || $dnsmasq::text{"index_tftp_bootp_pxe_settings"};

my @sel = split(/\0/, $in{'sel'});

my @tftp_bools = ();
my @tftp_singles = ();
foreach my $configfield ( @conftftp ) {
    next if ( grep { /^$configfield$/ } ( @confarrs ) );
    next if ( %dnsmconfigvals{"$configfield"}->{"mult"} ne "" );
    next if ( %dnsmconfigvals{"$configfield"}->{"page"} ne "2" );
    if ( grep { /^$configfield$/ } ( @confbools ) ) {
        push @tftp_bools, $configfield;
    }
    elsif ( grep { /^$configfield$/ } ( @confsingles ) ) {
        push @tftp_singles, $configfield;
    }
}

# check for input data errors

# @sel || &error($dnsmasq::text{'selected_none'});

# check user input for obvious errors
foreach my $configfield ( @tftp_singles ) {
    my $item = $dnsmconfig{"$configfield"};
    my $internalfield = &config_to_internal($configfield);
    if ( grep { /^$configfield$/ } ( @sel )) {
        if ( ! $item->{"val_optional"} && $in{$internalfield . "val"} eq "" ) {
            &send_to_error( $configfield, $dnsmasq::text{"err_valreq"}, $returnto, $returnlabel );
        }
    }
    if ( grep { /^$configfield$/ } ( @sel )) {
        if ( $in{$internalfield . "val"} ne "" ) {
            my $item_template = %dnsmconfigvals{"$configfield"};
            if ( $item_template->{"valtype"} eq "int" && ($in{$internalfield . "val"} !~ /^$NUMBER$/) ) {
                &send_to_error( $configfield, $dnsmasq::text{"err_numbad"}, $returnto, $returnlabel );
            }
            elsif ( $item_template->{"valtype"} eq "file" && ($in{$internalfield . "val"} !~ /^$FILE$/) ) {
                &send_to_error( $configfield, $dnsmasq::text{"err_filebad"}, $returnto, $returnlabel );
            }
            elsif ( $item_template->{"valtype"} eq "path" && ($in{$internalfield . "val"} !~ /^$FILE$/) ) {
                &send_to_error( $configfield, $dnsmasq::text{"err_pathbad"}, $returnto, $returnlabel );
            }
            elsif ( $item_template->{"valtype"} eq "dir" && ($in{$internalfield . "val"} !~ /^$FILE$/) ) {
                &send_to_error( $configfield, $dnsmasq::text{"err_pathbad"}, $returnto, $returnlabel );
            }
        }
    }
}
# adjust everything to what we got

if ($in{"submit"}) {
    &update_booleans( \@tftp_bools, \@sel, \%dnsmconfig );

    &update_simple_vals( \@tftp_singles, \@sel, \%$dnsmconfig );

    if ($in{"dhcp_boot_def"} == 1) {
        my $item = $dnsmconfig{"dhcp-boot"};
        &save_update($item->{"file"}, $item->{"lineno"}, undef, 1);
    }
    elsif ($in{"dhcp_boot_filename"}) { # =[tag:<tag>,]<filename>,[<servername>[,<server address>|<tftp_servername>]]
        # "tag", "filename", "host", "address"
        my $item = $dnsmconfig{"dhcp-boot"};
        my $val = "dhcp-boot=";
        if ($in{"dhcp_boot_tag"}) {
            $val .= $in{"dhcp_boot_tag"} . ",";
        }
        $val .= $in{"dhcp_boot_filename"};
        if ($in{"dhcp_boot_host"}) {
            $val .= "," . $in{"dhcp_boot_host"};
            if ($in{"dhcp_boot_address"}) {
                $val .= "," . $in{"dhcp_boot_address"};
            }
        }
        &save_update($item->{"file"}, $item->{"lineno"}, $val);
    }
    if ($in{"pxe_service_def"} == 1) {
        my $item = $dnsmconfig{"pxe-service"};
        &save_update($item->{"file"}, $item->{"lineno"}, undef, 1);
    }
    elsif ($in{"pxe_service_csa"}) { # =[tag:<tag>,]<CSA>,<menu text>[,<basename>|<bootservicetype>][,<server address>|<server_name>]
        # "tag", "csa", "menutext", "basename", "server"
        my $item = $dnsmconfig{"pxe-service"};
        my $val = "pxe-service=";
        if ($in{"pxe_service_tag"}) {
            $val .= $in{"pxe_service_tag"} . ",";
        }
        $val .= $in{"pxe_service_csa"} . "," . $in{"pxe_service_menutext"};
        if ($in{"pxe_service_basename"}) {
            $val .= "," . $in{"pxe_service_basename"};
        }
        if ($in{"pxe_service_server"}) {
            $val .= "," . $in{"pxe_service_server"};
        }
        &save_update($item->{"file"}, $item->{"lineno"}, $val);
    }
    if ($in{"pxe_prompt_def"} == 1) {
        my $item = $dnsmconfig{"pxe-prompt"};
        &save_update($item->{"file"}, $item->{"lineno"}, undef, 1);
    }
    elsif ($in{"pxe_prompt_prompt"}) { # =[tag:<tag>,]<prompt>[,<timeout>]
        # "tag", "prompt", "timeout"
        my $item = $dnsmconfig{"pxe-prompt"};
        my $val = "pxe-prompt=";
        if ($in{"pxe_prompt_tag"}) {
            $val .= $in{"pxe_prompt_tag"} . ",";
        }
        $val .= $in{"pxe_prompt_prompt"};
        if ($in{"pxe_prompt_timeout"}) {
            $val .= "," . $in{"pxe_prompt_timeout"};
        }
        &save_update($item->{"file"}, $item->{"lineno"}, $val);
    }
}
elsif ($in{"new_bootp_dynamic_val"} ne "") {
    my $newval = "";
    $newval .= $in{"new_bootp_dynamic_val"};
    &add_to_list("bootp-dynamic", $newval);
}
elsif ($in{"bootp_dynamic_idx"} ne "") {
    my $item = $dnsmconfig{"bootp-dynamic"}[$in{"bootp_dynamic_idx"}];
    my $newval = "bootp-dynamic=";
    $newval .= $in{"bootp_dynamic_val"};
    &save_update($item->{"file"}, $item->{"lineno"}, $newval);
}
else {
    &do_selected_action( [ "bootp_dynamic" ], \@sel, \%$dnsmconfig );
}
#
# re-load basic page
&redirect( $returnto );

### END of tftp_bootp_apply.cgi ###.
