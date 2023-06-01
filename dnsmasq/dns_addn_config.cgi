#!/usr/bin/perl
#
#    DNSMasq Webmin Module - dns_addn_config.cgi; basic DNS config     
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
my %dnsmconfig = ();

&parse_config_file( \%dnsmconfig, \$config_file, $config_filename );

&header($text{"index_title"}, "", "intro", 1, 0, 0, &restart_button());

my $count;
$count=0;
print &ui_form_start( 'dns_addn_config_apply.cgi', "post" );
@list_link_buttons = &list_links( "sel", 0, "dns_addn_config_apply.cgi", "conf-file=new", "dns_addn_config.cgi", &text("add_", $text{"p_label_conf_file"}) );
print &ui_links_row(\@list_link_buttons);
print &ui_columns_start( [ 
    # "line", 
    "",
    $text{"enabled"}, 
    $text{"p_label_conf_file"}, 
    # "full" 
], 100, undef, undef, &ui_columns_header( [ $text{"p_desc_conf_file"} ], [ 'class="table-title" colspan=3' ] ), 1 );

foreach my $conffile ( @{$dnsmconfig{"conf-file"}} ) {
    local @cols;
    my $edit = "<a href=host_edit.cgi?idx=$count>".$conffile->{"val"}."</a>";
    push ( @cols, &ui_checkbox("enabled", "1", "", $conffile->{"used"}?1:0, undef, 1) );
    push ( @cols, $edit );
    print &ui_checked_columns_row( \@cols, undef, "sel", $count );
    $count++;

}
print &ui_columns_end();
print &ui_links_row(\@list_link_buttons);
print "<p>" . $text{"with_selected"} . "</p>";
print &ui_submit($text{"enable_sel"}, "enable_sel_conf_file");
print &ui_submit($text{"disable_sel"}, "disable_sel_conf_file");
print &ui_submit($text{"delete_sel"}, "delete_sel_conf_file");
print &ui_form_end( );
print &ui_hr();

$count=0;
print &ui_form_start( 'dns_addn_config_apply.cgi', "post" );
@list_link_buttons = &list_links( "sel", 1, "dns_addn_config_apply.cgi", "conf-dir=new", "dns_addn_config.cgi", &text("add_", $text{"p_label_conf_dir"}) );
print &ui_links_row(\@list_link_buttons);
print &ui_columns_start( [ 
    # "line", 
    # $text{""},
    "",
    $text{"enabled"},
    $text{"p_label_conf_dir"},
    $text{"p_label_conf_dir_filter"},
    $text{"p_label_conf_dir_exceptions"},
    # "full" 
], 100, undef, undef, &ui_columns_header( [ $text{"p_desc_conf_dir"} ], [ 'class="table-title" colspan=5' ] ), 1 );

foreach my $confdir ( @{$dnsmconfig{"conf-dir"}} ) {
    local @cols;
    my $edit = "<a href=host_edit.cgi?idx=$count>".$confdir->{"val"}->{"dirname"}."</a>";
    push ( @cols, &ui_checkbox("enabled", "1", "", $confdir->{"used"}?1:0, undef, 1) );
    push ( @cols, $edit );
    push ( @cols, $confdir->{"val"}->{"filter"} );
    push ( @cols, $confdir->{"val"}->{"exceptions"} );
    print &ui_checked_columns_row( \@cols, undef, "sel", $count );
    $count++;

}
print &ui_columns_end();
print &ui_links_row(\@list_link_buttons);
print "<p>" . $text{"with_selected"} . "</p>";
print &ui_submit($text{"enable_sel"}, "enable_sel_conf_dir");
print &ui_submit($text{"disable_sel"}, "disable_sel_conf_dir");
print &ui_submit($text{"delete_sel"}, "delete_sel_conf_dir");
print &ui_form_end( );

ui_print_footer("index.cgi?mode=dns", $text{"index_dns_settings"});

### END of dns_addn_config.cgi ###.
