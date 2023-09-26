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
our $cfg_idx = $in{"cfg_idx"};
my $title = $in{"title"};
$title =~ s/\+/ /g;
our $internalfield = $in{"internalfield"};
our $configfield = &internal_to_config("$internalfield");
our $tddoc = 'colspan=2 class="dnsm-modal-desc"';
our $tdlabel = 'class="dnsm-modal-td-label"';
our $tdinput = 'class="dnsm-modal-td-input"';
our @doctd = ( $tddoc );
our @tds = ( $tdlabel, $tdinput );
our $item;
our %val;
our $fieldname_prefix = ( $action eq "add" ? "new_" : "" ) . $internalfield . "_";
our $at_least_one_required = 0;

sub formtable_ip4 {
    my ($fieldname_prefix) = @_;
    
    my $formtable = "";
    $formtable .= &ui_form_start(undef, undef, undef, "id=\"".$internalfield."_4_input_form\" onSubmit=\"save_".$internalfield."('".$internalfield."_4_input_form');\"");
    $formtable .= &ui_hidden($fieldname_prefix . "ipversion", 4);
    if ($action eq "edit") {
        $item = $dnsmconfig{$configfield}[$cfg_idx];
        %val = %{ $item->{"val"} };
        $formtable .= &ui_hidden($fieldname_prefix . "idx", $cfg_idx);
    }
    $formtable .= &ui_columns_start( [ undef, undef ], 100);
    $formtable .= &generate_param_rows(6);
    $formtable .= &ui_columns_end();
    if ($at_least_one_required) {
        $formtable .= "<div><span color='red'>*</span>&nbsp;<i>" . $text{"footnote_required_parameter"} . "</i></div>";
    }
    my @form_buttons = ();
    push( @form_buttons, &ui_button( $text{"button_cancel"}, "cancel", undef, "class='dnsm-modal-cancel' style='height: 33px; display:inline; float:right;' data-dismiss='modal' onclick=\"\$('#list-item-edit-modal').modal('hide'); return false;\"", "fa fa-fw fa-times-circle-o", "btn btn-default ui_reset" ) );
    push( @form_buttons, &ui_submit( $text{"button_save"}, "submit_4", undef, "class='dnsm-modal-submit' style='height: 33px; display:inline !important; float:right;' onclick=\"return check_".$internalfield."('".$internalfield."_4_input_form');\"" ) );
    $formtable .= &ui_form_end( \@form_buttons );
    return $formtable;
}

sub formtable_ip6 {
    my ($fieldname_prefix) = @_;
    
    my $formtable = "";
    $formtable .= &ui_form_start(undef, undef, undef, "id=\"".$internalfield."_6_input_form\" onSubmit=\"save_".$internalfield."('".$internalfield."_6_input_form');\"");
    $formtable .= &ui_hidden($fieldname_prefix . "ipversion", 6);
    if ($action eq "edit") {
        $item = $dnsmconfig{$configfield}[$cfg_idx];
        %val = %{ $item->{"val"} };
        $formtable .= &ui_hidden($fieldname_prefix . "idx", $cfg_idx);
    }
    $formtable .= &ui_columns_start( [ undef, undef ], 100);
    $formtable .= &generate_param_rows(4);
    $formtable .= &ui_columns_end();
    if ($at_least_one_required) {
        $formtable .= "<div><span color='red'>*</span>&nbsp;<i>" . $text{"footnote_required_parameter"} . "</i></div>";
    }
    my @form_buttons = ();
    push( @form_buttons, &ui_button( $text{"button_cancel"}, "cancel", undef, "class='dnsm-modal-cancel' style='height: 33px; display:inline; float:right;' data-dismiss='modal' onclick=\"\$('#list-item-edit-modal').modal('hide'); return false;\"", "fa fa-fw fa-times-circle-o", "btn btn-default ui_reset" ) );
    push( @form_buttons, &ui_submit( $text{"button_save"}, "submit_6", undef, "class='dnsm-modal-submit' style='height: 33px; display:inline !important; float:right;' onclick=\"return check_".$internalfield."('".$internalfield."_6_input_form');\"" ) );
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
            $at_least_one_required = 1;
            $label .= "&nbsp;<span color='red'>*</span>&nbsp;";
        }
        my $input;
        my $fieldname = $fieldname_prefix . $param . ($ipversionfilter ? "_" . ($ipversionfilter == 4 ? 6 : 4) : "");

        if ($paramdefinition->{"valtype"} eq "bool") {
            $input = &ui_checkbox($fieldname, "1", "", $val{$param});
        }
        else {
            if ( $paramdefinition->{"arr"} == 1 ) {
                $input = &ui_textbox($fieldname, join($paramdefinition->{"sep"}, @{$val{$param}}), $paramdefinition->{"length"}, undef, undef, $input_guidance . $validation);
            }
            else {
                # $input = &ui_textbox($fieldname, $val{$param}, $paramdefinition->{"length"}) ];
                $input = &ui_textbox($fieldname, $val{$param}, $paramdefinition->{"length"}, undef, undef, $input_guidance . $validation);
                if ($paramdefinition->{"sel"}) {
                    # ui_select(name, value|&values, &options, [size], [multiple], [add-if-missing], [disabled?], [javascript])
                    my ($options, $selval) = get_dropdown_options($internalfield, $param, $val, $paramdefinition, $ipversionfilter);
                    $input .= &ui_select($fieldname . "_sel", $selval, $options, 1, 0, ($selval ? 1 : 0), 0, "style=\"width: 220px;\" onchange=\"\$('input[name=" . $fieldname . "]').val(\$(this).val()); return false;\"");
                }
            }
        }
        $rows .= &ui_columns_row( [ $label, $input ], \@tds );
    }
    return $rows;
}

sub get_dropdown_options {
    my ($internalfield, $param, $val, $paramdefinition, $ipversionfilter) = @_;
    my $selval = $val{$param};
    my @options = ();
    if ($internalfield eq "dhcp_option") {
        my %options_by_alt_name = (); # for looking up the current value
        my %options_by_id = (); # for looking up the current value
        my $ipversion = $val{"ipversion"} == 6 ? "ipv6" : $val{"ipversion"} == 4 ? "ipv4" : "new";
        if ($ipversionfilter == 4) {
            foreach my $opt ( @{ $paramdefinition->{"sel"} } ) {
                my $desc = "";
                if ($opt->{"desc"}->{"ipv6"}) {
                    if ($opt->{"alt_names"}->{"ipv6"}) {
                        $desc = $opt->{"alt_names"}->{"ipv6"};
                        $options_by_alt_name->{"option6:" . $opt->{"alt_names"}->{"ipv6"}} = $opt->{"name"};
                        $options_by_id->{$opt->{"name"}} = "option6:" . $opt->{"alt_names"}->{"ipv6"};
                    }
                    $desc .= ($desc ? " - " : "") . $opt->{"desc"}->{"ipv6"};
                    push(@options, [ "option6:" . ($opt->{"alt_names"}->{"ipv6"} ? $opt->{"alt_names"}->{"ipv6"} : $opt->{"name"}), $desc ]);
                }
            }
        }
        else {
            foreach my $opt ( @{ $paramdefinition->{"sel"} } ) {
                my $desc = "";
                if ($opt->{"desc"}->{"ipv4"}) {
                    if ($opt->{"alt_names"}->{"ipv4"}) {
                        $desc = $opt->{"alt_names"}->{"ipv4"};
                        $options_by_alt_name->{$opt->{"alt_names"}->{"ipv4"}} = $opt->{"name"};
                        $options_by_id->{$opt->{"name"}} = $opt->{"alt_names"}->{"ipv4"};
                    }
                    $desc .= ($desc ? " - " : "") . $opt->{"desc"}->{"ipv4"};
                    push(@options, [ ($opt->{"alt_names"}->{"ipv4"} ? $opt->{"alt_names"}->{"ipv4"} : $opt->{"name"}), $desc ]);
                }
            }
        }
        if ($selval ne "") {
            if ($selval !~ /^\d{1,3}$/ ) {
                $selval = "option6:" . $selval if ($val{"ipversion"} == 6);
                # if (grep { /^$selval$/ } ( keys %{$options_by_alt_name} ) ) {
                #     $selval = $options_by_alt_name->{"$selval"};
                # }
            }
            else {
                $selval = "option6:" . $selval if ($val{"ipversion"} == 6);
                if (grep { /^$selval$/ } ( keys %{$options_by_id} ) ) {
                    $selval = $options_by_id->{"$selval"};
                }
            }
        }
    }
    return (\@options, $selval);
}

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
    . "    submitParentForm(vals, '" . $formid . "');\n"
    . "    event.stopPropagation();\n"
    . "  }\n"
    . "</script>\n";
# $headstuff .= &header_js();

&popup_header(undef, $headstuff);
# &ui_print_header(subtext, title, image, [help], [config], [nomodule], [nowebmin], [rightside], [head-stuff], [body-stuff], [below])
# &ui_print_header(undef, $title, undef, undef, 0, 1, 1, undef, $headstuff);

my $title_header = "<div class=\"dnsm-modal-header\"><span class=\"dnsm-modal-title\"><h4 class=\"modal-title\">" . $title . "</h4></span>"
    . "<button type=\"button\" class=\"close dnsm-close-x\" data-dismiss=\"modal\" aria-label=\"Close\">"
    . "<span aria-hidden=\"true\">&times;</span>"
    . "</button></div>";
if ($internalfield eq "dhcp_range" || $internalfield eq "dhcp_option") {
    my $ipversion = "modal_" . ($in{"ipversion"} || "ip4");
    print &ui_columns_start( undef, 100, undef, undef, $title_header);
    my $desc = &ui_hidden_start($text{"description_expand"}, "mandesc", 0, "list_item_edit_chooser.cgi");
    $desc .= $text{"p_man_desc_" . $internalfield} =~ s/&amp;/&/gr;
    $desc .= &ui_hidden_end("mandesc");
    print &ui_columns_row( [ $desc ], \@doctd );
    if ($action eq "edit") {
        if ($ipversion eq "modal_ip4") {
            print &ui_columns_row( [ &formtable_ip4($fieldname_prefix) ], [ "colspan=2 class=\"dnsm-td-left\"" ] );
        }
        else {
            print &ui_columns_row( [ &formtable_ip6($fieldname_prefix) ], [ "colspan=2 class=\"dnsm-td-left\"" ] );
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

        print &ui_columns_row( [ $tabrow ], [ "colspan=2 class=\"dnsm-td-left\"" ] );
    }
    print &ui_columns_end();
}
else {
    my $ipversion = "modal_" . ($in{"ipversion"} || "ip4");
    print &ui_form_start(undef, undef, undef, "id=\"".$internalfield."_input_form\" onsubmit=\"save_".$internalfield."('".$internalfield."_input_form');\"");
    if ($action eq "edit") {
        $item = $dnsmconfig{$configfield}[$cfg_idx];
        %val = %{ $item->{"val"} };
        print &ui_hidden($fieldname_prefix . "idx", $cfg_idx);
    }
    print &ui_columns_start( undef, 100, undef, undef, $title_header);
    my $desc = &ui_hidden_start($text{"description_expand"}, "mandesc", 0, "list_item_edit_chooser.cgi");
    $desc .= $text{"p_man_desc_" . $internalfield} =~ s/&amp;/&/gr;
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
    if ($at_least_one_required) {
        $formtable .= "<div><span color='red'>*</span>&nbsp;<i>" . $text{"footnote_required_parameter"} . "</i></div>";
    }
    my @form_buttons = ();
    push( @form_buttons, &ui_button( $text{"button_cancel"}, "cancel", undef, "class='dnsm-modal-cancel' style='height: 33px; display:inline; float:right;' data-dismiss='modal' onclick=\"\$('#list-item-edit-modal').modal('hide'); return false;\"", "fa fa-fw fa-times-circle-o", "btn btn-default ui_reset" ) );
    push( @form_buttons, &ui_submit( $text{"button_save"}, "submit", undef, "class='dnsm-modal-submit' style='height: 33px; display:inline !important; float:right;' onclick=\"return check_".$internalfield."('".$internalfield."_input_form');\"" ) );
    print &ui_form_end( \@form_buttons );
}
if ($in{"show_validation"}) {
    print "<script type='text/javascript'>\n";
    if (defined($in{"custom_error"}) && $in{"custom_error"} ne "") {
        print "    showCustomValidationFailure('" . $in{"bad_ifield"} . "_" . $in{"bad_param"} . "', '" . $in{"custom_error"} . "');\n";
    }
    print "    \$(\"input[name=" . $in{"show_validation"} . "]\").last()[0].reportValidity();\n"
        . "</script>\n";
}

# &footer();
&popup_footer();

### END of list_item_edit_chooser.cgi ###.
