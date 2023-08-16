#!/usr/bin/perl
#
#    DNSMasq Webmin Module - dhcp_domain_name.cgi; DHCP domain name config     
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

require "dnsmasq-lib.pl";

my %access=&get_module_acl;

## put in ACL checks here if needed

my $config_filename = $config{config_file};
my $config_file = &read_file_lines( $config_filename );

&parse_config_file( \%dnsmconfig, \$config_file, $config_filename );

&ReadParse();

&header( $text{"index_title"}, "", "intro", 1, 0, 0, &restart_button(), undef, undef, $text{"index_dhcp_domain_name"} );

my $returnto = $in{"returnto"} || "dhcp_domain_name.cgi";
my $returnlabel = $in{"returnlabel"} || $text{"index_dhcp_domain_name"};
my $apply_cgi = "dhcp_domain_name_apply.cgi";

# sub show_domain {
#     my @tds = ( $td_left, $td_left, $td_left, $td_left, $td_left );

#     my @edit_link = ( "", "", "" );
#     my $hidden_edit_input_fields;
#     my $edit_script;
#     my $formid = "domain_form";
#     my $internalfield = "domain";
#     my $configfield = &internal_to_config($internalfield);
#     my @newfields = ( "name", "subnet", "range" );
#     my @editfields = ( "idx", @newfields );
#     my $w = 500;
#     my $h = 375;
#     my $count=0;
#     # my @list_link_buttons = &list_links( "sel", 0, "dhcp_domain_name_apply.cgi", "domain=new", "dhcp_domain_name.cgi", &text("add_", $text{"_domain"}) );
#     my @list_link_buttons = &list_links( "sel", 0 );
#     my ($add_new_button, $hidden_add_input_fields) = &add_item_button(&text("add_", $text{"_domain"}), $internalfield, $text{"p_label_domain"}, $w, $h, $formid, \@newfields );
#     push(@list_link_buttons, $add_new_button);

#     print &ui_form_start( 'dhcp_domain_name_apply.cgi', "post" );
#     print &ui_links_row(\@list_link_buttons);
#     print $hidden_add_input_fields;
#     print &ui_columns_start( [ 
#         # "line", 
#         # $text{""}, 
#         "",
#         $text{"enabled"}, 
#         $text{"domain_name"}, 
#         $text{"subnet"}, 
#         $text{"range"}, 
#         # "full" 
#     ], 100, undef, undef, &ui_columns_header( [ &show_title_with_help($internalfield, $configfield) ], [ 'class="table-title" colspan=5' ] ), 1 );

#     foreach my $domain ( @{$dnsmconfig{"domain"}} ) {
#         local %val = %{ $domain->{"val"} };
#         local @cols;
#         # my $edit = "<a href=dhcp_domain_edit.cgi?idx=$count>".$domain->{"val"}->{"domain"}."</a>";
#         push ( @cols, &ui_checkbox("enabled", "1", "", $domain->{"used"}?1:0, undef, 1) );
#         ($edit_link[0], $hidden_edit_input_fields) = &edit_item_link($val{"domain"}, $internalfield, $text{"p_label_domain"}, $count, $formid, $w, $h, \@editfields);
#         ($edit_link[1]) = &edit_item_link($val{"subnet"}, $internalfield, $text{"p_label_domain"}, $count, $formid, $w, $h, \@editfields);
#         ($edit_link[2]) = &edit_item_link($val{"range"}, $internalfield, $text{"p_label_domain"}, $count, $formid, $w, $h, \@editfields);
#         # push ( @cols, $edit );
#         # push ( @cols, $domain->{"val"}->{"subnet"} );
#         # push ( @cols, $domain->{"val"}->{"range"} );
#         push ( @cols, $edit_link[0] );
#         push ( @cols, $edit_link[1] );
#         push ( @cols, $edit_link[2] );
#         print &ui_checked_columns_row( \@cols, \@tds, "sel", $count );
#         $count++;

#     }
#     print &ui_columns_end();
#     print &ui_links_row(\@list_link_buttons);
#     print "<p>" . $text{"with_selected"} . "</p>";
#     print &ui_submit($text{"enable_sel"}, "enable_sel_domain");
#     print &ui_submit($text{"disable_sel"}, "disable_sel_domain");
#     print &ui_submit($text{"delete_sel"}, "delete_sel_domain");
#     print $hidden_edit_input_fields;
#     print &ui_form_end( );
# }

# &show_domain();
&show_field_table("domain", $apply_cgi, $text{"_domain"}, \%dnsmconfig, 1);

print &add_js();

&ui_print_footer("index.cgi?mode=dhcp", $text{"index_dhcp_settings"}, "index.cgi?mode=dns", $text{"index_dns_settings"});

### END of dhcp_domain_name.cgi ###.
