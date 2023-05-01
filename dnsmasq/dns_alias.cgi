#!/usr/bin/perl
#
#    DNSMasq Webmin Module - dns_alias.cgi; aliasing and redirection
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

print "<hr>\n";
# uses the index_title entry from ./lang/en or appropriate
print "<br>\n";
print "<h2>".$text{"alias"}."</h2>";
print "<br><br>\n";
my $count=0;
print &ui_columns_start( [ $text{"forced_domain"}, $text{"forced_ip"}, $text{"enabled"} ], 100 );
foreach my $frcd ( @{$dnsmconfig{"alias"}} ) {
    my $edit = "<a href=forced_edit.cgi?idx=$count>".$$frcd{domain}."</a>";
    print &ui_columns_row( [ $edit, $$frcd{addr}, ($$frcd{used}) ?
            $text{"enabled"} : $text{"disabled"} ],
            [ "width=auto", "width=auto", "width=auto" ] );
    $count++;
}
print &ui_columns_end();
print "<br>\n";
print "<a href=add.cgi?what=address=/new/0.0.0.0&where=dns_alias.cgi>".
    $text{"add_"}." ".$text{"_forced"}."</a>";
print "<br>\n";
print "<br><br>\n";
print "<hr>";
print "<br>\n";
print "<h2>".$text{"alias"}."</h2>";
print "<br><br>\n";
$count=0;
print &ui_columns_start( [ $text{"forced_from"}, $text{"forced_ip"},
            $text{"netmask"}, $text{"enabled"} ], 100 );
foreach my $frcd ( @{$dnsmconfig{"alias"}} ) {
    my $edit = "<a href=alias_edit.cgi?idx=$count>".$$frcd{from}."</a>";
    print &ui_columns_row( [ 
            $edit, $$frcd{to}, 
            ($$frcd{netmask_used}) ?  
                $$frcd{netmask} : "255.255.255.255",
            ($$frcd{used}) ?
                $text{"enabled"} : $text{"disabled"} ],
            [ "width=25%", "width=25%", "width=25%", "width=25%" ] );
    $count++;
}
print &ui_columns_end();
print "<br>\n";
print "<a href=add.cgi?what=alias=0.0.0.0,0.0.0.0&where=dns_alias.cgi>".
    $text{"add_"}." ".$text{"_alias"}."</a>";
print "<br>\n";
print "<hr>";
print "<br>\n";
print "<h2>".$text{"nx"}."</h2>";
print "<br><br>\n";
$count=0;
print &ui_columns_start( [ $text{"forced_from"}, $text{"enabled"} ], 100 );
foreach my $frcd ( @{$dnsmconfig{"bogus-nxdomain"}} ) {
    my $edit = "<a href=nx_edit.cgi?idx=$count>".$$frcd{addr}."</a>";
    print &ui_columns_row( [ 
            $edit, 
            ($$frcd{used}) ?
                $text{"enabled"} : $text{"disabled"} ],
            [ "width=50%", "width=50%" ] );
    $count++;
}
print &ui_columns_end();
print "<br>\n";
print "<a href=add.cgi?what=bogus-nxdomain=0.0.0.0&where=dns_alias.cgi>".
    $text{"add_"}." ".$text{"_nx"}."</a>";
print "<br>\n";
ui_print_footer("index.cgi?mode=dns", $text{"index_dns_settings"});

### END of dns_alias.cgi ###.
