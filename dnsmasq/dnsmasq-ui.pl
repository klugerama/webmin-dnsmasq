#!/usr/bin/perl
#
#    DNSMasq Webmin Module - dnsmasq-ui.pl; dnsmasq webmin module UI library
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

our @radiodefaultno = ( 0, $text{"default"} );
our @radioyes = ( 1, "Yes" );
our @defaultoryes = ( \@radiodefaultno, \@radioyes );
# our @radiodefaultyes = ( 1, "Default" );
# our @radiono = ( 0, "No" );
# our @defaultorno = ( \@radiodefaultyes, \@radiono );
our @radioval = ( 1, " " );
our @defaultorval = ( \@radiodefaultno, \@radioval );
our $td_left_class = "dnsm-td-left";
our $td_label_class = "dnsm-td-left dnsm-td-label";
our $td_right_class = "dnsm-td-right";
our $warn_class = "dnsm-warn";
our $error_class = "dnsm-error";
our $cbtd_class = "dnsm-cb-td";
# our $customcbtd_class = "ui_checked_checkbox flexed " . $cbtd_class;
our $dnsm_basic_td_class = "dnsm-basic-td";
our $dnsm_header_warn_box_class = "dnsm-header-warn-box"; 

# our $td_left = "class=\"" . $td_left_class . "\"";
# our $td_label = "class=\"" . $td_label_class . "\"";
# our $td_right = "class=\"" . $td_right_class . "\"";
# our $td_warn = "class=\"" . $warn_class . "\"";
# our $td_error = "class=\"" . $error_class . "\"";
# our $cbtd = "class=\"" . $cbtd_class . "\"";
# our $customcbtd = "class=\"ui_checked_checkbox flexed " . $cbtd_class . "\"";
# our $dnsm_basic_td = "class=\"" . $dnsm_basic_td_class . "\"";

sub get_class_tag {
    my ($classes) = @_;
    if (ref($classes) eq "ARRAY") {
        return "class=\"" . join(" ", @{$classes}) . "\"";
    }
    else {
        return "class=\"$classes\"";
    }
}

sub radio_default_or_yes {
    my ($def) = @_;
    my $default_text = ( $def == 0 ? "No" : "(no)" );
    my $default_mouseover = &ui_help($default_text);
    # my @radio_default_no = ( 0, "Default" . ( $def ? " ($def)" : "" ) );
    my @radio_default_no = ( 0, "Default" . $default_mouseover );
    return ( \@radio_default_no, \@radioyes );
}

sub radio_default_or_val {
    my ($def) = @_;
    my $default_text = ( $def ? $def : "(none)" );
    my $default_mouseover = &ui_help($default_text);
    # my @radio_default_no = ( 0, "Default" . ( $d ? " ($d)" : "" ) );
    my @radio_default_no = ( 0, "Default" . $default_mouseover );
    return ( \@radio_default_no, \@radioval );
}

# Returns HTML for a link to put in the top-right corner of every page
sub restart_button {
    # return undef if ($config{'restart_pos'} == 2);
    my $buttons = "";
    if (($config{"check_for_updates"} eq "1" && &needs_update_check()) || $config{"dnsmasq_latest_url"}) {
        my $latest = &check_for_updated_version();
        if ($latest) {
            $buttons .= "<a href='dnsmasq_control.cgi?manual_check_for_update=1' class='show-update-button'>" . $text{"update_module"} . "</a><br>\n";
        }
    }
    my $args = "returnto=".&urlize(&this_url());
    if (&is_dnsmasq_running()) {
        $buttons .= ($access{'restart'} ?
            "<a href='restart.cgi?" . $args . "'>" . $text{"index_button_restart"} . "</a><br>\n" : "").
            ($access{'stop'} ?
            "<a href='stop.cgi?" . $args . "'>" . $text{"index_button_stop"} . "</a>" : "");
        # return "<a href=\"restart.cgi?$args\">$text{"lib_buttac"}</a><br>\n".
        #     "<a href=\"stop.cgi?$args\">$text{"lib_buttsd"}</a>\n";
    }
    else {
        $buttons .= $access{'start'} ?
            "<a href='start.cgi?" . $args . "'>" . $text{"index_button_start"} . "</a>" : "";
        # return "<a href=\"start.cgi?$args\">$text{"lib_buttsd1"}</a>\n";
    }
    return $buttons;
}

sub select_none_link {
    return &theme_select_none_link(@_) if (defined(&theme_select_none_link));
    my ($field, $form, $text) = @_;
    $form = int($form);
    $text ||= $text{'ui_selnone'};
    my $output = "<a class='select-none no-icon' href='#' onClick='javascript:theme_select_all_link($form, \"$field\"); theme_select_invert_link($form, \"$field\"); return false;'>";
    $output .= "$text</a>";
    return $output;
}

sub list_links {
    my ($sel_name, $form) = @_;
    my $addcgi = defined($_[2]) ? $_[2] : undef;
    my $what = defined($_[3]) ? $_[3] : undef;
    my $where = defined($_[4]) ? $_[4] : undef;
    my $link_text = defined($_[5]) ? $_[5] : undef;
    my @links = ( );
    push(@links, &select_all_link($sel_name, $form),
                &select_none_link($sel_name, $form),
                &select_invert_link($sel_name, $form)
                );
    if (defined($addcgi)) {
        push(@links, &ui_link("$addcgi?new=1&what=$what&where=$where",$link_text));
    }
    return @links;
}

sub list_links_add_popup {
    my ($sel_name, $form) = @_;
    my $addcgi = defined($_[2]) ? $_[2] : undef;
    my $height = defined($_[3]) ? $_[3] : 300;
    my $fieldmapping = defined($_[4]) ? $_[4] : undef;
    my @links = ( );
    push(@links, &select_all_link($sel_name, $form),
                &select_none_link($sel_name, $form),
                &select_invert_link($sel_name, $form)
                );
    if (defined($addcgi)) {
        # popup_window_button(url, width, height, scrollbars?, &field-mappings)
        push(@links, &popup_window_button("$addcgi", 600, $height, 0, \@fieldmapping ));
    }
    return @links;
}

=head2 get_mover_buttons(url, current_index, total_items)
=cut
sub get_mover_buttons {
    my ($url, $current_index, $total) = @_;
    my $sep = $url =~ /\?/ ? "&" : "?";
    my $mover;
    if ( $total == 1 ) {
        return "<img src=images/gap.gif>";
    }
    if( $current_index == ($total - 1) ) {
        $mover = "<img src=images/gap.gif>";
    }
    else {	
        $mover = "</a><a href='$url" . $sep . "cfg_idx=$current_index&t=".$total."&dir=down'><img src=images/down.gif border=0/></a>";
        # $mover = "<span onclick=\"location.href='$url" . $sep . "cfg_idx=$current_index&t=".$total."&dir=down';return false;\"><img src=images/down.gif border=0/></span>";
    }
    if( $current_index == 0 ) {
        $mover .= "<img src=images/gap.gif>";
    }
    else {
        $mover .= "<a href='$url" . $sep . "cfg_idx=$current_index&t=".$total."&dir=up'><img src=images/up.gif border=0/></a>";
        # $mover .= "<span onclick=\"location.href='$url" . $sep . "cfg_idx=$current_index&t=".$total."&dir=up';return false;\"><img src=images/up.gif border=0/></span>";
    }
    return $mover;
}

=head2 add_file_chooser_button(text, input, type, formid, [chroot], [addmode])
    Return HTML for a button that pops up a file chooser when clicked, and places
    the selected filename into another HTML field. The parameters are :
        text - Text to appear in the button.
        input - Name of the form field to store the filename in.
        type - 0 for file or directory chooser, or 1 for directory only.
        formid - Id of the form containing the button.
        chroot - If set, the chooser will be limited to this directory.
        addmode - If set to 1, the selected filename will be appended to the text box instead of replacing its contents.
=cut
sub add_file_chooser_button {
    my ($button_text, $input, $type, $formid)  = @_;
    my $chroot = defined($_[4]) ? $_[4] : "/";
    my $add    = int($_[5]);
    my $link   = "chooser.cgi?add=$add&type=$type&chroot=$chroot&file=\"+encodeURIComponent(ifield.value)";

    my $file_chooser_button = "<button class='btn btn-inverse btn-tiny file-chooser-button chooser_button no-icon' ";
    $file_chooser_button .= "onClick='ifield = \$( \"#$input\" )[0]; ";
    $file_chooser_button .= "chooser = window.open(\"$theme_webprefix/$link, \"chooser\"); chooser.ifield = ifield; window.ifield = ifield;'>";
    $file_chooser_button .= "$button_text</button>\n";

    my $hidden_input_fields = "";
    $hidden_input_fields .= "<input type=\"hidden\" name=\"$input\" class=\"new-file-input\"></input>";
    $hidden_input_fields .= "";
    return ($file_chooser_button, $hidden_input_fields);
}

=head2 edit_file_chooser_link(text, input, type, current_value, cfg_idx, formid, [chroot], [addmode])
    Return HTML for a link that pops up a file chooser when clicked, and places
    the selected filename into hidden HTML text field. The parameters are :
        text - Text to appear in the link.
        input - Name of the form field to store the filename in.
        type - 0 for file or directory chooser, or 1 for directory only.
        current_value - Current filename/directory
        cfg_idx - Index of the item to edit
        formid - Id of the form containing the button.
        chroot - If set, the chooser will be limited to this directory.
        addmode - If set to 1, the selected filename will be appended to the text box instead of replacing its contents.
=cut
sub edit_file_chooser_link {
    my ($link_text, $input, $type, $current_value, $cfg_idx, $formid)  = @_;
    my $chroot = defined($_[6]) ? $_[6] : "/";
    my $add    = int($_[7]);
    my $link   = "chooser.cgi?add=$add&type=$type&chroot=$chroot&file=\"+encodeURIComponent(ifield.value)";

    if ($link_text eq "") {
        $link_text = "<span class='dnsm-empty-value'>" . $text{"empty_value"} . "</span>"
    }

    my $file_edit_link = "<a href=\"#\" onclick='event.preventDefault();"
        . $formid."_".$input."_temp = \"".$current_value."\";"
        . "\$(\"input[name=" . $input. "]\").val(\"".$current_value."\");"
        . "\$(\"input[name=" . $input. "_idx]\").val($cfg_idx);"
        . "\$(\"#" . $formid . "_" . $input. "_b\").trigger(\"click\");event.stopPropagation();return false;'>" . $link_text . "</a>";

    my $hidden_input_fields = "<input type=\"hidden\" name=\"$input\" class=\"edit-file-input\"></input>"
        . "<button class='btn file-chooser-button chooser_button hidden' id=\"" . $formid . "_" . $input. "_b\" "
        . "onClick='\$(input[name=".$input."]).val(null); ifield = \$( \"#$input\" )[0]; "
        . "chooser = window.open(\"" . $theme_webprefix . "/" . $link . ", \"chooser\"); chooser.ifield = ifield; window.ifield = ifield;'>"
        . "</button>\n"
        . "";
    $hidden_input_fields .= "<input type=\"hidden\" name=\"".$input."_idx\"></input>";
    return ($file_edit_link, $hidden_input_fields);
}

=head2 add_interface_chooser_button(text, input, formid, [addmode])
    Return HTML for a button that pops up an interface chooser when clicked, and places
    the selected filename into another HTML field. The parameters are :
        text - Text to appear in the button.
        input - Name of the form field to store the filename in.
        formid - Id of the form containing the button.
        addmode - If set to 1, the selected interface will be appended to the text box instead of replacing its contents.
=cut
sub add_interface_chooser_button {
    my ($button_text, $input, $formid)  = @_;
    my $add    = int($_[3]);
    my $link   = "net/interface_chooser.cgi?multi=$add&interface=";

    my $iface_chooser_button = "<button class='btn btn-inverse btn-tiny iface-chooser-button chooser_button no-icon' ";
    $iface_chooser_button .= "onClick='ifield = \$( \"#$input\" )[0]; ";
    $iface_chooser_button .= "chooser = window.open(\"$theme_webprefix/$link, \"chooser\"); chooser.ifield = ifield; window.ifield = ifield; ";
    $iface_chooser_button .= "'>$button_text</button>\n";

    my $hidden_input_fields = "";
    $hidden_input_fields .= "<input type=\"hidden\" name=\"$input\" class=\"new-iface-input\"></input>";
    $hidden_input_fields .= "";
    return ($iface_chooser_button, $hidden_input_fields);
}

=head2 edit_interface_chooser_link(text, input, type, current_value, cfg_idx, formid, [addmode])
    Return HTML for a link that pops up an interface chooser when clicked, and places
    the selected interface into hidden HTML text field. The parameters are :
        text - Text to appear in the link.
        input - Name of the form field to store the interface in.
        current_value - Current interface
        cfg_idx - Index of the item to edit
        formid - Id of the form containing the button.
        addmode - If set to 1, the selected interface will be appended to the text box instead of replacing its contents.
=cut
sub edit_interface_chooser_link {
    my ($link_text, $input, $current_value, $cfg_idx, $formid)  = @_;
    my $add = $_[5];
    my $link   = "net/interface_chooser.cgi?multi=$add&interface=";

    if ($link_text eq "") {
        $link_text = "<span class='dnsm-empty-value'>" . $text{"empty_value"} . "</span>"
    }

    my $iface_edit_link = "<a href=\"#\" onclick='event.preventDefault();"
        . $formid."_".$input."_temp = \"".$current_value."\";"
        . "\$(\"input[name=" . $input. "]\").val(\"".$current_value."\");"
        . "\$(\"input[name=" . $input. "_idx]\").val($cfg_idx);"
        . "\$(\"#" . $formid . "_" . $input. "_b\").trigger(\"click\");event.stopPropagation();return false;'>" . $link_text . "</a>";

    my $hidden_input_fields = "<input type=\"hidden\" name=\"$input\" class=\"edit-iface-input\"></input>"
        . "<button class='btn btn-inverse btn-tiny iface-chooser-button chooser_button hidden' id=\"" . $formid . "_" . $input. "_b\" "
        . "onClick='\$(input[name=".$input."]).val(null); ifield = \$( \"#$input\" )[0]; "
        . "chooser = window.open(\"" . $theme_webprefix . "/" . $link . ", \"chooser\"); chooser.ifield = ifield; window.ifield = ifield;'>"
        . "</button>\n"
        . "";
    $hidden_input_fields .= "<input type=\"hidden\" name=\"".$input."_idx\"></input>";
    return ($iface_edit_link, $hidden_input_fields);
}

=head2 edit_item_popup_modal_link(url, internalfield, formid, link_text)
    Returns HTML for a link that will popup, hidden fields, and some JS to handle it 
    for a simple edit window of some kind.
        url - Base URL of the popup window's contents
        internalfield - Keyword that identifies what to edit
        formid - Id of the form on the source page to submit
        link_text - Text to appear in link
=cut
sub edit_item_popup_modal_link {
    my ($url, $internalfield, $formid, $link_text, $cfg_idx) = @_;

    my $sep = $url =~ /\?/ ? "&" : "?";
    $url .= $sep . "internalfield=$internalfield";
    $url .= "&formid=" . $formid;

    if ($link_text eq "") {
        $link_text = "<span class='dnsm-empty-value'>" . $text{"empty_value"} . "</span>"
    }

    my $link = "<a data-toggle=\"modal\" href=\"$url\" data-target=\"#list-item-edit-modal\" data-backdrop=\"static\" dnsm_array_idx=\"$cfg_idx\">";
    $link .= "$link_text";
    $link .= "</a>";
    return $link;
}

=head2 edit_item_link(link_text, internalfield, title, cfg_idx, formid, field-mappings[, extra-url-params])
    Returns HTML for a link that will popup, hidden fields, and some JS to handle it 
    for a simple edit window of some kind.
        link_text - Text to appear in link
        internalfield - Keyword that identifies what to edit
        title - Text to appear in the popup window title
        cfg_idx - Index of the item to edit
        formid - Id of the form on the source page to submit
        field-mappings - Array of fields to include in form
        [extra-url-params] - URL-formatted string of any extra param=value pairs (if multiple, delimited with "&")
=cut
sub edit_item_link {
    my ($link_text, $internalfield, $title, $cfg_idx, $formid, $fields, $fidx) = @_;
    my $extra_url_params = @_[7] || "";
    if ($extra_url_params) {
        $extra_url_params = ( $extra_url_params =~ /^&/ ? "" : "&" ) . $extra_url_params;
    }

    $title =~ s/ /+/g ;
    my $qparams = "action=edit&cfg_idx=$cfg_idx&title=$title" . $extra_url_params;
    $qparams .= "&fidx=" . $fidx;
    my $link = &edit_item_popup_modal_link("list_item_edit_chooser.cgi?" . $qparams, $internalfield, $formid, $link_text, $fidx);

    my $hidden_input_fields = "<div>\n";
    foreach my $fieldname ( @$fields ) {
        $hidden_input_fields .= "<input type=\"hidden\" name=\"" . $internalfield . "_" . $fieldname . "\" class=\"edit-item-val\"></input>";
    }
    $hidden_input_fields .= "</div>\n";

    return ($link, $hidden_input_fields);
}

=head2 add_item_popup_modal_button(url, internalfield, formid, button_content)
    Returns HTML for a button that will popup a simple list item add window of some kind.
    url - Base URL of the popup window's contents
    internalfield - Keyword that identifies what to add; handling must be defined in list_item_add_popup.cgi
    formid - Id of the form on the source page to submit
    button_content - Text to appear in button
=cut
sub add_item_popup_modal_button {
    my ($url, $internalfield, $formid, $button_content) = @_;

    my $sep = $url =~ /\?/ ? "&" : "?";
    $url .= $sep . "internalfield=$internalfield";
    $url .= "&formid=$formid";
    my $rv = "<a data-toggle=\"modal\" href=\"$url\" data-target=\"#list-item-edit-modal\" data-backdrop=\"static\" class='btn btn-inverse btn-tiny add-item-button new-dnsm-button-container no-icon' ";
    $rv .= ">";
    $rv .= "$button_content";
    $rv .= "</a>";
    return $rv;
}

=head2 add_item_button(buttontext, internalfield, title, formid, field-mappings[, extra-url-params])
    Returns HTML for a button that will popup a window, hidden fields, and some JS to handle it 
    for entry of a new item of some kind.
        buttontext - Text to appear in button
        internalfield - Keyword that identifies what to add; handling must be defined in list_item_add_popup.cgi
        title - Text to appear in the popup window title
        formid - Id of the form on the source page to submit
        fields - Array reference of field names i.e., [ "new_tag", "new_vendorclass" ]; must be handled in form's submit target
=cut
sub add_item_button {
    my ($button_text, $internalfield, $title, $formid, $fields) = @_;
    my $extra_url_params = @_[5] || "";
    if ($extra_url_params) {
        $extra_url_params = ( $extra_url_params =~ /^&/ ? "" : "&" ) . $extra_url_params;
    }

    # my @fieldmapping = ();
    my $hidden_input_fields = "<div>\n";
    foreach my $fieldname ( @$fields ) {
        $hidden_input_fields .= "<input type=\"hidden\" name=\"new_" . $internalfield . "_" . $fieldname . "\" class=\"add-item-val\"></input>";
    #     push( @fieldmapping, [ $fieldname, $fieldname ] );
    }
    $hidden_input_fields .= "</div>\n";

    $title =~ s/ /+/g ;
    my $qparams = "action=add&title=$title" . $extra_url_params;
    my $button = &add_item_popup_modal_button("list_item_edit_chooser.cgi?" . $qparams, $internalfield, $formid, $button_text );
    return ($button, $hidden_input_fields);
}

sub get_selectbox_with_controls {
    my ($name, $values, $size, $length, $template) = @_;
    # my $minwidth = ((($length * 7.39) + 111) || "150") . "px";
    my $s = "<div>";
    # ui_select(name, value|&values, &options, [size], [multiple], [add-if-missing], [disabled?], [javascript])
    $s .= &ui_select( $name, undef, \@{ $values }, $size, 1, undef, 0, "id=\"$name\"" );
    $s .= "<script type='text/javascript'>\n"
        . "\$(document).ready(function() {\n"
        . "  setTimeout(function() {\n"
        . "    \$(\"select[name='$name']\").attr(\"style\", (i,v)=>{ return (v?v:'')+\"width: 100%;\"; });\n"
        . "  }, 10);\n"
        . "});\n"
        . "\$(\"select[name='$name']\").parents(\"form\").first().on(\"submit\", function(e){ \$(\"select[name='$name'] option\").prop('selected', true); });\n"
        . "</script>";
    $s .= "<br><nobr><div><span class=\"btn btn-tiny remove-item-button-small no-icon\" onclick=\"removeSelectItem('$name'); return false;\"></span>";
    # ui_textbox(name, value, size, [disabled?], [maxlength], [tags])
    my $textbox_name = $name . "_additem";
    $s .= &ui_textbox( $textbox_name, undef, $length, undef, undef, "placeholder=\"$template\" title=\"$template\"" );
    $s .= "<span class=\"btn btn-tiny add-item-button-small no-icon\" onclick=\"addItemToSelect('$name'); return false;\"></span>";
    $s .= "</div></nobr>";
    $s .= "</div>";
    return $s;
}

=head2 show_basic_fields(\%dnsmconfig, $pageid, \@page_fields, $apply_cgi, $table_header)
=cut
sub show_basic_fields {
    my ($dnsmconfig, $pageid, $page_fields, $apply_cgi, $table_header) = @_;
    my $formid = $pageid . "_basic_form";
    our $at_least_one_required = 0;

    my @basic_fields = &get_basic_fields($page_fields);
    return if @basic_fields == 0;
    my @tds = ( &get_class_tag($cbtd_class), &get_class_tag($dnsm_basic_td_class), &get_class_tag($dnsm_basic_td_class) );
    print &ui_form_start( $apply_cgi, "post", undef, "id='$formid'" );
    if (@basic_fields == 1) {
        my $g = &ui_columns_start( [
                "",
                $text{'column_option'},
                $text{'column_value'}
            ], undef, 0, \@tds);
        my $configfield = @basic_fields[0];
        $g .= &get_basic_fields_row($dnsmconfig, $configfield);
        $g .= &ui_columns_end();
        push(@grid, $g);
        print &ui_grid_table(\@grid, 2, 100, undef, undef, $table_header);
    }
    else {
        my $l = int(@basic_fields / 2);

        my @grid = ();
        foreach my $column_array ([ @basic_fields[0..$l-1] ], [ @basic_fields[$l..$#basic_fields] ]) {
            my $g = &ui_columns_start( [
                    "",
                    $text{'column_option'},
                    $text{'column_value'}
                ], undef, 0, \@tds);

            foreach my $configfield ( @$column_array ) {
                $g .= &get_basic_fields_row($dnsmconfig, $configfield);
            }
            $g .= &ui_columns_end();
            push(@grid, $g);
        }
        print &ui_grid_table(\@grid, 2, 100, undef, undef, $table_header);
    }
    if ($at_least_one_required) {
        print "<div><span color='red'>*</span>&nbsp;<i>" . $text{"footnote_required_parameter"} . "</i></div>";
    }

    # print &ui_form_end( [ &ui_submit( $text{"button_save"} ), &ui_reset( $text{"undo_button"} ) ] );
    print &ui_form_end( [ &ui_submit( $text{"button_save"}, "submit" ) ] );
}

sub get_basic_fields_row {
    my ($dnsmconfig, $configfield) = @_;
    my $internalfield = &config_to_internal("$configfield");
    my $row = "";


    my $help = &ui_help($configfield . ": " . $text{"p_man_desc_$internalfield"});
    if ( grep { /^$configfield$/ } ( @confbools ) ) {
        my $bigtd = &get_class_tag($dnsm_basic_td_class) . " colspan=2";
        my @booltds = ( &get_class_tag($cbtd_class), $bigtd );
        $row = &ui_checked_columns_row( [
                ($definition->{"label"} || $text{"p_label_" . $internalfield}) . $help,
            ], \@booltds, "sel", $configfield, ($dnsmconfig->{$configfield}->{"used"})?1:0
        );
    }
    elsif ( grep { /^$configfield$/ } ( @confsingles ) ) {
        my $definition = %configfield_fields{$internalfield}->{"val"};
        my $tmpl = $definition->{"template"};
        my $label = $text{"p_label_" . $internalfield} . $help;
        my $input_guidance = "placeholder=\"$tmpl\" title=\"$tmpl\"";
        my $validation = "";
        $validation .= $definition->{"pattern"} ne "" ? " pattern='" . $definition->{"pattern"} . "'" : "";
        $validation .= $definition->{"min"} ne "" ? " min='" . $definition->{"min"} . "'" : "";
        $validation .= $definition->{"max"} ne "" ? " max='" . $definition->{"max"} . "'" : "";
        my $req_star = "";
        if ($definition->{"required"} == 1) {
            $at_least_one_required = 1;
            $req_star = "&nbsp;<span color='red'>*</span>&nbsp;";
            $validation .= " required";
        }
        else {
            $validation .= " optional";
        }
        my $is_used = $dnsmconfig->{$configfield}->{"used"}?1:0;
        my $fname = $internalfield . "val";
        my $extra_tags = "onchange=\"\$('input[name=" . $fname . "]').prop('disabled', (i, v) => !v);\"";
        my $val = $dnsmconfig->{$configfield}->{"val"};
        # my @tds = ( &get_class_tag($cbtd_class), &get_class_tag($dnsm_basic_td_class), &get_class_tag($dnsm_basic_td_class) );
        my @tds = ( &get_class_tag($dnsm_basic_td_class), &get_class_tag($dnsm_basic_td_class) );
        if ( $definition->{"valtype"} eq "user" ) {
            $row = &ui_clickable_checked_columns_row( [
                    $label, 
                    "<nobr>"
                        . &ui_user_textbox( $fname, $val, undef, $is_used?0:1, undef, $input_guidance . $validation )
                        . $req_star
                        . "</nobr>"
                ], undef, "sel", $configfield, $is_used, undef, $extra_tags );
        }
        elsif ( $definition->{"valtype"} eq "group" ) {
            $row = &ui_clickable_checked_columns_row( [
                    $label, 
                    "<nobr>"
                        . &ui_group_textbox( $fname, $val, undef, $is_used?0:1, undef, $input_guidance . $validation )
                        . $req_star
                        . "</nobr>"
                ], undef, "sel", $configfield, $is_used, undef, $extra_tags );
        }
        elsif ( $definition->{"valtype"} =~ /(file|dir|path)$/ ) {
            $row = &ui_clickable_checked_columns_row( [
                    $label, 
                    "<nobr>"
                        . &ui_filebox( $fname, $val, $definition->{"length"}, $is_used?0:1, undef, $input_guidance . $validation, $definition->{"valtype"} eq "dir" ? 1 : undef )
                        . $req_star
                        . "</nobr>"
                ], undef, "sel", $configfield, $is_used, undef, $extra_tags );
        }
        else {
            $row = &ui_clickable_checked_columns_row( [
                    $label, 
                    "<nobr>"
                        . &ui_textbox( $fname, $val, $definition->{"length"}, $is_used?0:1, undef, $input_guidance . $validation . " dnsmclass=\"dnsm-type-" . $definition->{"valtype"} . "\"" )
                        . $req_star
                        . "</nobr>"
                ], \@tds, "sel", $configfield, $is_used, undef, $extra_tags );
        }
        return $row;
    }
}

sub show_other_fields {
    my ($dnsmconfig, $pageid, $page_fields, $apply_cgi, $table_header) = @_;
    my $formid = "$pageid_other_form";
    our $at_least_one_required = 0;

    print &ui_form_start( $apply_cgi, "post", undef, "id='$formid'" );
    my @tds = ( &get_class_tag($td_label_class), &get_class_tag($td_left_class) );
    my @var_fields = &get_other_fields($page_fields);
    return if @var_fields == 0;
    my $col_ct = &get_max_columns(\@var_fields) + 2; # it will always have the label and radio buttons
    my @columns_arr = (3..$col_ct);
    for (@columns_arr) {
        push( @tds, &get_class_tag($td_label_class) );
    }
    print &ui_columns_start( undef, 100, undef, undef, &ui_columns_header( [ $table_header ], [ 'class="table-title" colspan=' . $col_ct ] ), 0 );
    foreach my $configfield ( @var_fields ) {
        my $internalfield = &config_to_internal($configfield);
        my @cols = &get_field_auto_columns($internalfield, $col_ct);
        print &ui_columns_row( \@cols, \@tds );
    }

    print &ui_columns_end();
    if ($at_least_one_required) {
        print "<div><span color='red'>*</span>&nbsp;<i>" . $text{"footnote_required_parameter"} . "</i></div>";
    }
    my @form_buttons = ();
    # push( @form_buttons, &ui_submit( $text{"button_cancel"}, "cancel" ) );
    push( @form_buttons, &ui_submit( $text{"button_save"}, "submit" ) );
    print &ui_form_end( \@form_buttons );
}

sub get_field_auto_columns {
    my ($internalfield, $col_ct) = @_;
    my $configfield = &internal_to_config($internalfield);
    my $item = $dnsmconfig{"$configfield"};
    my $val = $item->{"val"};
    my @pathtypes = ( "file", "path", "dir" );
    my @cols = ();
    push ( @cols, &show_label_with_help($internalfield, $configfield) );
    # first get a list of all parameters for this field, for the radio button (ui_opt_textbox)
    # to disable the text fields for them when this value is not enabled
    my @otherfields = ();
    foreach my $key ( @{ %configfield_fields{$internalfield}->{"param_order"} } ) {
        my $definition = %configfield_fields{$internalfield}->{$key};
        my $fieldname = $internalfield . "_" . $key;
        push ( @otherfields, $fieldname );
        # if this parameter is an array, include
        if ($definition->{"arr"} == 1) {
            push ( @otherfields, $fieldname . "_additem" );
        }
        elsif ($definition->{"valtype"} eq "interface") {
            push ( @otherfields, $fieldname . "_ifaceChooser" );
        }
    }
    # ui_opt_textbox(name, value, size, option1, [option2], [disabled?], [&extra-fields], [max], [tags])
    # ui_textbox(name, value, size, [disabled?], [maxlength], [tags])
    # ui_filebox(name, value, size, [disabled?], [maxlength], [tags], [dir-only])
    # ui_select(name, value|&values, &options, [size], [multiple], [add-if-missing], [disabled?], [javascript])
    my $count = 0;
    foreach my $key ( @{ %configfield_fields{$internalfield}->{"param_order"} }) {
        my $definition = %configfield_fields{$internalfield}->{$key};
        # my $is_used = $dnsmconfig->{$configfield}->{"used"}?1:0;
        if ($count == 0) {
            push ( @cols, "<nobr>" . &ui_opt_textbox( $internalfield, $item->{"used"}?1:undef, 1, $text{"disabled"}, undef, undef, \@otherfields, undef, "dummy_field" ) . "</nobr>");
        }
        my $fieldname = $internalfield . "_" . $key;
        my $tmpl = $definition->{"template"};
        my $label = $definition->{"label"} || $text{"p_label_" . $fieldname};
        my $input_guidance = "placeholder=\"$tmpl\" title=\"$tmpl\"";
        my $validation = "";
        $validation .= $definition->{"pattern"} ? " pattern='" . $definition->{"pattern"} . "'" : "";
        $validation .= $definition->{"min"} ? " min='" . $definition->{"min"} . "'" : "";
        $validation .= $definition->{"max"} ? " max='" . $definition->{"max"} . "'" : "";
        $validation .= $definition->{"required"} == 1 ? " required" : " optional";
        if ($definition->{"required"}) {
            $at_least_one_required = 1;
            $label .= "&nbsp;<span color='red'>*</span>&nbsp;";
        }
        if ($definition->{"arr"} == 1) {
            push ( @cols, $label . "<br>" . &get_selectbox_with_controls( $fieldname, ($key eq "val" ? $val : \@{ $val->{$key} }), 3, $definition->{"length"}, $tmpl ) );
        }
        else {
            my $input;
            my $valtype = $definition->{"valtype"};
            if (grep { /^$valtype$/ } ( @pathtypes )) {
                $input = "<nobr>" . &ui_filebox( $fieldname, $val->{$key}, $definition->{"length"}, undef, undef, $input_guidance . $validation, ($valtype eq "dir" ? 1 : 0) ) . "</nobr>";
            }
            elsif ($valtype eq "interface") {
                my $button;
                if (&foreign_available("net") && defined(net::active_interfaces)) {
                    &foreign_require("net", "net-lib.pl");
                    my $buttonname = $fieldname . "_ifaceChooser";
                    $button = &net::interfaces_chooser_button($fieldname);
                    webmin_debug_log("--------IFACE", "button: $button ");
                    $button =~ s/\>/ name="$buttonname">/;
                    webmin_debug_log("--------IFACE", "button: $button ");
                }
                $input = "<nobr>" . &ui_textbox( $fieldname, $val->{$key}, $definition->{"length"}, undef, undef, $input_guidance . $validation ) . " " .
                         ( $button ) . "</nobr>";
            }
            else {
                $input = &ui_textbox( $fieldname, $val->{$key}, $definition->{"length"}, undef, undef, $input_guidance . $validation );
            }
            push ( @cols, $label . "<br>" . $input );
        }
        $count++;
    }
    while (@cols <= $col_ct) {
        push( @cols, "&nbsp;" );
    }
    return @cols;
}

# &show_field_table("listen_address", "dns_iface_apply.cgi", $text{"_listen"}, \%dnsmconfig);
sub show_field_table {
    my ($internalfield, $apply_cgi, $addtext, $dnsmconfig, $formidx) = @_;
    my $addtype = defined($_[5]) ? $_[5] : undef;
    my $include_movers = defined($_[6]) ? $_[6] : undef;
    my $returnto = defined($_[7]) ? $_[7] : undef;
    my $returnlabel = defined($_[8]) ? $_[8] : undef;
    my $configfield = &internal_to_config($internalfield);
    my $definition = %configfield_fields{$internalfield};
    my $add_button;
    my $hidden_add_input_fields;
    my $hidden_interface_edit_input_fields;
    my $hidden_file_edit_input_fields;
    my $hidden_item_edit_input_fields;
    my @newfields = @{$definition->{"param_order"}};
    my @editfields = ( "cfg_idx", @newfields );
    my $formid = $internalfield . "_form";
    my @tds = ( &get_class_tag($td_label_class), &get_class_tag($td_left_class) );
    my @pathtypes = ( "file", "path", "dir" );
    my @column_headers = ( 
        "",
        $text{"enabled"}
    );
    # if ( @newfields == 1 ) {
    #     push(@column_headers, $definition->{"@newfields[0]"}->{"label"} );
    #     push( @tds, &get_class_tag($td_left_class) );
    # }
    # else {
        foreach my $param ( @newfields ) {
            push(@column_headers, $definition->{"$param"}->{"label"} );
            push( @tds, &get_class_tag($td_left_class) );
        }
    # }
    if ($include_movers) {
            push(@column_headers, "" );
            push( @tds, &get_class_tag($td_left_class) );
    }
    my @list_link_buttons = &list_links( "sel", $formidx );
    my $first_field = $newfields[0];
    if (!$addtype) {
        if ($definition->{$first_field} && $definition->{$first_field}->{"valtype"} eq "interface") {
            $addtype = "interface";
        }
        elsif ($definition->{$first_field} && grep { /^$definition->{$first_field}->{"valtype"}$/ } ( @pathtypes )) {
            $addtype = "file";
        }
        else {
            $addtype = "item";
        }
    }
    if ($addtype eq "interface") {
        ($add_button, $hidden_add_input_fields) = &add_interface_chooser_button( &text("add_", $text{"_iface"}), "new_" . $internalfield, $formid );
    }
    elsif ($addtype eq "file") {
        ($add_button, $hidden_add_input_fields) = &add_file_chooser_button( &text("add_", $text{"_" . $definition->{$first_field}->{"valtype"}}), "new_" . $internalfield, $formid );
    }
    else {
        ($add_button, $hidden_add_input_fields) = &add_item_button(&text("add_", $addtext), $internalfield, $text{"p_label_$internalfield"}, $formid, \@newfields );
        push(@list_link_buttons, $add_button);
    }

    my $count=0;
    print &ui_form_start( $apply_cgi, "post", undef, "id='$formid'" );
    print &ui_links_row(\@list_link_buttons);
    if ($addtype eq "interface" || $addtype eq "file") {
        print $hidden_add_input_fields . $add_button;
    }
    print &ui_columns_start( \@column_headers, 100, undef, undef, 
        &ui_columns_header( [ &show_title_with_help($internalfield, $configfield) ], 
        [ 'class="table-title" colspan=' . @column_headers ] ), 1 );
    foreach my $item ( @{$dnsmconfig{$configfield}} ) {
        local @cols;
        push ( @cols, &ui_checkbox("enabled", "1", "", $item->{"used"}?1:0, undef, 1) );
        foreach my $param ( @newfields ) {
            my $edit_link;
            my $valtype = $definition->{"$param"}->{"valtype"};
            my $val = ($param eq "val") ? $item->{"$param"} : $item->{"val"}->{"$param"};
            if ($definition->{"$param"}->{"arr"} == 1 && ref($val) eq "ARRAY") {
                $val = join($definition->{"$param"}->{"sep"}, @{$val})
            }
            elsif ($valtype eq "bool") {
                $val = &ui_checkbox("boolval", "1", "", $val, undef, 1)
            }
            my $extra_url_params = ($in{"bad_ifield"} 
                                    && $in{"cfg_idx"} eq $item->{"cfg_idx"} 
                                    && $in{"show_validation"} 
                                    ? "show_validation=" . $in{"show_validation"} 
                                        . ($in{"custom_error"} 
                                           ? "&custom_error=" . $in{"custom_error"} 
                                           : "") 
                                    : "");
            if ($count == 0) {
                if ($valtype eq "interface") {
                    # edit_interface_chooser_link(text, input, current_value, cfg_idx, formid, [addmode])
                    ($edit_link, $hidden_interface_edit_input_fields) = &edit_interface_chooser_link($val, $internalfield, $val, $count, $formid);
                }
                elsif (grep { /^$valtype$/ } ( @pathtypes )) {
                    # edit_file_chooser_link(text, input, type, current_value, cfg_idx, formid, [chroot], [addmode])
                    ($edit_link, $hidden_file_edit_input_fields) = &edit_file_chooser_link($val, $internalfield, ($valtype eq "dir" ? 1 : 0), $val, $count, $formid);
                }
                else {
                    # first call to &edit_item_link should capture link and fields; subsequent calls (1 for each field) only need the link
                    ($edit_link, $hidden_item_edit_input_fields) = &edit_item_link($val, $internalfield, $text{"p_desc_$internalfield"}, $count, $formid, \@editfields, $item->{"cfg_idx"}, $extra_url_params);
                }
            }
            else {
                if ($valtype eq "interface") {
                    ($edit_link) = &edit_interface_chooser_link($val, $internalfield, $val, $count, $formid);
                }
                elsif (grep { /^$valtype$/ } ( @pathtypes )) {
                    # edit_file_chooser_link(text, input, type, current_value, cfg_idx, formid, [chroot], [addmode])
                    ($edit_link) = &edit_file_chooser_link($val, $internalfield, ($valtype eq "dir" ? 1 : 0), $val, $count, $formid);
                }
                else {
                    ($edit_link) = &edit_item_link($val, $internalfield, $text{"p_desc_$internalfield"}, $count, $formid, \@editfields, $item->{"cfg_idx"}, ($in{"bad_ifield"} && $in{"show_validation"} ? "show_validation=" . $in{"show_validation"} : ""));
                }
            }
            push ( @cols, $edit_link );
        }
        if ($include_movers) {
            local $mover = &get_mover_buttons("item_move.cgi?internalfield=$internalfield&returnto=$returnto&returnlabel=$returnlabel", $count, int(@{$dnsmconfig{$configfield}}) );
            push ( @cols, $mover );
        }
        print &ui_clickable_checked_columns_row( \@cols, \@tds, "sel", $count );
        $count++;
    }
    print &ui_columns_end();
    print &ui_links_row(\@list_link_buttons);
    if ($addtype eq "interface" || $addtype eq "file") {
        print $hidden_add_input_fields . $add_button;
    }
    print "<p>" . $text{"with_selected"} . "</p>";
    print &ui_submit($text{"button_enable_sel"}, "enable_sel_$internalfield");
    print &ui_submit($text{"button_disable_sel"}, "disable_sel_$internalfield");
    print &ui_submit($text{"button_delete_sel"}, "delete_sel_$internalfield");
    # if (!$definition->{"val"} || $definition->{"val"}->{"valtype"} ne "interface") {
    if ($addtype ne "interface" && $addtype ne "file") {
        print $hidden_add_input_fields;
    }
    print $hidden_interface_edit_input_fields;
    print $hidden_file_edit_input_fields;
    print $hidden_item_edit_input_fields;
    print &ui_form_end();
    print &ui_hr();
}

sub show_path_list {
    my ($internalfield, $apply_cgi, $add_button_text, $val_label, $chooser_mode, $formidx) = @_;
    my $configfield = &internal_to_config($internalfield);
    my $count=0;
    my $edit_link;
    my $hidden_edit_input_fields;
    my $formid = $internalfield . "_form";
    print &ui_form_start( $apply_cgi . "?tab=$internalfield", "post", undef, "id='$formid'" );
    my @list_link_buttons = &list_links( "sel", $formidx );
    my ($file_chooser_button, $hidden_add_input_fields) = &add_file_chooser_button( &text("add_", $add_button_text), "new_" . $internalfield, $chooser_mode, $formid );
    print &ui_links_row(\@list_link_buttons);
    print $hidden_add_input_fields;
    print $file_chooser_button;
    print &ui_columns_start( [ 
        "",
        $text{"enabled"}, 
        $val_label, 
        # "full" 
    ], 100, undef, undef, &ui_columns_header( [ &show_title_with_help($internalfield, $configfield) ], [ 'class="table-title" colspan=3' ] ), 1 );

    foreach my $item ( @{$dnsmconfig{$configfield}} ) {
        local @cols;
        push ( @cols, &ui_checkbox("enabled", "1", "", $item->{"used"}?1:0, undef, 1) );
        # edit_file_chooser_link(text, input, type, current_value, cfg_idx, formid, [chroot], [addmode])
        ($edit_link, $hidden_edit_input_fields) = &edit_file_chooser_link($item->{"val"}, $internalfield, $chooser_mode, $item->{"val"}, $count, $formid);
        push ( @cols, $edit_link );
        print &ui_clickable_checked_columns_row( \@cols, \@tds, "sel", $count );
        $count++;
    }
    print &ui_columns_end();
    print &ui_links_row(\@list_link_buttons);
    print $hidden_add_input_fields;
    print $file_chooser_button;
    print "<p>" . $text{"with_selected"} . "</p>";
    print &ui_submit($text{"button_enable_sel"}, "enable_sel_$internalfield");
    print &ui_submit($text{"button_disable_sel"}, "disable_sel_$internalfield");
    print &ui_submit($text{"button_delete_sel"}, "delete_sel_$internalfield");
    print $hidden_edit_input_fields;
    print &ui_form_end( );
    print $g;
}

sub do_selected_action {
    my ($internalfields, $sel, $dnsmconfig) = @_;

    foreach my $internalfield ( @{$internalfields}) {
        my $configfield = &internal_to_config($internalfield);
        my $action = $in{"enable_sel_$internalfield"} ? "enable" : $in{"disable_sel_$internalfield"} ? "disable" : $in{"delete_sel_$internalfield"} ? "delete" : "";
        if ($action ne "") {
            @{$sel} || &error($text{'selected_none'});

            &update_selected($configfield, $action, $sel, $dnsmconfig);
            last;
        }
    }
}

=head2 ui_clickable_checked_columns_row($columns, $tdtags, checkname, checkvalue, [checked?], [disabled], [tags])
=cut
sub ui_clickable_checked_columns_row {
    my ($columns, $tdtags, $checkname, $checkvalue, $checked, $disabled, $tags) = @_;

    $checkname = $checkname || "sel";

    my $custom_clickable_td_cb = "class=\"ui_checked_checkbox flexed clickable_tr" . ($checked ? " clickable_tr_selected" : "") . "\"";
    my $custom_clickable_td = 'class="cursor-pointer clickable-td"';
    my @custom_clickable_tds = ( $custom_clickable_td_cb );

    my @cols = (
        # ui_checkbox(name, value, label, selected?, [tags], [disabled?])
        '<div class="wh-100p flex-wrapper flex-centered flex-start">' . &ui_checkbox($checkname, $checkvalue, undef, ($checked)?1:0, $tags, $disabled, ' thick' ) . '</div>',
        @{ $columns }
    );
    if ($tdtags) {
        @custom_clickable_tds = ( $custom_clickable_td_cb, @{ $tdtags } );
    }
    else {
        foreach my $col (@{ $columns }) {
            push ( @custom_clickable_tds, $custom_clickable_td );
        }
    }

    # return &ui_columns_row( \@cols, ($tdtags ? $tdtags : \@custom_clickable_tds) );
    return &ui_columns_row( \@cols, \@custom_clickable_tds );
}

sub show_title_with_help {
    my ($internalfield, $configfield) = @_;
    return $text{"p_desc_$internalfield"} . &ui_help($configfield . ": " . $text{"p_man_desc_$internalfield"})
}

sub show_label_with_help {
    my ($internalfield, $configfield) = @_;
    return $text{"p_label_$internalfield"} . &ui_help($configfield . ": " . $text{"p_man_desc_$internalfield"})
}

sub get_max_columns {
    my ($configfields) = @_;
    my $current_max = 0;
    foreach my $configfield ( @{ $configfields } ) {
        my $internalfield = &config_to_internal($configfield);
        if ($current_max <= @{ %configfield_fields{$internalfield}->{"param_order"} }) {
            $current_max = @{ %configfield_fields{$internalfield}->{"param_order"} };
        }
    }
    return $current_max;
}

sub custom_theme_ui_links_row {
    my ($links, $nopuncs) = @_;
    my $link = "<a";
    if (ref($links)) {
        if (string_contains("@$links", $link)) {
            @$links =
              map {string_contains($_, $link) ? $_ : "<span class=\"btn btn-success ui_link ui_link_empty\">$_</span>"}
              @$links;
            return @$links ? "<div class=\"btn-group ui_links_row\" role=\"group\">" . join("", @$links) . "</div>\n" :
              "";
        } else {
            if ($nopuncs == 1) {
                return @$links ? join(", ", @$links) . "\n" : "";
            } elsif ($nopuncs == 2) {
                return @$links ? join(" ", @$links) . "\n" : "";
            } else {
                my $dot = ".";
                if (scalar(@$links) == 1) {
                    $dot = "";
                }
                return @$links ? join(", ", @$links) . "$dot\n" : "";
            }
        }
    }
}

sub icon_if_disabled {
    my ($section) = @_;
    my $icon = "";
    if (%dnsmconfig{$section . "_disabled"} && $config{"show_" . $section . "_disabled"}) {
        my $page = %dnsmconfig{$section . "_disabled_ifield_page"};
        my $tab = %dnsmconfig{$section . "_disabled_ifield_tab"};
        &load_theme_library();
        $icon = &disabled_icon($section, $page, $tab, $text{$section . "_disabled_help"});
    }
    return $icon;
}

sub wrap_warning {
    my ($txt) = @_;
    my $help = $_[1] ? " " . &ui_help($_[1]) : "";
    my $classes = $_[2] ? $_[2] : $warn_class;
    return " <div " . &get_class_tag([$dnsm_header_warn_box_class, $classes]) . ">" . $txt . $help . "</div>"
}

sub disabled_icon {
    my ($section, $page, $tab, $title) = @_;
    my $nav = %{%dnsmnav{$section}}{$page};
    my $link_target = $nav->{"cgi_name"};
    if ($nav->{"tab"}) {
        $link_target .= "?tab=" . $nav->{"tab"}->{$tab};
    }
    return (
"<sup class=\"ui_help dnsm-" . $section . "-disabled\" dnsm-link-target=\"" . $link_target . "\" data-container=\"body\" data-placement=\"auto right\" data-title=\"$title\" data-toggle=\"tooltip\"><i class=\"fa fa-0_80x fa-ban cursor-help\"></i></sup>"
    );
}

