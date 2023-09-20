#!/usr/bin/perl
#
#    DNSMasq Webmin Module - dnsmasq-lib.pl; dnsmasq webmin module library
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

BEGIN { push(@INC, ".."); };
use POSIX qw(ceil getgroups cuserid);
use URI::Escape;
use File::Basename;
use WebminCore;

use constant ERR_FILE_PERMS => 1;

init_config();
# our $module_config_directory;
our %access = &get_module_acl();
require 'parse-config-lib.pl';
require 'dnsmasq-ui.pl';

$last_config_change_flag = $module_var_directory."/config-flag";
$last_restart_time_flag = $module_var_directory."/restart-flag";
$last_update_check_flag = $module_var_directory."/update-check-flag";

sub config_post_save {
    my ($newconfig, $oldconfig) = @_;
    if ($oldconfig->{"check_for_updates"} ne "1" && $newconfig->{"check_for_updates"} eq "1") {
        &check_for_updated_version(1);
    }
    elsif ($oldconfig->{"check_for_updates"} eq "1" && $newconfig->{"check_for_updates"} ne "1") {
        my %tempconfig;
        &lock_file("$module_config_directory/config");
        &read_file("$module_config_directory/config", \%tempconfig);
        delete($tempconfig{"dnsmasq_latest_url"});
        &write_file("$module_config_directory/config", \%tempconfig);
        &unlock_file("$module_config_directory/config");
    }
}

=head2 find_dnsmasq()
    Returns the path to the dnsmasq executable
=cut
sub find_dnsmasq{
    return $config{'dnsmasq_path'}
        if (-x &translate_filename($config{'dnsmasq_path'}) &&
            !-d &translate_filename($config{'dnsmasq_path'}) &&
            &has_command($config{'dnsmasq_path'}));
    return undef;
}

sub find_config_file {
    return (-e $config{'config_file'} && -r $config{'config_file'});
}

=head2 get_pid_file()
    Returns the path to the PID file (without any translation)
=cut
sub get_pid_file{
    return $config{'pid_filename'} if ($config{'pid_filename'});
    local $pidfilestr = $dnsmconfig->{"pid-file"}->{"val"};
    return $pidfile = $pidfilestr ? $pidfilestr : "/var/run/dnsmasq/dnsmasq.pid";
}

=head2 restart_dnsmasq()
    Re-starts DNSMasq, and returns undef on success or an error message on failure
=cut
sub restart_dnsmasq {
    if ($config{'dnsmasq_restart'} eq 'restart') {
        # Call stop and start functions
        local $err = &stop_dnsmasq();
        return $err if ($err);
        local $stopped = &wait_for_dnsmasq_stop();
        local $err = &start_dnsmasq();
        return $err if ($err);
    }
    elsif ($config{'dnsmasq_restart'}) {
        # Use the configured start command
        &clean_environment();
        local $out = &backquote_logged("$config{'dnsmasq_restart'} 2>&1");
        &reset_environment();
        if ($?) {
            return "<pre>".&html_escape($out)."</pre>";
        }
    }
    &restart_last_restart_time();
    return undef;
}

=head2 reload_dnsmasq_files()
    Clears DNSMasq cache and then re-loads /etc/hosts and /etc/ethers and any file given by 'dhcp-hostsfile',  
    'dhcp-hostsdir', 'dhcp-optsfile', 'dhcp-optsdir', 'addn-hosts', or 'hostsdir'. The DHCP lease change script
    is called for all existing DHCP leases. If 'no-poll' is set, also re-reads /etc/resolv.conf. Does NOT
    re-read the configuration file. Returns undef on success or an error message on failure
=cut
sub reload_dnsmasq_files {
    if ($config{'dnsmasq_reload_files'}) {
        # Use the configured start command
        &clean_environment();
        local $out = &backquote_logged("$config{'dnsmasq_reload_files'} 2>&1");
        &reset_environment();
        if ($?) {
            return "<pre>".&html_escape($out)."</pre>";
        }
    }
    else {
        # send SIGHUP directly
        local $pidfile = &get_pid_file();
        &open_readfile(PID, $pidfile) || return &text('restart_epid', $pidfile);
        <PID> =~ /(\d+)/ || return &text('restart_epid2', $pidfile);
        close(PID);
        &kill_logged('HUP', $1) || return &text('restart_esig', $1);
    }
    &restart_last_restart_time();
    return undef;
}

=head2 dump_logs()
    Generate a complete cache dump, and returns undef on success or an error message on failure
=cut
sub dump_logs {
    if ($config{'dnsmasq_dump_log'}) {
        # Use the configured start command
        &clean_environment();
        local $out = &backquote_logged("$config{'dnsmasq_dump_log'} 2>&1");
        &reset_environment();
        if ($?) {
            return "<pre>".&html_escape($out)."</pre>";
        }
    }
    else {
        # send SIGUSR1 directly
        local $pidfile = &get_pid_file();
        &open_readfile(PID, $pidfile) || return &text('restart_epid', $pidfile);
        <PID> =~ /(\d+)/ || return &text('restart_epid2', $pidfile);
        close(PID);
        &kill_logged('USR1', $1) || return &text('restart_esig', $1);
    }
    return undef;
}

=head2 rotate_log()
    When logging to a file, DNSMasq will close and reopen the file; returns undef on success or an error message on failure
=cut
sub rotate_log {
    # send SIGUSR2 directly
    local $pidfile = &get_pid_file();
    &open_readfile(PID, $pidfile) || return &text('restart_epid', $pidfile);
    <PID> =~ /(\d+)/ || return &text('restart_epid2', $pidfile);
    close(PID);
    &kill_logged('USR2', $1) || return &text('restart_esig', $1);
    return undef;
}

=head2 stop_dnsmasq()
    Attempts to stop the running DNSMasq process, and returns undef on success or
    an error message on failure
=cut
sub stop_dnsmasq {
    local $out;
    if ($config{'dnsmasq_stop'}) {
        # use the configured stop command
        $out = &backquote_logged("($config{'dnsmasq_stop'}) 2>&1");
        if ($?) {
            return "<pre>".&html_escape($out)."</pre>";
        }
    }
    else {
        # kill the process
        $pidfile = &get_pid_file();
        open(PID, "<".$pidfile) || return &text('stop_epid', $pidfile);
        <PID> =~ /(\d+)/ || return &text('stop_epid2', $pidfile);
        close(PID);
        &kill_logged('TERM', $1) || return &text('stop_esig', $1);
    }
    return undef;
}

=head2 start_dnsmasq()
    Attempts to start DNSMasq, and returns undef on success or an error message
    upon failure.
=cut
sub start_dnsmasq {
    local ($out, $cmd);
    &clean_environment();
    if ($config{'dnsmasq_start'}) {
        # use the configured start command
        if ($config{'dnsmasq_stop'}) {
            # execute the stop command to clear lock files
            &system_logged("($config{'dnsmasq_stop'}) >/dev/null 2>&1");
        }
        $out = &backquote_logged("($config{'dnsmasq_start'}) 2>&1");
        &reset_environment();
        if ($?) {
            return "<pre>".&html_escape($out)."</pre>";
        }
    }
    else {
        # start manually
        local $dnsmasq = &find_dnsmasq();
        $cmd = "$dnsmasq -C $config{'config_file'}";
        local $temp = &transname();
        local $rv = &system_logged("( $cmd ) >$temp 2>&1 </dev/null");
        $out = &read_file_contents($temp);
        unlink($temp);
        &reset_environment();
    }
    # Check if DNSMasq may have failed to start
    local $slept;
    if ($out =~ /\S/ && $out !~ /dnsmasq\s+started/i) {
        sleep(3);
        if (!&is_dnsmasq_running()) {
            return "<pre>".&html_escape($cmd)." :\n".
                    &html_escape($out)."</pre>";
        }
        $slept = 1;
    }
    # # check if startup was successful.
    # sleep(3) if (!$slept);
    # local $conf = &get_config();
    # if (!&is_dnsmasq_running()) {
    #     # Not running..  find out why
    #     local $errorlogstr = &find_directive_struct("ErrorLog", $conf);
    #     local $errorlog = $errorlogstr ? $errorlogstr->{'words'}->[0]
    #                     : "logs/error_log";
    #     if ($out =~ /\S/) {
    #         return "$text{'start_eafter'} : <pre>$out</pre>";
    #     }
    #     elsif ($errorlog eq 'syslog' || $errorlog =~ /^\|/) {
    #         return $text{'start_eunknown'};
    #     }
    #     else {
    #         $errorlog = &server_root($errorlog, $conf);
    #         $out = `tail -5 $errorlog`;
    #         return "$text{'start_eafter'} : <pre>$out</pre>";
    #     }
    # }
    &restart_last_restart_time();
    return undef;
}

# Returns the process ID if DNSMasq is running
sub is_dnsmasq_running {
    # Find all possible PID files
    my @pidfiles;
    my $pidstruct = &find_config("pid-file", $dnsmconfig);
    push(@pidfiles, $pidstruct->{'val'}) if ($pidstruct);
    push(@pidfiles, split(/\s+/, $config{'pid_filename'})) if ($config{'pid_filename'});
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

=head2 wait_for_dnsmasq_stop([secs])
    Wait 30 (by default) seconds for DNSMasq to stop. Returns 1 if OK, 0 if not
=cut
sub wait_for_dnsmasq_stop {
    local $secs = $_[0] || 30;
    for(my $i=0; $i<$secs; $i++) {
        return 1 if (!&is_dnsmasq_running());
        sleep(1);
    }
    return 0;
}

=head2 test_config()
    If possible, test the current configuration and return an error message,
    or undef.
=cut
sub test_config {
    # Test with dnsmasq
    local $dnsmasq = &find_dnsmasq();
    local $cmd = "\"$dnsmasq\" --test";
    local $out = &backquote_command("$cmd 2>&1");
    if ($out && $out !~ /syntax.*\s+ok/i) {
        return $out;
    }
    return undef;
}

=head2 update_last_config_change()
    Updates the flag file indicating when the config was changed
=cut
sub update_last_config_change {
    &open_tempfile(FLAG, ">$last_config_change_flag", 0, 1);
    &close_tempfile(FLAG);
}

=head2 restart_last_restart_time()
    Updates the flag file indicating when the config was changed
=cut
sub restart_last_restart_time {
    &open_tempfile(FLAG, ">$last_restart_time_flag", 0, 1);
    &close_tempfile(FLAG);
}

=head2 needs_config_restart()
    Returns 1 if a restart is needed for sure after a config change
=cut
sub needs_config_restart {
    my @cst = stat($last_config_change_flag);
    my @rst = stat($last_restart_time_flag);
    if (@cst && @rst && $cst[9] > $rst[9]) {
        return 1;
    }
    return 0;
}

=head2 update_last_update_check_time()
    Updates the flag file indicating when a module update check was performed
=cut
sub update_last_update_check_time {
    &open_tempfile(FLAG, ">$last_update_check_flag", 0, 1);
    &close_tempfile(FLAG);
}

=head2 needs_update_check()
    Returns 1 if a module update check is needed
=cut
sub needs_update_check {
    my @lup = stat($last_update_check_flag);
    my $epoc = time();
    my $freq = $config{"update_frequency"} || 1;
    my $max_diff = 60 * 60 * $freq;
    if (@lup && $epoc && ($epoc - $lup[9] > $max_diff)) {
        return 1;
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

=head2 save_update(file, line, val, [action])
=cut
sub save_update {
    my ($file, $line, $val) = @_;
    my $action = $_[3] ? $_[3] : 0;
    my $file_arr = &read_file_lines($file);
    &update($line, $val, \@$file_arr, $action);
    &flush_file_lines();
    &update_last_config_change();
}

=head2 update(lineno, text, file_arr_ref, action)
    update the config file array
        lineno       - the line number (array index) to update; -1 to add
        text         - the new contents of the line, or undef to leave unchanged
        file_arr_ref - reference to the array to change
        action       - 0 = normal
                       1 = put a comment marker ('#') at start of line
                       2 = delete the line

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
        $line =~ s/^#*\s*//g ;
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

=head2 update_selected(configfield, action, selected_idxes, dnsmconfig)
    update multiple selected items
    When changing (enable, disable, delete) multiple items, we don't want to keep
    opening a config file, changing one item, and then closing it. Because there
    could be both multiple files and many selected items, it's more efficient to open
    each file, make all changes that correspond to just that file, and then close it.
        configfield    - dnsmasq option name
        action         - enable, disable, delete
        selected_idxes - array reference of selected item indexes
        dnsmconfig     - reference to full config hash
=cut
sub update_selected {
    my ($configfield, $action, $selected_idxes, $dnsmconfig) = @_;
    my @conf_filenames;
    my $actioncode = $action eq "enable" ? 0 : $action eq "disable" ? 1 : $action eq "delete" ? 2 : -1;
    foreach my $selected_idx (@{$selected_idxes}) {
        my $sourcefile = $dnsmconfig{$configfield}[$selected_idx]->{"file"};
        if (! grep { /^$sourcefile$/ } ( @conf_filenames ) ) {
            push @conf_filenames, $sourcefile;
        }
    }
    foreach my $conf_filename (@conf_filenames) {
        my $file_arr = &read_file_lines($conf_filename);
        # if deleting - since we're using index - they must be handled in reverse
        # if not deleting, it doesn't matter
        my @reversed_selected_idxes = reverse @{$selected_idxes};
        foreach my $selected_idx (@reversed_selected_idxes) {
            my $item = $dnsmconfig{$configfield}[$selected_idx];
            if ($item->{"file"} eq $conf_filename) {
                &update( $item->{"line"}, undef,
                    \@$file_arr, $actioncode );
            }
        }
        &flush_file_lines();
        &update_last_config_change();
    }
}

sub internal_to_config {
    my $c = @_[0];
    $c =~ s/_/-/g ;
    return $c;
}

sub config_to_internal {
    my $i = @_[0];
    $i =~ s/-/_/g ;
    return $i;
}

sub is_integer {
   defined $_[0] && $_[0] =~ /^[+-]?\d+$/;
}

sub update_booleans {
    my $result;
    my ( $page_fields_bools, $sel, $dnsmconfig ) = @_;
    my @conf_filenames = ();
    foreach my $configfield ( @{$page_fields_bools} ) {
        # $result .= $configfield . ":" . $dnsmconfig{"$configfield"};
        my $sourcefile = $dnsmconfig{"$configfield"}->{"file"};
        if ( ! grep { /^$sourcefile$/ } ( @conf_filenames ) ) {
            push @conf_filenames, $sourcefile;
        }
    }
    foreach my $conf_filename ( @conf_filenames ) {
        my $file_arr = &read_file_lines($conf_filename);
        foreach my $configfield ( @{$page_fields_bools} ) {
            my $item = $dnsmconfig{"$configfield"};
            if ($item->{"file"} eq $conf_filename) {
                 # skip this if it:
                 # 1. wasn't selected and 
                 # 2. isn't already in the file
                next if (( ! grep { /^$configfield$/ } ( @{$sel} ) ) && $item->{"line"} == -1);
                &update( $item->{"line"}, $configfield,
                    \@$file_arr, ( ( grep { /^$configfield$/ } ( @{$sel} ) ) ? 0 : 1 ) );
            }
        }
        &flush_file_lines();
        &update_last_config_change();
    }
    return $result;
}

sub update_simple_vals {
    my $result;
    my ( $page_fields_singles, $sel, $dnsmconfig ) = @_;
    my @conf_filenames = ();
    foreach my $configfield ( @{$page_fields_singles} ) {
        my $sourcefile = $dnsmconfig{"$configfield"}->{"file"};
        if ( ! grep { /^$sourcefile$/ } ( @conf_filenames ) ) {
            push(@conf_filenames, $sourcefile);
        }
    }
    foreach my $conf_filename ( @conf_filenames ) {
        my $file_arr = &read_file_lines($conf_filename);
        foreach my $configfield ( @{$page_fields_singles} ) {
            my $internalfield = &config_to_internal($configfield);
            my $item = $dnsmconfig{"$configfield"};

            if ($item->{"file"} eq $conf_filename) {
                my $is_selected = ( grep { /^$configfield$/ } ( @{$sel} ) );
                 # skip this value if it:
                 # 1. wasn't selected and 
                 # 2a. isn't already in the file or
                 # 2b. is in the file but is disabled
                next if ( !$is_selected && ($item->{"line"} == -1 || $item->{"used"} == 0));
                if (!$is_selected && $item->{"used"} == 1) {
                    # if it wasn't selected but is enabled in the file, disabled this value
                    &update( $item->{"line"}, undef,
                        \@$file_arr, ( $is_selected ? 0 : 1 ) );
                }
                elsif ($item->{"val_optional"} || $in{$internalfield . "val"}) {
                    &update( $item->{"line"}, "$configfield" . ( $in{$internalfield . "val"} eq "" ? "" : "=" . $in{$internalfield . "val"}),
                        \@$file_arr, ( $is_selected ? 0 : 1 ) );
                }
                else {
                    &update( $item->{"line"}, "$configfield=" . $in{$internalfield . "val"},
                        \@$file_arr, ( $is_selected ? 0 : 1 ) );
                }
            }
        }
        &flush_file_lines();
        &update_last_config_change();
    }
}

sub apply_simple_vals {
    my ($domain, $sel, $page) = @_;
    my @page_fields_bools = ();
    my @page_fields_singles = ();
    my @domain_array = $domain eq "dns" ? @confdns : ($domain eq "dhcp" ? @confdhcp : @conft_b_p);
    foreach my $configfield ( @domain_array ) {
        next if ( grep { /^$configfield$/ } ( @confarrs ) );
        next if ( %dnsmconfigvals{"$configfield"}->{"mult"} ne "" );
        next if ( %dnsmconfigvals{"$configfield"}->{"page"} ne $page );
        if ( grep { /^$configfield$/ } ( @confbools ) ) {
            push(@page_fields_bools, $configfield);
        }
        elsif ( grep { /^$configfield$/ } ( @confsingles ) ) {
            push(@page_fields_singles, $configfield);
        }
    }

    # check user input for obvious errors
    foreach my $configfield ( @page_fields_singles ) {
        my $item = $dnsmconfig{"$configfield"};
        my $internalfield = &config_to_internal($configfield);
        if ( grep { /^$internalfield$/ } ( @{$sel} )) {
            if ( ! $item->{"val_optional"} && $in{$internalfield . "val"} eq "" ) {
                &send_to_error( $configfield, $text{"err_valreq"}, $returnto, $returnlabel );
            }
            if ( $in{$internalfield . "val"} ne "" ) {
                my $item_template = %dnsmconfigvals{"$configfield"};
                if ( $item_template->{"valtype"} eq "int" && ($in{$internalfield . "val"} !~ /^$NUMBER$/) ) {
                    &send_to_error( $configfield, $text{"err_numbad"}, $returnto, $returnlabel );
                }
                elsif ( $item_template->{"valtype"} eq "file" && ($in{$internalfield . "val"} !~ /^$FILE$/) ) {
                    &send_to_error( $configfield, $text{"err_filebad"}, $returnto, $returnlabel );
                }
                elsif ( $item_template->{"valtype"} eq "path" && ($in{$internalfield . "val"} !~ /^$FILE$/) ) {
                    &send_to_error( $configfield, $text{"err_pathbad"}, $returnto, $returnlabel );
                }
                elsif ( $item_template->{"valtype"} eq "dir" && ($in{$internalfield . "val"} !~ /^$FILE$/) ) {
                    &send_to_error( $configfield, $text{"err_pathbad"}, $returnto, $returnlabel );
                }
            }
        }
    }
    # adjust everything to what we got

    &update_booleans( \@page_fields_bools, $sel, \%dnsmconfig );

    &update_simple_vals( \@page_fields_singles, $sel, \%$dnsmconfig );
}

sub check_other_vals {
    my ($domain, $sel) = @_;
    my @vars = ();
    my @domain_array = $domain eq "dns" ? @confdns : $domain eq "dhcp" ? @confdhcp : @conft_b_p;
    foreach my $configfield ( @domain_array ) {
        next if ( grep { /^$configfield$/ } ( @confarrs ) );
        next if ( %dnsmconfigvals{"$configfield"}->{"mult"} ne "" );
        if ( grep { /^$configfield$/ } ( @confvars ) ) {
            push @vars, $configfield;
        }
    }

    # check user input for obvious errors
    foreach my $configfield ( @vars ) {
        my $item = $dnsmconfig{"$configfield"};
        my $internalfield = &config_to_internal($configfield);
        if ( grep { /^$internalfield$/ } ( @{$sel} )) {
            my @otherfields = ();
            foreach my $key ( @{ %configfield_fields{$internalfield}->{"param_order"} } ) {
                my $definition = %configfield_fields{$internalfield}->{$key};
                push ( @otherfields, $internalfield . "_" . $key );
                # if this parameter is an array, include
                if ( $definition->{"required"} && $in{$internalfield  . "_" . $key} eq "" ) {
                    &send_to_error( $configfield, $text{"err_valreq"}, $returnto, $returnlabel );
                }
                if ( $in{$internalfield . "_" . $key} ne "" ) {
                    if ( $definition->{"valtype"} eq "int" && ($in{$internalfield . "_" . $key} !~ /^$NUMBER$/) ) {
                        &send_to_error( $configfield, $text{"err_numbad"}, $returnto, $returnlabel );
                    }
                    elsif ( $definition->{"valtype"} eq "file" && ($in{$internalfield . "_" . $key} !~ /^$FILE$/) ) {
                        &send_to_error( $configfield, $text{"err_filebad"}, $returnto, $returnlabel );
                    }
                    elsif ( $definition->{"valtype"} eq "path" && ($in{$internalfield . "_" . $key} !~ /^$FILE$/) ) {
                        &send_to_error( $configfield, $text{"err_pathbad"}, $returnto, $returnlabel );
                    }
                    elsif ( $definition->{"valtype"} eq "dir" && ($in{$internalfield . "_" . $key} !~ /^$FILE$/) ) {
                        &send_to_error( $configfield, $text{"err_pathbad"}, $returnto, $returnlabel );
                    }
                }
            }
        }
    }
}

=head2 add_to_list( configfield, val )
  Adds a new entry value to the configuration
=cut
sub add_to_list {
    my ( $configfield, $val ) = @_;
    my $cfn = $config{config_file};
    if (@{$dnsmconfig{$configfield}} > 0) {
        $cfn = $dnsmconfig{$configfield}[0]->{"file"};
    }
    &save_update($cfn, -1, "$configfield=$val");
}

sub send_to_error {
    my ($line, $err_desc, $returnto, $returnlabel) = @_;
    my $line = "error.cgi?line=" . &urlize($line);
    $line .= "&type=" . &urlize($err_desc);
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

sub get_usernames_list {
    local (@users, @usernames);
    if (&foreign_available("useradmin") && defined(useradmin::list_users)) {
        &foreign_require("useradmin", "user-lib.pl");
        @users = useradmin::list_users();
        foreach my $user ( @users ) {
            push( @usernames, $user->{"user"})
        }
    }
    return @usernames;
}

sub get_groupnames_list {
    local (@groups, @groupnames);
    if (&foreign_available("useradmin") && defined(useradmin::list_groups)) {
        &foreign_require("useradmin", "user-lib.pl");
        @groups = useradmin::list_groups();
        foreach my $group ( @groups ) {
            push( @groupnames, $group->{"group"})
        }
    }
    return @groupnames;

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

sub get_basic_fields {
    my ($page_fields) = @_;
    my @basic_fields = ();
    foreach my $configfield ( @{ $page_fields } ) {
        next if ( grep { /^$configfield$/ } ( @confarrs ) );
        next if ( %dnsmconfigvals{"$configfield"}->{"mult"} ne "" );
        next if ( ( ! grep { /^$configfield$/ } ( @confbools ) ) && ( ! grep { /^$configfield$/ } ( @confsingles ) ) );
        push( @basic_fields, $configfield );
    }
    return @basic_fields;
}

sub get_other_fields {
    my ($page_fields) = @_;
    my @var_fields = ();
    my @basic_fields = &get_basic_fields($page_fields);
    foreach my $configfield ( @{ $page_fields } ) {
        next if ( grep { /^$configfield$/ } ( @confarrs ) );
        next if ( grep { /^$configfield$/ } ( @confbools ) );
        next if ( ( grep { /^$configfield$/ } ( @confsingles ) ) && %dnsmconfigvals{"$configfield"}->{"mult"} eq "" );
        next if ( grep { /^$configfield$/ } ( @basic_fields ) );
        push( @var_fields, $configfield );
    }
    return @var_fields;
}

sub string_contains {
    return (index($_[0], $_[1]) != -1);
}

sub check_for_file_errors {
    my ($returnto, $returnlabel, $dnsmconfig) = @_;
    my $error_check_result = "";
    my $error_check_action = "";
    $returnto = basename($returnto);
    # check for the executable
    if (!&find_dnsmasq()) {
        &ui_print_header(undef, $text{'index_title'}, "", undef, 1, 1);
        print &text('index_eserver', "<tt>$config{'dnsmasq_path'}</tt>",
                "@{[&get_webprefix()]}/config.cgi?$module_name"),"<p>\n";
        # &foreign_require("software", "software-lib.pl");
        # $lnk = &software::missing_install_link("dnsmasq", $text{'index_dnsmasq'},
        #         "../$module_name/", $text{'index_title'});
        # print $lnk,"<p>\n" if ($lnk);
        &ui_print_footer("/", $text{'index'});
        exit;
    }
    elsif (!&find_config_file()) {
        # config doesn't exist!
        &ui_print_header(undef, $text{'index_title'}, "", undef, 1, 1);
        print "<p>\n";
        print &text('index_econf', "<tt>$config{'config_file'}</tt>",
                "@{[&get_webprefix()]}/config.cgi?$module_name"),"<p>\n";
        &ui_print_footer("/", $text{'index'});
        exit;
    }
    if ($in{"forced_edit"} == 1) {
        if (defined($in{"sel"})) {
            my @sel = split(/\0/, $in{"sel"});
            foreach my $selid ( @sel ) {
                my $f = $in{"file_" . $selid};
                my $l = $in{"line_" . $selid};
                my $a = $in{"button_disable_sel"} ? 1 : ($in{"button_delete_sel"} ? 2 : 0);
                &save_update($f, $l, undef, $a);
            }
            $error_check_result = $redirect;
            $error_check_action = "redirect";
        }
        elsif ($in{"fix_perms"}) {
            if (!$access{"change_perms"}) {
                $error_check_result = "<div class=\"conf-error-block\">"
                            . "<h3>".$text{"error"}."</h3>"
                            . $text{"acl_change_perms_ecannot"} . "<br/><br/>"
                            . "</div>";
                $error_check_action = "warn";
            }
            else {
                my $internalfield = $in{"ifield"};
                my $configfield = &internal_to_config($internalfield);
                my $param = $in{"param"};
                my $relevant_user_name = $in{"foruser"};
                my $relevant_group_name = $in{"forgroup"};
                my $perms_failed  = $in{"perms_failed"};
                my $item;
                if ($in{"cfg_idx"} > -1) {
                    $item = $dnsmconfig->{"$configfield"}[$in{"cfg_idx"}];
                }
                else {
                    $item = $dnsmconfig->{"$configfield"};
                }
                my $val = ($param eq "val" ? $item->{"val"} : $item->{"val"}->{"$param"});
                $val = readlink($val) if (-l $val);

                &set_permissions($internalfield, $val, $perms_failed, $relevant_user_name, $relevant_group_name)
            }
        }
        elsif ($in{"bad_ifield"}) {
            $error_check_result .= "<script type='text/javascript'>\n"
                    . "\$(document).ready(function() {\n"
                    . "  setTimeout(function() {\n";
            if (defined($in{"cfg_idx"})) {
                # list item; show edit dialog modal
                $error_check_result .= "    \$(\"a[dnsm_array_idx='" . $in{"cfg_idx"} . "']\").first().trigger(\"click\");\n";
            }
            else {
                if (defined($in{"custom_error"}) && $in{"custom_error"} ne "") {
                    $error_check_result .= "    showCustomValidationFailure('" . $in{"bad_ifield"} . "_" . $in{"bad_param"} . "', '" . $in{"custom_error"} . "');\n";
                }
                $error_check_result .= "    \$(\"input[name*=" . $in{"bad_ifield"} . "_" . $in{"bad_param"} . "]\").first()[0].reportValidity();\n";
            }
            $error_check_result .= "  }, 5);\n"
                    . "});\n"
                    . "</script>\n";
            $error_check_action = "goto";
        }
    }
    elsif ( @{$dnsmconfig->{"error"}} > 0) {
        my $errorcount = @{$dnsmconfig->{"error"}};
        $error_check_result = "<div class=\"conf-error-block\">"
                            . "<h3>".$text{"configuration_error_heading"}."</h3>"
                            . &text( "err_has_errors_", $errorcount ) . "<br/><br/>"
                            . "<a href=\"error.cgi?returnto=$returnto&returnlabel=$returnlabel\" class=\"btn btn-lg btn-danger conf-error-button\">"
                            . "<i class=\"fa fa-fw fa-arrow-right\">&nbsp;</i>"
                            . "<span>" . $text{"err_goto"} . "</span></a>"
                            . "</div>";
        $error_check_action = "warn";
    }
    return ($error_check_action, $error_check_result);
}

sub set_permissions {
    my ($internalfield, $val, $perms_failed, $relevant_user_name, $relevant_group_name) = @_;
    my $fdef = $configfield_fields{$internalfield};
    my $pdef = \%{ $fdef->{"$param"} };
    my $req_perms = $pdef->{"req_perms"};

    my @tst = stat($val);
    my $target_current_mode = $tst[2]; # returns as hex value?
    my $target_uid = $tst[4];
    my $target_gid = $tst[5];
    my $existingperms = oct(sprintf("%04o", $target_current_mode & 07777)); # now it's octal; just perms (no file type)

    my ($current_user_name, undef, $relevant_user_uid, $relevant_user_gid) = getpwuid($<);
    $relevant_user_name = $current_user_name if (!$relevant_user_name);
    $relevant_group_name = getgrgid($relevant_user_gid) if (!$relevant_group_name); 
    my @relevant_user_gids;
    if ($relevant_user_name eq $current_user_name) {
        @relevant_user_gids = getgroups();
    }
    else {
        (undef, undef, $relevant_user_uid, $relevant_user_gid) = getpwnam($relevant_user_name);
        @relevant_user_gids = split(" ", @{split(":", `groups $relevant_user_name`)}[1]);
    }

    my $for_whom_multiplier = 00;
    if ($target_uid == $relevant_user_uid) {
        # user matches; perms should only change for the user
        $for_whom_multiplier = 0100;
    }
    elsif ($target_gid == $relevant_user_gid || (grep(/^$target_gid$/, @relevant_user_gids))) {
        # user doesn't match but group matches; perms should only change for the user + group
        $for_whom_multiplier = 0110;
    }
    else {
        # neither matches; perms should change for user + others
        $for_whom_multiplier = 0101;
    }
    my $newperms;
    if ($perms_failed & 1) {
        # needs execute permission
        $newperms = $existingperms | (01 * $for_whom_multiplier);
    }
    if ($perms_failed & 2) {
        # needs read permission
        $newperms = $existingperms | (02 * $for_whom_multiplier);
    }
    if ($perms_failed & 4) {
        # needs write permission
        $newperms = $existingperms | (04 * $for_whom_multiplier);
    }

    # set_ownership_permissions(user, group, perms, file, ...)
    &set_ownership_permissions(undef, undef, $newperms, $val);
}

sub get_current_version {
    my (%minfo, $version_str);
    if (read_file("module.info", \%minfo) && exists($minfo{'version'})) {
        $version_str = $minfo{'version'};
    }
    return $version_str;
}

sub check_for_updated_version {
    my ($force_check) = @_;
    return $config{"dnsmasq_latest_url"} if (!$force_check && $config{"dnsmasq_latest_url"});
    my $version_str = &get_current_version();
    return if (!$version_str);
    my @version = split(/\./, $version_str . ".0.0.0"); # add some fake extras for comparison below
    my $latest_release = get_GH_response("releases/latest");
    #-------
    # TODO this block is only necessary due to having only pre-releases in github; it should be removed
    # once a release version is published
    if ( $latest_release && $latest_release->{"message"} eq "Not Found" ) {
        my $all_releases = get_GH_response("releases");
        if (ref($all_releases) eq "ARRAY") {
            my @sorted = sort { $b->{"published_at"} <=> $a->{"published_at"} } @{ $all_releases };
            $latest_release = @sorted[0];
        }
    }
    #-------
    my $latest;
    my %tempconfig;
    &lock_file("$module_config_directory/config");
    &read_file("$module_config_directory/config", \%tempconfig);
    delete($tempconfig{"dnsmasq_latest_url"});
    if ( $latest_release && $latest_release->{"tag_name"}) {
        my $tag_name = $latest_release->{"tag_name"};
        if ( $tag_name =~ /^(v)([0-9.]*)(.*)$/ ) {
            my $latest_version_str = $2;
            my @latest_version = split(/\./, $latest_version_str . ".0.0.0");
            my $vidx = 0;
            foreach my $v ( @version ) {
                if (defined(@latest_version[$vidx]) && int(@latest_version[$vidx]) > int($v)) {
                    $latest = $tempconfig{"dnsmasq_latest_url"} = $latest_release->{"html_url"};
                    last;
                }
                elsif (defined(@latest_version[$vidx]) && int(@latest_version[$vidx]) < int($v)) {
                    last;
                }
                $vidx++;
            }
        }
    }
    &write_file("$module_config_directory/config", \%tempconfig);
    &unlock_file("$module_config_directory/config");
    &update_last_update_check_time();
    return $latest;
}

sub get_GH_response {
    eval "use HTTP::Request";
    eval "use LWP::UserAgent";
    eval "use IO::Socket::SSL qw( SSL_VERIFY_NONE )";
    eval "use JSON::PP";
    # my $ua = LWP::UserAgent->new(ssl_opts => { SSL_verify_mode => SSL_VERIFY_NONE });
    my $ua = LWP::UserAgent->new();
    my ($target) = @_;
    my $request = HTTP::Request->new("GET" => "https://api.github.com/repos/klugerama/webmin-dnsmasq/$target");
    $request->header(Content_Type => 'application/json');
    my $response = $ua->request($request);
    return decode_json($response->content);
}

sub deserialize_string {
    my ($str) = @_;
    my @v = split(/,/, $str);
    my $var = { };
    if ($v[0] eq 'HASH') {
        for(my $i=2; $i<@v; $i+=4) {
            $var->{&un_urlize($v[$i])} =
                &un_urlize($v[$i+2]);
        }
    }
    else {
        $var = &unserialize_variable($str);
    }
    return $var;
}

=head2 create_error(file, line, desc, configfield, param, cfg_idx, [custom_error], [error_type], [foruser], [forgroup])
=cut
sub create_error {
    my ($file, $line, $desc, $configfield, $param, $cfg_idx) = @_;
    my $custom_error = $_[6] ? $_[6] : 0;
    my $error_type = $_[7] ? $_[7] : undef;
    my $foruser = $_[8] ? $_[8] : undef;
    my $forgroup = $_[9] ? $_[9] : undef;
    my $perms_failed = $_[10] ? $_[10] : undef;
    return {
                "file" => $file,
                "line" => $line,
                "desc" => $desc,
                "configfield" => $configfield,
                "param" => $param,
                "cfg_idx" => defined($cfg_idx) ? $cfg_idx : -1,
                "custom_error" => $custom_error,
                "error_type" => $error_type,
                "foruser" => $foruser,
                "forgroup" => $forgroup,
                "perms_failed" => $perms_failed,
           };
}

sub header_js {
    my ($formid, $internalfield) = @_;
    my $script = "";
    # $script .= "<link href=\"dnsmasq.css\" rel=\"stylesheet\">\n";
    $script .= "<script id=\"dnsmasq_js\" type=\"text/javascript\" src=\"dnsmasq.js\"></script>\n";
    # $script .= "<script type=\"text/javascript\">\n";
    # $script .= "\$(document).ready(function() {\n";
    # $script .= "});\n";
    # $script .= "</script>\n";
    return $script;
}

=head2 add_js()
=cut
sub add_js {
    my $script = "";
    return $script;
}

1;
