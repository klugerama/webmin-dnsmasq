#!/usr/bin/perl
#
#    DNSMasq Webmin Module - list_item_edit_popup.cgi; basic DNS config     
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
# BEGIN { push(@INC, ".."); };
# use WebminCore;
# init_config();
# our %access = &get_module_acl();

my $config_filename = $config{config_file};
my $config_file = &read_file_lines( $config_filename );
# my %dnsmconfig = ();

&parse_config_file( \%dnsmconfig, \$config_file, $config_filename );

&ReadParse(undef, undef, 2);

my $internalfield = $in{"internalfield"};
my $title = $in{"title"};
my $formid = $in{"formid"};
my $action = $in{"action"};
my $idx = $in{"idx"};

# my $headstuff = $base_headstuff;
my $headstuff = "<script type='text/javascript'>\n"
    . "  document.addEventListener(\"DOMContentLoaded\", function(event) { \n"
    . "    setTimeout(function() {\n"
    . "      \$( \".opener_table_cell_style_small\" ).removeClass(\"opener_table_cell_style_small\");\n"
    . "    },10);\n"
    . "  });\n"
    . "  function save() {\n"
    . "    let vals=[];\n"
    . "    \$(\"#".$internalfield."_input_form\").find(\":input\").each(function(){\n"
    . "      let o={};\n"
    . "      o['f']=\$(this).attr('name');\n"
    . "      o['v']=\$(this).val();\n"
    . "      vals.push(o);\n"
    . "    });\n"
    . "    top.opener.submit_" . ( $action eq "add" ? "new_" : "" ) . "$formid(vals);\n"
    . "    top.close();\n"
    . "  }\n"
    . "</script>\n";
# &popup_header($title, $headstuff);
# header(title, image, [help], [config], [nomodule], [nowebmin], [rightside], [head-stuff], [body-stuff], [below])
&header($title, undef, undef, 0, 1, 1, undef, $headstuff);
print &ui_form_start(undef, undef, undef, "id=\"".$internalfield."_input_form\" onSubmit=\"save(); return false;\"");
my $tddoc = 'colspan=2 style="text-align: left; padding-right: 5px; word-break: break-word; overflow-wrap: break-word;"';
my $tdlabel = 'style="min-width: 100px; width: 100px !important; text-align: right; padding-right: 5px;"';
my $tdinput = 'style="min-width: 100px; width: 100px !important; padding-left: 5px !important;"';
my @doctd = ( $tddoc );
my @tds = ( $tdlabel, $tdinput );
print &ui_columns_start( [ undef, undef ], 100);
my $item;
my %val;
my $fieldname_prefix = ( $action eq "add" ? "new_" : "" ) . $internalfield . "_";
if ($action eq "edit") {
    my $configfield = &internal_to_config("$internalfield");
    $item = $dnsmconfig{$configfield}[$idx];
    %val = %{ $item->{"val"} };
    print &ui_hidden($fieldname_prefix . "idx", $idx);
}
# my $desc = &ui_hidden_start($text{"description"} . "<img src='images/down.gif' border=0 />", "mandesc", 0, "list_item_edit_popup.cgi");
my $desc = &ui_hidden_start($text{"description_expand"}, "mandesc", 0, "list_item_edit_popup.cgi");
$desc .= $text{"p_man_desc_" . $internalfield};
$desc .= &ui_hidden_end("mandesc");
print &ui_columns_row( [ $desc ], \@doctd );

if ($internalfield eq "dhcp_vendorclass") {
    print &ui_columns_row( [ $text{"p_label_val_set_tag"} . "  ", &ui_textbox($fieldname_prefix . "tag", $val{"tag"}, 5) ], \@tds );
    print &ui_columns_row( [ $text{"vendorclass"} . "  ", &ui_textbox($fieldname_prefix . "vendorclass", $val{"vendorclass"}, 10) ], \@tds );
}
elsif ($internalfield eq "dhcp_userclass") {
    print &ui_columns_row( [ $text{"p_label_val_set_tag"} . "  ", &ui_textbox($fieldname_prefix . "tag", $val{"tag"}, 5) ], \@tds );
    print &ui_columns_row( [ $text{"userclass"} . "  ", &ui_textbox($fieldname_prefix . "userclass", $val{"userclass"}, 10) ], \@tds );
}
elsif ($internalfield eq "server") {
    print &ui_columns_row( [ $text{"domain"}, &ui_textbox($fieldname_prefix . "domain", join("/", @{$val{"domain"}}), 10) ], \@tds );
    print &ui_columns_row( [ $text{"ip_address"}, &ui_textbox($fieldname_prefix . "ip", $val{"ip"}, 10) ], \@tds );
    print &ui_columns_row( [ $text{"source"}, &ui_textbox($fieldname_prefix . "source", $val{"source"}, 10) ], \@tds );
}
elsif ($internalfield eq "rev_server") {
    print &ui_columns_row( [ $text{"domain"}, &ui_textbox($fieldname_prefix . "domain", join("/", @{$val{"domain"}}), 10) ], \@tds );
    print &ui_columns_row( [ $text{"ip_address"}, &ui_textbox($fieldname_prefix . "ip", $val{"ip"}, 10) ], \@tds );
    print &ui_columns_row( [ $text{"source"}, &ui_textbox($fieldname_prefix . "source", $val{"source"}, 10) ], \@tds );
}
elsif ($internalfield eq "listen_address") {
    print &ui_columns_row( [ $text{"p_label_listen_address"}, &ui_textbox($fieldname_prefix . "listen_address_val", $item->{"val"}, 10) ], \@tds );
}
elsif ($internalfield eq "alias") {
    print &ui_columns_row( [ $text{"from_ip"}, &ui_textbox($fieldname_prefix . "from", $val{"from"}, 15) ], \@tds );
    print &ui_columns_row( [ $text{"to_ip"}, &ui_textbox($fieldname_prefix . "to", $val{"to"}, 10) ], \@tds );
    print &ui_columns_row( [ $text{"netmask"}, &ui_textbox($fieldname_prefix . "netmask", $val{"netmask"}, 10) ], \@tds );
}
elsif ($internalfield eq "bogus_nxdomain") {
    print &ui_columns_row( [ $text{"ip_address"}, &ui_textbox($fieldname_prefix . "ip", $val{"addr"}, 10) ], \@tds );
}
elsif ($internalfield eq "address") {
    print &ui_columns_row( [ $text{"domain"}, &ui_textbox($fieldname_prefix . "domain", $val{"domain"}, 10) ], \@tds );
    print &ui_columns_row( [ $text{"ip_address"}, &ui_textbox($fieldname_prefix . "addr", $val{"addr"}, 10) ], \@tds );
}
elsif ($internalfield eq "ignore_address") {
    print &ui_columns_row( [ $text{"ip_address"}, &ui_textbox($fieldname_prefix . "ip", $val{"ip"}, 10) ], \@tds );
}
elsif ($internalfield eq "domain") {
    print &ui_columns_row( [ $text{"domain_name"}, &ui_textbox($fieldname_prefix . "domain", $val{"domain"}, 10) ], \@tds );
    print &ui_columns_row( [ $text{"subnet"}, &ui_textbox($fieldname_prefix . "subnet", $val{"subnet"}, 10) ], \@tds );
    print &ui_columns_row( [ $text{"range"}, &ui_textbox($fieldname_prefix . "range", $val{"range"}, 10) ], \@tds );
}
else {
    my $definition = %configfield_fields{$internalfield};
    foreach my $key ( @{ $definition->{"param_order"} }) {
        print &ui_columns_row( [ $text{"p_label_" . $internalfield . "_" . $key}, &ui_textbox($fieldname_prefix . $key, $val{$key}, $definition->{$key}->{"length"}) ], \@tds );
    }
}
# elsif ($internalfield eq "") {
#     print &ui_columns_row( [ $text{""}, &ui_textbox($fieldname_prefix . "fieldname", $val{""}, 10) ], \@tds );
# }
my @form_buttons = ();
push( @form_buttons, &ui_submit( $text{"cancel_button"}, "cancel", undef, "style='display:inline; float:right;' onClick='top.close(); return false;'" ) );
push( @form_buttons, &ui_submit( $text{"save_button"}, "submit", undef, "style='display:inline !important; float:right;' onClick='\$(\"#".$internalfield."_input_form\").submit(); return false;'" ) );
print &ui_table_end();
print &ui_form_end( \@form_buttons );
&footer();

### END of list_item_edit_popup.cgi ###.
