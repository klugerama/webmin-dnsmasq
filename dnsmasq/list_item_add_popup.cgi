#!/usr/bin/perl
#
#    DNSMasq Webmin Module - list_item_add_popup.cgi; basic DNS config     
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

# require 'dnsmasq-lib.pl';
BEGIN { push(@INC, ".."); };
use WebminCore;
init_config();
our %access = &get_module_acl();

# my $config_filename = $config{config_file};
# my $config_file = &read_file_lines( $config_filename );
# my %dnsmconfig = ();

# &parse_config_file( \%dnsmconfig, \$config_file, $config_filename );

&ReadParse(undef, undef, 2);

my $context = $in{"context"};
my $title = $in{"title"};
my $formid = $in{"formid"};

# my $headstuff = $base_headstuff;
my $headstuff = "";
$headstuff .= "<script type='text/javascript'>\n";
$headstuff .= "  function save() {\n";
$headstuff .= "    let vals=[];\n";
$headstuff .= "    \$(\"#".$context."_input_form\").find(\":input\").each(function(){\n";
$headstuff .= "      let o={};\n";
$headstuff .= "      o['f']=\$(this).attr('name');\n";
$headstuff .= "      o['v']=\$(this).val();\n";
$headstuff .= "      vals.push(o);\n";
$headstuff .= "    });\n";
$headstuff .= "    top.opener.submit_new_$formid(vals);\n";
$headstuff .= "    top.close();\n";
$headstuff .= "  }\n";
$headstuff .= "</script>\n";
# &popup_header($title, $headstuff);
# header(title, image, [help], [config], [nomodule], [nowebmin], [rightside], [head-stuff], [body-stuff], [below])
&header($title, undef, undef, 0, 1, 1, undef, $headstuff);
print &ui_form_start(undef, undef, undef, "id=\"".$context."_input_form\" onSubmit=\"save(); return false;\"");
my $tddoc = 'colspan=2 style="text-align: left; padding-right: 5px; word-break: break-word; overflow-wrap: break-word;"';
my $tdlabel = 'style="min-width: 100px; width: 100px !important; text-align: right; padding-right: 5px;"';
my $tdinput = 'style="min-width: 100px; width: 100px !important; padding-left: 5px !important;"';
my @doctd = ( $tddoc );
my @tds = ( $tdlabel, $tdinput );
print &ui_columns_start( [ undef, undef ], 100);
if ($context eq "dhcp_vendorclass") {
    print &ui_columns_row( [ $text{"p_man_desc_dhcp_vendorclass"} ], \@doctd );
    print &ui_columns_row( [ $text{"dhcp_set_tag"} . "  ", &ui_textbox("new_tag", undef, 5) ], \@tds );
    print &ui_columns_row( [ $text{"vendorclass"} . "  ", &ui_textbox("new_vendorclass", undef, 10) ], \@tds );
}
elsif ($context eq "dhcp_userclass") {
    print &ui_columns_row( [ $text{"p_man_desc_dhcp_userclass"} ], \@doctd );
    print &ui_columns_row( [ $text{"dhcp_set_tag"} . "  ", &ui_textbox("new_tag", undef, 5) ], \@tds );
    print &ui_columns_row( [ $text{"userclass"} . "  ", &ui_textbox("new_userclass", undef, 10) ], \@tds );
}
elsif ($context eq "dns_servers") {
    print &ui_columns_row( [ $text{"p_man_desc_server"} ], \@doctd );
    print &ui_columns_row( [ $text{"domain"}, &ui_textbox("new_domain", undef, 10) ], \@tds );
    print &ui_columns_row( [ $text{"ip_address"}, &ui_textbox("new_ip", undef, 10) ], \@tds );
    print &ui_columns_row( [ $text{"source"}, &ui_textbox("new_source", undef, 10) ], \@tds );
}
elsif ($context eq "listen_address") {
    print &ui_columns_row( [ $text{"p_man_desc_listen_address"} ], \@doctd );
    print &ui_columns_row( [ $text{"p_label_listen_address"}, &ui_textbox("new_listen_address", undef, 10) ], \@tds );
}
elsif ($context eq "alias") {
    print &ui_columns_row( [ $text{"p_man_desc_alias"} ], \@doctd );
    print &ui_columns_row( [ $text{"from_ip"}, &ui_textbox("new_alias_from", undef, 15) ], \@tds );
    print &ui_columns_row( [ $text{"to_ip"}, &ui_textbox("new_alias_to", undef, 10) ], \@tds );
    print &ui_columns_row( [ $text{"netmask"}, &ui_textbox("new_alias_netmask", undef, 10) ], \@tds );
}
elsif ($context eq "nx") {
    print &ui_columns_row( [ $text{"p_man_desc_bogus_nxdomain"} ], \@doctd );
    print &ui_columns_row( [ $text{"ip_address"}, &ui_textbox("new_nx_ip", undef, 10) ], \@tds );
}
# elsif ($context eq "") {
#     print &ui_columns_row( [ $text{"p_man_desc_"} ], \@doctd );
#     print &ui_columns_row( [ $text{""}, &ui_textbox("new_fieldname", undef, 10) ], \@tds );
# }
my @form_buttons = ();
push( @form_buttons, &ui_submit( $text{"cancel_button"}, "cancel", undef, "style='display:inline; float:right;' onClick='top.close(); return false;'") );
push( @form_buttons, &ui_submit( $text{"save_button"}, "submit", undef, "style='display:inline !important; float:right;' onClick='\$(\"#".$context."_input_form\").submit(); return false;'" ) );
print &ui_table_end();
print &ui_form_end( \@form_buttons );
&footer();

### END of list_item_add_popup.cgi ###.
