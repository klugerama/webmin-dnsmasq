#!/usr/bin/perl
#
#    DNSMasq Webmin Module - option_edit.cgi; edit DHCP option
#        Copyright (C) 2023 by Loren Cress
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

my %access=&get_module_acl;

## put in ACL checks here if needed

my $config_filename = $config{config_file};
my $config_file = &read_file_lines( $config_filename );

&parse_config_file( \%dnsmconfig, \$config_file, $config_filename );

# read posted data
&ReadParse();

# &header($text{"index_title"}, "", "intro", 1, 0, 0, &restart_button());

my $idx;
my $dhcp_option;
if ($in{'new'}) {
    $idx = -1;
    # $dhcp_option = $dnsmconfig{"dhcp-option"}[$o];
    $dhcp_option{"line"} = -1;
    $dhcp_option{"file"} = $config_filename;
	&ui_print_header(undef, &text("add_", $text{"_dhcp_option"}), "", undef, undef, undef, undef, &restart_button());
}
else {
    $idx = $in{"idx"};
    $dhcp_option = $dnsmconfig{"dhcp-option"}[$idx];
    $desc = &text("dhcp_option_header", $dhcp_option->{"val"}->{"option"});
    &ui_print_header($desc, &text("edit_", $text{"_dhcp_option"}), "", undef, undef, undef, undef, &restart_button());
}
# check for errors in read config
if( $dnsmconfig{"errors"} > 0 ) {
	&header( "DNSMasq settings", "" );
	print "<hr><h2>";
	print $text{"warn_errors"};
	print $dnsmconfig{"errors"};
	print $text{"didnt_apply"};
	print "</h3><hr>\n";
	&footer( "/", $text{"index"});
	exit;
}

my @settags = ( );
if ( $dnsmconfig{"set_tags"} > 0 ) {
    foreach my $settag ( @{ $dnsmconfig{"set_tags"} } ) {
        push( @settags, $settag );
    }
}

my @iftags = ( );
if ( $dhcp_option->{"val"}->{"tag"} > 0 ) {
    foreach my $iftag ( @{ $dhcp_option->{"val"}->{"tag"} } ) {
        push( @iftags, $iftag );
    }
}

# adjust everything to what we got
#
# &header( "DNSMasq settings", "" );
# print "<h2>".&text("edit_", $text{"_dhcp_option"})."</h2>";
print &ui_form_start( "option_edit_apply.cgi", "post" );
print &ui_hidden( "idx", $idx );
# print "<br>" . $dhcp_option->{"file"} . ":" . $dhcp_option->{"line"};

print &ui_table_start( "", "", 2 );
print &ui_table_row($text{"enabled"}, &ui_radio( "enabled", ($dhcp_option->{"used"})?1:0, \@defaultoryes ));
print &ui_table_row($text{"forced"}, &ui_radio( "forced", ($dhcp_option->{"val"}->{"forced"})?1:0, \@defaultoryes ));
print &ui_table_row($text{"p_label_dhcp_option"}, &ui_textbox( "option", $dhcp_option->{"val"}->{"option"}, 20 ));
my $tag_cbs = "<div style='max-height: 100px; padding: 2px; width: fit-content; overflow: auto;'>";
foreach my $settag ( @settags ) {
    $tag_cbs .= &ui_checkbox("tag", $settag, $settag, ( grep { /^$settag$/ } ( @iftags) )) . "<br/>";
}
$tag_cbs .= "</div>";
print &ui_table_row($text{"dhcp_tag_s"}, $tag_cbs);
print &ui_table_row($text{"dhcp_encap"}, &ui_textbox( "encap", $dhcp_option->{"val"}->{"encap"}, 10 ));
print &ui_table_row($text{"dhcp_vi_encap"}, &ui_textbox( "", $dhcp_option->{"val"}->{"vi-encap"}, 10 ));
print &ui_table_row($text{"vendor"}, &ui_textbox( "vendor", $dhcp_option->{"val"}->{"vendor"}, 10 ));
print &ui_table_row($text{"value"}, &ui_textbox( "value", $dhcp_option->{"val"}->{"value"}, 80 ));
print &ui_table_end();

if ($in{'new'}) {
	print &ui_submit( $text{'create_'} );
}
else {
    print &ui_submit( $text{"save_button"}, "submit" );
    print &ui_submit( $text{"delete_button"}, "delete" );
}
print "<br>";
print &ui_form_end();
# &footer( "/", $text{"index"});
&ui_print_footer("dhcp_client_options.cgi", $text{"index_dhcp_client_options"}, "index.cgi?mode=dhcp", $text{"index_dhcp_settings"}, "index.cgi?mode=dns", $text{"index_dns_settings"});
#

# 
# sub-routines
#
### END of option_edit.cgi ###.
