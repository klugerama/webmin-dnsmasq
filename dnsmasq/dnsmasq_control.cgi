#!/usr/bin/perl
#
#    DNSMasq Webmin Module - dnsmasq_control.cgi; Stop, start, restart, reload, and dump logs
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
#    This module based on the DNSMasq Webmin module originally written by Neil Fisher

require 'dnsmasq-lib.pl';
use experimental qw( switch );

# read config file
my $config_filename = $config{config_file};
my $config_file = &read_file_lines( $config_filename );

&parse_config_file( \%dnsmconfig, \$config_file, $config_filename );

# read posted data
&ReadParse();

my $show_buttons = 1;

if ($in{"manual_check_for_update"} && $in{"manual_check_for_update"} eq "1") {
    $show_buttons = 0;
}
if ($in{"do_cmd"}) {
    my $cmd = $in{"do_cmd"};
    my @req_test_cmds = ( "start", "restart", "reload" );

    if (grep { $cmd } ( @req_test_cmds ) && $config{"test_config"}) {
        $err = &test_config();
        &error("<pre>".&html_escape($err)."</pre>") if ($err);
    }

    &error_setup($text{'$cmd_err'});
    my $err;
    $access{$cmd} || &error($text{'acl_'.$cmd.'_ecannot'});
    given ( $cmd ) {
        when ("start") {
            $err = &start_dnsmasq();
        }
        when ("stop") {
            $err = &stop_dnsmasq();
        }
        when ("restart") {
            $access{'stop'} || &error($text{'acl_stop_ecannot'});
            $access{'start'} || &error($text{'acl_start_ecannot'});
            $err = &restart_dnsmasq();
        }
        when ("reload") {
            $err = &reload_dnsmasq_files();
        }
        when ("dump_logs") {
            $err = &dump_logs();
        }
        default {

        }
    }
    &error($err) if ($err);
    &webmin_log($cmd) if $cmd;
    # &redirect($in{'returnto'});
}

my ($error_check_action, $error_check_result) = &check_for_file_errors( $0, $text{"index_dns_settings"}, \%dnsmconfig );
if ($error_check_action eq "redirect") {
    &redirect ( $error_check_result );
}

&ui_print_header(undef, $text{"index_title"}, "", "intro", 1, 0, 0, &restart_button());
print &header_style();
print $error_check_result;

if ($show_buttons == 1) {
    my $returnto = basename($0);
    my $apply_cgi = basename($0);

    my @actions = ( "start", "stop", "restart", "reload", "dump_logs" );

    my %button = ();
    foreach my $action ( @actions ) {
        %{$button{$action}} = ();
        $button->{$action}->{"enabled"} = 1;
        $button->{$action}->{"icon"} = "";
        $button->{$action}->{"btn_class_extra"} = "";
    }

    if (&is_dnsmasq_running()) {
        $button->{"stop"}->{"enabled"} = 0;
        $button->{"restart"}->{"enabled"} = 0;
        $button->{"reload"}->{"enabled"} = 0;
        $button->{"dump_logs"}->{"enabled"} = 0;
    }
    else {
        $button->{"start"}->{"enabled"} = 0;
    }
    $button->{"stop"}->{"icon"} = "fa fa-fw fa-stop";
    $button->{"stop"}->{"btn_class_extra"} = "btn-danger";
    $button->{"reload"}->{"icon"} = "fa fa-fw fa-refresh";
    $button->{"reload"}->{"btn_class_extra"} = "";
    $button->{"dump_logs"}->{"icon"} = "fa fa-fw fa-broom fa-1_25x";
    $button->{"dump_logs"}->{"btn_class_extra"} = "";

    print &ui_columns_start();
    foreach my $action ( @actions ) {
        # my $form = &ui_form_start($action . ".cgi?returnto=" . $returnto, "post");
        my $form = &ui_form_start(basename($0), "post");
        $form .= &ui_hidden("do_cmd", $action);
        $form .= &ui_submit($text{"index_button_" . $action}, $action, $button->{$action}->{"enabled"}, undef, $button->{$action}->{"icon"}, $button->{$action}->{"btn_class_extra"});
        $form .= &ui_form_end();
        my @cols = ();
        push(@cols, $form);
        push(@cols, $text{$action . "_desc"});
        print &ui_columns_row( \@cols );
    }
    print &ui_columns_end();
}

if ($config{"check_for_updates"} eq "1" || ($in{"manual_check_for_update"} && $in{"manual_check_for_update"} eq "1") ) {
    my $latest;
    my $force = ($in{"manual_check_for_update"} && $in{"manual_check_for_update"} eq "1") ? 1 
                : ($config{"check_for_updates"} eq "1" && &needs_update_check()) ? 1 
                : 0;
    $latest = &check_for_updated_version($force);
    if ($latest) {
        print "<p>" . &text("update_message", &get_current_version(), "<a href=\"" . $latest . "\" target=\"_blank\">" . $text{"click_here"} . "</a>") . "</p>";
    }
    else {
        print "<p>" . &text("current_version_message", &get_current_version()) . "</p>";
    }
    print "<p>" . $text{"gh_message"} . "</p>";
}
print &add_js();

ui_print_footer("index.cgi?tab=dns", $text{"index_dns_settings"});

### END of dnsmasq_control.cgi ###.
