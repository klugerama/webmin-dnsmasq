#!/usr/bin/perl
#
#    DNSMasq Webmin Module - restart.cgi; restart DNSmasq
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

my %access=&get_module_acl();

## put in ACL checks here if needed

my $config_filename = $config{config_file};
my $config_file = &read_file_lines( $config_filename );

&parse_config_file( \%dnsmconfig, \$config_file, $config_filename );

&ReadParse();

if ($config{'test_config'}) {
    $err = &test_config();
    &error("<pre>".&html_escape($err)."</pre>") if ($err);
}

&error_setup($text{'restart_err'});
$access{'stop'} || &error($text{'stop_ecannot'});
$access{'restart'} || &error($text{'restart_ecannot'});
$access{'start'} || &error($text{'start_ecannot'});
$err = &restart_dnsmasq();
&error($err) if ($err);
&webmin_log("restart");
&redirect($in{'returnto'});

### END of restart.cgi ###.
