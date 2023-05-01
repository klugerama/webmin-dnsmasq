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

do '../web-lib.pl';
do '../ui-lib.pl';
do 'dnsmasq-lib.pl';

$|=1;
&init_config("DNSMasq");

%access=&get_module_acl;

## put in ACL checks here if needed


## sanity checks

&header($text{"index_title"}, "", "intro", 1, 1, undef,
        "Written by Neil Fisher<BR><A HREF=mailto:neil\@magnecor.com.au>Author</A><BR><A HREF=http://www.authorpage.invalid>Home://page</A>");
# uses the index_title entry from ./lang/en or appropriate

## Insert Output code here


# output as web page

my $line=$config{restart};
&header( "DNSMasq settings", "" );
print $text{"restarting"} . "<br>"; 
print `$line`;
print "<br><hr><a href=index.cgi>";
print $text{"index_dns_settings"};
print "</a>";
&footer("/", $text{"index"});

### END of restart.cgi ###.
