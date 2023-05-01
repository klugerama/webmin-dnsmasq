#!/usr/bin/perl
#
#    DNSMasq Webmin Module - dhcp.cgi; DHCP reservations config
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

@links = ( );
push(@links, &select_all_link("e"),
            &select_invert_link("e"));

my $count;
my $width;
$count=0;
$width="width=auto";
print "<h2>".$text{"dhcp_res_title"}."</h2>";
print &ui_form_start( 'dhcp_apply.cgi', "get" );
print &ui_links_row(\@links);
print &ui_columns_start( [ 
    # "line", 
    # "",
    $text{"dhcp_res_name"}, 
    $text{"dhcp_res_ip"}, 
    $text{"dhcp_res_mac"}, 
    $text{"dhcp_res_ignore_client_id"}, 
    $text{"dhcp_res_tag"}, 
    $text{"dhcp_res_time"}, 
    # $text{"enabled"}, 
    # "full" 
], 100 );
foreach my $host ( @{$dnsmconfig{"dhcp-host"}} ) {
    if ($host->{"val"}->{"ipversion"} == 4) {
        my $edit = "<a href=host_edit.cgi?idx=$count>".$host->{"val"}->{"id"}."</a>";
        print &ui_checked_columns_row( [
            # $$host{line},
            $edit,
            $host->{"val"}->{"ip"},
            $host->{"val"}->{"infiniband"} . $host{"clientid"} . $host{"mac"},
            $host->{"val"}->{"ignore_clientid"},
            $host->{"val"}->{"tagname"},
            $host->{"val"}->{"leasetime"},
            # ($host->{"used"}) ?
            #     $text{"enabled"} : $text{"disabled"},
            # $$host{full} 
            ],
            [ $width, $width, $width, $width, $width, $width, $width, $width ],
            "e", $count, $host->{"used"}?1:0 );
    }
    $count++;
}
print &ui_columns_end();
print &ui_links_row(\@links);
print &ui_submit($text{"enable_sel"}, "enable_sel");
print &ui_submit($text{"disable_sel"}, "disable_sel");
print &ui_submit($text{"delete_sel"}, "delete_sel");
print &ui_form_end( );

$count=0;
$width="width=auto";
print "<h2>".$text{"dhcp6_res_title"}."</h2>";
print &ui_form_start( 'dhcp_apply.cgi', "get" );
print &ui_columns_start( [ 
    # "line", 
    $text{"dhcp_res_name"}, 
    $text{"dhcp_res_ip"}, 
    $text{"dhcp_res_mac"}, 
    $text{"dhcp_res_ignore_client_id"}, 
    $text{"dhcp_res_tag"}, 
    $text{"dhcp_res_time"}, 
    # $text{"enabled"}, 
    # "full" 
], 100 );
foreach my $host ( @{$dnsmconfig{"dhcp-host"}} ) {
    if ($host->{"val"}->{"ipversion"} == 6) {
        my $edit = "<a href=host_edit.cgi?idx=$count>".$host->{"val"}->{"id"}."</a>";
        print &ui_checked_columns_row( [
                # $$host{line},
                $edit,
                $host->{"val"}->{"ip"},
                $host->{"val"}->{"infiniband"} . $host->{"val"}->{"clientid"} . $host->{"val"}->{"mac"},
                $host->{"val"}->{"ignore_clientid"},
                $host->{"val"}->{"tagname"},
                $host->{"val"}->{"leasetime"},
                # ($host->{"used"}) ?
                #     $text{"enabled"} : $text{"disabled"},
                # $$host{full} 
            ],
            [ $width, $width, $width, $width, $width, $width, $width, $width ],
            "e", $count, $host->{"used"}?1:0 );
        print &ui_hidden("id_" . count . "_line", $host->{"line"});
        print &ui_hidden("id_" . count . "_file", $host->{"file"});
    }
    $count++;
}
print &ui_columns_end();
print "<br><a href=add.cgi?what=dhcp-host=new,0.0.0.0&where=dhcp.cgi>".
        $text{"add_"}." ".$text{"_host"}."</a><br><hr><br>";
# print "<br><br>".&ui_submit( $text{"save_button"} );
print &ui_submit($text{"enable_sel"}, "enable_sel");
print &ui_submit($text{"disable_sel"}, "disable_sel");
print &ui_submit($text{"delete_sel"}, "delete_sel");
print &ui_form_end( );
ui_print_footer("index.cgi?mode=dhcp", $text{"dhcp_settings"}, "index.cgi?mode=dns", $text{"index_dns_settings"});

### END of dhcp_reservations.cgi ###.
