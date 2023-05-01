#!/usr/bin/perl
#
#    DNSMasq Webmin Module - dns_servers.cgi; Upstream Servers config
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
&header( "DNSMasq settings", "" );
&parse_config_file( \%dnsmconfig, \$config_file, \$config_filename );
print "<h2>";
print $text{"dns_servers"};
print "</h2>";
print &ui_form_start( "srv_apply.cgi", "post" );
print "<h3>".$text{"dynamic"}."</h3>";
print $text{"resolv"};
print &ui_yesno_radio( "resolv", ($dnsmconfig{"no-resolv"}->{used}?0:1) );
print "<br>".$text{"resolv_file_explicit"};
print &ui_yesno_radio( "resolv_std", ($dnsmconfig{"resolv-file"}->{used}?1:0) );
print "<br>".$text{"resolv_file"};
print &ui_textbox( "resolv_file", $dnsmconfig{"resolv-file"}->{filename}, 50 );
print "<br><br>".$text{"poll"}."<br>";
print &ui_yesno_radio( "poll", ($dnsmconfig{"no-poll"}->{used}?0:1) );
print "<br><br>".$text{"strict_order"};
print &ui_yesno_radio( "strict", ($dnsmconfig{"strict-order"}->{used}?1:0) );
print "<br><br><h3>".$text{"in_file"}."</h3>";
print &ui_columns_start( [ $text{"domain"}, $text{"address"}, $text{"enabled"}, "" ], 100 );
foreach my $server ( @{$dnsmconfig{"servers"}} ) {
    local ( $mover, $edit );
    if( $count == @{$dnsmconfig{"servers"}}-1 ) {
        $mover="<img src=images/gap.gif>";
    }
    else
    {	
        $mover = "<a href='srv_move.cgi?idx=$count&".
        "dir=down'><img src=".
        "images/down.gif border=0></a>";
    }
        if( $count == 0 ) {
        $mover.="<img src=images/gap.gif>";
    }
    else
    {
        $mover .= "<a href='srv_move.cgi?idx=$count&".
        "dir=up'><img src=images/up.gif ".
        "border=0></a>";
    }
    $edit = "<a href=srv_edit.cgi?idx=$count>".$$server{address}."</a>";
    print &ui_columns_row( [ $$server{domain}, $edit,
        ($$server{used})?$text{"enabled"}:$text{"disabled"}, $mover ],
               [ "width=30%", "width=30%", "width=30%", "width=10%" ]	);
    $count++;
}
print &ui_columns_end();
print "<br><a href=add.cgi?what=server=0.0.0.0&where=dns_servers.cgi>".
        $text{"add_"}." ".$text{"_dns_serv"}."</a><hr>";
print "<br>" . &ui_submit( $text{"save_button"} );
print &ui_form_end();
ui_print_footer("index.cgi?mode=dns", $text{"index_dns_settings"});

### END of dns_servers.cgi ###.
