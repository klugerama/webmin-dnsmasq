#!/usr/bin/perl
#
#    DNSMasq Webmin Module - # TODO tftp_bootp.cgi; TFTP/Bootp config
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

&parse_config_file( \%dnsmconfig, \$config_file, $config_filename );

&header($text{"index_title"}, "", "intro", 1, 0, 0, &restart_button(), undef, undef, $text{"index_tftp_boot_pxe_settings"});

my $apply_cgi = "tftp_bootp_apply.cgi";

# sub show_bootp_dynamic {
#     my $formid = "bootp_dynamic_form";
#     my $internalfield = "bootp_dynamic";
#     my $configfield = &internal_to_config($internalfield);
#     my @newfields = ( "val" );
#     my @editfields = ( "idx", @newfields );
#     my @list_link_buttons = &list_links( "sel", 0 );
#     my ($button, $hidden_add_input_fields) = &add_item_button(&text("add_", $text{"_networkid"}), $internalfield, $text{"p_desc_$internalfield"}, 700, 505, $formid, \@newfields );
#     push(@list_link_buttons, $button);

#     my $count=0;
#     print &ui_form_start( $apply_cgi, "post", undef, "id='$formid'" );
#     print &ui_links_row(\@list_link_buttons);
#     my @edit_link = ( "" );
#     my $w = 700;
#     my $h = 505;
#     my $hidden_edit_input_fields;
#     my @tds = ( $td_left, $td_left, $td_left );
#     print &ui_columns_start( [
#         "",
#         $text{"enabled"},
#         $text{"p_label_val_networkids"},
#         ], 100, undef, undef, &ui_columns_header( [ &show_title_with_help($internalfield, $configfield) ], [ 'class="table-title" colspan=3' ] ), 1 );
#     foreach my $item ( @{$dnsmconfig{$configfield}} ) {
#         local %val = %{ $item->{"val"} };
#         local @cols;
#         ($edit_link[0], $hidden_edit_input_fields) = &edit_item_link($val, $internalfield, $text{"p_desc_$internalfield"}, $count, $formid, $w, $h, \@editfields);
#         push ( @cols, &ui_checkbox("enabled", "1", "", $item->{"used"}?1:0, undef, 1) );
#         push ( @cols, $edit_link[0] );
#         # print &ui_checked_columns_row( \@cols, \@tds, "sel", $count );
#         # print &ui_clickable_checked_columns_row( \@cols, \@tds, "sel", $count );
#         print &ui_clickable_checked_columns_row( \@cols, \@tds, "sel", $count );
#         $count++;
#     }
#     print &ui_columns_end();
#     print &ui_links_row(\@list_link_buttons);
#     print "<p>" . $text{"with_selected"} . "</p>";
#     print &ui_submit($text{"enable_sel"}, "enable_sel_$internalfield");
#     print &ui_submit($text{"disable_sel"}, "disable_sel_$internalfield");
#     print &ui_submit($text{"delete_sel"}, "delete_sel_$internalfield");
#     print $hidden_add_input_fields;
#     print $hidden_edit_input_fields;
#     print &ui_form_end();
# }

my @page_fields = ();
foreach my $configfield ( @conft_b_p ) {
    next if ( %dnsmconfigvals{"$configfield"}->{"page"} ne "2" );
    push( @page_fields, $configfield );
}

&show_basic_fields( \%dnsmconfig, "tftp_bootp", \@page_fields, $apply_cgi, $text{"index_tftp_boot_pxe_settings"} );

&show_other_fields( \%dnsmconfig, "tftp_bootp", \@page_fields, $apply_cgi, " " );

print &ui_hr();

# &show_bootp_dynamic();
&show_field_table("bootp_dynamic", $apply_cgi, $text{"_networkid"}, \%dnsmconfig);

print &add_js();

&ui_print_footer("index.cgi?mode=tftp", $text{"index_tftp_settings"}, "index.cgi?mode=dns", $text{"index_dns_settings"});

### END of tftp_bootp.cgi ###.
