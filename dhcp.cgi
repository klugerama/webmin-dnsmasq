#!/usr/bin/perl
#
#    DNSMasq Webmin Module - dhcp.cgi; DHCP config
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
#    This module inherited from the DNSMasq Webmin module by Neil Fisher

do '../web-lib.pl';
do '../ui-lib.pl';
do 'dnsmasq-lib.pl';

$|=1;
&init_config("DNSMasq");

%access=&get_module_acl;

## put in ACL checks here if needed


## sanity checks

&header($text{'index_title'}, "", "intro", 1, 1, undef,
        "Written by Neil Fisher<BR><A HREF=mailto:neil\@magnecor.com.au>Author</A><BR><A HREF=http://www.authorpage.invalid>Home://page</A>");
# uses the index_title entry from ./lang/en or appropriate

## Insert Output code here
# read config file
$config_file = &read_file_lines( $config{config_file} );
# pass into data structure


# output as web page


&header( "DNSMasq settings", "" );
&parse_config_file( \%config, \$config_file );
print "<hr>\n";
if( $config{errors} > 0 ) {
	print "<h3>WARNING: found ";
	print $config{errors};
	print "errors in config file!</h3><br>\n";
}
print "<br>\n";
print "<h2>$text{'DHCP_settings'}</h2>";
print "<br><hr><br>\n";
my $count;
my $width;
$count=0;
$width="width=33%";
print "<h2>".$text{vendor_classes}."</h2>";
print &ui_columns_start( [ $text{class},
				$text{vendor}, $text{in_use} ], 100 );
foreach my $range ( @{$config{vendor_class}} ) {
	my $edit = "<a href=vend_edit.cgi?idx=$count>".$$range{class}."</a>";
	print &ui_columns_row( [
			$edit, $$range{vendor},
			($$range{used}) ?
				$text{used} : $text{not_used} ],
			[ $width, $width, $width ] );
	$count++;
}
print &ui_columns_end();
print "<br><a href=add.cgi?what=dhcp-vendorclass=new&where=dhcp.cgi>".
		$text{vend_add}."</a><br><hr><br>";
$count=0;
$width="width=33%";
print "<h2>".$text{user_classes}."</h2>";
print &ui_columns_start( [ $text{class},
				$text{user}, $text{in_use} ], 100 );
foreach my $range ( @{$config{user_class}} ) {
	my $edit = "<a href=user_edit.cgi?idx=$count>".$$range{class}."</a>";
	print &ui_columns_row( [
			$edit, $$range{user},
			($$range{used}) ?
				$text{used} : $text{not_used} ],
			[ $width, $width, $width ] );
	$count++;
}
print &ui_columns_end();
print "<br><a href=add.cgi?what=dhcp-userclass=new&where=dhcp.cgi>".
		$text{user_add}."</a><br><hr><br>";
$count=0;
$width="20%";
print "<h2>".$text{dhcp_range}."</h2>";
print &ui_columns_start( [ $text{net_id}, $text{forced_from}, $text{forced_ip},
				$text{forced_mask}, $text{leasetime},
			        $text{in_use}	], 100 );
foreach my $range ( @{$config{dhcp_range}} ) {
	my $edit = "<a href=range_edit.cgi?idx=$count>".$$range{start}."</a>";
	print &ui_columns_row( [
			$$range{id}, $edit, $$range{end}, $$range{mask},
			$$range{leasetime}, 
			($$range{used}) ?
				$text{used} : $text{not_used} ],
			[ $width, $width, $width, $width, $width ] );
	$count++;
}
print &ui_columns_end();
print "<br><a href=add.cgi?what=dhcp-range=0.0.0.0,0.0.0.0&where=dhcp.cgi>".
		$text{range_add}."</a><br><hr><br>";
$count=0;
$width="width=50%";
print "<h2>".$text{hosts}."</h2>";
print &ui_columns_start( [ $text{hosts}, $text{in_use} ], 100 );
foreach my $range ( @{$config{dhcp_host}} ) {
	my $edit = "<a href=host_edit.cgi?idx=$count>".$$range{option}."</a>";
	print &ui_columns_row( [
			$edit,
			($$range{used}) ?
				$text{used} : $text{not_used} ],
			[ $width, $width ] );
	$count++;
}
print &ui_columns_end();
print "<br><a href=add.cgi?what=dhcp-host=new,0.0.0.0&where=dhcp.cgi>".
		$text{host_add}."</a><br><hr><br>";
$count=0;
$width="width=50%";
print "<h2>".$text{dhcp_options}."</h2>";
print &ui_columns_start( [ $text{dhcp_option}, $text{in_use} ], 100 );
foreach my $range ( @{$config{dhcp_option}} ) {
	my $edit = "<a href=option_edit.cgi?idx=$count>".$$range{option}."</a>";
	print &ui_columns_row( [
			$edit,
			($$range{used}) ?
				$text{used} : $text{not_used} ],
			[ $width, $width ] );
	$count++;
}
print &ui_columns_end();
print "<br><a href=add.cgi?what=dhcp-option=27&where=dhcp.cgi>".
	$text{dhcp_add}."</a><br><hr><br>";
print &ui_form_start( 'dhcp_apply.cgi', "get" );
print "<h2>".$text{misc}."</h2><br>";
print $text{read_ethers}.&ui_yesno_radio( "ethers", 
			($config{dhcp_ethers}{used})?1:0 );
print "<br><br>".$text{use_bootp}.&ui_yesno_radio ( "bootp",
			($config{dhcp_boot}{used})?1:0 );
print "<br>".$text{bootp_host}.&ui_textbox( "bootp_host",
			$config{dhcp_boot}{host}, 80 );
print "<br>".$text{bootp_file}.&ui_textbox( "bootp_file",
			$config{dhcp_boot}{file}, 80 );
print "<br>".$text{bootp_address}.&ui_textbox( "bootp_addr",
			$config{dhcp_boot}{address}, 80 );
print "<br><br>".$text{max_leases}.&ui_textbox( "max_leases",
			$config{dhcp_leasemax}{max}, 10 );
print "<br><br>".$text{leasefile}.&ui_yesno_radio( "useleasefile",
			($config{dhcp_leasefile}{used})?1:0 );
print "<br>".$text{lfiletouse}.&ui_textbox( "leasefile",
			$config{dhcp_leasefile}{file}, 80 );
print "<br><br>".&ui_submit( $text{'save_button'} );
print &ui_form_end( );
print "<br><hr><br><a href=\"index.cgi\">";
print $text{'DNS_settings'};
print "</a><br>";
&footer("/", $text{'index'});
# uses the index entry in /lang/en



## if subroutines are not in an extra file put them here


### END of dhcp.cgi ###.
