#!/usr/bin/perl
#
#    DNSMasq Webmin Module - dhcp.cgi; DHCP User class config
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

my $count;
my $width;
$count=0;
$width="width=33%";
print "<h2>".$text{dhcp-userclass}."</h2>";
print &ui_columns_start( [ $text{"class"},
                $text{"user"}, $text{"enabled"} ], 100 );
foreach my $range ( @{$dnsmconfig{"user-class"}} ) {
    my $edit = "<a href=user_edit.cgi?idx=$count>".$$range{class}."</a>";
    print &ui_columns_row( [
            $edit, $$range{user},
            ($$range{used}) ?
                $text{"enabled"} : $text{"disabled"} ],
            [ $width, $width, $width ] );
    $count++;
}
print &ui_columns_end();
print "<br><a href=add.cgi?what=dhcp-userclass=new&where=dhcp.cgi>".
        $text{"add_"}." ".$text{"_user"}."</a><br><hr><br>";
print "<br><br>".&ui_submit( $text{"save_button"} );
print &ui_form_end( );
ui_print_footer("index.cgi?mode=dhcp", $text{"dhcp_settings"}, "index.cgi?mode=dns", $text{"index_dns_settings"});

### END of dhcp_userclass.cgi ###.