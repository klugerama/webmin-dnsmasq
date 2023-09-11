#!/usr/bin/perl
#
#    DNSMasq Webmin Module - list_item_edit_chooser.cgi; basic DNS config     
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

my $config_filename = $config{config_file};
my $config_file = &read_file_lines( $config_filename );

&parse_config_file( \%dnsmconfig, \$config_file, $config_filename );

&ReadParse(undef, undef, 2);

our $action = $in{"action"};
our $formid = $in{"formid"};
our $idx = $in{"idx"};
my $title = $in{"title"};
$title =~ s/\+/ /g;
our $internalfield = $in{"internalfield"};
our $configfield = &internal_to_config("$internalfield");
our $tddoc = 'colspan=2 style="text-align: left; padding-right: 5px; word-break: break-word; overflow-wrap: break-word;"';
our $tdlabel = 'style="min-width: 100px; width: 100px !important; text-align: right; padding-right: 5px;"';
our $tdinput = 'style="min-width: 100px; width: 100px !important; padding-left: 5px !important;"';
our @doctd = ( $tddoc );
our @tds = ( $tdlabel, $tdinput );
our $item;
our %val;
our $fieldname_prefix = ( $action eq "add" ? "new_" : "" ) . $internalfield . "_";

sub formtable_ip4 {
    my ($fieldname_prefix) = @_;
    
    my $formtable = "";
    $formtable .= &ui_form_start(undef, undef, undef, "id=\"".$internalfield."_4_input_form\" onSubmit=\"event.preventDefault(); save".$internalfield."('".$internalfield."_4_input_form'); event.stopImmediatePropagation(); return false;\"");
    $formtable .= &ui_hidden($fieldname_prefix . "ipversion", 4);
    if ($action eq "edit") {
        $item = $dnsmconfig{$configfield}[$idx];
        %val = %{ $item->{"val"} };
        $formtable .= &ui_hidden($fieldname_prefix . "idx", $idx);
    }
    $formtable .= &ui_columns_start( [ undef, undef ], 100);
    $formtable .= &generate_param_rows(6);
    $formtable .= &ui_columns_end();
    $formtable .= "<div><span color='red'>*</span>&nbsp;<i>" . $text{"footnote_required_parameter"} . "</i></div>";
    my @form_buttons = ();
    push( @form_buttons, &ui_button( $text{"cancel_button"}, "cancel", undef, "style='height: 33px; display:inline; float:right;' data-dismiss='modal' onclick=\"\$('#list-item-edit-modal').modal('hide'); return false;\"", "fa fa-fw fa-times-circle-o", "btn btn-default ui_reset" ) );
    push( @form_buttons, &ui_submit( $text{"save_button"}, "submit_4", undef, "style='height: 33px; display:inline !important; float:right;' onclick=\"return check_".$internalfield."('".$internalfield."_4_input_form');\"" ) );
    $formtable .= &ui_form_end( \@form_buttons );
    return $formtable;
}

sub formtable_ip6 {
    my ($fieldname_prefix) = @_;
    
    my $formtable = "";
    $formtable .= &ui_form_start(undef, undef, undef, "id=\"".$internalfield."_6_input_form\" onSubmit=\"event.preventDefault(); save".$internalfield."('".$internalfield."_6_input_form'); event.stopImmediatePropagation(); return false;\"");
    $formtable .= &ui_hidden($fieldname_prefix . "ipversion", 6);
    if ($action eq "edit") {
        $item = $dnsmconfig{$configfield}[$idx];
        %val = %{ $item->{"val"} };
        $formtable .= &ui_hidden($fieldname_prefix . "idx", $idx);
    }
    $formtable .= &ui_columns_start( [ undef, undef ], 100);
    $formtable .= &generate_param_rows(4);
    $formtable .= &ui_columns_end();
    $formtable .= "<div><span color='red'>*</span>&nbsp;<i>" . $text{"footnote_required_parameter"} . "</i></div>";
    my @form_buttons = ();
    push( @form_buttons, &ui_button( $text{"cancel_button"}, "cancel", undef, "style='height: 33px; display:inline; float:right;' data-dismiss='modal' onclick=\"\$('#list-item-edit-modal').modal('hide'); return false;\"", "fa fa-fw fa-times-circle-o", "btn btn-default ui_reset" ) );
    push( @form_buttons, &ui_submit( $text{"save_button"}, "submit_6", undef, "style='height: 33px; display:inline !important; float:right;' onclick=\"return check_".$internalfield."('".$internalfield."_6_input_form');\"" ) );
    $formtable .= &ui_form_end( \@form_buttons );
    return $formtable;
}

sub generate_param_rows {
    my ($ipversionfilter) = @_;

    my $rows = "";
    my $fielddefinition = %configfield_fields{$internalfield};
    foreach my $param ( @{ $fielddefinition->{"param_order"} }) {
        my $paramdefinition = $fielddefinition->{$param};
        next if ($ipversionfilter && ($paramdefinition->{"ipversion"} eq "$ipversionfilter" || $paramdefinition->{"ipversion"} == $ipversionfilter));
        my $tmpl = $ipversionfilter == 4 && $paramdefinition->{"template6"} ? $paramdefinition->{"template6"} : $paramdefinition->{"template"};
        my $label = $paramdefinition->{"label"} || $text{"p_label_" . $internalfield . "_" . $param};
        my $input_guidance = "placeholder=\"$tmpl\" title=\"$tmpl\"";
        my $validation = "";
        $validation .= $paramdefinition->{"pattern"} ? " pattern='" . $paramdefinition->{"pattern"} . "'" : "";
        $validation .= $paramdefinition->{"min"} ? " min='" . $paramdefinition->{"min"} . "'" : "";
        $validation .= $paramdefinition->{"max"} ? " max='" . $paramdefinition->{"max"} . "'" : "";
        $validation .= $paramdefinition->{"required"} == 1 ? " required" : " optional";
        if ($paramdefinition->{"required"}) {
            $label .= "&nbsp;<span color='red'>*</span>&nbsp;";
        }
        my $input;
        if ($paramdefinition->{"valtype"} eq "bool") {
            $input = &ui_checkbox($fieldname_prefix . $param, "1", "", $val{$param});
        }
        else {
            if ( $paramdefinition->{"arr"} == 1 ) {
                $input = &ui_textbox($fieldname_prefix . $param, join($paramdefinition->{"sep"}, @{$val{$param}}), $paramdefinition->{"length"}, undef, undef, $input_guidance . $validation);
            }
            else {
                # $input = &ui_textbox($fieldname_prefix . $param, $val{$param}, $paramdefinition->{"length"}) ];
                $input = &ui_textbox($fieldname_prefix . $param, $val{$param}, $paramdefinition->{"length"}, undef, undef, $input_guidance . $validation);
            }
        }
        $rows .= &ui_columns_row( [ $label, $input ], \@tds );
    }
    return $rows;
}

# my $headstuff = $base_headstuff;
my $headstuff = "<script type='text/javascript'>\n"
    . "  \$( \".opener_hidden\" ).prop(\"style\", \"display: none;\");\n"
    . "  function check_" . $internalfield . "(formname) {\n"
    . "    if (!\$(\"#\"+formname)[0].checkValidity()) {\n"
    . "      \$(\"#\"+formname)[0].reportValidity();\n"
    . "      event.preventDefault();\n"
    . "      event.stopImmediatePropagation();\n"
    . "      despinnerfy_buttons();\n"
    . "      return false;\n"
    . "    }\n"
    . "    return true;\n"
    . "  }\n"
    . "  function save_" . $internalfield . "(formname) {\n"
    . "    event.preventDefault();\n"
    . "    let vals=[];\n"
    . "    \$(\"#\"+formname).find(\":input\").each(function(){\n"
    . "      if ((\$(this).prop('type') == 'checkbox' && !\$(this).is(':checked')) || (\$(this).prop('name') == 'submit') || (\$(this).prop('type') == 'button')) return;\n"
    . "      let o={};\n"
    . "      o['f']=\$(this).prop('name');\n"
    . "      o['v']=\$(this).val();\n"
    . "      vals.push(o);\n"
    . "    });\n"
    . "    \$('#list-item-edit-modal').modal('hide');\n"
    . "    submit_form(vals, '" . $formid . "');\n"
    . "    event.stopPropagation();\n"
    . "  }\n"
    . "</script>\n";
$headstuff .= &header_style();

&popup_header(undef, $headstuff);
# &ui_print_header(subtext, title, image, [help], [config], [nomodule], [nowebmin], [rightside], [head-stuff], [body-stuff], [below])
# &ui_print_header(undef, $title, undef, undef, 0, 1, 1, undef, $headstuff);

my $title_header = "<div class=\"modal-title\" style=\"display: flex; width: 100%;\"><span style=\"width: 100%;\"><h4>" . $title . "</h4></span>"
    . "<button type=\"button\" class=\"close\" data-dismiss=\"modal\" aria-label=\"Close\" style=\"height: 24px; width: 24px; float: right; padding: 1px 5px; margin: 2px; \">"
    . "<span aria-hidden=\"true\">&times;</span>"
    . "</button></div>";
if ($internalfield eq "dhcp_range") {
    my $ipversion = "modal_" . ($in{"ipversion"} || "ip4");
    print &ui_columns_start( undef, 100, undef, undef, $title_header);
    my $desc = &ui_hidden_start($text{"description_expand"}, "mandesc", 0, "list_item_edit_chooser.cgi");
    my $descstring = $text{"p_man_desc_" . $internalfield} =~ s/&amp;/&/gr; 
    $desc .= $descstring;
    $desc .= &ui_hidden_end("mandesc");
    print &ui_columns_row( [ $desc ], \@doctd );
    if ($action eq "edit") {
        if ($ipversion eq "modal_ip4") {
            print &ui_columns_row( [ &formtable_ip4($fieldname_prefix) ], [ "colspan=2 style=\"text-align: left; width: auto;\"" ] );
        }
        else {
            print &ui_columns_row( [ &formtable_ip6($fieldname_prefix) ], [ "colspan=2 style=\"text-align: left; width: auto;\"" ] );
        }
    }
    else {

        my @tabs = ( [ 'modal_ip4', $text{"dhcp_ipversion4"} ],
                    [ 'modal_ip6', $text{"dhcp_ipversion6"} ] );
        $tabrow .= &ui_tabs_start(\@tabs, "ipversion", $ipversion);

        $tabrow .= &ui_tabs_start_tab("ipversion", 'modal_ip4');
        $tabrow .= &formtable_ip4($fieldname_prefix);
        $tabrow .= &ui_tabs_end_tab("ipversion", 'modal_ip4');

        $tabrow .= &ui_tabs_start_tab("ipversion", 'modal_ip6');
        $tabrow .= &formtable_ip6($fieldname_prefix);
        $tabrow .= &ui_tabs_end_tab("ipversion", 'modal_ip6');
        $tabrow .= &ui_tabs_end();

        print &ui_columns_row( [ $tabrow ], [ "colspan=2 style=\"text-align: left; width: auto;\"" ] );
    }
    print &ui_columns_end();
}
else {
    print &ui_form_start(undef, undef, undef, "id=\"".$internalfield."_input_form\" onsubmit=\"save_".$internalfield."('".$internalfield."_input_form');\"");
    if ($action eq "edit") {
        $item = $dnsmconfig{$configfield}[$idx];
        %val = %{ $item->{"val"} };
        print &ui_hidden($fieldname_prefix . "idx", $idx);
    }
    print &ui_columns_start( undef, 100, undef, undef, $title_header);
    my $desc = &ui_hidden_start($text{"description_expand"}, "mandesc", 0, "list_item_edit_chooser.cgi");
    $desc .= $text{"p_man_desc_" . $internalfield};
    $desc .= &ui_hidden_end("mandesc");
    print &ui_columns_row( [ $desc ], \@doctd );
    if ($in{"ipversion"} eq "ip6") {
        print &generate_param_rows(4);
    }
    elsif ($in{"ipversion"} eq "ip4") {
        print &generate_param_rows(6);
    }
    else {
        print &generate_param_rows();
    }
    print &ui_table_end();
    print "<div><span color='red'>*</span>&nbsp;<i>" . $text{"footnote_required_parameter"} . "</i></div>";
    my @form_buttons = ();
    push( @form_buttons, &ui_button( $text{"cancel_button"}, "cancel", undef, "style='height: 33px; display:inline; float:right;' data-dismiss='modal' onclick=\"\$('#list-item-edit-modal').modal('hide'); return false;\"", "fa fa-fw fa-times-circle-o", "btn btn-default ui_reset" ) );
    push( @form_buttons, &ui_submit( $text{"save_button"}, "submit", undef, "style='height: 33px; display:inline !important; float:right;' onclick=\"return check_".$internalfield."('".$internalfield."_input_form');\"" ) );
    print &ui_form_end( \@form_buttons );
}
# elsif ($internalfield eq "") {
#     print &ui_columns_row( [ $text{""}, &ui_textbox($fieldname_prefix . "fieldname", $val{""}, 10) ], \@tds );
# }

# &footer();
&popup_footer();

### END of list_item_edit_chooser.cgi ###.
