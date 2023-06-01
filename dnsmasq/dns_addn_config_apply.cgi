#!/usr/bin/perl
#
#    DNSMasq Webmin Module - # TODO dns_addn_config_apply.cgi; update basic DNS info     
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

do '../web-lib.pl';
do '../ui-lib.pl';
do 'dnsmasq-lib.pl';

my %access=&get_module_acl;

## put in ACL checks here if needed

my $config_filename = $config{config_file};
my $config_file = &read_file_lines( $config_filename );
# my %dnsmconfig = ();

&parse_config_file( \%dnsmconfig, \$config_file, $config_filename );
# read posted data
&ReadParse();

my $returnto = $in{"returnto"} || "dhcp_addn_config.cgi";
my $returnlabel = $in{"returnlabel"} || $text{"index_dhcp_settings_basic"};
# check for errors in read config
if( $dnsmconfig{"errors"} > 0 ) {
    my $line = "error.cgi?line=xx&type=" . &urlize($text{"err_configbad"});
    &redirect( $line );
    exit;
}
# check user input for obvious errors
if( $in{"domain"} !~ /^$FILE$/ ) {
    my $line = "error.cgi?line=".$text{"p_label_domain"};
    $line .= "&type=" . &urlize($text{"err_domainbad"});
    &redirect( $line );
    exit;
}
if( ($in{"addn_hosts"}) && ($in{"addn_hostsval"} !~ /^$FILE$/) ) {
    my $line = "error.cgi?line=".$text{"p_label_addn_hosts"};
    $line .= "&type=" . &urlize($text{"err_filebad"});
    &redirect( $line );
    exit;
}
if( ($in{"cache_size"}) && ($in{"cache_sizeval"} !~ /^$NUMBER/) ) {
    my $line = "error.cgi?line=".$text{"p_label_cache_size"};
    $line .= "&type=" . &urlize($text{"err_numbbad"});
    &redirect( $line );
    exit;
}
if( ($in{"local_ttl"}) && ($in{"local_ttlval"} !~ /^$NUMBER/) ) {
    my $line = "error.cgi?line=".$text{"p_label_local_ttl"};
    $line .= "&type=" . &urlize($text{"err_numbbad"});
    &redirect( $line );
    exit;
}
# adjust everything to what we got

my $result = "";
my @sel = split(/\0/, $in{'sel'});


$action = $in{"enable_sel_conf_file"} ? "enable" : $in{"disable_sel_conf_file"} ? "disable" : $in{"delete_sel_conf_file"} ? "delete" : "";
if ($action ne "") {
    @sel || &error($text{'selected_none'});
    &update_selected("conf-file", $action, \@sel, \%$dnsmconfig);
}
else {
    $action = $in{"enable_sel_conf_dir"} ? "enable" : $in{"disable_sel_conf_dir"} ? "disable" : $in{"delete_sel_conf_dir"} ? "delete" : "";
    if ($action ne "") {
        @sel || &error($text{'selected_none'});
        &update_selected("conf-dir", $action, \@sel, \%$dnsmconfig);
    }
}
#
# re-load additional config files page
&redirect( $returnto );

# 
# sub-routines
#
### END of dns_apply.cgi ###.
