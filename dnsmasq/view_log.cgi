#!/usr/local/bin/perl
#
#    DNSMasq Webmin Module - view_log.cgi; view logs
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

require './dnsmasq-lib.pl';

if (!$dnsmasq::access{"view_logs"}) {
    &ui_print_header(undef, $dnsmasq::text{'index_dns_view_log'}, "", "intro", 1, 0, 0, &restart_button());
    &error($dnsmasq::text{"acl_view_logs_ecannot"});
    &ui_print_footer("index.cgi?tab=dns", $dnsmasq::text{"index_dns_settings"});
}

# read config file
my $config_filename = $config{config_file};
my $config_file = &read_file_lines( $config_filename );

&parse_config_file( \%dnsmconfig, \$config_file, $config_filename );

&ReadParse();
&foreign_require("proc", "proc-lib.pl");

my $using_syslog = 0;

# Viewing a log file
if ($dnsmconfig{"log-facility"}->{"used"}) {
    $file = $dnsmconfig{"log-facility"}->{"val"};
    if ($file =~ /^DAEMON$/) {
        $using_syslog = 1;
        $file = "/var/log/syslog";
    }
}
else {
    $using_syslog = 1;
    $file = "/var/log/syslog";
}
print "Refresh: $config{'refresh'}\r\n"
    if ($config{'refresh'});

&ui_print_header("<tt>".&html_escape($file)."</tt>", $dnsmasq::text{'index_dns_view_log'}, "", "intro", 1, 0, 0, &restart_button());

$lines = $in{'lines'} ? int($in{'lines'}) : 100;
$filter = $in{'filter'} ? quotemeta($in{'filter'}) : "";

&filter_form();

$| = 1;
print "<pre height=\"100%\">";
local $tailcmd = $config{'tail_cmd'} || "tail -n LINES";
$tailcmd =~ s/LINES/$lines/g;
$eflag = $gconfig{'os_type'} =~ /-linux/ ? "-E" : "";
$dashflag = $gconfig{'os_type'} =~ /-linux/ ? "--" : "";
$cat = "(cat ".quotemeta($file) . ($using_syslog ? " | grep -i -a $eflag $dashflag dnsmasq" : "") . ")";
if ($filter ne "") {
    # Are we supposed to filter anything? Then use grep.
    $got = &proc::safe_process_exec(
        "$cat | grep -i -a $eflag $dashflag $filter ".
        "| $tailcmd",
        0, 0, STDOUT, undef, 1, 0, undef, 1);
} 
else {
    # Not filtering
    $got = &proc::safe_process_exec(
        "$cat | $tailcmd", 0, 0, STDOUT, undef, 1, 0, undef, 1);
}
print "<i>$dnsmasq::text{'view_empty'}</i>\n" if (!$got);
print "</pre>\n";

print qq(<script type="text/javascript">\$(document).ready(function() {viewer_init();setTimeout(function() {var target=".panel-body .fa-refresh-fi",current_refresh_timer=localStorage.getItem(v___server_hostname+"-"+"option_"+v___module+"_refresh"),current_icon_class_str=".fa-refresh-fi",refresh_timer_str=".refresh-timer-timeout",btn_str=""+target+", .panel-body "+refresh_timer_str+"",timeout_box='<span class="label label-transparent-35 label-sm margined-top-1 refresh-timer-timeout">'+(current_refresh_timer?current_refresh_timer:"0")+"&nbsp;</span>";\$.each(\$(target+":not([data-processed])").parent("button"),function(e,t){\$(this).addClass("btn-xxs btntimer").find("i").attr("data-processed",1);\$(this).wrap('<div class="btn-group'+(e===1?" dropup":"")+'"></div>');\$(this).after(""+'<button class="btn btn-warning dropdown-toggle" data-toggle="dropdown" data-original-title="" title="" aria-expanded="false">'+'<i class="fa fa-caret-down"></i>'+"</button>"+'<ul class="dropdown-menu dropdown-menu-right refresh-timer-select">'+'<li><a data-off data-timeout="0">'+theme_language("global_automatic_refresh")+": "+theme_language("global_off")+"</a></li>"+'<li class="divider"></li>'+'<li><a data-on data-timeout="2">2 '+theme_language("global_seconds")+"</a></li>"+'<li><a data-on data-timeout="5">5 '+theme_language("global_seconds")+"</a></li>"+'<li><a data-on data-timeout="15">15 '+theme_language("global_seconds")+"</a></li>"+'<li><a data-on data-timeout="30">30 '+theme_language("global_seconds")+"</a></li>"+'<li><a data-on data-timeout="60">60 '+theme_language("global_seconds")+"</a></li>"+'<li><a data-on data-timeout="120">2 '+theme_language("global_minutes")+"</a></li>"+'<li><a data-on data-timeout="300">5 '+theme_language("global_minutes")+"</a></li>"+"</ul>");if(current_refresh_timer&&current_refresh_timer!="0"){var i=\$(btn_str);\$(this).find("i").before(timeout_box);\$(this).find("i").remove();var a=current_refresh_timer;typeof refreshTimer==="number"&&clearInterval(refreshTimer);refreshTimer=setInterval(function(){--a;\$(refresh_timer_str).text(a);if(a<=0){\$(i[0]).parent().trigger("click");clearInterval(refreshTimer)}},1e3)}}).promise().done(function(){\$(".refresh-timer-select li").click(function(){typeof refreshTimer==="number"&&clearInterval(refreshTimer);var e='<i class="fa fa-fw fa-refresh-fi fa-1_25x refresh-timer-icon"></i>',t='<span class="label label-transparent-35 label-sm margined-top-1 refresh-timer-timeout">'+(current_refresh_timer?current_refresh_timer:"0")+"&nbsp;</span>";localStorage.setItem(v___server_hostname+"-"+"option_"+v___module+"_refresh",\$(this).find("a").data("timeout"));current_refresh_timer=localStorage.getItem(v___server_hostname+"-"+"option_"+v___module+"_refresh");var i=\$(btn_str),a=i.parent();if(current_refresh_timer&&current_refresh_timer!="0"){if(!a.find(refresh_timer_str).length){a.prepend(t)}a.find(refresh_timer_str).html(current_refresh_timer+"&nbsp;");\$(current_icon_class_str).remove();var n=current_refresh_timer;refreshTimer=setInterval(function(){--n;\$(refresh_timer_str).text(n);if(n<=0){var e=\$(btn_str);\$(e[0]).parent().trigger("click");clearInterval(refreshTimer)}},1e3)}else{\$(refresh_timer_str).remove();!a.find(current_icon_class_str).length&&a.prepend(e)}})});\$.each(\$('form[action*="save_log.cgi"] select[name="idx"], form[action*="view_log.cgi"] select[name="idx"]'),function(){\$(this).on("change",function(){var e=\$("button.ui_submit.ui_form_end_submit");\$(this).next().next('[name="filter"]').val("");e.first().trigger("click");e.addClass("disabled")})})},10);});</script>);
&ui_print_footer("index.cgi?tab=dns", $dnsmasq::text{"index_dns_settings"});

sub filter_form {
    print &ui_form_start("view_log.cgi");
    print &ui_hidden("view", 1),"\n";

    $sel = "<tt>".&html_escape($file)."</tt>";

    print &text('view_header', "&nbsp;" . &ui_textbox("lines", $lines, 3), $sel),"\n";
    print "&nbsp;&nbsp;&nbsp;&nbsp;\n";
    print &text('view_filter', "&nbsp;" . &ui_textbox("filter", $in{'filter'}, 25)),"\n";
    print "&nbsp;&nbsp;\n";
    print &ui_submit($dnsmasq::text{'view_refresh'});
    print &ui_form_end(),"<br>\n";
}

### END of view_log.cgi ###