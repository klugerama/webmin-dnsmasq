#!/usr/bin/perl
#
#    DNSMasq Webmin Module - dns_basic.cgi; basic DNS config     
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

&header($text{"index_title"}, "", "intro", 1, 0, 0, &restart_button());

my $config_filename = $config{config_file};
my $config_file = &read_file_lines( $config_filename );

&parse_config_file( \%dnsmconfig, \$config_file, \$config_filename );

print &ui_form_start( 'basic_apply.cgi', "post" );

my @radiodefaultno = ( 0, "Default" );
my @radioyes = ( 1, "Yes" );
my @defaultoryes = ( \@radiodefaultno, \@radioyes );
# my @radiodefaultyes = ( 1, "Default" );
# my @radiono = ( 0, "No" );
# my @defaultorno = ( \@radiodefaultyes, \@radiono );
my @radioval = ( 1, " " );
my @defaultorval = ( \@radiodefaultno, \@radioval );
my $count;
my $subcount;
my $desccolumnprops;
my $valcolumnprops;
$desccolumnprops='width="auto" style="text-align:right;"';
# $desccolumnprops='class="col_label vertical-align-top"';
$valcolumnprops='width="auto" style="text-align:left;"';
# $valcolumnprops='class="col_value"';

# print "<h2>$text{"index_dns_settings_basic"}</h2>";
$count=0;
print &ui_table_start( $text{"index_dns_settings_basic"}, "", 4 );
print &ui_table_row($text{"domain_needed"}, &ui_radio( "domain_needed", ($dnsmconfig{"domain-needed"}->{"used"})?1:0, \@defaultoryes ));
$count++;
print &ui_table_row($text{"expand_hosts"}, &ui_radio( "expand_hosts", ($dnsmconfig{"expand-hosts"}->{"used"})?1:0, \@defaultoryes ));
$count++;
print &ui_table_row($text{"dns_port"}, &ui_radio( "dns_port", ($dnsmconfig{"port"}->{"used"})?1:0, \@defaultorval ) . &ui_textbox( "dns_portval", $dnsmconfig{"port"}->{"val"}, 5 ));
$count++;
print &ui_table_row($text{"bogus_priv"}, &ui_radio( "bogus_priv", ($dnsmconfig{"bogus-priv"}->{"used"})?1:0, \@defaultoryes ));
$count++;
print &ui_table_row($text{"filterwin2k"}, &ui_radio( "filterwin2k", ($dnsmconfig{"filterwin2k"}->{"used"})?1:0, \@defaultoryes ));
$count++;
print &ui_table_row($text{"no_read_hosts"}, &ui_radio( "no_read_hosts", ($dnsmconfig{"no-hosts"}->{"used"})?1:0, \@defaultoryes ));
$count++;
print &ui_table_row($text{"no_negcache"}, &ui_radio( "no_negcache", ($dnsmconfig{"no-negcache"}->{"used"})?1:0, \@defaultoryes ));
$count++;
print &ui_table_row($text{"cache_size"}, &ui_radio( "cache_size", ($dnsmconfig{"cache-size"}->{"used"})?1:0, \@defaultorval ) . &ui_textbox( "cache_sizeval", $dnsmconfig{"cache-size"}->{"val"}, 5 ));
$count++;
print &ui_table_row($text{"log_queries"}, &ui_radio( "log_queries", ($dnsmconfig{"log-queries"}->{"used"})?1:0, \@defaultoryes ));
$count++;
print &ui_table_row($text{"local_ttl"}, &ui_radio( "local_ttl", ($dnsmconfig{"local-ttl"}->{"used"})?1:0, \@defaultorval ) . &ui_textbox( "local_ttlval", $dnsmconfig{"local-ttl"}->{"val"}, 5 ));
$count++;
print &ui_table_end();


$subcount=0;
# print "<h2>$text{"local_domain"}</h2>";
print &ui_columns_start( [ 
    # "line", 
    # $text{""}, 
    "Domain name",
    "Subnet",
    "Range",
    $text{"enabled"}, 
    # "full" 
], 100, 0, undef, &ui_columns_header( [ $text{"local_domain"} ], [ 'class="table-title" colspan=4' ] ) );

foreach my $domain ( @{$dnsmconfig{"domain"}} ) {
    my $edit = "<a href=host_edit.cgi?idx=$subcount>".$domain->{"val"}->{"domain"}."</a>";
    my $enabled_cb = ui_checkbox("used", "1", "", $domain->{"used"});
    print &ui_columns_row( [
        # $$host{line},
        $edit,
        $domain->{"val"}->{"subnet"},
        $domain->{"val"}->{"range"},
        $enabled_cb,
        ],
        [ $valcolumnprops, $valcolumnprops, $valcolumnprops, $desccolumnprops ] );
    $subcount++;

}
print &ui_columns_end();

$subcount=0;
# print "<h2>$text{"p_desc_sh_conf_file"}</h2>";
print &ui_columns_start( [ 
    # "line", 
    # $text{""}, 
    "Filename",
    $text{"enabled"}, 
    # "full" 
], 100, 0, undef, &ui_columns_header( [ $text{"p_desc_lg_conf_file"} ], [ 'class="table-title" colspan=4' ] ) );

foreach my $conffile ( @{$dnsmconfig{"conf-file"}} ) {
    my $edit = "<a href=host_edit.cgi?idx=$subcount>".$conffile->{"val"}."</a>";
    my $enabled_cb = ui_checkbox("used", "1", "", $conffile->{"used"});
    print &ui_columns_row( [
        # $$host{line},
        $edit,
        $enabled_cb,
        ],
        [ $valcolumnprops, $desccolumnprops ] );
    $subcount++;

}
print &ui_columns_end();

$subcount=0;
# print "<h2>$text{"p_desc_sh_conf_dir"}</h2>";
print &ui_columns_start( [ 
    # "line", 
    # $text{""}, 
    $text{"p_desc_sh_conf_dir"},
    $text{"p_desc_sh_conf_dir_filter"},
    $text{"p_desc_sh_conf_dir_exceptions"},
    $text{"enabled"}, 
    # "full" 
], 100, 0, undef, &ui_columns_header( [ $text{"p_desc_lg_conf_dir"} ], [ 'class="table-title" colspan=4' ] ) );

foreach my $confdir ( @{$dnsmconfig{"conf-dir"}} ) {
    my $edit = "<a href=host_edit.cgi?idx=$subcount>".$confdir->{"val"}->{"dirname"}."</a>";
    my $enabled_cb = ui_checkbox("used", "1", "", $confdir->{"used"});
    print &ui_columns_row( [
        # $$host{line},
        $edit,
        $confdir->{"val"}->{"filter"},
        $confdir->{"val"}->{"exceptions"},
        $enabled_cb,
        ],
        [ $valcolumnprops, $valcolumnprops, $valcolumnprops, $desccolumnprops ] );
    $subcount++;

}
print &ui_columns_end();

print "<br><br>\n";
print &ui_submit( $text{"save_button"} );
print &ui_form_end( );
print "<hr>";
print "<a href=\"restart.cgi\">";
print $text{"restart"};
print "</a><br>";
ui_print_footer("index.cgi?mode=dns", $text{"index_dns_settings"});

### END of dns_basic.cgi ###.
