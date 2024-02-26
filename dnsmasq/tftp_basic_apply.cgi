#!/usr/bin/perl
#
#    DNSMasq Webmin Module - tftp_basic_apply.cgi; update misc TFTP/Bootp info     
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

my $returnto = $in{"returnto"} || "tftp_basic.cgi";
my $returnlabel = $in{"returnlabel"} || $dnsmasq::text{"index_tftp_settings_basic"};

my $result = "";
my @sel = split(/\0/, $in{'sel'});

my @tftp_bools = ();
my @tftp_singles = ();
foreach my $configfield ( @conftftp ) {
    next if ( grep { /^$configfield$/ } ( @confarrs ) );
    next if ( %dnsmconfigvals{"$configfield"}->{"mult"} ne "" );
    next if ( %dnsmconfigvals{"$configfield"}->{"page"} ne "1" );
    if ( grep { /^$configfield$/ } ( @confbools ) ) {
        push @tftp_bools, $configfield;
    }
    elsif ( grep { /^$configfield$/ } ( @confsingles ) ) {
        push @tftp_singles, $configfield;
    }
}

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

&update_booleans( \@tftp_bools, \@sel, \%dnsmconfig );

&update_simple_vals( \@tftp_singles, \@sel, \%$dnsmconfig );

#
# re-load basic page
&redirect( $returnto );

### END of tftp_basic_apply.cgi ###.
