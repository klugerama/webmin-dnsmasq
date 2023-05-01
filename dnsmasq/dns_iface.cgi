#!/usr/bin/perl
#
#    DNSMasq Webmin Module - dns_iface.cgi; network interfaces
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

my $count=0;
print "<h2>";
print $text{"dns_iface_settings"};
print "</h2><hr/>";

print "<h3>";
print $text{"iface_listen"};
print "</h3>";
print &ui_columns_start( [ $text{"iface"}, $text{"enabled"} ], 100 );
foreach my $iface ( @{$dnsmconfig{"interface"}} ) {
    my $edit = "<a href=iface_edit.cgi?idx=$count>".$$iface{iface}."</a>";
    print &ui_columns_row( 
            [ $edit, ($$iface{used})?$text{"enabled"}:$text{"disabled"} ],
            [ "width=auto", "width=auto" ]	);
    $count++;
}
print &ui_columns_end();
print "<br><a href=add.cgi?what=interface=new&where=dns_iface.cgi>". $text{"add_"}." ".$text{"_iface"}."</a><hr>";
print "<h3>";
print $text{"xiface_listen"};
print "</h3>";
$count=0;
print &ui_columns_start( [ $text{"xiface"}, $text{"enabled"} ], 100 );
foreach my $iface ( @{$dnsmconfig{"ex-interface"}} ) {
    my $edit = "<a href=xiface_edit.cgi?idx=$count>".$$iface{iface}."</a>";
    print &ui_columns_row( [ $edit, ($$iface{used})?$text{"enabled"}:$text{"disabled"} ],
            [ "width=auto", "width=auto" ]	);
    $count++;
}
print &ui_columns_end();
print "<br><a href=add.cgi?what=except-interface=new&where=dns_iface.cgi>".
        $text{"add_"}." ".$text{"_iface"}."</a><hr>";
print "<h3>";
print $text{"listen_addr"};
print "</h3>";
$count=0;
print &ui_columns_start( [ $text{"listen_addr"}, $text{"enabled"} ], 100 );
foreach my $iface ( @{$dnsmconfig{"listen-address"}} ) {
    my $edit = "<a href=listen_edit.cgi?idx=$count>".$$iface{address}."</a>";
    print &ui_columns_row( [ $edit, ($$iface{used})?$text{"enabled"}:$text{"disabled"} ],
               [ "width=auto", "width=auto" ]	);
    $count++;
}
print &ui_columns_end();
print "<br>";
print "<br><a href=add.cgi?what=listen-address=0.0.0.0&where=dns_iface.cgi>".
        $text{"add_"}." ".$text{"_addr"}."</a><hr><br>";
print &ui_form_start( 'iface_apply.cgi', "post" );
print $text{"bind_iface"};
print &ui_yesno_radio( "bind_iface", ($dnsmconfig{"bind-interfaces"}->{used})?1:0 );
print "<br>".&ui_submit( $text{"save_button"} );
print &ui_form_end();
ui_print_footer("index.cgi?mode=dns", $text{"index_dns_settings"});

### END of dns_iface.cgi ###.
