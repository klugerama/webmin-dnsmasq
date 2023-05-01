#!/usr/bin/perl
#
#    DNSMasq Webmin Module - dhcp.cgi; DHCP ranges config
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
$width="width=autoA";
print "<h2>".$text{"dhcp_range"}."</h2>";
print &ui_links_row(\@links);
print &ui_columns_start( [ 
    # $text{"net_id"},
    $text{"from_ip"},
    $text{"to_ip"},
    $text{"mask"},
    $text{"leasetime"},
    $text{"dhcp_res_tag"}, 
    "Flags",
    $text{"enabled"}	], 100 );
foreach my $range ( @{$dnsmconfig{"dhcp-range"}} ) {
    my $edit = "<a href=range_edit.cgi?idx=$count>".$range->{"val"}->{"start"}."</a>";
    print &ui_checked_columns_row( [
            # $$range{id},
            $edit,
            $range->{"val"}->{"end"},
            # $$range,
            $range->{"val"}->{"mask"},
            $range->{"val"}->{"leasetime"},
            $range->{"val"}->{"tagname"},
            $range->{"val"}->{"ra-only"}."-".$range->{"val"}->{"ra-names"}."-".$range->{"val"}->{"ra-stateless"}."-".$range->{"val"}->{"slaac"},
            # ($range->{"used"}) ?
            #     $text{"enabled"} : $text{"disabled"}
            ],
            [ $width, $width, $width, $width, $width, $width ],
            "e", $count, $range->{"used"}?1:0 );
    $count++;
}
print &ui_columns_end();
print "<br><a href=add.cgi?what=dhcp-range=0.0.0.0,0.0.0.0&where=dhcp.cgi>".
        $text{"add_"}." ".$text{"_range"}."</a><br><hr><br>";
print &ui_links_row(\@links);
# print "<br><br>".&ui_submit( $text{"save_button"} );
print &ui_submit($text{"enable_sel"}, "enable_sel");
print &ui_submit($text{"disable_sel"}, "disable_sel");
print &ui_submit($text{"delete_sel"}, "delete_sel");
print &ui_form_end( );
ui_print_footer("index.cgi?mode=dhcp", $text{"dhcp_settings"}, "index.cgi?mode=dns", $text{"index_dns_settings"});

### END of dhcp_ranges.cgi ###.
