#
# dnsmasq-lib.pl
#
# dnsmasq webmin module library module
#

BEGIN { push(@INC, ".."); };
use WebminCore;
init_config();
our %access = &get_module_acl();
require 'parse-config-lib.pl';

our @radiodefaultno = ( 0, "Default" );
our @radioyes = ( 1, "Yes" );
our @defaultoryes = ( \@radiodefaultno, \@radioyes );
# our @radiodefaultyes = ( 1, "Default" );
# our @radiono = ( 0, "No" );
# our @defaultorno = ( \@radiodefaultyes, \@radiono );
our @radioval = ( 1, " " );
our @defaultorval = ( \@radiodefaultno, \@radioval );
our $td_left = "style=\"text-align: left; width: auto;\"";
our $td_right = "style=\"text-align: right; width: auto;\"";

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
    return undef if ($config{'restart_pos'} == 2);
    my $args = "redir=".&urlize(&this_url());
    if (&is_dnsmasq_running()) {
        return ($access{'restart'} ?
            "<a href='restart.cgi?" . $args . "'>" . $text{"lib_buttac"} . "</a>" : "").
            ($access{'start'} ?
            "<a href='stop.cgi?" . $args . "'>" . $text{"lib_buttsd"} . "</a>" : "");
        # return "<a href=\"restart.cgi?$args\">$text{"lib_buttac"}</a><br>\n".
        #     "<a href=\"stop.cgi?$args\">$text{"lib_buttsd"}</a>\n";
    }
    else {
        return $access{'start'} ?
            "<a href='start.cgi?" . $args . "'>" . $text{"lib_buttsd1"} . "</a>" : "";
        # return "<a href=\"start.cgi?$args\">$text{"lib_buttsd1"}</a>\n";
    }
}

# Returns the process ID if dnsmasq is running
sub is_dnsmasq_running {
    my $dnsmconfig = &parse_config_file();

    # Find all possible PID files
    my @pidfiles;
    my $pidstruct = &find_config("pid_filename", $dnsmconfig);
    push(@pidfiles, $pidstruct->{'values'}->[0]) if ($pidstruct);
    my $def_pidstruct = &find_config("pid_filename", $dnsmconfig);
    push(@pidfiles, $def_pidstruct->{'values'}->[0]) if ($def_pidstruct);
    push(@pidfiles, split(/\s+/, $config{'pid_file'})) if ($config{'pid_file'});
    @pidfiles = grep { $_ ne "none" } @pidfiles;

    # Try check one
    foreach my $pidfile (@pidfiles) {
        my $pid = &check_pid_file($pidfile);
        return $pid if ($pid);
    }

    if (!@pidfiles) {
        # Fall back to checking for dnsmasq process
        my ($pid) = &find_byname("dnsmasq");
        return $pid;
    }

    return 0;
}

# Returns the structure(s) with some name
# disabled mode 0 = only enabled, 1 = both, 2 = only disabled,
# 3 = disabled and tags
sub find_config {
    my ($name, %conf, $mode) = @_;
    $mode ||= 0;
    my @rv;
    my $c;
    my $k;
    while (($k,$c) = each (%conf)) {
        if ($c->{'name'} eq $name) {
            push(@rv, $c);
        }
    }
    if ($mode == 0) {
        @rv = grep { $_->{'enabled'} && !$_->{'tag'} } @rv;
    }
    elsif ($mode == 1) {
        @rv = grep { !$_->{'tag'} } @rv;
    }
    elsif ($mode == 2) {
        @rv = grep { !$_->{'enabled'} && !$_->{'tag'} } @rv;
    }
    elsif ($mode == 3) {
        @rv = grep { !$_->{'enabled'} } @rv;
    }
    return @rv ? wantarray ? @rv : $rv[0]
            : wantarray ? () : undef;
}

=head2 update(lineno, text, file_arr_ref, action)

  update the config file array

=item lineno       - the line number (array index) to update; -1 to add

=item text         - the new contents of the line

=item file_arr_ref - reference to the array to change

=item action       - 0 = normal
                     1 = put a comment marker ('#') at start of line
                     2 = delete the line

=back

=cut

sub update {
    my ($lineno, $text, $file_arr_ref, $action) = @_;
    my $line;

    if ($action == 2) {
        if ($lineno >= 0) {
            splice(@$file_arr_ref, $lineno - 1, 1);
        }
    }
    else {
        $line = $text eq "" ? @$file_arr_ref[$lineno - 1] : $text;
        # always start with uncommented, then comment if needed
        $line =~ s/^#*//g ;
        if ( $action == 1 ) {
            $line = "#" . $line;
        }
        # elsif ( $action == 0 ) {
        #     $line =~ s/^#*//g ;
        # }
        if ( $lineno < 0 ) {
            push @$file_arr_ref, $line;
        }
        else {
            @$file_arr_ref[$lineno - 1]=$line;
        }
    }
} # end of sub update

=head2 update_selected(itemname, action, selected_idxes, dnsmconfig)

  update multiple selected items
  When changing (enable, disable, delete) multiple items, we don't want to keep
  opening a config file, changing one item, and then closing it. Because there
  could be both multiple files and many selected items, it's more efficient to open
  each file, make all changes that correspond to just that file, and then close it.

=over

=item itemname       - dnsmasq option name

=item action         - enable, disable, delete

=item selected_idxes - array reference of selected item indexes

=item dnsmconfig     - reference to full config hash

=back

=cut

sub update_selected {
    my ($itemname, $action, $selected_idxes, $dnsmconfig) = @_;
    my @conf_filenames;
    my $actioncode = $action eq "enable" ? 0 : $action eq "disable" ? 1 : $action eq "delete" ? 2 : -1;
    foreach my $selected_idx (@$selected_idxes) {
        my $sourcefile = $dnsmconfig{$itemname}[$selected_idx]->{"file"};
        if (! grep { /^$sourcefile$/ } ( @conf_filenames ) ) {
            push @conf_filenames, $sourcefile;
        }
    }
    foreach my $conf_filename (@conf_filenames) {
        my $file_arr = &read_file_lines($conf_filename);
        # if deleting - since we're using index - they must be handled in reverse
        # if not deleting, it doesn't matter
        my @reversed_selected_idxes = reverse @$selected_idxes;
        foreach my $selected_idx (@reversed_selected_idxes) {
            my $item = $dnsmconfig{$itemname}[$selected_idx];
            if ($item->{"file"} eq $conf_filename) {
                &update( $item->{"line"}, "",
                    \@$file_arr, $actioncode );
            }
        }
        &flush_file_lines();
    }
}

sub input_to_config {
    my $c = @_[0];
    $c =~ s/_/-/g ;
    return $c;
}

sub config_to_input {
    my $i = @_[0];
    $i =~ s/-/_/g ;
    return $i;
}

sub update_booleans {
    my $result;
    my ( $all, $enabled, $dnsmconfig ) = @_;
    my @conf_filenames = ();
    foreach my $configfield ( @$all ) {
        # $result .= $configfield . ":" . $dnsmconfig{"$configfield"};
        my $sourcefile = $dnsmconfig{"$configfield"}->{"file"};
        if ( ! grep { /^$sourcefile$/ } ( @conf_filenames ) ) {
            push @conf_filenames, $sourcefile;
        }
    }
    foreach my $conf_filename ( @conf_filenames ) {
        my $file_arr = &read_file_lines($conf_filename);
        foreach my $configfield ( @$all ) {
            my $item = $dnsmconfig{"$configfield"};
            if ($item->{"file"} eq $conf_filename) {
                &update( $item->{"line"}, $configfield,
                    \@$file_arr, ( ( grep { /^$configfield$/ } ( @$enabled ) ) ? 0 : 1 ) );
            }
        }
        &flush_file_lines();
    }
    return $result;
}

sub update_simple_vals {
    my $result;
    my ( $all, $enabled, $dnsmconfig ) = @_;
    my @conf_filenames = ();
    foreach my $configfield ( @$all ) {
        my $sourcefile = $dnsmconfig{"$configfield"}->{"file"};
        if ( ! grep { /^$sourcefile$/ } ( @conf_filenames ) ) {
            push @conf_filenames, $sourcefile;
        }
    }
    foreach my $conf_filename ( @conf_filenames ) {
        my $file_arr = &read_file_lines($conf_filename);
        foreach my $configfield ( @$all ) {
            my $inputfield = &config_to_input($configfield);
            my $item = $dnsmconfig{"$configfield"};
            if ($item->{"file"} eq $conf_filename && ($item->{"val_optional"} || $in{$inputfield . "val"}  ) ) {
                &update( $item->{"line"}, "$configfield" . ( $in{$inputfield . "val"} eq "" ? "" : "=" . $in{$inputfield . "val"}),
                    \@$file_arr, ( ( grep { /^$configfield$/ } ( @$enabled ) ) ? 0 : 1 ) );
            }
        }
        &flush_file_lines();
    }
}

=head2 add_to_list( configfield, val )
  Adds a new entry value to the configuration
=cut
sub add_to_list {
    my ( $configfield, $val ) = @_;
    my $cfn = $config_filename;
    if (@{$dnsmconfig{$configfield}} > 0) {
        $cfn = $dnsmconfig{$configfield}[0]->{"file"};
    }
    my $cf = &read_file_lines($cfn);
    &update(-1, "$configfield=$val", \@$cf, 0);
    &flush_file_lines();

}
# apply_configuration()
# Activate the current dnsmasq configuration
sub apply_configuration {
    if ($config{'dnsmasq_restart'}) {
        my $out = &backquote_logged("$config{'dnsmasq_restart'} 2>&1");
        return "<pre>".&html_escape($out)."</pre>" if ($?);
    }
    else {
        my $out = &backquote_logged("$config{'dnsmasq_path'} -C $config{'config_file'} 2>&1");
        return "<pre>".&html_escape($out)."</pre>"
            if ($? && $out !~ /warning/i);
    }
    return undef;
}

sub send_to_error {
    my ($line, $err_type, $returnto, $returnlabel) = @_;
    my $line = "error.cgi?line=" . &urlize($line);
    $line .= "&type=" . &urlize($err_type);
    $line .= "&returnto=" . $returnto;
    $line .= "&returnlabel=" . &urlize($returnlabel);
    &redirect( $line );
    exit;
}

sub this_url {
    my $url = $ENV{'SCRIPT_NAME'};
    if (defined($ENV{'QUERY_STRING'})) {
        $url .= "?$ENV{'QUERY_STRING'}";
    }
    return $url;
}

# list_auth_users(file)
sub list_auth_users {
    my ($file) = @_;
    my @rv;
    my $lnum = 0;
    my $fh = "USERS";
    &open_readfile($fh, $file);
    while(<$fh>) {
        if (/^(#*)([^:]+):(\S+)/) {
            push(@rv, { 'user' => $2, 'pass' => $3,
                    'enabled' => !$1, 'line' => $lnum });
            }
        $lnum++;
    }
    close($fh);
    if ($config{'sort_conf'}) {
        return sort { $a->{'user'} cmp $b->{'user'} } @rv;
    }
    else {
        return @rv;
    }
}

# can_access(file)
sub can_access {
    my ($file) = @_;
    my @f = grep { $_ ne '' } split(/\//, $file);
    return 1 if ($access{'root'} eq '/');
    my @a = grep { $_ ne '' } split(/\//, $access{'root'});
    for(my $i=0; $i<@a; $i++) {
        return 0 if ($a[$i] ne $f[$i]);
    }
    return 1;
}

sub select_none_link {
    return &theme_select_none_link(@_) if (defined(&theme_select_none_link));
    my ($field, $form, $text) = @_;
    $form = int($form);
    $text ||= $text{'ui_selnone'};
    # return "<a class='select_none' href='#' onClick='javascript:var ff = document.forms[$form].$field; ff.checked = false; for(i=0; i<ff.length; i++) { if (!ff[i].disabled) { ff[i].checked = false; } } return false;'><i class='fa fa-fw fa-square-o'> </i>$text</a>";
    # if (defined(&theme_select_all_link) && defined(&theme_select_invert_link)) {
    #     return "<a class='select-none' href='#' onClick='javascript:theme_select_all_link($form, \"$field\"); theme_select_invert_link($form, \"$field\"); return false;'>$text</a>";
    # }
    # else {
    #     return "<a class='select-none' href='#' onClick='javascript:select_all_link($form, \"$field\"); select_invert_link($form, \"$field\"); return false;'>$text</a>";
    # }
    my $output = "<a class='select-none' href='#' onClick='javascript:theme_select_all_link($form, \"$field\"); theme_select_invert_link($form, \"$field\"); return false;'>";
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
        push(@links, ui_link("$addcgi?new=1&what=$what&where=$where",$link_text));
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
    my $mover;
    if ( $total == 1 ) {
        return "<img src=images/gap.gif>";
    }
    if( $current_index == ($total - 1) ) {
        $mover = "<img src=images/gap.gif>";
    }
    else {	
        $mover = "<a href='$url?idx=$current_index&t=".$total."&dir=down'><img src=images/down.gif border=0></a>";
    }
    if( $current_index == 0 ) {
        $mover .= "<img src=images/gap.gif>";
    }
    else {
        $mover .= "<a href='$url?idx=$current_index&t=".$total."&dir=up'><img src=images/up.gif border=0></a>";
    }
    return $mover;
}

=head2 add_file_chooser_button(text, input, type, [form], [chroot], [addmode])

  Return HTML for a button that pops up a file chooser when clicked, and places
  the selected filename into another HTML field. The parameters are :

=over

=item text - Text to appear in the button.

=item input - Name of the form field to store the filename in.

=item type - 0 for file or directory chooser, or 1 for directory only.

=item formid - Id of the form containing the button.

=item chroot - If set, the chooser will be limited to this directory.

=item addmode - If set to 1, the selected filename will be appended to the text box instead of replacing its contents.

=back

=cut

sub add_file_chooser_button {
    my ($text, $input, $type, $formid)  = @_;
    my $chroot = defined($_[4]) ? $_[4] : "/";
    my $add    = int($_[5]);
    my $link   = "chooser.cgi?add=$add&type=$type&chroot=$chroot&file=\"+encodeURIComponent(ifield.value)";

    my $file_chooser_button = "<button class='btn btn-inverse btn-tiny file-chooser-button chooser_button' ";
    $file_chooser_button .= "style='min-width:90px; width:auto; height:33px;' onClick='ifield = \$( \"#$input\" )[0]; ";
    $file_chooser_button .= "chooser = window.open(\"$theme_webprefix/$link, \"chooser\"); chooser.ifield = ifield; window.ifield = ifield;'>";
    $file_chooser_button .= "$text</button>\n";

    my $hidden_input_fields = "";
    # $hidden_input_fields .= "<input type=\"text\" name=\"$input\" id=\"$input\" class=\"new-file-input\" onchange=\"console.log('submitting!'); \$(this).form().submit(); return false;\"></input>";
    $hidden_input_fields .= "<input type=\"hidden\" name=\"$input\" class=\"new-file-input\"></input>";
    $hidden_input_fields .= "";

    my $submit_script = "<script>";
    # $submit_script .= $formid."_".$input."_intvl = setInterval(function() {\n\tif(\$( \"#$input\" ).val()) {\n\t\tclearInterval(".$formid."_".$input."_intvl);\n\t\tdelete ".$formid."_".$input."_intvl;\n\t\tsetTimeout(function() {\n\t\t\t\$( \"#$formid\" ).submit();\n\t\t\t\$( \"#$input\" ).val('');\n\t\t}, 0);\n\t}\n}, 50);";
    $submit_script .= $formid."_".$input."_intvl = setInterval(function() {\n\t\$(\".new-file-input\").each(function(){\n\t\tif(\$(this).val()) {\n\t\t\tclearInterval(".$formid."_".$input."_intvl);\n\t\t\tdelete ".$formid."_".$input."_intvl;\n\t\t\tsetTimeout(function() {\n\t\t\t\t\$( \"#$formid\" ).submit();\n\t\t\t\t\$(this).val('');\n\t\t}, 0);\n\t\t}\n\t});\n}, 50);";
    $submit_script .= "</script>";
    return ($file_chooser_button, $hidden_input_fields, $submit_script);
}

=head2 add_interface_chooser_button(text, input, [form], [addmode])

  Return HTML for a button that pops up an interface chooser when clicked, and places
  the selected filename into another HTML field. The parameters are :

=over

=item text - Text to appear in the button.

=item input - Name of the form field to store the filename in.

=item formid - Id of the form containing the button.

=item addmode - If set to 1, the selected interface will be appended to the text box instead of replacing its contents.

=back

=cut

sub add_interface_chooser_button {
    my ($text, $input, $formid)  = @_;
    my $add    = int($_[3]);
    my $link   = "net/interface_chooser.cgi?multi=$add&interface=";

    my $iface_chooser_button = "<button class='btn btn-inverse btn-tiny iface-chooser-button chooser_button' ";
    $iface_chooser_button .= "style='min-width:90px; width:auto; height:33px;' onClick='ifield = \$( \"#$input\" )[0]; ";
    $iface_chooser_button .= "chooser = window.open(\"$theme_webprefix/$link, \"chooser\"); chooser.ifield = ifield; window.ifield = ifield;";
    $iface_chooser_button .= "'>$text</button>\n";

    my $hidden_input_fields = "";
    # $hidden_input_fields .= "<input type=\"text\" name=\"$input\" id=\"$input\" class=\"new-file-input\" onchange=\"console.log('submitting!'); \$(this).form().submit(); return false;\"></input>";
    $hidden_input_fields .= "<input type=\"hidden\" name=\"$input\" id=\"$input\" class=\"new-iface-input\"></input>";
    $hidden_input_fields .= "";

    my $submit_script = "<script>";
    # $submit_script .= $formid."_".$input."_intvl = setInterval(function() {\n\tif(\$( \"#$input\" ).val()) {\n\t\tclearInterval(".$formid."_".$input."_intvl);\n\t\tdelete ".$formid."_".$input."_intvl;\n\t\tsetTimeout(function() {\n\t\t\t\$( \"#$formid\" ).submit();\n\t\t\t\$( \"#$input\" ).val('');\n\t\t}, 0);\n\t}\n}, 50);";
    $submit_script .= $formid."_".$input."_intvl = setInterval(function() {\n\t\$(\".new-iface-input\").each(function(){\n\t\tif(\$(this).val()) {\n\t\t\tclearInterval(".$formid."_".$input."_intvl);\n\t\t\tdelete ".$formid."_".$input."_intvl;\n\t\t\tsetTimeout(function() {\n\t\t\t\t\$( \"#$formid\" ).submit();\n\t\t\t\t\$(this).val('');\n\t\t}, 0);\n\t\t}\n\t});\n}, 50);";
    $submit_script .= "</script>";
    return ($iface_chooser_button, $hidden_input_fields, $submit_script);
}

=head2 edit_item_popup_window_link(url, context, formid, link_text, width, height, [scrollbars], field-mappings)

    Returns HTML for a link that will popup, hidden fields, and some JS to handle it 
    for a simple edit window of some kind.

=over

=item url - Base URL of the popup window's contents

=item context - Keyword that identifies what to edit; handling must be defined in list_item_edit_popup.cgi

=item formid - Id of the form on the source page to submit

=item link_text - Text to appear in link

=item width - Width of the window in pixels

=item height - Height in pixels

=item scrollbars - Set to 1 if the window should have scrollbars

=cut

sub edit_item_popup_window_link {
    my ($url, $context, $formid, $link_text, $w, $h, $scrollbars) = @_;
    my $scrollyn = $scrollbars ? "yes" : "no";

    my $link = "<span onClick='";
    my $sep = $url =~ /\?/ ? "&" : "?";
    $url .= $sep . "context=$context";
    $url .= "&formid=$formid";
    $link .= "var h = $h;var w = $w;var left = (window.innerWidth/2)-(w/2);var top = (window.innerHeight/2)-(h/2);";
    $link .= "editor = window.open(\"$url\"";
    $link .= ", \"editor\", \"location=no,status=no,toolbar=no,menubar=no,scrollbars=$scrollyn,resizable=yes,left=\"+left+\",top=\"+top+\",width=$w,height=$h\"); ";
    $link .= "return false;'>$link_text</span>";
    return $link;
}

=head2 edit_item_link(link_text, context, title, idx, formid, width, height, field-mappings)

    Returns HTML for a link that will popup, hidden fields, and some JS to handle it 
    for a simple edit window of some kind.

=over

=item link_text - Text to appear in link

=item context - Keyword that identifies what to edit; handling must be defined in list_item_edit_popup.cgi

=item title - Text to appear in the popup window title

=item idx - Index of the item to edit

=item formid - Id of the form on the source page to submit

=item width - Width of the window in pixels

=item height - Height in pixels

=back

=cut

sub edit_item_link {
    my ($link_text, $context, $title, $idx, $formid, $w, $h, $fields) = @_;
    my $scrollyn = $scrollbars ? "yes" : "no";

    my $link = edit_item_popup_window_link("list_item_edit_popup.cgi?action=edit&idx=$idx&title=$title", $context, $formid, $link_text, $w, $h, 0);

    my $hidden_input_fields = "<div>\n";
    foreach my $fieldname ( @$fields ) {
        $hidden_input_fields .= "<input type=\"hidden\" name=\"" . $context . "_" . $fieldname . "\" class=\"edit-item-val\"></input>";
    }
    $hidden_input_fields .= "</div>\n";

    my $edit_script = "<script>\n";
    $edit_script .= "function submit_$formid(vals) {";
    $edit_script .= "  vals.forEach((o) => {";
    $edit_script .= "    let f=o.f;let v=o.v;";
    $edit_script .= "    \$(\"#$formid input[name=\"+f+\"]\").val(v);";
    $edit_script .= "  });";
    $edit_script .= "  \$(\"#$formid\").submit();";
    $edit_script .= "}\n";
    $edit_script .= "</script>\n";
    return ($link, $hidden_input_fields, $edit_script);
}

=head2 add_item_popup_window_button(url, context, formid, button_text, width, height, [scrollbars], field-mappings)

    Returns HTML for a button that will popup a simple list item add window of some kind.

=over

=item url - Base URL of the popup window's contents

=item context - Keyword that identifies what to add; handling must be defined in list_item_add_popup.cgi

=item formid - Id of the form on the source page to submit

=item button_text - Text to appear in button

=item width - Width of the window in pixels

=item height - Height in pixels

=item scrollbars - Set to 1 if the window should have scrollbars

=item field-mappings - See below

=back

=over 4

=item The field-mappings parameter is an array ref of array refs containing

=item - Attribute to assign field to in the popup window

=item - Form field name

=item - CGI parameter to URL for value, if any

=back

=cut

sub add_item_popup_window_button {
    my ($url, $context, $formid, $button_text, $w, $h, $scrollbars, $fields) = @_;
    my $scrollyn = $scrollbars ? "yes" : "no";

    my $rv = "<a class='btn btn-inverse btn-tiny add-item-button' href=\"#\" onClick='";
    my $sep = $url =~ /\?/ ? "&" : "?";
    $url .= $sep . "context=$context";
    $url .= "&formid=$formid";
    $rv .= "var h = $h;var w = $w;var left = (window.innerWidth/2)-(w/2);var top = (window.innerHeight/2)-(h/2);";
    $rv .= "chooser = window.open(\"$url\"";
    $rv .= ", \"chooser\", \"location=no,status=no,toolbar=no,menubar=no,scrollbars=$scrollyn,resizable=yes,left=\"+left+\",top=\"+top+\",width=$w,height=$h\"); ";
    $rv .= "'>$button_text</a>";
    return $rv;
}

=head2 add_item_button(buttontext, context, title, width, height, formid, field-mappings)

    Returns HTML for a button that will popup a window, hidden fields, and some JS to handle it 
    for entry of a new item of some kind.

=over

=item buttontext - Text to appear in button

=item context - Keyword that identifies what to add; handling must be defined in list_item_add_popup.cgi

=item title - Text to appear in the popup window title

=item width - Width of the window in pixels

=item height - Height in pixels

=item formid - Id of the form on the source page to submit

=item fields - Array reference of field names i.e., [ "new_tag", "new_vendorclass" ]; must be handled in form's submit target

=back

=cut

sub add_item_button {
    my ($button_text, $context, $title, $w, $h, $formid, $fields) = @_;
    my @fieldmapping = ();
    foreach my $fieldname ( @$fields ) {
        push( @fieldmapping, [ $fieldname, $fieldname ] );
    }
    my $button = &add_item_popup_window_button("list_item_edit_popup.cgi?action=add&title=$title", $context, $formid, $button_text, $w, $h, 0, \@fieldmapping );
    my $hidden_input_fields = "<div>\n";
    foreach my $fieldname ( @$fields ) {
        $hidden_input_fields .= "<input type=\"hidden\" name=\"new_" . $context . "_" . $fieldname . "\" class=\"add-item-val\"></input>";
    }
    $hidden_input_fields .= "</div>\n";

    my $add_new_script = "<script>\n";
    $add_new_script .= "function submit_new_$formid(vals) {";
    $add_new_script .= "  vals.forEach((o) => {";
    $add_new_script .= "    let f=o.f;let v=o.v;";
    $add_new_script .= "    \$(\"#$formid input[name=\"+f+\"]\").val(v);";
    $add_new_script .= "  });";
    $add_new_script .= "  \$(\"#$formid\").submit();";
    $add_new_script .= "}\n";
    $add_new_script .= "</script>\n";
    return ($button, $hidden_input_fields, $add_new_script);
}

=head2 add_js(uses_select_none, uses_add_item, uses_add_file, uses_add_interface, formid, context)

=cut

sub add_js {
    my ($uses_select_none, $uses_add_item, $uses_add_file, $uses_add_interface, $formid, $context) = @_;
    my $script = "";
    # $script .= "<div>\n";
    $script .= "<script type='text/javascript'>\n";
    $script .= "\$(document).ready(function() {\n";
    $script .= "  setTimeout(function() {\n";
    if ($uses_select_none == 1) {
        $script .= "    \$(\"<i class='fa fa-minus-square -cs vertical-align-middle' style='margin-right: 8px;'></i>\").prependTo(\".select-none\");\n";
    }
    if ($uses_add_item == 1) {
        $script .= "    \$(\"<i class='fa fa-plus -cs vertical-align-middle' style='margin-right: 8px;'></i>\").prependTo(\".add-item-button\");\n";
    }
    if ($uses_add_file == 1) {
        $script .= "    \$(\"<i class='fa fa-fw fa-files-o -cs vertical-align-middle' style='margin-right:5px;'></i>\").prependTo(\".file-chooser-button\");\n";
        # $script .= "    \$(\".new-file-input\").each(function(){\$(this).on(\"input\", function(){this.form.submit();return false;});});";
        $script .= "    \$(\".new-file-input\").each(function(){\$(this).parent().appendTo(\$(this).parent().prevUntil(\".btn-group\").last().prev());});";
    }
    if ($uses_add_interface == 1) {
        $script .= "    \$(\"<i class='fa fa2 fa2-plus-network vertical-align-middle' style='margin-right:5px;'></i>\").prependTo(\".iface-chooser-button\");\n";
        # $script .= "    \$(\".new-iface-input\").each(function(){\$(this).on(\"input\", function(){this.form.submit();return false;});});";
        $script .= "    \$(\".new-iface-input\").each(function(){\$(this).parent().appendTo(\$(this).parent().prevUntil(\".btn-group\").last().prev());});";
    }
    $script .= "  }, 5);\n";
    $script .= "\n";
    $script .= "});\n";
    $script .= "</script>\n";
    # $script .= "</div>\n";
    return $script;
}

sub string_contains
{
    return (index($_[0], $_[1]) != -1);
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

1;
